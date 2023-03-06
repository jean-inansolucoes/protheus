#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
#include 'totvs.ch'

/*/{Protheus.doc} QIEA030
PE modelo MVC para manutenção dos cadastros de Unidades de Medidas
@type function
@version 12.1.25
@author ICMAIS
@since 22/09/2019
@return variadic, xRet
/*/
user function QIEA030()
	
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
