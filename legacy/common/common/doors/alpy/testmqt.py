#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import json
import paho.mqtt.client as mqtt



def mpr(txt, ee):
    em = str(traceback.format_exc())
    mp('red', txt + '/ee=' + em)


def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)

def mp(c,txt):
 try:
  # spid=mgb['spid']
  if not '-ch' in gprm.keys():
   ch='???'
  else: ch=gprm['-ch']
  ch=gprm['-topic']+'_'+ch
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
        #redlog(txt)
        return
      if c == 'magenta':
          #magentalog(txt)
          return
 except Exception as ee:
   print ('mp ee='+str(ee))






def formir_glstojs(g):
   try:
    sj = json.dumps(g)
    if mbqt['mqtt']!=None:
     #mp('lime','tttttttttttttttttttttttttttttttttttttttttttt')
     mbqt['mqtt'].publish('tomain',sj)
    # mbqt['mqtt'].publish('tomain', sj)
     mp('cyan','SEND sj='+str(sj))
   except Exception as ee:
    mpr('glstojs',ee)


def timer1s(interval):
    while True:
     gevent.sleep(interval)
     mp(cl,'timer1s ......................')
     if gprm['-regim']=='both':
         g={}
         g['cmd']='life'
         g['who']=gprm['-cl']
         g['pid']=str(os.getpid())
         g['uxt']=str(stofunc.nowtosec('loc'))
         #mp(cl,'TIMERR1S')
         formir_glstojs(g)


def onmesmqtt(client, userdata, message):
    #gevent.sleep(0.01) #sudasleep
    js=message.payload.decode("utf-8")
    mp('white' ,'ONmes=' + str(js))
    try:
     g=json.loads(js)
    except Exception as ee:
      return



def connecttobroker(cid,host):
  try:
    rmp(cl,'connecttobroker START',1)
    mp(cl,'connecttobroker cid='+cid+' /host='+host)
    broker_address =host

    mqclient = mqtt.Client(gprm['cid'])  # create new instance
    mqclient._connect_timeout=25.0
    mqclient.on_message = onmesmqtt  # attach function to callback
    mqclient.connect(host)  # connect to broker
    mqclient.subscribe('tomain')
    mqclient.loop_start()  # start the loop
    rmp(cl,'AFTER connecttobroker  ',3)
    mbqt['mqtt'] =mqclient
    return mqclient
  except Exception as ee:
   mpr('connect to broker',ee)

#=====================mgbs============================
mgb={}
tasks=[]
mbqt={}
mbqt['mqtt']=None
mbqt['cl']=None
tasks=[]
gprm={}
gprm=gfunc.gonsgetp()    # -host 192.168.0.251 -port 1883 -topic m -cl lime
gprm['-ch']='testmqt'
cl=gprm['-cl']
gprm['cid']='cid'+gprm['-topic']
mp(cl,'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT')
mqclient=connecttobroker(gprm['cid'],gprm['-host'])
mqclient.subscribe('dms')

mbqt['mqtt'] = mqclient

task = gevent.spawn(timer1s,1)
tasks.append(task)

gevent.joinall(tasks)
