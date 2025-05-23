#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import socket
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import json

import psycopg2,json



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



class algonsdt():
    def __init__(self):
        self.year  =0
        self.month =0
        self.day   =0
        self.hour  =0
        self.minute=0
        self.second=0

def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mp(c,txt):
 try:
  if c == 'red':
    redlog(txt)
  # spid=mgb['spid']
  if not '-ch' in gprm.keys():
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  s ='ch=%10s,%10s,%15s' \
      % (ch,txt,t)
  if c=='t':
   print (s)
   #testlog(txt)
   return
  if c != 't':
      gfunc.mpv(c, s)
      #gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)

      if c == 'magenta':
          #magentalog(txt)
          return
 except Exception as ee:
   print ('mp ee='+str(ee))

def tobase_acerr(ac,erm,code): # from drv209
  try:
    cdate = gfunc.mydatezz()
    cdate = cdate.replace('.', '-')
    redlog('tobase_acerr ac='+str(ac)+' /erm='+erm)
    zp=','
    if ac==-1:
     if len(mbch['addrs'])==0:
      speed=0
     else :
       speed=mbch['speed']
     s='insert into tss_acerr(cdate,ctime,speed,bpcomp,bpch,code,counterr,erm)values( '+ \
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
    # sys.exit(77)
    curs2 = pgconn.cursor()
    curs2.execute(s)
    pgconn.commit()
    curs2.close()
  except Exception as ee:
   mpr('tobase_acerr',ee)



def toredbase(txt):
   try:
    txt=txt.replace(ap,'"')
    try:
     f=txt.index('/ee=')
     typ=-1
    except Exception as ee:
     typ='0'
    app = mgb['cid']
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



def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def crip(ch):
 atp=0
 while True:
   try:
    atp=atp+1
    mp('cyan','crip='+gprm['-ch'])
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.07    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    #chskd.flush_input()
    print('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))


def convertwiegand(k):
 return k ^ 0x3FFFFFF

def m_formircev(ev):
    pass
def formircev(ev):
    try:

        g = {}
        g['cmd'] = 'todmsev'
        g['komu'] = 'maldms'
        g['module'] = 'ch_'
        g['sens'] = 'undef'
        cl = 'red'
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
        g['no'] = str(ev.no)
        g['ac'] = str(ev.addr)
        g['port'] = str(ev.port)
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
             #g['code'] = str(8556084)
             #g['kluch'] = '000000828E34'
         else:
          g['kluch']=gfunc.xkeytos(ev.code)
        if g['sens']=='key':
           s='kpx=%3s,ev=%4s ,ac=%3s,no=%6s ,p=%2s, dt=%8s,delta=%3s,'\
             'code=%6s,KLUCH=%12s'\
           % (g['kpx'], g['sens'], g['ac'], g['no'], g['port'], g['dt'], g['delta'], g['code'],g['kluch'])
           mp(cl,s)
        else:
          s = 'kpx=%3s,ev=%4s ,ac=%3s,no=%6s ,p=%2s, dt=%8s,delta=%3s,' \
          % (g['kpx'], g['sens'], g['ac'], g['no'], g['port'], g['dt'], g['delta'])
          mp(cl, s)
        if g['sens']=='rte' and g['kpx']=='kpx':
         mp('lime','RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR')
       #  mbch['chskd'].relay_on(int(g['ac']),int(g['port']),3)
        #lsgtodms.append(g)
        gx={}
        gx['cmd']='tranzit'
        gx['komu']='localcentr'
        gx['glsbody']=g
       # mp('yellow','gx='+str(gx))
        formircliz('tomain', g)





    except Exception as ee:
      mprs('formircev',ee)




def timerrest(interval):
    while True:

      gevent.sleep(interval)
      try:
          rmp('gray', 'timerrest addrs='+str(mbch['addrs'])+' /exaddrs='+str(mbch['exaddrs']),2)
          while len(mbch['exaddrs'])>0:
            x=mbch['exaddrs'].pop(0)
            mbch['addrs'].append(x)
            mbacl[x]['cerr']=0
            frmchstatus('incl')
            mp('yellow','APPEND=============='+str(x))
          rmp('white','ADDRS='+str(mbch['addrs'])+',EXADDRS='+str(mbch['exaddrs']),3)
      except  Exception as ee:
           mpr('timerrest',ee)


def timer5s(interval):
    while True:
      gevent .sleep(interval)
      mp('lime','timer5  ADDRS='+str(mbch['addrs'])+' /EXCL='+str(mbch['exaddrs']))

def timertestrele(interval):
    while True:
      gevent .sleep(interval)
      g={}
      g = {}
      g['komu'] = 'tomain'
      g['cmd'] = 'testrele'
      g['kto'] = mgb['cid']
      g['ch'] = mbch['ch']
      g['uxt'] = str(stofunc.nowtosec('loc'))
      formircliz('tomain', g)

      x=1
      if x==0:
          try:
           mbch['chskd'].relay_on(7, 1,1)
          except:pass
          try:
           mbch['chskd'].relay_on(77, 1, 1)
          except :pass
          try:
           mbch['chskd'].relay_on(77, 2, 1)


          except:pass


def formirrele():

    rmp('lime', 'FORMIRRELE' ,2)
    ''' 
    l = len(al9box.lsgrele)
    if len(al9box.lsgrele) > 0:
        # mp('white','??????????????????????????????????????????????????????????????????????????')
        g = al9box.lsgrele.pop(0)
        tmr = int(g['tmr']) * 2
        try:
         mbch['chskd'].relay_on(int(g['ac']), int(g['port']), tmr)
        except Exception as ee:
         mprs('formirrele',ee)
    '''

def  addexlist(ac):
   try:
    n=mbch['exaddrs'].index(ac)
    mp('white','n='+str(n))
   except Exception as ee:
    mbch['exaddrs'].append(ac)
    mp('yellow','NEW EXLIST='+str(mbch['exaddrs']))


def analyzee(ac,ee):
    ac=int(ac)
    es = str(ee)
    es=es.lower()
    bp='broken pipe'
    p='unexpected response'
    p2='no response in'
    #print ('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
    #mp('white', 'ANALYZE=' + str(ac)+' ,ERR='+str(ee))
    try:

     if mbacl[ac]['cerr']>=mbacl[ac]['limitinfoerr']:
      mp('yellow','analyzee ac='+str(ac)+',cerr='+str(mbacl[ac]['cerr'])+',ee='+str(ee))
      addexlist(ac)
      mbch['addrs'].remove(ac)
      frmchstatus('excl')
      #fplay('alarm3.wav')
      rmp('magenta','???????????????analyze addrs='+str(mbch['addrs']),3)
     x=-1
     x=es.index(p)
    except :pass

    try:
     y=-1
     y=es.index(p2)
    except :pass
     #print ('y=',y)

def checkexcl(ac):
    rmp('yellow','checkexcl ??????????????',2)
    for ac in addrs:
     if mbacl[ac]['excl']>0:
       chskd = mbch['chskd']
       try:
          for i in range(1,3,1):
           dt=chskd.get_dt(ac)
           mbacl[ac]['excl']=-1
           break
       except Exception as ee:
        pass

def mypoll():
   while True:
      gevent.sleep(0.001)
      chskd = mbch['chskd']
      if mbch['active'] :
         for ac in mbch['addrs']:
          if  mbacl[ac]['kpx']=='kpx'  and  mbacl[ac]['buzy'] == False  :
              try:
               try:
                pass
               except  Exception as ee:
                pass
                #mp('magenta','timerpoll GETDT',ee)
               try:
                ev=None
                #mp('cyan','EVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV')
                ev = chskd.get_event(ac, True)
                mbch['cev'] = mbch['cev'] + 1
                gevent.sleep(0.001)
               except Exception as ee:
                 mbacl[ac]['cerr'] = mbacl[ac]['cerr'] + 1
                 mbch['cherrors']=mbch['cherrors']+1
                 analyzee(ac,ee)

               if ev != None:
                pass
                cev = formircev(ev)
              except Exception as ee:
               mbacl[ac]['cerr']=mbacl[ac]['cerr']+1
               mpr('timerpoll FINAL', ee)
               ev = None

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



def getdtonpoll():
    if '-start' in gprm.keys() and gprm['-start'] == 'wait':return
    if not mbch['active']:return
    for ac in addrs:
        mbacl[ac]['buzy'] = True
        try:
            dt = None
            dt = mbch['chskd'].get_dt(ac)
            mbacl[ac]['buzy'] = False
            s = 'getdtonpoll ac=%3s,dt=%40s' % (ac, dt)
           # mp('cyan',s)
            g=gfunc.al_209dt(ac,dt)
            if abs(g['acdelta'])>10 :
             al_setdt_ac(ac)
             mp('red','ac='+str(g['ac'])+' delta='+str(g['acdelta']))

        except Exception as ee:
            mbacl[ac]['buzy'] = False




def timer30s(interval):
    while True:
     gevent.sleep(interval)


def timerlsgtodms(interval):
    while True:
      try:
         gevent.sleep(interval)
         if len(lsgtocliz)>0:
          g=lsgtocliz.pop(0)
          try:
           mgb['cli'].send(g,'localcentr')
          # mp('cyan','clisend='+str(g))
          except Exception as ee:
           mp('yellow','timerlsgtodms ee='+str(ee))
      except Exception as ee:
          mp('yellow', 'timerlsgtodms 0 ee=' + str(ee))


def formir_glstojs(g):
   try:
    #return #suda
    sj = json.dumps(g)
    topic=g['komu']
    #mbqt['mqtt'].publish(topic,sj)
   # mp('red','sj='+str(sj))
   except Exception as ee:
    mpr('glstojs',ee)



def timerlsgto(interval):
    while True:
     gevent.sleep(interval)
     if len(lsgto)>0:
      pass
      g=lsgto.pop(0)
      formir_glstojs(g)


def selfupd(line):

      try:
          mp('white','selfupd='+line)
          curs = pgconn.cursor()
          curs.execute(line)
          pgconn.commit()
      except Exception as ee:
          mprs('selfupd', ee)

def altertmz():
   try:
    s='ALTER SYSTEM SET timezone TO "Europe/Moscow"'
    s ='SET timezone TO "Europe/Moscow"'
    mp('lime','altertmz='+s)
    selfupd(s)
   except Exception as ee:
     mpr('altertmz',ee)
     sys.exit(77)


def formircliz(komu,g):
    gx = {}
    gx['cmd'] = 'tranzit'
    gx['komu'] = komu
    gx['glsbody'] = g
    lsgtocliz.append(gx)


def fbidsaddrs():
  try:
    s=''
    for ac in mbch['addrs']:
     s = str(ac) + ',' + str(mbacl[ac]['bidac'])
    return s
  except Exception as ee:
   mpr('fbidsaddrs',ee)

def fbidsexcl():
  try:
    s=''
    for ac in mbch['exaddrs']:
     s = str(ac) + ',' + str(mbacl[ac]['bidac'])
    return s
  except Exception as ee:
      mpr('fbidsexcl', ee)

def frmchstatus(subcmd):
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

      tobase_acerr(-1,'excl='+str(mbch['exaddrs']),-5)
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
    tobase_acerr(-1,'excl=' + str(mbch['exaddrs']),5)
    rmp('white', 'frmchstatus=' + str(g), 2)
    formircliz('tomain', g)
   except Exception as ee:
    mpr('frmchstatus',ee)


def timerchinfo(interval):
    while True:
     gevent.sleep(interval)
     frmchstatus('chinfo')
     mp('white','timerchinfo 60 sec 600000000000000000000000000000000000000000000')
     fplay('ping1.wav')

def timer10s(interval):
    while True:
     gevent.sleep(interval)
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
     rmp('white','timer10s='+str(g),2)
     formircliz('tomain',g)

     if not mbch['active']:
      mp('cyan','ожидаю активации канала')
      #fplay('ping1.wav')
     if mbch['active']:
         for ac in addrs:
          s = 'ac=%3s,CERR=%4s' % (ac,mbacl[ac]['cerr'])
          mp('cyan',s)
         razborinmes()
         sp=str(int(mbch['cev'] / interval))
         mbch['cev']=0

         g= {}
         g['komu']='tomain'
         g['sp']=sp
         g['cmd'] = 'life'
         g['who'] = gprm['-ch']
         g['prefix'] = 'ch'
         g['ch'] =mbch['ch']
         g['pid'] = str(os.getpid())
         g['uxt'] = str(stofunc.nowtosec('loc'))
         lsgto.append(g)

         if '-start' in gprm.keys() and gprm['-start'] == 'poll':
          mp('white','SPEED='+sp+' /GETDT='+str(mbch['getdt']))
          mbch['speed']=sp


def fplay(wav):
    dir = gfunc.getmydir()
    pt = dir + 'wav/'+wav+' &'
    os.system('aplay ' + pt)

def formirmbch():
    s='select myid from tss_comps where name='+ap+mgb['comp']+ap
    bidcomp=str(readfld(s))
    mp('cyan', s)
    s='select myid from tss_ch where ch='+ap+gprm['-ch']+ap+' and bp='+bidcomp
    mp('cyan',s)
    bidch=str(readfld(s))

    g={}
    mgb['bidcomp'] = bidcomp
    mbch['bidcomp'] = bidcomp
    g['bidcomp']=bidcomp
    g['bidch']=bidch
    g['cev']=0
    g['speed']=0
    g['active']=False
    g['getdt'] = False
    g['exaddrs']=[]
    g['cherrors']=0
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
  g[ac]['buzy']=False      # контроллер занят другой операцией (запись ключей ...)
  g[ac]['cerr']=0          # общее кол-во ошибок на этом контроллере
  g[ac]['currerr']=0       # текущее кол-во ошибок до первого успешного события
  s='select limitinfoerr from tss_acl where ac='+str(ac)+' and bp='+str(mgb['bidch'])
  mp('lime','s='+s)
  g[ac]['limitinfoerr']=readfld(s)
 return g


def al_formirtk(ac,code,ms,tz):
   try:
        key = acs.Key()
        key.code = code
        key.mask = ms
        key.pers_cat = tz
        return key
   except Exception as ee:
    mprs('al_formirtk',ee)



def al_wratest(ac,n1,n2,ms,tz):
   ls=[]
   for code in range(n1,n2+1,1):
    t=al_formirtk(ac, code, ms, tz)
    ls.append(t)
   return ls

def razborinmes():
    return
    if len(lsinjs)==0 : return
    g=lsinjs.pop(0)
    rmp('cyan','g='+str(g),5)
    mbch['chskd'].find_addrs()
    if g["cmd"]=='find_addrs':
     addrs=mbch['chskd'].find_addrs()
     rmp('lime','addrs='+str(addrs),20)

def onmesmqtt(client, userdata, message):

    js = message.payload.decode("utf-8")
    rmp('magenta','oNmes=' + str(js),2)

    try:
     g=json.loads(js)
     mp('lime','g='+str(g))
     lsinjs.append(js)
    except Exception as ee:
      return

def timerscancmd(interval):
    while True:
     gevent.sleep(interval)
     #mp('yellow','timerscancmd')
     if os.path.isfile('cmd.txt'):
      inp=open('cmd.txt','r')
      ls=[]
      ls=inp.readlines()
      g=gfunc.lstogls(ls)
      mp('lime',str(g))
      inp.close()
      gfunc.mydeletefile('cmd.txt')
      if g['cmd']=='channelstart':
       topic='home251'

       rmp('cyan', 'ch=' + str(g['ch']), 10)
       mbch['chskd']=crip(g['ch'])
       mbch['ch']=g['ch']
       #addrs=mbch['chskd'].find_addrs()
       #rmp('lime','addrs='+str(addrs),10)



def wrallkeys(ac,n1,n2):
    msk=16
    ls = al_wratest(ac, n1, n2, [1, 2, 3, 4, 5, 6, 7, 8], msk)
    return ls


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
        mp('red', 'readchparams s=' + s)
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
def fpgs_connect():
 try:
  conn = psycopg2.connect(
    host    ='192.168.0.106', #mysysinfo['base']['ip'],
    database='postgres',        #gprm['-dbname'],
    user="postgres",
    port="5432",
    password='postgres')                #mysysinfo['base']['psw'], )
  mp('lime','host='+mysysinfo['base']['ip'])
  mp('lime','conn='+str(conn))
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')



def readacl():
  try:
    ls=[]
    g={}
    s='select myid,ac,actual,limitinfoerr,limitcrasherr from tss_acl where bp='+str(mgb['bidch']) +' and actual=True'
    mp('lime','readacl='+s);
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

def launchsatelits():
    s = 'python3 malwrlog.py &'
    os.system(s)
    gevent.sleep(1)
    s = 'python3 maldms.py &'
    os.system(s)
    gevent.sleep(1)
    s = 'python3 localcentr.py &'
    os.system(s)
    gevent.sleep(1)

def createclzero():
    hc = 'tcp://127.0.0.1:5555'
    clientftpsrv = ccftpsrv(hc,'maldrv209')
    ccftpsrv.on_receive = onclftpsrv
    task = gevent.spawn(clientftpsrv.run)
    tasks.append(task)
    mgb['cli']=clientftpsrv
    return clientftpsrv


def timerzero(interval):
   while True:
    gevent.sleep(interval)
    g={}
    g['cmd']='zpass'
    mgb['cli'].send(g)



def onclftpsrv(sender,g):
    try:
     if not 'cmd' in g.keys(): return

     ##  'subcmd': 'ac_wkpx_avt',ac': '77',
     ##        'bidch': '178', 'cds': '10-10-23 04:08:09'}
     if g['cmd']=='setdrv' and 'subcmd' in g.keys()\
         and str(mgb['bidch'])==g['bidch'] \
         and g['subcmd'] == 'ac_wkpx_avt' :
          ac=int(g['ac'])
          mbacl[ac]['kpx']='avt'
          rmp('yellow','AVTONOM ac='+str(g['ac']),5)

     if g['cmd']=='setdrv' and 'subcmd' in g.keys()\
         and str(mgb['bidch'])==g['bidch'] \
         and g['subcmd'] == 'ac_wkpx_kpx' :
          ac = int(g['ac'])
          mbacl[ac]['kpx'] = 'kpx'
          rmp('lime','KOMPLEX ac='+str(g['ac']),5)



     if g['cmd'] !='zpass':
       pass
       #  mp('magenta', 'CHHHH oncl=' + str(g))
     if g['cmd'] == 'releon' and (g['ch']==mbch['ch'] or g['ch']=='malemul'):
      try:
       mbch['chskd'].relay_on(int(g['ac']), int(g['port']),int(g['tmr']))
       mp('lime','AFTER RELAYON RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR')
      except Exception as ee:
       mprs('onclftpsrv', ee)


    except Exception as ee:
     mpr('oncl',ee)

def xxxx():
    pass
  #  1  -5  контроллер  исключен из  опроса
  #  2  -1  нет     стартера
  #  3  -2  нет     базы
  #  4  -3  нет     транспорта
  #  5  -4   нет    адреса    канала
  #  6  -6  ошибка  подключения к каналу
  #  7  -7  нет     контроллеров

#====================mgbs==========================

ap=chr(0x27)
zp=','
lstopics=[]
mgb={}
mbch={}
mbch['i']=0
mbch['active']=False
mbch['getdt'] = False
gprm={}
lsgtocliz=[]

lsgto=[]
lsgtodms=[]
mbacl={}
maxerv=10
tasks=[]
maxerv=10
mgb['ccs']=0
gprm=gfunc.gonsgetp()


cid='ch_'+gprm['-ch']
mgb['comp']=(socket.gethostname()).lower()
mp('lime','comp='+mgb['comp'])

mgb['cid']=cid
pt=gfunc.calcptstarter()
mp('cyan','pt='+pt)
mp('yellow','pt='+pt)
vb=gfunc.opendb3(pt,'r')
mp('red','start 2')
mysysinfo=gfunc.readstarter(vb)
mp('yellow','base='+str(mysysinfo['base']))
mp('yellow','comcentr='+str(mysysinfo['comcentr']))
mp('yellow','transport='+str(mysysinfo['transport']))
print ('CALL CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC')
clientftpsrv=createclzero()

pgconn=fpgs_connect()
altertmz()

mp('red','start')
x=readchparam(gprm['-ch'])
mp('lime','x='+str(x))


chskd=crip(gprm['-ch'])
mbch=formirmbch()

mbch['ch']=gprm['-ch']
mbch['i']=0
mbch['active']=True
mbch['chskd']=chskd
if chskd != None:
   pass
   mbacl,addrs = readacl()
   mbch['addrs']=addrs
   mp('cyan','mbacl='+str(mbacl))
for ac in addrs:
 print ('mbacl=',mbacl[ac])


'''
n1=stofunc.nowtosec('loc')
#addrs=mbch['chskd'].find_addrs()
addrs=[7,77]
mbch['addrs']=addrs
n2=stofunc.nowtosec('loc')
d=n2-n1
mbch['chskd'].del_all_keys(77)
ls=wrallkeys(77,1,10000)
#print ('ls=',ls)
t1=stofunc.nowtosec('loc')
mp('cyan','start wrallkeys=')
mbch['chskd'].write_all_keys(77, ls)
t2=stofunc.nowtosec('loc')
d=t2-t1

mp('lime','duration='+str(d))
mp('cyan','sleep 10 AFTER  wrallkeys')
gevent.sleep(10)
ki=mbch['chskd'].keys_info(77)
mp('cyan','KI='+str(ki))
sys.exit(99)
#rmp('magenta','stop '+str(addrs)+' TIME='+str(d),20)
mbacl=formirmbacl(addrs)

'''
mbacl=formirmbacl(addrs)
print (mbacl)



launchsatelits()

task = gevent.spawn(timerscancmd,2)
tasks.append(task)
task = gevent.spawn(timer10s,10)
tasks.append(task)
ask = gevent.spawn(timer30s,30)
tasks.append(task)
if '-start' in gprm.keys() and gprm['-start'] =='poll':
 pass


task = gevent.spawn(timerlsgto,0.01)
tasks.append(task)

task = gevent.spawn(timerlsgtodms,0.001)
tasks.append(task)

task = gevent.spawn(timer5s,5)
tasks.append(task)

task = gevent.spawn(timerrest,30)
tasks.append(task)
task = gevent.spawn(timerchinfo,60)
tasks.append(task)




frmchstatus('chinfo')
mypoll()
gevent.joinall(tasks)
