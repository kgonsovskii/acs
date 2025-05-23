#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import gfunc,sys,json,traceback
import paho.mqtt.client as mqtt
import asyncio




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
    redlog(txt)
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






def onmesmqtt(client, userdata, message):

   try:
    js=message.payload.decode("utf-8")
    mbrlist.append(js)
   except Exception as ee:
     mpr('onmes',ee)






def mysubscreibe(mqt,topic):
    try:
     mqt.subscribe(topic)
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
    mqclient = mqtt.Client(cid)
    mqclient._connect_timeout=25.0
    mqclient.on_message = onmesmqtt
    mqclient.connect(host)  # connect to broker
    mqclient.loop_start()  # start the loop
    rmp('magenta','AFTER connecttobroker ='+host,3)
    mbqt['mqtt']=mqclient
    return mqclient


async def astimer1s(interval):
   while True:
    await asyncio.sleep(interval)
    mp('magenta','BRIDGEtimer1s')


async def astimer1s(interval):
    while True:
     await asyncio.sleep(interval)
     mp('cyan','astimer1s ????????????????????????????????????????????????')

#=========================mgbs=================
mgb={}
mbqt={}
gprm={}
tasks=[]
mbrlist=[]
lstopics=[]
gprm['-ch']='mqtbridge'
mp('lime','start')

'''
loop = asyncio.get_event_loop()
task1 = loop.create_task(astimer1s(1))
loop.run_until_complete(asyncio.wait([task1]))
'''