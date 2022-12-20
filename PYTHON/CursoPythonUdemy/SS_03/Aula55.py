"""
Imprecisão de Números de ponto flutuante    
Double-precision floating-point format IEE 754
"""
import decimal

numero_1 = 0.1
numero_2 = 0.7
numero_3 = numero_1 + numero_2
numero_4 = str(numero_1 + numero_2)
print(numero_3)
print(f'{numero_3:2f}')
print(round(numero_3,10))
print(decimal.Decimal(numero_4))