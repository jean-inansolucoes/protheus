#INCLUDE "TOPCONN.Ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS02  ºAutor  ³ Lincoln Rossetto   º Data ³  07/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável pelo processo de Tabelas de Preço.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
E4_X_CNDMD - C - 03 - * Cnd Pg Bse
E4_X_DESC  - C - 15 - * Descricao
C5_CONDPAG -> U_LS02VTBP() (VALIDACAO)
C5_X_TBPRC -> U_LS02VTBP() (VALIDACAO)
*/
User Function LSOMS02()
***********************
Local cAliasH	:= "ZAC"
Local cUsers    := Alltrim( GETMV( "MV_XREGCOM" ) )

If !__CUSERID $ cUsers
   U_LSSHWHLP("Acesso Negado !", ;
               "Você esta tentando acessar uma rotina customizada sem permissão !!",;
	           "Solicite acesso a rotina para continuar. (MV_XREGCOM)" )
	Return( .F. )
Endif

Private cTitulo	     := "Tabelas de Preço"
Private aRotina      := MenuDef()
Private cPathExtras  := U_LSALXDIR( "SIGAOMS", "LSOMS02" )
Private aCores       := { { "  Dtos( ZAC_DTFIM )  < Dtos( dDataBase ) .And. !Empty( Dtos( ZAC_DTFIM ) )"                        , "DISABLE"   },; //inativa
                          { "( Dtos( ZAC_DTFIM ) >= Dtos( dDataBase ) .Or.   Empty( Dtos( ZAC_DTFIM ) ) ) .And. ZAC_ATIVA =='1'", "ENABLE"    },;
                          { "( Dtos( ZAC_DTFIM ) >= Dtos( dDataBase ) .Or.   Empty( Dtos( ZAC_DTFIM ) ) ) .And. ZAC_ATIVA =='2'", "BR_LARANJA"}}
                                                                           
dBSelectArea( cAliasH )
( cAliasH )->( dBSetOrder( 1 ) )
( cAliasH )->( dBGotop( ) )
mBrowse(6,1,22,75,cAliasH,,,,,,aCores)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha a tabela manipulada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( cAliasH ) > 0
	( cAliasH )->( dBCloseArea( ) )
Endif

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Lincoln Rossetto    º Data ³  04/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição das sub-rotinas da rotina principal               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()
*************************
Local aRotina := { { "Pesquisar" ,"AxPesqui"  , 0 , 1 } ,;
                   { "Visualizar","U_LS02VIS" , 0 , 2 } ,;
                   { "Incluir"   ,"U_LS02INC" , 0 , 3 } ,;
                   { "Alterar"   ,"U_LS02ALT" , 0 , 4 } ,;
                   { "Excluir"   ,"U_LS02EXC" , 0 , 5 } ,;
                   { "Copiar"    ,"U_LS02COP" , 0 , 4 } ,;
                   { "Reajuste"  ,"U_LS02REA" , 0 , 3 } ,;
                   { "Legenda"   ,"U_LS02LEG",  0 , 2 } }
Return( aRotina )    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02LEG   ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para visualizar a legenda do Browse        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LS02LEG()
***********************           
Local cNome    := ""
Local aLegenda := { { "BR_VERMELHO" , OemToAnsi( "Tabela Inativa"        ) },; 
					{ "BR_VERDE"    , OemToAnsi( "Tabela Ativa"          ) },;  
					{ "BR_LARANJA"  , OemToAnsi( "Tabela Inativa Especial" ) } }

BrwLegenda( cTitulo, OemToAnsi( "Status" ), aLegenda  )

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02VIS  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualização de registros         						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02VIS(cAlias, nReg, nOpc)
*******************************************		
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch     := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch       := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE        := "ZAC"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     	 := ""     // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    	 := .F.    // Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        	 := .F.    // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   	 := .T.    // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  	 := .F.    // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  	 := .F.    // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    	 := 3      // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nRegE          := 0  		//Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)     
Local aSize          := {}
Local aObjects       := {}
Local aInfo          := {}
Local aArea		     := GetArea( )  
Local cAliasIT 	     := "ZAD"       
Local bCampo         := {|nCPO| Field(nCPO)}
Local nCntFor 

Private cItem	     := "ZAD_ITEM"
Private nPosItem     := 0
Private noMsNewGet   := 0  
Private aHoMsNewGet  := {}
Private aCoMsNewGet  := {}   
Private aPosObj      := {}
Private aGets        := {}
Private aTela	     := {}
Private nOpcNewGd    := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Private oMsNewGet	
Private oDlgVis
Private INCLUI   	 := .F.
Private ALTERA   	 := .F.
Private DELETA   	 := .F.
Private VISUAL   	 := .T.
Private nColPrcBs    := 0


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
 
If U_LS02001()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 050, .T., .T. } )
	AAdd( aObjects, { 100, 120, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	DEFINE MSDIALOG oDlgVis TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos do Cabeçalho                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Enchoice( cAlias, nReg,nOpc,,,,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,,,,oDlgVis,lF3, lMemoria, lColumn, ,lNoFolder, lProperty )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grid de Exibição                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TGroup():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],"Tabela de Preço - Itens",oDlgVis,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oMsNewGet := MsNewGetDados():New( aPosObj[2,1] + 10,aPosObj[2,2]+5,aPosObj[2,3]-5,aPosObj[2,4]-5,nOpcNewGd,'AllwaysTrue()','AllwaysTrue()',"+" + cItem,,0,500,'AllwaysTrue()',.F.,.F.,oDlgVis,aHoMsNewGet,aCoMsNewGet)
	oMsNewGet:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlgVis ON INIT EnchoiceBar(oDlgVis,{|| oDlgVis:End()}, {|| oDlgVis:End()})
Endif

RestArea(aArea)

If Select(cAliasIT) > 0
	(cAliasIT)->(dBCloseArea())
Endif

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02INC  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusao de registros										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02INC(cAlias, nReg, nOpc)
******************************************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch     := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch       := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE        := "ZAC"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     	 := ""     // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    	 := .F.    // Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        	 := .F.    // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   	 := .T.    // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  	 := .F.    // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  	 := .F.    // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    	 := 3      // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nRegE          := 0  		//Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)     
Local aSize          := {}
Local aObjects       := {}
Local aInfo          := {}
Local bCampo         := {|nCPO| Field(nCPO)}
Local nOpcao	     := 1
Local nCntFor 

Private nOpcNewGd    := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Private aPosObj      := {}
Private aCoMsNewGet  := {}
Private aHoMsNewGet  := {}
Private nPosicoes    := {}
Private aGets        := {}
Private aTela	     := {}
Private ALTERA       := .F.
Private INCLUI       := .T.       
Private nPosItem     := 0
Private noMsNewGet   := 0
Private cItem	     := "ZAD_ITEM"
Private oDlgInc          
Private oMsNewGet
Private cPhFinal
Private nColPrcBs    := 0
Private INCLUI   	 := .T.
Private ALTERA   	 := .F.
Private DELETA   	 := .F.
Private VISUAL   	 := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos parâmetros para criação da tela de exibição     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()
AAdd( aObjects, { 100, 050, .T., .T. } )
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
	Enchoice(cAliasE,nRegE,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlgInc, lF3, lMemoria, lColumn, ,lNoFolder, lProperty )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grid de Exibição                                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TGroup():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],"Tabela de Preço - Itens",oDlgInc,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oMsNewGet := MsNewGetDados():New( aPosObj[2,1] + 10,aPosObj[2,2]+5,aPosObj[2,3]-5,aPosObj[2,4]-5,nOpcNewGd,'U_LS02LNOK()','U_LS02LNOK()',"+" + cItem,,0,500,'U_LS02FLOK()',.F.,.F.,oDlgInc,{},{})
	oMsNewGet:oBrowse:Free()
	
ACTIVATE MSDIALOG oDlgInc ON INIT EnchoiceBar(oDlgInc,{|| If(oMsNewGet:TudoOk() .AND. Obrigatorio(aGets, aTela), oDlgInc:End(),)}, {||nOpcao := 0, oDlgInc:End()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso esteja tudo validado, efetua a gravação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcao == 1
	LSOMSGRV(nOpc, oMsNewGet, .F., {}, {} )
Else
	RollBackSX8()
EndIf	

Return( nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02001  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação/Montagem do aCols                          	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02001( nAction  )
*********************************
Local aAreaSX3  := {}
Local cTitField := ""
Local lReBuild  := .F.
Local nPosProd  := 0
Local lRet      := .T.
Local lAdd      := .F. 

Default nAction := 2

If Len( aHoMsNewGet ) > 0
   lReBuild := .T.
Endif

aCoMsNewGet := {} 
aHoMsNewGet := {} 
noMsNewGet  := 0

If !Empty( M->ZAC_GRPCND )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna Descrição do Grupo de Condições de Pagamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    M->ZAC_DESCGR := POSICIONE( "ZAA", 1, xFilial( "ZAA" ) + M->ZAC_GRPCND, "ZAA->ZAA_DESCRI" )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa funcao de montagem do aHeader para GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBSeek( "ZAD" ) )
	While !SX3->( Eof() ) .and. SX3->X3_ARQUIVO == "ZAD"
		If X3Uso( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL .And. !Alltrim( SX3->X3_CAMPO ) $ "ZAD_ATIVO/ZAD_DTINI/ZAD_DTFIM"
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
			                     iif( nAction == 2, SX3->X3_WHEN , .T.)   ,;
			                     iif( nAction == 2, SX3->X3_VISUAL, "V")  ,;
			                     SX3->X3_VLDUSER    ,; 
			                     SX3->X3_PICTVAR    ,;
			                     SX3->X3_OBRIGAT    ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                })
                                                  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Utilizado para controle de autoincremento no campo ITEM no GetDados³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( AllTrim( SX3->X3_CAMPO ) == cItem )
				nPosItem  := noMsNewGet
			Endif
		EndIf
		SX3->( dBSkip() )
	Enddo
	
	/*
	LPR-24-02-2012
	dBSelectArea( "SX3" )
	SX3->( dBSetOrder( 2 ) )
	SX3->( dBGoTop(  ) )
	SX3->( dBSeek( "ZAE_VLRBAS" ) )
	Aadd( aHoMsNewGet, { AllTrim( X3Titulo( ) ),;
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
	                     SX3->X3_WHEN          ,;
	                     SX3->X3_VISUAL        ,;
	                     SX3->X3_VLDUSER       ,;
	                     SX3->X3_PICTVAR       ,;
			             SX3->X3_OBRIGAT       ,;
	                     NIL                   ,;
	                     NIL                   ,;
	                     NIL                   ,;
	                     NIL                   ,;
	                     NIL                   ,;
	                     NIL                   ,;
	                     NIL                   })
	noMsNewGet++
	*/
	
	
	dBSelectArea( "SX3" )
	SX3->( dBSetOrder( 2 ) )
	SX3->( dBGoTop(  ) )
	SX3->( dBSeek( "ZAE_VALOR" ) )
	
	dBSelectArea( "ZAB" )
	ZAB->( dBSetOrder( 2 ) )
	ZAB->( dBGoTop( ) )
	If ZAB->( mSSeek( xFilial( "ZAB" ) + M->ZAC_GRPCND ) )
		While ( ( !ZAB->( Eof( ) ) ) .And. ( ZAB->ZAB_CODIGO == M->ZAC_GRPCND ) .And. ( ZAB->ZAB_FILIAL == xFilial( "ZAB" ) ) )
			dBSelectArea( "SE4" )
			SE4->( dBSetOrder( 1 ) )
			SE4->( dBGoTop( ) )
			SE4->( dBSeek( xFilial( "SE4" ) + ZAB->ZAB_COND ) )
			
			cTitField := Left( Alltrim( SE4->E4_DESCRI ), 12 )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa funcao de montagem do aHeader para GetDados³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			noMsNewGet++
			Aadd( aHoMsNewGet, { cTitField       ,;
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
			                     SX3->X3_WHEN    ,;
			                     SX3->X3_VISUAL  ,;
			                     SX3->X3_VLDUSER ,;
			                     NIL             ,;
			                     NIL             ,;
			                     NIL             ,;
			                     NIL             ,;
			                     NIL             ,;
			                     NIL             ,;
			                     ZAB->ZAB_PRECOB ,;
			                     noMsNewGet      ,;
			                     ZAB->ZAB_COND   })
			
			If ZAB->ZAB_PRECOB ==  "1"
			   nColPrcBs := noMsNewGet
			Endif

			ZAB->( dBSkip( ) )
			
		Enddo
	    
		dBSelectArea("SX3")
		SX3->( dBSetOrder( 1 ) )
		SX3->( dBSeek( "ZAD" ) )
		While !Eof() .and. SX3->X3_ARQUIVO == "ZAD"
			If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. Alltrim( SX3->X3_CAMPO ) $ "ZAD_ATIVO/ZAD_DTINI/ZAD_DTFIM"
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
			                     iif( nAction == 2, SX3->X3_WHEN , .T.)   ,;
			                     iif( nAction == 2, SX3->X3_VISUAL, "V")  ,;
			                     SX3->X3_VLDUSER    ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                ,;
			                     NIL                })

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Utilizado para controle de autoincremento no campo ITEM no GetDados³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( AllTrim(SX3->X3_CAMPO)== cItem )
					nPosItem := noMsNewGet
				Endif
			EndIf
			SX3->( dBSkip( ) )
		Enddo
	Endif
Endif

If INCLUI
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa montagem do aCols para GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd( aCoMsNewGet, Array( noMsNewGet + 1 ) )
	For nI := 1 To noMsNewGet
		aCoMsNewGet[ 1 ][ nI ] := CriaVar( aHoMsNewGet[ nI ][ 2 ] )
	Next
	
	aCoMsNewGet[ 1 ][ noMsNewGet+1 ] := .F.
	aCoMsNewGet[ 1 ][ nPosItem     ] := StrZero( 1,TamSx3( cItem )[ 1 ] )
	
	If lReBuild
		oMsNewGet:oBrowse:Free()
	Endif
ElseIf ALTERA .OR. DELETA .OR. VISUAL
	nPosItem := aScan( aHoMsNewGet,{ |x| AllTrim( x[ 2 ] ) == cItem        } )
	nPosProd := aScan( aHoMsNewGet,{ |x| AllTrim( x[ 2 ] ) == "ZAD_PRODUT" } )
	
	dBSelectArea( "ZAD" )
	ZAD->( dBSetOrder( 1 ) )
	
	If ZAD->( dBSeek( xFilial( "ZAD" ) + ZAC->ZAC_CODIGO ) )
		While !ZAD->( Eof( ) ) .AND. xFilial( "ZAD" ) == ZAD->ZAD_FILIAL .AND.ZAD->ZAD_CODIGO == ZAC->ZAC_CODIGO
			If ( SOFTLOCK( "ZAD" ) )
				AADD( aCoMsNewGet, Array( noMsNewGet + 1 ) )
				
				For nX := 1 To noMsNewGet
					If aHoMsNewGet[ nX ][ 10 ] != "V"

						If Alltrim( aHoMsNewGet[ nX ][ 2 ] ) <> "ZAE_VALOR"

						    If !Empty( nPosZAD := FieldPos( aHoMsNewGet[ nX ][ 2 ] ) )
								aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := ZAD->( FieldGet( nPosZAD ) )
							EndIf
						Else
                            aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := 0
						Endif

					Else
					    aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := CriaVar( aHoMsNewGet[ nX ][ 2 ] )

						If !Empty( nPosZAD := FieldPos( aHoMsNewGet[ nX ][ 2 ] ) )
							aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := ZAD->( FieldGet( nPosZAD ) )
						EndIf
						
						/*If Alltrim( aHoMsNewGet[ nX ][ 2 ] ) == "ZAE_VLRBAS"
						    aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := Posicione( "SB1", 1, xFilial( "SB1" ) + ZAD->ZAD_PRODUT, "SB1->B1_PRV1" )
						Endif
						*/

					EndIf
					
				Next
				aCoMsNewGet[ Len( aCoMsNewGet ) ][ noMsNewGet + 1 ] := .F.
			Else
				lTravas := .T.
			EndIf
			
			ZAD->( dBSkip( ) )
		EndDo
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravação dos dados dos itens (ZAE)   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len( aCoMsNewGet )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se o item no aCols não esta deletado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !aCoMsNewGet[ nX ][ noMsNewGet + 1 ]
			dBSelectArea( "ZAE" )
			ZAE->( dBSetOrder( 4 ) )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Laço para gravação de todos os campos do item presentes no GetDados³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nY := 1 To noMsNewGet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o campo não é Virtual³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aHoMsNewGet[ nY ][ 10 ] != "V" .And. Alltrim( aHoMsNewGet[ nY ][ 2 ] ) == "ZAE_VALOR"
					ZAE->( dBGoTop(  ) )
					If ZAE->( dBSeek( xFilial( "ZAE" ) + ZAC->ZAC_CODIGO + aCoMsNewGet[ nX ][ nPosItem ] + aCoMsNewGet[ nX ][ nPosProd ] + aHoMsNewGet[ nY ][ Len( aHoMsNewGet[ nY ] ) ] ) )
						aCoMsNewGet[ nX ][ nY ] := ZAE->ZAE_VALOR
					Endif
				EndIf
			Next nY
		EndIf
	Next nX
Endif


If Len( aCoMsNewGet ) > 0 .AND. INCLUI
	oMsNewGet := MsNewGetDados():New(aPosObj[2,1] + 10,aPosObj[2,2]+5,aPosObj[2,3]-5,aPosObj[2,4]-5,nOpcNewGd,'U_LS02LNOK()','U_LS02LNOK()',"+" + cItem,,0,500,'U_LS02FLOK()',.F.,.F.,oDlgInc,aHoMsNewGet,aCoMsNewGet)
	oMsNewGet:oBrowse:Refresh()
Endif

If Len( aCoMsNewGet ) == 0
	lRet := .F.
Endif

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02ALT  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alteracao de registros            						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02ALT(cAlias, nReg, nOpc)
******************************************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch     := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch       := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE        := "ZAC"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     	 := ""     // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    	 := .F.    // Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        	 := .F.    // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   	 := .T.    // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  	 := .F.    // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  	 := .F.    // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    	 := 3      // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nRegE          := 0  		//Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)     
Local aSize          := {}
Local aObjects       := {}
Local aInfo          := {}
Local aArea		     := GetArea( )  
Local nOpcao	     := 1
Local bCampo         := {|nCPO| Field(nCPO)}
Local cAliasIT       := "ZAD"       
Local nCntFor 
Local lOk            := .T.

Private cItem	     := "ZAD_ITEM"
Private nPosItem     := 0
Private noMsNewGet   := 0  
Private aHoMsNewGet  := {}
Private aCoMsNewGet  := {}   
Private aPosObj      := {}
Private aGets        := {}
Private aTela	     := {}
Private nOpcNewGd    := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Private oMsNewGet	
Private oDlgAlt

Private ALTERA       := .T.
Private INCLUI   	 := .F.
Private DELETA   	 := .F.
Private VISUAL   	 := .F.
Private nColPrcBs    := 0

MsAguarde( { || lOk := LS02VERSC5( nOpc )  }  , "Aguarde, verificando dependências..." )

If !lOk
   Return( .F. )
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
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If U_LS02001()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 050, .T., .T. } )
	AAdd( aObjects, { 100, 120, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	DEFINE MSDIALOG oDlgAlt TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
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
	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos do Cabeçalho                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Enchoice(cAlias,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlgAlt,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grid de Exibição                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TGroup():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],"Tabela de Preço - Itens",oDlgAlt,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oMsNewGet := MsNewGetDados():New( aPosObj[2,1] + 10,aPosObj[2,2]+5,aPosObj[2,3]-5,aPosObj[2,4]-5,nOpcNewGd,'U_LS02LNOK()','U_LS02LNOK()',"+" + cItem,,0,500,'U_LS02FLOK()',.F.,.F.,oDlgAlt,aHoMsNewGet,aCoMsNewGet)
	oMsNewGet:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlgAlt ON INIT EnchoiceBar(oDlgAlt,{|| If(oMsNewGet:TudoOk() .AND. Obrigatorio(aGets, aTela), oDlgAlt:End(),)}, {||nOpcao := 0, oDlgAlt:End()})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso esteja tudo validado, efetua a gravação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcao == 1
		LSOMSGRV( nOpc, oMsNewGet, .F., {}, {} )
	Else
		RollBackSX8()
	EndIf
Endif

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02ALT  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alteracao de registros            						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02COP(cAlias, nReg, nOpc)
******************************************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch     := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch       := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE        := "ZAC"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     	 := ""     // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    	 := .F.    // Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        	 := .F.    // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   	 := .T.    // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  	 := .F.    // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  	 := .F.    // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    	 := 3      // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nRegE          := 0  		//Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)     
Local aSize          := {}
Local aObjects       := {}
Local aInfo          := {}
Local aArea		     := GetArea( )  
Local nOpcao	     := 1
Local bCampo         := {|nCPO| Field(nCPO)}
Local cAliasIT       := "ZAD"       
Local nCntFor 
Local lOk            := .T.
Local nOpc           := 3

Private cItem	     := "ZAD_ITEM"
Private nPosItem     := 0
Private noMsNewGet   := 0  
Private aHoMsNewGet  := {}
Private aCoMsNewGet  := {}   
Private aPosObj      := {}
Private aGets        := {}
Private aTela	     := {}
Private nOpcNewGd    := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Private oMsNewGet	
Private oDlgAlt

Private ALTERA       := .T.
Private INCLUI   	 := .F.
Private DELETA   	 := .F.
Private VISUAL   	 := .F.
Private nColPrcBs    := 0

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

M->ZAC_CODIGO := CriaVar( "ZAC_CODIGO"  )
M->ZAC_DESCRI := Space( TamSX3( "ZAC_DESCRI" )[ 1 ] )
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If U_LS02001()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos parâmetros para criação da tela de exibição     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 050, .T., .T. } )
	AAdd( aObjects, { 100, 120, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	DEFINE MSDIALOG oDlgAlt TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
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
	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos do Cabeçalho                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Enchoice(cAlias,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlgAlt,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grid de Exibição                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TGroup():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],"Tabela de Preço - Itens",oDlgAlt,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oMsNewGet := MsNewGetDados():New( aPosObj[2,1] + 10,aPosObj[2,2]+5,aPosObj[2,3]-5,aPosObj[2,4]-5,nOpcNewGd,'U_LS02LNOK()','U_LS02LNOK()',"+" + cItem,,0,500,'U_LS02FLOK()',.F.,.F.,oDlgAlt,aHoMsNewGet,aCoMsNewGet)
	oMsNewGet:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlgAlt ON INIT EnchoiceBar(oDlgAlt,{|| If(oMsNewGet:TudoOk() .AND. Obrigatorio(aGets, aTela), oDlgAlt:End(),)}, {||nOpcao := 0, oDlgAlt:End()})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso esteja tudo validado, efetua a gravação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nOpcao == 1
	   LSOMSGRV(nOpc, oMsNewGet, .F., {}, {} )
    Else
	   RollBackSX8()
    EndIf	
Endif

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02EXC  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclusao  de registros            						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02EXC(cAlias, nReg, nOpc)
******************************************
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local aAlterEnch      := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch        := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE         := "ZAC"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela          := ""  	// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn         := .F.  	//Indica se a apresentacao dos campos sera em forma de coluna
Local lF3             := .F.  	//Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria        := .T.  	//Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder       := .F.  	//Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty       := .F.  	//Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local aSize           := {}
Local aObjects        := {}
Local aInfo           := {}
Local aPosObj         := {}
Local aArea		      := GetArea( )  
Local cAliasIT 	      := "ZAD"       
Local cItem	          := "ZAD_ITEM"
Local bCampo          := {|nCPO| Field(nCPO)}
Local aHoMsNewGet     := {}
Local aCoMsNewGet     := {}   
Local nOpcNewGd       := If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Local nOpcao	      := 1
Local nPosItem        := 0
Local noMsNewGet      := 0  
Local nCntFor         := 0
Local nModelo         := 3  		//Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local lOk             := .T.
Local oMsNewGet	
Local oDlg1	

Private aGets        := {}
Private aTela	     := {}
Private INCLUI   	 := .F.
Private ALTERA   	 := .F.
Private DELETA   	 := .T.
Private VISUAL   	 := .F.
Private nColPrcBs    := 0

MsAguarde( { || lOk := LS02VERSC5( nOpc )  }  , "Aguarde, verificando dependências..." )

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
SX3->( dBSeek( "ZAD" ) )
While !Eof() .and. SX3->X3_ARQUIVO == "ZAD"
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
(cALiasIT)->(dbSetOrder(1)) 
If (cALiasIT)->(dbSeek(xFilial(cALiasIT ) + ZAC->ZAC_CODIGO ) )
	While !(cALiasIT)->(Eof()) .AND. xFilial(cALiasIT) == ZAD->ZAD_FILIAL .AND.	ZAD->ZAD_CODIGO == ZAC->ZAC_CODIGO
		If (SOFTLOCK(cALiasIT))
			AADD(aCoMsNewGet, Array(noMsNewGet + 1))
			For nX := 1 To noMsNewGet
				If aHoMsNewGet[ nX ][10] != "V"
					If !Empty(nPosZAD := FieldPos(aHoMsNewGet[ nX ][ 2 ] ) )
						aCoMsNewGet[Len(aCoMsNewGet)][ nX ] := (cALiasIT)->(FieldGet(nPosZAD))
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
	AAdd( aObjects, { 100, 40, .T., .T. } )
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
	    LSOMSGRV( nOpc, oMsNewGet, .F., {}, {} )
	EndIf

EndIf                        

Return( Nil )
                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02VERSC5 ºAutor  ³Lincoln Rossetto   º Data ³  23/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função implementada para validar se a tabela de preço pode  º±±
±±º          ³ou não ser alterada.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LS02VERSC5( nOpc )
**********************************
Local lRet     := .T.          
Local cQuery   := ""
Local hEnter   := Chr( 13 ) 
Local cTMPSC5  := GetNextAlias()
Local aProcess := iif( nOpc == 4, { "Alterar","Alterada" },  { "Excluir","Excluida" } )
Local nOk      := 0

cQuery := "SELECT COUNT( * ) C5_N_RECS"                          + hEnter
cQuery += "  FROM " + RetSqlName( "SC5" ) + " SC5, "             + hEnter
cQuery += "       " + RetSqlName( "SC6" ) + " SC6  "             + hEnter
cQuery += " WHERE SC5.C5_FILIAL    = '" + xFilial( "SC5" ) + "'" + hEnter
cQuery += "   AND SC6.C6_FILIAL    = '" + xFilial( "SC6" ) + "'" + hEnter
cQuery += "   AND SC6.C6_NUM       = SC5.C5_NUM"                 + hEnter
cQuery += "   AND SC5.C5_X_TBPRC   = '" + ZAC_CODIGO + "'"       + hEnter
cQuery += "   AND ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0"         + hEnter
cQuery += "   AND SC5.D_E_L_E_T_  <> '*'"                        + hEnter
cQuery += "   AND SC6.D_E_L_E_T_  <> '*'"                        + hEnter

MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery )

cQuery := ChangeQuery( cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cTMPSC5, .F., .T.)

If ( cTMPSC5 )->C5_N_RECS > 0
	nOk := Aviso("Atenção","Existem itens de Pedido de Venda em aberto a serem faturados, deseja realmente prosseguir?" ,{"Sim","Não"},2)
	If nOk == 2
		lRet := .F.
	Else
		Aviso("Atenção","Você optou por alterar a Tabela de Preço, entretanto esta operação não irá atualizar os Pedidos de Venda em aberto." ,{ "OK" } , 2 )
	Endif
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02FLOK    ºAutor  ³Lincoln Rossetto   º Data ³ 07/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para replicar para as demais condições os  º±±
±±º          ³valores reajustados conforme o preço base informado.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LS02FLOK()
************************
Local nPrecoBase := 0
Local nValor     := 0
Local nUsado     := Len( aHeader )

If ReadVar() == "M->ZAE_VALOR" .And. oMsNewGet:OBROWSE:COLPOS == nColPrcBs
	If Aviso( "Atenção","Atualizar demais condições de Pagamento com Base no Preço Base x Var. Relativo Preco Base informado nas Condições de Pagamento do Grupo de Condições [" + M->ZAC_GRPCND + "]? ",{"Sim","Não"},2) == 1
		
		If !aCols[ n ][ nUsado+1 ]
			For nI := 1 To nUSado
				If Alltrim( aHeader[ nI ][ 2 ] ) == "ZAE_VALOR"
					dBSelectArea( "ZAB" )
					ZAB->( dBSetOrder( 4 ) )
					ZAB->( dBGoTop( ) )
					
					If ZAB->( dBSeek( xFilial( "ZAB" ) + M->ZAC_GRPCND + aHeader[ nI ][ Len( aHeader[ nI ] ) ]  ) )
						If ZAB->ZAB_PRECOB == "1"
							nPrecoBase := M->ZAE_VALOR
							exit
						Endif
					Endif
				Endif
			Next nI
		Endif
		
		If !aCols[ n ][ nUsado+1 ] .And. nPrecoBase > 0
			For nI := 1 To nUSado
				If Alltrim( aHeader[ nI ][ 2 ] ) == "ZAE_VALOR"
					dBSelectArea( "ZAB" )
					ZAB->( dBSetOrder( 4 ) )
					ZAB->( dBGoTop( ) )
					
					nValor := 0
					
					If ZAB->( dBSeek( xFilial( "ZAB" ) + M->ZAC_GRPCND + aHeader[ nI ][ Len( aHeader[ nI ] ) ]  ) )
						If ZAB->ZAB_PRECOB <> "1"
						   nValor := ( nPrecoBase + ( nPrecoBase * ( ( ZAB->ZAB_VARIAC / 100 ) ) ) )
						Endif
					Endif
					
						If nValor > 0
						aCols[ n ][ nI ] := nValor
					Endif
					
				Endif
			Next nI
		Endif
	Endif
Endif

Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02LNOK    ºAutor  ³Lincoln Rossetto   º Data ³ 07/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para validar a mudanca de linha no GetDadosº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LS02LNOK()
************************           
Local lRet		  := .T.   
Local nPosProd    := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZAD_PRODUT" } )
Local nPosDtIni   := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZAD_DTINI"  } )
Local nPosDtFim   := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZAD_DTFIM"  } )
Local cProdAtual  := aCols[ n ][ nPosProd  ]
Local aPosValor   := {}
Local nI          := 0
Local nX          := 0

For nI := 1 To Len( aCols )
	If nI <> n
		If !aCols[ nI ][ Len( aHeader ) + 1 ]
			If aCols[ nI ][ nPosProd ] == cProdAtual
				lRet := .F.
				U_LSSHWHLP("Atenção !", ;
				           "Você esta tentando incluir um produto que já existe nesta tabela !!",;
				           "Altere o produto já existente ou inclua novos produtos!" )
			EndIf
		Endif
	EndIf
Next nI

For nI := 1 To Len( aHeader )
    If Alltrim( aHeader[ nI ][ 2 ] ) == "ZAE_VALOR"
       aAdd( aPosValor, nI )
    Endif
Next nI

If !aCols[ n ][ Len( aHeader ) + 1 ]
	For nX := 1 to Len( aPosValor )
		If aCols[ n ][ aPosValor[ nX ] ] == 0 
		   If lRet
		      lRet := .F.
		   Endif
		Endif
	Next
Endif

If !lRet
	U_LSSHWHLP("Tabela de Preço x Preço de Venda", "O Preço de Venda da Condição de Pagamento do Item não informado.", "Verifique o Preço de Venda da Condição de Pagamento do item da Tabela de Preço.")
Endif


If lRet .AND. INCLUI
	If !aCols[ n ][ Len( aHeader ) + 1 ]
		For nX := 1 to Len( aPosValor )
			If aCols[ n ][ aPosValor[ nX ] ] < 0
				If lRet
					lRet := .F.
				Endif
			Endif
		Next
	Endif
	
	If !lRet
		U_LSSHWHLP("Tabela de Preço x Preço de Venda", "O Preço de Venda da Condição de Pagamento do Item não pode ser negativo.", "Verifique o Preço de Venda da Condição de Pagamento do item da Tabela de Preço.")
	Endif
	
Endif

If lRet
	If Empty( DTOS( M->ZAC_DTINI ) )
		lRet := .F.
		U_LSSHWHLP("Tabela de Preço x Vigência", "Não foi informado um Inicio de Vigência para a Tabela de Preço (Cabeçalho).", "Verifique o Cabeçalho da Tabela de Preço.")
	Endif
Endif

If lRet
	If ( ( !aCols[ n ][ Len( aHeader ) + 1 ] ) .And. ( aCols[ n ][ nPosDtIni ] < M->ZAC_DTINI ) )
		lRet := .F.
		U_LSSHWHLP("Tabela de Preço x Vigência", "A Vigência Incial do item deve iniciar a partir da Data de Inicio da Vigência da Tabela de Preço", "Verifique a Vigência Inicial do item da Tabela de Preço.")
	Endif
Endif

If lRet
	If ( ( !aCols[ n ][ Len( aHeader ) + 1 ] ) .And. ( !Empty( DTOS( aCols[ n ][ nPosDtFim ] ) ) ) )
		If Empty( DTOS( M->ZAC_DTFIM ) )
			lRet := .F.
			U_LSSHWHLP("Tabela de Preço x Vigência", "Não foi informado um Fim da Vigência para a Tabela de Preço (Cabeçalho).", "Verifique o Cabeçalho da Tabela de Preço.")
		Endif
		
		If lRet
			If aCols[ n ][ nPosDtFim ] > M->ZAC_DTFIM
				lRet := .F.
				U_LSSHWHLP("Tabela de Preço x Vigência", "A Vigência Final do item deve iniciar a partir da Data de Inicio da Vigência da Tabela de Preço", "Verifique a Vigência Inicial do item da Tabela de Preço.")
			Endif
		Endif
	Endif
Endif


Return( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS02TBP  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o Preço de Venda do Produto informado             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02TBP()
***********************
Local nPosPrcVda := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRCVEN" } ) 
Local nPosPrcLst := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRUNIT" } ) 
Local nPosQtd    := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_QTDVEN" } ) 
Local nPosValor  := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_VALOR"  } ) 
Local nQuant     := aCols[ n ][ nPosQtd ]
Local cTabPreco  := M->C5_X_TBPRC
Local cCondPag   := M->C5_CONDPAG
Local cProduto   := M->C6_PRODUTO
Local dDataVld   := dDataBase
Local aAreaA     := SE4->( GetArea( ) )
Local aAreaB     := SA1->( GetArea( ) )
Local aAreaC     := SA2->( GetArea( ) )
Local aAreaD     := SE4->( GetArea( ) )
Local aAreaE     := SC5->( GetArea( ) )
Local aAreaF     := SC6->( GetArea( ) )
Local lRet       := .T.
Local cCondMedia := ""
Local nPrecVenda := 0
Local PercAument := GetMV("MV_AUMTBPC") // Percentual de aumento do preço de tabela
Local cTbPreco 	 := GetMV("MV_TBPRFUN") // Tbela de preços do funcionario / produtor

dBSelectArea( "ZAC" )
ZAC->( dBSetOrder( 1 ) )
ZAC->( dBGoTop(  ) )

If ZAC->( dBSeek( xFilial( "ZAC" ) + cTabPreco ) )
	If ZAC->ZAC_ATIVA == "1"
		dBSelectArea( "SE4" )
		SE4->( dBSetOrder( 1 ) )
		SE4->( dBGoTop(  ) )
		SE4->( dBSeek( xFilial( "SE4" ) + cCondPag ) )
		cCondMedia := SE4->E4_X_CNDMD
		
		dBSelectArea( "ZAE" )
		ZAE->( dBSetOrder( 6 ) )
		ZAE->( dBGoTop(  ) )
		
		If ZAE->( dBSeek( xFilial( "ZAE" ) + cTabPreco + cProduto + cCondMedia ) )
			If cTabPreco == cTbPreco
				nPrecVenda := ZAE->ZAE_VALOR + ((ZAE->ZAE_VALOR * PercAument) / 100)
			Else
				nPrecVenda := round(ZAE->ZAE_VALOR,2)
			EndIf
			
			dBSelectArea( "ZAD" )
			ZAD->( dBSetOrder( 3 ) )
			ZAD->( dBGoTop(  ) )
			
			If ZAD->( dBSeek( xFilial( "ZAD" ) + cTabPreco + ZAE->ZAE_ITEM + cProduto ) )
				If  (!( dDataVld >= ZAD->ZAD_DTINI  .And. dDataVld <= If(Empty( ZAD->ZAD_DTFIM  ), dDataVld, ZAD->ZAD_DTFIM ) ) )
					nPrecVenda := 0
					lRet       := .F.
					U_LSSHWHLP( "Tabela de Preço",;
					            "Preço do Produto informado fora da Vigência na Tabela de Preço.",;
					            "1.) Verifique a Tabela de Preço;"  )
				Endif
			Else
				nPrecVenda := 0
				lRet       := .F.
				U_LSSHWHLP( "Tabela de Preço",;
				            "Não foi possível determinar a Vigência do Produto, impossivel continuar...",;
				            "1.) Verifique a Tabela de Preço;"  + Chr( 10 ) + Chr( 13 ) + ;
				            "2.) Verifique o Produto Informado;"  )
				
			Endif
			
		Else
			nPrecVenda := 0
			lRet       := .F.
			U_LSSHWHLP( "Tabela de Preço",;
			            "Não foi encontrado Preço para o Produto informado na Tabela de Preço/Condição de Pagamento Média (informado na Condição de Pagamento do Pedido de Venda).",;
			            "1.) Verifique a Tabela de Preço;" + Chr( 10 ) + Chr( 13 ) + ;
			            "2.) Verifique a Condição de Pagamento;" + Chr( 10 ) +Chr( 13 ) + ;
			            "3.) Verifique a Condição de Pagamento Média da Condição de Pagamento informada no Pedido;" )
			
		Endif
		
		aCols[ n ][ nPosPrcVda ] := nPrecVenda
		aCols[ n ][ nPosPrcLst ] := nPrecVenda
		
		If aCols[ n ][ nPosQtd ] > 0
			A410MultT("C6_QTDVEN",aCols[ n ][ nPosQtd ] )
		Endif
		
		A410MultT( "C6_PRCVEN", aCols[ n ][ nPosPrcVda ] )
	Else
	   lRet := .F.
	   U_LSSHWHLP( "Tabela de Preço",;
	               "A Tabela de Preço informada não esta ativa, impossivel prosseguir...",;
	               "1.) Verifique a Tabela de Preço;"  )
	Endif
Endif

If Len( aAreaA ) > 0
   RestArea( aAreaA )
Endif

If Len( aAreaB ) > 0
   RestArea( aAreaB )
Endif

If Len( aAreaC ) > 0
   RestArea( aAreaC )
Endif

If Len( aAreaD ) > 0
   RestArea( aAreaD )
Endif

If Len( aAreaE ) > 0
   RestArea( aAreaE )
Endif

If Len( aAreaF ) > 0
   RestArea( aAreaF )
Endif

lRet := U_A410VLD2()

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS02VTBP ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a Tabela de Preço e a Condição de Pagamento e a Con-º±±
±±º          ³ dição de Pagamento Média.                                  º±±
±±º          ³ Na validação do campo da Condição de Pagamento informar a  º±±
±±º          ³ função.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02VTBP()
************************
Local aAreaA     := SE4->( GetArea( ) )
Local aAreaB     := SA1->( GetArea( ) )
Local aAreaC     := SA2->( GetArea( ) )
Local aAreaD     := SE4->( GetArea( ) )
Local aAreaE     := SC5->( GetArea( ) )
Local aAreaF     := SC6->( GetArea( ) )

Local cTabPreco  := M->C5_TABELA
Local cCondPag   := M->C5_CONDPAG
Local dDataVld   := dDataBase
Local lValido    := .T.
Local lRetira    := .F.
Local cTabFilial := Alltrim(GetMv("MV_TBPRECO")) // Tabelas de preco da filial
Local cTbRepres	 := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TABELA") // verifica se tem tabela de preço amarrada ao cliente
Local cUnVenda	 := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_UNIDVEN") // verifica se tem tabela de preço amarrada ao cliente
Local cTbSouk 	 := GetMV("MV_TBPSOUK") // Tbela de preços do SOUK
Local isFunc     := .F.
Local cCodFunc   := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FUNC") // Verifica se é funcionário
Local cTpCliente := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TIPO")
Local cCondPgto  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")
Local cTbPreco 	 := GetMV("MV_TBPRFUN") // Tbela de preços do funcionario / produtor
Local cTbDireta	 := GetMV("MV_TBPRDIR") // Tbela de preços do direta
Local cMV_USERREC:= SuperGetMV("MV_USERREC",,"")	//-- USUARIOS da recepcao com permissão pra usar tabela direta

If cCondPgto == "902" .OR. !Empty(Alltrim(cCodFunc))
	isFunc     := .T.
EndIf

If AllTrim(cUserName) $ AllTrim(cMV_USERREC) .AND. !isFunc 
    lRetira    := .T.          
EndIf

If !Empty(Alltrim(cTbRepres)) .AND. !isFunc 
	cTbRepres = StrZero(Val(cTbRepres),3)
EndIf

Do Case
	Case ( !Empty( cTabPreco ) .And. Empty( cCondPag ) ) .Or. !(cTabPreco $ cTabFilial)  .Or. !Empty(Alltrim(cTbRepres)) .Or. isFunc
		dBSelectArea( "DA0" )
		DA0->( dBSetOrder( 1 ) )
		DA0->( dBGoTop(  ) )
		
		If DA0->( dBSeek( xFilial( "DA0" ) + cTabPreco ) )
			If  (!( dDataVld >= DA0->DA0_DATDE  .And. dDataVld <= If(Empty( DA0->DA0_DATATE  ), dDataVld, DA0->DA0_DATATE ) ) )
				lValido := .F.
				U_LSSHWHLP( "Tabela de Preço",;
			                  "Tabela de preço inativa ou vencida.", ;
			                  "1.) Selecione outra Tabela de Preço ou altere o Status desta;" )                                                                                                  
				
			ElseIf ( ( DA0->DA0_ATIVO == "2" .Or. !(cTabPreco $ cTabFilial) ) .And. Empty(Alltrim(cTbRepres)) .And. !isFunc  )
				  		  
				  				  
				  lValido := .F.
			      U_LSSHWHLP( "Tabela de Preço",;
			                  "Tabela de preço inativa ou não pretence a essa filial.", ;
			                  "1.) Selecione outra Tabela de Preço ou altere o Status desta;" )
			
			Elseif M->C5_VEND2 == "000116" .AND. cUnVenda = "000001"
				lValido := .T.
			
			ElseIf !Empty(Alltrim(cTbRepres)) 
				
				If ( ( cTbRepres <> cTabPreco ) .And. !isFunc )
							  
				  M->C5_TABELA := cTbRepres
				  U_LSSHWHLP( "Tabela de Preço",;
			               "Não é possível alterar a tabela de preços para este cliente.", ;
			               "1.) A tabela de preços foi definida como exceção no cadastro de clientes")                 
		        
				ElseIf ( isFunc )
				  
				  M->C5_TABELA 	:= cTbPreco
				  U_LSSHWHLP( "Tabela de Preço",;
			                  "Não é possível alterar a tabela de preços para este cliente.", ;
			                  "1.) Este cliente é funcionario ou produtor e deve-se utilizar a tabela de preços sugerida")
				EndIf          
			
			
			Endif
		Else
			lValido := .F.
			U_LSSHWHLP( "Tabela de Preço",;
			                  "Tabela de preço não encontrada.", ;
			                  "1.) Selecione outra Tabela de Preço;" )
		Endif
	/*	
	Case ( ( Empty( cTabPreco ) .And. !Empty( cCondPag ) ) .OR. ( !Empty( cTabPreco ) .And. !Empty( cCondPag ) ) )
		dBSelectArea( "SE4" )
		SE4->( dBSetOrder( 1 ) )
		SE4->( dBGoTop(  ) )
		SE4->( dBSeek( xFilial( "SE4" ) + cCondPag ) )
		
		If Empty( SE4->E4_X_CNDMD )
			lValido := .F.
			U_LSSHWHLP( "Cond. Pagamento Média X Cond. Pagamento",;
			            "Não foi encontrado na Condição de Pagamento informada uma Condição de Pagamento Média para ser utilizado na verificação do preço do produto na Tabela de Preço", ;
			            "1.) Verifique a Condição de Pagamento;" + Chr( 10 ) + Chr( 13 ) + ;
			            "2.) Verifique a Condição de Pagamento média;" )
			            
		Else
		    If !Empty( cTabPreco )
			   dBSelectArea( "ZAE" )
			   ZAE->( dBSetOrder( 7 ) )
			   ZAE->( dBGoTop(  ) )
			
			   If !ZAE->( dBSeek( xFilial( "ZAE" ) + cTabPreco + SE4->E4_X_CNDMD ) )
			      lValido := .F.
			       U_LSSHWHLP( "Tabela de Preço X Cond. Pagto Média",;
			                   "Não há preços de produtos na Tabela de Preço x Condição de Pagamento Média informada", ;
			                   "1.) Verifique a Condição de Pagamento;" + Chr( 10 ) + Chr( 13 ) + ;
			                   "2.) Verifique a Condição de Pagamento média;" )
			   Endif
			   
			Endif
		Endif
	*/	
Endcase

If Len( aAreaA ) > 0
   RestArea( aAreaA )
Endif

If Len( aAreaB ) > 0
   RestArea( aAreaB )
Endif

If Len( aAreaC ) > 0
   RestArea( aAreaC )
Endif

If Len( aAreaD ) > 0
   RestArea( aAreaD )
Endif

If Len( aAreaE ) > 0
   RestArea( aAreaE )
Endif

If Len( aAreaF ) > 0
   RestArea( aAreaF )
Endif

Return( lValido )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS02VTB2 ºAutor  ³Djonata Guizzo      º Data ³ 15/09/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Nova validação para o campo Tabela de Preço, removido      º±±
±±º          ³ validações antigas da função LS02VTBP, mantido apenas      º±±
±±º          ³ validação para tabela de funcionário ou produtor.          º±±
±±º          ³ Na validação do campo da Condição de Pagamento informar a  º±±
±±º          ³ função.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02VTB2()
************************
Local aAreaA     := SE4->( GetArea( ) )
Local aAreaB     := SA1->( GetArea( ) )
Local aAreaC     := SA2->( GetArea( ) )
Local aAreaD     := SE4->( GetArea( ) )
Local aAreaE     := SC5->( GetArea( ) )
Local aAreaF     := SC6->( GetArea( ) )

Local cTabPreco  := M->C5_TABELA
Local cCondPag   := M->C5_CONDPAG
Local dDataVld   := dDataBase
Local lValido    := .T.
//Local lRetira    := .F.
Local cTabFilial := Alltrim(GetMv("MV_TBPRECO")) // Tabelas de preco da filial
Local cTbRepres	 := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TABELA") // verifica se tem tabela de preço amarrada ao cliente
Local isFunc     := .F.
Local isProd     := .F.
Local cCodFunc   := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_X_FUNC") // Verifica se é funcionário
//Local cTpCliente := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TIPO")
Local cCondPgto  	:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")
Local cTbPreco 	 := GetMV("MV_TBPRFUN") // Tbela de preços do funcionario
Local cTbProd 	 := GetMV("MV_TBPRPRO") // Tbela de preços do produtor
//Local cTbDireta	 := GetMV("MV_TBPRDIR") // Tbela de preços do direta
Local cMV_USERREC:= SuperGetMV("MV_USERREC",,"")	//-- USUARIOS da recepcao com permissão pra usar tabela direta
Local lRet := cTabFilial
If cCondPgto == "901" .OR. !Empty(Alltrim(cCodFunc))
	isFunc     := .T.
ElseIf cCondPgto == "902"
	isProd := .T.
EndIf
/*
If AllTrim(cUserName) $ AllTrim(cMV_USERREC) .AND. !isFunc 
    lRetira    := .T.          
EndIf
*/
If !Empty(Alltrim(cTbRepres)) .AND. !isFunc
	cTbRepres = StrZero(Val(cTbRepres),3)
EndIf

dBSelectArea( "DA0" )
DA0->( dBSetOrder( 1 ) )
DA0->( dBGoTop(  ) )

If DA0->( dBSeek( xFilial( "DA0" ) + cTabPreco ) )
	
	If  (!( dDataVld >= DA0->DA0_DATDE  .And. dDataVld <= If(Empty( DA0->DA0_DATATE  ), dDataVld, DA0->DA0_DATATE ) ) )
				lValido := .F.
				Help( " ", 1 , "OMSTABPRC1" )                                                                                                    
				
	ElseIf ( ( DA0->DA0_ATIVO == "2" .Or. !(cTabPreco $ cTabFilial) ) .And. !isFunc .And. M->C5_OPER != "60"  .and. Empty(cTbRepres)) 
				  		  
			  
				lValido := .F.
			    U_LSSHWHLP( "Tabela de Preço",;
			                  "Tabela de preço inativa ou não pretence a essa filial.", ;
			                  "1.) Selecione outra Tabela de Preço ou altere o Status desta;" )
				
	
	ElseIf ( isFunc )			
			M->C5_X_TBPRC 	:= cTbPreco
			lRet 	:= cTbPreco

	ElseIf ( isProd )
			
			M->C5_X_TBPRC 	:= cTbProd
			lRet 	:= cTbProd			
		
	elseif !Empty(cTbRepres) 
			lRet := cTbRepres
		
	Endif



Endif
	

If Len( aAreaA ) > 0
   RestArea( aAreaA )
Endif

If Len( aAreaB ) > 0
   RestArea( aAreaB )
Endif
 
If Len( aAreaC ) > 0
   RestArea( aAreaC )
Endif

If Len( aAreaD ) > 0
   RestArea( aAreaD )
Endif

If Len( aAreaE ) > 0
   RestArea( aAreaE )
Endif

If Len( aAreaF ) > 0
   RestArea( aAreaF )
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS02CLC  ºAutor  ³Lincoln Rossetto    º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a Necessidade de recalcular o Pedido de Venda.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
Static Function LS02CLC()
*************************
Local aAreaA     := SE4->( GetArea( ) )
Local aAreaB     := SA1->( GetArea( ) )
Local aAreaC     := SA2->( GetArea( ) )
Local aAreaD     := SE4->( GetArea( ) )
Local aAreaE     := SC5->( GetArea( ) )
Local aAreaF     := SC6->( GetArea( ) )
Local cTabPreco  := M->C5_X_TBPRC
Local cCondPag   := M->C5_CONDPAG
Local dDataVld   := dDataBase
Local nPosItem   := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_ITEM"    } ) 
Local nPosProd   := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRODUTO" } ) 
Local nPosPrcVda := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRCVEN"  } ) 
Local nPosPrcLst := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRUNIT"  } ) 
Local lRet       := .T.
Local aItens     := {}
Local cProduto   := ""
Local cCondMedia := ""
Local nPrecVenda := 0
Local nX

If Alltrim( Upper( cUserName ) ) <> "TOTVS"
   Return( .T. )
Endif

For nX := 1 To Len( aCols )
	If !aCols[ nX ][ Len( aHeader ) + 1 ]
	   If !Empty( aCols[ nX ][ nPosProd ] ) .And. aCols[ nX ][ nPosPrcVda ] > 0
	      aAdd( aItens, aCols[ nX ][ nPosItem ] )
	   Endif
	Endif
Next

If Len( aItens ) > 0

	If ZAC->( dBSeek( xFilial( "ZAC" ) + cTabPreco ) )

		If ZAC->ZAC_ATIVA == "1"
			dBSelectArea( "SE4" )
			SE4->( dBSetOrder( 1 ) )
			SE4->( dBGoTop(  ) )
			SE4->( dBSeek( xFilial( "SE4" ) + cCondPag ) )
			
			cCondMedia := SE4->E4_X_CNDMD
			
			For nX := 1 To Len( aCols )
			
				If ( nPos := aScan( aItens, aCols[ nX ] [ nPosItem ] ) ) > 0
			
					cProduto := aCols[ nX ][ nPosProd ]
			
					dBSelectArea( "ZAE" )
					ZAE->( dBSetOrder( 6 ) )
					ZAE->( dBGoTop(  ) )
					
					If ZAE->( dBSeek( xFilial( "ZAE" ) + cTabPreco + cProduto + cCondMedia ) )
						nPrecVenda := ZAE->ZAE_VALOR
						
						dBSelectArea( "ZAD" )
						ZAD->( dBSetOrder( 3 ) )
						ZAD->( dBGoTop(  ) )
						
						If ZAD->( dBSeek( xFilial( "ZAD" ) + cTabPreco + ZAE->ZAE_ITEM + cProduto ) )
							If  (!( dDataVld >= ZAD->ZAD_DTINI  .And. dDataVld <= If(Empty( ZAD->ZAD_DTFIM  ), dDataVld, ZAD->ZAD_DTFIM ) ) )
								nPrecVenda := 0
								lRet       := .F.
								U_LSSHWHLP( "Tabela de Preço",;
								            "Preço do Produto informado fora da Vigência na Tabela de Preço.",;
								            "1.) Verifique a Tabela de Preço;"  )
							Endif
						Else
							nPrecVenda := 0
							lRet       := .F.
							U_LSSHWHLP( "Tabela de Preço",;
							            "Não foi possível determinar a Vigência do Produto, impossivel continuar...",;
							            "1.) Verifique a Tabela de Preço;"  + Chr( 10 ) + Chr( 13 ) + ;
							            "2.) Verifique o Produto Informado;"  )
							
						Endif
						
					Else
						nPrecVenda := 0
						lRet       := .F.
						U_LSSHWHLP( "Tabela de Preço",;
						            "Não foi encontrado Preço para o Produto informado na Tabela de Preço/Condição de Pagamento Média (informado na Condição de Pagamento do Pedido de Venda).",;
						            "1.) Verifique a Tabela de Preço;" + Chr( 10 ) + Chr( 13 ) + ;
						            "2.) Verifique a Condição de Pagamento;" + Chr( 10 ) +Chr( 13 ) + ;
						            "3.) Verifique a Condição de Pagamento Média da Condição de Pagamento informada no Pedido;" )
						
					Endif
					
					aCols[ nX ][ nPosPrcVda ] := nPrecVenda
					aCols[ nX ][ nPosPrcLst ] := nPrecVenda
					
					If aCols[ nX ][ nPosQtd ] > 0
						A410MultT("C6_QTDVEN",aCols[ nX ][ nPosQtd ] )
					Endif
					
					A410MultT( "C6_PRCVEN", aCols[ nX ][ nPosPrcVda ] )
				Endif
			Next
		Else
			lRet := .F.
			U_LSSHWHLP( "Tabela de Preço",;
			            "A Tabela de Preço informada não esta ativa, impossivel prosseguir...",;
			            "1.) Verifique a Tabela de Preço;"  )
		Endif
	Endif
Endif

If Len( aAreaA ) > 0
	RestArea( aAreaA )
Endif

If Len( aAreaB ) > 0
	RestArea( aAreaB )
Endif

If Len( aAreaC ) > 0
	RestArea( aAreaC )
Endif

If Len( aAreaD ) > 0
	RestArea( aAreaD )
Endif

If Len( aAreaE ) > 0
	RestArea( aAreaE )
Endif

If Len( aAreaF ) > 0
	RestArea( aAreaF )
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS02RGDA  ºAutor  ³Lincoln Rossetto   º Data ³ 07/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o Preço de Venda do Produto informado             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function LS02RGDA()
************************
Local nPosPrcVda := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRCVEN" } ) 
Local nPosPrcLst := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_PRUNIT" } ) 
Local nPosQtd    := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_QTDVEN" } ) 
Local nPosValor  := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "C6_VALOR"  } ) 
Local nQuant     := aCols[ n ][ nPosQtd ]
Local cTabPreco  := M->C5_X_TBPRC
Local cCondPag   := M->C5_CONDPAG
Local cProduto   := M->C6_PRODUTO
Local dDataVld   := dDataBase
Local aAreaA     := SE4->( GetArea( ) )
Local aAreaB     := SA1->( GetArea( ) )
Local aAreaC     := SA2->( GetArea( ) )
Local aAreaD     := SE4->( GetArea( ) )
Local aAreaE     := SC5->( GetArea( ) )
Local aAreaF     := SC6->( GetArea( ) )
Local lRet       := .T.
Local cCondMedia := ""
Local nPrecVenda := 0

dBSelectArea( "ZAC" )
ZAC->( dBSetOrder( 6 ) )
ZAC->( dBGoTop(  ) )

If ZAC->( dBSeek( xFilial( "ZAC" ) + cTabPreco ) )
	If ZAC->ZAC_ATIVA == "1"
		dBSelectArea( "SE4" )
		SE4->( dBSetOrder( 1 ) )
		SE4->( dBGoTop(  ) )
		SE4->( dBSeek( xFilial( "SE4" ) + cCondPag ) )
		cCondMedia := SE4->E4_X_CNDMD
		
		dBSelectArea( "ZAE" )
		ZAE->( dBSetOrder( 6 ) )
		ZAE->( dBGoTop(  ) )
		
		If ZAE->( dBSeek( xFilial( "ZAE" ) + cTabPreco + cProduto + cCondMedia ) )
			
			nPrecVenda := ZAE->ZAE_VALOR
			
			dBSelectArea( "ZAD" )
			ZAD->( dBSetOrder( 3 ) )
			ZAD->( dBGoTop(  ) )
			
			If ZAD->( dBSeek( xFilial( "ZAD" ) + cTabPreco + ZAE->ZAE_ITEM + cProduto ) )
				If  (!( dDataVld >= ZAD->ZAD_DTINI  .And. dDataVld <= If(Empty( ZAD->ZAD_DTFIM  ), dDataVld, ZAD->ZAD_DTFIM ) ) )
					nPrecVenda := 0
					lRet       := .F.
					U_LSSHWHLP( "Tabela de Preço",;
					            "Preço do Produto informado fora da Vigência na Tabela de Preço.",;
					            "1.) Verifique a Tabela de Preço;"  )
				Endif
			Else
				nPrecVenda := 0
				lRet       := .F.
				U_LSSHWHLP( "Tabela de Preço",;
				            "Não foi possível determinar a Vigência do Produto, impossivel continuar...",;
				            "1.) Verifique a Tabela de Preço;"  + Chr( 10 ) + Chr( 13 ) + ;
				            "2.) Verifique o Produto Informado;"  )
				
			Endif
			
		Else
			nPrecVenda := 0
			lRet       := .F.
			U_LSSHWHLP( "Tabela de Preço",;
			            "Não foi encontrado Preço para o Produto informado na Tabela de Preço/Condição de Pagamento Média (informado na Condição de Pagamento do Pedido de Venda).",;
			            "1.) Verifique a Tabela de Preço;" + Chr( 10 ) + Chr( 13 ) + ;
			            "2.) Verifique a Condição de Pagamento;" + Chr( 10 ) +Chr( 13 ) + ;
			            "3.) Verifique a Condição de Pagamento Média da Condição de Pagamento informada no Pedido;" )
			
		Endif
		
		aCols[ n ][ nPosPrcVda ] := nPrecVenda
		aCols[ n ][ nPosPrcLst ] := nPrecVenda
		
		If aCols[ n ][ nPosQtd ] > 0
			A410MultT("C6_QTDVEN",aCols[ n ][ nPosQtd ] )
		Endif
		
		A410MultT( "C6_PRCVEN", aCols[ n ][ nPosPrcVda ] )
	Else
	   lRet := .F.
	   U_LSSHWHLP( "Tabela de Preço",;
	               "A Tabela de Preço informada não esta ativa, impossivel prosseguir...",;
	               "1.) Verifique a Tabela de Preço;"  )
	Endif
Endif

If Len( aAreaA ) > 0
   RestArea( aAreaA )
Endif

If Len( aAreaB ) > 0
   RestArea( aAreaB )
Endif

If Len( aAreaC ) > 0
   RestArea( aAreaC )
Endif

If Len( aAreaD ) > 0
   RestArea( aAreaD )
Endif

If Len( aAreaE ) > 0
   RestArea( aAreaE )
Endif

If Len( aAreaF ) > 0
   RestArea( aAreaF )
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS02REA   ºAutor  ³Lincoln Rossetto    º Data ³  04/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reajuste de Tabela de Preços     						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LS02REA(cAlias, nReg, nOpc)
*****************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea        := ZAC->( GetArea() )
Local cPerg        := "LSOMS02REA"
Local nOpcA        := 0
Local lOk          := .F.
Local cProdDe      := ""
Local cProdAte     := ""
Local cGrupoDe     := ""
Local cGrupoAte    := ""
Local cTiposPrc    := ""
Local nReajuste    := 0
Local lRecPedCr    := .F.
Local lAtuPreBs    := .F.
Local cPlanilha    := ""
Local aParams      := { }
Local aPrecoBase   := {}
Local aPrecoCndM   := {}
Local lReajSC9     := .F.
Private lEnd       := .F.

SetKey( VK_F12,{|| Nil } )

AjustaSX1( cPerg )

Pergunte( cPerg,.F.)

FormBatch( OemToAnsi( "Reajuste da Tabela de Preço" ),;
           { OemToAnsi( "Esta rotina efetuará o reajuste das Tabelas de Preço, conforme os parâmetros" ),OemToAnsi( "solicitados" ) } ,;
           { { 5,.T.,{|o| Pergunte( cPerg,.T.)  } },;
		   {   1,.T.,{|o| nOpcA :=1 , o:oWnd:End() } },;
		   {   2,.T.,{|o| o:oWnd:End()      } } } )

If ( nOpcA == 1 )
    aParams := { cProdDe   := MV_PAR01, ;
                 cProdAte  := MV_PAR02, ;
                 cGrupoDe  := MV_PAR03, ;
                 cGrupoAte := MV_PAR04, ;
                 cTiposPrc := MV_PAR05, ;
                 nReajuste := MV_PAR06, ;
                 lRecPedCr := iif( MV_PAR07 == 1, .T., .F. ), ;
                 lAtuPreBs := iif( MV_PAR08 == 1, .T., .F. ), ;
                 cPlanilha := MV_PAR09 ,;
                 lReajSC9  := iif( MV_PAR10 == 1, .T., .F. )}
                 
	Processa({ |lEnd| lOk := LS02REAJPR( cAlias, nReg, nOpc, aParams, @aPrecoBase, @aPrecoCndM ),;
	                         OemToAnsi( 'Analisando itens da tabela.' ) },;
 	                         OemToAnsi( 'Aguarde...' ) )

	If lOk
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pedidos em carteira  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRecPedCr
			LSOMSPEDVD( aParams, aPrecoBase, aPrecoCndM )
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza Preço Base  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAtuPreBs
			LSOMSATUSB( aPrecoBase )
		Endif
	Endif
	
EndIf

SetKey( VK_F12,{ || Pergunte( cPerg, .T. ) } )

RestArea( aArea )

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS02REAJPR ºAutor ³ Lincoln Rossetto  º Data ³  04/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reajuste de Tabela de Preços     						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LS02REAJPR( cAlias, nReg, nOpc, aParams, aPrecBse, aPrecCndM )
******************************************************************************
Local cAliasTMP     := GetNextAlias( )
Local aAlterEnch     := {}  	//Vetor com nome dos campos que poderao ser editados
Local aCpoEnch       := {}		// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local cAliasE        := "ZAC"  	//Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     	 := ""     // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    	 := .F.    // Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        	 := .F.    // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   	 := .T.    // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  	 := .F.    // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  	 := .F.    // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    	 := 3      // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nRegE          := 0  		//Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)     
Local nOpcao	     := 1
Local aSize          := {}
Local aObjects       := {}
Local aInfo          := {}
Local aPrecoBase     := {}
Local aPrecoCndM     := {}
Local cProdDe        := aParams[ 1 ]
Local cProdAte       := aParams[ 2 ]
Local cGrupoDe       := aParams[ 3 ]
Local cGrupoAte      := aParams[ 4 ]
Local cTiposPrc      := aParams[ 5 ]
Local nReajuste      := aParams[ 6 ]
Local lRecPedCr      := aParams[ 7 ]
Local lAtuPreBs      := aParams[ 8 ]
Local cPlanilha      := aParams[ 9 ]
Local lReajSC9       := aParams[ 10 ]
Local cQuery         := "" 
Local cCondBase      := ""
Local cCondAtu       := ""
Local hEnter         := Chr( 13 )
Local lReadOnly      := .F.
Local lShared        := .T.
Local lOk            := .F.
Local aHeadTMP       := {}
Local aColsTMP       := {}
Local nNewPreco      := 0
Local nPosProd       := 0
Local bCampo         := {|nCPO| Field(nCPO)}
                     
Private aGets        := {}
Private aTela	     := {}
Private aCoMsNewGet  := {} 
Private aHoMsNewGet  := {} 
Private nOpcNewGd    := GD_UPDATE + GD_DELETE
Private cItem        := "ZAD_ITEM"
Private noMsNewGet   := 0
Private oMsNewGet    := 0
Private nPosItem     := 0
Private nColPrcBs    := 0
Private INCLUI   	 := .F.
Private ALTERA   	 := .F.
Private DELETA   	 := .F.
Private VISUAL   	 := .F.

nOpc := 4

cQuery := " SELECT ZAD.*  "                                              + hEnter
cQuery += "   FROM " + RetSqlName( "ZAD" ) + " ZAD, "                    + hEnter
cQuery += "        " + RetSqlName( "SB1" ) + " SB1  "                    + hEnter
cQuery += "  WHERE ZAD.ZAD_FILIAL          = '" + xFilial( "ZAD" ) + "'" + hEnter
cQuery += "    AND SB1.B1_FILIAL           = '" + xFilial( "SB1" ) + "'" + hEnter
cQuery += "    AND ZAD.ZAD_CODIGO          = '" + ZAC->ZAC_CODIGO  + "'" + hEnter
cQuery += "    AND SB1.B1_COD              = ZAD.ZAD_PRODUT"             + hEnter
cQuery += "    AND SB1.B1_TIPO            IN (" + cTiposPrc + ")"        + hEnter
cQuery += "    AND ( ( ZAD.ZAD_PRODUT     >= '" + cProdDe   + "' ) AND ( ZAD.ZAD_PRODUT <= '" + cProdAte  + "' ) )"  + hEnter
cQuery += "    AND ( ( SB1.B1_GRUPO       >= '" + cGrupoDe  + "' ) AND ( SB1.B1_GRUPO   <= '" + cGrupoAte + "' ) )"  + hEnter
cQuery += "    AND ZAD.D_E_L_E_T_         <> '*'"                        + hEnter
cQuery += "    AND SB1.D_E_L_E_T_         <> '*'"                        + hEnter

MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)

If Select( cAliasTMP ) > 0
	( cAliasTMP )->( dBclosearea( ) )
	Ferase( Lower( cAliasTMP ) + GetDBExtension( ) )
	Ferase( Lower( cAliasTMP ) + OrdBagExt( ) )
Endif

dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAliasTMP, lShared, lReadOnly )

( cAliasTMP )->( dBGoTop( ) )   

If !( cAliasTMP )->( Eof( ) ) .And. !( cAliasTMP )->( Bof( ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona nos itens/condições de pagamento/preço produto    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( "ZAE" )
	ZAE->( dBSetOrder( 4 ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define e Registra os Campos do Enchoice                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( cAlias )
	RegToMemory( cAlias, .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribui aos Campos registrados os valores do registro da tabela posicionado   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea(cAlias)
	For i := 1 TO ( cAlias )->( FCount() )
		M->&( Eval( bCampo, i ) ) := ( cAlias )->( FieldGet(i) )
	Next i
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader e do aCols             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_LS02001( 1 )
	
	While ( ( !( cAliasTMP )->( Eof( ) ) ) .AND. ( xFilial( "ZAD" ) == ( cAliasTMP )->ZAD_FILIAL ) .AND. ( ( cAliasTMP )->ZAD_CODIGO == ZAC->ZAC_CODIGO ) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona nos itens da Tabela de Preço/Vigência do Produto               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( "ZAD" )
		ZAD->( dBSetOrder( 3 ) )
		ZAD->( dBSeek( xFilial( "ZAD" ) + ZAC->ZAC_CODIGO + ( cAliasTMP )->ZAD_ITEM + ( cAliasTMP )->ZAD_PRODUT ) )
		
		If ( SOFTLOCK( "ZAD" ) )
			AADD( aCoMsNewGet, Array( noMsNewGet + 1 ) )
			
			For nX := 1 To noMsNewGet
				If aHoMsNewGet[ nX ][ 10 ] != "V"
					
					If Alltrim( aHoMsNewGet[ nX ][ 2 ] ) <> "ZAE_VALOR"
						
						If !Empty( nPosZAD := FieldPos( aHoMsNewGet[ nX ][ 2 ] ) )
							aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := ZAD->( FieldGet( nPosZAD ) )
						EndIf
						
					Endif
				Else
					aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := CriaVar( aHoMsNewGet[ nX ][ 2 ] )
					
					If !Empty( nPosZAD := FieldPos( aHoMsNewGet[ nX ][ 2 ] ) )
						aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := ZAD->( FieldGet( nPosZAD ) )
					EndIf
					
					/* LPR - 24-02-2012
					If Alltrim( aHoMsNewGet[ nX ][ 2 ] ) == "ZAE_VLRBAS"
						aCoMsNewGet[ Len( aCoMsNewGet ) ][ nX ] := Posicione( "SB1", 1, xFilial( "SB1" ) + ZAD->ZAD_PRODUT, "SB1->B1_PRV1" )
					Endif
					*/
					
				EndIf
				
			Next
			aCoMsNewGet[ Len( aCoMsNewGet ) ][ noMsNewGet + 1 ] := .F.
		Else
			lTravas := .T.
		EndIf
		
		( cAliasTMP )->( dBSkip( ) )
	EndDo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravação dos dados dos itens (ZAE)           ³
	//³Verifica se o item no aCols não esta deletado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nItem      := 0
	nPosItem   := aScan( aHoMsNewGet,{ |x| AllTrim( x[ 2 ] ) == cItem        } )
	nPosProd   := aScan( aHoMsNewGet,{ |x| AllTrim( x[ 2 ] ) == "ZAD_PRODUT" } )
	aPrecoBase := { }
	aPrecoCndM := { }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reajustando o Preço base de  cada Produto da Tabela ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nQ := 1 To Len( aCoMsNewGet )
		For nY := 1 To noMsNewGet
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o campo não é Virtual³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aHoMsNewGet[ nY ][ 10 ] != "V" .And. Alltrim( aHoMsNewGet[ nY ][ 2 ] ) == "ZAE_VALOR"
				
				ZAE->( dBGoTop(  ) )
				If ZAE->( dBSeek( xFilial( "ZAE" ) + ZAC->ZAC_CODIGO + aCoMsNewGet[ nQ ][ nPosItem ] + aCoMsNewGet[ nQ ][ nPosProd ] + aHoMsNewGet[ nY ][ Len( aHoMsNewGet[ nY ] ) ] ) )
					nNewPreco := 0
					If nY == nColPrcBs
						If !Empty( cPlanilha )
							nNewPreco := LS02PLAN( cPlanilha, ZAE->ZAE_PRODUT, ZAE->ZAE_VALOR )
						Else
							nNewPreco := ZAE->ZAE_VALOR + ( ZAE->ZAE_VALOR * ( nReajuste / 100 ) )
						Endif
						aAdd( aPrecoBase, { aCoMsNewGet[ nQ ][ nPosProd ], aCoMsNewGet[ nQ ][ nPosItem ], aHoMsNewGet[ nY ][ Len( aHoMsNewGet[ nY ] ) ], nNewPreco, .F. } )
						aCoMsNewGet[ nQ ][ nY ] := NoRound( nNewPreco, TAMSX3( "ZAE_VALOR" )[ 2 ] )
					Endif
				Endif
				
			EndIf
		Next nY
		
	Next nQ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reajustando o das demais condições em relação ao preço base e conforme variações de cada condição de pagamento previamente informado ³
	//³ no grupo de condições.                                                                                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nQ := 1 To Len( aCoMsNewGet )
		
		For nY := 1 To noMsNewGet
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o campo não é Virtual³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aHoMsNewGet[ nY ][ 10 ] != "V" .And. Alltrim( aHoMsNewGet[ nY ][ 2 ] ) == "ZAE_VALOR"
				nNewPreco := 0
				
				If nY <> nColPrcBs
	                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	                //³ Posiciona nos itens do Grupo de Condições da Tabela de Preço Selecionada ³
	                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	                dBSelectArea( "ZAB" )
	                ZAB->( dBSetOrder( 4 ) )
					ZAB->( dBGoTop( ) )
					
					ZAB->( dBSeek( xFilial( "ZAB" ) + ZAC->ZAC_GRPCND + aHoMsNewGet[ nY ][ Len( aHoMsNewGet[ nY ] ) ] ) )
					
					nPos := aScan( aPrecoBase, { |X| X[ 1 ] == aCoMsNewGet[ nQ ][ nPosProd ] .And. X[ 2 ] == aCoMsNewGet[ nQ ][ nPosItem ] } )
					
					If nPos > 0
						aCoMsNewGet[ nQ ][ nY ] := ( aPrecoBase[ nPos ][ 4 ] + (  aPrecoBase[ nPos ][ 4 ] * ( ( ZAB->ZAB_VARIAC / 100 ) ) ) )
					Endif
					
					aAdd( aPrecoCndM, { aCoMsNewGet[ nQ ][ nPosProd ], aCoMsNewGet[ nQ ][ nPosItem ], aHoMsNewGet[ nY ][ Len( aHoMsNewGet[ nY ] ) ], aCoMsNewGet[ nQ ][ nY ], .F. } )
					
				Endif
				
			EndIf
		Next nY
		
	Next nQ
	
	If Len( aCoMsNewGet ) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos parâmetros para criação da tela de exibição     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MsAdvSize()
		AAdd( aObjects, { 100, 050, .T., .T. } )
		AAdd( aObjects, { 100, 120, .T., .T. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		aPosObj := MsObjSize( aInfo, aObjects,.T.)
		
		/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±± Definicao do Dialog e todos os seus componentes.                        ±±
		Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
		DEFINE MSDIALOG oDlgAlt TITLE cTitulo From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL
		
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
		Enddo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Campos do Cabeçalho                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Enchoice(cAlias,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,'',oDlgAlt,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grid de Exibição                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TGroup():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],"Tabela de Preço - Itens Reajustados",oDlgAlt,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oMsNewGet := MsNewGetDados():New( aPosObj[2,1] + 10,aPosObj[2,2]+5,aPosObj[2,3]-5,aPosObj[2,4]-5,nOpcNewGd,'AllwaysTrue()','AllwaysTrue()',"+" + cItem,,0,500,'U_LS02FLOK()',.F.,.F.,oDlgAlt,aHoMsNewGet,aCoMsNewGet)
		oMsNewGet:oBrowse:Refresh()
		
		ACTIVATE MSDIALOG oDlgAlt ON INIT EnchoiceBar(oDlgAlt,{|| If(oMsNewGet:TudoOk() .AND. Obrigatorio(aGets, aTela), oDlgAlt:End(),)}, {||nOpcao := 0, oDlgAlt:End()})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso esteja tudo validado, efetua a gravação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpcao == 1
			lOk := LSOMSGRV( nOpc, oMsNewGet, .T., @aPrecoBase, @aPrecCndM )
			
			If lOk
			   aPrecBse  := aPrecoBase
			   aPrecCndM := aPrecCndM
			Endif
			
		Else
			RollBackSX8()
		EndIf
		
	Endif
Endif

If Select( cAliasTMP ) > 0
	( cAliasTMP )->( dBclosearea( ) )
	Ferase( Lower( cAliasTMP ) + GetDBExtension( ) )
	Ferase( Lower( cAliasTMP ) + OrdBagExt( ) )
Endif

Return( lOk )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor ³ Lincoln Rossetto   º Data ³  15/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funçao responsavel pela verificacao/criacao do grupo de per º±±
±±º          ³guntas utilizado como parametro para emissao do relatorio   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
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

Default pcPerg := ""

If Empty( pcPerg )
   Alert( "Faltou informar o nome do Grupo de Perguntas !!!" )
   Return( NIL )
Endif

aHelp    := { { "." + pcPerg + "01.", "Informe a faixa de produtos inicial."          } , ;
              { "." + pcPerg + "02.", "Informe a faixa de produtos final."            } , ;
              { "." + pcPerg + "03.", "Informe a faixa de grupo de produtos inicial." } , ;
              { "." + pcPerg + "04.", "Informe a faixa de grupo de produtos final."   } , ;
              { "." + pcPerg + "05.", "Informe os tipos de produtos."                 } , ;
              { "." + pcPerg + "06.", "Informe o Fator de Reajuste."                  } , ;
              { "." + pcPerg + "07.", "Recalcular Pedidos em Carteira?"               } , ;
              { "." + pcPerg + "08.", "Atualizar Preço Base do Produto? "             } , ;
              { "." + pcPerg + "09.", "Informe a Planilha de Formação de Preço."      } , ;
              { "." + pcPerg + "10.", "Estorna Itens Liberados ?"                     } }


cPerg := pcPerg

If Len( pcPerg ) < 10
   cPerg := pcPerg + Space( 10 - Len( cPerg ) )
Endif

CursorWait()
SysRefresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len( aHelp )
	aHlp := {}
	cHlp := "P" + aHelp[ nX ][ 1 ]
	aAdd( aHlp, aHelp[ nX ][ 2 ] )
	PutSX1Help( cHlp , aHlp, aHlp, aHlp )
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                                                                                                                                                                                          
aAdd( aRegs,{ cPerg, "01", "Produto de ?             ", "Produto de ?             ", "Produto de ?             ", "mv_ch1","C",TamSX3( "B1_COD"   )[ 1 ],0,0,"G",""           ,"MV_PAR01",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", "SB1","" ,"030", aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "02", "Produto até ?            ", "Produto até ?            ", "Produto até ?            ", "mv_ch2","C",TamSX3( "B1_COD"   )[ 1 ],0,0,"G",""           ,"MV_PAR02",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", "SB1","" ,"030", aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "03", "Grupo de ?               ", "Grupo de ?               ", "Grupo de ?               ", "mv_ch3","C",TamSX3( "BM_GRUPO" )[ 1 ],0,0,"G",""           ,"MV_PAR03",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", "SBM","" ,""   , aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "04", "Grupo até ?              ", "Grupo até ?              ", "Grupo até ?              ", "mv_ch4","C",TamSX3( "BM_GRUPO" )[ 1 ],0,0,"G",""           ,"MV_PAR04",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", "SBM","" ,""   , aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "05", "Tipo Produto ?           ", "Tipo Produto ?           ", "Tipo Produto ?           ", "mv_ch5","C",99                       ,0,0,"G","U_LS2VTP()" ,"MV_PAR05",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", ""   ,"" ,""   , aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "06", "Fator Reajuste ?         ", "Fator Reajuste ?         ", "Fator Reajuste ?         ", "mv_ch6","N",6                        ,4,0,"G",""           ,"MV_PAR06",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", ""   ,"" ,""   , aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "07", "Pedidos em Carteira      ", "Pedidos em Carteira ?    ", "Pedidos em Carteira      ", "mv_ch7","N",1                        ,0,0,"C",""           ,"MV_PAR07","Atualizar","Atualizar","Atualizar","","","Manter","Manter","Manter","","","","","","","","","","","","","","","","", ""   ,"" ,""   , aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "08", "Atualiza Preço Base      ", "Atualiza Preço Base ?    ", "Atualiza Preço Base      ", "mv_ch8","N",1                        ,0,0,"C",""           ,"MV_PAR08","Sim"      ,"Sim"      ,"Sim"      ,"","","Não"   ,"Não"   ,"Não"   ,"","","","","","","","","","","","","","","","", ""   ,"" ,""   , aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "09", "Planilha                 ", "Planilha            ?    ", "Planilha                 ", "mv_ch9","C",8                        ,0,0,"G","U_LS2VPLN()","MV_PAR09",""         ,""         ,""         ,"","",""      ,""      ,""      ,"","","","","","","","","","","","","","","","", ""   ,"" ,""   , aHelp[ ++nHlp ][ 1 ] } )
aAdd( aRegs,{ cPerg, "10", "Estorna Itens Liberados? ", "Estorna Itens Liberados ?", "Estorna Itens Liberados? ", "mv_cha","N",1                        ,0,0,"C",""           ,"MV_PAR10","Sim"      ,"Sim"      ,"Sim"      ,"","","Não"   ,"Não"   ,"Não"   ,"","","","","","","","","","","","","","","","", ""   ,"" ,""   , aHelp[ ++nHlp ][ 1 ] } )

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

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS2VTP   ºAutor  ³ Lincoln Rossetto   º Data ³  04/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por Validar os Tipos dos Produtos        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  
User Function LS2VTP()
**********************
Local aArea       := GetArea( )
Local aStruSX5    := {}
Local aViewSX5    := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aCmpsSX5    := { "X5_OK", "X5_CHAVE", "X5_DESCRI"  }
Local MvParDef    := ""
Local cAliasSX5   := GetNextAlias( )
Local cMarca	  := GetMark()
Local lShare      := .T.
Local lReadOnly   := .F.
Local lExec       := .T.
Local MvPar
Local cTabTMP
Private lInverte  := .F.

MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

For nX := 1 To len( aCmpsSX5 )
	If nX == 1
		aAdd( aStruSX5, { aCmpsSX5[ nX ], "C" ,    2, 0 } )
		aAdd( aViewSX5, { aCmpsSX5[ nX ], "", "  ", "@!"    } )
		
	Else
		aAdd( aStruSX5, { aCmpsSX5[ nX ], U_LSSTRSX3( aCmpsSX5[ nX ] )[ 3 ], U_LSSTRSX3( aCmpsSX5[ nX ] )[ 4 ], U_LSSTRSX3( aCmpsSX5[ nX ] )[ 5 ] } )
		aAdd( aViewSX5, { aCmpsSX5[ nX ], ""                               , U_LSSTRSX3( aCmpsSX5[ nX ] )[ 1 ], U_LSSTRSX3( aCmpsSX5[ nX ] )[ 6 ] } )
	Endif
Next

cTabTMP := CriaTrab( aStruSX5, .T. )

cQuery := "  SELECT '  ' X5_OK ,"
cQuery += "     SX5.*"          "
cQuery += "    FROM " + RetSqlName( "SX5" ) + " SX5"
cQuery += "   WHERE SX5.X5_FILIAL  = '" + xFilial( "SX5" ) + "'"
cQuery += "     AND SX5.X5_TABELA  = '02'"
cQuery += "ORDER BY SX5.X5_CHAVE"

dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAliasSX5, lShare, lReadOnly )

For nX := 1 To len( aStruSX5 )
	If aStruSX5[ nX ][ 2 ] <> "C" .And. FieldPos( aStruSX5[ nX ][ 1 ] ) <> 0
		TcSetField( cAliasSX5, aStruSX5[ nX ][ 1 ], aStruSX5[ nX ][ 2 ],aStruSX5[ nX ][ 3 ],aStruSX5[ nX ][ 4 ] )
	EndIf
Next nX

Copy TO &cTabTMP
dBCloseArea()
dBUseArea( .T.,, cTabTMP, cAliasSX5, lShare, lReadOnly )

dbSelectArea( "SX5" )
SX5->( dBGoTop( ) )
If SX5->( dbSeek( xFilial( "SX5" ) + "0002") )
	cTitulo := Alltrim( X5Descri( ) )
Endif

( cAliasSX5 )->( dBGoTop( ) )
while !( cAliasSX5 )->( Eof( ) )
    
    If Alltrim( ( cAliasSX5 )->X5_CHAVE ) $  MvPar
       RecLock( cAliasSX5, .F. )
       ( cAliasSX5 )->X5_OK  := cMarca
       ( cAliasSX5 )->( MsUnLock( ) )
    Endif
    
	( cAliasSX5 )->( dBSkip( ) )
	
enddo
( cAliasSX5 )->( dBGoTop( ) )

DEFINE MSDIALOG oDlg TITLE cTitulo From 1,1 To 400,450 of oMainWnd PIXEL

oMark := MsSelect():New( cAliasSX5, "X5_OK",,aViewSX5 ,@lInverte,@cMarca,{20,4,190,223},,, oDlg )

ObjectMethod( oMark:oBrowse,"Refresh()" )
oMark:bMark                := {|| LS2MRKONE( cAliasSX5, cMarca, lInverte ) }
oMark:oBrowse:bAllMark     := {|| LS5MRKALL( cAliasSX5, cMarca, oMark    ) }
oMark:oBrowse:lhasMark     := .T.
oMark:oBrowse:lCanAllmark  := .T.

ACTIVATE DIALOG oDlg CENTERED ON INIT ( EnchoiceBar( oDlg,{ || lExec := .T., oDlg:End() },{ || lExec := .F., oDlg:End() } ), CursorArrow(), SysRefresh() )

MvParDef := ""

If lExec
	nRecs := 0
	cRet  := ""
	( cAliasSX5 )->( dBGoTop( ) )
	while !( cAliasSX5 )->( Eof( ) )
		If ( cAliasSX5 )->X5_OK == cMarca
			nRecs++
			
			MvParDef += ( cAliasSX5 )->X5_CHAVE
			
			If nRecs == 1
				cRet += "'" + Alltrim( ( cAliasSX5 )->X5_CHAVE ) + "'"
			Else
				cRet += " ,'" + Alltrim( ( cAliasSX5 )->X5_CHAVE ) + "'"
			Endif
			
		Endif
		( cAliasSX5 )->( dBSkip( ) )
	enddo
	mvpar  := cRet
	&MvRet := mvpar
Endif

RestArea( aArea )

Return( MvParDef )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS2MRKONE  ºAutor  ³ Lincoln Rossetto   º Data ³  14/12/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por Marcar o registro exibido no MsSelectº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LS2MRKONE( cAlias, cMarca, lInverte )
*****************************************************
Local nRecNo := ( cAlias )->X5_OK

RecLock ( cAlias, .F. )

If IsMark( "X5_OK", cMarca, lInverte )
   ( cAlias )->X5_OK := cMarca
Else
   ( cAlias )->X5_OK := Space( 02 )
EndIf 

( cAlias )->( MsUnLock () )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS5MRKALL ºAutor  ³ Lincoln Rossetto   º Data ³ 14/12/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por Marcar o registro exibido no MsSelectº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LS5MRKALL( cAlias, cMarca, oMrk )
*************************************************
Local nReg	:=	( cAlias )->( RecNo( ) )

If !( cAlias )->( Eof() ) .AND. !( cAlias )->( Bof() )
   While !( cAlias )->( Eof() )
         RecLock ( cAlias, .F. )
         If Empty( ( cAlias )->X5_OK )
            ( cAlias )->X5_OK := cMarca
         Else
            ( cAlias )->X5_OK := Space( 02 )
         EndIf 
         ( cAlias )->( MsUnLock( ) )
         ( cAlias )->( dBSkip( ) )
	Enddo 
	oMrk:oBrowse:Refresh( )        
EndIf 

( cAlias )->( dBGoto( nReg ) )

Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS02PLAN ºAutor  ³ Lincoln Rossetto   º Data ³  04/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por calcular o novo valor com base em umaº±±
±±º          ³planilha de formação de preço.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LS02PLAN( cPlanilha, cProduto, nPreco )
*******************************************************
Local aArray := {}
Local nX     := 0
Local nPos   := 0

Private cArqMemo   := cPlanilha
Private lDirecao   := .T.  
Private nQualCusto := 1
Private cProg      := "R430"
Default nPreco := 0

If !Empty( cPlanilha )
	Pergunte("MTC010",.F.)
    
    dBSelectArea( "SB1" )
    SB1->( dBGoTop( ) )
	SB1->( dBSetOrder( 1 ) )
	
	If SB1->( MsSeek( xFilial( "SB1" ) + cProduto ) )
		cArqMemo := cPlanilha
		aArray   := MC010Forma( "SB1", SB1->(RecNo()), 98 )
	Endif	
	
Endif		

If ValType( aArray ) <> "A"
	aArray := {}
Endif	

If nPos == 0
	For nX := 1 To Len(aArray)
		nPos  := At("@",aArray[nX][3])
		If nPos > 0
			nPreco := aArray[nX][6]
			Exit
		EndIf
	Next nX
Endif	


Return( nPreco )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LS2VPLN    ºAutor  ³ Lincoln Rossetto   º Data ³ 09/03/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável por validar a planilha de formação de   º±±
±±º          ³ preço informada.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LS2VPLN()
***********************
Local lRet  := .T.
Local cExt  := iif( RIGHT( ALLTRIM( &( ReadVar( ) ) ), 4 ) <> ".PDV", ".PDV", "" )
Local cArq  := AllTrim( &( ReadVar( ) ) )
Local cPlan := cArq + cExt

If !Empty( cArq )
	If !File( cPlan )
		U_LSSHWHLP( "Planilha de Formação de Preço",;
	              	"Esta Planilha não existe.", ;
		            "1.) Selecione uma planilha existente para continuar com o processo de reajuste;" )
		lRet := .F.
	EndIf
Endif

Return ( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMSPEDVD ºAutor  ³ Lincoln Rossetto   º Data ³ 09/03/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável por executar a atualização dos pedidos  º±±
±±º          ³ em carteira conforme reajustado.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMSPEDVD( aParams, aPrecoBase, aPrecoCndM )
*************************************************************
Local aArea     := GetArea( )
Local cAliasSC6 := GetNextAlias()
Local cAliasSC9 := GetNextAlias()
Local cProdDe   := aParams[  1 ]
Local cProdAte  := aParams[  2 ]
Local cGrupoDe  := aParams[  3 ]
Local cGrupoAte := aParams[  4 ]
Local cTiposPrc := aParams[  5 ]
Local nReajuste := aParams[  6 ]
Local lRecPedCr := aParams[  7 ]
Local lAtuPreBs := aParams[  8 ]
Local cPlanilha := aParams[  9 ]
Local lReajSC9  := aParams[ 10 ]
Local aProdut   := {}
Local aLstProd  := {}
Local aProdAtu  := {}
Local lShare    := .T.
Local lReadOnly := .F.
Local lFound    := .F.
Local hEnter    := Chr( 13 )                  
Local cQuery    := ""
Local cCondMed  := ""
Local nPosProd  := 0
Local nPosCond  := 0
Local nPosPreco := 0
Local nX
Local nLoop     := 0
Local nPPrUnit  := 0
Local nPPrcVen  := 0
Local nPValDesc := 0
Local nPDesc    := 0
Local nPValor   := 0
Local nPos      := 0
Local cQryProd  := ""
Local cLstProd  := ""
Local lAtuSC5   := .F.
Local lAtuSC6   := .F.
Private aHeader := {}
Private aCols   := {}
Private n       := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando Produtos alterados como Preço Base ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len( aPrecoBase )
	If aPrecoBase[ nX ][ 5 ]
		
		nPos := aScan( aLstProd, aPrecoBase[ nX ][ 1 ] )
		
		If nPos == 0
			aAdd( aLstProd, aPrecoBase[ nX ][ 1 ] )
		Endif
	Endif
Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando Produtos alterados como Preço de Condição de Pagamento de Média ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len( aPrecoCndM )
	If aPrecoCndM[ nX ][ 5 ]
		nPos := aScan( aLstProd, aPrecoCndM[ nX ][ 1 ] )
		
		If nPos == 0
			aAdd( aLstProd, aPrecoCndM[ nX ][ 1 ] )
		Endif
	Endif
Next

If Len( aLstProd ) == 1
   cQryProd := "    AND  SC6.C6_PRODUTO                  = '" + aLstProd[ 1 ]  + "'" + hEnter
Else
   cLstProd := ""
   
   For nX := 1 To Len( aLstProd )
       cLstProd += "'" + aLstProd[ nX ] + "',"
   Next
   
   If Right( cLstProd, 1 ) == ","
      cLstProd := SubStr( cLstProd, 1, Len( cLstProd ) - 1 )
   Endif

   cQryProd := "    AND  SC6.C6_PRODUTO                 IN (" + cLstProd  + ")" + hEnter

Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Lista de Produtos/itens para atualização (Preço Base) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len( aPrecoBase )
	If aPrecoBase[ nX ][ 5 ]
		nPos := aScan( aProdAtu, { |X| X[ 1 ] == aPrecoBase[ nX ][ 1 ] .And. X[ 2 ] == aPrecoBase[ nX ][ 2 ] .And. X[ 3 ] == aPrecoBase[ nX ][ 3 ] .And. X[ 4 ] == aPrecoBase[ nX ][ 4 ] } )
		
		If nPos == 0
			aAdd( aProdAtu, { aPrecoBase[ nX ][ 1 ], aPrecoBase[ nX ][ 2 ], aPrecoBase[ nX ][ 3 ], aPrecoBase[ nX ][ 4 ] } )
		Endif
	Endif
Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Lista de Produtos/itens para atualização (Condição de Pagamento de Média ) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len( aPrecoCndM )
	If aPrecoCndM[ nX ][ 5 ]
		nPos := aScan( aProdAtu, { |X| X[ 1 ] == aPrecoCndM[ nX ][ 1 ] .And. X[ 2 ] == aPrecoCndM[ nX ][ 2 ] .And. X[ 3 ] == aPrecoCndM[ nX ][ 3 ] .And. X[ 4 ] == aPrecoCndM[ nX ][ 4 ] } )
		
		If nPos == 0
			aAdd( aProdAtu, { aPrecoCndM[ nX ][ 1 ], aPrecoCndM[ nX ][ 2 ], aPrecoCndM[ nX ][ 3 ], aPrecoCndM[ nX ][ 4 ] } )
		Endif
	Endif
Next

cQuery := " SELECT SC6.C6_NUM," + hEnter
cQuery += "        SC6.C6_ITEM," + hEnter
cQuery += "        SC6.C6_PRODUTO," + hEnter
cQuery += "        SC6.C6_BLQ," + hEnter
cQuery += "        SC6.C6_PRUNIT," + hEnter
cQuery += "        SC6.C6_FILIAL," + hEnter
cQuery += "        SC6.C6_QTDVEN," + hEnter
cQuery += "        SC6.C6_QTDENT," + hEnter
cQuery += "        SC6.R_E_C_N_O_ SC6RECNO," + hEnter
cQuery += "        SC5.R_E_C_N_O_ SC5RECNO " + hEnter
cQuery += "   FROM " + RetSqlName( "SC6" ) + " SC6, " + hEnter
cQuery += "        " + RetSqlName( "SB1" ) + " SB1, " + hEnter
cQuery += "        " + RetSqlName( "SC5" ) + " SC5  " + hEnter
cQuery += "  WHERE SC6.C6_FILIAL                     = '" + xFilial( "SC6" ) + "'" + hEnter
cQuery += "    AND SB1.B1_FILIAL                     = '" + xFilial( "SB1" ) + "'" + hEnter
cQuery += "    AND SC5.C5_FILIAL                     = '" + xFilial( "SC5" ) + "'" + hEnter
cQuery += "    AND SC5.C5_X_TBPRC                    = '" + ZAC->ZAC_CODIGO  + "'" + hEnter
cQuery += "    AND SB1.B1_COD                        = SC6.C6_PRODUTO"             + hEnter
cQuery += "    AND SC5.C5_NUM                        = SC6.C6_NUM"                 + hEnter
cQuery += "    AND ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0"                          + hEnter
cQuery += cQryProd + hEnter
cQuery += "    AND ( ( SB1.B1_GRUPO                 >= '" + cGrupoDe + "' ) AND ( SB1.B1_GRUPO        <= '" + cGrupoAte + "' ) )" + hEnter
cQuery += "    AND SC5.C5_TIPO                  NOT IN ('C','I','P')"  + hEnter
cQuery += "    AND SC6.C6_BLQ                   NOT IN ('R ')"         + hEnter
cQuery += "    AND SB1.B1_TIPO                      IN (" + Alltrim( cTiposPrc ) + ")"        + hEnter
cQuery += "    AND SC6.C6_PRUNIT                    <> 0 "   + hEnter
cQuery += "    AND SB1.D_E_L_E_T_                   <> '*' " + hEnter
cQuery += "    AND SC5.D_E_L_E_T_                   <> '*' " + hEnter
cQuery += "    AND SC6.D_E_L_E_T_                   <> '*' " + hEnter

MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery )

If Select( cAliasSC6 ) > 0
	( cAliasSC6 )->( dBCloseArea( ) )
Endif

dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAliasSC6, lShare, lReadOnly )

If !( cAliasSC6 )->( Eof() )
	dbSelectArea( "SX3" )
	SX3->( dbSetOrder( 1 ) )
	SX3->( MsSeek( "SC6" ) )
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If ( X3USO(SX3->X3_USADO) .And. !(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) .And. Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And. Trim( SX3->X3_CAMPO ) <> "C6_QTDENT" 	.And. cNivel >= SX3->X3_NIVEL )
			Aadd( aHeader, { TRIM(X3Titulo()),;
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
Endif

While !( cAliasSC6 )->( Eof() ) .And. ( cAliasSC6 )->C6_FILIAL == xFilial( "SC6" )
	lAtualiza := .F.
	
	If  ( cAliasSC6 )->C6_BLQ      <> 'R  ' .And. ;
		( cAliasSC6 )->C6_PRUNIT   <> 0     .And. ;
		( ( cAliasSC6 )->C6_QTDVEN   - ( cAliasSC6 )->C6_QTDENT > 0 ) .And. ;
		( ( ( cAliasSC6 )->C6_PRODUTO >= cProdDe ) .And. ( ( cAliasSC6 )->C6_PRODUTO <= cProdAte ) )
		
		dBSelectArea( "SB1" )
		SB1->( dbSetOrder( 1 ) )
		SB1->( dBGoTop( ) )
		SB1->( MsSeek( xFilial( "SB1" ) + ( cAliasSC6 )->C6_PRODUTO ) )
		
		dBSelectArea( "SC5" )
		SC5->( dbSetOrder( 1 ) )
		SC5->( dBGoTop( ) )
		SC5->( MsSeek( xFilial( "SC5" ) + ( cAliasSC6 )->C6_NUM ) )
		If ( ( !SC5->C5_TIPO $ "CIP" ) .And. (  ( SB1->B1_GRUPO >= cGrupoDe ) .And. ( SB1->B1_GRUPO <= cGrupoAte ) ) .And. ( SB1->B1_TIPO $ cTiposPrc ) .And.  ( SC5->C5_X_TBPRC == ZAC->ZAC_CODIGO ) )
			lAtualiza := .T.
		EndIf
		
		If lAtualiza
			dBSelectArea( "SE4" )
			SE4->( dBSetOrder( 1 ) )
			SE4->( dBGoTop( ) )
			SE4->( MsSeek( xFilial( "SE4" ) + SC5->C5_CONDPAG ) )
			
			cCondMed := SE4->E4_X_CNDMD
			
			If Empty( cCondMed )
				lAtualiza := .F.
			Endif
			
		Endif
		
		If lAtualiza
		Endif
		
	EndIf
	
	lAtuSC5 := .F.
	lAtuSC6 := .F.
	
	If lAtualiza
		Begin Transaction
			If RecLock( "SC5" )
				
				lAtuSC5 := .T.
				
				RegToMemory( "SC5", .F., .F. )
				
				dBSelectArea( "SC6" )
				SC6->( dBSetOrder( 1 ) )
				SC6->( dBGoTop( ) )
				lFound := SC6->( dBSeek( xFilial( "SC6" ) + ( cAliasSC6 )->C6_NUM + ( cAliasSC6 )->C6_ITEM + ( cAliasSC6 )->C6_PRODUTO ) )
				
				If lFound
					If RecLock( "SC6" )
						
						lAtuSC6 := .T.
						
						aCols := {}
						
						aadd( aCols, Array( Len( aHeader ) + 1 ) )
						aCols[ 1 ][ Len( aHeader ) + 1 ] := .F.
						
						For nLoop := 1 To Len( aHeader )
							Do Case
								Case AllTrim( aHeader[ nLoop ][ 2 ] ) == "C6_PRUNIT"
									nPPrUnit := nLoop
									
								Case AllTrim( aHeader[ nLoop ][ 2 ] ) == "C6_PRCVEN"
									nPPrcVen := nLoop
									
								Case AllTrim( aHeader[ nLoop ][ 2 ] ) == "C6_VALDESC"
									nPValDesc := nLoop
									
								Case AllTrim( aHeader[ nLoop ][ 2 ] ) == "C6_DESCONT"
									nPDesc := nLoop
									
								Case AllTrim( aHeader[ nLoop ][ 2 ] ) == "C6_VALOR"
									nPValor:= nLoop
							EndCase
							
							If aHeader[ nLoop ][ 10 ] <> "V"
								aCols[ 1 ][ nLoop ] := SC6->( FieldGet( FieldPos( aHeader[ nLoop ][ 2 ] ) ) )
							Endif
							
						Next nLoop
						
						nPrcOrig := SC6->C6_PRUNIT
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verificando se o produto + Condição de Pagamento Média é do Preço Base ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						// aPrecoBase := { aCoMsNewGet[ nQ ][ nPosProd ], aCoMsNewGet[ nQ ][ nPosItem ], aHoMsNewGet[ nY ][ Len( aHoMsNewGet[ nY ] ) ], nNewPreco }
						
						nPos := aScan( aProdAtu, { |X| X[ 1 ] == ( cAliasSC6 )->C6_PRODUTO .And. X[ 3 ] == cCondMed } )
						
						If nPos > 0
							M->C6_PRUNIT := NoRound( aProdAtu[ nPos ][ 4 ], TAMSX3( "C6_PRUNIT" )[ 2 ] )
						Endif
						
						If ( ( nPos > 0  ) .And. ( M->C6_PRUNIT <> nPrcOrig ) )
							
							A410MultT( "C6_PRUNIT", M->C6_PRUNIT )
							
							aCols[1][nPPrunit] := M->C6_PRUNIT
							
							SC6->C6_PRUNIT        := aCols[ 1 ][ nPPrUnit  ]
							SC6->C6_PRCVEN        := aCols[ 1 ][ nPPrcVen  ]
							SC6->C6_VALDESC       := aCols[ 1 ][ nPValDesc ]
							SC6->C6_DESCONT       := aCols[ 1 ][ nPDesc    ]
							SC6->C6_VALOR         := aCols[ 1 ][ nPValor   ]
							
							If lReajSC9
								cQuery := "SELECT SUM( SC9.C9_QTDLIB ) C9_QTDLIB " + hEnter
								cQuery += "  FROM " + RetSqlName( "SC9" ) +" SC9 " + hEnter
								cQuery += " WHERE SC9.C9_FILIAL    = '" + xFilial( "SC9" ) + "'" + hEnter
								cQuery += "   AND SC9.C9_PEDIDO    = '" + ( cAliasSC6 )->C6_NUM  + "'" + hEnter
								cQuery += "   AND SC9.C9_ITEM      = '" + ( cAliasSC6 )->C6_ITEM + "'" + hEnter
								cQuery += "   AND SC9.C9_NFISCAL   = '" + Space( TamSX3( 'C9_NFISCAL' )[ 1 ] ) + "'" + hEnter
								cQuery += "   AND SC9.D_E_L_E_T_  <> '*'" + hEnter
								
								MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery )
								
								If Select( cAliasSC9 ) > 0
									( cAliasSC9 )->( dBCloseArea( ) )
								Endif
								
								dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAliasSC9, lShare, lReadOnly )
								nQtdLib := ( cAliasSC9 )->C9_QTDLIB
								
								( cAliasSC9 )->( dBCloseArea( ) )
								
								dBSelectArea( "SC9" )
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Efetua o estorno dos itens do pedido de venda                           ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//MaAvalSC6( "SC6",2,"SC5",.T.,.F.)
								
								SC6->C6_QTDLIB	:= nQtdLib
								
								nQtdLib := 0
								MaAvalSC6("SC6",1,"SC5",.T.,.F.)
								
								If Select( cAliasSC9 ) > 0
									( cAliasSC9 )->( dBCloseArea( ) )
								Endif

							EndIf
						Endif
					EndIf
				Endif
			Endif
			
			If lAtuSC5
			   SC5->( MsUnLock( ) )
			Endif

			If lAtuSC6
			   SC6->( MsUnLock( ) )
			Endif

		End Transaction

	Endif
    ( cAliasSC6 )->( dBSkip() )
Enddo

Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMSATUSB ºAutor  ³ Lincoln Rossetto   º Data ³ 16/04/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável por atualizar o preço base do Produto   º±±
±±º          ³ no Cadastro de Produtos.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMSATUSB( aPrecoBase )
****************************************
Local aArea := SB1->( GetArea( ) )
Local nX
If Len( aPrecoBase ) > 0
	dBSelectArea( "SB1" )
	SB1->( dBSetOrder( 1 ) )
	
	For nX := 1 To Len( aPrecoBase )
		SB1->( dBGoTop( ) )
		If aPrecoBase[ nX ][ 5 ]
			If SB1->( dBSeek( xFilial( "SB1" ) + aPrecoBase[ nX ][ 1 ] ) )
				
				If aPrecoBase[ nX ][ 4 ] > 0
					RecLock( "SB1", .F. )
					SB1->B1_PRV1 := NoRound( aPrecoBase[ nX ][ 4 ], TAMSX3( "B1_PRV1" )[ 2 ] ) 
					SB1->( MsUnLock() )
				Endif
				
			Endif
		Endif
	Next
Endif

RestArea( aArea )

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSOMSGRV  ºAutor  ³Lincoln Rossetto    º Data ³  04/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para efetur a gravação dos dados nas tabelaº±±
±±º          ³ZAC (Cabeçalho) e ZAD (Itens)                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSOMS02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LSOMSGRV( nOpc, oMsNewGet, lReaj, aPrecBse, aPrecCndM )
***********************************************************************
Local aHeader  := oMsNewGet:aHeader      
Local aCols	   := oMsNewGet:aCols
Local cNumCod  := M->ZAC_CODIGO
LOCAL cValItem := ""
Local cCodigo  := ""
Local cItem    := "ZAD_ITEM"
Local cMay     := "ZAC" + ALLTRIM( xFilial( "ZAC" ) ) + cNumCod
Local nPosItem := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == cItem        } )
Local nPosProd := aScan( aHeader,{ |x| AllTrim( x[ 2 ] ) == "ZAD_PRODUT" } )
Local nUsado   := Len( aHeader )
Local nLenGet  := oMsNewGet:nAt
Local nPosZCI  := 0
Local nItem    := 0
Local lGravou  := .F.          
Local nCont	   := 0
Local nI, nX, nY

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
  		While ( MsSeek( xFilial( "ZAC" ) + cNumCod ) .OR. !MayIUseCode( cMay ) ) 
    		cNumCod       := Soma1( cNumCod,Len( cNumCod ) )
        	cMay          := "ZAC" + ALLTRIM( xFilial("ZAC" ) ) + cNumCod 
        	M->ZAC_CODIGO := cNumCod
     	EndDo
     	
  		BEGIN TRANSACTION        
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³Gravação dos dados do cabeçalho (ZAC)³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 		dBSelectArea( "ZAC" )
	     	ZAC->( dBSetOrder( 1 ) )
	      	RecLock(  "ZAC", .T. )
	       	For nI := 1 To ZAC->( FCount() )
	        	If ZAC->( FieldName( nI ) )  == "ZAC_FILIAL" 
	            	FieldPut( nI, xFilial( "ZAC" ) )
	            Else                             
	                FieldPut( nI, M->&( FieldName( nI ) ) )
	            Endif
	         Next
	         
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação dos dados dos itens (ZAD)   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        	For nX := 1 To Len( aCols )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Verifica se o item no aCols não esta deletado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
         		If !aCols[ nX ][ nUsado+1 ] 
         			dBSelectArea( "ZAD" )
         			ZAD->( dBSetOrder( 1 ) )        
					RecLock(  "ZAD", .T. )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Laço para gravação de todos os campos do item presentes no GetDados³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         			For nY := 1 To nUsado   
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o campo não é Virtual³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          				If aHeader[ nY ][ 10 ] != "V"
          					If !Empty(nPosZAD := FieldPos( aHeader[ nY ][ 2 ] ) )
               					ZAD->( FieldPut( nPosZAD, aCols[ nX ][ nY ] ) ) 
          					EndIf        
          				EndIf
         			Next nY                             
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava campos do item os quais não estao no GetDados³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         			ZAD->ZAD_FILIAL := xFilial( "ZAD" )
         			ZAD->ZAD_CODIGO := M->ZAC_CODIGO
         		EndIf 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄî
				//³Confirma a gravação do item na ZC4³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄî
           	Next nX          

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação dos dados dos itens (ZAE)   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        	For nX := 1 To Len( aCols )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Verifica se o item no aCols não esta deletado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
         		If !aCols[ nX ][ nUsado+1 ] 
         			dBSelectArea( "ZAE" )
         			ZAE->( dBSetOrder( 1 ) )        
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Laço para gravação de todos os campos do item presentes no GetDados³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         			For nY := 1 To nUsado   
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o campo não é Virtual³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          				If aHeader[ nY ][ 10 ] != "V"
          					If Alltrim( aHeader[ nY ][ 2 ] ) == "ZAE_VALOR"
					           RecLock( "ZAE", .T. )
					           
					           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					           //³Grava campos do item os quais não estao no GetDados³
					           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					           nPosZAE         := FieldPos( aHeader[ nY ][ 2 ] )
         			           ZAE->ZAE_FILIAL := xFilial( "ZAE" )
         			           ZAE->ZAE_CODIGO := M->ZAC_CODIGO
         			           ZAE->ZAE_ITEM   := aCols[ nX ][ nPosItem ]
         			           ZAE->ZAE_PRODUT := aCols[ nX ][ nPosProd ]
          					   ZAE->ZAE_COND   := aHeader[ nY ][ Len( aHeader[ nY ] ) ]
          					   ZAE->ZAE_VALOR  := FieldPut( nPosZAE, aCols[ nX ][ nY ] )
          					Endif
          				EndIf
         			Next nY                             
         		EndIf 
           	Next nX          
           	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Terminou de gravar os itens, confirma a gravação do cabeçalho³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	ZAC->( MsUnLock( ) )
            ZAD->( MsUnLock( ) )           	
            ZAE->( MsUnLock( ) )           	
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
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravação dos dados do cabeçalho (ZC3)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 		dBSelectArea( "ZAC" )
	     	ZAC->( dbSetOrder( 1 ) )
	     	If ZAC->( dbSeek( xFilial( "ZAC" ) + M->ZAC_CODIGO ) )
	      		RecLock( "ZAC", .F.)
	       		For nI := 1 To ZAC->( FCount() )
	        		If ZAC->( FieldName( nI ) ) == "ZAC_FILIAL" 
	            		FieldPut( nI, xFilial( "ZAC" ) )
	            	Else                             
	            	    FieldPut( nI, M->&( FieldName( nI ) ) )
	            	Endif
	         	Next
	         	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Gravação dos dados dos itens (ZAD)   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        		For nX := 1 To Len( aCols )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Verifica se o item no aCols não esta deletado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
         			If !aCols[ nX ][ nUsado+1 ] 
         				
         				dBSelectArea( "ZAD" )
         				ZAD->( dBGoTop(  ) )        
         				ZAD->( dBSetOrder( 2 ) )        
         				If ZAD->( dBSeek( xFilial( "ZAD" ) + M->ZAC_CODIGO + aCols[ nX ][ nPosItem ] ) )
					     	RecLock( "ZAD", .F.)
				     	Else
					    	RecLock( "ZAD",.T.)
				     	EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Laço para gravação de todos os campos do item presentes no GetDados³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         				For nY := 1 To nUsado   
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o campo não é Virtual³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          					If aHeader[ nY ][ 10 ] != "V"
          						If !Empty(nPosZAD := FieldPos(aHeader[ nY ][ 2 ] ) )
               						ZAD->(FieldPut(nPosZAD, aCols[ nX ][ nY ] ) ) 
          						EndIf        
          					EndIf
         				Next nY                                            

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Trata o item do Produto conforme o Processo Origem ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lReaj
						   cValItem := StrZero( ++nCont, TAMSX3( cItem )[ 1 ] )
						Else
						   cValItem := aCols[ nX ][ nPosItem ]
						Endif
						
         				ZAD->ZAD_FILIAL := xFilial( "ZAD" )
         				ZAD->ZAD_ITEM	:= cValItem
         				ZAD->ZAD_CODIGO	:= M->ZAC_CODIGO

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Grava campos do item os quais não estao no GetDados³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         				dBSelectArea( "ZAE" )
         				ZAE->( dBSetOrder( 5 ) )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Laço para gravação de todos os campos do item presentes no GetDados³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         				For nY := 1 To nUsado   
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o campo não é Virtual³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          					If aHeader[ nY ][ 10 ] != "V" .And. Alltrim( aHeader[ nY ][ 2 ] ) == "ZAE_VALOR"
         				        ZAE->( dBGoTop(  ) )
         				        If ZAE->( dBSeek( xFilial( "ZAE" ) + M->ZAC_CODIGO + aCols[ nX ][ nPosItem ] + aHeader[ nY ][ Len( aHeader[ nY ] ) ] ) )
					     	       RecLock( "ZAE", .F.)
				     	        Else
					    	       RecLock( "ZAE",.T.)
				     	        EndIf
					           	
					           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					           	//³Grava campos do item os quais não estao no GetDados³
					           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					           	nPosZAE         := FieldPos( aHeader[ nY ][ 2 ] )
         			           	ZAE->ZAE_FILIAL := xFilial( "ZAE" )
         			           	ZAE->ZAE_CODIGO := M->ZAC_CODIGO
         			           	ZAE->ZAE_ITEM   := cValItem
         			           	ZAE->ZAE_PRODUT := aCols[ nX ][ nPosProd ]
          					   	ZAE->ZAE_VALOR  := FieldPut( nPosZAE, aCols[ nX ][ nY ] )
          					    ZAE->ZAE_COND   := aHeader[ nY ][ Len( aHeader[ nY ] ) ]
          					    
          					    If lReaj
					           	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					           	    //³ Atualiza quais Produtos/Condições da tabela foram atualizados para serem utilizados no processo de atualização de carteira ³
					           	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          					        nPos := aScan( aPrecBse, { |X| X[ 1 ] == aCols[ nX ][ nPosProd ] .And. X[ 3 ] == aHeader[ nY ][ Len( aHeader[ nY ] ) ] } )
          					    
          					        If nPos > 0
          					           aPrecBse[ nPos ][ 5 ] := .T.
          					        Else
          					           nPos := aScan( aPrecCndM, { |X| X[ 1 ] == aCols[ nX ][ nPosProd ] .And. X[ 3 ] == aHeader[ nY ][ Len( aHeader[ nY ] ) ] } )
          					       
          					           If nPos > 0
          					              aPrecCndM[ nPos ][ 5 ] := .T.
          					           Endif
          					        Endif
          					    Endif
          					    
          					EndIf
          					
         				Next nY                                            
         				
      				Else     
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Como o processo de alteração é compartilhado com o processo de reajuste, quando for chamado pelo processo de reajuste ³
						//³ não exclui nenhum item da tabela de preço.                                                                            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lReaj
						    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						    //³Trata-se de alteração eliminando o item da tabela³
						    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      					    dBSelectArea( "ZAD" )
         				    ZAD->( dBSetOrder( 2 ) )        
         				    If ZAD->( dBSeek( xFilial( "ZAD" ) + M->ZAC_CODIGO + aCols[ nX ][ nPosItem ] ) )
						 	    RecLock(  "ZAD", .F. )
      						    ZAD->( dBDelete( ) )
      					    EndIf
						
						    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						    //³Grava campos do item os quais não estao no GetDados³
						    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         				    dBSelectArea( "ZAE" )
         				    ZAE->( dBSetOrder( 5 ) )
						    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						    //³Laço para gravação de todos os campos do item presentes no GetDados³
						    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         				    For nY := 1 To nUsado   
							    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							    //³Verifica se o campo não é Virtual³
							    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          					    If aHeader[ nY ][ 10 ] != "V" .And. Alltrim( aHeader[ nY ][ 2 ] ) == "ZAE_VALOR"
         				            ZAE->( dBGoTop(  ) )
         				            If ZAE->( dBSeek( xFilial( "ZAE" ) + M->ZAC_CODIGO + aCols[ nX ][ nPosItem ] + aHeader[ nY ][ Len( aHeader[ nY ] ) ] ) )
					     	           RecLock( "ZAE", .F.)
					     	           ZAD->( dBDelete( ) )
				     	            EndIf
          				    	EndIf
         				    Next nY                                            
                        Endif
         			EndIf 
           			
           		Next nX          
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Terminou de gravar os itens, confirma a gravação do cabeçalho³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           		ZAC->( MsUnLock( ) )
           		ZAD->( MsUnLock( ) )
           		ZAE->( MsUnLock( ) )
           		
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
	 		dBSelectArea( "ZAC" )
	     	ZAC->( dBSetOrder( 1 ) )
	     	If ZAC->( dBSeek( xFilial( "ZAC" ) + M->ZAC_CODIGO ) ) 
	      		RecLock( "ZAC", .F. )
	    		ZAC->( dBDelete( ) )
	    		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Exclusao dos dados dos itens³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	    		dBSelectArea( "ZAD" )
       			ZAD->( dBSetOrder( 1 ) )        
         		
         		If ZAD->( dBSeek( xFilial( "ZAD" ) + M->ZAC_CODIGO ) )
					While !ZAD->( EOF( ) ) .AND. ZAD->ZAD_CODIGO == M->ZAC_CODIGO .And. ZAD->ZAD_FILIAL == xFilial( "ZAD" )
						RecLock( "ZAD", .F.)						
					 	ZAD->( dBDelete( ) )
					   	ZAD->( dbSkip( ) )
					EndDo
				EndIf 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Exclusao dos dados dos itens³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	    		dBSelectArea( "ZAE" )
       			ZAE->( dBSetOrder( 1 ) )        
         		
         		If ZAE->( dBSeek( xFilial( "ZAE" ) + M->ZAC_CODIGO ) )
					While !ZAE->( EOF( ) ) .AND. ZAE->ZAE_CODIGO == M->ZAC_CODIGO .And. ZAE->ZAE_FILIAL == xFilial( "ZAE" )
						RecLock( "ZAE", .F.)						
					 	ZAE->( dBDelete( ) )
					   	ZAE->( dbSkip( ) )
					EndDo
				EndIf 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÜ
				//³Confirma exclusao do cabecalho e dos itens³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÜ
				ZAC->( MsUnLock( ) )    		
				ZAD->( MsUnLock( ) )
				ZAE->( MsUnLock( ) )
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄo
//³Restaura ponteiros do mouse³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄo
CursorArrow()  
SysRefresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Efetua procedimentos para fechar o Alias manipulado (ZC4)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If Select( "ZAD" ) > 0
	ZAD->( dBCloseArea( ) )
EndIf

If Select( "ZAE" ) > 0
	ZAE->( dBCloseArea( ) )
EndIf

Return( lGravou )


User Function Arruma()
**********************
dBSelectArea( "SX3" )
SX3->( dBSetOrder( 1 ) )
SX3->( dBGoTop(  ) )
while !SX3->( Eof( ) )
	If '_FILIAL' $ Alltrim( SX3->X3_CAMPO )
		cCampo  := SX3->X3_CAMPO
		cTabela := SX3->X3_ARQUIVO
		dBSelectArea( cTabela )
		( cTabela )->( dBGoTop(  ) )
		while !( cTabela )->( Eof( ) )
			RecLock( cTabela, .F. )
			( cTabela )->&cCampo := xFilial( cTabela )
			( cTabela )->( MsUnLock( ) )
			( cTabela )->( dBSkip( ) )
		Enddo
	Endif
	SX3->( dBSkip( ) )
Enddo

Return( .T. )
