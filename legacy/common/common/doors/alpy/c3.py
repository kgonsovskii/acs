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
import json,subprocess

def mp(c,txt):
 try:
  # spid=mgb['spid']
  if not '-ch' in gprm.keys():
   ch='???'
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


def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)



class ccftpsrv(zerorpc.Client):
    on_receive = None

    def __init__(self, endpoint, name):
        super(ccftpsrv, self).__init__(endpoint)
        self.name = name

    def run(self):
        while True:
            try:
                # print ('rrrrrrrrrrrrrrrrrr')
                for data in self.pull(self.name):
                    if self.on_receive is not None:
                        self.on_receive(data)
            except Exception as ee:
                pass
                # mp('yellow','ccftpsrv.run ???='+str(ee))

    def send(self, data, *clients):
        try:
            self.publish(data, *clients)
        except:
            return False
        return True


def timer1s(interval):
    while True:
     gevent.sleep(interval)
     g={}
     g['cmd']='testc3'
     g['subcmd']='testc3'
     g['kto']='c3'
     clientftpsrv.send(g)

def onclftpsrv(sender,g):
     if not 'cmd' in g.keys(): return
     if g['kto'] =='c1':mp('lime',   'oncl='+str(g))
     if g['kto'] =='c2': mp('yellow','oncl='+str(g))
     if g['kto'] =='c3': mp('cyan', 'oncl=' + str(g))
     if g['kto'] =='c4': mp('magenta', 'oncl=' + str(g))
     if  'rsendstate' in g.keys() and g['rsendstate']=='1' :return
     cmd=g['cmd']

#=================mgbs=========================
mgb={}
tasks=[]
gprm=gsfunc.gonsgetp()
gprm['-ch']='c3'


h='tcp://127.0.0.1:5555'

clientftpsrv=ccftpsrv(h,'c3')
ccftpsrv.on_receive = onclftpsrv
task= gevent.spawn(clientftpsrv.run)
tasks.append(task)

task=gevent.spawn(timer1s,1)
tasks.append(task)



rmp('blue','joinall',2)
gevent.joinall(tasks)

