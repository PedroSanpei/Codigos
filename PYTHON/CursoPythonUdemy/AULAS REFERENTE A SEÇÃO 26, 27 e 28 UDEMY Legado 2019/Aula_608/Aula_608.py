"""

FORMATANDO VALORES COM MODIFICADORES

:s          - TEXTO (STRINGS)
:d          - INTEIROS (INT)
:f          - NÚMEORS DE PONTO FLUTUANTE (FLOAT)
:.(NÚMERO)f - QUANTIDADE DE CASAS DECIMAIS (FLOAT)
:(CARACTERE)(> ou < ou ^)(QUANTIDADE)(TIPO -s, d ou F)

> - Esquerda
< - Direita
^ - Centro

"""
"""
num1 = 10
num_2 = 3
divisao = num1 / num_2
print('{:.2f}'.format(divisao))
"""

num1 = 1
print(f'{num1:0>10}')  # PREENCHE COM 0 A ESQUERDA ATÉ DER 10 CARACTERES
num1 = 1
print(f'{num1:0<10}')  # PREENCHE COM 0 A DIREITA ATÉ DER 10 CARACTERES
num2 = 1150
print(f'{num2:0>10}')  # PREENCHE COM 0 A ESQUERDA ATÉ DER 10 CARACTERES
num3 = 1150
print(f'{num3:0^10}')  # PREENCHE COM 0 NO CENTRO ATÉ DER 10 CARACTERES
num4 = 1150
print(f'{num4:0>10.2f}')  # PREENCHE COM 0 A ESQUERDA E ADICIONA 2 CASAS DECIMAIS ATÉ DER 10 CARACTERES

nome = 'Pedro SaNpeI'
print((50-len(nome)) / 2)  # CONTA QUANTOS CARACTERES DIVIDE POR 2 E 
print(f'{nome:#^50}')
print(nome.lower())
print(nome.upper())
print(nome.title())

print('Segue o espaço do TAB: \t. Agora a representação crua: %r.' % '\t')
