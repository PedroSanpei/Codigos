"""
CUIDADO COM DADOS MUTÁVEIS

= - copiado o valor (imutáveis)
= - aponta para o mesmo valor na memória mutável
"""

lista_a = ['Pedro', 'Taíssa']
lista_b = lista_a.copy()
lista_a[0] = 'Qualquer coisa'
lista_b.insert(0,'Cunha')
print(f'ID: {id(lista_a)}-> ', lista_a)
print(f'ID: {id(lista_b)}-> ', lista_b)