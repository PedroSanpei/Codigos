num1 = input('Digite o Valor: ')
num2 = input('Digite o Valor: ')

# STRING METHODS: isnumeric isgiti isdecimal
# https://docs.python.org/3/library/stdtypes.html
# Em vez de usar os STRING METHODS pode usar esse código abaixo:
# https://github.com/luizomf/check-numbers-python/blob/master/chk_numbers.py

try:
    num1 = int(num1)
    num2 = int(num2)
    print(num1 + num2)
except:
    print('ERROR')

"""
if num1.isdigit() and num2.isdigit():
    num1    =   int(num1)
    num2    =   int(num2)
    print(num1 + num2)
else:
    print('Não pude converter os números para realizar contas')
"""
