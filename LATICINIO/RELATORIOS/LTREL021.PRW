#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL021 บAutor  ณRafael Parma         บ Data ณ  27/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de resultados de anแlises dos tanques/vazใo.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL021()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "ANมLISE DE ANTIBIOTICO TANQUES - VAZรO"
Local cPict          := ""
Local titulo         := "ANมLISE DE ANTIBIOTICO TANQUES - VAZรO"
Local nLin           := 80
Local Cabec1         := "DATA       TANQUE  SEQ LINHA                       ACIDEZ    CRIOSCOP. (%).CRIO. TEMPERAT. DENSIDADE GORDURA  ESD        EST       PROTEINA  LACTOSE   EST.ALCOOL  REDUTASE    ANTIBIOTICO TIPO ANAL. PER.HIDROGENIO  FORMOL" 
Local Cabec2         := "                                                   HIPOCLORITO  HID.SODIO   BICARBONATO   CLORETOS   SACAROSE   AMIDO    BORATOS   ANALISTA                     OBSERVACOES                                                 "
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00021"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL021"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL021"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZLH"
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
Local cAliasTMP   := GetNextAlias()
Local cDATANA     := STRING_NULL
Local cCODLIN     := STRING_NULL
Local cCODVAZ     := STRING_NULL
Local nTANQUES    := 0
Local hEnter	  := CHR(10) + CHR(13)
Local nZLH_ACI	:= 0
Local nZLH_CRI	:= 0
Local nZLH_PCR 	:= 0
Local nZLH_TEM	:= 0
Local nZLH_DEN 	:= 0
Local nZLH_GOR 	:= 0
Local nZLH_ESD 	:= 0
Local nZLH_EST 	:= 0
Local nZLH_PRO 	:= 0
Local nZLH_LAC	:= 0
Local nZLH_ALI 	:= 0
Local nZLH_RED	:= 0
Local nQZLH_ACI	:= 0				
Local nQZLH_CRI := 0
Local nQZLH_PCR := 0
Local nQZLH_TEM := 0
Local nQZLH_DEN := 0
Local nQZLH_GOR := 0
Local nQZLH_ESD := 0
Local nQZLH_EST := 0
Local nQZLH_PRO := 0
Local nQZLH_LAC	:= 0
Local nQZLH_ALI := 0
Local nQZLH_RED := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de registros....   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	 
	//-- Filtro dos dados
	cQuery := " SELECT 														" + hEnter
	cQuery += "     	ZLH.ZLH_CODVAZ,										" + hEnter	
	cQuery += "     	ZLH.ZLH_LINHA,										" + hEnter
	cQuery += "     	ZL7.ZL7_NOMLIN,										" + hEnter
	cQuery += "     	ZLH.ZLH_SEQENT,										" + hEnter	
	cQuery += "     	ZLH.ZLH_DATA,										" + hEnter
	cQuery += "     	ZLH.ZLH_TANQUE,										" + hEnter
	cQuery += "     	ZLH.ZLH_ACID,										" + hEnter
	cQuery += "     	ZLH.ZLH_CRIO,										" + hEnter
	cQuery += "     	ZLH.ZLH_PCRIO,										" + hEnter
	cQuery += "     	ZLH.ZLH_TEMPER,										" + hEnter
	cQuery += "     	ZLH.ZLH_DENS,										" + hEnter
	cQuery += "     	ZLH.ZLH_GORD,										" + hEnter
	cQuery += "     	ZLH.ZLH_ESD,										" + hEnter
	cQuery += "     	ZLH.ZLH_EST,										" + hEnter
	cQuery += "     	ZLH.ZLH_PROT,										" + hEnter
	cQuery += "     	ZLH.ZLH_LACTOS,										" + hEnter
	cQuery += "     	ZLH.ZLH_ANTIBI,										" + hEnter
	cQuery += "     	ZLH.ZLH_TAANT,										" + hEnter
	cQuery += "     	ZLH.ZLH_PERHID,										" + hEnter
	cQuery += "     	ZLH.ZLH_FORMOL,										" + hEnter
	cQuery += "     	ZLH.ZLH_HIPCLO,										" + hEnter
	cQuery += "     	ZLH.ZLH_HIDSOD,										" + hEnter
	cQuery += "     	ZLH.ZLH_BICARB,										" + hEnter
	cQuery += "     	ZLH.ZLH_CLORET,										" + hEnter
	cQuery += "     	ZLH.ZLH_ALIZ,										" + hEnter
	cQuery += "     	ZLH.ZLH_SACARO,										" + hEnter
	cQuery += "     	ZLH.ZLH_AMIDO,										" + hEnter
	cQuery += "     	ZLH.ZLH_BORATO,										" + hEnter
	cQuery += "     	ZLH.ZLH_REDUTA,										" + hEnter
	cQuery += "     	ZLH.ZLH_ANALIS,										" + hEnter
	cQuery += "     	ZLH.ZLH_OBS 										" + hEnter
	cQuery += " FROM " + RetSqlName("ZLH") + " ZLH							" + hEnter
	cQuery += " INNER JOIN " + RetSqlName("ZL7") + " ZL7					" + hEnter
	cQuery += " ON		ZLH.ZLH_FILIAL = ZL7.ZL7_FILIAL						" + hEnter
	cQuery += " AND		ZLH.ZLH_CODVAZ = ZL7.ZL7_COD						" + hEnter
	cQuery += "WHERE    ZLH.ZLH_FILIAL = '" + xFilial("ZLH") + "' 			" + hEnter
	cQuery += "AND 		( ZLH.ZLH_DATA   BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		( ZLH.ZLH_LINHA  BETWEEN '" + mv_par03 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par04 + "' )		" + hEnter	
	cQuery += "AND 		( ZL7.ZL7_TRANSP BETWEEN '" + mv_par05 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par06 + "' )		" + hEnter	
	cQuery += "AND 		ZLH.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL7.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "ORDER BY 								           			" + hEnter
 	If mv_par07 == 1
		cQuery += "     	ZLH.ZLH_LINHA,									" + hEnter
		cQuery += "     	ZLH.ZLH_DATA,									" + hEnter
		cQuery += "     	ZLH.ZLH_SEQENT 									" + hEnter	
	Else
		cQuery += "     	ZLH.ZLH_DATA,									" + hEnter
		cQuery += "     	ZLH.ZLH_LINHA,									" + hEnter
		cQuery += "     	ZLH.ZLH_SEQENT 									" + hEnter	
	EndIf
	

	memowrite("LTREL021.SQL",cQuery)
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

                                                                
		If mv_par07 == 1 .and. cCODLIN != (cAliasTMP)->ZLH_LINHA
		
			If cCODVAZ != (cAliasTMP)->ZLH_CODVAZ .and. cCODVAZ != STRING_NULL

				fImpMedia(@nZLH_ACI,@nZLH_CRI,@nZLH_PCR,@nZLH_TEM,@nZLH_DEN,@nZLH_GOR,@nZLH_ESD,@nZLH_EST,@nZLH_PRO,@nZLH_LAC,@nZLH_ALI,@nZLH_RED,;
				@nQZLH_ACI,@nQZLH_CRI,@nQZLH_PCR,@nQZLH_TEM,@nQZLH_DEN,@nQZLH_GOR,@nQZLH_ESD,@nQZLH_EST,@nQZLH_PRO,@nQZLH_LAC,@nQZLH_ALI,@nQZLH_RED,@nLin)	

			EndIf		
					
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		ElseIf mv_par07 == 2 .and. cDATANA != (cAliasTMP)->ZLH_DATA

			If cCODVAZ != (cAliasTMP)->ZLH_CODVAZ .and. cCODVAZ != STRING_NULL
				
				fImpMedia(@nZLH_ACI,@nZLH_CRI,@nZLH_PCR,@nZLH_TEM,@nZLH_DEN,@nZLH_GOR,@nZLH_ESD,@nZLH_EST,@nZLH_PRO,@nZLH_LAC,@nZLH_ALI,@nZLH_RED,;
				@nQZLH_ACI,@nQZLH_CRI,@nQZLH_PCR,@nQZLH_TEM,@nQZLH_DEN,@nQZLH_GOR,@nQZLH_ESD,@nQZLH_EST,@nQZLH_PRO,@nQZLH_LAC,@nQZLH_ALI,@nQZLH_RED,@nLin)	
			
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
		    DATA       TANQUE  SEQ LINHA                       ACIDEZ    CRIOSCOP. (%).CRIO. TEMPERAT. DENSIDADE GORDURA  ESD        EST       PROTEINA  LACTOSE   EST.ALCOOL  REDUTASE    ANTIBIOTICO TIPO ANAL. PER.HIDROGENIO  FORMOL    
		                                                       HIPOCLORITO  HID.SODIO   BICARBONATO   CLORETOS   SACAROSE   AMIDO    BORATOS   ANALISTA                     OBSERVACOES                                                 
		*/  
		
		If cCODVAZ != (cAliasTMP)->ZLH_CODVAZ .and. cCODVAZ != STRING_NULL
			
			fImpMedia(@nZLH_ACI,@nZLH_CRI,@nZLH_PCR,@nZLH_TEM,@nZLH_DEN,@nZLH_GOR,@nZLH_ESD,@nZLH_EST,@nZLH_PRO,@nZLH_LAC,@nZLH_ALI,@nZLH_RED,;
			@nQZLH_ACI,@nQZLH_CRI,@nQZLH_PCR,@nQZLH_TEM,@nQZLH_DEN,@nQZLH_GOR,@nQZLH_ESD,@nQZLH_EST,@nQZLH_PRO,@nQZLH_LAC,@nQZLH_ALI,@nQZLH_RED,@nLin)	
		
		EndIf
		 
		
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf

		cCODLIN := (cAliasTMP)->ZLH_LINHA
		cCODVAZ := (cAliasTMP)->ZLH_CODVAZ
		cDATANA := (cAliasTMP)->ZLH_DATA

		
		@nLin,000 PSAY dtoc(stod((cAliasTMP)->ZLH_DATA))
		@nLin,011 PSAY (cAliasTMP)->ZLH_TANQUE
		@nLin,019 PSAY (cAliasTMP)->ZLH_SEQENT
		@nLin,023 PSAY SUBSTR(ALLTRIM((cAliasTMP)->ZLH_LINHA)+"/"+(cAliasTMP)->ZL7_NOMLIN,1,24)

		@nLin,051 PSAY TRANSFORM((cAliasTMP)->ZLH_ACID 		,  "@E 999")
		@nLin,061 PSAY TRANSFORM((cAliasTMP)->ZLH_CRIO 		,  "@E 999999")
		@nLin,071 PSAY TRANSFORM((cAliasTMP)->ZLH_PCRIO		,  "@E 99.99")
		@nLin,081 PSAY TRANSFORM((cAliasTMP)->ZLH_TEMPER	,  "@E 999999")		
		@nLin,091 PSAY TRANSFORM((cAliasTMP)->ZLH_DENS		,  "@E 9,999.99")
		@nLin,101 PSAY TRANSFORM((cAliasTMP)->ZLH_GORD 		,  "@E 999.99")		
		@nLin,111 PSAY TRANSFORM((cAliasTMP)->ZLH_ESD 		,  "@E 999.99")
		@nLin,121 PSAY TRANSFORM((cAliasTMP)->ZLH_EST 		,  "@E 999.99")
		@nLin,131 PSAY TRANSFORM((cAliasTMP)->ZLH_PROT 		,  "@E 999.99")		
		@nLin,141 PSAY TRANSFORM((cAliasTMP)->ZLH_LACTOS	,  "@E 999.99")		
		@nLin,151 PSAY TRANSFORM((cAliasTMP)->ZLH_ALIZ 		,  "@E 999.99")
		@nLin,163 PSAY TRANSFORM((cAliasTMP)->ZLH_REDUTA	,  "@E 999.99")
		@nLin,175 PSAY IIF((cAliasTMP)->ZLH_ANTIBI=="P","POS.",IIF((cAliasTMP)->ZLH_ANTIBI=="N","NEG."," "))
		@nLin,187 PSAY IIF((cAliasTMP)->ZLH_TAANT=="B","BETALAC.",IIF((cAliasTMP)->ZLH_TAANT=="T","TETRAC.","AMBOS"))
		@nLin,198 PSAY IIF((cAliasTMP)->ZLH_PERHID=="P","POS.",IIF((cAliasTMP)->ZLH_PERHID=="N","NEG."," "))
		@nLin,214 PSAY IIF((cAliasTMP)->ZLH_FORMOL=="P","POS.",IIF((cAliasTMP)->ZLH_FORMOL=="N","NEG."," "))
		
		nLin += 1
		@nLin,051 PSAY IIF((cAliasTMP)->ZLH_HIPCLO=="P","POS.",IIF((cAliasTMP)->ZLH_HIPCLO=="N","NEG."," "))
		@nLin,064 PSAY IIF((cAliasTMP)->ZLH_HIDSOD=="P","POS.",IIF((cAliasTMP)->ZLH_HIDSOD=="N","NEG."," "))
		@nLin,076 PSAY IIF((cAliasTMP)->ZLH_BICARB=="P","POS.",IIF((cAliasTMP)->ZLH_BICARB=="N","NEG."," "))
		@nLin,090 PSAY IIF((cAliasTMP)->ZLH_CLORET=="P","POS.",IIF((cAliasTMP)->ZLH_CLORET=="N","NEG."," "))
		@nLin,101 PSAY IIF((cAliasTMP)->ZLH_SACARO=="P","POS.",IIF((cAliasTMP)->ZLH_SACARO=="N","NEG."," "))
		@nLin,112 PSAY IIF((cAliasTMP)->ZLH_AMIDO =="P","POS.",IIF((cAliasTMP)->ZLH_AMIDO =="N","NEG."," "))
		@nLin,121 PSAY IIF((cAliasTMP)->ZLH_BORATO=="P","POS.",IIF((cAliasTMP)->ZLH_BORATO=="N","NEG."," "))
		@nLin,130 PSAY SubSTR((cAliasTMP)->ZLH_ANALIS,1,28)
		@nLin,160 PSAY SubSTR((cAliasTMP)->ZLH_OBS,1,28)
						
		If (cAliasTMP)->ZLH_ACID != 0
			nZLH_ACI	+= (cAliasTMP)->ZLH_ACID
			nQZLH_ACI   += 1
		EndIf
		If (cAliasTMP)->ZLH_CRIO != 0
			nZLH_CRI   += (cAliasTMP)->ZLH_CRIO
			nQZLH_CRI  += 1
		EndIf                                
		If (cAliasTMP)->ZLH_PCRIO != 0
			nZLH_PCR 	+= (cAliasTMP)->ZLH_PCRIO
			nQZLH_PCR 	+= 1
		EndIf                                      
		If Val((cAliasTMP)->ZLH_TEMPER) != 0
			nZLH_TEM 	+= Val((cAliasTMP)->ZLH_TEMPER)
			nQZLH_TEM	+= 1
		EndIf                               
		If (cAliasTMP)->ZLH_DENS != 0
			nZLH_DEN 	+= (cAliasTMP)->ZLH_DENS
			nQZLH_DEN 	+= 1
		EndIf                               
		If (cAliasTMP)->ZLH_GORD != 0
			nZLH_GOR 	+= (cAliasTMP)->ZLH_GORD
			nQZLH_GOR 	+= 1
		EndIf
		If (cAliasTMP)->ZLH_ESD != 0
			nZLH_ESD 	+= (cAliasTMP)->ZLH_ESD
			nQZLH_ESD 	+= 1
		EndIf                              
		If (cAliasTMP)->ZLH_EST != 0
			nZLH_EST 	+= (cAliasTMP)->ZLH_EST
			nQZLH_EST 	+= 1
		EndIf                               
		If (cAliasTMP)->ZLH_PROT != 0
			nZLH_PRO 	+= (cAliasTMP)->ZLH_PROT
			nQZLH_PRO 	+= 1
		EndIf                                 
		If (cAliasTMP)->ZLH_LACTOS != 0
			nZLH_LAC	+= (cAliasTMP)->ZLH_LACTOS
			nQZLH_LAC	+= 1
		EndIf                               
		If (cAliasTMP)->ZLH_ALIZ != 0
			nZLH_ALI 	+= (cAliasTMP)->ZLH_ALIZ
			nQZLH_ALI 	+= 1
		EndIf                                 

		If (cAliasTMP)->ZLH_REDUTA != 0
			nZLH_RED 	+= (cAliasTMP)->ZLH_REDUTA
			nQZLH_RED	+= 1
		EndIf


		nLin += 1

		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())
                                 
	If cCODVAZ != STRING_NULL
		
		fImpMedia(@nZLH_ACI,@nZLH_CRI,@nZLH_PCR,@nZLH_TEM,@nZLH_DEN,@nZLH_GOR,@nZLH_ESD,@nZLH_EST,@nZLH_PRO,@nZLH_LAC,@nZLH_ALI,@nZLH_RED,;
		@nQZLH_ACI,@nQZLH_CRI,@nQZLH_PCR,@nQZLH_TEM,@nQZLH_DEN,@nQZLH_GOR,@nQZLH_ESD,@nQZLH_EST,@nQZLH_PRO,@nQZLH_LAC,@nQZLH_ALI,@nQZLH_RED,@nLin)	

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
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfImpMEDIA   บAutor  ณRafael Parma      บ Data ณ  27/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de m้dias.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*---------------------------------------------------------------------------------------------------------------------------------------* 
Static Function fImpMEDIA( nZLH_ACI,nZLH_CRI,nZLH_PCR,nZLH_TEM,nZLH_DEN,nZLH_GOR,nZLH_ESD,nZLH_EST,nZLH_PRO,nZLH_LAC,nZLH_ALI,nZLH_RED,;
		nQZLH_ACI,nQZLH_CRI,nQZLH_PCR,nQZLH_TEM,nQZLH_DEN,nQZLH_GOR,nQZLH_ESD,nQZLH_EST,nQZLH_PRO,nQZLH_LAC,nQZLH_ALI,nQZLH_RED,nLin )    
*---------------------------------------------------------------------------------------------------------------------------------------* 		

	
	@nLin,000 PSAY "MษDIA DAS ANALISES: "
	@nLin,051 PSAY TRANSFORM((nZLH_ACI/nQZLH_ACI)  	,  "@E 999")
	@nLin,061 PSAY TRANSFORM((nZLH_CRI/nQZLH_CRI)  	,  "@E 999999")
	@nLin,071 PSAY TRANSFORM((nZLH_PCR/nQZLH_PCR)	,  "@E 99.99")
	@nLin,081 PSAY TRANSFORM((nZLH_TEM/nQZLH_TEM)	,  "@E 999999")		
	@nLin,091 PSAY TRANSFORM((nZLH_DEN/nQZLH_DEN)	,  "@E 9,999.99")
	@nLin,101 PSAY TRANSFORM((nZLH_GOR/nQZLH_GOR)  	,  "@E 999.99")		
	@nLin,111 PSAY TRANSFORM((nZLH_ESD/nQZLH_ESD)  	,  "@E 999.99")
	@nLin,121 PSAY TRANSFORM((nZLH_EST/nQZLH_EST)  	,  "@E 999.99")
	@nLin,131 PSAY TRANSFORM((nZLH_PRO/nQZLH_PRO)  	,  "@E 999.99")		
	@nLin,141 PSAY TRANSFORM((nZLH_LAC/nQZLH_LAC) 	,  "@E 999.99")		
	@nLin,151 PSAY TRANSFORM((nZLH_ALI/nQZLH_ALI) 	,  "@E 999.99")
				
	nZLH_ACI	:= 0
	nZLH_CRI	:= 0
	nZLH_PCR 	:= 0
	nZLH_TEM	:= 0
	nZLH_DEN 	:= 0
	nZLH_GOR 	:= 0
	nZLH_ESD 	:= 0
	nZLH_EST 	:= 0
	nZLH_PRO 	:= 0
	nZLH_LAC	:= 0
	nZLH_ALI 	:= 0
	nZLH_RED	:= 0	
	nQZLH_ACI	:= 0				
	nQZLH_CRI   := 0
	nQZLH_PCR 	:= 0
	nQZLH_TEM   := 0
	nQZLH_DEN 	:= 0
	nQZLH_GOR 	:= 0
	nQZLH_ESD 	:= 0
	nQZLH_EST 	:= 0
	nQZLH_PRO 	:= 0
	nQZLH_LAC	:= 0
	nQZLH_ALI 	:= 0
	nQZLH_RED   := 0
	
	nLin += 2
	
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
aRegs   := {} ; aHelp01 := {} ; aHelp02 := {} ; aHelp03 := {}  
aHelp04 := {} ; aHelp05 := {} ; aHelp06 := {} ; aHelp07 := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Data Anแlise De    ?","Data Anแlise De    ?","Data Anแlise De    ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02101."})
	aAdd(aRegs,{cPerg,"02","Data Anแlise At้   ?","Data Anแlise At้   ?","Data Anแlise At้   ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02102."})	
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL02103."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL02104."})
	aAdd(aRegs,{cPerg,"05","Transportador De   ?","Transportador De   ?","Transportador De   ?","mv_ch5","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02105."})
	aAdd(aRegs,{cPerg,"06","Transportador At้  ?","Transportador At้  ?","Transportador At้  ?","mv_ch6","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02106."})
	aAdd(aRegs,{cPerg,"07","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","mv_ch7","N",01,0,1,"C","","mv_par07","Linha","Linha","Linha","","","Data Anแlise","Data Anแlise","Data Anแlise","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02107."})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe a data inicial de anแlise.        " )       
	AADD( aHelp02, "Informe a data final de anแlise.          " )       
	AADD( aHelp03, "Informe o c๓digo inicial da linha coleta. " )       
	AADD( aHelp04, "Informe o c๓digo final da linha de coleta." )       
	AADD( aHelp05, "Informe o c๓digo inicial do transportador." )       
	AADD( aHelp06, "Informe o c๓digo final do transportador.  " )       
	AADD( aHelp07, "Informe se deseje saltar pagina por       " )       
	AADD( aHelp07, "produtor ou linha de coleta.              " )  
		
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
	PutSX1Help("P.LTREL02101.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL02102.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL02103.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL02104.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL02105.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL02106.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL02107.",aHelp07,aHelp07,aHelp07)

					
Return Nil