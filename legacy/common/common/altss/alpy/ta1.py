#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import mqtransmod
import psycopg2
import json,subprocess


class Server(zerorpc.Server):
    def __init__(self, endpoint):
        super(Server, self).__init__()
        self.clients = {}
        self.bind(endpoint)

    def stso(self,g):
        try:
            # if g['cmd']=='getcpuinfo':
            #  rmp('lime',str(g),5)

            if g['cmd']=='sql':
                pass
                # mp('red','stso='+str(g))
            gg={}
            if type(g) != type(gg):
                mp('red','NOTGLS'+str(g))
                return
            try:
                cmd=g['cmd']
                if cmd=='cmdrd' or cmd=='keycrdr':
                    pass

            except Exception as ee:
                mpr('stso 1',ee)
            # lsgftpout.append(g)
            m1=gfunc.mymarker()
            # tostsobox(g)
            m2=gfunc.mymarker()
            d=gfunc.mymarkerdelta(m1,m2)
            # glstotransport.append(g)
        except Exception as ee:
            mpr('stso 2',ee)


    @zerorpc.stream
    def pull(self, name):
        queue = Queue()
        self.clients[name] = queue
        try:
            for item in queue:
                yield item
        finally:
            if id(self.clients.get(name)) == id(queue):
                self.clients.pop(name, None)

    def publish(self, data, *clients):
        if 0 == len(clients):
            for queue in self.clients.values():
                queue.put(data)
        else:
            for name in clients:
                queue = self.clients.get(name)
                if queue is not None:
                    queue.put(data)



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
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
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



def jstogls(js):
    try:
     g = json.loads(js)
     #mp('cyan','jstogls g='+str(g))
     return g
    except Exception as ee:
        return None


def  sendmqtt(js):
     mqttclient.publish('tss_mqtt', js)
     mp('yellow','sendmqtt='+js)

def timermqtt(interval):
    while True:
     gevent.sleep(interval)
     g={}
     g['cmd']='TESTASTR1'
     uxt=stofunc.nowtosec('loc')
     g['cd']=str(stofunc.sectodatetime(uxt))
    # mp('white', 'timermqtt g=' + str(g))
     js = json.dumps(g)
     sendmqtt(js)
     l=len(mqtransmod.sljsin)
     if l>0:
      #while len(mqtransmod.sljsin)>0:
      js=mqtransmod.sljsin.pop(0)
      g=jstogls(js)
      mp('lime','JSIN='+js)


def onclftpsrv(sender,g):
    try:
     if not 'cmd' in g.keys(): return
     cmd=g['cmd']
     js = json.dumps(g)

    except Exception as ee:
     mpr('onclftpsrv',ee)





#================mgbs========================
mgb={}
tasks=[]
gprm=gsfunc.gonsgetp()
gprm['ch']='ta1'
mp('lime','start')
mp('yellow','gprm='+str(gprm))


#server=Server('tcp://127.0.0.1:5555')
#hs='tcp://'+gprm['-t']+':5555'

hs='office.sevenseals.ru:33890'
hs='office.sevenseals.ru'
mp('lime','hs='+hs)
'''
for i in range (1,5,1):
 try:
   server=Server(hs)
   break
 except Exception as ee:
  mprs('msin hs',ee)
  gevent.sleep(1)
task = gevent.spawn(server.run)
tasks.append(task)
'''

#hc='tcp://'+gprm['-t']+':5555'
hc='office.sevenseals.ru:33890'
mp('red','hc='+hc)
'''
clientftpsrv=ccftpsrv(hc,'ta1')
ccftpsrv.on_receive = onclftpsrv
task= gevent.spawn(clientftpsrv.run)
tasks.append(task)
'''

#mqttclient=mqtransmod.connecttobroker('ta1',gprm['-t']) office.sevenseals.ru:33890
mqttclient=mqtransmod.connecttobroker('ta1','office.sevenseals.ru:33890')
mqttclient.loop_start()  # start the loop

task=gevent.spawn(timermqtt,1)
tasks.append(task)


rmp('blue','joinall',5)
gevent.joinall(tasks)




