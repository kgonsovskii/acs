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
import json,subprocess

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
    mqttclient.publish('tss_mqtt',sj)
   except Exception as ee:
    mpr('glstojs',ee)


def fplay(wav):
    mp('cyan','fplay='+wav)
    dir = gfunc.getmydir()
    pt = dir + 'wav/'+wav
    os.system('aplay ' + pt+' &')

def timer10s(interval):
  try:
   while True:
    gevent.sleep(interval)
    #fplay('ping1.wav')
    x=False
    if x:
        g = {}
        g['cmd'] = 'tocomcentr'
        g['subcmd'] = 'comcentrlife'
        g['uxt'] = str(stofunc.nowtosec('loc'))
        g['target'] = 'totop'
        g['rsendstate'] = '0'
        js = json.dumps(g)
        g['rpcchname'] =gprm['-ch']
        g['pid'] = str(os.getpid())
        g['startline'] =startline
       # mp('cyan','timer10s')
        #lstotrans.append(js)
        #clientftpsrv.send(g,'sgrd')
        #formirroad(g,'sgrd','rpc')
        #mp('cyan','timer10s='+js)
  except Exception as ee:
    mpr('timer10s',ee)


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
      l=len(lstotrans)
      if l>0:
       js=lstotrans.pop(0)
       totrans(js)



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
     l=len(mqtransmod.sljsin)
     if l>0:
      #mp('cyan','timer01s l='+str(l))
      #while len(mqtransmod.sljsin)>0:
      js=mqtransmod.sljsin.pop(0)
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
     if not 'cmd' in g.keys():   return
     if 'sens' in g.keys() :
      pass

     if g['cmd']=='todms':return
     #mp('red','SUBcmd='+g['subcmd']+' cmd='+g['cmd'])


     if 'subcmd' in g.keys() and g['subcmd'] == 'sgrdlife':
      pass
      #rmp('yellow', 'oncl =' + str(g), 2)
     if g['cmd']=='tosyslog' or g['subcmd']=='tosyslog':
      rmp('gray','????????????????????????????',3)

     if'subcmd' in g.keys():
      #mp('blue', 'oncl subcmd=' + str(g['subcmd']))
      if g['subcmd']=='dmslife':
       pass
       #rmp('red','oncl='+str(g)[0:120],3)
       #mp('yellow','SUBCMDsssssssssssssssssssssssssssss='+str(g['subcmd']))
     if not 'subcmd' in g.keys():
      mp('blue', 'TTTTToncl=' + str(g))


     #if g['subcmd']=='writerloglife':
     #mp('lime','oncl='+str(g))
     if  'rsendstate' in g.keys() and g['rsendstate']=='1' :return
     cmd=g['cmd']
     g['rsendstate']='1'
     g['cmd']='tocomcentr'
     js = json.dumps(g)
     if 'subcmd' in g.keys() and g['subcmd'] == 'relay':
         rmp('gray', '?????????     RELAY ', 10)
     lstotrans.append(js)
     if 'subcmd' in g.keys() and g['subcmd'] == 'tosyslog':
      pass
      rmp('blue','oncl js='+js,3)
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
      mqtransmod.sljsin.append(js)
     # mp('white','simbox='+str(len(simbox)))



def timersimul(interval):
    while True:
     gevent.sleep(interval)
     formirevent()
     mp('cyan','timersimul')

#==============================mgbs=================================
p=chr(0x27)
ap=chr(0x27)
zp=','
mgb={}
mbsym={}
simbox=[]
slgroad=[]
tasks=[]
gprm={}
#glstorpc=[]
lstocomcentr=[]
lstotrans=[]
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

mqttclient=mqtransmod.connecttobroker('comcentr',mysysinfo['transport']['ip'])
mqttclient.loop_start()  # start the loop
mp('w','11111111111111111111111111111111111111111')
hs='tcp://'+mysysinfo['comcentr']['ip']+':'+mysysinfo['comcentr']['port']
mp('cyan','hs='+hs)


pgconn=fpgs_connect()
mgb['pgc']=pgconn
gprm['-ch']='comcentr'
mp('red','start')

if '-symch' in gprm.keys():
    mbsym=formirmbsym()
    mp('yellow','mbsym[ch]='+str(mbsym['ch']))
    mgb['ch']=mbsym['ch']
    readchparam(mbsym['ch'])
    rpcchname= 'drv' +'209' + '_' +mbsym['ch']
    mbsym['rpcchname']=rpcchname
    mp('magenta','rpcchname='+str(rpcchname))




#server=Server('tcp://127.0.0.1:5555')
server=Server(hs)
task = gevent.spawn(server.run)
tasks.append(task)

mp('wait','22222222222222222222222222222222222')
#hc='tcp://127.0.0.1:5555'
hc='tcp://'+mysysinfo['comcentr']['ip']+':'+mysysinfo['comcentr']['port']
mp('cyan','hc='+hc)

mp('w','22222222222222222222222222222222222')
clientftpsrv=ccftpsrv(hc,'comcentr')
ccftpsrv.on_receive = onclftpsrv
task= gevent.spawn(clientftpsrv.run)
tasks.append(task)


task=gevent.spawn(timer10s,10)
tasks.append(task)

task=gevent.spawn(timer01s,0.01)
tasks.append(task)


task=gevent.spawn(timer10s,10)
tasks.append(task)

task=gevent.spawn(timertotrans,0.1)
tasks.append(task)

task=gevent.spawn(timerroad,0.01)
tasks.append(task)

#task=gevent.spawn(timertestrpc,3)
#tks.append(task)
if '-symch' in gprm.keys():
    if mbsym['symint']>0:
     task=gevent.spawn(timersimul,mbsym['symint'])
     task = gevent.spawn(timersimbox,00.1)
     tasks.append(task)



rmp('magenta','joinall',2)
gevent.joinall(tasks)

