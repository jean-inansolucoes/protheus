#include "colors.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0103V     ºAutor  ³RICARDO BRUNETO  º Data ³  30/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CONTABILIZACAO ICMS A RECUPERAR:                             ±±
±±            QUANDO FOR ICMS SOBRE DEVOLUCOES A CONTRAPARTIDA DO ICMS A   ±±
±±º          ³RECUPERAR SERA (- )ICMS SOBRE VENDAS, EM TODOS OS OUTROS    º±±
±±º          ³CASOS SERA A CONTA DE ESTOQUE PARA AJUSTAR O VLR DO ESTOQUE º±±
±±º          ³PELO CUSTO CAPADO                                            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO LATICINIOS SILVESTRE                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LPA0103V
**********************

Local nVALOR
nVALOR := 0
If(SD1->D1_CF = "1201" .OR. SD1->D1_CF = "1202" .OR. SD1->D1_CF = "1411" .OR. SD1->D1_CF = "2201";
   .OR. SD1->D1_CF = "2202" .OR. SD1->D1_CF = "2411")
	nVALOR := "30102030002"

Else 
	If(SD1->D1_CF = "1151" .OR. SD1->D1_CF = "1152" .OR. SD1->D1_CF = "2151" .OR. SD1->D1_CF = "2152";
   		.OR. SD1->D1_CF = "1208" .OR. SD1->D1_CF = "2208" .OR. SD1->D1_CF = "1209" .OR. SD1->D1_CF = "2209")
		nVALOR := "10104010050"
	Else
		nVALOR := SD1->D1_CONTA
	EndIf
EndIf                      

Return nVALOR


