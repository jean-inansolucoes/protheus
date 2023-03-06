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
ฑฑบPrograma  ณ TOTPR002 บAutor ณJoel Lipnharski      บ Data ณ  12/2009    บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PEDIDO DE COMPRAS (Emissao em formato Grafico)             บฑฑ
ฑฑ           ณ Para o Botao Imprimir na rotina Pedido de Compras, alterar บฑฑ
ฑฑ           ณ o parametro MV_PCCOMPRAS									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/

User Function TOTPR002()

Private _nPag  		:= 0          
Private	lEnd		:= .F.
Private	aAreaSC7	:= SC7->(GetArea())
Private	aAreaSA2	:= SA2->(GetArea())
Private	aAreaSA5	:= SA5->(GetArea())
Private	aAreaSF4	:= SF4->(GetArea())
Private	cPerg		:= 'TOTPR002  '
Private _cFornece   := ""
Private _cGrup 		:= ""     
Private Cond   		:= "" 
Private _cCond 		:= ""
Private _cTpFrete  	:= ""
Private TpFrete		:= ""
Private	oPrint		:= TMSPrinter():New(OemToAnsi('PEDIDO DE COMPRAS'))
Private oBrush		:= TBrush():New(,4)           
Private oPen		:= TPen():New(0,5,CLR_BLACK)
Private _cLogo		:= GetSrvProfString("Startpath","") + "logo.BMP"
Private _cTDesc		:= TamSx3("C7_DESCRI")[1]

Private oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08	  	:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
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

Private	lFlag		:= .t.,;	// Controla a impressao do fornecedor
nLinha				:= 3400,;	// Controla a linha por extenso
nLinFim				:= 0,;		// Linha final para montar a caixa dos itens
lPrintDesTab		:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
cRepres				:= Space(80)

Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
		_nValMerc 	:= 0,;		// Valor das mercadorias
		_nValIPI	:= 0,;		// Valor do I.P.I.
		_nValDes    := 0,;
		_nValICM    := 0,;
		_nValDesc	:= 0,;		// Valor de Desconto
		_nTotAcr	:= 0,;		// Valor total de acrescimo
		_nTotSeg	:= 0,;		// Valor de Seguro
		_nTotFre	:= 0,;		// Valor de Frete
		_nTotIcmsRet:= 0		// Valor do ICMS Retido


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta os parametros.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AjustaSX1(cPerg)

If	( ! Pergunte(cPerg,.T.) )
	Return
Else
	Private	cNumPed  	:= Alltrim(mv_par01)	// Numero do Pedido de Compras
	Private	cObserv1	:= mv_par02		   		// 1a Linha de Observacoes
	Private	cObserv2	:= mv_par03				// 2a Linha de Observacoes
	Private	cObserv3	:= mv_par04				// 3a Linha de Observacoes
	Private	cObserv4	:= mv_par05				// 4a Linha de Observacoes
	Private	lPrintCodFor:= mv_par06 			// Imprime o Codigo do produto no fornecedor ?
EndIf

DbSelectArea('SC7')
SC7->(DbSetOrder(1))
If	( ! SC7->(DbSeek(xFilial('SC7') + cNumPed)) )
	Help('',1,'PCGRAFICO',,OemToAnsi('Pedido nใo encontrado.'),1)
	Return .f.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a rotina de impressao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a area anterior ao processamento. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaSC7)
RestArea(aAreaSA2)
RestArea(aAreaSA5)
RestArea(aAreaSF4)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณ Joel Lipnharski     บ Data ณ  12/2009    บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Pedido de Compras                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona nos arquivos necessarios. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea('SA2')
SA2->(DbSetOrder(1))
If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
	Help('',1,'REGNOIS')
	Return .f.
EndIf          

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:SetPortrait()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta query !ณ 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
cSELECT :=	'SC7.C7_FILIAL,SC7.C7_UM, SC7.C7_NUM,SC7.C7_NUMSC, SC7.C7_VALICM, SC7.C7_DATPRF, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_COND, '+;
'SC7.C7_ITEM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, '+;
'SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_ICMSRET, SC7.C7_TPFRETE, SC7.C7_CONTATO '

cFROM   :=	RetSqlName('SC7') + ' SC7 '

cWHERE  :=	'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
			'SC7.C7_NUM     =    '+CHR(39) + cNumPed        +CHR(39)

cORDER  :=	'SC7.C7_FILIAL, SC7.C7_ITEM '

cQuery  :=	' SELECT '   + cSELECT + ;
			' FROM '     + cFROM   + ;
			' WHERE '    + cWHERE  + ;
			' ORDER BY ' + cORDER

TCQUERY cQuery NEW ALIAS 'TRA'

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

DbSelectArea('TRA')
Count to _nQtdReg
ProcRegua(_nQtdReg) 
TRA->(DbGoTop()) 
Cond := TRA->C7_COND
TpFrete := TRA->C7_TPFRETE

While TRA->( ! Eof() )
	
	xVerPag()
	
	If	( lFlag )
		//ฺฤฤฤฤฤฤฤฤฤฤฟ
		//ณFornecedorณ
		//ภฤฤฤฤฤฤฤฤฤฤู
		_cFornece := SA2->A2_COD
		nLin := 550
		oPrint:Say(nLin,0020,OemToAnsi('Fornecedor:'),oFont11)
		oPrint:Say(nLin,0390,AllTrim(SA2->A2_NOME) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont11)
		oPrint:Say(nLin+050,0020,OemToAnsi('Endere็o:'),oFont11)
		oPrint:Say(nLin+050,0390,SA2->A2_END,oFont11)
		oPrint:Say(nLin+100,0020,OemToAnsi('Municํpio/U.F.:'),oFont11)
		oPrint:Say(nLin+100,0390,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
		oPrint:Say(nLin+100,1200,OemToAnsi('Cep:'),oFont11)
		oPrint:Say(nLin+100,1370,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
		oPrint:Say(nLin+150,0020,OemToAnsi('Telefone:'),oFont11)
		oPrint:Say(nLin+150,0390,"("+Alltrim(SA2->A2_DDD)+") "+SA2->A2_TEL,oFont11)
		oPrint:Say(nLin+150,1200,OemToAnsi('Fax:'),oFont11)
		oPrint:Say(nLin+150,1370,"("+Alltrim(SA2->A2_DDD)+") "+SA2->A2_FAX,oFont11) 
		oPrint:Say(nLin+200,0020,OemToAnsi('Contato:'),oFont11)
		oPrint:Say(nLin+200,0390,TRA->C7_CONTATO,oFont11)
		oPrint:Say(nLin+200,1200,OemToAnsi('E-mail:'),oFont11)
		oPrint:Say(nLin+200,1370,SA2->A2_EMAIL,oFont11) 

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณNumero/Emissaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say(nLin+090,2370,"Pedido : "+SC7->C7_NUM,oFont18,,,,1)
		oPrint:Say(nLin+170,2370,"Emissใo: "+Dtoc(SC7->C7_EMISSAO),oFont11,,,,1)
		lFlag := .f.
	EndIf
	
	If	( lPrintDesTab )
		oPrint:Line(nLinha,20  ,nLinha   ,2370)
		oPrint:Line(nLinha,20  ,nLinha+70,  20)
		oPrint:Line(nLinha,140 ,nLinha+70, 140) 
		oPrint:Line(nLinha,480 ,nLinha+70, 480) 
		oPrint:Line(nLinha,1270,nLinha+70,1270)  
		oPrint:Line(nLinha,1470,nLinha+70,1470)  
		oPrint:Line(nLinha,1560,nLinha+70,1560)
		oPrint:Line(nLinha,1760,nLinha+70,1760)
		oPrint:Line(nLinha,1970,nLinha+70,1970)
		oPrint:Line(nLinha,2140,nLinha+70,2140)
		oPrint:Line(nLinha,2370,nLinha+70,2370)
		
		nLinha += 10
		oPrint:Say(nLinha,0040,OemToAnsi('Item'),oFont11)
		If mv_par06 = 2
			oPrint:Say(nLinha,0160,OemToAnsi('C๓digo/C๓d.For.'),oFont11)
		Else
			oPrint:Say(nLinha,0160,OemToAnsi('C๓digo'),oFont11)
		EndIf
		oPrint:Say(nLinha,0490,OemToAnsi('Descri็ใo' ),oFont11)
		oPrint:Say(nLinha,1280,OemToAnsi('Entrega'   ),oFont11)
		oPrint:Say(nLinha,1490,OemToAnsi('Un'        ),oFont11) 
		oPrint:Say(nLinha,1620,OemToAnsi('Qtde'      ),oFont11)
		oPrint:Say(nLinha,1785,OemToAnsi('Vlr.Unit.' ),oFont11) 
		oPrint:Say(nLinha,1990,OemToAnsi('% IPI'     ),oFont11)
		oPrint:Say(nLinha,2160,OemToAnsi('Total Item'),oFont11)
		lPrintDesTab := .f.
		nLinha += 60
		oPrint:Line(nLinha,020,nLinha,2370)
		
	EndIf
	
	For i := 1 to 2
			
		If	i == 1  //codigo do produto
			oPrint:Say(nLinha,040,TRA->C7_ITEM,oFont10)
			oPrint:Say(nLinha,0155,TRA->C7_PRODUTO,oFont10) 
		Else       // codigo fornecedor
			If mv_par06 = 2 
				If _cTDesc > 35
					nLinha -= 53
				EndIf
				DbSelectArea('SA5')
				SA5->(DbSetOrder(1))
				If	SA5->(DbSeek(xFilial('SA5') + SA2->A2_COD + SA2->A2_LOJA + TRA->C7_PRODUTO)) .and. ( ! Empty(SA5->A5_CODPRF) )
					nLinha += 53					
					oPrint:Say(nLinha,0155,"/ "+SA5->A5_CODPRF,oFont10)
					oPrint:Line(nLinha,20  ,nLinha+53,  20)
					oPrint:Line(nLinha,140 ,nLinha+53, 140)
					oPrint:Line(nLinha,480 ,nLinha+53, 480)
					oPrint:Line(nLinha,1270,nLinha+53,1270)
					oPrint:Line(nLinha,1470,nLinha+53,1470)
					oPrint:Line(nLinha,1560,nLinha+53,1560)
					oPrint:Line(nLinha,1760,nLinha+53,1760)
					oPrint:Line(nLinha,1970,nLinha+53,1970)
					oPrint:Line(nLinha,2140,nLinha+53,2140)
					oPrint:Line(nLinha,2370,nLinha+53,2370) 
				EndIf
			EndIf
		EndIf
		If i == 1			
			oPrint:Line(nLinha,20  ,nLinha+53,  20)
			oPrint:Line(nLinha,140 ,nLinha+53, 140)
			oPrint:Line(nLinha,480 ,nLinha+53, 480)
			oPrint:Line(nLinha,1270,nLinha+53,1270)
			oPrint:Line(nLinha,1470,nLinha+53,1470)
			oPrint:Line(nLinha,1560,nLinha+53,1560)
			oPrint:Line(nLinha,1760,nLinha+53,1760)
			oPrint:Line(nLinha,1970,nLinha+53,1970)
			oPrint:Line(nLinha,2140,nLinha+53,2140)
			oPrint:Line(nLinha,2370,nLinha+53,2370) 
			oPrint:Say(nLinha,0490,Substr(TRA->C7_DESCRI,1,35),oFont10) 

			If Len(Alltrim(TRA->C7_DESCRI)) > 35
				nLinha += 53
				oPrint:Line(nLinha,20  ,nLinha+53,20)
				oPrint:Line(nLinha,140 ,nLinha+53,140)
				oPrint:Line(nLinha,480 ,nLinha+53,480)
				oPrint:Line(nLinha,1270,nLinha+53,1270)
				oPrint:Line(nLinha,1470,nLinha+53,1470)
				oPrint:Line(nLinha,1560,nLinha+53,1560)
				oPrint:Line(nLinha,1760,nLinha+53,1760)
				oPrint:Line(nLinha,1970,nLinha+53,1970)
				oPrint:Line(nLinha,2140,nLinha+53,2140)
				oPrint:Line(nLinha,2370,nLinha+53,2370)
				oPrint:Say(nLinha,0490,Substr(TRA->C7_DESCRI,36,_cTDesc),oFont10) 
			EndIf

			oPrint:Say(nLinha,1280,DTOC(STOD(TRA->C7_DATPRF)),oFont10)
			oPrint:Say(nLinha,1490,TRA->C7_UM,oFont10)
			oPrint:Say(nLinha,1750,AllTrim(TransForm(TRA->C7_QUANT,'@E 9,999,999.99')),oFont10,,,,1) 
			If mv_par08 = 2
				oPrint:Say(nLinha,1950,AllTrim(TransForm(TRA->C7_PRECO,'@E 999,999.999')),oFont10,,,,1)
			EndIf
			oPrint:Say(nLinha,2120,AllTrim(TransForm(TRA->C7_IPI,  '@E 999,999.99')),oFont10,,,,1)
			If mv_par08 = 2
				oPrint:Say(nLinha,2350,AllTrim(TransForm(TRA->C7_TOTAL,'@E 999,999,999.99')),oFont10,,,,1)
			EndIf
		Endif
		
		nLinha += 53

		If mv_par06 = 1 
 			i := 2
  		EndIf                      

		If i == 2 
			oPrint:Line(nLinha,20,nLinha,2370)
		Endif
        
		If i == 1 .OR. (mv_par06 = 1)
			_nValMerc 		+= TRA->C7_TOTAL
			_nValIPI		+= (TRA->C7_TOTAL * TRA->C7_IPI) / 100
			_nValDes        += TRA->C7_VLDESC
			_nValICM        += TRA->C7_VALICM
			_nValDesc		+= TRA->C7_VLDESC
			_nTotAcr		+= TRA->C7_DESPESA
			_nTotSeg		+= TRA->C7_SEGURO
			_nTotFre		+= TRA->C7_VALFRE
		EndIf
				
		If	( Empty(TRA->C7_TES) )
			_nTotIcmsRet	+= TRA->C7_ICMSRET
		Else
			DbSelectArea('SF4')
			SF4->(DbSetOrder(1))
			If	SF4->(DbSeek(xFilial('SF4') + TRA->C7_TES))
				If	( AllTrim(SF4->F4_INCSOL) == 'S' )
					_nTotIcmsRet	+= TRA->C7_ICMSRET
				EndIf
			EndIf
		EndIf
			
	Next i
	
	IncProc()
	TRA->(DbSkip())
	
End

xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE MERCADORIASณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Line(nLinha,1270,nLinha+80,1270) 
oPrint:Line(nLinha,1560,nLinha+80,1560) 
oPrint:Line(nLinha,1760,nLinha+80,1760) 
oPrint:Line(nLinha,2140,nLinha+80,2140) 
oPrint:Line(nLinha,2370,nLinha+80,2370) 

ncol  := 1740  
ncol1 := 2360  

oPrint:Say(nLinha+10,1290,'ICMS:',oFont11)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol,TransForm(_nValICM,'@E 9,999,999.99'),oFont11,100,,,1)
EndIf
oPrint:Say(nLinha+10,1785,'Mercadorias:',oFont11)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol1,TransForm(_nValMerc,'@E 9,999,999.99'),oFont11,100,,,1)
EndIf
oPrint:Line(nLinha,1270,nLinha,2370)

nLinha += 80
xVerPag()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime DE ICMS RETIDOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Line(nLinha,1270,nLinha+80,1270) 
oPrint:Line(nLinha,1560,nLinha+80,1560) 
oPrint:Line(nLinha,1760,nLinha+80,1760) 
oPrint:Line(nLinha,2140,nLinha+80,2140) 
oPrint:Line(nLinha,2370,nLinha+80,2370) 
	
oPrint:Say(nLinha+10,1290,'ICMS Retido:',oFont11)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol,TransForm(_nTotIcmsRet,'@E 9,999,999.99'),oFont11,100,,,1)
EndIf
oPrint:Line(nLinha,1270,nLinha,2370)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE DESCONTณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(nLinha+10,1785,'Desconto(-):',oFont11)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol1,TransForm(_nValDesc,'@E 9,999,999.99'),oFont11,100,,,1)
EndIf
nLinha += 80
oPrint:Line(nLinha,1270,nLinha,2370)
xVerPag()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE IPIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Line(nLinha,1270,nLinha+80,1270) 
oPrint:Line(nLinha,1560,nLinha+80,1560) 
oPrint:Line(nLinha,1760,nLinha+80,1760) 
oPrint:Line(nLinha,2140,nLinha+80,2140) 
oPrint:Line(nLinha,2370,nLinha+80,2370) 
	
oPrint:Say(nLinha+10,1290,'I.P.I. (+):',oFont11)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol,TransForm(_nValIpi,'@E 9,999,999.99'),oFont11,100,,,1)
eNDiF
oPrint:Line(nLinha,1270,nLinha,2370)	
	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE ACRESCIMO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(nLinha+10,1785,'Acr้scimo (+):',oFont11)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol1,TransForm(_nTotAcr,'@E 9,999,999.99'),oFont11,100,,,1)
EndIf
nLinha += 80
oPrint:Line(nLinha,1270,nLinha,2370)
xVerPag()                 
	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE FRETE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Line(nLinha,1270,nLinha+80,1270) 
oPrint:Line(nLinha,1560,nLinha+80,1560) 
oPrint:Line(nLinha,1760,nLinha+80,1760) 
oPrint:Line(nLinha,2140,nLinha+80,2140) 
oPrint:Line(nLinha,2370,nLinha+80,2370) 
If mv_par08 = 2
	oPrint:Say(nLinha+10,1290,'Frete (+):',oFont11)
EndIf
oPrint:Say(nLinha+10,ncol,TransForm(_nTotFre,'@E 9,999,999.99'),oFont11,100,,,1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE SEGURO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(nLinha+10,1785,'Seguro (+):',oFont11)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol1,TransForm(_nTotSeg,'@E 9,999,999.99'),oFont11,100,,,1)
EndIf
nLinha += 80
oPrint:Line(nLinha,1270,nLinha,2370)
xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o VALOR TOTAL !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Line(nLinha,1270,nLinha+80,1270)
oPrint:Line(nLinha,1760,nLinha+80,1760)
oPrint:Line(nLinha,2370,nLinha+80,2370)
oPrint:Say(nLinha+10,1290,'VALOR TOTAL: ',oFont12)
If mv_par08 = 2
	oPrint:Say(nLinha+10,ncol1,TransForm(_nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet,'@E 9,999,999.99'),oFont12,100,,,1) 
EndIf
nLinha += 80
xVerPag()
oPrint:Line(nLinha,1270,nLinha,2370)
nLinha += 70
xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime as observacoes dos parametros. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPrint:Say(nLinha,0015,OemToAnsi('Observa็๕es:'),oFont11)

If	( ! Empty(cObserv1) )
	oPrint:Say(nLinha,0310,upper(cObserv1),oFont10)
	nLinha += 60
	xVerPag()
EndIf
If	( ! Empty(cObserv2) )
	oPrint:Say(nLinha,0310,upper(cObserv2),oFont10)
	nLinha += 60
	xVerPag()
EndIf
If	( ! Empty(cObserv3) )
	oPrint:Say(nLinha,0310,upper(cObserv3),oFont10)
	xVerPag()
	nLinha += 60
EndIf
If	( ! Empty(cObserv4) )
	oPrint:Say(nLinha,0310,upper(cObserv4),oFont10)
	xVerPag()
	nLinha += 60
	xVerPag()
EndIf

nLinha += 40
xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime a linha de prazo pagamento!        ณ     
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   

oPrint:Say(nLinha,0020,OemToAnsi('Condi็ใo Pagamento:'),oFont11)                                            
_cCond := POSICIONE("SE4",1,xFilial("SE4")+Cond,"E4_DESCRI")
oPrint:Say(nLinha,430,(AllTrim(Cond)+" - "+(_cCond)),oFont12) 

	// Imprime tipo de frete CIF / FOB
   	If	TpFrete == "C"  // Frete CIF
   		oPrint:Say(nLinha,1270,OemToAnsi('Tipo Frete:  CIF',oFont13))
   		Else 
   		oPrint:Say(nLinha,1270,OemToAnsi('Tipo Frete:  FOB',oFont13))
   	Endif		

nLinha += 100
xVerPag()

oPrint:Line(nLinha,0020,nLinha,2370)
nLinha += 10
xVerPag()

TRA->(DbCloseArea())

xRodape()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Esta fun็ao s๓ funciona em servidores Windows
oPrint:SaveAllAsJpeg('\data\pedido',640,900)

oPrint:Preview()
  
If mv_par07 = 2
	EnvMail()
EndIf

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
Static Function xCabec()

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
oPrint:Say(285,0450,AllTrim('Comprador:  ') + PswRet()[1][4] ,oFont11)
oPrint:Say(335,0450,AllTrim('www.laticiniosilvestre.com.br')+ "    Email: " + PswRet()[1][14],oFont11)
oPrint:Line(385,0450,385,2370)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(0410,0450,OemToAnsi('PEDIDO DE COMPRA'),oFont22)

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
Local cTipoSC7 := ""   
Local cAprov := ""

dbSelectArea("SC7")
If !Empty(SC7->C7_APROV)
	
	cTipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == cTipoSC7
		
		Do Case
			Case SCR->CR_STATUS=="03" //Liberado
				cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
				cAprov += dtoc(SCR->CR_DATALIB) 
				cAprov += "]  "
			Case SCR->CR_STATUS=="04" //Bloqueado
				cAprov += "BLQ"			
			Case SCR->CR_STATUS=="05" //Nivel Liberado
				cAprov += "  "
			OtherWise                 //Aguar.Lib
				cAprov += "??"
			EndCase
	
		dbSelectArea("SCR")
		dbSkip()
	Enddo
	If cAprov = "??????????????????" .AND. GetMv("MV_BLOIMPC")
		Help('',1,'PCGRAFICO',,OemToAnsi('Pedido nใo Aprovado.'),1)
		oPrint:Cancel()
	EndIf
	
EndIf


                                 
oPrint:Line(2800,0020,2800,2370)                                 
oPrint:Say(2830,020,AllTrim("Libera็ใo do Pedido"),oFont11)
oPrint:Say(2930,020,AllTrim(cAprov),oFont11)
//oPrint:Line(3030,0020,3030,2370)
oPrint:Say(3050,020,AllTrim("NOTA: S๓ aceitaremos a mercadoria se na sua Nota Fiscal constar o numero de nosso pedido de compras: "+Alltrim(SC7->C7_NUM)),oFont11)
oPrint:Line(3100,0020,3100,2370)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
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

Static Function xVerPag()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia a montagem da impressao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLin := nLinha
nLin += 400

If	( nLin >= 3400 )  
	
	If	( ! lFlag )
		oPrint:EndPage()
		nLinha:= 650  
	Else
		nLinha:= 850  
	EndIf
	
	oPrint:StartPage()
	xCabec()
	
	lPrintDesTab := .t.
	_nPag++
	
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1บAutor ณJoel Lipnharski      บ Data ณ  12/2009     บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o SX1 - Arquivo de Perguntas..                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

/******
Parametros da funcao padrao
---------------------------
PutSX1(cGrupo,;
cOrdem,;
cPergunt,cPerSpa,cPerEng,;
cVar,;
cTipo,;
nTamanho,;
nDecimal,;
nPresel,;
cGSC,;
cValid,;
cF3,;
cGrpSxg,;
cPyme,;
cVar01,;
cDef01,cDefSpa1,cDefEng1,;
cCnt01,;
cDef02,cDefSpa2,cDefEng2,;
cDef03,cDefSpa3,cDefEng3,;
cDef04,cDefSpa4,cDefEng4,;
cDef05,cDefSpa5,cDefEng5,;
aHelpPor,aHelpEng,aHelpSpa,;
cHelp)    
*/

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Informe o numero do Pedido de          '  )
Aadd( aHelpPor, 'compras a ser impressso.               '  )
PutSx1(cPerg,"01","Pedido: "            ,"Pedido:             ","Pedido              ","mv_ch1","C",6,0,0,"G","","SC7","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Informe as observa็๕es.                '  )
Aadd( aHelpPor, '                                       '  )
PutSx1(cPerg,"02","Observa็๕es"            ,"Observa็๕es           ","Observa็๕es         ","mv_ch2","C",70,0,1,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
PutSx1(cPerg,"03"," "            ," "," ","mv_ch3","C",70,0,1,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
PutSx1(cPerg,"04"," "            ," "," ","mv_ch4","C",70,0,1,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
PutSx1(cPerg,"05"," "            ," "," ","mv_ch5","C",70,0,1,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Informe Sim para imprimir o c๓digo     '  )
Aadd( aHelpPor, 'do Fornecedor (Amarra็ใo Prod. x Forn.)'  )
PutSx1(cPerg,"06","Imp.Cod.For.?"            ,"Imp.Cod.For.?        "  ,"Imp.Cod.For.?","mv_ch6","N",1,0,1,"C","","","","","mv_par06","Nใo","","","","Sim","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Informe Sim para enviar E-mail.        '  )
PutSx1(cPerg,"07","Enviar E-mail?"            ,"Enviar E-mail?        ","Enviar E-mail?","mv_ch7","N",1,0,1,"C","","","","","mv_par07","Nใo","","","","Sim","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, 'Informe Sim imprimir o pre็o do produto'  )
PutSx1(cPerg,"08","Imprime pre็o?"            ,"Imprime pre็o?        ","Imprime pre็o?","mv_ch8","N",1,0,1,"C","","","","","mv_par08","Nใo","","","","Sim","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail   บAutor  ณJoel Lipnharski     บ Data ณ  12/2009    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSalva o arquivo gerado em .JPG e envia e-mail do mesmo.     บฑฑ
ฑฑบ          ณIMPORTANTE: Somente para servidores Windows                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnvMail()


Local _cSubject := "Pedido de Compra:"+ mv_par01
Local _cBody    := "Pedido de compra"+space(170)
Local _cDest    := SPACE(150)

_lOk := .t. 

	if (SA2->A2_EMAIL) <> " "
     	_cDest := Alltrim(SA2->A2_EMAIL)+space(100)
 	Else
     	_cDest := SPACE(150)
 	EndIf  
 
@ 0,0 TO 150,400 DIALOG oDlg1 TITLE "Favor inserir o destinatario do email:"
@ 1.0,2.0 Say "Destinatarios:"
@ 0.9,7  Get _cDest  Size 120,13 when .T. 
@ 3.0,2.0 Say "Mensagem:"
@ 2.9,7  Get _cBody  Size 120,13 when .T. 
@ 5.5,23  Button "&Ok" SIZE 35,15 ACTION oDlg1:End()
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
For i := 1 to (_nPag + 1)
	_cAtach += '\data\pedido_pag'+alltrim(str(i))+".jpg , "
Next i
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
