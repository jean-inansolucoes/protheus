#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} ACC00010
//Rotina de cadastro conex�es.
@author Fernando Oliveira Feres
@since 20/10/2020
@version 1.0
@return nil, nil
/*/
user function ACC00010()
	local oBrowse

	oBrowse := FWMBrowse():New()
	dbSelectArea("ZKX")
	oBrowse:SetAlias('ZKX')
	oBrowse:SetDescription('Cadastro de Conex�es')
	oBrowse:setMenuDef('ACC00011')
	oBrowse:ForceQuitButton()

	
return oBrowse
