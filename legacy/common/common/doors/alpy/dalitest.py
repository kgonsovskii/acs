#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
import libtssdali as Dali
import gevent,os,sys,traceback
import libtsscmk as cmk
import stofunc,gfunc

def mpr(txt,ee):
 em=str(traceback.format_exc())
 gfunc.mpv('red',txt+'/ee='+em)


def mprs(txt,ee):
 em=str(ee)
 mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
 for i in range(1,n+1,1):
  mp(c,txt)



def mp(c,txt):
 try:
  c=c.lower()
  t=gfunc.mytime()
  s='DALITEST. '
  gfunc.mpv(c,'DALITEST. '+txt+'  /t='+t)
 except Exception,ee:
  print ee

def delfromgrupa(master,ac,gruppa):
   try:
    cmk.usart_write_speed(cmk.RS485_SPEED_REG, 115200)
    rc=Dali.Dali.remove_from_group(master,ac,gruppa)
    mp('lime','delfromgrupa.rc='+str(rc))
   except Exception,ee:
    mpr('delfromgrupa',ee)

def addingroup(master,gruppa,ac):
 try:
  cmk.usart_write_speed(cmk.RS485_SPEED_REG, 115200)
  rc=Dali.Dali.add_to_group(master,ac,gruppa)
  mp('lime','addingroup.rc='+str(rc))
 except Exception,ee:
  mpr('addingroup',ee)



# =============================================================================
# wdg=cmk.read_watchdog()
# print 'wdg=',wdg
# cmk.write_watchdog(0)
# wdg=cmk.read_watchdog()
# print 'wdg=',wdg

master=10
gruppa=1
cmk.usart_write_speed(cmk.RS485_SPEED_REG, 115200)
print 'START GENERATION'
rc=Dali.Dali.gen_addrs(master,0,64,)
print 'rc=',rc
sys.exit(99)

for ac in range(1,3,1):
 delfromgrupa(master,ac,gruppa)
# sys.exit(99)
ac=1
rc=addingroup(master,gruppa,ac)
rc=addingroup(master,gruppa,ac)
sys.exit(99)
print 'START PING SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS'

cmk.usart_write_speed(cmk.RS485_SPEED_REG, 115200)

rc=Dali.Dali.arc_power(master,1,0)
cmk.usart_write_speed(cmk.RS485_SPEED_REG, 115200)
rc=Dali.Dali.arc_power(master,2,100)
print 'AFTER  POWER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! '


mp('yellow','PING MASTER SLAVE START')
print 'nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn'
for i in range(1,2,1):
 cmk.usart_write_speed(cmk.RS485_SPEED_REG, 115200)
 rc=Dali.Dali.ping_master(master)
 mp('cyan','PING MASTER SLAVE I='+str(i)+' rc='+str(rc))
 print i,rc
if not rc:
 print 'NO PING MASTER--> EXIT'
 sys.exit(99)

print 'master=',master

mp('yelLow','START GEN ADDR')
t1=stofunc.nowtosec('SQL')
print 'ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss'
cmk.usart_write_speed(cmk.RS485_SPEED_REG, 115200)
ls=Dali.Dali.gen_addrs(10,1,64)
t2=stofunc.nowtosec('SQL')
d=(t2-t1)/60.00
mp('lime','STOP DELTA='+str(d)+' MINUT  t1='+str(t1)+' t2='+str(t2)+' / d='+str(d) )
print 'STOP DELTA ls=',ls
sys.exit(99)
print 'KILL TSSLUX (GONS) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
s='free -m;sudo killall tsslux;free-m;ps aux |grep tsslux'
s='free -m;free-m;ps aux |grep tsslux'
os.system(s)
gevent.sleep(1)
for i  in range(1,1001,1):
 rc=Dali.Dali.ping_master(master)
 gevent.sleep(1)
 print 'PING MASTER I=',i,'master=',master,' /rc=',rc