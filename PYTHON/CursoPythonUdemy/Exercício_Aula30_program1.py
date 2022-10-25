# PROGRAMA IMPAR OU PAR
def programa_imp_par() -> object:
    num1 = input('Digite um número Inteiro :')
    try:
        num1 = int(num1) % 2
        print('Número Inteiro Confirmado')
        if num1 == 0:
            print('Par')
        else:
            print('Impar')
    except ValueError:
        print('Erro: Não é um Número Inteiro, tente novamente')
        return programa_imp_par()


programa_imp_par()
