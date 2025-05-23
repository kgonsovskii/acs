#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import gevent,zerorpc
import psycopg2
import datetime
import sys,time,os,traceback,time
import stofunc,gsfunc,gfunc
from os import path, sep
import base64
import json,subprocess
import paho.mqtt.client as mqtt
import random


def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)



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

def formirfix(ac,port,sens,cev):

    lst = ['kpx','kpx','avt' ,'kpx','kpx','kpx','kpx','kpx','kpx','kpx','kpx']
    #lst = ['kpx','avt','kpx']
    kpx=random.choice(lst)
    cev['chx'] = gprm['-ch']
    cev['cmd'] = 'todmsev'
    cev['module']='emul'
    cev['ac']=str(ac)
    cev['sens'] =sens
    cev['kpx']=kpx
    cev['port']=str(port)
    cev['contuxt']=str(stofunc.nowtosec('loc'))
    mbac[ac]['no'] = abs(mbac[ac]['no'])
    mbac[ac]['no']=mbac[ac]['no']+1
    mbac[ac]['total'] = mbac[ac]['total'] +1
    cev['no']=mbac[ac]['no']
    cev['no']= cev['no']* -1
    #if kpx=='avt': mp('white', str(cev))
    return cev
'''
def timerto(interval):
    while True:
      gevent.sleep(interval)
      l=len(lsgto)
      if l>0:
       g=lsgto.pop(0)
       formir_glstojs(g)
'''

def formir_glstojs(g):
   try:
    sj = json.dumps(g)
    topic=g['komu']
    mbqt['mqtt'].publish(topic,sj)
   # mp('red','no='+str(g['no'])+'/ sens='+g['sens'])
   except Exception as ee:
    mpr('glstojs',ee)

def formir0():
 #'interval' cp 'flagrele
    cp=mbac[ac]['cp']
    interval=mbac[ac]['interval']
    cev={}
    for p in range(1,cp+1,1):
       cev[ac]={}
       for sens in mbac[ac]['lsens']:
        cev=formirfix(ac,p,sens,cev)
        mbac[ac]['count']=mbac[ac]['count']+1
        if mbac[ac]['total']>mbac[ac]['limit']:
         # mp('red','total break='+str(mbac[ac]['total']))
          break
        cev['komu']='maldms'
        #mp('yellow', 'cev=' + str(cev))
        formir_glstojs(cev)

def timerwork(interval):
 while True:
  gevent.sleep(interval)
  formir0()


def timer10s(interval):
    while True:
         gevent.sleep(interval)
         #print ('lllllllllllllllllllllllllllllllllllllllllllll')
         sp=(mbac[ac]['count'])/interval
         sp=int(sp)
         mp('cyan','speed='+str(sp)+' TOTAL='+str(mbac[ac]['total']))
         mbac[ac]['count']=0



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

def onmesmqtt(client, userdata, message):

    #gevent.sleep(0.01) #sudasleep
    js=message.payload.decode("utf-8")
    #mp('cyan', 'client=' + str(client.))
    #mp('cyan', 'userdata=' + str(userdata))
    #mp('white' ,'mymqtt ONmes=' + str(js))
    try:
     g=json.loads(js)
     if not 'cmd' in g.keys():return
     if  g['cmd']=='todmsev':
      pass
      #mp('magenta','onmes komu='+g['komu']+' ,'+str(g['no'])+','+str(g['sens']))

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

def getlastno():
    s='select no from tss_syslog where no <0   order by no   limit 1'
    loc=readrow(s)
    if len(loc)==0:return 0
    for row in loc:
     return row[0]



def fpgs_connect():
 try:
  conn = psycopg2.connect(
    host    =mysysinfo['base']['ip'],
    database=mysysinfo['base']['dbn'],
    user="postgres",
    port=5432,
    password=mysysinfo['base']['psw'],)
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')


def selfupd(line):

      try:
          mp('white','selfupd='+line)
          curs = mgb['pgc'].cursor()
          curs.execute(line)
          mgb['pgc'].commit()
      except Exception as ee:
          mpr('selfupd', ee)



def delfromlog():
    s='delete from tss_syslog'
    selfupd(s)

def readrow(s):
   try:
    pgconn = fpgs_connect()
    pgc = pgconn
    curs = pgc.cursor()
    curs.execute(s)
    for i in range (1,3,1):
     try:
      loc = curs.fetchall()
      curs.close()
      return loc
     except Exception as ee:
      mprs('readrow',ee)
      gevent.sleep(0.5)

    return loc
   except Exception as ee:
     mp('red','readrow s???='+s)
     mpr('readrow2',ee)

#==================mgbs================================
p=chr(0x27)
ap=chr(0x27)
zp=','
mgb={}
mbch={}
mbac={}
mbqt={}
lstopics=[]

tasks=[]
gprm={}
gprm=gfunc.gonsgetp()
gprm['-ch']='malemul'


pt=gfunc.calcptstarter()
mp('yellow','pt='+pt)

mgb['vbstarter']=gfunc.opendb3(pt,'r')
vb=mgb['vbstarter']
mysysinfo=gfunc.readstarter(vb)
mbrgg=mysysinfo['rggons']
mp('magenta','mbrgg='+str(mbrgg))

mp('cyan','base='+str(mysysinfo['base']))
mp('cyan','transport='+str(mysysinfo['transport']))
mp('cyan','comcentr='+str(mysysinfo['comcentr']))
#python3 malemul.py -ch 192.168.0.96   -ac  7,1,2,rr -start add -limit 1000  -lsens open,close  &

mbch['ch']=gprm['-ch']

#s=gprm['-ac']    # -ac 7,1,8,rr
s=gprm['-ac']
ls=s.split(',')
ac=int(ls[0])
mbac[ac]={}
mbac[ac]['ac']=ac
mbac[ac]['interval']=int(ls[1])
mbac[ac]['cp']=int(ls[2])
mbac[ac]['flagrele']=ls[3]
s=gprm['-lsens']
ls=s.split(',')
mbac[ac]['lsens']=ls
mp('red','lsens='+str(mbac[ac]['lsens']))

cid='malemul_'+gprm['-ch']+'_'+str(ac)
mgb['cid']=cid
rc=connecttobroker(cid,mysysinfo['transport']['ip'])
rc=mysubscreibe('maldms')
if rc=='ok':
 mp('magenta','ls='+str(ls))
 rc = mysubscreibe(cid)
 if rc == 'ok':
     mp('magenta', 'ls=' + str(ls))

pgconn = fpgs_connect()
mgb['pgc'] = pgconn
mp('red', 'start')
rmp('lime', 'after open base', 5)

t=int(mbac[ac]['interval'])
mp('red','t='+str(t))
mbac[ac]['limit']=int(gprm['-limit'])
mbac[ac]['start']=gprm['-start']
if mbac[ac]['start']=='add':
    mbac[ac]['no']=getlastno()
    mbac[ac]['total'] = 0
    mbac[ac]['count'] = 0
    mbac[ac]['total'] = 0

if mbac[ac]['start'] == 'del':
  delfromlog()
  mbac[ac]['no']=0
  mbac[ac]['count']=0
  mbac[ac]['total'] = 0

#task = gevent.spawn(timerto,0.5)
#tasks.append(task)



gevent.sleep(1)
if '-regim' in gprm.keys() and gprm['-regim']=='self':
 task = gevent.spawn(timerwork,t)
 tasks.append(task)
else :
    pass
mp('red','gprm='+str(gprm))
task = gevent.spawn(timer10s,5)
tasks.append(task)

rmp('blue','joinall',5)
gevent.joinall(tasks)







