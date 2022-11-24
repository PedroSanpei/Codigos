lista = ['Pedro','Taísa','Japa']

lista_enumerada = list(enumerate(lista)) # ITERADOR

# COM ITERADOR VOCÊ USA O NEXT
# print(next(lista_enumerada))
# print(next(lista_enumerada))
# print(next(lista_enumerada))
# print(next(lista_enumerada))

print(lista_enumerada)
# RESULTADO ACIMA É O MESMO QUE FAZER O FOR
for indices in enumerate(lista):
    indice, nome = indices
    print(indice, nome, sep='-')

# A Mesma coisa de fazer o que estiver acima
for indice, nome in enumerate(lista):
    print(indice, nome)
    
# Outra Forma de fazer o primeiro exemplo
for tupla_enumerada in enumerate(lista):
    for valor in tupla_enumerada:
        print(f'\t{valor}')