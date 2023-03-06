#INCLUDE "TOPCONN.CH"                                             
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL011 ºAutor  ³Rafael Parma         º Data ³  22/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão de pagamentos de produtores.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*-----------------------*
User Function LTREL011()
*-----------------------*


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELACAO DE PAGAMENTOS DE PRODUTORES"
Local cPict          := ""
Local titulo         := "RELACAO DE PAGAMENTOS DE PRODUTORES"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := "" 
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00011"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL011"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL011"
Private aVetLin	     := {}

Public DATE_NULL     := ctod("  /  /  ")
Public STRING_NULL   := ""
Public lATPERCFOR    := SuperGetMV("MV_ZLATPN",,.F.)	// Ativo controle de percentual s/ fornecedor p/ gerar documento 


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

	RptStatus({|| ReportPrd(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ReportPrd º Autor ³Rafael Parma        º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão de pagamentos de produtores.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportPrd(Cabec1,Cabec2,Titulo,nLin)

Local nCol         := 60				// coluna de impressão
Local nQTD_TOTAL   := 0					// quantidade total em litros
Local nPRC_LITRO   := 0					// preço total dos litros  
Local nPRC_FRETE   := 0					// preço de frete
Local nUNT_FRETE   := 0					// preco por litro de frete
Local nVLR_PROD    := 0					// valor total da produção   
Local nVLR_DESP    := 0					// valor total de despesas
Local nVLR_CRED    := 0					// valor total de creditos 
Local nTOTPROD     := 0
Local cLINHA       := STRING_NULL		// linha do produtor
Local cAliasTMP    := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13) 
Local lSTART_DATE  := .F.
Local lEND_DATE    := .F.
                
Local nQTD_TOTANT  := 0
Local nPRC_LITANT  := 0
Local nPRC_FRTANT  := 0
Local nUNT_FRTANT  := 0
Local aDADOSTMP    := {}

Local dSTART_DATE  := ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do período
Local dEND_DATE    := dSTART_DATE	  					// último dia do período
Local dCURR_DATE   := dSTART_DATE    				  	// dia do registro em processamento
Local dLAST_DATE   := dSTART_DATE	  					// último dia impresso
Local cMV_ZLTPRD   := AllTRIM(GetMV("MV_ZLTPRD"))		// código do produto
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// código da TES de movimento
Local nAlsenar := POSICIONE("SF4",1,xFilial("SF4")+cMV_ZLTTES,"F4_ALSENAR")
Local nAlInss   := 0

nMV_PAR01 := mv_par01
nMV_PAR02 := mv_par02

If dSTART_DATE == ctod("01/12/2014") .AND. mv_par12 == 2
	dSTART_DATE  := ctod("31/"+StrZERO(nMV_PAR01,2)+"/"+StrZERO(nMV_PAR02,4))
EndIf

If mv_par12 == 2 .AND. dSTART_DATE < ctod("01/12/2014") // A partir dessa data a emissão passou a ser no mês do movimento
	If nMV_PAR01 == 12
		nMV_PAR01 := 1
		nMV_PAR02 := nMV_PAR02 + 1
	Else
		nMV_PAR01 := nMV_PAR01 + 1
	EndIf
	dSTART_DATE  := ctod("01/"+StrZERO(nMV_PAR01,2)+"/"+StrZERO(nMV_PAR02,4))
EndIf


If U_YIsBis(nMV_PAR02)
	dEND_DATE := ctod(Iif(StrZero(nMV_PAR01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(nMV_PAR01,2)=="02","29","30"))+"/"+StrZero(nMV_PAR01,2)+"/"+StrZero(nMV_PAR02,4))
Else
	dEND_DATE := ctod(Iif(StrZero(nMV_PAR01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(nMV_PAR01,2)=="02","28","30"))+"/"+StrZero(nMV_PAR01,2)+"/"+StrZero(nMV_PAR02,4))
EndIf

If ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4)) == ctod("01/11/2014") .AND. mv_par12 == 2
	dEND_DATE  := ctod("30/"+StrZERO(nMV_PAR01,2)+"/"+StrZERO(nMV_PAR02,4))
EndIf

/* ** 21/01/2015 - Alexandre - Q
	If U_YIsBis(mv_par02) 
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","29","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))
    Else
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","28","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))   
    EndIf
*/


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro dos pedidos de acordo com os parametros informados pelo usuário. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	If mv_par12 == 1
		    
		cQuery := "SELECT 	ZL5.ZL5_LINHA 	LINHA,  									" + hEnter    
		cQuery += "			ZL6.ZL6_PRODUT 	PRODUT,										" + hEnter
		cQuery += "			ZL6.ZL6_LOJPRD	LOJPRD,										" + hEnter
		cQuery += "			SA2.A2_NOME		NOMPRD,										" + hEnter
		cQuery += "			SUM(ZL6.ZL6_QTDE) ZL6_QTDE									" + hEnter
		cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" + hEnter
		cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          " + hEnter		
		cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             " + hEnter
		
		cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0   							" + hEnter
		cQuery += "ON       ZL5.ZL5_FILIAL    = ZL0.ZL0_FILIAL                          " + hEnter		
		cQuery += "AND      ZL5.ZL5_LINHA     = ZL0.ZL0_COD                             " + hEnter
		
		cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" + hEnter
		cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	" + hEnter		
		cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	" + hEnter		
	
		cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "' 				" + hEnter
	    // filtro por linha
	    If mv_par09 == 1   
			cQuery += "AND ( ZL5.ZL5_LINHA  BETWEEN '" + mv_par03       + "' 			" + hEnter
			cQuery += "AND                 		    '" + mv_par04       + "' )			" + hEnter 
			cQuery += "AND ( ZL0.ZL0_CODRES BETWEEN '" + mv_par28       + "' 			" + hEnter
			cQuery += "AND                 		    '" + mv_par29       + "' )			" + hEnter
	    // filtro por produtor
	    Else                  
			cQuery += "AND ( ZL6.ZL6_PRODUT BETWEEN '" + mv_par05       + "' 			" + hEnter
			cQuery += "AND                		    '" + mv_par06       + "' )			" + hEnter
			cQuery += "AND ( ZL6.ZL6_LOJPRD BETWEEN '" + mv_par07       + "' 			" + hEnter
			cQuery += "AND                          '" + mv_par08       + "' )			" + hEnter
	    EndIf
		cQuery += "AND ( ZL5.ZL5_DATA       BETWEEN '" + DTOS(dSTART_DATE) + "' 		" + hEnter
		cQuery += "AND                          	'" + DTOS(dEND_DATE)   + "' )		" + hEnter
		cQuery += "AND ( SA2.A2_COD_MUN BETWEEN '" + mv_par16       + "' 				" + hEnter
		cQuery += "AND                          '" + mv_par17       + "' )				" + hEnter
		cQuery += "AND ( SA2.A2_EST     BETWEEN '" + mv_par18       + "' 				" + hEnter
		cQuery += "AND                          '" + mv_par19       + "' )				" + hEnter
		cQuery += "AND ( SA2.A2_COND    BETWEEN '" + mv_par20       + "' 				" + hEnter
		cQuery += "AND      	            	'" + mv_par21       + "' )				" + hEnter						
		cQuery += "AND ZL5.ZL5_STATUS         = '' 										" + hEnter
		cQuery += "AND ZL5.D_E_L_E_T_        != '*' 									" + hEnter
		cQuery += "AND ZL6.D_E_L_E_T_        != '*' 									" + hEnter
		cQuery += "AND SA2.D_E_L_E_T_        != '*' 									" + hEnter
		cQuery += "GROUP BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 								" + hEnter
		cQuery += "			ZL6.ZL6_LOJPRD, SA2.A2_NOME		 							" + hEnter
		If mv_par10 == 1
			cQuery += "ORDER BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, ZL6.ZL6_LOJPRD			" + hEnter
		ElseIf mv_par10 == 2                                                                      
			cQuery += "ORDER BY ZL5.ZL5_LINHA, SA2.A2_NOME								" + hEnter
		Else
			cQuery += "ORDER BY ZL6_QTDE DESC 											" + hEnter
		EndIf		

	Else
        
		If mv_par12 == 1
			cQuery := "SELECT 	SA2.A2_X_LINHA	LINHA, 									" + hEnter    
		Else
			cQuery := "SELECT 	SF1.F1_X_LINHA	LINHA, 									" + hEnter    
		EndIf
		cQuery += "			SF1.F1_FORNECE	PRODUT,										" + hEnter
		cQuery += "			SF1.F1_LOJA		LOJPRD,										" + hEnter
		cQuery += "			SA2.A2_NOME		NOMPRD,										" + hEnter
		cQuery += "			SUM(SD1.D1_QTDEDEV) D1_QTDEDEV,								" + hEnter
	   //	cQuery += "			SUM(SD1.D1_QUANT) D1_QUANT,									" + hEnter
		cQuery += "			SUM( CASE WHEN SD1.D1_QUANT = 1 THEN 0 ELSE SD1.D1_QUANT END ) D1_QUANT,		" + hEnter
		// SD1.D1_QUANT = 1 (referente a nota de complemento lancada como normal quantidade 1)
		//cQuery += "			SUM(SD1.D1_VUNIT) D1_VUNIT,									" + hEnter		
		cQuery += "			SUM(SD1.D1_TOTAL) D1_TOTAL,									" + hEnter
		cQuery += "			SUM(SD1.D1_VALDEV) D1_VALDEV,								" + hEnter
		cQuery += "			COUNT(*) QTDREG												" + hEnter
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
		If mv_par09 == 1   
				cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0 					" + hEnter
				cQuery += "ON       SF1.F1_FILIAL    = ZL0.ZL0_FILIAL                   " + hEnter		
				cQuery += "AND      SF1.F1_X_LINHA   = ZL0.ZL0_COD                      " + hEnter
		EndIf
		cQuery += "WHERE    SF1.F1_FILIAL     = '" + xFilial("SF1") + "' 				" + hEnter
		
	    
	    // filtro por linha
	    If mv_par09 == 1   
			If mv_par12 == 1
				cQuery += "AND ( SA2.A2_X_LINHA BETWEEN '" + mv_par03       + "' 		" + hEnter
				cQuery += "AND                 		    '" + mv_par04       + "' )		" + hEnter
							
			Else			
				cQuery += "AND ( ZL0.ZL0_CODRES BETWEEN '" + mv_par28       + "' 		" + hEnter
				cQuery += "AND                 		    '" + mv_par29       + "' )		" + hEnter
				cQuery += "AND ( SF1.F1_X_LINHA BETWEEN '" + mv_par03       + "' 		" + hEnter
				cQuery += "AND                 		    '" + mv_par04       + "' )		" + hEnter
			EndIf
	    // filtro por produtor
	    Else                  
			cQuery += "AND ( SF1.F1_FORNECE BETWEEN '" + mv_par05       + "' 			" + hEnter
			cQuery += "AND                		    '" + mv_par06       + "' )			" + hEnter
			cQuery += "AND ( SF1.F1_LOJA    BETWEEN '" + mv_par07       + "' 			" + hEnter
			cQuery += "AND                          '" + mv_par08       + "' )			" + hEnter
	    EndIf
		cQuery += "AND (( SF1.F1_EMISSAO     BETWEEN '" + DTOS(dSTART_DATE) + "' 		" + hEnter
		cQuery += "AND                          	'" + DTOS(dEND_DATE)   + "' )		" + hEnter
		cQuery += "OR SF1.F1_NUMRPS	= '"+StrZERO(nMV_PAR01,2)+StrZERO(nMV_PAR02,4)+"')	" + hEnter
		cQuery += "AND ( SA2.A2_COD_MUN BETWEEN '" + mv_par16       + "' 				" + hEnter
		cQuery += "AND                          '" + mv_par17       + "' )				" + hEnter
		cQuery += "AND ( SA2.A2_EST     BETWEEN '" + mv_par18       + "' 				" + hEnter
		cQuery += "AND                          '" + mv_par19       + "' )				" + hEnter	
		cQuery += "AND ( SA2.A2_COND    BETWEEN '" + mv_par20       + "' 				" + hEnter
		cQuery += "AND      	            	'" + mv_par21       + "' )				" + hEnter						
		If mv_par27 == 2
			cQuery += "AND SA2.A2_X_TIPO		  = 'P'		                            " + hEnter		
		EndIf
		cQuery += "AND SD1.D1_COD	          = '" + cMV_ZLTPRD		+ "' 				" + hEnter
		cQuery += "AND 		SD1.D1_TIPO	    IN ('N','C')			 					" + hEnter
		cQuery += "AND SF1.F1_ESPECIE         = 'SPED'		                            " + hEnter
		cQuery += "AND SF1.D_E_L_E_T_        != '*' 									" + hEnter
		cQuery += "AND SD1.D_E_L_E_T_        != '*' 									" + hEnter
		cQuery += "AND SA2.D_E_L_E_T_        != '*' 									" + hEnter

		If mv_par12 == 1
			cQuery += "GROUP BY SA2.A2_X_LINHA, SF1.F1_FORNECE, 						" + hEnter		
		Else
			cQuery += "GROUP BY SF1.F1_X_LINHA, SF1.F1_FORNECE, 						" + hEnter
		EndIf
		cQuery += "			SF1.F1_LOJA, SA2.A2_NOME		 							" + hEnter

		If mv_par23 == 1
			If mv_par10 == 1
				If mv_par12 == 1
					cQuery += "ORDER BY SA2.A2_X_LINHA, SF1.F1_FORNECE, SF1.F1_LOJA		" + hEnter
				Else
					cQuery += "ORDER BY SF1.F1_X_LINHA, SF1.F1_FORNECE, SF1.F1_LOJA		" + hEnter				
				EndIf
			ElseIf mv_par10 == 2
				If mv_par12 == 1
					cQuery += "ORDER BY SA2.A2_X_LINHA, SA2.A2_NOME						" + hEnter
				Else
					cQuery += "ORDER BY SF1.F1_X_LINHA, SA2.A2_NOME						" + hEnter
				EndIf
			Else	 
				If mv_par12 == 1		
					cQuery += "ORDER BY SA2.A2_X_LINHA, D1_QUANT DESC					" + hEnter
				Else
					cQuery += "ORDER BY SF1.F1_X_LINHA, D1_QUANT DESC					" + hEnter	
				EndIf				
			EndIf		
		Else
			If mv_par10 == 1
				cQuery += "ORDER BY SF1.F1_FORNECE, SF1.F1_LOJA							" + hEnter
			ElseIf mv_par10 == 2
				cQuery += "ORDER BY SA2.A2_NOME											" + hEnter
			Else			
				cQuery += "ORDER BY D1_QUANT DESC										" + hEnter
			EndIf		
		EndIf
	                        	
	EndIf
	                        
	memowrite("LTREL011_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
	
	
	nTQTD_TOTAL := 0
	nTPRC_LITRO := 0
	nTUNT_FRETE := 0
	nTUNT_CSOC  := 0
	nTVLR_PROD  := 0
	nTPRC_FRETE := 0
	nTVLR_CSOC  := 0
	nTPRC_LIQ   := 0
	nTVLR_DESP  := 0
	nTVLR_CRED  := 0
	nTVLR_LIQ   := 0
	nTTOTPROD   := 0
	
	nTPRC_LANT  := 0
	nTQTD_TANT  := 0	
	nTUNT_CANT  := 0
	nTPRC_FANT  := 0
    nTVLR_PANT  := 0

	nLQTD_TOTAL := 0
	nLPRC_LITRO := 0
	nLUNT_FRETE := 0
	nLUNT_CSOC  := 0
	nLVLR_PROD  := 0
	nLPRC_FRETE := 0
	nLVLR_CSOC  := 0
	nLPRC_LIQ   := 0
	nLVLR_DESP  := 0
	nLVLR_CRED  := 0
	nLVLR_LIQ   := 0	
	nLTOTPROD   := 0	 
	
	nLPRC_LANT  := 0
	nLQTD_TANT  := 0
	nLUNT_CANT  := 0
	nLPRC_FANT  := 0
	nLVLR_PANT  := 0

	If mv_par25 == 1
		//--Adiciona ao array a quantidade/valor unitarior referente a movimentacao de notas fiscais.
		fCalcMesAnt(@aDADOSTMP)
	EndIf


	While (cAliasTMP)->(!EOF())
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif  
		
       	If mv_par12 == 1            
       		If (cAliasTMP)->ZL6_QTDE == 0
       			(cAliasTMP)->(dbSkip())
       			Loop
       		EndIf
    	EndIf
		
				
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Impressao do cabecalho do relatorio. . .                            ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  		
  		If cLINHA != (cAliasTMP)->LINHA .and. mv_par23 == 1


		    If cLINHA != STRING_Null                 
		    
		    	nLPRC_LITRO  := Round(nLVLR_PROD / nLQTD_TOTAL, 7)
		    	//nLPRC_LIQ 	 := Round(nLPRC_LIQ / nTOTPROD, 4)
		    	nLPRC_LIQ 	 := Round((nLVLR_PROD - nLPRC_FRETE - nLVLR_CSOC) / nLQTD_TOTAL, 7)
		    	
		    	nLPRC_LANT   := Round((nLVLR_PANT - nLPRC_FANT - nLUNT_CANT) / nLQTD_TANT, 4)
		    	
		        nLin += 1
		    	@nLin,000 PSAY "NUMERO PRODUTORES ---> " + cValToChar(nTOTPROD)
		    	nLin += 1
		    	@nLin,000 PSAY "TOTAL --->"      	
				@nLin,051 PSAY nLQTD_TOTAL PICTURE "@E 99999999"
				@nLin,064 PSAY nLPRC_LITRO PICTURE "@E 9.9999"
				//@nLin,072 PSAY nLUNT_FRETE PICTURE "@E 99,999.9999"		
				//@nLin,084 PSAY nLUNT_CSOC  PICTURE "@E 99,999.99"		
				@nLin,094 PSAY nLVLR_PROD  PICTURE "@E 999,999,999.99"				
				@nLin,109 PSAY nLPRC_FRETE PICTURE "@E 999,999,999.99"		
				@nLin,126 PSAY nLVLR_CSOC  PICTURE "@E 99,999.99"		
				@nLin,141 PSAY nLPRC_LIQ   PICTURE "@E 9.9999"				
				If mv_par26 == 1
					@nLin,148 PSAY nLVLR_DESP  PICTURE "@E 9,999,999.99"		
					@nLin,161 PSAY nLVLR_CRED  PICTURE "@E 9,999,999.99"		
				EndIf
		        @nLin,174 PSAY nLVLR_LIQ   PICTURE "@E 999,999,999.99"	        
		        /*If mv_par25 == 1
			        @nLin,193 PSAY nLQTD_TANT  PICTURE "@E 99999999"
			        @nLin,205 PSAY nLPRC_LANT  PICTURE "@E 9.9999"   
			        @nLin,214 PSAY (nLPRC_LIQ-nLPRC_LANT)  PICTURE "@E 9.9999"   
			 	EndIf			
				*/
				aAdd ( aVetLin, { cLINHA, nLQTD_TOTAL, nLPRC_LITRO, nLUNT_FRETE, nLUNT_CSOC, nLVLR_PROD, nLPRC_FRETE, nLVLR_CSOC, nLPRC_LIQ, nLVLR_DESP, nLVLR_CRED, nLVLR_LIQ, nLQTD_TANT, nLPRC_LANT, nTOTPROD} )
				
				nLQTD_TOTAL := 0
				nLPRC_LITRO := 0
				nLUNT_FRETE := 0
				nLUNT_CSOC  := 0
				nLVLR_PROD  := 0
				nLPRC_FRETE := 0
				nLVLR_CSOC  := 0
				nLPRC_LIQ   := 0
				nLVLR_DESP  := 0
				nLVLR_CRED  := 0
				nLVLR_LIQ   := 0				
				nLTOTPROD   := 0
				nTOTPROD    := 0

				nLPRC_LANT  := 0
				nLQTD_TANT  := 0
				nLUNT_CANT  := 0
				nLPRC_FANT  := 0
				nLVLR_PANT  := 0
							
			EndIf
						        	        
	        dbSelectArea("ZL0")
	        dbSetOrder(1)
	        dbSeek( xFilial("ZL0") + (cAliasTMP)->LINHA )                            
	        
	        Cabec1 := "Período de: " + DTOC(dSTART_DATE) + " até: " + DTOC(dEND_DATE)
	        Cabec1 += " - " + SubSTR(ZL0->ZL0_DESC, 1,40) + " - " + iif(mv_par12 == 1, "PELO MOVIMENTO DO LEITE", "PELAS NOTAS FISCAIS - MOV.: " + StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4) )
			Cabec2 := "Transportador: " + ZL0->ZL0_TRANSP + "/" + ALLTRIM(ZL0_NOMTRP)			
	        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       

	        nLin := 9

			/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		    CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO
			*/  
			
	        If mv_par25 == 1
	        	If mv_par26 == 1
	        		@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO  QTD.MES.ANT  LIQ.M.A.  DIF.M.A"
	        	Else
	        		@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ                               VL.LIQUIDO  QTD.MES.ANT  LIQ.M.A.  DIF.M.A"
	        	EndIf
	        Else                
	        	If mv_par26 == 1
					@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO"	        
				Else
					@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ                               VL.LIQUIDO"	        
				EndIf
	        EndIf
			
			nLin+= 1
			@nLin,000 PSAY __PrtThinLine()
			nLin+= 1

		EndIf 
		

		If nLin > 65 	
        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
  			nLin := 9

	        If mv_par25 == 1
	        	If mv_par26 == 1
	        		@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO  QTD.MES.ANT  LIQ.M.A.  DIF.M.A"
	        	Else
	        		@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ                               VL.LIQUIDO  QTD.MES.ANT  LIQ.M.A.  DIF.M.A"
	        	EndIf
	        Else                
	        	If mv_par26 == 1
					@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO"	        
				Else
					@nLin,000 PSAY "CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ                               VL.LIQUIDO"	        
				EndIf
	        EndIf

			nLin+= 1
			@nLin,000 PSAY __PrtThinLine()
			nLin+= 1
  		EndIf   		
		 		
	
       	fTotalDesp( dSTART_DATE, dEND_DATE, (cAliasTMP)->PRODUT, (cAliasTMP)->LOJPRD, @nVLR_DESP, @nVLR_CRED )
    
       	If mv_par12 == 1
    
       		nQTD_TOTAL:= (cAliasTMP)->ZL6_QTDE 
       		fCalcProd( mv_par11, (cAliasTMP)->PRODUT, (cAliasTMP)->LOJPRD, (cAliasTMP)->LINHA, nQTD_TOTAL, @nPRC_LITRO, @nVLR_PROD, @nPRC_FRETE )
    
       	Else
    
       		fCalcProd( mv_par11, (cAliasTMP)->PRODUT, (cAliasTMP)->LOJPRD, (cAliasTMP)->LINHA, nQTD_TOTAL, @nPRC_LITRO, @nVLR_PROD, @nPRC_FRETE )
       		
       		nQTD_TOTAL := ((cAliasTMP)->D1_QUANT - (cAliasTMP)->D1_QTDEDEV)
       		//nPRC_LITRO := (cAliasTMP)->D1_VUNIT / (cAliasTMP)->QTDREG
       		nPRC_LITRO := ((cAliasTMP)->D1_TOTAL - (cAliasTMP)->D1_VALDEV) / ((cAliasTMP)->D1_QUANT - (cAliasTMP)->D1_QTDEDEV)
       		nVLR_PROD  := ((cAliasTMP)->D1_TOTAL - (cAliasTMP)->D1_VALDEV)
       		
       	EndIf
       	
       	dbSelectArea("SA2")
       	dbSetOrder(1)
       	dbSeek( xFilial("SA2") +  (cAliasTMP)->PRODUT + (cAliasTMP)->LOJPRD )

        dbSelectArea("ZL0")
        dbSetOrder(1)
        dbSeek( xFilial("ZL0") + SA2->A2_X_LINHA )

       	dbSelectArea("SA4")
       	dbSetOrder(1)
       	dbSeek( xFilial("SA4") +  ZL0->ZL0_TRANSP )
       	
       	If POSICIONE("SA2",1,xFilial("SA2")+SA4->A4_X_FORN+SA4->A4_X_LOJF,"A2_TIPO") == "F"
       		nUNT_FRETE := nPRC_FRETE
       		nPRC_FRETE := nPRC_FRETE * nQTD_TOTAL
       	Else                        
       		nUNT_FRETE := 0
       		nPRC_FRETE := 0         
       	EndIf
       	
       	dbSelectArea("SA2")
       	dbSetOrder(1)
       	dbSeek( xFilial("SA2") +  (cAliasTMP)->PRODUT + (cAliasTMP)->LOJPRD )

		cTipoRur  := SA2->A2_TIPORUR
		aPFunRur  := FunRur()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³aPFunRur[1]  == "F"³
		//³aPFunRur[2]  == "L"³
		//³aPFunRur[3]  == "J"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nPCFAT    := SA2->A2_X_PCDOC
		nVLR_CSOC := 0
		nUNT_CSOC := 0 
		nPosPer   := at(cTipoRur,"FLJ")
		nAlInss := POSICIONE("SED",1,XFILIAL("SED")+SA2->A2_NATUREZ,"ED_PERCINS")
		If nPosPer > 0 
			If cTipoRur != "J"
				If cTipoRur = "F"
					nAliquota := Val(aPFunRur[nPosPer]) + nAlsenar + nAlInss
				ElseIf cTipoRur = "L"
					nAliquota := nAlsenar
				EndIf                      
				If SA2->A2_X_PCONT > 0
					nAliquota := SA2->A2_X_PCONT + nAlsenar
				EndIf
				//-- Controle de serie de nota fiscal diferentes.
				If lATPERCFOR		
					nVLR_CSOC := ( (nVLR_PROD * nPCFAT / 100) * nAliquota) /100
					nUNT_CSOC := ( (nPRC_LITRO * nPCFAT / 100) * nAliquota) /100
				Else		
					nVLR_CSOC := (nVLR_PROD * nAliquota) /100
					nUNT_CSOC := (nPRC_LITRO * nAliquota) /100
				EndIf
			EndIf
		EndIf 
		    
	    
        //VALOR LIQUIDO
        nVLR_LIQ := Round( (nVLR_PROD + nVLR_CRED) - (nVLR_CSOC + nVLR_DESP + nPRC_FRETE), 4)
        nPRC_LIQ := Round( nPRC_LITRO - (nUNT_CSOC + nUNT_FRETE), 4)

			/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		    CODIGO    NOME PRODUTOR                 LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO  QTD.MES.ANT  LIQ.M.A.  DIF.M.A
                                                               99999999     9.9999  99,999.99   99,999.99 999,999,999.99 999,999,999.99    99,999.99     9.9999 9,999,999.99 9,999,999.99 999,999,999.99     99999999    9.9999   9.9999  
			*/  

            
		nPOS := aScan ( aDADOSTMP, {|x| x[1] == (cAliasTMP)->PRODUT .and. x[2] == (cAliasTMP)->LOJPRD .and. x[3] == (cAliasTMP)->LINHA } )
		If nPOS != 0
			nQTD_TANT := aDADOSTMP[nPOS,04]
			nPRC_LANT := aDADOSTMP[nPOS,05]
			nUNT_FANT := aDADOSTMP[nPOS,06]
			nUNT_CANT := aDADOSTMP[nPOS,07]
			nVLR_PANT := aDADOSTMP[nPOS,08]
		Else
			nQTD_TANT := 0
			nPRC_LANT := 0		
			nUNT_FANT := 0
			nUNT_CANT := 0
			nVLR_PANT := 0
		EndIf

        
        @nLin,000 PSAY (cAliasTMP)->PRODUT 
        @nLin,010 PSAY SubSTR((cAliasTMP)->NOMPRD,1,28)                                                                        
		@nLin,040 PSAY (cAliasTMP)->LINHA        
		@nLin,051 PSAY nQTD_TOTAL PICTURE "@E 99999999"
		@nLin,064 PSAY nPRC_LITRO PICTURE "@E 9.9999"
		@nLin,072 PSAY nUNT_FRETE PICTURE "@E 99,999.9999"		
		@nLin,084 PSAY nAliquota  PICTURE "@E 99,999.99"		
		@nLin,094 PSAY nVLR_PROD  PICTURE "@E 999,999,999.99"		
		@nLin,109 PSAY nPRC_FRETE PICTURE "@E 999,999,999.99"		
		@nLin,126 PSAY nVLR_CSOC  PICTURE "@E 99,999.99"		
		@nLin,141 PSAY nPRC_LIQ   PICTURE "@E 9.9999"				
		If mv_par26 == 1
			@nLin,148 PSAY nVLR_DESP  PICTURE "@E 9,999,999.99"		
			@nLin,161 PSAY nVLR_CRED  PICTURE "@E 9,999,999.99"		
		EndIf
        @nLin,174 PSAY nVLR_LIQ   PICTURE "@E 999,999,999.99"
        If mv_par25 == 1
        	@nLin,193 PSAY nQTD_TANT  PICTURE "@E 99999999"
        	@nLin,205 PSAY nPRC_LANT  PICTURE "@E 9.9999"   
        	@nLin,214 PSAY (nPRC_LIQ-nPRC_LANT)  PICTURE "@E 9.9999"   
        EndIf
        

		nTQTD_TOTAL += nQTD_TOTAL
		nTPRC_LITRO += nPRC_LITRO
		nTUNT_FRETE += nUNT_FRETE
		nTUNT_CSOC  += nUNT_CSOC
		nTVLR_PROD  += nVLR_PROD
		nTPRC_FRETE += nPRC_FRETE
		nTVLR_CSOC  += nVLR_CSOC
		nTPRC_LIQ   += nPRC_LIQ
		nTVLR_DESP  += nVLR_DESP
		nTVLR_CRED  += nVLR_CRED
		nTVLR_LIQ   += nVLR_LIQ		
		
		nTPRC_LANT  += nPRC_LANT
		nTQTD_TANT  += nQTD_TANT
		nTPRC_FANT  += nUNT_FANT
		nTUNT_CANT  += nUNT_CANT
		nTVLR_PANT  += nVLR_PANT
		

		nLQTD_TOTAL += nQTD_TOTAL
		nLPRC_LITRO += nPRC_LITRO
		nLUNT_FRETE += nUNT_FRETE
		nLUNT_CSOC  += nUNT_CSOC
		nLVLR_PROD  += nVLR_PROD
		nLPRC_FRETE += nPRC_FRETE
		nLVLR_CSOC  += nVLR_CSOC
		nLPRC_LIQ   += nPRC_LIQ
		nLVLR_DESP  += nVLR_DESP
		nLVLR_CRED  += nVLR_CRED
		nLVLR_LIQ   += nVLR_LIQ
		
		nLPRC_LANT  += nPRC_LANT
		nLQTD_TANT  += nQTD_TANT
		nLPRC_FANT  += nUNT_FANT
		nLUNT_CANT  += nUNT_CANT
		nLVLR_PANT  += nVLR_PANT
				                                  
		cLINHA    := (cAliasTMP)->LINHA
		nTOTPROD  += 1		
		nTTOTPROD += 1		                
		nLTOTPROD += 1		                
				
		nLin += 1
		IncRegua()
	    (cAliasTMP)->(dbSkip())
	   		
	EndDo
                
	(cAliasTMP)->(dbCloseArea())    

    If nLQTD_TOTAL > 0
                                                                         
        nLPRC_LITRO  := Round(nLVLR_PROD / nLQTD_TOTAL, 7)       
		//nLPRC_LIQ 	 := Round(nLPRC_LIQ / nLTOTPROD, 4)
		nLPRC_LIQ 	 := Round((nLVLR_PROD - nLPRC_FRETE - nLVLR_CSOC) / nLQTD_TOTAL, 7)
		
		nLPRC_LANT   := Round((nLVLR_PANT - nLPRC_FANT - nLUNT_CANT) / nLQTD_TANT, 4)

        nLin += 1
    	@nLin,000 PSAY "NUMERO PRODUTORES ---> " + cValToChar(nTOTPROD)

        
        If mv_par23 == 1
	        nLin += 1
	    	@nLin,000 PSAY "TOTAL --->"      	
			@nLin,051 PSAY nLQTD_TOTAL PICTURE "@E 99999999"
			@nLin,064 PSAY nLPRC_LITRO PICTURE "@E 9.9999"
			//@nLin,072 PSAY nLUNT_FRETE PICTURE "@E 99,999.9999"		
			//@nLin,084 PSAY nLUNT_CSOC  PICTURE "@E 99,999.99"		
			@nLin,094 PSAY nLVLR_PROD  PICTURE "@E 999,999,999.99"		
			@nLin,109 PSAY nLPRC_FRETE PICTURE "@E 999,999,999.99"		
			@nLin,126 PSAY nLVLR_CSOC  PICTURE "@E 99,999.99"		
			@nLin,141 PSAY nLPRC_LIQ   PICTURE "@E 9.9999"
			If mv_par26 == 1
				@nLin,148 PSAY nLVLR_DESP  PICTURE "@E 9,999,999.99"		
				@nLin,161 PSAY nLVLR_CRED  PICTURE "@E 9,999,999.99"		
			EndIf
	        @nLin,174 PSAY nLVLR_LIQ   PICTURE "@E 999,999,999.99"
	       /* If mv_par25 == 1
	        	@nLin,193 PSAY nLQTD_TANT  PICTURE "@E 99999999"
	        	@nLin,205 PSAY nLPRC_LANT  PICTURE "@E 9.9999"   
	        	@nLin,214 PSAY (nLPRC_LIQ-nLPRC_LANT)  PICTURE "@E 9.9999"   
	        EndIf
		   */
	  	EndIf

        //-- última linha de coleta
        aAdd ( aVetLin, { cLINHA, nLQTD_TOTAL, nLPRC_LITRO, nLUNT_FRETE, nLUNT_CSOC, nLVLR_PROD, nLPRC_FRETE, nLVLR_CSOC, nLPRC_LIQ, nLVLR_DESP, nLVLR_CRED, nLVLR_LIQ, nLQTD_TANT, nLPRC_LANT, nTOTPROD} )
			                                  
	EndIf		
	
    If nLQTD_TOTAL > 0
        
        nTPRC_LITRO  := Round(nTVLR_PROD / nTQTD_TOTAL, 7)
        //nTPRC_LIQ    := Round(nTPRC_LIQ / nTTOTPROD, 4)
        nTPRC_LIQ 	 := Round((nTVLR_PROD - nTPRC_FRETE - nTVLR_CSOC) / nTQTD_TOTAL, 7)
        
        nTPRC_LANT   := Round((nTVLR_PANT - nTPRC_FANT - nTUNT_CANT) / nTQTD_TANT, 4)
                            
        nLin += 1
    	@nLin,000 PSAY "TOTAL GERAL--->"      	
		@nLin,051 PSAY nTQTD_TOTAL PICTURE "@E 99999999"
		@nLin,064 PSAY nTPRC_LITRO PICTURE "@E 9.9999"
		//@nLin,072 PSAY nTUNT_FRETE PICTURE "@E 99,999.9999"		
		//@nLin,084 PSAY nTUNT_CSOC  PICTURE "@E 99,999.99"		
		@nLin,094 PSAY nTVLR_PROD  PICTURE "@E 999,999,999.99"		
		@nLin,109 PSAY nTPRC_FRETE PICTURE "@E 999,999,999.99"		
		@nLin,126 PSAY nTVLR_CSOC  PICTURE "@E 99,999.99"		
		@nLin,141 PSAY nTPRC_LIQ   PICTURE "@E 9.9999"
		If mv_par26 == 1
			@nLin,148 PSAY nTVLR_DESP  PICTURE "@E 9,999,999.99"		
			@nLin,161 PSAY nTVLR_CRED  PICTURE "@E 9,999,999.99"		
		EndIf
        @nLin,174 PSAY nTVLR_LIQ   PICTURE "@E 999,999,999.99"
        /*If mv_par25 == 1
        	@nLin,193 PSAY nTQTD_TANT  PICTURE "@E 99999999"
        	@nLin,205 PSAY nTPRC_LANT  PICTURE "@E 9.9999"   
        	@nLin,214 PSAY (nTPRC_LIQ-nTPRC_LANT)  PICTURE "@E 9.9999"   
        EndIf
        */

	EndIf		
    
	If mv_par15 == 1    
	   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
		nLin := 9

        If mv_par25 == 1
        	If mv_par26 == 1
	        	@nLin,000 PSAY "                   LINHA/RESP.      QTD PROD     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO  QTD.MES.ANT  LIQ.M.A.  DIF.M.A"
	        Else
	        	@nLin,000 PSAY "                   LINHA/RESP.      QTD PROD     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ                               VL.LIQUIDO  QTD.MES.ANT  LIQ.M.A.  DIF.M.A"
	        EndIf
        Else                
        	If mv_par26 == 1
				@nLin,000 PSAY "                                        LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ    VL.DEBITO   VL.CREDITO     VL.LIQUIDO"
			Else
				@nLin,000 PSAY "                                        LINHA     QTD.LEITE  VL.UN.BRT  VL.UN.FRT  VL.UN.FUNR    VL.PRODUCAO   VL.TOT.FRETE  VL.TOT.FUNR  VL.UN.LIQ                               VL.LIQUIDO"
			EndIf
        EndIf

		nLin+= 1
		@nLin,000 PSAY __PrtThinLine()
		nLin+= 1

		For i := 1 to Len(aVetLin)
			nLin+= 1
			@nLin,015 PSAY Alltrim(aVetLin[i][01]) + " - " +Posicione("ZL0",1,xFilial("ZL0")+Alltrim(aVetLin[i][01]),"ZL0_NOMRES")
			@nLin,040 PSAY cValToChar(aVetLin[i][15])
			@nLin,051 PSAY aVetLin[i][02] PICTURE "@E 99999999"
			@nLin,064 PSAY aVetLin[i][03] PICTURE "@E 9.9999999"
			//@nLin,072 PSAY aVetLin[i][04] PICTURE "@E 99,999.9999"		
			//@nLin,084 PSAY aVetLin[i][05] PICTURE "@E 99,999.99"	
			@nLin,094 PSAY aVetLin[i][06] PICTURE "@E 999,999,999.99"		
			@nLin,109 PSAY aVetLin[i][07] PICTURE "@E 999,999,999.99"		
			@nLin,126 PSAY aVetLin[i][08] PICTURE "@E 99,999.99"	
			@nLin,141 PSAY aVetLin[i][09] PICTURE "@E 9.9999"
			If mv_par26 == 1
				@nLin,148 PSAY aVetLin[i][10] PICTURE "@E 9,999,999.99"		
				@nLin,161 PSAY aVetLin[i][11] PICTURE "@E 9,999,999.99"		
			EndIf
	        @nLin,174 PSAY aVetLin[i][12] PICTURE "@E 999,999,999.99"
	       /* If mv_par25 == 1
	        	@nLin,193 PSAY aVetLin[i][13] PICTURE "@E 99999999"
	        	@nLin,205 PSAY aVetLin[i][14] PICTURE "@E 9.9999"   
	        	@nLin,214 PSAY (aVetLin[i][09]-aVetLin[i][14]) PICTURE "@E 9.9999"   
	        EndIf
		    */    
		Next i
                    
	    nLin += 1
  		@nLin,000 PSAY "TOTAL GERAL--->"      	
		@nLin,050 PSAY nTQTD_TOTAL PICTURE "@E 99999999"
		@nLin,063 PSAY nTPRC_LITRO PICTURE "@E 9.9999999"
	    //@nLin,071 PSAY nTUNT_FRETE PICTURE "@E 99,999.9999"		
		//@nLin,083 PSAY nTUNT_CSOC  PICTURE "@E 99,999.99"		
		@nLin,093 PSAY nTVLR_PROD  PICTURE "@E 999,999,999.99"		
		@nLin,108 PSAY nTPRC_FRETE PICTURE "@E 999,999,999.99"		
		@nLin,125 PSAY nTVLR_CSOC  PICTURE "@E 99,999.99"		
		@nLin,140 PSAY nTPRC_LIQ   PICTURE "@E 9.9999"
		If mv_par26 == 1
			@nLin,147 PSAY nTVLR_DESP  PICTURE "@E 9,999,999.99"		
			@nLin,160 PSAY nTVLR_CRED  PICTURE "@E 9,999,999.99"		
		EndIf
        @nLin,173 PSAY nTVLR_LIQ   PICTURE "@E 999,999,999.99"
       /* If mv_par25 == 1
        	@nLin,192 PSAY nTQTD_TANT  PICTURE "@E 99999999"
        	@nLin,204 PSAY nTPRC_LANT  PICTURE "@E 9.9999"   
        	@nLin,213 PSAY (nTPRC_LIQ-nTPRC_LANT)  PICTURE "@E 9.9999"   
        EndIf
       */
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
±±ºPrograma  ³fCalcProd  ºAutor  ³Rafael Parma       º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição do preço a ser pago ao produtor com base nas      º±±
±±º          ³tabelas de preços por faixa ou tabela de exceção.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              

Static Function fCalcProd( nEXCECAO, cPRODUT, cLOJPRD, cLINHA, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nPRC_FRETE )

	nVLR_PROD  := 0
	nPRC_LITRO := 0
	nPRC_FRETE := 0

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
					nPRC_LITRO := ZL2->ZL2_PRCLEI
					nPRC_FRETE := ZL2->ZL2_PRCFRT
				EndIf
			Else
				dbSelectArea("ZL2")
				dbSetOrder(2)
				dbGoTop()   
				If dbSeek ( xFilial("ZL2") + cLINHA )
					While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
						If nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
							nPRC_LITRO := ZL2->ZL2_PRCLEI
							nPRC_FRETE := ZL2->ZL2_PRCFRT
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
			nPRC_LITRO := ZL2->ZL2_PRCLEI                
			nPRC_FRETE := ZL2->ZL2_PRCFRT
		Else
			dbSelectArea("ZL2")
			dbSetOrder(2)	// // ZL2_FILIAL+ZL2_LINHA
			dbGoTop()   
			If dbSeek ( xFilial("ZL2") + cLINHA )
				While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
					If nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
						nPRC_LITRO := ZL2->ZL2_PRCLEI
						nPRC_FRETE := ZL2->ZL2_PRCFRT
						Exit
					EndIf
					ZL2->(dbSkip())
				EndDo
			EndIf
		EndIf     
    
    EndIf

   	If nPRC_LITRO != 0
   		nVLR_PROD := Round ( nPRC_LITRO * nQTD_TOTAL , 4)	
   	EndIf    

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTotalDesp ºAutor  ³Rafael Parma       º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para impressão das despesas do integrado   º±±
±±º          ³com base nas informações da conta corrente. Tabela ZLB.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTotalDesp( dSTART_DATE, dEND_DATE, cPRODUT, cLOJPRD, nVLR_DESP, nVLR_CRED )

Local lCabec     := .F.     
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10) + CHR(13) 

	nVLR_DESP := 0
	nVLR_CRED := 0
	
	//--Nao imprime creditos/debitos
	If mv_par26 == 2
		Return
	EndIf
	    
	If mv_par24 != 2	// Origem movimentos != Financeiro

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DEBITOS CONTA CORRENTE													³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		If (Select(cAliasTMP) <> 0)
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbCloseArea())
		Endif
	
		
		cQuery := "SELECT 	SUM(ZLB.ZLB_VALOR) ZLB_VALOR						" + hEnter
		cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
		cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
		cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
		cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
		cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par13) + "'   	" + hEnter
		cQuery += "AND      				       '" + DTOS(mv_par14) + "'	    " + hEnter
		cQuery += "AND 		ZLB.ZLB_TIPCD     = 'D'							    " + hEnter		
		If mv_par22 != 1
			cQuery += "AND 	ZLB.ZLB_STATUS    = ' '							    " + hEnter			
		EndIf	
		cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	                        
		memowrite("LTREL011_3.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		nVLR_DESP := (cAliasTMP)->ZLB_VALOR 
	    (cAliasTMP)->(dbCloseArea()) 
	    
	    
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CREDITOS CONTA CORRENTE												   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		If (Select(cAliasTMP) <> 0)
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbCloseArea())
		Endif
		    
		cQuery := "SELECT 	SUM(ZLB.ZLB_VALOR) ZLB_VALOR						" + hEnter
		cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
		cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
		cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
		cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
		cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(mv_par13) + "'	    " + hEnter
		cQuery += "AND      				       '" + DTOS(mv_par14) + "'	    " + hEnter
		cQuery += "AND 		ZLB.ZLB_TIPCD     = 'C'							    " + hEnter		
		If mv_par22 != 1
			cQuery += "AND 	ZLB.ZLB_STATUS    = ' '							    " + hEnter			
		EndIf	
		cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	
	                        
		memowrite("LTREL011_4.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		nVLR_CRED := (cAliasTMP)->ZLB_VALOR 
	    (cAliasTMP)->(dbCloseArea())
	    
	EndIf
	               


	If mv_par24 != 1	// Origem movimentos != Conta corrente
                   
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DEBITOS CONTAS A RECEBER     											³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		If (Select(cAliasTMP) <> 0)
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbCloseArea())
		Endif
	
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
			cQuery += "	AND     SE1.E1_VENCREA BETWEEN '" + dtos(mv_par13) + "'			" + hEnter
			cQuery += "	AND     					   '" + dtos(mv_par14) + "'			" + hEnter
			cQuery += "	AND     SE1.E1_SALDO     > 0									" + hEnter
			cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" + hEnter
	
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			While !(cAliasTMP)->(EOF())
			
				If ALLTRIM((cAliasTMP)->E1_TIPO) == "RA" .OR. (cAliasTMP)->E1_TIPO == "NCC"
					nVALORCR := (cAliasTMP)->E1_SALDO * -1
				Else
					nVALORCR := (cAliasTMP)->E1_SALDO
				EndIf
				
				nVLR_DESP += nVALORCR
				
				(cAliasTMP)->(dbSkip())		
			Enddo
		    (cAliasTMP)->(dbCloseArea())    
		    
		    
		
		EndIf
		    
		    
		    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CREDITOS CONTAS A PAGAR												   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		If (Select(cAliasTMP) <> 0)
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbCloseArea())
		Endif
		    
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
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(mv_par13) + "'						" + hEnter
		cQuery += "	AND     					   '" + dtos(mv_par14) + "'						" + hEnter
		cQuery += "	AND     SE2.E2_SALDO     > 0												" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 												" + hEnter

		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())

			If ALLTRIM((cAliasTMP)->E2_TIPO) == "PA" .OR. (cAliasTMP)->E2_TIPO == "NDF"
				nVALORCP := (cAliasTMP)->E2_SALDO * -1
			Else
				nVALORCP := (cAliasTMP)->E2_SALDO
			EndIf
                                   
			nVLR_CRED += nVALORCP
			(cAliasTMP)->(dbSkip())             
			
		Enddo		    
		
	    (cAliasTMP)->(dbCloseArea())
	    
	EndIf

	
Return       



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalcMesAntºAutor  ³Rafael Parma       º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para recuperar a quantidade/valor unitario º±±
±±º          ³referente a movimentacao de notas fiscais.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------------------------------------------*
Static Function fCalcMesAnt(aDADOSTMP)
*----------------------------------------------------------------------------*
Local cAliasANT := GetNextAlias()
Local hEnter := CHR(10) + CHR(13)

Local dSTART_DATE  := ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do período
Local dEND_DATE    := dSTART_DATE	  					// último dia do período
Local dCURR_DATE   := dSTART_DATE    				  	// dia do registro em processamento
Local dLAST_DATE   := dSTART_DATE	  					// último dia impresso
Local cMV_ZLTPRD   := AllTRIM(GetMV("MV_ZLTPRD"))		// código do produto
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// código da TES de movimento
Local nAlsenar := POSICIONE("SF4",1,xFilial("SF4")+cMV_ZLTTES,"F4_ALSENAR")

nMV_PAR01 := mv_par01
nMV_PAR02 := mv_par02

If dSTART_DATE > ctod("01/01/2015") // A partir dessa data a emissão passou a ser no mês do movimento
	If nMV_PAR01 == 1
		nMV_PAR01 := 12
		nMV_PAR02 := nMV_PAR02 - 1
	Else
		nMV_PAR01 := nMV_PAR01 - 1
	EndIf
	dSTART_DATE  := ctod("01/"+StrZERO(nMV_PAR01,2)+"/"+StrZERO(nMV_PAR02,4))
EndIf

If U_YIsBis(nMV_PAR02)
	dEND_DATE := ctod(Iif(StrZero(nMV_PAR01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(nMV_PAR01,2)=="02","29","30"))+"/"+StrZero(nMV_PAR01,2)+"/"+StrZero(nMV_PAR02,4))
Else
	dEND_DATE := ctod(Iif(StrZero(nMV_PAR01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(nMV_PAR01,2)=="02","28","30"))+"/"+StrZero(nMV_PAR01,2)+"/"+StrZero(nMV_PAR02,4))
EndIf

If ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4)) == ctod("01/12/2014")
	dEND_DATE  := ctod("30/"+StrZERO(nMV_PAR01,2)+"/"+StrZERO(nMV_PAR02,4))
EndIf

		If mv_par12 == 1
			cQuery := "SELECT 	SA2.A2_X_LINHA	LINHA, 									" + hEnter    
		Else
			cQuery := "SELECT 	SF1.F1_X_LINHA	LINHA, 									" + hEnter    
		EndIf
		cQuery += "			SF1.F1_FORNECE	PRODUT,										" + hEnter
		cQuery += "			SF1.F1_LOJA		LOJPRD,										" + hEnter
		cQuery += "			SA2.A2_NOME		NOMPRD,										" + hEnter
		cQuery += "			SUM(SD1.D1_QTDEDEV) D1_QTDEDEV,								" + hEnter
		cQuery += "			SUM(SD1.D1_QUANT) D1_QUANT,									" + hEnter
		cQuery += "			SUM( CASE WHEN SD1.D1_QUANT = 1 THEN 0 ELSE SD1.D1_QUANT END ) D1_QUANT,		" + hEnter
		// SD1.D1_QUANT = 1 (referente a nota de complemento lancada como normal quantidade 1)
		//cQuery += "			SUM(SD1.D1_VUNIT) D1_VUNIT,									" + hEnter		
		cQuery += "			SUM(SD1.D1_TOTAL) D1_TOTAL,									" + hEnter
		cQuery += "			SUM(SD1.D1_VALDEV) D1_VALDEV,								" + hEnter
		cQuery += "			COUNT(*) QTDREG												" + hEnter
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
		cQuery += "WHERE    SF1.F1_FILIAL     = '" + xFilial("SF1") + "' 				" + hEnter
	    // filtro por linha
	    If mv_par09 == 1   
			If mv_par12 == 1
				cQuery += "AND ( SA2.A2_X_LINHA BETWEEN '" + mv_par03       + "' 		" + hEnter
				cQuery += "AND                 		    '" + mv_par04       + "' )		" + hEnter
			Else			
				cQuery += "AND ( SF1.F1_X_LINHA BETWEEN '" + mv_par03       + "' 		" + hEnter
				cQuery += "AND                 		    '" + mv_par04       + "' )		" + hEnter
			EndIf
	    // filtro por produtor
	    Else                  
			cQuery += "AND ( SF1.F1_FORNECE BETWEEN '" + mv_par05       + "' 			" + hEnter
			cQuery += "AND                		    '" + mv_par06       + "' )			" + hEnter
			cQuery += "AND ( SF1.F1_LOJA    BETWEEN '" + mv_par07       + "' 			" + hEnter
			cQuery += "AND                          '" + mv_par08       + "' )			" + hEnter
	    EndIf
		cQuery += "AND ( SF1.F1_EMISSAO     BETWEEN '" + DTOS(dSTART_DATE) + "' 		" + hEnter
		cQuery += "AND                          	'" + DTOS(dEND_DATE)   + "' )		" + hEnter
		cQuery += "AND ( SA2.A2_COD_MUN BETWEEN '" + mv_par16       + "' 				" + hEnter
		cQuery += "AND                          '" + mv_par17       + "' )				" + hEnter
		cQuery += "AND ( SA2.A2_EST     BETWEEN '" + mv_par18       + "' 				" + hEnter
		cQuery += "AND                          '" + mv_par19       + "' )				" + hEnter	
		cQuery += "AND ( SA2.A2_COND    BETWEEN '" + mv_par20       + "' 				" + hEnter
		cQuery += "AND      	            	'" + mv_par21       + "' )				" + hEnter						
		If mv_par27 == 2
			cQuery += "AND SA2.A2_X_TIPO		  = 'P'		                            " + hEnter		
		EndIf
		cQuery += "AND SD1.D1_COD	          = '" + cMV_ZLTPRD		+ "' 				" + hEnter
		cQuery += "AND 		SD1.D1_TIPO	    IN ('N','C')			 					" + hEnter
		cQuery += "AND SF1.F1_ESPECIE         = 'SPED'		                            " + hEnter
		cQuery += "AND SF1.D_E_L_E_T_        != '*' 									" + hEnter
		cQuery += "AND SD1.D_E_L_E_T_        != '*' 									" + hEnter
		cQuery += "AND SA2.D_E_L_E_T_        != '*' 									" + hEnter

		If mv_par12 == 1
			cQuery += "GROUP BY SA2.A2_X_LINHA, SF1.F1_FORNECE, 						" + hEnter		
		Else
			cQuery += "GROUP BY SF1.F1_X_LINHA, SF1.F1_FORNECE, 						" + hEnter
		EndIf
		cQuery += "			SF1.F1_LOJA, SA2.A2_NOME		 							" + hEnter

		If mv_par23 == 1
			If mv_par10 == 1
				If mv_par12 == 1
					cQuery += "ORDER BY SA2.A2_X_LINHA, SF1.F1_FORNECE, SF1.F1_LOJA		" + hEnter
				Else
					cQuery += "ORDER BY SF1.F1_X_LINHA, SF1.F1_FORNECE, SF1.F1_LOJA		" + hEnter				
				EndIf
			ElseIf mv_par10 == 2
				If mv_par12 == 1
					cQuery += "ORDER BY SA2.A2_X_LINHA, SA2.A2_NOME						" + hEnter
				Else
					cQuery += "ORDER BY SF1.F1_X_LINHA, SA2.A2_NOME						" + hEnter
				EndIf
			Else	 
				If mv_par12 == 1		
					cQuery += "ORDER BY SA2.A2_X_LINHA, D1_QUANT DESC					" + hEnter
				Else
					cQuery += "ORDER BY SF1.F1_X_LINHA, D1_QUANT DESC					" + hEnter	
				EndIf				
			EndIf		
		Else
			If mv_par10 == 1
				cQuery += "ORDER BY SF1.F1_FORNECE, SF1.F1_LOJA							" + hEnter
			ElseIf mv_par10 == 2
				cQuery += "ORDER BY SA2.A2_NOME											" + hEnter
			Else			
				cQuery += "ORDER BY D1_QUANT DESC										" + hEnter
			EndIf		
		EndIf
	                        	
	
                        	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasANT)
	
dbSelectArea(cAliasANT)
(cAliasANT)->(dbGoTop())
While (cAliasANT)->(!EOF())
	
	nVLR_PROD  := 0
	nPRC_LITRO := 0
	nPRC_FRETE := 0
	nQTD_TOTAL := 0
	
	fCalcProd( mv_par11, (cAliasANT)->PRODUT, (cAliasANT)->LOJPRD, (cAliasANT)->LINHA, nQTD_TOTAL, @nPRC_LITRO, @nVLR_PROD, @nPRC_FRETE )
	
	nQTD_TOTAL := ((cAliasANT)->D1_QUANT - (cAliasANT)->D1_QTDEDEV)
	//nPRC_LITRO := (cAliasANT)->D1_VUNIT / (cAliasANT)->QTDREG
	nPRC_LITRO := ((cAliasANT)->D1_TOTAL - (cAliasANT)->D1_VALDEV) / ((cAliasANT)->D1_QUANT - (cAliasANT)->D1_QTDEDEV)
	nVLR_PROD  := ((cAliasANT)->D1_TOTAL - (cAliasANT)->D1_VALDEV)
	

       	
       	
       		
       	dbSelectArea("SA2")
       	dbSetOrder(1)
       	dbSeek( xFilial("SA2") +  (cAliasANT)->PRODUT + (cAliasANT)->LOJPRD )

        dbSelectArea("ZL0")
        dbSetOrder(1)
        dbSeek( xFilial("ZL0") + SA2->A2_X_LINHA )

       	dbSelectArea("SA4")
       	dbSetOrder(1)
       	dbSeek( xFilial("SA4") +  ZL0->ZL0_TRANSP )
       	
       	If POSICIONE("SA2",1,xFilial("SA2")+SA4->A4_X_FORN+SA4->A4_X_LOJF,"A2_TIPO") == "F"
       		nUNT_FRETE := nPRC_FRETE
       		nPRC_FRETE := nPRC_FRETE * nQTD_TOTAL
       	Else                        
       		nUNT_FRETE := 0
       		nPRC_FRETE := 0         
       	EndIf
       	
       	dbSelectArea("SA2")
       	dbSetOrder(1)
       	dbSeek( xFilial("SA2") +  (cAliasANT)->PRODUT + (cAliasANT)->LOJPRD )

		cTipoRur  := SA2->A2_TIPORUR
		aPFunRur  := FunRur()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³aPFunRur[1]  == "F"³
		//³aPFunRur[2]  == "L"³
		//³aPFunRur[3]  == "J"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nPCFAT    := SA2->A2_X_PCDOC
		nVLR_CSOC := 0
		nUNT_CSOC := 0 
		nPosPer   := at(cTipoRur,"FLJ")
		nAlInss := POSICIONE("SED",1,XFILIAL("SED")+SA2->A2_NATUREZ,"ED_PERCINS")
		If nPosPer > 0 
			nAliquota := Val(aPFunRur[nPosPer]) + nAlsenar +nAlInss
			If SA2->A2_X_PCONT > 0
				nAliquota := SA2->A2_X_PCONT + nAlsenar
			EndIf			                        
			//-- Controle de serie de nota fiscal diferentes.
			If lATPERCFOR		
				nVLR_CSOC := ( (nVLR_PROD * nPCFAT / 100) * nAliquota) /100
				nUNT_CSOC := ( (nPRC_LITRO * nPCFAT / 100) * nAliquota) /100
			Else		
				nVLR_CSOC := (nVLR_PROD * nAliquota) /100
				nUNT_CSOC := (nPRC_LITRO * nAliquota) /100
			EndIf
		EndIf 
		    
        //VALOR LIQUIDO
        nPRC_LIQ := Round( nPRC_LITRO - (nUNT_CSOC + nUNT_FRETE), 4)

        aAdd( aDADOSTMP, { (cAliasANT)->PRODUT, (cAliasANT)->LOJPRD, (cAliasANT)->LINHA, nQTD_TOTAL, nPRC_LIQ, nPRC_FRETE, nVLR_CSOC, nVLR_PROD } )
        
		(cAliasANT)->(dbSkip())
	Enddo
	(cAliasANT)->(dbCloseArea())
	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas LTREL011.                                      º±±
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
aHelp12 := {}
aHelp13 := {}
aHelp14 := {}
aHelp15 := {}
aHelp16 := {}
aHelp17 := {}
aHelp18 := {}
aHelp19 := {}
aHelp20 := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Mês                ?","Mês                ?","Mês                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1101."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1102."})
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",".LTREL1103."})
	aAdd(aRegs,{cPerg,"04","Linha Até          ?","Linha Até          ?","Linha Até          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",".LTREL1104."})
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL1105."})
	aAdd(aRegs,{cPerg,"06","Produtor Até       ?","Produtor Até       ?","Produtor Até       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL1106."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1107."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor Até  ?","Loja Produtor Até  ?","Loja Produtor Até  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1108."})
	aAdd(aRegs,{cPerg,"09","Filtrar Por        ?","Filtrar Por        ?","Filtrar Por        ?","mv_ch9","N",01,0,1,"C","","mv_par09","Linha","Linha","Linha","","","Produtor","Produtor","Produtor","","","","","","","","","","","","","","","","", "","","",".LTREL1109."})
	aAdd(aRegs,{cPerg,"10","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_cha","N",01,0,1,"C","","mv_par10","Codigo Produtor","Codigo Produtor","Codigo Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","Quantidade","Quantidade","Quantidade","","","","","","","","","","","", "","","",".LTREL1110."})
	aAdd(aRegs,{cPerg,"11","Utilizar Excecão   ?","Utilizar Excecão   ?","Utilizar Excecão   ?","mv_chb","N",01,0,1,"C","","mv_par11","Produtor","Produtor","Produtor","","","Tabela","Tabela","Tabela","","","","","","","","","","","","","","","","", "","","",".LTREL1111."})
	aAdd(aRegs,{cPerg,"12","Utilizar Dados     ?","Utilizar Dados     ?","Utilizar Dados     ?","mv_chc","N",01,0,1,"C","","mv_par12","Movimentações","Movimentações","Movimentações","","","Notas Fiscais","Notas Fiscais","Notas Fiscais","","","","","","","","","","","","","","","","", "","","",".LTREL1112."})
	aAdd(aRegs,{cPerg,"13","Vencimento De      ?","Vencimento De      ?","Vencimento De      ?","mv_chd","D",01,0,1,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1113."})
	aAdd(aRegs,{cPerg,"14","Vencimento Ate     ?","Vencimento Ate     ?","Vencimento Ate     ?","mv_che","D",01,0,1,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1114."})
	aAdd(aRegs,{cPerg,"15","Imprime Resumo     ?","Imprime Resumo     ?","Imprime Resumo     ?","mv_chf","C",01,0,1,"C","","mv_par15","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","", "","","",".LTREL1115."})
	aAdd(aRegs,{cPerg,"16","Município De       ?","Município De       ?","Município De       ?","mv_chg","C",TAMSX3("A2_COD_MUN")[1],0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL1116."})
	aAdd(aRegs,{cPerg,"17","Município Até      ?","Município Até      ?","Município Até      ?","mv_chh","C",TAMSX3("A2_COD_MUN")[1],0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL1117."})
	aAdd(aRegs,{cPerg,"18","UF De              ?","UF De              ?","UF De              ?","mv_chi","C",TAMSX3("A2_EST")[1],0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1118."})
	aAdd(aRegs,{cPerg,"19","UF Até             ?","UF Até             ?","UF Até             ?","mv_chj","C",TAMSX3("A2_EST")[1],0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1119."})
	aAdd(aRegs,{cPerg,"20","Cond. Pagamento De ?","Cond. Pagamento De ?","Cond. Pagamento De ?","mv_chk","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL1120."})
	aAdd(aRegs,{cPerg,"21","Cond. Pagamento Até?","Cond. Pagamento Até?","Cond. Pagamento Até?","mv_chl","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL1120."})
	aAdd(aRegs,{cPerg,"22","Imp. Descontos Compensados?","Imp. Descontos Compensados?","Imp. Descontos Compensados?","mv_chm","C",01,0,1,"C","","mv_par22","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","", "","","",""})		
	aAdd(aRegs,{cPerg,"23","Quebrar Pág.P/Linha?","Quebrar Pág.P/Linha?","Quebrar Pág.P/Linha?","mv_chm","C",01,0,1,"C","","mv_par23","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"24","Origem Movimentos  ?","Origem Movimentos  ?","Origem Movimentos  ?","mv_chn","N",01,0,1,"C","","mv_par24","Conta corrente","Conta corrente","Conta corrente","","","Financeiro","Financeiro","Financeiro","","","Todos","Todos","Todos","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"25","Imp. Dados Mês/Ant.?","Imp. Dados Mês/Ant.?","Imp. Dados Mês/Ant.?","mv_cho","N",01,0,1,"C","","mv_par25","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"26","Imp. Crédito/Débito?","Imp. Crédito/Débito?","Imp. Crédito/Débito?","mv_chp","N",01,0,1,"C","","mv_par26","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","", "","","",""})
	¼aAdd(aRegs,{cPerg,"27","Cons. NFs Comp/Coop?","Cons. NFs Comp/Coop?","Cons. NFs Comp/Coop?","mv_chp","N",01,0,1,"C","","mv_par27","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"28","Comparador De      ?","Comparador De      ?","Comparador De      ?","mv_com","C",TAMSX3("ZL0_CODRES")[1],0,0,"G","","mv_par28","","","","","","","","","","","","","","","","","","","","","","","","", "US1","","",".LTREL1128."})
	aAdd(aRegs,{cPerg,"29","Comparador Até     ?","Comparador Até     ?","Comparador Até     ?","mv_com","C",TAMSX3("ZL0_CODRES")[1],0,0,"G","","mv_par29","","","","","","","","","","","","","","","","","","","","","","","","", "US1","","",".LTREL1129."})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe o mês ao qual deseje imprimir    " )       
	AADD( aHelp02, "Informe o ano ao qual deseje imprimir    " )       
	AADD( aHelp03, "Informe o número inicial da linha        " )       
	AADD( aHelp03, "a ser impressa.                          " )       
	AADD( aHelp04, "Informe o número final da linha          " )       
	AADD( aHelp04, "a ser impressa.                          " )       
	AADD( aHelp05, "Informe o código inicial do produtor     " )       
	AADD( aHelp05, "a ser impresso.                          " )       
	AADD( aHelp06, "Informe o código final do produtor       " )       
	AADD( aHelp06, "a ser impresso.                          " )       
	AADD( aHelp07, "Informe a loja inicial do produtor       " )       
	AADD( aHelp07, "a ser impresso.                          " )       
	AADD( aHelp08, "Informe a loja final do produtor         " )       
	AADD( aHelp08, "a ser impresso.                          " )       
	AADD( aHelp09, "Informe se deseje imprimir por intervalo " )       
	AADD( aHelp09, "de linhas ou produtores.                 " )       
	AADD( aHelp10, "Ordenar os registros pelo nome ou código " )       
	AADD( aHelp10, "dos produtores.                          " )
	AADD( aHelp11, "Utilizar tabela de exceção do cadastro do" )       
	AADD( aHelp11, "produtor ou das tabelas de exceções.     " )
	AADD( aHelp12, "Utilizar dados das movimentações diárias " )       
	AADD( aHelp12, "dos produtores ou das notas fiscais.     " )
	AADD( aHelp13, "Informe o Vencimento Inicial.            " )	
	AADD( aHelp13, "Válido somente para lançamentos da       " )	
	AADD( aHelp13, "Conta Corrente Produtor.                 " )	
	AADD( aHelp14, "Informe o Vencimento Final.              " )	
	AADD( aHelp14, "Válido somente para lançamentos da       " )	
	AADD( aHelp14, "Conta Corrente Produtor.                 " )	
	AADD( aHelp15, "Imprime resumo das linhas na             " )	
	AADD( aHelp15, "última página?                           " )	
	AADD( aHelp16, "Informe o código do município inicial    " )       
	AADD( aHelp16, "a ser impresso.                          " )       
	AADD( aHelp17, "Informe o código do município final      " )       
	AADD( aHelp17, "a ser impresso.                          " )
	AADD( aHelp18, "Informe a unidade federativa inicial     " )       
	AADD( aHelp18, "a ser impresso.                          " )       
	AADD( aHelp19, "Informe a unidade federativa final       " )       
	AADD( aHelp19, "a ser impresso.                          " )
	AADD( aHelp20, "Informe o intervalo de condicao de paga- " )	
	AADD( aHelp20, "mento para filtro de produtores.         " )
		 
	
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
	PutSX1Help("P.LTREL1101.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL1102.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL1103.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL1104.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL1105.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL1106.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL1107.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL1108.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL1109.",aHelp09,aHelp09,aHelp09)	
	PutSX1Help("P.LTREL1110.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL1111.",aHelp11,aHelp11,aHelp11)	
	PutSX1Help("P.LTREL1112.",aHelp12,aHelp12,aHelp12)	
	PutSX1Help("P.LTREL1113.",aHelp13,aHelp13,aHelp13)	
	PutSX1Help("P.LTREL1114.",aHelp14,aHelp14,aHelp14)	
	PutSX1Help("P.LTREL1115.",aHelp15,aHelp15,aHelp15)	
	PutSX1Help("P.LTREL1116.",aHelp16,aHelp16,aHelp16)	
	PutSX1Help("P.LTREL1117.",aHelp17,aHelp17,aHelp17)	
	PutSX1Help("P.LTREL1118.",aHelp18,aHelp18,aHelp18)	
	PutSX1Help("P.LTREL1119.",aHelp19,aHelp19,aHelp19)	
	PutSX1Help("P.LTREL1120.",aHelp20,aHelp20,aHelp20)	
		
Return Nil
