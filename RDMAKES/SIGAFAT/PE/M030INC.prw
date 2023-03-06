#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M030INC
PE executado ap�s inclus�o de um cliente quando a rotina n�o utiliza modelo MVC
@type function
@version 12.1.25
@author ICMAIS
@since 26/09/2019
@return return_type, Nil
/*/
user function M030INC()
	
	Local aParam    := PARAMIXB
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  

	// Manter o trexo de c�digo a seguir no final do fonte
	if lPEICMAIS
		ExecBlock( 'T'+ cFunCall, .F., .F., aParam )
	EndIf
	
return ( Nil )
