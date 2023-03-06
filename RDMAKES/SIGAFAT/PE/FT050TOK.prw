#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FT050TOK
O ponto de entrada FT050TOK será executado na confirmação da inclusão / alteração
de uma meta de venda e será utilizado para que o usuário possa efetuar estas validações antes de finalizar estas ações.
@type function
@version 12.1.27
@author Alexandre Longhinotti
@since 04/03/2022
@return array, aNewBtn
/*/
user function FT050TOK()
	local aRet      := .T.
	if TYPE("nCt_Trelac") != "U"
		If nCt_Trelac
			alert("Você atualizou o Custo, Utilize a opção Fechar sem salvar os dados!")
			aRet  := .F.
		EndIf
	endif
return ( aRet )
