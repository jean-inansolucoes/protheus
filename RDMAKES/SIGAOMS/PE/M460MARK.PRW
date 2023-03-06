#include 'protheus.ch'
#include 'parmtype.ch'

User Function M460MARK()
	Local cMark := PARAMIXB[1] // MARCA UTILIZADA
	Local lInvert := PARAMIXB[2] // SELECIONOU "MARCA TODOS"
	Local aArea := GetArea("SC9")
	Local _aAreaSC5 := GetArea("SC5")
	Local _lRet     := .T.
	Local _aBlq     := {}
	Local _nPos     := 0
	Local nI        := 0
	Local _cPed     := ''
	Local _cMsg     := "Atenção! Os pedidos abaixo estão bloqueados por Regra de Desconto. Verifique!" + chr(10) + chr(13)
	Local _cPedido  := SC9->C9_PEDIDO

	While (SC9->(!EOF())) .AND. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial('SC9')+_cPedido
		_cPed := ''
		If lInvert .AND. !SC9->(IsMark("C9_OK")) // "CHECK ALL" OPTION SELECTED

			_cPed := SC9->C9_PEDIDO
		ElseIf !lInvert .AND. SC9->(IsMark("C9_OK")) // "CHECK ALL" OPTION NOT SELECTED
			_cPed := SC9->C9_PEDIDO
		EndIf

		_nPos := aScan(_aBlq,{|x| x == _cPed})
		If _nPos <= 0
			dbSelectArea('SC5')
			SC5->(dbSetOrder(1))
			SC5->(dbGoTop())
			If SC5->(dbSeek(xFilial('SC5')+_cPed))
				If (!Empty(_cPed))
					/*If Empty(SC5->C5_X_VLD)
						RecLock('SC5',.F.)
						SC5->C5_X_VLD := LastDay(SC5->C5_FECENT)
						SC5->(MsUnlock())
					EndIf*/

					dbSelectArea('SC6')
					SC6->(dbSetOrder(1))
					SC6->(dbGoTop())
					If SC6->(dbSeek(xFilial('SC6')+_cPed))
						While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+_cPed
							RecLock('SC6',.F.)
							IF SC6->C6_DESCONT > 0
								AAdd(_aBlq,_cPed)
							EndIf
							SC6->(MsUnlock())
							SC6->(dbSkip())
						EndDo
					EndIf

					If SC5->C5_BLQ $ '8/9'
						AAdd(_aBlq,_cPed)

						// Se tentar faturar pedido fora do prazo de validade, faço o bloqueio
					Else//If SC5->C5_X_VLD < dDataBase
						/*RecLock('SC5',.F.)
						SC5->C5_BLQ := '8'
						SC5->(MsUnlock())

						AAdd(_aBlq,_cPed)

						_cCanal := Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_X_CANAL')
						RecLock('ZAI',.T.)
						ZAI->ZAI_FILIAL := xFilial('ZAI')
						ZAI->ZAI_NUM  :=  SC5->C5_NUM
						ZAI->ZAI_MOTBLQ  := '2' // 1 = Desconto; 2 = Validade PV
						ZAI->ZAI_DTBLQ   := dDataBase
						ZAI->ZAI_CANAL   := _cCanal
						ZAI->ZAI_DESCR   := Posicione('ZAG',1,xfilial('ZAG')+_cCanal,'ZAG_DESCR')
						ZAI->ZAI_CLI     := SC5->C5_CLIENTE
						ZAI->ZAI_LOJA    := SC5->C5_LOJACLI
						ZAI->ZAI_NOME    := Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME')
						ZAI->ZAI_VEND    := SC5->C5_VEND1
						ZAI->ZAI_NOMVEN  := Posicione('SA3',1,xFilial('SA3')+SC5->C5_VEND1,'A3_NOME')
						ZAI->ZAI_DESC    := 0
						ZAI->ZAI_VALID   := SC5->C5_X_VLD
						ZAI->ZAI_OPER    := ''
						ZAI->ZAI_JUST    := ''
						ZAI->ZAI_DTOPER  := stod('')
						ZAI->ZAI_USER    := ''
						ZAI->(MsUnlock())*/
					EndIf

				EndIf
			EndIf

			 EndIf
			 
			// Ajuste do preço de venda na SC6
			dbSelectArea('SC6')
			SC6->(dbSetOrder(1))
			SC6->(dbGoTop())
			If SC6->(dbSeek(xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM))
				While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM == xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM
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

					SC6->(DbSkip())
				EndDo

			EndIf
			SC9->(DbSkip())
		EndDo

		If Len(_aBlq) > 0
			_lRet := .F.

			For nI := 1 To Len(_aBlq)
				_cMsg := _cMsg + _aBlq[nI] + chr(10)+chr(13)
			Next nI

			MsgAlert(_cMsg,"Pedidos Bloqueados")
		EndIf

		RestArea(aArea)
		RestArea(_aAreaSC5)
		Return _lRet
