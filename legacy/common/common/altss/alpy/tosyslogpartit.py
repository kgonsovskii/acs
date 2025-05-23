#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time

import stofunc,gsfunc,gfunc
import gevent,traceback
from gevent.queue import Queue
from os import path, sep
import psycopg2
import base64
import json,subprocess
import paho.mqtt.client as mqtt
import time
import calendar
from calendar import monthrange




def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='dms'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
    pass
    #redlog(txt)
    return
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)





def fpgs_connect(host,dbn,psw):
 try:
  conn = psycopg2.connect(
    host    =host,
    database=dbn,
    user="postgres",
    port=5432,
    password=psw)
  rmp('lime','PGS CONNECT='+host,5)
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


def getmonthdays(y,m):
       days = monthrange(y, m)[1]
       return  days



def is_leap(year):
    return calendar.isleap(year)

def days_in_year(year):
    return 366 if is_leap(year) else 365

def newcd(cd):
   try:
    cd += datetime.timedelta(days=1)
    return cd
   except Exception as ee:
    mprs('newcd',ee)

def currday():
 from datetime import date
 cd = date.today()
 return cd


def readrow(s):
   try:
   # pgconn = fpgs_connect()
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
    return loc
   except Exception as ee:
     mp('red','readrow s???='+s)
     mpr('readrow2',ee)

def formirtobase(cdz,nn):
  kx=1
  bls=1
  try:
    curs = pgconn.cursor()
    for n in range(1,nn+1, 1):
        compuxt= stofunc.nowtosec('loc')
        s = 'insert into tss_syslog (cdate,no,keycode,bidlocsens,compuxt)values(' + \
        ap+str(cdz)+ap + zp + ' ' + \
        str(n) + zp + ' ' + \
        str(kx) + zp + ' ' + \
        str(bls) + zp + ' ' + \
        str(compuxt) + ' ' + \
        ')'
        curs.execute(s)
        mp('white','=' + s)
    pgconn.commit()
  except Exception as ee:
     mprs('selfupd', ee)


def formir1():
    y1=int(gprm['-y1'])
    cdx = datetime.date(y1, 1,1)
    y2 =y1+1
    cd = newcd(cdx)
    for y in range(y1,y2,1):
     for m in range(1,13,1):
      ds=getmonthdays(y,m)
      for d in range(1,ds+1,1):
       kx=d
       bls=1
       compuxt=stofunc.nowtosec('loc')
       cdz=datetime.date(y,m,d)
       mp('yellow', 'FORMIR1 cdz=' + str(cdz))
       formirtobase(cdz,int(gprm['-ind']))



#==========================mgbs===============================
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
gprm=gfunc.gonsgetp()
mp('magenta','gprm='+str(gprm))
gprm['-ch']='tosyslogpartit'




pgconn=fpgs_connect(gprm['-ip'],gprm['-nm'],gprm['-psw'])
formir1()


gprm=gsfunc.gonsgetp()
