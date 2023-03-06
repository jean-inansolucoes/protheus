#INCLUDE 'PROTHEUS.CH'
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTBFAT04
  ==============================================================================
    @description
    Cadastro de níveis de alçadas vs grupos de usuários

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 27/08/2020

/*/
//============================================================================\
User Function LTBFAT04(  )
    Local oBrowse    := Nil
	Private aRotina := Menudef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZAM")
	oBrowse:SetDescription('Cadastro de Níveis de Alçadas vs Grupos de Usuários')
	oBrowse:Activate()

Return ( Nil )
// FIM da Funcao LTBFAT04
//==============================================================================

Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.LTBFAT04' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.LTBFAT04' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.LTBFAT04' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.LTBFAT04' OPERATION 5 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author guizz

@since 01/11/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	
	
	Local oStr1:= FWFormStruct(2, 'ZAM')
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('FORM4' , oStr1,'FIELD1' )
	oView:CreateHorizontalBox( 'FORMZR4', 100)
	oView:SetOwnerView('FORM4','FORMZR4')
	
Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author guizz

@since 01/11/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	
	
	Local oStr1:= FWFormStruct(1,'ZAM')
	oModel := MPFormModel():New('ZAMMASTER',,{|oModel| R004TOK(oModel)})
	oModel:SetDescription('Níveis de Alçadas vs Grupos de Usuários')
	oModel:addFields('FIELD1',,oStr1)
	oModel:SetPrimaryKey({ 'ZAM_FILIAL', 'ZAM_NIVEL' })
	
	
	oModel:getModel('FIELD1'):SetDescription('Níveis de Alçadas vs Grupos de Usuários')
	
	
	
Return oModel

Static Function R004TOK(oModel)
	Local _lRet := .T.
	
Return _lRet


