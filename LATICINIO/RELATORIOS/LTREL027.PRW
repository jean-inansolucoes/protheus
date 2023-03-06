#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL027 บAutor  ณRafael Parma         บ Data ณ  18/12/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo das anแlises de coletas a campo.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL027()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELAวรO DE ANมLISES COLETAS A CAMPO"
Local cPict          := ""
Local titulo         := "ANมLISE DE COLETAS A CAMPO - MODELO 02"
Local nLin           := 80
Local Cabec1         := "DATA ANมLISE  NUMERO      PRODUTOR                                  QTD.LEITE       ACIDEZ    CRIOSCOPIA  (%)CRIO.  GORDURA   DENSIDADE   ESD   REDUTASE  PROTEINA  ANTIBIOTICO  DESCONTO  ANALISTA"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00010"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL010"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL010"
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
ฑฑบDesc.     ณRotina de impressใo das anแlises normantiva 51.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
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
Local cCODLIN     := STRING_Null
Local cCODPRD     := STRING_Null
Local cDATANL     := STRING_Null
Local hEnter	  := CHR(10) + CHR(13) 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
                                        

	//-- Recupera limites dos parametros
	If mv_par12 == 1 
	
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
		 
	EndIf

	//-- Filtro dos dados
	cQuery := "SELECT 														" + hEnter
	cQuery += "     	ZLA.ZLA_NUMERO,										" + hEnter
	cQuery += "     	ZLA.ZLA_DATA,										" + hEnter
	cQuery += "         ZLA.ZLA_PRODUT,										" + hEnter
	cQuery += "         ZLA.ZLA_LOJPRD,										" + hEnter
	cQuery += "         ZLA.ZLA_NOMPRD,										" + hEnter
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
	cQuery += "         ZLA.ZLA_HIPOCL,										" + hEnter	 
	cQuery += "         ZLA.ZLA_ANTIBI,										" + hEnter	 
	cQuery += "         ZLA.ZLA_TAANT,										" + hEnter	 
	cQuery += "         ZLA.ZLA_ANALIS,										" + hEnter	 
	cQuery += "         ZL0.ZL0_COD 										" + hEnter
	cQuery += "FROM " + RetSqlName("ZLA") + " ZLA							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL1") + " ZL1         			" + hEnter
	cQuery += "ON       ZLA.ZLA_FILIAL    = ZL1.ZL1_FILIAL      			" + hEnter		
	cQuery += "AND      ZLA.ZLA_PRODUT    = ZL1.ZL1_PRODUT      			" + hEnter	
	cQuery += "AND      ZLA.ZLA_LOJPRD    = ZL1.ZL1_LOJPRD      			" + hEnter	
	cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0         			" + hEnter
	cQuery += "ON       ZL1.ZL1_FILIAL    = ZL0.ZL0_FILIAL      			" + hEnter		
	cQuery += "AND      ZL1.ZL1_COD       = ZL0.ZL0_COD		      			" + hEnter	
	cQuery += "WHERE    ZLA.ZLA_FILIAL = '" + xFilial("ZLA") + "' 			" + hEnter
	If mv_par09 == 1
		cQuery += "AND 		( ZLA.ZLA_PRODUT BETWEEN '" + mv_par03 + "' 	" + hEnter
		cQuery += "AND                 		         '" + mv_par04 + "' )	" + hEnter	
		cQuery += "AND 		( ZLA.ZLA_LOJPRD BETWEEN '" + mv_par05 + "' 	" + hEnter
		cQuery += "AND                 		         '" + mv_par06 + "' )	" + hEnter	
	Else
		cQuery += "AND 		( ZL0.ZL0_COD    BETWEEN '" + mv_par07 + "' 	" + hEnter
		cQuery += "AND                 		         '" + mv_par08 + "' )	" + hEnter	
	EndIf
	cQuery += "AND 		( ZLA.ZLA_DATA   BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZLA.D_E_L_E_T_    != '*' 							" + hEnter
 	If mv_par10 == 1 .and. mv_par11 == 1
		cQuery += "ORDER BY ZLA.ZLA_NOMPRD									" + hEnter
	ElseIf mv_par10 == 1 .and. mv_par11 == 2
		cQuery += "ORDER BY ZL0.ZL0_COD, ZLA.ZLA_NOMPRD						" + hEnter	
	ElseIf mv_par10 == 1 .and. mv_par11 == 3
		cQuery += "ORDER BY ZLA.ZLA_DATA, ZLA.ZLA_NOMPRD					" + hEnter	
	ElseIf mv_par10 == 2 .and. mv_par11 == 1
		cQuery += "ORDER BY ZLA.ZLA_DATA, ZLA.ZLA_NOMPRD					" + hEnter	
	ElseIf mv_par10 == 2 .and. mv_par11 == 2
		cQuery += "ORDER BY ZLA.ZLA_DATA, ZL0.ZL0_COD, ZLA.ZLA_NOMPRD		" + hEnter	
	ElseIf mv_par10 == 2 .and. mv_par11 == 3
		cQuery += "ORDER BY ZLA.ZLA_DATA, ZLA.ZLA_NUMERO, ZLA.ZLA_NOMPRD	" + hEnter	
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


		If mv_par11 == 1 .and. cCODPRD != ( (cAliasTMP)->ZLA_PRODUT + (cAliasTMP)->ZLA_LOJPRD )
			If nLin != 80 .and. mv_par12 == 1
				fImpLIMITE(@nLin)
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		ElseIf mv_par11 == 2 .and. cCODLIN != (cAliasTMP)->ZL0_COD
			If nLin != 80 .and. mv_par12 == 1
				fImpLIMITE(@nLin)
			EndIf
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
        ElseIf mv_par11 == 3 .and. cDATANL != (cAliasTMP)->ZLA_DATA  
			If nLin != 80 .and. mv_par12 == 1
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
		    DATA ANมLISE  NUMERO      PRODUTOR                                  QTD.LEITE       ACIDEZ    CRIOSCOPIA  (%)CRIO.  GORDURA   DENSIDADE   ESD   REDUTASE  PROTEINA  ANTIBIOTICO  DESCONTO  ANALISTA

		*/  
		
		@nLin,000 PSAY dtoc(stod((cAliasTMP)->ZLA_DATA))
		@nLin,014 PSAY (cAliasTMP)->ZLA_NUMERO
		@nLin,026 PSAY (cAliasTMP)->ZLA_PRODUT+"/"+(cAliasTMP)->ZLA_LOJPRD+"-"+SubSTR((cAliasTMP)->ZLA_NOMPRD,1,28)

		@nLin,068 PSAY TRANSFORM((cAliasTMP)->ZLA_QTDE 		,  "@E 999999")
		@nLin,085 PSAY TRANSFORM((cAliasTMP)->ZLA_ACID		,  "@E 999")
		@nLin,095 PSAY TRANSFORM((cAliasTMP)->ZLA_CRIO 		,  "@E 999.999")
		@nLin,107 PSAY TRANSFORM((cAliasTMP)->ZLA_PERC 		,  "@E 999.9")		
		@nLin,116 PSAY TRANSFORM((cAliasTMP)->ZLA_GORD 		,  "@E 999.9")
		@nLin,124 PSAY TRANSFORM((cAliasTMP)->ZLA_DENS 		,  "@E 9,999.999")
		@nLin,135 PSAY TRANSFORM((cAliasTMP)->ZLA_ESD 		,  "@E 999.999")
		@nLin,145 PSAY TRANSFORM((cAliasTMP)->ZLA_REDUTA 	,  "@E 999.999")
		@nLin,153 PSAY TRANSFORM((cAliasTMP)->ZLA_PROT 		,  "@E 999.99")
		@nLin,167 PSAY IIF((cAliasTMP)->ZLA_ANTIBI=="P","POS.",IIF((cAliasTMP)->ZLA_ANTIBI=="N","NEG."," "))
		@nLin,179 PSAY TRANSFORM((((cAliasTMP)->ZLA_QTDE * (cAliasTMP)->ZLA_PERC)/100)		,  "@E 999")
		@nLin,187 PSAY SubSTR((cAliasTMP)->ZLA_ANALIS,1,20)
						
		nLin += 1
		
		cCODLIN := (cAliasTMP)->ZL0_COD
		cCODPRD := (cAliasTMP)->ZLA_PRODUT + (cAliasTMP)->ZLA_LOJPRD
		cDATANL := (cAliasTMP)->ZLA_DATA
 
		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())

	If nLin != 80 .and. mv_par12 == 1
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
	LIM. DE ANมLISES:  ACIDEZ MIN./MAX.: 99/99   CRIOSCOPIA MIN./MAX.: 99999/99999  GORDURA MIN.: 999  DENSIDADE MIN./MAX.: 9999/99999  ESD MIN.: 999  REDUTASE MIN.: 999   PROTEINA.: 999  CSS.: 300 MC/ML  CBT.: 300 MC/ML
	*/
	
	nLin+= 2
	@nLin,000 PSAY "LIM. DE ANมLISES: "
	@nLin,019 PSAY "ACIDEZ MIN./MAX.: " + cValToChar(nACD_MIN)+"/"+cValToChar(nACD_MAX)
	@nLin,045 PSAY "CRIOSCOPIA MIN./MAX.: " + cValToChar(nCRI_MIN)+"/"+cValToChar(nCRI_MAX)	
	@nLin,080 PSAY "GORDURA MIN.: " + cValToChar(nGORD_MIN)
	@nLin,098 PSAY "DENSIDADE MIN./MAX.: " + cValToChar(nDEN_MIN)+"/"+cValToChar(nDEN_MAX)	
	@nLin,133 PSAY "ESD MIN.: " + cValToChar(nESD_MIN)
	@nLin,148 PSAY "REDUTASE MIN.: " + cValToChar(nRED_MIN)	
	@nLin,168 PSAY "PROTEINA.: " + cValToChar(nPROT_MIN) 	
	@nLin,185 PSAY "CSS MC/ML.: " + cValToChar(nCCS_MAX)	
	@nLin,202 PSAY "CBT MC/ML.: " + cValToChar(nCBT_MAX)	
	
		
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
aHelp10 := {}
aHelp11 := {}
aHelp12 := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Perํodo De         ?","Perํodo De         ?","Perํodo De         ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01001."})
	aAdd(aRegs,{cPerg,"02","Perํodo At้        ?","Perํodo At้        ?","Perํodo At้        ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01002."})	
	aAdd(aRegs,{cPerg,"03","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch3","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01003."})
	aAdd(aRegs,{cPerg,"04","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch4","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL01004."})
	aAdd(aRegs,{cPerg,"05","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch5","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01005."})
	aAdd(aRegs,{cPerg,"06","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch6","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01006."})
	aAdd(aRegs,{cPerg,"07","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch7","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01007."})
	aAdd(aRegs,{cPerg,"08","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch8","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL01008."})
	aAdd(aRegs,{cPerg,"09","Filtrar Por        ?","Filtrar Por        ?","Filtrar Por        ?","mv_ch9","N",01,0,1,"C","","mv_par09","Produtor","Produtor","Produtor","","","Linha","Linha","Linha","","","","","","","","","","","","","","","","","","","","","","",".LTREL01009."})
	aAdd(aRegs,{cPerg,"10","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_cha","N",01,0,1,"C","","mv_par10","Produtor","Produtor","Produtor","","","Data Anแlise","Data Anแlise","Data Anแlise","","","","","","","","","","","","","","","","","","","","","","",".LTREL01010."})
	aAdd(aRegs,{cPerg,"11","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","mv_chb","N",01,0,1,"C","","mv_par11","Produtor","Produtor","Produtor","","","Linha","Linha","Linha","","","Data Anแlise","Data Anแlise","Data Anแlise","","","","","","","","","","","","","","","","", "","","",".LTREL01011."})
	aAdd(aRegs,{cPerg,"12","Imprimir Limites   ?","Imprimir Limites   ?","Imprimir Limites   ?","mv_chc","N",01,0,1,"C","","mv_par12","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL01012."})	
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
	AADD( aHelp10, "Informe qual o tipo ordenamento para     " )       
	AADD( aHelp10, "impressใo dos dados.                     " )  
	AADD( aHelp11, "Informe se deseje saltar pagina por      " )       
	AADD( aHelp11, "produtor, linha ou analises.             " )  
	AADD( aHelp12, "Imprimir limites minimo/maximo sobre     " )       
	AADD( aHelp12, "analises.                                " )  
	
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
	PutSX1Help("P.LTREL01001.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL01002.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL01003.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL01004.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL01005.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL01006.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL01007.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL01008.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL01009.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL01010.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL01011.",aHelp11,aHelp11,aHelp11)	
	PutSX1Help("P.LTREL01012.",aHelp12,aHelp12,aHelp12)
	
					
Return Nil