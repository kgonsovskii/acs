
import gfunc

def formirmbacl(ls):
 g={}
 for ac in ls:
  g[ac]={}
  g[ac]['bidac']=ac
  g[ac]['kpx']='kpx'
  g[ac]['buzy']=False      # контроллер занят другой операцией (запись ключей ...)
  g[ac]['cerr']=0          # общее кол-во ошибок на этом контроллере
  g[ac]['currerr']=0       # текущее кол-во ошибок до первого успешного события
 # s='select limitinfoerr from tss_acl where ac='+str(ac)+' and bp='+str(mgb['bidch'])
 # mp('lime','s='+s)
  g[ac]['limitinfoerr']=30
 return g
#==============================================mgbs
mgb={}
mbch={}
mbch['excl']=[77,7]
mbacl=formirmbacl([7,77])
for ac in mbch['excl']:
 s=str(ac)+','+str(mbacl[ac]['bidac'])
 print ('s=',s)
 ct=gfunc.mytime()[0:8]
 cdate = gfunc.mydatezz()
 cdate=cdate.replace('.','-')
 print ('ct=',ct,'cdate='+cdate)



