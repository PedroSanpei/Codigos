"""
CONSTANTE = "Variáveis" que não vão mudar
Muitas condições no mesmo if (ruim)
    <- Contagem de complexidade (ruim)
"""
velocidade = 60  # velocidade atual do carro
local_carro = 100  # local em que o carro está na estrada

RADAR_1 = 60  # velocidade máxima do radar 1
LOCAL_1 = 100  # local onde o radar 1 está
RADAR_RANGE = 1  # A distância onde o radar pega

# SEPARO A LÓGICA DO IF EM VARIÁVEIS PARA MANTER UM CÓDIGO LIMPO
vel_carro_pass_radar_1 = velocidade > RADAR_1

carro_passou_radar_1_ant = local_carro >= (LOCAL_1 - RADAR_RANGE)

carro_passou_radar_1_dp =  local_carro <= (LOCAL_1 + RADAR_RANGE)

carro_passou_radar_1 = carro_passou_radar_1_ant and carro_passou_radar_1_dp

carro_multado_radar_1 = carro_passou_radar_1_dp and vel_carro_pass_radar_1

if vel_carro_pass_radar_1:
    print('Velocidade carro passou do radar 1')

if carro_passou_radar_1_dp:
    print('Carro passou radar 1')
    
if carro_multado_radar_1:
    print('Carro multador em radar1')