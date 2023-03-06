#include "protheus.CH"
#include "RWMAKE.CH"
#include "TBICONN.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GRV   ºAutor  ³Rafael Parma       º Data ³  16/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a confirmação documento de º±±
±±º          ³entrada, utilizado para validação da exclusão do documento. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LATICINIO                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function MT100GRV()
*----------------------------*
Local lRet  := .T.
Local lFec  := .F.
//Local aAreaTMP := GetArea()
Local lDeleta  := PARAMIXB[1]

	If lDeleta 

		//--Validação sobre cálculo de custo
		dbSelectArea("SD1")
		dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM	
		dbGoTop()
		If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
	 		While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
	 			If SD1->D1_X_FECCM == "S"
	 				lFec := .T.
	 				Exit
	 			EndIf
	 			SD1->(dbSkip())
	 		Enddo	
		EndIf
		
		If lFec 
	    	Aviso("Atenção","Este documento já foi utilizado para cálculo do fechamento do custo do leite e não poderá ser excluído.",{"OK"},2)
	    	lRet := .F.
	    EndIf
	 
	 EndIf  
	 
	 
	 
	 //--Validação sobre títulos de frete
	 If lDeleta .AND. !Empty(SF1->F1_X_LINHA)
	 
		//-- geração de títulos de frete a pagar/receber no fechamento mensal do produtor.	 
		If SuperGetMV("MV_ZLHTFR",,.F.)		
			
			cPREFIXTIT := SuperGetMV("MV_ZLPTFR",,"")		// Prefixo do título de frete a pagar/receber
			lTITREC    := .F.
			lTITPAG    := .F.
			
			//--Título a receber (produtor)
			dbSelectArea("SE1")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( SF1->F1_FILIAL + cPREFIXTIT + SF1->F1_DOC + Space(TAMSX3("E1_PARCELA")[1]) )
				While !SE1->(EOF()) .AND. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == SF1->F1_FILIAL + cPREFIXTIT + SF1->F1_DOC + Space(TAMSX3("E1_PARCELA")[1])
					//--Já baixado
					If SE1->E1_SALDO != SE1->E1_VALOR .AND. SF1->F1_X_LINHA == SE1->E1_X_LINHA .AND. SubSTR(SE1->E1_TIPO,1,2) == "DP"
						lTITREC := .T.	
						Exit
					EndIf
					SE1->(dbSkip())
				Enddo
			EndIf
			
			//--Título a pagar (transportador)
			dbSelectArea("SE2")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( SF1->F1_FILIAL + cPREFIXTIT + SF1->F1_DOC + Space(TAMSX3("E1_PARCELA")[1]) )
				While !SE2->(EOF()) .AND. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA) == SF1->F1_FILIAL + cPREFIXTIT + SF1->F1_DOC + Space(TAMSX3("E1_PARCELA")[1])
					//--Já baixado
					If SE2->E2_SALDO != SE2->E2_VALOR .AND. SF1->F1_X_LINHA == SE2->E2_X_LINHA .AND. SubSTR(SE2->E2_TIPO,1,2) == "DP"
						lTITPAG := .T.	
					EndIf
					SE2->(dbSkip())
				Enddo
			EndIf
            
			If lTITREC .or. lTITPAG
				cTEXTO := "Este documento não poderá ser excluído pois foram localizados títulos de frete referente ao transporte já baixados." + CHR(13)
				cTEXTO += "Devem ser canceladas as baixas sobre os títulos do contas a pagar/receber com o prefixo/número: "+cPREFIXTIT+"/"+SF1->F1_DOC
				Aviso( "Atenção", cTEXTO, {"OK"} )
				lRet := .F.
			EndIf
			                                                                                                             

		EndIf
	 EndIf


Return (lRet)
