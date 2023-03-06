#include "totvs.ch"
#include "protheus.ch"
 
User Function LTIMPARQ()
Local i, j 
Local cArq    := "analises.txt"
Local cDir    := "C:\"
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
 
Private aErro := {}
 
If !File(cDir+cArq)
	MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[LTIMPARQ] - ATENCAO")
	Return
EndIf
 
FT_FUSE(cDir+cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
 
	IncProc("Lendo arquivo texto...")
 
	cLinha := FT_FREADLN()
 
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
 
	FT_FSKIP()
EndDo
 
Begin Transaction
	ProcRegua(Len(aDados))
	For i:=1 to Len(aDados)
 
		IncProc("Importando Analises...")
 
		dbSelectArea("ZL9")
		dbSetOrder(1)
		dbGoTop()
		If !dbSeek(xFilial("ZL9")+aDados[i,1])
			Reclock("ZL9",.T.)
			ZL9->ZL9_FILIAL := xFilial("ZL9")
			For j:=1 to Len(aCampos)
				cCampo  := "ZL9->" + aCampos[j]
				&cCampo := aDados[i,j]
			Next j
			SZ9->(MsUnlock())
		EndIf
	Next i
End Transaction
 
FT_FUSE()
 
ApMsgInfo("Importação das ANALISES concluída com sucesso!","[LTIMPARQ] - SUCESSO")
 
Return
