#Include 'FWMVCDef.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

#DEFINE MAXGETDAD 99999

/*/{Protheus.doc} User Function ICPCP001
    Apontamento de ordens de producao
	@type  Function
	@author ICMAIS
	@since 12/08/2020
	@version 1.0
	@return nil, nil, nil
/*/
User Function ICPCP001()

	Local oBrowse    := Nil

	nCaixas2 := 0;

	Private cGrpSoro	:= AllTrim(GetMv("MV_X_SORO"))
	Private nPesoBal	:= 0
	Private nPesoGrd	:= 0
	Private nTotKG		:= 0
	Private olGetPes
	Private olGetTot
	Private oScrSco
	Private oPanel

	//MsgInfo("Estamos no fonte ICPCP001 !!!!")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria e define objeto FWMBrowse da rotina MVC    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZA")
	oBrowse:SetDescription("Apontamentos Ordem de Produção")
	oBrowse:DisableDetails()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona as opções de legenda do Browse         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBrowse:AddLegend("AllTrim(SZA->ZA_STATUS) == 'A'"	,"BR_VERDE"     ,"Em aberto")
	oBrowse:AddLegend("AllTrim(SZA->ZA_STATUS) == 'P'"	,"BR_AMARELO"  	,"Problema")
	oBrowse:AddLegend("AllTrim(SZA->ZA_STATUS) == 'E'"	,"BR_VERMELHO"  ,"Encerrada")

	oBrowse:Activate()

Return()




/*/{Protheus.doc} Menudef
	Definição do menu da rotina
	@type  Static Function
	@author ICMAIS
	@since 12/08/2020
	@version 1.0
	@return aRotina, vetor, rotinas
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Incluir'  		ACTION 'VIEWDEF.ICPCP001' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'  		ACTION 'U_ICPCP01A' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Finaliza Produção'ACTION 'U_ICPCP01R' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Reimprimir'       ACTION 'U_ICPCP01I' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'  		ACTION 'VIEWDEF.ICPCP001' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'  		ACTION 'VIEWDEF.ICPCP001' OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE 'Ativar impressora'ACTION 'U_ICPCP01P' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Ativar Etq. QRcode'ACTION 'U_ICPCP0QR' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Ativar balança'	ACTION 'U_ICPCP01T' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Etiqueta SORO'	ACTION 'U_ICPCPR02' OPERATION 7 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'    		ACTION 'U_ICPCP01L' OPERATION 5 ACCESS 0
	//ADD OPTION aRotina TITLE 'Ajusta empenho' 	ACTION 'U_ICPCP01E' OPERATION 5 ACCESS 0

Return aRotina




/*/{Protheus.doc} ModelDef
	Definição do modelo de Dados MVC
	@type  Static Function
	@author ICMAIS
	@since 12/08/2020
	@version 1.0
	@return oModel, objeto, modelo MVC
/*/
Static Function ModelDef()

	Local oModel
	Local oStr1 	:= FWFormStruct(1,'SZA')
	Local oStr2 	:= FWFormStruct(1,'SZB')
	Local bLinePre 	:= {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| linePreGrid(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)}

	oModel := MPFormModel():New('mICPCP001')
	oModel := MPFormModel():New('mICPCP001',/*{|oModel| ValidPre(oModel)}*/,/*{|oModel| ValidPos(oModel)}*/,{|oModel| fMdlCommit(oModel)},/*{|| MsgInfo('bCancel'),.F.}*/ )

	oModel:addFields('MASTER',,oStr1)
	oModel:addGrid('ITENS','MASTER',oStr2,bLinePre)

	oModel:SetRelation('ITENS', { { 'ZB_FILIAL','xFilial("SZB")' }, { 'ZB_OP','ZA_OP' } }, SZB->(IndexKey(2)) )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Descriçoes                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oModel:SetDescription('Apontamento Ordem de Produção')
	oModel:getModel('MASTER'):SetDescription('Tabela Cabeçalho')
	oModel:getModel('ITENS'):SetDescription('Tabela Itens')

	// define o numero maximo de linhas, de acordo com a define MAXGETDAD
	oModel:GetModel( 'ITENS' ):SetMaxLine(MAXGETDAD)

Return oModel




/*/{Protheus.doc} ValidPre
	Verifica se pode alterar registro
	@type  Static Function
	@author ICMAIS
	@since 14/08/2020
	@version 1.0
	@param oModel, objeto, modelo de dados
	@return lRet, logico, gravou dados
/*/
Static Function ValidPre(oModel)
	Local lRet	:= .T.
	Local nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_UPDATE
		If AllTrim(oModel:GetValue("MASTER","ZA_STATUS")) == 'A'
			lRet := .T.
		Else
			msginfo('Somente OP em aberto pode ser alterados')
			lRet := .F.
		Endif
	Endif

Return lRet




/*/{Protheus.doc} bLinePre
	Valida exclusão do item
	@type  Static Function
	@author ICMAIS
	@since 14/08/2020
	@version 1.0
	@param oModel, objeto, modelo de dados
	@return lRet, logico, gravou dados
/*/
Static Function linePreGrid(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)
	Local oModel  	:= FWModelActive()
	Local omodelGrd	:= oModel:GetModel('ITENS')
	Local omodelCab	:= oModel:GetModel('MASTER')
	Local lRet		:= .T.
	//Local nPesoTmp	:= omodelGrd:GetValue("ZB_PESOBAL")
	Local nPesoTmp	:= omodelGrd:GetValue("ZB_PESOLIQ")

	Do Case
	Case cAction == "DELETE"
		nTotKG := nTotKG - nPesoTmp
	Case cAction == "UNDELETE"
		nTotKG := nTotKG + nPesoTmp
	EndCase

	omodelCab:SetValue('ZA_QTDPROD', nTotKG)

	//Atualiza campos na tela
	olGetPes:CtrlRefresh()
	olGetTot:CtrlRefresh()
	GETDREFRESH()

Return lRet




/*/{Protheus.doc} ViewDef
	Definição da interface MVC
	@type  Static Function
	@author ICMAIS
	@since 26/06/2020
	@version 1.0
	@return oView, objeto, tela MVC
/*/
Static Function ViewDef()

	Local oView
	// INSTANCIA A VIEW
	Local oModel := ModelDef()

	// INSTANCIA AS SUBVIEWS
	Local oStr1	 := FWFormStruct(2, 'SZA')
	Local oStr2  := FWFormStruct(2, 'SZB')

	oView := FWFormView():New()

	// INDICA O MODELO DA VIEW
	oView:SetModel(oModel)

	// CRIA ESTRUTURA VISUAL DE CAMPOS
	oView:AddField('fMASTER' , oStr1,'MASTER' )
	oView:AddGrid('fITENS' , oStr2,'ITENS')

	// CRIA BOXES HORIZONTAIS
	oView:CreateHorizontalBox( 'CABECALHO', 35)
	oView:CreateHorizontalBox( 'BOXFORM3', 65)

	oView:CreateVerticalBox( 'CABESQ', 85, 'CABECALHO' )
	oView:CreateVerticalBox( 'CABDIR', 15, 'CABECALHO' )

	// RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
	oView:SetOwnerView('fITENS','BOXFORM3')
	oView:SetOwnerView('fMASTER','CABESQ')

	// DEFINE AUTO-INCREMENTO AO CAMPO
	oView:AddIncrementField('fITENS' , 'ZB_ITEM' )

	// Acrescenta um objeto externo ao View do MVC
	oView:AddOtherObject("VIEW_CAB", {|oPanel| CABEXT(oPanel)})

	// Fecha a Tela ao confirmar
	oView:SetCloseOnOk( { || .T. })

	// Associa ao box que ira exibir os outros objetos
	oView:SetOwnerView('VIEW_CAB','CABDIR')

	// DEFINE TITUTLO
	oView:EnableTitleView('fITENS','Pesagen(s)')

Return oView




/*/{Protheus.doc} User Function ICPCP01A
	(long_description)
	@type  Function
	@author ICMAIS
	@since 15/08/2020
	@version 1.0
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function ICPCP01A(cAlias,nReg,nOpc)
	Local lRet			:= .T.
	Local nOperation	:= 4 //Alterar
	Local cModelo		:= "ICPCP001"
	Private cTitulo		:= "Alterar"

	SZA->(dbSetOrder(1))
	SZA->(dbSeek( xFilial("SZA") + SZA->ZA_OP ))

	if SZA->ZA_STATUS <> "E"
		nTotKG := SZA->ZA_QTDPROD 
		oModel := FWLoadModel( cModelo )
		nRet := FWExecView( cTitulo , cModelo, nOperation, /*oDlg*/, {|| .T. } ,/*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/ , /*cOperatId*/, /*cToolBar*/, oModel )
		oModel := nil
		nTotKG := 0
		nPesoBal := 0
		nPesoGrd := 0
	else
		msgAlert("OP indisponível para movimentação","ATENÇÃO")
		lRet := .F.
	endif

Return lRet




/*/{Protheus.doc} CABEXT
	Cria campos e botoes auxiliares na tela
	@type  Static Function
	@author ICMAIS
	@since 14/08/2020
	@version 1.0
	@param oPanel, objeto, tela
/*/
Static Function CABEXT(oPanel)

	Local oView      	:= FWViewActive()
	Local oModel      	:= FWModelActive()
	Local oFont8N     	:= TFONT():New("ARIAL",,-11,,.T.,,,,.T.,.F.)
	Local oFont20N     	:= TFONT():New("ARIAL",,-20,,.T.,,,,.T.,.F.)
	Local nBtnAtv		:= .F.

	if oModel:GetOperation() > 1
		SetKey(VK_F5, {|| ICPCPADD(nPesoGrd)})
		SetKey(VK_F7, {|| RETPESBAL()})
		SetKey(VK_F9, {|| ICPCPREP()})
		nBtnAtv := .T.
	Endif

	SX3->(DbSetOrder(2))

	if Type("oScrSco") == "U"
		oScrSco:= TScrollBox():Create(oPanel,01,01,oPanel:nClientHeight - 40,oPanel:nClientWidth / 2,.F.,.T.,.F.)
		oScrSco:Align := CONTROL_ALIGN_ALLCLIENT
	Endif

	oPanel1 := oPanel
	oView:Refresh()

	oBalcao	 := TSay():New( 007, 007, { ||"Peso balança" } , oScrSco, "@!" , oFont8N,.f.,.f.,.f.,.t.,/*CLR_BLUE*/ )
	olGetPes := TGet():New( 016,007,{|u| if(PCount()>0,nPesoBal:=u,nPesoBal)},oScrSco,80,20,PesqPict("SC2","C2_QUANT"),,8421376,CLR_BLACK,oFont20N,.F.,,.T.,,.F.,,.F.,.F.,{|| ( nPesoGrd := nPesoBal, nPesoBal := 0 ) },.F.,.F.,,"nPesoBal",,,, )

	oBalcao	 := TSay():New( 045, 007, { ||"Total KG" } , oScrSco, "@!" , oFont8N,.f.,.f.,.f.,.t.,/*CLR_BLUE*/ )
	olGetTot := TGet():New( 054,007,{|u| if(PCount()>0,nTotKG:=u,nTotKG)},oScrSco,80,20,PesqPict("SC2","C2_QUANT"),,,,oFont20N,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"nTotKG",,,, )

	oBtnAdd  := TButton():New( 090, 007, "Adicionar peso (F5)",oScrSco,{||ICPCPADD(nPesoGrd)}, 60,20,,,.F.,.T.,.F.,,.F.,{|| nBtnAtv },,.F. )
	oBtnRep	 := TButton():New( 120, 007, "Reimpressão (F9)",oScrSco,{||ICPCPREP()}, 60,20,,,.F.,.T.,.F.,,.F.,{|| nBtnAtv },,.F. )

	/*
    //Cria CSS Defualt para os Botoes
    cCSSBtn1 := " QPushButton {"
    cCSSBtn1 += " background-color: rgb(0, 255, 0);"
    cCSSBtn1 += " border-style: outset; "
    cCSSBtn1 += " border-width: 1px;"
    cCSSBtn1 += " border-color: black;"
    cCSSBtn1 += " border-radius: 10px;"
    cCSSBtn1 += " font-weight: bold;"
    cCSSBtn1 += " }"

    oBtnAdd:setCSS(cCSSBtn1)
	oBtnAdd:Refresh()
	*/
	//olGetPes:setCSS(cCSSBtn1)
	//olGetPes:Refresh()


Return




/*/{Protheus.doc} ICPCPADD
	Inclui as pesagens no grid
	@type  Static Function
	@author ICMAIS
	@since 14/08/2020
	@version 1.0
	@param nPesoBal, numerico, peso balanca
/*/
Static Function ICPCPADD(nPesoBal)
	Local aArea		:= GetArea()
	Local oView    	:= FWViewActive()
	Local oModel  	:= FWModelActive()
	Local omodelGrd	:= oModel:GetModel('ITENS')
	Local omodelCab	:= oModel:GetModel('MASTER')
	Local cProduto	:= omodelCab:GetValue("ZA_PRODUTO")
	Local cPalete	:= omodelCab:GetValue("ZA_PALETE")
	Local oGrid    	:= oModel:GetModel('ITENS')
	Local cMvRGPRO	:= AllTrim(GetMv("MV_X_RGPRO"))
	Local cMvULOGI	:= AllTrim(STR(GetMv("MV_X_ULOGI")))
	Local cSerGtin	:= AllTrim(GetMv("MV_X_SRGS1"))
	Local cMvCODGT	:= GetMv("MV_X_CODGT")
	Local nTaraTot	:= omodelCab:GetValue("ZA_TARATOT")
	Local cCodGTIN	:= ""
	Local cGS1   	:= ""
	Local lImpEtiq	:= GetMv("MV_X_IMPET")
	Local lSoro		:= .F.
	Local nLinhas	:= omodelGrd:Length()
	Local nX		:= 0
	Local nMCxPlt	:= 0
	Local nCxPalet	:= 0

	If nPesoBal > 0 .OR. POSICIONE("SB1", 1, xFilial("SB1") + cProduto, "B1_UM") = 'UN'
		dbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(dbGoTop())
		if dbSeek(xFilial("SB1") + cProduto)
			if cMvCODGT
				cCodGTIN := SB1->B1_CODGTIN
			else
				cCodGTIN := SB1->B1_CODBAR
			endif

			//Verifica se produto e SORO
			if AllTrim(SB1->B1_GRUPO) $ cGrpSoro
				lSoro := .T.
			endif

			nMCxPlt := SB1->B1_X_MCXPL
		endif

		if !lSoro
			if nLinhas == 1
				cGS1 := GS1_17(cMvULOGI + cSerGtin)
			else
				omodelGrd:GoLine(nLinhas)
				if AllTrim(omodelGrd:GetValue("ZB_PALETE")) <> AllTrim(cPalete)
					cGS1 := GS1_17(cMvULOGI + cSerGtin)
				else
					cGS1 := omodelGrd:GetValue("ZB_ULOGI")	
				endif
			endif 
		endif

		IF SB1->B1_UM == 'UN'
			nPesoBal := SB1->B1_PESBRU * SB1->B1_QE
		ENDIF

		//Adiciona linha
		omodelGrd:AddLine()
		omodelGrd:SetValue("ZB_OP", omodelCab:GetValue("ZA_OP"))
		omodelGrd:SetValue("ZB_PRODUTO", cProduto)
		omodelGrd:SetValue("ZB_RGPRO", cMvRGPRO)
		omodelGrd:SetValue("ZB_ULOGI", cGS1)
		omodelGrd:SetValue("ZB_PALETE", cPalete)
		omodelGrd:SetValue("ZB_CODGTIN", cCodGTIN)
		omodelGrd:SetValue("ZB_LOTECTL", omodelCab:GetValue("ZA_LOTECTL"))
		omodelGrd:SetValue("ZB_DATAVLD", omodelCab:GetValue("ZA_DATVLD"))
		omodelGrd:SetValue("ZB_QTD", omodelCab:GetValue("ZA_QTD"))
		omodelGrd:SetValue("ZB_DATAFAB", omodelCab:GetValue("ZA_DATFAB"))
		omodelGrd:SetValue("ZB_TARAEMB", omodelCab:GetValue("ZA_TARAEMB"))
		omodelGrd:SetValue("ZB_TARACX", omodelCab:GetValue("ZA_TARACX"))
		omodelGrd:SetValue("ZB_TARATOT", nTaraTot)
		omodelGrd:SetValue("ZB_PESOLIQ", nPesoBal-nTaraTot )
		omodelGrd:SetValue("ZB_PESOBAL", nPesoBal)
		omodelGrd:SetValue("ZB_ITF14", U_ITF14(cProduto))

		 nTotKG += nPesoBal - nTaraTot //nPesoBal
		omodelCab:SetValue('ZA_QTDPROD', nTotKG)

		// Força o posicionamento na primeira linha do grid
		//omodelGrd:SetLine( 1 )
		omodelGrd:SetLine( omodelGrd:Length() )

		//Atualiza campos na tela
		olGetPes:CtrlRefresh()
		olGetTot:CtrlRefresh()
		GETDREFRESH()

		// Atualiza toda a tela
		oView:Refresh()
		SysRefresh()

		olGetPes:SetFocus()

		if !lSoro
			//Atualiza parametro
			PutMV("MV_X_SRGS1",Soma1(cSerGtin))

			//Imprime etiqueta
			If lImpEtiq
				ICPCPIMP()
			Endif
		endif


		For nX := 1 To oGrid:GetQtdLine()
			oGrid:GoLine(nX)
			If!oGrid:IsDeleted()
				If AllTrim( oGrid:GetValue("ZB_PALETE") ) == AllTrim( cPalete ) 
					nCxPalet++
				Endif
			Endif
		Next nX
		if nMCxPlt > 0
			if nCxPalet >= nMCxPlt
				if MsgYesNo("Número máximo de caixa do palete para este produto foi atingido. Deseja imprimir etiqueta?", "ATENÇÃO")
					U_PRINTETQ(cPalete)
					//MsgInfo("IMPRIMIU ETIQUETA PALETE", "ATENÇÃO")
				endif
			endif
		endif
	Endif

	RestArea(aArea)
Return




/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 14/08/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function ICPCPREP()
	Local lImpEtiq	:= GetMv("MV_X_IMPET")
	Local oModel  	:= FWModelActive()
	Local omodelCab	:= oModel:GetModel('MASTER')
	Local cProduto	:= omodelCab:GetValue("ZA_PRODUTO")
	Local lSoro		:= .F.

   
	//Verifica se produto e SORO
	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(dbGoTop())
	if dbSeek(xFilial("SB1") + cProduto)
		if AllTrim(SB1->B1_GRUPO) $ cGrpSoro
			lSoro := .T.
		endif
	endif

	//Imprime etiqueta
	if !lSoro
		if lImpEtiq
			ICPCPIMP()
		endif
	endif

Return




/*/{Protheus.doc} fMdlCommit
	Função para gravação dos dados do modelo MVC
	@type  Static Function
	@author ICMAIS
	@since 14/08/2020
	@version 1.0
	@param oModel, objeto, modelo de dados
	@return lRet, logico, gravou dados
/*/
Static Function fMdlCommit(oModel)

	Local lRet	:= .T.
	Local nOperation := oModel:GetOperation()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dispara a gravação padrão do Modelo de Dados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := fwFormCommit(oModel)
	nTotKG := 0
	If lRet
		if nOperation == MODEL_OPERATION_DELETE
			if AllTrim(oModel:GetValue("MASTER","ZA_STATUS")) == 'E'
				msgAlert("Está ordem produção não pode ser excluída","ATENÇÃO")
				lRet := .F.
			endif
		endif
	Endif

Return( lRet )




/*/{Protheus.doc} ICPCP01L
	Função para mostrar tela de Legenda da rotina 
	@type  Static Function
	@author ICMAIS
	@since 12/08/2020
	@version 1.0 
	@return lRet, logico, logico
/*/
User Function ICPCP01L()

	Local aCores := {}

	aAdd( aCores, {"BR_VERDE"  	    ,"Em aberto"  })
	aAdd( aCores, {"BR_AMARELO" 	,"Problema"  })
	aAdd( aCores, {"BR_VERMELHO"    ,"Encerrada" })

	BrwLegenda("Apontamento Ordem de Produção","Legenda",aCores)

Return(.T.)



/*/{Protheus.doc} User Function ICPCP01I
    Reimpressao
    @type  Function
    @author ICMAIS
    @since 12/08/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function ICPCP01I()
	Local aArea		:= GetArea()
	Local cAliasTMP	:= GetNextAlias()
	Local aPergs   	:= {}
	Local aParam	:= {}
	Local cArquivo 	:= Space(18)
	Local lImpEtiq	:= GetMv("MV_X_IMPET")
	
	aAdd(aPergs, {1, "Codigo Etiqueta", cArquivo, "", ".T.", "",    ".T.", 100, .T.})
	
	If ParamBox(aPergs, "Informe os parâmetros")

		cQuery := "SELECT *												"
		cQuery += "FROM " + RetSQLName("SZB") + " SZB					"
		cQuery += "WHERE SZB.ZB_FILIAL   = '" + xFilial("SZB") + "'		"
		cQuery += "  AND SZB.ZB_ULOGI    = '" + MV_PAR01    + "'		"
		cQuery += "  AND SZB.D_E_L_E_T_ <> '*'							"
			
		TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)
			
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		If (cAliasTMP)->(!EOF()) .AND. !EMPTY((cAliasTMP)->ZB_OP)
			dbSelectArea("SZA")
			If dbSeek(xFilial("SZA")+(cAliasTMP)->ZB_OP)
				aAdd(aParam,SZA->ZA_PRODUTO)        //1
				aAdd(aParam,SZA->ZA_DESC)           //2
				aAdd(aParam,(cAliasTMP)->ZB_CODGTIN)//3
				aAdd(aParam,(cAliasTMP)->ZB_QTD)    //4
				aAdd(aParam,(cAliasTMP)->ZB_LOTECTL)//5
				aAdd(aParam,(cAliasTMP)->ZB_PESOLIQ)//6
				aAdd(aParam,STOD((cAliasTMP)->ZB_DATAFAB))//7 STOD(
				aAdd(aParam,STOD((cAliasTMP)->ZB_DATAVLD))//8
				aAdd(aParam,(cAliasTMP)->ZB_PESOBAL)//9
				aAdd(aParam,(cAliasTMP)->ZB_TARAEMB)//10
				aAdd(aParam,(cAliasTMP)->ZB_TARACX) //11
				aAdd(aParam,(cAliasTMP)->ZB_TARATOT)//12
				aAdd(aParam,(cAliasTMP)->ZB_ULOGI)  //13

				//Imprime etiqueta
				If lImpEtiq
				    //LAOYOUT ARGOX
					//U_ICPCPR01(aParam)
					//LAYOUT ZEBRA 
					U_ICPCPR03(aParam)
				Endif
			Endif
		Else
			Alert("Codigo etiqueta não encotrado!")
		EndIf
			
		(cAliasTMP)->(dbCloseArea())

	EndIf

	RestArea(aArea)

Return





/*/{Protheus.doc} User Function ICPCP01R
    Reprocessa execauto apontamento
    @type  Function
    @author ICMAIS
    @since 12/08/2020
    @version 1.0
/*/
User Function ICPCP01R()

	Local aArea := GetArea()

	if SZA->ZA_STATUS <> "E"
		if ApMsgNoYes("Deseja realizar apontamento da ordem de produção "+ AllTrim( SZA->ZA_OP ) +"?")
			//Ajusta empenhos
			If U_ICPCP01E()
				FWMsgRun(, {|oSay| ICPCPAPO(oSay)}, "Processando", "Apontando ordem de produção...")
			Endif
		endif
	else
		msgAlert("Está ordem produção já foi encerrada","ATENÇÃO")
	endif

	RestArea(aArea)

Return





/*/{Protheus.doc} ICPCPATU
	Atualiza campos da tela
	@type  Static Function
	@author ICMAIS
	@since 14/08/2020
	@version 1.0
	@return cRet, caracter, retorno
/*/
User Function ICPCPATU()
	Local aArea		:= GetArea()
	Local cRet 		:= M->ZA_OP
	Local oModel  	:= FWModelActive()
	Local omodelCab	:= oModel:GetModel('MASTER')

	dbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	SC2->(dbGoTop())
	If dbSeek(xFilial("SC2") + M->ZA_OP )
		omodelCab:SetValue("ZA_PRODUTO",SC2->C2_PRODUTO)

		dbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(dbGoTop())
		If dbSeek(xFilial("SB1") + SC2->C2_PRODUTO)
			omodelCab:SetValue("ZA_DESC",SB1->B1_DESC)
			omodelCab:SetValue("ZA_QTD",SB1->B1_QE)
			omodelCab:SetValue("ZA_TARACX",SB1->B1_X_TRCX)
			omodelCab:SetValue("ZA_TARAEMB",SB1->B1_X_TREMB)
			omodelCab:SetValue("ZA_TARATOT",SB1->B1_X_TREMB + SB1->B1_X_TRCX)
		Endif
	Endif

	RestArea(aArea)

Return cRet




/*/{Protheus.doc} ICPCPAPO
	(long_description)
	@type  Static Function
	@author ICMAIS
	@since 16/08/2020
	@version 1.0
	@param oSay, objeto, tela de processamento
/*/
Static Function ICPCPAPO(param_name)

	Local aArea			:= GetArea()
	Local aApontProd	:= {}
	Local cRecurso		:= ""
	Local cLocal		:= ""
	Local lRastroPrd	:= .F.
	Local nQtdProd

	Private lMsErroAuto	:= .F.

	dbSelectArea( "SG2" )
	SG2->( dbSetOrder( 3 ) )
	SG2->( dbGoTop( ) )
	If dbSeek( xFilial( "SG2" ) + SZA->ZA_PRODUTO + SZA->ZA_OPERAC )
		cRecurso := SG2->G2_RECURSO
	Endif

	dbSelectArea("SB1")
	SB1->( dbSetOrder( 1 ) )
	SB1->( dbGoTop( ) )
	if dbSeek( xFilial("SB1") + SZA->ZA_PRODUTO )
		cLocal := SB1->B1_LOCPAD
		lRastroPrd := IIF( SB1->B1_RASTRO == "L",.T.,.F.)
	endif

	IF SB1->B1_UM == 'KG'
		nQtdProd := SZA->ZA_QTDPROD
	else
	    // Alert( "caixas=" + alltrim(str(nCaixas2)) )
        //Alert( ConvUM(SZA->ZA_PRODUTO, 0, nCaixas2,   1) )
		nQtdProd := ConvUM(SZA->ZA_PRODUTO, 0, nCaixas2,   1) //  ROUND(SZA->ZA_QTDPROD / SB1->B1_PESO,0)	

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras referentes ao Apontamento Produção Modelo II³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aApontProd := {}
	AADD(aApontProd, {"H6_FILIAL"  , xFilial("SH6")			, NIL})
	AADD(aApontProd, {"H6_OP"      , SZA->ZA_OP				, NIL})
	AADD(aApontProd, {"H6_PRODUTO" , SZA->ZA_PRODUTO		, NIL})
	AADD(aApontProd, {"H6_OPERAC"  , SZA->ZA_OPERAC			, NIL})
	AADD(aApontProd, {"H6_RECURSO" , cRecurso				, NIL})
	AADD(aApontProd, {"H6_DATAINI" , SZA->ZA_DATAINI		, NIL})
	AADD(aApontProd, {"H6_HORAINI" , SZA->ZA_HORAINI		, NIL})
	AADD(aApontProd, {"H6_DATAFIN" , SZA->ZA_DATAFIN		, NIL})
	AADD(aApontProd, {"H6_HORAFIN" , SZA->ZA_HORAFIN		, NIL})
	AADD(aApontProd, {"H6_X_DTFAB" , SZA->ZA_DATFAB			, NIL})
	If lRastroPrd
		AADD(aApontProd, {"H6_LOTECTL" , SZA->ZA_LOTECTL	, NIL})
		AADD(aApontProd, {"H6_DTVALID" , SZA->ZA_DATVLD		, NIL})
	Endif
	AADD(aApontProd, {"H6_X_OPERA" , SZA->ZA_OPERADO		, NIL})
	AADD(aApontProd, {"H6_LOCAL"   , cLocal					, NIL})
	AADD(aApontProd, {"H6_QTDPROD" , nQtdProd				, NIL})

	FWVetByDic(aApontProd, "SH6")

	MSExecAuto({|x,y| MATA681(x,y)}, aApontProd, 3)

	If lMsErroAuto
		ShowHelpDlg("Atenção", {"Ocorreram erros ao processar o apontamento de produção referente à OP " + SZA->ZA_OP + "."}, 5, {"Favor verificar log gravado no apontamento."}, 5)
		cErro := MOSTRAERRO()
		RecLock("SZA",.F.)
		SZA->ZA_LOG := cErro
		SZA->ZA_STATUS := "P"
		SZA->(MsUnlock())
	Else
		RecLock("SZA",.F.)
		SZA->ZA_LOG := "OP apontado com sucesso"
		SZA->ZA_STATUS := "E"
		SZA->(MsUnlock())
	Endif

	RestArea(aArea)

Return




/*
Função		GS1_17()
Autor		IGOR CHEMIN
Descrição	Calcula Digito verificador para SSCC 
Parâmetro	String com 17 digitos 
Retorno		String contendo dígito verificador
LINK:       https://www.gs1.org/services/how-calculate-check-digit-manually
*/

Static function GS1_17(cCodGTIN)

	Local nI
	Local nDig     := 0
	Local cMult    := "31313131313131313" // BASE PARA MULTIPLICACAO
	Local nResult  := 0
	Local multiplo := 0

	For nI := 1 to 17
		nResult +=  val(substr(cMult,nI,1)) * val(substr(cCodGTIN,nI,1))
	Next
	//MSGALERT( STR(nResult), "SOMA" )
	if (nResult % 10 == 0)
		multiplo = nResult
	else
		multiplo = (nResult - ( nResult % 10 )) + 10
	endif
	//MSGALERT( STR(multiplo), "MULTIPLO" )
	nDig := multiplo - nResult
	//MSGALERT( STR(nDig), "DIGITO" )

Return ALLTRIM(cCodGTIN + ALLTRIM(str(nDig)))




/*/{Protheus.doc} ICPCPATU
	Ajusta empenho
	@type  Static Function
	@author ICMAIS
	@since 23/08/2020
	@version 1.0
/*/
User Function ICPCP01E()
	Local aArea			:= GetArea()
	Local lRet			:= .F.
	Local aButtons		:= {}
	Local aAltEmp		:= {"PRODUTO","LOCAL","QTDEOP"}
	Local nCaixas		:= 0
	nCaixas2            := 0
	Local nTKGLiq		:= 0
	Local nOpcao		:= 0
	Local oFont14N     	:= TFONT():New("ARIAL",,-14,,.T.,,,,.T.,.F.)
	//Local oFont20N     	:= TFONT():New("ARIAL",,-20,,.T.,,,,.T.,.F.)
	Private aHderEmp 	:= {}
	Private aClsEmp  	:= {}
	Private oBrowEmp

	//Conta a quantidade de caixas
	dbSelectArea("SZB")
	SZB->(dbSetOrder(2))
	SZB->(dbGoTop())
	If dbSeek(xFilial("SZB")+SZA->ZA_OP)
		While SZB->(!Eof()) .And. SZB->ZB_OP == SZA->ZA_OP
			nCaixas++
			nCaixas2++
			nTKGLiq += SZB->ZB_PESOLIQ
			SZB->(dbSkip())
		Enddo
	Endif

	//              "cTitulo"     			, "Campo Ref"	,"cPicture"            		,"nTamanho"              	,"nDecimais"             	,"cValidação"   ,"cUsado","cTipo","cF3" 	,"Contexto"	,"cCBOX"	,"cRelacao" 	,"cVisual","Campo Ref."
	aAdd( aHderEmp, { "Produto" 			, "PRODUTO"		,X3Picture("D4_COD")		, TamSX3("D4_COD")[1]-10	, TamSX3("D4_COD" )[2]		, ""  			, "û"    , 'C'   , 'SB1EMP'	,			, ''   		,'' 	,".T." })
	aAdd( aHderEmp, { "Descrição" 			, "DESC"		,X3Picture("B1_DESC")		, TamSX3("B1_DESC")[1]		, TamSX3("B1_DESC" )[2]		, ""  			, "û"    , 'C'   , ''   	, 			, ''   		,''  	,".T." })
	aAdd( aHderEmp, { "Armazem" 			, "LOCAL"		,X3Picture("D4_LOCAL")		, TamSX3("D4_LOCAL")[1]		, TamSX3("D4_LOCAL" )[2]	, ""  			, "û"    , 'C'   , 'NNR'	, 			, ''		,''  	,".T." })
	aAdd( aHderEmp, { "Quantidade" 			, "QTDEOP"		,X3Picture("D4_QTDEORI")	, TamSX3("D4_QTDEORI")[1]	, TamSX3("D4_QTDEORI" )[2]	, "Positivo()"  , "û"    , 'N'   , ''   	, 			, ''		,'0'  	,".T." })

	//Busca empenhos
	RETEMPOP()

	DEFINE MSDIALOG oDlg TITLE "Ajuste empenhos" From 0,0 to 500,700 of oMainWnd PIXEL
	oSayOP	:= TSay():New( 035, 010, { ||"Ordem Produção - "+ AllTrim( SZA->ZA_OP )+" - "+AllTrim( SZA->ZA_PRODUTO )+" - "+AllTrim( SZA->ZA_DESC ) } , oDlg, "" , oFont14N,.f.,.f.,.f.,.t.,/*CLR_BLUE*/ )
	oSayCX	:= TSay():New( 050, 010, { ||"Número Caixa: " + AllTrim(Transform(nCaixas,PesqPict("SZB","ZB_QTD")))  } , oDlg, "" , oFont14N,.f.,.f.,.f.,.t.,/*CLR_BLUE*/ )
	oSayEB	:= TSay():New( 050, 100, { ||"Número Embalagens: " + AllTrim(Transform(nCaixas * SZA->ZA_QTD,PesqPict("SZB","ZB_QTD"))) } , oDlg, "" , oFont14N,.f.,.f.,.f.,.t.,/*CLR_BLUE*/ )
	oSayKG	:= TSay():New( 050, 200, { ||"Total KG: " + AllTrim(Transform(nTKGLiq,PesqPict("SZB","ZB_PESOLIQ"))) } , oDlg, "" , oFont14N,.f.,.f.,.f.,.t.,/*CLR_BLUE*/ )

	oBrowEmp := MsNewGetDados():New(065, 010, 245 , 345, GD_INSERT+GD_UPDATE+GD_DELETE,'AllwaysTrue()','AllwaysTrue()','',aAltEmp,0,999,'AllwaysTrue()','','AllwaysTrue()',oDlg,aHderEmp,aClsEmp  )

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||( oDlg:End(), nOpcao := 3)},{||oDlg:End()},,aButtons) CENTERED

	//Confimou rotina
	If nOpcao == 3
		FWMsgRun(, {|oSay| ICPCPEMP(oSay)}, "Processando", "Ajustando Empenhos...")
		lRet := .T.
	Endif

	RestArea(aArea)

Return lRet




/*/{Protheus.doc} RETEMPOP
	Retorna empenhos da ordem de produção
	@type  Static Function
	@author ICMAIS
	@since 25/08/2020
	@version 1.0
/*/
Static Function RETEMPOP()
	Local aArea := GetArea()

	dbSelectArea("SD4")
	SD4->(dbSetOrder(2))
	SD4->(dbGoTop())
	if dbSeek(xFilial("SD4")+SZA->ZA_OP)
		while SD4->(!Eof()) .And. AllTrim(SD4->D4_OP) == AllTrim(SZA->ZA_OP)
			aAdd( aClsEmp, Array( Len( aHderEmp ) + 1 ) )
			aClsEmp[Len( aClsEmp )][ 01 ] := SD4->D4_COD //Produto
			aClsEmp[Len( aClsEmp )][ 02 ] := Posicione( "SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC" )//Descricao
			aClsEmp[Len( aClsEmp )][ 03 ] := SD4->D4_LOCAL //Armazem
			aClsEmp[Len( aClsEmp )][ 04 ] := SD4->D4_QTDEORI //Quantidade

			aClsEmp[Len( aClsEmp )][Len( aHderEmp ) + 1] := .F.

			SD4->(dbSkip())
		end
	endif

	RestArea(aArea)

Return




/*/{Protheus.doc} ICPCPEMP
	(long_description)
	@type  Static Function
	@author ICMAIS
	@since 25/08/2020
	@version 1.0
/*/
Static Function ICPCPEMP(oSay)
	Local aArea 	:= GetArea()
	Local nY		:= 0
	Local aEmpenho	:= {}
	Local cQuery	:= ""
	Local hEnter	:= CHR( 13 )+CHR( 10 )
	Local cAlSD4    := GetNextAlias( )
	Local lShare   	:= .T.
	Local lReadOnly	:= .F.
	Private lMsErroAuto := .F.

	//Exclui os empenhos
	cQuery := "SELECT SD4.*											" 	+ hEnter
	cQuery += " FROM "+RetSqlName( "SD4" )+" SD4 					"	+ hEnter
	//cQuery += "  WHERE SD4.D4_QUANT <> SD4.D4_QTDEORI				" 	+ hEnter
	//cQuery += "   AND SD4.D4_QUANT > 0							"	+ hEnter
	cQuery += "   WHERE SD4.D4_OP = '"+ SZA->ZA_OP +"'				" 	+ hEnter
	cQuery += "   AND SD4.D4_FILIAL = '"+ xFilial( "SD4" ) +"'		"	+ hEnter
	cQuery += "   AND SD4.D_E_L_E_T_ = '' 							"	+ hEnter

	If Select( cAlSD4 ) > 0
		( cAlSD4 )->( dBCloseArea( ) )
	EndIf

	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlSD4 , lShare, lReadOnly )

	( cAlSD4 )->( dBGoTop()( ) )

	While ( cAlSD4 )->( !Eof()( ) )
		aEmpenho := {}
		AADD(aEmpenho, {"D4_COD" 	, ( cAlSD4 )->D4_COD	, Nil})
		AADD(aEmpenho, {"D4_LOCAL" 	, ( cAlSD4 )->D4_LOCAL	, Nil})
		AADD(aEmpenho, {"D4_TRT" 	, ( cAlSD4 )->D4_TRT	, Nil})
		AADD(aEmpenho, {"D4_OP" 	, ( cAlSD4 )->D4_OP		, Nil})
		AADD(aEmpenho, {"D4_DATA" 	, dDataBase				, Nil})
		AADD(aEmpenho, {"D4_QTDEORI", ( cAlSD4 )->D4_QTDEORI, Nil})
		AADD(aEmpenho, {"D4_QUANT" 	, ( cAlSD4 )->D4_QUANT	, Nil})

		lMsErroAuto := .F.
		MSExecAuto({|x,y| MATA380(x,y)}, aEmpenho, 5)

		If lMsErroAuto
			Mostraerro( )
			DisarmTransaction( )
		Else
			Conout( "[INFO] executou com sucesso o execauto MATA380 ajuste empenhos" )
		EndIf

		( cAlSD4 )->( dBSkip()( ) )
	Enddo

	If Select( cAlSD4 ) > 0
		( cAlSD4 )->( dBCloseArea( ) )
	EndIf


	//Inclui empenhos
	For nY := 1 To Len( oBrowEmp:aCols )

		if !oBrowEmp:aCols[nY][Len( aHderEmp ) + 1]
			aEmpenho := {}
			AADD(aEmpenho, {"D4_COD" 	, oBrowEmp:aCols[nY][01]	, Nil})
			AADD(aEmpenho, {"D4_LOCAL" 	, oBrowEmp:aCols[nY][03]	, Nil})
			AADD(aEmpenho, {"D4_OP" 	, SZA->ZA_OP				, Nil})
			AADD(aEmpenho, {"D4_DATA" 	, DDATABASE					, Nil})
			AADD(aEmpenho, {"D4_QTDEORI", oBrowEmp:aCols[nY][04]	, Nil})
			AADD(aEmpenho, {"D4_QUANT" 	, oBrowEmp:aCols[nY][04]	, Nil})

			lMsErroAuto := .F.
			MSExecAuto({|x,y| MATA380(x,y)}, aEmpenho, 3)

			If lMsErroAuto
				Mostraerro( )
				DisarmTransaction( )
			Else
				Conout( "[INFO] executou com sucesso o execauto MATA380 ajuste empenhos" )
			EndIf
		Endif

	Next nY

	RestArea(aArea)

Return





/*/{Protheus.doc} User Function ICPALETE
	Atualiza campos virtuais na tela
	@type  Function
	@author ICMAIS
	@since 01/09/2020
	@version 1.0
	@return cRet, caracter, retorna palete
/*/
User Function ICPALETE()
	Local aArea 	:= GetArea()
	Local nX		:= 0
	Local nTotCx	:= 0
	Local nTotLiq	:= 0
	Local nTotBru	:= 0
	Local oModel  	:= FWModelActive()
	Local cPalete 	:= oModel:GetValue("MASTER","ZA_PALETE")
	Local omodelCab	:= oModel:GetModel('MASTER')
	Local oGrid    	:= oModel:GetModel('ITENS')


	For nX := 1 To oGrid:GetQtdLine()
		oGrid:GoLine(nX)
		If!oGrid:IsDeleted()
			If AllTrim( oGrid:GetValue("ZB_PALETE") ) == AllTrim( cPalete ) 
				nTotCx++
				nTotLiq += oGrid:GetValue("ZB_PESOLIQ")
				nTotBru += oGrid:GetValue("ZB_PESOBAL")
			Endif
		Endif
	Next nX

	omodelCab:SetValue('ZA_TOTCX', nTotCx)
	omodelCab:SetValue('ZA_PESOLIQ', nTotLiq)
	omodelCab:SetValue('ZA_PESOBRU', nTotBru)

	RestArea(aArea)

Return cPalete






/*/{Protheus.doc} ICPCPIMP
	Imprime etiqueta
	@type  Static Function
	@author ICMAIS
	@since 17/09/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function ICPCPIMP()
	Local aArea		:= GetArea()
	Local oModel  	:= FWModelActive()
	Local omodelGrd	:= oModel:GetModel('ITENS')
	Local omodelCab	:= oModel:GetModel('MASTER')
	Local cProduto	:= omodelCab:GetValue("ZA_PRODUTO")
	Local cDesc		:= omodelCab:GetValue("ZA_DESC")
	Local cTpImp	:= omodelCab:GetValue("ZA_TPIMP")
	Local aParam	:= {}
	Local lEtiqueta := GetMv("MV_X_ETQRC")
    
	

 	nLinhas := omodelGrd:Length() 

	omodelGrd:GoLine(nLinhas)

	aAdd(aParam,cProduto)
	aAdd(aParam,cDesc)
	aAdd(aParam,omodelGrd:GetValue("ZB_CODGTIN"))
	aAdd(aParam,omodelGrd:GetValue("ZB_QTD"))
	aAdd(aParam,omodelGrd:GetValue("ZB_LOTECTL"))
	aAdd(aParam,omodelGrd:GetValue("ZB_PESOLIQ"))
	aAdd(aParam,omodelGrd:GetValue("ZB_DATAFAB"))
	aAdd(aParam,omodelGrd:GetValue("ZB_DATAVLD"))
	aAdd(aParam,omodelGrd:GetValue("ZB_PESOBAL"))
	aAdd(aParam,omodelGrd:GetValue("ZB_TARAEMB"))
	aAdd(aParam,omodelGrd:GetValue("ZB_TARACX"))

	aAdd(aParam,omodelGrd:GetValue("ZB_TARATOT"))
	aAdd(aParam,omodelGrd:GetValue("ZB_ULOGI"))
	aAdd(aParam,omodelGrd:GetValue("ZB_ITF14"))

	IF lEtiqueta
		cTemperatura :=  POSICIONE("SB1",1,XFILIAL("SB1")+cProduto,"SB1->B1_X_TEMPE")   
		cUND         := POSICIONE("SB1",1,XFILIAL("SB1")+cProduto,"SB1->B1_UM") 
		cRegistro    := GetMv("MV_X_RGPRO")
        cSIF         :=   AllTrim(GetMv("MV_X_SIF"))
		cDataF  := DTOC(aParam[7])
		// 27/08/2022
		cDataFAB := SUBSTRING(cDataF, 1, 2)+ SUBSTRING(cDataF, 4, 2) +SUBSTRING(cDataF, 7, 4)
		
		cQRCODE      := ALLTRIM(cProduto) +";"+ ALLTRIM(cDataFAB) +";"+ ALLTRIM( aParam[5] )+ ";"+ aParam[14]
       
        aAdd(aParam,ALLTRIM(cTemperatura))
		aAdd(aParam,ALLTRIM(cUND))
		aAdd(aParam,ALLTRIM(cRegistro))
		aAdd(aParam,ALLTRIM(cSIF))
		aAdd(aParam,ALLTRIM(cQRCODE))

	EndIF
	
	
	Do Case
	Case cTpImp == "1" //CHAMADA PARA ARGOX
		U_ICPCPR01(aParam)
	Case cTpImp == "2" //CHAMADA PARA ZEBRA
	 //MUDA LAYOUT ETIQUETA CONFORME SOLICITADO
	    IF lEtiqueta
           U_ICPCPQR1(aParam)
		else
           U_ICPCPR03(aParam)
		EndIF
			
	    	
	EndCase

	RestArea(aArea)
	
Return 




/*/{Protheus.doc} ICPCP01P
	Ativa impressora
	@type  Static Function
	@author ICMAIS
	@since 06/10/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function ICPCP01P()
	Local aArea		:= GetArea()
	Local aPergs   	:= {}
	Local lAtiva	:= .T.
	Local lCanSave 	:= .T.
 	Local lUserSave := .F.

	aAdd(aPergs, {2, "Ativa impressora", , {"1=Sim","2=Não"},50, ".T.", .T.,,,,lCanSave,lUserSave})
	
	If ParamBox(aPergs, "Informe os parâmetros")
		If MV_PAR01 == "2"
			lAtiva := .F.	
		Endif

		//Atualiza parametro
		PutMV("MV_X_IMPET",lAtiva)
	EndIf

	RestArea(aArea)
	
Return 


/*/{Protheus.doc} ICPCP01P
	Ativa impressora MODELO ETIQUETA QRCODE
	@type  Static Function
	@author ICMAIS
	@since 06/10/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function ICPCP0QR()
	Local aArea		:= GetArea()
	Local aPergs   	:= {}
	Local lAtiva	:= .T.
	Local lCanSave 	:= .T.
 	Local lUserSave := .F.

	aAdd(aPergs, {2, "Ativa Etiqueta QRCODE", , {"1=Sim","2=Não"},50, ".T.", .T.,,,,lCanSave,lUserSave})
	
	If ParamBox(aPergs, "Informe os parâmetros")
		If MV_PAR01 == "2"
			lAtiva := .F.	
		Endif

		//Atualiza parametro
		PutMV("MV_X_ETQRC",lAtiva)
	EndIf

	RestArea(aArea)
	
Return 




/*/{Protheus.doc} ICPCP01T
	Ativa captura peso balança
	@type  Static Function
	@author ICMAIS
	@since 06/10/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function ICPCP01T()
	Local aArea		:= GetArea()
	Local aPergs   	:= {}
	Local lAtiva	:= .T.
	Local lCanSave 	:= .T.
 	Local lUserSave := .F.

	aAdd(aPergs, {2, "Ativa balança", , {"1=Sim","2=Não"},50, ".T.", .T.,,,,lCanSave,lUserSave})
	
	If ParamBox(aPergs, "Informe os parâmetros")
		If MV_PAR01 == "2"
			lAtiva := .F.	
		Endif

		//Atualiza parametro
		PutMV("MV_X_ATBAL",lAtiva)
	EndIf

	RestArea(aArea)
	
Return 







/*/{Protheus.doc} RETPESBAL
	Recupera peso da balança
	@type  Static Function
	@author ICMAIS
	@since 06/10/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function RETPESBAL()
	Local aArea		:= GetArea()
	Local nPesRet	:= 0
	//Local nLinhas	:= 0
	Local lBalanca	:= GetMv("MV_X_ATBAL")
	//Local omodelGrd	:= oModel:GetModel('ITENS')
	//Local oView     := FWViewActive()

	If lBalanca
		FWMsgRun(, {|oSay| nPesRet := U_ICPCP002() }, "Balança", "Capturando peso...")

		If nPesRet > 0
			ICPCPADD(nPesRet)

			//nLinhas := omodelGrd:Length() 
			//omodelGrd:GoLine(nLinhas)

			// Atualiza toda a tela
			//oView:Refresh()
			//SysRefresh()
		Endif
	Else
		msginfo('Balança desativada')
	Endif 

	RestArea(aArea)
	
Return 
