#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTMOV012
  ==============================================================================
    @description
    Programa responsável pelo controle de Protocolos das Pesagens

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 05/04/2021

/*/
//============================================================================\
User Function LTMOV012(  )
    Private aRotina := MenuDef()
    Private cCadastro := "Protocolos de Qualidade"
    Private _nRotina   := 0
    oMBrowse := FWMBrowse():New()
    oMBrowse:SetAlias("ZM8")
    oMBrowse:SetDescription(cCadastro)
    
    oMBrowse:AddLegend( "ZM8_STATUS == 'L'"					, "BR_VERDE" 	    , "Pendente Análise Laboratório"  		)
	oMBrowse:AddLegend( "ZM8_STATUS == 'C'"					, "BR_AZUL" 		, "Pendente Análise Captação / Fornecedor"  	)
	oMBrowse:AddLegend( "ZM8_STATUS == 'Q'"                 , "BR_AMARELO" 		, "Pendente Análise Qualidade"	)
	oMBrowse:AddLegend( "ZM8_STATUS == 'F'"					, "BR_PRETO" 		, "Protocolo Finalizado" 	)

    oMBrowse:Activate()



Return ( Nil )
// FIM da Funcao LTMOV012
//==============================================================================


//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Montagem do Menu

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function MenuDef()
	Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.LTMOV012' OPERATION 2 ACCESS 0
	//ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.LTMOV012' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Análise  Captação / Fornec.'     ACTION 'U_LT12A(2)' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Análise Qualidade'    ACTION 'U_LT12A(3)' OPERATION 4 ACCESS 0
	
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.LTMOV012' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Conhecimento'    ACTION "MsDocument('ZM8', ZM8->(RecNo()), 4)" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'    ACTION "U_LTREL046()" OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Reenviar E-Mail'    ACTION "U_LTEVE02B()" OPERATION 6 ACCESS 0
Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct(1,'ZM8')
	Local oStr2:= FWFormStruct(1,'ZM9')
    Local bPost := {|oModel| LT012TOK(oModel) }
    Local bGrv  := {|oModel| LT012GRV(oModel)}

	oModel := MPFormModel():New('mLTMOV012', /*bPreValidacao*/, /*bPosValidacao*/ bPost , /* Gravação dos dados via bloco customizado */ bGrv)


	oModel:SetDescription('Protocolos de Qualidade')
	
    
    oModel:addFields('MASTER',,oStr1) 
	oModel:SetPrimaryKey({ 'ZM8_NUM', 'ZM8_IDPROT' })

	oModel:addGrid('ZM9DETAIL','MASTER',oStr2)
	oModel:getModel('ZM9DETAIL'):SetDescription('Características')
	oModel:GetModel('ZM9DETAIL'):SetUniqueLine( { 'ZM9_FILIAL', 'ZM9_TANQUE', 'ZM9_FORNEC' , 'ZM9_CARACT' } )
	oModel:SetRelation('ZM9DETAIL', { { 'ZM9_FILIAL', "FwXFilial('ZM9')" },{ 'ZM9_NUM', "ZM8_NUM" } }, ZM9->(IndexKey(1)) )
	
    // Remove a obrigatoriedade dos campos na inclusão via execauto chamada na rotina LTEVE001
    If IsInCallStack("U_LTMOV9D") .OR. IsInCallStack("U_LTMOV9E") .or. _nRotina <> 2
        oStr2:SetProperty('ZM9_MOTIVO',MODEL_FIELD_OBRIGAT,.F.)
        oStr2:SetProperty('ZM9_CAUSA',MODEL_FIELD_OBRIGAT,.F.)
        oStr2:SetProperty('ZM9_RELAC',MODEL_FIELD_OBRIGAT,.F.)
        oStr2:SetProperty('ZM9_ACOES',MODEL_FIELD_OBRIGAT,.F.)
        oStr2:SetProperty('ZM9_PRAZO',MODEL_FIELD_OBRIGAT,.F.)
        oStr2:SetProperty('ZM9_RESP',MODEL_FIELD_OBRIGAT,.F.)
    EndIf

    // Instalo evento para abertura dos protocolos quando necessário
    oModel:InstallEvent("LTEVE002", /*cOwner*/, LTEVE002():New())
    
    /* oStr3:SetProperty("ZA2_FXDE",MODEL_FIELD_WHEN,{|x,y,z| U_LT013EDIT(x,y,z)}) */

	//oModel:GetModel('MASTER'):SetOnlyQuery(.T.)
    //oModel:getModel('MASTER'):SetOptional(.T.)
    
Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZM8')
	Local oStr2:= FWFormStruct(2, 'ZM9')
	oStr3:= FWFormStruct(2, 'ZA2')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'MASTER' )
	oView:AddGrid('FORM2' , oStr2,'ZM9DETAIL') 
	

    oView:CreateHorizontalBox( 'TOPBOX', 40)
    oView:CreateHorizontalBox( 'BOTBOX', 60)
	
	oView:SetOwnerView('FORM1','TOPBOX')
    oView:SetOwnerView('FORM2','BOTBOX')
	
	oView:EnableTitleView('FORM2' , 'Análise de investigação das causas de não conformidade' ) 

    oStr2:RemoveField( 'ZM9_NUM' )
	oStr2:RemoveField( 'ZM9_IDPROT' )

    // Se for movimento por fornecedor não apresenta os campos com os dados dos Produtores
    If ZM8->ZM8_TPMOV == 'F'

        oStr2:RemoveField('ZM9_FORNEC' )
        oStr2:RemoveField('ZM9_LOJA' )
        oStr2:RemoveField('ZM9_NOME' )
    EndIf

    If _nRotina == 2
        oView:SetViewProperty("MASTER", "ONLYVIEW") 
    /* Else
        oView:SetViewProperty("ZM9DETAIL", "ONLYVIEW")  */
    EndIf


    oView:AddUserButton( "Visualizar Pesagem", ""          , {|oView| U_LT012PES() } )    
    

Return oView


// Validação total do formulário 
Static Function LT012TOK(oModel)

	Local lRet			:= .T.
	
Return(lRet)

// Gravação dos dados do modelo
Static Function LT012GRV(oModel)
    Local lRet          := .T.
    Local lInclui		:= oModel:GetOperation() == MODEL_OPERATION_INSERT
    Local lAltera		:= oModel:GetOperation() == MODEL_OPERATION_UPDATE
    Local lExclui		:= oModel:GetOperation() == MODEL_OPERATION_DELETE


    Begin Transaction
        If lExclui
            dbSelectArea('ZM1')
            ZM1->(dbSetOrder(1)) 
            ZM1->(dbGoTop())
            If ZM1->(dbSeek(xFilial('ZM1')+ZM8->ZM8_NUM))
                RecLock('ZM1',.F.)
                    ZM1->ZM1_IDPROT := ''
                    ZM1->ZM1_STPROT := 'P' 
                ZM1->(MsUnlock())
            EndIf
        EndIf

        If !FWFormCommit(oModel)
            lRet:= .F.
            DisarmTransaction()
        EndIf
        If lRet .and. !lExclui
            RecLock('ZM8',.F.)
                
                If _nRotina == 1
                    ZM8->ZM8_STATUS := 'C' 
                ElseIf _nRotina == 2
                    ZM8->ZM8_STATUS := 'Q' 
                ElseIf _nRotina == 3
                    ZM8->ZM8_STATUS := 'F' 
                    ZM8->ZM8_DTAVAL := Date()
                    ZM8->ZM8_USRQLD := Left(UsrFullName()  , TamSx3("ZM8_USRQLD")[1])
                EndIf
            ZM8->(MsUnlock())

            dbSelectArea('ZM1')
            ZM1->(dbSetOrder(1)) 
            ZM1->(dbGoTop())
            If ZM1->(dbSeek(xFilial('ZM1')+ZM8->ZM8_NUM))
                RecLock('ZM1',.F.)
                    ZM1->ZM1_STPROT := ZM8->ZM8_STATUS
                    If ZM8->ZM8_STATUS == 'F'
                        ZM1->ZM1_SITQLD := 'F'
                    EndIf
                ZM1->(MsUnlock())
            EndIf
        EndIf
    End Transaction
Return lRet


//============================================================================\
/*/{Protheus.doc}LT12A
  ==============================================================================
    @description
    Definição de variáveis para montagem da tela 

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 19/04/2021

/*/
//============================================================================\
User Function LT12A( _nOpc )
    Local _lExec := .F.
    Private cTitulo := IIf(_nOpc==1,'Análise Laboratório',IIf(_nOpc==2,'Análise Captação / Fornecedor','Análise Qualidade'))
    
    _nRotina := _nOpc
    
    If ZM8->ZM8_STATUS == 'L' .AND. RetCodUsr() $ GetMv("MX_LT012L") .AND. _nOpc == 1
        _lExec := .T.
    EndIf
    If ZM8->ZM8_STATUS == 'C' .AND. RetCodUsr() $ GetMv("MX_LT012C") .AND. _nOpc == 2
        _lExec := .T.
    EndIf
    If ZM8->ZM8_STATUS == 'Q' .AND. RetCodUsr() $ GetMv("MX_LT012Q") .AND. _nOpc == 3
        _lExec := .T.
	EndIf

    If _lExec
        FWExecView(cTitulo,'LTMOV012', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
    Else
        MsgAlert("Usuário sem acesso ou o status do Protocolo não permite a operação selecionada!")
    EndIf

Return ( Nil )
// FIM da Funcao LT12A
//==============================================================================



//============================================================================\
/*/{Protheus.doc}LT012PES
  ==============================================================================
    @description
    Chama visualização da pesagem

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 20/04/2021

/*/
//============================================================================\
User Function LT012PES(  )
    dbSelectArea('ZM1')
    ZM1->(dbSetOrder(1)) 
    ZM1->(dbGoTop())
    If ZM1->(dbSeek(xFilial('ZM1')+ZM8->ZM8_NUM))
        U_LT019VIS("ZM1", ZM1->(RECNO()), 2)
    EndIf

Return ( Nil )
// FIM da Funcao LT012PES
//==============================================================================



