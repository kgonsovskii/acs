#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
import sys,time,os,traceback,time
import stofunc,gsfunc,gfunc
import gevent,zerorpc
from gevent.queue import Queue
from os import path, sep
import json,subprocess
import paho.mqtt.client as mqtt
import maloneemulmod



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
  if not '-ch' in gprm.keys():
   ch='???'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
   pass
   #redlog(txt)
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)


def createclzero():

    server = Server('tcp://127.0.0.1:5555')
    task = gevent.spawn(server.run)
    tasks.append(task)
    hc = 'tcp://127.0.0.1:5555'
    clientftpsrv = ccftpsrv(hc,'maldrv209')
    ccftpsrv.on_receive = onclftpsrv
    task = gevent.spawn(clientftpsrv.run)
    tasks.append(task)
    mgb['cli']=clientftpsrv
    return clientftpsrv


def onclftpsrv(sender,g):
    try:
     if not 'cmd' in g.keys():   return
     mp('lime', 'oncl=' + str(g))
    except Exception as ee:
      mprs('oncl',ee)


def prolog():
 gprm=gfunc.gonsgetp()
 gprm['-ch']='testrpc'
 createclzero()
 print ('end prolog')

def timer1s(interval):
    while True:
     gevent.sleep(interval)
     g={}
     g['cmd']='life'
     g['uxt']=stofunc.nowtosec('loc')
     mgb['cli'].send(g)
     mp('cyan','timer1s')


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
    rmp('magenta','AFTER connecttobroker  ',3)
    mbqt['mqtt']=mqclient
    return mqclient


def mysubscreibe(topic):
    try:
     mbqt['mqtt'].subscribe(topic)
     lstopics.append(topic)
     return 'ok',lstopics
    except Exception as ee:
     mpr('mysubscreibe',ee)
     return str(ee),lstopics



def onmesmqtt(client, userdata, message):
    try:
     js = message.payload.decode("utf-8")
     g=json.loads(js)
     if not 'cmd' in g.keys():return
     mp('magenta','g='+str(g))
    except Exception as ee:
      mpr('onmes',ee)





 #==================mgbs==================================
mgb={}
gprm={}
tasks=[]
lstopics=[]
mbqt={}
prolog()


mqttclient=connecttobroker('localcentr','192.168.0.106')
mbqt['mqtt']=mqttclient
rc,ls=mysubscreibe('tomain')
rc,ls=mysubscreibe('maldms')
mp('lime','ls='+str(ls))


task = gevent.spawn(timer1s, 1)
tasks.append(task)

rmp('magenta', 'joinall', 2)
gevent.joinall(tasks)





