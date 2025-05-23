#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time

import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import mqtransmod
import psycopg2
import base64
import json,subprocess

def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='testdms'
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




def calcstartline():
    s1 = sys.argv[0]
    s = ''
    for x in gprm:
        v = str(gprm[x])
        s = s + x + ' ' + v + ' '
    startline = 'python3 ' + s1 + ' ' + s + ' &'
    mp('cyan', 'startline=' + startline)
    return startline




def formirroad(g,road,metod):
    gx={}
    gx['road'] = road
    gx['metod'] = metod
    gx['gbody'] = g
    slgroad.append(gx)


def jstogls(js):
    try:
     g = json.loads(js)
     #mp('cyan','jstogls g='+str(g))
     return g
    except Exception as ee:
        return None


def timer01s(interval):
    while True:
     gevent.sleep(interval)
     l=len(mqtransmod.sljsin)
    # mp('cyan','timer01s l='+str(l))
     if l>0:
      #mp('cyan','timer01s l='+str(l))
      #while len(mqtransmod.sljsin)>0:
      js=mqtransmod.sljsin.pop(0)
      g=jstogls(js)
      if 'komu' in g.keys():
       komu = g['komu']
       if g['cmd']=='vtodms':
        pass
       # mp('red', 'timer01s g=' + str(g))
       if 'sens' in g.keys() and g['sens']=='key':
        g['code']=gfunc.keytox(g['kluch'])
       g['rsendstate'] = '0'
       formirroad(g, komu, 'rpc')

      if 'subcmd' in g.keys()  and  g['subcmd']=='ac_wkpx_avt':
        rmp('magenta',g['subcmd'],5)

      else:
       pass



#     mgbs================================================================
p=chr(0x27)
ap=chr(0x27)
zp=','
gprm={}
gprm['-ch']='altestlife'
slgroad=[]
mgb={}
mgb['sucs']='0'
tasks=[]
gprm={}
mbalgol={}
lsginev=[]  # list of events
glsportparam={}
lsgitog=[]
lstocomcentr=[]
startline=calcstartline()

gprm=gsfunc.gonsgetp()
gprm['-ch']='altestlife'
mp('cyan','gprm='+str(gprm))

pt=gfunc.calcptstarter()
mp('yellow','pt='+pt)


mgb['vbstarter']=gfunc.opendb3(pt,'r')
vb=mgb['vbstarter']
mysysinfo=gfunc.readstarter(vb)
mbrgg=mysysinfo['rggons']
mp('cyan','mbrgg='+str(mbrgg))
#sys.exit(77)
mp('cyan','base='+str(mysysinfo['base']))

mp('cyan','transport='+str(mysysinfo['transport']))
mp('cyan','comcentr='+str(mysysinfo['comcentr']))

pgconn=fpgs_connect()
mgb['pgc']=pgconn
rmp('lime','after open base',5)


mqttclient=mqtransmod.connecttobroker('comcentr',mysysinfo['transport']['ip'])
mqttclient.loop_start()  # start the loop



task=gevent.spawn(timer01s,0.01)
tasks.append(task)
gevent.joinall(tasks)

