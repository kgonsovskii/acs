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
   #testlog(txt)
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








def get_event(addr, is_complex):
    try:
        gevent.sleep(0.01)
        f=True
        # print 'get_event addr=',addr
        return chskd.get_event(addr,f)
    except Exception as ee:
        print ('get_event new ERROR:',ee,' ADDR=',addr)
        gevent.sleep(1)



def poll_event():
    while True:
        for addr in addrs:
            # x0addkey(addr)
            gevent.sleep(0.1)
            evt = get_event(addr,True)
            if evt is not None:
                gevent.sleep(0.1)
                print ('evt==',evt)

                if isinstance(evt, acs.EventKey):
                    mp('red','KEY evt='+str(evt))
                    code=evt.code
                    kl=str(gfunc.xkeytos(code))
                    ac=evt.addr
                    kl=gfunc.xkeytos(code)
                    mp('blue','KEY ac='+str(ac)+' kl='+kl+' /code='+str(code))



def crip():
   try:
    chskd = acs.ChannelTCP(gprm['-ch'])
    chskd.response_timeout =0.5    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',10)
    return chskd
   except Exception as ee:
    mpr('crip',ee)
    return None


def timer1s(interval):
    while True:
     gevent.sleep(interval)
     mp('lime','timer1s')

#============= mgbs ============================================================
mgb={}
tasks=[]
addrs=[7,77]
gprm={}
gprm['-ch']='192.168.0.96'
chskd=crip()
mp('lime','chskd='+str(chskd))

task = gevent.spawn(timer1s,1)
tasks.append(task)


tasks.append(gevent.spawn(poll_event))



rmp('blue','gevent.joinall(tasks)',10)
gevent.joinall(tasks)


