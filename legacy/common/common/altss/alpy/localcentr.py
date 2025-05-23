#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import psycopg2
import json,subprocess
import paho.mqtt.client as mqtt
import maloneemulmod

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





def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
   redlog(txt)
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)



def redlog(txt):
    toredbase(txt)
    return
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




class Server(zerorpc.Server):
    def __init__(self, endpoint):
        super(Server, self).__init__()
        self.clients = {}
        self.bind(endpoint)

    def stso(self,g):
        try:
            # if g['cmd']=='getcpuinfo':
            #  rmp('lime',str(g),5)

            if g['cmd']=='sql':
                pass
                # mp('red','stso='+str(g))
            gg={}
            if type(g) != type(gg):
                mp('red','NOTGLS'+str(g))
                return
            try:
                cmd=g['cmd']
                if cmd=='cmdrd' or cmd=='keycrdr':
                    pass

            except Exception as ee:
                mpr('stso 1',ee)
            # lsgftpout.append(g)
            m1=gfunc.mymarker()
            # tostsobox(g)
            m2=gfunc.mymarker()
            d=gfunc.mymarkerdelta(m1,m2)
            # glstotransport.append(g)
        except Exception as ee:
            mpr('stso 2',ee)


    @zerorpc.stream
    def pull(self, name):
        queue = Queue()
        self.clients[name] = queue
        try:
            for item in queue:
                yield item
        finally:
            if id(self.clients.get(name)) == id(queue):
                self.clients.pop(name, None)

    def publish(self, data, *clients):
        if 0 == len(clients):
            for queue in self.clients.values():
                queue.put(data)
        else:
            for name in clients:
                queue = self.clients.get(name)
                if queue is not None:
                    queue.put(data)







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

def formir_glstojs(g):
   try:
    sj = json.dumps(g)
    mbqt['mqtt'].publish(g['komu'],sj)
   except Exception as ee:
    mpr('glstojs',ee)


def fplay(wav):
    mp('cyan','fplay='+wav)
    dir = gfunc.getmydir()
    pt = dir + 'wav/'+wav
    os.system('aplay ' + pt+' &')

def formirsendcli():
    g=lsgzcli.pop(0)
    clientftpsrv.send(g)
    mp('yellow','formirsendcli='+str(g))


def timerzero(interval):
   while True:
    gevent.sleep(interval)
    g={}
    g['cmd']='zpass'
    clientftpsrv.send(g)

def timerwork(interval):
   while True:
    gevent.sleep(interval)
    if len(lsgoneemul)>0:
     gin=lsgoneemul.pop(0)
     maloneemulmod.getparam(gin)

    l=len(lsgzcli)
    if l>0:formirsendcli()
    l=len(lsgtomqtt)
    if l>0 :
     gx=lsgtomqtt.pop(0)
     l = len(lsgtomqtt)
    # mp('lime','timerwork l='+str(l)+' / '+str(gx))
     formir_glstojs(gx)


def timer10s(interval):
   while True:
    gevent.sleep(interval)
    mp('lime','timer10s ?????????????????????????????????????????')
    gb={}
    gb['cmd']='life'
    gb['komu']='tomain'
    gb['kto']='localcentr'
    gb['uxt']=str(stofunc.nowtosec('loc'))
    lsgtomqtt.append(gb)

def calcstartline():
    s1 = sys.argv[0]
    s = ''
    for x in gprm:
        v = str(gprm[x])
        s = s + x + ' ' + v + ' '
    startline = 'python3 ' + s1 + ' ' + s + ' &'
    #mp('red', 'startline=' + startline)
    return startline

def totrans(js):
  try:
   g=json.loads(js)
   if g['subcmd'] == 'tosyslog':
    rmp('lime','TOSYSLOG',100)
 #  mp('red', 'TTTTTTTTTTTTTTTTTT CMD=' + g['cmd']+'/SUBCMD='+str(g['subcmd']))
   if g['cmd']=='tosyslog':
     pass
   mqttclient.publish('tss_mqtt', js)
   #mp('lime','TOTRANS='+str(js))
  except Exception as ee:
   mpr('totrans',ee)



def timertotrans(interval):
     while True:
      gevent.sleep(interval)
     ''' 
      l=len(lstotrans)
      if l>0:
       js=lstotrans.pop(0)
       totrans(js)
     '''


def jstogls(js):
    try:
     g = json.loads(js)
     #mp('cyan','jstogls g='+str(g))
     return g
    except Exception as ee:
        return None

def torpc():
   try:
    if  len(glstorpc)>0:
     g=glstorpc.pop(0)
     if 'rsendstate' in g.keys() and g['rsendstate']=='1':return

     if g['cmd']=='mbacinfo':
      rmp('lime',' ?????????????????????????torpc'+str(g),1)
     if 'target' in g.keys():
      #rmp('magenta','TARGET='+g['target'],3)
      tt=g['target']
      #mp('red','g='+str(g))
      clientftpsrv.send(g,tt)
      formirroad(g,tt, 'rpc')
     else:
      clientftpsrv.send(g)
   except Exception as ee:
    mpr('torpc',ee)

def crvtdms(gin):
    g={}
    g['cmd']='todms'
    #g['subcmd']= 'crvev'
    #g['evtyp']='virt'
    g['bidch']=mbsym['bidch']
    g['komu']='dms'
    g['target']='dms'
    g['ac']=mbsym['ac']
    g['port']='1'
    #g['rpcchname']=rpcchname
    #g['evid']=evid

    return g


def razborsimula():
    pass

def timer01s(interval):
    while True:
     gevent.sleep(interval)
     l=len(sljsin)
     if l>0:
      #
      js=sljsin.pop(0)
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



def timertestrpc(interval):
    while True:
        gevent.sleep(interval)
        g={}
        g['cmd']='timertestrpc'
        g['subcmd'] = 'timertestrpc'
        formirroad(g,'comcentr','rpc')

def onclftpsrv(sender,g):
    try:
     mp('magenta', 'oncl=' + str(g))
     if not 'cmd' in g.keys():   return
     #mp('magenta', 'oncl=' + str(g))


     if g['cmd'] == 'tranzit':
      gx = g['glsbody']
      lsgtomqtt.append(gx)
      #mp('cyan', 'onmes GX=' + str(gx))

    except Exception as ee:
     mpr('onclftpsrv',ee)


def toroad(g):
  try:
   gb=g['gbody']
   road=g['road']
   gx = g['gbody']
   try:
    #gx['rsendstate']='1'
    clientftpsrv.send(gx, road)
   except Exception as ee:
    mprs('toroad ROAD======================================================='+road,ee)
  except Exception as ee:
   mpr('toroad',ee)




def timerroad(interval):
  while True:
   gevent.sleep(interval)
   if len(slgroad)>0:
    g=slgroad.pop(0)
    toroad(g)


def formirroad(g,road,metod):
    gx={}
    gx['road'] = road
    gx['metod'] = metod
    gx['gbody'] = g
    slgroad.append(gx)


def fpgs_connect():
 try:
  conn = psycopg2.connect(
    host    =mysysinfo['base']['ip'],
    database=mysysinfo['base']['dbn'],
    user="postgres",
    port=5432,
    password=mysysinfo['base']['psw'],)
  rmp('lime', 'after open base  ПРОВЕРИТЬ ЗАЧЕМ ?????????', 2)
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')


def readrow(s):

    pgconn = fpgs_connect()
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
      gevent.sleep(0.5)

def readkeys():

    s='select kl.kluch from tss_persinfo ff,tss_keys kl'\
    ' where ff.myid =kl.bppers order by ff.name3'
    rmp('magenta','s='+s,3)
    ls=[]

    loc=readrow(s)
    for row in loc:
     kluch=row[0]
     mp('blue','kluch='+kluch)
     ls.append(kluch)
    return ls


def formirmbsym():
 try:
    rmp('blue','formirmbsym',5)
    #-symch 192.168.0.96,77,5,8,r
    g={}

    s=gprm['-symch']
    ls=s.split(',')
    ch=ls[0]
    ac=int(ls[1])
    symint=int(ls[2])
    g['ch']=ch
    g['symint']=symint
    g['ac'] = str(ac)
    g['nno']=0
    g['cp']=int(ls[3])
    g['regim']=ls[4]
    s='select myid from tss_ch where ch='+ap+ch+ap
    rmp('yellow','s='+s,10)
    loc=readrow(s)
    g['keysbox']=readkeys()
    for row in loc:
      g['bidch']=str(row[0])
      mp('yellow','mbsym='+str(mbsym))
    return g
 except Exception as ee:
   mpr('formirmbsym',ee)



def readchparam(p):
    try:
        s='select ' \
        ' tss_comps.name,'\
        ' tss_comps.myid,'\
        ' tss_ch.myid ,' \
        ' tss_ch.lobs,' \
        ' acl.myid'\
        ' from tss_comps, tss_ch,'\
        ' tss_acl as acl'\
        ' where '\
        ' tss_ch.actual=true ' \
        'and tss_comps.myid = tss_ch.bp '\
        ' and tss_ch.ch='+ap+mgb['ch']+ap+\
        ' and acl.ac='+str(mbsym['ac'])
        mp('cyan','readchparams s='+s)
        mp('magenta', 'readchparams s=' + s)

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
            mbsym['bidcomp'] = str(row[1])
            mbsym['bidch'] = str(row[2])
            mbsym['lobs'] = str(row[3])
            mbsym['bidac'] = str(row[4])
            mp('lime','comp='+comp+' /bidcomp='+mgb['bidcomp']+' / bidch='+mgb['bidch'])

        curs2.close
        print('cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc')


    except Exception as ee:
        row = None
        mpr('readchparam', ee)
        return None



def formirevent():
   try:
    if len(mbsym['keysbox'])==0:
     mbsym['keysbox'] = readkeys()
    if len(mbsym['keysbox'])>0:
      kluch=mbsym['keysbox'].pop(0)
      mp('yellow','formirevent kluch='+kluch)
      nn=int(mbsym['cp'])
      for n in range(1,nn+1,1):
       g={}
       g['cmd']='todms'
       g['port']=n
       mbsym['nno'] =mbsym['nno']+1
       nn=mbsym['nno'] * -1
       g['no']=nn
       g['kluch']=kluch
       g['code']=gfunc.keytox(kluch)
       g['bidch'] = mbsym['bidch']
       g['komu'] = 'dms'
       g['target'] = 'dms'
       g['ac'] = mbsym['ac']
       g['kpx'] = 'kpx'
       g['sens'] ='key'
       g['mrs'] = '1'
       g['ntmz'] ='ВСЕГДА'
       g['ev'] = 'key'
       evid = mbsym['bidcomp'] + '.' + mbsym['bidch'] + '.'+ mbsym['bidac'];
       g['evid']=evid
       g['evpid'] =evid+'.'+str(g['port'])
       g['rpcchname']=mbsym['rpcchname']
       js= json.dumps(g)
       simbox.append(js)
      # mp('yellow','js='+str(js))
   except Exception as ee:
     mpr('formirevent',ee)




def timersimbox(interval):
    while True:
     gevent.sleep(interval)
     if len(simbox)>0:
      js=simbox.pop(0)
      sljsin.append(js)
     # mp('white','simbox='+str(len(simbox)))



def timersimul(interval):
    while True:
     gevent.sleep(interval)
     formirevent()
     mp('cyan','timersimul')




def onmesmqtt(client, userdata, message):
    try:
     js = message.payload.decode("utf-8")
     g=json.loads(js)
     if not 'cmd' in g.keys():return
     if g['cmd'] == 'setdrv':
      mp('lime','ZZZZZZZonmes='+str(g))
      lsgzcli.append(g)
     if g['cmd'] == 'todrv':
      rmp('red',str(g),2)
     if g['cmd'] == 'todmsev':
       pass
       #mp('magenta','@@@@@@@@@@@@@@@@@='+str(g))
     if g['cmd']=='ztranzit':
      gb=g['glsbody']
      #mp('lime','ONMESS='+str(gb))
      lsgzcli.append(gb)
    except Exception as ee:
      mprs('onmes',ee)


def mysubscreibe(topic):
    try:
     mbqt['mqtt'].subscribe(topic)
     lstopics.append(topic)
     return 'ok',lstopics
    except Exception as ee:
     mpr('mysubscreibe',ee)
     return str(ee),lstopics

def connecttobroker(cid,host):
    rmp('lime','connecttobroker START',1)
    # print ('connecttobroker cid='+str(cid)+' /host='+host)
    mp('magenta','connecttobroker cid='+cid+' /host='+host)
    broker_address =host
    mqclient = mqtt.Client(cid)  # create new instance
    mqclient._connect_timeout=25.0
    mqclient.on_message = onmesmqtt  # attach function to callback
   # print("connecting to broker")
    mqclient.connect(host)  # connect to broker
    mqclient.loop_start()  # start the loop
    rmp('magenta','AFTER connecttobroker  ',3)
    mbqt['mqtt']=mqclient
    return mqclient


def mysubscreibe(topic):
    try:
     mbqt['mqtt'].subscribe(topic)
     lstopics.append(topic)
     return 'ok',lstopics
    except Exception as ee:
     mpr('mysubscreibe',ee)
     return str(ee),lstopics



#==============================mgbs=================================
p=chr(0x27)
ap=chr(0x27)
zp=','
mgb={}
mbsym={}
simbox=[]
lsgtomqtt=[]
lsgzcli=[]
tasks=[]
gprm={}
mbqt={}
mbqt['mqtt']=None
lsgoneemul=[]


lstopics=[]
gprm=gsfunc.gonsgetp()
pt=gfunc.calcptstarter()
startline=calcstartline()
rmp('red','start test comcentr !!!!!!!!!!!!!!!!!!!!!1',3)
mp('red','pt='+str(pt))
mgb['vbstarter']=gfunc.opendb3(pt,'r')
vb=mgb['vbstarter']
mysysinfo=gfunc.readstarter(vb)
mp('cyan','mysysinfo='+str(mysysinfo))
gprm['-ch']='comcentr'

mqttclient=connecttobroker('localcentr',mysysinfo['transport']['ip'])
mbqt['mqtt']=mqttclient
rc,ls=mysubscreibe('tomain')
rc,ls=mysubscreibe('maldms')
mp('lime','ls='+str(ls))

pgconn=fpgs_connect()
mgb['pgc']=pgconn
gprm['-ch']='localcentr'
mp('red','start')

server=Server('tcp://127.0.0.1:5555')
task = gevent.spawn(server.run)
tasks.append(task)

hc='tcp://127.0.0.1:5555'
#hc='tcp://'+mysysinfo['comcentr']['ip']+':'+mysysinfo['comcentr']['port']
#mp('cyan','hc='+hc)

clientftpsrv=ccftpsrv(hc,'localcentr')
ccftpsrv.on_receive = onclftpsrv
task= gevent.spawn(clientftpsrv.run)
tasks.append(task)



task=gevent.spawn(timer10s,10)
tasks.append(task)
task=gevent.spawn(timerwork,0.001)
tasks.append(task)
#task=gevent.spawn(timerzero,1)
#tasks.append(task)





rmp('magenta','joinall',2)
gevent.joinall(tasks)

