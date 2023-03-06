#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออออออปฑฑ
ฑฑบPrograma  ณLSEST08  บAutor  ณ                     Data ณ  09/12/2021          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออนฑฑ
ฑฑบDesc.    ณ Programa para verificar registro na ZM1 com diferen็as de          บฑฑ
ฑฑบ         ณ Qtde e Valores com a NF Entrada e gerar movimento interno multiplo บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณTOTVS TRELAC                                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LSEST08()

Local cQuery    := ""
Local cAliasTMP	:= GetNextAlias()
Local aDadosMov := {}
Local aArea	    := GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Sele็ใo de Informa็๕es os Itens da NF                  ณ
//ณ referentes ao Registro da pesagem                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT D1_FILIAL, D1_COD, D1_UM, D1_LOCAL, D1_QUANT, D1_TOTAL, D1_DOC, D1_SERIE, " + CRLF
cQuery += "        D1_FORNECE, D1_LOJA, D1_LOTECTL, D1_DTDIGIT, D1_CC, D1_NUMSEQ " + CRLF
cQuery += " FROM "+RetSqlName( "SD1" )                              + CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*' "                               + CRLF
cQuery += "     AND D1_FILIAL  = '" + SD1->D1_FILIAL +  "'"         + CRLF
cQuery += "     AND D1_DOC     = '" + SD1->D1_DOC +     "'"         + CRLF
cQuery += "     AND D1_SERIE   = '" + SD1->D1_SERIE +   "'"         + CRLF
cQuery += "     AND D1_FORNECE = '" + SD1->D1_FORNECE + "'"         + CRLF
cQuery += "     AND D1_LOJA    = '" + SD1->D1_LOJA +    "'"         + CRLF


//ฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta consulta SQL   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
cAliasTMP := GetNextAlias()
TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

dbSelectArea(cAliasTMP)

IF M->ZM1_SITCON == "F" .And. ALLTRIM((cAliasTMP)->D1_COD) $ SuperGetMv("LTS_PRDDIF",,"")

    //*****************************************************
    // adiciona os dados da Nf ao array aDadosMov que serแ 
    // utilizando no execauto do Movimento Interno MATA241
    //*****************************************************
    aDadosMov := {}
    aAdd(aDadosMov,(cAliasTMP)->D1_FILIAL)      //01-Filial	
    aAdd(aDadosMov,"")                  //02-Tipo Movimento
    aAdd(aDadosMov,(cAliasTMP)->D1_COD)         //03-Produto	
    aAdd(aDadosMov,(cAliasTMP)->D1_UM)          //04-Unidade Medida    
    aAdd(aDadosMov,(cAliasTMP)->D1_LOCAL)       //05-Local
    aAdd(aDadosMov,(cAliasTMP)->D1_QUANT)       //06-Quantidade	
    aAdd(aDadosMov,(cAliasTMP)->D1_TOTAL)       //07-Valor	
    aAdd(aDadosMov,(cAliasTMP)->D1_DOC)         //08-Nro Documento	
    aAdd(aDadosMov,(cAliasTMP)->D1_SERIE)       //09-Serie Documento
    aAdd(aDadosMov,(cAliasTMP)->D1_FORNECE)     //10-Fornecedor
    aAdd(aDadosMov,(cAliasTMP)->D1_LOJA)        //11-Loja
    aAdd(aDadosMov,(cAliasTMP)->D1_LOTECTL)     //12-Lote	
    aAdd(aDadosMov,STOD((cAliasTMP)->D1_DTDIGIT))//13-Data Digita็ใo
    aAdd(aDadosMov,(cAliasTMP)->D1_CC)          //14-Centro de Custo
    aAdd(aDadosMov,(cAliasTMP)->D1_NUMSEQ)      //15-NUMSEQ Numero Sequencial    

    //*****************************************************
    //Definindo as Variแveis de Quantidade
    //*****************************************************
    aDadosMov[06] := (cAliasTMP)->D1_QUANT - M->ZM1_LTBRT

    IF aDadosMov[06] <> 0
       aDadosMov[07] := 0  //For็a o valor zero para o movimento de quantidade

        IF aDadosMov[06] > 0            //Qtde da NF maior que a Qtde Convertida
            aDadosMov[02]   := "501"    //Saํda Qtde
        ElseIf aDadosMov[06] < 0        //Qtde da NF menor que a Qtde Convertida
            aDadosMov[06]   := ABS( aDadosMov[06] )
            aDadosMov[02]   := "001"    //Entrada Qtde  
        EndIf

        //*************************************************************
        //Gera o Movimento Interno Multiplo da diferen็a da Quantidade
        //*************************************************************
        U_LSMTA241(aDadosMov,"I")

    EndIf 

    //*********************************
    //Definindo as Variแveis de Valor 
    //*********************************
    nValorSol   := ROUND( M->ZM1_SLLT * M->ZM1_PRCSOL,2)
    aDadosMov[07]   := nValorSol - (cAliasTMP)->D1_TOTAL 

    IF aDadosMov[07] <> 0
       aDadosMov[06] := 0 //For็a a quantidade zero para o movimento de valor
    
        IF aDadosMov[07] > 0 //Valor Convertido Maior que o Valor da NF
            aDadosMov[02]    := "002" //Entrada Valor
        ElseIf aDadosMov[07] < 0  //Valor Convertido Menor que o Valor da NF
            aDadosMov[07]    := ABS( Round(aDadosMov[07],2) )
            aDadosMov[02]    := "502" //Saida Valor 
        EndIf

        //********************************************************
        //Gera o Movimento Interno Multiplo da diferen็a de Valor
        //********************************************************
        U_LSMTA241(aDadosMov,"I")
    
    EndIf 

EndIf   

dbCloseArea()

RestArea(aArea)

Return
