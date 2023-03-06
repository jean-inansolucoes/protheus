#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL002 บAutor  ณRafael Parma         บ Data ณ  06/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de demonstrativo de pagamento.          บฑฑ
ฑฑบ          ณPor Transportador.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL002()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "DEMONSTRATIVO DE PAGAMENTO - TRANSPORTADOR"
//Local cPict          := ""
Local titulo         := "DEMONSTRATIVO DE PAGAMENTO - TRANSPORTADOR"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := "" 
//Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00002"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LTREL002"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL002"

Public DATE_NULL     := ctod("  /  /  ")
Public STRING_NULL   := ""
Public cTIPO_PRD     := "P "
Public cTIPO_TRP     := "T "


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

	RptStatus({|| ReportTrp(Cabec1,Cabec2,Titulo,nLin) },Titulo)	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณReportPrd บ Autor ณRafael Parma        บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de demonstrativo de pagamento.          บฑฑ
ฑฑบ          ณPor Transportador.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ReportTrp(Cabec1,Cabec2,Titulo,nLin)

//Local nCol         := 60				// coluna de impressใo
Local nQTD_TOTAL   := 0					// quantidade total em litros
Local nQTD_PLATF   := 0					// quantidade total da plataforma
Local nQTD_DIVER   := 0					// quantidade total da divergencia
Local nPRC_LITRO   := 0					// pre็o total dos litros  
Local nVLR_PROD    := 0					// valor total da produ็ใo   
Local nVLR_DESP    := 0					// valor total de despesas
Local nVLR_CRED    := 0					// valor total de creditos
Local nQTD_PRD     := 0					// quantidade total do produtor
Local cPRODUT      := ""				// c๓digo do produtor
Local cLOJPRD      := ""				// loja do produtor
Local cLINHA       := ""				// linha do produtor
Local cTRANSP      := ""				// codigo do transportador
Local cCODIGO      := ""				// numero sequencial da coleta
Local cAliasTMP    := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13) 
Local lSTART_DATE  := .F.
Local lEND_DATE    := .F.     
Local dCURR_DATE   := ctod("")      	// dia do registro em processamento
Local dLAST_DATE   := ctod("")			// ๚ltimo dia impresso

Private dSTART_DATE:= ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do perํodo
Private dEND_DATE  := dSTART_DATE		// ๚ltimo dia do perํodo

	dCURR_DATE := dSTART_DATE
	dLAST_DATE := dSTART_DATE	

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
	    
	cQuery := " SELECT 																	 				" + hEnter
	cQuery += "			ZL5.ZL5_COD,													 				" + hEnter
	cQuery += "			ZL5.ZL5_LINHA,  												 				" + hEnter    
	cQuery += "			ZL5.ZL5_TRANSP, 												 				" + hEnter
	cQuery += "			ZL5.ZL5_NOMTRP, 												 				" + hEnter	
	cQuery += "			ZL5.ZL5_DATA,													 				" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,													 				" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,													 				" + hEnter  
	cQuery += "			ZL5.ZL5_TOTAL,													 				" + hEnter	
	cQuery += "			ZL6.ZL6_QTDE,												 					" + hEnter		
	If SuperGetMV("MV_ZLPTSBR",,.F.)
		cQuery += "		( SELECT SUM((ZL7.ZL7_QTDTRP+ZL7.ZL7_QTDSOB)-(ZL7.ZL7_QTDCRI+ZL7.ZL7_QTDFAL))	" + hEnter
	Else                                                                                                          
		cQuery += "		( SELECT SUM((ZL7.ZL7_QTDTRP)-(ZL7.ZL7_QTDCRI+ZL7.ZL7_QTDFAL))					" + hEnter
	EndIf	
	cQuery += "				FROM " + RetSQLName("ZL7") + " ZL7 						 					" + hEnter
	cQuery += " 			WHERE 																		" + hEnter
	cQuery += " 			ZL7.ZL7_FILIAL 		= ZL5.ZL5_FILIAL			   							" + hEnter		
	cQuery += " 			AND ZL7.ZL7_DATA    = ZL5.ZL5_DATA   					 					" + hEnter
	cQuery += " 			AND ZL7.ZL7_TRANSP  = ZL5.ZL5_TRANSP				 						" + hEnter
	cQuery += " 			AND ZL7.ZL7_LINHA   = ZL5.ZL5_LINHA   	  			 						" + hEnter
	cQuery += " 			AND ZL7.ZL7_TPROD  != 'O'							  						" + hEnter		
	cQuery += " 			AND ZL7.D_E_L_E_T_ != '*' ) ZL5_PLATF				  						" + hEnter
	cQuery += " FROM " + RetSqlName("ZL5") + " ZL5										 				" + hEnter
	cQuery += " INNER JOIN " + RetSqlName("ZL6") + " ZL6   								 				" + hEnter
	cQuery += " ON      ZL5.ZL5_FILIAL     = ZL6.ZL6_FILIAL                  			 				" + hEnter		
	cQuery += " AND     ZL5.ZL5_COD        = ZL6.ZL6_COD                     			 				" + hEnter		
	cQuery += " WHERE   ZL5.ZL5_FILIAL     = '" + xFilial("ZL5") + "' 					 				" + hEnter
	cQuery += " AND 	( ZL5.ZL5_TRANSP BETWEEN '" + mv_par03       + "' 				 				" + hEnter
	cQuery += " AND                		    	 '" + mv_par04       + "' ) 			 				" + hEnter
	cQuery += " AND 	( ZL5.ZL5_LINHA  BETWEEN '" + mv_par05       + "' 				 				" + hEnter
	cQuery += " AND                		    	 '" + mv_par06       + "' )				 				" + hEnter	
	cQuery += " AND 	( ZL5.ZL5_DATA   BETWEEN '" + DTOS(dSTART_DATE) + "'			 				" + hEnter
	cQuery += " AND                        		 '" + DTOS(dEND_DATE)   + "' )			 				" + hEnter	
	cQuery += " AND 	ZL5.ZL5_STATUS     = '' 										 				" + hEnter
	cQuery += " AND 	ZL5.D_E_L_E_T_    != '*' 										 				" + hEnter
	cQuery += " AND 	ZL6.D_E_L_E_T_    != '*' 										 				" + hEnter
	cQuery += " ORDER BY 																 				" + hEnter
	cQuery += "			ZL5.ZL5_TRANSP, 												 				" + hEnter	
	cQuery += "			ZL5.ZL5_LINHA, 													 				" + hEnter
	cQuery += "			ZL5.ZL5_COD,													 				" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT, 												 				" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD, 												 				" + hEnter
	cQuery += "			ZL5.ZL5_DATA													 				" + hEnter	
	memowrite("LTREL002_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
   
	nQTD_PRD := 0
		 
	While (cAliasTMP)->(!EOF())
        
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif 
				
	    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	    //ณ Impressao do cabecalho do relatorio. . .                            ณ
	    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If cTRANSP != (cAliasTMP)->ZL5_TRANSP

		    If cPRODUT != (cAliasTMP)->ZL6_PRODUT .or. cLOJPRD != (cAliasTMP)->ZL6_LOJPRD	       
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Cแlculo dos totalizadores do produtor no perํodo                        ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ	        
		        If cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL		        	
		        	fCalcProd( mv_par08, cPRODUT, cLOJPRD, cLINHA, nQTD_PRD, @nPRC_LITRO, @nVLR_PROD )		        	
		        EndIf
		    Endif                             

			If cTRANSP != STRING_NULL

		        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
		        nLin := 8   

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressใo das despesas                                                  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				
				dbSelectArea("SA4")
				dbSetOrder(1)
				dbSeek ( xFilial("SA4") + cTRANSP )		
				
				fTotalDesp( dSTART_DATE, dEND_DATE, SA4->A4_X_FORN, SA4->A4_X_LOJF, @nVLR_DESP, @nVLR_CRED, @nLin )
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressใo do recibo                                                     ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				fImpRec(cTRANSP, nVLR_PROD, nVLR_DESP, nVLR_CRED, nQTD_TOTAL, nQTD_PLATF, @nLin )

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Limpeza dos totalizadores                                               ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

		        nQTD_TOTAL   := 0
		        nQTD_DIVER   := 0
		        nQTD_PLATF   := 0
		        nQTD_PRD     := 0
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
		    
		    If cPRODUT != (cAliasTMP)->ZL6_PRODUT .or. cLOJPRD != (cAliasTMP)->ZL6_LOJPRD	       
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Cแlculo dos totalizadores do produtor no perํodo                        ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ	        
		        If cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL		        	
		        	fCalcProd( mv_par08, cPRODUT, cLOJPRD, cLINHA, nQTD_PRD, @nPRC_LITRO, @nVLR_PROD )		        	
		        EndIf 
		        
		        nQTD_PRD := 0
		    	
		    Endif                             
		    
		EndIf
	
		
		If cCODIGO != (cAliasTMP)->ZL5_COD
			nQTD_PLATF += (cAliasTMP)->ZL5_PLATF
			nQTD_TOTAL += (cAliasTMP)->ZL5_TOTAL
		EndIf
		    
	   	cPRODUT := (cAliasTMP)->ZL6_PRODUT  
	   	cLOJPRD := (cAliasTMP)->ZL6_LOJPRD
	   	cTRANSP := (cAliasTMP)->ZL5_TRANSP
	   	cLINHA  := (cAliasTMP)->ZL5_LINHA
		cCODIGO := (cAliasTMP)->ZL5_COD
	   	
 //	   	nQTD_TOTAL += (cAliasTMP)->ZL5_TOTAL
 //	   	nQTD_TOTAL += (cAliasTMP)->ZL6_QTDE
 	   	nQTD_PRD += (cAliasTMP)->ZL6_QTDE
	   	
	   	dCURR_DATE := STOD( (cAliasTMP)->ZL5_DATA )
	   	                                                   
	    (cAliasTMP)->(dbSkip())
	   		
	EndDo
    
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressใo das despesas e totalizadores do produtor no perํodo           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        
	If cTRANSP != STRING_NULL

        If cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL		        	
        	fCalcProd( mv_par08, cPRODUT, cLOJPRD, cLINHA, nQTD_PRD, @nPRC_LITRO, @nVLR_PROD )		        	
        EndIf

	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
	    nLin := 8   

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressใo das despesas                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				
		dbSelectArea("SA4")
		dbSetOrder(1)
		dbSeek ( xFilial("SA4") + cTRANSP )		
				
		fTotalDesp( dSTART_DATE, dEND_DATE, SA4->A4_X_FORN, SA4->A4_X_LOJF, @nVLR_DESP, @nVLR_CRED, @nLin )
				
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressใo do recibo                                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		fImpRec(cTRANSP, nVLR_PROD, nVLR_DESP, nVLR_CRED, nQTD_TOTAL, nQTD_PLATF, @nLin )

	EndIf

	(cAliasTMP)->(dbCloseArea())

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
ฑฑบPrograma  ณfCalcProd  บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo de linha e coluna de impressใo do produtor.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

    Else	// tabela de exce็๕es
    
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotalTrp  บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo dos totalizadores do trans- บฑฑ
ฑฑบ          ณportador.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fImpRec(cTRANSP, nVLR_PROD, nVLR_DESP, nVLR_CRED, nQTD_TOTAL, nQTD_PLATF, nLin)

Local nQTD_DIV  := nQTD_PLATF - nQTD_TOTAL
Local nVLR_DIV  := IIF(nQTD_DIV!=0,Round(nQTD_DIV*mv_par07,4),0)
Local nLIQUIDO  := ( nVLR_PROD + nVLR_DIV + nVLR_CRED ) - nVLR_DESP

	nLin += 1
	@nLin,000 PSAY __PrtThinLine()
	nLin += 1
	@nLin,034 PSAY " R E C I B O " 	 
	nLin += 1
	@nLin,000 PSAY __PrtThinLine() 
	nLin += 1
	@nLin,004 PSAY "EU " + UPPER(ALLTRIM(SA4->A4_NOME)) + " ("+SA4->A4_COD+")"
	nLin += 1
	@nLin,000 PSAY "RECEBI A QUANTIA ABAIXO DESCRITA, REFERENTE A SERVIวOS DE TRANSPORTE DE # " + ALLTRIM(TRANSFORM(nQTD_TOTAL, "@E 999999" )) + " #"
	nLin += 1
	@nLin,000 PSAY "LITROS DE LEITE, PRESTADOS A " + ALLTRIM(SM0->M0_NOME) + " NO PERอODO DE " + DTOC(dSTART_DATE) + " A " + DTOC(dEND_DATE) + "."
	nLin += 1
	nLin += 1
	@nLin,000 PSAY "VALOR TOTAL DO TRANSPORTE    : R$ " + TRANSFORM( nVLR_PROD , "@E 9,999,999.99" )
	nLin += 1
	@nLin,000 PSAY "DIVERGสNCIAS                 : R$ " + TRANSFORM( nVLR_DIV  , "@E 9,999,999.99" ) + SPACE(10) + " QTDE: " + TRANSFORM( nQTD_DIV , "@E 999,999.99" )
	nLin += 1 
	@nLin,000 PSAY "DESCONTO DEBITOS          (-): R$ " + TRANSFORM( nVLR_DESP , "@E 9,999,999.99" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "ACRESCIMO CREDITOS        (+): R$ " + TRANSFORM( nVLR_CRED , "@E 9,999,999.99" )
	nLin += 1                                                                                         
	@nLin,000 PSAY "TOTAL LIQUIDO A RECEBER      : R$ " + TRANSFORM( nLIQUIDO  , "@E 9,999,999.99" )
	nLin += 3       
	@nLin,010 PSAY ALLTRIM(SM0->M0_CIDCOB) + ", " + cValtoChar(day(ddatabase)) + " DE " + UPPER(mesextenso(month(ddatabase))) + " DE " + cValtoChar(year(ddatabase))
	nLin += 3	                
	@nLin,030 PSAY Replicate("_",36)
	nLin += 1	
	@nLin,030 PSAY "ASSINATURA: " + UPPER(ALLTRIM(SA4->A4_NOME))
	nLin += 1       
	@nLin,042 PSAY IIF(LEN(ALLTRIM(SA4->A4_CGC))>11,"CNPJ: "+TRANSFORM(SA4->A4_CGC,"@R 99.999.999/9999-99"),"CPF: "+TRANSFORM(SA4->A4_CGC,"@R 999.999.999-99"))
	nLin += 2      	 	
	@nLin,000 PSAY __PrtThinLine() 

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

Static Function fTotalDesp( dSTART_DATE, dEND_DATE, cPRODUT, cLOJPRD, nVLR_DESP, nVLR_CRED, nLin )
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
	cQuery += "			SX5.X5_DESCRI 										" + hEnter
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" + hEnter
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " + hEnter		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
/*
	cQuery += "AND      ZLB.ZLB_DTMOV  BETWEEN '" + DTOS(dSTART_DATE) + "'	" + hEnter
	cQuery += "AND      				       '" + DTOS(dEND_DATE)   + "'	" + hEnter
*/
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par09) + "'	    " + hEnter
	cQuery += "AND      				       '" + DTOS(mv_par10) + "'	    " + hEnter

	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'D'							    " + hEnter	
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter
                        
	memowrite("LTREL002_3.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nVLR_DESP  := 0 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressใo das despesas do produtor no perํodo                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	
    /*        1         2         3         4         5         6         7         8
    0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
    ---------------------------------------------------------------------------------
    DATA MOVIMENTO  VENCIMENTO  TIPO DA DESPESA                             VALOR(R$)
	*/  	
	
	While (cAliasTMP)->(!EOF())

		If ! lCabec
			@nLin,000 PSAY __PrtThinLine()  
			nLin += 1                          
			@nLin,032 PSAY " D E B I T O S " 
			nLin += 1
			@nLin,000 PSAY __PrtThinLine()  
			nLin += 1                          
			@nLin,000 PSAY "DATA MOVIMENTO  VENCIMENTO  TIPO DO DEBITO                              VALOR(R$)" 
			lCabec := .T.
		EndIf
                          
		nLin += 1
		@nLin,000 PSAY DTOC( STOD( (cAliasTMP)->ZLB_DTMOV ) )
		@nLin,016 PSAY DTOC( STOD( (cAliasTMP)->ZLB_DTVCTO ) )
		@nLin,028 PSAY SubSTR((cAliasTMP)->X5_DESCRI,1,30)
		@nLin,070 PSAY TRANSFORM((cAliasTMP)->ZLB_VALOR,"@E 999,999.99")
		
		nVLR_DESP += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbSkip())

    EndDo

    (cAliasTMP)->(dbCloseArea())           

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
/*
	cQuery += "AND      ZLB.ZLB_DTMOV  BETWEEN '" + DTOS(dSTART_DATE) + "'	" + hEnter
	cQuery += "AND      				       '" + DTOS(dEND_DATE)   + "'	" + hEnter
*/
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par09) + "'	    " + hEnter
	cQuery += "AND      				       '" + DTOS(mv_par10) + "'	    " + hEnter

	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'C'							    " + hEnter	
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter
                        
	memowrite("LTREL002_3.SQL",cQuery)
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

Static Function AjustaSX1()
Local i,j
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","M๊s                ?","M๊s                ?","M๊s                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0201."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0202."})
	aAdd(aRegs,{cPerg,"03","Transportador De   ?","Transportador De   ?","Transportador De   ?","mv_ch3","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA4","","",".LTREL0203."})
	aAdd(aRegs,{cPerg,"04","Transportador At้  ?","Transportador At้  ?","Transportador At้  ?","mv_ch4","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA4","","",".LTREL0204."})
	aAdd(aRegs,{cPerg,"05","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0205."})
	aAdd(aRegs,{cPerg,"06","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch6","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0206."})
	aAdd(aRegs,{cPerg,"07","Valor Lt. Diverg.  ?","Valor Lt. Diverg.  ?","Valor Lt. Diverg.  ?","mv_ch7","N",07,4,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0207."})
	aAdd(aRegs,{cPerg,"08","Utilizar Excecใo   ?","Utilizar Excecใo   ?","Utilizar Excecใo   ?","mv_ch8","N",01,0,1,"C","","mv_par08","Produtor","Produtor","Produtor","","","Tabela","Tabela","Tabela","","","","","","","","","","","","","","","","", "","","",".LTREL0208."})
	aAdd(aRegs,{cPerg,"09","Vencimento De      ?","Vencimento De      ?","Vencimento De      ?","mv_ch9","D",01,0,1,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0209."})
	aAdd(aRegs,{cPerg,"10","Vencimento Ate     ?","Vencimento Ate     ?","Vencimento Ate     ?","mv_cha","D",01,0,1,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0210."})

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe o m๊s ao qual deseje imprimir    " )       
	AADD( aHelp02, "Informe o ano ao qual deseje imprimir    " )       
	AADD( aHelp03, "Informe o c๓digo inicial do transportador" )       
	AADD( aHelp03, "a ser impresso.                          " )       
	AADD( aHelp04, "Informe o c๓digo final do transportador  " )       
	AADD( aHelp04, "a ser impresso.                          " )       
	AADD( aHelp05, "Informe o n๚mero inicial da linha        " )       
	AADD( aHelp05, "a ser impressa.                          " )       
	AADD( aHelp06, "Informe o n๚mero final da linha          " )       
	AADD( aHelp06, "a ser impressa.                          " )       
	AADD( aHelp07, "Informe o valor por litro para cแlculo   " )       
	AADD( aHelp07, "da diverg๊ncia.                          " ) 
	AADD( aHelp08, "Utilizar tabela de exce็ใo do cadastro do" )       
	AADD( aHelp08, "produtor ou das tabelas de exce็๕es.     " )	      
	AADD( aHelp09, "Informe o Vencimento Inicial.            " )	
	AADD( aHelp09, "Vแlido somente para lan็amentos da       " )	
	AADD( aHelp09, "Conta Corrente Produtor.                 " )	
	AADD( aHelp10, "Informe o Vencimento Final.              " )	
	AADD( aHelp10, "Vแlido somente para lan็amentos da       " )	
	AADD( aHelp10, "Conta Corrente Produtor.                 " )	
	
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
	PutSX1Help("P.LTREL0201.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0202.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL0203.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL0204.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL0205.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL0206.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL0207.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL0208.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL0209.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL0210.",aHelp10,aHelp10,aHelp10)
		
Return Nil
