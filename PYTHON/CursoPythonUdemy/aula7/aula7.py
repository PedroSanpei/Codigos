"""
AULA DE FORMATAÇÃO DE STRINGS
"""

nome    =   'Pedro Sanpei'
idade   =   32
altura  =   1.80
e_maior =   idade > 18
peso    =   80
imc     =   peso /(altura**2)

#  antes de uma string, permite que coloque as variáveis dentro do texto
print(f'{nome} tem {idade} anos de idade e seu imc é {imc:.2f}')
# Posso passar as chaves vazias e no final passar o format com as váriaveis
print('{} tem {} anos de idade e seu imc é {:.2f}'.format(nome, idade, imc))
# Posso passar o valor das chaves com letras e atribuir nos formatos
print('{n} tem {i} anos de idade e seu imc é {id:.2f}'.format(n=nome, i=idade, id=imc))