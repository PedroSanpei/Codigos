"""
-----------------------------------------------------------------------
                             DATA TYPES                                |
-----------------------------------------------------------------------
TYPE        MEANING                EXAMPLE                             |
-----------------------------------------------------------------------
str     -   string                  Ex: 'Olá World'                    |
int     -   inteiro                 Ex: 123456, 0, -10, -20, -50, -60  |
float   -   real/ponto flutuante    Ex: 0.10, 0.1, 0.0                 |
bool    -   booleano/lógico         Ex: True/False Ex: 10 == 10 (TRUE) |
-----------------------------------------------------------------------

"""
#VENDO O TIPO DE CADA VARIÁVEL
print('Luiz', type('Luiz'))
print(10,     type(10))
print(0.10,   type(0.10))
print(10 == 10, type(10 == 10))
print(bool(0))
print(type('Luiz'), bool('luiz'))
print('10', type('10'), type(int('10')))
print('luiz', float('10.1'))
print(int('10') + 10)

# EXERCÍCIO
print('EXERCÍCIO')
# NOME: STRING
print('Nome:', 'Pedro', type('Pedro'))
# IDADE: INT
print('Idade:', 26, type(26))
# ALTURA: FLOAT
print('Altura:', 1.80, type(1.80))
# É MAIOR DE IDADE
print('É MAIOR DE IDADE?', 26>18, type(26>18))