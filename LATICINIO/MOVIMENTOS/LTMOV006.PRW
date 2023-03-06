#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV006 บAutor  ณRafael Parma         บ Data ณ  16/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de fechamento de custos de leite in natura conforme  บฑฑ
ฑฑบ          ณcustos de fechamentos de estoque e movimentos de produtores.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTMOV006()
*-----------------------*                
/*Private oDlgProc    
            
Private cString  	:= "ZL5"
Private cPerg    	:= "LTMOV00006"
Private cTitulo  	:= "Fechamento Custo Leite"
Private STRING_Null := "" 
    
	AjustaSX1()
	Pergunte(cPerg,.T.)
	
	//Montagem da tela de processamento
	
	@ 200,1 TO 360,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar o fechamento do custo de "
	@ 020,018 Say " leite, com base nas movimenta็๕es de documentos dos produtores. "
	
	@ 02,010 TO 040,190
	@ 046,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 046,130 BMPBUTTON TYPE 01 ACTION Processa({|| fProcessa()},,"Processando os registros..")
	@ 046,160 BMPBUTTON TYPE 02 ACTION Close(oDlgProc)
	
	Activate Dialog oDlgProc Centered		
	*/
	ALTERT("ROTNA NAO COMPILADA - LTMOV006")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV006 บAutor  ณRafael Parma         บ Data ณ  16/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de fechamento de custos de leite in natura conforme  บฑฑ
ฑฑบ          ณcustos de fechamentos de estoque e movimentos de produtores.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------* 
Static Function fProcessa()
*---------------------------* 
Local cMV_ZLTTMV:= AllTRIM(GetMV("MV_ZLTTMV")) 		// tipo do movimento de inclusใo do estoque valorizado
Local cMV_ZLTLOC:= AllTRIM(GetMV("MV_ZLTLOC"))		// armazem do movimento
Local cMV_ZLTPRD:= AllTRIM(GetMV("MV_ZLTPRD"))		// c๓digo do produto
Local cAliasTMP := GetNextAlias()

Local nTOTQTD 	:= 0	// Quantidade total documento entrada
Local nTOTVLR 	:= 0	// Valor total documento entrada
Local nCMFECH 	:= 0	// Custo medio dos movimentos
Local nDIFCM  	:= 0	// Diferenca entre custo medio dos movimentos e fechamento estoque
                      
Private lMsErroAuto := .F. 

    // fecha a janela principal
    Close(oDlgProc) 
    
	cMV_ZLTPRD := cMV_ZLTPRD + Space(TAMSX3("D1_COD")[1]-Len(cMV_ZLTPRD))
	cMV_ZLTLOC := cMV_ZLTLOC + Space(TAMSX3("D1_LOCAL")[1]-Len(cMV_ZLTLOC))			

	dbSelectArea("SB9")
	dbSetOrder(1)
	dbGoTop()
	If !dbSeek( xFilial("SB9") + cMV_ZLTPRD + cMV_ZLTLOC + dtos(mv_par01) )         
		Aviso("Fechamento Estoque", "Nใo foi localizado o registro de fechamento de estoque para o Produto: "+cMV_ZLTPRD+;
				" - Armazem: "+cMV_ZLTLOC+" - Data fechamento: "+dtoc(mv_par01)+".", {"OK"},2 )
		Return .F.
	EndIf
                                
	cQuery := "	SELECT 	D1.R_E_C_N_O_ NUMREC						"
	cQuery += "	FROM " + RetSQLName("SD1") + " D1 			   		"
	cQuery += "	WHERE 	D1.D1_FILIAL   = '" + xFilial("SD1") + "'  	"
	cQuery += "	AND		D1.D1_X_DTFEC  = '" + dtos(mv_par01) + "'	"
	cQuery += "	AND 	D1.D1_X_FECCM  = 'N'						"
	cQuery += "	AND		D1.D_E_L_E_T_ != '*'						"
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)		
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		dbSelectArea("SD1")
		dbGoTo((cAliasTMP)->NUMREC)
		
		nTOTQTD += SD1->D1_QUANT
		nTOTVLR += SD1->D1_TOTAL
		
		(cAliasTMP)->(dbSkip())
	Enddo
    
    If nTOTQTD > 0 .and. nTOTVLR > 0 
    
    	//--Custo M้dio do Fechamento
    	nCMFECH := nTOTVLR/nTOTQTD 
    	                                                                              
    	//--Diferen็a do Custo M้dio: Custo M้dio do Fechamento (nCMFECH) deduzido do Custo M้dio do Perํodo Anterior
    	nDIFCM = nCMFECH - (SB9->B9_VINI1 / SB9->B9_QINI)
		
		//--Incluํ Movimento Valorizado com Quantidade Zero
		If SB9->B9_QINI > 0
        
			nVALMOV := nDIFCM * SB9->B9_QINI
			
			aArraySD3_I  := {	{"D3_TM"		,cMV_ZLTTMV	   		,Nil	},;
								{"D3_COD"		,cMV_ZLTPRD			,Nil	},;
								{"D3_QUANT"		,0					,Nil	},;
								{"D3_CUSTO1"	,nVALMOV			,Nil	},;
								{"D3_LOCAL"		,cMV_ZLTLOC			,Nil	},;
								{"D3_X_DTFEC"	,mv_par01			,Nil	},;
								{"D3_EMISSAO"	,mv_par01+1			,Nil	} } 
			
			//MATA240(aArraySD3_I,3)
			
			If lMsErroAuto
				MostraErro()				
			EndIf
			
		Else 
		
			nVALMOV := nCMFECH
			
			aArraySD3_I  := {	{"D3_TM"		,cMV_ZLTTMV	   		,Nil	},;
								{"D3_COD"		,cMV_ZLTPRD			,Nil	},;
								{"D3_QUANT"		,1					,Nil	},;
								{"D3_CUSTO1"	,nVALMOV			,Nil	},;
								{"D3_LOCAL"		,cMV_ZLTLOC			,Nil	},;
								{"D3_X_DTFEC"	,mv_par01			,Nil	},;
								{"D3_EMISSAO"	,mv_par01+1			,Nil	} } 

			
			//MATA240(aArraySD3_I,3)

			If lMsErroAuto
				MostraErro()				
			EndIf
		
		EndIf
		
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
			dbSelectArea("SD1")
			dbGoTo((cAliasTMP)->NUMREC)
			RecLock("SD1",.F.)
			SD1->D1_X_FECCM := "S"
			SD1->(MsUnLock())
			(cAliasTMP)->(dbSkip())
		Enddo

	EndIf          
	
	(cAliasTMP)->(dbCloseArea())	
		
Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTM6AJD1   บAutor  ณRafael Parma       บ Data ณ  16/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para acerto de movimentos anteriores.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTM6AJD1()

//Local cMV_ZLTTMV:= AllTRIM(GetMV("MV_ZLTTMV")) 		// tipo do movimento de inclusใo do estoque valorizado
Local cMV_ZLTLOC:= AllTRIM(GetMV("MV_ZLTLOC"))		// armazem do movimento
Local cMV_ZLTPRD:= AllTRIM(GetMV("MV_ZLTPRD"))		// c๓digo do produto
/*Local cAliasTMP := GetNextAlias()

Local nTOTQTD 	:= 0	// Quantidade total documento entrada
Local nTOTVLR 	:= 0	// Valor total documento entrada
Local nCMFECH 	:= 0	// Custo medio dos movimentos
Local nDIFCM  	:= 0	// Diferenca entre custo medio dos movimentos e fechamento estoque*/

Private cPerg := "LTMOV00006"
    
	Pergunte(cPerg,.T.)
	
	cMV_ZLTPRD := cMV_ZLTPRD + Space(TAMSX3("D1_COD")[1]-Len(cMV_ZLTPRD))
	cMV_ZLTLOC := cMV_ZLTLOC + Space(TAMSX3("D1_LOCAL")[1]-Len(cMV_ZLTLOC))			

	dbSelectArea("SB9")
	dbSetOrder(1)
	dbGoTop()
	If !dbSeek( xFilial("SB9") + cMV_ZLTPRD + cMV_ZLTLOC + DTOS(mv_par01) )         
		Aviso("Fechamento Estoque", "Nใo foi localizado o registro de fechamento de estoque para o Produto: "+cMV_ZLTPRD+;
				" - Armazem: "+cMV_ZLTLOC+" - Data fechamento: "+DTOS(mv_par01), {"OK"},2 )
		Return .F.
	EndIf
      
	dbSelectArea("SD1")	
	SET FILTER TO DTOS(SD1->D1_EMISSAO) == "20110818" .AND. ALLTRIM(SD1->D1_COD) == ALLTRIM(cMV_ZLTPRD)
	dbGoTop()
	While !SD1->(EOF())
		RecLock("SD1",.F.)
		SD1->D1_X_DTFEC	:= DTOS(mv_par01)
		SD1->D1_X_CMFEC := SB9->B9_VINI1 / SB9->B9_QINI
		SD1->D1_X_DIFCM := SD1->D1_VUNIT - SD1->D1_X_CMFEC
		SD1->D1_X_FECCM := "N"
		SD1->(MsUnLock())
		SD1->(dbSkip())
	Enddo
	dbSelectArea("SD1")	
	SET FILTER TO 	    
	
	Alert("OK")
	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTM6VDF    บAutor  ณRafael Parma       บ Data ณ  16/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para valida็ใo da data de fechamento.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LTM6VDF()
Local lRet := .T.

	If mv_par01 != GetMV("MV_ULMES")
		Aviso("MV_ULMES","A data informada nใo corresponde a data do ๚ltimo fechamento de estoque.",{"OK"},2)
		lRet := .F.
	EndIf

Return (lRet)	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  16/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas LTMOV00006.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------*
Static Function AjustaSX1()
*------------------------------*
Local i,j
aRegs  := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Data ฺltimo Fechamento?","Data ฺltimo Fechamento?","Data ฺltimo Fechamento?","mv_ch1","D",08,0,0,"G","U_LTM6VDF()","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	
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
	

Return Nil
