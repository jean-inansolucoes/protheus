//============================================================================\
/*/{Protheus.doc}M410INIC
  ==============================================================================
    @description
    Descrição da função
    Ponto de entrada para alterar a coluna de descrição(19) do bloco F100 do SPED.
    @author Alexandre Longhinotti <ti@tresbarras.ind.br>
    @version 1.0
    @since 24/03/2021

/*/
//============================================================================\

#Include "protheus.ch"

User Function SPD10019()
    Local cDesc := ParamIxb[1]
    If Empty(cDesc)
        cDesc := POSICIONE("SD1",1,XFILIAL("SE2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA,"SD1->D1_X_DESCP")
    ENDIF


Return cDesc