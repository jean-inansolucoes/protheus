#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL013 บAutor  ณRafael Parma         บ Data ณ  26/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de notas fiscais por produtor x municํpio.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL013()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELAวรO DE NOTAS FISCAIS X MUNICอPIOS"
Local cPict          := ""
Local titulo         := "RELAวรO DE NOTAS FISCAIS X MUNICอPIOS"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := "" 
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00013"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "LTREL013"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL013"

Public DATE_NULL     := ctod("  /  /  ")
Public STRING_NULL   := ""



	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "SF1"
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

	RptStatus({|| ReportPrd(@Cabec1,@Cabec2,Titulo,@nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณReportPrd บ Autor ณRafael Parma        บ Data ณ  26/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de notas fiscais por produtor x municํpio.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ReportPrd(Cabec1,Cabec2,Titulo,nLin)

Local nTOT_QTD     := 0
Local nTOT_VLR     := 0
Local nTOT_REG     := 0
Local nTOT_QBR_REG := 0
Local nTOT_QBR_QTD := 0
Local nTOT_QBR_VLR := 0
Local cLINHA       := STRING_NULL		// linha do produtor
Local cESTMUN      := STRING_NULL		// estado + municํpio do produtor
Local cAliasTMP    := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13) 
Local lSTART_DATE  := .F.
Local lEND_DATE    := .F.
Local dSTART_DATE  := ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do perํodo
Local dEND_DATE    := dSTART_DATE		// ๚ltimo dia do perํodo
Local dCURR_DATE   := dSTART_DATE      	// dia do registro em processamento
Local dLAST_DATE   := dSTART_DATE		// ๚ltimo dia impresso
Local aDADOSEXP    := {}

	If U_YIsBis(mv_par02) 
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","29","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))
    Else
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","28","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))   
    EndIf


    Cabec1 := "NOTA FISC   CPF        NOME PRODUTOR                 LINHA      UF MUNICอPIO                 QTD.LEITE   VLR.UNIT.    VLR.TOTAL"	        
    Cabec2 := "PERอODO DE: " + DTOC(dSTART_DATE) + " ATษ: " + DTOC(dEND_DATE)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	If Empty(AllTrim(mv_par18))
		mv_par18 := xFilial("SF1")
	EndIf    

	cQuery := "SELECT 	 															" + hEnter    
	cQuery += "			SF1.F1_X_LINHA	LINHA, 										" + hEnter    
	cQuery += "			SF1.F1_FORNECE	PRODUT,										" + hEnter
	cQuery += "			SF1.F1_LOJA		LOJPRD,										" + hEnter
	cQuery += "			SF1.F1_DOC		DOC,										" + hEnter
	cQuery += "			SA2.A2_NOME		NOMPRD,										" + hEnter
	cQuery += "			SA2.A2_COD_MUN  MUN,										" + hEnter
	cQuery += "			SA2.A2_EST 		EST,   										" + hEnter	
	cQuery += "			SA2.A2_CGC 		CPF,   										" + hEnter	
	cQuery += "			CC2.CC2_MUN 	NOMMUN,										" + hEnter	
	cQuery += "			SUM(SD1.D1_QUANT) D1_QUANT,									" + hEnter
	cQuery += "			SUM(SD1.D1_VUNIT) D1_VUNIT,									" + hEnter		
	cQuery += "			SUM(SD1.D1_TOTAL) D1_TOTAL									" + hEnter
	cQuery += "FROM " + RetSqlName("SF1") + " SF1									" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SD1") + " SD1   							" + hEnter
	cQuery += "ON       SF1.F1_FILIAL     = SD1.D1_FILIAL                           " + hEnter		
	cQuery += "AND      SF1.F1_DOC        = SD1.D1_DOC                              " + hEnter		
	cQuery += "AND      SF1.F1_SERIE      = SD1.D1_SERIE                            " + hEnter		
	cQuery += "AND      SF1.F1_FORNECE    = SD1.D1_FORNECE                          " + hEnter		
	cQuery += "AND      SF1.F1_LOJA       = SD1.D1_LOJA                             " + hEnter		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2   							" + hEnter
	cQuery += "ON       SA2.A2_COD        = SF1.F1_FORNECE                          " + hEnter		
	cQuery += "AND      SA2.A2_LOJA       = SF1.F1_LOJA                             " + hEnter				
	cQuery += "INNER JOIN " + RetSqlName("CC2") + " CC2   							" + hEnter
	cQuery += "ON       SA2.A2_EST        = CC2.CC2_EST                          	" + hEnter		
	cQuery += "AND      SA2.A2_COD_MUN    = CC2.CC2_CODMUN                          " + hEnter
	cQuery += "WHERE    SF1.F1_FILIAL     = '" + mv_par18 + "' 			   			" + hEnter
	cQuery += "AND ( SF1.F1_X_LINHA BETWEEN '" + mv_par03       + "' 				" + hEnter
	cQuery += "AND                 		    '" + mv_par04       + "' )				" + hEnter
	cQuery += "AND ( SF1.F1_FORNECE BETWEEN '" + mv_par05       + "' 				" + hEnter
	cQuery += "AND                		    '" + mv_par06       + "' )				" + hEnter
	cQuery += "AND ( SF1.F1_LOJA    BETWEEN '" + mv_par07       + "' 				" + hEnter
	cQuery += "AND                          '" + mv_par08       + "' )				" + hEnter
	cQuery += "AND ( SF1.F1_EMISSAO     BETWEEN '" + DTOS(dSTART_DATE) + "' 		" + hEnter
	cQuery += "AND                          	'" + DTOS(dEND_DATE)   + "' )		" + hEnter
	cQuery += "AND ( SA2.A2_COD_MUN BETWEEN '" + mv_par09       + "' 				" + hEnter
	cQuery += "AND                          '" + mv_par10       + "' )				" + hEnter
	cQuery += "AND ( SA2.A2_EST     BETWEEN '" + mv_par11       + "' 				" + hEnter
	cQuery += "AND                          '" + mv_par12       + "' )				" + hEnter	
	cQuery += "AND ( SA2.A2_COND    BETWEEN '" + mv_par16       + "' 				" + hEnter
	cQuery += "AND                          '" + mv_par17       + "' )				" + hEnter	
	cQuery += "AND SA2.A2_X_TIPO		  	= 'P'		                            " + hEnter
	//cQuery += "AND SF1.F1_ESPECIE         = 'SPED'		                           " + hEnter
	cQuery += "AND SF1.D_E_L_E_T_        != '*' 									" + hEnter
	cQuery += "AND SD1.D_E_L_E_T_        != '*' 									" + hEnter
	cQuery += "AND SA2.D_E_L_E_T_        != '*' 									" + hEnter
	cQuery += "GROUP BY 								 							" + hEnter
	cQuery += "			SF1.F1_X_LINHA, 											" + hEnter    
	cQuery += "			SF1.F1_FORNECE,												" + hEnter
	cQuery += "			SF1.F1_LOJA,												" + hEnter
	cQuery += "			SF1.F1_DOC,													" + hEnter	
	cQuery += "			SA2.A2_NOME,												" + hEnter
	cQuery += "			SA2.A2_COD_MUN,												" + hEnter
	cQuery += "			SA2.A2_EST,   												" + hEnter	
	cQuery += "			SA2.A2_CGC,   												" + hEnter	
	cQuery += "			CC2.CC2_MUN   												" + hEnter	
	cQuery += "ORDER BY   															" + hEnter	

	If mv_par14 == 1		// Quebrar Pแgina Por = LINHA
		cQuery += "		SF1.F1_X_LINHA	 											" + hEnter
	Else					// Quebrar Pแgina Por = MUNICIPIO
		cQuery += "		CC2.CC2_MUN   												" + hEnter	
	EndIf		

	If mv_par13 == 1		// Ordenar Por = CODIGO PRODUTOR
		cQuery += "		,SF1.F1_FORNECE												" + hEnter
		cQuery += "		,SF1.F1_LOJA												" + hEnter
	ElseIf mv_par13 == 2	// Ordenar Por = NOME PRODUTOR
		cQuery += "		,SA2.A2_NOME												" + hEnter
	ElseIf mv_par13 == 3	// Ordenar Por = NOTA FISCAL
		cQuery += "		,SF1.F1_DOC													" + hEnter	
    ElseIf mv_par14 == 1	// Ordenar Por = MUNICIPIO
		cQuery += "		,CC2.CC2_MUN   												" + hEnter
	EndIf		
                        	   
	memowrite("LTREL013_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
	 
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
  		
  		If mv_par14 == 1 .and. cLINHA != (cAliasTMP)->LINHA
	        
		    If cLINHA != STRING_Null  .and.  mv_par15 == 1 
		        nLin += 1
		    	@nLin,000 PSAY "TOTAL ---> " + cValToChar(nTOT_QBR_REG)      	
				@nLin,088 PSAY nTOT_QBR_QTD  PICTURE "@E 9999999999"		
		        @nLin,114 PSAY nTOT_QBR_VLR  PICTURE "@E 999,999,999.99"      
			EndIf
						        
			nTOT_QBR_QTD := 0
			nTOT_QBR_VLR := 0
			nTOT_QBR_REG := 0
			        
	        dbSelectArea("ZL0")
	        dbSetOrder(1)
	        dbSeek( xFilial("ZL0") + (cAliasTMP)->LINHA )                            
            
			If mv_par15 == 1 
	        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
	        	nLin := 9
	  		EndIf

		ElseIf mv_par14 == 2 .and. cESTMUN != (cAliasTMP)->EST + (cAliasTMP)->MUN

		    If cESTMUN != STRING_Null .and.  mv_par15 == 1    
		        nLin += 1
		    	@nLin,000 PSAY "TOTAL ---> " + cValToChar(nTOT_QBR_REG)      	
				@nLin,088 PSAY nTOT_QBR_QTD  PICTURE "@E 9999999999"		
		        @nLin,114 PSAY nTOT_QBR_VLR  PICTURE "@E 999,999,999.99"         
			EndIf
						        
			nTOT_QBR_QTD := 0
			nTOT_QBR_VLR := 0
			nTOT_QBR_REG := 0
			                                 
			If mv_par15 == 1 
	        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
	        	nLin := 9
	  		EndIf
		
		EndIf 
		

		If nLin > 65 .and. mv_par15 == 1 
        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
  			nLin := 9
  		EndIf   		
		 		
		/*
                 1         2         3         4         5         6         7         8         9         0         1         2         3  
       0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12
       -------------------------------------------------------------------------------------------------------------------------------------
	   NOTA FISCAL CODIGO    NOME PRODUTOR                 LINHA      UF MUNICIPIO                 QTD.LEITE   VLR.UNIT.    VLR.TOTAL
		*/  
                           
		If mv_par15 == 1 

	        @nLin,000 PSAY (cAliasTMP)->DOC
	        @nLin,010 PSAY SubSTR((cAliasTMP)->CPF,1,11)
			@nLin,023 PSAY SubSTR((cAliasTMP)->NOMPRD,1,28) 
			@nLin,052 PSAY (cAliasTMP)->LINHA
			@nLin,063 PSAY (cAliasTMP)->EST
			@nLin,066 PSAY SubSTR((cAliasTMP)->NOMMUN,1,24)
			@nLin,090 PSAY (cAliasTMP)->D1_QUANT  PICTURE "@E 99999999"		
			@nLin,104 PSAY (cAliasTMP)->D1_VUNIT  PICTURE "@E 999,999.99"		
	        @nLin,118 PSAY (cAliasTMP)->D1_TOTAL  PICTURE "@E 999,999.99"

		EndIf
			      
		aAdd ( aDADOSEXP, { (cAliasTMP)->DOC, SubSTR((cAliasTMP)->PRODUT,1,06), SubSTR((cAliasTMP)->NOMPRD,1,28), (cAliasTMP)->LINHA, (cAliasTMP)->EST, ;
		 					SubSTR((cAliasTMP)->NOMMUN,1,24), (cAliasTMP)->D1_QUANT, (cAliasTMP)->D1_VUNIT, (cAliasTMP)->D1_TOTAL} )
			                                  
		nTOT_QTD     += (cAliasTMP)->D1_QUANT
		nTOT_QBR_QTD += (cAliasTMP)->D1_QUANT		
		nTOT_VLR     += (cAliasTMP)->D1_TOTAL
		nTOT_QBR_VLR += (cAliasTMP)->D1_TOTAL
		nTOT_REG     += 1
		nTOT_QBR_REG += 1

		cLINHA   := (cAliasTMP)->LINHA
		cESTMUN  := (cAliasTMP)->EST + (cAliasTMP)->MUN		
		
		nLin += 1
		
	    (cAliasTMP)->(dbSkip())
	   	IncRegua()
	   		
	EndDo
                
	(cAliasTMP)->(dbCloseArea())    
	
    If cESTMUN != STRING_Null .or. cLINHA != STRING_Null .and.  mv_par15 == 1 
    
        nLin += 1
    	@nLin,000 PSAY "TOTAL ---> " + cValToChar(nTOT_QBR_REG)      	
		@nLin,088 PSAY nTOT_QBR_QTD  PICTURE "@E 9999999999"		
        @nLin,114 PSAY nTOT_QBR_VLR  PICTURE "@E 999,999,999.99"      

        nLin += 2
    	@nLin,000 PSAY "TOTAL GERAL ---> " + cValToChar(nTOT_REG)      	
		@nLin,088 PSAY nTOT_QTD  PICTURE "@E 9999999999"		
        @nLin,114 PSAY nTOT_VLR  PICTURE "@E 999,999,999.99"   

	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	If mv_par15 == 1 
	
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
	
	Else

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Exporta็ใo de dados p/ excel.                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Len(aDADOSEXP) > 0
					
			fExpXLS( aDADOSEXP )
		Else
		
			MsgInfo("Nใo existem dados a serem exportados! Verifique os parโmetros!")
		
		EndIf
	
	EndIf
		
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExpXLS  บAutor  ณRafael Parma         บ Data ณ  17/06/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExporta็ใo dos dados p/ planilha excel.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------------*
Static Function fExpXLS( aDADOSEXP )
*--------------------------------------*
Local cArquivo := GetNextAlias()
Local cPath	   := AllTrim(GetTempPath())

Private cArqTxt := cPath+cArquivo+".txt"
Private nHdl    := fCreate(cArqTxt)

	If nHdl == -1
	    MsgAlert("O arquivo "+cArqTxt+" nใo pode ser executado! Verifique os parโmetros.","Aten็ใo!")
	    Return
	Endif	
	
	If ! ApOleClient( 'MsExcel' ) 
	 	MsgStop("MsExcel nใo instalado!")
	 	Return
	EndIf

	cLin := "NOTA FISCAL" 	 + ";"
	cLin += "CODIGO" 		 + ";"
	cLin += "NOME" 			 + ";"
	cLin += "LINHA" 		 + ";"
	cLin += "UF" 			 + ";"
	cLin += "MUNICIPIO" 	 + ";"
	cLin += "QUANTIDADE" 	 + ";"
	cLin += "VALOR UNITARIO" + ";"
	cLin += "VALOR TOTAL" 	 + CHR(13)

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na grava็ใo do arquivo. Continua?","Aten็ใo!")
            Return
        Endif
    Endif	

	For nI := 1 to Len(aDADOSEXP)
		
		cLin := aDADOSEXP[nI,01] + ";"
		cLin += aDADOSEXP[nI,02] + ";"
		cLin += aDADOSEXP[nI,03] + ";"
		cLin += aDADOSEXP[nI,04] + ";"
		cLin += aDADOSEXP[nI,05] + ";"
		cLin += aDADOSEXP[nI,06] + ";"
		cLin += cValToChar(aDADOSEXP[nI,07]) + ";"
		cLin += cValToChar(aDADOSEXP[nI,08]) + ";"
		cLin += cValToChar(aDADOSEXP[nI,09]) + CHR(13)

	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na grava็ใo do arquivo. Continua?","Aten็ใo!")
	            Exit
	        Endif
	    Endif	
	
	Next nI
	
	fClose(nHdl)

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqTxt ) // Abre uma planilha
	oExcelApp:SetVisible(.T.) 
		
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  26/05/2010 บฑฑ
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
aHelp12 := {}
aHelp13 := {}
aHelp14 := {}
aHelp15 := {}
aHelp16 := {}
aHelp17 := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","M๊s                ?","M๊s                ?","M๊s                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1301."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1302."})
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1303."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1304."})
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL1305."})
	aAdd(aRegs,{cPerg,"06","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL1306."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1307."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1308."})
	aAdd(aRegs,{cPerg,"09","Municํpio De       ?","Municํpio De       ?","Municํpio De       ?","mv_ch9","C",TAMSX3("A2_COD_MUN")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL1309."})
	aAdd(aRegs,{cPerg,"10","Municํpio At้      ?","Municํpio At้      ?","Municํpio At้      ?","mv_cha","C",TAMSX3("A2_COD_MUN")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL1310."})
	aAdd(aRegs,{cPerg,"11","UF De              ?","UF De              ?","UF De              ?","mv_chb","C",TAMSX3("A2_EST")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1311."})
	aAdd(aRegs,{cPerg,"12","UF At้             ?","UF At้             ?","UF At้             ?","mv_chc","C",TAMSX3("A2_EST")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1312."})
	aAdd(aRegs,{cPerg,"13","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_chd","N",01,0,1,"C","","mv_par13","Codigo Produtor","Codigo Produtor","Codigo Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","Nota Fiscal","Nota Fiscal","Nota Fiscal","","","Municํpio","Municํpio","Municํpio","","","","","","", "","","",".LTREL1313."})
	aAdd(aRegs,{cPerg,"14","Quebrar Pแgina Por ?","Quebrar Pแgina Por ?","Quebrar Pแgina Por ?","mv_che","N",01,0,1,"C","","mv_par14","Linha","Linha","Linha","","","Municํpio","Municํpio","Municํpio","","","","","","","","","","","","","","","","", "","","",".LTREL1314."})
	aAdd(aRegs,{cPerg,"15","Exportar p/ Excel  ?","Exportar p/ Excel  ?","Exportar p/ Excel  ?","mv_chf","N",01,0,1,"C","","mv_par15","Nใo","Nใo","Nใo","","","Sim","Sim","Sim","","","","","","","","","","","","","","","","", "","","",".LTREL1315."})
	aAdd(aRegs,{cPerg,"16","Cond. Pagamento De ?","Cond. Pagamento De ?","Cond. Pagamento De ?","mv_chg","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL1316."})
	aAdd(aRegs,{cPerg,"17","Cond. Pagamento At้?","Cond. Pagamento At้?","Cond. Pagamento At้?","mv_chh","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL1316."})
	aAdd(aRegs,{cPerg,"18","Filial             ?","Filial             ?","Filial             ?","mv_chi","C",TAMSX3("F1_FILIAL")[1],0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","", "XM0","","",".LTREL1317."})

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
	AADD( aHelp09, "Informe o c๓digo do municํpio inicial    " )       
	AADD( aHelp09, "a ser impresso.                          " )       
	AADD( aHelp10, "Informe o c๓digo do municํpio final      " )       
	AADD( aHelp10, "a ser impresso.                          " )
	AADD( aHelp11, "Informe a unidade federativa inicial     " )       
	AADD( aHelp11, "a ser impresso.                          " )       
	AADD( aHelp12, "Informe a unidade federativa final       " )       
	AADD( aHelp12, "a ser impresso.                          " )
	AADD( aHelp13, "Informe por qual indicador os dados      " )       
	AADD( aHelp13, "devem ser ordenados.                     " )
	AADD( aHelp14, "Informe por qual indicador deve ser      " )       
	AADD( aHelp14, "a quebra de pแgina.                      " )
	AADD( aHelp15, "Informe se deseja exportar os dados      " )       
	AADD( aHelp15, "p/ planilha excel.                       " )
	AADD( aHelp16, "Informe o intervalo de condicao de paga- " )	
	AADD( aHelp16, "mento para filtro de produtores.         " )    
	AADD( aHelp17, "Informe a Filial" )
		 
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
	PutSX1Help("P.LTREL1301.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL1302.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL1303.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL1304.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL1305.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL1306.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL1307.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL1308.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL1309.",aHelp09,aHelp09,aHelp09)	
	PutSX1Help("P.LTREL1310.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL1311.",aHelp11,aHelp11,aHelp11)	
	PutSX1Help("P.LTREL1312.",aHelp12,aHelp12,aHelp12)	
	PutSX1Help("P.LTREL1313.",aHelp13,aHelp13,aHelp13)	
	PutSX1Help("P.LTREL1314.",aHelp14,aHelp14,aHelp14)	
	PutSX1Help("P.LTREL1315.",aHelp15,aHelp15,aHelp15)
	PutSX1Help("P.LTREL1316.",aHelp16,aHelp16,aHelp16)
	PutSX1Help("P.LTREL1317.",aHelp17,aHelp17,aHelp17)
		
Return Nil