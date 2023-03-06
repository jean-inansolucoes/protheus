#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"


//============================================================================\
/*/{Protheus.doc}LTBFAT08
  ==============================================================================
    @description
    Reajusta Tabelas de preços com base na Tabela Mestre


    @version 1.0
    @since 24/05/2022

/*/
//============================================================================\
User Function LTBFAT08( _cOper )
	Local cUsrGer := GETMV("MX_REAJTAB",, "")
	Private cPerg        := "LTBFAT0801"

	If __cUserId $ cUsrGer

		If PERGUNTE(cPerg)
			If DA0->DA0_X_MEST = "S" .AND. MsgYesNo("Esta rotina irá reajustar TODAS as tabelas de preço com base na tabela Mestre."+ chr(10) + chr(13)+"Esta operação não pederá ser desfeita."+ chr(10) + chr(13)+" Deseja continuar?")
				Processa({|| fReajusta()}, "Processando...")
			else
				MsgAlert("Selecione uma tabela Mestre")
			EndIf
		EndIf
	else
		If DA0->DA0_X_MEST <> "S"
			MsgAlert("Usuário sem permissão para acessar esta rotina!")
		EndIf
	EndIf
RETURN

Static Function fReajusta()
	Local _aPrcProd     := {}
	Local nI
	Local nReaj
	Local cPar1 := FunName()              // Interface que está sendo sincronizada Ex: OMSA010
	Local cPar2 := "2"                    // 1=Cabeçalho ou 2=Itens
	Local cPar3 := ""                     // cIDModel (usado apenas quando chamada for executada dentro de PE MVC)
	Local aPar4 := { DA1->( Recno() ) }   // Vetor com os Recnos a serem sincronizados no formato { nRec1, nRec2, nRec3, nRecN }


	dbSelectArea('DA1')
	DA1->(dbSetOrder(1))
	DA1->(dbGoTop())
	If DA1->(dbSeek(xFilial('DA1')+DA0->DA0_CODTAB))
		While DA1->(!Eof()) .And. DA1->DA1_FILIAL+DA1->DA1_CODTAB == xFilial('DA1')+DA0->DA0_CODTAB

			aAdd(_aPrcProd,{DA0->DA0_CODTAB,DA1->DA1_CODPRO,DA1->DA1_PRCVEN})

			DA1->(DbSkip())
		EndDo
	EndIf

	ProcRegua(Len(_aPrcProd))

	If Len(_aPrcProd) > 0
		For nI := 1 To Len(_aPrcProd)
			dbSelectArea('DA1')
			DA1->(dbSetOrder(2))
			DA1->(dbGoTop())

			IncProc("Reajustando registro " + cValToChar(nI) + " de " + cValToChar(Len(_aPrcProd)) + "...")

			If DA1->(dbSeek(xFilial('DA1')+_aPrcProd[nI][2]))
				While DA1->(!Eof()) .And. DA1->DA1_FILIAL+DA1->DA1_CODPRO == xFilial('DA1')+DA1->DA1_CODPRO

					If (DA1->DA1_CODTAB <> _aPrcProd[nI][1] .AND. DA1->DA1_CODTAB <> '998') // 998 TABELA DE TRANSFERENCIAS, DEVE SER ATUALIZADA MANUALMENTE
						If DA1->DA1_CODTAB >= MV_PAR01 .AND. DA1->DA1_CODTAB <= MV_PAR02
							nReaj := Posicione('DA0',1,xFilial('DA0')+DA1->DA1_CODTAB,'DA0_X_REAJ')
							If nReaj <> 0
								RecLock('DA1',.F.)
								DA1->DA1_X_PANT := DA1->DA1_PRCVEN
								//DA1->DA1_PRCVEN := ROUND(_aPrcProd[nI][3] + ((_aPrcProd[nI][3] * nReaj) / 100),2)
								DA1->DA1_PRCVEN := ROUND(_aPrcProd[nI][3] / (1 - (nReaj / 100) ),2)
								DA1->DA1_DATVIG := DDATABASE
								DA1->DA1_X_DULT := DDATABASE
								DA1->DA1_X_HULT	:= TIME()

								DA1->(MsUnlock())
							EndIf
						EndIf
					EndIf

					DA1->(DbSkip())
				EndDo
			EndIf


		Next nI
		ExecBlock( "ICEXPDEF", .F., .F., { cPar1,cPar2, cPar3, aPar4 } )
		MsgInfo("Reajuste efetuado com sucesso!", "Tabelas de Preço")
		DA0->(dbSetOrder(1))
		DA0->(dbGoTop())
	else
		MsgInfo("Não existem registro para atualizar, verifique os percentuais!", "Tabelas de Preço")
	Endif

Return ( Nil )
