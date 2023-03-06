#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTBFIS002  บAutor  ณALEXANDRE LONGIHNOTTI Data ณ  11/05/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aj Man dos parametros MV_DATAFIN MV_BXDTFIN MV_DATAFIS     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS TRELAC                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TBFIS002()  
Local dDataFin := GETMV("MV_DATAFIN") 
Local dBxDtFin := GETMV("MV_BXDTFIN") 
Local dDataFis := GETMV("MV_DATAFIS") 
Local nOpc := 0
Local cCab := "Bloqueio de movimentos FIN/FIS"
Local aItens := {"1=Sim","2=Nใo"}
	
	oDlgY := MSDialog():New(000,000,150,350,cCab,,,.F.,,,,,,.T.,,,.T. )
	
    oSayData := TSay():New(010,004,{|| "MV_DATAFIN:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	@ 009, 040 MSGET oData  	VAR dDataFin	PICTURE "@E 99" OF oDlgY WHEN .T. PIXEL SIZE 050,008 HASBUTTON
    oSayData := TSay():New(010,090,{|| "Mov. Financeiras"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,008)

    oSayData := TSay():New(022,004,{|| "MV_BXDTFIN:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,042,008)
	//	@ 019, 040 MSGET oData  	VAR dBxDtFin	PICTURE "@E 99" OF oDlgY WHEN .T. PIXEL SIZE 020,008 HASBUTTON
    //oSayData := TSay():New(020,090,{|| "Dias para Baixas"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,008)
	@ 021, 040 MSCOMBOBOX oData VAR dBxDtFin ITEMS aItens SIZE 040, 008 OF oDlgY PIXEL
    oSayData := TSay():New(022,090,{|| "Permite baixas PAG/REC?"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,090,008)
	

    oSayData := TSay():New(034,004,{|| "MV_DATAFIS:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,052,008)
	@ 033, 040 MSGET oData  	VAR dDataFis	PICTURE "@E 99" OF oDlgY WHEN .T. PIXEL SIZE 050,008 HASBUTTON
	oSayData := TSay():New(034,090,{|| "Mov. Fiscais"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,008)

    oBtnData := TButton():New(047, 40, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 047, 012,,,, .T.,,"",,,, .F.)
	oDlgY:Activate(,,,.T.)
	If nOpc == 1
		PUTMV("MV_DATAFIN",dDataFin)
        PUTMV("MV_BXDTFIN",dBxDtFin)
        PUTMV("MV_DATAFIS",dDataFis)
	EndIf
Return
	
Return  
