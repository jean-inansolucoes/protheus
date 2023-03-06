#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA455E   ºAutor  ³Lincoln Rossetto    º Data ³  09/01/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada responsavel por forçar o bloqueio por es- º±±
±±ºDesc.     ³ toque e exibir mensagem casos exista                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA455E()
***********************                     
Local aAreaTMP := GetArea()
Local lRet := 1
Local lCheckEST := SuperGetMV("MV_X_ESTPV",,.T.)
Local cNUMPED := SC9->C9_PEDIDO
Local nMatura := 0
Local nSaldo := 0

If lCheckEST .AND. SC9->C9_LOCAL $ ("02/03/04")
   dbSelectArea("SC9")
   dbSetOrder(1)
   dbSeek(xFilial("SC9")+cNUMPED)
   While !SC9->(EOF()) .AND. SC9->(C9_FILIAL+C9_PEDIDO) == xFilial("SC9")+cNUMPED .AND. SC9->C9_BLEST == "02"
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
	   If SC9->C9_QTDLIB > nSALDO .AND. !EMPTY(SC5->C5_OPER)
			ShowHelpDlg( "Desbloqueio impossivel",;
				     { "Não foi possivel desbloquear o item " + SC9->C9_PRODUTO + " do pedido " + SC9->C9_PEDIDO + " pois o mesmo esta com saldo: " + chr(10) + chr(13) + "[" + ;
				       Transform( nSALDO, PesqPict("SB2","B2_QATU",14) ) + "]"}, 5,;
				     { "1.) Verifique o produto;" + chr(10) + chr(13) +;
				       "2.) Verifique o pedido."}, 5)
			lRet := 2    
			Exit
	   Endif
       SC9->(dbSkip())
    Enddo
Else
   dbSelectArea("SC9")
   dbSetOrder(1)
   dbGoTop()
   dbSeek(xFilial("SC9")+cNUMPED)
   While !SC9->(EOF()) .AND. SC9->(C9_FILIAL+C9_PEDIDO) == xFilial("SC9")+cNUMPED .AND. SC9->C9_BLEST == "02"  
		If RecLock("SC9",.F.)
			SC9->C9_BLEST := ""		
			SC9->(MsUnLock())         			
		EndIf
   		SC9->(dbSkip())
   Enddo  
Endif

RestArea(aAreaTMP)

Return( lRet )
