#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}FT210OPC
  ==============================================================================
    @description
    PE chamado ap?s todas as transa??es do PV terem sido finalizadas

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 15/09/2020

/*/
//============================================================================\
User Function FT210OPC(  )

	Local _aGrpUsr      := UsrRetGrp()
	Local nI            := 0
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Opera??es de Venda
	Local _cNivel       := ''
	Local _lLibVld 		:= .F.
	Local _lLibGer 		:= .F.
	Local _aBlqs    := {}
	Local _aMots    := {}
	Local _nPosMot  := 0
	Local _cMsgLib  := ''
	Local _nRet  	:= 1
	Private _cNivelLib  := ''
	Private _cGrpUsr    := ''


	_nRet := U_LT210VIS()

	If _nRet == 1
		dbSelectArea('ZAM')
		ZAM->(dbSetOrder(2))

		For nI := 1 To Len(_aGrpUsr)
			ZAM->(dbGoTop())
			If ZAM->(dbSeek(xFilial('ZAM')+_aGrpUsr[nI]))
				_cGrpUsr := IIF(ZAM->ZAM_NIVEL > _cGrpUsr, ZAM->ZAM_GRPUSR,_cGrpUsr)
				_cNivelLib := IIF(ZAM->ZAM_NIVEL > _cNivel, ZAM->ZAM_NIVEL,_cNivel)
			EndIf
		Next nI

		ZAM->(dbGoTop())
		If ZAM->(dbSeek(xFilial('ZAM')+_cGrpUsr))
			_lLibGer := ZAM->ZAM_LIBGER == 'S'
			_lLibVld := ZAM->ZAM_VALID == 'S'
		EndIf

		dbSelectArea('ZAI')

		If SC5->C5_OPER $ (cMV_TOPEVEN) .AND. ( Alltrim(FunName()) == "FATA210" .or. IsInCallStack("U_ICGERPED") )// Inclus?o / Altera??o / C?pia

			_cNivel := U_LTBNIVELIB()
			// Desconto do pedido ? maior que o desconto permitido para o canal de venda
			If !Empty(_cNivel) .AND. SC5->C5_OPER $ GetMv("MV_TOPEVEN")
				If _cNivel > _cNivelLib
					MsgAlert("Este Pedido est? fora da sua Al?ada para libera??o!" +chr(10) +chr(13) + "Seu n?vel ?: " + _cNivelLib +chr(10) +chr(13) + "Nivel de bloqueio ?: " + _cNivel )
					RecLock('SC5',.F.)
					SC5->C5_BLQ := "1"
					SC5->(MsUnlock())
					BLOQUEIAPV()
					_nRet  	:= 0
				else
					RecLock('SC5',.F.)
					SC5->C5_BLQ := ""
					SC5->(MsUnlock())

					ZAI->(dbSetOrder(1))
					ZAI->(dbGoTop())
					If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+"1"))
						RecLock('ZAI',.F.)
						If ZAI->ZAI_MOTBLQ == '1'
							ZAI->ZAI_OPER   := '1'
							ZAI->ZAI_DTOPER := dDataBase
							ZAI->ZAI_USER   := RetCodUsr()

						ENDIF
						ZAI->(MsUnlock())
					EndIf

					LIBERAPV()
					U_LTBFAT07()


					If _lLibGer

						ZAI->(dbSetOrder(1))
						ZAI->(dbGoTop())
						ZAI->(dbseek(xFilial("ZAI")+SC5->C5_NUM))
						While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial("ZAI")+SC5->C5_NUM
							If Empty(ZAI->ZAI_OPER) .AND. ZAI->ZAI_NIVEL <= _cNivel
								If ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9'
									aAdd(_aBlqs,ZAI->(Recno()))
									_nPosMot := aScan(_aMots,{|x| x==ZAI->ZAI_MOTBLQ})
									If _nPosMot <= 0
										aAdd(_aMots,ZAI->ZAI_MOTBLQ)
									EndIf
								EndIf

							EndIf
							ZAI->(dbSkip())
						EndDo
						If Len(_aMots) > 0
							_cMsgLib := "Aten??o! O pedido selecionado possui outros bloqueios detalhados abaixo. Deseja liber?-los tamb?m?" +chr(10) +chr(13)

							For nI := 1 To Len(_aMots)
								If _aMots[nI] == '1'
									_cMsgLib += "Bloqueio por Desconto" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '2'
									_cMsgLib += "Pedido fora do prazo de validade" + chr(10) + chr(13)
									_lblqVal := .T.
								ElseIf _aMots[nI] == '3'
									_cMsgLib += "Opera??o tipo Bonifica??o, Doa??o ou Amostra Gr?tis" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '4'
									_cMsgLib += "Comiss?o no Ped. ? diferente da definida no vendedor" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '5'
									_cMsgLib += "Vendedor informado no pedido difere do preenchido no cliente" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '6'
									_cMsgLib += "Peso do pedido n?o atinge o m?nimo para frete CIF" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '7'
									_cMsgLib += "Opera??o do tipo Remessa consignada" + chr(10) + chr(13)
								EndIf
							Next nI
							If(ApMsgNoYes(_cMsgLib))
								U_LTB03LIB()
							EndIf
						EndIf
					EndIf
				EndIf

			else
				RecLock('SC5',.F.)
				SC5->C5_BLQ := ""
				SC5->(MsUnlock())

				dbSelectArea('ZAI')
				ZAI->(dbSetOrder(1))
				ZAI->(dbGoTop())
				If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+"1"))
					RecLock('ZAI',.F.)
					If ZAI->ZAI_MOTBLQ == '1'
						ZAI->ZAI_OPER   := '1'
						ZAI->ZAI_DTOPER := dDataBase
						ZAI->ZAI_USER   := RetCodUsr()

					ENDIF
					ZAI->(MsUnlock())
				EndIf

				LIBERAPV()				
				U_LTBFAT07()

				If _lLibGer
					ZAI->(dbSetOrder(1))
					ZAI->(dbGoTop())
					ZAI->(dbseek(xFilial("ZAI")+SC5->C5_NUM))
					While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial("ZAI")+SC5->C5_NUM
						If Empty(ZAI->ZAI_OPER) .AND. ZAI->ZAI_NIVEL <= _cNivel
							If ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9'
								aAdd(_aBlqs,ZAI->(Recno()))
								_nPosMot := aScan(_aMots,{|x| x==ZAI->ZAI_MOTBLQ})
								If _nPosMot <= 0
									aAdd(_aMots,ZAI->ZAI_MOTBLQ)
								EndIf
							EndIf

						EndIf
						ZAI->(dbSkip())
					EndDo

					If Len(_aMots) > 0
						_cMsgLib := "Aten??o! O pedido selecionado possui outros bloqueios detalhados abaixo. Deseja liber?-los tamb?m?" +chr(10) +chr(13)

						For nI := 1 To Len(_aMots)
							If _aMots[nI] == '1'
								_cMsgLib += "Bloqueio por Desconto" + chr(10) + chr(13)
							ElseIf _aMots[nI] == '2'
								_cMsgLib += "Pedido fora do prazo de validade" + chr(10) + chr(13)
								_lblqVal := .T.
							ElseIf _aMots[nI] == '3'
								_cMsgLib += "Opera??o tipo Bonifica??o, Doa??o ou Amostra Gr?tis" + chr(10) + chr(13)
							ElseIf _aMots[nI] == '4'
								_cMsgLib += "Comiss?o no Ped. ? diferente da definida no vendedor" + chr(10) + chr(13)
							ElseIf _aMots[nI] == '5'
								_cMsgLib += "Vendedor informado no pedido difere do preenchido no cliente" + chr(10) + chr(13)
							ElseIf _aMots[nI] == '6'
								_cMsgLib += "Peso do pedido n?o atinge o m?nimo para frete CIF" + chr(10) + chr(13)
							EndIf
						Next nI
						If(ApMsgNoYes(_cMsgLib))
							U_LTB03LIB()
						EndIf
					EndIf
				EndIf
			EndIf

		Else
			LIBERAPV()
		EndIf
	EndIf
Return 

// buscal n?vel de bloqueio do PV 
User Function LTBNIVELIB()

	Local _cCanal  		:= POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_X_CANAL")
	Local nAcordo       := POSICIONE( "SA1",1,XFILIAL( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"SA1->A1_X_DESCF")
	Local _aDescGrp     := {}
	Local _nPosGrp      := 0
	Local _cGrupo       := ''
	Local _cNivel 		:= ''
	Local nI	        := 0

	//************ VALIDA??O DE DESCONTOS **************//
	// Se desconto de algum item for maior que o permitido no canal de venda do cliente

	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))
	SC6->(dbGoTop())
	If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
		While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM

			_cGrupo := Posicione('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_GRUPO')

			_nPosGrp := aScan(_aDescGrp,{|x| x[1] == _cGrupo})

			If nAcordo > 15
				
					If _nPosGrp > 0
						_aDescGrp[_nPosGrp,2] := Max(_aDescGrp[_nPosGrp,2],ROUND(((((SC6->C6_X_PTB-(SC6->C6_PRCVEN-(SC6->C6_PRCVEN*nAcordo/100)))/SC6->C6_X_PTB)*100)+nAcordo),2))
					Else
						aAdd(_aDescGrp,{_cGrupo,ROUND((((SC6->C6_X_PTB-(SC6->C6_PRCVEN-(SC6->C6_PRCVEN*nAcordo/100)))/SC6->C6_X_PTB)*100)+nAcordo,2),'', ALLTRIM(SC6->C6_PRODUTO)})
					EndIf
				
			Else
				If SC6->C6_X_DESC > 0
					If _nPosGrp > 0
						_aDescGrp[_nPosGrp,2] := Max(_aDescGrp[_nPosGrp,2],SC6->C6_X_DESC)
					Else
						aAdd(_aDescGrp,{_cGrupo,SC6->C6_X_DESC,'', ALLTRIM(SC6->C6_PRODUTO)})
					EndIf
				EndIf
			EndiF

			SC6->(dbSkip())

		EndDo
	EndIf

	dbSelectArea('ZAH')
	ZAH->(dbSetOrder(2))

	For nI := 1 To LeN(_aDescGrp)
		ZAH->(dbGoTop())
		If ZAH->(dbSeek(xFilial('ZAH')+_cCanal+_aDescGrp[nI,1]))
			While ZAH->(!Eof()) .And. ZAH->ZAH_FILIAL+ZAH->ZAH_CANAL+ZAH->ZAH_GRUPO == xFilial('ZAH')+_cCanal+_aDescGrp[nI,1]
				If ZAH->ZAH_DATE >= _aDescGrp[nI,2]
					_cNivel := IIF(ZAH->ZAH_NIVEL>_cNivel,ZAH->ZAH_NIVEL,_cNivel)
					Exit
				EndIf
				ZAH->(DbSkip())
			EndDo
		EndIf
	Next nI

	If Empty(_cNivel) .AND. Len(_aDescGrp) > 0
		_cNivel := 'ZZ'
	EndIf

return _cNivel

User Function LT210VIS()
	Local _nRet := 0
	_nRet := A410Visual('SC5',SC5->(Recno()),2)
Return _nRet


Static Function LIBERAPV()
	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))
	SC6->(dbGoTop())
	If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
		While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM
			RecLock('SC6',.F.)
			SC6->C6_BLOQUEI := ""
			SC6->(MsUnlock())
			SC6->(dbSkip())
		EndDo
		RecLock('SC5',.F.)
			SC5->C5_BLQ := ""
		SC5->(MsUnlock())
	EndIf
Return

Static Function BLOQUEIAPV()
	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))
	SC6->(dbGoTop())
	If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
		While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM

			RecLock('SC6',.F.)
			SC6->C6_BLOQUEI := "01"
			SC6->(MsUnlock())

			SC6->(dbSkip())
		EndDo
	EndIf
Return
