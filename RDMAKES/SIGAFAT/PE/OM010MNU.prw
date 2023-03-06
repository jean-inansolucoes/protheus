#include 'topconn.ch'
#include 'protheus.ch'

/*/{Protheus.doc} OM010MNU
PE para adicionar novos bot�es � rotina de tabela de pre�os
@type function
@version 12.1.25
@author ICMAIS
@since 21/09/2020
@return array, aBotoes
/*/
user function OM010MNU()
    
    local aArea     := GetArea()
    local cFunCall  := SubStr(ProcName(0),3)
	local lPEICMAIS := ExistBlock( 'T'+ cFunCall )

    if lPEICMAIS
		ExecBlock( 'T'+ cFunCall, .F., .F., Nil )
	EndIf

    aadd(aRotina,{'Reaj. Autom�tico.','U_LTBFAT08' , 0 , 3,0,NIL})

    restArea( aArea )
return ( Nil )


