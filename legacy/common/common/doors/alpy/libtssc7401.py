# -*- coding: utf-8 -*-

import libtsscmk as cmk


class C7401(object):
    def __init__(self, slave):
        self.slave = slave

    def gons_led(self, idx):
       try:
        # print 'gons_led idx=',idx
        """
        Включить или выключить LED
        @param idx: Индекс LED 0..3
        """
        # cmk.modbus_write(self.slave, 6, 2000 + 0x007E + (1 * idx),1,1)
        cmk.modbus_write(self.slave, 6, 2000 + 0x007E,idx , 1)

        return 'ok'
       except Exception,ee:
        return str(ee)




    def control_relay(self, idx, arg):
        """
        Включить или выключить реле
        @param idx: Индекс реле 0..3
        @param arg: продолжительность в 1/8 секунды; 0 -- выключить; 65535 -- включить навсегда
        """
        cmk.modbus_write(self.slave, 6, 2000 + 0x0078 + (1 * idx), arg, 1)

    def sensor_values(self):
        lst = cmk.modbus_read(self.slave, 4, 1000 + 0x0008, 8, 1)
        return [v >> 6 for v in lst]

    def info(self):
        """
        Информация о внутренней программе контроллера
        """
        lst = cmk.modbus_read(self.slave, 4, 1000 + 0x0000, 4, 1)
        return lst[0], lst[1], lst[3] << 16 | lst[2]

    def key(self):
        """
        Возвращае код ключа если есть, иначе None
        """
        v = cmk.modbus_read(self.slave, 4, 1000 + 0x0028, 1, 1)[0]
        if v & (1 << 7) != 0:
            lst = cmk.modbus_read(self.slave, 4, 1000 + 0x0004, 4, 1)
            cmk.modbus_write(self.slave, 6, 2000 + 0x0080, 0xFFFF, 1)
            return (lst[3] << 48) | (lst[2] << 32) | (lst[1] << 16) | lst[0]
