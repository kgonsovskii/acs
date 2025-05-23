#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import psycopg2
import base64
import json,subprocess
import paho.mqtt.client as mqtt
import socket
import time

class algonsdt():
    def __init__(self):
        self.year  =0
        self.month =0
        self.day   =0
        self.hour  =0
        self.minute=0
        self.second=0

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





def mysubscreibe(topic):
    try:
     mbqt['mqtt'].subscribe(topic)
     lstopics.append(topic)
     return 'ok',lstopics
    except Exception as ee:
     mpr('mysubscreibe',ee)
     return str(ee),lstopics

def simuldelacfromlist(ac):
   try:
       addexlist(ac)
       try:
        s=str(mbch['exaddrs'])
        mp('yellow','BEFORE EXLIST= '+s)
        mbch['addrs'].remove(ac)

       except Exception as ee:
         mprs('simuldelacfromlist',ee)
       mbacl[ac]['cev'] = 0
       tobase_acerr(ac, 'addrs=' + str(mbch['addrs']),-6)
       s = str(mbch['exaddrs'])
       rmp('yellow', 'AFTER  EXLIST= ' + s,10)

   except Exception as ee:
     mpr('delacfromlist',ee)

def onmesmqtt(client, userdata, message):
   try:
    js=message.payload.decode("utf-8")
    g=json.loads(js)
    if not 'cmd' in g.keys():return

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ch_active':
        rmp('yellow', 'g=' + str(g), 3)
        mbch['active']=True
    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ch_notactive':
        rmp('yellow', 'g=' + str(g), 3)
        mbch['active']=False


    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_genkeys':
     rmp('yellow', 'g=' + str(g), 3)
     ac = int(g['ac'])
     gx={}
     gx['body']=g
     glslongscmd.append(gx)

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_test_readallkeys':
     rmp('yellow', 'g=' + str(g), 3)
     gx = {}
     gx['body'] = g
     glslongscmd.append(gx)

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_test_delallkeys':
     rmp('yellow', 'g=' + str(g), 3)
     gx = {}
     gx['body'] = g
     glslongscmd.append(gx)

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_wkpx_avt':
     rmp('yellow', 'g=' + str(g), 3)
     ac = int(g['ac'])
     mbacl[ac]['kpx']='avt'
    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_wkpx_kpx':
        rmp('yellow', 'g=' + str(g), 3)
        ac = int(g['ac'])
        mbacl[ac]['kpx'] ='kpx'

    if 'cid' in g.keys() and g['cid']==mgb['cid'] and g['cmd']=='ac_simulbad':
     rmp('yellow','g='+str(g),3)
     ac=int(g['ac'])
     mbacl[ac]['limitinfoerr']=101
     simuldelacfromlist(ac)

    if 'sens' in g.keys() and g['sens']=='rte':
     pass
     #mp('lime','onmes='+str(g))
    if 'subcmd' in g.keys() and 'glsbody' in g.keys() \
     and g['subcmd']=='releon' and mgb['cid']==g['cid']:
    # rmp('cyan','onmes'+str(g),2)
     gb=g['glsbody']
    # mp('magenta','NEW ONMES g='+str(g))
     t=int(gb['tmr'])*2
     g={}
     g['ac']=int(gb['ac'])
     g['port'] = int(gb['port'])
     g['tmr'] = t
     mblsrelay.append(g)

   except Exception as ee:
     mprs ('onmes ee=',ee)


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



def timer1s(interval):
    while True:
      gevent.sleep(interval)
      g={}
      g['uxt']=stofunc.nowtosec('loc')
      g['komu']='maldms'
      g['cid']=mgb['cid']
      #mp('white',str(g))
      sj = json.dumps(g)
      topic = g['komu']
      try:
          mbqt['mqtt'].publish(topic, sj)
      except Exception as ee:
       mpr('timer1s',ee)


def crip(ch):
 atp=0
 while True and atp<20:
   try:
    atp=atp+1
    mp('cyan','crip ch='+ch)
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.07    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
   # chskd.flush_input()
    gevent.sleep(1)
    rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',30)
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))


def fpgs_connect ():
 try:
  mp('lime','BEFORE='+str(mbsysinfo))
  conn = psycopg2.connect(
    host    =mbsysinfo['lebaseip'],
    database='postgres',
    user='postgres',
    port=int(mbsysinfo['lebaseport']),
    password=mbsysinfo['lebasepsw'])

  rmp('lime','OPENBASE OK='+str(mbsysinfo['lebaseip']),5)
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')

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

def readchparam(p):
    try:
        s='select ' \
        ' tss_comps.name,'\
        ' tss_comps.myid,'\
        ' tss_ch.myid ,' \
        ' tss_ch.lobs' \
          ' from tss_comps, tss_ch'\
        ' where '\
        ' tss_ch.actual=true ' \
        'and tss_comps.myid = tss_ch.bp '\
        ' and tss_ch.ch='+ap+gprm['-ch']+ap
        mp('cyan','readchparams s='+s)
        #mp('red', 'readchparams s=' + s)
        pgc =pgconn
        curs2 = pgc.cursor()
        curs2.execute(s)
        loc = curs2.fetchall()
        mp('yellow','s='+s)
        for row in loc:
            comp           = row[0]
            mgb['bidcomp'] = str(row[1])
            mgb['bidch']   = str(row[2])
            mgb['lobs'] =    str(row[3])
            mp('lime','comp='+comp+' /bidcomp='+mgb['bidcomp']+' / bidch='+mgb['bidch'])

        curs2.close
        print('cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc')


    except Exception as ee:
        row = None
        mpr('readchparam', ee)
        return None




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

def formirmbch():
    s='select myid from tss_comps where name='+ap+mgb['comp']+ap
    bidcomp=str(readfld(s))
    mp('cyan', s)
    s='select myid from tss_ch where ch='+ap+gprm['-ch']+ap+' and bp='+bidcomp
    mp('cyan',s)
    bidch=str(readfld(s))
    s = 'select rint1 from tss_ch where ch=' + ap + gprm['-ch'] + ap + ' and bp=' + bidcomp
    mp('cyan', s)
    rint1 = str(readfld(s))
    s = 'select rint2 from tss_ch where ch=' + ap + gprm['-ch'] + ap + ' and bp=' + bidcomp
    mp('cyan', s)
    rint2 = str(readfld(s))
    s = 'select rint3 from tss_ch where ch=' + ap + gprm['-ch'] + ap + ' and bp=' + bidcomp
    mp('cyan', s)
    rint3 = str(readfld(s))
    g={}
    s = 'select chch from tss_ch where ch=' + ap + gprm['-ch'] + ap + ' and bp=' + bidcomp
    mp('cyan', s)
    chch= str(readfld(s))
    g['chch']=chch
    g['bidcomp'] = bidcomp
    g['bidch']=bidch
    g['rint1']=0.3
    g['rint2']=0.001
    g['rint3']=0.1
    g['cev']=0
    g['speed']=0
    g['active']=False
    g['getdt'] = False
    g['exaddrs']=[]
    g['cherrors']=0
    g['exclcount']=0
    g['kofexcl']=0
    return g


def readrow(s):

   # pgconn = fpgs_connect()
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

def mydt_to_tssdt():
   try:
     tssdt=algonsdt()
     # return tssdt
     cd=gfunc.mydatezz()
     ct=gfunc.mytime()[0:8]

     ls=cd.split('.')
     tssdt.year=int(ls[0])-2000
     tssdt.month=int(ls[1])
     tssdt.day  =int(ls[2])
     sd=str(tssdt.year)+'.'+str(tssdt.month)+'.'+str(tssdt.day)
     ls=ct.split(':')
     # mp('red','mydt_to_tssdt ls='+str(ls))
     tssdt.hour=int(ls[0])
     tssdt.minute=int(ls[1])
     tssdt.second=int(ls[2])
     s=str(tssdt.year)+','+str(tssdt.month)+','+str(tssdt.hour)+','+str(tssdt.minute)+','+str(tssdt.second)
     st=str(tssdt.hour)+':'+str(tssdt.minute)+':'+str(tssdt.second)
     return tssdt
   except Exception as ee:
     mpr('mydt_to_tssdt',ee)



def al_setdt_ac(ac):
    try:
        tssdt=mydt_to_tssdt()
        mbch['chskd'].set_dt(ac,tssdt)
        mp('lime','al_setdt_ac='+str(ac)+'tssdt= '+str(tssdt))
    except Exception as ee:
        mpr('al_setdt_ac', ee)
        pass


def tobase_acerr(ac,erm,code): # from drv209
  try:
    cdate = gfunc.mydatezz()
    cdate = cdate.replace('.', '-')
   # redlog('tobase_acerr ac='+str(ac)+' /erm='+erm)
    zp=','
    #if ac==-1:
    if len(mbch['addrs'])==0:
     speed=0
    else :
       speed=mbch['speed']
    s='insert into tss_acerr(ac,cdate,ctime,speed,bpcomp,bpch,code,counterr,erm)values( '+ \
    str(ac)+zp+\
    ap+cdate+ap+zp+\
    ap+gfunc.mytime()[0:8]+ap+zp+\
    str(speed)+zp+\
    str(mgb["bidcomp"]) + zp + \
    str(mbch["bidch"])+zp+\
    str(code)+zp+\
    str(mbch['cherrors'])+zp+\
    ap + erm + ap + \
    ');'
    rmp('magenta', 'tobase_acerr=' + s,2)
    g={}
    g['cmd']='acerr'
    g["bidcomp"]=mgb["bidcomp"]
    g['bidch'] = str(mbch['bidch'])
    g['code']  = str(code)
    g['ac']    = str(ac)
    g['erm']   = str(erm)
    sj = json.dumps(g)
    topic = 'maldms'
    mbqt['mqtt'].publish(topic, sj)  # sudamqt
    curs2 = pgconn.cursor()
    curs2.execute(s)
    pgconn.commit()
    curs2.close()
  except Exception as ee:
   mpr('tobase_acerr',ee)





def readfld(s):
  try:
   loc=readrow(s)
   for row in loc:
    return row[0]
  except Exception as ee:
   mpr('readfld',ee)

def formirmbacl(ls):
 g={}
 for ac in ls:
  g[ac]={}
  s='select myid from tss_acl where ac='+str(ac) +' and bp='+str(mbch['bidch'])
  g[ac]['bidac']=str(readfld(s))
  g[ac]['kpx']='kpx'
  g[ac]['totalcev'] =0
  g[ac]['cno']=-1
  g[ac]['buzy']=False      # контроллер занят другой операцией (запись ключей ...)
  g[ac]['cerr']=0          # общее кол-во ошибок на этом контроллере
  g[ac]['currerr']=0       # текущее кол-во ошибок до первого успешного события
  s='select limitinfoerr from tss_acl where ac='+str(ac)+' and bp='+str(mgb['bidch'])
  g[ac]['cev']=0
  mp('lime','s='+s)
  g[ac]['limitinfoerr']=readfld(s)
 return g
def convertwiegand(k):
 return k ^ 0x3FFFFFF

def formircev(ev):
    try:
        ac=ev.addr
        g = {}
        g['cmd'] = 'todmsev'
        g['komu'] = 'maldms'
        g['cid']=mgb['cid']
        g['sens'] = 'undef'
        cl = 'red'
        g['tmm1'] = str(time.time())
        if ev.is_complex:
         kpx='kpx'
        else:
         kpx='avt'
        g['kpx']=kpx
        gx = gfunc.al_209dt(ev.addr, ev.dt)
        g['dt'] = gx['dt']
        pt = '.'

        uxtc = stofunc.datetimetosec(g['dt'], 'sql')
        g['chx']=mbch['ch']
        g['contuxt']=str(uxtc)
        uxtp = stofunc.nowtosec('loc')
        g['delta'] = str(uxtp - uxtc)
        delta=abs(uxtp - uxtc)
        if delta>=20 and kpx=='kpx':al_setdt_ac(ev.addr)
        g['no'] = str(ev.no)
        g['ac'] = str(ev.addr)
        g['port'] = str(ev.port)
        cerr = str(mbacl[ac]['cerr'])
        if isinstance(ev, acs.EventDoor):
            if ev.is_open:
                g['sens'] = 'open'
                cl='yellow'
            else:
                g['sens'] = 'close'
                cl='white'
        if isinstance(ev, acs.EventButton) :
            cl = 'cyan'
            g['sens'] = 'rte'
        if isinstance(ev, acs.EventKey):
         g['sens']='key'
         cl='lime'
         ik = convertwiegand(ev.code)
         g['Ikluch'] = str(gfunc.xkeytos(ik))
         g['code'] = str((ev.code))

         if g['kpx']=='kpx':
          try:
           pass
          # mbch['chskd'].relay_on(int(g['ac']), int(g['port']),1)
          except Exception as ee:
            mprs('formircev',ee)
         if '-ich' in gprm.keys() and gprm['-ich']=='y' and g['sens'] == 'key':
             pass
             g['code'] = str(8556084)
             g['kluch'] = '000000828E34'
         else:
          g['kluch']=gfunc.xkeytos(ev.code)
        if g['sens']=='key':
           s='kpx=%3s,ev=%4s ,ac=%3s,no=%6s ,p=%2s, dt=%8s,delta=%3s,'\
             'code=%6s,KLUCH=%12s,CERR=%5s'\
           % (g['kpx'], g['sens'], g['ac'], g['no'], g['port'], g['dt'], g['delta'], g['code'],g['kluch'],cerr)
           mp(cl,s)
        else:
          s = 'kpx=%3s,ev=%4s ,ac=%3s,no=%6s ,p=%2s, dt=%8s,delta=%3s,CERR=%5s' \
          % (g['kpx'], g['sens'], g['ac'], g['no'], g['port'], g['dt'], g['delta'],cerr)
          mp(cl, s)
        if g['sens']=='rte' and g['kpx']=='kpx':
         mp('lime','FORMIRCEV RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR')
       #  mbch['chskd'].relay_on(int(g['ac']),int(g['port']),3)
        #lsgtodms.append(g)
        g['cid']=mgb['cid']
        sj = json.dumps(g)
        topic ='maldms'    # g['komu']
        mbqt['mqtt'].publish(topic, sj)    #sudamqt
        mp('cyan', 'FORMIRCEV TO  MQT sens='+g["sens"]+'-------->')
    except Exception as ee:
      mpr('formircev',ee)


def checkno(ac,ev):
    try:
     ac=ev.addr
     no=ev.no
    # mp('yellow','checkno ac='+str(ac)+zp+'no='+str(no))
     if no==65535:
      mbacl[ac]['cno'] = 1
      nn=1
     if mbacl[ac]['cno'] ==-1:
        mbacl[ac]['cno'] = no
        nn=no
     if  mbacl[ac]['cno'] !=1 :
         mbacl[ac]['cno']=no+1
         nn=no+1
     d=abs(no-mbacl[ac]['cno'])
     if d>1 :
      s='CHECKNO ac='+str(ac)+zp+'no='+str(no)+zp+'newno='+str(mbacl[ac]['cno'])
      mp('red',s)
     else :
        pass
     return


    except Exception as ee:
     mprs('checkno',ee)

def mypoll():

    while True:
     try:
      chskd = mbch['chskd']
      gevent.sleep(0.005)
      if mbch['active'] :
       if len(mblsrelay)>0:
            try:
              g=mblsrelay.pop(0)
              mbch['chskd'].relay_on(int(g['ac']), int(g['port']), g['tmr'])
            except Exception as ee:
             mprs('mypoll',ee)
          # print ('mypoll addrs='+str(addrs))
       for ac in mbch['addrs']:
          #print ('ac=',ac)
          if  mbacl[ac]['kpx']=='kpx'  and  mbacl[ac]['buzy'] == False  :
              gevent.sleep(0.03)

             # if mbacl[ac]['totalcev'] % 100 == 0: #sudatotal
             #   rmp('cyan','AC='+str(ac)+zp+' TOTAL='+str( mbacl[ac]['totalcev']),5)
             #   getdtonpoll()
              try:
                ev=None

                ev = chskd.get_event(ac, True)
                gevent.sleep(0.001) #df around 0.02 #sudasleep  0.01   df around 0.02
                mbch['cev'] = mbch['cev'] + 1
                mbacl[ac]['cev']=mbacl[ac]['cev']+1
                mbacl[ac]['totalcev']=mbacl[ac]['totalcev']+1
                   # mp('yellow','TOTAL===============================' +str(mbacl[ac]['totalcev']))
                mbacl[ac]['cerr'] = 0
                if ev != None:
                     checkno(ac, ev)
                     cev = formircev(ev)
              except Exception as ee:
                 mbacl[ac]['cerr'] = mbacl[ac]['cerr'] + 1
                 mbch['cherrors']=mbch['cherrors']+1
                 analyzee(ac,ee)
     except Exception as ee:
       mpr('mypoll',ee)


def readacl():
  try:
    ls=[]
    g={}
    s='select myid,ac,actual,limitinfoerr,limitcrasherr from tss_acl where bp='+str(mbch['bidch']) +' and actual=True'
    mp('lime','readacl='+s);
    mp('white', 'readacl=' + s);
    mp('lime', 'readacl=' + s);
    pgc = pgconn
    curs2 = pgc.cursor()
    curs2.execute(s)
    loc = curs2.fetchall()
    for row in loc:
        ac = row[1]
        g[ac]={}
        myid = row[0]

        limitinfoerr  =row[3]
        limitcrasherr = row[4]
        g['ac']=ac
        g[ac]['bidac']=myid
        mp('blue',str(g[ac]['bidac']))  #####################################
        g[ac]['init'] = 0  # кол-во ошибок типа msg
        g[ac]['cerr'] = 0  # текущее кол-во ошибок
        g[ac]['speed'] = 0  # from mbch
        g[ac]['toterr'] = 0  # суммарное кол-во ошибок
        g[ac]['limitinfoerr'] = limitinfoerr  # 1-й предел   кол-ва ошибок
        g[ac]['limitcrasherr'] = limitcrasherr   # 2-й предел   кол-ва ошибок (avost for ac)
        g[ac]['countevsuc'] = 0  # кол-во успешных get_event
        g[ac]['counteverr'] = 0  # кол-во ошибок get_event
        g[ac]['wkpx'] = 0
        g[ac]['sem1'] = 0  # усли 0   опрос пазрешен
        g[ac]['buzy']=False
        g[ac]['kpx'] ='kpx'
        g[ac]['cerr'] =0
        print(' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@222')
        g[ac]['kpx'] = 'kpx'
        g[ac]['buzy'] = False  # контроллер занят другой операцией (запись ключей ...)
        g[ac]['cerr'] = 0  # общее кол-во ошибок на этом контроллере
        g[ac]['currerr'] = 0  # текущее кол-во ошибок до первого успешного события

        ls.append(ac)
        mp('blue','??? g='+str(g))
    return g,ls

  except Exception as ee:
      row = None
      mpr('readacl', ee)
      return None




def formirmbacl(ls):
 g={}
 for ac in ls:
  g[ac]={}
  s='select myid from tss_acl where ac='+str(ac) +' and bp='+str(mbch['bidch'])
  g[ac]['bidac']=str(readfld(s))
  g[ac]['kpx']='kpx'
  g[ac]['totalcev'] =0
  g[ac]['cno']=-1
  g[ac]['buzy']=False      # контроллер занят другой операцией (запись ключей ...)
  g[ac]['cerr']=0          # общее кол-во ошибок на этом контроллере
  g[ac]['currerr']=0       # текущее кол-во ошибок до первого успешного события
  s='select limitinfoerr from tss_acl where ac='+str(ac)+' and bp='+str(mgb['bidch'])
  g[ac]['cev']=0
  mp('lime','s='+s)
  g[ac]['limitinfoerr']=readfld(s)
 return g


def fbidsexcl():
  try:
    s=''
    for ac in mbch['exaddrs']:
     s = str(ac) + ',' + str(mbacl[ac]['bidac'])
    return s
  except Exception as ee:
      mpr('fbidsexcl', ee)


def fbidsaddrs():
  try:
    s=''
    for ac in mbch['addrs']:
     s = str(ac) + ',' + str(mbacl[ac]['bidac'])
    return s
  except Exception as ee:
   mpr('fbidsaddrs',ee)


def frmchstatus(ac,subcmd):
   try:
    g = {}
    g['komu']    = 'tomain'
    g['cmd']     = 'chstatus'
    g['bidch']   = mbch['bidch']
    g['bidcomp'] = mbch['bidcomp']
    g['addrs']=str(mbch['addrs'])
    g['bidsaddrs'] = str(fbidsaddrs())
    g['bidsexclbid'] = str(fbidsexcl())
    g['excl'] = str(mbch['exaddrs'])

    g['subcmd']=subcmd
    g['ch']=mbch['ch']

    if subcmd == 'chinfo':
     tobase_acerr(-1, 'addrs=' + str(mbch['addrs']),0)
    if subcmd=='excl':
      g['wav']='alarm1.wav'
      tobase_acerr(ac,'excl='+str(mbch['exaddrs']),-5)
    else:

        g['wav']='acincl.wav'
        g['kto'] = mgb['cid']
        g['ch'] = mbch['ch']
        g['bidch'] = mbch['bidch']
        g['bidcomp'] = mbch['bidcomp']
        g['uxt'] = str(stofunc.nowtosec('loc'))
        g['excl'] = str(mbch['exaddrs'])
        g['bidsaddrs'] = fbidsaddrs()
        g['addrs'] = str(mbch['addrs'])
        g['pid'] = str(os.getpid())
    tobase_acerr(ac,'incl=' + str(mbch['exaddrs']),5)
    rmp('white', 'frmchstatus=' + str(g), 2)
    #sudaexcl
   except Exception as ee:
    mpr('frmchstatus',ee)




def timerrest(interval):
    while True:
      gevent.sleep(interval)
      gevent.sleep(interval)
      try:
          rmp('gray', 'timerrest addrs='+str(mbch['addrs'])+' /exaddrs='+str(mbch['exaddrs']),2)
          while len(mbch['exaddrs'])>0:
            x=mbch['exaddrs'].pop(0)
            mbch['addrs'].append(x)
            mbacl[x]['cerr']=0
            frmchstatus(x,'incl')
            mp('yellow','APPEND=============='+str(x))

          rmp('white','ADDRS='+str(mbch['addrs'])+',EXADDRS='+str(mbch['exaddrs'])+zp+'KOFEX='+str(mbch['kofexcl']),1)
      except  Exception as ee:
           mpr('timerrest',ee)




def xflush():
    try:
        return
        chskd = mbch['chskd']
        chskd.flush_input()
        s=' FLUSH '*5
        rmp('yellow', s, 1)
    except Exception as ee:
      mprs('xflush',ee)

def  addexlist(ac):
   try:
    n=mbch['exaddrs'].index(ac)
    mp('white','n='+str(n))
   except Exception as ee:
    mbch['exaddrs'].append(ac)
    mp('yellow','NEW EXLIST='+str(mbch['exaddrs']))
    mbch['exclcount']=mbch['exclcount']+1


def fplay(wav):
    pt = calcconfig()
    ptf = pt + 'wav/'+wav
    cmd='aplay '+ptf
    rmp('cyan', 'fplay=' + cmd, 30)
    os.system(cmd)



def fbrp(es):
   try:
     s=es
     n1=-1
     n2=-1
     #rmp('yellow','brp                ????????????????????????????????????',30)
     
     n1=es.index('broken')
   except Exception as ee:
    pass
   try:
    n2 = es.index('pipe')
   except Exception as ee:
        pass
   if n1>=0 and n2>=0:

    rmp('yellow','BRP brp n1='+str(n1)+zp+'n2='+str(n2),20)
    ls=[]
    mp('red','brokenpipe')
    tobase_acerr(-1,es,-10)

    pid = str(os.getpid())
    ls.append('sudo kill +pid ')
    ls.append('python3 tzx1.py -ch '+' '+gprm['-ch']+\
    ' -start poll  -startdms n -startwrlog n &')
    appdir=gfunc.getmydir()
    fn=appdir+'rbp.sh'
    rmp('yellow', 'fn=' + fn, 10)
    gevent.sleep(2)
    outp=open(fn,'w')
    outp.writelines(ls)
    outp.flush()
    outp.close()
    s='chmod +x '+fn
    os.system(s)
    gevent.sleep(3)
    os.system(fn)
    rmp('lime','fn='+fn,10)
    fplay('ping1.wav')







def analyzee(ac,ee):
  #  mprs('analyzee ac='+str(ac),ee)
    ac=int(ac)
    es = str(ee)
    es=es.lower()
    fbrp(es)
    xflush()
    try:
     if mbacl[ac]['cerr']>=mbacl[ac]['limitinfoerr']:
      mp('yellow','analyzee ac='+str(ac)+',cerr='+str(mbacl[ac]['cerr'])+',ee='+str(ee))
      addexlist(ac)
      mbch['addrs'].remove(ac)
      mbacl[ac]['cev']=0
      frmchstatus(ac,'excl')
      #fplay('ping1.wav')
      rmp('magenta','???????????????analyze addrs='+str(mbch['addrs']),3)


    except :pass



def razborinmes():
    return
    if len(lsinjs)==0 : return
    g=lsinjs.pop(0)
    rmp('cyan','g='+str(g),5)
    mbch['chskd'].find_addrs()
    if g["cmd"]=='find_addrs':
     addrs=mbch['chskd'].find_addrs()
     rmp('lime','addrs='+str(addrs),20)


def timertest5(interval):
    while True:
            gevent.sleep(interval)
            g = {}
            g['komu'] = 'tomain'
            g['cmd'] = 'xxxxx'
            g['kto'] = mgb['cid']
            g['bidch'] = mbch['bidch']
            g['bidcomp'] = mbch['bidcomp']
            g['uxt'] = str(stofunc.nowtosec('loc'))
            g['pid'] = str(os.getpid())
            sj = json.dumps(g)
            topic = 'maldms'
            mbqt['mqtt'].publish(topic, sj)  # sudamqt
            mp('cyan','TEST5 SEND='+str(g))

def timer30s(interval):
    while True:
        gevent.sleep(interval)
        try:
          rmp('yellow','timer30s',20)
          s='aclist='+str(mbch['addrs'])+zp+'speed='+str(mbch['speed'])
          tobase_acerr(-1,s,0)
        except Exception as ee:
          mpr('timer10s',ee)


def timer10s(interval):
 while True:
  gevent.sleep(interval)
  try:
    # fbrp(' broken pipe')
     g={}
     g['komu'] = 'tomain'
     g['cmd']='life'
     g['kto']=mgb['cid']
     g['ch']=mbch['ch']
     g['bidch']=mbch['bidch']
     g['bidcomp'] = mbch['bidcomp']
     g['uxt']=str(stofunc.nowtosec('loc'))
     g['excl']=str(mbch['exaddrs'])
     g['pid']=str(os.getpid())
    # rmp('white','timer10s='+str(g),2)
     #formircliz('tomain',g)

     if not mbch['active']:
      mp('cyan','ожидаю активации канала')
     if mbch['active']:
         for ac in addrs:
          s = 'ac=%3s,CERR=%4s' % (ac,mbacl[ac]['cerr'])
          mp('cyan',s)
         razborinmes()
         sp=str(int(mbch['cev']) / (interval))
         mbch['cev']=0
         mbch['speed']=sp
         kf = mbch['exclcount'] / interval
         kf = str(round(kf, 1))
         mbch['kofexcl'] = kf
        # rmp('blue', ' KOFEXCL=' + kf, 3)
         mbch['exclcount'] = 0
         rmp('white', 'SPEED=' + str(mbch['speed'])+zp+' KOFEXCL='+kf, 1)

         g= {}
         g['komu']='tomain'
         g['sp']=sp
         g['cmd'] = 'life'
         g['who'] = gprm['-ch']
         g['prefix'] = 'ch'
         g['ch'] =mbch['ch']
         g['pid'] = str(os.getpid())
         g['uxt'] = str(stofunc.nowtosec('loc'))
         sj = json.dumps(g)
         mbqt['mqtt'].publish('maldms', sj)
         #lsgto.append(g)
         if '-start' in gprm.keys() and gprm['-start'] == 'poll':
          pass
          #mp('white','RINT1='+str(mbch['rint1'])+zp+'RINT2='+str(mbch['rint2'])+zp+'RINT3='+str(mbch['rint3']))

  except Exception as ee:
   mpr('timer10s',ee)


def launchsatelits():
    if '-startdms' in gprm.keys() and gprm['-startdms']=='y':
     gevent.sleep(1)
     s = 'python3 maldms.py &'
     os.system(s)
    if '-startwrlog' in gprm.keys() and gprm['-startwrlog'] == 'y':
        gevent.sleep(1)
        s = 'python3 malwrlog.py &'
        os.system(s)



#====================mgbs==================

ap=chr(0x27)
zp=','
tasks = []
mgb = {}
mbch={}
mblsrelay=[]
mbsysinfo={}
glslongscmd=[]
lstopics=[]
gprm={}
mbacl={}
gprm=gfunc.gonsgetp()
host       =gprm['-ch']

cid='ch_'+gprm['-ch']
mgb['cid']=cid
mp('lime','cid='+mgb['cid'])

mbqt={}


mgb['comp']=(socket.gethostname()).lower()
mp('yellow','comp='+mgb['comp'])
mgb['comp']=gprm['-psdcomp']
mp('yellow','psdcomp='+mgb['comp'])
chskd=crip(gprm['-ch'])
mbch['chskd']=chskd



mbsysinfo=readconfig()
h=mbsysinfo['letransip']
connecttobroker(cid,h)
rc,ls=mysubscreibe('maldms')
mp('lime','rc='+str(rc)+'/ls='+str(ls))

pgconn=fpgs_connect()
mgb['pgs']=pgconn
mp('yellow','mbsysinfo='+str(mbsysinfo))
mp('red','start')
x=readchparam(gprm['-ch'])
mp('lime','x='+str(x))
mbch=formirmbch()
mbch['ch'] = gprm['-ch']
mp('lime','mbch='+str(mbch))


mbch['chskd']=chskd
if chskd != None:
   rmp('white','NOT NONE',10)
   mbacl,addrs = readacl()
   mbch['addrs']=addrs
   rmp('cyan','TUT addrs='+str(addrs),10)
   mbacl=formirmbacl(addrs)
   mp('yellow','mbacl='+str(mbacl))
   mbch['active']=True
   mbch['addrs']=addrs


task = gevent.spawn(timerrest, 10)
tasks.append(task)

task = gevent.spawn(timer10s, 10)
tasks.append(task)
task = gevent.spawn(timer30s, 30)
tasks.append(task)
rmp('lime','call mypoll',20)
#launchsatelits()
if gprm['-start']=='poll':mypoll()


gevent.joinall(tasks)
'''
if __name__ == "__main__":
    print ('Start tzx1!')
    mgb['f1']='f1'
    mgb['uxt']=stofunc.nowtosec('loc')
    task=gevent.spawn(timer1s,1)
    tasks.append(task)

    gevent.joinall(tasks)
'''