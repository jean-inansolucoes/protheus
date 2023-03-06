#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MLKUPSA2  ºAutor  ³Marcelo Joner        º Data ³ 01/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de integração cadastro de fornecedor com API REST do º±±
±±º          ³software MilkUp.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Laticinios Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MLKUPSA2(nOper, lRegSA2)

	Local lRet			:= .T.
	Local aHeader		:= {}
	Local cToken		:= ALLTRIM(GETMV("MV_ZL00007",, ""))
	Local cParam		:= "api_key=" + cToken
	Local cUrl			:= "https://api.milkup.com.br/sync"
	Local oRetJSON
	Local oRestClient

	Default nOper		:= 0
	Default lRegSA2		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras de integração caso exista Token configurado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !EMPTY(cToken)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Cria objeto da clase FWRest para executar integração³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oRestClient	:= FWRest():New(cUrl)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Carrega variaveis utilizadas na integração³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cA2_FILIAL	:= ""
		cA2_X_MKUID	:= IIF(lRegSA2, SA2->A2_X_MKUID	, M->A2_X_MKUID)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Prepara variaveis para definição dos atributos de execução da API³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If nOper == 3 .OR. nOper == 4
			cA2_X_TIPO	:= IIF(lRegSA2, SA2->A2_X_TIPO	, M->A2_X_TIPO)
			cA2_NOME	:= IIF(lRegSA2, SA2->A2_NOME	, M->A2_NOME)
			cA2_TEL		:= IIF(lRegSA2, SA2->A2_TEL		, M->A2_TEL)
			cA2_COD		:= IIF(lRegSA2, SA2->A2_COD		, M->A2_COD)
			cA2_LOJA	:= IIF(lRegSA2, SA2->A2_LOJA	, M->A2_LOJA)
			cA2_CGC		:= IIF(lRegSA2, SA2->A2_CGC		, M->A2_CGC)
			cA2_X_LINHA	:= IIF(lRegSA2, SA2->A2_X_LINHA	, M->A2_X_LINHA)
			cA2_X_MKUID	:= IIF(lRegSA2, SA2->A2_X_MKUID	, M->A2_X_MKUID)
			cA2_MSBLQL	:= IIF(lRegSA2, SA2->A2_MSBLQL	, M->A2_MSBLQL)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Define ID da Filial à partir do inicio do código da Linha³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If SUBSTR(cA2_X_LINHA,01,02) == "TB" .OR. ( EMPTY(cA2_X_LINHA) .and. nOper == 3 )
				cA2_FILIAL := "d32f1605-a61e-4411-a9e8-0e14c4e2bb0d"
			ElseIf SUBSTR(cA2_X_LINHA,01,02) == "MC"
				cA2_FILIAL := "44c18b1d-7b69-4f36-ad9c-b1d17ec4b17c"
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza composição de string referente aos dados do produtor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cJSON := '{'
			cJSON += '"id_laticinio":"' + ALLTRIM(cA2_FILIAL) + '",'
			cJSON += '"nome":"' + ALLTRIM(cA2_NOME) + '",'
			cJSON += '"nome_propriedade":" ",'
			cJSON += '"telefone":"' + ALLTRIM(cA2_TEL) + '",'
			cJSON += '"codigo_laticinio":"' + ALLTRIM(cA2_COD) + '-' + ALLTRIM(cA2_LOJA) + '",'
			cJSON += '"cnpj_cpf":"' + ALLTRIM(cA2_CGC) + '",'
			cJSON += '"regiao":"' + ALLTRIM(cA2_X_LINHA) + '",'
			cJSON += '"status":"APROVADO"'
			cJSON += '}'
		EndIf

		Do Case

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa API REST de INCLUSÃO de produtores³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case nOper == 3

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza à inclusão caso seja PRODUTOR³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If cA2_X_TIPO == "P" .AND. !EMPTY(cA2_X_LINHA)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Seta parâmetros de execução da integração³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				oRestClient:SetPath("/produtores?" + cParam)
				oRestClient:SetPostParams(cJSON)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Composição do aHeader³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				AADD(aHeader, "Content-Type: application/json")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executra POST e avalia retorno (sucesso\insucesso)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If oRestClient:Post(aHeader)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o retorno da API e converte em JSON³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cRetJSON := oRestClient:GetResult()
					FWJsonDeserialize(cRetJSON, @oRetJSON)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o ID do Fornecedor no MILKUP³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If AttIsMemberOf(oRetJSON, "ID")

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Sendo integração de registro gravado na SA2, atualiza o ID³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If lRegSA2
							RECLOCK("SA2", .F.)
							SA2->A2_X_MKUID := oRetJSON:ID
							SA2->(MSUNLOCK())
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Sendo integração de registro em memória, atualiza o ID³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							oModelo	:= FWModelActive()
							oModelSA2 := oModelo:GetModel("SA2MASTER")
							oModelSA2:LoadValue("A2_X_MKUID", oRetJSON:ID)
						EndIf
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o retorno da API e converte em JSON³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cRetJSON := oRestClient:GetResult()
					FWJsonDeserialize(cRetJSON, @oRetJSON)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o ID do Fornecedor no MILKUP³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If AttIsMemberOf(oRetJSON, "ID") .AND. AttIsMemberOf(oRetJSON, "STATUS")
						cStatus := oRetJSON:STATUS
						cId := oRetJSON:ID
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso seja um PRODUTOR - ATIVO, altera o seu cadastro³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If cStatus == "ACTIVE"

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Obtém o ID do Produtor no MILKUP e atualiza no cadastro Fornecedor caso o mesmo ainda não tenha ID³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If AttIsMemberOf(oRetJSON, "ID") .AND. EMPTY(cA2_X_MKUID)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Sendo integração de registro gravado na SA2, atualiza o ID³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If lRegSA2
									RECLOCK("SA2", .F.)
									SA2->A2_X_MKUID := oRetJSON:ID
									SA2->(MSUNLOCK())
								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Sendo integração de registro em memória, atualiza o ID³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									oModelo	:= FWModelActive()
									oModelSA2 := oModelo:GetModel("SA2MASTER")
									oModelSA2:LoadValue("A2_X_MKUID", oRetJSON:ID)
								EndIf
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Executa novamente à função considerando-se de ALTERAÇÃO do cadastro no MilkUp³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							lRet := U_MLKUPSA2(4, lRegSA2)

						Else

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Caso seja um PRODUTOR - INATIVO, executa ativação do mesmo³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							oRestClient	:= FWRest():New(cUrl)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Seta parâmetros de execução da integração³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							oRestClient:SetPath("/produtores/" + cId + "/reativar?" + cParam)
							oRestClient:SetPostParams(cJSON)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Composição do aHeader³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							AADD(aHeader, "Content-Type: application/json")

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Executra PUT e avalia retorno (sucesso\insucesso)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If oRestClient:Put(aHeader)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Obtém o retorno da API e converte em JSON³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								cRetJSON := oRestClient:GetResult()
								FWJsonDeserialize(cRetJSON, @oRetJSON)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Obtém o ID do Fornecedor no MILKUP³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If AttIsMemberOf(oRetJSON, "ID")

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Sendo integração de registro gravado na SA2, atualiza o ID³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									If lRegSA2
										RECLOCK("SA2", .F.)
										SA2->A2_X_MKUID := oRetJSON:ID
										SA2->(MSUNLOCK())
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Sendo integração de registro em memória, atualiza o ID³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										oModelo	:= FWModelActive()
										oModelSA2 := oModelo:GetModel("SA2MASTER")
										oModelSA2:LoadValue("A2_X_MKUID", oRetJSON:ID)
									EndIf
								EndIf
								lRet := U_MLKUPSA2(4, lRegSA2)
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Obtém o retorno da API e apresenta mensagem ao usuário³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()
								Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração do cadastro do fornecedor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
								Alert(cRetJSON)

								lRet := .F.
							EndIf
						EndIf
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Apresenta mensagem ao usuário alertando em tonro da questão e não permite à inclusão do Fornecedor³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()
						Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração do cadastro do fornecedor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
						Alert(cRetJSON)

						lRet := .F.
					EndIf
				EndIf
			EndIf




			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa API REST de ALTERAÇÃO de produtores³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case nOper == 4

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa regras de alteração, caso o fornecedor alterado esteja integrado com o MilkUp³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !EMPTY(cA2_X_MKUID)
				cId := cA2_X_MKUID

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Seta parâmetros de execução da integração³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				oRestClient:SetPath("/produtores/" + cId + "?" + cParam)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Composição do aHeader³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				AADD(aHeader, "Content-Type: application/json")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executra PUT e avalia retorno (sucesso\insucesso)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If !oRestClient:Put(aHeader, cJSON)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o retorno da API e converte em JSON³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cRetJSON := oRestClient:GetResult()
					FWJsonDeserialize(cRetJSON, @oRetJSON)

					If at ("page_404", cRetJSON) > 0
						cRetJSON := oRestClient:GetLastError()
						Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração do cadastro do fornecedor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI. Erro: " + cRetJSON})
						lRet := .F.
					EndIf

					If at ("atualizar um registro inativo", cRetJSON) > 0
						//cRetJSON := oRestClient:GetLastError()
						//Help(NIL, NIL, "Atenção", NIL, "O Produtor " + cA2_NOME + " está inativo no Milkup!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Este produtor deve ser reativado no Milkup para continuar. Erro: " + cRetJSON})
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso seja um PRODUTOR - INATIVO, executa ativação do mesmo³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						oRestClient	:= FWRest():New(cUrl)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Seta parâmetros de execução da integração³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						oRestClient:SetPath("/produtores/" + cId + "/reativar?" + cParam)
						oRestClient:SetPostParams(cJSON)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Composição do aHeader³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						AADD(aHeader, "Content-Type: application/json")

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Executra PUT e avalia retorno (sucesso\insucesso)³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If oRestClient:Put(aHeader)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Obtém o retorno da API e converte em JSON³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							cRetJSON := oRestClient:GetResult()
							FWJsonDeserialize(cRetJSON, @oRetJSON)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Obtém o ID do Fornecedor no MILKUP³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If AttIsMemberOf(oRetJSON, "ID")

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Sendo integração de registro gravado na SA2, atualiza o ID³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If lRegSA2
									RECLOCK("SA2", .F.)
									SA2->A2_X_MKUID := oRetJSON:ID
									SA2->(MSUNLOCK())
								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Sendo integração de registro em memória, atualiza o ID³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									oModelo	:= FWModelActive()
									oModelSA2 := oModelo:GetModel("SA2MASTER")
									oModelSA2:LoadValue("A2_X_MKUID", oRetJSON:ID)
								EndIf
							EndIf
						EndIf
						lRet := U_MLKUPSA2(4, lRegSA2)
					Else


						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Obtém o ID do Fornecedor no MILKUP³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If AttIsMemberOf(oRetJSON, "ERROR")
							cStatus := oRetJSON:ERROR

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Caso seja um PRODUTOR - INATIVO, altera o seu cadastro³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If cStatus == "INVALID_UPDATE"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Caso seja um PRODUTOR - INATIVO, executa ativação do mesmo³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								oRestClient	:= FWRest():New(cUrl)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Seta parâmetros de execução da integração³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								oRestClient:SetPath("/produtores/" + cId + "/reativar?" + cParam)
								oRestClient:SetPostParams(cJSON)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Composição do aHeader³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								AADD(aHeader, "Content-Type: application/json")

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Executra PUT e avalia retorno (sucesso\insucesso)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If oRestClient:Put(aHeader)

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Obtém o retorno da API e converte em JSON³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									cRetJSON := oRestClient:GetResult()
									FWJsonDeserialize(cRetJSON, @oRetJSON)

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Obtém o ID do Fornecedor no MILKUP³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									If AttIsMemberOf(oRetJSON, "ID")

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Sendo integração de registro gravado na SA2, atualiza o ID³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										If lRegSA2
											RECLOCK("SA2", .F.)
											SA2->A2_X_MKUID := oRetJSON:ID
											SA2->(MSUNLOCK())
										Else
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
											//³Sendo integração de registro em memória, atualiza o ID³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
											oModelo	:= FWModelActive()
											oModelSA2 := oModelo:GetModel("SA2MASTER")
											oModelSA2:LoadValue("A2_X_MKUID", oRetJSON:ID)
										EndIf
									EndIf
								EndIf
								lRet := U_MLKUPSA2(4, lRegSA2)
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Obtém o retorno da API e apresenta mensagem ao usuário³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()
								Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração do cadastro do fornecedor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
								Alert(cRetJSON)
								lRet := .F.
							EndIf
						EndIf
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o retorno da API e converte em JSON³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cRetJSON := oRestClient:GetResult()
					FWJsonDeserialize(cRetJSON, @oRetJSON)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o local do Fornec   no MILKUP³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If AttIsMemberOf(oRetJSON, "PRODUCER:END_LATITUDE")
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Sendo integração de registro gravado na SA2, atualiza LOCAL³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If lRegSA2
							RECLOCK("SA2", .F.)
							SA2->A2_X_LOCAL := oRetJSON:PRODUCER:END_LATITUDE+","+oRetJSON:PRODUCER:END_LONGITUDE
							SA2->(MSUNLOCK())
						EndIf
					EndIf
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Quando o fornecedor não está integrado, executa regras visando integração do mesmo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				lRet := U_MLKUPSA2(3, lRegSA2)
			EndIf




			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa API REST de EXCLUSÃO de produtores³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case nOper == 5

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa regras de inclusão, caso o fornecedor alterado esteja integrado com o MilkUp³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !EMPTY(cA2_X_MKUID)
				cId := cA2_X_MKUID

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Seta parâmetros de execução da integração³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				oRestClient:SetPath("/produtores/" + cId + "?" + cParam)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executra PUT e avalia retorno (sucesso\insucesso)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If !oRestClient:Delete(aHeader)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o retorno da API e apresenta mensagem ao usuário³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()
					Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração do cadastro do fornecedor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
					Alert(cRetJSON)

					lRet := .F.
				EndIf
			EndIf
		EndCase
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MLKUPZL6  ºAutor  ³Marcelo Joner        º Data ³ 03/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de integração cadastro de coletas com à API REST do  º±±
±±º          ³software MilkUp.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Laticinios Silvestre                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MLKUPZL6(nOper)

	Local lRet			:= .T.
	Local nI, nt1, nt	:= 0
	Local nY			:= 0
	Local nW			:= 0
	Local aHeader		:= {}
	Local cToken		:= ALLTRIM(GETMV("MV_ZL00007",, ""))
	Local cParam		:= "api_key=" + cToken
	Local cUrl			:= "https://api.milkup.com.br/sync"
	Local cIdUsr		:= "48e38f57-d831-43bc-8b0a-0e9c64a59896"
	Local cNmUsr		:= "TOTVS"
	Local cUserAlt		:= UPPER(ALLTRIM(FwGetUserName(RetCodUsr())))
	Local oRetJSON
	Local oRestClient
	Local cA2_FILIAL
	Local nDiasCol		:= GETMV("MV_ZL00014",, 0)
	Local cAliasTMP 	:= GetNextAlias()
	Local hEnter    	:= CHR(13) + CHR(10)
	Local cEmailTo 		:= "ti@trelac.com.br"
	Local cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
	Local cArqHtml		:= cMV_WFDIR +"\WfAPIMkp.htm"
	Local oWFProc		:= nil
	Local cCodProces	:= "SENDWFMK1"
	LOCAL _cAssunto		:= "[TRELAC] FALHA INTEG. DE COLETA"
	Local lExitColeta	:= .F.
	Local nVolAtual		:= 0
	Local nColTmp		:= 0
	Default nOper		:= 0



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras de integração caso exista Token configurado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !EMPTY(cToken)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Cria objeto da clase FWRest para executar integração³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oRestClient	:= FWRest():New(cUrl)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Posiciona no cadastro do Fornecedor\Produtor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(dbGoTop())
		SA2->(dbSeek(xFilial("SA2") + ZL6->ZL6_PRODUT + ZL6->ZL6_LOJPRD))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Prepara variaveis para definição dos atributos de execução da API³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If nOper == 3 .OR. nOper == 4
			cHrCl := IIF(!EMPTY(ZL6->ZL6_HORCOL), ZL6->ZL6_HORCOL, SUBSTR(TIME(), 1, 5)) + ":00"
			dDtCl := IIF(!EMPTY(ZL6->ZL6_DTCOL), ZL6->ZL6_DTCOL, ZL5->ZL5_DATA)
			cDtHr := Year2Str(dDtCl) + "-" + Month2Str(dDtCl) + "-" + Day2Str(dDtCl) + " " + cHrCl

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Vincula à quantidade da amostra ao primeiro Tanque identificado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aQtTq := {0,0,0,0,0,0,0}
			cDtTq := ALLTRIM(ZL6->ZL6_TANQUE)
			For nt1 := 1 To Len(aQtTq)
				If ALLTRIM(STR(nt1)) $ cDtTq
					aQtTq[nt1] := ZL6->ZL6_QTDE
					exit
				EndIf
			Next nt1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Define ID da Filial à partir do inicio do código da Linha³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If SUBSTR(ALLTRIM(ZL5->ZL5_LINHA),01,02) == "TB" .OR. EMPTY(ALLTRIM(ZL5->ZL5_LINHA))
				cA2_FILIAL := "d32f1605-a61e-4411-a9e8-0e14c4e2bb0d"
			ElseIf SUBSTR(ALLTRIM(ZL5->ZL5_LINHA),01,02) == "MC"
				cA2_FILIAL := "44c18b1d-7b69-4f36-ad9c-b1d17ec4b17c"
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Monta variavel com os atributos necessários para execução da API³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If nOper == 4 .AND. !Empty(ZL6->ZL6_MKUID)
				cJSON := '{'
				cJSON += '"id_laticinio":"' + cA2_FILIAL + '",'
				cJSON += '"nome_pessoa_registro":"' + cUserAlt + '",'
				cJSON += '"data":"' + cDtHr + '",'
				cJSON += '"temperatura": ' + ALLTRIM(STR(ZL6->ZL6_TEMPER)) + ','
				cJSON += '"numero_amostra":"' + IIF(!EMPTY(ZL6->ZL6_AMOSTR), ALLTRIM(ZL6->ZL6_AMOSTR), "000000") + '",'
				cJSON += '"quantidade_coleta": ' + ALLTRIM(STR(ZL6->ZL6_QTDE)) + ','
				cJSON += '"tanque1": ' + ALLTRIM(STR(aQtTq[1])) + ','
				cJSON += '"tanque2": ' + ALLTRIM(STR(aQtTq[2])) + ','
				cJSON += '"tanque3": ' + ALLTRIM(STR(aQtTq[3])) + ','
				cJSON += '"tanque4": ' + ALLTRIM(STR(aQtTq[4])) + ','
				cJSON += '"tanque5": ' + ALLTRIM(STR(aQtTq[5])) + ','
				cJSON += '"tanque6": ' + ALLTRIM(STR(aQtTq[6])) + ','
				cJSON += '"tanque7": ' + ALLTRIM(STR(aQtTq[7])) + ','
				cJSON += '"observacao":"COLETA ALTERADA VIA ERP TOTVS POR: ' + cUserAlt + '",'
				cJSON += '"codigo_produtor":"' + ALLTRIM(SA2->A2_COD) + "-" + ALLTRIM(SA2->A2_LOJA) + '"'
				cJSON += '}'
			Else
				cJSON := '{'
				cJSON += '"id_laticinio":"' + cA2_FILIAL + '",'
				cJSON += '"id_usuario_coleta":"' + cIdUsr + '",'
				cJSON += '"nome_usuario_coleta":"' + cUserAlt + '",'
				cJSON += '"placa":"' + IIF(!EMPTY(ZL6->ZL6_PLACA), ALLTRIM(ZL6->ZL6_PLACA), "SEM PLACA") + '",'
				cJSON += '"data":"' + cDtHr + '",'
				cJSON += '"temperatura": ' + ALLTRIM(STR(ZL6->ZL6_TEMPER)) + ','
				cJSON += '"numero_amostra":"' + IIF(!EMPTY(ZL6->ZL6_AMOSTR), ALLTRIM(ZL6->ZL6_AMOSTR), "000000") + '",'
				cJSON += '"alizarol":"Negativo",'
				cJSON += '"quantidade_coleta": ' + ALLTRIM(STR(ZL6->ZL6_QTDE)) + ','
				cJSON += '"tanque1": ' + ALLTRIM(STR(aQtTq[1])) + ','
				cJSON += '"tanque2": ' + ALLTRIM(STR(aQtTq[2])) + ','
				cJSON += '"tanque3": ' + ALLTRIM(STR(aQtTq[3])) + ','
				cJSON += '"tanque4": ' + ALLTRIM(STR(aQtTq[4])) + ','
				cJSON += '"tanque5": ' + ALLTRIM(STR(aQtTq[5])) + ','
				cJSON += '"tanque6": ' + ALLTRIM(STR(aQtTq[6])) + ','
				cJSON += '"tanque7": ' + ALLTRIM(STR(aQtTq[7])) + ','
				cJSON += '"latitude":"SEM DADOS",'
				cJSON += '"longitude":"SEM DADOS",'
				cJSON += '"observacao":"COLETA REGISTRADA VIA ERP TOTVS POR: ' + cUserAlt + '",'
				cJSON += '"veiculo":"SEM VEICULO",'
				cJSON += '"codigo_produtor":"' + ALLTRIM(SA2->A2_COD) + "-" + ALLTRIM(SA2->A2_LOJA) + '"'
				cJSON += '}'
			EndIf
		EndIf

		Do Case

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa API REST de CONSULTA de coletas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case nOper == 2

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Compõe variavel de parâmetro adicional à API³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dDtSyn := dDataBase - nDiasCol
			cHrSyn := "00:00:01"
			cLastSyn := "last_synced_at=" + Year2Str(dDtSyn) + "-" + Month2Str(dDtSyn) + "-" + Day2Str(dDtSyn) + " " + cHrSyn
			//cLastSyn := "last_synced_at=2020-01-01 00:00:01"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Seta parâmetros de execução da integração³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oRestClient:SetPath("/coletas?" + cLastSyn + "&" + cParam)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Composição do aHeader³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			AADD(aHeader, "Content-Type: application/json")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executra GET e avalia retorno (sucesso\insucesso)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If oRestClient:Get(aHeader)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Obtém o retorno da API e converte em JSON³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cRetJSON := oRestClient:GetResult()
				FWJsonDeserialize(cRetJSON, @oRetJSON)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Havendo array privado de integração, popula o mesmo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If ValType(aDetMilk) == "A"
					aDetMilk := {}

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa laço para processamento de todas as coletas obtidas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					For nI := 1 To Len(oRetJSON)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Prepara variaveis com as informações da coleta atual³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						nVolAtual	:= 0
						lExitColeta := .F.
						lAchou  := .F.
						cFilCol := ""
						cCodLin := ""
						cFilCol := IIF(AttIsMemberOf(oRetJSON[nI], "ID_LATICINIO"), oRetJSON[nI]:ID_LATICINIO, "")
						cCodFor := IIF(AttIsMemberOf(oRetJSON[nI], "CODIGO_PRODUTOR"), SUBSTR(oRetJSON[nI]:CODIGO_PRODUTOR, 1, AT("-", oRetJSON[nI]:CODIGO_PRODUTOR)-1), "")
						cLojFor := IIF(AttIsMemberOf(oRetJSON[nI], "CODIGO_PRODUTOR"), SUBSTR(oRetJSON[nI]:CODIGO_PRODUTOR, AT("-", oRetJSON[nI]:CODIGO_PRODUTOR)+1, 10), "")
						cNmForn	:= IIF(AttIsMemberOf(oRetJSON[nI], "NOME_PRODUTOR"), oRetJSON[nI]:NOME_PRODUTOR, "")
						cDetLoc := ""
						nQtdVol := IIF(AttIsMemberOf(oRetJSON[nI], "QUANTIDADE_COLETA"), VAL(oRetJSON[nI]:QUANTIDADE_COLETA), 0)
						nVolOri := IIF(AttIsMemberOf(oRetJSON[nI], "QUANTIDADE_ORIGINAL"), IIF(oRetJSON[nI]:QUANTIDADE_ORIGINAL <> '0.0000', VAL(oRetJSON[nI]:QUANTIDADE_ORIGINAL),0), 0)
						nDetTem := IIF(AttIsMemberOf(oRetJSON[nI], "TEMPERATURA"), VAL(oRetJSON[nI]:TEMPERATURA), 0)
						cDetTnq := ""
						cDetAmo := IIF(AttIsMemberOf(oRetJSON[nI], "NUMERO_AMOSTRA"), oRetJSON[nI]:NUMERO_AMOSTRA, "")
						cHorCol := IIF(AttIsMemberOf(oRetJSON[nI], "HORA_CHEGADA"), oRetJSON[nI]:HORA_CHEGADA, "")
						cIdeCol := IIF(AttIsMemberOf(oRetJSON[nI], "ID_COLETA"), oRetJSON[nI]:ID_COLETA, "")
						cIdeDis := IIF(AttIsMemberOf(oRetJSON[nI], "ID_EQUIPAMENTO"), IIF(oRetJSON[nI]:ID_EQUIPAMENTO != NIL, oRetJSON[nI]:ID_EQUIPAMENTO, ""), "")
						cDatCol := IIF(AttIsMemberOf(oRetJSON[nI], "DATA"), STOD(SUBSTR(oRetJSON[nI]:DATA, 1, 4) + SUBSTR(oRetJSON[nI]:DATA, 6, 2) + SUBSTR(oRetJSON[nI]:DATA, 9, 2)), "")
						cDatReg := IIF(AttIsMemberOf(oRetJSON[nI], "DATA_HORA_REGISTRO"), STOD(SUBSTR(oRetJSON[nI]:DATA_HORA_REGISTRO, 1, 4) + SUBSTR(oRetJSON[nI]:DATA_HORA_REGISTRO, 6, 2) + SUBSTR(oRetJSON[nI]:DATA_HORA_REGISTRO, 9, 2)), "")
						cObserv := IIF(AttIsMemberOf(oRetJSON[nI], "OBSERVACAO"),oRetJSON[nI]:OBSERVACAO , "")
						cMotori := IIF(AttIsMemberOf(oRetJSON[nI], "NOME_USUARIO_COLETA"),oRetJSON[nI]:NOME_USUARIO_COLETA , "")
						cRotCol := IIF(AttIsMemberOf(oRetJSON[nI], "NOME_ROTA"),oRetJSON[nI]:NOME_ROTA , "")
						If !Empty(alltrim(cObserv))
							cObserv := decodeUTF8(cObserv,"cp1252")
						EndIf
						IF Empty(oRetJSON[nI]:ITINERARIO_DATA_HORA_FIM)
							cDatIti := ""//IIF(AttIsMemberOf(oRetJSON[nI], "DATA"), STOD(SUBSTR(oRetJSON[nI]:DATA, 1, 4) + SUBSTR(oRetJSON[nI]:DATA, 6, 2) + SUBSTR(oRetJSON[nI]:DATA, 9, 2)), "")
						Else
							cDatIti := IIF(AttIsMemberOf(oRetJSON[nI], "ITINERARIO_DATA_HORA_FIM"), STOD(SUBSTR(oRetJSON[nI]:ITINERARIO_DATA_HORA_FIM, 1, 4) + SUBSTR(oRetJSON[nI]:ITINERARIO_DATA_HORA_FIM, 6, 2) + SUBSTR(oRetJSON[nI]:ITINERARIO_DATA_HORA_FIM, 9, 2)), "")
						EndIf
						cDetPla := IIF(AttIsMemberOf(oRetJSON[nI], "PLACA"), oRetJSON[nI]:PLACA, "")
						cItner := IIF(AttIsMemberOf(oRetJSON[nI], "ID_ITINERARIO"), oRetJSON[nI]:ID_ITINERARIO, "")
						cDetPla := STRTRAN(ALLTRIM(cDetPla)," ","")

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Posiciona no cadastro do Fornecedor³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						dbSelectArea("SA2")
						SA2->(dbSetOrder(1))
						SA2->(dbGoTop())
						If SA2->(dbSeek(xFilial("SA2") + PADR(cCodFor, TAMSX3("A2_COD")[1]) + PADR(cLojFor, TAMSX3("A2_COD")[1])))
							//cCodLin := IIF(AttIsMemberOf(oRetJSON[nI], "REGIAO"), IIF(oRetJSON[nI]:REGIAO != NIL,	IIF(oRetJSON[nI]:REGIAO != '', oRetJSON[nI]:REGIAO,	SA2->A2_X_LINHA), SA2->A2_X_LINHA),SA2->A2_X_LINHA)
							//cCodLin := IIF(AttIsMemberOf(oRetJSON[nI], "REGIAO"), IIF(oRetJSON[nI]:REGIAO != NIL, oRetJSON[nI]:REGIAO, SA2->A2_X_LINHA), SA2->A2_X_LINHA)
							cCodLin := ALLTRIM(SA2->A2_X_LINHA)
							//cCodLin := ALLTRIM(cCodLin)
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Adiciona registro no arquivo de log³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							cDetLog := "01-Fornecedor não localizado: " + PADR(cCodFor, TAMSX3("A2_COD")[1]) + " \ " + PADR(cLojFor, TAMSX3("A2_COD")[1])
							cDetLog := DTOC(DATE()) + "-" + TIME() + "-" + cDetLog + CHR(13) + CHR(10)
							fWrite(nHldLOG,cDetLog,Len(cDetLog))
							CONOUT(cDetLog)
						EndIf


						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³A partir do código da LINHA, identifica o código da filial referente à Coleta³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If SUBSTR(cCODLIN,01,02) == "TB"
							cFilCol := "01LAT01"
						ElseIf SUBSTR(cCODLIN,01,02) == "GC"
							cFilCol := "01LAT02"
						ElseIf SUBSTR(cCODLIN,01,02) == "MC"
							cFilCol := "01LAT03"
						ElseIf SUBSTR(cCODLIN,01,02) == "SP"
							cFilCol := "01LAT04"
						ElseIf SUBSTR(cCODLIN,01,02) == "NE"
							cFilCol := "01LAT05"
						ElseIf SUBSTR(cCODLIN,01,02) == "PI"
							cFilCol := "01LAT06"
						EndIf


						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Considera à coleta, caso não exista na base de dados³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

						/*dbSelectArea("ZL6")
						ZL6->(dbSetOrder(5))
						ZL6->(dbGoTop())
						If ZL6->(dbSeek(cFilCol + cIdeCol ))
							nVolAtual	:= ZL6->ZL6_QTDE
							lExitColeta := .T.
						else
							nVolAtual	:= nQtdVol
						EndIf
						ZL6->(dbCloseArea())
						If !lExitColeta
							CONOUT("Insere nova")
						EndIf
						*/

						cQuery := "SELECT ZL6_QTDE VOLUME" 			+ hEnter
						cQuery += "FROM " + RetSQLName("ZL6") + " ZL6 	"	+ hEnter
						cQuery += "WHERE ZL6_MKUID ='" +  cIdeCol  + "'" 	+ hEnter
						
						TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
						dbSelectArea(cAliasTMP)
						(cAliasTMP)->(dbGoTop())

						If (cAliasTMP)->VOLUME > 0
							nVolAtual	:= (cAliasTMP)->VOLUME
							lExitColeta := .T.
						else
							nVolAtual	:= nQtdVol
						EndIf
						(cAliasTMP)->(dbCloseArea())
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Executa demais regras havendo identificado o código da linha³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If !EMPTY(ALLTRIM(cCodLin)) .AND. !EMPTY(cDatIti)



							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Executa demais regras, caso tenha identificado à filial referente a coleta³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If !EMPTY(cFilCol)


								If !lExitColeta
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³A partir da LINHA, identifica qual o TRANSPORTADOR³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									dbSelectArea("ZL0")
									ZL0->(dbSetOrder(1))
									ZL0->(dbGoTop())
									If ZL0->(dbSeek(xFilial("ZL0", cFilCol) + cCodLin))
										cCodTra := ZL0->ZL0_TRANSP

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Identifica o tanque de carregamento³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										For nW := 1 To 7
											If !Empty(&("oRetJSON[nI]:TANQUE" + ALLTRIM(STR(nW))))
												If VAL(&("oRetJSON[nI]:TANQUE" + ALLTRIM(STR(nW)))) > 0
													cDetTnq += ALLTRIM(STR(nW))
												EndIf
											EndIF
										Next nW
										If Empty(cDetTnq)
											cDetLog := "01-Tanque não preenchido: " + PADR(cCodFor, TAMSX3("A2_COD")[1]) + " \ " + PADR(cLojFor, TAMSX3("A2_COD")[1])
											cDetLog := DTOC(DATE()) + "-" + TIME() + "-" + cDetLog + CHR(13) + CHR(10)
											fWrite(nHldLOG,cDetLog,Len(cDetLog))
											CONOUT(cDetLog)
										EndIf
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Prepara array com as informações da coleta atual³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										aDetCol := {cCodFor, cLojFor, cDetLoc, nQtdVol, nDetTem, cDetTnq, cDetAmo, cHorCol, cIdeCol, cIdeDis, cDatCol, cDetPla, cItner, nVolOri}

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Atualiza array de dados com as informações da coleta atual³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										For nY := 1 To Len(aDetMilk)
											If aDetMilk[nY][1] == cCodLin .AND. aDetMilk[nY][2] == cDatIti .AND. aDetMilk[nY][3] == cCodTra .AND. aDetMilk[nY][4] == cDetPla .AND. aDetMilk[nY][5] == cItner
												AADD(aDetMilk[nY][6], aClone(aDetCol))
												lAchou := .T.
												exit
											EndIf
										Next nY

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Não havendo coletas para à LINHA, DATA e TRANSPORTADOR, adiciona os mesmos ao array de dados³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										If !lAchou
											AADD(aDetMilk, {cCodLin, cDatIti, cCodTra, cDetPla, cItner, {aClone(aDetCol)}})
										EndIf
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										//³Adiciona registro no arquivo de log³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
										cDetLog := "01-Transportador não localizado: " + cCodLin
										cDetLog := DTOC(DATE()) + "-" + TIME() + "-" + cDetLog + CHR(13) + CHR(10)
										fWrite(nHldLOG,cDetLog,Len(cDetLog))
										CONOUT(cDetLog)
									EndIf

								ElseIf nVolAtual <> nQtdVol //Altera volume da coleta conforme Milkup

									cQuery := "SELECT ZL6_QTDE VOLUME, ZL6_TANQUE TANQUE," 			+ hEnter
									cQuery += "SUBSTRING(ZL6_USERGA, 11,1)+SUBSTRING(ZL6_USERGA, 15,1)+SUBSTRING(ZL6_USERGA, 2, 1)+SUBSTRING(ZL6_USERGA, 6, 1)+SUBSTRING(ZL6_USERGA, 10,1)+SUBSTRING(ZL6_USERGA, 14,1)+SUBSTRING(ZL6_USERGA, 1, 1)+SUBSTRING(ZL6_USERGA, 5, 1)+SUBSTRING(ZL6_USERGA, 9, 1)+SUBSTRING(ZL6_USERGA, 13,1)+SUBSTRING(ZL6_USERGA, 17,1)+SUBSTRING(ZL6_USERGA, 4, 1)+SUBSTRING(ZL6_USERGA, 8, 1) USUARIO,"+ hEnter
									cQuery += "CONVERT(VARCHAR,DATEADD(DAY,((ASCII(SUBSTRING(ZL6_USERGA,12,1)) - 50) * 100 + (ASCII(SUBSTRING(ZL6_USERGA,16,1)) - 50)),'19960101'),112) DTALT"+ hEnter
									cQuery += "FROM " + RetSQLName("ZL6") + " ZL6 	"	+ hEnter
									cQuery += "WHERE ZL6_MKUID ='" +  cIdeCol  + "'" 	+ hEnter
									cQuery += "AND ZL6.D_E_L_E_T_ <> '*'" 	+ hEnter


									TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
									dbSelectArea(cAliasTMP)
									(cAliasTMP)->(dbGoTop())

									//nColTmp := (cAliasTMP)->VOLUME

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Adiciona registro no arquivo de log³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									cDetLog := "01-Coleta já existente na filial: " + xFilial("ZL6", cFilCol) + " ID " + cIdeCol + " Vol. Orig: " + alltrim(str(nVolOri)) + " Vol. novo : " + alltrim(str(nQtdVol))
									cDetLog := DTOC(DATE()) + "-" + TIME() + "-" + cDetLog + CHR(13) + CHR(10)
									fWrite(nHldLOG,cDetLog,Len(cDetLog))
									CONOUT(cDetLog)

									If nVolOri <> nQtdVol .OR. (cAliasTMP)->VOLUME <> nQtdVol

										If SUBSTR(ALLTRIM(cCodLin),01,02) == "TB" .OR. EMPTY(ALLTRIM(cCodLin))
											cA2_FILIAL := "d32f1605-a61e-4411-a9e8-0e14c4e2bb0d"
										ElseIf SUBSTR(ALLTRIM(cCodLin),01,02) == "MC"
											cA2_FILIAL := "44c18b1d-7b69-4f36-ad9c-b1d17ec4b17c"
										EndIf

										dbSelectArea("ZL6")
										ZL6->(dbSetOrder(5))
										ZL6->(dbGoTop())

										If ZL6->(dbSeek(cFilCol + cIdeCol ))
												//obs aqui
											If (cAliasTMP)->VOLUME <> nQtdVol .AND. (cDatReg > STOD((cAliasTMP)->DTALT) .OR. (cDatReg = STOD((cAliasTMP)->DTALT) .AND. Empty(alltrim((cAliasTMP)->USUARIO))))

												If RECLOCK("ZL6", .F.)
													ZL6->ZL6_QTDE := nQtdVol
													ZL6->ZL6_IDMOB := 0
													ZL6->(MSUNLOCK())

													cDetLog := "02-Quantidade Alterada Via Milkup: " + xFilial("ZL6", cFilCol) + " ID " + cIdeCol + " Vol. Orig: " + alltrim(str(nVolOri)) + " Vol. novo : " + alltrim(str(nQtdVol))
													cDetLog := DTOC(DATE()) + "-" + TIME() + "-" + cDetLog + CHR(13) + CHR(10)
													fWrite(nHldLOG,cDetLog,Len(cDetLog))
													CONOUT(cDetLog)

													If alltrim(cA2_FILIAL) = "d32f1605-a61e-4411-a9e8-0e14c4e2bb0d"
														cEmailTo := SuperGetMV("MX_ECOLTB",,.F.)
													ElseIf alltrim(cA2_FILIAL) = "44c18b1d-7b69-4f36-ad9c-b1d17ec4b17c"
														cEmailTo := SuperGetMV("MX_ECOLMC",,.F.)
													ENDIF

													cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
													cArqHtml		:= cMV_WFDIR +"\WfAPIMkp2.htm"
													oWFProc		:= nil
													cCodProces	:= "SENDWMKP1"
													_cAssunto		:= "[TRELAC] Quantidade Alterada Via Milkup"

													oWFProc := TWFProcess():New(cCodProces, _cAssunto)
													oWFProc:NewTask(_cAssunto, cArqHtml)
													oWFProc:cTo      := cEmailTo
													oWFProc:cSubject := _cAssunto
													oWFProc:oHtml:ValByName("D_DATABASE"       , DDATABASE ) //
													oWFProc:oHtml:ValByName("PRODUTOR"       , cCodFor + "-" + cLojFor )
													oWFProc:oHtml:ValByName("NOME"       , cNmForn )
													oWFProc:oHtml:ValByName("VOLUME"       , nQtdVol )
													oWFProc:oHtml:ValByName("VOLORI"       , nVolOri )
													oWFProc:oHtml:ValByName("LINHA"       , cCodLin )
													oWFProc:oHtml:ValByName("DTCOLETA"       , cDatCol )
													oWFProc:oHtml:ValByName("USER"       , UPPER(ALLTRIM(FwGetUserName((cAliasTMP)->USUARIO))) )
													oWFProc:oHtml:ValByName("PROBLEMA"       , "Alteração de coleta " + " - " +  cObserv)
													oWFProc:Start()
												EndIf
											Else

												cHrCl := IIF(!EMPTY(ZL6->ZL6_HORCOL), ZL6->ZL6_HORCOL, SUBSTR(TIME(), 1, 5)) + ":00"
												dDtCl := STOD((cAliasTMP)->DTALT)
												cDtHr := Year2Str(dDtCl) + "-" + Month2Str(dDtCl) + "-" + Day2Str(dDtCl) + " " + cHrCl

												aQtTq := {0,0,0,0,0,0,0}
												cDtTq := ALLTRIM((cAliasTMP)->TANQUE)
												For nt := 1 To Len(aQtTq)
													If ALLTRIM(STR(nt)) $ cDtTq
														aQtTq[nt] := (cAliasTMP)->VOLUME
														exit
													EndIf
												Next nt



												cJSON := '{'
												cJSON += '"id_laticinio":"' + cA2_FILIAL + '",'
												cJSON += '"nome_pessoa_registro":"' + UPPER(ALLTRIM(FwGetUserName((cAliasTMP)->USUARIO))) + '",'
												cJSON += '"quantidade_coleta": ' + ALLTRIM(STR((cAliasTMP)->VOLUME)) + ','
												cJSON += '"tanque1": ' + ALLTRIM(STR(aQtTq[1])) + ','
												cJSON += '"tanque2": ' + ALLTRIM(STR(aQtTq[2])) + ','
												cJSON += '"tanque3": ' + ALLTRIM(STR(aQtTq[3])) + ','
												cJSON += '"tanque4": ' + ALLTRIM(STR(aQtTq[4])) + ','
												cJSON += '"tanque5": ' + ALLTRIM(STR(aQtTq[5])) + ','
												cJSON += '"tanque6": ' + ALLTRIM(STR(aQtTq[6])) + ','
												cJSON += '"tanque7": ' + ALLTRIM(STR(aQtTq[7])) + ','
												cJSON += '"observacao":"COLETA ALTERADA VIA ERP TOTVS POR: ' + UPPER(ALLTRIM(FwGetUserName((cAliasTMP)->USUARIO))) + '",'
												cJSON += '"codigo_produtor":"' + ALLTRIM(cCodFor) + "-" + ALLTRIM(cLojFor) + '"'
												cJSON += '}'

												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
												//³Seta parâmetros de execução da integração³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
												oRestClient:SetPath("/coletas/" + cIdeCol + "?" + cParam)

												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
												//³Composição do aHeader³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
												AADD(aHeader, "Content-Type: application/json")

												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
												//³Executra PUT e avalia retorno (sucesso\insucesso)³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
												If !oRestClient:Put(aHeader, cJSON)

													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													//³Obtém o retorno da API e converte em JSON³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()

													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													//³Apresenta mensagem ao usuário alertando em tonro da questão e não permite à inclusão do Fornecedor³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração da coleta do produtor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
													Alert(cRetJSON)

													lRet := .F.
												EndIf


											EndIf
											ZL6->(dbCloseArea())
										EndIf
									EndIf
									(cAliasTMP)->(dbCloseArea())
								EndIf
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Adiciona registro no arquivo de log³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								cDetLog := "01-Filial não identificada para linha : " + cCODLIN + " e coleta ID " + cIdeCol
								cDetLog := DTOC(DATE()) + "-" + TIME() + "-" + cDetLog + CHR(13) + CHR(10)
								fWrite(nHldLOG,cDetLog,Len(cDetLog))
								CONOUT(cDetLog)
							EndIf
						ElseIf EMPTY(ALLTRIM(cCodLin))


							If alltrim(cFilCol) = "d32f1605-a61e-4411-a9e8-0e14c4e2bb0d"
								cEmailTo := SuperGetMV("MX_ECOLTB",,.F.)
							ElseIf alltrim(cFilCol) = "44c18b1d-7b69-4f36-ad9c-b1d17ec4b17c"
								cEmailTo := SuperGetMV("MX_ECOLMC",,.F.)
							ENDIF

							
							dbSelectArea("ZLK")
							dbSetOrder(1)

							If SuperGetMV("MX_SDWFMKP",,.F.) .AND. !(dbSeek(xFilial("ZLK")+cIdeCol))

								cDetLog := "01-Produtor não vinculado a uma Linha de coleta, Prod.: " + cCodFor + "-" + cLojFor +" e coleta ID " + cIdeCol + " - Email: " + cEmailTo + " - Data Itin: " + DTOC(cDatIti)
								cDetLog := CHR(13) + CHR(10) + cDetLog + CHR(13) + CHR(10)
								fWrite(nHldLOG,cDetLog,Len(cDetLog))
								CONOUT(cDetLog)

								oWFProc := TWFProcess():New(cCodProces, _cAssunto)
								oWFProc:NewTask(_cAssunto, cArqHtml)
								oWFProc:cTo      := cEmailTo
								oWFProc:cSubject := _cAssunto
								oWFProc:oHtml:ValByName("D_DATABASE"       , DDATABASE ) //
								oWFProc:oHtml:ValByName("PRODUTOR"       , cCodFor + "-" + cLojFor )
								oWFProc:oHtml:ValByName("NOME"       , cNmForn )
								oWFProc:oHtml:ValByName("VOLUME"       , nQtdVol )
								oWFProc:oHtml:ValByName("DTCOLETA"       , cDatCol )
								oWFProc:oHtml:ValByName("MOTORISTA"       , cMotori )
								oWFProc:oHtml:ValByName("ROTA"       , cRotCol )
								oWFProc:oHtml:ValByName("PROBLEMA"       , "Produtor não vinculado a uma Linha de coleta" )
								
								//oWFProc:Start()
								If RecLock("ZLK",.T.)
									ZLK->ZLK_MKUID := cIdeCol
									MsUnLock()
								EndIf
							EndIf
							ZLK->(DbCloseArea())
							
						EndIf

					Next nI
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Obtém o retorno da API e converte em JSON³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Apresenta mensagem ao usuário alertando em tonro da questão e não permite à inclusão da Coleta³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração das coletas de produtores com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
				Alert(cRetJSON)

				lRet := .F.
			EndIf




			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa API REST de INCLUSÃO de coletas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case nOper == 3

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Seta parâmetros de execução da integração³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oRestClient:SetPath("/coletas?" + cParam)
			oRestClient:SetPostParams(cJSON)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Composição do aHeader³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			AADD(aHeader, "Content-Type: application/json")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executra POST e avalia retorno (sucesso\insucesso)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If oRestClient:Post(aHeader)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Obtém o retorno da API e converte em JSON³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cRetJSON := oRestClient:GetResult()
				FWJsonDeserialize(cRetJSON, @oRetJSON)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Obtém o ID da Coleta no MILKUP³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If AttIsMemberOf(oRetJSON, "ID")
					RECLOCK("ZL6", .F.)
					ZL6->ZL6_MKUID := oRetJSON:ID
					ZL6->(MSUNLOCK())
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Obtém o retorno da API e converte em JSON³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Apresenta mensagem ao usuário alertando em tonro da questão e não permite à inclusão da Coleta³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração da coleta do produtor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
				Alert(cRetJSON)

				lRet := .F.
			EndIf




			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa API REST de ALTERAÇÃO de coletas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case nOper == 4

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa regras de alteração, caso o Mov. Produtor alterado esteja integrado com o MilkUp³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !EMPTY(ZL6->ZL6_MKUID)
				cId := ZL6->ZL6_MKUID

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Seta parâmetros de execução da integração³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				oRestClient:SetPath("/coletas/" + cId + "?" + cParam)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Composição do aHeader³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				AADD(aHeader, "Content-Type: application/json")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executra PUT e avalia retorno (sucesso\insucesso)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If !oRestClient:Put(aHeader, cJSON)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o retorno da API e converte em JSON³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Apresenta mensagem ao usuário alertando em tonro da questão e não permite à inclusão do Fornecedor³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração da coleta do produtor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
					Alert(cRetJSON)

					lRet := .F.
				EndIf

				If alltrim(ZL6->ZL6_FILIAL) = "01LAT01"
					cEmailTo := SuperGetMV("MX_ECOLTB",,.F.)
				ElseIf alltrim(ZL6->ZL6_FILIAL) = "01LAT03"
					cEmailTo := SuperGetMV("MX_ECOLMC",,.F.)
				ENDIF

				cMV_WFDIR		:= AllTrim(GetMV("MV_WFDIR"  ))		// Diretorio de trabalho do Workflow
				cArqHtml		:= cMV_WFDIR +"\WfAPIMkp2.htm"
				oWFProc		:= nil
				cCodProces	:= "SENDWMKP1"
				_cAssunto		:= "[TRELAC] Quantidade Alterada Via Totvs"

				oWFProc := TWFProcess():New(cCodProces, _cAssunto)
				oWFProc:NewTask(_cAssunto, cArqHtml)
				oWFProc:cTo      := cEmailTo
				oWFProc:cSubject := _cAssunto
				oWFProc:oHtml:ValByName("D_DATABASE"       , DDATABASE ) //
				oWFProc:oHtml:ValByName("PRODUTOR"       , ZL6->ZL6_PRODUT + "-" + ZL6->ZL6_LOJPRD )
				oWFProc:oHtml:ValByName("NOME"       , ALLTRIM(ZL6->ZL6_NOMPRD) )
				oWFProc:oHtml:ValByName("VOLUME"       , ALLTRIM(STR(ZL6->ZL6_QTDE)) )
				oWFProc:oHtml:ValByName("VOLORI"       , ZL6->ZL6_QTDORI )
				oWFProc:oHtml:ValByName("LINHA"       , ALLTRIM(SA2->A2_X_LINHA) )
				oWFProc:oHtml:ValByName("DTCOLETA"       , ZL6->ZL6_DTCOL )
				oWFProc:oHtml:ValByName("USER"       , cUserAlt )
				oWFProc:oHtml:ValByName("PROBLEMA"       , "Quantidade Alterada Via TOTVS" )
				oWFProc:Start()

				RECLOCK("ZL6", .F.)
				ZL6->ZL6_IDMOB := 0
				ZL6->(MSUNLOCK())

			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Quando o Mov. Produtor não está integrado, executa regras visando integração do mesmo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				lRet := U_MLKUPZL6(3)
			EndIf




			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa API REST de EXCLUSÃO de coletas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case nOper == 5

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa regras de exclusão, caso o Mov. Produtor excluído esteja integrado com o MilkUp³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !EMPTY(ZL6->ZL6_MKUID)
				cId := ZL6->ZL6_MKUID

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Seta parâmetros de execução da integração³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				oRestClient:SetPath("/coletas/" + cId + "?" + cParam)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executra PUT e avalia retorno (sucesso\insucesso)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If !oRestClient:Delete(aHeader)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém o retorno da API e converte em JSON³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cRetJSON := oRestClient:GetLastError() + oRestClient:GetResult()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Apresenta mensagem ao usuário alertando em tonro da questão e não permite à inclusão do Fornecedor³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					Help(NIL, NIL, "Atenção", NIL, "Não foi possível realizar à integração da coleta do produtor com o MilkUp.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe à ocorrência ao departamento de TI."})
					Alert(cRetJSON)

					lRet := .F.
				EndIf
			EndIf
		EndCase
	EndIf

Return lRet
