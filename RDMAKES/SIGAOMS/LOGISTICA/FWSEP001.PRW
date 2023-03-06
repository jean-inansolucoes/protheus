#include 'protheus.ch'
#include 'topconn.ch'

//PROCESSO ICMAIS AJUSTADO PARA FUNCIONAR COM LAYOUT JA EXISTENTE DE WORKFLOW
User Function FWSEP001( pcFilial, pcCarga, pcSeqCar, pcObj )

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
Local cRevCarga   := ""
Local cAssunto    := ""
Local cCodRota    := Space( TamSX3( "DA8_COD"    )[ 1 ] )
Local cZona       := Space( TamSX3( "DA7_PERCUR" )[ 1 ] )
Local cSetor      := Space( TamSX3( "DA7_ROTA"   )[ 1 ] )
Local cSeqRota    := Space( TamSX3( "DA9_SEQUEN" )[ 1 ] )
Local cSequencia  := Space( TamSX3( "DA7_SEQUEN" )[ 1 ] )
Local cPtoRefDA6  := Space( TamSX3( "DA6_REF"    )[ 1 ] )
Local cPtoRefDA5  := Space( TamSX3( "DA5_DESC"   )[ 1 ] )
Local cDescRota   := "PEDIDOS SEM ROTA"
Local lValido     := .F.
Local lNewSep     := .F.
Local cHtmlSepar  := Alltrim( GetMV( "MV_LSWFSEP" ) )
Local cDirWFSep   := Alltrim( GetMV( "MV_LSDIRSP" ) )
Local cMailTo     := Alltrim( GetMV( "MV_LSENDMA" ) )
Local cDir        := Alltrim( GetMV( "MV_WFDIR"   ) )
Local nPosD       := 0
Local aPedGet     := {}
Local aPedidos    := {}
Local aProdutos   := {}
Local oProcess
Local nX, nY, nZ, nRegDA7
Local _X__Ped := {}
Local _X__Aglut := {}
local cFileRep    := ""
//Default pcCarga   := ""

If pcObj == 2
    cAliasSC9   := GetNextAlias( )

   /* dBSelectArea( "DAK" )
	DAK ->( dBSetOrder( 1 ) )
	DAK->( dBGoTop(  ) )
	DAK->( MSSeek( xFilial( "DAK" ) + cCarga + pcSeqCar ) )
  

    
    If Empty( DAK->DAK_CAMINH )
       Aviso( "Atenção", "Esta Carga não tem um veiculo associado, impossivel prosseguir !", {"OK"}, 2 )
       Return( .F. )
    Endif
    
	pcFilial  := xFilial( "DAK" )
	pcCarga   := DAK->DAK_COD
	pcSeqCar  := DAK->DAK_SEQCAR*/
	
	Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "LSOMS06" )
	
	cQuery :=  " SELECT SC9.*,"                                 +       hEnter
	cQuery += "         SC9.R_E_C_N_O_ RECSC9 "                 +       hEnter
	cQuery += "    FROM " + RetSqlName( "SC9" ) + " SC9 "       +       hEnter
	cQuery += "   WHERE SC9.C9_FILIAL   = '" + xFilial( "SC9" ) + "'" + hEnter
	cQuery += "     AND SC9.C9_X_SIMUL  = '" + pcCarga          + "'" + hEnter
	//cQuery += "     AND SC9.C9_SEQCAR   = '" + pcSeqCar         + "'" + hEnter
	cQuery += "     AND SC9.D_E_L_E_T_ <> '*'"                  +       hEnter
	cQuery += "ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM"             +       hEnter
	
	//MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)
	
	If Select( cAliasSC9 ) > 0
		( cAliasSC9 )->( dBclosearea( ) )
	Endif
	
	cQuery := ChangeQuery(cQuery)
	
	dBUseArea(.T.,"TOPCONN",TCGENQRY(,, cQuery ),cAliasSC9,.F.,.T.)
	_x__aPedNw := {}
	

	//TABELA CUSTOMIZADA DE CARREGAMENTO DE CARGA
	/*dBSelectArea( "ZAF" )
	ZAF->( dBSetOrder( 2 ) )
	ZAF->( dBGoTop(  ) )
	ZAF->( MSSeek( xFilial( "ZAF" ) + DAK->DAK_COD + DAK->DAK_SEQCAR ) )

	
	
	//VETOR ORIGINAL
	/*_X__DadCga := { DAK->DAK_COD                , ;
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
					*/

     
	 dbSelectArea("ZN1")
        ZN1->(DbSetOrder(1))
        ZN1->(dbGoTop())
       // ZN1-> dbSeek( xFilial("ZN1") + pcCarga)
		ZN1->( MSSeek( xFilial( "ZN1" ) + pcCarga ) )

		 _X__DadCga := { pcCarga       , ;
	                "02"            , ;
	                "03"            , ;
	                date()          , ;
	                time()          , ;
	                ZN1->ZN1_PLACA  , ;
	                ZN1->ZN1_MOTORI , ;
	                ZN1->ZN1_DTEMB  , ;
	                ZN1->ZN1_DTSEP  , ;
	                ZN1->ZN1_HORA   , ;
	                "000001"        , ;
					ZN1->ZN1_REVISA , ;
					ZN1->ZN1_OBS   }
    // tela customizada de dados auxiliares
     /*_X__DadCga := { pcCarga       , ;
	                "01"           , ;
	                "01"           , ;
	                "22/11/2021"   , ;
	                "09:19:00"     , ;
	                "ABB4518"      , ;
	                "000003"       , ;
	                "23/11/2021"   , ;
	                "23/11/2021"   , ;
	                "10:00"        , ;
	                "000001"       , ;
	                "01"           , ;
					"Obs teste Igor"  }*/


	
	lFirst    := .T.
	( cAliasSC9 )->( dBGoTop( ) )
	
	While !( cAliasSC9 )->( Eof( ) )
		If lFirst
			lFirst := .F.
			aAdd( _x__aPedNw, { cCarga, "01" } )
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


    //MsgInfo("OK", "Passo 1")
	
	For nZ := 1 To Len( _x__aPedNw )
			
		For nY := 3 To Len( _x__aPedNw[ nZ ] ) // FILIAL + PEDIDO + ITEM
               
			   //TESTE
			  // cMensagem +=  cValToChar(_x__aPedNw[ nZ ][ nY ][ 1 ])
			  // cMensagem += " | " +cValToChar(_x__aPedNw[ nZ ][ nY ][ 2 ])
			  // cMensagem += " | " +cValToChar(_x__aPedNw[ nZ ][ nY ][ 3 ])
			  // MsgInfo(cMensagem, "Array _x__aPedNw ")


              // cMensagem2 += "Total Reg:" +  cValToChar( str(len( _X__Ped )) )
			  // MsgInfo(cMensagem2, "Array _X__Ped ")

			nPos := aScan( _X__Ped, { |X| X[ 1 ] == _x__aPedNw[ nZ ][ nY ][ 1 ] .And. X[ 2 ] == _x__aPedNw[ nZ ][ nY ][ 2 ]  .And. X[ 3 ] == _x__aPedNw[ nZ ][ nY ][ 3 ] } )
			
			//MsgInfo(str(nPos), "Passo 1.0")

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

 //MsgInfo("OK", "Passo 2")
 //MsgInfo(pcCarga, "Passo 2.0")
 //MsgInfo("tamanho vetor :"+str(len( _X__Ped )), "Passo 2.0.1")

If !Empty( pcCarga ) .And. Len( _X__Ped ) > 0 
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
	
	//MsgInfo("OK", "Passo 2.1")
	If Len( aTipo ) == 0
		Aadd( aTipo,{ Space( 6 ), Space( 30 ) } )
	EndIf
	
	cCarga  := pcCarga
	aPedGet := _X__Ped
	
	dBSelectArea( "DA4" )
	DA4->( dbSetOrder( 1 ) )
	DA4->( dBGoTop( ) )
	DA4->( dBSeek( xFilial( "DA4" ) + cValToChar(_X__DadCga[7]) ) )

	cRevCarga := StrZero(_X__DadCga[12], TAMSX3('ZN1_REVISA')[1]) //Soma1( cRevCarga, TamSX3( "DAK_X_REVI" )[ 1 ] )

   cCodSep  := cValToChar(_X__DadCga[11])  //GETSX8NUM( "ZAF", "ZAF_COD" )
   cMay     := "ZAF" + Alltrim( xFilial( "ZAF" ) )
   cRevSep  :=  cValToChar(_X__DadCga[12])  //StrZero( 0, TamSX3( 'ZAF_REVIS' )[ 1 ] )  
   //cRevSep  := Soma1( cRevSep, TamSX3( 'ZAF_REVIS' )[ 1 ] )


	
	/*dBSelectArea( "ZAF" )
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
	Endif*/


	
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
		//MsgInfo( FUNNAME() + " >>> Não foi encontrado o arquivo " + cHtmlSepar )
		Return( .F. )
	Endif
	
	aZonas   := {}
	aSetores := {}
	aRotas   := {}
	//MsgInfo("OK", "Passo 2.2")
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

		   /* RecLock( "SC9", .F. )
		    SC9->C9_X_CODSE := cCodSep
		    SC9->C9_X_REVSE := cRevSep
		    SC9->C9_BLEST   := "SP"
            SC9->( MsUnLock( ) )*/
			
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
	//MsgInfo("OK", "Passo 2.3")
	cRota   := ""
	cZona   := ""
	cSetor  := ""
	aSetorX := {}
	
	If PswSeek( AllTrim( __cUserId ), .T. )
		aDadosUsr := PswRet( 1 )
	Endif
	
	//MsgInfo("OK", "Passo 2.4")


	For nX := 1 To Len( aPedGet )
		
		nPos := aScan( aPedidos, { |X| X[ 1 ] == aPedGet[ nX ][ 2 ] } )
		If nPos == 0
			aAdd( aPedidos, { aPedGet[ nX ][ 2 ], aPedGet[ nX ][ 5 ], aPedGet[ nX ][ 6 ], aPedGet[ nX ][ 7 ], aPedGet[ nX ][ 8 ] } )
		Else
			aPedidos[ nPos ][ 5 ] += aPedGet[ nX ][ 8 ]
		Endif
		
	Next
   // MsgInfo("OK", "Passo 2.5")
	cProcesso := OemToAnsi( "SEPARA" )
    
    // Caso a carga já tenha sofrido alguma revisão, redefine o assunto do e-mail
	if isInCallStack( "U_FLXPE01" )
		cAssunto := "[ Carga: "+ cCarga +"] Separação Finalizada! "
    elseif _X__DadCga[12] > 0
        cAssunto := "Revisao "+ cRevCarga + " [Carga: "+ cCarga +"]
    else
	    cAssunto := "Separacao/Pesagem/Embarque de Mercadorias [Carga: " + cCarga +"]"
    endif
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
	oHtml:ValByName( "CAB_CARGA", cValToChar(_X__DadCga[1])        )
	oHtml:ValByName( "CAB_REVIS", cRevCarga             )
	oHtml:ValByName( "CAB_DTCGA",  cValToChar(_X__DadCga[4]) ) //DTOC
	oHtml:ValByName( "CAB_HRCGA", Transform( cValToChar(_X__DadCga[5]), "99:99" ) )
	oHtml:ValByName( "CAB_VEIC" , cValToChar(_X__DadCga[6]) )
	oHtml:ValByName( "CAB_MOTOR", DA4->DA4_NOME   )
	oHtml:ValByName( "CAB_EMBQE",  cValToChar(_X__DadCga[8])  ) // DTOC
	oHtml:ValByName( "CAB_DTSEP", cValToChar(_X__DadCga[9])  ) // DTOC
	oHtml:ValByName( "CAB_HRSEP", Transform( cValToChar(_X__DadCga[10]) , "99:99" ) )
	oHtml:ValByName( "CAB_SOLIC", Alltrim( aUserInfo[ 1 ] [ 4 ] ) )
	oHtml:ValByName( "CAB_SEPARA", cCodSep   )
	oHtml:ValByName( "CAB_REVSEP", cRevSep   )
	oHtml:ValByName( "CAB_DT"    , DTOC( dDataBase ) )
	oHtml:ValByName( "CAB_HR"    , Transform( Time(), "99:99:99" ) )
	oHtml:ValByName( "CAB_OBS1" , StrTran( cValToChar(_X__DadCga[13]),chr(13),'<br>') ) //StrTran(DAK->DAK_X_OBS,chr(13),'<br>') )

   	


	//MsgInfo("CABECARIO DA CARGA - OK", "Passo 2.6")
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
	
	if FindFunction( "U_LSROMS03" )
		cFileRep := U_LSROMS03( pcCarga, .T. )
		if File(cFileRep)
			oProcess:AttachFile( cFileRep )
		endif
	endif
	cIDWF := oProcess:Start()
	//MsgInfo("AJUSTE DE EMBARQUE - OK ", "Passo 2.7")
	If !lNewSep
	   /*	RecLock( "ZAF", .F. )
		ZAF->ZAF_REVIS  := cRevSep
		ZAF->ZAF_DATA   := DDATABASE
		ZAF->ZAF_HORA   := TIME()
		ZAF->ZAF_IDUSR  := __cUserId
		ZAF->ZAF_USER   := aDadosUsr[ 1 ][ 2 ]
		ZAF->ZAF_IDWF   := cIdWF
		ZAF->ZAF_STATUS := "E"
		ZAF->( MsUnLock( ) )*/
	Else
	 /*	S
		ZAF->ZAF_FILIAL := pcFilial
		ZAF->ZAF_COD    := cCodSep
		ZAF->ZAF_CARGA  := pcCargaS
		ZAF->ZAF_REVIS  := cRevSep
		ZAF->ZAF_SEQ    := pcSeqCar
		ZAF->ZAF_OPERAC := "S"
		ZAF->ZAF_DATA   := DDATABASE
		ZAF->ZAF_HORA   := TIME()
		ZAF->ZAF_IDUSR  := __cUserId
		ZAF->ZAF_USER   := aDadosUsr[ 1 ][ 2 ]
		ZAF->ZAF_IDWF   := cIdWF
		ZAF->( MsUnLock( ) )
		ConfirmSx8()*/
	Endif
	
Endif

 MsgInfo("Evento WorkFlow Disparado!", "Aviso")

Return( .T. )


// CACELAMENTO DO WORKFLOW GERADO

User Function FWSEP003( pcFilial, pcCarga, pcSeqCar, pcObj )
**************************
Local cCarga      := pcCarga
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
Local cRevCarga   := ""
Local cAssunto    := ""
Local cCodRota    := Space( TamSX3( "DA8_COD"    )[ 1 ] )
Local cZona       := Space( TamSX3( "DA7_PERCUR" )[ 1 ] )
Local cSetor      := Space( TamSX3( "DA7_ROTA"   )[ 1 ] )
Local cSeqRota    := Space( TamSX3( "DA9_SEQUEN" )[ 1 ] )
Local cSequencia  := Space( TamSX3( "DA7_SEQUEN" )[ 1 ] )
Local cPtoRefDA6  := Space( TamSX3( "DA6_REF"    )[ 1 ] )
Local cPtoRefDA5  := Space( TamSX3( "DA5_DESC"   )[ 1 ] )
Local cDescRota   := "PEDIDOS SEM ROTA"
Local lValido     := .F.
Local cHtmlCanc   := Alltrim( GetMV( "MV_LSWFCAN" ) )
Local cDirWFSep   := Alltrim( GetMV( "MV_LSDIRSP" ) )
Local cMailTo     := Alltrim( GetMV( "MV_LSENDMA" ) )
Local cDir        := Alltrim( GetMV( "MV_WFDIR"   ) )
Local nPosD       := 0
Local hEnter      := Chr( 13 )
Local aPedGet     := {}
Local aPedidos    := {}
Local aProdutos   := {}
Local oProcess
Local nRegDA7, nX
Local _X__Ped := {}
local nZ := 0
local nY := 0
 //MsgInfo("Evento Cancelar WorkFlow 01", "TESTE")

If !Empty( pcCarga )   //Type( '_X__Ped' ) <>  'U'
cAliasSC9   := GetNextAlias( )


	
	Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "LSOMS06" )
	
	cQuery :=  " SELECT SC9.*,"                                 +       hEnter
	cQuery += "         SC9.R_E_C_N_O_ RECSC9 "                 +       hEnter
	cQuery += "    FROM " + RetSqlName( "SC9" ) + " SC9 "       +       hEnter
	cQuery += "   WHERE SC9.C9_FILIAL   = '" + xFilial( "SC9" ) + "'" + hEnter
	cQuery += "     AND SC9.C9_X_SIMUL  = '" + pcCarga          + "'" + hEnter
	//cQuery += "     AND SC9.C9_SEQCAR   = '" + pcSeqCar         + "'" + hEnter
	cQuery += "     AND SC9.D_E_L_E_T_ <> '*'"                  +       hEnter
	cQuery += "ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM"             +       hEnter
	
	MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)
	
	If Select( cAliasSC9 ) > 0
		( cAliasSC9 )->( dBclosearea( ) )
	Endif
	
	cQuery := ChangeQuery(cQuery)
	
	dBUseArea(.T.,"TOPCONN",TCGENQRY(,, cQuery ),cAliasSC9,.F.,.T.)
	_x__aPedNw := {}
	

     
	 dbSelectArea("ZN1")
        ZN1->(DbSetOrder(1))
        ZN1->(dbGoTop())
       // ZN1-> dbSeek( xFilial("ZN1") + pcCarga)
		ZN1->( MSSeek( xFilial( "ZN1" ) + pcCarga ) )

		 _X__DadCga := { pcCarga       , ;
	                "02"            , ;
	                "03"            , ;
	                date()          , ;
	                time()          , ;
	                ZN1->ZN1_PLACA  , ;
	                ZN1->ZN1_MOTORI , ;
	                ZN1->ZN1_DTEMB  , ;
	                ZN1->ZN1_DTSEP  , ;
	                ZN1->ZN1_HORA   , ;
	                "000001"        , ;
					ZN1->ZN1_REVISA , ;
					ZN1->ZN1_OBS   }



	
	lFirst    := .T.
	( cAliasSC9 )->( dBGoTop( ) )
	
	While !( cAliasSC9 )->( Eof( ) )
		If lFirst
			lFirst := .F.
			aAdd( _x__aPedNw, { cCarga, "01" } )
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


    //MsgInfo("OK", "Passo 1")
	
	For nZ := 1 To Len( _x__aPedNw )
			
		For nY := 3 To Len( _x__aPedNw[ nZ ] ) // FILIAL + PEDIDO + ITEM
               

			nPos := aScan( _X__Ped, { |X| X[ 1 ] == _x__aPedNw[ nZ ][ nY ][ 1 ] .And. X[ 2 ] == _x__aPedNw[ nZ ][ nY ][ 2 ]  .And. X[ 3 ] == _x__aPedNw[ nZ ][ nY ][ 3 ] } )
			
			//MsgInfo(str(nPos), "Passo 1.0")

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

If !Empty( pcCarga ) .And. Len( _X__Ped ) > 0 
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
	
	//MsgInfo("OK", "Passo 2.1")
	If Len( aTipo ) == 0
		Aadd( aTipo,{ Space( 6 ), Space( 30 ) } )
	EndIf
	
	cCarga  := pcCarga
	aPedGet := _X__Ped
	
	dBSelectArea( "DA4" )
	DA4->( dbSetOrder( 1 ) )
	DA4->( dBGoTop( ) )
	DA4->( dBSeek( xFilial( "DA4" ) + cValToChar(_X__DadCga[7]) ) )
	
	cRevCarga := StrZero(_X__DadCga[12], TAMSX3('ZN1_REVISA')[1]) //Soma1( cRevCarga, TamSX3( "DAK_X_REVI" )[ 1 ] )

   cCodSep  := cValToChar(_X__DadCga[11])  //GETSX8NUM( "ZAF", "ZAF_COD" )
   cMay     := "ZAF" + Alltrim( xFilial( "ZAF" ) )
   cRevSep  :=  cValToChar(_X__DadCga[12])  //StrZero( 0, TamSX3( 'ZAF_REVIS' )[ 1 ] )  
   


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
		MsgInfo( FUNNAME() + " >>> Não foi encontrado o arquivo " + cHtmlCanc, "HTML nao existe" )
		Return( .F. )
	Endif
	
	aZonas   := {}
	aSetores := {}
	aRotas   := {}
	//MsgInfo("OK", "Passo 2.2")
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

		   /* RecLock( "SC9", .F. )
		    SC9->C9_X_CODSE := cCodSep
		    SC9->C9_X_REVSE := cRevSep
		    SC9->C9_BLEST   := "SP"
            SC9->( MsUnLock( ) )*/
			
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
	//MsgInfo("OK", "Passo 2.3")
	cRota   := ""
	cZona   := ""
	cSetor  := ""
	aSetorX := {}
	
	If PswSeek( AllTrim( __cUserId ), .T. )
		aDadosUsr := PswRet( 1 )
	Endif
	
	//MsgInfo("OK", "Passo 2.4")


	For nX := 1 To Len( aPedGet )
		
		nPos := aScan( aPedidos, { |X| X[ 1 ] == aPedGet[ nX ][ 2 ] } )
		If nPos == 0
			aAdd( aPedidos, { aPedGet[ nX ][ 2 ], aPedGet[ nX ][ 5 ], aPedGet[ nX ][ 6 ], aPedGet[ nX ][ 7 ], aPedGet[ nX ][ 8 ] } )
		Else
			aPedidos[ nPos ][ 5 ] += aPedGet[ nX ][ 8 ]
		Endif
		
	Next


	/// MsgInfo("Evento Cancelar WorkFlow 05 MONTANDO HTML", "TESTE")
	 cobscancela := pcObj
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
	oHtml:ValByName( "CAB_REVIS", _X__DadCga[ 12 ]                        )
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
	oHtml:ValByName( "CAB_OBS1" , 'AVISO DE CANCELAMENTO <br>' + StrTran( cobscancela, chr( 13 ),'<br>' ) )
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

	 MsgInfo("Workflow de Cancelamento Enviado !", "Aviso")
	
Endif

Return( .T. )
