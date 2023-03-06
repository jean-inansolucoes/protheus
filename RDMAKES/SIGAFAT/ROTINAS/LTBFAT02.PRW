#INCLUDE 'PROTHEUS.CH'
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTBFAT02
  ==============================================================================
    @description
    Regras de Alçadas por Canal de Venda

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 27/08/2020

/*/
//============================================================================\
User Function LTBFAT02(  )
    

Return FWExecView('Cadastro de Regras de Alçadas','LTBFAT02', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
// FIM da Funcao LTBFAT02
//==============================================================================


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author admin

@since 22/04/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct(1,'ZAG')
	Local oStr2:= FWFormStruct(1,'ZAH')
	Local oStr3:= FWFormStruct(1,'ZAJ')


	oModel := MPFormModel():New('mLTBFAT02')


	oModel:SetDescription('Alçadas de Descontos por Canal de Venda')
	
	//oStr2:SetProperty('ZRK_COD',MODEL_FIELD_OBRIGAT,.F.)
	//oStr1:RemoveField( 'ZRK_DDE' )


    oModel:addFields('MASTER',,oStr1) 
	oModel:SetPrimaryKey({ 'ZAG_FILIAL', 'ZAG_CODIGO' })

	oModel:addGrid('ZAJDETAIL','MASTER',oStr3)
	oModel:getModel('ZAJDETAIL'):SetDescription('Grupos de Produtos')
	oModel:GetModel('ZAJDETAIL'):SetUniqueLine( { 'ZAJ_FILIAL', 'ZAJ_GRUPO' } )
	oModel:SetRelation('ZAJDETAIL', { { 'ZAJ_FILIAL', "FwXFilial('ZAJ')" },{ 'ZAJ_CANAL', "ZAG_CODIGO" } }, ZAJ->(IndexKey(1)) )
	
	oModel:addGrid('ZAHDETAIL','ZAJDETAIL',oStr2)
	oModel:getModel('ZAHDETAIL'):SetDescription('Faixa de Descontos')
	oModel:GetModel('ZAHDETAIL'):SetUniqueLine( { 'ZAH_FILIAL','ZAH_GRUPO', 'ZAH_APROV' } )
	oModel:SetRelation('ZAHDETAIL', { { 'ZAH_FILIAL', "FwXFilial('ZAH')" },{ 'ZAH_CANAL', "ZAG_CODIGO" },{ 'ZAH_GRUPO', "ZAJ_GRUPO" } }, ZAH->(IndexKey(2)) )
	
	oModel:GetModel('MASTER'):SetOnlyQuery(.T.)
    //oModel:getModel('MASTER'):SetOptional(.T.)

	
	


Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author admin

@since 22/04/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZAG')
	Local oStr2:= FWFormStruct(2, 'ZAH')
	Local oStr3:= FWFormStruct(2, 'ZAJ')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'MASTER' )
	oView:AddGrid('FORM2' , oStr3,'ZAJDETAIL')  
	oView:AddGrid('FORM3' , oStr2,'ZAHDETAIL')  
	

    oView:CreateHorizontalBox( 'BOXFORM1', 10)
    oStr1:SetProperty('ZAG_CODIGO',MVC_VIEW_CANCHANGE,.F.)
    oStr1:SetProperty('ZAG_DESCR',MVC_VIEW_CANCHANGE,.F.)
    oStr1:SetProperty('ZAG_COMIS',MVC_VIEW_CANCHANGE,.F.)
	oStr2:RemoveField( 'ZAH_CANAL' )
	oStr2:RemoveField( 'ZAH_GRUPO' )
	oStr3:RemoveField( 'ZAJ_CANAL' )

	oView:CreateHorizontalBox( 'BOXFORM3', 90)
	oView:CreateVerticalBox("LEFTBOX",30,'BOXFORM3')
	oView:CreateVerticalBox("RIGTHBOX",70,'BOXFORM3')
	
	oView:SetOwnerView('FORM3','RIGTHBOX')
	oView:SetOwnerView('FORM2','LEFTBOX')
	oView:SetOwnerView('FORM1','BOXFORM1')
    oView:AddIncrementField('FORM3', 'ZAH_ITEM')
	oView:EnableTitleView('FORM3' , 'Regras de Alçadas' ) 
	oView:EnableTitleView('FORM2' , 'Grupos de Produtos' ) 

Return oView

