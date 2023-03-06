#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PARMTYPE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �WSADDLT   �Autor  �Marcelo Joner        � Data � 25/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Servi�o Rest de integra��o com o Addon Laticinio.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Laticinio                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WSRESTFUL WSADDLT DESCRIPTION "Integracao Addon Laticinio"
	
	//������������������������������������������������������������
	//� Propriedades para os par�metros da QueryString (opcional)�
	//������������������������������������������������������������
	WSDATA RECEIVE    AS STRING
	
	//������������������������������������������������������������
	//� M�todos HTTP que ser�o utilizados: POST, PUT, GET, DELETE�
	//������������������������������������������������������������
	WSMETHOD POST FORNECEDOR DESCRIPTION "Inclus�o de novos cadastros de fornecedores." WSSYNTAX ""

END WSRESTFUL





/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �POST      �Autor  �Marcelo Joner        � Data � 30/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Declara��o do m�todo POST do WSADDLTFORNECEDOR.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Laticinio                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WSMETHOD POST FORNECEDOR WSRECEIVE RECEIVE WSSERVICE WSADDLT

Local lRet			:= .T.
Local nI			:= ""
Local cJSON			:= Self:GetContent() //PEGA A STRING DO JSON
Local cCpoSA2		:= "A2_COD\A2_LOJA\A2_CGC\A2_TIPO\A2_NOME\A2_NREDUZ\A2_END\A2_XNRO\A2_CEP\A2_EST\A2_COD_MUN\A2_MUN\A2_TEL\A2_EMAIL\A2_X_MKUID\A2_PAIS\A2_MSBLQL\A2_X_LOCAL"
Local oParseJSON	:= Nil

Private bCampo		:= {|nCPO| Field(nCPO)}

//���������������������������
//�Deserializa a string JSON�
//���������������������������
FWJsonDeserialize(cJson, @oParseJSON)

//���������������������������������������������������������
//�Verifica se � propriedade principal - FORNECEDOR existe�
//���������������������������������������������������������
If AttIsMemberOf(oParseJSON, "FORNECEDOR")

	//�����������������������������������������������������������
	//�Verifica se as propriedades obrigatorias foram repassadas�
	//�����������������������������������������������������������
	If AttIsMemberOf(oParseJSON:FORNECEDOR, "CGC") .AND. AttIsMemberOf(oParseJSON:FORNECEDOR, "NOME")
	
		//����������������������������������������������
		//�Verifica se j� existe cadastro do fornecedor�
		//����������������������������������������������
		dbSelectArea("SA2")
		SA2->(dbSetOrder(3))
		If !(SA2->(dbSeek(xFilial("SA1") + oParseJSON:FORNECEDOR:CGC)))
		
			//���������������������
			//�Carrega Model - SA2�
			//���������������������
			oModel := FWLoadModel("MATA020")
			oModelSA2 := oModel:GetModel("SA2MASTER")
			oModel:Activate()
			
			//���������������������������������������
			//�Atribui valores repassados ao servi�o�
			//���������������������������������������
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
			//��������������������������������������������������
			//�Executa gatilhos para os campos de c�digo e loja�
			//��������������������������������������������������
			RunTrigger(1,NIL,NIL,,"A2_COD")
			RunTrigger(1,NIL,NIL,,"A2_LOJA")
			RunTrigger(1,NIL,NIL,,"A2_CGC")
			RunTrigger(1,NIL,NIL,,"A2_TIPO")
			
			//�����������������������������������
			//�Obt�m o c�digo da loja atualizado�
			//�����������������������������������
			M->A2_LOJA := oModelSA2:GetValue("A2_LOJA")
			
			//����������������������������������������������
			//�Realiza � grava��o do cadastro do fornecedor�
			//����������������������������������������������
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
				
				//�������������������������������������
				//�Executa fun��o de envio de workflow�
				//�������������������������������������
				ADDLTWF001(ALLTRIM(SA2->A2_COD) + " \ " + ALLTRIM(SA2->A2_LOJA) + " - " + ALLTRIM(SA2->A2_NOME))
				
				//�����������������������������������������
				//�Retorna sucesso na inclus�o do cadastro�
				//�����������������������������������������
				cJSONRet := '{' + CRLF
				cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
				cJSONRet += '"status": "Fornecedor cadastrado"' + CRLF
				cJSONRet += '}'
				
				Self:SetResponse(cJSONRet)
			Else
				//��������������������������������������������������������������
				//�Falha na composi��o do c�digo\loja do cadastro do fornecedor�
				//��������������������������������������������������������������
				lRet := .F.
				SetRestFault(400, EncodeUTF8("Falha na composi��o do c�digo e loja do fornecedor"))
			EndIf
			
			//����������������������������������
			//�Desativa o Model - SA2 utilizado�
			//����������������������������������
			oModel:DeActivate()
		Else
			//�����������������������������������������������������������������������
			//�J� existindo o fornecedor, verifica se est� bloqueado e ativa o mesmo�
			//�����������������������������������������������������������������������
			If SA2->A2_MSBLQL == "1"
				
				//������������������������������������������������������������������������������������������������
				//�Verifica se todos os campos obrigat�rios do SA2 para o registro do Fornecedor est�o informados�
				//������������������������������������������������������������������������������������������������
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
				
				//���������������������������������������������������
				//�Caso possa desbloquear o registro, executa regras�
				//���������������������������������������������������
				If lUpdReg
					RECLOCK("SA2", .F.)
						M->A2_MSBLQL := "2"
					SA2->(MSUNLOCK())
					
					//�����������������������������������������
					//�Retorna sucesso na inclus�o do cadastro�
					//�����������������������������������������
					cJSONRet := '{' + CRLF
					cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
					cJSONRet += '"status": "Fornecedor existente e ativado"' + CRLF
					cJSONRet += '}'
					
					Self:SetResponse(cJSONRet)
				Else
					//�������������������������������������������������������������������������������������������������������������������������������
					//�Retorna informando que j� existe cadastro de fornecedor e o campo obrigat�rio identificado n�o foi atualizado em seu cadastro�
					//�������������������������������������������������������������������������������������������������������������������������������
					lRet := .T.
					
					cJSONRet := '{' + CRLF
					cJSONRet += '"errorCode": 400,' + CRLF
					cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
					cJSONRet += '"errorMessage": "' + EncodeUTF8("Fornecedor j� cadastrado: " + SA2->A2_COD + "-" + SA2->A2_LOJA + ", com campo obrigat�rio " + ALLTRIM(UPPER(SX3->X3_TITULO)) + " (" + ALLTRIM(SX3->X3_CAMPO) +  ") n�o informado em seu cadastro") + '"' + CRLF
					cJSONRet += '}'
					
					Self:SetResponse(cJSONRet)
				EndIf
			Else
				//���������������������������������������������������������
				//�Retorna informando que j� existe cadastro de fornecedor�
				//���������������������������������������������������������
				lRet := .T.
				
				cJSONRet := '{' + CRLF
				cJSONRet += '"errorCode": 400,' + CRLF
				cJSONRet += '"codigo_produtor": "' + SA2->A2_COD + '-' + SA2->A2_LOJA + '",' + CRLF
				cJSONRet += '"errorMessage": "' + EncodeUTF8("Fornecedor j� cadastrado: " + SA2->A2_COD + "�" + SA2->A2_LOJA) + '"' + CRLF
				cJSONRet += '}'
				
				Self:SetResponse(cJSONRet)
			EndIf
		EndIf
	Else
		//����������������������������������������������������������������������������������������
		//�Retorna informando que as propriedades obrigat�rias (CGC ou NOME) n�o foram informadas�
		//����������������������������������������������������������������������������������������
		lRet := .F.
		SetRestFault(400, EncodeUTF8("As propriedades obrigat�rias (CGC ou NOME) n�o foram informadas"))
	EndIf
Else
	//����������������������������������������������������������������������������������
	//�Retorna informando que as propriedade obrigat�ria - FORNECEDOR n�o foi informada�
	//����������������������������������������������������������������������������������
	lRet := .F.
	SetRestFault(400, EncodeUTF8("A propriedade obrigat�ria FORNECEDOR n�o foi informada"))
EndIf

Return lRet





/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �ADDLTWF001 �Autor  �Marcelo Joner       � Data � 30/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela gera��o de workflow na inclus�o de  ���
���          �cadastro de Fornecedor atrav�s de REST.                     ���
�������������������������������������������������������������������������͹��
���Uso       � Laticinio                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ADDLTWF001(cFornecedor)

Local aArea		:= GetArea()
Local cStatus 	:= SPACE(6)
Local cEmails	:= ALLTRIM(GETMV("MV_ZL00006",,""))
Local cAssunto	:= "INCLUS�O - CADASTRO FORNECEDOR"

//�����������������������������������������������������������
//�Caso tenha e-mails para envio definidos, executa workflow�
//�����������������������������������������������������������
If !EMPTY(cEmails)
	
	//�������������������������������������������
	//�Declara��o do objeto de envio do workflow�
	//�������������������������������������������
	oProcess := TWFProcess():New("WFADDLT001", cAssunto)
	oProcess:NewTask(cStatus,"\workflow\fornecedor_rest.htm")
	oProcess:cSubject := cAssunto
	oProcess:cTo  := cEmails
	
	//��������������������������������������������������������
	//�Anexa ao e-mail, as imagens vinculadas ao layout do WF�
	//��������������������������������������������������������
	oProcess:AttachFile("\workflow\logo_totvs.jpg")
	oProcess:AttachFile("\workflow\logo_cliente.jpg")
	                  
	//�������������������������������������������
	//�Carrega variaveis de execu��o do workflow�
	//�������������������������������������������
	oHtml:= oProcess:oHTML
	oHtml:ValByName("DATA"		, DTOC(dDataBase))
	oHtml:ValByName("FORNECEDOR", cFornecedor)
	oHtml:ValByName("ORIGEM"	, "INCLUS�O VIA SOFTWARE - MILKUP")
	
	//������������������
	//�Envia o workflow�
	//������������������
	oProcess:Start()
EndIf

RestArea(aArea)

Return





/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �RESTSA2   �Autor  �Marcelo Joner        � Data � 30/03/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o de teste na utiliza��o do REST referente � inclus�o  ���
���          �de cadastro de fornecedores.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Laticinio                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TSTRESTSA2() 

Local cUrl			:= "http://127.0.0.1:7778/rest" 
Local cUser			:= "totvs" 
Local cPass			:= "totvs" 
Local cJSON			:= '{"FORNECEDOR":{"CGC":"00937259900","NOME":"MARCELO JONER","ENDERECO":"RUA ANGELIM, 235","NUMERO":"235","CEP":"85807190","UF":"PR","CODMUN":"048018","MUNICIPIO":"CASCAVEL","FONE":"33260446","EMAIL":"MJONER@TOTVS.COM.BR"}}'
Local oRestClient	:= FWRest():New(cUrl) 
Local aHeader		:= {} 

//������������������������������������������������������
//�Inclui o campo Authorization no formato : na base64 �
//������������������������������������������������������
AADD(aHeader, "Authorization: Basic " + Encode64(cUser+":"+cPass)) 

//��������������������������������������������
//�Seta path e parametros de execu��o do POST�
//��������������������������������������������
oRestClient:SetPath("/WSADDLT/FORNECEDOR") 
oRestClient:SetPostParams(cJSON)

//����������������������������������������������������
//�Executra POST e avalia retorno (sucesso\insucesso)�
//����������������������������������������������������
If oRestClient:Post(aHeader) 
   Alert("POST - " + oRestClient:GetResult()) 
Else
   Alert("POST - " + oRestClient:GetLastError()) 
EndIf

Return
