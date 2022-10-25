def diga_horas():

    hora = input('Digite a Hora: ')
    try:
        hora1 = int(hora)
        if hora1 > 0 and hora1 < 11:
            print('Bom Dia')
        elif hora1 > 12 and hora1 < 17:
            print('Boa Tarde')
        elif hora1 > 18 and hora1 < 23:
            print('Boa Noite')
    except:
        print('Não tenho uma saudação para ti, digite a hora certa')
        return diga_horas()


diga_horas()
