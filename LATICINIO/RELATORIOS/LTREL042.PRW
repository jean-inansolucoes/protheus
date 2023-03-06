#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL042  บ Autor ณMarcelo Joner       บ Data ณ  16/04/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelat๓rio de anแlises de qualidade.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTREL042()

Private oReport
Private cFile		:= "LTREL042"
Private cPerg		:= "LTREL042LT"
Private cTitle		:= "Fechamento Pesagens"
Private cHelp		:= "Relat๓rio responsแvel por apresentar as principais informa็๕es de pesagens."
Private cAliasTMP	:= GetNextAlias()
Private cAliasTMP2	:= GetNextAlias()
Private cAliasTMP3	:= GetNextAlias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a rotina de verifica็ใo do grupo de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
PERGUNTE(cPerg, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o objeto pertinente ao processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := REL042()
oReport:PRINTDIALOG()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณElimina tabelas temporแriasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If Select(cAliasTMP) > 0
	(cAliasTMP)->(dbCloseArea())
EndIf

If Select(cAliasTMP2) > 0
	(cAliasTMP2)->(dbCloseArea())
EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL042  บAutor  ณMarcelo Joner        บ Data ณ  16/04/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo processamento das demais regras em  บฑฑ
ฑฑบ          ณtorno da execu็ใo do relat๓rio.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL042()

Local aOrdem	:= {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o componente de processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL042PRT(oReport)}, cHelp,, "Total Filial")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)
oReport:ShowParamPage(.F.)
oReport:lParamPage := .F.
oReport:bTotalPrint := {|| }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal de FILIALณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection1 := TRSection():New(oReport, "Filial", {"SM0"}, aOrdem)
TRCell():New(oSection1, "ZM1_FILIAL", ""   , "Filial")
TRCell():New(oSection1, "M0_FILIAL"	, "SM0", "Descri็ใo", "@!", 60,, {|| POSICIONE("SM0", 1, cEmpAnt + (cAliasTMP)->ZM1_FILIAL, "M0_NOMECOM")})


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
oSection3 := TRSection():New(oSection2, "Pesagens", {"ZM1"},,,,,,,.T.)
oSection3:lHeaderVisible := .F.
oSection3:SetLeftMargin(04)

TRCell():New(oSection3, "ZM1_NUM"	, "ZM1",,,06)
TRCell():New(oSection3, "ZM1_CLIFOR", "ZM1",,,TAMSX3("ZM1_CLIFOR")[1])
TRCell():New(oSection3, "ZM1_LOJA"	, "ZM1",,,TAMSX3("ZM1_LOJA")[1])
TRCell():New(oSection3, "NOMEFOR" , "",, "@!", 30,, {|| POSICIONE("SA2",1,xFilial("SA2")+(cAliasTMP)->ZM1_CLIFOR+(cAliasTMP)->ZM1_LOJA,"A2_NREDUZ")}, "Nome Fantasia")
TRCell():New(oSection3, "ZM1_PLACA"	, "ZM1", "Placa",,TAMSX3("ZM1_PLACA")[1])
TRCell():New(oSection3, "ZM1_CODLIN", "ZM1", "Linha",,TAMSX3("ZM1_CODLIN")[1])
TRCell():New(oSection3, "ZM1_NFCOM"	, "ZM1")
TRCell():New(oSection3, "ZM1_SRCOM"	, "ZM1")
TRCell():New(oSection3, "ZM1_DTINI"	, "ZM1", "Data Ent")
TRCell():New(oSection3, "ZM1_HRINI"	, "ZM1", "Hora Ent")
TRCell():New(oSection3, "ZM1_KGINI"	, "ZM1", "Kg Entrada",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGINI, ((cAliasTMP)->ZM1_KGINI * -1))})
TRCell():New(oSection3, "ZM1_DTFIN"	, "ZM1", "Data Sai")
TRCell():New(oSection3, "ZM1_HRFIN"	, "ZM1", "Hora Sai")
TRCell():New(oSection3, "ZM1_KGFIN"	, "ZM1", "Kg Saํda","@E 99,999,999",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGFIN, ((cAliasTMP)->ZM1_KGFIN * -1))})
TRCell():New(oSection3, "ZM1_KGBRT"	, "ZM1", "Kg Balan็a","@E 99,999,999",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGBRT, ((cAliasTMP)->ZM1_KGBRT * -1))})
TRCell():New(oSection3, "ZM1_LTBRT" , "ZM1", "Lt Convertido","@E 99,999,999",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTBRT, ((cAliasTMP)->ZM1_LTBRT * -1))})
TRCell():New(oSection3, "ZM1_LTMOV" , "ZM1", "Lt Coleta","@E 99,999,999",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTMOV, ((cAliasTMP)->ZM1_LTMOV * -1))})
TRCell():New(oSection3, "ZM1_LTNOTA", "ZM1", "Lt Nota","@E 99,999,999",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTNOTA, ((cAliasTMP)->ZM1_LTNOTA * -1))})
TRCell():New(oSection3, "ZM1_DIFKG" , "ZM1", "Diferen.","@E 99,999,999",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_DIFKG, ((cAliasTMP)->ZM1_DIFKG * -1))})
TRCell():New(oSection3, "ZM1_LTDIF" , "ZM1", "Diferen.","@E 99,999,999",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTDIF, ((cAliasTMP)->ZM1_LTDIF * -1))})
TRCell():New(oSection3, "ZM1_QLD022", "ZM1", "ST Brix",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_QLD022, ((cAliasTMP)->ZM1_QLD022 * -1))})
TRCell():New(oSection3, "ZM1_SLKG"  , "ZM1", "S๓lidos","@E 99,999,999.99",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_SLKG, ((cAliasTMP)->ZM1_SLKG * -1))})
TRCell():New(oSection3, "ZM1_SLLT"  , "ZM1", "S๓lidos","@E 99,999,999.99",,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_SLLT, ((cAliasTMP)->ZM1_SLLT * -1))})
TRCell():New(oSection3, "ZM1_STATUS", "ZM1", "Pesagem", "@!", 12)
TRCell():New(oSection3, "ZM1PRCSOL",    "", "Pre็o Comb.", "@E 999.99", 6,, {|| ROUND(((cAliasTMP)->ZM1_PRCSOL ) , 2)})
TRCell():New(oSection3, "ZM1_VLSOLKG"	,    "", "Vl. Total Sol.", "@E 999,999,999.99", 9,, {|| ROUND((cAliasTMP)->ZM1_VLSOLKG , 2)})
TRCell():New(oSection3, "ZM1_VLSOLLT"	,    "", "Vl. Total Sol.", "@E 999,999,999.99", 9,, {|| ROUND((cAliasTMP)->ZM1_VLSOLLT , 2)})
TRCell():New(oSection3, "VLRTOTAL"	,    "", "Vl. Total", "@E 999,999,999.99", 9,, {|| ROUND(((cAliasTMP)->ZM1_LTBRT * (cAliasTMP)->ZM1_PRCSOL ) , 2)})
TRCell():New(oSection3, "D1_VUNIT"	, "SD1", "Pre็o NF", "@E 999.99", 6,, {|| (cAliasTMP)->D1_VUNIT })
TRCell():New(oSection3, "D1_QUANT"	, "SD1", "Quant NF", "@E 999,999", 10,, {|| (cAliasTMP)->D1_QUANT })
TRCell():New(oSection3, "D1_TOTAL"	, "SD1", "Total NF", "@E 999,999.99", 10,, {|| (cAliasTMP)->D1_TOTAL })
TRCell():New(oSection3, "ZM1_VLDIFK"	, "ZM1", "DIF VALOR", "@E 999,999.99", 10,, {|| ROUND((cAliasTMP)->ZM1_VLDIFK , 2)})
TRCell():New(oSection3, "ZM1_VLDIFL"	, "ZM1", "DIF VALOR", "@E 999,999.99", 10,, {|| ROUND((cAliasTMP)->ZM1_VLDIFL , 2)})


oSection3:aCell[5]:Disable()
oSection3:aCell[6]:Disable()
oSection3:aCell[10]:Disable()
oSection3:aCell[11]:Disable()
oSection3:aCell[12]:Disable()
oSection3:aCell[13]:Disable()
oSection3:aCell[14]:Disable()
oSection3:aCell[12]:Disable()
oSection3:aCell[13]:Disable()
oSection3:aCell[16]:Disable()
oSection3:aCell[17]:Disable()
oSection3:aCell[18]:Disable()
oSection3:aCell[19]:Disable()
oSection3:aCell[20]:Disable()
oSection3:aCell[21]:Disable()
oSection3:aCell[22]:Disable()
oSection3:aCell[23]:Disable()
oSection3:aCell[24]:Disable()
oSection3:aCell[25]:Disable()
oSection3:aCell[26]:Disable()
oSection3:aCell[27]:Disable()
oSection3:aCell[28]:Disable()
oSection3:aCell[32]:Disable()
oSection3:aCell[33]:Disable()




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo de TOTAIS POR PRODUTOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection4 := TRSection():New(oReport, "Totais por Produto",,,,,,,.F.,.F.,.F.,,,,,.F.)
oSection4:SetLeftMargin(50)
oSection4:lHeaderVisible := .T.

TRCell():New(oSection4, "B1_COD"	, "", "Produto",PESQPICT("SB1", "B1_COD"), TAMSX3("B1_COD")[1])
TRCell():New(oSection4, "B1_DESC"	, "", "Descri็ใo",PESQPICT("SB1", "B1_DESC"), TAMSX3("B1_DESC")[1])
TRCell():New(oSection4, "ZM1_KGBRT"	, "ZM1", "Kg Balan็a","@E 99,999,999")
TRCell():New(oSection4, "ZM1_LTBRT" , "ZM1", "Lt Convertido","@E 99,999,999")
TRCell():New(oSection4, "ZM1_LTMOV" , "ZM1", "Lt Coleta","@E 99,999,999")
TRCell():New(oSection4, "ZM1_LTNOTA", "ZM1", "Qtd Nota","@E 99,999,999")
TRCell():New(oSection4, "ZM1_DIFKG" , "ZM1", "Dif. Bal","@E 99,999,999")
TRCell():New(oSection4, "ZM1_LTDIF" , "ZM1", "Diferen.","@E 99,999,999")
TRCell():New(oSection4, "ZM1_QLD022", "ZM1", "ST Brix")
TRCell():New(oSection4, "ZM1_SLKG"  , "ZM1", "S๓lidos","@E 99,999,999.99")
TRCell():New(oSection4, "ZM1_SLLT"  , "ZM1", "S๓lidos","@E 99,999,999.99")
TRCell():New(oSection4, "ZM1_VLSLKG", "ZM1", "Vl. S๓lidos","@E 99,999,999.99",13)
TRCell():New(oSection4, "ZM1_VLSLLT", "ZM1", "Vl. S๓lidos","@E 99,999,999.99",13)
TRCell():New(oSection4, "ZM1_VLSLTT", "ZM1", "Vl. Total","@E 99,999,999.99",13)
TRCell():New(oSection4, "SD1_VLTOTN", "ZM1", "Total NF","@E 99,999,999.99",13)
TRCell():New(oSection4, "SD1_VLTOTD", "ZM1", "Dif. Total","@E 99,999,999.99",13)
TRCell():New(oSection4, "ZM1_TBRXKG"	,    "", "%Brix Med", "@E 999.99", 5,, {|| ROUND(((cAliasTMP3)->ZM1_SLKG / (cAliasTMP3)->ZM1_KGBRT )*100 , 2)})
TRCell():New(oSection4, "ZM1_TBRXLT"	,    "", "%Brix Med", "@E 999.99", 5,, {|| ROUND(((cAliasTMP3)->ZM1_SLLT / (cAliasTMP3)->ZM1_LTBRT )*100 , 2)})
//TRCell():New(oSection4, "SD1_VLTOTDL", "ZM1", "Dif. Total l","@E 99,999,999.99",13)

oSection4:aCell[03]:Disable()
oSection4:aCell[04]:Disable()
oSection4:aCell[05]:Disable()
oSection4:aCell[06]:Disable()
oSection4:aCell[07]:Disable()
oSection4:aCell[08]:Disable()
oSection4:aCell[09]:Disable()
oSection4:aCell[10]:Disable()
oSection4:aCell[11]:Disable()
oSection4:aCell[12]:Disable()
oSection4:aCell[13]:Disable()
oSection4:aCell[14]:Disable()
oSection4:aCell[15]:Disable()
oSection4:aCell[16]:Disable()
oSection4:aCell[17]:Disable()
oSection4:aCell[18]:Disable()
//oSection4:aCell[19]:Disable()


Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREL042PRT   บAutor  ณMarcelo Joner      บ Data ณ 16/04/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela execu็ใo das regras de montagem da  บฑฑ
ฑฑบ          ณquery de busca das informa็๕es\impressใo das mesmas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL042PRT(oReport)

Local cQryTpNota:= ""
Local cQryLtKg := ""
Local cQryUnQt := ""
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)
Local oSection4	:= oReport:Section(2)
//oSection3:SetHeaderPage()
oSection3:SetHeaderBreak(.T.)

If MV_PAR23 != 4
		cQryTpNota := "%AND ZM1.ZM1_TPNOTA = '" + ALLTRIM(STR(MV_PAR23)) + "'%"
Else
		cQryTpNota := "%AND ZM1.ZM1_TPNOTA >= '1' AND ZM1.ZM1_TPNOTA <= '1' %" 
EndIf

If MV_PAR22 == 1
	cQryLtKg := "%SUM((DADOS.ZM1_SLKG * DADOS.ZM1_PRCSOL) - DADOS.D1_TOTAL) SD1_VLTOTD %" 
	cQryUnQt := "%(SD1.D1_TOTAL / (SD1.D1_QUANT / ZM1_FATCON)) D1_VUNIT, (SD1.D1_QUANT / ZM1_FATCON) D1_QUANT%"
Else
	cQryLtKg := "%SUM((DADOS.ZM1_SLLT * DADOS.ZM1_PRCSOL) - DADOS.D1_TOTAL) SD1_VLTOTD %" 
	cQryUnQt := "%SD1.D1_VUNIT,SD1.D1_QUANT%"
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEfetua montagem da query da sessใo de FILIAISณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
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
							%Exp:cQryUnQt%,
							SD1.D1_TOTAL,
							((SD1.D1_QUANT /  ZM1.ZM1_FATCON)- ZM1.ZM1_KGBRT) AS ZM1_DIFKG,
							(ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLKG,
							(ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLLT,
							((ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFL,
							((ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFK
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%

			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '2'
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM3% ZM3
			              WHERE ZM3.ZM3_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM3.ZM3_NUM    = ZM1.ZM1_NUM
			                AND ZM3.%NotDel%)
			
			  
			UNION ALL
			
			
			SELECT DISTINCT ZM1.*, 
							SB1.B1_COD, 
							SB1.B1_DESC,
							%Exp:cQryUnQt%,
							SD1.D1_TOTAL,
							((SD1.D1_QUANT /  ZM1.ZM1_FATCON) - ZM1.ZM1_KGBRT) AS ZM1_DIFKG,
							(ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLKG,
							(ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLLT,
							((ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFL,
							((ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFK
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '1'
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM3% ZM3
			              WHERE ZM3.ZM3_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM3.ZM3_NUM    = ZM1.ZM1_NUM
			                AND ZM3.%NotDel%)

		  UNION ALL
		  SELECT DISTINCT ZM1.*, 
							SB1.B1_COD, 
							SB1.B1_DESC,
							%Exp:cQryUnQt%,
							SD1.D1_TOTAL,
							((SD1.D1_QUANT /  ZM1.ZM1_FATCON) - ZM1.ZM1_KGBRT) AS ZM1_DIFKG,
							(ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLKG,
							(ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLLT,
							((ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFL,
							((ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFK
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%

			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '2'
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)
			
			  
			UNION ALL
			
			
			SELECT DISTINCT ZM1.*, 
							SB1.B1_COD, 
							SB1.B1_DESC,
							%Exp:cQryUnQt%,
							SD1.D1_TOTAL,
							((SD1.D1_QUANT /  ZM1.ZM1_FATCON) - ZM1.ZM1_KGBRT) AS ZM1_DIFKG,
							(ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLKG,
							(ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) AS ZM1_VLSOLLT,
							((ZM1.ZM1_SLLT * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFL,
							((ZM1.ZM1_SLKG * ZM1.ZM1_PRCSOL) - SD1.D1_TOTAL) AS ZM1_VLDIFK
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '1'
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)) DADOS
		ORDER BY ZM1_FILIAL, B1_COD, ZM1_TIPO, ZM1_DATA, ZM1_NUM
		  
	EndSQL
END REPORT QUERY oSection1


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEfetua montagem da query da sessใo de TOTAIS POR PRODUTOSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
BEGIN REPORT QUERY oSection4
	BEGINSQL Alias cAliasTMP3
		
		%noparser%
		
		SELECT DISTINCT '1' FLAG,
						DADOS.B1_COD,
		                DADOS.B1_DESC,
		                SUM(DADOS.ZM1_KGBRT) ZM1_KGBRT,
		                SUM(DADOS.ZM1_LTBRT) ZM1_LTBRT,
		                SUM(DADOS.ZM1_LTNOTA) ZM1_LTNOTA,
		                SUM(DADOS.ZM1_LTDIF) ZM1_LTDIF,
						SUM((DADOS.D1_QUANT - DADOS.ZM1_KGBRT)) AS ZM1_DIFKG,
		                SUM(DADOS.ZM1_QLD022) ZM1_QLD022,
		                SUM(DADOS.ZM1_SLKG) ZM1_SLKG,
		                SUM(DADOS.ZM1_SLLT) ZM1_SLLT,
						SUM(DADOS.D1_TOTAL) SD1_VLTOTN,
						SUM(DADOS.ZM1_SLKG * DADOS.ZM1_PRCSOL) ZM1_VLSLKG,
						SUM(DADOS.ZM1_SLLT * DADOS.ZM1_PRCSOL) ZM1_VLSLLT,
						SUM(DADOS.ZM1_LTBRT * DADOS.ZM1_PRCSOL) ZM1_VLSLTT,
						%Exp:cQryLtKg%
						//SUM((DADOS.ZM1_SLKG * DADOS.ZM1_PRCSOL) - DADOS.D1_TOTAL) SD1_VLTOTDK
						//SUM((DADOS.ZM1_SLLT * DADOS.ZM1_PRCSOL) - DADOS.D1_TOTAL) SD1_VLTOTDL
						
						
		                
		FROM
			(SELECT DISTINCT SB1.B1_COD, 
							 SB1.B1_DESC,							 
							%Exp:cQryUnQt%,
							 SD1.D1_TOTAL,
							 SD1.D1_EMISSAO,
							 (ZM1.ZM1_KGBRT * -1) ZM1_KGBRT,
		                	 (ZM1.ZM1_LTBRT * -1) ZM1_LTBRT,
		                	 (ZM1.ZM1_LTNOTA * -1) ZM1_LTNOTA,
		                	 (ZM1.ZM1_LTDIF * -1) ZM1_LTDIF,
		                	 (ZM1.ZM1_QLD022 * -1) ZM1_QLD022,
		                	 (ZM1.ZM1_SLKG * -1) ZM1_SLKG,
		                	 (ZM1.ZM1_SLLT * -1) ZM1_SLLT,
							 (ZM1.ZM1_PRCSOL * -1) ZM1_PRCSOL
							 
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '2
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM3% ZM3
			              WHERE ZM3.ZM3_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM3.ZM3_NUM    = ZM1.ZM1_NUM
			                AND ZM3.%NotDel%)
			
			  
			UNION ALL
			
			
			SELECT DISTINCT SB1.B1_COD, 
							SB1.B1_DESC,
							%Exp:cQryUnQt%,
							SD1.D1_TOTAL,
							SD1.D1_EMISSAO,
							ZM1.ZM1_KGBRT,
		                	ZM1.ZM1_LTBRT,
		                	ZM1.ZM1_LTNOTA,
		                	ZM1.ZM1_LTDIF,
		                	ZM1.ZM1_QLD022,
		                	ZM1.ZM1_SLKG,
		                	ZM1.ZM1_SLLT,
							ZM1.ZM1_PRCSOL

			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '1'
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM3% ZM3
			              WHERE ZM3.ZM3_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM3.ZM3_NUM    = ZM1.ZM1_NUM
			                AND ZM3.%NotDel%)
							UNION ALL
			
			
			SELECT DISTINCT SB1.B1_COD, 
							 SB1.B1_DESC,							 
							%Exp:cQryUnQt%,
							SD1.D1_TOTAL,
							SD1.D1_EMISSAO,
							 (ZM1.ZM1_KGBRT * -1) ZM1_KGBRT,
		                	 (ZM1.ZM1_LTBRT * -1) ZM1_LTBRT,
		                	 (ZM1.ZM1_LTNOTA * -1) ZM1_LTNOTA,
		                	 (ZM1.ZM1_LTDIF * -1) ZM1_LTDIF,
		                	 (ZM1.ZM1_QLD022 * -1) ZM1_QLD022,
		                	 (ZM1.ZM1_SLKG * -1) ZM1_SLKG,
		                	 (ZM1.ZM1_SLLT * -1) ZM1_SLLT,
							 (ZM1.ZM1_PRCSOL * -1) ZM1_PRCSOL
							 
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '2'
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)
			
			  
			UNION ALL
			
			
			SELECT DISTINCT SB1.B1_COD, 
							SB1.B1_DESC,
							%Exp:cQryUnQt%,
							SD1.D1_TOTAL,
							SD1.D1_EMISSAO,
							ZM1.ZM1_KGBRT,
		                	ZM1.ZM1_LTBRT,
		                	ZM1.ZM1_LTNOTA,
		                	ZM1.ZM1_LTDIF,
		                	ZM1.ZM1_QLD022,
		                	ZM1.ZM1_SLKG,
		                	ZM1.ZM1_SLLT,
							ZM1.ZM1_PRCSOL

			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1,
				%Table:SD1% SD1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND SD1.D1_FILIAL = ZM1.ZM1_FILIAL
			  AND SD1.D1_DOC = ZM1.ZM1_NFCOM
			  AND SD1.D1_SERIE = ZM1.ZM1_SRCOM
			  AND SD1.D1_FORNECE = ZM1.ZM1_CLIFOR
			  AND SD1.D1_LOJA = ZM1.ZM1_LOJA

			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '1'
			  AND (ZM1.ZM1_FATCON  > 0 OR ZM1.ZM1_PRCSOL  > 0)
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  AND SD1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)) DADOS
		
		GROUP BY B1_COD, B1_DESC
		
		ORDER BY B1_COD
		  
	EndSQL
END REPORT QUERY oSection4

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCaso seja emissใo para LEITE, habilita c้lulas da sessใo de PESAGENSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If MV_PAR21 == "1"
	oSection3:aCell[17]:Enable()
	oSection3:aCell[18]:Enable()
	oSection3:aCell[19]:Enable()
	oSection4:aCell[05]:Enable()
	oSection4:aCell[06]:Enable()
	oSection4:aCell[07]:Enable()
		

	
	If MV_PAR23 == 1
		oSection3:aCell[25]:Enable()
		oSection3:aCell[26]:Enable()
		oSection4:aCell[14]:Enable()		
	EndIf	
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณCaso seja emissใo para SORO, habilita c้lulas da sessใo de PESAGENSณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oSection4:aCell[03]:Enable()
	oSection3:aCell[21]:Enable()
	If MV_PAR23 == 1
		oSection3:aCell[25]:Enable()
	EndIf
	
	oSection4:aCell[06]:Enable()
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณAtiva c้lula referente hแ informa็ใo de SOLIDOS conforme parโmetroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If MV_PAR22 == 1
		oSection3:aCell[19]:Enable()
		oSection3:aCell[22]:Enable()
		oSection3:aCell[32]:Enable()
		
		oSection4:aCell[07]:Enable()
		oSection4:aCell[10]:Enable()
		oSection4:aCell[12]:Enable()
		oSection4:aCell[15]:Enable()
		oSection4:aCell[16]:Enable()
		oSection4:aCell[17]:Enable()
		
		If MV_PAR23 == 1
			oSection3:aCell[26]:Enable()
		EndIf
	Else
		oSection3:aCell[16]:Enable()
		oSection3:aCell[20]:Enable()
		oSection3:aCell[23]:Enable()
		oSection3:aCell[33]:Enable()
		
		oSection4:aCell[04]:Enable()
		oSection4:aCell[08]:Enable()
		oSection4:aCell[11]:Enable()
		oSection4:aCell[13]:Enable()
		oSection4:aCell[15]:Enable()
		oSection4:aCell[16]:Enable()
		oSection4:aCell[18]:Enable()
		
		
		If MV_PAR23 == 1	
			oSection3:aCell[27]:Enable()
		EndIf
	EndIf
	
EndIf



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณSeta regra de contador do processamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport:SetMeter((cAliasTMP)->(RECCOUNT()))


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a impressใo das sess๕es do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection1:Print()



oReport:SkipLine(3)
oSection4:Print()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณSCHEDDEF  บAutor  ณMarcelo Joner      บ Data ณ  16/04/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por disponibilizar a utiliza็ใo do rela- บฑฑ
ฑฑบ          ณt๓rio na funcionalidade de Schedule.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*Static Function SCHEDDEF()

Local aParam

aParam := {"R", "LTREL042LT", "", {}, "Anแlises de Qualidade"}

Return aParam
*/
