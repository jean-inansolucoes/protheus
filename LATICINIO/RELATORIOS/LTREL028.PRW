#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL028 บAutor  ณTOTVS CASCAVEL       บ Data ณ  13/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de coletas de leite.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*---------------------------------------------------------------------------*
User Function LTREL028()
*---------------------------------------------------------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "RELAวรO DE COLETAS DE LEITE"
Private cPict        := ""
Private titulo       := "RELAวรO DE COLETAS DE LEITE"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := "" 
Private imprime      := .T.
Private aOrd         := {"C๓digo Produtor","Nome Produtor"}         
Private cPerg        := "LTREL028X1"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "LTREL028"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private nOrdem       := 1
Private cbtxt        := Space(10)
Private cbcont       := 00
Private m_pag        := 01
Private wnrel        := "LTREL028"
Private cString 	 := "ZL5"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
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
	
	nTipo  := If(aReturn[4]==1,15,18)
	nOrdem := aReturn[8]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RptStatus({|| ReportPrd() },Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL028 บAutor  ณTOTVS CASCAVEL       บ Data ณ  13/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de coletas de leite.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*---------------------------------------------------------------------------*
Static Function ReportPrd()          
*---------------------------------------------------------------------------*
Local cAliasTMP	:= GetNextAlias()
Local hEnter	:= CHR(10) + CHR(13) 
Local cLINIMP	:= ""
Local cDATIMP	:= ""
Local cIDDISP	:= ""
Local nTOTIMP	:= 0
Local nQTDIMP	:= 0

	cQuery := "SELECT 	ZL5.ZL5_LINHA,  											" + hEnter    
	cQuery += "			ZL5.ZL5_DATA,												" + hEnter
	cQuery += "			ZL5.ZL5_TRANSP, 											" + hEnter
	cQuery += "			ZL5.ZL5_NOMTRP, 											" + hEnter	
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
	cQuery += "			SA2.A2_NOME,   												" + hEnter
	cQuery += "			ZL6.ZL6_AMOSTR,												" + hEnter
	cQuery += "			ZL6.ZL6_TANQUE,												" + hEnter
	cQuery += "			ZL6.ZL6_TEMPER,												" + hEnter
	cQuery += "			ZL6.ZL6_HORCOL,												" + hEnter
	cQuery += "			ZL6.ZL6_QTDE,												" + hEnter
	cQuery += "			ZL6.ZL6_IDDISP,												" + hEnter 
	cQuery += "			ZL6.ZL6_DTCOL,												" + hEnter
	cQuery += "			ZL6.ZL6_PLACA												" + hEnter
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" + hEnter
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          " + hEnter		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             " + hEnter		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" + hEnter
	cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	" + hEnter		
	cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	" + hEnter		
	cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "' 				" + hEnter
	cQuery += "AND		ZL5.ZL5_DATA	BETWEEN	'" + DTOS(mv_par01) + "' 			" + hEnter
	cQuery += "AND								'" + DTOS(mv_par02) + "'			" + hEnter
	cQuery += "AND		ZL5.ZL5_LINHA	BETWEEN	'" + mv_par03 + "'					" + hEnter
	cQuery += "AND								'" + mv_par04 + "'					" + hEnter
	cQuery += "AND		ZL6.ZL6_PRODUT	BETWEEN	'" + mv_par05 + "' 					" + hEnter
	cQuery += "AND								'" + mv_par06 + "' 					" + hEnter
	cQuery += "AND		ZL6.ZL6_LOJPRD	BETWEEN	'" + mv_par07 + "' 					" + hEnter
	cQuery += "AND								'" + mv_par08 + "'					" + hEnter
	cQuery += "AND 		ZL6.ZL6_QTDE           > 0 									" + hEnter
	cQuery += "AND 		ZL5.D_E_L_E_T_        != '*' 								" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_        != '*' 								" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_        != '*' 								" + hEnter
	cQuery += "ORDER BY	ZL5.ZL5_DATA,   											" + hEnter    
	cQuery += "			ZL5.ZL5_LINHA,												" + hEnter
	If nOrdem == 1
		If mv_par09 == 2
			cQuery += "	ZL6.ZL6_IDDISP,												" + hEnter
		EndIf
		//cQuery += "		ZL6.ZL6_PRODUT,												" + hEnter
		//cQuery += "		ZL6.ZL6_LOJPRD												" + hEnter
		cQuery += "		ZL6.ZL6_HORCOL												" + hEnter
	Else                                                                                      
		If mv_par09 == 2
			cQuery += "	ZL6.ZL6_IDDISP,												" + hEnter
		EndIf
		cQuery += "		SA2.A2_NOME   												" + hEnter
	EndIf
                        
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
 	While (cAliasTMP)->(!EOF())

		lIMPCAB := .F.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Imprime totalizadores                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		
		If 	( cLINIMP != "" .and. cLINIMP != (cAliasTMP)->ZL5_LINHA ) .or. ( cDATIMP != "" .and. cDATIMP != (cAliasTMP)->ZL5_DATA ) .or. ;
			( cIDDISP != "" .and. cIDDISP != (cAliasTMP)->ZL6_IDDISP .and. mv_par09 == 2 )
			
			@nLin,000 PSAY "TOTAL DE PRODUTORES: " + cValToChar(nQTDIMP)
			@nLin,111 PSAY TRANSFORM ( nTOTIMP, "@E 999,999,999,999" )
		
			nTOTIMP	:= 0
			nQTDIMP := 0
			lIMPCAB := .T.
			
		EndIf


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Imprime cabe็alho                                                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If nLin > 60 .OR. lIMPCAB             
		
			Cabec1 := "DATA: "+DTOC(STOD((cAliasTMP)->ZL5_DATA))
			Cabec1 += " - LINHA: "+ALLTRIM((cAliasTMP)->ZL5_LINHA)+"-"+ALLTRIM(POSICIONE("ZL0",1,XFILIAL("ZL0")+(cAliasTMP)->ZL5_LINHA,"ZL0_DESC"))
			Cabec2 := "TRANSPORTADOR: "+(cAliasTMP)->ZL5_TRANSP+"-"+ALLTRIM((cAliasTMP)->ZL5_NOMTRP) 
			If mv_par09 == 2
				Cabec2 += " - DISPOSITIVO: "+(cAliasTMP)->ZL6_IDDISP+" - PLACA: "+(cAliasTMP)->ZL6_PLACA
			EndIf			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			nLin := 9                                          
		//  @nLin,000 PSAY "PRODUTOR                                                      NR.AMOSTRA        TANQUE  TEMPERATURA     HORA        QUANTIDADE"
			@nLin,000 PSAY "PRODUTOR                                                      NR.AMOSTRA    TANQUE     TEMP    AIZAROL   HORA      QUANTIDADE"
			nLin += 1
			@nLin,000 PSAY __PrtThinLine() 
			nLin += 1
		
		EndIf		

			/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3  
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12
            -------------------------------------------------------------------------------------------------------------------------------------
		    PRODUTOR                                                      NR.AMOSTRA    TANQUE    TEMP     AIZAROL   HORA      QUANTIDADE           

			*/  

		@nLin,000 PSAY SubSTR((cAliasTMP)->ZL6_PRODUT+"/"+(cAliasTMP)->ZL6_LOJPRD+"-"+(cAliasTMP)->A2_NOME,1,60)
		@nLin,064 PSAY (cAliasTMP)->ZL6_AMOSTR 
		@nLin,078 PSAY (cAliasTMP)->ZL6_TANQUE
		@nLin,086 PSAY TRANSFORM ( (cAliasTMP)->ZL6_TEMPER, "@E 999.99"	)
		@nLin,099 PSAY ( "NG"	)
		@nLin,106 PSAY TRANSFORM ( (cAliasTMP)->ZL6_HORCOL, "@R 99:99"	)
		@nLin,111 PSAY TRANSFORM ( (cAliasTMP)->ZL6_QTDE,	"@E 999,999,999,999" )
		nLin += 1

		cLINIMP	:= (cAliasTMP)->ZL5_LINHA
		cDATIMP	:= (cAliasTMP)->ZL5_DATA
		cIDDISP := (cAliasTMP)->ZL6_IDDISP
		nTOTIMP += (cAliasTMP)->ZL6_QTDE
		nQTDIMP += 1
		
	    (cAliasTMP)->(dbSkip())	   		
	Enddo
	(cAliasTMP)->(dbCloseArea())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Imprime totalizadores                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	

    If nTOTIMP > 0
		@nLin,000 PSAY "TOTAL DE PRODUTORES: " + cValToChar(nQTDIMP)
		@nLin,111 PSAY TRANSFORM ( nTOTIMP, "@E 999,999,999,999" )
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
ฑฑบPrograma  ณLTREL028 บAutor  ณTOTVS CASCAVEL       บ Data ณ  13/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*        
Static Function AjustaSX1()
*---------------------------------------------------------------------------*        
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Data De            ?","Data De            ?","Data De            ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","Data At้           ?","Data At้           ?","Data At้           ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",""})
	aAdd(aRegs,{cPerg,"06","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",""})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"08","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","Separa equipamento ?","Separa equipamento ?","Separa equipamento ?","mv_ch9","N",01,0,1,"C","","mv_par09","Nใo","Nใo","Nใo","","","Sim","Sim","Sim","","","","","","","","","","","","","","","","","","","","","", "","","",""})	

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
	Next i 
				
Return
