#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#Include "PROTHEUS.Ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ajustaSD2     ºAutor  ³Luiz Gamero Prado Data ³  26/02/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ rdmake tem a finalidade de ajustar os conteudos dos campos º±±
±±º          ³ para a geracao do arquivo sped pis cofins                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROTHEUS11                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function sd2Ajusta()
Local _COF := " "
Local _PIS := " "

DbSelectArea("SD2")
SD2->(DbSetOrder(1))
SD2->(DbGoTop())
While SD2->(!EOF())
	If DtoS(SD2->D2_EMISSAO) >= '20120101'
		if SD2->D2_FILIAL = "01LAT04"
			if SD2->D2_TES $ "506/509"
				_xfil := SD2->D2_FILIAL
				_TES  := SD2->D2_TES
				_COF  := " "
				_PIS  := " "
				
				DbSelectArea("SF4")
				SF4->(DbSetOrder(1))
				SF4->(DbGoTop())
				If dbSeek(_xFil + _TES)
					If !(SF4->F4_PISCRED) $ "3"
						IF SF4->F4_CSTCOF = "06"
							_COF := SF4->F4_CSTCOF
							_PIS := SF4->F4_CSTPIS
						ENDIF
					EndIf
				EndIf
				If !EMPTY(_COF) .OR. !EMPTY(_PIS)
					DbSelectArea("SD2")
					RecLock("SD2",.F.)
					SD2->D2_BASIMP6  := SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_DESPESA// PIS
					SD2->D2_VALIMP6  := (((SD2->D2_TOTAL + SD2->D2_VALFRE)  * 0.65) / 100)    // PIS
					SD2->D2_ALQIMP6  := 0.65
					SD2->D2_BASIMP5  := SD2->D2_TOTAL + SD2->D2_VALFRE  + SD2->D2_DESPESA // COFINS
					SD2->D2_VALIMP5  := (((SD2->D2_TOTAL + SD2->D2_VALFRE) * 3.00)  / 100)    // COFINS
					SD2->D2_ALQIMP5  := 3.00
					SD2->(MsunLock())
				EndIf
			Endif
		EndIf
	ENDIF
	SD2->(dbSkip())
EndDo
Alert("Processamento SD2 Finalizado . . . ")
Return
