#!/usr/bin/env python
# -*- coding: utf-8 -*

# Скрипт предназначен для мониторинга заполняемости таблицы cdr в базе
import fdb
from datetime import timedelta, datetime

# Соединение
con = fdb.connect(dsn='127.0.0.1:/fdb/employee.fdb', user='sysdba', password='masterkey')

# Объект курсора
cur = con.cursor()

# Выполняем запрос
dt = (datetime.now() - timedelta(minutes=30)).replace(microsecond=0)
#cur.execute("SELECT r.JOB_CODE, r.JOB_GRADE, r.JOB_COUNTRY, r.JOB_TITLE, r.MIN_SALARY, r.MAX_SALARY, r.JOB_REQUIREMENT FROM JOB ")
cur.execute("SELECT * FROM JOB ")

# cur.fetchall() возвращает список из кортежей. Адресуемся к единственному значению; + перевод строки
print(str(cur.fetchall()[0][0]))
