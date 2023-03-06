#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M030EXC
PE executado após exclusão de um cadastro de cliente
@type function
@version 12.1.25
@author ICMAIS
@since 26/09/2019
@return return_type, Nil
/*/
user function M030EXC()
	
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  
	
	// Manter o trexo de código a seguir no final do fonte
	if lPEICMAIS
		ExecBlock( 'T'+ cFunCall, .F., .F., Nil )
	EndIf
	
return ( Nil )
