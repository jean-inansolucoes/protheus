#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSGPER03  º Autor ³ Alexandre Longihnotti º Data ³  17/04/12º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio funcionarios por centro de custos                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LSGPER03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de funcionários x C. Custo"
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}

Private titulo       := "Relação de funcionários x C. Custo"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130
Private tamanho      := "M"
Private nomeprog     := "LSGPER03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "LSGPER0003"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LSGPER03" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SRA"

AjustaSX1()                                                 
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
Local cAliasTMP    := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13)
Local nCount := 0  
Local nTotalT      := 0
Local nSubTotT 	   := 0
Local aDadosImp    := {}  

/*
                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
		   0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
		   ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		   MATRIC NOME                                        ADMISSAO     FUNCAO                               SALARIO    SIT
*/  

If mv_par03 =='D'
Cabec1 := "   MATRIC NOME                                        ADMISSAO     FUNCAO                               SALARIO    SIT  DATA DEMISSAO"
Else
Cabec1 := "   MATRIC NOME                                        ADMISSAO     FUNCAO                               SALARIO    SIT"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro dos dados de acordo com os parametros informados pelo usuário. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If (Select(cAliasTMP) <> 0)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
Endif;				   								


cQuery := " SELECT   SRA.RA_MAT,																" + hEnter
cQuery += "			 SRA.RA_NOME,																" + hEnter
cQuery += "          SRA.RA_ADMISSA,															" + hEnter
cQuery += "          SRJ.RJ_DESC,								   								" + hEnter
cQuery += "          SRA.RA_SALARIO,							   								" + hEnter                    
cQuery += "          SRA.RA_SITFOLH,							   								" + hEnter
cQuery += "          SRA.RA_DEMISSA,							   								" + hEnter                    
cQuery += "          SRA.RA_CC,									   								" + hEnter                    
cQuery += "          CTT.CTT_DESC01								   								" + hEnter                    
cQuery += " FROM SRA010 SRA										   								" + hEnter 
cQuery += " INNER JOIN SRJ010 SRJ 																" + hEnter 
cQuery += "         ON         RA_CODFUNC       = RJ_FUNCAO										" + hEnter 
cQuery += " INNER JOIN CTT010 CTT																" + hEnter 
cQuery += "         ON        RA_CC            = CTT_CUSTO										" + hEnter 
cQuery += "WHERE ( SRA.RA_CC         BETWEEN '" + mv_par05 + "'        AND '" + mv_par06 + "' )	" + hEnter

If mv_par03 =='D'
	cQuery += "AND ( SRA.RA_DEMISSA    BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + " ') " + hEnter
Else
    cQuery += "AND ( SRA.RA_ADMISSA    BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + " ') " + hEnter
Endif

DO CASE

	CASE "A" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'A'											" + hEnter
	CASE "D" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'D'											" + hEnter
	CASE "F" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'F'								   			" + hEnter		
	CASE "T" == mv_par03
		cQuery += "AND         SRA.RA_SITFOLH   =  'T'								   			" + hEnter
	CASE Alltrim(mv_par03) == ""
		cQuery += "AND (        SRA.RA_SITFOLH   =  'F' 								   		" + hEnter
		cQuery += "OR          SRA.RA_SITFOLH   =  'A' 								   			" + hEnter
		cQuery += "OR          SRA.RA_SITFOLH   =  ' ' )								   		" + hEnter
END CASE

cQuery += "AND         SRA.D_E_L_E_T_   != '*'													" + hEnter
cQuery += "AND         SRJ.D_E_L_E_T_   != '*'					   								" + hEnter
cQuery += "AND         CTT.D_E_L_E_T_   != '*'													" + hEnter
cQuery += "AND         SRA.RA_CC	    != '02.01.01.001   '									" + hEnter
cQuery += "AND 		 ( SRA.RA_FILIAL         BETWEEN '" + mv_par07 + "'        AND '" + mv_par08 + "' )	" + hEnter
cQuery += "GROUP BY
cQuery += "          SRA.RA_MAT,															" + hEnter																
cQuery += "          SRA.RA_NOME,													   		" + hEnter																
cQuery += "          SRA.RA_ADMISSA,														" + hEnter															
cQuery += "          SRJ.RJ_DESC,															" + hEnter							   								
cQuery += "          SRA.RA_SALARIO,														" + hEnter							   								
cQuery += "          SRA.RA_SITFOLH,														" + hEnter							   								
cQuery += "          SRA.RA_DEMISSA,														" + hEnter	
cQuery += "          SRA.RA_CC,									   							" + hEnter
cQuery += "          CTT.CTT_DESC01															" + hEnter
cQuery += "ORDER BY																			" + hEnter
cQuery += "        SRA.RA_CC,								   							" + hEnter
cQuery += "        SRA.RA_NOME								   							" + hEnter


MemoWrite("LSGPER03.SQL",cQuery)
TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
SetRegua(RecCount(cAliasTMP))
                          
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Populo o vetor para impressao dos funcionarios                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

While (cAliasTMP)->(!EOF())
	
	If Len(aDadosImp) = 0
		AADD(aDadosImp,{(cAliasTMP)->RA_MAT, ALLTRIM( (cAliasTMP)->RA_NOME ), (cAliasTMP)->RA_ADMISSA, SUBSTR((cAliasTMP)->RJ_DESC,1,35), (cAliasTMP)->RA_SALARIO, (cAliasTMP)->RA_SITFOLH, (cAliasTMP)->RA_DEMISSA, (cAliasTMP)->RA_CC, (cAliasTMP)->CTT_DESC01 })
	Else
		nPos := aScan( aDadosImp, {|x| ALLTRIM(x[1]) == ALLTRIM( (cAliasTMP)->RA_MAT ) }  )
		AADD(aDadosImp,{(cAliasTMP)->RA_MAT, ALLTRIM( (cAliasTMP)->RA_NOME ), (cAliasTMP)->RA_ADMISSA, SUBSTR((cAliasTMP)->RJ_DESC,1,35), (cAliasTMP)->RA_SALARIO, (cAliasTMP)->RA_SITFOLH, (cAliasTMP)->RA_DEMISSA, (cAliasTMP)->RA_CC, (cAliasTMP)->CTT_DESC01 })
	EndIf

	(cAliasTMP)->( dbskip() ) 	
EndDo 

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
		
		If ( i > 1 .AND. (aDadosImp[i-1][8] # aDadosImp[i][8])) .AND. ( nSubTotT > 0 ) .AND. ( i != len(aDadosImp) )		
			@nLin,00 PSAY "Total de Funcionários no CC:"
			@nLin,37 PSAY TRANSFORM(nSubTotT,"@E  999999")
		 	nSubTotT := 0				
			
			nLin += 2 	 		
		EndIf
	           
	   	If nLin > 73 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif

	    If ( i = 1 )  .OR. ( aDadosImp[i-1][8] # aDadosImp[i][8] )    
		 	@nLin,00 PSAY Alltrim(aDadosImp[i][8]) + " : " + aDadosImp[i][9]
			nLin += 1 	
		EndIf

	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif
        
   		@nLin,03 PSAY aDadosImp[i][1]
		@nLin,10 PSAY aDadosImp[i][2]
   		@nLin,54 PSAY STOD(aDadosImp[i][3])
   		@nLin,67 PSAY aDadosImp[i][4]
  		If mv_par04 == 1
  			@nLin,99 PSAY TRANSFORM(aDadosImp[i][5],"@E 99,999,999.99")
  		EndIf
  		If Alltrim(aDadosImp[i][6]) != ""
  			@nLin,117 PSAY aDadosImp[i][6]
 		Else
 		    @nLin,117 PSAY "N"
 		EndIf
 		If mv_par03 =='D'
			@nLin,122 PSAY STOD(aDadosImp[i][7])
		EndIf

		nLin += 1
	
	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif

		If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	   	Endif
		
		nSubTotT := nSubTotT + 1 
			
		If ( i = len(aDadosImp) )
			 				
			@nLin,00 PSAY "Total de Funcionários no CC:"
			@nLin,37 PSAY TRANSFORM(nSubTotT,"@E  999999")
		 	nSubTotT := 0				
			
			nLin += 2 	 		
		EndIf
								 		
	EndIf

Next i

nLin += 3 			
If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif

@nLin,00 PSAY "TOTAL DE FUNIONÁRIOS: "
@nLin,23 PSAY Len(aDadosImp)
nLin += 2
If nLin > 75 // Salto de Página. Neste caso o formulario tem 60 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 7
Endif
@nLin,00 PSAY "Legenda Situações: N = NORMAL, F = FERIAS, T = TRANSFERIDO"
nLin += 1
If nLin > 75 // Salto de Página. Neste caso o formulario tem 60 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 7
Endif
@nLin,00 PSAY "                   A = AFASTADO, D = DEMITIDO"

(cAliasTmp)->( dbCloseArea() )

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
aHelp4  := {}
aHelp5  := {}
aHelp6  := {}
aHelp7  := {}
aHelp8  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd(aRegs,{cPerg,"01","Periodo de       ?","Periodo de       ?","Periodo de       ?","mv_ch01","D",08                      ,0,0,"G","			","mv_par01",         	     "",        	   "",         	     "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"02","Periodo até      ?","Periodo até      ?","Periodo até      ?","mv_ch02","D",08						,0,0,"G","			","mv_par02",         	     "", 	   	       "",    	       	 "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"03","Situação         :","Situação         :","Situação         :","mv_ch03","C",01						,0,0,"G","			","mv_par03",         	     "", 	   	       "",    	       	 "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"04","Imp. Salário     ?","Imp. Salário     ?","Imp. Salário     ?","mv_ch04","N",01						,0,1,"C","			","mv_par04",				 "Sim","Sim","Sim","",				 "","Não","Não","Não",	   "",		"","","",	  "",	  "",	  "","","","","","","","","","", "","","" ,""})
aAdd(aRegs,{cPerg,"05","Centro Custo de  ?","Centro Custo de  ?","Centro Custo de  ?","mv_ch05","C",TAMSX3("CTT_CUSTO")[1]  ,0,0,"G","			","mv_par05",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","CTT","","","", ""})
aAdd(aRegs,{cPerg,"06","Centro Custo até ?","Centro Custo até ?","Centro Custo até ?","mv_ch06","C",TAMSX3("CTT_CUSTO")[1]  ,0,0,"G","			","mv_par06",                "",               "",               "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","","CTT","","","", ""})
aAdd(aRegs,{cPerg,"07","Filial de        ?","Filial de        ?","Filial de        ?","mv_ch07","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par07",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})
aAdd(aRegs,{cPerg,"08","Filial até       ?","Filial até       ?","Filial até       ?","mv_ch08","C",TAMSX3("D2_FILIAL")[1]	,0,0,"G",""          ,"mv_par08",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
Aadd( aHelp1 , "Informe a Data inicial.					 " )
Aadd( aHelp2 , "Informe a Data final. 					 " )
Aadd( aHelp3 , "Informe a situação dos funionários.      " )     
Aadd( aHelp3 , "Ex. A= Afastados, D=Demitidos			 " )
Aadd( aHelp3 , "F = Férias, T = Transferidos			 " )
Aadd( aHelp3 , "Branco = Ativos (Normal+Ferias)			 " )
Aadd( aHelp4 , "Informe se imprime salário no relatório! " )      
Aadd( aHelp5 , "Informe o Centro de Custo inicial		 " ) 
Aadd( aHelp6 , "Informe o Centro de Custo final			 " ) 
Aadd( aHelp7 , "Informe a filial inicial. 				 " )
Aadd( aHelp8 , "Informe a filial final. 				 " )


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
Return
