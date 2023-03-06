#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA105OK ºAutor  ³Diego Martins       º Data ³  14/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma os produtos iguais                                    º±±
±±º          ³ Avalia o saldo de cada produto                             º±±
±±º          ³ Exibe mensagem para o usuario se encontrar algum problema  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Trelac 				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA105OK

	Local _areasb2 := SB2->( getarea() )
	Local nPosPrd := aScan( aHeader, { |x| upper(alltrim(x[2])) == "CP_PRODUTO" } )
	Local nPosQtd := aScan( aHeader, { |x| upper(alltrim(x[2])) == "CP_QUANT" } )
	Local nPosLocal := aScan( aHeader, { |x| upper(alltrim(x[2])) == "CP_LOCAL" } )
	Local cCodProd, nQtdProd, cLocal
	Local aReq := {}, nPos := 0, aFaltaSaldo := {}
	Local lRet := .T.
	Local cMsgErro := ""
	Local cQuery    := ""
	Local cAliasTMP	:= GetNextAlias()
	Local aSolicita := {}
	Local nPosConta := aScan(aHeader,{|x| AllTrim(x[2])=="CP_CONTA"})
	Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=="CP_PRODUTO"})
	Local nPosLoc   := aScan(aHeader,{|x| AllTrim(x[2])=="CP_X_LOC"})
	Local nPosCC    := aScan(aHeader,{|x| AllTrim(x[2])=="CP_CC"})
	Local cProdL    := ALLTRIM(GETMV("MV_ZLTPRD")) //Produto modulo Laticinio
	Local _cTM      := ALLTRIM(GETMV("MV_TMOBRIG")) //Tipos de Movimentacao de estoque em que nao sera validado Centro de Custo e Conta Contabil
	Local nX, i

	For nX := 1 To Len( aCols )
		If !(aCols[nX,Len(aCols[nX])])
			cCodProd := aCols[ nX, nPosPrd ]
			cLocal 	 := aCols[ nX, nPosLocal ]
			nQtdProd := aCols[ nX, nPosQtd ]

			nPos := aScan( aReq, { |x| x[1] = cCodProd } )
			if nPos == 0
				aAdd( aReq, { cCodProd, 0, cLocal } )
				nPos := len( aReq )
			endif
			aReq[ nPos,2 ] += nQtdProd
		Endif
	Next nX

// depois de somadas as quantidades, verifica o saldo em estoque de cada produto 
// utilizando as quantidade somadas    

	SB2->( dbSetOrder( 1 ) ) // B2_FILIAL, B2_COD, B2_LOCAL
	For nX := 1 To Len( aReq )
		nSALDO := SB2->(IF(dbSeek( xFilial() + aReq[ nX,1 ] + aReq[ nX,3 ]) , SaldoSB2(), 0 ))
		// se o saldo for menor que a quantidade solicitada, adiciona o produto ao array
		if aReq[ nX,2 ] > nSALDO
			aAdd( aFaltaSaldo, { ALLTRIM(aReq[ nX,1 ]), aReq[ nX,2 ], nSALDO }  )
		endif
	Next nX

	SB2->( restarea( _areasb2 ) )

	lRet := ( len( aFaltaSaldo ) = 0 )

	if ! lRet
		For nX := 1 To Len( aFaltaSaldo )
			cQuery := " SELECT IIF(SUM(B2_SALPEDI) > 0, SUM(B2_SALPEDI), 0) QTDSOL "+ CRLF
			cQuery += " FROM "+RetSqlName( "SB2" )+ " SB2"                       + CRLF
			cQuery += " WHERE B2_FILIAL  = '" +  xFilial("SB2") +  "'"   + CRLF
			cQuery += "     AND B2_COD  = '" + aFaltaSaldo[ nX,1 ] + "'"   + CRLF
			cQuery += "     AND SB2.D_E_L_E_T_  != '*'"   + CRLF

			cAliasTMP := GetNextAlias()
			TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)
			dbSelectArea(cAliasTMP)

			If (cAliasTMP)->QTDSOL < aFaltaSaldo[ nX,2 ]
				aAdd( aSolicita, {aFaltaSaldo[ nX,1 ], (aFaltaSaldo[ nX,2 ] - (cAliasTMP)->QTDSOL) })
			EndIf
			(cAliasTMP)->(dbCloseArea())

		Next nX

	endif


// se algum produto não possui saldo suficiente, avisa o usuário 
	if ! lRet
		For nX := 1 To Len( aFaltaSaldo )
			cMsgErro += "Não há saldo para o produto ‘" + aFaltaSaldo[ nX,1 ] + "‘" + CHR(13) + CHR(10)
		Next nX
		If Len(aSolicita) > 0 .and. __cUserId $ SuperGetMv("MX_USRSCP",,"")
			If ApMsgNoYes("Produto(s) NÃO têm saldo suficiente em estoque, Pressione F4 no código do produto e verifique o saldo disponível." + CHR(13) + CHR(10) + CHR(13) + CHR(10) + cMsgErro + CHR(13) + CHR(10) + CHR(13) + CHR(10) + "Deseja Incluir uma Solicitação de Compra para estes itens?")
				U_LSCOM004(aSolicita, .T.)
			EndIf
		else
			Alert ("Produto(s) NÃO têm saldo em estoque, pressione F4 no código do produto e verifique o saldo." + CHR(13) + CHR(10) + CHR(13) + CHR(10) + cMsgErro )
		EndIf
	endif


	For i := 1 to len(acols)
		If POSICIONE("SB1", 1, xFilial("SB1") + acols[i][nPosProd], "B1_APROPRI ") <> 'I'
			If (ALLTRIM(acols[i][nPosProd]) # cProdL) .AND. ( Empty(acols[i][nPosConta]) .OR. Empty(acols[i][nPosCC]) ) .AND. Empty(acols[i][nPosLoc])
				lRet := .F.
				Aviso("Atenção","Favor revisar o preenchimento dos campos: Centro de Custo e Conta Contabil, para produtos sem Armazem de destino.",{"OK"},2)
				Exit
			ElseIf !Empty(acols[i][nPosLoc]) .AND. !Empty(acols[i][nPosConta])
				acols[i][nPosConta] := ""
			EndIf
		EndIf
	Next i



	If (cSolic != cUserName)
		lRet := .F.
		Aviso("Atenção","Verifique o campo Solicitante!" + chr(13)+chr(10) + "O Solicitante deve ser o usuario que esta incluindo a solicitação!",{"OK"},2)
	EndIf

Return lRet
