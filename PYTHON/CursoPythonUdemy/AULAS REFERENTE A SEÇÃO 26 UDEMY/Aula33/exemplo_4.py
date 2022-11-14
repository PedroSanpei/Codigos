"""
MANIPULANDO STRINGS

* STRING INDICES
* FATIAMENTO DE STRINGS [inicio:fim:passo]
* FUNÇÕES DE built-in len, abs, type, print, etc...

ESSAS FUNÇÕES PODEM SER USADAS DIRETAMENTE EM CADA TIPO

Você pode conferir tudo isso em:
https://docs.python.org/3/library/stdtypes.html
https://docs.python.org/3/library/functions.html

"""
# positivos       [012345678]
texto           = 'Python s2'
#negativos       -[987654321]
texto1          = 'Python s2'
url             = 'www.google.com.br/'
# FATIAMENTO
nova_string  = texto[0:5]  # Fatiamento str[pos1:pos2]
nova_string2 = texto[:6]   # Fatiamento positivo do 0 a 6 [:pos2]
nova_string3 = texto[:-1]  # Fatiamento Negativo do -9 a -1 [:-1]
nova_string4 = texto[0:9:2]  # Fatiamento positivo com saltos [pos1:pos2:qtd. saltos]
nova_url = url[1]  # Indice [Pos]
# IMPRESSÃO FATIAMENTO
print(texto[0:5])
print(nova_string)
print(nova_string2)
print(nova_string3)
print(nova_string4)
print(nova_url)

# LEN
mylist = ["apple", "banana", "cherry"]
lista  = 'Apple'
x = len(mylist)  # Mede a quantidade itens da Lista
y = len(lista)  # Mede a quantidade de Caracteres da palavra
# IMPRESSAO LEN
print(x)
print(y)

# ABS
number = -20.5
absolute_number = abs(number)
# IMPRESSAO ABS
print(absolute_number)

# TYPE
string    = 'nome'
inteiro   = 1
flutuante = 1.5
booleano  = True
# IMPRESSAO TYPE
print(string, type(string))
print(inteiro, type(inteiro))
print(flutuante, type(flutuante))
print(booleano, type(booleano))


