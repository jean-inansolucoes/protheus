#include "protheus.ch"
#include "rwmake.ch"            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS01  ºAutor  ³ Lincoln Rossetto   º Data ³  07/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável pelo processo de Cadastro do Grupo de   º±±
±±º          ³ condições de Pagamentos.                                   º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LSOMS01()
***********************
Local cAliasH	:= "ZAA"
Local cUsers    := Alltrim( GETMV( "MV_XREGCOM" ) )

If !__CUSERID $ cUsers
   U_LSSHWHLP("Acesso Negado !", ;
               "Você esta tentando acessar uma rotina customizada sem permissão !!",;
	           "Solicite acesso a rotina para continuar. (MV_XREGCOM)" )
	Return( .F. )
Endif

Private cPathExtras   := U_LSALXDIR( "SIGAOMS", "LSOMS01" )
Private cTitulo	      := "Grupo de Condições de Pagamento"
Private aRotina       := MenuDef()

dBSelectArea( cAliasH )
( cAliasH )->( dBSetOrder( 1 ) )
( cAliasH )->( dBGotop( ) )
mBrowse(6, 1,22,75, cAliash)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha a tabela manipulada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( cAliasH ) > 0
	( cAliasH )->( dBCloseArea( ) )
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Lincoln Rossetto    º Data ³  19/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição das sub-rotinas da rotina principal               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MenuDef                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()
*************************
Local aRotina := { { "Pesquisar" , "AxPesqui"  , 0 , 1 } ,;
                   { "Visualizar", "U_LS01VIS" , 0 , 2 } ,;
                   { "Incluir"   , "U_LS01INC" , 0 , 3 } ,;
                   { "Alterar"   , "U_LS01ALT" , 0 , 4 } ,;
                   { "Excluir"   , "U_LS01EXC" , 0 , 5 } }
Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS01VIS  ºAutor  ³Lincoln Rossetto     º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualização de registros         						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS01VIS(cAlias, nReg, nOpc)
*******************************************		
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch   := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE    := "ZAA"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     := ""  	// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.  	//Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.  	//Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.  	//Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .F.  	//Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .F.  	//Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nCntFor 
Local nModelo    := 3  		//Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local aSize      := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}
Local aArea		 := GetArea()  
Local oDlg1	
Local cAliasIT 	 := "ZAB"       
Local cItem	     := "ZAB_ITEM"
Local nPosItem   := 0
Local noMsNewGet     := 0  
Local bCampo     := {|nCPO| Field(nCPO)}
Local aHoMsNewGet    := {}
Local aCoMsNewGet    := {}   
Local oMsNewGet	
Local nOpcNewGd  := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )

Private aGets    := {}
Private aTela	 := {}
Private ALTERA   := .F.
Private INCLUI   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define e Registra os Campos do Enchoice                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea(cAlias)
RegToMemory(cAlias, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui aos Campos registrados os valores do registro da tabela posicionado   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 TO FCount()
	M->&(Eval(bCampo, i)) := FieldGet(i)
Next i 
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa funcao de montagem do aHeader para GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea("SX3")
SX3->( dBSetOrder( 1 ) )
SX3->( dBSeek( "ZAB" ) )
While !Eof() .and. SX3->X3_ARQUIVO == "ZAB"
   If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
      noMsNewGet++
      Aadd( aHoMsNewGet, { AllTrim(X3Titulo()),;
                           SX3->X3_CAMPO   ,;
                           SX3->X3_PICTURE ,;
                           SX3->X3_TAMANHO ,;
                           SX3->X3_DECIMAL ,;
                           SX3->X3_VALID   ,;
                           SX3->X3_USADO   ,;
                           SX3->X3_TIPO    ,;
                           SX3->X3_F3      ,;
                           SX3->X3_CONTEXT ,;
                           SX3->X3_CBOX    ,;
                           SX3->X3_RELACAO ,;
                           ".T."           })
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Utilizado para controle de autoincremento no campo ITEM no GetDados³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	  If ( AllTrim(SX3->X3_CAMPO)== cItem )
	  		nPosItem := noMsNewGet
	  Endif  
   EndIf        
   DbSkip()
End                         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea(cALiasIT)
(cALiasIT)->( dbSetOrder( 2 ) ) 
If (cALiasIT)->( mSSeek( xFilial( cALiasIT ) + ZAA->ZAA_CODIGO ) )
	While !(cALiasIT)->(Eof()) .AND. xFilial(cALiasIT) == ZAB->ZAB_FILIAL .AND.	ZAB->ZAB_CODIGO == ZAA->ZAA_CODIGO
		If (SOFTLOCK(cALiasIT))
			AADD(aCoMsNewGet, Array(noMsNewGet + 1))
			For nX := 1 To noMsNewGet
				If aHoMsNewGet[ nX ][10] != "V"
					If !Empty(nPosZAB := FieldPos(aHoMsNewGet[ nX ][ 2 ] ) )
						aCoMsNewGet[Len(aCoMsNewGet)][ nX ] := (cALiasIT)->(FieldGet(nPosZAB))
					EndIf
				Else
					aCoMsNewGet[Len(aCoMsNewGet)][ nX ] := CriaVar(aHoMsNewGet[ nX ][ 2 ])
				EndIf
			Next
			aCoMsNewGet[Len(aCoMsNewGet)][noMsNewGet + 1] := .F.
		Else
			lTravas := .T.
		EndIf
		(cALiasIT)->(dBSkip())
	EndDo                             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 20, .T., .T. } )
	AAdd( aObjects, { 100, 120, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
		
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
	DEFINE MSDIALOG oDlg1 TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL   
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³ Campos do Cabeçalho                                          ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Enchoice(cAlias,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlg1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	   	
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³ Grid de Exibição                                             ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMsNewGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,'AllwaysTrue()','AllwaysTrue()',"+" + cItem,,0,500,'AllwaysTrue()',.F.,.F.,oDlg1,aHoMsNewGet,aCoMsNewGet)
		
	ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| oDlg1:End()}, {|| oDlg1:End()})
EndIf                        

RestArea(aArea)

If Select(cAliasIT) > 0
	(cAliasIT)->(dBCloseArea())
Endif

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS01INC  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusao de registros										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS01INC(cAlias, nReg, nOpc)
******************************************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch   := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE    := "ZAA"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     := ""  	// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.  	//Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.  	//Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.  	//Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .F.  	//Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .F.  	//Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nCntFor 
Local nModelo    := 3  		//Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nRegE      := 0  		//Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)     
Local aSize      := {}
Local aObjects   := {}
Local aInfo      := {}
Local aPosObj    := {}      
Local oDlgInc          
Local bCampo     := {|nCPO| Field(nCPO)}
Local cItem	     := "ZAB_ITEM"
Local nPosItem   := 0
Local nOpcao	 := 1

Private nOpcNewGd  := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Private cPhFinal
Private aCoMsNewGet  := {}
Private aHoMsNewGet  := {}
Private noMsNewGet   := 0
Private oMsNewGet
Private aGets    := {}
Private aTela	 := {}
Private ALTERA   := .F.
Private INCLUI   := .T.       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa funcao de montagem do aHeader para GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea( "SX3" )
SX3->( dBSetOrder( 1 ) )
SX3->( dBGoTop(  ) )
SX3->( dBSeek( "ZAB" ) )
While !Eof() .and. SX3->X3_ARQUIVO == "ZAB"
   If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
      noMsNewGet++
      Aadd( aHoMsNewGet, { AllTrim(X3Titulo()),;
                           SX3->X3_CAMPO      ,;
                           SX3->X3_PICTURE    ,;
                           SX3->X3_TAMANHO    ,;
                           SX3->X3_DECIMAL    ,;
                           SX3->X3_VALID      ,;
                           SX3->X3_USADO      ,;
                           SX3->X3_TIPO       ,;
                           SX3->X3_F3         ,;
                           SX3->X3_CONTEXT    ,;
                           SX3->X3_CBOX       ,;
                           SX3->X3_RELACAO    ,;
                           ".T."              })
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Utilizado para controle de autoincremento no campo ITEM no GetDados³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	  If ( AllTrim(SX3->X3_CAMPO)== cItem )
	  		nPosItem := noMsNewGet
	  Endif  
   EndIf        
   SX3->( dBSkip() )
End                         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa montagem do aCols para GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCoMsNewGet,Array(noMsNewGet+1))
For nI := 1 To noMsNewGet
   aCoMsNewGet[ 1 ][ nI ] := CriaVar(aHoMsNewGet[nI][2])
Next
aCoMsNewGet[ 1 ][ noMsNewGet+1 ] := .F.
aCoMsNewGet[ 1 ][ nPosItem     ] := StrZero(1,TamSx3(cItem)[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos parâmetros para criação da tela de exibição     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()
AAdd( aObjects, { 100, 20, .T., .T. } )
AAdd( aObjects, { 100, 120, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
DEFINE MSDIALOG oDlgInc TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL   
	RegToMemory(cAliasE, INCLUI, .F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pega os dados dos campos da tabela ZC3 no SX3 para montagem do Enchoice³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBSeek( cAliasE ) )
	While !SX3->( Eof() ) .And. ( SX3->X3_ARQUIVO == cAliasE )
	   If X3USO( SX3->X3_USADO ) .and. cNivel >= SX3->X3_NIVEL
	      AADD( aCpoEnch, SX3->X3_CAMPO )
	      If SX3->X3_VISUAL # "V"
	         AADD( aAlterEnch, SX3->X3_CAMPO )
	      Endif
	   Endif
	   SX3->( dBSkip() )
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos do Cabeçalho                                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Enchoice(cAliasE,nRegE,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlgInc,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grid de Exibição                                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMsNewGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,'U_LS01LNOK()','U_LS01LNOK()',"+" + cItem,,0,500,'U_LS01CPOK( .F. )',.F.,.F.,oDlgInc,aHoMsNewGet,aCoMsNewGet)
	
ACTIVATE MSDIALOG oDlgInc ON INIT EnchoiceBar(oDlgInc,{|| If(oMsNewGet:TudoOk() .AND. Obrigatorio(aGets, aTela), oDlgInc:End(),)}, {||nOpcao := 0, oDlgInc:End()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso esteja tudo validado, efetua a gravação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcao == 1
	LSOMSGRV(nOpc, oMsNewGet)
Else
	RollBackSX8()
EndIf	

Return Nil 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS01ALT  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alteracao de registros            						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS01ALT(cAlias, nReg, nOpc)
******************************************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local aArea		  := GetArea()  
Local aAlterEnch  := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch    := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE     := "ZAA"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela      := ""  	// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn     := .F.  	//Indica se a apresentacao dos campos sera em forma de coluna
Local lF3         := .F.  	//Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria    := .T.  	//Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder   := .F.  	//Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty   := .F.  	//Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo     := 3  		//Se for diferente de 1 desabilita execucao de gatilhos estrangeiros   
Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aCoMsNewGet := {}
Local aHoMsNewGet := {} 
Local bCampo      := {|nCPO| Field(nCPO)}
Local cAliasIT    := "ZAB"       
Local cItem	      := "ZAB_ITEM"
Local nPosItem    := 0
Local noMsNewGet  := 0    
Local nOpcNewGd   := 0
Local oDlg1	
Local nOpcao	  := 1
Local nCntFor 
Local lOk         := .T.
Local cValidaCPO  := ""

Private cPhFinal
Private aGets     := {}
Private aTela	  := {}
Private ALTERA    := .T.
Private INCLUI    := .F.
             

MsAguarde( { || lOk := LS01VERSC5( nOpc  ) }, "Aguarde, verificando dependências..." )

If !lOk
   nOpcNewGd   := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_UPDATE )
   cValidaCPO  := 'U_LS01CPOK(.T.)'
Else
   nOpcNewGd   := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
   cValidaCPO  := 'U_LS01CPOK(.F.)'
Endif              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define e Registra os Campos do Enchoice                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea(cAlias)
RegToMemory(cAlias, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui aos Campos registrados os valores do registro da tabela posicionado   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea(cAlias)
For i := 1 TO FCount()
	M->&( Eval( bCampo, i ) ) := FieldGet(i)
Next i 
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa funcao de montagem do aHeader para GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea("SX3")
SX3->( dBSetOrder( 1 ) )
SX3->( dBSeek( "ZAB" ) ) 
While !Eof() .and. SX3->X3_ARQUIVO == "ZAB"
   If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
      noMsNewGet++
      Aadd(aHoMsNewGet, {AllTrim(X3Titulo()),;
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
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Utilizado para controle de autoincremento no campo ITEM no GetDados³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	  If ( AllTrim(SX3->X3_CAMPO)== cItem )
	  		nPosItem := noMsNewGet
	  Endif  
   EndIf        
   DbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea(cALiasIT)
( cALiasIT )->( dbSetOrder( 2 ) ) 
If (cALiasIT)->(MsSeek( xFilial( cALiasIT ) + ZAA->ZAA_CODIGO ) )
	While !(cALiasIT)->(Eof()) .AND. xFilial(cALiasIT) == ZAB->ZAB_FILIAL .AND.	ZAB->ZAB_CODIGO == ZAA->ZAA_CODIGO
		If (SOFTLOCK(cALiasIT))
			AADD(aCoMsNewGet, Array(noMsNewGet + 1))
			For nX := 1 To noMsNewGet
				If aHoMsNewGet[ nX ][10] != "V"
					If !Empty(nPosZAA := FieldPos(aHoMsNewGet[ nX ][ 2 ] ) )
						aCoMsNewGet[Len(aCoMsNewGet)][ nX ] := (cALiasIT)->(FieldGet(nPosZAA))
					EndIf
				Else
					aCoMsNewGet[Len(aCoMsNewGet)][ nX ] := CriaVar(aHoMsNewGet[ nX ][ 2 ])
				EndIf
			Next
			aCoMsNewGet[Len(aCoMsNewGet)][noMsNewGet + 1] := .F.
		Else
			lTravas := .T.
		EndIf
		(cALiasIT)->(dBSkip())
	EndDo                             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 20, .T., .T. } )
	AAdd( aObjects, { 100, 120, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
		
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
	DEFINE MSDIALOG oDlg1 TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pega os dados dos campos da tabela ZC3 no SX3 para montagem do Enchoice³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( "SX3" )
		SX3->( dBSetOrder( 1 ) )
		SX3->( dBSeek( cAliasE ) )
		While !SX3->( Eof() ) .and. ( SX3->X3_ARQUIVO == cAliasE )
	   		If X3USO( SX3->X3_USADO ) .and. cNivel >= SX3->X3_NIVEL
	      		AADD( aCpoEnch, SX3->X3_CAMPO )
	      		If SX3->X3_VISUAL # "V"
	         		AADD( aAlterEnch, SX3->X3_CAMPO )
	      		Endif
	   		Endif
	   		SX3->( dBSkip() )
		End  	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³ Campos do Cabeçalho                                          ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Enchoice(cAlias,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlg1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	   	
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³ Grid de Exibição                                             ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMsNewGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,'U_LS01LNOK()','U_LS01LNOK()',"+" + cItem,,0,500,cValidaCPO,"",,oDlg1,aHoMsNewGet,aCoMsNewGet)  
		
	ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| If(oMsNewGet:TudoOk() .AND. Obrigatorio(aGets, aTela), oDlg1:End(),)}, {||nOpcao := 0, oDlg1:End()})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso esteja tudo validado, efetua a gravação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcao == 1
	   LSOMSGRV(nOpc, oMsNewGet)
	EndIf
EndIf                        

Return Nil                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS01CPOK ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação da Alteração da Condição de Pagamento             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS01CPOK( lValida )
*********************************
Local lRet   := .T.
Local lFaixa := GETMV( "MV_XFXACND" )

If ReadVar() == "M->ZAB_COND" .And. lValida
	lRet := .F.
	U_LSSHWHLP("Grupo de Condição", "Você esta tentando alterar uma Condição de Pagamento de um Grupo de Condições que já esta sendo utilizando em um ou mais pedidos, impossivel prosseguir.", "Não tente alterar a Condição de Pagamento" )
	
ElseIf ReadVar() == "M->ZAB_COND" .And. !lValida
	If lFaixa
		If ( ( Alltrim( M->ZAB_COND ) <> "000" ) .And. ( Alltrim( M->ZAB_COND ) < "500" ) )
			lRet := .F.
			U_LSSHWHLP("Grupo de Condição", "Condição de Pagamento fora da Faixa a ser utilizada no Faturamento.", "Utilize a faixa de Códigos de Condições de Pagamento acima de 500" )
		Endif
	Endif
Endif

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS01EXC  ºAutor  ³Lincoln Rossetto    º Data  ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclusao  de registros            						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS01EXC(cAlias, nReg, nOpc)
******************************************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch  := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch    := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE     := "ZAA"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela      := ""  	// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn     := .F.  	//Indica se a apresentacao dos campos sera em forma de coluna
Local lF3         := .F.  	//Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria    := .T.  	//Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder   := .F.  	//Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty   := .F.  	//Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nCntFor     := 0
Local nModelo     := 3  		//Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aArea		  := GetArea()  
Local cAliasIT 	  := "ZAB"       
Local cItem	      := "ZAB_ITEM"
Local nPosItem    := 0
Local noMsNewGet  := 0  
Local bCampo      := {|nCPO| Field(nCPO)}
Local aHoMsNewGet := {}
Local aCoMsNewGet := {}   
Local nOpcNewGd   := 0
Local nOpcao	  := 1
Local lOk         := .T.
Local oMsNewGet	
Local oDlg1	

Private aGets    := {}
Private aTela	 := {}
Private ALTERA   := .F.
Private INCLUI   := .F.

MsAguarde( { || lOk := LS01VERSC5( nOpc  ) }, "Aguarde, verificando dependências..." )

If !lOk
   Return( .F. )
Endif              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define e Registra os Campos do Enchoice                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea(cAlias)
RegToMemory(cAlias, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui aos Campos registrados os valores do registro da tabela posicionado   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 TO FCount()
	M->&(Eval(bCampo, i)) := FieldGet(i)
Next i 
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa funcao de montagem do aHeader para GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea("SX3")
SX3->( dBSetOrder( 1 ) )
SX3->( dBSeek( "ZAB" ) )
While !Eof() .and. SX3->X3_ARQUIVO == "ZAB"
   If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
      noMsNewGet++
      Aadd( aHoMsNewGet, { AllTrim(X3Titulo()),;
                           SX3->X3_CAMPO   ,;
                           SX3->X3_PICTURE ,;
                           SX3->X3_TAMANHO ,;
                           SX3->X3_DECIMAL ,;
                           SX3->X3_VALID   ,;
                           SX3->X3_USADO   ,;
                           SX3->X3_TIPO    ,;
                           SX3->X3_F3      ,;
                           SX3->X3_CONTEXT ,;
                           SX3->X3_CBOX    ,;
                           SX3->X3_RELACAO ,;
                           ".T."           })
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Utilizado para controle de autoincremento no campo ITEM no GetDados³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	  If ( AllTrim(SX3->X3_CAMPO)== cItem )
	  		nPosItem := noMsNewGet
	  Endif  
   EndIf        
   DbSkip()
End                         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea(cALiasIT)
(cALiasIT)->(dbSetOrder( 2 ) ) 
If (cALiasIT)->( mSSeek(xFilial(cALiasIT ) + ZAA->ZAA_CODIGO ) )
	While !(cALiasIT)->(Eof()) .AND. xFilial(cALiasIT) == ZAB->ZAB_FILIAL .AND.	ZAB->ZAB_CODIGO == ZAA->ZAA_CODIGO
		If (SOFTLOCK(cALiasIT))
			AADD(aCoMsNewGet, Array(noMsNewGet + 1))
			For nX := 1 To noMsNewGet
				If aHoMsNewGet[ nX ][10] != "V"
					If !Empty(nPosZAB := FieldPos(aHoMsNewGet[ nX ][ 2 ] ) )
						aCoMsNewGet[Len(aCoMsNewGet)][ nX ] := (cALiasIT)->(FieldGet(nPosZAB))
					EndIf
				Else
					aCoMsNewGet[Len(aCoMsNewGet)][ nX ] := CriaVar(aHoMsNewGet[ nX ][ 2 ])
				EndIf
			Next
			aCoMsNewGet[Len(aCoMsNewGet)][noMsNewGet + 1] := .F.
		Else
			lTravas := .T.
		EndIf
		(cALiasIT)->(dBSkip())
	EndDo                             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 20, .T., .T. } )
	AAdd( aObjects, { 100, 120, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
		
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 
	DEFINE MSDIALOG oDlg1 TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL   
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³ Campos do Cabeçalho                                          ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Enchoice(cAlias,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlg1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	   	
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³ Grid de Exibição                                             ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMsNewGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcNewGd,'AllwaysTrue()','AllwaysTrue()',"+" + cItem,,0,500,'AllwaysTrue()',.F.,.F.,oDlg1,aHoMsNewGet,aCoMsNewGet)
		
	ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| If(oMsNewGet:TudoOk() .AND. Obrigatorio(aGets, aTela), oDlg1:End(),)}, {||nOpcao := 0, oDlg1:End()})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso esteja tudo validado, efetua a gravação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcao == 1
	   LSOMSGRV(nOpc, oMsNewGet)
	EndIf

EndIf                        

Return Nil
                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS01VERSC5 ºAutor  ³Lincoln Rossetto   º Data ³  23/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função implementada para validar se a tabela de faixa de PH º±±
±±º          ³a qual esta sendo excluída já esta utilizada em melhoria PH º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS01                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LS01VERSC5( nOpc )
**********************************
Local lRet     := .T.          
Local cQuery   := ""
Local hEnter   := Chr( 13 ) 
Local cTMPSC5  := GetNextAlias()
Local aProcess := iif( nOpc == 4, { "Alterar","Alterado" },  { "Excluir","Excluido" } )

cQuery := "SELECT COUNT( * ) C5_N_RECS" + hEnter
cQuery += "  FROM " + RetSqlName( "SC5" ) + " SC5 " + hEnter
cQuery += " WHERE SC5.C5_FILIAL    = '" + xFilial( "SC5" ) + "'" + hEnter
cQuery += "   AND SC5.C5_X_TBPRC  IN ( SELECT ZAC.ZAC_CODIGO" + hEnter
cQuery += "                              FROM " + RetSqlName( "ZAC" ) + " ZAC" + hEnter
cQuery += "                             WHERE ZAC.D_E_L_E_T_  <> '*'" + hEnter
cQuery += "                               AND ZAC.ZAC_GRPCND   = '" + ZAA->ZAA_CODIGO + "'"  +  hEnter
cQuery += "                               AND ZAC.ZAC_FILIAL   = '" + xFilial( "ZAC" ) + "')" +  hEnter
cQuery += "   AND SC5.D_E_L_E_T_  <> '*'" + hEnter

MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery )

cQuery := ChangeQuery( cQuery )

If Select( cTMPSC5 ) > 0
	( cTMPSC5 )->( dBclosearea( ) )
	Ferase( Lower( cTMPSC5 ) + GetDBExtension( ) )
	Ferase( Lower( cTMPSC5 ) + OrdBagExt( ) )
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cTMPSC5, .F., .T.)

If ( cTMPSC5 )->C5_N_RECS > 0
    If nOpc == 4
       Aviso("Grupo de Condições","Já existe pelo menos uma Tabela de Preço utilizando o Grupo de Condições. Não será possivel adicionar novas Condições de Pagamento entretanto será possivel alterar as Variações e o Preço Base." , {"OK"} ,2)
    Else
       Aviso("Grupo de Condições","Já existe pelo menos uma Tabela de Preço utilizando o Grupo de Condições. Não será possivel excluir o Grupo de Condições." , {"OK"} ,2)
    Endif
	lRet := .F.
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS01LNOK    ºAutor  ³Lincoln Rossetto   º Data ³ 07/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para validar a mudanca de linha no GetDadosº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS01                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LS01LNOK()
************************           
Local lRet		  := .T.   
Local nPosCond    := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZAB_COND"   } )
Local nPosPrBse   := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZAB_PRECOB" } )
Local cCondAtual  := aCols[ n ][ nPosCond  ]
Local cPrecoBase  := aCols[ n ][ nPosPrBse ]
Local nI          := 0

For nI := 1 To Len( aCols )
	If nI <> n
		If !aCols[ nI ][ Len( aHeader ) + 1 ]
			If aCols[ nI ][ nPosCond ] == cCondAtual
				lRet := .F.
				U_LSSHWHLP("Grupo de Condição de Pagamento",;
				           "Já existe item com a Condição de Pagamento informada.",;
				           "Não pode existir mais de um item com a mesma Condição de Pagamento.")
			EndIf
		Endif
	EndIf
Next nI

If lRet
	For nI := 1 To Len( aCols )
		If nI <> n
			If !aCols[ nI ][ Len( aHeader ) + 1 ]
				If aCols[ nI ][ nPosPrBse ] == cPrecoBase .And. Alltrim( cPrecoBase ) == "1"
					lRet := .F.
					U_LSSHWHLP( "Grupo de Condição de Pagamento",;
					            "Já existe item informado a Condição de Pagamento é o Preço Base.",;
					            "Não pode existir mais de um item como Preço Base.")
				EndIf
			Endif
		EndIf
	Next nI
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSOMSGRV  ºAutor  ³Lincoln Rossetto    º Data ³  19/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para efetur a gravação dos dados nas tabelaº±±
±±º          ³ZAA (Cabeçalho) e ZAB (Itens)                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS01                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMSGRV(nOpc, oMsNewGet)                     
*****************************************
Local aHeader   := oMsNewGet:aHeader      
Local aCols	    := oMsNewGet:aCols
Local cNumCod   := M->ZAA_CODIGO
Local cCodigo   := ""
Local cItem     := "ZAB_ITEM"
Local cMay      := "ZAA" + ALLTRIM(xFilial("ZAA")) + cNumCod
Local nPosCond  := aScan( aHeader,{ |x| AllTrim( x[2] ) == "ZAB_COND" } )
Local nPosItem  := aScan( aHeader,{ |x| AllTrim( x[2] ) == cItem      } )
Local nUsado    := Len(aHeader)
Local nLenGet   := oMsNewGet:nAt
Local nPosZCI   := 0
Local nItem     := 0
Local lGravou   := .F.          
Local nCont	    := 0
Local cQuery    := ""
Local hEnter    := Chr( 13 )
Local cAliasZAC := ""
Local cItProd   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seta estilo do ponteiro do mouse como "processando"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CursorWait( )  
SysRefresh()

Do Case  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para inclusao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	Case nOpc == 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx”[¿
		//³Verifica se não existe registro com a mesma chave na ZC3³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx”[Ù
  		While ( MsSeek( xFilial( "ZAA" ) + cNumCod ) .OR. !MayIUseCode( cMay ) ) 
    		cNumCod       := Soma1( cNumCod,Len( cNumCod ) )
        	cMay          := "ZAA" + ALLTRIM( xFilial("ZAA" ) ) + cNumCod 
        	M->ZAA_CODIGO := cNumCod
     	EndDo
     	
  		BEGIN TRANSACTION        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravação dos dados do cabeçalho (ZAA)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 		dBSelectArea("ZAA")
	     	ZAA->(dbSetOrder(1))
	      	RecLock("ZAA",.T.)
	       	For nI := 1 To ZAA->( FCount() )
	        	If ZAA->(FieldName( nI ) )  == "ZAA_FILIAL" 
	            	FieldPut( nI, xFilial( "ZAA" ) )
	            Else                             
	                FieldPut( nI, M->&( FieldName( nI ) ) )
	            Endif
	         Next
	         
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação dos dados dos itens (ZAB)   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        	For nX := 1 To Len( aCols )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Verifica se o item no aCols não esta deletado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
         		If !aCols[ nX ][ nUsado+1 ] 
         			dBSelectArea("ZAB")
         			ZAB->( dBSetOrder( 2 ) )        
					RECLOCK( "ZAB", .T. )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Laço para gravação de todos os campos do item presentes no GetDados³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         			For nY := 1 To nUsado   
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o campo não é Virtual³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          				If aHeader[ nY ][ 10 ] != "V"
          					If !Empty(nPosZAB := FieldPos( aHeader[ nY ][ 2 ] ) )
               					ZAB->( FieldPut( nPosZAB, aCols[ nX ][ nY ] ) ) 
          					EndIf        
          				EndIf
         			Next nY                             
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava campos do item os quais não estao no GetDados³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         			ZAB->ZAB_FILIAL := xFilial( "ZAB" )
         			ZAB->ZAB_CODIGO := M->ZAA_CODIGO
         		EndIf 
           	Next nX          
           	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Terminou de gravar os itens, confirma a gravação do cabeçalho³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	ZAA->( MsUnLock( ) )
            ZAB->( MsUnLock( ) )
           	lGravou := .T.

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 	
			//³Dispara gatilhos e confirma o valor do sequencial utilizado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
           	FreeUsedCode()
			If (lGravou)
				EvalTrigger()
        		ConfirmSx8()
     		EndIf
		END TRANSACTION 
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para Alteracao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nOpc == 4
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄí
		//³Inicia procedimentos de gravação dos dados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄí
  		BEGIN TRANSACTION        
  			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verificando Tabela ZAE para no caso da inclusão de uma Condição de Pagamento ³
			//³ seja replicado para a tabela a Condição x Produtos                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "  SELECT ZAC.* " + hEnter
			cQuery += "    FROM " + RetSqlName( "ZAC" ) + " ZAC " + hEnter
			cQuery += "   WHERE ZAC.ZAC_FILIAL    = '" + xFilial( "ZAC" ) + "'" + hEnter
			cQuery += "     AND ZAC.ZAC_GRPCND    = '" + M->ZAA_CODIGO + "'" + hEnter
			cQuery += "     AND ZAC.D_E_L_E_T_   <> '*'" + hEnter
			cQuery += "ORDER BY ZAC.ZAC_CODIGO"          + hEnter
						
			MemoWrite( cPathExtras + ProcName() + "_A.SQL", cQuery )
					
			cAliasZAC := GetNextAlias()
						
			If Select( cAliasZAC ) > 0
				( cAliasZAC )->( dBclosearea( ) )
				Ferase( Lower( cAliasZAC ) + GetDBExtension( ) )
				Ferase( Lower( cAliasZAC ) + OrdBagExt( ) )
			Endif

			cQuery := ChangeQuery( cQuery )
					
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasZAC, .F., .T.)
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação dos dados do cabeçalho (ZC3)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 		dBSelectArea( "ZAA" )
	     	ZAA->( dbSetOrder( 1 ) )
	     	If ZAA->( dbSeek( xFilial( "ZAA" ) + M->ZAA_CODIGO ) )
	      		RECLOCK( "ZAA", .F. )
	       		For nI := 1 To ZAA->( FCount() )
	        		If ZAA->( FieldName( nI ) ) == "ZAA_FILIAL" 
	            		FieldPut( nI, xFilial( "ZAA" ) )
	            	Else                             
	            	    FieldPut( nI, M->&( FieldName( nI ) ) )
	            	Endif
	         	Next
	         	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Gravação dos dados dos itens (ZAB)   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        		For nX := 1 To Len( aCols )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Verifica se o item no aCols não esta deletado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
         			If !aCols[ nX ][ nUsado+1 ] 
         				
         				dBSelectArea( "ZAB" )
         				ZAB->( dBSetOrder( 2 ) )        
         				If ZAB->( dBSeek( xFilial( "ZAB" ) + M->ZAA_CODIGO + aCols[ nX ][ nPosItem ] ) )
					     	RECLOCK("ZAB", .F.)
				     	Else
					    	RECLOCK("ZAB",.T.)
				     	EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Laço para gravação de todos os campos do item presentes no GetDados³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         				For nY := 1 To nUsado   
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o campo não é Virtual³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          					If aHeader[ nY ][ 10 ] != "V"
          						If !Empty(nPosZAB := FieldPos(aHeader[ nY ][ 2 ] ) )
               						ZAB->(FieldPut(nPosZAB, aCols[ nX ][ nY ] ) ) 
          						EndIf        
          					EndIf
         				Next nY                                            
         				nCont++

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Grava campos do item os quais não estao no GetDados³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         				ZAB->ZAB_FILIAL := xFilial( "ZAB" )
         				ZAB->ZAB_ITEM	:= StrZero( nCont, TAMSX3( cItem )[ 1 ] )
         				ZAB->ZAB_CODIGO	:= M->ZAA_CODIGO
         				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Atualização das Tabelas de Preços                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   			( cAliasZAC )->( dBGoTop( ) )
         				while !( cAliasZAC )->( Eof( ) )
         				        dBSelectArea( "ZAD" )
         				        ZAD->( dBSetOrder( 2 ) )
         				        ZAD->( dBGoTop( ) )
         				        If ZAD->( MsSeek( xFilial( "ZAD" ) + ( cAliasZAC )->ZAC_CODIGO ) )
                                    while !ZAD->( Eof( ) ) .And. ( ZAD->ZAD_FILIAL == xFilial( "ZAD" ) ) .And. ( ZAD->ZAD_CODIGO == ( cAliasZAC )->ZAC_CODIGO )
	         				        	dBSelectArea( "ZAE" )
	         				        	ZAE->( dBSetOrder( 6 ) )
	         				        	ZAE->( dBGoTop( ) )
	         				        	If !ZAE->( MsSeek( xFilial( "ZAE" ) + ( cAliasZAC )->ZAC_CODIGO + ZAD->ZAD_PRODUT + aCols[ nX ][ nPosCond ] ) )

	         				        		dBSelectArea( "ZAE" )
	         				        		ZAE->( dBSetOrder( 2 ) )
	         				        		ZAE->( dBGoTop( ) )
	         				        	
	         				            	RecLock( "ZAE", .T. )
	         				            	ZAE->ZAE_FILIAL := xFilial( "ZAE" )
	         				            	ZAE->ZAE_CODIGO := ( cAliasZAC )->ZAC_CODIGO
	         				            	ZAE->ZAE_ITEM   := ZAE->ZAE_ITEM
	         				            	ZAE->ZAE_PRODUT := ZAD->ZAD_PRODUT
	         				            	ZAE->ZAE_COND   := aCols[ nX ][ nPosCond ]
	         				            	ZAE->ZAE_VALOR  := 0
	         				            	ZAE->( MsUnlock( ) )
	         				            	cItProd += ZAE->ZAE_FILIAL + " " + ( cAliasZAC )->ZAC_CODIGO + " " + ZAE->ZAE_ITEM + " " + ZAD->ZAD_PRODUT + " " + aCols[ nX ][ nPosCond ] + CHR( 10 ) + CHR( 13 )
	         				           
	         				        	Endif
	         				        	ZAD->( dBSkip( ) )
									Enddo
	         					Endif
	         					( cAliasZAC )->( dBSkip( ) )
						Enddo
      				Else     
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Trata-se de alteração eliminando o item da tabela³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      					dBSelectArea( "ZAB" )
         				ZAB->( dBSetOrder( 2 ) )        
         				If ZAB->( dBSeek( xFilial( "ZAB" ) + M->ZAA_CODIGO + aCols[ nX ][ nPosItem ] ) )
						 	RECLOCK( "ZAB", .F. )
      						ZAB->( dBDelete( ) )
      					EndIf
         			EndIf 
           		Next nX          

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Terminou de gravar os itens, confirma a gravação do cabeçalho³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           		ZAA->( MsUnLock( ) )
				ZAB->( MsUnLock( ) )
           		lGravou := .T.
			EndIF
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 	
			//³Dispara gatilhos e confirma o valor do sequencial utilizado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			FreeUsedCode()           	
			If (lGravou)
				EvalTrigger()
     		EndIf
     		
		END TRANSACTION        
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para Exclusao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OtherWise
     	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄí
		//³Inicia procedimentos de exclusao dos dados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄí
  		BEGIN TRANSACTION        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exclusao dos dados do cabeçalho (ZC3)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 		dBSelectArea("ZAA")
	     	ZAA->(dBSetOrder(1))
	     	If ZAA->( dBSeek( xFilial("ZAA") + M->ZAA_CODIGO ) ) 
	      		RECLOCK( "ZAA", .F. )
	    		ZAA->( dBDelete( ) )
	    		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Exclusao dos dados dos itens³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	    		dBSelectArea( "ZAB" )
       			ZAB->( dBSetOrder( 1 ) )        
         		
         		If ZAB->( dBSeek( xFilial( "ZAB" ) + M->ZAA_CODIGO ) )
					While !ZAB->( EOF( ) ) .AND. ZAB->ZAB_CODIGO == M->ZAA_CODIGO .And. ZAB->ZAB_FILIAL == xFilial( "ZAB" )
						RECLOCK( "ZAB", .F.)						
					 	ZAB->( dBDelete( ) )
					   	ZAB->( dbSkip( ) )
					EndDo
				EndIf 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÜ
				//³Confirma exclusao do cabecalho e dos itens³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÜ
				ZAA->( MsUnLock( ) )    		
				ZAB->( MsUnLock( ) )
				lGravou := .T.
	    	EndIf      
	    	
	    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 	
			//³Dispara gatilhos e confirma o valor do sequencial utilizado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			FreeUsedCode()           	
			If (lGravou)
				EvalTrigger()
     		EndIf
     	END TRANSACTION  
EndCase

Aviso( "Atenção", cItProd, { "OK" }, 3 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄo
//³Restaura ponteiros do mouse³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄo
CursorArrow()  
SysRefresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Efetua procedimentos para fechar o Alias manipulado (ZC4)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If Select("ZAB") > 0
	ZAB->(dBCloseArea())
EndIf

Return( lGravou )