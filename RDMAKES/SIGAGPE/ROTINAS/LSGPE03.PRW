#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSGPE03  ºAutor ³ Alexandre Longhinotti ºData ³ 07/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Bloqueia a venda de produtos para funcionário			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
User Function LSGPE03()
************************
Local cCod      := SUBSTR(SRA->RA_CIC,1,9)
Local nPerLim := VAL(GetMV("MV_CREDFUN"))
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+cCod+"0001")
	Reclock("SA1",.F.)
	SA1->A1_VENCLC := CTOD("31/12/2000")
	SA1->A1_LC 	   := ((SRA->RA_SALARIO * 0) / 100)
	SA1->(MsunLock())
	Aviso("","Cliente bloqueado com sucesso!",{"OK"},2)	
EndIf

Return( NIL )

User Function LSGPE03a()
************************
Local cCod      := SUBSTR(SRA->RA_CIC,1,9)
Local nPerLim := VAL(GetMV("MV_CREDFUN"))
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+cCod+"0001")
	Reclock("SA1",.F.)
		SA1->A1_LC 	   	:= ((SRA->RA_SALARIO * nPerLim) / 100)
		SA1->A1_X_FUNC 	:= SRA->RA_MAT
		SA1->A1_VEND   	:= "000000"
		SA1->A1_X_FORMA	:= "CO"	
		SA1->A1_RISCO 	:= ""
		SA1->A1_COND 	:= "901"
		SA1->A1_MSBLQL 	:= "2"
		SA1->A1_VENCLC  := CTOD("31/12/2099")
	SA1->(MsunLock())	
	Aviso("","Cliente desbloqueado com sucesso!",{"OK"},2)	
EndIf

Return( NIL )
