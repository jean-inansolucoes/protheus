#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL029 บAutor  ณTOTVS CASCAVEL       บ Data ณ  14/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEntregas de leite com quantidade e pre็o mensal no perํodo. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*---------------------------------------------------------------------------*
User Function LTREL029()
*---------------------------------------------------------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "RELAวรO DE ENTREGAS MENSAL"
Private cPict        := ""
Private titulo       := "RELAวรO DE ENTREGAS MENSAL"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := "" 
Private imprime      := .T.
Private aOrd         := {"C๓digo Produtor","Nome Produtor","Volume"}         
Private cPerg        := "LTREL029X1"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL029"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0        
Private nOrdem       := 1
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL029"
Public STRING_NULL   := ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZL0"
	AjustaSX1()                                                 
	Pergunte(cPerg, .F.) 
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	nOrdem := aReturn[8]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RptStatus({|| ReportPrd() },Titulo)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrdบAutor  ณTOTVS CASCAVEL       บ Data ณ  14/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEntregas de leite com quantidade e pre็o mensal no perํodo. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------------*
Static Function ReportPrd()          
*---------------------------------------------------------------------------*
Private cAliasTMP	:= GetNextAlias()
Private hEnter		:= CHR(10) + CHR(13) 
Private cMV_ZLTPRD	:= AllTRIM(GetMV("MV_ZLTPRD"))		//-- c๓digo do produto
Private aDADOSIMP	:= {}
Private aDADOSMES	:= {}
Private aDADOSLIN	:= {}
Private cLINIMP		:= ""
Private nCOLMED		:= 0
Private nCOLVOL		:= 0

	cMADe  := cValToChar(mv_par01)+STRZero(mv_par02,2)
	cMAAte := cValToChar(mv_par01)+STRZero(mv_par03,2)
	
	nMES := mv_par02
	While nMES <= mv_par03
		aAdd ( aDADOSMES, { cValToChar(mv_par01)+STRZero(nMES,2), 0 } )
		nMES += 1
	Enddo

	cQuery := "SELECT 	ZL5.ZL5_LINHA,			  									" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
	cQuery += "			SA2.A2_NOME,												" + hEnter
	cQuery += "			SUBSTRING(ZL5.ZL5_DATA,01,06) ANOMES,  						" + hEnter
	cQuery += "			SUM(ZL6.ZL6_QTDE) ZL6_QTDE  								" + hEnter
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" + hEnter
	cQuery += "ON       ZL5.ZL5_FILIAL    		= 	ZL6.ZL6_FILIAL                  " + hEnter		
	cQuery += "AND      ZL5.ZL5_COD				= 	ZL6.ZL6_COD                     " + hEnter		
	cQuery += "AND 		ZL5.D_E_L_E_T_        	!= '*' 								" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" + hEnter
	cQuery += "ON       SA2.A2_COD				= ZL6.ZL6_PRODUT    				" + hEnter		
	cQuery += "AND      SA2.A2_LOJA				= ZL6.ZL6_LOJPRD    				" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_        	!= '*' 								" + hEnter			
	cQuery += "WHERE    ZL5.ZL5_FILIAL			= 	'" + xFilial("ZL5") + "' 		" + hEnter
    cQuery += "AND   	ZL5.ZL5_LINHA	BETWEEN 	'" + mv_par04 + "' 		   		" + hEnter
	cQuery += "AND                 		    		'" + mv_par05 + "'				" + hEnter
   	cQuery += "AND 		SUBSTRING(ZL5.ZL5_DATA,1,6) >=	'" + cMADe  + "'				" + hEnter
   	cQuery += "AND 		SUBSTRING(ZL5.ZL5_DATA,1,6) <=	'" + cMAAte + "'				" + hEnter
    cQuery += "AND   	ZL6.ZL6_PRODUT	BETWEEN 	'" + mv_par06 + "' 		   		" + hEnter
	cQuery += "AND                 		    		'" + mv_par07 + "'				" + hEnter
    cQuery += "AND   	ZL6.ZL6_LOJPRD	BETWEEN 	'" + mv_par08 + "' 		   		" + hEnter
	cQuery += "AND                 		    		'" + mv_par09 + "'				" + hEnter
	cQuery += "AND 		ZL6.ZL6_QTDE           	> 0 								" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_        	!= '*' 								" + hEnter
	cQuery += "GROUP BY	ZL5.ZL5_LINHA,			  									" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
	cQuery += "			SA2.A2_NOME,												" + hEnter	
	cQuery += "			SUBSTRING(ZL5.ZL5_DATA,01,06)  								" + hEnter
	cQuery += "ORDER BY	ZL5.ZL5_LINHA,												" + hEnter
	If nOrdem == 1
		cQuery += "		ZL6.ZL6_PRODUT,												" + hEnter
		cQuery += "		ZL6.ZL6_LOJPRD,												" + hEnter
	ElseIf nOrdem == 2
		cQuery += "		SA2.A2_NOME,												" + hEnter	
	EndIf	
	cQuery += "			SUBSTRING(ZL5.ZL5_DATA,01,06)									" + hEnter
                       
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
 	While (cAliasTMP)->(!EOF())

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

 		If Len(aDADOSIMP) == 0
 			nPOSPRD := 0
 		Else
 			nPOSPRD := aScan ( aDADOSIMP, { |x| x[1] == (cAliasTMP)->ZL5_LINHA .and. x[2] == (cAliasTMP)->ZL6_PRODUT .and. x[3] == (cAliasTMP)->ZL6_LOJPRD } )
 		EndIf
 		
 		If nPOSPRD == 0
 			aAdd ( aDADOSIMP, { (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, {}, 0 } )
 			nPOSPRD := Len(aDADOSIMP) 			
 			For nI := 1 to Len(aDADOSMES)
 				aAdd ( aDADOSIMP[nPOSPRD][04], { aDADOSMES[nI][01], 0, 0 } )
 			Next nI 			
 		EndIf
 		
 		nPOSMES := aScan ( aDADOSIMP[nPOSPRD][04], { |x| x[1] == (cAliasTMP)->ANOMES } )
 		If nPOSMES != 0
 			aDADOSIMP[nPOSPRD][04][nPOSMES][02] += (cAliasTMP)->ZL6_QTDE
 		EndIf

		If nOrdem == 3
	 		If Len(aDADOSLIN) == 0
	 			nPOSLIN := 0
	 		Else
	 			nPOSLIN := aScan ( aDADOSLIN, (cAliasTMP)->ZL5_LINHA )
	 		EndIf
	 		
	 		If nPOSLIN == 0
	 			aAdd ( aDADOSLIN, (cAliasTMP)->ZL5_LINHA )
	 		EndIf
	 	EndIf
 		
		(cAliasTMP)->(dbskip())
		IncRegua()
	Enddo
	(cAliasTMP)->(dbCloseArea()) 
	
	
 	If Len(aDADOSIMP) > 0        
 		SetRegua(Len(aDADOSIMP))
 		For nI := 1 to Len(aDADOSIMP)
			
			cCODFOR := aDADOSIMP[nI][02]
			cLOJFOR := aDADOSIMP[nI][03]
			                             
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif			
			
			For nJ := 1 to Len(aDADOSIMP[nI][04])
				If aDADOSIMP[nI][04][nJ][02] > 0
				
					//Perํodos anteriores a 12/2014 as notas eram emitidas no m๊s seguinte.
					cANOMES := aDADOSIMP[nI][04][nJ][01]					
					If cANOMES < "201412"
						nANO := SubSTR(cANOMES,1,4)
						nMES := Val(SubSTR(cANOMES,5,2))
						nMES += 1
						If nMES == 13
							nMES := 1
							nANO += 1
						EndIf
						cANOMES := cValToChar(nANO)+STRZero(nMES,2)
					EndIf                                                                                     
					
					cCondData := "AND 	SUBSTRING(SD1.D1_EMISSAO,1,6) = '" + cANOMES  + "' 			" + hEnter					
					If aDADOSIMP[nI][04][nJ][01] == "201411"
						cCondData := "AND 	SD1.D1_EMISSAO		  >= '20141201'			 			" + hEnter
						cCondData += "AND 	SD1.D1_EMISSAO		   < '20141231'			 			" + hEnter
					ElseIf aDADOSIMP[nI][04][nJ][01] == "201412"
						cCondData := "AND 	SD1.D1_EMISSAO		   = '20141231'			 			" + hEnter
					EndIf
										
					cQuery := "SELECT	SUM(SD1.D1_TOTAL) D1_TOTAL									" + hEnter
					cQuery += " 	   ,SUM(SD1.D1_VALDEV) D1_VALDEV								" + hEnter
					cQuery += "FROM " + RetSqlName("SD1") + " SD1									" + hEnter
					cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2   							" + hEnter
					cQuery += "ON       SA2.A2_COD        = SD1.D1_FORNECE                          " + hEnter		
					cQuery += "AND      SA2.A2_LOJA       = SD1.D1_LOJA                             " + hEnter				
					cQuery += "AND      SA2.A2_X_TIPO     = 'P'			                            " + hEnter				
					cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 									" + hEnter
					cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1   							" + hEnter
					cQuery += "ON       SF1.F1_FILIAL     = SD1.D1_FILIAL                           " + hEnter		
					cQuery += "AND      SF1.F1_DOC        = SD1.D1_DOC                              " + hEnter		
					cQuery += "AND      SF1.F1_SERIE      = SD1.D1_SERIE                            " + hEnter		
					cQuery += "AND      SF1.F1_FORNECE    = SD1.D1_FORNECE                          " + hEnter		
					cQuery += "AND      SF1.F1_LOJA       = SD1.D1_LOJA                             " + hEnter		
					cQuery += "AND 		SF1.F1_ESPECIE    = 'SPED'		                            " + hEnter
					cQuery += "AND 		SF1.D_E_L_E_T_   != '*' 									" + hEnter
					cQuery += "WHERE    SD1.D1_FILIAL     = '" + xFilial("SD1") + "'				" + hEnter
					cQuery += "AND 		SD1.D1_COD	      = '" + cMV_ZLTPRD + "' 					" + hEnter
					cQuery += "AND 		SD1.D1_FORNECE	  = '" + cCODFOR + "' 						" + hEnter
					cQuery += "AND 		SD1.D1_LOJA		  = '" + cLOJFOR + "' 						" + hEnter
					cQuery += cCondData
					cQuery += "AND 		SD1.D1_TIPO	    IN ('N','C')			 					" + hEnter
					cQuery += "AND 		SD1.D_E_L_E_T_   != '*' 									" + hEnter
		
					TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)			
					dbSelectArea(cAliasTMP)
					(cAliasTMP)->(dbGoTop())
				 	If (cAliasTMP)->(!EOF())
				 		aDADOSIMP[nI][04][nJ][03] += ((cAliasTMP)->D1_TOTAL - (cAliasTMP)->D1_VALDEV)
				 	EndIf
					(cAliasTMP)->(dbCloseArea())
					IncRegua()
					
				EndIf  				
			Next nJ
		Next nI
	EndIf
		
 	
    //--Impressใo dos dados
	If Len(aDADOSIMP) > 0
		SetRegua(Len(aDADOSIMP))
		//--Ordena array por Volume
		If nOrdem == 3
		
			For nI := 1 to Len(aDADOSIMP)
				For nJ := 1 to Len(aDADOSIMP[nI][04])
					aDADOSIMP[nI][05] += aDADOSIMP[nI][04][nJ][02]					
				Next nJ
			Next nI 
			aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[5] < y[5] } )	
	    
			For nF := 1 to Len(aDADOSLIN)
			
				For nI := 1 to Len(aDADOSIMP)
		            
					If aDADOSLIN[nF] == aDADOSIMP[nI][01]

						//--Impressใo do cabe็alho
						If cLINIMP != aDADOSIMP[nI][01] .or. nLin > 65
							fImpCabec()
						EndIf
						
						If lAbortPrint
							@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
							Exit
						Endif						
							                              
						aDADOSMED := {}			
						
						@nLin,000	PSAY aDADOSIMP[nI][02]
						@nLin,010	PSAY SUBSTR(POSICIONE("SA2",1,XFILIAL("SA2")+aDADOSIMP[nI][02]+aDADOSIMP[nI][03],"A2_NOME"),1,26) 
									
						If mv_par10 == 1
							
							//--Impressใo dos meses
							For nJ := 1 to Len(aDADOSIMP[nI][04])			
								nCol := aScan ( aDADOSMES, { |x| x[1] == aDADOSIMP[nI][04][nJ][01] } )
								nCol := aDADOSMES[nCol][02]
								nQtd := aDADOSIMP[nI][04][nJ][02]
								nPrc := aDADOSIMP[nI][04][nJ][03]/aDADOSIMP[nI][04][nJ][02]
												
								@nLin,nCol		PSAY nQtd PICTURE "@E 999,999"
								@nLin,nCol+008	PSAY nPrc PICTURE "@E 9.9999"				
								
								If nQtd > 0 .and. nPrc > 0
									aAdd (aDADOSMED, { aDADOSIMP[nI][04][nJ][02], aDADOSIMP[nI][04][nJ][03] } )
								EndIf				
							Next nJ  
							
							//--Impressใo das m้dias
							If Len(aDADOSMED) > 0
								nQtdMed := 0
								nVlrMed := 0
								For nJ := 1 to Len(aDADOSMED)
									nQtdMed += aDADOSMED[nJ][01]	
									nVlrMed += aDADOSMED[nJ][02]	
								Next nI				
								nVlrMed := nVlrMed/nQtdMed
								nQtdMed := nQtdMed/Len(aDADOSMED)
								@nLin,nCOLMED		PSAY nQtdMed PICTURE "@E 999,999"
								@nLin,nCOLMED+008	PSAY nVlrMed PICTURE "@E 9.9999"								
							EndIf
							
						Else
			
							@nLin,038	PSAY "Pre็o: "
			
							//--Impressใo dos meses (pre็os)
							For nJ := 1 to Len(aDADOSIMP[nI][04])			
								nCol := aScan ( aDADOSMES, { |x| x[1] == aDADOSIMP[nI][04][nJ][01] } )
								nCol := aDADOSMES[nCol][02]
								nQtd := aDADOSIMP[nI][04][nJ][02]
								nPrc := aDADOSIMP[nI][04][nJ][03]/aDADOSIMP[nI][04][nJ][02]
								@nLin,nCol		PSAY nPrc PICTURE "@E 99.9999"
								If nQtd > 0 .and. nPrc > 0
									aAdd (aDADOSMED, { aDADOSIMP[nI][04][nJ][02], aDADOSIMP[nI][04][nJ][03] } )
								EndIf				
							Next nJ  
							
							//--Impressใo das m้dias (pre็os)
							nQtdMed := 0
							nQtdTot := 0
							nVlrMed := 0
							If Len(aDADOSMED) > 0
								For nJ := 1 to Len(aDADOSMED)
									nQtdTot += aDADOSMED[nJ][01]	
									nVlrMed += aDADOSMED[nJ][02]	
								Next nI				
								nVlrMed := nVlrMed/nQtdTot
								nQtdMed := nQtdTot/Len(aDADOSMED)
								@nLin,nCOLMED	PSAY nVlrMed PICTURE "@E 99.9999"								
							EndIf    
							
			                nLin += 1
							@nLin,038	PSAY "Volume: "
							
							//--Impressใo dos meses (volumes)
							For nJ := 1 to Len(aDADOSIMP[nI][04])			
								nCol := aScan ( aDADOSMES, { |x| x[1] == aDADOSIMP[nI][04][nJ][01] } )
								nCol := aDADOSMES[nCol][02]
								nQtd := aDADOSIMP[nI][04][nJ][02]
								@nLin,nCol		PSAY nQtd PICTURE "@E 999,999"
							Next nJ  
							
							//--Impressใo das m้dias (volumes)
							@nLin,nCOLMED	PSAY nQtdMed PICTURE "@E 999,999"								
							@nLin,nCOLVOL	PSAY nQtdTot PICTURE "@E 999,999,999"												
							
						EndIf

						nLin += 1
						@nLin,000 PSAY __PrtThinLine() 								
						nLin += 1				
						cLINIMP := aDADOSIMP[nI][01]			
						
					EndIf
					IncRegua()
				Next nI
			Next nF
		
		Else
		
			For nI := 1 to Len(aDADOSIMP)
	            
				//--Impressใo do cabe็alho
				If cLINIMP != aDADOSIMP[nI][01] .or. nLin > 65
					fImpCabec()
				EndIf	                              
				aDADOSMED := {}
				
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif													
				
				@nLin,000	PSAY aDADOSIMP[nI][02]
				@nLin,010	PSAY SUBSTR(POSICIONE("SA2",1,XFILIAL("SA2")+aDADOSIMP[nI][02]+aDADOSIMP[nI][03],"A2_NOME"),1,26) 
							
				If mv_par10 == 1
					
					//--Impressใo dos meses
					For nJ := 1 to Len(aDADOSIMP[nI][04])			
						nCol := aScan ( aDADOSMES, { |x| x[1] == aDADOSIMP[nI][04][nJ][01] } )
						nCol := aDADOSMES[nCol][02]
						nQtd := aDADOSIMP[nI][04][nJ][02]
						nPrc := aDADOSIMP[nI][04][nJ][03]/aDADOSIMP[nI][04][nJ][02]
										
						@nLin,nCol		PSAY nQtd PICTURE "@E 999,999"
						@nLin,nCol+008	PSAY nPrc PICTURE "@E 9.9999"				
						
						If nQtd > 0 .and. nPrc > 0
							aAdd (aDADOSMED, { aDADOSIMP[nI][04][nJ][02], aDADOSIMP[nI][04][nJ][03] } )
						EndIf				
					Next nJ  
					
					//--Impressใo das m้dias
					If Len(aDADOSMED) > 0
						nQtdMed := 0
						nVlrMed := 0
						For nJ := 1 to Len(aDADOSMED)
							nQtdMed += aDADOSMED[nJ][01]	
							nVlrMed += aDADOSMED[nJ][02]	
						Next nI				
						nVlrMed := nVlrMed/nQtdMed
						nQtdMed := nQtdMed/Len(aDADOSMED)
						@nLin,nCOLMED		PSAY nQtdMed PICTURE "@E 999,999"
						@nLin,nCOLMED+008	PSAY nVlrMed PICTURE "@E 9.9999"								
					EndIf
					
				Else
	
					@nLin,038	PSAY "Pre็o: "
	
					//--Impressใo dos meses (pre็os)
					For nJ := 1 to Len(aDADOSIMP[nI][04])			
						nCol := aScan ( aDADOSMES, { |x| x[1] == aDADOSIMP[nI][04][nJ][01] } )
						nCol := aDADOSMES[nCol][02]
						nQtd := aDADOSIMP[nI][04][nJ][02]
						nPrc := aDADOSIMP[nI][04][nJ][03]/aDADOSIMP[nI][04][nJ][02]
						@nLin,nCol		PSAY nPrc PICTURE "@E 99.9999"
						If nQtd > 0 .and. nPrc > 0
							aAdd (aDADOSMED, { aDADOSIMP[nI][04][nJ][02], aDADOSIMP[nI][04][nJ][03] } )
						EndIf				
					Next nJ  
					
					//--Impressใo das m้dias (pre็os)
					nQtdMed := 0
					nQtdTot := 0
					nVlrMed := 0
					If Len(aDADOSMED) > 0
						For nJ := 1 to Len(aDADOSMED)
							nQtdTot += aDADOSMED[nJ][01]	
							nVlrMed += aDADOSMED[nJ][02]	
						Next nI				
						nVlrMed := nVlrMed/nQtdTot
						nQtdMed := nQtdTot/Len(aDADOSMED)
						@nLin,nCOLMED	PSAY nVlrMed PICTURE "@E 99.9999"								
					EndIf    
					
	                nLin += 1
					@nLin,038	PSAY "Volume: "
					
					//--Impressใo dos meses (volumes)
					For nJ := 1 to Len(aDADOSIMP[nI][04])			
						nCol := aScan ( aDADOSMES, { |x| x[1] == aDADOSIMP[nI][04][nJ][01] } )
						nCol := aDADOSMES[nCol][02]
						nQtd := aDADOSIMP[nI][04][nJ][02]
						@nLin,nCol		PSAY nQtd PICTURE "@E 999,999"
					Next nJ  
					
					//--Impressใo das m้dias (volumes)
					@nLin,nCOLMED	PSAY nQtdMed PICTURE "@E 999,999"								
					@nLin,nCOLVOL	PSAY nQtdTot PICTURE "@E 999,999,999"												
					
				EndIf
						
				nLin += 1				
				cLINIMP := aDADOSIMP[nI][01]
				IncRegua()			
				
			Next nI
			
		EndIf
	EndIf	
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	        
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrdบAutor  ณTOTVS CASCAVEL       บ Data ณ  14/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEntregas de leite com quantidade e pre็o mensal no perํodo. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------------*
Static Function fImpCabec()
*---------------------------------------------------------------------------*

	Cabec1 := "ANO DE REFERสNCIA: "+cValToChar(mv_par01)+" - MสS INICIAL: "+STRZero(mv_par02,2)+" - MสS FINAL: "+STRZero(mv_par03,2)
	Cabec1 += " - LINHA: "+aDADOSIMP[nI][01]+"-"+ALLTRIM(POSICIONE("ZL0",1,XFILIAL("ZL0")+aDADOSIMP[nI][01],"ZL0_DESC"))
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
	nLin := 8

	@nLin,000	PSAY "C๓digo"
	@nLin,010	PSAY "Produtor"
		
	If mv_par10 == 1
		nCol := 038
	Else
		nCol := 048
	EndIf
	
	For nJ := 1 to Len(aDADOSMES)
		cMes := SubSTR(aDADOSMES[nJ][01],5,2)+"/"+SubSTR(aDADOSMES[nJ][01],1,4)
		If mv_par10 == 1
			@nLin,nCol+004	PSAY cMES        
		Else
			@nLin,nCol		PSAY cMES        
		EndIf
		aDADOSMES[nJ][02] := nCol
		If mv_par10 == 1
			nCol += 014
		Else           
			nCol += 010
		EndIf
	Next nJ
	
	If mv_par10 == 1				
		@nLin,nCol+002	PSAY "M้dia Geral"
	Else                                 
		@nLin,nCol		PSAY "M้dia Geral"
	EndIf
	nCOLMED := nCol
    
	If mv_par10 == 1
		nLin += 1
		nCol := 038
		For nJ := 1 to Len(aDADOSMES)
			@nLin,nCol PSAY " Volume  Pre็o"
			nCol += 014
		Next nJ				
		@nLin,nCol PSAY " Volume  Pre็o"
	Else
		@nLin,nCol+014 PSAY "Volume Total"
		nCOLVOL := nCol+014	
	EndIf
		
	nLin += 1
	@nLin,000 PSAY __PrtThinLine() 
	nLin += 1

Return   
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1บAutor  ณTOTVS CASCAVEL       บ Data ณ  14/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
*---------------------------------------------------------------------------*        
Static Function AjustaSX1()
*---------------------------------------------------------------------------*        
aRegs  := {}  
       
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Ano Refer๊ncia      ?","Ano Refer๊ncia      ?","Ano Refer๊ncia      ?","mv_ch1","N",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","M๊s Inicial         ?","M๊s Inicial         ?","M๊s Inicial         ?","mv_ch2","N",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"03","M๊s Final           ?","M๊s Final           ?","M๊s Final           ?","mv_ch3","N",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Linha De            ?","Linha De            ?","Linha De            ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"05","Linha At้           ?","Linha At้           ?","Linha At้           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"06","Produtor De         ?","Produtor De         ?","Produtor De         ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",""})
	aAdd(aRegs,{cPerg,"07","Produtor At้        ?","Produtor At้        ?","Produtor At้        ?","mv_ch7","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",""})
	aAdd(aRegs,{cPerg,"08","Loja Produtor De    ?","Loja Produtor De    ?","Loja Produtor De    ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","Loja Produtor At้   ?","Loja Produtor At้   ?","Loja Produtor At้   ?","mv_ch9","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"10","Imp. Dados Separados?","Imp. Dados Separados?","Imp. Dados Separados?","mv_chA","N",01,0,1,"C","","mv_par10","Nใo","Nใo","Nใo","","","Sim","Sim","Sim","","","","","","","","","","","","","","","","","","","","","", "","","",""})	

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
		
Return Nil
