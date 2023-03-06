#INCLUDE "TOPCONN.CH"                                             
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL026 บAutor  ณRafael Parma         บ Data ณ  22/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de produtores novos e ausentes.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL026()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "ACOMPANHAMENTO DE PRODUTORES"
Local cPict          := ""
Local titulo         := "ACOMPANHAMENTO DE PRODUTORES"
Local nLin           := 80
Local Cabec1         := "FILIAL    LINHA     CำDIGO    LOJA      PRODUTOR                                          QTDADE    STATUS"
Local Cabec2         := "" 
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00026"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "LTREL026"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL026"
Private aVetLin	     := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZL5"
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

	RptStatus({|| ReportPrd(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณReportPrd บ Autor ณRafael Parma        บ Data ณ  26/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo de pagamentos de produtores.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ReportPrd(Cabec1,Cabec2,Titulo,nLin)

Local cAliasTMP    := GetNextAlias()
Local dSTART_ATU   := ctod("")
Local dEND_ATU     := ctod("")
Local dSTART_ANT   := ctod("")
Local dEND_ANT     := ctod("")
Local aDADOSATU    := {}
Local aDADOSANT    := {}
Local aDADOSIMP    := {}
Local aDADOSTOT    := {}                                                                                                          

	dSTART_ATU  := ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do perํodo	
	If U_YIsBis(mv_par02) 
		dEND_ATU := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","29","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))
    Else
		dEND_ATU := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","28","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))   
    EndIf
    
    nMESANT := mv_par01 - 1
    nANOANT := mv_par02
    If nMESANT == 0
    	nMESANT := 12
    	nANOANT -= 1
    EndIf
    dSTART_ANT := ctod("01/"+StrZERO(nMESANT,2)+"/"+StrZERO(nANOANT,4))	// primeiro dia do perํodo anterior
	If U_YIsBis(nANOANT) 
		dEND_ANT := ctod(Iif(StrZero(nMESANT,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(nMESANT,2)=="02","29","30"))+"/"+StrZero(nMESANT,2)+"/"+StrZero(nANOANT,4))
    Else
		dEND_ANT := ctod(Iif(StrZero(nMESANT,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(nMESANT,2)=="02","28","30"))+"/"+StrZero(nMESANT,2)+"/"+StrZero(nANOANT,4))   
    EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de dados do mes ATUAL      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	    
	cQuery := "SELECT 	ZL5.ZL5_FILIAL, 											"      
	cQuery += "			ZL5.ZL5_LINHA,  											"      
	cQuery += "			ZL6.ZL6_PRODUT,												"  
	cQuery += "			ZL6.ZL6_LOJPRD,												"  
	cQuery += "			SA2.A2_NOME,												"  
	cQuery += "			SUM(ZL6.ZL6_QTDE) ZL6_QTDE									"  
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									"  
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							"  
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          "  		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             "  		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						"  
	cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	"  		
	cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	"  		
	cQuery += "WHERE    ZL5.ZL5_FILIAL	BETWEEN '" + mv_par15       	+ "' 		"  
	cQuery += "AND                 		    	'" + mv_par16       	+ "' 		"  		
	cQuery += "AND 		ZL5.ZL5_LINHA	BETWEEN '" + mv_par03       	+ "' 		"  
	cQuery += "AND                 		    	'" + mv_par04       	+ "' 		"  
	cQuery += "AND 		ZL6.ZL6_PRODUT 	BETWEEN '" + mv_par05       	+ "' 		"  
	cQuery += "AND                		    	'" + mv_par06       	+ "' 		"  
	cQuery += "AND 		ZL6.ZL6_LOJPRD 	BETWEEN '" + mv_par07   	    + "' 		"  
	cQuery += "AND                          	'" + mv_par08	        + "' 		"  
	cQuery += "AND 		ZL5.ZL5_DATA  	BETWEEN '" + DTOS(dSTART_ATU) 	+ "' 		"  
	cQuery += "AND                          	'" + DTOS(dEND_ATU)  	+ "' 		"  
	cQuery += "AND 		SA2.A2_COD_MUN	BETWEEN '" + mv_par09       	+ "' 		"  
	cQuery += "AND                          	'" + mv_par10       	+ "' 		"  
	cQuery += "AND 		SA2.A2_EST    	BETWEEN '" + mv_par11       	+ "' 		"  
	cQuery += "AND                          	'" + mv_par12       	+ "' 		"  
	cQuery += "AND 		SA2.A2_COND   	BETWEEN '" + mv_par13       	+ "' 		"  
	cQuery += "AND      	            		'" + mv_par14       	+ "' 		"  						
	cQuery += "AND ZL5.D_E_L_E_T_        != '*' 									"  
	cQuery += "AND ZL6.D_E_L_E_T_        != '*' 									"  
	cQuery += "AND SA2.D_E_L_E_T_        != '*' 									"  
	cQuery += "GROUP BY ZL5.ZL5_FILIAL, ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 				"  
	cQuery += "			ZL6.ZL6_LOJPRD, SA2.A2_NOME		 							"  
	cQuery += "ORDER BY ZL5.ZL5_FILIAL, ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 				"  
	cQuery += "			ZL6.ZL6_LOJPRD, SA2.A2_NOME		 							"  

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		If (cAliasTMP)->ZL6_QTDE
			aAdd ( aDADOSATU, { (cAliasTMP)->ZL5_FILIAL, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->A2_NOME, (cAliasTMP)->ZL6_QTDE } )
		EndIf
		(cAliasTMP)->(dbSkip())
	Enddo             
	(cAliasTMP)->(dbCloseArea())
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de dados do mes ANTERIOR   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	    
	cQuery := "SELECT 	ZL5.ZL5_FILIAL, 											"      
	cQuery += "			ZL5.ZL5_LINHA,  											"      
	cQuery += "			ZL6.ZL6_PRODUT,												"  
	cQuery += "			ZL6.ZL6_LOJPRD,												"  
	cQuery += "			SA2.A2_NOME,												"  
	cQuery += "			SUM(ZL6.ZL6_QTDE) ZL6_QTDE									"  
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									"  
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							"  
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          "  		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             "  		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						"  
	cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	"  		
	cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	"  		
	cQuery += "WHERE    ZL5.ZL5_FILIAL	BETWEEN '" + mv_par15       	+ "' 		"  
	cQuery += "AND                 		    	'" + mv_par16       	+ "' 		"  		
	cQuery += "AND 		ZL5.ZL5_LINHA	BETWEEN '" + mv_par03       	+ "' 		"  
	cQuery += "AND                 		    	'" + mv_par04       	+ "' 		"  
	cQuery += "AND 		ZL6.ZL6_PRODUT 	BETWEEN '" + mv_par05       	+ "' 		"  
	cQuery += "AND                		    	'" + mv_par06       	+ "' 		"  
	cQuery += "AND 		ZL6.ZL6_LOJPRD 	BETWEEN '" + mv_par07   	    + "' 		"  
	cQuery += "AND                          	'" + mv_par08	        + "' 		"  
	cQuery += "AND 		ZL5.ZL5_DATA  	BETWEEN '" + DTOS(dSTART_ANT) 	+ "' 		"  
	cQuery += "AND                          	'" + DTOS(dEND_ANT)  	+ "' 		"  
	cQuery += "AND 		SA2.A2_COD_MUN	BETWEEN '" + mv_par09       	+ "' 		"  
	cQuery += "AND                          	'" + mv_par10       	+ "' 		"  
	cQuery += "AND 		SA2.A2_EST    	BETWEEN '" + mv_par11       	+ "' 		"  
	cQuery += "AND                          	'" + mv_par12       	+ "' 		"  
	cQuery += "AND 		SA2.A2_COND   	BETWEEN '" + mv_par13       	+ "' 		"  
	cQuery += "AND      	            		'" + mv_par14       	+ "' 		"  						
	cQuery += "AND ZL5.D_E_L_E_T_        != '*' 									"  
	cQuery += "AND ZL6.D_E_L_E_T_        != '*' 									"  
	cQuery += "AND SA2.D_E_L_E_T_        != '*' 									"  
	cQuery += "GROUP BY ZL5.ZL5_FILIAL, ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 				"  
	cQuery += "			ZL6.ZL6_LOJPRD, SA2.A2_NOME		 							"  
	cQuery += "ORDER BY ZL5.ZL5_FILIAL, ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 				"  
	cQuery += "			ZL6.ZL6_LOJPRD, SA2.A2_NOME		 							"  

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		If (cAliasTMP)->ZL6_QTDE > 0
			aAdd ( aDADOSANT, { (cAliasTMP)->ZL5_FILIAL, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->A2_NOME, (cAliasTMP)->ZL6_QTDE } )
		EndIf
		(cAliasTMP)->(dbSkip())
	Enddo             
	(cAliasTMP)->(dbCloseArea())


	If Len(aDADOSATU) > 0 .and. Len(aDADOSANT) > 0
		//--Entregou neste m๊s mas nใo no m๊s passado
		For nI := 1 to Len(aDADOSATU)
			//--Compara็ใo = FILIAL + CODIGO + LOJA PRODUTOR
			lExiste := aScan (aDADOSANT, { |x| x[1] == aDADOSATU[nI,01] .and. x[3] == aDADOSATU[nI,03] .and. x[4] == aDADOSATU[nI,04] } ) != 0
			If !lExiste
				aAdd ( aDADOSIMP, { aDADOSATU[nI,01], "0", aDADOSATU[nI,02], aDADOSATU[nI,03], aDADOSATU[nI,04], aDADOSATU[nI,05], aDADOSATU[nI,06] } )
			EndIf			
		Next nI 
		
		//--Entregou no m๊s passado mas nใo neste m๊s
		For nI := 1 to Len(aDADOSANT)
			//--Compara็ใo = FILIAL + CODIGO + LOJA PRODUTOR
			lExiste := aScan (aDADOSATU, { |x| x[1] == aDADOSANT[nI,01] .and. x[3] == aDADOSANT[nI,03] .and. x[4] == aDADOSANT[nI,04] } ) != 0
			If !lExiste
				aAdd ( aDADOSIMP, { aDADOSANT[nI,01], "1", aDADOSANT[nI,02], aDADOSANT[nI,03], aDADOSANT[nI,04], aDADOSANT[nI,05], aDADOSANT[nI,06] } )
			EndIf			
		Next nI 		
	EndIf       
	
	aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6] < y[1]+y[2]+y[3]+y[4]+y[5]+y[6] } )
		
	If Len(aDADOSIMP) > 0
		
		cFILPRT := ""
		
		For nI := 1 to Len(aDADOSIMP)
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Verifica o cancelamento pelo usuario...                             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif  

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Salto de pแgina ...                                                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If nLin > 65  	
	        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
	  			nLin := 8
	        EndIf             
	        
	        If cFILPRT != aDADOSIMP[nI,01]
	        	If !Empty(cFILPRT)
                	aAdd ( aDADOSTOT, { cFILPRT, nPRDATU, nPRDANT, nQTDATU, nQTDANT } ) 
					@nLin,000 PSAY __PrtThinLine()
					nLin += 1
					@nLin,000 PSAY "NฺMERO PROD. NOVOS: "
					@nLin,030 PSAY TRANSFORM(nPRDATU, "@E 99999999")
					@nLin,050 PSAY "LITROS PROD. NOVOS: "
					@nLin,080 PSAY TRANSFORM(nQTDATU, "@E 99999999")
					nLin += 1
					@nLin,000 PSAY "NฺMERO QUE PARARAM: "
					@nLin,030 PSAY TRANSFORM(nPRDANT, "@E 99999999")
					@nLin,050 PSAY "LITROS QUE PARARAM: "
					@nLin,080 PSAY TRANSFORM(nQTDANT, "@E 99999999")
					nLin += 1
					@nLin,000 PSAY "SALDO DA FILIAL: "
					@nLin,030 PSAY TRANSFORM(nPRDATU-nPRDANT, "@E 99999999")
					@nLin,080 PSAY TRANSFORM(nQTDATU-nQTDANT, "@E 99999999")		                	
		        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
		  			nLin := 8
				EndIf
        		nPRDATU := 0
				nPRDANT := 0
        		nQTDATU := 0
				nQTDANT := 0
			EndIf
                                          
			/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3  
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12
            -------------------------------------------------------------------------------------------------------------------------------------
		    FILIAL    LINHA     CำDIGO    LOJA      PRODUTOR                                          QTDADE    STATUS
			*/  


			@nLin,000 PSAY aDADOSIMP[nI,01]
			@nLin,010 PSAY aDADOSIMP[nI,03]
			@nLin,020 PSAY aDADOSIMP[nI,04]			
			@nLin,030 PSAY aDADOSIMP[nI,05]
			@nLin,040 PSAY sUBstr(aDADOSIMP[nI,06],1,38)
			@nLin,090 PSAY TRANSFORM( aDADOSIMP[nI,07], "@E 99999999" )
			If aDADOSIMP[nI,02] == "0"
				@nLin,100 PSAY "PRODUTOR NOVO"
			Else
				@nLin,100 PSAY "DEIXOU DE ENTREGAR"
			EndIf   
			nLin += 1
			
			If aDADOSIMP[nI,02] == "0"
				nPRDATU += 1
				nQTDATU += aDADOSIMP[nI,07]
			Else
				nPRDANT += 1
				nQTDANT += aDADOSIMP[nI,07]
			EndIf
	        
      		cFILPRT := aDADOSIMP[nI,01]
		Next nI
		              
       	If !Empty(cFILPRT)
           	aAdd ( aDADOSTOT, { cFILPRT, nPRDATU, nPRDANT, nQTDATU, nQTDANT } )
			@nLin,000 PSAY __PrtThinLine()
			nLin += 1
			@nLin,000 PSAY "NฺMERO PROD. NOVOS: "
			@nLin,030 PSAY TRANSFORM(nPRDATU, "@E 99999999")
			@nLin,050 PSAY "LITROS PROD. NOVOS: "
			@nLin,080 PSAY TRANSFORM(nQTDATU, "@E 99999999")
			nLin += 1
			@nLin,000 PSAY "NฺMERO QUE PARARAM: "
			@nLin,030 PSAY TRANSFORM(nPRDANT, "@E 99999999")
			@nLin,050 PSAY "LITROS QUE PARARAM: "
			@nLin,080 PSAY TRANSFORM(nQTDANT, "@E 99999999")
			nLin += 1
			@nLin,000 PSAY "SALDO DA FILIAL: "
			@nLin,030 PSAY TRANSFORM(nPRDATU-nPRDANT, "@E 99999999")
			@nLin,080 PSAY TRANSFORM(nQTDATU-nQTDANT, "@E 99999999")		                	


			/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3  
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12
            -------------------------------------------------------------------------------------------------------------------------------------
			FILIAL    PROD. NOVOS         QUE PARARAM         SALDO PROD.         QTD LITROS NOVOS    QTD LITROS PARARAM  SALDO QTD LITROS
			*/  
        	
        	Cabec1 := "FILIAL    PROD. NOVOS         QUE PARARAM         SALDO PROD.         QTD LITROS NOVOS    QTD LITROS PARARAM  SALDO QTD LITROS"
        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
  			nLin := 8
			
			//--Resumo geral
			nTPRDATU := 0
			nTPRDANT := 0
			nTQTDATU := 0
			nTQTDANT := 0
			For nI := 1 to Len(aDADOSTOT)
				@nLin,000 PSAY aDADOSTOT[nI,01]
				@nLin,010 PSAY TRANSFORM(aDADOSTOT[nI,02], "@E 99999999")
				@nLin,030 PSAY TRANSFORM(aDADOSTOT[nI,03], "@E 99999999")
				@nLin,050 PSAY TRANSFORM(aDADOSTOT[nI,02]-aDADOSTOT[nI,03], "@E 99999999")
				@nLin,070 PSAY TRANSFORM(aDADOSTOT[nI,04], "@E 99999999")
				@nLin,090 PSAY TRANSFORM(aDADOSTOT[nI,05], "@E 99999999")
				@nLin,110 PSAY TRANSFORM(aDADOSTOT[nI,04]-aDADOSTOT[nI,05], "@E 99999999")
				nTPRDATU += aDADOSTOT[nI,02]
				nTPRDANT += aDADOSTOT[nI,03]
				nTQTDATU += aDADOSTOT[nI,04]
				nTQTDANT += aDADOSTOT[nI,05] 
				nLin += 1	
			Next nI
			@nLin,000 PSAY "SALDO GERAL"
			@nLin,050 PSAY TRANSFORM(nTPRDATU-nTPRDANT, "@E 99999999")
			@nLin,110 PSAY TRANSFORM(nTQTDATU-nTQTDANT, "@E 99999999")
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
	
	Endif
	     
Return
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  26/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas LTREL011.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1() 

aRegs  := {}
aHelp01 := {} ; aHelp02 := {} ; aHelp03 := {} ; aHelp04 := {}                                                   
aHelp05 := {} ; aHelp06 := {} ; aHelp07 := {} ; aHelp08 := {} 
aHelp09 := {} ; aHelp10 := {} ; aHelp11 := {} ; aHelp12 := {}
aHelp13 := {} ; aHelp14 := {} ; aHelp15 := {} ; aHelp16 := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","M๊s                ?","M๊s                ?","M๊s                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2601."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2602."})
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",".LTREL2603."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",".LTREL2604."})
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL2605."})
	aAdd(aRegs,{cPerg,"06","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL2606."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2607."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2608."})
	aAdd(aRegs,{cPerg,"09","Municํpio De       ?","Municํpio De       ?","Municํpio De       ?","mv_ch9","C",TAMSX3("A2_COD_MUN")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL2609."})
	aAdd(aRegs,{cPerg,"10","Municํpio At้      ?","Municํpio At้      ?","Municํpio At้      ?","mv_cha","C",TAMSX3("A2_COD_MUN")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "CC2","","",".LTREL2610."})
	aAdd(aRegs,{cPerg,"11","UF De              ?","UF De              ?","UF De              ?","mv_chb","C",TAMSX3("A2_EST")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2611."})
	aAdd(aRegs,{cPerg,"12","UF At้             ?","UF At้             ?","UF At้             ?","mv_chc","C",TAMSX3("A2_EST")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2612."})
	aAdd(aRegs,{cPerg,"13","Cond. Pagamento De ?","Cond. Pagamento De ?","Cond. Pagamento De ?","mv_chd","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL2613."})
	aAdd(aRegs,{cPerg,"14","Cond. Pagamento At้?","Cond. Pagamento At้?","Cond. Pagamento At้?","mv_che","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTREL2614."})
	aAdd(aRegs,{cPerg,"15","Filial De          ?","Filial De          ?","Filial De          ?","mv_chf","C",TAMSX3("E1_FILIAL")[1],0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2615."})
	aAdd(aRegs,{cPerg,"16","Filial At้         ?","Filial At้         ?","Filial At้         ?","mv_chg","C",TAMSX3("E1_FILIAL")[1],0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL2616."})

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
	AADD( aHelp13, "Informe a condi็ใo de pagamento inicial  " )       
	AADD( aHelp13, "a ser impresso.                          " )       
	AADD( aHelp14, "Informe a condi็ใo de pagamento final    " )       
	AADD( aHelp14, "a ser impresso.                          " )
	AADD( aHelp15, "Informe a filial inicial a ser impressa. " )       
	AADD( aHelp16, "Informe a filial final a ser impressa.   " )       
		
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
	PutSX1Help("P.LTREL2601.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL2602.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL2603.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL2604.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL2605.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL2606.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL2607.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL2608.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL2609.",aHelp09,aHelp09,aHelp09)	
	PutSX1Help("P.LTREL2610.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL2611.",aHelp11,aHelp11,aHelp11)	
	PutSX1Help("P.LTREL2612.",aHelp12,aHelp12,aHelp12)	
	PutSX1Help("P.LTREL2613.",aHelp13,aHelp13,aHelp13)	
	PutSX1Help("P.LTREL2614.",aHelp14,aHelp14,aHelp14)	
	PutSX1Help("P.LTREL2615.",aHelp15,aHelp15,aHelp15)	
	PutSX1Help("P.LTREL2616.",aHelp16,aHelp16,aHelp16)		
		
Return Nil