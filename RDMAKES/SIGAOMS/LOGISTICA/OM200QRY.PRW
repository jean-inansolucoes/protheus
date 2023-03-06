#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OM200QRY º Autor ³ TOTVS			    ³  03/12/2015 		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro Carga OMS.					   					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³          	   		          						      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

***---------------------***
User Function OM200QRY()
***---------------------***

	Local cQuery     := PARAMIXB[1]
	//Local aArrayTipo := PARAMIXB[2]

	Private cSimula  := iif( isInCallStack( "U_ICLOG001" ), ( cAliasTMP )->C5_X_SIMUL,  SPACE(TamSX3("C9_X_SIMUL")[1]) )
	Private oSimula
	Private oVend1
	Private oDlgQry 
	Private nOpca    := 0   

	// Quando a simulaçao já estiver preenchida, não exibe tela pedindo código da simulação
	If !Empty(cSimula) .or. FilCarga() == 1
		cQuery += " AND C9_X_SIMUL = '"+cSimula+"' " 
	EndIf

Return(cQuery)

***---------------------***
Static Function FilCarga()
***---------------------***

	DEFINE MSDIALOG oDlg FROM 010,100 TO 140,350 TITLE "Complemento de Filtro para a Carga"  OF oMainWnd PIXEL
	@ 005, 005 TO 45, 123 OF oDlg  PIXEL

	@ 011,020 SAY "Simulacao:"       SIZE 200,10 OF oDlgQry PIXEL 
	@ 010,060 MSGET oSimula   VAR cSimula  SIZE 050,09 OF oDlgQry PIXEL
	
	DEFINE SBUTTON FROM 50, 040 TYPE 1 ACTION (nOpca:=1,oDlg:End())ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM 50, 070 TYPE 2 ACTION (nOpca:=2,oDlg:End())ENABLE OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return (nOpca)
