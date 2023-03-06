#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M440STTS     ºAutor ³Alexandre LonghinottiºData ³ 23/09/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Bloqueia o pedido de venda caso a condição de pagamento do º±±
±±º          ³ pedido esteja diferente da que esta no cadastro do cliente º±±
±±º          ³ ou haja uma mensagem no pedido destinada ao credito.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M440STTS()
************************
Local aArea         := SC5->( GetArea() )
//Local aArea2        := { }
//Local cCond         := ""
//Local pCond         := ""
Local cStatus       := ""
Local cBlStat       := ""
Local cNWStatus     := Space( TamSX3( "C9_BLCRED" )[ 1 ] )
//Local lFlag 		:= .F.
//Local nDesconto		:= GETMV( "MV_DESCPED" )
Local cTpOperacao   := GetMV("MV_TPREMLC")
Local BlqEst		:= GetMV("MV_BLQEST")
Local cFormapg		:= POSICIONE("SCV",1,xFilial("SC5")+SC5->C5_NUM,"CV_FORMAPG")
Local cMV_TOPBONI   := AllTRIM(GetMV("MV_TOPBONI"))  // Tipos de Oeperações de Bonificação 
Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Operações de Venda


dBSelectArea( "SC9" )
SC9->( dBSetOrder( 2 ) )

dBSelectArea( "SC5" )
If Empty( SC5->C5_X_MCRED )
	cBlStat := SC5->C5_X_BLSTA
	
	If Empty( cBlStat )
		SC9->( dBGoTop(  ) )
		SC9->( MsSeek( xFilial( "SC9" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_NUM  ) )
		
		While !SC9->( Eof( ) ) .And. SC9->C9_PEDIDO == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. ( ( SC5->C5_CLIENTE + SC5->C5_LOJACLI ) == ( SC9->C9_CLIENTE + SC9->C9_LOJA ) )
			cStatus   := SC9->C9_BLCRED
			cNWStatus := SC9->C9_BLCRED
			
			If !Empty( SC9->C9_BLCRED )
				If SC5->C5_X_BLSTA <> cStatus
					RecLock( "SC5", .F. )
					SC5->C5_X_BLSTA := cStatus
					SC5->( MsUnLock( ) )
				Endif
			EndIf
			
			SC9->( dBSkip( ) )
		Enddo
	EndIf
	If ( SC5->C5_TIPO == "N" ) .AND. SC5->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN)
		If ( SC5->C5_CONDPAG == SA1->A1_COND )
			SC9->( dBGoTop(  ) )
			SC9->( MsSeek( xFilial( "SC9" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_NUM  ) )
			
			While !SC9->( Eof( ) ) .And. SC9->C9_PEDIDO == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. ( ( SC5->C5_CLIENTE + SC5->C5_LOJACLI ) == ( SC9->C9_CLIENTE + SC9->C9_LOJA ) )
				
				If ALLTRIM(cFormapg) == "R$" .AND. SC5->C5_CONDPAG == "000"
					RecLock( "SC9", .F. )
					SC9->C9_BLCRED := ""
					SC9->( MsUnLock( ) )
					
				ElseIf SC9->C9_BLCRED <> cNWStatus
					RecLock( "SC9", .F. )
					SC9->C9_BLCRED := cNWStatus
					SC9->( MsUnLock( ) )
				Endif
											
				SC9->( dBSkip( ) )
								
			Enddo
			
			RecLock( "SC5", .F. )
			SC5->C5_X_MCRE2 := Space( TamSX3( "C5_X_MCRE2" )[ 1 ] )
			SC5->C5_X_BLSTA := Space( TamSX3( "C5_X_BLSTA" )[ 1 ] )
			SC5->( MsUnLock( ) )
			
			
		
		Else
			
			SC9->( dBGoTop(  ) )
			SC9->( MsSeek( xFilial( "SC9" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_NUM  ) )
			
			While !SC9->( Eof( ) ) .And. SC9->C9_PEDIDO == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. ( ( SC5->C5_CLIENTE + SC5->C5_LOJACLI ) == ( SC9->C9_CLIENTE + SC9->C9_LOJA ) )
				If SC9->C9_BLCRED <> "01"
					RecLock( "SC9", .F. )
					SC9->C9_BLCRED  := "01"
					SC9->( MsUnLock( ) )
				Endif
				SC9->( dBSkip( ) )
			Enddo
			
			RecLock( "SC5", .F. )
			SC5->C5_X_BLSTA := Space( TamSX3( "C5_X_BLSTA" )[ 1 ] )
			SC5->C5_X_MCRE2 := "COND. PAGAMENTO DO PEDIDO DIFERENTE DO CADASTRO DO CLIENTE!"
			SC5->( MsUnLock( ) )
			
		EndIf
	EndIf
Else
	SC9->( dBGoTop(  ) )
	SC9->( MsSeek( xFilial( "SC9" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_NUM  ) )
	
	While !SC9->( Eof( ) ) .And. SC9->C9_PEDIDO == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. ( ( SC5->C5_CLIENTE + SC5->C5_LOJACLI ) == ( SC9->C9_CLIENTE + SC9->C9_LOJA ) )
		If SC9->C9_BLCRED <> "01"
			RecLock( "SC9", .F. )
			SC9->C9_BLCRED := "01"
			SC9->( MsUnLock( ) )
		Endif
		SC9->( dBSkip( ) )
	Enddo
	
EndIf

If ( ( SC5->C5_CLIENTE == "05341357 " ) .Or. ( SC5->C5_OPER $ cTpOperacao ) .OR. ( SC5->C5_TABELA $ "999/998/997/996" ) )
	SC9->( dBGoTop(  ) )
	SC9->( MsSeek( xFilial( "SC9" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_NUM  ) )
	
	While !SC9->( Eof( ) ) .And. SC9->C9_PEDIDO == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. ( ( SC5->C5_CLIENTE + SC5->C5_LOJACLI ) == ( SC9->C9_CLIENTE + SC9->C9_LOJA ) )
		RecLock( "SC9", .F. )
		SC9->C9_BLCRED := Space( TamSX3( "C9_BLCRED" )[ 1 ] )
		SC9->( MsUnLock( ) )
		SC9->( dBSkip( ) )
	Enddo
EndIf

If SF4->F4_ESTOQUE == "S" .AND. !VALEST02(SC5->C5_NUM)
	dbSelectArea("SC9")
	dbSetOrder(1)
   	dbSeek(xFilial("SC9")+SC5->C5_NUM)	
	While !SC9->( Eof( ) ) .And. SC9->C9_PEDIDO == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. ( ( SC5->C5_CLIENTE + SC5->C5_LOJACLI ) == ( SC9->C9_CLIENTE + SC9->C9_LOJA ) )
			RecLock( "SC9", .F. )
			SC9->C9_BLEST  := "02"
			SC9->( MsUnLock( ) )
		SC9->( dBSkip( ) )
	Enddo
	                                 
EndIf


RestArea( aArea )

Return

//============================================================================\
/*/{Protheus.doc}VALEST02
  ==============================================================================
	@description
	Verifica saldo do produto a ser liberado pra possível bloqueio de estoque

	@author Alexandre Longhinotti <ti@tresbarras.ind.br>
	@version 1.0
	@since 14/12/2020

/*/
//============================================================================\

Static Function VALEST02(cNUMPED)
***********************                     
Local aAreaTMP := GetArea()
Local lRet := .T.
Local lCheckEST := SuperGetMV("MV_X_ESTPV",,.T.)
Local nMatura := 0
Local nSaldo := 0

If lCheckEST .AND. SC6->C6_LOCAL $ ("02/03/04")
   dbSelectArea("SC9")
   dbSetOrder(1)
   dbSeek(xFilial("SC9")+cNUMPED)
   While !SC9->(EOF()) .AND. SC9->(C9_FILIAL+C9_PEDIDO) == xFilial("SC9")+cNUMPED
	   dbSelectArea("SB2")
   	   dbSetOrder(1)
   	   dbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL)
	   IF ( SC9->C9_PRODUTO >= "00020001" .AND. SC9->C9_PRODUTO <= "00029999" )
			dbSelectArea("SZ4")
			dbSetOrder(3)
			dbGoTop()
   	   		If dbSeek ( xFilial("SZ4") + ALLTRIM(SC9->C9_PRODUTO) )
				While !SZ4->(EOF()) .AND. ALLTRIM(SZ4->(Z4_PA)) == ALLTRIM(SC9->C9_PRODUTO)
					If SZ4->(Z4_APONTAD) == "N"
						nMatura += SZ4->(Z4_KG)
					EndIf
					SZ4->(dbSkip())
				EndDo
				nSALDO := SaldoSB2() - nMatura
			Else
				nSALDO := SaldoSB2()
	   		EndIf
	   Else
		   	nSALDO := SaldoSB2()
	   EndIf
	   If SC9->C9_QTDLIB > nSALDO
				lRet := .F.
			Exit
	   Endif
       SC9->(dbSkip())
    Enddo
EndIf
RestArea(aAreaTMP)

Return(lRet)

// FIM da Funcao VALEST02
//==============================================================================
