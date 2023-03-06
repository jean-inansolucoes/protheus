#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} ACC00003
//Rotina de cadastro DE / PARA atributos x campos Protheus.
@author Fernando Oliveira Feres
@since 20/10/2020
@version 1.0
@return nil, nil
/*/
user function ACC00003()
	local oBrowse

	oBrowse := FWMBrowse():New()
	dbSelectArea("ZKT")
	oBrowse:SetAlias('ZKT')
	oBrowse:SetDescription('Cadastro de De / para')
	oBrowse:setMenuDef('ACC00002')
	oBrowse:ForceQuitButton()

	
return oBrowse
