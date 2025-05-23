#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import json
import paho.mqtt.client as mqtt

#


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
      if c == 'red':
        redlog(txt)
        return
      if c == 'magenta':
          #magentalog(txt)
          return
 except Exception as ee:
   print ('mp ee='+str(ee))



def redlog(txt):
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
    chskd.flush_input()
    print('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))


def convertwiegand(k):
 return k ^ 0x3FFFFFF


def formircev(ev):
    try:
        #print ('ev=',ev)
        g = {}
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
         cl='magenta'
         ik = convertwiegand(ev.code)
         g['Ikluch'] = str(gfunc.xkeytos(ik))
         g['code'] = str((ev.code))
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
         mbch['chskd'].relay_on(int(g['ac']),int(g['port']),3)
    except Exception as ee:
      mprs('formircev',ee)


def analyzee(ac,ee):
    ac=int(ac)
    es = str(ee)
    es=es.lower()
    bp='broken pipe'
    p='unexpected response'
    p2='no response in'
    #print ('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
    #mp('cyan', 'Notresp=' + str(mbacl[ac]['notresp'])+' ,  UNEXP='+str(mbacl[ac]['unexp']))
    try:
     x=-1
     x=es.index(p)
    except :pass
    if x>=0:
          if mbacl[ac]['unexp']>maxerv:
            mp('red', 'analyzee ac=' + str(ac) + es)
            mbacl[ac]['unexp']=0


    try:
     y=-1
     y=es.index(p2)
    except :pass
     #print ('y=',y)
    if y >= 0:
       #mp('lime', 'Notresp=' + str(ee) + str(mbacl[ac]['notresp']))
       mbacl[ac]['notresp'] = mbacl[ac]['notresp'] + 1
       if mbacl[ac]['notresp']>maxerv:
        mp('red', 'analyzee ac=' + str(ac) + es)
        mbacl[ac]['notresp']=0



    if mbacl[ac]['unexp']>maxerv or mbacl[ac]['unexp']>maxerv :
      try:
       pass
       cd=mbch['chskd'].get_dt(ac)
       #mp('blue','pg='+str(pg))
       #mbch['chskd'].flush_input()
       #fplay('ping1.wav')
       #rmp('yellow', 'AFTER RESPONSE', 500)
      except Exception as ee:
       mprs(' chskd.get_dt(ac)',ee)




def timerpoll(interval):
   while True:
      gevent.sleep(interval)
      print ('polling ?????????????????????????????????')
      if mbch['active'] :
          addrs=mbch['addrs']
          chskd = mbch['chskd']
          l=len(addrs)
          gr=l-1
          i=mbch['i']
          mp('white','i='+str(i))
          if i>gr:mbch['i']=0
          i=mbch['i']
          ac=addrs[i]
          mp('cyan','i='+str(i)+'/ac='+str(ac))
          mbch['i']=i+1
          if  mbacl[ac]['kpx']=='kpx'\
          and  mbacl[ac]['buzy'] == False  :
              try:
               ev = chskd.get_event(ac, True)
               mbch['cev'] = mbch['cev'] + 1
               if ev != None:
                cev = formircev(ev)
              except Exception as ee:
               mbacl[ac]['cerr']=mbacl[ac]['cerr']+1
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
    if not mbch['active']:return
    for ac in addrs:
        mbacl[ac]['buzy'] = True
        try:
            dt = None
            dt = mbch['chskd'].get_dt(ac)
            mbacl[ac]['buzy'] = False
            s = 'getdtonpoll ac=%3s,dt=%40s' % (ac, dt)
            mp('cyan',s)
            g=gfunc.al_209dt(ac,dt)
            if abs(g['acdelta'])>10 :
             al_setdt_ac(ac)
             mp('red','ac='+str(g['ac'])+' delta='+str(g['acdelta']))

        except Exception as ee:
            mbacl[ac]['buzy'] = False




def timer30s(interval):
    while True:
     gevent.sleep(interval)
     getdtonpoll()


def timer10s(interval):
    while True:
     gevent.sleep(interval)
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
         g['sp']=sp
         g['cmd'] = 'life'
         g['who'] = gprm['-ch']
         g['prefix'] = 'ch'
         g['ch'] ='192.168.0.96'            #   mbch['ch']
         g['pid'] = str(os.getpid())
         g['uxt'] = str(stofunc.nowtosec('loc'))
         formir_glstojs(g)
         mp('lime','timer10s'+str(g))
         mp('white','SPEED='+sp)


def fplay(wav):
    dir = gfunc.getmydir()
    pt = dir + 'wav/'+wav+' &'
    os.system('aplay ' + pt)

def formirmbch():
    g={}
    g['i']=0
    g['cev']=0
    g['speed']=0
    g['active']=False
    return g

def formirmbacl(ls):
 g={}
 for ac in ls:
  g[ac]={}
  g[ac]['kpx']='kpx'
  g[ac]['buzy']=False      # контроллер занят другой операцией (запись ключей ...)
  g[ac]['cerr']=0          # общее кол-во ошибок на этом контроллере
  g[ac]['currerr']=0       # текущее кол-во ошибок до первого успешного события
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
    if len(lsinjs)==0 : return
    g=lsinjs.pop(0)
    rmp('cyan','g='+str(g),5)
    mbch['chskd'].find_addrs()
    if g["cmd"]=='find_addrs':
     addrs=mbch['chskd'].find_addrs()
     rmp('lime','addrs='+str(addrs),20)

def onmesmqtt(client, userdata, message):
    pass
    js = message.payload.decode("utf-8")
    mp('magenta','oNmes=' + str(js))

    try:
     g=json.loads(js)
     mp('lime','g='+str(g))
     lsinjs.append(js)
    except Exception as ee:
      return

def connecttobroker(topic,cid,host):
    rmp('magenta','connecttobroker START',1)
    # print ('connecttobroker cid='+str(cid)+' /host='+host)
    mp('magenta','connecttobroker cid='+cid+' /host='+host)
    broker_address =host

    # print("creating new instance")
    # print('cyan','connecttobroker h='+host+' /cid='+cid)
    mqclient = mqtt.Client(cid)  # create new instance
    mqclient._connect_timeout=25.0
    mqclient.on_message = onmesmqtt  # attach function to callback
    print("connecting to broker")
    mqclient.connect(host)  # connect to broker
    mqclient.subscribe(topic)
    mqclient.loop_start()  # start the loop
    rmp('magenta','AFTER connecttobroker  ',3)
    return mqclient


def timerscancmd(interval):
    while True:
     gevent.sleep(interval)
     mp('yellow','timerscancmd')
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
       mbqt['mqtt']=connecttobroker(topic,'tomain',g['mqtt.host'])
       rmp('cyan', 'ch=' + str(g['ch']), 10)
       mbch['chskd']=crip(g['ch'])
       mbch['ch']=g['ch']
       #addrs=mbch['chskd'].find_addrs()
       #rmp('lime','addrs='+str(addrs),10)


def formir_glstojs(g):
   try:
    sj = json.dumps(g)
    if mbqt['mqtt']!=None:
     mbqt['mqtt'].publish('tss_mqtt',sj)
     mp('cyan','sj='+str(sj))
   except Exception as ee:
    mpr('glstojs',ee)

def wrallkeys(ac,n1,n2):
    msk=16
    ls = al_wratest(ac, n1, n2, [1, 2, 3, 4, 5, 6, 7, 8], msk)
    return ls



#====================mgbs==========================
mgb={}
mbch={}
mbch['i']=0
mbch['active']=False
mbqt={}
gprm={}
lsinjs=[]
gprm['-ch']='tsstest'
mbqt['mqtt']=None
mbacl={}
maxerv=10
tasks=[]
maxerv=10
mgb['ccs']=0
mp('magenta','start')
cid='ch_'+gprm['-topic']
connecttobroker(gprm['-topic'],cid,gprm['-host'])
'''
mbch=formirmbch()
mbch['chskd']=crip('192.168.0.96')
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

#sys.exit(99)
'''
task = gevent.spawn(timerscancmd,2)
tasks.append(task)
task = gevent.spawn(timer10s,10)
tasks.append(task)
ask = gevent.spawn(timer30s,30)
tasks.append(task)

task = gevent.spawn(timerpoll,0.9)
tasks.append(task)

gevent.joinall(tasks)
