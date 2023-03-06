#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} User Function ICPCP004
    Tela de coleta de codigo de barras GS1
    @type  Function
    @author ICMAIS
    @since 15/10/2022
    @version 1.0
/*/
User Function ICPCP004()

	Local oBrowse := Nil

	dbSelectArea("ZGS")
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZGS")
	oBrowse:SetDescription("Coleta dados GS1")
	oBrowse:Activate()

Return




/*/{Protheus.doc} User Function MENUDEF
    Cria menu
    @type  Function
    @author ICMAIS
    @since 15/10/2022
    @version 1.0
/*/
Static Function MENUDEF()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.ICPCP004' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'U_IPCP04IC' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.ICPCP004' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.ICPCP004' OPERATION 5 ACCESS 0

Return aRotina




/*/{Protheus.doc} User Function MODELDEF
    Modelo de dados
    @type  Function
    @author ICMAIS
    @since 15/10/2022
    @version 1.0
/*/
Static Function MODELDEF()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'ZGS', {|cCampo| AllTRim(cCampo) $ "ZGS_PEDIDO;ZGS_PESO;ZGS_QTDITE"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('ASATF04M', /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldZGS', NIL, oStruCab)
	oModel:AddGrid('MdGridZGS', 'MdFieldZGS', oStruGrid, , )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridZGS', {;
		{'ZGS_FILIAL', 'xFilial("ZGS")'},;
		{'ZGS_PEDIDO',  'ZGS_PEDIDO'};
		}, ZGS->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridZGS"):SetMaxLine(9999)
	oModel:SetDescription("Coleta dados GS1")
	oModel:SetPrimaryKey({"ZGS_FILIAL", "ZGS_PEDIDO", "ZGS_ITEM"})


Return oModel




/*/{Protheus.doc} User Function VIEWDEF
    Visao dados
    @type  Function
    @author ICMAIS
    @since 15/10/2022
    @version 1.0
/*/
Static Function VIEWDEF()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('ICPCP004')
	Local oStruCab  := FWFormStruct(2, "ZGS", {|cCampo| AllTRim(cCampo) $ "ZGS_PEDIDO;ZGS_PESO;ZGS_QTDITE"})
	Local oStruGRID := fViewStruct()

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MdFieldZGS, e uma Grid vinculando com MdGridZGS
	oView:AddField('VIEW_ZGS', oStruCab, 'MdFieldZGS')
	oView:AddGrid ('GRID_ZGS', oStruGRID, 'MdGridZGS' )

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 75)

	//Vincula o MAIN com a VIEW_ZGS e a GRID com a GRID_ZGS
	oView:SetOwnerView('VIEW_ZGS', 'MAIN')
	oView:SetOwnerView('GRID_ZGS', 'GRID')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZGS_ITEM
	oView:AddIncrementField('GRID_ZGS', 'ZGS_ITEM')

Return oView




//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'ZGS')
Return oStruct




//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
	Local cCampoCom := "ZGS_PEDIDO;ZGS_PESO;ZGS_QTDITE"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "ZGS", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct





/*/{Protheus.doc} User Function IPCP04IC
    Tela paramtros pedido
    @type  Function
    @author ICMAIS
    @since 17/10/2022
    @version 1.0
/*/
User Function IPCP04IC()

	Local aArea     := GetArea()
	Local aPergs    := {}
	Local lCanSave  := .F.
	Local lUserSave := .F.

	Private cNumPed := ""

	aAdd(aPergs,{1,"Informe pedido de venda",Space(TamSX3("C5_NUM")[1]),"","ExistCpo('SC5')","SC5","",50,.T.})

	If ParamBox(aPergs, "Informe os parâmetros",,,,,,,,,lCanSave,lUserSave)
		cNumPed := MV_PAR01
		TELAINC(  )
	EndIf

	RestArea(aArea)

Return




/*/{Protheus.doc} TELAINC
    Tela cadastro de inclusao
    @type  Static Function
    @author ICMS
    @since 13/12/2021
    @version 1.0
/*/
Static Function TELAINC()

	Private oDlg     := Nil
	Private oSayItem := Nil
	Private oSayPeso := Nil
	Private oSayCnt  := Nil
	Private cGetGS1  := Space(TamSX3("ZGS_GS1")[1])
	Private cNumItem := RTMAXITEM()
	Private nCounIt  := RTCOUNTIT()
	Private nPeso    := RTTOTPES()

	oFont12n  := TFont():New("TAHOMA",0,-16,,.F.,0,,450,.T.,.F.,,,,,, )

	Define MsDialog oDlg Title 'Coleta dados GS1' From 000, 000 To 250, 480 Pixel Style DS_MODALFRAME

	oSay1 := TSay():New( 005,010,{||"Pedido: " + cNumPed},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oSay1 := TSay():New( 005,100,{||"Item: "},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSayItem := TSay():New( 005,125,{|| cNumItem},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay1 := TSay():New( 020,010,{||"Total itens: "},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
	oSayCnt := TSay():New( 020,065,{|| nCounIt},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
	oSay1 := TSay():New( 020,100,{||"Peso: "},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
	oSayPeso := TSay():New( 020,140,{|| nPeso},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
	oSay1 := TSay():New( 040,010,{||"Codigo da caixa" },oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)

	@ 060,010 GET oGetGS1 VAR cGetGS1 Picture "@!" Font oFont12n SIZE 200,15 OF oDlg PIXEL VALID (GRAVAGS1() .Or. Vazio()) //PASSWORD

	oBtnConf := TButton():New( 100,030, "&Sair",oDlg,{|| oDlg:End()},044,015,,oFont12n,,.T.,,"",,,,.F. )
	oBtnConf := TButton():New( 100,100, "&Apagar ultimo registro",oDlg,{|| DELETGS1()},100,015,,oFont12n,,.T.,,"",,,,.F. )

	//oDlg:lEscClose := .F.
	oDlg:lCentered := .T.
	Activate MsDialog oDlg

Return




/*/{Protheus.doc} teste
    Grava registro GS1
    @type  Static Function
    @author ICMAIS
    @since 18/10/2022
    @version 1.0
/*/
Static Function GRAVAGS1()

	Local cAlias     := "ZGS"
	Local bInsert    := .T.
	Local cAlSZB     := GetNextAlias()
	Local cAlSC9     := GetNextAlias()
	Local cAlZGS     := GetNextAlias()
	Local cQuery     := ""
	Local aBindParam := {}

	if !Empty(cGetGS1)

		cQuery := "SELECT SZB.ZB_PRODUTO, SZB.ZB_PESOBAL FROM "+ RetSqlName("SZB") +" SZB "
		//cQuery += " WHERE SZB.ZB_FILIAL = '"+ xFilial("SZB") +"'"
		cQuery += " WHERE SZB.ZB_ITF14 = '"+ AllTrim(cGetGS1) +"'"
		cQuery += " AND SZB.D_E_L_E_T_ = '' "

		cQuery := ChangeQuery(cQuery)

		//aBindParam := {xFilial("SZB"),AllTrim(cGetGS1),''}

		MPSysOpenQuery(cQuery,cAlSZB,,,)

		if !Empty((cAlSZB)->ZB_PRODUTO)

			cQuery := "SELECT SC9.C9_PRODUTO, SC9.C9_QTDLIB2, SC9.C9_QTDLIB   FROM "+ RetSqlName("SC9") +" SC9 "
			cQuery += " WHERE SC9.C9_FILIAL = '"+ xFilial("SZB") +"'"
			cQuery += " AND SC9.C9_PRODUTO = '"+ (cAlSZB)->ZB_PRODUTO +"' "
			cQuery += " AND SC9.C9_PEDIDO = '"+ cNumPed +"'"
			cQuery += " AND SC9.D_E_L_E_T_ = '' "

			cQuery := ChangeQuery(cQuery)

			//aBindParam := {xFilial("SZB"),(cAlias)->ZB_PRODUTO,cNumPed,''}

			MPSysOpenQuery(cQuery,cAlSC9,,,aBindParam)

			if !Empty((cAlSC9)->C9_PRODUTO)
				
					cQuery := "SELECT ZGS.ZGS_GS1 FROM "+ RetSqlName("ZGS") +" ZGS "
					cQuery += " WHERE ZGS.ZGS_FILIAL = '"+ xFilial("ZGS") +"'"
					cQuery += " AND ZGS.ZGS_GS1 = '"+ cGetGS1 +"' "
					cQuery += " AND ZGS.D_E_L_E_T_ = '' "

					cQuery := ChangeQuery(cQuery)

					MPSysOpenQuery(cQuery,cAlZGS,,,)

					if Empty((cAlZGS)->ZGS_GS1)

						RecLock(cAlias, bInsert)
						ZGS->ZGS_FILIAL := xFilial(cAlias)
						ZGS->ZGS_PEDIDO := cNumPed
						ZGS->ZGS_ITEM   := cNumItem
						ZGS->ZGS_GS1    := cGetGS1
						ZGS->ZGS_DATA   := dDataBase
						ZGS->ZGS_USER   := AllTrim( cUsername )
						(cAlias)->(MsUnlock())

						// Atualiza o label com o valor correspondente
						cNumItem := RTMAXITEM()
						oSayItem:SetText(cNumItem)
						//oSayItem:CtrlRefresh()

						//Atualiza peso
						nPeso += (cAlSZB)->ZB_PESOBAL
						oSayPeso:SetText(nPeso)
						//oSayPeso:CtrlRefresh()

						//Atualiza peso
						nCounIt := RTCOUNTIT()
						oSayCnt:SetText(nCounIt)
						//oSayCnt:CtrlRefresh()
					elseIf ApMsgNoYes("Caixa já foi bipada anteriormente. Deseja repetir a leitura da mesma? Cod: "+ AllTrim( ZGS->ZGS_GS1 ))
						//FWAlertError("Produto já foi bipado anteriormente!", "ATENÇÃO")
						RecLock(cAlias, bInsert)
						ZGS->ZGS_FILIAL := xFilial(cAlias)
						ZGS->ZGS_PEDIDO := cNumPed
						ZGS->ZGS_ITEM   := cNumItem
						ZGS->ZGS_GS1    := cGetGS1
						ZGS->ZGS_DATA   := dDataBase
						ZGS->ZGS_USER   := AllTrim( cUsername )
						(cAlias)->(MsUnlock())

						// Atualiza o label com o valor correspondente
						cNumItem := RTMAXITEM()
						oSayItem:SetText(cNumItem)
						//oSayItem:CtrlRefresh()

						//Atualiza peso
						nPeso += (cAlSZB)->ZB_PESOBAL
						oSayPeso:SetText(nPeso)
						//oSayPeso:CtrlRefresh()

						//Atualiza peso
						nCounIt := RTCOUNTIT()
						oSayCnt:SetText(nCounIt)
						
					endif
			else
				FWAlertError("Produto não possui liberação!", "ATENÇÃO")
			endif

			(cAlSC9)->(DbCloseArea())
		else
			FWAlertError("Código da caixa não foi encotrada no sistema!", "ATENÇÃO")
		endif

		(cAlSZB)->(DbCloseArea())

		//Limpa campos
		cGetGS1 := Space(TamSX3("ZGS_GS1")[1])
		oGetGS1:CtrlRefresh()

		// E manda o FOCO pro GET
		oGetGS1:SetFocus()
	endif

Return .T.




/*/{Protheus.doc} RTMAXITEM
    Retorna numero sequencial item
    @type  Static Function
    @author ICMAIS
    @since 18/10/2022
    @version 1.0
    @return cItem, caracter, numero item
/*/
Static Function RTMAXITEM()

	Local cItem      := "0001"
	Local cQuery     := ""
	Local cAlias     := GetNextAlias()
	Local aBindParam := {}
	Default lSoma    := .T.

	cQuery := "SELECT MAX(ZGS_ITEM) ITEM FROM "+ RetSqlName("ZGS") +" WHERE ZGS_FILIAL = '"+ xFilial("ZGS") +"' AND ZGS_PEDIDO = ? AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)

	aBindParam := {cNumPed}

	MPSysOpenQuery(cQuery,cAlias,,,aBindParam)

	if !Empty((cAlias)->ITEM)
		cItem := Soma1((cAlias)->ITEM)
	endif

	(cAlias)->(DbCloseArea())

Return cItem




/*/{Protheus.doc} RTCOUNTIT
    Retorna contador itens
    @type  Static Function
    @author ICMAIS
    @since 18/10/2022
    @version 1.0
    @return cItem, caracter, numero item
/*/
Static Function RTCOUNTIT()

	Local nCount     := 0
	Local cQuery     := ""
	Local cAlias     := GetNextAlias()
	Local aBindParam := {}


	cQuery := "SELECT COUNT(ZGS_PEDIDO) COUNT FROM "+ RetSqlName("ZGS") +" WHERE ZGS_FILIAL = '"+ xFilial("ZGS") +"' AND ZGS_PEDIDO = ? AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)

	aBindParam := {cNumPed}

	MPSysOpenQuery(cQuery,cAlias,,,aBindParam)

	if (cAlias)->COUNT > 0
		nCount := (cAlias)->COUNT
	endif

	(cAlias)->(DbCloseArea())

Return nCount

/*/{Protheus.doc} RTCOUNTIT
    Retorna contador itens
    @type  Static Function
    @author ICMAIS
    @since 18/10/2022
    @version 1.0
    @return cItem, caracter, numero item
/*/

Static Function RTCOUNPRD(cPrdLido)

	Local nCount     := 0
	Local cQuery     := ""
	Local cAlias     := GetNextAlias()
	Local aBindParam := {}


	cQuery := "SELECT COUNT(ZGS_PEDIDO) COUNT FROM "+ RetSqlName("ZGS") +" WHERE ZGS_FILIAL = '"+ xFilial("ZGS") +"' AND ZGS_PEDIDO = ? AND SUBSTRING(ZGS_GS1,1,8) = '" + TRIM(cPrdLido) + "' AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)

	aBindParam := {cNumPed}

	MPSysOpenQuery(cQuery,cAlias,,,aBindParam)

	if (cAlias)->COUNT > 0
		nCount := (cAlias)->COUNT
	endif

	(cAlias)->(DbCloseArea())

Return nCount




/*/{Protheus.doc} RTTOTPES
    Retorna total peso
    @type  Static Function
    @author ICMAIS
    @since 18/10/2022
    @version 1.0
    @return cItem, caracter, numero item
/*/
Static Function RTTOTPES()

	Local nPesTot    := 0
	Local cQuery     := ""
	Local cAlias     := GetNextAlias()

	cQuery := "SELECT SUM(SZB.ZB_PESOBAL) PESO FROM "+ RetSqlName("SZB") +" SZB "
	//cQuery += " WHERE SZB.ZB_ITF14 = '"+ AllTrim(cGetGS1) +"'"
	cQuery += "INNER JOIN "+ RetSqlName("ZGS") +" ZGS ON ZGS.ZGS_PEDIDO = '"+ cNumPed +"' AND ZGS.ZGS_GS1 = SZB.ZB_ITF14 AND ZGS.D_E_L_E_T_ = '' "
	cQuery += " AND SZB.D_E_L_E_T_ = '' "

	cQuery := ChangeQuery(cQuery)

	MPSysOpenQuery(cQuery,cAlias,,,)

	if (cAlias)->PESO > 0
		nPesTot := (cAlias)->PESO
	endif

	(cAlias)->(DbCloseArea())

Return nPesTot




/*/{Protheus.doc} DELETGS1
    Exclui ultimo registro GS1
    @type  Static Function
    @author ICMS
    @since 18/10/2022
    @version 1.0
/*/
Static Function DELETGS1()

	Local aArea := GetArea()
	Local cItem := RTMAXITEM()
	cItem := StrZero(Val(cItem)-1,4)

	DbSelectArea("ZGS")
	ZGS->(DbSetOrder(1))
	if dbSeek(xFilial("ZGS")+cNumPed+cItem)
		If ApMsgNoYes("Deseja realmente apagar a leitura da caixa: "+ AllTrim( ZGS->ZGS_GS1 ) +"?")
			RecLock( "ZGS", .F. )
			ZGS->( dbDelete() )
			ZGS->( MsUnlock() )

			// Atualiza o label com o valor correspondente
			cItem := RTMAXITEM()
			oSayItem:SetText(cItem)
			oSayItem:CtrlRefresh()

			//Atualiza peso
			nPeso := RTTOTPES()
			oSayPeso:SetText(nPeso)
			oSayPeso:CtrlRefresh()

			//Atualiza contador
			nCounIt := RTCOUNTIT()
			oSayCnt:SetText(nCounIt)
			oSayCnt:CtrlRefresh()
		EndIf
	endif

	oGetGS1:SetFocus()

	RestArea(aArea)

Return




/*/{Protheus.doc} User Function ICP04INI
    Retorna dados inicializacao campos
    @type  Function
    @author ICMAIS
    @since 04/11/2022
    @version version
    @param cOpcao, caracter, opcao 
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function ICP04INI(cOpcao)
	Local nRet       := 0
	Default cNumPed  := M->ZGS_PEDIDO

	Do Case
	Case cOpcao == "RTCOUNTIT"
		nRet := RTCOUNTIT()
	Case cOpcao == "RTTOTPES"
		nRet := RTTOTPES()
	EndCase

Return nRet
