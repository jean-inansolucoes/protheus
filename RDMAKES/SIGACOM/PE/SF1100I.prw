#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBINFO.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Luiz Gamero Prado   º Data ³  28/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para atualizar conteudo dirf com seus res º±±
±±º          ³ pectivos codigos de retencoes                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO LAT SILVESTRE                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

**--------------------------------------------------**
User Function SF1100I()
**--------------------------------------------------**

Local _Area      := GetArea()
Private cNumNFP   := ""
Private cSerieNFP := "" 

// Grava numero da nota da tabela das NFP
If ALLTRIM(SF1->F1_TIPO) == "N" .And. ALLTRIM(SF1->F1_FORMUL) == "S" .And. ALLTRIM(SA2->A2_X_TIPO) =="P"
	dbSelectArea("ZLJ")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( xFilial("ZLJ") + SF1->F1_FORNECE + SF1->F1_LOJA )
		While ! ZLJ->(EOF()) .and. ZLJ->ZLJ_FILIAL + ZLJ->ZLJ_COD + ZLJ->ZLJ_LOJA == xFilial("ZLJ") + SF1->F1_FORNECE + SF1->F1_LOJA
			If Empty(Alltrim(ZLJ->ZLJ_NFCOMP)) .and. ZLJ->ZLJ_VALNF >= dDataBase
				RecLock("ZLJ",.F.)
				ZLJ->ZLJ_NFCOMP := SF1->F1_DOC
				ZLJ->ZLJ_SERIEC := SF1->F1_SERIE
				ZLJ->ZLJ_EMISSA := dDataBase
				cNumNFP 		:= ZLJ->ZLJ_NUMNF
				cSerieNFP       := ZLJ->ZLJ_SERIEP
				Exit
			EndIf
			ZLJ->(dbSkip())
		EndDo
	EndIf
	If !SF1->(EOF()) .AND. RecLock("SF1",.F.)
		SF1->F1_X_NFP := cNumNFP     // F1_X_NFP
		SF1->F1_X_SNFP := cSerieNFP   //F1_X_SNFP
		SF1->(MsUnLock())
	EndIf

EndIF

CODRET()

RestArea(_Area)

Return .T.


**-------------------------**
Static Function CODRET()
**-------------------------**
dbSelectArea("SA2")
dbSetOrder(1)
dbGoTop()
dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,.t.)

BEGINSQL ALIAS "SE2IMP"
	SELECT E2_PARCCSS, E2_PARCCOF, E2_PARCPIS, E2_PARCSLL, E2_PARCIR, E2_PARCISS, E2_PARCINS, E2_PARCSES, E2_NUM, E2_PREFIXO
	FROM %TABLE:SE2% 
	WHERE %NOTDEL% 
		AND E2_FILIAL = %XFILIAL:SE2% 
		AND E2_FORNECE = %EXP:SF1->F1_FORNECE% 
		AND E2_LOJA = %EXP:SF1->F1_LOJA%
		AND E2_PREFIXO = %EXP:SF1->F1_SERIE%
		AND E2_NUM = %EXP:SF1->F1_DOC%
		AND E2_TIPO = 'NF'
ENDSQL

While SE2IMP->(!EOF())

	IF !EMPTY(SE2IMP->E2_PARCCOF) .AND. !EMPTY(SE2IMP->E2_PARCPIS) .AND. !EMPTY(SE2IMP->E2_PARCSLL)
		//CODRET 5952 - DIRF=SIM                            
		//COFINS
		UPDCODRET("5952",SE2IMP->E2_NUM,SE2IMP->E2_PREFIXO,"00394460 ","0058",SE2IMP->E2_PARCCOF,Alltrim(GetMv("MV_COFINS")))
		//PIS
		UPDCODRET("5952",SE2IMP->E2_NUM,SE2IMP->E2_PREFIXO,"00394460 ","0058",SE2IMP->E2_PARCPIS,Alltrim(GetMv("MV_PISNAT")))	
		//CSLL
		UPDCODRET("5952",SE2IMP->E2_NUM,SE2IMP->E2_PREFIXO,"00394460 ","0058",SE2IMP->E2_PARCSLL,Alltrim(GetMv("MV_CSLL")))	
		
	ENDIF
	
	IF EMPTY(SE2IMP->E2_PARCCOF) .AND. !EMPTY(SE2IMP->E2_PARCPIS) .AND. EMPTY(SE2IMP->E2_PARCSLL)
		//CODRET 5979 - DIRF=SIM
		//PIS
		UPDCODRET("5979",SE2IMP->E2_NUM,SE2IMP->E2_PREFIXO,"00394460 ","0058",SE2IMP->E2_PARCPIS,Alltrim(GetMv("MV_PISNAT")))		
		
	ENDIF
	
	IF !EMPTY(SE2IMP->E2_PARCIR) .AND. ALLTRIM(SA2->A2_TIPO) == "J" 
		//CODRET 1708 - DIRF=SIM
		//CSLL
		UPDCODRET("1708",SE2IMP->E2_NUM,SE2IMP->E2_PREFIXO,"00394460 ","0058",SE2IMP->E2_PARCIR,"20402004")		   // nao da para pegar do parametro, pois no parametro consta aspas dupluas		
		
	ENDIF                           
	
	SE2IMP->(dbSkip())				
EndDo

SE2IMP->(dbCloseArea())

Return

**------------------------**
Static Function UPDCODRET(cCodRet,cDocRet,cPrfRet,cForRet,cLojRet,cParRet,cNatRet)
**------------------------**
cNatRet1 := ALLTRIM(cNatRet)


IF '"IRF"' == ALLTRIM(cNatRet)
	cNatRet := "IRF"
ENDIF
cQuery := " UPDATE " + RetSqlName("SE2") + " "
cQuery += " SET E2_CODRET = '" + cCodRet + "' , E2_DIRF = '1' "
cQuery += " WHERE  E2_FILIAL = '" + XFILIAL("SE2") + "' AND "
cQuery += " D_E_L_E_T_ <> '*' AND E2_NUM = '"+cDocRet+"' AND "
cQuery += " E2_PREFIXO = '" + cPrfRet + "' AND "
cQuery += " E2_FORNECE = '" + cForRet + "' AND E2_LOJA = '" + cLojRet + "' AND "
cQuery += " E2_NATUREZ = '" + cNatRet + "' "

//MemoWrite("C:\QUERY_UPDATE.TXT",cQuery)
TCSQLEXEC(cQuery)


Return .t.