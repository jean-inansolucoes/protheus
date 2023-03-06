#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"

//============================================================================\
/*/{Protheus.doc}LPA0122V
  ==============================================================================
    @description
    Descrição da função

    @author Alexandre Longhinotti <ti@tresbarras.ind.br>
    @version 1.0
    @since 07/12/2020

/*/
//============================================================================\
        

USER FUNCTION LPA0123V()      

LOCAL nValor := 0

nValor := IIF((SRZ->RZ_CC >="06" .AND. SRZ->RZ_CC<="07.99.99.999") .OR. (SRZ->RZ_CC >="14.02" .AND. SRZ->RZ_CC <="14.02.01.999") .OR. (SRZ->RZ_CC >="14.98" .AND. SRZ->RZ_CC <="14.98.01.003") .OR. SRZ->RZ_CC="14.05.01.003" .OR. SRZ->RZ_CC="14.05.01.004", SRZ->RZ_VAL, 0)

RETURN nValor

