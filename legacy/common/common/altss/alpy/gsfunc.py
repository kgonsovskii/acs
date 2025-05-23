_author__ = 'master'
#!/usr/bin/env python
# -*- coding: utf-8 -*
import sys
import gfunc
# import geconfunc





def formirstartprm():
    import gsfunc
    g=gsfunc.gonsgetp()
    s=''
    for k in g:
        v=g[k].strip()
        s=s+k+' '+v+' '
    return s

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


def lstogls(ls):
  try:
    g={}
    for s in ls:
     s=s.replace('\x0d\x0a','')
     lss=s.split('=')
     for ss in lss:
      k=str(lss[0]).strip()
      v=str(lss[1])
      g[k]=v.strip()
    return g
  except Exception as ee:
   print('lstogls',str(ee))


def glstostr(g):
   try:
    da='\x0d\x0a'
    s=''
    for k in g :
      k=k.strip()
      v=g[k]
      # print k,v
      s=s+str(k)+'='+str(v)+da
    # print 's='+s
    return s
   except Exception as ee:
     print('glstostr',str(ee))





def putfileout(g):
   try:
    # rmp('magenta','putfileout clientftp='+str(mgb['clientftp']),3)
    if mgb['clientftp']==False:return
    # da='\x0d\x0a'
    ls=glstols(g)
    ct=gfunc.mytime()[0:8]
    # ls=['cmd=ftplife'+da+'ct='+ct+da+'maca='+mgb['maca']+da]
    try:
     pt=mgb['ptout']
     os.unlink(pt)
    except :pass
    fout=open(pt,'w')
    # fout.writelines(ls)
    s=glstostr(g)
    fout.write(s)
    fout.flush()
    fout.close()
    # mp('yellow','putfileout NEW............. s='+s)
   except Exception as ee:
    mpr('putfileout',ee)


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
 except Exception  as ee:
      print ('getp',ee)
      return g

# g=gonsgetp()
# n=int(g['-r'])

# for i in range(1,n,1):
#  g=gonsgetp()
#  print i,g

if __name__ == '__main__':
     pass





