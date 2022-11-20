"""
LISTAS EM PYTHON 123
FATIAMENTO
APPEND, INSERT, POP, DEL, CLEAR, EXTEND, +, MIN, MAX RANGE
"""

"""#INDEX +    0    1       2    3    4         5     6
lista1 =   ['A', 'Bife', 'C', 'D', 'Escuela', 10.5, 10]
#INDEX -    7    6       5    4    3         2     1

lista2 =   [1, 2, 2.1, 3, 4]

print(lista1, lista2)"""

"""# FORMATAÇÃO DE UM INDEX DA LISTA
lista1[5] = 'Qualquer Coisa'

# FATIAMENTO DE UMA LISTA
print(lista1[0], lista1[5])

l1 = [1, 2, 3]
l2 = [4, 5, 6]
print(l2)
l2.insert(0, 'maça')
print(l2)
l2.pop()
print(l2)
l3 = l1 + l2   # JUNTA A LISTA COM A LISTA DOIS USANDO O EXTEND
l1.extend(l2)  # JUNTA A LISTA COM A LISTA DOIS USANDO O EXTEND
l2.append('A')
l3.insert(0, 'banana')  # INSERE UM INDEX NA LISTA (indice, dados que deseja inserir
"""

"""    # 0  1  2  3  4  5  6  7  8
l2 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
print(l2)
l2.insert(0,'banana')  # INSERE INDICE
print(l2)
del(l2[0])  # DELETA INDICE
print(l2)
print(max(l2))  # MAX
print(min(l2))  # MIN
"""


"""l2: list[Any] = list(range(1, 100))  # criar lista usando o range
l3 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]"""

"""l3 = ['String', True, 10, -20.5]
for elem in l3:
    print(f'O Tipo de elem é {type(elem)} e seu valor é {elem}')"""


secreto = 'perfume'
digitadas = []
while True:
    letra = input('Digite uma Letra: ')
    if len(letra) > 1:
        print('Ahhhh isso não vale digite apenas uma letra.')
        continue

    elif len(letra) <= 0:
        print('Não pode ser vazio')
        continue

    elif letra.isdigit():
        print('Tem que ser uma Letra')
        continue

    digitadas.append(letra)

    if letra in secreto:
        print(f'Que legal! A Letra {letra} existe na palavra secreta')

    else:
        print(f'Affzzz: A Letra {letra} Não Existe na palavra Secreta')
        digitadas.pop()

    secreto_temporario  = ''
    for letra_secreta in secreto:
        if letra_secreta in digitadas:
            secreto_temporario += letra_secreta
        else:
            secreto_temporario += '*'

    if secreto_temporario == secreto:
        print('Você Ganhouuuuuuuuuuuuuuu!!!!!!')
        break
    else:
        print(f'A Palavra Secreta está assim: {secreto_temporario}')
