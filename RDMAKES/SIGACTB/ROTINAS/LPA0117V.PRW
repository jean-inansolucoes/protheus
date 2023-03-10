#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?LPA0106V     ?Autor  ?RICARDO BRUNETO  ? Data ?  06/01/2014 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?HISTORICO DOS LANCAMENTOS CONTABEIS VALIDADOS PELO LP        ??
??           ?PADRAO 527-002 - EXCLUSAO DAS BAIXAS DO CONTAS A PAGAR, POIS ??
??           ?NESTE LP SERAO CONTABILIZADAS AS COMPENSACOES ENTRE CARTEIRAS??
??           ?DE FORMA OFF-LINE                                            ??
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? ESPECIFICO LATICINIOS SILVESTRE                            ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
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