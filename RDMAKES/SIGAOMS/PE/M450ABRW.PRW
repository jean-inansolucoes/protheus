#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ M450ABRW   บAutor  ณLincoln Rossetto    บ Data ณ  09/01/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro libera็ใo cr้dito por clientes - 					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M450ABRW()
***********************                     

Local cQuery := PARAMIXB[1]

// Essa query ira verificar os clientes bloqueados tratando o campo C9_BLCRED = '10' e o campo A1_X_FUNC != ""

cQuery := "SELECT SC9.C9_CLIENTE,SC9.C9_LOJA,SA1.A1_COD   , SA1.A1_LOJA   ,SA1.A1_NOME    , 	"
cQuery += "SA1.A1_NREDUZ  ,SA1.A1_TIPO    ,SA1.A1_DDI     ,SA1.A1_REGIAO  ,SA1.A1_ABICS   , 	"
cQuery += "SA1.A1_DTINIV  ,SA1.A1_DTFIMV  ,SA1.A1_SIMPLES ,SA1.A1_CODSIAF ,SA1.A1_CTARE   , 	"
cQuery += "SA1.A1_TDA     ,SA1.A1_RECIRRF ,SC5.C5_FILIAL  ,SC5.C5_NUM     		  , 	"
cQuery += "SC5.C5_CLIENTE ,SC5.C5_LOJACLI ,SC5.C5_CLIENT  ,SC5.C5_LOJAENT ,SC5.C5_PEDEXP  , 	"
cQuery += "SC5.C5_MOEDA,SC9.C9_PEDIDO,SC9.C9_PRCVEN,SC9.C9_QTDLIB,SA1.A1_MOEDALC 	    	"
cQuery += "FROM SC9010 SC9, SA1010 SA1, SC5010 SC5  					    	"
cQuery += "WHERE  SC9.D_E_L_E_T_=' ' AND SA1.A1_FILIAL='  ' AND SA1.A1_COD = SC9.C9_CLIENTE 	"
cQuery += "AND SA1.A1_LOJA = SC9.C9_LOJA AND SA1.D_E_L_E_T_=' ' AND SC5.C5_FILIAL=SC9.C9_FILIAL	"
cQuery += "AND SC5.C5_NUM=SC9.C9_PEDIDO AND SC5.D_E_L_E_T_=' ' AND SC9.C9_BLCRED <> '10' AND SA1.A1_X_FUNC <> ' '"

Return cQuery