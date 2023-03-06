#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLSESTR02  บ Autor ณTRELAC 			 บ Data ณ  07/02/2022 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelat๓rio Estoque Final por Filial.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRELAC                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSESTR02()

Private oReport
Private cFile			:= "LSESTR02"
Private cPerg			:= "LSESTR02  "
Private cTitle			:= "Posi็ใo estoque final por Filial"
Private cHelp			:= "Este relat๓rio ter por objetivo gerar a posi็ใo final do estoque conforme o perํodo informado de cada filial."
Private cAlsInvProduto	:= GetNextAlias()
Private cAlsInvGrupo	:= GetNextAlias()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a rotina de verifica็ใo do grupo de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
AJUSTASX1()
PERGUNTE(cPerg, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o objeto pertinente ao processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := REPCP032()
oReport:PRINTDIALOG()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณElimina tabelas temporแriasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

If Select(cAlsInvProduto) > 0
	(cAlsInvProduto)->(dbCloseArea())
EndIf

If Select(cAlsInvGrupo) > 0
	(cAlsInvGrupo)->(dbCloseArea())
EndIf

Return
                            




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREPCP032  บAutor  ณTRELAC       		บ Data ณ  16/10/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo processamento das demais regras em  บฑฑ
ฑฑบ          ณtorno da execu็ใo do relat๓rio.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TRELAC                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REPCP032()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria o componente de processamento do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REPCP032PRT(oReport)}, cHelp,,"Posi็ใo Estoque")
oReport:EndReport(.F.)
oReport:SetPortrait()			    // Define a impressใo em Retrato
//oReport:SetLandScape()              // Define a Impressใo como paisagem
//oReport:oPage:nPaperSize := 9 	    // Define o tamanho da pแgina = A4
oReport:SetTotalInLine(.F.)		    // Define se os totalizadores serใo impressos em linha ou coluna
oReport:bTotalPrint := {|| }	    // Desativa a impressใo dos totalizadores gerais
//oReport:cFontBody := 'Courier New'  //TIPO DA FONTE
//oReport:nFontBody := 8              // TAMANMHO DA FONTE
oReport:SetLineHeight(55)		    // ALTURA DA LINHA



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal do INVENTมRIO PRODUTO
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    oSInvProduto := TRSection():New(oReport, "POSIวรO ESTOQUE POR PRODUTO",,,,,,,.F.,.F.,.F.,,,,,.T.)
    oSInvProduto:cAlias := cAlsInvProduto
    oSInvProduto:lHeaderVisible := .T.
    oSInvProduto:SetLeftMargin(03)

    TRCell():New(oSInvProduto, "INVPROD"    , "   ", ""		        ,				, 1)
    TRCell():New(oSInvProduto, "PRODUTO"    , "SB9", "Codigo"	    ,				, 10)
    TRCell():New(oSInvProduto, "TIPO"	    , "SB9", "Tipo"	        ,				, 04)
    TRCell():New(oSInvProduto, "GRUPO"	    , "SB9", "Grupo"	    ,				, 05)
    TRCell():New(oSInvProduto, "NOME"       , "SB9", "Descri็ใo"    ,	            , 50)
    TRCell():New(oSInvProduto, "UNID"	    , "SB9", "U.M."	        ,				, 04)
    TRCell():New(oSInvProduto, "MES"	    , "SB9", "MสS"	        ,				, 08)
    TRCell():New(oSInvProduto, "FIL01"	    , "SB9", "01LAT01"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvProduto, "FIL03"	    , "SB9", "01LAT03"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvProduto, "FIL04"	    , "SB9", "01LAT04"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvProduto, "TRANS"	    , "SB9", "Transito"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvProduto, "TERC"	    , "SB9", "Terceiro"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvProduto, "TOTAL"	    , "SB9", "TOTAL"		,"@E 999,999,999.99", 15,,{|| xTotProd() 	},"RIGHT",/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,RGB(211,211,211),RGB(000,000,255),.T.)
        
    
    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    //ณCria a regra de Quebra e Totais por TIPO DO PRODUTO    ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    oBreak1 := TRBreak():New(oSInvProduto,oSInvProduto:Cell("TIPO"),"TOTAL DO TIPO ------------> : ",.F.)
    TRFunction():New(oSInvProduto:Cell("FIL01")	,"TOT_FIL01" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("FIL03")	,"TOT_FIL03" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)  
    TRFunction():New(oSInvProduto:Cell("FIL04")	,"TOT_FIL04" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("TRANS")	,"TOT_TRANS" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("TERC")	,"TOT_TERC" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("TOTAL")	,"TOT_TOTAL" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    //ณCria a regra de Quebra e Totais Gerais do TIPO PRODUTO ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    oBreak1 := TRBreak():New(oSInvProduto,oSInvProduto:Cell("INVPROD"),"TOTAL GERAL DOS TIPOS ------------> : ",.F.)
    TRFunction():New(oSInvProduto:Cell("FIL01")	,"TOT_FIL01" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("FIL03")	,"TOT_FIL03" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)  
    TRFunction():New(oSInvProduto:Cell("FIL04")	,"TOT_FIL04" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("TRANS")	,"TOT_TRANS" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("TERC")	,"TOT_TERC" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvProduto:Cell("TOTAL")	,"TOT_TOTAL" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria a sessใo principal do INVENTมRIO GRUPO
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    oSInvGrupo := TRSection():New(oReport, "POSIวรO ESTOQUE POR GRUPO",,,,,,,.F.,.F.,.F.,,,,,.T.)
    oSInvGrupo:cAlias := cAlsInvGrupo
    oSInvGrupo:lHeaderVisible := .T.
    oSInvGrupo:SetLeftMargin(03)

    TRCell():New(oSInvGrupo, "INVGRUPO" , "   ", ""		        ,				, 1)
    TRCell():New(oSInvGrupo, "GRUPO"	, "SB9", "Grupo"	    ,				, 05)
    TRCell():New(oSInvGrupo, "TIPO"	    , "SB9", "Tipo"	        ,				, 04)
    TRCell():New(oSInvGrupo, "NOME"     , "SB9", "Descri็ใo"    ,	            , 50)
    TRCell():New(oSInvGrupo, "UNID"	    , "SB9", "U.M."	        ,				, 04)
    TRCell():New(oSInvGrupo, "MES"	    , "SB9", "MสS"	        ,				, 08)
    TRCell():New(oSInvGrupo, "FIL01"	, "SB9", "01LAT01"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvGrupo, "FIL03"	, "SB9", "01LAT03"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvGrupo, "FIL04"	, "SB9", "01LAT04"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvGrupo, "TRANS"	, "SB9", "Transito"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvGrupo, "TERC"	    , "SB9", "Terceiro"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSInvGrupo, "TOTAL"	, "SB9", "TOTAL"		,"@E 999,999,999.99", 15,,{|| xTotGrupo() 	},"RIGHT",/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,RGB(211,211,211),RGB(000,000,255),.T.)
        
    
    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    //ณCria a regra de Quebra e Totais do Tipo POR GRUPO    ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    oBreak1 := TRBreak():New(oSInvGrupo,oSInvGrupo:Cell("TIPO"),"TOTAL DO TIPO ------------> : ",.F.)
    TRFunction():New(oSInvGrupo:Cell("FIL01")	,"TOT_FIL01" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("FIL03")	,"TOT_FIL03" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)  
    TRFunction():New(oSInvGrupo:Cell("FIL04")	,"TOT_FIL04" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("TRANS")	,"TOT_TRANS" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("TERC")	,"TOT_TERC" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("TOTAL")	,"TOT_TOTAL" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)


    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    //ณCria a regra de Quebra e Totais Gerais do GRUPO    ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    oBreak1 := TRBreak():New(oSInvGrupo,oSInvGrupo:Cell("INVGRUPO"),"TOTAL GERAL DOS GRUPOS ------------> : ",.F.)
    TRFunction():New(oSInvGrupo:Cell("FIL01")	,"TOT_FIL01" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("FIL03")	,"TOT_FIL03" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)  
    TRFunction():New(oSInvGrupo:Cell("FIL04")	,"TOT_FIL04" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("TRANS")	,"TOT_TRANS" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("TERC")	,"TOT_TERC" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSInvGrupo:Cell("TOTAL")	,"TOT_TOTAL" 	, "SUM", oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)


Return oReport





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณREPCP032PRT   บAutor  ณTRELAC      บ Data ณ 16/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela execu็ใo das regras de montagem da  บฑฑ
ฑฑบ          ณquery de busca das informa็๕es\impressใo das mesmas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณQualidade - TRELAC                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REPCP032PRT(oReport)

Local oSInvProduto	:= oReport:Section(1)
Local oSInvGrupo	:= oReport:Section(2)




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEfetua montagem da query INVENTมRIO POR PRODUTO
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

BEGIN REPORT QUERY oSInvProduto
	BEGINSQL Alias cAlsInvProduto

    SELECT B9.B9_COD PRODUTO, B1.B1_TIPO TIPO, B1.B1_GRUPO GRUPO , B1.B1_DESC NOME, B1.B1_UM UNID, SUBSTRING(B9.B9_DATA,5,2)+'/'+SUBSTRING(B9.B9_DATA,1,4) AS MES,
        ISNULL( (SELECT SUM(B901.B9_QINI)
            FROM %table:SB9% B901
                INNER JOIN %table:SB1% B101 ON B101.D_E_L_E_T_ = '' AND B101.B1_COD = B901.B9_COD
            WHERE B901.D_E_L_E_T_   = '' 
                AND B901.B9_FILIAL  = '01LAT01'
                AND B901.B9_DATA    = B9.B9_DATA
                AND B901.B9_COD     = B9.B9_COD
                AND B101.B1_TIPO    = B1.B1_TIPO 
                AND B101.B1_UM      = B1.B1_UM
            GROUP BY B901.B9_COD, B101.B1_TIPO, B101.B1_GRUPO, B101.B1_DESC, B901.B9_DATA ),0) FIL01,
        ISNULL( (SELECT SUM(B903.B9_QINI)
            FROM %table:SB9% B903
                INNER JOIN %table:SB1% B103 ON B103.D_E_L_E_T_ = '' AND B103.B1_COD = B903.B9_COD
            WHERE B903.D_E_L_E_T_   = '' 
                AND B903.B9_FILIAL  = '01LAT03'
                AND B903.B9_DATA    = B9.B9_DATA
                AND B903.B9_COD     = B9.B9_COD
                AND B103.B1_TIPO    = B1.B1_TIPO 
                AND B103.B1_UM      = B1.B1_UM
            GROUP BY B903.B9_COD, B103.B1_TIPO, B103.B1_GRUPO, B103.B1_DESC, B903.B9_DATA ),0) FIL03,
        ISNULL( (SELECT SUM(B904.B9_QINI)
            FROM %table:SB9% B904
                INNER JOIN %table:SB1% B104 ON B104.D_E_L_E_T_ = '' AND B104.B1_COD = B904.B9_COD
            WHERE B904.D_E_L_E_T_   = '' 
                AND B904.B9_FILIAL  = '01LAT04'
                AND B904.B9_DATA    = B9.B9_DATA
                AND B904.B9_COD     = B9.B9_COD
                AND B104.B1_TIPO    = B1.B1_TIPO 
                AND B104.B1_UM      = B1.B1_UM
            GROUP BY B904.B9_COD, B104.B1_TIPO, B104.B1_GRUPO, B104.B1_DESC, B904.B9_DATA ),0) FIL04,

        0 TRANS, 0 TERC
    FROM %table:SB9% B9
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = '' AND B1.B1_COD = B9.B9_COD
    WHERE B9.D_E_L_E_T_ = '' 
        AND B9.B9_DATA = %Exp:mv_par01%
        AND B1.B1_TIPO IN ('MP','PP','PI','PA','SP')
        AND B1.B1_MSBLQL <> '1'
    GROUP BY B9.B9_COD, B1.B1_TIPO, B1.B1_GRUPO, B1.B1_DESC, B1.B1_UM, B9.B9_DATA
    ORDER BY B1.B1_TIPO, B9.B9_COD

	EndSQL

END REPORT QUERY oSInvProduto



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณEfetua montagem da query INVENTมRIO POR GRUPO
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

BEGIN REPORT QUERY oSInvGrupo
	BEGINSQL Alias cAlsInvGrupo

    SELECT B1.B1_GRUPO GRUPO, B1.B1_TIPO TIPO, BM.BM_DESC NOME, B1.B1_UM UNID, SUBSTRING(B9.B9_DATA,5,2)+'/'+SUBSTRING(B9.B9_DATA,1,4) AS MสS,
        ISNULL( (SELECT SUM(B901.B9_QINI)
            FROM %table:SB9% B901
                INNER JOIN %table:SB1% B101 ON B101.D_E_L_E_T_ = '' AND B101.B1_COD = B901.B9_COD
            WHERE B901.D_E_L_E_T_ = '' 
                AND B901.B9_FILIAL	= '01LAT01'
                AND B901.B9_DATA	= B9.B9_DATA
                AND B101.B1_GRUPO	= B1.B1_GRUPO
                AND B101.B1_TIPO	= B1.B1_TIPO 
                AND B101.B1_UM		= B1.B1_UM
            GROUP BY B101.B1_TIPO, B101.B1_GRUPO, B901.B9_DATA ),0) FIL01,
        ISNULL( (SELECT SUM(B903.B9_QINI)
            FROM %table:SB9% B903
                INNER JOIN %table:SB1% B103 ON B103.D_E_L_E_T_ = '' AND B103.B1_COD = B903.B9_COD
            WHERE B903.D_E_L_E_T_ = '' 
                AND B903.B9_FILIAL	= '01LAT03'
                AND B903.B9_DATA	= B9.B9_DATA
                AND B103.B1_GRUPO	= B1.B1_GRUPO
                AND B103.B1_TIPO	= B1.B1_TIPO 
                AND B103.B1_UM		= B1.B1_UM
            GROUP BY B103.B1_TIPO, B103.B1_GRUPO, B903.B9_DATA ),0) FIL03,
        ISNULL( (SELECT SUM(B904.B9_QINI)
            FROM %table:SB9% B904
                INNER JOIN %table:SB1% B104 ON B104.D_E_L_E_T_ = '' AND B104.B1_COD = B904.B9_COD
            WHERE B904.D_E_L_E_T_ = '' 
                AND B904.B9_FILIAL	= '01LAT04'
                AND B904.B9_DATA	= B9.B9_DATA
                AND B104.B1_GRUPO	= B1.B1_GRUPO
                AND B104.B1_TIPO	= B1.B1_TIPO 
                AND B104.B1_UM		= B1.B1_UM
            GROUP BY B104.B1_TIPO, B104.B1_GRUPO, B904.B9_DATA ),0) FIL04,

        0 TRANS, 0 TERC
    FROM %table:SB9% B9
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = '' AND B1.B1_COD = B9.B9_COD
        INNER JOIN %table:SBM% BM ON BM.D_E_L_E_T_ = '' AND BM.BM_FILIAL = '01LAT' AND B1.B1_GRUPO = BM.BM_GRUPO
    WHERE B9.D_E_L_E_T_ = '' 
        AND B9.B9_DATA = %Exp:mv_par01%
        AND B1.B1_TIPO IN ('PP','PI','PA','SP')
        AND B1.B1_MSBLQL <> '1'
    GROUP BY B1.B1_GRUPO, B1.B1_TIPO, BM.BM_DESC, B1.B1_UM, B9.B9_DATA
    ORDER BY B1.B1_GRUPO, B1.B1_TIPO

	EndSQL

END REPORT QUERY oSInvGrupo




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Define relacionamento com a Se็ใo Pai  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//oSEmbal2:SetParentQuery()
//oSEmbal2:SetParentFilter({|cParam| (cAlsEMBPROD)->PRODPA == cParam},{|| (cAlsEMBPROD)->PRODPA })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณSeta regra de contador do processamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport:SetMeter((cAlsInvProduto)->(RECCOUNT()))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta a impressใo das sess๕es do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

oSInvProduto:Print()
oSInvGrupo:Print()

oReport:SkipLine(2)

Return



//ฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ DEFINE O TOTAL DOS ESTOQUES POR PRODUTO           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Static Function xTotProd()

Local nTotProd := 0



    nTotProd := (cAlsInvProduto)->FIL01 + (cAlsInvProduto)->FIL03 + (cAlsInvProduto)->FIL04 + (cAlsInvProduto)->TRANS + (cAlsInvProduto)->TERC
    

Return nTotProd

//ฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ DEFINE O TOTAL DOS ESTOQUES POR PRODUTO           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Static Function xTotGrupo()

Local nTotGrupo := 0



    nTotGrupo := (cAlsInvGrupo)->FIL01 + (cAlsInvGrupo)->FIL03 + (cAlsInvGrupo)->FIL04 + (cAlsInvGrupo)->TRANS + (cAlsInvGrupo)->TERC
    

Return nTotGrupo




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณTRELAC       บ Data ณ  15/12/09  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ao responsavel pela verificacao/criacao do grupo de per บฑฑ
ฑฑบ          ณguntas utilizado como parametro para emissao do relatorio   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณQualidade - TRELAC                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AJUSTASX1()

Local nI		:= 0
Local nJ		:= 0

Private aRegs	:= {}  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDefini็ใo dos itens do grupo de perguntas a ser criado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
AADD(aRegs, {cPerg, "01", "Perํodo  :"       , "Perํodo  :"       , "Perํodo  :"       , "mv_ch1" , "D",TAMSX3("B9_DATA")[1]    ,0,0,"G","","mv_par01",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณInsere os itens do grupo de perguntas no dicionแrio de perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
dbSelectArea("SX1")
SX1->(dbSetOrder(1))
For nI := 1 To Len(aRegs)
	SX1->(dbGoTop())
	If !SX1->(dbSeek(cPerg + aRegs[nI,2]))
		RECLOCK("SX1", .T.)
			For nJ := 1 to FCount()
				If nJ <= Len(aRegs[nI])
					FieldPut(nJ, aRegs[nI,nJ])
				EndIf
			Next nJ
		SX1->(MSUNLOCK())
	EndIf
Next nI

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณSCHEDDEF  บAutor  ณTRELAC      บ Data ณ  26/01/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por disponibilizar a utiliza็ใo do rela- บฑฑ
ฑฑบ          ณt๓rio na funcionalidade de Schedule.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TRELAC                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SCHEDDEF()

Local aParam

aParam := {"R", cPerg, "", {}, cTitle}

Return aParam

