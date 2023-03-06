#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD005 บAutor  ณRafael Parma         บ Data ณ  10/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de entrada de dados Normativa 62.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTCAD005()
*-----------------------*

Local cAliasH		:= "ZL8"
Private cCadastro	:= "Normativa 62"
Private aCores		:= {}
Private aRotina		:= MENUDEF()

	dBSelectArea( cAliasH )
	(cAliasH)->( dBSetOrder( 1 ) )
	(cAliasH)->( dBGotop( ) )
    
	mBrowse( ,,,,cAliasH)
		
	If select(cAliasH) > 0
		(cAliasH)->( dBCloseArea( ) )
	Endif
	
Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef  บAutor  ณRafael Parma         บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo das sub-rotinas da rotina principal               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------*
Static Function MenuDef() 
*------------------------*

Local aRotina := {{"Pesquisar" 	  , "AxPesqui"    , 0 , 1},;
                  {"Visualizar"	  , "U_LTCAD5Vis" , 0 , 2},;
                  {"Incluir"   	  , "U_LTCAD5Inc" , 0 , 3},;
                  {"Alterar"   	  , "U_LTCAD5Alt" , 0 , 4},;                 
                  {"Excluir"   	  , "U_LTCAD5Exc" , 0 , 5},;
                  {"Importar"     , "U_LTIMPARQ"  , 0 , 6},;
				  {"Importar CSV" , "U_LTCAD5Imp" , 0 , 3}}
	                    
Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5Vis บAutor  ณRafael Parma        บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualiza็ใo do movimento.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    

*---------------------------------------------*
User Function LTCAD5Vis( cAlias, nReg, nOpc )
*---------------------------------------------*

Local oDlgLTCAD5
Local oGetD
Local aArea      := GetArea()
Local cAliasIT   := "ZL9" 
Local cItem      := "ZL9_SEQ"
Local bCampo     := {|nCPO| Field(nCPO) }
Local aSize      := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aCpoEnch   := {}
Local aAlterEnch := {}
Local aFldsNwGd  := {}
Local aCols	     := {}
Local aHeader	 := {}
//Local aGets      := {}
Local nModelo    := 3
Local nX         := 0
Local nUsado	 := 0
Local nPoZL8I    := 0
Local nPosItem   := 0
Local nOpcNewGd	 := GD_INSERT + GD_UPDATE + GD_DELETE
Local lColumn    := .F. 
Local lF3        := .F. 
Local lMemoria   := .T. 
Local lNoFolder  := .F. 
Local lProperty  := .T. 
//Local lAction    := .T.
Local i
Private INCLUI   := .F.
Private ALTERA   := .F.


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define e Registra os Campos do Enchoice                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atribui aos Campos registrados os valores do registro da tabela posicionado   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea( cAlias )
	For i := 1 TO FCount()
		M->&(Eval( bCampo,i ) ) := FieldGet(i)
	Next i
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define aHeader do MsNewGetDados                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop( ) )
	SX3->( dBSeek( cALiasIT ) )
	While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL9_PROTOC" )
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
			Endif
		EndIf
		SX3->(dbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos dados do aCols para utilizar no MsNewGetDados   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea( cALiasIT )
	(cALiasIT)->( dBSetOrder( 1 ) )
	(cALiasIT)->( dBGotop(  ) )
	(cALiasIT)->( dBSeek( xFilial( cALiasIT ) + ZL8->ZL8_PROTOC ) )
	While ( !(cALiasIT)->(  Eof( ) ) .And. ZL9->ZL9_FILIAL == xFilial( cALiasIT ) .And. ZL9->ZL9_PROTOC == ZL8->ZL8_PROTOC )
		If ( SoftLock( cALiasIT ) )
			aadd(aCols,Array(nUsado+1))
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V" )
					If !Empty( nPoZL8I := FieldPos(aHeader[nX][2] ) )
						aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL8I ) )
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใo     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aSize   := MsAdvSize()
	AAdd( aObjects, { 100, 40, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	DEFINE MSDIALOG oDlgLTCAD5 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos do Cabe็alho                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlgLTCAD5,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grid de Exibi็ใo                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,,,"+" + cItem, aFldsNwGd,000,999,,"",,oDlgLTCAD5,aHeader,aCols)
	
	ACTIVATE MSDIALOG oDlgLTCAD5 ON INIT EnchoiceBar(oDlgLTCAD5,{||oDlgLTCAD5:End()},{||oDlgLTCAD5:End()})
	
	RestArea(aArea)
	
	if select(cAliasIT) > 0
		(cAliasIT)->( dBCloseArea( ) )
	endif
	
return( nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5Inc บAutor  ณRafael Parma        บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclusใo do movimento.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function LTCAD5Inc( cAlias, nReg, nOpc )
*********************************************
Local cAliasIT   := "ZL9" 
Local cItem      := "ZL9_SEQ"
Local aSize      := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aCpoEnch   := {}
Local aAlterEnch := {}
Local aFldsNwGd  := {}

Local aHeader	 := {}
Local nModelo    := 3
Local nX         := 0
Local nUsado	 := 0
//Local nPoZL8I    := 0
Local nPosItem   := 0
Local nOpcA		 := 1
Local nOpcNewGd	 := if( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)
Local lAction    := .F.
Local lColumn    := .F. 
Local lF3        := .F. 
Local lMemoria   := .T. 
Local lNoFolder  := .F. 
Local lProperty  := .F. 
Private INCLUI   := .T.
Private ALTERA   := .F.
Private aTela    := {}
Private aGets    := {}

Public aCols	 := {}
Public oGetD
Public oDlgLTCAD5

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define e Registra os Campos do Enchoice                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define aHeader do MsNewGetDados                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop( ) )
	SX3->( dBSeek( cALiasIT ) )
	While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL9_PROTOC" )
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
			Endif
		EndIf
		SX3->(dbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem do aCols para utilizar no MsNewGetDados             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aadd(aCols,Array(nUsado+1))
	
	For nX := 1 To nUsado
		aCols[1][nX] := CriaVar(aHeader[nX][2])
	Next nX
	
	aCols[1][nUsado+1] := .F.
	aCols[1][nPosItem] := StrZero(1,TamSx3(cItem)[1])
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใo     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aSize   := MsAdvSize()
	AAdd( aObjects, { 100, 40, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	DEFINE MSDIALOG oDlgLTCAD5 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos do Cabe็alho                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlgLTCAD5,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grid de Exibi็ใo                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,"U_LTCAD5LnOk", "U_LTCAD5TdOk", "+" + cItem, aFldsNwGd, 000, 999,"U_LTCAD5CpOk","", "U_LTCAD5TdOk", oDlgLTCAD5, aHeader ,aCols )
	oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,"U_LTCAD5TdOk", "U_LTCAD5TdOk", "+" + cItem, aFldsNwGd, 000, 999,"U_LTCAD5TdOk","", "U_LTCAD5TdOk", oDlgLTCAD5, aHeader ,aCols )
	
	ACTIVATE MSDIALOG oDlgLTCAD5 ON INIT EnchoiceBar(oDlgLTCAD5,{||if(oGetd:TudoOk() .AND. Obrigatorio(aGets,aTela),oDlgLTCAD5:End(),nOpca := 1)},{||nOpca := 0, oDlgLTCAD5:End()})
	
	If nOpca == 1
		lAction := LTCAD5Grav( oGetD, nOpc )
	Else
	   RollBackSX8()
	Endif
	
	if select(cAliasIT) > 0
		(cAliasIT)->( dBCloseArea( ) )
	endif
	
return( lAction )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5Alt บAutor  ณRafael Parma        บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera็ใo do movimento.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function LTCAD5Alt( cAlias, nReg, nOpc )
*********************************************
Local oDlgLTCAD5
Local oGetD
Local aArea      := GetArea()
Local cAliasIT   := "ZL9" 
Local cItem      := "ZL9_SEQ"
Local bCampo     := {|nCPO| Field(nCPO) }
Local aSize      := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aCpoEnch   := {}
Local aAlterEnch := {}
Local aFldsNwGd  := {}
Local aCols	     := {}
Local aHeader	 := {}
Local aGets      := {}
Local nModelo    := 3
Local nOpca      := 1
Local nX         := 0
Local nUsado	 := 0
Local nPoZL8I    := 0
Local nPosItem   := 0
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
//Private aGets    := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define e Registra os Campos do Enchoice                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atribui aos Campos registrados os valores do registro da tabela posicionado   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea( cAlias )
	For i := 1 TO FCount()
		M->&(Eval( bCampo,i ) ) := FieldGet(i)
	Next i
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define aHeader do MsNewGetDados                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop( ) )
	SX3->( dBSeek( cALiasIT ) )
	While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL9_PROTOC" )
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
			Endif
		EndIf
		SX3->(dbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos dados do aCols para utilizar no MsNewGetDados   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea( cALiasIT )
	(cALiasIT)->( dBSetOrder( 1 ) )
	(cALiasIT)->( dBGotop( ) )
	(cALiasIT)->( dBSeek( xFilial( cALiasIT ) + ZL8->ZL8_PROTOC ) )
	While ( !(cALiasIT)->(  Eof( ) ) .And. ZL9->ZL9_FILIAL == xFilial( cALiasIT ) .And. ZL9->ZL9_PROTOC == ZL8->ZL8_PROTOC )
		If ( SoftLock( cALiasIT ) )
			aadd(aCols,Array(nUsado+1))
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V" )
					If !Empty( nPoZL8I := FieldPos(aHeader[nX][2] ) )
						aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL8I ) )
					EndIf
				Else
					aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
					aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL8I ) )
				EndIf
			Next
			aCols[Len(aCols)][nUsado+1] := .F.
		Else
			lTravas := .T.
		EndIf
		(cALiasIT)->(dBSkip())
	EndDo
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใo     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aSize   := MsAdvSize()
	AAdd( aObjects, { 100, 40, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	DEFINE MSDIALOG oDlgLTCAD5 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos do Cabe็alho                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlgLTCAD5,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grid de Exibi็ใo                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,"U_LTCAD5LnOk", "U_LTCAD5TdOk", "+" + cItem, aFldsNwGd, 000, 999,"U_LTCAD5CpOk","", "U_LTCAD5TdOk", oDlgLTCAD5, aHeader ,aCols )
	oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,"U_LTCAD5TdOk", "U_LTCAD5TdOk", "+" + cItem, aFldsNwGd, 000, 999,"U_LTCAD5TdOk","", "U_LTCAD5TdOk", oDlgLTCAD5, aHeader ,aCols )
	
	ACTIVATE MSDIALOG oDlgLTCAD5 ON INIT EnchoiceBar(oDlgLTCAD5,{||if(oGetd:TudoOk() .AND. Obrigatorio(aGets,aTela),oDlgLTCAD5:End(),nOpca := 1)},{||nOpca := 0, oDlgLTCAD5:End()})
	
	If nOpca == 1
		lAction := LTCAD5Grav( oGetD, nOpc )
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5Exc  บAutor  ณRafael Parma       บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclusใo do movimento.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function LTCAD5Exc( cAlias, nReg, nOpc )
*********************************************

Local oDlgLTCAD5
Local oGetD
Local aArea      := GetArea()
Local cAliasIT   := "ZL9" 
Local cItem      := "ZL9_SEQ"
Local bCampo     := {|nCPO| Field(nCPO) }
Local aSize      := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aCpoEnch   := {}
Local aAlterEnch := {}
Local aFldsNwGd  := {}
Local aCols	     := {}
Local aHeader	 := {}
Local aGets      := {}
Local nModelo    := 3
Local nOpca      := 1
Local nX         := 0
Local nUsado	 := 0
Local nPoZL8I    := 0
Local nPosItem   := 0
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
Private ALTERA   := .F.
Private aTela    := {}
//Private aGets    := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define e Registra os Campos do Enchoice                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atribui aos Campos registrados os valores do registro da tabela posicionado   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea( cAlias )
	For i := 1 TO FCount()
		M->&(Eval( bCampo,i ) ) := FieldGet(i)
	Next i
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define aHeader do MsNewGetDados                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGotop(  ) )
	SX3->( dBSeek( cALiasIT ) )
	While ( !Eof() .And. SX3->X3_ARQUIVO==cALiasIT )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_BROWSE == "S" .And. !AllTrim(SX3->X3_CAMPO)$"ZL9_PROTOC" )
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
			Endif
		EndIf
		SX3->(dbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos dados do aCols para utilizar no MsNewGetDados   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dBSelectArea( cALiasIT )
	(cALiasIT)->( dBSetOrder( 1 ) )
	(cALiasIT)->( dBGotop(  ) )
	(cALiasIT)->( dBSeek( xFilial( cALiasIT ) + ZL8->ZL8_PROTOC ) )
	While ( !(cALiasIT)->(  Eof( ) ) .And. ZL9->ZL9_FILIAL == xFilial( cALiasIT ) .And. ZL9->ZL9_PROTOC == ZL8->ZL8_PROTOC )
		If ( SoftLock( cALiasIT ) )
			aadd(aCols,Array(nUsado+1))
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V" )
					If !Empty( nPoZL8I := FieldPos(aHeader[nX][2] ) )
						aCols[Len(aCols)][nX] := (cALiasIT)->(FieldGet( nPoZL8I ) )
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
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใo     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aSize   := MsAdvSize()
	AAdd( aObjects, { 100, 40, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	DEFINE MSDIALOG oDlgLTCAD5 TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos do Cabe็alho                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Enchoice( cAlias ,nReg, nOpc ,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlgLTCAD5,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grid de Exibi็ใo                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,,,"+" + cItem, aFldsNwGd,000,999,,"",,oDlgLTCAD5,aHeader,aCols)
	
	ACTIVATE MSDIALOG oDlgLTCAD5 ON INIT EnchoiceBar(oDlgLTCAD5,{||if(oGetd:TudoOk() .AND. Obrigatorio(aGets,aTela),oDlgLTCAD5:End(),nOpca := 1)},{||nOpca := 0, oDlgLTCAD5:End()})
	
	If nOpca == 1
		lAction := LTCAD5Grav( oGetD, nOpc )
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5LnOk  บAutor  ณRafael Parma      บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Valida็ใo da linha do MsNewGetDados               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTCAD5LnOk()
**************************
Local lRet    := .T.
/*Local nX      := 1
Local nPosMx  := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZCI_PERCMX"   } )
Local nPosMi  := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZCI_PERCMI"   } )
    /*
	if n > 1
		if aCols[n][nPosMi] <= aCols[n-1][nPosMx]
		   U_GCALL001( cCadastro, "O Percentual Minimo informado deve ser superior ao Percentual Mแximo informado na linha anterior.", "Informe um Percentual Mํnimo superior ao Percentual Mแximo da linha anterior"  )
		   lRet := .F.
		Endif
	Endif
	
	if aCols[n][nPosMx] < aCols[n][nPosMi]
	    U_GCALL001( cCadastro, "O Percentual Mแximo deve ser pelo menos igual ao Percentual Minimo informado.", "" )
		lRet := .F.
	Endif
	*/

return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5LnOk  บAutor  ณRafael Parma      บ Data ณ  10/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Valida็ใo do campo do MsNewGetDados               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function LTCAD5CpOk()
**************************
Local lRet    := .T.
/*Local nX      := 1
Local nUsado  := Len( aHeader )
Local nPosMx  := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZCI_PERCMX"   } )
Local nPosMi  := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZCI_PERCMI"   } )
Local cVarMem := alltrim( ReadVar( ) )
    /*
	if n > 1
		if cVarMem == "M->ZCI_PERCMI"
			if ( ( M->ZCI_PERCMI <= aCols[n-1][nPosMx] ) .And. ( !aCols[ n ][ nUsado + 1 ] ) )
			    U_GCALL001( cCadastro, "O Percentual Minimo informado deve ser superior ao Percentual Mแximo informado na linha anterior.", "Altere o Percentual Minimo." )
				lRet := .F.
			Endif
		endif
	endif
	
	if  cVarMem == "M->ZCI_PERCMX"
		if ( ( M->ZCI_PERCMX < aCols[n][nPosMi] ) .And. ( !aCols[ n ][ nUsado + 1 ] ) )
			U_GCALL001( cCadastro, "O Percentual Mแximo deve ser pelo menos igual ao Percentual Minimo informado", "Altere o Percentual Mแximo" )
			lRet := .F.
		Endif
	Endif
	*/
return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5TdOk  บAutor  ณRafael Parma        บ Data ณ  10/10/09 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Valida็ใo se tudo esta correto no MsNewGetDados   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function LTCAD5TdOk()
**************************
Local lRet  := .T.

return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5Grav  บAutor  ณRafael Parma        บ Data ณ  10/10/09 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de grava็ใo de dados.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LTCAD005                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function LTCAD5Grav( poGet, pnOpc )
******************************************
Local aCols    := poGet:aCols
Local aHeader  := poGet:aHeader
Local cNumCod  := M->ZL8_PROTOC
//Local cCodigo  := ""
//Local cCampo   := ""
Local cItem    := "ZL9_SEQ"
Local cMay     := "ZL8" + xFilial("ZL8") + cNumCod
Local nUsado   := Len( aHeader )
Local nLenGet  := Len( aCols )
Local nPoZL8I  := 0
//Local nItem    := 0  
Local nCont    := 0
Local nQts     := 0
Local nPosItem := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == cItem   } )
Local nI, nY, nX
//Local bCampo   := {|nCPO| Field(nCPO) }
Local lGravou  := .F. 
Local lGoGrava := .T.
                        

CursorWait( )  
SysRefresh()

Do Case
   Case ( pnOpc == 3 .Or. pnOpc == 4 )
        If ( pnOpc == 3 )
		   dbSelectArea("ZL8")
		   ZL8->(dbSetOrder(1))
		   While ( MsSeek( xFilial( "ZL8" ) + cNumCod ) .OR. !MayIUseCode( cMay ) ) //SUA
			     cNumCod := Soma1( cNumCod,Len( cNumCod ) )
			     cMay 	:= "ZL8" + xFilial("ZL8") + cNumCod
		   EndDo
		   M->ZL8_PROTOC := cNumCod
        Endif
        
		Begin Transaction
		      // Grava็ใo do Enchoice
	          dBSelectArea("ZL8")
	          ZL8->( dBSetOrder( 1 ) )
	          //
	          If ( pnOpc == 3 )
	             RecLock("ZL8",.T.)
	          Else
	             RecLock("ZL8",.F.)
	          Endif
	          //
	          For nI := 1 To FCount()
		          If U_LTALLXSX3( FieldName(nI) )[3] == "C" .And. alltrim(FieldName(nI)) <> "ZL8_FILIAL"
		             cResult := U_LTALLXACE ( M->&(FieldName( nI ) ) )// remove os acentos...
		          Else
		             cResult := M->&(FieldName( nI ) )
		          Endif
		          M->&(FieldName( nI ) ) := cResult
		          
		          If ( FieldName(nI) == "ZL8_FILIAL" )
			         FieldPut( nI, xFilial( "ZL8" ) )
		          Else
			         FieldPut( nI, M->&(FieldName( nI ) ) )
		          Endif
	          Next

		      For nY := 1 To nLenGet
		          If ( !aCols[nY][nUsado+1] )
		             nQts++
		          Endif
		      Next
		                                        
		      /*
		      if nQts == 1
		          if aCols[1][nPosPrMi] == 0 .And. aCols[1][nPosPrMx] == 0 .And. aCols[1][nPosFat] == 0
		             lGoGrava := .F.
		          endif
		      endif
              */
              
              if lGoGrava
		         // Grava็ใo do aCols
		         For nX := 1 To nLenGet
			         If ( !aCols[nX][nUsado+1] )
				        dBSelectArea("ZL9")
				        ZL9->( dBSetOrder( 1 ) )
				        ZL9->( dBGotop(  ) )
				        If ( ZL9->( dBSeek( xFilial( "ZL9" ) + M->ZL8_PROTOC + aCols[nX][nPosItem] ) ) )
					       RecLock("ZL9", .F.)
				        Else
					       RecLock("ZL9",.T.)
				        EndIf
				          
				        For nY := 1 To nUsado
					        If ( aHeader[nY][10] != "V" )
						       If !Empty( nPoZL8I := FieldPos( aHeader[nY][2] ) )
  						          // ZL9->( FieldPut( nPoZL8I ,iif( Alltrim( aHeader[nY][2] ) == "ZCI_OBSERV", U_GCALLXACE ( aCols[nX][nY] ), aCols[nX][nY] )))	
  						          ZL9->( FieldPut( nPoZL8I , aCols[nX][nY] ))
			  			       EndIf 							
					        EndIf
				        Next nY
				     
				        nCont++
				     
				        ZL9->ZL9_FILIAL := xFilial("ZL9")
				        ZL9->ZL9_SEQ    := StrZero( nCont, TamSx3(cItem)[1] )
				        ZL9->ZL9_PROTOC := M->ZL8_PROTOC
       				 
			         Else
				        dBSelectArea("ZL9")
				        ZL9->( dBSetOrder( 1 ) )
				        ZL9->( dBGotop( ) )
				        If ( ZL9->( dBSeek( xFilial( "ZL9" ) + M->ZL8_PROTOC + aCols[nX][nPosItem] ) ) )
					       RecLock("ZL9")
					       ZL9->( dBDelete( ) )
				        EndIf
			         EndIf
		         Next nX
	          Endif
	          //
	          ZL8->( MsUnlock() )
	          
	          if lGoGrava
	             ZL9->( MsUnlock() )
	          endif
	          
	          FreeUsedCode() 
	          
	          lGravou := .T.
	          
	          If ( lGravou )
			     EvalTrigger()
			     ConfirmSx8()
			  EndIf    
		
			  
		End Transaction

	OtherWise
	    Begin Transaction
	          dBSelectArea("ZL8")
	          RecLock("ZL8")
	          ZL8->( dBDelete( ) )
	          if Len( aCols ) > 0 
	             For nX := 1 To Len( aCols )
		             dBSelectArea("ZL9")
			         ZL9->( dBSetOrder( 1 ) )
			         ZL9->( dBGotop( ) )
			         If ( ZL9->( dBSeek( xFilial( "ZL9" ) + ZL8->ZL8_PROTOC + aCols[nX][nPosItem] ) ) )
			            RecLock("ZL9")
			            ZL9->( dBDelete( ) )
		             EndIf
		       
		         Next nX
		         ZL9->( MsUnlock() )
		      endif
		      ZL8->( MsUnlock() )
		End Transaction
		lGravou := .T.

endcase		
CursorArrow( )  
SysRefresh()

Return( lGravou )                





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD5IMP บAutor  ณMarcelo Joner        บ Data ณ 13/01/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela funcionalidade de leitura e importa-บฑฑ
ฑฑบ          ณ็ใo de resultados เ partir de arquivo CSV.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lat. Silvestre                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTCAD5IMP(cAlias, nReg, nOpc)

Local lColumn    	:= .F. 
Local lF3        	:= .F. 
Local lMemoria   	:= .T. 
Local lNoFolder  	:= .F. 
Local lProperty  	:= .F.
Local nI			:= 0
//Local nX			:= 0
Local nOpcao		:= 2
//Local nModelo		:= 3
Local cCadOld		:= cCadastro
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aParam		:= {SPACE(250)}
Local aCpoEnch		:= {"NOUSER"}
Local aAlterEnch	:= {}
Local aPerg			:= {{6, "Arquivo",aParam[01],"",".T.",".T.",90,.T., "Arquivo .CSV|*.CSV	","c:\",GETF_LOCALHARD,.F.}}
Local cCampos		:= "ZL8_PROTOC\ZL8_DATREC\ZL8_TMPAMB"
Local nY
Private aTela    	:= {}
Private aGets    	:= {}
Private aColsDet	:= {}
Private aHeaderDet	:= {}
Private cArqCSV		:= ""
Private cPergCSV	:= "LTCAD05CSV"

Private VISUAL		:= .F.
Private INCLUI		:= .T.
Private ALTERA		:= .F.
Private DELETA		:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCaso o usuแrio confirmou เ localiza็ใo do arquivo CSV, executa demais regrasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If PARAMBOX(aPerg, "Parโmetros",@aParam,,,.T.,,,,cPergCSV,.F.,.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณObt้m เ localiza็ใo do arquivo informadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cArqCSV := ALLTRIM(aParam[01])
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณExecuta demais regras caso foi informado localiza็ใo do arquivo CSV para importa็ใoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If !EMPTY(cArqCSV)
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณCarrega em mem๓ria campos do cabe็alhoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		dbSelectArea(cAlias)
		RegToMemory(cAlias, INCLUI, .F.)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณComp๕e arrays com os campos do cabe็alho da telaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		dbSelectArea("SX3")
		SX3->(dbSetOrder(1))
		SX3->(dbGotop())
		SX3->(dbSeek(cAlias))
		While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cAlias
			If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_BROWSE == "S" .AND. ALLTRIM(SX3->X3_CAMPO) $ cCampos
				If SX3->X3_VISUAL # "V"
					AADD(aCpoEnch, ALLTRIM(SX3->X3_CAMPO))
					AADD(aAlterEnch, ALLTRIM(SX3->X3_CAMPO))
				EndIF
			EndIf
			SX3->(dbSkip())
		End
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณMonta aHeaderDet para utiliza็ใo na interfaceณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		dbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("ZL9"))   
		While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "ZL9"
			If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. ALLTRIM(SX3->X3_CAMPO) $ "ZL9_PROTOC/ZL9_SEQ/ZL9_PRODUT/ZL9_LOJPRD/ZL9_NOMPRD/ZL9_GORD/ZL9_PROTN/ZL9_LACT/ZL9_SOLD/ZL9_CCS/ZL9_CBT/ZL9_MEDGEO/ZL9_DATCOL/ZL9_DATANL/ZL9_INIMIC/"
				AADD(aHeaderDet, {Trim(X3Titulo()),;
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
								 SX3->X3_WHEN,;
								 SX3->X3_VISUAL,;
								 SX3->X3_VLDUSER})
			EndIf       
			SX3->(DbSkip())
		End
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณExecuta fun็ใo de leitura do arquivo CSV e carga no aColsDetณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		FWMsgRun(, {|oSay| CAD5IMPCSV()}, "Aten็ใo", "Importanto resultados...")
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณExecuta regras para apresentar interface ao usuแrio, caso existam itens no aColsDetณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		If Len(aColsDet) > 0
			cCadastro := "Normativa 62 - Importar CSV"
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			aSize := MsAdvSize()
			AADD(aObjects, {100, 020, .T., .T.})
			AADD(aObjects, {100, 080, .T., .T.})
			aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
			aPosObj := MsObjSize(aInfo, aObjects, .T.)
			
			/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
			ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
			ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
			oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5], cCadastro,,,.F.,,,,,,.T.,,,.T. )
			oDlg:bInit := {|| ENCHOICEBAR(oDlg, {|| IIF(OBRIGATORIO(aGets, aTela) .AND. oBrwDet:TudoOk(), (nOpcao := 1, aColsDet := oBrwDet:aCols, oDlg:End()), nOpcao := 2)}, {|| oDlg:End()},.F.,{})}
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณComponente do cabe็alho da interface ao usuแrioณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				oGetCab := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoEnch, {aPosObj[1,1], aPosObj[1,2], aPosObj[1,3], aPosObj[1,4]}, aAlterEnch, 2,/*nColMens*/,/*cMensagem*/,'',oDlg, lF3, lMemoria, lColumn,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณGrid de defini็ใo das despesas mensaisณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ	
				oBrwDet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,'AllwaysTrue()','AllwaysTrue()',"+",,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg,aHeaderDet,aColsDet)
			
			oDlg:Activate(,,,.T.)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณCaso confirmou เ interface, executa regras de grava็ใoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			If nOpcao == 1
				BEGIN TRANSACTION
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					//ณGrava็ใo do cabe็alho dos resultadosณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					dbSelectArea("ZL8")
					RECLOCK("ZL8",.T.)
						For nI := 1 To FCount()
							If FieldName(nI) == "ZL8_FILIAL" 
								FieldPut(nI, xFilial("ZL8"))
							Else   
								FieldPut(nI, M->&(FieldName(nI)))
							EndIf
						Next nI
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
						//ณGrava็ใo dos itens referentes aos resultadosณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
						For nI := 1 To Len(aColsDet)
							dbSelectArea("ZL9")
							RECLOCK("ZL9", .T.)
								For nY := 1 To Len(aHeaderDet)
									If aHeaderDet[nY][10] != "V"
										If !EMPTY(nPosZL9 := FieldPos(aHeaderDet[nY][2]))
											ZL9->(FieldPut(nPosZL9, aColsDet[nI][nY]))
										EndIf
									EndIf
								Next nY
								
								ZL9->ZL9_FILIAL	:= xFilial("ZL9")
								ZL9->ZL9_PROTOC := M->ZL8_PROTOC
							ZL9->(MSUNLOCK())
						Next nI
					ZL8->(MSUNLOCK())
				
				END TRANSACTION
			EndIf
			
		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณCaso nใo carregou itens, alerta o usuแrio e aborta o processoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			ShowHelpDlg("Aten็ใo",{"Nใo foram obtidos resultados เ partir do arquivo de importa็ใo informado."},5,{"Favor verificar se o arquivo informado estแ correto."},5)
		EndIf
		
	Else
		ShowHelpDlg("Aten็ใo",{"Nใo foi informado เ localiza็ใo do arquivo CSV para processamento da importa็ใo."},5,{"Deve-se informar เ correta localiza็ใo do arquivo para importa็ใo."},5)
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณRestaura tํtulo original da rotinaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
cCadastro := cCadOld

Return  





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณCAD5IMPCSV บAutor  ณMarcelo Joner       บ Data ณ 13/01/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela leitura e processamento das informa-บฑฑ
ฑฑบ          ณ็๕es presentes no arquivo CSV.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lat. Silvestre                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CAD5IMPCSV()

Local lFLAG			:= .T.
Local nLIN			:= 0 
Local cBuffer		:= ""
Local cBufSUB 		:= ""
Local cSeq			:= "001"
Local cArqTxt		:= ALLTRIM(cArqCSV)
Local cProd 		:= ""
Local nX, nI
Private nHdl		:= fOpen(cArqTxt,68)

Private cEOL		:= "CHR(13)+CHR(10)"

If EMPTY(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := TRIM(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณTamanho total do Arquivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
nTotal := FSeek(nHdl,0,2) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณMaximo 500 kbณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤ
If nTotal > 5000*1024
	MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser maior de 5000kb!","Atencao!")
    Return
EndIf
   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAloca no maximo 500kbณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
nBuffer := Min(5000*1024,nTotal) 
   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณPosiciona no 1o. Byteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
FSeek(nHdl,0,0)
nReadTot := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณRealiza leitura total do arquivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
While nReadTot < nTotal
   cBuffer  := Space(nBuffer)
   nRead    := FRead(nHdl,@cBuffer,nBuffer)
   nReadTot += nRead
   If (nRead <> nBuffer .and. nReadTot <> nTotal)
      MsgStop("Erro na leitura do arquivo !","Aviso")
      Break
   EndIf
Enddo
            
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณRecupera os dados do bufferณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If Len(cBuffer) > 0

	nPOSATUAL := 1                           
	cSRT := CHR(10) //CHR(13)+CHR(10)
	fGetTXT(cBuffer, @nPOSATUAL, cSRT)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณRetira primeira linha do cabe็alho do bufferณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cBuffer := SubSTR(cBuffer,nPOSATUAL,Len(cBuffer))
	cBufSUB := ""
	          
	nRegistro := 0
	nITEM := 1                                        
	
	While lFLAG
		cSRT := CHR(10) //CHR(13)+CHR(10)
		nPOSATUAL := 1
		nLIN += 1
		fGetTXT(cBuffer, @nPOSATUAL, cSRT)
		cBufSUB := ""
		cBufSUB := SubSTR(cBuffer,1,nPOSATUAL-2)
		cBuffer := SubSTR(cBuffer,nPOSATUAL,Len(cBuffer))
		nPOSATUAL2 := 1
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณHavendo carregado informa็๕es, realiza sequ๊ncia เ execu็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		If !EMPTY(cBufSUB)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณConverte , em . para os valores num้ricosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			For nX := 1 To Len(cBufSUB)
				If SUBSTR(cBufSUB, nX, 1) != CHR(10)
					If SUBSTR(cBufSUB, nX, 1) == ',' .AND. SUBSTR(cBufSUB, (nX - 1), 1) != '"' .AND. SUBSTR(cBufSUB, (nX + 1), 1) != '"'
						cAux := ALLTRIM(SUBSTR(cBufSUB, 1, (nX - 1)) + "." + SUBSTR(cBufSUB, (nX + 1), 500))
						cBufSUB := cAux
					EndIf
				EndIf
			Next nX
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณA partir da string obtida, comp๕e array separando os itens pela ,ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			cBufSUB := STRTRAN(cBufSUB, CHR(10), "")
			aDetBUF := STRTOKARR2(cBufSUB, ";", .T.)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณRemove " dos itens do array criadoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			For nX := 1 To Len(aDetBUF)
				aDetBUF[nX] := STRTRAN(aDetBUF[nX], '"', '')
			Next nX
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณConsidera apenas as linhas com 13 itensณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			If Len(aDetBUF) == 20
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณPosiciona no cadastro do Fornecedor vinculado ao item do arquivo CSV posicionadoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				If Len(aDetBUF[1]) == 14
					cProd := SUBSTR(aDetBUF[1],1,9)
				Else
					cProd := SUBSTR(aDetBUF[1],1,8)
				EndIf
				
				dbSelectArea("SA2")
				SA2->(dbSetOrder(1))
				SA2->(dbGoTop())
				SA2->(dbSeek(xFilial("SA2") + cProd))
								
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณCarrega as informa็๕es do CSV ao novo item do aColsDet adicionadoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//If EMPTY(aDetBUF[18])
		//		IF !( "NEGAT" $ aDetBUF[18] .OR. "POSIT" $ aDetBUF[18])
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					//ณAdiciona novo item ao aColsDetณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					AADD(aColsDet, ARRAY(Len(aHeaderDet) + 1))
					For nI := 1 To Len(aHeaderDet)
					   aColsDet[Len(aColsDet)][nI] := CriaVar(aHeaderDet[nI][2])
					Next
					
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_SEQ"})] 	:= cSeq
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_PRODUT"})]	:= SA2->A2_COD
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_LOJPRD"})]	:= SA2->A2_LOJA
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_NOMPRD"})]	:= IIF(!EMPTY(SA2->A2_NOME), SA2->A2_NOME, "")
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_GORD"})]	:= VAL(aDetBUF[4])
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_PROTN"})]	:= VAL(aDetBUF[5])
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_SOLD"})]	:= VAL(aDetBUF[7])
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_LACT"})]	:= VAL(aDetBUF[15])
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_CCS"})]		:= VAL(aDetBUF[8])
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_CBT"})]		:= VAL(aDetBUF[10])
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_DATCOL"})]	:= STOD(SUBSTR(aDetBUF[3], 7, 4) + SUBSTR(aDetBUF[3], 4, 2) + SUBSTR(aDetBUF[3], 1, 2))
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_DATANL"})]	:= STOD(SUBSTR(aDetBUF[11], 7, 4) + SUBSTR(aDetBUF[11], 4, 2) + SUBSTR(aDetBUF[11], 1, 2))
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_INIMIC"})]	:= IIF("POSIT" $ aDetBUF[18], "P", IIF("NEGAT" $ aDetBUF[18], "N", ""))
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIMม(x[2]) == "ZL9_PROTOC"})]	:= aDetBUF[19]
					aColsDet[Len(aColsDet)][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_MEDGEO"})]	:= VAL(aDetBUF[20])
					
					
					aColsDet[Len(aColsDet)][Len(aHeaderDet) + 1] := .F.
					cSeq := SOMA1(cSeq)
		/*		Else
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					//ณLocaliza registro jแ existente de resultados do produtor atual, para adicionar o resultado do INIBIDOR MICROBIOLOGICOณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					For nI := 1 To Len(aColsDet)
						If aColsDet[nI][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_PRODUT"})] == SA2->A2_COD .AND. aColsDet[nI][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_LOJPRD"})] == SA2->A2_LOJA .AND. ;
						   aColsDet[nI][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_DATCOL"})] == STOD(SUBSTR(aDetBUF[3], 7, 4) + SUBSTR(aDetBUF[3], 4, 2) + SUBSTR(aDetBUF[3], 1, 2))    .AND. ;
						   aColsDet[nI][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_DATANL"})] == STOD(SUBSTR(aDetBUF[11], 7, 4) + SUBSTR(aDetBUF[11], 4, 2) + SUBSTR(aDetBUF[11], 1, 2))
						   
						   aColsDet[nI][aScan(aHeaderDet,{|x| ALLTRIM(x[2]) == "ZL9_INIMIC"})]	:= IIF("POSIT" $ aDetBUF[18], "P", IIF("NEGAT" $ aDetBUF[18], "N", ""))
						   exit
						EndIf
					Next nI
				EndIf*/
			EndIf
		Else
			exit
		EndIf				
	Enddo
EndIf	                                                                    

fClose(nHdl)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณFGETTXT   บAutor  ณMarcelo Joner        บ Data ณ 13/01/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela leitura do arquivo CSV conforme os  บฑฑ
ฑฑบ          ณparโmetros repassados.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lat. Silvestre                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FGETTXT(cTXT,nPOSATUAL,cSRT)

Local cRET := ""
Local nI
If nPOSATUAL < Len(cTXT)
	For nI := nPOSATUAL to Len(cTXT)
		If ! SubSTR(cTXT,nI,1) $ cSRT
			cRET += SubSTR(cTXT,nI,1)
		Else                  
			If cSRT == CHR(13)+CHR(10)
				nPOSATUAL := nI+2
			Else                 
				nPOSATUAL := nI+1
			EndIf
			Exit
		EndIf
	Next nI
EndIf

Return cRET
