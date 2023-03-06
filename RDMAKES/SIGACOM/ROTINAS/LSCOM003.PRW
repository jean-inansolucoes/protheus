#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSCOM003 ºAutor ³ Alexandre Longhinotti ºData ³ 04/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável pela gravação/exibição Observacao no.	  º±±
±±             documento de entrada									      ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ Laticinio Silvestre    COM                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
User Function LSCOM003()
************************
//Local cHist      := iif(  Empty( SF1->F1_X_OBSER ), Space( TamSX3( "F1_X_OBSER" )[ 1 ] ), SF1->F1_X_OBSER )
Local lInclui    := iif(  Empty( SF1->F1_X_OBSER ), .T., .F. )
Local lAltera    := iif( !Empty( SF1->F1_X_OBSER ), .T., .F. )
Local cCaption1  := iif( lInclui, "Incluir", "Alterar" )
Local oDlgHist, oGrpHist, oMGet, oSBtnOk, oSBtnCan
Private cHist    := iif(  Empty( SF1->F1_X_OBSER ), Space( TamSX3( "F1_X_OBSER" )[ 1 ] ), SF1->F1_X_OBSER )

If ( SOFTLOCK( "SF1" ) )
	oDlgHist  := MSDialog():New( 091,232,604,910,"  Observação da Nota  ",,,.F.,,,,,,.T.,,,.T. )
	oGrpHist  := TGroup():New( 004,004,232,332,"  Observação da Nota  ",oDlgHist,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oMGet     := TMultiGet():New( 012,008,{|u| If(PCount()>0,cHist:=u,cHist)},oGrpHist,320,215,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
	
	oSBtnCan  := TButton():New( 236,296,"Fechar" ,oDlgHist,{ || fHistClose( lInclui, lAltera, cHist, oDlgHist, oSBtnCan ) },037,012,,,,.T.,,"",,,,.F. )
	
	if( Alltrim(FunName()) == "MATA140" )
		oSBtnOk   := TButton():New( 236,248,cCaption1,oDlgHist,{ || fHistAction( @oSBtnOk, @oSBtnCan, @oMGet ) } ,037,012,,,,.T.,,"",,,,.F. )
	ElseIf !INCLUI
		oSBtnOk   := TButton():New( 236,248,cCaption1,oDlgHist,{ || fHistAction( @oSBtnOk, @oSBtnCan, @oMGet ) } ,037,012,,,,.T.,,"",,,,.F. )
	EndIf
	oDlgHist:Activate(,,,.T.)
Endif

Return( NIL )



Static Function fHistAction( poSBtnOk, poSBtnCan, poMGet  )
***********************************************************
poMGet:lReadOnly    := .F.
poSBtnOk:lActive    := .F.
poSBtnCan:cCaption  := "Gravar"
cHist    := ""
poMGet:Refresh()
Return( Nil )


Static Function fHistClose( plInclui, plAltera, pcHist, poDlgHist, poSBtnCan )
******************************************************************************
Local nPos := 1

If plInclui .Or. plAltera
	
	If poSBtnCan:cCaption == "Gravar"
		nPos := Aviso( "Atenção !", "Deseja gravar a observação ?", { "Sim", "Não", "Cancelar" }, 2 )
		
		If nPos == 1
			Reclock( "SF1", .F. )
			If Empty(alltrim(SF1->F1_X_OBSER))
				SF1->F1_X_OBSER := dtoc(ddatabase) + " : " + CHR(13)+CHR(10) + pcHist + CHR(13)+CHR(10) +" Por: " + UPPER(ALLTRIM(FwGetUserName(__cUserID)))
			else
				SF1->F1_X_OBSER := trim(SF1->F1_X_OBSER) += CHR(13)+CHR(10) + CHR(13)+CHR(10) + dtoc(ddatabase) + " : " + CHR(13)+CHR(10) + pcHist + CHR(13)+CHR(10) +" Por: " + UPPER(ALLTRIM(FwGetUserName(__cUserID)))
			EndIf
			SF1->( MsUnLock() )
		Endif
		
	Endif
	
	If nPos <> 3
		poDlgHist:End()
	Endif
Else
	poDlgHist:End()
	
EndIf

Return( NIL )
