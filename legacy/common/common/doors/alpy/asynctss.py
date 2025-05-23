#!/usr/bin/python3
# -*- coding: utf-8 -*-
import asyncio,sys,time,traceback
import gfunc
import libtssacs as acs
import stofunc
import psycopg2


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='dms'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
    #redlog(txt)
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



async def astimer10s(interval):
    while True:
     await asyncio.sleep(interval)
    # mp('white','astimer10s ??????????????????????')
     #asyncio.ensure_future(frak0())

async def astimer1s(interval):
    while True:
     await asyncio.sleep(interval)
     tscd=gfunc.mytscd()
     txt = gfunc.mytime()

     s = 'insert into tss_atest(txt)values(' + \
         ap + txt + ap + \
         ')'
    # mp('cyan','s='+s)
     for i in range(5):
      pgsbox.append(s)
     #mp('yellow','s='+s)
     #mp('cyan', 'astimer1s  ??????????????????????')


def crip(ch):
 atp=0
 while True:
   try:
    atp=atp+1
    mp('cyan','crip='+gprm['-ch'])
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.5  #float(gprm['-chsleep'])
    chskd.baudrate = 19200
    #chskd.flush_input()
    print('lime', 'КАНАЛ СОЗДАН !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    print('crip','ПОПЫТКА СОЗДАТЬ КАНАЛ='+str(atp)+' /ee='+str(ee))


def fpgs_connect ():
 try:
  mp('lime','BEFORE START=')
  conn = psycopg2.connect(
    host    ='192.168.0.105',
    database='postgres',
    user='postgres',
    port=5432,
    password='DjonaMallaSas')

  rmp('lime','OPENBASE OK=',5)
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')


def calcspeed():
    speed = 0
    t = stofunc.nowtosec('loc')
    d = t - mbch['start']
    if d > 0:
        speed = str(int(mbch['evtotal'] / d))
    mbch['speed']=speed
    return speed

async def mypoll():


    while True:
        await asyncio.sleep(0.003)
        for ac in addrs:
         try:
             await asyncio.sleep(0.001)
             ev = chskd.get_event(ac, True)
             mbch['evtotal'] = mbch['evtotal'] + 1
             speed=str(calcspeed())
             if ev!=None:
              mp('white','ev='+str(ev)[0:100]+', speed='+speed)
         except Exception as ee:
           mbch['evtotal']=mbch['evtotal']+1
           mprs('mypoll',ee)



async def selfupd():
   while True:
      try:
        # mp('cyan','selfupd ??????????????????????????????')
         await asyncio.sleep(0.1)
         if len(pgsbox)>0:
           line=pgsbox.pop(0)
           if line !=None:
             # mp ('blue','selfupd line='+line)
              pgs=mgb['pgs']
              curs = pgs.cursor()
              curs.execute(line)
              pgs.commit()
      except Exception as ee:
          mpr('selfupd', ee)



async def ascicl():
    while True:
     await asyncio.sleep(0.5)
     mp('white','ascicl')


async def asmydelay(interval):
    while True:
     await asyncio.sleep(interval)
     break

async def pend():
    try:
        pass
        #asyncio.wait_for(ascicl, timeout=1.0)
    except asyncio.TimeoutError:
        print('timeout! ?????????????????????????????????????????????????????????')



#=============mgbs==========
p=chr(0x27)
ap=chr(0x27)
zp=','
mgb={}
mbch={}
mbch['speed']=0
pgsbox=[]
mbch['evtotal']=0
mgb['cmdlong']='free'
tasks=[]
gprm={}
gprm['-ch']='temp'
ch='192.168.0.96'
mp('yellow','asd start')
asyncio.run(ascicl())
asyncio.run(asmydelay(5.0))
asyncio.run(pend())
asyncio.wait_for(ascicl,timeout=2)

mp('yellow','asd stop')

sys.exit(99)





chskd=crip(ch)
addrs=[77,7]
mbch['start']=stofunc.nowtosec('loc')
pgs=fpgs_connect()
mgb['pgs']=pgs
line='12345'


asyncio.ensure_future(selfupd())
asyncio.ensure_future(mypoll())




loop = asyncio.get_event_loop()
#task1 = loop.create_task(fun1(4))
#task2 = loop.create_task(selfupd())
task3 = loop.create_task(astimer1s(1))
task4 = loop.create_task(astimer10s(10))
loop.run_until_complete(asyncio.wait([task3,task4]))



