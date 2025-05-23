# -*- coding: utf-8 -*-

import gfunc,stofunc,gevent,traceback,sys
import libtssacs as acs


def mpr(txt,ee):
    em=str(traceback.format_exc())
    mp('red',txt+'/ee='+em)

def mp(c,txt):
 try:
  if not '-ch' in gprm.keys():
   ch='dms'
  else: ch=gprm['-ch']
  t=gfunc.mytime()
  nm=gfunc.myappexe()
  gfunc.mpv(c,'/ '+ch+' '+txt+'  /t='+t)
  if c == 'red':
    #redlog(txt)
    return
  if c == 'magenta':
     # magentalog(txt)
      return
 except Exception as ee:
   print ('mp ee='+str(ee))



def mprs(txt,ee):
    em=str(ee)
    mp('red',txt+'/ee='+em)

def rmp(c,txt,n):
  for i in range(1,n+1,1):
   mp(c,txt)



def crip(ch):
 atp=0
 while True and atp<20:
   try:
    atp=atp+1
    print('cyan','crip ch='+ch)
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.1    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
   # chskd.flush_input()
    gevent.sleep(1)
    print ('lime', 'CHANNEL CREATE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',30)
    #fplay('prolog.wav')
    return chskd
   except Exception as ee:
    print('crip','ATTEMPT CHANNEL CREATE='+str(atp)+' /ee='+str(ee))




#===================================mgbs=================
gprm=gfunc.gonsgetp()
mp('cyan','gprm='+str(gprm))
ch=gprm['-ch']
mp('yellow','gprm='+str(gprm))
s=gprm['-acl']
ac=int(s)
s=gprm['-ck']
ck=int(s)
mp('cyan','ac='+str(ac)+'/ck='+str(ck))
chskd=crip(ch)
mp('white','chskd='+str(chskd))
chskd.del_all_keys(ac)
mp('red','after delall ')
ls=[]
for i in range(ck):
  t=acs.Key()
  t.code=i
  t.mask=[1,2,3,4,5,6,7,8]
  t.pers_cat=16
  ls.append(t)
mp('yellow','ki7=START WAK')
t1=stofunc.nowtosec('loc')
chskd.write_all_keys(ac,ls)
t2=stofunc.nowtosec('loc')
d=t2-t1
mp('lime','WAK d='+str(d))
t1=stofunc.nowtosec('loc')
try:
 chskd.flush_input()
except :
  pass
mp('cyan','sleep 10')
gevent.sleep(10)
mp('cyan','START RAK')
ls=chskd.read_all_keys(ac)
ll=str(len(ls))
t2=stofunc.nowtosec('loc')
d=t2-t1
mp('lime','d='+str(d)+' ll='+ll)
