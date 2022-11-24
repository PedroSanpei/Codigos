"""
INTRODUÇÃO AO DESEMPACOTAMENTO (tuplas)
"""
# Toda vez que precisar desempacotar um valor apenas de uma lista,
# eu preciso passar a variável que irá pegar o valor desejado e
# uma variável resto. Para isso colocamos "*" na frente da variável resto
_,nome2, *_ = ['Pedro','Taíssa','Luiz']
print(_)