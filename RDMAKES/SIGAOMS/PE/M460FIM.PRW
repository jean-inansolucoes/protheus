#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460FIM     บAutor ณAlexandre LonghinottiบData ณ 23/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere o numero da carga no campo SE1->E1_X_CARGA          บฑฑ
ฑฑบ          ณ e o desconto acordado. Campo A1_X_DESC p/ E1_DECRESC       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function M460FIM()
	***********************
	local aArea     := GetArea()
	local aAreaSF2  := SF2->(GetArea())
	local aAreaSE1  := SE1->(GetArea())
	local aAreaSD2  := SD2->(GetArea())
	local aParam    := PARAMIXB
	local cFunCall  := SubStr(ProcName(0),3)
	local lPEICMAIS := ExistBlock( 'T'+ cFunCall )
	Local cSerieFun := Alltrim(GetMv("MV_SERIEFU")) // S้rie de venda funcionarios
	Local aColsEx	:= {}
	Local lValido  	:= .F.
	Local cPedSep   := SC5->C5_NUM
	Local nTotElim	:= 0 //Indica se ้ eliminacao total do Pedido
	Private lMsErroAuto := .F.
	
	dBSelectArea( "SE1" )
	SE1->( dBSetOrder( 2 ) )
	SE1->( dBGoTop( ) )

	If SE1->( dBSeek( xFilial( "SE1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC ) )
		
		While !SE1->( EOF( ) ) .AND. ( SE1->E1_FILIAL == xFilial( "SE1" ) ) .AND. ( SE1->E1_CLIENTE == SF2->F2_CLIENTE ) .AND. ( SE1->E1_LOJA == SF2->F2_LOJA ) .AND. ( SE1->E1_NUM == SF2->F2_DOC ) .AND. ( SE1->E1_PREFIXO == SF2->F2_SERIE )
			/*
			RECLOCK( "SE1", .F. )

			SE1->E1_X_CARGA := SF2->F2_CARGA

			IF(SE1->E1_DESCFIN > 0 .OR. _nAcordo > 0)
				SE1->E1_DECRESC := (SE1->E1_VALOR * ((IIF(SE1->E1_DESCFIN > 0, SE1->E1_DESCFIN, _nAcordo)) / 100))				
				SE1->E1_SDDECRE := (SE1->E1_VALOR * ((IIF(SE1->E1_DESCFIN > 0, SE1->E1_DESCFIN, _nAcordo)) / 100))
			EndIf

			If !Empty( SA1->A1_X_FUNC )
				SE1->E1_PORCJUR := 0
				SE1->E1_VALJUR	:= 0

			EndIf

			SE1->( MsUnLock( ) )
			*/
			/*
			aFina040 := { { "E1_PREFIXO", SE1->E1_PREFIXO       , NIL },;
				{ "E1_NUM"	, SE1->E1_NUM    	                    , NIL },;
				{ "E1_PARCELA", SE1->E1_PARCELA	                    , NIL },;
				{ "E1_TIPO"  	, SE1->E1_TIPO		                , NIL },;
				{ "E1_CLIENTE", SE1->E1_CLIENTE	                    , NIL },;
				{ "E1_LOJA"  	, SE1->E1_LOJA		                , NIL },;
				{ "E1_DECRESC", (SE1->E1_VALOR * ((IIF(SE1->E1_DESCFIN > 0, SE1->E1_DESCFIN, _nAcordo)) / 100)), NIL }}

			MSExecAuto( {|x,y| FINA040( x , y ) }, aFina040, 4 )

			If lMsErroAuto
				DisarmTransaction()
				Mostraerro()
				lMostraErro	:= .F.
			EndIf
			*/

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณGera registro de valores futuros para desconto em folha do funcionแrioณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			If (!Empty(SA1->A1_X_FUNC) .AND. SE1->E1_PREFIXO == cSerieFun)
				dbSelectArea("RG1")
				RECLOCK("RG1", .T.)
				RG1->RG1_FILIAL := xFilial("RG1")
				RG1->RG1_MAT	:= SA1->A1_X_FUNC
				RG1->RG1_AUTOM	:= "1"
				RG1->RG1_ORDEM	:= RG1RETORD(SA1->A1_X_FUNC)
				RG1->RG1_TPCALC	:= "1"
				RG1->RG1_PD		:= "454"
				RG1->RG1_VALOR	:= SE1->E1_VALOR
				RG1->RG1_DINIPG	:= SE1->E1_VENCTO
				RG1->RG1_DFIMPG	:= SE1->E1_VENCTO
				RG1->RG1_ROT	:= "FOL"
				RG1->RG1_PROP	:= "2"
				RG1->RG1_CC		:= POSICIONE("SRA",1,xFilial("SE1")+SA1->A1_X_FUNC,"RA_CC")
				RG1->RG1_X_DTMV := dDataBase
				RG1->RG1_X_NDOC	:= SE1->E1_NUM
				RG1->RG1_STATUS := "1"
				RG1->(MSUNLOCK())
			EndIf

			SE1->(dBSkip())
		EndDo

	EndIf
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ ENCERRA PEDIDO DE VENDAS APOS O FATURAMENTO                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	restArea( aAreaSE1 )
	restArea( aAreaSD2 )
	restArea( aAreaSF2 )

	//Estorna Libera็ใo do PEDIDO caso haja
	Begin Transaction
		dBSelectArea("SC6")
		SC6->( dBSetOrder( 1 ) )
		SC6->( dBGoTop( ) )
		If SC6->( dbSeek( xFilial("SF2") + cPedSep) )
			// avalia os itens, de modo a eliminar resํduos caso haja faturamento
			While !SC6->(EOF()) .AND. SC6->C6_FILIAL == xFilial("SF2") .AND. SC6->C6_NUM == cPedSep
				// tenta estornar as libera็๕es do item
				MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil)
				If RecLock("SC6",.F.)
					IF Empty(SC6->C6_NOTA)
						SC6->( dBDelete( ) )
					ENDIF
					SC6->(MsUnLock())
				EndIf
				SC6->( dbSkip() )
			Enddo
		Endif

		/*dBSelectArea("SC5")
		SC5->( dBSetOrder( 1 ) )
		SC5->( dBGoTop( ) )
		If SC5->( dbSeek( xFilial("SF2") + cPedSep ) )
			While !SC5->(EOF()) .AND. SC5->C5_FILIAL == xFilial("SF2") .AND. SC5->C5_NUM == cPedSep
				If RecLock("SC5",.F.)
					IF Empty(SC5->C5_NOTA) .OR. SC5->C5_NOTA == 'XXXXXXXXX'
						SC5->C5_NOTA := SF2->F2_DOC
					ENDIF
					SC5->(MsUnLock())
				EndIf
				SC5->( dbSkip() )
			Enddo
		Endif*/

		If !Empty(cPedSep)
			
			cFilSC9 := "SC9->C9_FILIAL = '"+ SF2->F2_FILIAL +"' .AND. SC9->C9_PEDIDO = '"+ cPedSep +"'		  "
			dbSelectArea("SC9")
			SET FILTER TO &(cFilSC9)
			SC9->(dbGoTop())
			While !SC9->(EOF())
				If RecLock("SC9",.F.)
					IF Empty(SC9->C9_NFISCAL)
						SC9->( dBDelete( ) )
					Else
						SC9->C9_BLEST := "10"
						SC9->C9_BLCRED := "10"
					EndIf
					SC9->(MsUnLock())
				EndIf
				SC9->(dbSkip())
			Enddo
			SET FILTER TO
		EndIf

		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		SC6->(MsSeek( xFilial("SF2") + cPedSep ))

		While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SF2") .And. SC6->C6_NUM == cPedSep )

			//Faz o acerto da Quantidade reservada na SB2
			nReserv := 0
			cFilSC9 := "SC9->C9_FILIAL = '"+ SC6->C6_FILIAL +"' .AND. SC9->C9_LOCAL = '"+ SC6->C6_LOCAL	+"' .AND. SC9->C9_PRODUTO = '"+ SC6->C6_PRODUTO	+"' .AND. SC9->C9_NFISCAL = '         ' .AND. SC9->C9_BLEST <> '02'		  "
			cFilSB2 := "SB2->B2_FILIAL = '"+ SC6->C6_FILIAL	+"' .AND. SB2->B2_LOCAL = '"+ SC6->C6_LOCAL	+"' .AND. SB2->B2_COD = '"+ SC6->C6_PRODUTO	+"'		  "

			dbSelectArea("SC9")
			SET FILTER TO &(cFilSC9)
			SC9->(dbGoTop())
			While !SC9->(EOF())
				If RecLock("SC9",.F.)
					nReserv += SC9->C9_QTDLIB
					SC9->(MsUnLock())
				EndIf
				SC9->(dbSkip())
			Enddo
			SET FILTER TO

			dbSelectArea("SB2")
			SET FILTER TO &(cFilSB2)
			SB2->(dbGoTop())
			While !SB2->(EOF())
				If RecLock("SB2",.F.)
					SB2->B2_RESERVA := nReserv
					SB2->(MsUnLock())
				EndIf
				SB2->(dbSkip())
			Enddo
			SET FILTER TO
			//Fim do acerto da Quantidade reservada na SB2


			If Empty(SC6->C6_RESERVA)
				lValido  := .T.
			Else
				aAdd( aColsEx, { SC6->C6_NUM	,;
					SC6->C6_ITEM	,;
					SC6->C6_PRODUTO	,;
					POSICIONE('SB1', 1, xFilial('SF2') + SC6->C6_PRODUTO, 'B1_DESC'),;
					SC6->C6_RESERVA	,;
					.F.})
				lValido  := .F.
			EndIf

			If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
				Pergunte("MTA500",.F.)
				lElim := MaResDoFat(,.T.,.F.,,MV_PAR12 == 1,MV_PAR13 == 1)
				Pergunte("MTA410",.F.)
			EndIf

			nTotElim += (SC6->C6_QTDEMP + SC6->C6_QTDENT)


			dbSelectArea("SC6")
			dbSkip()
		EndDo
		SC6->(MaLiberOk({cPedSep},.T.))

		//Verifica se o pedido faz parte de integracao
		//e nao possui nenhum faturamento e manda o evento
		//de exclusao.
		If FindFunction('GETROTINTEG') .And. FWHasEAI("MATA410",.T.,,.T.) .AND. nTotElim == 0
			FwIntegDef( 'MATA410' )
		EndIf

	End Transaction

	restArea( aAreaSE1 )
	restArea( aAreaSD2 )
	restArea( aAreaSF2 )
	
	//--Envio de workflow
	If SF2->F2_BRICMS > 0 .AND. TRIM(SF2->F2_EST) != (SM0->M0_ESTENT)
		fSendWF()
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    //ณ Chamada especํfica para uso do FLUXI Separacao  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	if ExistBlock("FLXFAT02")
        U_FLXFAT02("FATURPV",cPedSep)
	endif

	restArea( aAreaSE1 )
	restArea( aAreaSD2 )
	restArea( aAreaSF2 )

	// Manter o trexo de c๓digo a seguir no final do fonte
	if lPEICMAIS
		ExecBlock( 'T'+ cFunCall, .F., .F., aParam )
	EndIf

	restArea( aAreaSE1 )
	restArea( aAreaSD2 )
	restArea( aAreaSF2 )
	RestArea( aArea )

Return( Nil )





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRG1RETORD บAutor  ณMarcelo Joner       บ Data ณ  14/02/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel por retornar o codigo da proxima ordem   บฑฑ
ฑฑบ          ณdisponivel para utilizacao.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Lat. Silvestre                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RG1RETORD(cCodMat)

	Local cNumOrd		:= STRZERO(1, TAMSX3("RG1_ORDEM")[1])
	Local cQuery		:= ""
	Local cAliasTMP		:= GetNextAlias()
	Local hEnter		:= CHR(10)

	Default cCodMat		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta regras caso exista funcionario informadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If !EMPTY(cCodMat)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณComposi็ใo da consulta SQL de anแlise dos registros do funcionแrioณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		cQuery := "SELECT MAX(RG1.RG1_ORDEM) RG1_ORDEM				" + hEnter
		cQuery += "FROM " + RetSQLName("RG1") + " RG1				" + hEnter
		cQuery += "WHERE RG1.RG1_FILIAL  = '" + xFilial("RG1") + "'	" + hEnter
		cQuery += "  AND RG1.RG1_MAT     = '" + cCodMat        + "'	" + hEnter
		cQuery += "  AND RG1.D_E_L_E_T_ <> '*'						" + hEnter

		If Select(cAliasTMP) > 0
			(cAliasTMP)->(dbCloseArea())
		Endif

		dBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)

		If !EMPTY((cAliasTMP)->RG1_ORDEM)
			cNumOrd := STRZERO((VAL((cAliasTMP)->RG1_ORDEM) + 1), TAMSX3("RG1_ORDEM")[1])
		Endif

		(cAliasTMP)->(dbCloseArea())
	EndIf

Return cNumOrd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSendWF  บAutor ณAlexandre Longhinotti  บ Data ณ 08/04/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para enviar workflow na finaliza็ใo do faturamento   บฑฑ
ฑฑบ                        .                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*----------------------------------*
Static Function fSendWF()
	*----------------------------------*
	Local aArea := GetArea()
	Local cEmailWF := ""
	Local oProcess

	CONOUT("WFM460FIM - INICIO DA EXECUวรO")

	cEmailWF := SuperGetMV("MX_EMCLIST",,"")

	If ALLTRIM(cEmailWF) == ""
		Return
	Endif

	oProcess := TWFProcess():New( "WFM460FIM", "FATURAMENTO PARA CLIENTE COM ICMS-ST")
	oProcess:NewTask( "WFPCAVISO", "\workflow\wfm460fim.html")

	oProcess:cSubject :=  "WF - AVISO - FATURAMENTO PARA CLIENTE COM ICMS-ST"

	oHTML := oProcess:oHTML

	CODCLI := SF2->F2_CLIENTE + "-" + SF2->F2_LOJA + " - UF: " + TRIM(SF2->F2_EST)
	RAZAO  := ALLTRIM(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME"))
	CNUNDOC := SF2->F2_DOC + "-" + SF2->F2_SERIE

	oHtml:ValByName("CFILIAL", SM0->M0_NOME							)
	oHtml:ValByName("CNUMDOC", CNUNDOC								)
	oHtml:ValByName("CODCLI", CODCLI		 						)
	oHtml:ValByName("RAZAO", RAZAO		 						)
	oHtml:ValByName("DTEMISS", SF2->F2_EMISSAO 						)
	oHtml:ValByName("CUSUARI", ALLTRIM(UPPER(CUSERNAME))			)

	oProcess:cTo  := LOWER(cEmailWF)

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo
	oProcess:Finish()

	CONOUT("WFM460FIM - FIM DA EXECUวรO")

	RestArea(aArea)

	
Return
