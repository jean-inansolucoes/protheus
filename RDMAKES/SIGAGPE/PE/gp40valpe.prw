#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP40VALPE �Autor  �Luiz Gamero Prado   � Data �  08/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para envio workflow inclusao nova verba  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Laticinio Silvestre                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Gp40ValPE()

Local lRet := .T.

IF INCLUI == .T.
	cProcess := OemToAnsi("000001") // Numero do Processo
	cStatus  := OemToAnsi("001000")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Inclus�o nova verba "))
	oProcess:NewTask(cStatus,"\workflow\wfverba.htm")
	oProcess:cSubject := OemToAnsi("Aviso: Inclus�o nova Verba " + M->RV_COD  )
	
	
	oProcess:cTo :=  GetMv('MV_X_VERBA')
	
	oHtml:= oProcess:oHtml
	
	oHtml:ValByName( "verba", M->RV_COD )
	oHtml:ValByName( "descricao", M->RV_DESC )
	oHtml:ValByName( "usuario", SUBSTR(cUsuario,7,15))
	
	oProcess:Start()
ENDIF

Return(lRet)