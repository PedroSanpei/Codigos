"""
OPERADORES RELACIONAIS
==  igual
>   maior que
>=  maior igual que
<   menor que
<=  menor igual que
!=  diferente
"""
"""
num_1 = int(input('Digite um número: ')) # int
num_2 = int(input('Digite um número: '))

expressao = num_1 == num_2
expressao1 = num_1 > num_2
expressao2 = num_1 >= num_2
expressao3 = num_1 < num_2
expressao4 = num_1 <= num_2
expressao5 = num_1 != num_2

print(expressao)
print(expressao1)
print(expressao2)
print(expressao3)
print(expressao4)
print(expressao5)
"""

nome    = input('Qual seu nome? ')
idade   = int(input('Qual sua idade? '))
idade_menor = 18
idade_maior = 30

if idade >= idade_menor and idade <= idade_maior:
    print('O {} PODE PEGAR O EMPRÉSTIMO'.format(nome))
else:
    print('O {} NÃO PODE PEGAR O EMPRÉSTIMO'.format(nome))
