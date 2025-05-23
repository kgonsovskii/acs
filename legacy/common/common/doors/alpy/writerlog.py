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



def redlog(txt):
    toredbase(txt)
    return
    txt=str(txt)
    ch=gprm['-ch']
    cd=gfunc.mydatezz()
    ct=gfunc.mytime()
    cds=cd+' '+ct+' '
    appdir=gfunc.getmydir()
    fn=appdir+'redlog'+sep+ch+'.txt'
    print ('redlog fn=',fn)
    outp=open(fn,'a')
    outp.write(cds+txt+'\n')
    outp.flush()
    outp.close()


def mp(c,txt):
 try:
  # spid=mgb['spid']
  if not '-ch' in gprm.keys():
   ch='testdms'
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


def onclftpsrv(sender,g):
    try:


     if not 'cmd' in g.keys(): return

     if 'subcmd' in g.keys() and g['subcmd'] == 'sgrdlife':
        #rmp('cyan', 'oncl =' + str(g),2)
        pass
     #if g['subcmd']=='relay':
     # rmp('blue','g='+str(g),5)
     if g['cmd']=='tosyslog' and g['subcmd']=='tosyslog':
       lsgsyslog.append(g)
       l=len(lsgsyslog)
      # mp('red', 'oncl sens='+g['sens']+'  cmd=' + g['cmd'] + '/subcmd=' + g['subcmd'] )
       #mp('white','NO=========================='+str(g['no'])+' l='+str(l))
       if g['sens']=='rte':
         pass
         #rmp('yellow',str(g),2)
       if 'rcp' in g.keys():
         pass
        #mp('blue','oncl rcp='+str(g['rcp']))
    except  Exception as ee:
     mpr('oncl',ee)

def topgs(g):
 try:
    #mp('blue','TOPGS=' + str(g))
    l=len(lsgsyslog)
    if l>0:
      pass
    l=str(l)
    s=g['evpid']
    lsx=s.split('.')
    bidcomp=lsx[0]
    bidch=lsx[1]
    bidac=lsx[2]
    port=lsx[3]
    ck='-1'
    if 'bidlocsens' in g.keys():
     bidlocsens=str(g['bidlocsens'])
    else:
        bidlocsens='-99'
    if g['sens'] =='key':
        cs='1'
        ck = str(g['code'])
    if g['sens'] == 'open':
        cs = '2'
        ck='-1'
    if g['sens'] == 'close':
        cs = '3'
    if g['sens'] == 'rte':
        cs = '4'
    kpx='-9'
    if g['kpx']=='kpx':   kpx='true'
    if g['kpx'] == 'avt': kpx = 'false'
    if g['sens']=='rte':
     pass
     # mp('red','TUTttttttttttttttttttttttttttttttttttttttttttttttt')
    uxt=stofunc.nowtosec('loc')
    no=str(g['no'])

    if kpx=='false':
     cdcont=str(stofunc.nowtosec('loc'))
     s='insert into tss_syslog(cdcont,bidlocsens,kpx,keycode,rcp,no) values(' +\
     cdcont+zp+\
     bidlocsens+zp+\
     kpx+zp+\
     ck+zp+\
     '0'+zp+\
     str(no)+')'
    else:
     s = 'insert into tss_syslog(tscd,bidlocsens,kpx,keycode,rcp,no) values(' + \
     'current_timestamp'+zp+\
     bidlocsens + zp + \
     kpx + zp + \
     ck + zp + \
     '0' + zp + \
     str(no) + ')'

    mp('white','TOPGS='+s)
    if g['sens'] == 'key':
     pass
    try:
      curs2 = pgconn.cursor()
      curs2.execute(s)
      pgconn.commit()
     # mp('white', 'topgs LSL=' + l + ' ' + s)
    except Exception as ee:
     mpr('topgs',ee)
    pgconn.commit()
 except Exception as ee:
  mpr('topgs',ee)



def calcstartline():
    s1 = sys.argv[0]
    s = ''
    for x in gprm:
        v = str(gprm[x])
        s = s + x + ' ' + v + ' '
    startline = 'python3 ' + s1 + ' ' + s + ' &'
    mp('red', 'startline=' + startline)
    return startline

def timersyslog(interval):
    while True:
      gevent.sleep(interval)
     # mp('white','timersyslog ===============================================================')
      if len(lsgsyslog)>0:
        g = lsgsyslog.pop(0)
        topgs(g)

def timer10s(interval):
  try:
   while True:
    gevent.sleep(interval)
    g = {}
    g['cmd'] = 'writerloglife'
    g['uxt'] = str(stofunc.nowtosec('loc'))
    js = json.dumps(g)
    #mp('red','timer10s  ?????????????????????????')
    lstocomcentr.append(js)
    g['rpcchname'] = gprm['-ch']
    g['pid'] = str(os.getpid())
    g['startline'] = startline
    g['cmd'] = 'writerloglife'
    g['subcmd'] = 'writerloglife'
    clientftpsrv.send(g, 'sgrd')

    #mp('cyan','timer10s............................')
  except Exception as ee:
    mpr('timer10s',ee)

def tocomcentr(js):
  try:
   gin=json.loads(js)
   gin['cmd']='tocomcentr'
   gin['subcmd'] = 'writerloglife'
   gin['target']='totop'
   gin['rsendstate'] = '0'
   clientftpsrv.send(gin,'comcentr')
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



#==================mgbs================================
mgb={}
tasks=[]
gprm={}
lsgsyslog=[]
lstocomcentr=[]
zp=','
ap=chr(0x27)

gprm['-ch']='writerlog'
gprm=gsfunc.gonsgetp()
startline=calcstartline()

pt=gfunc.calcptstarter()
mp('yellow','pt='+pt)

mgb['vbstarter']=gfunc.opendb3(pt,'r')
vb=mgb['vbstarter']
mysysinfo=gfunc.readstarter(vb)
mp('cyan','base='+str(mysysinfo['base']))
mp('cyan','transport='+str(mysysinfo['transport']))
mp('cyan','comcentr='+str(mysysinfo['comcentr']))
gprm['-ch']='writerlog'
pgconn=fpgs_connect()
mgb['pgc']=pgconn

mp('red','start')
rmp('lime','after open base',5)


gprm['-ch']='writerlog'
rpcxname='writerlog'
h='tcp://'+mysysinfo['comcentr']['ip']+':'+mysysinfo['comcentr']['port']
mp('red','h='+h)


clientftpsrv=ccftpsrv(h,rpcxname)
ccftpsrv.on_receive = onclftpsrv
task= gevent.spawn(clientftpsrv.run)
tasks.append(task)


task=gevent.spawn(timertocomcentr,0.1)
tasks.append(task)



task=gevent.spawn(timer10s,10)
tasks.append(task)

task=gevent.spawn(timersyslog,0.001)
tasks.append(task)

rmp('blue','joinall',5)
gevent.joinall(tasks)

