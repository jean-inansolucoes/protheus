#include "colors.ch"        
#include "totvs.ch"  
#include "topconn.ch" 
#include "sigawin.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCAD002    บAutor  ณJEAN P ROSSETTO   บ Data ณ  15/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CADASTRO DE FAIXA X PRECO                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  
*-------------------------------------------*
User Function LTCAD002()
*-------------------------------------------*

Local cAliasTAB   := "ZL2"
Private aCores    := {}
Private aRotina   := {}
Private cCadastro := "Cadastro Faixas - Pre็os"

Public lMVZLCPTA  := SuperGetMV("MV_ZLCPTA",,.F.)	//-- HABILITA O CONTROLE DE PAGAMENTO DO LEITE AOS PRODUTORES QUANDO TRANSPORTE REALIZADO POR FRETEIROS AUTONOMOS.
Public lMVZLMTPP  := SuperGetMV("MV_ZLMTPP",,.F.)	//-- HABILITA O BLOQUEIO DE MANUTENCAO SOBRE AS TABELAS DE PRECOS DOS PRODUTORES.
Public lMVZLMTPR  := SuperGetMV("MV_ZLMTPR",,.F.)	//-- HABILITA CONTROLE SOBRE USUARIO RESPONSAVEL PELA LINHA NA MANUTENCAO DAS TABELAS DE PRECOS DOS PRODUTORES RELACIONADOS.
Public cMV_ZLGPR  := SuperGetMV("MV_ZLGRPR",,"")	//-- GRUPO DE USUARIOS COM PERMISSAO DE ALTERACAO DAS TABELAS DE PRECO.
Public cMV_ZLEPR  := SuperGetMV("MV_ZLEXPR",,"")	//-- USUARIOS COM PERMISSAO DE ALTERACAO DAS TABELAS DE PRECO COM EXCEวรO DAS FAIXAS DA ZLI.
Public cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// c๓digo da TES de movimento

aRotina :=	{	{ "Pesquisar"    		,"AxPesqui" , 0, 1},;
{ "Visualizar"   		,"AxVisual" , 0, 2},;
{ "Incluir"      		,"U_LTC2IN" , 0, 3},;
{ "Alterar"      		,"U_LTC2AL" , 0, 4},;
{ "Excluir"      		,"U_LTC2EX" , 0, 5},;
{ "Reajustar Produtores","U_LTC2RJ" , 0, 7},;
{ "Faixas de Pre็os    ","U_LTCAD011" , 0, 7},;
{ "Atualiza็ใo Pre็o" 	,"U_LTC2RP" , 0, 7} }

dbSelectArea(cAliasTAB)
(cAliasTAB)->(dbSetOrder(1))

aADD(aCores, { 'ZL2_TIPO == "N" '  , 'BR_VERDE'     })
aADD(aCores, { 'ZL2_TIPO != "N" '  , 'BR_AMARELO'   })

mBrowse( ,,,,cAliasTAB,,,,,, aCores)

Return



*-------------------------------------------*
User Function LTC2IN(cAlias, nReg, nOpc)
*-------------------------------------------*

//-- HABILITA O BLOQUEIO DE MANUTENCAO SOBRE AS TABELAS DE PRECOS DOS PRODUTORES.
If !lMVZLMTPP
	AxInclui(cAlias,nReg,nOpc,,,,"U_LTCHKLIN()")
Else
	Aviso("MV_ZLMTPP","Nใo ้ permitida a manuten็ใo das tabelas de pre็os.",{"OK"},2)
EndIf

Return


*-------------------------------------------*
User Function LTC2AL(cAlias, nReg, nOpc)
*-------------------------------------------*
Local aGrp := {}
Local cUser := cUserName
Local cCodUser := ""
Local lOk := .F.
Local nX := 0 
aGrp := UsrRetGrp(cUser,cCodUser)

If __cUserId $ cMV_ZLEPR
	lOk := .T.
EndIf


 aGrp := UsrRetGrp(cUser,cCodUser)

If (lOk)
	
	//-- HABILITA O BLOQUEIO DE MANUTENCAO SOBRE AS TABELAS DE PRECOS DOS PRODUTORES.
	If !lMVZLMTPP
		
		//--HABILITA CONTROLE SOBRE USUARIO RESPONSAVEL PELA LINHA NA MANUTENCAO DAS TABELAS DE PRECOS DOS PRODUTORES RELACIONADOS.
		If lMVZLMTPR
			aAreaTMP := GetArea()
				lOk := .F.
				If Len(aGrp) > 0
					For nX := 1 to Len(aGrp)
						If aGrp[nX] $ cMV_ZLGPR
							lOk := .T.
							Exit
						EndIf
					Next nX
				EndIf
				dbSelectArea("ZL0")
				dbSetOrder(1)
				dbSeek(xFilial("ZL0")+ZL2->ZL2_LINHA)
				
				If __cUserId != ZL0->ZL0_CODRES .AND. ! lOk
					Aviso("MV_ZLMTPR","Usuแrio nใo relacionado como responsแvel pela linha/produtor, nใo poderแ alterar a tabela.",{"OK"},2)
				Else
					AxAltera(cAlias,nReg,nOpc,,,,,"U_LTCHKLIN()")
				EndIf
				RestArea(aAreaTMP)
		Else
			AxAltera(cAlias,nReg,nOpc,,,,,"U_LTCHKLIN()")
		EndIf
		
	Else
		Aviso("MV_ZLMTPP","Nใo ้ permitida a manuten็ใo das tabelas de pre็os.",{"OK"},2)
	EndIf
Else
	Aviso("MV_ZLEXPR","Nใo ้ permitida a manuten็ใo das tabelas de pre็os. Ultilize a op็ใo reajuste produtores",{"OK"},2)
End If

Return


*-------------------------------------------*
User Function LTC2EX(cAlias, nReg, nOpc)
*-------------------------------------------*
Local aGrp := {}
Local cUser := cUserName
Local cCodUser := ""
Local lOk := .F.
Local nX := 0 
aGrp := UsrRetGrp(cUser,cCodUser)

//-- HABILITA O BLOQUEIO DE MANUTENCAO SOBRE AS TABELAS DE PRECOS DOS PRODUTORES.
If !lMVZLMTPP
	
	//--HABILITA CONTROLE SOBRE USUARIO RESPONSAVEL PELA LINHA NA MANUTENCAO DAS TABELAS DE PRECOS DOS PRODUTORES RELACIONADOS.
	If lMVZLMTPR
		aAreaTMP := GetArea()
		lOk := .F.
		If Len(aGrp) > 0
			For nX := 1 to Len(aGrp)
				If aGrp[nX] $ cMV_ZLGPR
					lOk := .T.
					Exit
				EndIf
			Next nX
		EndIf
		dbSelectArea("ZL0")
		dbSetOrder(1)
		dbSeek(xFilial("ZL0")+ZL2->ZL2_LINHA)
		If __cUserId != ZL0->ZL0_CODRES .AND. ! lOk
			Aviso("MV_ZLMTPR","Usuแrio nใo relacionado como responsแvel pela linha/produtor, nใo poderแ excluir a tabela.",{"OK"},2)
		Else
			AxDeleta(cAlias,nReg,nOpc)
		EndIf
		
		RestArea(aAreaTMP)
	Else
		AxDeleta(cAlias,nReg,nOpc)
	EndIf
Else
	Aviso("MV_ZLMTPP","Nใo ้ permitida a manuten็ใo das tabelas de pre็os.",{"OK"},2)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTC2RP      บAutor  ณRafael Parma      บ Data ณ  16/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recalculo de pre็os.                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------*
User Function LTC2RP()
*-----------------------*
Local oDlg, oCbx1, oCbx2
Local nOpca, nProc := 0
Local aArea := GetArea()

Private cLTIPPRC  := {"Exce็ใo","Normal","Todas"}
Private cLTIPVLR  := {"Leite","Frete"}
Private cCODLDE   := Space(TAMSX3("ZL0_COD")[1])
Private cCODLATE  := Space(TAMSX3("ZL0_COD")[1])
Private nVLR_ATUAL:= 0
Private nVLR_NOVO := 0

//-- HABILITA O BLOQUEIO DE MANUTENCAO SOBRE AS TABELAS DE PRECOS DOS PRODUTORES.
If lMVZLMTPP
	Aviso("MV_ZLMTPP","Nใo ้ permitida a manuten็ใo das tabelas de pre็os.",{"OK"},2)
	Return NIL
EndIf

DEFINE MSDIALOG oDlg FROM 010,100 TO 270,400 TITLE "Atualiza็ใo de pre็os"  OF oMainWnd PIXEL
@ 015,015 SAY "Tipo Tabela ?"  SIZE 50,10 OF oDlg PIXEL
@ 015,060 MSCOMBOBOX oCbx1 VAR cLTIPPRC ITEMS cLTIPPRC  SIZE 060,09 OF oDlg PIXEL
@ 030,015 SAY "Sobre Valor ?"  SIZE 50,10 OF oDlg PIXEL
@ 030,060 MSCOMBOBOX oCbx2 VAR cLTIPVLR ITEMS cLTIPVLR  SIZE 060,09 OF oDlg PIXEL
@ 045,015 SAY "Linha De: "  SIZE 50,10 OF oDlg PIXEL
@ 045,060 MSGET cCODLDE  F3 "ZL0000" VALID (EXISTCPO("ZL0")) SIZE 050,10 OF oDlg PIXEL
@ 060,015 SAY "Linha At้: "  SIZE 50,10 OF oDlg PIXEL
@ 060,060 MSGET cCODLATE F3 "ZL0000" VALID (EXISTCPO("ZL0")) SIZE 050,10 OF oDlg PIXEL
@ 075,015 SAY "Valor Atual: "  SIZE 50,10 OF oDlg PIXEL
@ 075,060 GET nVLR_ATUAL PICTURE "@E 999,999.9999" VALID (nVLR_ATUAL>0) SIZE 050,10 OF oDlg PIXEL
@ 090,015 SAY "Novo Valor:  "  SIZE 50,10 OF oDlg PIXEL
@ 090,060 GET nVLR_NOVO PICTURE "@E 999,999.9999"  VALID (nVLR_NOVO>0)  SIZE 050,10 OF oDlg PIXEL

DEFINE SBUTTON FROM 110, 060 TYPE 1 ACTION (nOpca:=1,oDlg:End())ENABLE OF oDlg PIXEL
DEFINE SBUTTON FROM 110, 090 TYPE 2 ACTION (nOpca:=2,oDlg:End())ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	MsAguarde({||fUpdZL2(cLTIPPRC,cLTIPVLR,cCODLDE,cCODLATE,nVLR_ATUAL,nVLR_NOVO,@nProc) },"Atualizando pre็os...")
	Aviso( "Aviso", "Processo concluido! Registros processados: "+cValToChar(nProc), { "Ok" }, 2 )
EndIf

RestArea(aArea)

Return ()

*-------------------------------------------------------------------------------------------*
Static Function fUpdZL2(cLTIPPRC, cLTIPVLR, cCODLDE, cCODLATE, nVLR_ATUAL, nVLR_NOVO, nProc)
*-------------------------------------------------------------------------------------------*
Local lAtu  := .F.
Local nX := 0
Local aGrp := {}
Local cUser := cUserName
Local cCodUser := ""
Local lOk := .F.
aGrp := UsrRetGrp(cUser,cCodUser)
//--HABILITA CONTROLE SOBRE USUARIO RESPONSAVEL PELA LINHA NA MANUTENCAO DAS TABELAS DE PRECOS DOS PRODUTORES RELACIONADOS.
If lMVZLMTPR
	cCODRESP := ""
	aAreaTMP := GetArea()
	lOk := .F.
	If Len(aGrp) > 0
		For nX := 1 to Len(aGrp)
			If aGrp[nX] $ cMV_ZLGPR
				lOk := .T.
				Exit
			EndIf
		Next nX
	EndIf
EndIf

nProc := 0
// Atualiza็ใo de pre็os
dbSelectArea("ZL2")
dbSetOrder(2)	//ZL2_FILIAL+ZL2_LINHA
dbGoTop()
dbSeek(xFilial("ZL2")+cCODLDE)
While !ZL2->(EOF()) .and. ZL2->ZL2_LINHA <= cCODLATE
	
	lAtu := .F.
	If cLTIPPRC == "Exce็ใo" .and. ZL2->ZL2_TIPO == "E"
		lAtu := .T.
	ElseIf cLTIPPRC == "Normal" .and. ZL2->ZL2_TIPO == "N"
		lAtu := .T.
	ElseIf cLTIPPRC == "Todas"
		lAtu := .T.
	EndIf
	
	//--HABILITA CONTROLE SOBRE USUARIO RESPONSAVEL PELA LINHA NA MANUTENCAO DAS TABELAS DE PRECOS DOS PRODUTORES RELACIONADOS.
	If lMVZLMTPR .and. lAtu
		dbSelectArea("ZL0")
		dbSetOrder(1)
		dbSeek(xFilial("ZL0")+ZL2->ZL2_LINHA)
		If __cUserId != ZL0->ZL0_CODRES .AND. ! lOk
			lAtu := .F.
		EndIf
	EndIf
	
	If lAtu
		lAtu := .F.
		If cLTIPVLR == "Leite"
			If ZL2->ZL2_PRCLEI == nVLR_ATUAL
				lAtu := .T.
			EndIf
		Else
			If ZL2->ZL2_PRCFRT == nVLR_ATUAL
				lAtu := .T.
			EndIf
		EndIf
	EndIf
	
	If lAtu
		RecLock("ZL2",.F.)
		If cLTIPVLR == "Leite"
			ZL2->ZL2_PRCLEI := nVLR_NOVO
		Else
			ZL2->ZL2_PRCFRT := nVLR_NOVO
		EndIf
		ZL2->(MsUnLock())
		nProc += 1
	EndIf
	
	ZL2->(dbSkip())
Enddo

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTC2RJ      บAutor  ณRafael Parma      บ Data ณ  26/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Janela de reajustes de pre็os de produtores.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------*
User Function LTC2RJ()
*-----------------------*
Private cPerg := "LTCAD00002"

//-- HABILITA O BLOQUEIO DE MANUTENCAO SOBRE AS TABELAS DE PRECOS DOS PRODUTORES.
If lMVZLMTPP
	Aviso("MV_ZLMTPP","Nใo ้ permitida a manuten็ใo das tabelas de pre็os.",{"OK"},2)
	Return NIL
EndIf

AjustaSX1()
If Pergunte(cPerg,.T.)
	fLoadWind()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLoadWind   บAutor  ณRafael Parma      บ Data ณ  26/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Janela de reajustes de pre็os de produtores.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------*
Static Function fLoadWind()
*---------------------------*
Local cAliasTMP := GetNextAlias()
Local aSizeAut 	:= MsAdvSize(,.F.)
Local hEnter    := CHR(10)+CHR(13)
Local aObjects	:= {}
Local aInfo 	:= {}
Local aPosObj	:= {}
Local nTQTD     := 0
Local nTVLR     := 0
Local nTLIQ     := 0
Local nAliquota := 0 
Local cTRANSP   := ""
Local cTIPTRP   := ""
Local nAlsenar  := POSICIONE("SF4",1,xFilial("SF4")+cMV_ZLTTES,"F4_ALSENAR")
Local nAlInss   := 0
Local nX := 0
Local aGrp := {}
Local cUser := cUserName
Local cCodUser := ""
Local lOk := .F.
Private oDlg, oGet, oCpo, oSAY1, oSAY2, oSAY3
Private nVALAJU := 0
Private cLTIPAJU:= {"Acr้scimo","Decr้scimo"}
Private aHeader := {}
Private aCols   := {}
Private aCpoAlt := {}


aGrp := UsrRetGrp(cUser,cCodUser)
//--HABILITA CONTROLE SOBRE USUARIO RESPONSAVEL PELA LINHA NA MANUTENCAO DAS TABELAS DE PRECOS DOS PRODUTORES RELACIONADOS.
If lMVZLMTPR
	lOk := .F.
		If Len(aGrp) > 0
			For nX := 1 to Len(aGrp)
				If aGrp[nX] $ cMV_ZLGPR
					lOk := .T.
					Exit
				EndIf
			Next nX
		EndIf
EndIf

cQuery := "SELECT 	              												" + hEnter
cQuery += "			ZL0.ZL0_TRANSP,  											" + hEnter
cQuery += "			ZL2.ZL2_LINHA,  											" + hEnter
cQuery += "			ZL2.ZL2_PRODUT,												" + hEnter
cQuery += "			ZL2.ZL2_LOJPRD,												" + hEnter
cQuery += "			ZL2.ZL2_NOMPRD,												" + hEnter
cQuery += "			ZL2.ZL2_PRCLEI,												" + hEnter
cQuery += "			ZL2.ZL2_PRCFRT,												" + hEnter
cQuery += "			ZL2.R_E_C_N_O_,  											" + hEnter
cQuery += "			( SELECT SUM(ZL6.ZL6_QTDE) 									" + hEnter
cQuery += "				FROM " + RetSqlName("ZL6") + " ZL6						" + hEnter
cQuery += "				INNER JOIN " + RetSqlName("ZL5") + " ZL5   				" + hEnter
cQuery += "				ON 		ZL5.ZL5_FILIAL = ZL6.ZL6_FILIAL                 " + hEnter
cQuery += "				AND		ZL5.ZL5_COD    = ZL6.ZL6_COD                    " + hEnter
cQuery += "				WHERE	ZL5.ZL5_FILIAL = '"+xFilial("ZL5")+"'	 		" + hEnter
cQuery += "				AND 	ZL6.ZL6_STATUS = ''								" + hEnter
cQuery += "				AND 	ZL6.ZL6_QTDE   > 0 								" + hEnter
cQuery += "				AND   	ZL5.ZL5_LINHA  BETWEEN 	'"+mv_par01+"' 			" + hEnter
cQuery += "				AND          			       	'"+mv_par02+"'     		" + hEnter
cQuery += "				AND  	ZL5.ZL5_DATA BETWEEN 	'"+DTOS(mv_par03)+"'	" + hEnter
cQuery += "				AND      	                    '"+DTOS(mv_par04)+"'	" + hEnter
cQuery += "				AND   	ZL6.ZL6_PRODUT = ZL2.ZL2_PRODUT		 			" + hEnter
cQuery += "				AND   	ZL6.ZL6_LOJPRD = ZL2.ZL2_LOJPRD		 			" + hEnter
cQuery += "				AND		ZL5.D_E_L_E_T_ != '*' 							" + hEnter
cQuery += "				AND		ZL6.D_E_L_E_T_ != '*' ) ZL6_QTDE				" + hEnter
cQuery += "FROM " + RetSqlName("ZL2") + " ZL2									" + hEnter
cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0								" + hEnter
cQuery += "ON	  	ZL2.ZL2_FILIAL = ZL0.ZL0_FILIAL 	 						" + hEnter
cQuery += "AND	  	ZL2.ZL2_LINHA  = ZL0.ZL0_COD	 	 						" + hEnter
cQuery += "WHERE    ZL2.ZL2_FILIAL  = '" + xFilial("ZL2") + "' 					" + hEnter
cQuery += "AND  	ZL2.ZL2_LINHA  BETWEEN 	'"+mv_par01+"' 						" + hEnter
cQuery += "AND                 		    	'"+mv_par02+"' 						" + hEnter
cQuery += "AND  	ZL2.ZL2_PRCLEI BETWEEN 	"+cValToChar(mv_par09)+"			" + hEnter
cQuery += "AND                 		    	"+cValToChar(mv_par10)+"			" + hEnter
cQuery += "AND  	ZL2.ZL2_PRCFRT BETWEEN 	"+cValToChar(mv_par11)+"			" + hEnter
cQuery += "AND                 		    	"+cValToChar(mv_par12)+"			" + hEnter
cQuery += "AND  	ZL0.ZL0_TRANSP BETWEEN 	'"+mv_par07+"'						" + hEnter
cQuery += "AND                 		    	'"+mv_par08+"'						" + hEnter
cQuery += "AND 		ZL2.ZL2_TIPO    = 'E'		 								" + hEnter
If lMVZLMTPR .AND. ! lOk
	cQuery += "AND 	ZL0.ZL0_CODRES  = '"+__cUserId+"'		 					" + hEnter
EndIf
cQuery += "AND 		ZL2.D_E_L_E_T_  != '*' 										" + hEnter
cQuery += "AND 		ZL0.D_E_L_E_T_  != '*' 										" + hEnter
cQuery += "AND		EXISTS ( SELECT 1		 									" + hEnter
cQuery += "				FROM " + RetSqlName("ZL6") + " ZL6						" + hEnter
cQuery += "				INNER JOIN " + RetSqlName("ZL5") + " ZL5   				" + hEnter
cQuery += "				ON 		ZL5.ZL5_FILIAL = ZL6.ZL6_FILIAL                 " + hEnter
cQuery += "				AND		ZL5.ZL5_COD    = ZL6.ZL6_COD                    " + hEnter
cQuery += "				WHERE	ZL5.ZL5_FILIAL = '"+xFilial("ZL5")+"'	 		" + hEnter
cQuery += "				AND 	ZL6.ZL6_STATUS = ''								" + hEnter
cQuery += "				AND 	ZL6.ZL6_QTDE   > 0 								" + hEnter
cQuery += "				AND   	ZL5.ZL5_LINHA  BETWEEN 	'"+mv_par01+"' 			" + hEnter
cQuery += "				AND          			       	'"+mv_par02+"'     		" + hEnter
cQuery += "				AND  	ZL5.ZL5_DATA BETWEEN 	'"+DTOS(mv_par03)+"'	" + hEnter
cQuery += "				AND      	                    '"+DTOS(mv_par04)+"'	" + hEnter
cQuery += "				AND   	ZL6.ZL6_PRODUT = ZL2.ZL2_PRODUT		 			" + hEnter
cQuery += "				AND   	ZL6.ZL6_LOJPRD = ZL2.ZL2_LOJPRD		 			" + hEnter
cQuery += "				AND		ZL5.D_E_L_E_T_ != '*' 							" + hEnter
cQuery += "				AND		ZL6.D_E_L_E_T_ != '*' )							" + hEnter
cQuery += "ORDER BY 							 					  			" + hEnter
cQuery += "			ZL2.ZL2_LINHA,  											" + hEnter
cQuery += "			ZL2.ZL2_PRODUT,												" + hEnter
cQuery += "			ZL2.ZL2_LOJPRD,												" + hEnter
cQuery += "			ZL2.ZL2_NOMPRD												" + hEnter

TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())

While (cAliasTMP)->(!EOF())
	
	//--Controle de altera็ใo sobre registro
	dbSelectArea("ZL2")
	dbGoTo((cAliasTMP)->R_E_C_N_O_)
	If SoftLock("ZL2",.F.)
		
		If mv_par05 == 1
			nVALPRC := (cAliasTMP)->ZL2_PRCLEI
		Else
			nVALPRC := (cAliasTMP)->ZL2_PRCFRT
		EndIf
		
		nVLRTOT := nVALPRC*(cAliasTMP)->ZL6_QTDE
		nTQTD += (cAliasTMP)->ZL6_QTDE
		nTVLR += nVLRTOT
		
		//--HABILITA O CONTROLE DE PAGAMENTO DO LEITE AOS PRODUTORES QUANDO TRANSPORTE REALIZADO POR FRETEIROS AUTONOMOS.
		If mv_par05 == 1 .and. lMVZLCPTA
			
			//--Tipo do transportador (F/J)
			If cTRANSP != (cAliasTMP)->ZL0_TRANSP
				cTIPTRP := "J"
				dbSelectArea("SA4")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek( xFilial("SA4")+(cAliasTMP)->ZL0_TRANSP )
					dbSelectArea("SA2")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek( xFilial("SA2")+SA4->(A4_X_FORN+A4_X_LOJF) )
						cTIPTRP := SA2->A2_TIPO
					EndIf
				EndIf
			EndIf
			cTRANSP := (cAliasTMP)->ZL0_TRANSP
			
			//--Aliquota FUNRURAL
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("SA2")+(cAliasTMP)->ZL2_PRODUT+(cAliasTMP)->ZL2_LOJPRD )
				nAlInss := POSICIONE("SED",1,XFILIAL("SED")+SA2->A2_NATUREZ,"ED_PERCINS")
				cTipoRur  := SA2->A2_TIPORUR
				aPFunRur  := FunRur()
				nPosPer   := at(cTipoRur,"FLJ")
				If nPosPer > 0
					If cTipoRur != "J"
						nAliquota := Val(aPFunRur[nPosPer]) + nAlsenar + nAlInss
						If SA2->A2_X_PCONT > 0
							nAliquota := SA2->A2_X_PCONT + nAlsenar + nAlInss
						EndIf
					EndIf
				Else
					nAliquota := 0
				EndIf
			EndIf
			
			nUNTLIQ := nVALPRC
			If nAliquota > 0
				nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * nAliquota ) / 100 )
			EndIf
			If cTIPTRP == "F"
				nUNTLIQ := nUNTLIQ - (cAliasTMP)->ZL2_PRCFRT
			EndIf
			nTOTLIQ := nUNTLIQ * (cAliasTMP)->ZL6_QTDE
			
			nTLIQ += nTOTLIQ
			
			aAdd(aCols, { (cAliasTMP)->ZL2_LINHA, ALLTRIM((cAliasTMP)->ZL2_PRODUT), ALLTRIM((cAliasTMP)->ZL2_NOMPRD), nVALPRC, (cAliasTMP)->ZL6_QTDE, 0, "A", nVALPRC, nVLRTOT, cTIPTRP, nUNTLIQ, nTOTLIQ, nAliquota, (cAliasTMP)->ZL2_PRCFRT, (cAliasTMP)->R_E_C_N_O_, .F. })
			
			
		Else
			
			aAdd(aCols, { (cAliasTMP)->ZL2_LINHA, ALLTRIM((cAliasTMP)->ZL2_PRODUT), ALLTRIM((cAliasTMP)->ZL2_NOMPRD), nVALPRC, (cAliasTMP)->ZL6_QTDE, 0, "A", nVALPRC, nVLRTOT, (cAliasTMP)->R_E_C_N_O_, .F. })
			
		EndIf
		
	EndIf
	(cAliasTMP)->(dbSkip())
Enddo
(cAliasTMP)->(dbCloseArea())

If Len(aCols) > 0
	
	
	// propriedades das colunas
	dbSelectArea("SX3")
	Aadd(aHeader,{"Linha",				"XX_CODLIN" ,"@!", 				TAMSX3("ZL2_LINHA")[1], 	TAMSX3("ZL2_LINHA")[2]	,	 		  						, ,"C",, })
	Aadd(aHeader,{"Produtor",			"XX_CODPRD" ,"@!", 				TAMSX3("ZL2_PRODUT")[1], 	TAMSX3("ZL2_PRODUT")[2]	, 		  							, ,"C",, })
	Aadd(aHeader,{"Nome",				"XX_NOMPRD" ,"@!", 				TAMSX3("ZL2_NOMPRD")[1], 	TAMSX3("ZL2_NOMPRD")[2]	, 									, ,"C",, })
	Aadd(aHeader,{"Valor Antigo",		"XX_VLRANT" ,"@E 99.9999", 		TAMSX3("ZL2_PRCLEI")[1], 	TAMSX3("ZL2_PRCLEI")[2]	, 									, ,"C",, })
	Aadd(aHeader,{"Quantidade Leite",	"XX_QTDLEI" ,"@E 999,999.99",	TAMSX3("ZL6_QTDE")[1], 		TAMSX3("ZL6_QTDE")[2]	,	 			   					, ,"C",, })
	Aadd(aHeader,{"Valor Reajuste",		"XX_VLREAJ" ,"@E 99.9999", 		TAMSX3("ZL2_PRCLEI")[1], 	TAMSX3("ZL2_PRCLEI")[2]	, 'U_LCAD2UP1()'					, ,"C",, })
	Aadd(aHeader,{"Tipo Reajuste",		"XX_TPREAJ" ,"@!", 				TAMSX3("ZL2_TIPO")[1], 		TAMSX3("ZL2_TIPO")[2]	, 'Pertence("AD").AND.U_LCAD2UP2()' , ,"C",, })
	Aadd(aHeader,{"Novo Vlr Bruto",		"XX_NOVALR" ,"@E 99.9999", 		TAMSX3("ZL2_PRCLEI")[1], 	TAMSX3("ZL2_PRCLEI")[2]	, 'U_LCAD2UP3()'			 		, ,"C",, })
	If mv_par05 == 1 .and. lMVZLCPTA
		Aadd(aHeader,{"Total Bruto",		"XX_VLRTOT" ,"@E 999,999.99",	TAMSX3("D1_TOTAL")[1], 	TAMSX3("D1_TOTAL")[2]	, 			 						, ,"C",, })
		Aadd(aHeader,{"Tipo Transp.",		"XX_TIPTRP" ,"@!", 				TAMSX3("A2_TIPO")[1], 	TAMSX3("A2_TIPO")[2]	,	  								, ,"C",, })
		Aadd(aHeader,{"Novo Vlr Liq",		"XX_UNTLIQ" ,"@E 99.9999",		TAMSX3("D1_TOTAL")[1], 	TAMSX3("D1_TOTAL")[2]	, 'U_LCAD2UP4()'					, ,"C",, })
		Aadd(aHeader,{"Total Liquido",		"XX_TOTLIQ" ,"@E 999,999.99",	TAMSX3("D1_TOTAL")[1], 	TAMSX3("D1_TOTAL")[2]	, 			 						, ,"C",, })
	Else
		Aadd(aHeader,{"Valor Total",		"XX_VLRTOT" ,"@E 999,999.99",	TAMSX3("D1_TOTAL")[1], 	TAMSX3("D1_TOTAL")[2]	, 			 						, ,"C",, })
	EndIf
	
	
	//--Campos que podem ser alterados
	If mv_par05 == 1 .and. lMVZLCPTA
		aCpoAlt := {"XX_VLREAJ","XX_TPREAJ","XX_NOVALR","XX_UNTLIQ"}
	Else
		aCpoAlt := {"XX_VLREAJ","XX_TPREAJ","XX_NOVALR"}
	EndIf
	
	// indexa็ใo dos dados
	If mv_par06 == 1
		aCols := aSort( aCols,,,{ |x,y| x[1]+x[2] < y[1]+y[2] } )
	ElseIf mv_par06 == 2
		aCols := aSort( aCols,,,{ |x,y| x[1]+x[3] < y[1]+y[3] } )
	ElseIf mv_par06 == 3
		aCols := aSort( aCols,,,{ |x,y| x[2]+x[1] < y[2]+y[1] } )
	Else
		aCols := aSort( aCols,,,{ |x,y| x[3]+x[1] < y[3]+y[1] } )
	EndIf
	
	aTmp := aClone(aCols)
	
	cTitulo := "Reajustes de pre็os de "+IIF(mv_par05==1,"leite","frete")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใo     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aSize   := MsAdvSize()
	AAdd( aObjects, { 100,   0, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 4, 20 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{005,035,065,095,125,155}} )
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
	DEFINE FONT oFnt1 NAME "Verdana" SIZE 09,12 BOLD
	DEFINE FONT oFnt2 NAME "Verdana" SIZE 12,14 BOLD
	
	@ 016,010 SAY OemToAnsi("Valor Reajuste: ") FONT oFnt1 COLOR CLR_BLACK OF oDlg PIXEL
	@ 014,070 MSGET nVALAJU  Picture "99.9999" When .T. OF oDlg PIXEL SIZE 40,10 RIGHT
	@ 016,130 SAY OemToAnsi("Tipo Reajuste: ") FONT oFnt1 COLOR CLR_BLACK OF oDlg PIXEL
	@ 014,190 MSCOMBOBOX oCpo VAR cLTIPAJU ITEMS cLTIPAJU  SIZE 050,09 OF oDlg PIXEL
	@ 014,280 BUTTON oBtn PROMPT "Processar Reajuste" SIZE 055,12 OF oDlg PIXEL ACTION fProcREAJ()
	@ 014,400 SAY cTitulo SIZE 140,09 PIXEL FONT oFnt2 COLOR CLR_BLACK
	
	
	oGet := MSGetDados():New(aPosObj[2,1]-10,aPosObj[2,2],aPosObj[2,3]-16,aPosObj[2,4],3,"AllwaysTrue()","AllwaysTrue()",,.F.,aCpoAlt,,,Len(aCols))
	
	@ aPosObj[2,3],aPosGet[1,1]  SAY "Quantidade Total: " SIZE 080,09 PIXEL FONT oFnt1 COLOR CLR_BLACK
	@ aPosObj[2,3],aPosGet[1,2]  SAY oSAY1 VAR 0 PICTURE TM(0,16,2) FONT oFnt1 COLOR CLR_BLACK SIZE 050,09 OF oDlg PIXEL
	If mv_par05 == 1 .and. lMVZLCPTA
		@ aPosObj[2,3],aPosGet[1,3]  SAY "Total Bruto: " SIZE 050,09 PIXEL FONT oFnt1 COLOR CLR_BLACK
		@ aPosObj[2,3],aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,2) FONT oFnt1 COLOR CLR_BLACK SIZE 050,09 OF oDlg PIXEL
		@ aPosObj[2,3],aPosGet[1,5]  SAY "Total Liquido: " SIZE 050,09 PIXEL FONT oFnt1 COLOR CLR_BLACK
		@ aPosObj[2,3],aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,2) FONT oFnt1 COLOR CLR_BLACK SIZE 050,09 OF oDlg PIXEL
		oDlg:Cargo := {|n1,n2,n3| oSAY1:SetText(n1), oSAY2:SetText(n2), oSAY3:SetText(n3) }
		Eval(oDlg:Cargo,nTQTD,nTVLR,nTLIQ)
	Else
		@ aPosObj[2,3],aPosGet[1,3]  SAY "Valor Total: " SIZE 050,09 PIXEL FONT oFnt1 COLOR CLR_BLACK
		@ aPosObj[2,3],aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,2) FONT oFnt1 COLOR CLR_BLACK SIZE 050,09 OF oDlg PIXEL
		oDlg:Cargo := {|n1,n2| oSAY1:SetText(n1), oSAY2:SetText(n2) }
		Eval(oDlg:Cargo,nTQTD,nTVLR)
	EndIf
	
	@ aPosObj[2,3],aPosObj[2,4]-050 BUTTON oBtn PROMPT "Confirmar" 	SIZE 040,12 OF oDlg PIXEL ACTION fAtuZL2()
	@ aPosObj[2,3],aPosObj[2,4]-100 BUTTON oBtn PROMPT "Imprimir" 	SIZE 040,12 OF oDlg PIXEL ACTION fWPrint()
	@ aPosObj[2,3],aPosObj[2,4]-150 BUTTON oBtn PROMPT "Excel"	 	SIZE 040,12 OF oDlg PIXEL ACTION fExpXLS()
	@ aPosObj[2,3],aPosObj[2,4]-200 BUTTON oBtn PROMPT "Parโmetros" SIZE 040,12 OF oDlg PIXEL ACTION fReload()
	@ aPosObj[2,3],aPosObj[2,4]-250 BUTTON oBtn PROMPT "Fechar" 	SIZE 040,12 OF oDlg PIXEL ACTION oDlg:End()
	
	ACTIVATE MSDIALOG oDlg
	
Else
	Aviso("AVISO","Nใo existem dados para serem exibidos. Verifique os parโmetros.",{"OK"},2)
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAtuZL2    บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para grava็ใo de arquivos.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function fAtuZL2()
*---------------------------------------------------------------------*
Private cPerg := "LTCAD00002"

If ApMsgNoYes("Deseja realizar a impressใo antes do processamento?","Impressใo")
	fWPrint()
EndIf

MsAguarde({||fReajZL2()},"Reajustando valores...")
oDlg:End()
fLoadWind()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfReajZL2   บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para grava็ใo de arquivos.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function fReajZL2()
*---------------------------------------------------------------------*
Local nI := 0
For nI := 1 to Len(aCols)
	
	If mv_par05 == 1 .and. lMVZLCPTA
		nRECZL2 := aCols[nI,15]
	Else
		nRECZL2 := aCols[nI,10]
	EndIf
	
	dbSelectArea("ZL2")
	dbGoTo(nRECZL2)
	If mv_par05 == 1 .and. ZL2->ZL2_PRCLEI != aCols[nI,08]
		RecLock("ZL2",.F.)
		ZL2->ZL2_PRCLEI := aCols[nI,08]
		ZL2->(MsUnLock())
	ElseIf mv_par05 == 2 .and. ZL2->ZL2_PRCFRT != aCols[nI,08]
		RecLock("ZL2",.F.)
		ZL2->ZL2_PRCFRT := aCols[nI,08]
		ZL2->(MsUnLock())
	EndIf
	
Next nI

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfReload    บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para reabertura da janela.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function fReload()
*---------------------------------------------------------------------*
Local nI := 0
Private cPerg := "LTCAD00002"

//--Desativa controle sobre altera็ใo de registros
For nI := 1 to Len(aCols)
	If mv_par05 == 1 .and. lMVZLCPTA
		nRECZL2 := aCols[nI,15]
	Else
		nRECZL2 := aCols[nI,10]
	EndIf
	dbSelectArea("ZL2")
	dbGoTo(nRECZL2)
	ZL2->(MsUnLock())
Next nI

AjustaSX1()
If Pergunte(cPerg,.T.)
	oDlg:End()
	fLoadWind()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBUSCAFAIXA   บAutor  ณAlexandre Longhinotti บ Data ณ 21/08/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar de altera็ใo de pre็os.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BUSCAFAIXA(nQtd)
LOCAL nPreco := 0
LOCAL cQtdIni
LOCAL cQtdFim
LOCAL cChave := "000001"
dbSelectArea("ZLI")
dbSetOrder(1)
If dbSeek(xFilial("ZLI")+cChave)
	While !ZLI->( Eof() ) .AND. dbSeek(xFilial("ZLI")+cChave)
		
		cQtdIni := ZLI->ZLI_QTDINI
		cQtdFim := ZLI->ZLI_QTDFIM
		
		If (nQtd >= cQtdIni) .AND. (nQtd <= cQtdFim)
			nPreco := ZLI->ZLI_PRCLEI
		EndIf
		cChave := cValToChar(STRZERO(VAL(cChave)+1,6))
	EndDo
EndIf
ZLI->( dBSkip( ) )

Return(nPreco)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcREAJ  บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para processamento de reajuestes.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function fProcREAJ()
*---------------------------------------------------------------------*
Local lAcres := cLTIPAJU=="Acr้scimo"
Local nTQTD := 0
Local nTVLR := 0
Local nTLIQ := 0
Local nPrcLim := 0
Local lOk := .T.
Local nI := 0
Local nUNTLIQ := 0

If __cUserId $ cMV_ZLEPR
	lOk := .T.
EndIf

If nVALAJU >= 0
	For nI := 1 to Len(aCols)
		If lAcres
			nPrcLim := U_BUSCAFAIXA(aCols[nI,05])
			If mv_par05 == 1 .and. lMVZLCPTA
				nUNTLIQ := aCols[nI,04]+nVALAJU
				If aCols[nI,13] > 0
					nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[nI,13] ) / 100 )
				EndIf
				If aCols[nI,10] == "F"
					nUNTLIQ := nUNTLIQ - aCols[nI,14]
				EndIf
				
			EndIf
			
			//If mv_par05 == 1
				If nUNTLIQ <= nPrcLim .Or. lOk
					
					aCols[nI,06] := nVALAJU
					aCols[nI,07] := "A"
					aCols[nI,08] := aCols[nI,04]+nVALAJU
					aCols[nI,09] := aCols[nI,08]*aCols[nI,05]
					
					If mv_par05 == 1 .and. lMVZLCPTA
						nUNTLIQ := aCols[nI,08]
						If aCols[nI,13] > 0
							nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[nI,13] ) / 100 )
						EndIf
						If aCols[nI,10] == "F"
							nUNTLIQ := nUNTLIQ - aCols[nI,14]
						EndIf
						nTOTLIQ := nUNTLIQ * aCols[nI,05]
						aCols[nI,11] := nUNTLIQ
						aCols[nI,12] := nTOTLIQ
					EndIf
				Else
					
					ShowHelpDlg( "Alerta",;
					{ "Pre็o acima do limite permitido pra esta quantidade! Esse movimento nao serแ reajustado!" + chr(10) + chr(13) + chr(10) + chr(13) + ;
					"Lin./Cod/Nome: " + chr(10) + chr(13) + Alltrim(aCols[nI,01]) + "/" + aCols[nI,02] + "/" + aCols[nI,03] + chr(10) + chr(13)}, 5,;
					{ "Qtd Entregue:  " + Transform( aCols[nI,05], "@E 999,99999" ) + chr(10) + chr(13) + ;
					"Valor mแximo:  " + Transform( nPrcLim,     "@E 9,999.9999" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
					"Em caso de exce็ใo solicite a altera็ใo ao responsแvel. Par. MV_ZLEXPR!"}, 5)
					
					aCols[nI,06] := 0
					
					aCols[nI,07] := "A"
					
					aCols[nI,08] := aCols[nI,04]
					aCols[nI,09] := aCols[nI,08]*aCols[nI,05]
					
					If mv_par05 == 1 .and. lMVZLCPTA
						nUNTLIQ := aCols[nI,08]
						If aCols[nI,13] > 0
							nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[nI,13] ) / 100 )
						EndIf
						If aCols[nI,10] == "F"
							nUNTLIQ := nUNTLIQ - aCols[nI,14]
						EndIf
						nTOTLIQ := nUNTLIQ * aCols[nI,05]
						aCols[nI,11] := nUNTLIQ
						aCols[nI,12] := nTOTLIQ
					EndIf
				EndIf
			//EndIf
		Else
			aCols[nI,06] := nVALAJU
			aCols[nI,07] := "D"
			aCols[nI,08] := aCols[nI,04]-nVALAJU
			aCols[nI,09] := aCols[nI,08]*aCols[nI,05]
			
			If mv_par05 == 1 .and. lMVZLCPTA
				nUNTLIQ := aCols[nI,08]
				If aCols[nI,13] > 0
					nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[nI,13] ) / 100 )
				EndIf
				If aCols[nI,10] == "F"
					nUNTLIQ := nUNTLIQ - aCols[nI,14]
				EndIf
				nTOTLIQ := nUNTLIQ * aCols[nI,05]
				aCols[nI,11] := nUNTLIQ
				aCols[nI,12] := nTOTLIQ
			EndIf
			
		EndIf
		
		
		nTQTD += aCols[nI,05]
		nTVLR += aCols[nI,09]
		If mv_par05 == 1 .and. lMVZLCPTA
			nTLIQ += aCols[nI,12]
		EndIf
	Next nI
	
	
	If ValType(oDlg) == "O"
		If ( ValType(oDlg:Cargo)=="B" )
			If mv_par05 == 1 .and. lMVZLCPTA
				Eval(oDlg:Cargo,nTQTD,nTVLR,nTLIQ)
			Else
				Eval(oDlg:Cargo,nTQTD,nTVLR)
			EndIf
		EndIf
	Endif
	
	oDlg:Refresh()
	
Else
	Alert("O valor do reajuste nใo pode ser negativo! Utilize o campo Acrescimo/Descr้scimo!")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCAD2UP1   บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar de altera็ใo de pre็os.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
User Function LCAD2UP1()
*---------------------------------------------------------------------*
Local lAcres := aCols[n,07]=="A"
Local nTQTD := 0
Local nTVLR := 0
Local nTLIQ := 0
Local nPrcLim := 0
Local lOk := .T.
Local nI := 0
Local nUNTLIQ := 0

If __cUserId $ cMV_ZLEPR
	lOk := .T.
EndIf

If XX_VLREAJ >= 0
	If lAcres
		nPrcLim := U_BUSCAFAIXA(aCols[n,05])
		
		If mv_par05 == 1 .and. lMVZLCPTA
			nUNTLIQ := aCols[n,04]+M->XX_VLREAJ
			If aCols[n,13] > 0
				nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
			EndIf
			If aCols[n,10] == "F"
				nUNTLIQ := nUNTLIQ - aCols[n,14]
			EndIf
		EndIf
		
		If nUNTLIQ <= nPrcLim .Or. lOk
			aCols[n,08] := aCols[n,04]+M->XX_VLREAJ
			aCols[n,09] := aCols[n,08]*aCols[n,05]
			
			If mv_par05 == 1 .and. lMVZLCPTA
				nUNTLIQ := aCols[n,08]
				If aCols[n,13] > 0
					nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
				EndIf
				If aCols[n,10] == "F"
					nUNTLIQ := nUNTLIQ - aCols[n,14]
				EndIf
				nTOTLIQ := nUNTLIQ * aCols[n,05]
				aCols[n,11] := nUNTLIQ
				aCols[n,12] := nTOTLIQ
			EndIf
		Else
			//Alert("Pre็o acima do limite permitido pra esta quantidade!")
			ShowHelpDlg( "Alerta",;
			{ "Pre็o acima do limite permitido pra esta quantidade! Esse movimento nao serแ reajustado!" + chr(10) + chr(13) + chr(10) + chr(13) + ;
			"Lin./Cod/Nome: " + chr(10) + chr(13) + Alltrim(aCols[n,01]) + "/" + aCols[n,02] + "/" + aCols[n,03] + chr(10) + chr(13)}, 5,;
			{ "Qtd Entregue:  " + Transform( aCols[n,05], "@E 999,99999" ) + chr(10) + chr(13) + ;
			"Valor mแximo:  " + Transform( nPrcLim,     "@E 9,999.9999" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
			"Em caso de exce็ใo solicite a altera็ใo ao responsแvel. Par. MV_ZLEXPR!"}, 5)
			
			M->XX_VLREAJ := 0
			
			aCols[n,08] := aCols[n,04]
			aCols[n,09] := aCols[n,04]*aCols[n,05]
			
			If mv_par05 == 1 .and. lMVZLCPTA
				nUNTLIQ := aCols[n,08]
				If aCols[n,13] > 0
					nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
				EndIf
				If aCols[n,10] == "F"
					nUNTLIQ := nUNTLIQ - aCols[n,14]
				EndIf
				nTOTLIQ := nUNTLIQ * aCols[n,05]
				aCols[n,11] := nUNTLIQ
				aCols[n,12] := nTOTLIQ
			EndIf
		EndIf
	Else
		aCols[n,08] := aCols[n,04]-M->XX_VLREAJ
		aCols[n,09] := aCols[n,08]*aCols[n,05]
		
		If mv_par05 == 1 .and. lMVZLCPTA
			nUNTLIQ := aCols[n,08]
			If aCols[n,13] > 0
				nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
			EndIf
			If aCols[n,10] == "F"
				nUNTLIQ := nUNTLIQ - aCols[n,14]
			EndIf
			nTOTLIQ := nUNTLIQ * aCols[n,05]
			aCols[n,11] := nUNTLIQ
			aCols[n,12] := nTOTLIQ
		EndIf
		
		
	EndIf
	
	For nI := 1 to Len(aCols)
		nTQTD += aCols[nI,05]
		nTVLR += aCols[nI,09]
		If mv_par05 == 1 .and. lMVZLCPTA
			nTLIQ += aCols[nI,12]
		EndIf
	Next nI
	
	
	If ValType(oDlg) == "O"
		If ( ValType(oDlg:Cargo)=="B" )
			If mv_par05 == 1 .and. lMVZLCPTA
				Eval(oDlg:Cargo,nTQTD,nTVLR,nTLIQ)
			Else
				Eval(oDlg:Cargo,nTQTD,nTVLR)
			EndIf
		EndIf
	Endif
	
	oDlg:Refresh()
Else
	Alert("O valor do reajuste nใo pode ser negativo! Utilize o campo Acrescimo/Decr้scimo!")
	If aCols[n,04] > aCols[n,08]
		M->XX_VLREAJ := aCols[n,04] - aCols[n,08]
	Else
		M->XX_VLREAJ := aCols[n,08] - aCols[n,04]
	EndIf
EndIf
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCAD2UP2   บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar de altera็ใo de pre็os.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
User Function LCAD2UP2()
*---------------------------------------------------------------------*
Local lAcres := M->XX_TPREAJ=="A"
Local nTQTD := 0
Local nTVLR := 0
Local nTLIQ := 0
Local nPrcLim := 0
Local nUNTLIQ := 0
Local nI := 0

If __cUserId $ cMV_ZLEPR
	lOk := .T.
EndIf

If lAcres
	nPrcLim := U_BUSCAFAIXA(aCols[n,05])
	
	If mv_par05 == 1 .and. lMVZLCPTA
		nUNTLIQ := aCols[n,04]+aCols[n,06]
		If aCols[n,13] > 0
			nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
		EndIf
		If aCols[n,10] == "F"
			nUNTLIQ := nUNTLIQ - aCols[n,14]
		EndIf
	EndIf
	
	If nUNTLIQ <= nPrcLim .Or. lOk
		aCols[n,08] := aCols[n,04]+aCols[n,06]
		aCols[n,09] := aCols[n,08]*aCols[n,05]
		
		If mv_par05 == 1 .and. lMVZLCPTA
			nUNTLIQ := aCols[n,08]
			If aCols[n,13] > 0
				nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
			EndIf
			If aCols[n,10] == "F"
				nUNTLIQ := nUNTLIQ - aCols[n,14]
			EndIf
			nTOTLIQ := nUNTLIQ * aCols[n,05]
			aCols[n,11] := nUNTLIQ
			aCols[n,12] := nTOTLIQ
		EndIf
	Else
		//Alert("Pre็o acima do limite permitido pra esta quantidade!")
		ShowHelpDlg( "Alerta",;
		{ "Pre็o acima do limite permitido pra esta quantidade! Esse movimento nao serแ reajustado!" + chr(10) + chr(13) + chr(10) + chr(13) + ;
		"Lin./Cod/Nome: " + chr(10) + chr(13) + Alltrim(aCols[n,01]) + "/" + aCols[n,02] + "/" + aCols[n,03] + chr(10) + chr(13)}, 5,;
		{ "Qtd Entregue:  " + Transform( aCols[n,05], "@E 999,99999" ) + chr(10) + chr(13) + ;
		"Valor mแximo:  " + Transform( nPrcLim,     "@E 9,999.9999" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
		"Em caso de exce็ใo solicite a altera็ใo ao responsแvel. Par. MV_ZLEXPR!"}, 5)
		M->XX_TPREAJ:="D"
	EndIf
Else
	aCols[n,08] := aCols[n,04]-aCols[n,06]
	aCols[n,09] := aCols[n,08]*aCols[n,05]
	
	If mv_par05 == 1 .and. lMVZLCPTA
		nUNTLIQ := aCols[n,08]
		If aCols[n,13] > 0
			nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
		EndIf
		If aCols[n,10] == "F"
			nUNTLIQ := nUNTLIQ - aCols[n,14]
		EndIf
		nTOTLIQ := nUNTLIQ * aCols[n,05]
		aCols[n,11] := nUNTLIQ
		aCols[n,12] := nTOTLIQ
	EndIf
	
EndIf

For nI := 1 to Len(aCols)
	nTQTD += aCols[nI,05]
	nTVLR += aCols[nI,09]
	If mv_par05 == 1 .and. lMVZLCPTA
		nTLIQ += aCols[nI,12]
	EndIf
Next nI


If ValType(oDlg) == "O"
	If ( ValType(oDlg:Cargo)=="B" )
		If mv_par05 == 1 .and. lMVZLCPTA
			Eval(oDlg:Cargo,nTQTD,nTVLR,nTLIQ)
		Else
			Eval(oDlg:Cargo,nTQTD,nTVLR)
		EndIf
	EndIf
Endif

oDlg:Refresh()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCAD2UP3   บAutor  ณRafael Parma       บ Data ณ  15/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar de altera็ใo de pre็os.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
User Function LCAD2UP3()
*---------------------------------------------------------------------*
Local lAcres := .T.
Local nTQTD := 0
Local nTVLR := 0
Local nTLIQ := 0
Local nPrcLim := 0
Local lOk := .F. 
Local nI := 0
Local nUNTLIQ := 0

If __cUserId $ cMV_ZLEPR
	lOk := .T.
EndIf

If M->XX_NOVALR >= aCols[n,04]
	aCols[n,07] := "A"
	lAcres := .T.
Else
	aCols[n,07] := "D"
	lAcres := .F.
EndIf


If lAcres
	nPrcLim := U_BUSCAFAIXA(aCols[n,05])
	
	If mv_par05 == 1 .and. lMVZLCPTA
		nUNTLIQ := M->XX_NOVALR
		If aCols[n,13] > 0
			nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
		EndIf
		If aCols[n,10] == "F"
			nUNTLIQ := nUNTLIQ - aCols[n,14]
		EndIf
	EndIf
	
	If nUNTLIQ <= nPrcLim .Or. lOk
		aCols[n,06] := M->XX_NOVALR-aCols[n,04]
		aCols[n,09] := M->XX_NOVALR*aCols[n,05]
		
		If mv_par05 == 1 .and. lMVZLCPTA
			nUNTLIQ := M->XX_NOVALR
			If aCols[n,13] > 0
				nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
			EndIf
			If aCols[n,10] == "F"
				nUNTLIQ := nUNTLIQ - aCols[n,14]
			EndIf
			nTOTLIQ := nUNTLIQ * aCols[n,05]
			aCols[n,11] := nUNTLIQ
			aCols[n,12] := nTOTLIQ
		EndIf
	Else
		//Alert("Pre็o acima do limite permitido pra esta quantidade!")
		ShowHelpDlg( "Alerta",;
		{ "Pre็o acima do limite permitido pra esta quantidade! Esse movimento nao serแ reajustado!" + chr(10) + chr(13) + chr(10) + chr(13) + ;
		"Lin./Cod/Nome: " + chr(10) + chr(13) + Alltrim(aCols[n,01]) + "/" + aCols[n,02] + "/" + aCols[n,03] + chr(10) + chr(13)}, 5,;
		{ "Qtd Entregue:  " + Transform( aCols[n,05], "@E 999,99999" ) + chr(10) + chr(13) + ;
		"Valor mแximo:  " + Transform( nPrcLim,     "@E 9,999.9999" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
		"Em caso de exce็ใo solicite a altera็ใo ao responsแvel. Par. MV_ZLEXPR!"}, 5)
		M->XX_NOVALR := aCols[n,04]
		aCols[n,06] := 0
		aCols[n,09] := aCols[n,04]*aCols[n,05]
		
		If mv_par05 == 1 .and. lMVZLCPTA
			nUNTLIQ := M->XX_NOVALR
			If aCols[n,13] > 0
				nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
			EndIf
			If aCols[n,10] == "F"
				nUNTLIQ := nUNTLIQ - aCols[n,14]
			EndIf
			nTOTLIQ := nUNTLIQ * aCols[n,05]
			aCols[n,11] := nUNTLIQ
			aCols[n,12] := nTOTLIQ
		EndIf
	EndIf
Else
	aCols[n,06] := aCols[n,04]-M->XX_NOVALR
	aCols[n,09] := M->XX_NOVALR*aCols[n,05]
	
	If mv_par05 == 1 .and. lMVZLCPTA
		nUNTLIQ := M->XX_NOVALR
		If aCols[n,13] > 0
			nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
		EndIf
		If aCols[n,10] == "F"
			nUNTLIQ := nUNTLIQ - aCols[n,14]
		EndIf
		nTOTLIQ := nUNTLIQ * aCols[n,05]
		aCols[n,11] := nUNTLIQ
		aCols[n,12] := nTOTLIQ
	EndIf
	
EndIf

For nI := 1 to Len(aCols)
	nTQTD += aCols[nI,05]
	nTVLR += aCols[nI,09]
	If mv_par05 == 1 .and. lMVZLCPTA
		nTLIQ += aCols[nI,12]
	EndIf
Next nI


If ValType(oDlg) == "O"
	If ( ValType(oDlg:Cargo)=="B" )
		If mv_par05 == 1 .and. lMVZLCPTA
			Eval(oDlg:Cargo,nTQTD,nTVLR,nTLIQ)
		Else
			Eval(oDlg:Cargo,nTQTD,nTVLR)
		EndIf
	EndIf
Endif

oDlg:Refresh()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCAD2UP4   บAutor  ณRafael Parma       บ Data ณ  15/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar de altera็ใo de pre็os.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
User Function LCAD2UP4()
*---------------------------------------------------------------------*
Local lAcres := .T.
Local nTQTD := 0
Local nTVLR := 0
Local nTLIQ := 0
Local nPrcLim := 0
Local lOk := .F.
Local nI := 0
Local nUNTLIQ := 0

If __cUserId $ cMV_ZLEPR
	lOk := .T.
EndIf


If Round(M->XX_UNTLIQ * aCols[n,05], 2) >= Round( aCols[n,12], 2)
	aCols[n,07] := "A"
	lAcres := .T.
Else
	aCols[n,07] := "D"
	lAcres := .F.
EndIf


If aCols[n,10] == "F"
	nUNTBRT := XX_UNTLIQ + aCols[n,14]
Else
	nUNTBRT := XX_UNTLIQ
EndIf

If lAcres
	If aCols[n,13] > 0
		nUNTBRT := nUNTBRT / ( 1 - ( aCols[n,13] ) / 100 )
	EndIf
Else
	If aCols[n,13] > 0
		nUNTBRT := nUNTBRT + ( ( nUNTBRT * aCols[n,13] ) / 100 )
	EndIf
EndIf

aCols[n,08] := nUNTBRT
aCols[n,09] := nUNTBRT * aCols[n,05]
aCols[n,12] := M->XX_UNTLIQ * aCols[n,05]

If lAcres
	nPrcLim := U_BUSCAFAIXA(aCols[n,05])
	If M->XX_UNTLIQ <= nPrcLim .Or. lOk
		aCols[n,06] := nUNTBRT - aCols[n,04]
	Else
		//Alert("Pre็o acima do limite permitido pra esta quantidade!")
		ShowHelpDlg( "Alerta",;
		{ "Pre็o acima do limite permitido pra esta quantidade! Esse movimento nao serแ reajustado!" + chr(10) + chr(13) + chr(10) + chr(13) + ;
		"Lin./Cod/Nome: " + chr(10) + chr(13) + Alltrim(aCols[n,01]) + "/" + aCols[n,02] + "/" + aCols[n,03] + chr(10) + chr(13)}, 5,;
		{ "Qtd Entregue:  " + Transform( aCols[n,05], "@E 999,99999" ) + chr(10) + chr(13) + ;
		"Valor mแximo:  " + Transform( nPrcLim,     "@E 9,999.9999" ) + chr(10) + chr(13) + chr(10) + chr(13) + ;
		"Em caso de exce็ใo solicite a altera็ใo ao responsแvel. Par. MV_ZLEXPR!"}, 5)
		
		aCols[n,06] := 0
		aCols[n,08] := aCols[n,04]
		aCols[n,09] := aCols[n,04] * aCols[n,05]
		
		If mv_par05 == 1 .and. lMVZLCPTA
			nUNTLIQ := aCols[n,04]
			If aCols[n,13] > 0
				nUNTLIQ := nUNTLIQ - ( ( nUNTLIQ * aCols[n,13] ) / 100 )
			EndIf
			If aCols[n,10] == "F"
				nUNTLIQ := nUNTLIQ - aCols[n,14]
			EndIf
			nTOTLIQ := nUNTLIQ * aCols[n,05]
			M->XX_UNTLIQ := nUNTLIQ
			aCols[n,12] := nTOTLIQ
		EndIf
	EndIf
Else
	aCols[n,06] := (nUNTBRT - aCols[n,04]) * (-1)
EndIf


For nI := 1 to Len(aCols)
	nTQTD += aCols[nI,05]
	nTVLR += aCols[nI,09]
	If mv_par05 == 1 .and. lMVZLCPTA
		nTLIQ += aCols[nI,12]
	EndIf
Next nI


If ValType(oDlg) == "O"
	If ( ValType(oDlg:Cargo)=="B" )
		If mv_par05 == 1 .and. lMVZLCPTA
			Eval(oDlg:Cargo,nTQTD,nTVLR,nTLIQ)
		Else
			Eval(oDlg:Cargo,nTQTD,nTVLR)
		EndIf
	EndIf
Endif

oDlg:Refresh()

Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExpXLS  บAutor  ณRafael Parma         บ Data ณ  10/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExporta็ใo dos dados p/ planilha excel.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------------*
Static Function fExpXLS()
*--------------------------------------*
Local cArquivo := GetNextAlias()
Local cPath	   := AllTrim(GetTempPath())
Local nI := 0

Private cArqTxt := cPath+cArquivo+".csv"
Private nHdl    := fCreate(cArqTxt)

If nHdl == -1
	MsgAlert("O arquivo "+cArqTxt+" nใo pode ser executado! Verifique os parโmetros.","Aten็ใo!")
	Return
Endif

If ! ApOleClient( 'MsExcel' )
	MsgStop("MsExcel nใo instalado!")
	Return
EndIf

cLin := "Linha" 		 	+ ";"
cLin += "Produtor" 		 	+ ";"
cLin += "Nome"	 		 	+ ";"
cLin += "Valor Antigo"	 	+ ";"
cLin += "Quantidade Leite" 	+ ";"
cLin += "Valor Reajuste" 	+ ";"
cLin += "Tipo Reajuste" 	+ ";"
cLin += "Novo Valor"	 	+ ";"
If mv_par05 == 1 .and. lMVZLCPTA
	cLin += "Total Bruto"  	+ ";"
	cLin += "Tipo Transp." 	+ ";"
	cLin += "Unitแrio Liq."	+ ";"
	cLin += "Total Liquido" + CHR(13)
	
Else
	cLin += "Valor Total"  	+ CHR(13)
EndIf

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na grava็ใo do arquivo. Continua?","Aten็ใo!")
		Return
	Endif
Endif

For nI := 1 to Len(aCols)
	
	cLin := aCols[nI,01] + ";"
	cLin += aCols[nI,02] + ";"
	cLin += aCols[nI,03] + ";"
	cLin += cValToChar(aCols[nI,04]) + ";"
	cLin += cValToChar(aCols[nI,05]) + ";"
	cLin += cValToChar(aCols[nI,06]) + ";"
	cLin += aCols[nI,07] + ";"
	cLin += cValToChar(aCols[nI,08]) + ";"
	If mv_par05 == 1 .and. lMVZLCPTA
		cLin += cValToChar(aCols[nI,09]) + ";"
		cLin += aCols[nI,10]			 + ";"
		cLin += cValToChar(aCols[nI,11]) + ";"
		cLin += cValToChar(aCols[nI,12]) + CHR(13)
	Else
		cLin += cValToChar(aCols[nI,09]) + CHR(13)
	EndIf
	
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na grava็ใo do arquivo. Continua?","Aten็ใo!")
			Exit
		Endif
	Endif
	
Next nI

fClose(nHdl)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cArqTxt ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWPrint    บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para impressใo dos dados.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function fWPrint()
*---------------------------------------------------------------------*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := ""
//Local cPict  := ""
Local titulo := "Reajustes tabelas de pre็os"
Local nLin   := 80

Local Cabec1 	:= "LINHA     PRODUTOR                      PREวO ANTIGO    QTDE LEITE    VALOR REAJUS.   TIPO    NOVO PREวO     VALOR TOTAL"
Local Cabec2 	:= ""
//Local imprime 	:= .T.
Local aOrd 		:= {}
Private lEnd    := .F.
Private lAbortPrint  := .F.
Private CbTxt   := ""
Private limite  := 220
Private tamanho := "G"
Private nomeprog:= "LTCAD002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo   := 18
Private aReturn := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey:= 0
//Private cbtxt   := Space(10)
Private cbcont  := 00
Private CONTFL  := 01
Private m_pag   := 01
Private cString := "ZL2"
Private wnrel   := "LTCAD002" // Coloque aqui o nome do arquivo usado para impressao em disco

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport  บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para impressใo dos dados.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nQTDTOT := 0
Local nVLRTOT := 0
Local nLIQTOT := 0
Local nI := 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(Len(aCols))

/*
1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
LINHA     PRODUTOR                      PRECO ANTIGO    QTDE LEITE    VALOR REAJUS.   TIPO    NOVO PREวO     TOTAL BRUTO      TIPO TRANSP.    NOVO PRC.LIQ.     TOTAL LIQUIDO
*/

If mv_par05 == 1 .and. lMVZLCPTA
	Cabec1 	:= "LINHA     PRODUTOR                      PREวO ANTIGO    QTDE LEITE    VALOR REAJUS.   TIPO    NOVO PREวO     TOTAL BRUTO      TIPO TRANSP.    NOVO PRC.LIQ.     TOTAL LIQUIDO"
EndIf

For nI := 1 to Len(aCols)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,000 PSAY aCols[nI,01]
	@nLin,010 PSAY SubSTR(ALLTRIM(aCols[nI,02])+"-"+ALLTRIM(aCols[nI,03]),1,30)
	@nLin,044 PSAY TRANSFORM(aCols[nI,04],"@E 999.9999")
	@nLin,058 PSAY TRANSFORM(aCols[nI,05],"@E 9999999")
	@nLin,074 PSAY TRANSFORM(aCols[nI,06],"@E 999.9999")
	@nLin,088 PSAY aCols[nI,07]
	@nLin,096 PSAY TRANSFORM(aCols[nI,08],"@E 999.9999")
	@nLin,110 PSAY TRANSFORM(aCols[nI,09],"@E 999,999.99")
	
	If mv_par05 == 1 .and. lMVZLCPTA
		
		@nLin,130 PSAY aCols[nI,10]
		@nLin,144 PSAY TRANSFORM(aCols[nI,11],"@E 999.9999")
		@nLin,162 PSAY TRANSFORM(aCols[nI,12],"@E 999,999.99")
		
		nLIQTOT += aCols[nI,12]
		
	EndIf
	
	nQTDTOT += aCols[nI,05]
	nVLRTOT += aCols[nI,09]
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
Next nI

nLin := nLin + 1
@nLin,000 PSAY "TOTAL GERAL: "
@nLin,058 PSAY TRANSFORM(nQTDTOT,"@E 9999999")
@nLin,110 PSAY TRANSFORM(nVLRTOT,"@E 999,999.99")
If mv_par05 == 1 .and. lMVZLCPTA
	@nLin,162 PSAY TRANSFORM(nLIQTOT,"@E 999,999.99")
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function AjustaSX1()
*---------------------------------------------------------------------*
Local aRegs   := {}
Local i := 0
Local j := 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
aAdd(aRegs,{cPerg,"01","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch1","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",""})
aAdd(aRegs,{cPerg,"02","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch2","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",""})
aAdd(aRegs,{cPerg,"03","Data Coleta De     ?","Data Coleta De     ?","Data Coleta De     ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"04","Data Coleta At้    ?","Data Coleta At้    ?","Data Coleta At้    ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"05","Atualizar Pre็o    ?","Atualizar Pre็o    ?","Atualizar Pre็o    ?","mv_ch5","N",01,0,1,"C","","mv_par05","Leite","Leite","Leite","","","Frete","Frete","Frete","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"06","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_ch6","N",01,0,1,"C","","mv_par06","Linha+C๓digo","Linha+C๓digo","Linha+C๓digo","","","Linha+Nome","Linha+Nome","Linha+Nome","","","C๓digo+Linha","C๓digo+Linha","C๓digo+Linha","","","Nome+Linha","Nome+Linha","Nome+Linha","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"07","Transportador De   ?","Transportador De   ?","Transportador De   ?","mv_ch7","C",TAMSX3("ZL0_TRANSP")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "SA4","","",""})
aAdd(aRegs,{cPerg,"08","Transportador At้  ?","Transportador At้  ?","Transportador At้  ?","mv_ch8","C",TAMSX3("ZL0_TRANSP")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "SA4","","",""})
aAdd(aRegs,{cPerg,"09","Pre็o Leite De     ?","Pre็o Leite De     ?","Pre็o Leite De     ?","mv_ch9","N",TAMSX3("ZL2_PRCLEI")[1],TAMSX3("ZL2_PRCLEI")[2],0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"10","Pre็o Leite At้    ?","Pre็o Leite At้    ?","Pre็o Leite At้    ?","mv_cha","N",TAMSX3("ZL2_PRCLEI")[1],TAMSX3("ZL2_PRCLEI")[2],0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"11","Pre็o Frete De     ?","Pre็o Frete De     ?","Pre็o Frete De     ?","mv_chb","N",TAMSX3("ZL2_PRCFRT")[1],TAMSX3("ZL2_PRCFRT")[2],0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"12","Pre็o Frete At้    ?","Pre็o Frete At้    ?","Pre็o Frete At้    ?","mv_chc","N",TAMSX3("ZL2_PRCFRT")[1],TAMSX3("ZL2_PRCFRT")[2],0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})


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

Return Nil                                                 
