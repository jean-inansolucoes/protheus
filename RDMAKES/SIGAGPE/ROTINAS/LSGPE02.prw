#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LSGPE02  �Autor � Totvs Parana Central  �Data � 07/02/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Lancamentos por verba com filtro.                          ���
��                                                                		  ���
�������������������������������������������������������������������������ͺ��
���Uso       � Laticinio Silvestre    GPE                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

*/
User Function LSGPE02() 

	dbSelectArea("SRV")
	SET FILTER TO SRV->RV_COD == "409"
	SRV->(dbGoTop())
	GPEA100()
	dbSelectArea("SRV")
	SET FILTER TO
	
Return

