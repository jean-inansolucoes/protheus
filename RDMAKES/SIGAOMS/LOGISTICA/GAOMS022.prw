#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "font.ch"
#include "colors.ch"
#include "dbinfo.ch"
#include "tbiconn.ch"  

/*/{Protheus.doc} GAOMS022
Função responsável pelo processo de simulação de cargas
@type function
@version 1.0 
@author Igor
@since 14/02/2022
@param nOpc, numeric, Opção selecionada pelo usuário 
@return logical, lIncluiu
/*/
User Function GAOMS022( nOpc )
	
	Local cCadastro := "Simulação de Carga" + iif( nOpc == 2, " - " + ( cAliasTMP )->C5_X_SIMUL, "" )
	Local aPosObj   := {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aInfo     := {}
	Local oLayerCar	:= FWLayer():New()
	Local aAltPrd	:= {}
	local oCheckAll := Nil
	local lCheckAll := .T. as logical
	local oSayF4    := nil
	local oBmpBlE   := nil
	local oBmpBlC   := nil
	local oBmpBlG   := Nil
	local lOk       := .F. as logical
	
	Private aAltPed		:= {"C6_QTDLIB"}
	Private aTotDisp	:= {}
	
	//Private nTotVlr	  	:= 0
	//Private nTotPes	  	:= 0
	Private nTotVol	  	:= 0
	Private nTotQtdLib	:= 0
	
	Private aCposCar  := {}
	Private aHedeCar  := {}
	Private aColsCar  := {}
	
	Private aCposRot  := {}
	Private aHedeRot  := {}
	Private aColsRot  := {}
	
	Private aCposZon  := {}
	Private aHedeZon  := {}
	Private aColsZon  := {}
	
	Private aCposSet  := {}
	Private aHedeSet  := {}
	Private aColsSet  := {}
	
	Private aCposPed  := {}
	Private aHedePed  := {}
	Private aColsPed  := {}
	
	Private aTELA[0][0], aGETS[0]
	Private oDlg 
	Private oBrowCar, oBrowRot, oBrowZon, oBrowSet, oBrowPed, oBtnWFC, oBtnWFE, oBtnRFH  
	
	Private aArrayCli 	:= {} 
	Private aArrayTipo 	:= {}
	Private aArrayRota	:= {}
	Private aArraySetor	:= {}
	Private aArrayZona 	:= {}
	Private aArrayMod	:= {}
	Private aArrayPed	:= {}
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Private cGetEmAd   := Space( 250 )
	Private cGetEmail  := Space( 250 )

	if nOpc == 3	// Inclusão
		If !Pergunte( "OMS299",.T. )
			Return lOk
		Endif
	else
		// Apenas carrega os parâmetros em memória, caso necessite
		pergunte( "OMS299", .F. )
	endif
	
	//**********************************************************************
	// Campos das tabelas de origem 
	//**********************************************************************	
	aCposCar := {"DAK_VALOR","DAK_PESO","DAK_CAPVOL"}
	aCposRot := {"DA8_COD","DA8_DESC"}
	aCposZon := {"DA8_COD","DA5_COD","DA5_DESC"}
	aCposSet := {"DA8_COD","DA5_COD","DA6_PERCUR","DA6_REF"}
	//aCposPed := {"C9_PEDIDO","C9_ITEM", "C9_LOCAL","C9_PRODUTO","B1_DESC","C9_CLIENTE","C9_LOJA","A1_NOME","C6_PRCVEN","C5_PESOL","DAK_CAPVOL","A1_CEP","C9_QTDLIB","C6_QTDLIB","B2_QFIM", "B2_QATU" }
	aCposPed := {"C9_PEDIDO","C9_ITEM", "C9_LOCAL","C9_PRODUTO","B1_DESC","C9_CLIENTE","C9_LOJA","A1_NOME","C6_PRCVEN","C5_PESOL","C9_DATENT","C9_QTDLIB","C6_QTDLIB","B2_QFIM", "B2_QATU", "A1_EST", "A1_MUN", "A1_BAIRRO", "A1_CEP", "A1_END" }	
	
	// Seta hotkey apenas quando estiver gerando uma nova simulação
	if nOpc == 3
		// Seta HOT KEY para marcar todos os pedidos com apenas um comando
		SetKey(VK_F4, {|| marcaped( Nil,.T. ) })
	endif
	
	//				01			02			03			04			05			06			07		  08		09			10			11		  12		13			  14        15			16
	//**********************************************************************
	// Cria estrutura do browse
	//**********************************************************************	
	montEstr()		
	
	//**********************************************************************
	// Busca pedidos
	//**********************************************************************
	Processa({|| OmsBuscaPed( nOpc ) },"Selecionando Pedidos")	
 	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras de composição do tamanho do dialog³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aSize := MsAdvSize()
	AADD(aObjects, {100, 100, .T., .T.})
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)
	nDivTel := ((aPosObj[1,3] * 0.75) - aPosObj[1,1])
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL

		// Inicializa componente passa a Dialog criada, 
		// o segundo parametro é para criação de um botao de fechar utilizado para Dlg sem cabeçalho
		oLayerCar:INIT( oDlg, .F. )

		// Adiciona linha passando nome, porcentagem da largura, e se ela é redimensionada ou não
		// Adiciona coluna passando nome, porcentagem da largura, e se ela é redimensionada ou não e linha
		// Cria windows passando, nome da coluna onde sera criada, nome da window
		// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
		// se é redimensionada em caso de minimizar outras janelas e a ação no click do split
		oLayerCar:ADDLine('Lin01', 030, .F.)
		oLayerCar:ADDCollumn('Col01', 050, .F.,'Lin01')
		oLayerCar:ADDWindow('Col01', 'C1_Win01', 'Cargas',100,.T.,.F.,,'Lin01',)
		oFWCar	:= oLayerCar:getWinPanel("Col01","C1_Win01","Lin01")
		
		oBrowCar := MsNewGetDados():New(000, 000,(oFWCar:nClientHeight/2),(oFWCar:nClientWidth/2), GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAltPrd,0,999,'AllwaysTrue()','','AllwaysTrue()',oFWCar,aHedeCar,aColsCar,  )
		
		
		// Adiciona coluna passando nome, porcentagem da largura, e se ela é redimensionada ou não e linha
		// Cria windows passando, nome da coluna onde sera criada, nome da window
		// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
		// se é redimensionada em caso de minimizar outras janelas e a ação no click do split
		oLayerCar:ADDCollumn('Col02', 050, .F.,'Lin01')
		oLayerCar:ADDWindow('Col02', 'C1_Win02', 'Rotas',100,.T.,.F.,,'Lin01',)
		oFWRot := oLayerCar:getWinPanel("Col02","C1_Win02","Lin01")
		
		oBrowRot := MsNewGetDados():New(000, 000,(oFWRot:nClientHeight/2),(oFWRot:nClientWidth/2), GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAltPrd,0,999,'AllwaysTrue()','','AllwaysTrue()',oFWRot,aHedeRot,aColsrot,  )
		if nOpc == 3		// Ativa duplo-clique apenas quando for inclusão
			oBrowRot:oBrowse:bLDblClick := {|| oms22rot( "ROTAS" ) }
		endif
		
		//Coloca o botão de split na coluna
		//oLayerCar:setColSplit('Col01',CONTROL_ALIGN_RIGHT,"Lin01", )
		
		
		// Adiciona linha passando nome, porcentagem da largura, e se ela é redimensionada ou não
		// Adiciona coluna passando nome, porcentagem da largura, e se ela é redimensionada ou não e linha
		// Cria windows passando, nome da coluna onde sera criada, nome da window
		// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
		// se é redimensionada em caso de minimizar outras janelas e a ação no click do split
		oLayerCar:ADDLine('Lin02', 030, .F.)
		oLayerCar:ADDCollumn('Col01', 050, .F.,'Lin02')
		oLayerCar:ADDWindow('Col01', 'C1_Win03', 'Zonas',100,.T.,.F.,,'Lin02',)
		oFWZon	:= oLayerCar:getWinPanel("Col01","C1_Win03","Lin02")
		
		oBrowZon := MsNewGetDados():New(000, 000,(oFWZon:nClientHeight/2),(oFWZon:nClientWidth/2), GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAltPrd,0,999,'AllwaysTrue()','','AllwaysTrue()',oFWZon,aHedeZon,aColsZon,  )
		if nOpc == 3		// Ativa duplo-clique apenas quando for processo de inclusão
			oBrowZon:oBrowse:bLDblClick := {|| oms22rot( "ZONAS" ) }
		endif
		
		// Adiciona coluna passando nome, porcentagem da largura, e se ela é redimensionada ou não e linha
		// Cria windows passando, nome da coluna onde sera criada, nome da window
		// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
		// se é redimensionada em caso de minimizar outras janelas e a ação no click do split
		oLayerCar:ADDCollumn('Col02', 050, .F.,'Lin02')
		oLayerCar:ADDWindow('Col02', 'C1_Win04', 'Setores',100,.T.,.F.,,'Lin02',)
		oFWSet := oLayerCar:getWinPanel("Col02","C1_Win04","Lin02")
		
		oBrowSet := MsNewGetDados():New(000, 000,(oFWSet:nClientHeight/2),(oFWSet:nClientWidth/2), GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAltPrd,0,999,'AllwaysTrue()','','AllwaysTrue()',oFWSet,aHedeSet,aColsSet,  )
		if nOpc == 3		// Ativa o duplo-clique apenas quando for processo de inclusão
			oBrowSet:oBrowse:bLDblClick := {|| oms22rot( "SETORES" ) }
		endif
		
		//Coloca o botão de split na coluna
		//oLayerCar:setColSplit('Col01',CONTROL_ALIGN_RIGHT,"Lin02", )
		
		// Cria windows passando, nome da coluna onde sera criada, nome da window
		// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
		// se é redimensionada em caso de minimizar outras janelas e a ação no click do split
		oLayerCar:ADDLine('Lin03', 040, .F.)
		oLayerCar:ADDCollumn('Col01', 100, .F.,'Lin03')
		oLayerCar:ADDWindow('Col01', 'C1_Win05', 'Pedidos',100,.T.,.F.,,'Lin03',)
		oFWPed := oLayerCar:getWinPanel("Col01","C1_Win05","Lin03")		
		
		oBrowPed := MsNewGetDados():New(000, 000,(oFWPed:nClientHeight/2)-10,(oFWPed:nClientWidth/2)-100, 3,'AllwaysTrue()','AllwaysTrue()','',aAltPed,0,999,'U_OMSVLCPO()','','AllwaysTrue()',oFWPed,aHedePed,aColsPed,  )
		if nOpc == 3	// Ativa o duplo-clique apenas quando for para gerar novo processo
			oBrowPed:oBrowse:bLDblClick := {|| marcaped( lCheckAll ), oBrowPed:oBrowse:Refresh() }
		endif
		oCheckAll := TCheckBox():New((oFWPed:nClientHeight/2)-10,002,'Todos os itens do pedido',{|u|if(PCount()>0,lCheckAll:=u,lCheckAll)},oFWPed,100,020,,,,,,,,.T.,,,)
		oCheckAll:bWhen := {|| nOpc == 3 }
		if nOpc == 3	// Exibe atalho apenas quando estiver realizando montagem da carga
			oSayF4	  := TSay():New( (oFWPed:nClientHeight/2)-10,110,{||"Pressione F4 para selecionar todos os pedidos"},oFWPed,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
		endif

		oGrpLeg	 := TGroup():New( 000,(oFWPed:nClientWidth/2)-100,(oFWPed:nClientHeight/2)-50,(oFWPed:nClientWidth/2)," Legenda ",oFWPed,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oBmpLib  := TBitmap():New( 010,(oFWPed:nClientWidth/2)-095,008,008,,"BR_VERDE",.T.,oGrpLeg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oBmpBlE  := TBitmap():New( 022,(oFWPed:nClientWidth/2)-095,008,008,,"BR_PRETO",.T.,oGrpLeg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oBmpBlC  := TBitmap():New( 034,(oFWPed:nClientWidth/2)-095,008,008,,"BR_AZUL" ,.T.,oGrpLeg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oBmpBlG  := TBitmap():New( 046,(oFWPed:nClientWidth/2)-095,008,008,,"BR_PINK" ,.T.,oGrpLeg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		
		oSayLib	 := TSay():New( 010,(oFWPed:nClientWidth/2)-85,{||"Pedido liberado"}    ,oGrpLeg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
		oSayBlE	 := TSay():New( 022,(oFWPed:nClientWidth/2)-85,{||"Saldo Insuficiente"} ,oGrpLeg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
		oSayBlC	 := TSay():New( 034,(oFWPed:nClientWidth/2)-85,{||"Bloqueio de Crédito"},oGrpLeg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
		oSayBlG	 := TSay():New( 046,(oFWPed:nClientWidth/2)-85,{||"Bloqueio Gerencial"} ,oGrpLeg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
		
		oBtnImp	 := TButton():New( (oFWPed:nClientHeight/2)-45,(oFWPed:nClientWidth/2)-100,"Workflow de Separação",oFWPed,,100,012,,,,.T.,,"",,,,.F. )
		oBtnImp:bAction := {|| U_XXXXXX() }
		oBtnImp:bWhen := {|| nOpc == 2 }
	
		oBtnRFH	 := TButton():New( (oFWPed:nClientHeight/2)-27,(oFWPed:nClientWidth/2)-100,"Efetua Reserva",oFWPed,,100,012,,,,.T.,,"",,,,.F. )
		oBtnRFH:bAction := {|| lOk := oms22SC9() } 
		oBtnRFH:bWHen := {|| nOpc == 3 }

	ACTIVATE MSDIALOG oDlg ON INIT Processa({|| iif( nOpc == 2, visualInit(), Nil ) }, 'Aguarde!', 'Buscando pedidos...')

Return lOk

/*/{Protheus.doc} visualInit
Função para percorrer todas as rotas dos pedidos relacionados ao processo de simulação que está sendo visualizado
@type function
@version 1.0 
@author Igor
@since 15/02/2022
/*/
static function visualInit()
	
	local nRt := 0 as numeric
	if len( oBrowRot:aCOLS ) > 0
		for nRt := 1 to len( oBrowRot:aCOLS )
			oBrowRot:Goto(nRt)
			oms22rot( "ROTAS" )
			oBrowRot:oBrowse:Refresh()
		next nRt
	endif

	// Desativa os objetos do grid para evitar que o usuário consiga editar alguma coisa
	oBrowPed:Disable()
	oBrowCar:Disable()
	oBrowRot:Disable()
	oBrowSet:Disable()
	oBrowZon:Disable()

return Nil


/***
 * Função responsável preparar o aHeader para ser usado no Grid.
 */
User Function OMSVLCPO
Local lRet := .T.
Local nPsLib := aScan(aHedePed,{|x| AllTrim(x[2]) == 'C9_QTDLIB'})

If M->C6_QTDLIB <= aColsPed[n][nPsLib] 
	oms22rot( AllTrim( STR( M->C6_QTDLIB ) ) )
Else
	ShowHelpDlg("Quantidade Informada", {"Quantidade informada maior que a liberada."},5,{"Favor informa quantidade menor ou igual a liberada."},5) 
	lRet := .F.
Endif

Return lRet




/***
 * Função responsável preparar o aHeader para ser usado no Grid.
 */
Static Function montEstr()
	Local nX := 0
	Local aHeadLocal := {}
	
	//----------------------------------------------------------------------
	//Monta aHeader Cargas
	aHeadLocal := {}
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'legenda', 'V', 'S' } )
	aCampos := aClone( aCposCar )
	For nX := 1 To Len( aCampos )
		dbSelectArea( "SX3" )
		dbSetOrder( 2 ) 
		dbSeek( aCampos[nX] )
		
		Do Case
			Case AllTrim( SX3->X3_CAMPO ) == "DAK_VALOR"
				cTitulo := "Valor"
				nTamanho := SX3->X3_TAMANHO
			Case AllTrim( SX3->X3_CAMPO ) == "DAK_PESO"
				cTitulo := "Peso"
				nTamanho := SX3->X3_TAMANHO
			Case AllTrim( SX3->X3_CAMPO ) == "DAK_CAPVOL"
				cTitulo := "Volume"
				nTamanho := SX3->X3_TAMANHO				
			Otherwise	
				nTamanho := SX3->X3_TAMANHO
				cTitulo := TRIM( X3TITULO( ) )
		Endcase
		
		aAdd( aHeadLocal, { cTitulo, SX3->X3_CAMPO, SX3->X3_PICTURE, nTamanho, SX3->X3_DECIMAL, SX3->X3_VALID, "", SX3->X3_TIPO } )
	Next nX	
	aHedeCar := aClone( aHeadLocal )
	//----------------------------------------------------------------------
	
	//----------------------------------------------------------------------
	//Monta aHeader Rotas
	aHeadLocal := {}
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'legenda', 'V', 'S' } )
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'mark'   , 'V', 'S' } )
	aCampos := aClone( aCposRot )
	For nX := 1 To Len( aCampos )
		dbSelectArea( "SX3" )
		dbSetOrder( 2 ) 
		dbSeek( aCampos[nX] )
		aAdd( aHeadLocal, { TRIM( X3TITULO( ) ), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, "", SX3->X3_TIPO } )
	Next nX	
	aHedeRot := aClone( aHeadLocal )
	//----------------------------------------------------------------------
	
	//----------------------------------------------------------------------
	//Monta aHeader Zonas
	aHeadLocal := {}
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'legenda', 'V', 'S' } )
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'mark'   , 'V', 'S' } )
	aCampos := aClone( aCposZon )
	For nX := 1 To Len( aCampos )
		dbSelectArea( "SX3" )
		dbSetOrder( 2 ) 
		dbSeek( aCampos[nX] )
		aAdd( aHeadLocal, { TRIM( X3TITULO( ) ), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, "", SX3->X3_TIPO } )
	Next nX	
	aHedeZon := aClone( aHeadLocal )
	//----------------------------------------------------------------------	
	
	//----------------------------------------------------------------------
	//Monta aHeader Setores
	aHeadLocal := {}
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'legenda', 'V', 'S' } )
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'mark'   , 'V', 'S' } )
	aCampos := aClone( aCposSet )
	For nX := 1 To Len( aCampos )
		dbSelectArea( "SX3" )
		dbSetOrder( 2 ) 
		dbSeek( aCampos[nX] )
		aAdd( aHeadLocal, { TRIM( X3TITULO( ) ), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, "", SX3->X3_TIPO } )
	Next nX	
	aHedeSet := aClone( aHeadLocal )
	//----------------------------------------------------------------------	
	
	//----------------------------------------------------------------------
	//Monta aHeader Pedidos
	aHeadLocal := {}
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'legenda', 'V', 'S' } )
	aAdd( aHeadLocal, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'mark'   , 'V', 'S' } )
	aCampos := aClone( aCposPed )
	For nX := 1 To Len( aCampos )
		dbSelectArea( "SX3" )
		dbSetOrder( 2 ) 
		dbSeek( aCampos[nX] )
		
		Do Case
			Case AllTrim( SX3->X3_CAMPO ) == "C6_PRCVEN"
				cTitulo := "Valor"
				nTamanho := SX3->X3_TAMANHO
				cValid := SX3->X3_VALID
			Case AllTrim( SX3->X3_CAMPO ) == "C5_PESOL"
				cTitulo := "Peso"
				nTamanho := SX3->X3_TAMANHO
				cValid := SX3->X3_VALID
			Case AllTrim( SX3->X3_CAMPO ) == "B1_DESC"
				nTamanho := 20
				cTitulo := TRIM( X3TITULO( ) )
				cValid := SX3->X3_VALID
			Case AllTrim( SX3->X3_CAMPO ) == "A1_NOME"
				nTamanho := 20	
				cTitulo := TRIM( X3TITULO( ) )
				cValid := SX3->X3_VALID
			Case AllTrim( SX3->X3_CAMPO ) == "C9_QTDLIB"
				cTitulo := "Qtd.Liberada"
				nTamanho := SX3->X3_TAMANHO
				cValid := SX3->X3_VALID
			Case AllTrim( SX3->X3_CAMPO ) == "C6_QTDLIB"
				cTitulo := "Qtde Liberada Simulação"
				nTamanho := SX3->X3_TAMANHO
				cValid := ""
			Case AllTrim( SX3->X3_CAMPO ) == "B2_QFIM"
				cTitulo := "Saldo Disponivel"
				nTamanho := SX3->X3_TAMANHO		
				cValid := SX3->X3_VALID		
			Case AllTrim( SX3->X3_CAMPO ) == "A1_EST" //ADD ALEXANDRE TRELAC
				cTitulo := "UF"
				nTamanho := SX3->X3_TAMANHO		
				cValid := SX3->X3_VALID	
			Case AllTrim( SX3->X3_CAMPO ) == "A1_MUN"
				cTitulo := "Municipio"
				nTamanho := SX3->X3_TAMANHO		
				cValid := SX3->X3_VALID
			Case AllTrim( SX3->X3_CAMPO ) == "A1_BAIRRO"
				cTitulo := "Bairro"
				nTamanho := SX3->X3_TAMANHO		
				cValid := SX3->X3_VALID				
			Case AllTrim( SX3->X3_CAMPO ) == "A1_CEP"
				cTitulo := "CEP"
				nTamanho := SX3->X3_TAMANHO		
				cValid := SX3->X3_VALID
			Case AllTrim( SX3->X3_CAMPO ) == "A1_END"
				cTitulo := "Endereco"
				nTamanho := SX3->X3_TAMANHO		
				cValid := SX3->X3_VALID			//FIM ALEXANDRE TRELAC
			Otherwise	
				nTamanho := SX3->X3_TAMANHO
				cTitulo := TRIM( X3TITULO( ) )
				cValid := SX3->X3_VALID
		Endcase
		
		aAdd( aHeadLocal, { cTitulo, SX3->X3_CAMPO, SX3->X3_PICTURE, nTamanho, SX3->X3_DECIMAL, cValid, "", SX3->X3_TIPO } )
	Next nX	
	aHedePed := aClone( aHeadLocal )
	//----------------------------------------------------------------------		
	
Return ( Nil )

/*/{Protheus.doc} OmsBuscaPed
Função para leitura dos pedidos de acordo com os filtros selecionados durante a inicialização
@type function
@version 1.0 
@author Igor
@since 15/02/2022
@param nOpc, numeric, opção utilizada pelo usuário para abertura da rotina
/*/
Static Function OmsBuscaPed( nOpc )

	Local cQry		:= ""  
	Local cAlSC9    := GetNextAlias()
	Local lShare   	:= .T.
	Local lReadOnly	:= .F.
	Local nTipoOper := OsVlEntCom()
	Local lTransp   := SuperGetMv("MV_CGTRANS",.F.,.F.)
	Local lLocalEnt	:= SC5->(FieldPos("C5_CLIENT"))  > 0
	Local lQuery 	:= .T.
	Local lRotAtv  	:= SuperGetMv("MV_ROTATV",.F.,"2") == "2"
	Local lFreteEmb := .F.
	// Local cAlocPer 	:= SuperGetMv("MV_ALOCPER",.F.,"N")
	Local cStsLeg   := ""
	Local nX        := 0

	cQry := "SELECT C9_FILIAL,C9_PRODUTO,C9_CLIENTE,C9_LOJA,C9_QTDLIB,C9_PRCVEN,"
	cQry += "C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_ENDPAD,C9_BLCRED, C9_BLEST,C9_DATENT,SC9.R_E_C_N_O_ RECNO,"
	cQry += "B1_TIPCAR,SB1.R_E_C_N_O_ RECSB1,C9_LOCAL,"
	cQry += "SC5.C5_LOJAENT, SC5.C5_TIPO, SC5.R_E_C_N_O_ RECSC5, SC5.C5_EMISSAO, SC5.C5_BLQ "
	If	lLocalEnt
		cQry += ",SC5.C5_CLIENT"
	EndIf
	If	lFreteEmb
		cQry += ",SC5.C5_TPFRETE"
	EndIf
	cQry += " FROM "+RetSqlName('SC9')+" SC9, "
	cQry += RetSqlName('SC5')+" SC5, "
	cQry += RetSqlName('SC6')+" SC6, "
	cQry += RetSqlName('SB1')+" SB1 "
	cQry += " WHERE "
	cQry += " SC9.C9_FILIAL      = '"+ xFilial("SC9") +"'"

	if nOpc == 3		// Inclusão
		cQry += " AND SC9.C9_SEQCAR  = '"+ Space(Len(SC9->C9_SEQCAR))+ "'"
		cQry += " AND SC9.C9_PEDIDO  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
		cQry += " AND SC9.C9_CLIENTE BETWEEN '"+mv_par03+"' AND '"+ mv_par04 +"'"
		cQry += " AND SC9.C9_LOJA    BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"'"
		cQry += " AND SC9.C9_DATALIB BETWEEN '"+Dtos(mv_par07)+"' AND '"+Dtos(mv_par08)+"' "
		cQry += " AND SC9.C9_DATENT  BETWEEN '"+ DtoS(MV_PAR09) +"' AND '"+ DtoS( MV_PAR10 ) +"' "
		cQry += " AND SC9.C9_BLCRED  = '"+ Space( TAMSX3("C9_BLCRED" )[1] ) +"' "
		cQry += " AND SC9.C9_NFISCAL = '"+ Space( TAMSX3("C9_NFISCAL")[1] ) +"' "
		cQry += " AND SC9.C9_SERIENF = '"+ Space( TAMSX3("C9_SERIENF")[1] ) +"' "
		cQry += " AND SC9.C9_TPCARGA = '1' "
		cQry += " AND SC9.C9_X_SIMUL = '"+ Space( TAMSX3("C9_X_SIMUL")[1] ) +"' "		// traz apenas itens que ainda não foram adicionados a um processo de simulação
	else				// Visualização
		cQry += " AND SC9.C9_X_SIMUL = '"+ (cAliasTMP)->C5_X_SIMUL +"' "
	endif
	cQry += " AND SC9.D_E_L_E_T_ = ' ' "

	cQry += " AND SB1.B1_FILIAL  = '"+ xFilial("SB1")+ "' "
	cQry += " AND SB1.B1_COD     = C9_PRODUTO"
	cQry += " AND SB1.D_E_L_E_T_ = ' '"
	
	cQry += " AND SC5.C5_FILIAL  = '"+ FWxFilial( "SC5" ) +"' "
	cQry += " AND SC5.C5_NUM     = SC9.C9_PEDIDO"
	// PARAMETRO LOGICO QUE VALIDA SE A CARGA DEVE SER MONTADA PARA TRANSPORTADORA DO PEDIDO
	If !lTransp .and. nOpc == 3
		cQry += " AND SC5.C5_TRANSP = '"+Space(Len(SC5->C5_TRANSP))+"'"
	EndIf
	cQry += " AND SC5.D_E_L_E_T_ = ' '"
	
	cQry += " AND SC6.C6_FILIAL  =  '"+ FWxFilial( "SC6" ) +"' "
	cQry += " AND SC6.C6_NUM     = SC9.C9_PEDIDO"
	cQry += " AND SC6.C6_ITEM    = SC9.C9_ITEM"
	cQry += " AND SC6.C6_PRODUTO = SC9.C9_PRODUTO"
	cQry += " AND SC6.D_E_L_E_T_ = ' ' "

	cQry += " ORDER BY C9_FILIAL,C9_PEDIDO,C9_ITEM "
	
	If Select( cAlSC9 ) > 0
		( cAlSC9 )->( dBCloseArea( ) )
	EndIf

    //MemoWrite("OMS299.txt",  cQry)			
	dBUseArea( .T., "TOPCONN", TcGenQry( ,,cQry ), cAlSC9 , lShare, lReadOnly )
	
	( cAlSC9 )->( dBGoTop()( ) )
	
	ProcRegua( ( cAlSC9 )->( RecCount()( ) ) )
	
	While ( cAlSC9 )->( !Eof()( ) )
		IncProc( "Roterizando Pedido "+AllTrim( ( cAlSC9 )->C9_PEDIDO ) )
		
		//MSGINFO( ( cAlSC9 )->C9_PEDIDO )
	
		lContinua := .T.
		
		//-- Posiciona Registros
		SB1->( MsGoto( ( cAlSC9 )->RECSB1 ) )
		SC5->( MsGoto( ( cAlSC9 )->RECSC5 ) )

		//-- Verifica os tipo de carga
		/*
		If	lContinua .And. !Empty( ( cAlSC9 )->B1_TIPCAR )
			nPosModelo := Ascan( aArrayMod,{|x| Trim(x[2]) == Trim( ( cAlSC9 )->B1_TIPCAR )} )
			If	nPosModelo > 0
				If !aArrayMod[nPosModelo,1]
					lContinua := .F.
				EndIf
			EndIf
		EndIf
		*/
			
		If	lContinua
			//-- Verifica os tipo de pedido e o codigo/loja do cliente/fornecedor
			cCliente   := Iif( lLocalEnt.And.!Empty( SC5->C5_CLIENT ), SC5->C5_CLIENT ,( cAlSC9 )->C9_CLIENTE )
			cLoja      := Iif( lLocalEnt.And.!Empty( SC5->C5_LOJAENT ),SC5->C5_LOJAENT,( cAlSC9 )->C9_LOJA )
			cAliasCli  := Iif( SC5->C5_TIPO $ "BD" ,"SA2"       ,"SA1"       )
			cCpoNomCli := Iif( SC5->C5_TIPO $ "BD" ,"A2_NOME"   ,"A1_NOME"   )
			cCpoBaiCli := Iif( SC5->C5_TIPO $ "BD" ,"A2_BAIRRO" ,"A1_BAIRRO" )
			cCpoMunCli := Iif( SC5->C5_TIPO $ "BD" ,"A2_MUN"    ,"A1_MUN"    )
			cCpoEstCli := Iif( SC5->C5_TIPO $ "BD" ,"A2_EST"    ,"A1_EST"    )
			cCpoCepCli := Iif( SC5->C5_TIPO $ "BD" ,"A2_CEP"    ,"A1_CEP"    )
			cCpoCdrDes := Iif( SC5->C5_TIPO $ "BD" ,"A2_CDRDES" ,"A1_CDRDES" )
			//-- Verifica o codigo de referencia para o operador logistico - Amarracao Cod Cli X OL
			If	nTipoOper == 3
				DCK->( DbSetOrder( 2 ) ) //DCK_FILIAL+DCK_CODCLI+DCK_LOJCLI
				If	DCK->( MsSeek( xFilial( "DCK" )+( cAlSC9 )->C9_CLIENTE+( cAlSC9 )->C9_LOJA)) .And. ( cAlSC9 )->C9_FILIAL != cFilAnt
					cCliente := DCK->DCK_CODOPL
					cLoja    := DCK->DCK_LOJOPL
				EndIf
			EndIf
			//-- Garanto a integridade do pedido no momento da montagem de carga com SoftLock
			If	lQuery
				DbSelectArea( "SC9" )
				DbGoTo( ( cAlSC9 )->RECNO )
			EndIf
			//-- Inicializa as variaveis
			nPesoProd  := 0
			cCodRota   := Space( Len( DA8->DA8_COD ) )
			cDescRota  := "PEDIDOS SEM ROTA"
			cZona      := Space( Len( DA7->DA7_PERCUR ) )
			cSetor     := Space( Len( DA7->DA7_ROTA ) )
			cSeqRota   := Space( Len( DA9->DA9_SEQUEN ) )
			cSequencia := Space( Len( DA7->DA7_SEQUEN ) )
			lAchou     := .F.
			lValido    := .F.
			lTipCarga  := .T.
			If ( nPosRota := aScan( aArrayCli, {|x|x[1]+x[2]=cCliente+cLoja} ) ) > 0 
				cCodRota   := aArrayCli[nPosRota,3]
				cZona      := aArrayCli[nPosRota,4]
				cSetor     := aArrayCli[nPosRota,5]
				cSeqRota   := aArrayCli[nPosRota,6]
				cSequencia := aArrayCli[nPosRota,7]
				lValido    := .T.
			Else
				//-- Pesquisa o cliente/fornecedor em clientes por setor
				DbSelectArea( "DA7" )
				aRegDA7 := OmsHasDA7( ( cAlSC9 )->C9_FILIAL, cCliente, cLoja, cAliasCli )
	
				If	Len( aRegDA7 ) > 0
					//For nRegDA7 := 1 To Len(aRegDA7)
						DA7->( MsGoto( aRegDA7[Len( aRegDA7 )] ) )
						cZona      := DA7->DA7_PERCUR
						cSetor     := DA7->DA7_ROTA
						cSequencia := DA7->DA7_SEQUEN
						//-- Pesquisa o cliente/fornecedor na zona/setor
						DA9->( DbSetOrder( 2 ) ) //DA9_FILIAL+DA9_ROTEIR+DA9_SEQUEN+DA9_PERCUR+DA9_ROTA
						If	DA9->( MsSeek( xFilial( "DA9" )+cZona+cSetor ) )
							//-- Verifica se busca a primeira rota ativa
							While DA9->( !Eof( ) ) .And. DA9->DA9_FILIAL == xFilial("DA9") .And.;
								DA9->DA9_PERCUR == cZona .And.;
								DA9->DA9_ROTA   == cSetor
								//-- Pesquisa a Rota
								DA8->( DbSetOrder( 1 ) ) //DA8_FILIAL+DA8_COD
								If	DA8->( MsSeek(xFilial( "DA8" )+DA9->DA9_ROTEIR ) )
									If	DA8->DA8_ATIVO == "1" .And. If( lRotAtv,.T.,IIf( !Empty( DA8->DA8_CODCAL ),OmsDtEntr( DA8->DA8_CODCAL,dDataBase ) == dDataBase,.T. ) )
										//-- Verifica os tipo de carga da rota se esta incluido
										lValido   := .T.
										lTipCarga := .T.
										If	DA8->( FieldPos( "DA8_TIPCAR" ) ) > 0 .And. !Empty( DA8->DA8_TIPCAR )
											nPosModelo := Ascan( aArrayTipo,{|x| Trim(x[2] ) == Trim( DA8->DA8_TIPCAR )} )
											If	nPosModelo > 0
												If !aArrayTipo[nPosModelo,1]
													lValido := .F.
												Else
													DB0->( DbSetOrder( 1 ) ) //DB0_FILIAL+DB0_CODMOD
													If	DB0->( MsSeek( xFilial( "DB0" )+SB1->B1_TIPCAR ) ) .And.;
														AllTrim(aArrayTipo[nPosModelo,2]) <> DB0->DB0_TIPCAR
														lTipCarga := .F.
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								// Else
									// Exit //-- Nao localizou Rota
								EndIf
								//--
								If	lValido .And. lTipCarga
									lAchou   := .T.
									cCodRota := DA8->DA8_COD
									cDescRota:= DA8->DA8_DESC
									cSeqRota := DA9->DA9_SEQUEN
									//-- Pesquisa os Setores por Zona
									DbSelectArea( "DA6" )
									DA6->( DbSetOrder( 1 ) ) //DA6_FILIAL+DA6_PERCUR+DA6_ROTA
									If	MsSeek( xFilial( "DA6" )+cZona+cSetor )
										cPtoRefDA6 := DA6->DA6_REF
										//-- Pesquisa as Zonas
										DbSelectArea( "DA5" )
										DA5->( DbSetOrder( 1 ) )
										If	MsSeek( xFilial( "DA5" )+DA6->DA6_PERCUR )
											cPtoRefDA5 := DA5->DA5_DESC
										Else
											cPtoRefDA5 := ""
										EndIf
										If Ascan( aArrayRota, {|x| x[3] == cCodRota} ) == 0 .And. lValido
											AAdd( aArrayRota, { .T.,.F.,cCodRota,cDescRota,Space( 6 )} )
										EndIf
										//-- Verifico se existe setor para pegar descricao e acrescento no array
										If Ascan( aArraySetor, {|x| x[3]+x[4]+x[5] == cCodRota+cZona+cSetor} ) == 0 .And. lValido
											AAdd( aArraySetor, { .T.,.F.,cCodRota,cZona,cSetor,cPtoRefDA6,"      ",cSeqRota} )
											//-- Busco se ja existe a zona no array , caso nao exista,a mesma e incluida
											If Ascan(aArrayZona, {|x| x[3]+x[4] == cCodRota+cZona}) == 0
												AAdd(aArrayZona, { .T.,.F.,cCodRota,cZona,cPtoRefDA5,"      ",cSeqRota} )
											EndIf
										EndIf
									EndIf
									//-- Se localizou uma Rota para este Cliente
									// If	cAlocPer <> "S"
										// Exit
									// EndIf
								EndIf
								DA9->( DbSkip( ) )
							EndDo
						EndIf
						//-- Se localizou uma Rota para este Cliente / Produto / Tipo Carga
						// If	lAchou .And. cAlocPer <> "S"
							// Exit
						// EndIf
					//Next nRegDa7
				EndIf
				If !lAchou
					cCodRota   := Repl("9",Len(DA8->DA8_COD))
					cDescRota  := "PEDIDOS SEM ROTEIRIZACAO"
					cZona      := Repl("9",Len(DA7->DA7_PERCUR))
					cSetor     := Repl("9",Len(DA7->DA7_ROTA))
					cSeqRota   := Repl("9",Len(DA9->DA9_SEQUEN))
					cSequencia := Repl("9",Len(DA7->DA7_SEQUEN))
					lValido    := .T.
					If Ascan(aArrayRota, {|x| x[3] == cCodRota}) == 0
						AAdd(aArrayRota, {.T.,.F.,cCodRota,cDescRota,Space(6)} )
					EndIf
					If Ascan(aArrayZona, {|x| x[3]+x[4] == cCodRota+cZona}) == 0
						AAdd(aArrayZona, {.T.,.F.,cCodRota,cSetor,cDescRota,"      ",cSeqRota} )
					EndIf
					If Ascan(aArraySetor, {|x| x[3]+x[4]+x[5] == cCodRota+cZona+cSetor}) == 0
						AAdd(aArraySetor, {.T.,.F.,cCodRota,cZona,cSetor,cDescRota,"      ",cSeqRota} )
					EndIf
				EndIf
				//--
				AAdd(aArrayCli,{cCliente, cLoja, cCodRota, cZona, cSetor, cSeqRota, cSequencia})
			EndIf
			//-- Verifico se consiste os dados do pedido e se a rota foi valida
			( cAliasCli )->( DbSetOrder( 1 ) )
			If	( cAliasCli )->( MsSeek( OsFilial( cAliasCli, (cAlSC9)->C9_FILIAL)+cCliente+cLoja ) ) .And. lValido
				Do Case
					Case SuperGetMv("MV_ROTCEP",.F.,"1") == "1"
						cCpoCepCli := Iif( SC5->C5_TIPO $ "BD", "A2_CEP","A1_CEP")
					Case SuperGetMv("MV_ROTCEP",.F.,"1") == "2"
						cCpoCepCli := Iif( SC5->C5_TIPO $ "BD", "A2_CEP",IIf(!Empty((cAliasCli)->(FieldGet(FieldPos("A1_CEPE")))),"A1_CEPE","A1_CEP"))
					Case SuperGetMv("MV_ROTCEP",.F.,"1") == "3"
						cCpoCepCli := Iif( SC5->C5_TIPO $ "BD", "A2_CEP","A1_CEPE")
				EndCase
				//-- Calculo peso do item do pedido
				If FindFunction("OsPesoProd")
					nPesoProd := OsPesoProd((cAlSC9)->C9_PRODUTO)
				Else
					nPesoProd := SB1->( FieldGet( FieldPos( cCpoPeso ) ) )
				EndIf
				nPesoProd := (nPesoProd*(cAlSC9)->C9_QTDLIB)
				nValor    := A410Arred(((cAlSC9)->C9_QTDLIB *(cAlSC9)->C9_PRCVEN),"DAK_VALOR")
				nCapArm   := OsPrCapArm((cAlSC9)->C9_PRODUTO,(cAlSC9)->C9_FILIAL)
				nCapVol   := (nCapArm  *(cAlSC9)->C9_QTDLIB)
				nQtdLib   := (cAlSC9)->C9_QTDLIB
				If	lFreteEmb
					cTpFrete:= If( SC5->C5_TPFRETE=="C","CIF",If( SC5->C5_TPFRETE == "F", "FOB","" ) )
				EndIf
				
			EndIf
			
		EndIf
		
		Do Case 
			Case !Empty( ( cAlSC9 )->C9_BLCRED ) .And. ( cAlSC9 )->C9_BLCRED <> "10"  
				cStsLeg := 'BR_AZUL' 
			Case (cAlSC9)->C5_BLQ == "8"		// Boqueio de análise gerencial
				cStsLeg := "BR_PINK"
			//Case !Empty( ( cAlSC9 )->C9_BLEST ) .And. ( cAlSC9 )->C9_BLEST <> "10"
			//	cStsLeg := 'BR_PRETO'
			Otherwise 
				cStsLeg := 'BR_VERDE'
		EndCase
		
		//Posiciona para verificar saldo atual e saldo disponivel
		dbSelectArea( "SB2" )
		SB2->( dbSetOrder( 1 ) )
		SB2->( dbGoTop( ) )
		If dbSeek( xFilial( "SB2" )+( cAlSC9 )->( C9_PRODUTO+C9_LOCAL ) )
			nQtdAtual := SB2->B2_QATU
			nQtSdDisp := ( SB2->B2_QATU - SB2->B2_RESERVA )
		Else
			nQtdAtual := 0
			nQtSdDisp := 0
		Endif
		 
		AAdd( aArrayPed,{	cStsLeg,;  //01
							iif( nOpc == 3, 'LBNO', 'LBOK' ),; //02
							( cAlSC9 )->C9_PEDIDO,; //03
							( cAlSC9 )->C9_ITEM,; //04
							( cAlSC9 )->C9_LOCAL,; //05
							( cAlSC9 )->C9_PRODUTO,; //06
							Posicione( "SB1",1,xFilial("SB1")+( cAlSC9 )->C9_PRODUTO,"B1_DESC" ),; //07
							( cAlSC9 )->C9_CLIENTE,; //08
							( cAlSC9 )->C9_LOJA,; //09
							Posicione( "SA1",1,xFilial("SA1")+( cAlSC9 )->( C9_CLIENTE+C9_LOJA ),"A1_NOME" ),; //10
							nValor,; //11
							nPesoProd,; //12
							STOD( ( cAlSC9 )->C5_EMISSAO ),;  //13 nCapVol
							"",; //14 SA1->A1_CEP
							cCodRota,; //15
							cZona,; //16
							cSetor,;  //17
							cSeqRota,; //18
							( cAlSC9 )->C9_QTDLIB,; //19
							( cAlSC9 )->C9_PRCVEN,; //20
							STOD(( cAlSC9 )->C9_DATENT),; //21
							nQtdLib,; //22
							nQtSdDisp,; //23
							nQtdAtual,; //24
							Posicione( "SA1",1,xFilial("SA1")+( cAlSC9 )->( C9_CLIENTE+C9_LOJA ),"A1_EST" ),; //25  //ADD ALEXANDRE TRELAC
							Posicione( "SA1",1,xFilial("SA1")+( cAlSC9 )->( C9_CLIENTE+C9_LOJA ),"A1_MUN" ),; //26 //ADD ALEXANDRE TRELAC
							Posicione( "SA1",1,xFilial("SA1")+( cAlSC9 )->( C9_CLIENTE+C9_LOJA ),"A1_BAIRRO" ),; //27 //ADD ALEXANDRE TRELAC
							Posicione( "SA1",1,xFilial("SA1")+( cAlSC9 )->( C9_CLIENTE+C9_LOJA ),"A1_CEP" ),; //28 //ADD ALEXANDRE TRELAC
							Posicione( "SA1",1,xFilial("SA1")+( cAlSC9 )->( C9_CLIENTE+C9_LOJA ),"A1_END" ),; //29 //ADD ALEXANDRE TRELAC
							} ) 
		
		//Verifica totalizador saldo insuficiente 
		nPos := Ascan( aTotDisp,{|x| x[1] == ( cAlSC9 )->C9_PRODUTO } )
		If nPos == 0
			aadd( aTotDisp,{ ( cAlSC9 )->C9_PRODUTO, ( cAlSC9 )->C9_QTDLIB } )
		Else
			aTotDisp[nPos][2] += ( cAlSC9 )->C9_QTDLIB 	
		Endif
		
	( cAlSC9 )->( dBSkip( ) )
	Enddo	
	
	If Select( cAlSC9 ) > 0
		( cAlSC9 )->( dBCloseArea( ) )
	EndIf

	//-- Ordena os browses de rota, zona e setor de acordo com a sequencia
	aArrayRota  := aSort( aArrayRota,,,{|x,y| x[3] < y[3] } )
	aArrayZona  := aSort( aArrayZona,,,{|x,y| x[3]+x[7]+x[4] < y[3]+y[7]+y[4] } )
	aArraySetor := aSort( aArraySetor,,,{|x,y| x[3]+x[8]+x[4]+x[5] < y[3]+y[8]+y[4]+x[5] } )
	
	//Popula browse Total Cargas
	aAdd( aColsCar, Array( Len( aHedeCar ) + 1 ) )
	aColsCar[Len( aColsCar )][ 1 ] := 'BR_VERDE'
	aColsCar[Len( aColsCar )][ 2 ] := 0
	aColsCar[Len( aColsCar )][ 3 ] := 0
	aColsCar[Len( aColsCar )][ 4 ] := 0
	aColsCar[Len( aColsCar )][Len( aHedeCar ) + 1] := .F.
	
	//Popula browse Rotas
	If Len( aArrayRota ) > 0
		For nX := 1 To Len( aArrayRota )
			aAdd( aColsRot, Array( Len( aHedeRot ) + 1 ) )
			aColsRot[Len( aColsRot )][ 1 ] := 'BR_VERDE'
			aColsRot[Len( aColsRot )][ 2 ] := 'LBNO'
			aColsRot[Len( aColsRot )][ 3 ] := aArrayRota[nX][3]
			aColsRot[Len( aColsRot )][ 4 ] := aArrayRota[nX][4]			
			aColsRot[Len( aColsRot )][Len( aHedeRot ) + 1] := .F.				
		Next nX
	Endif	
	
	//Popula browse Zonas
	If Len( aArrayZona ) > 0
		For nX := 1 To Len( aArrayZona )
			aAdd( aColsZon, Array( Len( aHedeZon ) + 1 ) )
			aColsZon[Len( aColsZon )][ 1 ] := 'BR_VERDE'
			aColsZon[Len( aColsZon )][ 2 ] := 'LBNO'
			aColsZon[Len( aColsZon )][ 3 ] := aArrayZona[nX][3]
			aColsZon[Len( aColsZon )][ 4 ] := aArrayZona[nX][4]
			aColsZon[Len( aColsZon )][ 5 ] := aArrayZona[nX][5]			
			aColsZon[Len( aColsZon )][Len( aHedeZon ) + 1] := .F.				
		Next nX
	Endif	
	
	//Popula browse Setores
	If Len( aArraySetor ) > 0
		For nX := 1 To Len( aArraySetor )
			aAdd( aColsSet, Array( Len( aHedeSet ) + 1 ) )
			aColsSet[Len( aColsSet )][ 1 ] := 'BR_VERDE'
			aColsSet[Len( aColsSet )][ 2 ] := 'LBNO'
			aColsSet[Len( aColsSet )][ 3 ] := aArraySetor[nX][3]
			aColsSet[Len( aColsSet )][ 4 ] := aArraySetor[nX][4]
			aColsSet[Len( aColsSet )][ 5 ] := aArraySetor[nX][5]
			aColsSet[Len( aColsSet )][ 6 ] := aArraySetor[nX][6]			
			aColsSet[Len( aColsSet )][Len( aHedeSet ) + 1] := .F.				
		Next nX
	Endif	
	
Return




/***
 * Função responsável buscar vinculos da rota, zonas, setores
 */
Static Function oms22rot( cTipo, nOpc )

	//Local lBlqCred := .F. as logical
	//Local lBlqEst  := .F. as logical
	local nY := 0 as Numeric
	local nX := 0 as Numeric
	local nP := 0 as numeric
	local nTotVlr := 0
	local nTotPes := 0
	local nTotVol := 0


	Do Case
		Case cTipo == "ROTAS" 
			oBrowRot:aCOLS[oBrowRot:nAt,2] := Iif( oBrowRot:aCOLS[oBrowRot:nAt,2] == 'LBOK', 'LBNO', 'LBOK' )
			
			//Atualiza Zona
			For nY := 1 To Len( oBrowZon:aCOLS ) 
				If oBrowZon:aCOLS[nY][3] == oBrowRot:aCOLS[oBrowRot:nAt,3]  
					oBrowZon:aCOLS[nY][2] := oBrowRot:aCOLS[oBrowRot:nAt,2] //Iif( oBrowZon:aCOLS[nY][2] == 'LBOK', 'LBNO', 'LBOK' )	
				Endif 
			Next nY	
			oBrowZon:oBrowse:Refresh()
			
			//AAdd( aArrayPed,{ cCodRota, cZona, cSetor, cSeqRota, ( cAlSC9 )->C9_PEDIDO, ( cAlSC9 )->C9_ITEM, ( cAlSC9 )->C9_SEQUEN,  cAlSC9 )->C9_CLIENTE,  cAlSC9 )->C9_LOJA } )
			//Atualiza Setores
			For nY := 1 To Len( oBrowSet:aCOLS ) 
				If oBrowSet:aCOLS[nY][3] == oBrowRot:aCOLS[oBrowRot:nAt,3]  
					oBrowSet:aCOLS[nY][2] := oBrowRot:aCOLS[oBrowRot:nAt,2] //Iif( oBrowSet:aCOLS[nY][2] == 'LBOK', 'LBNO', 'LBOK' )	
				Endif 
			Next nY	
			oBrowSet:oBrowse:Refresh()
			
		Case cTipo == "ZONAS"
			oBrowZon:aCOLS[oBrowZon:nAt,2] := Iif( oBrowZon:aCOLS[oBrowZon:nAt,2] == 'LBOK', 'LBNO', 'LBOK' )
			
			//Atualiza Rotas
			For nY := 1 To Len( oBrowRot:aCOLS ) 
				If oBrowRot:aCOLS[nY][3] == oBrowZon:aCOLS[oBrowZon:nAt,3]  
					oBrowRot:aCOLS[nY][2] := oBrowZon:aCOLS[oBrowZon:nAt,2] //Iif( oBrowRot:aCOLS[nY][2] == 'LBOK', 'LBNO', 'LBOK' )	
				Endif 
			Next nY	
			oBrowRot:oBrowse:Refresh()
			
			//Atualiza Setores
			For nY := 1 To Len( oBrowSet:aCOLS ) 
				If oBrowSet:aCOLS[nY][3] == oBrowZon:aCOLS[oBrowZon:nAt,3]  
					oBrowSet:aCOLS[nY][2] := oBrowZon:aCOLS[oBrowZon:nAt,2] //Iif( oBrowSet:aCOLS[nY][2] == 'LBOK', 'LBNO', 'LBOK' )	
				Endif 
			Next nY	
			oBrowSet:oBrowse:Refresh()
		
		Case cTipo == "SETORES"
			oBrowSet:aCOLS[oBrowSet:nAt,2] := Iif( oBrowSet:aCOLS[oBrowSet:nAt,2] == 'LBOK', 'LBNO', 'LBOK' )
			
			//Atualiza Rotas
			For nY := 1 To Len( oBrowRot:aCOLS ) 
				If oBrowRot:aCOLS[nY][3] == oBrowSet:aCOLS[oBrowSet:nAt,3] 
					oBrowRot:aCOLS[nY][2] := oBrowSet:aCOLS[oBrowSet:nAt,2] //Iif( oBrowRot:aCOLS[nY][2] == 'LBOK', 'LBNO', 'LBOK' )	
				Endif 
			Next nY	
			oBrowRot:oBrowse:Refresh()
			
			//Atualiza Zonas
			For nY := 1 To Len( oBrowZon:aCOLS ) 
				If oBrowZon:aCOLS[nY][3] == oBrowSet:aCOLS[oBrowSet:nAt,3]  
					oBrowZon:aCOLS[nY][2] := oBrowSet:aCOLS[oBrowSet:nAt,2] //Iif( oBrowZon:aCOLS[nY][2] == 'LBOK', 'LBNO', 'LBOK' )	
				Endif 
			Next nY	
			oBrowZon:oBrowse:Refresh()		
	EndCase
	
	//Atualiza Totais e Pedidos 
	//oBtnWFC:lActive := .F.
	//oBtnWFE:lActive := .F.
	nTotVlr := 0
	nTotPes := 0
	nTotVol := 0
	aColsPed := {}
	aColsCar := {}
	For nX := 1 To Len( oBrowSet:aCOLS )
		If oBrowSet:aCOLS[nX][2] == 'LBOK' 
			For nP := 1 To Len( aArrayPed )
				conOut( 'Rota PD: '+  aArrayPed[nP][15] + ' - Rota Marcada: '+oBrowSet:aCOLS[nX][3] )
				conOut( 'Zona PD: '+  aArrayPed[nP][16] + ' - Zona Marcada: '+oBrowSet:aCOLS[nX][4] )
				conOut( 'Setor PD: '+  aArrayPed[nP][17] + ' - Setor Marcado: '+oBrowSet:aCOLS[nX][5] )
				If aArrayPed[nP][15] == oBrowSet:aCOLS[nX][3] .And. aArrayPed[nP][16] == oBrowSet:aCOLS[nX][4] .And. aArrayPed[nP][17] == oBrowSet:aCOLS[nX][5]
					aAdd( aColsPed, Array( Len( aHedePed ) + 1 ) )
					
					//Do Case
					//	Case aArrayPed[nP][1] == 'BR_AZUL'
					//		lBlqCred := .T.
					//	Case aArrayPed[nP][1] == 'BR_PRETO'
					//		lBlqEst := .T. 
					//EndCase
					
					//Verifica totalizador saldo insuficiente 
					nPos := Ascan( aTotDisp,{|x| x[1] == aArrayPed[nP][6] } )
					If nPos > 0
						If ( aArrayPed[nP][23] - aTotDisp[nPos][2] ) < 0 .and. nOpc == 3
							aArrayPed[nP][1] := 'BR_PRETO'
							//lBlqEst := .T.									
						Endif
					Endif
			
					aColsPed[Len( aColsPed )][ 1 ] := aArrayPed[nP][1]
					aColsPed[Len( aColsPed )][ 2 ] := aArrayPed[nP][2]
					aColsPed[Len( aColsPed )][ 3 ] := aArrayPed[nP][3]
					aColsPed[Len( aColsPed )][ 4 ] := aArrayPed[nP][4]
					aColsPed[Len( aColsPed )][ 5 ] := aArrayPed[nP][5]
					aColsPed[Len( aColsPed )][ 6 ] := aArrayPed[nP][6]
					aColsPed[Len( aColsPed )][ 7 ] := aArrayPed[nP][7]
					aColsPed[Len( aColsPed )][ 8 ] := aArrayPed[nP][8]
					aColsPed[Len( aColsPed )][ 9 ] := aArrayPed[nP][9]
					aColsPed[Len( aColsPed )][ 10 ] := aArrayPed[nP][10]
					aColsPed[Len( aColsPed )][ 11 ] := aArrayPed[nP][11]
					aColsPed[Len( aColsPed )][ 12 ] := aArrayPed[nP][12]
					aColsPed[Len( aColsPed )][ 13 ] := aArrayPed[nP][21]
					aColsPed[Len( aColsPed )][ 14 ] := aArrayPed[nP][19]
					// ADD IGOR
					IF aArrayPed[nP][1] == "BR_PRETO" .or. aArrayPed[nP][1] == "BR_PINK"
					   aColsPed[Len( aColsPed )][ 15 ] := 0
					else
					  aColsPed[Len( aColsPed )][ 15 ] := aArrayPed[nP][22]
					EndIF //ADD IGOR FIM
					aColsPed[Len( aColsPed )][ 16 ] := aArrayPed[nP][23]
					aColsPed[Len( aColsPed )][ 17 ] := aArrayPed[nP][24]

					// ADD ALEXANDRE TRELAC 
					aColsPed[Len( aColsPed )][ 18 ] := aArrayPed[nP][25]
					aColsPed[Len( aColsPed )][ 19 ] := aArrayPed[nP][26]
					aColsPed[Len( aColsPed )][ 20 ] := aArrayPed[nP][27]
					aColsPed[Len( aColsPed )][ 21 ] := aArrayPed[nP][28]
					aColsPed[Len( aColsPed )][ 22 ] := aArrayPed[nP][29]
					// FIM ALEXANDRE TRELAC 
																					
					aColsPed[Len( aColsPed )][Len( aHedePed ) + 1] := .F.  
					
					// nTotVlr 	+= aArrayPed[nP][11]			
					// nTotPes 	+= aArrayPed[nP][12]
					// nTotVol 	+= 0 //aArrayPed[nP][12]
					// nTotQtdLib 	+= aArrayPed[nP][19]
				Endif	
			Next nP	
		Endif			
	Next nX
	
	// If cTipo == "0"
	// 	nTotVlr := 0
	// 	nTotPes := 0
	// 	nTotVol := 0
	// 	For nP := 1 To Len( oBrowPed:aCols ) 
	// 		If oBrowPed:aCols[nP][14] > 0 
	// 			nTotVlr += oBrowPed:aCols[nP][10]
	// 			nTotPes += oBrowPed:aCols[nP][11]
	// 			nTotVol += 0 //oBrowPed:aCols[nP][12]	
	// 		//Else
	// 		//	nTotVlr -= oBrowPed:aCols[nP][10]
	// 		//	nTotPes -= oBrowPed:aCols[nP][11]
	// 		//	nTotVol -= oBrowPed:aCols[nP][12]			
	// 		Endif
	// 	Next nP
	// 	If M->C6_QTDLIB <= 0
	// 		nTotVlr -= oBrowPed:aCOLS[oBrowPed:oBrowse:nAt,10]
	// 		nTotPes -= oBrowPed:aCOLS[oBrowPed:oBrowse:nAt,11]
	// 		nTotVol -= 0 //oBrowPed:aCOLS[oBrowPed:oBrowse:nAt,12]
	// 	Endif
	// Endif

	aAdd( aColsCar, Array( Len( aHedeCar ) + 1 ) )
	aColsCar[Len( aColsCar )][ 1 ] := 'BR_VERDE'
	aColsCar[Len( aColsCar )][ 2 ] := nTotVlr
	aColsCar[Len( aColsCar )][ 3 ] := nTotPes
	aColsCar[Len( aColsCar )][ 4 ] := nTotVol
	aColsCar[Len( aColsCar )][Len( aHedeCar ) + 1] := .F.
	
	oBrowCar:oBrowse:SetArray( aColsCar )
	oBrowCar:aCols := aColsCar	
	oBrowCar:oBrowse:Refresh()
	
	//Ordena pedidos conforme status
	aColsPed  := aSort( aColsPed,,,{|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+x[4] } )
	
	oBrowPed:oBrowse:SetArray( aColsPed )
	oBrowPed:aCols := aColsPed		
	oBrowPed:oBrowse:Refresh()	
	
	//Habilita botao WF
	//If lBlqCred
		//oBtnWFC:lActive := .T.	
	//Endif
	//If lBlqEst
		//oBtnWFE:lActive := .T.
	//Endif 
	
Return


/***
 * Função responsável por enviar WF liberacao estoque
 */
 Static Function oms22WFE
 	Local oP, oHtml  
	Local cMV_WFDIR  	:= AllTrim( GetMV( "MV_WFDIR" ) )  // Diretorio de trabalho do Workflow
	Local cArqHtml  	:= cMV_WFDIR +"\wfomscrd2.htm" 
	local nX            := 0 as numeric
	
	If oms22telwf( 'ESTOQUE' )
	
		//Funcoes para envio de HTML
		oP := TWFProcess():New('PEDCOM','WF Liberacao Estoque')
		oP:NewTask( 'Inicio',cArqHtml  )
		oHtml   := oP:oHtml 
		
		oHtml:ValByName( "it.pedido" 		, {} )
		oHtml:ValByName( "it.cliente" 		, {} )
		oHtml:ValByName( "it.item"    		, {} )  
		oHtml:ValByName( "it.produto"  		, {} )
		oHtml:ValByName( "it.qtde"  		, {} )
		oHtml:ValByName( "it.valor"  		, {} )
		oHtml:ValByName( "it.total"    		, {} )
		oHtml:ValByName( "it.data"  		, {} )
	
		For nX := 1 To Len( oBrowPed:aCOLS )
			If oBrowPed:aCOLS[nX][1] == 'BR_PRETO'
				nPos := Ascan( aArrayPed,{|x| x[2] == oBrowPed:aCOLS[nX][2] .And. x[3] == oBrowPed:aCOLS[nX][3]  } )	
				If nPos > 0 	
					aadd(oHtml:ValByName("it.pedido"	) 	, oBrowPed:aCOLS[nX][2] )
					aadd(oHtml:ValByName("it.cliente"	) 	, AllTrim( oBrowPed:aCOLS[nX][7] )+" - "+ oBrowPed:aCOLS[nX][9] )
					aadd(oHtml:ValByName("it.item"		) 	, oBrowPed:aCOLS[nX][3] )
					aadd(oHtml:ValByName("it.produto"	) 	, AllTrim( oBrowPed:aCOLS[nX][5] )+" - "+ oBrowPed:aCOLS[nX][6] )
					aadd(oHtml:ValByName("it.qtde"		) 	, TRANSFORM( aArrayPed[nPos][18] ,PesqPict( "SC6", "C6_QTDVEN" ) ) )
					aadd(oHtml:ValByName("it.valor"		) 	, TRANSFORM( aArrayPed[nPos][19] ,PesqPict( "SC6", "C6_PRCVEN" ) ) )
					aadd(oHtml:ValByName("it.total"		) 	, TRANSFORM( oBrowPed:aCOLS[nX][10] ,PesqPict( "SC6", "C6_VALOR" ) ) )
					aadd(oHtml:ValByName("it.data"		) 	, DTOC( STOD( aArrayPed[nPos][20] ) ) ) 	
				Endif
			Endif
		Next nX  
		
		//envia o e-mail
		cUser := Subs( cUsuario,7,15 )
		oP:ClientName( cUser )
		oP:cTo := cGetEmail
		If !Empty( cGetEmAd )
			oP:cCC := cGetEmAd 
		Endif 
		subj := "WF Liberação Estoque"
		oP:cSubject := subj
		oP:Start( )
		
		//Envia Simulacao
		oms22SIM( )
 	
 		MsgAlert( "Workflow enviado!","ATENCAO" )
 		
 		//oBtnWFE:lActive := .F.
 	Endif
 	
 Return
 
 
 
 
 /***
 * Função responsável por enviar WF simulacao
 */
 Static Function oms22SIM
 	Local oP, oHtml
	Local cMV_WFDIR := AllTrim( GetMV( "MV_WFDIR" ) ) // Diretorio de trabalho do Workflow
	Local cArqHtml  := cMV_WFDIR +"\wfomscrd3.htm"
	Local cEmaSim   := AllTrim( GetMV( "MV_X_ACRG3" ) )
	local nY        := 0 as numeric
	local nW        := 0 as numeric
	local nZ        := 0 as numeric
	local nX        := 0 as numeric
	
	//Funcoes para envio de HTML
	oP := TWFProcess():New('PEDCOM','WF Simulacao')
	oP:NewTask( 'Inicio',cArqHtml  )
	oHtml   := oP:oHtml

	oHtml:ValByName( "tt.valor"			, {} )
	oHtml:ValByName( "tt.peso" 			, {} )
	oHtml:ValByName( "tt.volume" 		, {} )
	oHtml:ValByName( "it.rota" 			, {} )
	oHtml:ValByName( "it.descrota" 		, {} )
	oHtml:ValByName( "zo.zonas" 		, {} )
	oHtml:ValByName( "zo.desczonas"		, {} )	
	oHtml:ValByName( "st.setores" 		, {} )
	oHtml:ValByName( "st.descsetores"	, {} )	
	oHtml:ValByName( "pd.pedido" 		, {} )
	oHtml:ValByName( "pd.cliente" 		, {} )
	oHtml:ValByName( "pd.item"    		, {} )
	oHtml:ValByName( "pd.produto"  		, {} )
	oHtml:ValByName( "pd.qtde"  		, {} )
	oHtml:ValByName( "pd.valor"  		, {} )
	oHtml:ValByName( "pd.total"    		, {} )
	oHtml:ValByName( "pd.data"  		, {} )
	
	//Alimenta Rotas
	For nY := 1 To Len( oBrowCar:aCOLS )
		aadd(oHtml:ValByName("tt.valor"	) 	, TRANSFORM( oBrowCar:aCOLS[nY][2] ,PesqPict( "SC6", "C6_VALOR" ) ) )
		aadd(oHtml:ValByName("tt.peso"	) 	, TRANSFORM( oBrowCar:aCOLS[nY][3] ,PesqPict( "DAK", "DAK_PESO" ) ) )
		aadd(oHtml:ValByName("tt.volume") 	, TRANSFORM( oBrowCar:aCOLS[nY][4] ,PesqPict( "SC9", "C9_QTDLIB" ) ) )	
	Next nY
	
	//Alimenta Rotas
	For nY := 1 To Len( oBrowRot:aCOLS )
		If oBrowRot:aCOLS[nY][2] == 'LBOK'
			aadd(oHtml:ValByName("it.rota"	) 		, oBrowRot:aCOLS[nY][3] )
			aadd(oHtml:ValByName("it.descrota"	) 	, oBrowRot:aCOLS[nY][4] )
		Endif	
	Next nY
	
	
	//Alimenta Zonas
	For nW := 1 To Len( oBrowZon:aCOLS )
		If oBrowZon:aCOLS[nW][2] == 'LBOK'
			aadd(oHtml:ValByName("zo.zonas"	) 		, oBrowZon:aCOLS[nW][4] )
			aadd(oHtml:ValByName("zo.desczonas"	) 	, oBrowZon:aCOLS[nW][5] )
		Endif	
	Next nW
	
	
	//Alimenta Setores
	For nZ := 1 To Len( oBrowSet:aCOLS )
		If oBrowSet:aCOLS[nZ][2] == 'LBOK'
			aadd(oHtml:ValByName("st.setores"		) 	, oBrowSet:aCOLS[nZ][5] )
			aadd(oHtml:ValByName("st.descsetores"	) 	, oBrowSet:aCOLS[nZ][6] )
		Endif	
	Next nZ
	
	
	//Alimenta Pedidos		
	For nX := 1 To Len( oBrowPed:aCOLS )
		nPos := Ascan( aArrayPed,{|x| x[2] == oBrowPed:aCOLS[nX][2] .And. x[3] == oBrowPed:aCOLS[nX][3]  } )
		If nPos > 0
			aadd(oHtml:ValByName("pd.pedido"	) 	, oBrowPed:aCOLS[nX][2] )
			aadd(oHtml:ValByName("pd.cliente"	) 	, AllTrim( oBrowPed:aCOLS[nX][7] )+" - "+ oBrowPed:aCOLS[nX][9] )
			aadd(oHtml:ValByName("pd.item"		) 	, oBrowPed:aCOLS[nX][3] )
			aadd(oHtml:ValByName("pd.produto"	) 	, AllTrim( oBrowPed:aCOLS[nX][5] )+" - "+ oBrowPed:aCOLS[nX][6] )
			aadd(oHtml:ValByName("pd.qtde"		) 	, TRANSFORM( aArrayPed[nPos][18] ,PesqPict( "SC6", "C6_QTDVEN" ) ) )
			aadd(oHtml:ValByName("pd.valor"		) 	, TRANSFORM( aArrayPed[nPos][19] ,PesqPict( "SC6", "C6_PRCVEN" ) ) )
			aadd(oHtml:ValByName("pd.total"		) 	, TRANSFORM( oBrowPed:aCOLS[nX][10] ,PesqPict( "SC6", "C6_VALOR" ) ) )
			aadd(oHtml:ValByName("pd.data"		) 	, DTOC( STOD( aArrayPed[nPos][20] ) ) )
		Endif
	Next nX
			
	//envia o e-mail
	cUser := Subs( cUsuario,7,15 )
	oP:ClientName( cUser )
	oP:cTo := cEmaSim
	subj := "WF Simulacao"
	oP:cSubject := subj
	oP:Start( )
 		
 Return
 
 
 
 
 /***
 * Tela para envio dos workflows
 */
 Static Function oms22telwf( cTipo )
 	Local lRet := .T.
 	
 	cGetEmAd   := Space( 250 )
	cGetEmail  := Space( 250 )

 	Do Case
		Case cTipo == 'CREDITO'
			cGetEmail := AllTrim( GetMV( "MV_X_ACRG1" ) )
		Case cTipo == 'ESTOQUE'  
			cGetEmail := AllTrim( GetMV( "MV_X_ACRG2" ) )	
 	EndCase
 	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oFont10","oDlg1","oSay1","oSay2","oGetEmail","oGetEmAd","oBtnEnv","oBtnCan")
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oFont10    := TFont():New( "Tahoma",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
	oDlg1      := MSDialog():New( 092,232,233,630,"Workflow email",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 008,008,{||"E-mail:"},oDlg1,,oFont10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay2      := TSay():New( 029,009,{||"E-mail Adicional:"},oDlg1,,oFont10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
	oGetEmail  := TGet():New( 004,060,{|u| If(PCount()>0,cGetEmail:=u,cGetEmail)},oDlg1,125,010,'',,CLR_BLACK,CLR_WHITE,oFont10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetEmail",,)
	oGetEmail:Disable()
	oGetEmAd   := TGet():New( 024,060,{|u| If(PCount()>0,cGetEmAd:=u,cGetEmAd)},oDlg1,125,010,'',,CLR_BLACK,CLR_WHITE,oFont10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetEmAd",,)
	oBtnEnv    := TButton():New( 044,040,"Enviar",oDlg1,{||  nOpcao := 1, oDlg1:End()  },050,012,,oFont10,,.T.,,"",,,,.F. )
	oBtnCan    := TButton():New( 044,104,"Cancelar",oDlg1,{|| nOpcao := 2, oDlg1:End() },050,012,,oFont10,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
	
	If nOpcao == 2
		lRet := .F.	
	Endif 

Return lRet



//add legenda de cada item
 /***
 * Atualiza status dos pedidos ja selecionados
 */

 
/// add legendas F 
 Static Function oms22RFH( )
	
	local nX := 0 as numeric

 	If Len( oBrowPed:aCOLS ) > 0
 		For nX := 1 To Len( oBrowPed:aCOLS )
 			dbSelectArea( "SC9" )
 			SC9->( dbSetOrder( 1 ) )
 			SC9->( dbGoTop( ) )
 			If dbSeek( xFilial( "SC9" )+oBrowPed:aCOLS[nX][2]+oBrowPed:aCOLS[nX][3]+oBrowPed:aCOLS[nX][4]+oBrowPed:aCOLS[nX][5] )
		 		Do Case 
					Case oBrowPed:aCOLS[nX][1] == 'BR_AZUL'
						If Empty( SC9->C9_BLCRED ) .And. Empty( SC9->C9_BLEST )
							oBrowPed:aCOLS[nX][1] := 'BR_VERDE' 
						Endif 
					Case oBrowPed:aCOLS[nX][1] == 'BR_PRETO'
						If Empty( SC9->C9_BLEST ) .And.  Empty( SC9->C9_BLCRED ) 
							oBrowPed:aCOLS[nX][1] := 'BR_VERDE' 
						Endif
				
				EndCase			
 			Endif
 		Next nX 	
 		oBrowPed:oBrowse:Refresh() 			
 	Else
 		MsgAlert( "Não ha dados para atualizar status","ATENCAO" )
 	Endif
 Return
 
 
 
 
  /***
 * Atualiza SC9 COM A AIMULAÇÃO GERADA PELA RESERVA
 */
/*/{Protheus.doc} oms22SC9
Função que grava simulação da carga com base nos pedidos selecionados
@type function
@version 1.0	
@author Igor
@since 14/02/2022
@return logical, lSuccess
/*/ 
Static Function oms22SC9()
 
Local cGetLib  := SPACE(TamSX3("ZN1_SIMULA")[1])
Local cNumSimul
local nX       := 0 as numeric
local lSuccess := .T. as logical
local lTemPed  := .F. as logical

cGetLib     := GETSXENUM("ZN1","ZN1_SIMULA")
ConfirmSX8()		
cNumSimul    := cGetLib

//MsgInfo(cNumSimul, "NUMERO SIMULACAO")

//ADICIONAR AQUI REGRA PARA GRAVAR C5_X_SIMUL #ICMAIS
BEGIN TRANSACTION

	DBSelectArea( "ZN1" )
	ZN1->( DBSetOrder( 1 ) )		// ZN1_FILIAL + ZN1_SIMULA
	if ! ZN1->( DBSeek( FWxFilial( "ZN1" ) + cNumSimul ) )
		RecLock( "ZN1", .T. )
		ZN1->ZN1_FILIAL  := FWxFilial( "ZN1" )
		ZN1->ZN1_SIMULA  := cNumSimul
		ZN1->ZN1_EMISS   := dDataBase
		ZN1->ZN1_REVISA  := 0
		ZN1->( MsUnlock() )
	else
		lSuccess := .F.
		DisarmTransaction()
	endif  

	if lSuccess

		For nX := 1 To Len( oBrowPed:aCOLS )

			if oBrowPed:aCOLS[nX][2] == 'LBOK'
				
				lTemPed := .T.
				dbSelectArea("SC9")
				SC9->( dbSetOrder( 2 ) ) 
				SC9->( dbGoTop( ) )
				If  dbSeek( xFilial("SC9")+oBrowPed:aCOLS[nX][8]+oBrowPed:aCOLS[nX][9]+oBrowPed:aCOLS[nX][3]+oBrowPed:aCOLS[nX][4] )

					dbSelectArea("SC6")
					SC6->( dbSetOrder( 1 ) )
					SC6->( dbGoTop( ) )
					If dbSeek( xFilial("SC6")+SC9->( C9_PEDIDO+C9_ITEM+C9_PRODUTO ) )	
				
						// GRAVO NUMERO SC9
						Reclock("SC9",.F.)
						SC9->C9_BLEST  := "SP"
						SC9->C9_X_SIMUL := cNumSimul
						SC9->(MsUnLock())

						dbSelectArea("SC5")
						SC5->( dbSetOrder( 1 ) ) 
						SC5->( dbGoTop( ) )
						if  dbSeek( xFilial("SC5") + SC9-> ( C9_PEDIDO) )
							Reclock("SC5",.F.)
							SC5->C5_X_SIMUL  := cNumSimul
							SC5->(MsUnLock())
						endif

					endif  
				endif

			endif

		Next nX

		// Caso o usuário não tenha marcado nenhum pedido, desfaz a transação para evitar a gravação desnecessáriade registros
		if ! lTemPed
			MsgStop( "A gravação será CANCELADA pois é necessária a seleção de ao menos um pedido para criar uma simulação de carga!", "F A L H A" )
			lSuccess := .F.
			DisarmTransaction()
		endif

	endif 
END TRANSACTION	

//MSGINFO( "Simulação Numero: "+ " " + cNumSimul  + Chr(13) + Chr(10) + "Diparado Workflow separação !! " ) 
if lSuccess
	MSGINFO( "Simulação Número: "+ " " + cNumSimul ) 
endif
oDlg:End()
 
Return lSuccess

/*/{Protheus.doc} marcaped
Função para executar marcação no grid de pedidos
@type function
@version 1.0 
@author Igor
@since 12/02/2022
@param lAllItems, logical, indica se deve marcar todos os itens do pedido ao mesmo tempo (opcional)
@param lAllOrders, logical, indica se deve marcar todos os pedidos do grid ao mesmo tempo (opcional)
/*/
Static Function marcaped( lAllItems, lAllOrders )

	local nX := 0 as Numeric
	local cMark := "" as character
	local cOrder := "" as character
	local nTotVlr := 0 as numeric
	local nTotPes := 0 as numeric
	local aHeader := {} as array
	local nPosPes := 0 as numeric
	local nPosPrc := 0 as numericS

	default lAllItems  := .F.
	default lAllOrders := .F.

	aHeader := oBrowPed:aHeader
	nPosPes := aScan( aHeader, {|x| AllTrim( x[2] ) == 'C5_PESOL'  } )
	nPosPrc := aScan( aHeader, {|x| AllTrim( x[2] ) == 'C6_PRCVEN' } )

	// Marca/Desmarca todos os pedidos
	if lAllOrders

		if len( oBrowPed:aCOLS ) > 0
			for nX := 1 to len( oBrowPed:aCOLS )
				if oBrowPed:aCOLS[nX][2] == "LBNO" .AND. ! ( AllTrim( oBrowPed:aCOLS[nX][1] ) $ "BR_PINK/BR_PRETO/BR_AZUL" )		// Bloqueio gerencial, saldo insuficiente ou bloqueio financeiro
					// Se a marca ainda estiver vazia, vê o status do primeiro registro pra saber se deve marcar todos ou desmarcar todos
					if Empty( cMark )
						cMark := Iif( oBrowPed:aCOLS[nX][2] == 'LBOK', 'LBNO', 'LBOK' )
					endif
					oBrowPed:aCOLS[nX][2] := cMark
				elseif oBrowPed:aCols[nX][2] == "LBOK" .and. ! ( AllTrim( oBrowPed:aCOLS[nX][1] ) $ "BR_PINK/BR_PRETO/BR_AZUL" )
					if Empty( cMark )
						cMark := Iif( oBrowPed:aCOLS[nX][2] == 'LBOK', 'LBNO', 'LBOK' )
					endif
					oBrowPed:aCOLS[nX][2] := cMark
				endif
			next nX
		endif

	elseif lAllItems

		cOrder := oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][3]
		cMark := iif( oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][2] == "LBNO", "LBOK", "LBNO" )
		if len( oBrowPed:aCOLS ) > 0
			
			for nX := 1 to len( oBrowPed:aCOLS )
				
				// Verifica se o item do grid se refere ao pedido selecionado pelo usuário
				if oBrowPed:aCOLS[nX][3] == cOrder
					
					// Informa ao usuário que não é possível marcar o pedido pois o mesmo se encontr com bloqueio gerencial
					if oBrowPed:aCOLS[nX,2] == "LBNO" .and. cMark == "LBOK"
						if oBrowPed:aCOLS[nX][1] == "BR_PINK"		// Bloqueio gerencial
							Help( ,, 'Bloqueio gerencial',, "O pedido "+ cOrder +" está bloqueado aguardando análise gerencial!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
										{ 'Pedidos nessa situação não podem ser vinculados a uma carga. Solicite a liberação ou aguarde até que a análise seja realizada para poder prosseguir.' } )
							return nil
						elseif oBrowPed:aCOLS[nX][1] == "BR_PRETO"	// Estoque insuficiente
							Help( ,, 'Estoque insuficiente',, "O pedido "+ cOrder +" está com estoque insuficiente!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
										{ 'Verifique o saldo em estoque para os produtos e faça as adequações necessárias, depois tente novamente.' } )
							return nil
						elseif oBrowPed:aCOLS[nX][1] == "BR_AZUL"	// Análise financeira
							Help( ,, 'Bloqueio de crédito',, "O pedido "+ cOrder +" está com bloqueio de crédito!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
										{ 'Verifique com a equipe responsável e, assim que o pedido for liberado, tente novamente.' } )
							return nil
						endif
						
					endif
					oBrowPed:aCOLS[nX][2] := cMark
				
				endif

			next nX

		endif

	else

		// Informa ao usuário que não é possível marcar o pedido pois o mesmo se encontr com bloqueio gerencial
		if oBrowPed:aCOLS[oBrowPed:oBrowse:nAt,2] == "LBNO" 
			if oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][1] == "BR_PINK"		// Bloqueio gerencial
				Help( ,, 'Bloqueio gerencial',, "O pedido "+ oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][3] +" está bloqueado aguardando análise gerencial!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
							{ 'Pedidos nessa situação não podem ser vinculados a uma carga. Solicite a liberação ou aguarde até que a análise seja realizada para poder prosseguir.' } )
				return nil
			elseif oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][1] == "BR_PRETO"	// Estoque insuficiente
				Help( ,, 'Estoque insuficiente',, "O pedido "+ oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][3] +" está com estoque insuficiente!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
							{ 'Verifique o saldo em estoque para os produtos e faça as adequações necessárias, depois tente novamente.' } )
				return nil
			elseif oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][1] == "BR_AZUL"	// Análise financeira
				Help( ,, 'Bloqueio de crédito',, "O pedido "+ oBrowPed:aCOLS[oBrowPed:oBrowse:nAt][3] +" está com bloqueio de crédito!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
							{ 'Verifique com a equipe responsável e, assim que o pedido for liberado, tente novamente.' } )
				return nil
			endif
		endif

		//MsgInfo("Linha " + Str(oBrowPed:oBrowse:nAt), "TESTE")
		oBrowPed:aCOLS[oBrowPed:oBrowse:nAt,2] := Iif( oBrowPed:aCOLS[oBrowPed:oBrowse:nAt,2] == 'LBOK', 'LBNO', 'LBOK' )	
		oBrowPed:oBrowse:Refresh()

	endif

	// ADD JEAN - Atualizaçao de peso e valor no grid do totalizador da carga
	aEval( oBrowPed:aCOLS, {|x| iif( x[2] == 'LBOK', nTotVlr += x[nPosPrc], Nil ), iif( x[2] == 'LBOK', nTotPes += x[nPosPes], Nil )  } )

	oBrowCar:aCols[Len( oBrowCar:aCols )][ 2 ] := nTotVlr
	oBrowCar:aCols[Len( oBrowCar:aCols )][ 3 ] := nTotPes
	oBrowCar:oBrowse:Refresh()
	// ADD JEAN 

Return
