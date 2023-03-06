#include "TOTVS.CH"
#include "FWPRINTSETUP.CH"
#include "RPTDEF.CH"
#include "TOPCONN.CH"

#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "protheus.CH"
#Include "ap5mail.ch"
#Include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                              
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LTREL047 บAutor ณAlexandre Longhinotti บ Data ณ  09/2015    บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ EMPENHO (Emissao em formato Grafico)                       บฑฑ
ฑฑ           ณ Para o Botao Imprimir na rotina documentos de entrada	  บฑฑ
ฑฑ          															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/

User Function LTREL047()

	private cPath := "\data\"
	private cFile := "Ticket_"+UPPER(ALLTRIM(ZM1->ZM1_NUM))+".pdf"

	Private nPag  		:= 0
	Private	lEnd		:= .F.
	Private	cPerg		:= 'LTREL047  '
	Private _cFornece   := ""
	Private _cGrup 		:= ""
	Private Cond   		:= ""
	Private _cCond 		:= ""
	Private _cTpFrete  	:= ""
	Private TpFrete		:= ""
	Private oPrinter
	Private	oPrint		:= TMSPrinter():New(OemToAnsi('TICKET BALANวA'))
	Private oBrush		:= TBrush():New(,4)
	Private oPen		:= TPen():New(0,5,CLR_BLACK)
	Private _cLogo		:= GetSrvProfString("Startpath","") + "logo.BMP"
	Private aDADOSCC := {}
	Private aParcela := {}
	Private cAliasTMP	:= GetNextAlias()
	Private hEnter	:= CHR(10) + CHR(13)

	Private oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08	  	:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Tahoma',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
		oFont11n	:= TFont():New('Tahoma',11,11,,.T.,,,,.T.,.F.),;
		oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
		oFont12n	:= TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.),;
		oFont13		:= TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont15		:= TFont():New('Tahoma',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Arial' ,18,18,,.T.,,,,.T.,.F.),;
		oFont16		:= TFont():New('Arial' ,16,16,,.T.,,,,.T.,.F.),;
		oFont20		:= TFont():New('Arial' ,20,20,,.F.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial' ,22,22,,.T.,,,,.T.,.F.)

	If !Empty(ZM1->ZM1_TRANSP)
		If(ApMsgNoYes('Deseja enviar este Ticket por email?'))

			oPrinter 	:= FWMSPrinter():New(cFile, IMP_PDF, .T., cPath, .T.,,,, .T.,,, .F.)
			oPrinter:SetPortrait()
			oPrinter:SetPaperSize(DMPAPER_A4)
			oPrinter:SetMargin(40,40,40,40)
			oPrinter:cPathPDF := cPath
			Processa({ |lEnd| Printreport(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))
			oPrinter:Print()
			FreeObj(oPrinter)
			EnvMail()
			Processa({ |lEnd| xPrintRelB(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))
		else
			Processa({ |lEnd| xPrintRelB(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))
		EndIf
	Else

		Processa({ |lEnd| xPrintRelB(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))

	EndIf
	FErase( '\data\ticket_'+ UPPER(ALLTRIM(ZM1->ZM1_NUM)) +'.pdf')
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณ Alexandre Longhinottiบ Data ณ  09/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Empenho                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Printreport()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	private oFont14CN  := TFont():New("Courier new",,16)
	private oFont14CNb := TFont():New("Arial",,16)
	private oFont12CN  := TFont():New("Courier new",,12)
	private oFont16CI  := TFont():New("Courier new",,16,,,,,,,,.T.)
	private oFont18BD  := TFontEx():New(oPrinter,"Arial",18,18,.T.,.T.,.F.)
	private oFont16BD  := TFontEx():New(oPrinter,"Arial",16,16,.T.,.T.,.F.)
	private oFont16    := TFontEx():New(oPrinter,"Arial",16,16,.F.,.T.,.F.)
	private oFont14BD  := TFontEx():New(oPrinter,"Verdana",14,14,.T.,.T.,.F.)
	private oFont14    := TFontEx():New(oPrinter,"Verdana",14,14,.F.,.T.,.F.)
	private oFont12    := TFontEx():New(oPrinter,"Verdana",12,12,.F.,.T.,.F.)
	private oFont12BD  := TFontEx():New(oPrinter,"Verdana",12,12,.T.,.T.,.F.)
	private oFont10    := TFontEx():New(oPrinter,"Verdana",10,10,.F.,.T.,.F.)
	private oFont10BD    := TFontEx():New(oPrinter,"Verdana",10,10,.T.,.T.,.F.)


	//ฺฤฤฤฤฤฤฤฤฤฤฟ
	//ณFornecedorณ
	//ภฤฤฤฤฤฤฤฤฤฤู

	oBrushBranco := TBrush():New( , CLR_WHITE)
	oBrushCinza := TBrush():New( , Rgb(217,217,243) )

	oPrinter:Fillrect( {0425, 0050, 1050, 2350 }, oBrushBranco, "-2") //TBrush():New( , Rgb(255,255,255) )
	oPrinter:Box( 0425, 0050, 1050, 2350 , "-2")
	nLin := 455

	oPrinter:Say(415,2100,AllTrim("Via Motorista"),oFont12BD:oFont)

	oPrinter:Say(nLin+0020,0070,OemToAnsi('Empresa:'),oFont16BD:oFont)
	oPrinter:Say(nLin+0020,0320,'  ( ' +ZM1->ZM1_CLIFOR+') ' + UPPER(ALLTRIM(ZM1->ZM1_NOME)),oFont16BD:oFont)


	//Linha 1
	oPrinter:Say(nLin+100,0070,OemToAnsi('Entrada'),oFont16:oFont)
	oPrinter:FillRect( {nLin+125, 0065, nLin+190, 530}, oBrushCinza )
	oPrinter:Say(nLin+170,0080,DTOC(ZM1->ZM1_DTINI) + " - " + ZM1->ZM1_HRINI,oFont16BD:oFont)

	oPrinter:Say(nLin+100,0670,OemToAnsi('Saida'),oFont16:oFont)
	oPrinter:FillRect( {nLin+120, 00665, nLin+190, 1130}, oBrushCinza )
	oPrinter:Say(nLin+170,0680,DTOC(ZM1->ZM1_DTFIN) + " - " + ZM1->ZM1_HRFIN,oFont16BD:oFont)

	oPrinter:Say(nLin+100,1200,OemToAnsi('Placa'),oFont16:oFont)
	oPrinter:FillRect( {nLin+125, 1200, nLin+190, 1600}, oBrushCinza )
	oPrinter:Say(nLin+170,1250,TRANSFORM(ZM1->ZM1_PLACA, PESQPICT("ZM1", "ZM1_PLACA")),oFont16BD:oFont)

	oPrinter:Say(nLin+100,1800,OemToAnsi('Linha'),oFont16:oFont)
	oPrinter:FillRect( {nLin+125, 1800, nLin+190, 2250}, oBrushCinza )
	oPrinter:Say(nLin+170,1855,UPPER(ALLTRIM(ZM1->ZM1_CODLIN)),oFont16BD:oFont)

	//Linha 2
	oPrinter:Say(nLin+250,0070,OemToAnsi('Tipo'),oFont16:oFont)
	oPrinter:FillRect( {nLin+255, 0065, nLin+320, 0465}, oBrushCinza )
	oPrinter:Say(nLin+305,0070,IIF(ZM1->ZM1_TIPO == "1", "DESCARGA", "CARGA"),oFont16BD:oFont)

	oPrinter:Say(nLin+250,0670,OemToAnsi('Produto'),oFont16:oFont)
	oPrinter:FillRect( {nLin+255, 0670, nLin+320, 1600}, oBrushCinza )
	oPrinter:Say(nLin+305,0675,UPPER(ALLTRIM(ZM1->ZM1_DESC)),oFont16BD:oFont)


	//Linha 3
	oPrinter:Say(nLin+400,0070,OemToAnsi('Motorista'),oFont16:oFont)
	oPrinter:FillRect( {nLin+405, 0065, nLin+470, 1070}, oBrushCinza )
	oPrinter:Say(nLin+455,0070,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_NOMMOT))),oFont16BD:oFont)

	oPrinter:Say(nLin+0555,065,OemToAnsi('Obs.'),oFont16:oFont)
	oPrinter:Say(nLin+0555,165,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_OBS))),oFont16BD:oFont)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณExecuta regras para composi็ใo do KG Descarteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nKgDes := 0
	nSubtot := 0
	If ZM1->ZM1_KGIDES > 0
		nKgDes := ZM1->ZM1_KGIDES - ZM1->ZM1_KGFDES
		nSubtot := ZM1->ZM1_KGINI - ZM1->ZM1_KGFDES
	EndIf

	oPrinter:FillRect( {nLin+620, 0050, 1600, 2350}, oBrushCinza )
	//oPrinter:Box(nLin+620, 0050, 1600, 2350)


	oPrinter:Say(nLin+660,0070,OemToAnsi('DADOS DA PESAGEM'),oFont16BD:oFont)

	If nKgDes > 0

		oPrinter:Say(nLin+730,075,OemToAnsi('PESO ENTRADA... : '),oFont16:oFont)
		oPrinter:Say(nLin+730,500,TRANSFORM((ZM1->ZM1_KGINI), PESQPICT("ZM1", "ZM1_KGINI")),oFont16BD:oFont)

		oPrinter:Say(nLin+810,075,OemToAnsi('PESO SAIDA...  : '),oFont16:oFont)
		oPrinter:Say(nLin+810,500,TRANSFORM(ZM1->ZM1_KGFDES, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		oPrinter:Say(nLin+890,075,OemToAnsi('SUBTOTAL...  : '),oFont16:oFont)
		oPrinter:Say(nLin+890,500,TRANSFORM(nSubtot, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		oPrinter:Say(nLin+970,075,OemToAnsi('DESCARTE...  : '),oFont16:oFont)
		oPrinter:Say(nLin+970,500,TRANSFORM(nKgDes, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		Oprinter:Line(nLin+990, 075, nLin+990, 800)

		oPrinter:Say(nLin+1070,075,OemToAnsi('PESO LIQUIDO... : '),oFont16:oFont)
		oPrinter:Say(nLin+1070,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont16BD:oFont)

	Else

		oPrinter:Say(nLin+820,075,OemToAnsi('PESO ENTRADA... : '),oFont16:oFont)
		oPrinter:Say(nLin+820,500,TRANSFORM((ZM1->ZM1_KGINI), PESQPICT("ZM1", "ZM1_KGINI")),oFont16BD:oFont)

		oPrinter:Say(nLin+900,075,OemToAnsi('PESO SAIDA...  : '),oFont16:oFont)
		oPrinter:Say(nLin+900,500,TRANSFORM(ZM1->ZM1_KGFIN, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		Oprinter:Line(nLin+920, 075, nLin+920, 800)

		oPrinter:Say(nLin+1000,075,OemToAnsi('PESO LIQUIDO... : '),oFont16:oFont)
		oPrinter:Say(nLin+1000,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont16BD:oFont)

	EndIf

	oPrinter:Say(1620,0050,AllTrim("Ticket emitido em: "+DTOC(DATE())+" - Por: "+ __cUserID + " - " +  UPPER(ALLTRIM(FwGetUserName(__cUserID))) ),oFont12BD:oFont)
	oPrinter:Say(1680,0050,AllTrim("    Corte aqui -------------------------------------------------------------------------------------"),oFont12BD:oFont)

	//segunda via

	nLin := nLin + 1295


	//oPrinter:FillRect( {nLin, 0050, 2690, 2350}, oBrushBranco )
	oPrinter:Box(nLin, 0050, 2350, 2350 )
	//oPrinter:Box (060,450,700,2420)

	oPrinter:Say(nLin-10,2100,AllTrim("Via Trelac"),oFont12BD:oFont)

	nLin := nLin + 30

	oPrinter:Say(nLin+0020,0070,OemToAnsi('Empresa:'),oFont16:oFont)
	oPrinter:Say(nLin+0020,0320,'  ( ' +ZM1->ZM1_CLIFOR+') ' + UPPER(ALLTRIM(ZM1->ZM1_NOME)),oFont16BD:oFont)
	oPrinter:Say(nLin+0020,1800,AllTrim(TransForm(UPPER(ALLTRIM(ZM1->ZM1_NUM)),'@E 999999999')),oFont16BD:oFont)

	//Linha 1
	oPrinter:Say(nLin+100,0070,OemToAnsi('Entrada'),oFont16:oFont)
	oPrinter:FillRect( {nLin+125, 0065, nLin+190, 530}, oBrushCinza )
	oPrinter:Say(nLin+170,0080,DTOC(ZM1->ZM1_DTINI) + " - " + ZM1->ZM1_HRINI,oFont16BD:oFont)

	oPrinter:Say(nLin+100,0670,OemToAnsi('Saida'),oFont16:oFont)
	oPrinter:FillRect( {nLin+120, 00665, nLin+190, 1130}, oBrushCinza )
	oPrinter:Say(nLin+170,0680,DTOC(ZM1->ZM1_DTFIN) + " - " + ZM1->ZM1_HRFIN,oFont16BD:oFont)

	oPrinter:Say(nLin+100,1200,OemToAnsi('Placa'),oFont16:oFont)
	oPrinter:FillRect( {nLin+125, 1200, nLin+190, 1600}, oBrushCinza )
	oPrinter:Say(nLin+170,1250,TRANSFORM(ZM1->ZM1_PLACA, PESQPICT("ZM1", "ZM1_PLACA")),oFont16BD:oFont)

	oPrinter:Say(nLin+100,1800,OemToAnsi('Linha'),oFont16:oFont)
	oPrinter:FillRect( {nLin+125, 1800, nLin+190, 2250}, oBrushCinza )
	oPrinter:Say(nLin+170,1855,UPPER(ALLTRIM(ZM1->ZM1_CODLIN)),oFont16BD:oFont)

	//Linha 2
	oPrinter:Say(nLin+250,0070,OemToAnsi('Tipo'),oFont16:oFont)
	oPrinter:FillRect( {nLin+255, 0065, nLin+320, 0465}, oBrushCinza )
	oPrinter:Say(nLin+305,0070,IIF(ZM1->ZM1_TIPO == "1", "DESCARGA", "CARGA"),oFont16BD:oFont)

	oPrinter:Say(nLin+250,0670,OemToAnsi('Produto'),oFont16:oFont)
	oPrinter:FillRect( {nLin+255, 0670, nLin+320, 1600}, oBrushCinza )
	oPrinter:Say(nLin+305,0675,UPPER(ALLTRIM(ZM1->ZM1_DESC)),oFont16BD:oFont)


	//Linha 3
	oPrinter:Say(nLin+400,0070,OemToAnsi('Motorista'),oFont16:oFont)
	oPrinter:FillRect( {nLin+405, 0065, nLin+470, 1070}, oBrushCinza )
	oPrinter:Say(nLin+455,0070,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_NOMMOT))),oFont16BD:oFont)

	oPrinter:Say(nLin+0555,065,OemToAnsi('Obs.'),oFont16:oFont)
	oPrinter:Say(nLin+0555,165,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_OBS))),oFont16BD:oFont)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณExecuta regras para composi็ใo do KG Descarteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nKgDes := 0
	nSubtot := 0
	If ZM1->ZM1_KGIDES > 0
		nKgDes := ZM1->ZM1_KGIDES - ZM1->ZM1_KGFDES
		nSubtot := ZM1->ZM1_KGINI - ZM1->ZM1_KGFDES
	EndIf

	oPrinter:FillRect( {nLin+620, 0050, 2900, 2350}, oBrushCinza )
	//oPrinter:Box(nLin+620, 0050, 2900, 2350)


	oPrinter:Say(nLin+660,0070,OemToAnsi('DADOS DA PESAGEM'),oFont16BD:oFont)

	If nKgDes > 0

		oPrinter:Say(nLin+730,075,OemToAnsi('PESO ENTRADA... : '),oFont16:oFont)
		oPrinter:Say(nLin+730,500,TRANSFORM((ZM1->ZM1_KGINI), PESQPICT("ZM1", "ZM1_KGINI")),oFont16BD:oFont)

		oPrinter:Say(nLin+810,075,OemToAnsi('PESO SAIDA...  : '),oFont16:oFont)
		oPrinter:Say(nLin+810,500,TRANSFORM(ZM1->ZM1_KGFDES, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		oPrinter:Say(nLin+890,075,OemToAnsi('SUBTOTAL...  : '),oFont16:oFont)
		oPrinter:Say(nLin+890,500,TRANSFORM(nSubtot, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		oPrinter:Say(nLin+970,075,OemToAnsi('DESCARTE...  : '),oFont16:oFont)
		oPrinter:Say(nLin+970,500,TRANSFORM(nKgDes, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		Oprinter:Line(nLin+990, 075, nLin+990, 800)

		oPrinter:Say(nLin+1070,075,OemToAnsi('PESO LIQUIDO... : '),oFont16:oFont)
		oPrinter:Say(nLin+1070,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont16BD:oFont)

	Else

		oPrinter:Say(nLin+820,075,OemToAnsi('PESO ENTRADA... : '),oFont16:oFont)
		oPrinter:Say(nLin+820,500,TRANSFORM((ZM1->ZM1_KGINI), PESQPICT("ZM1", "ZM1_KGINI")),oFont16BD:oFont)

		oPrinter:Say(nLin+900,075,OemToAnsi('PESO SAIDA...  : '),oFont16:oFont)
		oPrinter:Say(nLin+900,500,TRANSFORM(ZM1->ZM1_KGFIN, PESQPICT("ZM1", "ZM1_KGFIN")),oFont16BD:oFont)

		Oprinter:Line(nLin+920, 075, nLin+920, 800)

		oPrinter:Say(nLin+1000,075,OemToAnsi('PESO LIQUIDO... : '),oFont16:oFont)
		oPrinter:Say(nLin+1000,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont16BD:oFont)

	EndIf



	xRodape()

	xCabec(UPPER(ALLTRIM(ZM1->ZM1_NUM)))

	oPrinter:EndPage()


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xCabec(cDocu)
	private oFont18BD  := TFontEx():New(oPrinter,"Arial",18,18,.T.,.T.,.F.)
	private oFont14    := TFontEx():New(oPrinter,"Verdana",14,14,.F.,.T.,.F.)

	PswOrder(1)  //** Codigo Usuario
	PswSeek( AllTrim(SC7->C7_USER),.t.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oPrinter:SayBitmap(020,020,_cLogo,1050,500) // Tem que estar abaixo do RootPath
	oPrinter:SayBitmap(020,030,_cLogo,266,360) // Tem que estar abaixo do RootPath
	oPrinter:Say(075,0450,SUBSTR(AllTrim(Upper(SM0->M0_NOMECOM)),1,48),oFont18BD:oFont)
	oPrinter:Say(135,0450,AllTrim(SM0->M0_ENDCOB),oFont14:oFont)
	oPrinter:Say(180,0450,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' +"("+Substr(SM0->M0_TEL,4,2)+") "+Substr(SM0->M0_TEL,7,4)+"-"+Substr(SM0->M0_TEL,11,4),oFont14:oFont)
	oPrinter:Say(225,0450,"CNPJ: "+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99') + '  -  ' + "I.E.: "+Alltrim(SM0->M0_INSC) ,oFont14:oFont)
	oPrinter:Say(265,0450,AllTrim('www.trelac.com.br'),oFont14:oFont)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrinter:Say(0350,0450,OemToAnsi('TICKET DE PESAGEM Nบ: '),oFont18BD:oFont)
	oPrinter:Say(0350,2100,AllTrim(TransForm(cDocu,'@E 999999999')),oFont18BD:oFont)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodape()
	private oFont12BD  := TFontEx():New(oPrinter,"Verdana",12,12,.T.,.T.,.F.)

	oPrinter:Line(2920,0050,2920,2350)
	oPrinter:Say(2940,0050,AllTrim("Ticket emitido em: "+DTOC(DATE())+" - Por: "+ __cUserID + " - " +  UPPER(ALLTRIM(FwGetUserName(__cUserID))) ),oFont12BD:oFont)

Return

Static Function EnvMail()

	Local _cSubject := "Ticket de Pesagem nบ:"+ ZM1->ZM1_NUM
	Local _cBody    := "Ticket de Pesagem"+space(170)
	Local _cDest    := SPACE(150)


	_lOk := .t.

	dbSelectArea("SA4")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("SA4")+ZM1->(ZM1_TRANSP) )

		if (SA4->A4_EMAIL) <> " "
			_cDest := Alltrim(SA4->A4_EMAIL)+space(100)
		Else
			_cDest := SPACE(150)
		EndIf
	eNDiF

	@ 10,10 TO 150,400 DIALOG oDlg1 TITLE "Se desejar insira o destinatario do email:"
	@ 5,10 Say "Destinatarios:"
	@ 12,10  Get _cDest  Size 120,13 when .T.
	@ 25,10 Say "Mensagem:"
	@ 32,10  Get _cBody  Size 120,13 when .T.
	@ 50,10  Button "&Ok" SIZE 35,15 ACTION oDlg1:End()
	ACTIVATE DIALOG oDlg1 CENTER

	CONNECT SMTP SERVER GetMV("MV_RELSERV") ACCOUNT GetMV("MV_RELACN1") PASSWORD GetMV("MV_RELPSW1") RESULT _lOk

	If _lOk
		If !MailAuth(alltrim(GetMV("MV_RELACN1")),alltrim(GetMV("MV_RELPSW1")) )
			MSGINFO("Falha na autentica็ใo do Usuแrio!")
			DISCONNECT SMTP SERVER RESULT lDisConectou
		Endif
	Else
		MSGINFO("Falha na Comunicacao com o servidor!")
	Endif

	_cAtach := ""

	_cAtach += '\data\ticket_'+ UPPER(ALLTRIM(ZM1->ZM1_NUM)) +'.pdf , "
	_cAtach := Substr(_cAtach,1,len(_cAtach) - 2 )

	If _lok
		SEND MAIL FROM GetMV("MV_RELFROM") ;
			TO _cDest ;
			SUBJECT _cSubject ;
			BODY _cBody ;
			ATTACHMENT _cAtach ;
			RESULT _lOk

		If _lOk
			msginfo("Email Enviado com Sucesso!")
			If (alltrim(_cDest) != Alltrim(SA4->A4_EMAIL))
				RECLOCK("SA4", .F.)
					SA4->A4_EMAIL := _cDest
				SA4->(MSUNLOCK())
			EndIf
		Else
			GET MAIL ERROR cSmtpError
			MsgSTop( "Erro de envio 1: " + cSmtpError+" Favor comunicar ao administrador do sistema.")
		Endif

	Else
		GET MAIL ERROR cSmtpError
		MsgSTop( "Erro de envio 2: " + cSmtpError+" Favor comunicar ao administrador do sistema.")
	Endif

	DISCONNECT SMTP SERVER RESULT _lok

	iF !_lok
		MSGINFO("Falha Disconnetc SMTP!")
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณ Alexandre Longhinottiบ Data ณ  09/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Empenho                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRelB()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	//ฺฤฤฤฤฤฤฤฤฤฤฟ
	//ณFornecedorณ
	//ภฤฤฤฤฤฤฤฤฤฤู

	oBrushBranco := TBrush():New( , Rgb(255,255,255) )
	oBrushCinza := TBrush():New( , Rgb(217,217,243) )

	oPrint:FillRect( {0500, 0050, 1200, 2350}, oBrushBranco )
	oPrint:Box( 0500, 0050, 1200, 2350 )
	//oPrint:Box (060,450,700,2420)
	nLin := 490

	oPrint:Say(nLin+0012,2100,AllTrim("Via Motorista"),oFont08)

	oPrint:Say(nLin+0020,0070,OemToAnsi('Empresa:'),oFont12)
	oPrint:Say(nLin+0020,0320,'  ( ' +ZM1->ZM1_CLIFOR+') ' + UPPER(ALLTRIM(ZM1->ZM1_NOME)),oFont12n)


	//Linha 1
	oPrint:Say(nLin+120,0070,OemToAnsi('Entrada'),oFont11)
	oPrint:FillRect( {nLin+175, 0065, nLin+260, 530}, oBrushCinza )
	oPrint:Say(nLin+190,0080,DTOC(ZM1->ZM1_DTINI) + " - " + ZM1->ZM1_HRINI,oFont12)

	oPrint:Say(nLin+120,0670,OemToAnsi('Saida'),oFont11)
	oPrint:FillRect( {nLin+175, 00665, nLin+260, 1130}, oBrushCinza )
	oPrint:Say(nLin+190,0680,DTOC(ZM1->ZM1_DTFIN) + " - " + ZM1->ZM1_HRFIN,oFont12)

	oPrint:Say(nLin+120,1200,OemToAnsi('Placa'),oFont11)
	oPrint:FillRect( {nLin+175, 1200, nLin+260, 1600}, oBrushCinza )
	oPrint:Say(nLin+190,1250,TRANSFORM(ZM1->ZM1_PLACA, PESQPICT("ZM1", "ZM1_PLACA")),oFont12)

	oPrint:Say(nLin+120,1800,OemToAnsi('Linha'),oFont11)
	oPrint:FillRect( {nLin+175, 1800, nLin+260, 2250}, oBrushCinza )
	oPrint:Say(nLin+190,1855,UPPER(ALLTRIM(ZM1->ZM1_CODLIN)),oFont12)

	//Linha 2
	oPrint:Say(nLin+270,0070,OemToAnsi('Tipo'),oFont11)
	oPrint:FillRect( {nLin+330, 0065, nLin+415, 0465}, oBrushCinza )
	oPrint:Say(nLin+340,0070,IIF(ZM1->ZM1_TIPO == "1", "DESCARGA", "CARGA"),oFont12)

	oPrint:Say(nLin+270,0670,OemToAnsi('Produto'),oFont11)
	oPrint:FillRect( {nLin+330, 0670, nLin+415, 1600}, oBrushCinza )
	oPrint:Say(nLin+340,0675,UPPER(ALLTRIM(ZM1->ZM1_DESC)),oFont12)


	//Linha 3
	oPrint:Say(nLin+420,0070,OemToAnsi('Motorista'),oFont11)
	oPrint:FillRect( {nLin+480, 0065, nLin+564, 1070}, oBrushCinza )
	oPrint:Say(nLin+490,0070,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_NOMMOT))),oFont11n)

	oPrint:Say(nLin+0600,065,OemToAnsi('Obs.'),oFont11)
	oPrint:Say(nLin+0600,165,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_OBS))),oFont11n)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณExecuta regras para composi็ใo do KG Descarteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nKgDes := 0
	nSubtot := 0
	If ZM1->ZM1_KGIDES > 0
		nKgDes := ZM1->ZM1_KGIDES - ZM1->ZM1_KGFDES
		nSubtot := ZM1->ZM1_KGINI - ZM1->ZM1_KGFDES
	EndIf

	oPrint:FillRect( {nLin+750, 0050, 1800, 2350}, oBrushCinza )
	oPrint:Box(nLin+750, 0050, 1800, 2350 )

	oPrint:Say(nLin+770,0070,OemToAnsi('DADOS DA PESAGEM'),oFont11n)

	If nKgDes > 0

		oPrint:Say(nLin+830,075,OemToAnsi('PESO ENTRADA... : '),oFont11)
		oPrint:Say(nLin+830,500,TRANSFORM((ZM1->ZM1_KGINI), PESQPICT("ZM1", "ZM1_KGINI")),oFont12)

		oPrint:Say(nLin+910,075,OemToAnsi('PESO SAIDA...  : '),oFont11)
		oPrint:Say(nLin+910,500,TRANSFORM(ZM1->ZM1_KGFDES, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		oPrint:Say(nLin+990,075,OemToAnsi('SUBTOTAL...  : '),oFont11)
		oPrint:Say(nLin+990,500,TRANSFORM(nSubtot, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		oPrint:Say(nLin+1070,075,OemToAnsi('DESCARTE...  : '),oFont11)
		oPrint:Say(nLin+1070,500,TRANSFORM(nKgDes, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		Oprint:Line(nLin+1160, 075, nLin+1160, 900)

		oPrint:Say(nLin+1170,075,OemToAnsi('PESO LIQUIDO... : '),oFont11)
		oPrint:Say(nLin+1170,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont12)

	Else

		oPrint:Say(nLin+920,075,OemToAnsi('PESO ENTRADA... : '),oFont11)
		oPrint:Say(nLin+920,500,TRANSFORM((ZM1->ZM1_KGINI), PESQPICT("ZM1", "ZM1_KGINI")),oFont12)

		oPrint:Say(nLin+1000,075,OemToAnsi('PESO SAIDA...  : '),oFont11)
		oPrint:Say(nLin+1000,500,TRANSFORM(ZM1->ZM1_KGFIN, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		Oprint:Line(nLin+1090, 075, nLin+1090, 900)

		oPrint:Say(nLin+1100,075,OemToAnsi('PESO LIQUIDO... : '),oFont11)
		oPrint:Say(nLin+1100,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont12)

	EndIf

	oPrint:Say(1760,0075,AllTrim("Ticket emitido em: "+DTOC(DATE())+" - Por: "+ __cUserID + " - " +  UPPER(ALLTRIM(FwGetUserName(__cUserID))) ),oFont08)
	oPrint:Say(1890,0050,AllTrim("    Corte aqui -------------------------------------------------------------------------------------"),oFont08)

	//segunda via

	nLin := nLin + 1500


	oPrint:FillRect( {nLin, 0050, 2690, 2350}, oBrushBranco )
	oPrint:Box(nLin, 0050, 2690, 2350 )
	//oPrint:Box (060,450,700,2420)

	oPrint:Say(nLin+0010,2100,AllTrim("Via Trelac"),oFont08)

	oPrint:Say(nLin+0020,0070,OemToAnsi('Empresa:'),oFont12)
	oPrint:Say(nLin+0020,0320,'  ( ' +ZM1->ZM1_CLIFOR+') ' + UPPER(ALLTRIM(ZM1->ZM1_NOME)),oFont12n)
	oPrint:Say(nLin+120,1800,OemToAnsi('Nบ Pesagem'),oFont11)
	oPrint:Say(nLin+175,1800,AllTrim(TransForm(UPPER(ALLTRIM(ZM1->ZM1_NUM)),'@E 999999999')),oFont18)

	//Linha 1
	oPrint:Say(nLin+120,0070,OemToAnsi('Entrada'),oFont11)
	oPrint:FillRect( {nLin+175, 0065, nLin+260, 530}, oBrushCinza )
	oPrint:Say(nLin+190,0080,DTOC(ZM1->ZM1_DTINI) + " - " + ZM1->ZM1_HRINI,oFont12)

	oPrint:Say(nLin+120,0670,OemToAnsi('Saida'),oFont11)
	oPrint:FillRect( {nLin+175, 00665, nLin+260, 1130}, oBrushCinza )
	oPrint:Say(nLin+190,0680,DTOC(ZM1->ZM1_DTFIN) + " - " + ZM1->ZM1_HRFIN,oFont12)

	oPrint:Say(nLin+120,1200,OemToAnsi('Placa'),oFont11)
	oPrint:FillRect( {nLin+175, 1200, nLin+260, 1600}, oBrushCinza )
	oPrint:Say(nLin+190,1250,TRANSFORM(ZM1->ZM1_PLACA, PESQPICT("ZM1", "ZM1_PLACA")),oFont12)

	oPrint:Say(nLin+270,1800,OemToAnsi('Linha'),oFont11)
	oPrint:FillRect( {nLin+330, 1800, nLin+415, 2250}, oBrushCinza )
	oPrint:Say(nLin+340,1855,UPPER(ALLTRIM(ZM1->ZM1_CODLIN)),oFont12)

	//Linha 2
	oPrint:Say(nLin+270,0070,OemToAnsi('Tipo'),oFont11)
	oPrint:FillRect( {nLin+330, 0065, nLin+415, 0465}, oBrushCinza )
	oPrint:Say(nLin+340,0070,IIF(ZM1->ZM1_TIPO == "1", "DESCARGA", "CARGA"),oFont12)

	oPrint:Say(nLin+270,0670,OemToAnsi('Produto'),oFont11)
	oPrint:FillRect( {nLin+330, 0670, nLin+415, 1600}, oBrushCinza )
	oPrint:Say(nLin+340,0675,UPPER(ALLTRIM(ZM1->ZM1_DESC)),oFont12)


	//Linha 3
	oPrint:Say(nLin+420,0070,OemToAnsi('Motorista'),oFont11)
	oPrint:FillRect( {nLin+480, 0065, nLin+564, 1070}, oBrushCinza )
	oPrint:Say(nLin+490,0070,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_NOMMOT))),oFont11n)

	oPrint:Say(nLin+0600,065,OemToAnsi('Obs.'),oFont11)
	oPrint:Say(nLin+0600,165,OemToAnsi(UPPER(ALLTRIM(ZM1->ZM1_OBS))),oFont11n)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณExecuta regras para composi็ใo do KG Descarteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nKgDes := 0
	nSubtot := 0
	If ZM1->ZM1_KGIDES > 0
		nKgDes := ZM1->ZM1_KGIDES - ZM1->ZM1_KGFDES
		nSubtot := ZM1->ZM1_KGINI - ZM1->ZM1_KGFDES
	EndIf


	oPrint:FillRect( {nLin+750, 0050, 3250, 2350}, oBrushCinza )
	oPrint:Box(nLin+750, 0050, 3250, 2350 )

	oPrint:Say(nLin+770,0070,OemToAnsi('DADOS DA PESAGEM'),oFont11n)

	If nKgDes > 0

		oPrint:Say(nLin+830,075,OemToAnsi('PESO ENTRADA... : '),oFont11)
		oPrint:Say(nLin+830,500,TRANSFORM((ZM1->ZM1_KGINI), PESQPICT("ZM1", "ZM1_KGINI")),oFont12)

		oPrint:Say(nLin+910,075,OemToAnsi('PESO SAIDA...  : '),oFont11)
		oPrint:Say(nLin+910,500,TRANSFORM(ZM1->ZM1_KGFDES, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		oPrint:Say(nLin+990,075,OemToAnsi('SUBTOTAL...  : '),oFont11)
		oPrint:Say(nLin+990,500,TRANSFORM(nSubtot, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		oPrint:Say(nLin+1070,075,OemToAnsi('DESCARTE...  : '),oFont11)
		oPrint:Say(nLin+1070,500,TRANSFORM(nKgDes, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		Oprint:Line(nLin+1160, 075, nLin+1160, 900)

		oPrint:Say(nLin+1170,075,OemToAnsi('PESO LIQUIDO... : '),oFont11)
		oPrint:Say(nLin+1170,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont12)

	Else

		oPrint:Say(nLin+920,075,OemToAnsi('PESO ENTRADA... : '),oFont11)
		oPrint:Say(nLin+920,500,TRANSFORM((ZM1->ZM1_KGINI + nKgDes), PESQPICT("ZM1", "ZM1_KGINI")),oFont12)

		oPrint:Say(nLin+1000,075,OemToAnsi('PESO SAIDA...  : '),oFont11)
		oPrint:Say(nLin+1000,500,TRANSFORM(ZM1->ZM1_KGFIN, PESQPICT("ZM1", "ZM1_KGFIN")),oFont12)

		Oprint:Line(nLin+1090, 075, nLin+1090, 900)

		oPrint:Say(nLin+1100,075,OemToAnsi('PESO LIQUIDO... : '),oFont11)
		oPrint:Say(nLin+1100,500,TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT")),oFont12)

	EndIf



	xRodapeB()

	xCabecB(UPPER(ALLTRIM(ZM1->ZM1_NUM)))

	oPrint:EndPage()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:Print()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xCabecB(cDocu)

	PswOrder(1)  //** Codigo Usuario
	PswSeek( AllTrim(SC7->C7_USER),.t.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oPrint:SayBitmap(020,020,_cLogo,1050,500) // Tem que estar abaixo do RootPath
	oPrint:SayBitmap(050,030,_cLogo,300,406) // Tem que estar abaixo do RootPath
	oPrint:Say(050,0450,SUBSTR(AllTrim(Upper(SM0->M0_NOMECOM)),1,48),oFont15)
	oPrint:Say(135,0450,AllTrim(SM0->M0_ENDCOB),oFont11)
	oPrint:Say(180,0450,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' +"("+Substr(SM0->M0_TEL,4,2)+") "+Substr(SM0->M0_TEL,7,4)+"-"+Substr(SM0->M0_TEL,11,4),oFont11)
	oPrint:Say(225,0450,"CNPJ: "+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99') + '  -  ' + "I.E.: "+Alltrim(SM0->M0_INSC) ,oFont11)
	oPrint:Say(265,0450,AllTrim('www.trelac.com.br'),oFont11)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:Say(0350,0450,OemToAnsi('TICKET DE PESAGEM Nบ: '),oFont18)
	oPrint:Say(0350,2100,AllTrim(TransForm(cDocu,'@E 999999999')),oFont18)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodapeB()

	//oPrint:Line(3340,0050,3340,2350)
	oPrint:Say(3250,0050,AllTrim("Ticket emitido em: "+DTOC(DATE())+" - Por: "+ __cUserID + " - " +  UPPER(ALLTRIM(FwGetUserName(__cUserID))) ),oFont08)

Return
