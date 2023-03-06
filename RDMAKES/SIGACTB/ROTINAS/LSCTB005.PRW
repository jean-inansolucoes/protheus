#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSCTB005 ³ Autor ³                    	³ Data ³16/08/2021  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Calculo de Recebimentos Produtos Leite e Soro para  ³±±
±±³          ³utilização no Rateio de Custo na Formação de Custo Produção   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*-----------------------------------------------------------------------------*
User Function LSCTB005( cTipoProd )
*-----------------------------------------------------------------------------*

Local cDataIni      := SUBSTR(DTOS(DDATABASE),1,6)+"01"
Local cDataFim      := DTOS(DDATABASE)
Local cQryD3Leite   := " "
Local cQryD1Soro    := " "
Local cQryD3Soro    := " "
Local cAlsD3Leite   := " "
Local cAlsD1Soro    := " "
Local cAlsD3Soro    := " "
Local nQtdD3Leite   := 0
Local nQtdD1Soro    := 0
Local nQtdD3Soro    := 0
Local nQtdTotal     := 0
Local nPercLeite    := 0
Local nPercSoro     := 0
Local nPerc         := 0

    //ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Monta consulta SQL para buscar os dados do Recebimento de Leite, movimentos da SD3    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    cQryD3Leite := " SELECT D3.D3_FILIAL FILIAL, SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4) MES_ANO, D3.D3_COD PRODUTO, "
    cQryD3Leite += "      B1.B1_DESC, SUM(D3_QUANT) QTDE_SD3 "
    cQryD3Leite += " FROM "+RetSqlName("SD3")+" D3 "
    cQryD3Leite += "     INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3.D3_COD "
    cQryD3Leite += " WHERE D3.D_E_L_E_T_ = ' '  "
    cQryD3Leite += "     AND D3_COD IN ('01010001')"
    cQryD3Leite += "     AND D3_TM = '001' AND D3_ESTORNO <> 'S' "
    cQryD3Leite += "     AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "
    cQryD3Leite += "     AND D3_FILIAL = '"+xFilial("SD3")+"' "
    cQryD3Leite += " GROUP BY D3_FILIAL, SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4), D3_COD , B1.B1_DESC "

    //ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Executa consulta SQL   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    cAlsD3Leite := GetNextAlias()
    TCQuery ChangeQuery( cQryD3Leite ) NEW Alias (cAlsD3Leite)
    dbSelectArea(cAlsD3Leite)

	nQtdD3Leite	:= (cAlsD3Leite)->QTDE_SD3
    
	dbCloseArea()


    //ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Monta consulta SQL para buscar os dados do Recebimento de Soro, movimentos de Compra da SD1  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    cQryD1Soro := " SELECT D1.D1_FILIAL,SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4) MES_ANO, D1.D1_COD, D1.D1_X_DESCP, SUM(D1.D1_QUANT) AS QTDE_SD1 "
    cQryD1Soro += " FROM "+RetSqlName("SD1")+" D1 "
    cQryD1Soro += "     INNER JOIN SF4010 F4 ON F4.D_E_L_E_T_ = ' ' AND F4.F4_FILIAL = D1.D1_FILIAL AND F4.F4_CODIGO = D1.D1_TES "
    cQryD1Soro += " WHERE D1.D_E_L_E_T_ = ' '   "
    cQryD1Soro += "         AND D1_COD IN ('01010002','01010003','01010004') " 
    cQryD1Soro += "         AND F4.F4_ESTOQUE = 'S' "
    cQryD1Soro += "         AND D1_FILIAL = '"+xFilial("SD1")+"' " 
    cQryD1Soro += "         AND D1_COD IN ('01010002','01010003','01010004') "
    cQryD1Soro += "         AND D1_DTDIGIT BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "
    cQryD1Soro += " GROUP BY D1.D1_FILIAL, SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4), D1.D1_COD, D1.D1_X_DESCP "

    //ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Executa consulta SQL   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    cAlsD1Soro := GetNextAlias()
    TcQuery ChangeQuery( cQryD1Soro ) NEW Alias (cAlsD1Soro)
    dbSelectArea(cAlsD1Soro)

	nQtdD1Soro	:= (cAlsD1Soro)->QTDE_SD1
    
	dbCloseArea()


    //ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Monta consulta SQL para buscar os dados da Produção de Soro, movimentos da SD3   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    cQryD3Soro := " SELECT D3_FILIAL, SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4) MES_ANO, SUM(D3_QUANT) QTDE_SD3 "
    cQryD3Soro += " FROM "+RetSqlName("SD3")+" D3 "
    cQryD3Soro += "     INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_ = ' ' AND B1.B1_COD = D3_COD "
    cQryD3Soro += " WHERE D3.D_E_L_E_T_ = ' '  "
    cQryD3Soro += "     AND D3_OP <> ' ' AND SUBSTRING(D3_CF,1,2) IN ('PR','DE') "
    cQryD3Soro += "     AND D3_COD IN ('01010002','01010003','01010004') "
    cQryD3Soro += "     AND D3_ESTORNO <> 'S' "
    cQryD3Soro += "     AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "
    cQryD3Soro += "     AND D3_FILIAL = '"+xFilial("SD3")+"' "
    cQryD3Soro += " GROUP BY D3_FILIAL, SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4) "
    cQryD3Soro += " ORDER BY D3_FILIAL, SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4) "


    //ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Executa consulta SQL   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    cAlsD3Soro := GetNextAlias()
    TcQuery ChangeQuery( cQryD3Soro ) NEW Alias (cAlsD3Soro)
    dbSelectArea(cAlsD3Soro)

	nQtdD3Soro	:= (cAlsD3Soro)->QTDE_SD3
    
	dbCloseArea()  



    //ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Soma e Caldulo dos Totais e Percentual de cada Produto   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

    nQtdTotal := nQtdD3Leite + nQtdD1Soro + nQtdD3Soro

    nPercLeite  := ( nQtdD3Leite / nQtdTotal ) * 100
    nPercSoro   := ( ( nQtdD1Soro + nQtdD3Soro) / nQtdTotal ) * 100

    IF cTipoProd == "LEITE"
        nPerc   := Round(nPercLeite,2)
    ElseIf cTipoProd == "SORO"
        nPerc   := Round(nPercSoro,2)
    EndIf 


Return ( nPerc )
