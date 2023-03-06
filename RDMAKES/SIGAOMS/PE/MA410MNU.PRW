//============================================================================\
/*/{Protheus.doc}MA410MNU
  ==============================================================================
    @description
    Descrição da função
    PE antes de abertura da inclusão do pedido de venda
    @author Alexandre Longhinotti <ti@tresbarras.ind.br>
    @version 1.0
    @since 15/10/2020

/*/
//============================================================================\

#Include "protheus.ch"
User Function MA410MNU()

aadd(aRotina,{'Estorna Lib','U_TBEstLib' , 0 , 3,0,NIL}) 
aadd(aRotina,{'Rastreia PV','U_TBBUSCAPV' , 0 , 3,0,NIL})
aadd(aRotina,{'Alt DT Entrega','U_NEWDTENT' , 0 , 3,0,NIL})
Return 
