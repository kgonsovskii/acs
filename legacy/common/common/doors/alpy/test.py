#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys,time,os,traceback,time,datetime
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
import psycopg2,random
import mqtransmod
import zlib, base64
import  sqlite3
#import  zs_memdisk


def myselect():
   try:
    s='select * from xxx'
    mbmem['c1cur'].execute(s)
   except Exception as ee:
    mpr('myselect',ee)


def memcrbase(namebase):
 try:
     ap='"'
     zp=','
     print ('memcrbase start')
     c1 = sqlite3.connect(":memory:")
     mgb['memc1']=c1
     s='create table aet (myid integer not null \
     primary key autoincrement  unique,\
     txt default " " ) '
     c1.execute(s)
     mgb['c1']=c1
     mgb['c1cur']=c1.cursor()

     # s='create unique index taet1 on aet(txt)'
     # c1.execute(s)
     for i in range(1,100,1):
       cd=gfunc.mydatezz()
       s='insert into aet(txt) values('+ap+cd+ap+')'
       lm=c1_insert(s)
       print('i=',i,'lm=',lm)
     c1.commit()
     print ('s=',s)
     mp('l','s='+s)
 except Exception as ee:
  mpr('magenta',ee)

def c1_insert(s):
  try:
   mgb['c1'].execute(s)
   mgb['c1'].commit()
   rc=findlastmyid('aet')
   return rc
  except Exception as ee:
   mprs('c1+insert',ee)

def findlastmyid(tbn):
   try:
      s='select * from "sqlite_sequence" where name='+ap+tbn+ap
      mgb['c1cur'].execute(s)
      mgb['c1cur'].fetchone()


   except Exception as ee:
     mpr('findlastmyid',ee)

def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mp(c,txt):
 try:
  ch='test'
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,ch+' '+txt+'  /t='+t)
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def myinsretreturn(ss):
  try:
   uxt= str(stofunc.nowtosec('loc'))
   pgc = pgconn
   curs = pgc.cursor()
   ss=ss+' returning myid'
   mp('lime','ss='+ss)
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






def timercheck(interval):
    while True:
     gevent.sleep(interval)
     fn='checkfile.txt'
     if os.path.isfile(fn):
       mgb['recoverac']='yes'
     else:
      mgb['recoverac']='no'
     mp('lime','timercheck='+ mgb['recoverac'])

def timerrecoverac(interval):
    while True:
        gevent.sleep(interval)
        if mgb['recoverac']=='yes':
         mp('yellow','timerrecoverac yes............................')

def jb_drvinfo(g):
    jb ={
    "cmd" :g['cmd'],
    "av"  : g['av'],
    "ev"  : g['ev'],
    "ac"  : g['ac'],
    "port": g['port'],
    "cd": g['cd'],
    "ct"  : g['ct'],
    "kluch": g['kluch'],
    "code": g['code']
    }
    s=json.dumps(jb)
    mp('yellow','s ='+s)
    fn='jsonpy.txt'
    outp=open(fn,'w')
    outp.write(s)
    outp.flush()
    outp.close()
    inp=open(fn,'r')
    ss=inp.read()
    jb=json.loads(ss)
    mp('lime','ss='+ss)
    sss=json.dumps(ss)
    # print('sss=',sss)
    # s = json.loads(sss)
    # print ('s=',s)
def fread():
    fn = 'atssguard.json'
    inp = open(fn, 'r')
    s=inp.read()
    return s

def findkeys(ser,nn):
   pgc = pgconn
   curs = pgc.cursor()
   t1=gfunc.mymarker()
   for i in range(1,nn+1,1):
     j= random.randint(0, nn)
     kluch=ser
     n=str(j)
     n= gfunc.zerol(n,5)
     kluch=kluch+n
     kluch=gfunc.zerol(kluch,12)
     code=str(gfunc.keytox(kluch))
     s='select myid,kluch,code  from tss_keys where code='+code
     curs.execute(s)
     loc = curs.fetchall()
     for row in loc:
        myid  = str(row[0])
        kluch = str(row[1])
        code  = str(row[2])
        ss=myid+zp+kluch+zp+code
        mp('lime', 'ss=' + ss)
   t2 = gfunc.mymarker()
   d = gfunc.mymarkerdelta(t1, t2)
   mp('yellow', 'd=' + str(d))

def crtscd(nn):
  try:
    pgc = pgconn
    curs = pgc.cursor()
    for i in range(1, nn + 1, 1):
        uxt= str(stofunc.nowtosec('loc'))
        s ='insert into tss_f3(f3)values('+uxt+')'
        curs.execute(s)
        mp('yellow',s)
    pgc.commit()
  except Exception as ee:
    mpr('crtscd',ee)

def getsizetable(tbn):
    pgc = pgconn
    curs = pgc.cursor()

    s='SELECT pg_size_pretty( pg_total_relation_size('+ap+tbn+ap+'))'
    curs.execute(s)
    loc = curs.fetchall()
    for row in loc:
        tbz = str(row[0])
        print ('TBN='+tbn+' SIZE='+tbz)

def readcolumnsname(tbn):
    pgc = pgconn
    curs = pgc.cursor()
    s='select table_name,column_name,data_type from information_schema.columns '\
    'where table_name='+ap+tbn+ap
    curs.execute(s)
    loc = curs.fetchall()
    for row in loc:
        tbn = str(row[0])
        cn  = str(row[1])
        ct = str(row[2])
        s='tbn='+tbn+' cn='+cn+' /ct='+ct
        print ('S='+s)

def readalgol():
    pgc = pgconn
    curs = pgc.cursor()

    s='SELECT name,num from tss_algol where actual=True order by num'
    print ('s=',s)
    curs.execute(s)
    loc = curs.fetchall()
    ls=[]
    for row in loc:
     name =str(row[0])
     num = str(row[1])
     print ('name=',name,'num='+num)
     ls.append(name)
    return ls




def readtablelist():
    pgc = pgconn
    curs = pgc.cursor()

    s='SELECT table_name  FROM     information_schema.tables '\
    ' where  table_name like ' +ap+'%tss%'+ap
    print ('s=',s)
    curs.execute(s)
    loc = curs.fetchall()
    ls=[]
    for row in loc:
     tbn = str(row[0])
     ls.append(tbn)
     print ('tbn=',tbn)
    return ls



def crlog(nn):
  try:
    pgc = pgconn
    curs = pgc.cursor()
    for i in range(1, nn + 1, 1):
        code=i
        bidcomp='6'
        bidch  ='79'
        bidac  ='101'
        bidport='1'
        bidsens='1'
        rccode='-99'
        # uxt=str(stofunc.nowtosec('loc'))
        uxt = str(i)
        s = 'insert into tss_eventlog(bidcomp,bidch,bidac,bidport,bidsens,rccode,uxt)values( ' + \
        bidcomp  + zp+\
        bidch    +zp+\
        bidac    +zp+\
        bidport  +zp+\
        bidsens  +zp+\
        rccode   +zp+\
        uxt+\
        ');'
        curs.execute(s)
        mp('yellow',s)
    pgc.commit()
  except Exception as ee:
    mpr('testlog',ee)

def mycoding(t):
    lt64 = base64.b64encode(t)
    return lt64

def mycrc32(s):
    b = bytes(s, 'utf-8')
    # print ('b=',b)
    r = zlib.crc32(b)
    # print('r=', r)
    # print('mycrc32================')
    return r


def testcode64(src):
    src='женя  ююююююююююююююююююююююююююююююююююююююююююююююююююююююююююююю'
    с1=mycrc32(src)
    mp('lime', 'c1=' + str(с1))
    sys.exit(11)
    src = 'женя '
    c2=mycrc32(src)
    mp('lime','c2='+str(c2))

    appdir = gfunc.getmydir()
    fn = appdir + 'test64.txt'
    print('fn=' + fn)
    outp = open(fn, 'w')
    outp.flush()

    target =mycompress(src)
    # outp.write(str(target)+'\n')
    # outp.flush()
    lt64 = mycoding(target)
    outp.write(str(lt64) + '\n')  # это для кодировки
    outp.flush()
    dec64 = base64.b64decode(lt64)
    # outp.write(str(dec64) + '\n')
    # outp.flush()
    uct64 = zlib.decompress(dec64).decode('utf-8')
    # outp.write(uct64 + '\n')
    # outp.flush()
    outp.close()
    return lt64,uct64
    mp('yellow','LAST='+uct64)


def mycompress(src):
    target = zlib.compress(src.encode('utf-8'))
    mp('white','AFTER MYCOMPESS')
    return target

def mycompress_old(src):
    mp('cyan', 'mycompress START src='+src)
    target = zlib.compress(src.encode('utf-8'))
    mp('white', 'target=' + str(target))
    lt64 = base64.b64encode(target)
    print('len(lt64=)', len(lt64))
    dec64 = base64.b64decode(lt64)
    print ('aaaaaaaaaaaaaaaaaaaaaaaa')
    uct64 = zlib.decompress(dec64).decode('utf-8')
    print('uct64=',uct64)
    print ('=================================================')
    sys.exit(55)
    return uct64


def testzlib():

    src = 'женя ОКСАНА'
    t=mycompress(src)
    mp('yellow','t='+str(t))

    # print('long_text', len(src))
    mp('yellow','src='+src)
    target = zlib.compress(src.encode('utf-8'))
    mp('white', 'target=' + str(target))
    # print('long_text_compressed', len(target))
    decoded_b64_text = base64.b64decode(target)
    undompressed_text = zlib.decompress(decoded_b64_text).decode('utf-8')
    # mp('lime','last='+str(undompressed_text))

    sys.exit(77)


def crkeys(nstart,nlast):
   uxt= str(stofunc.nowtosec('loc'))

   pgc = pgconn
   curs = pgc.cursor()
   for i in range(nstart,nlast+1,1):
     code=i
     kluch=gfunc.xkeytos(code)
     n=str(i)
     n= gfunc.zerol(n,5)
     kluch=gfunc.zerol(kluch,12)
     fio='fio_'+kluch
     mrs='1,2,3,4'
     uxt=stofunc.nowtosec('loc')
     jss = {
         "cmd": 'cmd',
         "av": 'av',
         "uxt": uxt,
         "department": 'top managment'
        }
     jss = json.dumps(jss)

     s ='insert into tss_persons(kluch,fio,mrs,jss,code)values( '+\
        ap+kluch+ap+zp+\
        ap+fio+ap+zp+ \
        ap + mrs + ap + zp + \
        ap + jss + ap + zp + \
        str(code)+') returning myid'
     curs.execute(s)
     loc = curs.fetchall()
     for row in loc:
       bp_pers = str(row[0])
       mp('yellow', 'bpkeys=' + str(bp_pers))

     s='insert into tss_keys(kluch,bp_pers,code)values( '+ \
     ap+kluch+ap+zp+ \
     str(bp_pers)+zp+\
     str(code)+')'
     curs.execute(s)
   pgc.commit()

def fpgs_connect():
 try:
  conn = psycopg2.connect(
    host    ='localhost',
    database='postgres',
    user="postgres",
    password="postgres")
  return conn
 except Exception as ee:
   mpr('ERROR ON=fpgs_connect EE=',ee)

def fsrc1209(g):
    vuxt,ms=gfunc.myuxtms()
    id= str(g['ac'])+'.'+ str(g['no'])
    job = {
            'cmd: '   : 'src1todms',
            'subcmd'  : 'src1todms',
            'typs': 209,
            'psw': {
                'ch': g['ch'],
                'bidcomp': int(g['bidcomp']),
                'bidch'  : int(g['bidch']),
                'no'     : int(g['no']),
                'cdc'   : str(g['cd']),   # date and time event of controller
                'vuxt'   : vuxt,             # time of registration
                'ms'     : ms,
                'body' : {
                  'av'    : g['av'],
                  'ev'    : g['ev'],
                  'ac'    : g['ac'],
                  'port'  : g['port'],
                  'kluch' : g['kluch'],
                  'ikluch': g['ikluch'],
                  'rst'   : g['rst']
                }
            }
    }
    s = json.dumps(job)
    mp('lime','s='+s)
    # }
    # glsjsrc1[id]=jb

def fckp(g):
    print (str(g))


def ffindk(g):
    print (str(g))

def initmbac():
    msg='init'
    g={}
    for ac in addrs:
     msg='init'
     g[ac]={}
     g['ac']=ac
     g[ac][msg]=0            # кол-во ошибок типа msg
     g[ac]['cerr'] = 0       # текущее кол-во ошибок
     g[ac]['limitcerr'] =50  # предел  кол-ва ошибок
     g[ac]['wkpx']=0
     g[ac]['sem1'] = 0     # усли 0   опрос пазрешен
    return g


def setmbac():
    lst=['tx1','tx2','tx3','t44']
    for ac in addrs:
     for  t in lst:
      mbac[ac][t]=ac*10
    print('x=' + str(mbac[ac]['tx2']))
    # for g in addrs:
    #  print ('g='+str(mbac[ac]))

def checkbb64():
  try:
   mp('cyan','checkbb4 start')
   pt='c:\@laz'+sep+'@atss_units'+sep+'atss_drv209'+sep+'specbase'+sep+'starter.db3'
   vb=gfunc.opendb3(pt,'r')
   s='select* from starter'
   vb.cursor.execute(s)
   for row in vb.cursor:
    dbn=row['dbn'].strip()
    psw =row['dbn'].strip()
    if dbn !='':
     dbn=base64.b64decode(dbn)
     psw= base64.b64decode(psw)
     dbn=dbn.decode()
     psw=psw.decode()
     print ('dbn=',dbn,' psw='+psw)

  except Exception as ee:
   mpr('checkbb64',ee)

def checkbroken(ex):
    p='broken pipe'
    ex=str(ex)
    ex=ex.lower()
    try:
     n=ex.index(p)
     mp('lime','n='+str(n))
     return n
    except Exception as ee:
      mprs('checkbroken',ee)
      return -1



# ================== mgbs==================================
init(autoreset=True)
print ('SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS')
glsalgol=[]
glsjsrc1={}
ap=chr(0x27)
zp=','
mgb={}
tasks=[]
addrs=[7,77]


#getsizetable('tss_acerr')

pgconn=fpgs_connect()
ls=readtablelist()

for s in ls:
  getsizetable(s)
  mp('white','s='+s)

sys.exit(91)

g={}
g['cmd']='test'
g['cmd']={}
g['cmd'][1]=[1,2,3,4,5]
s=json.dumps(g)
print ('s=',s,'type=',type(s))
sys.exit(99)

uxt=stofunc.nowtosec('loc')
print('uxt=',uxt)
dt=datetime.date()
print ('dt=',dt)
#dt=stofunc.datetimetosec(uxt,'sql')
#print ('dt='+str(dt))
sys.exit(99)

mbac=initmbac()
for k in mbac:
 v=mbac[k]
 mp('cyan','k='+str(k)+', v='+str(v))
if not 'initx' in mbac[77]:mbac[77]['initx']=1
mbac[77]['initx']=mbac[77]['initx']+55
x=mbac[77]['initx']
mp('lime','x='+str(x))
# mp('yellow','MBAC='+str(mbac))
sys.exit(99)
mp('c','start')
mbmem={}
appdir=gfunc.getmydir()
pt=appdir+'test3'
s='женя'
b = bytes(s, encoding='utf-8')
s1=base64.b64encode(b)
s2=base64.b64decode(s1)
s1=s1.decode()
s2=s2.decode()
print('s=',s)
print('s1=',s1)
print('s2=',s2)
# mp('magenta','s='+s+' s1='+s1+' s2='+s2)
# mp('magenta','s='+s+' s1='+s1)
checkbb64()
sys.exit(1)

# addrs=[3,77]
# initmbac()
# setmbac()
# sys.exit(3)

kl='000000828E34'
x=gfunc.keytox(kl)
kl2=gfunc.xkeytos(x)
print ('x=',x,' kl2=',kl2)
sys.exit(99)


# mqttclient=mqtransmod.connecttobroker('qwe123','office.sevenseals.ru:33890')
# mqttclient=mqtransmod.connecttobroker('qwe123','office.sevenseals')
# print('mqttclient',mqttclient)
# sys.exit(99)
mp('yellow','call connect')

mp('lime','call connect')
mgb['pgc']=pgconn
mp('white','?????'+str(pgconn))
s='insert into tss_armcmd(cmd,idoper)values('+\
   ap+'get_getacinfo'+ap+zp+'3)'
print ('s=',s)
rc=myinsretreturn(s)
mp('cyan','rc='+str(rc))
sys.exit(99)

c,r=gfunc.mycmps(src)
mp(' yellow','c='+str(c))
mp('lime',r)
crc=gfunc.mycrc32(src)
mp('lime','crc='+str(crc))
sys.exit(99)

crkeys(1,1000)
sys.exit(99)

# crtscd(10000)
# findkeys('A',3)
# ===============================zonetest

# =================================================


glsalgol=readalgol()
g={}
g['name']=''

for name in glsalgol:
 try:
  g['name']=name
  uxt,ms=gfunc.myuxtms()
  g['ms']=ms
  g['t1']=gfunc.mymarker()
  eval(name)
 except Exception as ee:
  mprs('eval',ee)


sys.exit(99)
readtablelist()
readcolumnsname('tss_eventlog')
getsizetable('tss_acerr')



mgb['recoverac']='yes'
g={}
g['cmd']='acsev'
g['av'] ='av',
g['ev'] ='key'
g['ac'] ='77'
g['port'] ='1'
g['ct']=gfunc.mytime()
g['cd']=gfunc.mydatezz()
g['code'] ='1122334455'
g['kluch'] ='000000828e34'
s=fread()
print ('s=',s)

jb=json.loads(s)

tp=str(type(jb))
print ('tp='+tp)
for i in range (0,len(jb),1):
 print (jb[i],'>>>> ',type(jb[i]))
 print (jb[i]['subcmd'],jb[i]['status'])


sys.exit(99)


# jb_drvinfo(g)
# sys.exit(99)
task = gevent.spawn(timercheck, 1)
tasks.append(task)


task=gevent.spawn(timerrecoverac,3)
tasks.append(task)

gevent.joinall(tasks)
# vuxt, ms = gfunc.myuxtms()
# id = str(ac) + '.' + str(no)
# job = {
#     'psw': {
#         'ch': 1,
#         'bidcomp': 2,
#         'bidch': 3,
#         'content': {
#             'x': 'x'
#         }
#     }
# }
