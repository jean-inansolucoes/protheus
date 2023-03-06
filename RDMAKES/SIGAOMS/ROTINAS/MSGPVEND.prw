#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSGPVEND    �Autor �Alexandre Longhinotti�Data � 23/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Mensagems informativas nos pedidos de Venda                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � OMS                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSGPVEND(cMsg)
Local oButton1
Local oMultiGe1
Local cMultiGe1 := cMsg
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Mensagem" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

    @ 011, 012 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 218, 053 COLORS 0, 16777215 READONLY HSCROLL PIXEL
    @ 073, 193 BUTTON oButton1 PROMPT "Fechar" Action Close(oDlg) SIZE 037, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return 
