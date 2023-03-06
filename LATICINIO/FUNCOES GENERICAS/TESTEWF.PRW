#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'FWMVCDef.ch'

//============================================================================\
User Function TESTEWF001()
	Local cEmailTo := "ti@trelac.com.br" // Aprovadores do setor de Qualidade
	Local _cAssunto := '[TRELAC] TESTE WORKFLOW'
	Local cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
	Local cArqHtml		:= cMV_WFDIR +"\WfTeste01.htm"
	Local oWFProc		:= nil
	Local cCodProces	:= "TESTEWF001"

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
    oWFProc:oHtml:ValByName("D_DATABASE"       , DDATABASE ) //
Return(lRet)

