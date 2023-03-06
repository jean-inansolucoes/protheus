#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH"
#define DMPAPER_A4 9
// A4 210 x 297 mm
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LSOMS08   ³ Autor  ³Alexandre      ³ Data ³15.10.2019  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³AJUSTA DESCFIN SE1							                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**------------------------------------------------------------------**
USER FUNCTION LSOMS09()
**------------------------------------------------------------------**
Private nReserv := 0
	
	cFilSE1 := "SE1->E1_TIPO = 'NF' .AND. SE1->E1_DESCFIN > 0 .AND. SE1->E1_DECRESC = 0"
	
	dbSelectArea("SE1")
	SET FILTER TO &(cFilSE1)
	SE1->(dbGoTop())
	While !SE1->(EOF())
		If RecLock("SE1",.F.)
			SE1->E1_DECRESC := ((SE1->E1_VALOR * SE1->E1_DESCFIN) / 100)
			IF EMPTY(SE1->E1_MOVIMEN)
				SE1->E1_SDDECRE := ((SE1->E1_VALOR * SE1->E1_DESCFIN) / 100)
			ENDIF
			SE1->(MsUnLock())
		EndIf
		SE1->( dbSkip() )
	Enddo
	SET FILTER TO

Return()

