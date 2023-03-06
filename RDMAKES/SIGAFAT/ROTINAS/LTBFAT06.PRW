#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTBFAT06
	==============================================================================
	@description
	Amarração Cliente vs Restrição de Veículos
    -- Amarra os clientes com as espécies de veículos cujo o qual não recebe,
    posteriormente isso é validado na montagem da carga no OMS

	@author Djonata Guizzo <djonata.guizzo@totvs.com.br>
	@version 1.0
	@since 03/06/2020

/*/
//============================================================================\
User Function LTBFAT06(  )
	FWExecView('Amarração Cliente vs Restrição de Veículos','LTBFAT06', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
Return ( Nil )
// FIM da Funcao LTBFAT06
//==============================================================================



//============================================================================\
/*/{Protheus.doc}ModelDef
	==============================================================================
	@description
	Definição do modelo para MVC

	@author Djonata Guizzo <djonata.guizzo@totvs.com.br>
	@version 1.0
	@since 03/06/2020

/*/
//============================================================================\
Static Function ModelDef(  )

	Local oModel
	Local oStr1 := FWFormStruct(1,'SA1')
	Local oStr3 := FWFormStruct(1,'ZAN')
    Local bPre  := {|oModel| L006PRE(oModel) }
    Local bPost := {|oModel| L006TOK(oModel) }
    Local bGrv  := {|oModel| L006GRV(oModel) }
	// Criação do modelo e submodelos de dados
	oModel := MPFormModel():New('mLTBFAT06', bPre, bPost, /* bGrv */, /*bCancel*/)
	oModel:AddFields('MASTER',,oStr1)
	oModel:AddGrid( 'ZANDETAIL', 'MASTER', oStr3,{|oModel,nLin,cOpc|L006DELOK(oModel,nLin,cOpc)} /*bLinePre*/,{|oModel,nLin|L006LOK(oModel,nLin)} /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'ZANDETAIL', { { 'ZAN_FILIAL', 'xFilial("ZAN")' } , { 'ZAN_CLI', 'A1_COD' } , { 'ZAN_LOJA', 'A1_LOJA' } } , ZAN->( IndexKey(1) ) )

	// Liga o controle de nao repeticao de linha
	oModel:SetPrimaryKey({"A1_FILIAL","A1_COD","A1_LOJA"})
	oModel:GetModel('ZANDETAIL'):SetUniqueLine( { 'ZAN_ESP' } )

	// Desabilita a validação de incluir pelo menos um registro nas tabelas filhas
	oModel:GetModel('MASTER'):SetOnlyQuery(.T.)
	oModel:GetModel( 'MASTER' ):SetOptional( .T. )
	oModel:GetModel( 'ZANDETAIL' ):SetOptional( .T. )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:SetDescription('Amarração Cliente vs Restrição de Veículos')
	oModel:GetModel('MASTER'   ):SetDescription('Cliente')
	oModel:GetModel('ZANDETAIL'):SetDescription('Veículos restritos no cliente')
    
	oStr1:SetProperty('A1_NOME',MODEL_FIELD_NOUPD,.T.)

Return ( oModel )
// FIM da Funcao ModelDef
//==============================================================================




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ViewDef   ºAutor  ³FSW TOTVS CASCAVEL   º Data ³ 26/10/2017 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³Definição da View p/ MVC                                    º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ViewDef()

Local oView
Local oModel := ModelDef()
Local oStr1  := FWFormStruct(2, 'SA1', {|x| AllTrim(x) $ '|A1_COD|A1_LOJA|A1_NOME|' })
Local oStr3  := FWFormStruct(2, 'ZAN')
//Local oStrTot:= FWCalcStruct(oModel:GetModel('TOTAIS'))

// Configurações das estruturas
oStr3:RemoveField( 'ZAN_CLI' )
oStr3:RemoveField( 'ZAN_LOJA' )

// Ligação dos modelos na View
oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField('VIEW_SA1', oStr1, 'MASTER')
oView:AddGrid('VIEW_ZAN', oStr3, 'ZANDETAIL')

// Elementos visuais
oView:CreateVerticalBox ( 'TELA'    , 100,        )
oView:CreateHorizontalBox( 'SUPERIOR',  30, 'TELA' )
oView:CreateHorizontalBox( 'INFERIOR',  70, 'TELA' )

//-- Cria a pasta e planilhas da Manutencao de Contratos
//oView:CreateFolder('FOLDER','INFERIOR')

//oView:AddSheet('FOLDER','GRDDESP',"Participantes")

//oView:CreateHorizontalBox('DESPESA',100,/*owner*/,/*lUsePixel*/,'FOLDER','GRDDESP') 

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_SA1', 'SUPERIOR' )
//oView:SetOwnerView( 'VIEW_ZAN', 'DESPESA' )
oView:SetOwnerView( 'VIEW_ZAN', 'INFERIOR' )
//oView:SetOwnerView( 'VIEW_TOT', 'TOTTAR' )
oView:EnableTitleView('VIEW_ZAN')

Return oView



Static Function L006LOK(oGridModel,nLin)
	Local _lRet  	:= .T.
	Local oModelZAN		:= oGridModel:GetModel("ZANDETAIL")
    Local _cMsgErro		:= ''
    Local _cMsgSol		:= ''
   

	/* If oGridModel:IsUpdated(nLin) 
		_lRet := .F.
		_cMsgErro := 'Atenção! O preenchimento do campo Mot. Bloqueio é obrigatório quando um Participante for bloqueado.'
		_cMsgSol  := 'Preencha o motivo do bloqueio.'
		//alert(_cMsgErro)
		oModelZAN:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
	EndIf  */
Return _lRet

Static Function L006DELOK(oGridModel,nLin,cOpc)
	Local _lRet  	:= .T.
	Local oModelZAN		:= oGridModel:GetModel("ZANDETAIL")
    Local _cMsgErro		:= ''
    Local _cMsgSol		:= ''
    
	/* If cOpc == 'DELETE' .AND. oGridModel:GetDataId() > 0
		_lRet := .F.
		_cMsgErro := 'Atenção! Não é permitido excluir participantes.'
		_cMsgSol  := 'Deve-se utilizar o bloqueio do mesmo, preenchendo os campos Data de Bloqueio e Motivo do Bloqueio.'
		//alert(_cMsgErro)
		oModelZAN:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
	EndIf  */
Return _lRet

//============================================================================\
/*/{Protheus.doc}L006PRE
  ==============================================================================
    @description
    Validação antes de gravar o Amarração Cliente vs Restrição de Veículos

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 03/06/2020

/*/
//============================================================================\
Static Function L006PRE( oModel )
    Local _lRet  	    := .T.
	Local oModelSA1		:= oModel:GetModel("MASTER")
	Local oModelZAN		:= oModel:GetModel("ZANDETAIL")
    
Return ( _lRet )
// FIM da Funcao L006PRE
//==============================================================================


//============================================================================\
/*/{Protheus.doc}L006TOK
  ==============================================================================
    @description
    Validação após a confirmação 

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 03/06/2020

/*/
//============================================================================\
Static Function L006TOK( oModel )
    Local _lRet  	    := .T.
	Local oModelSA1		:= oModel:GetModel("MASTER")
	Local oModelZAN		:= oModel:GetModel("ZANDETAIL")
    

Return ( _lRet )
// FIM da Funcao L006TOK
//==============================================================================

//============================================================================\
/*/{Protheus.doc}L006GRV
  ==============================================================================
    @description
    Após as validações, usado para preenchimento de campos ocultos 

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 03/06/2020

/*/
//============================================================================\
Static Function L006GRV( oModel )
    Local _lRet  	    := .T.
	Local oModelSA1		:= oModel:GetModel("MASTER")
	Local oModelZAN		:= oModel:GetModel("ZANDETAIL")
    Local nI            := 0
    Local _cCodigo      := ''

    Begin Transaction 

    For nI := 1 To oModelZAN:Length()
        oModelZAN:SetLine(nI)
        If Empty(oModelZAN:GetValue("ZAN_NOME",nI))
            oModelZAN:DeleteLine()
        ElseIf Empty(oModelZAN:GetValue("ZAN_CODIGO",nI))
            If Empty(_cCodigo)
                _cCodigo := L006COD()
            EndIF

            _cCodigo := Soma1(_cCodigo)

            oModelZAN:SetValue("ZAN_CODIGO",_cCodigo)
        EndIf
    Next nI

    If !FWFormCommit(oModel)
		lRet:= .F.
		DisarmTransaction()
	EndIf

    End Transaction

Return ( _lRet )
// FIM da Funcao L006TOK
//==============================================================================







