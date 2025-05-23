#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys,time,os,traceback,socket,time,gevent
import libtssacs as acs
from gevent.queue import Queue
import gfunc,stofunc

class tcmdmain():
    def __init__(self):
      self.bid=0                      # myid from base
      self.secmer=0                   # SECUNDOMER
      self.phase=None                # wait,exe
      self.attempt=0                 # попыток
      self.kpx='avt'                 # avt or kpx
      self.actcg=False               # channel active or not
      self.typ=['l','chnot','avt']    # long,channel not active,kpx=avt
      self.start=0                    #stamp DELIVERY work
      self.attempt=0
      self.chskd=None
      self.ac=-1
      self.lsout=[]
      self.lsin=[]
      self.cmd =None
      self.glsrc=None
      self.erm=None
      self.simulerr='no'





def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='dms'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
    #redlog(txt)
    return
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))



def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)





def simulrak(task,n):
    print ('simulrak ???????????????????????????????????????????')
    ac=str(task.ac)
    for i in range(1,n+1,1):
      k = acs.Key()
      k.code=i
      try:
       task.lsout.append(k)
       if task.simulerr=='yes':
        raise ZeroDivisionError('simulaition err ac='+ac)
      except Exception as ee:
       task.erm=str(ee)
       return task
    print('MYTSSLONGCMD STOP ????????????????????????????????????????')
    task.erm='ok'
    return task

def fshowlsout(ls):
    try:
      return
      for t in ls:
       print (t)
    except Exception as ee:
     print ('fshowlsout',ee)

def directrak(task):
    print ('directrak ???????????????????????????????????????????')
    ac=task.ac
    try:
     chskd=task.chskd
     task.attempt=1
     task.slout=[]
     print ('chskd=',chskd)
     print ('cyan','call read_all_keys ac='+str(ac))
     ki=chskd.keys_info(ac)
     print('cyan', 'call read_all_keys ki=' + str(ki))
     gevent.sleep(1) #sudasleep
     print ('call rak 111111111111111111111111111111111111111111')
     task.slout=task.chskd.read_all_keys(ac)
     task.erm='ok'
     ll=str(len(task.slout))
     print ('yellow','directrak 1  SIZE='+ll)
     #gevent.sleep(10)
     print ('sleep 20    ????????????????????????????????????')
     if int(ll) > 0: fshowlsout(task.slout)
     gevent.sleep(20)
     return task
    except Exception as ee:
       print ('direct EE=',ee)
       task.erm=str(ee)
    if task.erm !='ok':
       task.attemp = 2
       task.slout = []
       try:
        print ('call rak 222222222222222222222222222222222222222222222')
        task.slout = task.chskd.read_all_keys(ac)
        task.erm = 'ok'
        ll = str(len(task.slout))
        print('yellow', 'directrak 2  SIZE=' + ll)
        if int(ll) > 0: fshowlsout(task.slout)
        return task
       except Exception as ee:
           print('direct EE=', ee)
           task.erm = str(ee)
       return task



def tsslt_rak(task):
    try:
       print('MYTSSLONGCMD ?????????????????????????????????????????')
       print('MYTSSLONGCMD ?????????????????????????????????????????')
       print('MYTSSLONGCMD call rak')
       ac=int(task.ac)
       task.erm='ok'
       task.attempt = 1
       task.simulerr = 'no'
       task=directrak(task)
       return task
    except Exception as ee:
      print ('tsslt_rak',ee)


def crip(ch):
 atp=0
 while True and atp<20:
   try:
    atp=atp+1
    print('cyan','crip ch='+ch)
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.1    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
   # chskd.flush_input()
    gevent.sleep(1)
    print ('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',30)
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))


def timer1s(interval):
    while True:
     gevent.sleep(interval)
     mp('yellow','mytsslongcmd timer1')





#===============mgbs===============
chskd=None
tasks=[]
gprm={}
gprm['-ch']='mytsslongcmd'

#task = gevent.spawn(timer1s, 1)
#tasks.append(task)


chskd=crip('192.168.0.96')
ki7=chskd.keys_info(7)
ki77=chskd.keys_info(77)
mp('lime','ki7='+str(ki7))
mp('lime','ki77='+str(ki77))
ac=77
chskd.del_all_keys(ac)
mp('red','after delall ')
ls=[]
for i in range(1001):
  t=acs.Key()
  t.code=i
  t.mask=[1,2,3,4,5,6,7,8]
  t.pers_cat=16
  ls.append(t)
mp('yellow','ki7=START WAK')
t1=stofunc.nowtosec('loc')
chskd.write_all_keys(ac,ls)
t2=stofunc.nowtosec('loc')
d=t2-t1
mp('lime','WAK d='+str(d))
t1=stofunc.nowtosec('loc')
gevent.sleep(10)
mp('cyan','ki7=START RAK')
ls=chskd.read_all_keys(ac)
t2=stofunc.nowtosec('loc')
d=t2-t1
mp('lime','d='+str(d))

ll=str(len(ls))
mp('lime','ll='+ll+',d='+str(d))
sys.exit(99)

gevent.joinall(tasks)