#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
import zerorpc
import gevent
import traceback
import libtssacs as acs
import sys,os,platform
from gevent.queue import Queue
import geconfunc,gsfunc,stofunc,myfunction
import serial,socket
from os import path, sep
import m7func
import zlib, base64
import  sqlite3


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
            except Exception,ee:
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
    # toselflog(txt+'/ee='+em)


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)
    # toselflog(txt+'/ee='+em)



def mp(c,txt):
 try:
  t=geconfunc.mytime()
  # rbfunc.mp(c,'GONSABL. '+txt+'  /t='+t+' /regim='+mgb['abloy'])
  geconfunc.mpv(c,'M7MON. '+txt+'/ '+t)
  print
 except : pass

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def win_getmaca():
   try:
    # rmp('red','win_getmaca',2)
    maca=m7func.win_getmac()
    ip=socket.gethostbyname(socket.gethostname())
    return maca,ip
   except Exception,ee:
    print 'getmaca_win ERROR='+str(ee)
    sys.exit(99)


def gonscovertdt(evt):
    try:
      # import random
      evt.dt.year=evt.dt.year+2000
      d='%.4d.%.2d.%.2d'% (evt.dt.year, evt.dt.month,evt.dt.day)
      t= '%.2d:%.2d:%.2d' %(evt.dt.hour, evt.dt.minute, evt.dt.second)
      # ls=['2018.01.01','2017.01.01','2016.01.01']
      # d=random.choice(ls)
      dt=d+' '+t
      # rmp('red','gonscovertdt================='+dt,1)
      return dt
    except Exception,ee:
     mpr('gonscovertdt',ee)



def delemp(ls):
 for i in range(1,100,1):
  try:
   n= ls.index('')
   ls.pop(n)
  except :
   return ls
 return ls



def getipafromipconfig():
# 2-stroka    # inet addr:192.168.0.90  Bcast:192.168.0.255  Mask:255.255.255.0
    mp('yellow','getipafromipconfig start')
    appdir=geconfunc.getmydir()
    fn=appdir+'rbcfindip.txt'
    try:
     s='rm '+fn
     if os.path.isfile(fn):
      os.system(s)
     # os.unlink(fn) suda
    except: pass

    try:
        # rmp('yellow','getipafromipconfig ',5)
        s='ifconfig>'+fn+ ' '
        os.system(s)
        # mp('red','getipafromipconfig  after psystem')
        for i in range(1,30,1):
         gevent.sleep(0.5)
         mp('white','gdelay '+str(i)+ '......................................')
         if os.path.isfile(fn):
          # log('i,FIND !!!!!!!!!!!!!!!!1 '+fn)
          f=open(fn,'r')
          ls1=f.readlines()
          if len(ls1)==0:
            return None
          ss=ls1[1]
          ls=ss.split(' ')
          ls=delemp(ls)
          ss=ls[1]
          ls=ss.split(':')
          ip=ls[1]
          mp('white','getipafromipconfig  ip='+ip)
          mgb['ip']=ip
          return ip
        else:
           gevent.sleep(0.1)


    except Exception,ee:
        mpr('getipafromipconfig',ee)
        return 'UNDEF'





def getmaca_rbc():
  try:
    s='ifconfig>m7maca_mac.txt'
    maca='undef'
    os.system(s)
    gevent.sleep(0.1)
    f=open('m7maca_mac.txt')
    s=f.readline()
    ls=s.split('HWaddr ')
    if len(ls)>=2:
     s=ls[1]
     maca=s.strip()
     return maca
  except Exception,ee:
   mpr('getmaca_rbc',ee)




def getmaca_lin():
    mp('lime','getmaca_lin start ')
    return getmaca_rbc()

def getmaca(sos):
  try:
    if sos=='windows':
     maca,host=win_getmaca()
     mgbcpu['host']=host
     # rmp('red','getmaca='+host,20)
     # print 'maca='+maca,host
     # gevent.sleep(5)
    if sos=='linux':
      # host=socket.gethostbyname(socket.gethostname())
      host=getipafromipconfig()
      maca=getmaca_lin()
      rmp('magenta','maca='+maca+' /host='+host,30)
    mgbcpu['maca']=maca
    mgb['maca']=mgbcpu['maca']
    mgbcpu['host']=host
    mgb['host']=host
    mgb['selfip']=host
  except Exception,ee:
    mpr('getmaca',ee)
    sys.exit(99)

def getplatform():
    plt=platform.uname()                       #armv61- malina 2 armv71- malina3
    # mp('red','plt='+str(plt))
    # plt=('Linux', 'rpi', '4.1.13+', '#826 PREEMPT Fri Nov 13 20:13:22 GMT 2015', 'armv6l', '')
    mgbcpu['os']=plt[0].lower()
    mgbcpu['proc']=plt[1]
    mgbcpu['vers']=plt[2]
    mgbcpu['release']=plt[3]
    mgbcpu['arm']=plt[4]
    getmaca(mgbcpu['os'])
    # rmp('red','mgbcpu='+str(mgbcpu),10)
    # ============================================================

def findac():
    chskd=mgbcpu['chskd']
    chskd.flush_input() #suda only 422

    rmp('yellow','findac ................. ',20)
    addrs= chskd.find_addrs()
    return addrs


def todms(g):
 try:
  # mp('red','todms start='+str(g))
  gg={}
  gg['cmd']='todmsev'
  # gg['m1mm']=geconfunc.mymarker()
  # gg['m1s']=stofunc.nowtosec('loc')
  gg['ac']=g['ac']
  gg['port']=g['port']
  gg['ch']=g['ch']
  gg['host']=g['host']
  gg['maca']=mgbcpu['maca']
  gg['cd']=g['cd']
  gg['ct']=g['ct']
  gg['av']=g['av']
  gg['no']=g['no']
  gg['kl']=g['kluch']
  gg['sn']=g['sn']
  gg['event']=g['event']
  gg['m1s']=g['m1s']
  gg['bpmaca']=str(mgbcpu['bidmaca'])
  gg['bpch']=str(mgbcpu['bidch'])

 except Exception,ee:
  mpr('todms 1',ee)
 try:
  if gg['av']=='k':
   # mp('lime','todms='+str(gg))
   clientftpsrv.send(gg,'gecon_skud_dms')
 except Exception,ee:
    mprs('todms 2',ee)


def tosockets_event(gin):
    try:

      # mp('red',' Tosck='+str(gin))
      g={}
      g['sn']='skd.'+str(gin['adrc'])+'.'+str(gin['port'])
      g['cmd']='toss'
      g['towin']='towin'
      g['subcmd']='streamsock'
      g['who']='skd'

      g['ac']=str(gin['adrc'])
      # ct=myfunction.mytime()[0:8]
      # ct=myfunction.zerol(ct,8)
      g['host']=mgb['selfip']
      g['maca']=mgb['maca']
      g['ch']=mgbcpu['ch']
      g['ct']=gin['ct']
      g['cd']=gin['cd']
      g['alias']=gin['alias']
      g['kluch']=gin['kluch']
      g['rst']=gin['rst']
      g['av']=gin['av']
      g['event']=gin['event']
      g['port']=gin['port']
      g['no']=str(gin['no'])
      g['type']='event'
      g['m1s']=str(stofunc.nowtosec('loc'))
      if g['av']=='k':
       todms(g)
       return
      line=formirlinesocks(g)
      g['line']=line
      tologs(g['cd'],g['ct'],line)
      lsgtosockets.append(g)

    except Exception,ee:
     mpr('tosockets_event',ee)


def pcreatech(ch):
 try:
   ls=ch.split('.')
   l=len(ls)
   rmp('magenta','pcreatech start ch='+ch+' /l='+str(l),1)
   if l>=3:
    rmp('red','CALL CREATE TCP CLASS='+ch,50)
    mgb['chskds']=ch
    chx=acs.ChannelTCP(ch)
    chx.response_timeout=0.1
    rmp('red','after tcp='+ch,5)
    mgbcpu['chskd']=chx
    return chx


   rmp('cyan','pcreatech ch='+str(ch),5)
   mgb['chskds']=ch
   if ch=='422' :
    ch=acs.ChannelRS422()
    rmp('cyan','pcreatech ch='+str(ch),5)
    return ch
   rmp('cyan','os='+mgbcpu['os'],3)
   if mgbcpu['os']=='windows':
    ch= acs.ChannelRS232(ch)
   rmp('white',str(ch),3)
   return ch
  # toselflog('open channel 232')
  # ch232= acs.ChannelRS232()
 except Exception,ee:
  mpr('pcreatech',ee)

def formir_test():
  try:
   g={}
   g['cmd']='NEWTEST'
   g['body']='BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
   mp('red','formir_test g='+str(g))
   clientftpsrv(g)
   rmp('lime','timertestbb  OK..............................',5)
  except Exception,ee:
   mprs('formir_test',ee)


def timertestbb(interval):
    while True:
     gevent.sleep(interval)
     mp('white','timertestbb ..............................')
     # formir_test()


def formirvt(ls):
    pass

def checkvirt():
   try:
    if mgbcpu['ctyp']=='real':return
    ip=mgb['selfip']
    ch=mgbcpu['ch']
    pt='/home/pi/m7/config/'+ip+'/'+ch+'/virt/events.txt'
    if os.path.isfile(pt):
     inp=open(pt,'r')
     ls=inp.readlines()
     inp.close
     geconfunc.mydeletefile(pt)
     formirvt(ls)
   except Exception,ee:
    mprs('checkvirt',ee)

def checkexe():
    ip=mgb['selfip']
    ch=mgbcpu['ch']
    pt='/home/pi/m7/config/'+ip+'/'+ch+'/exe/cmd.txt'
    # mp('cyan','checkexe pt='+pt)
    if os.path.isfile(pt):
     inp=open(pt,'r')
     ls=inp.readlines()
     inp.close()
     g=geconfunc.lstogls(ls)
     rc=exerele(int(g['ac']),int(g['numr']),int(g['tmr']))
     if rc :
      mp('lime','checkexe g='+str(g))
      geconfunc.mydeletefile(pt)




def timer1(interval):
    while True:
     gevent.sleep(interval)
     # formir_test()
     checkexe()
     l=len(m7func.shrbox)
     if l>0:
      g=m7func.shrbox.pop(0)
      rmp('red',str(g),1)
      sendmesshr(g)

def sendmesshr(gin):
     try:
      g={}
      g=gin
      # mp('red','gin='+str(gin))
      g['cmd']='toss'
      # g['speed']='undef'
      g['subcmd']='streamsock'
      g['who']='skd'
      g['host']=mgb['selfip']
      g['maca']=mgb['maca']
      lsgtosockets.append(g)
     except Exception,ee:
      mpr('sendmesshr',ee)


def send_error_unit_skd(gin):
    try:

      g={}
      g=gin
      # mp('red','gin='+str(gin))
      g['cmd']='toss'
      # g['speed']='undef'
      g['subcmd']='streamsock'
      g['who']='skd'
      g['host']=mgb['selfip']
      g['maca']=mgb['maca']
      lsgtosockets.append(g)
      # mp('red','send_error_unit_skd type='+str(g['type']))
    except Exception,ee:
      mpr('send_error_unit_skd',ee)


def pdeleteacfromaddrs(addrs,ac):
   try:
     if ac==None:return
     if addrs==None:return
     if len(addrs)==0:return
     mp('red','pdeleteacfromaddrs attempt='+str(ac)+' /addrs='+str(addrs))
     addrs.remove(ac)
     mp('red','pdeleteacfromaddrs after='+str(ac)+' /addrs='+str(addrs))
   except Exception,ee:
    mprs('pdeleteacfromaddrs',ee)
   toworktxt(addrs)



def pdeleteacfromaddrsOLD(addrs,ac):
   try:
    mp('red','pdeleteacfromaddrs addrs='+str(addrs))
    if ac==None:return
    mp('red','pdeleteacfromaddrs start badac='+str(ac)+' /list='+str(addrs))
    try:
     n=addrs.index(ac)
    except BaseException,ee:
     mprs('pdeleteacfromaddrs',ee)
     # return
    try:
     addrs=addrs.remove(ac)
    except: pass
    toworktxt(addrs)
   except Exception,ee:
    mpr('pdeleteacfromaddrs',ee)
    mp('red','pdeleteacfromaddrs addrs='+str(addrs))



def get_event(addr, is_complex):
    try:
        ev=None
        ac=addr
        # print 'regim='+glsacrg[ac]
        if glsacrg[ac]=='w':
         return None
        ct=geconfunc.mytime()
        # print 'get_event addr=',addr,is_complex,ct
        # mp('cyan','get_event ac='+str(ac))
        try:
         # m1=stofunc.nowtosec('loc')
         # if ac==7 and not m1%10:
         #  k=str(ac)+'.count'
         #  glsce[k]=glsce[k]+1
         #  mp('cyan','get_event ac='+str(ac)+' /k='+k+' /ec='+str(glsce[k]))
         #  if glsce[k]>=0:
         #   mp('red','EMULATION AC ERROR='+str(glsce[k]))
         #   pdeleteacfromaddrs(addrs,addr)



         k=str(ac)+'.count'
         # try:
         # mp('yellow','get_event adddr='+str(addr))
         ev=chskd.get_event(addr, is_complex)

         # except Exception,ee:
         #  mprs('hskd.get_event addr='+str(addr),ee)
         glsce[k]=0
        except Exception,ee:
          mprs('get_even.tGLSCE ac='+str(addr)+' /???='+str(glsce[k]),ee)
          if glsce[k]>=int(skdparams['ac_limit_error']):
           pdeleteacfromaddrs(addrs,addr)

          k=str(ac)+'.count'
          # k=str(ac)+'.uxt'
          glsce[k]=int(glsce[k])+1
          mpr('get_event ac2='+str(ac),ee) # +' /COUNT='+str(glsce[k]))
          return None
        return ev
    except Exception as ee:
        mpr('get_event tuta',ee)
        g={}
        g['ac']=str(addr)
        g['erm']=str(ee)
        g['type']='error_ac'
        send_error_unit_skd(g)
        # mp('magenta','get_event error='+str(ee))
        k=str(addr)+'.count'
        mp('yellow',' k='+k+'='+str( glsce[k]))
        # mp('magenta','get_event'+'addr='+str(addr)+' /ee='+str(ee)+' /COUNTERROR='+str( glsce[k]))
        glsce[k]=glsce[k]+1
        if glsce[k]>30:
         pdeleteacfromaddrs(addrs,addr)
         mp('red','addrs='+str(addrs)+'TUTA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
        k=str(addr)+'.uxt'
        glsce[k]=stofunc.nowtosec('loc')
        g={}
        g['cmd']='error_ac'
        g['adrc']=str(addr)
        g['event']=str(ee)
        g['maca']=mgb['maca']
        g['ch']='422'
        g['cdate']=myfunction.mydatezz()
        ct=myfunction.mytime()[0:8]
        ct=myfunction.zerol(ct,8)
        g['ctime']=ct
        k=str(addr)+'.count'
        g['cer']=str(glsce[k])
        gproc['type']='error_ac'
        tosockets_error_ac(g)

        # lsgtostso.append(g)
        # mp('red',str(glsce[k]))


def tosockets_error_ac(gin):
  try:
      g={}
      g=gin
      # mp('red','gin='+str(gin))
      g['cmd']='toss'
      # g['speed']='undef'
      g['subcmd']='streamsock'
      g['who']='skd'
      g['host']=mgb['selfip']
      g['maca']=mgb['maca']
      lsgtosockets.append(g)


  except Exception,ee:
    mpr('_pollspeed',ee)








def poll_event():
    while True:
        # if m7func.mgb['busy']:return
        evt=None
        gevent.sleep(0.0001)
        # if mgb['stoppoll']:break
        # if mgb['blk']==True: break

        # if gbspeed['num']==0:
        #  pass
         # gbspeed['m1']=stofunc.nowtosec('loc')
        gbspeed['num']=gbspeed['num']+1
        # print 'gbspeed[num]=',gbspeed['num'],'/addrs=',addrs
        for addr in addrs:
           # if glsacrg[addr]=='w': return None
           if acstop[addr]=='poll':
             if glsacrg[addr]=='a':
              try:
               # mp('yellow','addr='+str(addr)+' call getevent AVTONOM')
               evt = get_event(addr, False)  # avtonom +read events
              except Exception,ee:
               pass
               # mprs('poll avtonom',ee)
              # print addr,False
             if glsacrg[addr]=='k':
              # mp('cyan','addr='+str(addr)+' call getevent KOMPLEX ')
              try:
               evt = get_event(addr,True)
              except Exception,ee:
                mpr('getevent.poll komplex',ee)




             if evt is not None:
                # lsgsrc.append(evt)
                print 'poll_event ev='+str(evt)
                showevt(evt)



def exerele(ac,port,tmr):
   try:
    if tmr<0:
     chskd.relay_off(ac,port)
     return True
    tmr=int(tmr)
    tme=tmr*2
    chskd.relay_on(ac,port,tme)
    mp('blue','exerele ac='+str(ac)+' /port='+str(port)+' / tmr='+str(tme))
    return True
   except Exception,ee:
     mpr('exerele',ee)
     return False



def convertwiegand(k):
 return k ^ 0x3FFFFFF


def  readdatakomplexkey(ac,kl,port):
  try:
   mp('yellow','readdatakomplexkey start ac='+str(ac)+' /port='+port+' /kl='+kl)
   return 'go'
   ap='"'
   mp('red','readdatakomplexkey ac='+str(ac)+' /kl='+str(kl)+' /port='+str(port))
   appdir=myfunction.getappdir()
   pt=appdir+'db/mapcont.db3'
   vb=rbfunc.reconnectbase(pt)
   s='select * from mapcont where alias='+ap+mgb['selfip']+ap+' and ac='+ac+' and kluch='+ap+kl+ap
   vb.cursor.execute(s)
   kluch=None
   for row in vb.cursor:
    kluch=row['kluch']
    maska=row['maska']
    break
   if kluch==None:
     return 'nf'
   rc=checkkomplexport(maska,port)
   if rc==False:
     return'bm'

   s='select * from relay where alias='+ap+mgb['selfip']+ap+' and ac='+ac+' and port='+port
   vb.cursor.execute(s)
   for row in vb.cursor:
     tmr=row['tmr']
     break
   chskd.relay_on(int(ac),int(port),int(tmr*2))
   return 'go'
  except Exception,ee:
   mpr('readdatakomplexkey',ee)
   return 'ad'



def work_key_komplex(g):
   try:
    av=g['av']
    mp('red','work_key_komplex g='+str(g))
    ac=str(g['adrc'])
    kl=g['kl']
    port=str(g['port'])
    s='av=%2s ,ac=%3s ,kl=%12s, port=%2s' %(av,ac,kl,port)
    # rmp('lime',s,3)
    rc=readdatakomplexkey(ac,kl,port)
    return rc

   except Exception,ee:
    mpr('work_key_komplex',ee)


def tologs(cdc,ctc,s):
  try:
      # mp('red','????????? start tologs,cdc='+cdc+' /ctc='+ctc)
      # mp('red','tologs000='+s)
      store=mgbcpu['store']
      cd=geconfunc.mydatezz()
      ct=geconfunc.mytime()[0:8]
      ct=geconfunc.zerol(ct,8)
      cd=cdc
      ct=ctc
      dt=cd+' '+ct

      dt=cdc+' '+ctc
      fn=cdc
      fn=fn+'.txt'
      appdir=geconfunc.getmydir()

      # pt=store+'skud'+sep
      # if not os.path.isdir(pt):
      #  os.mkdir(pt)
      # pt=store+'skud'+sep+mgbcpu['host']        #+sep+'eventslogs'+sep
      # if not os.path.isdir(pt):
      #   mp('lime','tologs.mkdir='+pt)
      #   os.mkdir(pt)
      # pt=store+'skud'+sep+mgbcpu['host']+sep+'eventslogs'+sep
      # if not os.path.isdir(pt):
      #   mp('lime','tologs.mkdir='+pt)
      #   os.mkdir(pt)

      pt='applogs'+sep+mgb['host']+sep+'skud/'
      gg={}
      gg['md']=pt
      rc=geconfunc.crm7dirvc(gg)
      pt=rc['md']
      ptf=pt+fn
      # rmp('red','ptf ???='+ptf,3)
      outp=open(ptf,'a')
      cd=geconfunc.mydatezz()
      ct=geconfunc.mytime()[0:8]
      ct=geconfunc.zerol(ct,8)
      dt=cd+' '+ct
      outp.write(str(dt)+' /'+str(s)+'\n')

      outp.flush()
      outp.close()
      # mp('red','tologs ptf='+ptf)
  except Exception,ee:
   mpr('toslogs',ee)






def formirlinesocks(g):
 try:
  alias=g['alias']
  # ct=geconfunc.mytime()[0:8]
  ct=g['ct']
  cd=g['cd']
  maca=g['maca']
  ch=g['ch']
  ac=str(g['ac'])
  kl=str(g['kluch'])
  rst=str(g['rst'])
  av=str(g['av'])
  port=str(g['port'])
  ev=g['event']
  no=g['no']
  dt=cd+','+ct
  line='%20s;%8s;%8s;%20s;%8s;%8s;%12s;%8s;%8s;%8s;%8s;' % (maca,alias,ch,dt,ac,port,kl,ev,rst,av,no)
  # mp('red','line='+line)
  return line
# 10.10.9.1;2017.09.21;00:00:51;     8;  1;00000222F1BF;     key;      go;

 except Exception,ee:
   mpr('formirlinesocks',ee)


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



def formir_sendsock(g,rc):
    # mp('magenta','formir_sendsock START='+str(g)[0:90])
    gg={}
    gg['sn']=g['sn']
    if rc==0:
     gg['erm']='ok'
    else:
     gg['erm']=g['erm']
    gg['cmd']=g['cmd']
    gg['rc']=rc
    gg['ac']=g['ac']
    gg['rclist']=g['rc']
    gg['host']=mgb['host']
    gg['maca']=mgb['maca']
    gg['cd']=geconfunc.mydatezz()
    gg['ct']=geconfunc.mytime()[0:8]

    try:
     clientftpsrv.send(gg,'geconsendersockss')
     if rc==0:
      mp('lime','formir_sendsock gg='+str(gg)[0:90])
     else:
      mp('red','formir_sendsock gg='+str(gg)[0:90])
    except Exception,ee:
      mprs('formir_sendsock send',ee)



def showevt(evt):
  try:
      t=type(evt)
      chs=mgbcpu['ch']
      av=evt.is_complex
      # if av:return
      rmp('cyan','SHOWEVT AV='+str(av),2)
      # mp('red','showevt='+str(evt))
      g={}
      g['alias']=mgb['selfip']
      ac=evt.addr
      g['adrc']=ac
      p=evt.port
      g['port']=p
      avx=evt.is_complex
      if avx: av='k'
      else:   av='a'
      g['av']=av
      g['code']='undef'
      g['kluch']='undef'
      # if av=='a':
      cd=gonscovertdt(evt)
      ls=cd.split(' ')
      g['cd']=ls[0]
      g['ct']=ls[1]
      # rmp('red','showevt ls='+str(ls)+' /cd='+g['cd'],2)
      g['rst']='u'
      if  isinstance(evt, acs.EventKey):
          g['no']=evt.no
          code=evt.code
          kl=geconfunc.xkeytos(code)
          cd=gonscovertdt(evt)
          r=evt.is_access_granted
          if av=='k':
           code=evt.code
           kl=geconfunc.xkeytos(code)
           g['kl']=kl
           g['rst']='und'
           # g['rst']=work_key_komplex(g)
           ev='key'
           g['event']=ev
           g['rst']=getresultkey(evt)
           g['kluch']=geconfunc.xkeytos(code)
           ik=convertwiegand(code)
           ik=str(geconfunc.xkeytos(ik))
           # if r :g['rst']='go'
           # else :g['rst']='ad'
           g['rst']='undk'
           s='av=%2s ,ev=%8s , ac=%3s,p=%2s,kl=%8s,IK=%8s,rst=%8s,dt=%8s' % (av,ev,str(ac),str(p),str(kl),ik,g['rst'],cd)
           mp('lime','SHOWEVT_1='+s)
           # mp('red','showevt g='+str(g))
           tosockets_event(g)

           # tosepar(g)
           return

          r=evt.is_access_granted
          if r :g['rst']='go'
          else :g['rst']='ad'
          ev='key'
          g['rst']=getresultkey(evt)
          g['event']=ev
          g['kluch']=geconfunc.xkeytos(code)
          ik=convertwiegand(code)
          ik=str(geconfunc.xkeytos(ik))
          s='av=%2s ,ev=%8s , ac=%3s,p=%2s,kl=%8s,IK=%8s,rst=%8s,dt=%8s' % (av,ev,str(ac),str(p),str(kl),ik,g['rst'],cd)
          mp('lime','SHOWEVT_A='+s)
          tosockets_event(g)

      if  isinstance(evt, acs.EventDoor):
          # mp('red','showevt='+str(evt)[0:110])
          # cd=gonscovertdt(evt)
          ev=evt.is_open
          if ev:ev='open'
          else:ev='close'
          code='undef'
          g['event']=ev
          g['no']=str(evt.no)
          s='ch=%8s, av???=%2s ,ev=%8s , ac=%3s,p=%2s ,kl=%8s, dt=%8s' % (chs,av,ev,str(ac),str(p),str(code),cd)
          mp('yellow',s)
          formirgeconbase(g)
          tosockets_event(g)

          # tosepar(g)

      if  isinstance(evt, acs.EventButton):
          ac=evt

          r
          p=evt.port
          g['event']='rte'
          av=evt.is_complex
          if av:av='k'
          else: av='a'
          code='undef'
          cd=gonscovertdt(evt)
          # ev=evt.is_open
          ev='rte'
          g['no']=str(evt.no)
          s='av=%2s ,ev=%8s , ac=%3s,p=%2s ,kl=%8s, dt=%8s' % (av,ev,str(ac),str(p),str(code),cd)
          mp('magenta',s)
          tosockets_event(g)
          # tosepar(g)
  except Exception,ee:
   mpr('showevt',ee)


def formirgeconbase(gin):
    return
    ap='"'
    z=','
    mp('red','formirgeconbase START')
    if grbciniparams['sqlite']=='no':return
    ip=mgbcpu['host']
    pt='/home/pi/m7/db/'+ip+'/'
    fn='skud_events.db3'
    ptf=pt+fn
    g={}
    g['cmd']='sqlline'
    g['base']=ptf
    g['line']='insert into flog(event,no)values('+ap+gin['event']+ap+z+str(gin['no'])+')'
    mp('red',g['base'])
    mp('red',g['line'])
    try:
     clientftpsrv.send(g,'geconbases')
    except Exception,ee:
     mpr('formirgeconbase')
    # mp('red','formirgeconbase='+str(g))
# formirgeconbase='event': 'open',
# 'code': 'undef',
# 'no': '38029',
# 'kluch': 'undef',
# 'cd': '2017.11.28',
# 'alias': '192.168.0.90',
# 'adrc': 7,
# 'av': 'a',
# 'rst': 'u',
# 'port': 1,
# 'ct': '06:45:25'}
# cd / 06:45:37,703;



def timertolsgsockets(interval):
    while True:
      gevent.sleep(interval)
      l=len(lsgtosockets)
      if l>0:
       g=lsgtosockets.pop(0)
       fsendtoall(g)


def fsendtoall(g):
    # mp('red','fsendall....................')
    for i in range(1,11,1):
     try:
       g['chskds']=mgb['chskds']
       clientftpsrv.send(g)
       # if g.has_key('event'):
       # mp('red','fsendall='+str(g))
       break
     except Exception,ee:
      mpr('fsendall',ee)



def onclftpsrv(sender,g):
    try:
     # mp('red','oncl='+str(g)[0:115])
     if not g.has_key('cmd'):return

     cmd=g['cmd']
     if cmd=='event_model':
        g['cmd']=g['evcmd']
        g['av']='k'
        g['m1s']=stofunc.nowtosec('loc')
        rmp('red','oncl g='+str(g),3)
        todms(g)

     #  rmp('red','oncl='+str(g),3)
     if cmd=='skudrelay':
      rmp('white',str(g),1)
      exerele(g['ac'],g['port'],g['tmr'])
      rmp('white',str(g),1)


     if cmd=='ac_stop':
      if g['state']=='stop':
          ac=int(g['ac'])
          acstop[ac]='dummy'
          glsacrg[ac]='w'
      if g['state']=='poll':
       ac=int(g['ac'])
       acstop[ac]='poll'
       glsacrg[ac]='a'


     if cmd=='toss':
       mgb['lsgtosocks'].append(g)
       # mp('yellow','onclftpsrv='+str(g)[0:115])
    except Exception,ee:
     mpr('onclftpsrv',ee)



def procinfo():
  try:
    # return
    gproc['type']='procinfo'
    tosockets_pollspeed(gproc)
    # mp('red','procinfo='+str(gproc)[0:110])
  except Exception,ee:
   mpr('procinfo',ee)



def timercalcspeed(interval):
    while True:
      gevent .sleep(interval)
      calcspeed()
      # procinfo()
      #

def tosockets_pollspeed(gin):

  try:
      g={}
      g=gin
      # mp('red','gin='+str(gin))
      g['cmd']='toss'
      # g['speed']='undef'
      if gin.has_key('speed'):
       # print ' GIN='+str(gin)
       g['speed']=gin['speed']
      g['subcmd']='streamsock'
      g['who']='skd'
      g['host']=mgb['selfip']
      g['maca']=mgb['maca']
      if g['type']=='acinfo':
       pass
       # mp('magenta','_pollspeed ac='+str(g['ac'])+' /speed='+str(gin['speed']))
      lsgtosockets.append(g)
      # mp('red','_pollspeed='+str(g))

  except Exception,ee:
    mpr('_pollspeed',ee)

def getacinfo(ac):
 try:
      g={}
      g['ac']=ac
      # mp('red','getacinfo start')
      gbac[ac]['prog_id'] =chskd.prog_id(ac)
      gbac[ac]['prog_ver']= chskd.prog_ver(ac)
      gbac[ac]['ser_num'] = chskd.ser_num(ac)
      gbac[ac]['keys_info']=chskd.keys_info(ac)
      gbac[ac]['events_info']=chskd.events_info(ac)
      g['prog_id']    =gbac[ac]['prog_id']
      g['prog_ver']   =gbac[ac]['prog_ver']
      g['ser_num']    = gbac[ac]['ser_num']
      g['keys_info']  = gbac[ac]['keys_info']
      g['events_info']=gbac[ac]['events_info']
      # mp('red','INFOAC='+str(g))
      return g
 except Exception,ee:
   mprs('getacinfo.error ac='+str(ac),ee)


def formir_speed(num,sp):
  try:
   g={}
   g['speed']=str(sp)
   g['num']=str(num)
   g['type']='speed'

   tosockets_pollspeed(g)
   for ac in addrs:
    g=getacinfo(ac)
    if g==None : break
    # rmp('red','formir_speed='+str(g),3)
    g['type']='acinfo'
    g['ac']=str(ac)
    g['state']=acstop[ac]+','+glsackpx[ac]
    # g['kpx']=skdparams['ac_start']
    gevent.sleep(0.5)
    tosockets_pollspeed(g)

    # g['prog_id']    =gbac[ac]['prog_id']
    # g['prog_ver']   =gbac[ac]['prog_ver']
    # g['ser_num']    = gbac[ac]['ser_num']
    # g['keys_info']  = gbac[ac]['keys_info']
    # g['events_info']=gbac[ac]['events_info']



  except Exception,ee:
    mpr('formir_speed',ee)



def calcspeed():
  try:
    m1=gbspeed['m1']
    m2=stofunc.nowtosec('loc')
    d=m2-m1
    num=gbspeed['num']
    sp= gbspeed['num'] /d
    gbspeed['num']=0
    gbspeed['m1']=stofunc.nowtosec('loc')
    # mp('red','calcspeed num='+str(num)+' /d='+str(d)+'/sp='+str(sp)+' /m1='+str(m1)+'/m2='+str(m2))
    formir_speed(num,sp)

  except Exception,ee:
   mpr('calcspeed',ee)


def readskdparams(pt):
  try:
   # rmp('red','STORE='+mgbcpu['store'],15)
   pt='/home/pi/m7/skud/db/skud_params.db3'
   if os.path.isfile(pt):
    fs=os.path.getsize(pt)
   if not os.path.isfile(pt) or fs==0:
    g=readskdparamsmsf(mgbcpu['store'])
    mp('red','readskdparams='+str(g))
    return g
   vb=geconfunc.reconnectbase(pt)
   g={}
   s='select * from params'
   vb.cursor.execute(s)
   for row in vb.cursor:
    k=row['key'].strip()
    v=row['value'].strip()
    g[k]=v
    # mp('red','readskdparams g='+str(g))
   return g

  except Exception,ee:
   mpr('readskdparams',ee)
   return


def readskdparamsmsf(pt):
  try:
    ptf=pt+sep+'config'+sep+mgbcpu['host']+sep+mgbcpu['ch']+sep+'skdparams.ini'
    rmp('red','readskdparamsmsf ?????????????????????????????????????',10)
    rmp('red','readskdparams ptf='+ptf,5)
    # rmp('yellow','readskdparams pt='+pt,3)
    inp=open(ptf,'r')
    ls=inp.readlines()
    mp('red','readskdparams ls='+str(ls))
    g=geconfunc.lstogls(ls)
    gg={}
    for k in g:
     # mp('white','k='+k[0:1])
     k=k.strip()
     if k[0:1]<>'#':
         v=g[k]
         lss=v.split('#')
         v=lss[0].strip()
         # mp('red','??k'+'='+v)
         gg[k]=v
         mp('white',str(gg))
    rmp('red','readskdparams gg='+str(gg),3)
    return gg
  except Exception,ee:
    mprs('readskdparams',ee)
    sys.exit(99)

def setacparams(lac):
    for ac in lac:
     k=str(ac)+'.count'
     glsce[k]=0
     glsacrg[ac]=skdparams['ac_start']
     glsackpx[ac]=skdparams['ac_start']
     mp('red','tsetacparams='+str(glsacrg[ac]))
     gbac[ac]={}
     acstop[ac]='poll'


# ============================================================

def pcrconfig_ip():
   try:
    g={}
    mp('red','pcrconfig_ip start')
    md=mgbcpu['host']
    g['md']=md+sep+mgbcpu['ch']
    geconfunc.crm7dir(g)
    md=g['md']
    mp('red','pcrconfig_ip 1 md='+md)
    g={}
    md= md=mgbcpu['host']+sep+mgbcpu['ch']+sep+'work'
    g['md']=md
    mp('red','pcrconfig_ip 2 md='+g['md'])
    geconfunc.crm7dir(g)
   except Exception,ee:
    mprs('pcrconfig_ip',ee)

def pcrconfig_ac(ac):
   try:
    rmp('lime','pcrconfig_ac='+str(ac),1)
    g={}
    md=mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)
    g['md']=md    # mp('red','pcrconfig_ac md='+md)
    rc=geconfunc.crm7dir(g)
    ptf=mgbcpu['store']+'config'+sep+mgbcpu['host']+sep+mgbcpu['ch']+sep+'acs.ini'
    outp=open(ptf,'a')
    # else:
    #   outp=open(ptf,'w')
    outp.write(str(ac)+'\n')
    outp.flush()
    outp.close()

    md=mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'info'
    g={}
    g['md']=md
    mp('magenta','pcrconfig_ac='+md)
    rc=geconfunc.crm7dir(g)

    md=mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'trace'
    g={}
    g['md']=md
    mp('magenta','pcrconfig_ac='+md)
    rc=geconfunc.crm7dir(g)


    md=mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'errors'
    g={}
    g['md']=md
    mp('magenta','pcrconfig_ac='+md)
    rc=geconfunc.crm7dir(g)

    mp('magenta','pcrconfig_ac rc='+str(rc))
    md=mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'watch'
    g={}
    g['md']=md
    rc=geconfunc.crm7dir(g)

    mp('magenta','pcrconfig_ac rc='+str(rc))
    md=mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'images'
    g={}
    g['md']=md
    rc=geconfunc.crm7dir(g)

    md=mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'ports'
    g={}
    g['md']=md
    # mp('red','ZZZ='+md)
    rc=geconfunc.crm7dir(g)
    ptf=mgbcpu['store']+sep+'config'+sep+md+sep+str(ac)+'.ini'
    if os.path.isfile(ptf):
     return

    # outp=open(ptf,'a')
    # for i in range(1,9,1):
    #   s='out,room '+str(ac)+'_'+str(i)+',1'
    #   outp.write(s+'\n')
    # outp.flush()
    # outp.close()
   except Exception,ee:
     mpr('pcrconfig_ac',ee)


def toworktxt(ls):
  try:
      tz=';'
      if ls==None:return
      # mp('magenta','toworktxt ls='+str(ls))
      pt=mgbcpu['store']+'config'+sep+mgbcpu['host']+sep+mgbcpu['ch']+sep+'work'+sep
      fn='work.txt'
      ptf=pt+fn
      # mp('yellow','')
      outp=open(ptf,'w')
      lss=[]
      if len(ls)==0: # CONTROLLERS LIST IS EMPTY
          cd=myfunction.mydatezz()
          ct=myfunction.mytime()[0:8]
          ct=myfunction.zerol(ct,8)
          line=';# CONTROLLERS LIST IS EMPTY'
          s=cd +' '+ct+tz+' '+line+tz
          outp.write(s)
          outp.flush()
          outp.close()
          rmp('red','toworktxt='+line,10)
          return
      sc=''
      for c in ls:
       sc=sc+str(c)+','

      cd=myfunction.mydatezz()
      ct=myfunction.mytime()[0:8]
      ct=myfunction.zerol(ct,8)
      s=cd +' '+ct+tz+' '+sc+tz
      outp.write(s)
      outp.flush()
      outp.close()
      mp('magenta','toworktxt='+s+' ctyp='+mgbcpu['ctyp'])
  except Exception,ee:
    mpr('ftptowork',ee)



def slavadttomydt(dt):
    try:
      dt.year=dt.year+2000
      d='%.4d.%.2d.%.2d'% (dt.year, dt.month,dt.day)
      t= '%.2d:%.2d:%.2d' %(dt.hour, dt.minute, dt.second)
      return d+' '+t
    except Exception,ee:
     mpr('gonscovertdt',ee)



def mydt_to_tssdt():
   try:
     tssdt=cgonsdt()
     # return tssdt
     cd=myfunction.mydatezz()
     ct=myfunction.mytime()[0:8]
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
   except Exception,ee:
     mpr('mydt_to_tssdt',ee)



def  pwr_errortimecont(ac,dt):
   try:
     if mgbcpu['ctyp']=='virtual':return
     mp('red','get_timecont ERROR TIME ON='+str(ac)+' /dt='+dt)
     return
     # appdir=myfunction.getappdir()
     pt='/home/pi/tss/linkobj/out/'+'errortimecont_'+str(ac) #suda23
     outp=open(pt,'w')
     cd=myfunction.mydatezz()+' '+myfunction.mytime()
     s='ac='+str(ac)+',dt='+str(dt)+' ,rbc datetime='+cd+'\n'
     outp.write(s)
     outp.flush()
     outp.close()
   except Exception,ee:
    mpr('pwr_errortimecont',ee)


def towatch(ac,delta):
  try:
   pt=mgbcpu['store']+'config'+sep+mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'watch'+sep
   fn='watch.txt'
   ptf=pt+fn
   outp=open(ptf,'a')
   dt=geconfunc.mydatezz()+' '+geconfunc.mytime()[0:8]
   s=dt+';'+'ac='+str(ac)+' delta='+str(delta)
   outp.write(s+'\n')
   mp('red','towatch s='+s+' /ptf='+ptf)
   outp.flush()
   outp.close()
  except Exception,ee:
   mpr('towatch',ee)

def get_timecont():
  try:
   if mgbcpu['ctyp']=='virtual':return
   # mp('yellow','get_timecont 00000000000000000000')
   if m7func.mgb['busy'] : return
   # mp('yellow','get_timecont 1111111111111111111111')
   for ac in addrs:
    try:

     chskd=mgbcpu['chskd']
     dt=chskd.get_dt(ac)
     dt=slavadttomydt(dt)
     delta=abs(int(checkdt(dt)))
     s='  ac=%4s ,dt=%14s ,delta=%2s' %(ac,dt,delta)
     if delta<=int(skdparams['clockdiff']):
      mp('lime','get_timecont'+s)
     else:
      mp('red','get_timecont'+s)
      towatch(ac,int(delta))
      dt=mydt_to_tssdt()
      chskd.set_dt(ac,dt)
      return
      dt=chskd.get_dt(ac)
      gevent.sleep(0.5)
      dt=slavadttomydt(dt)

    except Exception,ee:
      mprs('get_timecont 2',ee)

  except Exception,ee:
   mpr('get_timecont 1',ee)




def get_timecont_old():
  try:
   mp('yellow','get_timecont 00000000000000000000')
   if m7func.mgb['busy'] : return
   mp('yellow','get_timecont 1111111111111111111111')
   for ac in addrs:
    try:
     chskd=mgbcpu['chskd']
     dt=chskd.get_dt(ac)
     # gevent.sleep(0.5)
     dt=slavadttomydt(dt)
     lss=dt.split(' ')
     d=lss[0]
     ls=d.split('.')
     y=ls[0]
     if y<'2017':
      ndt=mydt_to_tssdt()
      chskd.set_dt(ac,ndt)
      pwr_errortimecont(ac,dt)
     else:
      # mp('cyan','calldelta=')
      delta=abs(int(checkdt(dt)))
      # mp('red','delta='+str(delta)+' /ac='+str(ac))
      if delta<7:
       ac=str(ac)
       dt=str(dt)
       delta=str(delta)
       s='  ac=%4s ,dt=%14s ,delta=%2s' %(ac,dt,delta)
       mp('lime','get_timecont'+s)
      else:
       mp('red','get_timecont'+s)
       try:
        towatch(ac,int(delta))
        dt=mydt_to_tssdt()
        chskd.set_dt(ac,dt)
        dt=chskd.get_dt(ac)
        gevent.sleep(0.5)
        dt=slavadttomydt(dt)
       except Exception,ee:
        mpr('get_timecont AFTER CHECKDT ',ee)
    except Exception,ee:
     mpr('get_timecont',ee)
     dt='UNDEFINED'
     rmp('yellow','get_timecont ac='+str(ac)+'  dt='+str(dt),5)

  except Exception,ee:
   mpr('get_timecont',ee)

def checkdt(dt):
  try:
    # return
    # mp('red','checkdt='+str(dt))
    ux1=stofunc.nowtosec('loc')
    ux2=int(geconfunc.kosta_dttoux(dt))
    delta=ux1-ux2
    return delta
  except Exception,ee:
    mpr('checkdt',ee)


def timerworktxt(interval):

    while True:
      gevent.sleep(interval)
      toworktxt(addrs)
      get_timecont()

      # if len(addrs)>0:
      #  ac=random.choice(addrs)
      #  pdeleteacfromaddrs(addrs,ac)

def exsql(vb,s):
   try:
     mp('blue','exsql='+s)
     vb.db.execute(s)
     mp('lime','exsql='+s)
   except Exception,ee:
    mprs('exsql',ee)

def testsql():
 try:

  g={}
  g['cmd']='sqlline'
  g['base']='/home/pi/m7/db/192.168.0.90/skud_events.db3'
  g['line']='insert into flog(event,no)values("test",14459);'
  # vb=geconfunc.reconnectbase(g['base'])
  vb=geconfunc.bropenbase('r',g['base'])
  exsql(vb,'end;')

  for i in range(1,3,1):
   exsql(vb,'BEGIN ;')
   exsql(vb,g['line'])
   exsql(vb,'COMMIT;')
   # vb.db.commit()
    # clientftpsrv.send(g,'geconbases')
   # except Exception,ee:
   #  mpr('testsql open exe',ee)
  vb.db.close()
 except Exception,ee:
  mpr('testsql',ee)

def readstorageini():
  try:
    appdir=geconfunc.getmydir()
    pt=appdir+'storage.ini'
    inp=open(pt,'r')
    ls=inp.readlines()
    g= geconfunc.lstogls(ls)
    return g
  except Exception,ee:
   print 'readstorageini ee='+str(ee)
   sys.exit(99)

def toinfo(g,ac):
 try:
  ip=mgbcpu['host']
  ch=mgbcpu['ch']
  ac=str(ac)
  mp('red','g='+str(g))
  pt='/home/pi/m7/config/'+ip+'/'+ch+'/'+ac+'/info/info.txt'
  outf=open(pt,'a')
  outf.write(str(g)+'\n')
  outf.flush()
  outf.close()
 except Exception,ee:
  mpr('toinfo',ee)

def checkaclist():
    s=''
    if len(addrs)==0:
       s='LEN ADDRS=0'
    if len(addrs)>16:
     s='LEN ADDRS>16'
    for ac in addrs:
     if ac==0:
      s='ac=0. IT IS BAD AC'
      addrs.remove(ac)

    if s<> '':
     rmp('red','ABORT M7 aaaaaaaaaaaaaaaaa=0aa=0aa=0a '+s,50)
     toworktxt([])
     sys.exit(99)

def getbidmacabidch():
  try:
    g={}
    if skdparams['shema']=='msf':
     g['bidmaca']='-1'
     g['bidch']='-1'
     return g

    mp('red','getbpmacabpch maca='+mgb['maca'])
    mp('red','getbpmacabpch ch='+mgbcpu['ch'])
    pt='/home/pi/m7/skud/db/skud_units.db3'
    vb=geconfunc.reconnectbase(pt)
    maca=mgb['maca']
    ch=mgbcpu['ch']
    ap='"'
    mp('red','ch='+ch+'>')
    s='select rbc.myid,ch.myid from rbc,ch where rbc.maca='+ap+maca+ap+' and ch.ch='+ap+ch+ap
    mp('red','xxxxs='+s)
    vb.cursor.execute(s)
    for row in vb.cursor:
     # g['bidmaca']=int(row['rbc.myid'])
     g['bidmaca']=int(row[0])
     g['bidch']=int(row[1])
     # g['bidch']=int(row['ch.myid'])
    return g



    ch=mgbcpu['ch']
    ap='"'
    s='select * from rbc where maca='+ap+maca+ap+' limit 1'
    mp('red','getbidmacabidch='+s)
    vb.cursor.execute(s)
    for row in vb.cursor:
     g['bidmaca']=row['myid']

    s='select * from ch where ch='+ap+ch+ap+' limit 1'
    mp('red','getbidmacabidch='+s)
    vb.cursor.execute(s)
    for row in vb.cursor:
     g['bidch']=row['myid']
    return g
  except Exception,ee:
   mpr('getbidmacabidch',ee)


def getaddrs():
   if not skdparams.has_key('findacl'):return None
   if skdparams['findacl']<>'base':return None

   try:
       pt='/home/pi/m7/skud/db/skud_units.db3'
       vb=geconfunc.reconnectbase(pt)
       g={}
       s='select * from acl where bp='+str(mgbcpu['bidch'])
       rmp('red',s,20)
       vb.cursor.execute(s)
       ls=[]
       for row in vb.cursor:
        ls.append(int(row['ac']))
       return ls
   except Exception,ee:
     mpr('getaddrs',ee)

    # return[7] #suda

tasks=[]
mgb={}
mgb['lsgtosocks']=[]
mgbcpu={}
# mgbcpu=readstorageini()
g=gsfunc.gonsgetp()
mgbcpu['ch']=g['-ch']
mgbcpu['ctyp']=g['-ctyp']
mp('red','g='+str(g))
mgbcpu['store']='/home/pi/m7/'



lsgtosockets=[]
acstop={}
gproc={}
gbac={}
glsacrg={}
glsackpx={}
glsce={}
skdparams={}
grbciniparams={}
gbspeed={}
gbspeed['num']=0
gbspeed['m1']=stofunc.nowtosec('loc')
gbspeed['m1']=stofunc.nowtosec('loc')
getplatform()
sos=mgbcpu['os']
# geconfunc.initlog('/home/pi/tss/m7_storage/')
ip=mgb['host']
ptlog='/home/pi/m7/tsslogs/'+ip
geconfunc.initlog(ptlog)
# rmp('red','CALL sqlite===============================================',30)

grbciniparams=geconfunc.readrbciniparams(ip)
rmp('lime','sqlite='+str(grbciniparams['sqlite']),1)
mp('red','start')
chskd={}
chskd=pcreatech(mgbcpu['ch'])
# ch=mgbcpu['chpcr']
mgb['regim']='real'
mgbcpu['host']=mgb['host']
mgbcpu['chskd']=chskd
mp('yellow','mgbcpu='+str(mgbcpu))
# mp('red','mgbcpu='+str(mgbcpu))
m7func.mgbcpu=mgbcpu
skdparams=readskdparams(mgbcpu['store'])
rmp('red','skdparams='+str(skdparams),10)
# sys.exit(99)
try:
     h='tcp://127.0.0.1:5555'
     ch=mgbcpu['ch']
     nm='m7mon_'+str(ch)
     clientftpsrv=ccftpsrv(h,nm)
     ccftpsrv.on_receive = onclftpsrv
     task= gevent.spawn(clientftpsrv.run)
     tasks.append(task)
     rmp('magenta','h='+h+' /NM='+nm,5)


except Exception,ee:
 mpr('MAIN clientftpsrv',ee)
 sys.exit(99)

mp('red','BEFORE CALL getbidmacabidch')
g=getbidmacabidch()
# mp('red','?????????g='+str(g))
mgbcpu['bidmaca']=g['bidmaca']
mgbcpu['bidch']=g['bidch']
mp('red','bidmaca='+str(mgbcpu['bidmaca'])+' / bidch='+str(mgbcpu['bidch']))
mp('red','AFTER CALL getbidmacabidch')
addrs=[]
if   len(addrs)==0 and mgbcpu['ctyp']=='real':
 addrs=getaddrs()  # sudaa
 rmp('yellow','>>>>>>>>>>>>>>>>>>>>>>>>>>>>  CALL FINDAC',15)
 if addrs==None:
  rmp('magenta','>>>>>>>>>>>>>>>>>>>>>>>>>>>>  START FINDAC',10)
  addrs=findac()
 rmp('LIME','GGGGGGGGGGG'+str(addrs),20)
 checkaclist()
 toworktxt(addrs)
 try:
  setacparams(addrs)
  # chskd.flush_input()
  tasks.append(gevent.spawn(poll_event)) #suda

 except Exception,ee:
  mpr('main NEW POINT  1   ',ee)

else:
  pass
 # addrs=[7,8,16,37]
mp('red','point4')
ptf=mgbcpu['store']+'config'+sep+mgbcpu['host']+sep+mgbcpu['ch']+sep+'acs.ini'
geconfunc.mydeletefile(ptf)
mp('red','point4 11111111111111111111111111111111111111111111111111111111')
mp('red','addrs='+str(addrs))
for ac in addrs:
    try:
        if mgbcpu['ctyp']=='real':
            pcrconfig_ac(ac)
            pginfo=m7func.get_acproginfo(chskd,ac)
            mp('red','pginfo ac='+str(ac)+'=='+str(pginfo))
            toinfo(pginfo,ac)
            dt=mydt_to_tssdt()
            chskd.set_dt(ac,dt)
            dt=chskd.get_dt(ac)
            # gevent.sleep(0.5)
            dt=slavadttomydt(dt)
    except Exception,ee:
     mprs('main getproginfo',ee)
mp('red','point5')
m7func.mgbcpu['addrs']=addrs
rmp('red','    FIND   OK='+str(addrs),5)
m7func.mgb['timerimu']=True
setacparams(addrs)



task=gevent.spawn(timertolsgsockets,0.001)
tasks.append(task)

task=gevent.spawn(timercalcspeed,10)
tasks.append(task)


# task=gevent.spawn(timertestbb,1)
# tasks.append(task)

task=gevent.spawn(timer1,1)
tasks.append(task)
m7func.addrs=addrs

m7func.mgb['timerimu']=True

task=gevent.spawn(timerworktxt,10)
tasks.append(task)
#


gevent.joinall(tasks)





