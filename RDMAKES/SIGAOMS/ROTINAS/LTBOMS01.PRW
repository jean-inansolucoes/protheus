#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}LTBOMS01
  ==============================================================================
    @description
    Verifica se há restrição no cliente quanto à espécie de veículo utilizada
    na montagem da carga ou na amarração de veículo com a carga

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 19/10/2020

/*/
//============================================================================\
User Function LTBOMS01( _aCliCarga )
    Local _cVeic    := _aCliCarga[1]
    Local _aRestr   := {}
    Local _cEsp     := ''
    Local nI        := 0
    Local _aAreaSA1 := SA1->(GetArea())
    Local _aAreaDA3 := DA3->(GetArea())
    _cEsp := Posicione('DA3',1,xFilial('DA3')+_cVeic,'DA3_X_ESP')

    If Empty(_cEsp)
        MsgAlert("Atenção! Não foi definido a Espécie do veículo utilizado nesta carga. Recomenda-se fazer o preenchimento no cadastro do veículo para que seja possível verificar se os clientes possuem alguma restrição para recebimento do veículo utilizado no transporte!")
        RestArea(_aAreaSA1)
        RestArea(_aAreaDA3)
        Return
    EndIf

    dbSelectArea('ZAN')
    ZAN->(dbSetOrder(1)) 
    

    For nI := 2 To Len(_aCliCarga)
        ZAN->(dbGoTop())
        If ZAN->(dbSeek(xFilial('ZAN')+_aCliCarga[nI]+_cEsp))
           
            aAdd(_aRestr,_aCliCarga[nI])
        EndIf
    Next nI

    If Len(_aRestr) > 0
        _cMsg := "Atenção! Os clientes abaixo possuem restrição para receber veículos da espécie " 
        _cMsg += AllTrim(Posicione('SX5',1,xFilial('SX5')+'Z3'+_cEsp,'X5_DESCRI')) + ", conforme o qual foi utilizado nesta carga. Verifique!"
        _cMsg += Chr(10)+Chr(13)

        For nI := 1 To Len(_aRestr)
            dbSelectArea('SA1')
            SA1->(dbSetOrder(1)) 
            SA1->(dbGoTop())
            If SA1->(dbSeek(xFilial('SA1')+_aRestr[nI]))
                _cMsg += SA1->A1_COD+'-'+SA1->A1_LOJA+': ' + AllTrim(SA1->A1_NOME) + CHR(10) + CHR(13)
            EndIf
        Next nI

        MsgAlert(_cMsg)
    EndIf
    RestArea(_aAreaSA1)
    RestArea(_aAreaDA3)
Return ( Nil )
// FIM da Funcao LTBOMS01
//==============================================================================



