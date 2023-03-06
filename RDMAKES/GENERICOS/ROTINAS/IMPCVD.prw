#include "totvs.ch"
#include "protheus.ch"

User Function IMPTABELACVD()

Local cArq := "impcvd.txt"
Local cLinha := ""
Local lPrim := .T.
Local aCampos := {}
Local aDados := {}
Local cDir := "c:\"

Private aErro := {}

If !File(cDir+cArq)
	MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[impcvd.txt] - ATENCAO")
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
	
	IncProc("Importando planos de contas ref...")
	
	dbSelectArea("CVD")
	dbSetOrder(1)
	dbGoTop()
	If !dbSeek(xFilial("CVD")+aDados[i,1])
		Reclock("CVD",.T.)
		CVD->CVD_FILIAL := xFilial("CVD")
		For j:=1 to Len(aCampos)
			cCampo := "CVD->" + aCampos[j]
			&cCampo := aDados[i,j]
		Next j
		CVD->(MsUnlock())
	EndIf
Next i
End Transaction

FT_FUSE()

ApMsgInfo("Importação dos dos planos de contas ref concluída com sucesso!","- SUCESSO")

Return
