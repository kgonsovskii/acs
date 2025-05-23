# -*- coding: utf-8 -*-
import sys,time,os
import gevent,traceback
import libtssacs as acs
import stofunc,gsfunc
# import libtsscmk as cmk
import gfunc,gfunc
import pickle
from os import path, sep
from colorama import init, Fore



def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mp(c,txt):
 try:
  t=gfunc.mytime()
  gfunc.mpv(c,'SCS_DEMO. '+txt+'  /t='+t)
  # print
 except Exception as ee:
   print ('mp ee='+str(ee))

def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def get_event(addr, is_complex):
    try:
        gevent.sleep(0.01)
        f=True
        # print 'get_event addr=',addr
        return ch.get_event(addr,f)
    except Exception as ee:
        print ('get_event new ERROR:',ee,' ADDR=',addr)
        gevent.sleep(1)

def x_dumppic(maca,ch,evt):
   try:
    ap='"'
    z=','
    appdir=gfunc.getmydir()
    ptf=appdir+'db'+sep+'vev.db3'
    vb=gfunc.bropenbase('r',ptf)
    v=pickle.dumps(evt)
    cd=gfunc.mydatezz()
    ct=gfunc.mytime()[0:8]
    ct=gfunc.zerol(ct,8)
    s='insert into vev(maca,ch,cd,ct,evt)values('+\
      ap+maca+ap+z+\
      ap+ch+ap+z+ \
      ap+cd+ap+z+\
      ap+ct+ap+z+ \
      ap+v+ap +\
      ')'
    vb.db.execute(s)
    vb.db.commit()
    vb.db.close()
   except Exceptionas as ee:
     mpr('x_dumppic',ee)

def dumppic(ptf):
  try:
    return
    with open(ptf, 'wb') as f:
        pickle.dump(lsdp, f)
        mp('red','dumppic l='+str(len(lsdp))+' /ptf='+ptf)
  except Exception as ee:
   mpr('dumppic',ee)

def tovev(evt):
 try:
   return
   if not mgb.has_key('vev'):return
   maca=mgb['maca']
   ch=mgb['ch']
   x_dumppic(maca,ch,evt)
   return
   appdir=gfunc.getmydir()
   ch=mgb['chs']
   ptf=appdir+'vev/'+ch+'.log'
   lsdp.append(evt)
   # dumppic(ptf)
   # x_dumppic(mgb['maca'],mgb['ch'],evt)

 except Exception as ee:
  mpr('tovev',ee)

def formirtestk():
 try:
  for ac in addrs:
      kl='00000274365A'
      code=41170522
      key = acs.Key()
      key.code =code
      key.mask = [1,2,3,4,5,6,5,7,8]
      key.pers_cat = 16
      mgb['chskd'].add_key(ac,key)
  return key
 except Exception as ee:
  mpr(formirtestk)



def x0formirtk(evt):
  try:
    key = acs.Key()
    key.code = evt.code
    key.mask = [1,2,3,4,5,6,5,7,8]
    key.pers_cat = 1
    return key
  except Exception as ee:
   mpr('x0formirtk',ee)

def x0addkey(ac):
  try:

    if len(mgb['lstk'][ac])<=0:return
    # mp('red','x0addkey 111111111111111111111111111111111111111111111111111111')
    for t in mgb['lstk'][ac]:
     mp('lime','t='+str(t))
     mgb['chskd'].write_all_keys(ac,mgb['lstk'][ac])
     mp('red','x0addkey 222222222222222222222222222222222222222222222222222222')
  except Exception as ee:
   mprs('x0addkey',ee)

def poll_event():
    while True:
        for addr in addrs:
            # x0addkey(addr)
            gevent.sleep(0.1)
            evt = get_event(addr,True)
            if evt is not None:
                gevent.sleep(0.1)
                print ('evt==',evt)
                # mp('blue','poll_event='+str(evt))
                tovev(evt)
                if isinstance(evt, acs.EventKey):
                    mp('red','KEY evt='+str(evt))
                    code=evt.code
                    kl=str(gfunc.xkeytos(code))
                    ac=evt.addr
                    # if evt.is_complex:
                    mp('red','BADKEY ac='+str(ac)+' kl='+kl+' /code='+str(code))
                    t=x0formirtk(evt)
                    mgb['lstk'][ac].append(t)
                    # myaddkey(addr,evt.code,[1,2,3,4,5,6,7,8])

def x_addkey():
    while len(mgb['lskyes'])>0:
     t=mgb['lskyes'].pop(0)
     ac=t.addr
     mgb['chskd'].write_all_keys(ac, keys)




def myaddkey(ac,xkey,ms):
   try:
    keys = []
    for i in range(1,2,1):
        key = acs.Key()
        key.code = xkey
        key.mask = ms
        key.pers_cat = 16
        keys.append(key)
        mgb['lskyes'].append(key)
        # mp('yellow','myaddkeykeys='+str(keys))
   except Exception as ee:
    mprs('myaddkey',ee)


def exerele(ac,port,tmr):
   try:
     tme=int(tmr*2.1)
     tme=40
     mgb['chskd'].relay_on(ac,port,tme,save_duration=True)
     mp('red','exerele ac='+str(ac)+' /port='+str(port)+' / tsec='+str(tmr))
   except Exception as ee:
     mprs('exerele',ee)

def find_key():
    while True:
        # print 'find_key:', ch.find_key(addr, 0x112233445566)
        gevent.sleep(1)

def fdel_all(ch,ac):
    ch.del_all_keys(ac)

def fformirkeys(n):
   ls=[]
   mp('yellow','fformirkeys n='+str(n))
   for i in range(1, n+1,1):
    key = acs.Key()
    key.code = i + 1
    key.mask = [1,2,3,4,5,6,5,7,8]
    key.pers_cat = 1
    ls.append(key)
   return ls
    # try:
    #  ch.add_key(addr, key)
    # except Exception,ee:
    #  print 'ee=',ee


def faddall(ls):

    rmp('lime','faddall START===========================================',1)
    m1=stofunc.nowtosec('loc')
    for t in ls:
     gevent.sleep(0.0001)
     try:
         mgb['ch'].add_key(addr,t)
         # print t
         # mp('lime','faddall='+str(t))
     except Exception as ee:
      mgb['abend'].append(t)
      mprs('faddall',ee)

     m2=stofunc.nowtosec('loc')
    d=m2-m1
    rmp('red','DELTA='+str(d),1)
    for t in mgb['abend']:
     mp('red','abend='+str(t))

def execmd(g):
   try:
    mp('lime','execmd  g='+str(g))
    for k in g:
     v=str(g[k])+'>'
     mp('red','k='+k+' /v='+v)
     if g['cmd']=='addall':
      mp('red','tttttttttttttttttttttttttut')
      g['count']=int(g['count'])
      ls=fformirkeys(g['count'])
      faddall(ls)




    if g['cmd']=='writeall':
     mp('red','tttttttttttttttttttttttttut')
     g['count']=int(g['count'])

     # fformirkeys(g['count'])
     ls=fformirkeys(g['count'])

     m1=stofunc.nowtosec('loc')
     rmp('red','WRITEALL START',1)
     mgb['ch'].write_all_keys(addr, ls)
     rmp('red','WRITEALL END',1)
     m2=stofunc.nowtosec('loc')
     d=m2-m1
     rmp('red','DELTA='+str(d),1)
    # readallkeys()
   except Exception as ee:
    mpr('execmd',ee)

def readallkeys():
    try:
     mp('yellow','CALL READ ALL KEYS')
     ls=mgb['ch'].read_all_keys(addr)
    except Exception as ee:
      mpr('readallkeys',ee)


def readcmd(pt):
    inp=open(pt,'r')
    ls=inp.readlines()
    g=gfunc.lstogls(ls)
    inp.close()
    gfunc.mydeletefile(pt)
    # mp('lime','readcmd ls='+str(ls))
    # mp('lime','readcmd  g='+str(g))
    return g

def timertest(interval):
    while True:
     gevent.sleep(interval)
     appdir=gfunc.getmydir()
     pt=appdir+'acs_demo.cmd'
     mp('cyan','timertest pt='+pt)
     for ac in addrs:
         lsxx=mgb['chskd'].read_all_keys(ac)
         mp('yellow','ac='+str(ac)+' /lsxx='+str(lsxx))
         keysinfo=mgb['chskd'].keys_info(ac)
         mp('lime', 'ac=' + str(ac) + ' /keysinfo=' + str(keysinfo))
         progver = mgb['chskd'].prog_ver(ac)
         mp('lime', 'ac=' + str(ac) + ' /progver=' + str(progver))
         events = mgb['chskd'].events_info(ac)
         mp('cyan', 'ac=' + str(ac) + ' /events=' + str(events))
         # if os.path.isfile(pt):
         #  g=readcmd(pt)
         #  execmd(g)

def setrbcdog(n):
    pass
    '''
    try:
        cmk.write_watchdog(n)
        rmp('lime','SETRBCDOG ='+str(n),5)
    except Exception as ee:
        mpr('main  watchdog n='+str(n),ee)
  '''




def formirmgbaddrs(sa):
    ls1=sa.split(',')
    ls=[]
    for ac in ls1:
     try:
      ls.append(int(ac))
     except Exception as ee:
      mprs('formirmgbaddrs',ee)
    return ls

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

def addone(ac,t):
   for i in range(1,6,1):
    try:
     ch.add_key(ac,t)
     mp('yellow', 'ADDONE t=' + str(t))
     return True
    except Exception as ee:
     mp('white','addone ee='+str(ee))
     gevent.sleep(0.15)
   return False

def addmass(ac,ls):
    ii=0
    cerr=0
    lmt1=10
    while  len(ls)>0:
     t=ls[0]
     rc=addone(ac,t)
     if rc==True:
        ii=ii+1
        ls.pop(0)
        if ii>=lmt1:
         gevent.sleep(0.5)
         ii=0
         mp('cyan','SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS')

# ===========mgbs==================================================================================
init(autoreset=True)
mgb={}
mgb['addrs']=None
mgb['lstk']={}
lsdp=[]
setrbcdog(0)
gp=gsfunc.gonsgetp()
mgb['chtyp'] = gp['-ctyp']
if 'chtyp' in gp.keys():
  mgb['ctyp']= gp['-chtyp']
  mgb['chtyp']=gp['-ctyp']
if '-ch'in gp.keys():
 mgb['chs']=gp['-ch']
if 'addrs' in gp.keys():
 sa=gp['-addrs']
 mgb['addrs']=formirmgbaddrs(sa)
# mgb['addrs']=[171]
 #addrs=[171]
if '-vev' in gp.keys():
    mgb['vev']=gp['-vev']
mgb['maca']=gfunc.getfromglobals('maca')
mgb['ch']=mgb['chs']

tasks = []
keys = []
mp('yellow','mgb='+str(mgb))
mp('lime','chtyp='+mgb['chtyp'])
mp('lime','chs='+mgb['chs'])

if 'chtyp' in mgb.keys() and 'chs' in mgb.keys():
 if mgb['chtyp']=='422':
  ch = acs.ChannelRS422()
 if mgb['chtyp']=='ip':
   rmp('cyan','chs='+str(mgb['chs']),1)
   ch = acs.ChannelTCP(mgb['chs'])
   if mgb['chtyp']=='tty':
       ch = acs.ChannelRS232(mgb['chs'])
# try:
#     ch.flush_input()
# except:pass
ch.baudrate=19200
ch.response_timeout=0.1
mgb['chskd']=ch


       # ch = acs.ChannelRS232('/dev/ttyUSB6')
# ch = acs.ChannelRS422()   # 7,8
# ch = acs.ChannelTCP('192.168.0.96')
try:
 ch.flush_input()
except:pass
ch.baudrate=19200
ch.response_timeout=0.1
ac=171
addr=171
ls=fformirkeys(10000)
ch.del_all_keys(ac)
gevent.sleep(5)
m1=stofunc.nowtosec('loc')
addmass(ac,ls)
m2=stofunc.nowtosec('loc')
d=m2-m1
mp('lime', 'd=' + str(d))
sys.exit(93)



gevent.sleep(3)
m2=gfunc.mymarker()

mp('lime', 'CALL READ ALL KEYS ================================')
for i in range (1,6,1):
 try:
  ls=ch.read_all_keys(171)
  mp('white', 'ls=' + str(ls))
 except Exception as ee:
   gevent.sleep(1)
   mprs('main x ',ee)

for t in ls:
  mp('lime','AFTER t='+str(t))
sys.exit(93)
a1=0
a2=254
als=[]
addrs,als=alfindaddrs(a1,a2,als)


#mp('lime','als='+str(als))
for g in als:
 ac=int(g['ac'])
 dt=g['dt']
 mdt=gfunc.al_209dt(ac,dt)
 mp('lime','mdt='+str(mdt))
 acd=mdt['acdelta']
 dt=mdt['dt']
 mp('magenta','ac='+str(ac)+' ACDELTA='+str(acd)+',dt='+str(dt))
sys.exit(93)


# try:
#  ch.flush_input()
# except Exception,ee:
#  mpr('main flush_input',ee)
# addrs =[7]
# addr=7
# ch = acs.ChannelRS422()
# ch.response_timeout=0.1
# ch.flush_input()
# ch.baudrate=19200
# mp('red','call FIND addrs')
# addrs = ch.find_addrs()
# rmp('yellow','set addrs='+str(addrs),5)
# sys.exit(99)
#

mp('lime','mgb[addrs]='+str(mgb['addrs']))
if mgb['addrs'] != None and  len(mgb['addrs']) != 0:
   addrs=mgb['addrs']
   ch.flush_input()
   rmp('yellow','CALL FIND ADDRS',10)
   rmp('lime','AFTERT CALL FIND ADDRS='+str(addrs),10)
else:
  rmp('yellow','CALL FIND ADDRS',10)
  addrs = ch.find_addrs()
 # addrs=[171]
  mgb['addrs']=addrs
  #mgb['addrs'] = [171]

  rmp('lime','AFTERT CALL FIND ADDRS='+str(addrs),10)
  # sys.exit(98)

   #
   # print 'addrs=',addrs
   # print 'AFTER  FIND ADDRS =========================='+str(addrs)
   # if len(addrs)==0:
   #   print 'ADDRS=0 --------------------------> EXIT '
   #   sys.exit(99)
# print

for ac in addrs:
   try:
      mgb['lstk'][ac]=[]
      mp('yellow','mgb[lask]='+str(mgb['lstk']))
      # mp('lime', 'ac='+str(ac)+' prog_ver='+str(ch.prog_ver(ac))) suda24
      # mp('lime', 'ac='+str(ac)+' prog_id='+str(ch.prog_id(ac)))suda27

      # exerele(ac,1,5)

      # exerele(ac,3,20)
      # exerele(ac,8,20)
      # gevent.sleep(10)
      # formirtestk()
      mp('white','start read all===================')
      # lsk=mgb['chskd'].read_all_keys(ac) suda24
      lsk=[]
      # for t in lsk: suda24
      #  kl=str(gfunc.xkeytos(t.code))
      #  mp('white','code='+str(t.code)+ '/ kl='+kl)
      # gevent.sleep(10)
   except Exception as ee:
    mpr('main 1',ee)
    # sys.exit(99)
# sys.exit(99)

 # ch.write_all_keys(addr, keys)

# ls=ch.read_all_keys(addr)
# print 'read_all_keys:',' / L=' ,len(ch.read_all_keys(addr))

# for s in ls:
#  print s
task=gevent.spawn(timertest,10)
tasks.append(task)
print ('5555555555555555555555555555555555555555555555555555555555555555555555555')
# ac=177
# ls=ch.read_all_keys(ac)
# print ls

tasks.append(gevent.spawn(poll_event))



print ('?????????????????????????????')
gevent.joinall(tasks)
# . ac=7 kl=000100030F8D /code=4295167885
# python acs_demo.py -ch 192.168.0.96 -chtyp ip -ctyp ip