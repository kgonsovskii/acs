#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import json
import al9box
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

def onmesmqtt(client, userdata, message):
    #gevent.sleep(0.01) #sudasleep
    js=message.payload.decode("utf-8")
    #mp('cyan', 'client=' + str(client.))
    #mp('cyan', 'userdata=' + str(userdata))
    #mp('white' ,'mymqtt ONmes=' + str(js))
    try:
     g=json.loads(js)
     if not 'cmd' in g.keys():return
     if g['cmd']=='stosyslog':
      rmp('lime',g['line'],1)
      lstowrlog.append(g['line'])
      mp('red','onmes ADD TO lswrlog='+g['line'])
     if g['cmd']=='releon' or g['cmd']=='releoff':
      #lsgrele.append(g)
      al9box.lsgrele.append(g)
      #rmp('magenta','onmes='+str(g),10)
     if  g['cmd']=='todmsev':
      mp('cyan','MYMQTT.ONMES='+str(g))
      lsgtodms.append(g)

    except Exception as ee:
      mprs('onmes',ee)

def mysubscreibe(topic):
    try:
     mbqt['mqtt'].subscribe(topic)
     lstopics.append(topic)
     return 'ok',lstopics
    except Exception as ee:
     mpr('mysubscreibe',ee)
     return str(ee),lstopics



def connecttobroker(cid,host):
    rmp('lime','connecttobroker START',1)
    # print ('connecttobroker cid='+str(cid)+' /host='+host)
    mp('magenta','connecttobroker cid='+cid+' /host='+host)
    broker_address =host
    mqclient = mqtt.Client(cid)  # create new instance
    mqclient._connect_timeout=25.0
    mqclient.on_message = onmesmqtt  # attach function to callback
   # print("connecting to broker")
    mqclient.connect(host)  # connect to broker
    mqclient.loop_start()  # start the loop
    rmp('magenta','AFTER connecttobroker  ',3)
    mbqt['mqtt']=mqclient
    return mqclient


def formir_glstojs(g):
   try:
    sj = json.dumps(g)
    topic=g['komu']
    mbqt['mqtt'].publish(topic,sj)
   # mp('red','sj='+str(sj))
   except Exception as ee:
    mpr('glstojs',ee)

#========================mgbs================================
mgb={}
mbqt={}
lsgrele=[]
lstopics=[]
lsgtodms=[]
lstowrlog=[]
mqclient=None
mbqt['mqtt']=None
gprm={}
gprm['-ch']='mymqtt'
gprm=gfunc.gonsgetp()
