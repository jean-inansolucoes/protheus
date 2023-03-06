#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH"     
#define DMPAPER_A4 9
 // A4 210 x 297 mm
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSOMS07   ³ Autor  ³Alexandre      ³ Data ³15.10.2019  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Altera Doc Origem NF de retorno			                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**------------------------------------------------------------------**
USER FUNCTION LSOMS07()
**------------------------------------------------------------------**
   /*	Local   aDesc        := { "Este programa altera os campos",;
							  "D2_ITEMORI, D2_SERIEORI",;
   							  "para notas de devolução de velor"} */
	Private aDADOS := {}
	Private nCOUNT := 0
	
	
							  
	cPerg    := "LSOMS00007"
	AjustaSX1()
	If !Pergunte( cPerg,.T., "Parâmetros - Alteração Item e Série de Origem" )
		Set Filter to
		Return
	Endif
	
	If (ApMsgNoYes("Atenção isso irá alterar o item e serie de origem dos documentos selecionados, deseja Continuar?", "Alteração Serie e Item de Origem SD2" ))
		cFiltro := "SD2->D2_FILIAL = '"+ mv_par01	+"' .AND. SD2->D2_DOC = '"+ mv_par02	+"' .AND. SD2->D2_SERIE = '"+ mv_par03	+"' .AND. SD2->D2_ITEM = '"+ mv_par04	+"'		  "  
	
		dbSelectArea("SD2")
		SET FILTER TO &(cFiltro)
		SD2->(dbGoTop())
		While !SD2->(EOF())
			If RecLock("SD2",.F.)
				SD2->D2_SERIORI := mv_par05
				SD2->D2_ITEMORI := mv_par06
				SD2->(MsUnLock())
				aAdd ( aDADOS, {"SD2", SD2->D2_FILIAL, SD2->D2_DOC, SD2->D2_SERIE} )
				nCOUNT += 1
			EndIf
			SD2->(dbSkip())
		Enddo
		SET FILTER TO
	EndIf
	
	Aviso("Aviso","Processo concluído!"+chr(13)+chr(10)+"Registros processados: "+cValToChar(nCOUNT),{"OK"})
	If Len(aDADOS) > 0
		cTEXTO := "Log de registros processados - Tabela: "+aDADOS[01,01]+chr(13)+chr(10)
		AutoGRLog(cTEXTO)
		cTEXTO := "FILIAL - DOC - SERIE"
		AutoGRLog(cTEXTO)
		For nI := 1 to Len(aDADOS)
			cTEXTO := aDADOS[nI,02]+" - "+aDADOS[nI,03]+" - "+aDADOS[nI,04]
			AutoGRLog(cTEXTO)
		Next nI
		MostraErro()
	EndIf

Return()



**/*----------------------------------------------------*/**
Static Function ajustaSX1()
**/*----------------------------------------------------*/**

/*aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Carga a ser considerada.')
PutSx1(cPerg,"01","Carga de       ?","Carga de       ?","Carga de       ?","mv_ch1","C",6,0,0,"G","","DAK","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)    */

		aRegs  	:= {}
		aHelp1  := {}
		aHelp2  := {}
		aHelp3  := {}
		aHelp4  := {}
		aHelp5  := {} 
		aHelp6  := {}

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Definição dos itens do grupo de perguntas a ser criado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		aAdd(aRegs,{cPerg,"01","Filial    ?","Filial    ?","Série Nota?","mv_ch1" ,"C",TAMSX3("D2_FILIAL")[1],0,0,"G","			","mv_par01",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
		aAdd(aRegs,{cPerg,"02","Num Nota  ?","Num Nota  ?","Série Nota?","mv_ch2" ,"C",TAMSX3("D2_DOC")[1]   ,0,0,"G","			","mv_par02",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
		aAdd(aRegs,{cPerg,"03","Série Nota?","Série Nota?","Série Nota?","mv_ch3" ,"C",TAMSX3("D2_SERIE")[1] ,0,0,"G","			","mv_par03",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
		aAdd(aRegs,{cPerg,"04","Item Nota?","Item Nota?","Item Nota?","mv_ch4" ,"C",TAMSX3("D2_ITEM")[1] ,0,0,"G","			","mv_par04",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
		aAdd(aRegs,{cPerg,"05","Serie Orig?","Serie Orig?","Serie Orig?","mv_ch5" ,"C",TAMSX3("D2_SERIORI")[1] ,0,0,"G","			","mv_par05",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
		aAdd(aRegs,{cPerg,"06","Item Orige?","Item Orige?","Item Orige?","mv_ch6" ,"C",TAMSX3("D2_ITEMORI")[1] ,0,0,"G","			","mv_par06",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})

		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do Help de cada item do Grupo de Perguntas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd( aHelp1 , "Informe a Filial da Nota que deseja     ")
		Aadd( aHelp1 , "alterar.    	 				  		")
		Aadd( aHelp2 , "Informe o numero da Nota que deseja     ")
		Aadd( aHelp2 , "alterar.   		                  		")
		Aadd( aHelp3 , "Informe o item da Nota que deseja     ")
		Aadd( aHelp3 , "alterar.   		                  		")
		Aadd( aHelp4 , "Informe a série  da Nota que deseja     ")
		Aadd( aHelp4 , "alterar.   		                  		")
		Aadd( aHelp5 , "Informe a série de origem que deseja    ")
		Aadd( aHelp5 , "informar. 		                  		")
		Aadd( aHelp6 , "Informe o item de origem que deseja     ")
		Aadd( aHelp6 , "informar. 		                  		")
		
		
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
		PutSX1Help("P." + cPerg + "06.", aHelp5, aHelp5, aHelp6)

               
Return .t.
