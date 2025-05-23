# -*- coding: utf-8 -*-

import importlib
from gevent.lock import Semaphore
import gevent


MEM_PAGE_SIZE = 256
MEM_TYPE_RAM = 1
MEM_TYPE_EEPROM = 3
MEM_OP_OFF = 1
MEM_OP_RD = 2
MEM_OP_WR = 3
KEY_SIZE = 8


def from_bcd(b):
    return (b >> 4) * 10 + (b & 0x0F)


def to_bcd(b):
    x = b // 10
    return (x << 4) + (b - (x * 10))


def secs_to_relay_duration(secs):
    v = int(secs * 1000)
    return (v * 4) // 1000 if v != 0 else 0


class _MemInfo(object):
    def __init__(self, data):
        self.blocks_in_pages = data[1]
        b = data[2]
        self.blocks = b if b != 0 else 256
        b = data[9]
        self.wr_buf_size = b if b != 0 else 256
        b = data[10]
        self.rd_buf_size = b if b != 0 else 256
        self.first_unsorted_key_block = data[11]
        self.unsorted_key_blocks = data[12]
        self.block_size = self.blocks_in_pages * MEM_PAGE_SIZE

    def bufs_per_block(self, buf_size):
        return self.block_size // buf_size

    @staticmethod
    def bank(offset):
        return offset // 65536


class _UnsortedKeysInfo(object):
    def __init__(self, mi):
        self.offset_beg = mi.first_unsorted_key_block * mi.blocks_in_pages * MEM_PAGE_SIZE
        self.keys_per_block = mi.block_size // KEY_SIZE - 1


class PrettyPrintable(object):
    def __str__(self):
        lst = []
        for k, v in self.__dict__.items():
            lst.append('{}: {}'.format(k, v))
        return '{}({})'.format(self.__class__.__name__, ', '.join(lst))


class DateTime(PrettyPrintable):
    def __init__(self):
        self.year = 0
        self.month = 0
        self.day = 0
        self.hour = 0
        self.minute = 0
        self.second = 0


class Event(PrettyPrintable):
    def __init__(self, data):
        flags = data[1]
        flags2 = data[12]
        self.addr = data[0]
        self.no = (data[9] << 8) | data[8]
        self.is_last = (flags & 0x80) == 0
        self.is_complex = (flags2 & 0x80) == 0
        b = (data[11] << 8) | data[10]
        dt = DateTime()
        dt.year = (b & 0b0111111000000000) >> 9
        dt.month = (b & 0b0000000111100000) >> 5
        dt.day = b & 0b0000000000011111
        dt.hour = from_bcd(data[15])
        dt.minute = from_bcd(data[14])
        dt.second = from_bcd(data[13])
        self.dt = dt


class EventPort(Event):
    def __init__(self, data):
        super(EventPort, self).__init__(data)
        self.port = ((data[1] & 0b01110000) >> 4) + 1


class EventDoor(EventPort):
    def __init__(self, data, is_open):
        super(EventDoor, self).__init__(data)
        self.is_open = is_open


class EventButton(EventPort):
    def __init__(self, data, is_open):
        super(EventButton, self).__init__(data)
        self.is_open = is_open


class EventKey(EventPort):
    def __init__(self, data, is_open):
        super(EventKey, self).__init__(data)
        self.is_open = is_open
        self.code = _data_to_int(data[2:2+6])
        flags2 = data[12]
        self.is_key_search_done = (flags2 & 1) == 0  # был произведен поиск в базе ключей
        self.is_key_found = (flags2 & 3) == 0  # ключ в БК найден
        self.is_access_granted = (flags2 & 7) == 0  # доступ по этому каналу разрешен
        self.is_time_restrict_done = (flags2 & 15) == 0  # была попытка применить временные ограничения
        self.is_time_restrict = (flags2 & 31) == 16  # допуск по временным ограничениям есть


def _make_cmd_88_or_89(addr, op, v1, v2, v3):
    return bytearray([0x16, op, addr, to_bcd(v1), to_bcd(v2), to_bcd(v3)])


def _make_event(data):
    b = data[1] & 0x0F
    if b == 0b0011:
        return EventDoor(data, True)
    elif b == 0b1011:
        return EventDoor(data, False)
    elif b & 0b111 == 0b100:
        return EventButton(data, False)
    elif b & 0b111 == 0b101:
        return EventButton(data, True)
    elif b & 0b111 == 0b110:
        return EventKey(data, False)
    elif b & 0b111 == 0b111:
        return EventKey(data, True)


def _to_key(data):
    key = Key()
    key.code = _data_to_int(data[:6])
    b = data[6]
    for i in range(0, KEY_SIZE):
        if b & (1 << i):
            key.mask.append(i + 1)
        else:
            key.mask.append(0)
    b = data[7]
    key.pers_cat = (b & 0x0F) + 1
    key.suppress_door_event = (b & (1 << 5)) != 0
    key.open_always = (b & (1 << 6)) != 0
    key.is_silent = (b & (1 << 7)) != 0
    return key


def _from_key(key):
    data = _int_to_data(key.code, 6)
    mask = 0
    for b in key.mask:
        if b != 0:
            mask |= 1 << (b - 1)
    assert mask != 0
    data.append(mask)
    flags = key.pers_cat - 1
    if key.suppress_door_event:
        flags |= 1 << 5
    if key.open_always:
        flags |= 1 << 6
    if key.is_silent:
        flags |= 1 << 7
    data.append(flags)
    return data


class Key(PrettyPrintable):
    def __init__(self):
        self.code = 0
        self.mask = []
        self.pers_cat = 0
        self.suppress_door_event = False
        self.open_always = False
        self.is_silent = False


class ErrorACS(Exception):
    def __init__(self, *args, **kwargs):
        super(ErrorACS, self).__init__(*args, **kwargs)


class ErrorNoResponse(ErrorACS):
    def __init__(self, response_timeout):
        super(ErrorNoResponse, self).__init__('no response in {}'.format(response_timeout))


class ErrorResponse(ErrorACS):
    def __init__(self, msg):
        super(ErrorResponse, self).__init__(msg)


def _raise_busy():
    raise ErrorResponse('busy')


def _raise_check_sum():
    raise ErrorResponse('check sum not match')


def _raise_failed(code=None):
    if code is not None:
        raise ErrorResponse('failed 0x{:02X}'.format(code))
    raise ErrorResponse('failed')


def _raise_unexpected_response():
    raise ErrorResponse('unexpected response')


def _ensure_check_sum_match(data):
    cs = check_sum(data[:-1])
    if cs != data[len(data) - 1]:
        _raise_check_sum()


def _data_to_int(data):
    r = 0
    for i, b in enumerate(data):
        r |= b << (8 * i)
    return r


def _int_to_data(val, n):
    return bytearray([(val >> (i * 8)) & 0xFF for i in range(0, n)])


def check_sum(data):
    r = 0
    for b in data:
        r = (r + b) & 0xFF
    return r


class Channel(object):
    def __init__(self, response_timeout):
        self._lock = Semaphore()
        self.response_timeout = response_timeout

    def flush_input(self):
        pass

    def _read_some(self, size):
        pass

    def _read(self, size):
        assert size > 0
        r = bytearray()
        while True:
            r += self._read_some(size - len(r))
            if len(r) >= size:
                break
        return r

    def _read_until(self, size, *any_of):
        assert size > 0
        r = bytearray()
        n = size
        while True:
            r += self._read_some(n)
            found = False
            for i, b in enumerate(r):
                if b in any_of:
                    found = True
                    del r[:i]
                    break
            n = size - len(r)
            if n < 1:
                if found:
                    break
                _raise_unexpected_response()
        return r

    def _write(self, data):
        pass

    def prog_id(self, addr):
        q = bytearray([0x16, 0x20, addr])
        with self._lock:
            self._write(q)
            r = self._read_some(1)
        return r[0]

    def find_addrs(self):
        r = []
        q = bytearray([0x16, 0x20, 0])
        for addr in range(0, 255):
            q[2] = addr
            with self._lock:
                self._write(q)
                try:
                    self._read_some(1)
                    r.append(addr)
                except ErrorNoResponse:
                    pass
        return r

    def prog_ver(self, addr):
        r = self._cmd_4c(addr, 0x10)
        return r[1], r[0]

    def ser_num(self, addr):
        r = self._cmd_4c(addr, 0x20)
        return _data_to_int(r[:4])

    def restart_prog(self, addr):
        q = bytearray([0x16, 0x23, addr])
        with self._lock:
            self._write(q)

    def set_dt(self, addr, dt):
        with self._lock:
            self._write(_make_cmd_88_or_89(addr, 0xA9, dt.day, dt.month, dt.year))
            self._write(_make_cmd_88_or_89(addr, 0xA8, dt.second, dt.minute, dt.hour))

    def get_dt(self, addr):
        r = self._cmd_4e(addr)
        dt = DateTime()
        dt.year = from_bcd(r[5])
        dt.month = from_bcd(r[4])
        dt.day = from_bcd(r[3])
        dt.hour = from_bcd(r[2])
        dt.minute = from_bcd(r[1])
        dt.second = from_bcd(r[0])
        return dt

    def events_info(self, addr):
        return self._events_or_keys_info(addr, 1)

    def keys_info(self, addr):
        return self._events_or_keys_info(addr, 8)

    def del_all_events(self, addr):
        self._del_all_keys_or_events(addr, 0x80)

    def get_event(self, addr, is_complex):
        q = bytearray([0x16, 0x2B if is_complex else 0x3B, addr])
        with self._lock:
            self._write(q)
            r = self._read_until(3, addr)
            if r[1] == 0 and r[2] == addr:
                return
            if r[1] == 0 and r[2] == ~addr & 0xFF:
                _raise_busy()
            n = 17 - len(r)
            if n > 0:
                r += self._read(n)
        del r[17:]
        _ensure_check_sum_match(r)
        return _make_event(r)

    def find_key(self, addr, code):
        q = _int_to_data(code, 6)
        r = self._cmd_c4(addr, 2, q)
        if len(r) == KEY_SIZE:
            key = _to_key(r)
            return key

    def add_key(self, addr, key):
        q = _from_key(key)
        self._cmd_c4(addr, 1, q)

    def _del_all_keys_or_events(self, addr, op):
        ser_num = self.ser_num(addr)
        data = bytearray([op, addr])
        data += _int_to_data(ser_num, 4)
        r = self._cmd_c4(addr, op, data)[0]
        if r != 0:
            _raise_failed()

    def _events_or_keys_info(self, addr, op):
        r = self._cmd_4c(addr, op)
        dim = r[0]
        capacity = _data_to_int(r[1:dim+1])
        count = _data_to_int(r[1+dim:1+dim+dim])
        return capacity, count

    def del_key(self, addr, code):
        r = self._cmd_c4(addr, 0, _int_to_data(code, 6))[0]
        if r == 0x80:
            _raise_failed()

    def del_all_keys(self, addr):
        self._del_all_keys_or_events(addr, 0x81)

    def read_all_keys(self, addr):
        keys = []
        ki = self.keys_info(addr)
        if ki[1] == 0:
            return keys
        mi = self._cmd_0d(addr)
        uki = _UnsortedKeysInfo(mi)
        recs_per_buf = mi.rd_buf_size // KEY_SIZE
        bufs_per_block = mi.bufs_per_block(mi.rd_buf_size)
        offset = uki.offset_beg
        mem_bank = mi.bank(offset)
        self._cmd_84(addr, MEM_TYPE_RAM, mem_bank, MEM_OP_RD, 0)
        for block_idx in range(0, mi.unsorted_key_blocks):
            for buf_idx in range(0, bufs_per_block):
                buf, mem_bank, offset = self._read_from_ram(addr, mem_bank, mi, offset)
                start = 0
                if buf_idx == 0:
                    rec_num = buf[7] if buf.startswith('DALLAS') != -1 else 0
                    if rec_num == 0:
                        _raise_failed()
                    start = 1
                for i in range(start, recs_per_buf):
                    n = i * KEY_SIZE
                    key_data = buf[n:n + KEY_SIZE]
                    if key_data != bytearray([0xFF]*8):
                        keys.append(_to_key(key_data))
                        if len(keys) == ki[1]:
                            return keys
        _raise_failed()

    def write_all_keys(self, addr, keys):
        ki = self.keys_info(addr)
        assert len(keys) <= ki[0]
        self.del_all_keys(addr)
        if len(keys) == 0:
            return
        mi = self._cmd_0d(addr)
        uki = _UnsortedKeysInfo(mi)
        recs_per_buf = mi.wr_buf_size // KEY_SIZE
        bufs_per_block = mi.bufs_per_block(mi.wr_buf_size)
        offset = uki.offset_beg
        mem_bank = mi.bank(offset)
        tail = bytearray([0xFF] * mi.wr_buf_size)
        data = bytearray()
        block_idx = 0
        keys_done = 0
        self._cmd_84(addr, MEM_TYPE_RAM, mem_bank, MEM_OP_WR, 0)
        while keys_done != len(keys):
            for buf_idx in range(0, bufs_per_block):
                if keys_done != len(keys):
                    n = min(recs_per_buf, len(keys) - keys_done)
                    if buf_idx == 0:
                        if n == recs_per_buf:
                            n -= 1
                        data += 'DALLAS'
                        data.append(0)
                        rec_num = min(uki.keys_per_block, len(keys) - keys_done)
                        data.append(rec_num)
                    for i in range(keys_done, keys_done + n):
                        data += _from_key(keys[i])
                    if len(data) < mi.wr_buf_size:
                        data += bytearray(tail[:mi.wr_buf_size - len(data)])
                    mem_bank, offset = self._write_to_ram(addr, mem_bank, mi, offset, data)
                    del data[:]
                    keys_done += n
                else:
                    mem_bank, offset = self._write_to_ram(addr, mem_bank, mi, offset, tail)
            block_idx += 1
        self.restart_prog(addr)
        gevent.sleep(1)

    def _write_to_ram(self, addr, mem_bank, mi, offset, data):
        if mem_bank != mi.bank(offset):
            self._cmd_84(addr, MEM_TYPE_RAM, mem_bank, MEM_OP_OFF, 0)
            mem_bank = mi.bank(offset)
            self._cmd_84(addr, MEM_TYPE_RAM, mem_bank, MEM_OP_WR, 0)
        self._cmd_dx(addr, mi.bank(offset), offset, data)
        offset += mi.wr_buf_size
        return mem_bank, offset

    def _read_from_ram(self, addr, mem_bank, mi, offset):
        if mem_bank != mi.bank(offset):
            self._cmd_84(addr, MEM_TYPE_RAM, mem_bank, MEM_OP_OFF, 0)
            mem_bank = mi.bank(offset)
            self._cmd_84(addr, MEM_TYPE_RAM, mem_bank, MEM_OP_RD, 0)
        buf = self._cmd_9x(addr, mi.bank(offset), offset, mi.rd_buf_size)
        offset += mi.rd_buf_size
        return buf, mem_bank, offset


    def relay_on(self, addr, port, secs, suppress_door_event=False, save_duration=True):
        assert 1 <= port <= 8
        b = port - 1
        if suppress_door_event:
            b |= 1 << 7
        if save_duration:
            b |= 1 << 6
        q = bytearray([addr, b, secs_to_relay_duration(secs)])
        self._cmd_c4(addr, 0x11, q)

    def relay_off(self, addr, port):
        assert 1 <= port <= 8
        b = 1 << (port - 1)
        q = bytearray([addr, b])
        self._cmd_c4(addr, 0x10, q)

    def _ensure_responded(self, response):
        if len(response) == 0:
            raise ErrorNoResponse(self.response_timeout)

    def _cmd_84(self, addr, mem_type, mem_bank, op, ops_num):
        assert 0 <= ops_num <= 15
        b = mem_type << 4
        if op == MEM_OP_WR:
            b |= 128
        b |= ops_num
        q = bytearray([0x16, 0xA4, addr, b, mem_bank])
        q.append(check_sum(q[3:3+2]))
        with self._lock:
            self._write(q)
            r = self._read_until(2, addr, 0x16)
            if r[0] == 0x16 and r[1] == 0x15:
                _raise_check_sum()
            if len(r) < 3:
                r += self._read_some(1)
            if r[0] == addr and r[1] == 0 and r[2] == ~addr & 0xFF:
                _raise_busy()
            pack_len = r[1] - 1
            n = 2 + pack_len + 1 - len(r)
            if n > 0:
                r += self._read(n)
        del r[2 + pack_len + 1:]
        _ensure_check_sum_match(r)
        if pack_len != 3:
            _raise_unexpected_response()
        if r[2] & (1 << 7) != 0:
            _raise_failed(r[0] & 0b1111)

    def _cmd_9x(self, addr, mem_bank, offset, size):
        q = bytearray([0x16, 0xB0 | mem_bank, addr, offset & 0xFF, (offset >> 8) & 0xFF, size])
        with self._lock:
            self._write(q)
            r = self._read_until(2, 0x16)
            b = r[1]
            if b == 4 or b == 0x18:
                _raise_failed(b)
            if len(r) < 5:
                r += self._read(5 - len(r))
            pack_len = r[4]
            n = 5 + pack_len + 1 - len(r)
            if n > 0:
                r += self._read(n)
        _ensure_check_sum_match(r[5:5+pack_len+1])
        return r[5:5+pack_len]

    def _cmd_dx(self, addr, mem_bank, offset, data):
        q = bytearray([0x16, 0xF0 | mem_bank, addr, offset & 0xFF, (offset >> 8) & 0xFF, len(data)])
        q += data
        q.append(check_sum(data))
        with self._lock:
            self._write(q)
            r = self._read_until(2, 0x16)
        b = r[1]
        if b == 0x15 or b == 0x1B or b == 4 or b == 0x18:
            _raise_failed(r[1])
        if b != 6:
            _raise_failed()

    def _cmd_4c(self, addr, op):
        q = bytearray([0x16, 0x6C, addr, op])
        with self._lock:
            self._write(q)
            r = self._read_until(3, addr)
            if r[1] == 0 and r[2] == ~addr & 0xFF:
                _raise_busy()
            pack_len = r[1] - 1
            n = 2 + pack_len + 1 - len(r)
            if n > 0:
                r += self._read(n)
        del r[2 + pack_len + 1:]
        _ensure_check_sum_match(r)
        if pack_len == 1 and r[2] == 0xFF:
            raise ErrorResponse('unsupported operation')
        return r[2:2+pack_len]

    def _cmd_c4(self, addr, op, data):
        q = bytearray([0x16, 0xE4, addr, op, 0, len(data)])
        q += data
        q.append(check_sum(data))
        with self._lock:
            self._write(q)
            r = self._read_until(2, addr, 0x16)
            if r[0] == 0x16 and r[1] == 0x15:
                _raise_check_sum()
            if len(r) < 3:
                r += self._read_some(1)
            if r[0] == addr and r[1] == 0 and r[2] == ~addr & 0xFF:
                _raise_busy()
            pack_len = r[1] - 1
            if pack_len == 1:
                if r[2] == 0xFF:
                    raise ErrorResponse('invalid param')
                elif r[2] == 0xFE:
                    raise ErrorResponse('invalid pack len')
            n = 2 + pack_len + 1 - len(r)
            if n > 0:
                r += self._read(n)
        del r[2 + pack_len + 1:]
        _ensure_check_sum_match(r)
        return r[2:2 + pack_len]

    def _cmd_0d(self, addr):
        q = bytearray([0x16, 0x2D, addr])
        with self._lock:
            self._write(q)
            r = self._read_until(3, addr)
            if r[1] == 0 and r[2] == ~addr & 0xFF:
                _raise_busy()
            pack_len = r[1] - 1
            n = 2 + pack_len + 1 - len(r)
            if n > 0:
                r += self._read(n)
        del r[2 + pack_len + 1:]
        _ensure_check_sum_match(r)
        return _MemInfo(r[2:2 + pack_len])

    def _cmd_4e(self, addr):
        q = bytearray([0x16, 0x6E, addr, 0b1110111])
        with self._lock:
            self._write(q)
            r = self._read_until(3, addr)
            if r[1] == 0 and r[2] == ~addr & 0xFF:
                _raise_busy()
            pack_len = r[1] - 1
            if pack_len != 6:
                _raise_unexpected_response()
            n = 2 + pack_len + 1 - len(r)
            if n > 0:
                r += self._read(n)
        del r[2 + pack_len + 1:]
        _ensure_check_sum_match(r)
        return r[2:]


class ChannelRS232(Channel):
    def __init__(self, port, baudrate=19200, response_timeout=0.04):
        super(ChannelRS232, self).__init__(response_timeout)
        globals()['serial'] = importlib.import_module('serial')
        globals()['gevent.monkey'] = importlib.import_module('gevent.monkey')
        if 'select' not in gevent.monkey.saved:
            gevent.monkey.patch_select()
        self._port = serial.Serial(port=port, baudrate=baudrate, timeout=response_timeout)

    def flush_input(self):
        self._port.flushInput()

    def _read_some(self, size):
        assert size > 0
        r = self._port.read(size)
        self._ensure_responded(r)
        return bytearray(r)

    def _write(self, data):
        self._port.write(data)


class ChannelRS422(Channel):
    def __init__(self, baudrate=19200, response_timeout=0.1):
        super(ChannelRS422, self).__init__(response_timeout)
        globals()['cmk'] = importlib.import_module('libtsscmk')
        cmk.usart_write_speed(cmk.RS422_SPEED_REG, baudrate)

    def flush_input(self):
        cmk.rs422_read_some(256, self.response_timeout)

    def _read_some(self, size):
        assert size > 0
        r = cmk.rs422_read_some(size, self.response_timeout)
        self._ensure_responded(r)
        return bytearray(r)

    def _write(self, data):
        cmk.rs422_write([b for b in data])


class ChannelTCP(Channel):
    def __init__(self, host, port=5086, response_timeout=0.05):
        super(ChannelTCP, self).__init__(response_timeout)
        globals()['gevent.socket'] = importlib.import_module('gevent.socket')
        self._socket = gevent.socket.socket(gevent.socket.AF_INET, gevent.socket.SOCK_STREAM)
        self._socket.settimeout(response_timeout)
        self._socket.connect((host, port))

    def flush_input(self):
        try:
            self._socket.recv(256)
        except gevent.socket.timeout:
            pass

    def _read_some(self, size):
        assert size > 0
        try:
            r = self._socket.recv(size)
            if len(r) == 0:
                self._socket.close()
                raise IOError('disconnected')
            return bytearray(r)
        except gevent.socket.timeout:
            raise ErrorNoResponse(self.response_timeout)

    def _write(self, data):
        self._socket.sendall(data)
