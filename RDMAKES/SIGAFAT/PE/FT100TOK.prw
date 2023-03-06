#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FT100TOK
PE executado durante a gravação das regras de negócio
@type function
@version 12.1.25
@author ICMAIS
@since 02/10/2019
@return logical, lTudoOk
/*/
user function FT100TOK()
	
	Local aParam    := PARAMIXB
	Local lRet      := .T.
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  
	
	// Manter o trexo de código a seguir no final do fonte
	if aParam <> Nil
		if lPEICMAIS
			lRet := ExecBlock( 'T'+ cFunCall, .F., .F., aParam )
		EndIf
	EndIf
return ( lRet )
