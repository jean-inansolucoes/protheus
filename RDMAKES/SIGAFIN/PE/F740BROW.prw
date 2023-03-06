
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF750BROW  บAutor  ณJefferson Mittanck  บ Data ณ  29/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto Entrada Fun็๕es Contas a Receber para novos bot๕es   บฑฑ
ฑฑบ          ณ no browse                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LATICINIO SILVESTRE                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F740BROW()

                aAdd( aRotina, { "Canc. Desdobram. *","FaCanDsd"	, 0 , 5})
                aAdd( aRotina, { "Comp. Carteira *"	 ,"FINA450()"	, 0 , 6}) //"Compensa็ใo entre Carteiras"
                AADD( aRotina, { "Cons. Posicao *"	 ,"Fc040Con()"	, 0 , 6})
                AADD( aRotina, { "Rastreamento *"	 ,"Fin250Rec(2)", 0 , 6})
                AADD( aRotina, { "Manut. Bordero *"	 ,"FINA590()"	, 0 , 6})

                aMovBanc :={}
                               AADD( aMovBanc, { "Saldos Bancแrios","FINA030()"	, 0 , 6})
                               AADD( aMovBanc, { "Movim. Bancแrios","FINA100()"	, 0 , 6})
                               AADD( aMovBanc, { "Concil. Bancแria", "FINA380()", 0 , 6})
                               AADD( aMovBanc, { "Recalc. Saldos"  ,"FINA210()"	, 0 , 6})
                                               
                AADD( aRotina, { "Movim. Bancos *",aMovBanc,   0 , 6})
                AADD( aRotina, { "Cons. Tit. Origem *"	 ,"U_RTORINCC()"	, 0 , 6})
                AADD( aRotina, { "Cons. Tit. Compensado *"	 ,"U_RTORIABT()"	, 0 , 6})
                AADD( aRotina, { "Emissใo de Boletos *"	 ,"U_LSFIN003()"	, 0 , 6})
                AADD( aRotina, { "Instr. de cobran็a *"	 ,"FINA151()"	, 0 , 6})
                AADD( aRotina, { "Carta de cobran็a *"	 ,"U_WFFIN001()"	, 0 , 6})

Return .t.
