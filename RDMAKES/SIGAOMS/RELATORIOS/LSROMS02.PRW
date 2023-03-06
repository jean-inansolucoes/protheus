#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH"     
#define DMPAPER_A4 9
 // A4 210 x 297 mm
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSROMS02   ³ Autor  ³Joel Lipnharski      ³ Data ³22.04.2010  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³RELATORIO de Resumo de Itens da Carga			                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**------------------------------------------------------------------**
USER FUNCTION LSROMS02()
**------------------------------------------------------------------**
LOCAL cDesc1			 :="Resumo de Itens da CARGA"
LOCAL cDesc2			 :=""
LOCAL cDesc3			 :=""
LOCAL aDadosRel
Private limite           := 132
Private nTotal           := 0
Private nValVend         := 0
Private nDevVend         := 0
Private cConPc           := 0
Private bImpr 			 := .F.
Private tamanho          := "P"
Private nTipo            := 18
PRIVATE titulo           := "Resumo de Itens da CARGA"
PRIVATE aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
PRIVATE nomeprog         := "LSROMS02",nLastKey := 0                                                                                     
PRIVATE cString          := "DAI"
Private cLogoEmp         := "logo.bmp"
Private cPerg		     := "LSROMS02  "
Private wnrel  			 := "LSROMS02"  
Private cVersion	     := "v.P11"
Private oBrush1
Private oBrush2             
Private aVet	         := {}
Private bInclui			 := .T.

ajustaSX1()           

If Pergunte(cPerg,.T.)
	nHeight07  := 7
	nHeight08  := 8
	nHeight10  := 10
	nheight13  := 13
	nHeight11  := 11
	lBold	   := .T.
	lUnderLine := .T.
	Processa( {|| IMPREL(wnrel,cString,aDadosRel) },Titulo,"Processando.....",.t. )
Else
    MSGALERT("Abortado pelo usuário!")
	dbCloseArea("TMP")
	RETURN .F.
EndIf

Return()

**/*----------------------------------------------------*/**
Static Function IMPREL(wnrel,cString,aDadosRel)
**/*----------------------------------------------------*/**
Local   cabec1   := "",cabec2:= "",cabec3:= ""
Local   aDadosRel
Local   nPerc     := 0
Local   nCont	  := 0  
Local   nPeso     := 0 
Local   nQuant    := 0 
Private nCol      := 50
Private nIncr     := 50
Private nPag      := 0
Private li        := 0
Private nPag      := 0
oFont7    := TFont():New( "Arial",,nHeight07,,!lBold,,,,,!lUnderLine )
oFont8    := TFont():New( "Arial",,nHeight08,,!lBold,,,,,!lUnderLine )
oFont8B   := TFont():New( "Arial",,nHeight08,, lBold,,,,,!lUnderLine )
oFont10   := TFont():New( "Arial",,nHeight10,,!lBold,,,,,!lUnderLine )
oFont10B  := TFont():New( "Arial",,nHeight10,, lBold,,,,,!lUnderLine )
oFont13   := TFont():New( "Arial",,nHeight13,,!lBold,,,,,!lUnderLine )
oFont13B  := TFont():New( "Arial",,nHeight13,, lBold,,,,,!lUnderLine )

lFirst	:= .T.

oPrn  := TMSPrinter():New()
oPen  := TPen():New(,7,CLR_BLACK,oPrn)
oBrush1 := TBrush():New( , CLR_GRAY )

/*
cQuery := "SELECT SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_CARGA, "
cQuery += "SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_PESO "
cQuery += "FROM "+RetSqlName("SF2")+" SF2 ," + RetSqlName("SD2")+" SD2 "
cQuery += "WHERE SF2.F2_DOC = SD2.D2_DOC AND "
cQuery += "SF2.F2_SERIE = SD2.D2_SERIE AND "
cQuery += "SF2.F2_CLIENTE = SD2.D2_CLIENTE AND "
cQuery += "SF2.F2_LOJA = SD2.D2_LOJA AND "
cQuery += "SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
cQuery += "SF2.F2_CARGA = '"+mv_par01+"' AND "
cQuery += "SF2.D_E_L_E_T_ <> '*' AND " 
cQuery += "SD2.D_E_L_E_T_ <> '*' " 
cQuery += "ORDER BY SF2.F2_CARGA"  
*/

cQuery := "SELECT DAI.DAI_COD, DAI.DAI_PEDIDO, SC9.C9_PEDIDO, SC9.C9_PRODUTO, SC9.C9_QTDLIB, SC9.C9_CARGA "
cQuery += "FROM "+RetSqlName("DAI")+" DAI ," + RetSqlName("SC9")+" SC9 "
cQuery += "WHERE DAI.DAI_COD = SC9.C9_CARGA AND "   
cQuery += "DAI.DAI_PEDIDO = SC9.C9_PEDIDO AND "   
cQuery += "DAI.DAI_FILIAL = '"+xFilial("DAI")+"' AND "
cQuery += "DAI.DAI_COD = '"+mv_par01+"' AND "
cQuery += "DAI.D_E_L_E_T_ <> '*' AND " 
cQuery += "SC9.D_E_L_E_T_ <> '*' " 
cQuery += "ORDER BY SC9.C9_PEDIDO, DAI.DAI_COD"  

MemoWrite("LSROMS02.txt",cQuery)
TcQuery ChangeQuery( cQuery ) NEW ALIAS "TMP"
  
dbSelectArea("TMP")
dbGoTop("TMP")
While !EOF()
	nCont ++
	dbskip()
EndDo
ProcRegua(nCont)  

dbSelectArea("TMP")
dbGotop()
While !EOF()
	Peso := POSICIONE("SB1",1,XFILIAL("SB1")+TMP->C9_PRODUTO,"B1_PESO")*TMP->C9_QTDLIB
	If Empty(aVet)
 		AADD (aVet, {TMP->C9_PRODUTO, Peso, TMP->C9_QTDLIB}) 
  		nPeso  += Peso
  		nQuant += TMP->C9_QTDLIB 		
	Else          	
		For x := 1 to len(aVet)
			If aVet[x][1] == TMP->C9_PRODUTO
				aVet[x][2] += Peso
				aVet[x][3] += TMP->C9_QTDLIB   
		  		nPeso += Peso
		  		nQuant += TMP->C9_QTDLIB
			    bInclui := .F.   
			    x := len(aVet)
			EndIf 
			
		next()
		
		If bInclui
			AADD (aVet, {TMP->C9_PRODUTO, Peso,  TMP->C9_QTDLIB})
		 	nPeso += Peso
		    nQuant += TMP->C9_QTDLIB
		EndIf 
	EndIf
	dbskip()  
	bInclui := .T.
EndDo

dbSelectArea("TMP")
dbGotop()
IF !EOF()

//INICIO RELATORIO GRAFICO
   
   	oPrn:Setup()
	oPen:= TPen():New(,7,CLR_BLACK,oPrn)
	ImpCab(0)  
 
 	IncProc()

	For i := 1 to len(aVet)	
  
		oPrn:Say( Li+nIncr, nCol+0000, aVet[i][1], oFont10, 100 ) 
		oPrn:Say( Li+nIncr, nCol+0350, POSICIONE("SB1",1,XFILIAL("SB1")+aVet[i][1],"B1_DESC") , oFont10, 100 ) 
		oPrn:Say( Li+nIncr, nCol+1650, Transform(aVet[i][2],"@E 999,999.99") , oFont10, 100,,,1 ) 
		oPrn:Say( Li+nIncr, nCol+2000, Transform(aVet[i][3],"@E 999,999.99") , oFont10, 100,,,1 ) 
		nIncr += 060
				      
		IF nIncr > 3300  
			ImpCab(1)
		ENDIF
		
	next()

	oPrn:Say( Li+nIncr, nCol+0000, "Total: ", oFont10B, 100 ) 
	oPrn:Say( Li+nIncr, nCol+1650, Transform(nPeso, "@E 999,999.99") , oFont10B, 100,,,1 ) 
	oPrn:Say( Li+nIncr, nCol+2000, Transform(nQuant,"@E 999,999.99") , oFont10B, 100,,,1 ) 
	       
	oPrn:EndPage()
	
	oPrn:Preview()
	
	DbCloseArea("TMP")

ELSE
	MSGALERT("Não há dados a serem exibidos!")  
	DbCloseArea("TMP")	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .T.

**----------------------------------------**
Static Function ImpCab(nPula)
**----------------------------------------**

IF nPula == 1
	oPrn:EndPage()
ENDIF  

Li    := 50
nCol  := 50
nIncr := 0
nPag ++
oPrn:SetPortrait()
oPrn:StartPage()
oPrn:setPaperSize( DMPAPER_A4 )
oPrn:SayBitmap( Li+000, nCol+000, cLogoEmp  , 365, 205 ) 
nIncr += 030
//SUPERIOR
oPrn:Line( 0020, 0030,0020, 2400 )
//ESQUERDO
oPrn:Line( 0020, 0030,3400, 0030 )  
//DIREITO
oPrn:Line( 0020, 2400,3400, 2400 ) 
//INFERIOR
oPrn:Line( 3400, 0030,3400, 2400 ) 

oPrn:Say( 0080, nCol+1850, "Folha  : "+ALLTRIM(STR(nPag)) , oFont7, 100 )
oPrn:Say( 0110, nCol+1850, "Hora   : "+Time()             , oFont7, 100 )
oPrn:Say( 0140, nCol+1850, ALLTRIM(wnrel)+" / "+cVersion  , oFont7, 100 )
oPrn:Say( 0170, nCol+1850, "Emissão: "+DTOC(DDATABASE)    , oFont7, 100 )
oPrn:Say( 0200, nCol+1850, "Empresa: SILVESTRE"+"/"+ALLTRIM(SM0->M0_FILIAL), oFont7, 100 )

nIncr += 20
oPrn:Say( Li+nIncr, nCol+0850, titulo, oFont13B, 100 )

DbSelectArea("TMP")
DbGotop()
oPrn:Say( Li+nIncr, nCol+0850, titulo+": ", oFont13B, 100 )
oPrn:Say( Li+nIncr, nCol+1500, TMP->DAI_COD, oFont13B, 100 )

nIncr += 180

oPrn:Line( Li+nIncr, 0030, Li+nIncr, 2400 )
nIncr += 020
oPrn:Say( Li+nIncr, nCol+0000, "Codigo"     , oFont10B, 100 )
oPrn:Say( Li+nIncr, nCol+0350, "Descricao"  , oFont10B, 100 )
oPrn:Say( Li+nIncr, nCol+1570, "Peso"       , oFont10B, 100 )
oPrn:Say( Li+nIncr, nCol+1830, "Quantidade" , oFont10B, 100 )
nIncr += 050
oPrn:Line( Li+nIncr, 0030, Li+nIncr, 2400 )

nIncr += 050

Return()

**/*----------------------------------------------------*/**
Static Function ajustaSX1()
**/*----------------------------------------------------*/**

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Carga a ser considerada.')
PutSx1(cPerg,"01","Carga de       ?","Carga de       ?","Carga de       ?","mv_ch1","C",6,0,0,"G","","DAK","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//aHelpPor	:= {}
//aHelpEng	:= {}
//aHelpSpa	:= {}
//Aadd( aHelpPor, 'Carga final a ser considerada.')
//PutSx1(cPerg,"02","Carga ate      ?","Carga ate      ?","Carga ate      ?","mv_ch2","C",6,0,0,"G","","DAK","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
               
Return .t.