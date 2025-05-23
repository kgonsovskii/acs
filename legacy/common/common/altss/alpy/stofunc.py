#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import datetime


class selfconst:
    def __init__(self):
        self.typetimestr = {'sqlt':[19,'%Y-%m-%dT%H:%M:%S'], 'sql':[19,'%Y-%m-%d %H:%M:%S'], 'gps':[12,'%y%m%d%H%M%S']}
        self.binstr = ['0000','0001','0010','0011','0100','0101','0110','0111','1000','1001','1010','1011','1100','1101','1110','1111']

class strmask:
    def __init__(self):
        self.intname = {'0':['DAV', [20,0,0,0,0,0,0,0,0,0,0,0,0]], '1':['MDGPS', [20,-9,-9,0,0,0,-98,-98,-98,0,0]], '2':['GPGGA',[63,44,9,54,9,0,20,1,1,9,1,9,0,40]], '3':['GPGLL',[44,9,54,9,63,9]], '4':['GPGSA',[9,0,20,20,20,20,20,20,20,20,20,20,20,20,1,1,1]], '5':['GPGSV',[0,0,20,20,20,30,20,20,20,30,20,20,20,30,20,20,20,30,20]], '6':['GPRMC',[63,9,44,9,54,9,2,2,60,0,9,9]], '7':['GPVTG',[32,9,32,9,2,9,1,9]]}
        self.intchr = {'0':'', '1':'N', '2':'S', '3':'E', '4':'W', '5':'V', '6':'A', '7':'M', '8':'K', '9':'T', '10':'D'}

#---------------------------------------------------------------------------------------------
def dec2bin(intparam):
    binstr = ''
    while intparam > 0:
        if intparam < 16:
            binstr = sc.binstr[intparam] + binstr
            intparam = 0
        else:
            i = intparam // 16
            j = intparam % 16
            intparam = i
            binstr = sc.binstr[j] + binstr
    return binstr

#--------------------------------------------------------------------------------------------
#        if Param        then flag
#  '2011-08-10T17:50:07' ==> 'sqlt'
#  '2011-08-10 17:50:07' ==> 'sql'
#  '100811175007.000'    ==> 'gps'
def datetimetosec(strDT, flag): # relapsing param - Data-Time number second
    instr = strDT[:sc.typetimestr[flag][0]]
    cdate =time.strptime(instr, sc.typetimestr[flag][1])
    intres = int(time.mktime(cdate))
    return intres


def sectodatetime(strsecdatetime):
    strres = datetime.datetime.fromtimestamp(float(strsecdatetime)) # Second => Date-Time
    #strres = datetime.datetime.utcfromtimestamp(float(strsecdatetime)) # Second (Local) => Date-Time (UTC)
    #xxx = datetime.datetime.timetz()
    return strres


def nowtosec(zone):
    if zone == 'UTC':
        strtime = datetime.datetime.utcnow() # fot UTS time
    # else:
    if zone=='loc':
       strtime = datetime.datetime.now() # fot Local time
    cdate = strtime.timetuple()
    intres = int(time.mktime(cdate)) # number second
    return intres


def  diffdate(deyOfset):
     now1 = datetime.date.today()
     now2 = now1 + datetime.timedelta(days = deyOfset)
     return now2

#--------------------------------------------------------------------------------------------
def crs8(IncomingString, scale): # check sum calculation
    eSum = 0
    for x in IncomingString:
        eSum ^= ord(x)
    if scale == 0: # Dec
        result = eSum
    elif scale == 1: # Hex
        result = hex(eSum)
    return result

#--------------------------------------------------------------------------------------------
def int2str(msg):
    arParam=msg.split(',')
    pSum=''
    Lp=len(arParam)-1
    Lk=len(sb.intname[arParam[0]][1])
    i=0
    for x in arParam:
        if i>0:
            if i<=Lk and i<Lp:
                Val=int(x)
                key = sb.intname[arParam[0]][1][i-1]
                pSum+=dModParam(Val, key)
            elif i==Lp:
                Val = int(arParam[i])
                if crs8(pSum, 0) == Val:
                    ph = str(hex(Val))[2:].upper()
                    ls = len(ph)
                    if ls < 2:
                        ph = '0' + ph
                    pSum += '*' + ph
                else:
                    pSum+='*Er'
                    break
            else:
                pSum='*Er'
                break
        else:
            pSum=sb.intname[arParam[0]][0]
        i+=1
    return pSum

def dModParam(var, key):
    strPar = ','
    if var > 0:
        if key > 0:
            if key !=9:
                dw, dl = '', ''
                var = str(var - 1)
                k1 = key // 10
                if k1 == 0:
                    k1 = 1
                k2 = key % 10
                if k2> 0:
                    pmid = len(var) - k2
                    part1 = var[:pmid]
                    part2 = '.'
                    tp = var[pmid:]
                    lenvar = len(tp)
                    if lenvar < k2:
                        part2 += ('0' * (k2 - lenvar))
                    part2 += tp
                else:
                    part1 = var
                    part2 = ''
                lenvar = len(part1)
                if k1 > lenvar:
                    dw = '0' * (k1 - lenvar)
                strPar += dw + part1 + part2
            else:
                strPar += sb.intchr[str(var)]
        elif key == 0:
            if var > 1:
                sv = str(var-1)
                par = sv[:-1]
                lp = len(par)
                k = int(sv[lp:])
                if k > 0:
                    if lp <= k:
                        par = ('0' * (k+1-lp)) + par
                    lp = len(par)
                    strPar += par[:-k] + '.' + par[lp-k:]
                else:
                    strPar += par
            elif var == 1:
                strPar += '0'
        elif key == -9: # Latitude Longitude
            if var > 0:
                main = ''
                var = str(var)
                len1 = int(var[:1])
                main = ('-' * int(var[(len(var)-1):]))
                var = var[1:-1]
                len0 = len(var)
                strPar += var[:len1]
                if len0 > len1:
                    strPar += '.' + var[len1:]
        elif key == -98:
            var = str(var - 1)
            pz = '-' * (int(var[:1]) - 1)
            p1 = str(int(var[1:]))
            strPar += pz + p1
    return strPar
#--------------------------------------------------------------------------------------------

sb = strmask()

sc = selfconst()