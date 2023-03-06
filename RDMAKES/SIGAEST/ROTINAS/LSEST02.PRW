#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LTMOV007   ¦ Autor ¦ TOTVS PARANA CENTRAL  Data ¦ 01.12.2014  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Função Bloquear / liberar movimento de com estoque   negativo ³±±
±±³          ³Altera valor do marametro MV_ESTNEG              .            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TOTVS                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/* #### CONFIGURAÇÕES DO APPSERVER.INI ####

[JOBLTMOV007]
MAIN=')
ENVIRONMENT=SILVESTRE       

[ONSTART]
JOBS=JOBLTMOV007
REFRESHRATE=6000      

#### CONFIGURAÇÕES DO APPSERVER.INI #### */

//***********************
User Function LEST02_1()   //LIBERA MOV ESTOQUE NEGATIVO
Local cMsg := "Deseja LIBERAR o movimento com estoque negativo?"
Local cCaption := "MV_ESTNEG"
Public c_Ret := getmv("MV_ESTNEG") 

If Alltrim(c_Ret) == "N"
	If ApMsgNoYes(cMsg, cCaption)
		PutMv("MV_ESTNEG", "S")
		ApMsgAlert("Movimento Liberado!", cCaption) 
	EndIf
Else
	ApMsgAlert("O Movimento já está Liberado!", cCaption)
EndIf

Return

//***********************
User Function LEST02_2()   //BLOQUEIA MOV ESTOQUE NEGATIVO
Local cMsg := "Deseja BLOQUEAR o movimento com estoque negativo?"
Local cCaption := "MV_ESTNEG"
Public c_Ret := getmv("MV_ESTNEG") 

If Alltrim(c_Ret) == "S"
	If ApMsgNoYes(cMsg, cCaption)
		PutMv("MV_ESTNEG", "N") 
	EndIf
Else
	ApMsgAlert("O Movimento já está Bloqueado!", cCaption)
EndIf

Return