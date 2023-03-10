//============================================================================\
/*/{Protheus.doc}MT410ACE 
  ==============================================================================
    @description
    Descri??o da fun??o
    PE antes de abertura da inclus?o do pedido de venda
    @author Alexandre Longhinotti <ti@tresbarras.ind.br>
    @version 1.0
    @since 15/10/2020

/*/
//============================================================================\

#Include "protheus.ch"
#include 'rwmake.ch'
User Function MT410ACE()
Local lContinua := .T.
Local nOpc  := PARAMIXB [1]

If ( nOpc == 4 .AND. !Empty(SC5->C5_NOTA) ) .OR. nOpc == 3
    lContinua := .F.
    If nOpc == 3
      U_LTALL001("ATEN??O", "A op??o de c?pia de Pedidos est? desabilitada.","Favor fazer a inclus?o de um novo pedido.")
    Else
      U_LTALL001("ATEN??O", "Imposs?vel executar o procedimento.","J? foi emitido nota fiscal para este pedido.")
    EndIf
EndIf

Return lContinua
