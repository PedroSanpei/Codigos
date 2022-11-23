frase = 'O Python é uma linguagem de programação' \
		'multiparadigma. '\
		'Python foi criado por Guido van Rossum'

i = 0
qtd_apareceu_mais_vezes = 0
letra_apareceu_mais_x = ''

while i < len(frase):
    letra_atual = frase[i]

    if letra_atual == ' ':
        i += 1
        continue

    qtd_atual = frase.count(letra_atual)

    if qtd_aparicoes < qtd_atual:
        qtd_aparicoes = qtd_atual
        letra_apareceu_mais_x = letra_atual

    i += 1

print(
    'A letra que apareceu mais vezes foi '
    f'"{letra_apareceu_mais_x}" que apareceu '
    f'{qtd_aparicoes}x'
)