#!/usr/bin/env python
# -*- coding: utf-8 -*-
import zerorpc
import gevent
import traceback
import libtssacs as acs
import sys,os,platform
from gevent.queue import Queue
import gsfunc,stofunc

from os import path, sep
import hashlib

def loadimu(ac,pt):
   try:
     inp=open(pt,'r')
     ls=inp.readlines()
     lss=[]
     for s in ls:
      s=s.strip()
      if s<>'':
       s=s.replace('\r','')
       s=s.replace('\n','')
       lss.append(s)
     rmp('white','loadimu OK='+pt,5)
     return lss
   except Exception,ee:
    mpr('loadimu',ee)
    return lss


def diff_uc(ls1,ls2):
 try:
   ls=list(set(ls1) - set(ls2)) # vulgaris
   return ls
 except Exception,ee:
   mprs('diff_uc',ee)

def diff_cu(ls1,ls2):
 try:
   ls=list(set(ls2) - set(ls1)) # vulgaris
   # ls=list(set(ls1) ^ set(ls2))
   return ls
 except Exception,ee:
   mprs('diff_cu',ee)


def calccrc(pt):
   try:
     # mp('red','pt='+pt)
     f=hashlib.md5()
     f.update(open(pt).read())
     m1=geconfunc.mymarker()
     crc=f.hexdigest()
     return crc
   except Exception,ee:
    mpr('calccrc',ee)



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
  geconfunc.mpv(c,'M7FUNC. '+txt+'/ '+t)
 except : pass

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)



def checknewimu():
  try:
     # mp('cyan','checknewimu BEFORE BUZY   BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB')
     return
     if mgb['busy']==True :return
     pt1=mgbcpu['store']
     pt2='config'+sep+mgbcpu['host']+sep
     pt3=mgbcpu['ch']+sep
     # pt4='images'+sep
     pt=pt1+pt2+pt3
     # mp('red','checknewimu pt='+pt+' /addrs='+str(mgbcpu['addrs']))
     addrs=mgbcpu['addrs']
     for ac in mgbcpu['addrs']:
      fn='imu_'+str(ac)+'.txt'
      ptf=pt+str(ac)+sep+'images'+sep+fn
      # rmp('yellow','checknewimu ptf='+ptf,1)
      # if int(ac)==7:
      #  pass
       # mp('cyan','checknewimu='+ptf)
      if os.path.isfile(ptf):
       # rmp('lime','checknewimu call calccrc ptf='+ptf,1)
       crc=calccrc(ptf)
       calccrc2(ac,crc,ptf)
       # mp('cyan','ptf='+ptf+' /crc='+crc)
      else:
       pass
       # if int(ac)==7:
       #  mp('magenta','not file='+ptf)
  except Exception,ee:
   mpr('checknewimu',ee)

def calccrc2(ac,crc,ptf):
    # mp('cyan','calccrc2 start')
    if gcrc.has_key(ac):
      if gcrc[ac]==crc:
       # mp('white','EQU CRC EQU CRC')
       return
      gcrc[ac]=crc
      # mp('red','NOT EQU not equ crc')
      compar1(ac,ptf)
      return
    else:
      gcrc[ac]=crc
      # mp('white','new gcrc')
    return



def formirgonsmaska(ls):
 try:
  s=''
  for n in ls:
   s=s+str(n)
  return s
 except Exception,ee:
   mpr('formifgonsmaska',ee)




def formirlsc(lsc):
  try:
   lss=[]
   for t in lsc:
    code=t.code
    kl=geconfunc.xkeytos(code)
    mask=t.mask
    maska=formirgonsmaska(t.mask)
    s=kl+','+maska
    mp('magenta','formirlsc='+s)
    lss.append(s)
   return lss
  except Exception,ee:
   mpr('formirlsc',ee)


def formirmaskaslava(m):
  try:
   ls=[]
   for n in m:
    ls.append(int(n))
   return ls
  except Exception,ee:
    mpr('formirmaskaslava',ee)


def m77_addkey(gin):
    try:
     chskd=mgbcpu['chskd']

     key = acs.Key()

     kl=gin['kluch']
     ac=int(gin['ac'])
     maska=gin['gmaska']
     kl=geconfunc.zerol(kl,12)
     x=geconfunc.keytox(kl)
     key.code = x
     key.mask =formirmaskaslava(maska)        #[1,2,3,4,5,6,7,8]
     key.pers_cat = 1
     try:
       mp('red','chskd='+str(chskd))
       mp('red','m77_addkey ac='+str(ac)+' kl='+kl+','+maska+' 7777777777777777777777777777777777777')
       chskd.add_key(ac, key)
     except Exception,ee:
       mpr('m77_addkey 2 ',ee)


    except Exception,ee:
     mpr('m77_addkey main',ee)


def faddkey(ac,lsa):
   try:
    chskd=mgbcpu['chskd']
    for s in lsa:
     s=s.strip()
     f=True
     if s[0]=='#' or s[1]=='#':
      f=False
      rmp('red','faddkey='+s,20)
     if s<>'' and f:
         key = acs.Key()
         lss=s.split(',')
         kl=lss[0]
         maska=lss[1]
         kl=geconfunc.zerol(kl,12)
         x=geconfunc.keytox(kl)
         key.code = x
         key.mask =formirmaskaslava(maska)        #[1,2,3,4,5,6,7,8]
         key.pers_cat = 1
         try:

          chskd.add_key(ac, key)
          mp('yellow','faddkey kl='+kl+','+maska)
         except Exception,ee:
          mpr('faddkey',ee)
   except Exception,ee:
    mpr('faddkey',ee)







def fdelkey(ac,lsd):
   try:
    chskd=mgbcpu['chskd']
    for s in lsd:
     ls=s.split(',')
     kl=ls[0]
     mp('yellow','fdelkey kl='+kl)
     code=geconfunc.keytox(kl)
     mp('cyan','fdelkey delete kl='+kl)
     chskd.del_key(ac,code)
   except Exception,ee:
    mpr('fdelkey',ee)

def write_imc(ac,lsc):
   try:
     pt=mgbcpu['store']+'config'+sep+mgbcpu['host']+sep+'images'+sep+mgbcpu['ch']+sep

     fn='imc_'+str(ac)+'.txt'
     pt1=mgbcpu['store']
     pt2='config'+sep+mgbcpu['host']+sep
     pt3=mgbcpu['ch']+sep+str(ac)+sep
     pt4='images'+sep
     pt=pt1+pt2+pt3+pt4
     ptx=pt+fn
     geconfunc.mydeletefile(ptx)
     lss=[]
     for s in lsc:
      ss=s+'\n'
      lss.append(ss)
     lss.sort()
     outp=open(ptx,'w')
     outp.writelines(lss)
     outp.flush()
     outp.close()
     formirmes('write_imc',ac,fn)
     gevent.sleep(1)
     formirmes('write_imc',ac,fn)
     rmp('red','====================================================================',10)
   except Exception,ee:
    mpr('write_imc',ee)

def formirmes(typ,ac,fn):
  try:
   g={}
   g['imcfn']=fn
   g['type']=typ
   g['ac']=str(ac)
   shrbox.append(g)
  except Exception,ee:
   mpr('formirmes',ee)

def totrace(code,ac,msg,ptf):
   try:
    ptx=mgbcpu['store']+sep+'config'+sep+mgbcpu['host']+sep+mgbcpu['ch']+sep+str(ac)+sep+'trace'+sep+'trace.txt'
    outp=open(ptx,'a')
    dt=geconfunc.mydatezz()+' '+geconfunc.mytime()[0:8]
    outp.write(dt+';'+str(code)+';'+msg+';'+ptf+'\n')
    outp.flush()
    outp.close()
   except Exception,ee:
     mpr('totrace',ee)



def compar1(ac,ptf):
  try:
    # mp('red','compar1 ac='+str(ac)+' /ptf='+ptf)
    totrace(1,ac,'start of reloadconts',ptf)

    mgb['busy']=True
    m1=stofunc.nowtosec('loc')
    lsu=loadimu(ac,ptf)
    lsc=getallkeys(ac)
    lsc=formirlsc(lsc)
    lsa=diff_uc(lsu,lsc)
    la=str(len(lsa))
    lsd=diff_cu(lsu,lsc)
    ld=str(len(lsd))
    fdelkey(ac,lsd)
    faddkey(ac,lsa)

    lsc=getallkeys(ac)
    lsc=formirlsc(lsc)
    write_imc(ac,lsc)
    mp('red','compar1 END COMPAR AND RELOAD')
    m2=stofunc.nowtosec('loc')
    d=m2-m1
    rmp('red','compar1 DELTA M2-M1='+str(d),5)
    mgb['busy']=False
    totrace(37,ac,'end of reloadconts time=='+str(d)+' sec.',ptf)

  except Exception,ee:
   mgb['busy']=False
   mpr('compar1',ee)


def   checkmount():
    try:
     ip=mgbcpu['host']
     pt=mgbcpu['store']+'config'+sep+ip+sep+'life'+sep+'life.txt'
     # mp('yellow','checkmount pt='+pt)
     outp=open(pt,'w')
     s1=geconfunc.mydatezz()
     s2=' '+geconfunc.mytime()[0:8]
     s=s1+s2
     outp.write(s)
     outp.flush()
     outp.close()
    except Exception,ee:
      mpr('checkmount NEW',ee)


def timer_imu(interval):
    while True:
     gevent.sleep(interval)
     # mp('cyan','timer_imu >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')

     if mgb['timerimu']:
      pass
      # checknewimu()
      # mp('yellow',mgbcpu['store']+' / '+mgbcpu['os'])
      # if mgbcpu.has_key('addrs'):
      #    addrs=mgbcpu['addrs']
      #    mp('yellow','addrs='+str(addrs))
      #    mp('yellow','ch='+mgbcpu['ch'])

def get_acproginfo(ch,ac):
    try:
     g={}
     g['pv']=ch.prog_ver(ac)
     g['pid']=ch.prog_id(ac)
     return g
    except Exception,ee:
      mpr('get_acproginfo',ee)


def delallkeys(ac):
  chskd=mgbcpu['chskd']
  try:
   chskd.del_all_keys(ac)
  except Exception,ee:
   mpr('delallkeys',ee)

def getallkeys(ac):
  try:
   chskd=mgbcpu['chskd']
   gevent.sleep(5)
   totrace(30,ac,'attempt readkeysinfo','')
   kinf=chskd.keys_info(ac)
   rmp('red','kinf='+str(kinf),1)
   totrace(31,ac,'end of readkeysinfo kinf='+str(kinf),'')
   mp('yellow','getallkeys waiting wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww')
   gevent.sleep(5)
   for i in range(1,11,1):
    try:
     totrace(35,ac,'attempt readallkeys','')
     ls=chskd.read_all_keys(ac)
     totrace(36,ac,'end readallkeys','')
     break
    except Exception,ee:
     totrace(999,ac,'error',str(ee))
     mprs('getallkeys i='+str(i),ee)
     if str(ee)=='failed' :
      rmp('red','call delallkeys dddddddddddddddddddddddddddddddddddddd',5)
      totrace(33,ac,'deleteallkeys','')
      delallkeys(ac)
      gevent.sleep(1)
      gcrc[ac]=None
      break

   for t in ls:
    mp('yellow',str(t))
   return ls
  except Exception,ee:
   mpr('getallkeys',ee)
   return None

def win_getmac():
  try:
   fn='winmaca.txt'
   appdir=geconfunc.getmydir()
   pt=appdir+fn
   s='getmac>'+pt
   # rmp('red','s='+s,3)
   os.system(s)
   gevent.sleep(5)
   # rmp('red','AFTERSLEEP=',3)

   if os.path.isfile(pt):
    inp=open(pt,'r')
    ls=inp.readlines()
    # for s in ls:
    l=len(ls)
    lss=ls[l-1]
    lss=lss.split(' ')
    maca=lss[0]
    maca=maca.replace('-',':')
    # rmp('red','win_getmac maca='+maca,3)
    return maca
  except Exception,ee:
   mpr('win_getmac',ee)



# =====================================================
mgb={}
mgb['busy']=False
addrs=[]
mgbcpu={}
gcrc={}
shrbox=[]
mgb['timerimu']=True
mgb['timerimu']=False
tasks=[]
rmp('red','start ',1)

# while  mgb['timerimu']==False:
#   gevent.sleep(1)
#   mp('white','waiting timerimu')
#


task=gevent.spawn(timer_imu,3)
tasks.append(task)

