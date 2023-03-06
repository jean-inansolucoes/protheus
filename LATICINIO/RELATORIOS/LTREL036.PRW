#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL036  บ Autor ณMarcelo Joner       บ Data ณ  14/02/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelat๓rio de movimenta็ใo diแria de pesagens.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTREL036()

Private oReport
Private cFile		:= "LTREL036"
Private cPerg		:= "LTREL036LT"
Private cTitle		:= "Mov. Diแria de Pesagens"
Private cHelp		:= "Relat๓rio responsแvel por apresentar as principais informa็๕es เ respeito das ocorr๊ncias de pesagens."
Private cAliasTMP	:= GetNextAlias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a rotina de verifica็ใo do grupo de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
PERGUNTE(cPerg, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o objeto pertinente ao processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := REL036()
oReport:PRINTDIALOG()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณElimina tabela temporแriaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If Select(cAliasTMP) > 0
	(cAliasTMP)->(dbCloseArea())
EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL036  บAutor  ณMarcelo Joner        บ Data ณ  14/02/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo processamento das demais regras em  บฑฑ
ฑฑบ          ณtorno da execu็ใo do relat๓rio.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL036()

Local aOrdem	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o componente de processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL036PRT(oReport)}, cHelp,, "Total Filial")
oReport:SetPortrait()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)
oReport:bTotalPrint := {|| }


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de FILIALณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection1 := TRSection():New(oReport, "Filial", {"SM0"}, aOrdem)
TRCell():New(oSection1, "ZM1_FILIAL", ""   , "Filial")
TRCell():New(oSection1, "M0_FILIAL"	, "SM0", "Descri็ใo", "@!", 30,, {|| POSICIONE("SM0", 1, cEmpAnt + (cAliasTMP)->ZM1_FILIAL, "M0_FILIAL")})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de PRODUTOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection2 := TRSection():New(oSection1, "Produto", {"SB1"})
oSection2:SetLeftMargin(01)
TRCell():New(oSection2, "B1_COD"	, "SB1", "Produto",,TAMSX3("B1_COD")[1])
TRCell():New(oSection2, "B1_DESC"	, "SB1", "Descri็ใo",,50)
TRCell():New(oSection2, "TIPO"		,    "", "Tipo", "@!", 15,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", "ENTRADA", "SAIDA")})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection3 := TRSection():New(oSection2, "Pesagens", {"ZM1"})
oSection3:lHeaderVisible := .T.
oSection3:SetLeftMargin(02)
TRCell():New(oSection3, "ZM1_DATA"	, "ZM1", "Data",, 10)
TRCell():New(oSection3, "ZM1_NUM"	, "ZM1",,,06)
TRCell():New(oSection3, "ZM1_CLIFOR", "ZM1",,,TAMSX3("ZM1_CLIFOR")[1])
TRCell():New(oSection3, "ZM1_LOJA"	, "ZM1",,,TAMSX3("ZM1_LOJA")[1])
TRCell():New(oSection3, "ZM1_NOME"	, "ZM1", "Nome",,40)
TRCell():New(oSection3, "ZM1_PLACA"	, "ZM1", "Placa",,TAMSX3("ZM1_PLACA")[1])
TRCell():New(oSection3, "ZM1_NFCOM"	, "ZM1", "Nota",,TAMSX3("ZM1_NFCOM")[1])
TRCell():New(oSection3, "ZM1_SRCOM"	, "ZM1", "Serie",,TAMSX3("ZM1_SRCOM")[1])
TRCell():New(oSection3, "ZM1_DTINI"	, "ZM1", "Data")
TRCell():New(oSection3, "ZM1_HRINI"	, "ZM1", "Hora")
//TRCell():New(oSection3, "ZM1_KGINI"	, "ZM1", "Kg Entrada",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGINI, ((cAliasTMP)->ZM1_KGINI * -1))})
TRCell():New(oSection3, "ZM1_KGINI"	, "ZM1", "Kg Entrada",,,, {|| (cAliasTMP)->ZM1_KGINI})
TRCell():New(oSection3, "ZM1_DTFIN"	, "ZM1", "Data")
TRCell():New(oSection3, "ZM1_HRFIN"	, "ZM1", "Hora")
//TRCell():New(oSection3, "ZM1_KGFIN"	, "ZM1", "Kg Saํda",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGFIN, ((cAliasTMP)->ZM1_KGFIN * -1))})
//TRCell():New(oSection3, "ZM1_KGBRT"	, "ZM1", "Kg Bruto",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGBRT, ((cAliasTMP)->ZM1_KGBRT * -1))})
TRCell():New(oSection3, "ZM1_KGFIN"	, "ZM1", "Kg Saํda",,,, {|| (cAliasTMP)->ZM1_KGFIN})
TRCell():New(oSection3, "ZM1_KGBRT"	, "ZM1", "Kg Lํquido",,,, {|| (cAliasTMP)->ZM1_KGBRT})
TRCell():New(oSection3, "ZM1_STATUS", "ZM1", "Status", "@!", 12)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณTotalizador referente เ sessใo de PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oBreak1 := TRBreak():New(oSection3,{|| (cAliasTMP)->B1_COD}, "Total das Pesagens",.F.)   
TRFunction():New(oSection3:Cell("ZM1_KGINI"), "TZM1_KGINI", "SUM", oBreak1,,"@E 999,999,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_KGFIN"), "TZM1_KGFIN", "SUM", oBreak1,,"@E 999,999,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_KGBRT"), "TZM1_KGBRT", "SUM", oBreak1,,"@E 999,999,999,999.99",,.F.,.T.,.F.)

Return oReport





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL036PRT   บAutor  ณMarcelo Joner      บ Data ณ 14/02/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela execu็ใo das regras de montagem da  บฑฑ
ฑฑบ          ณquery de busca das informa็๕es\impressใo das mesmas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL036PRT(oReport)

Local cQryTip	:= ""
Local cQrySta	:= ""
Local cQueryCmp	:= "%%"
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณPrepara filtro complementar da query em rela็ใo aos TIPOS DE PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Do Case
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณApenas pesagens de entradaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	Case MV_PAR21 == 1
		cQryTip := "AND ZM1.ZM1_TIPO = '1'"
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณApenas pesagens de saํdaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	Case MV_PAR21 == 2
		cQryTip := "AND ZM1.ZM1_TIPO = '2'"
EndCase

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณPrepara filtro complementar da query em rela็ใo ao STATUS DAS PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Do Case
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณApenas pesagens EM ABERTOณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	Case MV_PAR22 == 1
		cQrySta := "AND ZM1.ZM1_STATUS = '1'"
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณApenas pesagens FINALIZADASณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	Case MV_PAR22 == 2
		cQrySta := "AND ZM1.ZM1_STATUS = '2'"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณApenas pesagens CANCELADASณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	Case MV_PAR22 == 3
		cQrySta := "AND ZM1.ZM1_STATUS = '9'"
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณApenas pesagens VมLIDASณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	Case MV_PAR22 == 4
		cQrySta := "AND ZM1.ZM1_STATUS IN ('1', '2')"
EndCase

cQueryCmp := "%" + cQryTip + cQrySta + "%"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEfetua montagem da query da sessใo de FILIAISณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
BEGIN REPORT QUERY oSection1
	BEGINSQL Alias cAliasTMP
		Column ZM1_DATA as Date
		Column ZM1_DTINI  as Date
		Column ZM1_DTFIN  as Date
		
		%noparser%
		
		SELECT DISTINCT DADOS.*
		
		FROM
			(SELECT DISTINCT ZM1.*, 
							SB1.B1_COD, 
							SB1.B1_DESC
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.%NotDel%
			  
			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.%NotDel%
			  %Exp:cQueryCmp%
			
			  
			UNION ALL
			
			
			SELECT DISTINCT ZM1.*, 
							SB1.B1_COD, 
							SB1.B1_DESC
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.%NotDel%
			  
			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.%NotDel%
			  %Exp:cQueryCmp%) DADOS
		  
		ORDER BY ZM1_FILIAL, B1_COD, ZM1_TIPO, ZM1_DATA, ZM1_NUM
		  
	EndSQL
END REPORT QUERY oSection1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณVincula เ query da primeira sessใo เ segunda sessใo e define regra de quebraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection2:SetParentQuery()
oSection2:SetParentFilter({|cParam| (cAliasTMP)->ZM1_FILIAL == cParam},{|| (cAliasTMP)->ZM1_FILIAL})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณVincula เ query da primeira sessใo เ terceira sessใo e define regra de quebraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection3:SetParentQuery()
oSection3:SetParentFilter({|cParam| (cAliasTMP)->ZM1_FILIAL + (cAliasTMP)->B1_COD + (cAliasTMP)->ZM1_TIPO == cParam},{|| (cAliasTMP)->ZM1_FILIAL + (cAliasTMP)->B1_COD + (cAliasTMP)->ZM1_TIPO})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณSeta regra de contador do processamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a impressใo das sess๕es do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection1:Print()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณSCHEDDEF  บAutor  ณMarcelo Joner      บ Data ณ  14/02/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por disponibilizar a utiliza็ใo do rela- บฑฑ
ฑฑบ          ณt๓rio na funcionalidade de Schedule.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SCHEDDEF()

Local aParam

aParam := {"R", "LTREL036LT", "", {}, "Mov. Diแria de Pesagens"}

Return aParam