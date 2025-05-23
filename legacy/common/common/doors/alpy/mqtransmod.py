#!/usr/bin/env python
# -*- coding: utf-8 -*-
import gevent
from os import path, sep

import stofunc,gsfunc,gfunc
import json
import socket
import sys,time,os,traceback,time
import paho.mqtt.client as mqtt #import the client1

############

def toredlog(p):
   # return
   appdir = gfunc.getmydir()
   cd=gfunc.mydatezz()
   cd=cd.replace('.','')
   fn = appdir +'redlog'+sep+cd  +'dms.log'
   print('fn=',fn)
   fout=open(fn,'a')
   fout.write(p+'\n')
   fout.flush()
   fout.close()



def mp(c,txt):
 try:
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  pid=str(mgb['pid'])
  gfunc.mpv(c,nm+' /pid='+pid+'  ' +txt+'  /t='+t)
  if c=='red':toredlog(nm+' /pid='+pid+'  ' +txt+'  /t='+t)
 except Exception as ee:
   print ('mp ee='+str(ee))

def mprs(txt, ee):
     em = str(ee)
     mp('red', txt + '/ee=' + em)

def rmp(c, txt, n):
     for i in range(1, n + 1, 1):
         mp(c, txt)


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)





def timer1s(interval):
    while True:
     gevent.sleep(interval)
     pass
     # print('timer1s MQTRANSMOD ???????????')
     # client.publish("tss_mqtt", "ЖЕНЯ")
     # mp('cyan','timer1s ??????????????????????')
     # g={}
     # g['cmd']='TEST'
     # g['kto']=mgb['trlid']
     # g['komu']='all'
     # mp('yellow','timer5s g='+str(g))
     # mysend(g)


def on_message(client, userdata, message):
    pass
    #gevent.sleep(0.01) #sudasleep
    js=message.payload.decode("utf-8")
   # print ('oNmes=' + str(js))
    try:
     g=json.loads(js)

    except Exception as ee:
      return
    try:
     g = json.loads(js)
     if not 'cmd'  in g.keys() and not 'subcmd' in g.keys():return
     if g['cmd']=='bypass':return
     #mp('red','subcmd='+str(g['subcmd']))
     #mp('cyan','g=' + str(g))
     #mp('cyan','MGBT='+str(mgbt))
     #if g['cmd']!='bypass':
     #if not 'bidch' in g.keys():
    # mp('yellow','g='+str(g))
    # mp('YELLOW','ON_MESS KEY NOT FOUNDcmd='+g['cmd'])

    # if g['cmd'] != 'bypass':
     # if int(g['bidch'])!=int(mgbt['bidch']):return
     #mp('lime','MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM')
     #mp('white', 'apend aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
     sljsin.append(js)
    # mp('red','on_mes js='+js)
    except Exception as ee:
     mpr('mqtransmod 3 ',ee)
    # print("ONM="+str(message.topic+'='+ message.payload.decode("utf-8")))
    # print("message topic=",message.topic)
    # print("message qos=",message.qos)
    # print("message retain flag=",message.retain)

def connecttobroker(cid,host):
    rmp('magenta','connecttobroker START',1)
    # print ('connecttobroker cid='+str(cid)+' /host='+host)
    mp('magenta','connecttobroker cid='+cid+' /host='+host)
    broker_address =host
    # print("creating new instance")
    # print('cyan','connecttobroker h='+host+' /cid='+cid)
    mqclient = mqtt.Client(cid)  # create new instance
    mqclient._connect_timeout=25.0
    mqclient.on_message = on_message  # attach function to callback
    print("connecting to broker")
    mqclient.connect(host)  # connect to broker
    mqclient.subscribe('tss_mqtt')
    # client.loop_start()  # start the loop
    rmp('yellow','AFTER connecttobroker  ',3)
    return mqclient
# =============================mgbs ======================================
ap=chr(0x27)
zp=','
mgb={}
mgbt={}
sljsin=[]
tasks=[]
mgb['pid']=os.getpid()



task=gevent.spawn(timer1s,1)
tasks.append(task)















