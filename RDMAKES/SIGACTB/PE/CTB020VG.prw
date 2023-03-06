#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTB020VG �Autor  �Luiz Gamero Prado   � Data �  31/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para envio workflow inclusao nova conta  ���
���          �  contabil                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Laticinio Silvestre                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTB020VG()

Local lRet := .T.
Local nOpc	:= Paramixb[1]

IF nOpc==3

	cProcess := OemToAnsi("000001") // Numero do Processo
	cStatus  := OemToAnsi("001000")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Inclus�o nova Conta Cont�bil "))
	oProcess:NewTask(cStatus,"\workflow\wfctactb.htm")
	oProcess:cSubject := OemToAnsi("Aviso: Inclus�o nova Conta Contabil " + M->CT1_CONTA  )
	
	
	oProcess:cTo :=  GetMv('MV_X_CTACT')
	
	oHtml:= oProcess:oHtml
	
	oHtml:ValByName( "conta", M->CT1_CONTA )
	oHtml:ValByName( "descricao", M->CT1_DESC01 )
	oHtml:ValByName( "usuario", SUBSTR(cUsuario,7,15))
	
	oProcess:Start()

ENDIF

Return(lRet)