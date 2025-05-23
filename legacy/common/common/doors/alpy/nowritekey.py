#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys,time,datetime#,os,traceback
import libtssacs as acs
#import stofunc,gsfunc,gfunc
import gevent
import serial
##import vvgUtils
#from os import path, sep
#from mqtt import TMQTT,doMQTTRcvdParse
#from tssUtils import getMAC
#from vvgUtils import prntclr
#from random import randint
#from getkey import getkey, keys, platform # https://github.com/kcsaff/getkey
##import keyboard # https://github.com/boppreh/keyboard
##from gevent import monkey
##monkey.patch_all()
#import signal
#from gevent.event import AsyncResult
#asrKB = AsyncResult() # a = AsyncResult()

_PRT='/dev/ttyUSB0'
_ADDR=5
_chskd=None
_KEY=0x0000024D5C4D # 0000024D5C4D <-> 38624333

##########
def getTmStr(): return datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3]
# END: def getTmStr()

##########
def doPrnt(sMsg,isTm=True): sTm = '['+getTmStr()+'] ' if isTm else ''; print(sTm+sMsg)
# END: def doPrnt(..)

##########
def getType(Val):
    return str(type(Val))
# END: def getType(..)

##########
def cr232(sPrt):
    try:
        doPrnt('cr232 -> sPrt: '+sPrt)
        chskd = acs.ChannelRS232(sPrt)
        doPrnt('cr232 -> ['+sPrt+'] КАНАЛ СОЗДАН!!!')
        return chskd
    except Exception as ee:
        doPrnt('cr232 -> ERROR: '+str(ee))
        return None
# END: def cr232()

##########
def doRAK(isShow = False):
    doPrnt('DO read_all_keys...')
    doPrnt('   ЖДИТЕ...',False)
    start_time = time.time()
    ls=_chskd.read_all_keys(_ADDR)
    doPrnt('DONE read_all_keys('+str(_ADDR)+'): ['+str((time.time() - start_time))+'] -> len(ls): '+str(len(ls)))
    if isShow:
        #for k, key in enumerate(ls): doPrnt('   '+str(k+1)+': '+str(key.code)+' ['+hex(key.code)+']',False)
        for k, key in enumerate(ls): doPrnt('   '+str(k+1)+': '+str(key.code)+' ['+'{:012x}'.format(key.code).upper()+']',False)
# END: def doRAK(..)

##########
def doFK(iK=0):
    if 0==iK:
        doPrnt('doFK -> Ключ не задан!!!')
        return None
    else:
        doPrnt('DO find_key('+str(_ADDR)+','+str(iK)+')...')
        start_time = time.time()
        val = _chskd.find_key(_ADDR,iK)
        doPrnt('DONE find_key('+str(_ADDR)+','+str(iK)+'): ['+str((time.time() - start_time))+'] -> val ('+getType(val)+'): '+str(val))
        # val (<class 'libtssacs.Key'>): Key(code: 100068, mask: [1, 2, 3, 4, 5, 6, 7, 8], pers_cat: 16, suppress_door_event: False, open_always: False, is_silent: False)
        # val (<class 'NoneType'>): None
        return val
# END: def doFK(iK=0)

##########
def doMain():
    global _chskd

    doPrnt('doMain -> Start!')
    
    _chskd=None
    _chskd=cr232(_PRT)# создать канал
    doPrnt('doMain -> _chskd: '+str(_chskd))
    # doMain -> _chskd: None
    # doMain -> _chskd: <libtssacs.ChannelRS232 object at 0x7fefe942e070>
    if _chskd is None:
        doPrnt('Ошибка создания канала!')
    else:
        val = _chskd.prog_ver(_ADDR)
        doPrnt('   prog_ver ('+getType(val)+'): '+str(val),False)
        #prog_ver (<class 'tuple'>): (1, 79)
        val = _chskd.prog_id(_ADDR)
        doPrnt('   prog_id ('+getType(val)+'): '+str(val),False)
        #prog_id (<class 'int'>): 156
        val = _chskd.ser_num(_ADDR)
        doPrnt('   ser_num ('+getType(val)+'): '+str(val),False)
        #ser_num (<class 'int'>): 10804
        val = _chskd.get_dt(_ADDR)
        doPrnt('   get_dt ('+getType(val)+'): '+str(val),False)
        val = _chskd.keys_info(_ADDR)
        doPrnt('   keys_info ('+getType(val)+'): '+str(val),False)
        #keys_info (<class 'tuple'>): (64260, 1000)
        
        #doPrnt('DO read_all_keys...')
        #doPrnt('   ЖДИТЕ...',False)
        #start_time = time.time()
        #ls=_chskd.read_all_keys(_ADDR)
        #doPrnt('DONE read_all_keys('+str(_ADDR)+'): ['+str((time.time() - start_time))+'] -> len(ls): '+str(len(ls)))
        #for k, key in enumerate(ls): doPrnt('   '+str(k+1)+': '+str(key.code)+' ['+hex(key.code)+']',False)
        doRAK(True)

        ##iKey = 100068
        #iKey = 79460
        #doPrnt('DO find_key('+str(_ADDR)+','+str(iKey)+')...')
        #start_time = time.time()
        #val = _chskd.find_key(_ADDR,iKey)
        #doPrnt('DONE find_key('+str(_ADDR)+','+str(iKey)+'): ['+str((time.time() - start_time))+'] -> val ('+getType(val)+'): '+str(val))
        ## val (<class 'libtssacs.Key'>): Key(code: 100068, mask: [1, 2, 3, 4, 5, 6, 7, 8], pers_cat: 16, suppress_door_event: False, open_always: False, is_silent: False)
        ## val (<class 'NoneType'>): None
        doFK(79460)

        sTmp = 'add_key('+str(_ADDR)+','+'{:012x}'.format(_KEY).upper()+')'
        doPrnt('DO '+sTmp+'...')
        key = acs.Key()
        key.code = _KEY
        key.mask = [1,2,3,4,5,6,7,8]
        key.pers_cat = 16
        start_time = time.time()
        _chskd.add_key(_ADDR, key)
        doPrnt('DONE '+sTmp+': ['+str((time.time() - start_time))+']')
        doRAK(True)
        if doFK(_KEY) is not None:
            sTmp = 'del_key('+str(_ADDR)+','+'{:012x}'.format(_KEY).upper()+')'
            doPrnt('DO '+sTmp+'...')
            start_time = time.time()
            _chskd.del_key(_ADDR, _KEY)
            doPrnt('DONE '+sTmp+': ['+str((time.time() - start_time))+']')
            doRAK(True)
    
    doPrnt('doMain -> Stop!')
# END: def doMain():

##########
if __name__=="__main__":
    doPrnt('Start nowritekey!')
    
    tasks=[]
    tskMain = gevent.spawn(doMain)
    tasks.append(tskMain)
    gevent.joinall(tasks)
    
    doPrnt('Stop nowritekey!')
