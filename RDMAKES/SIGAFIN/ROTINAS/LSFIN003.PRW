#include "rwmake.ch"
#Include "PROTHEUS.Ch"
#Include "TOPCONN.Ch"
#include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLSFIN003  บAutor  ณJoel Lipnharski     บ Data ณ  10/04/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para impressao de Boletos Bancarios.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LSFIN003()

Local aItens 	:= {}
Local hEnter	:= CHR(10) + CHR(13)
Local cAliasTMP	:= GetNextAlias()
Local oButton1
Local oButton2
Local oComboBo1
Local oGroup1
Local oSay1

Private oDlg
Private cComboBo1 := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtro somente os bancos liberados pelo depto financeiro EE_X_LIBER = '1'
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
If (Select(cAliasTMP) <> 0)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
Endif

cQuery := "SELECT DISTINCT						" + hEnter
cQuery += "SEE.EE_CODIGO 						" + hEnter
cQuery += "FROM " + RetSqlName("SEE") + " SEE 	" + hEnter
cQuery += "WHERE   								" + hEnter
cQuery += "SEE.EE_X_LIBER = '1'		  			" + hEnter
cQuery += "AND SEE.D_E_L_E_T_ <> '*'			" + hEnter
cQuery += "ORDER BY SEE.EE_CODIGO	 			" + hEnter

TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())

While (cAliasTMP)->(!EOF())

DO CASE

	CASE (cAliasTMP)->EE_CODIGO = "001"
		aadd(aItens,"BANCO DO BRASIL")

	CASE (cAliasTMP)->EE_CODIGO = "237"
		aadd(aItens,"BANCO BRADESCO")

	CASE (cAliasTMP)->EE_CODIGO = "341"
		aadd(aItens,"BANCO ITAU/SOFISA")
		
	CASE (cAliasTMP)->EE_CODIGO = "422"
		aadd(aItens,"BANCO SAFRA")
	
	CASE (cAliasTMP)->EE_CODIGO = "655"
		aadd(aItens,"BANCO VOTORANTIN") 
		
	CASE (cAliasTMP)->EE_CODIGO = "748"
		aadd(aItens,"BANCO SICREDI IMPRESSO")
	   	aadd(aItens,"BANCO SICREDI P/ EMAIL")
	   	
	CASE (cAliasTMP)->EE_CODIGO = "756"
		aadd(aItens,"BANCO SICOOB") 
		//aadd(aItens,"BANCO SICOOB P/ EMAIL")
	CASE (cAliasTMP)->EE_CODIGO = "033"
		aadd(aItens,"BANCO SANTANDER")

END CASE

(cAliasTMP)->( dbskip() ) 

EndDo

	DEFINE MSDIALOG oDlg TITLE "Impressใo de Boletos" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL

    @ 007, 006 GROUP oGroup1 TO 068, 190 PROMPT "Selecione o Banco" OF oDlg COLOR 0, 16777215 PIXEL
    @ 078, 151 BUTTON oButton1 PROMPT "&OK" SIZE 037, 012 OF oDlg PIXEL ACTION Imprime()
    @ 022, 026 MSCOMBOBOX oComboBo1 VAR cComboBo1 ITEMS aItens SIZE 093, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 037, 027 SAY oSay1 PROMPT "Este programa tem o objetivo de imprimir os boletos bancแrios de acordo com os Bancos liberados  pelo departamento financeiro." SIZE 142, 025 OF oDlg COLORS 0, 16777215 PIXEL
    @ 078, 110 BUTTON oButton2 PROMPT "&Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION ExitProc()

  	ACTIVATE MSDIALOG oDlg CENTERED
                                   
(cAliasTMP)->( dbCloseArea() )

Return()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz a chamada dos rdmakes para impressใo dos boletos.                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
Static Function Imprime()

DO CASE

	CASE ALLTRIM(cComboBo1) = "BANCO SICREDI IMPRESSO"              
		ExitProc()                         
		U_LSFINR01()	
	
	CASE ALLTRIM(cComboBo1) = "BANCO SICREDI P/ EMAIL"              
		ExitProc()                         
		U_LSFINR07()	
	
	CASE ALLTRIM(cComboBo1) = "BANCO SAFRA"
		ExitProc()                         
		U_LSFINR02()	

	CASE ALLTRIM(cComboBo1) = "BANCO BRADESCO"
		ExitProc()                         
		U_LSFINR03()	

	CASE ALLTRIM(cComboBo1) = "BANCO ITAU/SOFISA"
		ExitProc()                         
		U_LSFINR04()	

	CASE ALLTRIM(cComboBo1) = "BANCO VOTORANTIN" 
		ExitProc()                         
		U_LSFINR05()	
	
	CASE ALLTRIM(cComboBo1) = "BANCO DO BRASIL" 
		ExitProc()                         
		U_LSFINR06()
		
	CASE ALLTRIM(cComboBo1) = "BANCO SICOOB"              
		ExitProc()                         
		U_LSFINR09()

	CASE ALLTRIM(cComboBo1) = "BANCO SANTANDER"              
		ExitProc()                         
		U_LSFINR11()
		
	/*CASE ALLTRIM(cComboBo1) = "BANCO SICOOB P/ EMAIL"              
		ExitProc()                         
		U_LSFINR10()*/		
	
END CASE                        

Return()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha janela.                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
Static Function ExitProc()

Close(oDlg)

Return()
