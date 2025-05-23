import asyncio, time
from random import randint
import libtssacs as acs
import gfunc
import traceback

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
 try:
    atp=atp+1
    print('cyan','crip ch='+ch)
    chskd = acs.ChannelTCP(ch)
    chskd.response_timeout =0.1    #float(gprm['-chsleep'])
    chskd.baudrate = 19200
   # chskd.flush_input()

    print ('lime', 'CHANNEL CREATE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',30)
    #fplay('prolog.wav')
    return chskd
 except Exception as ee:
    print('crip','ATTEMPT CHANNEL CREATE='+str(atp)+' /ee='+str(ee))

async def frak(ac):
    while True:
        mp('magenta', 'frak START')
        try:
         ls = chskd.read_all_keys(ac)
         ll=str(len(ls))
         rmp('white', 'frak ll=' + ll, 50)
         await asyncio.sleep(3)
        except Exception as ee:
         mprs('frak', ee)
         chskd.get_dt(7)
         await asyncio.sleep(3)






async def astimer5s(interval):
    while True:
        await asyncio.sleep(interval)
        #ei7=chskd.events_info(7)
       # ei77 = chskd.events_info(77)
        mp('yellow','ei7=????????????????????????????')



async def taska():
    while True:
     new_data=randint(0,100)
     await asyncio.sleep(2)
     mp('cyan','taska')
#=================mgbs===================
mgb={}
gprm={}
gprm['-ch']='testasync1'
ch='192.168.0.96'
chskd = crip(ch)
mp('lime', 'chskd= '+str(chskd))
event=asyncio.Event()
new_data=None

if __name__=='__main__':
    event_loop=asyncio.get_event_loop()
    mp('lime', 'main start ')
    event_loop.create_task(taska())
    event_loop.create_task(astimer5s(5))
    event_loop.create_task(frak(77))
    event_loop.run_forever()
    mp('lime', 'task1 start ')


    mp('lime','main')

