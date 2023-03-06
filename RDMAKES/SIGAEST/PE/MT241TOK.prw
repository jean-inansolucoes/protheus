/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT241TOK  บAutor  ณJoel Lipnharski     บ Data ณ  12/15/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao de preenchimento dos campos Centro de Custo e    บฑฑ
ฑฑบ          ณ Conta Contabil na baixa de pre-requisicao ao armazem       บฑฑ
ฑฑบ          ณ mod2, ou movimentacao interna mod2.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT241TOK()

Local lRet     := .T.
Local nPosConta := aScan(aHeader,{|x| AllTrim(x[2])=="D3_CONTA"})
Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=="D3_COD"})   
//Local nPosXDoc  := aScan(aHeader,{|x| AllTrim(x[2])=="D3_X_DOC"})   
Local cProdL   := ALLTRIM(GETMV("MV_ZLTPRD")) //Produto modulo Laticinio 
Local _cTM     := ALLTRIM(GETMV("MV_TMOBRIG")) //Tipos de Movimentacao de estoque em que nao sera validado Centro de Custo e Conta Contabil
Local i

If ISINCALLSTACK("MATA241")
	
	For i := 1 to len(acols)
		
		If (ALLTRIM(acols[i][nPosProd]) # cProdL) .AND. ( Empty(acols[i][nPosConta]) .OR. Empty(CCC) ) .AND. !( CTM $ _cTM )
			lRet := .F. 
			Aviso("Aten็ใo","Favor revisar o preenchimento dos campos: Centro de Custo e Conta Contabil.",{"OK"},2)			
			Exit
		ElseIf ( CTM $ _cTM ) .AND. !Empty(acols[i][nPosConta])
			acols[i][nPosConta] := ""
		EndIf
		
	Next i 

EndIf

Return(lRet)
