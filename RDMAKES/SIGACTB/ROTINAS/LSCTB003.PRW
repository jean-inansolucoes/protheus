#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSCTB002 ³ Autor ³Alexandre Longihnotti	³ Data ³28.05.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina para alteração do status dos lanc. padrão.		        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
User Function LSCTB003()
*-----------------------------------------------------------------------------*
Private cPerg  := "LSCTB00003"
Private nCOUNT := 0
Private aDADOS := {}
                           
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
			
			cFiltro := "CT5->CT5_FILIAL			>= '"+ mv_par01			+"' .AND. "
			cFiltro += "CT5->CT5_FILIAL 		<= '"+ mv_par02			+"' .AND. "
			cFiltro += "CT5->CT5_LANPAD			>= '"+ mv_par03			+"' .AND. "
			cFiltro += "CT5->CT5_LANPAD			<= '"+ mv_par04			+"'		  "
						
			dbSelectArea("CT5")
			SET FILTER TO &(cFiltro)
			CT5->(dbGoTop())
			While !CT5->(EOF())
				If RecLock("CT5",.F.)
					If mv_par05 == 1
				   		CT5->CT5_STATUS := "1"
					Else
						CT5->CT5_STATUS := "2"
					EndIf
					CT5->(MsUnLock())         
					aAdd ( aDADOS, {"CT5", CT5->CT5_FILIAL, CT5->CT5_LANPAD, CT5->CT5_SEQUEN, CT5->CT5_DESC} )
					nCOUNT += 1
				EndIf
				CT5->(dbSkip())
			Enddo              
			SET FILTER TO

			
		
	Aviso("Aviso","Processo concluído!"+chr(13)+chr(10)+"Registros processados: "+cValToChar(nCOUNT),{"OK"})
	If Len(aDADOS) > 0
		cTEXTO := "Log de registros processados - Tabela: "+aDADOS[01,01]+chr(13)+chr(10)
		AutoGRLog(cTEXTO)
		cTEXTO := "FILIAL - LAN.PADRAO - SEQ. - DESCR"
		AutoGRLog(cTEXTO)
		For nI := 1 to Len(aDADOS)
			cTEXTO := aDADOS[nI,02]+" - "+aDADOS[nI,03]+" - "+aDADOS[nI,04]+" - "+aDADOS[nI,05]
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

aAdd(aRegs,{cPerg,"01","Filial De        ?","Filial De        ?","Filial De        ?","mv_ch01" ,"C",TAMSX3("CT5_FILIAL")[1] 	,0,0,"G","			","mv_par01",		    "",		        "",			    "","","", 	    "",	      "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})
aAdd(aRegs,{cPerg,"02","Filial Até       ?","Filial Até       ?","Filial Até       ?","mv_ch02" ,"C",TAMSX3("CT5_FILIAL")[1] 	,0,0,"G","			","mv_par02",		    "",		        "",			    "","","", 	    "",	      "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","XM0","","","", ""})
aAdd(aRegs,{cPerg,"03","Lanc padrão de   ?","Lanc padrão de   ?","Lanc padrão de   ?","mv_ch03" ,"C",TAMSX3("CT5_LANPAD")[1] 	,0,0,"G","			","mv_par03",		    "",			    "",			    "","","", 	    "",	      "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","","","","", ""})
aAdd(aRegs,{cPerg,"04","Lanc padrão Até  ?","Lanc padrão Até  ?","Lanc padrão Até  ?","mv_ch04" ,"C",TAMSX3("CT5_LANPAD")[1] 	,0,0,"G","			","mv_par04",		    "",		        "",			    "","","", 	    "",	      "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","","","","", ""})
aAdd(aRegs,{cPerg,"05","Operação         ?","Operação         ?","Operação         ?","mv_ch05","N",01							,0,1,"C","			","mv_par05",			"Ativa","Ativa","Ativa","",				 "","Desativa","Desativa","Desativa",	   "",		"","","",	  "",	  "",	  "","","","","","","","","","", "","","" ,""})
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
