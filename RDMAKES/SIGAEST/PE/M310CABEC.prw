
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?M310CABEC ?Autor  ?Joel Lipnharski     ? Data ?  10/13/11   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Gravacao de data de entraga no Pedido de Vendas            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Transfer?ncia entre filiais - MATA310                      ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/


User Function M310CABEC()

Local cProg := PARAMIXB[1] 
Local aCabec := PARAMIXB[2]

If cProg == 'MATA410'   
	aadd(aCabec,{'C5_FECENT',DDATABASE,Nil}) 
Endif

Return(aCabec)