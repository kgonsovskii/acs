# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback
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
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
    redlog(txt)
    return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)




def crip():
   try:
    chskd = acs.ChannelTCP(gprm['-ch'])
    mbch['chskd'] = chskd
    chskd.response_timeout = 0.1
    rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!', 3)
    return chskd
   except Exception as ee:
    mpr('crip',ee)

def test_ffkls(n1,n2):
   ls=[]
   mp('yellow','fformirkeys n1='+str(n1)+' /n2='+str(n2))
   for i in range(n1,n2+1,1):
    key = acs.Key()
    key.code = i + 1
    key.mask = [1,2,3,4,5,6,7,8]
    key.pers_cat = 16
    ls.append(key)
   return ls

#=====================mgbs=================================
mgb={}
gprm={}
mbch={}
gprm['-ch']='vagacs'
mp('white','start')
gprm['-ch']='192.168.0.96'
chskd=crip()            # создать канал
#addrs=chskd.find_addrs() # найти все контроллеры канала примерно (одна минута,полторы)
chskd.del_all_keys(7)
ls=test_ffkls(1,10)
mp('yellow','start WRALLKEYS')
chskd.write_all_keys(7,ls)
mp('yellow','stOP WRALLKEYS')

mp('white','START readallkeys ')
ls=chskd.read_all_keys(7)   # вычитать ключи из контроллера 7
mp('white','stop readallkeys ls='+str(ls))
i=0;
for t in ls:
  gevent.sleep(0.01)
  i=i+1
  mp('yellow','i='+str(i)+', code='+str(t.code))
mp('lime','start writeallkeys')
