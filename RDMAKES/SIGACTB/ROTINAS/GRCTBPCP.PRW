#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRCTBPCP   ºAutor  ³ Desenvolvimento    º Data ³ 18/04/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por retornar à conta crédito\débito a    º±±
±±º          ³partir do cadastro de Regras de Contabilização Produção con-º±±
±±º          ³forme parâmetros repassados para a rotina.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Regras de Contabilização                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//U_GRCTBPCP(SD3->D3_CF, SD3->D3_FILIAL, SD3->D3_OP, SD3->D3_TIPO, SD3->D3_GRUPO, SD3->D3_TM, SB1->B1_CONTA, SD3->D3_CC, "D")                                                                             
User Function GRCTBPCP(cMov, cFilCta, cNumOp, cTpProd, cGrpProd, cTpMov, cCta, cCusto, cTpCta, cTpLp)

Local aArea			:= GetArea()
Local aStruct		:= {}
Local lSimpDeb		:= .F.
Local lSimpCred		:= .F.
Local lDobrada		:= .F.
Local cOp			:= ""
Local cTipo			:= ""
Local cTipoLp		:= "3"
Local cQuery		:= ""
Local cConta		:= "A CLASSIFICAR"
Local cAliasH		:= "SZ5"
Local cAliasCpo		:= "Z5"
Local cAliasMem		:= "M->Z5"
Local cAliasTab		:= "SZ5->Z5"
Local cAliasQry		:= cAliasH + "." + cAliasCpo
Local cAliasTMP		:= GetNextAlias()
Local cOrderBy		:= "ORDER BY " + cAliasCpo + "_FILREG DESC, " + cAliasCpo + "_TIPO DESC, " + cAliasCpo + "_GRUPO DESC, " + cAliasCpo + "_TM DESC, " + cAliasCpo + "_CONTA DESC, " + cAliasCpo + "_CONTAF DESC, " + cAliasCpo + "_CC DESC, " + cAliasCpo + "_CCF DESC"
Local hEnter		:= CHR(10) + CHR(13)
Local nX

Default cMov		:= ""
Default cFilCta		:= ""
Default cNumOp		:= ""
Default cTpProd		:= ""
Default cGrpProd	:= ""
Default cTpMov		:= ""
Default cCta		:= ""
Default cCusto		:= ""
Default cTpCta		:= ""
Default cTpLp		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Compõe regra de OP com base no campo de número de OP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
cOp := IIF(!EMPTY(cNumOp), "1", "2")

IF SUBSTR(cMov, 3, 1) $ '4/6'
	cTipo := cMov
Else 
	cTipo := SUBSTR(cMov, 1, 2)+"?"
EndIF 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras para montagem da query de busca das regras de contabilização que atendem as informações repassadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea(cAliasH)

cQuery := "SELECT " + cAliasH + ".*																													" + hEnter

cQuery += "FROM " + RetSQLName(cAliasH) + " " + cAliasH + "																							" + hEnter

cQuery += "WHERE "  + cAliasQry + "_FILIAL   = '" + xFilial(cAliasH) + "'																			" + hEnter
cQuery += "  AND "  + cAliasQry + "_CF       = '" + cTipo            + "'																			" + hEnter
cQuery += "  AND "  + cAliasQry + "_OP       = '" + cOp              + "'																			" + hEnter 
cQuery += "  AND (" + cAliasQry + "_FILREG   = '*'                          OR  " + cAliasQry + "_FILREG   = '" + cFilCta  + "')			" + hEnter
cQuery += "  AND (" + cAliasQry + "_TIPO     = '*'                          OR  " + cAliasQry + "_TIPO     = '" + cTpProd  + "')			" + hEnter
cQuery += "  AND (" + cAliasQry + "_GRUPO    = '*'                          OR  " + cAliasQry + "_GRUPO    = '" + cGrpProd + "')			" + hEnter
cQuery += "  AND (" + cAliasQry + "_TM       = '*'                          OR  " + cAliasQry + "_TM       = '" + cTpMov   + "')			" + hEnter
cQuery += "  AND (" + cAliasQry + "_CONTA   <= '" + cCta             + "'  AND  " + cAliasQry + "_CONTAF  >= '" + cCta     + "')			" + hEnter
cQuery += "  AND (" + cAliasQry + "_CC      <= '" + cCusto           + "'  AND  " + cAliasQry + "_CCF     >= '" + cCusto   + "')			" + hEnter
cQuery += "  AND " + cAliasH + ".D_E_L_E_T_ <> '*'																									" + hEnter

cQuery += cOrderBy

aStruct := (cAliasH)->(dbStruct())

cQuery := ChangeQuery(cQuery)
				    
If Select(cAliasTMP) > 0
	(cAliasTMP)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasTMP, .T., .T.)

For nX := 1 To Len(aStruct)
	If aStruct[nX][2] <> "C"
		TcSetField(cAliasTMP,aStruct[nX][1],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4])
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso exista registro na tabela temporária, considera o mesmo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
If (cAliasTMP)->(RECNO()) > 0 .AND. (!EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTACRE")) .OR. !EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTADEB")))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Obtém à conta contábil quando a regra de contabilização é por Campo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If &(cAliasTMP + "->" + cAliasCpo + "_REGRA") == "1"
		cCampo := 	IIF(cTpCta == "C", &(cAliasTMP + "->" + cAliasCpo + "_CTACRE"), &(cAliasTMP + "->" + cAliasCpo + "_CTADEB"))
		cConta := &(ALLTRIM(cCampo))
		
		If EMPTY(cConta)
			Do Case
				Case ALLTRIM(cCampo) == "SB1->B1_CONTA"
					cConta := "SB1 SEM CONTA"
				Case ALLTRIM(cCampo) == "SD3->D3_CONTA"
					cConta := "SD3 SEM CONTA"
			EndCase
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Obtém à conta contábil quando a regra de contabilização é pela Conta Contábil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cConta := IIF(cTpCta == "C", &(cAliasTMP + "->" + cAliasCpo + "_CTACRE"), &(cAliasTMP + "->" + cAliasCpo + "_CTADEB"))
	EndIf
										
	lSimpDeb	:= IIF(!EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTADEB")) .AND. EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTACRE")), .T., .F.)
	lSimpCred	:= IIF(EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTADEB")) .AND. !EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTACRE")), .T., .F.)
	lDobrada	:= IIF(!EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTADEB")) .AND. !EMPTY(&(cAliasTMP + "->" + cAliasCpo + "_CTACRE")), .T., .F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Determina o tipo do LP que deverá ser processado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If cTpLP == "T"
	Do Case
		Case lSimpDeb
			cTipoLp := "1"
		Case lSimpCred
			cTipoLp := "2"
		Case lDobrada
			cTipoLp := "3"	
	EndCase
EndIf

(cAliasTMP)->(dbCloseArea())
RestArea(aArea)

Return IIF(cTpLP == "T", cTipoLp, cConta)
