#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'FWMVCDef.ch'

//============================================================================\
User Function WFFIN001()
	Local cEmailTo := POSICIONE("SA1", 1, xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_X_MAILB")//"ti@trelac.com.br"
	Local cEmailVend := POSICIONE("SA3", 1, xFilial("SA3") + SE1->E1_VEND1, "A3_EMAIL")
	Local _cAssunto := 'Pendências Financeiras [TRELAC]'
	Local cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
	Local cEmailcob     := AllTrim(GetMV("MV_MAILCOB"  ))
    Local cArqHtml		:= cMV_WFDIR +"\WfFin001.htm"
	Local oWFProc		:= nil
	Local cCodProces	:= "WFFIN001"

	ConOut(cCodProces +"|INICIO")

	If !File(cArqHtml)
		Alert(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
		ConOut(cCodProces +"|Arquivo HTML não encontrado! "+ cArqHtml)
		Return()
	Endif

	If !Empty(alltrim(cEmailTo))

		IF SE1->E1_VENCREA <= Date() .AND. SE1->E1_SALDO > 0

			oWFProc := TWFProcess():New(cCodProces, _cAssunto)

			//oWFProc := TWFProcess():New(cCodProces, cAssunto)
			oWFProc:NewTask(_cAssunto, cArqHtml)
			oWFProc:cTo      := cEmailTo
			If !Empty(cEmailVend)
				oWFProc:cCC      := cEmailVend
			EndIf
			oWFProc:cSubject := _cAssunto
			oWFProc:oHtml:ValByName("EMISSAO"       , SE1->E1_EMISSAO ) //
			oWFProc:oHtml:ValByName("VENCIMENTO"    , SE1->E1_VENCREA )
			oWFProc:oHtml:ValByName("NOTAFISCAL"    , SE1->E1_NUM )
			oWFProc:oHtml:ValByName("NOME"          , SE1->E1_NOMCLI )
			oWFProc:oHtml:ValByName("VALOR"         , TRANSFORM(SE1->E1_VALOR,"@E 99,999,999.99") )
            oWFProc:oHtml:ValByName("MAILCOB"          , cEmailcob )

			ConOut(cCodProces +"|ProcessID: "+ oWFProc:fProcessID +"|TaskID: "+ oWFProc:fTaskID )
			If GeraHtml(@oWFProc)
				cRet := oWFProc:Start()
				ConOut(cCodProces +"|cRet: "+ cRet)
				msginfo("Email Enviado com Sucesso!")
			Endif

		ELSE
			Help( , , 'Dados Inválidos' , , 'O Título precisa estar vencido e possuir saldo para enviar a carta de cobrança!', 1, 0, , , , , , {"Selecione um título vencidoe com saldo!"})
		ENDIF
	else
		Help( , , 'Dados Inválidos' , , 'Cadastro do cliente sem email para boleto preenchido!', 1, 0, , , , , , {"Preencha o campo Email Boleto na aba Adm/Fin. no cadastro do Cliente e repita a operação!"})
	EndIf
	ConOut(cCodProces +"|FIM")

Return

Static Function GeraHtml(oWFProc)
	Local lRet		:= .T.

	// Preenche as variaveis do Cabeçalho
	oWFProc:oHtml:ValByName("D_DATABASE"       , DDATABASE ) //
Return(lRet)

