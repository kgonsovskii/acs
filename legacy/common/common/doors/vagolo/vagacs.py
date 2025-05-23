# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback
#import serial
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
    pass  
    #redlog(txt)
    return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)


def crip():
    try:
        #print(f'vagacs.crip -> gprm ({type(gprm)}): {gprm}')
        #gprm (<class 'dict'>): {'-ch': '192.168.1.75'}
        
        #print(f'vagacs.crip -> acs ({type(acs)}): {acs}')
        #acs (<class 'module'>): <module 'libtssacs' from '/home/vuejs/work/python/vagacs/libtssacs.py'>

        chskd = acs.ChannelTCP(gprm['-ch'])
        #chskd = acs.ChannelRS232('COM4')
        #chskd = acs.ChannelRS232('/dev/ttyUSB0')
        #print(f'vagacs.crip -> chskd ({type(chskd)}): {chskd}')

        mbch['chskd'] = chskd
        rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',1)
        return chskd
    except Exception as ee:
        mpr('crip',ee)

##########
def test_ffkls(n1,n2):
   ls=[]
   mp('yellow','fformirkeys n1='+str(n1)+' /n2='+str(n2))
   for i in range(n1,n2+1,1):
    key = acs.Key()
    key.code = i + 1
    key.mask = [1,2,3,4,5,6,7,8]
    key.pers_cat = 16

    #mp('yellow',f'   [{i}] key.code ({type(key.code)}): {key.code};   key.mask ({type(key.mask)}): {key.mask};   key.pers_cat ({type(key.pers_cat)}): {key.pers_cat}')

    ls.append(key)

   return ls
# END: def test_ffkls(..):

#=====================mgbs=================================
#chnl = 5 # канал контроллера
chnl = 171 # канал контроллера
mgb={}
gprm={}
mbch={}
gprm['-ch']='vagacs'
mp('white','start')
gprm['-ch']='192.168.0.7'
#gprm['-ch']='192.168.1.50'
chskd=crip()            # создать канал
#print ('!!! DO chskd.find_addrs()...')
#addrs=chskd.find_addrs() # найти все контроллеры канала примерно (одна минута,полторы)
#print ('!!! DONE chskd.find_addrs(): addrs=',addrs)
#exit

addr=171
print ('!!! DO chskd.read_all_keys...')
#ls=chskd.read_all_keys(77)   # вычитать ключи из контроллера 77
#ls=chskd.read_all_keys(chnl)
print ('attempt readall addr='+str(addr))
for i in range(1,5,1):
 try:
  mp('cyan','attempt='+str(i))
  ls=chskd.read_all_keys(addr)
  break
 except Exception as ee:
  mpr('main 1',ee)
  gevent.sleep(1)

#print (f'!!! DONE chskd.read_all_keys: (count={len(ls)}) ls=',ls)

"""
print ('!!! DO chskd.del_all_keys...')
chskd.del_all_keys(chnl)
print ('!!! DONE chskd.del_all_keys...')

ls=test_ffkls(1,10)
mp('yellow','start WRALLKEYS')
chskd.write_all_keys(chnl,ls)
mp('yellow','stOP WRALLKEYS')

mp('white','START readallkeys ')
ls=chskd.read_all_keys(chnl)   # вычитать ключи из контроллера 7
mp('white','stop readallkeys ls='+str(ls))
i=0;
for t in ls:
  gevent.sleep(0.01)
  i=i+1
  mp('yellow','i='+str(i)+', code='+str(t.code))
mp('lime','start writeallkeys')
"""

