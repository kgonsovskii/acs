
ls=[7,77]
try:
 ac=99
 n=ls.index(ac)
except Exception as ee:
  ls.append(ac)
print (ls)