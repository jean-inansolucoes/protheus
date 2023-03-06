#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410PVNF     ºAutor ³Alexandre LonghinottiºData ³ 31/05/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Libera o pedido do estoque na emissão da NF quando se trataº±±
±±º          ³ de vendas para funionários       						  º±±
±±º          ³ 														      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function M410PVNF()
************************
Local cFunc 	 	:= POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_X_FUNC")
Local lRet := .T.
If(!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ))
	If !Empty( cFunc ) .OR. SC5->C5_CONDPAG == "902"
		
		dBSelectArea( "SC9" )
		SC9->( dBSetOrder( 2 ) )
		SC9->( dBGoTop(  ) )
		SC9->( MsSeek( xFilial( "SC9" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_NUM  ) )
		While !SC9->( Eof( ) ) .And. SC9->C9_PEDIDO == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. ( ( SC5->C5_CLIENTE + SC5->C5_LOJACLI ) == ( SC9->C9_CLIENTE + SC9->C9_LOJA ) )
			
			If !Empty( SC9->C9_BLEST )
				RecLock( "SC9", .F. )
				SC9->C9_BLEST := ""
				SC9->( MsUnLock( ) )				
			EndIf
			dbSelectArea('SC6')
			SC6->(dbSetOrder(1))
			SC6->(dbGoTop())
			If SC6->(dbSeek(xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM))
				If SC6->C6_PRCVEN <> SC6->C6_PRUNIT .and. SC6->C6_PRUNIT > 0
					RecLock('SC6',.F.)
					SC6->C6_PRCVEN := SC6->C6_PRUNIT
					If (SC6->C6_QTDVEN) > 0
						SC6->C6_VALOR := SC6->C6_QTDVEN * SC6->C6_PRCVEN
					EndIf
					SC6->(MsUnlock())
					RecLock('SC9',.F.)
					SC9->C9_PRCVEN := SC6->C6_PRUNIT
					SC9->(MsUnlock())
				EndIf
			EndIf
			SC9->( dBSkip( ) )
		Enddo
	EndIf
Else
	Alert("O Pedido deve estar liberado para preparar o documento de saída!")
	lRet := .F.
EndIf


Return( lRet )
