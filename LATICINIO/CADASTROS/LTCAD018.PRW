#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTCAD018  ºAutor  ³ALEXANDRE LONGIHNOTTI Data ³  01/12/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CADASTRO PRECO SOLIDOS SORO   			                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TRELAC						                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTCAD018()
	Local cDel := "U_VAL018EX()"
	Local cOK  := "U_VAL018AI()"

	dbSelectArea("ZME")
	dbSetOrder(1)
	AxCadastro("ZME","Cadastro Preço Solidos de Soro",cDel,cOK)

Return


User Function VAL018AI()
	Local lRet := .T.
	Local cQuery    := ""
	Local cAliasTMP	:= GetNextAlias()

	If __cUserId $ SuperGetMV("MV_ZLEXPR",,"")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleção dos registros da Pesagem                       ³
//³ referentes ao Registro dos Itens da NF                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := " SELECT COUNT(ZM1_FILIAL) QTD " + CRLF
		cQuery += " FROM "+RetSqlName( "ZM1" )                           + CRLF
		cQuery += " WHERE ZM1_FILIAL  = '" + ZME->ZME_FILIAL +  "'"      + CRLF
		cQuery += "     AND ZM1_CLIFOR  = '" + ZME->ZME_FORNECE + "'"       + CRLF
		cQuery += "     AND ZM1_LOJA    = '" + ZME->ZME_LOJA +    "'"       + CRLF
		cQuery += "     AND ZM1_PROD    = '" + ZME->ZME_PROD +     "'"      + CRLF
		cQuery += "     AND ZM1_PRCSOL <> 0"						        + CRLF
		cQuery += "     AND ZM1_DATA  BETWEEN '" + dtos(ZME->ZME_DTDE)+ "'" + CRLF
		cQuery += "		AND '" + dtos(ZME->ZME_DTATE)+  "'"    			    + CRLF
		cQuery += "     AND "+RetSqlName( "ZM1" ) + ".D_E_L_E_T_  != '*'"   + CRLF


//ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa consulta SQL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cAliasTMP := GetNextAlias()
		TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

		dbSelectArea(cAliasTMP)

		If (cAliasTMP)->QTD > 0 .AND. !INCLUI
			lRet := .F.
			Alert("Já exite movimento para este forncecedor no periodo com este preço! Impossível prosseguir!")
		EndIf
	Else
		Alert("Usuário sem permissão pra usar essa rotina! Par. MV_ZLEXPR")
		lRet := .F.
	EndIf

Return lRet

User Function VAL018EX()
	Local lRet := .T.
	Local cQuery    := ""
	Local cAliasTMP	:= GetNextAlias()

	If __cUserId $ SuperGetMV("MV_ZLEXPR",,"")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleção dos registros da Pesagem                       ³
//³ referentes ao Registro dos Itens da NF                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := " SELECT COUNT(ZM1_FILIAL) QTD " + CRLF
		cQuery += " FROM "+RetSqlName( "ZM1" )                           + CRLF
		cQuery += " WHERE ZM1_FILIAL  = '" + ZME->ZME_FILIAL +  "'"      + CRLF
		cQuery += "     AND ZM1_CLIFOR  = '" + ZME->ZME_FORNECE + "'"       + CRLF
		cQuery += "     AND ZM1_LOJA    = '" + ZME->ZME_LOJA +    "'"       + CRLF
		cQuery += "     AND ZM1_PROD    = '" + ZME->ZME_PROD +     "'"      + CRLF
		cQuery += "     AND ZM1_PRCSOL <> 0"						        + CRLF
		cQuery += "     AND ZM1_DATA  BETWEEN '" + dtos(ZME->ZME_DTDE)+ "'" + CRLF
		cQuery += "		AND '" + dtos(ZME->ZME_DTATE)+  "'"    			    + CRLF
		cQuery += "     AND "+RetSqlName( "ZM1" ) + ".D_E_L_E_T_  != '*'"   + CRLF


//ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa consulta SQL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cAliasTMP := GetNextAlias()
		TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

		dbSelectArea(cAliasTMP)

		If (cAliasTMP)->QTD > 0 .AND. !INCLUI
			lRet := .F.
			Alert("Já exite movimento para este forncecedor no periodo com este preço! Impossível prosseguir!")
		EndIf
	Else
		Alert("Usuário sem permissão pra usar essa rotina! Par. MV_ZLEXPR")
		lRet := .F.
	EndIf
Return lRet

User Function LT018DATA(cCampo)
	Local lRet := .T.
	Local cQuery    := ""
	Local cAliasTMP	:= GetNextAlias()
	Local lPeriodo := .F.

	If !Empty(M->ZME_DTDE) .AND. !Empty(M->ZME_DTATE)
		lPeriodo := .T.
	EndIf

	If !Empty(M->ZME_DTDE) .AND. !Empty(M->ZME_DTATE)
		If M->ZME_DTATE < M->ZME_DTDE
			Return .F.
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleção dos registros da Pesagem                       ³
//³ referentes ao Registro dos Itens da NF                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT COUNT(ZME.ZME_FILIAL)	QTD	                        	" + CRLF
		cQuery += "FROM " + RetSQLName("ZME") + " ZME				        	" + CRLF
		cQuery += "WHERE ZME.ZME_FILIAL  = '" + xFilial("ZME")        	+ "'	" + CRLF
		cQuery += "  AND ZME.ZME_PROD       = '" + M->ZME_PROD        	+ "' 	" + CRLF
		cQuery += "  AND ZME.ZME_FORNEC     = '" + M->ZME_FORNEC     	+ "'	" + CRLF
		cQuery += "  AND ZME.ZME_LOJA       = '" + M->ZME_LOJA        	+ "'	" + CRLF
		If lPeriodo
			cQuery += "  AND ((ZME.ZME_DTDE   >= '" + dtos(M->ZME_DTDE)  + "'	" + CRLF
			cQuery += "  AND ZME.ZME_DTDE     <= '" + dtos(M->ZME_DTATE) + "'	" + CRLF
			cQuery += "  ) OR (ZME.ZME_DTATE  >= '" + dtos(M->ZME_DTDE)  + "'	" + CRLF
			cQuery += "   AND ZME.ZME_DTATE   <= '" + dtos(M->ZME_DTATE) + "'))	" + CRLF	
		else
			cQuery += "  AND ZME.ZME_DTDE     <= '" + dtos(cCampo)   	  + "'	" + CRLF
			cQuery += "  AND ZME.ZME_DTATE    >= '" + dtos(cCampo)   	  + "'	" + CRLF	
		EndIf
		
		cQuery += "  AND ZME.D_E_L_E_T_ <> '*'						" + CRLF

//ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa consulta SQL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cAliasTMP := GetNextAlias()
	TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

	dbSelectArea(cAliasTMP)

	If (cAliasTMP)->QTD > 0
		lRet := .F.
		Alert("Já exite cadastro para este forncecedor com a data informada! Impossível prosseguir!")
	EndIf

Return lRet

User Function LTVAL018()
	Local lRet := .T.
	Local cQuery    := ""
	Local cAliasTMP	:= GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleção dos registros da Pesagem                       ³
//³ referentes ao Registro dos Itens da NF                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := " SELECT COUNT(ZM1_FILIAL) QTD " + CRLF
	cQuery += " FROM "+RetSqlName( "ZM1" )                           + CRLF
	cQuery += " WHERE D_E_L_E_T_ <> '*' "                            + CRLF
	cQuery += "     AND ZM1_FILIAL  = '" + ZME->ZME_FILIAL +  "'"      + CRLF
	cQuery += "     AND ZM1_CLIFOR  = '" + ZME->ZME_FORNECE + "'"       + CRLF
	cQuery += "     AND ZM1_LOJA    = '" + ZME->ZME_LOJA +    "'"       + CRLF
	cQuery += "     AND ZM1_PROD    = '" + ZME->ZME_PROD +     "'"      + CRLF
	cQuery += "     AND ZM1_PRCSOL <> 0"						        + CRLF
	cQuery += "     AND ZM1_DATA  BETWEEN '" + dtos(ZME->ZME_DTDE)+ "'" + CRLF
	cQuery += "		AND '" + dtos(ZME->ZME_DTATE)+  "'"    			    + CRLF
	cQuery += "     AND "+RetSqlName( "ZM1" ) + ".D_E_L_E_T_  != '*'"   + CRLF


//ÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa consulta SQL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cAliasTMP := GetNextAlias()
	TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

	dbSelectArea(cAliasTMP)

	If (cAliasTMP)->QTD > 0
		lRet := .F.
		Alert("Já exite movimento para este forncecedor no periodo com este preço! Impossível prosseguir!")
	EndIf

Return lRet

