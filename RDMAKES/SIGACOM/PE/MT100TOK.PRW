
#include "protheus.ch"
#include "xmlxfun.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT100TOK  ?Autor  ?Rafael Parma       ? Data ?  09/04/2010  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Ponto de entrada acionado ap?s o usu?rio confirmar a inclus?o??
???          ?do documento de entrada.                                    ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS                                                       ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
*-------------------------*
User Function MT100TOK()
	*-------------------------*
	Local lRet := .T.
	Local cFunc := FUNNAME()

	If Alltrim(cFunc) != "MATA920"
		If Alltrim(FunName()) <> "SPEDNFE"
			lRet := U_VLXMLFOR()
		EndIf
	EndIF

return (lRet)




/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?VLXMLFOR  ?Autor  ?Rafael Parma       ? Data ?  09/04/2010  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Fun??o respons?vel pela valida??o dos dados do documento de ???
???          ?entrada de acordo com o arquivo XML repassado pelo fornecedor??
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS                                                       ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/            
*-------------------------*
User Function VLXMLFOR()
	*-------------------------*
	Local oXML
	Local lRet 		:= .T.
	Local aArea 	:= GetArea()
	Local aXml		:= {}
	Local aArq		:= {}
	Local lXml		:= .T.
	Local cType	    := ""
	Local cArq		:= ""
	Local cErro		:= ""
	Local cAviso    := ""
	Local cCNPJ		:= ""
	Local lCliente := .F.
	Local lExistNf := .F.
	Local lExitNF3 := .F.
	Local lExitNF2 := .F.
	Local lExitNF1 := .F.
	Local cEspecBD := ""
	Local cChaveDoc := ""
	Local cChaveSer := ""
	Local cMsg := "Aten??o! J? existe uma Nota Lan?ada para este Fornecedor com o mesmo N?mero/S?rie, Deseja continuar o Lan?amento?" +chr(10) +chr(13)
	Private cDir    := "xml"
	Default __cChvNFE := ""
	Default cXMLDEST := ""

	if INCLUI
		SF1->( dBCloseArea( ) )
	endif

	__cArqXml := ""

	If !Empty(__cChvNFE)
		cChaveSer := SUBSTR(__cChvNFE,23,3)
		cChaveDoc := SUBSTR(__cChvNFE,26,9)
	ElseIf SUBSTR(SF1->F1_CHVNFE,26,9) == STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
		cChaveSer := SUBSTR(SF1->F1_CHVNFE,23,3)
		cChaveDoc := SUBSTR(SF1->F1_CHVNFE,26,9)
	EndIf


                                 
	If !Empty(ALLTRIM(cEspecie)) .AND. ( Empty(cChaveDoc) .OR. (cChaveSer != STRZero(Val(cSerie),TamSX3("F1_SERIE")[1]) ) )
		If lExitNF1 := !Empty(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRTRAN(cSerie,"0","")+CA100FOR+CLOJA,"D1_EMISSAO"))
			cEspecBD += POSICIONE("SF1",1,XFILIAL("SF1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+cSerie+CA100FOR+CLOJA,"F1_ESPECIE")
			cMsg += ("EMISS?O: " + DTOC(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+cSerie+CA100FOR+CLOJA,"D1_EMISSAO")))
			cMsg += " - " + STRTRAN(cEspecBD,"/","") +chr(10) +chr(13)
			lExistNf := .T.
		EndIf
		If lExitNF2 := !Empty(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),2)+CA100FOR+CLOJA,"D1_EMISSAO"))
			cEspecBD += ("/" + POSICIONE("SF1",1,XFILIAL("SF1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),2)+CA100FOR+CLOJA,"F1_ESPECIE"))
			cMsg += ("EMISS?O: " + DTOC(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),2)+CA100FOR+CLOJA,"D1_EMISSAO")))
			cMsg += " - " + STRTRAN(cEspecBD,"/","") +chr(10) +chr(13)
			lExistNf := .T.
		EndIf
		If lExitNF3 := !Empty(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+CA100FOR+CLOJA,"D1_EMISSAO"))
			cEspecBD := ("/" + POSICIONE("SF1",1,XFILIAL("SF1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+CA100FOR+CLOJA,"F1_ESPECIE"))
			cMsg += ("EMISS?O: " + DTOC(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+CA100FOR+CLOJA,"D1_EMISSAO")))
			cMsg += " - " + STRTRAN(cEspecBD,"/","") +chr(10) +chr(13)
			lExistNf := .T.
		EndIf

		If ( !( TRIM(cEspecie) $ TRIM(cEspecBD) )  .AND. lExistNf ) .AND. ApMsgNoYes(cMsg)
			// Adiciona zeros antes do n?mero do documento
			If CFORMUL == "N" .and. CTIPO != "D"
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] )
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If  lExitNF3
					cSerie := STRZero(Val(cSerie),2)
				ElseIf lExitNF2
					cSerie := STRTRAN(cSerie,"0","")
				EndIf
				cCNPJ	 := POSICIONE( "SA2",1, XFILIAL( "SA2" ) + CA100FOR + CLOJA, "SA2->A2_CGC")
			Else
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] ) .AND. !Empty(cNFiscal)
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If  lExitNF3
					cSerie := STRZero(Val(cSerie),2)
				ElseIf lExitNF2
					cSerie := STRTRAN(cSerie,"0","")
				ElseIf Len(ALLTRIM(cSerie)) < TamSX3("F1_SERIE")[1]
					cSerie := STRZero(Val(cSerie),TamSX3("F1_SERIE")[1]) .AND. !Empty(cSerie)
				EndIf
				cCNPJ	 := POSICIONE( "SA1",1, XFILIAL( "SA1" ) + CA100FOR + CLOJA, "SA1->A1_CGC")
				If CFORMUL == "N"
					lCliente := .T.
				EndIf
			EndIf
		Else
			// Adiciona zeros antes do n?mero do documento
			If CFORMUL == "N" .and. CTIPO != "D"
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] )
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If Len(ALLTRIM(cSerie)) < TamSX3("F1_SERIE")[1]
					cSerie := STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])
				EndIf
				cCNPJ	 := POSICIONE( "SA2",1, XFILIAL( "SA2" ) + CA100FOR + CLOJA, "SA2->A2_CGC")
			Else
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] ) .AND. !Empty(cNFiscal)
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If Len(ALLTRIM(cSerie)) < TamSX3("F1_SERIE")[1] .AND. !Empty(cSerie)
					cSerie := STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])
				EndIf
				cCNPJ	 := POSICIONE( "SA1",1, XFILIAL( "SA1" ) + CA100FOR + CLOJA, "SA1->A1_CGC")
				If CFORMUL == "N"
					lCliente := .T.
				EndIf
			EndIf
		EndIf

		If INCLUI .OR. Empty(__cChvNFE)
			// Se especie do documento igual a SPED e formul?rio proprio = NAO
			If ALLTRIM(cEspecie) $ "SPED/CTE" .and. (CFORMUL == "N" .or. lCliente)
				// Filtro nome do arquivo dentro do diret?rio..
				If ALLTRIM(cEspecie) $ "SPED"
					cType := "Arquivo XML| *"+cCNPJ+"55"+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+"*.xml"
				Else
					cType := "Arquivo XML| *"+cCNPJ+"57"+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+"*.xml"
				EndIf

				If ALLTRIM(cEspecie) == "CTE"
					Public __cArqXml := ""
				EndIf

				// Verifica se o arquivo j? foi informado..
				If __cArqXml == ""

					__cChvNFE := ""
					__cArqXml := cGetFile( cType, "Selecione arquivo .xml", 1, "C:\"+cDir+"\", .F. , nOR(GETF_LOCALHARD, GETF_NOCHANGEDIR) )


				EndIf

				If ! cDir $ __cArqXml .or. Empty(__cArqXml)

					Aviso( "Aten??o", "Arquivo n?o informado ou diret?rio inv?lido!", {"OK"},,__cArqXml)
					Return .F.

				Else

					aXml := Directory(__cArqXml)


					// Verifica se ha XML a processar

					If (nXml := FOpen(__cArqXml,16)) < 0
						lXml := .F.
					Else
						lXml := .T.
					EndIf

					// Verifica se ha XML a processar

					If lXml

						cXml := FReadStr(nXml,aXml[1][2])
						oXML := XmlParser( cXml, "_", @cErro, @cAviso )

						FClose(nXml)

						If ! Empty(cErro)
							Aviso( "Aten??o", "Erro: " + cErro, {"OK"},,aXml[1][1])
							Return .F.
						EndIf
						If ! Empty(cAviso)
							Aviso( "Aten??o", cAviso, {"OK"},,aXml[1][1])
							Return .F.
						EndIf

					Else

						If Len(aXml) > 0
							Aviso( "Aten??o", "N?o foi possivel abrir arquivo", {"OK"},,aXml[1][1])
							FClose(nXml)
							Return .F.
						EndIf

					EndIf

					//Verifica estrutura do arquivo XML
					lOk := .F.
					aObj_Xml := ClassDataArr(oXml)

					If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFEPROC" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_NFEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFNFE" }) > 0
								aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0 .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
									aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
									lOk := .T.
									If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_DHEMI" }) > 0 //vers?o 3.10
										cXMLDOC  := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT)
										aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT)
										If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CNPJ" }) > 0
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										Elseif Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CPF" })
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										EndIf
										cXMLDEST := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
									Else
										cXMLDOC  := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
										aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT)
										If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CNPJ" }) > 0
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										Elseif Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CPF" })
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										EndIf
										cXMLDEST := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
									EndIf
								EndIf

							EndIf
						EndIf

						aObj_Xml := aClone(aOld_Xml)
						aObj_Xml := ClassDataArr(oXml:_NFEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_PROTNFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_NFEPROC:_PROTNFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT" }) > 0
								__cChvNFE := ALLTRIM(oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT)
							EndIf
						EndIf

					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ENVINFE" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_ENVINFE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_ENVINFE:_NFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFNFE" }) > 0
								aObj_Xml := ClassDataArr(oXml:_ENVINFE:_NFE:_INFNFE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0  .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
									lOk := .T.
									If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_DHEMI" }) > 0 //vers?o 3.10
										cXMLDOC  := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
										cXMLCNPJ := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
									Else
										cXMLDOC  := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
										cXMLCNPJ := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
										cXMLDEST := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
									Endif
								EndIf
							EndIf
						EndIf

						aObj_Xml := aClone(aOld_Xml)
						aObj_Xml := ClassDataArr(oXml:_ENVINFE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_PROTNFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_ENVINFE:_PROTNFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT" }) > 0
								__cChvNFE := ALLTRIM(oXML:_ENVINFE:_PROTNFE:_INFPROT:_CHNFE:TEXT)
							EndIf
						EndIf


					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFE" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_NFE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFNFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_NFE:_INFNFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0  .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
								lOk := .T.
								cXMLDOC  := ALLTRIM(oXML:_NFE:_INFNFE:_IDE:_NNF:TEXT)
								dXMLEMIS := ALLTRIM(oXML:_NFE:_INFNFE:_IDE:_DHEMI:TEXT)
								cXMLCNPJ := ALLTRIM(oXML:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
								cXMLDEST := ALLTRIM(oXML:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							EndIf

						EndIf

						__cChvNFE := ""
						Aviso("Aviso","Imposs?vel recuperar a chave NFE atrav?s do arquivo XML. Favor inserir a chave manualmente.",{"OK"})

					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CTEPROC" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_CTEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CTE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_CTEPROC:_CTE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFCTE" }) > 0
								aObj_Xml := ClassDataArr(oXml:_CTEPROC:_CTE:_INFCTE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0 .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
									lOk := .T.
									cXMLDOC  := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT)
									dXMLEMIS := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT)
									cXMLCNPJ := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
									aObj_Xml := ClassDataArr(oXml:_CTEPROC:_CTE:_INFCTE:_IDE)
									If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_TOMA3" }) > 0
										Do Case
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="0";	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="1"; 	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="2"; 	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT)
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="3"; 	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
										EndCase
									ElseIf !Empty(ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT))
										cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
									EndIf
								EndIf
							EndIf
						EndIf

						aObj_Xml := aClone(aOld_Xml)
						aObj_Xml := ClassDataArr(oXml:_CTEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_PROTCTE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_CTEPROC:_PROTCTE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT" }) > 0
								__cChvNFE := ALLTRIM(oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)
							ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT ID" }) > 0
								__cChvNFE := ALLTRIM(oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)
							EndIf
						EndIf


					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CTE" }) > 0

						aObj_Xml := ClassDataArr(oXml:_CTE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFCTE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_CTE:_INFCTE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0 .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
								lOk := .T.
								XMLDOC  := ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_NCT:TEXT)
								dXMLEMIS := ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_DHEMI:TEXT)
								cXMLCNPJ := ALLTRIM(oXML:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
								cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
								cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
								aObj_Xml := ClassDataArr(oXml:_CTE:_INFCTE:_IDE:_IDE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_TOMA3" }) > 0
									Do Case
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="0";	cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="1"; 	cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="2"; 	cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT)
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="3"; 	cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
									EndCase
								ElseIf !Empty(ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT))
									cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
								EndIf

							EndIf

						EndIf

						__cChvNFE := ""
						Aviso("Aviso","Imposs?vel recuperar a chave NFE atrav?s do arquivo XML. Favor inserir a chave manualmente.",{"OK"})

					EndIf


					If lOk	// Se localizou a estrutura correta

						dXMLEMIS := stod(StrTran( dXMLEMIS , "-" , "" ))
						If cTIPO == "D"
							dbSelectArea("SA1")
							dbSetOrder(1)
							dbSeek( xFilial("SA1") + CA100FOR + CLOJA )
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							dbSeek( xFilial("SA2") + CA100FOR + CLOJA )
						EndIf
						// Acerto do tamanho da vari?vel do documento no XML
						If Len(cXMLDOC) < TamSX3("F1_DOC")[1]
							cXMLDOC := STRZero(Val(cXMLDOC),TamSX3("F1_DOC")[1])
						EndIf

						If ! SM0->M0_CGC == cXMLDEST
							Aviso( "Aten??o", "Este documento n?o foi emitido para esta FILIAL", {"Ok"}, , aXml[1][1] )
							__cChvNFE := ""
							lOk := .F.
							lXml := .F.
							Return .F.

							// Verifica o documento contido no arquivo XML com o n?mero informado...
						ElseIf ! cXMLDOC == cNFiscal

							Aviso( "Aten??o", "O n?mero do documento contido no arquivo XML n?o ? igual ao informado!", {"Ok"}, , aXml[1][1] )
							Return .F.

							// Verifica se o CNPJ do fornecedor ? igual ao contido no arquivo XML...
						ElseIf (cXMLCNPJ != TRIM(SA2->A2_CGC) .and. cTipo != "D" ) .or. (cXMLCNPJ != TRIM(SA1->A1_CGC) .and. ( cTipo != "N" .and. cTipo != "C" .and. cTipo != "I" .and. cTipo != "B"))

							Aviso( "Aten??o", "O CNPJ do fornecedor contido no arquivo XML n?o ? igual ao do cadastro do fornecedor!", {"Ok"}, , aXml[1][1] )
							Return .F.

							// Verifica se a data de emiss?o ? igual a contida no arquivo XML...
						ElseIf dXMLEMIS != ddEmissao

							Aviso( "Aten??o", "A data de emiss?o contida no arquivo XML n?o ? igual a data informada!", {"Ok"}, ,  )
							Return .F.

						EndIf

					Else

						//Aviso( "Aten??o", "O arquivo XML deve possuir estrutura (opcional: NFEPROC), NFE, INFNFE e IDE", {"Ok"}, ,  )
						Return .F.

					EndIf

				EndIf

			EndIf

		EndIf
	ElseIf Empty(ALLTRIM(cEspecie))
		Return .F.
	EndIF
Return lRet

*-------------------------*
User Function VLXMLSER()
	*-------------------------*
	Local oXML
	Local lRet 		:= .T.
	Local aArea 	:= GetArea()
	Local aXml		:= {}
	Local aArq		:= {}
	Local lXml		:= .T.
	Local cType	    := ""
	Local cArq		:= ""
	Local cErro		:= ""
	Local cAviso    := ""
	Local cCNPJ		:= ""
	Local lCliente := .F.
	Local lExistNf := .F.
	Local lExitNF3 := .F.
	Local lExitNF2 := .F.
	Local lExitNF1 := .F.
	Local cEspecBD := ""
	Local cChaveDoc := ""
	Local cChaveSer := ""
	Local cMsg := "Aten??o! J? existe uma Nota Lan?ada para este Fornecedor com o Mesmo N?mero/S?rie, Deseja continuar o Lan?amento?" +chr(10) +chr(13)
	Private cDir    := "xml"
	Default __cChvNFE := ""

	__cArqXml := ""

	If !Empty(__cChvNFE)
		cChaveSer := SUBSTR(__cChvNFE,23,3)
		cChaveDoc := SUBSTR(__cChvNFE,26,9)
	ElseIf SUBSTR(SF1->F1_CHVNFE,26,9) == STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
		cChaveSer := SUBSTR(SF1->F1_CHVNFE,23,3)
		cChaveDoc := SUBSTR(SF1->F1_CHVNFE,26,9)
	EndIf


//Private cDir    := "xml_fornecedores\verificados"                                       
	If !Empty(ALLTRIM(cEspecie)) //.AND. ( Empty(cChaveDoc) .OR. (cChaveSer != STRZero(Val(cSerie),TamSX3("F1_SERIE")[1]) ) )
		If lExitNF1 := !Empty(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRTRAN(cSerie,"0","")+CA100FOR+CLOJA,"D1_EMISSAO"))
			cEspecBD += POSICIONE("SF1",1,XFILIAL("SF1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+cSerie+CA100FOR+CLOJA,"F1_ESPECIE")
			cMsg += ("EMISS?O: " + DTOC(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+cSerie+CA100FOR+CLOJA,"D1_EMISSAO")))
			cMsg += " - " + STRTRAN(cEspecBD,"/","") +chr(10) +chr(13)
			lExistNf := .T.
		EndIf
		If lExitNF2 := !Empty(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),2)+CA100FOR+CLOJA,"D1_EMISSAO"))
			cEspecBD += ("/" + POSICIONE("SF1",1,XFILIAL("SF1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),2)+CA100FOR+CLOJA,"F1_ESPECIE"))
			cMsg += ("EMISS?O: " + DTOC(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),2)+CA100FOR+CLOJA,"D1_EMISSAO")))
			cMsg += " - " + STRTRAN(cEspecBD,"/","") +chr(10) +chr(13)
			lExistNf := .T.
		EndIf
		If lExitNF3 := !Empty(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+CA100FOR+CLOJA,"D1_EMISSAO"))
			cEspecBD := ("/" + POSICIONE("SF1",1,XFILIAL("SF1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+CA100FOR+CLOJA,"F1_ESPECIE"))
			cMsg += ("EMISS?O: " + DTOC(POSICIONE("SD1",1,XFILIAL("SD1")+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+CA100FOR+CLOJA,"D1_EMISSAO")))
			cMsg += " - " + STRTRAN(cEspecBD,"/","") +chr(10) +chr(13)
			lExistNf := .T.
		EndIf

		If ( !( TRIM(cEspecie) $ TRIM(cEspecBD) )  .AND. lExistNf ) .AND. ApMsgNoYes(cMsg)
			// Adiciona zeros antes do n?mero do documento
			If CFORMUL == "N" .and. CTIPO != "D"
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] )
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If  lExitNF3
					cSerie := STRZero(Val(cSerie),2)
				ElseIf lExitNF2
					cSerie := STRTRAN(cSerie,"0","")
				EndIf
				cCNPJ	 := POSICIONE( "SA2",1, XFILIAL( "SA2" ) + CA100FOR + CLOJA, "SA2->A2_CGC")
			Else
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] ) .AND. !Empty(cNFiscal)
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If  lExitNF3
					cSerie := STRZero(Val(cSerie),2)
				ElseIf lExitNF2
					cSerie := STRTRAN(cSerie,"0","")
				ElseIf Len(ALLTRIM(cSerie)) < TamSX3("F1_SERIE")[1]
					cSerie := STRZero(Val(cSerie),TamSX3("F1_SERIE")[1]) .AND. !Empty(cSerie)
				EndIf
				cCNPJ	 := POSICIONE( "SA1",1, XFILIAL( "SA1" ) + CA100FOR + CLOJA, "SA1->A1_CGC")
				If CFORMUL == "N"
					lCliente := .T.
				EndIf
			EndIf
		Else
			// Adiciona zeros antes do n?mero do documento
			If CFORMUL == "N" .and. CTIPO != "D"
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] )
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If Len(ALLTRIM(cSerie)) < TamSX3("F1_SERIE")[1]
					cSerie := STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])
				EndIf
				cCNPJ	 := POSICIONE( "SA2",1, XFILIAL( "SA2" ) + CA100FOR + CLOJA, "SA2->A2_CGC")
			Else
				If (Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1] ) .AND. !Empty(cNFiscal)
					cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])
				EndIf
				If Len(ALLTRIM(cSerie)) < TamSX3("F1_SERIE")[1] .AND. !Empty(cSerie)
					cSerie := STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])
				EndIf
				cCNPJ	 := POSICIONE( "SA1",1, XFILIAL( "SA1" ) + CA100FOR + CLOJA, "SA1->A1_CGC")
				If CFORMUL == "N"
					lCliente := .T.
				EndIf
			EndIf
		EndIf

		If INCLUI .OR. Empty(__cChvNFE)
			// Se especie do documento igual a SPED e formul?rio proprio = NAO
			If ALLTRIM(cEspecie) $ "SPED/CTE" .and. (CFORMUL == "N" .or. lCliente)
				// Filtro nome do arquivo dentro do diret?rio..
				If ALLTRIM(cEspecie) $ "SPED"
					cType := "Arquivo XML| *"+cCNPJ+"55"+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+"*.xml"
				Else
					cType := "Arquivo XML| *"+cCNPJ+"57"+STRZero(Val(cSerie),TamSX3("F1_SERIE")[1])+STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])+"*.xml"
				EndIf

				If ALLTRIM(cEspecie) == "CTE"
					Public __cArqXml := ""
				EndIf

				// Verifica se o arquivo j? foi informado..
				If __cArqXml == ""

					__cChvNFE := ""
					__cArqXml := cGetFile( cType, "Selecione arquivo .xml", 1, "C:\"+cDir+"\", .F. , nOR(GETF_LOCALHARD, GETF_NOCHANGEDIR) )


				EndIf

				If ! cDir $ __cArqXml .or. Empty(__cArqXml)

					Aviso( "Aten??o", "Arquivo n?o informado ou diret?rio inv?lido!", {"OK"},,__cArqXml)
					Return .F.

				Else

					aXml := Directory(__cArqXml)


					// Verifica se ha XML a processar

					If (nXml := FOpen(__cArqXml,16)) < 0
						lXml := .F.
					Else
						lXml := .T.
					EndIf

					// Verifica se ha XML a processar

					If lXml

						cXml := FReadStr(nXml,aXml[1][2])
						oXML := XmlParser( cXml, "_", @cErro, @cAviso )

						FClose(nXml)

						If ! Empty(cErro)
							Aviso( "Aten??o", "Erro: " + cErro, {"OK"},,aXml[1][1])
							Return .F.
						EndIf
						If ! Empty(cAviso)
							Aviso( "Aten??o", cAviso, {"OK"},,aXml[1][1])
							Return .F.
						EndIf

					Else

						If Len(aXml) > 0
							Aviso( "Aten??o", "N?o foi possivel abrir arquivo", {"OK"},,aXml[1][1])
							FClose(nXml)
							Return .F.
						EndIf

					EndIf

					//Verifica estrutura do arquivo XML
					lOk := .F.
					aObj_Xml := ClassDataArr(oXml)

					If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFEPROC" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_NFEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFNFE" }) > 0
								aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0 .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
									aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
									lOk := .T.
									If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_DHEMI" }) > 0 //vers?o 3.10
										cXMLDOC  := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT)
										aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT)
										If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CNPJ" }) > 0
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										Elseif Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CPF" })
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										EndIf
										cXMLDEST := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
									Else
										cXMLDOC  := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
										aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT)
										If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CNPJ" }) > 0
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										Elseif Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CPF" })
											cXMLCNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT)
											aObj_Xml := ClassDataArr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE)
										EndIf
										cXMLDEST := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
									EndIf
								EndIf

							EndIf
						EndIf

						aObj_Xml := aClone(aOld_Xml)
						aObj_Xml := ClassDataArr(oXml:_NFEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_PROTNFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_NFEPROC:_PROTNFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT" }) > 0
								__cChvNFE := ALLTRIM(oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT)
							EndIf
						EndIf

					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ENVINFE" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_ENVINFE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_ENVINFE:_NFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFNFE" }) > 0
								aObj_Xml := ClassDataArr(oXml:_ENVINFE:_NFE:_INFNFE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0  .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
									lOk := .T.
									If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_DHEMI" }) > 0 //vers?o 3.10
										cXMLDOC  := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
										cXMLCNPJ := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
									Else
										cXMLDOC  := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_NNF:TEXT)
										dXMLEMIS := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
										cXMLCNPJ := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
										cXMLDEST := ALLTRIM(oXML:_ENVINFE:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
									Endif
								EndIf
							EndIf
						EndIf

						aObj_Xml := aClone(aOld_Xml)
						aObj_Xml := ClassDataArr(oXml:_ENVINFE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_PROTNFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_ENVINFE:_PROTNFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT" }) > 0
								__cChvNFE := ALLTRIM(oXML:_ENVINFE:_PROTNFE:_INFPROT:_CHNFE:TEXT)
							EndIf
						EndIf


					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_NFE" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_NFE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFNFE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_NFE:_INFNFE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0  .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
								lOk := .T.
								cXMLDOC  := ALLTRIM(oXML:_NFE:_INFNFE:_IDE:_NNF:TEXT)
								dXMLEMIS := ALLTRIM(oXML:_NFE:_INFNFE:_IDE:_DHEMI:TEXT)
								cXMLCNPJ := ALLTRIM(oXML:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
								cXMLDEST := ALLTRIM(oXML:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							EndIf

						EndIf

						__cChvNFE := ""
						Aviso("Aviso","Imposs?vel recuperar a chave NFE atrav?s do arquivo XML. Favor inserir a chave manualmente.",{"OK"})

					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CTEPROC" }) > 0

						aOld_Xml := aClone(aObj_Xml)
						aObj_Xml := ClassDataArr(oXml:_CTEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CTE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_CTEPROC:_CTE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFCTE" }) > 0
								aObj_Xml := ClassDataArr(oXml:_CTEPROC:_CTE:_INFCTE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0 .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
									lOk := .T.
									cXMLDOC  := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT)
									dXMLEMIS := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT)
									cXMLCNPJ := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
									aObj_Xml := ClassDataArr(oXml:_CTEPROC:_CTE:_INFCTE:_IDE)
									If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_TOMA3" }) > 0
										Do Case
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="0";	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="1"; 	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="2"; 	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT)
										Case oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="3"; 	cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
										EndCase
									ElseIf !Empty(ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT))
										cXMLDEST := ALLTRIM(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
									EndIf
								EndIf
							EndIf
						EndIf

						aObj_Xml := aClone(aOld_Xml)
						aObj_Xml := ClassDataArr(oXml:_CTEPROC)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_PROTCTE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_CTEPROC:_PROTCTE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT" }) > 0
								__cChvNFE := ALLTRIM(oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)
							ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFPROT ID" }) > 0
								__cChvNFE := ALLTRIM(oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)
							EndIf
						EndIf


					ElseIf Ascan(aObj_Xml,{|x| Upper(x[1]) == "_CTE" }) > 0

						aObj_Xml := ClassDataArr(oXml:_CTE)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_INFCTE" }) > 0
							aObj_Xml := ClassDataArr(oXml:_CTE:_INFCTE)
							If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_IDE" }) > 0 .and. Ascan(aObj_Xml,{|x| Upper(x[1]) == "_EMIT" }) > 0
								lOk := .T.
								XMLDOC  := ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_NCT:TEXT)
								dXMLEMIS := ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_DHEMI:TEXT)
								cXMLCNPJ := ALLTRIM(oXML:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
								cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
								cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
								aObj_Xml := ClassDataArr(oXml:_CTE:_INFCTE:_IDE:_IDE)
								If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_TOMA3" }) > 0
									Do Case
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="0";		cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="1"; 	cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="2"; 	cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT)
									Case oXML:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT=="3"; 	cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
									EndCase
								ElseIf !Empty(ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT))
									cXMLDEST := ALLTRIM(oXML:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
								EndIf

							EndIf

						EndIf

						__cChvNFE := ""
						Aviso("Aviso","Imposs?vel recuperar a chave NFE atrav?s do arquivo XML. Favor inserir a chave manualmente.",{"OK"})

					EndIf


					If lOk	// Se localizou a estrutura correta

						dXMLEMIS := stod(StrTran( dXMLEMIS , "-" , "" ))
						If cTIPO == "D"
							dbSelectArea("SA1")
							dbSetOrder(1)
							dbSeek( xFilial("SA1") + CA100FOR + CLOJA )
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							dbSeek( xFilial("SA2") + CA100FOR + CLOJA )
						EndIf
						// Acerto do tamanho da vari?vel do documento no XML
						If Len(cXMLDOC) < TamSX3("F1_DOC")[1]
							cXMLDOC := STRZero(Val(cXMLDOC),TamSX3("F1_DOC")[1])
						EndIf

						If ! SM0->M0_CGC == cXMLDEST
							Aviso( "Aten??o", "Este documento n?o foi emitido para esta FILIAL", {"Ok"}, , aXml[1][1] )
							__cChvNFE := ""
							lOk := .F.
							lXml := .F.
							Return .F.

							// Verifica o documento contido no arquivo XML com o n?mero informado...
						ElseIf ! cXMLDOC == cNFiscal

							Aviso( "Aten??o", "O n?mero do documento contido no arquivo XML n?o ? igual ao informado!", {"Ok"}, , aXml[1][1] )
							Return .F.

							// Verifica se o CNPJ do fornecedor ? igual ao contido no arquivo XML...
						ElseIf (cXMLCNPJ != TRIM(SA2->A2_CGC) .and. cTipo != "D" ) .or. (cXMLCNPJ != TRIM(SA1->A1_CGC) .and. ( cTipo != "N" .and. cTipo != "C" .and. cTipo != "I" .and. cTipo != "B"))

							Aviso( "Aten??o", "O CNPJ do fornecedor contido no arquivo XML n?o ? igual ao do cadastro do fornecedor!", {"Ok"}, , aXml[1][1] )
							Return .F.

							// Verifica se a data de emiss?o ? igual a contida no arquivo XML...
						ElseIf dXMLEMIS != ddEmissao

							Aviso( "Aten??o", "A data de emiss?o contida no arquivo XML n?o ? igual a data informada!", {"Ok"}, ,  )
							Return .F.

						EndIf

					Else

						//Aviso( "Aten??o", "O arquivo XML deve possuir estrutura (opcional: NFEPROC), NFE, INFNFE e IDE", {"Ok"}, ,  )
						Return .F.

					EndIf

				EndIf

			EndIf

		EndIf
	EndIF
Return lRet
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NIXMLCTE ?Autor  ?Rafael Parma       ? Data ?  29/03/2011  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Fun??o respons?vel pela leitura do codigo de barras do CTE. ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS                                                       ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/  
	*-------------------------------*
Static Function NIXMLCTE()
	*-------------------------------*
	Private cFILXML := ""
	Private cSTRING := Space(50)
	Private nOpcao  := 0
	Private cDir    := "xml"
//Private cDir    := "xml_fornecedores\verificados"  
	Private oDlg


	DEFINE MSDIALOG oDlg FROM 010,100 TO 150,420 TITLE "XML - CTE"  OF oMainWnd PIXEL
	@ 005, 005 TO 065, 158 OF oDlg  PIXEL

	@ 011,060 SAY "C?digo de barras:"   SIZE 100,10 OF oDlg PIXEL
	@ 022,010 GET cSTRING SIZE 145,09 OF oDlg PIXEL

	DEFINE SBUTTON FROM 040, 055 TYPE 1 ACTION (nOpcao:=1,oDlg:End()) ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM 040, 085 TYPE 2 ACTION (nOpcao:=2,oDlg:End()) ENABLE OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpcao == 1
		cTEMP := cDir+ALLTRIM(cSTRING)+".XML"
		If !File(cTEMP)
			Aviso("XML-CTE","Arquivo n?o encontrado "+cTEMP,{"OK"},2)
		Else
			cFILXML := cTEMP
		EndIf
	Endif
	__cArqXml := ""

Return (cFILXML)
