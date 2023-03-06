#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0120V     ºAutor  ³ALEXANDRE LONGHI  º Data ³  11/07/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³XX        ±±

±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±º USO ESPECIFICO LATICINIOS SILVESTRE - TRATA A BAIXA DO CONTAS A RECEBER   º±±
±±º COM PARTICULARIDADES RELACIONADAS AO PAGAMENTO DE NCC, RECEBIMENTO DE FRT º±±
±±º RECEBIMENTO DE PAP, CEC FUNCIONARIOS E BAIXA NORMAL DE TITULOS A RECEBER  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

USER FUNCTION LPA0120V()
LOCAL cVALOR := ""

IF(SE5->E5_TIPO="NCC" .AND. SE5->E5_BANCO!= "" .AND. SE5->E5_RECPAG= "P")   //QUANDO FOR PAGAMENTO DE NCC AO CLIENTE
	cVALOR := "10102960001"
ELSEIF(SE5->E5_TIPO="RA" .AND. SE5->E5_BANCO!= "" .AND. SE5->E5_RECPAG= "P")  //QUANDO FOR PAGAMENTO DE RA AO CLIENTE
	cVALOR := "20105010001"
ELSEIF(SE1->E1_PREFIXO $ "FRT/PAP" .OR. SE5->E5_MOTBX = "CEC")
	IF(!Empty(POSICIONE("SA2",1, XFILIAL("SA2") + SE1->E1_CLIENTE + SE1->E1_LOJA , "SA2->A2_X_FUNC"))) //QUANDO BAIXA DE TITULOS DE FUNCIONARIOS
		cVALOR := "10103020001"
	ELSE
		cVALOR := POSICIONE("SA2",1, XFILIAL("SA2") + SE1->E1_CLIENTE + SE1->E1_LOJA , "SA2->A2_CONTA") //QUANDO BAIXA DE TITULOS DE PRODUTORES
	ENDIF
ELSE
	cVALOR := SA6->A6_CONTA//QUANDO BAIXA DE TITULOS DE CLIENTES
ENDIF


RETURN cVALOR
