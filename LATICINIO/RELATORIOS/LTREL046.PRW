#include "protheus.ch"
#include "topconn.ch"
#include "colors.ch"

#define PAD_LEFT     0
#define PAD_RIGHT    1
#define PAD_CENTER   2
#define PAD_TOP      3
#define PAD_BOTTOM   4
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ LTREL046 บAutor  ณFSW TOTVS CASCAVEL   บ Data ณ 16/09/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescricao ณ Relat๓rio para impressใo de Protocolo de Nใo Conformidade  ณฑฑ
ฑฑณ          ณ Relat๓rio Grแfico utilizando TREPORT.                      ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Resultar                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTREL046()

	Local i
	Private oReport
	Private cPerg		:= ""
	Private aTmpFiles	:= {}
	Private nIdioma 	:= 1
    Private _cProt  	:= ZM8->ZM8_IDPROT
    Private _cPesagem   := ZM8->ZM8_NUM
    Private _cProd      := ''
    Private _cPlaca     := ''
    Private _cForn      := ''
    Private _dPesag     := SToD('')

    DbSelectArea("ZM1")
    ZM1->(dbSetOrder(1))
    ZM1->(dbGoTop())
    If !ZM1->(dbSeek(xFilial("ZM1")+_cPesagem))
        MsgAlert("Nใo foi possํvel localizar a pesagem " + _cPesagem + " na tabela ZM1.")
        Return
    EndIf

    _cProd := ZM1->ZM1_DESC
    _cPlaca := ZM1->ZM1_PLACA
    _cForn := ZM1->ZM1_NOME
    _dPesag := ZM1->ZM1_DATA

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefine a estrutura do relat๓rio     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oReport := ReportDef()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณCarrega a interface do relat๓rio    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oReport:PrintDialog()
	oReport := nil

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณ Exclui arquivos temporแrios das imagens           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	For i := 1 to Len(aTmpFiles)
		If File(aTmpFiles[i])
			FErase(aTmpFiles[i])
		Endif
	Next i

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณFSW Totvs Cascavel   บ Data ณ 26/09/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para defini็ใo e configura็ใo do layout do relat๓rio บฑฑ
ฑฑบ          ณchamada antes de mostrar a tela interface.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FSW Totvs Cascavel                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

	Local cNomeRel	:= "LTREL046"
	Local cTitulo 	:= "IMPRESSรO DE PROTOCOLO"
	Local cDescri 	:= "Este relat๓rio tem por objetivo imprimir o Protocolo de Nใo Conformidade."
	Local aOrdem 		:= {}
	Local oSection1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine op็๕es de Ordena็ใo dos registros         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd( aOrdem, "" )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria o componente de impressao                                          ณ
	//ณTReport():New                                                           ณ
	//ณExpC1 : Nome do relatorio                                               ณ
	//ณExpC2 : Titulo do relatorio                                             ณ
	//ณExpC3 : Perguntas SX1                                                   ณ
	//ณExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ณ
	//ณExpC5 : Descricao do objetivo do relatorio                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport := TReport():New(cNomeRel,cTitulo,cPerg, {|oReport| ReportPrint(oReport)},cDescri)
	oReport:SetPortrait()			// Define orienta็ใo da pแgina modo Retrato
	oReport:HideHeader()				// Oculta a impressใo do cabecalho do relatorio
	//oReport:SetPageFooter(1,{|| oReport:Say( oReport:Row(), oReport:Col() + nDesloc,"Pแg: "+cValToChar(oReport:Page()), oFntTit3,,,,PAD_LEFT )})				// Oculta a impressใo do cabecalho do relatorio
	//oReport:PrintHeader(.F.,.T.)
	oReport:HideFooter()
	oReport:HideParamPage()			// Oculta a impressใo da pแgina de parโmetros
	oReport:DisableOrientation()	// Inibe que o usuแrio altere o formato Retrato/Paisagem
	oReport:oPage:nPaperSize := 9 	// Define o tamanho da pแgina para A4
	oReport:nFontBody := 9			// Ajusta o tamanho da fonte padrใo do relat๓rio
	oReport:nLineHeight := 50		// Ajusta a altura da linha de impressใo (pixel)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria o objeto de Se็ใo do relat๓rio                                     ณ
	//ณTRSection():New                                                         ณ
	//ณExpO1 : Objeto TReport que a secao pertence                             ณ
	//ณExpC2 : Descricao da secao                                              ณ
	//ณExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ณ
	//ณ        sera considerada como principal para a se็ใo.                   ณ
	//ณExpA4 : Array com as Ordens do relat๓rio                                ณ
	//ณExpL5 : Carrega campos do SX3 como celulas                              ณ
	//ณ        Default : False                                                 ณ
	//ณExpL6 : Carrega ordens do Sindex                                        ณ
	//ณ        Default : False                                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSection1 := TRSection():New(oReport,"Protocolo de Nใo Conformidade",{},aOrdem)

Return(oReport)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrinบAutor  ณFSW Totvs Cascavel   บ Data ณ 26/09/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para processamento e controle da impressใo do        บฑฑ
ฑฑบ          ณrelat๓rio, chamada ao confirmar a impressใo.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FSW Totvs Cascavel                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport)

	Local lRet 		:= .T.
	Local nTotReg 	:= 0	// Total de registros da Query
    Local i

	Private nLargura  	:= 0	// Largura do quadro em Pixel
	Private nAltura   	:= 0	// Altura  do quadro em Pixel
	Private nAltQuadro	:= 50	// Altura padrใo dos quadros em Pixel
	Private nDesloc   	:= 150	// Deslocamento horizontal em Pixel
	Private nLinQuebra 	:= 0	// Altura limite para quebrar a pแgina
	Private cBmpLogo  	:= "lgmid01.png"
	Private nLogoW  	:= 220 //110 * 3.5
	Private nLogoH  	:= 220 //110 * 3.5
	Private nBmpWidth 	:= nil
	Private nBmpHeight	:= nil
	Private cAliasTMP 	:= ""
	Private aObsTec   	:= {}

	Private lBold		:= .T.
	Private lItalic	:= .T.
	Private oFntTit1 	:= TFont():New("Verdana"    ,,09,, lBold,,,,,.F. )
	Private oFntTit2 	:= TFont():New("Verdana"    ,,10,, lBold,,,,,.F. )
	Private oFntTit3 	:= TFont():New("Verdana"    ,,12,, lBold,,,,,.F. )
	Private oFntTit4 	:= TFont():New("Verdana"    ,,10,, lBold,,,,,.T. )
	Private oFntTit5 	:= TFont():New("Courier New",,09,, lBold,,,,,.F. )
	Private oFntCel1 	:= TFont():New("Verdana"    ,,09,,!lBold,,,,,.F. )
	Private oFntCel2 	:= TFont():New("Verdana"    ,,10,,!lBold,,,,,.F. )
	Private oFntCel3 	:= TFont():New("Courier New",,10,,!lBold,,,,,.F. )
	Private oFntCel4 	:= TFont():New("Courier New",,09,,!lBold,,,,,.F. )

	Private nCorFundo	:= CLR_HGRAY

	Private oQCabec 	:= nil	// Quadro cabe็alho da pแgina
	Private oQCliente	:= nil	// Quadro dados do Cliente/Prospect
	Private oQCondPag	:= nil	// Quadro dados da Condi็ใo Pagamneto
	Private oQCabItem	:= nil	// Quadro cabe็alho do Item
	Private oQCabItemX	:= nil	// Quadro cabe็alho do Item (exporta็ใo)
	Private oQDetItem	:= nil	// Quadro dados do Item
	Private oQDetItemX	:= nil	// Quadro dados do Item (exporta็ใo)
	Private oQImgItem	:= nil	// Quadro detalhes/imagem do Item
	Private oQTotais	:= nil	// Quadro totais do or็amento
	Private oQTotGer	:= nil	// Quadro totais do or็amento
	Private cTextoTotal:= ""
	Private cValorTotal:= ""

	Private _nPag	:= 1

	
    nTotReg := 20
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณAjusta a r้gua de processamento do relat๓rio       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	COUNT TO nTotReg
	oReport:SetMeter(nTotReg)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefine altura limite para quebrar a pแgina (pixel) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nLinQuebra := oReport:PageHeight() - 100

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefine a Largura padrใo para os quadros (pixel)    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nLargura := oReport:PageWidth() - 150


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefine o quadro CABEวALHO                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nAltura := nAltQuadro*5
	oQCabec := FSTRQuadro():New(oReport,nLargura,nAltura)
	oQCabec:SetBorder(.F.)

	oSubQ0  := oQCabec:AddColPerc(6.5)
	oSubQ1  := oQCabec:AddColPerc(13.5)
	oSubQ1:SetBitmap(cBmpLogo,nLogoW,nLogoH)

	oSubQ2  := oQCabec:AddColPerc(72)
	oSubQ2:AddRow(nAltQuadro, {|| AllTrim(Upper(SM0->M0_NOMECOM))                           }, oFntTit3)
	oSubQ2:AddRow(nAltQuadro, {|| "CNPJ: "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")  }, oFntCel2)
	oSubQ2:AddRow(nAltQuadro, {|| "Endere็o : "+ UPPER( AllTrim(SM0->M0_ENDCOB) +" "+ Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ "  CEP: "+ AllTrim(Transform(SM0->M0_CEPCOB,"@R 99.999-999")) ) }, oFntCel2)
	oSubQ2:AddRow(nAltQuadro, {|| "Telefone: "+AllTrim(Transform(StrTran(SM0->M0_TEL,'-',''),"@R (99) 9999-9999")) }, oFntCel2)
	oSubQ2:AddRow(nAltQuadro, {|| "www.tresbarras.ind.br" }, oFntCel2)

	oSubQ3  := oQCabec:AddColPerc(8)
	oSubQ3:AddRow(nAltQuadro, {|| "Pแg: " + cvaltochar(oReport:Page()) }, oFntCel2,PAD_RIGHT)

	nAltura := nAltQuadro
	oQProt := FSTRQuadro():New(oReport,nLargura-nDesloc,nAltura)
	oQProt:SetBorder(.F.)
	oSubQ1  := oQProt:AddColPerc(100)
	oSubQ1:AddRow(nAltQuadro,{|| "PLANO DE AวรO - NรO CONFORMIDADE RECEBIMENTO MATษRIA PRIMA"   },oFntTit3,PAD_CENTER)


    // Quadro Anแlise do Laborat๓rio
    nAltura := nAltQuadro*1.3
    oQCabLab := FSTRQuadro():New(oReport,nLargura-nDesloc,nAltura)
	oQCabLab:SetBorder(.T.)
    oQCabLab:SetShadow(.T.)
    oObs1  := oQCabLab:AddRow(nAltQuadro*1.3,,,PAD_CENTER)
	oObs1:AddColPerc(100, {|| 'ANมLISE LABORATำRIO' }, oFntTit2,,/* CLR_HGRAY */)
    //oObs1:SetBackColor(CLR_HGRAY)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefine o quadro Cabe็alho das Despesas             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	nAltura := nAltQuadro*5 // Movimento por Produtor tem uma linha a mais
	oQLab := FSTRQuadro():New(oReport,nLargura-nDesloc,nAltura)
	oQLab:SetBorder(.F.)
    
	
	oObs1  := oQLab:AddRow(nAltQuadro,,,PAD_LEFT)
	oObs1:AddColPerc(15, {|| 'Nบ Protocolo: ' }, oFntTit2)
	oObs1:AddColPerc(18, {||  _cProt  }, oFntCel2)
	oObs1:AddColPerc(15, {|| 'Nบ Pesagem:'  }, oFntTit2)
	oObs1:AddColPerc(35, {|| _cPesagem }, oFntCel2)
	//oObs1:SetBackColor(CLR_HGRAY)

    oObs2  := oQLab:AddRow(nAltQuadro,,,PAD_LEFT)
	oObs2:AddColPerc(15, {|| 'Data Pesagem:' }, oFntTit2)
	oObs2:AddColPerc(18, {|| dToC(_dPesag) }, oFntCel2)
	oObs2:AddColPerc(18, {|| 'Data Abertura RNC:' }, oFntTit2)
	oObs2:AddColPerc(15, {|| dToC(ZM8->ZM8_DTQLD) }, oFntCel2)
	oObs2:AddColPerc(18, {|| 'Prazo Resposta:' }, oFntTit2)
	oObs2:AddColPerc(15, {|| '' }, oFntCel2)

	oObs3  := oQLab:AddRow(nAltQuadro,,,PAD_LEFT)
	oObs3:AddColPerc(15, {|| 'Mat้ria Prima: ' }, oFntTit2)
    oObs3:AddColPerc(85, {|| AllTrim(_cProd) }, oFntCel2)

    oObs4  := oQLab:AddRow(nAltQuadro,,,PAD_LEFT)
    If ZM8->ZM8_TPMOV == 'F'
        oObs4:AddColPerc(15, {|| 'Fornecedor: ' }, oFntTit2)
        oObs4:AddColPerc(50, {|| AllTrim(_cForn) }, oFntCel2)
        oObs4:AddColPerc(15, {|| 'Placa: ' }, oFntTit2)
        oObs4:AddColPerc(20, {|| AllTrim(_cPlaca) }, oFntCel2)
    Else
        oObs4:AddColPerc(15, {|| 'Placa: ' }, oFntTit2)
        oObs4:AddColPerc(20, {|| AllTrim(_cPlaca) }, oFntCel2)
    EndIf

    oObs5  := oQLab:AddRow(nAltQuadro,,,PAD_LEFT)
	oObs5:AddColPerc(100, {|| 'Descri็ใo Resumida do Problema: ' }, oFntTit2)
    // Fim Quadro Anแlise do Laborat๓rio

    
    // Quadro Anแlise do Fornecedor ou Anแlise da Capta็ใo
    nAltura := nAltQuadro*1.3
    oQCabFor := FSTRQuadro():New(oReport,nLargura-nDesloc,nAltura)
	oQCabFor:SetBorder(.T.)
    oQCabFor:SetShadow(.T.)
    oObs1  := oQCabFor:AddRow(nAltQuadro*1.3,,,PAD_CENTER)
	oObs1:AddColPerc(100, {|| 'ANมLISE ' + IIF(ZM8->ZM8_TPMOV=='F','FORNECEDOR','CAPTAวรO') }, oFntTit2,,/* CLR_HGRAY */)


    nAltura := nAltQuadro*IIF(ZM8->ZM8_TPMOV=='F',2,3) // MOVIMENTO POR PRODUTOR TEM UMA LINHA A MAIS
    oQFor := FSTRQuadro():New(oReport,nLargura-nDesloc,nAltura)
	oQFor:SetBorder(.F.)    
	
    If ZM8->ZM8_TPMOV=='P'
        oObs0  := oQFor:AddRow(nAltQuadro,,,PAD_LEFT)
        oObs0:AddColPerc(15, {|| 'Produtor: ' }, oFntTit2)
        oObs0:AddColPerc(50, {||  AllTrim(ZM9->ZM9_NOME)  }, oFntCel2)
    EndIf

	oObs1  := oQFor:AddRow(nAltQuadro,,,PAD_LEFT)
	oObs1:AddColPerc(15, {|| 'Anแlise: ' }, oFntTit2)
	oObs1:AddColPerc(18, {||  AllTrim(ZM9->ZM9_DESCR)  }, oFntCel2)
	oObs1:AddColPerc(15, {|| 'Tanque:'  }, oFntTit2)
	oObs1:AddColPerc(18, {|| ZM9->ZM9_TANQUE }, oFntCel2)
	oObs1:AddColPerc(15, {|| 'Rela็ใo:' }, oFntTit2)
	oObs1:AddColPerc(18, {|| _cRelacao }, oFntCel2)
	//oObs1:SetBackColor(CLR_HGRAY)

    oObs2  := oQFor:AddRow(nAltQuadro,,,PAD_LEFT)
	oObs2:AddColPerc(15, {|| 'Responsแvel:' }, oFntTit2)
	oObs2:AddColPerc(18, {|| ZM9->ZM9_RESP }, oFntCel2)
	oObs2:AddColPerc(15, {|| 'Data:' }, oFntTit2)
	oObs2:AddColPerc(18, {|| dToC(ZM9->ZM9_DTINVE) }, oFntCel2)
    oObs2:AddColPerc(15, {|| 'Prazo Implement.:' }, oFntTit2)
	oObs2:AddColPerc(18, {|| dToC(ZM9->ZM9_PRAZO) }, oFntCel2)
	// FIM Quadro Anแlise do Fornecedor ou Anแlise da Capta็ใo



    // Quadro Anแlise da Qualidade
    nAltura := nAltQuadro*1.3
    oQCabQld := FSTRQuadro():New(oReport,nLargura-nDesloc,nAltura)
	oQCabQld:SetBorder(.T.)
    oQCabQld:SetShadow(.T.)
    oObs1  := oQCabQld:AddRow(nAltQuadro*1.3,,,PAD_CENTER)
	oObs1:AddColPerc(100, {|| 'ANมLISE QUALIDADE'}, oFntTit2,,/* CLR_HGRAY */)


    nAltura := nAltQuadro // MOVIMENTO POR PRODUTOR TEM UMA LINHA A MAIS
    oQQld := FSTRQuadro():New(oReport,nLargura-nDesloc,nAltura)
	oQQld:SetBorder(.F.)    
	

	oObs1  := oQQld:AddRow(nAltQuadro,,,PAD_LEFT)
	oObs1:AddColPerc(15, {|| 'Avalia็ใo RNC: ' }, oFntTit2)
	oObs1:AddColPerc(18, {||  IIF(EMPTY(ZM8->ZM8_AVAL),"Nใo Realizada",IIF(ZM8->ZM8_AVAL=="A","Aceita","Nใo Aceita"))  }, oFntCel2)
	oObs1:AddColPerc(15, {|| 'Data Avalia็ใo:'  }, oFntTit2)
	oObs1:AddColPerc(18, {|| ZM8->ZM8_DTAVAL }, oFntCel2)
	oObs1:AddColPerc(23, {|| 'Dt. RNC Devolv. Capta็ใo:' }, oFntTit2)
	oObs1:AddColPerc(10, {|| ZM8->ZM8_DTAVAL }, oFntCel2)
    
    // Fim Quadro Anแlise da Qualidade

    /*  */
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณProcessa a impressใo do relat๓rio          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Trata campo memo com quebra de linha           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cImpOpcPag := ""
	nTamLin := 100	// Tamanho da linha descri็ใo em caracteres

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณ Inicializa Pแgina e imprime cabe็alho      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	fStartPage(oReport)

    oQProt:Print( oReport:Row(), oReport:Col() + nDesloc )
    oReport:IncRow(oQProt:nHeight)
	
	oReport:Line( oReport:Row(), oReport:Col() + nDesloc, oReport:Row(), nLargura )
	oReport:IncRow()

    oQCabLab:Print( oReport:Row(), oReport:Col() + nDesloc )
    oReport:IncRow(oQCabLab:nHeight*1.5)

    oQLab:Print( oReport:Row(), oReport:Col() + nDesloc )
    oReport:IncRow(oQLab:nHeight)

    nTamLin := 125	// Tamanho da linha descri็ใo em caracteres
    aDesc := QuebraLin(Alltrim(ZM8->ZM8_DESCR), nTamLin)
    For i := 1 to Len(aDesc)
        If oReport:Row() > nLinQuebra - 150
            oReport:EndPage(.T.)
            fStartPage(oReport)
            nLinFIM := oReport:Row()
        Endif
        oReport:Say( oReport:Row(), oReport:Col() + nDesloc, Alltrim(aDesc[i]), oFntCel3,,,,PAD_LEFT )
        oReport:IncRow()
    Next i
    aDesc := nil

	
	//oReport:Line( oReport:Row(), oReport:Col() + nDesloc, oReport:Row(), nLargura )
	oReport:IncRow()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Imprime Quadro da Assinatura                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oReport:Row() > nLinQuebra - 150
		oReport:EndPage(.T.)
		fStartPage(oReport)
		nLinFIM := oReport:Row()
	Endif

    oQCabFor:Print( oReport:Row(), oReport:Col() + nDesloc )
    oReport:IncRow(oQCabFor:nHeight*1.5)

    __nQtdReg := 0

    DbSelectArea("ZM9")
    ZM9->(dbSetOrder(1))
    ZM9->(dbGoTop())
    ZM9->(dbSeek(xFilial('ZM9')+_cPesagem))
    While !ZM9->(EOF()) .AND. ZM9->(ZM9_FILIAL+ZM9_NUM) == xFilial('ZM9')+_cPesagem
        __nQtdReg++    
        If ZM9->ZM9_RELAC == '1'
            _cRelacao:= 'Mแquina'
        ElseIf ZM9->ZM9_RELAC == '2'
            _cRelacao := 'Mใo-de-Obra'
        ElseIf ZM9->ZM9_RELAC == '3'
            _cRelacao:= 'M้todo'
        ElseIf ZM9->ZM9_RELAC == '4'
            _cRelacao:= 'Material '
        EndIf

        If __nQtdReg > 1
            oReport:IncRow()
            oReport:Line( oReport:Row(), oReport:Col() + nDesloc, oReport:Row(), nLargura )
            oReport:IncRow()
        EndIf

        oQFor:Print( oReport:Row(), oReport:Col() + nDesloc )
        oReport:IncRow(oQFor:nHeight)
        
        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Imprime Quadro da Assinatura                   ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        If oReport:Row() > nLinQuebra - 150
            oReport:EndPage(.T.)
            fStartPage(oReport)
            nLinFIM := oReport:Row()
        Endif

        oReport:Say( oReport:Row(), oReport:Col() + nDesloc, "Motivo:", oFntTit2,,,,PAD_LEFT )
        oReport:IncRow()
        nTamLin := 125	// Tamanho da linha descri็ใo em caracteres
        aDesc := QuebraLin(Alltrim(ZM9->ZM9_MOTIVO), nTamLin)
        For i := 1 to Len(aDesc)
            If oReport:Row() > nLinQuebra - 150
                oReport:EndPage(.T.)
                fStartPage(oReport)
                nLinFIM := oReport:Row()
            Endif
            oReport:Say( oReport:Row(), oReport:Col() + nDesloc, Alltrim(aDesc[i]), oFntCel3,,,,PAD_LEFT )
            oReport:IncRow()
        Next i
        aDesc := nil
        oReport:IncRow()

        oReport:Say( oReport:Row(), oReport:Col() + nDesloc, "Causa Raiz:", oFntTit2,,,,PAD_LEFT )
        oReport:IncRow()
        nTamLin := 125	// Tamanho da linha descri็ใo em caracteres
        aDesc := QuebraLin(Alltrim(ZM9->ZM9_CAUSA), nTamLin)
        For i := 1 to Len(aDesc)
            If oReport:Row() > nLinQuebra - 150
                oReport:EndPage(.T.)
                fStartPage(oReport)
                nLinFIM := oReport:Row()
            Endif
            oReport:Say( oReport:Row(), oReport:Col() + nDesloc, Alltrim(aDesc[i]), oFntCel3,,,,PAD_LEFT )
            oReport:IncRow()
        Next i
        aDesc := nil
        oReport:IncRow()

        oReport:Say( oReport:Row(), oReport:Col() + nDesloc, "A็๕es Corretivas:", oFntTit2,,,,PAD_LEFT )
        oReport:IncRow()
        nTamLin := 125	// Tamanho da linha descri็ใo em caracteres
        aDesc := QuebraLin(Alltrim(ZM9->ZM9_ACOES), nTamLin)
        For i := 1 to Len(aDesc)
            If oReport:Row() > nLinQuebra - 150
                oReport:EndPage(.T.)
                fStartPage(oReport)
                nLinFIM := oReport:Row()
            Endif
            oReport:Say( oReport:Row(), oReport:Col() + nDesloc, Alltrim(aDesc[i]), oFntCel3,,,,PAD_LEFT )
            oReport:IncRow()
        Next i
        aDesc := nil
        ZM9->(dbSkip())
    EndDo

    oReport:IncRow()

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Imprime Quadro da Assinatura                   ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    If oReport:Row() > nLinQuebra - 150
        oReport:EndPage(.T.)
        fStartPage(oReport)
        nLinFIM := oReport:Row()
    Endif

    oQCabQld:Print( oReport:Row(), oReport:Col() + nDesloc )
    oReport:IncRow(oQCabQld:nHeight*1.5)
    
    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Imprime Quadro da Assinatura                   ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    If oReport:Row() > nLinQuebra - 150
        oReport:EndPage(.T.)
        fStartPage(oReport)
        nLinFIM := oReport:Row()
    Endif
    
    oQQld:Print( oReport:Row(), oReport:Col() + nDesloc )
    oReport:IncRow(oQQld:nHeight)

    If ZM8->ZM8_AVAL == 'N'
        oReport:Say( oReport:Row(), oReport:Col() + nDesloc, "Motivo nใo aceite:", oFntTit2,,,,PAD_LEFT )
        oReport:IncRow()
        
        nTamLin := 125	// Tamanho da linha descri็ใo em caracteres
        aDesc := QuebraLin(Alltrim(ZM8->ZM8_MOTNAO), nTamLin)
        For i := 1 to Len(aDesc)
            If oReport:Row() > nLinQuebra - 150
                oReport:EndPage(.T.)
                fStartPage(oReport)
                nLinFIM := oReport:Row()
            Endif
            oReport:Say( oReport:Row(), oReport:Col() + nDesloc, Alltrim(aDesc[i]), oFntCel3,,,,PAD_LEFT )
            oReport:IncRow()
        Next i
        aDesc := nil
    EndIf



	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณ Libera mem๓ria dos objetos criados                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	FreeObj(oQCabec)
	FreeObj(oQProt)


	oQCabec    	:= nil
	oQCliente  	:= nil
	oQProt  		:= nil
	oQProt2		:= nil
	oQProt3		:= nil
	oQProt4		:= nil

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณfStartPageบAutor  ณTotvs Cascavel       บ Data ณ 04/10/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para iniciar posicionamento a cada nova pแgina e     บฑฑ
ฑฑบ          ณimprimir imagem de fundo estilo marca d'แgua.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTotvs Cascavel                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fStartPage(oReport)

    oReport:PrintText("")

	oQCabec:Print( oReport:Row(), oReport:Col() )
	oReport:IncRow(oQCabec:nHeight)
	oReport:IncRow()
	oReport:Line( oReport:Row(), oReport:Col() + nDesloc, oReport:Row(), nLargura )


Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QuebraLinบAutor ณ TOTVS Cascavel      บ Data ณ  02/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recebe uma variavel de Texto e retorna um Array contendo   บฑฑ
ฑฑบ          ณ as linhas quebradas conforme a quantidade limite de        บฑฑ
ฑฑบ          ณ caracteres por linha passada. Efetua Quebra de Palavras.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral                                                      บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QuebraLin(cTexto,nTamLin)

Local nTabSize	:= 3
Local lWrap		:= .T.
Local nLines		:= 0
Local cAux 		:= ""
Local aRet 		:= {}
Local nCurrentLine := 0

cTexto := AllTrim(ConvMemo(cTexto))
nLines := MLCOUNT(cTexto, nTamLin)

For nCurrentLine := 1 to nLines
	cAux := MEMOLINE(cTexto, nTamLin, nCurrentLine)
	aAdd(aRet, cAux)
Next

Return(aRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณConvMemo  บAutor  ณTotvs Cascavel       บ Data ณ 04/10/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para converter caracteres de final de linha de um    บฑฑ
ฑฑบ          ณcampo texto, conforme codifica็ใo UNIX (LF) / DOS (CRLF)    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTotvs Cascavel                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ConvMemo(cMemo)

// Verifica se o texto origem possui uma sequencia caracter CRLF
// Se tiver jแ estแ correto, senใo converte o texto
If At(chr(13)+chr(10), cMemo) == 0
	cMemo := StrTran(cMemo, chr(10), chr(13)+chr(10))
Endif

Return(cMemo)

