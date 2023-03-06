#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}MT103DRF
  ==============================================================================
    @description
    Descrição da função

    @author Alexandre Longhinotti <ti@trelac.com.br>
    @version 1.0
    @since 14/04/2021

/*/
//============================================================================\
User Function MT103DRF()
Local nCombo  := PARAMIXB[1] 
Local cCodRet := PARAMIXB[2] 
Local aImpRet := {}

nCombo  := 1
IF ALLTRIM(SA2->A2_NATUREZ) == "20306001"
  cCodRet := "8045"
else
  cCodRet := "1708"
EndIf
aadd(aImpRet,{"IRR",nCombo,cCodRet})

nCombo  := 2
cCodRet := ""
aadd(aImpRet,{"ISS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"PIS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"COF",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"
aadd(aImpRet,{"CSL",nCombo,cCodRet})

Return aImpRet

// FIM da Funcao MT103DRF
//==============================================================================




