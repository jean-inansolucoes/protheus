#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLSEST04  บAutor  ณALEXANDRE LONGIHNOTTI Data ณ  11/05/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aj Man dos parametros MX_FECEST    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS TRELAC                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSEST04()
	Local dDataEst := GETMV("MX_FECEST")
	Local nOpc := 0
	Local cCab := "Libera็ใo do Fechamento de Estoque"
	Local cUsrCon	:= GETMV("MX_USCONT",, "")
	If __cUserId $ cUsrCon
		
		oDlgY := MSDialog():New(000,000,150,350,cCab,,,.F.,,,,,,.T.,,,.T. )

		oSayData := TSay():New(010,004,{|| "MX_FECEST:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		@ 009, 040 MSGET oData  	VAR dDataEst	OF oDlgY WHEN .T. PIXEL SIZE 050,008 HASBUTTON
		oSayData := TSay():New(010,090,{|| "Data Fechamento"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,008)

		oBtnData := TButton():New(047, 40, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 047, 012,,,, .T.,,"",,,, .F.)
		oDlgY:Activate(,,,.T.)
		If nOpc == 1
			PUTMV("MX_FECEST",dDataEst)
		EndIf
	else
		U_GCALL001("Aten็ใo - Par. MX_USCONT", "Usuแrio sem permissใo para liberar fechamento de estoque", "Favor entrar em contato com o departamento Contabil e informar o ocorrido.")
	ENDIF

Return
