#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
import zerorpc
from gevent.lock import Semaphore
import gevent
import libtsscmk as cmk


class Dali(object):
    MASTER_HW_TYPE = 0xDA51
    RAND_ADDR_MAX = 16777216
    SHORT_ADDR_MAX = 64
    CMD_DELAY = 0.06
    RESPONSE_TIMEOUT = 0.05
    _sync = Semaphore()

    @classmethod
    def ping_master(cls, master):
        try:
            with cls._sync:
                v = cmk.modbus_read(master, 4, 1000, 1, cls.RESPONSE_TIMEOUT)[0]
        except Exception:
            v = 0
        return v == cls.MASTER_HW_TYPE

    @classmethod
    def ping_slaves(cls, master):
        try:
            with cls._sync:
                res = cls._request(master, 0xFF, 0x90)
        except Exception:
            res = False
        return res

    @classmethod
    def gen_addrs(cls, master, start_addr=0, quantity=SHORT_ADDR_MAX):
        res = []
        with cls._sync:
            cls._write_twice(master, 0xA5, 0)
            cls._write_twice(master, 0xA7, 0)
            first = 0
            last = cls.RAND_ADDR_MAX
            cnt = 0
            while (len(res) < quantity) and (first < last) and (start_addr < cls.SHORT_ADDR_MAX):
                mid = first + (last - first) // 2
                cnt += 1
                cls._write(master, 0xB1, (mid & 0xFF0000) >> 16)
                cls._write(master, 0xB3, (mid & 0xFF00) >> 8)
                cls._write(master, 0xB5, mid & 0xFF)
                if cls._request(master, 0xA9, 0):
                    if cls._request(master, 0xBB, 0):
                        cls._write(master, 0xB7, start_addr << 1 | 1)
                        res.append(start_addr)
                        start_addr += 1
                        cls._write(master, 0xAB, 0)
                        last = cls.RAND_ADDR_MAX
                    else:
                        last = mid
                else:
                    first = mid + 1
            cls._write(master, 0xA1, 0)
        return res

    @classmethod
    def arc_power(cls, master, addr, level):
        with cls._sync:
            cls._write(master, addr << 1, level)

    @classmethod
    def group_arc_power(cls, master, group, level):
        with cls._sync:
            cls._write(master, 0x80 | group << 1, level)

    @classmethod
    def add_to_group(cls, master, addr, group):
        with cls._sync:
            cls._write_twice(master, addr << 1 | 1, 96 | group)

    @classmethod
    def remove_from_group(cls, master, addr, group):
        with cls._sync:
            cls._write_twice(master, addr << 1 | 1, 112 | group)

    @classmethod
    def remove_from_all_groups(cls, master, addr):
        with cls._sync:
            for group in range(16):
                cls._write_twice(master, addr << 1 | 1, 112 | group)

    @classmethod
    def power_on_level(cls, master, group, level):
        with cls._sync:
            cls._download_to_dtr(master, level)
            cls._write_twice(master, 0x81 | group << 1, 0x2D)

    @classmethod
    def min_level(cls, master, group, level):
        with cls._sync:
            cls._download_to_dtr(master, level)
            cls._write_twice(master, 0x81 | group << 1, 0x2B)

    @classmethod
    def max_level(cls, master, group, level):
        with cls._sync:
            cls._download_to_dtr(master, level)
            cls._write_twice(master, 0x81 | group << 1, 0x2A)

    @classmethod
    def fade_time(cls, master, group, fade_time):
        with cls._sync:
            cls._download_to_dtr(master, fade_time)
            cls._write_twice(master, 0x81 | group << 1, 0x2E)

    @classmethod
    def fade_rate(cls, master, group, fade_rate):
        with cls._sync:
            cls._download_to_dtr(master, fade_rate)
            cls._write_twice(master, 0x81 | group << 1, 0x2F)

    @classmethod
    def _write(cls, master, hi, lo):
        cmk.modbus_write(master, 6, 2003, hi << 8 | lo, cls.RESPONSE_TIMEOUT)
        gevent.sleep(cls.CMD_DELAY)

    @classmethod
    def _write_twice(cls, master, hi, lo):
        cmk.modbus_write(master, 6, 2003, hi << 8 | lo, cls.RESPONSE_TIMEOUT)
        cls._write(master, hi, lo)

    @classmethod
    def _read(cls, master):
        val = cmk.modbus_read(master, 4, 1007, 1, cls.RESPONSE_TIMEOUT)[0]
        return (val & 256) != 0

    @classmethod
    def _request(cls, master, hi, lo):
        cls._write(master, hi, lo)
        return cls._read(master)

    @classmethod
    def _download_to_dtr(cls, master, val):
        cls._write(master, 0xA3, val)
