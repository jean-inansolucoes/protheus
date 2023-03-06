#include "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LSPROD   บ Autor ณ LINCOLN ROSSETTO           ณ 11/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para carregar automaticamente o c๓digo do produto   บฑฑ
ฑฑบ          ณ de acordo com o grupo/sub-grupo                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SB1 - Cadastro de Produtos - P10                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

/***************************************************************************/
User Function LSPROD()
/***************************************************************************/
Local cArea  := GetArea()
Local cQuery,cProxProd, cArea, cUltProd, nUltProd, nTamanho
                
nTamanho := 4 //deve ser alimentado com o tamanho do codigo sem considerar o grupo.  Exemplo:
/*grupo 0101 codigo 000001 - B1_COD = 01010001
|____||___|
GRP  COD
4    4                 */

If (Select("QRYTOT") <> 0)
	dbSelectArea("QRYTOT")
	dbCloseArea()
Endif

cGrpAtual  := M->B1_GRUPO

cQuery := "SELECT MAX( SB1.B1_COD ) AS ULTPROD " + Chr(13)
cQuery += "  FROM "+RetSqlName( "SB1" )+" SB1" + Chr(13)
cQuery += " WHERE SB1.D_E_L_E_T_ <> '*' "  + Chr(13)
cQuery += "   AND SB1.B1_GRUPO    = '" + cGrpAtual + "' " + Chr(13)
cQuery += "   AND SB1.B1_FILIAL   = '" + xFilial( "SB1" ) + "' " + Chr(13)

TCQUERY cQuery NEW ALIAS "QRYTOT"

dbSelectArea("QRYTOT")

cUltProd  := QRYTOT->ultprod
nUltProd  := val(QRYTOT->ultprod)

If nUltProd <> 0
	cProxProd := SUBSTR(ALLTRIM(cUltProd),0,4)+STRZERO(VAL(SUBSTR(ALLTRIM(cUltProd),5,nTamanho))+1,nTamanho)
Else
	cProxProd := StrZero(Val(Alltrim(cGrpAtual)+"0001"),8)
Endif

dbCloseArea("QRYTOT")

RestArea( cArea )

Return( cProxProd )
