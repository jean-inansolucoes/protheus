#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} SPDNFDANF
PE executado ap�s autoriza��o do documento de sa�da na SEFAZ
@type function
@version 12.1.25
@author ICMAIS
@since 04/02/2020
@return variadic, xRet
/*/
user function SPDNFDANF()

    local aArea     := GetArea()
    Local aParam    := PARAMIXB
	Local xRet      := Nil
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T'+ cFunCall )  
	
	// Verifica se conseguiu receber valor do PARAMIXB
	If aParam <> NIL

		// Manter o trexo de c�digo a seguir no final do fonte
		if lPEICMAIS
			xRet := ExecBlock( 'T'+ cFunCall, .F., .F., aParam )
		EndIf
		
	EndIf
    
    // Devolve a area de processamento para retornar do ponto de entrada
    restArea( aArea )
return xRet
