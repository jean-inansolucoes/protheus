#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "protheus.CH"
#Include "ap5mail.ch"
#Include "tbiconn.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"

                                                                                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                              
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CMPREMP บAutor ณAlexandre Longhinotti บ Data ณ  09/2015    บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ EMPENHO (Emissao em formato Grafico)                       บฑฑ
ฑฑ           ณ Para o Botao Imprimir na rotina documentos de entrada	  บฑฑ
ฑฑ          															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/

User Function CMPREMP(cForn, cLoja, cRazao, cDocu, cSerie, cEmissa, cValbrut, cCond, cNatureza, cDescCond)

Private nPag  		:= 0          
Private	lEnd		:= .F.
Private	cPerg		:= 'CMPREMP  '
Private _cFornece   := ""
Private _cGrup 		:= ""     
Private Cond   		:= "" 
Private _cCond 		:= ""
Private _cTpFrete  	:= ""
Private TpFrete		:= ""
Private	oPrint		:= TMSPrinter():New(OemToAnsi('NOTA DE EMPENHO'))
Private oBrush		:= TBrush():New(,4)           
Private oPen		:= TPen():New(0,5,CLR_BLACK)
Private _cLogo		:= GetSrvProfString("Startpath","") + "logo.BMP"
Private _cTDesc		:= TamSx3("C7_DESCRI")[1]
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

cQuery := "SELECT 	SE2.E2_VENCTO,  										" + hEnter
cQuery += "			SE2.E2_NATUREZ,											" + hEnter
cQuery += "			SE2.E2_VALOR 											" + hEnter
cQuery += "FROM " + RetSqlName("SE2") + " SE2								" + hEnter
cQuery += "WHERE    SE2.E2_FILIAL    = '" + xFilial("SE2") + "'				" + hEnter
cQuery += "AND		SE2.E2_PREFIXO	 =	'" + AllTrim(cSerie) + "' 			" + hEnter
cQuery += "AND		SE2.E2_NUM		 =	'" + AllTrim(cDocu) + "' 			" + hEnter
cQuery += "AND		SE2.E2_FORNECE	 =	'" + AllTrim(cForn) + "' 			" + hEnter
cQuery += "AND		SE2.E2_LOJA	 	 =	'" + AllTrim(cLoja) + "' 			" + hEnter
cQuery += "AND 		SE2.D_E_L_E_T_        != '*' 							" + hEnter

TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
While (cAliasTMP)->(!EOF())
	nPag++
	(cAliasTMP)->(dbSkip())
End do 
(cAliasTMP)->(dbGoTop())
 	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a rotina de impressao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู    


Processa({ |lEnd| xPrintRel(cForn, cRazao, cDocu, cEmissa, cAliasTMP, cCond, cNatureza, cDescCond),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))


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

Static Function xPrintRel(cForn, cRazao, cDocu, cEmissa, cAliasTMP, cCond, cNatureza, cDescCond)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:SetPortrait()
oPrint:setPaperSize(9)


nPAR := 0
While (cAliasTMP)->(!EOF())
	nPAR++
	//	For nPAR := 1 to Len(vParcela)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฟ
	//ณFornecedorณ
	//ภฤฤฤฤฤฤฤฤฤฤู
	
	oBrushBranco := TBrush():New( , Rgb(255,255,255) )
	oBrushCinza := TBrush():New( , Rgb(217,217,243) )
	
	oPrint:FillRect( {0550, 0050, 1200, 2420}, oBrushBranco )
	oPrint:Box( 0550, 0050, 1180, 2380 )
	//oPrint:Box (060,450,700,2420)
	nLin := 540
	oPrint:Say(nLin+0020,0070,OemToAnsi('Fornecedor:'),oFont12)
	oPrint:Say(nLin+0020,0320,'  ( ' +cForn+') ' + AllTrim(cRazao),oFont14)
	
	
	//Linha 1
	oPrint:Say(nLin+120,0070,OemToAnsi('Data de Emissใo'),oFont11)
	oPrint:FillRect( {nLin+175, 0065, nLin+260, 465}, oBrushCinza )
	oPrint:Say(nLin+190,0080,Dtoc(cEmissa),oFont12)
	
	oPrint:Say(nLin+120,0670,OemToAnsi('Data de Vencimento'),oFont11)
	oPrint:FillRect( {nLin+175, 00665, nLin+260, 1065}, oBrushCinza )
	oPrint:Say(nLin+190,0680,Dtoc(STOD((cAliasTMP)->E2_VENCTO)),oFont12)
	
	oPrint:Say(nLin+120,1200,OemToAnsi('Data de Pagamento'),oFont11)
	oPrint:FillRect( {nLin+175, 1200, nLin+260, 1600}, oBrushCinza )
	
	oPrint:Say(nLin+120,1900,OemToAnsi('Parcela'),oFont11)
	oPrint:FillRect( {nLin+175, 1895, nLin+260, 2295}, oBrushCinza )
	oPrint:Say(nLin+190,1950,AllTrim(TransForm(nPAR,'@E 999999999'))+'/'+AllTrim(TransForm(nPag,'@E 999999999')),oFont12)
	
	//Linha 2
	oPrint:Say(nLin+270,0070,OemToAnsi('(+) Valor da Fatura'),oFont11)
	oPrint:FillRect( {nLin+330, 0065, nLin+415, 0465}, oBrushCinza )
	oPrint:Say(nLin+340,0070,TransForm((cAliasTMP)->E2_VALOR,'@E 9,999,999.99'),oFont12)
	
	oPrint:Say(nLin+270,0670,OemToAnsi('(+) Juros'),oFont11)
	oPrint:FillRect( {nLin+330, 0670, nLin+415, 1070}, oBrushCinza )
	
	oPrint:Say(nLin+270,1200,OemToAnsi('(-) Desconto'),oFont11)
	oPrint:FillRect( {nLin+330, 1200, nLin+415, 1600}, oBrushCinza )
	
	oPrint:Say(nLin+270,1900,OemToAnsi('(=) Valor Pago'),oFont11)
	oPrint:FillRect( {nLin+330, 1900, nLin+415, 2300}, oBrushCinza )
	
	//Linha 3
	oPrint:Say(nLin+420,0070,OemToAnsi('Natureza Financeira'),oFont11)
	oPrint:FillRect( {nLin+480, 0065, nLin+564, 0465}, oBrushCinza )
	oPrint:Say(nLin+490,0080,TransForm((cAliasTMP)->E2_NATUREZ,'@E 9999999999'),oFont12)
	
	oPrint:Say(nLin+0500,00665,OemToAnsi('Obs.'),oFont11)
	oPrint:Line(nLin+0550,00665,nLin+0550,2360)
	
	//	nLinha := nLinha - 20
	oPrint:Say(nLin+585,0070,OemToAnsi('Condi็ใo Pagamento:'),oFont11)
	oPrint:Say(nLin+585,0500,OemToAnsi(cCond)+' - '+ OemToAnsi(cDescCond),oFont11n)
	//nLinha := nLinha - 20
	
	oPrint:Say(nLin+645,0070,OemToAnsi('Pagamento via Dep๓sito Bancแrio'),oFont11n)
	oPrint:FillRect( {nLin+700, 0050, nLin+860, 2420}, oBrushCinza )
	
	oPrint:Say(nLin+700,075,OemToAnsi('Banco'),oFont11)
	oPrint:FillRect( {nLin+745, 0070, nLin+830, 0270}, oBrushBranco )
	
	oPrint:Say(nLin+700,0295,OemToAnsi('Agencia'),oFont11)
	oPrint:FillRect( {nLin+745, 0290, nLin+830, 0590}, oBrushBranco )
	
	oPrint:Say(nLin+700,0615,OemToAnsi('Conta'),oFont11)
	oPrint:FillRect( {nLin+745, 0610, nLin+830, 0910}, oBrushBranco )
	
	oPrint:Say(nLin+700,0935,OemToAnsi('Em nome de'),oFont11)
	oPrint:FillRect( {nLin+745, 0930, nLin+830, 1880}, oBrushBranco )
	
	oPrint:Say(nLin+700,1905,OemToAnsi('CPF/CNPJ nบ'),oFont11)
	oPrint:FillRect( {nLin+745, 1900, nLin+830, 2370}, oBrushBranco )
	
	//	nLinha := nLinha - 70
	
	oPrint:Say(nLin+860,0070,OemToAnsi('Pagamento via Cheque Avista ou Cheque Pr้ Datado'),oFont11n)
	oPrint:FillRect( {nLin+920, 0050, nLin+1080, 2420}, oBrushCinza )
	
	oPrint:Say(nLin+920,075,OemToAnsi('Banco'),oFont11)
	oPrint:FillRect( {nLin+965, 0070, nLin+1050, 0270}, oBrushBranco )
	
	oPrint:Say(nLin+920,0295,OemToAnsi('Agencia'),oFont11)
	oPrint:FillRect( {nLin+965, 0290, nLin+1050, 0590}, oBrushBranco )
	
	oPrint:Say(nLin+920,0615,OemToAnsi('Conta'),oFont11)
	oPrint:FillRect( {nLin+965, 0610, nLin+1050, 0910}, oBrushBranco )
	
	oPrint:Say(nLin+920,0935,OemToAnsi('Parc'),oFont11)
	oPrint:FillRect( {nLin+965, 0930, nLin+1050, 1030}, oBrushBranco )
	
	oPrint:Say(nLin+920,1055,OemToAnsi('Cheque nบ'),oFont11)
	oPrint:FillRect( {nLin+965, 1050, nLin+1050, 1350}, oBrushBranco )
	
	oPrint:Say(nLin+920,1375,OemToAnsi('Vencimento'),oFont11)
	oPrint:FillRect( {nLin+965, 1370, nLin+1050, 1670}, oBrushBranco )
	
	oPrint:Say(nLin+920,1695,OemToAnsi('Valor da Parcela'),oFont11)
	oPrint:FillRect( {nLin+965, 1690, nLin+1050, 2060}, oBrushBranco )
	//		nLinha := nLinha - 40
	oPrint:Say(nLin+1110,0070,OemToAnsi('Em caso de pagamento em mใos, ou seja, na aus๊ncia de Boleto ou Dep๓sito Identificado preencher o presente recibo.'),oFont10n)
	oPrint:Box(nLin+1170, 0050, 2270, 2380 )
	oPrint:Say(nLin+1180,0070,OemToAnsi('RECIBO'),oFont12)
	oPrint:Say(nLin+1240,0070,OemToAnsi('Declaro(amos) ter recebido de TRES BARRAS IND. DE LมCTEOS DO BRASIL LTDA, pessoa Jurํdica de direito privado, inscrita no CNPJ sob nบ .'),oFont10)
	oPrint:Say(nLin+1300,0070,OemToAnsi('05.341.357/0001-57, situada na Rua JK, 1016, Jardim Guarani, Tr๊s Barras do Paranแ - PR, CEP 85485-000, os valores constantes desta'),oFont10)
	oPrint:Say(nLin+1360,0070,OemToAnsi('Nota de Empenho, de acordo com Nota Fiscal emitida, e para maior clareza firmo o presente recibo para que produza o seu efeito, dando '),oFont10)
	oPrint:Say(nLin+1420,0070,OemToAnsi('plena, rasa e irrevogแvel quita็ใo, pelo valor recebido.'),oFont10)
	oPrint:Say(nLin+1480,0070,OemToAnsi('Tr๊s Barras do Paranแ, em ___/___/___'),oFont10)
	oPrint:Say(nLin+1600,0070,OemToAnsi('_______________________________________        __________________________________        _______________________________'),oFont10)
	oPrint:Say(nLin+1660,0410,OemToAnsi('NOME'),oFont10)
	oPrint:Say(nLin+1660,1250,OemToAnsi('CPF'),oFont10)
	oPrint:Say(nLin+1660,1930,OemToAnsi('ASSINATURA'),oFont10)
	
	oPrint:Box(nLin+1750, 0050, 3200, 2380 )
	oPrint:Say(nLin+2200,1000,OemToAnsi('Cole aqui a c๓pia do cheque'),oFont08)
	
	
	xRodape()
	
	xCabec(cDocu)
	
	oPrint:EndPage()
	
	If nPar < nPag
		oPrint:StartPage()
	EndIf
	 (cAliasTMP)->(dbSkip())
End do
(cAliasTMP)->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPrint:Preview()


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

PswOrder(1)  //** Codigo Usuario
PswSeek( AllTrim(SC7->C7_USER),.t.) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oPrint:SayBitmap(020,020,_cLogo,1050,500) // Tem que estar abaixo do RootPath
oPrint:SayBitmap(050,030,_cLogo,300,406) // Tem que estar abaixo do RootPath
oPrint:Say(050,0450,SUBSTR(AllTrim(Upper(SM0->M0_NOMECOM)),1,36),oFont15)
oPrint:Say(135,0450,AllTrim(SM0->M0_ENDCOB),oFont11)
oPrint:Say(180,0450,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' +"("+Substr(SM0->M0_TEL,4,2)+") "+Substr(SM0->M0_TEL,7,4)+"-"+Substr(SM0->M0_TEL,11,4),oFont11)
oPrint:Say(225,0450,"CNPJ: "+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99') + '  -  ' + "I.E.: "+Alltrim(SM0->M0_INSC) ,oFont11)
oPrint:Say(265,0450,AllTrim('www.laticiniosilvestre.com.br'),oFont11)
oPrint:Say(315,0450,"DEPARTAMENTO FINANCEIRO/CONTมBIL",oFont15)
oPrint:Line(385,0450,385,2400)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(0410,0450,OemToAnsi('NOTA DE EMPENHO Nบ: '),oFont22)
oPrint:Say(0410,1780,AllTrim(TransForm(cDocu,'@E 999999999')),oFont22) 
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

oPrint:Say(3290,0300,OemToAnsi('Visto Contabilidade'),oFont08)
oPrint:Say(3290,1100,OemToAnsi('Visto Financeiro'),oFont08)
oPrint:Say(3290,1800,OemToAnsi('Visto Gerencia'),oFont08)                                 
oPrint:Line(3340,0050,3340,2360)
oPrint:Say(3350,0050,AllTrim("Empenho emitido em: "+DTOC(DATE())+" - Por: "+ __cUserID + " - " + CUSERNAME + " - Doc Entrada"),oFont08)

Return

