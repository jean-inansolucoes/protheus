#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD006    บAutor  ณRafael Parma      บ Data ณ  10/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Entrada de dados de anแlises de coletas de campo.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function LTCAD006()
*-----------------------------*
                                                                
Private cCadastro := "Anแlises coletas de campo"                         
Private cString := "ZLA"
Private aRotina	:= {{"Pesquisar"   ,"AxPesqui"   ,0, 1},;
					{"Visualizar"  ,"U_LTC6ZLA"  ,0, 2},;
					{"Incluir"     ,"U_LTC6ZLA"  ,0, 3},;
					{"Manuten็ใo"  ,"U_LTC6ZLA"  ,0, 4} }             			

	
	dbSelectArea(cString)
	dbSetOrder(4)
	mBrowse(6,1,22,75,cString)
		
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTC6ZLA   บAutor  ณRafael Parma       บ Data ณ  10/09/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de anแlises do produtor.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------*
User Function LTC6ZLA( cAlias, nReg, nOpc )
*----------------------------------------------*
Local aArea        := GetArea()
Local aPosObj      := {}
Local aObjects     := {}
Local aSize        := MsAdvSize( .F. )
/*Local aGet         := {}
Local aEntidade    := {}
Local aChave       := {}*/

Local cSeekZLA     := ""
Local cEntidade    := "ZLA"

Local lGravou      := .F.
Local lTravas      := .T.

Local nCntFor      := 0

//Local nPosUser     := 0
Local nOpcA        := 0
//Local nScan        := 0
//Local nLoop        := 0

PRIVATE lALTER     := .F.
PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aTravas    := {}
PRIVATE aRecZLA    := {}
PRIVATE nUsado     := 0

PRIVATE oDlg
PRIVATE oGetD
PRIVATE oGetCPO

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona a entidade                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cEntidade)
	
	If nOpc != 3	//Incluir       
		dZLA_DATA  := ZLA->ZLA_DATA
		cZLA_LINHA := ZLA->ZLA_LINHA
	    cZLA_DESCL := Posicione("ZL0",1,xFilial("ZL0")+cZLA_LINHA,"ZL0_DESC")
	Else
		lALTER    := .T.
		dZLA_DATA  := ddatabase
		cZLA_LINHA := Space(TAMSX3("ZLA_LINHA")[1])
	    cZLA_DESCL := Space(TAMSX3("ZL0_DESC")[1])
	EndIf
	    
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbSeek( cEntidade ) )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeader                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidade)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidade )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "ZLA_FILIAL|ZLA_LINHA|ZLA_DATA" )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		
		SX3->( dbSkip() )
	EndDo                   
	
	If nOpc != 3
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aCols                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea(cEntidade)
		dbSetOrder(4)	//ZLA_FILIAL+DTOS(ZLA_DATA)+ZLA_LINHA
	 	(cEntidade)->(dbGoTop())        	
		
		cSeekZLA := xFilial( cEntidade ) + dtos(dZLA_DATA) + cZLA_LINHA
		If (cEntidade)->( MsSeek( cSeekZLA ) )
			While ( !Eof() .And. cSeekZLA == ZLA->(ZLA_FILIAL+DTOS(ZLA_DATA)+ZLA_LINHA)  )
	
				If ( SoftLock(cEntidade ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aCols,Array(nUsado+1))
					AAdd(aRecZLA, (cEntidade)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeader[nCntFor][10] != "V" )
							aCols[Len(aCols)][nCntFor] := ZLA->(FieldGet(FieldPos(aHeader[nCntFor][2])))
						Else
							aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
						EndIf
					Next
					aCols[Len(aCols)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidade)->( dbSkip()   )
			EndDo
		EndIf
	
	Endif
	
	If Empty( aCols )
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[1][nUsado+1] := .F.

	EndIf

	If ( lTravas )
          
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณJanela de manuten็ใo                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		AAdd( aObjects, { 100,  44, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 023,005 SAY OemToAnsi("Data Anแlise: ") 	   	SIZE 050,009 OF oDlg PIXEL 
		@ 022,040 GET oGetCPO VAR dZLA_DATA	VALID (fExitZLA())	SIZE 040,009 OF oDlg PIXEL WHEN lALTER
		@ 023,090 SAY OemToAnsi("Linha Coleta: ") 	   	SIZE 050,009 OF oDlg PIXEL 
	   	@ 022,130 MSGET cZLA_LINHA F3 "ZL0000" VALID (EXISTCPO("ZL0") .AND. fExitZLA()) SIZE 050,009 OF oDlg PIXEL WHEN lALTER
		@ 022,190 GET oGetCPO VAR cZLA_DESCL			SIZE 120,009 OF oDlg PIXEL WHEN .F.

		oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc,"U_LTC6LnOk()","AllwaysTrue", ,.T.)			
	
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| nOpcA:=1, Iif(U_LTC63TdOk(), oDlg:End(),nOpcA:=0)  } , {||oDlg:End()})

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza็ใo base de dados.                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := LTC6GRV( cEntidade, aRecZLA )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
		EndIf
   
	EndIf
	
	If ( __lSx8 )
		RollBackSx8()
	EndIf
	For nCntFor := 1 To Len(aTravas)
		dbSelectArea(aTravas[nCntFor][1])
		dbGoto(aTravas[nCntFor][2])
		MsUnLock()
	Next nCntFor

	RestArea( aArea )

Return(lGravou)
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExitZLA   บAutor  ณRafael Parma     บ Data ณ  10/09/09     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao de data + linha anแlise.                           ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*------------------------------*
Static Function fExitZLA()
*------------------------------*
Local lRet := .T.

	dbSelectArea("ZLA")
	dbSetOrder(4)	//ZLA_FILIAL+DTOS(ZLA_DATA)+ZLA_LINHA
	dbGoTop()
	If dbSeek ( xFilial("ZLA") + dtos(M->dZLA_DATA) + M->cZLA_LINHA )
		Aviso("Aten็ใo","Jแ existem registros para esta data e linha de coleta, localize o registro correspondente e acesse a op็ใo Manuten็ใo!",{"OK"},2)
		lRet := .F.
	Else                                                                     
		cZLA_DESCL := Posicione("ZL0",1,xFilial("ZL0")+cZLA_LINHA,"ZL0_DESC")
		fIncAUTO(M->dZLA_DATA, M->cZLA_LINHA)		
	Endif
	    
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTC6LnOk   บAutor  ณRafael Parma     บ Data ณ  10/09/09     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da MsGetDados.                                     ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*------------------------------*
User Function LTC6LnOk()
*------------------------------*  
Local lRet := .T.     

Local nPPRD := aScan(aHeader,{|x| AllTrim(x[2])=="ZLA_PRODUT"})
Local nPLOJ := aScan(aHeader,{|x| AllTrim(x[2])=="ZLA_LOJPRD"})
//Local nMaxFor   := Len(aCols)
//Local nUsado    := Len(aHeader)
//Local lTestaDel := nUsado <> Len(aCols[1])
	
	/*
	For nI := 1 to Len(aCols)              
		// verifica se existe registro duplicado
		If !aCols[nI][nUsado+1]
			If n != nI .and. aCols[nI,nPPRD]+aCols[nI,nPLOJ] == aCols[n,nPPRD]+aCols[n,nPLOJ]
				MsgAlert("Anแlise jแ informada para este produtor nesta data!")
				lRet := .F.
				Exit
			EndIf                          
		EndIf
	Next nI
	*/
	
	If lRet
		If Posicione("SA2",1,xFilial("SA2")+aCols[n,nPPRD]+aCols[n,nPLOJ],"A2_X_LINHA") != M->cZLA_LINHA
			MsgAlert("Este produtor nใo pertence a esta linha de coleta!")
			lRet := .F.
		EndIf
	EndIf
		
Return (lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTC63TdOk   บAutor  ณRafael Parma     บ Data ณ  10/09/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da MsGetDados.                                     ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*------------------------------*
User Function LTC63TdOk()
*------------------------------*  
Local lRet := .T.
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTC6GRV  บAutor  ณRafael Parma         บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para grava็ใo dos dados.                    ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------------------------------------------*
Static Function LTC6GRV( cEntidade, aRecZLA, lExclui )
*-------------------------------------------------------------*
Local cSeekZLA  := ""
Local lGravou   := .F.
Local nLoop     := 0
Local nLoop2    := 0

DEFAULT lExclui := .F.

	If lExclui

		cSeekZLA := xFilial( cEntidade ) + dtos(M->dZLA_DATA) + M->cZLA_LINHA
		(cEntidade)->( dbSetOrder(4) )	//ZLA_FILIAL+DTOS(ZLA_DATA)+ZLA_LINHA 
		If (cEntidade)->( dbSeek( cSeekZLA ) )
			lGravou := .T.
			While !(cEntidade)->( EOF() ) .And. cSeekZLA == ZLA->(ZLA_FILIAL+DTOS(ZLA_DATA)+ZLA_LINHA)
				RecLock( cEntidade, .F. )
				(cEntidade)->( dbDelete() )
				(cEntidade)->( MsUnLock() ) 			
				(cEntidade)->( dbSkip() )
			EndDo 	
		EndIf 	                  
	
	Else
	
		For nLoop := 1 To Len( aCols )
			lGravou := .T.
			If GDDeleted( nLoop )
				If nLoop <= Len( aRecZLA )
					(cEntidade)->( MsGoto( aRecZLA[ nLoop ] ) ) 	
					RecLock( cEntidade, .F. )
					(cEntidade)->( dbDelete() )
					(cEntidade)->( MsUnlock() ) 		
				EndIf
			Else
				If nLoop <= Len( aRecZLA )
					(cEntidade)->( MsGoto( aRecZLA[ nLoop ] ) ) 	
					RecLock( cEntidade, .F. )
				Else
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Inclui e grava os campos chave                                         ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					RecLock( cEntidade, .T. ) 		
					ZLA->ZLA_FILIAL := xFilial( cEntidade )
					ZLA->ZLA_DATA   := M->dZLA_DATA
					ZLA->ZLA_LINHA  := M->cZLA_LINHA
					
				EndIf
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Grava os demais campos                                                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				For nLoop2 := 1 To Len( aHeader )
					If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "ZLA_FILIAL|ZLA_DATA|ZLA_LINHA" )
						ZLA->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
					EndIf
				Next nLoop2	
				ZLA->( MsUnlock() )	
			EndIf	
		Next nLoop	
	EndIf 	
	
Return( lGravou )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINCAUTO บAutor  ณRafael Parma         บ Data ณ  09/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para popular array com dados de anแlises comฑฑ
ฑฑบ          ณbase nas amostras informadas no movimento do produtor.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------------------------------------------*
Static Function FINCAUTO( dDATMOV, cCODLIN)                                     
*-------------------------------------------------------------*
Local cAliasTMP := GetNextAlias()
Local cEntidade := "ZLA"
Local lFirst  := .T.
Local nPosPRD := aScan(aHeader,{|x| AllTrim(x[2])=="ZLA_PRODUT"})
Local nPosLOJ := aScan(aHeader,{|x| AllTrim(x[2])=="ZLA_LOJPRD"})
Local nPosNOM := aScan(aHeader,{|x| AllTrim(x[2])=="ZLA_NOMPRD"})
Local nPosAMS := aScan(aHeader,{|x| AllTrim(x[2])=="ZLA_NUMERO"})
Local nPosQTD := aScan(aHeader,{|x| AllTrim(x[2])=="ZLA_QTDE"})
Local nCntFor			

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRecupera registros com amostras.                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cQuery := "	SELECT 	ZL6.ZL6_PRODUT, 										"+chr(10)+chr(13)
	cQuery += "			ZL6.ZL6_LOJPRD, 										"+chr(10)+chr(13) 
	cQuery += "			ZL6.ZL6_NOMPRD, 										"+chr(10)+chr(13)
	cQuery += "			ZL6.ZL6_AMOSTR,											"+chr(10)+chr(13)
	cQuery += "			ZL6.ZL6_QTDE											"+chr(10)+chr(13)	
	cQuery += "	FROM " + RetSQLName("ZL6") + " ZL6  							"+chr(10)+chr(13)
	cQuery += " INNER JOIN " + RetSQLName("ZL5") + " ZL5  						"+chr(10)+chr(13)
	cQuery += " ON ZL5.ZL5_FILIAL = ZL6.ZL6_FILIAL  							"+chr(10)+chr(13)
	cQuery += " AND ZL5.ZL5_COD   = ZL6.ZL6_COD   								"+chr(10)+chr(13)
	cQuery += " WHERE ZL5.ZL5_FILIAL = '" + xFilial("ZL5") + "' 				"+chr(10)+chr(13)
	cQuery += " AND ZL5.ZL5_DATA     = '" + DTOS(dDATMOV) + "' 		  			"+chr(10)+chr(13)
	cQuery += " AND ZL5.ZL5_LINHA    = '" + cCODLIN + "'   						"+chr(10)+chr(13)
	cQuery += " AND ZL6.ZL6_AMOSTR  != '"+Space(TAMSX3("ZL6_AMOSTR")[1])+"'   	"+chr(10)+chr(13)
	cQuery += " AND ZL5.D_E_L_E_T_  != '*'   									"+chr(10)+chr(13)
	cQuery += " AND ZL6.D_E_L_E_T_  != '*'   									"+chr(10)+chr(13)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aCols                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lALTER := .F.	
		dbSelectArea(cEntidade)
		AAdd(aTravas,{ Alias() , RecNo() })	    
		While !(cAliasTMP)->(EOF())
			If ! lFirst
				AAdd(aCols,Array(nUsado+1))
			Else
				lFirst := .F.
			EndIf
			For nCntFor := 1 To nUsado
				If ( AllTrim(aHeader[nCntFor][2])=="ZLA_PRODUT" )
					aCols[Len(aCols)][nPosPRD] := (cAliasTMP)->ZL6_PRODUT
				ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLA_LOJPRD" )
					aCols[Len(aCols)][nPosLOJ] := (cAliasTMP)->ZL6_LOJPRD
				ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLA_NOMPRD" )
					aCols[Len(aCols)][nPosNOM] := (cAliasTMP)->ZL6_NOMPRD
				ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLA_NUMERO" )
					aCols[Len(aCols)][nPosAMS] := (cAliasTMP)->ZL6_AMOSTR 
				ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLA_QTDE" )
					aCols[Len(aCols)][nPosQTD] := (cAliasTMP)->ZL6_QTDE
				Else
					aCols[Len(aCols)][nCntFor] := CriaVar( aHeader[nCntFor,2] ) 
				EndIf
			Next nCntFor
			aCols[Len(aCols)][nUsado+1] := .F.
			
			(cAliasTMP)->(dbSkip())
		Enddo
		
		(cAliasTMP)->(dbCloseArea())
		
	EndIf
	oGetD:oBrowse:Refresh()	
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTUPDZLA บAutor  ณRafael Parma         บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do campo ZLA_LINHA sobre registros existentes.   ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------*
User Function LTUPDZLA()        
*------------------------------*

	dbSelectArea("ZLA")
	dbSetOrder(1)
	dbGoTop()
	While !EOF()
		If Empty(ZLA->ZLA_LINHA)
			RecLock("ZLA",.F.)
			ZLA->ZLA_LINHA := Posicione("SA2",1,xFilial("SA2")+ZLA->ZLA_PRODUT+ZLA->ZLA_LOJPRD,"A2_X_LINHA")	
			ZLA->(MsUnLock())
		EndIf
		ZLA->(dbSkip())
	Enddo
    
    MsgInfo("Processo concluํdo!")
 
 Return
