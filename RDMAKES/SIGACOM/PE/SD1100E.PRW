#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBINFO.CH"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?SD1100E   ?Autor  ?               o   ? Data ?  08/12/2021  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?  Ponto de Entrada  chamado na exclus?o de cada item do     ???
v???          ? Documento de entrada.                                     ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? ESPECIFICO LAT SILVESTRE                                   ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function SD1100E()

//????????????????????????????????????????????????????????Ŀ
//? Chama programa para verificar necessidade de Estorno   ?
//? de Movimento Interno de Qtde e Valores dos Itens da NF ?
//? referente aos lan?amentos de Pesagem ZM1.              ?
//??????????????????????????????????????????????????????????
U_LSEST06()
 
Return
