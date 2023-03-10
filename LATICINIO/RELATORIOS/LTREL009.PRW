#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?LTREL009 ?Autor  ?Rafael Parma         ? Data ?  24/11/2009 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Rotina de impress?o da notifica??o de crioscopia eletr?nica ???
???          ?de acordo com as an?lises de coletas de campo.              ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS LATICINIO                                             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
 
  
*-----------------------*
User Function LTREL009()
*-----------------------*


//?????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de Variaveis                                             ?
//???????????????????????????????????????????????????????????????????????

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "NOTIFICA??O CRIOSCOPIA ELETR?NICA"
Local cPict          := ""
Local titulo         := "NOTIFICA??O CRIOSCOPIA ELETR?NICA"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00009"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL009"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL009"
Public STRING_NULL   := ""


	//???????????????????????????????????????????????????????????Ŀ
	//?Chamado rotina de verifica??o/cria??o do grupo de perguntas?
	//?????????????????????????????????????????????????????????????
	cString := "ZL4"
	AjustaSX1()                                                 
	If ! Pergunte(cPerg, .T.) 
		Return
	EndIf
	
	//?????????????????????????????????????????????????????????????????????Ŀ
	//? Processamento. RPTSTATUS monta janela com a regua de processamento. ?
	//???????????????????????????????????????????????????????????????????????

	Processa({|| Report(Cabec1,Cabec2,Titulo,nLin) },Titulo,"Processando...")	

Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?Report    ? Autor ?Rafael Parma        ? Data ?  24/11/09   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Rotina de impress?o da notifica??o de crioscopia eletr?nica ???
???          ?de acordo com as an?lises de coletas de campo.              ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function Report(Cabec1, Cabec2, Titulo, nLin)

Local cAliasTMP := GetNextAlias()
Local hEnter	:= CHR(10) + CHR(13) 
Local aParam    := {}
Local nPag      := 1
Private cBitMap := "lgrl01.bmp"


    // recupera os limites de gordura do par?metro
	U_LTGETPMM("MV_ZLGORD",aParam)
	nGORD_MIN := aParam[1]            
	
    // recupera os limites de prote?na do par?metro
	U_LTGETPMM("MV_ZLPROT",aParam)
	nPROT_MIN := aParam[1]

    // recupera os limites de lactose do par?metro
	U_LTGETPMM("MV_ZLLACT",aParam)
	nLACT_MIN := aParam[1]                
	
    // recupera os limites de CCS do par?metro
	U_LTGETPMM("MV_ZLCCS",aParam)	
	nCCS_MAX  := aParam[2]              
	
    // recupera os limites de CBT do par?metro
	U_LTGETPMM("MV_ZLCBT",aParam)	
	nCBT_MAX  := aParam[2] 
	
	// recupera os limites de solidos totais do par?metro
	U_LTGETPMM("MV_ZLSLT",aParam)
	nSLT_MAX  := aParam[2]

    // recupera os limites de alizarol do par?metro
	U_LTGETPMM("MV_ZLALI",aParam)	
	nALZ_MIN  := aParam[1] 

    // recupera os limites de crioscopia do par?metro
	U_LTGETPMM("MV_ZLCRIO",aParam)	
	nCRI_MIN  := aParam[1]*1000 
	nCRI_MAX  := aParam[2]*1000 

    // recupera os limites de densidade do par?metro
	U_LTGETPMM("MV_ZLDENS",aParam)	
	nDEN_MIN  := aParam[1] 
	nDEN_MAX  := aParam[2] 
	
    // recupera os limites de EST do par?metro
	U_LTGETPMM("MV_ZLEST",aParam)	
	nEST_MIN  := aParam[1] 

    // recupera os limites de ESD do par?metro
	U_LTGETPMM("MV_ZLESD",aParam)	
	nESD_MIN  := aParam[1] 

    // recupera os limites de redutase do par?metro
	U_LTGETPMM("MV_ZLRED",aParam)	
	nRED_MIN  := aParam[1]

    // recupera os limites de acidez do par?metro
	U_LTGETPMM("MV_ZLACDZ",aParam)	
	nACD_MIN  := aParam[1]		
	nACD_MAX  := aParam[2]
	 

	nheight07  := 7
	nHeight08  := 8
	nHeight09  := 9
	nHeight10  := 10
	nHeight11  := 11
	nHeight12  := 12
	nheight13  := 13
	nHeight15  := 15
	nHeight22  := 22
		
	lBold	   := .T.
	lUnderLine := .T.
	
	oFont0  := TFont():New( "Arial",,nHeight22,,lBold,,,,,!lUnderLine )
	oFont1	:= TFont():New( "Arial",,nheight07,,lBold,,,,,!lUnderLine )
	oFont2  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont3  := TFont():New( "Arial",,nHeight10,,lBold,,,,,!lUnderLine )
	oFont4  := TFont():New( "Arial",,nHeight11,,lBold,,,,,!lUnderLine )
	oFont5  := TFont():New( "Arial",,nHeight13,,lBold,,,,,!lUnderLine )
	oFont6  := TFont():New( "Arial",,nheight15,,lBold,,,,,!lUnderLine )
	oFont7  := TFont():New( "Arial",,nheight12,,lBold,,,,,!lUnderLine )
	oFont8  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont9  := TFont():New( "Arial",,nheight10,,lBold,,,,,!lUnderLine )

	lFirst	:= .T.

	oPrn    := TMSPrinter():New()
	oPen    := TPen():New(,7,CLR_BLACK,oPrn)

	cQuery := "SELECT 	ZLA.ZLA_NUMERO,							 					" + hEnter
	cQuery += "         ZLA.ZLA_DATA,												" + hEnter
	cQuery += "         ZLA.ZLA_PRODUT,												" + hEnter
	cQuery += "         ZLA.ZLA_LOJPRD,												" + hEnter
	cQuery += "         ZLA.ZLA_NOMPRD,									   			" + hEnter
	cQuery += "         ZLA.ZLA_ACID,												" + hEnter
	cQuery += "         ZLA.ZLA_CRIO,												" + hEnter
	cQuery += "         ZLA.ZLA_PERC,												" + hEnter
	cQuery += "         ZLA.ZLA_GORD,												" + hEnter
	cQuery += "         ZLA.ZLA_ESD,												" + hEnter
	cQuery += "         ZLA.ZLA_DENS,												" + hEnter
	cQuery += "         ZLA.ZLA_PROT,												" + hEnter
	cQuery += "         ZLA.ZLA_QTDE,												" + hEnter
	cQuery += "         ZLA.ZLA_LACT,												" + hEnter
	cQuery += "         ZLA.ZLA_CLORET,												" + hEnter
	cQuery += "         ZLA.ZLA_NEUTRA,												" + hEnter
	cQuery += "         ZLA.ZLA_RECONS,												" + hEnter	 
	cQuery += "         ZLA.ZLA_ALIZAR,												" + hEnter	 
	cQuery += "         ZLA.ZLA_EST,												" + hEnter	 
	cQuery += "         ZLA.ZLA_REDUTA,												" + hEnter	 
	cQuery += "         ZLA.ZLA_HIDSOD,												" + hEnter	 
	cQuery += "         ZLA.ZLA_BICARB,												" + hEnter	 
	cQuery += "         ZLA.ZLA_BORATO,												" + hEnter	 
	cQuery += "         ZLA.ZLA_PERHID,												" + hEnter	 
	cQuery += "         ZLA.ZLA_FORMOL,												" + hEnter	 
	cQuery += "         ZLA.ZLA_SACARO,												" + hEnter	 
	cQuery += "         ZLA.ZLA_AMIDO,												" + hEnter	 
	cQuery += "         ZLA.ZLA_ANALIS												" + hEnter	 
	cQuery += "FROM " + RetSqlName("ZLA") + " ZLA						  			" + hEnter 
	cQuery += "INNER JOIN " + RetSqlName("ZL1") + " ZL1         					" + hEnter
	cQuery += "ON       ZL1.ZL1_FILIAL    = ZLA.ZLA_FILIAL      					" + hEnter		
	cQuery += "AND      ZL1.ZL1_PRODUT    = ZLA.ZLA_PRODUT      					" + hEnter	
	cQuery += "AND      ZL1.ZL1_LOJPRD    = ZLA.ZLA_LOJPRD      					" + hEnter	
	cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0         					" + hEnter
	cQuery += "ON       ZL0.ZL0_FILIAL    = ZL1.ZL1_FILIAL      					" + hEnter		
	cQuery += "AND      ZL0.ZL0_COD       = ZL1.ZL1_COD		      					" + hEnter		
	cQuery += "WHERE    ZLA.ZLA_FILIAL = '" + xFilial("ZLA") + "' 		   			" + hEnter
	If mv_par11 == 1
		cQuery += "AND 		( ZLA.ZLA_DATA   BETWEEN  '" + dtos(mv_par01) + "'  	" + hEnter
		cQuery += "AND                 		          '" + dtos(mv_par02) + "' )	" + hEnter	
	ElseIf mv_par11 == 2
		cQuery += "AND 		( ZLA.ZLA_NUMERO BETWEEN  '" + mv_par03 + "' 	  		" + hEnter
		cQuery += "AND                 		          '" + mv_par04 + "' )	  		" + hEnter	
	ElseIf mv_par11 == 3
		cQuery += "AND 		( ZLA.ZLA_PRODUT BETWEEN  '" + mv_par05 + "' 	  		" + hEnter
		cQuery += "AND                 		          '" + mv_par06 + "' )	 		" + hEnter	
		cQuery += "AND 		( ZLA.ZLA_LOJPRD BETWEEN  '" + mv_par07 + "' 	 		" + hEnter
		cQuery += "AND                 		          '" + mv_par08 + "' )	  		" + hEnter	
	ElseIf mv_par11 == 4
		cQuery += "AND  	( ZL0.ZL0_COD    BETWEEN  '" + mv_par09 + "' 			" + hEnter
		cQuery += "AND      	       		          '" + mv_par10 + "' )			" + hEnter	
	EndIf
	cQuery += "AND 		( ZLA.ZLA_CRIO NOT BETWEEN " + cValToChar(nCRI_MIN) + "  	" + hEnter
	cQuery += "AND        ZLA.ZLA_CRIO             " + cValToChar(nCRI_MAX) + " )	" + hEnter
	cQuery += "AND        ZLA.ZLA_PERC           > 0                                " + hEnter
	cQuery += "AND 		ZLA.D_E_L_E_T_  != '*' 							   			" + hEnter	
 	cQuery += "ORDER BY ZLA.ZLA_NUMERO, 			 					  			" + hEnter	
 	cQuery += "			ZLA.ZLA_DATA,			 						  			" + hEnter	
 	cQuery += "			ZLA.ZLA_NOMPRD	 		 						  			" + hEnter	

	
	MemoWrite("LTREL009.TXT",cQuery)
	
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
        
	    //-- Imprimir todas as an?lises = 1-N?o
	    If mv_par12 == 1
		    
		    If nPag == 1
	
				Li    := 50
				nCol  := 50
				nIncr := 0
		
				oPrn:StartPage()
				oPrn:SayBitmap( Li+010, nCol+020, cBitMap , 250, 100 )
		
				//SUPERIOR
				oPrn:Line( 0020, 0030,0020, 2300 )
				//ESQUERDO
				oPrn:Line( 0020, 0030,1540, 0030 )
				//DIREITO
				oPrn:Line( 0020, 2300,1540, 2300 )
				//INFERIOR
				oPrn:Line( 1540, 0030,1540, 2300 )
				
				oPrn:Box( 030, 040, 0280, 2290 )
				oPrn:Box( 290, 040, 1530, 2290 )
		    	
		    	nPag := 2
		    
			Else 
	
				Li    := 1750
				nCol  := 50
				nIncr := 0		
	            
				oPrn:SayBitmap( Li+010, nCol+020, cBitMap , 250, 100 )
				
				//SUPERIOR
				oPrn:Line( 1720, 0030, 1720, 2300 )
				//ESQUERDO
				oPrn:Line( 1720, 0030, 3220, 0030 )
				//DIREITO
				oPrn:Line( 1720, 2300, 3220, 2300 )
				//INFERIOR
				oPrn:Line( 3220, 0030, 3220, 2300 )
				
				oPrn:Box( 1730, 040, 1980, 2290 )
				oPrn:Box( 1990, 040, 3210, 2290 )
			
				nPag := 1
	
			EndIf
				
			nIncr += 020
			oPrn:Say( Li+nIncr, nCol+1000, ALLTRIM(SM0->M0_FILIAL)+" "+ALLTRIM(SM0->M0_NOMECOM), oFont6, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0720, "Registro no Servi?o de Inspe??o Federal sob n. 2012", oFont6, 100 )
			nIncr += 070                                                                                       
			oPrn:Say( Li+nIncr, nCol+1000, "NOTIFICA??O", oFont0, 100 )
			nIncr += 140
			oPrn:Say( Li+nIncr, nCol+0040, "Ilmo Sr.(a) " + ALLTRIM((cAliasTMP)->ZLA_NOMPRD), oFont6, 100 )						
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0080, "Vimos por interm?dio desta, informa-lo que na data de hoje, do total de "+TRANSFORM((cAliasTMP)->ZLA_QTDE,"@E 9999") + " litros de leite remetidos", oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "por Vossa Senhoria, foi detectado na an?lise de Crioscopia Eletr?nica um percentual de " + TRANSFORM((cAliasTMP)->ZLA_PERC, "@E 999.99") +" %" , oFont4, 100 )
			nIncr += 050
			nIMPRESSAO := NoRound(((cAliasTMP)->ZLA_PERC*(cAliasTMP)->ZLA_QTDE)/100,0)
			If nIMPRESSAO == 0
				nIMPRESSAO := 1
			EndIf
			oPrn:Say( Li+nIncr, nCol+0040, "de ?gua, que equivale a " + TRANSFORM(nIMPRESSAO , "@E 9999") + " litros de ?gua." , oFont4, 100 )
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0080, "Portanto, encontrando-se o leite nestas condi??es, somos obrigados a NOTIFICA-LO e tamb?m " , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "a realizar o DESCONTO da quantidade de ?gua detectada, da quantidade total de leite entregue " , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "por Vossa Senhoria, como prev? o RIISPOA (Regulamento de Inspe??o Industrial e Sanit?ria de" , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "Produtos de Origem Animal)." , oFont4, 100 )
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0500, ALLTRIM(SM0->M0_CIDCOB) + ", " + cValtoChar(day(ddatabase)) + " DE " + UPPER(mesextenso(month(ddatabase))) + " DE " + cValtoChar(year(ddatabase)) , oFont4, 100 )
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0560, Replicate("_",22) , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0580, "Controle de Qualidade" , oFont4, 100 )
			nIncr += 140
			oPrn:Say( Li+nIncr, nCol+0040, "OBS- Estamos certos que poderemos contar com sua colabora??o para regulariza??o deste problema." , oFont4, 100 )
			nIncr += 090
			oPrn:Say( Li+nIncr, nCol+0040, "Resultado da An?lise:" , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "ACIDEZ: " + TRANSFORM((cAliasTMP)->ZLA_ACID, "@E 999") + "? D" , oFont4, 100 )
			oPrn:Say( Li+nIncr, nCol+0500, "CRIOSCOPIA: " + TRANSFORM((cAliasTMP)->ZLA_CRIO, "@E 9999") + "m? H" , oFont4, 100 )
			oPrn:Say( Li+nIncr, nCol+1200, "N. AMOSTRA: " + ALLTRIM((cAliasTMP)->ZLA_NUMERO) , oFont4, 100 )
			nIncr += 090
			oPrn:Say( Li+nIncr, nCol+0040, "Par?metros:" , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "ACIDEZ: " + TRANSFORM(nACD_MIN, "@E 99") + "? a " + TRANSFORM(nACD_MAX, "@E 99") + "?D (graus Dornic)" , oFont4, 100 )
			oPrn:Say( Li+nIncr, nCol+0800, "CRIOSCOPIA: " + TRANSFORM(nCRI_MIN, "@E 9999") + " a " + TRANSFORM(nCRI_MAX, "@E 9999") + "m ?H (graus Hovert)" , oFont4, 100 )
	
			If nPag == 1
				oPrn:EndPage() 
			EndIf
			
		//-- Imprimir todas as an?lises = 2=Sim
	    Else

			Li    := 50
			nCol  := 50
			nIncr := 0
	
			oPrn:StartPage()
			oPrn:SayBitmap( Li+010, nCol+020, cBitMap , 250, 100 )
	
			//SUPERIOR
			oPrn:Line( 0020, 0030,0020, 2300 )
			//ESQUERDO
			oPrn:Line( 0020, 0030,2600, 0030 )
			//DIREITO
			oPrn:Line( 0020, 2300,2600, 2300 )
			//INFERIOR
			oPrn:Line( 2600, 0030,2600, 2300 )
			
			oPrn:Box( 0030, 040, 0280, 2290 )
			oPrn:Box( 0290, 040, 1250, 2290 )
			oPrn:Box( 1260, 040, 2590, 2290 )			
	    	
			nIncr += 020
			oPrn:Say( Li+nIncr, nCol+1000, ALLTRIM(SM0->M0_FILIAL)+" "+ALLTRIM(SM0->M0_NOMECOM), oFont6, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0720, "Registro no Servi?o de Inspe??o Federal sob n. 2012", oFont6, 100 )
			nIncr += 070                                                                                       
			oPrn:Say( Li+nIncr, nCol+1000, "NOTIFICA??O", oFont0, 100 )
			nIncr += 140
			oPrn:Say( Li+nIncr, nCol+0040, "Ilmo Sr.(a) " + ALLTRIM((cAliasTMP)->ZLA_NOMPRD), oFont6, 100 )						
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0080, "Vimos por interm?dio desta, informa-lo que na data de hoje, do total de "+TRANSFORM((cAliasTMP)->ZLA_QTDE,"@E 9999") + " litros de leite remetidos", oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "por Vossa Senhoria, foi detectado na an?lise de Crioscopia Eletr?nica um percentual de " + TRANSFORM((cAliasTMP)->ZLA_PERC, "@E 999.99") +" %" , oFont4, 100 )
			nIncr += 050
			nIMPRESSAO := NoRound(((cAliasTMP)->ZLA_PERC*(cAliasTMP)->ZLA_QTDE)/100,0)
			If nIMPRESSAO == 0
				nIMPRESSAO := 1
			EndIf
			oPrn:Say( Li+nIncr, nCol+0040, "de ?gua, que equivale a " + TRANSFORM(nIMPRESSAO , "@E 9999") + " litros de ?gua." , oFont4, 100 )
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0080, "Portanto, encontrando-se o leite nestas condi??es, somos obrigados a NOTIFICA-LO e tamb?m " , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "a realizar o DESCONTO da quantidade de ?gua detectada, da quantidade total de leite entregue " , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "por Vossa Senhoria, como prev? o RIISPOA (Regulamento de Inspe??o Industrial e Sanit?ria de" , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0040, "Produtos de Origem Animal)." , oFont4, 100 )
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0500, ALLTRIM(SM0->M0_CIDCOB) + ", " + cValtoChar(day(ddatabase)) + " DE " + UPPER(mesextenso(month(ddatabase))) + " DE " + cValtoChar(year(ddatabase)) , oFont4, 100 )
			nIncr += 100
			oPrn:Say( Li+nIncr, nCol+0560, Replicate("_",22) , oFont4, 100 )
			nIncr += 050
			oPrn:Say( Li+nIncr, nCol+0580, "Controle de Qualidade" , oFont4, 100 )
			nIncr += 140
			oPrn:Say( Li+nIncr, nCol+0040, "OBS- Estamos certos que poderemos contar com sua colabora??o para regulariza??o deste problema." , oFont4, 100 )
			nIncr += 100                                                                                                  
			oPrn:Say( Li+nIncr, nCol+0040, "RESULTADOS DA AN?LISE:" , oFont5, 100 )
			oPrn:Say( Li+nIncr, nCol+1200, "PAR?METROS:" , oFont5, 100 )
			nIncr += 070
			oPrn:Say( Li+nIncr, nCol+0040, "AN?LISE N?MERO: " + ALLTRIM((cAliasTMP)->ZLA_NUMERO) , oFont4, 100 )
			oPrn:Say( Li+nIncr, nCol+1200, "DATA AN?LISE: " + dtoc(stod((cAliasTMP)->ZLA_DATA)) , oFont4, 100 )
			nIncr += 090      
			
			If (cAliasTMP)->ZLA_ALIZAR != 0
				oPrn:Say( Li+nIncr, nCol+0040, "ALIZAROL: " + TRANSFORM((cAliasTMP)->ZLA_ALIZAR	,  "@E 999999") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "ALIZAROL: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "ALIZAROL M?NIMO: " + TRANSFORM(nALZ_MIN,"@E 999999") , oFont4, 100 )
			nIncr += 055			                                                                                                              
			
			If (cAliasTMP)->ZLA_ACID != 0
				oPrn:Say( Li+nIncr, nCol+0040, "ACIDEZ: " + TRANSFORM((cAliasTMP)->ZLA_ACID	,  "@E 999999") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "ACIDEZ: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "ACIDEZ: " + TRANSFORM(nACD_MIN,"@E 999999") + " /"+TRANSFORM(nACD_MAX,"@E 999999") , oFont4, 100 )
			nIncr += 055			                                                                                                              

			If (cAliasTMP)->ZLA_CRIO != 0
				oPrn:Say( Li+nIncr, nCol+0040, "CRIOSCOPIA: " + TRANSFORM((cAliasTMP)->ZLA_CRIO	,  "@E 999999") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "CRIOSCOPIA: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "CRIOSCOPIA: " + TRANSFORM(nCRI_MIN,"@E 999999")+" /"+TRANSFORM(nCRI_MAX,"@E 9999999") , oFont4, 100 )
			nIncr += 055

			If (cAliasTMP)->ZLA_GORD != 0
				oPrn:Say( Li+nIncr, nCol+0040, "GORDURA: " + TRANSFORM((cAliasTMP)->ZLA_GORD	,  "@E 999.99") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "GORDURA: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "GORDURA M?NIMO: " + TRANSFORM(nGORD_MIN, "@E 999.99") , oFont4, 100 )
			nIncr += 055
			
			If (cAliasTMP)->ZLA_DENS != 0
				oPrn:Say( Li+nIncr, nCol+0040, "DENSIDADE: " + TRANSFORM((cAliasTMP)->ZLA_DENS	,  "@E 999.99") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "DENSIDADE: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "DENSIDADE: " + TRANSFORM(nDEN_MIN,"@E 99.999")+" /"+TRANSFORM(nDEN_MAX,"@E 99.999") , oFont4, 100 )
			nIncr += 055			

			If (cAliasTMP)->ZLA_EST != 0
				oPrn:Say( Li+nIncr, nCol+0040, "EST: " + TRANSFORM((cAliasTMP)->ZLA_EST	,  "@E 999.99") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "EST: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "EST M?NIMO: " + TRANSFORM(nEST_MIN,"@E 999.99") , oFont4, 100 )
			nIncr += 055
			
			If (cAliasTMP)->ZLA_ESD != 0
				oPrn:Say( Li+nIncr, nCol+0040, "ESD: " + TRANSFORM((cAliasTMP)->ZLA_ESD	,  "@E 999.99") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "ESD: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "ESD M?NIMO: " + TRANSFORM(nESD_MIN,"@E 999.99") , oFont4, 100 )
			nIncr += 055
						
			If (cAliasTMP)->ZLA_REDUTA != 0
				oPrn:Say( Li+nIncr, nCol+0040, "REDUTAZE: " + TRANSFORM((cAliasTMP)->ZLA_REDUTA	,  "@E 999999") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "REDUTAZE: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			oPrn:Say( Li+nIncr, nCol+1200, "REDUTAZE M?NIMO: " + TRANSFORM(nRED_MIN,"@E 999999") , oFont4, 100 )
			nIncr += 055
			
			If !Empty((cAliasTMP)->ZLA_HIDSOD)
				oPrn:Say( Li+nIncr, nCol+0040, "HID.S?DIO: " + IIF((cAliasTMP)->ZLA_HIDSOD=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "HID.S?DIO: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055
			
			If !Empty((cAliasTMP)->ZLA_BICARB)
				oPrn:Say( Li+nIncr, nCol+0040, "BICARBONATO: " + IIF((cAliasTMP)->ZLA_BICARB=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "BICARBONATO: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055

			If !Empty((cAliasTMP)->ZLA_CLORET)
				oPrn:Say( Li+nIncr, nCol+0040, "CLORETOS: " + IIF((cAliasTMP)->ZLA_CLORET=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "CLORETOS: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055

			If !Empty((cAliasTMP)->ZLA_BORATO)
				oPrn:Say( Li+nIncr, nCol+0040, "BORATOS: " + IIF((cAliasTMP)->ZLA_BORATO=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "BORATOS: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055						

			If !Empty((cAliasTMP)->ZLA_PERHID)
				oPrn:Say( Li+nIncr, nCol+0040, "PER.HIDROG?NIO: " + IIF((cAliasTMP)->ZLA_PERHID=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "PER.HIDROG?NIO: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055
			
			If !Empty((cAliasTMP)->ZLA_FORMOL)
				oPrn:Say( Li+nIncr, nCol+0040, "FORMOL: " + IIF((cAliasTMP)->ZLA_FORMOL=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "FORMOL: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055
			
			If !Empty((cAliasTMP)->ZLA_SACARO)
				oPrn:Say( Li+nIncr, nCol+0040, "SACAROSE: " + IIF((cAliasTMP)->ZLA_SACARO=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "SACAROSE: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055
									
			If !Empty((cAliasTMP)->ZLA_AMIDO)
				oPrn:Say( Li+nIncr, nCol+0040, "AMIDO: " + IIF((cAliasTMP)->ZLA_AMIDO=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "AMIDO: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055

			If (cAliasTMP)->ZLA_PROT != 0
				oPrn:Say( Li+nIncr, nCol+0040, "PROTE?NA: " + TRANSFORM((cAliasTMP)->ZLA_PROT 	,  "@E 999.99") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "PROTE?NA: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055

			If (cAliasTMP)->ZLA_LACT != 0
				oPrn:Say( Li+nIncr, nCol+0040, "LACTOSE: " + TRANSFORM((cAliasTMP)->ZLA_LACT 	,  "@E 999.99") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "LACTOSE: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055

			If !Empty((cAliasTMP)->ZLA_RECONS)
				oPrn:Say( Li+nIncr, nCol+0040, "RECONSTITUINTES: " + IIF((cAliasTMP)->ZLA_RECONS=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "RECONSTITUINTES: N?O ANALISADO." , oFont4, 100 )
			EndIf			
			nIncr += 055

			If !Empty((cAliasTMP)->ZLA_NEUTRA)
				oPrn:Say( Li+nIncr, nCol+0040, "NEUTRALIZANTES: " + IIF((cAliasTMP)->ZLA_NEUTRA=="P","POSITIVO","NEGATIVO") , oFont4, 100 )
			Else                                                                                                               
				oPrn:Say( Li+nIncr, nCol+0040, "NEUTRALIZANTES: N?O ANALISADO." , oFont4, 100 )
			EndIf			
				
			oPrn:EndPage() 
			        		   
		EndIf
		
		(cAliasTMP)->(dbSkip())
				
	EndDo
    
	(cAliasTMP)->(dbCloseArea())
	
	oPrn:Preview()

	//??????????????????????????????????????????????????????????????Ŀ
	//? Se em disco, desvia para Spool                               ?
	//????????????????????????????????????????????????????????????????
	
	If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
		Set Printer To
		Commit
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return
     

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?AJUSTASX1  ?Autor  ?Rafael Parma       ? Data ?  19/11/09   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Fun??o utilizada para verificar/criar no ambiente o grupo   ???
???          ?de perguntas.                                               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS LATICINIO                                             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
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
aHelp12 := {}

	//???????????????????????????????????????????????????????
	//?Defini??o dos itens do grupo de perguntas a ser criado?
	//???????????????????????????????????????????????????????
	aAdd(aRegs,{cPerg,"01","Data An?lise De    ?","Data An?lise De    ?","Data An?lise De    ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0901."})
	aAdd(aRegs,{cPerg,"02","Data An?lise At?   ?","Data An?lise At?   ?","Data An?lise At?   ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0902."})	
	aAdd(aRegs,{cPerg,"03","C?digo An?lise De  ?","C?digo An?lise De  ?","C?digo An?lise De  ?","mv_ch3","C",TAMSX3("ZLA_NUMERO")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","ZLA000","","",".LTREL0903."})
	aAdd(aRegs,{cPerg,"04","C?digo An?lise At? ?","C?digo An?lise At? ?","C?digo An?lise At? ?","mv_ch4","C",TAMSX3("ZLA_NUMERO")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","ZLA000","","",".LTREL0904."})	
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2ZL2","","",".LTREL0905."})
	aAdd(aRegs,{cPerg,"06","Produtor At?       ?","Produtor At?       ?","Produtor At?       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2ZL2","","",".LTREL0906."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0907."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor At?  ?","Loja Produtor At?  ?","Loja Produtor At?  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0908."})
	aAdd(aRegs,{cPerg,"09","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch9","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0909."})
	aAdd(aRegs,{cPerg,"10","Linha At?          ?","Linha At?          ?","Linha At?          ?","mv_cha","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0910."})
	aAdd(aRegs,{cPerg,"11","Filtrar Por        ?","Filtrar Por        ?","Filtrar Por        ?","mv_chb","N",01,0,1,"C","","mv_par11","Data An?lise","Data An?lise","Data An?lise","","","C?digo An?lise","C?digo An?lise","C?digo An?lise","","","Produtor","Produtor","Produtor","","","Linha","Linha","Linha","","","","","","","","","","","","",".LTREL0911."})
	aAdd(aRegs,{cPerg,"12","Imp. Todas An?lises?","Imp. Todas An?lises?","Imp. Todas An?lises?","mv_chc","N",01,0,1,"C","","mv_par12","N?o","N?o","N?o","","","Sim","Sim","Sim","","","","","","","","","","","","","","","","","","","","","","",".LTREL0912."})
	
	//???????????????????????????????????????????????????Ŀ
	//?Montagem do Help de cada item do Grupo de Perguntas?
	//?????????????????????????????????????????????????????
	AADD( aHelp01, "Informe a data inicial da an?lise        " )       
	AADD( aHelp01, "a ser impressa.                          " )       
	AADD( aHelp02, "Informe a data final da an?lise          " )       
	AADD( aHelp02, "a ser impressa.                          " )	
	AADD( aHelp03, "Informe o c?digo inicial da an?lise      " )       
	AADD( aHelp03, "a ser impressa.                          " )       
	AADD( aHelp04, "Informe o c?digo final da an?lise        " )       
	AADD( aHelp04, "a ser impressa.                          " )
	AADD( aHelp05, "Informe o c?digo inicial do produtor     " )       
	AADD( aHelp05, "a ser impresso.                          " )       
	AADD( aHelp06, "Informe o c?digo final do produtor       " )       
	AADD( aHelp06, "a ser impresso.                          " )       
	AADD( aHelp07, "Informe a loja inicial do produtor       " )       
	AADD( aHelp07, "a ser impresso.                          " )       
	AADD( aHelp08, "Informe a loja final do produtor         " )       
	AADD( aHelp08, "a ser impresso.                          " )      
	AADD( aHelp09, "Informe o n?mero inicial da linha        " )       
	AADD( aHelp09, "a ser impressa.                          " )       
	AADD( aHelp10, "Informe o n?mero final da linha          " )       
	AADD( aHelp10, "a ser impressa.                          " )       
	AADD( aHelp11, "Filtrar intervalo por data an?lise,      " )       
	AADD( aHelp11, "protocolo, produtor/loja ou linha.       " )  
	AADD( aHelp12, "Imprimir resultado de todas as           " )       
	AADD( aHelp12, "an?lises?                                " )   		
	
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
	
	//?????????????????????????????????????????????Ŀ
	//?Atualiza o Help dos campos no arquivo de Help?
	//???????????????????????????????????????????????
	PutSX1Help("P.LTREL0901.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0902.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL0903.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL0904.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL0905.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL0906.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL0907.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL0908.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL0909.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL0910.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL0911.",aHelp11,aHelp11,aHelp11)	
	PutSX1Help("P.LTREL0912.",aHelp12,aHelp12,aHelp12)
					
Return Nil
