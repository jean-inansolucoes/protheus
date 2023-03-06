#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL007 บAutor  ณRafael Parma         บ Data ณ  19/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo das anแlises normantiva 62.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-------------------------------*
User Function LTREL007()
*-------------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELAวรO DE ANมLISES NORMATIVA 62"
Local cPict          := ""
Local titulo         := "RELAวรO DE ANมLISES NORMATIVA 62"
Local nLin           := 80
Local Cabec1         := "DATA COLETA        LINHA                                              PRODUTOR                                GORDURA (%)   PROTEอNA (%)  LACTOSE (%)   SำLIDOS (%)   CCS (1000/ml) CBT (1000/ml)"

Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00007"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL007"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL007"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZL4"
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

	RptStatus({|| Report(Cabec1,Cabec2,Titulo,nLin) },Titulo)	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณReport    บ Autor ณRafael Parma        บ Data ณ  19/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo das anแlises normantiva 62.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*------------------------------------------------------*
Static Function Report(Cabec1, Cabec2, Titulo, nLin)
*------------------------------------------------------*
Local cAliasTMP := GetNextAlias()
Local cCODLIN   := STRING_Null
Local cCODPRD   := STRING_Null
Local cDATANL   := STRING_Null
Local nTANALISE := 0
Local nMEDGORD  := 0
Local nMEDPROT  := 0
Local nMEDLACT  := 0
Local nMEDSOLD  := 0
Local nMEDCCS   := 0
Local nMEDCBT   := 0
Local nTOTGORD  := 0
Local nTOTPROT  := 0
Local nTOTLACT  := 0
Local nTOTSOLD  := 0
Local nTOTCCS   := 0
Local nTOTCBT   := 0

Local nGTANALISE:= 0
Local nGMDGORD  := 0
Local nGMDPROT  := 0
Local nGMDLACT  := 0
Local nGMDSOLD  := 0
Local nGMDCCS   := 0
Local nGMDCBT   := 0
Local nGTTGORD  := 0
Local nGTTPROT  := 0
Local nGTTLACT  := 0
Local nGTTSOLD  := 0
Local nGTTCCS   := 0
Local nGTTCBT   := 0

Local aPARAM    := {}
Local hEnter    := CHR(10) + CHR(13) 

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
	nSLT_MIN  := aParam[1]

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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	cQuery := "SELECT 	ZL8.ZL8_PROTOC,										" + hEnter
	cQuery += "         ZL8.ZL8_DATCOL,										" + hEnter
	cQuery += "			ZL9.ZL9_PRODUT,										" + hEnter
	cQuery += "			ZL9.ZL9_LOJPRD,										" + hEnter		
	cQuery += "			ZL9.ZL9_NOMPRD,										" + hEnter
	cQuery += "			ZL9.ZL9_SEQ,   										" + hEnter
	cQuery += "			ZL9.ZL9_GORD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_PROTN, 										" + hEnter  
	cQuery += "			ZL9.ZL9_LACT,  										" + hEnter  
	cQuery += "			ZL9.ZL9_SOLD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CCS,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CBT,  										" + hEnter  
	cQuery += "			ZL0.ZL0_COD,  										" + hEnter  
	cQuery += "			ZL0.ZL0_DESC  										" + hEnter  	
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
	If mv_par09 == 1
		cQuery += "AND 		( ZL9.ZL9_PRODUT BETWEEN '" + mv_par03 + "' 	" + hEnter
		cQuery += "AND                 		         '" + mv_par04 + "' )	" + hEnter	
		cQuery += "AND 		( ZL9.ZL9_LOJPRD BETWEEN '" + mv_par05 + "' 	" + hEnter
		cQuery += "AND                 		         '" + mv_par06 + "' )	" + hEnter	
	Else
		cQuery += "AND 		( ZL0.ZL0_COD    BETWEEN '" + mv_par07 + "' 	" + hEnter
		cQuery += "AND                 		         '" + mv_par08 + "' )	" + hEnter	
	EndIf
	cQuery += "AND 		( ZL8.ZL8_DATCOL BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL8.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL9.D_E_L_E_T_    != '*' 							" + hEnter	
 	If mv_par10 == 1 .and. mv_par11 == 1
		cQuery += "ORDER BY ZL9.ZL9_NOMPRD									" + hEnter
	ElseIf mv_par10 == 1 .and. mv_par11 == 2
		cQuery += "ORDER BY ZL0.ZL0_COD, ZL9.ZL9_NOMPRD						" + hEnter	
	ElseIf mv_par10 == 1 .and. mv_par11 == 3
		cQuery += "ORDER BY ZL8.ZL8_DATCOL, ZL9.ZL9_NOMPRD					" + hEnter	
	ElseIf mv_par10 == 2 .and. mv_par11 == 1
		cQuery += "ORDER BY ZL8.ZL8_DATCOL, ZL9.ZL9_NOMPRD					" + hEnter	
	ElseIf mv_par10 == 2 .and. mv_par11 == 2
		cQuery += "ORDER BY ZL8.ZL8_DATCOL, ZL0.ZL0_COD, ZL9.ZL9_NOMPRD		" + hEnter	
	ElseIf mv_par10 == 2 .and. mv_par11 == 3
		cQuery += "ORDER BY ZL8.ZL8_DATCOL, ZL9.Zl9_SEQ, ZL9.ZL9_NOMPRD		" + hEnter	
	EndIf

	memowrite("LTREL006_1.SQL",cQuery)
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
		//ณ Verifica registros dentro/fora intervalos..                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	    lSkip := .F.
		
		If (cAliasTMP)->ZL9_GORD < nGORD_MIN 		.AND. (cAliasTMP)->ZL9_GORD != 0
			lSkip := .T.
		ElseIf (cAliasTMP)->ZL9_PROTN < nPROT_MIN 	.AND. (cAliasTMP)->ZL9_PROTN != 0
			lSkip := .T.
		ElseIf (cAliasTMP)->ZL9_LACT < nLACT_MIN 	.AND. (cAliasTMP)->ZL9_LACT != 0
			lSkip := .T.
		ElseIf (cAliasTMP)->ZL9_SOLD < nSLT_MIN		.AND. (cAliasTMP)->ZL9_SOLD != 0
			lSkip := .T.
		ElseIf (cAliasTMP)->ZL9_CCS > nCCS_MAX 		.AND. (cAliasTMP)->ZL9_CCS != 0
			lSkip := .T.
		ElseIf (cAliasTMP)->ZL9_CBT > nCBT_MAX 		.AND. (cAliasTMP)->ZL9_CBT != 0
			lSkip := .T.
		EndIf

		If mv_par12 == 2	//Anแlises dentro dos limites
			
			If lSkip
				(cAliasTMP)->(dbSkip())
				Loop
			EndIf
	                                                       
		ElseIf mv_par12 == 3	//Anแlises fora dos limites
		
			If ! lSkip
				(cAliasTMP)->(dbSkip())
				Loop
			EndIf

		
		EndIf
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		    DATA COLETA   DATA ANมLISE    LINHA                                   PRODUTOR                                GORDURA (%)   PROTEอNA (%)  LACTOSE (%)   SำLIDOS (%)   CCS (1000/ml) CBT (1000/ml)                        

		*/  

		If mv_par11 == 1 .and. cCODPRD != ( (cAliasTMP)->ZL9_PRODUT + (cAliasTMP)->ZL9_LOJPRD )
			If nTANALISE != 0
				fImpMEDIA(.F.,@nTANALISE,@nMEDGORD,@nMEDPROT,@nMEDLACT,@nMEDSOLD,@nMEDCCS,@nMEDCBT,@nTOTGORD,@nTOTPROT,@nTOTLACT,@nTOTSOLD,@nTOTCCS,@nTOTCBT,@nLin)				
			EndIf						
			If nLin != 80 .and. mv_par13 == 1
				fImpLIMITE(@nLin)
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8 
		ElseIf mv_par11 == 2 .and. cCODLIN != (cAliasTMP)->ZL0_COD
			If nTANALISE != 0				
				fImpMEDIA(.F.,@nTANALISE,@nMEDGORD,@nMEDPROT,@nMEDLACT,@nMEDSOLD,@nMEDCCS,@nMEDCBT,@nTOTGORD,@nTOTPROT,@nTOTLACT,@nTOTSOLD,@nTOTCCS,@nTOTCBT,@nLin)				
			EndIf						
			If nLin != 80 .and. mv_par13 == 1
				fImpLIMITE(@nLin)
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8 
        ElseIf mv_par11 == 3 .and. cDATANL != (cAliasTMP)->ZL8_DATCOL
			If nTANALISE != 0
				fImpMEDIA(.F.,@nTANALISE,@nMEDGORD,@nMEDPROT,@nMEDLACT,@nMEDSOLD,@nMEDCCS,@nMEDCBT,@nTOTGORD,@nTOTPROT,@nTOTLACT,@nTOTSOLD,@nTOTCCS,@nTOTCBT,@nLin)
			EndIf								
			If nLin != 80 .and. mv_par13 == 1
				fImpLIMITE(@nLin)
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8 
		EndIf				      
				
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8                                       
		EndIf
		         
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao dos dados...                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		
		@nLin,000 PSAY dtoc(stod((cAliasTMP)->ZL8_DATCOL))
		@nLin,020 PSAY (cAliasTMP)->ZL0_COD+"/"+SubSTR((cAliasTMP)->ZL0_DESC,1,30)
		@nLin,070 PSAY (cAliasTMP)->ZL9_PRODUT+"/"+(cAliasTMP)->ZL9_LOJPRD+"-"+SubSTR((cAliasTMP)->ZL9_NOMPRD,1,26)
		@nLin,110 PSAY TRANSFORM((cAliasTMP)->ZL9_GORD,  "@E 999.99")
		@nLin,124 PSAY TRANSFORM((cAliasTMP)->ZL9_PROTN, "@E 999.99")
		@nLin,138 PSAY TRANSFORM((cAliasTMP)->ZL9_LACT,  "@E 999.99")
		@nLin,152 PSAY TRANSFORM((cAliasTMP)->ZL9_SOLD,  "@E 999.99")
		@nLin,166 PSAY TRANSFORM((cAliasTMP)->ZL9_CCS*1000, "@E 99,999,999")
		@nLin,180 PSAY TRANSFORM((cAliasTMP)->ZL9_CBT*1000, "@E 99,999,999")
		nLin += 1
		
		cCODLIN := (cAliasTMP)->ZL0_COD
		cCODPRD := (cAliasTMP)->ZL9_PRODUT + (cAliasTMP)->ZL9_LOJPRD
		cDATANL := (cAliasTMP)->ZL8_DATCOL 
		
		nTANALISE  += 1
		nGTANALISE += 1
		If (cAliasTMP)->ZL9_GORD != 0
			nMEDGORD += (cAliasTMP)->ZL9_GORD
			nTOTGORD += 1			
			nGMDGORD += (cAliasTMP)->ZL9_GORD
			nGTTGORD += 1			
		EndIf                        
		If (cAliasTMP)->ZL9_PROTN != 0
			nMEDPROT += (cAliasTMP)->ZL9_PROTN
			nTOTPROT += 1		
			nGMDPROT += (cAliasTMP)->ZL9_PROTN
			nGTTPROT += 1		
		EndIf
		If (cAliasTMP)->ZL9_LACT != 0		
			nMEDLACT += (cAliasTMP)->ZL9_LACT
			nTOTLACT += 1
			nGMDLACT += (cAliasTMP)->ZL9_LACT
			nGTTLACT += 1
		EndIf
		If (cAliasTMP)->ZL9_SOLD != 0		
			nMEDSOLD += (cAliasTMP)->ZL9_SOLD
			nTOTSOLD += 1
			nGMDSOLD += (cAliasTMP)->ZL9_SOLD
			nGTTSOLD += 1
		EndIf                            
		If (cAliasTMP)->ZL9_CCS != 0
			nMEDCCS += (cAliasTMP)->ZL9_CCS
			nTOTCCS += 1
			nGMDCCS += (cAliasTMP)->ZL9_CCS
			nGTTCCS += 1
		EndIf
		If (cAliasTMP)->ZL9_CBT != 0
			nMEDCBT += (cAliasTMP)->ZL9_CBT		
    		nTOTCBT += 1
			nGMDCBT += (cAliasTMP)->ZL9_CBT		
    		nGTTCBT += 1
		EndIf
 
		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())
	
	If nTANALISE != 0
		fImpMEDIA(.F.,@nTANALISE,@nMEDGORD,@nMEDPROT,@nMEDLACT,@nMEDSOLD,@nMEDCCS,@nMEDCBT,@nTOTGORD,@nTOTPROT,@nTOTLACT,@nTOTSOLD,@nTOTCCS,@nTOTCBT,@nLin)				
		fImpMEDIA(.T.,@nGTANALISE,@nGMDGORD,@nGMDPROT,@nGMDLACT,@nGMDSOLD,@nGMDCCS,@nGMDCBT,@nGTTGORD,@nGTTPROT,@nGTTLACT,@nGTTSOLD,@nGTTCCS,@nGTTCBT,@nLin)				
	EndIf
	If nLin != 80 .and. mv_par13 == 1
		fImpLIMITE(@nLin)
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
ฑฑบPrograma  ณfImpMEDIA  บAutor  ณRafael Parma       บ Data ณ  19/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para impressใo das m้dias de anแlises.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------------------------------------------------------------------------------------------------------------------------------------*
Static Function fImpMEDIA(lFINAL,nTANALISE,nMEDGORD,nMEDPROT,nMEDLACT,nMEDSOLD,nMEDCCS,nMEDCBT,nTOTGORD,nTOTPROT,nTOTLACT,nTOTSOLD,nTOTCCS,nTOTCBT,nLin)        
*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

	If lFINAL
		nLin += 2
		@nLin,000 PSAY "MษDIA GERAL DE ANมLISES: "
	Else
		@nLin,000 PSAY "MษDIA DE ANมLISES: "
	EndIf
	
	@nLin,110 PSAY TRANSFORM(nMEDGORD/nTOTGORD,  "@E 999.99")
	@nLin,124 PSAY TRANSFORM(nMEDPROT/nTOTPROT,  "@E 999.99")
	@nLin,138 PSAY TRANSFORM(nMEDLACT/nTOTLACT,  "@E 999.99")
	@nLin,152 PSAY TRANSFORM(nMEDSOLD/nTOTSOLD,  "@E 999.99")
	@nLin,166 PSAY TRANSFORM((nMEDCCS/nTOTCCS)*1000,   "@E 99,999,999")
	@nLin,180 PSAY TRANSFORM((nMEDCBT/nTOTCBT)*1000,   "@E 99,999,999")			
	nLin += 2      
	If lFINAL
		@nLin,000 PSAY "TOTAL GERAL DE ANมLISES: "+CVALTOCHAR(nTANALISE)
	Else
		@nLin,000 PSAY "TOTAL DE ANมLISES: "+CVALTOCHAR(nTANALISE)
	EndIf
	nTANALISE := 0
	nMEDGORD  := 0
	nMEDPROT  := 0
	nMEDLACT  := 0
	nMEDSOLD  := 0
	nMEDCCS   := 0
	nMEDCBT   := 0
	nTOTGORD  := 0
	nTOTPROT  := 0
	nTOTLACT  := 0
	nTOTSOLD  := 0
	nTOTCCS   := 0
	nTOTCBT   := 0

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfImpLIMITE บAutor  ณRafael Parma       บ Data ณ  19/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo dos limites das analises.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------*
Static Function fImpLIMITE(nLin)                                       
*---------------------------------------------------------------------*

	/*
			  1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
	0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	LIMITES DE ANมLISES:  ALIZAROL MIN.: 99   ACIDEZ MIN./MAX.: 99/99   CRIOSCOPIA MIN./MAX.: 99999/99999    GORDURA MIN.: 999        DENSIDADE MIN./MAX.: 9999/99999    EST MIN.: 999    ESD MIN.: 999      REDUTASE MIN.: 999
	*/
	
	nLin+= 2
	@nLin,000 PSAY "LIMITES DE ANมLISES: "
	@nLin,028 PSAY "GORDURA MIN.: "  + cValToChar(nGORD_MIN)
	@nLin,051 PSAY "PROTEอNA MIN.: " + cValToChar(nPROT_MIN)
	@nLin,075 PSAY "EX SEC DES MIN.: "  + cValToChar(nLACT_MIN)
	@nLin,099 PSAY "EX SEC TOT MIN.: "  + cValToChar(nSLT_MIN)
	@nLin,121 PSAY "CSS MAX.: " + cValToChar(nCCS_MAX*1000)
	@nLin,144 PSAY "CPP MAX.: " + cValToChar(nCBT_MAX*1000)
		
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
*-----------------------------*
Static Function AjustaSX1()
*-----------------------------*
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
aHelp12 := {} 
aHelp13 := {} 


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Perํodo De         ?","Perํodo De         ?","Perํodo De         ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0701."})
	aAdd(aRegs,{cPerg,"02","Perํodo At้        ?","Perํodo At้        ?","Perํodo At้        ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0702."})	
	aAdd(aRegs,{cPerg,"03","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch3","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL0703."})
	aAdd(aRegs,{cPerg,"04","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch4","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL0704."})
	aAdd(aRegs,{cPerg,"05","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch5","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0705."})
	aAdd(aRegs,{cPerg,"06","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch6","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0706."})
	aAdd(aRegs,{cPerg,"07","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch7","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0707."})
	aAdd(aRegs,{cPerg,"08","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch8","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0708."})
	aAdd(aRegs,{cPerg,"09","Filtrar Por        ?","Filtrar Por        ?","Filtrar Por        ?","mv_ch9","N",01,0,1,"C","","mv_par09","Produtor","Produtor","Produtor","","","Linha","Linha","Linha","","","","","","","","","","","","","","","","","","","","","","",".LTREL0709."})
	aAdd(aRegs,{cPerg,"10","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_cha","N",01,0,1,"C","","mv_par10","Produtor","Produtor","Produtor","","","Data Coleta","Data Coleta","Data Coleta","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","mv_chb","N",01,0,1,"C","","mv_par11","Produtor","Produtor","Produtor","","","Linha","Linha","Linha","","","Data Coleta","Data Coleta","Data Coleta","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"12","Filtrar Anแlises   ?","Filtrar Anแlises   ?","Filtrar Anแlises   ?","mv_chc","N",01,0,1,"C","","mv_par12","Todas","Todas","Todas","","","Dentro Limites","Dentro Limites","Dentro Limites","","","Fora Limites","Fora Limites","Fora Limites","","","","","","","","","","","","","","","","", "","","",".LTREL0712."})
	aAdd(aRegs,{cPerg,"13","Imprimir Limites   ?","Imprimir Limites   ?","Imprimir Limites   ?","mv_chd","N",01,0,1,"C","","mv_par13","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01013."})
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe a data inicial do periodo        " )       
	AADD( aHelp01, "a ser impresso.                          " )       
	AADD( aHelp02, "Informe a data final do periodo          " )       
	AADD( aHelp02, "a ser impresso.                          " )
	AADD( aHelp03, "Informe o c๓digo inicial do produtor     " )       
	AADD( aHelp03, "a ser impresso.                          " )       
	AADD( aHelp04, "Informe o c๓digo final do produtor       " )       
	AADD( aHelp04, "a ser impresso.                          " )       
	AADD( aHelp05, "Informe a loja inicial do produtor       " )       
	AADD( aHelp05, "a ser impresso.                          " )       
	AADD( aHelp06, "Informe a loja final do produtor         " )       
	AADD( aHelp06, "a ser impresso.                          " )      
	AADD( aHelp07, "Informe o n๚mero inicial da linha        " )       
	AADD( aHelp07, "a ser impressa.                          " )       
	AADD( aHelp08, "Informe o n๚mero final da linha          " )       
	AADD( aHelp08, "a ser impressa.                          " )       
	AADD( aHelp09, "Informe se deseje imprimir por intervalo " )       
	AADD( aHelp09, "de linhas ou produtores.                 " )  
	AADD( aHelp12, "Informe se deseje imprimir todas as anแ- " )       
	AADD( aHelp12, "lises, anแlises dentro dos parโmetros ou " )  
	AADD( aHelp12, "fora dos parโmetros.					 " )  
	AADD( aHelp13, "Imprimir limites minimo/maximo sobre     " )       
	AADD( aHelp13, "analises.                                " )  

	
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
	PutSX1Help("P.LTREL0701.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0702.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL0703.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL0704.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL0705.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL0706.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL0707.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL0708.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL0709.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL0712.",aHelp12,aHelp12,aHelp12)
	PutSX1Help("P.LTREL0713.",aHelp13,aHelp13,aHelp13)
					
Return Nil
