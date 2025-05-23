#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#import datetime
import sys,time,os,traceback,asyncio
import libtssacs as acs
import stofunc,gfunc,mqtbridge
from os import path, sep
import psycopg2
import base64
import json,subprocess
import socket
import time
#import mytsslongcmd

class tcmdmain():
    def __init__(self):
      self.bid=0                      # myid from base
      self.secmer=0                   # SECUNDOMER
      self.phase=None                # wait,exe
      self.attempt=0                 # попыток
      self.kpx='avt'                 # avt or kpx
      self.actcg=False               # channel active or not
      self.typ=['l','chnot','avt']    # long,channel not active,kpx=avt
      self.start=0                    #stamp DELIVERY work
      self.attempt=0
      self.chskd=None
      self.ac=-1
      self.lsout=[]
      self.lsin=[]
      self.cmd =None
      self.glsrc=None
      self.erm=None
      self.simulerr='no'


class algonsdt():
    def __init__(self):
        self.year  =0
        self.month =0
        self.day   =0
        self.hour  =0
        self.minute=0
        self.second=0


async def asselfupd():
   while True:
      try:
         await asyncio.sleep(0.1)
         if len(pgsbox)>0:
           line=pgsbox.pop(0)
           if line !=None:
              pgs=mgb['pgs']
              curs = pgs.cursor()
              curs.execute(line)
              pgs.commit()
      except Exception as ee:
          mpr('aselfupd', ee)




def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='drv9'
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
    pgsbox.append(s)

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

async def astimermbrlist(interval):
    while True:
     await asyncio.sleep(interval)
     l=len(mqtbridge.mbrlist)
     if l>0 :
       js=mqtbridge.mbrlist.pop(0)
       readmbrlist(js)

def readmbrlist(js):
   try:
    g=json.loads(js)
    if not 'cmd' in g.keys():return

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd']=='ac_readallkeys':
        rmp('yellow', 'g=' + str(g), 3)
        #fshowmes('i', 'delivery cmd =' + str(g))
        #glscmd['ls'].append(g)
        obj=tcmdmain()
        if 'bid' in g.keys():
         obj.bid=g['bid']
         obj.cmd=g['cmd']
         obj.phase='wait'
         obj.erm='ok'
         obj.start=stofunc.nowtosec('loc')
         obj.secmer =0
         obj.glsrc=g
         lsgcmdmain.append(obj)



    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd']=='ac_getinfo':
        rmp('yellow', 'g=' + str(g), 3)
        fshowmes('i', 'delivery команду =' + str(g))
        glscmd['ls'].append(g)
        #formirinfochac(int(g['ac']))

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ch_active':
        rmp('yellow', 'g=' + str(g), 3)
        mbch['active']=True
    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ch_notactive':
        rmp('yellow', 'g=' + str(g), 3)
        mbch['active']=False
        fshowmes('i', 'delivery команду =' + str(g))


    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_genkeys':
     rmp('yellow', 'g=' + str(g), 3)
     ac = int(g['ac'])
     fshowmes('i', 'delivery команду =' + str(g))
     glscmd['ls'].append(g)

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_test_readallkeys':
     rmp('yellow', 'g=' + str(g), 3)
     fshowmes('i', 'delivery команду =' + str(g))
     glscmd['ls'].append(g)

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_test_delallkeys':
     rmp('yellow', 'g=' + str(g), 3)
     fshowmes('i', 'delivery команду =' + str(g))
     glscmd['ls'].append(g)

    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_wkpx_avt':
     rmp('yellow', 'g=' + str(g), 3)
     ac = int(g['ac'])
     mbacl[ac]['kpx']='avt'
     fshowmes('i','delivery cmd='+str(g))
    if 'cid' in g.keys() and g['cid'] == mgb['cid'] and g['cmd'] == 'ac_wkpx_kpx':
        rmp('yellow', 'g=' + str(g), 3)
        ac = int(g['ac'])
        mbacl[ac]['kpx'] ='kpx'
        fshowmes('i', 'delivery cmd= =' + str(g))

    if 'cid' in g.keys() and g['cid']==mgb['cid'] and g['cmd']=='ac_simulbad':
     rmp('yellow','g='+str(g),3)
     fshowmes('i', 'delivery cmd=' + str(g))
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


def tobaseraktopic(ac,n,d,ls):
    rmp('cyan','tobaserak ac='+str(ac)+',n='+str(n)+',d='+str(d),10)
    try:
            cdate = gfunc.mydatezz()
            cdate = cdate.replace('.', '-')
            # redlog('tobase_acerr ac='+str(ac)+' /erm='+erm)
            zp = ','
            s = 'insert into tss_raktopic(attempt,delta,ac,cdate,ctime,bidcomp,bidch)values( ' + \
                str(n) + zp + \
                str(d) + zp + \
                str(ac) + zp + \
                ap + cdate + ap + zp + \
                ap + gfunc.mytime()[0:8] + ap + zp + \
                str(mgb["bidcomp"]) + zp + \
                str(mbch["bidch"]) + \
                ');'
            pgsbox.append(s)
            rmp('yellow','s='+s,30)

    except Exception as ee:
     mprs('tobaserk',ee)






def restorekpx():
   try:
    mgb['cmdlong']='free'
    mbch['active']= True
    for ac in mbch['addrs']:
      mbacl[ac]['kpx']= mbacl[ac]['kpx_safe']
   except Exception as ee:
     mpr('restorekpx',ee)




def setkpxall(kpx):
   try:
    mgb['cmdlong']='busy'
    mbch['active_safe'] = mbch['active']
    mbch['active'] = False
    for ac in mbch['addrs']:
      mbacl[ac]['kpx_safe']=mbacl[ac]['kpx']
      mbacl[ac]['kpx']=kpx
   except Exception as ee:
     mpr('setkpxall',ee)

def onereadrak(task,attempt):
        ac = task.ac
        chskd = task.chskd
        task.attempt = attempt
        task.slout = []
        try:
          chskd.flush_input()
        except :pass
        try:
         task.slout = task.chskd.read_all_keys(ac)
         task.erm = 'ok'
         return task
        except Exception as ee:
         task.erm=str(ee)
         mprs('onereadrak attempt='+str(task.attempt),ee)
         return task



def directrak(task):
     ac=task.ac
     chskd=task.chskd
     task.attempt=1
     task.slout=[]
     for i in range(3):
      task=onereadrak(task,i)
      if task.erm=='ok':
        break
     return task

def freadallkeys(task,ac):
    rmp('yellow','freadallkeys   ssssssssssssssssssssssssssssssssssssssssssssss',20)
    ac=int(ac)
    task.chskd=mbch['chskd']
    task.ac=ac
    task.phase = 'exe'
    fprgs(task)
    asyncio.run(asmydelay(1))
    mgb['cmdlong'] = 'busy'
    mbacl[ac]['kpx']='avt'
    try:
        try:
         rmp('white','freadallkeys dt='+str(dt),3)
        except :pass
        task.erm='ok'
        t1 = stofunc.nowtosec('loc')
        task=directrak(task)
        mbacl[ac]['kpx'] = 'kpx'
        mgb['cmdlong'] = 'free'
        ll=str(len(task.slout))
        atp=str(task.attempt)
        if task.erm=='ok':
          task.phase = 'endok'
          fprgs(task)
          asyncio.run(asmydelay(1))
        else:
            task.phase = 'enderr'
            fprgs(task)
            asyncio.run(asmydelay(3))
            rmp('white','end erm='+task.erm,20)
        asyncio.run(asmydelay(3))
        rmp('lime', 'ATTEMPT='+atp+'URA freadallkeys EXIT 99 ll='+ll+' ' + str(task.erm), 30)
    except Exception as ee:
      mpr('freadallkeys ac='+str(ac),ee)
    return task

    mgb['cmdlong']='free'
    pg = mgb['pgs']
    curs2 = pg.cursor()
    s='select myid from tss_raktopic order by myid desc limit 1'
    bidtopic=str(readfld(s))
    rmp('red','bidtopic='+bidtopic,20)
    asyncio.run(asmydelay(10))
    rmp('red','ll='+str(len(ls)),10)
    asyncio.run(asmydelay(10))
    n=0
    for t in ls:
     n=n+1
     code=str(t.code)
     perscat=str(t.pers_cat)
     mask=t.mask
     mask=str(gfunc.alfdecmaska(mask))
     #mp('white','code='+code+'/mask='+str(mask)+'/perscat='+perscat)
     s='insert into tss_rakmap(bidtopic,code,mask,perscat)values('+\
     bidtopic+zp+\
     code+zp+\
     mask+zp+\
     perscat+')'
     pgsbox.append(s)


def workglscmd(task):
  try:
    t=tcmdmain()

    if task.cmd == 'ac_readallkeys':
     g=task.glsrc
     ac=int(g['ac'])
     task.phase='exe'
     task.secmer=0
     #mgb['cmdlong'] ='busy'
     #fprgs(task)
     freadallkeys(task,ac)





    if 'cmd' in g.keys() and g['cmd']=='ac_getinfo':
      if glscmd['status']=='free':
       glscmd['status']='busy'
       formirinfochac(int(g['ac']))
       glscmd['status'] = 'free'
  except Exception as ee:
   mpr('workglscmd',ee)

def mypub(topic,sj):
   try:
    if mgb['cmdlong'] !='busy':
     mbqt['mqtt'].publish(topic, sj)
   except Exception as ee:
    mprs('mypub',ee)

def fprgs(task):
  try:
    g={}
    g['cmd']='cmd_progress'
    g['subcmd']=task.cmd
    g['bid']=str(task.bid)
    g['erm']=str(task.erm)
    g['phase']=str(task.phase)
    g['ctime']=gfunc.mytime()
    g['secmer']=str(task.secmer)
    g['cid']=mgb['cid']
    g['tscd']=gfunc.mytscd()
    sj = json.dumps(g)
    mypub('maldms',sj)

    mp('cyan','FPRGS='+str(g))

  except Exception as ee:
    mpr('fshowmes',ee)


def fshowmes(typ,txt):
  try:
    g={}
    g['cmd']='pshowmes'
    g['typ']=typ
    g['mes']=txt
    g['cid']=mgb['cid']
    g['tscd']=gfunc.mytscd()
    sj = json.dumps(g)
    mypub('maldms', sj)
   # mp('cyan','fhowmes='+str(g))

  except Exception as ee:
    mpr('fshowmes',ee)

async def astimer1s(interval):
    while True:
     await asyncio.sleep(interval)
     #mp('cyan','timer1s')

     try:
      lcmd=len(lsgcmdmain)
      if lcmd>0 and mgb['cmdlong'] != 'busy':
       task=lsgcmdmain.pop(0)
       task.secmer=task.secmer+1
       mp('cyan','timer1s task.cnd='+str(task.cmd))
       fprgs(task)
       workglscmd(task)
     except Exception as ee:
       mpr('timer1s',ee)


async def ascrip(ch):
 for atp in range(1,11,1):
   await asyncio.sleep(2)

   try:
    mp('red','ascrip BEFORE atmp=' + str(atp)+',ch='+ch)
    mp('cyan','crip ch='+ch)
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.1    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',30)
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    mpr('ascrip atmp='+str(atp),ee)
    #print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))
    return None





def crip(ch):
   try:
    mp('cyan','crip ch='+ch)
    mp('red','ATTEMPT crip ch='+ch)
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.1    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',30)
    #fplay('prolog.wav')
    mp('red', 'CREATE OK crip ch=' + ch)
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
    rmp('lime', 'calconfig dir =' + dir,5)
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
    g['active_safe']=None
    g['getdt'] = False
    g['exaddrs']=[]
    g['cherrors']=0
    g['exclcount']=0
    g['kofexcl']=0
    return g


def readrow(s):

   # pgconn = fpgs_connect()
    pgc = mgb['pgs']
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

def toacinfo(ac):
  try:
      jsinfo='sn='+mbacl[ac]['sn']+zp+'pi='+mbacl[ac]['pi']+zp+'ki='+mbacl[ac]['ki']+\
           ',ei='+mbacl[ac]['ei']
      s='insert into tss_acinfo(ac,bpcomp,bpch,jsinfo)values('+\
      str(ac)+zp+ \
      str(mgb["bidcomp"]) + zp + \
      str(mbch["bidch"]) + zp + \
      ap+jsinfo+ap+')'
      pgsbox.append(s)


  except Exception as ee:
   mprs('toacinfo',ee)

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
    mp('blue','s='+s)
    sj = json.dumps(g)
    topic = 'maldms'
    mypub('maldms', sj)
    pgsbox.append(s)
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
  g[ac]['kpx_safe']=' '
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
        mypub('maldms', sj)
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


async def mypoll():

    while True:
     try:
      chskd = mbch['chskd']
      await asyncio.sleep(0.009)
      if mbch['active'] :
       if len(mblsrelay)>0:
            try:
              g=mblsrelay.pop(0)
              mbch['chskd'].relay_on(int(g['ac']), int(g['port']), g['tmr'])
            except Exception as ee:
             mprs('mypoll',ee)
          # print ('mypoll addrs='+str(addrs))

       for ac in mbch['addrs']:
          if  mbacl[ac]['kpx']=='kpx'  and  mbacl[ac]['buzy'] == False  :
              await asyncio.sleep(0.03)
              try:
                ev=None
               # mp('cyan', 'mypoll ac=' + str(ac))
                ev = chskd.get_event(ac, True)
               # mp('lime','ac='+str(ac)+',ev='+str(ev))
                await asyncio.sleep(0.001)
                if ev !=None:
                    pass
                    print('ac=', ac,' , EV=',ev)

                if mgb['cmdlong']=='busy':
                 mp('blue','mypoll ac='+str(ac))
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
   # mp('lime','readacl='+s)
   # mp('white', 'readacl=' + s)
    #mp('lime', 'readacl=' + s)
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




async def astimerrest(interval):

    while True:
     await asyncio.sleep(interval)
     if mgb['cmdlong'] !='busy':
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
               mpr('astimerrest',ee)




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
    asyncio.run(asmydelay(1))
    pid = str(os.getpid())
    ls.append('sudo kill +pid ')
    ls.append('python3 tzx1.py -ch '+' '+gprm['-ch']+\
    ' -start poll  -startdms n -startwrlog n &')
    appdir=gfunc.getmydir()
    fn=appdir+'rbp.sh'
    rmp('yellow', 'fn=' + fn, 10)
    asyncio.run(asmydelay(2))
    outp=open(fn,'w')
    outp.writelines(ls)
    outp.flush()
    outp.close()
    s='chmod +x '+fn
    os.system(s)
    #await asyncio.sleep(3)
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


async def astimer30s(interval):
    while True:
        await asyncio.sleep(interval)
        if mgb['cmdlong'] != 'busy':
            try:
              s='aclist='+str(mbch['addrs'])+zp+'speed='+str(mbch['speed'])
              tobase_acerr(-1,s,0)
            except Exception as ee:
              mpr('astimer30s',ee)


async def astimer10s(interval):
 while True:
  await asyncio.sleep(interval)
  if mgb['cmdlong'] != 'busy':
       try:
         rmp('white','timer10s cmdlong='+str(mgb['cmdlong']),2)
        # fshowmes('i', 'timer10s')
         fbrp(' broken pipe')
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
             if mgb['cmdlong'] != 'busy':
               mypub('maldms', sj)
             #lsgto.append(g)
             if '-start' in gprm.keys() and gprm['-start'] == 'poll':
              pass
              #mp('white','RINT1='+str(mbch['rint1'])+zp+'RINT2='+str(mbch['rint2'])+zp+'RINT3='+str(mbch['rint3']))

       except Exception as ee:
           mpr('timer10s',ee)


def launchsatelits():
    if '-startdms' in gprm.keys() and gprm['-startdms']=='y':
     #await asyncio.sleep(1)
     s = 'python3 maldms.py &'
     os.system(s)
    if '-startwrlog' in gprm.keys() and gprm['-startwrlog'] == 'y':
        #await asyncio.sleep(1)
        s = 'python3 malwrlog.py &'
        os.system(s)


def formirinfochac(ac):
    rmp('blue','formirinfochac',30)
    if mgb['cmdlong']=='busy':return
    c = mbch['chskd']
    try:
     ki = str(c.keys_info(ac))
     mbacl[ac]['ki'] =ki
     mp('cyan','ac='+str(ac)+zp+'ki='+ki)
    except Exception as ee:
     mprs('formirinfochac ki',ee)
    try:
     ei = str(c.events_info(ac))
     mbacl[ac]['ei'] = ei
     mp('cyan', 'ac=' + str(ac) + zp + 'ei=' + ei)
    except Exception as ee:
     mprs('formirinfochac ei', ee)
    try:
        pv = str(c.prog_ver(ac))
        mp('cyan', 'ac=' + str(ac) + zp + 'pv=' + pv)
        mbacl[ac]['pv']=pv
        pi = str(c.prog_id(ac))
        mbacl[ac]['pi'] = pi
        mp('cyan', 'ac=' + str(ac) + zp + 'pi=' + pi)
        sn=str(c.ser_num(ac))
        mbacl[ac]['sn'] = sn
        mp('cyan', 'ac=' + str(ac) + zp + 'sn=' + sn)
        toacinfo(ac)
    except Exception as ee:
        mprs('formirinfochac prog ', ee)

async def asmydelay(interval):
  await asyncio.sleep(interval)

    #====================mgbs==================

ap=chr(0x27)
zp=','
tasks = []
mgb = {}
pgsbox=[]
mbch={}
mbch['active']=True
mblsrelay=[]
mbsysinfo={}
glscmd={}
lsgcmdmain=[]
mgb['cmdlong'] ='free'


glscmd['status']='free'
glscmd['ls']=[]



lstopics=[]
gprm={}
mbacl={}
gprm=gfunc.gonsgetp()
host       =gprm['-ch']

mbqt={}


mgb['comp']=(socket.gethostname()).lower()
mp('yellow','comp='+mgb['comp'])
mgb['comp']=gprm['-psdcomp']
mp('yellow','psdcomp='+mgb['comp'])

cid=mgb['comp']+'_'+gprm['-ch']
mgb['cid']=cid
mp('lime','cid='+mgb['cid'])


mbsysinfo=readconfig()
h=mbsysinfo['letransip']
mp('yellow','h='+str(h))


pgconn=fpgs_connect()
mgb['pgs']=pgconn
mp('yellow','mbsysinfo='+str(mbsysinfo))



mp('red','start')
for n in range(1,5,1):
 asmydelay(3)
 chskd=crip(gprm['-ch'])
 if chskd !=None:
   break
#chskd=asyncio.run(ascrip(gprm['-ch']))
#chskd=asyncio.ensure_future(ascrip(gprm['-ch']))
mbch['chskd']=chskd





mbqt['mqtt']=mqtbridge.connecttobroker(cid,h)
rc,ls=mqtbridge.mysubscreibe(mbqt['mqtt'],'maldms')
mp('lime','rc='+str(rc)+'/ls='+str(ls))


x=readchparam(gprm['-ch'])
mp('lime','x='+str(x))
mbch=formirmbch()
mbch['ch'] = gprm['-ch']
mp('lime','mbch='+str(mbch))

mbch['chskd']=chskd
if chskd != None:
   rmp('white','NOT NONE',50)
   mbacl,addrs = readacl()

   mbch['addrs']=addrs
   rmp('cyan','TUT addrs='+str(addrs),10)
   mbacl=formirmbacl(addrs)
   mp('yellow','mbacl='+str(mbacl))


   mbch['active']=True
   mbch['addrs']=addrs
   for ac in addrs:
    #mp('red','ac='+str(ac))
    formirinfochac(ac)


rmp('lime','call mypoll',20)
#launchsatelits()
if gprm['-start']=='poll':
    rmp('yellow','FUTURE MYPOLL START ADDRS='+str(addrs),50)
    asyncio.ensure_future(mypoll())
    #asyncio.run(mypoll())

loop = asyncio.get_event_loop()
task1 = loop.create_task(astimerrest(10))
task2 = loop.create_task(astimermbrlist(0.05))
task3 = loop.create_task(astimer1s(1))
task4 = loop.create_task(astimer10s(10))
task5 = loop.create_task(asselfupd())
task6 = loop.create_task(astimer30s(30))
loop.run_until_complete(asyncio.wait([task1,task2,task3,task4,task5,task6]))
