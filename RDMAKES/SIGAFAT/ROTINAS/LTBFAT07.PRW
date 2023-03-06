#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}LTBFAT07
  ==============================================================================
    @description
    Validações do PV depois da Liberação de Regras


    @version 1.0
    @since 28/04/2022

/*/
//============================================================================\
User Function LTBFAT07( _cOper )
	Local _cCanal  		:= POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_X_CANAL")
	Local _nDescBlq     := 0 // Desconto máximo permitido no PV, acima disto será bloqueado
	Local nComisVen1	:= 0
	Local nComisVen2	:= 0
	Local nComisVen3	:= 0	
	Local nComisVen4	:= 0
	Local nComisVen5	:= 0
	Local nComisCli		:= POSICIONE( "SA1",1,XFILIAL( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"SA1->A1_COMIS")
	Local cVendedor		:= POSICIONE( "SA1",1,XFILIAL( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"SA1->A1_VEND")
	Local _nComisIt     := 0
	Local lDifComis     := .F.
	Local cMV_PESOPED  	:= GetMV("MV_PESOPED")  		 // PESO LIMITE PARA PEDIDOS COM FRETE CIF
	Local cMV_TOPBONI   := AllTRIM(GetMV("MV_TOPBONI"))  // Tipos de Oeperações de Bonificação
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Operações de Venda
	Local cMV_TCONSIG   := AllTRIM(GetMV("MV_TCONSIG"))   // Tipos de Operações REMESSA CONSIGNAÇÃO

	//Local nComis1 		:= 0
	//Local nComis2 		:= 0
	Default _cOper      := "1"

	If SC5->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN+'/'+cMV_TCONSIG) .AND. ( Alltrim(FunName()) $ "MATA410/MATA210" .or. IsInCallStack("U_ICGERPED") .or. IsInCallStack("U_FT210OPC") .or. IsInCallStack("U_M410STTS"))// Inclusão / Alteração / Cópia
		//Alert("M410STTS")

		If _cOper $ '3/4/6' .AND. ( Alltrim(FunName()) == "MATA410" .or. IsInCallStack("U_ICGERPED") .or. IsInCallStack("U_M410STTS"))
			dbSelectArea('ZAI')
			ZAI->(dbSetOrder(1))
			ZAI->(dbGoTop())
			If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM))
				While ZAI->(!Eof()) .And. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial('ZAI')+SC5->C5_NUM
					If ZAI->ZAI_MOTBLQ <> "C"
						RecLock('ZAI',.F.)
						ZAI->(dbDelete())
						ZAI->(MsUnlock())
					EndIf
					ZAI->(DbSkip())
				EndDo
			EndIf
		Else
			dbSelectArea('ZAI')
			ZAI->(dbSetOrder(1))
			ZAI->(dbGoTop())
			If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM))
				While ZAI->(!Eof()) .And. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial('ZAI')+SC5->C5_NUM .and. (ZAI->ZAI_MOTBLQ <> "1" .OR. ZAI->ZAI_MOTBLQ <> "C")
					RecLock('ZAI',.F.)
					ZAI->(dbDelete())
					ZAI->(MsUnlock())

					ZAI->(DbSkip())
				EndDo
			EndIf
		EndIf
		dbSelectArea('ZAG')
		ZAG->(dbSetOrder(1))
		ZAG->(dbGoTop())
		If ZAG->(dbSeek(xFilial('ZAG')+_cCanal))
			_nDescBlq := ZAG->ZAG_DESCON
		EndIf



		//************ VALIDAÇÃO DE BONIFICAÇÃO **************//
		// Se PV for de bonificação, doação ou amostra grátis
		If ( SC5->C5_OPER $ cMV_TOPBONI + '/' + cMV_TCONSIG)
			RecLock('SC5',.F.)
			SC5->C5_BLQ := '8'
			SC5->(MsUnlock())

			dbSelectArea('ZAI')
			ZAI->(dbSetOrder(1))
			ZAI->(dbGoTop())
			If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+'3'))
				// Se já existir registro na tabela ZAI, limpo, pois pode ser operação de alteração do PV, o qual muda as regras
				RecLock('ZAI',.F.)
			Else
				RecLock('ZAI',.T.)
			EndIf

			ZAI->ZAI_FILIAL := xFilial('ZAI')
			ZAI->ZAI_NUM  :=  SC5->C5_NUM
			ZAI->ZAI_MOTBLQ  := IIf(SC5->C5_OPER $ cMV_TOPBONI,'3','7') // 1 = Desconto; 2 = Validade PV
			ZAI->ZAI_DTBLQ   := dDataBase
			ZAI->ZAI_CANAL   := _cCanal
			ZAI->ZAI_DESCR   := ZAG->ZAG_DESCR
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
			ZAI->(MsUnlock())
		EndIf




		//************ VALIDAÇÃO DE COMISSÕES **************//
		// Comissão do cabeçalho ou do item é diferente da comissão do cliente ou do vendedor (se cliente vazio)
		dbSelectArea('SC6')
		SC6->(dbSetOrder(1))
		SC6->(dbGoTop())
		If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
			While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM

				nComisVen1 := IIF(U_GETCOMIS( SC5->C5_VEND1, SC6->C6_PRODUTO) > 0, U_GETCOMIS( SC5->C5_VEND1, SC6->C6_PRODUTO),POSICIONE( "SA3",1,XFILIAL( "SA3" ) + SC5->C5_VEND1,"SA3->A3_COMIS"))
				nComisVen2 := IIF(U_GETCOMIS( SC5->C5_VEND2, SC6->C6_PRODUTO) > 0, U_GETCOMIS( SC5->C5_VEND2, SC6->C6_PRODUTO),POSICIONE( "SA3",1,XFILIAL( "SA3" ) + SC5->C5_VEND2,"SA3->A3_COMIS"))
				nComisVen3 := IIF(U_GETCOMIS( SC5->C5_VEND3, SC6->C6_PRODUTO) > 0, U_GETCOMIS( SC5->C5_VEND3, SC6->C6_PRODUTO),POSICIONE( "SA3",1,XFILIAL( "SA3" ) + SC5->C5_VEND3,"SA3->A3_COMIS"))
				nComisVen4 := IIF(U_GETCOMIS( SC5->C5_VEND4, SC6->C6_PRODUTO) > 0, U_GETCOMIS( SC5->C5_VEND4, SC6->C6_PRODUTO),POSICIONE( "SA3",1,XFILIAL( "SA3" ) + SC5->C5_VEND4,"SA3->A3_COMIS"))
				nComisVen5 := IIF(U_GETCOMIS( SC5->C5_VEND5, SC6->C6_PRODUTO) > 0, U_GETCOMIS( SC5->C5_VEND5, SC6->C6_PRODUTO),POSICIONE( "SA3",1,XFILIAL( "SA3" ) + SC5->C5_VEND5,"SA3->A3_COMIS"))

				_nComisIt   := SC6->C6_COMIS1+SC6->C6_COMIS2+SC6->C6_COMIS3+SC6->C6_COMIS4+SC6->C6_COMIS5

				//nComis1 := U_GETCOMIS( SC5->C5_VEND1, SC6->C6_PRODUTO)
				//nComis2 := U_GETCOMIS( SC5->C5_VEND2, SC6->C6_PRODUTO)

				IF nComisCli == 0
					//If nComis1 == 0
						If SC6->C6_COMIS1 <> nComisVen1 .OR. SC6->C6_COMIS2 <> nComisVen2 .OR. ;
								SC6->C6_COMIS3 <> nComisVen3 .OR. SC6->C6_COMIS4 <> nComisVen4 .OR. SC6->C6_COMIS5 <> nComisVen5
							lDifComis := .T.
						EndIf
				/*	Else
						If nComis1+nComis2 <> _nComisIt
							lDifComis := .T.
						EndIf
					EndIf
				
				/*Else
					If _nComisIt <> nComisCli
						lDifComis := .T.
					EndIf*/
				EndIf

				/*If (nComisVen1 <> SC5->C5_COMIS1 .Or. nComisVen2 <> SC5->C5_COMIS2 .Or. nComisVen3 <> SC5->C5_COMIS3 .Or. nComisVen4 <> SC5->C5_COMIS4 .Or. nComisVen5 <> SC5->C5_COMIS5)
					lDifComis		:= .T.
				EndIf*/

				If lDifComis
					If Empty(SC5->C5_BLQ)
						RecLock('SC5',.F.)
						SC5->C5_BLQ := '8'
						SC5->(MsUnlock())
					EndIf

					dbSelectArea('ZAI')
					ZAI->(dbSetOrder(1))
					ZAI->(dbGoTop())
					If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+'4'))
						// Se já existir registro na tabela ZAI, limpo, pois pode ser operação de alteração do PV, o qual muda as regras
						RecLock('ZAI',.F.)
					Else
						RecLock('ZAI',.T.)
					EndIf

					ZAI->ZAI_FILIAL := xFilial('ZAI')
					ZAI->ZAI_NUM  :=  SC5->C5_NUM
					ZAI->ZAI_MOTBLQ  := '4' // 1 = Desconto; 2 = Validade PV
					ZAI->ZAI_DTBLQ   := dDataBase
					ZAI->ZAI_CANAL   := _cCanal
					ZAI->ZAI_DESCR   := ZAG->ZAG_DESCR
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
					ZAI->(MsUnlock())

				EndIf
				SC6->(dbSkip())
			EndDo
		EndIf
		//************ VALIDAÇÃO DO VENDEDOR **************//
		// Vendedor do PV é diferente do cadastro do cliente

		If SC5->C5_VEND1 <> cVendedor .And. SC5->C5_TIPO == "N"
			If Empty(SC5->C5_BLQ)
				RecLock('SC5',.F.)
				SC5->C5_BLQ := '8'
				SC5->(MsUnlock())
			EndIf

			dbSelectArea('ZAI')
			ZAI->(dbSetOrder(1))
			ZAI->(dbGoTop())
			If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+'5'))
				// Se já existir registro na tabela ZAI, limpo, pois pode ser operação de alteração do PV, o qual muda as regras
				RecLock('ZAI',.F.)
			Else
				RecLock('ZAI',.T.)
			EndIf

			ZAI->ZAI_FILIAL := xFilial('ZAI')
			ZAI->ZAI_NUM  :=  SC5->C5_NUM
			ZAI->ZAI_MOTBLQ  := '5' // 1 = Desconto; 2 = Validade PV
			ZAI->ZAI_DTBLQ   := dDataBase
			ZAI->ZAI_CANAL   := _cCanal
			ZAI->ZAI_DESCR   := ZAG->ZAG_DESCR
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
			ZAI->(MsUnlock())
		EndIf

		//************ VALIDAÇÃO DO PESO DO PV **************//
		// Peso do pedido é menor que cMV_PESOPED e o frete é por nossa conta

		If SC5->C5_TPFRETE $ ("C/R") .And. SC5->C5_PBRUTO < cMV_PESOPED  .And. M->C5_TIPO == "N"
			//lFlag := ApMsgNoYes("Atenção o peso do pedido é menor que  " + cValToChar(cMV_PESOPED) + " KG e o frete é por nossa conta, deseja Continuar?", "Liberação da Gerência - MV_PESOPED" )
			If Empty(SC5->C5_BLQ)
				RecLock('SC5',.F.)
				SC5->C5_BLQ := '8'
				SC5->(MsUnlock())
			EndIf

			dbSelectArea('ZAI')
			ZAI->(dbSetOrder(1))
			ZAI->(dbGoTop())
			If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+'6'))
				// Se já existir registro na tabela ZAI, limpo, pois pode ser operação de alteração do PV, o qual muda as regras
				RecLock('ZAI',.F.)
			Else
				RecLock('ZAI',.T.)
			EndIf

			ZAI->ZAI_FILIAL := xFilial('ZAI')
			ZAI->ZAI_NUM  :=  SC5->C5_NUM
			ZAI->ZAI_MOTBLQ  := '6' // 1 = Desconto; 2 = Validade PV
			ZAI->ZAI_DTBLQ   := dDataBase
			ZAI->ZAI_CANAL   := _cCanal
			ZAI->ZAI_DESCR   := ZAG->ZAG_DESCR
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
			ZAI->(MsUnlock())
		EndIf

	EndIf
	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))
	SC6->(dbGoTop())
	If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
		While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM
			RecLock('SC6',.F.)
			SC6->C6_BLOQUEI := ""
			SC6->(MsUnlock())
			SC6->(dbSkip())
				
		ENDDO
	EndIf
Return ( Nil )

User Function VAL410DES(_cOper)
	Local _cCanal  		:= POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_X_CANAL")
	Local nAcordo       := POSICIONE( "SA1",1,XFILIAL( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"SA1->A1_X_DESCF")
	Local cGrpVen		:= POSICIONE( "SA1",1,XFILIAL( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"SA1->A1_GRPVEN")
	Local _aDescGrp     := {}
	Local _nPosGrp      := 0
	Local _cGrupo       := ''
	Local nI            := 0
	Local _cBlqDesc     := '1'
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Operações de Venda
	Local cMV_TCONSIG   := AllTRIM(GetMV("MV_TCONSIG"))   // Tipos de Operações REMESSA CONSIGNAÇÃO	
	Local lBlReg		:= .F.
	Default _cOper      := "3"


	//************ VALIDAÇÃO DE DESCONTOS **************//
	// Se desconto de algum item for maior que o permitido no canal de venda do cliente
	If _cOper $ '3/4/6' .AND. ( Alltrim(FunName()) $ "MATA410" .or. IsInCallStack("U_ICGERPED") .or. IsInCallStack("U_M410STTS"))
		dbSelectArea('ZAI')
		ZAI->(dbSetOrder(1))
		ZAI->(dbGoTop())
		If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM))
			While ZAI->(!Eof()) .And. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial('ZAI')+SC5->C5_NUM
				If ZAI->ZAI_MOTBLQ <> "C"
					RecLock('ZAI',.F.)
					ZAI->(dbDelete())
					ZAI->(MsUnlock())
				EndIf
				ZAI->(DbSkip())
			EndDo
		EndIf
	Else
		dbSelectArea('ZAI')
		ZAI->(dbSetOrder(1))
		ZAI->(dbGoTop())
		If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM))
			While ZAI->(!Eof()) .And. ZAI->ZAI_FILIAL+ZAI->ZAI_NUM == xFilial('ZAI')+SC5->C5_NUM .and. (ZAI->ZAI_MOTBLQ <> "1" .OR. ZAI->ZAI_MOTBLQ <> "C")
				RecLock('ZAI',.F.)
				ZAI->(dbDelete())
				ZAI->(MsUnlock())

				ZAI->(DbSkip())
			EndDo
		EndIf
	EndIf

	If SC5->C5_OPER $ (cMV_TOPEVEN + '/' + cMV_TCONSIG)
		dbSelectArea('SC6')
		SC6->(dbSetOrder(1))
		SC6->(dbGoTop())
		If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
			While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM

				_cGrupo := Posicione('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_GRUPO')

				_nPosGrp := aScan(_aDescGrp,{|x| x[1] == _cGrupo})

				If nAcordo > 15

					If _nPosGrp > 0
						_aDescGrp[_nPosGrp,2] := Max(_aDescGrp[_nPosGrp,2],ROUND(((((SC6->C6_X_PTB-(SC6->C6_PRCVEN-(SC6->C6_PRCVEN*nAcordo/100)))/SC6->C6_X_PTB)*100)),2))
						//_aDescGrp[_nPosGrp,2] := Max(_aDescGrp[_nPosGrp,2],ROUND(((((SC6->C6_X_PTB-(SC6->C6_PRCVEN-(SC6->C6_PRCVEN*nAcordo/100)))/SC6->C6_X_PTB)*100)+nAcordo),2))
						//_aDescGrp[_nPosGrp,2] := Max(_aDescGrp[_nPosGrp,2],ROUND((1-(SC6->C6_PRCVEN * (1 - (nAcordo / 100))/SC6->C6_X_PTB))*100,2))
					Else
						aAdd(_aDescGrp,{_cGrupo,ROUND(((((SC6->C6_X_PTB-(SC6->C6_PRCVEN-(SC6->C6_PRCVEN*nAcordo/100)))/SC6->C6_X_PTB)*100)),2),'', ALLTRIM(SC6->C6_PRODUTO)})
						//aAdd(_aDescGrp,{_cGrupo,ROUND(((((SC6->C6_X_PTB-(SC6->C6_PRCVEN-(SC6->C6_PRCVEN*nAcordo/100)))/SC6->C6_X_PTB)*100)+nAcordo),2),'', ALLTRIM(SC6->C6_PRODUTO)})
					EndIf

				Else
					If _cOper != '6'
						If SC6->C6_DESCONT > 0
							If _nPosGrp > 0
								_aDescGrp[_nPosGrp,2] := Max(_aDescGrp[_nPosGrp,2],SC6->C6_DESCONT)
							Else
								aAdd(_aDescGrp,{_cGrupo,SC6->C6_DESCONT,'', ALLTRIM(SC6->C6_PRODUTO)})
							EndIf
						EndIf
					Else
						If SC6->C6_X_DESC > 0
							If _nPosGrp > 0
								_aDescGrp[_nPosGrp,2] := Max(_aDescGrp[_nPosGrp,2],SC6->C6_X_DESC)
							Else
								aAdd(_aDescGrp,{_cGrupo,SC6->C6_X_DESC,'', ALLTRIM(SC6->C6_PRODUTO)})
							EndIf
						EndIf

					EndIf
				EndIf
				RecLock('SC6',.F.)
				SC6->C6_PRUNIT := SC6->C6_PRCVEN
				IF (SC6->C6_QTDVEN) > 0
					SC6->C6_VALOR  := SC6->C6_QTDVEN * SC6->C6_PRCVEN
				EndIf
				SC6->C6_X_DESC := SC6->C6_DESCONT
				SC6->C6_DESCONT:= 0
				SC6->C6_VALDESC:= 0
				SC6->(MsUnlock())
				SC6->(dbSkip())
			EndDo
		EndIf

		dbSelectArea('ACS')
		For nI := 1 To LeN(_aDescGrp)
			If nAcordo < 15
				ACS->(dbSetOrder(2))
				ACS->(dbGoTop())
				If ACS->(dbSeek(xFilial('ACS')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
					dbSelectArea('ACN')
					ACN->(dbSetOrder(1))
					ACN->(dbGoTop())
					If ACN->(dbSeek(xFilial('ACN')+ACS->ACS_CODREG))
						ACN->(dbSetOrder(2))
						ACN->(dbGoTop())
						If ACN->(dbSeek(xFilial('ACN')+SPACE(TAMSX3("ACN_GRPPRO")[1])+ _aDescGrp[nI,4]+ACS->ACS_CODREG))
							If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
								lBlReg		:= .T.
								Exit
							EndIf
						ElseIf  ACN->(dbSeek(xFilial('ACN')+ _aDescGrp[nI,1]+SPACE(TAMSX3("ACN_CODPRO")[1])+ACS->ACS_CODREG))
							If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
								lBlReg		:= .T.
								Exit
							EndIf

						ElseIf ACN->(dbSeek(xFilial('ACN')+ SPACE(TAMSX3("ACN_GRPPRO")[1])+SPACE(TAMSX3("ACN_CODPRO")[1])+ACS->ACS_CODREG))
							If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
								lBlReg		:= .T.
								Exit
							EndIf
						EndIf
						
						ACN->(DbSkip())
					EndIf
					ACS->(DbSkip())
				Else
					ACS->(dbSetOrder(3))
					ACS->(dbGoTop())
					If ACS->(dbSeek(xFilial('ACS')+cGrpVen))
						dbSelectArea('ACN')
						ACN->(dbSetOrder(1))
						ACN->(dbGoTop())

						If ACN->(dbSeek(xFilial('ACN')+ACS->ACS_CODREG))
							ACN->(dbSetOrder(2))
							ACN->(dbGoTop())
							If ACN->(dbSeek(xFilial('ACN')+SPACE(TAMSX3("ACN_GRPPRO")[1])+ _aDescGrp[nI,4]+ACS->ACS_CODREG))
								If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
									lBlReg		:= .T.
									Exit
								EndIf
							ElseIf  ACN->(dbSeek(xFilial('ACN')+ _aDescGrp[nI,1]+SPACE(TAMSX3("ACN_CODPRO")[1])+ACS->ACS_CODREG))
								If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
									lBlReg		:= .T.
									Exit
								EndIf
							ElseIf  ACN->(dbSeek(xFilial('ACN')+ SPACE(TAMSX3("ACN_GRPPRO")[1])+SPACE(TAMSX3("ACN_CODPRO")[1])+ACS->ACS_CODREG))  //.or. nAcordo > 0
								If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
									lBlReg		:= .T.
									Exit
								EndIf
							Elseif _aDescGrp[nI,2] > 0
								lBlReg		:= .T.
								Exit
							EndIf
							ACN->(DbSkip())
						EndIf
						ACS->(DbSkip())
					Else
						dbSelectArea('ACN')
						ACN->(dbSetOrder(1))
						ACN->(dbGoTop())

						If ACN->(dbSeek(xFilial('ACN')+SPACE(TAMSX3("ACN_GRPPRO")[1])+ _aDescGrp[nI,4]+ACS->ACS_CODREG))
							If ACN->ACN_CODPRO == _aDescGrp[nI,3]
								If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
									lBlReg		:= .T.
									Exit
								EndIf
							EndIf
							ACN->(DbSkip())
						ElseIf ACN->(dbSeek(xFilial('ACN')+ _aDescGrp[nI,1]+SPACE(TAMSX3("ACN_CODPRO")[1])+ACS->ACS_CODREG))
							If ACN->ACN_DESCON < _aDescGrp[nI,2] ///.AND. nAcordo < _aDescGrp[nI,2]
								lBlReg		:= .T.
								Exit
							EndIf
						ElseIf ACN->(dbSeek(xFilial('ACN')+ SPACE(TAMSX3("ACN_GRPPRO")[1])+SPACE(TAMSX3("ACN_CODPRO")[1])+ACS->ACS_CODREG)) 
							If ACN->ACN_DESCON < _aDescGrp[nI,2] //.AND. nAcordo < _aDescGrp[nI,2]
								lBlReg		:= .T.
								Exit
							EndIf
						Elseif _aDescGrp[nI,2] > 0
							//If nAcordo < _aDescGrp[nI,2]
							lBlReg		:= .T.
							Exit
							//EndIf
						EndIf
						ACS->(DbSkip())
					EndIf
				EndIf
			Else
				//If nAcordo < _aDescGrp[nI,2]
					lBlReg		:= .T.
					Exit
				//EndIf
			EndIf
		Next nI

		If lBlReg .AND. SC5->C5_OPER $ (GetMv("MV_TOPEVEN")+ '/' + cMV_TCONSIG)
			RecLock('SC5',.F.)
			SC5->C5_BLQ := "1"
			SC5->(MsUnlock())

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

			// Desconto do pedido é maior que o desconto permitido para o canal de venda
			If !Empty(_cNivel) .AND. SC5->C5_OPER $ (GetMv("MV_TOPEVEN") + '/' + cMV_TCONSIG)
				dbSelectArea('ZAI')
				ZAI->(dbSetOrder(1))
				ZAI->(dbGoTop())
				If ZAI->(dbSeek(xFilial('ZAI')+SC5->C5_NUM+_cBlqDesc))
					// Se já existir registro na tabela ZAI, limpo, pois pode ser operação de alteração do PV, o qual muda as regras
					RecLock('ZAI',.F.)
				Else
					RecLock('ZAI',.T.)
				EndIf

				ZAI->ZAI_FILIAL  := xFilial('ZAI')
				ZAI->ZAI_NUM     :=  SC5->C5_NUM
				ZAI->ZAI_MOTBLQ  := _cBlqDesc  // 1 = Desconto; 2 = Validade PV
				ZAI->ZAI_DTBLQ   := dDataBase
				ZAI->ZAI_CANAL   := _cCanal
				ZAI->ZAI_DESCR   := ZAG->ZAG_DESCR
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
				ZAI->ZAI_NIVEL   := _cNivel
				ZAI->(MsUnlock())
			EndIf
		EndIf
	else
		dbSelectArea('SC6')
		SC6->(dbSetOrder(1))
		SC6->(dbGoTop())
		If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
			While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM
				RecLock('SC6',.F.)
				SC6->C6_PRUNIT := SC6->C6_PRCVEN
				IF (SC6->C6_QTDVEN) > 0
					SC6->C6_VALOR  := SC6->C6_QTDVEN * SC6->C6_PRCVEN
				EndIf
				SC6->C6_X_DESC := SC6->C6_DESCONT
				SC6->C6_DESCONT:= 0
				SC6->C6_VALDESC:= 0
				SC6->C6_BLOQUEI := ""
				SC6->(MsUnlock())
				SC6->(dbSkip())
				
			ENDDO
		EndIf
	EndIf
Return lBlReg
