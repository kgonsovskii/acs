import asyncio
import time


async def fun1(x):
    print(x**2)
    await asyncio.sleep(3)
    print('fun1 завершена')


async def astimer10s(interval):
    while True:
     await asyncio.sleep(interval)
     print ('astimer10s ??????????????????????',time.time_ns())

async def astimer1s(interval):
    while True:
     await asyncio.sleep(interval)
     print ('astimer1s',time.time())

async def fun2(x):
    print(x**0.5)
    await asyncio.sleep(3)
    print('fun2 завершена')


print(time.strftime('%X'))

loop = asyncio.get_event_loop()
task1 = loop.create_task(fun1(4))
task2 = loop.create_task(fun2(4))
task3 = loop.create_task(astimer1s(1))
task4 = loop.create_task(astimer10s(10))
loop.run_until_complete(asyncio.wait([task1,task2,task3,task4]))