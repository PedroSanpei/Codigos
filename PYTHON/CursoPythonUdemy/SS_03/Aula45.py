"""
Iterável - > str, range, etc (__iter__)
Iterador - > quem sabe entregar um valor por vez
next - > me entregue o próximo valor de um iter
iter - > me entregue seu iterador
"""


texto = 'Pedro' # Iterável
iterador = iter(texto) # Iterador

# for letra in texto:
# for faz exatamente isso por debaixo dos panos
while True:
    try:
        letra = next(iterador) # Pega meu Iterador e dá um next
        print(f'{iterador}= ',letra)
    except StopIteration:
        break
