#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLSFATR09  บ Autor ณMarcelo Joner       บ Data ณ  07/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelat๓rio de Resumo de Faturamento - Anแlitico.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSFATR09()

Private oReport
Private cFile		:= "LSFATR09"
Private cPerg		:= "LSFATR08LS"
Private cTitle		:= "Resumo de Faturamento - Por UF"
Private cHelp		:= "Relat๓rio responsแvel por apresentar as principais informa็๕es เ respeito de faturamento por UF."
Private cAliasTMP	:= GetNextAlias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a rotina de verifica็ใo do grupo de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
PERGUNTE(cPerg, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o objeto pertinente ao processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := FATR09()
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
ฑฑบPrograma  ณFATR08  บAutor  ณMarcelo Joner        บ Data ณ  07/05/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo processamento das demais regras em  บฑฑ
ฑฑบ          ณtorno da execu็ใo do relat๓rio.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FATR09()

Local aOrdem	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o componente de processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| FATR08PRT(oReport)}, cHelp,, "Total Filial")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)
oReport:bTotalPrint := {|| }


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de FILIALณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection1 := TRSection():New(oReport, "Filial", {"SM0"}, aOrdem)
TRCell():New(oSection1, "D2_FILIAL"	, ""   , "Filial")
TRCell():New(oSection1, "M0_FILIAL"	, "SM0", "Descri็ใo", "@!", 30,, {|| POSICIONE("SM0", 1, cEmpAnt + (cAliasTMP)->D2_FILIAL, "M0_FILIAL")})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de GRUPO DE PRODUTOSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection2 := TRSection():New(oSection1, "Grupo", {"SBM"})
oSection2:SetLeftMargin(02)
TRCell():New(oSection2, "B1_GRUPO"	, "SB1", "Grupo",,TAMSX3("B1_GRUPO")[1])
TRCell():New(oSection2, "BM_DESC"	, "SBM", "Descri็ใo", "@!", 50,, {|| POSICIONE("SBM", 1, xFilial("SBM", (cAliasTMP)->D2_FILIAL) + (cAliasTMP)->B1_GRUPO, "BM_DESC")})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de NOTAS FISCAIS DE VENDAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection3 := TRSection():New(oSection2, "Notas Fiscais", {"SA1", "SB1", "SD2", "SF2"})
oSection3:lHeaderVisible := .F.
oSection3:SetLeftMargin(04)
TRCell():New(oSection3, "A1_EST"	, "SA1", "Uf")
TRCell():New(oSection3, "B1_COD"	, "SB1", "Produto",,10)
TRCell():New(oSection3, "B1_DESC"	, "SB1", "Descri็ใo",, 30)
TRCell():New(oSection3, "VOLUME"	, "SD2")
TRCell():New(oSection3, "TOTAL_NET"	, "SD2",, "@E 99,999,999,999.99", 13)
TRCell():New(oSection3, "PRECO_NET"	,    "", "Vlr. Net", "@E 999.99", 6)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณTotalizador referente เ sessใo de NOTAS FISCAIS DE VENDAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
/*
oBreak1 := TRBreak():New(oSection3,{|| (cAliasTMP)->B1_GRUPO}, "Totais do Grupo",.F.)   
oBreak1:lHeaderPage := .F.
TRFunction():New(oSection3:Cell("D2_QUANT") , "GD2_QUANT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("D2_TOTAL") , "GD2_TOTAL"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("VLRDES") 	, "GVLRDES"		, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("D2_PRCVEN"), "GD2_PRCVEN"	, "ONPRINT"	, oBreak1,,"@E 999.99",{|| ROUND((oReport:GetFunction("GD2_TOTAL"):GetLastValue() / oReport:GetFunction("GD2_QUANT"):GetLastValue()), 2)},.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("PRCNET") 	, "GPRCNET"		, "ONPRINT"	, oBreak1,,"@E 999.99",{|| ROUND(((oReport:GetFunction("GD2_TOTAL"):GetLastValue() - oReport:GetFunction("GVLRDES"):GetLastValue()) / oReport:GetFunction("GD2_QUANT"):GetLastValue()), 2)},.F.,.T.,.F.)
TRFunction():New(oSection3:Cell("VLRCOM")	, "VLRCOM"		, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
*/
Return oReport





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณFATR08PRT   บAutor  ณMarcelo Joner      บ Data ณ 07/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela execu็ใo das regras de montagem da  บฑฑ
ฑฑบ          ณquery de busca das informa็๕es\impressใo das mesmas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FATR08PRT(oReport)

Local oSection1		:= oReport:Section(1)
Local oSection2		:= oReport:Section(1):Section(1)
Local oSection3		:= oReport:Section(1):Section(1):Section(1)
Local cCFOPVen		:= ""
Local cCFOPDev		:= ""
Local cMV_CFOPVEN	:= SuperGetMV("MV_CFOPVEN",,"") //RELAวรO DAS CFOPS DE VENDA
Local cMV_CFOPVFU	:= SuperGetMV("MV_CFOPVFU",,"") //RELAวรO DAS CFOPS DE VENDA ENTREGAS FUTURAS
Local cMV_CFOPDEV	:= SuperGetMV("MV_CFOPDEV",,"") //RELAวรO DAS CFOPS DE DEVOLUวรO

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณConsidera parโmetros de vendas futuras caso definido pelo usuแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If MV_PAR09 == 1
	cMV_CFOPVEN += cMV_CFOPVFU
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณComp๕e parโmetro de CFOPs para consulta SQLณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
cCFOPVen := "%" + ALLTRIM(FORMATIN(cMV_CFOPVEN, ";")) + "%"
cCFOPDev := "%" + ALLTRIM(FORMATIN(cMV_CFOPDEV, ";")) + "%"

cQryAcordo 	 := "%(SELECT round((AVG(SE1.E1_DECRESC) / SUM(SE1.E1_VALOR))*100,1) FROM SE1010 SE1 WHERE SE1.E1_FILIAL = SD2.D2_FILIAL AND SE1.E1_EMISSAO = SD2.D2_EMISSAO AND SE1.E1_NUM = SD2.D2_DOC AND SE1.E1_PREFIXO = SD2.D2_SERIE AND SE1.E1_CLIENTE = SD2.D2_CLIENTE AND SE1.E1_LOJA = SD2.D2_LOJA AND  SE1.E1_TIPO ='NF' AND (SE1.E1_PARCELA = '001' OR SE1.E1_PARCELA = '') AND SE1.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*')%"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณConsidera as vendas e devolu็๕es do perํodoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If MV_PAR07 == 1
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณComp๕e regra de filtro das notas fiscais de devolu็ใoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If MV_PAR08 == 1
		cQryDev := "%AND SD1.D1_EMISSAO >= '" + DTOS(MV_PAR05) + "' AND SD1.D1_EMISSAO <= '" + DTOS(MV_PAR06) + "'%"
	Else
		cQryDev := "%AND SD1.D1_DTDIGIT >= '" + DTOS(MV_PAR05) + "' AND SD1.D1_DTDIGIT <= '" + DTOS(MV_PAR06) + "'%"
	EndIf
	
	BEGIN REPORT QUERY oSection1
		BEGINSQL Alias cAliasTMP
			Column D2_EMISSAO  as Date
			
			SELECT 
				SA1.A1_EST,
				SB1.B1_COD,	
				SB1.B1_X_DESCD,
				SB1.B1_GRUPO,
				SUM( SD2.D2_QUANT) VOLUME,
				(CASE WHEN
					ROUND((AVG(SE1.E1_DECRESC) / AVG(SE1.E1_VALOR))*100,1) > 0
				THEN
					SUM(ROUND(((SD2.D2_TOTAL - ((SD2.D2_TOTAL * (ROUND(((SE1.E1_DECRESC) / (SE1.E1_VALOR))*100,1))) / 100))),2) )
				ELSE
					SUM(ROUND(SD2.D2_TOTAL,2))
				END) TOTAL_NET,
				(CASE WHEN
					ROUND((AVG(SE1.E1_DECRESC) / AVG(SE1.E1_VALOR))*100,1) > 0
				THEN
					ROUND(AVG((SD2.D2_TOTAL - ((SD2.D2_TOTAL * (ROUND(((SE1.E1_DECRESC) / (SE1.E1_VALOR))*100,1))) / 100)) / SD2.D2_QUANT),2)
				ELSE
					ROUND(AVG(SD2.D2_TOTAL  / SD2.D2_QUANT),2)
				END) PRECO_NET

				   								 				
			FROM %Table:SD2% SD2     
				INNER JOIN %Table:SE1% SE1 ON SE1.E1_FILIAL = SD2.D2_FILIAL AND SE1.E1_EMISSAO = SD2.D2_EMISSAO AND SE1.E1_NUM = SD2.D2_DOC AND SE1.E1_PREFIXO = SD2.D2_SERIE AND SE1.E1_CLIENTE = SD2.D2_CLIENTE AND SE1.E1_LOJA = SD2.D2_LOJA AND  SE1.E1_TIPO ='NF' AND (SE1.E1_PARCELA = '001' OR SE1.E1_PARCELA = '') AND SE1.D_E_L_E_T_ <> '*'
				INNER JOIN %Table:SA1% SA1 ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA
				INNER JOIN %Table:SB1% SB1 ON SB1.B1_COD = SD2.D2_COD           								
			WHERE SA1.A1_COD      = SD2.D2_CLIENTE
			  AND SA1.A1_LOJA     = SD2.D2_LOJA
			  AND SA1.%NotDel%
			  
			  AND SB1.B1_COD      = SD2.D2_COD
			  AND SB1.%NotDel%
			  	  
			  AND SD2.D2_FILIAL  >= %Exp:MV_PAR01%  AND SD2.D2_FILIAL  <= %Exp:MV_PAR02%				
			  AND SD2.D2_COD     >= %Exp:MV_PAR03%  AND SD2.D2_COD     <= %Exp:MV_PAR04%						
			  AND SD2.D2_EMISSAO >= %Exp:MV_PAR05%  AND SD2.D2_EMISSAO <= %Exp:MV_PAR06%
			  AND SD2.D2_QUANT > 0
			  AND SD2.D2_CF IN %Exp:cCFOPVen%								
			  AND SD2.%NotDel%
			  
			  
			  
			  UNION ALL
			  
			  SELECT 
			         SA1.A1_EST,
					 SB1.B1_COD,
			 	     SB1.B1_X_DESCD,
			 	     SB1.B1_GRUPO,
			 	     SUM(SD1.D1_QUANT * -1) VOLUME,
			 	     SUM(SD1.D1_TOTAL * -1) TOTAL_NET,
			 	     AVG(SD1.D1_TOTAL / SD1.D1_QUANT) PRECO_NET	     
					  

			  FROM %Table:SD1% SD1
			 	INNER JOIN %Table:SA1% SA1 ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA
				INNER JOIN %Table:SB1% SB1 ON SB1.B1_COD = SD1.D1_COD  	   
			  WHERE SA1.A1_COD      = SD1.D1_FORNECE
				AND SA1.A1_LOJA     = SD1.D1_LOJA
				AND SA1.%NotDel%
				   
				
				AND SB1.B1_COD      = SD1.D1_COD
				AND SB1.%NotDel%
				  
				AND SD1.D1_FILIAL  >= %Exp:MV_PAR01%  AND SD1.D1_FILIAL  <= %Exp:MV_PAR02%				
				AND SD1.D1_COD     >= %Exp:MV_PAR03%  AND SD1.D1_COD     <= %Exp:MV_PAR04%
				AND SD1.D1_QUANT > 0
				AND SD1.D1_CF IN %Exp:cCFOPDev%								
				AND SD1.%NotDel%
				%Exp:cQryDev%
			GROUP BY SD2.D2_GRUPO, SD2.D2_COD, SB1.B1_X_DESCD, SA1.A1_EST	
			ORDER BY D2_FILIAL, B1_GRUPO, D2_EMISSAO, B1_COD, A1_COD, A1_LOJA	 											
			
		ENDSQL
	END REPORT QUERY oSection1

Else

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณLista apenas as notas fiscais de vendaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	BEGIN REPORT QUERY oSection1
		BEGINSQL Alias cAliasTMP
			Column D2_EMISSAO  as Date
			
			SELECT SD2.D2_FILIAL,
				   SA1.A1_FILIAL,
				   SA1.A1_COD,
				   SA1.A1_CGC,
				   SA1.A1_X_CANAL,
				   SA1.A1_LOJA,
			 	   SA1.A1_NOME,
			 	   SA1.A1_NREDUZ,
				   SA1.A1_DTCAD,
				   SA1.A1_EST,
				   SA1.A1_MUN,
			 	   SA1.A1_PRICOM,
			 	   SD2.D2_EMISSAO,
			 	   SD2.D2_DOC,
				   SD2.D2_SERIE,
			 	   SD2.D2_CF,
				   SD2.D2_PEDIDO,
			 	   SB1.B1_COD,
			 	   SB1.B1_DESC,
			 	   SB1.B1_GRUPO,
			 	   SD2.D2_QUANT,
			 	   SD2.D2_TOTAL,
			 	   
			 	   (CASE WHEN
			 	   		%Exp:cQryAcordo% > 0
			 	   	THEN
			 	   		((SD2.D2_TOTAL * %Exp:cQryAcordo%) / 100)
			 	   	ELSE
			 	   		0
			 	   	END) VLRDES,
			 	   	
			 	   %Exp:cQryAcordo% AS A1_X_DESCF,
			 	   SD2.D2_PRCVEN,
			 	   
			 	   (CASE WHEN
			 	   		%Exp:cQryAcordo% > 0
			 	   	THEN
			 	   		((SD2.D2_TOTAL - ((SD2.D2_TOTAL * %Exp:cQryAcordo%) / 100)) / SD2.D2_QUANT)
			 	   	ELSE
			 	   		(SD2.D2_TOTAL / SD2.D2_QUANT)
			 	   	END) PRCNET,
			 	   	
			 	   SF2.F2_VEND1,
			 	   SD2.D2_COMIS1,
			 	   SD2.D2_VALICM
				   								 				
			FROM %Table:SA1% SA1,
			     %Table:SB1% SB1,
			     %Table:SF4% SF4,
			     %Table:SF2% SF2,
			     %Table:SD2% SD2     
			           								
			WHERE SA1.A1_FILIAL   = %xFilial:SA1%
			  AND SA1.A1_COD      = SD2.D2_CLIENTE
			  AND SA1.A1_LOJA     = SD2.D2_LOJA
			  AND SA1.%NotDel%
			  
			  AND SB1.B1_FILIAL   = %xFilial:SB1%
			  AND SB1.B1_COD      = SD2.D2_COD
			  AND SB1.%NotDel%
			  
			  AND SF4.F4_FILIAL   = SD2.D2_FILIAL
			  AND SF4.F4_CODIGO   = SD2.D2_TES
			  AND SF4.%NotDel%                                   	   					
			  
			  AND SF2.F2_FILIAL   = SD2.D2_FILIAL
			  AND SF2.F2_DOC      = SD2.D2_DOC
			  AND SF2.F2_SERIE    = SD2.D2_SERIE
			  AND SF2.F2_CLIENTE  = SD2.D2_CLIENTE
			  AND SF2.F2_LOJA     = SD2.D2_LOJA
			  AND SF2.F2_TIPO     = SD2.D2_TIPO
			  AND SF2.%NotDel%
			  
			  AND SD2.D2_FILIAL  >= %Exp:MV_PAR01%  AND SD2.D2_FILIAL  <= %Exp:MV_PAR02%				
			  AND SD2.D2_COD     >= %Exp:MV_PAR03%  AND SD2.D2_COD     <= %Exp:MV_PAR04%						
			  AND SD2.D2_EMISSAO >= %Exp:MV_PAR05%  AND SD2.D2_EMISSAO <= %Exp:MV_PAR06%
			  AND SD2.D2_QUANT > 0 
			  AND SD2.D2_CF IN %Exp:cCFOPVen%								
			  AND SD2.%NotDel%		
			  
			ORDER BY D2_FILIAL, B1_GRUPO, D2_EMISSAO, B1_COD, A1_COD, A1_LOJA  											
			
		ENDSQL
	END REPORT QUERY oSection1
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณVincula เ query da primeira sessใo เ segunda sessใo e define regra de quebraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection2:SetParentQuery()
oSection2:SetParentFilter({|cParam| (cAliasTMP)->D2_FILIAL == cParam},{|| (cAliasTMP)->D2_FILIAL})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณVincula เ query da primeira sessใo เ terceira sessใo e define regra de quebraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection3:SetParentQuery()
oSection3:SetParentFilter({|cParam| (cAliasTMP)->D2_FILIAL + (cAliasTMP)->B1_GRUPO == cParam},{|| (cAliasTMP)->D2_FILIAL + (cAliasTMP)->B1_GRUPO})

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
ฑฑบPrograma  ณSCHEDDEF  บAutor  ณMarcelo Joner      บ Data ณ  07/05/2020  บฑฑ
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

aParam := {"R", "LSFATR08LS", "", {}, "Resumo de Faturamento - Anแlitico"}

Return aParam
