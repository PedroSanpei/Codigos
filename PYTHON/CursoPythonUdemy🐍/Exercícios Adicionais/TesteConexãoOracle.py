from turtle import left

import cx_Oracle

uid = "PEDROSANPEI"  # usuário
pwd = "PEDRO8732"  # senha
db = "K2PRDB"  # string de conexão do Oracle, configurado no cliente Oracle, arquivo tnsnames.ora

connection = cx_Oracle.connect(uid + "/" + pwd + "@" + db)  # cria a conexão
cursor = connection.cursor()  # cria um cursor
cursor.execute("""  SELECT 
                    PO_HEADER_ID
                    ,SEGMENT1
                    ,to_char(CREATION_DATE, 'dd/mm/yyyy') CREATION_DATE
                    ,attribute1
                    FROM APPS.PO_HEADERS_ALL 
                    WHERE segment1 = '35117' """)  # consulta sql
result = cursor.fetchall
header = cursor.description
columns = [col[0] for col in header]
cursor.rowfactory = lambda *args: dict(zip(columns, args))
data = cursor.fetchone()
print(data)
