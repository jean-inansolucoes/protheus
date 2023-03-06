#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'FWMVCDef.ch'
#include "dbinfo.ch"


#DEFINE CAMPOS_CABECALHO    '|ZM1_TIPO|ZM1_DATA|ZM1_PROD|ZM1_DESC|ZM1_TRANSP|ZM1_DTRANS|ZM1_CODVEI|ZM1_PLACA|ZM1_CODMOT|ZM1_NOMMOT|ZM1_SITQLD|ZM1_LIBPRO|ZM1_STPROT|'


// bal05341357
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTMOV9E   ºAutor  ³DJONATA GUIZZO      º Data ³ 22/12/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Rotina Qualidade Recebimento Leite / Soro                  ³±±
±±³          ³                                                            ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LATICÍNIOS TRÊS BARRAS                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV9E()
    Local _nI           := 0
    Local cUsrQld	    := GETMV("MV_ZL00008",, "")
    Local _cQuery       := ''
    Private _aCposQld   := {}
    Private _cCposGrid  := ''
    Private lExeQlq	    := .F.
    Private _cRevisao   := ''
    Private _cMovProd  := ''
    Private _lInconf  
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Verifica se o usuário tem permissão para utilizar a funcionalidade Qualidade³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    If __cUserId $ cUsrQld
        lExeQlq := .T.
    EndIf

    If !lExeQlq
        MsgInfo("Usuário sem acesso para manipular as informações da pesagem!")
    EndIf

    // Posiciona no cadastro do produto para utilização posterior
    dbSelectArea('SB1')
    SB1->(dbSetOrder(1)) 
    SB1->(dbGoTop())
    SB1->(dbSeek(xFilial('SB1')+ZM1->ZM1_PROD))

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Posiciona no cadastro do produto vinculado à pesagem manipulada³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    dbSelectArea("ZA1")
    ZA1->(dbSetOrder(2))
    ZA1->(dbGoTop())
    If !ZA1->(dbSeek(xFilial("ZA1") + ZM1->ZM1_PROD))
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        //³Apresenta mensagem ao usuário informando que não existe tipo de análise definida para o produto vinculado há pesagem³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        U_GLALL001("Atenção", "Não existe tipo de análise definida para o produto vinculado à esta pesagem.", "A funcionalidade de Qualidade somente pode ser executada sob pesagens nas quais o produto vinculado possua tipo de análise presente no seu cadastro.")
        Return
    EndIf

    If Empty(ZM1->ZM1_TRANSP) .OR. Empty(ZM1->ZM1_CODLIN) .OR. Empty(ZM1->ZM1_PLACA)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        //³Apresenta mensagem ao usuário informando que não existe tipo de análise definida para o produto vinculado há pesagem³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        U_GLALL001("Atenção", "Não foram preenchidos os dados de Transporte da Pesagem.", "É obrigatório o preenchimento dos campos: Transp., Linha e Veículo.")
        Return
    EndIf

    // Se ainda não foi lançada nenhuma análise, entra como opção de inclusão, senão como alteração
    dbSelectArea('ZM4')
    ZM4->(dbSetOrder(1)) 
    ZM4->(dbGoTop())
    If !ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
        U_GLALL001("Atenção", "Ainda não foi realizado análise para essa pesagem.", "A funcionalidade de Qualidade por Fornecedor somente pode ser executada após a análise de Qualidade da Pesagem já ter sido realizada.")
        Return
    Else
        _cRevisao := ZM4->ZM4_REVISA
    EndIf

    // Empty(ZM1->ZM1_TRANSP) .OR. Empty(ZM1->ZM1_CODLIN) .OR. Empty(ZM1->ZM1_CODVEI)
    _cQuery := " SELECT ZL5_COD "
    _cQuery += " FROM "
    _cQuery += "    "+ RetSqlName("ZL5") + " ZL5 "
    _cQuery += " WHERE "
    _cQuery += "    D_E_L_E_T_ = ' ' "
    _cQuery += "    AND ZL5_TRANSP = '"+ZM1->ZM1_TRANSP+"' "
    _cQuery += "    AND ZL5_LINHA = '"+ZM1->ZM1_CODLIN+"' "
    _cQuery += "    AND ZL5_DATA = '"+dToS(ZM1->ZM1_DATA)+"' "

    If Select("TMPX") > 0
        TMPX->(dbCloseArea())
    EndIf

    TcQuery _cQuery New Alias 'TMPX'

    While !TMPX->(eof())
        _cMovProd := TMPX->ZL5_COD
        TMPX->(dbSkip())
    EndDo

    TMPX->(dbCloseArea())

    If Empty(_cMovProd)
        U_GLALL001("Atenção", "Não foi possível encontrar um Movto de Transporte para essa pesagem.", "Verifique os dados de transporte preenchidos.")
        Return
    EndIf

    dbSelectArea('ZM6')
    ZM6->(dbSetOrder(1)) 
    ZM6->(dbGoTop())
    If !ZM6->(dbSeek(xFilial('ZM6')+ZM1->ZM1_NUM))
        _lInconf  := MsgYesNo("Deseja realizar a análise apenas dos tanques em que houve inconformidade?")
        CriaZM6()
    EndIf

    If !Empty(ZM1->ZM1_IDPROT)
        MsgInfo("Pesagem possui protocolo! Para manipular as informações da qualidade será necessário excluir o Protocolo através da rotina específica.")
        FWExecView('Qualidade Recebimento','LTMOV009E', MODEL_OPERATION_VIEW, , { || .T. }, , , )
    Else
        FWExecView('Qualidade Recebimento','LTMOV009E', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
    EndIf
Return 
// FIM da Funcao LTMOV9E
//====================================================================================================================\



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
	Local oStr1:= FWFormStruct(1,'ZM1', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_CABECALHO + '|ZM1_FILIAL|ZM1_NUM|'})
	Local oStr2:= FWFormStruct(1,'ZM4')
	Local oStr3:= FWFormStruct(1,'ZM6')
	Local oStr4:= FWFormStruct(1,'ZM7')
	
    Local bPosVal:= {|oModel| TudoOk(oModel) }
	/*Local bBefore	:= {|oObjeto,cID,cAlias| OnCommit('BEFORE', oObjeto,cID,cAlias) }
	Local bAfter	:= {|oObjeto,cID,cAlias| OnCommit('AFTER', oObjeto,cID,cAlias) }
	Local bAfterSTTS:= {|oObjeto| OnCommit('AFTERSTTS', oObjeto) }
	Local bVldGrv:= {|oModel| FWFormCommit(oModel,bBefore,bAfter,bAfterSTTS) }
    */

	// Definição dos modelos
	oModel := MPFormModel():New('mLTMOV09E', /*bPreVal*/, bPosVal, /* bVldGrv */, /*bCancel*/)
	oModel:addFields('MASTER',,oStr1)
	oModel:addGrid('ZM4DETAIL','MASTER',oStr2)
	oModel:addGrid('ZM6DETAIL','ZM4DETAIL',oStr3 )
	oModel:addGrid('ZM7DETAIL','ZM6DETAIL',oStr4 )



	// Características e relacionamento dos modelos
	oModel:SetPrimaryKey({ 'ZM1_FILIAL', 'ZM1_NUM' })
	oModel:GetModel('ZM4DETAIL'):SetUniqueLine( { 'ZM4_TANQUE' } )
	oModel:GetModel('ZM6DETAIL'):SetUniqueLine( { 'ZM6_FORNEC','ZM6_LOJA' } )
	oModel:GetModel('ZM7DETAIL'):SetUniqueLine( { 'ZM7_CARACT' } )

	oModel:SetRelation('ZM4DETAIL', { { 'ZM4_FILIAL', 'XFILIAL("ZM4")' }, { 'ZM4_NUM', 'ZM1_NUM' } }, ZM4->(IndexKey(1)) )
	oModel:SetRelation('ZM6DETAIL', { { 'ZM6_FILIAL', 'XFILIAL("ZM6")' }, { 'ZM6_NUM', 'ZM1_NUM' }, { 'ZM6_TANQUE', 'ZM4_TANQUE' } }, ZM6->(IndexKey(1)) )
	oModel:SetRelation('ZM7DETAIL', { { 'ZM7_FILIAL', 'XFILIAL("ZM7")' }, { 'ZM7_NUM', 'ZM1_NUM' }, { 'ZM7_TANQUE', 'ZM6_TANQUE' }, { 'ZM7_FORNEC', 'ZM6_FORNEC' }, { 'ZM7_LOJA', 'ZM6_LOJA' } }, ZM7->(IndexKey(2)) )

	oModel:SetDescription('Qualidade Recebimento')
	oModel:GetModel('MASTER'):SetDescription('Pesagem')
	oModel:GetModel('ZM4DETAIL'):SetDescription('Tanques')
	oModel:GetModel('ZM6DETAIL'):SetDescription('Fornecedores')
	oModel:GetModel('ZM7DETAIL'):SetDescription('Análises')

    oModel:GetModel('MASTER'):SetOnlyQuery(.T.)
    oModel:GetModel('ZM4DETAIL'):SetOnlyQuery(.T.)
    oModel:GetModel('MASTER'):SetOnlyView()
    oModel:GetModel('ZM4DETAIL'):SetOnlyView()
    
    If ZM1->ZM1_SITCON == "F" .OR. !lExeQlq
        oModel:GetModel('ZM6DETAIL'):SetOnlyQuery(.T.)
        oModel:GetModel('ZM7DETAIL'):SetOnlyQuery(.T.)
    EndIf

    //oModel:GetModel( 'ZM4DETAIL' ):SetLoadFilter( { { 'ZM4_STATUS', "'D/P'" , MVC_LOADFILTER_IS_CONTAINED  } } )
    oModel:GetModel( 'ZM4DETAIL' ):SetLoadFilter( , "  ZM4_TANQUE IN (SELECT DISTINCT ZM6_TANQUE FROM ZM6010 WHERE ZM6_NUM = '"+ZM1->ZM1_NUM+"') " )

    oStr4:SetProperty("ZM7_TEXTO",MODEL_FIELD_WHEN,{|x,y,z| U_LT09EEDIT(x,y,z)})
    oStr4:SetProperty("ZM7_VALOR",MODEL_FIELD_WHEN,{|x,y,z| U_LT09EEDIT(x,y,z)})
    
    // Instalo evento para abertura dos protocolos quando necessário
    oModel:InstallEvent("LTEVE001", /*cOwner*/, LTEVE001():New())

Return oModel
// FIM da Funcao ModelDef
//-------------------------------------------------------------------




Static Function ViewDef()
    Local _nI := 0
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZM1', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_CABECALHO })
	Local oStr2:= FWFormStruct(2, 'ZM4')
	Local oStr3:= FWFormStruct(2, 'ZM6')
	Local oStr4:= FWFormStruct(2, 'ZM7')
    Local _aCposQld := {'ZM7_VALOR','ZM7_TEXTO'}
    Local _aCposZM1 := Separa(CAMPOS_CABECALHO,"|")


	// Definição dos modelos da View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FIELD_MASTER' , oStr1,'MASTER' )
	oView:AddGrid('GRID_ZM4' , oStr2,'ZM4DETAIL')
	oView:AddGrid('GRID_ZM6' , oStr3,'ZM6DETAIL')
    oView:AddGrid('GRID_ZM7' , oStr4,'ZM7DETAIL')

	oView:EnableTitleView('GRID_ZM4' , 'Tanques' )
	oView:EnableTitleView('GRID_ZM6' , 'Fornecedores' )
	oView:EnableTitleView('GRID_ZM7' , 'Análises' )

	// Definição dos Objetos visuais
	oView:CreateHorizontalBox( 'BOX_SUPERIOR', 20)
	oView:CreateHorizontalBox( 'BOX_INFERIOR', 80)
	oView:CreateVerticalBox( 'BOX_ESQUERDA' , 12, 'BOX_INFERIOR')
	oView:CreateVerticalBox( 'BOX_MEIO'     , 28, 'BOX_INFERIOR')
	oView:CreateVerticalBox( 'BOX_DIREITA'  , 60, 'BOX_INFERIOR')
	
	// Ligação dos modelos com os objetos visuais
	oView:SetOwnerView('FIELD_MASTER','BOX_SUPERIOR')
	oView:SetOwnerView('GRID_ZM4','BOX_ESQUERDA')
	oView:SetOwnerView('GRID_ZM6','BOX_MEIO')
	oView:SetOwnerView('GRID_ZM7','BOX_DIREITA')
 
    oStr2:RemoveField( 'ZM4_NUM' )
    oStr2:RemoveField( 'ZM4_REVISA' )
    oStr2:RemoveField( 'ZM4_HRDESC' )
    oStr2:RemoveField( 'ZM4_SILO' )
    oStr2:RemoveField( 'ZM4_SEQSIL' )
    oStr3:RemoveField( 'ZM6_NUM' )
    oStr3:RemoveField( 'ZM6_TANQUE' )
    oStr3:RemoveField( 'ZM6_FORNEC' )
    oStr4:RemoveField( 'ZM7_NUM' )
    oStr4:RemoveField( 'ZM7_TANQUE' )
    oStr4:RemoveField( 'ZM7_FORNEC' )
    oStr4:RemoveField( 'ZM7_LOJA' )
    oStr4:RemoveField( 'ZM7_USRANA' )
    oStr4:RemoveField( 'ZM7_HRANA' )

    oStr1:AddGroup( 'GRUPO01', 'Pesagem'           , '', 1 )
    oStr1:AddGroup( 'GRUPO02', 'Status Qualidade'         , '', 2 )

    For _nI := 1 To Len(_aCposZM1)
        If !Empty(_aCposZM1[_nI])
            oStr1:SetProperty(_aCposZM1[_nI]     , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
            oStr1:SetProperty(_aCposZM1[_nI]     , MVC_VIEW_CANCHANGE, .F.)
        EndIf
    Next

    _aCposZM4 := oStr2:GetFields()
    For _nI := 1 To Len(_aCposZM4)
        oStr2:SetProperty(_aCposZM4[_nI,1] , MVC_VIEW_CANCHANGE, .F.)
    Next _nI

    oStr1:SetProperty('ZM1_SITQLD' ,MVC_VIEW_FOLDER_NUMBER, '1')
    oStr1:SetProperty('ZM1_SITQLD' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZM1_LIBPRO' ,MVC_VIEW_FOLDER_NUMBER, '1')
    oStr1:SetProperty('ZM1_LIBPRO' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZM1_STPROT' ,MVC_VIEW_FOLDER_NUMBER, '1')
    oStr1:SetProperty('ZM1_STPROT' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    
     
    // Ajusto a largura de algumas colunas que ficaram muito grandes no padrão
    oStr3:SetProperty("ZM6_NOME",MVC_VIEW_WIDTH,220)
    oStr4:SetProperty("ZM7_VALOR",MVC_VIEW_WIDTH,150)
    oStr4:SetProperty("ZM7_DESCTX",MVC_VIEW_WIDTH,150)
    oStr4:SetProperty("ZM7_DESCR",MVC_VIEW_WIDTH,200)
    oStr4:SetProperty("ZM7_STATUS",MVC_VIEW_WIDTH,150)

    //oStr3:SetProperty("ZM6_NOME",MVC_VIEW_WIDTH,20)
    
    For _nI := 1 To Len(_aCposQld)
	    oView:SetFieldAction(_aCposQld[_nI], { |oView, cIDView, cField, xValue| U_LT09EEST(oView, cIDView, cField, xValue) } )
    Next


    // Bloqueia edição dos campos se usuário não tiver acesso
    If !lExeQlq
        _aCposZM6 := oStr3:GetFields()
        For _nI := 1 To Len(_aCposZM6)
            oStr3:SetProperty(_aCposZM6[_nI,1] , MVC_VIEW_CANCHANGE, .F.)
        Next _nI

        
        _aCposZM7 := oStr4:GetFields()
        For _nI := 1 To Len(_aCposZM7)
            oStr4:SetProperty(_aCposZM7[_nI,1] , MVC_VIEW_CANCHANGE, .F.)
        Next _nI
    EndIf 

    oView:SetViewProperty( "*", "GRIDNOORDER")


    //oView:SetViewProperty("ZM4DETAIL", "ONLYVIEW")   
    
    // Realiza carga inicial dos dados caso nenhuma análise tenha sido lançada ainda
    //oView:SetAfterViewActivate({|oView| LoadAnalises(oView) })
    

Return oView
// FIM da Funcao ViewDef
//-------------------------------------------------------------------


// Carga inicial do modelo
Static Function LoadAnalises( oView )

	Local oModelZM1	:= oView:GetModel("MASTER")
	Local oModelZM4	:= oView:GetModel("ZM4DETAIL")
	Local oModelZM6	:= oView:GetModel("ZM6DETAIL")
	Local oModelZM7	:= oView:GetModel("ZM7DETAIL")
	Local _lPrimZM6	:= .T.
    Local _lPrimZM7	:= .T.
    Local _nLinZM7  := 0
    Local _nLinZM6  := 0
    Local _nLinAtu  := 0
    Local _nI       := 0
    Local _aCposZM1 := Separa("ZM1_NUM"+CAMPOS_CABECALHO,"|")

    
    For _nI := 1 To oModelZM4:Length()
        If _lPrimZM6
            _lPrimZM6 := .F.
        Else
            _nLinAtu := oModelZM4:Length()
            _nLinZM6 := oModelZM4:AddLine()

            If _nLinZM6 <> (_nLinAtu + 1)
                oView:ShowLastError()
                oView:Refresh()
                Return (.F.)
            EndIf
        EndIf

        oModelZM6:LoadValue('ZM6_TANQUE'  , oModelZM4:GetValue("ZM4_TANQUE") )
        
        dbSelectArea('ZA1')
        ZA1->(dbSetOrder(2)) 
        ZA1->(dbGoTop())
        If ZA1->(dbSeek(xFilial('ZA1')+SB1->B1_COD+_cRevisao))
            While !ZA1->(EOF()) .AND. ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA == xFilial('ZA1')+SB1->B1_COD+_cRevisao
                If _lPrimZM7
                    _lPrimZM7 := .F.
                    _nLinZM7 := 1
                Else
                    _nLinAtu := oModelZM7:Length()
                    _nLinZM7 := oModelZM7:AddLine()

                    If _nLinZM7 <> (_nLinAtu + 1)
                        oView:ShowLastError()
                        oView:Refresh()
                        Return (.F.)
                    EndIf
                EndIf

                oModelZM7:GoLine(_nLinZM7)

                oModelZM7:LoadValue('ZM7_TANQUE', StrZero(_nI,2) )
                oModelZM7:LoadValue('ZM7_CARACT', ZA1->ZA1_CARACT )
                oModelZM7:LoadValue('ZM7_DESCR', ZA1->ZA1_DESCR )
                oModelZM7:LoadValue('ZM7_ORDEM', ZA1->ZA1_ORDEM )
                
                
                ZA1->(dbSkip()) 
            EndDo

            _lPrimZM7 := .T.
            oModelZM7:GoLine(1)
        EndIf       
    Next 

    oModelZM4:GoLine(1)
    


    oView:Refresh()

Return ( .T. )



// Atualiza o status do tanque de acordo com as medições realizadas
User Function LT09EEST(oView, cIDView, cField, xValue)
    Local oModel		:= FWModelActive()
	Local oModelZM7		:= oModel:GetModel("ZM7DETAIL")
    Local oModelZM6		:= oModel:GetModel("ZM6DETAIL")
	Local _cCaract      := oModelZM7:GetValue("ZM7_CARACT")
    Local _aTbPrior := {} // Tabela para constrolar a prioridade de cada status, Ex: se houver um descarte, esse vai ser o status final
    Local _nPosStat := 0
    Local _nStatAtu := 0
    Local _cStatNew := ''
    Local _nStatNew := 0
    Local _cStatMed := ''
    Local _lEmpty   := .F.
    Local _nI := 0
    


    If Empty(xValue)
        oModel:SetValue('ZM6DETAIL','ZM6_STATUS',"")
        oModel:SetValue('ZM7DETAIL','ZM7_STATUS',"")
        oView:Refresh('ZM6DETAIL')
        oView:Refresh('ZM7DETAIL')
    EndIf


    aAdd(_aTbPrior,{'D',1}) // Descarte
    aAdd(_aTbPrior,{'P',2}) // Protocolo
    aAdd(_aTbPrior,{'A',3}) // Aprovado

    
    _nStatAtu := 99 // Atribuo um valor genérico
    
    dbSelectArea('ZA1')
    ZA1->(dbSetOrder(1)) //ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA+ZA1->ZA1_CARACT
    ZA1->(dbGoTop())
    If ZA1->(dbSeek(xFilial('ZA1')+ZM1->ZM1_PROD+_cRevisao+_cCaract))
        dbSelectArea('ZA2')
        ZA2->(dbSetOrder(1)) 
        ZA2->(dbGoTop())
        If ZA2->(dbSeek(xFilial('ZA2')+ZM1->ZM1_PROD+_cRevisao+_cCaract))
            While ZA2->(!Eof()) .And. ZA2->ZA2_FILIAL+ZA2->ZA2_PROD+ZA2->ZA2_CARACT == xFilial('ZA2')+ZM1->ZM1_PROD+_cCaract
                If ZA1->ZA1_TIPO == 'N'
                    If xValue >= ZA2->ZA2_FXDE .AND. xValue <= ZA2->ZA2_FXATE
                        _cStatMed := ZA2->ZA2_RESULT
                    EndIf
                ElseIf ZA1->ZA1_TIPO == 'T'
                    If Upper(xValue) == ZA2->ZA2_MED
                        _cStatMed := ZA2->ZA2_RESULT
                    EndIf
                EndIf
                ZA2->(DbSkip())
            EndDo

            // Se não econtrar nenhum status, joga para protocolo
            If Empty(_cStatMed)
                MsgInfo("Atenção! Não foi possível encontrar uma faixa de medição para esta característica vinculada ao produto. Verifique!")
                _cStatMed := 'P'
            EndIf
        EndIf
    EndIf

    // Primeiro, atualiza o status da característica na respectiva linha,
    // em seguida irá varrer todas as características para atualizar o status do Tanque
    oModel:SetValue('ZM7DETAIL','ZM7_STATUS',_cStatMed)

    _nPosStat := aScan(_aTbPrior,{|x| x[1] == _cStatMed})
    _nStatNew := Min(_nStatAtu,_aTbPrior[_nPosStat,2])
    
    _nPosStat := aScan(_aTbPrior,{|x| x[2] == _nStatNew})
    _cStatNew := _aTbPrior[_nPosStat,1]
    
    // Primeiro, acima, verifico a característica do campo atual
    // se a medição tem prioridade 1, já sai fora e nem valida os outros campos
    If _nStatNew <> 1
        For _nI := 1 To oModelZM7:Length()
            _cStatMed := oModelZM7:GetValue("ZM7_STATUS",_nI)

            If Empty(_cStatMed)
                _lEmpty := .T.
                Exit
            Else
                _nPosStat := aScan(_aTbPrior,{|x| x[1] == _cStatMed})
                _nStatNew := Min(_nStatNew,_aTbPrior[_nPosStat,2])
                
                _nPosStat := aScan(_aTbPrior,{|x| x[2] == _nStatNew})
                _cStatNew := _aTbPrior[_nPosStat,1]
            EndIf

            // Se alguma característica exige descarte, já encerra e nem valida as outras características
            If _nStatNew == 1
                Exit
            EndIf
        Next _nI
    EndIf

    
    oView:Refresh('ZM7DETAIL')

    // Só atualiza o status do tanque se todas as análises tiverem sido feitas
    If !_lEmpty
        oModel:SetValue('ZM6DETAIL','ZM6_STATUS',_cStatNew)
        oView:Refresh('ZM6DETAIL')
    EndIf
Return



Static Function TudoOk(oModel)


	Local lRet			:= .T.
	Local oModelZM1	:= oModel:GetModel("MASTER")
	Local oModelZM4	:= oModel:GetModel("ZM4DETAIL")
	Local oModelZM4	:= oModel:GetModel("ZM6DETAIL")
	Local oModelZM7	:= oModel:GetModel("ZM7DETAIL")
    Local _cMsgErro := ''
    Local _cMsgSol := ''
    Local nI
    Local nX
    Local _cStatFim := FwFldGet('ZM1_SITQLD')
    Local _cNewStat := 'P'
    Local _lEmpty := .F.

	If !lRet .And. ! Empty(_cMsgErro)
		oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
	EndIf


Return(lRet)

//============================================================================\
/*/{Protheus.doc}LT013GAT
  ==============================================================================
    @description
    Gatilhos

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 04/02/2021

/*/ 
//============================================================================\
User Function LT09EGAT( )
    Local oView  := FwViewActive()
    Local oModelZM7 := oView:oModel:GetModel("ZM7DETAIL")
    Local _nLine    := oModelZM7:GetLine()
    Local _cCaract  := oModelZM7:GetValue("ZM7_CARACT",_nLine)
    Local _xRet
    
    _xRet := Posicione('ZA4',1,xFilial('ZA4')+_cCaract+Upper(M->ZM7_TEXTO),'ZA4_DESCR')
    
    
Return ( _xRet )
// FIM da Funcao LT013GAT
//==============================================================================



// verifica se permite editar os campos
User Function LT09EEDIT(x,_cCampo,z)
    Local _lRet := .T.
    Local oModel := FWModelActive()
    Local oView  := FwViewActive()
    Local oModelZM7 := oModel:GetModel("ZM7DETAIL")
    Local _cCaract := oModelZM7:GetValue("ZM7_CARACT")
    Local _aOpcoes := {}

    dbSelectArea('ZA3')
    ZA3->(dbSetOrder(1)) 
    ZA3->(dbGoTop())
    If ZA3->(dbSeek(xFilial('ZA3')+_cCaract))
        If AllTrim(_cCampo) == 'ZM7_TEXTO'
            _lRet := ZA3->ZA3_TIPO == 'T'
        Else
            _lRet := ZA3->ZA3_TIPO == 'N'
        EndIf
    EndIf
Return _lRet



// Cria os registros nas tabelas ZM6 E ZM7 conforme movimento de produtores
Static Function CriaZM6()
    Local _nI       := 0
    Local _cTanque  := ''
    Local _aCaract  := {}
    Local _nTamTqe  := TamSx3('ZL6_TANQUE')[1]
    
    Local _cInconf  := ''

    dbSelectArea('ZM4')
    ZM4->(dbSetOrder(1)) 
    ZM4->(dbGoTop())
    If ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
        While !ZM4->(EOF()) .AND. ZM4->ZM4_FILIAL+ZM4->ZM4_NUM == xFilial('ZM4')+ZM1->ZM1_NUM
            If !(ZM4->ZM4_STATUS $ 'P/D') .AND. _lInconf
                _cInconf += ZM4->ZM4_TANQUE + '/'
            ElseIf ZM4->ZM4_STATUS == 'V' // Não apresenta os tanques vazios
                _cInconf += ZM4->ZM4_TANQUE + '/'
            EndIf
            ZM4->(dbSkip())
        EndDo
    EndIf


    dbSelectArea('ZA1')
    ZA1->(dbSetOrder(2)) 
    ZA1->(dbGoTop())
    ZA1->(dbSeek(xFilial('ZA1')+ZM1->ZM1_PROD+_cRevisao))
    While ZA1->(!Eof()) .And. ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA == xFilial('ZA1')+ZM1->ZM1_PROD+_cRevisao
        aAdd(_aCaract,{ZA1->ZA1_ORDEM,ZA1->ZA1_CARACT,ZA1->ZA1_DESCR})
        
        ZA1->(DbSkip())
    EndDo


    dbSelectArea('ZL6')
    ZL6->(dbSetOrder(1)) 
    ZL6->(dbGoTop())
    If ZL6->(dbSeek(xFilial('ZL6')+_cMovProd))
        While ZL6->(!Eof()) .And. ZL6->ZL6_FILIAL+ZL6->ZL6_COD == xFilial('ZL6')+_cMovProd
            For _nI := 1 To _nTamTqe
                _cTanque := SubStr(ZL6->ZL6_TANQUE,_nI,1)

                If !Empty(_cTanque)
                    _cTanque := StrZero(Val(_cTanque),2)

                    If !(_cTanque $ _cInconf) // não mostra tanques com inconformidade, se assim definido pelo usuário, e os vazios
                        RecLock('ZM6',.T.)
                            ZM6->ZM6_FILIAL := xFilial("ZM6")
                            ZM6->ZM6_NUM    := ZM1->ZM1_NUM
                            ZM6->ZM6_FORNEC := ZL6->ZL6_PRODUT
                            ZM6->ZM6_LOJA   := ZL6->ZL6_LOJPRD
                            ZM6->ZM6_NOME   := ZL6->ZL6_NOMPRD
                            ZM6->ZM6_TANQUE := _cTanque
                        ZM6->(MsUnlock())   
                    EndIf
                EndIf
            Next _nI
            ZL6->(DbSkip())
        EndDo
    EndIf

    dbSelectArea('ZM6')
    ZM6->(dbSetOrder(1)) 
    ZM6->(dbGoTop())
    If ZM6->(dbSeek(xFilial('ZM6')+ZM1->ZM1_NUM))
        While ZM6->(!Eof()) .And. ZM6->ZM6_FILIAL+ZM6->ZM6_NUM == xFilial('ZM6')+ZM1->ZM1_NUM
          
            For _nI := 1 To Len(_aCaract)
                _lIncZM7 := .F.
                If _lInconf 
                    dbSelectArea('ZM5')
                    ZM5->(dbSetOrder(1)) 
                    ZM5->(dbGoTop())
                    If ZM5->(dbSeek(xFilial('ZM5')+ZM6->(ZM6_NUM+ZM6_TANQUE)+_aCaract[_nI,2]))
                        If ZM5->ZM5_STATUS $ 'P/D'
                            _lIncZM7 := .T.
                        EndIf 
                    EndIf
                Else
                    _lIncZM7 := .T.
                EndIf

                If _lIncZM7
                    RecLock('ZM7',.T.)
                        ZM7->ZM7_FILIAL := xFilial('ZM7') 
                        ZM7->ZM7_NUM    := ZM1->ZM1_NUM
                        ZM7->ZM7_FORNEC := ZM6->ZM6_FORNEC
                        ZM7->ZM7_LOJA   := ZM6->ZM6_LOJA
                        ZM7->ZM7_TANQUE := ZM6->ZM6_TANQUE
                        ZM7->ZM7_ORDEM  := _aCaract[_nI,1]
                        ZM7->ZM7_CARACT := _aCaract[_nI,2]
                        ZM7->ZM7_DESCR  := _aCaract[_nI,3]
                    ZM7->(MsUnlock())
                EndIf
            Next _nI
        
            ZM6->(DbSkip())
        EndDo
    EndIf

Return
