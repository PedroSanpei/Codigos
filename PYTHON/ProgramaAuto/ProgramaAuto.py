import pyautogui
import pyperclip
import time
import os
os.system("taskkill /f /im JogoForca.exe")  # Roda o término do programa
os.system("net stop EpicOnlineServices")    # Para o Serviço
os.system("net start EpicOnlineServices")   # Inicia o Serviço

pyautogui.PAUSE = 1

pyautogui.hotkey('win', 'r')  # Comando Teclado Windows + R
pyperclip.copy('C:\WORKSPACE\Codigos\PYTHON\JogoForca\dist')  # Caminho para colar na Aba executar
pyautogui.hotkey('ctrl', 'v')  # Cola na aba Executar
pyautogui.press('enter')  # Dá enter
pyautogui.press('down')  # Clica no botão para baixo
pyautogui.press('enter')