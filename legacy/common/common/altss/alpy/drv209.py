#!/usr/bin/env python
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import psycopg2
from colorama import init, Fore
from colorama import Back
from colorama import Style
# from termcolor import colored, cprint
import gevent,zerorpc
from gevent.queue import Queue
from os import path, sep
import libtssacs as acs
import stofunc,gsfunc,gfunc
import json,subprocess
import socket
import mqtransmod
import gpgctr
from playsound import playsound
import winsound


class cgonsdt():
    def __init__(self):
        self.year  =0
        self.month =0
        self.day   =0
        self.hour  =0
        self.minute=0
        self.second=0



class ccftpsrv(zerorpc.Client):
    on_receive = None

    def __init__(self, endpoint, name):
        super(ccftpsrv, self).__init__(endpoint)
        self.name = name

    def run(self):
        while True:
            try:
                for data in self.pull(self.name):
                    if self.on_receive is not None:
                        self.on_receive(data)
            except Exception as  ee:
                pass


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
  spid=mgb['spid']
  if not '-ch' in gprm.keys():
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,spid+'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
    redlog(txt)
    return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)



def timerrecoverac(interval):
    while True:
        gevent.sleep(interval)
        if mgb['recoverac']=='yes':
         mp('yellow','timerrecoverac yes............................')
         mp('red','timerrecoverac ???????????????????????????????????')
         if len(mgb['recoveraclist'])>0:
          ac=mgb['recoveraclist'].pop(0)
          addrs.append(ac)
          mgb['recoverac'] == 'no'
          mp('red', 'timerrecoverac addrs='+str(addrs))

def formir_chstate():
 try:
      if mbch['regim_opros'] == 'kpx' or mbch['regim_opros'] == 'avr':
        speed=mbch['spd']
        sumerr=getsumerr()
      else:
          speed = 0
          sumerr =0

      vuxt,ms=gfunc.myuxtms()
      jb= {
          "cmd": 'ch_state',
          "ch_status" :mbch['status'],
          'pidch' :str(mgb['pidch']),
          "subcmd": 'chcurrinfo',
          "sumerr":str(sumerr),
          "ch"    : gprm['-ch'],
          "kto"   : mgb['zclid'],
           "speed": str(speed),
          "komu"  : 'all',
          "bidcomp": mgb['bidcomp'],
          "bidch": mgb['bidch'],
          "kpx"   :mbch['regim_opros'],
          "mystamp": str(ms),
          "ms"     : str(ms),
          "vuxt": str(vuxt),
          "launchline": mgb['launchline'],
          "uxt" : str(vuxt)
      }
      s = json.dumps(jb)
      mp('yellow', 'ch_state s =' + str(s))
      tolsoutjs.append(s)
      return s
 except Exception as ee:
   mpr('formir_chstate',ee)


def timer30s(interval):
    while True:
        gevent.sleep(interval)
        sp=mbch['cnt1'] /interval
        sp=int(sp)
        mbch['spd']=sp
        formir_chstate()
        mbch['cnt1']=0

        mp('blue','SPEED='+str(sp)+'        / addrs='+str(addrs))



def timerk2(interval):
    while True:
        gevent.sleep(interval)
        tobasek2()

def getsumerr():
    sum=0
    for ac in addrs:
     k2=fk2(ac)
     sum=sum+mbacl[k2]
    return sum

def extractjs(s):
   try:
    ss=s
    g = json.loads(s)
    return g
   except Exception as ee:
    mgb['counterrorextrct'] = mgb['counterrorextrct']+1
    mprs('extractjs',ee)
    return None

def toguard():
    l=len(mgb['lstoguard'])
    mp('cyan','toguard l========================================'+str(l))
    if l==0:return
    g=mgb['lstoguard'][0]
    try:
     clientftpsrv.send(g)
     g = mgb['lstoguard'].pop(0)
    except Exception as ee:
     mpr('toguard', ee)


def myinsretreturn(ss):
  try:
   uxt= str(stofunc.nowtosec('loc'))
   pgc = pgconn
   curs = pgc.cursor()
   ss=ss+' returning myid'
   mp('red','ss='+ss)
   curs.execute(ss)
   # pgc.commit()
   # curs = pgc.cursor()
   loc = curs.fetchall()
   for row in loc:
     rc = str(row[0])
     return rc
  except Exception as ee:
    mprs('myinsretreturn',ee)
    return -1




def mysend(g):
    try:
     clientftpsrv.send(g)
    except Exception as ee:
     mprs('mysend',ee)

def timerfatal(interval):
    while True:
        gevent.sleep(interval)
        winsound.Beep(1000, 2000)
        rmp('red','timerfatal FFFFFFFFFFFF interval='+str(interval),1)
        if mgb['ffatal']:sys.exit(99)

def timer1s(interval):
      while True:
       gevent.sleep(interval)
       s='TIMER1S mbch[regim_opros] /  ch='+mgb['ch']+' pid='+str(mgb['pidch']) + \
       ' / opros='+str( mbch["regim_opros"])
       # mp('cyan',s)
       if mgb['countstart']==0:
        if len(mgb['fatalerr'])==0:
         mp('white', 'SPAWN poll_event???????????????????????????????????')
         tasks.append(gevent.spawn(poll_event))  # suda


       l = len(mgb['lsdelayedmessage'])
       l=len(mgb['lsdelayedmessage'])
       if l>0:
        g=mgb['lsdelayedmessage'].pop(0)


def getms():
    uxt = stofunc.nowtosec('loc')
    ms = gfunc.mydatezz()
    ls = ms.split('.')
    ms = ls[2] + '.' + ls[1] + '.' + ls[0]
    ms = ms + ' ' + gfunc.mytime()[0:8]
    return ms


def formir_subscrtoguard():
    vuxt,ms=gfunc.myuxtms()
    jb= {"cmd": 'subscrtoguard',
          "ch_status" :mbch['status'],
          "bidcomp": str(mgb['bidcomp']),
          "bidch": str(mgb['bidch']),
          "ch"   : gprm['-ch'],
          "uxt"  : str(stofunc.nowtosec('loc')),
          "lastobs": str(vuxt),
          "kto"    : mgb['zclid'],
          'pidch'    : str(mgb['pidch']),
          "ms"   : str(ms),
          "vuxt": str(vuxt),
          "actual": True,
          'launchline':mgb['launchline']
          }
    s = json.dumps(jb)
    mp('red', 'formir_subscrtoguard s=' + s)
    tolsoutjs.append(s)





def timerlife(interval):
    while True:
        return
        gevent.sleep(interval)
        try:
            uxt=stofunc.nowtosec('loc')
            vuxt,ms=gfunc.myuxtms()
            jb= {"cmd": 'tsslife',
            "subcmd1": 'isll',
            "ch_status": mbch['status'],
            "pidch": str(mgb['pidch']),
            "bidcomp" : str(mgb['bidcomp'] ),
            "bidch"   : str(mgb['bidch']),
            "ch"      : gprm['-ch'] ,
            "uxt"     : str(uxt),
            'vuxt'    :str(vuxt),
            "kto"     : mgb['zclid'],
            # "mystamp" : str(ms),
            "guarding" : 'yes',
            "launchline": mgb['launchline'],
            "ms": str(ms)
            }
            s = json.dumps(jb)
            mp('blue', 's =' + s)
            tolsoutjs.append(s)
        except Exception as ee:
          mpr('timerlife',ee)

def razborjscmd(g) :
   try:
    if 'komu' in g.keys() and g['komu']!=mgb['zclid']  :return
    if 'subcmd' in g.keys() and g['subcmd'] == 'dmsrelay':
      # rmp('cyan','g='+str(g),5)
      gz={}
      tmr=int(g['tmr'])
      gz['ac']=int(g['ac'])
      gz['port'] = int(g['port'])
      gz['tmr'] = int(tmr) * 2
      lsgrelay.append(gz)

    if 'subcmd' in g.keys() and g['subcmd'] == 'ac_readallkeys':
        rmp('white', str(g), 3)
        freadallkeys(g['ac'])
    if 'subcmd' in g.keys() and g['subcmd'] == 'ac_deleteallkeys':
        fdeleteallkeys(g['ac'])
    if 'subcmd' in g.keys() and g['subcmd'] == 'get_getacinfo':
      rmp('white',str(g),3)
      ac=int(g['ac'])
      # z_formiracinfoall()
      z_formiracinfoonlyac(ac,g['idcmd'])
    if 'subcmd' in g.keys() and  g['subcmd']=='set_ch_opros':
      kpx=g['line']
      mbch['regim_opros']=g['line']
      formir_chstate()
      rmp('yellow','REGIM='+mbch['regim_opros']+'>',3)

   except Exception as ee:
    mpr('razborjscmd',ee)

def timerlsoutjs(interval):
    while True:
        gevent.sleep(interval)
        l=len(mqtransmod.sljsin)
        if l>0:
         js=mqtransmod.sljsin.pop(0)
         g = json.loads(js)
         razborjscmd(g)
         mp('lime','razbor='+str(g))
         if not 'cmd' in g.keys():return
         if g['cmd']=='ac_reload':
          rmp('cyan','razbor='+g['cmd']+' /ac='+g['ac']+' bidch='+g['bidch'],3)

        l=len(tolsoutjs)
        # if l>0: mp('blue','timerlsoutjs.......................L='+str(l))
        try:
         if  len(tolsoutjs)>0:
          s=tolsoutjs.pop(0)
          mqttclient.publish('tss_mqtt',s)
          mp('red', 'suda ='+s)
          #mp('yellow', 'timerlsoutjs='+s)
        except Exception as ee:
         mpr('timerlsoutjs',ee)


def fpgs_connect():
 try:

  conn = psycopg2.connect(
    host    =gprm['-host'],
    database=gprm['-dbname'],
    user="postgres",
    port=5432,
    password="postgres")
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')

def zget_dt(ac):
  for i in range(1,3,1):
   try:
    dt=chskd.get_dt(ac)
    return dt
   except Exception as ee:
    mprs('zget_dt',ee)
    gevent.sleep(0.1)

def freadallkeys(sac):
    rmp('red','FIRST freadallkeys sac='+str(sac),5)
    # ls = chskd.read_all_keys(int(sac))
    # mp('red', 'freadallkeys FIRST ls=' + str(ls))

    for i in range(1, 2, 1):
     try:
      ls=chskd.read_all_keys(int(sac))
      mp('red','ls='+str(ls))
      break
     except Exception as ee:
        mpr('freadallkeys', ee)


def formirmaskaslava(m):
  try:
   ls=[]
   for n in m:
    ls.append(int(n))
   return ls
  except Exception as ee:
    mpr('formirmaskaslava',ee)

def faddkey(ac,kl,maska):
    key = acs.Key()
    kl = gfunc.zerol(kl, 12)
    x = gfunc.keytox(kl)
    key.code = x
    mp('red', 'BEFORE faddkey kl=' + kl + ',' + maska)
    key.mask = formirmaskaslava(maska)  # [1,2,3,4,5,6,7,8]
    key.pers_cat = 1
    try:
        chskd.add_key(ac, key)
        mp('red', 'faddkey kl=' + kl + ',' + maska)
    except Exception as ee:
        mpr('faddkey', ee)


def fdeleteallkeys(sac):
   for i in range(1,3,1):
    try:
     rc=chskd.del_all_keys(int(sac))
     break
    except Exception as ee:
     mpr('fdeleteallkeys',ee)

def get_sernum(ac):
    for i in range(1,3,1):
     try:
      rc=chskd.ser_num(ac)
      return rc
     except Exception as ee:
      mprs('get_sernum',ee)
      gevent.sleep(0.1)

def getprog_ver(ac):
    for i in range(1,3,1):
     try:
      rc=chskd.prog_ver(ac)
      return rc
     except Exception as ee:
      mprs('getprog_ver',ee)
      gevent.sleep(0.1)

def getprog_id(ac):
    for i in range(1,3,1):
     try:
      rc=chskd.prog_id(ac)
      return rc
     except Exception as ee:
      mprs('getprog_id',ee)
      gevent.sleep(0.1)


def getacinfo(ac):
 try:
      g={}
      if chskd !=None:
          g['ac']=ac
          g['prog_id'] =str(getprog_id(ac))
          g['prog_ver']=str(getprog_ver(ac))
          g['ser_num'] =str(get_sernum(ac))
          g['keys_info']=chskd.keys_info(ac)
          g['events_info']=chskd.events_info(ac)
          mp('red','getacinfo='+str(g))
          # tobaseacinfo(g)
      else:
        g=None
      return g
 except Exception  as ee:
   mpr('getacinfo.error ac='+str(ac),ee)

def pgc_selfsel(gin):
     try:
      pgc=gin['pgc']
      curs2 = pgc.cursor()
      select_query=gin['sql']
      curs2.execute(select_query)
##      row = curs2.fetchclone()
      loc = curs2.fetchall()

##      loc = cur.fetchall()
##      row = cur.fetchone()


      gin['rc']='ok'
      gin['curs']=loc
##    row.close
      curs2.close
      print ('cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc')
      return gin
     except (Exception, Error) as ee:
      row=None
      print("Ошибка при работе с PostgreSQL", str(ee))
      mpr('pgc_selfsel',ee)
      gin['rc']=str(ee)
      gin['row']=row
      return gin



def pgc_selfupd(gin):
##     ВХОДНЫЕ ПАПАМЕТРЫ

##    gin['sql'] STRING insert update delete
##    gin['pgc'] соединение с базой
##    gin['fc']  комиТидь каждую запись
##    gin['myid']  возвращать id record

##     ВЫХОДНЫЕ ПАПАМЕТРЫ
##    gin['rc']  ok или текст ощибки

  pgc=gin['pgc']
  insert_query=gin['sql']

  cursor2 = pgc.cursor()
  try:
    cursor2.execute(insert_query)
    gin['rc']='ok'
    if gin['fc']:
     pgconn.commit
     cursor2.close
  except (Exception, Error) as ee:
   print("Ошибка при работе с PostgreSQL", str(ee))
   gin['rc']=str(ee)


def razbor1(gin):
  try:
    cmd=gin['cmd']
    mp('white','razbor1 cmd='+cmd+'> kto='+gin['kto'])
    if cmd == 'set_ch_opros':
      regim=g['regim']
      rmp('y',regim,5)
  except Exception as ee:
   mpr('y','razbor1',ee)




def on_unsubscribe(client, userdata, mid):
    print("UnSubscribed! mid:",mid)
    time.sleep(1)
    print('Do DisConnect!')
    client.disconnect()

def testselect(g):
    s='SELECT name,myid,bp FROM tssloc_locations'

    g['sql']=s
    g['pgc']=pgconn
    for j in range(1,2,1):
     g=pgc_selfsel(g)
     for row in g['curs']:
         name=row[0]
         myid=str(row[1])
         bp  =str(row[2])
         s='MAIN '+name+zp+name+zp+myid+zp+bp+zp
         print ('j='+str(j)+' '+s)
    ##g['curs'].close



def testinsert(g):

    for i in range(1,1000,1):
      cursor2 = pgconn.cursor()
      s='delete from tss_test1'
      cursor2.execute(s)
      for j in range(1,1000,1):
         pr=str(i)
         vcmd='cmd'+pr
         vkto='kto'+pr
         g['nn']=i
         s='INSERT INTO tss_test1(cmd,kto)values('+ \
         ap+vcmd+ap+zp+ap+vkto+ap+')'
         print ('s='+str(s))
         g['sql']=s
         g['pgc']=pgconn
         g['fc'] =True
         g['myid']=False
         pgc_selfupd(g)

def mydt_to_tssdt():
   try:
     tssdt=cgonsdt()
     # return tssdt
     cd=gfunc.mydatezz()
     ct=gfunc.mytime()[0:8]
     # mp('red','mydt_to_tssdt cd='+str(cd)+' /ct='+str(ct))

     ls=cd.split('.')
     tssdt.year=int(ls[0])-2000
     tssdt.month=int(ls[1])
     tssdt.day  =int(ls[2])
     sd=str(tssdt.year)+'.'+str(tssdt.month)+'.'+str(tssdt.day)
     # rmp('blue','mydt_to_tssdt sd='+sd,5)

     # tssdt.hour=0
     # tssdt.minute=0
     # tssdt.second=0
     # return tssdt
     ls=ct.split(':')
     # mp('red','mydt_to_tssdt ls='+str(ls))
     tssdt.hour=int(ls[0])
     tssdt.minute=int(ls[1])
     tssdt.second=int(ls[2])
     s=str(tssdt.year)+','+str(tssdt.month)+','+str(tssdt.hour)+','+str(tssdt.minute)+','+str(tssdt.second)
     st=str(tssdt.hour)+':'+str(tssdt.minute)+':'+str(tssdt.second)
     # rmp('blue','mydt_to_tssdt sd='+sd+' /st='+st,5)
     return tssdt
   except Exception as ee:
     mpr('mydt_to_tssdt',ee)



def slavadttomydt(dt):
    try:

      dt.year=dt.year+2000
      d='%.4d.%.2d.%.2d'% (dt.year, dt.month,dt.day)
      t= '%.2d:%.2d:%.2d' %(dt.hour, dt.minute, dt.second)
      return d+' '+t
    except Exception as ee:
     mpr('gonscovertdt',ee)



def gonscovertdt(evt):
    try:
      # rmp('cyan','NEWevt='+str(evt),1)
      if  evt.dt.year<2000:
       evt.dt.year=evt.dt.year+2000
      # evt.dt.year = evt.dt.year #suda
      d='%.4d.%.2d.%.2d'% (evt.dt.year, evt.dt.month,evt.dt.day)
      t= '%.2d:%.2d:%.2d' %(evt.dt.hour, evt.dt.minute, evt.dt.second)
      # ls=['2018.01.01','2017.01.01','2016.01.01']
      # d=random.choice(ls)
      dt=d+' '+t
      # rmp('red','gonscovertdt================='+dt,1)
      return dt
    except Exception as ee:
     mpr('gonscovertdt',ee)




def convertwiegand(k):
 return k ^ 0x3FFFFFF



def getresultkey(e):
# is_access_granted: False,
# code: 1629190,
# addr: 6,
# no: 119,
# is_time_restrict_done: False,
# is_key_found: False,
# is_key_search_done: True,
# is_time_restrict: False,
# is_last: True,
# is_complex: False,
# is_open: False,
# dt: DateTime(hour: 8, month: 8, second: 48, year: 4017, day: 18, minute: 12),
# port: 1)


    rc='u?'
    # mp('red','getresultkey='+str(e))

    if e.is_key_found==False:
       rc= 'knf'
       return rc

    if e.is_open:
       rc= 'go'
       return rc

    if e.is_time_restrict:
       rc= 'tz1'
       return rc
    if not e.is_access_granted:
       rc= 'bm'
       return rc
#    if e.isKeySearchDone and   e.isKeyFound==True:
#       rc='go2'
#       return rc
    if e.is_key_found==True:
       rc='fnd'
       return rc

    if  e.isTimeRestrictDone:
       rc='tmz'
       return rc
    return rc



def topgctr(gx):
    mp('white','gx='+str(gx))

def  formirtodms(gin):
    # mp('yellow','formirtodms='+str(gin))
    vuxt, ms = gfunc.myuxtms()
# 'm1': datetime.datetime(2022, 12, 6, 4, 39, 20, 94217), 'av': 'k', 'ev': 'key', 'ac': 77, 'port': 1,
# 'kluch': '0000007716AA', 'ikluch': '00000388E955', 'rst': 'undk', 'cd': '4022.12.06 04:39:48',
# 'no': 30812, 'uxt': 1670290760}

    jb = {
        "cmd"   : 'src1todms',
        "subcmd": 'src1todms',
        "no"    :  str(gin['no']),
        "av"    : gin['av'],
        "ev"    : gin['ev'],
        "ac"    : str(gin['ac']),
        "port"  : str(gin['port']),
        "kluch" : str(gin['kluch']),
        "ikluch": str(gin['ikluch']),
        "rst"   : str(gin['rst']),
        "cdc"   : str(gin['cd']),  #дата время контроллера
        "vuxt"  : str(vuxt),
        "ch"    : mbch['ch'],
        "pidch"    : mgb['pidch'],
        "bidch" : mgb['bidch'],
        "bidcomp": mgb['bidcomp'],
        "bidac"  : mbacl['ac']['bidac']
    }
    s = json.dumps(jb)
    mp('yellow', 'formirtodms=' + s)
    tolsoutjs.append(s)


def fsrc1209(g):
  try:
    # mp('red','fsrc1209 g='+str(g))
    vuxt,ms=gfunc.myuxtms()
    id= str(g['ac'])+'.'+ str(g['no'])
    ac=int(g['ac'])
    if not  'code' in  g.keys():
      code=-1
    else:
     code=g['code']
    job = {
            'cmd'     : 'src1todms',
            'subcmd'  : 'src1todms',
            'vuxt'    :vuxt,
            'typs': 209,
            'ch'  : g['ch'],
            'kto' : g['kto'],
            'bidcomp': int(g['bidcomp']),
            'bidch': int(g['bidch']),
            'bidac': mbacl[ac]['bidac'],
            'no': int(g['no']),

            'pidch' : g['pidch'],
            'cdc'   : str(g['cd']),   # date and time event of controller
            'vuxt'   : vuxt,             # time of registration
            'ms'     : ms,
             'av'    : g['av'],
             'ev'    : g['ev'],
             'ac'    : g['ac'],
             'port'  : g['port'],
             'kluch' : g['kluch'],
              'code'  :code,
             'ikluch': g['ikluch'],
             'rst'   : 'rst'

    }
    s = json.dumps(job)
    # mp('cyan','fsrc1209.s='+s)
    tolsoutjs.append(s)
  except Exception as ee:
    mpr('fsrc1209',ee)




def showevt(evt):
  try:
      kl='abcdefabcdef'
      code=gfunc.keytox(kl)
      ik = convertwiegand(code)
      avx='UND'
      if evt==None:
        return
##      print ('SHOWEVT='+str(evt))
      t=type(evt)
      chs=chskd
      avx=evt.is_complex
      if avx:
       av='k'
      else:
       av='a'
      g={}
##      g['alias']=mgb['selfip']
      ac=evt.addr
      g['adrc']=ac
      p=evt.port
      g['port']=p
      avx=evt.is_complex
      if avx: av='kpx'
      else:   av='avt'
      g['av']=av
      g['code']=code
      g['kluch']=kl
      g['kto'] = mgb['zclid']
      # if av=='a':
      dtdelta=0
      uxt,ms=gfunc.myuxtms()
      cd=gonscovertdt(evt)
      cd=cd.replace('.','-')
      # rmp('yellow', 'showevt cd=' + str(cd), 1)
      tc = gfunc.mstouxt(cd)
      ls=cd.split(' ')
      if av == 'k':
        dtdelta = uxt - tc
        g['dtdelta']=dtdelta
      # rmp('yellow', 'showevt DTDELTA================================== ' + str(dtdelta),1)

      g['cd']=ls[0]
      g['ct']=ls[1]
      # rmp('red','showevt ls='+str(ls)+' /cd='+g['cd'],2)
      g['rst']='u'
      if  isinstance(evt, acs.EventKey):
          g['no']=evt.no
          g['kto']=mgb['zclid']
          code=evt.code
          kl=gfunc.xkeytos(code)
          cd=gonscovertdt(evt)
          r=evt.is_access_granted
          if av=='kpx':
           code=evt.code
           kl=gfunc.xkeytos(code)
           g['kl']=kl
           g['rst']='und'
           # g['rst']=work_key_komplex(g)
           ev='key'
           g['event']=ev
           g['code']=code
           g['rst']=getresultkey(evt)
           g['kluch']=gfunc.xkeytos(code)
           ik=convertwiegand(code)
           ik=str(gfunc.xkeytos(ik))
           # if r :g['rst']='go'
           # else :g['rst']='ad'
           g['rst']='undk'
           dts=str(dtdelta)
           poll = str(mbch["regim_opros"])
           s = 'av=%2s ,ev=%8s , ac=%3s,p=%2s,kl=%8s,IK=%8s,rst=%8s,dt=%8s ,dtd=%2s,poll=%3s' % (\
           av, ev, str(ac), str(p), str(kl), ik, g['rst'], cd,dts,poll)

           mp('lime','AVR KEY HOWEVT='+s)
           gz={}
           if 'dtdelta' in g.keys() :
            gz['dtdelta']=g['dtdelta']
           gz['av']=av
           gz['kto']=g['kto']
           gz['ev']=ev
           gz['ac'] =ac
           gz['port']=p
           gz['kluch'] =kl
           gz['ikluch'] =ik
           gz['code']=g['code']
           gz['rst'] = g['rst']
           gz['cd'] = cd
           gz['no']=g['no']
           gz['uxt'] = stofunc.nowtosec('loc')
           gz['pidch']=mgb['pidch']
           gz['bidch'] = mgb['bidch']
           gz['bidcomp'] = mgb['bidcomp']
           gz['ch']=mbch['ch']
           fsrc1209(gz)
           rmp('yellow','tuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu',1)
           tmr=1
           try:
            # gz={}
            # gz['ac']=int(ac)
            # gz['port']=int(g['port'])
            # gz['tmr']=int(tmr) * 2
            # lsgrelay.append(gz)
            pass
            return
            # chskd.relay_on(int(ac),int(g['port']),int(tmr * 2))
           except Exception as ee:
            mprs('call relay_on',ee)
           gx={}
           gx=g
           gx['pgc'] = mgb['pgc']
           gx['kto'] = mgb['zclid']
           gx['komu'] = mgb['zclid']
           gx['cmd'] = 'updsql'
           gx['txt'] = 'update tss_tr set flagr=' + ap + 'new' + ap + zp + \
           ' komu=' + ap + mgb['zclid'] + ap + zp + \
           ' cmd='+ap+'acsev'+ap+\
           ' where kto=' + ap + mgb['zclid'] + ap + ';'
           mgb['lstoguard'].append(gx)
           return

          r=evt.is_access_granted
          if r :g['rst']='go'
          else :g['rst']='ad'
          ev='key'
          g['rst']=getresultkey(evt)
          g['event']=ev
          g['kluch']=gfunc.xkeytos(code)
          ik=convertwiegand(code)
          ik=str(gfunc.xkeytos(ik))
          gz = {}
          gz['kto'] = g['kto']
          gz['dtdelta'] = dtdelta
          gz['av'] = av
          gz['ev'] = ev
          gz['ac'] = ac
          gz['port'] = p
          gz['kluch'] = kl
          gz['ikluch'] = ik
          gz['rst'] = g['rst']
          gz['cd'] = cd
          gz['no'] = g['no']
          gz['uxt'] = stofunc.nowtosec('loc')
          gz['pidch'] = mgb['pidch']
          gz['bidch'] = mgb['bidch']
          gz['bidcomp'] = mgb['bidcomp']
          gz['ch'] = mbch['ch']
          fsrc1209(gz)

          s='av=%2s ,ev=%8s , ac=%3s,p=%2s,kl=%8s,IK=%8s,rst=%8s,dt=%8s' % (av,ev,str(ac),str(p),str(kl),ik,g['rst'],cd)
          mp('lime','KEY SHOWEVT_A='+s)

      if  isinstance(evt, acs.EventDoor):
          # mp('red','showevt='+str(evt)[0:110])
          # cd=gonscovertdt(evt)

          ev=evt.is_open
          if ev:ev='open'
          else:ev='close'
          code=code
          chs=gprm['-ch']
          g['event']=ev
          g['no']=str(evt.no)
          gz = {}
          gz['kto'] = g['kto']
          gz['dtdelta'] =dtdelta
          gz['av'] = av
          gz['ev'] = ev
          gz['ac'] = ac
          gz['port'] = p
          gz['kluch'] = kl
          gz['ikluch'] = ik
          gz['rst'] = g['rst']
          gz['cd'] = cd
          gz['no'] = g['no']
          gz['uxt'] = stofunc.nowtosec('loc')
          gz['pidch'] = mgb['pidch']
          gz['bidch'] = mgb['bidch']
          gz['bidcomp'] = mgb['bidcomp']
          gz['ch'] = mbch['ch']
          gz['kto']=g['kto']
          fsrc1209(gz)

          poll=str(mbch["regim_opros"])
          s='????DATA av=%2s ,ev=%8s , ac=%3s,p=%2s , dt=%8s, poll=%3s'  % (av,ev,str(ac),str(p),cd,poll)
          mp('yellow',s)
##          formirgeconbase(g)
##          tosockets_event(g)
##          # tosepar(g)

      if  isinstance(evt, acs.EventButton):
          ac=evt.addr
          p=evt.port

          g['event']='rte'
          av=evt.is_complex
          if av:av='k'
          else: av='a'
          code=code
          cd=gonscovertdt(evt)
          # ev=evt.is_open
          ev='rte'
          g['no']=str(evt.no)
          poll = str(mbch["regim_opros"])
          s='av=%2s ,ev=%8s , ac=%3s,p=%2s ,kl=%8s, dt=%8s,poll=#s' % (av,ev,str(ac),str(p),str(code),cd)
          mp('magenta',s)
  except Exception as ee:
   mpr('showevt',ee)

def tobaseremove(ac,descr,code):
   zp=','
   try:
    s = 'insert into tss_acerr(bpcomp,bpch,code,ac,erm)values( ' + \
    str(mgb['bidcomp'])+zp+ \
    str(mgb["bidch"]) +zp+ \
    str(code)+zp+\
    str(ac)+zp+\
    ap+descr+ str(ac)+ap+\
    ');'
    mp('cyan', 'tobasestart=' + s)
    curs2 = pgconn.cursor()
    curs2.execute(s)
    pgconn.commit()
    curs2.close()
   except Exception as ee:
    mprs('tobasestart', ee)




def tobasestart():
   np=gfunc.myappexe()
   zp=','
   try:
    code=3
    sp=''
    for k in gprm:
     v=gprm[k]
     sp=sp+k+' '+v+' '
    s = 'insert into tss_acerr(pid,bpcomp,bpch,code,erm)values( ' + \
    str(mgb['pidch']) + zp + \
    str(mgb["bidcomp"]) + zp + \
    str(mgb["bidch"]) +zp+ \
    str(code)+zp+\
    ap+'START '+np+sp+ap+\
    ');'
    mp('cyan', 'tobasestart=' + s)
    curs2 = pgconn.cursor()
    curs2.execute(s)
    pgconn.commit()
    curs2.close()
   except Exception as ee:
    mprs('tobasestart', ee)


def tobasek2():
   zp=','
   try:
    # rmp('yellow','tobasek2',5)
    for ac in addrs:
        # mp('cyan','ac='+str(ac))
        k1=fk1(ac)
        k2=fk2(ac)
        code=2
        if mbacl[k2] != 0 :
         s = 'insert into tss_acerr(pid,bpcomp,bpch,code,speedch,ac,sumerr)values( ' + \
         str(mgb['pidch'])+zp+\
         str(mgb["bidcomp"]) + zp + \
         str(mgb["bidch"]) +zp+\
         str(code)+zp+ \
         str(mbch['spd']) + zp + \
         str(ac)+zp+\
         str(mbacl[k2])+');'
         mp('cyan','tobasek2='+s)
         curs2 = pgconn.cursor()
         curs2.execute(s)
         pgconn.commit()
         curs2.close()
         mbacl[k2] = 0

   except Exception as ee:
    mprs('tobasek2',ee)


def  tobase_acerr(ac,erm):
  try:
    redlog('tobase_acerr ac='+str(ac)+' /erm='+erm)
    zp=','
    k = str(ac) + '.cerr'
    code=1
    s='insert into tss_acerr(pid,bpcomp,bpch,code,ac,counterr,speedch,erm)values( '+ \
    str(mgb['pidch']) + zp + \
    str(mgb["bidcomp"]) + zp + \
    str(mgb["bidch"])+zp+\
    str(code)+zp+\
    str(ac)+zp+str(mbacl[k])+zp+\
    str(mbch['spd'])+zp + \
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

def find10054(p):
  try:
   i=-1
   i=p.index('10054')
  except Exception as ee:
   mp('lime','find10054 i='+str(i))
   i=-1
  return i



def mypinger(url):
    def myping(ping):
        rc = 0
        res = subprocess.call(['ping', '-n', '1', ping])
        print ('res='+str(res))
        print ( 'res=', res)
        rc = rc + int(res)
        return rc
"""
    try:
        rc=-1
        cmd = 'ping  ' + url + '>gping.txt -n 2'
        cmd = 'ping  ' + url+' -n 1'
        rmp('magenta', 'CALL ping cmd='+cmd,10)
        rc = os.system(cmd)
        rmp('yellow','mypinger='+str(rc),20)
        if rc == 0:
            rmp('lime', 'ping url=' + url + ' /rc=' + str(rc),10)
        else:
            rmp('red', 'ping url=' + url + ' /rc=' + str(rc),10)
        return rc
    except Exception as ee:
        mprs('mypinger', ee)
        return rc
"""
def redlog(txt):
    ch=gprm['-ch']
    cd=gfunc.mydatezz()
    ct=gfunc.mytime()
    cds=cd+' '+ct+' '
    appdir=gfunc.getmydir()
    fn=appdir+'redlog'+sep+ch+'.log'
    # print ('fn=',fn)
    outp=open(fn,'a')
    outp.write(cds+txt+'\n')
    outp.flush()
    outp.close()

def arestore(ac,erm):
   try:
    k =str(ac) + '.cerr'

    redlog('ARESTORE mbacl[k]=' + str(mbacl[k]) + '   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
    tobase_acerr(ac,erm)
    rc=find10054(erm)
    if rc>0:
     redlog('CATASTROFIC ERROR 10054 ac='+str(ac))
     tobase_acerr(ac, 'STOP DEMON 1 ' + mgb['zclid'] + '--> CATASTROFIC ERROR 10054')
     sys.exit(77)

    k = str(ac) + '.cerr'
    print ('ARESTORE mbacl[k]='+str(mbacl[k])+'   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
    mbacl[k]=0
    x=None
    f=None
    try:
     if gprm['-regim'] !='virtual':
      print ('virtual 1')
      x=chskd.get_event(ac,True)
     else : pass
     f=True
     mbacl[k]=0
     mp('blue','ac Is NOW READY                  WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW')
    except Exception as ee:
      rc = find10054(str(ee))
      if rc > 0:
        tobase_acerr(ac, 'STOP DEMON 2 ' + mgb['zclid'] + '--> CATASTROFIC ERROR 10054')
        sys.exit(77)
      addrs.remove(ac)
      tobaseremove(ac,' исключен из опроса',99)
      mgb['recoverac'] = 'yes'
      mgb['recoveraclist'].append(ac)
      rmp('magenta', 'REMOVE AC FROM ADDRS',5)
      rmp('magenta',str(addrs),10)
      tobaseremove(ac, 'включен в опрос', 98)
      if len(addrs)==0 :
        tobase_acerr(ac,'STOP DEMON '+mgb['zclid']+' --> LIST ADDRS IS EMPTY')
        sys.exit(77)
    return True
   except Exception as ee:
    mprs('ARESTORE',ee)


def getvirtev(ac) :
    # print ('getvirtev='+str(ac))
    pass

def get_event(addr,kpx):
    try:
        # if gprm['-regim']=='virtual': return None
        while len(lsgrelay)>0:
         g= lsgrelay.pop(0)
         chskd.relay_on(g['ac'],g['port'],g['tmr'])
         mp('white','RELAY='+str(g))

        ev=None
        ac=addr
        k = str(addr) + '.cerr'
        is_complex=True
        try:
         # print('getevent tut1 ')
         if gprm['-regim']=='real':
          ev=chskd.get_event(addr, kpx)
         # mp('white','W ev=' + str(ev)[0:40])
          if isinstance(ev, acs.EventKey):
            mp('blue','ev='+str(ev)[0:40])

         else:
          ev=getvirtev(addr)
         mbacl[k]=0
         if ev != None:
            print ('get_event='+str(ev))
            showevt(ev)
        except Exception as ee:
         k2 =fk2(addr)
         mbacl[k2]=mbacl[k2]+1
         mprs('get_event   k2='+str(mbacl[k2])+' / ac='+str(addr),ee)
         mbacl[k]=mbacl[k]+1
         if mbacl[k]>=limitacerr:
          rc=arestore(addr,str(ee))
         return None

    except Exception as ee:
        mprs('get_event tuta',ee)
        g={}
        g['cmd']='error_ac'
        g['adrc']=str(addr)
        g['event']=str(ee)
##        g['maca']=mgb['maca']



def poll_event():
    # if mbch['regim_opros']=='dummy' :return
    # kpx=True
    print('poll_event mbch[regim_opros] ='+mbch['regim_opros'])
    if mbch['regim_opros'] =='avt':
        kpx=False
        print ('kpx=',kpx)
    if mbch['regim_opros'] =='kpx': kpx = True

    if mgb['countstart'] == 0:
        mgb['countstart'] =mgb['countstart']+1
        tobasestart()
    while True:
        # if m7func.mgb['busy']:return
        evt=None
        gevent.sleep(0.01)
        for addr in addrs:
           # if glsacrg[addr]=='w': return None
##           if acstop[addr]=='poll':
##             if glsacrg[addr]=='a':
              try:
##               print('poll_event addr='+str(addr))
               # mp('yellow','addr='+str(addr)+' call getevent AVTONOM')
               mbch['cnt1']=mbch['cnt1']+1
               # print('poll_event BEFORE mbch[regim_opros] =' + mbch['regim_opros'])
               r=False
               if  mbch['regim_opros']=='avt':
                kpx=False
                r  =False
               if  mbch['regim_opros']=='kpx':
                 evt = get_event(addr,True)
               if  mbch['regim_opros']=='avr':
                evt = get_event(addr, False)


              except Exception as ee:
               pass


def formir_jb(g):
    try:
      vuxt,ms=gfunc.myuxtms()
      jb= {
          "cmd": g['cmd'],
          "subcmd": g['subcmd'],
          "ch_status": mbch['status'],
          "status": g['status'],
          "ch"    : g['ch'],
          "kto"   : g['kto'],
          "komu"  : g['komu'],
          "vuxt"  : str(vuxt) ,
          "ms": str(ms),
          "pidch": str(mgb['pidch']),
          "errcode":g['errcode']
      }
      s = json.dumps(jb)
      # todiskjsfile(s)  #suda1
      mp('yellow', 's =' + s)
      tolsoutjs.append(s)
      return s

    except Exception as ee:
     mpr('formir_infostart',ee)





def glstojsonstr(gx):
  try:
    js = json.dumps(gx)
    return js
  except Exception as ee:
   mprs('glstojsonstr',ee)
   return None

def crjs_mbch():
   pass

def out_white(text):
    print("\037[47m {}".format(text))

def out_lime(text):
    print("\035[45m {}".format(text))

def fk2(ac):
    k2 = str(ac) + '.sumerr'
    return k2

def fk1(ac):
 k1 = str(ac) + '.cerr'
 return k1

def readacl():
  try:
    ls=[]
    s='select myid,ac,actual from tss_acl where bp='+str(mgb['bidch']) +' and actual=True'
    mp('lime','readacl='+s);
    pgc = pgconn
    curs2 = pgc.cursor()
    curs2.execute(s)
    loc = curs2.fetchall()
    for row in loc:
        myid = row[0]
        ac = row[1]
        mbacl[ac]={}
        mbacl[ac]['bidac']=myid
        ls.append(ac)
    return ls,mbacl
  except Exception as ee:
      row = None
      mpr('readacl', ee)
      return None


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

        pgc =pgconn
        curs2 = pgc.cursor()
        curs2.execute(s)
        loc = curs2.fetchall()
        # mp('lime','mgb='+str(mgb))
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


def onclftpsrv(sender,g):
    try:
     mp('cyan', 'oncl g=' + str(g))
     if not 'cmd' in g.keys():return
     cmd=g['cmd']
     if cmd=='TEST': return
     if g['kto'] == mgb['zclid']:return
     mp('yellow','oncl g='+str(g))
     razbor1(g)
    except Exception as ee:
      mpr('oncl',ee)

def checklsdelaym():
    if len (mgb['lsdelayedmessage'])==0 :return
    g= mgb['lsdelayedmessage'].pop(0)
    mp('red','checklsdelaym='+str(g))
    mysend(g)



def checkping(url):
    print('checkping start')
    rc =-1
    fn='gping.txt'
    cmd = 'ping  ' +url+ '>'+fn+' -n 2'
    os.system(cmd)
    for i in range(1,2,1):
     gevent.sleep(1)
     if os.path.isfile(fn):
      mp('cyan','i='+str(i))
      inp=open(fn,'r')
      ls=inp.readlines()
      s=str(ls)
      try:
       # print('s=',s)
       n = s.index('TTL')
       rc=n
       print ('n==================================',n)
      except:
        rc=-1
        print('rc?????==================================', rc)
      # mp('lime',str(ls))
      break
    return rc

def fjb_infostart(g):
   try:
    uxt=stofunc.nowtosec('loc')
    vuxt,ms=gfunc.myuxtms()
    jb= {"cmd": 'ch_infostart',
          "subcmd": g['subcmd'],
          "ch_status" :mbch['status'],
          "points" : g['points'] ,
          "bidcomp": str(mgb['bidcomp']),
          "bidch": str(mgb['bidch']),
          "ch": gprm['-ch'],
          "uxt": str(uxt),
          "kto": mgb['zclid'],
          "mystamp": ms,
          "status": g['status'],
          "errcode": g['errcode'] ,
          "pidch": str(mgb['pidch']),
           'vuxt'  : str(vuxt),
          'ms': str(ms),
          "pret"  : g['pret']
          }
    s = json.dumps(jb)
    # mp('red', 'BEFORE s =' + s)
    tolsoutjs.append(s)

   except Exception as ee:
     mpr('fjb_infostart', ee)


def formir_totop(points,pret,subcmd,errcode,status):

    mp('blue','totop subcmd='+subcmd+' /status='+status)
    g={}
    g['cmd']=subcmd
    g['subcmd']=subcmd
    g['points'] =points
    g['pret']=pret
    g['errcode']=errcode
    g['status']=status
    if subcmd=='infostart':fjb_infostart(g)



def get_interval():
    return 10

def checkdt(dt):
  try:
    # return
    # mp('red','checkdt='+str(dt))
    ux1=stofunc.nowtosec('loc')
    ux2=int(gfunc.kosta_dttoux(dt))
    delta=ux1-ux2
    return delta
  except Exception as ee:
    mpr('checkdt',ee)

def kosta_dttoux(st):
 # st='2017.11.14 4:31:00' sample
 from datetime import datetime
 import time
 # mp('red','kosta_dttoux st='+str(st))
#poluchit normalniy date object
 try:
    date_obj = datetime.strptime(st,'%Y.%m.%d %H:%M:%S')
    #unix stmap
    unix_stamp=time.mktime(date_obj.timetuple())
    # print 'date_obj=',date_obj
    # print 'unix_stamp=',unix_stamp
    ux=int(unix_stamp)
    return ux
    # print 'ux=',unix_stamp
 except Exception as ee:
  print ('kosta_dttoux='+str(ee))
  mp('r','kosta_dttoux ee='+str(ee))

def kosta_uxtodt(ux):
    from datetime import datetime
    import time
    try:
     # ts = time.time()
     # ts=int(stofunc.sectodatetime('UTC'))
     st = datetime.datetime.fromtimestamp(ux).strftime('%Y-%m-%d %H:%M:%S')
     return st
    except Exception as ee:
     mpr('kosta_uxtodt',ee)

def mysetdtac(skd,ac):
 try:
  dt = mydt_to_tssdt()
  # rmp('yellow', 'mysetdtac=' + str(dt),1)
  skd.set_dt(ac, dt)
 except Exception as ee:
  mpr('mysetdtac',ee)

def z_formiracinfoone(acx):
     try:
       dt = zget_dt(acx)
       if dt==None:return None
       gevent.sleep(0.5)
       dtg=slavadttomydt(dt)
       g=getacinfo(acx)
       mbacl[acx]['prog_ver']=g['prog_ver']
       mbacl[acx]['prog_id'] = g['prog_id']
       mbacl[acx]['ser_num'] = g['ser_num']
       mbacl[acx]['keys_info'] = g['keys_info']
       mbacl[acx]['events_info'] = g['events_info']
       mbacl[acx]['ms'] =dtg
       mp('red','z_formiracinfoone mbacl='+str(mbacl[acx]))
       return g
     except Exception as ee:
       mpr('z_formiracinfoall',ee)

def z_sendjs(g):
# g=
# {'ac': 3,
# 'prog_id': 156,
# 'prog_ver': (1, 83),
# 'ser_num': 4193,
# 'keys_info': (64260, 9),
# 'events_info': (1039011, 3)}
    mp('red', 'z_sendjs g =' +str(g))
    vuxt, ms = gfunc.myuxtms()
    mp('blue','z_sendjs='+str(g))
    ac=g['ac']
    if not 'idcmd' in g.keys():
     g['idcmd']='-1'
    jb = {
    "cmd": 'getacinfo',
    "idcmd":g['idcmd'],
    "subcmd": 'getacinfo',
    "ch_status": mbch['status'],
    "status": 'status',
    'ac': str(g['ac']),
    "ch": mgb['ch'],
    "kto": mgb['zclid'],
    "komu": 'all',
    "vuxt": str(vuxt),
    "ms": str(ms),
    "pidch": str(mgb['pidch']),
    "bidcomp": str(mgb['bidcomp']),
    "bidch": str(mgb['bidch']),
    "bidac": str(mbacl[ac]['bidac']),
    "prog_id":str(g['prog_id']),
    "prog_ver":str(g['prog_ver']),
    "ser_num" :str(g['ser_num']),
    "keys_info":str(g['keys_info']),
    "events_info":str(g['events_info']),
    "coderc": str(g['coderc'])
    }
    s = json.dumps(jb)
    mp('yellow', 'json =' + s)
    ss='insert into tss_acinfo(ac,bpcomp,bpch,jsinfo)values('+\
       str(g['ac'])+zp+mgb['bidcomp']+zp+mgb['bidch']+zp+ap+s+ap+')'
    tolsoutjs.append(s)
    mp('red','STARTacinfo='+s)
    myinsretreturn(ss) #suda0219

def z_formiracinfoonlyac(ac,idcmd):
  try:
    g=z_formiracinfoone(ac)
    if g!=None:
       g['coderc']='ok'
       g['idcmd']=idcmd
       z_sendjs(g)
  except Exception as ee:
   mpr('z_formiracinfoonlyac',ee)
   g['coderc'] = 'err'
   return g

def z_formiracinfoall():
  for acx in addrs:
     mp('red','z_formiracinfoall acx='+str(acx))
     try:
       g=z_formiracinfoone(acx)
       if g!=None:
           g['coderc']='ok'
           z_sendjs(g)
       mp('red','after z_formiracinfoone='+str(g))
     except Exception as ee:
       mpr('z_formiracinfoall',ee)
       g['coderc'] = 'err'
       return g


def timertest(interval):
    while True:
      try:
         gevent.sleep(interval)
         ac=3
         keys=chskd.keys_info(ac)
         mp('red','timertest keys='+str(keys))
         try:
             lskeys = chskd.read_all_keys(ac)
         except Exception as ee:
             mpr('timertest allkeys ', ee)
      except Exception as ee:
       mprs('timertest info',ee)


#================mgbs=================================================================

init(autoreset=True)
ap=chr(0x27)
zp=','
mgb={}
mgb['pidch']=str(os.getpid())
mgb['spid']=str(os.getpid())
mgb['bidcomp'] = '-1'
mgb['bidch'] = '-1'
tolsoutjs=[]  # список строк JSON  для передачи по каналу MQTT
mgb['ffatal'] = False
gprm=gsfunc.gonsgetp()
mp('red','START ====='+str(gprm))

mbch={}

# appdir=gfunc.getmydir()
# s=appdir+'wav'+sep+'aplay prolog.wav'
# print ('s='+s)
# playsound(s)
winsound.Beep(1600,1000)
# rmp('lime','wwwwwwwwwwww',100)

# os.system(s)


mbch['status']='undef'

tasks=[]
lsgrelay=[]
mgb['lsdelayedmessage']=[]


gprm=gsfunc.gonsgetp()
l = len(sys.argv)
mp('blue','gprm='+str(gprm))
s=''
for i in range(0, l, 1):
  s=s+sys.argv[i]+' '
mgb['launchline']=s
mgb['comp']=(socket.gethostname())
mgb['comp']=mgb['comp'].lower()
mp('lime','comp='+mgb['comp'])
mp('yellow','comp='+mgb['comp'])
# sys.exit(99)



h='tcp://127.0.0.1:5555'
nm=mgb['comp']+'#drv209_'+gprm['-ch']

mgb['zclid']=nm
mp('blue','before connect h='+gprm['-host'])
#sudatrans
mqttclient=mqtransmod.connecttobroker(nm,gprm['-host'])
mqttclient.loop_start()  # start the loop



# clientftpsrv=ccftpsrv(h,nm)
# ccftpsrv.on_receive = onclftpsrv
# task= gevent.spawn(clientftpsrv.run)
# tasks.append(task)


mp('lime','START PROGRAMM  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
redlog('start')
mgb['recoverac'] = 'no'
mgb['recoveraclist']=[]
mgb['fatalerr']=[]
mgb['lstoguard']=[]
mgb['countstart']=0
limitacerr=100
lsjson=[]
lss=[]
gprm=gsfunc.gonsgetp()
pgconn=fpgs_connect()
rmp('lime','pgconn='+str(pgconn),5)

mgb['pgc']=pgconn
if pgconn !=None:
  pass
  # formir_totop('base',0,'infostart','pgcconnok','connect to base ok')
else:
    mgb['fatalerr'].append('errpgcconn')
    formir_totop(0,'infostart','errpgcconn' ,'ERROR on connect to base')
readchparam(gprm['-ch'])
mgb['ch']=gprm['-ch']
mp('yellow','&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
rmp('white','lobs= ?????????????????????????????????????????????',10)
formir_subscrtoguard()




rmp('yellow','POINT 1',3)
# formir_totop(0, 'infostart', 'point3', 'POINT 3')


rmp('yellow','POINT 2',3)
"""
rc=checkping(gprm['-ch'])
if rc<0:
    formir_totop(0,'infostart','errpingch','bad ping onchannel='+gprm['-ch'])
    mgb['fatalerr'].append('errpingch')
    mgb['ffatal']=True
"""
rmp('yellow','POINT 3',3)
gbac={}
lsjstr=[]

mgb['countallmes']=0
mgb['counterrorextrct']=0



mbch['regim_opros']='kpx'   #'avt','kpx','dummy'
mbch['spd'] = 0
mbch['cnt1'] = 0
mbch['sumerr']=0
mbacl={}



mbch['ch']=gprm['-ch']
mbch['cnt1']=0

mp('red','start');


print ('gprm='+str(gprm))
g={}
rmp('yellow','POINT 4',3)

print ('gprm='+str(gprm))
chskd=None

if gprm['-regim'] !='virtual':
    for i in range(1,11,1):
      gevent.sleep(1)
      try:
       chskd = acs.ChannelTCP(gprm['-ch'])
       chskd.response_timeout = 0.01
       mbch['chskd'] = chskd
       rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',2)
       # formir_totop(0,'infostart','crchok', 'create channel ok')
       mbch['status'] = 'ok'
       break
      except Exception as ee:
       mprs('MAIN ATTEMPT CREATECHANNEL='+str(i),ee)
       mbch['chskd']=None



if gprm['-regim'] != 'virtual':
    if mbch['chskd'] == None :
        mgb['fatalerr'].append('errcrch')
        mbch['status']='err'
        formir_totop('channel',0,'infostart','errcrch','ERROR on create channel')
        mgb['ffatal'] = True



mp('red','bidch='+str(mgb['bidch']))
addrs,gac=readacl()
mp('yellow','ADDRS='+str(addrs))



# for k in mbacl:
 # rmp('red','MBACL='+str(mbacl[k]))
mp('red','mbacl='+str(mbacl))
# sys.exit(3)
rmp('white','start test',5)


# freadallkeys(3)
# for i in range(20,40,1):
#  faddkey(3,str(i),'12')
#  gevent.sleep(1)
# freadallkeys('3')

z_formiracinfoall()
# sys.exit(3)




if len(addrs) == 0 :
 mgb['fatalerr'].append('erraclist')
 formir_totop('addrs',0,'infostart','erraclist','ERROR on aclist')
 mgb['ffatal']=True

if gprm['-regim'] !='virtual':
 if mbch['chskd'] == None :
   mgb['ffatal']=True

for ac in addrs:
  addr=addrs[0]
  k  =str(ac)+'.cerr'
  k2=fk2(ac)
  # k2 =str(ac) + '.sumerr'
  mbacl[k]=0
  mbacl[k2]=0
  if gprm['-regim'] !='virtual':
   mysetdtac(chskd,ac)
   gx=getacinfo(ac)
   # mp('blue','gx='+str(gx))
mp('white','mbacl='+str(mbacl))


print ('mbacl=',mbacl)
print ('ADDRS ======================== chskd='+str(chskd)+str(addrs))

if  chskd != None:
 if len(addrs)>0:
     addr=addrs[0]
     # print ('addr='+str(addr))
     # prog_id=str(chskd.prog_id(addr))
     # print ('prog_id='+str(prog_id))
    # else:
    #  print ('НЕТ КОНТРОЛЛЕРОВ --> EXIT')
    #  sys.exit(99)
    #  gbac=getacinfo(addr)
    #  print ('GBAC='+str(gbac))
     ##sys.exit(99)

     # kinfo=chskd.keys_info
     # mp('white','keys_info=='+str(kinfo))
     # mp('yellow','1111111111111111111=======================================================')
    #ver=ch.prog_ver
     # dt=chskd.get_dt(addr)
     # mp('white','DT='+str(dt))
     # mp('yellow','=======================================================')
    ##sys.exit(99)

# try:
#  ls=chskd.read_all_keys(addr)
#  mp ('lime','ls='+str(ls))
# except Exception as ee:
#  mpr('main read_all_keys',ee)
"""
if  chskd !=None  and len(addrs)==0:
 rmp('yellow','chskd=none   addrs='+str(addrs),10)
 gz = {}
 gz['cmd'] = 'infostart'
 gz['ch'] = gprm['-ch']
 gz['kto']=mgb['zclid']
 gz['status'] = 'начал поиск контроллеров '
 mgb['lsdelayedmessage'].append(gz)
 rmp('cyan','CALL FIND ADDRS',10)
 addrs=chskd.find_addrs()
 rmp('lime','нашел '+str(addrs),20)
 """
# task = gevent.spawn(timerfatal,5)
# tasks.append(task)

# tasks.append(gevent.spawn(poll_event))  # suda21
task = gevent.spawn(timer1s, 1)
tasks.append(task)

# task = gevent.spawn(timertest, 10)
# tasks.append(task)

if len(addrs)>0:

 task=gevent.spawn(timerlife,get_interval())
 tasks.append(task)


task = gevent.spawn(timerlsoutjs,0.01)
 tasks.append(task)

 task=gevent.spawn(timerk2,120)
 tasks.append(task)
 pass


task = gevent.spawn(timer30s, int(mgb['lobs']))
tasks.append(task)

''''
if mgb['ffatal']==True:
    task = gevent.spawn(timerfatal,20)
    tasks.append(task)

    task=gevent.spawn(timerrecoverac,30)
    tasks.append(task)
'''

rmp('blue','gevent.joinall(tasks)',5)
 # ls=chskd.find_addrs()
 # formir_chstate() suda 1203
 # rmp('yellow','addrs='+str(addrs),20)
 # client.loop_start()  # start the loop
gevent.joinall(tasks)
# print ('    END EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE')/
# GET_EVENT EE=[WinError 10054] Удаленный хост принудительно разорвал существующее подключение AC=77 EEEEEEEEEEEEEEE

# start "python3.exe   drv209.py  -host  192.168.0.73  -dbname postgres  -ch  192.168.0.96"
#start "python3.exe   drv209.py  -host  192.168.0.73  -dbname postgres  -ch  192.168.0.96"

 # vcgencmd measure_temp  измерить температуру CPU

 # kluch # 0000007716AA # code # ": 7804586,




