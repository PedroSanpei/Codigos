"""
Iterando strings com while
"""
#       0 1 2 3 4 5 6 7 8 9
# nome = 'L u i z O t á v i o'  # Iteráveis
# #      10 9 8 7 6 5 4 3 2 1
# tamanho_nome = len(nome)
# print(nome)
# print(tamanho_nome)
# print(nome[3])

# nova_string = ''
# nova_string += '*L*u*i*z* *O*t*á*v*i*o'

nome = 'Pedro'
tamanho_nome = len(nome)
nova_string = ''
indice = 0


while nova_string != nome:
    letra = nome[indice]
    nova_string += letra
    print(nova_string)
    indice +=1
    


