#include "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DADOSMAT  ºAutor  ³Jefferson Mittanck  º Data ³  05/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que retorna os seguintes dados da matriz:           º±±
±±º          ³ M0_CGC, M0_NOMECOM, M0_ENDENT, M0_CIDENT, M0_CEPENT, M0_ESTENT
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LATICINIO SILVESTRE                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DADOSMAT(nParam)
Local _area    := getarea()
Local _areaSM0 := SM0->(getarea())
Local _chave   := SM0->M0_CODIGO+SUBSTR(SM0->M0_CODFIL,1,3)
Local cRet     := ""
dbselectarea("SM0")
dbsetorder(1)
if dbseek(_chave)
	if nParam==1
		cRet :=  SM0->M0_CGC	
	elseif nParam==2
		cRet :=  SM0->M0_NOMECOM
	elseif nParam==3
		cRet :=  SM0->M0_ENDENT 
	elseif nParam==4
		cRet :=  SM0->M0_CIDENT 
	elseif nParam==5
		cRet :=  SM0->M0_CEPENT
	elseif nParam==6
		cRet :=  SM0->M0_ESTENT
	endif			
endif

restarea(_areaSM0)
restarea(_area)

return cRet