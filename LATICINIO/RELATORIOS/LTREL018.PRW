#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL018 ºAutor  ³Rafael Parma         º Data ³  19/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão de rastreabilidade de antibióticos na vazão.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*-----------------------*
User Function LTREL018()
*-----------------------*


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RASTREABILIDADE DE ANTIBIÓTICO - VAZÃO"
Local cPict          := ""
Local titulo         := "RASTREABILIDADE DE ANTIBIÓTICO - VAZÃO"
Local nLin           := 80
Local Cabec1         := "PRODUTOR                      DAT.COLETA DAT.ANALISE AMOSTRA  TIPO ANAL. ANTIBIOTICO  NOME COLETOR    NOME ANALISTA      QTDE.COND. " 
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00018"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "LTREL018"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL018"
Public STRING_NULL   := ""


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamado rotina de verificação/criação do grupo de perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString := "ZLD"
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
Local nTOTAL      := 0
Local hEnter	  := CHR(10) + CHR(13) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de registros....   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	 
	//-- Filtro dos dados
	cQuery := " SELECT 														" + hEnter
	cQuery += "     	ZL7.ZL7_LINHA,										" + hEnter
	cQuery += "     	ZL7.ZL7_NOMLIN,										" + hEnter	
	cQuery += "     	ZLD.ZLD_CODMOV,										" + hEnter
	cQuery += "     	ZLD.ZLD_DATCOL,										" + hEnter
	cQuery += "         ZLD.ZLD_DATANA,										" + hEnter
	cQuery += "         ZLD.ZLD_PRODUT,										" + hEnter
	cQuery += "         ZLD.ZLD_LOJPRD,										" + hEnter
	cQuery += "         ZLD.ZLD_NOMPRD,										" + hEnter
	cQuery += "         ZLD.ZLD_NUMERO,										" + hEnter
	cQuery += "         ZLD.ZLD_ANTIBI,										" + hEnter
	cQuery += "         ZLD.ZLD_TAANT,										" + hEnter
	cQuery += "         ZLD.ZLD_COLETO,										" + hEnter
	cQuery += "         ZLD.ZLD_ANALIS,										" + hEnter	
	cQuery += "         ZLD.ZLD_QTDCON										" + hEnter
	cQuery += " FROM " + RetSqlName("ZLD") + " ZLD							" + hEnter
	cQuery += " INNER JOIN " + RetSqlName("ZL7") + " ZL7					" + hEnter
	cQuery += " ON		ZLD.ZLD_FILIAL = ZL7.ZL7_FILIAL						" + hEnter
	cQuery += " AND		ZLD.ZLD_CODMOV = ZL7.ZL7_COD						" + hEnter
	cQuery += "WHERE    ZLD.ZLD_FILIAL = '" + xFilial("ZLD") + "' 			" + hEnter
	cQuery += "AND 		( ZLD.ZLD_DATCOL BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		( ZLD.ZLD_DATANA BETWEEN '" + dtos(mv_par03) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par04) + "' )	" + hEnter
	cQuery += "AND 		( ZL7.ZL7_LINHA  BETWEEN '" + mv_par05 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par06 + "' )		" + hEnter	
	cQuery += "AND 		( ZLD.ZLD_PRODUT BETWEEN '" + mv_par07 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par08 + "' )		" + hEnter	
	cQuery += "AND 		( ZLD.ZLD_LOJPRD BETWEEN '" + mv_par09 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par10 + "' )		" + hEnter	
	cQuery += "AND 		( ZL7.ZL7_TRANSP BETWEEN '" + mv_par11 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par12 + "' )		" + hEnter	
	If mv_par15 == 1
		cQuery += "AND	ZLD.ZLD_ANTIBI     = 'P'					 		" + hEnter
	ElseIf mv_par15 == 2
		cQuery += "AND	ZLD.ZLD_ANTIBI    != 'P'					 		" + hEnter
	EndIf
	cQuery += "AND 		ZLD.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL7.D_E_L_E_T_    != '*' 							" + hEnter
 	If mv_par14 == 1
		cQuery += "ORDER BY ZL7.ZL7_LINHA,  ZLD.ZLD_PRODUT, 				" + hEnter
		cQuery += "			ZLD.ZLD_LOJPRD, ZLD.ZLD_DATANA					" + hEnter
	Else
		cQuery += "ORDER BY ZL7.ZL7_LINHA,  ZLD.ZLD_NOMPRD,	 				" + hEnter
		cQuery += "			ZLD.ZLD_DATANA									" + hEnter
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
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                                                                
		Cabec2 := "LINHA: "+ALLTRIM((cAliasTMP)->ZL7_LINHA)+"-"+ALLTRIM((cAliasTMP)->ZL7_NOMLIN)
		If mv_par13 == 1 .and. cCODLIN != (cAliasTMP)->ZL7_LINHA			
			If cCODLIN != STRING_NULL
				@nLin,000 PSAY "TOTAL DE ANALISES: "+cValToChar(nTOTAL)
			EndIf
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nTOTAL := 0
			nLin := 9
		ElseIf mv_par13 == 2 .and. cCODPRD != (cAliasTMP)->ZLD_PRODUT+(cAliasTMP)->ZLD_LOJPRD
			If cCODPRD != STRING_NULL
				@nLin,000 PSAY "TOTAL DE ANALISES: "+cValToChar(nTOTAL)
			EndIf
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nTOTAL := 0
			nLin := 9
		EndIf
						
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		
		cCODLIN := (cAliasTMP)->ZL7_LINHA
		cCODPRD := (cAliasTMP)->ZLD_PRODUT+(cAliasTMP)->ZLD_LOJPRD
		

		/*
                      1         2         3         4         5         6         7         8         9        10        11        12        13
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            -----------------------------------------------------------------------------------------------------------------------------------
		    PRODUTOR                      DAT.COLETA DAT.ANALISE AMOSTRA  TIPO ANAL. ANTIBIOTICO  NOME COLETOR    NOME ANALISTA      QTDE.COND. 
		*/  
		
		@nLin,000 PSAY SUBSTR(ALLTRIM((cAliasTMP)->ZLD_PRODUT)+"/"+ALLTRIM((cAliasTMP)->ZLD_LOJPRD)+"-"+ALLTRIM((cAliasTMP)->ZLD_NOMPRD),1,28)
		@nLin,030 PSAY DTOC(STOD((cAliasTMP)->ZLD_DATCOL))
		@nLin,041 PSAY DTOC(STOD((cAliasTMP)->ZLD_DATANA))
		@nLin,053 PSAY SUBSTR((cAliasTMP)->ZLD_NUMERO,1,10)
		@nLin,062 PSAY IIF((cAliasTMP)->ZLD_TAANT=="B","BETALAC.",IIF((cAliasTMP)->ZLD_TAANT=="T","TETRAC.","AMBOS"))
		@nLin,073 PSAY IIF((cAliasTMP)->ZLD_ANTIBI=="P","POSITIVO","NEGATIVO")
		@nLin,086 PSAY SUBSTR((cAliasTMP)->ZLD_COLETO,1,14)
		@nLin,102 PSAY SUBSTR((cAliasTMP)->ZLD_ANALIS,1,14)
		If (cAliasTMP)->ZLD_ANTIBI=="P"
			nQTDCON := (cAliasTMP)->ZLD_QTDCON
		Else
			nQTDCON := 0
		EndIf		
		@nLin,121 PSAY TRANSFORM(nQTDCON,"@E 999,999.99")		
		
		nLin += 1
		nTOTAL += 1

		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())                                   
	
	If nTOTAL != 0 
		@nLin,000 PSAY "TOTAL DE ANALISES: "+cValToChar(nTOTAL)
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
aRegs   := {} ; aHelp01 := {} ; aHelp02 := {} ; aHelp03 := {}  
aHelp04 := {} ; aHelp05 := {} ; aHelp06 := {} ; aHelp07 := {} 
aHelp08 := {} ; aHelp09 := {} ; aHelp10 := {} ; aHelp11 := {} 
aHelp12 := {} ; aHelp13 := {} ; aHelp14 := {} ; aHelp15 := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Data Coleta De     ?","Data Coleta De     ?","Data Coleta De     ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01801."})
	aAdd(aRegs,{cPerg,"02","Data Coleta Até    ?","Data Coleta Até    ?","Data Coleta Até    ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01802."})	
	aAdd(aRegs,{cPerg,"03","Data Análise De    ?","Data Análise De    ?","Data Análise De    ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01803."})
	aAdd(aRegs,{cPerg,"04","Data Análise Até   ?","Data Análise Até   ?","Data Análise Até   ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01804."})	
	aAdd(aRegs,{cPerg,"05","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01805."})
	aAdd(aRegs,{cPerg,"06","Linha Até          ?","Linha Até          ?","Linha Até          ?","mv_ch6","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01806."})
	aAdd(aRegs,{cPerg,"07","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch7","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01807."})
	aAdd(aRegs,{cPerg,"08","Produtor Até       ?","Produtor Até       ?","Produtor Até       ?","mv_ch8","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01808."})
	aAdd(aRegs,{cPerg,"09","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch9","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01809."})
	aAdd(aRegs,{cPerg,"10","Loja Produtor Até  ?","Loja Produtor Até  ?","Loja Produtor Até  ?","mv_cha","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01810."})
	aAdd(aRegs,{cPerg,"11","Transportador De   ?","Transportador De   ?","Transportador De   ?","mv_chb","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01811."})
	aAdd(aRegs,{cPerg,"12","Transportador Até  ?","Transportador Até  ?","Transportador Até  ?","mv_chc","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01812."})
	aAdd(aRegs,{cPerg,"13","Saltar Página Por  ?","Saltar Página Por  ?","Saltar Página Por  ?","mv_chd","N",01,0,1,"C","","mv_par13","Linha","Linha","Linha","","","Produtor","Produtor","Produtor","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01813."})
	aAdd(aRegs,{cPerg,"14","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_che","N",01,0,1,"C","","mv_par14","Código Produtor","Código Produtor","Código Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01814."})	
	aAdd(aRegs,{cPerg,"15","Imprimir Resultados?","Imprimir Resultados?","Imprimir Resultados?","mv_chf","N",01,0,1,"C","","mv_par15","Positivos","Positivos","Positivos","","","Negativos","Negativos","Negativos","","","Todos","Todos","Todos","","","","","","","","","","","","","","","","", "","","",".LTREL01815."})	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe a data inicial de coleta para     " )       
	AADD( aHelp01, "análise.                                  " )       
	AADD( aHelp02, "Informe a data final de coleta para       " )       
	AADD( aHelp02, "análise.                                  " )
	AADD( aHelp03, "Informe a data inicial de análise.        " )       
	AADD( aHelp04, "Informe a data final de análise.          " )       
	AADD( aHelp05, "Informe o código inicial da linha de      " )       
	AADD( aHelp05, "coleta.                                   " )       
	AADD( aHelp06, "Informe o código final da linha de        " )       
	AADD( aHelp06, "coleta.                                   " )       
	AADD( aHelp07, "Informe o código inicial do produtor      " )       
	AADD( aHelp07, "a ser impresso.                           " )       
	AADD( aHelp08, "Informe o código final do produtor        " )       
	AADD( aHelp08, "a ser impresso.                           " )       
	AADD( aHelp09, "Informe o código inicial da loja do       " )       
	AADD( aHelp09, "produtor a ser impresso.                  " )       
	AADD( aHelp10, "Informe o código final da loja do         " )       
	AADD( aHelp10, "produtor a ser impresso.                  " )       
	AADD( aHelp11, "Informe o código inicial do transportador." )       
	AADD( aHelp12, "Informe o código final do transportador.  " )       
	AADD( aHelp13, "Informe se deseje saltar pagina por       " )       
	AADD( aHelp13, "produtor ou linha de coleta.              " )  
	AADD( aHelp14, "Ordenar registros impressos pelo codigo   " )       
	AADD( aHelp14, "ou nome do produtor.                      " )
	AADD( aHelp15, "Informe o tipo de resultado para impressão" )       
		
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
	PutSX1Help("P.LTREL01801.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL01802.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL01803.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL01804.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL01805.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL01806.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL01807.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL01808.",aHelp08,aHelp08,aHelp08)	
	PutSX1Help("P.LTREL01809.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL01810.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL01811.",aHelp11,aHelp11,aHelp11)
	PutSX1Help("P.LTREL01812.",aHelp12,aHelp12,aHelp12)			
	PutSX1Help("P.LTREL01813.",aHelp13,aHelp13,aHelp13)
	PutSX1Help("P.LTREL01814.",aHelp14,aHelp14,aHelp14)	
	PutSX1Help("P.LTREL01815.",aHelp15,aHelp15,aHelp15)	
						
Return Nil