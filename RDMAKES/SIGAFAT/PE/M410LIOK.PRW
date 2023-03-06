#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   M410LIOK  ºAutor  ³Igor Chemin         º Data ³  29/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para validação na linha dos itens na rotina±±
±±º          ³ de pedido de itens                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico SILVESTRE                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410LIOK()

	Local aArea		:= GetArea()
	Local lRet			:= .T.
	Local nProduto		:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "C6_PRODUTO"})
	Local nComissao		:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "C6_COMIS1"})
	Local nComissao2	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "C6_COMIS2"})

	Local _nPosPreco    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_PRUNIT'})
	Local _nPosPrcV     := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_PRCVEN'})
	Local _nPosDesco    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_DESCONT'})
	Local _nPosXDesc    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_X_DESC'})
	Local _nPosPrTab    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_X_PTB'})

	Local _nPosVlTot    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_VALOR'})
	Local _nPosQuant    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_QTDVEN'})

	Local nComis1, nComis2     := 0
	Local nComisVen2	:= POSICIONE( "SA3",1,XFILIAL( "SA3" ) + SC5->C5_VEND2,"SA3->A3_COMIS")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Obtém conteúdo das entidades das ACOLS posicionadas                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cProduto   := aCols[n, nProduto]
	cComissao  := aCols[n, nComissao]
	cComissao2 := aCols[n, nComissao2]

	if cComissao == 0
		cVend := M->C5_VEND1
		nComis1 := U_GETCOMIS( cVend, cProduto)
		if nComis1 == 0
			aCols[n, nComissao] := M->C5_COMIS1
		else
			aCols[n, nComissao] := nComis1
		endIf
	EndIf

	If cComissao2 == 0
		cVend := M->C5_VEND2
		IF !EMPTY(ALLTRIM(cVend))
			nComis2 := U_GETCOMIS( cVend, cProduto)
		ENDiF
		if nComis2 == 0
			aCols[n, nComissao2] := nComisVen2
		else
			aCols[n, nComissao2] := nComis2
		endIf
	EndIf

	ConOut('M410LIOK - Fim da execucao do PE as '+ Time() )
	If IsInCallStack("U_ICGERPED")
		
		aCols[n,_nPosPreco] := aCols[n,_nPosPrTab]

		If aCols[n,_nPosDesco] > 0
			aCols[n,_nPosPrcV]  := Round(aCols[n,_nPosPreco] * (1-aCols[n,_nPosDesco]/100),2)
			If (aCols[n,_nPosQuant]) > 0
				aCols[n,_nPosVlTot] := Round(aCols[n,_nPosQuant] * aCols[n,_nPosPrcV], 2)
			EndIf
		ElseIf aCols[n,_nPosPrcV] < aCols[n,_nPosPrTab]
			//aCols[n,_nPosPrcV]  := aCols[n,_nPosPrTab]
			If (aCols[n,_nPosDesco]) = 0
				aCols[n,_nPosDesco] := round(((1-(aCols[n,_nPosPrcV] / aCols[n,_nPosPrTab]))*100),2)
			EndIf
			If (aCols[n,_nPosQuant]) > 0
				aCols[n,_nPosVlTot] := aCols[n,_nPosQuant] * aCols[n,_nPosPrcV]
			EndIf
		Endif
	EndIf

	RestArea(aArea)
return lRet
