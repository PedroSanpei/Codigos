#   ITERAR STRINGS COM WHILE
#   INDICES
#        0123456789.......................33

frase = 'o rato roeu a roupa do rei de roma'  # ITERÁVEL
tamanho_frase = len(frase)
print(tamanho_frase)
contador = 0
nova_string = ''
input_do_usuario = input('Qual letra deseja colocar maiúscula: ')
# ITERAÇÃO <- ITERAR
while contador < tamanho_frase:
    letra = frase[contador]
    if letra == input_do_usuario:
        nova_string += input_do_usuario.upper()
    else:
        nova_string += letra
    contador += 1

print(nova_string)
