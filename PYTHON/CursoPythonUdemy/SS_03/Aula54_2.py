"""
Faça uma lista de compra com listas
O Usuário deve ter a possibilidade de 
inserir ou apagar e listar valores da sua lista.
Não Permita que o programa quebre com erros de índices
inexistentes na lista
"""
import os

lista = []
lista_temp = []

while True:
    opcao = input('''Escolha uma das opções abaixo:
    [I]nserir
    [L]istar
    [A]pagar

Digite a opção aqui: ''')

    if  opcao   ==  'i':
        while True:
            os.system('cls')
            valor = input('Insira o Produto na lista: ')
            lista_temp.append(valor)
            for i, valor in enumerate(lista_temp):
                valor_2 = (f"{i}-{valor}") 
            lista.append(valor_2)
    
            sair = input('Deseja Sair? Se sim pressiona [S]: ')
            if sair == 's':
                break
        os.system('cls')


    elif opcao == 'l':
        if  lista != []:    
            print(f'\t{lista}')
        else:
            print('\tLista Vazia')
    

    elif opcao == 'a':
        os.system('cls')
        
        if len(lista) == 0:
            print('Lista Vazia')
            continue
        else:
            while True:
                try:
                    print('\tLISTA DE COMPRAS')
                    print(lista)
                    apagar = int(input('Selecione o item que deseja apagar: '))
                    del lista[apagar]
                except ValueError:
                    print('Por favor digite um número')
                except IndexError:
                    print('Índice não existe na lista')
                except Exception:
                    print(f'Erro Desconhecimento, {Exception}')
                sair1 = input('Deseja Sair? Se sim pressiona [S]: ')
                if sair1 == 's':
                     break
                os.system('cls')

    else:
        print('\tESCOLHA UMA DAS OPÇÕES DO MENU POR FAVOR!')