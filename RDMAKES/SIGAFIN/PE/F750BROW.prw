
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F750BROW  �Autor  �Jefferson Mittanck  � Data �  29/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto Entrada Fun��es Contas a Pagar para novos bot�es     ���
���          � no browse                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � LATICINIO SILVESTRE                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F750BROW()
                
                AADD( aRotina, { "Liquida��o *"		,"FINA565()"	, 0 , 6})
                aAdd( aRotina, { "Canc. Desdobram.*","FaCanDsd"		, 0 , 5})
                aAdd( aRotina, { "Comp. Carteira *"	,"FINA450()"	, 0 , 6}) //"Compensa��o entre Carteiras"
                AADD( aRotina, { "Manut. Bordero *"	,"FINA590()"	, 0 , 6})
                AADD( aRotina, { "Cons. Posicao*"	,"Fc050Con()"	, 0 , 6})
                AADD( aRotina, { "Rastreamento *"	,"Fin250Pag(2)"	, 0 , 6})

 
                aMovBanc :={}
                               AADD( aMovBanc, { "Saldos Banc�rios"	,"FINA030()",      0 , 6})
                               AADD( aMovBanc, { "Movim. Banc�rios"	,"FINA100()",      0 , 6})
                               AADD( aMovBanc, { "Concil. Banc�ria"	,"FINA380()",      0 , 6})
                               AADD( aMovBanc, { "Recalc. Saldos"	,"FINA210()",      0 , 6})
                
                AADD( aRotina, { "Movim. Bancos *",aMovBanc,0 , 6})
                AADD( aRotina, { "Nota Empenho"	,"U_CMPREMP2()",      0 , 6})
                AADD( aRotina, { "Alt.Ven. Border�"	,"U_LSFIN016()",      0 , 6})  
                
                aMovCheq :={}
                               AADD( aMovCheq, { "Lib Cheque Ext"	,"U_LSFIN009()",      0 , 6})
                               AADD( aMovCheq, { "Del Cheque Ext"	,"U_LSFIN010()",      0 , 6})
                               AADD( aMovCheq, { "Del Cheque Mot. 12"	,"U_LSFIN011()",      0 , 6})
                                             
                AADD( aRotina, { "Movim. Cheques *",aMovCheq,0 , 6})
                

Return .t.
