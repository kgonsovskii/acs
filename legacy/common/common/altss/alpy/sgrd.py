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


class ccftpsrv(zerorpc.Client):
    on_receive = None

    def __init__(self, endpoint, name):
        super(ccftpsrv, self).__init__(endpoint)
        self.name = name

    def run(self):
        while True:
            try:
                # print ('rrrrrrrrrrrrrrrrrr')
                for data in self.pull(self.name):
                    if self.on_receive is not None:
                        self.on_receive(data)
            except Exception as ee:
                pass
                # mp('yellow','ccftpsrv.run ???='+str(ee))

    def send(self, data, *clients):
        try:
            self.publish(data, *clients)
        except:
            return False
        return True

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
   ch='sgrd'
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



def toroad(g):
  try:
   gb=g['gbody']
   road=g['road']
   gx = g['gbody']

   try:
    #gx['rsendstate']='1'
    clientftpsrv.send(gx, road)


   #mp('red','road='+str(road))
   except Exception as ee:
    mprs('toroad ROAD======================================================='+road,ee)
  except Exception as ee:
   mpr('toroad',ee)


def timerroad(interval):
  while True:
   try:
    gevent.sleep(interval)
   except Exception as ee:
    mp('magenta','timerroad ee='+str(ee))
   if len(slgroad)>0:
    g=slgroad.pop(0)
    toroad(g)


def formirroad(g,road,metod):
    gx={}
    gx['road'] = road
    gx['metod'] = metod
    gx['gbody'] = g
    slgroad.append(gx)


def timertestrpc(interval):
    while True:
        gevent.sleep(interval)
        g={}
        g['cmd']='timertestrpc'
        g['subcmd'] = 'timertestrpc'
        formirroad(g,'sgrd','rpc')


def checksubsys():
   try:
    # rmp('white', '   NNN checksubsys='+str(mbsubsys)[0:100],3)
     for nm in mbsubsys:
     # mp('yellow','checksubsys nm='+str(nm))
      g=mbsubsys[nm]
      t1=int(g['uxt'])
      sl=g['startline']
      t2=stofunc.nowtosec('loc')
      d=t2-t1
      s ='checksubsys name=%20s,DELTA=%4s' \
      % (nm,str(d))
      #mp('yellow',s)
      if abs(d)>10:
       rmp('red','долго нет отметки ',5)
   except Exception as ee:
    mpr('checksubsys',ee)


def  formirbg(g):
   try:
   # mp('white', 'formirbg='+str(g))
    k=g['rpcchname']
    if k not in mbsubsys.keys():
     mbsubsys[k]={}
    mbsubsys[k]['name'] = g['rpcchname']
    mbsubsys[k]['pid']=g['pid']
    mbsubsys[k]['startline'] = g['startline']
    mbsubsys[k]['uxt'] = g['uxt']
   except Exception as ee:
    mpr('formirbg',ee)

[]
def onclftpsrv(sender,g):
    try:
     if not 'cmd' in g.keys(): return
     #mp('red', 'oncl CMD=' + str(g['cmd']))
    # mp('red','oncl============================'+str(g)[0:50])
     if g['cmd']=='chlife' or g['subcmd']=='chlife':
      formirbg(g)
     if g['cmd'] == 'dmslife' or g['subcmd'] == 'dmslife':
      formirbg(g)
     if g['cmd'] == 'writerloglife' or g['subcmd'] == 'writerloglife':
      formirbg(g)
     if g['cmd'] == 'comcentrlife' or g['subcmd'] == 'comcentrlife':
       formirbg(g)

     if g['cmd']=='tosylog':
       lsgsyslog.append(g)
      # mp('cyan','oncl='+str(g))
    except  Exception as ee:
     mpr('oncl',ee)



def tocomcentr(js):
  try:
   gin=json.loads(js)
   gin['cmd']='tocomcentr'
   gin['subcmd'] = 'sgrdlife'
   gin['target']='totop'
   gin['rsendstate'] = '0'
   # clientftpsrv.send(gin,'comcentr')
   clientftpsrv.send(gin)
  # mp('red','NEW tocomcentr='+str(gin))
  except Exception as ee:
   mpr('tocomcentr',ee)




def timertocomcentr(interval):
     while True:
      gevent.sleep(interval)
      l=len(lstocomcentr)
      if l>0:
       js=lstocomcentr.pop(0)
       tocomcentr(js)

def timer10s(interval):
  try:
   while True:
    gevent.sleep(interval)
    checksubsys()
    g = {}
    g['cmd'] = 'sgrdlife'
    g['subcmd'] = 'sgrdlife'
    g['pid']=str(os.getpid())
    g['uxt'] = str(stofunc.nowtosec('loc'))
    js = json.dumps(g)
    #mp('red','timer10s  ?????????????????????????')
    lstocomcentr.append(js)
    #mp('cyan','timer10s............................')
  except Exception as ee:
    mpr('timer10s',ee)




#==================mgbs================================
mgb={}
slgroad=[]
tasks=[]
gprm={}
lsgsyslog=[]
lstocomcentr=[]
mbsubsys={}
zp=','
ap=chr(0x27)

gprm['-ch']='sgrd'
gprm=gsfunc.gonsgetp()
pt=gfunc.calcptstarter()
mp('yellow','pt='+pt)

mgb['vbstarter']=gfunc.opendb3(pt,'r')
vb=mgb['vbstarter']
mysysinfo=gfunc.readstarter(vb)
mp('cyan','base='+str(mysysinfo['base']))
mp('cyan','transport='+str(mysysinfo['transport']))
mp('cyan','comcentr='+str(mysysinfo['comcentr']))

pgconn=fpgs_connect()
mgb['pgc']=pgconn
rmp('lime','after open base',5)

rpcxname='sgrd'
h='tcp://'+mysysinfo['comcentr']['ip']+':'+mysysinfo['comcentr']['port']
mp('red','h='+h)

clientftpsrv=ccftpsrv(h,rpcxname)
ccftpsrv.on_receive = onclftpsrv
task= gevent.spawn(clientftpsrv.run)
tasks.append(task)


task=gevent.spawn(timertocomcentr,0.1)
tasks.append(task)


task=gevent.spawn(timertestrpc,3)
tasks.append(task)



task=gevent.spawn(timer10s,10)
tasks.append(task)


rmp('blue','joinall',5)
gevent.joinall(tasks)



