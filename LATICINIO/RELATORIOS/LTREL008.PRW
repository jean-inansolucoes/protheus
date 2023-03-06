#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL008 ºAutor  ³Rafael Parma         º Data ³  21/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão do resultado análise normativa 62       º±±
±±º          ³para o produtor.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
  
*-----------------------*
User Function LTREL008()
*-----------------------*


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RESULTADO DE ANÁLISE POR PRODUTOR"
Local cPict          := ""
Local titulo         := "RESULTADO DE ANÁLISE POR PRODUTOR N62"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00008"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL008"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL008"
Public STRING_NULL   := ""


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamado rotina de verificação/criação do grupo de perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString := "ZL4"
	AjustaSX1()                                                 
	If ! Pergunte(cPerg, .T.) 
		Return
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Processa({|| Report(Cabec1,Cabec2,Titulo,nLin) },Titulo,"Processando...")	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³Report    º Autor ³Rafael Parma        º Data ³  21/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão do resultado análise normativa 62       º±±
±±º          ³para o produtor.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Report(Cabec1, Cabec2, Titulo, nLin)

Local cAliasTMP := GetNextAlias() 
Local hEnter	:= CHR(10) + CHR(13) 
Local aParam    := {}
Local nPag      := 1
Local nCCS_MAX  := 0
Local nCBT_MAX  := 0
Local nSLT_MAX  := 0 
Local nGORD_MIN := 0
Local nPROT_MIN := 0
Local nLACT_MIN := 0
Private cBitMap := "lgrl01.bmp"

    // recupera os limites de gordura do parâmetro
	U_LTGETPMM("MV_ZLGORD",aParam)
	nGORD_MIN := aParam[1]            
	
    // recupera os limites de proteína do parâmetro
	U_LTGETPMM("MV_ZLPROT",aParam)
	nPROT_MIN := aParam[1]

    // recupera os limites de lactose do parâmetro
	U_LTGETPMM("MV_ZLLACT",aParam)
	nLACT_MIN := aParam[1]                
	
    // recupera os limites de CCS do parâmetro
	U_LTGETPMM("MV_ZLCCS",aParam)	
	nCCS_MAX  := aParam[2]              
	
    // recupera os limites de CBT do parâmetro
	U_LTGETPMM("MV_ZLCBT",aParam)	
	nCBT_MAX  := aParam[2] 
	
	// recupera os limites de solidos totais do parâmetro
	U_LTGETPMM("MV_ZLSLT",aParam)
	nSLT_MAX  := aParam[1] 

	nheight07  := 7
	nHeight08  := 8
	nHeight09  := 9
	nHeight10  := 10
	nHeight11  := 11
	nHeight12  := 12
	nheight13  := 13
	nHeight15  := 15
	
	lBold	   := .T.
	lUnderLine := .T.
	
	oFont1	:= TFont():New( "Arial",,nheight07,,lBold,,,,,!lUnderLine )
	oFont2  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont3  := TFont():New( "Mono AS",,nHeight10,,lBold,,,,,!lUnderLine )
	oFont4  := TFont():New( "Arial",,nHeight11,,lBold,,,,,!lUnderLine )
	oFont5  := TFont():New( "Arial",,nHeight13,,lBold,,,,,!lUnderLine )
	oFont6  := TFont():New( "Arial",,nheight15,,lBold,,,,,!lUnderLine )
	oFont7  := TFont():New( "Arial",,nheight12,,lBold,,,,,!lUnderLine )
	oFont8  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont9  := TFont():New( "Arial",,nheight10,,lBold,,,,,!lUnderLine )
	lFirst	:= .T.

	oPrn    := TMSPrinter():New()
	oPen    := TPen():New(,7,CLR_BLACK,oPrn)

	cQuery := "SELECT 	ZL8.ZL8_PROTOC,										" + hEnter
	cQuery += "         ZL8.ZL8_DATCOL,										" + hEnter
	cQuery += "			ZL9.ZL9_PRODUT,										" + hEnter
	cQuery += "			ZL9.ZL9_LOJPRD,										" + hEnter		
	cQuery += "			ZL9.ZL9_NOMPRD,										" + hEnter
	cQuery += "			ZL9.ZL9_SEQ,   										" + hEnter
	cQuery += "			ZL9.ZL9_GORD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_PROTN, 										" + hEnter  
	cQuery += "			ZL9.ZL9_LACT,  										" + hEnter  
	cQuery += "			ZL9.ZL9_SOLD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CCS,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CBT,  										" + hEnter    
	cQuery += "			ZL0.ZL0_COD,  										" + hEnter  
	cQuery += "			ZL0.ZL0_DESC  										" + hEnter  	
	cQuery += "FROM " + RetSqlName("ZL8") + " ZL8							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL9") + " ZL9         			" + hEnter
	cQuery += "ON       ZL8.ZL8_FILIAL    = ZL9.ZL9_FILIAL      			" + hEnter		
	cQuery += "AND      ZL8.ZL8_PROTOC    = ZL9.ZL9_PROTOC      			" + hEnter	
	cQuery += "INNER JOIN " + RetSqlName("ZL1") + " ZL1         			" + hEnter
	cQuery += "ON       ZL9.ZL9_FILIAL    = ZL1.ZL1_FILIAL      			" + hEnter		
	cQuery += "AND      ZL9.ZL9_PRODUT    = ZL1.ZL1_PRODUT      			" + hEnter	
	cQuery += "AND      ZL9.ZL9_LOJPRD    = ZL1.ZL1_LOJPRD      			" + hEnter	
	cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0         			" + hEnter
	cQuery += "ON       ZL1.ZL1_FILIAL    = ZL0.ZL0_FILIAL      			" + hEnter		
	cQuery += "AND      ZL1.ZL1_COD       = ZL0.ZL0_COD		      			" + hEnter	
	cQuery += "WHERE    ZL9.ZL9_FILIAL = '" + xFilial("ZL9") + "' 			" + hEnter
	cQuery += "AND 	( ZL8.ZL8_DATCOL BETWEEN '" + dtos(mv_par01) + "' 		" + hEnter
	cQuery += "AND             		         '" + dtos(mv_par02) + "' )		" + hEnter	
	If mv_par11 == 1
		cQuery += "AND 	( ZL8.ZL8_PROTOC BETWEEN '" + mv_par03 + "' 		" + hEnter
		cQuery += "AND             		         '" + mv_par04 + "' )		" + hEnter	
	ElseIf mv_par11 == 2
		cQuery += "AND 	( ZL9.ZL9_PRODUT BETWEEN '" + mv_par05 + "' 		" + hEnter
		cQuery += "AND             		         '" + mv_par06 + "' )		" + hEnter	
		cQuery += "AND 	( ZL9.ZL9_LOJPRD BETWEEN '" + mv_par07 + "' 		" + hEnter
		cQuery += "AND             		         '" + mv_par08 + "' )		" + hEnter	
	ElseIf mv_par11 == 3
		cQuery += "AND  ( ZL0.ZL0_COD    BETWEEN '" + mv_par09 + "' 		" + hEnter
		cQuery += "AND             		         '" + mv_par10 + "' )		" + hEnter	
	EndIf
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL8.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL9.D_E_L_E_T_    != '*' 							" + hEnter	
 	cQuery += "ORDER BY ZL8.ZL8_PROTOC, 			 						" + hEnter		
 	cQuery += "			ZL9.ZL9_NOMPRD  		 							" + hEnter	

	
	MemoWrite("LTREL008.TXT",cQuery)
	
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	oPrn:SetPortrait()
	oPrn:Setup()
		 
	While (cAliasTMP)->(!EOF())
        
		If nPag == 1

			Li    := 50
			nCol  := 50
			nIncr := 0
	
			oPrn:StartPage()
			oPrn:SayBitmap( Li+000, nCol+000, cBitMap , 300, 90 )
	
			//SUPERIOR
			oPrn:Line( 0020, 0030,0020, 2300 )
			//ESQUERDO
			oPrn:Line( 0020, 0030,1240, 0030 )
			//DIREITO
			oPrn:Line( 0020, 2300,1240, 2300 )
			//INFERIOR
			oPrn:Line( 1240, 0030,1240, 2300 )
			
			oPrn:Box( 030, 040, 0200, 2290 )			
			oPrn:Box( 210, 040, 0400, 2290 )
			oPrn:Box( 410, 040, 1230, 2290 )
	    	
	    	nPag := 2
	    
		Else 

			Li    := 1750
			nCol  := 50
			nIncr := 0		
            
			oPrn:SayBitmap( Li+000, nCol+000, cBitMap , 300, 90 )
			//SUPERIOR
			oPrn:Line( 1720, 0030,1720, 2300 )
			//ESQUERDO
			oPrn:Line( 1720, 0030,2900, 0030 )
			//DIREITO
			oPrn:Line( 1720, 2300,2900, 2300 )
			//INFERIOR
			oPrn:Line( 2900, 0030,2900, 2300 )
			
			oPrn:Box( 1730, 040, 1900, 2290 )			
			oPrn:Box( 1910, 040, 2100, 2290 )
			oPrn:Box( 2110, 040, 2890, 2290 )
		
			nPag := 1

		EndIf
			
		nIncr += 020
		oPrn:Say( Li+nIncr, nCol+0840, ALLTRIM(SM0->M0_FILIAL)+" "+ALLTRIM(SM0->M0_NOMECOM), oFont6, 100 )
		
		nIncr += 050
		oPrn:Say( Li+nIncr, nCol+0940, "RESULTADO DE ANÁLISES - IN 62", oFont6, 100 )
		nIncr += 040
		oPrn:Say( Li+nIncr, nCol+1900, "Emissão: "+DTOC(DDATABASE), oFont2, 100 )
		
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0050, "Realizado por: Associação Paranaense de Criadores de Bovinos da Raça Holandesa", oFont4, 100 )
		nIncr += 040
		oPrn:Say( Li+nIncr, nCol+0050, "Programa de Análise de Rebanhos Leiteiros do Paraná", oFont4, 100 )
		nIncr += 040
		oPrn:Say( Li+nIncr, nCol+0050, "Rede Brasileira de Laboratórios de Controle de Qualidade de Leite", oFont4, 100 )

		nIncr += 120
		oPrn:Say( Li+nIncr, nCol+0050, "Data da coleta: "  + dtoc(stod((cAliasTMP)->ZL8_DATCOL)), oFont4, 100 )
		
		nIncr += 100
		oPrn:Say( Li+nIncr, nCol+0050, "Produtor: "+(cAliasTMP)->ZL9_PRODUT+"/"+(cAliasTMP)->ZL9_LOJPRD+"-"+SubSTR((cAliasTMP)->ZL9_NOMPRD,1,40), oFont5, 100 )

		nIncr += 100
		oPrn:Say( Li+nIncr, nCol+0050, "Resultados: ", oFont6, 100 )
		oPrn:Say( Li+nIncr, nCol+0950, "Parâmetros: ", oFont6, 100 )

		nIncr += 080
		If (cAliasTMP)->ZL9_GORD != 0
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Gordura: "+TRANSFORM((cAliasTMP)->ZL9_GORD,"@E 999.99"), oFont4, 100 )
		Else                                                                                                          
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Gordura: Não analisado.", oFont4, 100 )		
		EndIf		
		oPrn:Say( Li+nIncr, nCol+0950, "(%) Gordura mínimo: "+TRANSFORM(nGORD_MIN,"@E 999.99"), oFont4, 100 )
		
		nIncr += 080
		If (cAliasTMP)->ZL9_PROTN != 0
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Proteína: "+TRANSFORM((cAliasTMP)->ZL9_PROTN,"@E 999.99"), oFont4, 100 )
		Else
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Proteína: Não analisado.", oFont4, 100 )
		EndIf
		oPrn:Say( Li+nIncr, nCol+0950, "(%) Proteína mínimo: "+TRANSFORM(nPROT_MIN,"@E 999.99"), oFont4, 100 )
		
		nIncr += 080
		If (cAliasTMP)->ZL9_LACT != 0
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Extrato Seco deseng: "+TRANSFORM((cAliasTMP)->ZL9_LACT,"@E 999.99"), oFont4, 100 )
		Else 
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Extrato Seco deseng: Não analisado.", oFont4, 100 )
		EndIf
		oPrn:Say( Li+nIncr, nCol+0950, "(%) Extrato Seco desengordurado Min: "+TRANSFORM(nLACT_MIN,"@E 999.99"), oFont4, 100 )
		
		nIncr += 080
		If (cAliasTMP)->ZL9_SOLD != 0
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Extrato Seco total: "+TRANSFORM((cAliasTMP)->ZL9_SOLD,"@E 999.99") + " (%)", oFont4, 100 )
		Else                                                                                                                 
			oPrn:Say( Li+nIncr, nCol+0050, "(%) Extrato Seco total: Não analisado.", oFont4, 100 )
		EndIf
		oPrn:Say( Li+nIncr, nCol+0950, "Extrato Seco total Minino: "+TRANSFORM(nSLT_MAX, "@E 999.99")+" (%)", oFont4, 100 )
		
		nIncr += 080                                          
		If (cAliasTMP)->ZL9_CCS != 0
			oPrn:Say( Li+nIncr, nCol+0050, "CCS (ml): "+TRANSFORM((cAliasTMP)->ZL9_CCS*1000,"@E 99,999,999"), oFont4, 100 )
		Else
			oPrn:Say( Li+nIncr, nCol+0050, "CCS (ml): Não analisado.", oFont4, 100 )
		EndIf
		oPrn:Say( Li+nIncr, nCol+0950, "CCS (contagem de células somáticas) máximo: "+TRANSFORM(nCCS_MAX*1000, "@E 99,999,999")+" (CSS/ml)", oFont4, 100 )
		
		nIncr += 080
		If (cAliasTMP)->ZL9_CBT != 0
			oPrn:Say( Li+nIncr, nCol+0050, "CPP (UFC/ml): "+TRANSFORM((cAliasTMP)->ZL9_CBT*1000,"@E 99,999,999"), oFont4, 100 )
		Else 
			oPrn:Say( Li+nIncr, nCol+0050, "CPP (UFC/ml): Não analisado.", oFont4, 100 )
		EndIf
		oPrn:Say( Li+nIncr, nCol+0950, "CPP (contagem padrão em placas) máximo: "+TRANSFORM(nCBT_MAX*1000,"@E 99,999,999")+" (UFC/ml)", oFont4, 100 )

		If nPag == 1
			oPrn:EndPage() 
		EndIf
		        		
		(cAliasTMP)->(dbSkip())
				
	EndDo
    
	(cAliasTMP)->(dbCloseArea())
	
	oPrn:Preview()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se em disco, desvia para Spool                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
		Set Printer To
		Commit
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return
     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  21/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()
aRegs   := {}
aHelp01 := {}  
aHelp02 := {} 
aHelp03 := {}  
aHelp04 := {}                                                  
aHelp05 := {} 
aHelp06 := {} 
aHelp07 := {} 
aHelp08 := {}
aHelp09 := {}
aHelp10 := {}
aHelp11 := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Data Coleta De     ?","Data Coleta De     ?","Data Coleta De     ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0801."})
	aAdd(aRegs,{cPerg,"02","Data Coleta Até    ?","Data Coleta Até    ?","Data Coleta Até    ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0802."})	
	aAdd(aRegs,{cPerg,"03","Código Análise De  ?","Análise De         ?","Análise De         ?","mv_ch3","C",TAMSX3("ZL8_PROTOC")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","ZL8000","","",".LTREL0803."})
	aAdd(aRegs,{cPerg,"04","Código Análise Até ?","Análise Até        ?","Análise Até        ?","mv_ch4","C",TAMSX3("ZL8_PROTOC")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","ZL8000","","",".LTREL0804."})	
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2ZL2","","",".LTREL0805."})
	aAdd(aRegs,{cPerg,"06","Produtor Até       ?","Produtor Até       ?","Produtor Até       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2ZL2","","",".LTREL0806."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0807."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor Até  ?","Loja Produtor Até  ?","Loja Produtor Até  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0808."})
	aAdd(aRegs,{cPerg,"09","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch9","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0809."})
	aAdd(aRegs,{cPerg,"10","Linha Até          ?","Linha Até          ?","Linha Até          ?","mv_cha","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0810."})
	aAdd(aRegs,{cPerg,"11","Filtrar Por        ?","Filtrar Por        ?","Filtrar Por        ?","mv_chb","N",01,0,1,"C","","mv_par11","Código Análise","Código Análise","Código Análise","","","Produtor","Produtor","Produtor","","","Linha","Linha","Linha","","","","","","","","","","","","","","","","","",".LTREL0811."})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe a data inicial da coleta         " )       
	AADD( aHelp01, "a ser impressa.                          " )       
	AADD( aHelp02, "Informe a data final da coleta           " )       
	AADD( aHelp02, "a ser impressa.                          " )
	AADD( aHelp03, "Informe o código inicial da análise      " )       
	AADD( aHelp03, "a ser impressa.                          " )       
	AADD( aHelp04, "Informe o código final da análise        " )       
	AADD( aHelp04, "a ser impressa.                          " )
	AADD( aHelp05, "Informe o código inicial do produtor     " )       
	AADD( aHelp05, "a ser impresso.                          " )       
	AADD( aHelp06, "Informe o código final do produtor       " )       
	AADD( aHelp06, "a ser impresso.                          " )       
	AADD( aHelp07, "Informe a loja inicial do produtor       " )       
	AADD( aHelp07, "a ser impresso.                          " )       
	AADD( aHelp08, "Informe a loja final do produtor         " )       
	AADD( aHelp08, "a ser impresso.                          " )      
	AADD( aHelp09, "Informe o número inicial da linha        " )       
	AADD( aHelp09, "a ser impressa.                          " )       
	AADD( aHelp10, "Informe o número final da linha          " )       
	AADD( aHelp10, "a ser impressa.                          " )       
	AADD( aHelp11, "Filtrar intervalo por data análise,      " )       
	AADD( aHelp11, "protocolo, produtor/loja ou linha.       " )  
	
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
	PutSX1Help("P.LTREL0801.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0802.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL0803.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL0804.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL0805.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL0806.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL0807.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL0808.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL0809.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL0810.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL0811.",aHelp11,aHelp11,aHelp11)		
				
Return Nil