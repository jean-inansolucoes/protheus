#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSFIN016 ³ Autor ³Alexandre Longhi        ³ Data ³22.03.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Descri‡…o ³Rotina para alteção vencimento borderô pagamentos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LSFIN016()

Local   aDesc        := { "Este programa altera os títulos",;
						  "que estão em borderô de pagamentos",;
						  "para a data informada nos parâmetros"}
Private aDADOS := {}
Private nCOUNT := 0


						  
cPerg    := "LSFIN00016"
AjustaSX1()
If !Pergunte( cPerg,.T., "Parâmetros - Alteração Venc Borderô" )
	Set Filter to
	Return
Endif

If (ApMsgNoYes("Atenção isso irá alterar o vencimento de todos os títulos do borderô " + mv_par01 +" para o dia " + DTOC(mv_par02) +", deseja Continuar?", "Alteração Vencimento" ))
	cFiltro := "SE2->E2_NUMBOR = '"+ mv_par01	+"' 		  "  

	dbSelectArea("SE2")
	SET FILTER TO &(cFiltro)
	SE2->(dbGoTop())
	While !SE2->(EOF())
		If RecLock("SE2",.F.)
			SE2->E2_VENCTO  := mv_par02
			SE2->E2_VENCREA := mv_par02
			SE2->(MsUnLock())
			aAdd ( aDADOS, {"SE2", SE2->E2_FILIAL, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_VENCORI} )
			nCOUNT += 1
		EndIf
		SE2->(dbSkip())
	Enddo
	SET FILTER TO
EndIf

Aviso("Aviso","Processo concluído!"+chr(13)+chr(10)+"Registros processados: "+cValToChar(nCOUNT),{"OK"})
If Len(aDADOS) > 0
	cTEXTO := "Log de registros processados - Tabela: "+aDADOS[01,01]+chr(13)+chr(10)
	AutoGRLog(cTEXTO)
	cTEXTO := "FILIAL - SERIE/PREFIXO - DOC/TITULO - CLI/FOR - LOJA - VENC ORIGINAL"
	AutoGRLog(cTEXTO)
	For nI := 1 to Len(aDADOS)
		cTEXTO := aDADOS[nI,02]+" - "+aDADOS[nI,03]+" - "+aDADOS[nI,04]+" - "+aDADOS[nI,05]+" - "+aDADOS[nI,06]+" - "+DTOC(aDADOS[nI,07])
		AutoGRLog(cTEXTO)
	Next nI
	MostraErro()
EndIf

//******************************************************************************
// Ajusta as perguntas (SX1) da rotina
//******************************************************************************

Static Function AjustaSX1()

aRegs  	:= {}
aHelp1  := {}
aHelp2  := {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd(aRegs,{cPerg,"01","Num Borderô   ?","Num Borderô   ?","Num Borderô   ?","mv_ch1" ,"C",TAMSX3("E2_NUMBOR")[1] ,0,0,"G","			","mv_par01",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"02","Novo Vencimento","Novo Vencimento","Novo Vencimento","mv_ch2" ,"D",08 ,0,0,"G","								","mv_par02",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aHelp1 , "Informe o Numero do Borderô que deseja  ")
Aadd( aHelp1 , "alterar.    	 				  		")
Aadd( aHelp2 , "Informe a nova data de vencimetno para  ")
Aadd( aHelp2 , "os títulos do borderô.   				")


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


Return 

Return

