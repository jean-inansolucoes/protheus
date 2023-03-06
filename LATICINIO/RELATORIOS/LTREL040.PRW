#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL040  บ Autor ณMarcelo Joner       บ Data ณ  06/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelat๓rio de Fechamento Mov. Soro In Natura.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTREL040()

Private oReport
Private cFile		:= "LTREL040"
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
oReport := REL040()
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
ฑฑบPrograma  ณREL040  บAutor  ณMarcelo Joner        บ Data ณ  06/05/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo processamento das demais regras em  บฑฑ
ฑฑบ          ณtorno da execu็ใo do relat๓rio.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL040()

Local aOrdem	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o componente de processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL040PRT(oReport)}, cHelp,, "Total Filial")
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

TRCell():New(oSection3, "ZM3_QLD004",    "", "Acidez",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD004", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD007",    "", "Gordura",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD007", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD008",    "", "Densidade",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD008", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM1_QLD022", "ZM1", "ST Brix", "@E 99.9", 3)
TRCell():New(oSection3, "ZM3_QLD003",    "", "Temperatura",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD003", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD005",    "", "Ph",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD005", (cAliasTMP)->QTDANA)})
TRCell():New(oSection3, "ZM3_QLD023",    "", "Antibi๓tico",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD023")})
TRCell():New(oSection3, "ZM3_QLD013",    "", "Alizarol",,,, {|| REL40INF((cAliasTMP)->ZM1_FILIAL, (cAliasTMP)->ZM1_NUM, "ZM3_QLD013", (cAliasTMP)->QTDANA)})

TRCell():New(oSection3, "ZM1_SLKG"  , "ZM1", "S๓l. Kg")
TRCell():New(oSection3, "ZM1_SLLT"  , "ZM1", "S๓l. Lt")
oSection3:aCell[22]:Disable()
oSection3:aCell[23]:Disable()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณTotalizador referente เ sessใo de PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oBreak1 := TRBreak():New(oSection3,{|| (cAliasTMP)->B1_COD + (cAliasTMP)->ZM1_TIPO}, "Totais",.F.)   
oBreak1:lHeaderPage := .F.
TRFunction():New(oSection3:Cell("ZM1_KGBRT") , "TZM1_KGBRT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_LTBRT") , "TZM1_LTBRT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_LTNOTA"), "TZM1_LTNOTA", "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_LTDIF") , "TZM1_LTDIF"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD004"), "TZM3_QLD004", "AVERAGE"	, oBreak1,,"@E 999",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD007"), "TZM3_QLD007", "AVERAGE"	, oBreak1,,"@E 999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD008"), "TZM3_QLD008", "AVERAGE"	, oBreak1,,"@E 9999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_QLD022"), "TZM1_QLD022", "AVERAGE"	, oBreak1,,"@E 99.9",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD003"), "TZM3_QLD003", "AVERAGE"	, oBreak1,,"@E 999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD005"), "TZM3_QLD005", "AVERAGE"	, oBreak1,,"@E 999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM3_QLD013"), "TZM3_QLD013", "AVERAGE"	, oBreak1,,"@E 999",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_SLKG")	 , "TZM1_SLKG"	, "AVERAGE"	, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("ZM1_SLLT")	 , "TZM1_SLKG"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)

Return oReport





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL040PRT   บAutor  ณMarcelo Joner      บ Data ณ 06/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela execu็ใo das regras de montagem da  บฑฑ
ฑฑบ          ณquery de busca das informa็๕es\impressใo das mesmas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL040PRT(oReport)

Local nI		:= 0
Local nY		:= 0
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)

If MV_PAR25 != 4
		cQryTpNota := "%AND ZM1.ZM1_TPNOTA = '" + ALLTRIM(STR(MV_PAR25)) + "'%"
Else
		cQryTpNota := "%AND ZM1.ZM1_TPNOTA >= '1' AND ZM1.ZM1_TPNOTA <= '4' %" 
EndIf

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
			                 (SELECT COUNT(ZM3.ZM3_NUM)
			                    FROM %Table:ZM3% ZM3
			                   WHERE ZM3.ZM3_FILIAL  = ZM1.ZM1_FILIAL
			                     AND ZM3.ZM3_NUM     = ZM1.ZM1_NUM
			                     AND ZM3.ZM3_QLD001 <> ' '
			                     AND ZM3.D_E_L_E_T_ <> '*') QTDANA
			
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
			                 (SELECT COUNT(ZM3.ZM3_NUM)
			                    FROM %Table:ZM3% ZM3
			                   WHERE ZM3.ZM3_FILIAL  = ZM1.ZM1_FILIAL
			                     AND ZM3.ZM3_NUM     = ZM1.ZM1_NUM
			                     AND ZM3.ZM3_QLD001 <> ' '
			                     AND ZM3.D_E_L_E_T_ <> '*') QTDANA
			
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
			    AND ZM1.%NotDel%)DADOS 
			  
			  ORDER BY ZM1_FILIAL, B1_COD, ZM1_TIPO, ZM1_DATA, ZM1_NUM
			  
		EndSQL
	END REPORT QUERY oSection1
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณHavilita c้lula referente hแ S๓lidos conforme parโmetro definido pelo usuแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If MV_PAR21 == 1
	oSection3:aCell[22]:Enable()
Else
	oSection3:aCell[23]:Enable()
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
Static Function REL40INF(cCodFil, cCodPes, cCampo, nQtdAna)

Local xRet			:= ""
Local nI			:= 0

Default cCodFil		:= ""
Default cCodPes		:= ""
Default cCampo		:= ""
Default nQtdAna		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta regras, caso tenha repassado os parโmetrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If !EMPTY(cCodFil) .AND. !EMPTY(cCodPes) .AND. !EMPTY(cCampo)
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	SX3->(dbGoTop())
	If SX3->(dbSeek(PADR(cCampo, 10)))
		Do Case
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณExecuta tratamento, caso seja campo da anแlise CARACTERณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			Case SX3->X3_TIPO == "C"
				xRet := ""
				dbSelectArea("ZM3")
				ZM3->(dbSetOrder(1))
				ZM3->(dbGoTop())
				If ZM3->(dbSeek(xFilial("ZM3", cCodFil) + cCodPes))
					xRet := &("ZM3->" + ALLTRIM(cCampo))
					
					If !EMPTY(SX3->X3_CBOX)
						aItens := STRTOKARR(ALLTRIM(X3Cbox()), ";")
						For nI := 1 To Len(aItens)
							If SUBSTR(aItens[nI], 1, (AT("=", aItens[nI], 1) - 1)) == xRet
								xRet := ALLTRIM(SUBSTR(aItens[nI], (AT("=", aItens[nI], 1) + 1), 20))
								exit
							EndIf
						Next nI
					EndIf
				EndIf
				
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณExecuta tratamento, caso seja campo da anแlise DATAณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			Case SX3->X3_TIPO == "D"
				xRet := STOD(SPACE(8))
				dbSelectArea("ZM3")
				ZM3->(dbSetOrder(1))
				ZM3->(dbGoTop())
				If ZM3->(dbSeek(xFilial("ZM3", cCodFil) + cCodPes))
					xRet := &("ZM3->" + ALLTRIM(cCampo))
				EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณExecuta tratamento, caso seja campo da anแlise NUMษRICOณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			Case SX3->X3_TIPO == "N"
				xRet := 0
				dbSelectArea("ZM3")
				ZM3->(dbSetOrder(1))
				ZM3->(dbGoTop())
				If ZM3->(dbSeek(xFilial("ZM3", cCodFil) + cCodPes))
					While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3", cCodFil) .AND. ZM3->ZM3_NUM == cCodPes
						xRet += &("ZM3->" + ALLTRIM(cCampo))
						ZM3->(dbSkip())
					End
					
					If nQtdAna > 0
						xRet := ROUND((xRet / nQtdAna), TAMSX3(ALLTRIM(cCampo))[2])
					EndIf
				EndIf			
		EndCase
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

aParam := {"R", "LTREL040LT", "", {}, "Pesagens - Fechamento"}

Return aParam
