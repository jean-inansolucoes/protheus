#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#DEFINE nOpcEV  2 	 // Enhoice Visualizar
#DEFINE nOpcEI  3 	 // Enchoice Incluir
#DEFINE nOpcEA  4 	 // Enchoice Alterar
#DEFINE nOpcEE  5 	 // Enchoice Excluir
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS06  ºAutor ³ Lincoln Rossetto      ºData ³ 16/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow's separação/pesagem de mercadorias.               ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LSOMS06( pcFilial, pcCarga, pcSeqCar, pcObj )
***********************************************************
Local cCarga      := pcCarga
Local aDadosUsr   := {}
Local aRegDA7     := {}
Local aTipo       := {}
Local aRota       := {}
Local aZona       := {}
Local aSetor      := {}
Local aUserInfo   := {}
Local cQuery      :=  ""
Local hEnter      := Chr( 13 )

Local lFirst      := .T.
Local cCodSep     := ""
Local cRevSep     := ""
Local cMay        := ""
Local cIdWF       := ""
Local cIDWFLink   := ""
Local cMailID     := ""
Local cRevCarga   := ""
Local cAssunto    := ""
Local cCodProc    := ""
Local cCodRota    := Space( TamSX3( "DA8_COD"    )[ 1 ] )
Local cZona       := Space( TamSX3( "DA7_PERCUR" )[ 1 ] )
Local cSetor      := Space( TamSX3( "DA7_ROTA"   )[ 1 ] )
Local cSeqRota    := Space( TamSX3( "DA9_SEQUEN" )[ 1 ] )
Local cSequencia  := Space( TamSX3( "DA7_SEQUEN" )[ 1 ] )
Local cPtoRefDA6  := Space( TamSX3( "DA6_REF"    )[ 1 ] )
Local cPtoRefDA5  := Space( TamSX3( "DA5_DESC"   )[ 1 ] )
Local cDescRota   := "PEDIDOS SEM ROTA"
Local lReadOnly   := .F.
Local lShared     := .T.
Local lValido     := .F.
Local lShare      := .T.
Local lReadOnly   := .F.
Local lNewSep     := .F.
Local cHtmlSepar  := Alltrim( GetMV( "MV_LSWFSEP" ) )
Local cDirWFSep   := Alltrim( GetMV( "MV_LSDIRSP" ) )
Local cMailTo     := Alltrim( GetMV( "MV_LSENDMA" ) )
Local cDir        := Alltrim( GetMV( "MV_WFDIR"   ) )
Local nPosA       := 0
Local nPosB       := 0
Local nPosC       := 0
Local nPosD       := 0
Local hEnter      := Chr( 13 )
Local aPedGet     := {}
Local aPedidos    := {}
Local aProdutos   := {}
Local oProcess
Local nX, nY, nZ, nRegDA7
Default pcCarga   := ""

If pcObj == 2
    cAliasSC9   := GetNextAlias( )
    
    If Empty( DAK->DAK_CAMINH )
       Aviso( "Atenção", "Esta Carga não tem um veiculo associado, impossivel prosseguir !", {"OK"}, 2 )
       Return( .F. )
    Endif
    
	pcFilial  := xFilial( "DAK" )
	pcCarga   := DAK->DAK_COD
	pcSeqCar  := DAK->DAK_SEQCAR
	
	Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "LSOMS06" )
	
	cQuery :=  " SELECT SC9.*,"                                 +       hEnter
	cQuery += "         SC9.R_E_C_N_O_ RECSC9 "                 +       hEnter
	cQuery += "    FROM " + RetSqlName( "SC9" ) + " SC9 "       +       hEnter
	cQuery += "   WHERE SC9.C9_FILIAL   = '" + xFilial( "SC9" ) + "'" + hEnter
	cQuery += "     AND SC9.C9_CARGA    = '" + pcCarga          + "'" + hEnter
	cQuery += "     AND SC9.C9_SEQCAR   = '" + pcSeqCar         + "'" + hEnter
	cQuery += "     AND SC9.D_E_L_E_T_ <> '*'"                  +       hEnter
	cQuery += "ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM"             +       hEnter
	
	MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)
	
	If Select( cAliasSC9 ) > 0
		( cAliasSC9 )->( dBclosearea( ) )
	Endif
	
	cQuery := ChangeQuery(cQuery)
	
	dBUseArea(.T.,"TOPCONN",TCGENQRY(,, cQuery ),cAliasSC9,.F.,.T.)
	_x__aPedNw := {}
	
	dBSelectArea( "ZAF" )
	ZAF->( dBSetOrder( 2 ) )
	ZAF->( dBGoTop(  ) )
	ZAF->( MSSeek( xFilial( "ZAF" ) + DAK->DAK_COD + DAK->DAK_SEQCAR ) )
	
	_X__DadCga := { DAK->DAK_COD                , ;
	                DAK->DAK_SEQCAR             , ;
	                DAK->DAK_X_REVI             , ;
	                DAK->DAK_DATA               , ;
	                DAK->DAK_HORA               , ;
	                DAK->DAK_CAMINH             , ;
	                DAK->DAK_MOTORI             , ;
	                DAK->DAK_X_DTPE             , ;
	                DAK->DAK_X_DTPS             , ;
	                DAK->DAK_X_HREM             , ;
	                ZAF->ZAF_COD                , ;
	                ZAF->ZAF_REVIS              }
	
	lFirst    := .T.
	( cAliasSC9 )->( dBGoTop( ) )
	While !( cAliasSC9 )->( Eof( ) )
		If lFirst
			lFirst := .F.
			aAdd( _x__aPedNw, { DAK->DAK_COD, DAK->DAK_SEQCAR } )
		Endif
		
		dBSelectArea( "SB1" )
		SB1->( dBSetOrder( 1 ) )
		SB1->( dBGoTop( ) )
		SB1->( dBSeek( xFilial( "SB1" ) + ( cAliasSC9 )->C9_PRODUTO ) )
		
		dBSelectArea( "SA1" )
		SA1->( dBSetOrder( 1 ) )
		SA1->( dBGoTop( ) )
		SA1->( dBSeek( xFilial( "SA1" ) + ( cAliasSC9 )->C9_CLIENTE + ( cAliasSC9 )->C9_LOJA ) )
		
		aAdd( _x__aPedNw[ Len( _x__aPedNw ) ], { ( cAliasSC9 )->C9_FILIAL  , ;
		                                         ( cAliasSC9 )->C9_PEDIDO  , ;
		                                         ( cAliasSC9 )->C9_ITEM    , ;
		                                         ( cAliasSC9 )->C9_SEQUEN  , ;
		                                         ( cAliasSC9 )->C9_CLIENTE , ;
		                                         ( cAliasSC9 )->C9_LOJA    , ;
		                                         SA1->A1_NOME              , ;
		                                         ( cAliasSC9 )->C9_PRCVEN  , ;
		                                         ( cAliasSC9 )->C9_QTDLIB  , ;
		                                         ( cAliasSC9 )->C9_PRODUTO , ;
		                                         ( cAliasSC9 )->C9_LOCAL   , ;
		                                         SB1->B1_DESC              , ;
		                                         0                         } )
		
		( cAliasSC9 )->( dBSkip( ) )
	Enddo
	
	If Select( cAliasSC9 ) > 0
		( cAliasSC9 )->( dBclosearea( ) )
	Endif
	
	For nZ := 1 To Len( _x__aPedNw )
			
		For nY := 3 To Len( _x__aPedNw[ nZ ] ) // FILIAL + PEDIDO + ITEM
			nPos := aScan( _X__Ped, { |X| X[ 1 ] == _x__aPedNw[ nZ ][ nY ][ 1 ] .And. X[ 2 ] == _x__aPedNw[ nZ ][ nY ][ 2 ]  .And. X[ 3 ] == _x__aPedNw[ nZ ][ nY ][ 3 ] } )
			
			If nPos == 0
				aAdd( _X__Ped, { _x__aPedNw[ nZ ][ nY ][ 1 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 2 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 3 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 4 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 5 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 6 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 7 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 8 ] * _x__aPedNw[ nZ ][ nY ][ 9 ], ;
				                 _x__aPedNw[ nZ ][ nY ][ 9 ] , ;
				                 _x__aPedNw[ nZ ][ nY ][ 10 ], ;
				                 _x__aPedNw[ nZ ][ nY ][ 11 ], ;
				                 0                           } )
			Else
				_X__Ped[ nPos ][ 8 ] += _x__aPedNw[ nZ ][ nY ][ 8 ] * _x__aPedNw[ nZ ][ nY ][ 9 ]
				_X__Ped[ nPos ][ 9 ] += _x__aPedNw[ nZ ][ nY ][ 9   ]
			Endif
				
		Next nY
		
	Next nZ

Endif

If !Empty( pcCarga ) .And. Type( '_X__Ped' ) <>  'U'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca tipos de carga e joga no array³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( "SX5" )
	SX5->( dBSetOrder( 1 ) )
	SX5->( dBGoTop(  ) )
	SX5->( MsSeek( xFilial( "SX5" ) + "DU" ) )
	
	While !SX5->( Eof( ) ) .And. SX5->X5_FILIAL + SX5->X5_TABELA == xFilial( "SX5" ) + "DU"
		Aadd( aTipo,{ SX5->X5_CHAVE, X5Descri() } )
		SX5->( dbSkip( ) )
	EndDo
	
	If Len( aTipo ) == 0
		Aadd( aTipo,{ Space( 6 ), Space( 30 ) } )
	EndIf
	
	cCarga  := pcCarga
	aPedGet := _X__Ped
	
	dBSelectArea( "DAK" )
	If Alltrim( DAK->DAK_COD + DAK->DAK_FILIAL ) <> Alltrim( pcCarga + pcFilial )
		DAK->( dBSetOrder( 1 ) )
		DAK->( dBGoTop( ) )
		DAK->( dBSeek( pcFilial + pcCarga ) )
	Endif

	OsAvalDAK( "DAK", 11 )
	cRevCarga := DAK->DAK_X_REVI
	
	dBSelectArea( "DA4" )
	DA4->( dbSetOrder( 1 ) )
	DA4->( dBGoTop( ) )
	DA4->( dBSeek( xFilial( "DA4" ) + DAK->DAK_MOTORI ) )
	
	If Empty( cRevCarga )
		cRevCarga := StrZero( 0, TamSX3( "DAK_X_REVI" )[ 1 ] )
	Endif
	
	cRevCarga := Soma1( cRevCarga, TamSX3( "DAK_X_REVI" )[ 1 ] )
	
	dBSelectArea( "ZAF" )
	ZAF->( dBSetOrder ( 2 ) )
	ZAF->( dBGoTop( ) )
	If !ZAF->( MSSeek( xFilial( "ZAF" ) + pcCarga + pcSeqCar ) )
		lNewSep := .T.
		dBSelectArea( "ZAF" )
		ZAF->( dBSetOrder( 1 ) ) // ZAF_FILIAL+ZAF_COD
		
		cCodSep  := GETSX8NUM( "ZAF", "ZAF_COD" )
		cMay     := "ZAF" + Alltrim( xFilial( "ZAF" ) )
		cRevSep  := StrZero( 0, TamSX3( 'ZAF_REVIS' )[ 1 ] )
		cRevSep  := Soma1( cRevSep, TamSX3( 'ZAF_REVIS' )[ 1 ] )
		
		While ZAF->( ( MsSeek( xFilial( "DAK" ) + cCodSep ) .Or. !MayIUseCode( cMay + cCodSep ) ) )
			cCodSep := Soma1( cCodSep, TamSX3( 'ZAF_COD' )[ 1 ] )
		EndDo
	Else
		lNewSep := .F.
		cCodSep := ZAF->ZAF_COD
		cRevSep := ZAF->ZAF_REVIS
		cRevSep := Soma1( cRevSep, TamSX3( 'ZAF_REVIS' )[ 1 ] )
	Endif
	
	If Right( cDir, 1 ) <> "\"
		cDir += "\"
	Endif
	
	If Left( cDirWFSep, 1 ) == "\"
		cDirWFSep := SubStr( cDirWFSep, 2, Len( cDirWFSep ) )
	Endif
	
	If Right( cDirWFSep, 1 ) <> "\"
		cDirWFSep += "\"
	Endif
	
	cHtmlSepar := ( cDir + cDirWFSep + cHtmlSepar )
	
	If !File( cHtmlSepar )
		MsgInfo( FUNNAME() + " >>> Não foi encontrado o arquivo " + cHtmlSepar )
		Return( .F. )
	Endif
	
	aZonas   := {}
	aSetores := {}
	aRotas   := {}
	
	dbSelectarea( "DA6" )
	DA6->( dbSetOrder( 1 ) )
	
	dBselectArea( "DA7" )
	DA7->( dBGoTop( ) )
	
	dBselectArea( "DA8" )
	DA8->( dBGoTop( ) )
	
	dBselectArea( "DA9" )
	DA9->( dBGoTop( ) )
	
	dBSelectArea( "SC9" )
	SC9->( dBSetOrder( 2 ) )
	
	For nX := 1 To Len( aPedGet )
		
		SC9->( dBGoTop( ) )
		
		If SC9->( dBSeek( aPedGet[ nX ][ 1 ] + aPedGet[ nX ][ 5 ] + aPedGet[ nX ][ 6 ] + aPedGet[ nX ][ 2 ] + aPedGet[ nX ][ 3 ] ) )

		    RecLock( "SC9", .F. )
		    SC9->C9_X_CODSE := cCodSep
		    SC9->C9_X_REVSE := cRevSep
		    SC9->C9_BLEST   := "SP"
            SC9->( MsUnLock( ) )
			
			dBSelectArea( "SB1" )
			SB1->( dBSetOrder( 1 ) )
			SB1->( dBgoTop( ) )
			SB1->( MsSeek( xFilial( "SB1" ) + SC9->C9_PRODUTO ) )
			
			dBSelectArea( "SB2" )
			SB2->( dBSetOrder( 1 ) )
			SB2->( dBgoTop( ) )
			SB2->( MsSeek( xFilial( "SB2" ) + SB1->B1_COD + SC9->C9_LOCAL ) )
			
			nPos := aScan( aProdutos, { |X| X[ 1 ] == SB1->B1_COD } )
			If nPos == 0
				aAdd( aProdutos, { SB1->B1_COD, SB1->B1_DESC, SC9->C9_QTDLIB, SaldoSB2() } )
			Else
				aProdutos[ nPos ][ 3 ] += SC9->C9_QTDLIB
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Roteirização                                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( "SA1" )
			SA1->( dBSetOrder( 1 ) )
			SA1->( dBgoTop( ) )
			SA1->( dBSeek( xFilial( "SA1" ) + SC9->C9_CLIENTE + SC9->C9_LOJA ) )
			
			aRegDA7 := OmsHasDA7( SC9->C9_FILIAL, SC9->C9_CLIENTE, SC9->C9_LOJA )
			
			If Len( aRegDA7 ) > 0
				
				For nRegDA7 := 1 To Len(aRegDA7)
					
					DA7->( MsGoto( aRegDA7[ nRegDA7 ] ) )
					
					cZona      := DA7->DA7_PERCUR
					cSetor     := DA7->DA7_ROTA
					cSequencia := DA7->DA7_SEQUEN
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pesquisa o cliente/fornecedor na zona/setor                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DA9->( dBSetOrder( 2 ) )
					DA9->( dBGoTop( ) )
					If DA9->( MsSeek( xFilial( "DA9" ) + cZona + cSetor ) )
						lValido := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se busca a primeira rota ativa                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SuperGetMv( "MV_ROTATV", .F. ,"2" ) == "2"
							While !DA9->( Eof( ) ) .And. DA9->DA9_FILIAL == xFilial("DA9") .And. DA9->DA9_PERCUR == cZona .And. DA9->DA9_ROTA == cSetor
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Pesquisa a Rota                                                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								DA8->( dBSetOrder( 1 ) )
								DA8->( dBGoTop( ) )
								If DA8->( MsSeek( xFilial( "DA8" ) + DA9->DA9_ROTEIR ) )
									If DA8->DA8_ATIVO == "1"
										cCodRota  := DA8->DA8_COD
										cDescRota := DA8->DA8_DESC
										cSeqRota  := DA9->DA9_SEQUEN
										
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Verifica os tipo de carga da rota se esta incluido                  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If DA8->( FieldPos( "DA8_TIPCAR" ) ) > 0 .And. !Empty( DA8->DA8_TIPCAR )
											nPosD := Ascan( aTipo,{ |X| Alltrim( X[ 1 ] ) == DA8->DA8_TIPCAR } )
											If nPosD > 0
												lValido := .F.
											EndIf
										EndIf
										If lValido
											Exit
										EndIf
									Endif
								Else
									cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
									cDescRota  := "PEDIDOS SEM ROTA"
									cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
									cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
									cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
									cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
									Exit
								EndIf
								
								DA9->( dBSkip( ) )
							EndDo
							
							If Empty( cCodRota )
								cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
								cDescRota  := "PEDIDOS SEM ROTA"
								cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
								cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
								cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
								cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
							EndIf
						Else
							While !DA9->( Eof( ) ) .And. DA9->DA9_FILIAL == xFilial( "DA9" ) .And. DA9->DA9_PERCUR == cZona .And. DA9->DA9_ROTA == cSetor
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Pesquisa a Rota                                                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								DA8->( dBSetOrder( 1 ) )
								DA8->( dBGoTop( ) )
								If DA8->( MsSeek( xFilial( "DA8" ) + DA9->DA9_ROTEIR ) )
									If DA8->DA8_ATIVO == "1" .And. IIf( !Empty( DA8->DA8_CODCAL ), OmsDtEntr( DA8->DA8_CODCAL, dDataBase ) == dDataBase, .T. )
										cCodRota := DA8->DA8_COD
										cDescRota:= DA8->DA8_DESC
										cSeqRota := DA9->DA9_SEQUEN
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Verifica os tipo de carga da rota se esta incluido                  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If DA8->( FieldPos( "DA8_TIPCAR" ) ) > 0 .And. !Empty( DA8->DA8_TIPCAR )
											nPosD := Ascan( aTipo,{ |X| Alltrim( X[ 2 ] ) == DA8->DA8_TIPCAR } )
											If nPosD > 0
												lValido := .F.
											EndIf
										EndIf
										If lValido
											Exit
										EndIf
									EndIf
								Else
									cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
									cDescRota  := "PEDIDOS SEM ROTA"
									cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
									cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
									cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
									cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
									Exit
								EndIf
								DA9->( dBSkip( ) )
							EndDo
							
							If Empty( cCodRota )
								cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
								cDescRota  := "PEDIDOS SEM ROTA"
								cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
								cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
								cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
								cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
							EndIf
							
						Endif
					Else
						cCodRota   := Repl( "9", Len( DA8->DA8_COD    ) )
						cDescRota  := "PEDIDOS SEM ROTA"
						cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
						cSetor     := Repl( "9", Len( DA7->DA7_ROTA   ) )
						cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
						cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
						lEnable    := .T.
						lValido    := .T.
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pesquisa os Setores por Zona                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DA6->( dBGoTop( ) )
					If DA6->( MsSeek( xFilial( "DA6" ) + cZona + cSetor ) )
						cPtoRefDA6 := DA6->DA6_REF
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Pesquisa as Zonas                                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea( "DA5" )
						DA5->( dBSetOrder( 1 ) )
						If DA5->( MsSeek( xFilial( "DA5" ) + DA6->DA6_PERCUR ) )
							cPtoRefDA5 := DA5->DA5_DESC
						Else
							cPtoRefDA5 := ""
						EndIf
					Else
						cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
						cDescRota  := "PEDIDOS SEM ROTA"
						cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
						cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
						cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
						cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
						cPtoRefDA5 := ""
						cPtoRefDA6 := ""
					EndIf
					
					If Ascan( aRota, { |X| x[ 1 ] == cCodRota } ) == 0 .And. lValido
						AAdd( aRota, { cCodRota, cDescRota, Space( 6 ) } )
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifico se existe setor para pegar descricao e acrescento no³
					//³array                                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Ascan( aSetor, { |x| X[ 1 ] == cCodRota .And. X[ 2 ] == cZona .And. X[ 3 ] == cSetor } ) == 0 .And. lValido
						AAdd( aSetor, { cCodRota, cZona, cSetor, cDescRota, cPtoRefDA6, cSeqRota } )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Busco se ja existe a zona no array , caso nao exista,a mesma³
						//³e incluida                                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Ascan( aZona, { |x| x[ 1 ] == cCodRota .And. x[ 2 ] == cZona } ) == 0
							AAdd( aZona, { cCodRota, cZona, cPtoRefDA5, cSeqRota } )
						EndIf
					EndIf
				Next nRegDa7
			Else
				cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
				cDescRota  := "PEDIDOS SEM ROTEIRIZACAO"
				cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
				cSetor     := Repl( "9", Len( DA7->DA7_ROTA   ) )
				cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
				cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
				
				lEnable    := .T.
				lValido    := .T.
				
				If Ascan( aRota, {|x| X[ 1 ] == cCodRota } ) == 0
					AAdd( aRota, { cCodRota, cDescRota,  Space( 6 ) } )
				EndIf
				
				If Ascan( aZona, { |x| X[ 1 ] == cCodRota .And. X[ 2 ] ==  cZona } ) == 0
					AAdd( aZona, { cCodRota, cSetor, cDescRota, cSeqRota } )
				EndIf
				
				If Ascan( aSetor, { |x| x[ 1 ] == cCodRota .And. x[ 2 ] == cZona .And. x[ 3 ] == cSetor } ) == 0
					AAdd( aSetor, { cCodRota, cZona, cSetor, cDescRota, cPtoRefDA6, cSeqRota } )
				EndIf
				
			EndIf
		Endif
	Next
	
	cRota   := ""
	cZona   := ""
	cSetor  := ""
	aSetorX := {}
	
	If PswSeek( AllTrim( __cUserId ), .T. )
		aDadosUsr := PswRet( 1 )
	Endif
	
	RecLock( "DAK", .F. )
	DAK->DAK_X_REVI := cRevCarga
	DAK->DAK_X_USER := aDadosUsr[ 1 ][ 4 ]
	DAK->( MsUnLock( ) )

	For nX := 1 To Len( aPedGet )
		
		nPos := aScan( aPedidos, { |X| X[ 1 ] == aPedGet[ nX ][ 2 ] } )
		If nPos == 0
			aAdd( aPedidos, { aPedGet[ nX ][ 2 ], aPedGet[ nX ][ 5 ], aPedGet[ nX ][ 6 ], aPedGet[ nX ][ 7 ], aPedGet[ nX ][ 8 ] } )
		Else
			aPedidos[ nPos ][ 5 ] += aPedGet[ nX ][ 8 ]
		Endif
		
	Next

	cProcesso := OemToAnsi( "SEPARA" )
	cAssunto  := "Separação/Pesagem/Embarque de Mercadorias [Carga: " + cCarga + " - Separação: " + cCodSep + "/" + cCodSep  + "]"
	cStatus   := "SEPARACAO"
	
	oProcess := TWFProcess():New( cProcesso , cAssunto )
	oProcess:NewTask( cAssunto , cHtmlSepar )
	oProcess:cSubject	:= cAssunto
	oProcess:cTo		:= cMailTo
	oProcess:UserSiga   := "000000"
	oHtml               := oProcess:oHtml
	
	PSWOrder( 1 )
	PSWSeek( __cUserID, .T. )
	
	aUserInfo := PSWRet( 1 )
	oHtml:ValByName( "CAB_CARGA", DAK->DAK_COD          )
	oHtml:ValByName( "CAB_REVIS", cRevCarga             )
	oHtml:ValByName( "CAB_DTCGA", DTOC( DAK->DAK_DATA ) )
	oHtml:ValByName( "CAB_HRCGA", Transform( DAK->DAK_HORA, "99:99" ) )
	oHtml:ValByName( "CAB_VEIC" , DAK->DAK_CAMINH )
	oHtml:ValByName( "CAB_MOTOR", DA4->DA4_NOME   )
	oHtml:ValByName( "CAB_EMBQE", DTOC( DAK->DAK_X_DTPE ) )
	oHtml:ValByName( "CAB_DTSEP", DTOC( DAK->DAK_X_DTPS ) )
	oHtml:ValByName( "CAB_HRSEP", Transform( DAK->DAK_X_HREM, "99:99" ) )
	oHtml:ValByName( "CAB_SOLIC", Alltrim( aUserInfo[ 1 ] [ 4 ] ) )
	oHtml:ValByName( "CAB_SEPARA", cCodSep   )
	oHtml:ValByName( "CAB_REVSEP", cRevSep   )
	oHtml:ValByName( "CAB_DT"    , DTOC( dDataBase ) )
	oHtml:ValByName( "CAB_HR"    , Transform( Time(), "99:99:99" ) )
	oHtml:ValByName( "CAB_OBS1" , StrTran(DAK->DAK_X_OBS,chr(13),'<br>') )
	
	If Len( _X__Aglut ) > 0
		oHtml:ValByName( "CAB_OBS2"  , "<Strong>(**) Este Workflow foi gerado devido ao Agrupamento das Cargas (Carga(s) de: " + _X__Aglut[ 1 ] + ", Para Carga: " + _X__Aglut[ 2 ] + " - Sequencia: " + _X__Aglut[ 3 ] + ")</Strong>" )
	Endif
	
	oHtml:ValByName( "SLD_DT"   , DTOC ( dDataBase ) )
	oHtml:ValByName( "SLD_HR"   , Transform( Time(), "99:99:99" ) )
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Zona                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len( aSetor )
		AAdd( oHtml:ValByName( "ROT.ROT_ZONA"  ), aSetor[ nX ][ 2 ] )
		AAdd( oHtml:ValByName( "ROT.ROT_SETOR" ), aSetor[ nX ][ 3 ] )
		AAdd( oHtml:ValByName( "ROT.ROT_ROTA"  ), aSetor[ nX ][ 1 ] + " - " + aSetor[ nX ][ 4 ] )
	Next
	
	For nX := 1 To Len( aPedidos )
		AAdd( oHtml:ValByName( "PV.PV_NUM"   ),  aPedidos[ nX ][ 1 ]  )
		AAdd( oHtml:ValByName( "PV.PV_CLI"   ),  aPedidos[ nX ][ 2 ]  )
		AAdd( oHtml:ValByName( "PV.PV_LJA"   ),  aPedidos[ nX ][ 3 ]  )
		AAdd( oHtml:ValByName( "PV.PV_NOME"  ),  aPedidos[ nX ][ 4 ]  )
		AAdd( oHtml:ValByName( "PV.PV_VALOR" ),  Transform( aPedidos[ nX ][ 5 ], "@E 999,999,999.99"  ) )
	Next
	
	aProdutos := aSort( aProdutos,,, { |X, Y| X[ 1 ] < Y[ 1 ] })
	
	For nX := 1 To Len( aProdutos )
		AAdd( oHtml:ValByName( "PR.PR_COD"  ), aProdutos[ nX ][ 01 ] )
		AAdd( oHtml:ValByName( "PR.PR_DESC" ), aProdutos[ nX ][ 02 ] )
		AAdd( oHtml:ValByName( "PR.PR_QTDP" ), Transform( aProdutos[ nX ][ 03 ] , "@E 999,999,999.99"  ) )
		AAdd( oHtml:ValByName( "PR.PR_QTDE" ), Transform( aProdutos[ nX ][ 04 ] , "@E 999,999,999.99"  ) )
	Next
	
	cIDWF := oProcess:Start()
	
	If !lNewSep
		RecLock( "ZAF", .F. )
		ZAF->ZAF_REVIS  := cRevSep
		ZAF->ZAF_DATA   := DDATABASE
		ZAF->ZAF_HORA   := TIME()
		ZAF->ZAF_IDUSR  := __cUserId
		ZAF->ZAF_USER   := aDadosUsr[ 1 ][ 2 ]
		ZAF->ZAF_IDWF   := cIdWF
		ZAF->ZAF_STATUS := "E"
		ZAF->( MsUnLock( ) )
	Else
		RecLock( "ZAF", .T. )
		ZAF->ZAF_FILIAL := pcFilial
		ZAF->ZAF_COD    := cCodSep
		ZAF->ZAF_CARGA  := pcCarga
		ZAF->ZAF_REVIS  := cRevSep
		ZAF->ZAF_SEQ    := pcSeqCar
		ZAF->ZAF_OPERAC := "S"
		ZAF->ZAF_DATA   := DDATABASE
		ZAF->ZAF_HORA   := TIME()
		ZAF->ZAF_IDUSR  := __cUserId
		ZAF->ZAF_USER   := aDadosUsr[ 1 ][ 2 ]
		ZAF->ZAF_IDWF   := cIdWF
		ZAF->( MsUnLock( ) )
		ConfirmSx8()
	Endif
	
Endif

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS062 ºAutor ³ Lincoln Rossetto      ºData ³ 16/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow's separação/pesagem de mercadorias.               ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LSOMS062(  )
**************************
Local aDadosUsr   := {}
Local aRegDA7     := {}
Local aTipo       := {}
Local aRota       := {}
Local aZona       := {}
Local aSetor      := {}
Local aUserInfo   := {}
Local cCodSep     := ""
Local cRevSep     := ""
Local cMay        := ""
Local cIdWF       := ""
Local cIDWFLink   := ""
Local cMailID     := ""
Local cRevCarga   := ""
Local cAssunto    := ""
Local cCodProc    := ""
Local cCodRota    := Space( TamSX3( "DA8_COD"    )[ 1 ] )
Local cZona       := Space( TamSX3( "DA7_PERCUR" )[ 1 ] )
Local cSetor      := Space( TamSX3( "DA7_ROTA"   )[ 1 ] )
Local cSeqRota    := Space( TamSX3( "DA9_SEQUEN" )[ 1 ] )
Local cSequencia  := Space( TamSX3( "DA7_SEQUEN" )[ 1 ] )
Local cPtoRefDA6  := Space( TamSX3( "DA6_REF"    )[ 1 ] )
Local cPtoRefDA5  := Space( TamSX3( "DA5_DESC"   )[ 1 ] )
Local cDescRota   := "PEDIDOS SEM ROTA"
Local lReadOnly   := .F.
Local lShared     := .T.
Local lValido     := .F.
Local lShare      := .T.
Local lReadOnly   := .F.
Local cHtmlCanc   := Alltrim( GetMV( "MV_LSWFCAN" ) )
Local cDirWFSep   := Alltrim( GetMV( "MV_LSDIRSP" ) )
Local cMailTo     := Alltrim( GetMV( "MV_LSENDMA" ) )
Local cDir        := Alltrim( GetMV( "MV_WFDIR"   ) )
Local nPosA       := 0
Local nPosB       := 0
Local nPosC       := 0
Local nPosD       := 0
Local hEnter      := Chr( 13 )
Local aPedGet     := {}
Local aPedidos    := {}
Local aProdutos   := {}
Local oProcess
Local nRegDA7, nX

If Type( '_X__Ped' ) <>  'U'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca tipos de carga e joga no array³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( "SX5" )
	SX5->( dBSetOrder( 1 ) )
	SX5->( dBGoTop(  ) )
	SX5->( MsSeek( xFilial( "SX5" ) + "DU" ) )
	
	While !SX5->( Eof( ) ) .And. SX5->X5_FILIAL + SX5->X5_TABELA == xFilial( "SX5" ) + "DU"
		Aadd( aTipo,{ SX5->X5_CHAVE, X5Descri() } )
		SX5->( dbSkip( ) )
	EndDo
	
	If Len( aTipo ) == 0
		Aadd( aTipo,{ Space( 6 ), Space( 30 ) } )
	EndIf
	
	cCarga    := _X__DadCga[ 1 ]
	aPedGet   := _X__Ped
	cRevCarga := _X__DadCga[ 3 ]
	
	dBSelectArea( "DA4" )
	DA4->( dbSetOrder( 1 ) )
	DA4->( dBGoTop( ) )
	DA4->( dBSeek( xFilial( "DA4" ) + _X__DadCga[ 7 ] ) )
	
	If Right( cDir, 1 ) <> "\"
		cDir += "\"
	Endif
	
	If Left( cDirWFSep, 1 ) == "\"
		cDirWFSep := SubStr( cDirWFSep, 2, Len( cDirWFSep ) )
	Endif
	
	If Right( cDirWFSep, 1 ) <> "\"
		cDirWFSep += "\"
	Endif
	
	cHtmlCanc := ( cDir + cDirWFSep + cHtmlCanc )
	
	If !File( cHtmlCanc )
		MsgInfo( FUNNAME() + " >>> Não foi encontrado o arquivo " + cHtmlCanc )
		Return( .F. )
	Endif
	
	aZonas   := {}
	aSetores := {}
	aRotas   := {}
	
	dbSelectarea( "DA6" )
	DA6->( dbSetOrder( 1 ) )
	
	dBselectArea( "DA7" )
	DA7->( dBGoTop( ) )
	
	dBselectArea( "DA8" )
	DA8->( dBGoTop( ) )
	
	dBselectArea( "DA9" )
	DA9->( dBGoTop( ) )
	
	For nX := 1 To Len( aPedGet )
		dBSelectArea( "SB1" )
		SB1->( dBSetOrder( 1 ) )
		SB1->( dBgoTop( ) )
		SB1->( MsSeek( xFilial( "SB1" ) + aPedGet[ nX ][ 10 ] ) )
		
		dBSelectArea( "SB2" )
		SB2->( dBSetOrder( 1 ) )
		SB2->( dBgoTop( ) )
		SB2->( MsSeek( xFilial( "SB2" ) + SB1->B1_COD + aPedGet[ nX ][ 11 ] ) )
		
		nPos := aScan( aProdutos, { |X| X[ 1 ] == SB1->B1_COD } )
		If nPos == 0
			aAdd( aProdutos, { SB1->B1_COD, SB1->B1_DESC, aPedGet[ nX ][ 9 ], 0 } )
		Else
			aProdutos[ nPos ][ 3 ] += aPedGet[ nX ][ 9 ]
		Endif
		
		dBSelectArea( "SA1" )
		SA1->( dBSetOrder( 1 ) )
		SA1->( dBgoTop( ) )
		SA1->( dBSeek( xFilial( "SA1" ) + aPedGet[ nX ][ 5 ] + aPedGet[ nX ][ 6 ] ) )
		
		aRegDA7 := OmsHasDA7( aPedGet[ nX ][ 1 ], SA1->A1_COD, SA1->A1_LOJA )
		
		If Len( aRegDA7 ) > 0
			
			For nRegDA7 := 1 To Len( aRegDA7 )
				
				DA7->( MsGoto( aRegDA7[ nRegDA7 ] ) )
				
				cZona      := DA7->DA7_PERCUR
				cSetor     := DA7->DA7_ROTA
				cSequencia := DA7->DA7_SEQUEN
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pesquisa o cliente/fornecedor na zona/setor                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DA9->( dBSetOrder( 2 ) )
				DA9->( dBGoTop( ) )
				If DA9->( MsSeek( xFilial( "DA9" ) + cZona + cSetor ) )
					lValido := .T.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se busca a primeira rota ativa                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SuperGetMv( "MV_ROTATV", .F. ,"2" ) == "2"
						While !DA9->( Eof( ) ) .And. DA9->DA9_FILIAL == xFilial("DA9") .And. DA9->DA9_PERCUR == cZona .And. DA9->DA9_ROTA == cSetor
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Pesquisa a Rota                                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							DA8->( dBSetOrder( 1 ) )
							DA8->( dBGoTop( ) )
							If DA8->( MsSeek( xFilial( "DA8" ) + DA9->DA9_ROTEIR ) )
								If DA8->DA8_ATIVO == "1"
									cCodRota  := DA8->DA8_COD
									cDescRota := DA8->DA8_DESC
									cSeqRota  := DA9->DA9_SEQUEN
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica os tipo de carga da rota se esta incluido                  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If DA8->( FieldPos( "DA8_TIPCAR" ) ) > 0 .And. !Empty( DA8->DA8_TIPCAR )
										nPosD := Ascan( aTipo,{ |X| Alltrim( X[ 1 ] ) == DA8->DA8_TIPCAR } )
										If nPosD > 0
											lValido := .F.
										EndIf
									EndIf
									If lValido
										Exit
									EndIf
								Endif
							Else
								cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
								cDescRota  := "PEDIDOS SEM ROTA"
								cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
								cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
								cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
								cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
								Exit
							EndIf
							
							DA9->( dBSkip( ) )
						EndDo
						
						If Empty( cCodRota )
							cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
							cDescRota  := "PEDIDOS SEM ROTA"
							cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
							cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
							cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
							cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
						EndIf
					Else
						While !DA9->( Eof( ) ) .And. DA9->DA9_FILIAL == xFilial( "DA9" ) .And. DA9->DA9_PERCUR == cZona .And. DA9->DA9_ROTA == cSetor
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Pesquisa a Rota                                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							DA8->( dBSetOrder( 1 ) )
							DA8->( dBGoTop( ) )
							If DA8->( MsSeek( xFilial( "DA8" ) + DA9->DA9_ROTEIR ) )
								If DA8->DA8_ATIVO == "1" .And. IIf( !Empty( DA8->DA8_CODCAL ), OmsDtEntr( DA8->DA8_CODCAL, dDataBase ) == dDataBase, .T. )
									cCodRota := DA8->DA8_COD
									cDescRota:= DA8->DA8_DESC
									cSeqRota := DA9->DA9_SEQUEN
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Verifica os tipo de carga da rota se esta incluido                  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If DA8->( FieldPos( "DA8_TIPCAR" ) ) > 0 .And. !Empty( DA8->DA8_TIPCAR )
										nPosD := Ascan( aTipo,{ |X| Alltrim( X[ 2 ] ) == DA8->DA8_TIPCAR } )
										If nPosD > 0
											lValido := .F.
										EndIf
									EndIf
									If lValido
										Exit
									EndIf
								EndIf
							Else
								cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
								cDescRota  := "PEDIDOS SEM ROTA"
								cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
								cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
								cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
								cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
								Exit
							EndIf
							DA9->( dBSkip( ) )
						EndDo
						
						If Empty( cCodRota )
							cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
							cDescRota  := "PEDIDOS SEM ROTA"
							cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
							cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
							cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
							cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
						EndIf
						
					Endif
				Else
					cCodRota   := Repl( "9", Len( DA8->DA8_COD    ) )
					cDescRota  := "PEDIDOS SEM ROTA"
					cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
					cSetor     := Repl( "9", Len( DA7->DA7_ROTA   ) )
					cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
					cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
					lEnable    := .T.
					lValido    := .T.
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pesquisa os Setores por Zona                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DA6->( dBGoTop( ) )
				If DA6->( MsSeek( xFilial( "DA6" ) + cZona + cSetor ) )
					cPtoRefDA6 := DA6->DA6_REF
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pesquisa as Zonas                                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea( "DA5" )
					DA5->( dBSetOrder( 1 ) )
					If DA5->( MsSeek( xFilial( "DA5" ) + DA6->DA6_PERCUR ) )
						cPtoRefDA5 := DA5->DA5_DESC
					Else
						cPtoRefDA5 := ""
					EndIf
				Else
					cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
					cDescRota  := "PEDIDOS SEM ROTA"
					cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
					cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
					cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
					cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
					cPtoRefDA5 := ""
					cPtoRefDA6 := ""
				EndIf
				
				If Ascan( aRota, { |X| x[ 1 ] == cCodRota } ) == 0 .And. lValido
					AAdd( aRota, { cCodRota, cDescRota, Space( 6 ) } )
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifico se existe setor para pegar descricao e acrescento no³
				//³array                                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Ascan( aSetor, { |x| X[ 1 ] == cCodRota .And. X[ 2 ] == cZona .And. X[ 3 ] == cSetor } ) == 0 .And. lValido
					AAdd( aSetor, { cCodRota, cZona, cSetor, cDescRota, cPtoRefDA6, cSeqRota } )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Busco se ja existe a zona no array , caso nao exista,a mesma³
					//³e incluida                                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Ascan( aZona, { |x| x[ 1 ] == cCodRota .And. x[ 2 ] == cZona } ) == 0
						AAdd( aZona, { cCodRota, cZona, cPtoRefDA5, cSeqRota } )
					EndIf
				EndIf
			Next nRegDa7
		Else
			cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
			cDescRota  := "PEDIDOS SEM ROTEIRIZACAO"
			cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
			cSetor     := Repl( "9", Len( DA7->DA7_ROTA   ) )
			cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
			cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
			
			lEnable    := .T.
			lValido    := .T.
			
			If Ascan( aRota, {|x| X[ 1 ] == cCodRota } ) == 0
				AAdd( aRota, { cCodRota, cDescRota,  Space( 6 ) } )
			EndIf
			
			If Ascan( aZona, { |x| X[ 1 ] == cCodRota .And. X[ 2 ] ==  cZona } ) == 0
				AAdd( aZona, { cCodRota, cSetor, cDescRota, cSeqRota } )
			EndIf
			
			If Ascan( aSetor, { |x| x[ 1 ] == cCodRota .And. x[ 2 ] == cZona .And. x[ 3 ] == cSetor } ) == 0
				AAdd( aSetor, { cCodRota, cZona, cSetor, cDescRota, cPtoRefDA6, cSeqRota } )
			EndIf
			
		EndIf
	Next
	
	cRota   := ""
	cZona   := ""
	cSetor  := ""
	aSetorX := {}
	
	If PswSeek( AllTrim( __cUserId ), .T. )
		aDadosUsr := PswRet( 1 )
	Endif
	
	For nX := 1 To Len( aPedGet )

		If _X__lZerar
	        dBSelectArea( "SC9" )
	        SC9->( dBSetOrder( 2 ) )
			SC9->( dBGoTop( ) )
			If SC9->( dBSeek( aPedGet[ nX ][ 1 ] + aPedGet[ nX ][ 5 ] + aPedGet[ nX ][ 6 ] + aPedGet[ nX ][ 2 ] + aPedGet[ nX ][ 3 ] ) )
				RecLock( "SC9", .F. )
				SC9->C9_X_CODSE := Space( TamSX3( 'C9_X_CODSE' )[ 1 ] )
				SC9->C9_X_REVSE := Space( TamSX3( 'C9_X_REVSE' )[ 1 ] )
				SC9->( MsUnLock( ) )
			Endif
		Endif
		
		nPos := aScan( aPedidos, { |X| X[ 1 ] == aPedGet[ nX ][ 2 ] } )
		If nPos == 0
			aAdd( aPedidos, { aPedGet[ nX ][ 2 ], aPedGet[ nX ][ 5 ], aPedGet[ nX ][ 6 ], aPedGet[ nX ][ 7 ], aPedGet[ nX ][ 8 ] } )
		Else
			aPedidos[ nPos ][ 5 ] += aPedGet[ nX ][ 8 ]
		Endif

	Next
	
	If _X__lZerar
		dBSelectArea( "ZAF" )
		ZAF->( dBSetOrder( 2 ) )
		ZAF->( dBGoTop(  ) )
		If ZAF->( MSSeek( xFilial( "ZAF" ) + _X__DadCga[ 1 ] + _X__DadCga[ 2 ] ) )
			RecLock( "ZAF", .F. )
			ZAF->( dBDelete() )
			ZAF->( MsUnLock( ) )
		Endif
	Endif
	
	cProcesso := OemToAnsi( "CANCELAR" )
	cAssunto  := "CANCELAMENTO SEPARAÇÃO/PESAGEM/EMBARQUE !! [Carga: " + cCarga + " - Separação: " + cCodSep + "/" + cCodSep  + "]"
	cStatus   := "CANCELAR"
	
	oProcess := TWFProcess():New( cProcesso , cAssunto )
	oProcess:NewTask( cAssunto , cHtmlCanc )
	oProcess:cSubject	:= cAssunto
	oProcess:cTo		:= cMailTo
	oProcess:UserSiga   := "000000"
	oHtml               := oProcess:oHtml
	
	PSWOrder( 1 )
	PSWSeek( __cUserID, .T. )
	
	aUserInfo := PSWRet( 1 )
	
	oHtml:ValByName( "CAB_CARGA", _X__DadCga[ 1 ]                        )
	oHtml:ValByName( "CAB_REVIS", _X__DadCga[ 3 ]                        )
	oHtml:ValByName( "CAB_DTCGA", DTOC( _X__DadCga[ 4 ] )                )
	oHtml:ValByName( "CAB_HRCGA", Transform( _X__DadCga[ 5 ], "99:99" )  )
	oHtml:ValByName( "CAB_VEIC" , _X__DadCga[ 6 ]                        )
	oHtml:ValByName( "CAB_MOTOR", DA4->DA4_NOME                          )
	oHtml:ValByName( "CAB_EMBQE", DTOC( _X__DadCga[ 8 ] )                )
	oHtml:ValByName( "CAB_DTSEP", DTOC( _X__DadCga[ 9 ] )                )
	oHtml:ValByName( "CAB_HRSEP", Transform( _X__DadCga[ 10 ], "99:99" ) )
	oHtml:ValByName( "CAB_SOLIC", Alltrim( aUserInfo[ 1 ] [ 4 ] )        )
	oHtml:ValByName( "CAB_SEPARA", _X__DadCga[ 11 ]                      )
	oHtml:ValByName( "CAB_REVSEP", _X__DadCga[ 12 ]                      )
	oHtml:ValByName( "CAB_DT"    , DTOC( dDataBase )                     )
	oHtml:ValByName( "CAB_HR"    , Transform( Time(), "99:99:99" )        )
	oHtml:ValByName( "CAB_OBS1" , 'AVISO DE CANCELAMENTO <br>' + StrTran( M->DAK_X_OBSC, chr( 13 ),'<br>' ) )
	oHtml:ValByName( "CAN_DT"   , DTOC ( dDataBase ) )
	oHtml:ValByName( "CAN_HR"   , Transform( Time(), "99:99:99" ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Zona                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len( aSetor )
		AAdd( oHtml:ValByName( "ROT.ROT_ZONA"  ), aSetor[ nX ][ 2 ] )
		AAdd( oHtml:ValByName( "ROT.ROT_SETOR" ), aSetor[ nX ][ 3 ] )
		AAdd( oHtml:ValByName( "ROT.ROT_ROTA"  ), aSetor[ nX ][ 1 ] + " - " + aSetor[ nX ][ 4 ] )
	Next
	
	For nX := 1 To Len( aPedidos )
		AAdd( oHtml:ValByName( "PV.PV_NUM"    ), aPedidos[ nX ][ 1 ]  )
		AAdd( oHtml:ValByName( "PV.PV_CLI"    ), aPedidos[ nX ][ 2 ]  )
		AAdd( oHtml:ValByName( "PV.PV_LJA"    ), aPedidos[ nX ][ 3 ]  )
		AAdd( oHtml:ValByName( "PV.PV_NOME"   ), aPedidos[ nX ][ 4 ]  )
		AAdd( oHtml:ValByName( "PV.PV_VALOR"  ), Transform( aPedidos[ nX ][ 5 ], "@E 999,999,999.99"  ) )
		AAdd( oHtml:ValByName( "PV.PV_STATUS" ), 'N&Atilde;O SEPARAR! <img src="http://www.pti.org.br/protheus/img_microsiga/error.png" width="10" height="10" border="0">' )
	Next
	
	aProdutos := aSort( aProdutos,,, { |X, Y| X[ 1 ] < Y[ 1 ] } )
	
	For nX := 1 To Len( aProdutos )
		AAdd( oHtml:ValByName( "PR.PR_COD"    ), aProdutos[ nX ][ 01 ] )
		AAdd( oHtml:ValByName( "PR.PR_DESC"   ), aProdutos[ nX ][ 02 ] )
		AAdd( oHtml:ValByName( "PR.PR_QTDP"   ), Transform( aProdutos[ nX ][ 03 ] , "@E 999,999,999.99"  ) )
		AAdd( oHtml:ValByName( "PR.PR_STATUS" ), 'Separa&ccedil;&atilde;o CANCELADA! <img src="http://www.pti.org.br/protheus/img_microsiga/error.png" width="10" height="10" border="0">' )
	Next
	
	cIDWF := oProcess:Start()
	
Endif

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063 ºAutor ³ Lincoln Rossetto      ºData ³ 16/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de Separação de Mercadorias                       ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LSOMS063( pcFilial, pcCarga, pcSeqCar, pcObj )
************************************************************
Local aBotao        := { }
Local aObjects      := { }
Local aInfo         := { }
Local aPosObj       := { }
Local aViewDAK      := { }
Local aViewSC9      := { }
Local aSize         := MsAdvSize( .F. )
Local cCombo        := ""
Local xPesq         := ""
Local nX, nY
Local aPesq         := { { Space( TamSX3( 'DAK_COD'    )[ 1 ] + TamSX3( 'DAK_SEQCAR')[1] ), "@!" },;
                         { Space( TamSX3( "DAK_DATA"   )[ 1 ] )                           , "@D" },;
                         { Space( TamSX3( "DAK_MOTORI" )[ 1 ] )                           , "@!" },;
                         { Space( TamSX3( "DAK_CAMINH" )[ 1 ] )                           , "@!" } }

Local aOrdem        := { AllTrim( RetTitle( "DAK_COD"    ) ) + "+" + AllTrim(RetTitle( "DAK_SEQCAR" )), ;
                         AllTrim( RetTitle( "DAK_DATA"   ) ) ,;
                         AllTrim( RetTitle( "DAK_MOTORI" ) ) ,;
                         AllTrim( RetTitle( "DAK_CAMINH" ) ) }

Private cCadastro   := "Separação/Pesagem de Mercadorias"
Private aHeader     := {}
Private aCols       := {} 
Private cPerg       := "_X1OMS063_"
Private cAliasDAK   := "_DAK" 
Private cAliasSC9   := "_SC9"

Private aFldsSC9    := { "C9_PEDIDO", /*"C9_DATALIB", "C9_ITEM", "C9_SEQUEN",*/ "C9_CLIENTE", "C9_LOJA", "A1_NOME"/*, "C9_PRODUTO", "C9_LOCAL", "B1_DESC", "C9_PRCVEN", "C9_QTDLIB", "B1_UM", "C9_QTDLIB2", "B1_SEGUM"*/ }
Private aFldsDAK    := { "DAK_COD" , "DAK_SEQCAR", "DAK_ROTEIR", "DAK_CAMINH", "DA3_PLACA", "DA3_DESC", "DAK_MOTORI", "DA4_NOME", "DAK_PESO", "DAK_DATA", "DAK_HORA" }

Private cPathExtras := U_LSALXDIR( "SIGAOMS", "LSOMS063" )
Private aColors     := { { "_DAK->DAK_FEZNF == '1' .And. _DAK->DAK_ACECAR == '1' .And. (_DAK->DAK_BLQCAR == '2' .Or. _DAK->DAK_BLQCAR  == ' ') .And. ( _DAK->DAK_JUNTOU=='MANUAL' .Or. _DAK->DAK_JUNTOU=='ASSOCI' .Or. _DAK->DAK_JUNTOU=='JUNTOU' )", "DISABLE"   },; // Faturada e acertada
		                 { "_DAK->DAK_FEZNF == '2' .And. _DAK->DAK_ACECAR == '2' .And. (_DAK->DAK_BLQCAR == '1'                              ) .And. ( _DAK->DAK_JUNTOU=='MANUAL' .Or. _DAK->DAK_JUNTOU=='ASSOCI' .Or. _DAK->DAK_JUNTOU=='JUNTOU' )", "ENABLE"    },; // Apta para Separacao
		                 { "_DAK->DAK_FEZNF == '1' .And. _DAK->DAK_ACECAR == '2' .And. (_DAK->DAK_BLQCAR == '2' .Or. _DAK->DAK_BLQCAR  == ' ') .And. ( _DAK->DAK_JUNTOU=='MANUAL' .Or. _DAK->DAK_JUNTOU=='ASSOCI' .Or. _DAK->DAK_JUNTOU=='JUNTOU' )", "BR_LARANJA"},; // Somente faturada e nao acertada
		                 { "_DAK->DAK_FEZNF == '2' .And. _DAK->DAK_ACECAR == '2' .And. (_DAK->DAK_BLQCAR == '2' .Or. _DAK->DAK_BLQCAR  == ' ') .And. ( _DAK->DAK_JUNTOU=='MANUAL' .Or. _DAK->DAK_JUNTOU=='ASSOCI' .Or. _DAK->DAK_JUNTOU=='JUNTOU' )", "BR_PRETO"  } } // Carga nao liberada para separação"

Private oMSSC9, oGrpNw

SetKey( VK_F12, { || MsgRun ( "Aguarde...", "Atualizando dados...", { || LSOMS063C(  ), iif( Len( LSOMS063G( .T. ) ) > 0, LSOMS063C(  ), Nil ) } ) } )
SetKey( VK_F5 , { || MsgRun ( "Aguarde...", "Atualizando dados...", { || LSOMS063C(  ), iif( Len( LSOMS063G( .F. ) ) > 0, LSOMS063C(  ), Nil ) } ) } )

aAdd( aBotao, { "NOTE"     , {|| LSOMS063S() }, "Separar"              , "Separar"               } )
aAdd( aBotao, { "NOTE"     , {|| LSOMS063X() }, "Finalizar Separação"  , "Finalizar Separação"   } )
aAdd( aBotao, { "RELATORIO", {|| LSOMS063L() }, "Legenda"              , "Legenda"               } )
aAdd( aBotao, { "PESQUISA" , {|| LSOMS063D() }, "Detalhes Carga"       , "Detalhes Carga"        } )
aAdd( aBotao, { "PESQUISA" , {|| LSOMS063T() }, "Resumo Produtos Carga", "Resumo Produtos Carga" } )

aViewDAK := LSOMS063G( .T.  )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa funcao de montagem do aHeader para GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len( aFldsSC9 )
   dBSelectArea("SX3")
   SX3->( dBSetOrder( 2 ) ) 
   SX3->( dBGoTop(  ) ) 
   SX3->( dBSeek( aFldsSC9[ nX ] ) ) 

   Aadd(aHeader, { AllTrim( X3Titulo( ) ),;
                   SX3->X3_CAMPO         ,;
                   SX3->X3_PICTURE       ,;
                   SX3->X3_TAMANHO       ,;
                   SX3->X3_DECIMAL       ,;
                   SX3->X3_VALID         ,;
                   SX3->X3_USADO         ,;
                   SX3->X3_TIPO          ,;
                   SX3->X3_F3            ,;
                   SX3->X3_CONTEXT       ,;
                   SX3->X3_CBOX          ,;
                   SX3->X3_RELACAO       ,;
				   ".T."                 })
Next

Aadd( aCols, Array( Len( aHeader ) + 1 ) )

For nY := 1 To Len( aHeader )
    aCols[ 1 ][ nY ] := CriaVar( aHeader[ nY ][ 2 ] )
Next nY

aCols[ 1 ][ Len( aHeader ) + 1 ] := .F.

aAdd( aObjects, { 100,  010, .T., .T. } )
aAdd( aObjects, { 100,  050, .T., .T. } )
aAdd( aObjects, { 100,  040, .T., .T. } )

aInfo      := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj    := MsObjSize( aInfo, aObjects,.T.)

DEFINE MSDIALOG oDlgMan FROM aSize[7], 000 TO aSize[6],aSize[5] TITLE "Separacao de Mercadorias" OF oMainWnd PIXEL
oSPesq     := TSay():New(      aPosObj[ 1 ][ 1 ] + 14, aPosObj[ 1 ][ 2 ] + 04, { ||  "Pesquisar por:" },oDlgMan,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oCombo     := TComboBox():New( aPosObj[ 1 ][ 1 ] + 13, aPosObj[ 1 ][ 2 ] + 44, { |u| If( PCount() > 0, cCombo:=u, cCombo ) },aOrdem,072,010,oDlgMan,,,{|| ( cAliasDAK )->( dBSetOrder( oCombo:nAt ) ),( cAliasDAK )->( dBGotop() ),xPesq := aPesq[ ( cAliasDAK )->( IndexOrd( ) ) ][ 1 ], ObjectMethod( oMSDAK:oBrowse, "Refresh()" ) }, CLR_BLACK, CLR_WHITE,.T.,,"",,,,,,, cCombo )
oCombo:nAt := 1

oSLoc      := TSay():New( aPosObj[ 1 ][ 1 ] + 14, aPosObj[ 1 ][ 2 ] + 120,{ || "Localizar:" }                 ,oDlgMan,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGet       := TGet():New( aPosObj[ 1 ][ 1 ] + 13, aPosObj[ 1 ][ 2 ] + 150,{ |u| If(PCount()>0,xPesq:=u,xPesq)},oDlgMan,130,008,aPesq[ ( cAliasDAK )->( IndexOrd( ) ) ][ 2 ],,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","xPesq",,)

oBtnB      := TButton():New( aPosObj[ 1 ][ 1 ] + 13, aPosObj[ 1 ][ 2 ] + 290, "Buscar"    ,oDlgMan, { || ( ( cAliasDAK )->( dBGotop(  ) )          ,;
                                                                                                           ( cAliasDAK )->( MsSeek( xPesq ) )      ,;
                                                                                                           ObjectMethod( oMSDAK:oBrowse,"Refresh()") ) },037,012,,,,.T.,,"",,,, .F. )


oGrpMs   := TGroup():New(                                aPosObj[ 2 ][ 1 ]    , aPosObj[ 2 ][ 2 ] + 2, aPosObj[ 2 ][ 3 ]    , aPosObj[ 2 ][ 4 ]      ," Cargas ",oDlgMan,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMSDAK   := MsSelect():New( cAliasDAK,"","",aViewDAK,,,{ aPosObj[ 2 ][ 1 ] + 8, aPosObj[ 2 ][ 2 ] + 4, aPosObj[ 2 ][ 3 ] -2 , aPosObj[ 2 ][ 4 ] - 2  },,,oGrpMs ,,aColors )

oGrpNw   := TGroup():New(                                aPosObj[ 3 ][ 1 ]    , aPosObj[ 3 ][ 2 ] + 2, aPosObj[ 3 ][ 3 ]    , aPosObj[ 3 ][ 4 ]      ,"",oDlgMan,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMSSC9   := MsNewGetDados():New(                         aPosObj[ 3 ][ 1 ] + 8, aPosObj[ 3 ][ 2 ] + 4, aPosObj[ 3 ][ 3 ] - 2, aPosObj[ 3 ][ 4 ] - 2  ,0,'AllwaysTrue()','AllwaysTrue()',"",,0,9999,'AllwaysTrue()',.F.,.F.,oGrpNw, aHeader, aCols )

aViewDAK := LSOMS063C(  )

oMSDAK:oBrowse:blDblClick := { || LSOMS063C(  ) }

ACTIVATE MSDIALOG  oDlgMan ON INIT EnchoiceBar( oDlgMan, { || nOpca := 1,oDlgMan:End()}, {||oDlgMan:End()},, aBotao )

Set Key VK_F12 To
Set Key VK_F5 To

Return( .T. )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063C ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de consulta dos dados dos itens liberados do pedido±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063C( plRet )
**********************************
Local aView         := { }
Local aStruct       := { }
Local cQuery        := ""
Local lShare        := .T.
Local lReadOnly     := .F.
Local hEnter        := Chr( 13 )
Local aFldsSC9      := { "C9_PEDIDO", "C9_DATALIB", "C9_ITEM", "C9_SEQUEN", "C9_CLIENTE", "C9_LOJA", "A1_NOME", "C9_PRODUTO", "C9_LOCAL", "B1_DESC", "C9_PRCVEN", "C9_QTDLIB", "B1_UM", "C9_QTDLIB2", "B1_SEGUM", "C9_CARGA", "C9_X_QTLS", "C9_X_QTL2S", "B1_PESO" }
Local cTabTMP2
Local cArqTrab3
Local nX, nY
Private cIndSC9_1   := CriaTrab(,.F.)
Default plRet       := .T.


CursorWait( )
SysRefresh( )

For nX := 1 To Len( aFldsSC9 )
	aAdd( aStruct, { aFldsSC9[ nX ], U_LSSTRSX3( aFldsSC9[ nX ] )[ 3 ], U_LSSTRSX3( aFldsSC9[ nX ] )[ 4 ], U_LSSTRSX3( aFldsSC9[ nX ] )[ 5 ] } )
    aAdd( aView, { aFldsSC9[ nX ], "", U_LSSTRSX3( aFldsSC9[ nX ] )[ 1 ], U_LSSTRSX3( aFldsSC9[ nX ] )[ 6 ] } )
Next

/*
		±±³          ³C9_BLEST:  02 - Bloqueio de Estoque                         ³±±
		±±³          ³           03 - Bloqueio Manual de Estoque                  ³±±
		±±³          ³C9_BLCRED: 01 - Bloqueio de Credito por Valor               ³±±
		±±³          ³           04 - Vencto do Limite de Credito                 ³±±
		±±³          ³           05 - Bloqueio de Credito por Estorno             ³±±
		±±³          ³           06 - Bloqueio de Credito por Risco               ³±±
		±±³          ³           09 - Rejeicao de Credito                         ³±±
*/

cQuery := "   SELECT SC9.C9_PEDIDO ," + hEnter
cQuery += "          SC9.C9_ITEM   ," + hEnter
cQuery += "          SC9.C9_SEQUEN ," + hEnter
cQuery += "          SC9.C9_CLIENTE," + hEnter
cQuery += "          SC9.C9_LOJA   ," + hEnter
cQuery += "          SA1.A1_NOME   ," + hEnter
cQuery += "          SC9.C9_PRCVEN ," + hEnter
cQuery += "          SC9.C9_QTDLIB ," + hEnter
cQuery += "          SB1.B1_UM     ," + hEnter
cQuery += "          SC9.C9_QTDLIB2," + hEnter
cQuery += "          SB1.B1_SEGUM  ," + hEnter
cQuery += "          SC9.C9_PRODUTO," + hEnter
cQuery += "          SC9.C9_LOCAL  ," + hEnter 
cQuery += "          SB1.B1_DESC   ," + hEnter
cQuery += "          SC9.C9_CARGA  ," + hEnter
cQuery += "          SC9.C9_X_QTLS ," + hEnter
cQuery += "          SC9.C9_X_QTL2S," + hEnter
cQuery += "          SB1.B1_PESO    " + hEnter
cQuery += "     FROM " + RetSqlName( "SC9" ) + " SC9," + hEnter
cQuery += "          " + RetSqlName( "SA1" ) + " SA1," + hEnter
cQuery += "          " + RetSqlName( "SB1" ) + " SB1 " + hEnter
cQuery += "    WHERE SC9.C9_FILIAL        = '" + xFilial( "SC9" ) + "'" + hEnter
cQuery += "      AND SA1.A1_FILIAL        = '" + xFilial( "SA1" ) + "'" + hEnter 
cQuery += "      AND SB1.B1_FILIAL        = '" + xFilial( "SB1" ) + "'" + hEnter 
cQuery += "      AND SC9.C9_PRODUTO       = SB1.B1_COD"   + hEnter 
cQuery += "      AND SC9.C9_CLIENTE       = SA1.A1_COD"   + hEnter 
cQuery += "      AND SC9.C9_LOJA          = SA1.A1_LOJA"  + hEnter 
cQuery += "      AND SC9.C9_CARGA         = '" + ( cAliasDAK )->DAK_COD   + "'" + hEnter  
cQuery += "      AND SC9.C9_SEQCAR        = '" + ( cAliasDAK )->DAK_SEQCAR + "'" + hEnter  
//cQuery += "   	 AND SC9.C9_BLEST         = '" + Space( TamSX3( 'C9_BLEST'  )[ 1 ] ) + "'" + hEnter  
//cQuery += "	 	 AND SC9.C9_BLCRED 	      = '" + Space( TamSX3( 'C9_BLCRED' )[ 1 ] ) + "'" + hEnter  
cQuery += "      AND SC9.C9_DATALIB  > CONCAT(YEAR(GETDATE())-1,'0101')"  + hEnter 
cQuery += "      AND SC9.D_E_L_E_T_      <> '*'" + hEnter
cQuery += "      AND SA1.D_E_L_E_T_      <> '*'" + hEnter
cQuery += "      AND SB1.D_E_L_E_T_      <> '*'" + hEnter
cQuery += " ORDER BY SC9.C9_PEDIDO"              + hEnter

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena em arquivo a instrução SQL gerada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MemoWrite( cPathExtras + Procname() + ".SQL", cQuery )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se arquivo Temporário existir fecha o mesmo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( cAliasSC9 ) > 0
	( cAliasSC9 )->( dBCloseArea( ) )
	Ferase( lower( cAliasSC9 ) + GetDBExtension( ) )
	Ferase( lower( cAliasSC9 ) + OrdBagExt( ) )
EndIf       

cTabTMP2:= CriaTrab( aStruct, .T. ) 

dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery( cQuery ) ), cAliasSC9, .T., .T. )

For nX := 1 To Len( aStruct )
	If aStruct[ nX ][ 2 ] <> "C" .And. FieldPos( aStruct[ nX ][ 1 ] ) <> 0
	   TcSetField( cAliasSC9, aStruct[ nX ][ 1 ], aStruct[ nX ][ 2 ], aStruct[ nX ][ 3 ], aStruct[ nX ][ 4 ] )
	EndIf
Next nX

Copy TO &cTabTMP2
dBCloseArea()
dBUseArea( .T.,, cTabTMP2, cAliasSC9, lShare, lReadOnly )  

( cAliasSC9 )->( dBGoTop( ) )

IndRegua( cAliasSC9, cIndSC9_1,"C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_CLIENTE + C9_LOJA + C9_PRODUTO + C9_LOCAL" )
( cAliasSC9 )->( dBClearIndex( ) )
( cAliasSC9 )->( dbSetIndex( cIndSC9_1 + OrdBagExt() ) )
( cAliasSC9 )->( dBGoTop( ) )

aCols := {}

If !plRet
	aFldsSC9  := { "C9_PEDIDO", "C9_DATALIB", "C9_ITEM", "C9_SEQUEN","C9_CLIENTE", "C9_LOJA", "A1_NOME", "C9_PRODUTO", "C9_LOCAL", "B1_DESC", "C9_PRCVEN", "C9_QTDLIB", "B1_UM", "C9_QTDLIB2", "B1_SEGUM", "C9_CARGA", "C9_X_QTLS", "C9_X_QTL2S", "B1_PESO" }
	aHeader   := { }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa funcao de montagem do aHeader para GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len( aFldsSC9 )
		dBSelectArea("SX3")
		SX3->( dBSetOrder( 2 ) )
		SX3->( dBGoTop(  ) )
		SX3->( dBSeek( aFldsSC9[ nX ] ) )
		
		Aadd(aHeader, { AllTrim( X3Titulo( ) ),;
	 	                SX3->X3_CAMPO         ,;
		                SX3->X3_PICTURE       ,;
		                SX3->X3_TAMANHO       ,;
		                SX3->X3_DECIMAL       ,;
		                SX3->X3_VALID         ,;
		                SX3->X3_USADO         ,;
		                SX3->X3_TIPO          ,;
		                SX3->X3_F3            ,;
		                SX3->X3_CONTEXT       ,;
		                SX3->X3_CBOX          ,;
		                SX3->X3_RELACAO       ,;
		                ".T."                 })
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !( cAliasSC9 )->( Eof( ) )
	
	aAdd( aCols, Array( Len( aHeader ) + 1 ) )
	For nX := 1 To Len( aHeader )
		If aHeader[ nX ][ 10 ] != "V"
			If !Empty( nPos := ( cAliasSC9 )->( FieldPos( aHeader[ nX ][ 2 ] ) ) )
				aCols[ Len( aCols ) ][ nX ] := ( cAliasSC9 )->( FieldGet( nPos ) )
			EndIf
			
		Else
			aCols[ Len( aCols ) ][ nX ] := CriaVar( aHeader[ nX ][ 2 ])
		EndIf
	Next
	
	aCols[ Len( aCols ) ][ Len( aHeader ) + 1 ] := .F.
	( cAliasSC9 )->( dBSkip( ) )
	
EndDo

If plRet
	aAux       := aClone( aCols )
	aCols      := {}
	nPosB      := aScan( aHeader,{ |x| Trim( x[ 2 ] ) == "C9_PEDIDO" } )
	aFldsSC9   := { "C9_PEDIDO", /*"C9_DATALIB", "C9_ITEM", "C9_SEQUEN",*/ "C9_CLIENTE", "C9_LOJA", "A1_NOME"/*, "C9_PRODUTO", "C9_LOCAL", "B1_DESC", "C9_PRCVEN", "C9_QTDLIB", "B1_UM", "C9_QTDLIB2", "B1_SEGUM"*/ }
	
	For nX := 1 To Len( aAux )
		
		nPos := aSCan( aCols, { |X| X[ nPosB ] == aAux[ nX ][ nPosB ] } )
		If nPos == 0
			aAdd( aCols, Array( Len( aHeader ) + 1 ) )
			
			For nY := 1 To Len( aHeader )
				If aHeader[ nY ][ 10 ] != "V"
					
					If !Empty( nPos := FieldPos( aHeader[ nY ][ 2 ] ) )
						aCols[ Len( aCols ) ][ nY ] := aAux[ nX ][ nY ]
					EndIf
					
				Else
					aCols[ Len( aCols ) ][ nY ] := CriaVar( aHeader[ nY ][ 2 ])
				EndIf
			Next
			
			aCols[ Len( aCols ) ][ Len( aHeader ) + 1 ] := .F.
		Endif
	Next
	
	If Type( 'oMSSC9' ) <> 'U'
		oMSSC9:aCols     := aCols
		ObjectMethod( oMSSC9:oBrowse, "Refresh()" )
	Endif
	
	If Type( 'oGrpNw' ) <> 'U'
    	oGrpNw:cCaption  := " Pedidos da Carga: " + ( cAliasDAK )->DAK_COD + " - Seq. Carga: " + ( cAliasDAK )->DAK_SEQCAR + " "
		oGrpNw:cTitle    := " Pedidos da Carga: " + ( cAliasDAK )->DAK_COD + " - Seq. Carga: " + ( cAliasDAK )->DAK_SEQCAR + " "
	Endif
Else
   aView := { aHeader, aCols }
Endif


CursorArrow()
SysRefresh()

Return( aView )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063G ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de consulta dos dados das cargas                   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063G( lPergunte )
**************************************
Local aView         := { }
Local aStruct       := { }
Local cQuery        := ""
Local lShare        := .T.
Local lReadOnly     := .F.
Local hEnter        := Chr( 13 )
Local cTabTMP2
Local cArqTrab3, nX, nY
Private cIndDAK_1   := CriaTrab(,.F.)
Private cIndDAK_2   := CriaTrab(,.F.)
Private cIndDAK_3   := CriaTrab(,.F.)
Private cIndDAK_4   := CriaTrab(,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parämetros                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1( cPerg )

If	( ! Pergunte( cPerg, lPergunte ) )
	Return( { }  )
Endif

CursorWait( )
SysRefresh( )

For nX := 1 To Len( aFldsDAK )
	aAdd( aStruct, { aFldsDAK[ nX ], U_LSSTRSX3( aFldsDAK[ nX ] )[ 3 ], U_LSSTRSX3( aFldsDAK[ nX ] )[ 4 ], U_LSSTRSX3( aFldsDAK[ nX ] )[ 5 ] } )
	
	If !"DAK_FEZNF/DAK_ACECAR/DAK_BLQCAR/DAK_JUNTOU"  $ aFldsDAK[ nX ]
		aAdd( aView, { aFldsDAK[ nX ], "", U_LSSTRSX3( aFldsDAK[ nX ] )[ 1 ], U_LSSTRSX3( aFldsDAK[ nX ] )[ 6 ] } )
	Endif
Next

cQuery := "   SELECT DAK.DAK_COD    ," + hEnter
cQuery += "          DAK.DAK_SEQCAR ," + hEnter
cQuery += "          DAK.DAK_ROTEIR ," + hEnter
cQuery += "          DAK.DAK_CAMINH ," + hEnter
cQuery += "          DA3.DA3_PLACA  ," + hEnter
cQuery += "          DA3.DA3_DESC   ," + hEnter
cQuery += "          DAK.DAK_MOTORI ," + hEnter
cQuery += "          DA4.DA4_NOME   ," + hEnter
cQuery += "          DAK.DAK_PESO   ," + hEnter
cQuery += "          DAK.DAK_DATA   ," + hEnter
cQuery += "          DAK.DAK_HORA   ," + hEnter
cQuery += "          DAK.DAK_FEZNF  ," + hEnter
cQuery += "          DAK.DAK_ACECAR ," + hEnter
cQuery += "          DAK.DAK_BLQCAR ," + hEnter
cQuery += "          DAK.DAK_JUNTOU  " + hEnter
cQuery += "     FROM " + RetSqlName( "DAK" ) + " DAK," + hEnter
cQuery += "          " + RetSqlName( "DA3" ) + " DA3," + hEnter
cQuery += "          " + RetSqlName( "DA4" ) + " DA4 " + hEnter
cQuery += "    WHERE DAK.DAK_FILIAL       = '" + xFilial( "DAK" ) + "'" + hEnter
cQuery += "      AND DA3.DA3_FILIAL       = '" + xFilial( "DA3" ) + "'" + hEnter 
cQuery += "      AND DA4.DA4_FILIAL       = '" + xFilial( "DA4" ) + "'" + hEnter 
cQuery += "      AND DA3.DA3_COD          = DAK.DAK_CAMINH" + hEnter  
cQuery += "      AND ( DA4.DA4_COD        = DAK.DAK_MOTORI OR DA4.DA4_COD = '' )" + hEnter  
cQuery += "      AND ( DAK.DAK_COD       >= '" + MV_PAR01 + "' ) AND ( DAK.DAK_COD <= '" + MV_PAR02 + "' )" + hEnter 

If MV_PAR03 == 1
	cQuery += "      AND DAK.DAK_BLQCAR       = '1'" + hEnter
Endif

cQuery += "      AND DAK.D_E_L_E_T_      <> '*'" + hEnter
cQuery += "      AND DA3.D_E_L_E_T_      <> '*'" + hEnter
cQuery += "      AND DA4.D_E_L_E_T_      <> '*'" + hEnter
cQuery += " ORDER BY DAK.DAK_COD"                + hEnter

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena em arquivo a instrução SQL gerada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MemoWrite( cPathExtras + Procname() + ".SQL", cQuery )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se arquivo Temporário existir fecha o mesmo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( cAliasDAK ) > 0
	( cAliasDAK )->( dBCloseArea( ) )
	Ferase( lower( cAliasDAK ) + GetDBExtension( ) )
	Ferase( lower( cAliasDAK ) + OrdBagExt( ) )
EndIf       

cTabTMP2:= CriaTrab( aStruct, .T. ) 

dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery( cQuery ) ), cAliasDAK, .T., .T. )

For nX := 1 To Len( aStruct )
	If aStruct[ nX ][ 2 ] <> "C" .And. FieldPos( aStruct[ nX ][ 1 ] ) <> 0
	   TcSetField( cAliasDAK, aStruct[ nX ][ 1 ], aStruct[ nX ][ 2 ], aStruct[ nX ][ 3 ], aStruct[ nX ][ 4 ] )
	EndIf
Next nX

Copy TO &cTabTMP2
dBCloseArea()
dBUseArea( .T.,, cTabTMP2, cAliasDAK, lShare, lReadOnly )  

( cAliasDAK )->( dBGoTop( ) )

IndRegua( cAliasDAK, cIndDAK_1,"DAK_COD + DAK_SEQCAR" )
IndRegua( cAliasDAK, cIndDAK_2,"DTOS( DAK_DATA )"     )
IndRegua( cAliasDAK, cIndDAK_3,"DAK_MOTORI"           )
IndRegua( cAliasDAK, cIndDAK_4,"DAK_CAMINH"           )

( cAliasDAK )->( dBClearIndex( ) )
( cAliasDAK )->( dbSetIndex( cIndDAK_1 + OrdBagExt() ) )
( cAliasDAK )->( dbSetIndex( cIndDAK_2 + OrdBagExt() ) )
( cAliasDAK )->( dbSetIndex( cIndDAK_3 + OrdBagExt() ) )
( cAliasDAK )->( dbSetIndex( cIndDAK_4 + OrdBagExt() ) )

( cAliasDAK )->( dBGoTop( ) )

CursorArrow()
SysRefresh()

Return( aView )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063S ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de separação de mercadorias                        ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063S()
***************************
Local aArea      := GetArea( )
Local nPosSC9    := oMSSC9:nAt
Local cSituacao  := ""
Local aFldsAlt   := { "C9_ITEM", "C6_PRODUTO",  "B1_DESC", "C6_QTDLIB", "C6_UM", "C6_QTDLIB2", "C6_SEGUM", "C6_CLI", "C6_LOJA", "A1_NOME", "C6_LOCAL", "C9_SEQUEN"  }
Local aSize      := MsAdvSize(,.F.,430)
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aProdutos  := {}
Local aHeaderA   := {}
Local aColsA     := {}
Local nOption    := 0
Local nPosClA    := 0
Local nPosLjA    := 0
Local nPosNmA    := 0
Local nPosPdA    := 0
Local nPosLcA    := 0
Local nPosDsA    := 0
Local nPosQtA    := 0
Local nPosUMA    := 0
Local nPosQt2A   := 0
Local nPosUM2A   := 0
Local cCarga     := ""
Local cHoraEmb   := ""
Local dDataEmb   := ""
Local cObsEmb    := "" 
Local lGo        := .T.
Local nX, nY
Private cPedido  := Space( TamSX3( 'C9_PEDIDO'  )[ 1 ] )
Private cDescCli := Space( TamSX3( 'C9_CLIENTE' )[ 1 ] + TamSX3( 'C9_LOJA' )[ 1 ]  + TamSX3( 'A1_NOME' )[ 1 ] + 5 )
Private cUnMed1  := Space( TamSX3( 'B1_UM'      )[ 1 ] )
Private cUnMed2  := Space( TamSX3( 'B1_UM'      )[ 1 ] )
Private nQtd1    := 0
Private nQtd2    := 0
Private nPeso1   := 0
Private nPeso2   := 0
Private oGum1    := oQtd1 := oPes1 := oGum2 := oQtd2 := oPes2 := oMSSC6 := Nil
Private aMedidas := { }

LSOMS063C(  )

Do Case
	Case _DAK->DAK_FEZNF == '1' .And. _DAK->DAK_ACECAR == '1' .And. (_DAK->DAK_BLQCAR == '2' .Or. _DAK->DAK_BLQCAR  == ' ') .And. ( _DAK->DAK_JUNTOU=='MANUAL' .Or. _DAK->DAK_JUNTOU=='ASSOCI' .Or. _DAK->DAK_JUNTOU=='JUNTOU' )
		cSituacao := "Faturada e acertada"
		lGo       := .F.
		
	Case _DAK->DAK_FEZNF == '1' .And. _DAK->DAK_ACECAR == '2' .And. (_DAK->DAK_BLQCAR == '2' .Or. _DAK->DAK_BLQCAR  == ' ') .And. ( _DAK->DAK_JUNTOU=='MANUAL' .Or. _DAK->DAK_JUNTOU=='ASSOCI' .Or. _DAK->DAK_JUNTOU=='JUNTOU' )
		cSituacao := "Somente faturada e nao acertada"
		lGo       := .F.
		
	Case _DAK->DAK_FEZNF == '2' .And. _DAK->DAK_ACECAR == '2' .And. (_DAK->DAK_BLQCAR == '2' .Or. _DAK->DAK_BLQCAR  == ' ') .And. ( _DAK->DAK_JUNTOU=='MANUAL' .Or. _DAK->DAK_JUNTOU=='ASSOCI' .Or. _DAK->DAK_JUNTOU=='JUNTOU' )
		cSituacao := "Carga nao liberada para separação"
		lGo       := .F.
EndCase

If !lGo
	Aviso( "Atenção!", "A Carga Selecionada não esta apta para separação ! (" + cSituacao + ")", { "OK" }, 2 )
	Return( .F. )
     
Else
    INCLUI := .F.
	ALTERA := .T.

	For nX := 1 To Len( aFldsAlt )
		dBSelectArea( "SX3" )
		SX3->( dBSetOrder( 2 ) )
		SX3->( dBGoTop(  ) )
		
		If SX3->( MsSeek( Alltrim( aFldsAlt[ nX ] ) ) )
			lWhen   := iif( Alltrim( aFldsAlt[ nX ] ) == "C6_QTDLIB" .Or. aFldsAlt[ nX ] == "C6_QTDLIB2", ".T.", ".F." )
			lValid  := ""
			lValidU := ""
			cTitulo := iif( Alltrim( aFldsAlt[ nX ] ) == "C9_SEQUEN", "Seq. Liber.", AllTrim( X3Titulo( ) ) )
			
			Aadd( aHeaderA, { cTitulo               ,;
			                  SX3->X3_CAMPO         ,;
			                  SX3->X3_PICTURE       ,;
			                  SX3->X3_TAMANHO       ,;
			                  SX3->X3_DECIMAL       ,;
			                  lValid                ,;
			                  SX3->X3_USADO         ,;
			                  SX3->X3_TIPO          ,;
			                  SX3->X3_F3            ,;
			                  SX3->X3_CONTEXT       ,;
			                  SX3->X3_CBOX          ,;
			                  SX3->X3_RELACAO       ,;
			                  lWhen                 ,;
			                  lWhen                 ,;
			                  lValidU               })
		Endif
	Next
	
	If Len( aColsA ) == 0
		Aadd( aColsA, Array( Len( aHeaderA ) + 1 ) )
		
		For nY := 1 To Len( aHeaderA )
			aColsA[ 1 ][ nY ] := CriaVar( aHeaderA[ nY ][ 2 ] )
		Next nY
		
		aColsA[ 1 ][ Len( aHeaderA ) + 1 ] := .F.
	Endif
	
	aSize[ 1 ] /= 1.2
	aSize[ 2 ] /= 1.2
	aSize[ 3 ] /= 1.2
	aSize[ 4 ] /= 1.2
	aSize[ 5 ] /= 1.2
	aSize[ 6 ] /= 1.2
	aSize[ 7 ] /= 1.2
	
	aAdd( aObjects, { 100,  012, .T., .T. } )
	aAdd( aObjects, { 100,  012, .T., .T. } )
	aAdd( aObjects, { 100,  053, .T., .T. } )
	aAdd( aObjects, { 100,  023, .T., .T. } )
	
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 4, 4 }
	aPosObj  := MsObjSize( aInfo, aObjects,.T.)
	
	cCarga   := _DAK->DAK_COD + "/" + _DAK->DAK_SEQCAR + "-VEICULO: " + _DAK->DA3_PLACA + " - " + Alltrim( _DAK->DA3_DESC ) + " - MOTORISTA: " + Alltrim( _DAK->DA4_NOME )
	cPedido  := Space( TamSX3( 'C9_PEDIDO'  )[ 1 ] )
	cDescCli := Space( TamSX3( 'C9_CLIENTE' )[ 1 ] + TamSX3( 'C9_LOJA' )[ 1 ]  + TamSX3( 'A1_NOME' )[ 1 ] + 5 )
	cUnMed1  := cUnMed2  := Space( TamSX3( 'B1_UM'      )[ 1 ] )
	nQtd1    := nQtd2    := 0
	nPeso1   := nPeso2   := 0
	
	dBSelectArea( "DAK" )
	DAK->( dBSetOrder( 1 ) )
	DAK->( dBGoTop(  ) )
	DAK->( dBSeek( xFilial( "DAK" ) + _DAK->DAK_COD + _DAK->DAK_SEQCAR ) )
	cHoraEmb := DAK->DAK_X_HREM
	dDataEmb := DAK->DAK_X_DTPE
	cObsEmb  := DAK->DAK_X_OBS
	
	DEFINE DIALOG oDlgApon TITLE "Apontamento da Separação de Mercadorias" FROM aSize[ 7 ],000 TO aSize[ 6 ], aSize[ 5 ] pixel
	
	oGrpCabCga   := TGroup():New( aPosObj[ 1 ][ 1 ], aPosObj[ 1 ][ 2 ] + 2, aPosObj[ 1 ][ 3 ], aPosObj[ 1 ][ 4 ]," Carga "          , oDlgApon,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGrpPedCga   := TGroup():New( aPosObj[ 2 ][ 1 ], aPosObj[ 2 ][ 2 ] + 2, aPosObj[ 2 ][ 3 ], aPosObj[ 2 ][ 4 ]," Pedido/Clientes ", oDlgApon,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGrpPedDet   := TGroup():New( aPosObj[ 3 ][ 1 ], aPosObj[ 3 ][ 2 ] + 2, aPosObj[ 3 ][ 3 ], aPosObj[ 3 ][ 4 ]," Separação "      , oDlgApon,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGrpDetSep   := TGroup():New( aPosObj[ 4 ][ 1 ], aPosObj[ 4 ][ 2 ] + 2, aPosObj[ 4 ][ 3 ], aPosObj[ 4 ][ 4 ]," Detalhes "       , oDlgApon,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	TSay():New(              aPosObj[ 1 ][ 1 ] + 9, aPosObj[ 1 ][ 2 ] + 6, { || cCarga },oGrpCabCga,,TFont():New( "MS Sans Serif",0,-19,,.T.,0,,700,.F.,.F.,,,,,, ),.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,( oGrpCabCga:nWidth/2 )-2,020)
	
	TSay():New(              aPosObj[ 2 ][ 1 ] + 12,0010,{||"Pedido"},oGrpPedCga,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oGPedido  := TGet():New( aPosObj[ 2 ][ 1 ] + 11,028,{|u| If( PCount() > 0, cPedido  := u, cPedido ) },oGrpPedCga,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC5","cPedido",,)
    oGDadosC  := TGet():New( aPosObj[ 2 ][ 1 ] + 11,085,{|u| If( PCount() > 0, cDescCli := u, cDescCli ) },oGrpPedCga,250,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescCli",,)
	oMSSC6    := MsNewGetDados():New( aPosObj[ 3 ][ 1 ] + 8, aPosObj[ 3 ][ 2 ] + 4, aPosObj[ 3 ][ 3 ] - 2, aPosObj[ 3 ][ 4 ] - 2,GD_INSERT + GD_UPDATE,'U_LSOMS06K()','U_LSOMS06K()',"",,0,9999,'U_LSOMS06K(1)',.F.,.F.,oGrpPedDet, aHeaderA, aColsA )
	
	oGDadosC:lActive := .F.
	
	TSay():New( aPosObj[ 4 ][ 1 ] + 08,012,{||"1a Un. Medida"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
    TSay():New( aPosObj[ 4 ][ 1 ] + 08,075,{||"Quantidade"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
    TSay():New( aPosObj[ 4 ][ 1 ] + 08,150,{||"Peso"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
    TSay():New( aPosObj[ 4 ][ 1 ] + 08,220,{||"Data Embarque"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
    TSay():New( aPosObj[ 4 ][ 1 ] + 08,280,{||"Observações"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)

	TSay():New( aPosObj[ 4 ][ 1 ] + 27,012,{||"2a Un. Medida"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
    TSay():New( aPosObj[ 4 ][ 1 ] + 27,075,{||"Quantidade"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
    TSay():New( aPosObj[ 4 ][ 1 ] + 27,150,{||"Peso"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
    TSay():New( aPosObj[ 4 ][ 1 ] + 27,220,{||"Hora Embarque"},oGrpDetSep,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)

    oGum1      := TGet():New( aPosObj[ 4 ][ 1 ] + 16,012,{|u| If(PCount()>0,cUnMed1:=u,cUnMed1)},oGrpDetSep,048,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cUnMed1",,)
    oQtd1      := TGet():New( aPosObj[ 4 ][ 1 ] + 16,075,{|u| If(PCount()>0,nQtd1:=u,nQtd1)},oGrpDetSep,055,008  ,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nQtd1",,)
    oPes1      := TGet():New( aPosObj[ 4 ][ 1 ] + 16,150,{|u| If(PCount()>0,nPeso1:=u,nPeso1)},oGrpDetSep,055,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nPeso1",,)
    oDtEmb     := TGet():New( aPosObj[ 4 ][ 1 ] + 16,220,{|u| If(PCount()>0,dDataEmb:=u,dDataEmb)},oGrpDetSep,055,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDataEmb",,)
    oMGet      := TMultiGet():New( aPosObj[ 4 ][ 1 ] + 16,280,{|u| If(PCount()>0,cObsEmb:=u,cObsEmb)},oGrpDetSep,220,030,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  ) 

    oGum2      := TGet():New( aPosObj[ 4 ][ 1 ] + 35,012,{|u| If(PCount()>0,cUnMed2 :=u,cUnMed2 )},oGrpDetSep,048,008,'@!'               ,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cUnMed2",,)
    oQtd2      := TGet():New( aPosObj[ 4 ][ 1 ] + 35,075,{|u| If(PCount()>0,nQtd2   :=u,nQtd2   )},oGrpDetSep,055,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nQtd2",,)
    oPes2      := TGet():New( aPosObj[ 4 ][ 1 ] + 35,150,{|u| If(PCount()>0,nPeso2  :=u,nPeso2  )},oGrpDetSep,055,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nPeso2",,)
    oHrEmb     := TGet():New( aPosObj[ 4 ][ 1 ] + 35,220,{|u| If(PCount()>0,cHoraEmb:=u,cHoraEmb)},oGrpDetSep,055,008,'99:99'            ,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHoraEmb",,)

	oGPedido:bValid := { || LSOMS063V( @oGPedido, @cPedido, ;
	                                   @cDescCli, @oGDadosC,;
	                                   oMSSC6   , aHeaderA ,;
	                                   aColsA ) }

	ACTIVATE DIALOG oDlgApon CENTERED ON INIT ( EnchoiceBar( oDlgApon,{|| iif( Aviso("Atenção", "Deseja realmente efetivar esta separação ?", { "Sim","Não" } ) == 1, ( LSOMS063Y( cPedido, oMSSC6, aFldsAlt, cHoraEmb, dDataEmb, cObsEmb ), LSOMS063C(  ), oDlgApon:End() ), .F. ) },{|| nOption := 0,oDlgApon:End() } ), ( CursorArrow(), SysRefresh() ) )

Endif

RestArea( aArea )

Return( lGo )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063V ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de verificação e exibição dos itens do pedido      ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063V( oGPedido, cPedido, cDescCli, oGDadosC, oMSSC6, aHeaderA , aColsA )
*********************************************************************************************
Local nPosItem   := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_ITEM"    } )
Local nPosClA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_CLI"     } )
Local nPosLjA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_LOJA"    } )
Local nPosNmA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "A1_NOME"    } )
Local nPosPdA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_PRODUTO" } )
Local nPosLcA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_LOCAL"   } )
Local nPosSeq    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_SEQUEN"  } )
Local nPosDsA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_DESC"    } )
Local nPosQtA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_QTDLIB"  } )
Local nPosUMA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_UM"      } )
Local nPosQt2A   := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_QTDLIB2" } )
Local nPosUM2A   := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_SEGUM"   } )
Local lRet       := .T.
Local cDescCli   := Space( TamSX3( 'C9_CLIENTE' )[ 1 ] + TamSX3( 'C9_LOJA' )[ 1 ]  + TamSX3( 'A1_NOME' )[ 1 ] + 5 )
Local nQtd1aUm   := 0
Local nQtd2aUm   := 0
Local nX, nY


aColsA   := { }
aMedidas := { }

If ExistCPO( "SC5", cPedido )
	aAreaSC9 := ( cAliasSC9 )->( GetArea( ) )
	( cAliasSC9 )->( dBGoTop( ) )
	
	While !( cAliasSC9 )->( Eof( ) )
		If ( cAliasSC9 )->C9_CARGA == ( cAliasDAK )->DAK_COD .And. ( cAliasSC9 )->C9_PEDIDO == cPedido
			
			If Empty( cDescCli )
				cDescCli := Alltrim( ( cAliasSC9 )->C9_CLIENTE ) +" " + ( cAliasSC9 )->C9_LOJA + " - " + ( cAliasSC9 )->A1_NOME
			Endif
			
			aAdd( aColsA, Array( Len( aHeaderA ) + 1 ) )
			
			For nX := 1 To Len( aHeaderA )
			    if ( cAliasSC9 )->C9_X_QTLS > 0
			       nQtd1aUm := ( cAliasSC9 )->C9_X_QTLS
			       nQtd2aUm := ( cAliasSC9 )->C9_X_QTL2S
			    else
			       nQtd1aUm := ( cAliasSC9 )->C9_QTDLIB
			       nQtd2aUm := ( cAliasSC9 )->C9_QTDLIB2
			    endif
			    
			    aColsA[ Len( aColsA ) ][ nPosItem ] := ( cAliasSC9 )->C9_ITEM
				aColsA[ Len( aColsA ) ][ nPosClA  ] := ( cAliasSC9 )->C9_CLIENTE
				aColsA[ Len( aColsA ) ][ nPosLjA  ] := ( cAliasSC9 )->C9_LOJA
				aColsA[ Len( aColsA ) ][ nPosNmA  ] := ( cAliasSC9 )->A1_NOME
				aColsA[ Len( aColsA ) ][ nPosPdA  ] := ( cAliasSC9 )->C9_PRODUTO
				aColsA[ Len( aColsA ) ][ nPosLcA  ] := ( cAliasSC9 )->C9_LOCAL
			    aColsA[ Len( aColsA ) ][ nPosSeq  ] := ( cAliasSC9 )->C9_SEQUEN
				aColsA[ Len( aColsA ) ][ nPosDsA  ] := ( cAliasSC9 )->B1_DESC
				aColsA[ Len( aColsA ) ][ nPosQtA  ] := nQtd1aUm
				aColsA[ Len( aColsA ) ][ nPosUMA  ] := ( cAliasSC9 )->B1_UM
				aColsA[ Len( aColsA ) ][ nPosQt2A ] := nQtd2aUm
				aColsA[ Len( aColsA ) ][ nPosUM2A ] := ( cAliasSC9 )->B1_SEGUM
			Next
			
			nPos := aScan( aMedidas, { |X| Alltrim( X[ 1 ] ) == Alltrim( ( cAliasSC9 )->B1_UM ) } )

			If nPos == 0
			   aAdd( aMedidas, { ( cAliasSC9 )->B1_UM, nQtd1aUm, nQtd1aUm * ( cAliasSC9 )->B1_PESO } )
			Else
			   aMedidas[ nPos ][ 2 ] += nQtd1aUm
			   aMedidas[ nPos ][ 3 ] += nQtd1aUm * ( cAliasSC9 )->B1_PESO
			Endif

			nPos := aScan( aMedidas, { |X| Alltrim( X[ 1 ] ) == Alltrim( ( cAliasSC9 )->B1_SEGUM ) } )

			If nPos == 0
			   aAdd( aMedidas, { ( cAliasSC9 )->B1_SEGUM, nQtd2aUm,  nQtd2aUm * ( cAliasSC9 )->B1_PESO } )
			Else
			   aMedidas[ nPos ][ 2 ] += nQtd2aUm
			   aMedidas[ nPos ][ 3 ] += nQtd2aUm * ( cAliasSC9 )->B1_PESO
			Endif

			aColsA[ Len( aColsA ) ][ Len( aHeaderA ) + 1 ] := .F.
		Endif
		
		( cAliasSC9 )->( dBSkip( ) )
		
	EndDo
	
	RestArea( aAreaSC9 )
	
	If Len( aColsA ) == 0
		lRet := .F.
		Aviso( "Atenção", "Pedido de Venda não Pertencente a esta Carga !", { "OK" } )
		Aadd( aColsA, Array( Len( aHeaderA ) + 1 ) )
		
		For nY := 1 To Len( aHeaderA )
			aColsA[ 1 ][ nY ] := CriaVar( aHeaderA[ nY ][ 2 ] )
		Next nY
		
		aColsA[ 1 ][ Len( aHeaderA ) + 1 ] := .F.
	Endif

	For nX := 1 to Len( aMedidas )
	    do case
	       case nX == 1
	            cUnMed1 := aMedidas[ 1 ][ 1 ]
	            nQtd1   := aMedidas[ 1 ][ 2 ]
	            nPeso1  := aMedidas[ 1 ][ 3 ]

	            oGum1:SetText( aMedidas[ 1 ][ 1 ] )
	            oQtd1:SetText( aMedidas[ 1 ][ 2 ] )
	            oPes1:SetText( aMedidas[ 1 ][ 3 ] )

	            oGum1:Refresh()
	            oQtd1:Refresh()
	            oPes1:Refresh()

	       case nX == 2
	            cUnMed2 := aMedidas[ 2 ][ 1 ]
	            nQtd2   := aMedidas[ 2 ][ 2 ]
	            nPeso2  := aMedidas[ 2 ][ 3 ]

	            oGum2:SetText( aMedidas[ 2 ][ 1 ] )
	            oQtd2:SetText( aMedidas[ 2 ][ 2 ] )
	            oPes2:SetText( aMedidas[ 2 ][ 3 ] )

	            oGum2:Refresh()
	            oQtd2:Refresh()
	            oPes2:Refresh()

	    endcase
	
	Next
	
	oMSSC6:aCols := aColsA
	cDescCli := cDescCli
	
	oGDadosC:SetText( cDescCli )
    oGDadosC:Refresh( )
	ObjectMethod( oMSSC6:oBrowse, "Refresh()" )

Else
   lRet := .F.
Endif

Return( lRet )
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063L ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de exibição da Legenda.                            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063L()
***************************                                             
Local aLegenda := { { "BR_VERMELHO", "Faturada e acertada"               },;
	                { "BR_VERDE"   , "Apta para Separação"               },;
	                { "BR_LARANJA" , "Somente faturada e nao acertada"   },;
	                { "BR_PRETO"   , "Carga nao liberada para separação" }}
	                
LSOMS063C(  )

BrwLegenda( cCadastro, OemToAnsi( "Status" ), aLegenda  )

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063D ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de exibição dos detalhes de carga                  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063D()
***************************
LSOMS063C(  )
dBSelectArea( "DAK" )
DAK->( dBSetOrder( 1 ) )
DAK->( dBGoTop( ) )
If DAK->( dbSeek( xFilial( "DAK" ) + ( cAliasDAK )->DAK_COD + ( cAliasDAK )->DAK_SEQCAR ) )
	Os200Visual( "DAK", DAK->( Recno( ) ), 4 )
Endif

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063T ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Resumo dos Produtos da Carga                                ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063T()
***************************
Local aFldsRes   := { "C9_CLIENTE", "C9_LOJA", "A1_NOME" , "C9_PRODUTO", "C9_LOCAL", "B1_DESC", "C9_QTDLIB", "B1_UM", "C9_QTDLIB2", "B1_SEGUM"  }
Local aSize      := MsAdvSize(,.F.,430)
Local aProdutos  := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aHeaderR   := {}
Local aColsR     := {}
Local nOption    := 0
Local nPosClR    := 0
Local nPosLjR    := 0
Local nPosNmR    := 0
Local nPosPdR    := 0
Local nPosLcR    := 0
Local nPosDsR    := 0
Local nPosQtR    := 0
Local nPosUMR    := 0
Local nPosQt2R   := 0
Local nPosUM2R   := 0
Local nX, nY 
LSOMS063C(  )

For nX := 1 To Len( aFldsRes )
   dBSelectArea("SX3")
   SX3->( dBSetOrder( 2 ) ) 
   SX3->( dBGoTop(  ) ) 
   SX3->( dBSeek( aFldsRes[ nX ] ) ) 

   Aadd( aHeaderR, { AllTrim( X3Titulo( ) ),;
                     SX3->X3_CAMPO         ,;
                     SX3->X3_PICTURE       ,;
                     SX3->X3_TAMANHO       ,;
                     SX3->X3_DECIMAL       ,;
                     SX3->X3_VALID         ,;
                     SX3->X3_USADO         ,;
                     SX3->X3_TIPO          ,;
                     SX3->X3_F3            ,;
                     SX3->X3_CONTEXT       ,;
                     SX3->X3_CBOX          ,;
                     SX3->X3_RELACAO       ,;
				     ".T."                 })
Next

nPosClR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "C9_CLIENTE" } )
nPosLjR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "C9_LOJA"    } )
nPosNmR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "A1_NOME"    } )
nPosPdR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "C9_PRODUTO" } )
nPosPdR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "C9_PRODUTO" } )
nPosLcR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "C9_LOCAL"   } )
nPosDsR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "B1_DESC"    } )
nPosQtR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "C9_QTDLIB"  } )                                                               
nPosUMR    := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "B1_UM"      } )
nPosQt2R   := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "C9_QTDLIB2" } )
nPosUM2R   := aScan( aHeaderR,{ |x| Trim( x[ 2 ] ) == "B1_SEGUM"   } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAreaSC9 := ( cAliasSC9 )->( GetArea( ) )
( cAliasSC9 )->( dBGoTop( ) )

While !( cAliasSC9 )->( Eof( ) )
	If ( cAliasSC9 )->C9_CARGA == ( cAliasDAK )->DAK_COD
		nPos := aScan( aColsR, { |X| X[ nPosPdR ] == ( cAliasSC9 )->C9_PRODUTO .And. X[ nPosLcR ] == ( cAliasSC9 )->C9_LOCAL .And. X[ nPosClR ] == ( cAliasSC9 )->C9_CLIENTE .And. X[ nPosLjR ] == ( cAliasSC9 )->C9_LOJA } )
		
		If nPos == 0
			
			aAdd( aColsR, Array( Len( aHeaderR ) + 1 ) )
			
			For nX := 1 To Len( aHeaderR )
				If aHeaderR[ nX ][ 10 ] != "V"
					If !Empty( nPos := ( cAliasSC9 )->( FieldPos( aHeaderR[ nX ][ 2 ] ) ) )
						aColsR[ Len( aColsR ) ][ nX ] := ( cAliasSC9 )->( FieldGet( nPos ) )
					EndIf
					
				Else
					aColsR[ Len( aColsR ) ][ nX ] := CriaVar( aHeaderR[ nX ][ 2 ] )
				EndIf
			Next
			
			aColsR[ Len( aColsR ) ][ Len( aHeaderR ) + 1 ] := .F.
		Else
			
			aColsR[ nPos ][ nPosQtR  ] += ( cAliasSC9 )->C9_QTDLIB
			aColsR[ nPos ][ nPosQt2R ] += ( cAliasSC9 )->C9_QTDLIB2
			
		Endif
		
	Endif
	
	( cAliasSC9 )->( dBSkip( ) )
	
EndDo

RestArea( aAreaSC9 )

If Len( aColsR ) == 0
	Aadd( aColsR, Array( Len( aHeaderR ) + 1 ) )
	
	For nY := 1 To Len( aHeaderR )
		aColsR[ 1 ][ nY ] := CriaVar( aHeaderR[ nY ][ 2 ] )
	Next nY
	
	aColsR[ 1 ][ Len( aHeaderR ) + 1 ] := .F.
Endif

aSize[ 1 ] /= 1.4
aSize[ 2 ] /= 1.4
aSize[ 3 ] /= 1.4
aSize[ 4 ] /= 1.4
aSize[ 5 ] /= 1.4
aSize[ 6 ] /= 1.4
aSize[ 7 ] /= 1.4

AAdd( aObjects, { 315, 100, .T., .T. } )

aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
aPosObj  := MsObjSize( aInfo, aObjects,.T.)

DEFINE DIALOG oDlgRes TITLE "Resumo dos Produtos da Carga: " + ( cAliasDAK )->DAK_COD + " - Seq. Carga: " + ( cAliasDAK )->DAK_SEQCAR FROM aSize[ 7 ],000 TO aSize[ 6 ],aSize[ 5 ] PIXEL

oGrpRes   := TGroup():New(                                aPosObj[ 1 ][ 1 ]    , aPosObj[ 1 ][ 2 ] + 2, aPosObj[ 1 ][ 3 ]    , aPosObj[ 1 ][ 4 ]      ,"",oDlgRes,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMSRes    := MsNewGetDados():New(                         aPosObj[ 1 ][ 1 ] + 8, aPosObj[ 1 ][ 2 ] + 4, aPosObj[ 1 ][ 3 ] - 2, aPosObj[ 1 ][ 4 ] - 2  ,0,'AllwaysTrue()','AllwaysTrue()',"",,0,9999,'AllwaysTrue()',.F.,.F.,oGrpRes, aHeaderR, aColsR )

ACTIVATE DIALOG oDlgRes CENTERED ON INIT ( EnchoiceBar(oDlgRes,{|| nOption := 1, oDlgRes:End() },{|| nOption := 0, oDlgRes:End() } ), ( CursorArrow(), SysRefresh() ) )

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS06K ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cálculo das Quantidades/Pesos dos itens do Pedido de venda  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LSOMS06K( nOption )
*********************************
Local aColsAux   := oMSSC6:aCols
Local aHeaderAux := oMSSC6:aHeader
Local nPosClA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_CLI"     } )
Local nPosLjA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_LOJA"    } )
Local nPosNmA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "A1_NOME"    } )
Local nPosPdA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_PRODUTO" } )
Local nPosLcA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_LOCAL"   } )
Local nPosDsA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "B1_DESC"    } )
Local nPosQtA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_QTDLIB"  } )
Local nPosUMA    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_UM"      } )
Local nPosQt2A   := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_QTDLIB2" } )
Local nPosUM2A   := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C6_SEGUM"   } )
Local nPosItem   := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C9_ITEM"    } )
Local nPosSeq    := aScan( aHeaderAux,{ |x| Trim( x[ 2 ] ) == "C9_SEQUEN"  } )
Local lExecute   := .T.
Local nMinTol    := ( GetMV( "MV_LSMINT"  ) / 100 )
Local nMaxTol    := ( GetMV( "MV_LSMAXT"  ) / 100 )
Local nQuant1    := 0
Local nQuant2    := 0
Local nX, nY
Default nOption  := 0


If nOption == 1 .And. ReadVar() == "M->C6_QTDLIB"
	dBSelectArea( "SC9" )
	SC9->( dBSetOrder( 1 ) )
	SC9->( dBGoTop( ) )
	If SC9->( dBSeek( xFilial( "SC9" ) + cPedido + aColsAux[ n ][ nPosItem ] + aColsAux[ n ][ nPosSeq ] + aColsAux[ n ][ nPosPdA ] ) )
		If Empty(SC9->C9_X_TOL)
			nTolMin := ( SC9->C9_QTDLIB - ( SC9->C9_QTDLIB * nMinTol ) )
	   		nTolMax := ( SC9->C9_QTDLIB + ( SC9->C9_QTDLIB * nMaxTol ) )

			IsInTolMin := iif( M->C6_QTDLIB >= nTolMin, .T., .F. )
			IsInTolMax := iif( M->C6_QTDLIB <= nTolMax, .T., .F. )
		
	   		ObjectMethod( oMSSC6:oBrowse, "Refresh()" )
		
			If !IsInTolMin .OR. !IsInTolMax
				ShowHelpDlg( "Atenção",  { Chr( 10 ) + Chr( 13 ) + Alltrim( aColsAux[ n ][ nPosPdA ] ) + " " + Alltrim( aColsAux[ n ][ nPosDsA ] ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Mínima:         " + Transform( nTolMin, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Máxima:       " + Transform( nTolMax, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Informada: " + Transform( M->C6_QTDLIB, "@E 9,999,999.99" ) }, 5, { "Informe quantidades compatíveis com as da Tolerância Mínima e Máxima do Produto ou entre em contato com o responsável para comunicar a situação.!!" }, 5)
				Return( .F. )
	   		Endif
	   Else
			nTolMin := ( SC9->C9_QTDLIB - ( SC9->C9_QTDLIB * (SC9->C9_X_TOL / 100) ) )
	   		nTolMax := ( SC9->C9_QTDLIB + ( SC9->C9_QTDLIB * nMaxTol ) )

			IsInTolMin := iif( M->C6_QTDLIB >= nTolMin, .T., .F. )
			IsInTolMax := iif( M->C6_QTDLIB <= nTolMax, .T., .F. )
		
	   		ObjectMethod( oMSSC6:oBrowse, "Refresh()" )
		
			If !IsInTolMin .OR. !IsInTolMax
				ShowHelpDlg( "Atenção",  { Chr( 10 ) + Chr( 13 ) + Alltrim( aColsAux[ n ][ nPosPdA ] ) + " " + Alltrim( aColsAux[ n ][ nPosDsA ] ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Mínima:         " + Transform( nTolMin, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Máxima:       " + Transform( nTolMax, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Informada: " + Transform( M->C6_QTDLIB, "@E 9,999,999.99" ) }, 5, { "Informe quantidades compatíveis com as da Tolerância Mínima e Máxima do Produto ou entre em contato com o responsável para comunicar a situação.!!" }, 5)
				Return( .F. )
	   		Endif	   
	   EndIf
	Endif
Endif

aMedidas := {}

For nX := 1 To Len( aColsAux )
	dBSelectArea( "SB1" )
	SB1->( dBSetOrder( 1 ) )
	SB1->( dBGoTop( ) )
	SB1->( dBSeek( xFilial( "SB1" ) + aColsAux[ nX ][ nPosPdA ] ) )
	
	If nX <> n
		nPos := aScan( aMedidas, { |X| Alltrim( X[ 1 ] ) == Alltrim( aColsAux[ nX ][ nPosUMA ] ) } )
		
		If nPos == 0
			aAdd( aMedidas, { aColsAux[ nX ][ nPosUMA ], aColsAux[ nX ][ nPosQtA ], aColsAux[ nX ][ nPosQtA ] * SB1->B1_PESO } )
		Else
			aMedidas[ nPos ][ 2 ] += aColsAux[ nX ][ nPosQtA ]
			aMedidas[ nPos ][ 3 ] += aColsAux[ nX ][ nPosQtA ] * SB1->B1_PESO
		Endif
		
		nPos := aScan( aMedidas, { |X| Alltrim( X[ 1 ] ) == Alltrim( aColsAux[ nX ][ nPosUM2A ] ) } )
		
		If nPos == 0
			aAdd( aMedidas, { aColsAux[ nX ][ nPosUM2A ], aColsAux[ nX ][ nPosQt2A ],  aColsAux[ nX ][ nPosQt2A ] * SB1->B1_PESO } )
		Else
			aMedidas[ nPos ][ 2 ] += aColsAux[ nX ][ nPosQt2A ]
			aMedidas[ nPos ][ 3 ] += aColsAux[ nX ][ nPosQt2A ] * SB1->B1_PESO
		Endif
	Endif

Next

dBSelectArea( "SB1" )
SB1->( dBSetOrder( 1 ) )
SB1->( dBGoTop( ) )
SB1->( dBSeek( xFilial( "SB1" ) + aColsAux[ n ][ nPosPdA ] ) )

If Alltrim( ReadVar() ) == "M->C6_QTDLIB"
	nQuant1 := M->C6_QTDLIB
	nQuant2 := aColsAux[ n ][ nPosQt2A ]
	
ElseIf Alltrim( ReadVar() ) == "M->C6_QTDLIB2"
	nQuant1 := aColsAux[ n ][ nPosQtA ]
	nQuant2 := M->C6_QTDLIB2
	
Else
	lExecute := .F.
	
Endif

If lExecute
	nPos := aScan( aMedidas, { |X| Alltrim( X[ 1 ] ) == Alltrim( aColsAux[ n ][ nPosUMA ] ) } )
	
	If nPos == 0
		aAdd( aMedidas, { aColsAux[ n ][ nPosUMA ], nQuant1, nQuant1 * SB1->B1_PESO } )
	Else
		aMedidas[ nPos ][ 2 ] += nQuant1
		aMedidas[ nPos ][ 3 ] += nQuant1 * SB1->B1_PESO
	Endif
	
	nPos := aScan( aMedidas, { |X| Alltrim( X[ 1 ] ) == Alltrim( aColsAux[ n ][ nPosUM2A ] ) } )
	
	If nPos == 0
		aAdd( aMedidas, { aColsAux[ n ][ nPosUM2A ], nQuant2,  nQuant2 * SB1->B1_PESO } )
	Else
		aMedidas[ nPos ][ 2 ] += nQuant2
		aMedidas[ nPos ][ 3 ] += nQuant2 * SB1->B1_PESO
	Endif
	
	For nX := 1 to Len( aMedidas )
		do case
			case nX == 1
				cUnMed1 := aMedidas[ 1 ][ 1 ]
				nQtd1   := aMedidas[ 1 ][ 2 ]
				nPeso1  := aMedidas[ 1 ][ 3 ]
				
				oGum1:SetText( aMedidas[ 1 ][ 1 ] )
				oQtd1:SetText( aMedidas[ 1 ][ 2 ] )
				oPes1:SetText( aMedidas[ 1 ][ 3 ] )
				
				oGum1:Refresh()
				oQtd1:Refresh()
				oPes1:Refresh()
				
			case nX == 2
				cUnMed2 := aMedidas[ 2 ][ 1 ]
				nQtd2   := aMedidas[ 2 ][ 2 ]
				nPeso2  := aMedidas[ 2 ][ 3 ]
				
				oGum2:SetText( aMedidas[ 2 ][ 1 ] )
				oQtd2:SetText( aMedidas[ 2 ][ 2 ] )
				oPes2:SetText( aMedidas[ 2 ][ 3 ] )
				
				oGum2:Refresh()
				oQtd2:Refresh()
				oPes2:Refresh()
				
		endcase
	Next
Endif

ObjectMethod( oMSSC6:oBrowse, "Refresh()" )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063Y ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização dos itens separados com as novas quantidades.   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063Y( cPedido, oMSSC6, aFldsAlt, cHoraEmb, dDataEmb, cObsEmb )
***********************************************************************************
Local aHeaderA   := oMSSC6:aHeader
Local aColsA     := oMSSC6:aCols
Local nPosItem   := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_ITEM"    } )
Local nPosClA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_CLI"     } )
Local nPosLjA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_LOJA"    } )
Local nPosNmA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "A1_NOME"    } )
Local nPosPdA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_PRODUTO" } )
Local nPosLcA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_LOCAL"   } )
Local nPosSeq    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_SEQUEN"  } )
Local nPosDsA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_DESC"    } )
Local nPosQtA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_QTDLIB"  } )
Local nPosUMA    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_UM"      } )
Local nPosQt2A   := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_QTDLIB2" } )
Local nPosUM2A   := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C6_SEGUM"   } )
Local lRet       := .T.
Local aItens     := {}
Local aCabPed    := {}
Local cDescCli   := Space( TamSX3( 'C9_CLIENTE' )[ 1 ] + TamSX3( 'C9_LOJA' )[ 1 ]  + TamSX3( 'A1_NOME' )[ 1 ] + 5 )
Local nX

dBSelectArea( "DAK" )
DAK->( dBSetOrder( 1 ) )
If DAK->DAK_COD + DAK->DAK_SEQCAR <> ( cAliasDAK )->DAK_COD + ( cAliasDAK )->DAK_SEQCAR
   DAK->( dBGoTop( ) )
   DAK->( dBSeek( xFilial( "DAK" ) + ( cAliasDAK )->DAK_COD + ( cAliasDAK )->DAK_SEQCAR ) )
Endif

RecLock( "DAK" , .F. )
DAK->DAK_X_OBS  := DAK->DAK_BLQCAR
DAK->DAK_X_DTPE := dDataEmb
DAK->DAK_X_HREM := cHoraEmb

DAK->( MsUnlock() )

dBSelectArea( "SC5" )
SC5->( dBSetOrder( 1 ) )
SC5->( dBGoTop( ) )
SC5->( dBSeek( xFilial( "SC5" ) + cPedido ) )

For nX := 1 To Len( aColsA )
   
    ( cAliasSC9 )->( dBGoTop( ) )

    If ( cAliasSC9 )->( dBSeek( cPedido + aColsA[ nX ][ nPosItem ] + aColsA[ nX ][ nPosSeq ] + aColsA[ nX ][ nPosClA ] + aColsA[ nX ][ nPosLjA ] + aColsA[ nX ][ nPosPdA ] + aColsA[ nX ][ nPosLcA ] ) )
       RecLock( "SC9", .F. )
       dBSelectArea( "SC9" )
       SC9->( dBSetOrder( 1 ) )
       SC9->( dBGoTop( ) )
       If SC9->( dBSeek( xFilial( "SC9" ) + ( cAliasSC9 )->C9_PEDIDO + ( cAliasSC9 )->C9_ITEM + ( cAliasSC9 )->C9_SEQUEN + ( cAliasSC9 )->C9_PRODUTO ) )
          RecLock( "SC9", .F. )
          SC9->C9_X_QTLS  := aColsA[ nX ][ nPosQtA  ]
          SC9->C9_X_QTL2S := aColsA[ nX ][ nPosQt2A ]
          SC9->( MsUnLock( ) )
       Endif
    Endif
Next

Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Lincoln P. Rossetto ³    12;08;2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1( pcPerg )
***********************************
Local aArea    := GetArea( )
Local nHlp     := 0
Local aRegs    := {}
Local aHlp     := {}
Local aHelp    := { }
Local cHlp     := ""
Local nX, nW
Default pcPerg := ""

If Empty( pcPerg )
   RestArea( aArea )
   Alert( "Faltou informar o nome do Grupo de Perguntas !!!" )
   Return( .F. )
Endif

aHelp    := { { "." + pcPerg + "01.", "Informe a Carga de"       } , ;
              { "." + pcPerg + "02.", "Informe a Carga até"      } , ;
              { "." + pcPerg + "03.", "Informe o Tipo de Carga"  } }

cPerg := pcPerg

If Len( pcPerg ) < 10
   cPerg := pcPerg + Space( 10 - Len( cPerg ) )
Endif

CursorWait()
SysRefresh()

For nX := 1 To Len( aHelp )
	aHlp := {}
	cHlp := "P" + aHelp[ nX ][ 1 ]
	aAdd( aHlp, aHelp[ nX ][ 2 ] )
	PutSX1Help( cHlp , aHlp, aHlp, aHlp )
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                                                                                                                                                                                          
aAdd( aRegs,{ cPerg, "01", "Carga de ?                  ", "Carga de ?                   ", "Carga de ?                  ", "mv_ch1","C",TamSX3( "DAK_COD" )[ 1 ],0,0,"G",""           ,"MV_PAR01",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", "DAK" ,"" ,"", aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "02", "Carga até ?                 ", "Carga até ?                  ", "Carga até ?                 ", "mv_ch2","C",TamSX3( "DAK_COD" )[ 1 ],0,0,"G",""           ,"MV_PAR02",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", "DAK" ,"" ,"", aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "03", "Somente Cargas Aptas ?      ", "Somente Cargas Aptas ?       ", "Somente Cargas Aptas ?      ", "mv_ch3","N",01						 ,0,0,"C",""           ,"MV_PAR03","Sim"      ,"Sim"      ,"Sim"      ,"","","Nao"   ,"Nao"   ,"Nao"   ,"","","","","","","","","","","","","","","","", ""    ,"" ,"", aHelp[ ++nHlp ][ 1 ] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                          
//³ Verificação dos parâmetros no SX1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )
SX1->( dbGoTop( ) )

For nX := 1 To Len( aRegs )
	If !SX1->( dBSeek( cPerg + aRegs[ nX ][ 2 ] ) )
		RecLock( "SX1", .T. )
		For nW := 1 to SX1->( FCount() )
			If nW <= Len( aRegs[ nX ] )
				SX1->( FieldPut( nW, aRegs[ nX ][ nW ] ) )
			Endif
		Next
		SX1->( MsUnlock() )
	Endif
Next


CursorArrow()
SysRefresh()


RestArea( aArea )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063X ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Finaliza Separação da Carga, liberando o seu faturamento.   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063X()
***************************
Local aRet        := LSOMS063C( .F. )
Local aHeaderA    := aRet[ 1 ]
Local aColsA      := aRet[ 2 ]
Local nPosPedo    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_PEDIDO"  } )
Local nPosItem    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_ITEM"    } )
Local nPosClA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_CLIENTE" } )
Local nPosLjA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_LOJA"    } )
Local nPosNmA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "A1_NOME"    } )
Local nPosPdA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_PRODUTO" } )
Local nPosLcA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_LOCAL"   } )
Local nPosSeq     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_SEQUEN"  } )
Local nPosDsA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_DESC"    } )
Local nPosQtA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_QTDLIB"  } )
Local nPosUMA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_UM"      } )
Local nPosQt2A    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_QTDLIB2" } )
Local nPosUM2A    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_SEGUM"   } )
Local nMinTol     := ( GetMV( "MV_LSMINT"  ) / 100 )
Local nMaxTol     := ( GetMV( "MV_LSMAXT"  ) / 100 )
Local aPedNSep    := {}
Local cNConfor    := ""
Local cPedNSep    := ""
Local nTolMin     := 0
Local nTolMax     := 0
Local IsInTolMin  := .T.
Local IsInTolMax  := .T.
Local nX
CurSorWait()
SysRefresh()

If ( cAliasDAK )->DAK_BLQCAR <> "1"
	CurSorArrow()
	SysRefresh()
	Aviso("Atenção", "Carga com a separação já finalizada!", { "OK" } )
	Return( .F. )
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Verificação dos Pedidos que não foram separados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	For nX := 1 To Len( aColsA )
		( cAliasSC9 )->( dBGoTop( ) )
		If ( cAliasSC9 )->( dBSeek( aColsA[ nX ][ nPosPedo ] + aColsA[ nX ][ nPosItem ] + aColsA[ nX ][ nPosSeq ] + aColsA[ nX ][ nPosClA ] + aColsA[ nX ][ nPosLjA ] + aColsA[ nX ][ nPosPdA ] + aColsA[ nX ][ nPosLcA ] ) )
			
			dBSelectArea( "SC9" )
			SC9->( dBSetOrder( 1 ) )
			SC9->( dBGoTop( ) )
			
			If SC9->( dBSeek( xFilial( "SC9" ) + ( cAliasSC9 )->C9_PEDIDO + ( cAliasSC9 )->C9_ITEM + ( cAliasSC9 )->C9_SEQUEN + ( cAliasSC9 )->C9_PRODUTO ) )
				If SC9->C9_X_QTLS == 0
					aAdd( aPedNSep, { SC9->( Recno( ) ), SC9->C9_PEDIDO, SC9->C9_ITEM, SC9->C9_QTDLIB, SC9->C9_QTDLIB } )
					cPedNSep += Chr( 10 ) + Chr( 13 ) + SC9->C9_PEDIDO + " " + SC9->C9_ITEM + " " + Alltrim( SC9->C9_PRODUTO ) + " " + Alltrim( ( cAliasSC9 )->B1_DESC )
				Endif
			Endif
			
		Endif
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Autalização da separação dos pedidos que ainda não foram separados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If Len( aPedNSep ) > 0
		CurSorArrow()
		SysRefresh()
		
		If Aviso( "Separação Produtos", "Existem Pedidos que não foram separados, deseja finalizar mesmo assim a separação ?" + Chr( 10 ) + Chr( 13 ) + cPedNSep, { "Sim", "Não" }, 3  ) == 1
			aPedNSep := { }
		Else
			Aviso( "Atenção", "A Separação 'não' foi finalizada !!", { "OK" }, 2 )
			Return( .F. )
		Endif
	Endif
	
	If Len( aPedNSep ) == 0
		CurSorWait()
		SysRefresh()
	
	    dBSelectArea( "SC9" )
		SC9->( dBSetOrder( 1 ) )
		
		For nX := 1 To Len( aColsA )
			( cAliasSC9 )->( dBGoTop( ) )
			If ( cAliasSC9 )->( dBSeek( aColsA[ nX ][ nPosPedo ] + aColsA[ nX ][ nPosItem ] + aColsA[ nX ][ nPosSeq ] + aColsA[ nX ][ nPosClA ] + aColsA[ nX ][ nPosLjA ] + aColsA[ nX ][ nPosPdA ] + aColsA[ nX ][ nPosLcA ] ) )
				
				SC9->( dBGoTop( ) )
				
				If SC9->( dBSeek( xFilial( "SC9" ) + ( cAliasSC9 )->C9_PEDIDO + ( cAliasSC9 )->C9_ITEM + ( cAliasSC9 )->C9_SEQUEN + ( cAliasSC9 )->C9_PRODUTO ) )
					If Empty(SC9->C9_X_TOL)
						nTolMin := ( SC9->C9_QTDLIB - ( SC9->C9_QTDLIB * nMinTol ) )
						nTolMax := ( SC9->C9_QTDLIB + ( SC9->C9_QTDLIB * nMaxTol ) )
					
						IsInTolMin := iif( iif( ( cAliasSC9 )->C9_X_QTLS == 0, SC9->C9_QTDLIB, ( cAliasSC9 )->C9_X_QTLS ) >= nTolMin, .T., .F. )
						IsInTolMax := iif( iif( ( cAliasSC9 )->C9_X_QTLS == 0, SC9->C9_QTDLIB, ( cAliasSC9 )->C9_X_QTLS ) <= nTolMax, .T., .F. )
					
						If !IsInTolMin .OR. !IsInTolMax
							cNConfor += Chr( 10 ) + Chr( 13 ) + Alltrim( aColsA[ nX ][ nPosPdA ] ) + " " + Alltrim( ( cAliasSC9 )->B1_DESC ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Mínima:         " + Transform( nTolMin, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Máxima:       " + Transform( nTolMax, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Separação: " + Transform( iif( ( cAliasSC9 )->C9_X_QTLS == 0, SC9->C9_QTDLIB, ( cAliasSC9 )->C9_X_QTLS ), "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 )
						Endif
					Else
						nTolMin := ( SC9->C9_QTDLIB - ( SC9->C9_QTDLIB * SC9->C9_X_TOL / 100) )
						nTolMax := ( SC9->C9_QTDLIB + ( SC9->C9_QTDLIB * nMaxTol ) )
					
						IsInTolMin := iif( iif( ( cAliasSC9 )->C9_X_QTLS == 0, SC9->C9_QTDLIB, ( cAliasSC9 )->C9_X_QTLS ) >= nTolMin, .T., .F. )
						IsInTolMax := iif( iif( ( cAliasSC9 )->C9_X_QTLS == 0, SC9->C9_QTDLIB, ( cAliasSC9 )->C9_X_QTLS ) <= nTolMax, .T., .F. )
					
						If !IsInTolMin .OR. !IsInTolMax
							cNConfor += Chr( 10 ) + Chr( 13 ) + Alltrim( aColsA[ nX ][ nPosPdA ] ) + " " + Alltrim( ( cAliasSC9 )->B1_DESC ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Mínima:         " + Transform( nTolMin, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Máxima:       " + Transform( nTolMax, "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 ) + "  -> Qtde Separação: " + Transform( iif( ( cAliasSC9 )->C9_X_QTLS == 0, SC9->C9_QTDLIB, ( cAliasSC9 )->C9_X_QTLS ), "@E 9,999,999.99" ) + Chr( 10 ) + Chr( 13 )
						Endif
					EndIf
				Endif
			Endif
		Next
		
		If !Empty( cNConfor )
			CurSorArrow()
			SysRefresh()
			Aviso( "Atenção", "Impossivel finalizar a Carga, existem quantidades Zeradas ou a quantidade informada esta abaixo da minima tolerada ou a quantidade informada esta acima da quantidade máxima tolerada!!" + Chr( 10 ) + Chr( 13 ) + cNConfor, { "OK" }, 3 )
		Else
		    CurSorArrow()
			SysRefresh()
			If Aviso("Atenção", "Deseja realmente finalizar esta separação ?", { "Sim","Não" } ) == 1
				MsgRun ( "Aguarde...", "Finalizando Separação e enviando Workflow...", { || LSOMS063XG() } )
			Endif
		Endif
		
	Endif
Endif

CurSorArrow()
SysRefresh()

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS063XG ºAutor ³ Lincoln Rossetto   ºData ³ 16/11/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Finaliza Separação da Carga, liberando o seu faturamento.   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMS063XG()
****************************
Local cAliasSC9B  := GetNextAlias( )
Local aRet        := LSOMS063C( .F. )
Local aHeaderA    := aRet[ 1 ]
Local aColsA      := aRet[ 2 ]
Local nPosPedo    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_PEDIDO"  } )
Local nPosItem    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_ITEM"    } )
Local nPosClA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_CLIENTE" } )
Local nPosLjA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_LOJA"    } )
Local nPosNmA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "A1_NOME"    } )
Local nPosPdA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_PRODUTO" } )
Local nPosLcA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_LOCAL"   } )
Local nPosSeq     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_SEQUEN"  } )
Local nPosDsA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_DESC"    } )
Local nPosQtA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_QTDLIB"  } )
Local nPosUMA     := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_UM"      } )
Local nPosQt2A    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "C9_QTDLIB2" } )
Local nPosUM2A    := aScan( aHeaderA,{ |x| Trim( x[ 2 ] ) == "B1_SEGUM"   } )
Local lRet        := .T.
Local cDescCli    := Space( TamSX3( 'C9_CLIENTE' )[ 1 ] + TamSX3( 'C9_LOJA' )[ 1 ]  + TamSX3( 'A1_NOME' )[ 1 ] + 5 )
Local cHtmlFat    := Alltrim( GetMV( "MV_LSWFFAT" ) )
Local cDirWFSep   := Alltrim( GetMV( "MV_LSDIRSP" ) )
Local cMailTo     := Alltrim( GetMV( "MV_LSENDFA" ) )
Local cDir        := Alltrim( GetMV( "MV_WFDIR"   ) )
Local cTipoPeso   := GetMV( "MV_PESOCAR" )
Local hEnter      := Chr( 13 )
Local lValido     := .T.
Local cProcesso   := "" 
Local cAssunto    := ""
Local cStatus     := ""
Local aProdutos   := {}
Local aDadosUsr   := {}
Local aRegDA7     := {}
Local aTipo       := {}
Local aRota       := {}
Local aZona       := {}
Local aSetor      := {}
Local aUserInfo   := {}
Local aPedidos    := {}
Local aPedSC9OK   := {}
Local aNConfor    := {}
Local aDAI        := {}
Local cCodRota    := Space( TamSX3( "DA8_COD"    )[ 1 ] )
Local cZona       := Space( TamSX3( "DA7_PERCUR" )[ 1 ] )
Local cSetor      := Space( TamSX3( "DA7_ROTA"   )[ 1 ] )
Local cSeqRota    := Space( TamSX3( "DA9_SEQUEN" )[ 1 ] )
Local cSequencia  := Space( TamSX3( "DA7_SEQUEN" )[ 1 ] )
Local cPtoRefDA6  := Space( TamSX3( "DA6_REF"    )[ 1 ] )
Local cPtoRefDA5  := Space( TamSX3( "DA5_DESC"   )[ 1 ] )
Local cDescRota   := "PEDIDOS SEM ROTA"
Local cNConfor    := ""
Local oProcess, oHtml
Local nRegDA7, nX

If Right( cDir, 1 ) <> "\"
	cDir += "\"
Endif

If Left( cDirWFSep, 1 ) == "\"
	cDirWFSep := SubStr( cDirWFSep, 2, Len( cDirWFSep ) )
Endif

If Right( cDirWFSep, 1 ) <> "\"
	cDirWFSep += "\"
Endif

cHtmlFat := ( cDir + cDirWFSep + cHtmlFat )
If !File( cHtmlFat )
	MsgInfo( FUNNAME() + " >>> Não foi encontrado o arquivo " + cHtmlFat )
	Return( .F. )
Endif

For nX := 1 To Len( aColsA )
	( cAliasSC9 )->( dBGoTop( ) )
	If ( cAliasSC9 )->( dBSeek( aColsA[ nX ][ nPosPedo ] + aColsA[ nX ][ nPosItem ] + aColsA[ nX ][ nPosSeq ] + aColsA[ nX ][ nPosClA ] + aColsA[ nX ][ nPosLjA ] + aColsA[ nX ][ nPosPdA ] + aColsA[ nX ][ nPosLcA ] ) )

		nPos := aScan( aPedidos, { |X| X[ 1 ] == aColsA[ nX ][ nPosPedo ] } )
		If nPos == 0
			aAdd( aPedidos, { aColsA[ nX ][ nPosPedo ], aColsA[ nX ][ nPosClA ], aColsA[ nX ][ nPosLjA ], aColsA[ nX ][ nPosNmA ], ( cAliasSC9 )->C9_PRCVEN * ( cAliasSC9 )->C9_QTDLIB } )
		Else
			aPedidos[ nPos ][ 5 ] += ( cAliasSC9 )->C9_PRCVEN * ( cAliasSC9 )->C9_QTDLIB
		Endif
		
		dBSelectArea( "SC9" )
		SC9->( dBSetOrder( 1 ) )
		SC9->( dBGoTop( ) )

		If SC9->( dBSeek( xFilial( "SC9" ) + ( cAliasSC9 )->C9_PEDIDO + ( cAliasSC9 )->C9_ITEM + ( cAliasSC9 )->C9_SEQUEN + ( cAliasSC9 )->C9_PRODUTO ) )
					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Libera item do Pedido para Separação ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If Alltrim( SC9->C9_BLEST ) == 'SP'
				RecLock( "SC9", .F. )
				SC9->C9_BLEST  := Space( TamSX3( 'C9_BLEST' )[ 1 ] )
				SC9->( MsUnLock( ) )
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Atualizando quantidades informadas                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RecLock( "SC9", .F. )
			If ( cAliasSC9 )->C9_X_QTLS == 0
		    	( cAliasSC9 )->C9_X_QTLS  := SC9->C9_QTDLIB
            	( cAliasSC9 )->C9_X_QTL2S := SC9->C9_QTDLIB2
		    Else
		    	SC9->C9_QTDLIB  := ( cAliasSC9 )->C9_X_QTLS
            	SC9->C9_QTDLIB2 := ( cAliasSC9 )->C9_X_QTL2S
            Endif
            SC9->( MsUnLock( ) )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Verificar diferenças a mais entre o Separado e o Pedido de Venda ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dBSelectArea( "SC6" )
			SC6->( dBSetOrder( 2 ) )
			SC6->( dBGoTop( ) )
			If SC6->( dBSeek( xFilial( "SC6" ) + ( cAliasSC9 )->C9_PRODUTO + ( cAliasSC9 )->C9_PEDIDO + ( cAliasSC9 )->C9_ITEM ) )
			 //aAdd( aPedSC9OK, { xFilial( "SC6" ), ( cAliasSC9 )->C9_PRODUTO, ( cAliasSC9 )->C9_PEDIDO, ( cAliasSC9 )->C9_ITEM, ( cAliasSC9 )->C9_QTDLIB, ( cAliasSC9 )->C9_QTDLIB2 } )
			   aAdd( aPedSC9OK, { xFilial( "SC6" ), ( cAliasSC9 )->C9_PRODUTO, ( cAliasSC9 )->C9_PEDIDO, ( cAliasSC9 )->C9_ITEM, ( cAliasSC9 )->C9_X_QTLS, ( cAliasSC9 )->C9_X_QTL2S } )
			Endif
			
			aZonas   := {}
			aSetores := {}
			aRotas   := {}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Roteirização                                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( "SB1" )
			SB1->( dBSetOrder( 1 ) )
			SB1->( dBgoTop( ) )
			SB1->( MsSeek( xFilial( "SB1" ) + SC9->C9_PRODUTO ) )
			
			dBSelectArea( "SB2" )
			SB2->( dBSetOrder( 1 ) )
			SB2->( dBgoTop( ) )
			SB2->( MsSeek( xFilial( "SB2" ) + SB1->B1_COD + SC9->C9_LOCAL ) )
			
			dBSelectArea( "SA1" )
			SA1->( dBSetOrder( 1 ) )
			SA1->( dBgoTop( ) )
			SA1->( dBSeek( xFilial( "SA1" ) + SC9->C9_CLIENTE + SC9->C9_LOJA ) )
			
			aRegDA7 := OmsHasDA7( SC9->C9_FILIAL, SC9->C9_CLIENTE, SC9->C9_LOJA )
			
			If Len( aRegDA7 ) > 0
				
				For nRegDA7 := 1 To Len(aRegDA7)
					
					DA7->( MsGoto( aRegDA7[ nRegDA7 ] ) )
					
					cZona      := DA7->DA7_PERCUR
					cSetor     := DA7->DA7_ROTA
					cSequencia := DA7->DA7_SEQUEN
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pesquisa o cliente/fornecedor na zona/setor                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DA9->( dBSetOrder( 2 ) )
					DA9->( dBGoTop( ) )
					If DA9->( MsSeek( xFilial( "DA9" ) + cZona + cSetor ) )
						lValido := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se busca a primeira rota ativa                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SuperGetMv( "MV_ROTATV", .F. ,"2" ) == "2"
							While !DA9->( Eof( ) ) .And. DA9->DA9_FILIAL == xFilial("DA9") .And. DA9->DA9_PERCUR == cZona .And. DA9->DA9_ROTA == cSetor
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Pesquisa a Rota                                                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								DA8->( dBSetOrder( 1 ) )
								DA8->( dBGoTop( ) )
								If DA8->( MsSeek( xFilial( "DA8" ) + DA9->DA9_ROTEIR ) )
									If DA8->DA8_ATIVO == "1"
										cCodRota  := DA8->DA8_COD
										cDescRota := DA8->DA8_DESC
										cSeqRota  := DA9->DA9_SEQUEN
										
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Verifica os tipo de carga da rota se esta incluido                  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If DA8->( FieldPos( "DA8_TIPCAR" ) ) > 0 .And. !Empty( DA8->DA8_TIPCAR )
											nPosD := Ascan( aTipo,{ |X| Alltrim( X[ 1 ] ) == DA8->DA8_TIPCAR } )
											If nPosD > 0
												lValido := .F.
											EndIf
										EndIf
										If lValido
											Exit
										EndIf
									Endif
								Else
									cDescRota  := "PEDIDOS SEM ROTA"
									cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
									cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
									cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
									cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
									cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
									Exit
								EndIf
								
								DA9->( dBSkip( ) )
							EndDo
							
							If Empty( cCodRota )
								cDescRota  := "PEDIDOS SEM ROTA"
								cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
								cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
								cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
								cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
								cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
							EndIf
						Else
							While !DA9->( Eof( ) ) .And. DA9->DA9_FILIAL == xFilial( "DA9" ) .And. DA9->DA9_PERCUR == cZona .And. DA9->DA9_ROTA == cSetor
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Pesquisa a Rota                                                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								DA8->( dBSetOrder( 1 ) )
								DA8->( dBGoTop( ) )
								If DA8->( MsSeek( xFilial( "DA8" ) + DA9->DA9_ROTEIR ) )
									If DA8->DA8_ATIVO == "1" .And. IIf( !Empty( DA8->DA8_CODCAL ), OmsDtEntr( DA8->DA8_CODCAL, dDataBase ) == dDataBase, .T. )
										cCodRota := DA8->DA8_COD
										cDescRota:= DA8->DA8_DESC
										cSeqRota := DA9->DA9_SEQUEN
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Verifica os tipo de carga da rota se esta incluido                  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If DA8->( FieldPos( "DA8_TIPCAR" ) ) > 0 .And. !Empty( DA8->DA8_TIPCAR )
											nPosD := Ascan( aTipo,{ |X| Alltrim( X[ 2 ] ) == DA8->DA8_TIPCAR } )
											If nPosD > 0
												lValido := .F.
											EndIf
										EndIf
										If lValido
											Exit
										EndIf
									EndIf
								Else
									cDescRota  := "PEDIDOS SEM ROTA"
									cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
									cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
									cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
									cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
									cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
									Exit
								EndIf
								DA9->( dBSkip( ) )
							EndDo
							
							If Empty( cCodRota )
								cDescRota  := "PEDIDOS SEM ROTA"
								cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
								cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
								cSetor     := Repl( "9", Len( DA7->DA7_ROTA ) )
								cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
								cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
							EndIf
							
						Endif
					Else
						cDescRota  := "PEDIDOS SEM ROTA"
						cCodRota   := Repl( "9", Len( DA8->DA8_COD    ) )
						cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
						cSetor     := Repl( "9", Len( DA7->DA7_ROTA   ) )
						cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
						cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
						lEnable    := .T.
						lValido    := .T.
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pesquisa os Setores por Zona                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DA6->( dBGoTop( ) )
					If DA6->( MsSeek( xFilial( "DA6" ) + cZona + cSetor ) )
						cPtoRefDA6 := DA6->DA6_REF
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Pesquisa as Zonas                                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea( "DA5" )
						DA5->( dBSetOrder( 1 ) )
						If DA5->( MsSeek( xFilial( "DA5" ) + DA6->DA6_PERCUR ) )
							cPtoRefDA5 := DA5->DA5_DESC
						Else
							cPtoRefDA5 := ""
						EndIf
					Else
						cDescRota  := "PEDIDOS SEM ROTA"
						cCodRota   := Repl( "9", Len( DA8->DA8_COD    ) )
						cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
						cSetor     := Repl( "9", Len( DA7->DA7_ROTA   ) )
						cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
						cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
						cPtoRefDA5 := ""
						cPtoRefDA6 := ""
					EndIf
					
					If Ascan( aRota, { |X| x[ 1 ] == cCodRota } ) == 0 .And. lValido
						AAdd( aRota, { cCodRota, cDescRota, Space( 6 ) } )
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifico se existe setor para pegar descricao e acrescento no³
					//³array                                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Ascan( aSetor, { |x| X[ 1 ] == cCodRota .And. X[ 2 ] == cZona .And. X[ 3 ] == cSetor } ) == 0 .And. lValido
						AAdd( aSetor, { cCodRota, cZona, cSetor, cDescRota, cPtoRefDA6, cSeqRota } )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Busco se ja existe a zona no array , caso nao exista,a mesma³
						//³e incluida                                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Ascan( aZona, { |x| x[ 1 ] == cCodRota .And. x[ 2 ] == cZona } ) == 0
					   		AAdd( aZona, { cCodRota, cZona, cPtoRefDA5, cSeqRota } )
						EndIf
					EndIf
				Next nRegDa7
			Else
				cCodRota   := Repl( "9", Len( DA8->DA8_COD ) )
				cDescRota  := "PEDIDOS SEM ROTEIRIZACAO"
				cZona      := Repl( "9", Len( DA7->DA7_PERCUR ) )
				cSetor     := Repl( "9", Len( DA7->DA7_ROTA   ) )
				cSeqRota   := Repl( "9", Len( DA9->DA9_SEQUEN ) )
				cSequencia := Repl( "9", Len( DA7->DA7_SEQUEN ) )
				
				lEnable    := .T.
				lValido    := .T.
				
				If Ascan( aRota, {|x| X[ 1 ] == cCodRota } ) == 0
					AAdd( aRota, { cCodRota, cDescRota,  Space( 6 ) } )
				EndIf
				
				If Ascan( aZona, { |x| X[ 1 ] == cCodRota .And. X[ 2 ] ==  cZona } ) == 0
					AAdd( aZona, { cCodRota, cSetor, cDescRota, cSeqRota } )
				EndIf
				
				If Ascan( aSetor, { |x| x[ 1 ] == cCodRota .And. x[ 2 ] == cZona .And. x[ 3 ] == cSetor } ) == 0
					AAdd( aSetor, { cCodRota, cZona, cSetor, cDescRota, cPtoRefDA6, cSeqRota } )
				EndIf
				
			EndIf
			
		Endif
	Endif
Next

dBSelectArea( "DAK" )
DAK->( dBSetOrder( 1 ) )
DAK->( dBGoTop( ) )
DAK->( dBSeek( xFilial( "DAK" ) + ( cAliasDAK )->DAK_COD + ( cAliasDAK )->DAK_SEQCAR ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Workflow de aviso de finalização de separação para faturamento da carga ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dBSelectArea( "ZAF" )
ZAF->( dBSetOrder ( 2 ) )
ZAF->( dBGoTop( ) )
ZAF->( MSSeek( xFilial( "ZAF" ) + ( cAliasDAK )->DAK_COD + ( cAliasDAK )->DAK_SEQCAR ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Verifrica diferenças a mais entre o Separado e o Pedido de Venda ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
For nX := 1 To Len( aPedSC9OK )
	dBSelectArea( "SC6" )
	SC6->( dBSetOrder( 2 ) )
	SC6->( dBGoTop( ) )
	If SC6->( dBSeek( xFilial( "SC6" ) + aPedSC9OK[ nX ][ 2 ] + aPedSC9OK[ nX ][ 3 ] + aPedSC9OK[ nX ][ 4 ] ) )
		
		If aPedSC9OK[ nX ][ 5 ] != SC6->C6_QTDVEN
	
			dBSelectArea( "SB2" )
			SB2->( dBSetOrder( 1 ) )
			SB2->( dBGoTop() )
			If SB2->( dBSeek( xFilial( "SB2" ) + SC6->C6_PRODUTO + SC6->C6_LOCAL ) )
			   RecLock( "SB2", .F. )
			   SB2->B2_RESERVA += aPedSC9OK[ nX ][ 5 ] - SC6->C6_QTDVEN
			   SB2->( MsUnLock( ) )
			Endif

		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Conciliando SC6 e SC9 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        RecLock( "SC6", .F. )
		SC6->C6_QTDVEN  := aPedSC9OK[ nX ][ 5 ]
		SC6->C6_QTDLIB  := aPedSC9OK[ nX ][ 5 ]
		SC6->C6_QTDLIB2 := aPedSC9OK[ nX ][ 6 ]
		SC6->( MsUnLock( ) )
		
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recálculo do Volume e do Peso da Carga                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery  := "SELECT SC9.*,                   " 						+ hEnter
cQuery  += "       SC9.R_E_C_N_O_ SC9RECNO  " 						+ hEnter
cQuery  += "  FROM " + RetSqlName( "SC9" ) + " SC9"                 + hEnter
cQuery  += " WHERE SC9.C9_FILIAL     = '" + xFilial( "SC9" ) + "'"  + hEnter
cQuery  += "   AND SC9.C9_CARGA      = '" + DAK->DAK_COD            + "'" + hEnter
cQuery  += "   AND SC9.C9_SEQCAR     = '" + DAK->DAK_SEQCAR         + "'" + hEnter
cQuery  += "   AND SC9.D_E_L_E_T_   <> '*'"                               + hEnter

MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se arquivo Temporário existir fecha o mesmo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( cAliasSC9B ) > 0
	( cAliasSC9B )->( dBCloseArea( ) )
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery( cQuery ) ), cAliasSC9B, .T., .T.)

nPesoTotal := 0
nVolmTotal := 0
nValCarga  := 0
			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculando por pedido para Atualizar a DAK e a DAI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
while !( cAliasSC9B )->( Eof( ) )
	dBSelectArea( "SB1" )
	SB1->( dBSetOrder( 1 ) )
	SB1->( dBGoTop( ) )
	SB1->( dBSeek( xFilial( "SB1" ) + ( cAliasSC9B )->C9_PRODUTO ) )
	
	nPeso   := 0
	nCapArm := 0
	nVolume := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cálculo do Peso                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipoPeso == "L"
		nPeso := ( ( cAliasSC9B )->C9_QTDLIB * SB1->B1_PESO )
	Else
		nPeso := ( ( cAliasSC9B )->C9_QTDLIB * SB1->B1_PESBRU )
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo de Volume do produto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCapArm   := OsPrCapArm( SB1->B1_COD, xFilial( "SC9" ) )
	nVolume   := ( nCapArm * ( cAliasSC9B )->C9_QTDLIB )
	
	nPesoTotal += nPeso
	nVolmTotal += nVolume
	nValCarga  += ( ( cAliasSC9B )->C9_QTDLIB * ( cAliasSC9B )->C9_PRCVEN )
	
	nPos := aScan( aDAI, { |X| X[ 1 ] == ( cAliasSC9B )->C9_PEDIDO .And. X[ 2 ] == DAK->DAK_COD .And. X[ 3 ] == DAK->DAK_SEQCAR } )
	
	If nPos == 0
		aAdd( aDAI, { ( cAliasSC9B )->C9_PEDIDO, DAK->DAK_COD, DAK->DAK_SEQCAR, nPeso, nVolume } )
	Else
		aDAI[ nPos ][ 4 ] += nPeso
		aDAI[ nPos ][ 5 ] += nVolume
	Endif
	
	( cAliasSC9B )->( dBSkip( ) )
Enddo
			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se arquivo Temporário existir fecha o mesmo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( cAliasSC9B ) > 0
	( cAliasSC9B )->( dBCloseArea( ) )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando a DAK                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock( "DAK", .F. )
DAK->DAK_PESO   := nPesoTotal
DAK->DAK_CAPVOL := nVolmTotal
DAK->DAK_VALOR  := nValCarga
DAK->( MsUnLock( ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Liberando Carga                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OsAvalDAK( "DAK", 12 )

RecLock( cAliasDAK , .F. )
( cAliasDAK )->DAK_BLQCAR := DAK->DAK_BLQCAR
( cAliasDAK )->( MsUnlock()	)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando a DAI                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len( aDAI )
	dBSelectArea( "DAI" )
	DAI->( dBSetOrder( 4 ) )
	DAI->( dBGoTop( ) )
	If DAI->( dBSeek( xFilial( "DAI" ) + aDAI[ nX ][ 1 ] + aDAI[ nX ][ 2 ] + aDAI[ nX ][ 3 ] ) )
		RecLock( "DAI", .F. )
		DAI->DAI_PESO   := aDAI[ nX ][ 4 ]
		DAI->DAI_CAPVOL := aDAI[ nX ][ 5 ]
		DAI->( MsUnLock( ) )
	Endif
Next

Return( .T. )
