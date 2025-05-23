#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time

import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import psycopg2
import base64
import json,subprocess
import paho.mqtt.client as mqtt





def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)




def redlog(txt):
    toredbase(txt)
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

def toredbase(txt):
   try:
    txt=txt.replace(ap,'"')
    try:
     f=txt.index('/ee=')
     typ=-1
    except Exception as ee:
     typ='0'
    app = gprm['-ch']
    s='insert into tss_redlog(typ,app,txt)values ('+\
    str(typ)+zp+\
    ap+app+ap+zp+ap+txt+ap+')'
    mp('blue','toredbase s='+s)

    curs2 = pgconn.cursor()
    curs2.execute(s)
    pgconn.commit()
    curs2.close()
   except Exception as ee:
     print('TTTTTTTTTTTTTTTTTTTTtoredbase '+str(ee))


def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='dms'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
   # redlog(txt)
    return
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)



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
    rmp('magenta','AFTER connecttobroker ='+host,3)
    mbqt['mqtt']=mqclient
    return mqclient

def onmesmqtt(client, userdata, message):

    js=message.payload.decode("utf-8")
    #mp('cyan', 'client=' + str(client.))
    #mp('cyan', 'userdata=' + str(userdata))
    #mp('white' ,'mymqtt ONmes=' + str(js))
    try:
     g=json.loads(js)
     if not 'cmd' in g.keys():return
     if g['module'] !='maldms':return
     if  g['cmd']=='stosyslog':
      mp('lime','???????onmes TODMSEV komu='+g['komu']+' ,'+str(g))
      #lsgtodms.append(g)

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

def timer1s(interval):
    while True:
     gevent.sleep(interval)
     mp('cyan','timer1s ????????????????')

#===================mgbs=======================
p=chr(0x27)
ap=chr(0x27)
zp=','
lsgtodms=[]
lstowrlog=[]
lstopics=[]
mgb={}
mbqt={}
mgb['sucs']='0'
tasks=[]
gprm={}
lsgto=[]
gprm['-ch']='wrtest'
mbalgol={}

lsginev=[]  # list of events
glsportparam={}
lsgitog=[]
lstocomcentr=[]


gprm=gsfunc.gonsgetp()
gprm['-ch']='wrtest'
mp('magenta','gprm='+str(gprm))

pt=gfunc.calcptstarter()
mp('yellow','pt='+pt)

mgb['vbstarter']=gfunc.opendb3(pt,'r')
vb=mgb['vbstarter']
mysysinfo=gfunc.readstarter(vb)
mbrgg=mysysinfo['rggons']
mp('magenta','mbrgg='+str(mbrgg))

mp('cyan','base='+str(mysysinfo['base']))
cid='wrtest'
mgb['cid']=cid
mp('cyan','transport='+str(mysysinfo['transport']))
mp('cyan','comcentr='+str(mysysinfo['comcentr']))
mqclient=connecttobroker(cid,mysysinfo['transport']['ip'])
mbqt['mqtt']=mqclient
rc,ls=mysubscreibe('tosyslog')
if rc=='ok':
 mp('magenta','ls='+str(ls))


task = gevent.spawn(timer1s, 1)
tasks.append(task)

rmp('blue', 'joinall', 5)
gevent.joinall(tasks)




