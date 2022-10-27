"""
For in em Python
Iterando Strings com for
Função range(start=0, stop, step=1)
"""
# USANDO O FOR E ENUMERATE
"""texto = 'Python'
for n, letra in enumerate(texto):  # Ele cria um indíce a cada laço
    print(n, letra)"""

# USANDO O FOR COM RANGE
"""for numero in range(0, 100, 8):
    print(numero)"""

# USANDO O FOR COM RANGE MAIS OPERADORES
"""for n in range(100):
    if n % 8 == 0:
        print(n)"""
#
texto = 'Pedro'
nova_string = ''
    #  continue - pula para o próximo laço
    #  break - termina a interação

for letra in texto:
    if letra == 'd':
        nova_string = nova_string + letra.upper()
    elif letra == 'o':
        nova_string += letra.upper()
        break
    else:
        nova_string += letra
print(nova_string)