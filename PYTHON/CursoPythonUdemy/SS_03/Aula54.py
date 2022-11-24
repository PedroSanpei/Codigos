"""
Faça uma lista de compra com listas
O Usuário deve ter a possibilidade de 
inserir ou apagar e listar valores da sua lista.
Não Permita que o programa quebre com erros de índices
inexistentes na lista
"""
import os

lista = []
indices = enumerate(lista)

while True:

    menu_inicial = input("""SEJA BEM VINDO A SUA LISTA DE COMPRAS!!!
Você deseja:
[I]nserir
[D]eletar
[L]istar
[S]air: """)

    # CONDIÇÃO PARA INSERIR NA LISTA
    if menu_inicial == 'i':
        while True:
            valor_lista = input('Digite o que deseja colocar na sua lista: ')
            lista.append(valor_lista)
            print(lista)
            sair = input('Deseja Sair? [S] ou [N]: ')
            if sair == 's':
                os.system('cls')
                break
    
    elif menu_inicial == 'l':

        print('\tA SUA LISTA ATUAL É ESSA:')
        if lista == []:
            print('\tLista Vazia')
            continue
        else:
            for indice in indices:
                indice2, produto2 = indice
                print(f'\t{indice2} - {produto2}')
    
    elif menu_inicial == 'd':
        print(lista)

    elif menu_inicial == 's':
        break

    else:
        print('Essa opção não existe no nosso menu')
                
            
        
    

