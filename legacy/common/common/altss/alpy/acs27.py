# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback
from os import path, sep


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
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
    redlog(txt)
    return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)



def magentalog(txt):
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



def redlog(txt):
    ch=gprm['-ch']
    cd=gfunc.mydatezz()
    ct=gfunc.mytime()
    cds=cd+' '+ct+' '
    appdir=gfunc.getmydir()
    fn=appdir+'redlog'+sep+ch+'.log'
    # print ('redlog fn=',fn)
    outp=open(fn,'a')
    outp.write(cds+txt+'\n')
    outp.flush()
    outp.close()

def crip():
   try:
    chskd = acs.ChannelTCP(gprm['-ch'])
    chskd.response_timeout =float(gprm['-chtimeout'])
    mbch['chskd'] = chskd
    rmp('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!', 3)
    return chskd
   except Exception as ee:
    mpr('crip',ee)

 #gggdt=DateTime(year: 23, month: 3, day: 9, hour: 5, minute: 45, second: 31)

def gggettime(ac):
    try:

     dt=chskd.get_dt(ac)
     g=gfunc.al_209dt(ac,dt)
     mp('cyan', 'gggettime g='+str(g))
    except  Exception as ee:
      mpr('gggettime',ee)

def runlsgspec():
    l=len(lsgspec)
    if l==0: return
    gggettime(7)
    lsgspec.pop(0)

def fping_wav():
  appdir=gfunc.getmydir()
  pt=appdir+'wav'+sep+'ping1.wav'
  s='aplay '+pt+' &'
  mp('cyan',s)
  os.system(s)




def get_event(addr, kpx):
   try:
      runlsgspec()
      ac=addr
      if  not addr in mbac.keys():
       mp('red','нету'+str(addr))
       return
      if  mbac[addr]['semafor1']==1:return
      # if gprm['-regim']=='virtual': return None
      razborboxfunc(lslongfunc)
      try:
       ev=None
       ev=chskd.get_event(addr, kpx)
       cerrac = str(mbac[addr]['cerr'])
      except Exception as ee:
        erm=str(ee)
        erm='ac='+str(addr)+',e='+erm
        mprs('get_event ee=',erm)
        return

        mbac[addr]['cerr'] = mbac[addr]['cerr'] + 1
        mbch['cerr'] = mbch['cerr']+1
        cerrac = str(mbac[addr]['cerr'])

        if not mbac[ac]['germ'].has_key(erm):
         mbac[ac]['germ'][erm]=0
        else:
         mbac[ac]['germ'][erm]=mbac[ac]['germ'][erm]+1
         if mbac[ac]['germ'][erm]>10 :
           # s='toacerr='+str(mbac[ac]['germ'])+'='+str(mbac[ac]['germ'][erm])
           t=str(mbac[ac]['germ'])
           print ('t=',t)
           ern = int(mbac[ac]['germ']['ern'])
           # ern=int(mbac[ac]['germ']['ern'])
           s='NEWMAG '+t+'/ERn='+str(ern)
           magentalog(t)
           mbac[ac]['germ'][erm]=0
      if ev != None:
       if isinstance(ev, acs.EventKey):
        # mp('blue', 'evkey=' + str(ev)[0:40])
         fping_wav()
       mp('white','ev='+str(ev)[0:110]+' /cerr='+str(mbch['cerr'])+',cerrac='+cerrac)
      return

      while len(lsgrelay) > 0:
         g = lsgrelay.pop(0)
         chskd.relay_on(g['ac'], g['port'], g['tmr'])
         mp('white', 'RELAY=' + str(g))

      ev = None
      ac = addr
      k = str(addr) + '.cerr'
      is_complex = True
      try:
         # print('getevent tut1 ')
         if gprm['-regim'] == 'real':
            ev = chskd.get_event(addr, kpx)
         else:
            ev = getvirtev(addr)
         mbacl[k] = 0
         if ev != None:
            print('get_event=' + str(ev))
            showevt(ev)
      except Exception as ee:
        return
        '''  
         k2 = fk2(addr)
         mbacl[k2] = mbacl[k2] + 1
         mprs('get_event   k2=' + str(mbacl[k2]) + ' / ac=' + str(addr), ee)
         mbacl[k] = mbacl[k] + 1
         if mbacl[k] >= limitacerr:
            rc = arestore(addr, str(ee))
         '''


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

   print ('poll_event')
   # kpx=True
   print('poll_event mbch[regim_opros] =' + mbch['regim_opros'])
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
      gevent.sleep(0.1)
      for addr in addrs:
         ac=addr
         # print ('get_event ac='+str(ac))
         # if glsacrg[addr]=='w': return None
         ##           if acstop[addr]=='poll':
         ##             if glsacrg[addr]=='a':
         try:
            ##               print('poll_event addr='+str(addr))
            # mp('yellow','addr='+str(addr)+' call getevent AVTONOM')
            mbch['cnt1'] = mbch['cnt1'] + 1
            # print('poll_event BEFORE mbch[regim_opros] =' + mbch['regim_opros'])
            r = False
            if mbch['regim_opros'] == 'avt':
               kpx = False
               r = False
            if mbch['regim_opros'] == 'kpx':
               evt = get_event(addr, True)
            if mbch['regim_opros'] == 'avr':
               evt = get_event(addr, False)
            # print('get_event='+str(evt))


         except Exception as ee:
            pass

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



def timerspecoper(interval):
    while True:
     gevent.sleep(interval)
     g={}
     g['cmd']='rdinfoac'
     lsgspec.append(g)


def timerdebug(interval):
    while True:
     gevent.sleep(interval)
     fn='drv209.cmd'
     if os.path.isfile(fn):
      inp=open(fn,'r')
      ls=inp.readlines()
      inp.close()
      gfunc.mydeletefile(fn)
      g=gfunc.lstogls(ls)
      mp('cyan','timerdebug g='+str(g))


def initmbac():
    mes='init'
    for ac in addrs:
     mbac[ac]={}
     mbac[mes]={}
     mbac[ac]['ac'] = ac
     mbac[ac]['semafor1']=0
     mbac[ac]['cerr'] = 0

     mbac[mes][ac] = 0  # для сбора ошибок на контроллере


# ========mgbs============================================================
mgb={}
mbch={}
mbac={}
semafor1=0
lsgspec=[]
mbch['cnt1']=0
mbch['cerr']=0

tasks=[]
lslongfunc=[]
mgb['countstart'] = 0
mbch['regim_opros']='kpx'
gprm=gsfunc.gonsgetp()
v=getpyvers()

chskd=crip()
if chskd != None:
   if gprm['-find']=='y':
    mp('lime','and findaddrs now')
    addrs=chskd.find_addrs()
    rmp('lime','addrs='+str(addrs),3)
   else:
    addrs=[7,77]
    mp('lime','addrs='+str(addrs))
    mp ('cyan','APPEND POLL')
    for ac in addrs:
      pass
     # lsk = chskd.read_all_keys(ac)
     # ll = len(lsk)
     # mp('lime', 'len(ac='+str(ac)+' lsk=' + str(ll))
    # gevent.sleep(2)
   mp('cyan', 'APPEND POLL 2')
   # rmp('red','CALL POOLEVENT',5)
   initmbac()
   tasks.append(gevent.spawn(poll_event))
else:
 mp('red','CHHANEL NOT CREATR--> EXIT')
 sys.exit(99)
mp('red','level='+str(mgb['pylevel']))
if mgb['pylevel']==2:freadallkeys()

task = gevent.spawn(timerdebug, 5)
tasks.append(task)

task = gevent.spawn(timerspecoper,10)
tasks.append(task)

rmp('blue','joinall',10)
gevent.joinall(tasks)













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



