#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³LSFATR04 º Autor ³ Alexandre Longhinotti º Data ³  23/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Media de Vendas por Grupo (Preço NET)         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LSFATR06()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Resumo Faturamento - Preço NET"
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}

Private titulo       := ""
Private nLin         := 80
Private Cabec1       := "" 
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "LSFATR06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "LSFATR0006"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LSFATR06" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD2"

AjustaSX1()                                                 
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
titulo       := "Resumo Faturamento - Preço NET-(2015)"
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport() },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport()

Local nOrdem 
Local nTotalQ      := 0
Local nTotalT      := 0
Local nSubTotQ     := 0
Local nSubTotT 	   := 0
Local nTotalD	   := 0
Local nSubTotD	   := 0
Local nPerDesc	   := 0
Local nTotDesc	   := 0
Local nTotGeral	   := 0
Local nQtdGeral	   := 0
Local cAliasTMP    := GetNextAlias()
Local cAliasTMP1   := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13)
Local  cGrpAnt     := ""                
Local aDadosImp    := {}  
Local aDadosDev    := {}  
Local cMV_CFOPVEN  := SuperGetMV("MV_CFOPVEN",,"") // Relação das CFOPs de venda
Local cMV_CFOPVFU  := SuperGetMV("MV_CFOPVFU",,"") // Relação das CFOPs de venda entregas futuras
Local cMV_CFOPDEV  := SuperGetMV("MV_CFOPDEV",,"") // Relação das CFOPs de devolução
Local CabexAux := ""

If mv_par09 = 1
	cMV_CFOPVEN := cMV_CFOPVFU
EndIf
If mv_par05 = 1 
	CabexAux := " - C/ Devoluções pela " + IIF(mv_par06 = 1, "Emissão", "Digitação")
EndIf
/*
          1         2         3         4         5         6         7         8         9         100       110
0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
---------------------------------------------------------------------------------------------------------------
PRODUTO  DESCRICAO                                QTDE TOTAL    VALOR TOTAL   VALOR DESC   %DESC    MEDIA VALOR
*/  
Cabec1 := "Período de " + dtoc(mv_par01) + " até " + dtoc(mv_par02) + CabexAux
Cabec2 := "PRODUTO  DESCRICAO                                QTDE TOTAL        VALOR TOTAL     VALOR DESC   %DESC    MEDIA VALOR   PREÇO(Net)"
                                                                                                      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro dos dados de acordo com os parametros informados pelo usuário. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If (Select(cAliasTMP) <> 0)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
Endif

cQuery := "SELECT 	 														" + hEnter
cQuery += "SD2.D2_CLIENTE,									 				" + hEnter
cQuery += "SD2.D2_LOJA,									 			   		" + hEnter
cQuery += "SUM(SD2.D2_QUANT) AS QUANT, 								   		" + hEnter
cQuery += "SUM(SD2.D2_TOTAL) AS TOTAL,  							  		" + hEnter
cQuery += "SD2.D2_FILIAL,									 				" + hEnter
cQuery += "SD2.D2_COD,									 					" + hEnter
cQuery += "SD2.D2_GRUPO,													" + hEnter
cQuery += "SD2.D2_EMISSAO AS EMISSAO,										" + hEnter
cQuery += "SD2.D2_DOC AS DOCUMENTO,											" + hEnter
cQuery += "SD2.D2_CF,									 					" + hEnter
cQuery += "SF4.F4_FILIAL,									 				" + hEnter
cQuery += "SF4.F4_CODIGO, 									 				" + hEnter
cQuery += "ROUND((AVG(SE1.E1_DECRESC) / AVG(SE1.E1_VALOR))*100,1) AS ACORDO" + hEnter
cQuery += "FROM " + RetSqlName("SD2") + " SD2						 		" + hEnter
cQuery += "INNER JOIN SE1010 SE1 ON SE1.E1_FILIAL = SD2.D2_FILIAL AND SE1.E1_EMISSAO = SD2.D2_EMISSAO AND SE1.E1_NUM = SD2.D2_DOC AND SE1.E1_PREFIXO = SD2.D2_SERIE AND SE1.E1_CLIENTE = SD2.D2_CLIENTE AND SE1.E1_LOJA = SD2.D2_LOJA AND  SE1.E1_TIPO ='NF' AND (SE1.E1_PARCELA = '001' OR SE1.E1_PARCELA = '') AND SE1.D_E_L_E_T_ <> '*'" + hEnter
cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4   				 		" + hEnter
cQuery += "ON SD2.D2_TES = SF4.F4_CODIGO                      					   			" + hEnter
cQuery += "AND SD2.D2_FILIAL = SF4.F4_FILIAL                   								" + hEnter
cQuery += "WHERE SD2.D2_FILIAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND  				" + hEnter
cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND 		" + hEnter
cQuery += "SD2.D2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND 						" + hEnter
cQuery+=  "SD2.D2_CF IN " + FormatIn(cMV_CFOPVEN,";")+"  AND 									" + hEnter
cQuery += "SD2.D_E_L_E_T_ <> '*' AND                                 			   			" + hEnter
cQuery += "SF4.D_E_L_E_T_ <> '*'                                     	   					" + hEnter
cQuery += "GROUP BY SD2.D2_CF, SD2.D2_GRUPO, SD2.D2_COD, SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_FILIAL, SF4.F4_CODIGO, SF4.F4_FILIAL, SD2.D2_CLIENTE, SD2.D2_LOJA	" + hEnter
cQuery += "ORDER BY SD2.D2_GRUPO, SD2.D2_COD	 											" + hEnter
 
MemoWrite("LSFATR04.SQL",cQuery)
TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
SetRegua(RecCount(cAliasTMP))
                          
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Populo o vetor para impressao das Vendas                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

While (cAliasTMP)->(!EOF())

cDescri  := ALLTRIM( SUBSTR( POSICIONE("SB1",1,XFILIAL("SB1")+(cAliasTMP)->D2_COD,"B1_DESC"),1,35 ) )
nPesoPrd := POSICIONE("SB1",1,XFILIAL("SB1")+(cAliasTMP)->D2_COD,"B1_PESO")
nPerdesc := (cAliasTMP)->ACORDO//POSICIONE( "SA1",1, XFILIAL( "SA1" ) + (cAliasTMP)->D2_CLIENTE + (cAliasTMP)->D2_LOJA, "SA1->A1_X_DESCF")                                           
nTotDesc :=((cAliasTMP)->TOTAL * (nPerdesc / 100))
nTotGeral += (cAliasTMP)->TOTAL
nQtdGeral += ((cAliasTMP)->QUANT * nPesoPrd )
If Len(aDadosImp) = 0
	AADD(aDadosImp,{ALLTRIM( (cAliasTMP)->D2_COD ), cDescri, (cAliasTMP)->D2_GRUPO, (cAliasTMP)->F4_CODIGO, (cAliasTMP)->QUANT, (cAliasTMP)->TOTAL, nTotDesc})
Else
	nPos := aScan( aDadosImp, {|x| ALLTRIM(x[1]) == ALLTRIM( (cAliasTMP)->D2_COD ) }  )  
	If nPos = 0 
	AADD(aDadosImp,{ALLTRIM( (cAliasTMP)->D2_COD ), cDescri, (cAliasTMP)->D2_GRUPO, (cAliasTMP)->F4_CODIGO, (cAliasTMP)->QUANT, (cAliasTMP)->TOTAL, nTotDesc})
	Else
	    aDadosImp[nPos][5] += (cAliasTMP)->QUANT
	    aDadosImp[nPos][6] += (cAliasTMP)->TOTAL
	    aDadosImp[nPos][7] += nTotDesc
	EndIf
EndIf                           



(cAliasTMP)->( dbskip() ) 

EndDo 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro dos dados de Devolções.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If mv_par05 = 1

	If (Select(cAliasTMP1) <> 0)
		dbSelectArea(cAliasTMP1)
		(cAliasTMP1)->(dbCloseArea())
	Endif
	
	cQuery := "SELECT 	 														" + hEnter
	cQuery += "SD1.D1_FORNECE,									 				" + hEnter
	cQuery += "SD1.D1_LOJA,									 					" + hEnter
	cQuery += "SUM(SD1.D1_QUANT) AS QUANT, 								   		" + hEnter
	cQuery += "SUM(SD1.D1_TOTAL) AS TOTAL,  							  		" + hEnter
	cQuery += "SD1.D1_FILIAL,									 				" + hEnter
	cQuery += "SD1.D1_COD,									 					" + hEnter
	cQuery += "SD1.D1_GRUPO,									 				" + hEnter
	cQuery += "SF4.F4_FILIAL, 									 				" + hEnter
	//cQuery += "round((AVG(SE1.E1_DECRESC) / SUM(SE1.E1_VALOR))*100,1) AS ACORDO," + hEnter
	cQuery += "SF4.F4_CODIGO 									 				" + hEnter
	cQuery += "FROM " + RetSqlName("SD1") + " SD1						 		" + hEnter
	//cQuery += "INNER JOIN SE1010 SE1 ON SE1.E1_FILIAL = SD1.D1_FILIAL AND SE1.E1_NUM = SD1.D1_NFORI AND SE1.E1_PREFIXO = SD1.D1_SERIORI AND SE1.E1_CLIENTE = SD1.D1_FORNECE AND SE1.E1_LOJA = SD1.D1_LOJA AND  SE1.E1_TIPO ='NF' AND (SE1.E1_PARCELA = '001' OR SE1.E1_PARCELA = '') AND SE1.D_E_L_E_T_ <> '*'" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4   				 		" + hEnter
	cQuery += "ON SD1.D1_TES = SF4.F4_CODIGO                      				" + hEnter
	cQuery += "AND SD1.D1_FILIAL = SF4.F4_FILIAL                   				" + hEnter
	cQuery += "WHERE SD1.D1_FILIAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND " + hEnter
	If mv_par06 = 1
   		cQuery += "SD1.D1_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND	" + hEnter
	Else
   		cQuery += "SD1.D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND 		" + hEnter
	EndIf
	cQuery += "SD1.D1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND 		" + hEnter
	cQuery+=  "SD1.D1_CF IN " + FormatIn(cMV_CFOPDEV,";")+" AND 									" + hEnter
	cQuery += "SD1.D_E_L_E_T_ <> '*' AND                                 						" + hEnter
	cQuery += "SF4.D_E_L_E_T_ <> '*'                                     						" + hEnter
	cQuery += "GROUP BY SD1.D1_CF, SD1.D1_COD, SD1.D1_GRUPO, SD1.D1_FILIAL, SF4.F4_CODIGO, SF4.F4_FILIAL, SD1.D1_FORNECE, SD1.D1_LOJA	" + hEnter
	cQuery += "ORDER BY SD1.D1_GRUPO, SD1.D1_COD 	 											" + hEnteR
	
	MemoWrite("LSFATR06a.SQL",cQuery)
	TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP1)
	
	dbSelectArea(cAliasTMP1)
	(cAliasTMP1)->(dbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Populo o vetor para impressao das Devoluções                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	
	While (cAliasTMP1)->(!EOF())
	
	cDescri := ALLTRIM( SUBSTR( POSICIONE("SB1",1,XFILIAL("SB1")+(cAliasTMP1)->D1_COD,"B1_DESC"),1,35 ) )
	nPerdesc := 0//POSICIONE( "SA1",1, XFILIAL( "SA1" ) + (cAliasTMP1)->D1_FORNECE + (cAliasTMP1)->D1_LOJA, "SA1->A1_X_DESCF")                                           
	nTotDesc :=((cAliasTMP1)->TOTAL * (nPerdesc / 100))
	nTotDesc := nTotDesc * -1
	If Len(aDadosDev) = 0
		AADD(aDadosDev,{ALLTRIM( (cAliasTMP1)->D1_COD ), cDescri, (cAliasTMP1)->D1_GRUPO, (cAliasTMP1)->F4_CODIGO, (cAliasTMP1)->QUANT, (cAliasTMP1)->TOTAL, nTotDesc})
	Else
		nPos := aScan( aDadosDev, {|x| ALLTRIM(x[1]) == ALLTRIM( (cAliasTMP1)->D1_COD ) }  )  
		If nPos = 0 
			AADD(aDadosDev,{ALLTRIM( (cAliasTMP1)->D1_COD ), cDescri, (cAliasTMP1)->D1_GRUPO, (cAliasTMP1)->F4_CODIGO, (cAliasTMP1)->QUANT, (cAliasTMP1)->TOTAL, nTotDesc})	
		Else
		    aDadosDev[nPos][5] += (cAliasTMP1)->QUANT
		    aDadosDev[nPos][6] += (cAliasTMP1)->TOTAL
		    aDadosDev[nPos][7] += nTotDesc	    
		EndIf
	EndIf                           
	
	(cAliasTMP1)->( dbskip() ) 
	
	EndDo 

EndIf
For i := 1 to len(aDadosImp)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())

   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   	If lAbortPrint
   	   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
   	   Exit
   	Endif

   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   	//³ Impressao do cabecalho do relatorio. . .                            ³
   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If i <= len(aDadosImp)
		nPesoPrd := POSICIONE("SB1",1,XFILIAL("SB1")+aDadosImp[i][1],"B1_PESO")
		cUMPrd := POSICIONE("SB1",1,XFILIAL("SB1")+aDadosImp[i][1],"B1_UM")
		
	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 10
	   	Endif
			
		If ( i > 1 .AND. (aDadosImp[i-1][3] # aDadosImp[i][3]))// .OR. ( i = len(aDadosImp) )
				
			nTotalQ  += nSubTotQ * nPesoPrd
			nTotalT  += nSubTotT
            nTotalD  += nSubTotD
            nLin += 1
            If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   		nLin := 10
	   		Endif
            
            
			@nLin,00 PSAY "SUB TOTAL DO GRUPO POR KG:"
			@nLin,47 PSAY TRANSFORM(nSubTotQ,"@E 99,999,999.99")
			@nLin,61 PSAY "KG"
		 	@nLin,66 PSAY TRANSFORM(nSubTotT,"@E 99,999,999.99")
		 	@nLin,81 PSAY TRANSFORM(nSubTotD,"@E 99,999,999.99")
		 	@nLin,96 PSAY TRANSFORM(((nSubTotD / nSubTotT) * 100),"@E 999.99")
		 	@nLin,102 PSAY "%"
		  	@nLin,103 PSAY TRANSFORM( ( nSubTotT / nSubTotQ ),"@E 9,999,999.99")
			@nLin,116 PSAY TRANSFORM( ( ( nSubTotT - nSubTotD ) / nSubTotQ ),"@E 9,999,999.99")
			nLin += 1
			If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
		   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   		   nLin := 10
	   		Endif
	   			@nLin,00 PSAY "PARCICIPAÇÃO DO GRUPO NO FATURAMENTO:"
		   		@nLin,72 PSAY TRANSFORM(((nSubTotT / nTotGeral) * 100),"@E  999.99")
		   		@nLin,78 PSAY "%"
		   				
			nSubTotQ := 0
			nSubTotT := 0
		    nSubTotD := 0
			
			nLin += 2 			
		 		
		EndIf
        
	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 10
	   	Endif

	    If ( i = 1 )  .OR. ( aDadosImp[i-1][3] # aDadosImp[i][3] )    
		 	@nLin,00 PSAY "GRUPO: " + aDadosImp[i][3] + " - " + POSICIONE("SBM",1,XFILIAL("SBM")+aDadosImp[i][3],"BM_DESC")
			nLin += 1 	
		EndIf

	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 10
	   	Endif

		@nLin,00 PSAY aDadosImp[i][1]
		@nLin,10 PSAY aDadosImp[i][2]
		@nLin,47 PSAY TRANSFORM(aDadosImp[i][5],"@E 99,999,999.99")
		@nLin,61 PSAY cUMPrd
		@nLin,66 PSAY TRANSFORM(aDadosImp[i][6],"@E 99,999,999.99")
		@nLin,81 PSAY TRANSFORM(aDadosImp[i][7],"@E 99,999,999.99")
		@nLin,96 PSAY TRANSFORM(((aDadosImp[i][7] / aDadosImp[i][6]) * 100),"@E 999.99")
		@nLin,102 PSAY "%"
		@nLin,103 PSAY TRANSFORM( ( aDadosImp[i][6] / aDadosImp[i][5] ),"@E 9,999,999.99")
		@nLin,116 PSAY TRANSFORM( ( ( aDadosImp[i][6] - aDadosImp[i][7] ) / aDadosImp[i][5] ),"@E 9,999,999.99")		
			
		nLin += 1
		
				
	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 10
	   	Endif

		nPosDev := aScan(aDadosDev,{|x| ALLTRIM(x[1]) == aDadosImp[i][1] } )
		If nPosDev # 0 .AND. mv_par05 = 1
 			//nLin += 1
			@nLin,00 PSAY aDadosDev[nPosDev][1] + "  (-) DEVOLUCOES:"
			@nLin,47 PSAY TRANSFORM((aDadosDev[nPosDev][5] * -1),"@E 99,999,999.99")
			@nLin,61 PSAY cUMPrd
			@nLin,66 PSAY TRANSFORM((aDadosDev[nPosDev][6] * -1),"@E 99,999,999.99")
			@nLin,81 PSAY TRANSFORM(aDadosDev[nPosDev][7],"@E 99,999,999.99")
			@nLin,96 PSAY TRANSFORM(((aDadosDev[nPosDev][7] / (aDadosDev[nPosDev][6] * -1)) * 100),"@E 999.99")
			@nLin,102 PSAY "%"
			@nLin,103 PSAY TRANSFORM( ( (aDadosDev[nPosDev][6] * -1) / aDadosDev[nPosDev][5] ),"@E 9,999,999.99")					
			@nLin,116 PSAY TRANSFORM( ( ( (aDadosDev[nPosDev][6] * -1)-aDadosDev[nPosDev][7] ) / aDadosDev[nPosDev][5] ),"@E 9,999,999.99")					
 			nLin += 1
		
		   	If nLin > 75 // Salto de Página. Neste caso o f'ormulario tem 75 linhas...
	   		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   	   nLin := 10
	   		Endif
	
			@nLin,00 PSAY "Sub Total Produto: "
			@nLin,47 PSAY TRANSFORM(aDadosImp[i][5]-aDadosDev[nPosDev][5],"@E 99,999,999.99")
		 	@nLin,61 PSAY cUMPrd
		 	@nLin,66 PSAY TRANSFORM(aDadosImp[i][6]-aDadosDev[nPosDev][6],"@E 99,999,999.99")
		 	@nLin,81 PSAY TRANSFORM(aDadosImp[i][7] + aDadosDev[nPosDev][7],"@E 99,999,999.99")
		 	@nLin,96 PSAY TRANSFORM((((aDadosImp[i][7] + aDadosDev[nPosDev][7]) / (aDadosImp[i][6]-aDadosDev[nPosDev][6])) * 100),"@E 999.99")
			@nLin,102 PSAY "%"
			@nLin,103 PSAY TRANSFORM( ( ( aDadosImp[i][6]-aDadosDev[nPosDev][6] ) / ( aDadosImp[i][5]-aDadosDev[nPosDev][5] ) ),"@E 9,999,999.99")
		 	@nLin,116 PSAY TRANSFORM( ( ( aDadosImp[i][6]-aDadosImp[i][7]-aDadosDev[nPosDev][6] ) / ( aDadosImp[i][5]-aDadosDev[nPosDev][5] ) ),"@E 9,999,999.99")
 			nLin += 1

			nSubTotQ += (aDadosImp[i][5] * nPesoPrd)-(aDadosDev[nPosDev][5]*nPesoPrd)
			nSubTotT += aDadosImp[i][6]-aDadosDev[nPosDev][6]
			nSubTotD += aDadosImp[i][7] + (aDadosDev[nPosDev][7])
		Else
			nSubTotQ += aDadosImp[i][5] * nPesoPrd
			nSubTotT += aDadosImp[i][6]
			nSubTotD += aDadosImp[i][7]
		EndIf
		
		If ( i = len(aDadosImp) )
			nTotalQ  += nSubTotQ
			nTotalT  += nSubTotT
			nTotalD  += nSubTotD
            nLin += 1        
		   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
		   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   		   nLin := 10
	   		Endif

	   		@nLin,00 PSAY "SUB TOTAL DO GRUPO POR KG:"
			@nLin,47 PSAY TRANSFORM(nSubTotQ,"@E 99,999,999.99")
		 	@nLin,61 PSAY "KG"
		 	@nLin,66 PSAY TRANSFORM(nSubTotT,"@E 99,999,999.99")
		 	@nLin,81 PSAY TRANSFORM(nSubTotD,"@E 99,999,999.99")
		 	@nLin,96 PSAY TRANSFORM(((nSubTotD / nSubTotT) * 100),"@E 999.99")
		  	@nLin,102 PSAY "%"
		  	@nLin,103 PSAY TRANSFORM( ( nSubTotT / nSubTotQ ),"@E 9,999,999.99")
			@nLin,116 PSAY TRANSFORM( ( ( nSubTotT - nSubTotD ) / nSubTotQ ),"@E 9,999,999.99")
	
			nLin += 1
			If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
		   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   		   nLin := 10
	   		Endif
	   			@nLin,00 PSAY "PARCICIPAÇÃO DO GRUPO NO FATURAMENTO:"
		   		@nLin,72 PSAY TRANSFORM(((nSubTotT / nTotGeral) * 100),"@E  999.99")
		   		@nLin,78 PSAY "%"
			nLin += 2 			
		 	nSubTotQ := 0
			nSubTotT := 0
			nSubTotD := 0	
		EndIf

								 		
	EndIf

Next i

nLin += 2 			
If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 10
Endif

@nLin,00 PSAY "TOTAL GERAL FATURAMENTO:"
@nLin,44 PSAY TRANSFORM(nTotalQ,"@E 9,999,999,999.99")
@nLin,61 PSAY "KG"
@nLin,63 PSAY TRANSFORM(nTotalT,"@E 9,999,999,999.99")
@nLin,96 PSAY TRANSFORM(((nTotalD / nTotalT)*100),"@E 999.99")
@nLin,102 PSAY "%"
nLin += 1
@nLin,00 PSAY "TOTAL GERAL DESCONTOS:"
@nLin,66 PSAY TRANSFORM(nTotalD,"@E 99,999,999.99")
nLin += 1
@nLin,64 PSAY "_______________"
nLin += 1
@nLin,00 PSAY "TOTAL GERAL LIQUIDO:"
@nLin,63 PSAY TRANSFORM((nTotalT-nTotalD),"@E 9,999,999,999.99") 		




(cAliasTmp)->( dbCloseArea() )
If mv_par05 = 1
	(cAliasTmp1)->( dbCloseArea() )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
                               
//******************************************************************************
// Ajusta as perguntas (SX1) da rotina
//******************************************************************************

Static Function AjustaSX1()

aRegs  	:= {}  
aHelp1  := {}
aHelp2  := {}
aHelp3  := {}                                         
aHelp4	:= {}
aHelp5	:= {}
aHelp6	:= {}
aHelp7	:= {}
aHelp8	:= {}
aHelp9	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd(aRegs,{cPerg,"01","Emissão de       ?","Emissão de       ?","Emissão de       ?","mv_ch01","D",08                      ,0,0,"G","			","mv_par01",         	     "",        	   "",         	     "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"02","Emissão até      ?","Emissão até      ?","Emissão até      ?","mv_ch02","D",08						,0,0,"G","			","mv_par02",         	     "", 	   	       "",    	       	 "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"03","Produto de		 ?","Produto de       ?","Produto de       ?","mv_ch03","C",TAMSX3("D2_COD")[1]     ,0,0,"G","			","mv_par03",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","SB1","","","", ""})
aAdd(aRegs,{cPerg,"04","Produto ate      ?","Produto ate      ?","Produto ate      ?","mv_ch04","C",TAMSX3("D2_COD")[1]     ,0,0,"G","			","mv_par04",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","SB1","","","", ""})
aAdd(aRegs,{cPerg,"05","Inclui Devolução ?","Inclui Devolução ?","Inclui Devolução ?","mv_ch05","N",01						,0,0,"C","naovazio()","mv_par05",		      "Sim",			"Sim",			  "Sim","","", 	  "Nao",	"Nao",	 "Nao","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"06","Dev. Pela Emissão?","Dev. Pela Emissão?","Dev. Pela Emissão?","mv_ch06","N",01						,0,0,"C","naovazio()","mv_par06", 			  "Sim",			"Sim",			  "Sim","","",	  "Nao",  	"Nao", 	 "Nao","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"07","Filial de        ?","Filial de        ?","Filial de        ?","mv_ch07","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par07",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"08","Filial até       ?","Filial até       ?","Filial até       ?","mv_ch08","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par08",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"09","Entregas Futuras ?","Entregas Futuras ?","Entregas Futuras ?","mv_ch09","N",01						,0,0,"C",""			 ,"mv_par09",		      "Sim",			"Sim",			  "Sim","","", 	  "Nao",	"Nao",	 "Nao","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
Aadd( aHelp1 , "Informe a Data inicial."   )
Aadd( aHelp2 , "Informe a Data final. "   )    
Aadd( aHelp3 , "Informe o Produto inicial. ")
Aadd( aHelp4 , "Informe o Produto final. ") 
Aadd( aHelp5 , "Inclui devoluções ?")
Aadd( aHelp6 , "Dev. Pela Emissão?")
Aadd( aHelp7 , "Informe a filial inicial. ")
Aadd( aHelp8 , "Informe a filial final. ")
Aadd( aHelp8 , "Emitir o relatório de vendas com entregas futuras? Padrão é NÃO!")

dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j, aRegs[i,j])	 
			Endif
		Next
		MsUnlock()
	Endif
Next  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o Help dos campos no arquivo de Help³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSX1Help("P." + cPerg + "01.", aHelp1, aHelp1, aHelp1)
PutSX1Help("P." + cPerg + "02.", aHelp2, aHelp2, aHelp2)
PutSX1Help("P." + cPerg + "03.", aHelp3, aHelp3, aHelp3)
PutSX1Help("P." + cPerg + "04.", aHelp4, aHelp4, aHelp4)
PutSX1Help("P." + cPerg + "05.", aHelp5, aHelp5, aHelp5)
PutSX1Help("P." + cPerg + "06.", aHelp6, aHelp6, aHelp6)
PutSX1Help("P." + cPerg + "07.", aHelp7, aHelp7, aHelp7)
PutSX1Help("P." + cPerg + "08.", aHelp8, aHelp8, aHelp8)
PutSX1Help("P." + cPerg + "09.", aHelp9, aHelp9, aHelp9)


Return
