
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF750BROW  บAutor  ณJefferson Mittanck  บ Data ณ  29/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto Entrada Fun็๕es Contas a Pagar para novos bot๕es     บฑฑ
ฑฑบ          ณ no browse                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LATICINIO SILVESTRE                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F750BROW()
                
                AADD( aRotina, { "Liquida็ใo *"		,"FINA565()"	, 0 , 6})
                aAdd( aRotina, { "Canc. Desdobram.*","FaCanDsd"		, 0 , 5})
                aAdd( aRotina, { "Comp. Carteira *"	,"FINA450()"	, 0 , 6}) //"Compensa็ใo entre Carteiras"
                AADD( aRotina, { "Manut. Bordero *"	,"FINA590()"	, 0 , 6})
                AADD( aRotina, { "Cons. Posicao*"	,"Fc050Con()"	, 0 , 6})
                AADD( aRotina, { "Rastreamento *"	,"Fin250Pag(2)"	, 0 , 6})

 
                aMovBanc :={}
                               AADD( aMovBanc, { "Saldos Bancแrios"	,"FINA030()",      0 , 6})
                               AADD( aMovBanc, { "Movim. Bancแrios"	,"FINA100()",      0 , 6})
                               AADD( aMovBanc, { "Concil. Bancแria"	,"FINA380()",      0 , 6})
                               AADD( aMovBanc, { "Recalc. Saldos"	,"FINA210()",      0 , 6})
                
                AADD( aRotina, { "Movim. Bancos *",aMovBanc,0 , 6})
                AADD( aRotina, { "Nota Empenho"	,"U_CMPREMP2()",      0 , 6})
                AADD( aRotina, { "Alt.Ven. Border๔"	,"U_LSFIN016()",      0 , 6})  
                
                aMovCheq :={}
                               AADD( aMovCheq, { "Lib Cheque Ext"	,"U_LSFIN009()",      0 , 6})
                               AADD( aMovCheq, { "Del Cheque Ext"	,"U_LSFIN010()",      0 , 6})
                               AADD( aMovCheq, { "Del Cheque Mot. 12"	,"U_LSFIN011()",      0 , 6})
                                             
                AADD( aRotina, { "Movim. Cheques *",aMovCheq,0 , 6})
                

Return .t.
