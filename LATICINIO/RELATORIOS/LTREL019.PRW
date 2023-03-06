#INCLUDE "TOPCONN.CH"	
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL019 บAutor  ณRafael Parma         บ Data ณ  05/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de rela็ใo de anแlises fํsico-quimicas sobre      บฑฑ
ฑฑบ          ณprodutos.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL019()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "ANมLISE FอSICO-QUอMICA DE PRODUTO"
Local cPict          := ""
Local titulo         := "ANมLISE FอSICO-QUอMICA DE PRODUTO"
Local nLin           := 80  
Local Cabec1         := "PRODUTO                                           DATA FAB.   DATA MP     NฺM.LOTE    (%)GORD. (%)UMID. (%)E.SECO (%)G.E.SECO (%)CLOR.SOD.  FATIAMENTO  (%)G.CR.SORO  (%)G.CR.LEITE NฺM.EMB.   ACID.TOT.  INSOL.ETEROETILICO"
Local Cabec2         := "SEQ.SILO LEITE  NฺM.SILO LEITE  SEQ.SILO SORO  NฺM.SILO SORO  CRIOSCOPIA  E.S.D.   DENSIDADE   PROTEINA  PH LEITE  PH SORO   FOSFATASE  HORA ENT.  RESPONSAVEL                                                              "
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00019"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL019"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL019"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZLF"
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

	RptStatus({|| Report(@Cabec1,@Cabec2,Titulo,nLin) },Titulo)	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReport   บAutor  ณRafael Parma         บ Data ณ  25/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de resultados de anแlises da vazใo.     บฑฑ
ฑฑบ          ณEntrega do transportador.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*---------------------------------------------------------------------*
Static Function Report(Cabec1, Cabec2, Titulo, nLin)                   
*---------------------------------------------------------------------*
Local cAliasTMP := GetNextAlias()
Local cDATFAB   := STRING_NULL
Local cCODPRD   := STRING_NULL
Local nTOTCSG   := 0
Local nTOTCLG   := 0
Local nREGCSG   := 0
Local nREGCLG   := 0

Local hEnter	:= CHR(10) + CHR(13) 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de registros....   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	 
	//-- Filtro dos dados
	cQuery := " SELECT 														" + hEnter
	cQuery += "     	ZLF.ZLF_PRODUT,										" + hEnter
	cQuery += "     	ZLF.ZLF_DESPRD,										" + hEnter	
	cQuery += "     	ZLF.ZLF_DATFAB,										" + hEnter
	cQuery += "     	ZLF.ZLF_LOTE,										" + hEnter
	cQuery += "         ZLF.ZLF_DATMAT,										" + hEnter
	cQuery += "         ZLF.ZLF_GORD,										" + hEnter
	cQuery += "         ZLF.ZLF_UMIDAD,										" + hEnter
	cQuery += "         ZLF.ZLF_ESP,										" + hEnter
	cQuery += "         ZLF.ZLF_ESG,										" + hEnter
	cQuery += "         ZLF.ZLF_CLRSOD,										" + hEnter
	cQuery += "         ZLF.ZLF_CSOROG,										" + hEnter	
	cQuery += "         ZLF.ZLF_CLEITG,										" + hEnter	
	cQuery += "         ZLF.ZLF_NUMEMB,										" + hEnter	
	cQuery += "         ZLF.ZLF_ACDTOT,										" + hEnter	
	cQuery += "         ZLF.ZLF_INSETE,										" + hEnter		 
	cQuery += "         ZLF.ZLF_FATIAM,										" + hEnter	
	cQuery += "         ZLF.ZLF_TANQL,										" + hEnter	
	cQuery += "         ZLF.ZLF_SEQL,										" + hEnter	
	cQuery += "         ZLF.ZLF_TANQS,										" + hEnter	
	cQuery += "         ZLF.ZLF_SEQS,										" + hEnter	
	cQuery += "         ZLF.ZLF_CRIO,										" + hEnter	
	cQuery += "         ZLF.ZLF_ESD,										" + hEnter	
	cQuery += "         ZLF.ZLF_DENS,										" + hEnter	
	cQuery += "         ZLF.ZLF_PROT,										" + hEnter	
	cQuery += "         ZLF.ZLF_PHL,										" + hEnter	
	cQuery += "         ZLF.ZLF_PHS,										" + hEnter	
	cQuery += "         ZLF.ZLF_FOSF,										" + hEnter	
	cQuery += "         ZLF.ZLF_HORA,										" + hEnter	
	cQuery += "         ZLF.ZLF_RESP										" + hEnter		
	cQuery += "FROM " + RetSqlName("ZLF") + " ZLF							" + hEnter
	cQuery += "WHERE    ZLF.ZLF_FILIAL = '" + xFilial("ZLF") + "' 			" + hEnter
	cQuery += "AND 		( ZLF.ZLF_DATFAB BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		( ZLF.ZLF_DATMAT BETWEEN '" + dtos(mv_par03) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par04) + "' )	" + hEnter
	cQuery += "AND 		( ZLF.ZLF_PRODUT BETWEEN '" + mv_par05 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par06 + "' )		" + hEnter	
	cQuery += "AND 		ZLF.D_E_L_E_T_    != '*' 							" + hEnter
 	If mv_par08 == 1
		cQuery += "ORDER BY ZLF.ZLF_DATFAB,  					 			" + hEnter
		If mv_par09 == 1
			cQuery += "		ZLF.ZLF_PRODUT  					 			" + hEnter
		Else
			cQuery += "		ZLF.ZLF_DESPRD  					 			" + hEnter
		EndIf
	Else
		If mv_par09 == 1
			cQuery += "ORDER BY ZLF.ZLF_PRODUT  					 		" + hEnter
		Else
			cQuery += "ORDER BY ZLF.ZLF_DESPRD  					 		" + hEnter
		EndIf
	EndIf
	

	memowrite("LTREL019.SQL",cQuery)
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
		If mv_par07 == 1 .and. cDATFAB 	!= (cAliasTMP)->ZLF_DATFAB		
			If cDATFAB != STRING_NULL .AND. mv_par07 == 1 
				nLin += 2
				@nLin,00 PSAY "MEDIAS DE CREME: "
				@nLin,153 PSAY TRANSFORM(nTOTCSG/nREGCSG ,"@E 999.99")
				@nLin,166 PSAY TRANSFORM(nTOTCLG/nREGCLG ,"@E 999.99")
				nTOTCSG := 0
				nTOTCLG := 0
				nREGCSG := 0
				nREGCLG := 0				
			EndIf			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		ElseIf mv_par07 == 2 .and. cCODPRD != (cAliasTMP)->ZLF_PRODUT
			If cCODPRD != STRING_NULL .AND. mv_par07 == 1
				nLin += 2
				@nLin,00 PSAY "MEDIAS DE CREME: "
				@nLin,153 PSAY TRANSFORM(nTOTCSG/nREGCSG ,"@E 999.99")
				@nLin,166 PSAY TRANSFORM(nTOTCLG/nREGCLG ,"@E 999.99")
				nTOTCSG := 0
				nTOTCLG := 0
				nREGCSG := 0
				nREGCLG := 0			
			EndIf		
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf				      
				
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		
		cDATFAB := (cAliasTMP)->ZLF_DATFAB
		cCODPRD := (cAliasTMP)->ZLF_PRODUT
		
		/*
                      1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		   "PRODUTO                                           DATA FAB.   DATA MP     NฺM.LOTE    (%)GORD. (%)UMID. (%)E.SECO (%)G.E.SECO (%)CLOR.SOD.  FATIAMENTO  (%)G.CR.SORO  (%)G.CR.LEITE NฺM.EMB.   ACID.TOT.  INSOL.ETEROETILICO"
		   "SEQ.SILO LEITE  NฺM.SILO LEITE  SEQ.SILO SORO  NฺM.SILO SORO  CRIOSCOPIA  E.S.D.   DENSIDADE   PROTEINA  PH LEITE  PH SORO   FOSFATASE  HORA ENT.  RESPONSAVEL                                                 "
		*/  

		
		@nLin,000 PSAY SUBSTR(ALLTRIM((cAliasTMP)->ZLF_PRODUT)+"-"+ALLTRIM((cAliasTMP)->ZLF_DESPRD),1,28)
		@nLin,050 PSAY DTOC(STOD((cAliasTMP)->ZLF_DATFAB))
		@nLin,062 PSAY DTOC(STOD((cAliasTMP)->ZLF_DATMAT))
		@nLin,074 PSAY SUBSTR((cAliasTMP)->ZLF_LOTE,1,10)
		@nLin,086 PSAY TRANSFORM((cAliasTMP)->ZLF_GORD		,"@E 999.99")
		@nLin,095 PSAY TRANSFORM((cAliasTMP)->ZLF_UMIDAD	,"@E 999.99")
		@nLin,104 PSAY TRANSFORM((cAliasTMP)->ZLF_ESP		,"@E 999.99")
		@nLin,114 PSAY TRANSFORM((cAliasTMP)->ZLF_ESG		,"@E 999.99")
		@nLin,126 PSAY TRANSFORM((cAliasTMP)->ZLF_CLRSOD	,"@E 999.99")
		@nLin,140 PSAY TRANSFORM((cAliasTMP)->ZLF_FATIAM	,"@E 999.99")
		@nLin,153 PSAY TRANSFORM((cAliasTMP)->ZLF_CSOROG	,"@E 999.99")
		@nLin,166 PSAY TRANSFORM((cAliasTMP)->ZLF_CLEITG	,"@E 999.99")
		@nLin,180 PSAY (cAliasTMP)->ZLF_NUMEMB
		@nLin,192 PSAY TRANSFORM((cAliasTMP)->ZLF_ACDTOT	,"@E 999.99")
		@nLin,202 PSAY TRANSFORM((cAliasTMP)->ZLF_INSETE	,"@E 999.99")
		
		nLin += 1
		                                        		
		@nLin,000 PSAY (cAliasTMP)->ZLF_SEQL
		@nLin,016 PSAY (cAliasTMP)->ZLF_TANQL	
		@nLin,032 PSAY (cAliasTMP)->ZLF_SEQS
		@nLin,047 PSAY (cAliasTMP)->ZLF_TANQS
		@nLin,062 PSAY TRANSFORM((cAliasTMP)->ZLF_CRIO	,"@E 999.99")
		@nLin,074 PSAY TRANSFORM((cAliasTMP)->ZLF_ESD	,"@E 999.99")
		@nLin,083 PSAY TRANSFORM((cAliasTMP)->ZLF_DENS	,"@E 999.99")
		@nLin,095 PSAY TRANSFORM((cAliasTMP)->ZLF_PROT	,"@E 999.99")
		@nLin,105 PSAY TRANSFORM((cAliasTMP)->ZLF_PHL	,"@E 999.99")
		@nLin,115 PSAY TRANSFORM((cAliasTMP)->ZLF_PHS	,"@E 999.99")
		@nLin,125 PSAY TRANSFORM((cAliasTMP)->ZLF_FOSF	,"@E 999.99")
		@nLin,136 PSAY (cAliasTMP)->ZLF_HORA
		@nLin,147 PSAY (cAliasTMP)->ZLF_RESP
		
		
		If (cAliasTMP)->ZLF_CSOROG != 0
			nTOTCSG += (cAliasTMP)->ZLF_CSOROG
			nREGCSG += 1
		EndIf
		
		If (cAliasTMP)->ZLF_CLEITG != 0
			nTOTCLG += (cAliasTMP)->ZLF_CLEITG
			nREGCLG += 1		
		EndIf
		 
		nLin += 1

		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())
	
	If cCODPRD != STRING_NULL .AND. mv_par07 == 1
		nLin += 2
		@nLin,00 PSAY "MEDIAS DE CREME: "
		@nLin,153 PSAY TRANSFORM(nTOTCSG/nREGCSG ,"@E 999.99")
		@nLin,166 PSAY TRANSFORM(nTOTCLG/nREGCLG ,"@E 999.99")
		nTOTCSG := 0
		nTOTCLG := 0
		nREGCSG := 0
		nREGCLG := 0			
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
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  19/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------*
Static Function AjustaSX1()                                            
*---------------------------------------------------------------------*
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Data Fabrica็ใo De ?","Data Fabrica็ใo De ?","Data Fabrica็ใo De ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01901."})
	aAdd(aRegs,{cPerg,"02","Data Fabrica็ใo At้?","Data Fabrica็ใo At้?","Data Fabrica็ใo At้?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01902."})	
	aAdd(aRegs,{cPerg,"03","Data Mat.Prima De  ?","Data Mat.Prima De  ?","Data Mat.Prima De  ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01903."})
	aAdd(aRegs,{cPerg,"04","Data Mat.Prima At้ ?","Data Mat.Prima At้ ?","Data Mat.Prima At้ ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01904."})	
	aAdd(aRegs,{cPerg,"05","Produto De         ?","Produto De         ?","Produto De         ?","mv_ch5","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","",".LTREL01905."})
	aAdd(aRegs,{cPerg,"06","Produto At้        ?","Produto At้        ?","Produto At้        ?","mv_ch6","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","",".LTREL01906."})
	aAdd(aRegs,{cPerg,"07","Imp. M้dia Creme   ?","Imp. M้dia Creme   ?","Imp. M้dia Creme   ?","mv_ch7","N",01,0,1,"C","","mv_par07","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01907."})
	aAdd(aRegs,{cPerg,"08","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","mv_ch8","N",01,0,1,"C","","mv_par08","Data Fabrica็ใo","Data Fabrica็ใo","Data Fabrica็ใo","","","Produto","Produto","Produto","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01908."})
	aAdd(aRegs,{cPerg,"09","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_ch9","N",01,0,1,"C","","mv_par09","C๓digo Produto","C๓digo Produto","C๓digo Produto","","","Descri็ใo Produto","Descri็ใo Produto","Descri็ใo Produto","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01909."})	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe a data inicial de fabrica็ใo.     " )       
	AADD( aHelp02, "Informe a data final de fabrica็ใo.       " )       
	AADD( aHelp03, "Informe a data inicial da mat้ria-prima.  " )       
	AADD( aHelp04, "Informe a data final da mat้ria-prima.    " )       
	AADD( aHelp05, "Informe o c๓digo inicial do produto.      " )       
	AADD( aHelp06, "Informe o c๓digo final do produto.        " )       
	AADD( aHelp07, "Imprimir m้dias sobre analises de produtos" )       
	AADD( aHelp07, "creme.                                    " )       
	AADD( aHelp08, "Saltar pแgina por data de fabrica็ใo ou   " )       
	AADD( aHelp08, "produto.                                  " )       
	AADD( aHelp09, "Ordenar registros por c๓digo ou descri็ใo " )       
	AADD( aHelp09, "do produto.                               " )       

		
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
	PutSX1Help("P.LTREL01901.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL01902.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL01903.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL01904.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL01905.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL01906.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL01907.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL01908.",aHelp08,aHelp08,aHelp08)	
	PutSX1Help("P.LTREL01909.",aHelp09,aHelp09,aHelp09)	
						
Return Nil