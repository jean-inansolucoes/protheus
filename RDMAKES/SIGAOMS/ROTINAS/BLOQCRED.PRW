#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPDTREGR  บAutor ณAlexandre Longhinotti บData ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Fun็ใo farแ o bloqueio do pedido de venda por cr้dito     บฑฑ
ฑฑบ          ณ  quando a cond. pag for diferente do cad. do cliente.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

  
User Function BLOQCRED(cPedi)
*----------------------*  
Local aArea  := GetArea()
Private lMsErroAuto := .F.
        
		cBloq = "01"
	
   		cQuery := "UPDATE 	[" + RetSQLName("SC9") + "] 				"
		cQuery += "SET 		C9_BLCRED  = '" + cBloq + "'		    "
		cQuery += "WHERE 	C9_FILIAL  = '" + xFilial("SC9") + "'"
		cQuery += "AND  	C9_PEDIDO  = '" + cPedi + "'"
		cQuery += "AND  	D_E_L_E_T_ != '*'"
		TCSQLEXEC(cQuery)       
	    
	    cMsg = " - COND. PAGAMENTO DO PEDIDO DIFERENTE DO CADASTRO DO CLIENTE!"
	    
		cQuery := "UPDATE 	[" + RetSQLName("SC5") + "] 				"
		cQuery += "SET 		C5_X_MCRE2  = '" + cMsg + "'		    "
		cQuery += "WHERE 	C5_FILIAL  = '" + xFilial("SC5") + "'"
		cQuery += "AND  	C5_NUM  = '" + cPedi + "'"
		cQuery += "AND  	D_E_L_E_T_ != '*'"
		TCSQLEXEC(cQuery)   
	 
		
Return