/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01 º Autor ³TOTVS PARANA CENTRALº Data ³  19/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de Envio de Dados Fornecedores/Retorno BB.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "TOPCONN.CH"

Static N_PAN_PRIN    := 0
Static N_PAN_LAY     := 1
Static N_PAN_ARQ     := 2
Static N_PAN_PAR1    := 3
Static N_PAN_PAR2    := 4
Static N_PAN_SWNF    := 5
Static N_PAN_CONF    := 6
Static N_PAN_GODO    := 7

User Function LTRCOF01()
************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oWizard
Local nMetGlobP
Local oRadioArq
Local oMetGlobP
Local cAliasRem     := GetNextAlias()
Local cAliasSD1     := GetNextAlias()
Local aBanco        := &( GetMV( "MV_BCRCOF1" ) )	
Local cProdutos     := &( GetMV( "MV_BCRCOF2" ) )	
Local lShare        := .T.  
Local lReadOnly     := .F.
Local nRadioLOut    := 0
Local aHeader       := {}
Local aCols         := {}
Local cFile			:= Space( 8 )
Local cHeader 		:= "Geração de Arquivos RCOF 310 RCOF 312."
Local cTpArq		:= "Delimitado (*.txt)|*.txt|"
Local cLayOut		:= ""
Local cText 	    := 	 "Esta rotina tem por objetivo gerar arquivo RCOF com os dados dos" + ; 
			             "Fornecedores Classificados como Produtores de Leite e seus respe-"+ ; 
			             "ctivos movimentos para o Banco do Brasil." + CRLF +  CRLF + ; 
			             "Verifique os parâmetros e ao final será gerado um arquivo conforme o Lay-out desejado."+ CRLF + CRLF

Local dDataIni      := dDataFim := CTOD( "  /  /  " )
Local cAgCont       := CriaVar( "Z3_AGENCIA" )
Local cCcCont       := CriaVar( "Z3_CTACONT" )
Local cNumCont      := CriaVar( "Z3_NUMCONT" )
Local cProdDe       := CriaVar( "B1_COD" )
Local cProdAte      := CriaVar( "B1_COD" )
Local cUor          := CriaVar( "Z3_UOR" )
Local aStruSZ3      := {}
Local aStruSD1      := {}
Local cTabTMP       := ""
Local nTotalV       := 0
Local nTotalL       := 0

Local cCodFina      := Space( 05 )
Local cDesFina      := Space( 20 )
Local cCodProdFin   := Space( 05 )
Local cDescPrdFin   := Space( 30 )
Local cUmProdFin    := Space( 20 )
Local nVlTetoFin    := 0

Local cPerg         := "LTRCOF01X1"
Local oTotalV
Local oTotalL 

Private INCLUI	  := .T.
Private ALTERA	  := .F.
Private aViewSZ3  := {}
Private aViewSD1  := {}
Private lFirst    := .T.              

Private lInverte := .F.
Private cMarca   := GetMark()
Private cIndica310  := ""
Private cIndica312  := ""

cAgCont   := iif( Empty( aBanco[ 1 ] ), Space( TamSX3( "Z3_AGENCIA" )[ 1 ] ), aBanco[ 1 ] )
cCcCont   := iif( Empty( aBanco[ 2 ] ), Space( TamSX3( "Z3_CTACONT" )[ 1 ] ), aBanco[ 2 ] )
cNumCont  := iif( Empty( aBanco[ 3 ] ), Space( TamSX3( "Z3_NUMCONT" )[ 1 ] ), aBanco[ 3 ] )
cUor      := iif( Empty( aBanco[ 4 ] ), Space( TamSX3( "Z3_UOR"     )[ 1 ] ), aBanco[ 4 ] )
cProdDe   := cProdutos
cProdAte  := cProdutos
dDataIni  := FirstDay( dDataBase )
dDataFim  := dDataBase
	
//*************************************//
    // 1                                   //
// Primeiro Painel - Abertura          //
//*************************************//
DEFINE WIZARD oWizard 	TITLE "Geração do Arquivo RCOF" HEADER cHeader MESSAGE "Apresentação." TEXT cText;
						NEXT   {|| .T. } ;
						FINISH {|| .T. } PANEL


//*************************************//
// 2                                   //
// Segundo Painel - Arquivo e Contrato //
//*************************************//
CREATE PANEL oWizard 	HEADER cHeader ;
						MESSAGE "Selecione o Lay-Out que deseja utilizar para geração do arquivo;" ;
						BACK {|| .T. } ;
						NEXT {|| nRadioLOut > 0 } ;
						FINISH {||  .T., oWizard:End() } ;
						PANEL
         
oPanel     := oWizard:oMPanel[ 2 ]//oWizard:GetPanel( N_PAN_LAY )


@ 15, 08 GROUP oGrpCon 	TO 120, 230 LABEL "Lay-Out" OF oPanel PIXEL DESIGN
     
@ 25,35 Radio oRadioArq Var nRadioLOut Items "RCOF 310 - Remessa de Lotes Movimentos",;
											 "RCOF 312 - Remessa " ;
											 3D Size 280,10 Of oPanel PIXEL DESIGN ;                    
											 ON CHANGE LTRCOF01CR( nRadioLOut, @cLayOut, @cFile, @cAgCont, @cCcCont, @cNumCont, @cUor )
											 
											 
//											 "Nome do arquivo para gerar a Exportação."
//******************************************************//
// 3                                                    //
// Terceiro Painel - Arquivo para importação/exportação //
//******************************************************//
CREATE PANEL oWizard 	HEADER cHeader ;
						MESSAGE "Nome do arquivo para gerar a Exportação."  ;
						BACK {|| .T. } ;
						NEXT {|| oWizard:SetPanel( iif( cLayOut == "310", N_PAN_PAR1,  N_PAN_PAR2 ) ), .T. } ;
						FINISH {|| .T., oWizard:End() } ;
						PANEL         

oPanel     := oWizard:oMPanel[ 3 ] //oWizard:GetPanel( N_PAN_ARQ )

@ 10, 08 GROUP oGrpArq 	TO 40, 280 LABEL "Arquivo..." ; 
						OF oPanel ;
						PIXEL ;
     					DESIGN

@ 20, 15 MSGET oArq 	VAR cFile OF oPanel PICTURE "@!" SIZE 220, 10 PIXEL 

@ 50, 08 GROUP oGrpArq2 TO 130, 280 LABEL "Observações" ; 
						OF oPanel;
						PIXEL ;
     					DESIGN

@ 65, 20 SAY "Nome do arquivo que será utilizado para a geração do Arquivo no LayOut [RCOF: " + iif( nRadioLOut == 1, "310", "312" ) + "]."    OF oPanel SIZE 300, 8 PIXEL   
@ 80, 20 SAY "Por Padrão o arquivo será gerado em [C:\" + cFile + "]"    OF oPanel SIZE 300, 8 PIXEL   
    


//************************************************//
// 4                                              //
// Quarto Painel - Parâmetros                     //
//************************************************//
CREATE PANEL oWizard 	HEADER cHeader ;
						MESSAGE "Parâmetros" ; 
						BACK {|| oWizard:SetPanel( N_PAN_ARQ  ), .T. } ;
						NEXT {|| IIF( LTRCOF01V2( dDataIni, dDataFim ), ( LTRCOF01NF( @aViewSD1, @aStruSD1, @cAliasSD1, dDataIni, dDataFim,  cProdDe, cProdAte, @nTotalV, @nTotalL, @oTotalV, @oTotalL ), oWizard:SetPanel( iif( cLayOut == "310", N_PAN_SWNF,  N_PAN_CONF )  ), .T. ), .F. ) } ;
						FINISH {|| .T., oWizard:End() } ;
						PANEL  

oPanel      := oWizard:oMPanel[ 4 ] // oWizard:GetPanel( N_PAN_PAR1 )

@ 05, 08 GROUP oGrpPar 	TO 130, 300 LABEL "Parâmetros..." OF oPanel PIXEL DESIGN

@ 010, 122 GROUP oGrpDiv TO 125,125 LABEL "" OF oPanel PIXEL DESIGN

oScroll := TScrollBox():New( oGrpPar, 12, 10, 115, 110, .T.,.F.,.F.)

nLin := 05

@ nLin, 003 SAY "Período Inicial"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Período Final"      OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Agência Contrato"   OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "C/C Contrato"       OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Número Contrato"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Unidade Organiz."   OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Produto de"         OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Produto até"         OF oScroll SIZE 140, 8 PIXEL   
  
//
  
nLin := 05

@ nLin, 050 MSGET oPerIni    VAR dDataIni  OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 050 MSGET oPerFim    VAR dDataFim  OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 050 MSGET oAgencia   VAR cAgCont OF oScroll SIZE 50, 10 PIXEL 
nLin+=15  

@ nLin, 050 MSGET oContaCor  VAR cCcCont OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 050 MSGET oNumCont   VAR cNumCont  OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 050 MSGET oUOR   VAR cUor  OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 050 MSGET oProdDe   VAR cProdDe  F3 "SB1" OF oScroll SIZE 50, 10 PIXEL Valid iif( !Empty( cProdDe ), ExistCPO( "SB1", cProdDe ), .T. )
nLin+=15

@ nLin, 050 MSGET oProdAte   VAR cProdAte  F3 "SB1" OF oScroll SIZE 50, 10 PIXEL Valid iif( !Empty( cProdAte ) .And. ( cProdAte <> Replicate( "Z", TamSX3( 'B1_COD' )[ 1 ] ) ), ExistCPO( "SB1", cProdAte ), .T. )
nLin+=15

cUseFld := ""
dBSelectArea( "SX3" )
SX3->( dBSetOrder( 1 ) )
SX3->( dBGoTop( ) )
SX3->( dBSeek( "SZ3" ) )
While SX3->X3_ARQUIVO == "SZ3" .And. !SX3->( Eof( ) )
	
	cField  := ""
	cTitulo := ""
	
	If !Alltrim( SX3->X3_CAMPO ) $ "Z3_FILIAL | Z3_STATUS | Z3_USERLGI | Z3_USERLGA | Z3_MSFIL | Z3_MSEMP"
		
		If !Alltrim( SX3->X3_CAMPO ) $ "Z3_OK"
			cTitulo := AllTrim( X3Titulo( ) )
		Endif
		
		aAdd( aViewSZ3, { SX3->X3_CAMPO, ""          ,  cTitulo       , SX3->X3_PICTURE } )
		aAdd( aStruSZ3, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		cUseFld += "SZ3." + Alltrim( SX3->X3_CAMPO ) + ", " + Chr( 13 )
		
	Endif
	
	SX3->( dBSkip( ) )
	
Enddo

cUseFld := SubStr( Alltrim( cUseFld ), 1, Len( Alltrim( cUseFld ) ) - 3 ) + Chr( 13 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consultando dados das remessas geradas      '³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT " + cUseFld   + Chr( 13 )
cQuery += "  FROM " + RetSqlName( "SZ3" ) + " SZ3" + Chr( 13 )
cQuery += " WHERE SZ3.Z3_FILIAL    = '" + xFilial( "SZ3" ) + "'" + Chr( 13 )
cQuery += "   AND SZ3.Z3_LAYOUT    = '310'" + Chr( 13 )
cQuery += "   AND SZ3.Z3_STATUS   <> 'E'" + Chr( 13 )
cQuery += "   AND SZ3.D_E_L_E_T_  <> '*'" + Chr( 13 )

cQuery := ChangeQuery( cQuery )

If Select( cAliasSD1 ) > 0
	( cAliasSD1 )->( dBclosearea( ) )
EndIf

cTabTMP   := CriaTrab( aStruSZ3, .T. )

MsAguarde( {|| dBUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasRem, .T., .T.) }, "Consultando Lotes..." )


For nX := 1 To len(aStruSZ3)
	If aStruSZ3[nX][2] <> "C" .And. FieldPos(aStruSZ3[nX][1])<>0
	   TcSetField(cAliasRem,aStruSZ3[nX][1],aStruSZ3[nX][2],aStruSZ3[nX][3],aStruSZ3[nX][4])
	EndIf
Next nX

Copy TO &cTabTMP
dBCloseArea()

dBUseArea( .T.,, cTabTMP, cAliasRem, lShare, lReadOnly )


@ 010, 130 SAY "Lotes para Exclusão"   COLOR CLR_HBLUE PIXEL OF oPanel SIZE 140, 8 PIXEL   


oMark                      := MsSelect():New( cAliasRem,"Z3_OK","",aViewSZ3,@lInverte,@cMarca,{020,129,125,295},,, oPanel )  
oMark:oBrowse:lHasMark     := .T.
oMark:oBrowse:lCanAllMark  := .T.
oMark:oBrowse:bAllMark     := {|| LTRCOF01MA( cAliasRem, "Z3_OK" ) }
oMark:bMark                := {|| LTRCOF01MO( cAliasRem, "Z3_OK" ) } 
oMark:oBrowse:Refresh()

//*****************************************************************


//************************************************//
// 5                                              //
// Quinto Painel - Parâmetros II                  //
//************************************************//
CREATE PANEL oWizard 	HEADER cHeader ;
						MESSAGE "Parâmetros II" ; 
						BACK {|| oWizard:SetPanel( N_PAN_ARQ   ), .T. } ;
						NEXT {|| oWizard:SetPanel( N_PAN_CONF ), .T. } ;
						FINISH {|| .T., oWizard:End() } ;
						PANEL  

oPanel      := oWizard:oMPanel[ 5 ] // oWizard:GetPanel( N_PAN_PAR2 )

cCodFina      := Space( 05 )
cDesFina      := Space( 20 )
cCodProdFin   := Space( 05 )
cDescPrdFin   := Space( 30 )
cUmProdFin    := Space( 20 )
cUmProdFin    := Space( 20 )

@ 05, 08 GROUP oGrpPar 	TO 130, 295 LABEL "Parâmetros..." OF oPanel PIXEL DESIGN

//@ 010, 187 GROUP oGrpDiv TO 125,190 LABEL "" OF oPanel PIXEL DESIGN

oScroll := TScrollBox():New( oGrpPar, 12, 10, 115, 280, .T.,.F.,.F. )

nLin := 05

@ nLin, 003 SAY "Agência Contrato"   OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "C/C Contrato"       OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Número Contrato"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Unidade Organiz."   OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Código de Finalidade"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Descrição Finalidade"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Código Produto"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Descrição Produto"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Unidade de Medida"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 003 SAY "Valor Teto p/ Financiamento"    OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

nLin := 005

@ nLin, 080 MSGET oAgencia   VAR cAgCont OF oScroll SIZE 50, 10 PIXEL 
nLin+=15  

@ nLin, 080 MSGET oContaCor  VAR cCcCont OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oNumCont   VAR cNumCont  OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oUOR   VAR cUor  OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oCodFina    VAR cCodFina    OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oDesFina    VAR cDesFina    OF oScroll SIZE 100, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oCodProdFin VAR cCodProdFin OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oDescPrdFin VAR cDescPrdFin OF oScroll SIZE 100, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oUmProdFin  VAR cUmProdFin  OF oScroll SIZE 50, 10 PIXEL 
nLin+=15

@ nLin, 080 MSGET oVlTetoFin  VAR nVlTetoFin  Picture "@E 99,999,999,999,999.99" OF oScroll SIZE 100, 10 PIXEL 
nLin+=15


// 6
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sexto  Painel - Notas Fiscais Período        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CREATE PANEL oWizard 	HEADER cHeader ;
						MESSAGE "Notas Fiscais Período" ; 
						BACK {|| oWizard:SetPanel( N_PAN_PAR1 + 1 ), .T. } ;
						NEXT {|| .T. } ;
						FINISH {|| .F. } ;
						PANEL  

oPanel     := oWizard:oMPanel[ 6 ] // oWizard:GetPanel( N_PAN_SWNF )


@ 005, 010 SAY "Notas Fiscais Período: " + DTOC( dDataIni ) + " a " + DTOC( dDataFim )   COLOR CLR_HBLUE PIXEL OF oPanel SIZE 140, 8 PIXEL   

@ 130, 010 SAY "Total (R$)" COLOR CLR_HBLUE PIXEL OF oPanel SIZE 140, 8 PIXEL   
@ 128, 040 MSGET oTotalV 	VAR nTotalV Picture "@E 999,999,999.99" OF oPanel PICTURE "@!" When .F. SIZE 070, 10 PIXEL 

@ 130, 120 SAY "Total (Lts)" COLOR CLR_HBLUE PIXEL OF oPanel SIZE 140, 8 PIXEL   
@ 128, 150 MSGET oTotalL 	VAR nTotalL Picture "@E 999,999,999.99" OF oPanel PICTURE "@!" When .F. SIZE 070, 10 PIXEL 


LTRCOF01NF( @aViewSD1, @aStruSD1, @cAliasSD1, dDataIni, dDataFim, cProdDe, cProdAte, @nTotalV, @nTotalL, @oTotalV, @oTotalL )

oMark2                      := MsSelect():New( cAliasSD1,"D1_OK","",aViewSD1,@lInverte,@cMarca,{015,010,125,295},,, oPanel )  
oMark2:oBrowse:lHasMark     := .T.
oMark2:oBrowse:lCanAllMark  := .T.
oMark2:oBrowse:bAllMark     := {|| LTRCOF01MA( cAliasSD1, "D1_OK", @nTotalV, @nTotalL, @oTotalV, @oTotalL ) }
oMark2:bMark                := {|| LTRCOF01MO( cAliasSD1, "D1_OK", @nTotalV, @nTotalL, @oTotalV, @oTotalL) } 
oMark2:oBrowse:Refresh()

// 7
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sétimmo  Painel - Confirmacao  / Processamento  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CREATE PANEL oWizard 	HEADER cHeader ;
						MESSAGE "Confirmação dos dados e início de processamento." ; 
						BACK {|| oWizard:SetPanel( N_PAN_ARQ ), .T. } ;
						NEXT {|| .T. } ;
						FINISH {|| .F. } ;
						PANEL  
						
						
						       
oPanel     := oWizard:oMPanel[ 7 ] // oWizard:GetPanel( N_PAN_CONF )

If ( Select( "SM0" ) == 0 )
	OpenSM0()
Endif

If ( Select( "SM0" ) > 0 )
	SM0->( dBGotop() )
	
	SM0->( dBSeek( cEmpAnt + cFilAnt ) )

Endif

oScroll := TScrollBox():New( oPanel, 12, 10, 115, 280, .T.,.F.,.T. )

nDiv := 0
nLin := 05

@ nLin, 005 SAY "Empresa/Filial.............: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "Agência Contrato.......: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "C/C Contrato...............: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "Número Contrato..........: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "Unidade Organizadora...: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "Arquivo a ser Gerado...: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 20


@ nLin, 005 SAY cIndica310 OF oScroll COLOR CLR_HRED SIZE 200, 8 PIXEL   
nLin+=15

@ nLin, 005 SAY "Período Inicial............: "  OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "Período Final..............: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "Produto de.................: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 15

@ nLin, 005 SAY "Produto até................: " OF oScroll SIZE 140, 8 PIXEL   
nLin += 30


@ nLin, 005 SAY cIndica312    OF oScroll COLOR CLR_HRED SIZE 200, 8 PIXEL   
nLin+=15

nDiv := nLin
@ nLin, 005 SAY "Código de Finalidade......:" OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 005 SAY "Descrição Finalidade......:" OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 005 SAY "Código do Produto.........:" OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 005 SAY "Descrição Produto..........:" OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 005 SAY "Unidade de Medida........:" OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 005 SAY "Valor Teto p/ Financiamento:" OF oScroll SIZE 140, 8 PIXEL   
nLin+=15

@ nLin, 005 SAY "" OF oScroll SIZE 140, 8 PIXEL   

nLin  := 05

@ nLin, 085 SAY cEmpAnt + " " + SM0->M0_NOME + " " + Alltrim( SM0->M0_FILIAL ) + " " + SM0->M0_NOMECOM  OF oScroll SIZE 180, 8 COLOR CLR_HBLUE PIXEL	
nLin += 15

@ nLin, 085 SAY iif( Empty( cAgCont ), "-", cAgCont ) OF oScroll SIZE 180, 10 COLOR CLR_HBLUE PIXEL 
nLin+=15  

@ nLin, 085 SAY iif( Empty( cCcCont ), "-", cCcCont ) OF oScroll SIZE 180, 10 COLOR CLR_HBLUE PIXEL 
nLin+=15

@ nLin, 085 SAY iif( Empty( cNumCont ), "-", cNumCont ) OF oScroll SIZE 180, 10 COLOR CLR_HBLUE PIXEL 
nLin+=15

@ nLin, 085 SAY iif( Empty( cUor ), "-", cUor )  OF oScroll SIZE 180, 10 COLOR CLR_HBLUE PIXEL 
nLin += 15

@ nLin, 085 SAY cFile + "   (conforme lay-out selecionado)"           OF oScroll SIZE 140, 8 COLOR CLR_HBLUE PIXEL	
nLin+=35

@ nLin, 085 SAY DTOC( dDataIni ) OF oScroll SIZE 140, 8 COLOR CLR_HBLUE PIXEL	
nLin += 15

@ nLin, 085 SAY iif( Empty( dDataFim ), "  /  /  ", DTOC( dDataFim ) )  OF oScroll SIZE 140, 8 COLOR CLR_HBLUE PIXEL	
nLin += 15


@ nLin, 085 SAY iif( Empty( cProdDe ), "-", cProdDe )  OF oScroll SIZE 180, 10 COLOR CLR_HBLUE PIXEL
nLin+=15

@ nLin, 085 SAY iif( Empty( cProdAte ), "-", cProdAte )  OF oScroll SIZE 180, 10 COLOR CLR_HBLUE PIXEL


nLin := nDiv

@ nLin, 085 SAY iif( Empty( cCodFina ), "-", cCodFina )   OF oScroll SIZE 180, 8 COLOR CLR_HBLUE PIXEL 
nLin+=15

@ nLin, 085 SAY iif( Empty( cDesFina ), "-", cDesFina )   OF oScroll SIZE 180, 8 COLOR CLR_HBLUE PIXEL 
nLin+=15

@ nLin, 085 SAY iif( Empty( cCodProdFin ), "-", cCodProdFin ) OF oScroll SIZE 180, 8 COLOR CLR_HBLUE PIXEL 
nLin+=15

@ nLin, 085 SAY iif( Empty( cDescPrdFin ), "-", cDescPrdFin ) OF oScroll SIZE 180, 8 COLOR CLR_HBLUE PIXEL 
nLin+=15                                     

@ nLin, 085 SAY iif( Empty( cUmProdFin ), "-", cUmProdFin )  OF oScroll SIZE 180, 8 COLOR CLR_HBLUE PIXEL 
nLin+=15

@ nLin, 085 SAY nVlTetoFin  Picture "@E 99,999,999,999,999.99" OF oScroll SIZE 100, 10 COLOR CLR_HBLUE PIXEL 
nLin+=15


// 8
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sexto Painel - Processamento                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CREATE PANEL oWizard 	HEADER cHeader ;
						MESSAGE "Processamento..." ; 
						BACK {|| .F. } ;
						NEXT {|| .F. } ;
						FINISH {|| .T. } ;
						EXEC {|| LTRCOF01GO( cAliasRem, cAliasSD1, oMetGlobP, nRadioLOut, cFile, cLayOut, dDataIni, dDataFim, cAgCont, cCcCont, cNumCont, cUor, cCodFina, cDesFina, cCodProdFin, cDescPrdFin, cUmProdFin, nVlTetoFin )  } ;
						PANEL 

oPanel     := oWizard:oMPanel[ 8 ] // oWizard:GetPanel( N_PAN_GODO )

						        
@ 25, 30 SAY "Exportação" OF oPanel SIZE 140, 8 PIXEL   
@ 40, 30 METER oMetGlobP 	VAR nMetGlobP ;
							TOTAL 100 ;
							SIZE 224,10 OF oPanel PIXEL UPDATE DESIGN ;
							BARCOLOR CLR_BLACK,CLR_WHITE ;
							COLOR CLR_WHITE,CLR_BLACK ;
						 	NOPERCENTAGE 


ACTIVATE WIZARD oWizard CENTER

If Select( cAliasSD1 ) > 0
	( cAliasSD1 )->( dBclosearea( ) )
EndIf


If Select( cAliasRem ) > 0
	( cAliasRem )->( dBclosearea( ) )
EndIf



Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01GO º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pelo processo de geração/importação dos º±±
±±º          ³ Arquivos.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01GO( cAliasRem, cAliasSD1, oMetGlobP, nRadioLOut, cFile, cLayOut, dDataIni, dDataFim, cAgCont, cCcCont, cNumCont, cUor, cCodFina, cDesFina, cCodProdFin, cDescPrdFin, cUmProdFin, nVlTetoFin )
*********************************************************************************************************************************************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea		:= GetArea()
Local cAliasSA2 := GetNextAlias()
Local cSafra    := Alltrim( Str( Year( dDataBase ) - 1 ) ) + "/" + Alltrim( Str( Year( dDataBase )  ) )
Local cLinha 	:= ""
Local aHeader	:= {}
Local nHdl    	:= 	0
Local cEnvServ	:= GetEnvServer()
Local cIniFile	:= GetADV97()
Local cEnd		:= GetPvProfString(cEnvServ,"StartPath","",cIniFile)   
Local cDtHr 	:= DtoS(dDataBase)+"-"+Substr(time(),1,2)+"-"+Substr(time(),4,2)+"-"+Substr(time(),7,2)
Local cPath		:= "\EXTRAS\"
Local cTipoLog	:= "Import_"
Local cNomeLog	:=	cPath+cTipoLog+cDtHr+"_Log.txt"
Local cArq		:=	cEnd+cNomeLog              
Local cLin		:= ""   
Local cCdAlias	:= ""
Local cQuery    := ""
Local nQtReg	:= 0
Local nQtNOk	:= 0
Local nQtOk		:= 0
Local aLog		:= {}
Local cRotina	:= ""
Local nCont		:= 0
Local nSeq310   := GetMV( "MV_SQRCOF0" )
Local nSeq312   := GetMV( "MV_SQRCOF2" )
Local nSeq310Nw := nSeq310 + 1
Local nSeq312Nw := nSeq312 + 1
Local lShare    := .T.  
Local lReadOnly := .F.
Local aDigVIBGE := { { "AC", "12" },; 
                     { "AL", "27" },;
                     { "AM", "13" },;
                     { "AP", "16" },;
                     { "BA", "29" },;
                     { "CE", "23" },;
                     { "DF", "53" },;
                     { "ES", "32" },;
                     { "GO", "52" },;
                     { "MA", "21" },;
                     { "MG", "31" },;
                     { "MS", "50" },;
                     { "MT", "51" },;
                     { "PA", "15" },;
                     { "PB", "25" },;
                     { "PE", "26" },;
                     { "PI", "22" },;
                     { "PR", "41" },;
                     { "RJ", "33" },;
                     { "RJ", "33" },;
                     { "RN", "24" },;
                     { "RO", "11" },;
                     { "RR", "14" },;
                     { "RS", "43" },;
                     { "SC", "42" },;
                     { "SE", "28" },;
                     { "SP", "35" },;
                     { "TO", "17" }}
 

MAKEDIR(cEnd+cPath)

cAgCont := StrTran( cAgCont, "-", "" )
cCcCont := StrTran( cCcCont, "-", "" )

Do Case
	Case cLayOut == "310"
		cFile := "RCOF310"

		nHdl  := 	fCreate( "C:\" + cFile )
		
		If nHdl == -1
			MsgAlert( "O arquivo [C:\"+cFile+"] não pode ser criado!","Atenção!" )
			fClose( nHdl )
			fErase( "C:\" + cFile )
			RestArea( aArea )
	 		Return()
		EndIf
		
		
		// Exportar
		//
		cHeader   := ""
		cDetalhe1 := ""
		aDetalhe1 := {}
		cDetalhe2 := ""
		aDetalhe2 := {}
		cDetalhe3 := ""
		aDetalhe3 := {}
		cDetalhe4 := ""
		aDetalhe4 := {}
		cFooter   := ""
		cNumRemes := StrZero( nSeq310Nw, 9 )
		
		nQtdRecDt3 := 0 // Qtde de Registros          => número de registros contados desde de o último registro detalhe02 até o atual registro detalhe04 (inclusive)
		nTotQtdDt3 := 0 // Soma Quantidade adquireida => Soma das quantidades de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		nTotVlPDt3 := 0 // Soma Valor Pago            => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		nTotVlFDt3 := 0 // Soma Valor Financiado      => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		nTotRecsG  := 0
		
		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
	
	    // 1
		// CÓDIGO HEADER
		// A	2		1	2	Código que identifica  cabeçalho com dados fixos do arquivo.	ALFANUMÉRICO	Para cabeçalho, informar 00.
		cHeader := "00"
		
	    // 2
		// NOME DO ARQUIVO
		// A	8		3	10	Nome do arquivo enviado.	ALFANUMÉRICO	Informar RCOF310
		cHeader += Alltrim( cFile ) + Space( 8 - Len( Alltrim( cFile ) ) )

	    // 3
	    // DATA DA REMESSA
	    // A	8		11	18	Data da remessa.	FORMATO DDMMAAAA	Data de envio do arquivo	
	    cHeader += StrTran( DTOC( dDataBase ), "/", "" )
	
	    // 4
		// NÚMERO DA REMESSA
	    // N	9		19	27	Número da remessa.	NUMÉRICO	Número sequencial iniciado em 01 e acrescido de 01 a cada arquivo enviado
		cHeader += cNumRemes
		
	    // 5
		// CNPJ DA EMPRESA
	    // N	14		28	41	Número do CNPJ da empresa.	NUMÉRICO	CNPJ completo da empresa responsável pelo arquivo, seus dados, e consequentemente pela operação de crédito.
		cHeader += SM0->M0_CGC
		
	    // 6
		// PREFIXO DA AGÊNCIA DO CONTRATO	
		// N	9		42	50	Agência com a qual a empresa assinou o contrato de utilização do gerenciador financeiro.	NUMÉRICO	Prefixo da Agência com a qual foi assinado o contrato de uso do gerenciador financeiro.
		cHeader += Alltrim( cAgCont ) + Space( Len( Alltrim( cAgCont)  ) - 9 )
		
	    // 7
		// CONTA DO CONTRATO
		// N	9		51	59	Conta-corrente, pertencente à empresa, na agência onde foi assinado o contrato, que vincula à utilização do gerenciador financeiro.	NUMÉRICO	Número da conta corrente da empresa na agência onde foi assinado o contrato de uso do gerenciador financeiro.
		cHeader += Alltrim( cCcCont )  + Space( Len( Alltrim( cCcCont )  ) - 9 )
		
	    // 8
		// NÚMERO DO CONTRATO
		// N	9		60	68	Número do contrato no RCO para Intercâmbio Eletrônico de Dados(IED).	NUMÉRICO	Número do contrato informado pela agência, aplicativo RCO, gerado pelo IED, para troca dos arquivos remessa e retorno no gerenciador financieiro.	Informação necessária ao  correto tratamento do arquivo pelo Gerenciador Financeiro.
		cHeader += Alltrim( cNumCont )  + Space( Len( Alltrim( cNumCont )  ) - 9 )
	
	    // 9
	    // UNIDADE ORGANIZACIONAL DO CONTRATO
	    // N	9		69	77	Número da Unidade Organizacional	NUMÉRICO	Número da UOR da agência do contrato ou zeros caso a informação não esteja disponível e o campo prefixo tenha sido preenchido.
	    cHeader += cUor
	    
	    // 10
	    // ESPAÇOS EM BRANCO(FILLER)
	    // A	53		78	130	Espaços em branco.	ALFANUMÉRICO	preencher com brancos
	    cHeader += Space( 53 ) + CHR( 13 ) + CHR( 10 )
	    nTotRecsG++
	    
	    LTRCOF01GL( nHdl, cHeader, cFile ) // Grava Linha
	    
		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
	
	    // Detalhe 1
	    //     
	    ( cAliasRem )->( dBgoTop( ) )
	    While !( cAliasRem )->( Eof( ) )
	    	If !Empty( ( cAliasRem )->Z3_OK  ) .And. !Empty( ( cAliasRem )->Z3_LOTEBB )
	    		aAdd( aDetalhe1, { '01', ( cAliasRem )->Z3_LOTEBB } )
	    	Endif
	    	( cAliasRem )->( dBSkip( ) )
	    EndDo
	    
	    If Len( aDetalhe1 ) > 0
	    
	    	For nX := 1 To Len( aDetalhe1 )
	    	    nTotRecsG++
	    	    cDetalhe1 := aDetalhe1[ nX ][ 1 ] +                                     /* CÓDIGO DETALHE 1                 => A	2		1	2	Código que identifica conteúdo1(detalhe1), contendo dados para exclusão de lote previamente gravado.	ALFANUMÉRICO Para conteúdo, informar 01 */; 
	    	                 aDetalhe1[ nX ][ 2 ] + Space( 117 ) + CHR( 13 )+CHR( 10 )  /* NÚMERO DO LOTE CADASTRADO NO BB  => N	11		3	13	Número do lote cadastrado no BB.	NUMÉRICO	Preencher com o número do lote que se deseja excluir */
	    		LTRCOF01GL( nHdl, cDetalhe1, cFile ) // Grava Linha
	    	
	    	Next
	    
	    Else
	    	nTotRecsG++
	    	cDetalhe1 := Space( 02 ) +                                    /* CÓDIGO DETALHE 1                 => A	2		1	2	Código que identifica conteúdo1(detalhe1), contendo dados para exclusão de lote previamente gravado.	ALFANUMÉRICO Para conteúdo, informar 01 */;
	    	             Space( 11 ) + Space( 117 ) + CHR( 13 )+CHR( 10 ) /* NÚMERO DO LOTE CADASTRADO NO BB  => N	11		3	13	Número do lote cadastrado no BB.	NUMÉRICO	Preencher com o número do lote que se deseja excluir */
	    	LTRCOF01GL( nHdl, cDetalhe1, cFile ) // Grava Linha
	    	
	    Endif
	    
		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
		
	    // Detalhe 2
	    //     
	    nTotRecsG++
	    cDetalhe2 := "02" + "00030" + "04280" + cSafra + cAgCont + Space( 104 ) + CHR( 13 )+CHR( 10 )
	   	LTRCOF01GL( nHdl, cDetalhe2, cFile ) // Grava Linha
	    
		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
		
	    // Detalhe 3
	    //     
	   	cDetalhe3 := ""
	   	aDetalhe3 := {}
	   	//
	   	nAtu     := 1
	   	nTotRecs := 0
	   	
	    ( cAliasSD1 )->( dBGoTop() )
	   	While !( cAliasSD1 )->( Eof( ) )
	   		
	   		nPos := aScan( aDigVIBGE, { |X| X[ 1 ] == ( cAliasSD1 )->A2_EST } )
	   		
	   		If nPos > 0
	   			nTotRecs++
	   		Endif
	   		
	   		( cAliasSD1 )->( dBSkip( ) )
	   		
	   	Enddo
	   	    
	   	
	   	oMetGlobP:SetTotal( nTotRecs )
		
	    ( cAliasSD1 )->( dBGoTop() )
	   	While !( cAliasSD1 )->( Eof( ) )
	   		If !Empty( ( cAliasSD1 )->D1_OK )
	   			
	   			nPos := aScan( aDigVIBGE, { |X| X[ 1 ] == ( cAliasSD1 )->A2_EST } )
	   			
	   			If nPos > 0
	   				oMetGlobP:Set( ++nAtu )
	   				
	   				nTotRecsG++
	   				nQtdRecDt3++                           /* Qtde de Registros          => número de registros contados desde de o último registro detalhe02 até o atual registro detalhe04 (inclusive) */
	   				cMunIBGE   := aDigVIBGE[ nPos ][ 2 ] + ( cAliasSD1 )->A2_COD_MUN 
	   				nTotQtdDt3 += ( cAliasSD1 )->D1_QUANT  /* Soma Quantidade adquireida => Soma das quantidades de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04. */
	   				nTotVlPDt3 += ( cAliasSD1 )->D1_TOTAL  /* Soma Valor Pago            => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04. */
	   				nTotVlFDt3 += ( cAliasSD1 )->D1_TOTAL  /* Soma Valor Financiado      => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04. */
	   				
		   			/* 
		   			CÓDIGO DETALHE 3	                    A	2		1	2	Código que identifica conteúdo3(detalhe3), contendo dados complementares para inclusão de informações de fornecedores.	ALFANUMÉRICO	Para conteúdo, informar 03.
		   			CPF/CNPJ DO PRODUTOR RURAL	            N	14		3	16	CPF/CNPJ do produtor rural.	NUMÉRICO	CNPJ/CPF do beneficiário da operação de crédito.
		   			INDICADOR DO CÓDIGO DE TIPO PARA CNPJ	A	1		17	17	Determina se o conteúdo do campo Código do CNPJ CPF do Produtor Rural é um CNPJ.	ALFANUMÉRICO J - Campo do tipo CNPJF - Campo do tip oCPF  
		   			SÉRIE DA NOTA FISCAL      	            A	3		18	20	Utilizada para controle de repetição do número da nota	ALFANUMÉRICO	Código de série da nota fiscal
		   			NÚMERO DA NOTA FISCAL	                N	17		21	37	Número da Nota Fiscal.	NUMÉRICO	Número da nota fiscal da compra do produto
		   			DATA DA COMPRA	                        D	8		38	45	Data da compra.	FORMATO DDMMAAAA	Conforme data da nota fiscal
		   			QUANTIDADE ADQUIRIDA	                N	18	3	46	63	Quantidade adquirida.	NUMÉRICO	Quantidade adquirida na nota fiscal
		   			VALOR PAGO	                            N	17	2	64	80	Valor pago.	NUMÉRICO	Valor da nota fiscal
		   			VALOR FINANCIADO	                    N	17	2	81	97	Total ou parcela do valor pago a ser financiado.	NUMÉRICO	Total ou parcela do valor da nota fiscal a ser financiado
		   			UNIDADE DE MEDIDA	                    A	20		98	117	Unidade de medida a qual deve estar vinculada a quantidade, quando apresentada para o produto.	ALFANUMÉRICO	Unidade de medida para o produto em kg ou l, conforme arquivo RCOF312
		   			MUNICÍPIO DE ORIGEM	                    N	7		118	124	O município da origem do produto. 	ALFANUMÉRICO	Código do município de origem do produto conforme tabela do IBGE
		   			ESPAÇOS EM BRANCO(FILLER)	            A	6		125	130	Espaços em branco.	ALFANUMÉRICO	preencher com brancos 
		   			*/
	
		   			cDetalhe3 := "03"                                                                + ;
		   						  ( cAliasSD1 )->A2_CGC                                              + ;
		   			              ( cAliasSD1 )->A2_TIPO                                             + ;
		   			              ( cAliasSD1 )->D1_SERIE                                            + ;
		   			              ( cAliasSD1 )->D1_DOC + Space( 17 - Len( ( cAliasSD1 )->D1_DOC ) ) + ;
		   			              STRTRAN( DTOC( ( cAliasSD1 )->D1_EMISSAO ), "/", "" )              + ;
		   			              Transform( ( cAliasSD1 )->D1_QUANT, "@E 99999999999999.999" )      + ;
		   			              Transform( ( cAliasSD1 )->D1_TOTAL, "@E 9999999999999.999" )       + ;
		   			              Transform( ( cAliasSD1 )->D1_TOTAL, "@E 9999999999999.999" )       + ;
		   			              ( cAliasSD1 )->B1_UM  + Space( 20 - Len( ( cAliasSD1 )->B1_UM ) )  + ;
		   			              cMunIBGE                                                           +;
		   			              Space( 6 )  + CHR( 13 )+CHR( 10 )                                  
	
		   				LTRCOF01GL( nHdl, cDetalhe3, cFile ) // Grava Linha
	   			
	            Endif
	   		
	   		Endif
	   		( cAliasSD1 )->( dBSkip( ) )
	   	Enddo
	
	
		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
		
	    // Detalhe 4
	    //     
	   	cDetalhe4 := ""
	   	aDetalhe4 := {}
	   	//
		// nQtdRecDt3  - Qtde de Registros          => número de registros contados desde de o último registro detalhe02 até o atual registro detalhe04 (inclusive)
		// nTotQtdDt3  - Soma Quantidade adquireida => Soma das quantidades de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		// nTotVlPDt3  - Soma Valor Pago            => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		// nTotVlFDt3  - Soma Valor Financiado      => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
	
	   	cDetalhe4 := "04"                                             /* CÓDIGO DETALHE 4	A	2		1	2	Código que identifica conteúdo4(detalhe4), contendo dados complementares para inclusão de informações de fornecedores.	ALFANUMÉRICO	Para conteúdo, informar 04. */ + ; 
	                 Transform( nQtdRecDt3, "@E 9999999" )            /* QUANTIDADE DE REGISTROS	N	7		3	9	Quantidade de registros somados do detalhe2 ao detalhe4.	NUMÉRICO	número de registros contados desde de o último registro detalhe02 até o atual registro detalhe04 (inclusive) */ + ;
	                 Transform( nTotQtdDt3, "@E 99999999999999.999" ) /* SOMA QUANTIDADE ADQUIRIDA	N	18	3	10	27	Soma das quantidades adquiridas em todos os registros detalhe3 entre o detalhe2 e o detalhe4	NUMÉRICO	Soma das quantidades de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.*/ + ;
	                 Transform( nTotVlPDt3, "@E 99999999999999.99"  ) /* SOMA VALOR PAGO	N	17	2	28	44	Soma dos valores pagos em todos os registros detalhe1 entre o detalhe2 e o detalhe4.	NUMÉRICO	Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04. */ + ;
	                 Transform( nTotVlFDt3, "@E 99999999999999.99"  ) /* SOMA VALOR FINANCIADO	N	17	2	45	61	Soma dos valores financiados em todos os registros detalhe1 entre o detalhe2 e o detalhe4.	NUMÉRICO	Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04. */ +;
	                 Space( 69 )  + CHR( 13 ) + CHR( 10 ) 
	    
		nTotRecsG++
		LTRCOF01GL( nHdl, cDetalhe4, cFile ) // Grava Linha
		
		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
		
	    // Rodapé
	    //     
		cFooter   := ""
		cFooter   := "99" + ;
		             Transform( nTotRecsG, "@E 9999999" ) + ;
		             Space( 121 )  + CHR( 13 )+CHR( 10 ) 
		             
		LTRCOF01GL( nHdl, cFooter, cFile ) // Grava Linha
	
		fClose(nHdl) // Fecha Arquivo
		
		
		MsgInfo( "Arquivo gerado em [C:\"+cFile+"]" )
		
		PutMvPar( "MV_SQRCOF0" , nSeq310Nw )
		
		dBSelectArea( "SZ3" )
		SZ3->( dBGoTop( ) )
		If !SZ3->( dBSeek( xFilial( "SZ3" ) + cNumRemes + "310" ) )
		 
			RecLock( "SZ3", .T. )
			SZ3->Z3_FILIAL  := xFilial( "SZ3" )
			SZ3->Z3_LAYOUT  := "310"
			SZ3->Z3_NOMEARQ := cFile
			SZ3->Z3_DTAREME := dDataBase
			SZ3->Z3_HRAREME := Time()
			SZ3->Z3_NUMREM  := cNumRemes
			SZ3->Z3_CNPJ    := SM0->M0_CGC
			SZ3->Z3_AGENCIA := cAgCont
			SZ3->Z3_CTACONT := cCcCont
			SZ3->Z3_NUMCONT := cNumCont
			SZ3->Z3_UOR     := cUor
			SZ3->Z3_USUARIO := SubStr( cUsuario, 7, 15 )
			SZ3->Z3_STATUS  := "I"
			SZ3->( MsUnLock( ) )
			
			MsgInfo( "Registro da geração da Remessa atualizada em SZ3 !" )
					
        Else
        	Alert( "Já existe uma Remessa gravada (SZ3) com esse número [" + Alltrim( cNumRemes ) + "]" )
        Endif



	Case cLayOut == "312"
		cFile := "RCOF312"

		nHdl  := 	fCreate( "C:\" + cFile )
		
		If nHdl == -1
			MsgAlert( "O arquivo [C:\"+cFile+"] não pode ser criado!","Atenção!" )
			fClose( nHdl )
			fErase( "C:\" + cFile )
			RestArea( aArea )
	 		Return()
		EndIf
		
		
		// Exportar
		//
		cHeader   := ""
		cDetalhe1 := ""
		aDetalhe1 := {}
		cDetalhe2 := ""
		aDetalhe2 := {}
		cDetalhe3 := ""
		aDetalhe3 := {}
		cDetalhe4 := ""
		aDetalhe4 := {}
		cFooter   := ""
		cNumRemes := StrZero( nSeq312Nw, 9 )
		
		nQtdRecDt3 := 0 // Qtde de Registros          => número de registros contados desde de o último registro detalhe02 até o atual registro detalhe04 (inclusive)
		nTotQtdDt3 := 0 // Soma Quantidade adquireida => Soma das quantidades de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		nTotVlPDt3 := 0 // Soma Valor Pago            => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		nTotVlFDt3 := 0 // Soma Valor Financiado      => Soma dos valores de todos os registros detalhe03 existentes entre o último registro detalhe02 gravado e o atual registro detalhe04.
		nTotRecsG  := 0
		
		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
	
	    // 1
		// CÓDIGO HEADER
		// A	2		1	2	Código que identifica  cabeçalho com dados fixos do arquivo.	ALFANUMÉRICO	Para cabeçalho, informar 00.
		cHeader := "00"
		
	    // 2
		// NOME DO ARQUIVO
		// A	8		3	10	Nome do arquivo enviado.	ALFANUMÉRICO	Informar RCOF310
		cHeader += Alltrim( cFile ) + Space( 8 - Len( Alltrim( cFile ) ) )

	    // 3
	    // DATA DA REMESSA
	    // A	8		11	18	Data da remessa.	FORMATO DDMMAAAA	Data de envio do arquivo	
	    cHeader += StrTran( DTOC( dDataBase ), "/", "" )
	
	    // 4
		// NÚMERO DA REMESSA
	    // N	9		19	27	Número da remessa.	NUMÉRICO	Número sequencial iniciado em 01 e acrescido de 01 a cada arquivo enviado
		cHeader += cNumRemes
		
	    // 5
		// CNPJ DA EMPRESA
	    // N	14		28	41	Número do CNPJ da empresa.	NUMÉRICO	CNPJ completo da empresa responsável pelo arquivo, seus dados, e consequentemente pela operação de crédito.
		cHeader += SM0->M0_CGC
		
	    // 6
		// PREFIXO DA AGÊNCIA DO CONTRATO	
		// N	9		42	50	Agência com a qual a empresa assinou o contrato de utilização do gerenciador financeiro.	NUMÉRICO	Prefixo da Agência com a qual foi assinado o contrato de uso do gerenciador financeiro.
		cHeader += Alltrim( cAgCont ) + Space( Len( Alltrim( cAgCont)  ) - 9 )
		
	    // 7
		// CONTA DO CONTRATO
		// N	9		51	59	Conta-corrente, pertencente à empresa, na agência onde foi assinado o contrato, que vincula à utilização do gerenciador financeiro.	NUMÉRICO	Número da conta corrente da empresa na agência onde foi assinado o contrato de uso do gerenciador financeiro.
		cHeader += Alltrim( cCcCont )  + Space( Len( Alltrim( cCcCont )  ) - 9 )
		
	    // 8
		// NÚMERO DO CONTRATO
		// N	9		60	68	Número do contrato no RCO para Intercâmbio Eletrônico de Dados(IED).	NUMÉRICO	Número do contrato informado pela agência, aplicativo RCO, gerado pelo IED, para troca dos arquivos remessa e retorno no gerenciador financieiro.	Informação necessária ao  correto tratamento do arquivo pelo Gerenciador Financeiro.
		cHeader += Alltrim( cNumCont )  + Space( Len( Alltrim( cNumCont )  ) - 9 )
	
	    // 9
	    // UNIDADE ORGANIZACIONAL DO CONTRATO
	    // N	9		69	77	Número da Unidade Organizacional	NUMÉRICO	Número da UOR da agência do contrato ou zeros caso a informação não esteja disponível e o campo prefixo tenha sido preenchido.
	    cHeader += cUor
	    
	    // 10
	    // ESPAÇOS EM BRANCO(FILLER)
	    // A	33		78	130	Espaços em branco.	ALFANUMÉRICO	preencher com brancos
	    cHeader += Space( 33 ) + CHR( 13 ) + CHR( 10 )
	    nTotRecsG++
	    
	    LTRCOF01GL( nHdl, cHeader, cFile ) // Grava Linha

		//----------------------------------------------------------------------------------------------
		//**********************************************************************************************    
		//**********************************************************************************************    
		//----------------------------------------------------------------------------------------------
	
	    // Detalhe 1
	    //     
   	    cDetalhe1 := "01"                                             /* CÓDIGO DETALHE 1	                 A	2		1	2	Código que identifica conteúdo1(detalhe1), contendo os registros referentes aos códigos de produto no BACEN e seus dados complementares.	ALFANUMÉRICO	Para conteúdo, informar 01. */+; 
				     cCodFina                                         /* CÓDIGO DE FINALIDADE           	 N	5		3	7	Código de finalidade válida para fornecedor 	NUMÉRICO */ + ;
				     cDesFina                                         /* DESCRIÇÃO DA FINANLIDADE	         A	20		8	27	Descreve o código de finalidade 	ALFANUMÉRICO */ + ;
				     cCodProdFin                                      /* CÓDIGO DO PRODUTO	                 N	5		28	32	Código de produto para fornecedor, válido para a finalidade informada.	NUMÉRICO */ + ; 
				     cDescPrdFin                                      /* DESCRICAO  DO PRODUTO	             A	30		33	62	Descreve o código do produto 	ALFANUMÉRICO */ + ;
				     cUmProdFin                                       /* UNIDADE DE MEDIDA              	 A	20		63	82	Unidade de medida a qual deve estar vinculada a quantidade, quando apresentada para o produto.	ALFANUMÉRICO */ + ;
				     Transform( nVlTetoFin, "@E 99999999999999.99"  ) /* VALOR TETO PARA FINCIAMENTO      	 N	17	2	83	99	Valor máximo de uma finalidade  para operações  de uma  Empresa/Produtor/Produto/Safra.	NUMÉRICO */ + ;
   	                 Space( 11 ) + CHR( 13 )+CHR( 10 )                /* ESPAÇOS EM BRANCO(FILLER)	         A	11		100	110	Espaços em branco.	ALFANUMÉRICO	preencher com brancos */

   		LTRCOF01GL( nHdl, cDetalhe1, cFile ) // Grava Linha
   		
   		
   		cFooter := "99"                          + ;
   		           Transform( 3, "@E 9999999"  ) + ;
   		           Space( 101 )                  + CHR( 13 )+CHR( 10 )
   		
   		LTRCOF01GL( nHdl, cFooter, cFile ) // Grava Linha

		fClose(nHdl) // Fecha Arquivo
		
		

		MsgInfo( "Arquivo gerado em [C:\"+cFile+"]" )
		
		PutMvPar( "MV_SQRCOF2" , nSeq312Nw )
		
		dBSelectArea( "SZ3" )
		SZ3->( dBGoTop( ) )
		If !SZ3->( dBSeek( xFilial( "SZ3" ) + cNumRemes + "312" ) )
		 
			RecLock( "SZ3", .T. )
			SZ3->Z3_FILIAL  := xFilial( "SZ3" )
			SZ3->Z3_LAYOUT  := "312"
			SZ3->Z3_NOMEARQ := cFile
			SZ3->Z3_DTAREME := dDataBase
			SZ3->Z3_HRAREME := Time()
			SZ3->Z3_NUMREM  := cNumRemes
			SZ3->Z3_CNPJ    := SM0->M0_CGC
			SZ3->Z3_AGENCIA := cAgCont
			SZ3->Z3_CTACONT := cCcCont
			SZ3->Z3_NUMCONT := cNumCont
			SZ3->Z3_UOR     := cUor
			SZ3->Z3_USUARIO := SubStr( cUsuario, 7, 15 )
			SZ3->Z3_STATUS  := "I"
			SZ3->( MsUnLock( ) )
			
			MsgInfo( "Registro da geração da Remessa atualizada em SZ3 !" )
					
        Else
        	Alert( "Já existe uma Remessa gravada (SZ3) com esse número [" + Alltrim( cNumRemes ) + "]" )
        Endif


EndCase

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01CR º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pelo processo de determinar qual o lay  º±±
±±º          ³ out a ser usado e dependendo do lay-out o nome do arquivo  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01CR( nRadioLOut, cLayOut, cFile )
********************************************************

Do Case
	Case nRadioLOut == 1		
		cLayOut    := "310"
		cFile      := "RCOF310"
		cIndica310 := "----> [ Parâmetros RCOF 310 ] <= Lay-Out a ser utilizado no processo !"
		cIndica312 := "----> [ Parâmetros RCOF 312 ] <----"
		
	Case nRadioLOut == 2		 
		cLayOut    := "312"
		cFile      := "RCOF312"
		cIndica310 := "----> [ Parâmetros RCOF 310 ] <------------------------------"
		cIndica312 := "----> [ Parâmetros RCOF 312 ]  <= Lay-Out a ser utilizado no processo !"
		
EndCase

Return( Nil )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01V2 º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pela validação do período informado pa- º±±
±±º          ³ ra consulta dos movimentos.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01V2( dDataIni, dDataFim, oPanelGoTo )
************************************************************
Local lRet     := .T.
Local nPnlPar1 := GetMV( "MV_PNLPAR1" )
Local nPnlPar2 := GetMV( "MV_PNLPAR2" )


If Empty( dDataFim ) .OR. Empty( dDataIni )
	Alert( "Periodo informado é inválido." )
	lRet := .F.
Endif

If lRet
	If dDataFim < dDataIni
		Alert( "Periodo informado é inválido." )
		lRet := .F.
	Endif
Endif

Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01MA º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pelo processo de marcação dos itens no  º±±
±±º          ³ objeto de seleção exibido no Wizard.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01MA( cAliasRem, cFldOk, pnTotalV, pnTotalL, poTotalV, poTotalL )
***************************************************************************************
Local aTMP := GetArea( cAliasRem )

( cAliasRem )->( dBGoTop( ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄU
//³Verifica, caso o item esteja marcado, significa que esta desmarcando todos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄU
If !EMPTY( ( cAliasRem )->&( cFldOk ) )  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua laco passando por todos os registros da tabela temporaria³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !( cAliasRem )->( EOF( ) )
		RECLOCK( cAliasRem, .F. )
		( cAliasRem )->&( cFldOk )  := Space( 2 )
		( cAliasRem )->( MSUNLOCK() )

		If pnTotalV <> Nil .And. pnTotalL <> Nil
			pnTotalV -= ( cAliasRem )->D1_TOTAL 
			pnTotalL -= ( cAliasRem )->D1_QUANT
			poTotalV:Refresh()
			poTotalL:Refresh()
			SysRefresh()
		Endif
		
		( cAliasRem )->( dBSkip( ) )            
		
			
	Enddo
Else     
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa laco verificando todos os registros da tabela temporaria³
	//³trata-se de desmarcar todos                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !( cAliasRem )->( EOF( ) )
		RECLOCK(cAliasRem, .F.)
			( cAliasRem )->&( cFldOk ) := cMarca
		MSUNLOCK()

		If pnTotalV <> Nil .And. pnTotalL <> Nil
			pnTotalV += ( cAliasRem )->D1_TOTAL 
			pnTotalL += ( cAliasRem )->D1_QUANT
			poTotalV:Refresh()
			poTotalL:Refresh()
				
			SysRefresh()
		Endif
		
		( cAliasRem )->(dbSkip())
	End       
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza componente auxiliar da tela e restaura a integridade das tabelas envolvidas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RestArea(aTMP)

( cAliasRem )->(dbGoTop())

SysRefresh()

Return .T.                                              


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01MO º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pelo processo de marcação do iten no ob-º±±
±±º          ³ jeto de seleção exibido no Wizard.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01MO( cAliasRem, cFldOk, pnTotalV, pnTotalL, poTotalV, poTotalL )
***************************************************************************************
Local lRet 	:= .T.

If IsMark(cFldOk,cMarca,lInverte)
	( cAliasRem )->&( cFldOk ) := cMarca
	
	If pnTotalV <> Nil .And. pnTotalL <> Nil
		pnTotalV += ( cAliasRem )->D1_TOTAL 
		pnTotalL += ( cAliasRem )->D1_QUANT
		poTotalV:Refresh()
		poTotalL:Refresh()
		SysRefresh()
	Endif

Else
	( cAliasRem )->&( cFldOk ) := Space( 2 )

	If pnTotalV <> Nil .And. pnTotalL <> Nil
		pnTotalV -= ( cAliasRem )->D1_TOTAL 
		pnTotalL -= ( cAliasRem )->D1_QUANT
		poTotalV:Refresh()
		poTotalL:Refresh()
		SysRefresh()
	Endif

EndIf
    
SysRefresh() 

Return( lRet  )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01GL º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pelo processo de gravação da linha no   º±±
±±º          ³ arquivo sendo gerado (conforme o lay-out selecionado)      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01GL( nHdl, cConteudo, cFile )
****************************************************
Local cLin := cConteudo
Local lRet := .T.
	
If fWrite( nHdl, cLin, Len( cLin ) ) != Len( cLin )
	fClose( nHdl )
	fErase( cFile )
	lRet := .F.
	Alert("Erro ao gravar informações no arquivo" )
EndIf

Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01NF º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pela consulta dos movimentos de entra-  º±±
±±º          ³ da, referente ao "Produto" conforme produto informado.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01NF( aViewSD1, aStruSD1, cAliasSD1, dDataIni, dDataFim, cProdDe, cProdAte, pnTotalV, pnTotalL, poTotalV, poTotalL )
******************************************************************************************************************************************
Local aFields     := { "D1_OK", "A2_COD", "A2_LOJA", "A2_NOME", "A2_TIPO", "A2_CGC", "A2_COD_MUN", "A2_EST", "CC2_MUN", "D1_EMISSAO", "D1_COD", "B1_DESC", "B1_UM", "D1_QUANT", "D1_VUNIT", "D1_ALIQFUN", "D1_VALFUN", "D1_TOTAL", "F1_VALMERC", "D1_DOC", "D1_SERIE", "D1_X_DESCP" }
Local cSafra      := Alltrim( Str( Year( dDataBase ) - 1 ) ) + "/" + Alltrim( Str( Year( dDataBase )  ) )
Local cTabTMP2    := "" 
Local cQuery      := ""
Local lShare      := .T.
Local lReadOnly   := .F.                                        	

CursorWait()
SysRefresh()

aViewSD1 := {}
aStruSD1 := {}

pnTotalV := 0
pnTotalL := 0
poTotalV:Refresh()
poTotalL:Refresh()
SysRefresh()
	
dBSelectArea( "SX3" )
SX3->( dBSetOrder( 2 ) )

For nX := 1 To Len( aFields )
	
	SX3->( dBGoTop( ) )
	
	If SX3->( dBSeek( aFields[ nX ], .F. ) )
		
		cTitulo := ""
		
		Do Case
			Case Alltrim( SX3->X3_CAMPO ) $ "D1_OK | D1_OKISS"
				cTitulo := ""
		
			Case Alltrim( SX3->X3_CAMPO ) == "D1_X_DESCP"
				cTitulo := "Safra"
			
			Case Alltrim( SX3->X3_CAMPO ) == "F1_VALMERC"
				cTitulo := "Vlr Lts Liq"

			OtherWise
				cTitulo := AllTrim( X3Titulo( ) )
		EndCase
		
		aAdd( aViewSD1, { SX3->X3_CAMPO, ""          , cTitulo        , SX3->X3_PICTURE } )
		aAdd( aStruSD1, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		
	Endif
	
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consultando dados das remessas geradas      '³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT '  ' D1_OK,    "  + Chr( 13 )
cQuery += "       SA2.A2_COD,    "  + Chr( 13 )
cQuery += "       SA2.A2_LOJA,   "  + Chr( 13 )
cQuery += "       SA2.A2_NOME,   "  + Chr( 13 )
cQuery += "       SA2.A2_TIPO,   "  + Chr( 13 )
cQuery += "       SA2.A2_CGC,    "  + Chr( 13 )
cQuery += "       SA2.A2_COD_MUN,"  + Chr( 13 )
cQuery += "       SA2.A2_EST,    "  + Chr( 13 )
cQuery += "       CC2.CC2_MUN,   "  + Chr( 13 )
cQuery += "       SD1.D1_COD,    "  + Chr( 13 )
cQuery += "       SB1.B1_DESC,   "  + Chr( 13 )
cQuery += "       SB1.B1_UM,    "  + Chr( 13 )
cQuery += "       SD1.D1_EMISSAO,"  + Chr( 13 )
cQuery += "       SD1.D1_QUANT,  "  + Chr( 13 )
cQuery += "       SD1.D1_VUNIT,  "  + Chr( 13 )
cQuery += "       SD1.D1_ALIQFUN,"  + Chr( 13 )
cQuery += "       SD1.D1_VALFUN, "  + Chr( 13 )
cQuery += "       SD1.D1_TOTAL,  "  + Chr( 13 )
cQuery += "       (SD1.D1_TOTAL - SD1.D1_VALFUN) F1_VALMERC,  "  + Chr( 13 )
cQuery += "       SD1.D1_DOC,    "  + Chr( 13 )
cQuery += "       SD1.D1_SERIE,  "  + Chr( 13 )
cQuery += "       '" + cSafra + "' D1_X_DESCP" + Chr( 13 )
cQuery += "  FROM " + RetSqlName( "SD1" ) + " SD1, " + Chr( 13 )
cQuery += "       " + RetSqlName( "SA2" ) + " SA2, " + Chr( 13 )
cQuery += "       " + RetSqlName( "SB1" ) + " SB1, " + Chr( 13 )
cQuery += "       " + RetSqlName( "CC2" ) + " CC2  " + Chr( 13 )
cQuery += "   WHERE SD1.D1_FILIAL       = '" + xFilial( "SD1" ) + "'" + Chr( 13 )
cQuery += "     AND SA2.A2_FILIAL       = '" + xFilial( "SA2" ) + "'" + Chr( 13 )
cQuery += "     AND SB1.B1_FILIAL       = '" + xFilial( "SB1" ) + "'" + Chr( 13 )
cQuery += "     AND CC2.CC2_FILIAL      = '" + xFilial( "CC2" ) + "'" + Chr( 13 )
cQuery += "     AND SD1.D1_FORNECE      = SA2.A2_COD" + Chr( 13 )
cQuery += "     AND SD1.D1_LOJA         = SA2.A2_LOJA" + Chr( 13 )
cQuery += "     AND SD1.D1_COD          = SB1.B1_COD"  + Chr( 13 )
cQuery += "     AND SA2.A2_COD_MUN      = CC2.CC2_CODMUN"  + Chr( 13 )
cQuery += "     AND SA2.A2_EST          = CC2.CC2_EST"  + Chr( 13 )
cQuery += "     AND SA2.A2_X_TIPO       = 'P'" + Chr( 13 )

If lFirst
	cQuery += "     AND SD1.D1_EMISSAO      = 'X_X_X_X_'" + Chr( 13 )
Else
	cQuery += "     AND ( ( SD1.D1_EMISSAO >= '" + DTOS( dDataIni ) + "' ) AND ( SD1.D1_EMISSAO <= '" + DTOS( dDataFim ) + "' ) )" + Chr( 13 )
	cQuery += "     AND ( ( SD1.D1_COD     >= '" + cProdDe  + "' ) AND ( SD1.D1_COD  <= '" + cProdAte + "' ) )" + Chr( 13 )
Endif

cQuery += "     AND SD1.D1_TIPO        <> 'D'" + Chr( 13 )
cQuery += "     AND SD1.D_E_L_E_T_     <> '*'" + Chr( 13 )
cQuery += "     AND SA2.D_E_L_E_T_     <> '*'" + Chr( 13 )
cQuery += "     AND SB1.D_E_L_E_T_     <> '*'" + Chr( 13 )
cQuery += "     AND CC2.D_E_L_E_T_     <> '*'" + Chr( 13 )
cQuery += "ORDER BY SA2.A2_COD, SA2.A2_LOJA, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_ITEM" + Chr( 13 )

MemoWrite( "LTRCOF01NF.SQL", cQuery )

cQuery := ChangeQuery( cQuery )

If Select( cAliasSD1 ) > 0
	( cAliasSD1 )->( dBclosearea( ) )
EndIf

cTabTMP2   := CriaTrab( aStruSD1, .T. )

If lFirst
	dBUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasSD1, .T., .T.)
	lFirst := .F.
Else
	MsAguarde( {|| dBUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasSD1, .T., .T.) }, "Consultando movimentos..." )
Endif

For nX := 1 To len(aStruSD1)
	If aStruSD1[nX][2] <> "C" .And. FieldPos(aStruSD1[nX][1])<>0
	   TcSetField(cAliasSD1,aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
	EndIf
Next nX

Copy TO &cTabTMP2
dBCloseArea()

dBUseArea( .T.,, cTabTMP2, cAliasSD1, lShare, lReadOnly )

( cAliasSD1 )->( dBGoTop() )

CursorArrow()
SysRefresh()


Return( Nil )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LTRCOF01LL º Autor ³ TOTVS Paraná Central º Data ³ 19/03/13º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsável pelo processo de leitura da linha do ar-º±±
±±º          ³ quivo sendo gerado (conforme o lay-out selecionado)        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticínio Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LTRCOF01LL()
****************************
Local cLinhaTmp := ""
Local cLinhaM100 := ""

cLinhaTmp := FT_FReadLN()

If !Empty(cLinhaTmp)
	cIdent:= Substr(cLinhaTmp,1,1)
	If Len(cLinhaTmp) < 1023
		cLinhaM100 := cLinhaTmp
	Else
		cLinAnt := cLinhaTmp
		cLinhaM100 += cLinAnt
		Ft_FSkip()
		cLinProx:= Ft_FReadLN()
		If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
			While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
				cLinhaM100 += cLinProx
				Ft_FSkip()
				cLinProx := Ft_fReadLn()
				If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
					cLinhaM100 += cLinProx
				Endif
			Enddo
		Else
			cLinhaM100 += cLinProx
		Endif
	Endif
Endif

Return( cLinhaM100 )