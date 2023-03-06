#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410ALOK  �Autor  � Trelac             � Data � 01/07/2022 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida altera��o do Pedido de venda						  ���
�������������������������������������������������������������������������͹��
���Uso       � Laticinio Silvestre                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410ALOK()
************************
Local lRet       := .F.

	If Empty(ALLTRIM(SC5->C5_X_SIMUL)) .OR. IsInCallStack( "U_FLXFAT03" )
		lRet       := .T.
	else
		Aviso( "Aten��o", "Pedido de venda n�o pode ser alterado pois est� em uma carga, Solicite o estorno!", { "OK" } )
	EndIf

Return( lRet )
