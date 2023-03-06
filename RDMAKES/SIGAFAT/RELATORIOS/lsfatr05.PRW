#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³LSFATR05 º Autor ³ Alexandre Longhinotti º Data ³  23/04/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio para averbação							          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LSFATR05()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Ralatório mensal para averbação"
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}

Private titulo       := "Relatório para averbação"
Private nLin         := 80
Private Cabec1       := "" 
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "LSFATR05" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "LSFATR0005"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LSFATR05" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF2"

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

Local nTotGeral	   := 0
Local cAliasTMP    := GetNextAlias()
Local cAliasTMP1   := GetNextAlias()
Local hEnter	   := CHR(10) + CHR(13)
Local  cGrpAnt     := ""                
Local aDadosImp    := {}  
Local aDadosDev    := {}  

/*
          1         2         3         4         5         6         7         8         9         100       110
0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
---------------------------------------------------------------------------------------------------------------
NF         DATA         CIDADE ORIGEM           UF ORIGEM    CIDADE DESTINO        UF DESTINO PLACA      VALOR
*/  

Cabec1 := "Período de " + dtoc(mv_par01) + " até " + dtoc(mv_par02)
Cabec2 := "NF         DATA         CIDADE ORIGEM           UF ORIGEM    CIDADE DESTINO              UF DESTINO  PLACA        VALOR"                                                                                                      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro dos dados de acordo com os parametros informados pelo usuário. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If (Select(cAliasTMP) <> 0)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
Endif

cQuery := " SELECT
cQuery += "	SF2.F2_FILIAL,
cQuery += "	SF2.F2_DOC,
cQuery += "	SF2.F2_EMISSAO,
cQuery += "	SA1.A1_MUN,
cQuery += "	SA1.A1_EST,
cQuery += "	SF2.F2_VEICUL1,
cQuery += "	SF2.F2_VALBRUT
cQuery += " FROM SF2010 SF2	
cQuery += " INNER JOIN SA1010 SA1
cQuery += "        ON       SF2.F2_CLIENTE    = SA1.A1_COD
cQuery += "        AND      SF2.F2_LOJA    = SA1.A1_LOJA   		
cQuery += " WHERE SF2.F2_FILIAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND  				" + hEnter
cQuery += " SF2.F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND 		" + hEnter
cQuery += " SF2.F2_SERIE = '002'
cQuery += " ORDER BY
cQuery += "	SF2.F2_FILIAL, SF2.F2_DOC


MemoWrite("LSFATR05.SQL",cQuery)
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

CidOri := POSICIONE("SM0",1,"01"+(cAliasTMP)->F2_FILIAL,"M0_CIDCOB")
EstOri := POSICIONE("SM0",1,"01"+(cAliasTMP)->F2_FILIAL,"M0_ESTCOB")
nTotGeral += (cAliasTMP)->F2_VALBRUT
If Len(aDadosImp) = 0
	AADD(aDadosImp,{ALLTRIM( (cAliasTMP)->F2_DOC ), (cAliasTMP)->F2_EMISSAO, CidOri, EstOri, (cAliasTMP)->A1_MUN, (cAliasTMP)->A1_EST, (cAliasTMP)->F2_VEICUL1, (cAliasTMP)->F2_VALBRUT})
Else
	nPos := aScan( aDadosImp, {|x| ALLTRIM(x[1]) == ALLTRIM( (cAliasTMP)->F2_DOC ) }  )  
	If nPos = 0 
	AADD(aDadosImp,{ALLTRIM( (cAliasTMP)->F2_DOC ), (cAliasTMP)->F2_EMISSAO, CidOri, EstOri, (cAliasTMP)->A1_MUN, (cAliasTMP)->A1_EST, (cAliasTMP)->F2_VEICUL1, (cAliasTMP)->F2_VALBRUT})
	Else

	EndIf
EndIf                           

(cAliasTMP)->( dbskip() ) 

EndDo 
CidOri := POSICIONE("SM0",1,"01"+"01LAT01","M0_CIDCOB")
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
        
	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8
	Endif

	  
/*
          1         2         3         4         5         6         7         8         9         100       110
0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
---------------------------------------------------------------------------------------------------------------
NF         DATA         CIDADE ORIGEM            UF ORIGEM    CIDADE DESTINO              UF DESTINO PLACA      VALOR
*/      
		nLin += 1
		
		@nLin,00 PSAY Alltrim(aDadosImp[i][1])
		@nLin,11 PSAY Alltrim(aDadosImp[i][2])
		@nLin,24 PSAY Alltrim(aDadosImp[i][3])
		@nLin,49 PSAY Alltrim(aDadosImp[i][4])
		@nLin,61 PSAY Alltrim(aDadosImp[i][5])
		@nLin,90 PSAY Alltrim(aDadosImp[i][6])
		@nLin,100 PSAY aDadosImp[i][7]
		@nLin,110 PSAY TRANSFORM(aDadosImp[i][8],"@E 99,999,999.99")
			
					
	   	If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
	   	   //nLin += 1
	   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	   nLin := 8   		
	   	Endif
		
		nPosDev := aScan(aDadosDev,{|x| ALLTRIM(x[1]) == aDadosImp[i][1] } )
	
								 		
	EndIf

Next i

nLin += 2 			
If nLin > 75 // Salto de Página. Neste caso o formulario tem 75 linhas...
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif

@nLin,00 PSAY "TOTAL GERAL :"
@nLin,40 PSAY TRANSFORM(nTotGeral,"@E 99,999,999.99")


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
aHelp4	:= {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd(aRegs,{cPerg,"01","Emissão de       ?","Emissão de       ?","Emissão de       ?","mv_ch01","D",08                      ,0,0,"G","			","mv_par01",         	     "",        	   "",         	     "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"02","Emissão até      ?","Emissão até      ?","Emissão até      ?","mv_ch02","D",08						,0,0,"G","			","mv_par02",         	     "", 	   	       "",    	       	 "","","",       "",       "",      "","","",     "",     "",     "","","","","","","","","","","","",""   ,"","","", ""})
aAdd(aRegs,{cPerg,"03","Filial de        ?","Filial de        ?","Filial de        ?","mv_ch03","C",TAMSX3("F2_FILIAL")[1]	,0,0,"G",""          ,"mv_par03",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})
aAdd(aRegs,{cPerg,"04","Filial até       ?","Filial até       ?","Filial até       ?","mv_ch04","C",TAMSX3("F2_FILIAL")[1]	,0,0,"G",""          ,"mv_par04",		         "",			   "",			     "","","", 	     "",	   "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
Aadd( aHelp1 , "Informe a Data inicial."   )
Aadd( aHelp2 , "Informe a Data final. "   )    
Aadd( aHelp3 , "Informe a filial inicial. ")
Aadd( aHelp4 , "Informe a filial final. ")

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


Return