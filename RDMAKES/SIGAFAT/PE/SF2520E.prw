#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} SF2520E
PE executado após exclusão de um documento de saída
@type function
@version 12.1.25
@author ICMAIS
@since 24/07/2020
@return variadic, xRet
/*/
user function SF2520E()

    local aArea := GetArea()
	Local xRet      := Nil
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  
	
	// Manter o trexo de código a seguir no final do fonte
	if lPEICMAIS
		xRet := ExecBlock( 'T'+ cFunCall, .F., .F., )
	EndIf
	
    restArea( aArea )
return xRet
