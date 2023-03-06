#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2520     ºAutor ³Alexandre LonghinottiºData ³ 25/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ É chamado antes da exclusão do registro no SD2, na exclusãoº±±
±±º          ³ de Documentos de saída                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 */
User function MSD2520()
***********************
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10)+CHR(13)       
Local cFilSC6	:= xFilial("SF2")
	Local lValido  	:= .F.
	Local lIntTMK	:= .T.
	Local nTotElim	:= 0 //Indica se é eliminacao total do Pedido
	Private lMsErroAuto := .F.

If !Empty( SA1->A1_X_FUNC )

	cQuery := "	SELECT 	RG1.R_E_C_N_O_               					   			" + hEnter
	cQuery += "	FROM " + RetSqlName("RG1") + " RG1						  			" + hEnter
	cQuery += "	WHERE    RG1.RG1_FILIAL    = '" + xFilial("SF2") + "' 	  			" + hEnter
	cQuery += "	AND      RG1.RG1_PD    = '454'   									" + hEnter
	cQuery += "	AND      RG1.RG1_X_NDOC = '"+SF2->F2_DOC+"'   		   				" + hEnter
	cQuery += "	AND      RG1.RG1_MAT = '"+SA1->A1_X_FUNC+"'   		   				" + hEnter
	cQuery += "	AND 	 RG1.D_E_L_E_T_   != '*' 									" + hEnter
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		dbSelectArea("RG1")
		RG1->(dbGoTo((cAliasTMP)->R_E_C_N_O_))
		If RG1->RG1_X_NDOC == SF2->F2_DOC
			If RecLock("RG1",.F.)
				RG1->(dbDelete())
				RG1->(MsUnLock())
			EndIf
		EndIf
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ENCERRA PEDIDO DE VENDAS APOS O  A EXCLUSAO DO DOCUMENTO                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//Estorna Liberação do PEDIDO caso haja
	Begin Transaction
	dBSelectArea("SC6")
	SC6->( dBSetOrder( 1 ) )
	SC6->( dBGoTop( ) )
	If SC6->( dbSeek( cFilSC6 + SD2->D2_PEDIDO ) )
		// avalia os itens, de modo a eliminar resíduos caso haja faturamento
		While !SC6->(EOF()) .AND. SC6->C6_FILIAL == cFilSC6 .AND. SC6->C6_NUM == SD2->D2_PEDIDO
			// tenta estornar as liberações do item
			MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil)
			If RecLock("SC6",.F.)
				IF Empty(SC6->C6_NOTA)
					SC6->( dBDelete( ) )
				ENDIF
				SC6->(MsUnLock())
			EndIf
			SC6->( dbSkip() )
		Enddo
	Endif

	cFilSC9 := "SC9->C9_FILIAL = '"+ cFilSC6 +"' .AND. SC9->C9_PEDIDO = '"+ SD2->D2_PEDIDO	+"' .AND. ( SC9->C9_BLEST <> '10' .OR. SC9->C9_BLCRED <> '10' )  "

	dbSelectArea("SC9")
	SET FILTER TO &(cFilSC9)
	SC9->(dbGoTop())
	While !SC9->(EOF())
		If RecLock("SC9",.F.)
			IF Empty(SC9->C9_NFISCAL)
				SC9->( dBDelete( ) )
			Else
				SC9->C9_BLEST := "10"
				SC9->C9_BLCRED := "10"
			EndIf
			SC9->(MsUnLock())
		EndIf
		SC9->(dbSkip())
	Enddo
	SET FILTER TO


	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	SC6->(MsSeek( cFilSC6 + SD2->D2_PEDIDO ))

	While ( !Eof() .And. SC6->C6_FILIAL == cFilSC6 .And. SC6->C6_NUM == SD2->D2_PEDIDO )

		//Faz o acerto da Quantidade reservada na SB2
		nReserv := 0
		cFilSC9 := "SC9->C9_FILIAL = '"+ SC6->C6_FILIAL +"' .AND. SC9->C9_LOCAL = '"+ SC6->C6_LOCAL	+"' .AND. SC9->C9_PRODUTO = '"+ SC6->C6_PRODUTO	+"' .AND. SC9->C9_NFISCAL = '         ' .AND. SC9->C9_BLEST <> '02'		  "
		cFilSB2 := "SB2->B2_FILIAL = '"+ SC6->C6_FILIAL	+"' .AND. SB2->B2_LOCAL = '"+ SC6->C6_LOCAL	+"' .AND. SB2->B2_COD = '"+ SC6->C6_PRODUTO	+"'		  "

		dbSelectArea("SC9")
		SET FILTER TO &(cFilSC9)
		SC9->(dbGoTop())
		While !SC9->(EOF())
			If RecLock("SC9",.F.)
				nReserv += SC9->C9_QTDLIB
				SC9->(MsUnLock())
			EndIf
			SC9->(dbSkip())
		Enddo
		SET FILTER TO

		dbSelectArea("SB2")
		SET FILTER TO &(cFilSB2)
		SB2->(dbGoTop())
		While !SB2->(EOF())
			If RecLock("SB2",.F.)
				SB2->B2_RESERVA := nReserv
				SB2->(MsUnLock())
			EndIf
			SB2->(dbSkip())
		Enddo
		SET FILTER TO
		//Fim do acerto da Quantidade reservada na SB2


		If Empty(SC6->C6_RESERVA)
			lValido  := .T.
		Else
			aAdd( aColsEx, { SC6->C6_NUM	,;
				SC6->C6_ITEM	,;
				SC6->C6_PRODUTO	,;
				POSICIONE('SB1', 1, cFilSB1 + SC6->C6_PRODUTO, 'B1_DESC'),;
				SC6->C6_RESERVA	,;
				.F.})
			lValido  := .F.
		EndIf
		If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
			lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
		EndIf
		If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
			Pergunte("MTA500",.F.)
			lElim := MaResDoFat(,.T.,.F.,,MV_PAR12 == 1,MV_PAR13 == 1)
			Pergunte("MTA410",.F.)
		EndIf

		nTotElim += (SC6->C6_QTDEMP + SC6->C6_QTDENT)

		//Verifica se o pedido foi gerado pelo Televendas.
		lIntTMK := IIF(lIntTMK,!Empty(SC6->C6_PEDCLI) .And. "TMK" $ upper(SC6->C6_PEDCLI),lIntTMK)
		dbSelectArea("SC6")
		dbSkip()
	EndDo
	SC6->(MaLiberOk({SC5->C5_NUM},.T.))
	//Se o pedido for eliminado por completo, será feito o cancelamento do atendimento do Televendas.
	If lIntTMK .AND. SC5->C5_LIBEROK == "S" .And. "X" $ SC5->C5_NOTA
		TkAtuTlv(SC5->C5_NUM,4)
	EndIf

	//Verifica se o pedido faz parte de integracao
	//e nao possui nenhum faturamento e manda o evento
	//de exclusao.
	If FindFunction('GETROTINTEG') .And. FWHasEAI("MATA410",.T.,,.T.) .AND. nTotElim == 0
		FwIntegDef( 'MATA410' )
	EndIf
	End Transaction

Return
