"""
split e join usamos para list e str 
(Split divide uma string em um caracter)
(Join une uma string)
strip corta os espaços 
rstrip corta espaço da direita, 
lstrip corta espaço da esquerda
"""
frase = 'Olha o quebra, queixo, coquinho'

lista_frases_cruas = frase.split(', ')
lista_frases = []

for i, frase in enumerate(lista_frases_cruas):
    lista_frases.append(lista_frases_cruas[i].strip())


# print(lista_frases_cruas)
# print(lista_frases)


frases_unidas = ', '.join(lista_frases_cruas) # JOIN PERMITE APENAS ITERÁVEIS
print(frases_unidas)