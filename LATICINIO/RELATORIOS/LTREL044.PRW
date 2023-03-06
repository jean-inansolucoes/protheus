#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL044  บ Autor ณMarcelo Joner       บ Data ณ  06/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelat๓rio de Fechamento Mov. Soro In Natura.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTREL044()

Private oReport
Private cFile		:= "LTREL044"
Private cPerg		:= "LTREL040LT"
Private cTitle		:= "Pesagens - Fechamento"
Private cHelp		:= "Relat๓rio responsแvel por apresentar as principais informa็๕es เ respeito das ocorr๊ncias de movimenta็๕es de pesagens de cargas de mat้rias-primas."
Private cAliasTMP	:= GetNextAlias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a rotina de verifica็ใo do grupo de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
PERGUNTE(cPerg, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o objeto pertinente ao processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := REL044()
oReport:PRINTDIALOG()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณElimina tabelas temporแriasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If Select(cAliasTMP) > 0
	(cAliasTMP)->(dbCloseArea())
EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL044  บAutor  ณMarcelo Joner        บ Data ณ  06/05/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo processamento das demais regras em  บฑฑ
ฑฑบ          ณtorno da execu็ใo do relat๓rio.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL044()

Local aOrdem	:= {}
Local _aCaract := {}
Local _cQry := ''
Local _cRevisa := ''
Local _nX := 0

If Select("TMPX") > 0
    TMPX->(dbCloseArea())
EndIf

_cQry := " SELECT MAX(ZA1_REVISA) AS ZA1_REVISA FROM ZA1010 WHERE ZA1_PROD = '01010004' AND D_E_L_E_T_ = ' ' "

TcQuery _cQry New Alias 'TMPX'

_cRevisa := TMPX->ZA1_REVISA

dbSelectArea("ZA1")
ZA1->(dbSetOrder(2))
ZA1->(dbGoTop())
ZA1->(dbSeek(xFilial('ZA1')+'01010004                      '+_cRevisa))
While ZA1->(!EOF()) .AND. ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA == xFilial('ZA1')+'01010004                      '+_cRevisa
    aAdd(_aCaract,{ZA1->ZA1_CARACT, ZA1->ZA1_TIPO, ZA1->ZA1_DESCR})
    ZA1->(dbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o componente de processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL044PRT(oReport)}, cHelp,, "Total Filial")
oReport:SetLandscape()
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
oSection2:SetLeftMargin(02)
TRCell():New(oSection2, "B1_COD"	, "SB1", "Produto",,TAMSX3("B1_COD")[1])
TRCell():New(oSection2, "B1_DESC"	, "SB1", "Descri็ใo",,50)
TRCell():New(oSection2, "TIPO"		,    "", "Tipo", "@!", 15,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", "ENTRADA", "SAIDA")})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection3 := TRSection():New(oSection2, "Pesagens", {"ZM1"})
oSection3:lHeaderVisible := .F.
oSection3:SetLeftMargin(04)
TRCell():New(oSection3, "ZM1_NUM"	, "ZM1",,,06)
TRCell():New(oSection3, "ZM1_CLIFOR", "ZM1",,,TAMSX3("ZM1_CLIFOR")[1])
TRCell():New(oSection3, "ZM1_LOJA"	, "ZM1",,,TAMSX3("ZM1_LOJA")[1])
TRCell():New(oSection3, "ZM1_NOME"	, "ZM1", "Nome",,30)
TRCell():New(oSection3, "ZM1_DTINI"	, "ZM1", "Data Receb")
TRCell():New(oSection3, "ZM1_HRINI"	, "ZM1", "Hora")
TRCell():New(oSection3, "ZM1_NFCOM"	, "ZM1", "Nota")
TRCell():New(oSection3, "ZM1_SRCOM"	, "ZM1", "S้rie")
TRCell():New(oSection3, "F1_EMISSAO", "SF1", "Emis. NF")
TRCell():New(oSection3, "ZM1_KGBRT"	, "ZM1", "Kg Lํquido")
TRCell():New(oSection3, "ZM1_LTBRT" , "ZM1", "Lt Lํquido")
TRCell():New(oSection3, "ZM1_LTNOTA", "ZM1", "Lt Nota")
TRCell():New(oSection3, "ZM1_LTDIF" , "ZM1", "Lt Dif.")
TRCell():New(oSection3, "QTDANA"    ,    "", "Tanques", "@E 99", 2)



/* TRCell():New(oSection3, "ZM3_QLD004",    "", "Acidez",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD004", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD007",    "", "Gordura",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD007", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD008",    "", "Densidade",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD008", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM1_QLD022", "ZM1", "ST Brix", "@E 99.9", 3)
TRCell():New(oSection3, "ZM3_QLD003",    "", "Temperatura",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD003", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD005",    "", "Ph",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD005", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD023",    "", "Antibi๓tico",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD023")})
TRCell():New(oSection3, "ZM3_QLD013",    "", "Alizarol",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD013", (cAliasTMP)->QTDANA)})
 */
/* For _nX := 1 To Len(_aCaract)
    If _aCaract[_nX,2] == 'T'
        _cTipo := 'C'
        _nTam1 := 10
        _nTam2 := 0
    Else
        _cTipo := 'N'
        _nTam1 := 12
        _nTam2 := 4
    EndIf
   
    _cCaract := _aCaract[_nX,1]
    TRCell():New(oSection3, "TRB_"+_aCaract[_nX,1],    "", _aCaract[_nX,3],,,, {|oReport| REL40INF(oReport,(cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM,   _cCaract , (cAliasTMP)->QTDANA)})
Next _nX */


TRCell():New(oSection3, "ZM1_SLKG"  , "ZM1", "S๓l. Kg")
TRCell():New(oSection3, "ZM1_SLLT"  , "ZM1", "S๓l. Lt")
oSection3:aCell[15]:Disable()
oSection3:aCell[16]:Disable() 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณTotalizador referente เ sessใo de PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oBreak1 := TRBreak():New(oSection3,{|| (cAliasTMP)->B1_COD + (cAliasTMP)->ZM1_TIPO}, "Totais",.F.)   
oBreak1:lHeaderPage := .F.



If MV_PAR26 == 2
    oSection4 := TRSection():New(oSection3, "M้dia Anแlises", {"ZM5"})
    oSection4:lHeaderVisible := .F.
    oSection4:SetLeftMargin(05)

    TRCell():New(oSection4, "ZM5_CARACT" , "ZM5", "Anแlise")
    TRCell():New(oSection4, "ZM5_DESCR"  , "ZM5", "Descri็ใo")
    TRCell():New(oSection4, "ZM5_VALOR"  ,    "", "Valor",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, (cAliasTMP)->ZM5_CARACT, (cAliasTMP)->QTDANA)})
    TRCell():New(oSection4, "ZM5_DESCTX" ,    "", "Medi็ใo",,,, {|| REL40INF2((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, (cAliasTMP)->ZM5_CARACT, (cAliasTMP)->QTDANA)})
EndIf
TRFunction():New(oSection3:Cell("ZM1_KGBRT") , "TZM1_KGBRT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_LTBRT") , "TZM1_LTBRT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_LTNOTA"), "TZM1_LTNOTA", "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_LTDIF") , "TZM1_LTDIF"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
/* TRFunction():New(oSection3:Cell("ZM3_QLD004"), "TZM3_QLD004", "AVERAGE"	, oBreak1,,"@E 999",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD007"), "TZM3_QLD007", "AVERAGE"	, oBreak1,,"@E 999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD008"), "TZM3_QLD008", "AVERAGE"	, oBreak1,,"@E 9999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_QLD022"), "TZM1_QLD022", "AVERAGE"	, oBreak1,,"@E 99.9",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD003"), "TZM3_QLD003", "AVERAGE"	, oBreak1,,"@E 999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD005"), "TZM3_QLD005", "AVERAGE"	, oBreak1,,"@E 999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD013"), "TZM3_QLD013", "AVERAGE"	, oBreak1,,"@E 999",,.F.,.T.,.F.) */


TRFunction():New(oSection3:Cell("ZM1_SLKG")	 , "TZM1_SLKG"	, "AVERAGE"	, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_SLLT")	 , "TZM1_SLKG"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
//TRFunction():New(oSection3:Cell("ZM5_VALOR") , "TZM5_VALOR"	, "AVERAGE"	, oBreak2,,"@E 99,999.9999",,.F.,.T.,.F.)

Return oReport





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL044PRT   บAutor  ณMarcelo Joner      บ Data ณ 06/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela execu็ใo das regras de montagem da  บฑฑ
ฑฑบ          ณquery de busca das informa็๕es\impressใo das mesmas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL044PRT(oReport)

Local nI		:= 0
Local nY		:= 0
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)
Local oSection4
If MV_PAR26 == 2
    oSection4	:= oReport:Section(1):Section(1):Section(1):Section(1)
EndIf

If MV_PAR25 != 4
		cQryTpNota := "%AND ZM1.ZM1_TPNOTA = '" + ALLTRIM(STR(MV_PAR25)) + "'%"
Else
		cQryTpNota := "%AND ZM1.ZM1_TPNOTA >= '1' AND ZM1.ZM1_TPNOTA <= '4' %" 
EndIf

//oSection4:Disable()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณConsulta SQL quando trata-se de Pesagens de SAIDAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If MV_PAR22 == 2
	BEGIN REPORT QUERY oSection1
		BEGINSQL Alias cAliasTMP
			Column ZM1_DATA   as Date
			Column ZM1_DTINI  as Date
			Column ZM1_DTFIN  as Date
			
			%noparser%
			
		
			
			SELECT DISTINCT DADOS.* 
	
			FROM 
			
			(SELECT DISTINCT ZM1.*, 
			                 SB1.B1_COD, 
			                 SB1.B1_DESC,
			                 (SELECT COUNT(ZM5.ZM5_NUM)
			                    FROM %Table:ZM5% ZM5
			                   WHERE ZM3.ZM5_FILIAL  = ZM1.ZM1_FILIAL
			                     AND ZM3.ZM5_NUM     = ZM1.ZM1_NUM
			                     AND ZM5.ZM5_STATUS <> 'V'
			                     AND ZM5.D_E_L_E_T_ <> '*') QTDANA
			
			    FROM  %Table:SB1% SB1,  
			          %Table:ZM1% ZM1 
			 
			  WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			    AND SB1.B1_COD       = ZM1.ZM1_PRODธ
			    AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			    AND SB1.B1_X_TPANA   = '2'
			    AND SB1.%NotDel%
			  
			    AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			    AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			    AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			    AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			    AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			    AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			    AND ZM1.ZM1_DATA	>= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			    AND ZM1.ZM1_SRCON	>= %Exp:MV_PAR23% AND ZM1.ZM1_SRCON   <= %Exp:MV_PAR24%
			    AND ZM1.ZM1_TIPO     = '2'
				%Exp:cQryTpNota%
			    AND ZM1.%NotDel%)DADOS 
			  
			  ORDER BY ZM1_FILIAL, B1_COD, ZM1_TIPO, ZM1_DATA, ZM1_NUM
			  			  
		EndSQL
	END REPORT QUERY oSection1

ElseIf MV_PAR26 == 2

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณConsulta SQL quando trata-se de Pesagens de ENTRADAณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	BEGIN REPORT QUERY oSection1
		BEGINSQL Alias cAliasTMP
			Column ZM1_DATA   as Date
			Column ZM1_DTINI  as Date
			Column ZM1_DTFIN  as Date
			
			%noparser%
			
			SELECT DISTINCT DADOS.* 
		
			FROM 
			
			(SELECT DISTINCT ZM1.*, 
                             ZM5_NUM,
                             ZM5_CARACT,
                             ZM5_DESCR,
                             ZM5_VALOR,
                             ZM5_TEXTO,
			                 SB1.B1_COD, 
			                 SB1.B1_DESC,
			                 SF1.F1_EMISSAO,
			                 (SELECT COUNT(ZM4.ZM4_NUM)
			                    FROM %Table:ZM4% ZM4
			                   WHERE ZM4.ZM4_FILIAL  = ZM1.ZM1_FILIAL
			                     AND ZM4.ZM4_NUM     = ZM1.ZM1_NUM
			                     AND ZM4.ZM4_STATUS <> 'V'
			                     AND ZM4.D_E_L_E_T_ <> '*') QTDANA
			
			    FROM  %Table:SB1% SB1,  
			          %Table:ZM1% ZM1,
			          %Table:SF1% SF1,
			          %Table:ZM5% ZM5
			 
			  WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			    AND SB1.B1_COD       = ZM1.ZM1_PROD
			    AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			    AND SB1.B1_X_TPANA   = '2'
			    AND SB1.%NotDel%
			  
			    AND SF1.F1_FILIAL    = %xFilial:SF1%
			    AND SF1.F1_DOC       = ZM1.ZM1_NFCOM
			    AND SF1.F1_SERIE     = ZM1.ZM1_SRCOM
			    AND SF1.F1_FORNECE   = ZM1.ZM1_CLIFOR
			    AND SF1.F1_LOJA      = ZM1.ZM1_LOJA
			    AND SF1.%NotDel%
			    
			    AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			    AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			    AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			    AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			    AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			    AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			    AND ZM1.ZM1_DATA	>= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			    AND ZM1.ZM1_SRCOM	>= %Exp:MV_PAR23% AND ZM1.ZM1_SRCOM   <= %Exp:MV_PAR24%
			    AND ZM1.ZM1_TIPO     = '1'
				%Exp:cQryTpNota%
			    AND ZM1.%NotDel%
                
                AND ZM5.ZM5_FILIAL  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			    AND ZM5.ZM5_NUM = ZM1_NUM
                AND ZM5.D_E_L_E_T_ <> '*'
                

                )DADOS 
			  
                

			  ORDER BY ZM1_FILIAL, B1_COD, ZM1_TIPO, ZM1_DATA, ZM1_NUM
			  
		EndSQL
	END REPORT QUERY oSection1
Else

    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณConsulta SQL quando trata-se de Pesagens de ENTRADAณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	BEGIN REPORT QUERY oSection1
		BEGINSQL Alias cAliasTMP
			Column ZM1_DATA   as Date
			Column ZM1_DTINI  as Date
			Column ZM1_DTFIN  as Date
			
			%noparser%
			
			SELECT DISTINCT DADOS.* 
		
			FROM 
			
			(SELECT DISTINCT ZM1.*,
			                 SB1.B1_COD, 
			                 SB1.B1_DESC,
			                 SF1.F1_EMISSAO,
			                 (SELECT COUNT(ZM4.ZM4_NUM)
			                    FROM %Table:ZM4% ZM4
			                   WHERE ZM4.ZM4_FILIAL  = ZM1.ZM1_FILIAL
			                     AND ZM4.ZM4_NUM     = ZM1.ZM1_NUM
			                     AND ZM4.ZM4_STATUS <> 'V'
			                     AND ZM4.D_E_L_E_T_ <> '*') QTDANA
			
			    FROM  %Table:SB1% SB1,  
			          %Table:ZM1% ZM1,
			          %Table:SF1% SF1
			 
			  WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			    AND SB1.B1_COD       = ZM1.ZM1_PROD
			    AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			    AND SB1.B1_X_TPANA   = '2'
			    AND SB1.%NotDel%
			  
			    AND SF1.F1_FILIAL    = %xFilial:SF1%
			    AND SF1.F1_DOC       = ZM1.ZM1_NFCOM
			    AND SF1.F1_SERIE     = ZM1.ZM1_SRCOM
			    AND SF1.F1_FORNECE   = ZM1.ZM1_CLIFOR
			    AND SF1.F1_LOJA      = ZM1.ZM1_LOJA
			    AND SF1.%NotDel%
			    
			    AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			    AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			    AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			    AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			    AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			    AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			    AND ZM1.ZM1_DATA	>= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			    AND ZM1.ZM1_SRCOM	>= %Exp:MV_PAR23% AND ZM1.ZM1_SRCOM   <= %Exp:MV_PAR24%
			    AND ZM1.ZM1_TIPO     = '1'
				%Exp:cQryTpNota%
			    AND ZM1.%NotDel%
                
                

                )DADOS 
			  
                

			  ORDER BY ZM1_FILIAL, B1_COD, ZM1_TIPO, ZM1_DATA, ZM1_NUM
			  
		EndSQL
	END REPORT QUERY oSection1
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณHavilita c้lula referente hแ S๓lidos conforme parโmetro definido pelo usuแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If MV_PAR21 == 1
	oSection3:aCell[15]:Enable()
Else
	oSection3:aCell[16]:Enable()
EndIf

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณVincula เ query da primeira sessใo เ terceira sessใo e define regra de quebraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If MV_PAR26 == 2
    oSection4:SetParentQuery()
    oSection4:SetParentFilter({|cParam| (cAliasTMP)->ZM1_FILIAL + (cAliasTMP)->ZM5_NUM == cParam},{|| (cAliasTMP)->ZM1_FILIAL + (cAliasTMP)->ZM1_NUM})
EndIf

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
ฑฑบPrograma  ณREL40INF  บAutor  ณMarcelo Joner        บ Data ณ 06/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por retornar o valor m้dio da anแlise de บฑฑ
ฑฑบ          ณqualidade da Pesagem conforme o campo repassado por parโme- บฑฑ
ฑฑบ          ณtro.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL40INF( cCodFil, cCodPes, _cAnalise, nQtdAna)

Local xRet			:= 0
Local _cTipo      := Posicione('ZA3',1,xFilial('ZA3')+_cAnalise,'ZA3_TIPO')

Default cCodFil		:= ""
Default cCodPes		:= ""
Default _cAnalise		:= ""
Default nQtdAna		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta regras, caso tenha repassado os parโmetrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If !EMPTY(cCodFil) .AND. !EMPTY(cCodPes) .AND. !EMPTY(_cAnalise)

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    //ณExecuta tratamento, caso seja campo da anแlise NUMษRICOณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    If _cTipo == "N" 
        xRet := 0 
        dbSelectArea("ZM5")
        ZM5->(dbSetOrder(1))
        ZM5->(dbGoTop())
        If ZM5->(dbSeek(xFilial("ZM5", cCodFil) + cCodPes))
            While ZM5->(!EOF()) .AND. ZM5->ZM5_FILIAL == xFilial("ZM5", cCodFil) .AND. ZM5->ZM5_NUM == cCodPes
                If ZM5->ZM5_CARACT == _cAnalise
                    xRet += ZM5->ZM5_VALOR
                EndIf
                ZM5->(dbSkip())
            EndDo
            
            If nQtdAna > 0
                xRet := ROUND((xRet / nQtdAna), 4)
            EndIf
        EndIf			
    EndIf

EndIf

Return xRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL40INF  บAutor  ณMarcelo Joner        บ Data ณ 06/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por retornar o valor m้dio da anแlise de บฑฑ
ฑฑบ          ณqualidade da Pesagem conforme o campo repassado por parโme- บฑฑ
ฑฑบ          ณtro.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL40INF2( cCodFil, cCodPes, _cAnalise, nQtdAna)

Local xRet			:= ""
Local _cTipo      := Posicione('ZA3',1,xFilial('ZA3')+_cAnalise,'ZA3_TIPO')

Default cCodFil		:= ""
Default cCodPes		:= ""
Default _cAnalise		:= ""
Default nQtdAna		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta regras, caso tenha repassado os parโmetrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If !EMPTY(cCodFil) .AND. !EMPTY(cCodPes) .AND. !EMPTY(_cAnalise)

    If _cTipo == "T" 
            xRet := ""
            dbSelectArea("ZM5")
            ZM5->(dbSetOrder(1))
            ZM5->(dbGoTop())
            If ZM5->(dbSeek(xFilial("ZM5", cCodFil) + cCodPes + '01' + _cAnalise))
                xRet := ZM5->ZM5_DESCTX
            EndIf
    EndIf

EndIf

Return xRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณSCHEDDEF  บAutor  ณMarcelo Joner      บ Data ณ  06/05/2020  บฑฑ
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

aParam := {"R", "LTREL044LT", "", {}, "Pesagens - Fechamento"}

Return aParam
