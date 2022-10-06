from pickle import NONE
from this import d
from unittest import result
import cx_Oracle
import pandas as pd

cx_Oracle.init_oracle_client(lib_dir=r"C:\oracle\instantclient_19_16")
dsn_tns = cx_Oracle.makedsn('PEDRO-DESK', '1521', service_name='XE') # if needed, place an 'r' before any parameter in order to address special characters such as '\'.
conn = cx_Oracle.connect (user=r'pedro', password='pedro123', dsn=dsn_tns) # if needed, place an 'r' before any parameter in order to address special characters such as '\'. For example, if your user name contains '\', you'll need to place 'r' before the user name: user=r'User Name'
print('A Versão é:', conn.version)
cursor = conn.cursor()
cursor.execute('SELECT * FROM hr.employees') 
for resultado in cursor:
        print(resultado)
        dataDf = pd.DataFrame(columns=["EMPLOYEE_ID", "FIRST_NAME", "LAST_NAME", "EMAIL", "PHONE_NUMBER", "HIRE_DATE", "JOB_ID", "SALARY", "COMMISSION_PCT", "MANAGER_ID", "DEPARTMENT_ID" ],
                                        data = resultado)
conn.close()