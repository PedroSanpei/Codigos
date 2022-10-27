"""
WHILE EM PYTHON

Utilizando para realizar ações enquanto uma condição for verdadeira.

Requisitos: Entender Condições e Operadores
"""

# WHILE CONTAGEM
"""x = 0

while x <= 10:
    if x == 3:
        x = x + 1
        break
    print(x)
    x = x + 1
print('Acabou')"""

# WHILE USANDO CIRCULOS
"""
Ele irá rodar o y até ele fechar um circulo de y = 5 e depois vai começar um loop até o X = 10 Y = 5
"""
"""x = 0

while x <= 10:
    y = 0
    while y <= 5:
        print(f'({x},{y})')
        y += 1
    x += 1
print('Acabou')"""

# EXEMPLO WHILE CALCULADORA
while True:
    print()
    num_1 = input('Digite um número: ')
    num_2 = input('Digite outro número: ')
    operador = input('Digite um operador: ')
    sair = input('Deseja Sair?  [s]im ou [n]ão: ')

    if sair == 's':
        break

    if not num_1.isnumeric() or not num_2.isnumeric():
        print('Você precisa colocar um número')
        continue

    num_1 = int(num_1)
    num_2 = int(num_2)

    if operador == '+':
        print(num_1 + num_2)
    elif operador == '-':
        print(num_1 - num_2)
    elif operador == '/':
        print(num_1 / num_2)
    elif operador == '*':
        print(num_1 * num_2)
    else:
        print('Operador Não Existe')




