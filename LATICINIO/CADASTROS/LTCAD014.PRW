#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTCAD014
  ==============================================================================
    @description
    Cadastro de Análises de Qualidade

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 03/02/2021

/*/
//============================================================================\
User Function LTCAD014(  )
    Local oBrowse    := Nil
	Private aRotina := Menudef()
	
    oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZA3")
	oBrowse:SetDescription('Análises de Qualidade')

	oBrowse:Activate()
Return ( Nil )
// FIM da Funcao LTCAD014
//==============================================================================




Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.LTCAD014'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'          ACTION 'VIEWDEF.LTCAD014'   OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'          ACTION 'VIEWDEF.LTCAD014'   OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'          ACTION 'VIEWDEF.LTCAD014'   OPERATION 5 ACCESS 0
	
Return aRotina


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
	Local oStr1     := FWFormStruct(1,'ZA3')
	Local oStr2     := FWFormStruct(1,'ZA4')
	
	oModel := MPFormModel():New('mLTCAD014',,,)
	oModel:SetDescription('Cadastro de Análises de Qualidade')
	

    oModel:addFields('MASTER',,oStr1) 
	oModel:SetPrimaryKey({ 'ZA3_FILIAL', 'ZA3_COD' })

	oModel:addGrid('ZA4DETAIL','MASTER',oStr2)
	oModel:getModel('ZA4DETAIL'):SetDescription('Análises')
	oModel:GetModel('ZA4DETAIL'):SetUniqueLine( { 'ZA4_FILIAL','ZA4_CARACT','ZA4_COD' } )
	oModel:SetRelation('ZA4DETAIL', { { 'ZA4_FILIAL', "FwXFilial('ZA4')" },{ 'ZA4_CARACT', "ZA3_COD" } }, ZA4->(IndexKey(1)) )
	
    oModel:SetVldActivate({|oModel|PreValidacaoModelo(oModel)})

    oStr1:SetProperty("ZA3_TIPO",MODEL_FIELD_VALID,{|x,y,z| ValidaTipo(x,y,z)})
    
    oModel:GetModel('ZA4DETAIL'):SetOnlyQuery(.T.)
    oModel:getModel('ZA4DETAIL'):SetOptional(.T.)

	
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
	Local oStr1:= FWFormStruct(2, 'ZA3')
	Local oStr2:= FWFormStruct(2, 'ZA4')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'MASTER' )
	oView:AddGrid('FORM2' , oStr2,'ZA4DETAIL')  
	
	

    oView:CreateHorizontalBox( 'BOXSUPERIOR', 50)
    oView:CreateHorizontalBox( 'BOXINFERIOR', 50)
	
	oView:SetOwnerView('FORM2','BOXINFERIOR')
	oView:SetOwnerView('FORM1','BOXSUPERIOR')
	oView:EnableTitleView('FORM2' , 'Análises Tipo Texto' ) 

    oStr2:RemoveField( 'ZA4_CARACT' )
    
    // Realiza carga inicial dos dados em caso de renegociação
    oView:SetAfterViewActivate({|oView| LoadAnalises(oView) })
Return oView

// Validação inicial do modelo, indica se permite ou não executar a operação selecionada no menu
Static Function PreValidacaoModelo(oModel)
	Local _lRet  	    := .T.
	Local lInclui		:= oModel:GetOperation() == MODEL_OPERATION_INSERT
	Local lAltera		:= oModel:GetOperation() == MODEL_OPERATION_UPDATE
	Local lExclui		:= oModel:GetOperation() == MODEL_OPERATION_DELETE
	Local oModelZA3		:= oModel:GetModel("MASTER")
	Local oModelZA4		:= oModel:GetModel("ZA4DETAIL")
    Local _cMsgErro     := ''
    Local _cMsgSol      := ''
    
    /* If lExclui 
        _cMsgErro   := 'Atenção! Não é permitido excluir!'
        _cMsgSol    := ''
        _lRet       := .F.
    EndIf */


    If !_lRet .And. ! Empty(_cMsgErro)
		oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
	EndIf

Return _lRet


// Validação do campo Tipo
// Utilizo para bloquear ou obrigar o preenchimento do grid de Tipos
Static Function ValidaTipo(oModelZA3,cField,xValue)
    Local _lRet     := .T.
    Local oModel    := FWModelActive()
    Local _nI       := 0


    // Se for tipo Texto, ativa o grid
    If xValue == 'T'
        oModel:GetModel('ZA4DETAIL'):SetOnlyQuery(.F.)
        oModel:GetModel('ZA4DETAIL'):CanInsertLine(.T.)
        oModel:GetModel('ZA4DETAIL'):CanUpdateLine(.T.)
        oModel:GetModel('ZA4DETAIL'):CanDeleteLine(.T.)

    // Se for tipo numérico, desativa o grid
    Else
        For _nI := 1 To oModel:GetModel('ZA4DETAIL'):Length()
            oModel:GetModel('ZA4DETAIL'):SetLine(_nI)
            If !oModel:GetModel('ZA4DETAIL'):IsDeleted()
                oModel:GetModel('ZA4DETAIL'):DeleteLine()
            EndIf
        Next 

        oModel:GetModel('ZA4DETAIL'):CanInsertLine(.F.)
        oModel:GetModel('ZA4DETAIL'):CanUpdateLine(.F.)
        oModel:GetModel('ZA4DETAIL'):CanDeleteLine(.F.)
    EndIf

Return _lRet

// Carga inicial do modelo
Static Function LoadAnalises( oView )

	Local oModelZA3	:= oView:GetModel("MASTER")
	Local oModelZA4	:= oView:GetModel("ZA4DETAIL")
	
	
	If oView:GetModel():GetOperation() == MODEL_OPERATION_INSERT 
        oModelZA3:LoadValue("ZA3_COD"    , GetSxeNum('ZA3','ZA3_COD'))
        ConfirmSX8()

        oView:Refresh()
    EndIf

Return ( .T. )
