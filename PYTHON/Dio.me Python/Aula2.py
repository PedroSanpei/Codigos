from audioop import mul
a = int(input('Entre com o primeiro valor: ')) #interage com o usuário o mesmo pode digitar a informação na tela.
b = int(input('Entre com o segundo valor: '))  #interage com o usuário o mesmo pode digitar a informação na tela.

soma = a + b 
subtracao = a- b
multiplicacao = a * b
divisao = a / b
resto = a % b
RESULTADO =  ('Soma: {soma}.' 
        '\nSubração: {subtracao}. '
        '\nMultiplicação: {multiplicacao}'
        '\nDivisão: {divisao}'
        '\nResto: {resto}'   .format(soma=soma,subtracao=subtracao,multiplicacao=multiplicacao,divisao=divisao,resto=resto))
#x = '1'
#soma2 = int(x) + 1
print(RESULTADO)