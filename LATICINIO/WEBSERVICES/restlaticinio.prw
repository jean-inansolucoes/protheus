#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PARMTYPE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSADDLT   ºAutor  ³Marcelo Joner        º Data ³ 25/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Serviço Rest de integração com o Addon Laticinio.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
WSRESTFUL WSADDLT DESCRIPTION "Integracao Addon Laticinio"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Propriedades para os parâmetros da QueryString (opcional)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	WSDATA RECEIVE    AS STRING
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Métodos HTTP que serão utilizados: POST, PUT, GET, DELETE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	WSMETHOD POST FORNECEDOR DESCRIPTION "Inclusão de novos cadastros de fornecedores." WSSYNTAX ""

END WSRESTFUL





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³POST      ºAutor  ³Marcelo Joner        º Data ³ 30/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Declaração do método POST do WSADDLTFORNECEDOR.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
WSMETHOD POST FORNECEDOR WSRECEIVE RECEIVE WSSERVICE WSADDLT

Local lRet			:= .T.
Local nI			:= ""
Local cJSON			:= Self:GetContent() //PEGA A STRING DO JSON
Local cCpoSA2		:= "A2_COD\A2_LOJA\A2_CGC\A2_TIPO\A2_NOME\A2_NREDUZ\A2_END\A2_XNRO\A2_CEP\A2_EST\A2_COD_MUN\A2_MUN\A2_TEL\A2_EMAIL\A2_X_MKUID\A2_PAIS\A2_MSBLQL\A2_X_LOCAL"
Local oParseJSON	:= Nil

Private bCampo		:= {|nCPO| Field(nCPO)}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Deserializa a string JSON³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FWJsonDeserialize(cJson, @oParseJSON)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se à propriedade principal - FORNECEDOR existe³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If AttIsMemberOf(oParseJSON, "FORNECEDOR")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Verifica se as propriedades obrigatorias foram repassadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If AttIsMemberOf(oParseJSON:FORNECEDOR, "CGC") .AND. AttIsMemberOf(oParseJSON:FORNECEDOR, "NOME")
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se já existe cadastro do fornecedor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SA2")
		SA2->(dbSetOrder(3))
		If !(SA2->(dbSeek(xFilial("SA1") + oParseJSON:FORNECEDOR:CGC)))
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Carrega Model - SA2³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oModel := FWLoadModel("MATA020")
			oModelSA2 := oModel:GetModel("SA2MASTER")
			oModel:Activate()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Atribui valores repassados ao serviço³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			M->A2_CGC		:= oParseJSON:FORNECEDOR:CGC
			M->A2_NOME		:= oParseJSON:FORNECEDOR:NOME
			M->A2_NREDUZ	:= oParseJSON:FORNECEDOR:NOME
			M->A2_TIPO		:= IIF(LEN(oParseJSON:FORNECEDOR:CGC) == 14, "J", "F")
			M->A2_END		:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "ENDERECO"), oParseJSON:FORNECEDOR:ENDERECO, "")
			M->A2_XNRO		:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "NUMERO"), oParseJSON:FORNECEDOR:NUMERO, "")
			M->A2_CEP		:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "CEP"), oParseJSON:FORNECEDOR:CEP, "")
			M->A2_EST		:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "UF"), oParseJSON:FORNECEDOR:UF, "")
			M->A2_COD_MUN	:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "CODMUN"), SUBSTR(oParseJSON:FORNECEDOR:CODMUN, 3,5), "")
			M->A2_MUN		:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "MUNICIPIO"), oParseJSON:FORNECEDOR:MUNICIPIO, "")
			M->A2_TEL		:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "FONE"), oParseJSON:FORNECEDOR:FONE, "")
			M->A2_EMAIL		:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "EMAIL"), oParseJSON:FORNECEDOR:EMAIL, "")
			M->A2_X_MKUID	:= IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "IDMILKUP"), oParseJSON:FORNECEDOR:IDMILKUP, "")
			M->A2_PAIS		:= "105"
			M->A2_MSBLQL	:= "1"
			M->A2_X_LOCAL   := IIF(AttIsMemberOf(oParseJSON:FORNECEDOR, "LATITUDE"), oParseJSON:FORNECEDOR:LATITUDE+";"+oParseJSON:FORNECEDOR:LONGITUDE, "")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa gatilhos para os campos de código e loja³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RunTrigger(1,NIL,NIL,,"A2_COD")
			RunTrigger(1,NIL,NIL,,"A2_LOJA")
			RunTrigger(1,NIL,NIL,,"A2_CGC")
			RunTrigger(1,NIL,NIL,,"A2_TIPO")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Obtém o código da loja atualizado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			M->A2_LOJA := oModelSA2:GetValue("A2_LOJA")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza à gravação do cadastro do fornecedor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !EMPTY(M->A2_COD) .AND. !EMPTY(M->A2_LOJA)
				dbSelectArea("SA2")
				RECLOCK("SA2", .T.)
					For nI := 1 To FCount()
						If FieldName(nI) == "A2_FILIAL"
							FieldPut(nI, xFilial("SA2"))
						ElseIf ALLTRIM(FieldName(nI)) $ cCpoSA2
							FieldPut(nI, M->&(FieldName(nI)))
						Endif
					Next nI	
				SA2->(MSUNLOCK())
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa função de envio de workflow³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				ADDLTWF001(ALLTRIM(SA2->A2_COD) + " \ " + ALLTRIM(SA2->A2_LOJA) + " - " + ALLTRIM(SA2->A2_NOME))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Retorna sucesso na inclusão do cadastro³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cJSONRet := '{' + CRLF
				cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
				cJSONRet += '"status": "Fornecedor cadastrado"' + CRLF
				cJSONRet += '}'
				
				Self:SetResponse(cJSONRet)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Falha na composição do código\loja do cadastro do fornecedor³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				lRet := .F.
				SetRestFault(400, EncodeUTF8("Falha na composição do código e loja do fornecedor"))
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Desativa o Model - SA2 utilizado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oModel:DeActivate()
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Já existindo o fornecedor, verifica se está bloqueado e ativa o mesmo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If SA2->A2_MSBLQL == "1"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Verifica se todos os campos obrigatórios do SA2 para o registro do Fornecedor estão informados³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				lUpdReg := .T.
				dbSelectArea("SX3")
				SX3->(dbSetOrder(1))
				SX3->(dbGoTop())
				SX3->(dbSeek("SA2"))
				While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "SA2"
					If X3OBRIGAT(SX3->X3_CAMPO)
						If EMPTY(&("SA2->" + ALLTRIM(SX3->X3_CAMPO)))
							lUpdReg := .F.
							exit
						EndIf 
					EndIf
					SX3->(dbSkip())
				End
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Caso possa desbloquear o registro, executa regras³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If lUpdReg
					RECLOCK("SA2", .F.)
						M->A2_MSBLQL := "2"
					SA2->(MSUNLOCK())
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Retorna sucesso na inclusão do cadastro³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					cJSONRet := '{' + CRLF
					cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
					cJSONRet += '"status": "Fornecedor existente e ativado"' + CRLF
					cJSONRet += '}'
					
					Self:SetResponse(cJSONRet)
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Retorna informando que já existe cadastro de fornecedor e o campo obrigatório identificado não foi atualizado em seu cadastro³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					lRet := .T.
					
					cJSONRet := '{' + CRLF
					cJSONRet += '"errorCode": 400,' + CRLF
					cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
					cJSONRet += '"errorMessage": "' + EncodeUTF8("Fornecedor já cadastrado: " + SA2->A2_COD + "-" + SA2->A2_LOJA + ", com campo obrigatório " + ALLTRIM(UPPER(SX3->X3_TITULO)) + " (" + ALLTRIM(SX3->X3_CAMPO) +  ") não informado em seu cadastro") + '"' + CRLF
					cJSONRet += '}'
					
					Self:SetResponse(cJSONRet)
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Retorna informando que já existe cadastro de fornecedor³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				lRet := .T.
				
				cJSONRet := '{' + CRLF
				cJSONRet += '"errorCode": 400,' + CRLF
				cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
				cJSONRet += '"errorMessage": "' + EncodeUTF8("Fornecedor já cadastrado: " + SA2->A2_COD + "–" + SA2->A2_LOJA) + '"' + CRLF
				cJSONRet += '}'
				
				Self:SetResponse(cJSONRet)
			EndIf
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Retorna informando que as propriedades obrigatórias (CGC ou NOME) não foram informadas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		lRet := .F.
		SetRestFault(400, EncodeUTF8("As propriedades obrigatórias (CGC ou NOME) não foram informadas"))
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Retorna informando que as propriedade obrigatória - FORNECEDOR não foi informada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	lRet := .F.
	SetRestFault(400, EncodeUTF8("A propriedade obrigatória FORNECEDOR não foi informada"))
EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADDLTWF001 ºAutor  ³Marcelo Joner       º Data ³ 30/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela geração de workflow na inclusão de  º±±
±±º          ³cadastro de Fornecedor através de REST.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ADDLTWF001(cFornecedor)

Local aArea		:= GetArea()
Local cStatus 	:= SPACE(6)
Local cEmails	:= ALLTRIM(GETMV("MV_ZL00006",,""))
Local cAssunto	:= "INCLUSÃO - CADASTRO FORNECEDOR"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso tenha e-mails para envio definidos, executa workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !EMPTY(cEmails)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Declaração do objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFADDLT001", cAssunto)
	oProcess:NewTask(cStatus,"\workflow\fornecedor_rest.htm")
	oProcess:cSubject := cAssunto
	oProcess:cTo  := cEmails
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Anexa ao e-mail, as imagens vinculadas ao layout do WF³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess:AttachFile("\workflow\logo_totvs.jpg")
	oProcess:AttachFile("\workflow\logo_cliente.jpg")
	                  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Carrega variaveis de execução do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oHtml:= oProcess:oHTML
	oHtml:ValByName("DATA"		, DTOC(dDataBase))
	oHtml:ValByName("FORNECEDOR", cFornecedor)
	oHtml:ValByName("ORIGEM"	, "INCLUSÃO VIA SOFTWARE - MILKUP")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess:Start()
EndIf

RestArea(aArea)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTSA2   ºAutor  ³Marcelo Joner        º Data ³ 30/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de teste na utilização do REST referente à inclusão  º±±
±±º          ³de cadastro de fornecedores.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TSTRESTSA2() 

Local cUrl			:= "http://127.0.0.1:7778/rest" 
Local cUser			:= "totvs" 
Local cPass			:= "totvs" 
Local cJSON			:= '{"FORNECEDOR":{"CGC":"00937259900","NOME":"MARCELO JONER","ENDERECO":"RUA ANGELIM, 235","NUMERO":"235","CEP":"85807190","UF":"PR","CODMUN":"048018","MUNICIPIO":"CASCAVEL","FONE":"33260446","EMAIL":"MJONER@TOTVS.COM.BR"}}'
Local oRestClient	:= FWRest():New(cUrl) 
Local aHeader		:= {} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Inclui o campo Authorization no formato : na base64 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aHeader, "Authorization: Basic " + Encode64(cUser+":"+cPass)) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Seta path e parametros de execução do POST³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oRestClient:SetPath("/WSADDLT/FORNECEDOR") 
oRestClient:SetPostParams(cJSON)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executra POST e avalia retorno (sucesso\insucesso)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If oRestClient:Post(aHeader) 
   Alert("POST - " + oRestClient:GetResult()) 
Else
   Alert("POST - " + oRestClient:GetLastError()) 
EndIf

Return
