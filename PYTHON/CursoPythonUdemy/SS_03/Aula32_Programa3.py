def comprimento_nome():
    nome = input('Dígite seu nome cabra bom: ')
    comprimento = len(nome)
    try:
        if comprimento >= 6:
            print('Seu nome é muito grande')
        elif comprimento >= 4 and comprimento <= 6:
            print('Seu nome é normal')
        elif comprimento <= 4:
            raise ValueError
    except ValueError:
        print('Nome Muito Pequeno, o seu nome deve ter mais que 4 digitos, o nome atual tem: {}'.format(comprimento))
        return comprimento_nome()


comprimento_nome()
