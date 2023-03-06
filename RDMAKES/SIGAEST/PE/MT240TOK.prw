/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT241TOK  ºAutor  ³Joel Lipnharski     º Data ³  12/15/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao de preenchimento dos campos Centro de Custo e    º±±
±±º          ³ Conta Contabil na baixa de pre-requisicao ao armazem       º±±
±±º          ³ mod1., ou movimentacao interna mod1.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT240TOK()

Local _lRet    := .T.  
Local _cProdL  := ALLTRIM(GETMV("MV_ZLTPRD")) //Produto modulo Laticinio
Local _cTM     := ALLTRIM(GETMV("MV_TMOBRIG")) //Tipos de Movimentacao de estoque em que nao sera validado Centro de Custo e Conta Contabil

If ISINCALLSTACK("MATA240")

	If ( ALLTRIM(M->D3_COD) # _cProdL ) .AND. ( Empty( M->D3_CONTA ) .OR. Empty( M->D3_CC ) ) .AND. !( M->D3_TM $ _cTM) 
		_lRet := .F. 
		Aviso("Atenção","Favor revisar o preenchimento dos campos: Centro de Custo e Conta Contabil.",{"OK"},2)	
	ElseIf ( M->D3_TM $ _cTM ) .AND. !Empty( M->D3_CONTA)
		M->D3_CONTA := ""
	EndIf

EndIf 

Return(_lRet)
