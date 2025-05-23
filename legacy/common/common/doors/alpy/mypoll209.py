#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import socket
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
#import mqtbridge,json





def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)


def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mp(c,txt):
  if c == 'red':
    pass
    #redlog(txt)

  if not '-ch' in gprm.keys():
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  s ='ch=%10s,%10s,%15s' \
      % (ch,txt,t)
  if c=='t':
   print (s)
   #testlog(txt)
   return
  if c != 't':
      gfunc.mpv(c, s)
      #gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)

      if c == 'magenta':
          #magentalog(txt)
          return



def frmerr(ac):
   s='ac='+str(ac)+' ERR='+str(mbacl[ac]['cerr'])
   return s

def xanalyzee(ac,ee):
  try:
    mbch['cherrors']=mbch['cherrors']+1
    mp('magenta','xanalyzee cherrors='+str(mbch['cherrors']))
  except Exception as ee:
   mprs('xanalyzee',ee)


def xmypoll():
      while True:
          gevent.sleep(0.005)
          chskd = mbch['chskd']
          if mbch['active'] :
             for ac in mbch['addrs']:
              if  mbacl[ac]['kpx']=='kpx'  and  mbacl[ac]['buzy'] == False  :
                  gevent.sleep(0.001)
                  try:
                    ev=None
                    #mp('cyan','EVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV')
                    ev = chskd.get_event(ac, True)
                    mbch['countev']=mbch['countev']+1
                    if ev !=None:
                     s=frmerr(ac)
                     mp('white',str(ev)+' ERR='+s)
                    #mbch['cev'] = mbch['cev'] + 1


                  except Exception as ee:
                    mbacl[ac]['cerr'] = mbacl[ac]['cerr'] + 1
                    mprs('getevent ac='+str(ac)+'cerr='+str( mbacl[ac]['cerr']),ee)
                    xanalyzee(ac,ee)

              if ev != None:
                pass
                #cev = formircev(ev)


def formirmbacl(ls):
 g={}
 for ac in ls:
  g[ac]={}
  g[ac]['kpx']='kpx'
  g[ac]['buzy']=False      # контроллер занят другой операцией (запись ключей ...)
  g[ac]['cerr']=0          # общее кол-во ошибок на этом контроллере
  g[ac]['currerr']=0       # текущее кол-во ошибок до первого успешного события


 return g


def formirmbch():
    g={}
    g['cev']=0
    g['speed']=0
    g['active']=False
    g['getdt'] = False
    g['exaddrs']=[]
    g['cherrors']=0
    g['exclcount']=0
    g['kofexcl']=0
    g['cherrors']=0
    g['countev'] =0
    return g



def crip(ch):
 atp=0
 while True:
   try:
    atp=atp+1
    mp('cyan','crip='+gprm['-ch'])
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.5  #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    #chskd.flush_input()
    print('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))

def timer10s(interval):
    while True:
      gevent.sleep(interval)
      mbch['speed']=int(mbch['countev'] / interval )
      mp('lime','SPEED='+str(mbch['countev']))
      mbch['countev']=0

def fd_rak(ac):
    mp('yellow', 'CALL READALLKEYS AC=' + str(ac))
    ls=[]
    try:
        f=False
       # chskd.get_dt(ac)
        ls = chskd.read_all_keys(ac)
        f=True
        return f,ls
    except Exception as ee:
        f=False
        mprs('rak 1  ', ee)
    if not f:
        try:
            gevent.sleep(5)
            f = False
            rmp('yellow','readallkeys 2',20)
            ls = chskd.read_all_keys(ac)
            f = True
            return f, ls
        except Exception as ee:
            f = False
            mprs('rak  2 ', ee)
        return f,ls


def timer1s(interval):
    while True:
     gevent.sleep(interval)
     mp('white','timer1s')
     g={}
     g['cmd']='test'
     g['tscd']=gfunc.mytscd()
     #sj = json.dumps(g)
     #mbqt['mqtt'].publish('maldms', sj)

#==================================mgbs
mgb={}
tasks=[]
mbch={}
mbqt={}
mbacl={}
gprm={}
mbch['speed']=0
mbch['countev']=0
gprm=gfunc.gonsgetp()
s=gprm['-acl']
ls=s.split(',')
print('ls=',ls)
lss=[]
mbch=formirmbch()
for ac in ls:
  lss.append (int(ac))
print('lss=',lss)
mbacl=formirmbacl(lss)
print (mbacl)
chskd=crip(gprm['-ch'])
mbch['chskd']=chskd

mbch['active']=True
mbch['addrs']=lss

#task = gevent.spawn(timer10s,10)
#tasks.append(task)
rmp('magenta','JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ',10)
mp('lime','call readallkey')
cid='astraorel_192.168.0.96'
host='192.168.0.105'
#mbqt['mqtt']=mqtbridge.connecttobroker(cid,host)
#rc,ls=mqtbridge.mysubscreibe(mbqt['mqtt'],'maldms')
#mp('lime','rc='+rc+',ls='+str(ls))


task = gevent.spawn(timer1s,1)
tasks.append(task)

ac=7
rmp('yellow','sssssssssssssssssssssssssssssssssssssssssssssssssssssss',5)
#chskd.flush_input()
rc,ls=fd_rak(ac)
if rc==None:
 rmp('red','EEEEEEEEEEEEEEEEEEEEEEEEEEEE',5)
else:
 ll=len(ls)
 rmp('lime','URA  ll='+str(ll),50)

gevent.sleep(5)
xmypoll()






gevent.joinall(tasks)

