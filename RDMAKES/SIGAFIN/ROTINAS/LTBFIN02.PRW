#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'FWMVCDef.ch'
#include "dbinfo.ch"

#DEFINE CAMPOS_GRID_SA2	'|A2_COD|A2_LOJA|A2_NOME|'
#DEFINE CAMPOS_GRID_NFS	'|D1_DOC|D1_SERIE|D1_EMISSAO|D1_X_DESCP|D1_QUANT|D1_VUNIT|D1_TOTAL|'


//============================================================================\
/*/{Protheus.doc}LTBFIN02
  ==============================================================================
    @description
    Apresenta dados do fornecedor e NFs dos últimos 12 meses

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 06/10/2020

/*/
//============================================================================\
User Function LTBFIN02(  )
    Private _dDtNfs := dToS(FirstDay(dDataBase - 365))

Return FWExecView('Nfs do Produtor','LTBFIN02', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
// FIM da Funcao LTBFIN02
//==============================================================================

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author guizz

@since 17/11/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'SA2', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_GRID_SA2+ '|A2_FILIAL|'})
	Local oStr2:= FWFormStruct(1,'SD1', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_GRID_NFS+ '|D1_FILIAL|D1_FORNECE|D1_LOJA|D1_ITEM|' })
	

    oStr2:AddField( "Emissão", "Emissão", "D1_X_EMIS", "D", TamSX3('F1_EMISSAO')[1], TamSX3('F1_EMISSAO')[2],,,, .F. )
	oStr2:SetProperty('D1_X_EMIS',MODEL_FIELD_INIT,{||SD1->D1_EMISSAO})
    
    oStr2:AddField( "Méd.Entr.Dia", "Média Entrega Diária", "D1_X_ENTR", "N", TamSX3('D1_QUANT')[1], TamSX3('D1_QUANT')[2],,,, .F. )
	oStr2:SetProperty('D1_X_ENTR',MODEL_FIELD_INIT,{||SD1->D1_QUANT / Day(SD1->D1_EMISSAO)})

	// Definição dos modelos
	oModel := MPFormModel():New('mLTBFIN02')
	oModel:addFields('MASTER',,oStr1)
	oModel:addGrid('DETAIL_NFS','MASTER',oStr2)
	
	// Características e relacionamento dos modelos
	oModel:SetPrimaryKey({ 'A2_COD', 'A2_LOJA' })
	oModel:GetModel('DETAIL_NFS'):SetUniqueLine( { 'D1_DOC', 'D1_ITEM' } )

	oModel:SetRelation('DETAIL_NFS', { { 'D1_FILIAL', 'XFILIAL("SD1")' }, { 'D1_FORNECE', 'A2_COD' } }, 'D1_FILIAL+DTOS(D1_EMISSAO)' )
	
	oModel:SetDescription('Agendamento de Recursos')
	oModel:GetModel('MASTER'):SetDescription('Detalhes do Fornecedor')
	oModel:GetModel('DETAIL_NFS'):SetDescription('Notas Fiscais')
    oModel:GetModel('MASTER'):SetOnlyView()
    oModel:GetModel('DETAIL_NFS'):SetOnlyView()
    oModel:GetModel('MASTER'):SetOnlyQuery(.T.)
    oModel:GetModel('DETAIL_NFS'):SetOnlyQuery(.T.)

	oModel:GetModel( 'DETAIL_NFS' ):SetLoadFilter( , "  D1_EMISSAO >= '"+_dDtNfs+"' " )


Return oModel
// FIM da Funcao ModelDef
//-------------------------------------------------------------------


Static Function ViewDef()

	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'SA2', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_GRID_SA2 })
	Local oStr2:= FWFormStruct(2, 'SD1', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_GRID_NFS })

    oStr2:AddField( "D1_X_EMIS"	, '02', "Emissão", "Emissão", /*Help*/, "G", , /*PictVar*/, /*F3*/, .F. /*lCanChange*/ )
    oStr2:AddField( "D1_X_ENTR"	, '06', "Méd.Entr.Dia", "Média Entrega Diária", /*Help*/, "G", , {||"@E 999,999.99"}, /*F3*/, .F. /*lCanChange*/ )

	// Definição dos modelos da View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FIELD_MASTER' , oStr1,'MASTER' )
	oView:AddGrid('GRID_NFS' , oStr2,'DETAIL_NFS')

	oView:EnableTitleView('GRID_NFS' , 'Detalhamento das Notas Fiscais' )

	// Definição dos Objetos visuais
	oView:CreateHorizontalBox( 'BOX_SUPERIOR', 20)
	oView:CreateHorizontalBox( 'BOX_INFERIOR', 80)

	// Ligação dos modelos com os objetos visuais
	oView:SetOwnerView('FIELD_MASTER','BOX_SUPERIOR')
	oView:SetOwnerView('GRID_NFS','BOX_INFERIOR')

    oStr2:SetProperty('D1_DOC',MVC_VIEW_ORDEM,"01")
	


    oView:SetAfterViewActivate({|oView| LoadNfs(oView) })

Return oView


Static Function LoadNfs( oView )

	Local oModelSA2	:= oView:GetModel("MASTER")
	Local oModelSD1	:= oView:GetModel("DETAIL_NFS")


    oModelSA2:LoadValue('A2_COD'	, SA2->A2_COD )
	oModelSA2:LoadValue('A2_LOJA'   , SA2->A2_LOJA )
	oModelSA2:LoadValue('A2_NOME'	, SA2->A2_NOME )
				
Return
