#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}LTBFAT05
  ==============================================================================
    @description
    Calcula desconto no pedido de venda em gatilho do campo C6_PRCVEN

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 16/10/2020

/*/
//============================================================================\
User Function LTBFAT05(  )
    Local _nDesc := 0
    Local _nPosPrT := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT"})
    Local _nPrcTab := aCols[n,_nPosPrT]

    If !IsInCallStack("MATA310") .and. !IsInCallStack("MATA311") .AND. _nPrcTab > 0
        _nDesc := MAX(0,Round((1-M->C6_PRCVEN/(_nPrcTab*(1-M->C5_DESC4/100)))*100,2))                             
    EndIf

Return ( _nDesc )
// FIM da Funcao LTBFAT05
//==============================================================================



