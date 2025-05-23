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
    #mp('blue','toredbase s='+s)

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
    redlog(txt)
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

    try:
     g=json.loads(js)
     if not 'cmd' in g.keys():return
     if g['module'] !='maldms':return
     if  g['cmd']=='stosyslog' and g['module']=='maldms':
      s=g['line']
     # mp('cyan','onmess s='+s)
      lssyslog.append(s)

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

def tosyslog():
    try:
      n=0
      while len(lssyslog)>0:
        line=lssyslog.pop(0)
        #mp('magenta', 'line=' + line)
        curs = pgconn.cursor()
        curs.execute(line)
        n=n+1
        mgb['total']= mgb['total'] + 1
        #mp('magenta','line='+line)
      pgconn.commit()
      l=len(lssyslog)
      mp('white','AFTER COMMIT n=' + str(n)+' TOTAL  добавлено ='+str(mgb['total'])+' /l='+str(l))
    except Exception as ee:
        mpr('tosyslog', ee)


def timer1s(interval):
    while True:
     gevent.sleep(interval)
     l=len(lssyslog)
     if l>0 :tosyslog()




def calcstartline():
    s1 = sys.argv[0]
    s = ''
    for x in gprm:
        v = str(gprm[x])
        s = s + x + ' ' + v + ' '
    startline = 'python3 ' + s1 + ' ' + s + ' &'
    mp('red', 'startline=' + startline)
    return startline

def fpgs_connect ():
 try:
  mp('lime','BEFORE='+str(mbsysinfo))
  conn = psycopg2.connect(
    host    =mbsysinfo['lebaseip'],
    database='postgres',
    user="postgres",
    port=int(mbsysinfo['lebaseport']),
    password=mbsysinfo['lebasepsw'])

  rmp('lime','OPENBASE OK='+str(mbsysinfo['lebaseip']),5)
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')




def readconfig():
 try:
      pt=calcconfig()
      ptf = pt + 'config/altssconfig.db3'
      mp('cyan','pt='+ptf)
      mgb['vbconfig'] = gfunc.opendb3(ptf, 'r')
      vb = mgb['vbconfig']
      s = 'select key,value from config'
      vb.cursor.execute(s)
      g={}
      for row in vb.cursor:
       k =row[0].strip()
       v = str(row[1].strip())
       v=base64.b64decode(v)
       v= v.decode('utf-8')
       mp('yellow','k='+k+' /v='+str(v))
       g[k]=str(v)
      mp('blue','g='+str(g))
      return g
 except Exception as ee:
  mpr('readconfig',ee)

def calcconfig():
    dir = gfunc.getmydir()
    mp('lime', 'dir=' + dir)
    # / home / gonso / common / doors / alpy /
    ls = dir.split('/')
    mp('lime', ' ls=' + str(ls))
    n = len(ls) - 1
    x = ls.pop(n)
    x = ls.pop(n - 1)
    mp('yellow', ' ls=' + str(ls))
    pt = ''
    for x in ls:
        pt = pt + x + ('/'
                       '')
    mp('yellow', ' pt=' + str(pt))
    return pt



#===================mgbs=======================
p=chr(0x27)
ap=chr(0x27)
zp=','

lssyslog=[]

lstopics=[]
mgb={}
mgb['total']=0
mbqt={}
mgb['sucs']='0'
tasks=[]
gprm={}
lsgto=[]
gprm['-ch']='malwrlog'
startline=calcstartline()

gprm=gsfunc.gonsgetp()
gprm['-ch']='malwrlog'
mp('magenta','gprm='+str(gprm))


mbsysinfo=readconfig()
cid='malwrlog'
mgb['cid']=cid
mqclient=connecttobroker(cid,mbsysinfo['letransip'])


mbqt['mqtt']=mqclient
rc,ls=mysubscreibe('tosyslog')
if rc=='ok':
 mp('magenta','ls='+str(ls))

 pgconn = fpgs_connect()
 mp('red','start')
 mgb['pgc'] = pgconn

task = gevent.spawn(timer1s,1)
tasks.append(task)

rmp('blue', 'joinall', 5)
gevent.joinall(tasks)




