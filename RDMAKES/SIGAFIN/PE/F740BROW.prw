
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F750BROW  �Autor  �Jefferson Mittanck  � Data �  29/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Entrada Fun��es Contas a Receber para novos bot�es   ���
���          � no browse                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � LATICINIO SILVESTRE                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F740BROW()

                aAdd( aRotina, { "Canc. Desdobram. *","FaCanDsd"	, 0 , 5})
                aAdd( aRotina, { "Comp. Carteira *"	 ,"FINA450()"	, 0 , 6}) //"Compensa��o entre Carteiras"
                AADD( aRotina, { "Cons. Posicao *"	 ,"Fc040Con()"	, 0 , 6})
                AADD( aRotina, { "Rastreamento *"	 ,"Fin250Rec(2)", 0 , 6})
                AADD( aRotina, { "Manut. Bordero *"	 ,"FINA590()"	, 0 , 6})

                aMovBanc :={}
                               AADD( aMovBanc, { "Saldos Banc�rios","FINA030()"	, 0 , 6})
                               AADD( aMovBanc, { "Movim. Banc�rios","FINA100()"	, 0 , 6})
                               AADD( aMovBanc, { "Concil. Banc�ria", "FINA380()", 0 , 6})
                               AADD( aMovBanc, { "Recalc. Saldos"  ,"FINA210()"	, 0 , 6})
                                               
                AADD( aRotina, { "Movim. Bancos *",aMovBanc,   0 , 6})
                AADD( aRotina, { "Cons. Tit. Origem *"	 ,"U_RTORINCC()"	, 0 , 6})
                AADD( aRotina, { "Cons. Tit. Compensado *"	 ,"U_RTORIABT()"	, 0 , 6})
                AADD( aRotina, { "Emiss�o de Boletos *"	 ,"U_LSFIN003()"	, 0 , 6})
                AADD( aRotina, { "Instr. de cobran�a *"	 ,"FINA151()"	, 0 , 6})
                AADD( aRotina, { "Carta de cobran�a *"	 ,"U_WFFIN001()"	, 0 , 6})

Return .t.
