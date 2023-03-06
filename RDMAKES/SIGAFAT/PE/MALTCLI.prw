#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MALTCLI
PE executado após a gravação das alterações do cliente quando a rotina não utilizar modelo MVC
@type function
@version 12.1.25
@author ICMAIS
@since 26/09/2020
@return return_type, Nil
/*/
user function MALTCLI()
	
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  

	// Manter o trexo de código a seguir no final do fonte
	if lPEICMAIS
		ExecBlock( 'T'+ cFunCall, .F., .F. )
	EndIf
	
return ( Nil )
