#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL001 บAutor  ณRafael Parma         บ Data ณ  22/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de demonstrativo de pagamento.          บฑฑ
ฑฑบ          ณPor Linha / Produtor.AKI                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL001()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "DEMONSTRATIVO DE PAGAMENTO - PRODUTOR"
Private cPict        := ""
Private titulo       := "DEMONSTRATIVO DE PAGAMENTO - PRODUTOR"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := "" 
Private imprime      := .T.
Private aOrd         := {}         
Private cPerg        := "LTREL00001"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LTREL001"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL001"
Private nPOSCOL      := 6
Public DATE_NULL     := ctod("  /  /  ")
Public STRING_NULL   := ""
Public cTIPO_PRD     := "P "
Public cTIPO_TRP     := "T "
Public lATPERCFOR    := SuperGetMV("MV_ZLATPN",,.F.)	// Ativo controle de percentual s/ fornecedor p/ gerar documento 
Public lIMPSE1       := SuperGetMV("MV_ZLISE1",,.F.) 
Public lIMPSE2       := SuperGetMV("MV_ZLISE2",,.F.) 
Public lTITFRETE     := SuperGetMV("MV_ZLHTFR",,.F.)	// Habilita gera็ใo de tํtulos de frete a pagar/receber no fechamento mensal do produtor.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZL5"
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
       
*-----------------------------------*
Static Function ReportPrd()          
*-----------------------------------*

Local nCol         := 60				// coluna de impressใo
Local nQTD_TOTAL   := 0					// quantidade total em litros
Local nPRC_LITRO   := 0					// pre็o total dos litros  
Local nPRC_FRETE   := 0					// pre็o por litro de frete
Local nVLR_PROD    := 0					// valor total da produ็ใo   
Local nVLR_DESP    := 0					// valor total de despesas
Local nVLR_CRED    := 0					// valor total de creditos
Local cPRODUT      := ""				// c๓digo do produtor
Local cLOJPRD      := ""				// loja do produtor
Local cLINHA       := ""				// linha do produtor
Local cAliasTMP    := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13) 
Local lSTART_DATE  := .F.
Local lEND_DATE    := .F.
Local dSTART_DATE  := ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do perํodo
Local dEND_DATE    := dSTART_DATE		// ๚ltimo dia do perํodo
Local dCURR_DATE   := dSTART_DATE      	// dia do registro em processamento
Local dLAST_DATE   := dSTART_DATE		// ๚ltimo dia impresso
Local aDADOSIMP    := {}


	If U_YIsBis(mv_par02) 
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","29","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))
    Else
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","28","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))   
    EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "SELECT 	ZL5.ZL5_COD,												" + hEnter
	cQuery += "			ZL5.ZL5_LINHA,  											" + hEnter    
	cQuery += "			ZL5.ZL5_TRANSP, 											" + hEnter
	cQuery += "			ZL5.ZL5_NOMTRP, 											" + hEnter	
	cQuery += "			ZL5.ZL5_DATA,												" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
	cQuery += "			SA2.A2_NOME,   												" + hEnteR
	cQuery += "			ZL6.ZL6_QTDE												" + hEnter
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" + hEnter
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          " + hEnter		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             " + hEnter		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" + hEnter
	cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	" + hEnter		
	cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	" + hEnter		
	cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "' 				" + hEnter
    
    // filtro por linha
    If mv_par09 == 1   
		cQuery += "AND ( ZL5.ZL5_LINHA  BETWEEN '" + mv_par03       + "' 			" + hEnter
		cQuery += "AND                 		    '" + mv_par04       + "' )			" + hEnter
    // filtro por produtor
    Else                  
		cQuery += "AND ( ZL6.ZL6_PRODUT BETWEEN '" + mv_par05       + "' 			" + hEnter
		cQuery += "AND                		    '" + mv_par06       + "' )			" + hEnter
		cQuery += "AND ( ZL6.ZL6_LOJPRD BETWEEN '" + mv_par07       + "' 			" + hEnter
		cQuery += "AND                          '" + mv_par08       + "' )			" + hEnter
    EndIf

	cQuery += "AND 		( SA2.A2_COND  BETWEEN '" + mv_par14       + "' 			" + hEnter
	cQuery += "AND      	           		 '" + mv_par15       + "' )				" + hEnter

	cQuery += "AND 		( ZL5.ZL5_DATA       BETWEEN '" + DTOS(dSTART_DATE) + "' 	" + hEnter
	cQuery += "AND      	                    	 '" + DTOS(dEND_DATE)   + "' )	" + hEnter
	cQuery += "AND 		ZL5.ZL5_STATUS         = '' 								" + hEnter
	cQuery += "AND 		ZL6.ZL6_QTDE           > 0 									" + hEnter
	cQuery += "AND 		ZL5.D_E_L_E_T_        != '*' 								" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_        != '*' 								" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_        != '*' 								" + hEnter
    
    // filtro por linha
    If mv_par09 == 1   
		If mv_par10 == 1
			cQuery += "ORDER BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 						" + hEnter
			cQuery += "			ZL6.ZL6_LOJPRD, ZL5.ZL5_DATA						" + hEnter
		Else
			cQuery += "ORDER BY ZL5.ZL5_LINHA, SA2.A2_NOME, ZL5.ZL5_DATA			" + hEnter
		EndIf		
	
	// filtro por produtor
	Else
		If mv_par10 == 1                                                                                        
			cQuery += "ORDER BY ZL6.ZL6_PRODUT, ZL6.ZL6_LOJPRD, ZL5.ZL5_DATA 		" + hEnter
		Else 
			cQuery += "ORDER BY SA2.A2_NOME, ZL5.ZL5_DATA 					   		" + hEnter
		EndIf
	EndIf
                        
	memowrite("LTREL001_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
   	
 	While (cAliasTMP)->(!EOF())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ posi็ใo do produtor                                          			ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        
		If Len(aDADOSIMP) > 0
			nPOS := aScan ( aDADOSIMP, { |x| x[1] == (cAliasTMP)->ZL6_PRODUT .and. x[2] == (cAliasTMP)->ZL6_LOJPRD } )
		Else
			nPOS := 0
		EndIf
		
		If nPOS == 0
			
			aAdd ( aDADOSIMP, { (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL5_TRANSP, (cAliasTMP)->ZL5_NOMTRP, {}, (cAliasTMP)->A2_NOME } )
			nPOS := Len(aDADOSIMP)
		EndIf
				                                                                        

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ troca de produtor                                          				ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ				
	
	    If cPRODUT != (cAliasTMP)->ZL6_PRODUT .or. cLOJPRD != (cAliasTMP)->ZL6_LOJPRD	       
            
			If cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL
				nPOS := aScan ( aDADOSIMP, { |x| x[1] == cPRODUT .and. x[2] == cLOJPRD } )
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ perํodo final sem movimentos                               				ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		   	
		   	If ! lEND_DATE .and. lSTART_DATE
				nTOT := ( dEND_DATE - dLAST_DATE )
				For nI := 1 to nTOT
					If nPOS != 0
						aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dLAST_DATE + nI) , 0 } )
					EndIf
				Next nI
				lEND_DATE := .T.
			EndIf
	                                                                                     
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Limpeza dos totalizadores                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	        nQTD_TOTAL   := 0
	        nPRC_LITRO   := 0
	        nPRC_FRETE   := 0
	        nVLR_PROD    := 0
	        nVLR_DESP    := 0
	        nVLR_CRED    := 0
	        dLAST_DATE   := dSTART_DATE
	        dCURR_DATE   := dSTART_DATE
	        lSTART_DATE  := .F.
			lEND_DATE    := .F.
	    	
	    	nPOS := aScan ( aDADOSIMP, { |x| x[1] == (cAliasTMP)->ZL6_PRODUT .and. x[2] == (cAliasTMP)->ZL6_LOJPRD } )
	        
	    Endif                             
	    
	   	cPRODUT := (cAliasTMP)->ZL6_PRODUT  
	   	cLOJPRD := (cAliasTMP)->ZL6_LOJPRD
	   	cLINHA  := (cAliasTMP)->ZL5_LINHA
	   	
	   	nQTD_TOTAL += (cAliasTMP)->ZL6_QTDE
	   	dCURR_DATE := STOD( (cAliasTMP)->ZL5_DATA )
	   	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ perํodo inicial                                              			ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		
	   	If ! lSTART_DATE
		   	If dCURR_DATE == dSTART_DATE 
		   		lSTART_DATE := .T.
			EndIf
			If ! lSTART_DATE   
				nTOT := (( dCURR_DATE - dSTART_DATE ) - 1 )
				For nI := 0 to nTOT
					If nPOS != 0
						aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dSTART_DATE + nI) , 0 } )
						dLAST_DATE := dSTART_DATE + nI
					EndIf										
				Next nI
				lSTART_DATE := .T.
			EndIf
		EndIf
		                        
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ perํodo intermediแrio sem movimentos                       				ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

		If (dLAST_DATE + 1) < dCURR_DATE
			nTOT := (( dCURR_DATE - dLAST_DATE ) - 1 )
			For nI := 1 to nTOT
				If nPOS != 0
					aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dLAST_DATE + 1) , 0 } )
					dLAST_DATE := dLAST_DATE + 1
				EndIf								
			Next nI	
		Endif
		   
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ movimento atual                                            				ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

		If nPOS != 0
			aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dCURR_DATE), (cAliasTMP)->ZL6_QTDE } )
		EndIf		
		dLAST_DATE := dCURR_DATE   

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ ๚ltima data                                                				ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		
	   	If ! lEND_DATE
		   	If dLAST_DATE == dEND_DATE 
		   		lEND_DATE := .T.
			EndIf
		EndIf		
		
	    (cAliasTMP)->(dbSkip())
	   		
	EndDo

	(cAliasTMP)->(dbCloseArea())
                
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ perํodo final sem movimentos                               				ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

   	If ! lEND_DATE .and. lSTART_DATE
		nTOT := ( dEND_DATE - dLAST_DATE )
		For nI := 1 to nTOT
			If nPOS != 0
				aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dLAST_DATE + nI) , 0 } )
			EndIf			
		Next nI
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ indexa็ใo dos dados                                          			ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	If Len(aDADOSIMP) > 0
		If mv_par10 == 1	// Ordena por linha + c๓digo produtor
			aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[3]+x[1] < y[3]+y[1] } )
		Else	// Ordena por linha + nome produtor
			aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[3]+x[7] < y[3]+y[7] } )
		Endif
		
		For nI := 1 to Len(aDADOSIMP)
			aDADOSIMP[nI][nPOSCOL] := aSort( aDADOSIMP[nI][nPOSCOL],,,{ |x,y| x[1] < y[1] } )	
		Next nI	
	EndIf

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ impressใo dos dados                                          			ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	
	If Len(aDADOSIMP) > 0
		
		For nY := 1 to Len(aDADOSIMP)

		    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		    //ณ Impressao do cabecalho do relatorio. . .                            ณ
		    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
	        Cabec1 := "Perํodo de: " + DTOC(dSTART_DATE) + " at้: " + DTOC(dEND_DATE)
			Cabec2 := "Transportador: " + aDADOSIMP[nY,4] + "/" + ALLTRIM(aDADOSIMP[nY,5])			
	        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressใo dos dados do produtor                                         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	        nLin := 8
	        nCol := 60
	        fCabecPrd( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], .T., @nLin )	        
	                                                                                     
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Limpeza dos totalizadores                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	        nQTD_TOTAL   := 0
	        nPRC_LITRO   := 0
	        nPRC_FRETE   := 0
	        nVLR_PROD    := 0
	        nVLR_DESP    := 0
	        nVLR_CRED    := 0
	        nLin += 1
	        
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ impressใo dos movimentos diarios                             			ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				    
		   	For nJ := 1 to Len(aDADOSIMP[nY][nPOSCOL])

			   	nQTD_TOTAL += aDADOSIMP[nY][nPOSCOL][nJ][2]
			   	lInc := .F.
				
				nCol := 0
				If nJ <= 10
					@nLin,nCol 		PSAY aDADOSIMP[nY][nPOSCOL][nJ][1] 
					@nLin,nCol+10	PSAY ": " + TRANSFORM(aDADOSIMP[nY][nPOSCOL][nJ][2],"@E 999,999")		
					lInc := .T.
				EndIf

				nCol := 30
				If nJ+10 <= 20
					@nLin,nCol 		PSAY aDADOSIMP[nY][nPOSCOL][nJ+10][1] 
					@nLin,nCol+10	PSAY ": " + TRANSFORM(aDADOSIMP[nY][nPOSCOL][nJ+10][2],"@E 999,999")		
					lInc := .T.
				EndIf

				nCol := 60                             
				If nJ+20 <= Len(aDADOSIMP[nY][nPOSCOL])
					@nLin,nCol 		PSAY aDADOSIMP[nY][nPOSCOL][nJ+20][1] 
					@nLin,nCol+10	PSAY ": " + TRANSFORM(aDADOSIMP[nY][nPOSCOL][nJ+20][2],"@E 999,999")					   		
					lInc := .T.
				EndIf
                                                                                                            
				If lInc 
					nLin += 1		   						
				EndIf

		   	Next nJ

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressใo das despesas e totalizadores do produtor no perํodo           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		    
			fTotalDesp( dSTART_DATE, dEND_DATE, aDADOSIMP[nY,1], aDADOSIMP[nY,2], @nVLR_DESP, @nVLR_CRED, @nLin )
			
			fCalcProd ( dSTART_DATE, mv_par11, aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], nQTD_TOTAL, @nPRC_LITRO, @nVLR_PROD, @nPRC_FRETE )
		  	fTotalPrd ( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nVLR_DESP, nVLR_CRED, nPRC_FRETE, @nLin )
		  	fResAnlPrd( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], dSTART_DATE, dEND_DATE, @nLin )
		  	
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
		 		nLin := 8
		 		fCabecPrd( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], .F., @nLin )	                     
		    EndIf		  	
		  	
		  	//-- Impressใo anแlise coleta a campo
		  	If mv_par16 == 2
		  		fResAnlCpo( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], dSTART_DATE, dEND_DATE, @nLin )
		  	EndIf
		  	
			If nLin > 60 .and. !Empty(mv_par18)
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
		 		nLin := 8
		 		fCabecPrd( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], .F., @nLin )	                     
		    Else
	            //--Impressใo de mensagens
			  	fImpMensag( mv_par18, mv_par19, mv_par20, @nLin )
		    
		    EndIf		  	          
		    

		  	
		Next nY
	
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
ฑฑบPrograma  ณfLinColPrd บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo de linha e coluna de impressใo do produtor.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/          
*-----------------------------------------*        
Static Function fLinColPrd(nLin, nCol)
*-----------------------------------------*                                                           

   	If nCol == 0
   		nCol := 30
   	ElseIf nCol == 30
   		nCol := 60
   	ElseIf nCol == 60
   		nCol := 0
   		nLin += 1
   	EndIf
   	
Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalcProd  บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo do pre็o a ser pago ao produtor com base nas      บฑฑ
ฑฑบ          ณtabelas de pre็os por faixa ou tabela de exce็ใo.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/              
*----------------------------------------------------------------------------------------------------------------*        
Static Function fCalcProd( dSTART_DATE, nEXCECAO, cPRODUT, cLOJPRD, cLINHA, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nPRC_FRETE )           
*----------------------------------------------------------------------------------------------------------------*        

	nVLR_PROD  := 0
	nPRC_LITRO := 0
	nPRC_FRETE := 0  

	
	if month(dSTART_DATE) == month(ddatabase) .and. year(dSTART_DATE) == year(ddatabase)
	
		if nEXCECAO == 1 	// Cadastro do produtor
			
			dbselectarea("SA2")
			dbsetorder(1)
			dbgotop()
			if dbseek ( xfilial("SA2") + cPRODUT + cLOJPRD )
				if ! empty ( SA2->A2_X_FAIXA )
					dbselectarea("ZL2")
					dbsetorder(1)
					dbgotop()
					if dbseek ( xfilial("ZL2") + SA2->A2_X_FAIXA )
						nPRC_LITRO := ZL2->ZL2_PRCLEI
						nPRC_FRETE := ZL2->ZL2_PRCFRT	
					endif
				else
					dbselectarea("ZL2")
					dbsetorder(2)
					dbgotop()   
					if dbseek ( xfilial("ZL2") + cLINHA )
						while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
							if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
								nPRC_LITRO := ZL2->ZL2_PRCLEI
								nPRC_FRETE := ZL2->ZL2_PRCFRT
								Exit
							endif
							ZL2->(dbskip())
						enddo
					endif
				endif	
			endif 
			
	    else	// tabela de exce็๕es
	    
			dbselectarea("ZL2")
			dbsetorder(3)	// ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
			dbgotop()                                            
			if dbseek ( xfilial("ZL2") + cLINHA + cPRODUT + cLOJPRD, .T. )
				nPRC_LITRO := ZL2->ZL2_PRCLEI                
				nPRC_FRETE := ZL2->ZL2_PRCFRT
			else
				dbselectarea("ZL2")
				dbsetorder(2)	// // ZL2_FILIAL+ZL2_LINHA
				dbgotop()   
				if dbseek ( xfilial("ZL2") + cLINHA )
					while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
						if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
							nPRC_LITRO := ZL2->ZL2_PRCLEI
							nPRC_FRETE := ZL2->ZL2_PRCFRT
							Exit
						endif
						ZL2->(dbskip())
					enddo
				endif
			endif     
	    
	    endif                               
	    
	
	Else

		cMV_ZLTPRD	:= AllTRIM(GetMV("MV_ZLTPRD"))		//-- c๓digo do produto
		cANOMES		:= cvaltochar(year(dSTART_DATE))+STRZero(month(dSTART_DATE),2)
		hEnter		:= chr(10)+chr(13)                    
		cAliasTMP	:= GetNextAlias()
		
		//Perํodos anteriores a 12/2014 as notas eram emitidas no m๊s seguinte.
		If cANOMES < "201411"
			nANO := SubSTR(cANOMES,1,4)
			nMES := Val(SubSTR(cANOMES,5,2))
			nMES += 1
			If nMES == 13
				nMES := 1
				nANO += 1
			EndIf
			cANOMES := cValToChar(nANO)+STRZero(nMES,2)
			cCondSD1 := "AND 	SUBSTR(SD1.D1_EMISSAO,1,6) = '" + cANOMES  + "' 		" + hEnter	
		ElseIf cANOMES == "201411"
			cCondSD1 := "AND 	SD1.D1_EMISSAO		  >= '20141201'			 			" + hEnter
			cCondSD1 += "AND 	SD1.D1_EMISSAO		   < '20141231'			 			" + hEnter
		ElseIf cANOMES == "201412"
			cCondSD1 := "AND 	SD1.D1_EMISSAO		   = '20141231'			 			" + hEnter	
		Else
			cCondSD1 := "AND 	SUBSTR(SD1.D1_EMISSAO,1,6) = '" + cANOMES  + "' 		" + hEnter			
		EndIf


		cQuery := "SELECT	SUM(SD1.D1_TOTAL) D1_TOTAL,									" + hEnter
		cQuery += "			SUM(SD1.D1_QUANT) D1_QUANT,									" + hEnter
		cQuery += "			SUM(SD1.D1_VALDEV) D1_VALDEV,								" + hEnter
		cQuery += "			SUM(SD1.D1_QTDEDEV) D1_QTDEDEV								" + hEnter
		cQuery += "FROM " + RetSqlName("SD1") + " SD1									" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2   							" + hEnter
		cQuery += "ON       SA2.A2_COD        = SD1.D1_FORNECE                          " + hEnter		
		cQuery += "AND      SA2.A2_LOJA       = SD1.D1_LOJA                             " + hEnter				
		cQuery += "AND      SA2.A2_X_TIPO     = 'P'			                            " + hEnter
	    cQuery += "AND   	SA2.A2_X_LINHA	  = '" + cLINHA + "' 		   				" + hEnter
		cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 									" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1   							" + hEnter
		cQuery += "ON       SF1.F1_FILIAL     = SD1.D1_FILIAL                           " + hEnter		
		cQuery += "AND      SF1.F1_DOC        = SD1.D1_DOC                              " + hEnter		
		cQuery += "AND      SF1.F1_SERIE      = SD1.D1_SERIE                            " + hEnter		
		cQuery += "AND      SF1.F1_FORNECE    = SD1.D1_FORNECE                          " + hEnter		
		cQuery += "AND      SF1.F1_LOJA       = SD1.D1_LOJA                             " + hEnter		
		cQuery += "AND 		SF1.F1_TIPO       = 'N'					 					" + hEnter
		cQuery += "AND 		SF1.F1_ESPECIE    = 'SPED'		                            " + hEnter
		cQuery += "AND 		SF1.D_E_L_E_T_   != '*' 									" + hEnter	
		cQuery += "WHERE    SD1.D1_FORNECE    = '" + cPRODUT + "'						" + hEnter
		cQuery += "AND      SD1.D1_LOJA       = '" + cLOJPRD + "'						" + hEnter
		cQuery += cCondSD1
		cQuery += "AND 		SD1.D1_COD	      = '" + cMV_ZLTPRD + "' 					" + hEnter
		cQuery += "AND 		SD1.D_E_L_E_T_   != '*' 									" + hEnter

		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)			
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
	 	If (cAliasTMP)->(!EOF())
	 		nVALTOT := ((cAliasTMP)->D1_TOTAL -  (cAliasTMP)->D1_VALDEV)
	 		nQTDTOT := ((cAliasTMP)->D1_QUANT -  (cAliasTMP)->D1_QTDEDEV)
	 		If nQTDTOT > 0 .and. nVALTOT > 0
		 		nPRC_LITRO := Round(nVALTOT/nQTDTOT, 7)
		 	Endif
	 	EndIf
		(cAliasTMP)->(dbCloseArea())  

                
		If nPRC_LITRO == 0

			if nEXCECAO == 1 	// Cadastro do produtor
				
				dbselectarea("SA2")
				dbsetorder(1)
				dbgotop()
				if dbseek ( xfilial("SA2") + cPRODUT + cLOJPRD )
					if ! empty ( SA2->A2_X_FAIXA )
						dbselectarea("ZL2")
						dbsetorder(1)
						dbgotop()
						if dbseek ( xfilial("ZL2") + SA2->A2_X_FAIXA )
							nPRC_LITRO := ZL2->ZL2_PRCLEI
							nPRC_FRETE := ZL2->ZL2_PRCFRT	
						endif
					else
						dbselectarea("ZL2")
						dbsetorder(2)
						dbgotop()   
						if dbseek ( xfilial("ZL2") + cLINHA )
							while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
								if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
									nPRC_LITRO := ZL2->ZL2_PRCLEI
									nPRC_FRETE := ZL2->ZL2_PRCFRT
									Exit
								endif
								ZL2->(dbskip())
							enddo
						endif
					endif	
				endif 
				
		    else	// tabela de exce็๕es
		    
				dbselectarea("ZL2")
				dbsetorder(3)	// ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
				dbgotop()                                            
				if dbseek ( xfilial("ZL2") + cLINHA + cPRODUT + cLOJPRD, .T. )
					nPRC_LITRO := ZL2->ZL2_PRCLEI                
					nPRC_FRETE := ZL2->ZL2_PRCFRT
				else
					dbselectarea("ZL2")
					dbsetorder(2)	// // ZL2_FILIAL+ZL2_LINHA
					dbgotop()   
					if dbseek ( xfilial("ZL2") + cLINHA )
						while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
							if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
								nPRC_LITRO := ZL2->ZL2_PRCLEI
								nPRC_FRETE := ZL2->ZL2_PRCFRT
								Exit
							endif
							ZL2->(dbskip())
						enddo
					endif
				endif     
		    
		    endif                               
	
		endif	

	endif    
        
    
   	if nPRC_LITRO != 0
   		nVLR_PROD := Round ( nPRC_LITRO * nQTD_TOTAL , 7)
   	endif    

return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPrtLinePrd  บAutor  ณRafael Parma     บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo da linha do movimento do produtor.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/	   	
*----------------------------------------------------------------------------------------------------*        
Static Function fPrtLinePrd( cDATA, nQTDE, nLin, nCol )                                                       
*----------------------------------------------------------------------------------------------------*        
      
	@nLin,nCol 		PSAY cDATA 
	@nLin,nCol+10	PSAY ": " + TRANSFORM(nQTDE,"@E 999,999")
	
Return
    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCabecPrd  บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo dos dados do produtor.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------------------------------------------------------------*        
Static Function fCabecPrd(cPRODUT, cLOJPRD, cLINHA, lImpPROD, nLin)                                           
*----------------------------------------------------------------------------------------------------*        
	      
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek( xFilial("SA2") + cPRODUT + cLOJPRD )                           

	dbSelectArea("ZL0")
	dbSetOrder(1)
	dbGoTop()
	dbSeek( xFilial("ZL0") + cLINHA ) 
		
	nLin += 1
	@nLin,000 PSAY "Produtor..: " + cPRODUT + "/" + cLOJPRD + "-" + SubSTR(SA2->A2_NOME,1,25)
	@nLin,054 PSAY IIF(SA2->A2_TIPO=="J","CNPJ..: "+TRANSFORM(SA2->A2_CGC,"@R 99.999.999/9999-99"),"CPF..: "+TRANSFORM(SA2->A2_CGC,"@R 999.999.999-99"))
	nLin += 1
	@nLin,000 PSAY "Endere็o..: " + ALLTRIM(SA2->A2_END) + " - " + ALLTRIM(SA2->A2_MUN) + "/" + SA2->A2_EST
	nLin += 1                                                                                               
	@nLin,000 PSAY "Linha.....: " + cLINHA + "/" + ALLTRIM(ZL0->ZL0_DESC)
	nLin += 1                                                                                               
	@nLin,000 PSAY "Pagamento.: " + IIF(SA2->A2_X_FPGTO=="C","CHEQUE","DEPOSITO - BANCO/AGENCIA/CONTA: " + ALLTRIM(SA2->A2_BANCO) + "/" + SA2->A2_AGENCIA + "/" + SA2->A2_NUMCON)
	
	If lImpPROD
		nLin += 1         
		@nLin,000 PSAY __PrtThinLine() 
		nLin += 1
		@nLin,032 PSAY " P R O D U ว ร O " 
		nLin += 1
		@nLin,000 PSAY __PrtThinLine() 
	EndIf
		
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotalPrd  บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo dos totalizadores do produ- บฑฑ
ฑฑบ          ณtor.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------------------------------------------------------------*        
Static Function fTotalPrd( cPRODUT, cLOJPRD, cLINCOL, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nVLR_DESP, nVLR_CRED, nPRC_FRETE, nLin )
*----------------------------------------------------------------------------------------------------*        
Local nFUNRURAL := 0  
local nSENAR := 0
Local nLIQUIDO  := 0
Local nPRCUNLIQ := nPRC_LITRO - nPRC_FRETE 
Local nPCFAT    := 0
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// c๓digo da TES de movimento
Local nAlsenar := POSICIONE("SF4",1,xFilial("SF4")+cMV_ZLTTES,"F4_ALSENAR")
Local nAlInss   := 0
	lImpDescFRT := .F.
	If lTITFRETE
		If fCheckTPF() .AND. nPRC_FRETE > 0	//Verifica se transportador ้ pessoa fํsica
			nVLRTRANSP := Round(nPRC_FRETE * nQTD_TOTAL, 7 ) 
			lImpDescFRT := .T.
		Else
			nPRCUNLIQ := nPRC_LITRO
		EndIf		
	EndIf


	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek( xFilial("SA2") + cPRODUT + cLOJPRD )
	cTipoRur  := SA2->A2_TIPORUR
	aPFunRur  := FunRur()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณaPFunRur[1]  == "F"ณ
	//ณaPFunRur[2]  == "L"ณ
	//ณaPFunRur[3]  == "J"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nPosPer   := at(cTipoRur,"FLJ")
	nPCFAT    := SA2->A2_X_PCDOC
	nAlInss := POSICIONE("SED",1,XFILIAL("SED")+SA2->A2_NATUREZ,"ED_PERCINS")
	If nPosPer > 0 
		If cTipoRur != "J"
			If cTipoRur = "F"
		  		nAliquota := Val(aPFunRur[nPosPer]) + nAlsenar + nAlInss
	   		ElseIf cTipoRur = "L"
				nAliquota := nAlsenar
	  		EndIf
	   		if SA2->A2_X_PCONT > 0
				nAliquota := SA2->A2_X_PCONT+ nAlsenar
			EndIf
			//-- Controle de serie de nota fiscal diferentes.
			If lATPERCFOR		
				nFUNRURAL := ( (nVLR_PROD * nPCFAT / 100) * nAliquota) /100
				nSENAR := ( (nVLR_PROD * nPCFAT / 100) * nAlsenar) /100
				nPRCUNLIQ := nPRCUNLIQ - (( (nPRCUNLIQ * nPCFAT / 100) * nAliquota) /100)
			Else		
				nFUNRURAL := (nVLR_PROD * nAliquota) /100
				nSENAR := (nVLR_PROD * nAlsenar) /100
				nPRCUNLIQ := nPRCUNLIQ - ((nPRCUNLIQ * nAliquota) /100)
			EndIf
		EndIf
	EndIf 
	
	nLIQUIDO  := Round( (nVLR_PROD + nVLR_CRED) - ( nFUNRURAL + nVLR_DESP ), 7) 

	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
 		nLin := 8
 		fCabecPrd( cPRODUT, cLOJPRD, cLINCOL, .F., @nLin )	                     
    EndIf

             
	nLin += 1
	@nLin,000 PSAY __PrtThinLine()
	nLin += 1
	@nLin,034 PSAY " T O T A I S " 	 
	nLin += 1
	@nLin,000 PSAY __PrtThinLine() 
	nLin += 1
	@nLin,000 PSAY "QUANTIDADE TOTAL PRODUZIDA EM LITROS :    " + TRANSFORM( nQTD_TOTAL, "@E 99,999,999" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "PREวO UNITมRIO EM LITROS BRUTO       : R$ " + TRANSFORM( nPRC_LITRO, "@E 9,999.9999" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "PREวO UNITมRIO EM LITROS LIQUIDO     : R$ " + TRANSFORM( nPRCUNLIQ , "@E 9,999.9999" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "VALOR TOTAL DA PRODUวรO           (+): R$ " + TRANSFORM( nVLR_PROD , "@E 999,999.99" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "FUNRURAL                          (-): R$ " + TRANSFORM( nFUNRURAL , "@E 999,999.99" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "DESCONTO DEBITOS                  (-): R$ " + TRANSFORM( nVLR_DESP , "@E 999,999.99" )
	nLin += 1                                                                                         
	If lImpDescFRT                                                                                             
		nLIQUIDO := nLIQUIDO - nVLRTRANSP 
		@nLin,000 PSAY "DESCONTO TRANSPORTADOR            (-): R$ " + TRANSFORM( nVLRTRANSP , "@E 999,999.99" )
		nLin += 1
	EndIf 
	@nLin,000 PSAY "ACRESCIMO CREDITOS                (+): R$ " + TRANSFORM( nVLR_CRED , "@E 999,999.99" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "TOTAL LIQUIDO A RECEBER              : R$ " + TRANSFORM( nLIQUIDO  , "@E 999,999.99" )
	nLin += 1                                                                                         	
	@nLin,000 PSAY __PrtThinLine() 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfResAnlPrd บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo dos resultados de anแlises  บฑฑ
ฑฑบ          ณnormativa 62.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------------------------------------------------------------*        
Static Function fResAnlPrd( cCODPRD, cLOJPRD, cLINCOL, dINICIAL, dFINAL, nLin )                               
*----------------------------------------------------------------------------------------------------*        

Local cAliasTMP := GetNextAlias()  
Local cQuery    := STRING_Null
Local hEnter	:= CHR(10) + CHR(13)
Local nCCS_MAX  := 0
Local nCBT_MAX  := 0
Local nSLT_MAX  := 0 
Local nGORD_MIN := 0
Local nPROT_MIN := 0
Local nLACT_MIN := 0
Local aParam    := {}

    // recupera os limites de gordura do parโmetro
	U_LTGETPMM("MV_ZLGORD",aParam)
	nGORD_MIN := aParam[1]            
	
    // recupera os limites de proteํna do parโmetro
	U_LTGETPMM("MV_ZLPROT",aParam)
	nPROT_MIN := aParam[1]

    // recupera os limites de lactose do parโmetro
	U_LTGETPMM("MV_ZLLACT",aParam)
	nLACT_MIN := aParam[1]                
	
    // recupera os limites de CCS do parโmetro
	U_LTGETPMM("MV_ZLCCS",aParam)	
	nCCS_MAX  := aParam[2]              
	
    // recupera os limites de CBT do parโmetro
	U_LTGETPMM("MV_ZLCBT",aParam)	
	nCBT_MAX  := aParam[2] 
	
	// recupera os limites de solidos totais do parโmetro
	U_LTGETPMM("MV_ZLSLT",aParam)
	nSLT_MAX  := aParam[1] //SuperGetMV("MV_ZLSLT",,"") 
 

	cQuery := "SELECT 	ZL8.ZL8_DATCOL,										" + hEnter
	cQuery += "			ZL9.ZL9_GORD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_PROTN, 										" + hEnter  
	cQuery += "			ZL9.ZL9_LACT,  										" + hEnter  
	cQuery += "			ZL9.ZL9_SOLD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CCS,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CBT  										" + hEnter    
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
	cQuery += "AND 		( ZL8.ZL8_DATCOL BETWEEN '" + dtos(dINICIAL) + "' 	" + hEnter
	cQuery += "AND             		             '" + dtos(dFINAL) + "' )	" + hEnter	
	cQuery += "AND 	 	ZL9.ZL9_PRODUT = '" + cCODPRD + "' 					" + hEnter
	cQuery += "AND 		ZL9.ZL9_LOJPRD = '" + cLOJPRD + "' 					" + hEnter
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL8.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL9.D_E_L_E_T_    != '*' 							" + hEnter	
 	cQuery += "ORDER BY ZL8.ZL8_PROTOC	 			 						" + hEnter	

	
	MemoWrite("LTREL001_2.SQL",cQuery)
	
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

    If ! Empty ( (cAliasTMP)->ZL8_DATCOL )

        If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
        	nLin := 8                                                                                
        	fCabecPrd( cCODPRD, cLOJPRD, cLINCOL, .F., @nLin )	                     
        EndIf
		
		nLin += 1
		@nLin,000 PSAY __PrtThinLine() 		
		nLin += 1
		@nLin,015 PSAY "R E S U L T A D O   D E   A N ม L I S E - IN 62"
		nLin += 1
		@nLin,000 PSAY __PrtThinLine() 
		nLin += 1
		@nLin,000 PSAY "DATA DA COLETA : "  + dtoc(stod((cAliasTMP)->ZL8_DATCOL))

		nLin += 1
		@nLin,000 PSAY "RESULTADOS : "
		@nLin,035 PSAY "PARยMETROS : "
	
		nLin += 1                                                                                         
		If (cAliasTMP)->ZL9_GORD != 0
			@nLin,000 PSAY "(%) GORDURA.........:  "+TRANSFORM((cAliasTMP)->ZL9_GORD,"@E 999.99")
		Else                                                                                                          
			@nLin,000 PSAY "(%) GORDURA.........: NรO ANALISADO."
		EndIf		
			@nLin,035 PSAY "(%) GORDURA MอNIMO.........: "+TRANSFORM(nGORD_MIN,"@E 999.99")
	
		nLin += 1
		If (cAliasTMP)->ZL9_PROTN != 0
			
			@nLin,000 PSAY "(%) PROTEอNA........:  "+TRANSFORM((cAliasTMP)->ZL9_PROTN,"@E 999.99")
		Else
			@nLin,000 PSAY "(%) PROTEอNA........: NรO ANALISADO."
		EndIf                   
			@nLin,035 PSAY "(%) PROTEอNA MอNIMO........: "+TRANSFORM(nPROT_MIN,"@E 999.99")
			
		nLin += 1
			If (cAliasTMP)->ZL9_LACT != 0
			@nLin,000 PSAY "(%) EXTR SECO DESENG:  "+TRANSFORM((cAliasTMP)->ZL9_LACT,"@E 999.99")
		Else 
			@nLin,000 PSAY "(%) EXTR SECO DESENG: NรO ANALISADO."
		EndIf                   
			@nLin,035 PSAY "(%) EXTR SECO DESENORDURADO: "+TRANSFORM(nLACT_MIN,"@E 999.99")
			
		nLin += 1
		If (cAliasTMP)->ZL9_SOLD != 0
			@nLin,000 PSAY "(%) EXTR SECO TOTAL.:  "+TRANSFORM((cAliasTMP)->ZL9_SOLD,"@E 999.99") 
		Else                                                                                                                 
			@nLin,000 PSAY "(%) EXTR SECO TOTAL.: NรO ANALISADO."
		EndIf
		    @nLin,035 PSAY "(%) EXTR SECO TOTAL MอNIMO.:  "+TRANSFORM(nSLT_MAX, "@E 999.99")
		
		nLin += 1
		If (cAliasTMP)->ZL9_CCS != 0             
			@nLin,000 PSAY "CCS (ML)............: "+TRANSFORM((cAliasTMP)->ZL9_CCS*1000,"@E 9,999,999")
		Else
			@nLin,000 PSAY "CCS (ML)............: NรO ANALISADO."
		EndIf
		@nLin,035 PSAY "CONTAGEM CษLULAS SOMมTICAS MมXIMO:"+TRANSFORM(nCCS_MAX*1000, "@E 9999,999")
	
		nLin += 1		
		If (cAliasTMP)->ZL9_CBT != 0
			@nLin,000 PSAY "CPP (UFC/ML)........: "+TRANSFORM((cAliasTMP)->ZL9_CBT*1000,"@E 9,999,999")
		Else 
			@nLin,000 PSAY "CPP (UFC/ML)........: NรO ANALISADO."
		EndIf
		@nLin,035 PSAY "CONTAGEM PADRAO EM PLACAS MมXIMO: "+TRANSFORM(nCBT_MAX*1000,"@E 9999,999")
		nLin += 2                                                                                         	
		@nLin,000 PSAY __PrtThinLine() 
	
	EndIf
	
	(cAliasTMP)->(dbCloseArea())
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfResAnlCpo บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo dos resultados de anแlises  บฑฑ
ฑฑบ          ณa campo.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------------------------------------------------------------*        
Static Function fResAnlCpo( cCODPRD, cLOJPRD, cLINCOL, dINICIAL, dFINAL, nLin )                               
*----------------------------------------------------------------------------------------------------*        

Local cAliasTMP := GetNextAlias()  
Local cQuery    := STRING_Null
Local hEnter	:= CHR(10) + CHR(13)
Local nCCS_MAX  := 0
Local nCBT_MAX  := 0
Local nSLT_MAX  := 0 
Local nGORD_MIN := 0
Local nPROT_MIN := 0
Local nLACT_MIN := 0
Local aParam    := {}


    // recupera os limites de gordura do parโmetro
	U_LTGETPMM("MV_ZLGORD",aParam)
	nGORD_MIN := aParam[1]            
	
    // recupera os limites de proteํna do parโmetro
	U_LTGETPMM("MV_ZLPROT",aParam)
	nPROT_MIN := aParam[1]

    // recupera os limites de lactose do parโmetro
	U_LTGETPMM("MV_ZLLACT",aParam)
	nLACT_MIN := aParam[1]                
	
    // recupera os limites de CCS do parโmetro
	U_LTGETPMM("MV_ZLCCS",aParam)	
	nCCS_MAX  := aParam[2]              
	
    // recupera os limites de CBT do parโmetro
	U_LTGETPMM("MV_ZLCBT",aParam)	
	nCBT_MAX  := aParam[2] 
	
	// recupera os limites de solidos totais do parโmetro
	U_LTGETPMM("MV_ZLSLT",aParam)
	nSLT_MAX  := aParam[2]

    // recupera os limites de alizarol do parโmetro
	U_LTGETPMM("MV_ZLALI",aParam)	
	nALZ_MIN  := aParam[1] 

    // recupera os limites de crioscopia do parโmetro
	U_LTGETPMM("MV_ZLCRIO",aParam)	
	nCRI_MIN  := aParam[1]*1000 
	nCRI_MAX  := aParam[2]*1000 

    // recupera os limites de densidade do parโmetro
	U_LTGETPMM("MV_ZLDENS",aParam)	
	nDEN_MIN  := aParam[1] 
	nDEN_MAX  := aParam[2] 
	
    // recupera os limites de EST do parโmetro
	U_LTGETPMM("MV_ZLEST",aParam)	
	nEST_MIN  := aParam[1] 

    // recupera os limites de ESD do parโmetro
	U_LTGETPMM("MV_ZLESD",aParam)	
	nESD_MIN  := aParam[1] 

    // recupera os limites de redutase do parโmetro
	U_LTGETPMM("MV_ZLRED",aParam)	
	nRED_MIN  := aParam[1]

    // recupera os limites de acidez do parโmetro
	U_LTGETPMM("MV_ZLACDZ",aParam)	
	nACD_MIN  := aParam[1]		
	nACD_MAX  := aParam[2]
	 

	//-- Filtro dos dados
	cQuery := "SELECT 														" + hEnter
	cQuery += "     	ZLA.ZLA_NUMERO,										" + hEnter
	cQuery += "     	ZLA.ZLA_DATA,										" + hEnter
	cQuery += "         ZLA.ZLA_ACID,										" + hEnter
	cQuery += "         ZLA.ZLA_CRIO,										" + hEnter
	cQuery += "         ZLA.ZLA_PERC,										" + hEnter
	cQuery += "         ZLA.ZLA_GORD,										" + hEnter
	cQuery += "         ZLA.ZLA_ESD,										" + hEnter
	cQuery += "         ZLA.ZLA_DENS,										" + hEnter
	cQuery += "         ZLA.ZLA_PROT,										" + hEnter
	cQuery += "         ZLA.ZLA_QTDE,										" + hEnter
	cQuery += "         ZLA.ZLA_LACT,										" + hEnter
	cQuery += "         ZLA.ZLA_CLORET,										" + hEnter
	cQuery += "         ZLA.ZLA_NEUTRA,										" + hEnter
	cQuery += "         ZLA.ZLA_RECONS,										" + hEnter	 
	cQuery += "         ZLA.ZLA_ALIZAR,										" + hEnter	 
	cQuery += "         ZLA.ZLA_EST,										" + hEnter	 
	cQuery += "         ZLA.ZLA_REDUTA,										" + hEnter	 
	cQuery += "         ZLA.ZLA_HIDSOD,										" + hEnter	 
	cQuery += "         ZLA.ZLA_BICARB,										" + hEnter	 
	cQuery += "         ZLA.ZLA_BORATO,										" + hEnter	 
	cQuery += "         ZLA.ZLA_PERHID,										" + hEnter	 
	cQuery += "         ZLA.ZLA_FORMOL,										" + hEnter	 
	cQuery += "         ZLA.ZLA_SACARO,										" + hEnter	 
	cQuery += "         ZLA.ZLA_AMIDO,										" + hEnter	 
	cQuery += "         ZLA.ZLA_ANALIS										" + hEnter	 
	/*
	cQuery += "         ZLA.ZLA_CCS,										" + hEnter	 
	cQuery += "         ZLA.ZLA_CBT											" + hEnter	 
	*/
	cQuery += "FROM " + RetSqlName("ZLA") + " ZLA							" + hEnter
	cQuery += "WHERE    ZLA.ZLA_FILIAL = '" + xFilial("ZLA") + "' 			" + hEnter
	cQuery += "AND 		ZLA.ZLA_PRODUT = '" + cCODPRD + "' 					" + hEnter
	cQuery += "AND 		ZLA.ZLA_LOJPRD = '" + cLOJPRD + "' 					" + hEnter
	cQuery += "AND 		( ZLA.ZLA_DATA   BETWEEN '" + dtos(dINICIAL) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(dFINAL) + "' )	" + hEnter
	cQuery += "AND 		ZLA.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "ORDER BY ZLA.ZLA_DATA										" + hEnter	

	MemoWrite("LTREL001_AC.SQL",cQuery)
	
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

    If ! (cAliasTMP)->(EOF())
        
        lImpLINE := .F.
        If nLin > 60
        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
        	nLin := 8
        	fCabecPrd( cCODPRD, cLOJPRD, cLINCOL, .F., @nLin )	                     
        	lImpLINE := .T.
        EndIf                          
                           
        If lImpLINE 
			nLin += 1
			@nLin,000 PSAY __PrtThinLine() 
		EndIf
		
		nLin += 1
		@nLin,013 PSAY "R E S U L T A D O   D E   A N ม L I S E  -  C A M P O"
		nLin += 1
		@nLin,000 PSAY __PrtThinLine() 
		nLin += 1
		@nLin,000 PSAY "NUMERO DA COLETA: "+(cAliasTMP)->ZLA_NUMERO 
		@nLin,035 PSAY "DATA DA COLETA : "+dtoc(stod((cAliasTMP)->ZLA_DATA))
		nLin += 1
		@nLin,000 PSAY "RESULTADOS : "
		@nLin,035 PSAY "PARยMETROS : "
	
		nLin += 1                                                                                         
		If (cAliasTMP)->ZLA_ALIZAR != 0
			@nLin,000 PSAY "(%) ALIZAROL......:  "+TRANSFORM((cAliasTMP)->ZLA_ALIZAR	,  "@E 999999")
		Else                                                                                                          
			@nLin,000 PSAY "(%) ALIZAROL......: NรO ANALISADO."
		EndIf		
		@nLin,035 PSAY "(%) ALIZAROL MอNIMO.: "+TRANSFORM(nALZ_MIN,"@E 999999")
	
		nLin += 1
		If (cAliasTMP)->ZLA_ACID != 0
			@nLin,000 PSAY "(%) ACIDEZ........:  "+TRANSFORM((cAliasTMP)->ZLA_ACID 		,  "@E 999999")
		Else
			@nLin,000 PSAY "(%) ACIDEZ........: NรO ANALISADO."
		EndIf                   
		@nLin,035 PSAY "(%) ACIDEZ..........: "+TRANSFORM(nACD_MIN,"@E 999999")+" /"+TRANSFORM(nACD_MAX,"@E 999999")
			
		nLin += 1
		If (cAliasTMP)->ZLA_CRIO != 0
			@nLin,000 PSAY "CRIOSCOPIA........:  "+TRANSFORM((cAliasTMP)->ZLA_CRIO 		,  "@E 999999")
		Else 
			@nLin,000 PSAY "CRIOSCOPIA........: NรO ANALISADO."
		EndIf                   
		@nLin,035 PSAY "CRIOSCOPIA..........: "+TRANSFORM(nCRI_MIN,"@E 999999")+" /"+TRANSFORM(nCRI_MAX,"@E 9999999")
			
		nLin += 1
		If (cAliasTMP)->ZLA_GORD != 0
			@nLin,000 PSAY "(%) GORDURA.......:  "+TRANSFORM((cAliasTMP)->ZLA_GORD 		,  "@E 999.99")
		Else                                                                                                                 
			@nLin,000 PSAY "(%) GORDURA.......: NรO ANALISADO."
		EndIf
		@nLin,035 PSAY "(%) GORDURA MอNIMO..: "+TRANSFORM(nGORD_MIN, "@E 999.99")
		
		nLin += 1
		If (cAliasTMP)->ZLA_DENS != 0             
			@nLin,000 PSAY "DENSIDADE.........:  "+TRANSFORM((cAliasTMP)->ZLA_DENS 		,  "@E 99999")
		Else
			@nLin,000 PSAY "DENSIDADE.........: NรO ANALISADO."
		EndIf
		@nLin,035 PSAY "DENSIDADE...........: "+TRANSFORM(nDEN_MIN,"@E 99.999")+" /"+TRANSFORM(nDEN_MAX,"@E 99.999")
	
		nLin += 1		
		If (cAliasTMP)->ZLA_EST != 0
			@nLin,000 PSAY "EST...............:  "+TRANSFORM((cAliasTMP)->ZLA_EST  		,  "@E 999.99")
		Else 
			@nLin,000 PSAY "EST...............: NรO ANALISADO."
		EndIf
		@nLin,035 PSAY "EST MอNIMO..........: "+TRANSFORM(nEST_MIN,"@E 999.99")


		nLin += 1		
		If (cAliasTMP)->ZLA_ESD != 0
			@nLin,000 PSAY "ESD...............:  "+TRANSFORM((cAliasTMP)->ZLA_ESD  		,  "@E 999.99")
		Else 
			@nLin,000 PSAY "ESD...............: NรO ANALISADO."
		EndIf
		@nLin,035 PSAY "ESD MอNIMO..........: "+TRANSFORM(nESD_MIN,"@E 999.99")


		nLin += 1		
		If (cAliasTMP)->ZLA_REDUTA != 0
			@nLin,000 PSAY "REDUTAZE..........:  "+TRANSFORM((cAliasTMP)->ZLA_REDUTA 	,  "@E 999999")
		Else 
			@nLin,000 PSAY "REDUTAZE..........: NรO ANALISADO."
		EndIf
		@nLin,035 PSAY "REDUTAZE MอNIMO.....: "+TRANSFORM(nRED_MIN,"@E 999999")


		nLin += 1		
		If !Empty((cAliasTMP)->ZLA_HIDSOD)
			@nLin,000 PSAY "HID.SำDIO.........: "+IIF((cAliasTMP)->ZLA_HIDSOD=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,000 PSAY "HID.SำDIO.........: NรO ANALISADO."
		EndIf

		
		If !Empty((cAliasTMP)->ZLA_BICARB)
			@nLin,035 PSAY "BICARBONATO.......: "+IIF((cAliasTMP)->ZLA_BICARB=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,035 PSAY "BICARBONATO.......: NรO ANALISADO."
		EndIf

		nLin += 1		
		If !Empty((cAliasTMP)->ZLA_CLORET)
			@nLin,000 PSAY "CLORETOS..........: "+IIF((cAliasTMP)->ZLA_CLORET=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,000 PSAY "CLORETOS..........: NรO ANALISADO."
		EndIf

		If !Empty((cAliasTMP)->ZLA_BORATO)
			@nLin,035 PSAY "BORATOS...........: "+IIF((cAliasTMP)->ZLA_BORATO=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,035 PSAY "BORATOS...........: NรO ANALISADO."
		EndIf

		nLin += 1		
		If !Empty((cAliasTMP)->ZLA_PERHID)
			@nLin,000 PSAY "PER.HIDROGสNIO....: "+IIF((cAliasTMP)->ZLA_PERHID=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,000 PSAY "PER.HIDROGสNIO....: NรO ANALISADO."
		EndIf

		If !Empty((cAliasTMP)->ZLA_FORMOL)
			@nLin,035 PSAY "FORMOL............: "+IIF((cAliasTMP)->ZLA_FORMOL=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,035 PSAY "FORMOL............: NรO ANALISADO."
		EndIf

		nLin += 1		
		If !Empty((cAliasTMP)->ZLA_SACARO)
			@nLin,000 PSAY "SACAROSE..........: "+IIF((cAliasTMP)->ZLA_SACARO=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,000 PSAY "SACAROSE..........: NรO ANALISADO."
		EndIf

		If !Empty((cAliasTMP)->ZLA_AMIDO)
			@nLin,035 PSAY "AMIDO.............: "+IIF((cAliasTMP)->ZLA_AMIDO=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,035 PSAY "AMIDO.............: NรO ANALISADO."
		EndIf
                    

		nLin += 1		
		If (cAliasTMP)->ZLA_PROT != 0
			@nLin,000 PSAY "PROTEINA..........: "+TRANSFORM((cAliasTMP)->ZLA_PROT 	,  "@E 999.99")
		Else 
			@nLin,000 PSAY "PROTEINA..........: NรO ANALISADO."
		EndIf
		
		If (cAliasTMP)->ZLA_LACT != 0
			@nLin,035 PSAY "LACTOSE...........: "+TRANSFORM((cAliasTMP)->ZLA_LACT 	,  "@E 999.99")
		Else 
			@nLin,035 PSAY "LACTOSE...........: NรO ANALISADO."
		EndIf


		nLin += 1		
		If !Empty((cAliasTMP)->ZLA_RECONS)
			@nLin,000 PSAY "RECONSTITUINTES...: "+IIF((cAliasTMP)->ZLA_RECONS=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,000 PSAY "RECONSTITUINTES...: NรO ANALISADO."
		EndIf

		If !Empty((cAliasTMP)->ZLA_NEUTRA)
			@nLin,035 PSAY "NEUTRALIZANTES....: "+IIF((cAliasTMP)->ZLA_NEUTRA=="P","POSITIVO","NEGATIVO")
		Else 
			@nLin,035 PSAY "NEUTRALIZANTES....: NรO ANALISADO."
		EndIf
            
		/*
		nLin += 1
		If (cAliasTMP)->ZLA_CCS != 0
			@nLin,000 PSAY "(%) CCS........:  "+TRANSFORM((cAliasTMP)->ZLA_CCS 		,  "@E 999999")
		Else
			@nLin,000 PSAY "(%) CCS........: NรO ANALISADO."
		EndIf                   
		
		If (cAliasTMP)->ZLA_CBT != 0
			@nLin,035 PSAY "(%) CBT........:  "+TRANSFORM((cAliasTMP)->ZLA_CBT 		,  "@E 999999")
		Else
			@nLin,035 PSAY "(%) CBT........: NรO ANALISADO."
		EndIf                   
		*/
		
		nLin += 2
		                                                                                         	
		@nLin,000 PSAY __PrtThinLine() 
	
	EndIf
	
	(cAliasTMP)->(dbCloseArea())
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotalDesp บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo das despesas do integrado   บฑฑ
ฑฑบ          ณcom base nas informa็๕es da conta corrente. Tabela ZLB.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------------------------------------------------------------*        
Static Function fTotalDesp( dSTART_DATE, dEND_DATE, cPRODUT, cLOJPRD, nVLR_DESP, nVLR_CRED, nLin )            
*----------------------------------------------------------------------------------------------------*        
Local lCabec     := .F.     
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10) + CHR(13) 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ DEBITO  															  . ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
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
	cQuery += "			ZLB.ZLB_HIST,  								    	" + hEnter
	cQuery += "			SX5.X5_DESCRI 										" + hEnter
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" + hEnter
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " + hEnter		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par12) + "'   	" + hEnter
	cQuery += "AND      				       '" + DTOS(mv_par13) + "'	    " + hEnter	
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'D'							    " + hEnter
    If mv_par17 != 1 
		cQuery += "AND 	ZLB.ZLB_STATUS    = ' '								" + hEnter		
	EndIf		
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter

                        
	memowrite("LTREL001_3.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nVLR_DESP  := 0 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressใo das despesas do produtor no perํodo                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	
	
		/*
                      1         2         3         4         5         6         7         8
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            ---------------------------------------------------------------------------------
		    DATA MOVIMENTO  VENCIMENTO  TIPO DA DESPESA                             VALOR(R$)
		*/  	
	
	While (cAliasTMP)->(!EOF())

		If ! lCabec
			nLin += 1                
			@nLin,000 PSAY __PrtThinLine() 
			nLin += 1
			@nLin,032 PSAY " D E B I T O S " 
			nLin += 1
			@nLin,000 PSAY __PrtThinLine()  
			nLin += 1                          
			@nLin,000 PSAY "DATA MOVIMENTO  VENCIMENTO  TIPO DA DESPESA                             VALOR(R$)" 
			lCabec := .T.
		EndIf
                          
		nLin += 1
		@nLin,000 PSAY DTOC( STOD( (cAliasTMP)->ZLB_DTMOV ) )
		@nLin,016 PSAY DTOC( STOD( (cAliasTMP)->ZLB_DTVCTO ) )
		@nLin,028 PSAY ALLTRIM(SubSTR((cAliasTMP)->X5_DESCRI,1,20))+" / "+ALLTRIM(SUBSTR((cAliasTMP)->ZLB_HIST,1,15))
		@nLin,070 PSAY TRANSFORM((cAliasTMP)->ZLB_VALOR,"@E 999,999.99")
		
		nVLR_DESP += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbSkip())

    EndDo

    (cAliasTMP)->(dbCloseArea())           

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
	//ณSeleciona todos os tํtulos em aberto do contas a receber p/ o produtor         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

	If lIMPSE1
	
		dbSelectArea("SA1")
		dbSetOrder(14) 	// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
		dbGoTop()
		If dbSeek ( xFilial("SA1") + SubSTR(cPRODUT,1,TAMSX3("A2_COD")[1]) + SubSTR(cLOJPRD,1,TAMSX3("A2_LOJA")[1]) )		
	
			cQuery := "	SELECT 															" + hEnter
			cQuery += "			SE1.E1_SALDO,											" + hEnter
			cQuery += "			SE1.E1_FILIAL,											" + hEnter
			cQuery += "			SE1.E1_PREFIXO,											" + hEnter
			cQuery += "			SE1.E1_NUM,   											" + hEnter
			cQuery += "			SE1.E1_PARCELA,											" + hEnter
			cQuery += "			SE1.E1_TIPO,  											" + hEnter
			cQuery += "			SE1.E1_CLIENTE,											" + hEnter
			cQuery += "			SE1.E1_LOJA,   											" + hEnter
			cQuery += "			SE1.E1_EMISSAO,   										" + hEnter
			cQuery += "			SE1.E1_VENCREA   										" + hEnter		
			cQuery += "	FROM " + RetSqlName("SE1") + " SE1								" + hEnter	
			cQuery += "	WHERE   SE1.E1_FILIAL    = '" + xFilial("SE1") + "' 			" + hEnter
			cQuery += "	AND     SE1.E1_CLIENTE   = '" + SA1->A1_COD  + "'				" + hEnter
			cQuery += "	AND     SE1.E1_LOJA      = '" + SA1->A1_LOJA + "'				" + hEnter
			cQuery += "	AND     SE1.E1_VENCREA BETWEEN '" + dtos(mv_par12) + "'			" + hEnter
			cQuery += "	AND     					   '" + dtos(mv_par13) + "'			" + hEnter
			cQuery += "	AND     SE1.E1_SALDO     > 0									" + hEnter
			cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" + hEnter
		
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)				
			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			
			While !(cAliasTMP)->(EOF())
	
				If ! lCabec
					nLin += 1                
					@nLin,000 PSAY __PrtThinLine() 
					nLin += 1
					@nLin,032 PSAY " D E B I T O S " 
					nLin += 1
					@nLin,000 PSAY __PrtThinLine()  
					nLin += 1                          
					@nLin,000 PSAY "DATA MOVIMENTO  VENCIMENTO  TIPO DA DESPESA                             VALOR(R$)" 
					lCabec := .T.
				EndIf
				                        
				If ALLTRIM((cAliasTMP)->E1_TIPO) == "RA" .OR. (cAliasTMP)->E1_TIPO == "NCC"
					nVALORCR := (cAliasTMP)->E1_SALDO * -1
				Else
					nVALORCR := (cAliasTMP)->E1_SALDO
				EndIf				
				
				nLin += 1
				@nLin,000 PSAY DTOC( STOD( (cAliasTMP)->E1_EMISSAO ) )
				@nLin,016 PSAY DTOC( STOD( (cAliasTMP)->E1_VENCREA ) )
				@nLin,028 PSAY (cAliasTMP)->E1_PREFIXO+"-DEBITOS MESES ANTERIORES/NOTAS FISCAIS"
				@nLin,070 PSAY TRANSFORM(nVALORCR,"@R 999,999.99")
				
				nVLR_DESP += nVALORCR
				
				(cAliasTMP)->(dbSkip())
		
		    EndDo
		
	    	(cAliasTMP)->(dbCloseArea())   
	 
	 	EndIf
	 
	 EndIf
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ CREDITO 															  . ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

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
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par12)    + "'  " + hEnter
	cQuery += "AND      				       '" + DTOS(mv_par13)    + "'  " + hEnter
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'C'							    " + hEnter	
    If mv_par17 != 1 
		cQuery += "AND 	ZLB.ZLB_STATUS    = ' '								" + hEnter		
	EndIf		
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter
                        
	memowrite("LTREL001_3.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nVLR_CRED  := 0 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressใo das creditos do produtor no perํodo                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	
	
		/*
                      1         2         3         4         5         6         7         8
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            ---------------------------------------------------------------------------------
		    DATA MOVIMENTO  VENCIMENTO  TIPO DO CREDITO                             VALOR(R$)
		*/  	
	lCabec := .F.
	While (cAliasTMP)->(!EOF())

		If ! lCabec
			nLin += 1                
			@nLin,000 PSAY __PrtThinLine() 
			nLin += 1
			@nLin,032 PSAY " C R E D I T O S " 
			nLin += 1
			@nLin,000 PSAY __PrtThinLine()  
			nLin += 1                          
			@nLin,000 PSAY "DATA MOVIMENTO  VENCIMENTO  TIPO DO CREDITO                             VALOR(R$)" 
			lCabec := .T.
		EndIf
                          
		nLin += 1
		@nLin,000 PSAY DTOC( STOD( (cAliasTMP)->ZLB_DTMOV ) )
		@nLin,016 PSAY DTOC( STOD( (cAliasTMP)->ZLB_DTVCTO ) )
		@nLin,028 PSAY SubSTR((cAliasTMP)->X5_DESCRI,1,30)
		@nLin,070 PSAY TRANSFORM((cAliasTMP)->ZLB_VALOR,"@E 999,999.99")
		
		nVLR_CRED += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbSkip())

    EndDo

    (cAliasTMP)->(dbCloseArea()) 
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
	//ณSeleciona todos os tํtulos em aberto do contas a pagar p/ o produtor           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

	If lIMPSE2
	
		cQuery := "	SELECT 																		" + hEnter
		cQuery += "			SE2.E2_SALDO,														" + hEnter
		cQuery += "			SE2.E2_FILIAL,														" + hEnter
		cQuery += "			SE2.E2_PREFIXO,														" + hEnter
		cQuery += "			SE2.E2_NUM,   														" + hEnter
		cQuery += "			SE2.E2_PARCELA,														" + hEnter
		cQuery += "			SE2.E2_TIPO,  														" + hEnter
		cQuery += "			SE2.E2_FORNECE,														" + hEnter
		cQuery += "			SE2.E2_LOJA,   														" + hEnter
		cQuery += "			SE2.E2_EMISSAO,   													" + hEnter
		cQuery += "			SE2.E2_VENCREA   													" + hEnter		
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2											" + hEnter	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xFilial("SE2") + "' 						" + hEnter
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR(cPRODUT,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR(cLOJPRD,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(mv_par12) + "'						" + hEnter
		cQuery += "	AND     					   '" + dtos(mv_par13) + "'						" + hEnter
		cQuery += "	AND     SE2.E2_SALDO     > 0												" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 												" + hEnter
	
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)				
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		
		While !(cAliasTMP)->(EOF())
	
			If ! lCabec
				nLin += 1                
				@nLin,000 PSAY __PrtThinLine() 
				nLin += 1
				@nLin,032 PSAY " C R E D I T O S " 
				nLin += 1
				@nLin,000 PSAY __PrtThinLine()  
				nLin += 1                          
				@nLin,000 PSAY "DATA MOVIMENTO  VENCIMENTO  TIPO DO CREDITO                             VALOR(R$)" 
				lCabec := .T.
			EndIf

			If ALLTRIM((cAliasTMP)->E2_TIPO) == "PA" .OR. (cAliasTMP)->E2_TIPO == "NDF"
				nVALORCP := (cAliasTMP)->E2_SALDO * -1
			Else
				nVALORCP := (cAliasTMP)->E2_SALDO
			EndIf

			
			nLin += 1
			@nLin,000 PSAY DTOC( STOD( (cAliasTMP)->E2_EMISSAO ) )
			@nLin,016 PSAY DTOC( STOD( (cAliasTMP)->E2_VENCREA ) )
			@nLin,028 PSAY (cAliasTMP)->E2_PREFIXO+"-CREDITOS MESES ANTERIORES"
			@nLin,070 PSAY TRANSFORM(nVALORCP,"@R 999,999.99")
			
			nVLR_CRED += nVALORCP
			
			(cAliasTMP)->(dbSkip())
	
	    EndDo
	
		(cAliasTMP)->(dbCloseArea())   
	
	EndIf
                  


Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfImpMensag  บAutor  ณRafael Parma       บ Data ณ  22/10/09  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo de mensagens.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fImpMensag( cMSG1, cMSG2, cMSG3, nLin )
    
    If ALLTRIM(cMSG1) != STRING_NULL
		nLin += 2
		@nLin,000 PSAY cMSG1
	EndIf
    If ALLTRIM(cMSG2) != STRING_NULL
		nLin += 1
		@nLin,000 PSAY cMSG2
	EndIf
    If ALLTRIM(cMSG3) != STRING_NULL
		nLin += 1
		@nLin,000 PSAY cMSG3
	EndIf	

  
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCheckTPF   บAutor  ณRafael Parma       บ Data ณ  22/10/09  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se transportador ้ pessoa fํsica.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCheckTPF()
Local aAreaTMP := GetArea()
Local lRet := .F.
	                  
	//--Cadastro da linha do produtor posicionado.
	dbSelectArea("ZL0")
	dbSetOrder(1)
	If dbSeek ( xFilial("ZL0") + SA2->A2_X_LINHA )
	
		//--Transportador relacionado a linha.
		dbSelectArea("SA4")
		dbSetOrder(1)
		If dbSeek ( xFilial("SA4") + ZL0->ZL0_TRANSP )
			
			//--Fornecedor do transportador.
			If !Empty(SA4->A4_X_FORN) .and. !Empty(SA4->A4_X_LOJF)
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek ( xFilial("SA2") + SA4->A4_X_FORN + SA4->A4_X_LOJF )
					If SA2->A2_TIPO == "F"
						lRet := .T.
					EndIf
				EndIf
			EndIf
		
		EndIf
	
	EndIf

	RestArea(aAreaTMP)	

Return (lRet)
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
*----------------------------------------------------------------------------------------------------*        
Static Function AjustaSX1()
*----------------------------------------------------------------------------------------------------*        
aRegs  := {}  ; aHelp01 := {} ; aHelp02 := {} ; aHelp03 := {} ; aHelp04 := {} 
aHelp05 := {} ; aHelp06 := {} ; aHelp07 := {} ; aHelp08 := {} ; aHelp09 := {} 
aHelp10 := {} ; aHelp11 := {} ; aHelp12 := {} ; aHelp13 := {} ; aHelp14 := {}
aHelp16 := {} ; aHelp17 := {} ; aHelp18 := {}


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","M๊s                ?","M๊s                ?","M๊s                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0101."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0102."})
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",".LTREL0103."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",".LTREL0104."})
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL0105."})
	aAdd(aRegs,{cPerg,"06","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL0106."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0107."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0108."})
	aAdd(aRegs,{cPerg,"09","Filtrar Por        ?","Filtrar Por        ?","Filtrar Por        ?","mv_ch9","N",01,0,1,"C","","mv_par09","Linha","Linha","Linha","","","Produtor","Produtor","Produtor","","","","","","","","","","","","","","","","", "","","",".LTREL0109."})
	aAdd(aRegs,{cPerg,"10","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_cha","N",01,0,1,"C","","mv_par10","Codigo Produtor","Codigo Produtor","Codigo Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","","","","","","","","","","","","","","", "","","",".LTREL0110."})
	aAdd(aRegs,{cPerg,"11","Utilizar Excecใo   ?","Utilizar Excecใo   ?","Utilizar Excecใo   ?","mv_chb","N",01,0,1,"C","","mv_par11","Produtor","Produtor","Produtor","","","Tabela","Tabela","Tabela","","","","","","","","","","","","","","","","", "","","",".LTREL0111."})
	aAdd(aRegs,{cPerg,"12","Vencimento De      ?","Vencimento De      ?","Vencimento De      ?","mv_chc","D",01,0,1,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0112."})
	aAdd(aRegs,{cPerg,"13","Vencimento Ate     ?","Vencimento Ate     ?","Vencimento Ate     ?","mv_chd","D",01,0,1,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0113."})
	aAdd(aRegs,{cPerg,"14","Cond. Pagamento De ?","Cond. Pagamento De ?","Cond. Pagamento De ?","mv_che","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL0114."})
	aAdd(aRegs,{cPerg,"15","Cond. Pagamento At้?","Cond. Pagamento At้?","Cond. Pagamento At้?","mv_chf","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL0114."})
	aAdd(aRegs,{cPerg,"16","Imp. Anแlise Campo ?","Imp. Anแlise Campo ?","Imp. Anแlise Campo ?","mv_chg","N",01,0,1,"C","","mv_par16","Nใo","Nใo","Nใo","","","Sim","Sim","Sim","","","","","","","","","","","","","","","","", "","","",".LTREL0116."})
	aAdd(aRegs,{cPerg,"17","Imp. Descontos Compensados?","Imp. Descontos Compensados?","Imp. Descontos Compensados?","mv_chh","C",01,0,1,"C","","mv_par17","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","", "","","",".LTREL0117."})	
	aAdd(aRegs,{cPerg,"18","Mensagem 1         ?","Mensagem 1         ?","Mensagem 1         ?","mv_chh","C",60,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0118."})
	aAdd(aRegs,{cPerg,"19","Mensagem 2         ?","Mensagem 2         ?","Mensagem 2         ?","mv_chi","C",60,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0118."})
	aAdd(aRegs,{cPerg,"20","Mensagem 3         ?","Mensagem 3         ?","Mensagem 3         ?","mv_chj","C",60,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0118."})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe o m๊s ao qual deseje imprimir    " )       
	AADD( aHelp02, "Informe o ano ao qual deseje imprimir    " )       
	AADD( aHelp03, "Informe o n๚mero inicial da linha        " )       
	AADD( aHelp03, "a ser impressa.                          " )       
	AADD( aHelp04, "Informe o n๚mero final da linha          " )       
	AADD( aHelp04, "a ser impressa.                          " )       
	AADD( aHelp05, "Informe o c๓digo inicial do produtor     " )       
	AADD( aHelp05, "a ser impresso.                          " )       
	AADD( aHelp06, "Informe o c๓digo final do produtor       " )       
	AADD( aHelp06, "a ser impresso.                          " )       
	AADD( aHelp07, "Informe a loja inicial do produtor       " )       
	AADD( aHelp07, "a ser impresso.                          " )       
	AADD( aHelp08, "Informe a loja final do produtor         " )       
	AADD( aHelp08, "a ser impresso.                          " )       
	AADD( aHelp09, "Informe se deseje imprimir por intervalo " )       
	AADD( aHelp09, "de linhas ou produtores.                 " )       
	AADD( aHelp10, "Ordenar os registros pelo nome ou c๓digo " )       
	AADD( aHelp10, "dos produtores.                          " ) 
	AADD( aHelp11, "Utilizar tabela de exce็ใo do cadastro do" )       
	AADD( aHelp11, "produtor ou das tabelas de exce็๕es.     " )	
	AADD( aHelp12, "Informe o Vencimento Inicial.            " )	
	AADD( aHelp12, "Vแlido somente para lan็amentos da       " )	
	AADD( aHelp12, "Conta Corrente Produtor.                 " )	
	AADD( aHelp13, "Informe o Vencimento Final.              " )	
	AADD( aHelp13, "Vแlido somente para lan็amentos da       " )	
	AADD( aHelp13, "Conta Corrente Produtor.                 " )	
	AADD( aHelp14, "Informe o intervalo de condicao de paga- " )	
	AADD( aHelp14, "mento para filtro de produtores.         " )	
	AADD( aHelp14, "Imprimir dados das anแlises de coleta    " )	
	AADD( aHelp14, "a campo?                                 " )	
	AADD( aHelp17, "Imprime descontos compensados?           " )
	AADD( aHelp18, "Mensagem para impressใo sobre recibo.    " )
	
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza o Help dos campos no arquivo de Helpณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutSX1Help("P.LTREL0101.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0102.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL0103.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL0104.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL0105.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL0106.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL0107.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL0108.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL0109.",aHelp09,aHelp09,aHelp09)	
	PutSX1Help("P.LTREL0110.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL0111.",aHelp11,aHelp11,aHelp11)
	PutSX1Help("P.LTREL0112.",aHelp12,aHelp12,aHelp12)
	PutSX1Help("P.LTREL0113.",aHelp13,aHelp13,aHelp13)
	PutSX1Help("P.LTREL0114.",aHelp14,aHelp14,aHelp14)
	PutSX1Help("P.LTREL0116.",aHelp16,aHelp16,aHelp16)
	PutSX1Help("P.LTREL0117.",aHelp17,aHelp17,aHelp17)
	PutSX1Help("P.LTREL0118.",aHelp18,aHelp18,aHelp18)	
			
Return Nil
