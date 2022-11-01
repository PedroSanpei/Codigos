# INICIA O ORACLE CLIENT
import cx_Oracle

cx_Oracle.init_oracle_client(lib_dir=r"C:\oracle\instantclient_19_16")
# Enquanto tudo abaixo for Verdadeiro

while True:
    # 1 -LOGAR OU SE CADASTRAR
    login_page = int(input("""1- Logar, 2- Cadastar: """))
    # 1.1 LOGAR-SE
    if login_page == 1:

        # 1.1.1 INPUTS DE LOGIN E SENHA
        login = input('Digite seu Login: ')
        password = int(input('Digite sua Senha: '))

        # 1.1.2 CONEXÃO ORACLE

        # 1.1.3 VARIÁVEL COM CONFIGURAÇÃO TNS
        dsn_tns = cx_Oracle.makedsn('PEDRO-DESK', '1521', service_name='XE')

        # 1.1.4 CONEXÃO COM O BANCO DE DADOS
        conn = cx_Oracle.connect(user=r'pedro', password='pedro123', dsn=dsn_tns)

        # 1.1.5 MONTANDO CURSOR
        cursor1 = conn.cursor()
        cursor2 = conn.cursor()

        # 1.1.6 EXECUTANDO O CURSOR COM UM SELECT
        check_login = cursor1.execute(f"SELECT nvl(LOGIN,'') FROM LOGIN_SENHA WHERE LOGIN = '{login}'")
        check_senha = cursor2.execute(f"SELECT nvl(SENHA, '') FROM LOGIN_SENHA WHERE LOGIN = '{login}'")

        # 1.1.7 PASSANDO UMA VARIÁVEL PARA TRAZER O RESULTADO DO SELECT
        data1 = check_login.fetchone()
        data2 = check_senha.fetchone()

        # 1.1.8 CONDIÇÕES DE VALIDAÇÃO

        # 1.1.8.1 CONDIÇÃO 1
        if data1 is None and data2 is None:
            print('Login Inexistente. Cadastre-se')
            cadastrar_se = input('Deseja se cadastrar?  [s]im ou [n]ão: ')
            if cadastrar_se == 'n':
                break
            elif cadastrar_se == 's':
                login_page2 = int(input("""Digite 2- Para Cadastrar-se """))

        # 1.1.8.2 CONDIÇÃO 2
        elif login in data1 and password != data2:
            print('Senha Incorreta')
            sair = input('Tentar Novamente?  [s]im ou [n]ão: ')
            if sair == 'n':
                break

        # 1.1.8.3 CONDIÇÃO 3
        elif login in data1 and password in data2:
            print(f'Seja Bem Vindo {login}')
            break

    # 1.2 CADASTRAR-SE

    elif login_page == 2:
        login_cadast = input('Digite nome.sobrenome: ')
        # # passw_cadast = input('Digite uma senha de até 3 digitos: ')
        # import openpyxl
        # from openpyxl import load_workbook
        # arquivo_excel = openpyxl.load_workbook("C:\\WORKSPACE\\Codigos\\PYTHON\\CursoPythonUdemy\\Dados.xlsx")
        # planilha1 = arquivo_excel.active
        #
        # max_linha = planilha1.max_row
        # for i in range(1, max_linha):
