secreto = 'perfume'
digitadas = []
chances = len(secreto)

while True:
    if chances <= 0:
        print('Você Perdeu!!!!')
        break
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

    secreto_temporario = ''
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

    if letra not in secreto:
        chances -= 1
    print(f'Você ainda tem {chances} chances.')
    print()

