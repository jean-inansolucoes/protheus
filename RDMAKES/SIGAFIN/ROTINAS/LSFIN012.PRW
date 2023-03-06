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
User Function LSFIN012()
*-----------------------------------------------------------------------------*


Private aDADOS := {}
Private nLENLA := TAMSX3("E5_FILORIG")[1]
Private nCOUNT := 0

cFiltro := "SE5->E5_FILORIG = '"+ Space(nLENLA)	+"'		  "  

dbSelectArea("SE5")
SET FILTER TO &(cFiltro)
SE5->(dbGoTop())
While !SE5->(EOF())
	If RecLock("SE5",.F.)
		SE5->E5_FILORIG := SE5->E5_FILIAL
		SE5->(MsUnLock())
		aAdd ( aDADOS, {"SE5", SE5->E5_FILIAL, SE5->E5_VALOR, SE5->E5_NUMCHEQ, SE5->E5_CLIFOR, SE5->E5_LOJA, SE5->E5_DATA} )
		nCOUNT += 1
	EndIf
	SE5->(dbSkip())
Enddo
SET FILTER TO


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

