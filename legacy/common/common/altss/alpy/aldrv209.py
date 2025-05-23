#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
#import mqtransmod
import psycopg2,json



class algonsdt():
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
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  s ='ch=%10s,%10s,%10s' \
      % (ch,txt,t)
  if c=='t':
   print (s)
   testlog(txt)
   return
  if c != 't':
      gfunc.mpv(c, s)
      #gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
      if c == 'red':
        redlog(txt)
        return
      if c == 'magenta':
          magentalog(txt)
          return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)



def magentalog(txt):
    return
    ch=gprm['-ch']
    cd=gfunc.mydatezz()
    ct=gfunc.mytime()
    cds=cd+' '+ct+' '
    appdir=gfunc.getmydir()
    fn=appdir+'magentalog'+sep+ch+'.log'
    outp=open(fn,'a')
    outp.write(cds+txt+'\n')
    gfunc.mpv('magenta',cds+txt)
    outp.flush()
    outp.close()



def magentalog(txt):
    ch=gprm['-ch']
    cd=gfunc.mydatezz()
    ct=gfunc.mytime()
    cds=cd+' '+ct+' '
    appdir=gfunc.getmydir()
    fn=appdir+'magentalog'+sep+ch+'.log'
    outp=open(fn,'a')
    outp.write(cds+txt+'\n')
    outp.flush()
    outp.close()


def testlog(txt):
    ch=gprm['-ch']
    cd=gfunc.mydatezz()
    ct=gfunc.mytime()
    cds=cd+' '+ct+' '
    appdir=gfunc.getmydir()
    fn=appdir+'testlog'+sep+ch+'.txt'
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




def redlog(txt):
    ch=gprm['-ch']
    toredbase(txt)
    return
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



def formirtk (ac,xkey,ms,tz):
   try:
        keys = []
        key = acs.Key()
        key.code = xkey
        key.mask = ms
        key.pers_cat = tz
        return key
   except Exception as ee:
    mprs('formirtk',ee)



def crip():
 atp=0
 while True:
   try:
    atp=atp+1
    chskd = acs.ChannelTCP(gprm['-ch'])
    chskd.response_timeout =0.5    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    mbch['chskd'] = chskd
    print('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',10)
    return chskd
   except Exception as ee:
    print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))


 #gggdt=DateTime(year: 23, month: 3, day: 9, hour: 5, minute: 45, second: 31)

def gggettime(ac):
    try:

     dt=chskd.get_dt(ac)
     g=gfunc.al_209dt(ac,dt)
     #mp('cyan', 'gggettime g='+str(g))
    except  Exception as ee:
      mp('yellow','gggettime ee='+str(ee))

def runlsgspec():
    l=len(lsgspec)
    if l==0: return
    mp('red','runlsgspec ???????//???????????????????/?////////////////')
    gggettime(addrs[0])
    lsgspec.pop(0)


def tofankey(ev):
    mp('magenta','tofankey min='+str(mgb['minkey'])+', code='+str(ev.code)+' ,max='+str(mgb['maxkey']))
    #rmp('magenta','tofankey='+str(ev),1)

def checkfantom(ev):
    min = int(mgb['minkey'])
    max = mgb['maxkey']

    return True # EXIT DEBUG

    if ev.code==0   :return False
    if ev.code < min: return False
    if ev.code > max: return False
    else:
     s='select code from tss_keys where code='+str(ev.code)
     loc=readrow(s)
     for row in loc:
      return True
     return False

def convertwiegand(k):
 return k ^ 0x3FFFFFF

def formirformat(ev):
 #addr: 77, no: 61323, is_last: True, is_complex: True, dt: DateTime(
 #year: 23, month: 3, day: 13, hour: 8, minute: 44, second: 42), port: 2, is_open: True) / t = 0
 #8: 44:41, 749
 #mp('gray', '000000000000000000000000000000000000000000000ev=' + str(ev))
 try:

    g={}
    g['sens'] = 'UNDEF'
    cl='red'
    gx=gfunc.al_209dt(ev.addr,ev.dt)
    g['dt']=gx['dt']
    pt='.'

    uxtc = stofunc.datetimetosec(g['dt'], 'sql')
    uxtp = stofunc.nowtosec('loc')
    g['delta'] = str(uxtp - uxtc)
    g['no']=str(ev.no)
    g['ac'] = str(ev.addr)
    g['port'] = str(ev.port)
    try:
        ac=int(g['ac'])
        bidcomp  = str(mgb['bidcomp'])
        bidch    = str(mgb['bidch'])
        bidac    = str(mbac[ac]['bidac'])
        g['evid']= bidcomp+pt+bidch+pt+bidac+pt+g['no']
        g['evpid'] = bidcomp + pt + bidch + pt + bidac + pt + g['port']
        #mp('lime','EVPID='+g['evpid'])
    except Exception as ee:
     mprs('formirformat 1',ee)
 except Exception as ee:
   mpr('formirformat 2',ee)
 try:
  if isinstance(ev, acs.EventKey):
      g['kluch'] = gfunc.xkeytos(ev.code)
      ik=convertwiegand(ev.code)
      g['Ikluch']=str(gfunc.xkeytos(ik))
      g['code'] = str((ev.code))
 except  Exception as ee:
     mprs('formirformat.kluch',ee)

 if ev.is_complex and isinstance(ev, acs.EventKey):

     g['kpx']='kpx'
     g['sens'] = 'key'
     g['kluch'] = gfunc.xkeytos(ev.code)
     g['ik']    = convertwiegand(ev.code)
     if not checkfantom(ev):
        tofankey(ev)
        return
 else:
  g['kpx'] = 'avt'
 if isinstance(ev, acs.EventKey):

    if not checkfantom(ev):
        tofankey(ev)
        return

    cl='lime'
    g['sens'] = 'key'
 if isinstance(ev,acs.EventButton) and ev.is_complex:
      cl='cyan'
      g['sens'] = 'rte'
      g['kpx']='kpx'
 if isinstance(ev, acs.EventButton) and ev.is_complex==False:
     cl = 'cyan'
     g['sens'] = 'rte'
     g['kpx'] = 'avt'

 if isinstance(ev, acs.EventDoor) and ev.is_complex:
     # return
     # print('EventDoor KPX')
     # return # sudadoor
      cl='yellow'
      g['kpx'] = 'kpx'
      if ev.is_open:
       g['sens']='open'
      else :g['sens']='close'
 if isinstance(ev, acs.EventDoor) and ev.is_complex==False:
     # print ('EventDoor avt')
      #return  # sudadoor
      cl='yellow'
      g['kpx'] = 'avt'
      if ev.is_open:
       g['sens']='open'
      else :g['sens']='close'
 if not 'code' in g.keys():
  g['code']=-1
 kluch=gfunc.xkeytos(int(g['code']))
 s = 'kpx=%3s,ev=%4s ,ac=%3s,no=%6s ,p=%2s, dt=%8s,delta=%3s,code=%6s,KLUCH=%12s' \
        % (g['kpx'], g['sens'], g['ac'],g['no'],g['port'],g['dt'] ,g['delta'],g['code'],kluch)
 if g['sens']=='key':
  mp(cl,'KKKKKKKKKKKkkkkkkkkkkkkkkkkkkk='+s)
 else:
  mp(cl,s)
 g['rsendstate'] = '0'
 g['cmd']='todms'
 g['subcmd'] = 'todms'
 mgb['specdelay1']=5
 g['rpcchname']=mgb['rpcchname']
 g['uxt1'] =stofunc.nowtosec('loc')
 g['almm1'] =gfunc.almymarker()
 #mp('white','sens='+g['sens'])
# if g['kpx']=='kpx':
 #g['target'] = 'dms'
 ac=int(g['ac'])
 g['bidac']=str(mbac[ac]['bidac'])
# mp('lime','11111111111111111111111111111111111111111111111111111111111111111111111')
 if g['kpx']=='kpx':
  #mp('lime', 'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk')
  formirroad(g,'dms','rpc')
 else:
   #  mp('lime', '2222222222222222222222222222222222222222222222222222222222222222222222222')
     g['target'] = 'writerlog'
     g['cmd'] = 'tosyslog'
     g['subcmd'] = 'tosyslog'
     g['rcp'] = 0
     formirroad(g, 'writerlog', 'rpc')


def formirroad(g,road,metod):
    gx={}
    gx['road'] = road
    gx['metod'] = metod
    gx['gbody'] = g
    slgroad.append(gx)

def fping_wav():
  appdir=gfunc.getmydir()
  pt=appdir+'wav'+sep+'ping1.wav'
  s='aplay '+pt+' &'
  mp('cyan',s)
  os.system(s)


def  tobasec10(ac):
  try:
    zp=','
    code=10
    erm='acexclude'
    cerr='0'
    s='insert into tss_acerr(bpcomp,bpch,code,ac,erm)values( '+ \
    str(mgb["bidcomp"]) + zp + \
    str(mgb["bidch"])+zp+\
    str(code)+zp+\
    str(ac)+zp+\
    ap + erm + ap + \
    ')'
    rmp('magenta', 'tobase_acerr=' + s,2)
    curs2 = pgconn.cursor()
    curs2.execute(s)
    pgconn.commit()
    curs2.close()
  except Exception as ee:
   mpr('tobase_acerr',ee)



def  tobase_acerr(ac,erm,cerr): # from drv209
  try:
    redlog('tobase_acerr ac='+str(ac)+' /erm='+erm)
    zp=','
    k = str(ac) + '.cerr'
    code=1
    s='insert into tss_acerr(bpcomp,bpch,code,ac,counterr,erm)values( '+ \
    str(mgb["bidcomp"]) + zp + \
    str(mgb["bidch"])+zp+\
    str(code)+zp+\
    str(ac)+zp+\
    str(cerr)+zp+\
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



def tobase(ac,pr,topic,cerr):
   try:
    tobase_acerr(ac,topic,cerr)
    #rmp('white','tobase ac='+str(ac)+' /topic='+topic+' /cerr='+str(cerr),10)
    mbac[ac]['bidcomp'] = str(mgb['bidcomp'])
    mbac[ac]['bidch'] = str(mgb['bidch'])
   # mbac[ac]['cmd'] = 'mbacerr'
    #mbac[ac]['subcmd'] = 'mbacerr'
    mbac[ac]['errtopic'] = topic


    if 'chskd' in mbch.keys():mbch.pop('chskd')
    formirmbac_state(ac,'err')

   except Exception as ee:
    mpr('tobase',ee)
    mp('red','tobase ac='+str(ac)+zp+' pr='+pr+zp+'topic='+topic+zp+' cerr='+str(cerr))

def fftatal(ee):
    ee=str(ee)
    rmp('red','I KILL SELF ee='+ee,10)
    gevent.sleep(1)
    sys.exit(99)

def checkbroken(ex):
    p='broken pipe'
    ex=str(ex)
    ex=ex.lower()
    try:
     n=ex.index(p)
     rmp('yellow','checkbroken n='+str(n),10)
     if n>0 :ffatal(ex)
     return n
    except Exception as ee:
      #mp('white','NO checkbroken'+ex)
      return -1

def checkbadadddr(addr):
    for x in mgb['lsex']:
     if x==addr:return True
    return False

def flsexadd(ls,ac):
   try:
    n=ls.index(ac)
    return False,ls
   except Exception as ee:
    ls.append(ac)
    return True,ls

def get_event(addr, kpx):
   try:
    gevent.sleep(0.01)
    if not checkbadadddr(addr):
      if len(addrs) == 0: return
      if 'semonekey'in mgb.keys() and mgb['semonekey']==True:return
      #runlsgspec()
      ac=addr
      #mp('cyan','get_event ac='+str(ac))
      #if  not addr in mbac.keys():
      #mp('red','нету'+str(addr))
       #return
      ev=None
      #gevent.sleep(mbch['chsleep'])  # sudachsleep
      if   mbac[addr]['wkpx'] ==0:
          razborboxfunc(lslongfunc)
          try:
           ev=None
           ev=chskd.get_event(addr, kpx)
           mbch['countgev']=mbch['countgev']+1
           mbac[ac]['cerr']=0
           mbac[addr]['counteverr']=0
          # mbac[ac]['toterr']=0
           mbac[addr]['countevsuc']=mbac[addr]['countevsuc']+1
           #cerrac = str(mbac[addr]['cerr'])
          except Exception as ee:
            s='get_event cerr='+str(mbac[ac]['cerr'])+\
            ' ,toterr='+str( mbac[ac]['toterr'])+\
            ',COUNTCeverr='+str(str(mbac[ac]['counteverr'])) +\
            ' ,ee='+str(ee)
            mp('cyan',s)  #suda14
            t=int(mbac[ac]['toterr'])
            l=int(mbac[ac]['limitcrasherr'])
            if t>l:
             s='CRASH  CRASH  AC= '+str(ac)+',t='+str(t)+',Ceverr='+\
             str(mbac[addr]['counteverr'])
             if len(addrs)>0:
              mbac[ac]['toterr']=0
              rc, mgb['lsex']=flsexadd(mgb['lsex'],ac)
              if rc: tobasec10(ac)


            #x=checkbroken(ee)

            l=str(mbac[ac]['limitinfoerr'] )
            #mprs('get_event 1 cerr='+str( mbch['councerr'])+zp+' limit='+l+' ee=',ee)
            #mbch['countgev'] = mbch['countgev'] + 1
            mbac[ac]['toterr']=mbac[ac]['toterr']+1
            mbch['councerr']=mbch['councerr']+1
            erm=str(ee)
            #mp('lime','get_event ee='+erm)
            mbac[ac]['cerr'] = mbac[ac]['cerr']+1
           # mp('lime','ac='+str(ac)+'cerr='+str(mbac[ac]['cerr'])+' /limit='+str(mbac[ac]['limitinfoerr']))
            if mbac[ac]['cerr']>=mbac[ac]['limitinfoerr']:
              mp('white','ac='+str(ac)+zp+'cerr='+str(mbac[ac]['cerr']))
              formirspecoper(ac)
            mbac[addr]['counteverr']=mbac[ac]['counteverr']+1
            if not erm in mbac[ac]:
             mbac[addr][erm] = 0
            else:
             mbac[addr][erm]=mbac[addr][erm]+1
             if  mbac[addr][erm]>mbac[ac]['limitinfoerr']:
              rmp('gray','LIMITINFOERR@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',1)
              tobase(ac,'limitinfoerr',erm,mbac[addr][erm]) #SUDAERR
              mbac[addr][erm]=0
            erm='ac='+str(addr)+',e='+erm
            #mprs('magenta',' get_event ee='+erm)
            pass
            return
      # ttttttttttttttttttttttttttttttttttttttttt
      if ev != None:
       #mp('red','ev='+str(ev))
       #print ('ev====',ev) #suda0701
       formirformat(ev)
   except Exception as ee:
      mpr('get_event main???', ee)
      g = {}
      g['cmd'] = 'error_ac'
      g['adrc'] = str(addr)
      g['event'] = str(ee)


##        g['maca']=mgb['maca']

def razborboxfunc(lsin):
  try:
     semafor1=1
     l = len(lsin)
     if l==0:return
     x=lsin.pop(0)
     ac=int(x['ac'])
     mbac[ac]['semafor1']=1
     lsk=chskd.read_all_keys(ac)
     mbac[ac]['semafor1'] = 0
     l=len(lsk)
     rmp('magenta','ac='+str(ac)+' /ll='+str(l),10)
  except Exception as ee:
   mpr('razborboxfunc',ee)

def poll_event():
   #gevent.sleep(0.001)
   if 'semonekey' in mgb.keys() and mgb['semonekey'] == True: return

   if mbch['regim_opros'] == 'avt':
      kpx = False
      print('kpx=', kpx)
   if mbch['regim_opros'] == 'kpx': kpx = True

   if mgb['countstart'] == 0:
      mgb['countstart'] = mgb['countstart'] + 1
      # tobasestart() suda
   while True:
      # if m7func.mgb['busy']:return
      evt = None
      pass
     # mp('cyan', 'poll_event  opros=')
      #gevent.sleep(mbch['chsleep'])      #sudachsleep
      for addr in addrs:
         gevent.sleep(mbch['chsleep']) #sudachsleep
         ac=addr
         #mp('yellow', 'poll_event  ac=' + str(ac)+' /opros='+str(mbch['regim_opros']+'>'))
         # print ('get_event ac='+str(ac))
         # if glsacrg[addr]=='w': return None
         ##           if acstop[addr]=='poll':
         ##             if glsacrg[addr]=='a':
         try:
            ##               print('poll_event addr='+str(addr))
            # mp('yellow','addr='+str(addr)+' call getevent AVTONOM')
            #mp('white', 'poll_event =' + str(mbch['cnt1']))
            mbch['cnt1'] = mbch['cnt1'] + 1
            #mp('yellow', 'poll_event call get   ac=' + str(addr))

            r = False
            if mbch['regim_opros'] == 'avt':
               kpx = False
               r = False
            if mbch['regim_opros'] == 'kpx':
               #mp('white', 'poll_event call get   ac=' + str(addr))
               evt = get_event(addr, True)
            if mbch['regim_opros'] == 'avr':
               evt = get_event(addr, False)

         except Exception as ee:
          mpr('poll_event',ee)

def getpyvers():
    v=sys.version
    mp('red','PYTON version='+str(v))
    ls=v.split(' ')
    for x in ls:
      pass
     # mp('red', 'getpyvers x=' + x)
    # mp('red','getpyvers='+str(v))
    l=ls[0]
    if l>'3.0' :mgb['pylevel']=3
    else:
        mgb['pylevel']=2
    return v

def freadallkeys():
      for ac in addrs:
       try:
        ls=chskd.read_all_keys(ac)
        for t in ls:
         pass
         # mp('red','freadallkeys ac='+str(ac)+' code='+str(t.code)+' mask='+str(t.mask))
       except Exception as ee:
        mpr('freadallkeys',ee)

def getminmaxkeys():
 try:
 # mp('red', 'getminmaxkeys 00000000000000000000000000000000000000')
  s='select max(code) ,min(code) from tss_keys'
  loc=readrow(s)
  for row in loc:
   #mp('red','getminmaxkeys  ?????????????????????????????????????????')
   mgb['maxkey']=int(row[0])
   mgb['minkey']=int(row[1])
  # mp('red','minkey='+str(mgb['minkey']))
  # mp('red','maxkey=' + str(mgb['maxkey']))

 except Exception as ee:
  mpr('getminmaxkeys',ee)


def formirspecoper(ac):
    try:
     ac=int(ac)
     #fping_wav()
     mp('cyan','formirspecoper FLLLLLLLLLLLLLLLLLLLLLL')
     #chskd.flush_input()
     chskd.get_dt(ac)
     #g={}
     #g['cmd']='rdinfoac'
     #lsgspec.append(g)
    except Exception as ee:
     mp('yellow','formirspecoper ee='+str(ee))

    # if checkbroken(ee):
    # if checkbroken(ee):
    #    fftatal(ee)

def timerspecoper(interval):
    while True:
     gevent.sleep(interval)
     formirspecoper()

def razborcmd(g):
 try:
  ac=int(g['ac'])
  #mp('red','razborcmd='+str(g)[0:120])

  if g['cmd']=='ac_getpassport':
   rmp('y','g='+str(g),20)
  if g['cmd'] == 'acoffline':
    mbac[ac]['sem1']=1
    rmp('cyan',str(g),5)
  if g['cmd'] == 'aconline':
    mbac[ac]['sem1']=0
    rmp('lime', str(g), 5)
  if g['cmd']=='writekeys':
   rmp('yellow','g='+str(g),5)
 except Exception as ee:
  mpr('razborcmd',ee)

def formirmbchacinfo():
 try:
    #
    g = mbch
    g['pid']=str(os.getpid())
    if chskd==None:
      g['speed']='0'
      g['fatal']='e'

    g['bidcomp'] = mgb['bidcomp']
    g['bidch'] = mgb['bidch']
    if 'chskd' in g.keys(): g.pop('chskd')
    g['cmd'] = 'mbchinfo'
    g['subcmd'] = 'mbchinfo'
    g['rsendstate'] = '0'
    ss=str(mgb['lsex'])
   # ss=ss.replace('[','!')
   # ss = ss.replace(']', '!')
    g['lsacexclude']=ss

   # rmp('yellow','lsacexclude='+str(lsacexclude),2)
    formirroad(g,'comcentr','js')
    #mp('magenta','formirmbchacinfo='+str(g))
    #gevent.sleep(0.01)
    mbch['countgev'] = 0
    if chskd!= None:
        for ac in addrs:
            mbac[ac]['bidcomp'] =str( mgb['bidcomp'])
            mbac[ac]['bidch'] = str(mgb['bidch'])
            mbac[ac]['cmd']='mbacinfo'
            mbac[ac]['subcmd'] = 'mbacinfo'
            mbac[ac]['rsendstate'] = '0'
            g=mbac[ac]
            g['cmd']    ='mbacinfo'
            g['subcmd'] ='mbacinfo'
            g['rsendstate'] = '0'
            #mp('magenta','g='+str(g))
            formirroad(g, 'comcentr', 'js')
            #gevent.sleep(0.01)
            #for k in mbac[ac]:
            # mbac[ac][k]=str(mbac[ac][k])
            #mp('cyan','???????? gx='+str(mbac[ac]))
 except Exception as ee:
   mpr('formirmbchacinfo',ee)


def calcspeed(interval):
   try:
    sp=int(mbch['countgev'] / interval)
    exc=str(mgb['lsex'])
    s = 'speed=%3s,interval=%3s,EXclude=%5s' \
        % (str(sp), str(interval),exc)
    mp('lime',s)
    mbch['speed']=str(sp)
    formirmbchacinfo()
   except Exception as ee:
    mpr('calcspeed',ee)


def getcmdinside():
   try:
    return
    pt=gfunc.getmydir()
    ptf=pt+'cmdinside'+sep+gprm['-ch']+'.txt'
    mp('lime','getcmdinside='+ptf)
    inp=open(ptf,'r')
    ls=inp.readlines()
    mp('cyan','getcmdinside='+str(ls)+' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2')
    inp.close()
   except Exception as ee:
    mpr('getcmdinside',ee)

def timer10s(interval):
    while True:
      gevent.sleep(interval)
      try:
       #  mp('cyan','timer10s ?????????????????????????????????')
         g={}
         g['rsendstate'] = '0'
         g['cmd'] = 'chlife'
         g['subcmd'] = 'chlife'
         g['rpcchname'] = mgb['rpcchname']
         g['uxt'] = stofunc.nowtosec('loc')
         g['target'] = 'sgrd'
         g['pid']=str(os.getpid())
         g['startline'] =startline
         formirroad(g,'sgrd','rpc')
      except Exception as ee:
       mpr('timer10s',ee)
      try:
         #rmp('lime','CALL CALCSPEED',1)
         calcspeed(interval)
         formirmbchacinfo()
      except Exception as ee:
       mpr('timer10s',ee)


def initmbch():
    pass
    g={}
    g['chskd'] = None
    g['ch']=''
    g['fatal']='?'
    g['regim_opros']='kpx'
    #g['bidcomp']  = -1
    #g['bidch']    =-1
    g['countgev']  =0
    g['councerr'] =0
    g['cnt1'] = 0
    g['chsleep'] = float(gprm['-chsleep'])
    return g

def formirmbac_state(ac,flag):
    g={}
    g['cmd']='mbac_state'
    g['flag'] =flag
    g['subcmdcmd'] ='mbac_state'
    g['subcmd'] = 'mbacerr'
    g['ac']=str(ac)
    g['bidac']     =str(mbac[ac]['bidac'])
    rmp('lime','formirmbac_state ac='+str(ac)+' bidac='+str(g['bidac']),1)
    g['limitinfoerr']   =str(mbac[ac]['limitinfoerr'])
    g['limitcrasherr'] = str(mbac[ac]['limitcrasherr'])
    g['toterr']         =str(mbac[ac]['toterr'])
    g['cerr']=str(mbac[ac]['cerr'])
    g['wkpx'] = mbac[ac]['wkpx']
    g['sem1'] = mbac[ac]['sem1']
    g['uxt']=str(stofunc.nowtosec('loc'))
    #totop(g)
    formirroad(g, 'comcentr', 'js')





def initmbac(lsa):
    pass
    pass
    msg='init'
    g={}
    g[1]={}
    for ac in lsa:
     msg='init'
     kk='ac.'+str(ac)
     g[ac]={}
     g[kk]=ac
     g[ac][msg]=0            # кол-во ошибок типа msg
     g[ac]['cerr'] = 0       # текущее кол-во ошибок
     g[ac]['limitcerr1'] =10 # 1-й предел   кол-ва ошибок
     g[ac]['countevsuc'] = 0  # кол-во успешных get_event
     g[ac]['counteverr'] = 0  # кол-во ошибок get_event
     g[ac]['wkpx']=0
     g[ac]['sem1'] = 0     # усли 0   опрос пазрешен
    return g


def readacl():
  try:
    ls=[]
    lsg=[]
    s='select myid,ac,actual,limitinfoerr,limitcrasherr from tss_acl where bp='+str(mgb['bidch']) +' and actual=True'
    mp('lime','readacl='+s);
    pgc = pgconn
    curs2 = pgc.cursor()
    curs2.execute(s)
    loc = curs2.fetchall()
    for row in loc:
        g={}
        myid = row[0]
        ac = row[1]
        g[ac]={}
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
        print(' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@222')
        ls.append(ac)
        lsg.append(g)

    return ls,lsg
    pass
    pass
    pass

  except Exception as ee:
      row = None
      mpr('readacl', ee)
      return None

def readrow(s):
   try:
    pgc = pgconn
    curs = pgc.cursor()
    curs.execute(s)
    loc = curs.fetchall()
    return loc
   except Exception as ee:
     mpr('readrow',ee)



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
       # mp('red', 'readchparams s=' + s)
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
    host    = mysysinfo['base']['ip'],
    database='postgres',        #gprm['-dbname'],
    user="postgres",
    port=5432,
    password=mysysinfo['base']['psw'], )
  mp('lime','host='+mysysinfo['base']['ip'])
  mp('lime','conn='+str(conn))
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')

def spectest2(lsa):
    #addrs = lsa
    n1=1
    n2=100
    ls=[]
    ac=7
    t1=gfunc.mymarker()
    for x in range(n1,n2+1,1):
      t=formirtk(7,x,[1,2,3,4],1)
      for i in range(1,6,1):
        try:
         chskd.add_key(ac,t)
         mp('cyan',str(t))
         gevent.sleep(0.001)
         break
        except Exception as ee:
         mprs('spectest2 x='+str(x),ee)
         gevent.sleep(0.001)

      t2 = gfunc.mymarker()
      d=gfunc.mymarkerdelta(t1,t2)
      mp('red','d='+str(d))
    try:
     pass
     #t1=gfunc.mymarker()
     #chskd.write_all_keys(ac,ls)
     #t2 = gfunc.mymarker()
     #d=gfunc.mymarkerdelta(t1,t2)
     #mp('red','d='+str(d))
    except Exception as ee:
     mpr('spectest2',ee)

def al_getacinfo(ac):
   for i in range(1,5,1):
    try:
        mp('red','al_getacinfo='+str(ac))
        g = {}
        g['prog_ver']=chskd.prog_ver(ac)
        g['prog_id'] =chskd.prog_id(ac)
        g['sernum'] =chskd.ser_num(ac)
        g['keys_info'] =chskd.keys_info(ac)
        g['events_info'] = chskd.events_info(ac)
        mp('magenta', 'al_getacinfo=' + str(g))
        return g
    except Exception as ee:
      mprs('al_getacinfo',ee)

def totop(g):
    g['bidcomp'] = str(mgb['bidcomp'])
    g['bidch']   = str(mgb['bidch'])
    sj = json.dumps(g)

    mp('blue','TOTOP SJ='+sj)
    tolsoutjs.append(sj)  #suda12err

def z_formiracinfoonlyac(ac,idcmd):
    rmp('cyan','z_formiracinfoonlyac ac='+str(ac),3)
    g=al_getacinfo(ac)
    rmp('lime','g='+str(g),1)
    g['cmd']='answ_acgetpassport'
    g['ac'] =str(ac)
    g['idcmd']=idcmd
    totop(g)


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
        chskd.set_dt(ac,tssdt)
        mp('lime','al_setdt_ac='+str(ac)+'tssdt= '+str(tssdt))
    except Exception as ee:
        mpr('al_setdt_ac', ee)
        pass

def addmykey():
    key = acs.Key()
    key.code = 7804586
    key.mask = [1, 2, 3, 4, 5, 6, 7, 8]
    key.pers_cat = 16
    return key


def test_ffkls(n1,n2):
   ls=[]
   mp('yellow','fformirkeys n1='+str(n1)+' /n2='+str(n2))
   for i in range(n1,n2+1,1):
    key = acs.Key()
    key.code = i + 1
    key.mask = [1,2,3,4,5,6,7,8]
    key.pers_cat = 16
    ls.append(key)
   k=addmykey()
   ls.append(k)


   return ls

def wdelone(ac,code):
   for i in range(1,3,1):
    try:
     chskd.del_key(ac,code)
     break
    except Exception as ee:
     mprs('WDELONE',ee)

def waddone(ac,t):
   for i in range(1,21,1):
    try:
     gevent.sleep(0.1)
     wdelone(ac,t.code)
     chskd.add_key(ac, t)
     gevent.sleep(0.1)
     mp('yellow', 'WADDONE ac=' + str(ac) + ', t=' + str(t))
     return True
    except Exception as ee:
     mprs('Waddone',ee)
     gevent.sleep(0.3)
   return False


def test_addmass(ac,ls):
    lls=len(ls)
    m1=stofunc.nowtosec('loc')
    ii=0
    cerr=0
    lmt1=10
    while  len(ls)>0:
     t=ls.pop(0)
     gx={}
     gx['ac']=ac
     gx['t']=t
     glsonekey.append(gx)
     gevent.sleep(0.001)
     #if rc==True:
     #   ii=ii+1
     #   ls.pop(0)
     #   if ii>=lmt1:
     #    mp('cyan','test_addmass lmt1='+str(lmt1))
     #    ii=0
    #m2 = stofunc.nowtosec('loc')
    #d=m2-m1
    #mp('lime','test_addmass d='+str(d))
    #mp('t', 'test_addmass d=' + str(d))


def test_writeallkeys(g):
    try:
     rmp('red','test_writeallkeys',3)
     n1=int(g['n1'])
     n2=int(g['n2'])
     ls=test_ffkls(n1,n2)
     ac=int(g['ac'])
     mp('yellow', 'call chskd.test_addmass(ac)=' + str(ac))
     test_addmass(ac,ls)
     mp('t', 'end of test_addmass')
    except Exception as ee:
     mpr('t','test_writeallkeys,ee='+str(ee))


def test_readallkeys(g):
     ac=int(g['ac'])
     mp('lime','call chskd.read_all_keys(ac)='+str(ac))
     for i in range (1,6,1):
      try:
       m1=stofunc.nowtosec('loc')
       ls=chskd.read_all_keys(ac)
       m2=stofunc.nowtosec('loc')
       l=len(ls)
       d=m2-m1
       rmp('lime','READALLKEYS l='+str(l)+' DELTA='+str(d),3)
       return
       for t in ls:
        mp('cyan','t='+str(t))
       break
      except Exception as ee:
       mprs('test_readallkeys',ee)
       #mp('', 'end of chskd.test_readallkeys')
       gevent.sleep(1)


def test_delallkeys(g):
    try:
     ac=int(g['ac'])
     mp('lime','call chskd.del_all_keys(ac)='+str(ac))
     for i in range(1,5,1):
      try:
       chskd.del_all_keys(ac)
       break
      except Exception as ee:
       mprs('test_delallkeys',ee)
       gevent.sleep(1)
     mp('t', 'end of chskd.del_all_keys')
     chskd=crip()
    except Exception as ee:
     mprs('test_delallkeys,ee='+str(ee))

def razboroncl(g) :
   try:
    if g['subcmd'] == 'ac_test_delallkeys':
        rmp('cyan', str(g['subcmd']), 3)
        test_delallkeys(g)
    if g['subcmd'] == 'ac_test_readallkeys':
        rmp('cyan', str(g['subcmd']), 3)
        test_readallkeys(g)
    if g['subcmd'] == 'ac_test_writewallkeys':
        rmp('cyan', str(g['subcmd']), 3)
        test_writeallkeys(g)


    if 'subcmd' in g.keys() and g['subcmd'] == 'sgrdlife':
     pass
     #rmp('lime','oncl ='+str(g),2)
    if 'subcmd' in g.keys() and g['subcmd'] == 'ac_wkpx_kpx':
        # mp('lime','ac='+str(ac))
        rmp('cyan', str(g['subcmd']), 3)
    if 'subcmd' in g.keys() and g['subcmd'] == 'ac_wkpx_avt':
        rmp('yellow', str(g['subcmd']), 3)
   except Exception as ee:
    mpr('razboroncl',ee)

def razborjscmd(g) :
 try:
   return
   mp('red','razborjscmd='+str(g)[0:100])
   if 'ac' in g.keys():
     ac = int(g['ac'])
    #if 'komu' in g.keys() and g['komu']!=mgb['zclid']  :return
   if 'subcmd' in g.keys() and g['subcmd'] == 'dmsrelay':
      rmp('cyan','razborjscmd g='+str(g),2)
      gz={}
      tmr=int(g['tmr'])
      gz['ac']=int(g['ac'])
      gz['port'] = int(g['port'])
      gz['tmr']= int(tmr) * 2
      lsgrelay.append(gz)

   if 'subcmd' in g.keys() and g['subcmd'] == 'ac_wkpx_kpx':
       # mp('lime','ac='+str(ac))
        rmp('cyan', str(g['subcmd']), 3)
        mbac[ac]['wkpx']= 0
        mgb['lsex']=clearex(mgb['lsex'])


   if 'subcmd' in g.keys() and g['subcmd'] == 'ac_wkpx_avt':
        rmp('yellow', str(g['subcmd']), 3)
        mbac[ac]['wkpx'] = 1

   if 'subcmd' in g.keys() and g['subcmd'] == 'ac_readallkeys':
        rmp('white', str(g), 3)
        freadallkeys(g['ac'])
   if 'subcmd' in g.keys() and g['subcmd'] == 'ac_deleteallkeys':
        fdeleteallkeys(g['ac'])
   if 'subcmd' in g.keys() and g['subcmd'] == 'ac_getpassport':
     # rmp('white',str(g),5)
      ac=int(g['ac'])
      z_formiracinfoonlyac(ac,g['idcmd'])
   if 'subcmd' in g.keys() and  g['subcmd']=='set_ch_opros':
      kpx=g['line']
      mbch['regim_opros']=g['line']
      formir_chstate()
      rmp('yellow','REGIM='+mbch['regim_opros']+'>',3)

 except Exception as ee:
    mpr('razborjscmd',ee)




def timerlstorpc(interval):
   while True:
     gevent.sleep(interval)
     l=len(glsrpc)
     if l>0:
         gx={}
         #print ('l=',l)
         g=glsrpc.pop(0)
         if type(g)!=type(gx):
          rmp('yellow','NOT GLS',3)
         f=False
         #if g['cmd']=='mbacinfo' or g['cmd']=='mbchinfo':return
         ss='UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU'
         if 'sens' in g.keys():
             if g['sens']=='key' :
               f=True
               ss='kkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'
             if g['sens']== 'rte' or g['sens']=='open' or g['sens']=='close':
              ss='RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR'
              #g['subcmd']='tosyslog'
              f = True
        # mp('cyan','sens='+ ss)
        # if not f:mp('red','NETONESE g='+str(g))

        #formirroad(g,'comcentr','js')
        #mp('yellow', 'TOCOMCENTR')

def timerlsoutjs(interval):
    while True:
        #return  #suda01
        gevent.sleep(interval)
        l=len(mqtransmod.sljsin)
        if l>0 :
         pass
         #mp('white', '31suda FIRST== l='+str(l))
        if l>0:
         js=mqtransmod.sljsin.pop(0)
         g = json.loads(js)
         razborjscmd(g)
         #mp('cyan','NEWrazbor='+str(g)[0:100])
         mp('white', '01suda 0=' + str(g)[0:100])
         if  'cmd' in g.keys():
             pass
             #if g['cmd']=='ac_reload':
             # rmp('cyan','NOT CMDrazbor='+g['cmd']+' /ac='+g['ac']+' bidch='+g['bidch'],3)

        l=len(tolsoutjs)
        try:
            if  len(tolsoutjs)>0:
              s=tolsoutjs.pop(0)
              mqttclient.publish('tss_mqtt',s)
              #mp('red', '31suda ='+s)
              #mp('yellow', 'timerlsoutjs='+s)
        except Exception as ee:
             mpr('timerlsoutjs',ee)


def razborzgls(g):
  try:
   if not ('cmd' in g.keys() and 'bidch' in g.keys() and
           int(g['bidch'])==int(mgb['bidch'])):return
   if 'ac' in g.keys() :
      ac=int(g['ac'])

   if 'cmd' in g.keys() and 'subcmd' in g.keys() and g['subcmd']=='ac_wkpx_avt':
     mbac[ac]['wkpx'] = 1
     rmp('yellow',str(g['subcmd']+'/ ac='+str(g['ac'])),2)
   if 'cmd' in g.keys() and 'subcmd' in g.keys() and g['subcmd']=='ac_wkpx_kpx':
       mbac[ac]['wkpx'] = 0
       rmp('cyan', str(g['subcmd'] + '/ ac=' + str(g['ac'])), 2)

  except Exception as ee:
    mpr('razborzgls',ee)


def onclftpsrv(sender,g):
    try:

    # mp('yellow','onclFIRST========'+str(g))
     if 'sens' in g.keys() and g['sens']=='key':
      pass
      #mp('yellow','oncl==============================='+str(g))
     #mp('magenta','oncl 11111111111111111111111111111111111111'+str(g))
     if not 'cmd' in g.keys():
      rmp('red','oncl NOT CMD ---> RETURN',2)
      return

     if 'subcmd' in g.keys() and  g['subcmd']=='ac_test_delallkeys':
       mp('t','g='+str(g))

     if g['cmd']=='fromdms' and g['subcmd']=='relay':
      mp('blue','RELAY RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR')
      t1=float(g['almm1'])
      t2=float(gfunc.almymarker())
      d=t2-t1
      d=round(d,3)
      tmr=g['tmr']
      tmr=1
      #rmp('yellow','oncl?????????????????????????? '+str(g),5)
      try:
       chskd.relay_on(int(g['ac']), int(g['port']),tmr)  #sudarelay
      except Exception as ee:
        mprs('onclrel',ee)
      #mp('red','relay ac='+str(g['ac'])+',p='+str(g['port'])+', tmr='+str(tmr))
      #if g['sens']=='key':
      mp('white','FROMDMS delta='+str(d)+'   !!!!!')
     razboroncl(g)
     cmd=g['cmd']
     razborzgls(g)
     #mp('white','oncl='+str(g))
    except Exception as ee:
     mpr('onclftpsrv',ee)



def al_wratest(ac,n1,n2,ms,tz):
 try:
   ls=[]
   for code in range(n1,n2+1,1):
    t=al_formirtk(ac, code, ms, tz)
    ls.append(t)
   return ls

 except Exception as ee:
   mpr('al_wratest',ee)




def al_formirtk(ac,code,ms,tz):
   try:
        key = acs.Key()
        key.code = code
        key.mask = ms
        key.pers_cat = tz
        return key
   except Exception as ee:
    mprs('al_formirtk',ee)


def calltestvag(ac):

   try:

      mp('blue', 'ATTEMPT "WRITE_ALL_KEYS" ')
      ls=al_wratest(ac, 1, 10, [1,2,3,4,5,6,7,8], 16)
      for t in ls:
       mp('yellow','for wra ac='+str(ac)+','+'code='+str(t.code)+','+str(t.mask)+','+'tz='+str(t.pers_cat))
      chskd.write_all_keys(ac, ls)
      return
      mp('blue', 'ATTEMPT "READ_ALL_KEYS" ')

     # ls = chskd.read_all_keys(7)
     # for t in ls:
     #    print('t=', t)
   except Exception as ee:
        mpr('main allkeys', ee)
        sys.exit(99)


def alfindaddrs(a1,a2,als):
    t1 = stofunc.nowtosec('loc')
    ls=[]
    for i in range(a1,a2+1,1):
       ac=i
       mp('yellow', 'TEST AC=' + str(i))
       gevent.sleep(0.01)
       for n in range(1,3,1):
         gevent.sleep(0.01)
         try:
          dt=ch.get_dt(ac)
          gt = gfunc.al_209dt(ac, dt)
          mp('magenta','gt='+str(gt))
          ls.append(ac)
          gx={}
          gx['ac']=ac
          gx['dt']=dt
          als.append(gx)
          mp('lime', 'FIND AC=' + str(i))
          break
         except Exception as ee:
          gevent.sleep(0.02)

    t2=stofunc.nowtosec('loc')
    d=t2-t1
    mp('lime','TOTAL FIND='+str(ls)+' time='+str(d)+' sec.')
    return ls,als




def calcstartline():
    s1 = sys.argv[0]
    s = ''
    for x in gprm:
        v = str(gprm[x])
        s = s + x + ' ' + v + ' '
    startline = 'python3 ' + s1 + ' ' + s + ' &'
    mp('red', 'startline=' + startline)
    return startline

def toroad(g):
  try:
   gb=g['gbody']
   road=g['road']
   gx = g['gbody']
   #if 'subcmd' not in g.keys():
   # mp('blue','NOT SUBCMD='+str(g))
   #mp('blue','toroad road='+road+'>')
   try:
    clientftpsrv.send(gx, road)
   # mp('red','road='+str(road))
   except Exception as ee:
    mprs('toroad ROAD======================================================='+road,ee)
  except Exception as ee:
   mpr('toroad',ee)


def timertestrpc(interval):
    while True:
        gevent.sleep(interval)
        g={}
        g['cmd']='timertestrpc'
        g['subcmd'] = 'timertestrpc'
        formirroad(g,rpcxname,'rpc')



def timeronekey(interval):
  while True:
   gevent.sleep(interval)
  # mp('cyan','timeronekey ???????????????????????@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@f')
   try:
    if len(glsonekey)==0: mgb['semonekey'] = False
    if len(glsonekey) > 0:
     gx=glsonekey[0]
     ac=int(gx['ac'])
     t=gx['t']
     mgb['semonekey']=True
     rc=waddone(ac,t)
     mgb['semonekey'] =False
     if rc:
      gx = glsonekey.pop(0)
   except Exception as ee:
    mprs('timeronekey',ee)





def timerroad(interval):
  while True:
   gevent.sleep(interval)
   if len(slgroad)>0:
    g=slgroad.pop(0)
    toroad(g)

def clearex(ls):
    while len(ls)>0:
     ls.pop(0)
    return ls

def restoreaddrs():

   try:
   # rmp('yellow', 'restoreaddrs=============' + str(mgb['lsex']),1)
    mgb['lsex']=clearex(mgb['lsex'])
   # rmp('lime', 'restoreaddrs================' + str(mgb['lsex']),1)
    mgb['lsex']=clearex(mgb['lsex'])
   # mp('red','restoreaddrs mgb[lsex]='+str(mgb['lsex']))
   except Exception as ee:
     mpr('restoreaddrs',ee)

def timeraddrs(interval):
    while True:
     gevent.sleep(interval)
     rmp('cyan','timeraddrs='+str(mgb['lsex']),1)
     restoreaddrs()


def timertest(interval):
    while True:
     gevent.sleep(interval)
    # mp('magenta','timertest ???????????????????????')





# ========mgbs============================================================

ap=chr(0x27)
zp=','
slgroad=[]
mgb={}
mgb['lsex']=[]
mgb['lsempty']=[]
tasks=[]
mbch={}
#glsrpc=[]
tolsoutjs=[]
glstestcmd=[]
glscmdin=[]
glsonekey=[]
gprm=gsfunc.gonsgetp()
startline=calcstartline()
mp('red','startline='+startline)
mp('t','startline='+startline)

#gprm['-ch']='192.168.0.7'
#gprm['-chsleep']=0.01
#gprm['-find']='n'

rpcxname='drv209_'+gprm['-ch']
rpcxname='drv209_'+gprm['-ch']
mgb['rpcchname']=rpcxname
mp('red','1111 rpcxname='+rpcxname+'>')
chskd=None
for i in range(1,6,1):
 mp('red','crip ATTEMPT='+str(i))
 gevent.sleep(1)
 chskd=crip()
 #sys.exit(77)
 if chskd != None:
   rmp('red','CRIP OKEY  ',5)
   break
if chskd==None:
 rmp('red','CHHANEL NOT CREATE ???????????????????????????????????????????',10)
 sys.exit(99)




#                    calltestvag(77)
#                    gevent.sleep(2)
#                    sys.exit(99)


pt=gfunc.calcptstarter()
mp('cyan','pt='+pt)
mp('yellow','pt='+pt)
vb=gfunc.opendb3(pt,'r')
mysysinfo=gfunc.readstarter(vb)
mp('yellow','base='+str(mysysinfo['base']))
mp('yellow','comcentr='+str(mysysinfo['comcentr']))
mp('yellow','transport='+str(mysysinfo['transport']))




#h='tcp://127.0.0.1:5555'
#h='tcp://192.168.0.103:5555'
hc='tcp://'+mysysinfo['comcentr']['ip']+':'+mysysinfo['comcentr']['port']
mp('red','hc='+hc)


clientftpsrv=ccftpsrv(hc,rpcxname)
mp('red','??? rpcxname='+rpcxname)

ccftpsrv.on_receive = onclftpsrv
task= gevent.spawn(clientftpsrv.run)
tasks.append(task)


mbch=initmbch()

mbac={}
lsgrelay=[]
semafor1=0
lsgspec=[]

lslongfunc=[]
mgb['countstart'] = 0
v=getpyvers()



pgconn=fpgs_connect()
mp('red','start')

getminmaxkeys()

readchparam(gprm['-ch'])


#mqtransmod.mgbt=mgb
mp('lime','mgb='+str(mgb))


mp('magenta','START ALDRV209 ')
rmp('yellow','BEFORE  MQTT LOOP',5)
#mqttclient=mqtransmod.connecttobroker('aldrv209','192.168.0.103')
#mqttclient.loop_start()  # start the loop
#rmp('yellow','AFTER LOOP',5)

mp('yellow','mbch='+str(mbch))






if chskd != None:
   pass
   addrs, lsg = readacl()
   mp('red','lsg='+str(lsg))
   if len(lsg)==0:
     mpr('red','НЕТ КОНТРОЛЛЕРОВ ДЛЯ КАНАЛА ='+gprm['-ch'],10)
     sys.exit(99)
   if gprm['-find']=='y':
    mp('lime','and findaddrs now')
    als = []


    addrs,als=alfindaddrs(1,253,als)
    for g in als:
        ac = int(g['ac'])
        dt = g['dt']
        mdt = gfunc.al_209dt(ac, dt)
        mp('lime', 'mdt=' + str(mdt))
        acd = mdt['acdelta']
        dt = mdt['dt']
        mp('magenta', 'ac=' + str(ac) + ' ACDELTA=' + str(acd) + ',dt=' + str(dt))

   else:
    addrs,lsg=readacl()
    for g in lsg:
     ac=int(g['ac'])
     mp('lime', 'ac===' + str(g['ac']) + 'bidac=' + str(g[ac]['bidac']))
    # mp('yellow', 'ac='+str(ac)+' / bidac=' + str(lsg[ac]['bidac']))
    #sys.exit(211)
    #for g in lsg:
     ac=g['ac']
     mbac[ac]=g[ac]
     mbac[ac]['ac']=ac
     gp=al_getacinfo(ac)
     if gp!=None:
         mbac[ac]['prog_id']=str(gp['prog_id'])
         mbac[ac]['prog_ver'] =str(gp['prog_ver'])
         mbac[ac]['ser_num'] = str(gp['sernum'])
         mbac[ac]['keys_info'] =str(gp['keys_info'])
         mbac[ac]['events_info'] = str(gp['events_info'])


    mp ('cyan','APPEND POLL')
    for ac in addrs:
     al_setdt_ac(ac)
    # al_getacinfo(ac)
     pass


     # lsk = chskd.read_all_keys(ac)
     # ll = len(lsk)
     # mp('lime', 'len(ac='+str(ac)+' lsk=' + str(ll))
    # gevent.sleep(2)
   mp('cyan', 'APPEND POLL 2')
   # rmp('red','CALL POOLEVENT',5)
   rmp('lime', 'poll_event   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&', 5)
   tasks.append(gevent.spawn(poll_event))
else:
 mp('red','CHHANEL NOT CREATR--> EXIT') #sudachskd
# sys.exit(99)
#mp('red','Gbac='+str(mbac))


mp('magenta','level='+str(mgb['pylevel']))
#if mgb['pylevel']==2:freadallkeys()
pass
task = gevent.spawn(timer10s,10)
tasks.append(task)
pass
pass


#task = gevent.spawn(timerlstorpc,0.001)
#tasks.append(task)

task = gevent.spawn(timertest,10)
tasks.append(task)
task = gevent.spawn(timeraddrs,30)
tasks.append(task)


#task = gevent.spawn(timerspecoper,20)
#tasks.append(task)

task = gevent.spawn(timerroad,0.01)
tasks.append(task)


task = gevent.spawn(timeronekey,0.1) #for 3200 keys
tasks.append(task)

ask = gevent.spawn(timertestrpc,2)
tasks.append(task)





rmp('blue','joinall',5)
gevent.joinall(tasks)











pass

'''
for ac in addrs:
  pv = chskd.prog_ver(ac)
  print('pv=', pv)
  ls = chskd.read_all_keys(ac)
  ll=len(ls)
  print ('ac=',ac,'ll=',ll,stofunc.nowtosec('loc'))
  # for t in ls:
  #  print  ('ac=',ac,'t.code=',t.code,'t,mask=',t.mask,' ll=',ll)
'''

#python3 acs27.py -ch 192.168.0.96 -chtimeout 0.001 -find n &
#/home/astra/common/doors/alpy# python3 acs27.py -ch 192.168.0.96 -chtimeout 0.01 -find n


#mbac={7: {'bidac': 129, 'init': 0, 'cerr': 0, 'limitcerr1': 10, 'countevsuc': 0, 'counteverr': 0, 'wkpx': 0, 'sem1': 0}, 'ac': 7}  /t=10:05:24,821
#mbac={77: {'bidac': 130, 'init': 0, 'cerr': 0, 'limitcerr1': 10, 'countevsuc': 0, 'counteverr': 0, 'wkpx': 0, 'sem1': 0}, 'ac': 77}  /t=10:05:24,821

#Broken pipe
#7804586

'''
bs=1M
т май  5 02:37:02 MSK 2023
7968129024 байт (8,0 GB, 7,4 GiB) скопирован, 2073,05 s, 3,8 MB/s 
7600+0 записей получено
7600+0 записей отправлено
7969177600 байт (8,0 GB, 7,4 GiB) скопирован, 2074,07 s, 3,8 MB/s
Пт май  5 03:11:36 MSK 2023
root@AstraOrel:/home/astra/common/doors/rdd# 

bs=2M
Пт май  5 04:19:42 MSK 2023
7969177600 байт (8,0 GB, 7,4 GiB) скопирован, 1561,21 s, 5,1 MB/s 
3800+0 записей получено
3800+0 записей отправлено
7969177600 байт (8,0 GB, 7,4 GiB) скопирован, 1562,03 s, 5,1 MB/s
Пт май  5 04:45:44 MSK 2023
root@AstraOrel:/home/astra/common/doors/rdd# 


'''

