#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#import zerorpc
import gevent
import traceback,datetime
import libtssacs as acs
import sys,os,platform
from gevent.queue import Queue
import gfunc,gsfunc,stofunc
import socket
from os import path, sep
import smbus




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
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  s ='ch=%10s,%10s' \
      % (ch,txt)
  if c=='t':
   print (s)
   testlog(txt)
   return
  if c != 't':
      gfunc.mpv(c, s)
      #gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
      if c == 'red':
        #redlog(txt)
        return
      if c == 'magenta':
          #magentalog(txt)
          return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)





def cr422():
   try:
    ch='422'
    chskd = acs.ChannelRS422()
    rmp('lime', 'pcreatech ch=' + str(ch),3)
    return chskd
   except Exception as ee:
    mprs('crip422',ee)

#========================mgbs=========================================
mgb={}
gprm={}
nmmod='p27acs'
gprm['-ch']=nmmod
mp('yellow','START cr')
chskd=cr422()
if chskd==None:
 rmp('red','cr422  BAD CHANELL',10)
 sys.exit(99)
mp('yellow','START find addrs')
ls=chskd.find_addrs()
addr=ls[0]
dt=chskd.get_dt()
mp('lime', 'dt=' + str(dt))
for t in ls:
 mp('lime','code='+str(t.code))

