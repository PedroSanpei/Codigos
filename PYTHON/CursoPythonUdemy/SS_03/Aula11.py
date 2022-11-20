# ORDEM DA PRECEDÊNCIA DE UM CÁLCULO
# 1º (n + n) -> Executar o que está dentro do parenteses
# 2º ** -> Exponenciação
# 3º * = multiplicação, / = divisão, // = divisão inteira, % = módulo
# 4º + -
conta_1 = (1 + int(0.5 + 0.5)) ** (5 + 5)
print(conta_1)