#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FT050TOK
O ponto de entrada FT050TOK ser� executado na confirma��o da inclus�o / altera��o
de uma meta de venda e ser� utilizado para que o usu�rio possa efetuar estas valida��es antes de finalizar estas a��es.
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
			alert("Voc� atualizou o Custo, Utilize a op��o Fechar sem salvar os dados!")
			aRet  := .F.
		EndIf
	endif
return ( aRet )
