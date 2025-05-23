#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time

import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import psycopg2
import base64
import json,subprocess
import paho.mqtt.client as mqtt





def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)




def redlog(txt):
    toredbase(txt)
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
   ch='dms'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
   # redlog(txt)
    return
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)


def getdelta(m1,m2):
 try:
  d=gfunc.mymarkerdelta(m1,m2)
  return d
 except Exception as ee:
  mpr('getdelta',ee)


def formirkeyrte(g):
    #rmp('red','FORMIRKEYRTE='+str(g),1)
    if g['kpx']!='kpx':
     mp('red','formirkeyrte kpx='+str(g['kpx']))
     return
    if g['sens']=='key' or g['sens']=='rte':
       # rmp('yellow', 'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT',3)
        gx={}

        gx['ac']=g['ac']
        gx['port']=g['port']
        gx['tmr']=3*2
        gx['cmd']='fromdms'
        gx['subcmd']='relay'
        gx['almm1']=gfunc.almymarker()

        #rmp('cyan', 'BEFORE ??????????????????????????????????? t='+t,3)
        if g['sens']=='key' or g['sens']=='rte':
         pass
         rmp('blue','t=====SEND RTE===========',1)





def torpc(g):
    if g['komu']=='dms':
     pass
    # formirroad(g,'dms','rpc')


def readrow(s):
   try:
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

    return loc
   except Exception as ee:
     mp('red','readrow s???='+s)
     mpr('readrow2',ee)

def readrow_old(s):
   try:
    pgc = pgconn
    curs = pgc.cursor()
    curs.execute(s)
    for i in range(1, 3, 1):
        try:
            mp('white', 'readrow s=' + s)
            loc = curs.fetchall()
            curs.close()
            return loc
        except Exception as ee:
            mprs('readrow', ee)
            gevent.sleep(0.5)
    return loc
   except Exception as ee:
     mpr('readrow',ee)






def readalgol():
    pgc = pgconn
    curs = pgc.cursor()

    s = 'SELECT name,namefunc,num,cerr,descr,abrv,actual from tss_algol  order by num'
   # print ('s=',s)
    curs.execute(s)
    loc = curs.fetchall()
    ls=[]
    g={}
    for row in loc:
     name =str(row[0].strip())
     g[name]={}
     namefunc = str(row[1])
     num = str(row[2])
     g[name]['num']=num
     cerr = str(row[3])
     descr = row[4]
     abrv = row[5]
     actual = row[6]
     g[name]['namefunc'] =namefunc
     g[name]['cerr'] =cerr
     g[name]['actual'] = actual
     g[name]['descr'] = descr
     g[name]['abrv'] = abrv
     mp('white','name='+name+'>')
     ls.append(name)
    return g,ls

     # print ('name=',name)

def selfupd(line):

      try:
          mp('white','selfupd='+line)
          curs = pgconn.cursor()
          curs.execute(line)
          pgconn.commit()
      except Exception as ee:
          mprs('selfupd', ee)


def clearlsgitog():
    while len(lsgitog)>0:
     lsgitog.pop(0)
    # mp('lime',' clearlsgitog DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD')
    return


def calcstartline():
    s1 = sys.argv[0]
    s = ''
    for x in gprm:
        v = str(gprm[x])
        s = s + x + ' ' + v + ' '
    startline = 'python3 ' + s1 + ' ' + s + ' &'
    mp('red', 'startline=' + startline)
    return startline

def timer10s(interval):
  try:
   while True:
    gevent.sleep(interval)
    mp('cyan', 'timer10s  ?????????????????????????')
    g = {}
    g['cmd'] = 'life'
    g['komu']='tomain'
    g['kto'] ='dms'
    g['uxt'] = str(stofunc.nowtosec('loc'))
    g['pid'] = str(os.getpid())
    g['startline'] = startline
    lsgto.append(g)
  except Exception as ee:
    mpr('timer10s',ee)



def timerwork(interval):
    while True:
     gevent.sleep(interval)
     l=len(lsgtodms)
     if l>0:
      #mp('magenta', 'l========================================' + str(l))
      g=lsgtodms.pop(0)
     # mp('white',str(g))
      if 'sens' not in g.keys():return
      cev = getportinfo(g)  #suda
      if g['sens']=='key':
      # rmp('white', 'timerwork g=' + str(g),2)
       g=calc0(g)
      else: calc0(g)
     # mp('red','timerwork AFTER CALC0================================')
      gx={}
      for g in lsgitog:
       try:
        if type(gx)!=type(g):return
        if 'alf1' in g.keys() and 'alf2' in g.keys():
           t1=float(g['alf1'])
           t2=float(g['alf2'])
           d=t2-t1
           d = round(d, 3)
           g['delta']=str(d)
           #mp('magenta','timerwork  ITOG============'+str(g))
        clearlsgitog()
       except Exception as ee:
        #mp('magenta','-BEFORE g='+str(g))
        mprs('timerwork 2 tile',ee)




def timer1s(interval):
    while True:
     gevent.sleep(interval)
     '''
     g={}
     g['komu'] = 'tomain'
     g['cmd'] = 'life'
     g['pid'] =str(os.getpid())
     g['uxt']=str(stofunc.nowtosec('loc'))
     g['startline'] =startline
     formir_glstojs(g)
     mp('cyan', 'timer1s g='+str(g))
     while len(lstowrlog) :
      s=lstowrlog.pop(0)
      selfupd(s)
     '''
def fpgs_connect():
 try:
  conn = psycopg2.connect(
    host    =mysysinfo['base']['ip'],
    database=mysysinfo['base']['dbn'],
    user="postgres",
    port=5432,
    password=mysysinfo['base']['psw'],)
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)
   mgb['fatalerr'].append('baseerr')

def calcptstarter():
    appdir = gfunc.getmydir()
    pt = appdir
   # mp('cyan', 'pt=' + pt)
    ls = pt.split('/')
    #mp('cyan', 'ls=' + str(ls))
    l = len(ls)
    l = l - 1
    #mp('yellow', 'l=' + str(l))
    for x in range(l, l - 3, -1):
     ls.remove(ls[x])
    ss=''
    for s in ls:
     ss=ss+s+'/'
    ss=ss+'starter/starter.db3'
    return ss


def f_findkey(cev):
   #rmp('blue','NEW f_findk='+str(cev)[0:100],3)
   if cev['sens']!='key':
   # rmp('red','f_findk ?????????????????????????????  sens='+cev['sens'],3)
    return cev
  # rmp('lime','f_findkey START ',10)
   gx = {}
   gx['func']='f_findk'
   gx['alf1'] = gfunc.almymarker()
   cev['cerr'] = '0'
   cev['code']='8556084'
   cev['kluch']='000000828E34'     #str(cev['code']) suda change
   kluch =cev['kluch']                             #str(cev['kluch'])
   sens= str(cev['sens'])
  # mp('blue', 'f_findk='+str(cev))
   #rmp('yellow','f_findk???????????????????????????????????????',3)
   if not 'kluch' in cev.keys():
       rmp('red', 'Not kluch  RETURN', 2)

   code =str(cev['code'])
   nump = str(cev['port'])
   s=' select info.myid, info.bidkeys, info.mrs, info.tmzname, kl.kluch,'\
   ' kl.keypad, kl.zapret, info.name3, info.name1, info.name2, '\
   ' info.fadmin,lc.ioflag,lcp.name,lc.rdrtype,lc.tmr,lcp.myid,lc.myid,'+\
   ' lcp.tag,lcp.fckp '+\
   ' from tss_persinfo as info, tss_keys as kl,'+\
   ' tss_ports as pt,'+\
   ' tssloc_locations as lc, tssloc_locations as lcp'\
   ' where kl.code='+code+''+\
   ' and pt.nump ='+nump+''+\
   ' and kl.bppers = info.myid'\
   ' and pt.myid = lc.bidport'\
   ' and lc.code = 1'\
   ' and lcp.myid = lc.bp'
   mp('red','FFFFKKK='+s)
   loc=readrow(s)
   #rmp('red','LEN='+str(len(loc)),3)
   f=False
   if len(loc)==0:
       cev['cerr'] = '-1'  # 1- nkf
       cev['fio'] = 'undef'
       gx['alf2'] = gfunc.almymarker()
       # lsgitog.append(gx)
       return cev
   for row in loc:
    f=True
    pmyid    =row[0]
    pbpkeys  =row[1]
    pmrs     =row[2]
    tmzname  =row[3]
    kluch    =row[4]
    keypad   =row[5]
    zapret   =row[6]
    name3    =row[7]
    name1    =row[8]
    name2    =row[9]
    fadmin   =str(row[10])
    ioflag   =str(row[11])
    #lcp.name, lc.rdrtype, lc.tmr, lcp.myid, lc.myid
    cev['locat']        =str(row[12])
    cev['rdrtype']      =str(row[13])
    cev['tmr']          =str(row[14])
    cev['bidlocparent'] =str(row[15])
    cev['bidlocsens']   =str(row[16])
    cev['prevtag'] = str(row[17])
    cev['fckp'] = str(row[18])
    cev['bidpers']=str(pmyid)
    fio=name3+' '+name1+' '+name2
    cev['fio']=fio
    mp('yellow','fio='+fio+'/bidlocsens='+cev['bidlocsens']+'/parent='+cev['bidlocparent'])
   return cev
   cev['bidpers']=str(pmyid)
   if not 'evtyp' in cev.keys():
    if 'evtyp' in cev.keys() and cev['evtyp'] != 'virt':
     mrs = row[3]
     ntmz  = row[4]
     rmp('red','virt vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv',3)
    bidpers=row[5]

   if f :
       rmp('yellow',' ^^^^^^^^^^^^^^^^^^^^^^',3)
       cev['cerr'] = '0'
       cev['fio']=fio
       cev['ntmz'] = tmzname
       if not 'evtyp' in cev.keys():
        #rmp('yellow','EVTYP NOT IN GLS',3)
        cev['ntmz'] = tmzname
        cev['mrs'] = pmrs
        #rmp('lime', 'READ NTMZ MRS', 5)
       cev['bidpers']=str(pmyid)
      # gx['alf2'] = gfunc.almymarker()
      # lsgitog.append(gx)
       return cev
   else:

    cev['cerr'] = '1'  # 1- nkf
    cev['fio'] ='undef'
    gx['alf2'] = gfunc.almymarker()
    #lsgitog.append(gx)
    return cev


def getcountrow(tbn):
  try:
   s='select count(*) from '+tbn
   loc=readrow(s)
   for row in loc:
    return 'ok',row[0]
  except Exception as ee:
    mpr('getcountrow',ee)
    return str(ee),-1

def b2_anfilada(cev):
  try:
  # mp('yellow','B2_ANFILADA='+str(cev))
   return cev
  except Exception as ee:
   mpr('b2_anfilada',ee)


def b_anfilada(cev):
  try:
  # mp('white','B_ANFilada cev='+str(cev))
  # mp('gray','PREVTAG='+str(cev['prevtag'])+' PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP')
  # rmp('red','prevtag='+str(cev['prevtag']),5)

   if int(cev['prevtag'])<2:
    cev['cerr']=mgb['sucs']
    cev['abrv']='ok'
    rc,cr= getcountrow('tss_passes')
   # rmp('red', 'b_anfilada rc=' + str(rc) + ' /cr=' + str(cr), 5)
    if rc=='ok':
     if cr==0:
      return cev
     else :
      cev=b2_anfilada(cev)
      return cev
   else:
    # rmp('magenta', 'prevtag=' + str(cev['prevtag']), 5)
     rc=sel1frompass(cev)
     if rc==False:
         rmp('red','BAD FROM PASSES='+s,3)
         cev['cerr']=str(mgbalg['anfilada']['cerr'])
         cev['abrv'] = mgbalg['anfilada']['abrv']
     else:
         cev['cerr'] = mgb['sucs']
         cev['abrv'] = 'ok'
     return cev
  except Exception as ee:
   mpr('b_anfilada',ee)
   return cev

def sel1frompass(cev):
  try:
    mp('cyan','sel1frompass='+str(cev))
    if cev['ioflag']=='False':
       iof=True
    if cev['ioflag'] == 'True':
        iof =True

    s = 'select * from tss_passes where bidlocparent=' + str(cev['prevbidloc']) + \
        ' and keycode=' + str(cev['code']) + 'and ioflag=' +str(iof)   #  cev['ioflag']
    rmp('lime','sel1frompass='+s,3)
    loc=readrow(s)
    for row in loc:
     return True
    return False

  except Exception as ee:
    mpr('sel1frompass',ee)


def diff(ls1,ls2): #вычитание  списков
  try:
    #ls1= [7]
    #ls2= [3,4,5,6]
    ds1=set(ls1)
    ds2=set(ls2)
    d1 = ds1 - ds2  # d1 - остаются, которых нет в ds2; если список пуст, то в d2 они есть
    d2 = ds2 - ds1  # d2 - остаются, которых нет в ds1
    d1=list(d1)
    d2=list(d2)
    return  d1,d2
  except Exception as ee:
    mpr('diff',ee)





def f_anfilada(cev):
 try:

     nm='anfilada'
     if mgbalg[nm]['actual'] == False:
         cev['cerr'] = mgb['sucs']
         cev['abrv'] = mgbalg[nm]['abrv']
         return cev
     if (cev['fckp']==True or cev['fckp']=='True') and (cev['ioflag']==False or cev['ioflag']=='False'):
        cev['cerr'] = mgb['sucs']
        #cev['abrv'] = mgbalg[nm]['abrv']
        return cev
     cev=b_anfilada(cev)
    # rmp('blue','AFTER B_ANFILADA cccccccccccccccccccccccccccccccccccccCERR='+cev['cerr'],5)
     return cev

 except Exception as ee:
  mpr('f_anfilada',ee)
 return cev


def b_checkmars(cev):
  try:
   nm = 'checkmars'
   #rmp('cyan','START nm='+nm,5)
   if mgbalg[nm]['actual'] == False:
    cev['cerr'] = mgb['sucs']
    cev['abrv'] ='ok'
    return cev

  # rmp('lime','checkmars ?????????????????????//////////////////',3)
   pm = cev['mrs']
   dm = cev['smrn']
   lsp = pm.split(',')
   lsd = dm.split(',')
   #mp('gray','lsp='+str(lsp))
   #mp('gray','lsd='+str(lsd))
   rc=False
   for x in lsp:
    if x in lsd:
     rc=True
     return rc
    #rmp('magenta','b_checkmars rc='+str(rc),10)
   return rc
  except Exception as ee:
   mpr('b_checkmars',ee)

def readfld(line):
  try:
  # mp('blue','readfld line='+line)
   loc=readrow(line)
   for row in loc:
    return row[0]
   return None
  except Exception as ee:
   mpr('readfld',ee)


def f_checkmars(cev):
   nm='checkmars'
   if mgbalg[nm]['actual'] == False:
       cev['cerr'] = mgb['sucs']
       cev['abrv'] = mgbalg[nm]['abrv']
       #rmp('red', 'nm=' + nm + 'EXIT NOT ACTUAL', 5)
       return cev

   pm=cev['mrs'].strip()
   if pm=='0' :
       cev['cerr'] = mgb['sucs']
       cev['abrv'] = mgbalg[nm]['abrv']
       return cev
   dm=cev['smrn']
   #rmp('red','f_checkmars pm='+pm+' / dm='+dm,2)
   rc=b_checkmars(cev)
   if rc==True:
    cev['cerr']=mgb['sucs']
    return cev
   else:
    cev['abrv'] = mgbalg[nm]['abrv']
    cev['cerr']=mgbalg[nm]['cerr']
    #rmp('yellow','abrv='+cev['abrv'],10)
    return cev

def fitsckp(cev):
    mp('red','fitsckp='+str(cev))
    s = 'select bidlocparent from tss_passes where ' + \
        ' keycode =' + str(cev['code'])+ \
        ' and ioflag = true'+\
        ' and bidlocparent='+str(cev['prevbidloc'])
    rmp('red',s,3)
    #return False
    loc = readrow(s)
    for row in loc:
        bidlocparent=str(row[0])
        rmp('red','bidlocparent='+bidlocparent+' / prevbidloc='+str(cev['prevbidloc']),3)
        if str(cev['prevbidloc'])==bidlocparent:
         rmp('red','fitsckp= TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT',3)
         return True
        else :
          rmp('red', 'fitsckp=FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', 3)
          return False
    return False




def b_fckp(cev):
    nm = 'fckp'
   # mp('blue','nm='+nm+' B_FCKP cev='+str(cev))
    if mgbalg[nm]['actual'] == False:
        cev['cerr'] = mgb['sucs']
        cev['abrv'] = mgbalg[nm]['abrv']
        rmp('red', 'nm=' + nm + 'EXIT NOT ACTUAL', 5)
        return cev
   # rmp('white','b_fckp',10)
    s='select * from tss_passes where '+\
    ' keycode ='+str(cev['code'])+'' \
    '  and fckp = true and ioflag = true'+\
    ' and prevbidloc='+cev['prevbidloc']
    #mp('gray','XXXnm='+nm+' s='+s)
    s='select *  from tss_passes where '+\
    ' bidlocparent = '+str(cev['prevbidloc'])
    mp('gray', 'XXXnm=' + nm + ' s=' + s)
    loc=readrow(s)
    for row in loc:
     cev['cer'] = mgb['sucs']
     return cev

    cev['cerr'] = str(mgbalg[nm]['cerr'])
    cev['abrv'] = mgbalg[nm]['abrv']
    return cev

def f_fckp(cev):
 try:
  # mp('red','F_FCKP='+str(cev))
   nm='fckp'
   if mgbalg[nm]['actual'] == False:
     cev['cerr'] = mgb['sucs']
     cev['abrv'] = mgbalg[nm]['abrv']
     return cev
   #mp('red','nm='+nm+' PREVTAG=================='+str(cev['prevtag']))

   if int(cev['prevtag'])<2:
    cev['cerr']=mgb['sucs']
    cev['abrv'] = mgbalg[nm]['abrv']
    return cev

   if cev['fckp']=='True':
    cev['cerr']=mgb['sucs']
    cev['abrv'] = mgbalg[nm]['abrv']
    rmp('cyan', 'ITS CKP  CCCCCCCCCCCCCCCCCCCKKKKKKKKKKKKKKKKKKKKKPPPPPPPPPPP', 3)
    rc=fitsckp(cev)
    if rc :
     cev['cerr'] = mgb['sucs']
     cev['abrv'] = mgbalg[nm]['abrv']
     return cev
    else:
        cev['cerr'] = str(mgbalg[nm]['cerr'])
        cev['abrv'] = mgbalg[nm]['abrv']
        return cev

    return cev
   else:
    rmp('cyan', 'ITS DOOR  DDDDDDDDDDDDDDDDDDDDDDD', 3)
    cev=b_fckp(cev)
   rmp('cyan', 'ITS CKP 22222222222222222222222222222',3)
   return cev
 except Exception as ee:
   mpr('f_ckp',ee)

def b_owner(cev):
    mp('red','B+OWNER='+str(cev))
    nm = 'owner'
    s='select count(*) from tss_passes where bidpers='+str(cev['bidowner'])
    ' and  bidpers='+\
    ' and bidloc='+str(cev['bidlocsens'])
    mp('red','b_owner='+s)
    cr=readfld(s)
    mp('red', 'b_owner=' + s+' /RC='+str(cr))
    if cr==0:
     return False
    else: return True



def f_owner(cev):
  try:
   nm='owner'
  # rmp('yellow','ooooooooooooooooooooooooooooooooooooooooooooooooooo',3)
  # mp('yellow','FFFFFFFFFFFFFFFF OWNER='+str(cev))
  # mp('lime', 'FFFFFFFFFFFFFFFF OWNER=' + str(mgbalg['fapbin']))
  # mp('lime', 'FFFFFFFFFFFFFFFF OWNER=' + str(mgbalg[nm]))
   if mgbalg[nm]['actual'] == False :
    cev['cerr'] = mgb['sucs']
    cev['abrv'] = mgbalg[nm]['abrv']
   # rmp('cyan','nm='+nm+'NOTACTUAL',3)
    return cev
   bow= int(cev['bidowner'])
   if bow == -1:
    cev['cerr'] = mgb['sucs']
    cev['abrv'] = mgbalg[nm]['abrv']
    return cev
   if bow >0:
     rc=b_owner(cev)
     if rc:
      cev['cerr'] = mgb['sucs']
      cev['abrv'] = mgbalg[nm]['abrv']
      return cev
     else:
         cev['cerr'] = str(mgbalg[nm]['cerr'])
         cev['abrv'] = mgbalg[nm]['abrv']
         return cev
   return cev

  except Exception as ee:
   mpr('f_fowner',ee)





def f_fapbin(cev):
  try:
   nm='fapbin'
   #mp('yellow','nm='+nm+' /cev='+str(cev))
   if mgbalg[nm]['actual'] == False:
    cev['cerr'] = mgb['sucs']
    cev['abrv'] = mgbalg[nm]['abrv']
    return cev

   if cev['fckp']=='False':
       cev['cerr'] = mgb['sucs']
       cev['abrv'] = mgbalg[nm]['abrv']
       #rmp('lime', nm+' ttttttttttttttttttttttttttttttttttttttttttttttt 0.1 ', 3)
       return cev
   if cev['fckp']=='True' and cev['ioflag']=='False':
       cev['cerr'] = mgb['sucs']
       cev['abrv'] = mgbalg[nm]['abrv']
       #rmp('lime', nm+' ttttttttttttttttttttttttttttttttttttttttttttttt 0.2 ', 3)
       return cev

   s='select count(*)  from tss_passes where keycode='+str(cev['code'])+\
     ' and fckp=True and ioflag=True'
   cr=readfld(s)
   #rmp('cyan','nm='+nm+' /s='+s+' /cr='+str(cr),3)
   if int(cr)>0 and cev['fckp']=='True':
       cev['cerr'] = str(mgbalg[nm]['cerr'])
       cev['abrv'] = mgbalg[nm]['abrv']
       #rmp('cyan','ttttttttttttttttttttttttttttttttttttttttttttttt 1 ',3)
       return cev
   else:
       cev['cerr'] = mgb['sucs']
       return cev
  except Exception as ee:
   mpr('f_fapbin',ee)


def f_fapbout(cev):
    try:
        nm = 'fapbout'
       # mp('yellow', 'f_fapbout nm=' + nm + ' /cev=' + str(cev))
        if mgbalg[nm]['actual'] == False:
            cev['cerr'] = mgb['sucs']
            cev['abrv'] = mgbalg[nm]['abrv']
            return cev
        if cev['fckp'] =='False':
            cev['cerr'] = mgb['sucs']
            cev['abrv'] = mgbalg[nm]['abrv']
            return cev
        if cev['fckp'] =='True' and cev['ioflag']=='True':
            cev['cerr'] = mgb['sucs']
            cev['abrv'] = mgbalg[nm]['abrv']
            return cev

        s = 'select count(*) from tss_passes where keycode=' + str(cev['code']) + \
            ' and fckp=True and ioflag=False'
        cr = readfld(s)
        rmp('cyan', 'nm=' + nm + ' /s=' + s + ' /cr=' + str(cr), 3)
        if cr > 0:
            cev['cerr'] = str(mgbalg[nm]['cerr'])
            cev['abrv'] = mgbalg[nm]['abrv']
            return cev
        return cev
    except Exception as ee:
        mpr('f_fapbout', ee)
def calct():
    t=gfunc.mytime()[0:8]
    t=gfunc.zerol(t,8)
    return t

def f_ftmz(cev):

   cev['cerr']=mgb['sucs']
   nm='ftmz'
   if mgbalg[nm]['actual'] == False:
    cev['cerr'] = mgb['sucs']
    cev['abrv'] = mgbalg[nm]['abrv']
    return cev

   t=calct()
   nz=str(cev['ntmz'])
  # mp('red','nm='+nm+' cev='+str(cev))
   #s='select  count(*)  from tss_tmz where    ntmz ='+str(cev['ntmz'])+\
   #'  and '+ ap+t+ap+\
   #' between  t1 and t2'
   s='select count(*) from tss_tmzvst '+\
   ' where '+\
   ' name = '+ap+nz+ap+\
   ' and zapret = false '+\
   ' and '+ap+t+ap+\
   ' between '+\
   ' start and stop '


   mp('lime', s)
   cr=int(readfld(s))
   if cr==0:
    cev['cerr'] = str(mgbalg[nm]['cerr'])
    cev['abrv'] = mgbalg[nm]['abrv']
    return cev
   else:
    cev['cerr'] = mgb['sucs']
    cev['abrv'] = mgbalg[nm]['abrv']
    return cev

def delmulti(lsg):
    try:
      for g in lsg:
       fio=g['fio']
       s = 'select myid from tss_persons where bpkeys='+\
         str(g['fio']['bpkeys'])
       mp('yellow',s)
       loc = readrow(s)
       ls=[]
       for row in loc:
        myid=str(row[0])
        ls.append(myid)
       if len(ls)>1:ls.pop(0)
       mp('lime',str(ls))
    except Exception as ee:
     mpr('delmulti',ee)


def updkeys(bpkeys,bidpers):
    s='update tss_keys set bppers='+bidpers +\
    ' where myid='+bpkeys
    mp('white',s)
    selfupd(s)

def fromls_loccode():
    rmp('magenta', 'fromls_loccode', 10)
    appdir = gfunc.getmydir()

    fn = appdir + 'loccode.txt'
    mp('lime', 'fn=' + fn)
    mp('red', 'fn=' + fn)
    inp = open(fn, 'r')
    ls = inp.readlines()
    mp('red', 'l================' + str(len(ls)))
    pgc = pgconn
    curs = pgc.cursor()
    s = 'delete from tssloc_loccode'
    curs.execute(s)
    pgc.commit()
    for s in ls:
        #s = loccode + zp + name
        lss = s.split(',')
        loccode = str(lss[0])
        name = lss[1]
        l = len(name)
        fio = name[0:l - 1]
        s = 'insert into tssloc_loccode(loccode,name)values(' + \
        loccode + zp + \
        ap+name+ap+')'
        mp('yellow','s='+s)
        curs.execute(s)
    pgc.commit()

def tols_loccode():
    s = 'select distinct loccode,name    from tssloc_loccode '
    loc = readrow(s)
    ls = []
    for row in loc:
        s = ''
        loccode = str(row[0])
        name = str(row[1])
        s = loccode + zp + name
        mp('yellow', 'name=' + name)
        s = s.strip()
        s = s + '\n'
        s = s.strip()
        s = s + '\n'
        print('s=', s)
        if s != '': ls.append(s)

    appdir = gfunc.getmydir()
    fn = appdir + 'loccode.txt'
    mp('lime', 'fn=' + fn)
    outp = open(fn, 'w')
    outp.writelines(ls)
    outp.flush()
    outp.close()


def tolsfile():
  s='select distinct bpkeys,mrs,fio,ntmz    from tss_persons '
  loc = readrow(s)
  ls = []
  for row in loc:
    s=''
    bpkeys = str(row[0])
    mrs    = str(row[1])
    fio    = row[2]
    ntmz   = str(row[3])
    s=bpkeys+zp+mrs+zp+ntmz+zp+fio
    mp('yellow','fio='+fio)
    s=s.strip()
    s=s+'\n'
    print ('s=',s)
    if s!='': ls.append(s)
  appdir=gfunc.getmydir()
  fn=appdir+'persons.txt'
  mp('lime','fn='+fn)
  outp=open(fn,'w')
  outp.writelines(ls)
  outp.flush()
  outp.close()
  inp=open(fn,'r')
  ls=inp.readlines()
  for s in ls:
   mp('cyan','s='+s)
 # fromslstopers()



def checkmultipers():
#select  *    from tss_persons  order by fio
    try:
     s='select  distinct fio,bpkeys from tss_persons'
     loc=readrow(s)
     lsg1=[]
     for row in loc:
      g={}
      fio   = row[0]
      bpkeys= str(row[1])
      g['fio'] =fio
      g['fio']={}
      g['fio']['bpkeys']=bpkeys
      lsg1.append(g)
     delmulti(lsg1)


    except Exception as ee:
     mpr('checkmultipers',ee)




def addgls(g,n):
    for i in range(1,1000,1):
     k=str(i)
     g[k]=str(i)
    return g

def updpassaccu(cev):
   try:
    #mp('lime','updpassaccu cev='+str(cev))
    s='select count(*) from tss_pasaccu where '\
    ' keycode='+str(cev['code'])+\
    ' and bidlocsens='+str(cev['bidlocsens'])
    #mp('red','updpassaccu s=')
    #mp('yellow','s='+s)
    rc=int(readfld(s))
    if rc>0:
        s = 'update  tss_pasaccu' + \
         ' set keycode='+ str(cev['code']) +zp+ \
         ' bidpers='+  str(cev['bidpers']) + zp + \
         ' bidlocsens='+ str(cev['bidlocsens'])
       # mp('red','updpassaccu='+s)
        selfupd(s)
    return rc
   except Exception as ee:
    mpr('updpassaccu',ee)
    return None

def topasaccu(cev):

    try:
        return
        if mbrgg['ip']!= 'home':
         return
        else:
         pass
        rc=updpassaccu(cev)
        if rc !=None and rc>0:return
        # rmp('li
        #
        #
        #
        # me','tobases start sssssssssssssssssssssssssssss',1)
        bid, bidloc = findinpasses(cev['bidlocsens'], cev['code'])
        # rmp('yellow','topasses AFTER FINDIN bid='+str(bid),2)
        uxt = str(stofunc.nowtosec('loc'))
        s = 'insert into tss_pasaccu' + \
        ' (bidpers,bidlocsens,keycode)values(' + \
        str(cev['bidpers']) + zp + \
        str(cev['bidlocsens']) + zp + \
        str(cev['code'])+\
        ')'
        mp('red','Topasaccu=s='+s)

        selfupd(s)



         #   s = 'update tss_passes set uxt=' + uxt + ' where myid=' + str(bid)
            # rmp('yellow', 'topasses=' + s, 2)
         #   selfupd(s)
    except Exception as ee:
        mpr('topasaccu', ee)

def tobasses(cev):

 topasaccu(cev)
 '''
    'sens':
    'key',
    'dt': '2023-6-8 5:22:21',
    'delta': '1',
    'no': '14972',
    'ac': '77',
    'port': '2',
    'evid': '48.168.232.14972',
    'evpid': '48.168.232.2',
    'kluch': '0000007716AA',
    'Ikluch': '00000388E955',
    'code': '7804586',
    'kpx': 'kpx',
    'ik': 59304277,
    'rsendstate': '0',
    'cmd': 'tosyslog',
    'subcmd':
    'tosyslog',
    'rpcchname': 'drv209_192.168.0.96',
    'uxt1': 1686190942,
    'almm1': '22.286377',
    'bidac': '232',
    'bidsens': '1309',
    'locat': 'tambur',
    'ioflag': 'True',
    'fckp': 'False',
    'tmr': '1',
    'smrn': '1,2,3',
    'tol': '-1',
    'mol': '-1',
    'prevtag': '1',
    'prevname': 'ЭТАЖ 1',
    'prevbidloc': '2481',
    'bidlocsens': '2580',
    'bidlocparent': '2510',
    'cerr': '0',
    'md1': '1686190942',
    'fio': 'Testov Test Testovich',
    'abrv': 'ok',
    'duralg': '0',
    'target': 'writerlog'
  w
  '''
 try:

     #mp('red','TOBASSES='+str(cev))
     bid,bidloc=findinpasses(cev['bidlocsens'],cev['code'])
     #bid=-1  #suda
     #bidloc=-1 #suda
     #rmp('yellow','topasses AFTER FINDIN bid='+str(bid),2)
     uxt=str(stofunc.nowtosec('loc'))
     if bid==0:
      cev['poglg']='true'
      cev['fckp']='false'
      s='insert into tss_passes'+\
        ' (bidpers,bidlocsens,uxt,keycode,fckp,ioflag)values(' + \
        str(cev['bidpers']) + zp + \
        str(cev['bidlocsens'])+zp+\
        uxt+zp+\
        str(cev['code'])+zp+\
        cev['fckp']+zp+\
        cev['ioflag']+')'
      s = s.replace('\x0d\x0a', '')
      selfupd(s)
     if bid>0:
      s='update tss_passes set uxt='+uxt +' where myid='+str(bid)
      #rmp('red', 'topasses=' + s,2)
      selfupd(s)
 except Exception as ee:
  mp('magenta','?????????????????? s='+s)
  rmp('magenta', '???????????????? cev=' + str(cev))
  mpr('tobases',ee)



def findinpasses(bls,code):
 # резулmт bid,bidloc
  try:
    bid=0
    bidloc=0
    s='select myid,bidlocsens from tss_passes where keycode='+str(code)
   # rmp('cyan','findinpasses='+s,1)
    loc=readrow(s)
    for row in loc:
     bid=row[0]
     bidloc = row[1]
    # rmp('lime','findinpasses s='+s+' /bid='+str(bid)+'/bidloc='+str(bidloc),2)
    return bid,bidloc
  except Exception as ee:
   mpr(findinpasses,ee)
   return -1,-1

def delfrompass(cev):
    #mp('magenta','delfrompass='+str(cev))
    if cev['fckp'] != 'True':return
    rmp('lime', 'delfrompass fckp=' + cev['fckp']+' ioflag='+cev['ioflag'],1)
    if cev['ioflag'] == 'True':
     s='delete from tss_passes where keycode='+str(cev['code'])+\
       ' and ioflag=False'\
       ' and fckp=True'
     rmp('lime', 's ВЫХОДЫ =' +s,5)
    if cev['ioflag'] == 'False':
     s='delete from tss_passes where keycode=' + str(cev['code']) + \
       ' and fckp=True'\
       ' and ioflag=True'
     rmp('yellow','ВХОДЫ ЧЕРЕЗ ПРОХОДНУЮ s='+s,5)
     selfupd(s)



def f_final(cev):
  try:
   # rmp('magenta','start final',20)
    cev['cerr']=mgb['sucs']
    cev['abrv']='ok'
   # mp('lime','FINAL cev='+str(cev))
    formirkeyrte(cev)
    md2 = stofunc.nowtosec('loc')
    md1=int(cev['md1'])
    d = md2-md1
    cev['duralg']=str(d)
   # mp('yellow','ADELTA='+str(cev))

    wrcev(cev)
    tobasses(cev)
    delfrompass(cev)
    return cev
  except Exception as ee:
    mpr('f_final', ee)

  '''
    g={}
    g['cmd']='OXSANA'
    g['subcmd']='OXSANA'
  
    s='1'
    g['fio']='гонсовский жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж'
    g=addgls(g,100)
    clientftpsrv.send(g,'writerlog')
 '''


def fillglsportparam(id):
   try:
       #return
       pgc = pgconn
       curs = pgc.cursor()

       #s = 'SELECT  from tss_ports and tssloc_locations  suda
       # print ('s=',s)
       curs.execute(s)
       loc = curs.fetchall()
       ls = []
       g = {}
       for row in loc:
           name = str(row[0].strip())
   except Exception as ee:
    mpr(' fillglsportparam',ee)

def formirportinfo(cev):
    try:
     s=cev['evid']
     ls=s.split('.')
     id=ls[0]+'.'+ls[1]+'.'+ls[2]+'.'+str(cev['port'])
     if not id in glsportparam.keys():
      glsportparam[id]={}
     else: pass
     fillglsportparam(id)
    except Exception as ee:
     mpr('formirportinfo',ee)


def wrcev(cev):
   try:

       cev['compuxt']=str(stofunc.nowtosec('loc'))
       cev['no']=str(cev['no'])
       cev['bidlocsens']=str(cev['bidlocsens'])
       g={}
       if cev['sens'] !='key':
        if cev['kpx']=='kpx':
            s='insert into tss_syslog(bidlocsens,no,compuxt)values('+\
            cev['bidlocsens']+zp+\
            cev['no']+zp+\
            cev['compuxt']+')'
            g = {}
            g['cmd'] = 'stosyslog'
            g['komu'] = 'malwrlog'
            g['line'] = s
            mp('lime', 'KPX =' + str(g))
            lsgto.append(g)
        else:
            s='insert into tss_syslog(bidlocsens,no,contuxt,compuxt)values('+ \
            cev['bidlocsens']+zp+\
            cev['no']+zp+\
            cev['contuxt']+zp+\
            cev['compuxt']+')'
            g={}
            g['cmd']='stosyslog'
            g['komu']='malwrlog'
            g['line']=s
            mp('yellow', 'AVT =' + str(g))
            lsgto.append(g)

   except Exception as ee:
    mprs('wrcev',ee)


def formir_glstojs(g):
   try:
    sj = json.dumps(g)
    topic=g['komu']
    mbqt['mqtt'].publish(topic,sj)
    mp('blue','maldms SENDJS ='+str(g))
   except Exception as ee:
    mpr('glstojs',ee)


def calc_open(cev):
  wrcev(cev)

def calc_close(cev):
    wrcev(cev)

def calc_rte(cev):
    wrcev(cev)
    ''' 
    if cev['kpx']=='kpx':
     formirkeyrte(cev)
     cev['cerr']=mgb['sucs']
     wrcev(cev)
   '''

def getbidsens(gin,cs):
  try:
    s='select '+\
    ' s.myid, s.code'+ \
    ' from tss_acl as ac, tss_ports as p, tss_sensors as s '+\
    ' where '+\
    ' ac.ac = '+str(gin['ac'])+\
    ' and p.nump ='+ str(gin['port'])+\
    ' and s.bp = p.myid'+\
    ' and p.bp = ac.myid'+\
    ' and s.code ='+str(cs)
   # mp('blue','getbidsens s='+s)
    loc = readrow(s)
    if loc==None:
     rmp('red','loc=none',20)
     return 0
    #mp('red','loc='+str(loc)[0:80])
    f = False
    for row in loc:
        f = True
        gin['bidsens'] = str(row[0])
        return gin['bidsens']
    return None
  except Exception as ee:
   mpr('getbidsens',ee)

def getportinfo(gin):
  try:
    nump=str(gin['port'])
    if gin['sens'] == 'key':
        cs = '1'
        return gin
    if gin['sens'] == 'open': cs = '2'
    if gin['sens'] == 'close': cs = '3'
    if gin['sens'] == 'rte': cs = '4'

    s=' select     lc.ioflag, lcp.name, lc.tmr,' \
    ' lc.fckp, lc.myid, lcp.myid, lcp.tag'\
    ' from tss_ports as pt,'\
    ' tssloc_locations as lc, tssloc_locations as lcp'\
    ' where  lc.code ='+cs+' '\
    ' and pt.nump ='+nump+' '\
    ' and lc.bidport = pt.myid'\
    ' and lcp.myid = lc.bp'
   # mp('red','getportinfo SENS='+gin['sens']+' s='+s)
    loc = readrow(s)
    for row in loc:
        gin['ioflag'] = str(row[0])
        gin['locat'] = row[1]
        gin['tmr'] = str(row[2])
        gin['fckp'] = str(row[3])
        gin['bidlocsens'] = str(row[4])
        gin['bidlocparent'] = str(row[5])
        gin['prevtag'] = str(row[6])
   # mp('yellow','getportinfo='+str(gin))

    return gin
  except Exception as ee:
   mpr('getportinfo',ee)


#lcp.myid - bidlocparent
#lc.myid - bidlocsens
#lcp.tag - prevtag



def calcportinfo(gin):
  try:
   # mp('blue','calcportinfo start           ?????????????????')
    no=str(gin['no'])
    if gin['sens'] =='key'   : cs ='1'
    if gin['sens'] == 'open' : cs = '2'
    if gin['sens'] == 'close': cs = '3'
    if gin['sens'] == 'rte'  : cs = '4'
    gin['bidsens']=getbidsens(gin,cs)
    if gin['bidsens'] != None:
        pass
        s='select  t2.name,t3.name,t3.ioflag,t3.fckp,t3.tmr,t3.smrn,t3.tol,t3.mol '+\
        ',t1.tag,t1.name,t2.bp '+\
        ',sl.bidlocsens,t2.myid '+\
        ',t2.bidowner '+\
        ' from '+\
        ' tssloc_locations as t2 ,tssloc_locations as t3,tssloc_locations as t1,'+\
        ' tss_acl as acl, '+\
        ' tss_ports as pt,'+\
        ' tss_sensorlinks as sl'+\
        ' where pt.nump='+str(gin['port'])+ \
        ' and acl.ac = '+str(gin['ac'])+ \
        ' and pt.bp = acl.myid '+\
        ' and t2.myid=t3.bp '+\
        ' and t3.code ='+cs+\
        ' and pt.myid=t3.bpp'+\
        ' and t1.myid=t2.bp'+\
        ' and t3.myid=sl.bidlocsens '
       # mp('white', 'calcportinfo===='+s)
        loc = readrow(s)

    f=False
    for row in loc:
     f=True
     gin['locat']=row[0]
     gin['ioflag']  =str(row[2])
     gin['fckp'] =str(row[3])
     gin['tmr'] = str(row[4])
     #if not 'evtyp' in gin.keys():
     gin['smrn'] = str(row[5])
     gin['tol'] = str(row[6])
     gin['mol'] = str(row[7])
     gin['prevtag']=str(row[8])
     gin['prevname'] = str(row[9])
     gin['prevbidloc'] =str(row[10])
     gin['bidlocsens'] = str(row[11])
     gin['bidlocparent'] = str(row[12])
     gin['bidowner'] = str(row[13])
     mp('cyan', 'bidlocsens=' + gin['bidlocsens'])
     mp('cyan','bidlocparent='+gin['bidlocparent'])
    # mp('cyan','FPI tol='+str(gin['tol'])+zp+'mol='+str(gin['mol']))
     #mp('cyan','FPI ptag=' + str(gin['prevtag']) + zp +' prevname='+gin['prevname']+\
     #   ',prevbidloc='+ gin['prevbidloc'])
     gin['cmd'] = 'tosyslog'
     gin['subcmd'] = 'tosyslog'
    # mp('yellow','calcportinfo FIND OK gin='+str(gin))
     formirroad(gin, 'comcentr', 'js')

    if f==False:
     # rmp('cyan','FPI NOT no ='+no,1)
      #gin['kluch'] = 'undef'
      gin['locat'] ='undef'
      gin['fio']   = 'undef'
      gin['ioflag'] ='False'
      gin['fckp'] = 'False'
      gin['tmr'] = '3'
      gin['cmd'] = 'tosyslog'
      gin['subcmd'] = 'tosyslog'
      gin['rcp']='-999'
      gin['cerr'] = '-999'
     # mp('cyan', 'calcportinfo NOT FIND gin=' + str(gin))
      formirroad(gin, 'comcentr', 'js')
    return gin
  except Exception  as ee:
    mpr('formirportinfo',ee)
    return gin

def getalgactual(nm):
  try:
   s='select actual from tss_algol where name='+ap+nm+ap
   v=readfld(s)
   s = 'name=%10s,value=%10s' \
       % (nm, str(v))
  # mp('white', 'getalgactual=' + s)
   return v

  except Exception as ee:
   mpr('getalgactual',ee)


def readrggons():
    s=''

def calc0(cev):
    #print ('calc0 start sens= '+cev['sens']+',port='+str(cev['port'])+',no='+str(cev['no']))
    if 'sens' not in cev.keys():
     return cev

    if cev['sens']=='key':
     pass
    #mp('blue','calc0='+str(cev))
    t1 = gfunc.mymarker()
    #cev=calcportinfo(cev)
    t2 = gfunc.mymarker()
    d = str(gfunc.mymarkerdelta(t1,t2))
   # mp('cyan','CALC0 AFTER calcportinfo DUR='+d)
    clearlsgitog()
    #mp('magenta', 'calc0 1')
    if 'evpid' in cev.keys():
        #mp('magenta', 'calc0 2')
        s=cev['evpid']
        ls=s.split('.')
        bidcomp=ls[0]
        bidch=ls[1]
        bidac=ls[2]
        port=cev['port']
        #cev['bidcomp']=bidcomp
        #cev['bidch'] =bidch
        #cev['bidac'] =bidac'
        clearlsgitog()
       # mp('yellow','calc0 start  ')
        cev['cerr'] = '0'

    if cev['sens']== 'open':
      calc_open(cev)




    if cev['sens']== 'close':
       calc_close(cev)

    if cev['sens'] == 'rte':
     calc_rte(cev)
    if cev['sens'] == 'key':
      # mp('yellow','KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK')
       md1=gfunc.mymarker()
       md1=stofunc.nowtosec('loc')
       cev['md1']=str(md1)
       for nm in mbalgol['list']:
         mp('yellow','nm AAAAAAAAAAAAAAAAAAAAA=================='+str(nm))
         f=mgbalg[nm]['namefunc']
         f=f.strip()
         if f !='':
          f=f+'(cev)'
          try:
          # mp('yellow','nm='+nm+',f='+f+' BEFORE EVAL EEEEEEEEEEEEEEEEEEEEEVVVVV')
           if mbrgg['ip']=='home':
             mgbalg[nm]['actual']=getalgactual(nm)
           cev=eval(f)
           #rmp('yellow','AFTER   AAAAAAAAAAAAAAAA NM='+nm+ 'CERR='+str(cev['cerr']),1)
           #mp('blue','nm='+nm+',f='+f+'AFTER EVAL CERR====================================='+str(cev['cerr']))
           if cev['cerr'] !=mgb['sucs']:
            wrcev(cev)
            return cev
          except Exception as ee:
           mpr('calc0 ,f='+f,ee)

       rmp('white','EVAL DELTA='+str(d),2)
       #return cev


def timerlsgto(interval):
    while True:
     gevent.sleep(interval)
     if len(lsgto)>0:
      g=lsgto.pop(0)
      formir_glstojs(g)


     # mp('yellow','SEND='+str(g))



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
    rmp('magenta','AFTER connecttobroker ='+host,3)
    mbqt['mqtt']=mqclient
    return mqclient

def onmesmqtt(client, userdata, message):
    #gevent.sleep(0.01) #sudasleep
    js=message.payload.decode("utf-8")

    try:
     g=json.loads(js)
     if not 'cmd' in g.keys():return
     if  g['cmd']=='stosyslog':
      mp('lime','???????onmes komu='+g['komu']+' ,'+str(g))


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

#==================mgbs================================
p=chr(0x27)
ap=chr(0x27)
zp=','
lsgtodms=[]
lstowrlog=[]
lstopics=[]
mgb={}
mbqt={}
mgb['sucs']='0'
tasks=[]
gprm={}
lsgto=[]
gprm['-ch']='mqtest'
mbalgol={}

lsginev=[]  # list of events
glsportparam={}
lsgitog=[]
lstocomcentr=[]
startline=calcstartline()



gprm=gsfunc.gonsgetp()
gprm['-ch']='mqtest'
mp('magenta','gprm='+str(gprm))

pt=gfunc.calcptstarter()
mp('yellow','pt='+pt)

mgb['vbstarter']=gfunc.opendb3(pt,'r')
vb=mgb['vbstarter']
mysysinfo=gfunc.readstarter(vb)
mbrgg=mysysinfo['rggons']
mp('magenta','mbrgg='+str(mbrgg))

mp('cyan','base='+str(mysysinfo['base']))
cid='mqtest'
mgb['cid']=cid
mp('cyan','transport='+str(mysysinfo['transport']))
mp('cyan','comcentr='+str(mysysinfo['comcentr']))
mqclient=connecttobroker(cid,mysysinfo['transport']['ip'])
mbqt['mqtt']=mqclient
rc,ls=mysubscreibe('malwrlog')
if rc=='ok':
 mp('magenta','ls='+str(ls))


pgconn=fpgs_connect()
mgb['pgc']=pgconn
mp('red','start')
rmp('lime','after open base',5)

rmp('blue','joinall',5)
gevent.joinall(tasks)




