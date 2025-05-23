# -*- coding: utf-8 -*-

import time
from smbus import SMBus
from gevent.lock import Semaphore
import gevent

RPM6 = 60  # not_augmented
RPM62 = 62  # not_augmented
RPM7 = 70  # not_augmented
PWR_EXT_3 = 0  # PORTA.0  B0V12  7401             not_augmented
PWR_EXT_2 = 1  # PORTA.1  B1V12  GSM_TERMINAL     not_augmented
PWR_EXT_1 = 2  # PORTA.2  B0V5   USB_HUB          not_augmented
PWR_EXT_0 = 3  # PORTA.3  B1V5   SERIAL_PORT_DTR  not_augmented
RS485_SPEED_REG = 0x08  # not_augmented
RS422_SPEED_REG = 0x18  # not_augmented
_I2C_ADDR = 0x70

_i2c = SMBus(1)
_port_a_lock = Semaphore()
_port_b_lock = Semaphore()
_port_c_lock = Semaphore()
_rs485_last_tx_size = 0


def info():
    lst = _i2c.read_i2c_block_data(_I2C_ADDR, 0x80, 8)
    prog_id = lst[1] << 8 | lst[0]
    prog_ver = lst[3] << 8 | lst[2]
    ser_num = lst[7] << 24 | lst[6] << 16 | lst[5] << 8 | lst[4]
    # TODO: here i'm reading PIND without locking because this is the only usage.
    brd_id = (_i2c.read_byte_data(_I2C_ADDR, 0xCB) & 48) >> 4
    if prog_id == 0x46A5:
        if prog_ver >= 0x0304:
            if brd_id == 1:
                prog_id = RPM7
            elif brd_id == 2:
                brd_id = RPM62
            elif brd_id == 3:
                brd_id = RPM6
        else:
            brd_id = RPM6
    return prog_id, prog_ver, ser_num, brd_id


def read_watchdog():
    return _i2c.read_byte_data(_I2C_ADDR, 0x8F)


def write_watchdog(val):
    _i2c.write_byte_data(_I2C_ADDR, 0x8F, val)


def read_pwr_exts():
    with _port_a_lock:
        x = _i2c.read_byte_data(_I2C_ADDR, 0xC0)
    return [x & 8 != 0, x & 4 != 0, x & 2 != 0, x & 1 != 0]


def control_pwr_ext(idx, val):
    _control_port(_port_a_lock, 0xC0, 1 << idx, val)


def pwr_ext_all_off():
    _control_port(_port_a_lock, 0xC0, 0x0F, False)


def _read_port(lock, reg):
    with lock:
        return _i2c.read_byte_data(_I2C_ADDR, reg)


def _control_port(lock, reg, mask, is_set):
    with lock:
        x = _i2c.read_byte_data(_I2C_ADDR, reg)
        x = (x | mask) if is_set else (x & ~mask)
        _i2c.write_byte_data(_I2C_ADDR, reg, x)
        cnt = 0
        while True:
            gevent.sleep(0.001)
            y = _i2c.read_byte_data(_I2C_ADDR, reg)
            if (x & mask) == (y & mask):
                break
            cnt += 1
            if cnt > 33:
                raise Exception('failed')


def read_inputs():
    b = _i2c.read_byte_data(_I2C_ADDR, 0xCE)
    return [b & 1 == 0, b & 2 == 0, b & 4 == 0]


def read_sensors():
    lst = _i2c.read_i2c_block_data(_I2C_ADDR, 0xF0, 16)
    return [(lst[i * 2 + 1] << 2) | (lst[i * 2] >> 6) for i in range(8)]


def read_relays():
    b = _read_port(_port_c_lock, 0xC2)
    return [b & 1 != 0, b & 2 != 0, b & 4 != 0, b & 8 != 0]


def control_relay(idx, val):
    _control_port(_port_c_lock, 0xC2, 1 << idx, val)


def control_user_led(val):
    _control_port(_port_c_lock, 0xC2, 1 << 4, not val)


def control_wg_led(val):
    _control_port(_port_c_lock, 0xC2, 1 << 6, val)


def control_beep_minus(val):
    _control_port(_port_b_lock, 0xC1, 1 << 5, val)


def control_beep_plus(val):
    _control_port(_port_b_lock, 0xC1, 1 << 6, val)


def read_sw_0_and_1():
    b = _i2c.read_byte_data(_I2C_ADDR, 0xC6)
    return (b & (1 << 3)) != 0, (b & (1 << 4)) != 0


def read_sb_1():
    b = _i2c.read_byte_data(_I2C_ADDR, 0xC1)
    return (b & (1 << 4)) != 0


# def reset_self():
#     _control_port(_port_c_lock, 0xC2, 1 << 7, True)


def read_wiegand():
    b = _i2c.read_byte_data(_I2C_ADDR, 0x90)
    if b & 0x7F:
        lst = _i2c.read_i2c_block_data(_I2C_ADDR, 0x92, 6)
        _i2c.write_byte_data(_I2C_ADDR, 0x90, 1)
        return (lst[5] << 40) | (lst[4] << 32) | (lst[3] << 24) | (lst[2] << 16) | (lst[1] << 8) | lst[0]
    else:
        return -1


def _baud_to_usart(val):
    if val == 19200: return 0x0017
    if val == 115200: return 0x0003
    if val == 9600: return 0x002F
    if val == 2400: return 0x00BF
    if val == 4800: return 0x005F
    if val == 38400: return 0x000B
    if val == 57600: return 0x0007
    if val == 1200: return 0x017F
    raise Exception('unsupported baud rate')


def _usart_to_baud(val):
    if val == 0x0017: return 19200
    if val == 0x0003: return 115200
    if val == 0x002F: return 9600
    if val == 0x00BF: return 2400
    if val == 0x005F: return 4800
    if val == 0x000B: return 38400
    if val == 0x0007: return 57600
    if val == 0x017F: return 1200
    raise Exception('invalid baud rate')


def usart_read_speed(reg):
    lst = _i2c.read_i2c_block_data(_I2C_ADDR, reg, 2)
    return _usart_to_baud(lst[1] << 8 | lst[0])


def usart_write_speed(reg, val):
    val = _baud_to_usart(val)
    lst = [val & 0xFF, val >> 8]
    _i2c.write_i2c_block_data(_I2C_ADDR, reg, lst)


def _usart_read(rx_avail_reg, rx_reg, size, timeout, is_raise):
    # may return more then size
    start = None
    avail = 0
    while True:
        avail = _i2c.read_byte_data(_I2C_ADDR, rx_avail_reg)
        if avail >= size:
            break
        if start is None:
            start = time.time()
        elif (time.time() - start) > timeout:
            if is_raise:
                raise Exception('response timeout')
            else:
                break
        gevent.sleep(0.001)
    r = []
    done = 0
    while done < avail:
        n = min(32, avail - done)
        r += _i2c.read_i2c_block_data(_I2C_ADDR, rx_reg, n)
        done += n
    return r


def _write_i2c_block_data(addr, data):
    data_len = len(data)
    done = 0
    while done < data_len:
        n = min(32, data_len - done)
        _i2c.write_i2c_block_data(_I2C_ADDR, addr, data[done:done+n])
        done += n


def _rs485_write(data):
    global _rs485_last_tx_size
    _write_i2c_block_data(0, data)
    n = len(data)
    if _rs485_last_tx_size != n:
        _i2c.write_byte_data(_I2C_ADDR, 0x0F, n)
        _rs485_last_tx_size = n


def rs485_write(data):
    _rs485_write(data)


def rs485_read_some(size, timeout):
    return _usart_read(0x10, 0x11, size, timeout, False)


def rs485_read(size, timeout):
    return _usart_read(0x10, 0x11, size, timeout, True)


def rs422_read_some(size, timeout):
    return _usart_read(0x10, 0x11, size, timeout, False)


def rs422_read(size, timeout):
    return _usart_read(0x10, 0x11, size, timeout, True)


def rs422_write(data):
    _write_i2c_block_data(0x10, data)


def _modbus_crc(data, size):
    polynom = 0xA001
    crc = 0xFFFF
    for i in range(size):
        crc ^= data[i]
        for j in range(8):
            carry_bit = crc & 1
            crc >>= 1
            if carry_bit != 0:
                crc ^= polynom
    return crc


def modbus_read(slave, func, abs_addr, size, timeout):
    data = [slave, func, abs_addr >> 8, abs_addr & 0xFF, 0, size, 0, 0]
    crc = _modbus_crc(data, 6)
    data[6] = crc & 0xFF
    data[7] = crc >> 8
    _rs485_write(data)
    del data[:]
    data += _usart_read(0, 0x01, 5, timeout, True)
    if len(data) < 5:
        raise IOError('response too short')
    if data[1] & 0x80:
        crc = (data[4] << 8) | data[3]
        if _modbus_crc(data, 3) != crc:
            raise IOError('crc not match')
        raise IOError('error {0:02x}{1:02x}'.format(data[1], data[2]))
    bytes_size = size * 2
    n = bytes_size + 5 - len(data)
    if n > 0:
        data += _usart_read(0, 0x01, n, timeout, True)
    n = bytes_size + 3
    crc = (data[n + 1] << 8) | data[n]
    if _modbus_crc(data, n) != crc:
        raise IOError('crc not match')
    return [data[i] << 8 | (data[i + 1] & 0xFF) for i in range(3, n, 2)]


def modbus_write(slave, func, abs_addr, val, timeout):
    data = [slave, func, abs_addr >> 8, abs_addr & 0xFF, val >> 8, val & 0xFF, 0, 0]
    crc = _modbus_crc(data, 6)
    data[6] = crc & 0xFF
    data[7] = crc >> 8
    _rs485_write(data)
    data = _usart_read(0, 0x01, 8, timeout, True)
    if len(data) < 8:
        raise IOError('response too short')
    crc = (data[7] << 8) | data[6]
    if _modbus_crc(data, 6) != crc:
        raise IOError('crc not match')


def modbus_flush():
    while True:
        data = _usart_read(0, 0x01, 32, 0.001, False)
        if len(data) == 0:
            break