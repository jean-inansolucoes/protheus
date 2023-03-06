#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSFIS001 ³ Autor ³Alexandre Long          ³ Data ³01.11.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³Descri‡…o ³Rotina para oreencher campos da data e hora da autorizacao    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
User Function LSFIS001()
*-----------------------------------------------------------------------------*
Private cPerg  := "LSFIS00001"
Private nCOUNT := 0
                           
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
		
			cFiltro := "SF2->F2_FILIAL			== '"+ mv_par01			+"' .AND. "
			cFiltro += "SF2->F2_SERIE			== '"+ mv_par02			+"' .AND. "
			cFiltro += "SF2->F2_DOC	 			>= '"+ mv_par03			+"' .AND. "
			cFiltro += "SF2->F2_DOC	 			<= '"+ mv_par04			+"' .AND. "		
			cFiltro += "DTOS(SF2->F2_EMISSAO)	== '"+ DTOS(mv_par05)	+"'       "		

			
			dbSelectArea("SF2")
			SET FILTER TO &(cFiltro)
			SF2->(dbGoTop())
			While !SF2->(EOF())
				If RecLock("SF2",.F.)
					If Empty(SF2->F2_DAUTNFE)
						SF2->F2_DAUTNFE := mv_par05
						SF2->F2_HAUTNFE := "12:00"
						SF2->(MsUnLock())
				   		nCOUNT += 1
					EndIf
				EndIf
				SF2->(dbSkip())
			Enddo              
			SET FILTER TO


	Aviso("Aviso","Processo concluído!"+chr(13)+chr(10)+"Registros processados: "+cValToChar(nCOUNT),{"OK"})

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

aAdd(aRegs,{cPerg,"01","Filial De        ?","Filial De        ?","Filial De        ?","mv_ch01" ,"C",TAMSX3("E1_FILIAL")[1] 	,0,0,"G","			","mv_par01",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"02","Serie			 ?","Serie/Prefixo De ?","Serie/Prefixo De ?","mv_ch02" ,"C",TAMSX3("E1_PREFIXO")[1] 	,0,0,"G","			","mv_par02",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"03","Nota De          ?","Doc/Título De    ?","Doc/Título De    ?","mv_ch03" ,"C",TAMSX3("E1_NUM")	[1] 	,0,0,"G","			","mv_par03",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"04","Nota Até         ?","Doc/Título Até   ?","Doc/Título Até   ?","mv_ch04" ,"C",TAMSX3("E1_NUM")	[1] 	,0,0,"G","			","mv_par04",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"05","Data Emissão De  ?","Data Emissão De  ?","Data Emissão De  ?","mv_ch05", "D",08                      	,0,0,"G","			","mv_par05",         	"",        		"",         	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})


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
