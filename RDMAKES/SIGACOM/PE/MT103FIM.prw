#include "TOTVS.CH"  
#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "TBICONN.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM   ºAutor  ³Rafael Parma       º Data ³  18/10/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a inclusão do documento de º±±
±±º          ³entrada.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SILVESTRE                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------*
User Function MT103FIM()
*----------------------------*
Local aAreaTMP 	:= GetArea()
Local nOpcao 	:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE
//Local cNumDoc := cNFiscal
                                                      
	If nConfirma == 1 .and.  nOpcao == 3 	//Inclusão                 
		/*
		If SF4->F4_PODER3 = "D" .AND. !Empty(SD1->D1_NFORI) .AND. !Empty(SD1->D1_SERIORI) .AND. !Empty(SD1->D1_ITEMORI) .AND. Empty(SD1->D1_IDENTB6)
			cFilSD1 := "SD1->D1_FILIAL = '"+ SD1->D1_FILIAL	+"' .AND. SD1->D1_FORNECE = '"+ ALLTRIM(SD1->D1_FORNECE) + "' .AND. SD1->D1_DOC = '"+ SD1->D1_DOC + "' .AND. SD1->D1_SERIE = '"+ SD1->D1_SERIE + "'"
			dbSelectArea("SD1")
			SET FILTER TO &(cFilSD1)
			SD1->(dbGoTop())
			While !SD1->(EOF())
				cFilSB6 := "SB6->B6_FILIAL = '"+ SD1->D1_FILIAL	+"' .AND. SB6->B6_CLIFOR = '"+ ALLTRIM(SD1->D1_FORNECE) +"' .AND. SB6->B6_PRODUTO = '"+ ALLTRIM(SD1->D1_COD) + "' .AND. SB6->B6_LOCAL = '"+ SD1->D1_LOCAL + "' .AND. SB6->B6_DOC = '"+ SD1->D1_NFORI + "' .AND. SB6->B6_SERIE = '"+ SD1->D1_SERIORI + "'"
				dbSelectArea("SB6")
				SET FILTER TO &(cFilSB6)
				SB6->(dbGoTop())
				While !SB6->(EOF())
					cIDENT := SB6->B6_IDENT
				SB6->(dbSkip())
				Enddo
				SET FILTER TO

				If RecLock("SD1",.F.)
					SD1->D1_IDENTB6 := cIDENT
				EndIf
			SD1->(dbSkip())
			Enddo
			SET FILTER TO
			
		EndIf
		
		*/

		IF !Empty(SA2->A2_X_LINHA) .AND. TRIM(SD1->D1_COD) == "01010001" .AND. SD1->D1_TES == "001" .AND. SF1->F1_TIPO =="N" .AND. Empty(SF1->F1_FORMUL) .AND. SA2->A2_X_TIPO =="P"
			If RecLock("SF1",.F.)
				SF1->F1_X_LINHA := SA2->A2_X_LINHA
				If AnoMes(SF1->F1_EMISSAO) == AnoMes(DDATABASE)
					SF1->F1_NUMRPS := AnoMes(MonthSub(SF1->F1_EMISSAO,1))
				EndIf
				SF1->(MsUnLock())
			EndIf 
		EndIf

		If Type("__cArqXml") == "C"	
			If __cArqXml != "" .OR. __cChvNFE != ""
				If RecLock("SF1",.F.)
					//--Arquivo XML
					SF1->F1_X_NFXML := __cArqXml
					If __cChvNFE != ""
						//--Chave NFE
						SF1->F1_CHVNFE := __cChvNFE

					EndIf

					SF1->(MsUnLock())
				EndIf 
				If RecLock("SF3",.F.)
					//--Arquivo XML
					If __cChvNFE != ""
						//--Chave NFE
						SF3->F3_CHVNFE := __cChvNFE
					EndIf
					SF3->(MsUnLock())
				EndIf 
				dbSelectArea('SFT')
				SFT->(dbSetOrder(15))
				SFT->(dbGoTop())
				If SFT->(dbSeek(xFilial('SFT')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					While !SFT->(EOF()) .AND. SFT->FT_FILIAL+SFT->FT_NFISCAL+SFT->FT_SERIE+SFT->FT_CLIEFOR+SFT->FT_LOJA == xFilial('SF1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
						RecLock("SFT",.F.)
						//--Arquivo XML
						If __cChvNFE != ""
							//--Chave NFE
							SFT->FT_CHVNFE  := __cChvNFE
						EndIf	
						SFT->(MsUnLock())
						SFT->(dbSkip())
					EndDo
				EndIf 
				         
				__cArqXml := ""
				__cChvNFE := ""
			EndIf
		EndIf
	   
	EndIf

	__cArqXml := ""
	__cChvNFE := ""
	
	RestArea(aAreaTMP)


Return
