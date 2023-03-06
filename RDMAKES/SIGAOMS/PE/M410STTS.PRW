#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}M410STTS
  ==============================================================================
    @description
    PE chamado após todas as transações do PV terem sido finalizadas

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 15/09/2020

/*/
//============================================================================\
User Function M410STTS(  )
	Local _nOper := PARAMIXB[1]
	Local _cOper := cValToChar(_nOper)
	Local cMV_TOPBONI   := AllTRIM(GetMV("MV_TOPBONI"))  // Tipos de Oeperações de Bonificação
	Local cMV_TOPEVEN   := AllTRIM(GetMV("MV_TOPEVEN"))   // Tipos de Operações de Venda
	

	RecLock('SC5',.F.)
	SC5->C5_DESC4 := 0
	SC5->(MsUnlock())


	If _cOper $ '3/4/6' .AND. SC5->C5_OPER $ (cMV_TOPBONI+'/'+cMV_TOPEVEN) .AND. ( Alltrim(FunName()) == "MATA410" .or. IsInCallStack("U_ICGERPED") ) // Inclusão / Alteração / Cópia
	
		If !U_VAL410DES(_cOper)
			U_LTBFAT07(_cOper)
		EndIf

	elseIf Alltrim(FunName()) == "FLXFAT03"
		dbSelectArea('SC6')
		SC6->(dbSetOrder(1))
		SC6->(dbGoTop())
		If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
			While !SC6->(EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial('SC6')+SC5->C5_NUM
				RecLock('SC6',.F.)
				SC6->C6_PRCVEN := SC6->C6_PRUNIT
				IF (SC6->C6_QTDVEN) > 0
					SC6->C6_VALOR  := SC6->C6_QTDVEN * SC6->C6_PRCVEN
				EndIf
				SC6->C6_DESCONT:= 0
				SC6->C6_VALDESC:= 0
				SC6->C6_BLOQUEI := ""
				SC6->(MsUnlock())
				SC6->(dbSkip())
				
			ENDDO
		EndIf
	elseIf ( Alltrim(FunName()) == "MATA410" .or. IsInCallStack("U_ICGERPED") )
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
			EndDo
		EndIf
	EndIf


	
Return ( Nil )
// FIM da Funcao M410STTS
//==============================================================================
