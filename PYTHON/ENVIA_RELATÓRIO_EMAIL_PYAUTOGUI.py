import pyautogui
import pyperclip
import time

pyautogui.PAUSE = 1

# pyautogui.click -> clicar
# pyautogui.press -> apertar 1 tecla
# pyautogui.hotkey -> conjunto de teclas
# pyautogui.write -> escreve um texto

# Passo 1: Entrar no sistema da empresa (no nosso caso é o link do drive)
pyautogui.press("win")
pyautogui.write("Microsoft Edge")
pyautogui.press("enter")
time.sleep(2)
pyautogui.hotkey("ctrl", "t")
pyperclip.copy("https://drive.google.com/drive/folders/149xknr9JvrlEnhNWO49zPcw0PW5icxga?usp=sharing")
pyautogui.hotkey("ctrl", "v")
pyautogui.press("enter")
time.sleep(5)

# Passo 2: Navegar no sistema e encontrar a base de vendas (entrar na pasta exportar)
pyautogui.click(x=439, y=330, clicks=2)
time.sleep(2)

# Passo 3: Fazer o download da base de vendas
pyautogui.click(x=464, y=431) # clicar no arquivo
pyautogui.click(x=1675, y=206) # clicar nos 3 pontinhos
pyautogui.click(x=1392, y=696) # clicar no fazer download
time.sleep(5) # esperar o download acabar

import pandas as pd

tabela = pd.read_excel(r"C:\Users\pedro\Downloads\Vendas - Dez.xlsx")

# Passo 5: Calcular os indicadores da empresa
faturamento = tabela["Valor Final"].sum()
print(faturamento)
quantidade = tabela["Quantidade"].sum()
print(quantidade)

# Passo 6: Enviar um e-mail para a diretoria com os indicadores de venda

# abrir aba
pyautogui.hotkey("ctrl", "t")

# entrar no link do email - https://mail.google.com/mail/u/0/#inbox
pyperclip.copy("https://mail.google.com/mail/u/0/#inbox")
pyautogui.hotkey("ctrl", "v")
pyautogui.press("enter")
time.sleep(5)

# clicar no botão escrever
pyautogui.click(x=93, y=197)

# preencher as informações do e-mail
pyautogui.write("prubio05@gmail.com")
pyautogui.press("tab") # selecionar o email

pyautogui.press("tab") # pular para o campo de assunto
pyperclip.copy("Relatório de Vendas")
pyautogui.hotkey("ctrl", "v")

pyautogui.press("tab") # pular para o campo de corpo do email

texto = f"""
Prezados,

Segue relatório de vendas.
Faturamento: R${faturamento:,.2f}
Quantidade de produtos vendidos: {quantidade:,}

Qualquer dúvida estou à disposição.
Att.,
By Python Lecote
"""

# formatação dos números (moeda, dinheiro)

pyperclip.copy(texto)
pyautogui.hotkey("ctrl", "v")
pyautogui.click(x=1329, y=982)
arquivo = r'C:\Users\pedro\Downloads\Vendas - Dez.xlsx'
pyautogui.write(arquivo)
pyautogui.press("enter")
# enviar o e-mail
pyautogui.hotkey("ctrl", "enter")


#Mapeamento de tela 
#time.sleep(5)
#pyautogui.position()