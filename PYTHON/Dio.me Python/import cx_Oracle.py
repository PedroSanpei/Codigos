from pickle import NONE
import cx_Oracle
import pandas as pd

cx_Oracle.init_oracle_client(lib_dir=r"C:\oracle\instantclient_19_16")
dsn_tns = cx_Oracle.makedsn('PEDRO-DESK', '1521', service_name='XE') # if needed, place an 'r' before any parameter in order to address special characters such as '\'.
conn = cx_Oracle.connect (user=r'pedro', password='pedro123', dsn=dsn_tns) # if needed, place an 'r' before any parameter in order to address special characters such as '\'. For example, if your user name contains '\', you'll need to place 'r' before the user name: user=r'User Name'
print('A Versão é:', conn.version)
cursor = conn.cursor()
cursor.execute("""
        SELECT employee_Id,first_name, last_name
        FROM hr.employees
        WHERE department_id = :did AND employee_id > :eid AND employee_Id = :empid""",
        did = 50,
        eid = 190,
        empid = 195
        )
for employeeid, fname, lname in cursor:
    print(employeeid,fname,lname)
        # df = pd.DataFrame([[fname, lname]], columns=["fname", "lname"])  
        # with pd.ExcelWriter("path_to_file.xlsx") as writer:
        #     df.to_excel(writer) 
conn.close()