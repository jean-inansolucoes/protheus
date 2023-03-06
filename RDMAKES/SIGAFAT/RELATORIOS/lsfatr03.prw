#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LSFATR03     � Autor � Joel Lipnharski � Data �  09/04/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Media de Vendas por Grupo                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LSFATR03()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Resumo Faturamento"
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}

Private titulo       := "Resumo Faturamento"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LSFATR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "LSFATR0003"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LSFATR03" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD2"

AjustaSX1()                                                 
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport() },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  09/04/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport()

Local nOrdem 
Local nTotalQ      := 0
Local nTotalT      := 0
Local nSubTotQ     := 0
Local nSubTotT 	   := 0
Local cAliasTMP    := GetNextAlias()
Local cAliasTMP1   := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13)
Local  cGrpAnt     := ""                
Local aDadosImp    := {}  
Local aDadosDev    := {}  

/*
          1         2         3         4         5         6         7         8         9
0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
-------------------------------------------------------------------------------------------
PRODUTO  DESCRICAO                      QTDE TOTAL    VALOR TOTAL   MEDIA VALOR  
*/  
Cabec1 := "Per�odo de " + dtoc(mv_par01) + " at� " + dtoc(mv_par02)
Cabec2 := "PRODUTO  DESCRICAO                      QTDE TOTAL    VALOR TOTAL   MEDIA VALOR"

//�������������������������������������������������������������������������Ŀ
//� Filtro dos dados de acordo com os parametros informados pelo usu�rio. �
//�������������������������������������������������������������������������Ŀ
If (Select(cAliasTMP) <> 0)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
Endif

cQuery := "SELECT 	 														" + hEnter
cQuery += "SUM(SD2.D2_QUANT) AS QUANT, 								   		" + hEnter
cQuery += "SUM(SD2.D2_TOTAL) AS TOTAL,  							  		" + hEnter
cQuery += "SD2.D2_FILIAL,									 				" + hEnter
cQuery += "SD2.D2_COD,									 					" + hEnter
cQuery += "SD2.D2_GRUPO,									 				" + hEnter
cQuery += "SF4.F4_FILIAL,									 				" + hEnter
cQuery += "SF4.F4_CODIGO 									 				" + hEnter
cQuery += "FROM " + RetSqlName("SD2") + " SD2						 		" + hEnter
cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4   				 		" + hEnter
cQuery += "ON SD2.D2_TES = SF4.F4_CODIGO                      					   			" + hEnter
cQuery += "AND SD2.D2_FILIAL = SF4.F4_FILIAL                   								" + hEnter
cQuery += "WHERE SD2.D2_FILIAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND  				" + hEnter
cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND 		" + hEnter
cQuery += "SD2.D2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND 						" + hEnter
If mv_par06 = 1
	cQuery += "SF4.F4_DUPLIC = 'S' AND 														" + hEnter	
EndIf
cQuery += "SD2.D_E_L_E_T_ <> '*' AND                                 			   			" + hEnter
cQuery += "SF4.D_E_L_E_T_ <> '*'                                     	   					" + hEnter
cQuery += "GROUP BY SD2.D2_GRUPO, SD2.D2_COD, SD2.D2_FILIAL, SF4.F4_CODIGO, SF4.F4_FILIAL	" + hEnter
cQuery += "ORDER BY SD2.D2_GRUPO, SD2.D2_COD	 											" + hEnter

MemoWrite("LSFATR03.SQL",cQuery)
TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
SetRegua(RecCount(cAliasTMP))
                          
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())

//�������������������������������������������������������������������������Ŀ
//� Populo o vetor para impressao das Vendas                                �
//�������������������������������������������������������������������������Ŀ

While (cAliasTMP)->(!EOF())

cDescri := ALLTRIM( SUBSTR( POSICIONE("SB1",1,XFILIAL("SB1")+(cAliasTMP)->D2_COD,"B1_DESC"),1,25 ) )

If Len(aDadosImp) = 0
	AADD(aDadosImp,{ALLTRIM( (cAliasTMP)->D2_COD ), cDescri, (cAliasTMP)->D2_GRUPO, (cAliasTMP)->F4_CODIGO, (cAliasTMP)->QUANT, (cAliasTMP)->TOTAL})
Else
	nPos := aScan( aDadosImp, {|x| ALLTRIM(x[1]) == ALLTRIM( (cAliasTMP)->D2_COD ) }  )  
	If nPos = 0 
	AADD(aDadosImp,{ALLTRIM( (cAliasTMP)->D2_COD ), cDescri, (cAliasTMP)->D2_GRUPO, (cAliasTMP)->F4_CODIGO, (cAliasTMP)->QUANT, (cAliasTMP)->TOTAL})
	Else
	    aDadosImp[nPos][5] += (cAliasTMP)->QUANT
	    aDadosImp[nPos][6] += (cAliasTMP)->TOTAL	    
	EndIf
EndIf                           

(cAliasTMP)->( dbskip() ) 

EndDo 


//�������������������������������������������������������������������������Ŀ
//� Filtro dos dados de Devol��es.                                          �
//�������������������������������������������������������������������������Ŀ
If mv_par05 = 1

	If (Select(cAliasTMP1) <> 0)
		dbSelectArea(cAliasTMP1)
		(cAliasTMP1)->(dbCloseArea())
	Endif
	
	cQuery := "SELECT 	 														" + hEnter
	cQuery += "SUM(SD1.D1_QUANT) AS QUANT, 								   		" + hEnter
	cQuery += "SUM(SD1.D1_TOTAL) AS TOTAL,  							  		" + hEnter
	cQuery += "SD1.D1_FILIAL,									 				" + hEnter
	cQuery += "SD1.D1_COD,									 					" + hEnter
	cQuery += "SD1.D1_GRUPO,									 				" + hEnter
	cQuery += "SF4.F4_FILIAL, 									 				" + hEnter
	cQuery += "SF4.F4_CODIGO 									 				" + hEnter
	cQuery += "FROM " + RetSqlName("SD1") + " SD1						 		" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4   				 		" + hEnter
	cQuery += "ON SD1.D1_TES = SF4.F4_CODIGO                      				" + hEnter
	cQuery += "AND SD1.D1_FILIAL = SF4.F4_FILIAL                   				" + hEnter
	cQuery += "WHERE SD1.D1_FILIAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND  				" + hEnter
	cQuery += "SD1.D1_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND 		" + hEnter
	cQuery += "SD1.D1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND 		" + hEnter
	If mv_par06 = 1
		cQuery += "SF4.F4_DUPLIC = 'S' AND 														" + hEnter	
	EndIf
	cQuery += "SD1.D_E_L_E_T_ <> '*' AND                                 						" + hEnter
	cQuery += "SF4.D_E_L_E_T_ <> '*'                                     						" + hEnter
	cQuery += "GROUP BY SD1.D1_COD, SD1.D1_GRUPO, SD1.D1_FILIAL, SF4.F4_CODIGO, SF4.F4_FILIAL	" + hEnter
	cQuery += "ORDER BY SD1.D1_GRUPO, SD1.D1_COD 	 											" + hEnteR
	
	MemoWrite("LSFATR03a.SQL",cQuery)
	TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP1)
	
	dbSelectArea(cAliasTMP1)
	(cAliasTMP1)->(dbGoTop())
	
	//�������������������������������������������������������������������������Ŀ
	//� Populo o vetor para impressao das Devolu��es                            �
	//�������������������������������������������������������������������������Ŀ
	
	While (cAliasTMP1)->(!EOF())
	
	cDescri := ALLTRIM( SUBSTR( POSICIONE("SB1",1,XFILIAL("SB1")+(cAliasTMP1)->D1_COD,"B1_DESC"),1,25 ) )
	
	If Len(aDadosDev) = 0
		AADD(aDadosDev,{ALLTRIM( (cAliasTMP1)->D1_COD ), cDescri, (cAliasTMP1)->D1_GRUPO, (cAliasTMP1)->F4_CODIGO, (cAliasTMP1)->QUANT, (cAliasTMP1)->TOTAL})
	Else
		nPos := aScan( aDadosDev, {|x| ALLTRIM(x[1]) == ALLTRIM( (cAliasTMP1)->D1_COD ) }  )  
		If nPos = 0 
			AADD(aDadosDev,{ALLTRIM( (cAliasTMP1)->D1_COD ), cDescri, (cAliasTMP1)->D1_GRUPO, (cAliasTMP1)->F4_CODIGO, (cAliasTMP1)->QUANT, (cAliasTMP1)->TOTAL})	
		Else
		    aDadosDev[nPos][5] += (cAliasTMP1)->QUANT
		    aDadosDev[nPos][6] += (cAliasTMP1)->TOTAL	    
		EndIf
	EndIf                           
	
	(cAliasTMP1)->( dbskip() ) 
	
	EndDo 

EndIf

For i := 1 to len(aDadosImp)

	//���������������������������������������������������������������������Ŀ
	//� SETREGUA -> Indica quantos registros serao processados para a regua �
	//�����������������������������������������������������������������������
	SetRegua(RecCount())

   	//���������������������������������������������������������������������Ŀ
   	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������

   	If lAbortPrint
   	   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
   	   Exit
   	Endif

   	//���������������������������������������������������������������������Ŀ
   	//� Impressao do cabecalho do relatorio. . .                            �
   	//�����������������������������������������������������������������������

	If i <= len(aDadosImp)
		
	   	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif
			
		If ( i > 1 .AND. (aDadosImp[i-1][3] # aDadosImp[i][3]))// .OR. ( i = len(aDadosImp) )
			nTotalQ  += nSubTotQ
			nTotalT  += nSubTotT

			@nLin,00 PSAY "SUB TOTAL DO GRUPO:"
			@nLin,37 PSAY TRANSFORM(nSubTotQ,"@E  9,999,999.99")
		 	@nLin,51 PSAY TRANSFORM(nSubTotT,"@E 99,999,999.99")
		  	@nLin,65 PSAY TRANSFORM( ( nSubTotT / nSubTotQ ),"@E 9,999,999.99")
				
			nSubTotQ := 0
			nSubTotT := 0
		
			nLin += 2 			
		 		
		EndIf
        
	   	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif

	    If ( i = 1 )  .OR. ( aDadosImp[i-1][3] # aDadosImp[i][3] )    
		 	@nLin,00 PSAY "GRUPO: " + aDadosImp[i][3] + " - " + POSICIONE("SBM",1,XFILIAL("SBM")+aDadosImp[i][3],"BM_DESC")
			nLin += 1 	
		EndIf

	   	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif

		@nLin,00 PSAY aDadosImp[i][1]
		@nLin,10 PSAY aDadosImp[i][2]
		@nLin,37 PSAY TRANSFORM(aDadosImp[i][5],"@E 9,999,999.99")
		@nLin,51 PSAY TRANSFORM(aDadosImp[i][6],"@E 99,999,999.99")
		@nLin,65 PSAY TRANSFORM( ( aDadosImp[i][6] / aDadosImp[i][5] ),"@E 9,999,999.99")		
		nLin += 1
		
	   	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif

		nPosDev := aScan(aDadosDev,{|x| ALLTRIM(x[1]) == aDadosImp[i][1] } )
		If nPosDev # 0 .AND. mv_par05 = 1
 			//nLin += 1
			@nLin,00 PSAY "(-) DEVOLUCOES:"
			@nLin,37 PSAY TRANSFORM(aDadosDev[nPosDev][5],"@E 9,999,999.99")
			@nLin,51 PSAY TRANSFORM(aDadosDev[nPosDev][6],"@E 99,999,999.99")
			@nLin,65 PSAY TRANSFORM( ( aDadosDev[nPosDev][6] / aDadosDev[nPosDev][5] ),"@E 9,999,999.99")					
 			nLin += 1
		
		   	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	   		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   	   nLin := 8
	   		Endif

			@nLin,00 PSAY "Sub Total Produto: "
			@nLin,37 PSAY TRANSFORM(aDadosImp[i][5]-aDadosDev[nPosDev][5],"@E  9,999,999.99")
		 	@nLin,51 PSAY TRANSFORM(aDadosImp[i][6]-aDadosDev[nPosDev][6],"@E 99,999,999.99")
		  	@nLin,65 PSAY TRANSFORM( ( (aDadosImp[i][6]-aDadosDev[nPosDev][6] ) / ( aDadosImp[i][5]-aDadosDev[nPosDev][5] ) ),"@E 9,999,999.99")
 			nLin += 1

			nSubTotQ += aDadosImp[i][5]-aDadosDev[nPosDev][5]
			nSubTotT += aDadosImp[i][6]-aDadosDev[nPosDev][6]
		Else
			nSubTotQ += aDadosImp[i][5]
			nSubTotT += aDadosImp[i][6]
		EndIf
		
		If ( i = len(aDadosImp) )
			nTotalQ  += nSubTotQ
			nTotalT  += nSubTotT
        
		   	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   		   nLin := 8
	   		Endif

			@nLin,00 PSAY "SUB TOTAL DO GRUPO:"
			@nLin,37 PSAY TRANSFORM(nSubTotQ,"@E  9,999,999.99")
		 	@nLin,51 PSAY TRANSFORM(nSubTotT,"@E 99,999,999.99")
		  	@nLin,65 PSAY TRANSFORM( ( nSubTotT / nSubTotQ ),"@E 9,999,999.99")
				
			nSubTotQ := 0
			nSubTotT := 0
		
			nLin += 2 			
		 		
		EndIf

								 		
	EndIf

Next i

nLin += 2 			
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif

@nLin,00 PSAY "TOTAL GERAL:"
@nLin,37 PSAY TRANSFORM(nTotalQ,"@E 9,999,999.99")
@nLin,51 PSAY TRANSFORM(nTotalT,"@E 99,999,999.99")
@nLin,65 PSAY TRANSFORM( ( nTotalT / nTotalQ ),"@E 9,999,999.99")

(cAliasTmp)->( dbCloseArea() )
If mv_par05 = 1
	(cAliasTmp1)->( dbCloseArea() )
EndIf

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

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

//�������������������������������������������������������
//�Defini��o dos itens do grupo de perguntas a ser criado�
//�������������������������������������������������������
aAdd(aRegs,{cPerg,"01","Emiss�o de       ?","Emiss�o de       ?","Emiss�o de       ?","mv_ch01","D",08                      ,0,0,"G","			","mv_par01",         	     "",        	   "",         	     "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"02","Emiss�o at�      ?","Emiss�o at�      ?","Emiss�o at�      ?","mv_ch02","D",08						,0,0,"G","			","mv_par02",         	     "", 	   	       "",    	       	 "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"03","Produto de		 ?","Produto de       ?","Produto de       ?","mv_ch03","C",TAMSX3("D2_COD")[1]     ,0,0,"G","			","mv_par03",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","SB1","","","", ""})
aAdd(aRegs,{cPerg,"04","Produto ate      ?","Produto ate      ?","Produto ate      ?","mv_ch04","C",TAMSX3("D2_COD")[1]     ,0,0,"G","			","mv_par04",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","SB1","","","", ""})
aAdd(aRegs,{cPerg,"05","Inclui Devolu��o ?","Inclui Devolu��o ?","Inclui Devolu��o ?","mv_ch05","N",01						,0,0,"C","naovazio()","mv_par05",		      "Sim",			"Sim",			  "Sim","","", 	  "Nao",	"Nao",	 "Nao","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"06","Quanto a TES     ?","Quanto a TES     ?","Quanto a TES     ?","mv_ch06","N",01						,0,0,"C","naovazio()","mv_par06", "Gera Financeiro","Gera Financeiro","Gera Financeiro","","",	"Todas",  "Todas", "Todas","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"07","Filial de        ?","Filial de        ?","Filial de        ?","mv_ch07","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par07",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"08","Filial at�       ?","Filial at�       ?","Filial at�       ?","mv_ch08","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par08",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","",""   ,"","","", ""})

//���������������������������������������������������Ŀ
//�Montagem do Help de cada item do Grupo de Perguntas�
//�����������������������������������������������������   
Aadd( aHelp1 , "Informe a Data inicial."   )
Aadd( aHelp2 , "Informe a Data final. "   )    
Aadd( aHelp3 , "Informe o Produto inicial. ")
Aadd( aHelp4 , "Informe o Produto final. ") 
Aadd( aHelp5 , "Inclui devolu��es ?.")
Aadd( aHelp6 , "TES Gera Financeiro ou N�o?")
Aadd( aHelp7 , "Informe a filial inicial. ")
Aadd( aHelp8 , "Informe a filial final. ")

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

//���������������������������������������������Ŀ
//�Atualiza o Help dos campos no arquivo de Help�
//�����������������������������������������������
PutSX1Help("P." + cPerg + "01.", aHelp1, aHelp1, aHelp1)
PutSX1Help("P." + cPerg + "02.", aHelp2, aHelp2, aHelp2)
PutSX1Help("P." + cPerg + "03.", aHelp3, aHelp3, aHelp3)
PutSX1Help("P." + cPerg + "04.", aHelp4, aHelp4, aHelp4)
PutSX1Help("P." + cPerg + "05.", aHelp5, aHelp5, aHelp5)
PutSX1Help("P." + cPerg + "06.", aHelp6, aHelp6, aHelp6)
PutSX1Help("P." + cPerg + "07.", aHelp7, aHelp7, aHelp7)
PutSX1Help("P." + cPerg + "08.", aHelp8, aHelp8, aHelp8)

Return