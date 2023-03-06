#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "FWMVCDef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV011  ºAutor  ³Marcelo Joner        º Data ³ 16/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para importação de movimentos de débito na º±±
±±º          ³conta corrente de produtores.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV011()

Local oProcess
Local cFuncao		:= "LTMOV011"
Local cPerg			:= "LTMOV011LT"
Local cTitle		:= " Importação - Conta Corrente Produtor "
Local bProcess		:= {|oSelf| MOV011IMP(oSelf)}
Local cDescricao	:= "  Esta rotina tem como objetivo efetuar à importação de movimentos de débito"+ CRLF +;
					   "  junto à composição da conta corrente dos produtores. "

Private lLinux		:= "LINUX" $ UPPER(GetSrvInfo()[2])
Private cPathErro	:= "LTMOV011_ERRO"+ If(lLinux,"/","\")  // Pasta abaixo da Protheus_Data para gravar os LOGS de ERRO
Private cPathLOG	:= "LTMOV011_LOG" + If(lLinux,"/","\")  // Pasta abaixo da Protheus_Data para gravar os LOGS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras de verificação e criação dos diretórios de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !EXISTDIR(cPathErro)
	nPath := MakeDir(cPathErro)
	If nPath != 0
		U_GLALL001("Atenção", "Não foi possível criar o diretório " + cPathErro, "Favor incluir o diretório " + cPathErro + " abaixo de PROTHEUS_DATA.")
		Return
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa o objeto referente à execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oProcess := tNewProcess():New(cFuncao, cTitle, bProcess, cDescricao, cPerg, , , , , .T., .F.)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MOV011IMP  ºAutor  ³Marcelo Joner       º Data ³ 17/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução das regras de processamentoº±±
±±º          ³da importação dos movimentos na conta corrente dos produtor.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MOV011IMP(oProcess)

Local lRet			:= .T.
Local lFlag			:= .T.
Local nX			:= 0
Local nHdl			:= 0
Local nLin			:= 0 
Local nBuffer		:= 0
Local nTotal		:= 0
Local nReadTot		:= 0
Local cCodMot		:= MV_PAR01
Local cArqCSV		:= ALLTRIM(MV_PAR02)
Local aStruct		:= {{"XX_FILIAL", "C", TAMSX3("ZLB_FILIAL")[1]	, TAMSX3("ZLB_FILIAL")[2]},;
						{"XX_DTMOV"	, "D", TAMSX3("ZLB_DTMOV")[1]	, TAMSX3("ZLB_DTMOV")[2] },;
						{"XX_CPFFOR", "C", TAMSX3("A2_CGC")[1]		, TAMSX3("A2_CGC")[2]	 },;
						{"XX_CODFOR", "C", TAMSX3("A2_COD")[1]		, TAMSX3("A2_COD")[2]	 },;
						{"XX_LOJFOR", "C", TAMSX3("A2_LOJA")[1]		, TAMSX3("A2_LOJA")[2]	 },;
						{"XX_NOMFOR", "C", TAMSX3("A2_NOME")[1]		, TAMSX3("A2_NOME")[2]	 },;
						{"XX_NUMNFE", "C", TAMSX3("ZLB_NF3")[1]		, TAMSX3("ZLB_NF3")[2]	 },;
						{"XX_VLRNFE", "N", TAMSX3("ZLB_VALOR")[1]	, TAMSX3("ZLB_VALOR")[2] },;
						{"XX_CODMOV", "C", TAMSX3("ZLB_COD")[1]		, TAMSX3("ZLB_COD")[2]	 },;
						{"XX_OBS"	, "C", 100						, 0						 },;
						{"XX_STATUS", "C", 1						, 0						 }}

Private cTabTMP
Private lMsErroAuto := .F. 
Private cAliasTMP	:= GetNextAlias()

Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Valida informação do código do tipo de débito de importação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case EMPTY(cCodMot)
		U_GLALL001("Atenção", "Não foi informado o código do tipo de débito para importação dos movimentos.", "Favor informar o código do tipo de débito para importação.")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Valida informação do arquivo que contém os movimentos à serem importados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case EMPTY(cArqCSV)
		U_GLALL001("Atenção", "Não foi informado o arquivo que contém as informações à serem importadas.", "Favor informar o arquivo de importação dos movimentos.")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Caso o arquivo informado não seja CSV, não executa à rotina³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case !".CSV" $ UPPER(cArqCSV)
		U_GLALL001("Atenção", "O arquivo informado não é do tipo CSV.", "Somente é possível utilizar à rotina, caso o arquivo utilizado seja do tipo CSV.")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras de processamento da rotina³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	OtherWise
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Cria tabela temporária para geração de log que será apresentado em relatório ao término da execução³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cTabTMP := CriaTrab(aStruct, .T.)
		dbUseArea(.T.,, cTabTMP ,cAliasTMP, .F., .F.)
		dbSelectArea(cAliasTMP)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Valida se o tipo de débito informado é válido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SX5")
		SX5->(dbSetOrder(1))
		SX5->(dbGoTop())
		If !SX5->(dbSeek(xFilial("SX5") + "LT" + PADR(cCodMot, 2)))
			U_GLALL001("Atenção", "O tipo de débito informado para os movimentos é inválido.", "Favor verificar o tipo de débito informado para importação dos movimentos.")
			lRet := .F.
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Valida se o arquivo informado é válido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If lRet
			nHdl := fOpen(cArqCSV,0)
			If nHdl == -1
			    U_GLALL001("Atenção", "Não foi possível abrir o arquivo " + cArqCSV + ".", "Favor verificar o arquivo informado para importação dos movimentos.")
				lRet := .F.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Obtém o tamanho total do arquivo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				nTotal := FSeek(nHdl, 0, 2)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Aloca no maximo 500kb³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				nBuffer := Min(500*1024, nTotal)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Posiciona no inicio do arquivo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				FSeek(nHdl, 0, 0)
			EndIf
		EndIf
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Após à validação dos parâmetros, executa demais regras de importação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If lRet
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza leitura total do arquivo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			While nReadTot < nTotal
				cBuffer  := SPACE(nBuffer)
				nRead    := FRead(nHdl, @cBuffer, nBuffer)
				nReadTot += nRead
				If (nRead <> nBuffer .AND. nReadTot <> nTotal)
					MsgStop("Erro na leitura do arquivo !","Aviso")
					Break
				EndIf
			End
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Seta reguas de processamento da rotina³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oProcess:SetRegua1(4) 
			oProcess:SetRegua2(2)
			oProcess:IncRegua1("Abrindo arquivo...")
			oProcess:IncRegua2("Importação - Conta Corrente Produtor")
			
			oProcess:SaveLog("Abrindo arquivo...")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Recupera os dados do buffer³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If Len(cBuffer) > 0
				nPOSATUAL := 1
				cSRT := CHR(10)
				fGetTXT(cBuffer, @nPOSATUAL, cSRT)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Retira primeira linha do cabeçalho do buffer³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cBuffer := SubSTR(cBuffer, nPOSATUAL, Len(cBuffer))
				cBufSUB := ""
				          
				nRegistro := 0
				nITEM := 1
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Incremente barra de processamento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				oProcess:IncRegua1("Lendo informações do arquivo...")
				oProcess:SaveLog("Lendo informações do arquivo...")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa laço para leitura de todas as linhas do arquivo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				While lFlag
					cSRT := CHR(10)
					nPOSATUAL := 1
					nLin += 1
					fGetTXT(cBuffer, @nPOSATUAL, cSRT)
					cBufSUB := ""
					cBufSUB := SUBSTR(cBuffer, 1, nPOSATUAL-2)
					cBuffer := SUBSTR(cBuffer, nPOSATUAL, Len(cBuffer))
					nPOSATUAL2 := 1
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Havendo carregado informações, realiza sequência à execução³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(cBufSUB)
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³A partir da string obtida, compõe array separando os itens pela ,³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						cBufSUB := STRTRAN(cBufSUB, CHR(10), "")
						aDetBUF := STRTOKARR2(cBufSUB, ";", .T.)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Remove " dos itens do array criado³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						For nX := 1 To Len(aDetBUF)
							aDetBUF[nX] := STRTRAN(aDetBUF[nX], '"', '')
						Next nX
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Considera apenas as linhas com 6 itens³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If Len(aDetBUF) == 6
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Prepara variaveis com os dados da linha atual do arquivo³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							cDatLan := CTOD(aDetBUF[1])
							cNomFor := aDetBUF[2]
							cNomFan	:= aDetBUF[3]
							cCpfFor	:= PADR(STRTRAN(aDetBUF[4], '-', ''), TAMSX3("A2_CGC")[1])
							cNfeVen	:= STRZERO(VAL(STRTRAN(aDetBUF[5], ".", "")), 9)
							nVlrVen := VAL(STRTRAN(aDetBUF[6], ",", "."))
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Adiciona informações ao array de movimentos à serem importados³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							RECLOCK(cAliasTMP, .T.)
								(cAliasTMP)->XX_FILIAL := xFilial("ZLB")
								(cAliasTMP)->XX_DTMOV  := cDatLan
								(cAliasTMP)->XX_CPFFOR := cCpfFor
								(cAliasTMP)->XX_CODFOR := cNomFan
								(cAliasTMP)->XX_NOMFOR := cNomFor
								(cAliasTMP)->XX_NUMNFE := cNfeVen
								(cAliasTMP)->XX_VLRNFE := nVlrVen
							(cAliasTMP)->(MSUNLOCK())
						EndIf
					Else
						exit
					EndIf
				End
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Fecha o arquivo utilizado para leitura das informações³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				fClose(nHdl)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Obtém o número de registros da tabela temporária³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				nTotReg := (cAliasTMP)->(RECCOUNT())
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Caso existam registros na tabela temporária, executa demais regras de importação³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If nTotReg > 0
					nRegImp := 1
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Atualiza o log de execução da rotina³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					oProcess:SaveLog("Importando movimentos para conta corrente...")
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa laço para inclusão na Conta Corrente³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					(cAliasTMP)->(dbGoTop())
					While (cAliasTMP)->(!EOF())
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Incremente barra de processamento³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						nRegImp++
						oProcess:IncRegua1("Importando movimento " + ALLTRIM(STR(nRegImp)) + " de " + ALLTRIM(STR(nTotReg)) + "...")
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Posiciona no cadastro do Fornecedor vinculado ao item do arquivo CSV posicionado³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						dbSelectArea("SA2")
						SA2->(dbSetOrder(3))
						SA2->(dbGoTop())
						If SA2->(dbSeek(xFilial("SA2") + (cAliasTMP)->XX_CPFFOR))
							lValido := .F.
							nSA2Rec := SA2->(RECNO())
							While SA2->(!EOF()) .AND. SA2->A2_FILIAL == xFilial("SA2") .AND. SA2->A2_CGC == (cAliasTMP)->XX_CPFFOR
								If SA2->A2_MSBLQL != "1"
									lValido := .T.
									exit
								EndIf
								
								SA2->(dbSkip())
							End
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Executa demais regras, caso tenha encontrado cadastro do fornecedor que seja válido³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If lValido
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Verifica se já existe registro deste movimento para o produtor³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								dbSelectArea("ZLB")
								ZLB->(dbSetOrder(5))
								ZLB->(dbGoTop())
								If !ZLB->(dbSeek(xFilial("ZLB") + SA2->A2_COD + SA2->A2_LOJA + DTOS((cAliasTMP)->XX_DTMOV) + (cAliasTMP)->XX_NUMNFE))
									cDetHist := "REF. NF " + ALLTRIM((cAliasTMP)->XX_NUMNFE)
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Prepara array para inclusão do Mov. Conta Corrente³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									aMOV004 := {}
									AADD(aMOV004, {'ZLB_FILIAL'	, xFilial("ZLB")		, Nil})
									AADD(aMOV004, {'ZLB_FORNEC'	, SA2->A2_COD			, Nil})
									AADD(aMOV004, {'ZLB_LOJFOR'	, SA2->A2_LOJA			, Nil})
									AADD(aMOV004, {'ZLB_NOMFOR'	, SA2->A2_NOME			, Nil})
									AADD(aMOV004, {'ZLB_TIPCD'	, "D"					, Nil})
									AADD(aMOV004, {'ZLB_TPDESP'	, cCodMot				, Nil})
									AADD(aMOV004, {'ZLB_VALOR'	, (cAliasTMP)->XX_VLRNFE, Nil})
									AADD(aMOV004, {'ZLB_DTMOV'	, (cAliasTMP)->XX_DTMOV	, Nil})
									AADD(aMOV004, {'ZLB_NF3'	, (cAliasTMP)->XX_NUMNFE, Nil})
									AADD(aMOV004, {'ZLB_HIST'	, cDetHist				, Nil})
									AADD(aMOV004, {'ZLB_DESDOB'	, "N"					, Nil})
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Executa rotina de inclusão do movimento na Conta Corrente do produtor³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									MSExecAuto({|x,y| U_LTMOV004(x,y)}, aMOV004, 3)
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Verifica se ocorreu erro na inclusão do Mov. Conta Corrente³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									If lMsErroAuto
										lMsErroAuto := .F.
										RECLOCK(cAliasTMP, .F.)
											(cAliasTMP)->XX_OBS    := ALLTRIM(SUBSTR(MOSTRAERRO("\" + cPathErro, "ltmov004_erro.txt"), 1, 80))
											//(cAliasTMP)->XX_CODFOR := SA2->A2_COD
											//(cAliasTMP)->XX_LOJFOR := SA2->A2_LOJA
											(cAliasTMP)->XX_STATUS := "2"
										(cAliasTMP)->(MSUNLOCK())
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Após inclusão com sucesso, adiciona informações na tabela temporária³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										RECLOCK(cAliasTMP, .F.)
											(cAliasTMP)->XX_OBS    := "MOVIMENTO REALIZADO"
											//(cAliasTMP)->XX_CODMOV := ZLB->ZLB_COD
											//(cAliasTMP)->XX_CODFOR := SA2->A2_COD
											//(cAliasTMP)->XX_LOJFOR := SA2->A2_LOJA
											//(cAliasTMP)->XX_STATUS := "1"
										(cAliasTMP)->(MSUNLOCK())
									EndIf
								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Caso localizou o movimento já existente, registra log de observação³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									RECLOCK(cAliasTMP, .F.)
										(cAliasTMP)->XX_OBS    := "MOVIMENTO IMPORTADO ANTERIORMENTE"
										//(cAliasTMP)->XX_CODMOV := ZLB->ZLB_COD
										//(cAliasTMP)->XX_CODFOR := SA2->A2_COD
										//(cAliasTMP)->XX_LOJFOR := SA2->A2_LOJA
										(cAliasTMP)->XX_STATUS := "2"
									(cAliasTMP)->(MSUNLOCK())
								EndIf
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Não existe cadastro válido para o fornecedor vinculado ao movimento³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								RECLOCK(cAliasTMP, .F.)
									(cAliasTMP)->XX_OBS    := "NÃO EXISTE CADASTRO DE FORNECEDOR VÁLIDO"
									(cAliasTMP)->XX_CODMOV := ""
									(cAliasTMP)->XX_CODFOR := ""
									(cAliasTMP)->XX_LOJFOR := ""
									(cAliasTMP)->XX_STATUS := "2"
								(cAliasTMP)->(MSUNLOCK())
							EndIf
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Caso não localizou o fornecedor, registra log de observação³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							RECLOCK(cAliasTMP, .F.)
								(cAliasTMP)->XX_OBS    := "FORNECEDOR NÃO LOCALIZADO"
								(cAliasTMP)->XX_CODFOR := ""
								(cAliasTMP)->XX_LOJFOR := ""
								(cAliasTMP)->XX_STATUS := "2"
							(cAliasTMP)->(MSUNLOCK())
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Posiciona no próximo registro para importação³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						(cAliasTMP)->(dbSkip())
					End
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa função para geração de relatório de log de execução³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					oProcess:IncRegua1("Gerando relatório de logs....")
					oProcess:IncRegua2("Finalizando - Conta Corrente Produtor")
					oProcess:SaveLog("Gerando relatório com os logs de execução...")
					MOV011REL()
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Alerta o usuário, pois não foram localizadas informações para importação³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					U_GLALL001("Atenção", "Não foi possível obter informações para importação no arquivo informado.", "Verifique o arquivo utilizado para importação.")
				EndIf
			EndIf
		EndIf
EndCase

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGETTXT   ºAutor  ³Marcelo Joner        º Data ³ 17/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela leitura do arquivo de movimentos pa-º±±
±±º          ³ra importação na Conta Corrente dos produtores.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FGETTXT(cTXT, nPOSATUAL, cSRT)

Local cRET := ""
Local nI := 0

If nPOSATUAL < Len(cTXT)
	For nI := nPOSATUAL to Len(cTXT)
		If ! SubSTR(cTXT,nI,1) $ cSRT
			cRET += SubSTR(cTXT,nI,1)
		Else                  
			If cSRT == CHR(13)+CHR(10)
				nPOSATUAL := nI+2
			Else                 
				nPOSATUAL := nI+1
			EndIf
			Exit
		EndIf
	Next nI
EndIf

Return cRET





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MOV011REL  º Autor ³Marcelo Joner       º Data ³ 17/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Função de execução de relatório de log ao término da execu- º±±
±±º          ³ção da importação de movimentos de conta corrente.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MOV011REL()

Private oReport
Private cFile		:= "LTMOV11REL"
Private cTitle		:= "Log - Importação Conta Corrente"
Private cHelp		:= "Relatório responsável por apresentar as principais informações à respeito do log de execução da importação de movimentos na conta corrente dos produtores."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria o objeto pertinente ao processamento do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oReport := REL011()
oReport:PRINTDIALOG()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REL011  ºAutor  ³Marcelo Joner        º Data ³  17/04/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pelo processamento das demais regras em  º±±
±±º          ³torno da execução do relatório.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function REL011()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria o componente de processamento do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oReport := TReport():New(cFile, cTitle,, {|oReport| REL011PRT(oReport)}, cHelp,, "")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)
oReport:bTotalPrint := {|| }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria a sessão principal de FILIAIS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oSection1 := TRSection():New(oReport, "FILIAL", {"SM0"}, {})
oSection1:cAlias := cAliasTMP
TRCell():New(oSection1, "XX_FILIAL"	, ""   , "Filial")
TRCell():New(oSection1, "M0_FILIAL"	, "SM0", "Descrição", "@!", 50,, {|| POSICIONE("SM0", 1, cEmpAnt + (cAliasTMP)->XX_FILIAL, "M0_FILIAL")})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria a sessão principal de MOVIMENTOS PROCESSADOS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oSection2 := TRSection():New(oSection1, "Movimentos Processados", {})
oSection2:SetLeftMargin(02)
oSection2:cAlias := cAliasTMP
oSection2:lHeaderVisible := .T.
TRCell():New(oSection2, "XX_DTMOV"	, "", "Data Mov.",,10)
//TRCell():New(oSection2, "XX_CODMOV"	, "", "Código Mov.",,TAMSX3("ZLB_COD")[1])
TRCell():New(oSection2, "XX_CPFFOR"	, "", "Cpf\Cnpj",,TAMSX3("A2_CGC")[1])
TRCell():New(oSection2, "XX_CODFOR"	, "", "Fornecedor",,TAMSX3("A2_COD")[1])
TRCell():New(oSection2, "XX_LOJFOR"	, "", "Loja",,TAMSX3("A2_LOJA")[1])
TRCell():New(oSection2, "XX_NOMFOR"	, "", "Nome",,TAMSX3("A2_NOME")[1])
TRCell():New(oSection2, "XX_NUMNFE"	, "", "Nota Fiscal",,TAMSX3("ZLB_NF3")[1])
TRCell():New(oSection2, "XX_VLRNFE"	, "", "Valor",PESQPICT("ZLB", "ZLB_VALOR"),TAMSX3("ZLB_VALOR")[1])
TRCell():New(oSection2, "XX_OBS"	, "", "Observações",,100)

Return oReport





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REL011PRT   ºAutor  ³Marcelo Joner      º Data ³ 17/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução das regras em torno da exe-º±±
±±º          ³cução do relatório de log de processamento.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function REL011PRT(oReport)

Local oSection1	:= oReport:Section(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria indice e posiciona no primeiro registro da tabela temporária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea(cAliasTMP)
IndRegua(cAliasTMP, cTabTMP, "XX_STATUS+DTOS(XX_DTMOV)+XX_CODFOR+XX_LOJFOR",,, "Selecionando Registros...")
(cAliasTMP)->(dbSetOrder(1))
(cAliasTMP)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Seta regra de contador do processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa a impressão das sessões do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oSection1:Print()

Return
