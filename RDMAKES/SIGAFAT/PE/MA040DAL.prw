#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} MA040DAL
PE executado ap�s a grava��o das altera��es no cadastro de vendedor
@type function
@version 12.1.25
@author ICMAIS
@since 23/09/2020
@return return_type, Nil
/*/
user function MA040DAL()
	
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  
	
	// Manter o trexo de c�digo a seguir no final do fonte
	if lPEICMAIS
		ExecBlock( 'T'+ cFunCall, .F., .F. )
	EndIf

return ( Nil )
