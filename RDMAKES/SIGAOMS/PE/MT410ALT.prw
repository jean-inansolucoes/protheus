#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410ALT �Autor  � Lincoln Rossetto   � Data �  20/09/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina respons�vel pela valida��o do preenchimento das for-���
���          � mas de pagamento no pedido de venda.                       ���
�������������������������������������������������������������������������͹��
���Uso       � Laticinio Silvestre                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410ALT()
************************
Local lRet       := .T.

IF lRet
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbGoTop()   
	If dbSeek ( xFilial("SC6") + M->C5_NUM )
		While ! SC6->(EOF()) .and. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC5") + M->C5_NUM
			RecLock( "SC6", .F. )
			SC6->C6_ENTREG := M->C5_FECENT
			SC6->(dbSkip())
			SC6->( MsUnLock( ) )
					
		EndDo
	
	EndIf
EndIf

Return( lRet )
