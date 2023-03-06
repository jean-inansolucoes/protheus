#include 'protheus.ch'

user function MA410LEG()

Local aLeg := PARAMIXB

// Adiciona legenda para pedidos em simulacao de carga
aAdd( aLeg, { 'CARGA','Pedido em Simulacao de Carga' } )
aAdd(aLeg,{'BR_PRETO' ,"Pedido Bloqueado por Regras de Descontos"})
aAdd(aLeg,{'BR_PINK' ,"Pedido Bloqueado por Validade/Gerencial"})
aAdd(aLeg,{'WHITE' ,"Pedido Rejeitado pelo Crédito"})

Return aLeg
