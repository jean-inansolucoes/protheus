#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} ACC00012
//Rotina de cadastro Etiquetas.
@author Fernando Oliveira Feres
@since 20/10/2020
@version 1.0
@return nil, nil
/*/
user function ACC00012()
	local oBrowse

	oBrowse := FWMBrowse():New()
	dbSelectArea("ZKW")
	oBrowse:SetAlias('ZKW')
	oBrowse:SetDescription('Cadastro de Etiquetas')
	oBrowse:setMenuDef('ACC00013')
	oBrowse:ForceQuitButton()

	
return oBrowse
