#!/usr/bin/env python
# -*- coding: utf-8 -*-
import datetime,sys,os,platform,time
import  sqlite3
import gevent
from os import path, sep
import calendar
import stofunc
import zlib,base64



class tvb:
    def __init__(self):
        self.alias=''
        self.type='r'
        self.dbpath=''          #
        self.db=-1              #  handle
        self.suc=0              #  0/1 success of find base
        self.sucdb=0            #  0/1 success of open base
        self.cursor=-1          #  cursor on select statement
        self.lsb=[]             #
        self.cl=1
        self.active='yes'
        self.sql_prepare=''
        self.lsstart=[]         #
        self.errmess=[]
        self.commit_number=0
        self.commit_border=100


def opendb3(pt,typ):
    vb = tvb
    vb.dbpath = pt
    try:
       if typ=='r':
        vb=tvb
        vb.dbpath=pt
        vb.db = sqlite3.connect(vb.dbpath)
        vb.db.text_factory = str
        vb.cursor = vb.db.cursor()
        vb.cursor.row_factory = sqlite3.Row
        vb.dbpath = pt
        vb.sucdb = 1
        return vb

       if typ=='v':   # virtual memory
           vb.db = sqlite3.connect(":memory:")
           # mp('lime','bropenbase fn='+fn+'/tp='+str(tp))
           # print
           vb.db = sqlite3.connect(vb.dbpath)
           vb.db.text_factory = str
           vb.cursor = vb.db.cursor()
           vb.cursor.row_factory = sqlite3.Row
           vb.dbpath = pt
           vb.sucdb = 1
           return vb

    except Exception as ee:
     mpr('opendb3',ee)


def mycompress(src):
    target = zlib.compress(src.encode('utf-8'))
    return target

def mycmps(src):
    target =mycompress(src)
    cds = mycoding(target)
    dec64 = base64.b64decode(cds)
    uct64 = zlib.decompress(dec64).decode('utf-8')
    return cds,uct64



def mycoding(t):
    lt64 = base64.b64encode(t)
    return lt64

def mycrc32(s):
    b = bytes(s, 'utf-8')
    # print ('b=',b)
    r = zlib.crc32(b)
    # print('r=', r)
    # print('mycrc32================')
    return r


def linetols(line):
    # select non blanc string and append to []
    ls=[]
    ss=''
    n=0
    l=len(line)
    for x in line:
        n=n+1
        # print 'x=',x+'>','n=',n,' l=',l
        if x !=' ':
            ss=ss+x
        if n==l:
            ls.append(ss)
            # print 'LAST ss=',ss
            lsx=delemp(ls)
            return lsx
        if  x==' ' :
            ls.append(ss)
            ss=ss+','
            if n==l:
                ls.append(ss)
                lsx=delemp(ls)
                return lsx
            ss=''
    return ls

def mstouxt(ms):
# ms='2022-12-10 09:06:30'
 try:
   uxt=stofunc.datetimetosec(ms,'sql')
   return  uxt
 except Exception as ee:
   mpv('red','mstouxt ee='+str(ee))


def myuxtms():
   try:
    dt = datetime.datetime.now()
    # print("dt:", dt.strftime('%Y.%m.%d %H:%M:%S'))
    ut = int(time.mktime(dt.timetuple()))
    # print("ut:", ut)
    ms = str(datetime.datetime.fromtimestamp(ut))
    # ms=ms.replace('-','.')
    return ut,ms
   except Exception as ee:
     mpv('red','myuxtms,ee='+str(ee))



def calck_ipmaca(ls):
    try:
        # . s=        inet 192.168.0.90  netmask 255.255.255.0  broadcast 192.168.0.255
        # ls2=        ether b8:27:eb:66:bc:8d  txqueuelen 1000  (Ethernet)  /t=05:30:15,898

        gr={}
        s=ls[1]
        lsx=s.split('inet')
        x=lsx[1]
        lsy=x.split(' ')
        gr['host']=lsy[1]
        m=ls[3]
        lsx=m.split('ether')
        z=lsx[1]
        lsx=z.split(' ')
        maca=lsx[1]
        gr['maca']=maca
        return gr
    except Exception as ee:
        mpr('calck_ipmaca',ee)


def  razbor_ifconfig(ls,g):

    try:
        ls2=[]
        i=0
        lt=g['lantype']
        for s in ls:
            try:
                n=s.index(lt)
                break
            except: pass
            i=i+1
        # mp('lime','lt='+lt+' /i='+str(i))
        for i in range(i,i+4,1):
            ls2.append(ls[i])

        gx=calck_ipmaca(ls2)
        gx['lantype']=lt
        # mp('red','gx='+str(gx))
        return gx
    except Exception as ee:
        mpr('razbor_ifconfig',ee)





def xcalc_rbcparams():
    # mp('yellow','xcalc_rbcparams start')
    g={}
    g['lantype']=x_getlantype()
    cmd='ifconfig'
    ls=getinfocmdlinux(cmd)
    gr=razbor_ifconfig(ls,g)
    return gr



def getinfocmdlinux(cmd):
    import subprocess
    process = subprocess.Popen([cmd], bufsize=-1, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result, error = process.communicate()
    result=result.split('\n')
    process.stdout.close()
    return result


def myweekday(zz):
    try:
        days = ["понедельник","вторник","среда","четверг","пятница","суббота","воскресенье"]
        ls=zz.split('.')
        y=int(ls[0])
        m=int(ls[1])
        d=int(ls[2])
        mdw=days[calendar.weekday(y,m,d)]
        return mdw
    except Exception as ee:
        mpv('red','myweekday ee='+str(ee))

def newpyprc(name,pid):
    ap='"'
    z=','
    f=False
    cd=mydatezz()
    ct=mytime()[0:8]
    ct=zerol(ct,8)
    uxt=stofunc.nowtosec('loc')
    uxt=str(uxt)
    ptf='/tmp/ramdisk/registerprc.db3'
    vb=bropenbase('r',ptf)
    # s='delete from register where name='+ap+name+ap
    # vb.db.execute(s)
    s='insert into register(name,pid,cd,ct,uxt)values('+\
    ap+name+ap+z+\
    str(pid)+z+\
    ap+cd+ap+z+ \
    ap+ct+ap+z+uxt+\
    str(pid)+')'
    try:
     vb.db.execute(s)
     vb.db.commit()
     vb.db.close()
     f=True
     return 'ok'
    except Exception as ee:
     mpv('red','newpyprc ee='+str(ee))
     return str(ee)
    s='update regiter set pid='+str(pid)+', cd='+ap+cd+ap+z+\
     ' ct='+ap+ct+ap+z+\
     'where name='+ap+name+ap
    try:

      vb.db.execute(s)
      vb.db.commit()
      vb.db.close()
      return 'ok'
    except Exception as ee:
        mpv('red','newpyprc ee='+str(ee))
        return str(ee)


def x_getlantype():
    try:
        cmd='netstat -r'
        ls=getinfocmdlinux(cmd)
        s=ls[2]
        ls1=s.split(' ')
        ls1=delemp(ls1)
        ifc=ls1[7].strip()
        return ifc
    except Exception as ee:
        mpv('red',' ee='+str(ee))



def getlantype():
    try:
        appdir=getmydir()
        nm=myappexe()
        ptf1=appdir+nm+'.txt'
        mpv('yellow','ptf='+ptf1)
        s='netstat -r>'+ptf1
        mpv('yellow','s='+s)
        os.system(s)
        time.sleep(1)
        inp=open(ptf1,'r')
        ls=inp.readlines()
        lss=[]
        for s in ls:
            ss=s.replace('\n','')
            lss.append(ss)
            mpv('lime','ss='+ss)
        s2=lss[2]
        mpv('lime','s2='+s2)
        lx=s2.split(' ')
        lx=delemp(lx)

        l=len(lx)
        v=lx[l-1]
        # g=gfunc.lstogls(lx)
        mpv('yellow','v='+str(v)+'>')
        return v
    except Exception as ee:
        mpv('red','getlantype ee='+str(ee))

def getlocalipformlt(lt):
    try:
        appdir=getmydir()
        nm=myappexe()
        nm0=nm
        nm=nm0+'01'
        ptf1=appdir+nm+'.txt'
        mpv('yellow','ptf='+ptf1)
        s='ifconfig>'+ptf1
        mpv('yellow','s='+s)
        os.system(s)
        gevent.sleep(1)
        nm=nm0+'02'
        ptf2=appdir+nm+'.txt'
        s='grep -A4 "'+lt+'"   '+ptf1+'>'+ptf2
        mpv('red','s='+s)
        os.system(s)
        gevent.sleep(1)
        nm=nm0+'03'
        ptf3=appdir+nm+'.txt'
        s='grep -A2 "inet "   '+ptf2+'>'+ptf3
        os.system(s)
        gevent.sleep(1)
        inp=open(ptf3,'r')
        # ls=inp.readlines()
        ls=inp.readlines()
        mpv('cyan','ls='+str(ls))
        lss=[]
        for s in ls:
            ss=s.replace('\n','')
            print ('ss=',ss)
            lss.append(ss)
        v=lss[0]
        lsx=v.split(' ')
        lsx=delemp(lsx)
        print ('lsx=',lsx)
        mpv('blue','lsx='+str(lsx))
        v=lsx[1]
        v=v.replace('addr:','')
        mpv('lime','v='+v)
        return v

    except Exception as ee:
        mpv('red','getlocalipformlt ee='+str(ee))


def mytmark():
    t1=mytime()[0:12]
    ls=t1.split(':')
    t1=ls[2]
    t1=t1.replace(',','.')
    return float(t1)


def sysconvdt():
    dt=mydatezz()
    dt=dt.replace('.','')
    print ('dt=',dt)
    ct=mytime()[0:8]
    ct=zerol(ct,8)
    ct=ct.replace(':','')
    g={}
    g['cd']=dt
    g['ct']=ct
    return g



def zerol(s,n):
    ## print 'zerol s=',s,'/n=',n
    l = len(s)
    k=n-l
    zz='0'*k
    ss=zz+s
    return  ss


def mydeletefile(pt):
    try:
        os.unlink(pt)
        mp('magenta','unlink='+pt)
    except:pass

def getoss():
    g={}
    plt=platform.uname()
    oss=plt[0].lower()
    g['oss']=oss
    return g,plt


def mymarkerdelta(a,b):
    try:
        delta = b - a
        msec=int(delta.total_seconds() * 1000) # milliseconds
        sec=float(msec/1000.000)
        return sec
    except Exception as ee:
        print ('mymarkerdelta ee=',ee)

def cchet(g,val):
    try:
        if not  val % g:
            # print 'found g=',g
            rc='c' # CHETNOE
        else:
            # print 'not g=',g
            rc='n' # NE CHETNOE
        return rc
    except Exception as ee:
        print ('cchet',ee)
def xkeytos(x):
    ## x=int(xk,16)
    s = '%.12x' % x
    s=s.upper()
    return s

def keytox(kl):
    kl=kl.strip()
    try:
        x=int(kl,16)
        return x
    except :
        return 0


def oldkeytox(kl):
    kl=kl.strip()
    if kl=='':return -1
    try:
        kl=int(kl,16)
        return kl
    except Exception as e:
        ##		print ('E,keytox,'+e[0]+' kl='+kl)
        print('E,keytox,'+e[0]+' /kl='+kl)
        return -1

    return kl



def mymarker():
    r = datetime.datetime.now()
    return r


def mydatezz():
    try:
        now = datetime.datetime.now()
        ##     d='%.4d.%.2d.%.2d.'% (now.year,now.month,now.day)

        ##print '%.4d.%.2d.%.2d.%.2d:%.2d:%.2d.%.3d' % (now.year, now.month, now.day, now.hour, now.minute, now.second, now.microsecond / 1000)
        d='%.4d.%.2d.%.2d'% (now.year, now.month,now.day)
        ##        print 'd=',d
        ##print '%.4d.%.2d.%.2d'% (now.year, now.month,now.day)
        t= '%.2d:%.2d.%.2d,%3d'% (now.hour, now.minute, now.second, now.microsecond / 1000)
    except Exception as ee :
        print (ee)
    return d



def lstogls(ls):
    try:
        # print 'lstogls ggggggggggggggggggggggggggggggggggggg'
        g={}
        for s in ls:
            s=s.strip()
            # s=s.replace('\r','')
            # s=s.replace('\n','')
            s=s.replace('\x0d\x0a','')
            lss=s.split('=')
            for ss in lss:
                k=str(lss[0]).strip()
                try:
                    v=str(lss[1])
                    v=v.strip()
                    # v=v.replace('equ','=')
                    g[k]=v
                except :pass
        # gg=repl_equ(g)
        return g
    except Exceptio as ee:
        print ('lstogls ee='+str(ee))


def glstols(g):
    try:
        da='\x0d\x0a'
        ls=[]
        for k in g:
            v=str(g[k])
            k=str(k)
            # v=v.strip()
            s=k+'='+v+da
            ls.append(s)
        return ls
    except Exception as ee:
        print('glstols',str(ee))



def getmachine_addr():
    os_type = sys.platform.lower()
    if "win" in os_type:
        command = "wmic bios get serialnumber"
    elif "linux" in os_type:
        print ('linux tut')
        command = "hal-get-property --udi /org/freedesktop/Hal/devices/computer --key system.hardware.uuid"
        print ('command=',command)
    elif "darwin" in os_type:
        command = "ioreg -l | grep IOPlatformSerialNumber"
    return os.popen(command).read().replace("\n","").replace("	","").replace(" ","")

#output machine serial code: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX


# /proc/cpuinfo= 000000004266bc8d my in home   192.168.0.90
# /proc/cpuinfo= 000000005645f0d5 my in office 192.168.0.95





def mytime():
    now = datetime.datetime.now()
    t= '%.2d:%.2d:%.2d,%.3d' %(now.hour, now.minute, now.second, now.microsecond / 1000)
    return t

def mpv(c,b):
    try:
        t=mytime()
        c=c.lower()
        c=c.strip()
        c=c.lower()
        b=str(b)
        f2='\033[1;m'

        if c=='gray':
            f1='\033[1;47m'
            mes=f1+b+f2

        if c=='blue':
            f1='\033[1;44m'
            mes=f1+b+f2

        if c=='white':
            f1= '\033[1;37m'
            mes=f1+b+f2
        if c=='magenta':
            f1='\033[1;35m'
            mes=f1+b+f2
        if c=='yellow':
            f1='\033[1;33m'
            f2='\033[1;m'
            mes=f1+b+f2
        if c=='lime':
            f1='\033[1;32m'
            f2='\033[1;m'
            mes=f1+b+f2
        if c=='cyan':
            f1='\033[1;36m'
            f2='\033[1;m'''
            mes=f1+b+f2
        if c=='red':
            f1='\033[1;31m'
            f2='\033[1;m'''
            mes=f1+b+f2
            print (mes)
            # selflog(b)
            return
        print (mes)

    except Exception as ee:
        print ('')



def checkmedialost(x):
    # Filesystem     1K-blocks    Used Available Use% Mounted on
    # /dev/root        6991732 5736228    908240  87% /
    # devtmpfs          469544       0    469544   0% /dev
    # tmpfs             474152       0    474152   0% /dev/shm
    # tmpfs             474152   47880    426272  11% /run
    # tmpfs               5120       4      5116   1% /run/lock
    # tmpfs             474152       0    474152   0% /sys/fs/cgroup
    # /dev/mmcblk0p1     44220   22687     21533  52% /boot
    # tmpfs              94828       0     94828   0% /run/user/1000
    # /dev/sda1         123888   16311    107577  14% /media/pi/F120MB
    # tmpfs              10240     324      9916   4% /tmp/ramdisk


    ls=getinfocmdlinux('df')

    for s in ls:
        try:
            # mp('cyan',s)
            n=s.index(x)
            if n>0:
                # mp('red','/n='+str(n))
                g=getvx(s)
                # mp('yellow',s+'/g='+str(g))
                return g
        except :pass
    return None

def getfromglobals(key):
    try:
        # mpv('red','NEW getfromgls key='+str(key))
        ap='"'
        # mpv('yellow','NEW getfromglobals')
        pt=mgb['main_path']
        pt='/tmp/ramdisk'
        # mpv('yellow','NEW getfromglobals PT='+str(pt)+' /key='+str(key))
        if pt==None :
            pt=pt+'/globals.db3'
            # mpv('cyan','getfromglobals pt='+str(pt))
            # mpv('cyan','getfromglobals pt='+str(pt))
            # mpv('wait','getfromglobals pt='+str(pt))
            vvb=bropenbase('r',pt)
            s='select * from globals where key='+ap+key+ap
            # print 'NEW getfromglobals s=',s
            vvb.cursor.execute(s)
            for row in vvb.cursor:
                value=row['value']
                vvb.db.close()
                return value
    except Exception as ee:
        # mpv('red','getfromglobals ee='+str(ee))
        #  mpv('yellow','getfromglobals pt='+str(pt))
        print ('getfromglobals,ee=',ee)



def getvx(s):
    try:
        # mp('red','s='+s)
        lsx=s.split(' ')
        lsx=delemp(lsx)
        # print 'lsx=',lsx
        g={}
        g['filesystem']=lsx[0]
        g['1kb']=lsx[1]
        g['used']=lsx[2]
        g['Available']=lsx[3]
        g['use']=lsx[4]
        g['mounted']=lsx[5]
        # mpv('white','getvx g='+str(g))
        # print 'g=',g
        return g
    except Exception as ee:
        mpv('getvx',ee)
        return g


def gonsdict(ls):
    # ls=['-d', '1', '-p', '-7']
    lsn=[]
    lsv=[]
    nnm=0
    nv=1
    g={}
    l=len(ls)
    try:
        for i in range(0,l,1):
            nm=ls[nnm]
            nnm=nnm+2
            v=ls[nv]
            nv=nv+2
            g[nm]=v
        # print g
    except Exception as ee:
        # print ee
        return g
    return g


def myappexe():
    pt=sys.argv[0]
    ls=pt.split('/')
    l=len(ls)
    lss=ls[l-1]
    ls=lss.split('.')
    nm=ls[0]
    return nm


def delemp(ls):
    for i in range(1,100,1):
        try:
            n= ls.index('')
            ls.pop(n)
        except :
            return ls
    return ls


def getmydir():
    appdir = path.dirname(path.abspath(sys.argv[0])) + sep
    return appdir


def gonsgetp():
    try:
        #    gons read params to dict
        g={}
        nm=' '
        ls=[]
        i=1
        l=len(sys.argv)
        for i in range(1,l,1):
            ls.append(sys.argv[i])
        return gonsdict(ls)
    except Exception as ee:
        print ('getp',ee)
        return g

def fping(host,c):
    rc=1
    rx=0
    for i in range(1,c+1,1):
        try:
            rc = os.system('ping -c 1 ' + host)
        except Exception as ee:
            mpv('magenta','fping',ee)
        if rc == 0:
            rx=rx+1
        else:
            rx=rx-1
    return rx

def bropenbase(tp,fn):
 try:
    vb=tvb()
    vb.dbpath=fn
    if tp=='m':
        vb.db=sqlite3.connect(":memory:")
        # mp('lime','bropenbase fn='+fn+'/tp='+str(tp))
        # print
        vb.db = sqlite3.connect(vb.dbpath)
        vb.db.text_factory = str
        vb.cursor = vb.db.cursor()
        vb.cursor.row_factory = sqlite3.Row
        vb.dbpath=fn
        # for i in range(1,20,1):
        #  mp('lime', 'bropenbase fn='+fn +' OK     ?????????      OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO')
        #  print
        print ('geconfunc vb.dbpath='+vb.dbpath)
        vb.sucdb=1
        return vb
    if tp=='r':
        try:
            # mp('lime','bropenbase fn='+fn+'/tp='+str(tp))
            # print
            vb.db = sqlite3.connect(vb.dbpath)
            vb.db.text_factory = str
            vb.cursor = vb.db.cursor()
            vb.cursor.row_factory = sqlite3.Row
            vb.dbpath=fn
            # mp('lime', 'bropenbase fn='+fn +' OK     ?????????      OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO')
            # print
            # print 'vb.dbpath='+vb.dbpath
            vb.sucdb=1
            return vb

        except Exception as ee:
            vb.sucdb=0
            mpv('red','bropenbase new 1 '+vb.dbpath+' '+str(ee))
            print
 except Exception as  ee:
    vb.sucdb=0
    mpv('red','bropenbase 2,ee= '+vb.dbpath+' '+str(ee))
    print
# ===========================================================================
mgb={}




