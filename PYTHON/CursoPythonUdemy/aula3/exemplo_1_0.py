"""
CONDIÇÕES IF, ELIF e ELSE
"""
print('SEJA BEM VINDO AO NOSSO SORTEIO')
print('REGRA: PRECISA ACERTAR PELO MENOS 2 NÚMEROS')
num_1 = int(input('Digite um número: '))
num_2 = int(input('Digite um Segundo número: '))
num_3 = int(input('Digite um Terceiro número: '))

if num_1 == 1:
    print('Correto')
elif num_1 != 1:
    print('Incorreto')
if num_2 == 2:
    print('Correto')
elif num_2 != 2:
    print('Incorreto')
if num_3 == 3:
    print('Correto')
elif num_3 != 3:
    print('Incorreto')
else:
    print('Puxa vida não foi dessa vez')