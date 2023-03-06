#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0113V     ºAutor  ³RICARDO BRUNETO  º Data ³  24/10/12   º±±
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

User Function LPA0113V
**********************

Local nVALOR

nVALOR := 0

IF SE2->E2_PREFIXO = "MAN"
	IF!( (ALLTRIM(SE2->E2_TIPO) $ "PRE/FT"))
		IF!( ( ALLTRIM(SED->ED_CODIGO) $ "20401001/20302001/20302002/20302003/20302004/20401007" ) .OR. ( SE2->E2_PREFIXO $ "FRT/PAP" ) .OR. ( ( VAL(SED->ED_CODIGO) >= 202) .AND. (VAL(SED->ED_CODIGO) <= 20299999) ) )
			nVALOR := SE2->E2_VALOR
		ELSEIF ALLTRIM(SED->ED_CODIGO) $ "20203001/20203013"
			nVALOR := SE2->E2_VALOR
		ENDIF
	ENDIF
ELSEIF ( SE2->E2_TIPO = "NF" .AND. ALLTRIM(SED->ED_CODIGO) $ "20203001/20203013" )
			nVALOR := SE2->E2_VALOR
ENDIF

Return nVALOR


