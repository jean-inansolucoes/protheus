#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLSFIN004 บAutor  ณAlexandre Longhinottiบ Data ณ  24/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de fechamento financeiro mensal dos funcionarios     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIOS SILVESTRE                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
User Function LSFIN004()                                                          
*---------------------------------------*
Private cPerg    	:= "LSFIN00004"
Private cTitulo  	:= "Fechamento financeiro de funiocnarios"
Private STRING_Null := "" 


Private oDlgProc    
    
	AjustaSX1()
	
	Pergunte(cPerg,.T.)
	
	//Montagem da tela de processamento
	
	@ 200,1 TO 440,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar o fechamento financeiro de "
	@ 022,018 Say " funcionarios, efetuando a compensa็ใo entre carteiras dos tํtulos  "
	@ 032,018 Say " referentes as vendas de produtos silvestre "
	@ 042,018 Say " de acordo com os parโmetros informados. "
	
	@ 02,010 TO 100,190
	@ 106,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 106,130 BMPBUTTON TYPE 01 ACTION Processa({|| U_LTFIN4PROC(mv_par01, mv_par02, mv_par03, mv_par04, .T.)},,"Processando os registros..")
	@ 106,160 BMPBUTTON TYPE 02 ACTION Close(oDlgProc)
	
	Activate Dialog oDlgProc Centered

Return
       
       
                                                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTFIN4PROCบAutor  ณRafael Parma        บ Data ณ  15/06/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento de registros do fechamento financeiro de      บฑฑ
ฑฑบ          ณpagamento de produtores.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
User Function LTFIN4PROC(dVCTOINI, dVCTOFIN, cFUNINI, cFUNFIN, lClose ) 
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Private STRING_Null := "" 
Private cArqLog		:= "\fechamento\FUN_"+dtos(ddatabase)+"_"+StrTran(cValToChar(time()),":","")+".log"  // arquivo de log das opera็๕es
Private nHdlLog
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa็ใo do arquivo de log                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    If ! fBegFile()
		MsgAlert("O arquivo de nome "+cArqLog+" nao pode ser executado!","Aten็ใo")
		Return
    EndIf
          
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cMENSAGEM := "0-INICIO DO PROCESSAMENTO."
	fWrtFile(cMENSAGEM)

	cMENSAGEM := "0-DATA DE-ATE: "+dtoc(dVCTOINI)+"-"+dtoc(dVCTOFIN)+" - FUNCIONARIO DE-ATE: "+cFUNINI+"-"+cFUNFIN
    fWrtFile(cMENSAGEM)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Compensa็ใo entre carteiras - Creditos x Debitos de produtores      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	fPrcCOMP(dVCTOINI, dVCTOFIN, cFUNINI, cFUNFIN) 

		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cMENSAGEM := "9-FIM DO PROCESSAMENTO."
	fWrtFile(cMENSAGEM)
	fEndFile()
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza janela de processamento                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    


	If lClose
		Close(oDlgProc)
	EndIf	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPrcCOMP   บAutor  ณRafael Parma       บ Data ณ  15/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona os tํtulos a receber e a pagar por produtor em    บฑฑ
ฑฑบ          ณaberto e realiza a compensa็ใo entre carteiras.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPrcCOMP( dVCTOINI, dVCTOFIN, cFUNINI, cFUNFIN)

Local cAliasTMP   := GetNextAlias()
Local hEnter	  := CHR(13) + CHR(10)   

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private aAutoCab  := {}
Private aTITSE1   := {}
Private aTITSE2   := {}		
Private aTITCPC   := {}
Private nTOTSE1   := 0
Private nTOTSE2   := 0 
Private nTOTCPC   := 0
Private nDEBCR    := 0 

U_LTIMPFOR() // Chama rotina cadastro fornecedores com base nos funcionแrios

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos dados de acordo com os parametros informados pelo usuแrio  . ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
CONOUT("##################### PROCESSO DE COMPENSACAO #############################")
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "	SELECT 	SRA.RA_CLIENTE,               						" + hEnter
	cQuery += "         SRA.RA_LOJA,				 						" + hEnter
	cQuery += "         SRA.RA_NOME					 						" + hEnter
	cQuery += "	FROM " + RetSqlName("SRA") + " SRA							" + hEnter 
	cQuery += "	INNER JOIN " + RetSqlName("SA2") + " SA2   					" + hEnter
	cQuery += "	ON       SRA.RA_CLIENTE    = SA2.A2_COD					 	" + hEnter
	cQuery += "	AND      SRA.RA_LOJA	   = SA2.A2_LOJA				 	" + hEnter	
	cQuery += "	WHERE    SRA.RA_FILIAL    = '" + xFilial("SRA") + "' 		" + hEnter
	cQuery += "	AND      SRA.RA_MAT BETWEEN '" + cFUNINI + "'	 			" + hEnter
	cQuery += "	AND      					'" + cFUNFIN + "'		 		" + hEnter
	cQuery += "	AND 	 SRA.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "	AND 	 SA2.D_E_L_E_T_   != '*' 							" + hEnter	                        
	
	memowrite("LSFIN004_SCMP.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	                         

	cMENSAGEM := "INICIO DO PROCESSAMENTO-COMPENSACAO ENTRE CARTEIRAS."
	fWrtFile(cMENSAGEM)
	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	ProcRegua((cAliasTMP)->(RecCount()))
	
	While !(cAliasTMP)->(EOF())
                                   
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณDefine variแveis de processamento                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		cAliasSE1 := GetNextAlias()
		cAliasSE2 := GetNextAlias()

		aTITSE1   := {}
		aTITSE2   := {}
		
		nTOTSE1   := 0
		nTOTSE2   := 0
			                
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Escreve no arquivo de log                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		
		cMENSAGEM := "FORNECEDOR: " + (cAliasTMP)->RA_CLIENTE + "/" + (cAliasTMP)->RA_LOJA
		fWrtFile(cMENSAGEM)		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณSeleciona todos os tํtulos em aberto do contas a receber p/ o produtor         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		dbSelectArea("SA1")
		dbSetOrder(1) 	// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
		dbGoTop()
		If dbSeek ( xFilial("SA1") + SubSTR((cAliasTMP)->RA_CLIENTE,1,TAMSX3("A2_COD")[1]) + SubSTR((cAliasTMP)->RA_LOJA,1,TAMSX3("A2_LOJA")[1]) )		

			cQuery := "	SELECT 															" + hEnter
			cQuery += "			SE1.E1_SALDO,											" + hEnter
			cQuery += "			SE1.E1_FILIAL,											" + hEnter
			cQuery += "			SE1.E1_PREFIXO,											" + hEnter
			cQuery += "			SE1.E1_NUM,   											" + hEnter
			cQuery += "			SE1.E1_PARCELA,											" + hEnter
			cQuery += "			SE1.E1_TIPO,  											" + hEnter
			cQuery += "			SE1.E1_CLIENTE,											" + hEnter
			cQuery += "			SE1.E1_LOJA   											" + hEnter
			
			cQuery += "	FROM " + RetSqlName("SE1") + " SE1								" + hEnter
		
			cQuery += "	WHERE   SE1.E1_FILIAL    = '" + xFilial("SE1") + "' 			" + hEnter
			cQuery += "	AND     SE1.E1_CLIENTE   = '" + SA1->A1_COD  + "'				" + hEnter
			cQuery += "	AND     SE1.E1_LOJA      = '" + SA1->A1_LOJA + "'				" + hEnter
			cQuery += "	AND     SE1.E1_VENCREA BETWEEN '" + dtos(dVCTOINI) + "'			" + hEnter
			cQuery += "	AND     					   '" + dtos(dVCTOFIN) + "'			" + hEnter
			cQuery += "	AND     SE1.E1_SALDO     > 0									" + hEnter
			cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" + hEnter
		
			memowrite("LTMOV005_SCMP-SE1.SQL",cQuery)
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSE1)				
			
			dbSelectArea(cAliasSE1)
			(cAliasSE1)->(dbGoTop())
			
			While !(cAliasSE1)->(EOF())
					
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
				//ณAdiciona ao array os tํtulos em aberto do contas a receber p/ o funcionario       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู			

//				aAdd (aTITSE1 , { (cAliasSE1)->E1_FILIAL + (cAliasSE1)->E1_PREFIXO + (cAliasSE1)->E1_NUM + (cAliasSE1)->E1_PARCELA + (cAliasSE1)->E1_TIPO } )
				dbSelectArea("SE1")
				SE1->( dbSetOrder( 1 ) )
				SE1->(dbGoTop())
				SE1->( MsSeek( xFilial( "SE1" ) + ;
								PadR( (cAliasSE1)->E1_PREFIXO , TamSX3( "E1_PREFIXO" )[ 1 ] ) + ;
								PadR( (cAliasSE1)->E1_NUM , TamSX3( "E1_NUM"     )[ 1 ] ) + ;
								PadR( (cAliasSE1)->E1_PARCELA , TamSX3( "E1_PARCELA" )[ 1 ] ) + ; 
								PadR( (cAliasSE1)->E1_TIPO , TamSX3( "E1_TIPO"    )[ 1 ] ) ) )
                
		        dbSelectArea(cAliasSE1)
				aAdd (aTITSE1 , { xFilial( "SE1" ) + ;
								PadR( (cAliasSE1)->E1_PREFIXO , TamSX3( "E1_PREFIXO" )[ 1 ] ) + ;
								PadR( (cAliasSE1)->E1_NUM , TamSX3( "E1_NUM"     )[ 1 ] ) + ;
								PadR( (cAliasSE1)->E1_PARCELA , TamSX3( "E1_PARCELA" )[ 1 ] ) + ; 
								PadR( (cAliasSE1)->E1_TIPO , TamSX3( "E1_TIPO"    )[ 1 ] ) } )
			
				cMENSAGEM := "CR:" + (cAliasSE1)->E1_FILIAL + (cAliasSE1)->E1_PREFIXO + (cAliasSE1)->E1_NUM + (cAliasSE1)->E1_PARCELA + (cAliasSE1)->E1_TIPO
				fWrtFile(cMENSAGEM)

				nTOTSE1 +=  (cAliasSE1)->E1_SALDO
				
				(cAliasSE1)->(dbSkip())				
			Enddo                      
			(cAliasSE1)->(dbCloseArea())
			
		Else

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Escreve no arquivo de log                                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			
			cMENSAGEM := "2-ERRO CLIENTE NAO LOCALIZADO - FORNECEDOR: " + (cAliasTMP)->RA_CLIENTE + "/" + (cAliasTMP)->RA_LOJA
			fWrtFile(cMENSAGEM)

		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณSeleciona todos os tํtulos em aberto de credito (PA/NDF)contas a pagar p/ o funcionario  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		cQuery := "	SELECT 																			  			" + hEnter
		cQuery += "			SE2.R_E_C_N_O_										   					 			" + hEnter
		
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2							  								" + hEnter
	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xFilial("SE1") + "' 		  								" + hEnter
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR((cAliasTMP)->RA_CLIENTE,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR((cAliasTMP)->RA_LOJA,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dVCTOINI) + "'										" + hEnter
		cQuery += "	AND     					   '" + dtos(dVCTOFIN) + "'	   									" + hEnter
		cQuery += "	AND     SE2.E2_TIPO      = 'CO'																" + hEnter		
		cQuery += "	AND     SE2.E2_SALDO     > 0							  									" + hEnter
		cQuery += "	AND		SE2.E2_TIPO IN ('PA','NDF')						  					 				" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 								  								" + hEnter
		
//        Aviso("SQL",cQuery,{"OK"},3)
		memowrite("LSFIN004_SCMP-SE2.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSE2)			

		dbSelectArea(cAliasSE2)
		(cAliasSE2)->(dbGoTop())
		
		While !(cAliasSE2)->(EOF())
			aAdd ( aTITCPC, (cAliasSE2)->R_E_C_N_O_ )
			dbSelectArea("SE2")
			dbGoTo((cAliasSE2)->R_E_C_N_O_)
			If !SE2->(EOF())
				nTOTCPC += SE2->E2_SALDO
			EndIf
			(cAliasSE2)->(dbSkip())
		Enddo             
		(cAliasSE2)->(dbCloseArea())


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณSeleciona todos os tํtulos em aberto de credito (PA/NDF)contas a pagar p/ o funiocnario  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		cQuery := "	SELECT 																			  			" + hEnter
		cQuery += "			SE2.R_E_C_N_O_,										   					 			" + hEnter
		cQuery += "			SE2.E2_PREFIXO 										   					 			" + hEnter
		
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2							  								" + hEnter
	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xFilial("SE1") + "' 		  								" + hEnter
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR((cAliasTMP)->RA_CLIENTE,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR((cAliasTMP)->RA_LOJA,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dVCTOINI) + "'										" + hEnter
		cQuery += "	AND     					   '" + dtos(dVCTOFIN) + "'	   									" + hEnter		
		cQuery += "	AND     SE2.E2_TIPO      = 'CO'																" + hEnter		
		cQuery += "	AND     SE2.E2_SALDO     > 0							  									" + hEnter
		cQuery += "	AND		SE2.E2_TIPO NOT IN ('PA','NDF')						  					 			" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 								  								" + hEnter

		cQuery += "	ORDER BY SE2.E2_PREFIXO DESC									   					 		" + hEnter

		memowrite("LSFIN004_SCMP-SE2.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSE2)			

		dbSelectArea(cAliasSE2)
		(cAliasSE2)->(dbGoTop())
		
		While !(cAliasSE2)->(EOF())
			aAdd ( aTITSE2, (cAliasSE2)->R_E_C_N_O_ )
			dbSelectArea("SE2")
			dbGoTo((cAliasSE2)->R_E_C_N_O_)
			If !SE2->(EOF())
				nTOTSE2 += SE2->E2_SALDO
			EndIf
			(cAliasSE2)->(dbSkip())
		Enddo             
		(cAliasSE2)->(dbCloseArea())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณRealiza a compensa็ใo entre titulos contas a pagar  PA/NDF                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู
		If Len(aTITSE2) > 0 .and. Len(aTITCPC) > 0

			cMENSAGEM := "COMPENSACAO ENTRE TITULOS: " + (cAliasTMP)->RA_CLIENTE + "/" + (cAliasTMP)->RA_LOJA
			fWrtFile(cMENSAGEM) 
			
			nOldMod := nModulo
			nModulo := 6

			PERGUNTE("AFI340",.F.)		   	
			lContabiliza:= MV_PAR11 == 1
			lAglutina	:= MV_PAR08 == 1
			lDigita		:= MV_PAR09 == 1
		
			dDtBxCmp := ddatabase
			nValComp := NIL        	
			CONOUT("##################### INICIO PROCESSO COMPENSACAO CONTAS A PAGAR PA/NDF #############################")
        	MaIntBxCP(2,aTITSE2,,aTITCPC,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,nValComp,dDtBxCmp)	     
			CONOUT("##################### FIM PROCESSO COMPENSACAO CONTAS A PAGAR PA/NDF #############################")        	
        	nModulo := nOldMod

		EndIf                      
		
		
		aTITSE2 := {}
		nTOTSE2 := 0
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณSeleciona todos os tํtulos em aberto do contas a pagar p/ o funcionario       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		cQuery := "	SELECT 																			  			" + hEnter
		cQuery += "			SE2.E2_SALDO,										   					 			" + hEnter
		cQuery += "			SE2.E2_FILIAL,															 			" + hEnter
		cQuery += "			SE2.E2_PREFIXO,										 					 			" + hEnter
		cQuery += "			SE2.E2_NUM,   										 					 			" + hEnter
		cQuery += "			SE2.E2_PARCELA,										  					 			" + hEnter
		cQuery += "			SE2.E2_TIPO,  										  					 			" + hEnter
		cQuery += "			SE2.E2_FORNECE,										 				   				" + hEnter
		cQuery += "			SE2.E2_LOJA   										   								" + hEnter
		
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2							  								" + hEnter
	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xFilial("SE1") + "' 		  								" + hEnter
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR((cAliasTMP)->RA_CLIENTE,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR((cAliasTMP)->RA_LOJA,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dVCTOINI) + "'										" + hEnter
		cQuery += "	AND     					   '" + dtos(dVCTOFIN) + "'	   									" + hEnter		
		cQuery += "	AND     SE2.E2_TIPO      = 'CO'																" + hEnter		
		cQuery += "	AND     SE2.E2_SALDO     > 0							  									" + hEnter
		cQuery += "	AND		SE2.E2_TIPO NOT IN ('PA','NDF')						  					 			" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 								  								" + hEnter

		memowrite("LTMOV005_SCMP-SE2.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSE2)			

		dbSelectArea(cAliasSE2)
		(cAliasSE2)->(dbGoTop())
		
		While !(cAliasSE2)->(EOF())
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
			//ณAdiciona ao array os tํtulos em aberto do contas a pagar p/ o funcionario     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู			
	
/*			aAdd (aTITSE2 , { 	(cAliasSE2)->E2_FILIAL + (cAliasSE2)->E2_PREFIXO + (cAliasSE2)->E2_NUM + (cAliasSE2)->E2_PARCELA + ;
								(cAliasSE2)->E2_TIPO + (cAliasSE2)->E2_FORNECE + (cAliasSE2)->E2_LOJA } ) */
		dbSelectArea("SE2")
		SE2->( dbSetOrder( 1 ) )
		SE2->( dbGoTop() )		
        SE2->( MsSeek( xFilial( "SE2" ) +  PadR( (cAliasSE2)->E2_PREFIXO        , TamSX3( "E2_PREFIXO" )[ 1 ] ) + ;
                                           PadR( (cAliasSE2)->E2_NUM 			, TamSX3( "E2_NUM"     )[ 1 ] ) + ;
                                           PadR( (cAliasSE2)->E2_PARCELA        , TamSX3( "E2_PARCELA" )[ 1 ] ) + ;
                                           PadR( (cAliasSE2)->E2_TIPO       	, TamSX3( "E2_TIPO"    )[ 1 ] ) + ;
                                           PadR( (cAliasSE2)->E2_FORNECE    	, TamSX3( "E2_FORNECE" )[ 1 ] ) + ;
                                           PadR( (cAliasSE2)->E2_LOJA        	, TamSX3( "E2_LOJA"    )[ 1 ] ) ) )
		dbSelectArea(cAliasSE2)								

			aAdd (aTITSE2 , { xFilial( "SE2" ) + ;
							PadR( (cAliasSE2)->E2_PREFIXO 	, TamSX3( "E2_PREFIXO" )[ 1 ] ) + ;
							PadR( (cAliasSE2)->E2_NUM 		, TamSX3( "E2_NUM"     )[ 1 ] ) + ;
							PadR( (cAliasSE2)->E2_PARCELA 	, TamSX3( "E2_PARCELA" )[ 1 ] ) + ;
							PadR( (cAliasSE2)->E2_TIPO 		, TamSX3( "E2_TIPO"    )[ 1 ] ) + ;
							PadR( (cAliasSE2)->E2_FORNECE 	, TamSX3( "E2_FORNECE" )[ 1 ] ) + ;
							PadR( (cAliasSE2)->E2_LOJA 		, TamSX3( "E2_LOJA"    )[ 1 ] ) } )

			cMENSAGEM := "CP:" + (cAliasSE2)->E2_FILIAL + (cAliasSE2)->E2_PREFIXO + (cAliasSE2)->E2_NUM + (cAliasSE2)->E2_PARCELA + ;
						 (cAliasSE2)->E2_TIPO + (cAliasSE2)->E2_FORNECE + (cAliasSE2)->E2_LOJA
			fWrtFile(cMENSAGEM)
			
			nTOTSE2 +=  (cAliasSE2)->E2_SALDO					
			
			(cAliasSE2)->(dbSkip())				
		Enddo                      

		(cAliasSE2)->(dbCloseArea())
			


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe existir tํtulos a receber e pagar p/ o funcionario, realiza a compensa็ใo entre carteiras.   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If Len(aTITSE1) > 0 .and. Len(aTITSE2) > 0

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณDefine se compensa็ใo de credito ou debito.    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					    
		    If nTOTSE1 > nTOTSE2
		    	nVALMT := nTOTSE1
		    	nDEBCR := 0	// DEBITO
		    Else                 
		    	nVALMT := nTOTSE2
		    	nDEBCR := 1 // CREDITO
		    EndIf
			
			aAutoCab := { 	{"AUTDVENINI450", dVCTOINI		 			, nil},;
							{"AUTDVENFIM450", dVCTOFIN		   			, nil},; 
							{"AUTNLIM450" 	, nVALMT 					, nil},;
							{"AUTCCLI450" 	, SA1->A1_COD 	 			, nil},;
							{"AUTCLJCLI" 	, SA1->A1_LOJA	   			, nil},;
							{"AUTCFOR450" 	, SubSTR((cAliasTMP)->RA_CLIENTE,1,TamSX3("A2_COD")[1]) , nil},;
							{"AUTCLJFOR" 	, SubSTR((cAliasTMP)->RA_LOJA,1,TamSX3("A2_LOJA")[1]), nil},;
							{"AUTCMOEDA450" , "01" 						, nil},;
							{"AUTNDEBCRED" 	, nDEBCR					, nil},;
							{"AUTLTITFUTURO", .F. 						, nil},;
							{"AUTARECCHAVE" , aTITSE1 					, nil},;
							{"AUTAPAGCHAVE" , aTITSE2 					, nil}}
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta rotina de compensa็ใo entre carteiras.   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			
			aTMPAlias := GetArea()
			
			dbSelectArea("SE1")
			dbSelectArea("SE2")

			cMENSAGEM := "0-EXECAUTO COMPENSACAO - FORNECEDOR: " + (cAliasTMP)->RA_CLIENTE + "/" + (cAliasTMP)->RA_LOJA + " - VALOR CR: " +cValToChar(nTOTSE1)+ " - VALOR CP: " +cValToChar(nTOTSE2)
			fWrtFile(cMENSAGEM)
			CONOUT("##################### INICIO PROCESSO COMPENSACAO ENTRE CARTEIRAS #############################")
//			nOldMod := nModulo
//			nModulo := 6
			MSExecAuto( {|x,y,z| FINA450(x,y,z)}, nil , aAutoCab , 3 ) //inclusao
//			nModulo :=nOldMod
			CONOUT("##################### FIM PROCESSO COMPENSACAO ENTRE CARTEIRAS #############################")			
			If !lMsErroAuto

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	                               
				RestArea(aTMPAlias)
				
				cMENSAGEM := "1-COMPENSACAO - FORNECEDOR: " + (cAliasTMP)->RA_CLIENTE + "/" + (cAliasTMP)->RA_LOJA + " - VALOR CR: " +cValToChar(nTOTSE1)+ " - VALOR CP: " +cValToChar(nTOTSE2)
				fWrtFile(cMENSAGEM)

			Else
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				MostraErro()

				cMENSAGEM := "2-ERRO COMPENSACAO - FORNECEDOR: " + (cAliasTMP)->RA_CLIENTE + "/" + (cAliasTMP)->RA_LOJA + " - VALOR CR: " +cValToChar(nTOTSE1)+ " - VALOR CP: " +cValToChar(nTOTSE2)
				fWrtFile(cMENSAGEM)

				RestArea(aTMPAlias)
			EndIf
			
			
					
		Else                                  
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Escreve no arquivo de log                                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
			cMENSAGEM := "NAO EXISTEM TITULOS A COMPENSAR."
			fWrtFile(cMENSAGEM)			
		
		EndIf
		
		IncProc()
		dbSelectArea(cAliasTMP)		
		(cAliasTMP)->(dbSkip())
	Enddo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	                         
	cMENSAGEM := "FIM DO PROCESSAMENTO-COMPENSACAO ENTRE CARTEIRAS"
	fWrtFile(cMENSAGEM)
	
    (cAliasTMP)->(dbCloseArea())           

Return	




                                                                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBegFile    บAutor  ณRafael Parma      บ Data ณ  11/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicializa็ใo do arquivo de log.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fBegFile()               
*---------------------------------------*
Local lRet := .T.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o arquivo texto                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	nHdlLog := fCreate(cArqLog)

	If nHdlLog == -1
	    lRet := .F.
	Endif
	
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWrtFile    บAutor  ณRafael Parma      บ Data ณ  11/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEscreve no arquivo de log.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
Static Function fWrtFile(cLin)           
*---------------------------------------*
Local lRet := .T.
Local cSTR := cLin
	
	cSTR := dtos(ddatabase)+"-"+cValToChar(time())+"-"+cSTR+chr(13)+chr(10)
	
   	If fWrite(nHdlLog,cSTR,Len(cSTR)) != Len(cSTR)
   		lRet := .F.
   	EndIf
	
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEndFile    บAutor  ณRafael Parma      บ Data ณ  11/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinaliza็ใo do arquivo de log.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
Static Function fEndFile()
*---------------------------------------*
	fClose(nHdlLog)
	
Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChkParam  บAutor  ณRafael Parma       บ Data ณ  13/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para checar todos os parโmetros utilizados บฑฑ
ฑฑบ          ณno processo antes de ser inicializado.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChkParam()

Local lRet        := .T.
Local cMV_ZLRNAT  := AllTRIM(GetMV("MV_ZLRNAT"))	// c๓digo da natureza do tํtulo a receber
Local cMV_ZLRPRF  := AllTRIM(GetMV("MV_ZLRPRF"))	// prefixo do tํtulo a receber
Local cMV_ZLRTIP  := AllTRIM(GetMV("MV_ZLRTIP"))	// tipo do tํtulo a receber
Local cMV_ZLRPRC  := AllTRIM(GetMV("MV_ZLRPRC"))	// parcela do tํtulo a receber 
Local cMV_ZLPNAT  := AllTRIM(GetMV("MV_ZLPNAT"))	// c๓digo da natureza do tํtulo a pagar  
Local cMV_ZLPPRF  := AllTRIM(GetMV("MV_ZLPPRF"))	// prefixo do tํtulo a pagar  
Local cMV_ZLPTIP  := AllTRIM(GetMV("MV_ZLPTIP"))	// tipo do tํtulo a pagar  
Local cMV_ZLPPRC  := AllTRIM(GetMV("MV_ZLPPRC"))	// parcela do tํtulo a pagar   
Local cNATCHQ     := ALLTRIM(GETMV("MV_ZLNTCH"))	// Natureza do cheque
Local cDESCHIST   := ALLTRIM(GETMV("MV_ZLHTCH"))	// Historico do cheque 

Local nMV_NUMTCP  := GetMV("MV_ZLNTCP")				// Numero sequencial tํtulo a pagar  	
Local nMV_NUMTCR  := GetMV("MV_ZLNTCR")				// Numero sequencial tํtulo a receber
	                    
	
	
	If cMV_ZLRNAT == STRING_Null .or. cMV_ZLRNAT == STRING_Null 
		U_LTALL001(cTitulo, "Paramโtro MV_ZLRNAT/MV_ZLPNAT sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLRNAT/MV_ZLPNAT.")
		lRet := .F.
	Else
		
		dbSelectArea("SED")
		dbSetOrder(1)
		dbGoTop()
		If ! dbSeek ( xFilial("SED") + cMV_ZLPNAT )
			U_LTALL001(cTitulo, "C๓digo da Natureza definido no parโmetro MV_ZLPNAT ้ invแlido.","Verificar o conte๚do no param๊tro MV_ZLPNAT.")
			lRet := .F.	
		EndIf		

		dbSelectArea("SED")
		dbSetOrder(1)
		dbGoTop()
		If ! dbSeek ( xFilial("SED") + cMV_ZLRNAT )
			U_LTALL001(cTitulo, "C๓digo da Natureza definido no parโmetro MV_ZLRNAT ้ invแlido.","Verificar o conte๚do no param๊tro MV_ZLRNAT.")
			lRet := .F.	
		EndIf
		
	EndIf
		
	If cMV_ZLRPRF == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLRPRF sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLRPRF.")
		lRet := .F.
	EndIf

	If cMV_ZLPPRF == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLPPRF sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLPPRF.")
		lRet := .F.
	EndIf

	If cMV_ZLRTIP == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLRTIP sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLRTIP.")
		lRet := .F.
	EndIf

	If cMV_ZLPTIP == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLPTIP sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLPTIP.")
		lRet := .F.
	EndIf

	If cMV_ZLRPRC == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLRPRC sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLRPRC.")
		lRet := .F.
	EndIf

	If cMV_ZLPPRC == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLPPRC sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLPPRC.")
		lRet := .F.
	EndIf

	If cNATCHQ == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLNTCH sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLNTCH.")
		lRet := .F.
	EndIf

	If cDESCHIST == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLHTCH sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLHTCH.")
		lRet := .F.
	EndIf
		

Return ( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChkCLIENTE  บAutor  ณRafael Parma      บ Data ณ  16/11/09  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se existe c๓digo de cliente relacionado a todos    บฑฑ
ฑฑบ          ณos produtores das linhas selecionadas para fechamento.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChkCLIENTE( cSTART_LIN, cEND_LIN )
Local lRet       := .T.
Local aPRODUT    := {}         
Local cAliasTMP  := GetNextAlias()
Local cPRODUT    := STRING_Null
Local cCODCLI    := STRING_Null
Local cLOJCLI    := STRING_Null
Local hEnter	 := CHR(13) + CHR(10)

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
			    
	cQuery := "SELECT   SRA.ZL1_PRODUT,									" + hEnter
	cQuery += "			SRA.ZL1_LOJPRD									" + hEnter
	cQuery += "FROM " + RetSqlName("ZL1") + " ZL1						" + hEnter
	cQuery += "WHERE    SRA.ZL1_FILIAL     = '" + xFilial("ZL1") + "' 	" + hEnter
	cQuery += "AND 		SRA.SRA_COD  BETWEEN '" + cSTART_LIN + "' 		" + hEnter
	cQuery += "AND      	           		 '" + cEND_LIN   + "' 		" + hEnter
	cQuery += "AND 		SRA.D_E_L_E_T_    != '*' 						" + hEnter
	cQuery += "ORDER BY SRA.RA_CLIENTE, SRA.RA_LOJA                 	" + hEnter		
	
	memowrite("LTMOV003_5.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())	
	While !(cAliasTMP)->(EOF()) 		            
		If !fRecCLIENTE( SubSTR((cAliasTMP)->ZL1_PRODUT,1,TAMSX3("A2_COD")[1]), SubSTR((cAliasTMP)->ZL1_LOJPRD,1,TAMSX3("A2_LOJA")[1]) )
			AAdd( aPRODUT, { (cAliasTMP)->ZL1_PRODUT, (cAliasTMP)->ZL1_LOJPRD })
		EndIf
    	dbSelectArea(cAliasTMP)
    	(cAliasTMP)->(dbSkip())
    Enddo

    (cAliasTMP)->(dbCloseArea())
    
    If Len(aPRODUT) > 0    	
    	For nI := 1 to Len(aPRODUT)
    		cPRODUT += "CำDIGO: " + aPRODUT[nI,1]+"/LOJA: " + aPRODUT[nI,2]+", "
    	Next nI                
    	cPRODUT := SubSTR(cPRODUT,1,Len(cPRODUT)-2)
    	U_LTALL001(cTitulo, "O(s) seguinte(s) funcionarios(es) nใo possue(m) cliente(s) relacionado(s): "+cPRODUT,"Inserir o cliente correspondente a(os) funcionarios(es) relacionado(s).")
    	lRet := .F.
    EndIf
    
Return ( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRecSA1    บAutor  ณRafael Parma       บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRecupera o c๓digo do cliente + loja relacionado ao produtor บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRecCLIENTE( cPRODUT, cLOJPRD )
Local lRet       := .F.

	dbSelectArea("SA1")
	dbSetOrder(14) 		// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
	dbGoTop()
	If dbSeek ( xFilial("SA1") + cPRODUT + cLOJPRD )
		lRet := .T.
	EndIf
    
Return ( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  24/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas LTMOV010.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
Static Function AjustaSX1()              
*---------------------------------------*
aRegs   := {}
aHelp01 := {}  
aHelp02 := {} 
aHelp03 := {}  
aHelp04 := {}                                                  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Vencimento De      ?","Vencimento De      ?","Vencimento De      ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","Vencimento At้     ?","Vencimento At้     ?","Vencimento At้     ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPerg,"03","Funionแrio De      ?","Funionแrio De      ?","Funionแrio De      ?","mv_ch3","C",TAMSX3("RA_MAT")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SRA","","",""})
	aAdd(aRegs,{cPerg,"04","Funionแrio At้     ?","Funionแrio At้     ?","Funionแrio At้     ?","mv_ch4","C",TAMSX3("RA_MAT")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SRA","","",""})
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe a data inicial do vencimento de  " )       
	AADD( aHelp01, "tํtulos para compensa็ใo.         		 " )       
	AADD( aHelp02, "Informe a data final   do vencimento de  " )       
	AADD( aHelp02, "tํtulos para compensa็ใo.      			 " )       
	AADD( aHelp03, "Informe o funcionario inicial    		 " )       
	AADD( aHelp04, "Informe o funcionario final              " )       


  
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
	PutSX1Help("P.LSFIN0001.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LSFIN0002.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LSFIN0003.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LSFIN0004.",aHelp04,aHelp04,aHelp04)
		
Return Nil   
