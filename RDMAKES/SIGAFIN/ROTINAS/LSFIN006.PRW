#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSFIN006 ³ Autor ³Alexandre Longihnotti	³ Data ³28.05.2012  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina para eliminação do desconto de acordo comercial.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
User Function LSFIN006()
*-----------------------------------------------------------------------------*
Private cPerg  := "LSFIN00006"
Private nCOUNT := 0
Private nDesc := 0
Private nSdDesc := 0
Private aDADOS := {}
                           
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
			
			cFiltro := "SE1->SE1_FILIAL			>= '"+ mv_par01			+"' .AND. "
			cFiltro += "SE1->SE1_FILIAL 		<= '"+ mv_par02			+"' .AND. "
			cFiltro += "SE1->SE1_NUM			>= '"+ mv_par03			+"' .AND. "
			cFiltro += "SE1->SE1_NUM			<= '"+ mv_par04			+"'		  "
						
			dbSelectArea("SE1")
			SET FILTER TO &(cFiltro)
			SE1->(dbGoTop())
			While !SE1->(EOF())
				If RecLock("SE1",.F.)
					nSdDesc := SE1->E1_SDDECRE
					nDesc := SE1->E1_SDDECRE
					SE1->E1_DECRESC := 0
				   	SE1->E1_SDDECRE := 0
				   	nDesc := SE1->E1_SDDECRE
					SE1->(MsUnLock())         
					aAdd ( aDADOS, {"SE1", SE1->E1_FILIAL, SE1->E1_NUM, nSdDesc, nDesc} )
					nCOUNT += 1
				EndIf
				SE1->(dbSkip())
			Enddo              
			SET FILTER TO

			
		
	Aviso("Aviso","Processo concluído!"+chr(13)+chr(10)+"Registros processados: "+cValToChar(nCOUNT),{"OK"})
	If Len(aDADOS) > 0
		cTEXTO := "Log de registros processados - Tabela: "+aDADOS[01,01]+chr(13)+chr(10)
		AutoGRLog(cTEXTO)
		cTEXTO := "FILIAL - TITULO - SD DESC. - DESC."
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
aAdd(aRegs,{cPerg,"03","Tílulo de        ?","Lanc padrão de   ?","Lanc padrão de   ?","mv_ch03" ,"C",TAMSX3("CT5_LANPAD")[1] 	,0,0,"G","			","mv_par03",		    "",			    "",			    "","","", 	    "",	      "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","","","","", ""})
aAdd(aRegs,{cPerg,"04","Tílulo até       ?","Lanc padrão Até  ?","Lanc padrão Até  ?","mv_ch04" ,"C",TAMSX3("CT5_LANPAD")[1] 	,0,0,"G","			","mv_par04",		    "",		        "",			    "","","", 	    "",	      "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","","","","","", ""})

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
