#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV003 บAutor  ณRafael Parma         บ Data ณ  12/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de fechamento de coletas mensal dos produtores.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTMOV003()
*-----------------------*                
                                      
Private oDlgProc    
            
Private cString  	:= "ZL5"
Private cPerg    	:= "LTMOV00003"
Private cTitulo  	:= "Fechamento mensal de produtores"
Private STRING_Null := ""          
    
	AjustaSX1()
	Pergunte(cPerg,.F.)
	//Montagem da tela de processamento
	
	@ 200,1 TO 440,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar o fechamento do mensal "
	@ 022,018 Say " de produtores, gerando as notas fiscais e tํtulos no m๓dulo "
	@ 032,018 Say " financeiro, de acordo com os parโmetros informados. "
	@ 052,018 Say " Antes de efetuar o fechamento mensal, imprimir os relat๓rios "
	@ 064,018 Say " de fechamento e efetuar as confer๊ncias necessแrias. "
	
	@ 02,010 TO 100,190
	@ 106,070 BMPBUTTON TYPE 06 ACTION U_LTREL001()
	@ 106,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 106,130 BMPBUTTON TYPE 01 ACTION Processa({|| fProcessa()},,"Processando os registros..")
	@ 106,160 BMPBUTTON TYPE 02 ACTION Close(oDlgProc)
	
	Activate Dialog oDlgProc Centered		
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalPrd  บAutor  ณRafael Parma         บ Data ณ  12/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de fechamento mensal dos produtores.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fProcessa()             
                                         
Local cAliasTMP    := GetNextAlias() 
Local cMENSAGEM    := STRING_Null
Local hEnter	   := CHR(13) + CHR(10) 
Local nVLR_NFS     := 0					// valor total das notas fiscais de saํda
Local nVLR_DESP    := 0					// valor total de despesas (conta corrente)
//Local nSALDO_CP    := 0					// saldo contas a pagar do produtor
Local nPRC_LITRO   := 0					// pre็o total dos litros  
Local nPRC_FRETE   := 0					// pre็o do frete
Local cNUMDOC      := STRING_Null		// n๚mero do documento de entrada
Local cSERDOC	   := STRING_Null		// serie do documento de entrada
Local cKeyNDF      := STRING_Null		// chave do tํtulo NDF
Local cKeyNFE      := STRING_Null		// chave do documento de entrada 
Local cCODCLI      := STRING_Null		// c๓digo cliente do produtor
Local cLOJCLI      := STRING_Null		// n๚mero da loja do produtor
Local aKeyNFS      := {}				// array com os tํtulos de NFS
Local aKeyNFE      := {}				// array com as chaves da NFE
Local dSTART_DATE  := ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))	// primeiro dia do perํodo
Local dEND_DATE    := dSTART_DATE												// ๚ltimo dia do perํodo
Local cLINHA_DE    := mv_par03
Local cLINHA_ATE   := mv_par04
Local nORDPROC     := mv_par05
Local nEXCECAO     := mv_par06
Local cFORN_DE     := mv_par07
Local cFORN_ATE    := mv_par08
Local cLOJA_DE     := mv_par09
Local cLOJA_ATE    := mv_par10
Local cCOND_DE     := mv_par11
Local cCOND_ATE    := mv_par12
Local cTpEntrada   := "1"

Private lATPERCFOR := SuperGetMV("MV_ZLATPN",,.F.)	// Ativo controle de percentual s/ fornecedor p/ gerar documento 
Private cArqLog    := "\fechamento\COL_"+dtos(ddatabase)+"_"+StrTran(cValToChar(time()),":","")+".log"  // arquivo de log das opera็๕es
Private nHdlLog
Private cSERIENF   := ""

    // fecha a janela principal
    Close(oDlgProc)                      
    
    Pergunte(cPerg,.F.)
    
	// define a data final
	If U_YIsBis(mv_par02) 
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","29","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))
    Else
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","28","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))   
    EndIf
    
    // inicializa็ใo do arquivo de log
    If ! fBegFile()
		MsgAlert("O arquivo de nome "+cArqLog+" nao pode ser executado!","Aten็ใo")
		Return
    EndIf
                                                                                           
	// verifica se o usuแrio tem certeza antes de executar o procedimento.
	If ! ApMsgNoYes("Confirma a execu็ใo do fechamento mensal de acordo com os parโmetros informados ?", "Aten็ใo")
		Return 
	EndIf
    
    // verifica se os parโmetros utilizados no procedimento estใo preenchidos corretamente.
	If ! fChkParam()
		U_LTALL001(cTitulo, "Impossํvel executar o procedimento.","Favor verificar o conte๚do dos parโmetros apresentados anteriormente e executar a rotina novamente.")
		Return
	EndIf                                                                                  
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	
	cQuery := "SELECT 	SUM(ZL6.ZL6_QTDE) ZL6_QTDE,								" + hEnter
	cQuery += "			ZL5.ZL5_LINHA,											" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,											" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,											" + hEnter
	cQuery += "			SA2.A2_NOME												" + hEnter	
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5								" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6		   					" + hEnter
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL  	                " + hEnter		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD         	            " + hEnter		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   					" + hEnter
	cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                " + hEnter		
	cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            " + hEnter		
	cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "'	 		" + hEnter
	cQuery += "AND 		( ZL5.ZL5_LINHA  BETWEEN '" + cLINHA_DE   + "'	 		" + hEnter
	cQuery += "AND      	           		     '" + cLINHA_ATE  + "' )		" + hEnter
	cQuery += "AND 		( ZL5.ZL5_DATA   BETWEEN '" + DTOS(dSTART_DATE) + "'	" + hEnter
	cQuery += "AND                          	 '" + DTOS(dEND_DATE) + "' )	" + hEnter

	cQuery += "AND 		( ZL6.ZL6_PRODUT BETWEEN '" + cFORN_DE +  "'			" + hEnter
	cQuery += "AND                          	 '" + cFORN_ATE + "' )			" + hEnter
	cQuery += "AND 		( ZL6.ZL6_LOJPRD BETWEEN '" + cLOJA_DE +  "'			" + hEnter
	cQuery += "AND                          	 '" + cLOJA_ATE + "' )			" + hEnter
	cQuery += "AND 		( SA2.A2_COND BETWEEN    '" + cCOND_DE +  "'			" + hEnter
	cQuery += "AND                          	 '" + cCOND_ATE + "' )			" + hEnter
		
	cQuery += "AND 		ZL5.ZL5_STATUS    = ''  								" + hEnter
	cQuery += "AND 		ZL6.ZL6_STATUS    = ''  								" + hEnter
	cQuery += "AND 		ZL5.D_E_L_E_T_   != '*' 								" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_   != '*' 								" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 								" + hEnter
	cQuery += "AND 		SA2.A2_INDCP   <> '2'	 								" + hEnter
	cQuery += "GROUP BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 							" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD, SA2.A2_NOME								" + hEnter
	If nORDPROC == 1
		cQuery += "ORDER BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, ZL6.ZL6_LOJPRD		" + hEnter
	Else                                                                                  
		cQuery += "ORDER BY ZL5.ZL5_LINHA, SA2.A2_NOME							" + hEnter
	EndIf
                        
	memowrite("LTMOV003_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	ProcRegua((cAliasTMP)->(RecCount()))
	
	cMENSAGEM := "INICIO DO PROCESSAMENTO."
	fWrtFile(cMENSAGEM)
	
	 
	While (cAliasTMP)->(!EOF())
	
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek ( xFilial("SA2") + (cAliasTMP)->ZL6_PRODUT + (cAliasTMP)->ZL6_LOJPRD )
            
		// limpeza das variแveis
		cKeyNDF    := STRING_Null
        cKeyNFE    := STRING_Null
        cCODCLI    := STRING_Null
        cLOJCLI    := STRING_Null
        aKeyNFS    := {}
        aKeyNFE    := {} 
        nVLR_NFS   := 0
        nVLR_DESP  := 0
        nPRC_LITRO := 0
        nPRC_FRETE := 0
            
        cMENSAGEM := "0-PRODUTOR: "+(cAliasTMP)->ZL6_PRODUT+"/"+(cAliasTMP)->ZL6_LOJPRD+" - LINHA: "+(cAliasTMP)->ZL5_LINHA
        fWrtFile(cMENSAGEM)
            
		
		// recupera o valor por litro de leite produzido
        fCalcProd( nEXCECAO, (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL6_QTDE, @nPRC_LITRO, @nPRC_FRETE )
        cMENSAGEM := "1-QTDE LEITE: "+cValToChar((cAliasTMP)->ZL6_QTDE)+" - PRECO LITRO: "+cValToChar(nPRC_LITRO)
        fWrtFile(cMENSAGEM)
        	        	
        	
        // se encontrou o valor por litro e se a quantidade produzida for maior que zero
        If nPRC_LITRO != 0 .and. (cAliasTMP)->ZL6_QTDE > 0


			//-- Controle de serie de nota fiscal diferentes.
			If lATPERCFOR
				
				//-- Documento ๚nico
				If SA2->A2_X_PCDOC == 100 .or. SA2->A2_X_PCDOC == 0

					//inclusใo do documento de entrada do produtor        	
		   			If SA2->A2_X_PCDOC == 100
		   				Aviso("Documento Entrada","Produtor: "+ALLTRIM(SA2->A2_NOME)+" possui 100% para gera็ใo documento de entrada.",{"OK"},1)
		   				cTpEntrada := "1"
		   			Else
		   				Aviso("Documento Entrada","Produtor: "+ALLTRIM(SA2->A2_NOME)+" possui percentual 0 para gera็ใo documento de entrada.",{"OK"},1)
		   				cTpEntrada := "2"
		   			EndIf
		   			fIncNFE( (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL6_QTDE, nPRC_LITRO, @cNUMDOC, @cSERDOC, @cKeyNFE, @aKeyNFE, cTpEntrada, dEND_DATE, nPRC_FRETE)
		
		            cMENSAGEM := "2-DOC ENTRADA: "+cNUMDOC+"/"+cSERDOC
		            fWrtFile(cMENSAGEM)  
				
				Else
					
					nQTDDOC1 := int( ( (cAliasTMP)->ZL6_QTDE * SA2->A2_X_PCDOC ) / 100 )
					nQTDDOC2 := (cAliasTMP)->ZL6_QTDE - nQTDDOC1
				
					//inclusใo do documento de entrada do produtor        	
		   			Aviso("Documento Entrada","Produtor: "+ALLTRIM(SA2->A2_NOME)+" com "+cValToChar(SA2->A2_X_PCDOC)+"% para gera็ใo documento de entrada.",{"OK"},1)
		   			fIncNFE( (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, nQTDDOC1, nPRC_LITRO, @cNUMDOC, @cSERDOC, @cKeyNFE, @aKeyNFE, "1", dEND_DATE, nPRC_FRETE)
		            cMENSAGEM := "2-DOC ENTRADA PERCENTUAL CADASTRO: "+cNUMDOC+"/"+cSERDOC
		            fWrtFile(cMENSAGEM)  


					//inclusใo do documento de entrada do produtor        	
		   			Aviso("Documento Entrada","Produtor: "+ALLTRIM(SA2->A2_NOME)+" com percentual restante para gera็ใo documento de entrada.",{"OK"},1)
		   			fIncNFE( (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, nQTDDOC2, nPRC_LITRO, @cNUMDOC, @cSERDOC, @cKeyNFE, @aKeyNFE, "2", dEND_DATE, nPRC_FRETE)
		            cMENSAGEM := "2-DOC ENTRADA RESTANTE: "+cNUMDOC+"/"+cSERDOC
		            fWrtFile(cMENSAGEM)  
				
				EndIf
			
			Else
						
				//inclusใo do documento de entrada do produtor        	
	   			fIncNFE( (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL6_QTDE, nPRC_LITRO, @cNUMDOC, @cSERDOC, @cKeyNFE, @aKeyNFE, "1", dEND_DATE, nPRC_FRETE)
	
	            cMENSAGEM := "2-DOC ENTRADA: "+cNUMDOC+"/"+cSERDOC
	            fWrtFile(cMENSAGEM)  
			
			EndIf
           	
           	// altera็ใo do status dos movimentos de coleta de leite processados do produtor
	    	cENDMOV := STRING_Null    
	    	fCloseProd(dSTART_DATE, dEND_DATE, cLINHA_DE, cLINHA_ATE, (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, cNUMDOC, cSERDOC, @cENDMOV, nPRC_LITRO, nPRC_FRETE)
            cMENSAGEM := "3-MOVIMENTOS DE ENTRADA ENCERRADOS: "+cENDMOV
            fWrtFile(cMENSAGEM)             	        	    
	    	
	  	Else

	  		//--Inclusใo/exclusใo da tabela tipo EXCECAO para o produtor.
	  		If (cAliasTMP)->ZL6_QTDE == 0 .and. SuperGetMV("MV_ZLAITE",,.F.) 
	  		
	  			dbSelectArea("ZL1")
	  			dbSetOrder(3)	//--ZL1_FILIAL+ZL1_COD+ZL1_PRODUT+ZL1_LOJPRD
	  			dbGoTop()
	  			If dbSeek( xFilial("ZL1") + (cAliasTMP)->ZL5_LINHA + (cAliasTMP)->ZL6_PRODUT + (cAliasTMP)->ZL6_LOJPRD )
	  				If RecLock("ZL1",.F.)               
	  				
						//--Limpeza dos campos da linha no cadastro do produtor
						RecLock("SA2",.F.)
						SA2->A2_X_LINHA := ""//M->ZL0_COD
						SA2->A2_X_NOMLI := ""//M->ZL0_DESC
						SA2->(MsUnLock())
					
						//--Exclusใo da tabela tipo EXCECAO para o produtor.
						dbSelectArea("ZL2")
						dbSetOrder(3)	//--ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
						dbGoTop()
						If dbSeek ( xFilial("ZL2") + (cAliasTMP)->ZL5_LINHA + (cAliasTMP)->ZL6_PRODUT + (cAliasTMP)->ZL6_LOJPRD )
							RecLock("ZL2",.F.)
							ZL2->(dbDelete())
							ZL2->(MsUnLock())
						EndIf       
						
						  					
	  					//--Elimina relacionamento produtor x linha
	  					ZL1->(dbDelete())
	  					ZL1->(MsUnLock())
	  					
			  			cMENSAGEM := "5-QUANTIDADE ZERO - TABELA PRECO EXCLUIDA."
			    		fWrtFile(cMENSAGEM)
			  					
	  				EndIf
	  			EndIf
	  			
	  		Else
	  		
	  			cMENSAGEM := "5-TABELA DE PRECO NAO LOCALIZADA/QUANTIDADE ZERO."
	    		fWrtFile(cMENSAGEM)
	    	
	    	EndIf

		EndIf     
        	
         IncProc()		    		    	
    	(cAliasTMP)->(dbSkip())
   		
	EndDo
    
	LimpaInativos(dEND_DATE, cLINHA_DE, cLINHA_ATE, nORDPROC)
    	
	cMENSAGEM := "FIM DO PROCESSAMENTO."
	fWrtFile(cMENSAGEM)
	fEndFile()
	
	(cAliasTMP)->(dbCloseArea())
	
Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบบAutor  ณAlexandre longhinotti                    บ Data ณ  10/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLimpa a linha e elimina tabela de pre็os do produtor inativoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LimpaInativos(dEND_DATE, cLINHA_DE, cLINHA_ATE, nORDPROC)   

Local cAliasTMP2   := GetNextAlias() 
Local cAliasTMP3   := GetNextAlias()   
Local hEnter	   := CHR(13) + CHR(10) 
Local nQtdProd := 0                       
Local mes
Local ano
Local dSTART_DATEx

/*If val(substr(dtos(dEND_DATE), 6,1)) == 1
     mes := 12
     ano := val(substr(dtos(dEND_DATE), 1,4)) -1
Else
     mes := val(substr(dtos(dEND_DATE), 6,1))	 - 1
     ano := val(substr(dtos(dEND_DATE), 1,4))
EndIf
*/
mes := val(substr(dtos(dEND_DATE), 6,1))
ano := val(substr(dtos(dEND_DATE), 1,4))

dSTART_DATEx := ctod("01/"+StrZERO(mes,2)+"/"+StrZERO(ano,4))

If (Select(cAliasTMP2) <> 0)
	dbSelectArea(cAliasTMP2)
	(cAliasTMP2)->(dbCloseArea())
Endif

cQuery := "SELECT 	SA2.A2_COD,												" + hEnter   
cQuery += "			SA2.A2_LOJA,											" + hEnter
cQuery += "			SA2.A2_X_LINHA											" + hEnter
cQuery += "FROM " + RetSqlName("SA2") + " SA2								" + hEnter
cQuery += "WHERE    SA2.A2_X_TIPO    = 'P'						 			" + hEnter
cQuery += "AND 		( SA2.A2_X_LINHA  BETWEEN '" + cLINHA_DE   + "'	 		" + hEnter
cQuery += "AND      	           		     '" + cLINHA_ATE  + "' )		" + hEnter
cQuery += "AND 		SA2.A2_LOJA   < '9999'									" + hEnter
cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 								" + hEnter	

TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP2)
	
dbselectarea(cAliasTMP2)
(cAliasTMP2)->(dbgotop())
	
while !(cAliasTMP2)->(EOF())

nQtdProd:= 0	

	If (Select(cAliasTMP3) <> 0)
		dbSelectArea(cAliasTMP3)
		(cAliasTMP3)->(dbCloseArea())
	Endif
	
	cQuery := "SELECT 	SUM(ZL6.ZL6_QTDE) ZL6_QTDE,							   		" + hEnter
	cQuery += "			ZL5.ZL5_LINHA,												" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
	cQuery += "			SA2.A2_NOME													" + hEnter	
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6		   						" + hEnter
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL  	               		" + hEnter		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD         	        	   	" + hEnter		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" + hEnter
	cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	" + hEnter		
	cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	" + hEnter		
	cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "'	 			" + hEnter
	cQuery += "AND 		ZL5.ZL5_DATA   >= '" + DTOS(dSTART_DATEx) + "'				" + hEnter
	cQuery += "AND 		ZL6.ZL6_PRODUT = '" + (cAliasTMP2)->A2_COD + "'				" + hEnter
	cQuery += "AND 		ZL6.ZL6_LOJPRD = '" + (cAliasTMP2)->A2_LOJA +  "'			" + hEnter                                                                 	
	cQuery += "AND 		ZL6.ZL6_QTDE   > 0		 									" + hEnter
	cQuery += "AND 		ZL5.D_E_L_E_T_   != '*' 									" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_   != '*' 									" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 									" + hEnter
	cQuery += "GROUP BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 								" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD, SA2.A2_NOME									" + hEnter
	If nORDPROC == 1
		cQuery += "ORDER BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, ZL6.ZL6_LOJPRD			" + hEnter
	Else                                                                                  
		cQuery += "ORDER BY ZL5.ZL5_LINHA, SA2.A2_NOME								" + hEnter
	EndIf
                        
	memowrite("LTMOV003_1x.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP3)
	
	dbSelectArea(cAliasTMP3)
	(cAliasTMP3)->(dbGoTop())
	ProcRegua((cAliasTMP3)->(RecCount()))
	
	While (cAliasTMP3)->(!EOF())
	
		nQtdProd := (cAliasTMP3)->ZL6_QTDE
		(cAliasTMP3)->(dbskip()) 
		
	EndDo

	(cAliasTMP3)->(dbCloseArea())
	
	//--Inclusใo/exclusใo da tabela tipo EXCECAO para o produtor.
	If nQtdProd == 0 .and. SuperGetMV("MV_ZLAITE",,.F.) 
	  		

			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek ( xFilial("SA2") + (cAliasTMP2)->A2_COD + (cAliasTMP2)->A2_LOJA )
			
			dbSelectArea("ZL1")
  			dbSetOrder(3)	//--ZL1_FILIAL+ZL1_COD+ZL1_PRODUT+ZL1_LOJPRD
  			dbGoTop()
  			If dbSeek( xFilial("ZL1") + (cAliasTMP2)->A2_X_LINHA + (cAliasTMP2)->A2_COD + (cAliasTMP2)->A2_LOJA )
  				If RecLock("ZL1",.F.)               
  				
					//--Limpeza dos campos da linha no cadastro do produtor
					RecLock("SA2",.F.)
					SA2->A2_X_LINHA := ""//M->ZL0_COD
					SA2->A2_X_NOMLI := ""//M->ZL0_DESC
					SA2->A2_MSBLQL  := "1"
					SA2->(MsUnLock())
					
					//--Exclusใo da tabela tipo EXCECAO para o produtor.
					dbSelectArea("ZL2")
					dbSetOrder(3)	//--ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
					dbGoTop()
					If dbSeek ( xFilial("ZL2") +(cAliasTMP2)->A2_X_LINHA + (cAliasTMP2)->A2_COD + (cAliasTMP2)->A2_LOJA )
						RecLock("ZL2",.F.)
						ZL2->(dbDelete())
						ZL2->(MsUnLock())
					EndIf       
						
						  					
	  				//--Elimina relacionamento produtor x linha
	  				ZL1->(dbDelete())
	  				ZL1->(MsUnLock())
	  					
			  					
	  			EndIf
	  		EndIf
	  			  			    	
	EndIf
	(cAliasTMP2)->(dbskip())
enddo
	(cAliasTMP2)->(dbCloseArea())

Return

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
/*
Static Function fRecCLIENTE( cPRODUT, cLOJPRD, cCODCLI, cLOJCLI )
Local lRet       := .F.
Local cAliasCLI  := GetNextAlias()
Local hEnter	 := CHR(13) + CHR(10)

	cCODCLI := STRING_Null
	cLOJCLI := STRING_Null

	If (Select(cAliasCLI) <> 0)
		dbSelectArea(cAliasCLI)
		(cAliasCLI)->(dbCloseArea())
	Endif
			    
	cQuery := "SELECT 	SA1.A1_COD, SA1.A1_LOJA						" + hEnter
	cQuery += "FROM " + RetSqlName("SA1") + " SA1					" + hEnter
	cQuery += "WHERE    SA1.A1_FILIAL   = '" + xFilial("SA1") + "' 	" + hEnter
	cQuery += "AND 		SA1.A1_X_FORN   = '" + cPRODUT + "' 		" + hEnter
	cQuery += "AND 		SA1.A1_X_LOJF   = '" + cLOJPRD + "' 		" + hEnter			
	cQuery += "AND 		SA1.D_E_L_E_T_ != '*' 						" + hEnter
		                        
	memowrite("LTMOV003_2.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasCLI)
		
	dbSelectArea(cAliasCLI)
	(cAliasCLI)->(dbGoTop())
	
	If ! Empty ( (cAliasCLI)->A1_COD ) .and. ! Empty ( (cAliasCLI)->A1_LOJA )
		cCODCLI := (cAliasCLI)->A1_COD
		cLOJCLI := (cAliasCLI)->A1_LOJA
		lRet    := .T.		
	EndIf		            
    
    (cAliasCLI)->(dbCloseArea())
    
Return ( lRet )

*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalcProd  บAutor  ณRafael Parma       บ Data ณ  13/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo do pre็o a ser pago ao produtor com base nas      บฑฑ
ฑฑบ          ณtabelas de pre็os por faixa ou tabela de exce็ใo.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/              
 
Static Function fCalcProd( nEXCECAO, cPRODUT, cLOJPRD, cLINHA, nQTD_PROD, nPRC_LITRO, nPRC_FRETE )

	nPRC_LITRO := 0
	nPRC_FRETE := 0
	
	If nEXCECAO == 1 // Cadastro do produtor
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("SA2") + cPRODUT + cLOJPRD )
			If ! Empty ( SA2->A2_X_FAIXA )
				dbSelectArea("ZL2")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial("ZL2") + SA2->A2_X_FAIXA )
					nPRC_LITRO := ZL2->ZL2_PRCLEI	
					nPRC_FRETE := ZL2->ZL2_PRCFRT
				EndIf
			Else
				dbSelectArea("ZL2")
				dbSetOrder(2)
				dbGoTop()   
				If dbSeek ( xFilial("ZL2") + cLINHA )
					While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
						If nQTD_PROD >= ZL2->ZL2_FXINI .and. nQTD_PROD <= ZL2->ZL2_FXFIN 
							nPRC_LITRO := ZL2->ZL2_PRCLEI
							nPRC_FRETE := ZL2->ZL2_PRCFRT
							Exit
						EndIf
						ZL2->(dbSkip())
					EndDo
				EndIf
			EndIf	
		EndIf
	
	Else		// tabela de exce็๕es

		dbSelectArea("ZL2")
		dbSetOrder(3)	// ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
		dbGoTop()                                            
		If dbSeek ( xFilial("ZL2") + cLINHA + cPRODUT + cLOJPRD, .T. )
			nPRC_LITRO := ZL2->ZL2_PRCLEI                
			nPRC_FRETE := ZL2->ZL2_PRCFRT
		Else
			dbSelectArea("ZL2")
			dbSetOrder(2)	// // ZL2_FILIAL+ZL2_LINHA
			dbGoTop()   
			If dbSeek ( xFilial("ZL2") + cLINHA )
				While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
					If nQTD_PROD >= ZL2->ZL2_FXINI .and. nQTD_PROD <= ZL2->ZL2_FXFIN 
						nPRC_LITRO := ZL2->ZL2_PRCLEI
						nPRC_FRETE := ZL2->ZL2_PRCFRT
						Exit
					EndIf
					ZL2->(dbSkip())
				EndDo
			EndIf
		EndIf
	
	EndIf
	
		
Return 




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIncNFE    บAutor  ณRafael Parma       บ Data ณ  13/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de inclusใo do documento de entrada do produtor.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function fIncNFE(cFORNECE, cLOJFOR, cCODLIN, nQTDE, nVUNIT, cNUMDOC, cSERDOC, cKeyNFE, aKeyNFE, cNf1_2, dEND_DATE, nPRC_FRETE)
Local aAreaTMP    := GetArea()
Local nLenITEM    := TamSX3("D1_ITEM")[1]			  				// tamanho do campo no dicionแrio
Local cTipoNF     := SuperGetMv("MV_TPNRNFS")		   				// tipo do controle de numera็ใo NF
//Local cMV_ZLTTMV  := AllTRIM(GetMV("MV_ZLTTMV")) 	   				// tipo do movimento de inclusใo do estoque valorizado
Local cMV_ZLTLOC  := AllTRIM(GetMV("MV_ZLTLOC"))	  				// armazem do movimento
Local cMV_ZLTPRD  := AllTRIM(GetMV("MV_ZLTPRD"))	   				// c๓digo do produto
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// c๓digo da TES de movimento
Local cMV_ZLTCPG  := AllTRIM(GetMV("MV_ZLTCPG"))	   				// c๓digo da condi็ใo de pagamento
Local lTITFRETE   := SuperGetMV("MV_ZLHTFR",,.F.)	   				// Habilita gera็ใo de tํtulos de frete a pagar/receber no fechamento mensal do produtor.
Local lLIMITITUL  := SuperGetMV("MV_ZLCPCH",,.F.)	   				// Utiliza controle de limite de valor para gera็ใo de tํtulos
Local nLIMITITUL  := SuperGetMV("MV_ZLVALT",,5000)	   				// Valor limite para gera็ใo de tํtulos
Local cPREFIXTIT  := SuperGetMV("MV_ZLPTFR",,"")	   				// Prefixo do tํtulo de frete a pagar/receber 
Local cNATTITREC  := SuperGetMV("MV_ZLNRFR",,"")					// Natureza do tํtulo de frete a receber
//Local cNATTITPAG  := SuperGetMV("MV_ZLNPFR",,"")					// Natureza do tํtulo de frete a pagar       
Local cLISTCONDP  := SuperGetMV("MV_ZLCPCD",,cMV_ZLTCPG)			// Lista condi็๕es de pagamento para parcelas                                            
Local lMV_CTLIPAG := SuperGetMV("MV_CTLIPAG",,.F.)					// Utiliza controle de liberacao de titulos a pagar
Local lMV_LTRENFP := SuperGetMV("MV_LTRENFP")				   		// Utiliza customizacao que referencia NFP 
Local cMV_ZLLIPAR := SuperGetMV("MV_ZLLIPAR",,1999) 	   			// Quantidade limite para gera็ใo de tํtulo com parcela ๚nica
Local nVALTOTDOC  := Round( nQTDE * nVUNIT, TAMSX3("D1_TOTAL")[2])	// Valor total do documento                                                              
Local cTIPO_TIT   := "NF "
Local aCab        := {}
Local aItens      := {}
Local aLinha      := {}
Local nZ
Private cNumero   := STRING_Null
Private cSerie    := STRING_Null 
Private cNumNFP   := STRING_Null
Private cSerieNFP := STRING_Null 
Private lMsErroAuto := .F.                           

	if cNf1_2 = "2" 
		cMV_ZLTTES := AllTRIM(GetMV("MV_ZLTTES2"))		// c๓digo da TES para diferenca de % de DOC
	endif
               
	//-- utiliza condi็ใo pagamento do produtor caso volume seja maior que o parametro MV_ZLLIPAR
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek ( xFilial("SA2") + cFORNECE + cLOJFOR )
	
	If SuperGetMV("MV_ZLUCPP",,.F.) .And. nQTDE > cMV_ZLLIPAR 
		If !Empty(SA2->A2_COND)
			cMV_ZLTCPG := SA2->A2_COND
		EndIf
	EndIf  
	
	If nQTDE <= cMV_ZLLIPAR .And. SA2->A2_COND = "708"
	     	cMV_ZLTCPG := "704"
	EndIf
	
	              
	//-- Utiliza condi็ใo de pagamento com parcelas, tํtulos com valor inferior a R$ 5000,00
	If lLIMITITUL
        
        //Somente utilizada quando forma de pagamento diferente de deposito.
        If SA2->A2_X_FPGTO != "D"	
        
	        //-- N๚mero de parcelas.
			nPARCEL  := int(nVALTOTDOC/nLIMITITUL)
			If nPARCEL > 9
				Aviso("Aten็ใo","Valor do documento ultrapassa n๚mero de parcelas (10) para gera็ใo de tํtulos, por favor informar ao Administrador do sistema.",{"OK"},2)
				nPARCEL	:= 0
			EndIf                                                                     
			
			//-- Caso seja zero utiliza condi็ใo de pagamento do parโmetro/fornecedor.
			If nPARCEL > 0	
				cCONDTMP := cLISTCONDP
				For nZ := 1 to nPARCEL
					nPOS := At(",",cCONDTMP)
					If nPOS > 0     
				    	cCONDTMP := SubSTR(cCONDTMP,nPOS+1,Len(cCONDTMP))
					EndIf
				Next nZ
				If nPOS > 0
			    	cCONDTMP := SubSTR(cCONDTMP,1,TAMSX3("E4_CODIGO")[1])
			    	If ExistCPO("SE4",cCONDTMP)
			    		cMV_ZLTCPG := cCONDTMP
			    	EndIf
			    EndIf
			EndIf
	
		EndIf
	
	EndIf          

	If cSERIENF == ""
		dbSelectArea("SF1") 
		lRetorno := SX5NumNota(.F.,cTipoNF)
		DO WHILE !lRetorno
	    	lRetorno := SX5NumNota(.F.,cTipoNF)
	    ENDDO
	    NxTSx5Nota(cSerie,.T.)    
	    cSERIENF := cSerie
	Else	
		lRetorno := .T.
		cSerie  := cSERIENF    
		cNumero := NxTSx5Nota(cSerie, .T., cTipoNF, .T.)  
	EndIf
			
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Validacao da NF informada pelo usuario                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lRetorno
		SF1->(dbSetOrder(1))
		If SF1->(MsSeek(xFilial("SF1")+cNumero+cSerie+cFORNECE+cLOJFOR,.F.))
			Help(" ",1,"EXISTNF")
			lRetorno := .F.
			cNumero:= STRING_Null
			cSerie := STRING_Null
			Return
		EndIf
	EndIf
	
	cNUMDOC := cNumero
	cSERDOC := cSerie
		
	//-- Cabecalho da nota fiscal de entrada.
	Aadd( aCab, { 'F1_FILIAL'	, xFilial("SF1")	 							, Nil } )	// Numero da NF
	Aadd( aCab, { 'F1_DOC'		, cNumero			 							, Nil } )	// Numero da NF
	Aadd( aCab, { 'F1_SERIE'	, cSerie			 							, Nil } )	// Serie da NF
	Aadd( aCab, { 'F1_TIPO'		, 'N'				 							, Nil } )	// Tipo da NF
	Aadd( aCab, { 'F1_FORNECE'	, SubSTR(cFORNECE,1,TamSX3("F1_FORNECE")[1])	, Nil } )	// Codigo do Fornecedor
	Aadd( aCab, { 'F1_LOJA'		, SubSTR(cLOJFOR,1,TamSX3("F1_LOJA")[1])		, Nil } )	// Loja do Fornecedor
	Aadd( aCab, { 'F1_EMISSAO'	, dDataBase			 							, Nil } )	// Emissao da NF
	Aadd( aCab, { 'F1_FORMUL'	, 'S'				 							, Nil } )	// Formulario
	Aadd( aCab, { 'F1_ESPECIE'	, 'SPED'			 							, Nil } )	// Especie
	Aadd( aCab, { 'F1_COND'		, cMV_ZLTCPG		 							, Nil } )	// Condicao de pagamento
	Aadd( aCab, { 'F1_X_LINHA'	, cCODLIN			 							, Nil } )	// C๓digo da linha de coleta
	
	//-- Itens da nota fiscal de entrada.
	cItem	:= StrZero( 1, nLenITEM )    	
	Aadd( aLinha, { 'D1_ITEM'   , cItem				 , Nil } )	// Item da nota fiscal
	Aadd( aLinha, { 'D1_LOCAL'  , cMV_ZLTLOC         , Nil } )	// Codigo do armazem
	Aadd( aLinha, { 'D1_QUANT'  , nQTDE		         , Nil } )	// Quantidade do produto
	Aadd( aLinha, { 'D1_COD'    , cMV_ZLTPRD		 , Nil } )	// Codigo do produto
	Aadd( aLinha, { 'D1_VUNIT'  , nVUNIT             , Nil } )	// Valor unitario
	Aadd( aLinha, { 'D1_TOTAL'  , nVALTOTDOC		 , Nil } )	// Valor total
	Aadd( aLinha, { 'D1_TES'    , cMV_ZLTTES		 , Nil } )	// Tipo de entrada da nota
    Aadd(aItens,aLinha)
	cKeyNFE := xFilial("SF1") + cSerie + cNumero + cTIPO_TIT
	
	AAdd ( aKeyNFE , { xFilial("SF1")	, ;	
					   cSerie		 	, ;
					   cNumero			, ;
					   cTIPO_TIT	    } )


    cMENSAGEM := 'F1_FILIAL-'+xFilial("SF1")+'=F1_DOC-'+cNumero+'=F1_SERIE-'+cSerie+'=F1_TIPO-'+'N'+'=F1_FORNECE-'+cFORNECE+'=F1_LOJA-'+cLOJFOR+'=F1_FORMUL-S'+'=F1_COND-'+cMV_ZLTCPG+'=F1_X_LINHA-'+cCODLIN
    fWrtFile(cMENSAGEM)
    cMENSAGEM := 'D1_ITEM-'+cItem+'=D1_LOCAL-'+cMV_ZLTLOC+'=D1_QUANT-'+str(nQTDE)+'=D1_COD-'+cMV_ZLTPRD+'=D1_VUNIT-'+str(nVUNIT)+'=D1_TES-'+cMV_ZLTTES
    fWrtFile(cMENSAGEM)

					   
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณReinicializa ambiente para os calculos Fiscaisณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If MaFisFound()
		MaFisEnd()
	EndIf

	//-- Gera nota fiscal de entrada. 
	nOldMod := nModulo
	nModulo := 2
	MSExecAuto( {|x,y,z| MATA103( x,y,z ) }, aCab, aItens, 3 )
	nModulo :=nOldMod
 	
 	If lMsErroAuto
		MostraErro()
	Else                        
   		// Grava numero da nota da tabela das NFP
		If lMV_LTRENFP
				dbSelectArea("ZLJ")
				dbSetOrder(1)
				dbGoTop()   
				If dbSeek ( xFilial("ZLJ") + cFORNECE + cLOJFOR )
					While ! ZLJ->(EOF()) .and. ZLJ->ZLJ_FILIAL + ZLJ->ZLJ_COD + ZLJ->ZLJ_LOJA == xFilial("ZLJ") + cFORNECE + cLOJFOR
                        If Empty(Alltrim(ZLJ->ZLJ_NFCOMP)) .and. ZLJ->ZLJ_VALNF >= dDataBase
							RecLock("ZLJ",.F.)
							ZLJ->ZLJ_NFCOMP := cNumero
							ZLJ->ZLJ_SERIEC := cSerie
							ZLJ->ZLJ_EMISSA := dDataBase
							cNumNFP 		:= ZLJ->ZLJ_NUMNF
							cSerieNFP       := ZLJ->ZLJ_SERIEP
							Exit
                         EndIf
                       	ZLJ->(dbSkip())
					EndDo
				EndIf
		EndIF		
	    //-- Grava o c๓digo da linha na NF    
	    If !SF1->(EOF()) .AND. RecLock("SF1",.F.)
	    	SF1->F1_X_LINHA := cCODLIN
	   		If lMV_LTRENFP
		    	SF1->F1_X_NFP := cNumNFP     // F1_X_NFP
	    		SF1->F1_X_SNFP := cSerieNFP   //F1_X_SNFP 
    		EndIf
	    	SF1->(MsUnLock())
	    EndIf
	                                    
		//-- Atualiza variแveis de custo do estoque --//
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			dbSelectArea("SB9")
			dbSetOrder(1)
			dbGoTop()                
			cMV_ZLTPRD := cMV_ZLTPRD + Space(TAMSX3("D1_COD")[1]-Len(cMV_ZLTPRD))
			cMV_ZLTLOC := cMV_ZLTLOC + Space(TAMSX3("D1_LOCAL")[1]-Len(cMV_ZLTLOC))			
			If dbSeek( xFilial("SB9") + cMV_ZLTPRD + cMV_ZLTLOC + dtos(dEND_DATE) )
	        	While !SD1->(EOF()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
					RecLock("SD1",.F.)
					SD1->D1_X_DTFEC	:= dEND_DATE
					SD1->D1_X_CMFEC := SB9->B9_VINI1 / SB9->B9_QINI
					SD1->D1_X_DIFCM := SD1->D1_VUNIT - SD1->D1_X_CMFEC
					SD1->D1_X_FECCM := "N"
					SD1->(MsUnLock())
					SD1->(dbSkip())
				Enddo
			EndIf
		EndIf		                                    
	                                    
		// Grava o c๓digo da linha nos tํtulos
		
		dVCTO1DUP := ctod("")
		dbSelectArea("SE2")
		dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		dbGoTop()                       
		If dbSeek ( xFilial("SE2") + SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC) )
			While !SE2->(EOF()) .and. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == xFilial("SE2") + SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
				
				If RecLock("SE2",.F.)
					
					SE2->E2_X_LINHA := cCODLIN

					If lLIMITITUL .AND. dVCTO1DUP == ctod("")
						dVCTO1DUP := SE2->E2_VENCREA
						SE2->E2_VENCTO  := dVCTO1DUP
					ElseIf lLIMITITUL
						SE2->E2_VENCTO  := dVCTO1DUP
						SE2->E2_VENCREA := dVCTO1DUP
					ElseIf ! lLIMITITUL .AND. dVCTO1DUP == ctod("")
						dVCTO1DUP := SE2->E2_VENCREA
					EndIf	 
					    
					
					//--controle liberacao para pagamento
					If lMV_CTLIPAG 
						If RecLock("SE2",.F.)
							SE2->E2_DATALIB := SE2->E2_EMISSAO
							//SE2->(MsUnLock())
						EndIf
					EndIf                        
						                                                                                   
					
					//--pagamento com deposito
					If Type("SA2->A2_X_NOMDP") != "U"
						If SA2->A2_X_FPGTO == "D"
							SE2->E2_X_BCODP := SA2->A2_BANCO
							SE2->E2_X_AGDEP := SA2->A2_AGENCIA
							SE2->E2_X_CTADP := SA2->A2_NUMCON
							SE2->E2_X_FAVDP := IIF(!Empty(SA2->A2_X_NOMDP),SA2->A2_X_NOMDP,SA2->A2_NOME)
							SE2->E2_X_TPPSD := IIF(!Empty(SA2->A2_X_TPPSD),SA2->A2_X_TPPSD,SA2->A2_TIPO)
							SE2->E2_X_CGCDP := IIF(!Empty(SA2->A2_X_CGCDP),SA2->A2_X_CGCDP,SA2->A2_CGC)					
						EndIf  					
					EndIf
					
					SE2->(MsUnLock())
				EndIf
				SE2->(dbSkip())
			Enddo
		EndIf  
		/* 
		dbSelectArea("SE2") // Altera a natureza dos tํtulos de INSS 
		dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		dbGoTop()                       
	  	If dbSeek ( SF1->F1_FILIAL + "29979036 " + "0000" + SF1->(F1_SERIE+F1_DOC) )
	  		While !SE2->(EOF()) .and. SE2->E2_TIPO = 'TX' .and. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->F1_FILIAL+"29979036 "+"0000"+SF1->(F1_SERIE+F1_DOC)
				If RecLock("SE2",.F.)
					SE2->E2_NATUREZ := "20402007"
					//SE2->E2_TIPO := "TX"		
					SE2->(MsUnLock())
				EndIf	
				SE2->(dbSkip())		
			Enddo  
		Endif		
		*/
		//--Habilita gera็ใo de tํtulos de frete a pagar/receber 
		If lTITFRETE .and. nPRC_FRETE > 0
                        
			//-- utiliza condi็ใo pagamento do produtor
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek ( xFilial("SA2") + cFORNECE + cLOJFOR )
			
			dbSelectArea("ZL0")
			dbSetOrder(1)
			If dbSeek ( xFilial("ZL0") + cCODLIN )
			
				dbSelectArea("SA4")
				dbSetOrder(1)
				If dbSeek ( xFilial("SA4") + ZL0->ZL0_TRANSP )
					
					If !Empty(SA4->A4_X_FORN) .and. !Empty(SA4->A4_X_LOJF)
						dbSelectArea("SA2")
						dbSetOrder(1)
						If dbSeek ( xFilial("SA2") + SA4->A4_X_FORN + SA4->A4_X_LOJF )
							
							If SA2->A2_TIPO == "F"
								          
								//-- Inclusใo do tํtulo a pagar do transportador
								lMsErroAuto := .F.
								aFina050 := {}
                                
							    //****************************************************
								// vencimento frete conforme cond pagto 701

								aPARCELA := Condicao(nPRC_FRETE*nQTDE, "902", 0)
								dVencFrt := aPARCELA[01][01]
								
								//***************************************************

								AADD(aFina050, {"E2_FILIAL" , xFilial("SE2")                       				, Nil})
								AADD(aFina050, {"E2_PREFIXO", cPREFIXTIT                           				, Nil})
						        AADD(aFina050, {"E2_NUM"    , cNumero				            				, Nil})
						        AADD(aFina050, {"E2_PARCELA", Space(TAMSX3("E1_PARCELA")[1])					, Nil})
						        AADD(aFina050, {"E2_TIPO"   , "DP "			                       				, Nil})
						        AADD(aFina050, {"E2_FORNECE", SA2->A2_COD	                      				, Nil})
						        AADD(aFina050, {"E2_LOJA"   , SA2->A2_LOJA                        				, Nil})
						        AADD(aFina050, {"E2_NATUREZ", cNATTITREC		                   				, Nil})
						        AADD(aFina050, {"E2_EMISSAO", ddatabase		                     				, Nil})   
						        AADD(aFina050, {"E2_VENCTO" , dVencFrt		                     				, Nil})
						        AADD(aFina050, {"E2_VENCREA", dVencFrt					         				, Nil})
						        AADD(aFina050, {"E2_VALOR"  , nPRC_FRETE*nQTDE                     				, Nil})
						        AADD(aFina050, {"E2_FLUXO"  , "S"			                     			 	, Nil})
						        AADD(aFina050, {"E2_HIST"   , "TIT. FRETE NF: "+cNumero+"/"+cSerie             	, Nil})
								AADD(aFina050, {"E2_MOEDA"  , 1													, Nil})
						        AADD(aFina050, {"E2_X_LINHA", cCODLIN							             	, Nil})						        

								nOldMod := nModulo
								nModulo := 6  						        
						        MSExecAuto({|x,y,z| Fina050(x, y, z)}, aFina050,, 3)
						        nModulo :=nOldMod
						        
						        If lMsErroAuto
						        	conout(mostraerro())
						        	MostraErro()
						        EndIf
                                
                                If !lMsErroAuto
								
									/*--controle liberacao para pagamento
									If lMV_CTLIPAG 
										If RecLock("SE2",.F.)
											SE2->E2_DATALIB := SE2->E2_EMISSAO
											//SE2->(MsUnLock())
										EndIf
									EndIf                        
					                */

									//--Inclusใo do tํtulo a receber do produtor

									dbSelectArea("SA1")
									dbSetOrder(14)	// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
									If dbSeek ( xFilial("SA1") + cFORNECE + cLOJFOR ) 
									
									
										lMsErroAuto := .F.
										aFina040 := {}
										
									   	//****************************************************
										// vencimento frete a compensar conforme cond pagto 902


										aPARCELA := Condicao(nPRC_FRETE*nQTDE, "902", 0)
										dVencFrt := aPARCELA[01][01]
										
							  			//***************************************************			
										
										AADD(aFina040, {"E1_FILIAL"  , xFilial("SE1")								, Nil})
										AADD(aFina040, {"E1_PREFIXO" , cPREFIXTIT									, Nil})
										AADD(aFina040, {"E1_NUM"	 , cNumero										, Nil})
										AADD(aFina040, {"E1_PARCELA" , Space(TAMSX3("E1_PARCELA")[1])				, Nil})
										AADD(aFina040, {"E1_TIPO"	 , "DP "										, Nil})
										AADD(aFina040, {"E1_CLIENTE" , SA1->A1_COD									, Nil})
										AADD(aFina040, {"E1_LOJA"	 , SA1->A1_LOJA									, Nil})
										AADD(aFina040, {"E1_NATUREZ" , cNATTITREC	  								, Nil})
										AADD(aFina040, {"E1_EMISSAO" , ddatabase									, Nil})
										AADD(aFina040, {"E1_VENCTO"  , dVencFrt   									, Nil})
										AADD(aFina040, {"E1_VENCREA" , dVencFrt										, Nil})
										AADD(aFina040, {"E1_VALOR"   , nPRC_FRETE*nQTDE								, Nil})
										AADD(aFina040, {"E1_FLUXO"   , "S"											, Nil})
										AADD(aFina040, {"E1_HIST"    , "TIT. FRETE NF: "+cNumero+"/"+cSerie			, Nil})
										AADD(aFina040, {"E1_MOEDA"   , 1											, Nil})	
										AADD(aFina040, {"E1_X_LINHA" , cCODLIN										, Nil})

										nOldMod := nModulo
										nModulo := 6  						        
										MSExecAuto({|x,y| FINA040(x,y)}, aFina040, 3) 
										nModulo :=nOldMod

								        If lMsErroAuto
								        	MostraErro()
								        EndIf
										
									EndIf
								EndIf
										
							EndIf
						EndIf
					EndIf
				EndIf
			
			EndIf				
		
		EndIf
 	
 	EndIf		
 	
 	RestArea(aAreaTMP)
    
Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCloseProd  บAutor  ณRafael Parma      บ Data ณ  11/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste de flags do fechamento mensal de coletas do produtor.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/           

Static Function fCloseProd( dSTART_DATE, dEND_DATE, cSTART_LIN, cEND_LIN, cCODPRD, cLOJPRD, cNUMDOC, cSERDOC, cENDMOV, nPRC_LITRO, nPRC_FRETE )
Local cAliasTMP := GetNextAlias()                                                         
Local hEnter	:= CHR(13) + CHR(10) 
	         
	cENDMOV += CHR(13) + CHR(10)	
 
	cQuery := "SELECT 	*												" + hEnter
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5						" + hEnter
	cQuery += "WHERE    ZL5.ZL5_FILIAL  = '" + xFilial("ZL5") + "' 		" + hEnter
	cQuery += "AND 		ZL5.ZL5_DATA   >= '" + dtos(dSTART_DATE) + "' 	" + hEnter
	cQuery += "AND 		ZL5.ZL5_DATA   <= '" + dtos(dEND_DATE) + "' 	" + hEnter
	cQuery += "AND 		ZL5.ZL5_LINHA  >= '" + cSTART_LIN + "' 	   		" + hEnter
	cQuery += "AND 		ZL5.ZL5_LINHA  <= '" + cEND_LIN + "' 	  		" + hEnter				
	cQuery += "AND 		ZL5.D_E_L_E_T_ != '*' 					  		" + hEnter
		                        
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		dbSelectArea("ZL6")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek ( xFilial("ZL6") + (cAliasTMP)->ZL5_COD + cCODPRD + cLOJPRD )
			While !ZL6->(EOF()) .and. ZL6->(ZL6_FILIAL+ZL6_PRODUT+ZL6_LOJPRD) == xFilial("ZL6") + cCODPRD + cLOJPRD
				RecLock("ZL6", .F.)
				ZL6->ZL6_STATUS := "C"
				ZL6->ZL6_DOC    := cNUMDOC
				ZL6->ZL6_SERIE  := cSERDOC
				ZL6->(MsUnlock())
				cENDMOV += "MOV: "+(cAliasTMP)->ZL5_COD + "SEQ: "+ZL6->ZL6_SEQ + CHR(13) + CHR(10)
				ZL6->(dbSkip())
			EndDo
		EndIf
		
		(cAliasTMP)->(dbSkip())
	EndDo             
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

Static Function fBegFile()
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

Static Function fWrtFile(cLin)
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

Static Function fEndFile()

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
Local cMV_ZLTTMV  := AllTRIM(GetMV("MV_ZLTTMV")) 		// tipo do movimento de inclusใo do estoque valorizado
Local cMV_ZLTLOC  := AllTRIM(GetMV("MV_ZLTLOC"))		// armazem do movimento
Local cMV_ZLTPRD  := AllTRIM(GetMV("MV_ZLTPRD"))		// c๓digo do produto
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))		// c๓digo da TES de movimento
Local cMV_ZLTCPG  := AllTRIM(GetMV("MV_ZLTCPG"))		// c๓digo da condi็ใo de pagamento
Local cMV_TIPONF  := AllTRIM(GetMV("MV_TPNRNFS"))		// tipo do controle de numera็ใo NF

	If cMV_ZLTTMV == STRING_Null		
		U_LTALL001(cTitulo, "Paramโtro cMV_ZLTTMV sem conte๚do.","Inserir o conte๚do no param๊tro cMV_ZLTTMV.")
		lRet := .F.
	ELse
		dbSelectArea("SF5")
		dbSetOrder(1)
		If ! dbSeek( xFilial("SF5") + cMV_ZLTTMV )                              
			U_LTALL001(cTitulo, "Tipo de movimento de entrada informado no parโmetro nใo existente para movimento de estoque.","Verificar o conte๚do no param๊tro MV_ZLTTMV.")
			lRet := .F.
		Else
			If SF5->F5_VAL != "S" .or. SF5->F5_QTDZERO != "1"
				U_LTALL001(cTitulo, "Tipo de movimento informado no parโmetro MV_ZLTTMV deve possuir os campos: Valorizado=SIM e Qtd.Zero=SIM.","Verificar o cadastro do tipo de movimento.")
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
	
	If cMV_ZLTLOC == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLTLOC sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLTLOC.")
		lRet := .F.
	EndIf
	
	
	If cMV_ZLTPRD == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLTPRD sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLTPRD.")
		lRet := .F.
	Else
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTop()
		If ! dbSeek ( xFilial("SB1") + cMV_ZLTPRD )
			U_LTALL001(cTitulo, "C๓digo do produto definido no parโmetro MV_ZLTPRD ้ invแlido.","Verificar o conte๚do no param๊tro MV_ZLTPRD.")
			lRet := .F.	
		EndIf
	EndIf
	

	If cMV_ZLTTES == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLTTES sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLTTES.")
		lRet := .F.
	Else
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbGoTop()
		If ! dbSeek ( xFilial("SF4") + cMV_ZLTTES )
			U_LTALL001(cTitulo, "C๓digo da TES definido no parโmetro MV_ZLTTES ้ invแlido.","Verificar o conte๚do no param๊tro MV_ZLTTES.")
			lRet := .F.	
		EndIf
	EndIf
	

	If cMV_ZLTCPG == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_ZLTCPG sem conte๚do.","Inserir o conte๚do no param๊tro MV_ZLTCPG.")
		lRet := .F.
	Else
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbGoTop()
		If ! dbSeek ( xFilial("SE4") + cMV_ZLTCPG )
			U_LTALL001(cTitulo, "C๓digo da condi็ใo de pagamento definido no parโmetro MV_ZLTCPG ้ invแlido.","Verificar o conte๚do no param๊tro MV_ZLTCPG.")
			lRet := .F.	
		EndIf
	EndIf		


	If cMV_TIPONF == STRING_Null
		U_LTALL001(cTitulo, "Paramโtro MV_TPNRNFS sem conte๚do.","Inserir o conte๚do no param๊tro MV_TPNRNFS.")
		lRet := .F.
	EndIf
 

Return ( lRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas LTMOV00003.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()
Local i,j
aRegs  := {}
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
	aAdd(aRegs,{cPerg,"01","M๊s                ?","M๊s                ?","M๊s                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",".LTMOV0301."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",".LTMOV0302."})
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","ZL0000","","",".LTMOV0303."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","ZL0000","","",".LTMOV0304."})
	aAdd(aRegs,{cPerg,"05","Ordenar NFs Por    ?","Ordenar NFs Por    ?","Ordenar NFs Por    ?","mv_ch5","N",01,0,1,"C","","mv_par05","Codigo Produtor","Codigo Produtor","Codigo Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","","","","","","","","","","","","","","", "","","",".LTMOV0305."})
	aAdd(aRegs,{cPerg,"06","Utilizar Excecใo   ?","Utilizar Excecใo   ?","Utilizar Excecใo   ?","mv_ch6","N",01,0,1,"C","","mv_par06","Produtor","Produtor","Produtor","","","Tabela","Tabela","Tabela","","","","","","","","","","","","","","","","", "","","",".LTMOV0306."})
	aAdd(aRegs,{cPerg,"07","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch7","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTMOV0307."})
	aAdd(aRegs,{cPerg,"08","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch8","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTMOV0308."})
	aAdd(aRegs,{cPerg,"09","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch9","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0309."})
	aAdd(aRegs,{cPerg,"10","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_cha","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0310."})
	aAdd(aRegs,{cPerg,"11","Cond. Pagamento De ?","Cond. Pagamento De ?","Cond. Pagamento De ?","mv_chb","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTMOV0311."})
	aAdd(aRegs,{cPerg,"12","Cond. Pagamento At้?","Cond. Pagamento At้?","Cond. Pagamento At้?","mv_chc","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTMOV0311."})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe o m๊s ao qual deseje efetuar o   " )       
	AADD( aHelp01, "fechamento.                              " )       
	AADD( aHelp02, "Informe o ano ao qual deseje efetuar o   " )       
	AADD( aHelp02, "fechamento.                              " )       
	AADD( aHelp03, "Informe o c๓digo inicial da linha        " )       
	AADD( aHelp03, "a ser processado.                        " )       
	AADD( aHelp04, "Informe o c๓digo final da linha          " )       
	AADD( aHelp04, "a ser processado.                        " )       
	AADD( aHelp05, "Ordenar os registros pelo nome ou c๓digo " )       
	AADD( aHelp05, "dos produtores.                          " ) 
	AADD( aHelp06, "Utilizar tabela de exce็ใo do cadastro do" )       
	AADD( aHelp06, "produtor ou das tabelas de exce็๕es.     " )	

	AADD( aHelp07, "Informe o c๓digo inicial do produtor     " )       
	AADD( aHelp07, "a ser impresso.                          " )       
	AADD( aHelp08, "Informe o c๓digo final do produtor       " )       
	AADD( aHelp08, "a ser impresso.                          " )       
	AADD( aHelp09, "Informe a loja inicial do produtor       " )       
	AADD( aHelp09, "a ser impresso.                          " )       
	AADD( aHelp10, "Informe a loja final do produtor         " )       
	AADD( aHelp10, "a ser impresso.                          " )       
	AADD( aHelp11, "Informe o intervalo de condicao de paga- " )	
	AADD( aHelp11, "mento para filtro de produtores.         " )
		
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
	PutSX1Help("P.LTMOV0301.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTMOV0302.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTMOV0303.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTMOV0304.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTMOV0305.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTMOV0306.",aHelp06,aHelp06,aHelp06)

	PutSX1Help("P.LTMOV0307.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTMOV0308.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTMOV0309.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTMOV0310.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTMOV0311.",aHelp11,aHelp11,aHelp11)


Return Nil              
