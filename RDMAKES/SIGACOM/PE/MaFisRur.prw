/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAFISRUR  ºAutor  ³Rafael Parma        º Data ³  07/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao na aliquota FUNRURAL                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Array com dados da Operação com 8 elementos 
[1] = TES; 
[2] = PRODUTO; 
[3] = C se CLIENTE e F se FORNECEDOR; 
[4] = S se SAIDA ou E se ENTRADA; 
[5] = CODIGO CLIENTE/FORNECEDOR; 
[6] = LOJA CLIENTE/FORNECEDOR; 
[7] = TIPO DA PESSOA; 
[8] = ALIQUOTA DO FUNRURAL APLICADA NA OPERAÇÃO PELO SISTEMA 
*/              

*------------------------------*
User Function MaFisRur()
*------------------------------*                  
Local aParam   := PARAMIXB                  
Local nAlqRur  := aParam[8]
Local aArea    := GetArea()   

If aParam[3] == "F"
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("SA2")+aParam[5]+aParam[6] )
		If SA2->A2_X_PCONT > 0
			nAlqRur := SA2->A2_X_PCONT
		EndIf
	EndIf
EndIf


RestArea(aArea)

Return (nAlqRur)