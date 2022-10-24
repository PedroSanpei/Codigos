nome    =   input('Qual Seu Nome? ')
idade   =   input('Qual sua Idade? ')
ano_nascimento  =   2022-int(idade)


num1    =   int(input('Digite um número'))
num2    =   int(input('Digite outro número'))


print("""O Nome da pessoa é: {} e o mesmo tem {} anos de idade e nasceu no ano de {}.
E a variável usada é do tipo:""".format(nome, idade, ano_nascimento), type(nome))

print(num1+num2)