#INCLUDE "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLSFIN008  บAutor  ณTOTVS PARANม CENTRAL บ Data ณ  08/07/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina responsแvel por realizar a baixa de tํtulos a pagar บฑฑ
ฑฑบ          ณ relacionados com cheques, a partir do arquivo de extrato   บฑฑ
ฑฑบ          ณ de conta corrente para concilia็ใo bancแria.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico LATICINIO SILVESTRE                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function LSFIN008()                                                     
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Private cPerg	:= "LSFIN008X1"
Private oDlgIMP

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem da tela de processamento.                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	AjustaSX1()
	Pergunte(cPerg,.F.)
	
	@ 200,001 TO 370,380 DIALOG oDlgIMP TITLE OemToAnsi("Baixa de Tํtulos a Pagar - Cheques S/Tํtulos")
	@ 005,010 TO 060,180
	@ 015,018 Say " Este programa irแ baixar os tํtulos a pagar, que possuirem"
	@ 025,018 Say " cheques s/tํtulo e que o cheque esteja presente no arquivo"
	@ 035,018 Say " de extrato de conta corrente."
	
	@ 065,090 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)	
	@ 065,120 BMPBUTTON TYPE 01 ACTION Processa({|| fProcFIN() },"Processando...")
	@ 065,150 BMPBUTTON TYPE 02 ACTION Close(oDlgIMP)
	
	Activate Dialog oDlgIMP Centered
	
	RestArea(aAreaTMP)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcFIN บ Autor ณTOTVS PARANA CENTRAL  บ Data ณ  08/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina responsแvel por realizar a baixa de tํtulos a pagar บฑฑ
ฑฑบ          ณ relacionados com cheques, a partir do arquivo de extrato   บฑฑ
ฑฑบ          ณ de conta corrente para concilia็ใo bancแria.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                                         

*---------------------------------------------------------------------------*
Static Function fProcFIN()
*---------------------------------------------------------------------------*
Private lRet		:= .T.
Private aDADOSIMP 	:= {}
Private STRING_NULL	:= ""
Private cHISTBAIXAS := "|CHEQUE PAGO|CH.PAGO EM DINH/ESPECIE|CHEQUE COMPE SICREDI|DEBITO CHEQUE - CUSTODIA|"
Private cDataIMP	:= Lower(ALLTRIM(mv_par01))
Private cDataLOG	:= "\system\lsfin008_"+dtos(ddatabase)+"_"+StrTran(time(),":",STRING_NULL)+".log"
Private	nHdlIMP 	:= fT_fUse(cDataIMP)
Private nHdlLOG		:= fCreate(cDataLOG)
Private cLOG_MSG	:= STRING_NULL
Private cIMP_TXT	:= STRING_NULL
Private nIMP_LIN	:= 0

	//--Cria็ใo do arquivo de log
	If nHdlLOG == -1
	    Alert("O arquivo de Log nome "+cDataLOG+" nใo pode ser criado.")
	    Return
	Endif
		               
	//-- Valida็ใo para abertura do arquivo.
	If nHdlIMP == -1                         
		Alert("Nใo foi possํvel abrir o arquivo: "+cDataIMP)
		lRet := .F.	
	EndIf
	
	//-- Valida็ใo de arquivo vazio.
	If lRet 
		fT_fGotop()
		lRet := !( fT_fEof() )
		If !( lRet )
			Alert("Arquivo "+cDataIMP+" vazio.")
			lRet := .F.
		EndIf
	EndIf

	cLOG_MSG := "---------------- LEITURA DO ARQUIVO: "+cDataIMP+" --------------------"
	fWriteLog()	
		
	//-- Percorre o arquivo...
	ProcRegua(fT_fLastRec())
	While ( !fT_fEof() ) .and. lRet 
		IncProc()
		cIMP_TXT	:= fT_fReadLn()
		nIMP_LIN	+= 1
		
		//-- Verifica o tipo do registro (Segmento E)
		If SubSTR( cIMP_TXT , 14 , 1 ) != "E"
			cLOG_MSG := "SEGMENTO DIFERENTE DE 'E'"
			fWriteLog()	
			fT_fSkip()
			Loop
		EndIf         
		
		//-- Descri็ใo hist๓rico lcto. no banco
		cHISTDOC := ALLTRIM( SubSTR( cIMP_TXT , 177 , 25 ) )
		
		//-- Verifica hist๓rico ref. a baixa de cehques
		If cHISTDOC $ cHISTBAIXAS
			cNUMDOC := ALLTRIM( SubSTR( cIMP_TXT , 205 , 35 ) )
			nVALDOC := Val ( SubSTR( cIMP_TXT , 151 , 18 ) ) / 100
			dDATDOC := SubSTR( cIMP_TXT , 143 , 08 )
			dDATDOC := CTOD(SubSTR(dDATDOC,1,2)+"/"+SubSTR(dDATDOC,3,2)+"/"+SubSTR(dDATDOC,5,4))
			aAdd ( aDADOSIMP, { STRING_NULL, cNUMDOC, nVALDOC, dDATDOC, cHISTDOC, {} } )
			cLOG_MSG := "HISTำRICO DE PAGAMENTO DE CHEQUE - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC)
		Else
			cLOG_MSG := "HISTำRICO DIFERENTE DE PAGAMENTO DE CHEQUE."			
		EndIf                                                        
		fWriteLog()	

		fT_fSkip()
	End While                   
	fT_fUse()
                                                           
	//--Processamentos dos registros...
	If Len(aDADOSIMP) > 0 .and. lRet		
		nIMP_LIN := 0

		cLOG_MSG := "---------------- BUSCA DE CHEQUES/TอTULOS --------------------"
		fWriteLog()	
	
		//--Busca de tํtulos relacionados aos pagamentos...
		ProcRegua(Len(aDADOSIMP))
		For nCHQ := 1 to Len(aDADOSIMP)
			IncProc()
			fSeekTIT( aDADOSIMP[nCHQ,02], aDADOSIMP[nCHQ,03], @aDADOSIMP[nCHQ,06] )
			If Len(aDADOSIMP[nCHQ,06]) > 0
				aDADOSIMP[nCHQ,01] := aDADOSIMP[nCHQ,06][Len(aDADOSIMP[nCHQ,06]),01]
			EndIf
		Next nCHQ
		
		//--Ordena registros pelo campo da filial + n๚mero do cheque
		aDADOSIMP := aSort(aDADOSIMP,,, {|x, y| x[1]+x[2] < y[1]+y[2] })
		

		cLOG_MSG := "---------------- BAIXAS DE TอTULOS --------------------"
		fWriteLog()	

		//--Realiza processo de baixa dos tํtulos a pagar...
		ProcRegua(Len(aDADOSIMP))
		cFilOld	:= cFilAnt
		For nCHQ := 1 to Len(aDADOSIMP)
			IncProc()
			If Len(aDADOSIMP[nCHQ,06]) > 0
				For nTIT := 1 to Len(aDADOSIMP[nCHQ,06])
					fBaixaTIT(aDADOSIMP[nCHQ,02], aDADOSIMP[nCHQ,03], aDADOSIMP[nCHQ,04], aDADOSIMP[nCHQ,05], aDADOSIMP[nCHQ,06][nTIT] )
				Next nTIT
			EndIf
		Next nCHQ		
		cFilAnt := cFilOld
	EndIf
	
	fClose(nHdlLOG)
	Close(oDlgIMP)
	
	If lRet		
		If Aviso("Aviso","Processo conclํdo! Deseja abrir arquivo de log: "+cDataLOG,{"Sim","Nใo"}) == 1
			fExibeLOG(cDataLOG)
		EndIf
	Else
		fErase(cDataLOG)
	EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSeekTIT  บ Autor ณTOTVS PARANA CENTRALบ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Busca dados do titulo de acordo com numero do cheque.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------------------------------------*
Static Function fSeekTIT( cNUMDOC, nVALDOC, aTITULO )
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()                                                                      
Local cAliasTMP := GetNextAlias()                                                                 
Local nEF_VALOR := 0
	
	aTITULO := {}
	//-- Recupera o codigo do turno	
	cQuery := "	SELECT 	R_E_C_N_O_ NUMREC FROM "+RetSQLName("SEF")+" WHERE EF_NUM = '"+cNUMDOC+"' AND D_E_L_E_T_ != '*' "
	
	TCQUERY cQuery NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())                                                                      	
		While !(cAliasTMP)->(EOF())
			dbSelectArea("SEF")
			SEF->(dbGoTo((cAliasTMP)->NUMREC))	
			If !SEF->(EOF()) .AND. !SEF->(BOF())
				If !Empty(SEF->EF_PREFIXO) .AND. !Empty(SEF->EF_TITULO) .AND. !Empty(SEF->EF_TIPO)
					nEF_VALOR += SEF->EF_VALOR
					aAdd ( aTITULO, { SEF->EF_FILIAL, SEF->EF_PREFIXO, SEF->EF_TITULO, SEF->EF_PARCELA, SEF->EF_TIPO, SEF->EF_FORNECE, SEF->EF_LOJA, SEF->EF_BANCO, SEF->EF_AGENCIA, SEF->EF_CONTA } )				
				EndIf
			EndIf
			(cAliasTMP)->(dbSkip())
		End While
		If nEF_VALOR != nVALDOC
			aTITULO := {}
			cLOG_MSG := "CHEQUE LOCALIZADO COM VALOR INCORRETO - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC)+" - VALOR REGISTRO (EF_VALOR): "+cValToChar(nEF_VALOR)
			fWriteLog()	
		Else
			For nX := 1 to Len(aTITULO)
				cLOG_MSG := "CHEQUE LOCALIZADO - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC) +" - CHAVE (SE2): "+aTITULO[nX,01]+aTITULO[nX,02]+aTITULO[nX,03]+aTITULO[nX,04]+aTITULO[nX,05]+aTITULO[nX,06]+aTITULO[nX,07]
				fWriteLog()	
			Next nX
		EndIf
	Else
		cLOG_MSG := "CHEQUE NรO LOCALIZADO - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC)
		fWriteLog()	
	EndIf
	(cAliasTMP)->(dbCloseArea())
	
	
	RestArea(aAreaTMP)

Return                        


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSeekTIT  บ Autor ณTOTVS PARANA CENTRALบ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Busca dados do titulo de acordo com numero do cheque.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------------------------------------*
Static Function fBaixaTIT(cNUMDOC, nVALDOC, dDATADOC, cHISTDOC, aTITULO)
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Local cMOTBX	:= "NOR"
Local aTITBX	:= {}
Private lMsErroAuto := .F.          
    
	cCHAVESE2 := aTITULO[01] + aTITULO[02] + aTITULO[03] + aTITULO[04] + aTITULO[05] + aTITULO[06]  + aTITULO[07]

	dbSelectArea("SA6")
	SA6->(dbSetOrder(1))
SA6->(dbGoTop())
	SA6->(dbSeek( xFilial("SA6") + aTITULO[08] + aTITULO[09] + aTITULO[10] ))
	
	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	SE2->(dbGoTop())
	If SE2->(dbSeek( cCHAVESE2 ))
	                                   
		If SE2->E2_SALDO > 0
	
			AADD( aTITBX, {"E2_FILIAL"   , SE2->E2_FILIAL							, Nil} )		
			AADD( aTITBX, {"E2_PREFIXO"  , SE2->E2_PREFIXO							, Nil} )
			AADD( aTITBX, {"E2_NUM"      , SE2->E2_NUM								, Nil} )
			AADD( aTITBX, {"E2_PARCELA"  , SE2->E2_PARCELA							, Nil} )
			AADD( aTITBX, {"E2_TIPO"     , SE2->E2_TIPO								, Nil} )
			AADD( aTITBX, {"E2_FORNECE"  , SE2->E2_FORNECE							, Nil} )
			AADD( aTITBX, {"E2_LOJA"     , SE2->E2_LOJA								, Nil} )
			AADD( aTITBX, {"AUTBANCO"    , SA6->A6_COD								, Nil} )
			AADD( aTITBX, {"AUTAGENCIA"  , SA6->A6_AGENCIA							, Nil} )
			AADD( aTITBX, {"AUTCONTA"    , SA6->A6_NUMCON							, Nil} )
			AADD( aTITBX, {"AUTCHEQUE"   , cNUMDOC									, Nil} )
			AADD( aTITBX, {"AUTMOTBX"    , cMOTBX									, Nil} )
			AADD( aTITBX, {"AUTDTBAIXA"  , dDATADOC									, Nil} )
			AADD( aTITBX, {"AUTDTCREDITO", dDATADOC									, Nil} )
			AADD( aTITBX, {"AUTHIST"     , cHISTDOC									, Nil} )
			AADD( aTITBX, {"AUTVLRPG"    , SE2->E2_SALDO							, Nil} )
		            	            
			cFilAnt := SE2->E2_FILIAL
			PERGUNTE("FIN080", .F.)    
			MSExecAuto( {|x,y| FINA080(x,y)}, aTITBX, 3 )
		
			If lMsErroAuto
				cArqLog := "lsfin008_"+dtos(ddatabase)+"_"+StrTran(time(),":",STRING_NULL)+"_"+cCHAVESE2+".log"
				DisarmTransaction()
				MostraErro("\system\", cArqLog)				
				cLOG_MSG := "TอTULO COM ERRO NA BAIXA DO CONTAS A PAGAR - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC) + " CHAVE (SE2): "+cCHAVESE2
				fWriteLog()				
				cLOG_MSG := "ERRO GRAVADO EM: \system\"+cArqLog
				fWriteLog()				
			Else
				cLOG_MSG := "TอTULO BAIXADO COM SUCESSO CONTAS A PAGAR - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC) + " CHAVE (SE2): "+cCHAVESE2
				fWriteLog()				
				
				//--Retorna registro do movimento bancแrio ref. libera็ใo do cheque, excluํdo no PE A390CHEQ
				If U_LSF8USE5(cNUMDOC, nVALDOC, dDATADOC, aTITULO[01], aTITULO[06], aTITULO[07], aTITULO[08], aTITULO[09], aTITULO[10]) 				
					//--Atualiza็ใo do saldo bancแrio...
					AtuSalBco(aTITULO[08], aTITULO[09], aTITULO[10], dDATADOC, nVALDOC, "-")
				EndIf
	
			EndIf
		Else
			If (Alltrim(SE2->E2_HIST) == "CHBX" .OR. SE2->E2_TIPO == "PA")
				cLOG_MSG := "CHEQUE LIBERADO COM SUCESSO NO MOV.BANCARIO - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC) + " CHAVE (SE2): "+cCHAVESE2
				fWriteLog()				

				//--Retorna registro do movimento bancแrio ref. libera็ใo do cheque, excluํdo no PE A390CHEQ
				If U_LSF8USE5(cNUMDOC, nVALDOC, dDATADOC, aTITULO[01], "", "", aTITULO[08], aTITULO[09], aTITULO[10]) 				
					//--Atualiza็ใo do saldo bancแrio...
					AtuSalBco(aTITULO[08], aTITULO[09], aTITULO[10], dDATADOC, nVALDOC, "-")  
				EndIf
			Else
				cLOG_MSG := "TอTULO SEM SALDO PARA BAIXAR DO CONTAS A PAGAR - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC) + " CHAVE (SE2): "+cCHAVESE2
				fWriteLog()				
			End
		EndIf
		
	Else
		cLOG_MSG := "TอTULO NรO LOCALIZADO CONTAS A PAGAR - CHEQUE NฺMERO: "+cNUMDOC+" - VALOR: "+cValToChar(nVALDOC) + " CHAVE (SE2): "+cCHAVESE2
		fWriteLog()				
	
	EndIf
	
	RestArea(aAreaTMP)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLSF8USE5  บ Autor ณTOTVS PARANA CENTRALบ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna registro do movimento bancแrio ref. libera็ใo do   บฑฑ
ฑฑบ          ณ cheque, excluํdo no PE A390CHEQ                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------------------------------------*
User Function LSF8USE5( cNUMDOC, nVALDOC, dDATADOC, cFILTIT, cFORTIT, cLOJFOR, cBCOTIT, cAGETIT, cCTATIT )
*---------------------------------------------------------------------------*
Local nRET := 0
Local lRet := .T.

	cQuery := "	UPDATE 		"+RetSQLName("SE5")	+ CHR(13)+CHR(10)						
	cQuery += "	SET 		D_E_L_E_T_ 	= 	' ', 						"	+ CHR(13)+CHR(10)
	cQuery += "				E5_DATA		= 	'"+DTOS(dDATADOC)+"',		"	+ CHR(13)+CHR(10)
	cQuery += "				E5_DTDIGIT	= 	'"+DTOS(dDATADOC)+"',		"	+ CHR(13)+CHR(10)
	cQuery += "				E5_DTDISPO	= 	'"+DTOS(dDATADOC)+"'		"	+ CHR(13)+CHR(10)
	cQuery += "	WHERE		E5_NUMCHEQ	= 	'"+cNUMDOC+"'				"	+ CHR(13)+CHR(10)
	cQuery += "	AND			E5_VALOR	= 	"+cValToChar(nVALDOC)+"		"	+ CHR(13)+CHR(10)
	cQuery += "	AND			E5_BANCO	= 	'"+cBCOTIT+"'				"	+ CHR(13)+CHR(10)
	cQuery += "	AND			E5_AGENCIA	= 	'"+cAGETIT+"'				"	+ CHR(13)+CHR(10)
	cQuery += "	AND			E5_CONTA	= 	'"+cCTATIT+"'				"	+ CHR(13)+CHR(10)
	If !Empty(Alltrim(cFORTIT))
	cQuery += "	AND			E5_CLIFOR	= 	'"+cFORTIT+"'				"	+ CHR(13)+CHR(10)
	EndIf
	cQuery += "	AND			E5_RECPAG	= 	'P'							"	+ CHR(13)+CHR(10)
	cQuery += "	AND			E5_SITUACA	!= 	'C'							"	+ CHR(13)+CHR(10)
//	cQuery += "	AND			E5_TIPODOC	= 	'CH'						"	+ CHR(13)+CHR(10)
	cQuery += "	AND 		D_E_L_E_T_ 	= 	'*' 						" 	+ CHR(13)+CHR(10)
	
	nRET := TCSQLEXEC(cQuery) 
	If nRET < 0
		lRet := .F.
	EndIf
							
Return (lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWriteLog บ Autor ณTOTVS PARANA CENTRALบ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo para escrita no arquivo de log.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------------------------------------*
Static Function fWriteLog()
*---------------------------------------------------------------------------*

	If nIMP_LIN != 0
		cLOG_MSG := "LINHA DO ARQUIVO: " + cValToChar(nIMP_LIN) + " - " + cLOG_MSG + CHR(13)+CHR(10)
	Else
		cLOG_MSG := cLOG_MSG + CHR(13)+CHR(10)
	EndIf

	fWrite(nHdlLOG,cLOG_MSG,Len(cLOG_MSG))
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExibeLOG  บ Autor ณ TOTVS PARANA CENTRAL บ Data ณ08/07/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exibe log das altera็๕es.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                                                                          
*---------------------------------------------------------------------------*
Static Function fExibeLOG(cArqLOG)                                           
*---------------------------------------------------------------------------*
Local nHdlLOG 	:= fT_fUse(cArqLOG)
Local cBuffer 	:= STRING_NULL
Local oFont01, oDlg                       

	//-- Valida็ใo para abertura do arquivo.
	If nHdlLOG == -1                         
		Alert("Nใo foi possํvel abrir o arquivo: "+cDataIMP)
		Return
	EndIf

	While ( !fT_fEof() )
		cIMP_TXT := fT_fReadLn()
		cBuffer	 += cIMP_TXT + CHR(13)+CHR(10)
		fT_fSkip()
	End While                   
	fT_fUse()
	
	If !Empty(cBuffer)
		DEFINE FONT oFont01 NAME "Mono AS" SIZE 6,12
		DEFINE MSDIALOG oDlg TITLE "Log do processo" From 3,0 to 340,417 PIXEL 
			@ 5,5 GET oMemo  VAR cBuffer MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont01
			oMemo:lReadOnly := .T.
			DEFINE SBUTTON FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL 
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Alert("Arquivo de log vazio!")
	Endif
	
Return

  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บ Autor ณTOTVS PARANA CENTRALบ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo para cria็ใo dos parโmetros da rotina.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------------------------------------*
Static Function AjustaSX1()
*---------------------------------------------------------------------------*
Local aRegs := {}
Local aAreaTMP := GetArea()
	
	aAdd(aRegs,{cPerg,"01","Arquivo p/baixas ?","","","mv_ch1","C",30,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		If !dbSeek( cPerg + aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock("SX1")
		Endif
	Next
	
	RestArea(aAreaTMP)

Return