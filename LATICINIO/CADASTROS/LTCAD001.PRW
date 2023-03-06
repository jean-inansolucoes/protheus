#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTCAD001    ºAutor  ³JEAN P ROSSETTO   º Data ³  14/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CADASTRO DE PRODUTOR X LINHA                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*-------------------------------*
User Function LTCAD001()         
*-------------------------------*

Private aRotina := {{ "Pesquisar" ,"AxPesqui", 0 , 1},;
					{ "Visualizar","U_LTCADZL0('VISUALIZAR')"	, 0 , 2		},;
					{ "Incluir"   ,"U_LTCADZL0('INCLUIR')"		, 0 , 3		},;
					{ "Alterar"   ,"U_LTCADZL0('ALTERAR')"		, 0 , 4, 20 },;
					{ "Excluir"   ,"U_LTCADZL0('EXCLUIR')"		, 0 , 5, 21 } }
	
Private cCadastro := "Cadastro de Produtor x Linha"
 	
 	cQuery := " DELETE FROM " +RetSQLName("ZL1")+ " ZL1 WHERE ZL1.D_E_L_E_T_ = '*' "
	TCSQLEXEC(cQuery) 
	
	dbSelectArea("ZL0")
	dbSetOrder(1)
	
	mBrowse(6, 1, 22, 75, "ZL0",,,,,,)
	
Return

*-------------------------------*
User Function LTCADZL0(cOpcao)
*-------------------------------*
Local _ni
	
	Do Case		
		Case cOpcao=="INCLUIR";		nOpcE:=3 ; nOpcG:=3
		Case cOpcao=="ALTERAR"; 	nOpcE:=3 ; nOpcG:=3
		Case cOpcao=="VISUALIZAR"; 	nOpcE:=2 ; nOpcG:=2
		Case cOpcao=="EXCLUIR"; 	nOpcE:=2 ; nOpcG:=2
	EndCase
	
	RegToMemory("ZL0",(cOpcao=="INCLUIR"))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria aHeader e aCols da GetDados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek("ZL1")
	aHeader:={}
	While !Eof().And.(x3_arquivo=="ZL1")
		If Alltrim(x3_campo)$"ZL1_FILIAL/ZL1_COD/ZL1_SEQ"
			dbSkip()
			Loop
		Endif
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
		dbSkip()
	Enddo
	
	If ALLTRIM(cOpcao) $ "INCLUIR"
		aCols:={Array(nUsado+1)}
		aCols[1,nUsado+1]:=.F.
		For _ni:=1 to nUsado
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Next
	Else
		
		//-- HABILITA CONTROLE SOBRE USUARIO RESPONSAVEL PELA LINHA NA MANUTENCAO DAS TABELAS DE PRECOS DOS PRODUTORES RELACIONADOS.
		/*
		If SuperGetMV("MV_ZLMTPR",,.F.) .AND. cOpcao $ "ALTERAR/EXCLUIR"
			PswOrder(2)  //** Nome Usuario
			If PswSeek( AllTrim(cUserName),.t.) 
				If !Empty(ZL0->ZL0_CODRES) .and. ZL0->ZL0_CODRES != PswRet()[1][1]
					Aviso("MV_ZLMTPR","Usuário não relacionado como responsável pela linha/produtor.",{"OK"},2)
					Return NIL
				EndIf
			EndIf
		EndIf
		*/
		
		aCols:={}
		dbSelectArea("ZL1")
		dbSetOrder(2)
		IF dbSeek(xFilial("ZL1")+M->ZL0_COD)
			While !eof() .and. ZL1->ZL1_FILIAL+ZL1->ZL1_COD == xFilial("ZL1")+M->ZL0_COD
				AADD(aCols,Array(nUsado+1))
				For _ni:=1 to nUsado
					aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
				Next
				aCols[Len(aCols),nUsado+1]:=.F.
				dbSkip()
			End
		ENDIF
	Endif
	
	cTitulo       := "Produtor x Linha"
	cAliasEnchoice:= "ZL0"
	cAliasGetD    := "ZL1"
	cLinOk        := "U_LTCAD1LnOk()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	aCpoEnchoice  := {"ZL0_COD"}
	nLinhas       := 9999
	lRetOK        := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,nLinhas)
	
    If lRetOK
		MsAguarde({|| fINCZL0ZL1(cOpcao)},"Atualizando dados...")
	EndIf

Return

*----------------------------------*
Static Function fINCZL0ZL1(cOpcao)
*----------------------------------*

Local cToken	:= ALLTRIM(GETMV("MV_ZL00007",, ""))
Local I
BEGIN TRANSACTION
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras referentes há EXCLUSÃO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	IF ALLTRIM(cOpcao) == "EXCLUIR"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Exclui o cabeçalho de PRODUTORES X LINHA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cCodZa := M->ZL0_COD
		dbSelectArea("ZL0")
		dbSetOrder(1)
		dbGoTop()
		IF dbSeek(xFilial("ZL0") + cCodZa)
			WHILE !EOF() .AND. xFilial("ZL0")+cCodZa == ZL0->ZL0_FILIAL+ZL0->ZL0_COD
				RECLOCK("ZL0")
					DBDELETE()
				MSUNLOCK()
				dbSkip()
			ENDDO
		ENDIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Exclui os itens de PRODUTORES X LINHA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("ZL1")
		dbSetOrder(2)
		dbGoTop()
		IF dbSeek(xFilial("ZL1")+cCodZa)
			WHILE !EOF() .AND. xFilial("ZL1")+cCodZa == ZL1->ZL1_FILIAL+ZL1->ZL1_COD
				RECLOCK("ZL1",.F.)
					ZL1->(DBDELETE())
				ZL1->(MSUNLOCK())
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Remove o vinculo da LINHA no cadastro do FORNECEDOR³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				dbSelectArea("SA2")
				SA2->(dbSetOrder(1))
				SA2->(dbGoTop())
				If SA2->(dbSeek(xFilial("SA2") + ZL1->ZL1_PRODUT + ZL1->ZL1_LOJPRD))
					RECLOCK("SA2", .F.)
						SA2->A2_X_LINHA := SPACE(TAMSX3("A2_X_LINHA")[1])
						SA2->A2_X_NOMLI := SPACE(TAMSX3("A2_X_NOMLI")[1])
					SA2->(MSUNLOCK())
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa regras de integração com o MilkUp³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(cToken)
						U_MLKUPSA2(5, .T.)
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Exclusão da tabela tipo EXCECAO para o produtor³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If SuperGetMV("MV_ZLAITE",,.F.)
					dbSelectArea("ZL2")
					ZL2->(dbSetOrder(3))
					ZL2->(dbGoTop())
					If ZL2->(dbSeek(xFilial("ZL2") + ZL1->ZL1_COD + ZL1->ZL1_PRODUT + ZL1->ZL1_LOJPRD))
						RECLOCK("ZL2",.F.)
							ZL2->ZL2_LINHA := ""
						ZL2->(MSUNLOCK())
					EndIf
				EndIf
					
				ZL1->(dbSkip())				
			ENDDO
		ENDIF
		
	ELSE
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras de INCLUSÃO\ALTERAÇÃO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nP1   := aScan(aHeader,{|x| Alltrim(x[2])=="ZL1_PRODUT"})
		nP2   := aScan(aHeader,{|x| Alltrim(x[2])=="ZL1_LOJPRD"})
		nP3   := aScan(aHeader,{|x| Alltrim(x[2])=="ZL1_NOMPRD"})
		
		IF cOpcao=="INCLUIR"
			RecLock("ZL0", .T.)
			Replace ZL0_FILIAL   With xFilial("ZL0")
			Replace ZL0_COD      With M->ZL0_COD
			Replace ZL0_DESC     With M->ZL0_DESC
			Replace ZL0_TRANSP   With M->ZL0_TRANSP
			Replace ZL0_NOMTRP   With M->ZL0_NOMTRP
			Replace ZL0_CODRES   With M->ZL0_CODRES
			Replace ZL0_NOMRES   With M->ZL0_NOMRES

			MsUnLock("ZL0")
			ConfirmSX8()
		ENDIF
		IF ALLTRIM(cOpcao) $ "INCLUIR/ALTERAR"
			IF ALLTRIM(cOpcao) == "ALTERAR"
				cCodZa  := M->ZL0_COD          
				dbSelectArea("ZL0")
				dbSetOrder(1)
				dbGoTop()
				IF dbSeek(xFilial("ZL0")+cCodZa)
					RecLock("ZL0", .f.)
					Replace ZL0_DESC     With M->ZL0_DESC
					Replace ZL0_DESC     With M->ZL0_DESC
					Replace ZL0_TRANSP   With M->ZL0_TRANSP
					Replace ZL0_NOMTRP   With M->ZL0_NOMTRP
					Replace ZL0_CODRES   With M->ZL0_CODRES
					Replace ZL0_NOMRES   With M->ZL0_NOMRES					
					MsUnLock("ZL0")
				Endif		
				dbSelectArea("ZL1")
				dbSetOrder(1)
				dbGoTop()
				IF dbSeek(xFilial("ZL1")+M->ZL0_COD)
					WHILE !EOF() .AND. xFilial("ZL1")+M->ZL0_COD == ZL1->ZL1_FILIAL+ZL1->ZL1_COD
						RecLock("ZL1")
						dbDelete()
						MsUnLock()
						dbSkip()
					ENDDO
				ENDIF
			ENDIF
			nGrvAcols := 1
			FOR I := 1 TO LEN(aCols)
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek(xFilial("SA2")+aCols[I,nP1]+aCols[I,nP2])
					
					aCols[I,nP3] := SA2->A2_NOME
					If aCols[I,LEN(aCols[I])] == .F.
						RECLOCK("SA2",.F.)
							SA2->A2_X_LINHA := M->ZL0_COD
							SA2->A2_X_NOMLI := M->ZL0_DESC
						SA2->(MSUNLOCK())
						
					Else
						RECLOCK("SA2",.F.)
							SA2->A2_X_LINHA := SPACE(TAMSX3("A2_X_LINHA")[1])
							SA2->A2_X_NOMLI := SPACE(TAMSX3("A2_X_NOMLI")[1])
						SA2->(MSUNLOCK())			
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa regras de integração com o MilkUp³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(cToken) .AND. !Empty(ALLTRIM(SA2->A2_X_LINHA))
						U_MLKUPSA2(4, .T.)
					Else
						If !EMPTY(cToken)
							U_MLKUPSA2(5, .T.)
						EndIf
					EndIf
					
					
					// Atualização do campo nome do produtor nas tabelas 
					//PRECO X FAIXA
					cQuery := " UPDATE " + RetSQLName("ZL2") + " SET ZL2_NOMPRD = '"+SubSTR(SA2->A2_NOME,1,30)+"' WHERE ZL2_PRODUT = '"+aCols[I,nP1]+"' AND ZL2_LOJPRD = '"+aCols[I,nP2]+"' "
					TCSQLEXEC(cQuery)

					//ITENS ENTRADA PRODUTOR
					cQuery := " UPDATE " + RetSQLName("ZL6") + " SET ZL6_NOMPRD = '"+SubSTR(SA2->A2_NOME,1,30)+"' WHERE ZL6_PRODUT = '"+aCols[I,nP1]+"' AND ZL6_LOJPRD = '"+aCols[I,nP2]+"' "
					TCSQLEXEC(cQuery)
                    
					//ITENS NORMATIVA 51
					cQuery := " UPDATE " + RetSQLName("ZL9") + " SET ZL9_NOMPRD = '"+SubSTR(SA2->A2_NOME,1,30)+"' WHERE ZL9_PRODUT = '"+aCols[I,nP1]+"' AND ZL9_LOJPRD = '"+aCols[I,nP2]+"' "
					TCSQLEXEC(cQuery)

					//COLETAS A CAMPO
					cQuery := " UPDATE " + RetSQLName("ZLA") + " SET ZLA_NOMPRD = '"+SubSTR(SA2->A2_NOME,1,30)+"' WHERE ZLA_PRODUT = '"+aCols[I,nP1]+"' AND ZLA_LOJPRD = '"+aCols[I,nP2]+"' "
					TCSQLEXEC(cQuery) 
					
					//RESULTADOS ANTIBIOTICO S/VAZAO
					cQuery := " UPDATE " + RetSQLName("ZLD") + " SET ZLD_NOMPRD = '"+SubSTR(SA2->A2_NOME,1,30)+"' WHERE ZLD_PRODUT = '"+aCols[I,nP1]+"' AND ZLD_LOJPRD = '"+aCols[I,nP2]+"' "
					TCSQLEXEC(cQuery) 

					//CONTROLE EXAMES REBANHO       
					cQuery := " UPDATE " + RetSQLName("ZLE") + " SET ZLE_NOMPRD = '"+SubSTR(SA2->A2_NOME,1,30)+"' WHERE ZLE_PRODUT = '"+aCols[I,nP1]+"' AND ZLE_LOJPRD = '"+aCols[I,nP2]+"' "
					TCSQLEXEC(cQuery) 

					//ANTIBIOTICO PRODUTOR          
					cQuery := " UPDATE " + RetSQLName("ZLG") + " SET ZLG_NOMPRD = '"+SubSTR(SA2->A2_NOME,1,30)+"' WHERE ZLG_PRODUT = '"+aCols[I,nP1]+"' AND ZLG_LOJPRD = '"+aCols[I,nP2]+"' "
					TCSQLEXEC(cQuery) 

				Else
					Alert("Produtor Inválido! Favor corrigir o registro pois o Produtor/Loja: "+aCols[I,nP1]+"/"+aCols[I,nP2]+" não existe no cadastro.")
				EndIf
			NEXT I
			dbSelectArea("ZL1")
			FOR I := 1 TO LEN(aCols)
				IF aCols[I,LEN(aCols[I])] == .F.
					RECLOCK("ZL1", .T.)
						Replace ZL1_FILIAL   With xFilial("ZL1")
						Replace ZL1_COD      With M->ZL0_COD
						Replace ZL1_SEQ      With STRZERO(nGrvAcols,3)
						Replace ZL1_PRODUT   With aCols[I,nP1]
						Replace ZL1_LOJPRD   With aCols[I,nP2]
						Replace ZL1_NOMPRD   With aCols[I,nP3]
					MSUNLOCK("ZL1")

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Inclusão da tabela tipo EXCECAO para o produtor³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If SuperGetMV("MV_ZLAITE",,.F.)
					 	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso não existe registro do produtor para à linha, executa demais regras³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						dbSelectArea("ZL2")
						ZL2->(dbSetOrder(3))
						ZL2->(dbGoTop())
						If !ZL2->(dbSeek(xFilial("ZL2") + M->ZL0_COD + aCols[I,nP1] + aCols[I,nP2]))
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica se existe existe do produtor sem linha, então atualiza o mesmo³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							lAchou := .F.
							dbSelectArea("ZL2")
							ZL2->(dbSetOrder(4))
							ZL2->(dbGoTop())
							If ZL2->(dbSeek(xFilial("ZL2") + aCols[I,nP1] + aCols[I,nP2]))     
								While ZL2->(!EOF()) .AND. ZL2->ZL2_FILIAL == xFilial("ZL2") .AND. ZL2->ZL2_PRODUT == aCols[I,nP1] .AND. ZL2->ZL2_LOJPRD == aCols[I,nP2]
									If EMPTY(ZL2->ZL2_LINHA)
										RECLOCK("ZL2", .F.)
											ZL2->ZL2_LINHA  := M->ZL0_COD
										ZL2->(MSUNLOCK())
										lAchou := .T.
										exit
									EndIf
									
									ZL2->(dbSkip())
								End
							EndIf
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Caso não encontrou registro para atualização, inclui registro do produtor e linha³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If !lAchou
								RECLOCK("ZL2", .T.)
									ZL2->ZL2_FILIAL := xFilial("ZL2")
									ZL2->ZL2_COD    := GETSXENUM("ZL2","ZL2_COD")
									ZL2->ZL2_DESC   := aCols[I,nP3]
									ZL2->ZL2_TIPO   := "E"
									ZL2->ZL2_LINHA  := M->ZL0_COD
									ZL2->ZL2_PRODUT := aCols[I,nP1]
									ZL2->ZL2_LOJPRD := aCols[I,nP2]
									ZL2->ZL2_NOMPRD := aCols[I,nP3]
									ZL2->ZL2_FXINI  := 0
									ZL2->ZL2_FXFIN  := 0
									ZL2->ZL2_PRCLEI := SuperGetMV("MV_ZLPRBL",,0)
									ZL2->ZL2_PRCFRT := SuperGetMV("MV_ZLPRBF",,0)
								ZL2->(MSUNLOCK())
							EndIf
						EndIf
					EndIf

					nGrvAcols++

				ELSE
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Exclusão da tabela tipo EXCECAO para o produtor³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If SuperGetMV("MV_ZLAITE",,.F.)
					 	dbSelectArea("ZL2")
						ZL2->(dbSetOrder(3))
						ZL2->(dbGoTop())
						If ZL2->(dbSeek(xFilial("ZL2") + M->ZL0_COD + aCols[I,nP1] + aCols[I,nP2]))
							RECLOCK("ZL2",.F.)
								ZL2->ZL2_LINHA := ""
							ZL2->(MSUNLOCK())
						EndIf
					EndIf
					
				ENDIF
				
			NEXT I
		ENDIF
	ENDIF
END TRANSACTION


Return    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTCAD1LnOk  ºAutor  ³Rafael Parma      º Data ³  05/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Validação da linha do MsNewGetDados               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LTMOV001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function LTCAD1LnOk()
*-------------------------*
Local lRet    := .T.
Local nI
Local nPosPrd := aScan(aHeader,{|x| AllTrim(x[2])=="ZL1_PRODUT"})
Local nPosLoj := aScan(aHeader,{|x| AllTrim(x[2])=="ZL1_LOJPRD"})
//Local nMaxFor   := Len(aCols)
Local nUsado    := Len(aHeader)
//Local lTestaDel := nUsado <> Len(aCols[1])


	For nI := 1 to Len(aCols)              
		If !aCols[n][nUsado+1] .and. !aCols[nI][nUsado+1] 
			If n != nI .and. aCols[nI,nPosPrd] == aCols[n,nPosPrd] .and. aCols[nI,nPosLoj] == aCols[n,nPosLoj] 
				MsgAlert("O produtor "+aCols[n,nPosPrd]+" loja "+aCols[n,nPosLoj]+" já foi lançado neste movimento.")
				lRet := .F.
			EndIf
			If lRet   
				cCODLIN := POSICIONE("SA2",1,xFilial("SA2")+aCols[n,nPosPrd]+aCols[n,nPosLoj],"A2_X_LINHA")
				If !Empty(cCODLIN) .AND. cCODLIN != M->ZL0_COD
					MsgAlert("O produtor "+aCols[n,nPosPrd]+" loja "+aCols[n,nPosLoj]+" esta relacionado a linha código: "+ALLTRIM(cCODLIN))
					lRet := .F.
				EndIf
			EndIf                          
		EndIf
	Next nI	
	
Return( lRet )
