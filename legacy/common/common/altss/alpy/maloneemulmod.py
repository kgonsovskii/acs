#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import gevent
import datetime
import sys,time,os,traceback,time
import stofunc,gsfunc,gfunc
from os import path, sep



def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)



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


def formirfix(g):
    cev= {}
    cev['chx'] = g['ch']
    cev['cmd'] = 'todmsev'
    cev['module'] = 'malemul'
    cev['ac'] = str(g['ac'])
    cev['sens'] = g['sens']
    cev['kpx'] = 'kpx'
    cev['port'] = str(g['port'])
    cev['contuxt'] = str(stofunc.nowtosec('loc'))
    cev['no'] =str(g['no'])
    return cev

def getparam(gin):
  try:
    g={}
    g['ch']=gin['ch']
    g['ac']=gin['ac']
    g['port']=gin['port']
    g['sens']=gin['sens']
    g['no'] = gin['no']
    if g['sens']=='key':
     g['kluch']=gin['kluch']
     g['code']=gin['code']
     cev=formirkey(g)
     mp('lime','GETPARAM cev='+str(cev))
     return cev

  except Exception as ee:
   mpr('getparam',ee)


def formirkey(gin):
    cev=formirfix(gin)
    return cev



#======================mgbs=============================
mgb={}
gprm={}
tasks=[]
gprm['-ch']='maloneemulmod'
mp('yellow','start')

#task = gevent.spawn(timerwork,3)
#tasks.append(task)

rmp('cyan','joinall',5)
gevent.joinall(tasks)

