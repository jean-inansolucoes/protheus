#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁLSESTR01  ╨ Autor ЁTRELAC 			 ╨ Data Ё  14/12/2021 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao ЁRelatСrio AnАlise e ConferЙncia do Custo da ProduГЦo        ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁRELAC                                                       ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function LSESTR01()

Private oReport
Private cFile			:= "LSESTR01"
Private cPerg			:= "LSESTR01  "
Private cTitle			:= "AnАlise/ConferЙncia Custo de ProduГЦo"
Private cHelp			:= "Este relatСrio ter por objetivo detalhar os movimentos da ProduГЦo apra sua anАlise e conferЙncia dos seus custos."
Private cAliasTMP1		:= GetNextAlias()
Private cAlsInsSoro		:= GetNextAlias()
Private cAlsINSUMOS		:= GetNextAlias()
Private cAlsGGFMassa	:= GetNextAlias()
Private cAlsGGFGrupo	:= GetNextAlias()
Private cAlsEMBTOT	    := GetNextAlias()
Private cAlsEMBPROD		:= GetNextAlias()
Private cAlsCUSTOGRP	:= GetNextAlias()
Private cAlsProdMASSA 	:= GetNextAlias()
Private cAlsPPMASSA 	:= GetNextAlias()
Private cLeitePadron    := ""
Private cPPMassa        := ""
Private cProdMassa      := "('')"
Private cProdPPMassa    := ""
Private nQtdeMassa      := 0




//здддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁExecuta a rotina de verificaГЦo do grupo de perguntasЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддд
AJUSTASX1()
PERGUNTE(cPerg, .F.)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria o objeto pertinente ao processamento do relatСrioЁ
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддд
oReport := REPCP032()
    oReport:PRINTDIALOG()

//здддддддддддддддддддддддддддд
//ЁElimina tabelas temporАriasЁ
//юдддддддддддддддддддддддддддд
If Select(cAlsCUSTOGRP) > 0
	(cAlsCUSTOGRP)->(dbCloseArea())
EndIf

If Select(cAliasTMP1) > 0
	(cAliasTMP1)->(dbCloseArea())
EndIf

If Select(cAlsProdMASSA) > 0
	(cAlsProdMASSA)->(dbCloseArea())
EndIf

If Select(cAlsPPMASSA) > 0
	(cAlsPPMASSA)->(dbCloseArea())
EndIf

If Select(cAlsInsSoro) > 0
	(cAlsInsSoro)->(dbCloseArea())
EndIf

If Select(cAlsINSUMOS) > 0
	(cAlsINSUMOS)->(dbCloseArea())
EndIf

If Select(cAlsGGFMassa) > 0
	(cAlsGGFMassa)->(dbCloseArea())
EndIf

If Select(cAlsGGFGrupo) > 0
	(cAlsGGFGrupo)->(dbCloseArea())
EndIf

If Select(cAlsEMBTOT) > 0
	(cAlsEMBTOT)->(dbCloseArea())
EndIf

If Select(cAlsEMBPROD) > 0
	(cAlsEMBPROD)->(dbCloseArea())
EndIf

Return
                            




/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммм`ммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  ЁREPCP032  ╨Autor  ЁTRELAC       		╨ Data Ё  16/10/2015  ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁFunГЦo responsАvel pelo processamento das demais regras em  ╨╠╠
╠╠╨          Ёtorno da execuГЦo do relatСrio.                             ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё TRELAC                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function REPCP032()

//здддддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria o componente de processamento do relatСrioЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддд
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REPCP032PRT(oReport)}, cHelp,,"AnАlise Custos")
oReport:EndReport(.F.)
//oReport:SetPortrait()			    // Define a impressЦo em Retrato
oReport:SetLandScape()              // Define a ImpressЦo como paisagem
//oReport:oPage:nPaperSize := 9 	    // Define o tamanho da pАgina = A4
oReport:SetTotalInLine(.F.)		    // Define se os totalizadores serЦo impressos em linha ou coluna
oReport:bTotalPrint := {|| }	    // Desativa a impressЦo dos totalizadores gerais
//oReport:cFontBody := 'Courier New'  //TIPO DA FONTE
oReport:nFontBody := 09              // TAMANMHO DA FONTE
oReport:SetLineHeight(55)		    // ALTURA DA LINHA



//здддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal do GRUPO e ProdutoЁ
//юдддддддддддддддддддддддддддддддддддддддддддд
oSection1 := TRSection():New(oReport, "GRUPO DO PRODUTO",,,,,,,.F.,.F.,.F.,,,,,.F.)
oSection1:cAlias := cAliasTMP1
oSection1:lHeaderVisible := .F.
oSection1:SetLeftMargin(02)
oSection1:SetPageBreak(.F.)			// Define se salta a pАgina na quebra de seГЦo
oSection1:SetHeaderSection(.T.)		// Define de imprime cabeГalho das cИlulas na quebra de seГЦo

//TRCell():New(oSection1,"TXTFIXO" ,,,,20,,{|| "Grupo do Produto: "	},"LEFT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.T.)
TRCell():New(oSection1, "GRUPO"     ,,"Grupo do Produto" , "@!"        ,40,, {|| (cAliasTMP1)->GRUPO + " - " + (cAliasTMP1)->NOME },"LEFT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.T.)
TRCell():New(oSection1, "PERCRENDA" ,,"Perc.Renda(%)"     , "@E 999.99",10,, {|| xRatRenda("PERCRENDA") },"RIGHT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.T.)


//здддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal do PRODUгцO GRUPO 
//юдддддддддддддддддддддддддддддддддддддддддддддддддд
    oSCustoProd := TRSection():New(oReport, "PRODUгцO DO MйS",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSCustoProd:cAlias := cAlsCUSTOGRP
    oSCustoProd:lHeaderVisible := .T.
    oSCustoProd:SetLeftMargin(02)

    TRCell():New(oSCustoProd, "CUSTTOT"	    , "   ", ""		            ,				, 1)
    TRCell():New(oSCustoProd, "PRODUTO"	    , "SD3", "Codigo"	        ,				, 10)
    TRCell():New(oSCustoProd, "NOME"        , "SD3", "Produto"          ,	            , 40)
    TRCell():New(oSCustoProd, "QUANT"	    , "SD3", "Volume"		    ,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSCustoProd, "UNID"	    , "SD3", "U.M."	            ,				, 05)
    TRCell():New(oSCustoProd, "CUNIT"		, "SD3", "Custo Unit."      ,"@E 999,999.9999"  , 10,,,"RIGHT",,"RIGHT")
    TRCell():New(oSCustoProd, "CUSTO"		, "SD3", "Custo Total"	    ,"@E 99,999,999.99" , 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSCustoProd, "CUSTOMASSA"	, "SD3", "Custo kg Massa"	,"@E 999,999.9999" , 12,,{|| (cAlsCUSTOGRP)->CUSTO / xProdMassa()  } ,"RIGHT",,"RIGHT")
        
    
    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo do TOTAL PRODUгцO GRUPO    Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
        oBreak1 := TRBreak():New(oSCustoProd,oSCustoProd:Cell("CUSTTOT"),"TOTAL ------------> : ",.F.)
        TRFunction():New(oSCustoProd:Cell("QUANT")	,"TOT_QUANT" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
        TRFunction():New(oSCustoProd:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)  
        TRFunction():New(oSCustoProd:Cell("CUNIT")	,"TOT_CUNIT" 	, "ONPRINT", oBreak1,,"@E 999,999.9999",{ || xTotGrupo("CUNIT") },.F.,.T.,.F.)



//здддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal do CONSUMO PP MASSA 
//юдддддддддддддддддддддддддддддддддддддддддддддддддд
    oSPPMASSA := TRSection():New(oReport, "CONSUMO MASSA NO MйS",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSPPMASSA:cAlias := cAlsPPMASSA
    oSPPMASSA:lHeaderVisible := .T.
    oSPPMASSA:SetLeftMargin(02)

    TRCell():New(oSPPMASSA, "CONSMASSA" , "   ", ""		        ,				    , 1)
    TRCell():New(oSPPMASSA, "PRODUTO"   , "SD3", "Codigo"	    ,				    , 10,,{|| (cAlsPPMASSA)->PRODUTO    } )
    TRCell():New(oSPPMASSA, "NOME"      , "SD3", "Produto"      ,	                , 40,,{|| (cAlsPPMASSA)->NOME       } )
    TRCell():New(oSPPMASSA, "QUANT"	    , "SD3", "Quantidade"	,"@E 999,999,999.99", 15,,{|| (cAlsPPMASSA)->QUANT      } ,"RIGHT",,"RIGHT")
    TRCell():New(oSPPMASSA, "UNID"	    , "SD3", "U.M."	        ,				    , 05,,{|| (cAlsPPMASSA)->UNID       } )
    TRCell():New(oSPPMASSA, "CUNIT"		, "SD3", "Custo Unit."  ,"@E 999,999.9999"  , 10,,{|| (cAlsPPMASSA)->CUNIT      } ,"RIGHT",,"RIGHT")
    TRCell():New(oSPPMASSA, "CUSTO"		, "SD3", "Custo Total"	,"@E 99,999,999.99" , 15,,{|| (cAlsPPMASSA)->CUSTO      } ,"RIGHT",,"RIGHT")
        
    
    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo do TOTAL CUSTO PRODUгцO GRUPO    Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oBreak1 := TRBreak():New(oSPPMASSA,oSPPMASSA:Cell("CONSMASSA"),"TOTAL ------------> : ",.F.)
    TRFunction():New(oSPPMASSA:Cell("QUANT")	,"TOT_QUANT" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSPPMASSA:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)  
    //TRFunction():New(oSPPMASSA:Cell("CUNIT")	,"TOT_CUNIT" 	, "ONPRINT", oBreak1,,"@E 999,999.9999",{ || xTotGrupo() },.F.,.T.,.F.)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal da PRODUгцO MASSA DOS PRODUTOS PROVOLONE / MONTANHES E PARMESцO
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oSProdMASSA := TRSection():New(oReport, "PRODUгцO MASSA NO MйS",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSProdMASSA:cAlias := cAlsProdMASSA
    oSProdMASSA:lHeaderVisible := .T.
    oSProdMASSA:SetLeftMargin(02)

    TRCell():New(oSProdMASSA, "PRODMASSA"   , "   ", ""		        ,				    , 1)
    TRCell():New(oSProdMASSA, "PRODUTO"     , "SD3", "Codigo"	    ,				    , 10,,{|| (cAlsProdMASSA)->PRODUTO    } )
    TRCell():New(oSProdMASSA, "NOME"        , "SD3", "Produto"      ,	                , 40,,{|| (cAlsProdMASSA)->NOME       } )
    TRCell():New(oSProdMASSA, "QUANT"	    , "SD3", "Quantidade"	,"@E 999,999,999.99", 15,,{|| (cAlsProdMASSA)->QUANT      } ,"RIGHT",,"RIGHT")
    TRCell():New(oSProdMASSA, "UNID"	    , "SD3", "U.M."	        ,				    , 05,,{|| (cAlsProdMASSA)->UNID       } )
    TRCell():New(oSProdMASSA, "CUNIT"		, "SD3", "Custo Unit."  ,"@E 999,999.9999"  , 10,,{|| (cAlsProdMASSA)->CUNIT      } ,"RIGHT",,"RIGHT")
    TRCell():New(oSProdMASSA, "CUSTO"		, "SD3", "Custo Total"	,"@E 99,999,999.99" , 15,,{|| (cAlsProdMASSA)->CUSTO      } ,"RIGHT",,"RIGHT")
        
    
    //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo do TOTAL CUSTO PRODUгцO MASSA    Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oBreak1 := TRBreak():New(oSProdMASSA,oSProdMASSA:Cell("PRODMASSA"),"TOTAL ------------> : ",.F.)
    TRFunction():New(oSProdMASSA:Cell("QUANT")	,"TOT_QUANT" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSProdMASSA:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.) 


//зддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal dos INSUMOS SORO
//юддддддддддддддддддддддддддддддддддддддддддддд

    oSInsSoro := TRSection():New(oReport, "INSUMOS SORO",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSInsSoro:cAlias := cAlsInsSoro
    oSInsSoro:lHeaderVisible := .T.
    oSInsSoro:SetLeftMargin(02)

    TRCell():New(oSInsSoro, "INSSORO"	, "   ", ""		        ,				        , 1)
    TRCell():New(oSInsSoro, "PRODUTO"	, "SD3", "Produto"	    ,				        , 10)
    TRCell():New(oSInsSoro, "NOME"      , "SD3", "DescriГЦo dos INSUMOS",		        , 40)
    TRCell():New(oSInsSoro, "QUANT"	    , "SD3", "Consumo Grupo","@E 999,999,999.99"    , 15,,          ,"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSInsSoro, "UNID"	    , "SD3", "U.M."	        ,				        , 05)
    TRCell():New(oSInsSoro, "CUNIT"		, "SD3", "Custo Unit."	,"@E 999,999.9999"      , 10,,          ,"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSInsSoro, "CUSTO"		, "SD3", "Custo Total"	,"@E 99,999,999,999.99" , 20,,          ,"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo INSUMOS do relatСrio     Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oBreak1 := TRBreak():New(oSInsSoro,oSInsSoro:Cell("INSSORO"),"TOTAL ------------> : ",.F.)
    TRFunction():New(oSInsSoro:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 99,999,999,999.99",,.F.,.T.,.F.)

//зддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal dos INSUMOS 
//юддддддддддддддддддддддддддддддддддддддддддддд
    oSInsumos := TRSection():New(oReport, "INSUMOS",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSInsumos:cAlias := cAlsINSUMOS
    oSInsumos:lHeaderVisible := .T.
    oSInsumos:SetLeftMargin(02)

    TRCell():New(oSInsumos, "INSUMOS"	, "   ", ""		        ,				        , 1)
    TRCell():New(oSInsumos, "PRODUTO"	, "SD3", "Produto"	    ,				        , 10)
    TRCell():New(oSInsumos, "NOME"      , "SD3", "DescriГЦo dos INSUMOS",		        , 40,, {|| xDescInsumos((cAlsINSUMOS)->DIV,(cAlsINSUMOS)->NOME)  },"LEFT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSInsumos, "QUANT"	    , "SD3", "Consumo Grupo","@E 999,999,999.99"    , 15,, {|| xQtde( (cAlsINSUMOS)->DIV )      },"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSInsumos, "UNID"	    , "SD3", "U.M."	        ,				        , 05)
    TRCell():New(oSInsumos, "CUNIT"		, "SD3", "Custo Unit."	,"@E 999,999.9999"      , 10,, {|| xPreco( (cAlsINSUMOS)->DIV )     },"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSInsumos, "CUSTO"		, "SD3", "Custo Total"	,"@E 99,999,999.99"     , 15,, {|| xCusto( (cAlsINSUMOS)->DIV )     },"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSInsumos, "CUSTOMASSA", "SD3", "Custo kg Massa"	,"@E 999,999.9999"  , 12,,{|| (cAlsINSUMOS)->CUSTO / xProdMassa()  } ,"RIGHT",,"RIGHT")
    IF MV_PAR01 $ '0001/0003/0008' // MUSSARELA/PROVOLONE/REQUEIJцO
        TRCell():New(oSInsumos, "|"	        , "SD3", "|"	        ,				        , 01,, {|| "|"                              },"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
        TRCell():New(oSInsumos, "QTDTOT"    , "SD3", "Consumo TOTAL","@E 999,999,999.99"    , 15,, {|| xConsTotal( (cAlsINSUMOS)->DIV ) },"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    EndIf 
    //TRCell():New(oSInsumos, "UNID"	    , "SD3", "U.M."	        ,				        , 03)

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo INSUMOS do relatСrio     Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    IF MV_PAR01 <> '0010'
        oBreak1 := TRBreak():New(oSInsumos,oSInsumos:Cell("INSUMOS"),"TOTAL ------------> : ",.F.)
        TRFunction():New(oSInsumos:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    EndIF 
        

//зддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal dos GGFs MASSA 
//юддддддддддддддддддддддддддддддддддддддддддддд
    oSGGFMassa := TRSection():New(oReport, "GGFs MASSA",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSGGFMassa:cAlias := cAlsGGFMassa
    oSGGFMassa:lHeaderVisible := .T.
    oSGGFMassa:SetLeftMargin(02)

    TRCell():New(oSGGFMassa, "GGFMASSA"	, "   ", ""		        ,				        , 1)
    TRCell():New(oSGGFMassa, "PRODUTO"	, "SD3", "Produto"	    ,				        , 10)
    TRCell():New(oSGGFMassa, "NOME"     , "SD3", "DescriГЦo"    ,		                , 40,, ,"LEFT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFMassa, "QUANT"	, "SD3", "Consumo Grupo","@E 999,999,999.99"    , 15,, {|| (cAlsGGFMassa)->QUANT * xRatRenda("PERCGRUPO")      },"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFMassa, "UNID"	    , "SD3", "U.M."	        ,				        , 05)
    TRCell():New(oSGGFMassa, "CUNIT"	, "SD3", "Custo Unit."	,"@E 999,999.9999"      , 10,, ,"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFMassa, "CUSTO"	, "SD3", "Custo Total"	,"@E 99,999,999.99"     , 15,, {|| (cAlsGGFMassa)->CUSTO * xRatRenda("PERCGRUPO")      },"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFMassa, "CUSTOMASSA", "SD3", "Custo kg Massa"	,"@E 999,999.9999"  , 12,, {|| (cAlsGGFMassa)->CUSTO / xProdMassa()  } ,"RIGHT",,"RIGHT")

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo INSUMOS do relatСrio     Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oBreak1 := TRBreak():New(oSGGFMassa,oSGGFMassa:Cell("GGFMASSA"),"TOTAL ------------> : ",.F.)
    TRFunction():New(oSGGFMassa:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)



//зддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal dos GGFs GRUPO 
//юддддддддддддддддддддддддддддддддддддддддддддд
    oSGGFGrupo := TRSection():New(oReport, "GGFs ACABADO",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSGGFGrupo:cAlias := cAlsGGFGrupo
    oSGGFGrupo:lHeaderVisible := .T.
    oSGGFGrupo:SetLeftMargin(02)

    TRCell():New(oSGGFGrupo, "GGFMASSA" , "   ", ""		        ,				        , 1)
    TRCell():New(oSGGFGrupo, "PRODUTO"  , "SD3", "Produto"	    ,				        , 10)
    TRCell():New(oSGGFGrupo, "NOME"     , "SD3", "DescriГЦo"    ,		                , 40,, ,"LEFT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFGrupo, "QUANT"    , "SD3", "Consumo Grupo","@E 999,999,999.99"    , 15,, ,"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFGrupo, "UNID"	    , "SD3", "U.M."	        ,				        , 05)
    TRCell():New(oSGGFGrupo, "CUNIT"	, "SD3", "Custo Unit."	,"@E 999,999.9999"      , 10,, ,"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFGrupo, "CUSTO"	, "SD3", "Custo Total"	,"@E 99,999,999.99"     , 15,, ,"RIGHT" ,/*lLineBreak*/,"RIGHT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.F.)
    TRCell():New(oSGGFGrupo, "CUSTOMASSA", "SD3", "Custo kg Massa"	,"@E 999,999.9999"  , 12,, {|| (cAlsGGFGrupo)->CUSTO / xProdMassa()  } ,"RIGHT",,"RIGHT")

    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo INSUMOS do relatСrio     Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oBreak1 := TRBreak():New(oSGGFGrupo,oSGGFGrupo:Cell("GGFMASSA"),"TOTAL ------------> : ",.F.)
    TRFunction():New(oSGGFGrupo:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)



//здддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal do TOTAL DAS EMBALAGENS 
//юдддддддддддддддддддддддддддддддддддддддддддддддддд
    oSEmbalTot := TRSection():New(oReport, "EMBALAGENS TOTAL",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSEmbalTot:cAlias := cAlsEMBTOT
    oSEmbalTot:lHeaderVisible := .T.
    oSEmbalTot:SetLeftMargin(02)

    TRCell():New(oSEmbalTot, "EMBTOT"	    , "   ", ""		        ,				, 1)
    TRCell():New(oSEmbalTot, "PRODUTO"	    , "SD3", "Produto"	    ,				, 10)
    TRCell():New(oSEmbalTot, "NOME"         , "SD3", "DescriГЦo das Embalagens",	, 40)
    TRCell():New(oSEmbalTot, "QUANT"	    , "SD3", "Consumo"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSEmbalTot, "UNID"	        , "SD3", "U.M."	        ,				    , 05)
    TRCell():New(oSEmbalTot, "CUNIT"		, "SD3", "Custo Unit."	,"@E 999,999.9999"  , 10,,,"RIGHT",,"RIGHT")
    TRCell():New(oSEmbalTot, "CUSTO"		, "SD3", "Custo Total"	,"@E 99,999,999.99" , 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSEmbalTot, "CUSTOMASSA"   , "SD3", "Custo kg Massa"	,"@E 999,999.9999"  , 12,, {|| (cAlsEMBTOT)->CUSTO / xProdMassa()  } ,"RIGHT",,"RIGHT")


    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo do TOTAL DAS EMBALAGENS     Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oBreak1 := TRBreak():New(oSEmbalTot,oSEmbalTot:Cell("EMBTOT"),"TOTAL ------------> : ",.F.)
    TRFunction():New(oSEmbalTot:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)


//здддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁCria a sessЦo principal das EMBALAGENS POR PRODUTO
//юдддддддддддддддддддддддддддддддддддддддддддддддддд
    oSEmbal1 := TRSection():New(oReport, "EMBALAGENS POR PRODUTO",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSEmbal1:cAlias := cAlsEMBPROD
    oSEmbal1:lHeaderVisible := .F.
    oSEmbal1:SetLeftMargin(02)
    oSEmbal1:SetPageBreak(.F.)			// Define se salta a pАgina na quebra de seГЦo
    oSEmbal1:SetHeaderSection(.F.)		// Define de imprime cabeГalho das cИlulas na quebra de seГЦo


    TRCell():New(oSEmbal1,"TXTFIXO" ,,,,23,,{|| "Embalagens do Produto: "	},"LEFT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.T.)
    TRCell():New(oSEmbal1,"PRODUTO" ,,,,60,,{|| ALLTRIM( (cAlsEMBPROD)->PRODPA )+" - "+ALLTRIM( (cAlsEMBPROD)->NOMEPA )	},"LEFT" ,/*lLineBreak*/,"LEFT",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,.T.)


    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a sessЦo de Detalhes do relatСrio                 Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oSEmbal2 := TRSection():New(oSEmbal1,"EMBAGENS POR PRODUTO",{"SD3"})
    oSEmbal2:SetHeaderSection(.T.)
    oSEmbal2:SetLeftMargin(05)

    TRCell():New(oSEmbal2, "EMBPROD"    , "   ", ""		        ,				, 1)
    TRCell():New(oSEmbal2, "PRODEMB"    , "SD3", "Produto"	    ,				, 10)
    TRCell():New(oSEmbal2, "NOMEEMB"    , "SD3", "DescriГЦo das Embalagens",	, 40)
    TRCell():New(oSEmbal2, "QUANT"      , "SD3", "Consumo"		,"@E 999,999,999.99", 15,,,"RIGHT",,"RIGHT")
    TRCell():New(oSEmbal2, "UNID"	    , "SD3", "U.M."	        ,				    , 05)
    TRCell():New(oSEmbal2, "CUNIT"		, "SD3", "Custo Unit."	,"@E 999,999.9999"  , 10,,,"RIGHT",,"RIGHT")
    TRCell():New(oSEmbal2, "CUSTO"		, "SD3", "Custo Total"	,"@E 99,999,999.99" , 15,,,"RIGHT",,"RIGHT")


    //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    //ЁCria a regra de Quebra e Totais da SeГЦo do TOTAL DAS EMBALAGENS     Ё
    //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
    oBreak1 := TRBreak():New(oSEmbal2,oSEmbal2:Cell("EMBPROD"),"TOTAL ------------> : ",.F.)
    TRFunction():New(oSEmbal2:Cell("CUSTO")	,"TOT_CUSTO" 	, "SUM", 	 oBreak1,,"@E 999,999,999.99",,.F.,.T.,.F.)
    
Return oReport





/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммм`ммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  ЁREPCP032PRT   ╨Autor  ЁTRELAC      ╨ Data Ё 16/10/2015 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁFunГЦo responsАvel pela execuГЦo das regras de montagem da  ╨╠╠
╠╠╨          Ёquery de busca das informaГУes\impressЦo das mesmas.        ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁQualidade - TRELAC                                           ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function REPCP032PRT(oReport)

Local oSection1		:= oReport:Section(1)
Local oSCustoProd	:= oReport:Section(2)
Local oSPPMassa 	:= oReport:Section(3)
Local oSProdMassa 	:= oReport:Section(4)
Local oSInsSoro		:= oReport:Section(5)
Local oSInsumos		:= oReport:Section(6)
Local oSGGFMassa	:= oReport:Section(7)
Local oSGGFGrupo	:= oReport:Section(8)
Local oSEmbalTot	:= oReport:Section(9)
Local oSEmbal1	    := oReport:Section(10)
Local oSEmbal2	    := oReport:Section(10):Section(1)


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua definiГЦo do Produto PP Leite Padronizado e PP Massa e ProduГЦo Massa
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Do Case
    Case MV_PAR01 $ '0001/0003/0008' // MUSSARELA/PROVOLONE/REQUEIJцO
        cLeitePadron := '99010001'
        cPPMassa     := '99000001'
        IF MV_PAR01 == "0003" // PROVOLONE
            cProdMassa := "('99000001','99000009','99000012','99000020','99000006')"
        Else 
            cProdMassa := "('99000001')"
        EndIf 
    Case MV_PAR01 $ '0002'          // PRATO
        cLeitePadron := '99010002'
        cPPMassa     := '99000002'
        cProdMassa   := "('99000002')"
    Case MV_PAR01 $ '0004'          // PARMESцO
        cLeitePadron := '99010003'
        cPPMassa     := '99000003'
        cProdMassa   := "('99000003')"
    Case MV_PAR01 $ '0005'          // MINAS FRESCAL
        cLeitePadron := '99010004'
        cPPMassa     := '99000004'
        cProdMassa   := "('99000004')"
    Case MV_PAR01 $ '0006'          // MONTANHES
        cLeitePadron := '99010008'
        cPPMassa     := '99000018'
        cProdMassa   := "('99000018')"
    Case MV_PAR01 $ '0007'          // QUEIJO COALHO
        cLeitePadron := '99010007'
        cPPMassa     := '99000017'  
        cProdMassa   := "('99000017')"   
    Case MV_PAR01 $ '0009'          // LEITE CONDENSADO
        cLeitePadron := '99010008'  
 
EndCase 

//cProdMassa := "%" + cProdMassa + "%"

cProdPPMassa := cProdMassa
cProdMassa   := '%' + cProdMassa + '%'

IF MV_PAR01 == '001'
    cREPR := 'RE'
Else
    cREPR := 'PR'
EndIF 

Do Case 
    Case MV_PAR01 == "0003"
        cFilInsumos := "( D3_GRUPO IN ('0003') OR D3_COD IN " + cProdPPMassa +" )"
    
    Case MV_PAR01 == "0008"
        cFilInsumos := "( D3_GRUPO IN ('0008') OR D3_COD IN " + cProdPPMassa +" )"
    
    Case MV_PAR01 == "0010"
        cFilInsumos := "( D3_GRUPO IN ('0010') OR D3_COD IN " + cProdPPMassa +" )"
    
    Case MV_PAR01 == "0011"
        cFilInsumos := "D3_GRUPO IN ('0011')"
    
    Otherwise
        cFilInsumos := "D3_COD IN " + cProdPPMassa
EndCase

cFilInsumos   := '%' + cFilInsumos + '%'


//зддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo dos GRUPO
//юддддддддддддддддддддддддддддддддддддддддддддддддд
BEGIN REPORT QUERY oSection1
	BEGINSQL Alias cAliasTMP1

        SELECT BM_GRUPO GRUPO, BM_DESC NOME
        FROM %table:SBM% 
        WHERE D_E_L_E_T_ = '' 
            AND BM_FILIAL = %xFilial:SBM% 
            AND BM_GRUPO  = %Exp:mv_par01%

        EndSQL
END REPORT QUERY oSection1




//здддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo PRODUгцO DO GRUPO
//юдддддддддддддддддддддддддддддддддддддддддддддддддддд

BEGIN REPORT QUERY oSCustoProd

	BEGINSQL Alias cAlsCUSTOGRP

    SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
            SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1  ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD   = D3.D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3.D3_CF,1,2) = 'PR'
        AND D3.D3_ESTORNO = ' '
        AND D3.D3_OP	 <> ''
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND ( D3.D3_GRUPO   = %Exp:mv_par01% OR (D3.D3_COD = '00990009' AND %Exp:mv_par01% ='0010' ) )
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM
    ORDER BY D3.D3_FILIAL, D3.D3_COD

	EndSQL

END REPORT QUERY oSCustoProd




//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo do PRODUгцO MASSA DOS PRODUTOS PROVOLONE / MONTANHES E PARMESцO
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

BEGIN REPORT QUERY oSProdMassa
    BEGINSQL Alias cAlsProdMASSA

    SELECT D3_FILIAL FILIAL, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND D3.D3_CF IN ('PR0','PR1','DE4')
        AND D3.D3_ESTORNO = ' '
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_COD     IN %Exp:cProdMassa_%
    GROUP BY D3_FILIAL, D3_COD, B1.B1_DESC, D3.D3_UM    
    ORDER BY D3.D3_FILIAL, D3.D3_COD

    EndSQL

END REPORT QUERY oSProdMassa





//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo do CONSUMO DE MASSA
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
BEGIN REPORT QUERY oSPPMassa
    BEGINSQL Alias cAlsPPMASSA

    SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3.D3_CF,1,2) = 'RE'
        AND D3.D3_ESTORNO = ' '
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_COD     = %Exp:cPPMassa%
        AND D3.D3_OP	IN ( SELECT D3_OP FROM SD3010 
                                WHERE D_E_L_E_T_ = ' '  
                                    AND D3_FILIAL = D3.D3_FILIAL 
                                    AND D3_OP <> ' '
                                    AND D3_GRUPO   = %Exp:mv_par01%
                                    AND D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
                                    AND SUBSTRING(D3_CF,1,2) = 'PR' 
                                    AND D3_ESTORNO = '' 
                                    AND D3_OP = D3.D3_OP
                                GROUP BY D3_OP )
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM    
    ORDER BY D3.D3_FILIAL, D3.D3_COD

    EndSQL

END REPORT QUERY oSPPMassa



//зддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo INSUMOS DO SORO
//юддддддддддддддддддддддддддддддддддддддддддддддддд

BEGIN REPORT QUERY oSInsSoro
	BEGINSQL Alias cAlsInsSoro

    SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO			
    FROM %table:SD3% D3
        INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'RE'
        AND D3_ESTORNO = ' '
        AND D3.D3_COD <> 'MANUTENCAO'
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_TIPO NOT IN ('MO','GG','PP','PI','EM','MC')
        AND D3.D3_OP	IN ( SELECT D3_OP FROM %table:SD3% 
                                WHERE D_E_L_E_T_ = ' '  
                                    AND D3_FILIAL = D3.D3_FILIAL 
                                    AND D3_OP <> ' ' 
                                    AND SUBSTRING(D3_CF,1,2) = 'PR' 
                                    AND D3_ESTORNO = '' 
                                    AND D3_OP = D3.D3_OP
                                    AND D3_GRUPO = '%Exp:MV_PAR01%' 
                                    AND '%Exp:MV_PAR01%' = '0010'
                                GROUP BY D3_OP )    
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM    
    ORDER BY D3.D3_FILIAL, D3.D3_COD

	EndSQL

END REPORT QUERY oSInsSoro


//зддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo INSUMOS DO SORO
//юддддддддддддддддддддддддддддддддддддддддддддддддд

BEGIN REPORT QUERY oSGGFMassa 
	BEGINSQL Alias cAlsGGFMassa

    SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO			
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'RE'
        AND D3_ESTORNO = ' '
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_TIPO IN ('MO','GG')
        AND D3.D3_OP	IN ( SELECT D3_OP FROM %table:SD3% 
                                WHERE D_E_L_E_T_ = ' '  
                                    AND D3_FILIAL = D3.D3_FILIAL 
                                    AND D3_OP <> ' ' 
                                    AND SUBSTRING(D3_CF,1,2) = 'PR' 
                                    AND D3_ESTORNO = '' 
                                    AND D3_OP = D3.D3_OP
                                    AND %Exp:cFilInsumos% 
                                GROUP BY D3_OP )    
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM    
    ORDER BY D3.D3_FILIAL, D3.D3_COD

	EndSQL

END REPORT QUERY oSGGFMassa

BEGIN REPORT QUERY oSGGFGrupo
	BEGINSQL Alias cAlsGGFGrupo

    SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO			
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'RE'
        AND D3_ESTORNO = ' '
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_TIPO IN ('MO','GG')
        AND D3.D3_OP	IN ( SELECT D3_OP FROM %table:SD3% 
                                WHERE D_E_L_E_T_ = ' '  
                                    AND D3_FILIAL = D3.D3_FILIAL 
                                    AND D3_OP <> ' ' 
                                    AND SUBSTRING(D3_CF,1,2) = 'PR' 
                                    AND D3_ESTORNO = '' 
                                    AND D3_OP = D3.D3_OP
                                    AND D3_GRUPO = %Exp:MV_PAR01% 
                                GROUP BY D3_OP )    
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM    
    ORDER BY D3.D3_FILIAL, D3.D3_COD

	EndSQL

END REPORT QUERY oSGGFGrupo 



//зддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo dos INSUMOS
//юддддддддддддддддддддддддддддддддддддддддддддддддд

BEGIN REPORT QUERY oSInsumos
	BEGINSQL Alias cAlsINSUMOS


    //PP LEITE PADRONIZADO
    SELECT 1 AS DIV, D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'RE'
        AND D3_ESTORNO = ' '
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_TIPO IN ('PP','PI')
        AND D3.D3_OP <> '' 
        AND D3.D3_COD = %Exp:cLeitePadron%
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM

    UNION ALL
    
    //SсLIDOS - Soro Concentrado
    /*
    SELECT 2 AS DIV, D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, 'KG',
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'DE'
        AND D3_ESTORNO = ' '
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_OP <> '' 
        AND ( D3.D3_COD = '01010002' AND %Exp:mv_par01% NOT IN ('0004','0005','0006','0007') )
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC
    */
    SELECT 2 AS DIV, D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO			
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND D3_CF = 'DE1'
        AND D3_ESTORNO = ' '
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_OP	IN ( SELECT D3_OP FROM %table:SD3% 
                                WHERE D_E_L_E_T_ = ' '  
                                    AND D3_FILIAL = D3.D3_FILIAL 
                                    AND D3_OP <> ' ' 
                                    AND SUBSTRING(D3_CF,1,2) = 'PR' 
                                    AND D3_ESTORNO = '' 
                                    AND D3_OP = D3.D3_OP
                                    AND %Exp:cFilInsumos% 
                                GROUP BY D3_OP )    
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM    

    /*
    UNION ALL 

    //MATERIA GORDA - CREME DE LEITE E SORO
    SELECT 3 AS DIV, D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO			
    FROM %table:SD3% D3
        INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'DE'
        AND D3_ESTORNO = ' '
        AND ( (D3.D3_COD = '99000010' AND %Exp:mv_par01% NOT IN ('0010') ) OR ( D3.D3_COD = '99000011' AND %Exp:mv_par01% NOT IN ('0004','0005','0006','0007','0010') ) )
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_OP <> ''
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM
    */

    /*
    SELECT 3 AS DIV, D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO			
    FROM %table:SD3% D3
        INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'DE'
        AND D3_ESTORNO = ' '
        AND D3.D3_COD IN ('99000010','99000011') 
        AND ( (D3.D3_COD = '99000010' ) OR (D3.D3_COD = '99000011' AND '0001' NOT IN ('0005')) )
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_OP <> ''
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM
    */

    UNION ALL   
    
    //INSUMOS GERAL EXCETO EMBALAGENS
    SELECT 4 AS DIV, D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO			
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'RE'
        AND D3_ESTORNO = ' '
        AND D3.D3_COD <> 'MANUTENCAO'
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_TIPO NOT IN ('MO','GG','PP','PI','EM','PA','MC')
        AND D3.D3_OP	IN ( SELECT D3_OP FROM %table:SD3% 
                                WHERE D_E_L_E_T_ = ' '  
                                    AND D3_FILIAL = D3.D3_FILIAL 
                                    AND D3_OP <> ' ' 
                                    AND SUBSTRING(D3_CF,1,2) = 'PR' 
                                    AND D3_ESTORNO = '' 
                                    AND D3_OP = D3.D3_OP
                                    AND %Exp:cFilInsumos% 
                                GROUP BY D3_OP )    
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM    
    ORDER BY 1, D3.D3_FILIAL, D3.D3_COD

	EndSQL

END REPORT QUERY oSInsumos



//зддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo EMBALAGEM TOTAL
//юддддддддддддддддддддддддддддддддддддддддддддддддд

BEGIN REPORT QUERY oSEmbalTot
	BEGINSQL Alias cAlsEMBTOT

    SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID,
        SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO				
    FROM %table:SD3% D3
        INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD
    WHERE D3.D_E_L_E_T_ = ' '
        AND SUBSTRING(D3_CF,1,2) = 'RE'
        AND D3_ESTORNO = ' '
        AND D3.D3_COD <> 'MANUTENCAO'
        AND D3.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
        AND D3.D3_FILIAL  = %xFilial:SD3%
        AND D3.D3_TIPO IN ('EM')
        AND D3.D3_OP	IN ( SELECT D3_OP FROM %table:SD3% 
                                WHERE D_E_L_E_T_ = ' '  
                                    AND D3_FILIAL = D3.D3_FILIAL 
                                    AND D3_OP <> ' ' 
                                    AND SUBSTRING(D3_CF,1,2) = 'PR' 
                                    AND D3_ESTORNO = '' 
                                    AND D3_OP = D3.D3_OP
                                    AND D3_GRUPO = %Exp:mv_par01%
                                GROUP BY D3_OP )
    GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM
    ORDER BY D3.D3_FILIAL, D3.D3_COD

	EndSQL

END REPORT QUERY oSEmbalTot



//здддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁEfetua montagem da query da sessЦo EMBALAGEM PRODUTO
//юдддддддддддддддддддддддддддддддддддддддддддддддддддд

BEGIN REPORT QUERY oSEmbal1
	BEGINSQL Alias cAlsEMBPROD

SELECT D3.D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3.D3_COD PRODPA, B1.B1_DESC NOMEPA, R.D3_COD PRODEMB, B1R.B1_DESC NOMEEMB,			
	   SUM(R.D3_QUANT) QUANT, R.D3_UM UNID,
	   SUM(R.D3_CUSTO1)/SUM(R.D3_QUANT) CUNIT, SUM(R.D3_CUSTO1) CUSTO
FROM %table:SD3% D3
	INNER JOIN %table:SD3% R   ON R.D_E_L_E_T_   = ' ' AND R.D3_FILIAL = D3.D3_FILIAL AND SUBSTRING(R.D3_CF,1,2) = 'RE' AND R.D3_OP = D3.D3_OP
	INNER JOIN %table:SB1% B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD   = D3.D3_COD
	INNER JOIN %table:SB1% B1R ON B1R.D_E_L_E_T_ = ' ' AND B1R.B1_COD  = R.D3_COD
WHERE D3.D_E_L_E_T_ = ' '
	AND SUBSTRING(D3.D3_CF,1,2) = 'PR'
	AND D3.D3_ESTORNO = ' '
	AND R.D3_EMISSAO BETWEEN  %Exp:mv_par02% AND %Exp:mv_par03%
	AND D3.D3_FILIAL  = %xFilial:SD3%
	AND D3.D3_TIPO IN ('PA')
	AND D3.D3_GRUPO = %Exp:mv_par01%
	AND R.D3_ESTORNO = ''
	AND R.D3_TIPO = 'EM'

GROUP BY D3.D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3.D3_COD, B1.B1_DESC, R.D3_UM, R.D3_COD, B1R.B1_DESC
ORDER BY D3.D3_COD, R.D3_COD 

	EndSQL

END REPORT QUERY oSEmbal1



//здддддддддддддддддддддддддддддддддддддддд
//Ё Define relacionamento com a SeГЦo Pai  Ё
//юдддддддддддддддддддддддддддддддддддддддд
oSEmbal2:SetParentQuery()
oSEmbal2:SetParentFilter({|cParam| (cAlsEMBPROD)->PRODPA == cParam},{|| (cAlsEMBPROD)->PRODPA })

//здддддддддддддддддддддддддддддддддддддддд
//ЁSeta regra de contador do processamentoЁ
//юдддддддддддддддддддддддддддддддддддддддд
oReport:SetMeter((cAlsINSUMOS)->(RECCOUNT()))
oReport:SetMeter((cAlsGGFMassa)->(RECCOUNT()))

//зддддддддддддддддддддддддддддддддддддддддддддд
//ЁExecuta a impressЦo das sessУes do relatСrioЁ
//юддддддддддддддддддддддддддддддддддддддддддддд

oSection1:Print()
oSCustoProd:Print()
oSPPMassa:Print()
oSProdMassa:Print()
oSInsSoro:Print()
oSInsumos:Print()
oSGGFMassa:Print()
oSGGFGrupo:Print()
oSEmbalTot:Print()
//oReport:EndPage() //Quebra pАgina
oSEmbal1:Print()
oSEmbal2:Print()

oReport:SkipLine(10)

Return


//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё DEFINIгцO DA DESCRIгAO DO INSUMOS           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xDescInsumos(nDiv,cDescProd)

Local cDesc := ""


Do Case
    Case nDiv == 1
        cDesc := ALLTRIM(cDescProd)
    Case nDiv == 2
        //cDesc := "(-) SсLIDOS"
        cDesc := "(-) " + ALLTRIM(cDescProd)
    Case nDiv == 3
        cDesc := "(-) MAT.GORDA-" + ALLTRIM(cDescProd)
    Case nDiv == 4
        cDesc := ALLTRIM(cDescProd)
EndCase

Return cDesc


//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CALCULO O CUSTO MEDIO DO CUSTO TOTAL DO GRUPO           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xTotGrupo(cTipo)

Local nRetGrupo   := 0
Local cCustoGrp  := GetNextAlias()

	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL para buscar os dados                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	cQueryTot := " SELECT D3_FILIAL FILIAL, SUM(D3.D3_QUANT) QUANT, SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO " + CRLF
	cQueryTot += " FROM "+RetSqlName("SD3")+" D3 "		 + CRLF
	cQueryTot += " WHERE D3.D_E_L_E_T_ = ' ' " + CRLF
    cQueryTot += " 	AND D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
	cQueryTot += " 	AND SUBSTRING(D3.D3_CF,1,2) = 'PR' " + CRLF
	cQueryTot += " 	AND D3_ESTORNO = ' '  " + CRLF
	cQueryTot += " 	AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"'	" + CRLF
	IF MV_PAR01 == '0010'
        cQueryTot += "		AND ( D3_GRUPO 	= '"+MV_PAR01+"' OR D3_COD =  '00990009' ) " + CRLF
    Else
        cQueryTot += "		AND D3_GRUPO 	= '"+MV_PAR01+"' " + CRLF
    EndIf 
	cQueryTot += "		AND D3_OP	 <> ''   " + CRLF
	cQueryTot += "	GROUP BY D3_FILIAL  " + CRLF

	//дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cCustoGrp := GetNextAlias()
	TCQuery ChangeQuery( cQueryTot ) NEW Alias (cCustoGrp)

    dbSelectArea(cCustoGrp)

    If cTipo == "CUNIT"
	    nRetGrupo := (cCustoGrp)->CUNIT
    ElseIf cTipo == "CUSTO"
	    nRetGrupo := (cCustoGrp)->CUSTO
    ElseIf cTipo == "QUANT"
	    nRetGrupo := (cCustoGrp)->QUANT 
    EndIf 

	dbCloseArea()


Return nRetGrupo



//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CALCULO DA PRODUгцO DO PP MASSA           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xProdMassa()

Local nQtdeMassa  := 0

	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL para buscar os dados                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

    cQuery := " SELECT D3_FILIAL FILIAL, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID, " + CRLF
    cQuery += "	    SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO " + CRLF
    cQuery += "	FROM "+RetSqlName("SD3")+" D3 " + CRLF
    cQuery += "	    INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD " + CRLF
    cQuery += "	WHERE D3.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "	    AND D3.D3_CF IN ('PR0','PR1','DE4') " + CRLF
    cQuery += "	    AND D3.D3_ESTORNO = ' ' " + CRLF
    cQuery += "	    AND D3.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQuery += "	    AND D3.D3_FILIAL  = '"+xFilial( "SD3" )+"' " + CRLF
    cQuery += "	    AND D3.D3_COD    IN "+cProdPPMassa+" " + CRLF
    cQuery += "	GROUP BY D3_FILIAL, D3_COD, B1.B1_DESC, D3.D3_UM   " + CRLF
    cQuery += "	ORDER BY D3.D3_FILIAL, D3.D3_COD " + CRLF        
   

    //дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cAlsProdM := GetNextAlias()
	TCQuery ChangeQuery( cQuery ) NEW Alias (cAlsProdM)

    dbSelectArea(cAlsProdM)

	nQtdeMassa := (cAlsProdM)->QUANT

	dbCloseArea()


Return nQtdeMassa


//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CALCULO DO CONSUMO DO PP MASSA           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xPPMassa()

Local nQtdeMassa  := 0

	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL para buscar os dados                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

    cQuery := " SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT, D3.D3_UM UNID, " + CRLF
    cQuery += "	    SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO " + CRLF
    cQuery += "	FROM "+RetSqlName("SD3")+" D3 " + CRLF
    cQuery += "	    INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD " + CRLF
    cQuery += "	WHERE D3.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "	    AND SUBSTRING(D3.D3_CF,1,2) = 'RE' " + CRLF
    cQuery += "	    AND D3.D3_ESTORNO = ' ' " + CRLF
    cQuery += "	    AND D3.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQuery += "	    AND D3.D3_FILIAL  = '"+xFilial( "SD3" )+"' " + CRLF
    cQuery += "	    AND D3.D3_COD     = '"+cPPMassa+"' " + CRLF
    cQuery += "	    AND D3.D3_OP	IN ( SELECT D3_OP FROM "+RetSqlName("SD3")+" D3 " + CRLF
    cQuery += "	                            WHERE D_E_L_E_T_ = ' '  " + CRLF
    cQuery += "	                                AND D3_FILIAL            = D3.D3_FILIAL " + CRLF
    cQuery += "	                                AND D3_OP                <> ' ' " + CRLF
    cQuery += "	                                AND D3_OP                = D3.D3_OP " + CRLF    
    cQuery += "	                                AND SUBSTRING(D3_CF,1,2) = 'PR' " + CRLF
    cQuery += "	                                AND D3_GRUPO             = '"+MV_PAR01+"' " + CRLF
    cQuery += "	                                AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQuery += "	                                AND D3_ESTORNO = '' " + CRLF
    cQuery += "	                            GROUP BY D3_OP ) " + CRLF
    cQuery += "	GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC, D3.D3_UM   " + CRLF
    cQuery += "	ORDER BY D3.D3_FILIAL, D3.D3_COD " + CRLF

    //дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cAlsPPMASSA := GetNextAlias()
	TCQuery ChangeQuery( cQuery ) NEW Alias (cAlsPPMASSA)

    dbSelectArea(cAlsPPMASSA)

	nQtdeMassa := (cAlsPPMASSA)->QUANT

	dbCloseArea()


Return nQtdeMassa




//дздддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё RELAгцO DOS PRODUTOS MPs CONSUMIDOS NO PP MASSA MUSSARELA - 99000001 Ё
//
// Utilizado para selecionar os Produtos que deverЦo considerar Rateio
// nos INSUMOS dos Grupos Mussarela/Provolone e RequeijЦo
//
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xMPPPMassa()

//Local nQtdeMassa    := 0
Local cMPPPMassa    := ""

	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL para buscar os dados                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

    cQuery := " SELECT D3_FILIAL FILIAL, B1.B1_TIPO TIPO, B1.B1_GRUPO, D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3.D3_QUANT) QUANT " + CRLF
    cQuery += "	FROM "+RetSqlName("SD3")+" D3 " + CRLF
    cQuery += "	    INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD " + CRLF
    cQuery += "	WHERE D3.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "	    AND SUBSTRING(D3.D3_CF,1,2) = 'RE' " + CRLF
    cQuery += "	    AND D3.D3_ESTORNO = ' ' " + CRLF
    cQuery += "	    AND D3.D3_COD <> 'MANUTENCAO' " + CRLF    
    cQuery += "	    AND D3.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQuery += "	    AND D3.D3_FILIAL  = '"+xFilial( "SD3" )+"' " + CRLF
    cQuery += "	    AND D3.D3_TIPO NOT IN ('MO','GG','PP','PI','EM','PA') " + CRLF
    cQuery += "	    AND D3.D3_OP	IN ( SELECT D3_OP FROM "+RetSqlName("SD3")+" D3 " + CRLF
    cQuery += "	                            WHERE D_E_L_E_T_ = ' '  " + CRLF
    cQuery += "	                                AND D3_FILIAL            = D3.D3_FILIAL " + CRLF
    cQuery += "	                                AND D3_OP                <> ' ' " + CRLF
    cQuery += "	                                AND D3_OP                = D3.D3_OP " + CRLF    
    cQuery += "	                                AND SUBSTRING(D3_CF,1,2) = 'PR' " + CRLF
    cQuery += "	                                AND D3_COD IN ('99000001')  " + CRLF
    cQuery += "	                                AND D3_ESTORNO = '' " + CRLF
    cQuery += "	                            GROUP BY D3_OP ) " + CRLF
    cQuery += "	GROUP BY D3_FILIAL, B1.B1_TIPO, B1.B1_GRUPO, D3_COD, B1.B1_DESC  " + CRLF
    cQuery += "	ORDER BY D3.D3_FILIAL, D3.D3_COD " + CRLF

    //дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cAlsMPPPMASSA := GetNextAlias()
	TCQuery ChangeQuery( cQuery ) NEW Alias (cAlsMPPPMASSA)

    dbSelectArea(cAlsMPPPMASSA)
	(cAlsMPPPMASSA)->(dbGoTop())
	While !(cAlsMPPPMASSA)->(EOF())

        cMPPPMassa += "/"
        cMPPPMassa += ALLTRIM( (cAlsMPPPMASSA)->PRODUTO )

        (cAlsMPPPMASSA)->(dbSkip())

    EndDo

	dbCloseArea()


Return cMPPPMassa


//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CALCULO DO PERCENTUAL DA RENDA MASSA MUSSARELA/POVOLONE/REQUEIJцO Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xRatRenda(cTipoPerc)

Local nPercRenda    := 0
Local cQtdGrupo     := GetNextAlias()
Local cQtdLeite     := GetNextAlias()
Local nQtdLeite     := 0
Local nQtdTotal     := 0
Local nQtdeGrupo    := 0
Local nRet          := 0


    //*****************************************
    // CONSUMO (RE) DO PP LEITE PADRONIZADO
    //*****************************************
    cQryLeite := "SELECT D3_FILIAL FILIAL, SUM(D3.D3_QUANT) QUANT " + CRLF 
    cQryLeite += "FROM "+RetSqlName("SD3")+" D3  " + CRLF
    cQryLeite += "    INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD  " + CRLF
    cQryLeite += "WHERE D3.D_E_L_E_T_ = ' '  " + CRLF
    cQryLeite += "    AND SUBSTRING(D3_CF,1,2) = 'RE'  " + CRLF
    cQryLeite += "    AND D3_ESTORNO = ' '  " + CRLF
    cQryLeite += "    AND D3.D3_EMISSAO BETWEEN  '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"'  " + CRLF
    cQryLeite += "    AND D3.D3_FILIAL  = '"+xFilial( "SD3" )+"'  " + CRLF
    cQryLeite += "    AND D3.D3_TIPO IN ('PP','PI') " + CRLF
    cQryLeite += "    AND D3.D3_COD = '"+cLeitePadron+"' " + CRLF
    cQryLeite += "    AND D3.D3_OP <> ' ' " + CRLF
    cQryLeite += " GROUP BY D3_FILIAL " + CRLF

	//дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cQtdLeite := GetNextAlias()
	TCQuery ChangeQuery( cQryLeite ) NEW Alias (cQtdLeite)

    dbSelectArea(cQtdLeite)

    nQtdLeite   := (cQtdLeite)->QUANT

	(cQtdLeite)->(dbCloseArea())

	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁCONSUMO (RE) DO PP MASSA CONFORME CADA GRUPO INFORMADO   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	cQryMassa := " SELECT D3R.D3_FILIAL FILIAL,  D3P.D3_GRUPO GRUPO, D3R.D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3R.D3_QUANT) QUANT, D3R.D3_UM UNID, " + CRLF
    cQryMassa += "      SUM(D3R.D3_CUSTO1)/SUM(D3R.D3_QUANT) CUNIT, SUM(D3R.D3_CUSTO1) CUSTO " + CRLF
    cQryMassa += " FROM "+RetSqlName("SD3")+" D3R "  + CRLF
    cQryMassa += "      INNER JOIN "+RetSqlName("SB1")+" B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD = D3R.D3_COD "  + CRLF
    cQryMassa += "      INNER JOIN "+RetSqlName("SD3")+" D3P ON D3P.D_E_L_E_T_ = ' ' AND D3P.D3_OP = D3R.D3_OP AND D3P.D3_FILIAL = D3R.D3_FILIAL "  + CRLF
	cQryMassa += " WHERE D3R.D_E_L_E_T_ = ' ' " + CRLF
    cQryMassa += " 	    AND D3R.D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
	cQryMassa += " 	    AND SUBSTRING(D3R.D3_CF,1,2) = 'RE' " + CRLF
	cQryMassa += " 	    AND D3R.D3_ESTORNO = ' '  " + CRLF
    cQryMassa += " 	    AND D3R.D3_OP <> ' '  "     + CRLF
	cQryMassa += " 	    AND D3R.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"'	" + CRLF
    cQryMassa += " 	    AND D3R.D3_COD = '"+cPPMassa+"' " + CRLF
    cQryMassa += " 	    AND SUBSTRING(D3P.D3_CF,1,2) = 'PR' " + CRLF
    cQryMassa += " 	    AND D3P.D3_ESTORNO = ' '  " + CRLF
	cQryMassa += " GROUP BY D3R.D3_FILIAL, D3P.D3_GRUPO, D3R.D3_COD, B1.B1_DESC, D3R.D3_UM   " + CRLF


	//дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cQtdGrupo := GetNextAlias()
	TCQuery ChangeQuery( cQryMassa ) NEW Alias (cQtdGrupo)

    dbSelectArea(cQtdGrupo)
	(cQtdGrupo)->(dbGoTop())
	While !(cQtdGrupo)->(EOF())

        nQtdTotal += (cQtdGrupo)->QUANT

        IF MV_PAR01 == '0003'
            cGrupo := '9900' 
        Else 
            cGrupo := MV_PAR01 
        EndIf 

        If (cQtdGrupo)->GRUPO == cGrupo
            nQtdeGrupo := (cQtdGrupo)->QUANT
        EndIf 

        (cQtdGrupo)->(dbSkip())

    EndDo

	(cQtdGrupo)->(dbCloseArea())

    //********************************************
    //DEFINIгцO DOS VALORES PARA AS VARIаVEIS
    //********************************************
    IF MV_PAR01 $ '0004/0006' // PARMESцO E MONTANHES
        nQtdeGrupo := xProdMassa()
        nQtdTotal  := xProdMassa()
    EndIF 
    nPercGrupo := (nQtdeGrupo / nQtdTotal)
    nParteGrp  := nQtdLeite * nPercGrupo
    IF MV_PAR01 == "0010"
        nPercRenda := (cAlsINSsoro)->QUANT / xTotGrupo("QUANT")   //prod. + compra concentrado 01010004 / produГЦo total
    Else
        nPercRenda := (nParteGrp / nQtdeGrupo )
    EndIf 

    IF cTipoPerc == "PERCGRUPO"
        nRet := nPercGrupo
    ElseIf cTipoPerc == "PERCPARTE"
        nRet := nParteGrp
    ElseIf cTipoPerc == "PERCRENDA"
        nRet := nPercRenda
    ElseIf cTipoPerc == "QTDGRUPO"
        nRet := nQtdeGrupo    
    EndIf  

Return nRet

//xRatRenda("QTDGRUPO") * xRatRenda("PERCRENDA")
//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CALCULO RATEIO SOLIDOS 01010004 PARA MUSSARELA/PROVOLONE/REQUEIJцO/PRATO Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xRatSolido()

Local nQtdeGrupo    := 0
//Local nQtdeTotal    := 0
Local cGrupo        := MV_PAR01
Local cSolTot       := GetNextAlias()
Local cSolGrp       := GetNextAlias()

Do Case
    Case MV_PAR01 $ '0001/0003/0008' // MUSSARELA/PROVOLONE/REQUEIJцO
        cPPMassa     := '99000001'
    Case MV_PAR01 $ '0002'           // PRATO
        cPPMassa     := '99000002'
EndCase

If MV_PAR01 == "0003" //PROVOLONE
    cGrupo  := "9900"
EndIf 

//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁMonta consulta SQL TOTAL PRODUгцO MASSA                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
cQueryTotSol := " SELECT D3R.D3_FILIAL FILIAL, SUM(D3R.D3_QUANT) QUANT " + CRLF
cQueryTotSol += " FROM "+RetSqlName("SD3")+" D3R  " + CRLF
cQueryTotSol += "       INNER JOIN "+RetSqlName("SB1")+" B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD = D3R.D3_COD " + CRLF
cQueryTotSol += "       INNER JOIN "+RetSqlName("SD3")+" D3P ON D3P.D_E_L_E_T_ = ' ' AND D3P.D3_OP = D3R.D3_OP AND D3P.D3_FILIAL = D3R.D3_FILIAL   " + CRLF
cQueryTotSol += " WHERE D3R.D_E_L_E_T_ = ' ' " + CRLF
cQueryTotSol += "     	AND D3R.D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
cQueryTotSol += "     	AND ( SUBSTRING(D3R.D3_CF,1,2) = 'RE' OR D3R.D3_CF = 'RE4' ) " + CRLF
cQueryTotSol += "     	AND D3R.D3_ESTORNO = ' '  " + CRLF
cQueryTotSol += "     	AND D3R.D3_OP <> ' ' " + CRLF
cQueryTotSol += "     	AND D3R.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
cQueryTotSol += "     	AND D3R.D3_COD  IN ('99000001','99000002') " + CRLF
cQueryTotSol += "     	AND SUBSTRING(D3P.D3_CF,1,2) = 'PR' " + CRLF
cQueryTotSol += "     	AND D3P.D3_ESTORNO = ' '  " + CRLF
cQueryTotSol += " GROUP BY D3R.D3_FILIAL " + CRLF

 
//дзддддддддддддддддддддддд
//ЁExecuta consulta SQL   Ё
//юдддддддддддддддддддддддд
cSolTot := GetNextAlias()
TCQuery ChangeQuery( cQueryTotSol ) NEW Alias (cSolTot)


//дздддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁMonta consulta SQL TOTAL PRODUгцO MASSA POR GRUPO MUSSARELA/PRATO/PROVOLONE/REQUEIJцO Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
/*
cQrySolGrp := " SELECT D3R.D3_FILIAL FILIAL, SUM(D3R.D3_QUANT) QUANT " + CRLF
cQrySolGrp += " FROM "+RetSqlName("SD3")+" D3R  " + CRLF
cQrySolGrp += "       INNER JOIN "+RetSqlName("SB1")+" B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD = D3R.D3_COD " + CRLF
cQrySolGrp += "       INNER JOIN "+RetSqlName("SD3")+" D3P ON D3P.D_E_L_E_T_ = ' ' AND D3P.D3_OP = D3R.D3_OP AND D3P.D3_FILIAL = D3R.D3_FILIAL   " + CRLF
cQrySolGrp += " WHERE D3R.D_E_L_E_T_ = ' ' " + CRLF
cQrySolGrp += "     	AND D3R.D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
cQrySolGrp += "     	AND ( SUBSTRING(D3R.D3_CF,1,2) = 'RE' OR D3R.D3_CF = 'RE4' ) " + CRLF
cQrySolGrp += "     	AND D3R.D3_ESTORNO = ' '  " + CRLF
cQrySolGrp += "     	AND D3R.D3_OP <> ' ' " + CRLF
cQrySolGrp += "     	AND D3R.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
cQrySolGrp += "     	AND D3R.D3_COD  = '"+cPPMassa+"' " + CRLF
IF MV_PAR01 <> "0002"
    cQrySolGrp += "     	AND D3P.D3_GRUPO = '"+cGrupo+"' " + CRLF
EndIf 
cQrySolGrp += "     	AND SUBSTRING(D3P.D3_CF,1,2) = 'PR' " + CRLF
cQrySolGrp += "     	AND D3P.D3_ESTORNO = ' '  " + CRLF
cQrySolGrp += " GROUP BY D3R.D3_FILIAL " + CRLF
*/

cQrySolGrp := " SELECT D3R.D3_FILIAL FILIAL, " + CRLF
cQrySolGrp += "       CASE " + CRLF
cQrySolGrp += "           WHEN D3P.D3_GRUPO = '9900' AND D3R.D3_COD = '99000001' THEN '0003' " + CRLF
cQrySolGrp += "           WHEN D3R.D3_COD = '99000002' THEN '0002' ELSE D3P.D3_GRUPO END AS GRUPO,  " + CRLF
cQrySolGrp += "           D3R.D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3R.D3_QUANT) QUANT " + CRLF
cQrySolGrp += " FROM "+RetSqlName("SD3")+" D3R  " + CRLF
cQrySolGrp += "       INNER JOIN "+RetSqlName("SB1")+" B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD = D3R.D3_COD " + CRLF
cQrySolGrp += "       INNER JOIN "+RetSqlName("SD3")+" D3P ON D3P.D_E_L_E_T_ = ' ' AND D3P.D3_OP = D3R.D3_OP AND D3P.D3_FILIAL = D3R.D3_FILIAL   " + CRLF
cQrySolGrp += " WHERE D3R.D_E_L_E_T_ = ' ' " + CRLF
cQrySolGrp += "     	AND D3R.D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
cQrySolGrp += "     	AND ( SUBSTRING(D3R.D3_CF,1,2) = 'RE' OR D3R.D3_CF = 'RE4' ) " + CRLF
cQrySolGrp += "     	AND D3R.D3_ESTORNO = ' '  " + CRLF
cQrySolGrp += "     	AND D3R.D3_OP <> ' ' " + CRLF
cQrySolGrp += "     	AND D3R.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
cQrySolGrp += "     	AND D3R.D3_COD  IN ('99000001','99000002') " + CRLF
cQrySolGrp += "     	AND SUBSTRING(D3P.D3_CF,1,2) = 'PR' " + CRLF
cQrySolGrp += "     	AND D3P.D3_ESTORNO = ' '  " + CRLF
cQrySolGrp += " GROUP BY D3R.D3_FILIAL, D3P.D3_GRUPO, D3R.D3_COD, B1.B1_DESC " + CRLF
cQrySolGrp += " ORDER BY D3R.D3_FILIAL, D3P.D3_GRUPO " + CRLF

//дзддддддддддддддддддддддд
//ЁExecuta consulta SQL   Ё
//юдддддддддддддддддддддддд
cSolGrp := GetNextAlias()
TCQuery ChangeQuery( cQrySolGrp ) NEW Alias (cSolGrp)

    dbSelectArea(cSolGrp)
	(cSolGrp)->(dbGoTop())
	While !(cSolGrp)->(EOF())

        If (cSolGrp)->GRUPO == MV_PAR01 
            nQtdeGrupo += (cSolGrp)->QUANT
        EndIf 

        (cSolGrp)->(dbSkip())

    EndDo

    nPerGrupo := nQtdeGrupo / (cSolTot)->QUANT 

(cSolTot)->(dbCloseArea())
(cSolGrp)->(dbCloseArea())


/*

	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL para buscar os dados                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	cQuery := " SELECT D3_FILIAL FILIAL, D3.D3_GRUPO GRUPO, " + CRLF
    cQuery += "     CASE WHEN D3.D3_GRUPO = '0008' THEN SUM(D3.D3_QUANT) * 0.200 ELSE SUM(D3.D3_QUANT) END AS QUANT, " + CRLF
    cQuery += "     SUM(D3.D3_CUSTO1)/SUM(D3.D3_QUANT) CUNIT, SUM(D3.D3_CUSTO1) CUSTO " + CRLF
    cQuery += " FROM "+RetSqlName("SD3")+" D3 "		 + CRLF
	cQuery += " WHERE D3.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " 	AND D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
	cQuery += " 	AND SUBSTRING(D3.D3_CF,1,2) = 'PR' " + CRLF
	cQuery += " 	AND D3_ESTORNO = ' '  " + CRLF
	cQuery += " 	AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"'	" + CRLF
	//cQuery += "		AND D3_GRUPO IN ('0001','0003','0008','0002') " + CRLF
    IF  MV_PAR01 $ '0001/0003/0008' // MUSSARELA/PROVOLONE/REQUEIJцO
        cQuery += "		AND D3_GRUPO IN ('0001','0003','0008') " + CRLF 
    Else
        cQuery += "		AND D3_GRUPO IN ('0001','0002','0003','0004','0006','0008') " + CRLF 
    EndIf 
	cQuery += "		AND D3_OP	 <> ''   " + CRLF
	cQuery += "	GROUP BY D3_FILIAL, D3_GRUPO  " + CRLF

	//дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cRatSolido := GetNextAlias()
	TCQuery ChangeQuery( cQuery ) NEW Alias (cRatSolido)

    dbSelectArea(cRatSolido)
	(cRatSolido)->(dbGoTop())
	While !(cRatSolido)->(EOF())

        nQtdeTotal += (cRatSolido)->QUANT

        If (cRatSolido)->GRUPO == MV_PAR01 
            nQtdeGrupo := (cRatSolido)->QUANT
        EndIf 

        (cRatSolido)->(dbSkip())

    EndDo

    nPerGrupo := nQtdeGrupo / nQtdeTotal

	dbCloseArea()
*/

Return nPerGrupo 



//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CALCULO RATEIO DA MATиRIA GORDA - CREME DE LEITE E SORO (99000010 / 99000011) Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xRatMG()

Local nQtdeTotal    := 0
//Local nQtdeGrupo    := 0
Local nPerGrupo     := 0
Local cPPMassa      := ""
Local cGrupo        := MV_PAR01
Local cTOTMG        := GetNextAlias()
Local cProdGrp      := GetNextAlias()

Do Case
    Case MV_PAR01 $ '0001/0003/0008'          // MUSSARELA/PROVOLONE/REQUEIJцO
        cPPMassa     := '99000001'
    Case MV_PAR01 $ '0002'          // PRATO
        cPPMassa     := '99000002'
    Case MV_PAR01 $ '0004'          // PARMESцO
        cPPMassa     := '99000003'
    Case MV_PAR01 $ '0005'          // MINAS FRESCAL
        cPPMassa     := '99000004'
    Case MV_PAR01 $ '0006'          // MONTANHES
        cPPMassa     := '99000018'
    Case MV_PAR01 $ '0007'          // QUEIJO COALHO
        cPPMassa     := '99000017'     
EndCase

If MV_PAR01 == "0003" //PROVOLONE
    cGrupo  := "9900"
EndIf 


//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁMonta consulta SQL TOTAL PRODUгцO MASSA                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

IF ALLTRIM((cAlsINSUMOS)->PRODUTO) == '99000010'
    cQueryTOTMG := " SELECT D3R.D3_FILIAL FILIAL, SUM(D3R.D3_QUANT) QUANT " + CRLF
    cQueryTOTMG += " FROM "+RetSqlName("SD3")+" D3R  " + CRLF
    cQueryTOTMG += "       INNER JOIN "+RetSqlName("SB1")+" B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD = D3R.D3_COD " + CRLF
    cQueryTOTMG += "       INNER JOIN "+RetSqlName("SD3")+" D3P ON D3P.D_E_L_E_T_ = ' ' AND D3P.D3_OP = D3R.D3_OP AND D3P.D3_FILIAL = D3R.D3_FILIAL   " + CRLF
    cQueryTOTMG += " WHERE D3R.D_E_L_E_T_ = ' ' " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
    cQueryTOTMG += "     	AND ( SUBSTRING(D3R.D3_CF,1,2) = 'RE' OR D3R.D3_CF = 'RE4' ) " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_ESTORNO = ' '  " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_OP <> ' ' " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_COD  IN ('99000001','99000002') " + CRLF
    cQueryTOTMG += "     	AND SUBSTRING(D3P.D3_CF,1,2) = 'PR' " + CRLF
    cQueryTOTMG += "     	AND D3P.D3_ESTORNO = ' '  " + CRLF
    cQueryTOTMG += " GROUP BY D3R.D3_FILIAL " + CRLF
    cQueryTOTMG += "  " + CRLF
    cQueryTOTMG += "  UNION ALL " + CRLF
    cQueryTOTMG += "   " + CRLF
    cQueryTOTMG += " SELECT D3_FILIAL FILIAL, SUM(D3.D3_QUANT) QUANT " + CRLF
    cQueryTOTMG += " FROM "+RetSqlName("SD3")+" D3 "		 + CRLF
    cQueryTOTMG += " WHERE D3.D_E_L_E_T_ = ' ' " + CRLF
    cQueryTOTMG += " 	AND D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
    cQueryTOTMG += " 	AND D3.D3_CF IN ('PR0','PR1','RE4') " + CRLF
    cQueryTOTMG += " 	AND D3_ESTORNO = ' '  " + CRLF
    cQueryTOTMG += " 	AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"'	" + CRLF
    cQueryTOTMG += "	AND D3.D3_COD  IN ('99000003','99000004','99000017','99000018') " + CRLF
    cQueryTOTMG += " GROUP BY D3_FILIAL " + CRLF
Else 
    cQueryTOTMG := " SELECT D3R.D3_FILIAL FILIAL, SUM(D3R.D3_QUANT) QUANT " + CRLF
    cQueryTOTMG += " FROM "+RetSqlName("SD3")+" D3R  " + CRLF
    cQueryTOTMG += "       INNER JOIN "+RetSqlName("SB1")+" B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD = D3R.D3_COD " + CRLF
    cQueryTOTMG += "       INNER JOIN "+RetSqlName("SD3")+" D3P ON D3P.D_E_L_E_T_ = ' ' AND D3P.D3_OP = D3R.D3_OP AND D3P.D3_FILIAL = D3R.D3_FILIAL   " + CRLF
    cQueryTOTMG += " WHERE D3R.D_E_L_E_T_ = ' ' " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
    cQueryTOTMG += "     	AND ( SUBSTRING(D3R.D3_CF,1,2) = 'RE' OR D3R.D3_CF = 'RE4' ) " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_ESTORNO = ' '  " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_OP <> ' ' " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQueryTOTMG += "     	AND D3R.D3_COD  IN ('99000001','99000002') " + CRLF
    cQueryTOTMG += "     	AND SUBSTRING(D3P.D3_CF,1,2) = 'PR' " + CRLF
    cQueryTOTMG += "     	AND D3P.D3_ESTORNO = ' '  " + CRLF
    cQueryTOTMG += " GROUP BY D3R.D3_FILIAL " + CRLF
EndIf 

//дзддддддддддддддддддддддд
//ЁExecuta consulta SQL   Ё
//юдддддддддддддддддддддддд
cTOTMG := GetNextAlias()
TCQuery ChangeQuery( cQueryTOTMG ) NEW Alias (cTOTMG)

dbSelectArea(cTOTMG)
(cTOTMG)->(dbGoTop())
While !(cTOTMG)->(EOF())

    nQtdeTotal += (cTOTMG)->QUANT

    (cTOTMG)->(dbSkip())

EndDo


IF MV_PAR01 $ '0001/0003/0008' // MUSSARELA/PROVOLONE/REQUEIJцO
	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL TOTAL PRODUгцO MASSA POR GRUPO MUSSARELA/PROVOLONE/REQUEIJцO Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	cQueryMG := " SELECT D3R.D3_FILIAL FILIAL,  " + CRLF
    cQueryMG += "     	CASE WHEN D3P.D3_GRUPO = '9900' THEN '0003' ELSE D3P.D3_GRUPO END AS GRUPO, " + CRLF
    cQueryMG += "     	D3R.D3_COD PRODUTO, B1.B1_DESC NOME, SUM(D3R.D3_QUANT) QUANT " + CRLF
    cQueryMG += " FROM "+RetSqlName("SD3")+" D3R  " + CRLF
    cQueryMG += "       INNER JOIN "+RetSqlName("SB1")+" B1  ON B1.D_E_L_E_T_  = ' ' AND B1.B1_COD = D3R.D3_COD " + CRLF
    cQueryMG += "       INNER JOIN "+RetSqlName("SD3")+" D3P ON D3P.D_E_L_E_T_ = ' ' AND D3P.D3_OP = D3R.D3_OP AND D3P.D3_FILIAL = D3R.D3_FILIAL   " + CRLF
    cQueryMG += " WHERE D3R.D_E_L_E_T_ = ' ' " + CRLF
    cQueryMG += "     	AND D3R.D3_FILIAL   = '"+xFilial( "SD3" )+"' " + CRLF
    cQueryMG += "     	AND ( SUBSTRING(D3R.D3_CF,1,2) = 'RE' OR D3R.D3_CF = 'RE4' ) " + CRLF
    cQueryMG += "     	AND D3R.D3_ESTORNO = ' '  " + CRLF
    cQueryMG += "     	AND D3R.D3_OP <> ' ' " + CRLF
    cQueryMG += "     	AND D3R.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQueryMG += "     	AND D3R.D3_COD  = '"+cPPMassa+"' " + CRLF
    cQueryMG += "     	AND D3P.D3_GRUPO = '"+cGrupo+"' " + CRLF
    cQueryMG += "     	AND SUBSTRING(D3P.D3_CF,1,2) = 'PR' " + CRLF
    cQueryMG += "     	AND D3P.D3_ESTORNO = ' '  " + CRLF
    cQueryMG += " GROUP BY D3R.D3_FILIAL, D3P.D3_GRUPO, D3R.D3_COD, B1.B1_DESC " + CRLF
    cQueryMG += " ORDER BY D3R.D3_FILIAL, D3P.D3_GRUPO " + CRLF
Else 
	//дздддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL TOTAL PRODUгцO MASSA POR GRUPO EXCETO MUSSARELA/PROVOLONE/REQUEIJцO  Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

	cQueryMG := " SELECT D3_FILIAL FILIAL, D3_GRUPO GRUPO, SUM(D3.D3_QUANT) QUANT " + CRLF
    cQueryMG += "     FROM "+RetSqlName("SD3")+" D3 " + CRLF
    cQueryMG += "     WHERE D3.D_E_L_E_T_ = ' ' " + CRLF
    cQueryMG += "         AND D3.D3_CF IN ('PR0','PR1','RE4') " + CRLF
    cQueryMG += "         AND D3.D3_ESTORNO = ' ' " + CRLF
    cQueryMG += "         AND D3.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"' " + CRLF
    cQueryMG += "         AND D3.D3_FILIAL  = '"+xFilial( "SD3" )+"' " + CRLF
    cQueryMG += "         AND D3.D3_COD  = '"+cPPMassa+"' " + CRLF
    cQueryMG += "     GROUP BY D3_FILIAL, D3_GRUPO	" + CRLF

EndIf   

//дзддддддддддддддддддддддд
//ЁExecuta consulta SQL   Ё
//юдддддддддддддддддддддддд
cProdGrp := GetNextAlias()
TCQuery ChangeQuery( cQueryMG ) NEW Alias (cProdGrp)

    nPerGrupo := (cProdGrp)->QUANT / nQtdeTotal 

(cTOTMG)->(dbCloseArea())
(cProdGrp)->(dbCloseArea())

Return nPerGrupo 



//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё DEFINE A QUANTIDADE - SOLIDOS E MATEIRA GORDA           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xQtde(nDiv)

Local nQtde := 0

Do Case
    Case nDiv == 1 // PP LEITE PADRONIZADO
        If MV_PAR01 $ '0001/0003/0008'  // Mussarela, Provolone e RequeijЦo
            nQtde :=  xRatRenda("QTDGRUPO") * xRatRenda("PERCRENDA")
        Else
            nQtde := (cAlsINSUMOS)->QUANT
        EndIf  
    
    Case nDiv == 2 // SOLIDOS - SORO CONCENTRADO
        IF MV_PAR01 == '0010'
            nQtde := (cAlsINSUMOS)->QUANT
            //nQtde := (cAlsINSUMOS)->QUANT  * (MV_PAR07 /100)
        ElseIf MV_PAR01 $ '0001/0003/0008'  // Mussarela, Provolone e RequeijЦo
            nQtde :=  (cAlsINSUMOS)->QUANT * xRatRenda("PERCGRUPO")
            //nQtde := ( (cAlsINSUMOS)->QUANT * (MV_PAR07/100) ) * xRatSolido()

        Else //If !MV_PAR01 $ '0004/0006' // ParmesЦo e Montanhes nЦo considera Solidos 
            nQtde :=  (cAlsINSUMOS)->QUANT
            //nQtde := (cAlsINSUMOS)->QUANT * (MV_PAR07/100) * xRatSolido()
        EndIf

    Case nDiv == 3 // MATиRIA GORADA - CREME DE LEITE E CREME DE SORO
        IF ALLTRIM((cAlsINSUMOS)->PRODUTO) == '99000010'
            nPercMG := MV_PAR08/100
        Else      
            nPercMG := MV_PAR09/100
        EndIf 
        
        nQtde := ( (cAlsINSUMOS)->QUANT * xRatMG() ) * nPercMG
    
    OtherWise
        cMPPPMassa := xMPPPMassa()
        IF MV_PAR01 $ '0001/0003/0008'  //MUSSARELA / PROVOLONE / REQUEIJцO
            IF ALLTRIM( (cAlsINSUMOS)->PRODUTO ) $ cMPPPMassa
                nQtde := (cAlsINSUMOS)->QUANT * xRatRenda("PERCGRUPO")
            Else
                nQtde := (cAlsINSUMOS)->QUANT
            EndIf 
        Else 
            nQtde := (cAlsINSUMOS)->QUANT 
        EndIF 
EndCase

Return nQtde


//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CаLCULO DO CONSUMO TOTAL DOS INSUMOS           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xConsTotal(nDiv)

Local nQtde := 0

Do Case
    Case nDiv == 1 // PP LEITE PADRONIZADO
        nQtde :=  (cAlsINSUMOS)->QUANT
    
    Case nDiv == 2 // SOLIDOS - SORO CONCENTRADO
        IF MV_PAR01 == '0010'
            nQtde := ( (cAlsINSUMOS)->QUANT + xCompraSolido() ) * (MV_PAR07 /100)
        Else 
            nQtde := (cAlsINSUMOS)->QUANT * (MV_PAR07/100)
        EndIf

    Case nDiv == 3 // MATиRIA GORADA - CREME DE LEITE E CREME DE SORO
        IF !MV_PAR01 $ '0010'  //Soro nЦo considera a MatИria Gorda
            nQtde := (cAlsINSUMOS)->QUANT   
        EndIF 
    
    OtherWise
        nQtde := (cAlsINSUMOS)->QUANT 
EndCase

Return nQtde

//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё DEFINE O PREгO/CUSTO UNITARIO - SOLIDOS E MATEIRA GORDA           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xPreco(nDiv)

Local nPreco := 0

    Do Case
        Case nDiv == 2  // SOLIDOS - SORO CONCENTRADO
            //nPreco :=  MV_PAR04
            nPreco := (cAlsINSUMOS)->CUNIT
            
        Case nDiv == 3   // MATиRIA GORADA - CREME DE LEITE E CREME DE SORO
            If ALLTRIM((cAlsINSUMOS)->PRODUTO) == '99000010' // CREME DE LEITE
                nPreco :=  MV_PAR05
                
            ElseIF ALLTRIM((cAlsINSUMOS)->PRODUTO) == '99000011' // CREME DE SORO
                nPreco :=  MV_PAR06
                
            EndIf
        OtherWise
        
        nPreco := (cAlsINSUMOS)->CUNIT

    EndCase

    nPreco := ROUND(nPreco,4)

Return nPreco


//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//Ё CALCULO DO CUSTO - SOLIDOS E MATEIRA GORDA           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
Static Function xCusto(nDiv)

Local nCusto := 0

Do Case
    Case nDiv == 1  // Leite Padronizado
        nCusto := xQtde(1) * Round((cAlsINSUMOS)->CUNIT,4)
    
    Case nDiv == 2  // SСlidos
        IF MV_PAR01 == '0010'
            nCusto := ( xQtde(2) * MV_PAR04 )
        
        Else
            //nCusto := ( xQtde(2) * MV_PAR04 ) * -1
            nCusto := ( xQtde(2) * (cAlsINSUMOS)->CUNIT ) * -1
        
        EndIf 
    
    Case nDiv == 3  // Mat. Gorda Creme de Leite e Soro
        IF ALLTRIM((cAlsINSUMOS)->PRODUTO) == '99000010'
            nCusto := ( xQtde(3) * MV_PAR05 ) * -1
        
        ElseIf ALLTRIM((cAlsINSUMOS)->PRODUTO) == '99000011'
            nCusto := ( xQtde(3) * MV_PAR06 ) * -1
        
        EndIf 
    
    OtherWise
        nCusto  := xQtde(nDiv) * (cAlsINSUMOS)->CUNIT
EndCase

nCusto := ROUND(nCusto,2)

Return nCusto



//дздддддддддддддддддддддддддддд
//Ё COMPRA DO SсLIDO - 01010004 Ё
//юддддддддддддддддддддддддддддд
Static Function xCompraSolido()

Local cQtdCompra    := GetNextAlias()
Local nQtdCompra    := 0


	//дзддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁMonta consulta SQL para buscar os dados                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддд 
	cQryD1Sol := " SELECT D1_FILIAL FILIAL, D1_COD, SUM(D1_QUANT) QUANT " + CRLF
    cQryD1Sol += " FROM "+RetSqlName("SD1")+" D1 "  + CRLF
    cQryD1Sol += "      INNER JOIN "+RetSqlName("SF4")+" F4 ON F4.D_E_L_E_T_ = ' ' AND F4.F4_FILIAL = D1.D1_FILIAL AND F4.F4_CODIGO = D1.D1_TES "  + CRLF
	cQryD1Sol += " WHERE D1.D_E_L_E_T_ = ' ' " + CRLF
    cQryD1Sol += "  	AND D1_FILIAL   = '"+xFilial( "SD1" )+"' " + CRLF
	cQryD1Sol += " 	    AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR02)+"' AND  '"+DTOS(MV_PAR03)+"'	" + CRLF
    cQryD1Sol += "	    AND D1_COD = '01010004' " + CRLF
    cQryD1Sol += "	    AND F4.F4_ESTOQUE = 'S' " + CRLF
	cQryD1Sol += "GROUP BY D1_FILIAL, D1_COD    " + CRLF


	//дзддддддддддддддддддддддд
	//ЁExecuta consulta SQL   Ё
	//юдддддддддддддддддддддддд
	cQtdCompra := GetNextAlias()
	TCQuery ChangeQuery( cQryD1Sol ) NEW Alias (cQtdCompra)

    dbSelectArea(cQtdCompra)
	(cQtdCompra)->(dbGoTop())

    nQtdCompra := (cQtdCompra)->QUANT

	(cQtdCompra)->(dbCloseArea())


Return nQtdCompra



/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁAJUSTASX1  ╨Autor  ЁTRELAC       ╨ Data Ё  15/12/09  ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁFunГao responsavel pela verificacao/criacao do grupo de per ╨╠╠
╠╠╨          Ёguntas utilizado como parametro para emissao do relatorio   ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁQualidade - TRELAC                                           ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function AJUSTASX1()

Local nI		:= 0
Local nJ		:= 0

Private aRegs	:= {}  

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁDefiniГЦo dos itens do grupo de perguntas a ser criado Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддд
AADD(aRegs, {cPerg, "01", "Grupo       :"           , "Grupo       :"           , "Grupo       :"           , "mv_ch1" , "C",TAMSX3("BM_GRUPO")[1]      ,0,0,"G","","mv_par01",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "   ","","   ", "",						""})
AADD(aRegs, {cPerg, "02", "EmissЦo De  :"           , "EmissЦo De  :"           , "EmissЦo De  :"           , "mv_ch2" , "D",TAMSX3("D3_EMISSAO")[1]    ,0,0,"G","","mv_par02",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})
AADD(aRegs, {cPerg, "03", "EmissЦo Ate :"           , "EmissЦo Ate :"           , "EmissЦo Ate :"           , "mv_ch3" , "D",TAMSX3("D3_EMISSAO")[1]    ,0,0,"G","","mv_par03",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})
AADD(aRegs, {cPerg, "04", "C.Unit.Solidos :"        , "C.Unit.Solidos :"        , "C.Unit.Solidos :"        , "mv_ch4" , "N",9                          ,4,0,"G","","mv_par04",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})
AADD(aRegs, {cPerg, "05", "C.Unit.Creme Leite :"    , "C.Unit.Creme Leite :"    , "C.Unit.Creme Leite :"    , "mv_ch5" , "N",9                          ,4,0,"G","","mv_par05",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})
AADD(aRegs, {cPerg, "06", "C.Unit.Creme Soro :"     , "C.Unit.Creme Soro :"     , "C.Unit.Creme Soro :"     , "mv_ch6" , "N",9                          ,4,0,"G","","mv_par06",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})
AADD(aRegs, {cPerg, "07", "BRIX MИdio MЙs - Soro :" , "BRIX MИdio MЙs - Soro :" , "BRIX MИdio MЙs - Soro :" , "mv_ch7" , "N",9                          ,4,0,"G","","mv_par07",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})
AADD(aRegs, {cPerg, "08", "% MG Creme Leite :"      , "% MG Creme Leite :"      , "% MG Creme Leite :"      , "mv_ch8" , "N",9                          ,4,0,"G","","mv_par08",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})
AADD(aRegs, {cPerg, "09", "% MG Creme Soro :"       , "% MG Creme Soro :"       , "% MG Creme Soro :"       , "mv_ch9" , "N",9                          ,4,0,"G","","mv_par09",			"",		     "",		    "","","",			 "",         "",         "","","",						"",						"",						"","","",				"",				"",				"","","",		"",		 "",	  "","",   "","","", "",							""})


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁInsere os itens do grupo de perguntas no dicionАrio de perguntasЁ
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
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
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммм`ммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  ЁSCHEDDEF  ╨Autor  ЁTRELAC      ╨ Data Ё  26/01/2016  ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁFunГЦo responsАvel por disponibilizar a utilizaГЦo do rela- ╨╠╠
╠╠╨          ЁtСrio na funcionalidade de Schedule.                        ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё TRELAC                                                   ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function SCHEDDEF()

Local aParam

aParam := {"R", cPerg, "", {}, cTitle}

Return aParam

