#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT450FIM    ºAutor ³Alexandre LonghinottiºData ³ 23/09/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite que a liberação / rejeição por pedido  seja        º±±
±±º          ³ v                    .                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS           
                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 */

User function MTA450LIB()
	************************
	Local lRet := .T.
	Local _cBlqDesc := "C"

	dbSelectArea('ZAI')
	ZAI->(dbSetOrder(1))
	ZAI->(dbGoTop())
	If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+'C'))
		RecLock('ZAI',.F.)
	else
		RecLock('ZAI',.T.)
	EndIf

	ZAI->ZAI_FILIAL  := xFilial('ZAI')
	ZAI->ZAI_NUM     :=  SC5->C5_NUM
	ZAI->ZAI_MOTBLQ  := _cBlqDesc  // 1 = Desconto; 2 = Validade PV
	ZAI->ZAI_DTBLQ   := dDataBase
	ZAI->ZAI_CANAL   := ""
	ZAI->ZAI_DESCR   := ""
	ZAI->ZAI_CLI     := SC5->C5_CLIENTE
	ZAI->ZAI_LOJA    := SC5->C5_LOJACLI
	ZAI->ZAI_NOME    := Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME')
	ZAI->ZAI_VEND    := SC5->C5_VEND1
	ZAI->ZAI_NOMVEN  := Posicione('SA3',1,xFilial('SA3')+SC5->C5_VEND1,'A3_NOME')
	ZAI->ZAI_DESC    := 0
	ZAI->ZAI_VALID   := SC5->C5_X_VLD
	ZAI->ZAI_OPER    := '1'
	ZAI->ZAI_JUST    := trim(ZAI->ZAI_JUST) + CHR(13)+CHR(10) + dtoc(ddatabase) + ' ' + TIME() + CHR(13)+CHR(10) + 'CREDITO LIBERADO POR: ' + UPPER(ALLTRIM(FwGetUserName(__cUserID))) + " - " + Alltrim(FunName())
	ZAI->ZAI_DTOPER  := dDataBase
	ZAI->ZAI_USER    := __cUserId
	ZAI->ZAI_NIVEL   := ''
	ZAI->(MsUnlock())

Return( lRet )

