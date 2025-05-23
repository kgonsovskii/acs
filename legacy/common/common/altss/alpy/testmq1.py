#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import sys,time,os,traceback,time
#import libtssacs as acs
import stofunc,gsfunc,gfunc
import gevent,traceback,zerorpc
from gevent.queue import Queue
from os import path, sep
import psycopg2,json
import paho.mqtt.client as mqtt
import base64
import  shlex


def main(x):
    s = shlex.join(sys.argv)
    print (x)
#==================================mgbs-======================
print ('000000000')
mgb={}
'''
if  __name__ == '__main__':
    print ('END OF PROGRAMM')
    #main('111111111111111111111')
'''