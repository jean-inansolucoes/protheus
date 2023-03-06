#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}M410GET
  ==============================================================================
    @description
    Ponto de Entrada chamado na montagem da tela de alteração de PV;
    Usado para redefinir o conteúdo dos campos C6_PRUNIT e C6_DESCONT

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 17/09/2020

/*/
//============================================================================\
User Function M410GET(  )
   
    Local _nPosPreco    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_PRUNIT'})
    Local _nPosPrcV     := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_PRCVEN'})
    Local _nPosDesco    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_DESCONT'})
    Local _nPosXDesc    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_X_DESC'})
    Local _nPosPrTab    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_X_PTB'})
    
    Local _nPosVlTot    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_VALOR'})
    Local _nPosQuant    := aScan(aHeader,{|x| alltrim(x[2]) == 'C6_QTDVEN'})

    Local _nI           := 0
    Local nArred := IIF(INCLUI, 4, 2)

    // Quando houver alteração no pedido de venda, força a limpeza dos campos da simulação de carga
    if ALTERA .and. SC5->( FieldPos( "C5_X_SIMUL" ) ) > 0 .and. SC5->( FieldPos( "C5_X_SQENT" ) ) > 0 .and. SC5->( FieldPos( "C5_X_LACRE" ) ) > 0
        M->C5_X_SIMUL := Space( TAMSX3("C5_X_SIMUL")[1] )
        M->C5_X_SQENT := Space( TAMSX3("C5_X_SQENT")[1] )
        M->C5_X_LACRE := Space( TAMSX3("C5_X_LACRE")[1] )
    endif

    For _nI := 1 To Len(aCols)
        aCols[_nI,_nPosPreco] := aCols[_nI,_nPosPrTab]
        aCols[_nI,_nPosDesco] := aCols[_nI,_nPosXDesc]
        
        If aCols[_nI,_nPosXDesc] > 0
            aCols[_nI,_nPosPrcV]  := Round(aCols[_nI,_nPosPreco] * (1-aCols[_nI,_nPosDesco]/100),nArred)
            If (aCols[_nI,_nPosQuant]) > 0
                aCols[_nI,_nPosVlTot] := Round(aCols[_nI,_nPosQuant] * aCols[_nI,_nPosPrcV], nArred)
            EndIf
        Else
            aCols[_nI,_nPosPrcV]  := aCols[_nI,_nPosPrcV]
            If (aCols[_nI,_nPosQuant]) > 0
                aCols[_nI,_nPosVlTot] := aCols[_nI,_nPosQuant] * aCols[_nI,_nPosPrcV]
            EndIf
        Endif
        
    Next _nI

Return ( Nil )

// FIM da Funcao M410GET
//==============================================================================



