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
        

USER FUNCTION LPA0122V()      

LOCAL cConta := ""

Do Case
	
  Case (SE1->E1_PREFIXO $ "FRT/PAP")
		cConta := "20105040001"

	Case ((SE5->E5_TIPO="NCC" .OR. SE5->E5_TIPO="RA") .AND. SE5->E5_BANCO != "" .AND. SE5->E5_RECPAG= "P")
		cConta := SA6->A6_CONTA	
		
	Case (SE5->E5_TIPO="EMP" .AND. SE5->E5_RECPAG= "R")
		cConta := "10103010002"		
		
	OTHERWISE 
		cConta := SA1->A1_CONTA 	
		
EndCase

RETURN cConta

