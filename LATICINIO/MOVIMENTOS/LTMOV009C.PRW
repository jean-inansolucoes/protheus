#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019TRP  ºAutor  ³Marcelo Joner        º Data ³ 27/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função referente há execução das regras em torno da funcionaº±±
±±º          ³lidade Conciliar browse da rotina de Pesagem.       		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019TRP(cAlias, nReg, nOpc, lExeCon)

//Local aArea			:= GetArea()
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aBotoes		:= {}
	Local aCpoCab		:= {}
	Local aAltCab		:= {}
	Local aCpoCon		:= {}
	Local aAltCon		:= {}
	Local aCpoTot		:= {}
	Local aAltTot		:= {}
	Local aVwTRP		:= {}
	Local lF3			:= .F.
	Local lColumn		:= .F.
	Local lMemoria		:= .T.
	Local lNoFolder		:= .T.
	Local lProperty		:= .F.
	Local lInverte		:= .F.
	Local lShare		:= .T.
	Local lReadOnly		:= .F.
//Local nI			:= 0
	Local nX			:= 0
	Local nOpcao		:= 2
	Local cMarca		:= GetMark()
//Local cCadOld		:= cCadastro

	Private oBrwTrp
	Private oGetCon
	Private aGets[0]
	Private aGets1[0]
	Private aGets2[0]
	Private aGets3[0]
	Private aTela[0][0]
	Private aTela1[0][0]
	Private aTela2[0][0]
	Private aTela3[0][0]

	Private lTemNf		:= !EMPTY(ZM1->ZM1_NFCOM)
	Private cAliasTRP	:= GetNextAlias()

	Private bCampo		:= {|nCPO| Field(nCPO)}

	Private VISUAL		:= .F.
	Private INCLUI		:= .F.
	Private ALTERA		:= .T.
	Private DELETA		:= .F.

	Default cAlias		:= "ZM1"
	Default nReg		:= 0
	Default nOpc		:= 2
	Default lExeCon		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Posiciona no cadastro do produto vinculado há pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	If SB1->(dbSeek(xFilial("SB1") + ZM1->ZM1_PROD))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Havendo Tipo Análise vinculada ao produto da pesagem, valida se há foram informados as análises de qualidade³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		lDetQld := .T.
		If !EMPTY(SB1->B1_X_TPANA)
			lDetQld := ZM1->ZM1_SITQLD == "F"
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa sequência, caso as regras de análise de qualidade para o produto\pesagem estejam de acordo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If lDetQld

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa demais regras, caso exista regra de obtenção do fator de conversão definida no cadastro do produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !EMPTY(SB1->B1_X_FCONV)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa à fórmula para obter o fator de conversão³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				nFator := FORMULA(SB1->B1_X_FCONV)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Caso seja obtido fator numérico maior que zero, executa demais regras³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If Type("nFator") == "N" .AND. nFator > 0

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Altera o título apresentado na interface ao usuário³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cCadastro := "Pesagens - Conciliar"

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Monta arrays com estruturas para MsMGet³
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					aCpoCab := {"NOUSER", "ZM1_COD", "ZM1_TIPO", "ZM1_DATA", "ZM1_PROD", "ZM1_DESC", "ZM1_TRANSP", "ZM1_DTRANS", "ZM1_CODVEI", "ZM1_PLACA", "ZM1_CODMOT", "ZM1_NOMMOT", "ZM1_CODLIN", "ZM1_NOMLIN"}
					aAltCab := {}
					aCpoTot := {"NOUSER", "ZM1_KGINI", "ZM1_DTINI", "ZM1_HRINI", "ZM1_KGFIN", "ZM1_DTFIN", "ZM1_HRFIN", "ZM1_KGBRT"}
					aAltTot := {}

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Havendo nota fiscal vinculada há pesagem, não considera vinculo de MOV. TRANSPORTADOR³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If lTemNf
						aCpoCon := {"NOUSER", "ZM1_LTBRT", "ZM1_TPNOTA", "ZM1_LTNOTA", "ZM1_LTDIF", "ZM1_QLD022", "ZM1_SLKG", "ZM1_SLLT", "ZM1_SITCON", "ZM1_PRCSOL", "ZM1_FATCON"}
						aAltCon := IIF(lExeCon, {"ZM1_TPNOTA","ZM1_LTNOTA", "ZM1_SITCON","ZM1_PRCSOL"}, {})
					ELse
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Demais casos, considera vinculo de MOV. TRANSPORTADOR³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						aCpoCon := {"NOUSER", "ZM1_LTBRT", "ZM1_LTMOV", "ZM1_LTDIF", "ZM1_LTDESC", "ZM1_DESTRP", "ZM1_LTVAZ", "ZM1_SITCON"}
						aAltCon := IIF(lExeCon, {"ZM1_DESTRP", "ZM1_SITCON"}, {})
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Composição de arrays com estrutura dos campos para visualização³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					AADD(aVwTRP, {"ZL7_COD"   	, "", "Código"		 , U_LTALLXSX3("ZL7_COD")[6]   	})
					AADD(aVwTRP, {"ZL7_DATA"	, "", "Data"		 , U_LTALLXSX3("ZL7_DATA")[6]	})
					AADD(aVwTRP, {"ZL7_HORA"	, "", "Hora"		 , U_LTALLXSX3("ZL7_HORA")[6]	})
					AADD(aVwTRP, {"ZL7_PLACA"	, "", "Placa"		 , U_LTALLXSX3("ZL7_PLACA")[6]	})
					AADD(aVwTRP, {"ZL7_LINHA"   , "", "Linha"		 , U_LTALLXSX3("ZL7_LINHA")[6]  })
					AADD(aVwTRP, {"ZL7_NOMLIN"  , "", "Descrição"	 , U_LTALLXSX3("ZL7_NOMLIN")[6] })
					AADD(aVwTRP, {"ZL7_QTDTRP"  , "", "Qtd. Transp." , U_LTALLXSX3("ZL7_QTDTRP")[6] })
					AADD(aVwTRP, {"ZL7_QTDVAZ"  , "", "Qtd. Vazão"	 , U_LTALLXSX3("ZL7_QTDVAZ")[6] })
					AADD(aVwTRP, {"ZL7_QTDSOB"  , "", "Qtd. Sobra"	 , U_LTALLXSX3("ZL7_QTDSOB")[6] })
					AADD(aVwTRP, {"ZL7_QTDFAL"  , "", "Qtd. Falta"	 , U_LTALLXSX3("ZL7_QTDFAL")[6] })
					AADD(aVwTRP, {"ZL7_QTDANT"  , "", "Qtd. Desconto", U_LTALLXSX3("ZL7_QTDANT")[6] })
					AADD(aVwTRP, {"ZL7_QTDDES"  , "", "Qtd. Descarte", U_LTALLXSX3("ZL7_QTDDES")[6] })

					aStruTRP := ZL7->(dbStruct())

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa consulta SQL de busca dos MOV. TRANSPORTADOR vinculados à pesagem³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cQuery := "SELECT ZL7.*											" + CRLF
					cQuery += "FROM " + RetSQLName("ZL7") + " ZL7					" + CRLF
					cQuery += "WHERE ZL7.ZL7_FILIAL  = '" + xFilial("ZL7") + "'		" + CRLF
					cQuery += "  AND ZL7.ZL7_NUMPES  = '" + ZM1->ZM1_NUM   + "'		" + CRLF
					cQuery += "  AND ZL7.D_E_L_E_T_ <> '*'							" + CRLF

					cQuery += "ORDER BY ZL7_FILIAL, ZL7_DATA, ZL7_HORA, ZL7_COD		" + CRLF

					cArqTrab  := CriaTrab(aStruTRP, .T. )

					If Select(cAliasTRP) > 0
						(cAliasTRP)->(dbCloseArea())
					EndIf

					cQuery := ChangeQuery(cQuery)

					TCQUERY cQuery NEW ALIAS cAliasTRP

					Copy TO &cArqTrab
					dBCloseArea()
					dBUseArea(.T.,, cArqTrab, cAliasTRP, lShare, lReadOnly)
					(cAliasTRP)->(dbGoTop())

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Atribui aos campos em memória, os valores do registro da tabela posicionado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					dbSelectArea(cAlias)
					For nX := 1 TO FCount()
						M->&(Eval(bCampo, nX)) := FieldGet(nX)
					Next nX

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa regras para composição do KG Descarte³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					nLtPlataforma := 0
					dbSelectArea("ZM3")
					ZM3->(dbSetOrder(1))
					ZM3->(dbGoTop())
					If ZM3->(dbSeek(xFilial("ZM3") + M->ZM1_NUM))
						While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == M->ZM1_NUM
							nLtPlataforma += (ZM3->ZM3_KGANT - ZM3->ZM3_KGPOS)
							ZM3->(dbSkip())
						End
					EndIf


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa regras de cálculo do fator de conversão³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If nLtPlataforma == 0
						M->ZM1_FATCON := IIF(M->ZM1_FATCON == 0, nFator, M->ZM1_FATCON)
						M->ZM1_LTBRT  := IIF(M->ZM1_LTBRT  == 0, ROUND((M->ZM1_KGBRT  * M->ZM1_FATCON), 0), M->ZM1_LTBRT)
						M->ZM1_LTDESC := IIF(M->ZM1_LTDESC == 0, ROUND(((ZM1->ZM1_KGIDES-ZM1->ZM1_KGFDES) * M->ZM1_FATCON), 0), M->ZM1_LTDESC)
					Else
						M->ZM1_FATCON := IIF(M->ZM1_FATCON == 0, nFator, M->ZM1_FATCON)
						M->ZM1_LTBRT  := IIF(M->ZM1_LTBRT  == 0, ROUND((nLtPlataforma * M->ZM1_FATCON), 0), M->ZM1_LTBRT)
						M->ZM1_LTDESC := IIF(M->ZM1_LTDESC == 0, ROUND((ZM1_KGBRT * M->ZM1_FATCON), 0), M->ZM1_LTDESC)
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa função de cálculo dos solidos³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If lTemNf
						aDetSL := LT019CLCSL()
						M->ZM1_QLD022 := IIF(M->ZM1_QLD022 == 0, aDetSL[1], M->ZM1_QLD022)
						M->ZM1_SLKG   := IIF(M->ZM1_SLKG   == 0, aDetSL[2], M->ZM1_SLKG)
						M->ZM1_SLLT   := IIF(M->ZM1_SLLT   == 0, aDetSL[3], M->ZM1_SLLT)
						M->ZM1_LTDIF  := IIF(M->ZM1_LTDIF  == 0, ROUND(((M->ZM1_LTBRT + M->ZM1_LTDESC) - M->ZM1_LTNOTA), 0) , M->ZM1_LTDIF)
						M->ZM1_PRCSOL := IIF(M->ZM1_PRCSOL == 0 .AND. ZM1->ZM1_SITCON !='F', U_LTPRCSOL(),M->ZM1_PRCSOL)
					Else
						M->ZM1_LTDIF  := IIF(M->ZM1_LTDIF  == 0, ROUND(((M->ZM1_LTBRT + M->ZM1_LTDESC) - M->ZM1_LTMOV), 0) , M->ZM1_LTDIF)
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Caso encontre dados de conciliação pergunta se quer preprocessar³
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If ZM1->ZM1_FATCON != 0 .and. ZM1->ZM1_SITCON == 'P' .AND. lExeCon .and. lTemNf
						
							LT019RECC(lTemNf, aDetSL)
						
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Havendo ocorrência de Conciliação, disponibiliza opção para visualização do log³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(ZM1->ZM1_USRCON)
						AADD(aBotoes, {"UPDWARNING", {|| LT019LOG()}, "Log"})
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Havendo ocorrência de Conciliação, disponibiliza opção para visualização do log³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(ZM1->ZM1_USRCON)

						AADD(aBotoes, {"UPDMOVIMEN", {|| LT019RECC(lTemNf, aDetSL)}, "Recalcula"})
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³estorno do preço do Sólido para quepossibilite alteração da ZME				³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If __cUserId $ SuperGetMV("MX_PRECCON",,"")
						AADD(aBotoes, {"UPDPRECO", {|| LT019ZERPR(lTemNf, aDetSL)}, "Zera Preço"})
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Calcula tamanho\posicionamento da interface³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					aSize := MsAdvSize()
					AADD(aObjects, {100, 030, .T., .T.})
					AADD(aObjects, {100, 070, .T., .T.})
					aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
					aPosObj := MsObjSize(aInfo, aObjects, .T.)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Definição do Dialog e demais componentes da interface³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
					oDlg:bInit := {|| ENCHOICEBAR(oDlg,{|| IIF(LT019TOK(), (oDlg:End(), nOpcao := 1), )}, {|| (oDlg:End(), nOpcao := 2)},.F.,aBotoes), LT019INI(lExeCon)}

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Componentes referentes ao CABEÇALHO³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					oGetCab := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoCab, {aPosObj[1,1], aPosObj[1,2], aPosObj[1,3], aPosObj[1,4]}, aAltCab, 2,/*nColMens*/,/*cMensagem*/,'',oDlg, lF3, lMemoria, lColumn,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
					aGets1 := AClone(aGets)
					aTela1 := AClone(aTela)
					aGets  := {}
					aTela  := {}


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Componentes da sessão de COLETAS³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					oGrpTrp := TGroup():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]-148,"Mov. Transportador",oDlg,CLR_HBLUE,CLR_WHITE,.T.,.F.)
					oBrwTrp := MsSelect():New(cAliasTRP,"","", aVwTRP,@lInverte,@cMarca,{aPosObj[2,1]+009,aPosObj[2,2]+003,aPosObj[2,3]-020,aPosObj[2,4]-152},,,oDlg)
					oBrwTrp:oBrowse:lHasMark     := .F.
					oBrwTrp:oBrowse:lCanAllMark  := .F.
					oBrwTrp:oBrowse:bLdBlClick := {|| IIF(!EMPTY((cAliasTRP)->ZL7_COD), LT019TRPAJ(), )}
					oBrwTrp:oBrowse:lActive := !lTemNf .AND. lExeCon

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Cria opções do botão de DETALHES da interface³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					oMnImp := TMenu():New(0,0,0,0,.T.)
					oTMnPrd := TMenuItem():New(oDlg, "Mov. &Produtor",,,,{|| LT019DET("P")},,,,,,,,,.T.)
					oMnImp:Add(oTMnPrd)
					oTMnTrp := TMenuItem():New(oDlg, "Mov. &Transportador",,,,{|| LT019DET("T")},,,,,,,,,.T.)
					oMnImp:Add(oTMnTrp)

					oButAdd := TButton():New(aPosObj[2,3]-017, aPosObj[2,2]+003, "&Adicionar", oDlg, {|| LT019ADD()}, 50,12,,,.F.,.T.,.F.,,.F.,,,.F. )
					oButAdd:lActive := !lTemNf .AND. lExeCon

					oButDet := TButton():New(aPosObj[2,3]-017, aPosObj[2,2]+063, "&Detalhes", oDlg, {|| }, 50,12,,,.F.,.T.,.F.,,.F.,,,.F. )
					oButDet:SetPopupMenu(oMnImp)
					oButDet:lActive := !lTemNf .AND. lExeCon

					oButRem := TButton():New(aPosObj[2,3]-017, aPosObj[2,2]+123, "&Remover", oDlg, {|| LT019DEL()}, 50,12,,,.F.,.T.,.F.,,.F.,,,.F. )
					oButRem:lActive := !lTemNf .AND. lExeCon

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Componentes da sessão de PESAGEM³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					oGrpTot := TGroup():New(aPosObj[2,1],aPosObj[2,4]-142,aPosObj[2,3]-132,aPosObj[2,4],"Pesagem",oDlg,CLR_HBLUE,CLR_WHITE,.T.,.F.)

					oGetTot := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoTot, {aPosObj[2,1]+009,aPosObj[2,4]-138,aPosObj[2,3]-135,aPosObj[2,4]-003}, aAltTot, 2,/*nColMens*/,/*cMensagem*/,'',oDlg, lF3, lMemoria, .T.,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
					aGets2 := AClone(aGets)
					aTela2 := AClone(aTela)
					aGets  := {}
					aTela  := {}


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Componentes da sessão de CONCILIAÇÃO³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					oGrpCon := TGroup():New(aPosObj[2,3]-130,aPosObj[2,4]-142,aPosObj[2,3],aPosObj[2,4],"Conciliação",oDlg,CLR_HBLUE,CLR_WHITE,.T.,.F.)
					oGetCon := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoCon, {aPosObj[2,3]-119,aPosObj[2,4]-138,aPosObj[2,3]-003,aPosObj[2,4]-003}, aAltCon, 2,/*nColMens*/,/*cMensagem*/,'',oDlg, lF3, lMemoria, .T.,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
					aGets3 := AClone(aGets)
					aTela3 := AClone(aTela)
					aGets  := {}
					aTela  := {}

					SetFocus(oBrwTrp:oBrowse:hWnd)

					ACTIVATE MSDIALOG oDlg

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Confirmando à tela, grava movimentos no banco³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If lExeCon .AND. nOpcao == 1
						LT019GRV()
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Finaliza o alias temporário utilizado pela função³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If Select(cAliasTRP) > 0
						(cAliasTRP)->(dbCloseArea())
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Alerta o usuário pois o fator de conversão obtido é inválido³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					U_LTALL001("Atenção", "O fator de conversão obtido para à pesagem é inválido.", "Favor verificar as definições do fator de conversão no cadastro do produto vinculado à está pesagem.")
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Alerta o usuário pois não há regra de fator de conversão para o produto da pesagem³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				U_LTALL001("Atenção", "Não existe regra de composição do fator de conversão para o produto desta pesagem.", "Favor verificar as definições do cadastro do produto vinculado à está pesagem.")
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Alerta o usuário, pois não foi finalizado o processo de registro das análises de qualidade vinculadas à pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			U_LTALL001("Atenção", "Não foram finalizadas as análises de qualidade vinculadas à está pesagem.", "É necessário que as análises de qualidade sejam finalizadas antes de executar está funcionalidade.")
		EndIf
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019TOK  ºAutor  ³Marcelo Joner        º Data ³ 29/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela validação geral da interface de     º±±
±±º          ³Conciliação sob o registro de Pesagem.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019TOK()

	Local lRet		:= .T.
	Local nDesTrp	:= 0
	Local nLitDes	:= 0
	Local cPrdLin	:= GETMV("MV_ZL00005",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Regras de validação quando existe NOTA vinculada há pesagem - não vincula MOV. TRANSPORTADOR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lTemNf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Aplica regras, caso o produto não necessita de controle de LINHA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !(ALLTRIM(M->ZM1_PROD) $ cPrdLin)
			Do Case

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida obrigatoriedade na informação do campo LT Nota³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			Case M->ZM1_LTNOTA == 0
				U_LTALL001("Atenção", "Não foi informado o total de litros presente na nota fiscal vinculada há pesagem.", "Favor informar à quantidade de litros do produto presente na nota fiscal.")
				lRet := .F.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida obrigatoriedade na informação do campo TP Nota³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			Case EMPTY(ALLTRIM(M->ZM1_TPNOTA))
				U_LTALL001("Atenção", "Não foi informado o TIPO da nota fiscal vinculada há pesagem.", "Favor informar se a Nota Fsical é de Compra ou Remessa.")
				lRet := .F.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida obrigatoriedade na composição do valor de SÓLIDOS KG³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			Case M->ZM1_SLKG == 0
				U_LTALL001("Atenção", "Não foi composto o valor de sólidos sob o peso bruto da carga.", "Favor verificar com o departamento de qualidade à análise de ST Brix.")
				lRet := .F.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida obrigatoriedade na composição do valor de SÓLIDOS LT³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			Case M->ZM1_SLLT == 0
				U_LTALL001("Atenção", "Não foi composto o valor de sólidos sob o total de litros bruto da carga.", "Favor verificar com o departamento de qualidade à análise de ST Brix.")
				lRet := .F.
			EndCase

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Valida obrigatoriedade na informação do campo LT Nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		ElseIf M->ZM1_LTNOTA == 0
			U_LTALL001("Atenção", "Não foi informado o total de litros presente na nota fiscal vinculada há pesagem.", "Favor informar à quantidade de litros do produto presente na nota fiscal.")
			lRet := .F.
		EndIf

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Regras de validação quando não existe NOTA vinculada há pesagem - vincula MOV. TRANSPORTADOR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Não permite prosseguir caso à quantidade LT. BRUTO seja diferente de LT VAZAO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If (M->ZM1_LTVAZ != M->ZM1_LTBRT) .AND. M->ZM1_LTVAZ > 0
			U_LTALL001("Atenção", "O total de litros do LT Movimento é diferente do total de Litros Plataforma.", "Favor verificar os movimentos de transportador vinculados à pesagem.")
			lRet := .F.
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Valida que os MOV. TRANSPORTADOR vinculados à pesagem não tenham sido utilizados em outras pesagems³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nRecTRP := (cAliasTRP)->(RECNO())
			dbSelectArea(cAliasTRP)
			(cAliasTRP)->(dbGoTop())
			While (cAliasTRP)->(!EOF())
				dbSelectArea("ZL7")
				ZL7->(dbSetOrder(1))
				ZL7->(dbGoTop())
				If ZL7->(dbSeek(xFilial("ZL7") + (cAliasTRP)->ZL7_COD))
					If !EMPTY(ZL7->ZL7_NUMPES) .AND. ZL7->ZL7_NUMPES != ZM1->ZM1_NUM
						U_LTALL001("Atenção", "O Mov. Transportador (" + ALLTRIM(ZL7->ZL7_COD) + ") está vinculado há outra pesagem (" + ALLTRIM(ZL7->ZL7_NUMPES) + ").", "É necessário que seja vinculado à pesagem, apenas Mov. Transportador que não possuam vinculo há nenhuma outra pesagem.")
						lRet := .F.
						exit
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Atualiza variáveis com valor total de LT Desconto e LT Descarte distribuídos nos Mov. Transportador vinculados à Pesagem³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				nDesTrp += (cAliasTRP)->ZL7_QTDANT
				nLitDes += (cAliasTRP)->ZL7_QTDDES
				(cAliasTRP)->(dbSkip())
			End

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Valida se o LT DESCONTO TRANSPORTADOR DISTRIBUÍDO é igual ao LT DESCONTO TOTAL³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If lRet .AND. nDesTrp != M->ZM1_DESTRP
				U_LTALL001("Atenção", "A quantidade de LT Desconto (" + ALLTRIM(TRANSFORM(nDesTrp, PESQPICT("ZM1", "ZM1_DESTRP"))) + ") atribuída em Mov. Transportador, é inferior à quantidade LT Desconto total (" + ALLTRIM(TRANSFORM(M->ZM1_DESTRP, PESQPICT("ZM1", "ZM1_DESTRP"))) + ").", "É necessário que o total de LT Desconto esteja completamente vinculado à Mov. Transportador da Pesagem.")
				lRet := .F.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Valida se o LT DESCARTE DISTRIBUÍDO é igual ao LT DESCARTE TOTAL³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If lRet .AND. nLitDes != M->ZM1_LTDESC
				U_LTALL001("Atenção", "A quantidade de LT Descarte (" + ALLTRIM(TRANSFORM(nLitDes, PESQPICT("ZM1", "ZM1_LTDESC"))) + ") atribuída em Mov. Transportador, é inferior à quantidade LT Descarte total (" + ALLTRIM(TRANSFORM(M->ZM1_LTDESC, PESQPICT("ZM1", "ZM1_LTDESC"))) + ").", "É necessário que o total de LT Descarte esteja completamente vinculado à Mov. Transportador da Pesagem.")
				lRet := .F.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Restaura posicionamento original do grid de Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			(cAliasTRP)->(dbGoTo(nRecTRP))
		EndIf
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019ADD  ºAutor  ³Marcelo Joner        º Data ³ 27/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela disponibilização dos recursos para aº±±
±±º          ³inclusão de MOV. TRANSPORTADOR no grid de Coletas.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019ADD()

	Local nI			:= 0
	Local nOpcao		:= 2
	Local lRet			:= .T.
	Local lShare		:= .T.
	Local lReadOnly		:= .F.
	Local cCadOld		:= cCadastro
	Local aArea			:= GetArea()
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aPosObj		:= {}
//Local aDetQld		:= {}
	Local aVwZL7  		:= {{"ZL7_COD"		, "", U_LTALLXSX3("ZL7_COD")[1]		, U_LTALLXSX3("ZL7_COD")[6]		},;
		{"ZL7_DATA"		, "", U_LTALLXSX3("ZL7_DATA")[1]	, U_LTALLXSX3("ZL7_DATA")[6]	},;
		{"ZL7_HORA"		, "", U_LTALLXSX3("ZL7_HORA")[1]	, U_LTALLXSX3("ZL7_HORA")[6]	},;
		{"ZL7_LINHA"	, "", U_LTALLXSX3("ZL7_LINHA")[1]	, U_LTALLXSX3("ZL7_LINHA")[6]	},;
		{"ZL7_NOMLIN"	, "", U_LTALLXSX3("ZL7_NOMLIN")[1]	, U_LTALLXSX3("ZL7_NOMLIN")[6]	},;
		{"ZL7_QTDTRP"	, "", U_LTALLXSX3("ZL7_QTDTRP")[1]	, U_LTALLXSX3("ZL7_QTDTRP")[6]	},;
		{"ZL7_QTDSOB"	, "", U_LTALLXSX3("ZL7_QTDSOB")[1]	, U_LTALLXSX3("ZL7_QTDSOB")[6]	},;
		{"ZL7_QTDFAL"	, "", U_LTALLXSX3("ZL7_QTDFAL")[1]	, U_LTALLXSX3("ZL7_QTDFAL")[6]	}}

	Local aStruct		:= ZL7->(dbStruct())

	Private lInverte	:= .F.
	Private cMarca		:= GetMark()
	Private cAliasZL7	:= GetNextAlias()

	cCadastro := "Movimentos Transportador - Selecionar"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa consulta SQL de busca dos MOV. TRANSPORTADOR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cQuery := "SELECT ZL7.*												" + CRLF
	cQuery += "FROM " + RetSQLName("ZL7") + " ZL7						" + CRLF
	cQuery += "WHERE ZL7.ZL7_FILIAL  = '" + xFilial("ZL7")      + "'	" + CRLF
	cQuery += "  AND ZL7.ZL7_DATA    = '" + DTOS(ZM1->ZM1_DATA) + "'	" + CRLF
	cQuery += "  AND ZL7.ZL7_PLACA    = '" + ZM1->ZM1_PLACA + "'	" + CRLF
	cQuery += "  AND ZL7.ZL7_NUMPES IN (' ', '" + ZM1->ZM1_NUM + "')	" + CRLF
	cQuery += "  AND ZL7.D_E_L_E_T_ <> '*'								" + CRLF

	cQuery += "ORDER BY ZL7_FILIAL, ZL7_DATA, ZL7_HORA, ZL7_COD			" + CRLF

	cArqTrab  := CriaTrab(aStruct, .T. )

	If Select(cAliasZL7) > 0
		(cAliasZL7)->(dbCloseArea())
	EndIf

	cQuery := ChangeQuery(cQuery)

	TCQUERY cQuery NEW ALIAS cAliasZL7

	Copy TO &cArqTrab
	dBCloseArea()
	dBUseArea( .T.,, cArqTrab, cAliasZL7, lShare, lReadOnly )
	(cAliasZL7)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Remove os MOV. TRANSPORTADOR que estão vinculados à pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	While (cAliasZL7)->(!EOF())
		dbSelectArea(cAliasTRP)
		(cAliasTRP)->(dbGoTop())
		While (cAliasTRP)->(!EOF())
			If (cAliasTRP)->ZL7_COD == (cAliasZL7)->ZL7_COD
				RECLOCK(cAliasZL7, .F.)
				(cAliasZL7)->(DBDELETE())
				(cAliasZL7)->(MSUNLOCK())

				exit
			EndIf
			(cAliasTRP)->(dbSkip())
		End
		(cAliasZL7)->(dbSkip())
	End
	(cAliasZL7)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calcula dimensão da interface\componentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aSize := MsAdvSize()
	aSize[5] -= 100
	aSize[7] := 200

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Montagem dos parâmetros para criação da tela de exibição³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	AAdd(aObjects, {100, 100, .T., .F.})
	aInfo := {aSize[1], aSize[2], aSize[3] / 2, aSize[4] / 2, 2, 2}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta dialog e demais componentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oDlgCons := MSDialog():New(aSize[7],0,aSize[6],(aSize[5]/1.5), cCadastro,,,.F.,,,,,,.T.,,,.T. )
	oDlgCons:bInit := {|| ENCHOICEBAR(oDlgCons, {|| (nOpcao := 1, oDlgCons:End())}, {|| (nOpcao := 2, oDlgCons:End())}, .F., {})}
	oBrwCons := MsSelect():New(cAliasZL7,"","",aVwZL7,@lInverte,@cMarca,{aPosObj[1,1],aPosObj[1,2],(oDlgCons:nClientHeight/2)-11, (oDlgCons:nClientWidth/2)-5},,,oDlgCons)
	oBrwCons:oBrowse:bLDblClick := {|| (nOpcao := 1, oDlgCons:End())}
	oDlgCons:Activate(,,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Confirmando à interface, adiciona o MOV. TRANSPORTADOR à pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If nOpcao == 1
		If !EMPTY((cAliasZL7)->ZL7_COD)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Posiciona no cadastro do Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("ZL7")
			ZL7->(dbSetOrder(1))
			ZL7->(dbGoTop())
			If ZL7->(dbSeek(xFilial("ZL7") + (cAliasZL7)->ZL7_COD))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Verifica se é possível utilizar o Mov. Transportador selecionado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If U_LTMOV2VD()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Vincula os dados do Mov. Transportador à tabela temporária³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					dbSelectArea(cAliasTRP)
					RECLOCK(cAliasTRP, .T.)
					For nI := 1 To FCount()
						FieldPut(nI, (cAliasZL7)->&(FieldName(nI)))
					Next nI
					(cAliasTRP)->(MSUNLOCK())
				EndIf

				oBrwTrp:oBrowse:Refresh()
			EndIf
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha alias temporário utilizado na consulta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If Select(cAliasZL7) > 0
		(cAliasZL7)->(dbCloseArea())
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função de atualização dos totais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	LT019TRPRF()

	RestArea(aArea)
	cCadastro := cCadOld

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019DEL  ºAutor  ³Marcelo Joner        º Data ³ 28/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela disponibilização dos recursos para àº±±
±±º          ³exclusão de MOV. TRANSPORTADOR no grid de Coletas.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019DEL()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Realiza exclusão, desde que esteja posicionado em registro válido no grid³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea(cAliasTRP)
	If !EMPTY((cAliasTRP)->ZL7_COD)
		RECLOCK(cAliasTRP, .F.)
		(cAliasTRP)->(DBDELETE())
		(cAliasTRP)->(MSUNLOCK())

		oBrwTrp:oBrowse:Refresh()
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função de atualização dos totais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	LT019TRPRF()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019DET  ºAutor  ³Marcelo Joner        º Data ³ 29/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela disponibilização dos recursos para àº±±
±±º          ³visualização dos detalhes do MOV. TRANSPORTADOR posicionado º±±
±±º          ³no grid de Coletas.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019DET(cOpcao)

	Local aArea		:= GetArea()
	Local cCadOld	:= cCadastro
	Local cCondicao	:= ""
	Local lMovTrans	:= !EMPTY((cAliasTRP)->ZL7_COD)

	Default cOpcao	:= ""

	Do Case

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras quando trata-se de manipulação MOV. PRODUTOR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case cOpcao == "P"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa rotina de MOV. PRODUTOR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		U_LTMOV001()




		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras quando trata-se de manipulação MOV. TRANSPORTADOR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case cOpcao == "T"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Filtra a ZL7 apenas com o MOV. TRANSPORTADOR vinculado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If lMovTrans
			cCondicao := "ZL7_FILIAL == '" + xFilial("ZL7") + "' .AND. ZL7_COD == '" + (cAliasTRP)->ZL7_COD + "'"
			dbSelectArea("ZL7")
			ZL7->(dbSetOrder(1))
			ZL7->(dbGoTop())
			ZL7->(dbSetFilter({||&(cCondicao)}, cCondicao))
			ZL7->(dbGoTop())
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa rotina de MOV. TRANSPORTADOR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		U_LTMOV002()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Remove o filtro da tabela ZL7 após sair da rotina de MOV. TRANSPORTADOR³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		ZL7->(dbClearFilter())

	EndCase

	RestArea(aArea)
	cCadastro := cCadOld

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019TRPRF  ºAutor  ³Marcelo Joner      º Data ³ 28/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela realização do recalculo dos totais  º±±
±±º          ³de acordo com os MOV. TRANSPORTADOR vinculados à pesagem.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019TRPRF()

	Local nQtdLt	:= 0
	Local nQtdTrp	:= 0
	Local nQtdVaz	:= 0
	Local nRecTRP	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Obtém os totais com base nos MOV. TRANSPORTADOR vinculados à pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea(cAliasTRP)
	(cAliasTRP)->(dbGoTop())
	While (cAliasTRP)->(!EOF())
		nQtdLt  += (cAliasTRP)->ZL7_QTDTRP

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Regras quando é ajuste automático da diferença³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !ISINCALLSTACK("LT019TRPAJ")
			RECLOCK(cAliasTRP, .F.)
			(cAliasTRP)->ZL7_QTDFAL := 0
			(cAliasTRP)->ZL7_QTDSOB := 0
			(cAliasTRP)->ZL7_QTDDES := 0
			(cAliasTRP)->ZL7_QTDVAZ := (cAliasTRP)->ZL7_QTDTRP
			(cAliasTRP)->(MSUNLOCK())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Identifica o MOV. TRANSPORTADOR de maior quantidade para depois sugerir ajuste de diferença³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If (cAliasTRP)->ZL7_QTDTRP > nQtdTrp
				nQtdTrp := (cAliasTRP)->ZL7_QTDTRP
				nRecTRP := (cAliasTRP)->(RECNO())
			EndIf
		EndIf

		(cAliasTRP)->(dbSkip())
	End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza campos na sessão de CONVERSÃO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	M->ZM1_LTMOV := ROUND((nQtdLt), 0)
	M->ZM1_LTDIF := ROUND(((M->ZM1_LTBRT + M->ZM1_LTDESC) - M->ZM1_LTMOV), 0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Havendo diferença entre LT Bruto e LT Coleta, sugere ajuste no MOV. TRANSPORTADOR de maior volume³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea(cAliasTRP)
	(cAliasTRP)->(dbGoTop())
	While (cAliasTRP)->(!EOF())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Regras quando é ajuste automático da diferença³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !ISINCALLSTACK("LT019TRPAJ")
			RECLOCK(cAliasTRP, .F.)
			If (cAliasTRP)->(RECNO()) == nRecTRP
				If M->ZM1_LTDIF >= 0
					(cAliasTRP)->ZL7_QTDSOB := M->ZM1_LTDIF
					(cAliasTRP)->ZL7_QTDDES := M->ZM1_LTDESC
					(cAliasTRP)->ZL7_QTDVAZ := ROUND(((cAliasTRP)->ZL7_QTDTRP + (cAliasTRP)->ZL7_QTDSOB), 0)
				Else
					(cAliasTRP)->ZL7_QTDFAL := ABS(M->ZM1_LTDIF)
					(cAliasTRP)->ZL7_QTDDES := M->ZM1_LTDESC
					(cAliasTRP)->ZL7_QTDVAZ := ROUND(((cAliasTRP)->ZL7_QTDTRP - (cAliasTRP)->ZL7_QTDFAL), 0)
				EndIf
			Else
				(cAliasTRP)->ZL7_QTDVAZ := (cAliasTRP)->ZL7_QTDTRP
			EndIf
			(cAliasTRP)->(MSUNLOCK())
		EndIf

		nQtdVaz += ROUND(((cAliasTRP)->ZL7_QTDVAZ - (cAliasTRP)->ZL7_QTDDES), 0)
		(cAliasTRP)->(dbSkip())
	End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza total de vazão³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	M->ZM1_LTVAZ  := nQtdVaz
//M->ZM1_SITCON := "F"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza os componentes da interface³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	(cAliasTRP)->(dbGoTop())
	oGetCon:Refresh()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019TRPAJ  ºAutor  ³Marcelo Joner      º Data ³ 28/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela apresentação de interface secundáriaº±±
±±º          ³referente há ajuste na diferença junto ao MOV. TRANSPORTADORº±±
±±º          ³posicionado no grid. Executado através de duplo-clique.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019TRPAJ()

	Local nOpc		:= 2
	Local nQuant	:= ABS(M->ZM1_LTDIF)
//Local nTotal	:= ABS(M->ZM1_LTDIF)
	Local nQtdDes	:= M->ZM1_DESTRP
//Local nTotDes	:= M->ZM1_DESTRP
	Local nQtdDesc	:= M->ZM1_LTDESC
//Local nTotDesc	:= M->ZM1_LTDESC
	Local lEdtAju	:= (cAliasTRP)->(RECCOUNT()) > 1 .AND. ABS(M->ZM1_LTDIF) > 0
	Local lEdtDes	:= M->ZM1_DESTRP > 0
	Local lEdtDesc	:= (cAliasTRP)->(RECCOUNT()) > 1 .AND. ABS(M->ZM1_LTDESC) > 0
	Local cCadOld	:= cCadastro
//Local bAlert	:= {|| U_LTALL001("Atenção", "A quantidade de litros informado para o ajuste é superior à diferença total da carga.", "A quantidade de litros de ajuste deve ser menor ou igual à diferença total."), .F.}
//Local bAltDes	:= {|| U_LTALL001("Atenção", "A quantidade de litros informado para o desconto é superior ao desconto total da carga.", "A quantidade de litros de desconto deve ser menor ou igual ao desconto total."), .F.}
//Local bAltDesc	:= {|| U_LTALL001("Atenção", "A quantidade de litros informado para o descarte é superior ao descarte total da carga.", "A quantidade de litros de descarte deve ser menor ou igual ao descarte total."), .F.}

	Private nRecAJU	:= (cAliasTRP)->(RECNO())

	cCadastro := "Movimento Transportador - Ajuste"

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgSel := MSDialog():New(091,232,185,585, cCadastro,,,.F.,,,,,,.T.,,,.T. )
	oSay1  := TSay():New(007,004,{|| "LT Ajuste"},oDlgSel,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,048,008)
	@006,056 MSGET oGet1 VAR nQuant   PICTURE PesqPict("ZM1", "ZM1_LTDIF") OF oDlgSel WHEN lEdtAju PIXEL SIZE 70,008 HASBUTTON
	
	oSay2  := TSay():New(020,004,{|| "LT Desconto"},oDlgSel,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,048,008)
	@019,056 MSGET oGet2 VAR nQtdDes  PICTURE PesqPict("ZM1", "ZM1_LTDIF") OF oDlgSel WHEN lEdtDes PIXEL SIZE 70,008 HASBUTTON
	
	oSay3  := TSay():New(033,004,{|| "LT Descarte"},oDlgSel,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,048,008)
	@032,056 MSGET oGet3 VAR nQtdDesc PICTURE PesqPict("ZM1", "ZM1_LTDIF") OF oDlgSel WHEN lEdtDesc PIXEL SIZE 70,008 HASBUTTON
	
	oSBtn1 := SButton():New(018,143,1,{|| nOpc := 1, oDlgSel:End()},oDlgSel,,"",)
oDlgSel:Activate(,,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Confirmando à interface, proceder com os ajustes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If nOpc == 1
	RECLOCK(cAliasTRP, .F.)
		If M->ZM1_LTDIF > 0
			(cAliasTRP)->ZL7_QTDFAL := 0
			(cAliasTRP)->ZL7_QTDSOB := nQuant
			(cAliasTRP)->ZL7_QTDVAZ := ROUND(((cAliasTRP)->ZL7_QTDTRP + (cAliasTRP)->ZL7_QTDSOB), 2)
		Else
			(cAliasTRP)->ZL7_QTDSOB := 0
			(cAliasTRP)->ZL7_QTDFAL := nQuant
			(cAliasTRP)->ZL7_QTDVAZ := ROUND(((cAliasTRP)->ZL7_QTDTRP - (cAliasTRP)->ZL7_QTDFAL), 2)
		EndIf
		
		(cAliasTRP)->ZL7_QTDANT := nQtdDes
		(cAliasTRP)->ZL7_QTDDES := nQtdDesc
	(cAliasTRP)->(MSUNLOCK())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa função para atualização do grid e totais da tela³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	LT019TRPRF()
EndIf

cCadastro := cCadOld
(cAliasTRP)->(dbGoTo(nRecAJU))

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019CLCSL ºAutor  ³Marcelo Joner       º Data ³ 29/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pelo cálculo de sólidos.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019CLCSL()

	Local nCount	:= 0
	Local nValBrix	:= 0
	Local _cBrix	:= AllTrim(GetMv("MX_LT009BR"))

	If Empty(_cBrix)
		MsgAlert("Não foi definido no parâmetro o código do Brix no cadastro de Análises. Verificar o parâmetro MX_LT009BR")
		Return {0, 0, 0}
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Obtém o valor médio do ST BRIX com base nas análises dos tanques da pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("ZM3")
	ZM3->(dbSetOrder(1))
	ZM3->(dbGoTop())
	If ZM3->(dbSeek(xFilial("ZM3") + ZM1->ZM1_NUM))
		While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == ZM1->ZM1_NUM
			If ZM3->ZM3_STATUS == "A"
				nCount++
				nValBrix += ZM3->ZM3_QLD022
			EndIf

			ZM3->(dbSkip())
		End

		nValBrix := ROUND((nValBrix / nCount), 1)
	Else
		dbSelectArea('ZM5')
		ZM5->(dbSetOrder(1))
		ZM5->(dbGoTop())
		If ZM5->(dbSeek(xFilial('ZM5')+ZM1->ZM1_NUM))
			While ZM5->(!Eof()) .And. ZM5->ZM5_FILIAL == xFilial("ZM5") .AND. ZM5->ZM5_NUM == ZM1->ZM1_NUM
				If ZM5->ZM5_CARACT == _cBrix .AND. ZM5->ZM5_STATUS $ 'A/P'
					nCount++
					nValBrix += ZM5->ZM5_VALOR
				EndIf
				ZM5->(DbSkip())
			EndDo
			nValBrix := ROUND((nValBrix / nCount), 1)
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³A partir do ST BRIX obtido, cálcula os valores de sólidos por KG e LT bruto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nSlKG := ROUND(((M->ZM1_KGBRT) * (nValBrix / 100)), 2)
	nSlLT := ROUND((M->ZM1_LTBRT * (nValBrix / 100)), 2)

Return {nValBrix, nSlKG, nSlLT}





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019LNF  ºAutor  ³Marcelo Joner        º Data ³ 29/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função vinculada à edição do campo ZM1_LTNOTA. Responsável  º±±
±±º          ³pela validação do valor informado e também pela atualização º±±
±±º          ³do campo ZM1_LTDIF.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019LNF()

	Local lRet := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calcula diferença caso à quantidade LT Nota seja positiva³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If POSITIVO(M->ZM1_LTNOTA)
		lRet := .T.
		M->ZM1_LTDIF  := ROUND((M->ZM1_LTBRT - M->ZM1_LTNOTA), 2)
		If M->ZM1_LTNOTA > 0 .AND. M->ZM1_PRCSOL > 0
			M->ZM1_SITCON := "F"
		EndIf
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019FT01 ºAutor  ³Marcelo Joner        º Data ³ 29/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução das regras referentes à    º±±
±±º          ³composição do fator de conversão considerado quando trata-seº±±
±±º          ³de SORO IN NATURA. Vinculado ao cadastro de Fórmulas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019FT01()

	Local nFator	:= 0
	Local nCount	:= 0
	Local nValDen	:= 0
	Local _cDensid  := AllTrim(GetMv("MX_LT009DE"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calcula o fator com base nas análises de densidade³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("ZM3")
	ZM3->(dbSetOrder(1))
	ZM3->(dbGoTop())
	If ZM3->(dbSeek(xFilial("ZM3") + ZM1->ZM1_NUM))
		While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == ZM1->ZM1_NUM
			If ZM3->ZM3_STATUS == "A"
				nCount++
				nValDen += ZM3->ZM3_QLD008
			EndIf

			ZM3->(dbSkip())
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Calcula à densidade média da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nFator := ROUND((nValDen / nCount), 0)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Calcula o total de litros à partir do peso bruto da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nFator := ROUND(((ZM1->ZM1_KGBRT / nFator) * 1000), TAMSX3("ZM1_LTBRT")[2])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Calcula o fator de conversão por KG x LT³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nFator := ROUND((nFator / ZM1->ZM1_KGBRT), TAMSX3("ZM1_FATCON")[2])
	Else
		dbSelectArea('ZM5')
		ZM5->(dbSetOrder(1))
		ZM5->(dbGoTop())
		If ZM5->(dbSeek(xFilial('ZM5')+ZM1->ZM1_NUM))
			While ZM5->(!Eof()) .And. ZM5->ZM5_FILIAL+ZM5->ZM5_NUM == xFilial('ZM5')+ZM1->ZM1_NUM
				If ZM5->ZM5_CARACT == _cDensid .AND. ZM5->ZM5_STATUS $ 'A/P'
					nCount++
					nValDen += ZM5->ZM5_VALOR
				EndIf
				ZM5->(DbSkip())
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calcula à densidade média da carga³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nFator := ROUND((nValDen / nCount), 0)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calcula o total de litros à partir do peso bruto da carga³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nFator := ROUND(((ZM1->ZM1_KGBRT / nFator) * 1000), TAMSX3("ZM1_LTBRT")[2])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calcula o fator de conversão por KG x LT³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nFator := ROUND((nFator / ZM1->ZM1_KGBRT), TAMSX3("ZM1_FATCON")[2])

		EndIf
	EndIf

Return nFator





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019INI  ºAutor  ³Marcelo Joner        º Data ³ 05/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução de regras na inicialização º±±
±±º          ³da interface da funcionalidade de Conciliação.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019INI(lEdtCon)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso usuário possui permissão para utilizar à funcionalidade, seta foco no grid de Mov. Transportador³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lEdtCon
		If EMPTY(ZM1->ZM1_NFCOM)
			SETFOCUS(oBrwTrp:oBrowse:hWnd)
		Else
			SETFOCUS(oGetCon:hWnd)
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso o usuário não possui permissão, apresenta mensagem alertando ao mesmo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		U_LTALL001("Atenção", "O seu usuário não possui permissão para utilizar está funcionalidade.", "Somente será possível visualizar as informações referentes à conciliação desta pesagem.")
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019GRV  ºAutor  ³Marcelo Joner        º Data ³ 30/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela gravação das informações referentes º±±
±±º          ³à funcionalidade de Conciliação.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019GRV()

	Local aArea			:= GetArea()
	Local aMOV002		:= {}
	Local nI			:= 0
	Private lMsErroAuto	:= .F.

	BEGIN TRANSACTION

		If M->ZM1_SITCON != ZM1->ZM1_SITCON

			If  ( ALLTRIM(M->ZM1_PROD) $ SuperGetMv("LTS_PRDDIF",,"") .AND. M->ZM1_PRCSOL <= 0 .AND. M->ZM1_SITCON == 'F' .and. ZM1_TPNOTA == '1' )
			
				U_GLALL001("Atenção", "Não foi possível concluir a conciliação, preço do sólido não informado", "Favor verificar verificar com o setor de captação.")
				ZM1->ZM1_SITCON := "P"
				M->ZM1_SITCON := "P"
			
			ElseIf ALLTRIM(M->ZM1_PROD) $ SuperGetMv("LTS_PRDDIF",,"")

				If M->ZM1_SITCON != 'F' .and. ZM1->ZM1_SITCON == "F"
					U_LSEST07()
				ElseIf M->ZM1_SITCON == 'F' .and. ZM1->ZM1_SITCON == "P" .and. M->ZM1_PRCSOL > 0 .and. !EMPTY(POSICIONE("SD1",1,XFILIAL("SD1")+M->ZM1_NFCOM+M->ZM1_SRCOM+M->ZM1_CLIFOR+M->ZM1_LOJA,"D1_DOC"))
					U_LSEST08()
				EndIf
			EndIf
		EndIf
		
		If M->ZM1_SITCON != 'F' .and. ZM1->ZM1_SITCON == "F"
			If ApMsgNoYes("Deseja reabrir os lançamentos da Qualidade?", "Atenção")
				ZM1->ZM1_SITQLD := "P"
				M->ZM1_SITQLD := "P"
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Realiza à gravação dos dados na tabela de Pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("ZM1")
		RECLOCK("ZM1", .F.)

		For nI := 1 To FCount()
			If FieldName(nI) == "ZM1_FILIAL"
				FieldPut(nI, xFilial("ZM1"))
			Else
				FieldPut(nI, M->&(FieldName(nI)))
			EndIf
		Next nI

		ZM1->ZM1_USRCON := __cUserId
		ZM1->ZM1_NOMCON := cUserName
		ZM1->ZM1_DTCON  := dDataBase
		ZM1->ZM1_HRCON  := SUBSTR(GetRmtTime(), 1, 5)
		ZM1->(MSUNLOCK())


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Remove o vinculo da Pesagem aos Mov. Transportador vinculados anteriormente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		While .T.
			dbSelectArea("ZL7")
			ZL7->(dbSetOrder(4))
			ZL7->(dbGoTop())
			If ZL7->(dbSeek(xFilial("ZL7") + ZM1->ZM1_NUM))
				While ZL7->(!EOF()) .AND. ZL7->ZL7_FILIAL == xFilial("ZL7") .AND. ZL7->ZL7_NUMPES == ZM1->ZM1_NUM
					RECLOCK("ZL7", .F.)
					ZL7->ZL7_NUMPES := ""
					ZL7->(MSUNLOCK())

					ZL7->(dbSkip())
				End
			Else
				exit
			EndIf
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Realiza atualização dos Mov. Transportador vinculados há pesagem atualmente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea(cAliasTRP)
		(cAliasTRP)->(dbGoTop())
		While (cAliasTRP)->(!EOF())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Prepara array para atualização do Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aMOV002 := {}
			AADD(aMOV002, {'ZL7_FILIAL', xFilial("ZL7")				, Nil})
			AADD(aMOV002, {'ZL7_COD'   , (cAliasTRP)->ZL7_COD		, Nil})
			AADD(aMOV002, {'ZL7_QTDVAZ', (cAliasTRP)->ZL7_QTDVAZ	, Nil})
			AADD(aMOV002, {'ZL7_QTDANT', (cAliasTRP)->ZL7_QTDANT	, Nil})
			AADD(aMOV002, {'ZL7_QTDTRP', (cAliasTRP)->ZL7_QTDTRP	, Nil})
			AADD(aMOV002, {'ZL7_QTDCRI', (cAliasTRP)->ZL7_QTDCRI	, Nil})
			AADD(aMOV002, {'ZL7_QTDSOB', (cAliasTRP)->ZL7_QTDSOB	, Nil})
			AADD(aMOV002, {'ZL7_QTDFAL', (cAliasTRP)->ZL7_QTDFAL	, Nil})
			AADD(aMOV002, {'ZL7_QTDANT', (cAliasTRP)->ZL7_QTDANT	, Nil})
			AADD(aMOV002, {'ZL7_QTDDES', (cAliasTRP)->ZL7_QTDDES	, Nil})
			AADD(aMOV002, {'ZL7_NUMPES', ZM1->ZM1_NUM				, Nil})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa rotina de alteração do Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			MSExecAuto({|x,y| U_LTMOV002(x,y)}, aMOV002, 4)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Verifica se ocorreu erro na atualização do Mov. Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If lMsErroAuto
				DISARMTRANSACTION()
				U_GLALL001("Atenção", "Ocorreram erros na atualização do Mov. Transportador (" + ALLTRIM(ZL7->ZL7_COD) + ") vinculado à pesagem.", "Favor verificar o log apresentado à seguir.")
				MOSTRAERRO()
				Return
			EndIf

			(cAliasTRP)->(dbSkip())
		End

	END TRANSACTION

	RestArea(aArea)

Return

//============================================================================\
/*/{Protheus.doc}LTMOV009C 
  ==============================================================================
	@description
	Recalcula Conciliação

	@author Alexandre Longhinotti <ti@tresbarras.ind.br>
	@version 1.0
	@since 10/11/2020

/*/  
//============================================================================\
Static Function LT019RECC(lTemNf, aDetSL)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa função de cálculo dos solidos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If M->ZM1_SITCON != ZM1->ZM1_SITCON .OR. ( M->ZM1_SITCON == 'P' .AND. ZM1->ZM1_SITCON == 'P' )
		If lTemNf
			If M->ZM1_SITCON != 'F'
				aDetSL := LT019CLCSL()
				M->ZM1_QLD022 := aDetSL[1]
				M->ZM1_SLKG   := aDetSL[2]
				M->ZM1_SLLT   := aDetSL[3]
				M->ZM1_LTDIF  := ROUND(((M->ZM1_LTBRT + M->ZM1_LTDESC) - M->ZM1_LTNOTA), 0)
				M->ZM1_PRCSOL := U_LTPRCSOL()
				//MsgAlert("Recalculo efetuado com Sucesso!")
			else
				MsgAlert("Não foi possível efetuar o recalculo. Verificar o Status da conciliação!")
			EndIf
		Else
			M->ZM1_LTDIF  := ROUND(((M->ZM1_LTBRT + M->ZM1_LTDESC) - M->ZM1_LTMOV), 0)
		EndIf
	EndIf
Return
// FIM da Funcao LTMOV009C
//==============================================================================

//============================================================================\
/*/{Protheus.doc}LT019ZERPR 
  ==============================================================================
	@description
	Recalcula Conciliação

	@author Alexandre Longhinotti <ti@tresbarras.ind.br>
	@version 1.0
	@since 10/12/2021

/*/  
//============================================================================\
Static Function LT019ZERPR(lTemNf, aDetSL)

	If M->ZM1_SITCON != ZM1->ZM1_SITCON .OR. ( M->ZM1_SITCON == 'P' .AND. ZM1->ZM1_SITCON == 'P' )
		If lTemNf
			If M->ZM1_SITCON != 'F'
				M->ZM1_PRCSOL := 0
				MsgAlert("Preço zerado com Sucesso!")
			else
				MsgAlert("Não foi possível zerar o preço. Verificar o Status da conciliação!")
			EndIf
		EndIf
	EndIf
Return
// FIM da Funcao LT019ZERPR
//==============================================================================






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019LOG  ºAutor  ³Marcelo Joner        º Data ³ 05/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela apresentação das informações de log º±±
±±º          ³de execução na realização do processo de Conciliação.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019LOG()

	Local aArea			:= GetArea()
	Local aCpoCad 		:= {'NOUSER', 'ZM1_USRCON', 'ZM1_NOMCON', 'ZM1_DTCON', 'ZM1_HRCON'}
	Local aAltCad 		:= {''}
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
//Local lRet			:= .T.
	Local lF3			:= .F.
	Local lColumn		:= .F.
	Local lMemoria		:= .T.
	Local lNoFolder		:= .T.
	Local lProperty		:= .F.
	Local cCadOld		:= cCadastro

	Default nOpc		:= 1

	Private aGets[0]
	Private aTela[0][0]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Ajusta o título que será apresentado no dialog ao usuário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cCadastro := "Pesagem - Log de Conciliação"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calcula tamanho\posicionamento da interface³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aSize := MsAdvSize(.T.)
	AADD(aObjects, {100, 100, .T., .T.})
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Declaração do dialog e demais componentes da interface secundária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oDlgLog := MSDialog():New(089,232,IIF(nOpc == 4, 220, 260),920,cCadastro,,,.F.,,,,,,.T.,,,.T. )
	oDlgLog:bInit := {|| ENCHOICEBAR(oDlgLog, {|| oDlgLog:End()}, {|| oDlgLog:End()}, .F., {})}
	oGetCad := MSMGET():NEW("ZM1",0, nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoCad, {aPosObj[1][1], 001, (oDlgLog:nClientHeight / 2)-15,(oDlgLog:nClientWidth / 2)-5}, aAltCad, 2,/*nColMens*/,/*cMensagem*/,'',oDlgLog, lF3, lMemoria, lColumn,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
	oDlgLog:Activate(,,,.T.)

	cCadastro := cCadOld

	RestArea(aArea)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019LDS  ºAutor  ³Marcelo Joner        º Data ³ 26/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função vinculada como função de validação campo ZM1_DESTRP  º±±
±±º          ³no processo de conciliação de pesagem.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019LDS()

	Local lRet		:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Não permite que o LT Desconto seja superior ao LT Vazão³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If POSITIVO()
		If M->ZM1_DESTRP > M->ZM1_LTVAZ
			U_LTALL001("Atenção", "A quantidade de LT Desconto informada é inválida.", "A quantidade de LT Desconto deve ser menor ou igual à quantidade LT Movimento.")
			lRet := .F.
		EndIf
	Else
		lRet := .F.
	EndIf

Return lRet
