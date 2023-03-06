#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL024 บAutor  ณAlexandre Longhinottiบ Data ณ  16/12/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de totaliza็ใo				          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*---------------------------------------------------------------------------*
User Function LTREL024()
*---------------------------------------------------------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "TOTALIZACAO DE FATURAMENTO - POR POSTO"
Private cPict        := ""
Private titulo       := "TOTALIZACAO DE FATURAMENTO - POR POSTO"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := "" 
Private imprime      := .T.
Private aOrd         := {}         
Private cPerg        := "LTREL00024"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LTREL024"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL024"
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RptStatus({|| ReportPrd() },Titulo)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณReportPrd บ Autor ณRafael Parma        บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Impressใo do movimento do produtor.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
       
*---------------------------------------------------------------------------*
Static Function ReportPrd()          
*---------------------------------------------------------------------------*
Local cAliasTMP		:= GetNextAlias()
Local hEnter		:= CHR(10) + CHR(13) 
Local aDADOSTMP		:= {}
Local aDADOSPRD		:= {}
Local aDADOSTOT		:= {}
Local cMV_ZLTPRD	:= AllTRIM(GetMV("MV_ZLTPRD"))		//-- c๓digo do produto
Local CabecAux 		:= ""

	cMADe  := cValToChar(mv_par01)+STRZero(mv_par02,2)
	cMAAte := cValToChar(mv_par01)+STRZero(mv_par03,2)
    If mv_par04 == mv_par05
       CabecAux := " - LINHA: " + mv_par04
    EndIf
	Cabec1 := "ANO DE REFERสNCIA: "+cValToChar(mv_par01)+" - MสS INICIAL: "+STRZero(mv_par02,2)+" - MสS FINAL: "+STRZero(mv_par03,2) + CabecAux
	
	    
	cQuery := "SELECT 	SUBSTRING(ZL5.ZL5_DATA,01,06) ANOMES,							" + hEnter
	cQuery += "			ZL5.ZL5_FILIAL, 											" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
	cQuery += "			SUM(ZL6.ZL6_QTDE) ZL6_QTDE  								" + hEnter
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" + hEnter
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          " + hEnter		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             " + hEnter		
	cQuery += "WHERE    ZL5.ZL5_FILIAL    BETWEEN	'" + mv_par06 + "' 				" + hEnter
	cQuery += "AND                 		          	'" + mv_par07 + "'  			" + hEnter    
    cQuery += "AND   	ZL5.ZL5_LINHA  	  BETWEEN 	'" + mv_par04 + "' 		   		" + hEnter
	cQuery += "AND                 		    		'" + mv_par05 + "'				" + hEnter
   	cQuery += "AND 		SUBSTRING(ZL5.ZL5_DATA,1,6) >=	'" + cMADe  + "'				" + hEnter
   	cQuery += "AND 		SUBSTRING(ZL5.ZL5_DATA,1,6) <=	'" + cMAAte + "'				" + hEnter
	cQuery += "AND 		ZL6.ZL6_QTDE           > 0 									" + hEnter
	cQuery += "AND 		ZL5.D_E_L_E_T_        != '*' 								" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_        != '*' 								" + hEnter
	cQuery += "GROUP BY	SUBSTRING(ZL5.ZL5_DATA,01,06),									" + hEnter
	cQuery += "			ZL5.ZL5_FILIAL, 											" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD 												" + hEnter
	cQuery += "ORDER BY	SUBSTRING(ZL5.ZL5_DATA,01,06),									" + hEnter
	cQuery += "			ZL5.ZL5_FILIAL, 											" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD 												" + hEnter
                       
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
 	While (cAliasTMP)->(!EOF())
 	
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
 		
 		If Len(aDADOSTMP) == 0
 			nPOS := 0
 		Else
 			nPOS := aScan ( aDADOSTMP, { |x| x[1] == (cAliasTMP)->ANOMES .and. x[2] == (cAliasTMP)->ZL5_FILIAL } )
 		EndIf
 		
 		If nPOS == 0
 			aAdd ( aDADOSTMP, { (cAliasTMP)->ANOMES, (cAliasTMP)->ZL5_FILIAL, 0, 0, 0, 0, 0 } )
 			nPOS := Len(aDADOSTMP)
 		EndIf
 		
 		If Len(aDADOSPRD) == 0
 			nPOSPRD := 0
 		Else
 			nPOSPRD := aScan ( aDADOSPRD, { |x| x[1] == (cAliasTMP)->ZL6_PRODUT .and. x[2] == (cAliasTMP)->ZL6_LOJPRD } )
 		EndIf
 		
 		If nPOSPRD == 0
 			aDADOSTMP[nPOS][03] += 1					//--N๚mero de produtores
 			aAdd ( aDADOSPRD, { (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD } )
 		EndIf
 			
 		aDADOSTMP[nPOS][04] += (cAliasTMP)->ZL6_QTDE	//--Quantidade de leite
 		
		(cAliasTMP)->(dbskip())
		IncRegua()
		
	Enddo
	(cAliasTMP)->(dbCloseArea()) 
	
	
 	If Len(aDADOSTMP) > 0
 		SetRegua(Len(aDADOSTMP))
 		For nI := 1 to Len(aDADOSTMP)

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

 		
			cANOMES := aDADOSTMP[nI][01]
			
			//Perํodos anteriores a 12/2014 as notas eram emitidas no m๊s seguinte.
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
			
			cCondSD1 := "AND 	(SUBSTRING(SD1.D1_EMISSAO,1,6) = '" + cANOMES  + "' 			" + hEnter					
			cCondSE1 := "AND 	SUBSTRING(SE1.E1_EMISSAO,1,6) = '" + cANOMES  + "' 			" + hEnter					
			If aDADOSTMP[nI][01] == "201411"
				cCondSD1 := "AND 	(SD1.D1_EMISSAO		  >= '20141201'			 			" + hEnter
				cCondSD1 += "AND 	(SD1.D1_EMISSAO		   < '20141231'			 			" + hEnter
				cCondSE1 := "AND 	SE1.E1_EMISSAO		  >= '20141201'			 			" + hEnter
				cCondSE1 += "AND 	SE1.E1_EMISSAO		   < '20141231'			 			" + hEnter
			ElseIf aDADOSTMP[nI][01] == "201412"
				cCondSD1 := "AND 	(SD1.D1_EMISSAO		   = '20141231'			 			" + hEnter
				cCondSE1 := "AND 	SE1.E1_EMISSAO		   = '20141231'			 			" + hEnter
			EndIf
				
			
			//--Valor Total e FUNRURAL
			cQuery := "SELECT	SUM(SD1.D1_TOTAL) D1_TOTAL,									" + hEnter
			cQuery += "			SUM(SD1.D1_VALDEV) D1_VALDEV,								" + hEnter
			cQuery += "			SUM(SF1.F1_CONTSOC) F1_CONTSOC								" + hEnter
			cQuery += "FROM " + RetSqlName("SD1") + " SD1									" + hEnter
			cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2   							" + hEnter
			cQuery += "ON       SA2.A2_COD        = SD1.D1_FORNECE                          " + hEnter		
			cQuery += "AND      SA2.A2_LOJA       = SD1.D1_LOJA                             " + hEnter				
			cQuery += "AND      SA2.A2_X_TIPO     = 'P'			                            " + hEnter
		    cQuery += "AND   	SA2.A2_X_LINHA	BETWEEN 	'" + mv_par04 + "' 		   		" + hEnter
			cQuery += "AND                 		    		'" + mv_par05 + "'				" + hEnter
			cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 									" + hEnter
			cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1   							" + hEnter
			cQuery += "ON       SF1.F1_FILIAL     = SD1.D1_FILIAL                           " + hEnter		
			cQuery += "AND      SF1.F1_DOC        = SD1.D1_DOC                              " + hEnter		
			cQuery += "AND      SF1.F1_SERIE      = SD1.D1_SERIE                            " + hEnter		
			cQuery += "AND      SF1.F1_FORNECE    = SD1.D1_FORNECE                          " + hEnter		
			cQuery += "AND      SF1.F1_LOJA       = SD1.D1_LOJA                             " + hEnter		
			cQuery += "AND 		SD1.D1_TIPO	    IN ('N')				 					" + hEnter
			cQuery += "AND 		SF1.F1_ESPECIE    = 'SPED'		                            " + hEnter
			cQuery += "AND 		SF1.D_E_L_E_T_   != '*' 									" + hEnter	
			cQuery += "WHERE    SD1.D1_FILIAL     = '" + aDADOSTMP[nI][02] + "'				" + hEnter
			cQuery += cCondSD1
			cQuery += "OR 		SF1.F1_NUMRPS='"+SubSTR(cANOMES,5,2)+SubSTR(cANOMES,1,4)+"')" + hEnter
			cQuery += "AND 		SD1.D1_COD	      = '" + cMV_ZLTPRD + "' 					" + hEnter
			cQuery += "AND 		SD1.D1_TIPO	    IN ('N','C')			 					" + hEnter
			cQuery += "AND 		SD1.D_E_L_E_T_   != '*' 									" + hEnter

			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
		 	If (cAliasTMP)->(!EOF())
		 		aDADOSTMP[nI][05] += ((cAliasTMP)->D1_TOTAL -  (cAliasTMP)->D1_VALDEV)
		 		aDADOSTMP[nI][06] += (cAliasTMP)->F1_CONTSOC
		 	EndIf
			(cAliasTMP)->(dbCloseArea())  
			
			
			//--Frete
			cQuery := "SELECT	SUM(SE1.E1_VALOR) E1_VALOR 									" + hEnter
			cQuery += "FROM " + RetSqlName("SE1") + " SE1									" + hEnter
			cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1   							" + hEnter
			cQuery += "ON       SF1.F1_FILIAL     = SE1.E1_FILIAL                           " + hEnter		
			cQuery += "AND      SF1.F1_DOC        = SE1.E1_NUM	                            " + hEnter		
			cQuery += "AND 		SF1.F1_TIPO	      = 'N'					 					" + hEnter
			cQuery += "AND 		SF1.F1_ESPECIE    = 'SPED'		                            " + hEnter
			cQuery += "AND 		SF1.D_E_L_E_T_   != '*' 									" + hEnter
			cQuery += "INNER JOIN " + RetSqlName("SD1") + " SD1   							" + hEnter
			cQuery += "ON       SD1.D1_FILIAL     = SF1.F1_FILIAL                           " + hEnter		
			cQuery += "AND      SD1.D1_DOC        = SF1.F1_DOC                              " + hEnter		
			cQuery += "AND      SD1.D1_SERIE      = SF1.F1_SERIE                            " + hEnter		
			cQuery += "AND      SD1.D1_FORNECE    = SF1.F1_FORNECE                          " + hEnter		
			cQuery += "AND      SD1.D1_LOJA       = SF1.F1_LOJA                             " + hEnter
			cQuery += "AND 		SD1.D1_COD	      = '" + cMV_ZLTPRD + "' 					" + hEnter
			cQuery += "AND 		SD1.D_E_L_E_T_   != '*' 									" + hEnter					
			cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2   							" + hEnter
			cQuery += "ON       SA2.A2_COD        = SD1.D1_FORNECE                          " + hEnter		
			cQuery += "AND      SA2.A2_LOJA       = SD1.D1_LOJA                             " + hEnter				
			cQuery += "AND      SA2.A2_X_TIPO     = 'P'			                            " + hEnter				
		    cQuery += "AND   	SA2.A2_X_LINHA	BETWEEN 	'" + mv_par04 + "' 		   		" + hEnter
			cQuery += "AND                 		    		'" + mv_par05 + "'				" + hEnter
			cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 									" + hEnter
			cQuery += "WHERE    SE1.E1_FILIAL     = '" + aDADOSTMP[nI][02] + "'				" + hEnter
			cQuery += "AND 		SE1.E1_PREFIXO    = 'FRT'		                            " + hEnter
			cQuery += cCondSE1
			cQuery += "AND 		SE1.D_E_L_E_T_   != '*' 									" + hEnter

			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
		 	If (cAliasTMP)->(!EOF())
		 		aDADOSTMP[nI][07] += (cAliasTMP)->E1_VALOR
		 	EndIf
			(cAliasTMP)->(dbCloseArea())
			IncRegua()			
			 		
 		Next nI 		
 	EndIf
 	

	If Len(aDADOSTMP) > 0
		For nI := 1 to Len(aDADOSTMP)
			If Len(aDADOSTOT) == 0
				nPOS := 0
			Else
				nPOS := aScan( aDADOSTOT, { |x| x[1] == aDADOSTMP[nI][02] } )
			EndIf
			If nPOS == 0
				aAdd ( aDADOSTOT, { aDADOSTMP[nI][02], 0, 0, 0, 0, 0 } )
				nPOS := Len(aDADOSTOT)
			EndIf
			aDADOSTOT[nPOS][02] += aDADOSTMP[nI][03]
			aDADOSTOT[nPOS][03] += aDADOSTMP[nI][04]
			aDADOSTOT[nPOS][04] += aDADOSTMP[nI][05]
			aDADOSTOT[nPOS][05] += aDADOSTMP[nI][06]
			aDADOSTOT[nPOS][06] += aDADOSTMP[nI][07]
		Next nI
	EndIf
	
	If Len(aDADOSTOT) > 0
		For nI := 1 to Len(aDADOSTOT)
			If nLin > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
				nLin := 8
			EndIf                                                         
			nPRCMEDBRT := aDADOSTOT[nI,04] / aDADOSTOT[nI,03]
			nPRCMEDLIQ := (aDADOSTOT[nI,04]-aDADOSTOT[nI,05]-aDADOSTOT[nI,06]) / aDADOSTOT[nI,03]
			@nLin,01 PSAY "Filial...............: " + aDADOSTOT[nI,01]
			nLin +=1
			@nLin,01 PSAY "N๚m. Produtores......: " + Transform(aDADOSTOT[nI,02], "@E 99999999999999")
			nLin +=1
			@nLin,01 PSAY "Quantidade Leite.....: " + Transform(aDADOSTOT[nI,03], "@E 99,999,999,999")
			nLin +=1
			@nLin,01 PSAY "Total Bruto..........: " + Transform(aDADOSTOT[nI,04], "@E 999,999,999.99")
			nLin +=1
			@nLin,01 PSAY "Total Funrural.......: " + Transform(aDADOSTOT[nI,05], "@E 999,999,999.99")
			nLin +=1
			@nLin,01 PSAY "Total Frete..........: " + Transform(aDADOSTOT[nI,06], "@E 999,999,999.99")
			nLin +=1
			@nLin,01 PSAY "Pre็o M้dio Bruto....: " + Transform(nPRCMEDBRT, "@E 9,999,999.9999")
			nLin +=1
			@nLin,01 PSAY "Pre็o M้dio Liquido..: " + Transform(nPRCMEDLIQ, "@E 9,999,999.9999")
			nLin +=2
		Next nI
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
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
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
	aAdd(aRegs,{cPerg,"01","Ano Refer๊ncia     ?","Ano Refer๊ncia     ?","Ano Refer๊ncia     ?","mv_ch1","N",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","M๊s Inicial        ?","M๊s Inicial        ?","M๊s Inicial        ?","mv_ch2","N",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"03","M๊s Final          ?","M๊s Final          ?","M๊s Final          ?","mv_ch3","N",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"05","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"06","Filial De          ?","Filial De          ?","Filial De          ?","mv_ch6","C",TAMSX3("ZL0_FILIAL")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", " ","","",""})
	aAdd(aRegs,{cPerg,"07","Filial At้         ?","Filial At้         ?","Filial At้         ?","mv_ch7","C",TAMSX3("ZL0_FILIAL")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", " ","","",""})

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