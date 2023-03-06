#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240FIL   �Autor  �Jefferson Mittanck  � Data �  29/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para filtrar os t�tulos na gera��o do     ���
���          � Border� a pagar                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LATICINIO SILVESTRE                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

**------------------------**
User Function F240FIL()
**------------------------**

Local _cFiltro	:= ""
Local _cBcod	:= SE2->E2_X_BCODP
Local _cAgend	:= SE2->E2_X_AGDEP
Local _cContad	:= SE2->E2_X_CTADP
Local cFpgto	:= POSICIONE( "SA2" , 1 , XFILIAL( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, "SA2->A2_X_FPGTO")   // C = Cheque, D = Deposito

If cModPgto $ "01" 	// Filtra t�tulos para bordero de pagamento com Transfer�ncia entre C/C Produtores

	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ = '20101001' .and. E2_X_BCODP = '" + CPORT240 + "'"

ElseIf cModPgto $ "02"	// Filtra t�tulos para bordero de pagamento com trasferencia Fornecedores

  	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ != '20101001' .and. E2_X_BCODP = '" + CPORT240 + "'"
  
ElseIf cModPgto $ "03"	// Filtra t�tulos para bordero de pagamento com TED / DOC Produtores

  	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ = '20101001' .and. E2_X_BCODP != '" + CPORT240 + "'"
	
ElseIf cModPgto $ "41"	// Filtra t�tulos para bordero de pagamento com TED / DOC Fornecedores

  	_cFiltro := "!EMPTY(E2_X_BCODP) .and. !EMPTY(E2_X_AGDEP) .and. !EMPTY(E2_X_CTADP) .and. !EMPTY(E2_X_FAVDP) .and. !EMPTY(E2_X_TPPSD) .and. !EMPTY(E2_X_CGCDP) .and. E2_NATUREZ != '20101001' .and. E2_X_BCODP != '" + CPORT240 + "'"
  	
ElseIf cModPgto $ "30/31"  // Filtra t�tulos para Bordero de pagamento de t�tulos com c�digo de barras
	
	_cFiltro := "!EMPTY(E2_CODBAR) .and. (Substr(E2_CODBAR,1,1) <> '8' )"	
	
ElseIf cModPgto $ "13/16"  // Filtra t�tulos para Bordero de pagamento de CONCESSIONARIAS / DARF(com c�digo de barras)
	
	_cFiltro := "!EMPTY(E2_CODBAR) .and. (Substr(E2_CODBAR,1,1) == '8' )"
	
Endif

Return _cFiltro