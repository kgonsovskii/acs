#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import datetime
#from datetime import datetime

print('11111111111111111111111')
cd = datetime.datetime(2023,10,11,0,0,0)
for i in range(5):
    cd += datetime.timedelta(days=1)
    print(cd)