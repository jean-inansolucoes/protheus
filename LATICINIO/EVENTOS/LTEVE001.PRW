#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'FWMVCDef.ch'

//====================================================================================================================\
/*/{Protheus.doc}LTEVE001
  ====================================================================================================================
    @description
    Evento chamado após a análise de qualidade das pesagens e a análise de qualidade por produtor
    Chamada no fonte LTMOV009D ou LTMOV009E
    Utilizo o método AfterTTS (após a transação) para abertura dos protocolos quando necessário

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 07/04/2021

/*/
//===================================================================================================================\
Class LTEVE001 FROM FWModelEvent
    Method AfterTTS()
    Method New()
End Class
// FIM da Funcao LTEVE001
//======================================================================================================================



//============================================================================\
/*/{Protheus.doc}LTEVE001:New
  ==============================================================================
    @description
    Mï¿½todo Construtor da Classe

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 07/04/2021

/*/
//============================================================================\
Method New() Class LTEVE001
Return ()
// FIM do mï¿½todo LTEVE001:New
//==============================================================================



//============================================================================\
/*/{Protheus.doc}LTEVE001:AfterTTS
  ==============================================================================
    @description
    Mï¿½todo Construtor da Classe

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 07/04/2021

/*/
//============================================================================\
Method AfterTTS(oModel, cModelId, cAlias, lNewRecord) Class LTEVE001
	Local _cOpc := ''
	Local oModelZM1 := oModel:GetModel("MASTER")

	If !Empty(oModelZM1:GetValue("ZM1_LIBPRO"))
		  RecLock("ZM1",.F.)
			ZM1->ZM1_LIBPRO := oModelZM1:GetValue("ZM1_LIBPRO")
		  ZM1->(MsUnlock())
	EndIf

	If IsInCallStack("U_LTMOV9D")
		_cOpc := 'F'
	ElseIf IsInCallStack("U_LTMOV9E")
		_cOpc := 'P'
	EndIf

	U_LTEV001(_cOpc)
Return
  
User Function LTEV001(_cOpc)  
	If _cOpc == "F"
		MovPesag()
	ElseIf _cOpc == "P"
		MovProd() // Envia Workflow OS Extra Cronograma - Fonte LTEVE001EXC
	EndIf
  
Return ( Nil )


//============================================================================\
/*/{Protheus.doc}MovPesag
  ==============================================================================
    @description
    Verifica as análises das pesagens para verificar se alguma deve gerar
    protocolo, então cria os registros, se for o caso

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 07/04/2021

/*/
//============================================================================\

Static Function MovPesag()
  Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.f.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
  Local _lOpenProt	:= .F.
  Private _cIdProt  := ''
  Private _cTpMov := 'F'
  Private _aCabec := {}
  Private _aItens := {}


  // Se tiver preenchido o Código da linha, significa que é um movimento por produtor
  // dessa forma, o protocolo só será aberto na análise de qualidade por produtor -> MovProd()
  If !Empty(ZM1->ZM1_CODLIN)
    Return
  EndIf

  dbSelectArea('ZM5')
  ZM5->(dbSetOrder(2)) 
  ZM5->(dbGoTop())
  
  
  dbSelectArea('ZM4')
  ZM4->(dbSetOrder(1)) 
  ZM4->(dbGoTop())
  If ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
    While ZM4->(!Eof()) .And. ZM4->ZM4_FILIAL+ZM4->ZM4_NUM == xFilial('ZM4')+ZM1->ZM1_NUM
      If ZM4->ZM4_STATUS $ "D/P"

      
        If Empty(_aCabec)
          _cIdProt := GetSxeNum('ZM8',"ZM8_IDPROT")
          ConfirmSx8()
          aAdd(_aCabec,{'ZM8_FILIAL',xFilial("ZM8")})
          aAdd(_aCabec,{'ZM8_NUM',ZM1->ZM1_NUM})
          aAdd(_aCabec,{'ZM8_IDPROT',_cIdProt})
          aAdd(_aCabec,{'ZM8_IDENTI',"N"})
          aAdd(_aCabec,{'ZM8_DESCR',""}) // Não alterar o campo ZM8_DESCR da posição 5
          aAdd(_aCabec,{'ZM8_AVAL',""})
          aAdd(_aCabec,{'ZM8_DTQLD',dDataBase})
          aAdd(_aCabec,{'ZM8_TPMOV',_cTpMov})

          // Chama função LTMOV013 para preencher a descrição do problema na posição 5 da variável _aCabec
          If IsInCallStack("U_LTMOV9F")
            If MsgYesNo("Deseja realizar a abertura do Protocolo?")
			        	_lOpenProt := .T.
              	FWExecView('Descrição do Problema','LTMOV013', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )
				        RecLock("ZM1",.F.)
				  	    ZM1->ZM1_LIBPRO := 'N'
			        	ZM1->(MsUnlock())
            Else
              
              Return
            EndIf
          Else
            WfEve001()
          EndIf
          
        EndIf

        If ZM5->(dbSeek(xFilial('ZM5')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE))
          While ZM5->(!Eof()) .And. ZM5->ZM5_FILIAL+ZM5->ZM5_NUM+ZM5->ZM5_TANQUE == xFilial('ZM5')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE
            If ZM5->ZM5_STATUS $ 'D/P'
               aAdd(_aItens,{})
              aAdd(_aItens[Len(_aItens)],{"ZM9_FILIAL",xFilial("ZM9")})
              aAdd(_aItens[Len(_aItens)],{"ZM9_NUM",ZM1->ZM1_NUM})
              aAdd(_aItens[Len(_aItens)],{"ZM9_TANQUE",ZM4->ZM4_TANQUE})
              aAdd(_aItens[Len(_aItens)],{"ZM9_FORNEC",''})
              aAdd(_aItens[Len(_aItens)],{"ZM9_LOJA",''})
              aAdd(_aItens[Len(_aItens)],{"ZM9_NOME",''})
              aAdd(_aItens[Len(_aItens)],{"ZM9_CARACT",ZM5->ZM5_CARACT})
              aAdd(_aItens[Len(_aItens)],{"ZM9_DESCR",ZM5->ZM5_DESCR})
              aAdd(_aItens[Len(_aItens)],{"ZM9_VALOR",ZM5->ZM5_VALOR})
              aAdd(_aItens[Len(_aItens)],{"ZM9_DESCTX",ZM5->ZM5_DESCTX})
            EndIf
            ZM5->(DbSkip())
          EndDo
        EndIf
        
      EndIf
      
      ZM4->(DbSkip())
    EndDo
  EndIf
 /*  For _nI := 1 To oModelZM4:Length()
    If oModelZM4:GetValue('ZM4_STATUS',_nI) $ "D/P"
      oModelZM4:GoLine(_nI)
      
      If Empty(_aCabec)
        _cIdProt := GetSxeNum('ZM8',"ZM8_IDPROT")
        ConfirmSx8()
        aAdd(_aCabec,{'ZM8_FILIAL',xFilial("ZM8")})
        aAdd(_aCabec,{'ZM8_NUM',ZM1->ZM1_NUM})
        aAdd(_aCabec,{'ZM8_IDPROT',_cIdProt})
        aAdd(_aCabec,{'ZM8_IDENTI',"N"})
        aAdd(_aCabec,{'ZM8_DESCR',""}) // Não alterar o campo ZM8_DESCR da posição 5
        aAdd(_aCabec,{'ZM8_AVAL',""})
        aAdd(_aCabec,{'ZM8_DTQLD',dDataBase})
        aAdd(_aCabec,{'ZM8_TPMOV',_cTpMov})

        // Chama função LTMOV013 para preencher a descrição do problema na posição 5 da variável _aCabec
        FWExecView('Descrição do Problema','LTMOV013', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )
        
      EndIf

      For _nY := 1 To oModelZM5:Length()
        If oModelZM5:GetValue('ZM5_STATUS',_nY) $ 'D/P'
          aAdd(_aItens,{})
          aAdd(_aItens[Len(_aItens)],{"ZM9_FILIAL",xFilial("ZM9")})
          aAdd(_aItens[Len(_aItens)],{"ZM9_NUM",ZM1->ZM1_NUM})
          aAdd(_aItens[Len(_aItens)],{"ZM9_TANQUE",oModelZM4:GetValue("ZM4_TANQUE",_nI)})
          aAdd(_aItens[Len(_aItens)],{"ZM9_FORNEC",''})
          aAdd(_aItens[Len(_aItens)],{"ZM9_LOJA",''})
          aAdd(_aItens[Len(_aItens)],{"ZM9_NOME",''})
          aAdd(_aItens[Len(_aItens)],{"ZM9_CARACT",oModelZM5:GetValue("ZM5_CARACT",_nY)})
          aAdd(_aItens[Len(_aItens)],{"ZM9_DESCR",oModelZM5:GetValue("ZM5_DESCR",_nY)})
          aAdd(_aItens[Len(_aItens)],{"ZM9_VALOR",oModelZM5:GetValue("ZM5_VALOR",_nY)})
          aAdd(_aItens[Len(_aItens)],{"ZM9_DESCTX",oModelZM5:GetValue("ZM5_DESCTX",_nY)})
        EndIf
      Next _nY
    EndIf
  Next _nI */

  // Chama função para gravar o protocolo
  If Len(_aCabec) > 0 .AND. _lOpenProt
    LT001GRV()
  EndIf
Return


//============================================================================\
/*/{Protheus.doc}MovProd
  ==============================================================================
    @description
    Verifica as análises por produtor para verificar se alguma deve gerar
    protocolo, então cria os registros, se for o caso

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 07/04/2021

/*/
//============================================================================\

Static Function MovProd()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.f.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	Local _lOpenProt := .F.
	Private _cIdProt  := ''
	Private _cTpMov := 'P'
	Private _aCabec := {}
	Private _aItens := {}
 

  // Se não tiver preenchido o Código da linha, significa que é um movimento de Fornecedor
  // dessa forma, o protocolo só será aberto na análise de qualidade da pesagem  -> MovPesag()
  If Empty(ZM1->ZM1_CODLIN)
    Return
  EndIf

  dbSelectArea('ZM6')
  ZM6->(dbSetOrder(1)) 
  ZM6->(dbGoTop())
  
  dbSelectArea('ZM7')
  ZM7->(dbSetOrder(2)) 
  ZM7->(dbGoTop())
  
  dbSelectArea('ZM4')
  ZM4->(dbSetOrder(1)) 
  ZM4->(dbGoTop())
  If ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
    While ZM4->(!Eof()) .And. ZM4->ZM4_FILIAL+ZM4->ZM4_NUM == xFilial('ZM4')+ZM1->ZM1_NUM
      If ZM4->ZM4_STATUS $ "D/P"
      
        If Empty(_aCabec)
          _cIdProt := GetSxeNum('ZM8',"ZM8_IDPROT")
          ConfirmSx8()
          aAdd(_aCabec,{'ZM8_FILIAL',xFilial("ZM8")})
          aAdd(_aCabec,{'ZM8_NUM',ZM1->ZM1_NUM})
          aAdd(_aCabec,{'ZM8_IDPROT',_cIdProt})
          aAdd(_aCabec,{'ZM8_IDENTI',"N"}) // Não alterar o campo ZM8_IDENT da posição 4
          aAdd(_aCabec,{'ZM8_DESCR',""}) // Não alterar o campo ZM8_DESCR da posição 5
          aAdd(_aCabec,{'ZM8_AVAL',""})
          aAdd(_aCabec,{'ZM8_DTQLD',dDataBase})
          aAdd(_aCabec,{'ZM8_TPMOV',_cTpMov})
          aAdd(_aCabec,{'ZM8_STATUS','C'})

          // Chama função LTMOV013 para preencher a descrição do problema na posição 5 da variável _aCabec
         /*  If ZM1->ZM1_SITQLD <> 'P'
            // Não deixa finalizar se for necessário abrir protocolo
            RecLock('ZM1',.F.)
              ZM1->ZM1_SITQLD := 'E'
            ZM1->(MsUnlock()) */
          If IsInCallStack("U_LTMOV9F")
            If MsgYesNo("Deseja realizar a abertura do Protocolo?")
				_lOpenProt := .T.
              	FWExecView('Descrição do Problema','LTMOV013', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )
				RecLock("ZM1",.F.)
				  	ZM1->ZM1_LIBPRO := 'N'
				ZM1->(MsUnlock())
            Else
              
              Return
            EndIf
          Else
            WfEve001()
          EndIf
          
        EndIf

        // Grid por Produtor
        If ZM6->(dbSeek(xFilial("ZM6")+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE))
          While ZM6->(!Eof()) .And. ZM6->(ZM6_FILIAL+ZM6_NUM+ZM6_TANQUE) == xFilial("ZM6")+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE
            If ZM6->ZM6_STATUS $ 'D/P'
              If ZM7->(dbSeek(xFilial("ZM7")+ZM6->(ZM6_NUM+ZM6_TANQUE+ZM6_FORNEC+ZM6_LOJA)))
                While ZM7->(!Eof()) .And. ZM7->(ZM7_FILIAL+ZM7_NUM+ZM7_TANQUE+ZM7_FORNEC+ZM7_LOJA) == xFilial("ZM7")+ZM6->(ZM6_NUM+ZM6_TANQUE+ZM6_FORNEC+ZM6_LOJA)
                  If ZM7->ZM7_STATUS $ 'D/P'
                    aAdd(_aItens,{})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_FILIAL",xFilial("ZM9")})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_NUM",ZM1->ZM1_NUM})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_TANQUE",ZM7->ZM7_TANQUE})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_FORNEC",ZM7->ZM7_FORNEC})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_LOJA",ZM7->ZM7_LOJA})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_NOME",ZM6->ZM6_NOME})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_CARACT",ZM7->ZM7_CARACT})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_DESCR",ZM7->ZM7_DESCR})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_VALOR",ZM7->ZM7_VALOR})
                    aAdd(_aItens[Len(_aItens)],{"ZM9_DESCTX",ZM7->ZM7_DESCTX})

                  EndIF // If ZM7->ZM7_STATUS $ 'D/P'
                  ZM7->(DbSkip())
                EndDo

              EndIf // If ZM7->(dbSeek(xFilial("ZM7")+ZM6->(ZM6_FILIAL+ZM6_NUM+ZM6_TANQUE+ZM6_FORNEC+ZM6_LOJA)))
            EndIf // If ZM6->ZM6_STATUS $ 'D/P'
            ZM6->(DbSkip())
          EndDo
          
        EndIf // If ZM6->(dbSeek(xFilial("ZM6")+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE))
      EndIf // if ZM4->ZM4_STATUS $ "D/P"
      ZM4->(dbSkip())
    EndDo
  EndIf
  
  If Len(_aItens) > 0 // a análise de qualidade identificou o produtor cujo produto gerou descarte ou protocolo
    _aCabec[4,2] := 'S'
  Else
    // Preenche o _aItens com base na análise por pesagem
    _aItens := {}

    dbSelectArea('ZM5')
    ZM5->(dbSetOrder(1)) 
    ZM5->(dbGoTop())
    If ZM5->(dbSeek(xFilial('ZM5')+ZM1->ZM1_NUM))
      While ZM5->(!Eof()) .And. ZM5->ZM5_FILIAL+ZM5->ZM5_NUM == xFilial('ZM5')+ZM1->ZM1_NUM
        If ZM5->ZM5_STATUS $ 'D/P'
          aAdd(_aItens,{})
          aAdd(_aItens[Len(_aItens)],{"ZM9_FILIAL",xFilial("ZM9")})
          aAdd(_aItens[Len(_aItens)],{"ZM9_NUM",ZM1->ZM1_NUM})
          aAdd(_aItens[Len(_aItens)],{"ZM9_TANQUE",ZM5->ZM5_TANQUE})
          aAdd(_aItens[Len(_aItens)],{"ZM9_FORNEC",""})
          aAdd(_aItens[Len(_aItens)],{"ZM9_LOJA",""})
          aAdd(_aItens[Len(_aItens)],{"ZM9_NOME",""})
          aAdd(_aItens[Len(_aItens)],{"ZM9_CARACT",ZM5->ZM5_CARACT})
          aAdd(_aItens[Len(_aItens)],{"ZM9_DESCR",ZM5->ZM5_DESCR})
          aAdd(_aItens[Len(_aItens)],{"ZM9_VALOR",ZM5->ZM5_VALOR})
          aAdd(_aItens[Len(_aItens)],{"ZM9_DESCTX",ZM5->ZM5_DESCTX})
        EndIf

        ZM5->(DbSkip())
      EndDo
    EndIf

  EndIf

  // Chama função para gravar o protocolo
  If Len(_aCabec) > 0 .and. _lOpenProt
    LT001GRV()
  EndIf

Return
   

//============================================================================\
/*/{Protheus.doc}LT001GRV
  ==============================================================================
  @description
  Função responsável por gravar o protocolo através do model da rotina LTMOV012

  @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
  @version 1.0
  @since 19/04/2021

/*/
//============================================================================\
Static Function LT001GRV(  )
	Local oModel := FWLoadModel("LTMOV012")
	Local oModelZM8
	Local oModelZM9
	Local _nX := 0
	Local _nK := 0
	Local _lAddLin := .F.
	Private _nRotina := 0

	oModel:SetOperation(3)
	oModel:Activate()

	//Pegando o model e setando os campos
	oModelZM8 := oModel:GetModel("MASTER")

	For _nX := 1 To Len(_aCabec)
		oModelZM8:LoadValue(_aCabec[_nX,1]    , _aCabec[_nX,2]       ) 
		//oModelZM8:LoadValue("ZM8_FILIAL"   , xFilial("ZM8")     ) 
	Next _nX

	oModelZM9 := oModel:GetModel("ZM9DETAIL")
	For _nX := 1 To Len(_aItens)
		If _lAddLin
			oModelZM9:AddLine()
		Else
			_lAddLin := .T.
		EndIf

		For _nK := 1 To Len(_aItens[_nX])
			oModelZM9:LoadValue(_aItens[_nX,_nK,1],_aItens[_nX,_nK,2])
		Next _nK
	Next _nX

	//Se conseguir validar as informações
	If oModel:VldData()
		
		//Tenta realizar o Commit
		If oModel:CommitData()
			lOk := .T.
			RecLock('ZM1',.F.)
			ZM1->ZM1_IDPROT := _cIdProt 
			ZM1->ZM1_STPROT := 'A'
			ZM1->(MsUnlock())
		//Se não deu certo, altera a variável para false
		Else
			lOk := .F.
		EndIf
		
	//Se não conseguir validar as informações, altera a variável para false
	Else
		lOk := .F.
	EndIf

	//Se não deu certo a inclusão, mostra a mensagem de erro
	If ! lOk
		//Busca o Erro do Modelo de Dados
		aErro := oModel:GetErrorMessage()
		
		//Monta o Texto que será mostrado na tela
		cMessage := "Id do formulário de origem:"  + ' [' + cValToChar(aErro[01]) + '], '
		cMessage += "Id do campo de origem: "      + ' [' + cValToChar(aErro[02]) + '], '
		cMessage += "Id do formulário de erro: "   + ' [' + cValToChar(aErro[03]) + '], '
		cMessage += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], '
		cMessage += "Id do erro: "                 + ' [' + cValToChar(aErro[05]) + '], '
		cMessage += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], '
		cMessage += "Mensagem da solução: "        + ' [' + cValToChar(aErro[07]) + '], '
		cMessage += "Valor atribuído: "            + ' [' + cValToChar(aErro[08]) + '], '
		cMessage += "Valor anterior: "             + ' [' + cValToChar(aErro[09]) + ']'
		
		//Mostra mensagem de erro
		lRet := .F.
		Alert("Erro LTEVE001: " + cMessage)
	Else
		lRet := .T.
		
	EndIf

	//Desativa o modelo de dados
	oModel:DeActivate()

Return ( Nil )
// FIM da Funcao LT001GRV
//==============================================================================


//============================================================================\
/*/{Protheus.doc}WFEVE001
  ==============================================================================
  @description
  Função responsável por enviar um WF ao dpto de qualidade informando sobre a
  necessidade de abertura de protocolo da pesagem

  @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
  @version 1.0
  @since 18/05/2021

/*/
//============================================================================\
Static Function WfEve001()
	Local cEmailTo := GetMv("MX_EVE002Q") // Aprovadores do setor de Qualidade
	Local _cAssunto := '[TRELAC] ABERTURA PROTOCOLO DE QUALIDADE'
	Local cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
	Local cArqHtml		:= cMV_WFDIR +"\WfEvento001a.htm"
	Local oWFProc		:= nil
	Local cCodProces	:= "WFEVE001"

	ConOut(cCodProces +"|INICIO")

    If !File(cArqHtml)
        Alert(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
        ConOut(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
        Return()
    Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gera Workflow da COTACAO DE COMPRA (função W002B02)                       ³
    //³ Retorna o ID do arquivo HTML para uso no WF LINK DO E-MAIL                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oWFProc := TWFProcess():New(cCodProces, _cAssunto)
    
    //oWFProc := TWFProcess():New(cCodProces, cAssunto)
    oWFProc:NewTask(_cAssunto, cArqHtml)
    oWFProc:cTo      := cEmailTo
    oWFProc:cSubject := _cAssunto
    
    ConOut(cCodProces +"|ProcessID: "+ oWFProc:fProcessID +"|TaskID: "+ oWFProc:fTaskID )
    If GeraHtml(@oWFProc)
        cRet := oWFProc:Start()
        ConOut(cCodProces +"|cRet: "+ cRet)
       
    Endif

    ConOut(cCodProces +"|FIM")

Return

Static Function GeraHtml(oWFProc)
    Local lRet		:= .T.
    
    // Preenche as variaveis do Cabeçalho
    oWFProc:oHtml:ValByName("NUM_PESAGEM"       , ZM1->ZM1_NUM ) //
Return(lRet)

