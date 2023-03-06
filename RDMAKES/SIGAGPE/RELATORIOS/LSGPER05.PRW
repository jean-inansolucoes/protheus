#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"     
#define DMPAPER_A4 9
 // A4 210 x 297 mm
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSGPER05   ³ Autor  ³Alexandre Longhinotti³ Data ³01.08.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatório Genérico GPE              			                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**------------------------------------------------------------------**
USER FUNCTION LSGPER05()
**------------------------------------------------------------------**
LOCAL cDesc1			 :="Relatório Genérico GPE"
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
PRIVATE titulo           := "Relatório Genérico GPE"
PRIVATE aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
PRIVATE nomeprog         := "LSGPER05",nLastKey := 0                                                                                     
PRIVATE cString          := "DAI"
Private cLogoEmp         := "logo.bmp"
Private cPerg		     := "LSGPER05  "
Private wnrel  			 := "LSGPER05"  
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
Local   nQuant    := 0 
Local nCount := 0  
Local nTotalT      := 0
Local nSubTotT 	   := 0  
Local hEnter	   := CHR(10) + CHR(13)

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

cQuery := " SELECT   SRA.RA_MAT,																" + hEnter
cQuery += "			 SRA.RA_NOME,																" + hEnter
cQuery += "          SRA.RA_CIC,																" + hEnter
cQuery += "          SRJ.RJ_DESC,								   								" + hEnter
cQuery += "          SRA.RA_SALARIO,							   								" + hEnter                    
cQuery += "          SRA.RA_SITFOLH,							   								" + hEnter
cQuery += "          SRA.RA_DEMISSA,							   								" + hEnter                    
cQuery += "          SRA.RA_CC,									   								" + hEnter                    
cQuery += "          CTT.CTT_DESC01								   								" + hEnter  
cQuery += " FROM SRA010 SRA										   								" + hEnter 
cQuery += " INNER JOIN SRJ010 SRJ 																" + hEnter 
cQuery += "         ON         RA_CODFUNC       = RJ_FUNCAO										" + hEnter 
cQuery += " INNER JOIN CTT010 CTT																" + hEnter 
cQuery += "         ON        RA_CC            = CTT_CUSTO										" + hEnter 
cQuery += "WHERE ( SRA.RA_CC         BETWEEN '" + mv_par05 + "'        AND '" + mv_par06 + "' )	" + hEnter
cQuery += "AND ( SRA.RA_ADMISSA    BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + " ') " + hEnter
DO CASE

	CASE "A" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'A'											" + hEnter
	CASE "D" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'D'											" + hEnter
	CASE "F" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'F'								   			" + hEnter		
	CASE "T" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'T'								   			" + hEnter
	CASE Alltrim(mv_par03) == ""
		cQuery += "AND (        SRA.RA_SITFOLH  =  'F'	 								   		" + hEnter
		cQuery += "OR          SRA.RA_SITFOLH   =  'A' 								   			" + hEnter
		cQuery += "OR          SRA.RA_SITFOLH   =  ' ' )								   		" + hEnter
END CASE

cQuery += "AND         SRA.D_E_L_E_T_   != '*'													" + hEnter
cQuery += "AND         SRJ.D_E_L_E_T_   != '*'					   								" + hEnter
cQuery += "AND         CTT.D_E_L_E_T_   != '*'													" + hEnter
cQuery += "AND         SRA.RA_CC	    != '02.01.01.001   '									" + hEnter
cQuery += "AND 		 ( SRA.RA_FILIAL         BETWEEN '" + mv_par07 + "'        AND '" + mv_par08 + "' )	" + hEnter
cQuery += "GROUP BY																				" + hEnter
cQuery += "			 SRA.RA_MAT,																" + hEnter
cQuery += "			 SRA.RA_NOME,																" + hEnter
cQuery += "          SRA.RA_CIC,																" + hEnter
cQuery += "          SRJ.RJ_DESC,								   								" + hEnter
cQuery += "          SRA.RA_SALARIO,							   								" + hEnter                    
cQuery += "          SRA.RA_SITFOLH,							   								" + hEnter
cQuery += "          SRA.RA_DEMISSA,							   								" + hEnter                    
cQuery += "          SRA.RA_CC,									   								" + hEnter                    
cQuery += "          CTT.CTT_DESC01								   								" + hEnter 
cQuery += "ORDER BY																				" + hEnter
cQuery += "        SRA.RA_CC,									   								" + hEnter
cQuery += "        SRA.RA_NOME									   								" + hEnter 


MemoWrite("LSGPER05.txt",cQuery)
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
	If Len(aVet) == 0
		AADD(aVet,{TMP->RA_MAT, ALLTRIM( TMP->RA_NOME ), TMP->RA_CIC, SUBSTR(TMP->RJ_DESC,1,35), TMP->RA_CC, TMP->CTT_DESC01 })
	Else
		nPos := aScan( aVet, {|x| ALLTRIM(x[1]) == ALLTRIM( TMP->RA_MAT ) }  )
		AADD(aVet,{TMP->RA_MAT, ALLTRIM( TMP->RA_NOME ), TMP->RA_CIC, SUBSTR(TMP->RJ_DESC,1,35), TMP->RA_CC, TMP->CTT_DESC01 })
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
  
		
		If ( i > 1 .AND. (aVet[i-1][5] # aVet[i][5])) .AND. ( nSubTotT > 0 ) .AND. ( i != len(aVet) )		
			
			oPrn:Say( Li+nIncr, nCol+0000, "Total de Funcionários no CC:", oFont10, 100 )
			oPrn:Say( Li+nIncr, nCol+0550, TRANSFORM(nSubTotT,"@E  999999") , oFont10, 100,,,1 )
		 	nSubTotT := 0				
			
			nIncr += 060	 		
		EndIf
		
		IF nIncr > 3300  
			ImpCab(1)
		ENDIF
		
		If ( i == 1 )  .OR. ( aVet[i-1][5] # aVet[i][5] )    
		 oPrn:Say( Li+nIncr, nCol+0000, Alltrim(aVet[i][5]) + " : " + aVet[i][6] , oFont10, 100,,,1 )
			nIncr += 060 	
		EndIf
		
		IF nIncr > 3300  
			ImpCab(1)
		ENDIF
				
		oPrn:Say( Li+nIncr, nCol+0000, aVet[i][1], oFont10, 100 ) 
		oPrn:Say( Li+nIncr, nCol+0350, aVet[i][2], oFont10, 100 ) 
		oPrn:Say( Li+nIncr, nCol+1650, aVet[i][3], oFont10, 100 )
		oPrn:Say( Li+nIncr, nCol+2000, aVet[i][4], oFont10, 100 )
		oPrn:Say( Li+nIncr, nCol+3000, aVet[i][5], oFont10, 100 )
		nIncr += 060
				      
		IF nIncr > 3300  
			ImpCab(1)
		ENDIF
		
		If ( i == len(aVet) )
			oPrn:Say( Li+nIncr, nCol+0000, "Total de Funcionários no CC:", oFont10, 100 )
			oPrn:Say( Li+nIncr, nCol+0550, TRANSFORM(nSubTotT,"@E  999999") , oFont10, 100,,,1 )
		 	nSubTotT := 0			
		EndIf
	
	next()

		       
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
oPrn:Say( Li+nIncr, nCol+0850, mv_par04, oFont13B, 100 )

nIncr += 180

oPrn:Line( Li+nIncr, 0030, Li+nIncr, 2400 )
nIncr += 020
oPrn:Say( Li+nIncr, nCol+0000, "Matric"     , oFont10B, 100 )
oPrn:Say( Li+nIncr, nCol+0350, "Nome"  		, oFont10B, 100 )
oPrn:Say( Li+nIncr, nCol+1570, "CPF"        , oFont10B, 100 )
oPrn:Say( Li+nIncr, nCol+1830, "FUNCAO" 	, oFont10B, 100 )
oPrn:Say( Li+nIncr, nCol+3000, "ASSINATURA"	, oFont10B, 100 )
nIncr += 050
oPrn:Line( Li+nIncr, 0030, Li+nIncr, 2400 )

nIncr += 050

Return()


//******************************************************************************
// Ajusta as perguntas (SX1) da rotina
//******************************************************************************

Static Function AjustaSX1()

aRegs  	:= {}  
aHelp1  := {}
aHelp2  := {} 
aHelp3  := {} 
aHelp4  := {}
aHelp5  := {}
aHelp6  := {}
aHelp7  := {}
aHelp8  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd(aRegs,{cPerg,"01","Periodo de       ?","Periodo de       ?","Periodo de       ?","mv_ch01","D",08                      ,0,0,"G","			","mv_par01",         	     "",        	   "",         	     "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"02","Periodo até      ?","Periodo até      ?","Periodo até      ?","mv_ch02","D",08						,0,0,"G","			","mv_par02",         	     "", 	   	       "",    	       	 "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"03","Situação         :","Situação         :","Situação         :","mv_ch03","C",01						,0,0,"G","			","mv_par03",         	     "", 	   	       "",    	       	 "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"04","Título Relatorio :","Título Relatorio :","Título Relatorio :","mv_ch04","C",60						,0,1,"C","			","mv_par04",				 "",			   "",				 "","","",		 "",	   "",		"","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"05","Centro Custo de  ?","Centro Custo de  ?","Centro Custo de  ?","mv_ch05","C",TAMSX3("CTT_CUSTO")[1]  ,0,0,"G","			","mv_par05",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","CTT","","","", ""})
aAdd(aRegs,{cPerg,"06","Centro Custo até ?","Centro Custo até ?","Centro Custo até ?","mv_ch06","C",TAMSX3("CTT_CUSTO")[1]  ,0,0,"G","			","mv_par06",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","CTT","","","", ""})
aAdd(aRegs,{cPerg,"07","Filial de        ?","Filial de        ?","Filial de        ?","mv_ch07","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par07",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})
aAdd(aRegs,{cPerg,"08","Filial até       ?","Filial até       ?","Filial até       ?","mv_ch08","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par08",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
Aadd( aHelp1 , "Informe a Data inicial.					 " )
Aadd( aHelp2 , "Informe a Data final. 					 " )
Aadd( aHelp3 , "Informe a situação dos funionários.      " )     
Aadd( aHelp3 , "Ex. A= Afastados, D=Demitidos			 " )
Aadd( aHelp3 , "F = Férias, T = Transferidos			 " )
Aadd( aHelp3 , "Branco = Ativos (Normal+Ferias)			 " )
Aadd( aHelp4 , "Informe o Título do Relatório! " )      
Aadd( aHelp5 , "Informe o Centro de Custo inicial		 " ) 
Aadd( aHelp6 , "Informe o Centro de Custo final			 " ) 
Aadd( aHelp7 , "Informe a filial inicial. 				 " )
Aadd( aHelp8 , "Informe a filial final. 				 " )


dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j, aRegs[i,j])	 
			Endif
		Next
		MsUnlock()
	Endif
Next  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o Help dos campos no arquivo de Help³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSX1Help("P." + cPerg + "01.", aHelp1, aHelp1, aHelp1)
PutSX1Help("P." + cPerg + "02.", aHelp2, aHelp2, aHelp2)
PutSX1Help("P." + cPerg + "03.", aHelp3, aHelp3, aHelp3)
PutSX1Help("P." + cPerg + "04.", aHelp4, aHelp4, aHelp4)
PutSX1Help("P." + cPerg + "05.", aHelp5, aHelp5, aHelp5)
PutSX1Help("P." + cPerg + "06.", aHelp6, aHelp6, aHelp6)
PutSX1Help("P." + cPerg + "07.", aHelp7, aHelp7, aHelp7)
PutSX1Help("P." + cPerg + "08.", aHelp8, aHelp8, aHelp8)     
Return .t.