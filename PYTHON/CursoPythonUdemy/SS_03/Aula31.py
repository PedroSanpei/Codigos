"""
Flag (Bandeira) - Marcar um local
None = Nenhum Valor
is e is not = é ou não é (Tipo, valor, identidade)
id = Identidade
"""

# ID
"""v1 = 'a'
v2 = 'a'
print(id(v1))
print(id(v2))
print(id(v1)==id(v2))"""

condicao = False
passsou_no_if = None

if condicao:
    passsou_no_if = True # Flag
    print('Faço Algo')
else:
    print('Não faça algo')
# print(passsou_no_if, passsou_no_if is None)
# print(passsou_no_if, passsou_no_if is not None)

if passsou_no_if is None:
    print('Não Passou no IF')
if passsou_no_if is not None:
    print('Passou no IF')