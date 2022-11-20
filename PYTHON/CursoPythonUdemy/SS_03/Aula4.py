"""Tipos int e float
int -> Número Inteiro
O Tipo int representa qualquer número positivo ou negativo. int sem sinal é considerado positivo
"""

INT = 11, -11, 0
print(INT)

"""
flot -> Número com ponto flutuante.
O Tipo float represent qualquer número positivo ou negativo com ponto flutuante.
O float sem sinal é considerado positivo
"""
FLOAT = 1.1, -1.1, 0
print(FLOAT)
"""
A Função type mostra o tipo que o Python inferiu ao valor
"""
print(f'Os números',11, -11, 0, 'são do tipo: ', type(0), )
print(f'Os números',11.1, -11.1, 0.1, 'são do tipo: ', type(0.1))