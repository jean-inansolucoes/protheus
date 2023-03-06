#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL015 บAutor  ณRafael Parma         บ Data ณ  28/01/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de movimentos conta corrente.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
  
*-----------------------*
User Function LTREL015()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "MOVIMENTOS CONTA CORRENTE"          
//Local cPict          := ""
Local titulo         := "MOVIMENTOS CONTA CORRENTE"          
Local nLin           := 80
Local Cabec1         := "MOVIMENTO  PARC.  DATA MOVTO    DATA VENCTO     PRODUTOR/TRANSP.                              HISTORICO                             TIPO                JUROS(%)      VALOR ORIGINAL(R$)      VALOR CORRIGIDO(R$)"
Local Cabec2         := ""
//Local imprime        := .T.
Local aOrd           := {"Data Movimento","Produtor/Transportador"}         
Private cPerg        := "LTREL00015"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL015"
Private nTipo        := 18
Private nOrdem       := 1
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL015"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZLB"
	AjustaSX1()                                                 
	Pergunte(cPerg, .F.) 

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	nOrdem := aReturn[8]	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RptStatus({|| Report(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณReport    บ Autor ณRafael Parma        บ Data ณ  28/01/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de movimentos conta corrente.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Report(Cabec1, Cabec2, Titulo, nLin)

Local cAliasTMP := GetNextAlias()
Local hEnter	:= CHR(10) + CHR(13) 
Local nTOTORDEM := 0
Local nTOTGERAL := 0
Local nTOTGCORR := 0
Local nTOTOCORR := 0

	cQuery := "SELECT 														" + hEnter
	cQuery += "         ZLB.ZLB_COD,	 									" + hEnter
	cQuery += "         ZLB.ZLB_PARCEL,	 									" + hEnter
	cQuery += "         ZLB.ZLB_FORNEC, 									" + hEnter
	cQuery += "         ZLB.ZLB_LOJFOR,										" + hEnter
	cQuery += "			ZLB.ZLB_TPDESP,    									" + hEnter
	cQuery += "			ZLB.ZLB_VALOR,										" + hEnter		
	cQuery += "			ZLB.ZLB_JUROS,										" + hEnter		
	cQuery += "			ZLB.ZLB_DTMOV,   									" + hEnter
	cQuery += "			ZLB.ZLB_DTVCTO,										" + hEnter
	cQuery += "			ZLB.ZLB_TIPCD,   									" + hEnter  
	cQuery += "			ZLB.ZLB_HIST, 										" + hEnter  
	cQuery += "			SA2.A2_NOME 										" + hEnter  
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2	ON					" + hEnter		
	cQuery += "			ZLB.ZLB_FORNEC = SA2.A2_COD						 	" + hEnter
	cQuery += "AND  	ZLB.ZLB_LOJFOR = SA2.A2_LOJA					 	" + hEnter	
	
	cQuery += "WHERE    ZLB.ZLB_FILIAL  = '" + xFilial("ZLB") + "' 			" + hEnter
	
	cQuery += "AND		ZLB.ZLB_DTMOV  BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND             		           '" + dtos(mv_par02) + "' 	" + hEnter	
	cQuery += "AND		ZLB.ZLB_DTVCTO BETWEEN '" + dtos(mv_par03) + "' 	" + hEnter
	cQuery += "AND             		           '" + dtos(mv_par04) + "' 	" + hEnter	

	cQuery += "AND		ZLB.ZLB_FORNEC BETWEEN '" + mv_par05 + "' 			" + hEnter
	cQuery += "AND             		           '" + mv_par06 + "' 			" + hEnter	
	cQuery += "AND		ZLB.ZLB_LOJFOR BETWEEN '" + mv_par07 + "' 			" + hEnter
	cQuery += "AND             		           '" + mv_par08 + "' 			" + hEnter	
	cQuery += "AND		SA2.A2_X_LINHA BETWEEN '" + mv_par09 + "' 			" + hEnter
	cQuery += "AND             		           '" + mv_par10 + "' 			" + hEnter	
	cQuery += "AND		ZLB.ZLB_TPDESP BETWEEN '" + mv_par12 + "' 			" + hEnter
	cQuery += "AND             		           '" + mv_par13 + "' 			" + hEnter	

	If mv_par11 == 1  //-- cr้bito
		cQuery += "AND	ZLB.ZLB_TIPCD = 'C'									" + hEnter  	
	Else  //-- d้bito						
		cQuery += "AND	ZLB.ZLB_TIPCD = 'D'									" + hEnter  	
	EndIf
	cQuery += "AND 		ZLB.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_    != '*' 							" + hEnter
 	
 	cQuery += "ORDER BY                 			 						" + hEnter		
	If nOrdem == 1
		cQuery += "         ZLB.ZLB_FORNEC, 								" + hEnter
		cQuery += "         ZLB.ZLB_LOJFOR 									" + hEnter	
    Else
		cQuery += "			ZLB.ZLB_DTMOV  									" + hEnter     	    	
    EndIf
	
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	MemoWrite("LTREL015.TXT",cQuery)

		/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		    MOVIMENTO  PARC.  DATA MOVTO    DATA VENCTO     PRODUTOR/TRANSP.                              HISTORICO                             TIPO                JUROS(%)      VALOR ORIGINAL(R$)      VALOR CORRIGIDO(R$)
		*/  	


	cCHAVORDEM := STRING_NULL
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
    While !(cAliasTMP)->(EOF())
            
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
		    nLin := 9                                                                               
		EndIf
        
        
        lImpTOTAL := .F.
        If nOrdem == 1
        	If cCHAVORDEM != (cAliasTMP)->ZLB_DTMOV .AND. cCHAVORDEM != STRING_NULL
        		lImpTOTAL := .T.
        	EndIf
        Else
        	If cCHAVORDEM != (cAliasTMP)->ZLB_FORNEC+(cAliasTMP)->ZLB_LOJFOR  .AND. cCHAVORDEM != STRING_NULL
        		lImpTOTAL := .T.
        	EndIf
        EndIf   
        
        If lImpTOTAL  			
			@nLin,000 PSAY "TOTAL "+IIF(nOrdem==1,"DATA MOVIMENTO: ","PRODUTOR/TRANSP.: ")
			@nLin,168 PSAY TRANSFORM(nTOTORDEM , "@E 9,999,999.99" )
			@nLin,194 PSAY TRANSFORM(nTOTGCORR , "@E 9,999,999.99" )
        	nTOTORDEM := 0                                          
        	nTOTGCORR := 0
        	nLin += 2
        EndIf

		cFORNECE  := ALLTRIM((cAliasTMP)->ZLB_FORNEC) + "/" + ALLTRIM((cAliasTMP)->ZLB_LOJFOR) + "-" + ALLTRIM((cAliasTMP)->A2_NOME)
		nTOTALCOR := (cAliasTMP)->ZLB_VALOR + ( ( (cAliasTMP)->ZLB_VALOR * (cAliasTMP)->ZLB_JUROS ) / 100 )
		
		@nLin,000 PSAY (cAliasTMP)->ZLB_COD
		@nLin,011 PSAY (cAliasTMP)->ZLB_PARCEL
		@nLin,018 PSAY dtoc(stod((cAliasTMP)->ZLB_DTMOV)) 
		@nLin,032 PSAY dtoc(stod((cAliasTMP)->ZLB_DTVCTO))                                       
		@nLin,048 PSAY SubSTR(cFORNECE,1,40)
		@nLin,094 PSAY SubSTR((cAliasTMP)->ZLB_HIST,1,26)
		@nLin,132 PSAY (cAliasTMP)->ZLB_TIPCD
		@nLin,152 PSAY TRANSFORM( (cAliasTMP)->ZLB_JUROS , "@E 999.99" )
		@nLin,168 PSAY TRANSFORM( (cAliasTMP)->ZLB_VALOR , "@E 9,999,999.99" )
		@nLin,194 PSAY TRANSFORM( nTOTALCOR				 , "@E 9,999,999.99" )		
		nLin += 1
        
        If nOrdem == 1
        	cCHAVORDEM := (cAliasTMP)->ZLB_DTMOV
        Else
        	cCHAVORDEM := (cAliasTMP)->ZLB_FORNEC+(cAliasTMP)->ZLB_LOJFOR
        EndIf
        
        If (cAliasTMP)->ZLB_TIPCD == "C"
        	nMULT := -1
        Else
        	nMULT := 1
        EndIf
    	
    	nTOTORDEM += ((cAliasTMP)->ZLB_VALOR * nMULT)
    	nTOTGERAL += ((cAliasTMP)->ZLB_VALOR * nMULT)
    	nTOTGCORR += nTOTALCOR
    	nTOTOCORR += nTOTALCOR 
    	
    	(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	If nTOTORDEM != 0
		@nLin,000 PSAY "TOTAL "+IIF(nOrdem==1,"DATA MOVIMENTO: ","PRODUTOR/TRANSP.: ")
		@nLin,168 PSAY TRANSFORM(nTOTORDEM , "@E 9,999,999.99" )
		@nLin,194 PSAY TRANSFORM(nTOTGCORR , "@E 9,999,999.99" )			
  		nLin += 2
		@nLin,000 PSAY "TOTAL GERAL: "
		@nLin,168 PSAY TRANSFORM(nTOTGERAL , "@E 9,999,999.99" )
		@nLin,194 PSAY TRANSFORM(nTOTGCORR , "@E 9,999,999.99" )
	EndIf
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se em disco, desvia para Spool                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
		Set Printer To
		Commit
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return
 
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  28/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()
Local i,j
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


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Data Movimento De  ?" ,"Data Movimento De  ?", "Data Movimento De  ?" ,"mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1501."})
	aAdd(aRegs,{cPerg,"02","Data Movimento At้ ?" ,"Data Movimento At้ ?", "Data Movimento At้ ?" ,"mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1502."})	
	aAdd(aRegs,{cPerg,"03","Data Vencimento De ?" ,"Data Vencimento De ?", "Data Vencimento De ?" ,"mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1503."})
	aAdd(aRegs,{cPerg,"04","Data Vencimento At้?" ,"Data Vencimento At้?", "Data Vencimento At้?" ,"mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1504."})	
	aAdd(aRegs,{cPerg,"05","Produtor/Transp.De ?" ,"Produtor/Transp.De ?", "Produtor/Transp.De ?" ,"mv_ch5","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",".LTREL1505."})
	aAdd(aRegs,{cPerg,"06","Produtor/Transp.At้?" ,"Produtor/Transp.At้?", "Produtor/Transp.At้?" ,"mv_ch6","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",".LTREL1506."})
	aAdd(aRegs,{cPerg,"07","Loja Prd/Transp.De ?" ,"Loja Prd/Transp.De ?", "Loja Prd/Transp.De ?" ,"mv_ch7","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1507."})
	aAdd(aRegs,{cPerg,"08","Loja Prd/Transp.At้?" ,"Loja Produtor At้  ?", "Loja Produtor At้  ?" ,"mv_ch8","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1508."})
	aAdd(aRegs,{cPerg,"09","Linha De           ?" ,"Linha De           ?", "Linha De           ?" ,"mv_ch9","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1509."})
	aAdd(aRegs,{cPerg,"10","Linha At้          ?" ,"Linha At้          ?", "Linha At้          ?" ,"mv_cha","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1510."})
	aAdd(aRegs,{cPerg,"11","Tipo Movimento     ?" ,"Tipo Movimento     ?", "Tipo Movimento     ?" ,"mv_chb","N",01,0,1,"C","","mv_par11","Cr้dito","Cr้dito","Cr้dito","","","D้bito","D้bito","D้bito","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","","","",".LTREL1511."})
	aAdd(aRegs,{cPerg,"12","Motivo Movimento De?" ,"Motivo Movimento De?", "Motivo Movimento De?" ,"mv_chc","C",TAMSX3("ZLB_TPDESP")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "LT","","",""})
	aAdd(aRegs,{cPerg,"13","Motivo Movimento At้?","Motivo Movimento At้?","Motivo Movimento At้?","mv_chd","C",TAMSX3("ZLB_TPDESP")[1],0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "LT","","",""})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe a data inicial de movimento      " )       
	AADD( aHelp01, "dos registros para filtro.               " )       
	AADD( aHelp02, "Informe a data final   de movimento      " )       
	AADD( aHelp02, "dos registros para filtro.               " )       
	AADD( aHelp03, "Informe a data inicial de vencimento     " )       
	AADD( aHelp03, "dos registros para filtro.               " )       
	AADD( aHelp04, "Informe a data final   de vencimento     " )       
	AADD( aHelp04, "dos registros para filtro.               " )       
	AADD( aHelp05, "Informe o c๓digo inicial do produtor/    " )       
	AADD( aHelp05, "transportador para filtro.               " )       
	AADD( aHelp06, "Informe o c๓digo final   do produtor/    " )       
	AADD( aHelp06, "transportador para filtro.               " )       
	AADD( aHelp07, "Informe o c๓digo inicial da loja do      " )       
	AADD( aHelp07, "produtor/transportador para filtro.      " )       
	AADD( aHelp08, "Informe o c๓digo final   da loja do      " )       
	AADD( aHelp08, "produtor/transportador para filtro.      " )       
	AADD( aHelp09, "Informe o n๚mero inicial da linha        " )       
	AADD( aHelp09, "para filtro.                             " )       
	AADD( aHelp10, "Informe o n๚mero final da linha          " )       
	AADD( aHelp10, "para filtro.                             " )       
	AADD( aHelp11, "Informe o tipo de movimento do registro  " )       
	AADD( aHelp11, "para filtro.                             " )       
	
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
	PutSX1Help("P.LTREL1501.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL1502.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL1503.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL1504.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL1505.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL1506.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL1507.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL1508.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTREL1509.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL1510.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL1511.",aHelp11,aHelp11,aHelp11)		

					
Return Nil
