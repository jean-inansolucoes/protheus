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
±±³Descri‡…o ³Acerta Qtd Reservada SB2			                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**------------------------------------------------------------------**
USER FUNCTION LSOMS08()
**------------------------------------------------------------------**
Private nReserv := 0


cPerg    := "LSOMS00008"

If !Pergunte( cPerg,.T., "Parâmetros - Reserva SB2" )
	Set Filter to
	Return
Endif

If (ApMsgNoYes("Atenção isso irá alterar a quantidade reservada do produto na SB2 (Tabela de Saldos), deseja Continuar?", "Alteração Reserva SB2" ))
	cFilSB1 := "SB1->B1_COD >= '"+ mv_par03	+"' .AND. SB1->B1_COD <= '"+ mv_par04	+"' .AND. SB1->B1_TIPO = 'PA' .AND. SB1->B1_MSBLQL = '2'		  "
	
	dbSelectArea("SB1")
	SET FILTER TO &(cFilSB1)
	SB1->(dbGoTop())
	While !SB1->(EOF())
		nReserv := 0
		cFilSC9 := "SC9->C9_FILIAL = '"+ mv_par01	+"' .AND. SC9->C9_LOCAL = '"+ mv_par02	+"' .AND. SC9->C9_PRODUTO = '"+ SB1->B1_COD	+"' .AND. SC9->C9_NFISCAL = '         ' .AND. SC9->C9_BLEST <> '02'		  "
		cFilSB2 := "SB2->B2_FILIAL = '"+ mv_par01	+"' .AND. SB2->B2_LOCAL = '"+ mv_par02	+"' .AND. SB2->B2_COD = '"+ SB1->B1_COD	+"'		  "

		dbSelectArea("SC9")
		SET FILTER TO &(cFilSC9)
		SC9->(dbGoTop())
		While !SC9->(EOF())
			If RecLock("SC9",.F.)
				nReserv += SC9->C9_QTDLIB
				SC9->(MsUnLock())
			EndIf
			SC9->(dbSkip())
		Enddo
		SET FILTER TO

		dbSelectArea("SB2")
		SET FILTER TO &(cFilSB2)
		SB2->(dbGoTop())
		While !SB2->(EOF())
			If RecLock("SB2",.F.)
				SB2->B2_RESERVA := nReserv
				SB2->(MsUnLock())
			EndIf
			SB2->(dbSkip())
		Enddo
		SET FILTER TO
		SB1->(dbSkip())
	Enddo
	SET FILTER TO
EndIf

Aviso("Aviso","Processo concluído!",{"OK"})

Return()

