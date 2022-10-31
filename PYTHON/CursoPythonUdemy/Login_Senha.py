"""
OBJETIVO CRIAR UM PROGRAMA DE LOGIN E SENHA QUE BUSCA A INFORMAÇÃO DE UM BANCO DE DADOS
"""


def login_senha():
    while True:
        # IMPORTAR A BIBLIOTECA PANDA
        import pandas as pd
        # LER O EXCEL
        planilha = pd.read_excel("C:\\WORKSPACE\\Codigos\\PYTHON\\CursoPythonUdemy\\Dados.xlsx",
                                 sheet_name='dados_user')
        # INPUTS DE LOGIN E SENHA
        login = input('Digite seu Login: ')
        password = int(input('Digite sua Senha: '))

        # LISTA DE CHECAGEM DE LOGIN E SENHA COM BASE NA PLANILHA
        check_login = set(list(planilha['LOGIN']))
        check_senha = set(list(planilha['SENHA']))

        # CONDIÇÕES DE VALIDAÇÃO
        if login in check_login and password in check_senha:
            print(f'Seja Bem Vindo {login}')
            break
        elif login not in check_login and password in check_senha:
            print('Login Incorreto tente novamente')
            sair = input('Tentar Novamente?  [s]im ou [n]ão: ')
            if sair == 'n':
                break
        elif login in check_login and password not in check_senha:
            print('Senha Incorreta')
            sair = input('Tentar Novamente?  [s]im ou [n]ão: ')
            if sair == 'n':
                break
        else:
            print('Login e Senha incorretos')


login_senha()

