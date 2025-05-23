#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep


def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mp(c,txt):
 try:
  # spid=mgb['spid']
  if not '-ch' in gprm.keys():
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  s ='ch=%10s,%10s,%10s' \
      % (ch,txt,t)
  if c=='t':
   print (s)
   testlog(txt)
   return
  if c != 't':
      gfunc.mpv(c, s)
      #gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
      if c == 'red':
        #redlog(txt)
        return
      if c == 'magenta':
         # magentalog(txt)
          return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def tgmaska(m):
  try:
   ls=[]
   for n in m:
    ls.append(int(n))
   return ls
  except Exception as ee:
    mpr('tgmaska',ee)

def tg_addkey(ac,kl):
     key = acs.Key()
     maska=[1,2,3,4,5,6,7,8]
     kl=gfunc.zerol(kl,12)
     x=gfunc.keytox(kl)
     key.code = x
     key.mask =tgmaska(maska)        #[1,2,3,4,5,6,7,8]
     key.pers_cat = 1
     try:
       mp('lime','chskd='+str(chskd))
       mp('lime','tgaddkey ac='+str(ac)+' kl='+kl+','+str(maska))
       chskd.add_key(ac, key)
     except Exception as ee:
       mpr('m77_addkey 2 ',ee)

def crip(ip):
 atp=0
 while True:
   try:
    atp=atp+1
    chskd = acs.ChannelTCP(ip)
    chskd.response_timeout =0.5    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    print('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',10)
    return chskd
   except Exception as ee:
    print('ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))
# ==============mgbs========================================
mgb={}
gprm={}
gprm['-ch']='tgaddkey'
_ach='192.168.0.96'
addrs=[77]
addr=addrs[0]
ac=addr
if _ach=='422':
 ch = acs.ChannelRS422()
else:
 chskd=crip(_ach)
print('dt='+str(chskd.get_dt(ac)))
print('prog id='+str(chskd.prog_id(ac)))
print('prog ver='+str(chskd.prog_ver(ac)))
print('keys_info='+str(chskd.keys_info(ac)))
#chskd.del_all_keys(ac)
kl='0000024D5C4D'
tg_addkey(ac,'0000024D5C4D')
ls=chskd.read_all_keys(ac)
for t in ls :
 kl2=gfunc.xkeytos(t.code)
 if kl !=kl2:
  mp('red', 'kl=' + kl + ' /kl2=' + kl2)
 else:
  mp('lime','kl='+kl+' /kl2='+kl2)
#for k, key in enumerate(ls): print('   '+str(k+1)+': '+str(key.code)+' ['+'{:012x}'.format(key.code).upper()+']')
for k, key in enumerate(ls): mp('yellow','QQQ '+str(k+1)+': '+str(key.code)+' ['+'{:012x}'.format(key.code).upper()+']')

inp=open('imu_14.txt')
ls=inp.readlines()
lsx=[]

for s in ls:
 lss=s.split(',')
 if len(lss)==2:
     kl=lss[0]
     maska=lss[1]
     code=gfunc.keytox(kl)
     lsx.append(code)
lsx.sort()
i=0
for x in lsx:
 i=i+1
 if i>1:
     d=lsx[i]-lsx[i-1]
     if x!=38624333:
      mp('magenta','i='+str(i)+' code='+str(x)+' /d='+str(d))
     else:
         mp('yellow', 'i=' + str(i) + ' code=' + str(x)+' /d='+str(d))



#code=gfunc.xkeytos(kl)
#kl3=chskd.find_key(ac,code)
#print ('kl3=',str(kl3))