#INCLUDE 'PROTHEUS.CH'
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTBFAT01
  ==============================================================================
    @description
    Cadastro de Canais de Vendas

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 27/08/2020

/*/
//============================================================================\
User Function LTBFAT01(  )
    Local oBrowse    := Nil
	Private aRotina := Menudef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZAG")
	oBrowse:SetDescription('Cadastro de Canais de Vendas')
	oBrowse:Activate()

Return ( Nil )
// FIM da Funcao LTBFAT01
//==============================================================================

Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.LTBFAT01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.LTBFAT01' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.LTBFAT01' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.LTBFAT01' OPERATION 5 ACCESS 0
	If RetCodUsr() $ GetMv("MX_DEFALC")
		ADD OPTION aRotina TITLE 'Regras de Alçadas'    ACTION 'U_LTBFAT02'      OPERATION 4 ACCESS 0
	EndIf

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
	
	
	Local oStr1:= FWFormStruct(2, 'ZAG')
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
	
	
	Local oStr1:= FWFormStruct(1,'ZAG')
	oModel := MPFormModel():New('ZAGMASTER',,{|oModel| R001TOK(oModel)})
	oModel:SetDescription('Canais de Vendas')
	oModel:addFields('FIELD1',,oStr1)
	oModel:SetPrimaryKey({ 'ZAG_FILIAL', 'ZAG_CODIGO' })
	
	
	oModel:getModel('FIELD1'):SetDescription('Canais de Vendas')
	
	
	
Return oModel

Static Function R001TOK(oModel)
	Local _lRet := .T.
	
Return _lRet


