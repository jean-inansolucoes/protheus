#include 'protheus.ch'
#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} MATA035
PE modelo MVC para rotina de Grupos de Produtos
@type function
@version 12.1.25
@author ICMAIS
@since 19/09/2020
@return variadic, xRet
/*/
user function MATA035()
	
	Local aParam    := PARAMIXB
	Local xRet      := .T.
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  
	
	// Verifica se conseguiu receber valor do PARAMIXB
	If aParam <> NIL

		// Manter o trexo de código a seguir no final do fonte
		if lPEICMAIS
			xRet := ExecBlock( 'T'+ cFunCall, .F., .F., aParam )
		EndIf
		
	EndIf
	
return ( xRet )
