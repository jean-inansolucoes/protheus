#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSOMS04  ºAutor ³ Alexandre Longhinotti ºData ³ 07/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável pela gravação/exibição Historico de .	  º±±
±±             crédito do cliente									      ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    OMS                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
User Function HistCred()
************************
Local cHist      := iif(  Empty( SA1->A1_X_INFOR ), Space( TamSX3( "A1_X_INFOR" )[ 1 ] ), SA1->A1_X_INFOR )
Local lInclui    := iif(  Empty( SA1->A1_X_INFOR ), .T., .F. )
Local lAltera    := iif( !Empty( SA1->A1_X_INFOR ), .T., .F. )
Local cCaption1  := iif( lInclui, "Incluir", "Alterar" )
Local oDlgHist, oGrpHist, oMGet, oSBtnOk, oSBtnCan

If ( SOFTLOCK( "SA1" ) )
	oDlgHist  := MSDialog():New( 091,232,604,910,"  Histórico de Crédito  ",,,.F.,,,,,,.T.,,,.T. )
	oGrpHist  := TGroup():New( 004,004,232,332,"  Histórico de Crédito  ",oDlgHist,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oMGet     := TMultiGet():New( 012,008,{|u| If(PCount()>0,cHist:=u,cHist)},oGrpHist,320,215,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
	oSBtnCan  := TButton():New( 236,296,"Fechar" ,oDlgHist,{ || fHistClose( lInclui, lAltera, cHist, oDlgHist, oSBtnCan ) },037,012,,,,.T.,,"",,,,.F. )
	oSBtnOk   := TButton():New( 236,248,cCaption1,oDlgHist,{ || fHistAction( @oSBtnOk, @oSBtnCan, @oMGet ) } ,037,012,,,,.T.,,"",,,,.F. )
	
	oDlgHist:Activate(,,,.T.)
Endif

Return( NIL )



Static Function fHistAction( poSBtnOk, poSBtnCan, poMGet  )
***********************************************************
poMGet:lReadOnly    := .F.
poSBtnOk:lActive    := .F.
poSBtnCan:cCaption  := "Gravar"
Return( Nil )


Static Function fHistClose( plInclui, plAltera, pcHist, poDlgHist, poSBtnCan )
******************************************************************************
Local nPos := 1

If plInclui .Or. plAltera
	
	If poSBtnCan:cCaption == "Gravar"
		nPos := Aviso( "Atenção !", "Deseja gravar o histórico ?", { "Sim", "Não", "Cancelar" }, 2 )
		
		If nPos == 1
			Reclock( "SA1", .F. )
			SA1->A1_X_INFOR := pcHist
			SA1->( MsUnLock() )
		Endif
		
	Endif
	
	If nPos <> 3
		poDlgHist:End()
	Endif
Else
	poDlgHist:End()
	
EndIf

Return( NIL )
