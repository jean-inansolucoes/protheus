#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออออออปฑฑ
ฑฑบPrograma  ณLSEST06  บAutor  ณ                     Data ณ  30/11/2021         บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para verificar se houve Movimentos Internos referente a  บฑฑ
ฑฑบ          ณ movimentos de Qtde e Valores gerados sobre os Itens da NF Entrada บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS TRELAC                                                       บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LSEST06()

Local cQuery    := ""
Local cAliasTMP	:= GetNextAlias()
Local aArea	    := GetArea()
Local aDadosMov := {}
Local cObserva  := "NumSeq SD1: "+SD1->D1_NUMSEQ

Private lMsHelpAuto := .T. // se .T. direciona as mensagens de help
Private lMsErroAuto := .F. //necessario a criacao
Private l241Auto    := .T. //Nใo apresenta mensagem de confirma็ใo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Sele็ใo de Movimentos internos de Qtde e Valores       ณ
//ณ gerados pelo Registro dos Itens da NF                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT D3_FILIAL, D3_TM, D3_COD, D3_LOCAL, D3_UM, D3_QUANT, D3_CF,  D3_DOC, D3_CC, "   + CRLF
cQuery += "        D3_EMISSAO, D3_LOTECTL, D3_NUMSEQ, D3_OBSERVA, D3_CUSTO1, R_E_C_N_O_ NRECNO "   + CRLF
cQuery += " FROM "+RetSqlName( "SD3" )                          + CRLF
cQuery += " WHERE D_E_L_E_T_ <> '*' "                           + CRLF
cQuery += "     AND D3_FILIAL   = '" + SD1->D1_FILIAL +  "'"    + CRLF
cQuery += "     AND D3_DOC      = '" + SD1->D1_DOC +     "'"    + CRLF
cQuery += "     AND D3_COD      = '" + SD1->D1_COD +     "'"    + CRLF
cQuery += "     AND D3_OBSERVA  = '" + cObserva +        "'"    + CRLF
cQuery += " 	AND D3_ESTORNO <> 'S' "                         + CRLF


//ฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta consulta SQL   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
cAliasTMP := GetNextAlias()
TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
While (cAliasTMP)->(!EOF())

    //*****************************************************
    // adiciona os dados da Nf ao array aDadosMov que serแ 
    // utilizando no execauto do Movimento Interno MATA241
    //*****************************************************
    aDadosMov := {}
    aAdd(aDadosMov,(cAliasTMP)->D3_FILIAL)  //01-Filial	
    aAdd(aDadosMov,(cAliasTMP)->D3_TM)      //02-Tipo Movimento
    aAdd(aDadosMov,(cAliasTMP)->D3_COD)     //03-Produto	
    aAdd(aDadosMov,(cAliasTMP)->D3_UM)      //04-Unidade Medida    
    aAdd(aDadosMov,(cAliasTMP)->D3_LOCAL)   //05-Local
    aAdd(aDadosMov,(cAliasTMP)->D3_QUANT)   //06-Quantidade	
    aAdd(aDadosMov,(cAliasTMP)->D3_CUSTO1)  //07-Valor	
    aAdd(aDadosMov,(cAliasTMP)->D3_DOC)     //08-Nro Documento	
    aAdd(aDadosMov,SD1->D1_SERIE)           //09-Serie Documento
    aAdd(aDadosMov,SD1->D1_FORNECE)         //10-Fornecedor
    aAdd(aDadosMov,SD1->D1_LOJA)            //11-Loja
    aAdd(aDadosMov,(cAliasTMP)->D3_LOTECTL) //12-Lote	
    aAdd(aDadosMov,(cAliasTMP)->D3_EMISSAO) //13-Data Digita็ใo
    aAdd(aDadosMov,(cAliasTMP)->D3_CC)      //14-Centro de Custo
    aAdd(aDadosMov,(cAliasTMP)->D3_NUMSEQ)  //15-NUMSEQ Numero Sequencial


    //**********************************************************************
    //Gera Estorno do Movimento Interno Multiplo da diferen็a da Quantidade
    //**********************************************************************
    U_LSMTA241(aDadosMov,"E")

    (cAliasTMP)->(dbSkip())

Enddo

(cAliasTMP)->(dbCloseArea())

RestArea(aArea)

Return
