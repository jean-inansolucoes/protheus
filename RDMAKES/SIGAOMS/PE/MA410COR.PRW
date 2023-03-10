#Include "protheus.ch"
User Function MA410COR()
Local aCoresPE := {}
//local aCred := Posicione('SC9',1,xFilial('SC9')+SC5->C5_NUM,'SC9->C9_BLCRED')
// ? importante destacar que, ao utilizar este ponto de entrada, voc? ser? o respons?vel por priorizar a valida??o para cada caracter?stica da legenda, de forma a existir apenas 01 condi??o verdadeira.
// Caso contr?rio, sua customiza??o pode n?o ter o resultado esperado.
// Adi??o cor de legenda para pedidos bbloqueados por cr?dito
aAdd( aCoresPE, { '! Empty( C5_X_SIMUL ) .and. Empty( C5_NOTA )' /* bCondition */,'CARGA','Pedido em Simulacao de Carga' } )
aAdd(aCoresPE, {"C5_BLQ == '9'", "BR_PRETO", "Pedido Bloqueado por Regras de Descontos"})
aAdd(aCoresPE, {"C5_BLQ == '8'", "BR_PINK", "Pedido Bloqueado por Validade/Gerencial"})
aAdd(aCoresPE, {"C5_BLQ == '7'", "WHITE", "Pedido Rejeitado pelo Cr?dito"})
aAdd(aCoresPE, {"C5_BLQ == 'R'", "BPMSTASK2", "Pedido Rejeitado pela Ger?ncia - (Aberto)"})

//aAdd(aCoresPE, {"C5_BLQ == 'E'", "BPMSTASK1", "Pedido Rejeitado pela Ger?ncia - (Encerrado)"})
if Type( 'ParamIXB' ) == 'A'
    aEval( PARAMIXB, {|x| aAdd( aCoresPE, x ) } )
endif
/* aIns(aCoresPE, 1)
aCoresPE[01] := {"C5_BLQ == '9'", "BR_PRETO", "Pedido Bloqueado por Regras de Descontos"} */
Return aCoresPE
