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
        cursor3 = conn.cursor()

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
                pass

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

        # 1.2.1 INPUTS NOME, SOBRENOME, SENHA E E-MAIL
        v_nome = input('Digite o seu nome: ').lower()
        v_sobrenome = input('Digite o seu sobrenome: ').lower()
        v_password = input('Digite sua senha até 10 digítos: ')
        v_email = input('Informe seu e-mail: ')

        # 1.2.2 CRIAÇÃO DO LOGIN A PARTIR DO NOME E SOBRENOME
        login_cadastrado = v_nome + '.' + v_sobrenome

        # 1.2.3 VALIDADORES DE TAMANHO LOGIN E SENHA PADRÃO
        tam_log_pad = 20
        tam_pass_pad = 10

        # 1.2.3 CONDIÇÕES

        # 1.2.3.1 CONDIÇÃO 1
        if len(login_cadastrado) > tam_log_pad:
            print(f'Login não pode ser maior que 20 caracteres. O login digitado tem {len(login_cadastrado)} caracteres')

        # 1.2.3.2 CONDIÇÃO 2
        elif len(v_password) > tam_pass_pad:
            print(f'Senha não pode ser maior que 10 dígitos. A senha digitada tem {len(v_password)} dígitos')

        # 1.2.3.3 CONDIÇÃO 3
        else:
            print('Login e Senha criados com sucesso!')


            import win32com.client as win32

            # criar a integração com o outlook
            outlook = win32.Dispatch('outlook.application')

            # criar um email
            email = outlook.CreateItem(0)

            # configurar as informações do seu e-mail
            email.To = f"{v_email};"
            email.Subject = "Cadastro do Login e Senha"
            email.HTMLBody = f"""
            <p>Olá {v_nome} {v_sobrenome}, aqui é o da tela de Login da ativadade. Segue informações abaixo:</p>

            <p>O Seu Login é: {login_cadastrado}</p>
            <p>A Sua Senha é: {v_password}</p>

            <p>Abs,</p>
            <p>Código Python</p>
            """

            # anexo = "C://Users/joaop/Downloads/arquivo.xlsx"
            # email.Attachments.Add(anexo)

            email.Send()
            print("Email Enviado")
            break
