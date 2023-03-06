#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL014 ºAutor  ³Rafael Parma         º Data ³  18/06/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão de recibo de débito financeiro.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
  
*-----------------------*
User Function LTREL014()
*-----------------------*


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RECIBO DE DÉBITO"                   
Local cPict          := ""
Local titulo         := "RECIBO DE DÉBITO"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00014"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL014"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL014"
Public STRING_NULL   := ""


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamado rotina de verificação/criação do grupo de perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString := "SE1"
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
±±ºFun‡„o    ³Report    º Autor ³Rafael Parma        º Data ³  18/06/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão de recibo de débito financeiro.         º±±
±±º          ³                                                            º±±
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


Private cDlgTitle := "Filtrar Títulos"
Private aCampos   := {}
Private cMarca    := GetMark()
Private lInverte  := .F.
Private oDlg


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
    
	If mv_par10 == 1

		cQuery := "SELECT 														" + hEnter
		cQuery += "         SE1.E1_OK,	 										" + hEnter
		cQuery += "         SE1.E1_FILIAL, 										" + hEnter
		cQuery += "         SE1.E1_PREFIXO,										" + hEnter
		cQuery += "			SE1.E1_NUM,    										" + hEnter
		cQuery += "			SE1.E1_PARCELA,										" + hEnter		
		cQuery += "			SE1.E1_TIPO,   										" + hEnter
		cQuery += "			SE1.E1_CLIENTE,										" + hEnter
		cQuery += "			SE1.E1_LOJA,   										" + hEnter  
		cQuery += "			SE1.E1_NOMCLI, 										" + hEnter  
		cQuery += "			SE1.E1_EMISSAO,										" + hEnter  
		cQuery += "			SE1.E1_VENCTO, 										" + hEnter  
		cQuery += "			SE1.E1_X_LINHA,										" + hEnter  
		cQuery += "			SE1.E1_SALDO 										" + hEnter  
		
		cQuery += "FROM " + RetSqlName("SE1") + " SE1							" + hEnter
		
		cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1	ON					" + hEnter		
		
		cQuery += "			SE1.E1_CLIENTE = SA1.A1_COD						 	" + hEnter
		cQuery += "AND  	SE1.E1_LOJA    = SA1.A1_LOJA					 	" + hEnter	
		
		cQuery += "WHERE    SE1.E1_FILIAL  = '" + xFilial("SE1") + "' 			" + hEnter
		
		cQuery += "AND		SE1.E1_VENCTO  BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
		cQuery += "AND             		           '" + dtos(mv_par02) + "' 	" + hEnter	
	
		cQuery += "AND		SA1.A1_X_FORN  BETWEEN '" + mv_par03 + "' 			" + hEnter
		cQuery += "AND             		           '" + mv_par04 + "' 			" + hEnter	
	
		cQuery += "AND		SA1.A1_X_LOJF  BETWEEN '" + mv_par05 + "' 			" + hEnter
		cQuery += "AND             		           '" + mv_par06 + "' 			" + hEnter	
	
		cQuery += "AND		SE1.E1_X_LINHA BETWEEN '" + mv_par07 + "' 			" + hEnter
		cQuery += "AND             		           '" + mv_par08 + "' 			" + hEnter	
	
		cQuery += "AND 		SE1.E1_SALDO      >  0   							" + hEnter
		cQuery += "AND 		SA1.D_E_L_E_T_    != '*' 							" + hEnter
		cQuery += "AND 		SE1.D_E_L_E_T_    != '*' 							" + hEnter
	 	
	 	cQuery += "ORDER BY                 			 						" + hEnter		
		cQuery += "			SE1.E1_X_LINHA,										" + hEnter  
	
		If mv_par09 == 1
			cQuery += "		SE1.E1_CLIENTE										" + hEnter
	    Else
			cQuery += "		SE1.E1_NOMCLI 										" + hEnter      	    	
	    EndIf
		
		If (Select(cAliasTMP) <> 0)
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbCloseArea())
		Endif
	
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
		MemoWrite("LTREL014.TXT",cQuery)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria arquivos temporarios                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		dbSelectArea("SE1")
		aStruct := dbStruct()
	
		cArqTrab := CriaTrab(aStruct, .T.)
		dbUseArea(.T.,, cArqTrab ,"_SE1", .F.,.F. )
		dbSelectArea("_SE1")
		If mv_par09 == 1
			Index on E1_FILIAL+E1_X_LINHA+E1_CLIENTE to &cArqTrab
		Else
			Index on E1_FILIAL+E1_X_LINHA+E1_NOMCLI  to &cArqTrab
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza temporarios                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		While (cAliasTMP)->(!EOF())
		    
		    dbSelectArea("_SE1")
		    RecLock("_SE1",.T.)
		    For x := 1 To Len(aStruct)
		       //If ALLTRIM(aStruct[x,1]) $ "E1_OK/E1_FILIAL/E1_PREFIXO/E1_NUM/E1_PARCELA/E1_TIPO/E1_CLIENTE/E1_LOJA/E1_NOMCLI/E1_EMISSAO/E1_VENCTO/E1_X_LINHA/E1_SALDO"
		       If ALLTRIM(aStruct[x,1]) $ "E1_OK/E1_FILIAL/E1_PREFIXO/E1_NUM/E1_PARCELA/E1_TIPO/E1_CLIENTE/E1_LOJA/E1_NOMCLI/E1_X_LINHA/E1_SALDO"
			       _nPosic := FieldPos(aStruct[x,1])
			       _cCampo := (cAliasTMP)+"->"+aStruct[x,1]
			       _cDados := &_cCampo
			       _SE1->(FieldPut(_nPosic,_cDados))
			   EndIf
			Next
		    _SE1->E1_OK := "  "
		    MsUnLock("_SE1")
			
			(cAliasTMP)->(dbSkip())	
		Enddo
		
		(cAliasTMP)->(dbCloseArea())
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Campos para mostrar no BROWSE padrao                      ³
		//³ Necessario quando usando um arquivo qualquer (sem o SX3)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		AADD(aCampos,{"E1_OK"   	,"" ," "          ," " })
		AADD(aCampos,{"E1_PREFIXO"  ,"" ,"Prefixo"    ," " })
		AADD(aCampos,{"E1_NUM"    	,"" ,"Número"     ," " })
		AADD(aCampos,{"E1_PARCELA" 	,"" ,"Parcela"    ," " })
		AADD(aCampos,{"E1_TIPO"    	,"" ,"Tipo"       ," " })
		AADD(aCampos,{"E1_CLIENTE" 	,"" ,"Cliente"    ," " })
		AADD(aCampos,{"E1_LOJA" 	,"" ,"Loja"       ," " })
		AADD(aCampos,{"E1_NOMCLI"  	,"" ,"Nome"       ," " })
		//AADD(aCampos,{"E1_EMISSAO" 	,"" ,"Emissão"    ," " })
		//AADD(aCampos,{"E1_VENCTO"  	,"" ,"Vencimento" ," " })
		AADD(aCampos,{"E1_X_LINHA" 	,"" ,"Linha"      ," " })
		AADD(aCampos,{"E1_SALDO"   	,"" ,"Saldo"      ," " })
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Dialogo para Usuario Selecionar os Titulos Filtrados no arquivo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		dbSelectArea("_SE1")
		dbGoTop()
	
		DEFINE MSDIALOG oDlg TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL
		
		oMark := MsSelect():New("_SE1","E1_OK",,aCampos,@lInverte,@cMarca,{1,1,170,350})
	  
		@ 180,300 BMPBUTTON TYPE 1 ACTION Close(oDlg) 
	
		ObjectMethod(oMark:oBrowse,"Refresh()")
		oMark:bMark := {|| fRegSel(oMark, cMarca, oDlg)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := {|| fMarkAll(oMark, cMarca, oDlg)}
	
	
		ACTIVATE MSDIALOG oDlg CENTERED		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento de impressão..                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oPrn:SetPortrait()
		oPrn:Setup()

		dbSelectArea("_SE1")
		dbGoTop()
		While _SE1->(!EOF())
	        
	        If !Empty( _SE1->E1_OK )
	            
	        	dbSelectArea("SA1")
	        	dbSetOrder(1)
	        	dbSeek( xFilial("SA1") + _SE1->E1_CLIENTE + _SE1->E1_LOJA )
	        
				If nPag == 1
		
					Li    := 50
					nCol  := 50
					nIncr := 0
			
					oPrn:StartPage()
					oPrn:SayBitmap( Li+000, nCol+000, cBitMap , 300, 90 )
			
					//SUPERIOR
					oPrn:Line( 0020, 0030,0020, 2300 )
					//ESQUERDO
					oPrn:Line( 0020, 0030,1040, 0030 )
					//DIREITO
					oPrn:Line( 0020, 2300,1040, 2300 )
					//INFERIOR
					oPrn:Line( 1040, 0030,1040, 2300 )
					
					oPrn:Box( 0030, 0040, 0200, 2290 )			
					oPrn:Box( 0210, 0040, 0400, 2290 )
					oPrn:Box( 0410, 0040, 1030, 2290 )
			    	
			    	nPag := 2
			    
				ElseIf nPag == 2

					Li    := 1150
					nCol  := 50
					nIncr := 0		

					oPrn:SayBitmap( Li+000, nCol+000, cBitMap , 300, 90 )
					//SUPERIOR
					oPrn:Line( 1120, 0030,1120, 2300 )
					//ESQUERDO
					oPrn:Line( 1120, 0030,2140, 0030 )
					//DIREITO
					oPrn:Line( 1120, 2300,2140, 2300 )
					//INFERIOR
					oPrn:Line( 2140, 0030,2140, 2300 )
					
					oPrn:Box( 1130, 0040, 1300, 2290 )			
					oPrn:Box( 1310, 0040, 1500, 2290 )
					oPrn:Box( 1510, 0040, 2130, 2290 )
					
					nPag := 3
												
				Else
					
					Li    := 2250
					nCol  := 50
					nIncr := 0		

					oPrn:SayBitmap( Li+000, nCol+000, cBitMap , 300, 90 )
					//SUPERIOR
					oPrn:Line( 2220, 0030,2220, 2300 )
					//ESQUERDO
					oPrn:Line( 2220, 0030,3240, 0030 )
					//DIREITO
					oPrn:Line( 2220, 2300,3240, 2300 )
					//INFERIOR
					oPrn:Line( 3240, 0030,3240, 2300 )
					
					oPrn:Box( 2230, 0040, 2400, 2290 )			
					oPrn:Box( 2410, 0040, 2600, 2290 )
					oPrn:Box( 2610, 0040, 3230, 2290 )
				
					nPag := 1
				
				EndIf
					
				nIncr += 030
				oPrn:Say( Li+nIncr, nCol+0880, SM0->M0_NOMECOM, oFont6, 100 )
				nIncr += 050
				oPrn:Say( Li+nIncr, nCol+0985, "RECIBO DE DÉBITO", oFont6, 100 )
				nIncr += 040
				
				nIncr += 120
				oPrn:Say( Li+nIncr, nCol+0050, "VALOR: R$ " + TRANSFORM(_SE1->E1_SALDO,"@E 999,999.99") + " - ("+ALLTRIM(UPPER(EXTENSO(_SE1->E1_SALDO)))+")", oFont5, 100 )
				nIncr += 060
				oPrn:Say( Li+nIncr, nCol+0050, "PREFIXO/TÍTULO: "+_SE1->E1_PREFIXO+"/"+_SE1->E1_NUM, oFont2, 100 )		
				
				nIncr += 120
				oPrn:Say( Li+nIncr, nCol+0050, "Referente ao saldo devedor em "  + dtoc(mv_par14), oFont5, 100 )
				nIncr += 060
				oPrn:Say( Li+nIncr, nCol+0050, "Será descontado no pagamento do leite de " + dtoc(mv_par15), oFont5, 100 )
				
				nIncr += 100
				oPrn:Say( Li+nIncr, nCol+0050, "Produtor: " + SA1->A1_X_FORN +"/"+SA1->A1_X_LOJF+"-"+SubSTR(_SE1->E1_NOMCLI,1,40), oFont5, 100 )
				
				nIncr += 050
				
				If !Empty(_SE1->E1_X_LINHA)
				
					oPrn:Say( Li+nIncr, nCol+0050, "Linha: " + _SE1->E1_X_LINHA +"-"+ Posicione("ZL0",1,xFilial("ZL0")+ _SE1->E1_X_LINHA,"ZL0_DESC"), oFont5, 100 )
				
				EndIf
		
				nIncr += 120
				oPrn:Say( Li+nIncr, nCol+0650, ALLTRIM(SM0->M0_CIDCOB) + ", " + cValtoChar(day(mv_par14)) + " DE " + UPPER(mesextenso(month(mv_par14))) + " DE " + cValtoChar(year(mv_par14)) , oFont6, 100 )
				nIncr += 100
				oPrn:Say( Li+nIncr, nCol+0710, Replicate("_",22) , oFont6, 100 )
				
		
				If nPag == 1
					oPrn:EndPage() 
				EndIf
			
			EndIf
			
			IncProc()	        		
			_SE1->(dbSkip())
					
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Elimina arquivos temporarios                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		    
		dbSelectArea("_SE1")
		dbCloseArea("_SE1")
		FErase(cArqTrab+OrdBagExt())
		FErase(cArqTrab+".*") 		
		
		oPrn:Preview()	
		
	Else
	    
	    // RECIBO AVULSO
	    
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+mv_par11+mv_par12)

		Li    := 50
		nCol  := 50
		nIncr := 0

		oPrn:StartPage()
		oPrn:SayBitmap( Li+000, nCol+000, cBitMap , 300, 90 )

		//SUPERIOR
		oPrn:Line( 0020, 0030,0020, 2300 )
		//ESQUERDO
		oPrn:Line( 0020, 0030,1040, 0030 )
		//DIREITO
		oPrn:Line( 0020, 2300,1040, 2300 )
		//INFERIOR
		oPrn:Line( 1040, 0030,1040, 2300 )
		
		oPrn:Box( 0030, 0040, 0200, 2290 )			
		oPrn:Box( 0210, 0040, 0400, 2290 )
		oPrn:Box( 0410, 0040, 1030, 2290 )
    	
			
		nIncr += 030
		oPrn:Say( Li+nIncr, nCol+0880, SM0->M0_NOMECOM, oFont6, 100 )
		nIncr += 050
		oPrn:Say( Li+nIncr, nCol+0985, "RECIBO DE DÉBITO", oFont6, 100 )
		nIncr += 040
		
		nIncr += 120
		oPrn:Say( Li+nIncr, nCol+0050, "VALOR: R$ " + TRANSFORM(mv_par13,"@E 999,999.99") + " - " + UPPER(EXTENSO(mv_par13)), oFont5, 100 )
		nIncr += 060
		oPrn:Say( Li+nIncr, nCol+0050, "AVULSO", oFont2, 100 )		
		
		nIncr += 120
		oPrn:Say( Li+nIncr, nCol+0050, "Referente ao saldo devedor em "  + dtoc(mv_par14), oFont5, 100 )
		nIncr += 060
		oPrn:Say( Li+nIncr, nCol+0050, "Será descontado no pagamento do leite de " + dtoc(mv_par15), oFont5, 100 )
		
		nIncr += 100
		oPrn:Say( Li+nIncr, nCol+0050, "Produtor: "+SA2->A2_COD+"/"+SA2->A2_LOJA+"-"+SubSTR(SA2->A2_NOME,1,40), oFont5, 100 )
		
		nIncr += 050
		
		If !Empty(SA2->A2_X_LINHA)
		
			oPrn:Say( Li+nIncr, nCol+0050, "Linha: " + SA2->A2_X_LINHA +"-"+ Posicione("ZL0",1,xFilial("ZL0")+ SA2->A2_X_LINHA,"ZL0_DESC"), oFont5, 100 )
		
		EndIf

		nIncr += 120
		oPrn:Say( Li+nIncr, nCol+0650, ALLTRIM(SM0->M0_CIDCOB) + ", " + cValtoChar(day(mv_par14)) + " DE " + UPPER(mesextenso(month(mv_par14))) + " DE " + cValtoChar(year(mv_par14)) , oFont6, 100 )
		nIncr += 100
		oPrn:Say( Li+nIncr, nCol+0710, Replicate("_",22) , oFont6, 100 )
		
			
		oPrn:EndPage()
		oPrn:Preview() 

	
	EndIf
	
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
 
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*--------------------------------------------*
Static Function fRegSel(oMark, cMarca, oDlg)
*--------------------------------------------*

	If Marked("E1_OK")
		RecLock("_SE1",.F.)
		Replace _SE1->E1_OK With cMarca
		MsUnlock()
	Else
		RecLock("_SE1",.F.)
		Replace _SE1->E1_OK With "  "
		MsUnlock()
	Endif
	
	oMark:oBrowse:Refresh(.t.)
	oDlg:Refresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marcador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*---------------------------------------------*
Static Function fMarkAll(oMark, cMarca, oDlg)
*---------------------------------------------*
Local nREC := Recno()    
    
	dbGoTop()
	While !EOF()
		RecLock("_SE1",.F.)
		If Empty(_SE1->E1_OK)
			Replace _SE1->E1_OK With cMarca
		Else
			Replace _SE1->E1_OK With "  "
		Endif
		MsUnlock()
		dbSkip()
	EndDo  
	
	dbGoTo(nREC)
	oMark:oBrowse:Refresh(.t.)
	oDlg:Refresh()

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
aHelp12 := {}
aHelp13 := {}
aHelp14 := {}
aHelp15 := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Vencimento De      ?","Vencimento De      ?","Vencimento De      ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1401."})
	aAdd(aRegs,{cPerg,"02","Vencimento Até     ?","Vencimento Até     ?","Vencimento Até     ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1402."})	
	aAdd(aRegs,{cPerg,"03","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch3","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",".LTREL1403."})
	aAdd(aRegs,{cPerg,"04","Produtor Até       ?","Produtor Até       ?","Produtor Até       ?","mv_ch4","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",".LTREL1404."})
	aAdd(aRegs,{cPerg,"05","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch5","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1405."})
	aAdd(aRegs,{cPerg,"06","Loja Produtor Até  ?","Loja Produtor Até  ?","Loja Produtor Até  ?","mv_ch6","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1406."})
	aAdd(aRegs,{cPerg,"07","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch7","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1407."})
	aAdd(aRegs,{cPerg,"08","Linha Até          ?","Linha Até          ?","Linha Até          ?","mv_ch8","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1408."})
	aAdd(aRegs,{cPerg,"09","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_ch9","N",01,0,1,"C","","mv_par09","Código","Código","Código","","","Nome","Nome","Nome","","","","","","","","","","","","","","","","","","","","","","",".LTREL1409."})
	aAdd(aRegs,{cPerg,"10","Imprimir Recibo De ?","Imprimir Recibo De ?","Imprimir Recibo De ?","mv_cha","N",01,0,1,"C","","mv_par10","Títulos","Títulos","Títulos","","","Avulso","Avulso","Avulso","","","","","","","","","","","","","","","","","","","","","","",".LTREL1410."})
	aAdd(aRegs,{cPerg,"11","Produtor Rec.Avulso?","Produtor Rec.Avulso?","Produtor Rec.Avulso?","mv_chb","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2ZL1","","",".LTREL1411."})
	aAdd(aRegs,{cPerg,"12","Loja Rec. Avulso   ?","Loja Rec. Avulso   ?","Loja Rec. Avulso   ?","mv_chc","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1412."})
	aAdd(aRegs,{cPerg,"13","Valor Rec. Avulso  ?","Valor Rec. Avulso  ?","Valor Rec. Avulso  ?","mv_chd","N",10,2,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",".LTREL1413."})
	aAdd(aRegs,{cPerg,"14","Recibo Referente   ?","Recibo Referente   ?","Recibo Referente   ?","mv_che","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1414."})
	aAdd(aRegs,{cPerg,"15","Recibo Descontato  ?","Recibo Descontato  ?","Recibo Descontato  ?","mv_chf","D",08,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1415."})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe a data inicial de vencimento     " )       
	AADD( aHelp01, "para filtro de títulos a receber.        " )       
	AADD( aHelp02, "Informe a data final de vencimento       " )       
	AADD( aHelp02, "para filtro de títulos a receber.        " )       
	AADD( aHelp03, "Informe o código inicial do produtor     " )       
	AADD( aHelp03, "para filtro de títulos a receber.        " )       
	AADD( aHelp04, "Informe o código final do produtor       " )       
	AADD( aHelp04, "para filtro de títulos a receber.        " )       
	AADD( aHelp05, "Informe a loja inicial do produtor       " )       
	AADD( aHelp05, "para filtro de títulos a receber.        " )       
	AADD( aHelp06, "Informe a loja final do produtor         " )       
	AADD( aHelp06, "para filtro de títulos a receber.        " )       
	AADD( aHelp07, "Informe o número inicial da linha        " )       
	AADD( aHelp07, "para filtro de títulos a receber.        " )       
	AADD( aHelp08, "Informe o número final da linha          " )       
	AADD( aHelp08, "para filtro de títulos a receber.        " )       
	AADD( aHelp09, "Ordenar impressão dos recibos            " )       
	AADD( aHelp09, "por código ou nome do produtor.          " )  

	AADD( aHelp10, "Imprimir recibo sobre títulos em aberto  " )       
	AADD( aHelp10, "do financeiro ou recibo avulso.          " )  
	
	AADD( aHelp11, "Informe o código do produtor para        " )       
	AADD( aHelp11, "impressão do recibo avulso.              " )  
	AADD( aHelp12, "Informe a loja do produtor para          " )       
	AADD( aHelp12, "impressão do recibo avulso.              " )  
	AADD( aHelp13, "Informe o valor que será impresso        " )       
	AADD( aHelp13, "no recibo avulso.                        " )  
	AADD( aHelp14, "Informe a data que se refere o           " )       
	AADD( aHelp14, "recibo.                                  " )  
	AADD( aHelp15, "Informe a data em que será realizado     " )       
	AADD( aHelp15, "o desconto do recibo.                    " )  
	
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
	PutSX1Help("P.LTREL1401.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL1402.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL1403.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL1404.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL1405.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL1406.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL1407.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL1408.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL1409.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL1410.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL1411.",aHelp11,aHelp11,aHelp11)		
	PutSX1Help("P.LTREL1412.",aHelp12,aHelp12,aHelp12)		
	PutSX1Help("P.LTREL1413.",aHelp13,aHelp13,aHelp13)		
	PutSX1Help("P.LTREL1414.",aHelp14,aHelp14,aHelp14)		
	PutSX1Help("P.LTREL1415.",aHelp15,aHelp15,aHelp15)
					
Return Nil