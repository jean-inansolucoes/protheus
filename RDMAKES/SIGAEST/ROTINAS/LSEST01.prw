/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSEST01   ºAutor  ³Joel Lipnharski     º Data ³  12/15/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro utilizado na consulta padrao CT1SD3, campo D3_CONTA º±±
±±º          ³ se o tipo de movimentacao for de saida ( > 500 ) mostra    º±±
±±º          ³ somente as contas com inicio 4 (DESPESAS).                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LSEST01()

Local _cFiltro := ""
Local _cTM     := ""

If ( ISINCALLSTACK("MATA185") .AND. ISINCALLSTACK("A241INCLUI") ) .OR. ISINCALLSTACK("MATA241")
	_cFiltro := IIF((VAL(ALLTRIM(CTM)) >= 500),SUBSTR(CT1->CT1_CONTA,1,1) $ "4/5",VAL(ALLTRIM(CT1->CT1_CONTA))>0)
ElseIf ( ISINCALLSTACK("MATA185") .AND. ISINCALLSTACK("A240INCLUI") ) .OR. ISINCALLSTACK("MATA240")
	_cFiltro := IIF((VAL(ALLTRIM(M->D3_TM)) >= 500),SUBSTR(CT1->CT1_CONTA,1,1) $ "4/5",VAL(ALLTRIM(CT1->CT1_CONTA))>0)
Else
	_cFiltro := VAL(ALLTRIM(CT1->CT1_CONTA))>0
EndIf

Return(_cFiltro)