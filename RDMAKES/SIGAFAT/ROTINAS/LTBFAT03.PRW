#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include 'FWMVCDef.ch'
#DEFINE ITENSSC6 300
Static cTitulo 	:= "Liberação de Pedidos por Alçada"
Static _lAdm 	:= .F.
Static __aContCache:= Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTBFAT03  ºAutor  ³FSW TOTVS CASCAVEL   º Data ³ 16/09/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Liberação de Pedidos Bloq por Desconto ou Validadeº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico LTB                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LTBFAT03()

	Local oBrowse    	:= Nil
	Local cAlias		:= 'ZAI'
	Local _aGrpUsr      := UsrRetGrp()
	Local nI            := 0
	Private cCadastro	:= 'Pedidos de Venda Bloqueados por Alçada'
	Private _cNivel     := ''
	Private _cGrpUsr    := ''


	dbSelectArea('ZAM')
	ZAM->(dbSetOrder(2))

	For nI := 1 To Len(_aGrpUsr)
		ZAM->(dbGoTop())
		If ZAM->(dbSeek(xFilial('ZAM')+_aGrpUsr[nI]))
			_cGrpUsr := IIF(ZAM->ZAM_NIVEL > _cGrpUsr, ZAM->ZAM_GRPUSR,_cGrpUsr)
			_cNivel := IIF(ZAM->ZAM_NIVEL > _cNivel, ZAM->ZAM_NIVEL,_cNivel)
		EndIf
	Next nI

	dbSelectArea('ZAI')


	Private aRotina:= MenuDef()
	oBrowse:= BrowseDef(cAlias)


	oBrowse:SetFilterDefault( "@" + FiltraPV() )


	oBrowse:Activate()

Return

Static Function FiltraPV()

	Local cQuery:= " EXISTS (
	cQuery += " SELECT 1
	cQuery += " FROM ZAH010 ZAH  ,

	cQuery += "      ZAM010 ZAM
	cQuery += " WHERE
	cQuery += "     ZAH.D_E_L_E_T_ = ' '
	cQuery += "     AND ZAM.D_E_L_E_T_ = ' '
	cQuery += "     AND ZAM_GRPUSR = '"+_cGrpUsr+"'
	cQuery += "     AND ZAH_APROV = '"+_cGrpUsr+"'
	cQuery += "     AND ZAH_CANAL = ZAI_CANAL
	//cQuery += "     AND ( ZAH_NIVEL >= ZAI_NIVEL AND ZAH_NIVEL = '"+_cNivel+"' AND ZAI_MOTBLQ = '1'OR ZAI_MOTBLQ = '2' AND ZAM_VALID = 'S' OR ZAI_MOTBLQ IN ('3','4','5','6') AND ZAM_LIBGER = 'S')
	cQuery += "     AND ( ZAI_MOTBLQ = '2' AND ZAM_VALID = 'S' OR ZAI_MOTBLQ IN ('3','4','5','6','7'))
	cQuery += " ) "

Return ( cQuery )
// FIM da Funcao FiltraEquipe
//======================================================================================================================



Static Function BrowseDef(cAlias)
	Local oBrowse := FWMBrowse():New()

	oBrowse:SetAlias(cAlias)
	oBrowse:SetDescription(cCadastro)


	oBrowse:AddLegend( "ZAI->ZAI_MOTBLQ == '1' .AND. EMPTY(ZAI->ZAI_OPER)"		, "RED"	        ,	"Ped. Bloqueado por Desconto" )
	oBrowse:AddLegend( "ZAI->ZAI_MOTBLQ == '2' .AND. EMPTY(ZAI->ZAI_OPER)"		, "YELLOW"	    ,	"Ped. Bloqueado por Validade" )
	oBrowse:AddLegend( "ZAI->ZAI_MOTBLQ == '3' .AND. EMPTY(ZAI->ZAI_OPER)"		, "PINK"	    ,	"Ped. Bloq. - Bonif./Doação/Amostra" )
	oBrowse:AddLegend( "ZAI->ZAI_MOTBLQ == '4' .AND. EMPTY(ZAI->ZAI_OPER)"		, "GREEN"	    ,	"Ped. Bloq. - Comis. PV é dif. do vendedor" )
	oBrowse:AddLegend( "ZAI->ZAI_MOTBLQ == '5' .AND. EMPTY(ZAI->ZAI_OPER)"		, "WHITE"	    ,	"Ped. Bloq. - Vendedor do PV é dif. do Cad. Cliente" )
	oBrowse:AddLegend( "ZAI->ZAI_MOTBLQ == '6' .AND. EMPTY(ZAI->ZAI_OPER)"		, "BLUE"	    ,	"Ped. com frete CIF bloqueado por Peso" )
	oBrowse:AddLegend( "ZAI->ZAI_MOTBLQ == '7' .AND. EMPTY(ZAI->ZAI_OPER)"		, "BR_MARROM"	,	"Ped. Bloq. - Remessa Consignada" )
	oBrowse:AddLegend( "ZAI->ZAI_OPER == '1' "		                            , "GRAY"	    ,	"Liberação Realizada" )
	oBrowse:AddLegend( "ZAI->ZAI_OPER == '2' "		                            , "BLACK"	    ,	"Liberação Rejeitada" )
	/*oBrowse:AddLegend( "ZR1->ZR1_STATUS == '3'"									, "RED"		,	"Recebido Administrativo" )
	oBrowse:AddLegend( "ZR1->ZR1_STATUS == '4' .AND. !EMPTY(ZR1->ZR1_DTPRT)"	, "BLACK"	,	"OS Faturada" )
	oBrowse:AddLegend( "ZR1->ZR1_STATUS == '5'"									, "BLUE"	,	"OS Liberada p/ Fatur., Não receb. pelo adm." )
	oBrowse:AddLegend( "ZR1->ZR1_STATUS == '4' .AND. EMPTY(ZR1->ZR1_DTPRT)"		, "PINK"	,	"OS Faturada Não Protocolada" )
	 */
     /*
     ZAI_MOTBLQ = 1 -> Ped. Bloqueado por Desconto
     ZAI_MOTBLQ = 2 -> Ped. Bloqueado por Validade
     ZAI_MOTBLQ = 3 -> Ped. Bloq. - Bonif./Doação/Amostra
     ZAI_MOTBLQ = 4 -> Ped. Bloq. - Comis. PV é dif. do vendedor
     ZAI_MOTBLQ = 5 -> Ped. Bloq. - Vendedor do PV é dif. do Cad. Cliente
     ZAI_MOTBLQ = 6 -> Ped. com frete CIF bloqueado por Peso
     */

Return (oBrowse)



Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Liberar'          ACTION 'U_LTB03LIB'      OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Rejeitar'         ACTION 'U_LTB03REJ'      OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar PV'    ACTION 'U_LTB03VIS'      OPERATION 6 ACCESS 0

Return aRotina

User Function LTB03LIB()
	Local _nRet
	Local _cNewStatus := ''
	Local _cTpLib := ZAI->ZAI_MOTBLQ
	Local _lLibGer := .F.
	Local _cNivelPed := IIF(EMPTY(ALLTRIM(ZAI->ZAI_NIVEL)),"99",ZAI->ZAI_NIVEL)
	Local _aBlqs    := {}
	Local _aMots    := {}
	Local _nPosMot  := 0
	Local _cMsgLib  := ''
	Local _lblqVal := .F.
	Local nI := 0
	Local lRegra := IsInCallStack("U_FT210OPC")
	Default _aGrpUsr    := UsrRetGrp()
	Default _cGrpUsr    := ''
	Default _cNivel 	:= ''

	iF lRegra
		_cNivelPed := "00"
	EndIf

	dbSelectArea('ZAM')
	ZAM->(dbSetOrder(2))

	For nI := 1 To Len(_aGrpUsr)
		ZAM->(dbGoTop())
		If ZAM->(dbSeek(xFilial('ZAM')+_aGrpUsr[nI]))
			_cGrpUsr := IIF(ZAM->ZAM_NIVEL > _cGrpUsr, ZAM->ZAM_GRPUSR,_cGrpUsr)
			_cNivel := IIF(ZAM->ZAM_NIVEL > _cNivel, ZAM->ZAM_NIVEL,_cNivel)
		EndIf
	Next nI

	ZAM->(dbGoTop())
	If ZAM->(dbSeek(xFilial('ZAM')+_cGrpUsr))
		_lLibGer := ZAM->ZAM_LIBGER == 'S'
		_lLibVld := ZAM->ZAM_VALID == 'S'
	EndIf


	iF !lRegra

		If (_cNivel >= _cNivelPed) .OR. (ZAI->ZAI_MOTBLQ == '2' .AND. _lLibVld) .OR. (ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9' .AND. _lLibGer )

			_nRet := U_LTB03VIS()

			dbSelectArea('ZAH')
			ZAH->(dbSetOrder(3))
			ZAH->(dbGoTop())

			If ZAH->(dbSeek(xFilial('ZAH')+ZAI->ZAI_CANAL+ _cNivel))

			EndIf

			If _nRet == 1
				If ApMsgNoYes("Confirma a Liberação do Pedido de Venda para Faturamento?")
					If ZAI->ZAI_MOTBLQ != '2'
						RecLock('ZAI',.F.)
						ZAI->ZAI_OPER   := '1'
						ZAI->ZAI_DTOPER := dDataBase
						ZAI->ZAI_USER   := RetCodUsr()
						ZAI->(MsUnlock())

						_aAreaZAI := ZAI->(GetArea())

					ElseIf ZAI->ZAI_MOTBLQ = '2' .and. _lLibVld
						RecLock('ZAI',.F.)
						ZAI->ZAI_OPER   := '1'
						ZAI->ZAI_DTOPER := dDataBase
						ZAI->ZAI_USER   := RetCodUsr()
						ZAI->(MsUnlock())

						RecLock('SC5',.F.)
						SC5->C5_BLQ := _cNewStatus
						SC5->C5_X_VLD := LastDay(SC5->C5_FECENT)
						SC5->(MsUnlock())

						_aAreaZAI := ZAI->(GetArea())
					EndIf


					_cPed   := ZAI->ZAI_NUM
					_cPesq  := Iif(ZAI->ZAI_MOTBLQ == '1','2','1')

					// Se tiver permissão para realizar outras liberações, pergunto se já quer liberar todos os bloqueios de uma vez
					If _lLibGer .or. _lLibVld
						ZAI->(dbSetOrder(1))
						ZAI->(dbGoTop())
						ZAI->(dbseek(xFilial("ZAI")+_cPed))
						While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial("ZAI")+_cPed
							If Empty(ZAI->ZAI_OPER) .AND. ZAI->ZAI_NIVEL <= _cNivel
								If ZAI->ZAI_MOTBLQ == '2' .AND. _lLibVld .OR. ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9' .OR. ZAI->ZAI_MOTBLQ == '1'
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
							_cMsgLib := "Atenção! O pedido selecionado possui outros bloqueios detalhados abaixo. Deseja liberá-los também?" +chr(10) +chr(13)

							For nI := 1 To Len(_aMots)
								If _aMots[nI] == '1'
									_cMsgLib += "Bloqueio por Desconto" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '2'
									_cMsgLib += "Pedido fora do prazo de validade" + chr(10) + chr(13)
									_lblqVal := .T.
								ElseIf _aMots[nI] == '3'
									_cMsgLib += "Operação tipo Bonificação, Doação ou Amostra Grátis" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '4'
									_cMsgLib += "Comissão no Ped. é diferente da definida no vendedor" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '5'
									_cMsgLib += "Vendedor informado no pedido difere do preenchido no cliente" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '6'
									_cMsgLib += "Peso do pedido não atinge o mínimo para frete CIF" + chr(10) + chr(13)
								ElseIf _aMots[nI] == '7'
									_cMsgLib += "Operação tipo Remessa Consignada" + chr(10) + chr(13)
								EndIf
							Next nI


							If ApMsgNoYes(_cMsgLib)

								For nI := 1 To Len(_aBlqs)
									ZAI->(dbGoTo(_aBlqs[nI]))
									If ZAI->ZAI_MOTBLQ != '2'
										RecLock('ZAI',.F.)
										ZAI->ZAI_OPER   := '1'
										ZAI->ZAI_DTOPER := dDataBase
										ZAI->ZAI_USER   := RetCodUsr()
										ZAI->(MsUnlock())
									ElseIf _lLibVld

										RecLock('ZAI',.F.)
										ZAI->ZAI_OPER   := '1'
										ZAI->ZAI_DTOPER := dDataBase
										ZAI->ZAI_USER   := RetCodUsr()
										ZAI->ZAI_valid 	:= LastDay(SC5->C5_FECENT)
										ZAI->(MsUnlock())

										RecLock('SC5',.F.)
										SC5->C5_X_VLD := LastDay(SC5->C5_FECENT)
										SC5->(MsUnlock())

									EndIf

								Next nI
							EndIf
						EndIf
					EndIf


					ZAI->(dbSetOrder(1))
					ZAI->(dbGoTop())
					ZAI->(dbseek(xFilial("ZAI")+_cPed))
					While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial("ZAI")+_cPed
						If ZAI->ZAI_OPER == '2'  .or. eMPTY(ZAI->ZAI_OPER)
							// Se tiver outro tipo de bloqueio (desconto ou validade), mantenho o PV bloqueado
							_cNewStatus := IIF(ZAI->ZAI_MOTBLQ == '1' , '9' ,'8')

						EndIf
						ZAI->(dbSkip())
					EndDo

					RecLock('SC5',.F.)
					SC5->C5_BLQ := _cNewStatus
					SC5->(MsUnlock())

					RestArea(_aAreaZAI)

				EndIf
			EndIf
		Else
			If (ZAI->ZAI_MOTBLQ == '2' .AND. !_lLibVld)

				MsgAlert("Seu usuário não tem permissão para liberação de pedidos bloqueados por validade!" )

			ElseIf (ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9' .AND. !_lLibGer )

				MsgAlert("Este Pedido está fora da sua Alçada para liberação!" +chr(10) +chr(13) + "Solicite liberação pela gerência!")

			Elseif  ZAI->ZAI_MOTBLQ == '1'

				MsgAlert("Este Pedido está fora da sua Alçada para liberação!" +chr(10) +chr(13) + "Seu nível é: " + _cNivel )

			EndIf
		EndIf
	else

		dbSelectArea('ZAI')
		ZAI->(dbSetOrder(1))
		ZAI->(dbGoTop())
		If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM))
			While ZAI->(!Eof()) .And. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial('ZAI')+SC5->C5_NUM 

				If (ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9' .AND. _lLibGer ) .and. ZAI->ZAI_DTOPER == CtoD("//")

					_nRet := U_LTB03VIS()

					If _nRet == 1
						
							_cPed   := ZAI->ZAI_NUM
							_cPesq  := Iif(ZAI->ZAI_MOTBLQ == '1','2','1')

							// Se tiver permissão para realizar outras liberações, pergunto se já quer liberar todos os bloqueios de uma vez
							If _lLibGer
								ZAI->(dbSetOrder(1))
								ZAI->(dbGoTop())
								ZAI->(dbseek(xFilial("ZAI")+_cPed))
								While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial("ZAI")+_cPed
									If Empty(ZAI->ZAI_OPER) .AND. ZAI->ZAI_NIVEL <= _cNivel
										If ZAI->ZAI_MOTBLQ == '2' .AND. _lLibVld .OR. ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9' .OR. ZAI->ZAI_MOTBLQ == '1'
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
									
										For nI := 1 To Len(_aBlqs)
											ZAI->(dbGoTo(_aBlqs[nI]))
											If ZAI->ZAI_MOTBLQ != '2'
												RecLock('ZAI',.F.)
												ZAI->ZAI_OPER   := '1'
												ZAI->ZAI_DTOPER := dDataBase
												ZAI->ZAI_USER   := RetCodUsr()
												ZAI->(MsUnlock())
											ElseIf _lLibVld

												RecLock('ZAI',.F.)
												ZAI->ZAI_OPER   := '1'
												ZAI->ZAI_DTOPER := dDataBase
												ZAI->ZAI_USER   := RetCodUsr()
												ZAI->ZAI_valid 	:= LastDay(SC5->C5_FECENT)
												ZAI->(MsUnlock())

												RecLock('SC5',.F.)
												SC5->C5_X_VLD := LastDay(SC5->C5_FECENT)
												SC5->(MsUnlock())

											EndIf

										Next nI
									
								Else
									Exit
								EndIf
								
							EndIf

							RecLock('SC5',.F.)
							SC5->C5_BLQ := _cNewStatus
							SC5->(MsUnlock())

												
					else
						Exit
					EndIf
				Else
					If (ZAI->ZAI_MOTBLQ == '2' .AND. !_lLibVld)

						MsgAlert("Seu usuário não tem permissão para liberação de pedidos bloqueados por validade!" )

					ElseIf (ZAI->ZAI_MOTBLQ $ '3/4/5/6/7/8/9' .AND. !_lLibGer )

						MsgAlert("Este Pedido está fora da sua Alçada para liberação!" +chr(10) +chr(13) + "Solicite liberação pela gerência!")

					EndIf
				EndIf
				ZAI->(DbSkip())
			EndDo
		EndIf
	EndIf
Return

User Function LTB03REJ()
	If _cNivel >= ZAI->ZAI_NIVEL
		dbSelectArea('SC5')
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		If SC5->(dbSeek(xFilial('SC5')+ZAI->ZAI_NUM))
			RecLock('SC5',.F.)
			SC5->C5_LIBEROK := ""
			SC5->C5_BLQ := "R"
			SC5->(MsUnlock())

			RecLock('ZAI',.F.)
			ZAI->ZAI_OPER   := '2'
			ZAI->ZAI_DTOPER := dDataBase
			ZAI->ZAI_USER   := RetCodUsr()
			ZAI->(MsUnlock())

			U_TBEstLib()
			If ApMsgNoYes("Deseja encerrar esse pedido? Não será possível reutilizá-lo após esta operação!")
				LTB03RESID('SC5',SC5->(Recno()),2)
			EndIf
		EndIf
	Else
		MsgAlert("Este Pedido está fora da sua Alçada para Rejeição!" +chr(10) +chr(13) + "Seu nível é: " + _cNivel )
	EndIf
Return

User Function LTB03VIS()
	Local _nRet := 0
	dbSelectArea('SC5')
	SC5->(dbSetOrder(1))
	SC5->(dbGoTop())
	If SC5->(dbSeek(xFilial('SC5')+ZAI->ZAI_NUM))
		_nRet := A410Visual('SC5',SC5->(Recno()),2)
	EndIf
Return _nRet



Static Function LTB03RESID(cAlias,nReg,nOpc)
	Local aArea		:= GetArea()
	Local aColsEx	:= {}
	Local cFilSB1	:= xFilial('SB1')
	Local cFilSC6	:= xFilial("SC6")
	Local aHeaderEx	:= {}
	Local cMsgLog	:= ""
	Local lValido  	:= .F.
	Local lContinua	:= .T.
	Local lMt410Ace	:= Existblock("MT410ACE")
	Local lIntTMK	:= .T.
	Local nTotElim	:= 0 //Indica se é eliminacao total do Pedido

	If SoftLock(cAlias)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para validar acesso do usuario na funcao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMt410Ace
			lContinua := Execblock("MT410ACE",.F.,.F.,{nOpc})
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Se o Pedido foi originado no SIGALOJA E-COMMERCE Nao elimina resíduo    |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lContinua .AND. !Empty(SC5->C5_PEDECOM) .AND. (Type("l410Auto") == "U" .OR. !l410Auto)
			MsgAlert("Este Pedido foi gerado através do módulo de Controle de Lojas  - e-commerce, e  não poderá ter eliminação de resíduo.")//"Este Pedido foi gerado através do módulo de Controle de Lojas  - e-commerce, e  não poderá ter eliminação de resíduo."
			lContinua := .F.
		EndIf

		If lContinua .And. a410Visual(cAlias,nReg,nOpc)==1
			lContinua :=  ApMsgNoYes("Confirma a Rejeição do Pedido de Venda para Faturamento?" + chr(10)+chr(13) + chr(10)+chr(13) + ;
				"OBS: Esta operação não poderá ser desfeita após a sua confirmação, e o pedido não poderá voltar ao status anterior.")

			If ExistBlock("M410VRES") .AND. lContinua
				lContinua := ExecBlock("M410VRES",.F.,.F.)
			EndIf
			//Validações referentes à integração do OMS com o Cockpit Logístico Neolog
			If lContinua .and. nOpc == 2 .And. SuperGetMv("MV_CPLINT",.F.,"2") == "1" .And. FindFunction("OMSCPLVlPd")
				lContinua := OMSCPLVlPd(5,SC5->C5_NUM)
			EndIf
			If lContinua
				Begin Transaction
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Eliminacao de residuo                                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SC6")
					SC6->(dbSetOrder(1))
					SC6->(MsSeek( cFilSC6 + SC5->C5_NUM ))

					While ( !Eof() .And. SC6->C6_FILIAL == cFilSC6 .And. SC6->C6_NUM == SC5->C5_NUM )
						If Empty(SC6->C6_RESERVA)
							lValido  := .T.
						Else
							aAdd( aColsEx, { SC6->C6_NUM	,;
								SC6->C6_ITEM	,;
								SC6->C6_PRODUTO	,;
								POSICIONE('SB1', 1, cFilSB1 + SC6->C6_PRODUTO, 'B1_DESC'),;
								SC6->C6_RESERVA	,;
								.F.})
							lValido  := .F.
						EndIf
						If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
							lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
						EndIf
						If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
							Pergunte("MTA500",.F.)
							lElim := MaResDoFat(,.T.,.F.,,MV_PAR12 == 1,MV_PAR13 == 1)
							Pergunte("MTA410",.F.)
						EndIf

						nTotElim += (SC6->C6_QTDEMP + SC6->C6_QTDENT)

						//Verifica se o pedido foi gerado pelo Televendas.
						lIntTMK := IIF(lIntTMK,!Empty(SC6->C6_PEDCLI) .And. "TMK" $ upper(SC6->C6_PEDCLI),lIntTMK)
						dbSelectArea("SC6")
						dbSkip()
					EndDo
					SC6->(MaLiberOk({SC5->C5_NUM},.T.))
					//Se o pedido for eliminado por completo, será feito o cancelamento do atendimento do Televendas.
					If lIntTMK .AND. SC5->C5_LIBEROK == "S" .And. "X" $ SC5->C5_NOTA
						TkAtuTlv(SC5->C5_NUM,4)
					EndIf

					//Verifica se o pedido faz parte de integracao
					//e nao possui nenhum faturamento e manda o evento
					//de exclusao.
					If FindFunction('GETROTINTEG') .And. FWHasEAI("MATA410",.T.,,.T.) .AND. nTotElim == 0
						FwIntegDef( 'MATA410' )
					EndIf

					RecLock('ZAI',.F.)
					ZAI->ZAI_OPER   := '2'
					ZAI->ZAI_DTOPER := dDataBase
					ZAI->ZAI_USER   := RetCodUsr()
					ZAI->(MsUnlock())

					_aAreaZAI := ZAI->(GetArea())
					// Se tiver bloqueando por desconto, verifico se tem por validade a liberar e bloqueio tbm
					// Se tiver bloqueando por validade, verifico se tem por desconto a liberar e bloqueio tbm
					_cPed   := ZAI->ZAI_NUM
					_cPesq  := Iif(ZAI->ZAI_MOTBLQ == '1','2','1')
					ZAI->(dbSetOrder(1))
					ZAI->(dbGoTop())
					ZAI->(dbseek(xFilial("ZAI")+_cPed))
					While !ZAI->(EOF()) .AND. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial("ZAI")+_cPed
						If ZAI->ZAI_OPER == ''
							RecLock('ZAI',.F.)
							ZAI->ZAI_OPER   := '2'
							ZAI->ZAI_DTOPER := dDataBase
							ZAI->ZAI_USER   := RetCodUsr()
							ZAI->ZAI_JUST   := "Rejeição automática realizada em outra operação"
							ZAI->(MsUnlock())

						EndIf
						ZAI->(dbSkip())
					EndDo
					RestArea(_aAreaZAI)

				End Transaction
				If Len(aColsEx) > 0
					aAdd( aHeaderEx, { GetSx3Cache('C6_NUM'		,'X3_TITULO')	, GetSx3Cache('C6_NUM'		,'X3_CAMPO')	, '@!', TAMSX3('C6_NUM')    [1]	, 0, '', 'û', 'C', '', '', '', '', '.T.'})
					aAdd( aHeaderEx, { GetSx3Cache('C6_ITEM'	,'X3_TITULO')	, GetSx3Cache('C6_ITEM'		,'X3_CAMPO')	, '@!', TAMSX3('C6_ITEM')   [1]	, 0, '', 'û', 'C', '', '', '', '', '.T.'})
					aAdd( aHeaderEx, { GetSx3Cache('C6_PRODUTO'	,'X3_TITULO')	, GetSx3Cache('C6_PRODUTO'	,'X3_CAMPO')	, '@!', TAMSX3('C6_PRODUTO')[1]	, 0, '', 'û', 'C', '', '', '', '', '.T.'})
					aAdd( aHeaderEx, { GetSx3Cache('B1_DESC'	,'X3_TITULO')	, GetSx3Cache('B1_DESC'		,'X3_CAMPO')	, '@!', TAMSX3('B1_DESC')   [1]	, 0, '', 'û', 'C', '', '', '', '', '.T.'})
					aAdd( aHeaderEx, { GetSx3Cache('C6_RESERVA'	,'X3_TITULO')	, GetSx3Cache('C6_RESERVA'	,'X3_CAMPO')	, '@!', TAMSX3('C6_RESERVA')[1]	, 0, '', 'û', 'C', '', '', '', '', '.T.'})

					cMsgLog		:= "LTBFAT03 1" + CRLF
					cMsgLog		+= "LTBFAT03 2" + CRLF

					A410MsgLog("LTBFAT03 3", cMsgLog, aHeaderEx, aColsEx)

				EndIf
			EndIf
		EndIf

	EndIf

	RestArea(aArea)

Return
