#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0106V     ºAutor  ³RICARDO BRUNETO  º Data ³  06/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³HISTORICO DOS LANCAMENTOS CONTABEIS VALIDADOS PELO LP        ±±
±±           ³PADRAO 527-002 - EXCLUSAO DAS BAIXAS DO CONTAS A PAGAR, POIS ±±
±±           ³NESTE LP SERAO CONTABILIZADAS AS COMPENSACOES ENTRE CARTEIRAS±±
±±           ³DE FORMA OFF-LINE                                            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO LATICINIOS SILVESTRE                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

USER FUNCTION LPA0117V()

LOCAL cHIST := ""

IF (SE1->E1_PREFIXO $ "FRT/PAP" .AND. SE5->E5_MOTBX = "CEC")
	cHIST :=  SUBSTR ("EXCL VLR CONV PROD-" + SE2->E2_NUM + "-" + SA1->A1_NOME,1,40) //QDO FOR COMPENSACAO DE CONVENIOS PRODUTOR RURAL
	
ELSEIF (SE1->E1_PREFIXO <> "FRT/PAP" .AND. SE5->E5_MOTBX = "CEC")
	cHIST :=  SUBSTR ("EXCL BX COMP CPG/REC-" + SA1->A1_NOME,1,40) //QDO FOR COMPENSACAO ENTRE CONTAS A PAGAR E A RECEBER
	
ELSE
	cHIST := SUBSTR ("EXCL REC TITULO-" + ALLTRIM (SE1->E1_PREFIXO) + "-" + SE1->E1_NUM + "-" + SA1->A1_NOME,1,40) //QDO FOR RECEBIMENTO NORMAL DE TITULOS
ENDIF


RETURN cHIST