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
±±ºPrograma  ³ LTMOV9D   ºAutor  ³DJONATA GUIZZO      º Data ³ 22/12/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Rotina Qualidade Recebimento Leite / Soro                  ³±±
±±³          ³                                                            ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LATICÍNIOS TRÊS BARRAS                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV9D()
    Local _nI := 0
    Local cUsrQld	:= GETMV("MV_ZL00008",, "")
    Private _aCposQld := {}
    Private _cCposGrid := ''
    Private lExeQlq	:= .F.
    Private _cRevisao := ''
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Verifica se o usuário tem permissão para utilizar a funcionalidade Qualidade³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    If __cUserId $ cUsrQld
        lExeQlq := .T.
    EndIf

    If !lExeQlq
        MsgInfo("Usuário sem acesso para manipular as informações da pesagem!")
    ElseIf ZM1->ZM1_SITCON == 'F'
        MsgInfo("Pesagem já conciliada! Não é permitido manipular as informações da pesagem.")
    ElseIf !Empty(ZM1->ZM1_IDPROT)
        MsgInfo("Pesagem possui protocolo! Para manipular as informações da qualidade será necessário excluir o Protocolo através da rotina específica.")
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
        U_GLALL001("Atenção", "Não existe tipo de análise definida para o produto vinculado à está pesagem.", "A funcionalidade de Qualidade somente pode ser executada sob pesagens nas quais o produto vinculado possua tipo de análise presente no seu cadastro.")
        Return
    EndIf


    // Verifica a revisão vigente à epoca do fato
    dbSelectArea('ZA5')
    ZA5->(dbSetOrder(1)) 
    ZA5->(dbGoTop())
    If ZA5->(dbSeek(xFilial('ZA5')+SB1->B1_COD))
        While ZA5->(!Eof()) .And. ZA5->ZA5_FILIAL+ZA5->ZA5_PROD == xFilial('ZA5')+SB1->B1_COD
            If ZA5->ZA5_DTINI <= dDataBase .AND. (Empty(ZA5->ZA5_DTFIM) .OR. ZA5->ZA5_DTFIM >= dDataBase)
                _cRevisao := ZA5->ZA5_REVISA
            EndIf
            
            ZA5->(DbSkip())
        EndDo
    EndIf

    // Se ainda não foi lançada nenhuma análise, entra como opção de inclusão, senão como alteração
    dbSelectArea('ZM4')
    ZM4->(dbSetOrder(1)) 
    ZM4->(dbGoTop())
    If ZM1->ZM1_SITCON == "F" .OR. !lExeQlq .or. !Empty(ZM1->ZM1_IDPROT)
        FWExecView('Qualidade Recebimento','LTMOV009D', MODEL_OPERATION_VIEW, , { || .T. }, , , )
    ElseIf ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
        FWExecView('Qualidade Recebimento','LTMOV009D', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
    Else
        FWExecView('Qualidade Recebimento','LTMOV009D', MODEL_OPERATION_INSERT, , { || .T. }, , , )
    EndIf

Return 
// FIM da Funcao LTMOV9D
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
	Local oStr1:= FWFormStruct(1,'ZM1', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_CABECALHO + '|ZM1_FILIAL|ZM1_NUM|ZM1_IDPROT|'})
	Local oStr2:= FWFormStruct(1,'ZM4')
	Local oStr3:= FWFormStruct(1,'ZM5')
	
    Local bPosVal:= {|oModel| TudoOk(oModel) }
	/*Local bBefore	:= {|oObjeto,cID,cAlias| OnCommit('BEFORE', oObjeto,cID,cAlias) }
	Local bAfter	:= {|oObjeto,cID,cAlias| OnCommit('AFTER', oObjeto,cID,cAlias) }
	Local bAfterSTTS:= {|oObjeto| OnCommit('AFTERSTTS', oObjeto) }
	Local bVldGrv:= {|oModel| FWFormCommit(oModel,bBefore,bAfter,bAfterSTTS) }
    */

	// Definição dos modelos
	oModel := MPFormModel():New('mLTMOV009D', /*bPreVal*/, bPosVal, /* bVldGrv */, /*bCancel*/)
	oModel:addFields('MASTER',,oStr1)
	oModel:addGrid('ZM4DETAIL','MASTER',oStr2)
	oModel:addGrid('ZM5DETAIL','ZM4DETAIL',oStr3 )



	// Características e relacionamento dos modelos
	oModel:SetPrimaryKey({ 'ZM1_FILIAL', 'ZM1_NUM' })
	oModel:GetModel('ZM4DETAIL'):SetUniqueLine( { 'ZM4_TANQUE' } )
	oModel:GetModel('ZM5DETAIL'):SetUniqueLine( { 'ZM5_CARACT' } )

	oModel:SetRelation('ZM4DETAIL', { { 'ZM4_FILIAL', 'XFILIAL("ZM4")' }, { 'ZM4_NUM', 'ZM1_NUM' } }, ZM4->(IndexKey(1)) )
	oModel:SetRelation('ZM5DETAIL', { { 'ZM5_FILIAL', 'XFILIAL("ZM5")' }, { 'ZM5_NUM', 'ZM1_NUM' }, { 'ZM5_TANQUE', 'ZM4_TANQUE' } }, ZM5->(IndexKey(2)) )

	oModel:SetDescription('Qualidade Recebimento')
	oModel:GetModel('MASTER'):SetDescription('Pesagem')
	oModel:GetModel('ZM4DETAIL'):SetDescription('Tanques')
	oModel:GetModel('ZM5DETAIL'):SetDescription('Análise')

    oModel:GetModel('MASTER'):SetOnlyQuery(.T.)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Não permite manipular pesagem caso já esteja conciliada³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    If ZM1->ZM1_SITCON == "F" .OR. !lExeQlq .or. !Empty(ZM1->ZM1_IDPROT)
        oModel:GetModel('ZM4DETAIL'):SetOnlyQuery(.T.)
        oModel:GetModel('ZM5DETAIL'):SetOnlyQuery(.T.)
        oModel:GetModel('MASTER'):SetOnlyView()
    EndIf


    oStr3:SetProperty("ZM5_TEXTO",MODEL_FIELD_WHEN,{|x,y,z| U_LT009EDIT(x,y,z)})
    oStr3:SetProperty("ZM5_VALOR",MODEL_FIELD_WHEN,{|x,y,z| U_LT009EDIT(x,y,z)})

    /* bBloc:=FWBuildFeature(STRUCT_FEATURE_VALID,", .T.")
    oStr1:SetProperty("ZM1_SITQLD",MODEL_FIELD_VALID,bBloc) */
        
    
    /* oModel:GetModel('ZM5DETAIL'):SetLPre({|oModelGrid,nLine,cOperation,a,b,c| VldLineTar(oModelGrid,nLine,cOperation,a,b,c) })
	oModel:GetModel('ZM4DETAIL'):SetLPre({|oModelGrid,nLine,cOperation,a,b,c| VldLineDat(oModelGrid,nLine,cOperation,a,b,c) })
	oModel:GetModel('ZM4DETAIL'):SetLPost({|oModelGrid,nLine,cOperation,a,b,c| VldLDatPos(oModelGrid,nLine,cOperation,a,b,c) })
 */
 
    // Instalo evento para abertura dos protocolos quando necessário
    oModel:InstallEvent("LTEVE001", /*cOwner*/, LTEVE001():New())
    
	/* oModel:SetVldActivate({|oModel| VldActivate(oModel) })*/
Return oModel
// FIM da Funcao ModelDef
//-------------------------------------------------------------------




Static Function ViewDef()
    Local _nI := 0
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZM1', {|x| '|'+AllTrim(x)+'|' $ CAMPOS_CABECALHO })
	Local oStr2:= FWFormStruct(2, 'ZM4')
	Local oStr3:= FWFormStruct(2, 'ZM5')
    Local _aCposQld := {'ZM5_VALOR','ZM5_TEXTO'}
    Local _aCposZM1 := Separa(CAMPOS_CABECALHO,"|")


	// Definição dos modelos da View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FIELD_MASTER' , oStr1,'MASTER' )
	oView:AddGrid('GRID_ZM4' , oStr2,'ZM4DETAIL')
	oView:AddGrid('GRID_ZM5' , oStr3,'ZM5DETAIL')

    /* oView:SetNoInsertLine('GRID_ZM4')
    oView:SetNoDeleteLine('GRID_ZM4') */
 
	oView:EnableTitleView('GRID_ZM4' , 'Tanques' )
	oView:EnableTitleView('GRID_ZM5' , 'Análises' )

	// Definição dos Objetos visuais
	oView:CreateHorizontalBox( 'BOX_SUPERIOR', 38)
	oView:CreateHorizontalBox( 'BOX_INFERIOR', 62)
	oView:CreateVerticalBox( 'BOX_ESQUERDA', 35, 'BOX_INFERIOR')
	oView:CreateVerticalBox( 'BOX_DIREITA' , 65, 'BOX_INFERIOR')
	
	// Ligação dos modelos com os objetos visuais
	oView:SetOwnerView('FIELD_MASTER','BOX_SUPERIOR')
	oView:SetOwnerView('GRID_ZM4','BOX_ESQUERDA')
	oView:SetOwnerView('GRID_ZM5','BOX_DIREITA')

    oStr2:RemoveField( 'ZM4_NUM' )
    oStr3:RemoveField( 'ZM5_NUM' )
    oStr3:RemoveField( 'ZM5_TANQUE' )

    oStr1:AddGroup( 'GRUPO01', 'Pesagem'           , '', 1 )
    oStr1:AddGroup( 'GRUPO02', 'Status Qualidade'         , '', 2 )

    For _nI := 1 To Len(_aCposZM1)
        If !Empty(_aCposZM1[_nI])
            oStr1:SetProperty(_aCposZM1[_nI]     , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
            oStr1:SetProperty(_aCposZM1[_nI]     , MVC_VIEW_CANCHANGE, .F.)
        EndIf
    Next

    oStr1:SetProperty('ZM1_SITQLD' ,MVC_VIEW_FOLDER_NUMBER, '1')
    oStr1:SetProperty('ZM1_SITQLD' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZM1_SITQLD' , MVC_VIEW_CANCHANGE, .T.)
    oStr1:SetProperty('ZM1_LIBPRO' ,MVC_VIEW_FOLDER_NUMBER, '1')
    oStr1:SetProperty('ZM1_LIBPRO' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZM1_STPROT' ,MVC_VIEW_FOLDER_NUMBER, '1')
    oStr1:SetProperty('ZM1_STPROT' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    
    For _nI := 1 To Len(_aCposQld)
	    oView:SetFieldAction(_aCposQld[_nI], { |oView, cIDView, cField, xValue| U_LTMOV9ST(oView, cIDView, cField, xValue) } )
    Next 
    
    oView:SetFieldAction("ZM4_HRDESC", { |oView, cIDView, cField, xValue| U_LTMOV9HR(oView, cIDView, cField, xValue) } )


    // Bloqueia edição dos campos se usuário não tiver acesso
    If !lExeQlq
        oStr1:SetProperty('ZM1_SITQLD'     , MVC_VIEW_CANCHANGE, .F.)
        oStr1:SetProperty('ZM1_STPROT'     , MVC_VIEW_CANCHANGE, .F.)
        
        _aCposZM4 := oStr2:GetFields()
        For _nI := 1 To Len(_aCposZM4)
            oStr2:SetProperty(_aCposZM4[_nI,1] , MVC_VIEW_CANCHANGE, .F.)
        Next _nI
        
        _aCposZM5 := oStr3:GetFields()
        For _nI := 1 To Len(_aCposZM5)
            oStr3:SetProperty(_aCposZM5[_nI,1] , MVC_VIEW_CANCHANGE, .F.)
        Next _nI
    EndIf

    If ZM1->ZM1_SITQLD == 'F'
        oView:SetViewProperty("ZM4DETAIL", "ONLYVIEW")   
        oView:SetViewProperty("ZM5DETAIL", "ONLYVIEW")   
    EndIf
	
    // Realiza carga inicial dos dados caso nenhuma análise tenha sido lançada ainda
    oView:SetAfterViewActivate({|oView| LoadAnalises(oView) })
    oView:SetViewProperty( "*", "GRIDNOORDER")

    oStr2:SetProperty("ZM4_TANQUE",MVC_VIEW_WIDTH,50)
    oStr2:SetProperty("ZM4_REVISA",MVC_VIEW_WIDTH,50)
    oStr2:SetProperty("ZM4_HRDESC",MVC_VIEW_WIDTH,80)
    oStr2:SetProperty("ZM4_SILO",MVC_VIEW_WIDTH,80)
    oStr2:SetProperty("ZM4_SEQSIL",MVC_VIEW_WIDTH,60)
    oStr2:SetProperty("ZM4_STATUS",MVC_VIEW_WIDTH,80)

Return oView
// FIM da Funcao ViewDef
//-------------------------------------------------------------------


// Carga inicial do modelo
Static Function LoadAnalises( oView )

	Local oModelZM1	:= oView:GetModel("MASTER")
	Local oModelZM4	:= oView:GetModel("ZM4DETAIL")
	Local oModelZM5	:= oView:GetModel("ZM5DETAIL")
	Local _lPrimZM4	:= .T.
    Local _lPrimZM5	:= .T.
    Local _nLinZM4  := 0
    Local _nLinZM5  := 0
    Local _nLinAtu  := 0
    Local _nI       := 0
    Local _aCposZM1 := Separa("ZM1_NUM"+CAMPOS_CABECALHO,"|")

    // Se for alteração, não faz a carga do model, pois será feita automaticamente
	If oView:GetModel():GetOperation() <> MODEL_OPERATION_INSERT
        Return .T.
    EndIf

    For _nI := 1 To Len(_aCposZM1)
        If !(Empty(_aCposZM1[_nI]))
            oModelZM1:LoadValue(_aCposZM1[_nI], ZM1->&(_aCposZM1[_nI]))
        EndIf
    Next

    
    For _nI := 1 To ZM1->ZM1_NRTNQ
        If _lPrimZM4
            _lPrimZM4 := .F.
        Else
            _nLinAtu := oModelZM4:Length()
            _nLinZM4 := oModelZM4:AddLine()

            If _nLinZM4 <> (_nLinAtu + 1)
                oView:ShowLastError()
                oView:Refresh()
                Return (.F.)
            EndIf
        EndIf

        oModelZM4:LoadValue('ZM4_TANQUE'  , StrZero(_nI,2) )
        oModelZM4:LoadValue('ZM4_REVISA'  , _cRevisao )
        
        dbSelectArea('ZA1')
        ZA1->(dbSetOrder(2)) 
        ZA1->(dbGoTop())
        If ZA1->(dbSeek(xFilial('ZA1')+SB1->B1_COD+_cRevisao))
            While !ZA1->(EOF()) .AND. ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA == xFilial('ZA1')+SB1->B1_COD+_cRevisao
                If _lPrimZM5
                    _lPrimZM5 := .F.
                    _nLinZM5 := 1
                Else
                    _nLinAtu := oModelZM5:Length()
                    _nLinZM5 := oModelZM5:AddLine()

                    If _nLinZM5 <> (_nLinAtu + 1)
                        oView:ShowLastError()
                        oView:Refresh()
                        Return (.F.)
                    EndIf
                EndIf

                oModelZM5:GoLine(_nLinZM5)

                oModelZM5:LoadValue('ZM5_TANQUE', StrZero(_nI,2) )
                oModelZM5:LoadValue('ZM5_CARACT', ZA1->ZA1_CARACT )
                oModelZM5:LoadValue('ZM5_DESCR', ZA1->ZA1_DESCR )
                oModelZM5:LoadValue('ZM5_ORDEM', ZA1->ZA1_ORDEM )
                
                
                ZA1->(dbSkip()) 
            EndDo

            _lPrimZM5 := .T.
            oModelZM5:GoLine(1)
        EndIf       
    Next 

    oModelZM4:GoLine(1)
    


    oView:Refresh()

Return ( .T. )



// Atualiza o status do tanque de acordo com as medições realizadas
User Function LTMOV9ST(oView, cIDView, cField, xValue)
    Local oModel		:= FWModelActive()
	Local oModelZM5		:= oModel:GetModel("ZM5DETAIL")
    Local oModelZM4		:= oModel:GetModel("ZM4DETAIL")
	Local _cCaract      := oModelZM5:GetValue("ZM5_CARACT")
    Local _aTbPrior := {} // Tabela para constrolar a prioridade de cada status, Ex: se houver um descarte, esse vai ser o status final
    Local _nPosStat := 0
    Local _nStatAtu := 0
    Local _cStatNew := ''
    Local _nStatNew := 0
    Local _cStatMed := ''
    Local _lEmpty   := .F.
    Local _nI := 0
    
    If Empty(xValue)
        oModel:SetValue('ZM5DETAIL','ZM5_STATUS',"")
        oModel:SetValue('ZM4DETAIL','ZM4_STATUS',"")
        oView:Refresh('ZM4DETAIL')
        oView:Refresh('ZM5DETAIL')
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
    oModel:SetValue('ZM5DETAIL','ZM5_STATUS',_cStatMed)

    _nPosStat := aScan(_aTbPrior,{|x| x[1] == _cStatMed})
    _nStatNew := Min(_nStatAtu,_aTbPrior[_nPosStat,2])
    
    _nPosStat := aScan(_aTbPrior,{|x| x[2] == _nStatNew})
    _cStatNew := _aTbPrior[_nPosStat,1]
    
    // Primeiro, acima, verifico a característica do campo atual
    // se a medição tem prioridade 1, já sai fora e nem valida os outros campos
    If _nStatNew <> 1
        For _nI := 1 To oModelZM5:Length()
            _cStatMed := oModelZM5:GetValue("ZM5_STATUS",_nI)

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

    
    oView:Refresh('ZM5DETAIL')

    // Só atualiza o status do tanque se todas as análises tiverem sido feitas
    If !_lEmpty
        oModel:SetValue('ZM4DETAIL','ZM4_STATUS',_cStatNew)
        oView:Refresh('ZM4DETAIL')
    EndIf
Return



Static Function TudoOk(oModel)


	Local lRet			:= .T.
	Local oModelZM1	:= oModel:GetModel("MASTER")
	Local oModelZM4	:= oModel:GetModel("ZM4DETAIL")
	Local oModelZM5	:= oModel:GetModel("ZM5DETAIL")
    Local _cMsgErro := ''
    Local _cMsgSol := ''
    Local nI
    Local nX
    Local _cStatFim := FwFldGet('ZM1_SITQLD')
    Local _cNewStat := 'P'
    Local _lEmpty := .F.
    Local _nI
    Local _lAAval := .F.
    If _cStatFim == 'F'
        For nI := 1 To oModelZM4:Length()
            oModelZM4:SetLine(nI)
            If oModelZM4:GetValue("ZM4_STATUS",nI) <> 'V'
                For nX := 1 To oModelZM5:Length()
                    If Empty(oModelZM5:GetValue("ZM5_STATUS",nX)) 
                        lRet := .F.
                        _cCpoTit := oModelZM5:GetValue("ZM5_DESCR",nX)
                        
                        //"Não foi informado o valor de " + ALLTRIM(aHeaderQld[nY][1]) + " para o Tanque " + ALLTRIM(aColsQld[nI][GDFIELDPOS("ZM4_TANQUE", aHeaderQld)]) + ".", 
                        _cMsgErro 	:= "Não foi informado o valor de " + _cCpoTit + " para o Tanque " + ALLTRIM(oModelZM4:GetValue("ZM4_TANQUE",nI)) + "."
                        _cMsgSol	:= "Favor informar o valor do item pendente."
                        Exit
                    EndIf
                Next
            EndIf
            If !lRet
                Exit
            EndIf
        Next 
	EndIf

	If !lRet .And. ! Empty(_cMsgErro)
		oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
	EndIf

    
    If lRet 
        
        _lProt := .F.
        For _nI := 1 To oModelZM4:Length()
            If Empty(oModelZM4:GetValue("ZM4_STATUS",_nI))
                _lAAval := .T.
                Exit
            EndIf

            If oModelZM4:GetValue("ZM4_STATUS",_nI) == 'P'
               _lProt := .T.
            EndIf
        Next _nI

        If !_lProt .and. !_lAAval
            _cStatFim := 'F'
        EndIf
       
        For nI := 1 To oModelZM4:Length()
            If Empty(oModelZM4:GetValue("ZM4_STATUS",nI))
                _lEmpty := .T.
            ElseIf oModelZM4:GetValue("ZM4_STATUS",nI) == 'P'
                _lProt := .T.
            EndIf
        Next 

        If !_lEmpty
            _cNewStat := 'E'
        EndIf
        
        If _cNewStat == 'E' .AND. _cStatFim == 'F'
            _cNewStat := 'F'
        EndIf
        oModelZM1:LoadValue("ZM1_SITQLD",_cNewStat)

        RecLock('ZM1',.F.)
            ZM1->ZM1_SITQLD := _cNewStat 
            If _lProt
                ZM1->ZM1_STPROT := 'P' // Protocolo Pendente
            EndIf
        ZM1->(MsUnlock())

    EndIf


Return(lRet)

// Função responsável por limpar as medições caso o horário de pesagem seja limpo
User Function LTMOV9HR(oView, cIDView, cField, xValue)
    Local oModel := FWModelActive()
    Local oModelZM1	:= oModel:GetModel("MASTER")
    Local oModelZM4	:= oModel:GetModel("ZM4DETAIL")
	Local oModelZM5	:= oModel:GetModel("ZM5DETAIL")
    Local nI := 0
    Local _cNewStat := 'P'

    If Empty(xValue) .OR. xValue == '  :  '
        If MsgNoYes("Deseja remover os resultados de análise deste tanque?")
            For nI := 1 To oModelZM5:Length()
                oModelZM5:GoLine(nI)
                If !Empty(oModelZM5:GetValue('ZM5_VALOR'))
                    oModelZM5:SetValue('ZM5_VALOR', CriaVar('ZM5_VALOR'))
                EndIf

                If !Empty(oModelZM5:GetValue('ZM5_TEXTO'))
                    oModelZM5:SetValue('ZM5_TEXTO', CriaVar('ZM5_TEXTO'))
                EndIf
                oModelZM5:SetValue('ZM5_STATUS', "")
            Next
            oModelZM5:GoLine(1)
            oModelZM4:SetValue("ZM4_STATUS", "V")
        EndIf

        For nI := 1 To oModelZM4:Length()
            If !Empty(oModelZM4:GetValue("ZM4_STATUS",nI))
                _cNewStat := 'E'
            EndIf
        Next
        
        oModelZM1:LoadValue("ZM1_SITQLD",_cNewStat)

        oView:Refresh("MASTER")
        oView:Refresh("ZM4DETAIL")
        oView:Refresh("ZM5DETAIL")
    EndIf
Return

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
User Function LT009GAT( )
    Local oView  := FwViewActive()
    Local oModelZM5 := oView:oModel:GetModel("ZM5DETAIL")
    Local _nLine    := oModelZM5:GetLine()
    Local _cCaract  := oModelZM5:GetValue("ZM5_CARACT",_nLine)
    Local _xRet
    
    If IsInCallStack("U_LTMOV9HR")
        _xRet := Space(TamSx3("ZM5_DESCTX")[1])
    Else
        _xRet := Posicione('ZA4',1,xFilial('ZA4')+_cCaract+Upper(M->ZM5_TEXTO),'ZA4_DESCR')
    EndIf
    
Return ( _xRet )
// FIM da Funcao LT013GAT
//==============================================================================



// verifica se permite editar os campos
User Function LT009EDIT(x,_cCampo,z)
    Local _lRet := .T.
    Local oModel := FWModelActive()
    Local oView  := FwViewActive()
    Local oModelZM5 := oModel:GetModel("ZM5DETAIL")
    Local _cCaract := oModelZM5:GetValue("ZM5_CARACT")
    Local _aOpcoes := {}

    dbSelectArea('ZA3')
    ZA3->(dbSetOrder(1)) 
    ZA3->(dbGoTop())
    If ZA3->(dbSeek(xFilial('ZA3')+_cCaract))
        If AllTrim(_cCampo) == 'ZM5_TEXTO'
            _lRet := ZA3->ZA3_TIPO == 'T'
        Else
            _lRet := ZA3->ZA3_TIPO == 'N'
        EndIf
    EndIf
Return _lRet


User Function LT9FIN(_cSitQld)
    Local _lRet := .F.
    Local oModel := FWModelActive()
    Local oModelZM1	:= oModel:GetModel("MASTER")
    Local oModelZM4 := oModel:GetModel("ZM4DETAIL")
    Local _lProt    := .F.
    Local _lAAval   := .F.
    Local _cLib     := oModelZM1:GetValue("ZM1_LIBPRO")
    Local _nI       := 0
    Local _cMsgErro := ''
    Local _cMsgSol  := ''

    /* If _cSitQld == 'F' .AND. ZM1->ZM1_SITQLD <> 'F'
        oModel:SetErrorMessage(, , , , , "Operação não permitida!", "Para finalizar a pesagem, utilize a opção Fechar no Menu!", , )
        Return .F.
    EndIf */

    If _cSitQld <> 'F'
        If ZM1->ZM1_SITQLD == 'F'
            If !(RetCodUsr() $ GetMv("MX_LT012Q"))
                MsgAlert("Usuário sem acesso a essa operação! (MX_LT012Q) (operação A)")
                Return .F.
            EndIf
        EndIf
        // Valido se status não estava como finalizado e foi alterado para 
        Return .T.
    EndIf

    If !Empty(oModelZM1:GetValue("ZM1_IDPROT"))
        If !(RetCodUsr() $ GetMv("MX_LT012Q"))
            MsgAlert("Usuário sem acesso a essa operação! (MX_LT012Q) (operação B)")
            Return .F.
        EndIf
        Return .T.
    EndIf

    For _nI := 1 To oModelZM4:Length()
        If Empty(oModelZM4:GetValue("ZM4_STATUS",_nI))
            _lAAval := .T.
            Exit
        EndIf

        If oModelZM4:GetValue("ZM4_STATUS",_nI) == 'P'
            _lProt := .T.
        EndIf
    Next _nI

    If _lAAval
        _lRet := .F.
        _cMsgErro 	:= "Não é permitido finalizar uma pesagem cujos tanques ainda não tenham sido analisados."
        _cMsgSol	:= "Favor realizar as análises de todos os tanques."
    ElseIf _lProt //.AND. Empty(_cLib)
        If !(RetCodUsr() $ GetMv("MX_LT012Q"))
            MsgAlert("Usuário sem acesso a essa operação! (MX_LT012Q) (operação C)")
            Return .F.
        EndIf
    
        /* If MsgYesNo("Atenção! Essa pesagem precisa que seja aberto Protocolo. Confirma a mudança de Status da Análise para Finalizada?")
            oModelZM1:LoadValue("ZM1_LIBPRO",'S')
        Else
            _lRet := .F.
        EndIf */
    EndIf

    
	If !_lRet .And. ! Empty(_cMsgErro)
		oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
	EndIf

Return _lRet

User Function LT9FIN2()
    Local _cSitQld := ZM1->ZM1_SITQLD
    Local _lRet := .F.
    Local _lProt    := .F.
    Local _lAAval   := .F.
    Local _cLib     := ZM1->ZM1_LIBPRO
    Local _nI       := 0
    Local _cMsgErro := ''
    Local _cMsgSol  := ''

    /* If _cSitQld <> 'F'
        Return 
    EndIf */

    If !(RetCodUsr() $ GetMv("MX_LT012Q"))
        MsgAlert("Usuário sem acesso a essa operação! (MX_LT012Q)")
        Return
    EndIf

    If ZM1->ZM1_IDPROT == 'S'
        Return 
    EndIf

    dbSelectArea("ZM4")
    ZM4->(dbSetOrder(1))
    ZM4->(dbGoTop())
    If ZM4->(dbSeek(xFilial("ZM4")+ZM1->ZM1_NUM))
        If ZM4->ZM4_STATUS
            _lAAval := .T.
        EndIf

        If ZM4->ZM4_STATUS == 'P'
            _lProt := .T.
        EndIf
    Else
        _lAAval := .T.
    EndIf

    If _lAAval
        MsgAlert("Não será possível liberar o descarregamento, pois as análises de qualidade ainda não foram feitas!")
        Return
    ElseIf _lProt .AND. _cLib <> "S"
        If MsgYesNo("Atenção! Essa pesagem precisa que seja aberto Protocolo. Confirma a Liberação do Descarregamento?")
            RecLock("ZM1",.F.)
                ZM1->ZM1_LIBPRO := 'S'
                ZM1->ZM1_SITQLD := 'F'
            ZM1->(MsUnlock())
        EndIf
    EndIf

Return
 