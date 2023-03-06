#include "TOTVS.CH"
#include "FWPRINTSETUP.CH"
#include "RPTDEF.CH"
#include "TOPCONN.CH"


/*----------------------------------------------------------------------------------------------------
{Protheus.doc} Informe
Informe de rendimetnos do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/

user function LTREL034()

private cPerg		:= "LTREL00034"
private nPOSCOL		:= 6
private DATE_NULL	:= ctod("  /  /    ")
private STRING_NULL	:= ""

private lExecjob	:= (alltrim(upper(funname()))$alltrim("RPC/WEBSERVICES"))

conout(time()+"-------------LTREL034-------------- start")

private oPrinter
AjustaSX1()
pergunte(cPerg, .F.)
if lExecjob
	private cPath := "\spool\pdf\"
	private cFile := "informe"+cvaltochar(ThreadID())+dtos(date())+strtran(time(),":","")+".pdf"
	private cFilJob := paramixb[1]
	private cCodJob := paramixb[2]
	private cLojJob := paramixb[3]
	private nMesJob := paramixb[4]
	private nAnoJob := paramixb[5] 
	private nMes2Job := paramixb[6]
	private nAno2Job := paramixb[7]
	oPrinter := FWMSPrinter():New(cFile, IMP_PDF, .T., cPath, .T.,,,, .T.,,, .F.)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(40,40,40,40)
	oPrinter:cPathPDF := cPath
	Printreport()
	return (cPath+cFile)
else
	if pergunte(cPerg, .T.)
		oPrinter := FWMSPrinter():New("informe", IMP_SPOOL)
		oPrinter:SetPaperSize(DMPAPER_A4)
		oPrinter:SetMargin(40,40,40,40)
		oPrinter:SetPortrait()
		Printreport()
	endif
endif


return



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} Printreport
Demonstrativo de pagamento do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function Printreport()

local cPRODUT      := ""				// código do produtor
local cAliasTMP    := GetnextAlias()
local hEnter	   := CHR(10) + CHR(13)
local lSTART_DATE  := .F.
local lEND_DATE    := .F.
local aDADOSIMP    := {}
private nPag 		:= 0
private nLin 		:= 0
private nCol 		:= 0
private oFont14CN  := TFont():New("Courier new",,16)
private oFont14CNb := TFont():New("Arial",,16)
private oFont12CN  := TFont():New("Courier new",,12)
private oFont16CI  := TFont():New("Courier new",,16,,,,,,,,.T.)
private oFont16BD  := TFontEx():New(oPrinter,"Arial",16,16,.T.,.T.,.F.)
private oFont16    := TFontEx():New(oPrinter,"Arial",16,16,.F.,.T.,.F.)
private oFont14BD  := TFontEx():New(oPrinter,"Arial",14,14,.T.,.T.,.F.)
private oFont14    := TFontEx():New(oPrinter,"Arial",14,14,.F.,.T.,.F.)
private oFont12    := TFontEx():New(oPrinter,"Arial",12,12,.F.,.T.,.F.)
private oFont10    := TFontEx():New(oPrinter,"Arial",10,10,.F.,.T.,.F.)

oFont14CNb:Bold := .T.

if !(lExecjob)
	
	dSTART_DATE  := ctod("01/" + strzero(mv_par01,2) + "/" + strzero(mv_par02,4))	// primeiro dia do período
	dEND_DATE    := ctod("31/" + strzero(mv_par03,2) + "/" + strzero(mv_par04,4))		// último dia do período
	dCURR_DATE   := dSTART_DATE     // dia do registro em processamento
	dLAST_DATE   := dSTART_DATE		// último dia impresso
	
	if U_YIsBis(mv_par04) 
		dEND_DATE := ctod(Iif(strzero(mv_par03,2)$"01/03/05/07/08/10/12","31",Iif(strzero(mv_par03,2)=="02","29","30"))+"/"+strzero(mv_par03,2)+"/"+strzero(mv_par04,4))
    else
		dEND_DATE := ctod(Iif(strzero(mv_par03,2)$"01/03/05/07/08/10/12","31",Iif(strzero(mv_par03,2)=="02","28","30"))+"/"+strzero(mv_par03,2)+"/"+strzero(mv_par04,4))   
    endif
	
else
	
	dSTART_DATE  := ctod("01/" + strzero(nMesJob,2) + "/" + strzero(nAnoJob,4))	// primeiro dia do período
	dEND_DATE    := ctod("31/" + strzero(nMes2Job,2) + "/" + strzero(nAno2Job,4))		// último dia do período
	dCURR_DATE   := dSTART_DATE		// dia do registro em processamento
	dLAST_DATE   := dEND_DATE		// último dia impresso
	
	if U_YIsBis(nAno2Job) 
		dEND_DATE := ctod(Iif(strzero(nMes2Job,2)$"01/03/05/07/08/10/12","31",Iif(strzero(nMes2Job,2)=="02","29","30"))+"/"+strzero(nMes2Job,2)+"/"+strzero(nAno2Job,4))
    else
		dEND_DATE := ctod(Iif(strzero(nMes2Job,2)$"01/03/05/07/08/10/12","31",Iif(strzero(nMes2Job,2)=="02","28","30"))+"/"+strzero(nMes2Job,2)+"/"+strzero(nAno2Job,4))   
    endif
	
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ impressão dos dados                                          			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressão dos dados do produtor                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

If !(lExecjob)
	PrintCabec( dSTART_DATE, dEND_DATE, mv_par05 )
Else
	PrintCabec( dSTART_DATE, dEND_DATE, cCodJob )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressão das despesas notas         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿


If !(lExecjob)
	
	fBuscaNotas( dSTART_DATE, dEND_DATE, mv_par05 )

Else'
    fBuscaNotas( dSTART_DATE, dEND_DATE, cCodJob )
EndIf



oPrinter:EndPage()


oPrinter:Print()
FreeObj(oPrinter)



return




/*----------------------------------------------------------------------------------------------------
{Protheus.doc} PrintCabec
Impressão do cabeçalho .

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function PrintCabec(dSTART_DATE, dEND_DATE,  cPRODUT)
Local nVALOTot := 0
local cAliasTMP  := GetnextAlias()
local hEnter	 := CHR(10) + CHR(13)
local dSTART_FIN := dSTART_DATE
local dEND_FIN   := dEND_DATE

dbselectarea("SA2")
dbsetorder(1)
dbgotop()
If dbseek ( xfilial("SA2") + substr(cPRODUT,1,TAMSX3("A2_COD")[1]) )
	
	cQuery := "	SELECT 															" + hEnter
	cQuery += "			SUM(SF1.F1_VALBRUT) AS VLTOTAL							" + hEnter
	cQuery += "	FROM " + RetSqlName("SF1") + " SF1								" + hEnter
	cQuery += "	WHERE   SF1.F1_FORNECE   = '" + SA2->A2_COD  + "'	 			" + hEnter
	cQuery += "	AND     SF1.F1_LOJA      = '" + SA2->A2_LOJA + "'				" + hEnter
	cQuery += " AND     SF1.F1_TIPO   = 'N'								 		" + hEnter
	cQuery += "	AND     SF1.F1_EMISSAO BETWEEN '" + dtos(dSTART_FIN) + "'		" + hEnter
	cQuery += "	AND     					   '" + dtos(dEND_FIN) + "'			" + hEnter
	cQuery += "	AND 	SF1.D_E_L_E_T_  != '*' 									" + hEnter
	cQuery += "	GROUP BY SF1.F1_FORNECE		 									" + hEnter
	
	//conout(cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())
	
	while !(cAliasTMP)->(EOF())
		
		nVALOTot:= (cAliasTMP)->VLTOTAL
		
		(cAliasTMP)->(dbskip())
	enddo
	(cAliasTMP)->(dbCloseArea())
EndIF



dbselectarea("SA2")
dbsetorder(1)
dbgotop()
dbseek( xfilial("SA2") + cPRODUT )


If nPag > 0
	oPrinter:EndPage()
EndIf
nPag++
oPrinter:StartPage()

oPrinter:Box(100, 5, 3000, 2300)

cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
if file(cLogoD)
	oPrinter:SayBitmap(110,080,cLogoD,200,110)
endif


oPrinter:Say(160, 650	, "INFORME DE RENDIMENTOS DO PRODUTOR", oFont16BD:oFont )
oPrinter:Say(140, 2040	, "Data: " + dtoc(date()), oFont10:oFont )
oPrinter:Say(170, 2040	, "Hora: " + substr(time(),1,5), oFont10:oFont )
if !lExecjob
	oPrinter:Say(190, 730	, alltrim(SM0->M0_NOMECOM) +" - CNPJ: "+ transform(alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99"), oFont12:oFont )
else
	oPrinter:Say(190, 630	, alltrim(SM0->M0_NOMECOM) +" - CNPJ: "+transform(alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99")+" - ( Emitido pelo Portal do Produtor )", oFont12:oFont )
endif
oPrinter:Say(200, 2040	, "Página: " + cvaltochar(nPag), oFont10:oFont )

oPrinter:Line(220, 5, 220, 2300)
oPrinter:Say(270, 20	, "PERIODO: ", oFont14:oFont )
oPrinter:Say(270, 900	, dtoc(dSTART_DATE) + " a: " + dtoc(dEND_DATE), oFont14:oFont )

oPrinter:Line(310, 5, 310, 2300)
oPrinter:Say(360, 20	, "Produtor" , oFont14:oFont)
oPrinter:Say(360, 220	, ":  " + alltrim(SA2->A2_NOME), oFont14:oFont )
oPrinter:Say(360, 1900	, "CPF:  " + transform(SA2->A2_CGC,"@R 999.999.999-99"), oFont14:oFont )
oPrinter:Say(410, 20	, "Endereço ", oFont14:oFont)
oPrinter:Say(410, 220	,":  " + alltrim(SA2->A2_END) + " - " + alltrim(SA2->A2_MUN) + " / " + SA2->A2_EST, oFont14:oFont )	

If nPag = 1

	oPrinter:Line(450, 5, 450, 2300)	
                           	
	oPrinter:Say(500, 20	, "DECLARAMOS PARA OS FINS QUE SE FIZERAM NECESSÁRIOS, QUE ADQUIRIMOS DO PRODUTOR ACIMA QUALIFICADO " , oFont14:oFont)
	oPrinter:Say(550, 20	, "PARA O PERIODO INFORMADO, OS VALORES CONSTANTES NO PRESENTE DEMONSTRATIVO, A TÍTULO DE COMPRAS " , oFont14:oFont)
	oPrinter:Say(600, 20	, "DE LEITE IN NATURA." , oFont14:oFont)

	nLin := 650
Else
	nLin := 450
EndIf
 
return                                          



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fBuscaNotas
Função utilizada para impressão notas fiscais do produtor no perído informado.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fBuscaNotas( dSTART_DATE, dEND_DATE, cPRODUT )
Local lRet		 := .T.
local lCabec     := .F.
local cAliasTMP  := GetnextAlias()
local hEnter	 := CHR(10) + CHR(13)
local dSTART_FIN := dSTART_DATE
local dEND_FIN   := dEND_DATE
Local nMesAtual1 := MONTH(date())
Local nMesrel1 := MONTH(dSTART_DATE)
Local nVALOTot := 0
Local nPagina := 1

dbselectarea("SA2")
dbsetorder(1)
dbgotop()
If dbseek ( xfilial("SA2") + substr(cPRODUT,1,TAMSX3("A2_COD")[1]) )
	
	cQuery := "	SELECT 															" + hEnter
	cQuery += "			SF1.F1_DOC,												" + hEnter
	cQuery += "			SF1.F1_SERIE,  											" + hEnter
	cQuery += "			SF1.F1_EMISSAO,											" + hEnter
	cQuery += "			SF1.F1_VALBRUT,											" + hEnter
	cQuery += "			SF1.F1_TIPO,  											" + hEnter
	cQuery += "			SF1.F1_FORNECE											" + hEnter
   //	cQuery += "			SF1.F1_LOJA   											" + hEnter
	cQuery += "	FROM " + RetSqlName("SF1") + " SF1								" + hEnter
	cQuery += "	WHERE   SF1.F1_FORNECE   = '" + SA2->A2_COD  + "'	 			" + hEnter
  //	cQuery += "	AND     SF1.F1_LOJA      = '" + SA2->A2_LOJA + "'				" + hEnter
	cQuery += " AND     SF1.F1_TIPO   = 'N'								 		" + hEnter
	cQuery += "	AND     SF1.F1_EMISSAO BETWEEN '" + dtos(dSTART_FIN) + "'		" + hEnter
	cQuery += "	AND     					   '" + dtos(dEND_FIN) + "'			" + hEnter
	cQuery += "	AND 	SF1.D_E_L_E_T_  != '*' 									" + hEnter
	cQuery += "	ORDER BY SF1.F1_EMISSAO		 									" + hEnter
	
	//conout(cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())
	
	while !(cAliasTMP)->(EOF())
		
		if ! lCabec
			oPrinter:Line(nLin, 5, nLin, 2300)
			nLin += 50
			oPrinter:Say(nLin, 1050	, "DEMONSTRATIVO", oFont14BD:oFont )
			nLin += 25
			oPrinter:Line(nLin, 5, nLin, 2300)
			nLin += 25
			If nPagina > 1
				nLin += 25
				oPrinter:Say(nLin, 20	, "Continuação... " , oFont14:oFont)
				nLin += 50
			EndIf
			nCol := 70
			oPrinter:SayAlign(nLin, nCol, "NOTAS FISCAIS",oFont14CNb,350,50,,0,0)
			nCol := 500
			oPrinter:SayAlign(nLin, nCol, "DATA EMISSAO",oFont14CNb,300,50,,0,0)
			nCol := 1900
			oPrinter:SayAlign(nLin, nCol, "VALOR BRUTO",oFont14CNb,350,50,,1,0)
			
			lCabec := .T.
		endif
		
		
		nVALORCR := (cAliasTMP)->F1_VALBRUT
		nVALOTot := nVALOTot + nVALORCR
		
		
		nLin += 50
		nCol := 70
		oPrinter:SayAlign(nLin, nCol, alltrim( (cAliasTMP)->F1_DOC ) ,oFont14CN,350,50,,0,0)
		nCol := 500
		oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->F1_EMISSAO ) ),oFont14CN,300,50,,0,0)
		nCol := 1900
		oPrinter:SayAlign(nLin, nCol, transform(nVALORCR,"@R 999,999.99"),oFont14CN,350,50,,1,0)
		
		if nLin > 2750
			nLin += 100
			oPrinter:SayAlign(nLin, 70, "Continua...",oFont16CI,350,50,,1,0)
			PrintCabec( dSTART_DATE, dEND_DATE, mv_par05 )
			lCabec := .F.
			nPagina++
		endif
		
		(cAliasTMP)->(dbskip())
		
	enddo
	
	(cAliasTMP)->(dbCloseArea())
   
	nLin += 150
	nCol := 70
	oPrinter:SayAlign(nLin, nCol, "TOTAL R$  ",oFont14CN,350,50,,0,0)
	nCol := 1900
	oPrinter:SayAlign(nLin, nCol, transform(nVALOTot,"@E 99,999,999.99"),oFont14CN,350,50,,1,0)
	
	oPrinter:Say(2550, 240	, "Por ser a mais pura expressão da verdade, assino o presente, para que surta os seus legais e jurídicos efeitos." , oFont14:oFont)

	cAssina	:= GetSrvProfString("Startpath","") + "ASSINA" + ".BMP"

	if file(cAssina)
  		oPrinter:SayBitmap(2600,870,cAssina,600,195)
	endif
	oPrinter:Say(2850, 900	, "EDSON SANTOS SOARES" , oFont14:oFont)
	oPrinter:Say(2900, 995	, "CONTADOR" , oFont14:oFont)
	oPrinter:Say(2950, 950	, "CRC/PR: 052569/O-4" , oFont14:oFont) 
	
endif


return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  22/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------------------------------------------------------------------------------*
Static Function AjustaSX1()
*----------------------------------------------------------------------------------------------------*
aRegs  := {}  ; aHelp01 := {} ; aHelp02 := {} ; aHelp03 := {} ; aHelp04 := {} 
aHelp05 := {} ;

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd(aRegs,{cPerg,"01","Mês de            ?","Mês                ?","Mês                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL3401."})
aAdd(aRegs,{cPerg,"02","Ano de            ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL3402."})
aAdd(aRegs,{cPerg,"03","Mês até           ?","Mês                ?","Mês                ?","mv_ch3","N",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL3403."})
aAdd(aRegs,{cPerg,"04","Ano até           ?","Ano                ?","Ano                ?","mv_ch4","N",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL3404."})
aAdd(aRegs,{cPerg,"05","Produtor          ?","Produtor           ?","Produtor           ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL3405."})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe o mês inicial    " )       
	AADD( aHelp02, "Informe o ano inicial    " )       
	AADD( aHelp03, "Informe o mês final      " )       
	AADD( aHelp04, "Informe o ano final		 " )       
	AADD( aHelp05, "Informe o código inicial do produtor     " )       
	AADD( aHelp05, "a ser impresso.                          " ) 

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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o Help dos campos no arquivo de Help³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PutSX1Help("P.LTREL3401.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL3402.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL3403.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL3404.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL3405.",aHelp05,aHelp05,aHelp05)

Return Nil
