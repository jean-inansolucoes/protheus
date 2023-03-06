#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL016 บAutor  ณRafael Parma         บ Data ณ  25/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de resultados de anแlises da vazใo.     บฑฑ
ฑฑบ          ณEntrega do transportador.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL016()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELAวรO DE ANมLISES DA VAZรO"
Local cPict          := ""
Local titulo         := "ANมLISES DA VAZรO - COD: PPHO 23 - ISO: 4.9 - RG: 01 - PG: 4/5"
Local nLin           := 80
Local Cabec1         := "DATA        HORA  LINHA         TEMPERAT. ACIDEZ    ALIZAROL  CRIOSCOP. GORDURA   DENSIDADE PROTEอNA  ESD       REDUTAZE  ANTIBIOT. HID.SำDIO   BICARBON. CLORETOS  BORATOS  	PER.HID.  FORMOL    SACAROSE  AMIDO" 
Local Cabec2         := "VOLUME INF.     VOL. MEDIDO         ANALISTA                      OBSERVACOES"
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00016"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL016"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL016"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZL7"
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
Local cAliasTMP   := GetNextAlias()
Local cCODTRP     := STRING_NULL
Local cCODLIN     := STRING_NULL
Local cDATANL     := STRING_NULL
Local hEnter	  := CHR(10) + CHR(13) 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
                                        
	
    aParam := {}
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
	cQuery += "     	ZL7.ZL7_COD,										" + hEnter
	cQuery += "     	ZL7.ZL7_LINHA,										" + hEnter
	cQuery += "         ZL7.ZL7_TRANSP,										" + hEnter
	cQuery += "         ZL7.ZL7_DATA,  										" + hEnter
	cQuery += "         ZL7.ZL7_QTDVAZ,										" + hEnter
	cQuery += "         ZL7.ZL7_HORA,										" + hEnter
	cQuery += "         ZL7.ZL7_TANQUE,										" + hEnter
	cQuery += "         ZL7.ZL7_TEMPER,										" + hEnter
	cQuery += "         ZL7.ZL7_ACID,										" + hEnter
	cQuery += "         ZL7.ZL7_ALIZAR,										" + hEnter
	cQuery += "         ZL7.ZL7_CRIO,										" + hEnter
	cQuery += "         ZL7.ZL7_GORD,										" + hEnter
	cQuery += "         ZL7.ZL7_DENS,										" + hEnter
	cQuery += "         ZL7.ZL7_PROT,										" + hEnter
	cQuery += "         ZL7.ZL7_ESD,   										" + hEnter
	cQuery += "         ZL7.ZL7_REDUTA,										" + hEnter
	cQuery += "         ZL7.ZL7_ANTIBI,										" + hEnter	 
	cQuery += "         ZL7.ZL7_HIDSOD,										" + hEnter	 
	cQuery += "         ZL7.ZL7_BICARB,										" + hEnter	 
	cQuery += "         ZL7.ZL7_CLORET,										" + hEnter	 	
	cQuery += "         ZL7.ZL7_BORATO,										" + hEnter	 
	cQuery += "         ZL7.ZL7_PERHID,										" + hEnter	 
	cQuery += "         ZL7.ZL7_FORMOL,										" + hEnter	 
	cQuery += "         ZL7.ZL7_SACARO,										" + hEnter	 
	cQuery += "         ZL7.ZL7_AMIDO,										" + hEnter	 
	cQuery += "         ZL7.ZL7_ANALIS,										" + hEnter	 
	cQuery += "         ZL7.ZL7_OBS											" + hEnter	 	
	cQuery += "FROM " + RetSqlName("ZL7") + " ZL7							" + hEnter
	cQuery += "WHERE    ZL7.ZL7_FILIAL = '" + xFilial("ZL7") + "' 			" + hEnter
	cQuery += "AND 		( ZL7.ZL7_DATA   BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		( ZL7.ZL7_TRANSP BETWEEN '" + mv_par03 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par04 + "' )		" + hEnter	
	cQuery += "AND 		( ZL7.ZL7_LINHA  BETWEEN '" + mv_par05 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par06 + "' )		" + hEnter	
	cQuery += "AND 		ZL7.D_E_L_E_T_    != '*' 							" + hEnter
 	If mv_par07 == 1
		cQuery += "ORDER BY ZL7.ZL7_TRANSP, ZL7.ZL7_DATA					" + hEnter
	ElseIf mv_par07 == 2
		cQuery += "ORDER BY ZL7.ZL7_LINHA, ZL7.ZL7_TRANSP, ZL7.ZL7_DATA		" + hEnter	
	Else
		cQuery += "ORDER BY ZL7.ZL7_DATA, ZL7.ZL7_TRANSP					" + hEnter	
	EndIf
	

	memowrite("LTREL010_1.SQL",cQuery)
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


		If mv_par07 == 1 .and. cCODTRP != (cAliasTMP)->ZL7_TRANSP
			If nLin != 80 .and. mv_par08 == 1
				fImpLIMITE(@nLin)
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		ElseIf mv_par07 == 2 .and. cCODLIN != (cAliasTMP)->ZL7_LINHA
			If nLin != 80 .and. mv_par08 == 1
				fImpLIMITE(@nLin)
			EndIf		
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
        ElseIf mv_par07 == 3 .and. cDATANL != (cAliasTMP)->ZL7_DATA
			If nLin != 80 .and. mv_par09 == 1
				fImpLIMITE(@nLin)
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf				      
				
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf

		/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		    DATA        HORA  LINHA         TEMPERAT. ACIDEZ    ALIZAROL  CRIOSCOP. GORDURA   DENSIDADE PROTEอNA  ESD       REDUTAZE  ANTIBIOT. HID.SำDIO   BICARBON. CLORETOS  BORATOS  	PER.HID.  FORMOL    SACAROSE  AMIDO
			VOLUME INF.     VOL. MEDIDO         ANALISTA                      OBSERVACOES
		*/  
		
		@nLin,000 PSAY dtoc(stod((cAliasTMP)->ZL7_DATA))
		@nLin,012 PSAY (cAliasTMP)->ZL7_HORA
		@nLin,018 PSAY (cAliasTMP)->ZL7_LINHA

		@nLin,032 PSAY TRANSFORM((cAliasTMP)->ZL7_TEMPER	,  "@E 999")
		@nLin,042 PSAY TRANSFORM((cAliasTMP)->ZL7_ACID 		,  "@E 999999")
		@nLin,052 PSAY TRANSFORM((cAliasTMP)->ZL7_ALIZAR	,  "@E 999999")				
		@nLin,062 PSAY TRANSFORM((cAliasTMP)->ZL7_CRIO 		,  "@E 999999")
		@nLin,072 PSAY TRANSFORM((cAliasTMP)->ZL7_GORD 		,  "@E 999.99")		
		@nLin,082 PSAY TRANSFORM((cAliasTMP)->ZL7_DENS 		,  "@E 99,999")
		@nLin,092 PSAY TRANSFORM((cAliasTMP)->ZL7_PROT 		,  "@E 999999")
		@nLin,102 PSAY TRANSFORM((cAliasTMP)->ZL7_ESD  		,  "@E 999.99")
		@nLin,112 PSAY TRANSFORM((cAliasTMP)->ZL7_REDUTA	,  "@E 999999")
		@nLin,122 PSAY IIF((cAliasTMP)->ZL7_ANTIBI=="P","POS.",IIF((cAliasTMP)->ZL7_ANTIBI=="N","NEG."," "))
		@nLin,132 PSAY IIF((cAliasTMP)->ZL7_HIDSOD=="P","POS.",IIF((cAliasTMP)->ZL7_HIDSOD=="N","NEG."," "))
		@nLin,152 PSAY IIF((cAliasTMP)->ZL7_BICARB=="P","POS.",IIF((cAliasTMP)->ZL7_BICARB=="N","NEG."," "))
		@nLin,162 PSAY IIF((cAliasTMP)->ZL7_CLORET=="P","POS.",IIF((cAliasTMP)->ZL7_CLORET=="N","NEG."," "))
		@nLin,172 PSAY IIF((cAliasTMP)->ZL7_BORATO=="P","POS.",IIF((cAliasTMP)->ZL7_BORATO=="N","NEG."," "))
		@nLin,182 PSAY IIF((cAliasTMP)->ZL7_PERHID=="P","POS.",IIF((cAliasTMP)->ZL7_PERHID=="N","NEG."," "))
		@nLin,192 PSAY IIF((cAliasTMP)->ZL7_FORMOL=="P","POS.",IIF((cAliasTMP)->ZL7_FORMOL=="N","NEG."," "))
		@nLin,202 PSAY IIF((cAliasTMP)->ZL7_SACARO=="P","POS.",IIF((cAliasTMP)->ZL7_SACARO=="N","NEG."," "))
		@nLin,212 PSAY IIF((cAliasTMP)->ZL7_AMIDO =="P","POS.",IIF((cAliasTMP)->ZL7_AMIDO =="N","NEG."," "))								
		nLin += 1
		
		nTOTINF := 0
		dbSelectArea("ZL5")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek ( xFilial("ZL5") + dtoc(stod((cAliasTMP)->ZL7_DATA)) + (cAliasTMP)->ZL7_LINHA )
			While !ZL5->(EOF()) .and. ZL5->ZL5_FILIAL + ZL5->ZL5_DATA + ZL5->ZL5_LINHA == xFilial("ZL5") + stod((cAliasTMP)->ZL7_DATA) + (cAliasTMP)->ZL7_LINHA
				nTOTINF += ZL5->ZL5_TOTAL	
			Enddo
		EndIf

		@nLin,000 PSAY TRANSFORM(nTOTINF	,  "@E 999999")
		@nLin,016 PSAY TRANSFORM((cAliasTMP)->ZL7_QTDVAZ	,  "@E 999999")
		@nLin,036 PSAY UPPER(SubSTR((cAliasTMP)->ZL7_ANALIS,1,28))
		@nLin,066 PSAY UPPER(SubSTR((cAliasTMP)->ZL7_OBS,1,150))
		nLin += 1
		
		cCODTRP := (cAliasTMP)->ZL7_TRANSP
		cCODLIN := (cAliasTMP)->ZL7_LINHA
		cDATANL := (cAliasTMP)->ZL7_DATA
 
		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())

	If nLin != 80 .and. mv_par08 == 1
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
	@nLin,022 PSAY "ALIZAROL MIN.: " + cValToChar(nALZ_MIN)
	@nLin,042 PSAY "ACIDEZ MIN./MAX.: " + cValToChar(nACD_MIN)+"/"+cValToChar(nACD_MAX)
	@nLin,068 PSAY "CRIOSCOPIA MIN./MAX.: " + cValToChar(nCRI_MIN)+"/"+cValToChar(nCRI_MAX)	
	@nLin,105 PSAY "GORDURA MIN.: " + cValToChar(nGORD_MIN)
	@nLin,130 PSAY "DENSIDADE MIN./MAX.: " + cValToChar(nDEN_MIN)+"/"+cValToChar(nDEN_MAX)	
	@nLin,165 PSAY "EST MIN.: " + cValToChar(nEST_MIN)
	@nLin,182 PSAY "ESD MIN.: " + cValToChar(nESD_MIN)
	@nLin,200 PSAY "REDUTASE MIN.: " + cValToChar(nRED_MIN)	
	
		
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Perํodo De         ?","Perํodo De         ?","Perํodo De         ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01601."})
	aAdd(aRegs,{cPerg,"02","Perํodo At้        ?","Perํodo At้        ?","Perํodo At้        ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01602."})	
	aAdd(aRegs,{cPerg,"03","Transportador De   ?","Transportador De   ?","Transportador De   ?","mv_ch3","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01603."})
	aAdd(aRegs,{cPerg,"04","Transportador At้  ?","Transportador At้  ?","Transportador At้  ?","mv_ch4","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01604."})
	aAdd(aRegs,{cPerg,"05","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01605."})
	aAdd(aRegs,{cPerg,"06","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch6","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01606."})
	aAdd(aRegs,{cPerg,"07","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","mv_ch7","N",01,0,1,"C","","mv_par07","Transportador","Transportador","Transportador","","","Linha","Linha","Linha","","","Data Anแlise","Data Anแlise","Data Anแlise","","","","","","","","","","","","","","","","", "","","",".LTREL01607."})
	aAdd(aRegs,{cPerg,"08","Imprimir Limites   ?","Imprimir Limites   ?","Imprimir Limites   ?","mv_ch8","N",01,0,1,"C","","mv_par08","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01608."})	
	
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
	AADD( aHelp05, "Informe o n๚mero inicial da linha        " )       
	AADD( aHelp05, "a ser impressa.                          " )       
	AADD( aHelp06, "Informe o n๚mero final da linha          " )       
	AADD( aHelp06, "a ser impressa.                          " )       
	AADD( aHelp07, "Informe se deseje saltar pagina por      " )       
	AADD( aHelp07, "produtor, linha ou analises.             " )  
	AADD( aHelp08, "Imprimir limites minimo/maximo sobre     " )       
	AADD( aHelp08, "analises.                                " )
		
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
	PutSX1Help("P.LTREL01601.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL01602.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL01603.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL01604.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL01605.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL01606.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL01607.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL01608.",aHelp08,aHelp08,aHelp08)	
					
Return Nil