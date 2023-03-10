#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}M410VIS
  ==============================================================================
    @description
    Ponto de Entrada chamado na montagem da tela de altera??o de PV;
    Usado para redefinir o conte?do dos campos C6_PRUNIT e C6_DESCONT

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 17/09/2020

/*/
//============================================================================\
User Function M410VIS()
    Local _nPosPreco    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_PRUNIT'})
    Local _nPosPrcV     := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_PRCVEN'})
    Local _nPosDesco    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_DESCONT'})
    Local _nPosXDesc    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_X_DESC'})
    Local _nPosPrTab    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_X_PTB'})
    Local _nPosVlTot    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_VALOR'})
    Local _nPosQuant    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_QTDVEN'})

    Local _nI           := 0
    Local nArred := IIF(INCLUI, 4, 2)

    For _nI := 1 To Len(aCols)
        aCols[_nI,_nPosPreco] := aCols[_nI,_nPosPrTab]
        aCols[_nI,_nPosDesco] := aCols[_nI,_nPosXDesc]
        If aCols[_nI,_nPosXDesc] > 0
            aCols[_nI,_nPosPrcV]  := Round(aCols[_nI,_nPosPreco] * (1-aCols[_nI,_nPosDesco]/100),nArred)
            aCols[_nI,_nPosVlTot] := Round(aCols[_nI,_nPosQuant] * aCols[_nI,_nPosPrcV], nArred)
        ElseIf aCols[_nI,_nPosPrcV] < aCols[_nI,_nPosPrTab]
            If (aCols[_nI,_nPosDesco]) = 0
				aCols[_nI,_nPosDesco] := round(((1-(aCols[_nI,_nPosPrcV] / aCols[_nI,_nPosPrTab]))*100),2)
			EndIf
            aCols[_nI,_nPosPrcV]  := aCols[_nI,_nPosPrcV]
            aCols[_nI,_nPosVlTot] := aCols[_nI,_nPosQuant] * aCols[_nI,_nPosPrcV]
        Else
            aCols[_nI,_nPosVlTot] := aCols[_nI,_nPosQuant] * aCols[_nI,_nPosPrcV]
        Endif
    Next _nI

Return ( Nil )
// FIM da Funcao M410GET
//==============================================================================
