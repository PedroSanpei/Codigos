#PASSO A PASSSO - PROGRAMA PREMIAÇÃO VIA SMS
from ast import If
from msilib.schema import Condition, tables
from tkinter.tix import COLUMN
import pandas as pd
from pyparsing import line
from twilio.rest import Client

# Your Account SID from twilio.com/console
account_sid = "AC29a2578b007141ebd3f1d3790c8ac0ea"
# Your Auth Token from twilio.com/console
auth_token  = "b5e21fb8e0105a663b44725dca3a5aeb"
client = Client(account_sid, auth_token)

#ABRIR OS ARQUIVOS EM EXCEL
lista_meses = ['janeiro','fevereiro','março','abril','maio','junho']
for mes in lista_meses:
    tabela_vendas = pd.read_excel(f'{mes}.xlsx')
    if (tabela_vendas['Vendas'] > 55000).any():
        vendedor = tabela_vendas.loc[tabela_vendas['Vendas'] > 55000,'Vendedor'].values[0]
        vendas = tabela_vendas.loc[tabela_vendas['Vendas'] > 55000, 'Vendas'].values[0]
        print()
        message = client.messages.create(
            to="+5511975477498", 
            from_="+19562653914",
            body=f'No Mês {mes} alguém Bateu a meta! O vendedor {vendedor} bateu a meta com o valor R${vendas},00, ou Seja você me deve um negócinho Taíssa Sanpei')

        print(message.sid)

#PARA CADA ARQUIVOS:

#VERIFICAR SE HÁ ALGUM VALOR DE VENDA DA COLUNA VENDAS MAIOR QUE R$55.000,00

#by pedro