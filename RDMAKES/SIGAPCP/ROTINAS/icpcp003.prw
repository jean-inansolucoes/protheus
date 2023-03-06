#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include "topconn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function ICPCP003
    Planejamento Producao
    @type  Function
    @author ICMAIS
    @since 17/11/2020
    @version 1.0
/*/
User Function ICPCP003()

	Local aArea     := GetArea()
	Local aSaveKeys	:= GetKeys()

	Local oFWLayer, oPanelPRI, oPanelCDA, oBrowseCD0 //, oRelacCD0
	Local aCoors	:=	FWGetDialogSize( oMainWnd )

	Local aStruct		:= {}
	Local aStruOP		:= {}
	Private nSelPed		:= 0
	Private cCadastro 	:= "Planejamento Produção"
	Private cAliasTMP 	:= GetNextAlias()
	Private cAliasOP 	:= GetNextAlias()
	Private cAliasPri
	Private oDlgPrinc
	Private oSayCalc
	Private oSayEst
	Private oSaySlPV
	Private oBrowsePRI
	Private oBrowseCDA

	//Cria estutura tabela pedido de vendas
	AAdd(aStruct, {"OK" 	, "C", 2  							, 0})
	AAdd(aStruct, {"FILIAL" , "C", TamSX3("C6_FILIAL")[01]  	, TamSX3("C6_FILIAL")[02]})
	AAdd(aStruct, {"PEDIDO" , "C", TamSX3("C6_NUM")[01]  		, TamSX3("C6_NUM")[02]})
	AAdd(aStruct, {"ITEM" 	, "C", TamSX3("C6_ITEM")[01]  		, TamSX3("C6_ITEM")[02]})
	AAdd(aStruct, {"PRODUTO", "C", TamSX3("C6_PRODUTO")[01]  	, TamSX3("C6_PRODUTO")[02]})
	AAdd(aStruct, {"CLIENTE", "C", TamSX3("A1_NOME")[01]  		, TamSX3("A1_NOME")[02]})
	AAdd(aStruct, {"ENTREGA", "D", TamSX3("C6_ENTREG")[01] 		, TamSX3("C6_ENTREG")[02]})
	AAdd(aStruct, {"QTDE"	, "N", TamSX3("C6_QTDVEN")[01] 		, TamSX3("C6_QTDVEN")[02]})
	AAdd(aStruct, {"OP"		, "C", TamSX3("C6_X_OPPLA")[01] 	, TamSX3("C6_X_OPPLA")[02]})
	AAdd(aStruct, {"SEQ"	, "C", TamSX3("C6_X_SQPLA")[01] 	, TamSX3("C6_X_SQPLA")[02]})

	//Cria estrutura tabela OPs
	AAdd(aStruOP, {"C2_FILIAL" 	, "C", TamSX3("C2_FILIAL")[01]  , TamSX3("C2_FILIAL")[02]})
	AAdd(aStruOP, {"C2_NUM" 	, "C", TamSX3("C2_NUM")[01]  	, TamSX3("C2_NUM")[02]})
	AAdd(aStruOP, {"C2_ITEM" 	, "C", TamSX3("C2_ITEM")[01]  	, TamSX3("C2_ITEM")[02]})
	AAdd(aStruOP, {"C2_SEQUEN" 	, "C", TamSX3("C2_SEQUEN")[01]  , TamSX3("C2_SEQUEN")[02]})
	AAdd(aStruOP, {"C2_PRODUTO" , "C", TamSX3("C2_PRODUTO")[01] , TamSX3("C2_PRODUTO")[02]})
	AAdd(aStruOP, {"C2_DATPRI" 	, "D", TamSX3("C2_DATPRI")[01] 	, TamSX3("C2_DATPRI")[02]})
	AAdd(aStruOP, {"C2_DATPRF" 	, "D", TamSX3("C2_DATPRF")[01] 	, TamSX3("C2_DATPRF")[02]})
	AAdd(aStruOP, {"C2_QUANT" 	, "N", TamSX3("C2_QUANT")[01] 	, TamSX3("C2_QUANT")[02]})
	AAdd(aStruOP, {"C2_QUJE" 	, "N", TamSX3("C2_QUJE")[01] 	, TamSX3("C2_QUJE")[02]})
	AAdd(aStruOP, {"C2_X_OPPLA" , "C", TamSX3("C2_X_OPPLA")[01] , TamSX3("C2_X_OPPLA")[02]})
	AAdd(aStruOP, {"C2_X_SQPLA" , "C", TamSX3("C2_X_SQPLA")[01] , TamSX3("C2_X_SQPLA")[02]})

	//Instance of Temporary Table
	oTempTable := FWTemporaryTable():New()
	//Set Fields
	oTempTable:SetFields(aStruct)
	//Set Indexes
	oTempTable:AddIndex("INDEX1", {"FILIAL"} )
	oTempTable:AddIndex("INDEX2", {"PEDIDO"} )
	oTempTable:AddIndex("INDEX3", {"ENTREGA"} )

	//Create
	oTempTable:Create()
	cAliasTmp := oTemptable:GetAlias()

	//Instance of Temporary Table
	oTempOP := FWTemporaryTable():New()
	//Set Fields
	oTempOP:SetFields(aStruOP)
	//Set Indexes
	oTempOP:AddIndex("INDEX1", {"C2_FILIAL"} )
	oTempOP:AddIndex("INDEX2", {"C2_NUM"} )
	oTempOP:AddIndex("INDEX3", {"C2_ITEM"} )
	oTempOP:AddIndex("INDEX4", {"C2_SEQUEN"} )

	//Create
	oTempOP:Create()
	cAliasOP := oTempOP:GetAlias()

	//Teclas de atalho
	SetKey(VK_F4, {|| VERESTOQ(SZC->ZC_PRODUTO)})

	DEFINE MSDIALOG oDlgPrinc TITLE cCadastro FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL

	oFWLayer	:=	FWLayer():New()
	oFWLayer:Init(oDlgPrinc, .F., .T.)

	oFWLayer:AddLine('PRI', 50, .F.)
	oFWLayer:AddCollumn('ALLPRI', 85, .T., 'PRI')
	oFWLayer:AddCollumn('ALLPRI2', 15, .T., 'PRI')
	oPanelPRI	:=	oFWLayer:GetColPanel('ALLPRI', 'PRI')
	oPanelSEC	:=	oFWLayer:GetColPanel('ALLPRI2', 'PRI')

	oFWLayer:AddLine('CDA', 50, .F.)
	oFWLayer:AddCollumn('ALLCDA', 100, .T., 'CDA')
	oPanelCDA	:=	oFWLayer:GetColPanel('ALLCDA', 'CDA')

	// Cria a Folder
	aTFolder := { 'Pedidos em Carteira', 'Ordens Produção' }
	oTFolder := TFolder():New( 0,0,aTFolder,,oPanelCDA,,,,.T.,,aCoors[4]/2, aCoors[3]/4 )

	// Usando o método New
	oFont := TFont():New('Tahoma',,-14,.T.,.T.)
	oSay1 := TSay():New(40,10,{||'SALDO ATUAL'},oPanelSEC,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oSayCalc := TSay():New(60,10,{||'0,00'},oPanelSEC,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oTButton := TButton():New( 80, 25,"Recalcular",oPanelSEC,{||FWMsgRun(, {|oSay| RECALCOP( oSay ) }, "Processando", "Recalculando planejamento...")}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	oSay2 := TSay():New(110,10,{||'ESTOQUE ATUAL'},oPanelSEC,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oSayEst := TSay():New(130,10,{||'0,00'},oPanelSEC,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oSay3 := TSay():New(170,10,{||'PEDIDOS SEL.'},oPanelSEC,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oSaySlPV := TSay():New(190,10,{||'0,00'},oPanelSEC,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)


	//Seleciona registros
	dbSelectArea("SZC")
	SZC->(dbGoTop())
	//FWMsgRun(, {|oSay| SLPEDIDO( oSay ) }, "Processando", "Selecionando pedidos...")
	//FWMsgRun(, {|oSay| SELOP( oSay ) }, "Processando", "Selecionando Ordens producao...")
	ATUGRIDS()

	//Planejamento
	oBrowsePRI	:=	FWMBrowse():New()
	oBrowsePRI:SetOwner(oPanelPRI)
	oBrowsePRI:SetDescription("Planejamento de Produção")
	oBrowsePRI:AddLegend( "SZC->ZC_STATUS == 'A'", "GREEN",  "Aberto" )
	oBrowsePRI:AddLegend( "SZC->ZC_STATUS == 'E'", "RED",  "Encerrado" )
	oBrowsePRI:SetAlias("SZC")
	oBrowsePRI:SetMenuDef("ICPCP003")
	oBrowsePRI:SetProfileID('1')
	oBrowsePRI:SetUseFilter(.T.)
	oBrowsePRI:DisableConfig(.F.)
	oBrowsePRI:DisableReport(.F.)
	oBrowsePRI:DisableDetails(.T.)
	oBrowsePRI:SetWalkThru(.F.)
	oBrowsePRI:SetAmbiente(.F.)
	oBrowsePRI:Activate()
	oBrowsePRI:SetChange({||  (ATUGRIDS(),oBrowseCDA:Refresh(),oBrowseCD0:Refresh()) })
	oBrowsePRI:UpdateBrowse()


	//Pedidos de Venda
	oBrowseCDA := FWMBrowse():New()
	oBrowseCDA:SetOwner(oTFolder:aDialogs[1])
	oBrowseCDA:SetAlias(cAliasTMP)
	oBrowseCDA:SetTemporary()
	oBrowseCDA:AddMarkColumns({|| IIf(Empty((cAliasTMP)->OK), "LBNO","LBOK")},; //Code-Block image
	{|| SelectOne()},; //Code-Block Double Click
	{|| SelectAll() }) //Code-Block Header Click

	oBrowseCDA:AddLegend('!Empty(OP)',"RED","Com Ordem de Planejamento")
	oBrowseCDA:AddLegend('Empty(OP)',"GREEN","Sem Ordem de Planejamento")
	oBrowseCDA:SetMenuDef("")
	/* Array da coluna
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)

	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
	*/

	oBrowseCDA:addColumn({"Filial"		, {||(cAliasTMP)->FILIAL}, "C", PesqPict("SC6","C6_FILIAL"), ,TamSX3("C6_FILIAL")[01], TamSX3("C6_FILIAL")[02], .T. , , .F.,, "FILIAL",, .F., .T., , "ETDESPES1" })
	oBrowseCDA:addColumn({"Pedido"		, {||(cAliasTMP)->PEDIDO}, "C", PesqPict("SC6","C6_NUM"), , TamSX3("C6_NUM")[01], TamSX3("C6_NUM")[02], .T. , , .F.,, "PEDIDO",, .F., .T., , "ETDESPES2" })
	oBrowseCDA:addColumn({"Item"		, {||(cAliasTMP)->ITEM}, "C", PesqPict("SC6","C6_ITEM"), , TamSX3("C6_ITEM")[01], TamSX3("C6_ITEM")[02], .T. , , .F.,, "ITEM",, .F., .T., , "ETDESPES3" })
	oBrowseCDA:addColumn({"Produto"		, {||(cAliasTMP)->PRODUTO}, "C", PesqPict("SC6","C6_PRODUTO"), , TamSX3("C6_PRODUTO")[01], TamSX3("C6_PRODUTO")[02], .T. , , .F.,, "PRODUTO",, .F., .T., , "ETDESPES4" })
	oBrowseCDA:addColumn({"Cliente"		, {||(cAliasTMP)->CLIENTE}, "C", PesqPict("SA1","A1_NOME"), 1, 100 , TamSX3("A1_NOME")[02], .T. , , .F.,, "CLIENTE",, .F., .T., , "ETDESPES5" })
	oBrowseCDA:addColumn({"Entrega"		, {||(cAliasTMP)->ENTREGA}, "D", PesqPict("SC6","C6_ENTREG"), , TamSX3("C6_ENTREG")[01], TamSX3("C6_ENTREG")[02], .T. , , .F.,, "ENTREGA",, .F., .T., , "ETDESPES6" })
	oBrowseCDA:addColumn({"Quantidade"	, {||(cAliasTMP)->QTDE}, "N", PesqPict("SC6","C6_QTDVEN"), , TamSX3("C6_QTDVEN")[01], TamSX3("C6_QTDVEN")[02], .T. , , .F.,, "QTDE",, .F., .T., , "ETDESPES7" })
	oBrowseCDA:addColumn({"Planejamento", {||(cAliasTMP)->OP}, "C", PesqPict("SC6","C6_X_OPPLA"), , TamSX3("C6_X_OPPLA")[01], TamSX3("C6_X_OPPLA")[02], .T. , , .F.,{|| ATUPPPV()}, "OP",, .F., .T., , "ETDESPES8" })
	oBrowseCDA:addColumn({"Sequencial"	, {||(cAliasTMP)->SEQ}, "C", PesqPict("SC6","C6_X_SQPLA"), , TamSX3("C6_X_SQPLA")[01], TamSX3("C6_X_SQPLA")[02], .T. , , .F.,, "SEQ",, .F., .T., , "ETDESPES9" })
	oBrowseCDA:SetProfileID('2')
	oBrowseCDA:SetDescription("Pedido de Venda")
	oBrowseCDA:SetUseFilter(.T.)
	oBrowseCDA:DisableConfig(.F.)
	oBrowseCDA:DisableReport(.F.)
	oBrowseCDA:DisableDetails(.T.)
	oBrowseCDA:SetWalkThru(.F.)
	oBrowseCDA:SetAmbiente(.F.)
	oBrowseCDA:Activate()


	//Ordens de Producao
	oBrowseCD0	:=	FWMBrowse():New()
	oBrowseCD0:SetOwner(oTFolder:aDialogs[2])
	oBrowseCD0:SetDescription("Ordens Produção")
	//oBrowseCD0:SetAlias("SC2")
	//oBrowseCD0:SetOnlyFields({'C2_FILIAL','C2_NUM','C2_ITEM','C2_SEQUEN','C2_PRODUTO','C2_DATPRI','C2_QUANT','C2_QUJE','C2_X_OPPLA','C2_X_SQPLA'})
	oBrowseCD0:SetAlias(cAliasOP)
	oBrowseCD0:SetTemporary()
	oBrowseCD0:SetMenuDef("")
	oBrowseCD0:AddLegend('!Empty(C2_X_OPPLA)',"RED","Com Ordem de Planejamento")
	oBrowseCD0:AddLegend('Empty(C2_X_OPPLA)',"GREEN","Sem Ordem de Planejamento")
	oBrowseCD0:addColumn({"Filial"		, {||(cAliasOP)->C2_FILIAL}, "C", PesqPict("SC2","C2_FILIAL"), ,TamSX3("C2_FILIAL")[01], TamSX3("C2_FILIAL")[02], .T. , , .F.,, "C2_FILIAL",, .F., .T., , "CPOSC201" })
	oBrowseCD0:addColumn({"Numero da OP", {||(cAliasOP)->C2_NUM}, "C", PesqPict("SC2","C2_NUM"), ,TamSX3("C2_NUM")[01], TamSX3("C2_NUM")[02], .T. , , .F.,, "C2_NUM",, .F., .T., , "CPOSC202" })
	oBrowseCD0:addColumn({"Item"		, {||(cAliasOP)->C2_ITEM}, "C", PesqPict("SC2","C2_ITEM"), ,TamSX3("C2_ITEM")[01], TamSX3("C2_ITEM")[02], .T. , , .F.,, "C2_ITEM",, .F., .T., , "CPOSC203" })
	oBrowseCD0:addColumn({"Sequencia"	, {||(cAliasOP)->C2_SEQUEN}, "C", PesqPict("SC2","C2_SEQUEN"), ,TamSX3("C2_SEQUEN")[01], TamSX3("C2_SEQUEN")[02], .T. , , .F.,, "C2_SEQUEN",, .F., .T., , "CPOSC204" })
	oBrowseCD0:addColumn({"Produto"		, {||(cAliasOP)->C2_PRODUTO}, "C", PesqPict("SC2","C2_PRODUTO"), ,TamSX3("C2_PRODUTO")[01], TamSX3("C2_PRODUTO")[02], .T. , , .F.,, "C2_PRODUTO",, .F., .T., , "CPOSC205" })
	oBrowseCD0:addColumn({"Previsao Ini", {||(cAliasOP)->C2_DATPRI}, "D", PesqPict("SC2","C2_DATPRI"), ,TamSX3("C2_DATPRI")[01], TamSX3("C2_DATPRI")[02], .T. , , .F.,, "C2_DATPRI",, .F., .T., , "CPOSC206" })
	oBrowseCD0:addColumn({"Entrega"		, {||(cAliasOP)->C2_DATPRF}, "D", PesqPict("SC2","C2_DATPRF"), ,TamSX3("C2_DATPRF")[01], TamSX3("C2_DATPRF")[02], .T. , , .F.,, "C2_DATPRF",, .F., .T., , "CPOSC207" })
	oBrowseCD0:addColumn({"Quantidade"	, {||(cAliasOP)->C2_QUANT}, "N", PesqPict("SC2","C2_QUANT"), ,TamSX3("C2_QUANT")[01], TamSX3("C2_QUANT")[02], .T. , , .F.,, "C2_QUANT",, .F., .T., , "CPOSC208" })
	oBrowseCD0:addColumn({"Qtd. Produz"	, {||(cAliasOP)->C2_QUJE}, "N", PesqPict("SC2","C2_QUJE"), ,TamSX3("C2_QUJE")[01], TamSX3("C2_QUJE")[02], .T. , , .F.,, "C2_QUJE",, .F., .T., , "CPOSC209" })
	oBrowseCD0:addColumn({"Planejamento", {||(cAliasOP)->C2_X_OPPLA}, "C", PesqPict("SC6","C2_X_OPPLA"), , TamSX3("C2_X_OPPLA")[01], TamSX3("C2_X_OPPLA")[02], .T. , , .F.,{|| ATUPPOP()}, "C2_X_OPPLA",, .F., .T., , "CPOSC210" })
	oBrowseCD0:addColumn({"Sequencial"	, {||(cAliasOP)->C2_X_SQPLA}, "C", PesqPict("SC6","C2_X_SQPLA"), , TamSX3("C2_X_SQPLA")[01], TamSX3("C2_X_SQPLA")[02], .T. , , .F.,, "C2_X_SQPLA",, .F., .T., , "CPOSC211" })
	oBrowseCD0:SetProfileID('3')
	oBrowseCD0:ForceQuitButton()
	oBrowseCD0:DisableDetails()
	oBrowseCD0:DisableConfig(.F.)
	oBrowseCD0:DisableReport(.F.)
	oBrowseCD0:SetWalkThru(.F.)
	oBrowseCD0:SetAmbiente(.F.)
	oBrowseCD0:SetUseFilter(.F.)
	oBrowseCD0:Activate()

	//oRelacCD0	:=	FWBrwRelation():New()
	//oRelacCD0:AddRelation(oBrowsePRI, oBrowseCD0, {{"C2_X_OPPLA","ZC_ORDEM"},{"C2_X_SQPLA","ZC_SEQ"}})
	//oRelacCD0:Activate()

	Activate MsDialog oDlgPrinc Center

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Remove definição original das teclas de atalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	RestKeys(aSaveKeys , .T.)

	//Exclui a tabela
	oTempTable:Delete()
	oTempOP:Delete()

	RestArea(aArea)

Return




/*/{Protheus.doc} SelectOne
	Marca browse
	@type  Static Function
	@author 1.0
	@since 11/12/2020
	@version version
/*/
Static Function SelectOne( lAtu )

	Local cMark		:= GetMark()
	Default lAtu	:= .F.

	if Empty((cAliasTMP)->OP)
		RecLock(cAliasTMP,.F.)
		if Empty((cAliasTMP)->OK)
			(cAliasTMP)->OK := cMark
			nSelPed += (cAliasTMP)->QTDE
		else
			(cAliasTMP)->OK := ""
			nSelPed -= (cAliasTMP)->QTDE
		endif
		(cAliasTMP)->(MsUnlock())

		oSaySlPV:SetText( Transform(nSelPed, PesqPict("SC2","C2_QUANT")) )
		oSaySlPV:CtrlRefresh()

		oBrowseCDA:Refresh()
	endif

	if lAtu .And. !Empty((cAliasTMP)->OK)
		RecLock(cAliasTMP,.F.)
		(cAliasTMP)->OK := ""
		nSelPed -= (cAliasTMP)->QTDE
		(cAliasTMP)->(MsUnlock())

		oSaySlPV:SetText( Transform(nSelPed, PesqPict("SC2","C2_QUANT")) )
		oSaySlPV:CtrlRefresh()

		oBrowseCDA:Refresh()
	EndIf

Return




/*/{Protheus.doc} SelectAll
	(long_description)
	@type  Static Function
	@author user
	@since 24/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function SelectAll(param_name)

	Local cMark		:= GetMark()

	DBSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	if (cAliasTMP)->(!Eof())
		while (cAliasTMP)->(!Eof())

			if Empty((cAliasTMP)->OP) .And. Empty((cAliasTMP)->OK)
				RecLock(cAliasTMP,.F.)
				(cAliasTMP)->OK := cMark
				nSelPed += (cAliasTMP)->QTDE
				(cAliasTMP)->(MsUnlock())
			endif

			(cAliasTMP)->(DBSkip())
		end
	endif

	DBSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())

	oSaySlPV:SetText( Transform(nSelPed, PesqPict("SC2","C2_QUANT")) )
	oSaySlPV:CtrlRefresh()

	oBrowseCDA:Refresh()


Return





/*/{Protheus.doc} ATUGRIDS
	Atualiza dado dos grids
	@type  Static Function
	@author ICMAIS
	@since 06/12/2020
	@version 1.0
/*/
Static Function ATUGRIDS()

	nSelPed := 0
	FWMsgRun(, {|oSay| SLPEDIDO( oSay ) }, "Processando", "Selecionando pedidos...")
	FWMsgRun(, {|oSay| SELOP( oSay ) }, "Processando", "Selecionando Ordens producao...")

Return




static function MenuDef()

	Local aRotina as array

	aRotina := {}
	aAdd(aRotina, {"Pesquisar"		, "AxPesqui"	, 0, 1})
	aAdd(aRotina, {"Visualizar"		, "AxVisual"	, 0, 2})
	aAdd(aRotina, {"Incluir"		, "U_IC3INCLU"	, 0, 3})
	aAdd(aRotina, {"Alterar"		, "U_IC3DETPL"	, 0, 4})
	aAdd(aRotina, {"Ajustar Status"	, "U_IC3AJSTS"	, 0, 4})
	aAdd(aRotina, {"Excluir"		, "AxDeleta"	, 0, 5})
	aAdd(aRotina, {"Gerar OP"		, "U_IC3GEROP"	, 0, 6})

return aRotina




/*/{Protheus.doc} User Function ICP003SEQ
	Rotina utilizada em gatilho para validar periodo,
	ordem e sequencia
	@type  Function
	@author ICMAIS
	@since 18/11/2020
	@version 1.0
	@return dData, data, retorna data digitada
	@example
	(examples)
	@see (links_or_references)
/*/
User Function ICP003SEQ()
	Local aArea		:= GetArea()
	Local dData		:= M->ZC_FIM
	Local cAliasTMP	:= GetNextAlias()

	cQuery := "SELECT *	"
	cQuery += "FROM " + RetSQLName("SZC") + " SZC	"
	cQuery += "WHERE SZC.ZC_FILIAL   = '" + xFilial("SZC") + "'	"
	cQuery += "  AND SZC.ZC_PRODUTO    = '" + M->ZC_PRODUTO + "' "
	cQuery += "  AND SZC.ZC_INICIO    = '" + DTOS(M->ZC_INICIO) + "' "
	cQuery += "  AND SZC.ZC_FIM    = '" + DTOS(M->ZC_FIM) + "' "
	cQuery += "  AND SZC.D_E_L_E_T_ <> '*'	"
	cQuery += "ORDER BY SZC.ZC_SEQ DESC "

	TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If (cAliasTMP)->(!EOF())
		Alert("Para este periodo já foi identificado lançamento, será ajustado ordem e sequencial!")
		M->ZC_ORDEM := (cAliasTMP)->ZC_ORDEM
		M->ZC_SEQ := SOMA1((cAliasTMP)->ZC_SEQ)
		RollBackSXE()
	EndIf

	(cAliasTMP)->(dbCloseArea())

	RestArea(aArea)

Return dData




/*/{Protheus.doc} User Function IC3GEROP
	Gera ordem de produção
	@type  Function
	@author ICMAIS
	@since 19/11/2020
	@version 1.0
/*/
User Function IC3GEROP()
	Local aArea		:= GetArea()
	Local aPergs   	:= {}
	Local nQuant   	:= 0
	Local c2Num		:= ""
	Local c2Item	:= ""
	Local c2Sequ	:= ""
	Local cUM		:= ""
	Local dDataEnt	:= CTOD("//")

	Private lMsErroAuto	:= .F.

	if SZC->ZC_STATUS == 'A'
		if ApMsgNoYes("Deseja gerar OP do planejamento " + SZC->ZC_ORDEM +" ?")

			aAdd(aPergs, {1, "Informar quantidade",  nQuant,  PesqPict("SC2","C2_QUANT"), "Positivo()", "", ".T.", 100,.T.})
			aAdd(aPergs, {1, "Entrega",  dDataEnt,  "", ".T.", "", ".T.", 60,  .T.})
			if ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
				c2Num	:= GETNUMSC2( )
				c2Item 	:= STRZERO( 1, TamSX3( "C2_ITEM" )[1], 0)
				c2Sequ 	:= STRZERO( 1, TamSX3( "C2_SEQUEN" )[1], 0)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³ Adiciona campos da Ordem de Produção para a rotina automática.      ³
				//³ O parâmetro AUTOEXPLODE indica que vai gerar as OPs intermediárias  ³
				//³ e os Empenhos automaticamente.                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cUM := Posicione("SB1",1,xFilial( "SB1" )+SZC->ZC_PRODUTO, "B1_UM" )

				aMata650  := {  {"AUTEXPLODE"	,"S"						,NIL},;
					{'C2_FILIAL'   	,xFilial( "SC2" )			,NIL},;
					{'C2_PRODUTO'  	,SZC->ZC_PRODUTO	 		,NIL},;
					{'C2_NUM'      	,c2Num         				,NIL},;
					{'C2_ITEM'     	,c2Item                		,NIL},;
					{'C2_SEQUEN'	,c2Sequ               		,NIL},;
					{'C2_QUANT'   	,MV_PAR01					,NIL},;
					{'C2_UM'   		,cUM						,NIL},;
					{'C2_DATPRI'   	,SZC->ZC_INICIO				,NIL},;
					{'C2_DATPRF'   	,MV_PAR02 /*SZC->ZC_FIM*/	,NIL},;
					{'C2_X_OPPLA'   ,SZC->ZC_ORDEM				,NIL},;
					{'C2_X_SQPLA'   ,SZC->ZC_SEQ				,NIL}}

				//Inclusao da O.P
				FWMsgRun(, {|oSay| msExecAuto( {|x,Y| Mata650(x,Y)} ,aMata650 ,3 )}, "Processando", "Gerando ordem de produção...")

				If !lMsErroAuto
					cOP := c2Num+c2Item+c2Sequ
					msgInfo( "Gerou O.P "+ cOP +" com sucesso!!!" )

					//Atualiza grid ordem produção
					SELOP()

					//Recacula OP
					RECALCOP()
				Else
					MostraErro( )
				EndIf
			else
				msgAlert("Ordem de produção não gerada!","ATENÇÃO")
			endif
		endif
	else
		msgAlert("Planejamento encerrado!","ATENÇÃO")
	endif

	RestArea(aArea)
Return




/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 23/11/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function SLPEDIDO()

	Local cQuery    := ""
	Local hEnter    := CHR( 13 )+CHR( 10 )
	Local cAlSC6    := GetNextAlias( )
	Local lShare    := .T.
	Local lReadOnly := .F.

	//Limpa os dados
	DBSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	if (cAliasTMP)->(!Eof())
		while (cAliasTMP)->(!Eof())
			RecLock(cAliasTMP, .F.)
			(cAliasTMP)->(dbDelete())
			(cAliasTMP)->(MsUnlock())
			(cAliasTMP)->(DBSkip())
		end
	endif

	cQuery := " SELECT SC6.C6_FILIAL,		    		               	" + hEnter
	cQuery += "        SC6.C6_NUM,					                    " + hEnter
	cQuery += "        SC6.C6_ITEM,					                    " + hEnter
	cQuery += "        SC6.C6_PRODUTO,				                    " + hEnter
	cQuery += "        SA1.A1_NOME,			                            " + hEnter
	cQuery += "        SC6.C6_ENTREG,		                            " + hEnter
	cQuery += "        SC6.C6_QTDVEN,		                            " + hEnter
	cQuery += "        SC6.C6_X_OPPLA,		                            " + hEnter
	cQuery += "        SC6.C6_X_SQPLA		                            " + hEnter
	cQuery += "  FROM " + RetSQLName( "SC6" ) + " SC6                   " + hEnter
	cQuery += "  INNER JOIN " + RetSQLName( "SA1" ) + " SA1             " + hEnter
	cQuery += "     ON SA1.A1_COD = SC6.C6_CLI		                    " + hEnter
	cQuery += "     AND SA1.A1_LOJA = SC6.C6_LOJA	                    " + hEnter
	cQuery += "     AND SA1.D_E_L_E_T_ <> '*'                           " + hEnter
	cQuery += " WHERE SC6.C6_ENTREG BETWEEN '"+DTOS(SZC->ZC_INICIO)+ "' " + hEnter
	cQuery += "     AND '"+DTOS(SZC->ZC_FIM)+"'            				" + hEnter
	cQuery += "     AND SC6.C6_PRODUTO = '"+ SZC->ZC_PRODUTO +"'  		" + hEnter
	cQuery += "     AND ( ( SC6.C6_X_OPPLA = '' AND SC6.C6_NOTA = '' )	" + hEnter
	cQuery += "     	OR ( SC6.C6_X_OPPLA = '"+ SZC->ZC_ORDEM +"'		" + hEnter
	cQuery += "     	AND SC6.C6_X_SQPLA = '"+ SZC->ZC_SEQ +"' ) ) 	" + hEnter
	cQuery += "     AND SC6.C6_OPER = '01'	                           	" + hEnter
	cQuery += "   AND SC6.D_E_L_E_T_ <> '*'                             " + hEnter
	cQuery += " ORDER BY SC6.C6_FILIAL 		                            " + hEnter

	If Select( cAlSC6 ) > 0
		( cAlSC6 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC6 , lShare, lReadOnly )

	( cAlSC6 )->( dBGoTop()( ) )

	If !( cAlSC6 )->( EOF( ) )

		While !( cAlSC6 )->( EOF( ) )
			If (RecLock(cAliasTMP, .T.))
				(cAliasTMP)->OK	 	 := ""
				(cAliasTMP)->FILIAL	 := ( cAlSC6 )->C6_FILIAL
				(cAliasTMP)->PEDIDO	 := ( cAlSC6 )->C6_NUM
				(cAliasTMP)->ITEM	 := ( cAlSC6 )->C6_ITEM
				(cAliasTMP)->PRODUTO := ( cAlSC6 )->C6_PRODUTO
				(cAliasTMP)->CLIENTE := ( cAlSC6 )->A1_NOME
				(cAliasTMP)->ENTREGA := STOD(( cAlSC6 )->C6_ENTREG)
				(cAliasTMP)->QTDE 	 := ( cAlSC6 )->C6_QTDVEN
				(cAliasTMP)->OP 	 := ( cAlSC6 )->C6_X_OPPLA
				(cAliasTMP)->SEQ 	 := ( cAlSC6 )->C6_X_SQPLA
				(cAliasTMP)->(MsUnlock())
			EndIf

			( cAlSC6 )->( dBSkip() )
		EndDo
	Endif

	If Select( cAlSC6 ) > 0
		( cAlSC6 )->( dBCloseArea( ) )
	EndIf

	//Posiciona no primeiro registro
	(cAliasTMP)->(DbGoTop())

	//Atualiza saldo
	SALDOTEL()

Return




/*/{Protheus.doc} SELOP
	Seleciona ordens de producao
	@type  Static Function
	@author ICMAIS
	@since 06/12/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function SELOP()

	Local cQuery    := ""
	Local hEnter    := CHR( 13 )+CHR( 10 )
	Local cAlSC2    := GetNextAlias( )
	Local lShare    := .T.
	Local lReadOnly := .F.

	//Limpa os dados
	DBSelectArea(cAliasOP)
	(cAliasOP)->(DbGoTop())
	if (cAliasOP)->(!Eof())
		while (cAliasOP)->(!Eof())
			RecLock(cAliasOP, .F.)
			(cAliasOP)->(dbDelete())
			(cAliasOP)->(MsUnlock())
			(cAliasOP)->(DBSkip())
		end
	endif

	cQuery := " SELECT SC2.C2_FILIAL,		    		               	" + hEnter
	cQuery += "        SC2.C2_NUM,					                    " + hEnter
	cQuery += "        SC2.C2_ITEM,					                    " + hEnter
	cQuery += "        SC2.C2_SEQUEN,				                    " + hEnter
	cQuery += "        SC2.C2_PRODUTO,		                            " + hEnter
	cQuery += "        SC2.C2_DATPRI,		                            " + hEnter
	cQuery += "        SC2.C2_DATPRF,		                            " + hEnter
	cQuery += "        SC2.C2_QUANT,		                            " + hEnter
	cQuery += "        SC2.C2_QUJE,			                            " + hEnter
	cQuery += "        SC2.C2_X_OPPLA,		                            " + hEnter
	cQuery += "        SC2.C2_X_SQPLA		                            " + hEnter
	cQuery += "  FROM " + RetSQLName( "SC2" ) + " SC2                   " + hEnter
	cQuery += " WHERE SC2.C2_DATPRI BETWEEN '"+DTOS(SZC->ZC_INICIO)+ "' " + hEnter
	cQuery += "     AND '"+DTOS(SZC->ZC_FIM)+"'            				" + hEnter
	cQuery += "     AND SC2.C2_PRODUTO = '"+ SZC->ZC_PRODUTO +"'  		" + hEnter
	cQuery += "     AND ( SC2.C2_X_OPPLA = '' 							" + hEnter
	cQuery += "     	OR ( SC2.C2_X_OPPLA = '"+ SZC->ZC_ORDEM +"'		" + hEnter
	cQuery += "     	AND SC2.C2_X_SQPLA = '"+ SZC->ZC_SEQ +"' ) ) 	" + hEnter
	cQuery += "   AND SC2.D_E_L_E_T_ <> '*'                             " + hEnter
	cQuery += " ORDER BY SC2.C2_FILIAL 		                            " + hEnter

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC2 , lShare, lReadOnly )

	( cAlSC2 )->( dBGoTop()( ) )

	If !( cAlSC2 )->( EOF( ) )

		While !( cAlSC2 )->( EOF( ) )
			If (RecLock(cAliasOP, .T.))
				(cAliasOP)->C2_FILIAL	:= ( cAlSC2 )->C2_FILIAL
				(cAliasOP)->C2_NUM	 	:= ( cAlSC2 )->C2_NUM
				(cAliasOP)->C2_ITEM	 	:= ( cAlSC2 )->C2_ITEM
				(cAliasOP)->C2_SEQUEN 	:= ( cAlSC2 )->C2_SEQUEN
				(cAliasOP)->C2_PRODUTO 	:= ( cAlSC2 )->C2_PRODUTO
				(cAliasOP)->C2_DATPRI 	:= STOD(( cAlSC2 )->C2_DATPRI)
				(cAliasOP)->C2_DATPRF 	:= STOD(( cAlSC2 )->C2_DATPRF)
				(cAliasOP)->C2_QUANT 	:= ( cAlSC2 )->C2_QUANT
				(cAliasOP)->C2_QUJE 	:= ( cAlSC2 )->C2_QUJE
				(cAliasOP)->C2_X_OPPLA 	:= ( cAlSC2 )->C2_X_OPPLA
				(cAliasOP)->C2_X_SQPLA 	:= ( cAlSC2 )->C2_X_SQPLA
				(cAliasOP)->(MsUnlock())
			EndIf

			( cAlSC2 )->( dBSkip() )
		EndDo
	Endif

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	//Posiciona no primeiro registro
	(cAliasOP)->(DbGoTop())

	//Atualiza saldo
	SALDOTEL()

Return




/*/{Protheus.doc} RECALCOP
	(long_description)
	@type  Static Function
	@author user
	@since 25/11/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function RECALCOP()
	Local aArea		:= GetArea()
	Local cQuery    := ""
	Local hEnter    := CHR( 13 )+CHR( 10 )
	Local cAlSC6    := GetNextAlias( )
	Local cAlSC2    := GetNextAlias( )
	Local lShare    := .T.
	Local lReadOnly := .F.
	Local nTmpVlr	:= 0

	//Realiza soma pedido em carteira vinculado
	cQuery := " SELECT SUM(SC6.C6_QTDVEN) CARTEIRA   		       	" + hEnter
	cQuery += "  FROM " + RetSQLName( "SC6" ) + " SC6            	" + hEnter
	cQuery += " WHERE SC6.C6_X_OPPLA =  '"+ SZC->ZC_ORDEM +"' 		" + hEnter
	cQuery += "	 AND SC6.C6_X_SQPLA = '"+ SZC->ZC_SEQ +"'  			" + hEnter
	cQuery += "	 AND SC6.D_E_L_E_T_ <> '*'                       	" + hEnter

	If Select( cAlSC6 ) > 0
		( cAlSC6 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC6 , lShare, lReadOnly )

	( cAlSC6 )->( dBGoTop()( ) )

	nTmpVlr := 0
	If ( cAlSC6 )->CARTEIRA > 0
		nTmpVlr := ( cAlSC6 )->CARTEIRA
	Endif
	If (RecLock("SZC", .F.))
		SZC->ZC_CARTEIR	 := nTmpVlr
		SZC->(MsUnlock())
	EndIf

	If Select( cAlSC6 ) > 0
		( cAlSC6 )->( dBCloseArea( ) )
	EndIf


	//Realiza soma pedido sem carteira
	cQuery := " SELECT SUM(SC6.C6_QTDVEN) CARTEIRA   		        	" + hEnter
	cQuery += "  FROM " + RetSQLName( "SC6" ) + " SC6                   " + hEnter
	cQuery += " WHERE SC6.C6_ENTREG BETWEEN '"+DTOS(SZC->ZC_INICIO)+ "' " + hEnter
	cQuery += "     AND '"+DTOS(SZC->ZC_FIM)+"'            				" + hEnter
	cQuery += "     AND SC6.C6_PRODUTO = '"+ SZC->ZC_PRODUTO +"'  		" + hEnter
	cQuery += "     AND SC6.C6_OPER = '01'	                           	" + hEnter
	cQuery += "     AND SC6.C6_X_OPPLA = ''	                           	" + hEnter
	cQuery += "     AND SC6.C6_X_SQPLA = ''	                           	" + hEnter
	cQuery += "   	AND SC6.D_E_L_E_T_ <> '*'                           " + hEnter
	If Select( cAlSC6 ) > 0
		( cAlSC6 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC6 , lShare, lReadOnly )

	( cAlSC6 )->( dBGoTop()( ) )

	nTmpVlr := 0
	If ( cAlSC6 )->CARTEIRA > 0
		nTmpVlr := ( cAlSC6 )->CARTEIRA
	Endif
	If (RecLock("SZC", .F.))
		SZC->ZC_QTDPED	 := nTmpVlr
		SZC->(MsUnlock())
	EndIf

	If Select( cAlSC6 ) > 0
		( cAlSC6 )->( dBCloseArea( ) )
	EndIf


	//Realiza soma OP produzidas
	cQuery := " SELECT SUM(SC2.C2_QUJE) PRODUZIDO  		       		" + hEnter
	cQuery += "  FROM " + RetSQLName( "SC2" ) + " SC2            	" + hEnter
	cQuery += " WHERE SC2.C2_X_OPPLA =  '"+ SZC->ZC_ORDEM +"' 		" + hEnter
	cQuery += "	 AND SC2.C2_X_SQPLA = '"+ SZC->ZC_SEQ +"'  			" + hEnter
	cQuery += "	 AND SC2.D_E_L_E_T_ <> '*'                       	" + hEnter

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC2 , lShare, lReadOnly )

	( cAlSC2 )->( dBGoTop()( ) )

	nTmpVlr := 0
	If ( cAlSC2 )->PRODUZIDO > 0
		nTmpVlr := ( cAlSC2 )->PRODUZIDO
	Endif
	If (RecLock("SZC", .F.))
		SZC->ZC_PRODUZ	 := nTmpVlr
		SZC->(MsUnlock())
	EndIf

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf


	//Realiza soma OP previstas
	cQuery := " SELECT SUM(SC2.C2_QUANT) PREVISTO 		       		" + hEnter
	cQuery += "  FROM " + RetSQLName( "SC2" ) + " SC2            	" + hEnter
	cQuery += " WHERE SC2.C2_X_OPPLA =  '"+ SZC->ZC_ORDEM +"' 		" + hEnter
	cQuery += "	 AND SC2.C2_X_SQPLA = '"+ SZC->ZC_SEQ +"'  			" + hEnter
	cQuery += "	 AND SC2.D_E_L_E_T_ <> '*'                       	" + hEnter

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC2 , lShare, lReadOnly )

	( cAlSC2 )->( dBGoTop()( ) )

	nTmpVlr := 0
	If ( cAlSC2 )->PREVISTO > 0
		nTmpVlr := ( cAlSC2 )->PREVISTO
	Endif
	If (RecLock("SZC", .F.))
		SZC->ZC_QTDOP 	:= nTmpVlr
		SZC->(MsUnlock())
	EndIf

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	//Atualiza campos de saldos
	If (RecLock("SZC", .F.))
		SZC->ZC_SLDPED	 := SZC->ZC_QTDPED
		SZC->ZC_SLDOP	 := SZC->ZC_PRODUZ - SZC->ZC_QTDOP
		SZC->(MsUnlock())
	EndIf

	//Atualiza saldo
	SALDOTEL()

	oBrowsePRI:Refresh()

	RestArea(aArea)

Return




/*/{Protheus.doc} ATUPPPV
	Atualiza grid e pedido com ordem de 
	planejamento
	@type  Static Function
	@author ICMAIS
	@since 23/11/2020
	@version 1.0
/*/
Static Function ATUPPPV()

	if Empty((cAliasTMP)->OP)
		if ApMsgNoYes("Deseja <b>VINCULAR</b> planejamento neste pedido?","Confirmação" )
			if (RecLock(cAliasTMP, .F.))
				(cAliasTMP)->OP	 := SZC->ZC_ORDEM
				(cAliasTMP)->SEQ := SZC->ZC_SEQ
				(cAliasTMP)->(MsUnlock())

				dbSelectArea("SC6")
				SC6->(dbSetOrder(1))
				SC6->(dbGoTop())
				if dbSeek((cAliasTMP)->(FILIAL+PEDIDO+ITEM+PRODUTO))
					RecLock("SC6", .F.)
					SC6->C6_X_OPPLA := SZC->ZC_ORDEM
					SC6->C6_X_SQPLA := SZC->ZC_SEQ
					SC6->(MsUnlock())
				endif
			endif
		endif
	else
		if ApMsgNoYes("Deseja <b>DESVINCULAR</b> planejamento neste pedido?","Confirmação" )
			if (RecLock(cAliasTMP, .F.))
				(cAliasTMP)->OP	 := ""
				(cAliasTMP)->SEQ := ""
				(cAliasTMP)->(MsUnlock())

				dbSelectArea("SC6")
				SC6->(dbSetOrder(1))
				SC6->(dbGoTop())
				if dbSeek((cAliasTMP)->(FILIAL+PEDIDO+ITEM+PRODUTO))
					RecLock("SC6", .F.)
					SC6->C6_X_OPPLA := ""
					SC6->C6_X_SQPLA := ""
					SC6->(MsUnlock())
				endif
			endif
		endif
	endif

	//Atualiza pedidos selecionados
	SelectOne( .T. )

	//Recacula OP
	RECALCOP()

Return




/*/{Protheus.doc} ATUPPOP
	Atualiza grid ordem com producao com 
	planejamento
	@type  Static Function
	@author ICMAIS
	@since 06/12/2020
	@version 1.0
/*/
Static Function ATUPPOP()

	if Empty((cAliasOP)->C2_X_OPPLA)
		if ApMsgNoYes("Deseja <b>VINCULAR</b> planejamento nesta ordem de produção?","Confirmação" )
			if (RecLock(cAliasOP, .F.))
				(cAliasOP)->C2_X_OPPLA	:= SZC->ZC_ORDEM
				(cAliasOP)->C2_X_SQPLA 	:= SZC->ZC_SEQ
				(cAliasOP)->(MsUnlock())

				dbSelectArea("SC2")
				SC2->(dbSetOrder(6))
				SC2->(dbGoTop())
				if dbSeek((cAliasOP)->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_PRODUTO))
					RecLock("SC2", .F.)
					SC2->C2_X_OPPLA := SZC->ZC_ORDEM
					SC2->C2_X_SQPLA := SZC->ZC_SEQ
					SC2->(MsUnlock())
				endif
			endif
		endif
	else
		if ApMsgNoYes("Deseja <b>DESVINCULAR</b> planejamento nesta ordem de produção?","Confirmação" )
			if (RecLock(cAliasOP, .F.))
				(cAliasOP)->C2_X_OPPLA	:= ""
				(cAliasOP)->C2_X_SQPLA 	:= ""
				(cAliasOP)->(MsUnlock())

				dbSelectArea("SC2")
				SC2->(dbSetOrder(6))
				SC2->(dbGoTop())
				if dbSeek((cAliasOP)->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_PRODUTO))
					RecLock("SC2", .F.)
					SC2->C2_X_OPPLA := ""
					SC2->C2_X_SQPLA := ""
					SC2->(MsUnlock())
				endif
			endif
		endif
	endif

	//Recacula OP
	RECALCOP()

Return




/*/{Protheus.doc} SALDOTEL
	Atualiza saldo da tela
	@type  Static Function
	@author ICMAIS
	@since 25/11/2020
	@version 1.0
/*/
Static Function SALDOTEL()

	Local aArea		:= GetArea()
	Local nSaldo	:= 0

	//Consulta estoque atual produto
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	if dbSeek(xFilial("SB1")+SZC->ZC_PRODUTO)
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		SB2->(dbGoTop())
		if dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
			nSaldo := SB2->B2_QATU
		endif
	endif

	//Atualiza saldo tela
	oSayCalc:SetText( Transform(SZC->ZC_PLANEJA - SZC->ZC_PRODUZ,PesqPict("SZC","ZC_PLANEJA")) )
	oSayCalc:CtrlRefresh()

	oSayEst:SetText( Transform(nSaldo, PesqPict("SB2","B2_QATU")) )
	oSayEst:CtrlRefresh()

	oSaySlPV:SetText( Transform(nSelPed, PesqPict("SC2","C2_QUANT")) )
	oSaySlPV:CtrlRefresh()

	RestArea(aArea)

Return





/*/{Protheus.doc} VERESTOQ
	Mostra estoque do produto posicionado
	em todas as filiais
	@type  Static Function
	@author ICMAIS
	@since 07/01/2021
	@version version
	@param cCodProd, caracater, codigo produto
/*/
Static Function VERESTOQ(cCodProd)

	Local aArea		:= GetArea()
	Local cQuery 	:= ""
	Local aHeaderx 	:= {}
	Local aColsx 	:= {}
	Local cLocal	:= AllTrim(GetMv("MV_X_LOCAL"))

	cQuery := "SELECT * "
	cQuery += " FROM "+ RetSQLName("SB2")+ " SB2 "
	cQuery += " WHERE SB2.B2_COD = '" + cCodProd + "' "
	cQuery += " AND SB2.B2_LOCAL IN ("+ cLocal +")"
	cQuery += " AND SB2.D_E_L_E_T_ != '*'"
	cQuery += " ORDER BY SB2.B2_FILIAL, SB2.B2_LOCAL "

	AADD(aHeaderx, { "Filial"	 		, "B2_FILIAL"  	, "@"                  		, TamSX3("B2_FILIAL")[01], TamSX3("B2_FILIAL")[02],".F.", /*SX3->X3_USADO*/, "C",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeaderx, { "Produto"	 		, "B2_COD"  	, "@"                  		, TamSX3("B2_COD")[01], TamSX3("B2_COD")[02],".F.", /*SX3->X3_USADO*/, "C",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeaderx, { "Armazem"	 		, "B2_LOCAL" 	, "@"                  		, TamSX3("B2_LOCAL")[01], TamSX3("B2_LOCAL")[02],".F.", /*SX3->X3_USADO*/, "C",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeaderx, { "Poder terceiros"	, "B2_QTER"    	, PesqPict("SB2","B2_QTER")	, TamSX3("B2_QTER ")[01], TamSX3("B2_QTER ")[02],".F.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeaderx, { "Saldo em Estoque"	, "B2_QATU"    	, PesqPict("SB2","B2_QATU")	, TamSX3("B2_QATU")[01], TamSX3("B2_QATU")[02],".F.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

	DbSelectArea("TMP")
	TMP->(DbGoTop())

	While !TMP->(EOF())
		AADD(aColsx, {TMP->B2_FILIAL, TMP->B2_COD,TMP->B2_LOCAL,TMP->B2_QTER,B2_QATU,.F.})
		TMP->(dbSkip())
	EndDo

	DEFINE MSDIALOG oDlg TITLE "Consulta de Estoques" FROM 000,000 TO 300, 650 OF oMainWnd PIXEL

	oBrowse := MsNewGetDados():New(5, 5, 145, 325,/*GD_UPDATE*/,,,,/*aAlter*/,,,,,,oDlg,aHeaderx,aColsx)

	ACTIVATE MSDIALOG oDlg CENTERED

	TMP->(DbCloseArea())

	RestArea(aArea)

Return




/*/{Protheus.doc} User Function IC3INCLU
	Realiza inclusao do registro planejamento e
	detalhamento
	@type  Function
	@author ICMAIS
	@since 17/03/2021
	@version 1.0
/*/
User Function IC3INCLU()
	Local nRet	 	:= 0

	nRet := AXINCLUI("SZC",0,3,/*aAcho*/,/*cFunc*/,/*aCpos*/,/**/)
	if nRet == 1
		//Planejamento diario
		INCPLDIA()

		//Planejamento semanal
		INCPLSEM()
	endif

Return




/*/{Protheus.doc} INCPLDIA
	Inclusao planejamento diario
	@type  Static Function
	@author ICMAIS
	@since 22/03/2021
	@version 1.0
/*/
Static Function INCPLDIA()
	Local nDias	 	:= 0
	Local nPlan	 	:= 0
	Local nPlanD 	:= 0
	Local nX	 	:= 0
	Local cData	 	:= ""

	nDias 	:= Day( SZC->ZC_FIM )
	nPlan 	:= SZC->ZC_PLANEJA
	nPlanD	:= nPlan / nDias
	cData	:= AllTrim(Str(Year(SZC->ZC_FIM))+StrZero(Month(SZC->ZC_FIM),2))

	//Planejamento diario
	for nX := 1 to nDias
		RecLock("SZD",.T.)
		SZD->ZD_FILIAL 	:= xFilial("SZD")
		SZD->ZD_ORDEM 	:= SZC->ZC_ORDEM
		SZD->ZD_SEQ		:= SZC->ZC_SEQ
		SZD->ZD_PLANEJA	:= nPlanD
		SZD->ZD_DATA	:= StoD(cData + StrZero(nX,2))
		SZD->(MsUnlock())
	next

Return




/*/{Protheus.doc} INCPLSEM
	Inclusao planejamento semanal
	@type  Static Function
	@author ICMAIS
	@since 22/03/2021
	@version 1.0
/*/
Static Function INCPLSEM()
	Local aSemanas	:= {}
	Local nX		:= 0
	Local nDias		:= 0
	Local nPlan		:= 0
	Local nPlanD	:= 0

	nDias 	:= Day( SZC->ZC_FIM )
	nPlan 	:= SZC->ZC_PLANEJA
	nPlanD	:= nPlan / nDias

	aSemanas := RTSEMMES(SZC->ZC_INICIO, SZC->ZC_FIM, .F.)
	if len(aSemanas)
		for nX := 1 to len(aSemanas)
			RecLock("SZE",.T.)
			SZE->ZE_FILIAL 	:= xFilial("SZE")
			SZE->ZE_ORDEM 	:= SZC->ZC_ORDEM
			SZE->ZE_SEQ		:= SZC->ZC_SEQ
			SZE->ZE_REVISAO	:= "001"
			SZE->ZE_SEMANA	:= StrZero(nX,2)
			SZE->ZE_SEMINI	:= aSemanas[nX][1]
			SZE->ZE_SEMFIM	:= aSemanas[nX][2]
			SZE->ZE_PLANEJA	:= nPlanD * ((aSemanas[nX][2]-aSemanas[nX][1])+1)
			SZE->(MsUnlock())
		next
	endif
	
Return




/*/{Protheus.doc} User Function IC3DETPL
	Tela detalhamento planejamento
	@type  Function
	@author ICMAIS
	@since 17/03/2021
	@version 1.0
/*/
User Function IC3DETPL(param_name)
    Local aHeadDia  	:= {}
    Local aAlteSem 	  	:= {"ZE_PLANEJA"}
	Local nTotPlan		:= 0
	Local cUltRev		:= LASTREV()
	Private aHeadSem  	:= {}
    Private aColsSem  	:= {}
    Private aColsDia  	:= {}
	Private oBroSem		as object
	Private oSPlaAjus	as object

    //Define campos planejamento diario
	AADD(aHeadDia, { "Planejamento"		, "ZD_ORDEM"  	, PesqPict("SZD","ZD_ORDEM")	, TamSX3("ZD_ORDEM")[01], TamSX3("ZD_ORDEM")[02],".F.", /*SX3->X3_USADO*/, "C",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadDia, { "Dia"	 		    , "ZD_DATA"  	, PesqPict("SZD","ZD_DATA")  	, TamSX3("ZD_DATA")[01], TamSX3("ZD_DATA")[02],".F.", /*SX3->X3_USADO*/, "D",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadDia, { "Planejado"	    , "ZD_PLANEJA" 	, PesqPict("SZD","ZD_PLANEJA")	, TamSX3("ZD_PLANEJA ")[01], TamSX3("ZD_PLANEJA")[02],".F.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadDia, { "Produzido"	    , "ZD_PRODUZ" 	, PesqPict("SZD","ZD_PRODUZ")	, TamSX3("ZD_PRODUZ ")[01], TamSX3("ZD_PRODUZ")[02],".F.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadDia, { "Previsto"	        , "ZD_PREVIST" 	, PesqPict("SZD","ZD_PREVIST")	, TamSX3("ZD_PREVIST ")[01], TamSX3("ZD_PREVIST")[02],".F.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})

	FWMsgRun(, {|oSay| COSPLDIA() }, "Processando", "Carregando planejamento diario...")

    //Define campos planejamento semanal
	AADD(aHeadSem, { "Planejamento"		, "ZE_ORDEM"  	, PesqPict("SZE","ZE_ORDEM")   	, TamSX3("F2_DOC")[01], TamSX3("F2_DOC")[02],".F.", /*SX3->X3_USADO*/, "C",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadSem, { "Semana"			, "ZE_SEMANA"  	, "@"                  			, 25, 0,".F.", /*SX3->X3_USADO*/, "C",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadSem, { "Planejado"	    , "ZE_PLANEJA" 	, PesqPict("SZE","ZE_PLANEJA")	, TamSX3("ZE_PLANEJA ")[01], TamSX3("ZE_PLANEJA")[02],".T.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadSem, { "Produzido"	    , "ZE_PRODUZ"   , PesqPict("SZE","ZE_PRODUZ")	, TamSX3("ZE_PRODUZ ")[01], TamSX3("ZE_PRODUZ")[02],".F.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})
	AADD(aHeadSem, { "Previsto"	        , "ZE_PREVIST" 	, PesqPict("SZE","ZE_PREVIST")	, TamSX3("ZE_PREVIST ")[01], TamSX3("ZE_PREVIST")[02],".F.", /*SX3->X3_USADO*/, "N",/*SX3->X3_F3*/, /*SX3->X3_CONTEXT*/})

	FWMsgRun(, {|oSay| COSPLSEM() }, "Processando", "Carregando planejamento semana...")

	//Soma planejamento semanal
	dbSelectArea("SZE")
	SZE->(dbSetOrder(2))
	SZE->(dbGoTop())
	if dbSeek(xFilial("SZE")+SZC->ZC_ORDEM+SZC->ZC_SEQ+cUltRev)
		while SZE->(!Eof()) .And. SZE->ZE_ORDEM == SZC->ZC_ORDEM .And. SZE->ZE_SEQ == SZC->ZC_SEQ
			nTotPlan += SZE->ZE_PLANEJA
			SZE->(dbSkip())
		end
	endif

	DEFINE MSDIALOG oDlg TITLE "Detalhe do planejamento" FROM 000,000 TO 720, 1300 OF oMainWnd PIXEL

	oFont := TFont():New('Tahoma',,-12,.T.,.F.)
	oFontB := TFont():New('Tahoma',,-12,.T.,.T.)

	//Planejamento
	oGrpPla := TGroup():New(02,02,40,650,'',oDlg,,,.T.)
	oSay01 := TSay():New(10,10,{||'Planejamento'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay02 := TSay():New(25,10,{||SZC->ZC_ORDEM},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oSay03 := TSay():New(10,60,{||'Seq'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay04 := TSay():New(25,60,{||SZC->ZC_SEQ},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oSay05 := TSay():New(10,80,{||'Produto'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay06 := TSay():New(25,80,{||AllTrim(SZC->ZC_PRODUTO)+" - "+AllTrim(SZC->ZC_DESC)},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oSay07 := TSay():New(10,230,{||'Inicio'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay08 := TSay():New(25,230,{||DTOC(SZC->ZC_INICIO)},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oSay09 := TSay():New(10,280,{||'Fim'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay10 := TSay():New(25,280,{||DTOC(SZC->ZC_FIM)},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oSay09 := TSay():New(10,330,{||'Planejamento'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay10 := TSay():New(25,330,{||AllTrim(Transform(SZC->ZC_PLANEJA,PesqPict("SZC","ZC_PLANEJA")))},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	
    oSay11 := TSay():New(10,385,{||'Produzido'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay12 := TSay():New(25,385,{||AllTrim(Transform(SZC->ZC_PRODUZ,PesqPict("SZC","ZC_PLANEJA")))},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)
    
    oSay13 := TSay():New(10,440,{||'Saldo Atual'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSay14 := TSay():New(25,440,{||AllTrim(Transform(SZC->ZC_PLANEJA - SZC->ZC_PRODUZ,PesqPict("SB2","B2_QATU")))},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)
    
	oSay15 := TSay():New(10,520,{||'Planejamento ajustado'},oGrpPla,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	oSPlaAjus := TSay():New(25,535,{||AllTrim(Transform(nTotPlan,PesqPict("SZC","ZC_PLANEJA")))},oGrpPla,,oFontB,,,,.T.,CLR_RED,CLR_WHITE,200,20)
    
    //Planejamento diario
	oGrpDia := TGroup():New(50,02,355,300,' Planejamento Diario ',oDlg,,,.T.)
	oBroDia := MsNewGetDados():New(60, 5, 350, 295,/*GD_UPDATE*/,,,,/*aAlter*/,,,,,,oGrpDia,aHeadDia,aColsDia)

    //Planejamento semanal
	oGrpSem := TGroup():New(50,310,270,650,' Planejamento Semanal ',oDlg,,,.T.)
    oBroSem := MsNewGetDados():New(60, 315, 265, 645,GD_UPDATE,,,,aAlteSem,,,"U_IP3QDPLA()",,,oGrpSem,aHeadSem,aColsSem)

    //Botoes
    oBtnConf  := TButton():New( 280,550, "&Confirmar",oDlg,{|| ( GRVREVIS(cUltRev), Close( oDlg ) ) },044,012,,,,.T.,,"",,,,.F. )
    oBtnCanc  := TButton():New( 280,600, "Ca&ncelar",oDlg,{|| Close( oDlg ) },044,012,,,,.T.,,"",,,,.F. )

	ACTIVATE MSDIALOG oDlg CENTERED

Return




/*/{Protheus.doc} TESTE
	Calcula valor planejamento ajustado
	@type  Static Function
	@author ICMAIS
	@since 23/03/2021
	@version 1.0
	@return lRet, logico, validacao
/*/
User Function IP3QDPLA()
	Local nX		:= 0
	Local nTotal	:= 0
	Local nPosPla	:= aScan(aHeadSem, {|x| ALLTRIM(x[2]) == "ZE_PLANEJA"})

	for nX := 1 to Len(oBroSem:aCols)
		if nX == oBroSem:nAT
			nTotal += M->ZE_PLANEJA
		else
			nTotal += oBroSem:aCols[nX,nPosPla]	
		endif
		
	next

	oSPlaAjus:SetText( Transform(nTotal, PesqPict("SZC","ZC_PLANEJA")) )
	oSPlaAjus:CtrlRefresh()
	oBroSem:Refresh()

Return .T.




/*/{Protheus.doc} RTSEMMES
	(long_description)
	@type  Static Function
	@author ICMAIS
	@since 19/03/2021
	@version 1.0
	@param dDataIni, data, data inicial
	@param dDataFim, data, data final
	@param lQuebDif, logico, quebra semana no sabado
	@return aSemanas, return_type, return_description
/*/
Static Function RTSEMMES(dDataIni, dDataFim, lQuebDif)
	Local aArea      	:= GetArea()
	Local aSemanas    	:= {}
	Local dDataAtu   	:= dDataBase
	Local cDiaQueb    	:= "saturday"
	Default dDataIni    := DaySub(dDataBase, 15)
	Default dDataFim    := DaySum(dDataBase, 15)
	Default lQuebDif    := .F.

	//Definindo o dia de quebra
	If lQuebDif
		cDiaQueb := Alltrim(Lower(cDoW(dDataIni)))
	EndIf

	//Zerando variáveis
	dDataAtu := dDataIni
	aAdd(aSemanas, {dDataAtu, dDataAtu, dToS(dDataAtu)+";"})
	nAtual := 1

	//Enquanto o dia atual for diferente do último dia
	While dDataAtu <= dDataFim
		//Se for sábado, quebra a semana
		If Alltrim( Lower( cDow(dDataAtu) ) ) == cDiaQueb
			aSemanas[nAtual][2] := dDataAtu
			aSemanas[nAtual][3] += dToS(dDataAtu)+";"
			dDataAtu := DaySum(dDataAtu, 1)
			aAdd(aSemanas, {dDataAtu, dDataAtu, ""})
			nAtual++
		EndIf

		aSemanas[nAtual][2] := dDataAtu
		aSemanas[nAtual][3] += dToS(dDataAtu)+";"
		dDataAtu := DaySum(dDataAtu, 1)
	EndDo

	RestArea(aArea)
Return aSemanas




/*/{Protheus.doc} COSPLDIA
	Consulta planejamento diario
	@type  Static Function
	@author ICMAIS
	@since 22/03/2021
	@version 1.0
/*/
Static Function COSPLDIA()
	Local aArea		:= GetArea()
	Local cQuery	:= ""

	cQuery := "SELECT * "
	cQuery += " FROM "+ RetSQLName("SZD")+ " SZD "
	cQuery += " WHERE SZD.ZD_ORDEM = '" + SZC->ZC_ORDEM + "' "
	cQuery += " AND SZD.ZD_SEQ = '"+ SZC->ZC_SEQ +"' "
	cQuery += " AND SZD.ZD_FILIAL = '"+ xFilial("SZD") +"' "
	cQuery += " AND SZD.D_E_L_E_T_ != '*'"
	cQuery += " ORDER BY SZD.ZD_DATA "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSZD",.T.,.T.)

	DbSelectArea("TMPSZD")
	TMPSZD->(DbGoTop())

	While !TMPSZD->(EOF())
		AADD(aColsDia, {TMPSZD->ZD_ORDEM, STOD(TMPSZD->ZD_DATA),TMPSZD->ZD_PLANEJA,SUMPROD(TMPSZD->ZD_DATA,TMPSZD->ZD_DATA),SUMPREV(TMPSZD->ZD_DATA,TMPSZD->ZD_DATA),.F.})
		TMPSZD->(dbSkip())
	EndDo

	TMPSZD->(DbCloseArea())

	RestArea(aArea)

Return




/*/{Protheus.doc} COSPLSEM
	Consulta planejamento semanal
	@type  Static Function
	@author ICMAIS
	@since 22/03/2021
	@version 1.0
/*/
Static Function COSPLSEM()
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cSemana	:= ""

	cQuery := "SELECT * "
	cQuery += " FROM "+ RetSQLName("SZE")+ " SZE "
	cQuery += " WHERE SZE.ZE_ORDEM = '" + SZC->ZC_ORDEM + "' "
	cQuery += " AND SZE.ZE_SEQ = '"+ SZC->ZC_SEQ +"' "
	cQuery += " AND SZE.ZE_FILIAL = '"+ xFilial("SZE") +"' "
	cQuery += " AND SZE.D_E_L_E_T_ != '*'"
	cQuery += " AND SZE.ZE_REVISAO = ( "
	cQuery += "		SELECT MAX(SZEMAX.ZE_REVISAO) "
	cQuery += " 	FROM "+ RetSQLName("SZE")+ " SZEMAX "
	cQuery += " 	WHERE SZEMAX.ZE_ORDEM = '" + SZC->ZC_ORDEM + "' "
	cQuery += " 	AND SZEMAX.ZE_SEQ = '"+ SZC->ZC_SEQ +"' "
	cQuery += " 	AND SZEMAX.ZE_FILIAL = '"+ xFilial("SZE") +"' "
	cQuery += " 	AND SZEMAX.D_E_L_E_T_ != '*' )"
	cQuery += " ORDER BY SZE.ZE_SEMANA "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSZE",.T.,.T.)

	DbSelectArea("TMPSZE")
	TMPSZE->(DbGoTop())

	While !TMPSZE->(EOF())
		cSemana := TMPSZE->ZE_SEMANA + " - " + DTOC(STOD(TMPSZE->ZE_SEMINI)) + " ATE " + DTOC(STOD(TMPSZE->ZE_SEMFIM))
		AADD(aColsSem, {TMPSZE->ZE_ORDEM, cSemana,TMPSZE->ZE_PLANEJA,SUMPROD(TMPSZE->ZE_SEMINI,TMPSZE->ZE_SEMFIM),SUMPREV(TMPSZE->ZE_SEMINI,TMPSZE->ZE_SEMFIM),.F.})
		TMPSZE->(dbSkip())
	EndDo

	TMPSZE->(DbCloseArea())

	RestArea(aArea)

Return




/*/{Protheus.doc} SUMPROD
	Realiza soma das OPs produzidas
	@type  Static Function
	@author ICMAIS
	@since 23/03/2021
	@version 1.0
	@param dDataIni, data, data inicio
	@param dDataFim, data, data final
	@return nSoma, numerico, soma valor produzido
/*/
Static Function SUMPROD(dDataIni,dDataFim)
	Local aArea		:= GetArea()
	Local nSoma		:= 0
	Local cQuery    := ""
	Local hEnter    := CHR( 13 )+CHR( 10 )
	Local cAlSC2    := GetNextAlias( )
	Local lShare    := .T.
	Local lReadOnly := .F.

	cQuery := " SELECT SUM(SC2.C2_QUJE) PRODUZIDO  		       					" + hEnter
	cQuery += "  FROM " + RetSQLName( "SC2" ) + " SC2            				" + hEnter
	cQuery += " WHERE SC2.C2_X_OPPLA =  '"+ SZC->ZC_ORDEM +"' 					" + hEnter
	cQuery += "	 AND SC2.C2_X_SQPLA = '"+ SZC->ZC_SEQ +"'  						" + hEnter
	cQuery += "  AND SC2.C2_DATPRF BETWEEN '"+ dDataIni +"' AND '"+ dDataFim +"'" + hEnter
	cQuery += "	 AND SC2.D_E_L_E_T_ <> '*'                       				" + hEnter

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC2 , lShare, lReadOnly )

	( cAlSC2 )->( dBGoTop()( ) )

	If ( cAlSC2 )->PRODUZIDO > 0
		nSoma := ( cAlSC2 )->PRODUZIDO
	Endif

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	RestArea(aArea)

Return nSoma




/*/{Protheus.doc} SUMPREV
	Realiza soma das OPs previstas
	@type  Static Function
	@author ICMAIS
	@since 23/03/2021
	@version 1.0
	@param dDataIni, data, data inicio
	@param dDataFim, data, data final
	@return nSoma, numerico, soma valor produzido
/*/
Static Function SUMPREV(dDataIni,dDataFim)
	Local aArea		:= GetArea()
	Local nSoma		:= 0
	Local cQuery    := ""
	Local hEnter    := CHR( 13 )+CHR( 10 )
	Local cAlSC2    := GetNextAlias( )
	Local lShare    := .T.
	Local lReadOnly := .F.

	cQuery := " SELECT SUM(SC2.C2_QUANT) PREVISTO  		       					" + hEnter
	cQuery += "  FROM " + RetSQLName( "SC2" ) + " SC2            				" + hEnter
	cQuery += " WHERE SC2.C2_PRODUTO = '"+ SZC->ZC_PRODUTO +"'  				" + hEnter
	cQuery += "  AND SC2.C2_DATPRI BETWEEN '"+ dDataIni +"' AND '"+ dDataFim +"'" + hEnter
	cQuery += "  AND SC2.C2_X_OPPLA = '' 										" + hEnter
	cQuery += "  AND SC2.C2_X_SQPLA = '' 										" + hEnter
	cQuery += "	 AND SC2.D_E_L_E_T_ <> '*'                       				" + hEnter

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	MemoWrite( Procname() + ".SQL", cQuery )

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSC2 , lShare, lReadOnly )

	( cAlSC2 )->( dBGoTop()( ) )

	If ( cAlSC2 )->PREVISTO > 0
		nSoma := ( cAlSC2 )->PREVISTO
	Endif

	If Select( cAlSC2 ) > 0
		( cAlSC2 )->( dBCloseArea( ) )
	EndIf

	RestArea(aArea)

Return nSoma




/*/{Protheus.doc} LASTREV
	Retorna ultima revisao do planejamento
	@type  Static Function
	@author ICMAIS
	@since 24/03/2021
	@version 1.0
	@return cRet, caracter, ultima revisao
/*/
Static Function LASTREV()
	Local aArea		:= GetArea()
	Local cRet		:= "001"
	Local cQuery	:= ""

	cQuery += "	SELECT MAX(SZEMAX.ZE_REVISAO) REVISAO"
	cQuery += " FROM "+ RetSQLName("SZE")+ " SZEMAX "
	cQuery += " WHERE SZEMAX.ZE_ORDEM = '" + SZC->ZC_ORDEM + "' "
	cQuery += " AND SZEMAX.ZE_SEQ = '"+ SZC->ZC_SEQ +"' "
	cQuery += " AND SZEMAX.ZE_FILIAL = '"+ xFilial("SZE") +"' "
	cQuery += " AND SZEMAX.D_E_L_E_T_ != '*' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSZE",.T.,.T.)

	DbSelectArea("TMPSZE")
	TMPSZE->(DbGoTop())

	if !Empty(TMPSZE->REVISAO)
		cRet := TMPSZE->REVISAO
	endif

	TMPSZE->(DbCloseArea())

	RestArea(aArea)

Return cRet




/*/{Protheus.doc} GRVREVIS
	Grava revisao semanal
	@type  Static Function
	@author ICMAIS
	@since 24/03/2021
	@version 1.0
	@param cUltRev, caracter, ultima revisao
/*/
Static Function GRVREVIS(cUltRev)
	Local nX		:= 0
	Local nDias		:= 0
	Local aDiaria	:= {}
	Local cRevis	:= SOMA1(cUltRev)
	Local nPosPla	:= aScan(aHeadSem, {|x| ALLTRIM(x[2]) == "ZE_PLANEJA"})
	Local nPosPro	:= aScan(aHeadSem, {|x| ALLTRIM(x[2]) == "ZE_PRODUZ"})
	Local nPosPre	:= aScan(aHeadSem, {|x| ALLTRIM(x[2]) == "ZE_PREVIST"})

	if ApMsgNoYes("Deseja gravar os ajustes do planejamento semanal ?")
		//Grava revisao
		for nX := 1 to Len(oBroSem:aCols)
			if !Empty(oBroSem:aCols[nX][2])
				RecLock("SZE",.T.)
				SZE->ZE_FILIAL 	:= xFilial("SZE")
				SZE->ZE_ORDEM 	:= SZC->ZC_ORDEM
				SZE->ZE_SEQ		:= SZC->ZC_SEQ
				SZE->ZE_REVISAO	:= cRevis
				SZE->ZE_SEMANA	:= StrZero(nX,2)
				SZE->ZE_SEMINI	:= CTOD(SubStr(oBroSem:aCols[nX][2],6,10))
				SZE->ZE_SEMFIM	:= CTOD(SubStr(oBroSem:aCols[nX][2],21,10))
				SZE->ZE_PLANEJA	:= oBroSem:aCols[nX][nPosPla]
				SZE->ZE_PRODUZ	:= oBroSem:aCols[nX][nPosPro]
				SZE->ZE_PREVIST	:= oBroSem:aCols[nX][nPosPre]
				SZE->ZE_USRLOG	:= cUserName
				SZE->ZE_DATALOG	:= dDataBase
				SZE->(MsUnlock())

				nDias := ( CTOD(SubStr(oBroSem:aCols[nX][2],21,10)) - CTOD(SubStr(oBroSem:aCols[nX][2],6,10)) ) 
				aAdd(aDiaria,{CTOD(SubStr(oBroSem:aCols[nX][2],21,10)), (oBroSem:aCols[nX][nPosPla] / Iif(nDias == 0, 1, nDias + 1))})
			endif
		next
		//Atualiza diaria
		dbSelectArea("SZD")
		SZD->(dbSetOrder(1))
		SZD->(DbGoTop())
		if dbSeek(xFilial("SZD")+SZC->ZC_ORDEM+SZC->ZC_SEQ)
			while SZD->(!Eof()) .And. SZD->ZD_ORDEM == SZC->ZC_ORDEM .And. SZD->ZD_SEQ == SZC->ZC_SEQ
				for nX := 1 to len(aDiaria)
					if SZD->ZD_DATA <= aDiaria[nX][1]
						RecLock("SZD",.F.)
						SZD->ZD_PLANEJA := aDiaria[nX][2]  
						SZD->(MsUnlock())
						Exit
					endif
				next
				SZD->(dbSkip())
			end
		endif
	endif
	
Return




/*/{Protheus.doc} User Function IC3AJSTS
	Ajsuta status do planejamento
	@type  Function
	@author ICMAIS
	@since 01/04/2021
	@version 1.0
/*/
User Function IC3AJSTS()
	Local cMsg	:= ""
	Local cOpc	:= ""

	if SZC->ZC_STATUS == "A"
		cMsg := "Deseja <b>encerrar<b/> este planejamento?"
		cOpc := "E"
	else
		cMsg := "Deseja <b>reabrir<b/> este planejamento?"
		cOpc := "A"
	endif

	if ApMsgNoYes(cMsg,"Confirmação")
		RecLock("SZC", .F.)
		SZC->ZC_STATUS := cOpc
		SZC->(MsUnlock())
	endif
	
Return 
