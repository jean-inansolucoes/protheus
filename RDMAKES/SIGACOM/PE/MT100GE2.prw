#include "protheus.ch"   
#include "topconn.ch"   
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100G2   ºAutor  ³Jefferson Mittanck  º Data ³  29/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado na gravação das parcelas pelo   º±±
±±º          ³ Documento de Entrada                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LATICINIO SILVESTRE                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100GE2()   


Local cBco	:=  POSICIONE( "SA2",1, XFILIAL( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, "SA2->A2_BANCO")                 // Banco para deposito
Local cAgen	:=  POSICIONE( "SA2",1, XFILIAL( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, "SA2->A2_AGENCIA")               // Agencia para deposito
Local cCta	:=  POSICIONE( "SA2",1, XFILIAL( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, "SA2->A2_NUMCON")                // Conta para deposito
Local cTpCta:=  POSICIONE( "SA2",1, XFILIAL( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, "SA2->A2_X_TPCON")                // Tipo Conta para deposito
Local cFavor:=  POSICIONE( "SA2",1, XFILIAL( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, IIF(EMPTY(SA2->A2_X_NOMDP),"SA2->A2_NOME","SA2->A2_X_NOMDP"))// Favorecido para deposito
Local cTipo	:=  POSICIONE( "SA2",1, XFILIAL( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, IIF(EMPTY(SA2->A2_X_TPPSD),"SA2->A2_TIPO","SA2->A2_X_TPPSD"))// Tipo da pessoa para deposito
Local cCgc	:=  POSICIONE( "SA2",1, XFILIAL( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, IIF(EMPTY(SA2->A2_X_TPPSD),"SA2->A2_CGC","SA2->A2_X_CGCDP")) // CPF/CNPJ da pessoa para deposito

	RECLOCK("SE2",.F.)
		SE2->E2_X_BCODP := cBco
		SE2->E2_X_AGDEP := cAgen
		SE2->E2_X_CTADP := cCta
		SE2->E2_X_FAVDP := cFavor
		SE2->E2_X_TPPSD := cTipo
		SE2->E2_X_CGCDP := cCgc  
		SE2->E2_X_TPCON := cTpCta
		IF (cBco != "133" .And. cAgen != "1025")
			SE2->E2_FORBCO := "748"	
		EndIf
//Adicionado campo E2_X_DTLAN para ser gravado a database do lançamento do Documento de Entrada no Titulo a Pagar.
//Solicitação: Rose (Dpto. Financeiro) - Analista: Diego Coradini (Totvs Parana Central).
		SE2->E2_X_DTLAN := DDataBase                                
	SE2->(MSUNLOCK())
                  

Return
