#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "PROTHEUS.CH"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?Ma440VLD  ?Autor   ?Alexandre Longhinotti  ?Data ? 23/09/11 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Bloqueia o pedido de venda caso a o valor do desconto seja ???
???          ? seja superior ao limite do usu?rio 						  ???
???          ? 														      ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? OMS                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User function Ma440VLD()
************************
Local iRet 			:= .T.
	
U_M440STTS()

Return( iRet )	
