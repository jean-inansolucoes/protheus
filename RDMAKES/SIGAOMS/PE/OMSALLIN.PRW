#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"

User Function OM200BRW()
	************************
	Public _X__ArMan  := { }
	Public _X__ArCga  := { }
	Public _X__PsCga  := 0
	Public _X__aCarga := { }
	Public _X__Carga  := Space( TamSX3( 'DAK_COD'    )[ 1 ] )
	Public _X__SeqCg  := Space( TamSX3( 'DAK_SEQCAR' )[ 1 ] )
	Public _x__Motor  := Space( TamSX3( 'DA4_COD'    )[ 1 ] )
	Public _x__Veicl  := Space( TamSX3( 'DA3_COD'    )[ 1 ] )
	Public _X__Ped    := { }
	Public _X__Go     := .F.
	Public _X__Item   := "00"
	Public _x__aPedNw := { }
	Public _X__Aglut  := { }
	Public _X__lTabl  := .T.
	Public _X__DadCga := { }
	Public _X__lZerar := .F.
Return( NIL )

//Ponto de entrada antes da geração da carga, permitindo o usuário interfirir na geração ou não da carga.
User Function OM200OK()
	Local nI
	Local _aCli := {}
	_X__ArMan := PARAMIXB[ 1 ]
	_X__ArCga := PARAMIXB[ 2 ]
	_X__PsCga := PARAMIXB[ 3 ]

	If !Empty(_X__ArCga[1,10])
		aAdd(_aCli,_X__ArCga[1,10])

		For nI := 1 To Len(_X__ArMan)
			_nPosCli := aScan(_aCli,{|x| x == _X__ArMan[nI,6]+_X__ArMan[nI,7]})

			If _nPosCli <= 0
				aAdd(_aCli,_X__ArMan[nI,6]+_X__ArMan[nI,7])
			EndIf
		Next nI
	EndIf

	If !Empty(_aCli)
		U_LTBOMS01(_aCli)
	EndIf

Return( .T. )

// Na montagem da Carga
User Function OS200DAK()
	************************
	Local nPos      := 0
//Local aDadosUsr := {}
//Local lGo       := .F.
	Local nOpc := 1
	Local lFilial := SuperGetMV("MV_ZLDTCA",,.F.)
	local _X__Item := "00"
	DEFAULT _X__aCarga := { }
//MsgInfo( 'OS200DAK' + ", " + FunName() + ", " + ProcName( ) )

	If !Empty( DAK->DAK_CAMINH )
		_X__Item    := Soma1( _X__Item, 2                           )
		nPos        := aScan( _X__aCarga, { |X| X[ 3 ] == DAK->DAK_COD } )

		dBSelectArea( "DA4" )
		DA4->( dBSetOrder( 1 ) )
		DA4->( dBGoTop( ) )
		DA4->( dBSeek( xFilial( "DA4" ) + DAK->DAK_MOTORI ) )

		dBSelectArea( "DA3" )
		DA3->( dBSetOrder( 1 ) )
		DA3->( dBGoTop( ) )
		DA3->( dBSeek( xFilial( "DA3" ) + DAK->DAK_CAMINH ) )

		If nPos == 0
			aAdd( _X__aCarga, { .T.,  _X__Item, DAK->DAK_FILIAL, DAK->DAK_COD, DAK->DAK_SEQCAR, DAK->DAK_CAMINH + " - " + Alltrim( DA3->DA3_DESC ), DAK->DAK_MOTORI + " " + alltrim( DA4->DA4_NOME ), "" } )
		Endif
		_X__lTabl := .T.

	Endif

	If lFilial
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta dialog para informar à data da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oDlgY := MSDialog():New(000,000,050,300,"Informe a Data de Carregamento",,,.F.,,,,,,.T.,,,.T. )
		oSayData := TSay():New(010,004,{|| "Data"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		@ 009, 040 MSGET oData  	VAR DAK->DAK_DATA	PICTURE "99/99/9999" OF oDlgY WHEN .T. PIXEL SIZE 050,008 HASBUTTON

		oBtnData := TButton():New(007, 100, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 037, 012,,,, .T.,,"",,,, .F.)
		oDlgY:Activate(,,,.T.)

	EndIf

Return( NIL )


// Estorno da carga
// Carrega itens liberados antes da efetivação do estorno da carga para envio do workflow
// inicio do processo de estorno
User Function OS200EST()
	************************
	Local hEnter    := Chr( 13 )
	Local cAliasSC9 := GetNextAlias( )
	Local cQuery    := ""
	Local lFirst    := .T.
	Local lGo       := .F.

//MsgInfo( 'OS200EST' + ", " + FunName() + ", " + ProcName( ) )

// If !Empty( DAK->DAK_CAMINH )

	Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "OS200EST" )

	If ( DAK->DAK_COD + DAK->DAK_SEQCAR ) <> ( PARAMIXB[ 1 ] + PARAMIXB[ 2 ] )
		dBSelectArea( "DAK" )
		DAK->( dBSetOrder( 1 ) )
		DAK->( dBGoTop(  ) )
		DAK->( dBSeek( xFilial( "DAK" ) + PARAMIXB[ 1 ] + PARAMIXB[ 2 ] ) )
	Endif

	If !Empty( DAK->DAK_CAMINH )
		_X__Carga  := DAK->DAK_COD
		_X__SeqCg  := DAK->DAK_SEQCAR
		_X__aCarga := {}

		_X__Item    := "00"
		_X__Item    := Soma1( _X__Item, 2 )

		aAdd( _X__aCarga, { .T.,  _X__Item, DAK->DAK_FILIAL, DAK->DAK_COD, DAK->DAK_SEQCAR, DAK->DAK_CAMINH + " - " + Alltrim( DA3->DA3_DESC ), DAK->DAK_MOTORI + " " + alltrim( DA4->DA4_NOME ), "" } )
	Endif

	dBSelectArea( "ZAF" )
	ZAF->( dBSetOrder( 2 ) )
	ZAF->( dBGoTop(  ) )
	ZAF->( MSSeek( xFilial( "ZAF" ) + DAK->DAK_COD + DAK->DAK_SEQCAR ) )

	if !Empty( DAK->DAK_CAMINH )
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
	endif

	cQuery := "  SELECT SC9.*,"                                 +       hEnter
	cQuery += "         SC9.R_E_C_N_O_ RECSC9 "                 +       hEnter
	cQuery += "    FROM " + RetSqlName( "SC9" ) + " SC9 "       +       hEnter
	cQuery += "   WHERE SC9.C9_FILIAL   = '" + xFilial( "SC9" ) + "'" + hEnter
	cQuery += "     AND SC9.C9_CARGA    = '" + DAK->DAK_COD     + "'" + hEnter
	cQuery += "     AND SC9.C9_SEQCAR   = '" + DAK->DAK_SEQCAR  + "'" + hEnter
	cQuery += "     AND SC9.D_E_L_E_T_ <> '*'"                  +       hEnter
	cQuery += "ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM"             +       hEnter

	MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)

	If Select( cAliasSC9 ) > 0
		( cAliasSC9 )->( dBclosearea( ) )
	Endif

	cQuery := ChangeQuery(cQuery)

	dBUseArea(.T.,"TOPCONN",TCGENQRY(,, cQuery ),cAliasSC9,.F.,.T.)

	_x__aPedNw := {}
	_X__lTabl  := .F.

	lFirst    := .T.
	( cAliasSC9 )->( dBGoTop( ) )
	while !( cAliasSC9 )->( Eof( ) )
		If lFirst
			lFirst := .F.

			If !Empty( DAK->DAK_CAMINH )
				aAdd( _x__aPedNw, { DAK->DAK_COD, DAK->DAK_SEQCAR, DAK->DAK_MOTORI, DAK->DAK_CAMINH  } )
			Endif
		Endif
		dBSelectArea( "SB1" )
		SB1->( dBSetOrder( 1 ) )
		SB1->( dBGoTop( ) )
		SB1->( dBSeek( xFilial( "SB1" ) + ( cAliasSC9 )->C9_PRODUTO ) )

		dBSelectArea( "SA1" )
		SA1->( dBSetOrder( 1 ) )
		SA1->( dBGoTop( ) )
		SA1->( dBSeek( xFilial( "SA1" ) + ( cAliasSC9 )->C9_CLIENTE + ( cAliasSC9 )->C9_LOJA ) )

		If !Empty( DAK->DAK_CAMINH )
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
		Endif

		dBSelectArea( "SC9" )
		SC9->( dBGoTop( ) )
		SC9->( dBGoTo( ( cAliasSC9 )->RECSC9 ) )
		If SC9->C9_PEDIDO == ( cAliasSC9 )->C9_PEDIDO .And. SC9->C9_BLEST == 'SP'
			RecLock( "SC9", .F. )
			SC9->C9_BLEST  := Space( TamSX3( 'C9_BLEST' )[ 1 ] )
			SC9->( MsUnLock( ) )
		Endif

		( cAliasSC9 )->( dBSkip( ) )
	enddo
//Endif

Return( Nil )

// Estorno da carga
// Envia Workflow de cancelamento de separação
User Function OS200ES2()
	************************
//MsgInfo( 'OS200ES2' + ", " + FunName() + ", " + ProcName( ) )
	If ISINCALLSTACK( "OS200PROCEST" )
		If Len( _x__aPedNw ) > 0
			_X__lZerar := .T.
			U_OMSAESTF()
			_x__aPedNw := {}
			_X__DadCga := {}
			_X__lZerar := .F.
		Endif
	Endif

Return( Nil )



//Associacao do motorista apos geracao de carga
User Function OS200MNT()
	***********************
	Local cVeiculo   := PARAMIXB[ 1 ] // - Veiculo
	Local cMotorista := PARAMIXB[ 2 ] // - Motorista
	Local cAjuda1    := PARAMIXB[ 3 ] // - Ajudante 1
	Local cAjuda2    := PARAMIXB[ 4 ] // - Ajudante 2
	Local cAjuda3    := PARAMIXB[ 5 ] // - Ajudante 3
	Local aRet       := { cVeiculo, cMotorista, cAjuda1, cAjuda2, cAjuda3 }

//MsgInfo( 'OS200MNT' + ", " + FunName() + ", " + ProcName( )  + ", " + 'OS200ASSOC: ' + iif( ISINCALLSTACK( 'OS200ASSOC' ), "Sim", " Nao" ) + ", " + 'OS200MANUT:' + iif( ISINCALLSTACK( 'OS200MANUT' ), " Sim" , " Nao" ) )
// Manuten'c~ao da carga - Associar Ve'iculo
	If ISINCALLSTACK( 'OS200ASSOC' )

		If !Empty( cMotorista )
			_x__Motor := cMotorista
		Else
			_x__Motor := Space( TamSX3( 'DA4_COD' )[ 1 ] )

		Endif

		If !Empty( cVeiculo )
			_x__Veicl  := cVeiculo
		Else
			_x__Veicl := Space( TamSX3( 'DA3_COD' )[ 1 ] )
		Endif

	Endif


Return( aRet )

//Associacao do ve'iculo/motorista apos geracao de carga
User Function OS200MOT()//    ok
	************************
	Local cQuery    :=  ""
	Local hEnter    := Chr( 13 )
	Local cAliasSC9 := GetNextAlias( )
	Local lFirst    := .T.
	Local lNew      := .F.
	Local _aCli		:= {}

	If ISINCALLSTACK( 'OS200ASSOC' )

		CursorWait()
		SysRefresh()

		Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "OS200MOT" )

		OsAvalDAK( "DAK", 11 )

		_X__lZerar           := .F.

		If Alltrim( _x__Veicl ) <> Alltrim( DAK->DAK_CAMINH ) .And. !Empty( DAK->DAK_CAMINH )
			lNew := .T.
		Else
			lNew := .F.
		Endif

		_X__lTabl := .F.

		cQuery := "SELECT SC9.*,"                                 +       hEnter
		cQuery += "       SC9.R_E_C_N_O_ RECSC9 "                 +       hEnter
		cQuery += "  FROM " + RetSqlName( "SC9" ) + " SC9 "       +       hEnter
		cQuery += " WHERE SC9.C9_FILIAL   = '" + xFilial( "SC9" ) + "'" + hEnter
		cQuery += "   AND SC9.C9_CARGA    = '" + DAK->DAK_COD     + "'" + hEnter
		cQuery += "   AND SC9.C9_SEQCAR   = '" + DAK->DAK_SEQCAR  + "'" + hEnter
		cQuery += "   AND SC9.D_E_L_E_T_ <> '*'"                  +       hEnter
		cQuery += "ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM"           +       hEnter

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
			SC9->( dBGoTop( ) )
			SC9->( dBGoTo( ( cAliasSC9 )->RECSC9 ) )

			If Empty( SC9->C9_BLEST )
				If Empty( SC9->C9_BLEST )
					RecLock( "SC9", .F. )
					SC9->C9_BLEST  := 'SP'
					SC9->( MsUnLock( ) )
				Endif
			Endif


			If lFirst
				lFirst := .F.
				aAdd( _x__aPedNw, { DAK->DAK_COD, DAK->DAK_SEQCAR, DAK->DAK_MOTORI, DAK->DAK_CAMINH  } )
			Endif

			dBSelectArea( "SB1" )
			SB1->( dBSetOrder( 1 ) )
			SB1->( dBGoTop( ) )
			SB1->( dBSeek( xFilial( "SB1" ) + ( cAliasSC9 )->C9_PRODUTO ) )

			dBSelectArea( "SA1" )
			SA1->( dBSetOrder( 1 ) )
			SA1->( dBGoTop( ) )
			SA1->( dBSeek( xFilial( "SA1" ) + ( cAliasSC9 )->C9_CLIENTE + ( cAliasSC9 )->C9_LOJA ) )

			_nPosCli := aScan(_aCli,{|x| x == ( cAliasSC9 )->C9_CLIENTE + ( cAliasSC9 )->C9_LOJA})
			If _nPosCli <= 0
				If Empty(_aCli)
					aAdd(_aCli,DAK->DAK_CAMINH)
				EndIf
				aAdd(_aCli,( cAliasSC9 )->C9_CLIENTE + ( cAliasSC9 )->C9_LOJA)
			EndIf

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

		If !Empty(_aCli)
			U_LTBOMS01(_aCli)
		EndIf

		CursorArrow()
		SysRefresh()

		_X__aCarga := {}
		_X__Item   := Soma1( _X__Item, 2 )

		_X__Carga  := DAK->DAK_COD
		_X__SeqCg  := DAK->DAK_SEQCAR

		aAdd( _X__aCarga, { .T.,  _X__Item, DAK->DAK_FILIAL, DAK->DAK_COD, DAK->DAK_SEQCAR, DAK->DAK_CAMINH + " - " + Alltrim( DA3->DA3_DESC ), DAK->DAK_MOTORI + " " + alltrim( DA4->DA4_NOME ), "" } )

		If lNew
			U_OM200FIM()
			_x__aPedNw := {}
			_X__lTabl  := .T.
		Else

			If Len( _x__aPedNw ) > 0 .And. Empty( DAK->DAK_CAMINH )
				U_OMSAESTF()
				_x__aPedNw := {}
				_X__DadCga := {}
				_X__lTabl := .T.
			Endif

		Endif

	Endif

Return( Nil )


User Function OM200MNU()
	************************

	aAdd( aRotina,{ 'Workflow Separação', 'MsgRun ( "Aguarde...", "Enviando workflow...", { || U_LSOMS06( , , , 2 ) } )' , 0 , 4,0, NIL } )
	aadd(aRotina,{'Data Carregamento','U_fDTDAK()' , 0 , 3,0,NIL})

Return( Nil )

User Function fDTDAK()
	Local nOpc := 1
	Local lFilial := SuperGetMV("MV_ZLDTCA",,.F.)
	Local dNovaDT := DAK->DAK_DATA
	If lFilial
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta dialog para informar à data da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oDlgY := MSDialog():New(000,000,050,300,"Informe a Nova data de Carregamento",,,.F.,,,,,,.T.,,,.T. )
		oSayData := TSay():New(010,004,{|| "Data"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		@ 009, 040 MSGET oData  	VAR dNovaDT	PICTURE "99/99/9999" OF oDlgY WHEN .T. PIXEL SIZE 050,008 HASBUTTON

		oBtnData := TButton():New(007, 100, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 037, 012,,,, .T.,,"",,,, .F.)
		oDlgY:Activate(,,,.T.)
		RECLOCK("DAK", .F.)
		DAK->DAK_DATA := dNovaDT
		DAK->(MSUNLOCK())
	EndIf
Return
/*
User Function OM200FIM()
************************
Local cAliasSC9  := GetNextAlias()
Local caTela     := ""     // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.    // Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.    // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.    // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .T.    // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .F.    // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    := 3      // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros 
Local nOption    := 2
Local oOK        := LoadBitmap( GetResources(), 'CHECKED'   )
Local oNO        := LoadBitmap( GetResources(), 'NOCHECKED' )
Local aCabTit    := { "", "Item", "Filial", "Carga", "Seq. Carga" ,"Veiculo", "Motorista" }
Local aLenTits   := { 12, 20    , 50      , 35     , 35           ,120      , 120        }
Local aLinDet    := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aSize      := MsAdvSize( , .F. , 430 )
Local nX, nZ, nY := 0
Local aCpoEnch1  := {}
Local aAlterEn1  := {}
Local hEnter     := Chr(13) 
Local oGDTPS, oGDTPE, oGHRPS, oGOBS
Default _X__lTabl := .T.
Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "OS200EST" )

//MsgInfo( 'OM200FIM' + ", " + FunName() + ", " + ProcName( )  )

OsAvalDAK( "DAK", 11 )

If _X__lTabl
	aArea  := TRBPED->( GetArea( ) )
	
	TRBPED->( dBGoTop( ) )
	
	While !TRBPED->( Eof( ) )
		
		If TRBPED->PED_GERA == "S"
			
			cQuery := "SELECT SC9.*,"                                     +       hEnter
			cQuery += "       SC9.R_E_C_N_O_ RECSC9 "                     +       hEnter
			cQuery += "  FROM " + RetSqlName( "SC9" ) + " SC9 "           +       hEnter
			cQuery += " WHERE SC9.C9_FILIAL     = '" + TRBPED->PED_FILORI + "'" + hEnter
			cQuery += "   AND SC9.C9_CARGA      = '" + DAK->DAK_COD       + "'" + hEnter
			cQuery += "   AND SC9.C9_SEQCAR     = '" + DAK->DAK_SEQCAR    + "'" + hEnter
			cQuery += "   AND SC9.C9_PEDIDO     = '" + TRBPED->PED_PEDIDO + "'" + hEnter
			cQuery += "   AND SC9.D_E_L_E_T_   <> '*'"                    +       hEnter
			cQuery += "ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM"               +       hEnter
			
			MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)
			
			If Select( cAliasSC9 ) > 0
				( cAliasSC9 )->( dBclosearea( ) )
			Endif
			
			cQuery := ChangeQuery(cQuery)
			
			dBUseArea(.T.,"TOPCONN",TCGENQRY(,, cQuery ),cAliasSC9,.F.,.T.)
			
			( cAliasSC9 )->( dBGoTop( ) )
			
			while !( cAliasSC9 )->( Eof() )
				dBSelectArea( "SC9" )
				SC9->( dBGoTop( ) )
				SC9->( dBGoTo( ( cAliasSC9 )->RECSC9  ) )
				
				RecLock( "SC9", .F. )
				SC9->C9_BLEST  := 'SP'
				SC9->( MsUnLock( ) )
				( cAliasSC9 )->( dBSkip() )
				
			enddo
		Endif
		TRBPED->( dBSkip( ) )
	Enddo
	
	RestArea( aArea )
	
Endif

If Type( "_X__aCarga" ) <> "U"

	If Len( _X__aCarga ) > 0
		
		If Aviso( "Atenção", "Existe(m) Carga(s) apta(s) para ser(em) separada(s), deseja enviar workflow para avisar a Expedição/Separação ?", { "Sim", "Não" } ) == 1
		     cPathExtras   := U_LSALXDIR( "SIGAOMS", "OM200FIM" )
		    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define e Registra os Campos do Enchoice                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( 'DAK' )
			RegToMemory( 'DAK', .F. )
			
			M->DAK_X_DTPS := DAK->DAK_X_DTPS
			M->DAK_X_DTPE := DAK->DAK_X_DTPE
			M->DAK_X_HREM := DAK->DAK_X_HREM
			M->DAK_X_OBS  := DAK->DAK_X_OBS
			
			aLinDet       := _X__aCarga
			aSize[ 1 ]    /= 1.5
			aSize[ 2 ]    /= 1.5
			aSize[ 3 ]    /= 1.5
			aSize[ 4 ]    /= 1.5
			aSize[ 5 ]    /= 1.5
			aSize[ 6 ]    /= 1.5
			aSize[ 7 ]    /= 1.5
			AAdd( aObjects, { 315,  75, .T., .T. } )
			AAdd( aObjects, { 100, 100, .T., .T. } )
			
			aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
			aPosObj  := MsObjSize( aInfo, aObjects,.T.)
			
			DEFINE DIALOG oDlgSep TITLE "Selecione as Cargas para Separação..." FROM aSize[ 7 ],000 TO aSize[ 6 ],aSize[ 5 ] PIXEL
			nCol := 120
			nLin := 45
			oGrupoA  := TGroup():New(   aPosObj[ 1 ][ 1 ] + 05, aPosObj[ 1 ][ 2 ]                        , ( oDlgSep:nHeight / 2 ) - nLin , aPosObj[ 1 ][ 4 ] - nCol     ,"   Cargas  ",oDlgSep,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oBrowse  := TWBrowse():New( aPosObj[ 1 ][ 1 ] + 15, aPosObj[ 1 ][ 2 ] + 5                    , ( oGrupoA:nWidth  / 2 ) - 10   , ( oGrupoA:nHeight / 2 ) - 13 ,, aCabTit, aLenTits, oGrupoA,,,,,,,,,,,,.F.,,.T.,,.T.,,.T.,.T. )
			oGrupoB  := TGroup():New(   aPosObj[ 1 ][ 1 ] + 05, ( ( ( oDlgSep:nWidth / 2 ) - nCol ) ) - 2, ( oDlgSep:nHeight / 2 ) - 20   , aPosObj[ 1 ][ 4 ]            ,"  Separação  ",oDlgSep,CLR_BLACK,CLR_WHITE,.T.,.F. )
			
			nLinA    := aPosObj[ 1 ][ 1 ] + 17
			nLinB    := aPosObj[ 1 ][ 1 ] + 24
			TSay():New( nLinA,( ( oDlgSep:nWidth / 2 ) - nCol ) + 2,{||"Data 'Separação'"                             },oGrupoB,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,0200,008)
			oGDTPS   := TGet():New( nLinB,( ( oDlgSep:nWidth / 2 ) - nCol ) + 2,{|u| If(PCount()>0,M->DAK_X_DTPS:=u,M->DAK_X_DTPS)},oGrupoB,( oGrupoB:nWidth / 4 ) - 8,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","M->DAK_X_DTPS",,)
			
			TSay():New( nLinA, ( ( oDlgSep:nWidth / 2 ) - nCol ) + ( ( oGrupoB:nWidth / 4 ) + 2 ),{||"Data 'Embarque'"                              },oGrupoB,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,0200,008)
			oGDTPE   := TGet():New( nLinB, ( ( oDlgSep:nWidth / 2 ) - nCol ) + ( ( oGrupoB:nWidth / 4 ) + 2 ),{|u| If(PCount()>0,M->DAK_X_DTPE:=u,M->DAK_X_DTPE)},oGrupoB,( oGrupoB:nWidth / 4 ) - 8,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","M->DAK_X_DTPE",,)
			
			nLinA    := nLinB + 16
			nLinB    := nLinA + 7
			TSay():New( nLinA,( ( oDlgSep:nWidth / 2 ) - nCol ) + 2,{||"Hora 'Embarque'"                          },oGrupoB,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,0200,008)
			oGHRPS   := TGet():New( nLinB,( ( oDlgSep:nWidth / 2 ) - nCol ) + 2,{|u| If(PCount()>0,M->DAK_X_HREM:=u,M->DAK_X_HREM)},oGrupoB,( oGrupoB:nWidth / 4 ) - 8,008,'99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","M->DAK_X_HREM",,)
			
			TSay():New( nLinB,( ( oDlgSep:nWidth / 2 ) - nCol ) + ( ( oGrupoB:nWidth / 4 ) ),{||" previsão embarque"    },oGrupoB,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,0200,008)
			
			nLinA    := nLinB + 16
			nLinB    := nLinA + 7
			TSay():New( nLinA,( ( oDlgSep:nWidth / 2 ) - nCol ) + 4,{||"Observações"                                 },oGrupoB,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,0200,008)
			oGOBS    := TMultiGet():New( nLinB,( ( oDlgSep:nWidth / 2 ) - nCol ) + 4,{|u| If(PCount()>0,M->DAK_X_OBS:=u,M->DAK_X_OBS)},oGrupoB,(oGrupoB:nWidth/2)-8,(oGrupoB:nHeight/3)-10,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
			
			oGDTPS:bValid := { || OM200FIMVD( M->DAK_X_DTPS ) }
			oGDTPE:bValid := { || OM200FIMVD( M->DAK_X_DTPE ) }
			oGHRPS:bValid := { || OM200FIMVH( M->DAK_X_HREM ) }
			
			oBrowse:SetArray( aLinDet )
			oBrowse:bLine      := {|| { If( aLinDet[ oBrowse:nAt ][ 01 ], oOK, oNO ), aLinDet[ oBrowse:nAt ][ 02 ], aLinDet[ oBrowse:nAt ][ 03 ], aLinDet[ oBrowse:nAt ][ 04 ], aLinDet[ oBrowse:nAt ][ 05 ], aLinDet[ oBrowse:nAt ][ 06 ] } }
			oBrowse:bLDblClick := {|| aLinDet[ oBrowse:nAt ][ 1 ] := !aLinDet[ oBrowse:nAt ][ 1 ], oBrowse:DrawSelect( ) }
			
			TBitmap():New( ( oGrupoA:nHeight / 2 ) + 25,004,012,012,"CHECKED",""  ,.F.,oDlgSep,,,.F.,.T.,,"",.T.,,.T.,,.F. )
			TSay():New(    ( oGrupoA:nHeight / 2 ) + 28,019,{||"Carga selecionado para 'Separação'."},oDlgSep,,TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, ),.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,0200,008)
			
			TBitmap():New( ( oGrupoA:nHeight / 2 ) + 25,150,012,012,"NOCHECKED","",.F.,oDlgSep,,,.F.,.T.,,"",.T.,,.T.,,.F. )
			TSay():New(    ( oGrupoA:nHeight / 2 ) + 28,165,{||"Carga não selecionada para 'Separação'."},oDlgSep,,TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, ),.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,0200,008)
			
			ACTIVATE DIALOG oDlgSep CENTERED ON INIT ( EnchoiceBar(oDlgSep,{|| iif( OM200FIMVD( M->DAK_X_DTPS ) .And. OM200FIMVD( M->DAK_X_DTPE ) .And. OM200FIMVH( M->DAK_X_HREM ), ( nOption := 1, oDlgSep:End() ), .F. ) },{|| ( nOption := 2, oDlgSep:End() ) } ), ( CursorArrow(), SysRefresh() ) )
			
			If nOption == 1
			   For nX := 1 To Len( aLinDet )
			      	If aLinDet[ nX ][ 1 ]
				     	RecLock( "DAK", .F. )
					 	DAK->DAK_X_DTPS := M->DAK_X_DTPS
					 	DAK->DAK_X_DTPE := M->DAK_X_DTPE
					 	DAK->DAK_X_HREM := M->DAK_X_HREM
					 	DAK->DAK_X_OBS  := M->DAK_X_OBS
					 	DAK->( MsUnLock( ) )

					 	_X__Ped         := { }
					 	cTexto          := ""
					
					 	If _X__lTabl
						 	aArea  := TRBPED->( GetArea( ) )
						
						 	TRBPED->( dBGoTop( ) )
						
						 	While !TRBPED->( Eof( ) )

							 	If TRBPED->PED_GERA == "S"
							     	nPos := aScan( _X__Ped, { |X| X[ 1 ] == TRBPED->PED_FILORI .And. X[ 2 ] == TRBPED->PED_PEDIDO } )
							     	If nPos == 0
							     	    dBSelectArea( "SC9" )
							     	    SC9->( dBSetOrder( 2 ) )
							     	    SC9->( dBGoTop( ) )
							     	    SC9->( dBSeek( TRBPED->PED_FILORI + TRBPED->PED_CODCLI + TRBPED->PED_LOJA + TRBPED->PED_PEDIDO + TRBPED->PED_ITEM ) )
							     	    
							     	    dBSelectArea( "SB1" )
							     	    SB1->( dBSetOrder( 1 ) )
							     	    SB1->( dBGoTop( ) )
							     	    SB1->( dBSeek( xFilial( "SB1" ) + SC9->C9_PRODUTO ) )
							     	    
								     	aAdd( _X__Ped, { TRBPED->PED_FILORI , ;
								                      	 TRBPED->PED_PEDIDO , ;
								                      	 TRBPED->PED_ITEM   , ;
								                      	 TRBPED->PED_SEQLIB , ;
								                      	 TRBPED->PED_CODCLI , ;
								                      	 TRBPED->PED_LOJA   , ;
								                      	 TRBPED->PED_NOME   , ;
								                      	 TRBPED->PED_VALOR  , ;
								                      	 TRBPED->PED_QTDLIB , ;
								                      	 SC9->C9_PRODUTO    , ;
								                      	 SB1->B1_DESC       , ;
								                      	 0                  } )
								        cTexto += TRBPED->PED_PEDIDO + "  " + TRBPED->PED_ITEM
							     	Else
							         	_X__Ped[ nPos ][ 8 ] += TRBPED->PED_VALOR
							         	_X__Ped[ nPos ][ 9 ] += TRBPED->PED_QTDLIB
							     	Endif
							 	Endif
							 	TRBPED->( dBSkip( ) )
						 	Enddo
						
						 	RestArea( aArea )
						
					 	Else 
					     	For nZ := 1 To Len( _x__aPedNw )
					    	
					         	If ( _x__aPedNw[ nZ ][ 1 ] + _x__aPedNw[ nZ ][ 2 ] ) == ( aLinDet[ nZ ][ 4 ] + aLinDet[ nX ][ 5 ] )
					        	
					             	For nY := 5 To Len( _x__aPedNw[ nZ ] ) // FILIAL + PEDIDO + ITEM
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
								        
								         	cTexto += _x__aPedNw[ nZ ][ nY ][ 2 ] + "  " + _x__aPedNw[ nZ ][ nY ][ 3 ]
                                     	Else
							            	_X__Ped[ nPos ][ 8 ] += _x__aPedNw[ nZ ][ nY ][ 8 ] * _x__aPedNw[ nZ ][ nY ][ 9 ]
							            	_X__Ped[ nPos ][ 9 ] += _x__aPedNw[ nZ ][ nY ][ 9   ]
                                     	Endif
								                     
								 	Next nY
					         	Endif
					     	Next
					 	Endif
					
					 	MemoWrite( cPathExtras + ProcName() + ".TXT", cTexto )
					
					 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					 	//³ Montagem do Workflow de envio de solicitação de separação das mercadorias da carga  ³
					 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					 	MsgRun ( "Aguarde...", "Enviando workflow...", { || U_LSOMS06( aLinDet[ nX ][ 3 ], aLinDet[ nX ][ 4 ], aLinDet[ nX ][ 5 ], 1  ) } )
					
				 	Endif
			 	Next
			Endif
		Endif
	Endif
Endif

_X__ArMan  := { }
_X__ArCga  := { }
_X__PsCga  := 0
_X__aCarga := { }
_X__Carga  := Space( TamSX3( 'DAK_COD'    )[ 1 ] )
_X__SeqCg  := Space( TamSX3( 'DAK_SEQCAR' )[ 1 ] )
_x__Motor  := Space( TamSX3( 'DA4_COD'    )[ 1 ] )
_x__Veicl  := Space( TamSX3( 'DA3_COD'    )[ 1 ] )
_X__Ped    := { }
_X__Go     := .F.
_X__Item   := "00"

Return( Nil )
*/
User Function OMSAESTF()
	************************
	Local caTela     := ""     // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
	Local lColumn    := .F.    // Indica se a apresentacao dos campos sera em forma de coluna
	Local lF3        := .F.    // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
	Local lMemoria   := .T.    // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
	Local lNoFolder  := .T.    // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
	Local lProperty  := .F.    // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
	Local nModelo    := 3      // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros*/
	Local nOption    := 2
	Local oOK        := LoadBitmap( GetResources(), 'CHECKED'   )
	Local oNO        := LoadBitmap( GetResources(), 'NOCHECKED' )
	Local aCabTit    := { "", "Item", "Filial", "Carga", "Seq. Carga" ,"Veiculo", "Motorista" }
	Local aLenTits   := { 12, 20    , 50      , 35     , 35           ,120      , 120        }
	Local aLinDet    := {}
	Local aObjects   := {}
	Local aInfo      := {}
	Local aPosObj    := {}
	Local aSize      := MsAdvSize( , .F. , 430 )
	Local nX, nZ, nY := 0
	Local aCpoEnch1  := {}
	Local aAlterEn1  := {}
	Local oGDTPS, oGDTPE, oGHRPS, oGOBS

	If Type( "_X__aCarga" ) <> "U"

		If Len( _X__aCarga ) > 0

			If Aviso( "Atenção", "Esta operação caracteriza o Cancelamento da Expedição/Separação dos Pedidos, deseja enviar Workflow de Aviso de Cancelamento?", { "Sim", "Não" } ) == 1
				Private cPathExtras := U_LSALXDIR( "SIGAOMS", "OMSAESTF" )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Define e Registra os Campos do Enchoice                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( 'DAK' )
				RegToMemory( 'DAK', .F. )

				M->DAK_X_OBS  := DAK->DAK_X_OBS

				aLinDet       := _X__aCarga
				aSize[ 1 ]    /= 1.5
				aSize[ 2 ]    /= 1.5
				aSize[ 3 ]    /= 1.5
				aSize[ 4 ]    /= 1.5
				aSize[ 5 ]    /= 1.5
				aSize[ 6 ]    /= 1.5
				aSize[ 7 ]    /= 1.5
				AAdd( aObjects, { 315,  75, .T., .T. } )
				AAdd( aObjects, { 100, 100, .T., .T. } )

				aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
				aPosObj  := MsObjSize( aInfo, aObjects,.T.)

				DEFINE DIALOG oDlgSep TITLE "Selecione as Cargas para Cancelamento de Separação..." FROM aSize[ 7 ],000 TO aSize[ 6 ],aSize[ 5 ] PIXEL
				nCol := 120
				nLin := 45
				oGrupoA  := TGroup():New(   aPosObj[ 1 ][ 1 ] + 05, aPosObj[ 1 ][ 2 ]                        , ( oDlgSep:nHeight / 2 ) - nLin , aPosObj[ 1 ][ 4 ] - nCol     ,"   Cargas  ",oDlgSep,CLR_BLACK,CLR_WHITE,.T.,.F. )
				oBrowse  := TWBrowse():New( aPosObj[ 1 ][ 1 ] + 15, aPosObj[ 1 ][ 2 ] + 5                    , ( oGrupoA:nWidth  / 2 ) - 10   , ( oGrupoA:nHeight / 2 ) - 13 ,, aCabTit, aLenTits, oGrupoA,,,,,,,,,,,,.F.,,.T.,,.T.,,.T.,.T. )
				oGrupoB  := TGroup():New(   aPosObj[ 1 ][ 1 ] + 05, ( ( ( oDlgSep:nWidth / 2 ) - nCol ) ) - 2, ( oDlgSep:nHeight / 2 ) - 20   , aPosObj[ 1 ][ 4 ]            ,"  Observações  ",oDlgSep,CLR_BLACK,CLR_WHITE,.T.,.F. )

				nLinB    := aPosObj[ 1 ][ 1 ] + 15
				oGOBS    := TMultiGet():New( nLinB,( ( oDlgSep:nWidth / 2 ) - nCol ) + 2,{|u| If(PCount()>0,M->DAK_X_OBSC:=u,M->DAK_X_OBSC)},oGrupoB,(oGrupoB:nWidth/2)-8,(oGrupoB:nHeight/2)-12,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

				oBrowse:SetArray( aLinDet )
				oBrowse:bLine      := {|| { If( aLinDet[ oBrowse:nAt ][ 01 ], oOK, oNO ), aLinDet[ oBrowse:nAt ][ 02 ], aLinDet[ oBrowse:nAt ][ 03 ], aLinDet[ oBrowse:nAt ][ 04 ], aLinDet[ oBrowse:nAt ][ 05 ], aLinDet[ oBrowse:nAt ][ 06 ] } }
				oBrowse:bLDblClick := {|| aLinDet[ oBrowse:nAt ][ 1 ] := !aLinDet[ oBrowse:nAt ][ 1 ], oBrowse:DrawSelect( ) }

				TBitmap():New( ( oGrupoA:nHeight / 2 ) + 19,004,012,012,"CHECKED",""  ,.F.,oDlgSep,,,.F.,.T.,,"",.T.,,.T.,,.F. )
				TSay():New(    ( oGrupoA:nHeight / 2 ) + 22,019,{||"Carga selecionado p/ 'Cancelamento Separação'."},oDlgSep,,TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, ),.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,0200,008)

				TBitmap():New( ( oGrupoA:nHeight / 2 ) + 33,004,012,012,"NOCHECKED","",.F.,oDlgSep,,,.F.,.T.,,"",.T.,,.T.,,.F. )
				TSay():New(    ( oGrupoA:nHeight / 2 ) + 36,019,{||"Carga não selecionada p/ 'Cancelamento Separação'."},oDlgSep,,TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, ),.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,0200,008)

				ACTIVATE DIALOG oDlgSep CENTERED ON INIT ( EnchoiceBar(oDlgSep,{|| nOption := 1, oDlgSep:End()  },{|| ( nOption := 2, oDlgSep:End() ) } ), ( CursorArrow(), SysRefresh() ) )

				If nOption == 1
					For nX := 1 To Len( aLinDet )
						If aLinDet[ nX ][ 1 ]
							RecLock( "DAK", .F. )
							DAK->DAK_X_OBSC := M->DAK_X_OBSC
							DAK->( MsUnLock( ) )

							_X__Ped         := { }
							cTexto          := ""

							For nZ := 1 To Len( _x__aPedNw )

								If ( _x__aPedNw[ nZ ][ 1 ] + _x__aPedNw[ nZ ][ 2 ] ) == ( aLinDet[ nZ ][ 4 ] + aLinDet[ nX ][ 5 ] )

									For nY := 5 To Len( _x__aPedNw[ nZ ] ) // FILIAL + PEDIDO + ITEM
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
												_x__aPedNw[ nZ ][ nY ][ 12 ], ;
												_x__aPedNw[ nZ ][ nY ][ 13 ] } )

											cTexto += _x__aPedNw[ nZ ][ nY ][ 2 ] + "  " + _x__aPedNw[ nZ ][ nY ][ 3 ]
										Else
											_X__Ped[ nPos ][ 9 ] += _x__aPedNw[ nZ ][ nY ][ 9 ]
											_X__Ped[ nPos ][ 8 ] += _x__aPedNw[ nZ ][ nY ][ 8 ] * _x__aPedNw[ nZ ][ nY ][ 9 ]
										Endif

									Next nY
								Endif
							Next

							MemoWrite( cPathExtras + ProcName() + ".TXT", cTexto )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Montagem do Workflow de envio de solicitação de separação das mercadorias da carga  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							MsgRun ( "Aguarde...", "Enviando workflow...", { || U_LSOMS062( ) } )


						Endif
					Next
				Endif
			Endif
		Endif
	Endif

	_X__ArMan  := { }
	_X__ArCga  := { }
	_X__PsCga  := 0
	_X__aCarga := { }
	_X__Carga  := Space( TamSX3( 'DAK_COD'    )[ 1 ] )
	_X__SeqCg  := Space( TamSX3( 'DAK_SEQCAR' )[ 1 ] )
	_x__Motor  := Space( TamSX3( 'DA4_COD'    )[ 1 ] )
	_x__Veicl  := Space( TamSX3( 'DA3_COD'    )[ 1 ] )
	_X__Ped    := { }
	_X__Go     := .F.
	_X__Item   := "00"

Return( Nil )


Static Function OM200FIMVD( pData )
	***********************************
	Local dNullDate := CTOD( "  /  /  " )
	Local lRet      := .T.
	Default pData   := dNullDate

	If pData == dNullDate
		HELP(" ",1,"NVAZIO",,"Data 'Separação'/Data 'Embarque' deve ser informada, não pode ser vazia.",4,0)
		lRet := .F.
	Else
		If pData < dDataBase
			U_LSSHWHLP( "Data Inválida !", "Foi informado uma data inferior a data atual.", "Verifique novamente o a Data Informada!" )
			lRet := .F.
		Endif
	Endif

Return( lRet )

Static Function OM200FIMVH( pHora )
	***********************************
	Local cNullTime := ""
	Local lRet      := .T.
	Default pHora   := cNullTime

	If pHora == cNullTime
		HELP(" ",1,"NVAZIO",,"Hora 'Embarque' deve ser informada, não pode ser vazia.",4,0)
		lRet := .F.
	Else
		If !AtVldHora(  pHora )
			lRet := .F.
		Endif
	Endif

Return( lRet )

User Function OS200PM()
	***********************
//MsgInfo( 'OS200PM' + ", " + FunName() + ", " + ProcName( ) )
Return( NIL )


// Aglutina'c~ao de Carga
User Function OSAGRCAR()
	************************
	Local aAreaDAK  := DAK->( GetArea( ) )
	Local aOrigem   := PARAMIXB[ 1 ] // Dados da Carga Origem (Carga/Sequencia)
	Local cCarga    := PARAMIXB[ 2 ] // Carga Destino
	Local cSeqCar   := PARAMIXB[ 3 ] // Sequencia Carga Destino
	Local cQuery    := ""
	Local hEnter    := Chr( 13 )
	Local cAliasSC9 := GetNextAlias()
	Local nX := 0

	dBSelectArea( "DAK" )
	DAK->( dBSetOrder( 1 ) )
	DAK->( dBGoTop( ) )
	DAK->( dBSeek( xFilial( "DAK" ) + cCarga + cSeqCar ) )

	If !Empty( DAK->DAK_CAMINH )  .And. DAK->DAK_COD == cCarga

		Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "OSAGRCAR" )

		cQuery := "SELECT SC9.*,"                                 +       hEnter
		cQuery += "       SC9.R_E_C_N_O_ RECSC9 "                 +       hEnter
		cQuery += "  FROM " + RetSqlName( "SC9" ) + " SC9 "       +       hEnter
		cQuery += " WHERE SC9.C9_FILIAL   = '" + xFilial( "SC9" ) + "'" + hEnter
		cQuery += "   AND SC9.C9_CARGA    = '" + DAK->DAK_COD     + "'" + hEnter
		cQuery += "   AND SC9.C9_SEQCAR   = '" + DAK->DAK_SEQCAR  + "'" + hEnter
		cQuery += "   AND SC9.D_E_L_E_T_ <> '*'"                  +       hEnter

		MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)

		If Select( cAliasSC9 ) > 0
			( cAliasSC9 )->( dBclosearea( ) )
		Endif

		cQuery := ChangeQuery(cQuery)

		dBUseArea(.T.,"TOPCONN",TCGENQRY(,, cQuery ),cAliasSC9,.F.,.T.)

		_x__aPedNw := {}
		_X__lTabl := .F.

		lFirst    := .T.
		( cAliasSC9 )->( dBGoTop( ) )
		While !( cAliasSC9 )->( Eof( ) )
			If lFirst
				lFirst := .F.
				aAdd( _x__aPedNw, { DAK->DAK_COD, DAK->DAK_SEQCAR, DAK->DAK_MOTORI, DAK->DAK_CAMINH  } )
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
				SB1->B1_DESC              , ;
				0                         } )

			( cAliasSC9 )->( dBSkip( ) )
		Enddo

		If Select( cAliasSC9 ) > 0
			( cAliasSC9 )->( dBclosearea( ) )
		Endif

		CursorArrow()
		SysRefresh()

		_X__aCarga := {}
		_X__Item   := Soma1( _X__Item, 2 )

		_X__Carga  := DAK->DAK_COD
		_X__SeqCg  := DAK->DAK_SEQCAR

		cAux   := ""
		For nX := 1 To Len( aOrigem )
			If nX == 1
				cAux += aOrigem[ nX ][ 1 ] + " - Sequencia: " + aOrigem[ nX ][ 2 ]
			Else
				cAux += "/" + aOrigem[ nX ][ 1 ] + " Sequencia: " + aOrigem[ nX ][ 2 ]
			Endif
		Next

		_X__Aglut  := { cAux, cCarga, cSeqCar }

		aAdd( _X__aCarga, { .T.,  _X__Item, DAK->DAK_FILIAL, DAK->DAK_COD, DAK->DAK_SEQCAR, DAK->DAK_CAMINH + " - " + Alltrim( DA3->DA3_DESC ), DAK->DAK_MOTORI + " " + alltrim( DA4->DA4_NOME ), "" } )

		U_OM200FIM()
		_x__aPedNw := { }
		_X__Aglut  := { }
		_X__lTabl  := .T.
	Endif

	RestArea( aAreaDAK )

Return( NIL )


User Function OS200TOK ()
	Local cCarga   := DAK->DAK_COD
	Local aColsAux := aClone(aCols)
	Local aHeader  := aClone(aHeader)
	Local lRet     := .T.


	// Realiza as validações necessárias e atribui um valor à variável lRet
	// ......
	// ......

Return lRet

User Function NEWDTENT()
	Local nOpc := 1
	Local lFilial := .T.
	Local dNovaDT := SC5->C5_FECENT
	If lFilial
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta dialog para informar à data da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oDlgY := MSDialog():New(000,000,050,300,"Informe a nova data de entrega",,,.F.,,,,,,.T.,,,.T. )
		oSayData := TSay():New(010,004,{|| "Data"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		@ 009, 040 MSGET oData  	VAR dNovaDT	PICTURE "99/99/9999" OF oDlgY WHEN .T. PIXEL SIZE 050,008 HASBUTTON

		oBtnData := TButton():New(007, 100, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 037, 012,,,, .T.,,"",,,, .F.)
		oDlgY:Activate(,,,.T.)

		IF Empty(ALLTRIM(SC5->C5_NOTA)) .AND. Empty(ALLTRIM(SC5->C5_X_SIMUL)) .AND. dNovaDT >= dDataBase
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("SC6") + SC5->C5_NUM )
				RecLock( "SC5", .F. )
					SC5->C5_FECENT := dNovaDT
					SC5->C5_X_VLD := LastDay(dNovaDT)
				SC5->( MsUnLock( ) )
				While ! SC6->(EOF()) .and. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC5") + SC5->C5_NUM
					RecLock( "SC6", .F. )
					SC6->C6_ENTREG := dNovaDT
					SC6->(dbSkip())
					SC6->( MsUnLock( ) )

				EndDo
				dbSelectArea("SC9")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial("SC9") + SC5->C5_NUM )
					While ! SC9->(EOF()) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC5") + SC5->C5_NUM
						RecLock( "SC9", .F. )
						SC9->C9_DATENT := dNovaDT
						SC9->(dbSkip())
						SC9->( MsUnLock( ) )

					EndDo
				EndIf
				ApMsgInfo("Data de entrega alterada!", "Sucesso")
			EndIf
		ElseIf !Empty(ALLTRIM(SC5->C5_NOTA))
			MsgStop("Pedido já faturado, não é possível alterar a data!", "Atenção")
		ElseIf !Empty(ALLTRIM(SC5->C5_X_SIMUL))
			MsgStop("Pedido está em uma carga, solicite o estorno!", "Atenção")
		Elseif dNovaDT < dDataBase
			MsgStop("Não é possível informar uma data retroativa!", "Atenção")
		EndIf

	EndIf

Return
