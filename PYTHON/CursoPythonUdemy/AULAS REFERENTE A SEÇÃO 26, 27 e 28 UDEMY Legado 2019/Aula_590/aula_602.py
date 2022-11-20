"""
OPERADORES LÓGICOS

and
or
not
in
not in
"""

login = input('Digite o seu usuário: ')
senha = input('Digite a sua senha: ')

usuario_bd = 'Pedro'
senha_bd = 'ncbpm@250696**'

if usuario_bd == login and senha_bd == senha:
    print(f'Seja Bem Vindo ao nosso sistema {login}')
if usuario_bd != login and senha_bd == senha:
    print(f'O Usuário {login} não está cadastrado, verifique por favor')
if usuario_bd == login and senha_bd != senha:
    print(f'A Senha está incorreta')
if usuario_bd != login and senha_bd != senha:
    print('Usuário e Senha Incorretos')
