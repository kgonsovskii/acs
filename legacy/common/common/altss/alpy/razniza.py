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
import base64
import json,subprocess
import fdb




def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)


def mp(c,txt):
 try:
  # spid=mgb['spid']
  if not '-ch' in gprm.keys():
   ch='testdms'
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



#===========================================================
mgb={}
ls1= [1,2,3]
ls2= [3,4,5,6]
d1,d2=diff(ls1,ls2)
print ('В LS1 НЕТ =',d2)

d1,d2=diff(ls2,ls1)
print ('В LS2 НЕТ =',d2)




