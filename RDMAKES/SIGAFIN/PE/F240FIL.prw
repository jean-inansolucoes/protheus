#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F240FIL   ºAutor  ³Jefferson Mittanck  º Data ³  29/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para filtrar os títulos na geração do     º±±
±±º          ³ Borderô a pagar                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LATICINIO SILVESTRE                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

**------------------------**
User Function F240FIL()
**------------------------**

Local _cFiltro	:= ""
Local _cBcod	:= SE2->E2_X_BCODP
Local _cAgend	:= SE2->E2_X_AGDEP
Local _cContad	:= SE2->E2_X_CTADP
Local cFpgto	:= POSICIONE( "SA2" , 1 , XFILIAL( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, "SA2->A2_X_FPGTO")   // C = Cheque, D = Deposito

If cModPgto $ "01" 	// Filtra títulos para bordero de pagamento com Transferência entre C/C Produtores

	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ = '20101001' .and. E2_X_BCODP = '" + CPORT240 + "'"

ElseIf cModPgto $ "02"	// Filtra títulos para bordero de pagamento com trasferencia Fornecedores

  	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ != '20101001' .and. E2_X_BCODP = '" + CPORT240 + "'"
  
ElseIf cModPgto $ "03"	// Filtra títulos para bordero de pagamento com TED / DOC Produtores

  	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ = '20101001' .and. E2_X_BCODP != '" + CPORT240 + "'"
	
ElseIf cModPgto $ "41"	// Filtra títulos para bordero de pagamento com TED / DOC Fornecedores

  	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ != '20101001' .and. E2_X_BCODP != '" + CPORT240 + "'"
  	
ElseIf cModPgto $ "30/31"  // Filtra títulos para Bordero de pagamento de títulos com código de barras
	
	_cFiltro := "!EMPTY(E2_CODBAR) .and. (Substr(E2_CODBAR,1,1) <> '8' )"	
	
ElseIf cModPgto $ "13/16"  // Filtra títulos para Bordero de pagamento de CONCESSIONARIAS / DARF(com código de barras)
	
	_cFiltro := "!EMPTY(E2_CODBAR) .and. (Substr(E2_CODBAR,1,1) == '8' )"
	
Endif

Return _cFiltro