#Include "protheus.ch"
User Function MA410COR()
Local aCoresPE := {}
//local aCred := Posicione('SC9',1,xFilial('SC9')+SC5->C5_NUM,'SC9->C9_BLCRED')
// É importante destacar que, ao utilizar este ponto de entrada, você será o responsável por priorizar a validação para cada característica da legenda, de forma a existir apenas 01 condição verdadeira.
// Caso contrário, sua customização pode não ter o resultado esperado.
// Adição cor de legenda para pedidos bbloqueados por crédito
aAdd( aCoresPE, { '! Empty( C5_X_SIMUL ) .and. Empty( C5_NOTA )' /* bCondition */,'CARGA','Pedido em Simulacao de Carga' } )
aAdd(aCoresPE, {"C5_BLQ == '9'", "BR_PRETO", "Pedido Bloqueado por Regras de Descontos"})
aAdd(aCoresPE, {"C5_BLQ == '8'", "BR_PINK", "Pedido Bloqueado por Validade/Gerencial"})
aAdd(aCoresPE, {"C5_BLQ == '7'", "WHITE", "Pedido Rejeitado pelo Crédito"})
aAdd(aCoresPE, {"C5_BLQ == 'R'", "BPMSTASK2", "Pedido Rejeitado pela Gerência - (Aberto)"})

//aAdd(aCoresPE, {"C5_BLQ == 'E'", "BPMSTASK1", "Pedido Rejeitado pela Gerência - (Encerrado)"})
if Type( 'ParamIXB' ) == 'A'
    aEval( PARAMIXB, {|x| aAdd( aCoresPE, x ) } )
endif
/* aIns(aCoresPE, 1)
aCoresPE[01] := {"C5_BLQ == '9'", "BR_PRETO", "Pedido Bloqueado por Regras de Descontos"} */
Return aCoresPE
