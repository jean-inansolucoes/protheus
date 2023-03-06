#INCLUDE 'PROTHEUS.CH'
#INCLUDE "PONCALEN.CH"
#include "rwmake.ch"
#include "topconn.ch"


//--------------------------------------------------------------------------
// Programa: COMPHORAS  	Autor: TOTVS CASCAVEL 			Data: 30/05/2019
// Desc....: Rotina para compensar o Banco de Horas - SIGAPON.
// Uso.....: SILVESTRE
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
User Function CompHoras()
//_-------------------------------------------------------------------------


Private cPerg := "XCOMPHOR"
ValidPerg()
Pergunte(cPerg,.T.)
Processa({|| RunComp() },"Processando...")
Return
Static Function RunComp()
If MSGBOX("Será iniciado agora o processo de compensação de horas. Deseja continuar?","Compensação de horas","YESNO")
	cProv := MV_PAR05
	cDesc := MV_PAR06
	cQuery := " SELECT * FROM "
	cQuery += RETSQLNAME("SPB")
	cQuery += " WHERE PB_PD = '"+cDesc+"' " //VERBA DE DESCONTO
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " AND PB_FILIAL >= '" + MV_PAR01 + "' "
	cQuery += " AND PB_FILIAL <= '" + MV_PAR02 + "' "
	cQuery += " AND PB_MAT >= '" + MV_PAR03 + "' "
	cQuery += " AND PB_MAT <= '" + MV_PAR04 + "' "
	cQuery += " AND PB_DATA >= '" + DTOS(MV_PAR07) + "' "
	cQuery += " AND PB_DATA <= '" + DTOS(MV_PAR08) + "' "
	TCQUERY cQuery NEW ALIAS "QSPB"
	dbSelectArea("QSPB")
	dbgoTop()
	ProcRegua(RecCount()) // Numero de registros a processar
	While !EOF()
		IncProc("Processando Matricula: "+QSPB->PB_FILIAL +"/"+QSPB->PB_MAT)
		nHorDesc := QSPB->PB_HORAS //HORAS DE DESCONTO
		nRecDesc := QSPB->R_E_C_N_O_
		cQuery := " SELECT * FROM "
		cQuery += RETSQLNAME("SPB")
		cQuery += " WHERE PB_PD = '"+cProv+"' "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		cQuery += " AND PB_FILIAL = '"+QSPB->PB_FILIAL+"' "
		cQuery += " AND PB_MAT = '"+QSPB->PB_MAT+"' "
		cQuery += " AND PB_DATA >= '" + DTOS(MV_PAR07) + "' "
		cQuery += " AND PB_DATA <= '" + DTOS(MV_PAR08) + "' "
		TCQUERY cQuery NEW ALIAS "QSPB1"
		nHorProv := QSPB1->PB_HORAS //HORAS PROVENTOS
		nRecProv := QSPB1->R_E_C_N_O_
		QSPB1->(DbCloseArea())
		If nHorDesc > nHorProv
			cVerba := "076"
			nHoras := nHorDesc - nHorProv
			nRec := nRecDesc
			nRecDel := CVALTOCHAR(nRecProv)
		ElseIf nHorProv > nHorDesc
			cVerba := "441"
			nHoras := nHorProv - nHorDesc
			nRec := nRecProv
			nRecDel := CVALTOCHAR(nRecDesc)
		Else
			nHoras := 0
			nRec := 0
			nRecDel := cvaltochar(nRecDesc) + "','" + cvaltochar(nRecProv)
		EndIf
		cSql := " UPDATE "
		cSql += RETSQLNAME("SPB")
		cSql += " SET PB_HORAS = " + CVALTOCHAR(nHoras)
		cSql += " WHERE R_E_C_N_O_ = " + CVALTOCHAR(nRec)
		TcSqlExec(cSql)
		cSql := " DELETE FROM "
		cSql += RETSQLNAME("SPB")
		cSql += " WHERE R_E_C_N_O_ IN ('" + nRecDel + "') "
		TcSqlExec(cSql)
		dbSelectArea("QSPB")
		dbSkip()
	EndDo
	QSPB->(DbCloseArea())
	MsgBox("Processo concluído com sucesso!","Ok","INFO")
EndIf
Return
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs := {}
AADD(aRegs,{cPerg,"01","Filial de ?",Space(20),Space(20),"mv_ch1","C",07,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SMO","","","","","","",""})
AADD(aRegs,{cPerg,"02","Filial ate ?",Space(20),Space(20),"mv_ch2","C",07,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SMO","","","","","","",""})
AADD(aRegs,{cPerg,"03","Matricula de ?",Space(20),Space(20),"mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","","","",""})
AADD(aRegs,{cPerg,"04","Matricula ate ?",Space(20),Space(20),"mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","","","",""})
AADD(aRegs,{cPerg,"05","Verba Provento ?",Space(20),Space(20),"mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRV","","","","","","",""})
AADD(aRegs,{cPerg,"06","Verba Desconto ?",Space(20),Space(20),"mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRV","","","","","","",""})
AADD(aRegs,{cPerg,"07","Data Pagto de ?",Space(20),Space(20),"mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Data Pagto até ?",Space(20),Space(20),"mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next
dbSelectArea(_sAlias)
Return
