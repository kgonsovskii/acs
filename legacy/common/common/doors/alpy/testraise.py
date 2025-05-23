


print('bbbbbbbbbbbbbbbbbbbbbbb')
try:
  exac='simulerror ac=77'
  raise ZeroDivisionError(exac)
except Exception as ee:
  print ('ошибка=',str(ee))