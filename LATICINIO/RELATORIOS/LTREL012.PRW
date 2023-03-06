#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL012 ºAutor  ³Rafael Parma         º Data ³  25/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relação de pagamentos de transportadores.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*------------------------*
User Function LTREL012()
*------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELAÇÃO DE PAGAMENTO DE TRANSPORTADORES"
Local cPict          := ""
Local titulo         := "RELAÇÃO DE PAGAMENTO DE TRANSPORTADORES"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := "" 
Local imprime        := .T.
Local aOrd           := {}         

Private cPerg        := "LTREL00012"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL012"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL012"

Private nTGQTDE     := 0
Private nTGPLAT    := 0
Private nTGPLAP    := 0
Private nTGDIVR      := 0
Private nTGPROD     := 0
Private nTGCRED     := 0
Private nTGDESP     := 0
Private nTGDIVN     := 0
Private nTGDIVP     := 0
Private nTGLIQD      := 0

Public DATE_NULL     := ctod("  /  /  ")
Public STRING_NULL   := ""      


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamado rotina de verificação/criação do grupo de perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString := "ZL5"
	AjustaSX1()                                                 
	Pergunte(cPerg, .F.) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| ReportTrp(@Cabec1,@Cabec2,Titulo,@nLin) },Titulo)	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ReportPrd º Autor ³Rafael Parma        º Data ³  25/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relação de pagamentos de transportadores.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS LATICINIO	                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportTrp(Cabec1,Cabec2,Titulo,nLin)

Local nCol         := 60				// coluna de impressão
Local nQTD_TOTAL   := 0					// quantidade total em litros
Local nQTD_PLATF   := 0					// quantidade da plataforma 
Local nQTD_PLATP   := 0					// quantidade total da plataforma positivo
Local nQTD_PLATN   := 0					// quantidade total da plataforma negativo
Local nQTD_DIVER   := 0					// quantidade total da divergencia
Local nPRC_LITRO   := 0					// preço total dos litros  
Local nVLR_PROD    := 0					// valor total da produção   
Local nVLR_DESP    := 0					// valor total de despesas
Local nVLR_CRED    := 0					// valor total de creditos
Local nQTD_PRD     := 0					// quantidade total do produtor
Local nQTD_PRDP    := 0					// quantidade total de produtores plataforma
Local cPRODUT      := STRING_NULL		// código do produtor
Local cLOJPRD      := STRING_NULL		// loja do produtor
Local cLINHA       := STRING_NULL		// linha do produtor
Local cTRANSP      := STRING_NULL		// codigo do transportador
Local cCODIGO      := STRING_NULL		// numero sequencial da coleta
Local cAliasTMP    := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13) 
Local lSTART_DATE  := .F.
Local lEND_DATE    := .F.     
Local dCURR_DATE   := ctod("")      	// dia do registro em processamento
Local dLAST_DATE   := ctod("")			// último dia impresso
Local aDADOSDESP   := {}

Private dSTART_DATE:= ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do período
Private dEND_DATE  := dSTART_DATE		// último dia do período

	dCURR_DATE := dSTART_DATE
	dLAST_DATE := dSTART_DATE	

	If U_YIsBis(mv_par02) 
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","29","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))
    Else
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","28","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))   
    EndIf 

    Cabec1 := "LINHA      TRANSPORTADOR                                    UF     QTD LEITE  QTD FALTAS  QTD SOBRAS  DIVERGÊNCIAS       VALOR BRUTO     VALOR BONIF.    VALOR DESC.    VALOR FALTAS    VALOR SOBRAS    VALOR LIQUIDO"
    Cabec2 := "PERIODO DE: " + DTOC(dSTART_DATE) + " ATE: " + DTOC(dEND_DATE)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro dos pedidos de acordo com os parametros informados pelo usuário. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := " SELECT 																	" + hEnter
	cQuery += "			ZL5.ZL5_COD,													" + hEnter
	cQuery += "			ZL5.ZL5_LINHA,  												" + hEnter    
	cQuery += "			ZL5.ZL5_TRANSP, 												" + hEnter
	cQuery += "			ZL5.ZL5_NOMTRP, 												" + hEnter	
	cQuery += "			ZL5.ZL5_DATA,													" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,													" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,													" + hEnter  
	cQuery += "			ZL5.ZL5_TOTAL,													" + hEnter	
	cQuery += "			ZL6.ZL6_QTDE,													" + hEnter	
	cQuery += "			( SELECT SUM(ZL7.ZL7_QTDTRP-(ZL7.ZL7_QTDCRI+ZL7.ZL7_QTDFAL))	" + hEnter
	cQuery += "				FROM " + RetSQLName("ZL7") + " ZL7 							" + hEnter
	cQuery += " 			WHERE 														" + hEnter
	cQuery += " 			ZL7.ZL7_FILIAL 		= ZL5.ZL5_FILIAL			   			" + hEnter		
	cQuery += " 			AND ZL7.ZL7_DATA    = ZL5.ZL5_DATA   						" + hEnter
	cQuery += " 			AND ZL7.ZL7_TRANSP  = ZL5.ZL5_TRANSP						" + hEnter
	cQuery += " 			AND ZL7.ZL7_LINHA   = ZL5.ZL5_LINHA   	  					" + hEnter
	cQuery += " 			AND ZL7.ZL7_TPROD  != 'O'									" + hEnter		
	cQuery += " 			AND ZL7.D_E_L_E_T_ != '*' ) ZL5_PLATF						" + hEnter
	cQuery += " FROM " + RetSqlName("ZL5") + " ZL5										" + hEnter
	cQuery += " INNER JOIN " + RetSqlName("ZL6") + " ZL6   								" + hEnter
	cQuery += " ON      ZL5.ZL5_FILIAL     = ZL6.ZL6_FILIAL                  			" + hEnter		
	cQuery += " AND     ZL5.ZL5_COD        = ZL6.ZL6_COD                     			" + hEnter		
	cQuery += " WHERE   ZL5.ZL5_FILIAL     = '" + xFilial("ZL5") + "' 					" + hEnter
	cQuery += " AND 	( ZL5.ZL5_TRANSP BETWEEN '" + mv_par03       + "' 				" + hEnter
	cQuery += " AND                		    	 '" + mv_par04       + "' ) 			" + hEnter
	cQuery += " AND 	( ZL5.ZL5_LINHA  BETWEEN '" + mv_par05       + "' 				" + hEnter
	cQuery += " AND                		    	 '" + mv_par06       + "' )				" + hEnter	
	cQuery += " AND 	( ZL5.ZL5_DATA   BETWEEN '" + DTOS(dSTART_DATE) + "'			" + hEnter
	cQuery += " AND                        		 '" + DTOS(dEND_DATE)   + "' )			" + hEnter	
	cQuery += " AND 	ZL5.ZL5_STATUS     = '' 										" + hEnter
	cQuery += " AND 	ZL5.D_E_L_E_T_    != '*' 										" + hEnter
	cQuery += " AND 	ZL6.D_E_L_E_T_    != '*' 										" + hEnter
	cQuery += " ORDER BY 																" + hEnter
	cQuery += "			ZL5.ZL5_TRANSP, 												" + hEnter
	cQuery += "			ZL5.ZL5_LINHA, 													" + hEnter
	cQuery += "			ZL5.ZL5_COD,													" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT, 												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD, 												" + hEnter
	cQuery += "			ZL5.ZL5_DATA													" + hEnter	

	memowrite("LTREL012_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
   
	While (cAliasTMP)->(!EOF())
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif 
				
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Impressao do cabecalho do relatorio. . .                            ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If cTRANSP != (cAliasTMP)->ZL5_TRANSP .OR. cLINHA  != (cAliasTMP)->ZL5_LINHA

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cálculo dos totalizadores do produtor no período                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	        
	        
		    If cPRODUT != (cAliasTMP)->ZL6_PRODUT .or. cLOJPRD != (cAliasTMP)->ZL6_LOJPRD	       

		        If cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL		        	
		        	fCalcProd( mv_par08, cPRODUT, cLOJPRD, cLINHA, nQTD_PRD, @nPRC_LITRO, @nVLR_PROD )		        	
		        EndIf

		    Endif                             

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo dos totalizadores de plataforma                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿		

			If cCODIGO != (cAliasTMP)->ZL5_COD
				If cCODIGO != STRING_NULL
					If ( nQTD_PLATF - nQTD_PRDP ) >= 0
				    	nQTD_PLATP := 0
				    Else
				    	nQTD_PLATN += nQTD_PLATF - nQTD_PRDP
				    EndIf	
				    
				EndIf
				nQTD_PRDP  := 0		
			EndIf
	

			If cTRANSP != STRING_NULL .OR. cLINHA  != STRING_NULL

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Salto de página                                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			    
			    If nLin > 55
			    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    	nLin := 8   
			    EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressão das despesas                                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				
				dbSelectArea("SA4")
				dbSetOrder(1)
				dbSeek ( xFilial("SA4") + cTRANSP )		
				
				If Len(aDADOSDESP) > 0
					nPOS := aScan ( aDADOSDESP, {|x| x[1] == SA4->A4_X_FORN } )
				Else
					nPOS := 0
				EndIf
				
				If nPOS == 0
					fTotalDesp( dSTART_DATE, dEND_DATE, SA4->A4_X_FORN, SA4->A4_X_LOJF, @nVLR_DESP, @nVLR_CRED, @nLin )
					aAdd (aDADOSDESP , {SA4->A4_X_FORN, nVLR_DESP, nVLR_CRED} )
				Else
					nVLR_DESP := 0
					nVLR_CRED := 0				
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressão dos totalizadores                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

				fImpRec(cTRANSP, cLINHA, nVLR_PROD, nVLR_DESP, nVLR_CRED, nQTD_TOTAL, nQTD_PLATF, nQTD_PLATP, nQTD_PLATN, @nLin )


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Limpeza dos totalizadores                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

		        nQTD_TOTAL   := 0
		        nQTD_DIVER   := 0
		        nQTD_PLATF   := 0
		        nQTD_PLATP   := 0
		        nQTD_PLATN   := 0
		        nQTD_PRD     := 0
		        nQTD_PRDP    := 0
		        nPRC_LITRO   := 0
		        nVLR_PROD    := 0
		        nVLR_DESP    := 0
		        nVLR_CRED    := 0
		        dLAST_DATE   := dSTART_DATE
		        dCURR_DATE   := dSTART_DATE
		        lSTART_DATE  := .F.
				lEND_DATE    := .F.
				
			EndIf
		
		Else
		    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo dos totalizadores do produtor no período                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	

		    If cPRODUT != (cAliasTMP)->ZL6_PRODUT .or. cLOJPRD != (cAliasTMP)->ZL6_LOJPRD	       
				
		        If cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL		        	
		        	fCalcProd( mv_par08, cPRODUT, cLOJPRD, cLINHA, nQTD_PRD, @nPRC_LITRO, @nVLR_PROD )		        	
		        EndIf 
		        
		        nQTD_PRD := 0  

		    Endif                             
		    
		EndIf
	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo dos totalizadores de plataforma                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿		

		If cCODIGO != (cAliasTMP)->ZL5_COD
			If cCODIGO != STRING_NULL
				If ( nQTD_PLATF - nQTD_PRDP ) >= 0
			    	nQTD_PLATP := 0
			    Else
			    	nQTD_PLATN += nQTD_PLATF - nQTD_PRDP
			    EndIf	
			    
			EndIf
			nQTD_PRDP  := 0		
		EndIf
		    
	   	cPRODUT := (cAliasTMP)->ZL6_PRODUT  
	   	cLOJPRD := (cAliasTMP)->ZL6_LOJPRD
	   	cTRANSP := (cAliasTMP)->ZL5_TRANSP
	   	cLINHA  := (cAliasTMP)->ZL5_LINHA
		cCODIGO := (cAliasTMP)->ZL5_COD
	   	
	   	nQTD_TOTAL += (cAliasTMP)->ZL6_QTDE
	   	nQTD_PRD   += (cAliasTMP)->ZL6_QTDE
	   	nQTD_PRDP  += (cAliasTMP)->ZL6_QTDE
	   	nQTD_PLATF := (cAliasTMP)->ZL5_PLATF
	   	
	   	dCURR_DATE := STOD( (cAliasTMP)->ZL5_DATA )
	   	                                                   
	    (cAliasTMP)->(dbSkip())
	   		
	EndDo
    
	(cAliasTMP)->(dbCloseArea())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressão das despesas e totalizadores do produtor no período           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        
	If cTRANSP != STRING_NULL .or. cLINHA != STRING_NULL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo dos totalizadores do produtor no período                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	

        If cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL		        	
        	fCalcProd( mv_par08, cPRODUT, cLOJPRD, cLINHA, nQTD_PRD, @nPRC_LITRO, @nVLR_PROD )		        	
        EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo dos totalizadores de plataforma                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿		

		If cCODIGO != STRING_NULL
			If ( nQTD_PLATF - nQTD_PRDP ) >= 0
		    	nQTD_PLATP += nQTD_PLATF - nQTD_PRDP
		    Else
		    	nQTD_PLATN += nQTD_PLATF - nQTD_PRDP
		    EndIf	
		    
		EndIf
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Salto de página                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    
	    If nLin > 55
	    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
	    	nLin := 8   
	    EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressão das despesas                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				
		dbSelectArea("SA4")
		dbSetOrder(1)
		dbSeek ( xFilial("SA4") + cTRANSP )		

		If Len(aDADOSDESP) > 0
			nPOS := aScan ( aDADOSDESP, {|x| x[1] == SA4->A4_X_FORN } )
		Else
			nPOS := 0
		EndIf
		
		If nPOS == 0				
			fTotalDesp( dSTART_DATE, dEND_DATE, SA4->A4_X_FORN, SA4->A4_X_LOJF, @nVLR_DESP, @nVLR_CRED, @nLin )
			aAdd (aDADOSDESP , {SA4->A4_X_FORN, nVLR_DESP, nVLR_CRED} )
		Else
			nVLR_DESP := 0
			nVLR_CRED := 0
		EndIf
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressão do recibo                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		
		fImpRec(cTRANSP, cLINHA, nVLR_PROD, nVLR_DESP, nVLR_CRED, nQTD_TOTAL, nQTD_PLATF, nQTD_PLATP, nQTD_PLATN, @nLin )

	EndIf


	If nTGQTDE != 0
		nLin += 2              
		@ nLin, 000 PSAY "TOTAL GERAL --> "
		@ nLin, 070 PSAY TRANSFORM( nTGQTDE  , "@R 99999999" )
		@ nLin, 082 PSAY TRANSFORM( nTGPLAT , "@R 99999999" )
		@ nLin, 094 PSAY TRANSFORM( nTGPLAP , "@R 99999999" )
		@ nLin, 108 PSAY TRANSFORM( nTGDIVR   , "@R 99999999" )
		@ nLin, 120 PSAY TRANSFORM( nTGPROD  , "@R 9,999,999.99" )
		@ nLin, 136 PSAY TRANSFORM( nTGCRED  , "@R 9,999,999.99" )
		@ nLin, 152 PSAY TRANSFORM( nTGDESP  , "@R 9,999,999.99" )	
		@ nLin, 168 PSAY TRANSFORM( nTGDIVN  , "@R 9,999,999.99" )	
		@ nLin, 184 PSAY TRANSFORM( nTGDIVP  , "@R 9,999,999.99" )	
		@ nLin, 200 PSAY TRANSFORM( nTGLIQD   , "@R 9,999,999.99" )	
	EndIf 


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return
     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalcProd  ºAutor  ³Rafael Parma       º Data ³  25/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição do valor por litro.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              

Static Function fCalcProd( nEXCECAO, cPRODUT, cLOJPRD, cLINHA, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD )

	nPRC_LITRO := 0

	If nEXCECAO == 1 	// Cadastro do produtor
	
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("SA2") + cPRODUT + cLOJPRD )
			If ! Empty ( SA2->A2_X_FAIXA )
				dbSelectArea("ZL2")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial("ZL2") + SA2->A2_X_FAIXA )
					nPRC_LITRO := ZL2->ZL2_PRCFRT	
				EndIf
			Else
				dbSelectArea("ZL2")
				dbSetOrder(2)
				dbGoTop()   
				If dbSeek ( xFilial("ZL2") + cLINHA )
					While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
						If nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
							nPRC_LITRO := ZL2->ZL2_PRCFRT
							Exit
						EndIf
						ZL2->(dbSkip())
					EndDo
				EndIf
			EndIf	
		EndIf

    Else	// tabela de exceções
    
		dbSelectArea("ZL2")
		dbSetOrder(3)	// ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
		dbGoTop()                                            
		If dbSeek ( xFilial("ZL2") + cLINHA + cPRODUT + cLOJPRD, .T. )
			nPRC_LITRO := ZL2->ZL2_PRCFRT
		Else
			dbSelectArea("ZL2")
			dbSetOrder(2)	// // ZL2_FILIAL+ZL2_LINHA
			dbGoTop()   
			If dbSeek ( xFilial("ZL2") + cLINHA )
				While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
					If nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
						nPRC_LITRO := ZL2->ZL2_PRCFRT
						Exit
					EndIf
					ZL2->(dbSkip())
				EndDo
			EndIf
		EndIf     
    
	EndIf
	
   	If nPRC_LITRO != 0
   		nVLR_PROD += Round ( nPRC_LITRO * nQTD_TOTAL , 4)	
   	EndIf    

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTotalTrp  ºAutor  ³Rafael Parma       º Data ³  25/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para impressão dos totalizadores do trans- º±±
±±º          ³portador.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function fImpRec(cTRANSP, cLINHA, nVLR_PROD, nVLR_DESP, nVLR_CRED, nQTD_TOTAL, nQTD_PLATF, nQTD_PLATP, nQTD_PLATN, nLin)

Local nQTD_DIV  := nQTD_PLATP + nQTD_PLATN
Local nVLR_DIVP := IIF( nQTD_PLATP != 0, Round( nQTD_PLATP * mv_par07, 4), 0)
Local nVLR_DIVN := IIF( nQTD_PLATN != 0, Round( nQTD_PLATN * mv_par07, 4), 0)
Local nLIQUIDO  := ( nVLR_PROD + nVLR_DIVP + nVLR_CRED + nVLR_DIVN ) -  nVLR_DESP 

	nLin += 1              
	
	/*
                  1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
        0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	    LINHA      TRANSPORTADOR                                    UF     QTD LEITE  QTD FALTAS  QTD SOBRAS  DIVERGÊNCIAS       VALOR BRUTO     VALOR BONIF.    VALOR DESC.    VALOR FALTAS    VALOR SOBRAS    VALOR LIQUIDO
	*/  

	@ nLin, 000 PSAY cLINHA
	@ nLin, 011 PSAY SA4->A4_COD + "/" +SubSTR(SA4->A4_NOME,1,40)
	@ nLin, 060 PSAY SA4->A4_EST
	
	@ nLin, 070 PSAY TRANSFORM( nQTD_TOTAL , "@E 99999999" )
	@ nLin, 082 PSAY TRANSFORM( nQTD_PLATN , "@E 99999999" )
	@ nLin, 094 PSAY TRANSFORM( nQTD_PLATP , "@E 99999999" )
	@ nLin, 108 PSAY TRANSFORM( nQTD_DIV   , "@E 99999999" )
	
	@ nLin, 120 PSAY TRANSFORM( nVLR_PROD  , "@E 9,999,999.99" )
	@ nLin, 136 PSAY TRANSFORM( nVLR_CRED  , "@E 9,999,999.99" )
	@ nLin, 152 PSAY TRANSFORM( nVLR_DESP  , "@E 9,999,999.99" )	
	@ nLin, 168 PSAY TRANSFORM( nVLR_DIVN  , "@E 9,999,999.99" )	
	@ nLin, 184 PSAY TRANSFORM( nVLR_DIVP  , "@E 9,999,999.99" )	
	@ nLin, 200 PSAY TRANSFORM( nLIQUIDO   , "@E 9,999,999.99" )	
	
	nTGQTDE  += nQTD_TOTAL
	nTGPLAT  += nQTD_PLATN
	nTGPLAP  += nQTD_PLATP
	nTGDIVR  += nQTD_DIV
	nTGPROD  += nVLR_PROD
	nTGCRED  += nVLR_CRED
	nTGDESP  += nVLR_DESP
	nTGDIVN  += nVLR_DIVN
	nTGDIVP  += nVLR_DIVP
	nTGLIQD   += nLIQUIDO 	

Return
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTotalDesp ºAutor  ³Rafael Parma       º Data ³  25/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para impressão das despesas do integrado   º±±
±±º          ³com base nas informações da conta corrente. Tabela ZLB.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTotalDesp( dSTART_DATE, dEND_DATE, cPRODUT, cLOJPRD, nVLR_DESP, nVLR_CRED, nLin )
Local lCabec     := .F.     
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10) + CHR(13) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEBITO  															  . ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "SELECT 	ZLB.ZLB_TPDESP,										" + hEnter
	cQuery += "			ZLB.ZLB_VALOR,  									" + hEnter  
	cQuery += "			ZLB.ZLB_DTMOV,  									" + hEnter
	cQuery += "			ZLB.ZLB_DTVCTO, 									" + hEnter	
	cQuery += "			ZLB.ZLB_STATUS,										" + hEnter
	cQuery += "			ZLB.ZLB_DOC,   										" + hEnter
	cQuery += "			ZLB.ZLB_SERIE,  									" + hEnter
	cQuery += "			SX5.X5_DESCRI 										" + hEnter
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" + hEnter
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " + hEnter		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par09) + "'	    " + hEnter
	cQuery += "AND      				       '" + DTOS(mv_par10) + "'	    " + hEnter
/*
	cQuery += "AND      ZLB.ZLB_DTMOV  BETWEEN '" + DTOS(dSTART_DATE) + "'	" + hEnter
	cQuery += "AND      				       '" + DTOS(dEND_DATE)   + "'	" + hEnter
*/
	If mv_par11 != 1
		cQuery += "AND 	ZLB.ZLB_STATUS    = ' '						    	" + hEnter
	EndIf
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'D'							    " + hEnter	
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter
                        
	memowrite("LTREL012_3.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nVLR_DESP  := 0 
	
	While (cAliasTMP)->(!EOF())

		nVLR_DESP += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbSkip())

    EndDo

    (cAliasTMP)->(dbCloseArea())           

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CREDITO 															  . ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "SELECT 	ZLB.ZLB_TPDESP,										" + hEnter
	cQuery += "			ZLB.ZLB_VALOR,  									" + hEnter  
	cQuery += "			ZLB.ZLB_DTMOV,  									" + hEnter
	cQuery += "			ZLB.ZLB_DTVCTO, 									" + hEnter	
	cQuery += "			ZLB.ZLB_STATUS,										" + hEnter
	cQuery += "			ZLB.ZLB_DOC,   										" + hEnter
	cQuery += "			ZLB.ZLB_SERIE,  									" + hEnter
	cQuery += "			SX5.X5_DESCRI 										" + hEnter
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" + hEnter
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " + hEnter		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par09) + "'	    " + hEnter
	cQuery += "AND      				       '" + DTOS(mv_par10) + "'	    " + hEnter
/*
	cQuery += "AND      ZLB.ZLB_DTMOV  BETWEEN '" + DTOS(dSTART_DATE) + "'	" + hEnter
	cQuery += "AND      				       '" + DTOS(dEND_DATE)   + "'	" + hEnter
*/
	If mv_par11 != 1
		cQuery += "AND 	ZLB.ZLB_STATUS    = ' '						    	" + hEnter
	EndIf
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'C'							    " + hEnter	
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter
                        
	memowrite("LTREL012_3.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nVLR_CRED  := 0 

	While (cAliasTMP)->(!EOF())

		nVLR_CRED += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbSkip())

    EndDo

    (cAliasTMP)->(dbCloseArea())           

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  25/05/10   º±±
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
aRegs  := {}
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
	aAdd(aRegs,{cPerg,"01","Mês                ?","Mês                ?","Mês                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1201."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1202."})
	aAdd(aRegs,{cPerg,"03","Transportador De   ?","Transportador De   ?","Transportador De   ?","mv_ch3","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA4","","",".LTREL1203."})
	aAdd(aRegs,{cPerg,"04","Transportador Até  ?","Transportador Até  ?","Transportador Até  ?","mv_ch4","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA4","","",".LTREL1204."})
	aAdd(aRegs,{cPerg,"05","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1205."})
	aAdd(aRegs,{cPerg,"06","Linha Até          ?","Linha Até          ?","Linha Até          ?","mv_ch6","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1206."})
	aAdd(aRegs,{cPerg,"07","Valor Lt. Diverg.  ?","Valor Lt. Diverg.  ?","Valor Lt. Diverg.  ?","mv_ch7","N",07,4,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1207."})
	aAdd(aRegs,{cPerg,"08","Utilizar Excecão   ?","Utilizar Excecão   ?","Utilizar Excecão   ?","mv_ch8","N",01,0,1,"C","","mv_par08","Produtor","Produtor","Produtor","","","Tabela","Tabela","Tabela","","","","","","","","","","","","","","","","", "","","",".LTREL1208."})
	aAdd(aRegs,{cPerg,"09","Vencimento De      ?","Vencimento De      ?","Vencimento De      ?","mv_ch9","D",01,0,1,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1209."})
	aAdd(aRegs,{cPerg,"10","Vencimento Ate     ?","Vencimento Ate     ?","Vencimento Ate     ?","mv_cha","D",01,0,1,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1210."})
	aAdd(aRegs,{cPerg,"11","Imp. Descontos Compensados?","Imp. Descontos Compensados?","Imp. Descontos Compensados?","mv_chb","C",01,0,1,"C","","mv_par11","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","", "","","",".LTREL1211."})	


	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  `
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe o mês ao qual deseje imprimir    " )       
	AADD( aHelp02, "Informe o ano ao qual deseje imprimir    " )       
	AADD( aHelp03, "Informe o código inicial do transportador" )       
	AADD( aHelp03, "a ser impresso.                          " )       
	AADD( aHelp04, "Informe o código final do transportador  " )       
	AADD( aHelp04, "a ser impresso.                          " )       
	AADD( aHelp05, "Informe o número inicial da linha        " )       
	AADD( aHelp05, "a ser impressa.                          " )       
	AADD( aHelp06, "Informe o número final da linha          " )       
	AADD( aHelp06, "a ser impressa.                          " )       
	AADD( aHelp07, "Informe o valor por litro para cálculo   " )       
	AADD( aHelp07, "da divergência.                          " ) 
	AADD( aHelp08, "Utilizar tabela de exceção do cadastro do" )       
	AADD( aHelp08, "produtor ou das tabelas de exceções.     " )	      
	AADD( aHelp09, "Válido somente para lançamentos da       " )	
	AADD( aHelp09, "Conta Corrente Produtor.                 " )	
	AADD( aHelp10, "Informe o Vencimento Final.              " )	
	AADD( aHelp10, "Válido somente para lançamentos da       " )	
	AADD( aHelp10, "Conta Corrente Produtor.                 " )	
	AADD( aHelp11, "Imprime Descontos compensados?           " )
	
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
	PutSX1Help("P.LTREL1201.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL1202.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL1203.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL1204.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL1205.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL1206.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL1207.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL1208.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL1209.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL1210.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL1211.",aHelp11,aHelp11,aHelp11)
			
Return Nil