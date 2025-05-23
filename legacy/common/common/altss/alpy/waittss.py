#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import json
import paho.mqtt.client as mqtt #import the client1
#

def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mpr(txt, ee):
    em = str(traceback.format_exc())
    mp('red', txt + '/ee=' + em)


def mp(c,txt):
 try:
  # spid=mgb['spid']
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
      if c == 'red':
        redlog(txt)
        return
      if c == 'magenta':
          #magentalog(txt)
          return
 except Exception as ee:
   print ('mp ee='+str(ee))



def redlog(txt):
    return
    ch=gprm['-ch']

    cd=gfunc.mydatezz()
    ct=gfunc.mytime()
    cds=cd+' '+ct+' '
    appdir=gfunc.getmydir()
    fn=appdir+'redlog'+sep+ch+'.txt'
    # print ('redlog fn=',fn)
    outp=open(fn,'a')
    outp.write(cds+txt+'\n')
    outp.flush()
    outp.close()

def formir_glstojs(g):
   try:
    sj = json.dumps(g)
    if mbqt['mqtt']!=None:
     mbqt['mqtt'].publish('tss_mqtt',sj)
     mp('cyan','sj='+str(sj))
   except Exception as ee:
    mpr('glstojs',ee)


def timer1s(interval):
    while True:
     gevent.sleep(interval)
     g={}
     g['cmd']='life'
     g['who']=gprm['-ch']
     g['pid']=str(os.getpid())
     g['uxt']=str(stofunc.nowtosec('loc'))
     formir_glstojs(g)

def timerscancmd(interval):
    while True:
     gevent.sleep(interval)
     mp('yellow','timerscancmd')
     if os.path.isfile('cmd.txt'):
      inp=open('cmd.txt','r')
      ls=[]
      ls=inp.readlines()
      g=gfunc.lstogls(ls)
      mp('lime',str(g))
      inp.close()
      gfunc.mydeletefile('cmd.txt')
      if g['cmd']=='channelstart':
       mbqt['mqtt']=connecttobroker('waittss',g['mqtt.host'])


def onmesmqtt(client, userdata, message):
    pass
    #gevent.sleep(0.01) #sudasleep
    js=message.payload.decode("utf-8")
    mp('magenta','oNmes=' + str(js))
    return
    try:
     g=json.loads(js)
    except Exception as ee:
      return


def connecttobroker(cid,host):
    rmp('magenta','connecttobroker START',1)
    # print ('connecttobroker cid='+str(cid)+' /host='+host)
    mp('magenta','connecttobroker cid='+cid+' /host='+host)
    broker_address =host

    # print("creating new instance")
    # print('cyan','connecttobroker h='+host+' /cid='+cid)
    mqclient = mqtt.Client(cid)  # create new instance
    mqclient._connect_timeout=25.0
    mqclient.on_message = onmesmqtt  # attach function to callback
    print("connecting to broker")
    mqclient.connect(host)  # connect to broker
    mqclient.subscribe('tss_mqtt')
    mqclient.loop_start()  # start the loop
    rmp('magenta','AFTER connecttobroker  ',3)
    return mqclient


#=====================mgbs============================
mgb={}
mbqt={}
mbqt['mqtt']=None
tasks=[]
gprm={}
gprm['-ch']='waittss'



task = gevent.spawn(timerscancmd,2)
tasks.append(task)

task = gevent.spawn(timer1s,1)
tasks.append(task)

gevent.joinall(tasks)
