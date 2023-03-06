#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'FWMVCDef.ch'

//====================================================================================================================\
/*/{Protheus.doc}LTEVE002
  ====================================================================================================================
    @description
    Evento chamado após a análise de qualidade das pesagens e a análise de qualidade por produtor
    Chamada no fonte LTMOV012
    Utilizo o método AfterTTS (após a transação) para envio dos WorkFlows

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 10/04/2021

/*/
//===================================================================================================================\
Class LTEVE002 FROM FWModelEvent
    Method AfterTTS()
    Method New()
End Class
// FIM da Funcao LTEVE002
//======================================================================================================================



//============================================================================\
/*/{Protheus.doc}LTEVE002:New
  ==============================================================================
    @description
    Mï¿½todo Construtor da Classe

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 07/04/2021

/*/
//============================================================================\
Method New() Class LTEVE002
Return ()
// FIM do mï¿½todo LTEVE002:New
//==============================================================================



//============================================================================\
/*/{Protheus.doc}LTEVE002:AfterTTS
  ==============================================================================
    @description
    Mï¿½todo Construtor da Classe

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 07/04/2021

/*/
//============================================================================\
Method AfterTTS(oModel, cModelId, cAlias, lNewRecord) Class LTEVE002
    Local lInclui	:= oModel:GetOperation() == MODEL_OPERATION_INSERT
    Local lAltera	:= oModel:GetOperation() == MODEL_OPERATION_UPDATE
    Local lExclui	:= oModel:GetOperation() == MODEL_OPERATION_DELETE
    
    // chama função responsável pelo envio do WF
    If lInclui .or. lAltera
        WfProt()
    EndIf
Return
  
//============================================================================\
/*/{Protheus.doc}WfProt
  ==============================================================================
    @description
    Envia WorkFlow informando aos aprovadores sobre a necessidade de aprovação
    do protocolo

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 12/05/2021

/*/
//============================================================================\
Static Function WfProt(  )
    Local cEmailTo := ''
    Local _cAssunto := '[TRELAC] PROTOCOLO DE QUALIDADE'
    Local cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
    Local cArqHtml		:= ''
    Local oWFProc		:= nil
    Local cCodProces	:= "WFEVE002"
    Local cIDLink       := ''
    Local cNota         := ZM1->ZM1_NFCOM + "/"+ ZM1->ZM1_SRCOM
    
    If ZM8->ZM8_STATUS == 'C'
        If ZM8->ZM8_TPMOV == "F"
            cEmailTo := AllTrim(Posicione("SA2",1,xFilial("SA2")+ZM1->ZM1_CLIFOR+ZM1->ZM1_LOJA,"A2_EMAIL"))

            If Empty(cEmailTo)
                cEmailTo := GetMv("MX_EVE002C")
                _cAssunto += ' - E-MAIL FORNECEDOR NÃO PREENCHIDO'
            EndIf
        Else
            cEmailTo := GetMv("MX_EVE002C") // Aprovadores do setor de Captação
        EndIf

        cArqHtml		:= cMV_WFDIR +"\WfEvento002b.htm" // Contém o link para preenchimento do formulário eletrônico
    ElseIf ZM8->ZM8_STATUS == 'Q'
        cArqHtml		:= cMV_WFDIR +"\WfEvento002a.htm"
        cEmailTo := GetMv("MX_EVE002Q") // Aprovadores do setor de Qualidade
    EndIf


    ConOut(cCodProces +"|INICIO")

    If !File(cArqHtml)
        Alert(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
        ConOut(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
        Return( .F.)
    Endif

    If !Empty(ZM8->ZM8_PROCID) .AND. ZM8->ZM8_STATUS == 'C'
        cIDLink := ZM8->ZM8_PROCID
        DbSelectArea('WFA')
        WFA->(dbsetOrder(2))
        WFA->(dbGoTop())
        If WFA->(dbSeek(xFilial("WFA")+cIDLink))
            If WFA->WFA_TIPO == '4'
                Alert(cCodProces +"| Resposta já recebida! ")
                ConOut(cCodProces +"| Resposta já recebida! ")
                Return .F.
            EndIf
        Else
            cIdLink := ''
        EndIf
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gera Workflow da COTACAO DE COMPRA (função W002B02)                       ³
    //³ Retorna o ID do arquivo HTML para uso no WF LINK DO E-MAIL                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oWFProc := TWFProcess():New(cCodProces, _cAssunto)
    
    If ZM8->ZM8_STATUS == 'C' .and. Empty(cIDLink)// monta formulário para preenchimento eletrônico do protocolo
        cIDLink := WFP002(@oWFProc)
    EndIf

    //oWFProc := TWFProcess():New(cCodProces, cAssunto)
    oWFProc:NewTask(_cAssunto, cArqHtml)
    oWFProc:cTo      := cEmailTo
    oWFProc:cSubject := _cAssunto
    
    ConOut(cCodProces +"|ProcessID: "+ oWFProc:fProcessID +"|TaskID: "+ oWFProc:fTaskID )
    If GeraHtml(@oWFProc, cIDLink, cNota)
        cRet := oWFProc:Start()
        ConOut(cCodProces +"|cRet: "+ cRet)
       
    Endif

    ConOut(cCodProces +"|FIM")

Return ( .T. )
// FIM da Funcao WfProt
//==============================================================================

Static Function GeraHtml(oWFProc, cIDLink, cNota)
    Local lRet		:= .T.
    Local cMV_URLWF	:= AllTrim(SUPERGETMV("MV_WFBRWSR"))	// Endereco URL do Workflow acesso Web]
    
    // Preenche as variaveis do Cabeçalho
    oWFProc:oHtml:ValByName("NUM_PROT", ZM8->ZM8_IDPROT ) //
    IF(ZM8->ZM8_TPMOV == "F")
        oWFProc:oHtml:ValByName("NUM_NOTA", cNota )
    ENDIF
    IF !Empty(cIDLink) .AND. ZM8->ZM8_STATUS == 'C'
        RecLock('ZM8', .F.)
            ZM8->ZM8_PROCID := cIDLink
        MsUnlock()
        oWFProc:oHtml:ValByName("proc_link"     , cMV_URLWF+ "/messenger/emp"+ cEmpAnt +"/wfp002/"+ cIDLink +".htm")
    EndIf
Return(lRet)



Static Function wfp002(oWFProc)
    Local cRet			:= ""
    Local cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
    Local cMV_DHTTP		:= AllTrim(GetMV("MV_WFDHTTP"))		// Pasta de acesso Web HTTP
    Local cCodProces	:= "WFP002"
    Local cAssunto		:= "Protocolo de Não Conformidade"
    Local cEmailTo		:= cCodProces
    Local cArqHtml		:= IIF(ZM8->ZM8_TPMOV != "F",cMV_WFDIR +"\WfEvento002c.htm",cMV_WFDIR +"\WfEvento002d.htm")

    cMV_DHTTP := StrTran(cMV_DHTTP,"\","/")

    ConOut(cCodProces +"|INICIO")

    If !File(cArqHtml)
        Alert(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
        ConOut(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
        Return(cRet)
    Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria objeto do Workflow e gera o HTML                                     ³
	//³ Retorna o ID do arquivo HTML para uso no WF LINK                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oWFProc == nil
		oWFProc := TWFProcess():New(cCodProces, cAssunto)
	Endif
	oWFProc:NewTask(cAssunto, cArqHtml)
	oWFProc:cTo      := cEmailTo
	oWFProc:cSubject := cAssunto
	oWFProc:bReturn  := "U_WfEve03R()"
	
	ConOut(cCodProces +"|ProcessID: "+ oWFProc:fProcessID +"|TaskID: "+ oWFProc:fTaskID )
	If GeraHtm2(@oWFProc)
		cRet := oWFProc:Start( cMV_DHTTP +"/messenger/emp"+ cEmpAnt +"/wfp002/" )
		ConOut(cCodProces +"|cRet: "+ cRet)
	Endif


    ConOut(cCodProces +"|FIM")

Return(cRet)





Static Function GeraHtm2(oWFProc)
    Local lRet		:= .T.
    Local cMV_URLWF	:= AllTrim(SUPERGETMV("MV_WFBRWSR"))	// Endereco URL do Workflow acesso Web]
    Local cChave	:= "500"
    Local aColHtml	:= {}
    Local j, i		:= 0 
    Local _aAreaZM9 := ZM9->(GetArea())
    

    oWFProc:oHtml:ValByName("PRODUTO"      , AllTrim(ZM1->ZM1_PROD) +' - ' + AllTrim(ZM1->ZM1_DESC)    )
    If ZM8->ZM8_TPMOV != "F"
    oWFProc:oHtml:ValByName("VEICULO" , IIF(EMPTY(ZM1->ZM1_CODVEI),"Não se Aplica",ZM1->ZM1_CODVEI) )
    oWFProc:oHtml:ValByName("LINHA"   , AllTrim(ZM1->ZM1_CODLIN)+' - '+AllTrim(ZM1->ZM1_NOMLIN) )
    EndIf
    oWFProc:oHtml:ValByName("PESAGEM"        , ZM1->ZM1_NUM    )
    oWFProc:oHtml:ValByName("DATA_ENTRADA"   , dToC(ZM1->ZM1_DTINI) )
    If ZM8->ZM8_TPMOV == "F"
        oWFProc:oHtml:ValByName("NFISCAL"        , ZM1->ZM1_NFCOM + '/' + ZM1->ZM1_SRCOM    )
        oWFProc:oHtml:ValByName("NMFORNE"        , ZM1->ZM1_NOME)
    EndIf
    dbSelectArea('ZM9')
    ZM9->(dbSetOrder(1))  
    ZM9->(dbGoTop())
    If ZM9->(dbSeek(xFilial('ZM9')+ZM8->ZM8_NUM))
        While ZM9->(!Eof()) .And. ZM9->(ZM9_FILIAL+ZM9_NUM) == xFilial('ZM9')+ZM8->ZM8_NUM
            aAdd( oWFProc:oHtml:ValByName("IT.TANQUE"    ), ZM9->ZM9_TANQUE    )
		    If ZM8->ZM8_TPMOV != "F"
                aAdd( oWFProc:oHtml:ValByName("IT.FORNECE"    ), IIF(EMPTY(ZM9->ZM9_FORNECE),ZM1->ZM1_CLIFOR,ZM9->ZM9_FORNECE)    )
		        aAdd( oWFProc:oHtml:ValByName("IT.LOJA"    ), IIF(EMPTY(ZM9->ZM9_LOJA),ZM1->ZM1_LOJA,ZM9->ZM9_LOJA)    )
		        aAdd( oWFProc:oHtml:ValByName("IT.NOME"    ), IIF(EMPTY(ZM9->ZM9_NOME),ZM1->ZM1_NOME,ZM9->ZM9_NOME)    )
            EndIf
		    aAdd( oWFProc:oHtml:ValByName("IT.ANALISE" ), ZM9->ZM9_CARACT )
            aAdd( oWFProc:oHtml:ValByName("IT.DESCRI"    ), ZM9->ZM9_DESCR    )
            aAdd( oWFProc:oHtml:ValByName("IT.VALOR"    ), transform(ZM9->ZM9_VALOR,"@E 999,999.999")   )
            aAdd( oWFProc:oHtml:ValByName("IT.MOTIVO"    ), ""    )
            aAdd( oWFProc:oHtml:ValByName("IT.CAUSA"    ), ""    )
            aAdd( oWFProc:oHtml:ValByName("IT.RELACAO"    ), {"1=Maquina","2=Mao-de-Obra","3=Metodo","4=Material"}   )
            aAdd( oWFProc:oHtml:ValByName("IT.ACOES"    ), ""    )
            aAdd( oWFProc:oHtml:ValByName("IT.PRAZO"    ), "  /  /    "    )
            
		
            
            ZM9->(DbSkip())
        EndDo
    EndIf

Return(lRet)




User Function WfEve03R(oProcess)
    Local nI := 0
    ConOut("WfEve03R|INICIO RETORNO PROTOCOLO")
     
     cRet		:= ""
     _cPesagem	:= PADR(oProcess:oHtml:RetByName("PESAGEM"), TamSX3("ZM9_NUM")[1])
     nX := 0
     nJ	:= 0
     aRecno	:= {}
     cPath		:= ""
     cFile		:= ""
     cErro		:= ""

    
    If !Empty(_cPesagem) .AND. Len(oProcess:oHtml:RetByName("it.tanque")) > 0
        dbSelectArea('ZM8')
        ZM8->(dbSetOrder(1)) 
        ZM8->(dbSeek(xFilial("ZM8")+_cPesagem))

        RecLock('ZM8', .F.)
            ZM8->ZM8_STATUS := 'Q'
        MsUnlock()
    EndIf

    dbSelectArea('ZM9')
    ZM9->(dbSetOrder(1)) 

    ConOut("WfEve03R|"+cValToChar(Len(oProcess:oHtml:RetByName("it.tanque")))+" ANÁLISES ENCONTRADAS")
    
    For nI := 1 To Len(oProcess:oHtml:RetByName("it.tanque"))
     
        _cRespon    := PADR(oProcess:oHtml:RetByName("RESPONSAVEL"), TamSX3("ZM9_RESP")[1])
        _cTanque    := PADR(oProcess:oHtml:RetByName("it.tanque")[nI], TamSX3("ZM9_TANQUE")[1])
        _cAnalise   := PADR(oProcess:oHtml:RetByName("it.analise")[nI], TamSX3("ZM9_CARACT")[1])
        If ZM8->ZM8_TPMOV != "F"
          _cFornece   := PADR(Replace(oProcess:oHtml:RetByName("it.fornece")[nI],"N/A",""), TamSX3("ZM9_FORNEC")[1])
          _cLoja      := PADR(Replace(oProcess:oHtml:RetByName("it.loja")[nI],"N/A",""), TamSX3("ZM9_LOJA")[1])
        Else
          _cFornece   := PADR("",TamSX3("ZM9_FORNEC")[1])
          _cLoja      := PADR("",TamSX3("ZM9_LOJA")[1])
        EndIf
        _cMotivo    := ALLTRIM(oProcess:oHtml:RetByName("it.motivo")[nI])
        _cCausa     := ALLTRIM(oProcess:oHtml:RetByName("it.causa")[nI])
        _cRelacao   := Left(oProcess:oHtml:RetByName("it.relacao")[nI],1)
        _cAcoes     := ALLTRIM(oProcess:oHtml:RetByName("it.acoes")[nI])
        _cPrazo     := ALLTRIM(oProcess:oHtml:RetByName("it.prazo")[nI])
        ConOut("WfEve03R|PRAZO TIPO "+Type(_cPrazo))    
    
        // Valido se data veio preenchida corretamente
        If Type(_cPrazo) == "U"
            _cPrazo := Date()+7
        Else
            _cPrazo := cValToChar(_cPrazo)
            _cPrazo := cToD(_cPrazo)
        EndIf

        ZM9->(dbGoTop())

        ConOut("WfEve03R|PROCURANDO TANQUE "+_cTanque+", ANALISE " + _cAnalise + ', PRODUTOR ' +_cFornece + ', LOJA ' + _cLoja)    
        
        If ZM9->(dbSeek(xFilial('ZM9')+_cPesagem+_cTanque+_cFornece+_cLoja+_cAnalise))
            RecLock('ZM9',.F.)
                ZM9->ZM9_MOTIVO := _cMotivo
                ZM9->ZM9_CAUSA  := _cCausa
                ZM9->ZM9_RELAC  := _cRelacao 
                ZM9->ZM9_ACOES  := _cAcoes
                ZM9->ZM9_PRAZO  := _cPrazo
                ZM9->ZM9_RESP   := _cRespon
                ZM9->ZM9_DTINVE := Date() 
            ZM9->(MsUnlock())

        EndIf
        
    Next nI

    ConOut("WfEve03R|ENVIANDO E-MAIL AO SETOR DE QUALIDADE")
    WfProt()

    ConOut("WfEve03R|FIM RETORNO PROTOCOLO")

   

Return(cRet)


User Function LTEVE02B()
    Local _lEnv := WfProt()
    If _lEnv
        MsgInfo("E-mail enviado com sucesso!")
    EndIf
Return
