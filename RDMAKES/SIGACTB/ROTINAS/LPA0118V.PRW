#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0118V     ºAutor  ³ALEXANDRE LONGHI  º Data ³  06/06/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³HISTORICO DOS LANCAMENTOS CONTABEIS VALIDADOS PELO LP        ±±

±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±º USO ESPECIFICO LATICINIOS SILVESTRE - BUSCA VALOR DO DESCONTO PARA TITULOSº±±
±±º COMPENSADOS  CONTABILIZA O VALOR DO MOVIMENTO BANCARIO E5_VLDESCO         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

USER FUNCTION LPA0118V()

LOCAL nVALOR := 0

Do Case
	Case POSICIONE( "SE5",18, "01LAT01" + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO") > 0
		nVALOR := POSICIONE( "SE5",I, XFILIAL( "SE5" ) + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO")

	Case POSICIONE( "SE5",18, "01LAT02" + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO") > 0
		nVALOR := POSICIONE( "SE5",I, XFILIAL( "SE5" ) + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO")
		
	Case POSICIONE( "SE5",18, "01LAT03" + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO") > 0
		nVALOR := POSICIONE( "SE5",I, XFILIAL( "SE5" ) + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO")
		
	Case POSICIONE( "SE5",18, "01LAT04" + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO") > 0
		nVALOR := POSICIONE( "SE5",I, XFILIAL( "SE5" ) + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO")

	Case POSICIONE( "SE5",18, "01LAT05" + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO") > 0
		nVALOR := POSICIONE( "SE5",I, XFILIAL( "SE5" ) + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO")
		
	Case POSICIONE( "SE5",18, "01LAT06" + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO") > 0
		nVALOR := POSICIONE( "SE5",I, XFILIAL( "SE5" ) + "CP" + SUBSTR(SE5->E5_DOCUMEN,1,3) + SUBSTR(SE5->E5_DOCUMEN,4,9) + SUBSTR(SE5->E5_DOCUMEN,10,3) + SE5->E5_SEQ, "SE5->E5_VLDESCO")
		
EndCase


RETURN nVALOR