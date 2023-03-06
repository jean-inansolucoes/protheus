#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA080MNU  ºAutor  ³Luiz Gamero Prado   º Data ³  06/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para adicionar nos opçoes a rotina de      º±±
±±º          ³cadastro de TES.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Totvs Paraná Central                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA080MNU()
Local aRotina := ParamIxb[1]
 //AADD(aRotina,{"Copiar", "U_MATA080CPO", 0, 3, 2, NIL})
// ADD OPTION aRotina TITLE "Copiar" ACTION 'U_MATA080CPO' OPERATION 4 ACCESS 0 //"Executa Função"


Return  aRotina


                                   
                                   
                                   
                                   
                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATA080CPO ºAutor ³Luiz Gamero prado   º Data ³  06/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de cópia do cadastro de TES.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Totvs Paraná Central                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATA080CPO(cAlias, nReg, nOpc)

Local aSize     := MsAdvSize() 
Local aInfo     := {} 
Local aObjects  := {} 
Local aObj      := {}
Local aNoFields := {"FC_TES"}
Local bCampo    := {|nCPO| Field(nCPO)}
Local bCondicao := {|| .T.}
Local cSeek     := ""
Local cWhile    := ""
Local cCampo    := ""
Local lGravaOk  := .T.
Local nX        := 0
Local nOpca     := 0
Local nRecSF4   := SF4->(Recno())
Local oDlg
Local aHeadCC7	  := {}
Local aColsCC7	  := {}
Local lAjICMS     := AliasIndic("CC6").And.AliasIndic("CC7").And.AliasIndic("CC8").And.AliasIndic("CC9").And.;
					 AliasIndic("CCA").And.AliasIndic("CCB").And.AliasIndic("CCC").And.AliasIndic("CCD")
Local lCalcImpV := GetMV("MV_GERIMPV")=="S"
Local aFolders	:=	{}
Local cOk       := ""
Local aButtons	  := {}
Local aButtonUsr  := {}
Local nPosX		:=	0
Local bSkip		  := IIF(lAjICMS .And. CC7->(FieldPos("CC7_TPREG")) > 0,{|| CC7->CC7_TPREG == "NA" },NIL)

PRIVATE oGetd
PRIVATE aTELA[0][0],aGETS[0]

If SoftLock("SF4") .And. SF4->(LastRec()) <> 0

	aHeader := {}
	aCols	:= {}

	If lCalcImpV
		aAdd(aFolders,"Impostos variáveis")

		dbSelectArea("SFC")
		dbSetOrder(1)
		If dbSeek(xFilial("SFC")+SF4->F4_CODIGO)
			cSeek    := xFilial("SFC")+SF4->F4_CODIGO
			cWhile   := "SFC->FC_FILIAL+SFC->FC_TES"
			bCondicao:= {|| If( SoftLock("SFC") , .T. , .F. ) }
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Sintaxe da FillGetDados(nOpcX,Alias,nOrdem,cSeek,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FillGetDados(nOpc,"SFC",1,cSeek,{|| &cWhile },bCondicao,aNoFields,,,,,,,,,,,)
		Else
			FillGetDados(nOpc,"SFC",1,,,,aNoFields,,,,,.T.,,,,,)
			aCols[1][aScan(aHeader,{|x| Trim(x[2])=="FC_SEQ"})] := StrZero(1,Len(SFC->FC_SEQ))
		EndIf
	EndIf
	
	If lAjICMS
		Private	oNewGetDad
		
		aAdd(aFolders,"Lançamentos da Apuração de ICMS"	)
		aMHead("CC7","CC7_TES/",@aHeadCC7)
		CC7->(dbSeek(xFilial("CC7")+SF4->F4_CODIGO))
		aMAcols(nOpc,"CC7",@aColsCC7,aHeadCC7,{||CC7->CC7_TES==SF4->F4_CODIGO},bSkip)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a integridade dos campos de Bancos de Dados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF4")
	For nX := 1 to FCount()
		nPosX := aScan(aAutoCab,{|aX|AllTrim(Eval(bCampo,nX))$aX[1]})
		If nPosX<>0
			M->&(Eval(bCampo,nX)) := aAutoCab[nPosX,2]
		Else
			M->&(Eval(bCampo,nX)) := FieldGet(nX)
		EndIf
	Next nX

	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100,  60, .T., .T. } )
	aInfo := { aSize[1],aSize[2],aSize[3],aSize[4],3,3 }
	aObj  := MsObjSize( aInfo, aObjects, .T. )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	                       
	M->F4_CODIGO := SPACE(TAMSX3("F4_CODIGO")[1])
	                       
	EnChoice( "SF4", nReg, nOpc, , , , , aObj[1], , 3 )
	
	oFolder := TFolder():New(aObj[2,1],aObj[2,2],aFolders,{},oDlg,,,,.t.,.f.,aObj[2,4],aObj[2,3],)

	cOk	:=	"{||nOpcA:=1"
	If lCalcImpV
		A081Cab(nOpc)
		oGetd:=MsGetDados():New(0,0,aObj[2,3]-aObj[2,1]-13,aObj[2,4],nOpc,"A081LinOk","A081TudOk","+FC_SEQ",.T.,,,,,,,,,oFolder:aDialogs[1])
		oGetd:oBrowse:bGotFocus:={|| A081Cab(nOpc)}
		If lAjICMS
			cOk	+=	",if(A081TudOk(,nOpc).And.AjusteLOK(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)"
		Else
			cOk	+=	",if(A081TudOk(,nOpc),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)"
		EndIf
	EndIf

	If lAjICMS
		oNewGetDad := MsNewGetDados():New(0,0,aObj[2,3]-aObj[2,1]-13,aObj[2,4],GD_UPDATE+GD_INSERT+GD_DELETE,"AjusteLOK","AllwaysTrue","+CC7_SEQ",{"CC7_CODLAN"},/*freeze*/,990,/*fieldok*/,/*superdel*/,/*delok*/,oFolder:aDialogs[Iif(lCalcImpV,2,1)],@aHeadCC7,@aColsCC7)
		cOk	+=	Iif(lCalcImpV,"",",Iif(AjusteLOK(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca:=0)")
	Else
		cOk	+=	Iif(lCalcImpV,"",",Iif(A081TudOk(,nOpc),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)")
	EndIf
	cOk	+=	"}"

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,&(cOk),{||oDlg:End()},,aButtons)
	
	If nOpcA == 1
		Begin Transaction
			dbSelectArea("SF4")
		    SF4->(dbSetOrder(1))
		    RECLOCK("SF4", .T.)
			    For nI := 1 To FCount()
			    	If FieldName(nI) == "F4_FILIAL" 
			     		FieldPut(nI, xFilial("SF4"))
			       	Else   
			       		FieldPut(nI, M->&(FieldName(nI)))
			        Endif
			    Next
			SF4->(MSUNLOCK()) 
						
			dbSelectArea("CC7")
			For nI := 1 To Len(aColsCC7) 
				If !aColsCC7[nI][Len(aHeadCC7) + 1] .AND. !EMPTY(aColsCC7[nI][2])
			    	RECLOCK("CC7", .T.)
						For nY := 1 To Len(aHeadCC7)
							If aHeadCC7[nY][10] != "V"
		          				If !EMPTY(nPosCC7 := FieldPos(aHeadCC7[nY][2]))
		               				CC7->(FieldPut(nPosCC7, aColsCC7[i][nY])) 
		          				EndIf        
		          			EndIf                
		         		Next nY                  
		         		CC7->CC7_FILIAL := xFilial("SFC")
		         		CC7->CC7_TES	   := M->F4_CODIGO
					CC7->(MSUNLOCK())			        
				EndIf
			Next nI
			
			
			
		End Transaction

	EndIf
Else
	IF SF4->F4_FILIAL <> xFilial("SF4")
		Help(" ",1,"A000FI")
	Endif
EndIf

Return( nOpcA )                                        






/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³aMHead    ³ Autor ³ Gustavo G. Rueda      ³ Data ³05/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para montagem do HEADER do GETDADOS                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias da tabela base para montagem do HEADER      ³±±
±±³          ³cNCmps -> Campos que nao serao considerados no HEADER       ³±±
±±³          ³aH -> array no qual o HEADER serah montado                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function aMHead(cAlias,cNCmps,aH)
Local	lRet	:=	.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos campos de Bancos de Dados            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
While !Eof() .And. (X3_ARQUIVO==cAlias)
	IF X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .and. !(AllTrim(X3_CAMPO)+"/"$cNCmps)
		AADD(aH,{ Trim(X3Titulo()), ;
			AllTrim(X3_CAMPO),;
			X3_PICTURE,;
			X3_TAMANHO,;
			X3_DECIMAL,;
			X3_VALID,;
			X3_USADO,;
			X3_TIPO,;
			X3_F3,;
			X3_CONTEXT,;
			X3_CBOX,;
			X3_RELACAO})
	Endif
	dbSkip()
Enddo
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³aMAcols   ³ Autor ³ Gustavo G. Rueda      ³ Data ³05/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para montagem do ACOLS do GETDADOS                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nOpc -> Opcao do AROTINA                                    ³±±
±±³          ³cAlias -> Alias da tabela base para montagem do HEADER      ³±±
±±³          ³aC -> array no qual o ACOLS serah montado                   ³±±
±±³          ³aH -> array no qual o HEADER serah montado                  ³±±
±±³          ³bCond -> Condicao de loop do while                          ³±±
±±³          ³bSkip -> Condicao para ignorar um registro isolado          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function aMAcols(nOpc,cAlias,aC,aH,bCond,bSkip)
Local	lRet	:=	.T.
Local	nI		:=	0

DEFAULT bSkip 	:= {|| .F. }

dbSelectArea(cAlias)
dbSetOrder(1)
If nOpc#3 .And. !Eof()	//nopc==3 indica INCLUSAO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array aCols com os itens                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aC	:=	{}
	While !Eof() .And. Eval(bCond)
		IF Eval(bSkip)
			dbSkip()
			Loop
		EndIf
		aAdd(aC,Array(Len(aH)+1))
		For nI := 1 To Len(aH)
			aC[Len(aC),nI] := FieldGet(FieldPos(aH[nI,2]))
		Next
		aC[Len(aC),Len(aH)+1] := .F.
		dbSkip()
	End	
Else
	aC				:=	{Array(Len(aH)+1)}
	aC[1,Len(aH)+1]	:=	.F.
	For nI := 1 To Len(aH)
		If aH[nI,10]#"V"
			aC[1,nI]	:=	CriaVar(aH[nI,2])
		EndIf

		If "_SEQ"$aH[nI,2]
			aC[1,nI]	:=	StrZero(1,aH[nI,4])
		EndIf
	Next
EndIf
Return lRet