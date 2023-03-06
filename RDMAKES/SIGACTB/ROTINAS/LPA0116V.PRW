#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0116V     ºAutor  ³RICARDO BRUNETO  º Data ³  13/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³HISTORICO DOS LANCAMENTOS CONTABEIS VALIDADOS PELO LP        ±±

±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±º USO ESPECIFICO LATICINIOS SILVESTRE - VALIDA AS BAIXAS DO CONTAS          º±±
±±º A PAGAR. SE O MOTIVO DA BAIXA FOR DIFERENTE DE CONPENSACAO ENTRE CARTEIAS º±±
±±º E DACAO, CONTABILIZA O VALOR LIQUIDO DO TITULO. CASO CONTRARIO VALIDA SE  º±±
±±º A COMPENSACAO FOR A RECEBER E O MOTIVO FOR DIFERENTE DE DACAO E           º±±
±±º CONTABILIZA O VALOR DO MOVIMENTO BANCARIO                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

USER FUNCTION LPA0116V()

LOCAL nVALOR := 0

IF (SE5->E5_MOTBX <> "CEC" .AND. SE5->E5_MOTBX <> "DAC")
  	nVALOR := SE5->E5_VALOR

ELSEIF (SE5->E5_RECPAG = "R" .AND. SE5->E5_MOTBX <> "DAC")
	nVALOR := SE5->E5_VALOR
ENDIF

RETURN nVALOR