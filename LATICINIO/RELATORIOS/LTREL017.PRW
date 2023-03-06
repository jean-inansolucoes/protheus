#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL017 ºAutor  ³Rafael Parma         º Data ³  19/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão de relação de exames de rebanho por produtor.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*-----------------------*
User Function LTREL017()
*-----------------------*


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELAÇÃO DE EXAMES DO REBANHO"
Local cPict          := ""
Local titulo         := "RELAÇÃO DE EXAMES DO REBANHO"
Local nLin           := 80
Local Cabec1         := "PRODUTOR                                ENDEREÇO                                MUNICÍPIO                           UF      DAT.EXAME     VALIDADE    EX.TUBERC.    EX.BRUCELOSE"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00017"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL017"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL017"
Private aDADOSEXP    := {}
Public STRING_NULL   := ""


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamado rotina de verificação/criação do grupo de perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString := "ZLE"
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

	RptStatus({|| Report(@Cabec1,@Cabec2,Titulo,nLin) },Titulo)	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Report   ºAutor  ³Rafael Parma         º Data ³  25/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão de resultados de análises da vazão.     º±±
±±º          ³Entrega do transportador.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*---------------------------------------------------------------------*
Static Function Report(Cabec1, Cabec2, Titulo, nLin)                   
*---------------------------------------------------------------------*
Local cAliasTMP   := GetNextAlias()
Local cCODPRD     := STRING_NULL
Local cCODLIN     := STRING_NULL
Local hEnter	  := CHR(10) + CHR(13) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de registros....   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	 
	//-- Filtro dos dados
	cQuery := "SELECT 															" + hEnter
	cQuery += "     	ZLE.ZLE_PRODUT PRODUT,									" + hEnter
	cQuery += "     	ZLE.ZLE_LOJPRD LOJPRD,									" + hEnter
	cQuery += "         ZLE.ZLE_NOMPRD NOMPRD,									" + hEnter
	cQuery += "         ZLE.ZLE_LINHA  LINHA, 									" + hEnter
	cQuery += "         ZLE.ZLE_NOMLIN NOMLIN,									" + hEnter
	cQuery += "         ZLE.ZLE_DATEXA DATEXA,									" + hEnter
	cQuery += "         ZLE.ZLE_DATVAL DATVAL,									" + hEnter
	cQuery += "         ZLE.ZLE_NTUBER NTUBER,									" + hEnter
	cQuery += "         ZLE.ZLE_NBRUCE NBRUCE,									" + hEnter
	cQuery += "         ZLE.ZLE_QTDTUB QTDTUB,									" + hEnter
	cQuery += "         ZLE.ZLE_QTDBRU QTDBRU,									" + hEnter
	cQuery += "         'S'			   EXAME									" + hEnter	
	cQuery += "FROM " + RetSqlName("ZLE") + " ZLE								" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2							" + hEnter
	cQuery += "ON  		ZLE.ZLE_PRODUT = SA2.A2_COD								" + hEnter
	cQuery += "AND 		ZLE.ZLE_LOJPRD = SA2.A2_LOJA							" + hEnter
	cQuery += "WHERE    ZLE.ZLE_FILIAL = '" + xFilial("ZLE") + "' 				" + hEnter
	cQuery += "AND 		( ZLE.ZLE_DATEXA BETWEEN '" + dtos(mv_par01) + "' 		" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )		" + hEnter
	cQuery += "AND 		( ZLE.ZLE_DATVAL BETWEEN '" + dtos(mv_par03) + "' 		" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par04) + "' )		" + hEnter
	cQuery += "AND 		( ZLE.ZLE_LINHA  BETWEEN '" + mv_par07 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par08 + "' )			" + hEnter	
	cQuery += "AND 		( ZLE.ZLE_PRODUT BETWEEN '" + mv_par09 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par10 + "' )			" + hEnter	
	cQuery += "AND 		( ZLE.ZLE_LOJPRD BETWEEN '" + mv_par11 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par12 + "' )			" + hEnter	
	cQuery += "AND 		( SA2.A2_COD_MUN BETWEEN '" + mv_par13 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par14 + "' )			" + hEnter	
	cQuery += "AND 		( SA2.A2_EST     BETWEEN '" + mv_par15 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par16 + "' )			" + hEnter
	cQuery += "AND 		ZLE.ZLE_PRODUT || ZLE.ZLE_LOJPRD IN ( 		 			" + hEnter	
	cQuery += " 			SELECT ZL6.ZL6_PRODUT || ZL6.ZL6_LOJPRD 	 		" + hEnter
	cQuery += "				FROM " + RetSqlName("ZL6") + " ZL6					" + hEnter
	cQuery += "				INNER JOIN " + RetSqlName("ZL5") + " ZL5			" + hEnter
	cQuery += "  			ON ZL6.ZL6_COD = ZL5.ZL5_COD  						" + hEnter
	cQuery += "  			WHERE ZL5.ZL5_FILIAL = '"+xFilial("ZL5")+"'  		" + hEnter
	cQuery += "  			AND   ZL5.ZL5_DATA BETWEEN '"+dtos(mv_par05)+"' 	" + hEnter
	cQuery += "  			AND                        '"+dtos(mv_par06)+"' 	" + hEnter
	cQuery += "  			AND   ZL6.D_E_L_E_T_ != '*'                     	" + hEnter
	cQuery += "  			AND   ZL5.D_E_L_E_T_ != '*' )                   	" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_    != '*' 								" + hEnter
	cQuery += "AND 		ZLE.D_E_L_E_T_    != '*' 								" + hEnter
	cQuery += "UNION ALL														" + hEnter
	cQuery += "SELECT 															" + hEnter
	cQuery += "     	ZL6.ZL6_PRODUT PRODUT,									" + hEnter
	cQuery += "     	ZL6.ZL6_LOJPRD LOJPRD,									" + hEnter
	cQuery += "         ZL6.ZL6_NOMPRD NOMPRD,									" + hEnter
	cQuery += "         ZL5.ZL5_LINHA  LINHA, 									" + hEnter
	cQuery += "         ZL5.ZL5_NOMLIN NOMLIN,									" + hEnter
	cQuery += "         ''             DATEXA,									" + hEnter
	cQuery += "         ''             DATVAL,									" + hEnter
	cQuery += "         0              QTDTUB,									" + hEnter
	cQuery += "         0              QTDBRU,									" + hEnter
	cQuery += "         0              NTUBER,									" + hEnter
	cQuery += "         0              NBRUCE,									" + hEnter
	cQuery += "         'N'			   EXAME									" + hEnter	
	cQuery += "FROM " + RetSqlName("ZL6") + " ZL6								" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL5") + " ZL5							" + hEnter
	cQuery += "ON  		ZL5.ZL5_COD = ZL6.ZL6_COD								" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2							" + hEnter
	cQuery += "ON  		ZL6.ZL6_PRODUT = SA2.A2_COD								" + hEnter
	cQuery += "AND 		ZL6.ZL6_LOJPRD = SA2.A2_LOJA							" + hEnter
	cQuery += "WHERE    ZL5.ZL5_FILIAL = '" + xFilial("ZL5") + "' 				" + hEnter
	cQuery += "AND 		( ZL5.ZL5_LINHA  BETWEEN '" + mv_par07 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par08 + "' )			" + hEnter	
	cQuery += "AND 		( ZL6.ZL6_PRODUT BETWEEN '" + mv_par09 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par10 + "' )			" + hEnter	
	cQuery += "AND 		( ZL6.ZL6_LOJPRD BETWEEN '" + mv_par11 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par12 + "' )			" + hEnter	
	cQuery += "AND 		( SA2.A2_COD_MUN BETWEEN '" + mv_par13 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par14 + "' )			" + hEnter	
	cQuery += "AND 		( SA2.A2_EST     BETWEEN '" + mv_par15 + "' 			" + hEnter
	cQuery += "AND                 		         '" + mv_par16 + "' )			" + hEnter
	cQuery += "AND   	( ZL5.ZL5_DATA BETWEEN 	 '"+dtos(mv_par05)+"' 			" + hEnter
	cQuery += "AND                        		 '"+dtos(mv_par06)+"' )			" + hEnter
	cQuery += "AND 		ZL6.ZL6_PRODUT || ZL6.ZL6_LOJPRD NOT IN ( 		 		" + hEnter	
	cQuery += " 			SELECT ZLE.ZLE_PRODUT || ZLE.ZLE_LOJPRD 	 		" + hEnter
	cQuery += "				FROM " + RetSqlName("ZLE") + " ZLE					" + hEnter
	cQuery += "  			WHERE ZLE.ZLE_FILIAL = '"+xFilial("ZLE")+"'  		" + hEnter
	cQuery += "				AND ZLE.ZLE_DATEXA BETWEEN '"+dtos(mv_par01)+"' 	" + hEnter
	cQuery += "				AND                 	   '"+dtos(mv_par02)+"' 	" + hEnter
	cQuery += "				AND ZLE.ZLE_DATVAL BETWEEN '"+dtos(mv_par03)+"' 	" + hEnter
	cQuery += "				AND                 	   '"+dtos(mv_par04)+"' 	" + hEnter
	cQuery += "  			AND ZLE.D_E_L_E_T_ != '*' )                   		" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_    != '*' 								" + hEnter
	cQuery += "AND 		ZL5.D_E_L_E_T_    != '*' 								" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_    != '*' 								" + hEnter
	cQuery += "GROUP BY															" + hEnter
	cQuery += "     	ZL6.ZL6_PRODUT,       									" + hEnter
	cQuery += "     	ZL6.ZL6_LOJPRD,       									" + hEnter
	cQuery += "         ZL6.ZL6_NOMPRD,       									" + hEnter
	cQuery += "         ZL5.ZL5_LINHA,         									" + hEnter
	cQuery += "         ZL5.ZL5_NOMLIN       									" + hEnter
 	If mv_par20 == 1
		cQuery += "ORDER BY LINHA, PRODUT, LOJPRD 			 					" + hEnter
	ElseIf mv_par20 == 2
		cQuery += "ORDER BY LINHA, NOMPRD                   					" + hEnter
	Else
		cQuery += "ORDER BY DATVAL                             					" + hEnter	
	EndIf
	

	memowrite("LTREL017_1.SQL",cQuery)
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
		
		If mv_par17 == 1 .and. (cAliasTMP)->EXAME != "S"
			(cAliasTMP)->(dbSkip())
			Loop
		ElseIf mv_par17 == 2 .and. (cAliasTMP)->EXAME != "N"
			(cAliasTMP)->(dbSkip())
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                                                                
		Cabec2 := "LINHA: "+ALLTRIM((cAliasTMP)->LINHA)+"-"+ALLTRIM((cAliasTMP)->NOMLIN)
		If mv_par19 == 1 .and. cCODLIN != (cAliasTMP)->LINHA			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		ElseIf mv_par19 == 2 .and. cCODPRD != (cAliasTMP)->PRODUT+(cAliasTMP)->LOJPRD
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf				      
				
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		
		cCODLIN := (cAliasTMP)->LINHA
		cCODPRD := (cAliasTMP)->PRODUT+(cAliasTMP)->LOJPRD
		

		/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		    PRODUTOR                                ENDEREÇO                                MUNICÍPIO                           UF      DAT.EXAME     VALIDADE    EX.TUBERC.    EX.BRUCELOSE   QTD.TUBERC.    QTD.BRUCELOSE
		*/  

		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek( xFilial("SA2") + (cAliasTMP)->PRODUT + (cAliasTMP)->LOJPRD )
		
		@nLin,000 PSAY SUBSTR(ALLTRIM((cAliasTMP)->PRODUT)+"/"+ALLTRIM((cAliasTMP)->LOJPRD)+"-"+ALLTRIM((cAliasTMP)->NOMPRD),1,30)
		@nLin,040 PSAY SubSTR(SA2->A2_END,1,40)
		@nLin,080 PSAY SubSTR(Posicione("CC2",1,xFilial("CC2")+SA2->A2_EST+SA2->A2_COD_MUN,"CC2_MUN"),1,34)
		@nLin,116 PSAY SA2->A2_EST
		@nLin,124 PSAY DTOC(STOD((cAliasTMP)->DATEXA))
		@nLin,138 PSAY DTOC(STOD((cAliasTMP)->DATVAL))
		@nLin,150 PSAY TRANSFORM((cAliasTMP)->NTUBER, "@E 999999")
		@nLin,164 PSAY TRANSFORM((cAliasTMP)->NBRUCE, "@E 999999")
		nLin += 1
		
		aAdd (aDADOSEXP, { 	ALLTRIM((cAliasTMP)->LINHA)+"-"+ALLTRIM((cAliasTMP)->NOMLIN), ;
							ALLTRIM((cAliasTMP)->PRODUT)+"/"+ALLTRIM((cAliasTMP)->LOJPRD)+"-"+ALLTRIM((cAliasTMP)->NOMPRD), ;
							SA2->A2_END, ;
							Posicione("CC2",1,xFilial("CC2")+SA2->A2_EST+SA2->A2_COD_MUN,"CC2_MUN"), ;
							SA2->A2_EST, ;
							DTOC(STOD((cAliasTMP)->DATEXA)), ; 
							DTOC(STOD((cAliasTMP)->DATVAL)), ;
							TRANSFORM((cAliasTMP)->NTUBER, "@E 999999"), ;
							TRANSFORM((cAliasTMP)->NBRUCE, "@E 999999") } )

		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If mv_par18 == 1

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

	Else
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exportação de dados p/ excel.                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aDADOSEXP) > 0
					
			fExpXLS( aDADOSEXP )
		Else
		
			MsgInfo("Não existem dados a serem exportados! Verifique os parâmetros!")
		
		EndIf
			
	EndIf

	
Return
     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fExpXLS  ºAutor  ³Rafael Parma         º Data ³  10/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exportação dos dados p/ planilha excel.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------------------*
Static Function fExpXLS( aDADOSEXP )
*--------------------------------------*
Local cArquivo := GetNextAlias()
Local cPath	   := AllTrim(GetTempPath())

Private cArqTxt := cPath+cArquivo+".txt"
Private nHdl    := fCreate(cArqTxt)

	If nHdl == -1
	    MsgAlert("O arquivo "+cArqTxt+" não pode ser executado! Verifique os parâmetros.","Atenção!")
	    Return
	Endif	
	
	If ! ApOleClient( 'MsExcel' ) 
	 	MsgStop("MsExcel não instalado!")
	 	Return
	EndIf

	cLin := "LINHA" 		 + ";"
	cLin += "PRODUTOR" 		 + ";"
	cLin += "ENDEREÇO" 		 + ";"
	cLin += "MUNICÍPIO"		 + ";"
	cLin += "ESTADO" 		 + ";"
	cLin += "DAT.EXAME" 	 + ";"
	cLin += "VALIDADE" 	 	 + ";"
	cLin += "TUBERCULOSE" 	 + ";"
	cLin += "BRUCELOSE"      + CHR(13)

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravação do arquivo. Continua?","Atenção!")
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
		cLin += aDADOSEXP[nI,07] + ";"
		cLin += aDADOSEXP[nI,08] + ";"
		cLin += aDADOSEXP[nI,09] + CHR(13)


	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na gravação do arquivo. Continua?","Atenção!")
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  19/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------*
Static Function AjustaSX1()                                            
*---------------------------------------------------------------------*
aRegs   := {}; aHelp01 := {}; aHelp02 := {}; aHelp03 := {}; aHelp04 := {}                                                  
aHelp05 := {}; aHelp06 := {}; aHelp07 := {}; aHelp08 := {}; aHelp09 := {} 
aHelp10 := {}; aHelp11 := {}; aHelp12 := {}; aHelp13 := {}; aHelp14 := {}
aHelp15 := {}; aHelp16 := {}; aHelp17 := {}; aHelp18 := {}; aHelp19 := {} 
aHelp20 := {}                                               

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Data Exame De      ?","Data Exame De      ?","Data Exame De      ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01701."})
	aAdd(aRegs,{cPerg,"02","Data Exame Até     ?","Data Exame Até     ?","Data Exame Até     ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01702."})	
	aAdd(aRegs,{cPerg,"03","Data Validade De   ?","Data Validade De   ?","Data Validade De   ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01703."})
	aAdd(aRegs,{cPerg,"04","Data Validade Até  ?","Data Validade Até  ?","Data Validade Até  ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01704."})	
	aAdd(aRegs,{cPerg,"05","Data Movimento De  ?","Data Movimento De  ?","Data Movimento De  ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01705."})
	aAdd(aRegs,{cPerg,"06","Data Movimento Até ?","Data Movimento Até ?","Data Movimento Até ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01706."})	
	aAdd(aRegs,{cPerg,"07","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01707."})
	aAdd(aRegs,{cPerg,"08","Linha Até          ?","Linha Até          ?","Linha Até          ?","mv_ch6","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01708."})
	aAdd(aRegs,{cPerg,"09","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch7","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01709."})
	aAdd(aRegs,{cPerg,"10","Produtor Até       ?","Produtor Até       ?","Produtor Até       ?","mv_ch8","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01710."})
	aAdd(aRegs,{cPerg,"11","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch9","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01711."})
	aAdd(aRegs,{cPerg,"12","Loja Produtor Até  ?","Loja Produtor Até  ?","Loja Produtor Até  ?","mv_cha","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01712."})
	aAdd(aRegs,{cPerg,"13","Município De       ?","Município De       ?","Município De       ?","mv_chb","C",TAMSX3("A1_COD_MUN")[1],0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL01713."})
	aAdd(aRegs,{cPerg,"14","Município Até      ?","Município Até      ?","Município Até      ?","mv_chc","C",TAMSX3("A1_COD_MUN")[1],0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL01714."})
	aAdd(aRegs,{cPerg,"15","Estado De          ?","Estado De          ?","Estado De          ?","mv_chd","C",TAMSX3("A1_EST")[1],0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","", "12","","",".LTREL01715."})
	aAdd(aRegs,{cPerg,"16","Estado Até         ?","Estado Até         ?","Estado Até         ?","mv_che","C",TAMSX3("A1_EST")[1],0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","", "12","","",".LTREL01716."})
	aAdd(aRegs,{cPerg,"17","Filtrar Produtores ?","Filtrar Produtores ?","Filtrar Produtores ?","mv_chf","N",01,0,1,"C","","mv_par17","Entregaram exame","Entregaram exame","Entregaram exame","","","Não entregaram","Não entregaram","Não entregaram","","","Todos produtores","Todos produtores","Todos produtores","","","","","","","","","","","","","","","","", "","","",".LTREL01717."})
	aAdd(aRegs,{cPerg,"18","Exportar p/Excel   ?","Exportar p/Excel   ?","Exportar p/Excel   ?","mv_chg","N",01,0,1,"C","","mv_par18","Não","Não","Não","","","Sim","Sim","Sim","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01718."})
	aAdd(aRegs,{cPerg,"19","Saltar Página Por  ?","Saltar Página Por  ?","Saltar Página Por  ?","mv_chh","N",01,0,1,"C","","mv_par19","Linha","Linha","Linha","","","Produtor","Produtor","Produtor","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01719."})
	aAdd(aRegs,{cPerg,"20","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_chi","N",01,0,1,"C","","mv_par20","Código Produtor","Código Produtor","Código Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","Data Validade","Data Validade","Data Validade","","","","","","","","","","","","","","","","", "","","",".LTREL01720."})	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe a data inicial de realizacao     " )       
	AADD( aHelp01, "do exame.                                " )       
	AADD( aHelp02, "Informe a data final de realizacao       " )       
	AADD( aHelp02, "do exame.                                " )
	AADD( aHelp03, "Informe a data inicial de validade       " )       
	AADD( aHelp03, "do exame.                                " )       
	AADD( aHelp04, "Informe a data final de validade         " )       
	AADD( aHelp04, "do exame.                                " )
	AADD( aHelp05, "Informe a data inicial de movimento de   " )       
	AADD( aHelp05, "entrada de leite do produtor.            " )       
	AADD( aHelp06, "Informe a data final   de movimento de   " )       
	AADD( aHelp06, "entrada de leite do produtor.            " )
	AADD( aHelp07, "Informe o código inicial da linha de     " )       
	AADD( aHelp07, "coleta.                                  " )       
	AADD( aHelp08, "Informe o código final da linha de       " )       
	AADD( aHelp08, "coleta.                                  " )       
	AADD( aHelp09, "Informe o código inicial do produtor     " )       
	AADD( aHelp09, "a ser impresso.                          " )       
	AADD( aHelp10, "Informe o código final do produtor       " )       
	AADD( aHelp10, "a ser impresso.                          " )       
	AADD( aHelp11, "Informe o código inicial da loja do      " )       
	AADD( aHelp11, "produtor a ser impresso.                 " )       
	AADD( aHelp12, "Informe o código final da loja do        " )       
	AADD( aHelp12, "produtor a ser impresso.                 " ) 	
	AADD( aHelp13, "Informe o código inicial do municipio do " )       
	AADD( aHelp13, "produtor a ser impresso.                 " )       
	AADD( aHelp14, "Informe o código final do municipio do   " )       
	AADD( aHelp14, "produtor a ser impresso.                 " ) 
	AADD( aHelp15, "Informe o código inicial do estado do    " )       
	AADD( aHelp15, "produtor a ser impresso.                 " )       
	AADD( aHelp16, "Informe o código final do estado do      " )       
	AADD( aHelp16, "produtor a ser impresso.                 " ) 	      
	AADD( aHelp17, "Informe se deseja filtrar os produtores  " )       
	AADD( aHelp17, "que entregaram os exames ou não.         " )  
	AADD( aHelp18, "Informe se deseja exportar os dados para " )       
	AADD( aHelp18, "excel.                                   " )
	AADD( aHelp19, "Informe se deseje saltar pagina por      " )       
	AADD( aHelp19, "produtor ou linha de coleta.             " )  
	AADD( aHelp20, "Ordenar registros impressos pelo codigo, " )       
	AADD( aHelp20, "nome do produtor ou data validade.       " )
		
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
	PutSX1Help("P.LTREL01701.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL01702.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL01703.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL01704.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL01705.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL01706.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL01707.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL01708.",aHelp08,aHelp08,aHelp08)	
	PutSX1Help("P.LTREL01709.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL01710.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL01711.",aHelp11,aHelp11,aHelp11)
	PutSX1Help("P.LTREL01712.",aHelp12,aHelp12,aHelp12)			
	PutSX1Help("P.LTREL01713.",aHelp13,aHelp13,aHelp13)
	PutSX1Help("P.LTREL01714.",aHelp14,aHelp14,aHelp14)					
	PutSX1Help("P.LTREL01715.",aHelp15,aHelp15,aHelp15)
	PutSX1Help("P.LTREL01716.",aHelp16,aHelp16,aHelp16)
	PutSX1Help("P.LTREL01717.",aHelp17,aHelp17,aHelp17)
	PutSX1Help("P.LTREL01718.",aHelp18,aHelp18,aHelp18)
	PutSX1Help("P.LTREL01719.",aHelp19,aHelp19,aHelp19)
	PutSX1Help("P.LTREL01720.",aHelp20,aHelp20,aHelp20)

Return Nil