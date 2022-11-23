"""
WHILE + ELSE
"""
string = 'ValorQualquer'

i = 0

while i < len(string):
    letra = string[i]

    if letra == ' ':
        break

    i += 1
    print(letra)
else:
    print('O Else foi executado')
print('Fora do While')