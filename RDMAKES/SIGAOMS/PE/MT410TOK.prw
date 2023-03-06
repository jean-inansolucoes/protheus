#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT410TOK ºAutor  ³ Lincoln Rossetto   º Data ³  20/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável pela validação do preenchimento das for-º±±
±±º          ³ mas de pagamento no pedido de venda.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT410TOK()
	************************
	Local aArea      := SC5->( GetArea( ) )
	Local lRet       := .T.
	Local nEndereco1 := aScan( aGets,{ |x| Subs(x,9,08) == "C5_PESOL"   } )
	Local nEndereco2 := aScan( aGets,{ |x| Subs(x,9,09) == "C5_PBRUTO"  } )
	Local nEndereco3 := aScan( aGets,{ |x| Subs(x,9,10) == "C5_VOLUME1" } )
//Local nEndereco4 := aScan( aGets,{ |x| Subs(x,9,10) == "C5_VOLUME2" } )
	Local nEndereco5 := aScan( aGets,{ |x| Subs(x,9,10) == "C5_ESPECI1" } )
	Local nEndereco6 := aScan( aGets,{ |x| Subs(x,9,10) == "C5_ESPECI2" } )
	Local nEndereco7 := aScan( aGets,{ |x| Subs(x,9,10) == "C5_ESPECI3" } )
	Local nEndereco8 := aScan( aGets,{ |x| Subs(x,9,10) == "C5_ESPECI4" } )

	Local nPosDesc   := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_DESCONT" } )
	Local nPosQuant1 := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_QTDVEN"  } )
	Local nPosProd   := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRODUTO" } )
	Local aEspecie   := {  }
	Local cArqQry    := GetNextAlias()
	Local cCpoPesoL  := "B1_PESO"
	Local cCpoPesoB  := "B1_PESBRU"
	Local cQuery     := ""
	Local nPesoL     := 0
	Local nPesoB     := 0
	Local nQuantid   := 0
	Local nCapArm    := 0
	Local nCapVol1   := 0
//Local nCapVol2   := 0
	Local nFormas    := 0
//Local lRetOper   := .T.
	Local nX

	Local ndVLim := 0
	Local cDtLim := ctod("  /  /  ")
	Local lVlCred   := GetMV("MV_VLLCRED")
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))  // Tipos de Oeperações de Venda
	//Local cTpCliente	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TIPO")
	Local cCondPgto  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")
	Local _cCanal  		:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_CANAL")
	Local _nDesc		:= 0 // Maior desconto aplicado nos itens do PV --  DJONATA
	Local _nOpc 		:= PARAMIXB[1]
	Local _nAcordo  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_DESCF")


	If !IsInCallStack( "U_FLXFAT03" )
		/*If M->C5_DESCFI = 0 .AND. _nAcordo > 0
			 M->C5_DESCFI := _nAcordo
		EndIf*/

		IF M->C5_CONDPAG == '998' .and. ( empty(M->C5_DATA1) .AND. empty(M->C5_DATA2) .AND. empty(M->C5_DATA3) .AND. empty(M->C5_DATA4) )
			Help( ,, 'Atencao',, 'Foi utilizada um condição de pagamento variável.', 1, 0, NIL, NIL, NIL, NIL, NIL, { 'Defina a data de vencimento e valor na aba Financeiro!' } )
			lRet := .F.
		ENDIF

		If _nOpc == 1
			dbSelectArea('ZAI')
			ZAI->(dbSetOrder(1))
			ZAI->(dbGoTop())
			If ZAI->(dbSeek(xFilial('ZAI')+M->C5_NUM))
				While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial('ZAI')+M->C5_NUM
					RecLock('ZAI',.F.)
					ZAI->(dbDelete())
					ZAI->(MsUnlock())
					ZAI->(dbSkip())
				EndDo
			EndIf
		EndIf

		If Empty(_cCanal) .AND. M->C5_TIPO == "N"
			Help( ,, 'Atencao',, 'Cliente não está amarrado a nenhum canal de venda.', 1, 0, NIL, NIL, NIL, NIL, NIL, { 'Solicite revisão do cadastro do cliente!' } )
			Return .F.
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo do volume do Pedido.                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( "SB1" )
		SB1->( dBSetOrder( 1 ) )

		dBSelectArea( "SB5" )
		SB5->( dBSetOrder( 1 ) )

		For nX := 1 To Len ( aCols )
			If !aCols[ nX ][ Len( aHeader ) + 1 ]
				nQuantid := aCols[ nX ][ nPosQuant1 ]
				_nDesc   := Max(_nDesc,aCols[nX,nPosDesc])

				SB1->( dBGoTop( ) )
				If SB1->( MsSeek( xFilial( "SB1" ) + aCols[ nX ][ nPosProd ] ) )

					dBSelectArea( "SAH" )
					SAH->( dBSetOrder( 1 ) )
					SAH->( dBGoTop(  ) )
					SAH->( dBSeek( xFilial( "SAH" ) + SB1->B1_SEGUM ) )

					nPos := aScan( aEspecie, { |X| X[ 1 ] == SB1->B1_SEGUM } )

					If nPos == 0
						aAdd(  aEspecie, { SB1->B1_SEGUM, iif( Alltrim( SB1->B1_SEGUM ) == "KG", "UNIDADES", SAH->AH_DESCPO ) } )
					endif

					nPesoL   += ( SB1->( FieldGet( FieldPos( cCpoPesoL ) ) ) * nQuantid )
					nPesoB   += ( SB1->( FieldGet( FieldPos( cCpoPesoB ) ) ) * nQuantid )

					SB5->( dbGoTop( ) )
					If SB5->( MsSeek( xFilial( "SB5" ) + aCols[ nX ][ nPosProd ] ) )
						nCapArm := ( SB5->B5_ALTURLC * SB5->B5_LARGLC * SB5->B5_COMPRLC )
					EndIf

					nCapVol1 += ( nCapArm * nQuantid )

				Endif

			Endif
		Next

		nCapVol1 := IIF( ( nCapVol1 > 0 .And. nCapVol1 < 1 ), 1, nCapVol1 )

		If nCapVol1 > 0
			nAuxA := Int( nCapVol1 )
			nAuxB := Round( nCapVol1, 2 )
			If nAuxB > ( nAuxA + 0.50 )
				nCapVol1 := nAuxA + 1
			Endif
		Endif

		If nPesoL > 0
			M->C5_PESOL := nPesoL
			If nEndereco1 > 0
				aTela[Val(Subs(aGets[nEndereco1],1,2))][Val(Subs(aGets[nEndereco1],3,1))*2] := nPesoL
			EndIf
		Endif

		If nPesoB > 0
			M->C5_PBRUTO := nPesoB
			If nEndereco2 > 0
				aTela[Val(Subs(aGets[nEndereco2],1,2))][Val(Subs(aGets[nEndereco2],3,1))*2] := nPesoB
			EndIf
		Endif

		If nCapVol1 > 0
			M->C5_VOLUME1 := nCapVol1
			If nEndereco3 > 0
				aTela[Val(Subs(aGets[nEndereco3],1,2))][Val(Subs(aGets[nEndereco3],3,1))*2] := nCapVol1
			EndIf
		Endif

		For nX := 1 To Len( aEspecie )
			Do Case
			Case nX == 1
				M->C5_ESPECI1 := aEspecie[ nX ][ 2 ]
				If nEndereco5 > 0
					aTela[Val(Subs(aGets[nEndereco5],1,2))][Val(Subs(aGets[nEndereco5],3,1))*2] := aEspecie[ nX ][ 2 ]
				Endif

			Case nX == 2
				M->C5_ESPECI2 := aEspecie[ nX ][ 2 ]
				If nEndereco6 > 0
					aTela[Val(Subs(aGets[nEndereco6],1,2))][Val(Subs(aGets[nEndereco6],3,1))*2] := aEspecie[ nX ][ 2 ]
				Endif

			Case nX == 3
				M->C5_ESPECI3 := aEspecie[ nX ][ 2 ]
				If nEndereco7 > 0
					aTela[Val(Subs(aGets[nEndereco7],1,2))][Val(Subs(aGets[nEndereco7],3,1))*2] := aEspecie[ nX ][ 2 ]
				Endif

			Case nX == 4
				M->C5_ESPECI4 := aEspecie[ nX ][ 2 ]
				If nEndereco8 > 0
					aTela[Val(Subs(aGets[nEndereco8],1,2))][Val(Subs(aGets[nEndereco8],3,1))*2] := aEspecie[ nX ][ 2 ]
				Endif

			EndCase
		Next


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Formas de Pagamento                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Type( "aColsFor" ) <> "U" .And. Type( "aHeadFor" ) <> "U" .And. !ISINCALLSTACK( "MATA310" ) .And. M->C5_TIPO == "N" .And. M->C5_CLIENTE != "05341357"

			If Len( aColsFor ) > 0
				nPosForm := aScan( aHeadFor, {|x| AllTrim(x[2]) == "CV_FORMAPG" } )

				For nX := 1 To Len( aColsFor )
					If !aColsFor[ nX ][ Len( aHeadFor ) + 1 ]
						nFormas++
						If Empty( aColsFor[ nX ][ nPosForm ] ) .And. M->C5_TIPO == "N"
							lRet := .F.
							exit
						Endif
					Endif
				Next

				If nFormas == 0 .And. lRet .And. M->C5_TIPO == "N"
					lRet := .F.
				Endif
			Else
				If Select( cArqQry ) > 0
					( cArqQry )->( dBCloseArea( ) )
				EndIf

				cQuery := "SELECT SCV.CV_PEDIDO,"
				cQuery += "       SCV.CV_FORMAPG "
				cQuery += "  FROM " + RetSqlName( "SCV" ) + " SCV "
				cQuery += " WHERE SCV.CV_FILIAL   = '" + xFilial( "SCV" ) + "'"
				cQuery += "   AND SCV.CV_PEDIDO   = '" + M->C5_NUM + "'"
				cQuery += "   AND SCV.D_E_L_E_T_ <> '*' "

				cQuery := ChangeQuery(cQuery)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)

				If Empty( ( cArqQry )->CV_FORMAPG ) .And. M->C5_TIPO == "N"
					lRet := .F.
				Endif

			Endif
		Endif

		If !lRet
			// Verifica se a execução é sem interface
			if isBlind()
				Help( ,, 'Atencao',, 'Não foram informadas as formas de pagamento.', 1, 0, NIL, NIL, NIL, NIL, NIL, { 'Verifique a opção Forma no Pedido de Venda!' } )
			else
				U_LSSHWHLP( "Atenção !", "Não foram informadas as formas de pagamento.", "Verifique a opção 'Forma' no Pedido de Venda!" )
			endif
		Endif

		RestArea( aArea )


		If lRet .AND. cCondPgto != "902" .AND. M->C5_OPER $ cMV_TOPEVEN  .and. !IsInCallStack( "U_FLXFAT03" )
			ndVLim := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"SA1->A1_LC"     )
			cDtLim := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"SA1->A1_VENCLC" )
			If lVlCred
				If ( ( ndVLim < 0 .or. cDtLim < DDATABASE .Or. cDtLim == CTOD( "  /  /  " ) ) .And. ( M->C5_OPER $ cMV_TOPEVEN ) .And. ( M->C5_CLIENTE != "05341357 " ) )
					Aviso( "Atenção", "Limite de crédito do Cliente VENCIDO ou ZERADO, Impossível Prosseguir!!!", { "OK" } )
					lRet := .F.
				EndIf
			EndIf
		EndIf

		If lRet

			If ( ( M->C5_OPER $ cMV_TOPEVEN ) .And. Empty( M->C5_TABELA ) )
				if isBlind()
					Help( ,, 'Atencao',, 'Tabela de preço não informada!', 1, 0, NIL, NIL, NIL, NIL, NIL, { 'Informe uma tabela de preço para esse tipo de operação!' } )
				else
					Aviso( "Atenção", "É obrigatório o uso de tabela de preço para esse tipo de operação!!!", { "OK" } )
				endif
				U_A410VLD4()
				lRet := .F.
			EndIf

		EndIf

		If lRet
			lRet := U_A410VLD5()
		EndIf
	EndIf
Return( lRet )
