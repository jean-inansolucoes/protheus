#INCLUDE "PROTHEUS.CH"


User Function TabelaFin()

Local aCampos		:= {		{"CODIGO   ","C",50 ,0},;
								{"VALOR ","N",17,2},;
								{"TESTE","C",50,0}}   
Local cArqTmp	:= CriaTrab(aCampos) 
Local cFiltro	:=""
Local cIndTmp 	:= ""
Local nx		:= 1
Local cCod		:= "000001"

Private cPeriodo	:= '02/04/2013'

cFiltro	:="Alltrim(cPeriodo)=='02/04/2013'" // "'02/04/2013'=='02/04/2013'"

dbUseArea(.T.,__LocalDriver,cArqTmp,"TMP",.F.,.F.)

DbSelectArea("TMP")

For nx := 1 To 10
	RecLock("TMP",.T.)
	CODIGO := cCod
	VALOR  := nx
	TESTE  := "GRAVACAO NUMERO " + Alltrim(Str(nx)) 
	MsUnlock()
	cCod := Soma1(Alltrim(CODIGO))
Next nx

//cFiltro := "VALOR>7"
cIndTmp := CriaTrab(,.F.)
IndRegua("TMP",cIndTmp,"CODIGO+TESTE",,"")

Set Filter To &cFiltro

dbGotop()

DbCloseArea()
FErase (cIndTmp+OrdBagExt())


Return Nil