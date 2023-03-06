#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03   ºAutor  ³Desenvolvimento      º Data ³ 18/04/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina referente ao cadastro das regras de contabilização   º±±
±±º          ³consideradas para movimentações de estoque\produção.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Regras de Contabilização                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C997D03()

Private cAliasH		:= "SZ5"
Private cAliasCpo	:= "Z5"
Private cAliasMem	:= "M->Z5"
Private cCadastro	:= "Contabilização de Produção"
Private aRotina		:= MENUDEF()      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Carrega o componente mBrowse para apresentação das regras³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea(cAliasH)
(cAliasH)->(dBSetOrder(1))
(cAliasH)->(dBGotop())
mBrowse(6, 1,22,75, cAliash)
	
Return






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MENUDEF   ºAutor  ³Desenvolvimento      º Data ³  11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição das opções existentes no menu da rotina.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Regras de Contabilização                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MENUDEF()

Local aRotina := { {"Pesquisar" , "AxPesqui"   , 0 , 1},;
                   {"Visualizar", "U_C997D03X" , 0 , 2},;
                   {"Incluir"   , "U_C997D03X" , 0 , 3},;
                   {"Alterar"   , "U_C997D03X" , 0 , 4},;
                   {"Excluir"   , "U_C997D03X" , 0 , 5},;
                   {"Copiar"    , "U_C997D03X" , 0 , 6}}
                    
Return aRotina






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03X   ºAutor  ³Desenvolvimento     º Data ³  11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manipulação dos reggistros.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Regras de Contabilização                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C997D03X(cAlias, nReg, nOpc)

Local aAlterEnch	:= {}
Local aCpoEnch	:= {'NOUSER'}
Local cAliasE		:= cAliasH
Local aSize		:= {}
Local aObjects	:= {}
Local aInfo		:= {}
Local aPosObj		:= {}
Local aArea		:= GetArea()  
Local oDlg
Local cCpoCab		:=  cAliasCpo + "_FILIAL/" + cAliasCpo + "_CF/"
Local bCampo		:= {|nCPO| Field(nCPO)}
Local aHeader		:= {}
Local aCols		:= {}   
Local nI			:= 0
Local nX			:= 0
Local nAnt			:= 0
Local nAtu			:= 0
Local nOpcao		:= 2
Local nOpcNewGd	:= If(((nOpc == 2) .OR. (nOpc == 5)) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE)

Private oBrw		:= 0
Private aGets		:= {}
Private aTela		:= {}

Private VISUAL	:= IIF(nOpc == 2, .T., .F.)
Private INCLUI	:= IIF(nOpc == 3, .T., .F.)
Private ALTERA	:= IIF(nOpc == 4, .T., .F.)
Private DELETA	:= IIF(nOpc == 5, .T., .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Define e Registra os Campos do Enchoice³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea(cAliasH)
RegToMemory(cAliasH, INCLUI .AND. nOpc == 3, .F.)
If !INCLUI
	For nI := 1 TO FCount()
		M->&(Eval(bCampo, nI)) := FieldGet(nI)
	Next nI 
EndIf
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa funcao de montagem do aHeader para o grid de itens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias))
While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cAliasH
   If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
      If !(ALLTRIM(SX3->X3_CAMPO) $ cCpoCab)
	      AADD(aHeader, {AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT,;
							SX3->X3_CBOX,;
							SX3->X3_RELACAO,;
							SX3->X3_WHEN})
		Else
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Campos do cabeçalho da tela³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			AADD(aCpoEnch, SX3->X3_CAMPO)
			If X3_VISUAL # "V"
				AADD(aAlterEnch, SX3->X3_CAMPO)
			EndIf
		EndIf
   EndIf        
   
   SX3->(dbSkip())                                                                                         
End                                                                                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Montagem dos dados do aCols para utilizar no MsNewGetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea(cAliasH)
(cAliasH)->(dbSetOrder(1)) 
(cAliasH)->(dbGoTop())
If (cAliasH)->(dbSeek(xFilial(cAliasH) + &("M->" + cAliasCpo + "_CF")))
	While !(cAliasH)->(EOF()) .AND. &(cAliasH + "->" + cAliasCpo + "_FILIAL") == xFilial(cAliasH) .AND. &(cAliasH + "->" + cAliasCpo + "_CF") == &("M->" + cAliasCpo + "_CF")
		AADD(aCols, Array(Len(aHeader) + 1))
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosSZ0 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := (cAliasH)->(FieldGet(nPosSZ0))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		(cAliasH)->(dbSkip())
	End   
EndIf         
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Limpa o código da verba caso seja cópia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
INCLUI	:= IIF(nOpc == 3 .OR. nOpc == 6, .T., .F.)
&("M->" + cAliasCpo + "_CF") := IIF(nOpc == 6, CRIAVAR(cAliasCpo + "_CF"), &("M->" + cAliasCpo + "_CF"))
	           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Montagem dos parâmetros para criação da tela de exibição³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aSize := MsAdvSize(.T.)
AADD(aObjects, {100, 100, .T., .T.})
aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects, .T.)              
aPos := {aPosObj[1,1], 000, aPosObj[1,1] + 035, aPosObj[1,4]}
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição do dialog e demais componentes da tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6], aSize[5] of oMainWnd PIXEL   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Campos do cabeçalho da interface³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ENCHOICE(cAlias, nReg, nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoEnch, aPos, aAlterEnch, 3, /*nColMens*/,/*cMensagem*/,'', oDlg,.F.,.T.,.F.,,.F.,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³grid de itens da interface³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oBrw := MsNewGetDados():New(aPosObj[1,1] + 036, 001, aPosObj[1,3], aPosObj[1,4],nOpcNewGd,'U_C997D03L()','AllwaysTrue()',"+",,0,99,'U_C997D03G()',.F.,.F.,oDlg,aHeader,aCols)
	oBrw:SetEditLine(.F.)
	
ACTIVATE MSDIALOG oDlg ON INIT ENCHOICEBAR(oDlg,{|| IIF(C997D03TDOK(), (nOpcao := 1, oDlg:End()), nOpcao := 2)}, {|| (nOpcao := 2, oDlg:End())})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras de gravação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If nOpcao == 1 .AND. !VISUAL
	C997D03GRV()
EndIf

Return






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03G   ºAutor  ³Desenvolvimento     º Data ³ 11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação vinculada à edição de campos do grid de º±±
±±º          ³itens da interface.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Regras de Contabilização                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C997D03G()

Local lRet			:= .T.
Local aCols		:= oBrw:aCols
Local aHeader		:= oBrw:aHeader
Local nI			:= 0
Local nPos			:= oBrw:oBrowse:nAt
Local nPosFil		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_FILREG"})
Local nPosOp		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_OP"})
Local nPosTipo	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_TIPO"})
Local nPosGrupo	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_GRUPO"})
Local nPosTm		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_TM"})
Local nPosCta		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CONTA"})
Local nPosCtaF	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CONTAF"})
Local nPosCc		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CC"})
Local nPosCcF		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CCF"})
Local nPosRegra	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_REGRA"})
Local nPosDeb		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CTADEB"})
Local nPosCre		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CTACRE"})

Do Case

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Aplica validações à respeito da filial da regra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(ReadVar()) == cAliasMem + "_FILREG"
		If !EMPTY(&(cAliasMem + "_FILREG")) .AND. &(cAliasMem + "_FILREG") != "*"
			If !EXISTCPO("SM0", cEmpAnt + &(cAliasMem + "_FILREG")) 
				Return .F.
			EndIf
		EndIf
		
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Aplica validações à respeito do tipo de produto informado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(ReadVar()) == cAliasMem + "_TIPO"
		If !EMPTY(&(cAliasMem + "_TIPO")) .AND. &(cAliasMem + "_TIPO") != "*"
			If !ExistCpo("SX5", "02" + &(cAliasMem + "_TIPO"))
				Return .F.
			EndIf
		EndIf
		
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Aplica validações à respeito do grupo de produto informado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(ReadVar()) == cAliasMem + "_GRUPO"
		If !EMPTY(&(cAliasMem + "_GRUPO")) .AND. &(cAliasMem + "_GRUPO") != "*"
			If !ExistCpo("SBM")
				Return .F.
			EndIf
		EndIf
		
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Aplica validações à respeito do tipo de movimentação informado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(ReadVar()) == cAliasMem + "_TM"
		If !EMPTY(&(cAliasMem + "_TM")) .AND. &(cAliasMem + "_TM") != "*"
			If !ExistCpo("SF5")
				Return .F.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida o TM em relação ao cabeçalho da regra³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				dbSelectArea("SF5")
				SF5->(dbSetOrder(1))
				SF5->(dbGoTop())
				If SF5->(dbSeek(xFilial("SF5") + &(cAliasMem + "_TM")))
					Do Case
						Case SF5->F5_TIPO == "D" .AND. SUBSTRING(&(cAliasMem + "_CF"),1,2) != "DE"
							ShowHelpDlg("Atenção", {"O tipo de movimentação informado é inválido."}, 5, {"O tipo de movimentação informado deve ser da mesma operação presente no cabeçalho da regra."}, 5)
							Return .F.
						
						Case SF5->F5_TIPO == "P" .AND. SUBSTRING(&(cAliasMem + "_CF"),1,2) != "PR"
							ShowHelpDlg("Atenção", {"O tipo de movimentação informado é inválido."}, 5, {"O tipo de movimentação informado deve ser da mesma operação presente no cabeçalho da regra."}, 5)
							Return .F.
						
						Case SF5->F5_TIPO == "R" .AND. SUBSTRING(&(cAliasMem + "_CF"),1,2) != "RE"
							ShowHelpDlg("Atenção", {"O tipo de movimentação informado é inválido."}, 5, {"O tipo de movimentação informado deve ser da mesma operação presente no cabeçalho da regra."}, 5)
							Return .F.
					EndCase
				EndIf
			EndIf
		EndIf		

		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Aplica validações à respeito da conta contábil final informada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(ReadVar()) == cAliasMem + "_CONTAF"
		If SUBSTR(&(cAliasMem + "_CONTAF"), 1, 1) == "Z"
			&(cAliasMem + "_CONTAF") := REPLICATE("Z", TAMSX3(cAliasCpo + "_CONTAF")[1])
		EndIf
		


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Verifica se o centro de custos final existe³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(ReadVar()) == cAliasMem + "_CCF"
		If SUBSTR(&(cAliasMem + "_CCF"), 1, 1) == "Z"
			&(cAliasMem + "_CCF") := REPLICATE("Z", TAMSX3(cAliasCpo + "_CCF")[1])
		EndIf
		


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa limpeza dos campos de conta débito\crédito ao informar à regra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(ReadVar()) == cAliasMem + "_REGRA"
		aCols[nPos][nPosCre] := SPACE(TAMSX3(cAliasCpo + "_CTACRE")[1])
		aCols[nPos][nPosDeb] := SPACE(TAMSX3(cAliasCpo + "_CTADEB")[1])
	
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Aplica validações sob à informação de conta crédito³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
	Case ALLTRIM(ReadVar()) == cAliasMem + "_CTACRE"
		If !EMPTY(aCols[nPos][nPosRegra])
			Do Case
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida o campo informado quando a regra é Campo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				Case aCols[nPos][nPosRegra] == "1"
					If ALLTRIM(&(cAliasMem + "_CTACRE")) == "SB1->B1_CONTA" .OR. ALLTRIM(&(cAliasMem + "_CTACRE")) == "SD3->D3_CONTA"
						If &(cAliasMem + "_CTACRE") == aCols[nPos][nPosDeb]
							ShowHelpDlg("Atenção", {"O campo informado é inválido."}, 5, {"O campo informado para conta crédito e débito não podem ser iguais."}, 5)
							Return .F.
						EndIf
					Else
						ShowHelpDlg("Atenção", {"O campo informado é inválido."}, 5, {"Deve-se informar um dos campos abaixo na composição da regra." + CHR(13) + CHR(13) + "SB1->B1_CONTA" + CHR(13) + "SD3->D3_CONTA"}, 5)
						Return .F.
					EndIf
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida à conta contábil quando a regra é Conta³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				Case aCols[nPos][nPosRegra] == "2"
					If !EMPTY(&(cAliasMem + "_CTACRE"))
						If !ExistCpo("CT1")
							Return .F.
						Else
							If &(cAliasMem + "_CTACRE") == aCols[nPos][nPosDeb]
								ShowHelpDlg("Atenção", {"A conta contábil crédito informada é inválida."}, 5, {"A conta contábil crédito e débito não podem ser iguais."}, 5)
								Return .F.
							EndIf
						EndIf
					EndIf
			EndCase
		Else
			ShowHelpDlg("Atenção", {"Não foi definido o tipo da regra."}, 5, {"Antes de definir à conta crédito, deve-se informar qual o tipo da regra considerada."}, 5)
			Return .F.
		EndIf
		
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Aplica validações sob à informação de conta débito³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
	Case ALLTRIM(ReadVar()) == cAliasMem + "_CTADEB"
		If !EMPTY(aCols[nPos][nPosRegra])
			Do Case
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida o campo informado quando a regra é Campo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				Case aCols[nPos][nPosRegra] == "1"
					If ALLTRIM(&(cAliasMem + "_CTADEB")) == "SB1->B1_CONTA" .OR. ALLTRIM(&(cAliasMem + "_CTADEB")) == "SD3->D3_CONTA"
						If &(cAliasMem + "_CTADEB") == aCols[nPos][nPosCre]
							ShowHelpDlg("Atenção", {"O campo informado é inválido."}, 5, {"O campo informado para conta crédito e débito não podem ser iguais."}, 5)
							Return .F.
						EndIf
					Else
						ShowHelpDlg("Atenção", {"O campo informado é inválido."}, 5, {"Deve-se informar um dos campos abaixo na composição da regra." + CHR(13) + CHR(13) + "SB1->B1_CONTA" + CHR(13) + "SD3->D3_CONTA"}, 5)
						Return .F.
					EndIf
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida à conta contábil quando a regra é Conta³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				Case aCols[nPos][nPosRegra] == "2"
					If !EMPTY(&(cAliasMem + "_CTADEB"))
						If !ExistCpo("CT1")
							Return .F.
						Else
							If &(cAliasMem + "_CTADEB") == aCols[nPos][nPosCre]
								ShowHelpDlg("Atenção", {"A conta contábil débito informada é inválida."}, 5, {"A conta contábil débito e crédito não podem ser iguais."}, 5)
								Return .F.
							EndIf
						EndIf
					EndIf
			EndCase
		Else
			ShowHelpDlg("Atenção", {"Não foi definido o tipo da regra."}, 5, {"Antes de definir à conta débito, deve-se informar qual o tipo da regra considerada."}, 5)
			Return .F.
		EndIf
		
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Sendo regras movimentos de PRODUÇÃO, garante que o campo OP esteja como SIM³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If SUBSTRING(&(cAliasMem + "_CF"),1,2) == "PR"
	For nI := 1 To Len(aCols)
		aCols[nI][nPosOp] := "1"
	Next nI
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Replico as informações da linha anterior								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
nAtu	:= Len(aCols)
nAnt	:= Len(aCols) - 1
If Len(aCols) > 1 .AND. __READVAR == "M->Z5_FILREG"
	If SUBSTRING(&(cAliasMem + "_CF"),1,2) == "PR"
		aCols[nAtu][nPosOp] 	:= "1"
	Else
		aCols[nAtu][nPosOp] 	:= aCols[nAnt][nPosOp]
	EndIf 
	aCols[nAtu][nPosFil] 	:= aCols[nAnt][nPosFil]
	aCols[nAtu][nPosTipo] 	:= aCols[nAnt][nPosTipo]
	aCols[nAtu][nPosGrupo] 	:= aCols[nAnt][nPosGrupo]
	aCols[nAtu][nPosTm] 	:= aCols[nAnt][nPosTm]
	aCols[nAtu][nPosCta] 	:= aCols[nAnt][nPosCta]
	aCols[nAtu][nPosCtaF] 	:= aCols[nAnt][nPosCtaF]
	aCols[nAtu][nPosCc] 	:= aCols[nAnt][nPosCc]
	aCols[nAtu][nPosCcF] 	:= aCols[nAnt][nPosCcF]
	aCols[nAtu][nPosRegra] 	:= aCols[nAnt][nPosRegra]
	aCols[nAtu][nPosDeb] 	:= aCols[nAnt][nPosDeb]
	aCols[nAtu][nPosCre] 	:= aCols[nAnt][nPosCre]
EndIf 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza o grid de itens das regras³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oBrw:aCols := aCols
oBrw:oBrowse:Refresh()

Return lRet







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03W  ºAutor  ³Desenvolvimento       º Data ³ 11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pelo processamento das regras de valida- º±±
±±º          ³ção do modo de edição dos campos.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Regras de Contabilização                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C997D03W(cSufCpo)

Local lEdit		:= .T.

Default cSufCpo	:= ""

Do Case

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Regras de validação do modo de edição do campo referente ao Tipo Movimento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case cSufCpo == "_CF"
		lEdit := INCLUI
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Regras de validação do modo de edição do campo referente a Ord. Prod.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case cSufCpo == "_OP"
		lEdit := IIF(SUBSTRING(&(cAliasMem + "_CF"),1,2) == "PR", .F., .T.)

EndCase

Return lEdit






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03V  ºAutor  ³Desenvolvimento       º Data ³ 11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela validação de campos especificos da  º±±
±±º          ³rotina.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Regras de Contabilização                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C997D03V()

Local lRet		:= .T.
Local aArea	:= GetArea()

Do Case

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Edição do Tipo de Movimentação da regra de contabilização³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ALLTRIM(READVAR()) == (cAliasMem + "_CF")
		If !EMPTY(&(cAliasMem + "_CF")) .AND. INCLUI
			dbSelectArea(cAliasH)
			(cAliasH)->(dbSetOrder(1))
			(cAliasH)->(dbGoTop())
			If (cAliasH)->(dbSeek(xFilial(cAliasH) + &(cAliasMem + "_CF")))
				ShowHelpDlg("Atenção", {"Já existem regras para o tipo de movimentação selecionado."}, 5, {"Favor utilizar à funcionalidade de alteração das definições de contabilização."}, 5)
				Return .F.
			EndIf
		EndIf
		
EndCase

RestArea(aArea)

Return lRet







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03L  ºAutor  ³Desenvolvimento       º Data ³ 11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela validação de mudança de linha entre º±±
±±º          ³os itens de regras de contabilização.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Regras de Contabilização                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C997D03L()

Local lRet			:= .T.
Local aArea		:= GetArea()
Local aCols		:= oBrw:aCols
Local aHeader		:= oBrw:aHeader
Local nI			:= 0
Local nPos			:= oBrw:oBrowse:nAt
Local nPosFil		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_FILREG"})
Local nPosOp		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_OP"})
Local nPosTipo	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_TIPO"})
Local nPosGrupo	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_GRUPO"})
Local nPosTm		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_TM"})
Local nPosCta		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CONTA"})
Local nPosCtaF	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CONTAF"})
Local nPosCc		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CC"})
Local nPosCcF		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CCF"})
Local nPosRegra	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_REGRA"})
Local nPosDeb		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CTADEB"})
Local nPosCre		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CTACRE"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Valida se à conta crédito e\ou débito foram informadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If EMPTY(aCols[nPos][nPosCre]) .AND. EMPTY(aCols[nPos][nPosDeb])
	ShowHelpDlg("Atenção", {"Não foi definido à conta contábil de crédito e\ou débito da regra."}, 5, {"A regra de contabilização deve possuir à conta contábil crédito e\ou débito informada."}, 5)
	Return .F.
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Valida se não existe registro duplicado em relação das definições da regra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	For nI := 1 To Len(aCols)
		If !aCols[nI][Len(aHeader) + 1]
			If aCols[nI][nPosFil]   == aCols[nPos][nPosFil]   .AND. ;
			   aCols[nI][nPosOp]    == aCols[nPos][nPosOp]    .AND. ;
			   aCols[nI][nPosTipo]  == aCols[nPos][nPosTipo]  .AND. ;
			   aCols[nI][nPosGrupo] == aCols[nPos][nPosGrupo] .AND. ;
			   aCols[nI][nPosTm]    == aCols[nPos][nPosTm]    .AND. ;
			   aCols[nI][nPosCta]   == aCols[nPos][nPosCta]   .AND. ;
			   aCols[nI][nPosCtaF]  == aCols[nPos][nPosCtaF]  .AND. ;
			   aCols[nI][nPosCc]    == aCols[nPos][nPosCc]    .AND. ;
			   aCols[nI][nPosCcF]   == aCols[nPos][nPosCcF]   .AND. ;
			   nI != nPos
			
				ShowHelpDlg("Atenção", {"A regra atual esta definida em duplicidade em relação ao item " + STRZERO(nI, 2) + "."}, 5, {"Não pode haver mais de uma regra com as mesmas definições."}, 5)
				Return .F.
			EndIf
		EndIf
	Next nI
EndIf

RestArea(aArea)

Return lRet








/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03TDOK ºAutor  ³Desenvolvimento     º Data ³ 11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação geral\total da tela de regras de conta- º±±
±±º          ³bilização.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Regras de Contabilização                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C997D03TDOK()

Local lRet		:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se os campos obrigatórios do cabeçalho foram informados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !OBRIGATORIO(aGets, aTela)
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Validação total do grid de itens das regras de contabilização³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !oBrw:TudoOk()
	lRet := .F.
EndIf

Return lRet






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C997D03GRV  ºAutor  ³Desenvolvimento     º Data ³ 11/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de execução das regras de manipulação das informaçõesº±±
±±º          ³junto à base de dados.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Regras de Contabilização                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C997D03GRV()

Local nI			:= 0
Local nY			:= 0
Local aHeader		:= oBrw:aHeader
Local aCols		:= oBrw:aCols
Local nPosFil		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_FILREG"})
Local nPosOp		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_OP"})
Local nPosTipo	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_TIPO"})
Local nPosGrupo	:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_GRUPO"})
Local nPosTm		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_TM"})
Local nPosCta		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CONTA"})
Local nPosCC		:= aScan(aHeader, {|x| ALLTRIM(x[2]) == cAliasCpo + "_CC"})

Do Case

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras caso seja inclusão\alteração³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case INCLUI .OR. ALTERA
		BEGIN TRANSACTION
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Exclui todos os registros existentes para o tipo de movimento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If ALTERA
				dbSelectArea(cAliasH)
				(cAliasH)->(dbSetOrder(1))
				(cAliasH)->(dbGoTop())
				If (cAliasH)->(dbSeek(xFilial(cAliasH) + &(cAliasMem + "_CF")))
					While (cAliasH)->(!EOF()) .AND. &(cAliasCpo + "_FILIAL") == xFilial(cAliasH) .AND. &(cAliasCpo + "_CF") == &(cAliasMem + "_CF")
						RECLOCK(cAliasH, .F.)
							(cAliasH)->(DBDELETE())
						(cAliasH)->(MSUNLOCK())
					
						(cAliasH)->(dbSkip())
					End
				EndIf
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Realiza à inclusão dos registros³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			For nI := 1 To Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Realiza à inclusão\atualização dos campos³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					RECLOCK(cAliasH, .T.)
						For nY := 1 To Len(aHeader)
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosSZ0 := FieldPos(aHeader[nY][2]))
									(cAliasH)->(FieldPut(nPosSZ0, aCols[nI][nY])) 
								EndIf        
							EndIf
						Next nY	
						
						&(cAliasCpo + "_FILIAL") := xFilial(cAliasH)			
						&(cAliasCpo + "_CF")     := &(cAliasMem + "_CF")
					(cAliasH)->(MSUNLOCK())
				EndIf		
			Next nI
			
		END TRANSACTION
	
	
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras caso seja exclusão³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case DELETA
		BEGIN TRANSACTION
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Exclui todos os registros existentes para o tipo de movimento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea(cAliasH)
			(cAliasH)->(dbSetOrder(1))
			(cAliasH)->(dbGoTop())
			If (cAliasH)->(dbSeek(xFilial(cAliasH) + &(cAliasMem + "_CF")))
				While (cAliasH)->(!EOF()) .AND. &(cAliasCpo + "_FILIAL") == xFilial(cAliasH) .AND. &(cAliasCpo + "_CF") == &(cAliasMem + "_CF")
					RECLOCK(cAliasH, .F.)
						(cAliasH)->(DBDELETE())
					(cAliasH)->(MSUNLOCK())
				
					(cAliasH)->(dbSkip())
				End
			EndIf
		
		END TRANSACTION
		
EndCase

Return
