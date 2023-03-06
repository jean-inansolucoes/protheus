#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV005 บAutor  ณRafael Parma         บ Data ณ  24/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de fechamento financeiro mensal dos produtores.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
User Function LTMOV005()                                                          
*---------------------------------------*
Private cPerg    	:= "LTMOV00005"
Private cTitulo  	:= "Fechamento financeiro de produtores"
Private STRING_Null := "" 


Private oDlgProc    
    
	AjustaSX1()
	
	Pergunte(cPerg,.T.)
	
	//Montagem da tela de processamento
	
	@ 200,1 TO 440,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar o fechamento financeiro de "
	@ 022,018 Say " produtores, processando os registros de conta corrente e gerando  "
	@ 032,018 Say " cheques sobre tํtulos, contas a pagar no m๓dulo financeiro, "
	@ 042,018 Say " de acordo com os parโmetros informados. "
	
	@ 02,010 TO 100,190
	@ 106,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 106,130 BMPBUTTON TYPE 01 ACTION Processa({|| U_LTMOV5PROC(mv_par01, mv_par02, mv_par03, mv_par04, mv_par05, mv_par06, mv_par07, mv_par08, mv_par09, mv_par10, mv_par11, mv_par12, mv_par13, mv_par14, mv_par15, mv_par16, .T.)},,"Processando os registros..")
	@ 106,160 BMPBUTTON TYPE 02 ACTION Close(oDlgProc)
	
	Activate Dialog oDlgProc Centered

Return
       
       
                                                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV5PROCบAutor  ณRafael Parma        บ Data ณ  15/06/2010 บฑฑ
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
User Function LTMOV5PROC(dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cBCOCHQ, cAGNCHQ, cCNTCHQ, cNUMCHQ, nSEQCHQ, nORDCHQ, cCONINI, cCONFIN, lClose ) 
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Private STRING_Null := "" 
Private cArqLog		:= "\fechamento\FIN_"+dtos(ddatabase)+"_"+StrTran(cValToChar(time()),":","")+".log"  // arquivo de log das opera็๕es
Private nHdlLog
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa็ใo do arquivo de log                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    If ! fBegFile()
		MsgAlert("O arquivo de nome "+cArqLog+" nao pode ser executado!","Aten็ใo")
		Return
    EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se os parโmetros utilizados no procedimento estใo preenchidos corretamente.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    
	If ! fChkParam()
		U_LTALL001(cTitulo, "Impossํvel executar o procedimento.","Favor verificar o conte๚do dos parโmetros apresentados anteriormente e executar a rotina novamente.")
		Return
	EndIf                                                                                  


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ verifica se os produtores das linhas selecinadas possuem c๓digo de cliente relacionado.  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	If ! fChkCLIENTE( cLININI, cLINFIN )
		Return 
	EndIf 



       
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cMENSAGEM := "0-INICIO DO PROCESSAMENTO."
	fWrtFile(cMENSAGEM)

	cMENSAGEM := "0-DATA DE-ATE: "+dtoc(dVCTOINI)+"-"+dtoc(dVCTOFIN)+" - LINHA DE-ATE: "+cLININI+"-"+cLINFIN+" - FORNECEDOR DE-ATE: "+cFORINI+"-"+cFORFIN
    fWrtFile(cMENSAGEM)

       
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gera็ใo de titulos a receber - Debitos de produtores                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fPrcTITCR( dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cCONINI, cCONFIN )   


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gera็ใo de titulos a pagar - Creditos de produtores                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fPrcTITCP( dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cCONINI, cCONFIN )   


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Compensa็ใo entre carteiras - Creditos x Debitos de produtores      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	fPrcCOMP(dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cCONINI, cCONFIN ) 

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gera็ใo de cheques sobre tํtulos - Creditos de produtores           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	

	fPrcCHEQ(dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cBCOCHQ, cAGNCHQ, cCNTCHQ, cNUMCHQ, nSEQCHQ, nORDCHQ, cCONINI, cCONFIN ) 
	
	
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
ฑฑบPrograma  ณfPrcTITCR  บAutor  ณRafael Parma       บ Data ณ  15/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona os registros em aberto de tipo DEBITO no perํodo  บฑฑ
ฑฑบ          ณdo movimento de conta corrente, para gerar os titulos no CR.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPrcTITCR( dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cCONINI, cCONFIN )

Local cAliasTMP   := GetNextAlias()
Local hEnter	  := CHR(13) + CHR(10)

Local cMV_ZLTNAT  := AllTRIM(GetMV("MV_ZLRNAT"))	// c๓digo da natureza do tํtulo a receber
Local cMV_ZLTPRF  := AllTRIM(GetMV("MV_ZLRPRF"))	// prefixo do tํtulo a receber
Local cMV_ZLTTIP  := AllTRIM(GetMV("MV_ZLRTIP"))	// tipo do tํtulo a receber
Local cMV_ZLTPRC  := AllTRIM(GetMV("MV_ZLRPRC"))	// parcela do tํtulo a receber 
Local nMV_NUMTCR  := GetMV("MV_ZLNTCR")				// Numero sequencial tํtulo a receber
Local dVencto     := ddatabase   
Local cHistTIT    := "DESPESAS DIVERSAS DO PRODUTOR"

PRIVATE lMSHelpAuto := .f. 	// para nao mostrar os erro na tela
PRIVATE lMSErroAuto := .f. 	// inicializa como falso, se voltar verdadeiro e' que deu erro 
    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos dados de acordo com os parametros informados pelo usuแrio  . ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "	SELECT 	SUM(ZLB.ZLB_VALOR) ZLB_VALOR,						" + hEnter
	cQuery += "         ZLB.ZLB_FORNEC,				 						" + hEnter
	cQuery += "         ZLB.ZLB_LOJFOR,				 						" + hEnter	
	cQuery += "         ZLB.ZLB_DTVCTO,				 						" + hEnter	
	cQuery += "         SA2.A2_X_LINHA				 						" + hEnter	
	cQuery += "	FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter

	cQuery += "	INNER JOIN " + RetSqlName("SA2") + " SA2   					" + hEnter
	cQuery += "	ON       ZLB.ZLB_FORNEC    = SA2.A2_COD					 	" + hEnter
	cQuery += "	AND      ZLB.ZLB_LOJFOR    = SA2.A2_LOJA				 	" + hEnter

	cQuery += "	WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
	cQuery += "	AND      ZLB.ZLB_FORNEC BETWEEN '" + cFORINI + "'	 		" + hEnter
	cQuery += "	AND      						'" + cFORFIN + "'	 		" + hEnter
	
	cQuery += "	AND      ZLB.ZLB_LOJFOR BETWEEN '" + cLOJINI + "'	 		" + hEnter
	cQuery += "	AND      						'" + cLOJFIN + "'	 		" + hEnter

	cQuery += "	AND      ZLB.ZLB_DTVCTO BETWEEN '" + dtos(dVCTOINI) + "'	" + hEnter
	cQuery += "	AND      						'" + dtos(dVCTOFIN) + "'	" + hEnter

	cQuery += "	AND      SA2.A2_X_LINHA BETWEEN '" + cLININI + "'  			" + hEnter
	cQuery += "	AND      						'" + cLINFIN + "' 			" + hEnter

	cQuery += "	AND      SA2.A2_COND    BETWEEN '" + cCONINI + "'  			" + hEnter
	cQuery += "	AND      						'" + cCONFIN + "' 			" + hEnter
	
	cQuery += "	AND      ZLB.ZLB_STATUS    = ''	                     	 	" + hEnter
	cQuery += "	AND 	 ZLB.ZLB_TIPCD     = 'D'							" + hEnter
	cQuery += "	AND 	 ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += " AND      SA2.A2_X_LINHA	  != ''		 						" + hEnter
	cQuery += "	AND 	 SA2.D_E_L_E_T_   != '*' 							" + hEnter

	cQuery += "	GROUP BY                             						" + hEnter
	cQuery += "         ZLB.ZLB_FORNEC,				 						" + hEnter
	cQuery += "         ZLB.ZLB_LOJFOR,				 						" + hEnter	
	cQuery += "         ZLB.ZLB_DTVCTO,				 						" + hEnter	
	cQuery += "         SA2.A2_X_LINHA				 						" + hEnter	
	                        
	memowrite("LTMOV005_SCR.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	                         

	cMENSAGEM := "INICIO DO PROCESSAMENTO-CONTAS A RECEBER."
	fWrtFile(cMENSAGEM)
	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	ProcRegua((cAliasTMP)->(RecCount()))

	While !(cAliasTMP)->(EOF())
        
		If (cAliasTMP)->ZLB_VALOR != 0
		      
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
			//ณMonta itens para a realiza็ใo da inclusใo no contas a receberณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

			dbSelectArea("SA1")
			dbSetOrder(14) 	// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
			dbGoTop()
			If dbSeek ( xFilial("SA1") + SubSTR((cAliasTMP)->ZLB_FORNEC,1,TAMSX3("A2_COD")[1]) + (cAliasTMP)->ZLB_LOJFOR )
			
				lMsErroAuto := .F.
				nMV_NUMTCR  := GetMV("MV_ZLNTCR") + 1	// Numero sequencial tํtulo a receber
				aFina040    := {}                       
				
				dVencto := stod((cAliasTMP)->ZLB_DTVCTO)
			
				AADD( aFina040, { "E1_PREFIXO" , cMV_ZLTPRF						,Nil } )
				AADD( aFina040, { "E1_NUM"	   , STRZero(nMV_NUMTCR,9)			,Nil } )
				AADD( aFina040, { "E1_PARCELA" , cMV_ZLTPRC					    ,Nil } )
				AADD( aFina040, { "E1_TIPO"	   , cMV_ZLTTIP				 		,Nil } )
				AADD( aFina040, { "E1_VALOR"   , (cAliasTMP)->ZLB_VALOR 		,Nil } )
				AADD( aFina040, { "E1_VLCRUZ"  , (cAliasTMP)->ZLB_VALOR			,Nil } )
				AADD( aFina040, { "E1_MOEDA"   , 1								,Nil } )	
				AADD( aFina040, { "E1_NATUREZ" , cMV_ZLTNAT				     	,Nil } )
				AADD( aFina040, { "E1_VENCTO"  , dVencto       					,Nil } )
				AADD( aFina040, { "E1_VENCREA" , DataValida(dVencto)		    ,Nil } )
				AADD( aFina040, { "E1_CLIENTE" , SA1->A1_COD	              	,Nil } )
				AADD( aFina040, { "E1_LOJA"	   , SA1->A1_LOJA	              	,Nil } )
				AADD( aFina040, { "E1_EMISSAO" , dDatabase						,Nil } )
				AADD( aFina040, { "E1_FLUXO"   , "N"							,Nil } )
				AADD( aFina040, { "E1_ORIGEM"  , "LTMOV005", 					,Nil } )
				AADD( aFina040, { "E1_HIST"    , cHistTIT				        ,Nil } )
				AADD( aFina040, { "E1_X_LINHA" , (cAliasTMP)->A2_X_LINHA	    ,Nil } )
				
								
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤอ
				//ณEfetua a chamada da rotina automatica de inclusใo no contas a receber       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤอ

				nOldMod := nModulo
				nModulo := 6 	
				MSExecAuto({|x,y| FINA040(x,y)}, aFina040, 3)
				nModulo :=nOldMod
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณCheca erro de rotina automatica na inclusao, caso exista, apresenta o mesmo       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lMsErroAuto
					DisarmTransaction() 

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Escreve no arquivo de log                                           ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
					cMENSAGEM := "2-ERRO INCLUSAO TITULO CR - FORNECEDOR: " + (cAliasTMP)->ZLB_FORNEC + "/" + (cAliasTMP)->ZLB_LOJFOR
					fWrtFile(cMENSAGEM)						
					
					Mostraerro()
					Return(.F.)
				Else

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAtualiza param๊tro com n๚mero sequencial de tํtulos                               ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
					PUTMV("MV_ZLNTCR", nMV_NUMTCR)	 
									                                  
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Escreve no arquivo de log                                           ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									
					cMENSAGEM := "1-INCLUSAO CR: " + cMV_ZLTPRF+STRZero(nMV_NUMTCR,9)+cMV_ZLTPRC+cMV_ZLTTIP+SA1->A1_COD+SA1->A1_LOJA+ " - VALOR: " + cValToChar((cAliasTMP)->ZLB_VALOR)
					fWrtFile(cMENSAGEM)

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAtualiza registros de despesas com o n๚mero e prefixo do tํtulo gerado            ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

					cQuery := "	UPDATE " + RetSqlName("ZLB") + " 	       					" + hEnter
					cQuery += " SET     ZLB_STATUS = 'C',			 						" + hEnter
					cQuery += "         ZLB_DOC    = '" + STRZero(nMV_NUMTCR,9) + "',		" + hEnter	
					cQuery += "         ZLB_SERIE  = '" + cMV_ZLTPRF + "'					" + hEnter	
					cQuery += "	WHERE   ZLB_FILIAL    = '" + xFilial("ZLB") + "' 			" + hEnter
					cQuery += "	AND     ZLB_FORNEC    = '" + (cAliasTMP)->ZLB_FORNEC + "'	" + hEnter
					cQuery += "	AND     ZLB_LOJFOR    = '" + (cAliasTMP)->ZLB_LOJFOR + "'	" + hEnter
					cQuery += "	AND     ZLB_DTVCTO BETWEEN '" + dtos(dVCTOINI) + "'	   		" + hEnter
					cQuery += "	AND     				   '" + dtos(dVCTOFIN) + "'	 		" + hEnter					
					cQuery += "	AND     ZLB_STATUS    = ''	                     	 		" + hEnter
					cQuery += "	AND 	ZLB_TIPCD     = 'D'							 		" + hEnter
					cQuery += "	AND 	D_E_L_E_T_   != '*' 								" + hEnter
					
					memowrite("LTMOV005_UCR.SQL",cQuery)					
					TCSQLEXEC(cQuery)									
					
				EndIf   				
				
			Else    

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
				cMENSAGEM := "2-ERRO INCLUSAO CR - CLIENTE NAO LOCALZIADO - FORNECEDOR: " + (cAliasTMP)->ZLB_FORNEC + "/" + (cAliasTMP)->ZLB_LOJFOR
				fWrtFile(cMENSAGEM)			
				
			EndIf
				
		EndIf
		
		IncProc()	
		(cAliasTMP)->(dbSkip())
	Enddo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	                         
	cMENSAGEM := "FIM DO PROCESSAMENTO-CONTAS A RECEBER."
	fWrtFile(cMENSAGEM)
	
    (cAliasTMP)->(dbCloseArea())           

Return	



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPrcTITCP  บAutor  ณRafael Parma       บ Data ณ  15/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona os registros em aberto de tipo CREDITO no perํodo บฑฑ
ฑฑบ          ณdo movimento de conta corrente, para gerar os titulos no CP.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPrcTITCP( dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cCONINI, cCONFIN )

Local cAliasTMP   := GetNextAlias()
Local hEnter	  := CHR(13) + CHR(10)

Local cMV_ZLTNAT  := AllTRIM(GetMV("MV_ZLPNAT"))	// c๓digo da natureza do tํtulo a pagar  
Local cMV_ZLTPRF  := AllTRIM(GetMV("MV_ZLPPRF"))	// prefixo do tํtulo a pagar  
Local cMV_ZLTTIP  := AllTRIM(GetMV("MV_ZLPTIP"))	// tipo do tํtulo a pagar  
Local cMV_ZLTPRC  := AllTRIM(GetMV("MV_ZLPPRC"))	// parcela do tํtulo a pagar   
Local nMV_NUMTCP  := GetMV("MV_ZLNTCP")				// Numero sequencial tํtulo a pagar  
Local dVencto     := ddatabase   
Local cHistTIT    := "RECEITAS DIVERSAS DO PRODUTOR"
//Local lMV_CTLIPAG := SuperGetMV("MV_CTLIPAG",,.F.)	// Utiliza controle de liberacao de titulos a pagar

PRIVATE lMSHelpAuto := .f. 	// para nao mostrar os erro na tela
PRIVATE lMSErroAuto := .f. 	// inicializa como falso, se voltar verdadeiro e' que deu erro 
    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos dados de acordo com os parametros informados pelo usuแrio  . ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "	SELECT 	SUM(ZLB.ZLB_VALOR) ZLB_VALOR,						" + hEnter
	cQuery += "         ZLB.ZLB_FORNEC,				 						" + hEnter
	cQuery += "         ZLB.ZLB_LOJFOR,				 						" + hEnter	
	cQuery += "         SA2.A2_X_LINHA				 						" + hEnter	
	cQuery += "	FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter

	cQuery += "	INNER JOIN " + RetSqlName("SA2") + " SA2   					" + hEnter
	cQuery += "	ON       ZLB.ZLB_FORNEC    = SA2.A2_COD					 	" + hEnter
	cQuery += "	AND      ZLB.ZLB_LOJFOR    = SA2.A2_LOJA				 	" + hEnter

	cQuery += "	WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" + hEnter
	cQuery += "	AND      ZLB.ZLB_FORNEC BETWEEN '" + cFORINI + "'	 		" + hEnter
	cQuery += "	AND      						'" + cFORFIN + "'	 		" + hEnter
	
	cQuery += "	AND      ZLB.ZLB_LOJFOR BETWEEN '" + cLOJINI + "'	 		" + hEnter
	cQuery += "	AND      						'" + cLOJFIN + "'	 		" + hEnter

	cQuery += "	AND      ZLB.ZLB_DTVCTO BETWEEN '" + dtos(dVCTOINI) + "'	" + hEnter
	cQuery += "	AND      						'" + dtos(dVCTOFIN) + "'	" + hEnter

	cQuery += "	AND      SA2.A2_X_LINHA BETWEEN '" + cLININI + "'  			" + hEnter
	cQuery += "	AND      						'" + cLINFIN + "' 			" + hEnter
	cQuery += "	AND      SA2.A2_COND    BETWEEN '" + cCONINI + "'  			" + hEnter
	cQuery += "	AND      						'" + cCONFIN + "' 			" + hEnter	
	cQuery += "	AND      ZLB.ZLB_STATUS    = ''	                     	 	" + hEnter
	cQuery += "	AND 	 ZLB.ZLB_TIPCD     = 'C'							" + hEnter
	cQuery += "	AND 	 ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += " AND      SA2.A2_X_LINHA	  != ''		 						" + hEnter	
	cQuery += "	AND 	 SA2.D_E_L_E_T_   != '*' 							" + hEnter 
	
	cQuery += "	GROUP BY                             						" + hEnter
	cQuery += "         ZLB.ZLB_FORNEC,				 						" + hEnter
	cQuery += "         ZLB.ZLB_LOJFOR,				 						" + hEnter	
	cQuery += "         SA2.A2_X_LINHA				 						" + hEnter		
	                        
	memowrite("LTMOV005_SCP.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	                         
	cMENSAGEM := "INICIO DO PROCESSAMENTO-CONTAS A PAGAR."
	fWrtFile(cMENSAGEM)
	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	ProcRegua((cAliasTMP)->(RecCount()))
	
	While !(cAliasTMP)->(EOF())

		If (cAliasTMP)->ZLB_VALOR != 0
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
			//ณMonta itens para a realiza็ใo da inclusใo no contas a pagar  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู
		
			lMsErroAuto := .F.
			nMV_NUMTCP  := GetMV("MV_ZLNTCP") + 1	// Numero sequencial tํtulo a pagar
			aFina050    := {}
			cCODFOR     := SubSTR((cAliasTMP)->ZLB_FORNEC,1,TAMSX3("A2_COD")[1])
			cLOJFOR     := (cAliasTMP)->ZLB_LOJFOR


			dVencto := ddatabase				
			dbSelectArea("SA2")
			dbSetOrder(1) 
			If dbSeek ( xFilial("SA2") + cCODFOR + cLOJFOR )
				If !Empty(SA2->A2_COND)
					aPARCELA := Condicao((cAliasTMP)->ZLB_VALOR, SA2->A2_COND, 0)
					If Len(aPARCELA) > 0
						If aPARCELA[01][01] >= ddatabase
							dVencto := aPARCELA[01][01]
						EndIf
					EndIf
				EndIf
			EndIf
	
			
			AADD( aFina050, { "E2_PREFIXO" , cMV_ZLTPRF						,Nil } )
			AADD( aFina050, { "E2_NUM"	   , STRZero(nMV_NUMTCP,9)			,Nil } )
			AADD( aFina050, { "E2_PARCELA" , cMV_ZLTPRC					    ,Nil } )
			AADD( aFina050, { "E2_TIPO"	   , cMV_ZLTTIP				 		,Nil } )
			AADD( aFina050, { "E2_VALOR"   , (cAliasTMP)->ZLB_VALOR 		,Nil } )
			AADD( aFina050, { "E2_VLCRUZ"  , (cAliasTMP)->ZLB_VALOR			,Nil } )
			AADD( aFina050, { "E2_MOEDA"   , 1								,Nil } )	
			AADD( aFina050, { "E2_NATUREZ" , cMV_ZLTNAT				     	,Nil } )
			AADD( aFina050, { "E2_VENCTO"  , dVencto       					,Nil } )
			AADD( aFina050, { "E2_VENCREA" , DataValida(dVencto)		    ,Nil } )
			AADD( aFina050, { "E2_FORNECE" , cCODFOR       					,Nil } )
			AADD( aFina050, { "E2_LOJA"	   , cLOJFOR				       	,Nil } )
			AADD( aFina050, { "E2_EMISSAO" , dDatabase						,Nil } )
			AADD( aFina050, { "E2_FLUXO"   , "N"							,Nil } )
			AADD( aFina050, { "E2_ORIGEM"  , "LTMOV005", 					,Nil } )
			AADD( aFina050, { "E2_HIST"    , cHistTIT				        ,Nil } )
			AADD( aFina050, { "E2_X_LINHA" , (cAliasTMP)->A2_X_LINHA	    ,Nil } )
			AADD( aFina050, { "E2_DATALIB" , dDatabase               	    ,Nil } )
							
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤอ
			//ณEfetua a chamada da rotina automatica de inclusใo no contas a pagar         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤอ

			nOldMod := nModulo
			nModulo := 6 	
			MSExecAuto({|x,z,y| FINA050(x,z,y)}, aFina050, , 3)
			nModulo :=nOldMod
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCheca erro de rotina automatica na inclusao, caso exista, apresenta o mesmo       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If lMsErroAuto
				DisarmTransaction() 

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
				cMENSAGEM := "2-ERRO INCLUSAO TITULO CP - FORNECEDOR: " + (cAliasTMP)->ZLB_FORNEC + "/" + (cAliasTMP)->ZLB_LOJFOR
				fWrtFile(cMENSAGEM)			
			
				Mostraerro()
				Return(.F.)
			Else

				//--controle liberacao para pagamento
				/*If lMV_CTLIPAG 
					If RecLock("SE2",.F.)
						SE2->E2_DATALIB := SE2->E2_EMISSAO
						//SE2->(MsUnLock())
					EndIf
				EndIf       */                 
				
				
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbGoTop()
				dbSeek( xFilial("SA2")+cCODFOR+cLOJFOR )
			
				//--pagamento com deposito
				If SA2->A2_X_FPGTO == "D"
					If RecLock("SE2",.T.)
						SE2->E2_X_BCODP := SA2->A2_BANCO
						SE2->E2_X_AGDEP := SA2->A2_AGENCIA
						SE2->E2_X_CTADP := SA2->A2_NUMCON
						SE2->E2_X_FAVDP := IIF(!Empty(SA2->A2_X_NOMDP),SA2->A2_X_NOMDP,SA2->A2_NOME)
						SE2->E2_X_TPPSD := IIF(!Empty(SA2->A2_X_TPPSD),SA2->A2_X_TPPSD,SA2->A2_TIPO)
						SE2->E2_X_CGCDP := IIF(!Empty(SA2->A2_X_CGCDP),SA2->A2_X_CGCDP,SA2->A2_CGC)					
				   	EndIf 
				   	MsUnlock()
				EndIf  				
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza param๊tro com n๚mero sequencial de tํtulos                               ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				PUTMV("MV_ZLNTCP", nMV_NUMTCP)	 

								                                  
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
												
								
				cMENSAGEM := "1-INCLUSAO CP: " + cMV_ZLTPRF+STRZero(nMV_NUMTCP,9)+cMV_ZLTPRC+cMV_ZLTTIP+(cAliasTMP)->ZLB_FORNEC+(cAliasTMP)->ZLB_LOJFOR+ " - VALOR: " + cValToChar((cAliasTMP)->ZLB_VALOR)
				fWrtFile(cMENSAGEM)

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza registros de despesas com o n๚mero e prefixo do tํtulo gerado            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				cQuery := "	UPDATE " + RetSqlName("ZLB") + " 	       					" + hEnter
				cQuery += " SET     ZLB_STATUS = 'C',			 						" + hEnter
				cQuery += "         ZLB_DOC    = '" + STRZero(nMV_NUMTCP,9) + "',		" + hEnter	
				cQuery += "         ZLB_SERIE  = '" + cMV_ZLTPRF + "'					" + hEnter	
				cQuery += "	WHERE   ZLB_FILIAL    = '" + xFilial("ZLB") + "' 			" + hEnter
				cQuery += "	AND     ZLB_FORNEC    = '" + (cAliasTMP)->ZLB_FORNEC + "'	" + hEnter
				cQuery += "	AND     ZLB_LOJFOR    = '" + (cAliasTMP)->ZLB_LOJFOR + "'	" + hEnter
				cQuery += "	AND     ZLB_DTVCTO BETWEEN '" + dtos(dVCTOINI) + "'	   		" + hEnter
				cQuery += "	AND     				   '" + dtos(dVCTOFIN) + "'	 		" + hEnter					
				cQuery += "	AND     ZLB_STATUS    = ''	                     	 		" + hEnter
				cQuery += "	AND 	ZLB_TIPCD     = 'C'							 		" + hEnter
				cQuery += "	AND 	D_E_L_E_T_   != '*' 								" + hEnter
				
				memowrite("LTMOV005_UCP.SQL",cQuery)					
				TCSQLEXEC(cQuery)									
				
			EndIf
		
		EndIf	
		
		IncProc()
		(cAliasTMP)->(dbSkip())
		
	Enddo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	                         
	cMENSAGEM := "FIM DO PROCESSAMENTO-CONTAS A PAGAR."
	fWrtFile(cMENSAGEM)
	
    (cAliasTMP)->(dbCloseArea())           

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

Static Function fPrcCOMP( dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cCONINI, cCONFIN )

Local cAliasTMP   := GetNextAlias()
Local hEnter	  := CHR(13) + CHR(10)   
Local cSerieFun := Alltrim(GetMv("MV_SERIEFU")) // S้rie de venda funcionarios

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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos dados de acordo com os parametros informados pelo usuแrio  . ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
CONOUT("##################### PROCESSO DE COMPENSACAO #############################")
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "	SELECT 	ZL1.ZL1_PRODUT,               						" + hEnter
	cQuery += "         ZL1.ZL1_LOJPRD,				 						" + hEnter
	cQuery += "         ZL1.ZL1_NOMPRD,				 						" + hEnter
	cQuery += "         ZL1.ZL1_COD    				 						" + hEnter	
	cQuery += "	FROM " + RetSqlName("ZL1") + " ZL1							" + hEnter 
	cQuery += "	INNER JOIN " + RetSqlName("SA2") + " SA2   					" + hEnter
	cQuery += "	ON       ZL1.ZL1_PRODUT    = SA2.A2_COD					 	" + hEnter
	cQuery += "	AND      ZL1.ZL1_LOJPRD    = SA2.A2_LOJA				 	" + hEnter	

	cQuery += "	WHERE    ZL1.ZL1_FILIAL    = '" + xFilial("ZL1") + "' 		" + hEnter
	cQuery += "	AND      ZL1.ZL1_PRODUT BETWEEN '" + cFORINI + "'	 		" + hEnter
	cQuery += "	AND      						'" + cFORFIN + "'	 		" + hEnter
	cQuery += "	AND      ZL1.ZL1_LOJPRD BETWEEN '" + cLOJINI + "'	 		" + hEnter
	cQuery += "	AND      						'" + cLOJFIN + "'	 		" + hEnter
	cQuery += "	AND      ZL1.ZL1_COD    BETWEEN '" + cLININI + "'  			" + hEnter
	cQuery += "	AND      						'" + cLINFIN + "' 			" + hEnter
	cQuery += "	AND      SA2.A2_COND    BETWEEN '" + cCONINI + "'  			" + hEnter
	cQuery += "	AND      						'" + cCONFIN + "' 			" + hEnter	
	cQuery += "	AND 	 ZL1.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "	AND 	 SA2.D_E_L_E_T_   != '*' 							" + hEnter	                        
	
	memowrite("LTMOV005_SCMP.SQL",cQuery)
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
				
		cMENSAGEM := "FORNECEDOR: " + (cAliasTMP)->ZL1_PRODUT + "/" + (cAliasTMP)->ZL1_LOJPRD
		fWrtFile(cMENSAGEM)		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณSeleciona todos os tํtulos em aberto do contas a receber p/ o produtor         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		dbSelectArea("SA1")
		dbSetOrder(14) 	// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
		dbGoTop()
		If dbSeek ( xFilial("SA1") + SubSTR((cAliasTMP)->ZL1_PRODUT,1,TAMSX3("A2_COD")[1]) + SubSTR((cAliasTMP)->ZL1_LOJPRD,1,TAMSX3("A2_LOJA")[1]) )		

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
			cQuery += "	AND     SE1.E1_PREFIXO   <> '" + cSerieFun + "'					" + hEnter // != prefixo vendas funcionarios
			cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" + hEnter
		
			memowrite("LTMOV005_SCMP-SE1.SQL",cQuery)
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSE1)				
			
			dbSelectArea(cAliasSE1)
			(cAliasSE1)->(dbGoTop())
			
			While !(cAliasSE1)->(EOF())
					
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
				//ณAdiciona ao array os tํtulos em aberto do contas a receber p/ o produtor       ณ
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
			
			cMENSAGEM := "2-ERRO CLIENTE NAO LOCALIZADO - FORNECEDOR: " + (cAliasTMP)->ZL1_PRODUT + "/" + (cAliasTMP)->ZL1_LOJPRD
			fWrtFile(cMENSAGEM)

		EndIf
/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณSeleciona todos os tํtulos em aberto de credito (PA/NDF)contas a pagar p/ o produtor     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		cQuery := "	SELECT 																			  			" + hEnter
		cQuery += "			SE2.R_E_C_N_O_										   					 			" + hEnter
		
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2							  								" + hEnter
	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xFilial("SE1") + "' 		  								" + hEnter
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR((cAliasTMP)->ZL1_PRODUT,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR((cAliasTMP)->ZL1_LOJPRD,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dVCTOINI) + "'										" + hEnter
		cQuery += "	AND     					   '" + dtos(dVCTOFIN) + "'	   									" + hEnter		
		cQuery += "	AND     SE2.E2_SALDO     > 0							  									" + hEnter
		cQuery += "	AND		SE2.E2_TIPO NOT IN ('PA','NDF','GPE')				  					 			" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 								  								" + hEnter
		
//        Aviso("SQL",cQuery,{"OK"},3)
		memowrite("LTMOV005_SCMP-SE2.SQL",cQuery)
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

*/
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
		//ณSeleciona todos os tํtulos em aberto de credito (PA/NDF)contas a pagar p/ o produtor     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

		cQuery := "	SELECT 																			  			" + hEnter
		cQuery += "			SE2.R_E_C_N_O_,										   					 			" + hEnter
		cQuery += "			SE2.E2_PREFIXO 										   					 			" + hEnter
		
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2							  								" + hEnter
	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xFilial("SE1") + "' 		  								" + hEnter
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR((cAliasTMP)->ZL1_PRODUT,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR((cAliasTMP)->ZL1_LOJPRD,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dVCTOINI) + "'										" + hEnter
		cQuery += "	AND     					   '" + dtos(dVCTOFIN) + "'	   									" + hEnter		
		cQuery += "	AND     SE2.E2_SALDO     > 0							  									" + hEnter
		cQuery += "	AND		SE2.E2_TIPO NOT IN ('PA','NDF','GPE')					  					 		" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 								  								" + hEnter

		cQuery += "	ORDER BY SE2.E2_PREFIXO DESC									   					 		" + hEnter

		memowrite("LTMOV005_SCMP-SE2.SQL",cQuery)
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

			cMENSAGEM := "COMPENSACAO ENTRE TITULOS: " + (cAliasTMP)->ZL1_PRODUT + "/" + (cAliasTMP)->ZL1_LOJPRD
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
		//ณSeleciona todos os tํtulos em aberto do contas a pagar p/ o produtor           ณ
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
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR((cAliasTMP)->ZL1_PRODUT,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR((cAliasTMP)->ZL1_LOJPRD,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dVCTOINI) + "'										" + hEnter
		cQuery += "	AND     					   '" + dtos(dVCTOFIN) + "'	   									" + hEnter		
		cQuery += "	AND     SE2.E2_SALDO     > 0							  									" + hEnter
		cQuery += "	AND		SE2.E2_TIPO NOT IN ('PA','NDF')						  					 			" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 								  								" + hEnter

		memowrite("LTMOV005_SCMP-SE2.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSE2)			

		dbSelectArea(cAliasSE2)
		(cAliasSE2)->(dbGoTop())
		
		While !(cAliasSE2)->(EOF())
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
			//ณAdiciona ao array os tํtulos em aberto do contas a pagar p/ o produtor         ณ
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
		//ณSe existir tํtulos a receber e pagar p/ o produtor, realiza a compensa็ใo entre carteiras.       ณ
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
							{"AUTCFOR450" 	, SubSTR((cAliasTMP)->ZL1_PRODUT,1,TamSX3("A2_COD")[1]) , nil},;
							{"AUTCLJFOR" 	, SubSTR((cAliasTMP)->ZL1_LOJPRD,1,TamSX3("A2_LOJA")[1]), nil},;
							{"AUTCMOEDA450" , "01" 						, nil},;
							{"AUTNDEBCRED"  , nDEBCR					, nil},;
							{"AUTLTITFUTURO", .F. 						, nil},;
							{"AUTARECCHAVE" , aTITSE1 					, nil},;
							{"AUTAPAGCHAVE" , aTITSE2 					, nil}}
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta rotina de compensa็ใo entre carteiras.   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			
			aTMPAlias := GetArea()
			
			dbSelectArea("SE1")
			dbSelectArea("SE2")

			cMENSAGEM := "0-EXECAUTO COMPENSACAO - FORNECEDOR: " + (cAliasTMP)->ZL1_PRODUT + "/" + (cAliasTMP)->ZL1_LOJPRD + " - VALOR CR: " +cValToChar(nTOTSE1)+ " - VALOR CP: " +cValToChar(nTOTSE2)
			fWrtFile(cMENSAGEM)
			CONOUT("##################### INICIO PROCESSO COMPENSACAO ENTRE CARTEIRAS #############################")
			//nOldMod := nModulo
			//nModulo := 6
			MSExecAuto( {|x,y,z| FINA450(x,y,z)}, nil , aAutoCab , 3 ) //inclusao
			//nModulo :=nOldMod
			CONOUT("##################### FIM PROCESSO COMPENSACAO ENTRE CARTEIRAS #############################")			
			If !lMsErroAuto

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	                               
				RestArea(aTMPAlias)
				
				cMENSAGEM := "1-COMPENSACAO - FORNECEDOR: " + (cAliasTMP)->ZL1_PRODUT + "/" + (cAliasTMP)->ZL1_LOJPRD + " - VALOR CR: " +cValToChar(nTOTSE1)+ " - VALOR CP: " +cValToChar(nTOTSE2)
				fWrtFile(cMENSAGEM)

			Else
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				MostraErro()

				cMENSAGEM := "2-ERRO COMPENSACAO - FORNECEDOR: " + (cAliasTMP)->ZL1_PRODUT + "/" + (cAliasTMP)->ZL1_LOJPRD + " - VALOR CR: " +cValToChar(nTOTSE1)+ " - VALOR CP: " +cValToChar(nTOTSE2)
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
ฑฑบPrograma  ณfPrcCHEQ   บAutor  ณRafael Parma       บ Data ณ  24/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona tํtulos para gera็ใo de cheques s/ tํtulo CP,     บฑฑ
ฑฑบ          ณpagamento de produtores.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Static Function fPrcCHEQ(dVCTOINI, dVCTOFIN, cLININI, cLINFIN, cFORINI, cFORFIN, cLOJINI, cLOJFIN, cBCOCHQ, cAGNCHQ, cCNTCHQ, cNUMCHQ, nSEQCHQ, nORDCHQ, cCONINI, cCONFIN ) 
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Local cAliasTMP 	:= GetNextAlias()
Local lMV_LINCHQ 	:= SuperGetMV("MV_LINCHQ",,.F.)		// Utiliza codigo da linha no beneficiแrio do cheque
Local cNomeProd
Local _nCONTCHQ
Private cNATCHQ 	:= ALLTRIM(GETMV("MV_ZLNTCH"))		// Natureza do cheque
Private cDESCHIST   := ALLTRIM(GETMV("MV_ZLHTCH"))		// Historico do cheque  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos dados de acordo com os parametros informados pelo usuแrio  . ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	
	cQuery := " SELECT						  									" + CHR(13)
	cQuery += " 		SUM(SE2.E2_SALDO) E2_SALDO,								" + CHR(13)		
	cQuery += " 		SE2.E2_FORNECE,											" + CHR(13)		
	cQuery += " 		SE2.E2_LOJA,											" + CHR(13)		
	cQuery += " 		SE2.E2_X_LINHA,    										" + CHR(13)		
	cQuery += " 		SA2.A2_NOME    											" + CHR(13)		
	cQuery += " FROM " + RetSQLName("SE2") + " SE2								" + CHR(13)
	cQuery += " INNER JOIN " + RetSQLName("SA2") + " SA2						" + CHR(13)
	cQuery += " ON 		SA2.A2_COD       = SE2.E2_FORNECE						" + CHR(13)		
	cQuery += " AND		SA2.A2_LOJA      = SE2.E2_LOJA							" + CHR(13)		
	cQuery += " WHERE 															" + CHR(13)		
	cQuery += "  		SE2.E2_FILIAL    = '" + xFilial("SE2") + "'				" + CHR(13)		
	cQuery += " AND		SE2.E2_VENCREA BETWEEN 	'" + dtos(dVCTOINI) + "' 		" + CHR(13)		
	cQuery += " AND								'" + dtos(dVCTOFIN) + "' 		" + CHR(13)		
	cQuery += " AND		SE2.E2_X_LINHA BETWEEN 	'" + cLININI		+ "' 		" + CHR(13)		
	cQuery += " AND								'" + cLINFIN		+ "' 		" + CHR(13)		
	cQuery += " AND		SE2.E2_FORNECE BETWEEN 	'" + cFORINI 		+ "' 		" + CHR(13)		
	cQuery += " AND								'" + cFORFIN		+ "' 		" + CHR(13)		
	cQuery += " AND		SE2.E2_LOJA BETWEEN 	'" + cLOJINI 		+ "' 		" + CHR(13)		
	cQuery += " AND								'" + cLOJFIN		+ "' 		" + CHR(13)		
	cQuery += " AND		SA2.A2_COND BETWEEN 	'" + cCONINI 		+ "' 		" + CHR(13)		
	cQuery += " AND								'" + cCONFIN		+ "' 		" + CHR(13)
	cQuery += "	AND		SE2.E2_TIPO NOT IN ('PA','NDF')						  	" + CHR(13)
	cQuery += " AND		SE2.E2_NUMBCO    = '"+Space(TAMSX3("E2_NUMBCO")[1])+"'	" + CHR(13)		
	cQuery += " AND		SE2.E2_SALDO     > 0						 			" + CHR(13)
	cQuery += " AND		SE2.E2_PREFIXO  != 'FRT'					 			" + CHR(13)		
	cQuery += " AND		SE2.D_E_L_E_T_  != '*'						 			" + CHR(13)		
	cQuery += " AND		SA2.D_E_L_E_T_  != '*'						 			" + CHR(13)		

	cQuery += " GROUP BY					  						 			" + CHR(13)     
	cQuery += " 		SE2.E2_FORNECE,								 			" + CHR(13)		
	cQuery += " 		SE2.E2_LOJA,											" + CHR(13)		
	cQuery += " 		SE2.E2_X_LINHA,    							 			" + CHR(13)		
	cQuery += " 		SA2.A2_NOME    								  			" + CHR(13)		

	cQuery += " ORDER BY					  						  			" + CHR(13)     
	cQuery += " 		SE2.E2_X_LINHA,    							  			" + CHR(13)				
	
	If nORDCHQ == 1
		cQuery += " 	SE2.E2_FORNECE,											" + CHR(13)		
		cQuery += " 	SE2.E2_LOJA	   											" + CHR(13)				
	Else
		cQuery += " 	SA2.A2_NOME    									 		" + CHR(13)		
  	EndIf

	memowrite("LTMOV005_CHQ.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	ProcRegua((cAliasTMP)->(RecCount()))

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cMENSAGEM := "INICIO PROCESSO DE INCLUSAO DE CHEQUES."
    fWrtFile(cMENSAGEM)                                                
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento dos registros - gera็ใo de cheques                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	//-- Utiliza condi็ใo de pagamento com parcelas, tํtulos com valor inferior a R$ 5000,00
	lLIMITCHQ := SuperGetMV("MV_ZLCPCH",,.F.) 
	If lLIMITCHQ
		nLIMITCHQ := SuperGetMV("MV_ZLVALT",,5000)-1
	EndIf
	
    While !(cAliasTMP)->(EOF())
    	                        
    	
    	dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+(cAliasTMP)->E2_FORNECE+(cAliasTMP)->E2_LOJA)
		If SA2->A2_X_FPGTO == "D"	//Forma de pagamento deposito
			
			cMENSAGEM := "FORNECEDOR:"+(cAliasTMP)->E2_FORNECE+"/"+(cAliasTMP)->E2_LOJA+"-FORMA DE PAGAMENTO=DEPOSITO-NAO FOI GERADO CHEQUE."
		    fWrtFile(cMENSAGEM)                                                
					
			(cAliasTMP)->(dbSkip())
			Loop
		EndIf
    	
    	cNUMCHQ := ALLTRIM(cNUMCHQ)
    	cNUMCHQOLD := cNUMCHQ

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Define quantidade de cheques a serem gerados.                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

		nQUANTCHQ := 1  
        If lLIMITCHQ                  
        	//-- Quantidade de cheques a serem gerados.
        	nSALDOCHQ := Round((cAliasTMP)->E2_SALDO,0)+1
        	nQUANTCHQ := int( nSALDOCHQ / nLIMITCHQ ) + 1
		Else
			nLIMITCHQ := Round((cAliasTMP)->E2_SALDO,0)+1
		EndIf


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Chamada da fun็ใo de inclusใo de cheques sobre tํtulos                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			   
		For _nCONTCHQ := 1 to nQUANTCHQ
		
	    	aTMPLOC := GetArea()
	    	
	    	If lMV_LINCHQ 
	    		cNomeProd := Alltrim((cAliasTMP)->E2_X_LINHA) + " - " + Alltrim((cAliasTMP)->A2_NOME)
	    	Else
	    		cNomeProd := (cAliasTMP)->A2_NOME
	    	EndIf
	    		    	
	    	If U_LTMOV5FC( nLIMITCHQ, cNATCHQ, cNomeProd, (cAliasTMP)->E2_FORNECE, dVCTOINI, ;
	    					dVCTOFIN, cDESCHIST, cBCOCHQ, cAGNCHQ, cCNTCHQ, @cNUMCHQ, nSEQCHQ )
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    		
	    		cMENSAGEM := "1-INCLUSAO CHEQUE: "+cNUMCHQOLD+" -FORNECEDOR: "+(cAliasTMP)->E2_FORNECE+"-"+(cAliasTMP)->A2_NOME+" - VALOR: "+cValToCHar((cAliasTMP)->E2_SALDO) 
			    fWrtFile(cMENSAGEM)
			    
			Else
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Escreve no arquivo de log                                           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	    		cMENSAGEM := "2-ERRO INCLUSAO CHEQUE: "+cNUMCHQOLD+" -FORNECEDOR: "+(cAliasTMP)->E2_FORNECE+"-"+(cAliasTMP)->A2_NOME+" - VALOR: "+cValToCHar((cAliasTMP)->E2_SALDO) 
			    fWrtFile(cMENSAGEM)		
			    
	    	EndIf
	    		    	
	    	RestArea(aTMPLOC)
	    	
		Next _nCONTCHQ
	        	
    	dbSelectArea(cAliasTMP)
    	(cAliasTMP)->(dbSkip())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Caso nใo realiza a numera็ใo automaticamente	                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		
	    If nSEQCHQ == 2 .and. !(cAliasTMP)->(EOF())
	    	Pergunte(cPerg,.T.)
	    	cBCOCHQ   := mv_par09
	    	cAGNCHQ   := mv_par10
	    	cCNTCHQ   := mv_par11
	    	cNUMCHQ   := mv_par12    	
    	EndIf
    
		IncProc()
    	
    Enddo
    
    (cAliasTMP)->(dbCloseArea())


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Escreve no arquivo de log                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cMENSAGEM := "FIM PROCESSO DE INCLUSAO DE CHEQUES."
    fWrtFile(cMENSAGEM)                                                


Return

                                                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV5FC บAutor  ณRafael Parma         บ Data ณ  24/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclusใo de cheque s/ tํtulo CP, pagamento de produtores.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-----------------------------------------------------------------------------------------------------------------------------------------*                                                                                  
User Function LTMOV5FC( nVLRCHQ, cNATCHQ, cDESCBEN, cCODFOR, dVCTOINI, dVCTOFIN, cDESCHIST, cBCOCHQ, cAGNCHQ, cCNTCHQ, cNUMCHQ, nSEQCHQ )         
*-----------------------------------------------------------------------------------------------------------------------------------------*                                                                                  

PRIVATE cPerg  := "LTMOV00005"   
PRIVATE lMSHelpAuto := .T. // para nao mostrar os erro na tela
PRIVATE lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e' que deu erro 
PRIVATE aAutoCab := {}
                    
	dbSelectArea("SA6")
	dbSetOrder(1)
	dbSeek(xFilial("SA6")+cBCOCHQ+cAGNCHQ+cCNTCHQ)

	aAutoCab := { 	{"AUTBANCO"     , SA6->A6_COD  		, Nil},;       
					{"AUTAGENCIA" 	, SA6->A6_AGENCIA  	, Nil},;      
 					{"AUTCONTA"  	, SA6->A6_NUMCON 	, Nil},;      
 					{"AUTCHEQUE"    , cNUMCHQ	  		, Nil},;
 					{"AUTVALOR"  	, nVLRCHQ   		, Nil},;
 					{"AUTNATUREZA" 	, cNATCHQ 			, Nil},;      
 					{"AUTBENEF"  	, cDESCBEN  		, Nil},;
 					{"AUTFORN"  	, cCODFOR  	 		, Nil},;
 					{"AUTVENCINI"   , dVCTOINI 			, Nil},;
 					{"AUTVENCFIM"   , dVCTOFIN 			, Nil},;
 					{"AUTHIST"     	, cDESCHIST			, Nil} }

	Pergunte(cPerg, .F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Executa execauto de inclusใo de cheque s/ tํtulo.   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ 	
	aTMPAlias := GetArea()
	nOldMod := nModulo
	nModulo := 6
	FinA390(,aAutoCab,2)
	nModulo :=nOldMod
 	
 	If !lMSErroAuto  
 	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se informado n๚mero do cheque sequencial, incremento n๚mero do cheque no parโmetro.  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ 	
 		RestArea(aTMPAlias)
 		
		If nSEQCHQ == 1
			cNUMCHQ := SOMA1(cNUMCHQ, Len(cNUMCHQ))    	
		EndIf
    Else
    	
    	MostraErro()
    	RestArea(aTMPAlias)
    	Return .F.
    	
    Endif
          


Return (!lMSErroAuto)



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

//Local nMV_NUMTCP  := GetMV("MV_ZLNTCP")				// Numero sequencial tํtulo a pagar  	
//Local nMV_NUMTCR  := GetMV("MV_ZLNTCR")				// Numero sequencial tํtulo a receber
	                    
	
	
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
Local nI
Local cCODCLI    := STRING_Null
Local cLOJCLI    := STRING_Null
Local hEnter	 := CHR(13) + CHR(10)

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
			    
	cQuery := "SELECT   ZL1.ZL1_PRODUT,									" + hEnter
	cQuery += "			ZL1.ZL1_LOJPRD									" + hEnter
	cQuery += "FROM " + RetSqlName("ZL1") + " ZL1						" + hEnter
	cQuery += "WHERE    ZL1.ZL1_FILIAL     = '" + xFilial("ZL1") + "' 	" + hEnter
	cQuery += "AND 		ZL1.ZL1_COD  BETWEEN '" + cSTART_LIN + "' 		" + hEnter
	cQuery += "AND      	           		 '" + cEND_LIN   + "' 		" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 						" + hEnter
	cQuery += "ORDER BY ZL1.ZL1_PRODUT, ZL1.ZL1_LOJPRD                 	" + hEnter		
	
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
    	U_LTALL001(cTitulo, "O(s) seguinte(s) produtor(es) nใo possue(m) cliente(s) relacionado(s): "+cPRODUT,"Inserir o cliente correspondente a(os) produtor(es) relacionado(s).")
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
aHelp12 := {}
aHelp13 := {}
aHelp14 := {}
aHelp15 := {}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Vencimento De      ?","Vencimento De      ?","Vencimento De      ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0501."})
	aAdd(aRegs,{cPerg,"02","Vencimento At้     ?","Vencimento At้     ?","Vencimento At้     ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0502."})	
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTMOV0503."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTMOV0504."})

	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTMOV0505."})
	aAdd(aRegs,{cPerg,"06","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTMOV0506."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0507."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0508."})
	
	aAdd(aRegs,{cPerg,"09","Banco              ?","Banco              ?","Banco              ?","mv_ch9","C",TAMSX3("A6_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "SA6","","",".LTMOV0509."})
	aAdd(aRegs,{cPerg,"10","Ag๊ncia            ?","Ag๊ncia            ?","Ag๊ncia            ?","mv_cha","C",TAMSX3("A6_AGENCIA")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0510."})
	aAdd(aRegs,{cPerg,"11","Conta              ?","Conta              ?","Conta              ?","mv_chb","C",TAMSX3("A6_NUMCON")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0511."})
	aAdd(aRegs,{cPerg,"12","No. Cheque         ?","No. Cheque         ?","No. Cheque         ?","mv_chc","C",TAMSX3("EF_NUM")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTMOV0512."})
	aAdd(aRegs,{cPerg,"13","Numera Automatico  ?","Numera Automatico  ?","Numera Automatico  ?","mv_chd","N",01,0,1,"C","","mv_par13","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","","","","","","","",".LTMOV0513."})
	aAdd(aRegs,{cPerg,"14","Ordenar Cheques Por?","Ordenar Cheques Por?","Ordenar Cheques Por?","mv_che","N",01,0,1,"C","","mv_par14","Codigo Produtor","Codigo Produtor","Codigo Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","","","","","","","","","","","","","","", "","","",".LTMOV0514."})
	
	aAdd(aRegs,{cPerg,"15","Cond. Pagamento De ?","Cond. Pagamento De ?","Cond. Pagamento De ?","mv_chf","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTMOV0515."})
	aAdd(aRegs,{cPerg,"16","Cond. Pagamento At้?","Cond. Pagamento At้?","Cond. Pagamento At้?","mv_chg","C",TAMSX3("E4_CODIGO")[1],0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","", "SE4","","",".LTMOV0515."})
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe a data inicial do vencimento de  " )       
	AADD( aHelp01, "tํtulos para gera็ใo de cheques.         " )       
	AADD( aHelp02, "Informe a data final   do vencimento de  " )       
	AADD( aHelp02, "tํtulos para gera็ใo de cheques.         " )       
	AADD( aHelp03, "Informe o c๓digo inicial da linha        " )       
	AADD( aHelp03, "para gera็ใo de cheques.                 " )       
	AADD( aHelp04, "Informe o c๓digo final da linha          " )       
	AADD( aHelp04, "para gera็ใo de cheques.                 " ) 

	AADD( aHelp05, "Informe o c๓digo inicial do produtor     " )       
	AADD( aHelp05, "a ser processado.                        " )       
	AADD( aHelp06, "Informe o c๓digo final do produtor       " )       
	AADD( aHelp06, "a ser processado.                        " )       
	AADD( aHelp07, "Informe a loja inicial do produtor       " )       
	AADD( aHelp07, "a ser processado.                        " ) 	
	AADD( aHelp08, "Informe a loja final do produtor         " )       
	AADD( aHelp08, "a ser processado.                        " ) 
	      
	AADD( aHelp09, "Informe o c๓digo do banco em que         " )       
	AADD( aHelp09, "o cheque serแ gerado.                    " )       
	AADD( aHelp10, "Informe o c๓digo da ag๊ncia em que       " )       
	AADD( aHelp10, "o cheque serแ gerado.                    " )       
	AADD( aHelp11, "Informe o n๚mero da conta em que         " )       
	AADD( aHelp11, "o cheque serแ gerado.                    " )       
	AADD( aHelp12, "Informe o n๚mero do cheque que           " )       
	AADD( aHelp12, "serแ gerado.                             " )       
	AADD( aHelp13, "Selecione a op็ใo SIM para que os        " )       
	AADD( aHelp13, "cheques sejam numerados automaticamente. " )       
	AADD( aHelp14, "Ordenar os registros pelo nome ou c๓digo " )       
	AADD( aHelp14, "dos produtores.                          " ) 
	AADD( aHelp15, "Informe o intervalo de condicao de paga- " )	
	AADD( aHelp15, "mento para filtro de produtores.         " ) 
     
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
	PutSX1Help("P.LTMOV0501.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTMOV0502.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTMOV0503.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTMOV0504.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTMOV0505.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTMOV0506.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTMOV0507.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTMOV0508.",aHelp08,aHelp08,aHelp08)
	PutSX1Help("P.LTMOV0509.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTMOV0510.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTMOV0511.",aHelp11,aHelp11,aHelp11)
	PutSX1Help("P.LTMOV0512.",aHelp12,aHelp12,aHelp12)
	PutSX1Help("P.LTMOV0513.",aHelp13,aHelp13,aHelp13)
	PutSX1Help("P.LTMOV0514.",aHelp14,aHelp14,aHelp14)								
	PutSX1Help("P.LTMOV0515.",aHelp15,aHelp15,aHelp15)
		
Return Nil   
