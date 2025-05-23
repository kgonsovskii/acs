#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import stofunc,gsfunc,gfunc
import gevent,traceback
from gevent.queue import Queue
from os import path, sep
import psycopg2
#import base64
import json,subprocess
#import socket
import time



def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)




def redlog(txt):
    return
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
    tscd=gfunc.mytscd()
    mp('yellow','toredbasetscd='+tscd)
    ctime=gfunc.mytime()[0:8]
    s='insert into tss_redlog(tscd,typ,app,txt)values ('+\
    ap+tscd+ap+zp+\
    str(typ)+zp+\
    ap+app+ap+zp+ap+txt+ap+')'
   # mp('blue','toredbase s='+s)

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
    redlog(txt)
    return
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)








def pgsopen (ip,psw,portn):
 try:
  conn = psycopg2.connect(
    host    =ip,
    database='postgres',
    user='postgres',
    port=portn,
    password=psw)

  rmp('lime','OPENBASE OK='+ip,2)
  return conn
 except Exception as ee:
   mpr ('ERROR ON=fpgs_connect EE=',ee)



def readfld(line):
  try:
  # mp('blue','readfld line='+line)
   loc=readrow(line)
   for row in loc:
    return row[0]
   return None
  except Exception as ee:
   mpr('readfld',ee)


def readrow(s):
   try:
   # pgconn = fpgs_connect()
    pgc = mgb['pgs']
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






#=======================mgbs=============================

ap=chr(0x27)
zp=','
tasks = []
mgb={}
gprm={}
gprm['-ch']='marswork'
mp('yellow','start')
mgb['pgs']=pgsopen('100.82.117.99','DjonaMallaSas',5432)
s='select name3 from tss_persinfo'
loc=readrow(s)
#0ksys.exit(99)
for row in loc:
 nm=row[0]
 mp('lime','name3='+nm)







