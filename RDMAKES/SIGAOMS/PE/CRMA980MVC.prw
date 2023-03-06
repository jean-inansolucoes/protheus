#include 'totvs.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CRMA980
PE MVC do cadastro de clientes
@type function
@version 1.0
@author ICmais
@since 2/8/2022
@return variadic, xRet
/*/
user function CRMA980()
    
    local aArea     := getArea()
    Local aParam    := PARAMIXB
	Local xRet      := .T.
	Local cFunCall  := SubStr(ProcName(0),3)
	Local lPEICMAIS := ExistBlock( 'T' + cFunCall )
	
	// Verifica se conseguiu receber valor do PARAMIXB
	If aParam <> NIL

		// Manter o trexo de código a seguir no final do fonte
		if lPEICMAIS
			ExecBlock( 'T'+ cFunCall, .F., .F., aParam )
		EndIf
		
	EndIf

    restArea( aArea )
return xRet
