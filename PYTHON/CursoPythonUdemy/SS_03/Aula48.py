"""
                                    LISTAS EM PYTHON

Tipo list - Mutável
Suporta vários valores de qualquer tipo.
Conhecimento reutilizáveis - índices e fatiamento

MÉTODOS ÚTEIS: 
append - Adiciona um item ao final da lista,
insert - Adiciona um item no índice escolhido,
pop - Remove do final ou do índice escolhido,
del - apaga um índice,
clear - limpa a lista,
extend - estente a lista,
+ - concatena a lista
Create, Read, Update, Delete
"""
# EXEMPLO 1 - Video 79
# string = 'ABCDE'

# #              INDICE              #
# #-------  0    1       2      3    4
lista = [123, True, 'Pedro', 1.2, []]
# #------- -5   -4      -3     -2   -1
lista[2] = 'Taíssa'
print(lista[2], type(lista[2]))


# EXEMPLO 2 - Vídeo 80
# # USANDO MÉTODOS
lista2 = [10, 20, 30, 40]
numero = lista2[2] = 300
del lista2[2]
lista2.append(50)
lista2.append(60)
lista2.append(70) # Adiciona valor na lista
ultimo_valor = lista2.pop() # POP Remover o último valor da lista
ultimo_valor = lista2.pop(2) # POP Remover o valor da lista pelo índice
print(ultimo_valor)
print(lista2)


# EXEMPLO 3 - Vídeo 81
lista = [10, 20, 30, 40]
# lista.clear()
lista.insert(0, 5)
print(lista)


#EXEMPLO 4 - Vídeo 82
lista_a = [1, 2, 3]
lista_b = [4, 5, 6]
lista_c = lista_a + lista_b
lista_d = lista_a.extend(lista_b)
print(lista_d)