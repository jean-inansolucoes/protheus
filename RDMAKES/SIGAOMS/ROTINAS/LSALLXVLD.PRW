#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TB410NVL ºAutor  ³Lincoln Rossetto    º Data ³  23/11/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Arquivo com todas as validações do Módulo de OMS.          º±±
±±ºDesc.     ³ rotinas.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A410VLD1 ºAutor  ³Alexandre Longihnottiº Data ³  29/05/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verificações do Cliente/Loja para verificar se existem pe- º±±
±±º          ³ didos em aberto.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA410 - PEDIDO DE VENDA                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A410VLD0()
	************************
	Local lRet 			:= .T.
	Local lRetira    := .F.
	Local dVlLim 		:= 0
	Local cDtLim 		:= ctod("  /  /  ")
	Local cMV_VLLCRED   := GetMV("MV_VLLCRED")
	Local cAliasTMP  	:= GetNextAlias()
	Local hEnter	 	:= CHR(10)+CHR(13)
	Local nSoma 		:= 0
	Local cFunc 		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FUNC")
	Local nLimCred 		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_LC")
	Local cFunAtivo		:= POSICIONE("SRA",1,xFilial("SE1")+SA1->A1_X_FUNC,"RA_SITFOLH")
	Local cEmailBoleto  := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_MAILB")
	Local cFormaPag  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FORMA")
	Local cCondPgto  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")

	Local cMV_USERREC:= SuperGetMV("MV_USERREC",,"")	//-- USUARIOS da recepcao com permissão pra usar tabela direta
	Local _aAreaSA1		:= SA1->(GetArea())
	Local cMV_TOPBONI   := AllTRIM(GetMV("MV_TOPBONI"))  // Tipos de Oeperações de Bonificação
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Operações de Venda
	Local nPosPrd   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO"  } )
	/*Local cTes
	Local nOper*/
	Local nX := 0

	If (IsInCallStack( "MATA311" )) // tp de operação transferencia entre filiais
		M->C5_OPER := '64'
	EndIf

	If ( AllTrim(cUserName) $ AllTrim(cMV_USERREC) .AND. cCondPgto != "902" .AND. Empty( cFunc ) ) .OR. !(M->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN))
		lRetira    := .T.
	EndIf

	If FieldPos("A1_X_CANAL") > 0 .AND. !Empty(M->C5_LOJACLI) .AND. M->C5_TIPO == "N" .AND. M->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN)
		If Empty(A1_X_CANAL)
			U_LSSHWHLP( "Atenção !", "Cliente não vinculado a nenhum Canal de Venda!", "É obrigatório o preenchimento do Canal de Venda no Cadastro do Cliente!" )
		EndIf
	EndIf



	If !Empty(M->C5_LOJACLI)
		M->C5_LOJAENT := M->C5_LOJACLI
		If Empty( cFunc )
		
		dVlLim := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_LC")
		cDtLim := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VENCLC")
		
			If(cMV_VLLCRED) .AND. cCondPgto != "902" .AND. !lRetira .and. M->C5_OPER $ cMV_TOPEVEN .and. !IsInCallStack("U_FLXFAT03")
				If ( ( dVlLim <= 0 .Or. cDtLim < DDATABASE .Or. cDtLim == ctod("  /  /  ") .Or. (Empty(Alltrim(cEmailBoleto)) .And. Alltrim(cFormaPag)=="BOL" ) ) .And. ( M->C5_CLIENTE != "05341357 " ) )
					If (Empty(Alltrim(cEmailBoleto)) .And. Alltrim(cFormaPag)=="BOL" )
					U_LSSHWHLP( "Atenção !", "A forma de pagamento desse cliente é Boleto e o mesmo não possiu um E-mail para recebimento, será impossível confirmar o Pedido!", "Solicite maiores informações ao setor de crédito!" )
					
					Else
			        U_LSSHWHLP( "Atenção !", "Limite de crédito do Cliente VENCIDO ou ZERADO!, Caso o Tipo de Operação seja VENDA será impossível confirmar o Pedido!", "Solicite maiores informações ao setor de crédito!" )
					Endif
				EndIf
			
			Elseif !lRetira
		
				M->C5_FECENT 	:= DDATABASE
			
				M->C5_X_SLDPR	:= iif( findFunction( 'U_LTTRG004'), U_LTTRG004(M->C5_CLIENTE,M->C5_LOJACLI,DDATABASE,U_LSTRGDTV(DDATABASE,POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND"))), 0)
		
			ElseIf M->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN)
			
				M->C5_FECENT 	:= DDATABASE
			
			EndIf
		
		Else
		
			If !(cFunAtivo $ "D/A")
			
		
				M->C5_FECENT 	:= DDATABASE
			
				M->C5_X_FUNC    := cFunc
			
				cQuery := "	SELECT 	SE1.R_E_C_N_O_               					   			" + hEnter
				cQuery += "	FROM " + RetSqlName("SE1") + " SE1						  			" + hEnter
				cQuery += "	WHERE    SE1.E1_FILIAL     = '" + xFilial("SC5") + "' 	  			" + hEnter
				cQuery += "	AND      SE1.E1_CLIENTE    = '" + M->C5_CLIENTE +"'   		 		" + hEnter
				cQuery += "	AND      SE1.E1_LOJA       = '" + M->C5_LOJACLI +"'					" + hEnter
				cQuery += "	AND      SE1.E1_SALDO      > 0										" + hEnter
				cQuery += "	AND 	 SE1.D_E_L_E_T_   != '*' 									" + hEnter
			
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
				While !(cAliasTMP)->(EOF())
				dbSelectArea("SE1")
				SE1->(dbGoTo((cAliasTMP)->R_E_C_N_O_))
				nSoma += SE1->E1_SALDO
				
				(cAliasTMP)->(dbSkip())
				Enddo
			(cAliasTMP)->(dbCloseArea())
			
			//Na Seleção do Cliente Barra aqui!
				If !( nLimCred > nSoma )
				
				ShowHelpDlg( "Pedido não permitido",;
				{ "Não foi possivel incluir o pedido de venda pois ultrapassou o limite de crédito: " + chr(10) + chr(13) + ;
				Transform( nLimCred, "@E 9,999.99" ) }, 5,;
				{ "1.) Compras até o momento:" + Transform( nSoma, "@E 9,999.99" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
				"2.) O saldo é recomposto após o fechamento e integração da Folha mensal pelo RH!."}, 5)
				lRet := .F.
				Else
					If (nLimCred - nSoma < 100)
					ApMsgInfo("O Saldo disponível para compras é de :   " + chr(10) + chr(13) + ;
					Transform( nLimCred - nSoma, "@E 9,999.99" ) )
					EndIf
				EndIf
			
			Else
			Alert("Funcionário demitido ou Afastado, Impossível Prosseguir!")
			lRet := .F.
			EndIf
		
		EndIf

	EndIf

	U_LS410SCV() 

	If Empty(lRet)
	lRet := .T.
	EndIf
	RestArea(_aAreaSA1)

	If lRet .AND. !Empty(M->C5_LOJACLI)
		For nX := 1 To Len( aCols )
			If ( AllTrim(aCols[ nX ][ nPosPrd ]) != "" )
				/*aCols[ nX ][ nPosOPER ]  	:= M->C5_OPER
				aCols[ nX ][ nPosTES ] 	 	:= MaTesInt(2,M->C5_OPER,M->C5_CLIENTE,M->C5_LOJACLI,If(M->C5_TIPO$'DB',"F","C"),(aCols[ nX ][ nPosPrd ]),) 
				aCols[ nX ][ nPosCLASFIS ]  := CodSitTri()*/
				If ExistTrigger('C6_PRODUTO')
					RunTrigger(2,nX,nil,,'C6_PRODUTO')
				Endif
			Endif
		Next
	
	EndIf

	If M->C5_CLIENTE = '05341357' .AND. M->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN) .and. !IsInCallStack( "MATA311" )
		Alert("Tipo de operação não pode ser de Venda para uma filial!")
		lRet := .F.
	EndIf
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A410VLD1 ºAutor  ³Alexandre Longihnottiº Data ³  29/05/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verificações do Cliente/Loja para verificar se existem pe- º±±
±±º          ³ didos em aberto.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA410 - PEDIDO DE VENDA                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A410VLD1()
	************************
	Local lRet 			:= .T.
	Local lRetira    := .F.
	Local dVlLim 		:= 0
	Local cDtLim 		:= ctod("  /  /  ")
	Local cMV_VLLCRED   := GetMV("MV_VLLCRED")
	Local cAliasTMP  	:= GetNextAlias()
	Local hEnter	 	:= CHR(10)+CHR(13)
	Local nSoma 		:= 0
	Local cFunc 		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FUNC")
	Local nLimCred 		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_LC")
	Local cFunAtivo		:= POSICIONE("SRA",1,xFilial("SE1")+SA1->A1_X_FUNC,"RA_SITFOLH")
	Local cEmailBoleto  := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_MAILB")
	Local cFormaPag  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FORMA")
	Local cCondPgto  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")
	Local cMV_USERREC:= SuperGetMV("MV_USERREC",,"")	//-- USUARIOS da recepcao com permissão pra usar tabela direta
	Local _aAreaSA1		:= SA1->(GetArea())
	Local cMV_TOPBONI   := AllTRIM(GetMV("MV_TOPBONI"))  // Tipos de Oeperações de Bonificação
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Operações de Venda
	Local cMV_TOPEPER   := AllTRIM(GetMV("MV_TOPEPER"))   // Tipos de Operações de Venda
	Local nPosPrd   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO"  } )
	Local nX := 0



	If ( AllTrim(cUserName) $ AllTrim(cMV_USERREC) .AND. cCondPgto != "902" .AND. Empty( cFunc ) ) .OR. !(M->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN))
		lRetira    := .T.
	EndIf

	If FieldPos("A1_X_CANAL") > 0 .AND. !Empty(M->C5_LOJACLI) .AND. M->C5_TIPO == "N" .AND. M->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN) .and. !IsInCallStack( "U_FLXFAT03" )
		If Empty(A1_X_CANAL)
			U_LSSHWHLP( "Atenção !", "Cliente não vinculado a nenhum Canal de Venda!", "É obrigatório o preenchimento do Canal de Venda no Cadastro do Cliente!" )
		EndIf
	EndIf

	If !Empty(M->C5_LOJACLI) .and. !IsInCallStack( "U_FLXFAT03" )
		M->C5_LOJAENT := M->C5_LOJACLI
		If Empty( cFunc )

			dVlLim := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_LC")
			cDtLim := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VENCLC")

			If(cMV_VLLCRED) .AND. cCondPgto != "902" .AND. !lRetira .and. M->C5_OPER $ cMV_TOPEVEN
				If ( ( dVlLim <= 0 .Or. cDtLim < DDATABASE .Or. cDtLim == ctod("  /  /  ") .Or. (Empty(Alltrim(cEmailBoleto)) .And. Alltrim(cFormaPag)=="BOL" ) ) .And. ( M->C5_CLIENTE != "05341357 " ) )
					If (Empty(Alltrim(cEmailBoleto)) .And. Alltrim(cFormaPag)=="BOL" )
						U_LSSHWHLP( "Atenção !", "A forma de pagamento desse cliente é Boleto e o mesmo não possiu um E-mail para recebimento, será impossível confirmar o Pedido!", "Solicite maiores informações ao setor de crédito!" )

					Else
						U_LSSHWHLP( "Atenção !", "Limite de crédito do Cliente VENCIDO ou ZERADO!, Caso o Tipo de Operação seja VENDA será impossível confirmar o Pedido!", "Solicite maiores informações ao setor de crédito!" )
					Endif
				EndIf

			Elseif !lRetira

				M->C5_FECENT 	:= DDATABASE

				M->C5_X_SLDPR	:= iif( FindFunction('U_LTTRG004'), U_LTTRG004(M->C5_CLIENTE,M->C5_LOJACLI,DDATABASE,U_LSTRGDTV(DDATABASE,POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND"))),0)

			ElseIf M->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN)

				M->C5_FECENT 	:= DDATABASE

			EndIf

		Else

			If !(cFunAtivo $ "D/A")


				M->C5_FECENT 	:= DDATABASE

				M->C5_X_FUNC    := cFunc

				cQuery := "	SELECT 	SE1.R_E_C_N_O_               					   			" + hEnter
				cQuery += "	FROM " + RetSqlName("SE1") + " SE1						  			" + hEnter
				cQuery += "	WHERE    SE1.E1_FILIAL     = '" + xFilial("SC5") + "' 	  			" + hEnter
				cQuery += "	AND      SE1.E1_CLIENTE    = '" + M->C5_CLIENTE +"'   		 		" + hEnter
				cQuery += "	AND      SE1.E1_LOJA       = '" + M->C5_LOJACLI +"'					" + hEnter
				cQuery += "	AND      SE1.E1_SALDO      > 0										" + hEnter
				cQuery += "	AND 	 SE1.D_E_L_E_T_   != '*' 									" + hEnter

				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

				dbSelectArea(cAliasTMP)
				(cAliasTMP)->(dbGoTop())
				While !(cAliasTMP)->(EOF())
					dbSelectArea("SE1")
					SE1->(dbGoTo((cAliasTMP)->R_E_C_N_O_))
					nSoma += SE1->E1_SALDO

					(cAliasTMP)->(dbSkip())
				Enddo
				(cAliasTMP)->(dbCloseArea())

				//Na Seleção do Cliente Barra aqui!
				If !( nLimCred > nSoma )

					ShowHelpDlg( "Pedido não permitido",;
						{ "Não foi possivel incluir o pedido de venda pois ultrapassou o limite de crédito: " + chr(10) + chr(13) + ;
						Transform( nLimCred, "@E 9,999.99" ) }, 5,;
						{ "1.) Compras até o momento:" + Transform( nSoma, "@E 9,999.99" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
						"2.) O saldo é recomposto após o fechamento e integração da Folha mensal pelo RH!."}, 5)
					lRet := .F.
				Else
					If (nLimCred - nSoma < 100)
						ApMsgInfo("O Saldo disponível para compras é de :   " + chr(10) + chr(13) + ;
							Transform( nLimCred - nSoma, "@E 9,999.99" ) )
					EndIf
				EndIf

			Else
				Alert("Funcionário demitido ou Afastado, Impossível Prosseguir!")
				lRet := .F.
			EndIf

		EndIf


	EndIf
	If !IsInCallStack( "U_FLXFAT03" )
		U_LS410SCV()
	Endif

	If Empty(lRet)
		lRet := .T.
	EndIf

	If SM0->M0_CGC == SA1->A1_CGC .AND. !(M->C5_OPER $ cMV_TOPEPER)
		lRet := .F.
		Alert("A Filial de Destino deve ser Diferente da Filial de Origem!")
	EndIf

	RestArea(_aAreaSA1)

	If lRet .AND. !Empty(M->C5_LOJACLI) .and. !IsInCallStack( "U_FLXFAT03" )
		For nX := 1 To Len( aCols )
			If ( AllTrim(aCols[ nX ][ nPosPrd ]) != "" )
				/*aCols[ nX ][ nPosOPER ]  	:= M->C5_OPER
				aCols[ nX ][ nPosTES ] 	 	:= MaTesInt(2,M->C5_OPER,M->C5_CLIENTE,M->C5_LOJACLI,If(M->C5_TIPO$'DB',"F","C"),(aCols[ nX ][ nPosPrd ]),) 
				aCols[ nX ][ nPosCLASFIS ]  := CodSitTri()*/
				If ExistTrigger('C6_PRODUTO')
					RunTrigger(2,nX,nil,,'C6_PRODUTO')
				Endif
			Endif
		Next
		If ( AllTrim(aCols[ 1 ][ nPosPrd ]) != "" )
			GETDREFRESH()
     		SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
     		oGetDad:Refresh()
     		A410LinOk(oGetDad)
		EndIf
	EndIf



Return( lRet )


//**************************************************************************************
//**  VALIDA DUPLICIDADE DOS PRODUTOS NO PV
//**************************************************************************************

User Function A410VLD2()
************************
//Local nPosTES   := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES"  } )
Local nPosPrd   := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO"  } )
Local nPosItem  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_ITEM" } )
Local lRet      := .T.
Local nX := 0

	For nX := 1 To Len( aCols )
		If !aCols[ nX ][ Len( aHeader ) + 1 ]
			If nX <> n
				If ( aCols[ nX ][ nPosPrd ] == M->C6_PRODUTO )
			   lRet := .F.
			   Aviso( "Atenção", "Ja existe o produto informado no item [" + aCols[ nX ][ nPosItem ] + "]", { "OK" } )
			   exit
				Endif
			Endif
		Endif
	Next

	If lRet
		If Empty( M->C5_OPER )
		Aviso( "Atenção", "Informe o Tipo de Operação no campo acima!!!", { "OK" } )
		lRet := .F.
		EndIf
	EndIf

Return( lRet )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Tipos de Operação                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function A410VLD3()
************************

//Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))  // Tipos de Oeperações de Venda
//Local lFlag := .T.
Local lRet := .T.
Local nX := 0
Local nPosOPER   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_OPER"  } )
Local nPosTES   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES"  } )
Local nPosCLASFIS    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_CLASFIS"  } )
Local nPosPrd   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO"  } )
Local cTes
Local nOper

// ignora execução da alteração da operação quando a origem do pedido for do ICmais
	if !IsInCallStack( "U_ICGERPED" )
		If ApMsgNoYes("Confirma alteracao do Tipo de Operacao?")     
			If !(M->C5_TIPO$'DB') .AND. Empty(M->C5_OPER)
			lRet := .F.
			ElseIf !Empty(M->C5_OPER)
			 lRet := ExistCpo("SX5","DJ"+M->C5_OPER)    
			 //IIF(ISINCALLSTACK("MATA310").OR.ISINCALLSTACK("MATA311"),'60','01')                                                                                                                                                         
			EndIf

			For nX := 1 To Len( aCols )
				If ( ( aCols[ nX ][ nPosOPER ] != M->C5_OPER ) .And. AllTrim(aCols[ nX ][ nPosPrd ]) != "" )
			nOper := aCols[ nX ][ nPosOPER ]
			cTes  := aCols[ nX ][ nPosTES ] 
			aCols[ nX ][ nPosOPER ]  	:= M->C5_OPER
			aCols[ nX ][ nPosTES ] 	 	:= MaTesInt(2,M->C5_OPER,M->C5_CLIENTE,M->C5_LOJACLI,If(M->C5_TIPO$'DB',"F","C"),(aCols[ nX ][ nPosPrd ]),) 
			aCols[ nX ][ nPosCLASFIS ]  := CodSitTri()
					If ExistTrigger('C6_PRODUTO')
				RunTrigger(2,nX,nil,,'C6_PRODUTO')
					Endif
					If ( aCols[ nX ][ nPosTES ] == cTes )
				aCols[ nX ][ nPosTES ] 	 	:= "   "
				aCols[ nX ][ nPosCLASFIS ]  := "    "
					EndIf
				Endif
			Next
		Else
			lRet := .F.     
		EndIf
		
	endif

Return ( lRet ) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zera preços do acols da SC6                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function A410VLD4()
************************

Local nPrcVen   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRCVEN"  } )
Local nX := 0
//Local cTes
//Local nOper
	For nX := 1 To Len( aCols )
    		aCols[ nX ][ nPrcVen ] 	 	:= 0
	Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A410VLD5 ºAutor  ³Alexandre Longhinottiº Data ³  29/05/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica limite de crédito do cliente quando este for um   º±±
±±º          ³ Funcionário. (Compara a soma dos saldos da SE1 com o campo º±±
±±º			 ³ A1_LC)                   		                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA410 - PEDIDO DE VENDA                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function A410VLD5()
	***********************
	Local cAliasTMP  	:= GetNextAlias()
	Local hEnter	 	:= CHR(10)+CHR(13)
	Local nSoma 	 	:= 0
	Local cFunc 	 	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FUNC")
	Local nLimCred 		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_LC")
	Local VLimCred 		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VENCLC")
//Local nTotalPed 	:= 0
	Local lRet 			:= .T.
	Local nTotal   		:= 0
	Local nPrcItem   	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_VALOR"  } )
//Local cTpCliente	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TIPO")
	Local cEmailBoleto  := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_MAILB")
	Local cFormaPag  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FORMA")
	Local cCondPgto  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")
	Local cMV_TOPBONI   := AllTRIM(GetMV("MV_TOPBONI"))  // Tipos de Oeperações de Bonificação
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Operações de Venda
	Local nX := 0

	If !Empty( cFunc ) .And. cCondPgto != "902"

		cQuery := "	SELECT 	SE1.R_E_C_N_O_               					   			" + hEnter
		cQuery += "	FROM " + RetSqlName("SE1") + " SE1						  			" + hEnter
		cQuery += "	WHERE    SE1.E1_FILIAL     = '" + xFilial("SC5") + "' 	  			" + hEnter
		cQuery += "	AND      SE1.E1_CLIENTE    = '" + M->C5_CLIENTE +"'   		 		" + hEnter
		cQuery += "	AND      SE1.E1_LOJA       = '" + M->C5_LOJACLI +"'					" + hEnter
		cQuery += "	AND      SE1.E1_SALDO      > 0										" + hEnter
		cQuery += "	AND 	 SE1.D_E_L_E_T_   != '*' 									" + hEnter

		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
			dbSelectArea("SE1")
			SE1->(dbGoTo((cAliasTMP)->R_E_C_N_O_))
			nSoma += SE1->E1_SALDO

			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())

		For nX := 1 To Len( aCols )
			nTotal += aCols[ nX ][ nPrcItem ]
		Next

		If (nLimCred - nSoma < nTotal)
			ShowHelpDlg( "Impossível Prosseguir",;
				{ "O pedido de venda ultrapassou o limite de crédito disponível: " + chr(10) + chr(13) + ;
				Transform( nLimCred - nSoma, "@E 9,999.99" ) }, 5,;
				{ "1.) Valor do Pedido:" + Transform( nTotal, "@E 9,999.99" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
				"2.) O saldo é recomposto após o fechamento e integração da Folha mensal pelo RH!."}, 5)
			lRet := .F.
		EndIf

	ElseIf nLimCred <= 0 .AND. VLimCred <= DDATABASE .AND. M->C5_TIPO == "N" .AND. SC5->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN)
		if isBlind()
			Help( ,, 'Atencao',, 'Limite de credito vencido ou zerado!', 1, 0, NIL, NIL, NIL, NIL, NIL, { 'Solicite maiores informacoes no setor de credito!' } )
		else
			U_LSSHWHLP( "Atenção !", "Limite de crédito Vencid ou Zerado, será impossível confirmar o Pedido!", "Solicite maiores informações ao setor de crédito!" )
		endif
		lRet := .F.
	ElseIf (Empty(Alltrim(cEmailBoleto)) .And. Alltrim(cFormaPag)=="BOL" .AND. M->C5_TIPO == "N") .AND. SC5->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN)
		if isBlind()
			Help( ,, 'Atencao',, 'A forma de pagamento desse cliente é Boleto e o mesmo não possiu um E-mail para recebimento, será impossível confirmar o Pedido!', 1, 0, NIL, NIL, NIL, NIL, NIL, { 'Solicite maiores informações ao setor de crédito!' } )
		else
			U_LSSHWHLP( "Atenção !", "A forma de pagamento desse cliente é Boleto e o mesmo não possiu um E-mail para recebimento, será impossível confirmar o Pedido!", "Solicite maiores informações ao setor de crédito!" )
		endif
		lRet := .F.
	EndIf


Return ( lRet )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ busca vendedor CASO NAO ACHEO SELECIONA VENDA DIRETA                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function A410VLD6()
	************************

	Local cVendCli	:= POSICIONE( "SA1",1,XFILIAL( "SA1" ) + M->C5_CLIENTE + M->C5_LOJACLI,"SA1->A1_VEND")
	Local cVEndFil	:= AllTRIM(GetMV("MV_VENDIR"))
	Local cRet := ""

	If !Empty(cVendCli)
		cRet := cVendCli

	Else
		cRet := cVEndFil

	EndIf

Return cRet


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TES do acols da SC6                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function A410VLD7()
	************************
	Local lRet := .T.
	Local nX := 0
	Local nPosOPER   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_OPER"  } )
	Local nPosTES   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES"  } )
	Local nPosCLASFIS    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_CLASFIS"  } )
	Local nPosPrd   	 := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO"  } )
	Local cTes
	Local nOper

// ignora execução da alteração da operação quando a origem do pedido for do ICmais
	if !IsInCallStack( "U_ICGERPED" )

		If !(M->C5_TIPO$'DB') .AND. Empty(M->C5_OPER)
			lRet := .F.
		ElseIf !Empty(M->C5_OPER)
			lRet := ExistCpo("SX5","DJ"+M->C5_OPER)
			//IIF(ISINCALLSTACK("MATA310").OR.ISINCALLSTACK("MATA311"),'60','01')
		EndIf
		M->C5_OPER := M->C6_OPER
		For nX := 1 To Len( aCols )
			If ( ( aCols[ nX ][ nPosOPER ] != M->C5_OPER ) .And. AllTrim(aCols[ nX ][ nPosPrd ]) != "" )
				nOper := aCols[ nX ][ nPosOPER ]
				cTes  := aCols[ nX ][ nPosTES ]
				aCols[ nX ][ nPosOPER ]  	:= M->C5_OPER
				aCols[ nX ][ nPosTES ] 	 	:= MaTesInt(2,M->C5_OPER,M->C5_CLIENTE,M->C5_LOJACLI,If(M->C5_TIPO$'DB',"F","C"),(aCols[ nX ][ nPosPrd ]),)
				aCols[ nX ][ nPosCLASFIS ]  := CodSitTri()
				If ExistTrigger('C6_PRODUTO')
					RunTrigger(2,nX,nil,,'C6_PRODUTO')
				Endif
				If ( aCols[ nX ][ nPosTES ] == cTes )
					aCols[ nX ][ nPosTES ] 	 	:= "   "
					aCols[ nX ][ nPosCLASFIS ]  := "    "
				EndIf
			Endif
		Next

	endif

Return ( lRet )



	*-------------------------------*
User Function LSTRGDTV(dDtMov, cCond)
	*-------------------------------*
//retorna vencimento baseado na condição de pagamento p/ venda p/ produtor
	Local dRET := ddatabase
//Local aArea := GetArea()

	If Alltrim(cCond) == NIL .OR. Alltrim(cCond) == ""
		cCond := "902"
	EndIf

	If dDtMov != NIL .And. dDtMov != ctod("  /  /  ")
		dRET := dDtMov
	EndIf

	aPARCELA := Condicao(1,cCond,,dRET)
	dRET := aPARCELA[01][01]

Return (dRET)

	*-------------------------------*
User Function LSCONSALDO()
	*-------------------------------*
//retorna saldo do produtor de leite para o PE MA030ROT
	Local nSaldo := 0

	Local cMsg
	Local cCaption := "Saldo Produtor"


	If SA1->A1_COND == "902"
		nSaldo := iif( findFunction('U_LTTRG004'), U_LTTRG004(SA1->A1_COD,SA1->A1_LOJA,DDATABASE,U_LSTRGDTV(DDATABASE,SA1->A1_COND)),0)
		If nSaldo > 0
			cMsg :=  "Saldo do Produtor no período: "  + chr(10) + chr(13) + "R$ "+  Transform( nsALDO, "@E 9,999.99")
		Else
			cMsg :=  "Saldo do Produtor no período: "  + chr(10) + chr(13) + "R$ "+  Transform( nsALDO, "@E 9,999.99" + chr(10) + chr(13) + "Verifique com o setor de fomento se poderá efetuar uma venda!")
		EndIf
		ApMsgInfo(cMsg, cCaption)
	EndIf

Return

/************************************************/
	*-------------------------------*
User Function VALBOLETO()
	*-------------------------------*
	Local cForma := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FORMA")
	Local cRet 		:= ""
	Local cMailBoleto := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_MAILB")
	Local cProd 		:= Alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TIPO"))
	Local cFunc		:= Alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FUNC"))


	If !Empty(M->C5_CLIENTE) .AND. cForma == "BOL"
		If Empty(cMailBoleto) .AND. cProd != "L" .AND. Empty(cFunc)
			ShowHelpDlg( "Atenção!!!",;
				{ "Este Cliente não possui email para recebimento de boletos em seu cadastro, ou o Cliente nao foi selecionado! " + chr(10) + chr(13) }, 5,;
				{ "1.) Inclua o email para recebimento do boleto no cadastro do cliente" + chr(10) + chr(13) + chr(10) + chr(13) + ;
				"    Pasta: Adm/Fin, Campo: Email Boleto"}, 5)
			cRet := ""

		Else
			cRet := "BOL"
		EndIf
	Else
		cRet := cForma
	EndIf

Return cRet

//============================================================================\
/*/{Protheus.doc}TB410NVL
  ==============================================================================
	@description
	Descrição da função

	@author Alexandre Longhinotti <ti@tresbarras.ind.br>
	@version 1.0
	@since 11/11/2020

/*/
//============================================================================\
User Function TB410NVL()
	Local aAreaTMP := GetArea()
	Local lRet := ""

	While .T.
		dbSelectArea("ZAI")
		dbSetOrder(1)
		If dbSeek ( xFilial("ZAI") + SC5->C5_NUM )
			If !Empty(ZAI->ZAI_NIVEL)

			Else
				Exit
			EndIf
		Else
			Exit
		EndIf
	End

	RestArea(aAreaTMP)


Return ( lRet )
// FIM da Funcao TB410NVL
//==============================================================================


//============================================================================\
/*/{Protheus.doc}TBEstLib
  ==============================================================================
	@description
	Descrição da função
	Estorna todas as Liberações do Pedido de Venda
	@author Alexandre Longhinotti <ti@tresbarras.ind.br>
	@version 1.0
	@since 21/12/2020

/*/
//============================================================================\
user function TBEstLib( )
	local cFilSC5 := xFilial("SC5")
	local cFilSC6 := xFilial("SC6")

	If Empty(ALLTRIM(SC5->C5_X_SIMUL)) .OR. IsInCallStack( "U_FLXFAT03" )
		If ApMsgNoYes("Confirma o Estorno das liberações do do Pedido de Venda?")
			if SC5->( dbSeek( cFilSC5 + SC5->C5_NUM ) )
				SC6->( dbGoTop() )
				SC6->( dbSeek( cFilSC6 + SC5->C5_NUM ) )
				while !SC6->(EOF()) .AND. SC6->C6_FILIAL == cFilSC6 .AND. SC6->C6_NUM == SC5->C5_NUM
					// tenta estornar as liberações do item

					MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil)
					SC6->( dbSkip() )
				enddo
			endif
			u_TBRESERV()
		EndIf
	else
		Aviso( "Atenção", "As Liberações não podem ser estornadas pois está em uma carga, Solicite o estorno da carga!", { "OK" } )
	EndIf

return


// FIM da Funcao TBEstLib
//==============================================================================

//============================================================================\
user function TBBUSCAPV( )
	local cFilSC5 := xFilial("SC5")
	local cFilSC9 := xFilial("SC9")
	local cBlEst := ""
	local cBlCre := ""
	local cCaption := "Status do Pedido de Venda " + SC5->C5_NUM
	local lLib := .F.
	local lGer := .F.
	local cNivel := ""
	local nFiscal := ""
	local cMsg := ""
	local lRej	:= .F.
	local cUserRej := ''
	local nI
	local _cMsgLib := ''
	Local _aBlqs    := {}
	Local _aMots    := {}
	Local _nPosMot  := 0

	if SC5->( dbSeek( cFilSC5 + SC5->C5_NUM ) )
		nFiscal := SC5->C5_NOTA
		SC9->( dbGoTop() )
		SC9->( dbSeek( cFilSC9 + SC5->C5_NUM ) )
		while !SC9->(EOF()) .AND. SC9->C9_FILIAL == cFilSC9 .AND. SC9->C9_PEDIDO == SC5->C5_NUM
			If Empty(cBlEst)
				cBlEst := SC9->C9_BLEST
			ENDIF
			If Empty(cBlCre)
				cBlCre := SC9->C9_BLCRED
			EndIf
			lLib := .T.
			SC9->( dbSkip() )
		enddo
	endif


	DBSelectArea( 'ZAI' )
	DAI->(dbGoTop())
	ZAI->( DBSetOrder( 1 ) )
	if ZAI->( DBSeek( FWxFilial( 'ZAI' ) + SC5->C5_NUM ) )
		// Percorre a ZAI enquanto o numero do pedido for igual
		While !ZAI->( EOF() ) .and. ZAI->ZAI_FILIAL + ZAI->ZAI_NUM == FWxFilial( 'ZAI' ) + SC5->C5_NUM
			If ZAI->ZAI_MOTBLQ <> "1" .and. ZAI->ZAI_DTOPER == CtoD("//") .and. ZAI->ZAI_OPER <>  "2"
				lGer := .T.
			EndIf
			ZAI->( DBSkip() )
		end
	endif

	DBSelectArea( 'ZAI' )
	DAI->(dbGoTop())
	ZAI->( DBSetOrder( 1 ) )
	if ZAI->( DBSeek( FWxFilial( 'ZAI' ) + SC5->C5_NUM ) )
		// Percorre a ZAI enquanto o numero do pedido for igual
		While !ZAI->( EOF() ) .and. ZAI->ZAI_FILIAL + ZAI->ZAI_NUM == FWxFilial( 'ZAI' ) + SC5->C5_NUM
			If ZAI->ZAI_OPER =  "2"
				lRej	:= .T.
				cUserRej := UPPER(ALLTRIM(FwGetUserName(ZAI->ZAI_USER)))
			EndIf
			ZAI->( DBSkip() )
		end
	endif

	cNivel := U_LTBNIVELIB()

	If lGer
		ZAI->(dbSetOrder(1))
		ZAI->(dbGoTop())
		ZAI->(dbseek(xFilial("ZAI")+SC5->C5_NUM))
		While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial("ZAI")+SC5->C5_NUM
			If Empty(ZAI->ZAI_OPER)
				If ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9'
					aAdd(_aBlqs,ZAI->(Recno()))
					_nPosMot := aScan(_aMots,{|x| x==ZAI->ZAI_MOTBLQ})
					If _nPosMot <= 0
						aAdd(_aMots,ZAI->ZAI_MOTBLQ)
					EndIf
				EndIf
			EndIf
			ZAI->(dbSkip())
		EndDo
		If Len(_aMots) > 0
			_cMsgLib := "Pedido de venda com bloqueio de Gerência pelos motivos abaixo:" +chr(10) +chr(13)

			For nI := 1 To Len(_aMots)
				If _aMots[nI] == '1'
					_cMsgLib += "Bloqueio por Desconto" + chr(10) + chr(13)
				ElseIf _aMots[nI] == '2'
					_cMsgLib += "Pedido fora do prazo de validade" + chr(10) + chr(13)
					_lblqVal := .T.
				ElseIf _aMots[nI] == '3'
					_cMsgLib += "Operação tipo Bonificação, Doação ou Amostra Grátis" + chr(10) + chr(13)
				ElseIf _aMots[nI] == '4'
					_cMsgLib += "Comissão no Ped. é diferente da definida no vendedor" + chr(10) + chr(13)
				ElseIf _aMots[nI] == '5'
					_cMsgLib += "Vendedor informado no pedido difere do preenchido no cliente" + chr(10) + chr(13)
				ElseIf _aMots[nI] == '6'
					_cMsgLib += "Peso do pedido não atinge o mínimo para frete CIF" + chr(10) + chr(13)
				EndIf
			Next nI
		EndIf
	EndIf

	If !Empty(cNivel) .and. SC5->C5_BLQ == '1'
		cMsg := "Pedido de venda com bloqueio de Regra/Desconto!" + chr(10) + chr(13) + "Nível: " + cNivel + " ou superior!"
	EndIf

	If !Empty(cMsg)
		ApMsgInfo(cMsg, cCaption)
	ElseIf ((cBlEst == '10' .OR. cBlCre == '10' .OR. !Empty(nFiscal))) .and.  !lRej
		ApMsgInfo("Pedido de venda já faturado!" + chr(10) + chr(13) + "NFº " +  nFiscal, "Informação")
	ElseIf lGer
		ApMsgInfo(_cMsgLib, cCaption)
	ElseIf lRej
		ApMsgInfo("Pedido Rejeitado por:" + chr(10) + chr(13) +  cUserRej, "Informação")
	ElseIf cBlCre $ '01/04/05/09'
		ApMsgInfo("Pedido de venda com bloqueio de crédito!", cCaption)
	ElseIf cBlEst == '02'
		ApMsgInfo("Pedido de venda com bloqueio de Estoque!", cCaption)
	ElseIf cBlEst == 'SP'
		ApMsgInfo("Pedido de venda em Separação!", cCaption)
	elseif !lLib
		ApMsgInfo("Pedido de venda ainda NÃO foi liberado!", cCaption)
	elseif lLib .AND. (Empty(cBlEst) .AND. Empty(cBlCre))
		ApMsgInfo("Pedido de venda LIBERADO!", cCaption)
	EndIf
return


// FIM da Funcao TBEstLib
//==============================================================================


//============================================================================\
/*/{Protheus.doc}LSALLXVLD
  ==============================================================================
	@description
	Descrição da função

	@author Alexandre Longhinotti <ti@tresbarras.ind.br>
	@version 1.0
	@since 04/02/2021

/*/
//============================================================================\
USER FUNCTION TBRESERV()
	**------------------------------------------------------------------**
	Local cFilSB1, cFilSB2, cFilSC9 := ""
	Private nReserv := 0


	cFilSB1 := "SB1->B1_COD >= '"+ AllTRIM(GetMV("MX_PRDRESI"))	+"' .AND. SB1->B1_COD <= '"+ AllTRIM(GetMV("MX_PRDRESF"))	+"' .AND. SB1->B1_MSBLQL = '2'		  "

	dbSelectArea("SB1")
	SET FILTER TO &(cFilSB1)
	SB1->(dbGoTop())
	While !SB1->(EOF())
		nReserv := 0
		cFilSC9 := "SC9->C9_FILIAL = '"+ xFilial("SC9")	+"' .AND. SC9->C9_LOCAL = '"+ SB1->B1_LOCPAD	+"' .AND. SC9->C9_PRODUTO = '"+ SB1->B1_COD	+"' .AND. SC9->C9_NFISCAL = '         ' .AND. SC9->C9_BLEST <> '02'		  "
		cFilSB2 := "SB2->B2_FILIAL = '"+ xFilial("SC9")	+"' .AND. SB2->B2_LOCAL = '"+ SB1->B1_LOCPAD	+"' .AND. SB2->B2_COD = '"+ SB1->B1_COD	+"'		  "

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
		SB1->(dbSkip())
	Enddo
	SET FILTER TO




	//Fim do acerto da Quantidade reservada na SB2

Return()
// FIM da Funcao LSALLXVLD
//==============================================================================

//============================================================================\
/*/{Protheus.doc}VLINCCLI
  ==============================================================================
	@description
	Descrição da função

	@author Alexandre Longhinotti <ti@trelac.com.br>
	@version 1.0
	@since 28/06/2021

/*/
//============================================================================\
User Function VLINCCLI()
	Local lRet:= .F.

	If M->A1_MSBLQL=="2" .or. (M->A1_VENCLC  > DDATABASE .AND. !Empty(M->A1_CONTA))
		lRet:= .T.
	EndIf


Return ( lRet )
// FIM da Funcao VLINCCLI
//==============================================================================


User Function VLDPRDVEN()
	Local lRet := .T.

	If !IsInCallStack("U_ICGERPED")
		dbSelectArea('DA1')
		DA1->(dbSetOrder(1))
		DA1->(dbGoTop())
		If !DA1->(dbSeek(xFilial('DA1')+M->C5_TABELA+M->C6_PRODUTO))
			If alltrim(Posicione('SB1',1,xFilial('SB1')+M->C6_PRODUTO,'B1_TIPO'))	== 'PA'
				MsgAlert("O produto digitado não existe na tabela de preços selecionada!" )
				lRet := .F.
			EndIf
		EndIf
	EndIf
Return lRet


User Function DValLote(cProd)
	Local cRet := ""

	dbSelectArea('SZA')
	SZA->(dbSetOrder(2))
	SZA->(dbGoTop())
	If SZA->(dbSeek("01LAT01"+cProd+M->C6_X_LOTE))
		cRet := " - VAL.: " + DTOC(SZA->ZA_DATVLD)
	EndIf

Return cRet
