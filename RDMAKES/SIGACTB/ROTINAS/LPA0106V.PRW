#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0106V     ºAutor  ³RICARDO BRUNETO  º Data ³  13/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³HISTORICO DOS LANCAMENTOS CONTABEIS VALIDADOS PELO LP        ±±
±±           ³PADRAO 520-002 - BAIXA DO CONTAS A PAGAR, POIS NESTE LP SERAO±±
±±           ³CONTABILIZADAS AS COMPENSACOES ENTRE CARTEIRAS DE FORMA      ±±
±±           ³OFF-LINE                                                     ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO LATICINIOS SILVESTRE                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

USER FUNCTION LPA0106V()

LOCAL cHIST := "" 

IF(SE5->E5_TIPO="NCC" .AND.  SE5->E5_BANCO!= "" .AND. SE5->E5_RECPAG= "P")   //QUANDO FOR PAGAMENTO DE NCC AO CLIENTE  
	cHIST :=  SUBSTR ("BX NCC-" + SE1->E1_NUM + "-" + SA1->A1_NOME,1,40)
	
ELSEIF(SE5->E5_TIPO="RA" .AND.  SE5->E5_BANCO!= "" .AND. SE5->E5_RECPAG= "P")  //QUANDO FOR PAGAMENTO DE RA AO CLIENTE 
	cHIST :=  SUBSTR ("DEV REC-" + SE1->E1_NUM + "-" + SA1->A1_NOME,1,40)
	
ELSEIF (SE1->E1_PREFIXO $ "FRT/PAP" .AND. SE5->E5_MOTBX = "CEC")  
	cHIST :=  SUBSTR ("VLR CONV PROD-" + SE1->E1_NUM + "-" + SA1->A1_NOME,1,40) //QDO FOR COMPENSACAO DE CONVENIOS PRODUTOR RURAL
	
ELSEIF (SE1->E1_PREFIXO <> "FRT/PAP" .AND. SE5->E5_MOTBX = "CEC" .AND. SE5->E5_TIPO!="EMP")
	cHIST :=  SUBSTR ("BX CEC-" + SE1->E1_NUM + "-" + SA1->A1_NOME,1,40) //QDO FOR COMPENSACAO ENTRE CONTAS A PAGAR E A RECEBER

ELSEIF (SE1->E1_PREFIXO <> "FRT/PAP" .AND. SE5->E5_MOTBX = "CEC" .AND. SE5->E5_TIPO=="EMP")
	cHIST :=  SUBSTR ("BX EMP-" + SE1->E1_NUM + "-" + SA1->A1_NOME,1,40) //QDO FOR EMPRESTIMO	

ELSE
	cHIST := SUBSTR ("REC TIT-" + SE1->E1_NUM + "-" + SA1->A1_NOME,1,40) //QDO FOR RECEBIMENTO NORMAL DE TITULOS
	
ENDIF


RETURN cHIST
