
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV001 ºAutor  ³Rafael Parma         º Data ³  07/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de entrada de dados de coleta de leite do produtor.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------*
User Function LTMOV001()
	*-----------------------*

	Local cAliasH		:= "ZL5"

	Private cCadastro	:= "Mov. Produtor"
	Private aCores  	:= {}
	Private aRotina 	:= MENUDEF()

	Public nTotItem 	:= 0
	Public nTotDivg 	:= 0

	dBSelectArea( cAliasH )
	(cAliasH)->( dBSetOrder( 1 ) )
	(cAliasH)->( dBGotop( ) )

	aADD(aCores, { 'ZL5_STATUS == " ".AND.ZL5_X_PARC ==" " '  , 'BR_VERDE'     })
	aADD(aCores, { 'ZL5_STATUS == " ".AND.ZL5_X_PARC !=" " '  , 'BR_AZUL'     })
	aADD(aCores, { 'ZL5_STATUS != " " '  , 'BR_VERMELHO'  })


	mBrowse( ,,,,cAliasH,,,,,, aCores)

	If select(cAliasH) > 0
		(cAliasH)->( dBCloseArea( ) )
	Endif

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef  ºAutor  ³Rafael Parma         º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição das sub-rotinas da rotina principal               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	*------------------------*
Static Function MenuDef()
	*------------------------*

	Local aRotina := { { "Pesquisar" , "AxPesqui"    , 0 , 1},;
		{ "Visualizar", "U_LTMOV1Vis" , 0 , 2},;
		{ "Incluir"   , "U_LTMOV1Inc" , 0 , 3},;
		{ "Alterar"   , "U_LTMOV1Alt" , 0 , 4},;
		{ "Excluir"   , "U_LTMOV1Exc" , 0 , 5},;
		{ "At. Plataforma"   , "U_LTMV1PLT1" , 0 , 6}}
Return ( aRotina )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1Vis ºAutor  ³Rafael Parma        º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualização do movimento.                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

	*---------------------------------------------*
User Function LTMOV1Vis( cAlias, nReg, nOpc )
	*---------------------------------------------*
	Local oSAY1
	Local oSAY2
	Local aArea      := GetArea()
	Local cAliasIT   := "ZL6"
	Local cItem      := "ZL6_SEQ"
	Local cNomePrd   := "ZL6_NOMPRD"
	Local bCampo     := {|nCPO| Field(nCPO) }
	Local aSize      := {}
	Local aObjects   := {}
	Local aInfo      := {}
	Local aPosObj    := {}
	Local aCpoEnch   := {}
	Local aAlterEnch := {}
	Local aFldsNwGd  := {}
//Local aGets      := {}
	Local nModelo    := 3
	Local nX, i        := 0
	Local nUsado	 := 0
	Local nPoZL5I    := 0
	Local nPosItem   := 0
	Local nP_NOMPRD  := 0
	Local nOpcNewGd	 := GD_INSERT + GD_UPDATE + GD_DELETE
	Local lColumn    := .F.
	Local lF3        := .F.
	Local lMemoria   := .T.
	Local lNoFolder  := .F.
	Local lProperty  := .T.
//Local lAction    := .T.
	Local nNumDec    := TamSX3("ZL5_TOTAL")[2]
	Private aHeader	 := {}
	Private aCols	 := {}
	Private INCLUI   := .F.
	Private ALTERA   := .F.
	Private oGetD
	Private oDlgLTMOV1

	nTotItem := 0
	nTotDivg := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define e Registra os Campos do Enchoice                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( cAlias )
	RegToMemory( cAlias, INCLUI, .F. )

	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop( ) )
	SX3->( dBSeek( cAlias ) )
	While ( !Eof() .And. SX3->X3_ARQUIVO==cAlias )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" )
			AADD( aCpoEnch, SX3->X3_CAMPO )
		EndIf
		SX3->(dbSkip())
	Enddo
	aAlterEnch := aCpoEnch

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribui aos Campos registrados os valores do registro da tabela posicionado   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( cAlias )
	For i := 1 TO FCount()
		M->&(Eval( bCampo,i ) ) := FieldGet(i)
	Next i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define aHeader do MsNewGetDados                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop( ) )
	SX3->( dBSeek( cALiasIT ) )
	While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL6_COD" )
			nUsado++
			Aadd(aHeader,{AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO,;
				".T."})

			Aadd(aFldsNwGd, SX3->X3_CAMPO)

			If ( AllTrim(SX3->X3_CAMPO)== cItem )
				nPosItem := nUsado
			ElseIf  ( AllTrim(SX3->X3_CAMPO)== cNomePrd )
				nP_NOMPRD := nUsado
			Endif
		EndIf
		SX3->(dbSkip())
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( cALiasIT )
	(cALiasIT)->( dBSetOrder( 1 ) )
	(cALiasIT)->( dBGotop(  ) )
	(cALiasIT)->( dBSeek( xFilial( cALiasIT ) + ZL5->ZL5_COD ) )
	While ( !(cALiasIT)->(  Eof( ) ) .And. ZL6->ZL6_FILIAL == xFilial( cALiasIT ) .And. ZL6->ZL6_COD == ZL5->ZL5_COD )
		If ( SoftLock( cALiasIT ) )
			aadd(aCols,Array(nUsado+1))
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V" )
					If !Empty( nPoZL5I := FieldPos(aHeader[nX][2] ) )
						aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL5I ) )
					EndIf
				Else
					aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
				EndIf
			Next
			aCols[Len(aCols)][nUsado+1] := .F.
		Else
			lTravas := .T.
		EndIf
		(cALiasIT)->(dBSkip())
	EndDo

	aSort( aCols , , , { |x,y| x[nP_NOMPRD] < y[nP_NOMPRD] } )


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize   := MsAdvSize()
	AAdd( aObjects, { 060, 060, .T., .f. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 010, 010, .T., .f. } )

	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
	nGetLin := aPosObj[3,1]

	DEFINE MSDIALOG oDlgLTMOV1 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos do Cabeçalho                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlgLTMOV1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)

	@ nGetLin,aPosGet[1,1]  SAY "Total dos itens: " SIZE 050,09 PIXEL
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL
	@ nGetLin,aPosGet[1,3]  SAY "Divergência: " SIZE 050,09 PIXEL
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL

	oDlgLTMOV1:Cargo := {|n1,n2| oSAY1:SetText(n1), oSAY2:SetText(n2) }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grid de Exibição                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,,,"+" + cItem, aFldsNwGd,000,999,,"",,oDlgLTMOV1,aHeader,aCols)
	MOV001Rodap(@nTotItem,@nTotDivg)

	ACTIVATE MSDIALOG oDlgLTMOV1 ON INIT EnchoiceBar(oDlgLTMOV1,{||oDlgLTMOV1:End()},{||oDlgLTMOV1:End()})

	RestArea(aArea)

	If select(cAliasIT) > 0
		(cAliasIT)->( dBCloseArea( ) )
	Endif

Return( nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1Inc ºAutor  ³Rafael Parma        º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusão do movimento.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                            
	*--------------------------------------------*
User Function LTMOV1Inc( cAlias, nReg, nOpc )
	*--------------------------------------------*

	Local oSAY1
	Local oSAY2
	Local cAliasIT   := "ZL6"
	Local cItem      := "ZL6_SEQ"
	Local aSize      := {}
	Local aObjects   := {}
	Local aInfo      := {}
	Local aPosObj    := {}
	Local aCpoEnch   := {}
	Local aAlterEnch := {}
	Local aFldsNwGd  := {}
	Local aBotoes    := {}
	Local nModelo    := 3
	Local nX         := 0
	Local nUsado	 := 0
//Local nPoZL5I    := 0
	Local nPosItem   := 0
	Local nOpcA		 := 1
	Local nNumDec    := TamSX3("ZL5_TOTAL")[2]
	Local nOpcNewGd	 := if( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)
	Local lAction    := .F.
	Local lColumn    := .F.
	Local lF3        := .F.
	Local lMemoria   := .T.
	Local lNoFolder  := .F.
	Local lProperty  := .F.
	Private INCLUI   := .F.
	Private ALTERA   := .F.
	Private aTela    := {}
	Private aGets    := {}
	Private aHeader	 := {}
	Private aCols	 := {}
	Private oDlgLTMOV1
	Private oGetD


	nTotItem := 0
	nTotDivg := 0

	If INCLUI
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define e Registra os Campos do Enchoice                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( cAlias )
		RegToMemory( cAlias, INCLUI, .F. )

		dBSelectArea("SX3")
		SX3->( dBSetOrder( 1 ) )
		SX3->( dBGotop( ) )
		SX3->( dBSeek( cAlias ) )

		While ( !Eof() .And. SX3->X3_ARQUIVO==cAlias )
			If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" )
				if SX3->X3_VISUAL # "V"
					AADD( aCpoEnch, SX3->X3_CAMPO )
				Endif
			EndIf
			SX3->(dbSkip())
		Enddo
		aAlterEnch := aCpoEnch

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define aHeader do MsNewGetDados                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea("SX3")
		SX3->( dBSetOrder( 1 ) )
		SX3->( dBGotop( ) )
		SX3->( dBSeek( cALiasIT ) )
		While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
			If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL6_COD" )
				nUsado++
				Aadd(aHeader,{AllTrim(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_F3,;
					SX3->X3_CONTEXT,;
					SX3->X3_CBOX,;
					SX3->X3_RELACAO,;
					".T."})

				Aadd(aFldsNwGd, SX3->X3_CAMPO)

				If ( AllTrim(SX3->X3_CAMPO)== cItem )
					nPosItem := nUsado
				EndIf
			EndIf
			SX3->(dbSkip())
		Enddo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do aCols para utilizar no MsNewGetDados             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aCols,Array(nUsado+1))

		For nX := 1 To nUsado
			aCols[1][nX] := CriaVar(aHeader[nX][2])
		Next nX

		aCols[1][nUsado+1] := .F.
		aCols[1][nPosItem] := StrZero(1,TamSx3(cItem)[1])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos parâmetros para criação da tela de exibição     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize   := MsAdvSize()
		AAdd( aObjects, { 060, 060, .T., .f. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )
		AAdd( aObjects, { 010, 010, .T., .f. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]

		AADD(aBotoes, {"SDUPROP", {|| LTMOV1PLT() }, "Atualizar campo quantidade da plataforma", "Plataforma"})


		DEFINE MSDIALOG oDlgLTMOV1 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Campos do Cabeçalho                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/, ,oDlgLTMOV1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)

		@ nGetLin,aPosGet[1,1]  SAY "Total dos itens: " SIZE 050,09 PIXEL
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL
		@ nGetLin,aPosGet[1,3]  SAY "Divergência: " SIZE 050,09 PIXEL
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL

		oDlgLTMOV1:Cargo := {|n1,n2| oSAY1:SetText(n1), oSAY2:SetText(n2) }

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grid de Exibição                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,"U_LTMOV1LnOk" , "U_LTMOV1TdOk", "+" + cItem, aFldsNwGd, 000, 999,"U_LTMOV1Edt",,, oDlgLTMOV1, aHeader ,aCols )
		MOV001Rodap(@nTotItem,@nTotDivg)

		ACTIVATE MSDIALOG oDlgLTMOV1 ON INIT EnchoiceBar(oDlgLTMOV1,{|| IIF(LTMOV1TOK(), (oDlgLTMOV1:End(), nOpca := 1),)}, {|| nOpca := 0, oDlgLTMOV1:End()},,aBotoes)

		If nOpca == 1
			lAction := LTMOV1Grav( oGetD, nOpc )
		Else
			RollBackSX8()
		Endif

		if select(cAliasIT) > 0
			(cAliasIT)->( dBCloseArea( ) )
		endif

	ENDIF

return( lAction )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1Alt ºAutor  ³Rafael Parma        º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alteração do movimento.                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
	*---------------------------------------------*
User Function LTMOV1Alt( cAlias, nReg, nOpc )
	*---------------------------------------------*
	Local oSAY1
	Local oSAY2
	Local aArea      := GetArea()
	Local cAliasIT   := "ZL6"
	Local cItem      := "ZL6_SEQ"
	Local cNomePrd   := "ZL6_NOMPRD"
	Local bCampo     := {|nCPO| Field(nCPO) }
	Local aSize      := {}
	Local aObjects   := {}
	Local aInfo      := {}
	Local aPosObj    := {}
	Local aCpoEnch   := {}
	Local aAlterEnch := {}
	Local aFldsNwGd  := {}
	Local aBotoes    := {}
	Local nModelo    := 3
	Local nOpca      := 1
	Local nX         := 0
	Local nUsado	 := 0
	Local nPoZL5I    := 0
	Local nPosItem   := 0
	Local nP_NOMPRD  := 0
	Local nNumDec    := TamSX3("ZL5_TOTAL")[2]
	Local nOpcNewGd	 := if( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)
	Local lAction    := .F.
	Local lColumn    := .F.
	Local lF3        := .F.
	Local lMemoria   := .T.
	Local lNoFolder  := .F.
	Local lProperty  := .T.
	Local i
//Local lAction    := .T.
	Private INCLUI   := .F.
	Private ALTERA   := .T.
	Private aTela    := {}
	Private aGets    := {}
	Private aHeader	 := {}
	Private aCols	 := {}
	Private oGetD
	Private oDlgLTMOV1

	nTotItem := 0
	nTotDivg := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define e Registra os Campos do Enchoice                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( cAlias )
	RegToMemory( cAlias, ALTERA, .F. )

	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop( ) )
	SX3->( dBSeek( cAlias ) )

	While ( !Eof() .And. SX3->X3_ARQUIVO==cAlias )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" )
			if SX3->X3_VISUAL # "V"
				AADD( aCpoEnch, SX3->X3_CAMPO )
			Endif
		EndIf
		SX3->(dbSkip())
	Enddo
	aAlterEnch := aCpoEnch

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribui aos Campos registrados os valores do registro da tabela posicionado   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( cAlias )
	For i := 1 TO FCount()
		M->&(Eval( bCampo,i ) ) := FieldGet(i)
	Next i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define aHeader do MsNewGetDados                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop( ) )
	SX3->( dBSeek( cALiasIT ) )
	While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL6_COD" )
			nUsado++
			Aadd(aHeader,{AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO,;
				".T."})

			Aadd(aFldsNwGd, SX3->X3_CAMPO)

			If ( AllTrim(SX3->X3_CAMPO)== cItem )
				nPosItem := nUsado
			ElseIf  ( AllTrim(SX3->X3_CAMPO)== cNomePrd )
				nP_NOMPRD := nUsado
			Endif
		EndIf
		SX3->(dbSkip())
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( cALiasIT )
	(cALiasIT)->( dBSetOrder( 1 ) )
	(cALiasIT)->( dBGotop( ) )
	(cALiasIT)->( dBSeek( xFilial( cALiasIT ) + ZL5->ZL5_COD ) )
	While ( !(cALiasIT)->(  Eof( ) ) .And. ZL6->ZL6_FILIAL == xFilial( cALiasIT ) .And. ZL6->ZL6_COD == ZL5->ZL5_COD )
		If ( SoftLock( cALiasIT ) )
			aadd(aCols,Array(nUsado+1))
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V" )
					If !Empty( nPoZL5I := FieldPos(aHeader[nX][2] ) )
						aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL5I ) )
					EndIf
				Else
					aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
					aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL5I ) )
				EndIf
			Next
			aCols[Len(aCols)][nUsado+1] := .F.
		Else
			lTravas := .T.
		EndIf
		(cALiasIT)->(dBSkip())
	EndDo

	aSort( aCols , , , { |x,y| x[nP_NOMPRD] < y[nP_NOMPRD] } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize   := MsAdvSize()
	AAdd( aObjects, { 060, 060, .T., .f. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 010, 010, .T., .f. } )

	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
	nGetLin := aPosObj[3,1]

	AADD(aBotoes, {"SDUPROP", {|| LTMOV1PLT() }, "Atualizar campo quantidade da plataforma", "Plataforma"})

	DEFINE MSDIALOG oDlgLTMOV1 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos do Cabeçalho                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,,oDlgLTMOV1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)

	@ nGetLin,aPosGet[1,1]  SAY "Total dos itens: " SIZE 050,09 PIXEL
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL
	@ nGetLin,aPosGet[1,3]  SAY "Divergência: " SIZE 050,09 PIXEL
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL

	oDlgLTMOV1:Cargo := {|n1,n2| oSAY1:SetText(n1), oSAY2:SetText(n2) }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grid de Exibição                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd, "U_LTMOV1LnOk", "U_LTMOV1TdOk", "+" + cItem, aFldsNwGd, 000, len(aCols),"U_LTMOV1Edt",, , oDlgLTMOV1, aHeader ,aCols )
	MOV001Rodap(@nTotItem,@nTotDivg)

	ACTIVATE MSDIALOG oDlgLTMOV1 ON INIT EnchoiceBar(oDlgLTMOV1,{||IIF(LTMOV1TOK(), (oDlgLTMOV1:End(),nOpca := 1),)}, {|| nOpca := 0, oDlgLTMOV1:End()},,aBotoes)

	If nOpca == 1
		lAction := LTMOV1Grav( oGetD, nOpc )
	Else
		RollBackSX8()
	Endif

	RestArea(aArea)

	if select(cAliasIT) > 0
		(cAliasIT)->( dBCloseArea( ) )
	endif

return( lAction )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1Exc  ºAutor  ³Rafael Parma       º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclusão do movimento.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                             
	*---------------------------------------------*
User Function LTMOV1Exc( cAlias, nReg, nOpc )
	*---------------------------------------------*
	Local oSAY1
	Local oSAY2
	Local aArea      := GetArea()
	Local cAliasIT   := "ZL6"
	Local cItem      := "ZL6_SEQ"
	Local cNomePrd   := "ZL6_NOMPRD"
	Local bCampo     := {|nCPO| Field(nCPO) }
	Local aSize      := {}
	Local aObjects   := {}
	Local aInfo      := {}
	Local aPosObj    := {}
	Local aCpoEnch   := {}
	Local aAlterEnch := {}
	Local aFldsNwGd  := {}
	Local nModelo    := 3
	Local nOpca      := 1
	Local nX         := 0
	Local nUsado	 := 0
	Local nPoZL5I    := 0
	Local nPosItem   := 0
	Local nP_NOMPRD  := 0
	Local nNumDec    := TamSX3("ZL5_TOTAL")[2]
	Local nOpcNewGd	 := if( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)
	Local lAction    := .F.
	Local lColumn    := .F.
	Local lF3        := .F.
	Local lMemoria   := .T.
	Local lNoFolder  := .F.
	Local lProperty  := .T.
	Local i
//Local lAction    := .T.
	Private INCLUI   := .F.
	Private ALTERA   := .T.
	Private aTela    := {}
	Private aGets    := {}
	Private aHeader	 := {}
	Private aCols	 := {}
	Private oGetD
	Private oDlgLTMOV1

	nTotItem := 0
	nTotDivg := 0

	IF INCLUI
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define e Registra os Campos do Enchoice                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( cAlias )
		RegToMemory( cAlias, ALTERA, .F. )

		dBSelectArea("SX3")
		SX3->( dBSetOrder( 1 ) )
		SX3->( dBGotop( ) )
		SX3->( dBSeek( cAlias ) )

		While ( !Eof() .And. SX3->X3_ARQUIVO==cAlias )
			If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" )
				if SX3->X3_VISUAL # "V"
					AADD( aCpoEnch, SX3->X3_CAMPO )
				Endif
			EndIf
			SX3->(dbSkip())
		Enddo
		aAlterEnch := aCpoEnch

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atribui aos Campos registrados os valores do registro da tabela posicionado   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( cAlias )
		For i := 1 TO FCount()
			M->&(Eval( bCampo,i ) ) := FieldGet(i)
		Next i

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define aHeader do MsNewGetDados                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea("SX3")
		SX3->( dBSetOrder( 1 ) )
		SX3->( dBGotop(  ) )
		SX3->( dBSeek( cALiasIT ) )
		While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
			If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL6_COD" )
				nUsado++
				Aadd(aHeader,{AllTrim(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_F3,;
					SX3->X3_CONTEXT,;
					SX3->X3_CBOX,;
					SX3->X3_RELACAO,;
					".T."})

				Aadd(aFldsNwGd, SX3->X3_CAMPO)

				If ( AllTrim(SX3->X3_CAMPO)== cItem )
					nPosItem := nUsado
				ElseIf  ( AllTrim(SX3->X3_CAMPO)== cNomePrd )
					nP_NOMPRD := nUsado
				Endif
			EndIf
			SX3->(dbSkip())
		Enddo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( cALiasIT )
		(cALiasIT)->( dBSetOrder( 1 ) )
		(cALiasIT)->( dBGotop(  ) )
		(cALiasIT)->( dBSeek( xFilial( cALiasIT ) + ZL5->ZL5_COD ) )
		While ( !(cALiasIT)->(  Eof( ) ) .And. ZL6->ZL6_FILIAL == xFilial( cALiasIT ) .And. ZL6->ZL6_COD == ZL5->ZL5_COD )
			If ( SoftLock( cALiasIT ) )
				aadd(aCols,Array(nUsado+1))
				For nX := 1 To nUsado
					If ( aHeader[nX][10] != "V" )
						If !Empty( nPoZL5I := FieldPos(aHeader[nX][2] ) )
							aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL5I ) )
						EndIf
					Else
						aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
					EndIf
				Next
				aCols[Len(aCols)][nUsado+1] := .F.
			Else
				lTravas := .T.
			EndIf
			(cALiasIT)->(dBSkip())
		EndDo


		//--Validacao do período
		dbSelectArea("ZLC")
		dbSetOrder(1)
		If dbSeek( xFilial("ZLC")+(cValToChar(Year(M->ZL5_DATA))+STRZero(Month(M->ZL5_DATA),2)+"01") )
			If ZLC->ZLC_STATUS == "F"
				U_LTALL001("Atenção", "O período deste movimento esta fechado.","Verifique o cadastro de períodos.")
				Return
			EndIf
		Else
			U_LTALL001("Atenção", "Não existe período de movimento para lançamento.","Verifique o cadastro de períodos.")
			Return
		EndIf

		aSort( aCols , , , { |x,y| x[nP_NOMPRD] < y[nP_NOMPRD] } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos parâmetros para criação da tela de exibição     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize   := MsAdvSize()
		AAdd( aObjects, { 060, 060, .T., .f. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )
		AAdd( aObjects, { 010, 010, .T., .f. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]

		DEFINE MSDIALOG oDlgLTMOV1 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Campos do Cabeçalho                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlgLTMOV1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)

		@ nGetLin,aPosGet[1,1]  SAY "Total dos itens: " SIZE 050,09 PIXEL
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL
		@ nGetLin,aPosGet[1,3]  SAY "Divergência: " SIZE 050,09 PIXEL
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec) SIZE 050,09 OF oDlgLTMOV1 PIXEL

		oDlgLTMOV1:Cargo := {|n1,n2| oSAY1:SetText(n1), oSAY2:SetText(n2) }

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grid de Exibição                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,,,"+" + cItem, aFldsNwGd,000,999,,"",,oDlgLTMOV1,aHeader,aCols)

		MOV001Rodap(@nTotItem,@nTotDivg)

		ACTIVATE MSDIALOG oDlgLTMOV1 ON INIT EnchoiceBar(oDlgLTMOV1,{|| IIF(LTMOV1TOK(), (oDlgLTMOV1:End(),nOpca := 1),)}, {|| nOpca := 0, oDlgLTMOV1:End()})

		If nOpca == 1
			lAction := LTMOV1Grav( oGetD, nOpc )
		Else
			RollBackSX8()
		Endif

		RestArea(aArea)

		if select(cAliasIT) > 0
			(cAliasIT)->( dBCloseArea( ) )
		endif
	ENDIF
return( lAction )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1LnOk  ºAutor  ³Rafael Parma      º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Validação da linha do MsNewGetDados               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*-------------------------*
User Function LTMOV1LnOk()
	*-------------------------*
	Local lRet			:= .T.
	Local nPosPrd		:= aScan(aHeader,{|x| AllTrim(x[2])=="ZL6_PRODUT"})
	Local nPosLoj		:= aScan(aHeader,{|x| AllTrim(x[2])=="ZL6_LOJPRD"})
	Local nPosAmt		:= aScan(aHeader,{|x| AllTrim(x[2])=="ZL6_AMOSTR"})
	Local nPosQde		:= aScan(aHeader,{|x| AllTrim(x[2])=="ZL6_QTDE"})
	Local nPosPla		:= aScan(aHeader,{|x| AllTrim(x[2])=="ZL6_PLACA"})
	Local nPosSeq		:= aScan(aHeader,{|x| AllTrim(x[2])=="ZL6_SEQZL7"})
//Local nMaxFor		:= Len(aCols)
	Local nI
	Local nUsado		:= Len(aHeader)
	Local lTestaDel 	:= nUsado <> Len(aCols[1])
	Local nTOTAL_ITENS	:= 0
	Local cProdvld 		:= ""

	For nI := 1 to Len(aCols)
		If !aCols[n][nUsado+1] .and. !aCols[nI][nUsado+1]
			If n != nI .and. aCols[nI,nPosPrd] == aCols[n,nPosPrd] .and. aCols[nI,nPosLoj] == aCols[n,nPosLoj] ;
					.and. aCols[nI,nPosAmt] == aCols[n,nPosAmt] .and. aCols[nI,nPosQde] == aCols[n,nPosQde]
				Aviso("Aviso","Os dados do produtor "+aCols[n,nPosPrd]+", loja: "+aCols[n,nPosLoj]+", amostra: "+ALLTRIM(aCols[n,nPosAmt])+" e quantidade: "+cValToChar(aCols[n,nPosQde])+" já foram lançados neste movimento.",{"OK"})
				lRet := .F.
			EndIf
		EndIf
	Next nI
	If lRet
		IF Empty(POSICIONE( "SA2",1, XFILIAL( "SA2" ) + aCols[n,nPosPrd] + aCols[n,nPosLoj], "SA2->A2_NOME"))
			U_LTALL001("Atenção", "O Produtor/Loja "+aCols[n,nPosPrd]+",/"+aCols[n,nPosLoj]+" não existe, verifique o cadastro!")
			lRet := .F.
		Elseif POSICIONE( "SA2",1, XFILIAL( "SA2" ) + aCols[n,nPosPrd] + aCols[n,nPosLoj], "SA2->A2_MSBLQL") == "1"
			U_LTALL001("Atenção", "O Produtor/Loja "+aCols[n,nPosPrd]+",/"+aCols[n,nPosLoj]+" está bloqueado para uso, verifique o cadastro!")
			lRet := .F.
		EndIf
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Não aceita item sem informação de PLACA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lRet
		If !aCols[n][nUsado+1] .AND. EMPTY(aCols[n][nPosPla])
			U_LTALL001("Atenção", "Não foi informado à Placa referente à este item do Mov. Produtor.","É obrigatório que seja informado à placa do veículo vinculada ao transporte da quantidade deste item.")
			lRet := .F.
		EndIf
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³vALIDA SEQUENCIAL DA ZL7³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lRet
		If !aCols[n][nUsado+1] .AND. EMPTY(aCols[n][nPosSeq])
			U_LTALL001("Atenção", "O Sequencial informado não existe no Mov. de Transportador.","É obrigatório que seja informado um sequencial existente")
			lRet := .F.

		EndIf
	EndIf





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função, para atualização do rodapé da interface³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	MOV001Rodap()

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1TdOk  ºAutor  ³Rafael Parma        º Data ³  05/10/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Validação se tudo esta correto no MsNewGetDados   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                         
	*-------------------------*
User Function LTMOV1TdOk()
	*-------------------------*
	Local lRet  := .T.
	Local nTOTAL_ITENS := 0
	Public cParc := ""

	If (M->ZL5_PLATF == NIL)
		U_LTALL001("Atenção", "Impossível incluir este movimento, pois o movimento do transportador não existe!","Favor efetuar o movimento do transportador para esta linha e dada.")
		lRet  := .F.
	EndIf

	If lRet
		MOV001Rodap(@nTOTAL_ITENS)
		If M->ZL5_TOTAL != nTOTAL_ITENS
			U_LTALL001("Atenção", "O total dos itens não é igual ao total do cabeçalho!","Verifique o total dos itens com o total da coleta informado no cabeçalho.")
			cParc := "P"
			//lRet  := .F.
		EndIf
	EndIf

	//--Validacao do período
	If lRet
		dbSelectArea("ZLC")
		dbSetOrder(1)
		If dbSeek( xFilial("ZLC")+(cValToChar(Year(M->ZL5_DATA))+STRZero(Month(M->ZL5_DATA),2)+"01") )
			If ZLC->ZLC_STATUS == "F"
				U_LTALL001("Atenção", "O período deste movimento esta fechado.","Verifique o cadastro de períodos.")
				lRet := .F.
			EndIf
		Else
			U_LTALL001("Atenção", "Não existe período de movimento para lançamento.","Verifique o cadastro de períodos.")
			lRet := .F.
		EndIf
	EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1Grav  ºAutor  ³Rafael Parma        º Data ³  05/10/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Gravação de Dados.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	*-----------------------------------------*
Static Function LTMOV1Grav( poGet, pnOpc )
	*-----------------------------------------*
	Local aCols    		:= poGet:aCols
	Local aHeader  		:= poGet:aHeader
	Local cNumCod  		:= M->ZL5_COD
//Local cCodigo  		:= ""
//Local cCampo   		:= ""
	Local cItem    		:= "ZL6_SEQ"
	Local cMay     		:= "ZL5" + xFilial("ZL5") + cNumCod
	Local nUsado  		:= Len(aHeader)
	Local nLenGet  		:= Len(aCols)
	Local nPoZL5I  		:= 0
//Local nItem    		:= 0  
	Local nCont   		:= 0
	Local nQts     		:= 0
	Local nPosItem	 	:= aScan(aHeader,{ |x| ALLTRIM(x[2]) == cItem})
	Local nPosAmos 		:= aScan(aHeader,{ |x| ALLTRIM(x[2]) == "ZL6_AMOSTR"})
	Local nY, nI, nX
/*Local nPosProd 		:= aScan(aHeader,{ |x| ALLTRIM(x[2]) == "ZL6_PRODUT"}) 
Local nPosLoja 		:= aScan(aHeader,{ |x| ALLTRIM(x[2]) == "ZL6_LOJPRD"}) 

Local bCampo   		:= {|nCPO| Field(nCPO)}*/
Local lGravou  		:= .F.
Local lGoGrava 		:= .T.
Local lATUANALCPO	:= SuperGetMV("MV_ZLATAC",,.F.)                         

CursorWait()  
SysRefresh()

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras quando trata-se de EXCLUSÃO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case pnOpc == 3 .Or. pnOpc == 4
        If pnOpc == 3
		 	dbSelectArea("ZL5")
		 	ZL5->(dbSetOrder(1))
		   	While ( MsSeek( xFilial( "ZL5" ) + cNumCod ) .OR. !MayIUseCode( cMay ) ) //SUA
			     cNumCod := Soma1( cNumCod,Len( cNumCod ) )
			     cMay 	:= "ZL5" + xFilial("ZL5") + cNumCod
		    EndDo
		    M->ZL5_COD := cNumCod
        Endif
        
		BEGIN TRANSACTION
		      // Gravação do Enchoice
	          dBSelectArea("ZL5")
	          ZL5->( dBSetOrder( 1 ) )
	          //
	          If ( pnOpc == 3 )
	             RECLOCK("ZL5",.T.)
	          Else
	          	
	          	 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				 //³Executa função de integração com o MilkUp³
				 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				 //LTMOV1MLKUP(ZL5->ZL5_COD, 5)
	             
	             RECLOCK("ZL5",.F.)
	          Endif
	          //
	          For nI := 1 To FCount()
		          If U_LTALLXSX3( FieldName(nI) )[3] == "C" .And. alltrim(FieldName(nI)) <> "ZL5_FILIAL"
		             cResult := U_LTALLXACE ( M->&(FieldName( nI ) ) )// remove os acentos...
		          Else
		             cResult := M->&(FieldName( nI ) )
		          Endif
		          M->&(FieldName( nI ) ) := cResult
		          
		          If ( FieldName(nI) == "ZL5_FILIAL" )
                     FieldPut( nI, xFilial( "ZL5" ) )
                  ElseIf ( FieldName(nI) == "ZL5_X_PARC" )
                     FieldPut( nI, cParc )
                  Else
                     FieldPut( nI, M->&(FieldName( nI ) ) )
                  Endif

	          Next

		      For nY := 1 To nLenGet
		          If ( !aCols[nY][nUsado+1] )
		             nQts++
		          Endif
		      Next                  
             
              if lGoGrava
		         // Gravação do aCols
		         For nX := 1 To nLenGet
			         If !aCols[nX][nUsado+1]
				        dBSelectArea("ZL6")
				        ZL6->(dBSetOrder(1))
				        ZL6->(dBGotop())
				        If (ZL6->(dBSeek(xFilial("ZL6") + M->ZL5_COD + aCols[nX][nPosItem])))
					       RECLOCK("ZL6", .F.)
				        Else
					       RECLOCK("ZL6",.T.)
				        EndIf
				          
				        For nY := 1 To nUsado
					        If aHeader[nY][10] != "V"
						       If !Empty(nPoZL5I := FieldPos( aHeader[nY][2]))  						
  						          ZL6->(FieldPut(nPoZL5I, aCols[nX][nY]))
			  			       EndIf 							
					        EndIf
				        Next nY
				     
				        nCont++
				     
				        ZL6->ZL6_FILIAL := xFilial("ZL6")				        
				        ZL6->ZL6_COD    := M->ZL5_COD
				        ZL6->ZL6_DTCOL	:= IIF(!EMPTY(ZL6->ZL6_DTCOL), ZL6->ZL6_DTCOL, M->ZL5_DATA)
				        
				        //-- Atualiza analises a campo
				        If lATUANALCPO .and. !Empty(aCols[nX][nPosAmos])
				        	aAreaTMP := GetArea()
				        	dbSelectArea("ZLA")
				        	dbSetOrder(5)	//ZLA_FILIAL+ZLA_NUMERO+ZLA_PRODUT+ZLA_LOJPRD+DTOC(ZLA_DATA)
				        	dbGoTop()
				        	lFound := .F.
				        	If dbSeek( xFilial("ZLA") + aCols[nX][nPosAmos] + ZL6->ZL6_PRODUT + ZL6->ZL6_LOJPRD + DTOS(ZL5->ZL5_DATA) )
				        		lFound := .T.
				        	EndIf
				        	If !lFound
				        		If RECLOCK("ZLA", .T.)
				        			ZLA->ZLA_FILIAL := xFilial("ZLA")
				        			ZLA->ZLA_NUMERO := ZL6->ZL6_AMOSTR
				        			ZLA->ZLA_PRODUT := ZL6->ZL6_PRODUT
				        			ZLA->ZLA_LOJPRD := ZL6->ZL6_LOJPRD
				        			ZLA->ZLA_NOMPRD := ZL6->ZL6_NOMPRD				        			
				        			ZLA->ZLA_QTDE   := ZL6->ZL6_QTDE  
				        			ZLA->ZLA_LINHA  := ZL5->ZL5_LINHA
				        			ZLA->ZLA_DATA   := ZL5->ZL5_DATA 
				        			ZLA->(MSUNLOCK())
				        		EndIf
				        	EndIf
				        	RestArea(aAreaTMP)
				        EndIf
       				 
			         Else
				        dBSelectArea("ZL6")
				        ZL6->(dBSetOrder(1))
				        ZL6->(dBGotop())
				        If ZL6->(dBSeek(xFilial("ZL6") + M->ZL5_COD + aCols[nX][nPosItem]))
					       RECLOCK("ZL6")
					       ZL6->(DBDELETE())
				        EndIf
			         EndIf
		         Next nX
	          Endif
	          
	          ZL5->(MSUNLOCK())
	          
	          If lGoGrava
	             ZL6->(MSUNLOCK())
	          EndIf
	          
	          FreeUsedCode() 
	          
	          lGravou := .T.
	          
	          If lGravou
			     EvalTrigger()
			     ConfirmSx8()
			  EndIf    
		END TRANSACTION
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de integração com o MilkUp³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
		If pnOpc == 3 
			LTMOV1MLKUP(ZL5->ZL5_COD, 3)
		else
			LTMOV1MLKUP(ZL5->ZL5_COD, 4)
		EndIf
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras quando trata-se de EXCLUSÃO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	OtherWise
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras de exclusão do MOV. PRODUTOR na base de dados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	    BEGIN TRANSACTION
	          
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de integração com o MilkUp³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dBSelectArea("ZL5")
			If LTMOV1MLKUP(ZL5->ZL5_COD, pnOpc)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Após processar integração com sucesso, excluir os registros do Mov. Produtor³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				RECLOCK("ZL5")
					ZL5->(dBDelete())
					If Len(aCols) > 0 
						For nX := 1 To Len(aCols)
							dBSelectArea("ZL6")
							ZL6->(dBSetOrder(1))
							ZL6->(dBGotop())
							If (ZL6->(dBSeek(xFilial("ZL6") + ZL5->ZL5_COD + aCols[nX][nPosItem])))
								RECLOCK("ZL6")
									ZL6->(DBDELETE())
								ZL6->(MSUNLOCK())
							EndIf
						Next nX
					EndIf
				ZL5->(MSUNLOCK())
			EndIf
		END TRANSACTION
		lGravou := .T.

ENDCASE

CursorArrow()
SysRefresh()

Return lGravou





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MOV001Rodap³ Autor ³ Rafael Parma          ³ Data ³12.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para preenchimento do Rodape.                        ³±±  
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MOV001Rodap(nTotItem, nTotDivg)

Local aCols		:= IIF(Type("oGetD") == "O", oGetD:aCols, aCols)
Local aHeader	:= IIF(Type("oGetD") == "O", oGetD:aHeader, aHeader)
Local nTotal    := 0
Local nDivg     := 0
Local nPosQtde  := aScan(aHeader, {|x| ALLTRIM(x[2]) == "ZL6_QTDE"})
Local nI
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso nao seja passado o objeto da getdados deve-se pegar a janela default³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If ( oGetDad == Nil )
		oDlg := GetWndDefault()
		If ( ValType(oDlg:Cargo)<>"B" )
			oDlg := oDlg:oWnd
		EndIf
	Else
		oDlg := oGetDad:oWnd
	EndIf    
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma as variaveis do Rodape                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 To Len(aCols)
		If !aCols[nI][Len(aHeader) + 1]
			nTotal += aCols[nI][nPosQtde]
		EndIf
	Next nI

	nDivg := nTotal - M->ZL5_TOTAL

	If nTotItem != nil
		nTotItem := nTotal
		nTotDivg := nDivg
	EndIf

	If ValType(oDlgLTMOV1) == "O"
		If ( ValType(oDlgLTMOV1:Cargo)=="B" )
			Eval(oDlgLTMOV1:Cargo,nTotal,nDivg)
		EndIf
	Endif

Return .T.


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³LTMOV1PLT  ³ Autor ³ Rafael Parma          ³ Data ³25.02.10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Função responsável por atualizar o campo quantidade da      ³±±
	±±º          ³plataforma de acordo com o movimento do transportador.      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ LTMOV001                                                   º±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
	*--------------------------*
Static Function LTMOV1PLT()
	*--------------------------*
	Local cAliasTMP := GetNextAlias()
	Local hEnter    := CHR(13) + CHR(10)

	If ! Empty (M->ZL5_DATA) .AND. ! Empty(M->ZL5_LINHA) .AND. ! Empty(M->ZL5_TRANSP)

		// alimenta a quanditade da vazão do transportador na data e linha
		cQuery := "	SELECT SUM(ZL7_QTDVAZ) ZL7_QTDVAZ						" + hEnter
		cQuery += "	FROM " + RetSQLName("ZL7") + " ZL7 						" + hEnter
		cQuery += " WHERE 													" + hEnter
		cQuery += " ZL7.ZL7_FILIAL 		= '" + xFilial("ZL7")    + "'   	" + hEnter
		cQuery += " AND ZL7.ZL7_DATA    = '" + dtos(M->ZL5_DATA) + "'   	" + hEnter
		cQuery += " AND ZL7.ZL7_TRANSP  = '" + M->ZL5_TRANSP     + "'		" + hEnter
		cQuery += " AND ZL7.ZL7_LINHA   = '" + M->ZL5_LINHA      + "'   	" + hEnter
		cQuery += " AND ZL7.ZL7_TPROD  != 'O'								" + hEnter
		cQuery += " AND ZL7.D_E_L_E_T_ != '*'								" + hEnter

		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		If ! Empty ( (cAliasTMP)->ZL7_QTDVAZ )
			M->ZL5_PLATF := (cAliasTMP)->ZL7_QTDVAZ
		Else
			M->ZL5_PLATF := 0
		EndIf
		(cAliasTMP)->(dbCloseArea())

	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1MLKUP  ºAutor  ³Marcelo Joner     º Data ³ 03/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução das regras e demais funçõesº±±
±±º          ³de integração do Mov. Produtor com o MilkUp.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Laticinios Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTMOV1MLKUP(cMovPrd, nOper)

	Local lRet		:= .T.
	Local aArea		:= GetArea()
	Local cAliasTMP := GetNextAlias()
	Local aHeader		:= {}
	Local hEnter    := CHR(13) + CHR(10)
	Local cToken		:= ALLTRIM(GETMV("MV_ZL00007",, ""))
	Local cParam		:= "api_key=" + cToken
	Local cUrl			:= "https://api.milkup.com.br/sync"
//Local oRetJSON

	Local oRestClient
	Default cMovPrd	:= ""
	Default nOper	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras, caso o código do Mov. Produtor seja informado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !EMPTY(cMovPrd)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Posiciona no cabeçalho do Mov. Produtor - ZL5³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("ZL5")
		ZL5->(dbSetOrder(1))
		ZL5->(dbGoTop())
		If ZL5->(dbSeek(xFilial("ZL5") + cMovPrd))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza o processamento dos itens do Mov. Produtor - ZL6³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			// alimenta a quanditade da vazão do transportador na data e linha
			cQuery := "	SELECT *, ZL6.D_E_L_E_T_ AS ZL6_DEL						" + hEnter
			cQuery += "	FROM " + RetSQLName("ZL6") + " ZL6 						" + hEnter
			cQuery += " WHERE 													" + hEnter
			cQuery += " ZL6.ZL6_FILIAL 		= '" + xFilial("ZL6")    + "'   	" + hEnter
			cQuery += " AND ZL6.ZL6_COD    = '" + ZL5->ZL5_COD + "'   			" + hEnter
			cQuery += " ORDER BY ZL6_SEQ 										" + hEnter

			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())

			While (cAliasTMP)->(!EOF())

				If (cAliasTMP)->ZL6_DEL == '*'
					If !Empty((cAliasTMP)->ZL6_MKUID) .AND. !EMPTY(cToken)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Cria objeto da clase FWRest para executar integração³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						oRestClient	:= FWRest():New(cUrl)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Executa regras de exclusão, caso o Mov. Produtor excluído esteja integrado com o MilkUp³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

						cId := (cAliasTMP)->ZL6_MKUID

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Seta parâmetros de execução da integração³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						oRestClient:SetPath("/coletas/" + cId + "?" + cParam)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Composição do aHeader³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						AADD(aHeader, "Content-Type: application/json")

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Executra PUT e avalia retorno (sucesso\insucesso)³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If !oRestClient:Delete(aHeader)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Obtém o retorno da API e converte em JSON³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Apresenta mensagem ao usuário alertando em tonro da questão e não permite à inclusão do Fornecedor³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração da coleta do produtor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
							Alert(cRetJSON)

							lRet := .F.
						EndIf

					EndIf
				Else
					dbSelectArea("ZL6")
					ZL6->(dbSetOrder(2))
					ZL6->(dbGoTop())
					If ZL6->(dbSeek(xFilial("ZL6") + (cAliasTMP)->ZL6_COD + (cAliasTMP)->ZL6_PRODUT + (cAliasTMP)->ZL6_LOJPRD))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Executa função de integração com o MILKUP³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If ZL6->ZL6_IDMOB == 1
							If !Empty(ZL6->ZL6_MKUID)
								If !U_MLKUPZL6(4)
									lRet := .F.
									exit
								EndIf
							Else
								If !U_MLKUPZL6(3)
									lRet := .F.
									exit
								EndIf
							EndIf						
						EndIf
						ZL6->(dbSkip())
					EndIf
				EndIf
				(cAliasTMP)->(dbSkip())
			End Do

			(cAliasTMP)->(dbCloseArea())

		EndIf
	EndIf

	RestArea(aArea)

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1TOK  ºAutor  ³Marcelo Joner       º Data ³ 25/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela validação geral da interface do Mov.º±±
±±º          ³Produtor quando da inclusão\alteração.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTMOV1TOK()

	Local lRet			:= .T.
	Local nTotItem		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras quando é INCLUSÃO\ALTERAÇÃO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If INCLUI .OR. ALTERA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Valida informações do cabeçalho do Mov. Produtor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !Obrigatorio(aGets,aTela)
			Return .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Valida informações do grid de itens do Mov. Produtor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !oGetd:TudoOk()
			Return .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Sendo ALTERAÇÃO, executa função de vinculo dos Mov. Transportador à serem ajustados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ALTERA

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de recalculo do rodapé da interface³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			MOV001Rodap(@nTotItem)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de validação em relação aos Mov. Transp. existentes³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			lRet := LTMOV1MTRP(nTotItem)
		EndIf
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1MTRP  ºAutor  ³Marcelo Joner      º Data ³ 25/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por disponibilizar regras de vinculo de  º±±
±±º          ³Mov. Transportador ao Mov. Produtor manipulado.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTMOV1MTRP(nQtdMov)

	Local lRet			:= .T.
	Local lShare		:= .T.
	Local lReadOnly		:= .F.
	Local cCadOld		:= cCadastro
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aPosObj		:= {}
	Local nX, nI
//Local aDetQld		:= {}
	Local aStruct		:= ZL7->(dbStruct())
	Local aCols			:= IIF(Type("oGetD") == "O", oGetD:aCols, aCols)
	Local aHeader		:= IIF(Type("oGetD") == "O", oGetD:aHeader, aHeader)
	Local aVwZL7  		:= {{"ZL7_COD"		, "", "Código"		 , U_LTALLXSX3("ZL7_COD")[6]	},;
		{"ZL7_DATA"		, "", "Data"		 , U_LTALLXSX3("ZL7_DATA")[6]	},;
		{"ZL7_HORA"		, "", "Hora"		 , U_LTALLXSX3("ZL7_HORA")[6]	},;
		{"ZL7_NUMPES"	, "", "Pesagem"		 , U_LTALLXSX3("ZL7_NUMPES")[6]	},;
		{"ZL7_PLACA"	, "", "Placa"		 , U_LTALLXSX3("ZL7_PLACA")[6]	},;
		{"ZL7_SEQ"		, "", "Sequencia"	 , U_LTALLXSX3("ZL7_SEQ")[6]	},;
		{"ZL7_LINHA"	, "", "Linha"		 , U_LTALLXSX3("ZL7_LINHA")[6]	},;
		{"ZL7_NOMLIN"	, "", "Descrição"	 , U_LTALLXSX3("ZL7_NOMLIN")[6]	},;
		{"ZL7_QTDTRP"	, "", "Qtd. Transp." , U_LTALLXSX3("ZL7_QTDTRP")[6]	},;
		{"ZL7_QTDVAZ"	, "", "Qtd. Vazão"	 , U_LTALLXSX3("ZL7_QTDVAZ")[6]	},;
		{"ZL7_QTDSOB"	, "", "Qtd. Sobra"	 , U_LTALLXSX3("ZL7_QTDSOB")[6]	},;
		{"ZL7_QTDFAL"	, "", "Qtd. Falta"	 , U_LTALLXSX3("ZL7_QTDFAL")[6]	},;
		{"ZL7_QTDANT"	, "", "Qtd. Desconto", U_LTALLXSX3("ZL7_QTDANT")[6]	}}

	Local nOpcao		:= 2
	Local nQtdVaz		:= 0
	Local nPosQtd  		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "ZL6_QTDE"})
	Local nPosPlaca		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "ZL6_PLACA"})
	Local nPosSeq		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == "ZL6_SEQZL7"})

	Private nQtdSld		:= 0
	Private nQtdPrd		:= nQtdMov
	Private lSobra		:= .T.
	Private lInverte	:= .F.
	Private cMarca		:= GetMark()
	Private cAliasZL7	:= GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa consulta SQL de busca dos MOV. TRANSPORTADOR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cQuery := "SELECT ZL7.*												" + CRLF
	cQuery += "FROM " + RetSQLName("ZL7") + " ZL7						" + CRLF
	cQuery += "WHERE ZL7.ZL7_FILIAL  = '" + xFilial("ZL7")      + "'	" + CRLF
	cQuery += "  AND ZL7.ZL7_LINHA   = '" + M->ZL5_LINHA        + "'	" + CRLF
	cQuery += "  AND ZL7.ZL7_TRANSP  = '" + M->ZL5_TRANSP       + "'	" + CRLF
	cQuery += "  AND ZL7.ZL7_DATA    = '" + DTOS(M->ZL5_DATA)   + "'	" + CRLF
	cQuery += "  AND ZL7.D_E_L_E_T_ <> '*'								" + CRLF

	cQuery += "ORDER BY ZL7_FILIAL, ZL7_DATA, ZL7_HORA, ZL7_COD			" + CRLF

	cArqTrab  := CriaTrab(aStruct, .T. )

	If Select(cAliasZL7) > 0
		(cAliasZL7)->(dbCloseArea())
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZL7,.T.,.T.)
	For nX := 1 To len(aStruct)
		If aStruct[nX][2] <> "C" .And. FieldPos(aStruct[nX][1])<>0
			TcSetField(cAliasZL7,aStruct[nX][1],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4])
		EndIf
	Next nX

	Copy TO &cArqTrab
	dBCloseArea()
	dBUseArea( .T.,, cArqTrab, cAliasZL7, lShare, lReadOnly)
	(cAliasZL7)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Processa todos os itens da ZL7 localizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	While (cAliasZL7)->(!EOF())
		nQtdVaz += (((cAliasZL7)->ZL7_QTDVAZ + (cAliasZL7)->ZL7_QTDFAL) - (cAliasZL7)->ZL7_QTDSOB)
		(cAliasZL7)->(dbSkip())
	End
	(cAliasZL7)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calcula o saldo à partir da Qtd. Transp. e Qtd. Prod.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nQtdSld := nQtdVaz - nQtdPrd
	lSobra  := nQtdSld > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Apresenta interface ao usuário, caso exista diferença entre o Mov. Prod. e Mov. Transportador³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If nQtdSld != 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Altera o título da rotina para correta apresentação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cCadastro := "Mov. Transportador - Vinculados"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Havendo apenas 1 Mov. Transportador vinculado, já atribui à diferença ao mesmo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		While (cAliasZL7)->(!EOF())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Obtém à quantidade total de itens do Mov. Produtor para à Placa do Mov. Transportador atual³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nQuant := 0
			For nI := 1 To Len(aCols)
				If !aCols[nI][Len(aHeader) + 1] .AND. aCols[nI][nPosPlaca] == (cAliasZL7)->ZL7_PLACA .AND. aCols[nI][nPosSeq] == (cAliasZL7)->ZL7_SEQ
					nQuant += aCols[nI][nPosQtd]
				EndIf
			Next nI

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calcula à Qtd. Diferenção considerando à Qtd. Vazão - Qtd. Mov. Produtor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nQtdDif := (cAliasZL7)->ZL7_QTDVAZ - nQuant

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza ajuste do Mov. Transportador conforme à quantidade obtida no Mov. Produtor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RECLOCK(cAliasZL7, .F.)
			(cAliasZL7)->ZL7_QTDTRP := nQuant

			If nQtdDif >= 0
				(cAliasZL7)->ZL7_QTDSOB := ABS(nQtdDif)
				(cAliasZL7)->ZL7_QTDFAL := 0
			Else
				(cAliasZL7)->ZL7_QTDSOB := 0
				(cAliasZL7)->ZL7_QTDFAL := ABS(nQtdDif)
			EndIf
			(cAliasZL7)->(MSUNLOCK())

			(cAliasZL7)->(dbSkip())
		End
		(cAliasZL7)->(dbGoTop())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Calcula dimensão da interface\componentes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		aSize := MsAdvSize()
		aSize[5] -= 100
		aSize[7] := 200

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Montagem dos parâmetros para criação da tela de exibição³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		AAdd(aObjects, {100, 100, .T., .F.})
		aInfo := {aSize[1], aSize[2], aSize[3] / 2, aSize[4] / 2, 2, 2}
		aPosObj := MsObjSize(aInfo, aObjects, .T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta dialog e demais componentes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oDlgZL7 := MSDialog():New(aSize[7],0,aSize[6],(aSize[5]/1.2), cCadastro,,,.F.,,,,,,.T.,,,.T. )
		oDlgZL7:bInit := {|| ENCHOICEBAR(oDlgZL7, {|| (nOpcao := 1, oDlgZL7:End())}, {|| (nOpcao := 2, oDlgZL7:End())}, .F., {})}
		oBrwTrp := MsSelect():New(cAliasZL7,"","",aVwZL7,@lInverte,@cMarca,{aPosObj[1,1],aPosObj[1,2],(oDlgZL7:nClientHeight/2)-14, (oDlgZL7:nClientWidth/2)-5},,,oDlgZL7)
		oDlgZL7:Activate(,,,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso confirmou à interface, efetua atualização das informações³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If nOpcao == 1
			BEGIN TRANSACTION

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa laço para atualização de todos os itens da tabela temporária de Mov. Transportador³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				dbSelectArea(cAliasZL7)
				(cAliasZL7)->(dbGoTop())
				While (cAliasZL7)->(!EOF())

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Atualiza informações no registro do Mov. Transportador³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					dbSelectArea("ZL7")
					ZL7->(dbSetOrder(1))
					ZL7->(dbGoTop())
					If ZL7->(dbSeek(xFilial("ZL7") + (cAliasZL7)->ZL7_COD))
						RECLOCK("ZL7", .F.)
						ZL7->ZL7_QTDTRP := (cAliasZL7)->ZL7_QTDTRP
						ZL7->ZL7_QTDSOB := (cAliasZL7)->ZL7_QTDSOB
						ZL7->ZL7_QTDFAL := (cAliasZL7)->ZL7_QTDFAL
						ZL7->(MSUNLOCK())

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso exista Pesagem vinculada ao Mov. Transportador, atualiza conciliação da mesma³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If !EMPTY(ZL7->ZL7_NUMPES)
							dbSelectArea("ZM1")
							ZM1->(dbSetOrder(1))
							ZM1->(dbGoTop())
							If ZM1->(dbSeek(xFilial("ZM1") + ZL7->ZL7_NUMPES))

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Soma à Qtd. Transportada de todos os Mov. Transportador vinculados há Pesagem³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								nQtdTrp := 0
								dbSelectArea("ZL7")
								ZL7->(dbSetOrder(4))
								ZL7->(dbGoTop())
								If ZL7->(dbSeek(xFilial("ZL7") + ZM1->ZM1_NUM))
									While ZL7->(!EOF()) .AND. ZL7->ZL7_FILIAL == xFilial("ZL7") .AND. ZL7->ZL7_NUMPES == ZM1->ZM1_NUM
										nQtdTrp += ZL7->ZL7_QTDTRP
										ZL7->(dbSkip())
									End
								End

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Atualiza à conciliação da Pesagem caso esteja finalizada³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								RECLOCK("ZM1", .F.)
								ZM1->ZM1_LTMOV := nQtdTrp
								ZM1->ZM1_LTDIF := ZM1->ZM1_LTBRT - nQtdTrp
								ZM1->(MSUNLOCK())
							EndIf
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Avança para o próximo registro da tabela temporária³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					(cAliasZL7)->(dbSkip())
				End

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Atualiza o Mov. Produtor em relação à Qtd. Transportada do Mov. Transportador³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cParc := ""
				M->ZL5_TOTAL := nQtdPrd

			END TRANSACTION
		Else
			lRet := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Restaura o título original da rotina³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cCadastro := cCadOld
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV1EDT  ºAutor  ³Marcelo Joner       º Data ³ 26/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação executada quando da edição dos campos doº±±
±±º          ³grid de itens do Mov. Produtor.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV1EDT()

	Local lRet		:= .T.
	Local cCpoEdt	:= ALLTRIM(ReadVar())

	Do Case

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa validação quando trata-se de edição da PLACA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case "ZL6_PLACA" $ cCpoEdt
		If !EMPTY(M->ZL6_PLACA)
			cQuery := "SELECT COUNT(*) TOTAL								" + CRLF
			cQuery += "FROM " + RetSQLName("ZL7") + " ZL7					" + CRLF
			cQuery += "WHERE ZL7.ZL7_FILIAL  = '" + xFilial("ZL7")    + "'	" + CRLF
			cQuery += "  AND ZL7.ZL7_TRANSP  = '" + M->ZL5_TRANSP     + "'	" + CRLF
			cQuery += "  AND ZL7.ZL7_LINHA   = '" + M->ZL5_LINHA      + "'	" + CRLF
			cQuery += "  AND ZL7.ZL7_PLACA   = '" + M->ZL6_PLACA 	  + "'	" + CRLF
			cQuery += "  AND ZL7.ZL7_DATA    = '" + DTOS(M->ZL5_DATA) + "'	" + CRLF
			cQuery += "  AND ZL7.D_E_L_E_T_ <> '*'							" + CRLF

			cAliasTMP := GetNextAlias()

			If Select(cAliasTMP) > 0
				(cAliasTMP)->(dbCloseArea())
			EndIf

			dBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)

			If (cAliasTMP)->TOTAL == 0
				U_LTALL001("Atenção", "Não existe Mov. Transportador para à data, linha, transportador e  placa  informada.","Favor providenciar à inclusão de Mov. Transportador referente à Placa e Mov. Produtor manipulados.")
				lRet := .F.
			EndIf
		EndIf

	EndCase

Return lRet

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³LTMOV1PLT  ³ Autor ³ Rafael Parma          ³ Data ³25.02.10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Função responsável por atualizar o campo quantidade da      ³±±
	±±º          ³plataforma de acordo com o movimento do transportador.      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ LTMOV001                                                   º±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
	*--------------------------*
User Function LTMV1PLT1()
	*--------------------------*
	Local cAliasTMP := GetNextAlias()
	Local cAliasTMP2 := GetNextAlias()
	Local hEnter    := CHR(13) + CHR(10)
/*Local cData 	:= ZL5->ZL5_DATA
Local cLinha  	:= ZL5->ZL5_LINHA
Local cTransp 	:= ZL5->ZL5_TRANSP*/
Local cCODMOV	:= ZL5->ZL5_COD
    
    If ! Empty (ZL5->ZL5_DATA) .AND. ! Empty(ZL5->ZL5_LINHA) .AND. ! Empty(ZL5->ZL5_TRANSP)

		// alimenta a quanditade da vazão do transportador na data e linha
		cQuery := "	SELECT SUM(ZL7_QTDVAZ) ZL7_QTDVAZ						" + hEnter
		cQuery += "	FROM " + RetSQLName("ZL7") + " ZL7 						" + hEnter
		cQuery += " WHERE 													" + hEnter
		cQuery += " ZL7.ZL7_FILIAL 		= '" + xFilial("ZL7")    + "'   	" + hEnter		
		cQuery += " AND ZL7.ZL7_DATA    = '" + dtos(ZL5->ZL5_DATA) + "'   	" + hEnter
		cQuery += " AND ZL7.ZL7_TRANSP  = '" + ZL5->ZL5_TRANSP     + "'		" + hEnter
		cQuery += " AND ZL7.ZL7_LINHA   = '" + ZL5->ZL5_LINHA      + "'   	" + hEnter
		cQuery += " AND ZL7.ZL7_TPROD  != 'O'								" + hEnter
		cQuery += " AND ZL7.D_E_L_E_T_ != '*'								" + hEnter
		
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		
			// alimenta a quanditade da vazão do transportador na data e linha
		cQuery := "	SELECT SUM(ZL6_QTDE) AS ZL6_TOTAL						" + hEnter
		cQuery += "	FROM " + RetSQLName("ZL6") + " ZL6 						" + hEnter
		cQuery += " WHERE 													" + hEnter
		cQuery += " ZL6.ZL6_FILIAL 		= '" + xFilial("ZL7")    + "'   	" + hEnter		
		cQuery += " AND ZL6.ZL6_COD    = '" + cCODMOV + "'  			 	" + hEnter
		cQuery += " AND ZL6.D_E_L_E_T_ != '*'								" + hEnter
		
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP2)		
		dbSelectArea(cAliasTMP2)
		(cAliasTMP2)->(dbGoTop())
		
				
		If ! Empty ( (cAliasTMP)->ZL7_QTDVAZ )
			dbSelectArea("ZL5")
			ZL5->(dbSetOrder(1))
			ZL5->(dbGoTop())
			If ZL5->(dbSeek(xFilial("ZL5") + cCODMOV))
				If RECLOCK("ZL5",.F.)
					ZL5->ZL5_PLATF  := (cAliasTMP)->ZL7_QTDVAZ
						If ZL5->ZL5_TOTAL == (cAliasTMP2)->ZL6_TOTAL
							ZL5->ZL5_X_PARC := ""
						EndIf
					ZL5->(MSUNLOCK())
				EndIf
			EndIf			
		EndIf
		(cAliasTMP)->(dbCloseArea())				
		
		
	EndIf

Return
