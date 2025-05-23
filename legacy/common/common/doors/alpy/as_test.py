import asyncio
import stofunc


def cicl2():
    n = 0
    while True:
     asyncio.run(asmydelay(1))
     n = n + 1
     print ('cicl2 n=',n)

async def cicl():
   n=0
   while True:
     await asyncio.sleep(1)
     #asyncio.run(asmydelay(1))
     print ('cicl n=',n)
     n=n+1
     b=7777
     x=b**7


async def setlimittime(f,t):
    # ждем не более 3 сек.
    try:
        await asyncio.wait_for(f(), timeout=t)
    except asyncio.TimeoutError:
        print('timeout!')

async def asmydelay(interval):
    while True:
     try:
      await asyncio.sleep(interval)
     except :pass
     break

#========================mgbs===
#asyncio.run(setlimittime(cicl,5))
t1=stofunc.nowtosec('loc')

print ('time 1 =',)
#asmydelay(5)
asyncio.run(asmydelay(1))
t2=stofunc.nowtosec('loc')
d=t2-t1
print ('d =',str(d))
#asyncio.run(cicl2())
cicl2()

"""
async def main():
    # ждем не более 1 сек.
    try:
        await asyncio.wait_for(eternity(), timeout=1.0)
    except asyncio.TimeoutError:
        print('timeout!')

asyncio.run(main())
"""