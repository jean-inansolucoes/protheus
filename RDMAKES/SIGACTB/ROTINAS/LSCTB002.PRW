#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSCTB002 ³ Autor ³Rafael Parma            ³ Data ³22.03.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Descri‡…o ³Rotina para limpeza do campo F1_DTLANC/F2_DTLANC.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
User Function LSCTB002()
*-----------------------------------------------------------------------------*
Private cPerg  := "LSCTB00002"
Private nLENLA := TAMSX3("E1_LA")[1]
Private nCOUNT := 0
Private aDADOS := {}
                           
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
	Do Case
		Case mv_par01 == 1	//--Doc. Entrada
			
			cFiltro := "SF1->F1_FILIAL			>= '"+ mv_par02			+"' .AND. "
			cFiltro += "SF1->F1_FILIAL 			<= '"+ mv_par03			+"' .AND. "
			cFiltro += "SF1->F1_SERIE 			>= '"+ mv_par04			+"' .AND. "
			cFiltro += "SF1->F1_SERIE 			<= '"+ mv_par05			+"' .AND. "
			cFiltro += "SF1->F1_DOC	  			>= '"+ mv_par06			+"' .AND. "
			cFiltro += "SF1->F1_DOC	   			<= '"+ mv_par07			+"' .AND. "		
			cFiltro += "SF1->F1_FORNECE			>= '"+ mv_par08			+"' .AND. "		
			cFiltro += "SF1->F1_FORNECE			<= '"+ mv_par09			+"' .AND. "		
			cFiltro += "SF1->F1_LOJA			>= '"+ mv_par10			+"' .AND. "		
			cFiltro += "SF1->F1_LOJA			<= '"+ mv_par11			+"' .AND. "		
			cFiltro += "DTOS(SF1->F1_DTDIGIT)	>= '"+ DTOS(mv_par12)	+"' .AND. "		
			cFiltro += "DTOS(SF1->F1_DTDIGIT)	<= '"+ DTOS(mv_par13)	+"'		  "		
			
			dbSelectArea("SF1")
			SET FILTER TO &(cFiltro)
			SF1->(dbGoTop())
			While !SF1->(EOF())
				If RecLock("SF1",.F.)
					SF1->F1_DTLANC := ctod("")
					SF1->(MsUnLock())         
					aAdd ( aDADOS, {"SF1", SF1->F1_FILIAL, SF1->F1_SERIE, SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_DTDIGIT} )
					nCOUNT += 1
				EndIf
				SF1->(dbSkip())
			Enddo              
			SET FILTER TO

			
		Case mv_par01 == 2	//--Doc. Saída

			cFiltro := "SF2->F2_FILIAL			>= '"+ mv_par02			+"' .AND. "
			cFiltro += "SF2->F2_FILIAL			<= '"+ mv_par03			+"' .AND. "
			cFiltro += "SF2->F2_SERIE			>= '"+ mv_par04			+"' .AND. "
			cFiltro += "SF2->F2_SERIE			<= '"+ mv_par05			+"' .AND. "
			cFiltro += "SF2->F2_DOC	 			>= '"+ mv_par06			+"' .AND. "
			cFiltro += "SF2->F2_DOC	 			<= '"+ mv_par07			+"' .AND. "		
			cFiltro += "SF2->F2_CLIENTE			>= '"+ mv_par08			+"' .AND. "		
			cFiltro += "SF2->F2_CLIENTE			<= '"+ mv_par09			+"' .AND. "		
			cFiltro += "SF2->F2_LOJA  			>= '"+ mv_par10			+"' .AND. "		
			cFiltro += "SF2->F2_LOJA   			<= '"+ mv_par11			+"' .AND. "		
			cFiltro += "DTOS(SF2->F2_EMISSAO)	>= '"+ DTOS(mv_par12)	+"' .AND. "		
			cFiltro += "DTOS(SF2->F2_EMISSAO)	<= '"+ DTOS(mv_par13)	+"'		  "		
			
			dbSelectArea("SF2")
			SET FILTER TO &(cFiltro)
			SF2->(dbGoTop())
			While !SF2->(EOF())
				If RecLock("SF2",.F.)
					SF2->F2_DTLANC := ctod("")
					SF2->(MsUnLock())
					aAdd ( aDADOS, {"SF2", SF2->F2_FILIAL, SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_EMISSAO} )
					nCOUNT += 1
				EndIf
				SF2->(dbSkip())
			Enddo              
			SET FILTER TO


		Case mv_par01 == 3	//--Título Pagar

			cFiltro := "SE2->E2_FILIAL			>= '"+ mv_par02			+"' .AND. "
			cFiltro += "SE2->E2_FILIAL			<= '"+ mv_par03			+"' .AND. "
			cFiltro += "SE2->E2_PREFIXO			>= '"+ mv_par04			+"' .AND. "
			cFiltro += "SE2->E2_PREFIXO			<= '"+ mv_par05			+"' .AND. "
			cFiltro += "SE2->E2_NUM				>= '"+ mv_par06			+"' .AND. "
			cFiltro += "SE2->E2_NUM				<= '"+ mv_par07			+"' .AND. "		
			cFiltro += "SE2->E2_FORNECE			>= '"+ mv_par08			+"' .AND. "		
			cFiltro += "SE2->E2_FORNECE			<= '"+ mv_par09			+"' .AND. "		
			cFiltro += "SE2->E2_LOJA   			>= '"+ mv_par10			+"' .AND. "		
			cFiltro += "SE2->E2_LOJA   			<= '"+ mv_par11			+"' .AND. "		
			cFiltro += "DTOS(SE2->E2_EMIS1)	>= '"+ DTOS(mv_par12)	+"' .AND. "		
			cFiltro += "DTOS(SE2->E2_EMIS1)	<= '"+ DTOS(mv_par13)	+"'		  "		
			
			dbSelectArea("SE2")
			SET FILTER TO &(cFiltro)
			SE2->(dbGoTop())
			While !SE2->(EOF())
				If RecLock("SE2",.F.)
					SE2->E2_LA := Space(nLENLA)
					SE2->(MsUnLock())          
					aAdd ( aDADOS, {"SE2", SE2->E2_FILIAL, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_EMIS1} )
					nCOUNT += 1					
				EndIf
				SE2->(dbSkip())
			Enddo              
			SET FILTER TO


		Case mv_par01 == 4	//--Título Receber

			cFiltro := "SE1->E1_FILIAL			>= '"+ mv_par02			+"' .AND. "
			cFiltro += "SE1->E1_FILIAL 			<= '"+ mv_par03			+"' .AND. "
			cFiltro += "SE1->E1_PREFIXO			>= '"+ mv_par04			+"' .AND. "
			cFiltro += "SE1->E1_PREFIXO			<= '"+ mv_par05			+"' .AND. "
			cFiltro += "SE1->E1_NUM	   			>= '"+ mv_par06			+"' .AND. "
			cFiltro += "SE1->E1_NUM				<= '"+ mv_par07			+"' .AND. "		
			cFiltro += "SE1->E1_CLIENTE			>= '"+ mv_par08			+"' .AND. "		
			cFiltro += "SE1->E1_CLIENTE			<= '"+ mv_par09			+"' .AND. "		
			cFiltro += "SE1->E1_LOJA   			>= '"+ mv_par10			+"' .AND. "		
			cFiltro += "SE1->E1_LOJA			<= '"+ mv_par11			+"' .AND. "		
			cFiltro += "DTOS(SE1->E1_EMIS1)	>= '"+ DTOS(mv_par12)  		+"' .AND. "		
			cFiltro += "DTOS(SE1->E1_EMIS1)	<= '"+ DTOS(mv_par13)		+"'		  "		
			
			
			dbSelectArea("SE1")
			SET FILTER TO &(cFiltro)
			SE1->(dbGoTop())
			While !SE1->(EOF())
				If RecLock("SE1",.F.)
					SE1->E1_LA := Space(nLENLA)
					SE1->(MsUnLock())
					aAdd ( aDADOS, {"SE1", SE1->E1_FILIAL, SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_CLIENTE, SE1->E1_LOJA, SE1->E1_EMISSAO} )
					nCOUNT += 1					
				EndIf
				SE1->(dbSkip())
			Enddo              
			SET FILTER TO


		Case mv_par01 == 5	//--Mov. Bancário

			cFiltro := "SE5->E5_FILIAL			>= '"+ mv_par02			+"' .AND. "
			cFiltro += "SE5->E5_FILIAL			<= '"+ mv_par03			+"' .AND. "
			cFiltro += "SE5->E5_PREFIXO			>= '"+ mv_par04			+"' .AND. "
			cFiltro += "SE5->E5_PREFIXO			<= '"+ mv_par05			+"' .AND. "
			cFiltro += "SE5->E5_NUMERO			>= '"+ mv_par06			+"' .AND. "
			cFiltro += "SE5->E5_NUMERO			<= '"+ mv_par07			+"' .AND. "		
			cFiltro += "SE5->E5_CLIFOR 			>= '"+ mv_par08			+"' .AND. "		
			cFiltro += "SE5->E5_CLIFOR 			<= '"+ mv_par09			+"' .AND. "		
			cFiltro += "SE5->E5_LOJA  			>= '"+ mv_par10			+"' .AND. "		
			cFiltro += "SE5->E5_LOJA  			<= '"+ mv_par11			+"' .AND. "		
			cFiltro += "DTOS(SE5->E5_DTDISPO)	>= '"+ DTOS(mv_par12)	+"' .AND. "		
			cFiltro += "DTOS(SE5->E5_DTDISPO)	<= '"+ DTOS(mv_par13)	+"'		  "		
			
			dbSelectArea("SE5")
			SET FILTER TO &(cFiltro)
			SE5->(dbGoTop())
			While !SE5->(EOF())
				If RecLock("SE5",.F.)
					SE5->E5_LA := Space(nLENLA)
					SE5->(MsUnLock())
					aAdd ( aDADOS, {"SE5", SE5->E5_FILIAL, SE5->E5_PREFIXO, SE5->E5_NUMERO, SE5->E5_CLIFOR, SE5->E5_LOJA, SE5->E5_DATA} )
					nCOUNT += 1					
				EndIf
				SE5->(dbSkip())
			Enddo              
			SET FILTER TO

	EndCase
	
	Aviso("Aviso","Processo concluído!"+chr(13)+chr(10)+"Registros processados: "+cValToChar(nCOUNT),{"OK"})
	If Len(aDADOS) > 0
		cTEXTO := "Log de registros processados - Tabela: "+aDADOS[01,01]+chr(13)+chr(10)
		AutoGRLog(cTEXTO)
		cTEXTO := "FILIAL - SERIE/PREFIXO - DOC/TITULO - CLI/FOR - LOJA - EMISSAO"
		AutoGRLog(cTEXTO)
		For nI := 1 to Len(aDADOS)
			cTEXTO := aDADOS[nI,02]+" - "+aDADOS[nI,03]+" - "+aDADOS[nI,04]+" - "+aDADOS[nI,05]+" - "+aDADOS[nI,06]+" - "+DTOC(aDADOS[nI,07])
			AutoGRLog(cTEXTO)
		Next nI                   
		MostraErro()
	EndIf		

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³AjustaSX1³ Autor ³Rafael Parma            ³ Data ³22.03.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina para criação dos parâmetros (SX1).                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
Static Function AjustaSX1()
*-----------------------------------------------------------------------------*
Local aRegs  	:= {}  

aAdd(aRegs,{cPerg,"01","Tipo Documento   ?","Tipo Documento   ?","Tipo Documento   ?","mv_ch01", "N",01							,0,0,"C","			","mv_par01","Doc. Entrada","Doc. Entrada","Doc. Entrada","","","Doc. Saída","Doc. Saída","Doc. Saída","","","Título Pagar","Título Pagar","Título Pagar","","","Título Receber","Título Receber","Título Receber","","","Mov. Bancário","Mov. Bancário","","Mov. Bancário","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial De        ?","Filial De        ?","Filial De        ?","mv_ch02" ,"C",TAMSX3("E1_FILIAL")[1] 	,0,0,"G","			","mv_par02",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"03","Filial Até       ?","Filial Até       ?","Filial Até       ?","mv_ch03" ,"C",TAMSX3("E1_FILIAL")[1] 	,0,0,"G","			","mv_par03",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"04","Serie/Prefixo De ?","Serie/Prefixo De ?","Serie/Prefixo De ?","mv_ch02" ,"C",TAMSX3("E1_PREFIXO")[1] 	,0,0,"G","			","mv_par04",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"05","Serie/Prefixo Até?","Serie/Prefixo Até?","Serie/Prefixo Até?","mv_ch03" ,"C",TAMSX3("E1_PREFIXO")[1] 	,0,0,"G","			","mv_par05",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"06","Doc/Título De    ?","Doc/Título De    ?","Doc/Título De    ?","mv_ch04" ,"C",TAMSX3("E1_NUM")	[1] 	,0,0,"G","			","mv_par06",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"07","Doc/Título Até   ?","Doc/Título Até   ?","Doc/Título Até   ?","mv_ch05" ,"C",TAMSX3("E1_NUM")	[1] 	,0,0,"G","			","mv_par07",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"08","Cli/For De       ?","Cli/For De       ?","Cli/For De       ?","mv_ch06", "C",TamSX3("E1_CLIENTE")[1]	,0,0,"G","			","mv_par08",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",    			 ""})
aAdd(aRegs,{cPerg,"09","Cli/For Até      ?","Cli/For Até      ?","Cli/For Até      ?","mv_ch07", "C",TamSX3("E1_CLIENTE")[1]	,0,0,"G","			","mv_par09",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"10","Loja Cli/For De  ?","Loja Cli/For De  ?","Loja Cli/For De  ?","mv_ch08", "C",TamSX3("E1_LOJA")	[1]		,0,0,"G","			","mv_par10",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"11","Loja Cli/For Até ?","Loja Cli/For Até ?","Loja Cli/For Até ?","mv_ch09", "C",TamSX3("E1_LOJA")	[1]		,0,0,"G","			","mv_par11",			"",				"",				"","","",		"",		  "",		"","","",	  "",	  "",	  "","","","","","","","","","","","",   "" ,"","","",               ""})
aAdd(aRegs,{cPerg,"12","Data Emissão De  ?","Data Emissão De  ?","Data Emissão De  ?","mv_ch10", "D",08                      	,0,0,"G","			","mv_par12",         	"",        		"",         	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"13","Data Emissão Até ?","Data Emissão Até ?","Data Emissão Até ?","mv_ch11", "D",08							,0,0,"G","			","mv_par13",         	"", 	   	    "",    	     	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})

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

Return
