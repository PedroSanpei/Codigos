"""
                                            EXERCÍCIO
1- Criar Variáveis para nome(str), idade(int), altura(float) e peso(float) de uma pessoa
2- Criar Varável com o ano atual(int)
3- Obter o ano de nascimento da pessoa (Baseando-se na idade e no ano atual)
4- Obter o IMC da Pessoa com 2 casas decimais (peso e na altura da pessoa)
5- Exibir um texto com todos os valores na tela usando o F-STRINGS (com as chaves)
"""
from datetime import date
nome        =   'Pedro Sanpei'
idade       =   26
peso        =   87
altura      =   1.80
ano_atual   =   2022
imc         =   peso/(altura**2)
data_nasc   =   ano_atual - idade

print("""{n} tem {i} anos de idade e nasceu no ano de {dn}.Tem como {a:.2f} de altura, pesa {p}kg e seu IMC é {im:.2f}""".
      format(n=nome, i=idade, dn=data_nasc, a=altura, p=peso, im=imc))