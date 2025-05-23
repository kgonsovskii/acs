#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import gfunc,sys

def lsmasktostr(ls):
    s = ''
    for x in ls:
        s = s + str(x)
    return s
#==================================

ct=gfunc.mytime()
print ('ct=',ct)
sys.exit(99)
try:
 raise ZeroDivisionError ('model error ???????????????')
except Exception as ee:
 print (ee)
sys.exit(99)
tscd=gfunc.mytscd()
print ('tscd'+tscd)
s='женя'
u = s.encode()
print('u=',u)
sys.exit(99)
p=0
maska='12345608'
m=[1,2,0,4,0,6,7,8]
s=gfunc.allsmasktostr(m)
print ('s=',s)

sys.exit(99)

p=gfunc.alfdecmaska(maska)
m=gfunc.alfstrmaska(p)
print ('m='+m)