#INCLUDE 'PROTHEUS.CH'
#Include 'FWMVCDef.ch'

Static C_STAT_PENDENTE 	    := '1'
Static C_STAT_APROVADO 	    := '2'
Static C_STAT_FINALIZADO 	:= '3'
Static C_STAT_REJEITADO 	:= '9'
Static C_STAT_RENEGOCIADO   := 'R'

//============================================================================\
/*/{Protheus.doc}LTBFIN01
  ==============================================================================
    @description
    Programa para antecipação de pagamento aos produtores, controlando o 
    recebimento com taxa de juros

    OBS: Os juros são cobrados em sua totalidade na primeira parcela

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 29/09/2020

/*/
//============================================================================\
User Function LTBFIN01(  )
    Local oBrowse    := Nil
	Private aRotina := Menudef()
    Private _lReneg := .F.

    SetKey (VK_F12,{|a,b| AcessaPerg("FIN080",.T.)})
	
    oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZAK")
	oBrowse:SetDescription('Antecipação a Fornecedores')

    
	oBrowse:AddLegend( "ZAK->ZAK_STATUS == '"+C_STAT_PENDENTE+"' .AND. EMPTY(ZAK->ZAK_DTAPR1) .AND. EMPTY(ZAK->ZAK_DTAPR2)"		, "GREEN"	,	"Pendente de Aprovação" )
    oBrowse:AddLegend( "ZAK->ZAK_STATUS == '"+C_STAT_PENDENTE+"' .AND. EMPTY(ZAK->ZAK_DTAPR1) .AND. !EMPTY(ZAK->ZAK_DTAPR2)"		, "BLUE"	,	"A Aprovar Financeiro" )
    oBrowse:AddLegend( "ZAK->ZAK_STATUS == '"+C_STAT_PENDENTE+"' .AND. !EMPTY(ZAK->ZAK_DTAPR1) .AND. EMPTY(ZAK->ZAK_DTAPR2)"		, "YELLOW"	,	"A Aprovar Fomento" )
    oBrowse:AddLegend( "ZAK->ZAK_STATUS == '"+C_STAT_APROVADO+"' "		, "RED"	,	"Aprovado" )
    oBrowse:AddLegend( "ZAK->ZAK_STATUS == '"+C_STAT_FINALIZADO+"' "		, "GRAY"	,	"Empréstimo Efetuado / Financeiro Integrado" )
    oBrowse:AddLegend( "ZAK->ZAK_STATUS == '"+C_STAT_RENEGOCIADO+"' "		, "F12_MARR"	,	"Empréstimo Renegociado" )
    oBrowse:AddLegend( "ZAK->ZAK_STATUS == '9' "		, "BLACK"	,	"Empréstimo Rejeitado" )

	oBrowse:Activate()

Return (  )
// FIM da Funcao LTBFIN01
//==============================================================================


Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Incluir'          ACTION 'U_LTB01INC'         OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Aprovar'          ACTION 'U_LTB01APR'         OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar CP/CR'      ACTION 'U_LTB01BX'          OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE 'Excl. Baixa'      ACTION 'U_LTB01EXC'         OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Impr.Contrato'    ACTION 'U_LTBFIN03'         OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.LTBFIN01'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'          ACTION 'VIEWDEF.LTBFIN01'   OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'          ACTION 'VIEWDEF.LTBFIN01'   OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Rejeitar'         ACTION 'U_LTB01REJ'         OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Renegociação'     ACTION 'U_LTB01REN'         OPERATION 4 ACCESS 0

Return aRotina

//============================================================================\
/*/{Protheus.doc}LTB01INC
  ==============================================================================
    @description
    Chama operação de inclusão

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 27/01/2021

/*/
//============================================================================\
User Function LTB01INC(  )
    _lReneg := .F.

Return FWExecView(,'LTBFIN01', MODEL_OPERATION_INSERT, , { || .T. }, , , )
// FIM da Funcao LTB01INC
//==============================================================================

//============================================================================\
/*/{Protheus.doc}LTB01INC
  ==============================================================================
    @description
    Chama operação de renegociação

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 27/01/2021

/*/
//============================================================================\
User Function LTB01REN(  )
    Local _nJurDesc     := 0 // Juros pagos na primeira parcela a serem descontados na renegociação
    Local _lPrimPaga    := .F. // Primeira parcela já foi paga -- Na primeira parcela é pago o juro de todas as demais
    Local _lNenhuma     := .T. // Nenhuma parcela foi paga, então pega valor do contrato original, evitando diferenças de arredondamento nas somas
    Local _lPode        := .F. // Indica se pode renegociar, precisa ter alguma parcela não recebida do empréstimo original
    Private _nSaldoCR     := 0 // Soma o Saldo das Parcelas do CR
    Private _nPagoCR      := 0 // Soma das Parcelas Pagas do CR
    Private _nJurosAnt      := 0 // Juros antecipados na primeira parcela das parcelas ainda não pagas
    Private _nSldCrJr       := 0 // 
    Private _cParcRen     := '' // Parcelas que estão sendo renegociadas
    _lReneg := .T.


    If ZAK->ZAK_STATUS <> C_STAT_FINALIZADO
        HELP(' ',1,'Status do Empréstimo' ,,'O Status Atual do Empréstimo não permite essa operação',2,0,,,,,,;
                     {'Somente empréstimos com o status Efetuado podem ser renegociados!'})
        Return
    EndIf

    dbSelectArea('SE1')
    SE1->(dbSetOrder(1)) 
    SE1->(dbGoTop())
    
    dbSelectArea('ZAL')
    ZAL->(dbSetOrder(1)) 
    ZAL->(dbGoTop())
    If ZAL->(dbSeek(ZAK->ZAK_FILIAL+ZAK->ZAK_NUM+ZAK->ZAK_VERSAO))
        While ZAL->(!Eof()) .AND. ZAL->ZAL_FILIAL+ZAL->ZAL_NUM+ZAL->ZAL_VERSAO == ZAK->ZAK_FILIAL+ZAK->ZAK_NUM+ZAK->ZAK_VERSAO
            //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA
            If SE1->(dbSeek(ZAK->(ZAK_FILIAL+ZAK_PREF+ZAK_NUM)+ZAL->ZAL_PARC+ZAK->ZAK_TIPO))
                If SE1->E1_SALDO > 0
                    _lPode      := .T.
                    _nSaldoCR   += ZAL->ZAL_VLPARC - ZAL->ZAL_VLRJUR
                    _nSldCrJr   += ZAL->ZAL_VLPARC
                    _nJurosAnt  += ZAL->ZAL_VLRJUR
                    _cParcRen   += ZAL->ZAL_PARC + ';'
                Else
                    _nPagoCR    += ZAL->ZAL_VLPARC
                    _lNenhuma   := .F. // Se alguma parcela já foi paga
                EndIf
            EndIf        
            
            
            ZAL->(DbSkip())
        EndDo
    EndIf

    If _lNenhuma
        _nSaldoCR := ZAK->ZAK_VALOR
    EndIf

Return FWExecView('Renegociação de Empréstimos','LTBFIN01', MODEL_OPERATION_INSERT, , { || .T. }, , , )
// FIM da Funcao LTB01INC




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
	Local oStr1     := FWFormStruct(1,'ZAK')
	Local oStr2     := FWFormStruct(1,'ZAL')
    
    Local bTudoOk   := {|oModel| TudoOk(oModel) }
    Local bVldGrv  := {|oModel| LTB001GRV(oModel)}


    //oStr1:AddField( "Cons.NFs Produtor", "Consulta NFs Produtor", "DIGBOTAOOK", 'BT', 1, 0, /*{|oFW, cId, xValue| U_IExpDQtd(oFW, cId, xValue) }*/ )
	
	oModel := MPFormModel():New('mLTBFIN01',,bTudoOk,bVldGrv)


	oModel:SetDescription('Antecipação de Pagamento a Fornecedores')
	
	//oStr2:SetProperty('ZRK_COD',MODEL_FIELD_OBRIGAT,.F.)
	//oStr1:RemoveField( 'ZRK_DDE' )


    oModel:addFields('MASTER',,oStr1) 
	oModel:SetPrimaryKey({ 'ZAK_FILIAL', 'ZAK_NUM', 'ZAK_VERSAO' })

	oModel:addGrid('ZALDETAIL','MASTER',oStr2)
	oModel:getModel('ZALDETAIL'):SetDescription('Parcelas a Receber')
	oModel:GetModel('ZALDETAIL'):SetUniqueLine( { 'ZAL_FILIAL','ZAL_NUM','ZAL_NUM', 'ZAL_PARC' } )
	oModel:SetRelation('ZALDETAIL', { { 'ZAL_FILIAL', "FwXFilial('ZAL')" },{ 'ZAL_NUM', "ZAK_NUM" },{ 'ZAL_VERSAO', "ZAK_VERSAO" } }, ZAL->(IndexKey(1)) )
	
    oModel:SetVldActivate({|oModel|LTB01PRE(oModel)})

    oStr1:SetProperty("ZAK_METODO",MODEL_FIELD_VALID,{|x,y,z| VldMetodo(x,y,z)})
    oStr2:SetProperty("ZAL_VENCTO",MODEL_FIELD_VALID,{|x,y,z| VldVencto(x,y,z)})

    // Se for renegociação, força o preenchimento do campo motivo
    If _lReneg
	    oStr1:SetProperty("ZAK_MOTIVO",MODEL_FIELD_OBRIGAT,.T.) 
    EndIf
    
    //oModel:GetModel('MASTER'):SetOnlyQuery(.T.)
    //oModel:getModel('MASTER'):SetOptional(.T.)

	
	oModel:InstallEvent("WFEmprest", /*cOwner*/, WFEmprest():New())


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
	Local oStr1:= FWFormStruct(2, 'ZAK')
	Local oStr2:= FWFormStruct(2, 'ZAL')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'MASTER' )
	oView:AddGrid('FORM2' , oStr2,'ZALDETAIL')  
	
	

    oView:CreateHorizontalBox( 'BOXSUPERIOR', 50)
    //oStr1:SetProperty('ZAK_CODIGO',MVC_VIEW_CANCHANGE,.F.)
    oStr2:RemoveField( 'ZAL_NUM' )
    oStr2:RemoveField( 'ZAL_VERSAO' )
	
	oView:CreateHorizontalBox( 'BOXINFERIOR', 50)
	
	oView:SetOwnerView('FORM2','BOXINFERIOR')
	oView:SetOwnerView('FORM1','BOXSUPERIOR')
    oView:AddIncrementField('FORM2', 'ZAL_PARC')
	oView:EnableTitleView('FORM2' , 'Parcelas a Receber' ) 


	oView:SetFieldAction('ZAK_VALOR', 	{ |oView, cIDView, cField, xValue| U_LTBPARC(oView, cIDView, cField, xValue) } )
    oView:SetFieldAction('ZAK_JUROS', 	{ |oView, cIDView, cField, xValue| U_LTBPARC(oView, cIDView, cField, xValue) } )
    oView:SetFieldAction('ZAK_PARC', 	{ |oView, cIDView, cField, xValue| U_LTBPARC(oView, cIDView, cField, xValue) } )
    oView:SetFieldAction('ZAK_DTPRIM', 	{ |oView, cIDView, cField, xValue| U_LTBPARC(oView, cIDView, cField, xValue) } )
    oView:SetFieldAction('ZAK_DTPGTO', 	{ |oView, cIDView, cField, xValue| U_LTBPARC(oView, cIDView, cField, xValue) } )
    oView:SetFieldAction('ZAL_VENCTO', 	{ |oView, cIDView, cField, xValue| U_LTB01REC(oView, cIDView, cField, xValue) } )

    oStr1:AddGroup( 'GRUPO01', 'Produtor'           , '', 1 )
    oStr1:AddGroup( 'GRUPO02', 'Empréstimo'         , '', 2 )
    oStr1:AddGroup( 'GRUPO03', 'Contábil'           , '', 4 )
    
    oStr1:SetProperty('ZAK_NUM'     , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
    oStr1:SetProperty('ZAK_VERSAO'  , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
    oStr1:SetProperty('ZAK_FORN'    , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
    oStr1:SetProperty('ZAK_LOJA'    , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
    oStr1:SetProperty('ZAK_NOME'    , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
    oStr1:SetProperty('ZAK_COND'    , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

    oStr1:SetProperty('ZAK_METODO'  , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZAK_VALOR'   , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZAK_JUROS'   , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZAK_PARC'    , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZAK_DTPGTO'  , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
    oStr1:SetProperty('ZAK_DTPRIM'  , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )

    oStr1:SetProperty('ZAK_CONTA'   , MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
    oStr1:SetProperty('ZAK_CC'      , MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )


    // Se for renegociação, desabilita a alteração de alguns campos
    If _lReneg
        oStr1:AddGroup( 'GRUPO04', 'Renegociação'        , '', 3 )
        oStr1:SetProperty('ZAK_VALOR'   ,MVC_VIEW_CANCHANGE ,.F.)
        oStr1:SetProperty('ZAK_FORN'    ,MVC_VIEW_CANCHANGE ,.F.)
        oStr1:SetProperty('ZAK_LOJA'    ,MVC_VIEW_CANCHANGE ,.F.)
        oStr1:SetProperty('ZAK_DTPGTO'  ,MVC_VIEW_CANCHANGE ,.F.)
        oStr1:SetProperty('ZAK_MOTIVO'  ,MVC_VIEW_FOLDER_NUMBER, '1')
        oStr1:SetProperty('ZAK_MOTIVO'  , MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
    
    Else
        oStr1:SetProperty('ZAK_MOTIVO'  ,MVC_VIEW_CANCHANGE ,.F.)
    EndIf




    //oStr1:AddField( "DIGBOTAOOK"	, "99", "Cons.NFs Produtor", "Consulta NFs Produtor", /*Help*/, "BT" )
    //oView:SetFieldAction( 'DIGBOTAOOK', { |oView, cIDView, cField, xValue| ViewNfs(oView, cIDView, cField, xValue ) } )
	oView:AddUserButton('Consulta NFS Produtor','',{|| ViewNfs()},,,{MODEL_OPERATION_VIEW,MODEL_OPERATION_INSERT,MODEL_OPERATION_UPDATE,MODEL_OPERATION_DELETE})


    // Realiza carga inicial dos dados em caso de renegociação
    oView:SetAfterViewActivate({|oView| LoadReneg(oView) })
Return oView

//============================================================================\
/*/{Protheus.doc}LTBPARC
  ==============================================================================
    @description
    Calcula as parcelas a Receber e preenche o grid

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 29/09/2020

/*/
//============================================================================\
User Function LTBPARC( oView, cIDView, cField, xValue )
    Local oModel	:= FWModelActive()
	Local oModelZAL := oModel:GetModel('ZALDETAIL')
    Local _cMetodo  := FwFldGet('ZAK_METODO')
    Local _nValor   := IIF(AllTrim(cField)=="ZAK_VALOR",xValue,FwFldGet('ZAK_VALOR'))
    Local _nParc    := IIF(AllTrim(cField)=="ZAK_PARC",xValue,FwFldGet('ZAK_PARC'))
    Local _nTxJur   := IIF(AllTrim(cField)=="ZAK_JUROS",xValue,FwFldGet('ZAK_JUROS'))
    Local _dDtPrim  := IIF(AllTrim(cField)=="ZAK_DTPRIM",xValue,FwFldGet('ZAK_DTPRIM'))
    Local _dDtLib   := IIF(AllTrim(cField)=="ZAK_DTPGTO",xValue,FwFldGet('ZAK_DTPGTO'))
    Local _aParcel  := {}
    Local _nAmort   := 0 // Valor da parcela a amortizar do empréstimo. #sem juros#
    Local _nJurMes  := 0 // Valor do juro mensal
    Local _nLen     := 0
    Local nI ,nX       := 0
    Local _nSldAmort:= 0
    Local _nTotJur  := 0
    Local _dParcAnt
    Local _cCond    := ''
    Local _nParcCond:= 1
    Local _aVenctos := {}
    Local _aCond    := {}
    Local _cCond    := Posicione('SA2',1,xFilial('SA2')+FwFldGet('ZAK_FORN')+FwFldGet('ZAK_LOJA'),'A2_COND')
    
    If Empty(_cMetodo)
        MsgAlert("Preencher o campo Método de Cálculo antes de prosseguir com os demais campos!")
        Return
    EndIf

    // Se ainda não tiver preenchido alguma das informações necessárias para cálculo das parcelas, não executa o restante da função
    If Empty(_nValor) .OR. Empty(_nParc) .OR. Empty(_nTxJur) .OR. Empty(_dDtPrim) .OR. Empty(_dDtLib)
        Return
    EndIf

    If _dDtPrim < _dDtLib
        MsgAlert("Data da primeira parcela não pode ser menor que a data de pagamento do empréstimo!")
        Return
    EndIf

    If _cMetodo == 'C'
        _aCond := Condicao(_nValor,_cCond,,_dDtPrim-1)
        For nI := 1 To _nParc
            For nX := 1 To Len(_aCond)
                aAdd(_aVenctos,MonthSum(_aCond[nX,1],nI-1))
            Next nX
        Next nI
    Else
        For nI := 1 To _nParc
            aAdd(_aVenctos,MonthSum(_dDtPrim,nI-1))
        Next nI
    EndIf

    _nParc := Len(_aVenctos)

    _nAmort :=  _nValor / _nParc
    
    _nSldAmort := _nValor

    For nI := 1 To LeN(_aVenctos)
        // 20210127
        // Tratativa para jogar o vencimento sempre no mesmo dia e para possibilitar
        // o cálculo das parcelas de acordo com a cond. pgto do fornecedor
            
        _dParcAnt := IIF(nI==1,_dDtLib,_dDtVcto)
        _dDtVcto := _aVenctos[nI]
        _nJuros   := _nTxJur / 30 * (_dDtVcto-_dParcAnt)
        _nDias  := _dDtVcto-_dParcAnt
        
       /*  If nI == 1
            _nJuros := _nTxJur / 30 * (_dDtPrim-_dDtLib)
            _nDias  := _dDtPrim-_dDtLib
            _dDtVcto := _dDtPrim
        Else
            _nJuros   := _nTxJur
            _nDias  := 30
            _dDtVcto := _dDtVcto+_nDias
        EndIf */

        _nJurMes    := _nSldAmort * _nJuros / 100
        _nSldAmort  := _nSldAmort - _nAmort
        aAdd(_aParcel,{_dDtVcto, _nAmort, _nJurMes, _nSldAmort,_nJuros,_nDias})
    Next nI
    

    // Atualizo o valor da primeira parcela, pois os juros são cobrados exclusivamente nela
    For nI := 1 To Len(_aParcel)
        _nTotJur += _aParcel[nI,3]
    Next nI
    _aParcel[1,2] += _nTotJur


    For nI := 1 To Len(_aParcel)
        // Se já existir linha no grid, apenas verifica se está deletada e faz o undelet
        If oModelZAL:Length() >= nI
            oModelZAL:SetLine(nI)
            If oModelZAL:IsDeleted()
                oModelZAL:UnDeleteLine()
            EndIf

        // Senão, add uma linha nova
        Else
            _nLen := oModelZAL:Length()
			If ! oModelZAL:AddLine() == _nLen + 1
				oView:ShowLastError()
				Return
			EndIf
        EndIf

        //aAdd(_aParcel,{_dDtVcto, _nAmort, _nJurMes, _nSldAmort,_nJuros,_nDias})
		oModelZAL:SetValue('ZAL_PARC'   , StrZero(nI,3) )
        oModelZAL:SetValue('ZAL_VENCTO' , _aParcel[nI,1] )
        oModelZAL:SetValue('ZAL_DIAS'   , _aParcel[nI,6] )
        oModelZAL:SetValue('ZAL_JUROS'  , _aParcel[nI,5] )
        oModelZAL:SetValue('ZAL_PRINC'  , _nAmort )
        oModelZAL:SetValue('ZAL_VLRJUR' , _aParcel[nI,3] )
        oModelZAL:SetValue('ZAL_VLPARC' , _aParcel[nI,2] )
        oModelZAL:SetValue('ZAL_SLDAMO' , _aParcel[nI,4] )
        
    Next nI

    // Se no grid houver mais linhas que o número de parcelas, deleta as linhas adicionais
    If oModelZAL:Length() > Len(_aParcel)
        For nI := Len(_aParcel)+1 To oModelZAL:Length()
            oModelZAL:SetLine(nI)
            If !oModelZAL:IsDeleted()
                oModelZAL:DeleteLine()
            EndIf
        Next nI
    EndIf
       
    oModelZAL:SetLine(1)
	oView:RefreSh('ZALDETAIL')

Return ( Nil )
// FIM da Funcao LTBPARC
//==============================================================================


Static Function LTB01PRE(oModel)
	Local _lRet  	    := .T.
	Local lInclui		:= oModel:GetOperation() == MODEL_OPERATION_INSERT
	Local lAltera		:= oModel:GetOperation() == MODEL_OPERATION_UPDATE
	Local lExclui		:= oModel:GetOperation() == MODEL_OPERATION_DELETE
	Local oModelZAK		:= oModel:GetModel("MASTER")
	Local oModelZAL		:= oModel:GetModel("ZALDETAIL")
    Local _cMsgErro     := ''
    Local _cMsgSol      := ''
    Local _lAprFin      := RetCodUsr() $ GetMv("MX_APRFIN")
    Local _lAprFom      := RetCodUsr() $ GetMv("MX_APRFOM")



    If lExclui .AND. ZAK->ZAK_STATUS $ C_STAT_FINALIZADO+C_STAT_RENEGOCIADO .AND. _lRet
        _cMsgErro   := 'Atenção! Não é permitido excluir Empréstimos com o Status atual!'
        _cMsgSol    := 'Para excluir este Empréstimo, primeiro é necessário excluir a baixa do mesmo.'
        _lRet       := .F.
    EndIf

    If lExclui .AND. ZAK->ZAK_STATUS == '9' .AND. _lRet
        _cMsgErro   := 'Atenção! Não é permitido excluir Empréstimos Rejeitados!'
        _cMsgSol    := ''
        _lRet       := .F.
    EndIf

    
	 If lAltera .And. (!Empty(ZAK->ZAK_DTAPR1) .OR. !Empty(ZAK->ZAK_DTAPR2)) .AND. _lRet 
        // Validação removida em 29/01/21 por Djonata, a pedido dos usuários
        // adicionado opção que, se um empréstimo já aprovado venha a ser alterado, ele voltará ao status inicial
        // precisando passar por novas aprovações
        /*If !_lAprFin .AND. !_lAprFom
            _cMsgErro   := 'Atenção! Já houve ao menos uma aprovação para este empréstimo. Somente os Gerentes Financeiro e de Fomento podem fazer alterações, desde que ainda não tenham sido feitas as duas aprovações!'
            _cMsgSol    := 'Solicite a alteração aos Gerentes citados acima, ou faça a exclusão do empréstimo.'
            _lRet       := .F.
        EndIf*/
        _cMsgUpd   := 'Atenção! Esse empréstimo já foi aprovado por pelo menos um dos gestores. Se for alterado, a aprovação será estornada, fazendo-se necessário a análise dos gestores novamente.';
                        + chr(10) + chr(13) + 'Deseja prosseguir com a alteração?'
        
        _lRet       := MsgYesNo(_cMsgUpd)

        If !_lRet
            _cMsgErro   := 'Processo cancelado!'
            _cMsgSol    := ''
        EndIf
	EndIf 

    If !_lRet .And. ! Empty(_cMsgErro)
		oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
	EndIf

Return _lRet




//============================================================================\
/*/{Protheus.doc} LTB01APR
  ==============================================================================
    @description
    Efetua aprovação do Empréstimo por parte dos usuários autorizados

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 29/09/2020

/*/
//============================================================================\
User Function  LTB01APR()
    Local _lAprFin      := RetCodUsr() $ GetMv("MX_APRFIN")
    Local _lAprFom      := RetCodUsr() $ GetMv("MX_APRFOM")
    Local _cPerg        := "Confirma a aprovação por parte do " + IIf(_lAprFin,'Financeiro','Fomento') + " para este Empréstimo?"
    Local _cNum         := ZAK->ZAK_NUM
    Local _cNome        := ZAK->ZAK_NOME
    Local _cValor       := "R$ " + AllTrim(Transform(ZAK->ZAK_VALOR,"@E 999,999,999.99"))
    Local _cJuros       := AllTrim(Transform(ZAK->ZAK_JUROS,"@E 999.99")) + "%"
    Local _cParc        := cValToChar(ZAK->ZAK_PARC)
    Local _cDtPgto      := dToC(ZAK->ZAK_DTPGTO)

    _cPerg += chr(10) + chr(13) +  chr(10) + chr(13) + "Não será possível desfazer esta operação sem realizar a exclusão do Empréstimo após a sua aprovação!"
    
    If !_lAprFin .AND. !_lAprFom
        MsgAlert("Usuário sem permissão para realizar esta operação!")
        Return
    EndIf

    If ZAK->ZAK_STATUS <> C_STAT_PENDENTE
        MsgAlert("O Status deste Empréstimo não permite esta operação!")
        Return
    EndIf

    FWExecView('Aprovação de Empréstimos a Fornecedores','LTBFIN01', MODEL_OPERATION_VIEW, , { || .T. }, , , )
    If MsgNoYes(_cPerg,"Aprovação de Empréstimos a Fornecedores")
        RecLock('ZAK',.F.)
            If _lAprFin
                ZAK->ZAK_DTAPR1 := dDataBase 
            EndIf
            
            If _lAprFom 
                ZAK->ZAK_DTAPR2 := dDataBase 
            EndIf

            If !Empty(ZAK->ZAK_DTAPR1) .AND. !Empty(ZAK->ZAK_DTAPR2)
                ZAK->ZAK_STATUS := C_STAT_APROVADO

                U_WfEmprest(10, _cNum, _cNome, _cValor, _cJuros, _cParc, _cDtPgto)

            EndIf
        
        ZAK->(MsUnlock())

        
    EndIf


Return ( Nil )
// FIM da Funcao  LTB01APR
//==============================================================================

//============================================================================\
/*/{Protheus.doc} LTB01REJ
  ==============================================================================
    @description
    Efetua Rejeição do Empréstimo por parte dos usuários autorizados

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 29/09/2020

/*/
//============================================================================\
User Function  LTB01REJ()
    Local _lAprFin      := RetCodUsr() $ GetMv("MX_APRFIN")
    Local _lAprFom      := RetCodUsr() $ GetMv("MX_APRFOM")
    Local _cPerg        := "Confirma a Rejeição deste Empréstimo?"
    Local _cNum         := ZAK->ZAK_NUM
    Local _cNome        := ZAK->ZAK_NOME
    Local _cValor       := "R$ " + AllTrim(Transform(ZAK->ZAK_VALOR,"@E 999,999,999.99"))
    Local _cJuros       := AllTrim(Transform(ZAK->ZAK_JUROS,"@E 999.99")) + "%"
    Local _cParc        := cValToChar(ZAK->ZAK_PARC)
    Local _cDtPgto      := dToC(ZAK->ZAK_DTPGTO)

    _cPerg += chr(10) + chr(13) +  chr(10) + chr(13) + "Não será possível desfazer esta operação!"
    
    If !_lAprFin .AND. !_lAprFom
        MsgAlert("Usuário sem permissão para realizar esta operação!")
        Return
    EndIf

    If ZAK->ZAK_STATUS <> C_STAT_PENDENTE
        MsgAlert("O Status deste Empréstimo não permite esta operação!")
        Return
    EndIf

    FWExecView('Rejeição de Empréstimos a Fornecedores','LTBFIN01', MODEL_OPERATION_VIEW, , { || .T. }, , , ) 
    If MsgNoYes(_cPerg,"Rejeição de Empréstimos a Fornecedores")
        RecLock('ZAK',.F.)
            If _lAprFin .OR. _lAprFom
                ZAK->ZAK_DTAPR1 := dDataBase 
                ZAK->ZAK_DTAPR2 := dDataBase 
            EndIf
            
            If !Empty(ZAK->ZAK_DTAPR1) .AND. !Empty(ZAK->ZAK_DTAPR2)
                ZAK->ZAK_STATUS := '9'
                U_WfEmprest(11, _cNum, _cNome, _cValor, _cJuros, _cParc, _cDtPgto)
            EndIf
        ZAK->(MsUnlock())

    EndIf
    

Return ( Nil )
// FIM da Funcao  LTB01REJ
//==============================================================================



Static Function TudoOk( oModel )

	Local _lRet		:= .T.
	Local oModelZAK	:= oModel:GetModel('MASTER')
	Local oModelZAL := oModel:GetModel('ZALDETAIL')
	Local _cMsgErro := ''
    Local _cMsgSol  := ''


    If oModel:GetOperation() == MODEL_OPERATION_DELETE .AND. ZAK->ZAK_STATUS == C_STAT_FINALIZADO .AND. _lRet
        _cMsgErro   := 'Atenção! Não é permitido excluir Empréstimos com o Status atual!'
        _cMsgSol    := 'Para excluir este Empréstimo, primeiro é necessário excluir a baixa do mesmo.'
        oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
        _lRet       := .F.
    EndIf

    If oModel:GetOperation() == MODEL_OPERATION_DELETE .AND. ZAK->ZAK_STATUS == '9' .AND. _lRet
        _cMsgErro   := 'Atenção! Não é permitido excluir Empréstimos Rejeitados!'
        _cMsgSol    := ''
        oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
        _lRet       := .F.
    EndIf

Return _lRet


// Realiza a inclusão do Contas a Pagar, a Baixa do CP, e a Inclusão das parcelas a receber no CR
User Function LTB01BX()
    Local _aFina050 := {}
    Local _aFina040 := {}
    Local _aFina070 := {}
    Local _Ret080   := {}
    Local _cCgc     := Posicione('SA2',1,xFilial('SA2')+ZAK->ZAK_FORN+ZAK->ZAK_LOJA,'A2_CGC')
    Local _lReneg   := ZAK->ZAK_VERSAO > '001'
    Local _cVerAnt  := ZAK->ZAK_VERANT
    Local _cMsgPerg := ''
    Local _cMotBx   := 'DAC'
    Local _cHistor  := 'EMPRÉSTIMO RENEGOCIADO'
    Private  nTamLote   := TamSX3("E2_LOTE")[1]
    Private lMsErroAuto := .F.
    Private LFINI055    := .F.
    
    If ZAK->ZAK_STATUS <> C_STAT_APROVADO
        MsgAlert("Atenção! O Status atual do Empréstimo não permite esta operação!")
        Return
    EndIf
    

    dbSelectArea('SA1')
    SA1->(dbSetOrder(3)) 
    SA1->(dbGoTop())
    If !SA1->(dbSeek(xFilial('SA1')+_cCgc))
        MsgAlert("Atenção! Não existe Cliente cadastrado equivalente a este Fornecedor, portanto, não será possível incluir os títulos a receber...")
        Return
    EndIf

    If _lReneg
        _cMsgPerg := 'Confirma geração dos títulos a receber da renegociação no Financeiro?'
    Else
        _cMsgPerg := 'Confirma geração dos títulos a pagar e a receber no Financeiro?'
    EndIf 
    
    If !MsgNoYes(_cMsgPerg,"Geração de Títulos do Empréstimo")
        Return
    EndIf
    
    Begin Transaction

    /*Inclusão dos títulos a receber*/

    dbSelectArea('ZAL')
    ZAL->(dbSetOrder(1)) 
    ZAL->(dbGoTop()) 
    If ZAL->(dbSeek(xFilial('ZAL')+ZAK->ZAK_NUM+ZAK->ZAK_VERSAO))
        While ZAL->(!Eof()) .And. ZAL->ZAL_FILIAL+ZAL->ZAL_NUM+ZAL->ZAL_VERSAO == xFilial('ZAL')+ZAK->ZAK_NUM+ZAK->ZAK_VERSAO
            _aFina040 := {  { "E1_FILIAL"   , ZAK->ZAK_FILIAL                         , NIL },;
                            { "E1_PREFIXO"  , ZAK->ZAK_PREF                         , NIL },;
                            { "E1_NUM"      , ZAK->ZAK_NUM                          , NIL },;
                            { "E1_TIPO"     , ZAK->ZAK_TIPO                         , NIL },;
                            { "E1_NATUREZ"  , ZAK->ZAK_NATCR                        , NIL },;
                            { "E1_CLIENTE"  , SA1->A1_COD                           , NIL },;
                            { "E1_LOJA"     , SA1->A1_LOJA                          , NIL },;
                            { "E1_EMISSAO"  , ZAK->ZAK_EMISSA                       , NIL },;
                            { "E1_PARCELA"  , ZAL->ZAL_PARC                         , NIL },;
                            { "E1_VENCTO"   , ZAL->ZAL_VENCTO                       , NIL },;
                            { "E1_VENCREA"  , DataValida(ZAL->ZAL_VENCTO,.T.)       , NIL },;
                            { "E1_ACRESC"   , ZAL->ZAL_VLPARC - ZAL->ZAL_PRINC      , NIL },;
                            { "E1_VLCRUZ"   , ZAL->ZAL_PRINC                        , NIL },;
                            { "E1_MOEDA"    , 1                                     , NIL },;
                            { "E1_DEBITO"   , ""                                    , NIL },;
                            { "E1_CCD"      , ZAK->ZAK_CC                           , NIL },;
                            { "E1_VALOR"    , ZAL->ZAL_PRINC                        , NIL }}


            MsExecAuto( { |x,y| FINA040(x,y)} , _aFina040, 3)
            
            If lMsErroAuto
                DisarmTransaction()
                MsgAlert("Atenção, não foi possível incluir o(s) título(s) a receber do empréstimo. Verifique a mensagem a seguir com apoio do administrador do sistema!")
                MostraErro()
                Return
            EndIf
            
            ZAL->(DbSkip())
        EndDo
       
    EndIf

    
    /*Fim Inclusão CR*/

    /* Baixa por dação dos títulos a receber do empréstimo renegociado */
    If _lReneg

        dbSelectArea('SE1')
        SE1->(dbSetOrder(1)) 
        SE1->(dbGoTop())
        
        dbSelectArea('ZAL')
        ZAL->(dbSetOrder(1)) 
        ZAL->(dbGoTop())
        If ZAL->(dbSeek(ZAK->ZAK_FILIAL+ZAK->ZAK_NUM+_cVerAnt))
            While ZAL->(!Eof()) .AND. ZAL->ZAL_FILIAL+ZAL->ZAL_NUM+ZAL->ZAL_VERSAO == ZAK->ZAK_FILIAL+ZAK->ZAK_NUM+_cVerAnt
                //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA
                If SE1->(dbSeek(ZAK->(ZAK_FILIAL+_cVerAnt+ZAK_NUM)+ZAL->ZAL_PARC+ZAK->ZAK_TIPO))
                    If SE1->E1_SALDO > 0
                        _aFina070 := {}
                        aadd( _aFina070, { "E1_FILIAL" 	, SE1->E1_FILIAL 	, nil } )
                        aadd( _aFina070, { "E1_PREFIXO" 	, SE1->E1_PREFIXO 	, nil } )
                        aadd( _aFina070, { "E1_NUM" 		, SE1->E1_NUM 		, nil } )
                        aadd( _aFina070, { "E1_PARCELA" 	, SE1->E1_PARCELA 	, nil } )
                        aadd( _aFina070, { "E1_TIPO" 	    , SE1->E1_TIPO 		, nil } )
                        aadd( _aFina070, { "E1_CLIENTE" 	, SE1->E1_CLIENTE 	, nil } )
                        aadd( _aFina070, { "E1_LOJA" 	    , SE1->E1_LOJA 		, nil } ) 
                        aadd( _aFina070, { "AUTBANCO" 	    , "" 				, nil } )
                        aadd( _aFina070, { "AUTAGENCIA" 	, "" 				, nil } )
                        aadd( _aFina070, { "AUTCONTA" 	    , "" 				, nil } )
                        aadd( _aFina070, { "AUTMOTBX" 	    , _cMotBx 			, nil } ) 
                        aadd( _aFina070, { "AUTDTBAIXA" 	, ddatabase 		, nil } )
                        aadd( _aFina070, { "AUTDTCREDITO"   , ddatabase 		, nil } )
                        aadd( _aFina070, { "AUTHIST" 	    , _cHistor 			, nil } )
                        aadd( _aFina070, { "AUTJUROS" 	    , 0 				, nil, .T. } )
                        aadd( _aFina070, { "AUTJUROS" 	    , 0 				, nil } )
                        aadd( _aFina070, { "AUTDESCONT" 	, 0 				, nil } )
                        aadd( _aFina070, { "AUTVALREC" 	    , SE1->E1_VALOR + SE1->E1_ACRESC		, nil } ) 
                                    
                        MSExecAuto({|x,y,b,a| Fina070(x,y,b,a)},_aFina070,3,.F.) //3 - Baixa de Título, 5 - Cancelamento de baixa, 6 - Exclusão de Baixa.

                        If lMsErroAuto
                            DisarmTransaction()
                            MsgAlert("Atenção, não foi possível baixar o(s) título(s) a receber do empréstimo renegociado. Verifique a mensagem a seguir com apoio do administrador do sistema!")
                            MostraErro()
                            Return
                        EndIf
                    EndIf //E1_SALDO > 0
                EndIf // dbseek se1
                
                ZAL->(DbSkip())
            EndDo
        EndIf // dbseek zal

    EndIf // _lReneg
    // Fim Baixa títulos a receber



    /*Inclusão do Título a Pagar*/
    Private cBanco 		:= CriaVar("E1_PORTADO")
    Private cAgencia	:= CriaVar("E1_AGEDEP")
    Private cConta		:= CriaVar("E1_CONTA")
    Private cCheque 	:= CriaVar("E1_NUMBCO")
    Private lF080Auto   := .F.
    Private aAutoCab    := {}
    Private cLoteFin 	:= Space(nTamLote)
    Private cBanco 		:= CriaVar("E1_PORTADO")
    Private cAgencia	:= CriaVar("E1_AGEDEP")
    Private cConta		:= CriaVar("E1_CONTA")
    Private cCheque 	:= CriaVar("E1_NUMBCO")
    Private cPortado	:= "   "
    Private cNumBor 	:= Space(6)
    Private cMarca 		:= ''
    Private nValPadrao	:= 0
    Private nValEstrang	:= 0
    Private cBenef
    Private cBancoV
    Private cAgenciaV
    Private cContrato
    Private cPrefV
    Private cNumV
    Private cParcV
    Private cTipV
    Private cNaturV
    Private cFornecV
    Private nValAcres
    Private nTxAcresV
    Private nValtitV
    Private dDataVencV
    Private cCtbaixa 	:= GETMV("MV_CTBAIXA")
    Private cFil080
    Private oVlEstrang,oCM
    Private lGerouSef 	:= .F.
    Private nAcresc     := 0
    Private nDecresc    := 0
    Private lIntegracao := IF(GetMV("MV_EASYFIN")=="S",.T.,.F.)
    Private lEECFAT  := SuperGetMv("MV_EECFAT",.F.,.F.)
    Private oDifCambio
    Private oAcresc
    Private oDecresc
    Private aDadosSPB 	:= {}
    Private nMoedaBco	 := 1
    Private cCodDiario	:= ""
    Private lIRProg	:= "2"
    Private nPgtoAuto := 0
    Private nValEIC  := 0

    // Se for renegociação não gera o CP, pois o empréstimo já foi pago ao produtor
    If !_lReneg
        _aFina050 := {  { "E2_PREFIXO"  , ZAK->ZAK_PREF                 , NIL },;
                        { "E2_NUM"      , ZAK->ZAK_NUM                  , NIL },;
                        { "E2_TIPO"     , ZAK->ZAK_TIPO                 , NIL },;
                        { "E2_NATUREZ"  , ZAK->ZAK_NATCP                , NIL },;
                        { "E2_FORNECE"  , ZAK->ZAK_FORN                 , NIL },;
                        { "E2_LOJA"     , ZAK->ZAK_LOJA                 , NIL },;
                        { "E2_EMISSAO"  , ZAK->ZAK_EMISSA               , NIL },;
                        { "E2_VENCTO"   , ZAK->ZAK_DTPGTO               , NIL },;
                        { "E2_VENCREA"  , ZAK->ZAK_DTPGTO               , NIL },;
                        { "E2_VLCRUZ"   , ZAK->ZAK_VALOR                , NIL },;
                        { "E2_CREDIT"   , ZAK->ZAK_CONTA                , NIL },;
                        { "E2_VALOR"    , ZAK->ZAK_VALOR                , NIL } }
    
        MsExecAuto( { |x,y,z| FINA050(x,y,z)}, _aFina050,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

        RecLock('SE2',.F.,.t.)
            SE2->E2_DATALIB := dDataBase
            SE2->E2_USUALIB := "LTBFIN01"
            SE2->E2_STATLIB := "03"
        MsUnlock()

        If lMsErroAuto
            DisarmTransaction()
            MsgAlert("Atenção, não foi possível incluir o título a pagar do empréstimo. Verifique a mensagem a seguir com apoio do administrador do sistema!")
            MostraErro()
            Return
        EndIf
    EndIf
    /*Fim Inclusão CP*/
    
    End Transaction

    // Atualização do Status
    RecLock('ZAK',.F.)
        ZAK->ZAK_STATUS := C_STAT_FINALIZADO
    ZAK->(MsUnlock())
    //End Transaction
Return




User Function LTB01REC(oView, cIDView, cField, xValue)

	Local oModel			:= FWModelActive()
	Local oModelZAK		:= oModel:GetModel("MASTER")
	Local oModelZAL		:= oModel:GetModel("ZALDETAIL")
	Local _nLine        := oModelZAL:GetLine()
    Local _nNextLine    := _nLine+1
    Local _dNewDate     := xValue
    Local _nDays        := 0
    Local _nJurMes      := 0
    Local _nJuros       := FwFldGet('ZAK_JUROS')
    Local _nTotJuros    := 0
    Local _nAmort       := 0
    Local _nParc        := FwFldGet('ZAK_PARC')
    Local nI            := 0

    If oModelZAL:IsDeleted()
        Return
    EndIf

    If _nLine == 1
        _nDays := _dNewDate - FwFldGet("ZAK_EMISSA")
        _nAmort := FwFldGet("ZAK_VALOR")
        _nJuros := _nJuros/30*_nDays
        _nJurMes := _nAmort*(_nJuros/100)

    Else
        _nDays := _dNewDate - oModelZAL:GetValue("ZAL_VENCTO",_nLine-1)
        _nAmort := oModelZAL:GetValue("ZAL_SLDAMO",_nLine-1)
        _nJuros := _nJuros/30*_nDays
        _nJurMes := _nAmort*(_nJuros/100)

    EndIf
	
    oModelZAL:LoadValue('ZAL_DIAS'	    , _nDays )
    oModelZAL:LoadValue('ZAL_JUROS'	    , _nJuros )
    oModelZAL:LoadValue('ZAL_VLRJUR'	, _nJurMes )

    
    _nJuros       := FwFldGet('ZAK_JUROS')

    If _nNextLine <= _nParc
        oModelZAL:SetLine(_nNextLineLine)
        _nDays := oModelZAL:GetValue("ZAL_VENCTO",_nNextLineLine) - oModelZAL:GetValue("ZAL_VENCTO",_nNextLineLine-1)
        _nAmort := oModelZAL:GetValue("ZAL_SLDAMO")
        _nJuros := _nJuros/30*_nDays
        _nJurMes := _nAmort*(_nJuros/100)
        
        oModelZAL:LoadValue('ZAL_DIAS'	    , _nDays )
        oModelZAL:LoadValue('ZAL_JUROS'	    , _nJuros )
        oModelZAL:LoadValue('ZAL_VLRJUR'	, _nJurMes )

    EndIf

   

    For nI := 1 To _nParc
        _nTotJuros += oModelZAL:GetValue("ZAL_VLRJUR",nI)
    Next nI

    oModelZAL:SetLine(1)
    oModelZAL:LoadValue('ZAL_VLPARC', oModelZAL:GetValue("ZAL_PRINC")+_nTotJuros )
    
    oModelZAL:SetLine(_nLine)

	oView:Refresh('ZALDETAIL')

Return

Static Function VldVencto(oModelZAL,cField,xValue)
    Local _lRet := .T.
    Local _dNewDate := xValue
    Local _nLine := oModelZAL:GetLine()
    Local _cMsgErro := ''
    Local _cMsgSol := ''
    Local oModel := FWModelActive()

    If oModelZAL:IsDeleted(_nLine) .OR. IsInCallStack("U_LTBPARC")
        Return _lRet
    EndIf

    If _nLine == 1
        _lRet := _dNewDate > FwFldGet("ZAK_EMISSA")

        If !_lRet
            _cMsgErro := "Atenção! O Vencimento não pode ser menor que a data de Emissão do Empréstimo."
            _cMsgSol  := "Ajuste a data para prosseguir!"
        EndIf
    Else
        _lRet := _dNewDate >= oModelZAL:GetValue("ZAL_VENCTO",_nLine - 1)

        If !_lRet
            _cMsgErro := "Atenção! O Vencimento desta parcela não pode ser menor que o da parcela anterior."
            _cMsgSol  := "Ajuste a data para prosseguir!"
        Else
            If oModelZAL:Length() >= (_nLine+1)
                If !oModelZAL:IsDeleted(_nLine+1)
                    _lRet := _dNewDate < oModelZAL:GetValue("ZAL_VENCTO",_nLine + 1)
                EndIf

                If !_lRet
                    _cMsgErro := "Atenção! O Vencimento desta parcela não pode ser maior ou igual ao da próxima parcela."
                    _cMsgSol  := "Ajuste a data para prosseguir!"
                EndIf
            EndIf
        EndIf


    EndIf

    If !_lRet
        oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
    EndIf

Return _lRet



Static Function VldMetodo(oModelZAK,cField,xValue)
    Local _lRet := .T.
    Local _cMetodo := xValue
    Local _cMsgErro := ''
    Local _cMsgSol := ''
    Local _cCond := ''
    Local oModel := FWModelActive()

    // Se o campo estiver em branco ou tiver selecionado o método manual
    If Empty(_cMetodo) .OR. _cMetodo == 'M'
        Return _lRet
    EndIf
    
    // Se tiver selecionado o método Condição de Pagamento valida se o campo A2_COND está preenchido
    If Empty(FwFldGet("ZAK_FORN")) .OR. Empty(FwFldGet("ZAK_LOJA"))
        _lRet := .F.
        _cMsgErro := "Atenção! Os dados do Fornecedor não foram preenchidos."
        _cMsgSol  := "Ajuste os dados para prosseguir!"
    EndIf

    If _lRet
        _cCond := Posicione('SA2',1,xFilial('SA2')+FwFldGet("ZAK_FORN")+FwFldGet("ZAK_LOJA"),'A2_COND')
        _lRet := !Empty(_cCond)

        If !_lRet
            _cMsgErro := "Atenção! O Fornecedor informado não possui Condição de Pagamento vinculada ao cadastro."
            _cMsgSol  := "É necessário ajustar o cadastro do fornecedor para prosseguir com este método de cálculo!"
        EndIf
    EndIf

    If !_lRet
        oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
    EndIf

Return _lRet



Static Function ViewNfs()
    Local _cForn := FwFldGet("ZAK_FORN")
    Local _cLoja := FwFldGet("ZAK_LOJA")

    dbSelectArea('SA2')
    SA2->(dbSetOrder(1)) 
    SA2->(dbGoTop())
    If SA2->(dbSeek(xFilial('SA2')+_cForn+_cLoja))
        U_LTBFIN02()
    Else
        MsgAlert("O Produtor preenchido é inválido!")
    EndIf

Return



Static Function LTB001GRV(oModel)
    Local lRet := .T.
    Local lInclui		:= oModel:GetOperation() == MODEL_OPERATION_INSERT
    Local lAltera		:= oModel:GetOperation() == MODEL_OPERATION_UPDATE
    Local lExclui		:= oModel:GetOperation() == MODEL_OPERATION_DELETE
    Local oModelZAK		:= oModel:GetModel("MASTER")
    Local oModelZAL		:= oModel:GetModel("ZALDETAIL")
    Local _cNum         := FwFldGet("ZAK_NUM")
    Local _cVerAnt      := FwFldGet("ZAK_VERANT")
    Local _cHist        := ''
    Local _cHistAnt     := AllTrim(FwFldGet("ZAK_HIST"))

    Begin Transaction
    
    // Primeiro, altero a versão antiga com o status Renegociado e preencho as parcelas que foram renegociadas
    // as parcelas só serão excluídas do financeiro no momento em que a nova versão for aprovada pelos gestores
    If lInclui .AND. _lReneg
        _cHist := 'RENEGOCIAÇÃO ' + FwFldGet('ZAK_VERSAO') + chr(10) + chr(13)
        _cHist += 'Data Renegociação: ' + dToC(Date()) + chr(10) + chr(13)
        _cHist += 'Usuário: ' + AllTrim(UsrFullName()) + chr(10) + chr(13)
        _cHist += 'Versão Anterior: ' + _cVerAnt + chr(10) + chr(13)
        _cHist += 'Parcelas Renegociadas: ' + _cParcRen + chr(10) + chr(13)
        _cHist += 'Valor Renegociado: R$ ' + AllTrim(Transform(FwFldGet('ZAK_VALOR'),"@E 999,999,999.99")) + chr(10) + chr(13)
        _cHist += 'Taxa Renegociação: ' + AllTrim(Transform(FwFldGet('ZAK_JUROS'),"@E 999.99")) + "%" + chr(10) + chr(13)
        _cHist += 'Taxa Original: ' + AllTrim(Transform(ZAK->ZAK_JUROS,"@E 999.99")) + "%" + chr(10) + chr(13)
        _cHist += Chr(10) + Chr(13)
        _cHist += '*** MEMÓRIA DE CÁLCULO DO VALOR RENEGOCIADO *** '+ chr(10) + chr(13)
        _cHist += 'VR = Valor das Parcelas da Versão Anterior (V.A.) que ainda não foram recebidas do produtor '+ chr(10) + chr(13)
        _cHist += 'VJ = Valor dos Juros das Parcelas da V.A. que ainda não foram recebidas do produtor  '+ chr(10) + chr(13)
        _cHist += '*** FÓRMULA *** '+ chr(10) + chr(13)
        _cHist += '  VR - VJ  '+ chr(10) + chr(13)
        _cHist +=   AllTrim(Transform(_nSldCrJr,"@E 999,999,999.99")) + ' - ' +;
                    AllTrim(Transform(_nJurosAnt,"@E 999,999,999.99")) + ' = ' +;
                    AllTrim(Transform(FwFldGet('ZAK_VALOR'),"@E 999,999,999.99")) + chr(10) + chr(13)
        
        _cHist += Chr(10) + Chr(13)
        _cHist += 'Motivo: ' + AllTrim(FwFldGet('ZAK_MOTIVO')) + chr(10) + chr(13)
        _cHist += chr(10) + chr(13) + Replicate('*',100) + chr(10) + chr(13) + chr(10) + chr(13)+ chr(10) + chr(13)
        _cHist += _cHistAnt

        oModelZAK:LoadValue("ZAK_HIST",_cHist)
        

        RecLock('ZAK',.F.)
            ZAK->ZAK_STATUS := C_STAT_RENEGOCIADO 
            ZAK->ZAK_PARREN := _cParcRen
        ZAK->(MsUnlock())
    EndIf


    If lInclui .AND. !_lReneg
        _cHist := 'INCLUSÃO ' + FwFldGet('ZAK_VERSAO') + chr(10) + chr(13)
        _cHist += 'Data Inclusão: ' + dToC(Date()) + chr(10) + chr(13)
        _cHist += 'Usuário: ' + AllTrim(UsrFullName()) + chr(10) + chr(13)
        _cHist += 'Valor Contrato: R$ ' + AllTrim(Transform(FwFldGet('ZAK_VALOR'),"@E 999,999,999.99"))+ chr(10) + chr(13)
        _cHist += 'Juros: ' + AllTrim(Transform(FwFldGet('ZAK_JUROS'),"@E 999.99")) + "%" + chr(10) + chr(13)
        _cHist += chr(10) + chr(13) + Replicate('*',100) + chr(10) + chr(13) + chr(10) + chr(13)
        _cHist += _cHistAnt

        oModelZAK:LoadValue("ZAK_HIST",_cHist)
    EndIf

    // Gravo a nova versão do empréstimo
    If !FWFormCommit(oModel)
		lRet:= .F.
		DisarmTransaction()
	EndIf

    If lRet .AND. lAltera
        RecLock('ZAK',.F.)
            ZAK->ZAK_STATUS := '1'
            ZAK->ZAK_DTAPR1 := sToD('') 
            ZAK->ZAK_DTAPR2 := sToD('') 
        ZAK->(MsUnlock())
    EndIf

    If lRet .AND. lInclui .AND. _lReneg
        RecLock('ZAK',.F.)
            ZAK->ZAK_VERANT := _cVerAnt
            ZAK->ZAK_VERSAO := Soma1(_cVerAnt)
            ZAK->ZAK_HIST   := _cHist
        ZAK->(MsUnlock())
    EndIf

    If lRet .AND. lExclui
        // Restauro a Versão Anterior
        dbSelectArea('ZAK')
        ZAK->(dbSetOrder(1)) 
        ZAK->(dbGoTop())
        If ZAK->(dbSeek(xFilial('ZAK')+_cNum+_cVerAnt))
            RecLock('ZAK',.F.)
                ZAK->ZAK_STATUS := C_STAT_FINALIZADO
                // ZAK->ZAK_PARREN := ''
            ZAK->(MsUnlock())
        EndIf
    EndIf

    End Transaction
Return lRet



Static Function LoadReneg( oView )

	Local oModelZAK	:= oView:GetModel("MASTER")
	Local oModelZAL	:= oView:GetModel("ZALDETAIL")
	Local lPrimeiro	:= .T.
	Local nLinAtu
	
	If oView:GetModel():GetOperation() == MODEL_OPERATION_INSERT .AND. _lReneg
        oModelZAK:LoadValue("ZAK_VERANT"    , ZAK->ZAK_VERSAO)
        oModelZAK:LoadValue("ZAK_VERSAO"    , SOMA1(ZAK->ZAK_VERSAO))
        oModelZAK:LoadValue("ZAK_PREF"      , SOMA1(ZAK->ZAK_VERSAO))
        oModelZAK:LoadValue("ZAK_VALOR"     , _nSaldoCR)
        oModelZAK:LoadValue("ZAK_FORN"      , ZAK->ZAK_FORN)
        oModelZAK:SetValue("ZAK_LOJA"       , ZAK->ZAK_LOJA)
        oModelZAK:LoadValue("ZAK_NUM"       , ZAK->ZAK_NUM)
        oModelZAK:LoadValue("ZAK_DTPGTO"    , ZAK->ZAK_DTPGTO)
        oModelZAK:LoadValue("ZAK_HIST"      , ZAK->ZAK_HIST)

        oView:Refresh()
    EndIf

Return ( .T. )

// Retorna saldo da parcela no financeiro
User Function LTB01SLD()
    Local oModel := FWModelActive()
    Local oModelZAL := oModel:GetModel("ZALDETAIL")
    Local _cPref    := FwFldGet('ZAK_PREF')
    Local _cNum     := FwFldGet('ZAK_NUM')
    Local _cParc    := ZAL->ZAL_PARC
    Local _cTipo    := FwFldGet('ZAK_TIPO')
    Local _nSaldo   := 0

    _nSaldo += POSICIONE('SE1',1,XFILIAL('SE1')+_cPref+_cNum+_cParc+_cTipo,'E1_SALDO')
    _nSaldo += POSICIONE('SE1',1,XFILIAL('SE1')+_cPref+_cNum+_cParc+_cTipo,'E1_SDACRES')
Return _nSaldo



//============================================================================\
/*/{Protheus.doc}LTB01PRF
  ==============================================================================
    @description
    Valida o prefixo na inclusão de títulos no contas a receber

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 29/01/2021

/*/
//============================================================================\
User Function LTB01PRF(  )
    Local _lRet := .T.
    
    
    
    If !IsInCallStack("U_LTBFIN01")
        _lRet := ExistCpo("SX5","Z2"+M->E1_PREFIXO)
    EndIf
Return (_lRet )
// FIM da Funcao LTB01PRF
//==============================================================================


User Function LTB01DT(  )
    Local _lRet := .T.
    Local oModel := FWModelActive()
    Local _dDtPrim := FwFldGet('ZAK_DTPRIM')
    Local _dDtPgto := FwFldGet('ZAK_DTPGTO')
    
    If _dDtPgto < dDataBase .AND. !Empty(_dDtPgto) .AND. !_lReneg
        _cMsgErro := 'Data Inválida'
        _cMsgSol := ''
        _lRet := .F.
        oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
    EndIf

    If _lRet .AND. _dDtPrim < dDataBase .AND. !Empty(_dDtPrim) 
        _cMsgErro := 'Data Inválida'
        _cMsgSol := ''
        _lRet := .F.
        oModel:SetErrorMessage(, , , , , _cMsgErro, _cMsgSol, , )
    EndIf
Return (_lRet )
