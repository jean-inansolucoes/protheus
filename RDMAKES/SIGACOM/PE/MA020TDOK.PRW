/*     	
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MA020ALT   ºAutor  ³Alexandre          º Data ³  25/07/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida alteração fornecedor    							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA020TDOK()
************************
Local lRet := .T.
Local cMV_ZLTCPP  := AllTRIM(GetMV("MV_ZLTCPP"))	   				// códigos das condições de pagamento parcelado
Local cMsg1 := ""
Local cMsg2 := ""
Local cMsg3 := ""

If M->A2_X_TIPO == "P" .And. M->A2_X_FPGTO !="D" .And. M->A2_LOJA !="9999"
	M->A2_X_FPGTO := "D"
	cMsg2  := "1. Informe os dados da conta!"
	If !(M->A2_COND $ cMV_ZLTCPP)
 		cMsg1 := "2. A condição " + M->A2_COND + " não pode ser utilizada para produtor de leite!" 
 		cMsg2 := cMsg2  + Chr(13) + Chr(10)  +"2. Utilize as condições: " + Alltrim(cMV_ZLTCPP) + Chr(13) + Chr(10)
 		cMsg3 := " ** Conforme programação do financeiro"
		M->A2_COND := ""
	EndIf

	ShowHelpDlg( "Atenção!!!",;
			{ "1. Produtores de leite não podem utilizar a Forma de pagamento em CHEQUE!" + Chr(13) + Chr(10) + " ** A Forma foi alterada para DEPOSITO." + Chr(13) + Chr(10)  + cMsg1 }, 5,;
			{ cMsg2 + ;
			cMsg3}, 5)
	lRet := .F.
	 
EndIf

If M->A2_X_TIPO == "P" .And. !(M->A2_COND $ cMV_ZLTCPP) .And. lRet .And. M->A2_LOJA !="9999" .And. !Empty(Alltrim(M->A2_COND))
	M->A2_COND := ""
	lRet := .F.
	cMsg1 := "2. A condição " + M->A2_COND + " não pode ser utilizada para produtor de leite!" 
	cMsg2 :=  Chr(13) + Chr(10)  +"2. Utilize: " + Alltrim(cMV_ZLTCPP) + Chr(13) + Chr(10)
	cMsg3 := " ** Conforme programação do financeiro"
	ShowHelpDlg( "Atenção!!!",;
			{ cMsg1 }, 5,;
			{ cMsg2 + ;
			cMsg3}, 5)
	
EndIf

Return(lRet)
