import cx_Oracle
import csv

cx_Oracle.init_oracle_client(lib_dir=r"C:\oracle\instantclient_19_16")
dsn_tns = cx_Oracle.makedsn('PEDRO-DESK', '1521', service_name='XE') # if needed, place an 'r' before any parameter in order to address special characters such as '\'.
conn = cx_Oracle.connect (user=r'pedro', password='pedro123', dsn=dsn_tns) # if needed, place an 'r' before any parameter in order to address special characters such as '\'. For example, if your user name contains '\', you'll need to place 'r' before the user name: user=r'User Name'
print('A Versão é:', conn.version)
cursor = conn.cursor()
cursor.execute("""
        SELECT first_name, last_name
        FROM hr.employees
        WHERE department_id = :did AND employee_id > :eid""",
        did = 50,
        eid = 190)
for fname, lname in cursor:
    resultado = fname + ' ' +  lname
    print(resultado)
    with open('LOG.csv', 'w', encoding='UTF8', newline='') as f:
        
        writer = csv.writer(f)
        #header = ['fname','lname']
        data = [resultado]
        
        # write the header
        #  writer.writerow(header)

            # write the data
        writer.writerow(data)
conn.close()