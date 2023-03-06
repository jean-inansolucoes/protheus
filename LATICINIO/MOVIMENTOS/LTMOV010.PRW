#INCLUDE "tbiconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV010  ºAutor  ³Marcelo Joner        º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável pela importação dos registros de Coletas º±±
±±º          ³junto ao à API REST do software MilkUp.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV010()

	Private cArqLOG		:= "/milkup/integracao_" + SUBSTR(DTOS(DATE()),7,2) + '_' + SUBSTR(DTOS(DATE()),5,2) + '_' + SUBSTR(DTOS(DATE()),1,4) + "_" + STRTRAN(TIME(), ":", "") + ".log"
	Private nHldLOG		:= 0
	Private aDetMilk	:= {}
	Private lValida		:= .T.

	CONOUT("LTMOV010-" + DTOC(DATE()) + "-" + TIME() + "-Inicio do processo.")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Avalia threads em execução e aguarda até a conclusão para inicializar à rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
/*
If Type("cEmpAnt") != "U"
	nLIMIT := 0
	While !FreeAllThreads()                            
		If nLIMIT > 10
			Return .F.
		EndIf
		CONOUT("LTMOV010-" + DTOC(DATE()) + "-" + TIME() + "-Processo já em execução aguardando...(" + cValToChar(nLIMIT) + ")")  
		Sleep(10000)
		nLIMIT += 1
	End
EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Se estiver sendo executado por JOB, inicializa o ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If Type("cEmpAnt")=="U"
		cEmpDet := "01"
		cFilDet := "01LAT01"
		RPCSetType(3)
		RpcSetEnv(cEmpDet, cFilDet,,, "EST", GetEnvServer(), {"SA2","SB1","SD3","ZL5","ZL6","ZL7"})
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Regras em torno da criação arquivo de log de execução³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nHldLOG := fCreate(cArqLOG)
	If nHldLOG == -1
		CONOUT("LTMOV010-" + DTOC(DATE()) + "-" + TIME() + "-Erro na criação do arquivo de log: " + cArqLOG)
		CONOUT("LTMOV010-" + DTOC(DATE()) + "-" + TIME() + "-Fim do processo.")

		Return
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Inicia composição do arquivo de log de execução³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTEXTO := "00-Inicio do processo de integração."
	fWriteLog(cTEXTO,nHldLOG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona registro no arquivo de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTEXTO := "01-Inicio da leitura de registros de coleta no MilkUp."
	fWriteLog(cTEXTO,nHldLOG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa integração com o MilkUp para obter os registros de coleta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !U_MLKUPZL6(2)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona registro no arquivo de log³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cTEXTO := "01-Falha da leitura de registros de coleta no MilkUp."
		fWriteLog(cTEXTO,nHldLOG)
	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona registro no arquivo de log³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cTEXTO := "01-Fim da leitura de registros de coleta MilkUp."
		fWriteLog(cTEXTO,nHldLOG)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Havendo informações de coletas, executa regras de gravação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If Len(aDetMilk) > 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Inicia bloco de controle de transação³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//BEGIN TRANSACTION

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-Inicio da gravação de registros de coleta ERP."
			fWriteLog(cTEXTO,nHldLOG)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função para gravação das coletas obtidas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			lValida := fWriteColetas(aDetMilk)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-Fim da gravação de registros de coleta ERP."
			fWriteLog(cTEXTO,nHldLOG)




			//END TRANSACTION
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona registro no arquivo de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTEXTO := "00-Fim do processo de integração."
	fWriteLog(cTEXTO,nHldLOG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha e finaliza o arquivo de log de execução³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//--Fecha arquivo de log
	Ft_Fuse()
	fClose(nHldLOG)

	IF (nHandle := FOPEN(cArqLOG)) >= 0
		// Posiciona no fim do arquivo, retornando o tamanho do mesmo
		nLength := FSEEK(nHandle, 0, FS_END)
		// Posiciona no início do arquivo
		FSEEK(nHandle, 0)
		// Fecha arquivo
		FCLOSE(nHandle)
	ELSE
		MsgStop( "File open error" )
	ENDIF

	nHandle := fopen('/milkup/last.log' , FO_READWRITE + FO_SHARED )
	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else

		cMesgl := chr(10)+chr(13)+SubSTR(DTOS(DATE()),7,2)+'_'+SubSTR(DTOS(DATE()),5,2)+'_'+SubSTR(DTOS(DATE()),1,4)+"_"+Time()+ " - "+Alltrim(str(nLength))+chr(10)+chr(13)
		FSEEK(nHandle, 0, FS_END)
		fWrite(nHandle, cMesgl, 100)
		fclose(nHandle) // Fecha arquivo
	Endif
	If nLength < 512
		FERASE(cArqLOG)
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fWriteColetas  ºAutor  ³Marcelo Joner   º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela gravação das informações de coletas º±±
±±º          ³obtidas na API MilkUp junto ao ERP Totvs.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fWriteColetas(aDetMilk)

	Local lRet				:= .T.
	Local aArea				:= GetArea()
	Local cCodMov			:= ""
	Local nQtdTot			:= 0
	Local nSeq := 			"001"
	Local nI,nJ :=0
	Local cFilZL7 := ""
	Local lExitZL7 := .F.
	Local cFilAnt := ""
	Private lMsErroAuto		:= .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Efetua processamento de todos os itens do array de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	For nI := 1 To Len(aDetMilk)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Reseta variavel de controle do volume total coletado na LINHA, DATA e TRANSPORTADOR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

		//--Validacao do período
		dbSelectArea("ZLC")
		dbSetOrder(1)
		If dbSeek( xFilial("ZLC")+(cValToChar(Year(aDetMilk[nI][02]))+STRZero(Month(aDetMilk[nI][02]),2)+"01") )
			If ZLC->ZLC_STATUS == "F"
				cTEXTO := "O período deste movimento esta fechado."
				fWriteLog(cTEXTO,nHldLOG)
				lRet := .F.
			EndIf
		Else
			cTEXTO :="Não existe período de movimento para lançamento."
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.
		EndIf

		nQtdTot	:= 0
		If lRet
			cTEXTO := "Período de Movimento válido."
			fWriteLog(cTEXTO,nHldLOG)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Inclusão de Mov. Produtor - CABEÇALHO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !fMovProdCab(aDetMilk[nI][01], aDetMilk[nI][02], aDetMilk[nI][03], nQtdTot, @cCodMov, aDetMilk[nI][04])
				DISARMTRANSACTION()
				Return .T.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Adiciona registro no arquivo de log³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If SUBSTR(aDetMilk[nI][01],01,02) == "TB"
					cFilAnt := "01LAT01"
				ElseIf SUBSTR(aDetMilk[nI][01],01,02) == "GC"
					cFilAnt := "01LAT02"
				ElseIf SUBSTR(aDetMilk[nI][01],01,02) == "MC"
					cFilAnt := "01LAT03"
				ElseIf SUBSTR(aDetMilk[nI][01],01,02) == "SP"
					cFilAnt := "01LAT04"
				ElseIf SUBSTR(aDetMilk[nI][01],01,02) == "NE"
					cFilAnt := "01LAT05"
				ElseIf SUBSTR(aDetMilk[nI][01],01,02) == "PI"
					cFilAnt := "01LAT06"
				EndIf


				cTEXTO := "02-02-Inicio do processo de movimento do produtor (itens)"
				fWriteLog(cTEXTO,nHldLOG)

				cFilZL7 := "ZL7->ZL7_FILIAL = '"+ cFilAnt +"' .AND. ZL7->ZL7_LINHA = '"+ aDetMilk[nI][01]	+"' .AND. ZL7->ZL7_ITINER = '"+  aDetMilk[nI][05]	+"' "
				dbSelectArea("ZL7")
				SET FILTER TO &(cFilZL7)
				ZL7->(dbGoTop())
				While !ZL7->(EOF())
					lExitZL7 := .T.
					Exit
				Enddo
				SET FILTER TO

				If !lExitZL7
					dbSelectArea("ZL7")
					ZL7->(dbSetOrder(2))
					ZL7->(MsSeek(xFilial("ZL7")+ DTOS(aDetMilk[nI][02])+aDetMilk[nI][03]))
					While ( !Eof() .AND. xFilial("ZL7") == ZL7->ZL7_FILIAL .AND. ALLTRIM(ZL7->ZL7_LINHA) == aDetMilk[nI][01] .AND. DTOS(ZL7->ZL7_DATA) == DTOS(aDetMilk[nI][02]) )
						If ( xFilial("ZL7") == ZL7->ZL7_FILIAL .AND. ALLTRIM(ZL7->ZL7_LINHA) == aDetMilk[nI][01] .AND. DTOS(ZL7->ZL7_DATA) == DTOS(aDetMilk[nI][02]) .AND. ALLTRIM(ZL7->ZL7_PLACA) == ALLTRIM(STRTRAN(aDetMilk[nI][04]," ",""))	)
							nSeq := STRZERO((VAL(ZL7->ZL7_SEQ)+1),3)
						EndIf
						dbSelectArea("ZL7")
						dbSkip()
					Enddo
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa inclusão de Mov. Produtor - ITENS³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				For nJ := 1 To Len(aDetMilk[nI][06])
					If !fMovProdItem(aDetMilk[nI][06][nJ][01], aDetMilk[nI][06][nJ][02], aDetMilk[nI][06][nJ][03],;
							aDetMilk[nI][06][nJ][04], aDetMilk[nI][06][nJ][05], aDetMilk[nI][06][nJ][06],;
							aDetMilk[nI][06][nJ][07], aDetMilk[nI][06][nJ][08], aDetMilk[nI][06][nJ][09],;
							aDetMilk[nI][06][nJ][10], cCodMov, @nQtdTot,  aDetMilk[nI][06][nJ][11], aDetMilk[nI][06][nJ][12], nSeq, aDetMilk[nI][06][nJ][14])
						DISARMTRANSACTION()
						Return lRet
					EndIf
				Next nJ

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Adiciona registro no arquivo de log³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cTEXTO := "02-02-Fim do processo de movimento do produtor (itens)"
				fWriteLog(cTEXTO,nHldLOG)


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Havendo quantidade coletada, executa demais regras³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If nQtdTot > 0

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Atualiza Mov. Produtor - CABEÇALHO (ATUALIZAÇÃO QUANTIDADE)³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !fMovProdCab(aDetMilk[nI][01], aDetMilk[nI][02], aDetMilk[nI][03], nQtdTot, @cCodMov, aDetMilk[nI][04])
						DISARMTRANSACTION()
						Return lRet
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Inclusão Mov. Transportador³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If !fMovTransp(aDetMilk[nI][01], aDetMilk[nI][02], aDetMilk[nI][03], aDetMilk[nI][04], aDetMilk[nI][05], nQtdTot)
							DISARMTRANSACTION()
							Return .F.
						EndIf
					EndIf
				EndIf
			EndIf
		else
			cTEXTO := "02-03-Movimento NÃO Incluido - Placa: " + aDetMilk[nI][04] + " - Linha: " + aDetMilk[nI][01] + " - Transportador: " + aDetMilk[nI][03] + " - Data: " + DTOC(aDetMilk[nI][02])
			fWriteLog(cTEXTO,nHldLOG)
		EndIf
	Next nI

	RestArea(aArea)

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fWriteLog ºAutor  ³Marcelo Joner        º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela atualização do arquivo de log.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fWriteLog(cTxt, nHdl)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza o log conforme parâmetros repassados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !EMPTY(cTxt) .AND. nHdl > 0
		cTxt := DTOC(DATE()) + "-" + TIME() + "-" + cTxt + CHR(13) + CHR(10)
		fWrite(nHdl, cTxt, Len(cTxt))
		CONOUT(cTxt)
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FreeAllThreads  ºAutor  ³Marcelo Joner  º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela verificação de thread em execução daº±±
±±º          ³rotina e com isto, aborta o inicio de novas execuções.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FreeAllThreads()

	Local cEnvServer		:= GETENVSERVER()
	Local cComputerName		:= GETCOMPUTERNAME()
	Local aUserInfoArray	:= GETUSERINFOARRAY()
	Local nThreads			:= 0
	Local lFreeThreads		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se existe thread de execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aEval(aUserInfoArray, {|aThread| IF((aThread[2] == cComputerName) .AND. (aThread[5] == "U_LTMOV010") .AND. (aThread[6] == cEnvServer), ++nThreads, NIL)})

	lFreeThreads := nThreads == 0

Return lFreeThreads





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMovTransp  ºAutor  ³Marcelo Joner      º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela geração de Mov. Transportador no    º±±
±±º          ³Addon Laticinio.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMovTransp(cCODLIN, dDATA, cCODTRP, cPLACA, cITINER, nQUANT )
	Local cAliasTMP := GetNextAlias()
	Local lRet			:= .T.
	Local lNewMov		:= .F.
	Local aArraySD3_I	:= {}								// Array de inclusão do estoque
	Local aArraySD3_E	:= {}								// Array de estorno do estoque
	Local aDadosMov 	:= {}
//Local cMV_ZLTTMV	:= AllTRIM(GETMV("MV_ZLTTMV")) 		// tipo do movimento de inclusão do estoque valorizado
	Local cMV_ZLTTMI	:= AllTRIM(GETMV("MV_ZLTTMI")) 		// tipo do movimento de inclusão do estoque quantidade
	Local cMV_ZLTTME	:= AllTRIM(GETMV("MV_ZLTTME")) 		// tipo do movimento de estorno do estoque
	Local cMV_ZLTLOC	:= AllTRIM(GETMV("MV_ZLTLOC"))		// armazem do movimento
	Local cMV_ZLTPRD	:= AllTRIM(GETMV("MV_ZLTPRD"))		// código do produto
	Local nSeq := "001"
	Local cFilZL7 := ""
	Local cFilZL5 := ""
	Local lExitZL7 := .F.
	Local cCodMov := ""
	Local aArea := GetArea()
	Private lMsErroAuto	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona registro no arquivo de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTEXTO := "02-03-Inicio do processo de movimento do transportador - Placa: " + cPLACA + " - Linha: " + cCODLIN + " - Transportador: " + cCODTRP + " - Data: " + DTOC(dDATA) + " - Itinerario: " + cITINER
	fWriteLog(cTEXTO,nHldLOG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Define à filial de manipulação do Mov. Transportador à partir do inicio do código da LINHA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If SUBSTR(cCODLIN,01,02) == "TB"
		cFilAnt := "01LAT01"
	ElseIf SUBSTR(cCODLIN,01,02) == "GC"
		cFilAnt := "01LAT02"
	ElseIf SUBSTR(cCODLIN,01,02) == "MC"
		cFilAnt := "01LAT03"
	ElseIf SUBSTR(cCODLIN,01,02) == "SP"
		cFilAnt := "01LAT04"
	ElseIf SUBSTR(cCODLIN,01,02) == "NE"
		cFilAnt := "01LAT05"
	ElseIf SUBSTR(cCODLIN,01,02) == "PI"
		cFilAnt := "01LAT06"
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras quando deve sempre incluir um novo Mov. Transportador³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lNewMov

		dbSelectArea("ZL7")
		ZL7->(dbSetOrder(2))
		ZL7->(MsSeek(xFilial("ZL7")+ DTOS(dDATA)+cCODTRP))
		While ( !Eof() .AND. xFilial("ZL7") == ZL7->ZL7_FILIAL .AND. ALLTRIM(ZL7->ZL7_LINHA) == cCODLIN .AND. DTOS(ZL7->ZL7_DATA) == DTOS(dDATA))
			If (xFilial("ZL7") == ZL7->ZL7_FILIAL .AND. ALLTRIM(ZL7->ZL7_LINHA) == cCODLIN .AND. DTOS(ZL7->ZL7_DATA) == DTOS(dDATA) .AND. ALLTRIM(ZL7->ZL7_PLACA) == cPLACA)
				nSeq := STRZERO((VAL(ZL7->ZL7_SEQ)+1),3)
			EndIf
			dbSelectArea("ZL7")
			dbSkip()
		Enddo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Obtém o código de inclusão do Mov. Transportador³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		While .T.
			cCODMOV := GETSXENUM("ZL7","ZL7_COD")
			dbSelectArea("ZL7")
			ZL7->(dbSetOrder(1))
			ZL7->(dbGoTop())
			If ZL7->(!dbSeek(xFilial("ZL7")+cCODMOV))
				Exit
			Else
				ZL7->(CONFIRMSX8())
			EndIf
		Enddo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Realiza à inclusão do Mov. Transportador³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If RECLOCK("ZL7",.T.)
			ZL7->ZL7_FILIAL := xFilial("ZL7")
			ZL7->ZL7_COD	:= cCODMOV
			ZL7->ZL7_LINHA 	:= cCODLIN
			ZL7->ZL7_NOMLIN	:= POSICIONE("ZL0",1,xFilial("ZL0")+cCODLIN,"ZL0_DESC")
			ZL7->ZL7_TRANSP	:= cCODTRP
			ZL7->ZL7_NOMTRP	:= POSICIONE("SA4",1,xFilial("SA4")+cCODTRP,"A4_NOME")
			ZL7->ZL7_DATA	:= dDATA
			ZL7->ZL7_PLACA	:= ALLTRIM(STRTRAN(cPLACA," ",""))
			ZL7->ZL7_HORA	:= TIME()
			ZL7->ZL7_TPROD 	:= "L"
			ZL7->ZL7_QTDVAZ := 1
			ZL7->ZL7_QTDTRP := nQUANT
			ZL7->ZL7_INTEG	:= 1
			ZL7->ZL7_ITINER	:= cITINER
			ZL7->ZL7_SEQ	:= nSeq

			ZL7->(MSUNLOCK())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-03-Incluido novo movimento do transportador - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade: " + cValToChar(nQUANT) + " - Itinerario: " + cITINER
			fWriteLog(cTEXTO,nHldLOG)
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-03-Erro na inclusão do novo movimento do transportador - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade: " + cValToChar(nQUANT)+ " - Itinerario: " + cITINER
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.
		EndIf

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se já existe Mov. Transportador e atualiza o mesmo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cFilZL7 := "ZL7->ZL7_FILIAL = '"+ cFilAnt +"' .AND. ZL7->ZL7_LINHA = '"+ cCODLIN	+"' .AND. ZL7->ZL7_ITINER = '"+ cITINER	+"' "

		dbSelectArea("ZL7")
		SET FILTER TO &(cFilZL7)
		ZL7->(dbGoTop())
		While !ZL7->(EOF())
			lExitZL7 := .T.
			Exit
		Enddo
		SET FILTER TO


		If lExitZL7

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Compõe array de informações para inclusão Mov. Interno Estoque³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

			nQTDEST := (ZL7->ZL7_QTDTRP + ZL7->ZL7_QTDSOB) - (ZL7->ZL7_QTDANT + ZL7->ZL7_QTDFAL)
			cNumPes := ZL7->ZL7_NUMPES
			/*
			// Estorno movimentos internos (valores antigos)
			aArraySD3_E := {{"D3_FILIAL" , xFilial("SD3"), NIL},;
				{"D3_TM"	 , cMV_ZLTTME	 , NIL},;
				{"D3_COD"	 , cMV_ZLTPRD	 , NIL},;
				{"D3_QUANT"	 , nQTDEST		 , NIL},;
				{"D3_LOCAL"	 , cMV_ZLTLOC	 , NIL},;
				{"D3_DOC"  	 , ZL7->ZL7_COD	 , NIL},;
				{"D3_EMISSAO", ZL7->ZL7_DATA , NIL}}

			nModOld := nModulo
			nModulo := 4

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa rotina Mov. Interno Simples³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//MATA240(aArraySD3_E, 3)
			
			nModulo := nModOld
			*/
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Seleção de Movimentos internos de Qtde e Valores       ³
			//³ gerados pelo Registro dos Itens da NF                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := " SELECT D3_FILIAL, D3_TM, D3_COD, D3_LOCAL, D3_UM, D3_QUANT, D3_CF,  D3_DOC, D3_CC, "   + CRLF
			cQuery += "        D3_EMISSAO, D3_LOTECTL, D3_NUMSEQ, D3_OBSERVA, D3_CUSTO1, R_E_C_N_O_ NRECNO "   + CRLF
			cQuery += " FROM "+RetSqlName( "SD3" )                          + CRLF
			cQuery += " WHERE D_E_L_E_T_ <> '*' "                           + CRLF
			cQuery += "     AND D3_FILIAL   = '" + xFilial("SD3") +   	"'"    + CRLF
			cQuery += "     AND D3_DOC      = '" + ZL7->ZL7_COD +    	"'"    + CRLF
			cQuery += "     AND D3_COD      = '" + cMV_ZLTPRD +     	"'"    + CRLF
			cQuery += " 	AND D3_ESTORNO <> 'S' "                         + CRLF

			//ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa consulta SQL   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cAliasTMP := GetNextAlias()
			TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			While (cAliasTMP)->(!EOF())

				//*****************************************************
				// adiciona os dados da Nf ao array aDadosMov que será
				// utilizando no execauto do Movimento Interno MATA241
				//*****************************************************
				aDadosMov := {}
				aAdd(aDadosMov,(cAliasTMP)->D3_FILIAL)  //01-Filial
				aAdd(aDadosMov,(cAliasTMP)->D3_TM)      //02-Tipo Movimento
				aAdd(aDadosMov,(cAliasTMP)->D3_COD)     //03-Produto
				aAdd(aDadosMov,(cAliasTMP)->D3_UM)      //04-Unidade Medida
				aAdd(aDadosMov,(cAliasTMP)->D3_LOCAL)   //05-Local
				aAdd(aDadosMov,(cAliasTMP)->D3_QUANT)   //06-Quantidade
				aAdd(aDadosMov,(cAliasTMP)->D3_DOC)     //07-Nro Documento
				aAdd(aDadosMov,(cAliasTMP)->D3_EMISSAO) //08-Data Digitação
				aAdd(aDadosMov,(cAliasTMP)->D3_NUMSEQ)  //09-NUMSEQ Numero Sequencial


				//**********************************************************************
				//Gera Estorno do Movimento Interno Multiplo da diferença da Quantidade
				//**********************************************************************
				U_LSMTA241(aDadosMov,"E")

				(cAliasTMP)->(dbSkip())
				exit
			Enddo

			(cAliasTMP)->(dbCloseArea())

			RestArea(aArea)


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-03-Movimento do transportador já existente - Placa: " + cPLACA + " -  Código: " + ZL7->ZL7_COD + " - Quantidade: " + cValToChar(nQTDEST) + "- Itinerario: " + cITINER
			fWriteLog(cTEXTO,nHldLOG)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log caso ocorreu falha na inclusão do Mov. Interno Estoque³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If lMsErroAuto

				cTEXTO := "02-03-Erro na inclusão do movimento interno de saída de estoque: " + MOSTRAERRO()
				fWriteLog(cTEXTO,nHldLOG)
				PUTMV("MV_ESTNEG", "N")
				lRet := .F.

			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Busca total de Fichas para alteração do Mov³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				dbSelectArea("ZL5")
				ZL5->(dbSetOrder(2))
				ZL5->(dbGoTop())
				If ZL5->(dbSeek(xFilial("ZL5") + DTOS(dDATA) + cCODLIN))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Vincula o código do Mov. Produtor à variavel de controle³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cCODMOV := ZL5->ZL5_COD

				ENDIF

				cQuery := "	SELECT 	SUM(ZL6.ZL6_QTDE) AS ZL6_TOTAL						"+chr(10)+chr(13)
				cQuery += "	FROM " + RetSQLName("ZL6") + " ZL6  						"+chr(10)+chr(13)
				cQuery += " WHERE ZL6_FILIAL = '" + ZL7->ZL7_FILIAL + "' 				"+chr(10)+chr(13)
				cQuery += " AND ZL6_COD    = '" + cCODMOV + "'   						"+chr(10)+chr(13)
				cQuery += " AND ZL6_PLACA    = '" + cPLACA + "'   						"+chr(10)+chr(13)
				cQuery += " AND ZL6_DTCOL    = '" + DTOS( ZL7->ZL7_DATA) + "'			"+chr(10)+chr(13)
				cQuery += " AND ZL6_SEQZL7   = '" + nSeq + "'   						"+chr(10)+chr(13)
				cQuery += " AND ZL6.D_E_L_E_T_  != '*'   								"+chr(10)+chr(13)

				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
				dbSelectArea(cAliasTMP)
				(cAliasTMP)->(dbGoTop())

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Adiciona registro no arquivo de log³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cTEXTO := "02-03-Incluido novo movimento interno de saída de estoque."
				fWriteLog(cTEXTO,nHldLOG)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Acrescenta quantidade ao Mov. Transportador já existente³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If RECLOCK("ZL7",.F.)
					ZL7->ZL7_NUMPES := ""
					ZL7->ZL7_QTDVAZ := 1
					ZL7->ZL7_QTDTRP := IIF((cAliasTMP)->ZL6_TOTAL > 0, (cAliasTMP)->ZL6_TOTAL,1)

					ZL7->(MSUNLOCK())

					dbSelectArea("ZM1")
					ZM1->(dbSetOrder(1))
					ZM1->(dbGoTop())
					If ZM1->(dbSeek(xFilial("ZM1") + cNumPes))
						RECLOCK("ZM1", .F.)
						ZM1->ZM1_SITCON := "P"
						ZM1->(MSUNLOCK())
					ENDIF
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Adiciona registro no arquivo de log³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cTEXTO := "02-03-Alterada quantidade do movimento do transortador - Placa: " + cPLACA + " - Código: " + ZL7->ZL7_COD + " - Quantidade: " + cValToChar(ZL7->ZL7_QTDVAZ) + "- Itinerario: " + cITINER
					fWriteLog(cTEXTO,nHldLOG)
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Adiciona registro no arquivo de log³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cTEXTO := "02-03-Erro na alteração da quantidade do movimento do transortador - Placa: " + cPLACA + " - Código: " + ZL7->ZL7_COD + " - Quantidade: " + cValToChar(ZL7->ZL7_QTDVAZ) + "- Itinerario: " + cITINER
					fWriteLog(cTEXTO,nHldLOG)

					lRet := .F.
				EndIf

			EndIf

		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Obtém o Seq de inclusão do Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("ZL7")
			ZL7->(dbSetOrder(2))
			ZL7->(MsSeek(xFilial("ZL7")+ DTOS(dDATA)+cCODTRP))
			While ( !Eof() .AND. xFilial("ZL7") == ZL7->ZL7_FILIAL .AND. ALLTRIM(ZL7->ZL7_LINHA) == cCODLIN .AND. DTOS(ZL7->ZL7_DATA) == DTOS(dDATA))
				If (xFilial("ZL7") == ZL7->ZL7_FILIAL .AND. ALLTRIM(ZL7->ZL7_LINHA) == cCODLIN .AND. DTOS(ZL7->ZL7_DATA) == DTOS(dDATA) .AND. ALLTRIM(ZL7->ZL7_PLACA) == cPLACA)
					nSeq := STRZERO((VAL(ZL7->ZL7_SEQ)+1),3)
				EndIf
				dbSelectArea("ZL7")
				dbSkip()
			Enddo


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Obtém o código de inclusão do Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			While .T.
				cCODMOV := GETSXENUM("ZL7","ZL7_COD")
				dbSelectArea("ZL7")
				ZL7->(dbSetOrder(1))
				ZL7->(dbGoTop())
				If ZL7->(!dbSeek(xFilial("ZL7")+cCODMOV))
					Exit
				Else
					ZL7->(CONFIRMSX8())
				EndIf
			Enddo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza à inclusão do Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If RECLOCK("ZL7",.T.)
				ZL7->ZL7_FILIAL := xFilial("ZL7")
				ZL7->ZL7_COD	:= cCODMOV
				ZL7->ZL7_LINHA 	:= cCODLIN
				ZL7->ZL7_NOMLIN	:= POSICIONE("ZL0",1,xFilial("ZL0")+cCODLIN,"ZL0_DESC")
				ZL7->ZL7_TRANSP	:= cCODTRP
				ZL7->ZL7_NOMTRP	:= POSICIONE("SA4",1,xFilial("SA4")+cCODTRP,"A4_NOME")
				ZL7->ZL7_DATA	:= dDATA
				ZL7->ZL7_PLACA	:= ALLTRIM(STRTRAN(cPLACA," ",""))
				ZL7->ZL7_HORA	:= TIME()
				ZL7->ZL7_TPROD 	:= "L"
				ZL7->ZL7_QTDVAZ := 1
				ZL7->ZL7_QTDTRP := nQUANT
				ZL7->ZL7_INTEG	:= 1
				ZL7->ZL7_ITINER	:= cITINER
				ZL7->ZL7_SEQ	:= nSeq

				ZL7->(MSUNLOCK())

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Adiciona registro no arquivo de log³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cTEXTO := "02-03-Incluido novo movimento do transportador - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade: " + cValToChar(nQUANT) + "- Itinerario: " + cITINER
				fWriteLog(cTEXTO,nHldLOG)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Adiciona registro no arquivo de log³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cTEXTO := "02-03-Erro na inclusão do novo movimento do transportador - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade: " + cValToChar(nQUANT) + "- Itinerario: " + cITINER
				fWriteLog(cTEXTO,nHldLOG)
				lRet := .F.
			EndIf
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras de inclusão Mov. Interno Estoque³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lRet

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Compõe array de informações para inclusão Mov. Interno Estoque³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nQTDEST := (ZL7->ZL7_QTDTRP + ZL7->ZL7_QTDSOB) - (ZL7->ZL7_QTDANT + ZL7->ZL7_QTDFAL)
		aDadosMov := {}
		aAdd(aDadosMov,ZL7_FILIAL)  //01-Filial
		aAdd(aDadosMov,cMV_ZLTTMI)      //02-Tipo Movimento
		aAdd(aDadosMov,cMV_ZLTPRD)     //03-Produto
		aAdd(aDadosMov,"L")      //04-Unidade Medida
		aAdd(aDadosMov,cMV_ZLTLOC)   //05-Local
		aAdd(aDadosMov,nQTDEST)   //06-Quantidade
		aAdd(aDadosMov,ZL7->ZL7_COD)     //07-Nro Documento
		aAdd(aDadosMov,ZL7->ZL7_DATA) //08-Data Digitação

		nOldMod := nModulo
		nModulo := 4
		//MATA240(aArraySD3_I,3)
		U_LSMTA241(aDadosMov,"I")
		nModulo :=nOldMod

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona registro no arquivo de log em caso de falha do Mov. Estoque³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If lMsErroAuto
			cTEXTO := "02-03-Erro na inclusão do movimento interno de entrada de estoque: " + MOSTRAERRO()
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-03-Incluido novo movimento interno de entrada de estoque."
			fWriteLog(cTEXTO,nHldLOG)
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona registro no arquivo de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTEXTO := "02-03-Fim do processo de movimento do transportador - Placa: " + cPLACA + " - Linha: " + cCODLIN + " - Transportador: " + cCODTRP + " - Data: " + DTOC(dDATA)
	fWriteLog(cTEXTO,nHldLOG)

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMovProdCab  ºAutor  ³Marcelo Joner     º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela geração do cabeçalho de Mov. Trans- º±±
±±º          ³portador no Addon Laticinio.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMovProdCab(cCODLIN, dDATA, cCODTRP, nQUANT, cCODMOV, cPLACA)

	Local lRet		:= .T.
	Local nQtdAnt 	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona registro no arquivo de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTEXTO := "02-01-Inicio do processo de movimento do produtor (cabeçalho) - Placa: " + cPLACA + " - Linha: " + cCODLIN + " - Transportador: " + cCODTRP + " - Data: " + DTOC(dDATA)
	fWriteLog(cTEXTO,nHldLOG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Define à filial de manipulação do Mov. Produtor à partir do inicio do código da LINHA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If SUBSTR(cCODLIN,01,02) == "TB"
		cFilAnt := "01LAT01"
	ElseIf SUBSTR(cCODLIN,01,02) == "GC"
		cFilAnt := "01LAT02"
	ElseIf SUBSTR(cCODLIN,01,02) == "MC"
		cFilAnt := "01LAT03"
	ElseIf SUBSTR(cCODLIN,01,02) == "SP"
		cFilAnt := "01LAT04"
	ElseIf SUBSTR(cCODLIN,01,02) == "NE"
		cFilAnt := "01LAT05"
	ElseIf SUBSTR(cCODLIN,01,02) == "PI"
		cFilAnt := "01LAT06"
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se já existe Mov. Produtor para à DATA e LINHA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("ZL5")
	ZL5->(dbSetOrder(2))
	ZL5->(dbGoTop())
	If ZL5->(dbSeek(xFilial("ZL5") + DTOS(dDATA) + cCODLIN))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Vincula o código do Mov. Produtor à variavel de controle³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cCODMOV := ZL5->ZL5_COD

		dbSelectArea("ZL6")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek ( xFilial("ZL6") + cCODMOV )
			While !ZL6->(EOF()) .and. ZL6->(ZL6_FILIAL+ZL6_COD) == xFilial("ZL6") + cCODMOV
				nQtdAnt += ZL6->ZL6_QTDE
				ZL6->(dbSkip())
			EndDo
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona registro no arquivo de log³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cTEXTO := "02-01-Cabeçalho do movimento do produtor já existente - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade Total: " + cValToChar(ZL5->ZL5_TOTAL)
		fWriteLog(cTEXTO,nHldLOG)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Atualiza informações no Mov. Produtor já existente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If RECLOCK("ZL5",.F.)
			ZL5->ZL5_TOTAL  := nQtdAnt
			ZL5->(MsUnLock())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-01-Alterado quantidade do movimento do produtor (cabeçalho) - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade Total: " + cValToChar(ZL5->ZL5_TOTAL)
			fWriteLog(cTEXTO,nHldLOG)
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-01-Erro na alteração do movimento do produtor (cabeçalho) - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade Total: " + cValToChar(ZL5->ZL5_TOTAL)
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.
		EndIf

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Obtém o código de inclusão do Mov. Produtor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		While .T.
			cCODMOV := GETSXENUM("ZL5","ZL5_COD")
			dbSelectArea("ZL5")
			ZL5->(dbSetOrder(1))
			ZL5->(dbGoTop())
			If ZL5->(!dbSeek(xFilial("ZL5") + cCODMOV))
				Exit
			Else
				ZL5->(CONFIRMSX8())
			EndIf
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Realiza à gravação do cabeçalho do Mov. Produtor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If RECLOCK("ZL5",.T.)
			ZL5->ZL5_FILIAL := xFilial("ZL5")
			ZL5->ZL5_COD	:= cCODMOV
			ZL5->ZL5_LINHA 	:= cCODLIN
			ZL5->ZL5_NOMLIN	:= POSICIONE("ZL0",1,xFilial("ZL0")+cCODLIN,"ZL0_DESC")
			ZL5->ZL5_TRANSP	:= cCODTRP
			ZL5->ZL5_NOMTRP	:= POSICIONE("SA4",1,xFilial("SA4")+cCODTRP,"A4_NOME")
			ZL5->ZL5_DATA	:= dDATA
			ZL5->ZL5_X_PARC	:= ""
			ZL5->ZL5_TOTAL  := 0
			ZL5->ZL5_PLATF  := 1
			ZL5->ZL5_INTEG	:= 1

			ZL5->(MSUNLOCK())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-01-Incluido novo movimento do produtor (cabeçalho) - Placa: " + cPLACA + " - Código: " + cCODMOV + " - Quantidade: " + cValToChar(nQUANT)
			fWriteLog(cTEXTO,nHldLOG)
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-01-Erro na inclusão do novo movimento do produtor (cabeçalho)  - Placa: " + cPLACA + " -  Código: " + cCODMOV + " - Quantidade: " + CVALTOCHAR(nQUANT)
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona registro no arquivo de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTEXTO := "02-01-Fim do processo de movimento do produtor (cabeçalho) - Placa: " + cPLACA + " - Linha: " + cCODLIN + " - Transportador: " + cCODTRP + " - Data: " + DTOC(dDATA)
	fWriteLog(cTEXTO,nHldLOG)

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMovProdItem  ºAutor  ³Marcelo Joner    º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela gravação dos itens de Mov. Produtor º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMovProdItem(cFORNECE, cLOJA, cLOCALIZ, nVOLUME, nTEMPERAT, nTANQUE, cAMOSTRA, cHORACOL, cIDCOL, cIDDISP, cCODMOV, nQTDTOT, dDATACOL, cPLACA, nSeq, nVolOri)

	Local lRet	:= .T.
	Local nPRC_LITRO := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Valida se existe registro da coleta repassada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("ZL6")
	ZL6->(dbSetOrder(5))
	ZL6->(dbGoTop())

	If IIF(!EMPTY(cIDCOL), ZL6->(dbSeek(xFilial("ZL6") + cIDCOL)), .F.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄer
		//³Adiciona registro no arquivo de log³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cTEXTO := "02-02-Item do movimento do produtor já existente - Produtor: " + ZL6->ZL6_PRODUT + " - Loja: " + ZL6->ZL6_LOJPRD + " - ID Coleta: " + cIDCOL + " - Placa: " + cPLACA
		fWriteLog(cTEXTO,nHldLOG)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Não existindo registro da coleta, executa demais regras para inclusão³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nTEMPERAT := STRTRAN(cValToChar(nTEMPERAT), ",", ".")
		If RECLOCK("ZL6",.T.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Definição das informações do Item - Mov. Produtor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			ZL6->ZL6_FILIAL := xFilial("ZL6")
			ZL6->ZL6_COD	:= cCODMOV
			ZL6->ZL6_SEQ   	:= fNextSeq(xFilial("ZL6"), cCODMOV)
			ZL6->ZL6_PRODUT	:= cFORNECE
			ZL6->ZL6_LOJPRD	:= cLOJA
			ZL6->ZL6_NOMPRD	:= POSICIONE("SA2", 1, xFilial("SA2") + alltrim(cFORNECE) + cLOJA, "A2_NOME")
			ZL6->ZL6_AMOSTR	:= cAMOSTRA
			ZL6->ZL6_QTDE   := nVOLUME
			ZL6->ZL6_IDDISP := cIDDISP
			ZL6->ZL6_MKUID  := cIDCOL
			ZL6->ZL6_TANQUE := cValToChar(nTANQUE)
			ZL6->ZL6_TEMPER := VAL(nTEMPERAT)
			ZL6->ZL6_HORCOL	:= cHORACOL
			ZL6->ZL6_DTCOL	:= dDATACOL
			ZL6->ZL6_PLACA	:= cPLACA
			ZL6->ZL6_SEQZL7	:= nSeq
			ZL6->ZL6_QTDORI := nVolOri

			ZL6->(MSUNLOCK())

			
			IF POSICIONE("SA2", 1, xFilial("SA2") + alltrim(cFORNECE) + cLOJA, "A2_X_ENRUR") == '1'
			//IF alltrim(cFORNECE) = '030937899'
				dbSelectArea("ZLL")
				dbSetOrder(2)
				dbGoTop()
				//If !dbSeek ( xFilial("ZLL") + cFORNECE + cLOJA + dtos(dDATACOL) + nSeq, .T. )
				If !ZLL->(dbSeek(xFilial("ZL6") + cIDCOL))
					dbSelectArea("ZL2")
					dbSetOrder(4)	// ZL2_FILIAL+ZL2_PRODUT+ZL2_LOJPRD
					dbGoTop()
					If dbSeek ( xFilial("ZL2") + cFORNECE + cLOJA, .T. )
						nPRC_LITRO := ZL2->ZL2_PRCLEI
					EndIf

					nCred := (( (nVOLUME * nPRC_LITRO)*GetMV("MX_PERCRUR") ) /100)
					If RECLOCK("ZLL",.T.)
						ZLL->ZLL_FILIAL := xFilial("ZL6")
						ZLL->ZLL_FORNECE := cFORNECE
						ZLL->ZLL_LOJA := cLOJA
						ZLL_NOME_NOME := POSICIONE("SA2", 1, xFilial("SA2") + alltrim(cFORNECE) + cLOJA, "A2_NOME")										 
						ZLL_CREDIT := nCred
						ZLL_DATA := dDATACOL
						ZLL_SEQUEN := nSeq
						ZLL_MKUID := cIDCOL
						ZLL_LITROS := nVOLUME
						ZLL_PRCLEI := nPRC_LITRO
						ZLL_PERLIT := GetMV("MX_PERCRUR")

						ZLL->(MSUNLOCK())
						cTEXTO := "02-03-Incluido novo credito do produtor na RuralCash (item) - Produtor: " + cFORNECE + " - Loja: " + cLOJA + " - ID Coleta: " + cIDCOL + " - Placa: " + cPLACA
						fWriteLog(cTEXTO,nHldLOG)
					EndIf
				else
					cTEXTO := "02-03-Credito do produtor na RuralCash ja existente pra essa coleta - Produtor: " + cFORNECE + " - Loja: " + cLOJA + " - ID Coleta: " + cIDCOL + " - Placa: " + cPLACA
					fWriteLog(cTEXTO,nHldLOG)
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-02-Incluido novo movimento do produtor (item) - Produtor: " + cFORNECE + " - Loja: " + cLOJA + " - ID Coleta: " + cIDCOL + " - Placa: " + cPLACA
			fWriteLog(cTEXTO,nHldLOG)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Atualiza variavel de controle do volume total - Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nQTDTOT += nVOLUME
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Adiciona registro no arquivo de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cTEXTO := "02-02-Erro na inclusão do novo movimento do produtor (item) - Produtor: " + cFORNECE + " - Loja: " + cLOJA + " - ID Coleta: " + cIDCOL + " - Placa: " + cPLACA
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.
		EndIf
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fNextSeq  ºAutor  ³Marcelo Joner        º Data ³ 06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por obter à próxima sequência dos itens  º±±
±±º          ³de Mov. Produtor.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinios Silvestre                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fNextSeq(cCODFIL, cCODMOV)

	Local aArea		:= GetArea()
	Local nSeq		:= 0
	Local cAliasTMP := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Consulta SQL de pesquisa no banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	BEGINSQL ALIAS cAliasTMP
	SELECT MAX (ZL6.ZL6_SEQ) ZL6_SEQ
	FROM %Table:ZL6% ZL6
	WHERE 	ZL6.ZL6_FILIAL = %Exp:cCODFIL%
	AND 	ZL6.ZL6_COD	   = %Exp:cCODMOV%
	AND 	ZL6.%notDel%
	ENDSQL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Obtém sequência atual - caso exista par à filial e Mov. Produtor informados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !(cAliasTMP)->(EOF())
		nSeq := VAL((cAliasTMP)->ZL6_SEQ)
	EndIf
	(cAliasTMP)->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Compõe o valor da nova sequência³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cRet := STRZERO(nSeq+1, TAMSX3("ZL6_SEQ")[1])

	RestArea(aArea)

Return cRet
