# JOGO FORCA

# VARIÁVEIS
secreto = 'perfume'
digitadas = []
chance = len(secreto)
tentativa = 0

# INICIO DO LOOP
while True:
    print(f'VOCÊ TEM {chance} CHANCES BOA SORTE!!!')
    letra = input('Digite uma Letra: ')

    # CONDIÇÃO DE TENTATIVAS
    tentativa +=1
    if tentativa == chance:
        print('Acabaram as suas chances')
        break

    # CONDIÇÃO VALIDA SE VOCÊ DIGITOU MAIS DE UMA LETRA NO INPUT    
    if len(letra) > 1:
        print('Ahhhh isso não vale digite apenas uma letra.')
        continue

    # CONDIÇÃO VALIDA SE VALOR FOR NULO    
    elif len(letra) <= 0:
        print('Não pode ser vazio')
        continue

    # CONDIÇÃO VALIDA SE ESTÁ DIGITANDO UM NÚMERO
    elif letra.isdigit():
        print('Tem que ser uma Letra')
        continue

    # ACRESCENTA A LETRA DIGITADA NA VÁRIAVEL DE LISTA "DIGITADAS"     
    digitadas.append(letra)

    # CONDIÇÃO PARA VALIDAR SE A LETRA DIGITADA ESTÁ NA PALAVRA SECRETA
    if letra in secreto:
        print(f'Que legal! A Letra {letra} existe na palavra secreta')

    else:
        print(f'Affzzz: A Letra {letra} Não Existe na palavra Secreta')
        digitadas.pop()

    # VARIÁVEL TEMPORÁRIA PARA IR GUARDANDO AS LETRAS DIGITADS QUE FORMARÃO A PALAVRA SECRETA.
    secreto_temporario  = ''

    # lOOP para validar se cada letra digitada está na palavra secreta
    for letra_secreta in secreto:
        # Caso letra digitada estiver na palavra secreta, adiciona letra na váriavel
        if letra_secreta in digitadas:
            secreto_temporario += letra_secreta
        # Caso Letra digitada não estiver na palavra secreta, adiciona *
        else:
            secreto_temporario += '*'

    if secreto_temporario == secreto:
        print('Você Ganhouuuuuuuuuuuuuuu!!!!!!')
        print('A Palavra era', secreto)
        break
    else:
        print(f'A Palavra Secreta está assim: {secreto_temporario}')
