#include "rwmake.ch"
#include "protheus.ch"
#include 'fwmvcdef.ch'
#include 'totvs.ch'
#Include "topconn.ch"

/*/{Protheus.doc} User Function ICLOG001
    Tela manutencao simulacao carga
    @type  Function
    @author ICMAIS
    @since 12/12/2021
    @version 1.0
/*/
User Function ICLOG001()

	Local aArea     := GetArea()
	Local aPergs    := {}
	//local aCombo    := {"SIM","NAO"}
	Local dDataIni  := dDataBase-15
	Local dDataFim  := dDataBase+7
	Local lCanSave  := .T.
	Local lUserSave := .T.

	Private aMvPar  := {}

	aAdd(aPergs,{1,"Embarque de"   ,dDataIni,"","","","",50,.F.})
	aAdd(aPergs,{1,"Embarque at�"  ,dDataFim,"","","","",50,.F.})
	//aAdd(aPergs,{1,"Data separa��o De"  ,dDataIni,"","","","",50,.T.})
	//aAdd(aPergs,{1,"Data separa��o At�" ,dDataFim,"","","","",50,.T.})
	//aAdd(aPergs,{2,"Mostrar associados?", 1, aCombo, 100,"", .T. } )

	If ParamBox(aPergs, "Informe os par�metros",,,,,,,,,lCanSave,lUserSave)
		GRVPARAM()

		runProc()
	EndIf

	RestArea(aArea)
Return

/*/{Protheus.doc} runProc
    Tela processamento
    @type Function
    @author ICMAIS
    @since 13/12/2021
    @version 1.0
/*/
Static Function runProc()

	Local oDlg  as object
	Local oSize as object
	Local nX    as numeric
	local cPicture := ""
	local cTitle   := ""

	Private cAliasTMP as string
	Private aStruct   as array

	aStruct := {}
	aadd(aStruct, {"C5_X_SIMUL", "C", TamSX3("C5_X_SIMUL")[01], TamSX3("C5_X_SIMUL")[02]})
	aAdd(aStruct, {"ZN1_EMISS" , "D", TamSX3("ZN1_EMISS" )[01], TamSX3("ZN1_EMISS" )[02]})
	aadd(aStruct, {"ZN1_DTSEP" , "D", TamSX3("ZN1_DTSEP")[01] , TamSX3("ZN1_DTSEP" )[02]})
	aadd(aStruct, {"ZN1_DTEMB" , "D", TamSX3("ZN1_DTEMB")[01] , TamSX3("ZN1_DTEMB" )[02]})
	aadd(aStruct, {"ZN1_HORA"  , "C", TamSX3("ZN1_HORA")[01]  , TamSX3("ZN1_HORA"  )[02]})
	aadd(aStruct, {"ZN1_VEICUL", "C", TamSX3("ZN1_VEICUL")[01], TamSX3("ZN1_VEICUL")[02]})
	aadd(aStruct, {"DA4_NREDUZ", "C", TamSX3("DA4_NREDUZ")[01], TamSX3("DA4_NREDUZ")[02]})
	aadd(aStruct, {"C9_CARGA"  , "C", TamSX3("C9_CARGA")[01]  , TamSX3("C9_CARGA"  )[02]})
	aadd(aStruct, {"ZN1_TRANSP", "C", TamSX3("ZN1_TRANSP")[01], TamSX3("ZN1_TRANSP")[02]})
	aAdd(aStruct, {"GERNFE"    , "C", 03                      , 00})

	//Set Columns
	aColumns := {}
	aFilter  := {}
	For nX := 01 To Len(aStruct)
		//Columns
		AAdd(aColumns,FWBrwColumn():New())
		aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
		aColumns[Len(aColumns)]:SetTitle(RetTitle(aStruct[nX][1]))
		aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
		aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
		
		// Seta picture do campo personalizado
		if aStruct[nX][01] == "GERNFE"
			cPicture := "@x"
			cTitle := "NFe"
			aColumns[Len(aColumns)]:SetTitle(cTitle)
		else
			cPicture := PesqPict("SC5",aStruct[nX][1])
			cTitle := RetTitle(aStruct[nX][1])
		endif
		aColumns[Len(aColumns)]:SetPicture( cPicture )

		//Filters
		aAdd(aFilter, {aStruct[nX][1], cTitle, aStruct[nX][2], aStruct[nX][3], aStruct[nX][4], cPicture} )
	Next nX

	//Instance of Temporary Table
	oTempTable := FWTemporaryTable():New()
	//Set Fields
	oTempTable:SetFields(aStruct)
	//Set Indexes
	oTempTable:AddIndex("INDEX1", {"C5_X_SIMUL"} )
	//Create
	oTempTable:Create()
	cAliasTMP := oTemptable:GetAlias()

	//Seleciona registros
	FWMsgRun(, {|| PROCREG() }, "Processando", "Selecionando registros...")

	aBrwSeek := {}
	aAdd( aBrwSeek , {"Simula��o",{{"","C" , 255 , 0 ,"","@!"}} } )

	// Calcula as dimensoes dos objetos
	oSize := FwDefSize():New( .F. ) // Com enchoicebar
	// Dispara o calculo
	oSize:Process()

	Define MsDialog oDlg Title 'SIMULA��O DE CARGA' From oSize:aWindSize[1],oSize:aWindSize[2] To oSize:aWindSize[3],oSize:aWindSize[4] Pixel //Style DS_MODALFRAME

	oBrowse:= FWMBrowse():New()
	oBrowse:SetOwner(oDlg)
	oBrowse:SetDescription("Monitor separa��o pedidos")
	oBrowse:SetAlias(cAliasTMP) //Temporary Table Alias
	oBrowse:SetMenuDef("iclog001")
	oBrowse:SetTemporary(.T.) //Using Temporary Table
	oBrowse:SetUseFilter(.T.) //Using Filter
	oBrowse:OptionReport(.F.) //Disable Report Print
	oBrowse:DisableDetails(.T.)
	oBrowse:AddLegend( "GERNFE == 'Sim' "   , "BR_AZUL"    , "Carga faturada" )
	oBrowse:AddLegend( "!Empty(C9_CARGA) "  , "BR_AMARELO" , "Carga gerada no OMS" )
	oBrowse:AddLegend( "Empty(ZN1_VEICUL) " , "BR_VERDE"   , "Sem associa��o de veiculo" )
	oBrowse:AddLegend( "!Empty(ZN1_VEICUL) ", "BR_VERMELHO", "Com associa��o de veiculo" )
	oBrowse:SetColumns(aColumns)
	oBrowse:SetFieldFilter(aFilter) //Set Filters
	oBrowse:SetSeek(.T.,aBrwSeek)
	oBrowse:Activate() //Caso deseje incluir em um componente de Tela (Dialog, Panel, etc), informar como par�metro o objeto

	oFWFilter := oBrowse:FWFilter()
	oFWFilter:DisableSave(.T.) //Disable Save Button

	Activate MsDialog oDlg

Return

/*/{Protheus.doc} LGLOG001
Fun��o para exibi��o do significado das legendas do browse
@type function
@version 1.0
@author Igor
@since 11/02/2022
/*/
User Function LGLOG001()

	Local cTitulo := OemtoAnsi("Legendas" )
	Local aCores  := {}

	aCores :=  {{ 'BR_VERDE'    , "Sem associa��o de ve�culo"  },;
				{ 'BR_VERMELHO' , "Com associa��o de ve�culo"  },;
				{ 'BR_AMARELO'  , "Carga gerada no OMS"        },;
				{ 'BR_AZUL'  	, "Carga faturada"             }}				

	BrwLegenda( cTitulo, "Legendas", aCores)
Return ( Nil )

/*/{Protheus.doc} PROCREG
    Seleciona os registros
    @type Function
    @author user
    @since 13/05/2021
    @version 1.0
/*/
Static Function PROCREG()

	Local nX := 0
	Local cQuery := ""
	Local cAliasQry := ""

	cAliasQry := GetNextAlias()

	//Query com os dados
	cQuery := "SELECT DISTINCT "
	cQuery += "SC5.C5_X_SIMUL, "
	cQuery += "ZN1.ZN1_EMISS, "
	cQuery += "ZN1.ZN1_DTSEP, "
	cQuery += "ZN1.ZN1_DTEMB, "
	cQuery += "ZN1.ZN1_HORA, "
	cQuery += "ZN1.ZN1_VEICUL, "
	cQuery += "COALESCE( DA4.DA4_NREDUZ, '"+ Space(TAMSX3("DA4_NREDUZ")[1]) +"' ) DA4_NREDUZ, "
	cQuery += "SC9.C9_CARGA AS C9_CARGA, "
	cQuery += "ZN1.ZN1_TRANSP AS ZN1_TRANSP, "
	cQuery += "CASE WHEN COALESCE(DAK.DAK_FEZNF,'2') = '1' THEN 'Sim' ELSE 'Nao' END GERNFE "
	cQuery += "FROM " + RetSqlName("ZN1") + " ZN1 "
	cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_FILIAL  = '"+ FWxFilial( "SC5" ) +"' AND SC5.C5_X_SIMUL = ZN1.ZN1_SIMULA AND SC5.D_E_L_E_T_ = ' ' "		// Cabe�alho do pedido
	cQuery += "INNER JOIN " + RetSqlName("SC9") + " SC9 ON SC9.C9_FILIAL  = '"+ FWxFilial( "SC9" ) +"' AND SC9.C9_PEDIDO = SC5.C5_NUM AND SC9.C9_X_SIMUL = SC5.C5_X_SIMUL  AND SC9.D_E_L_E_T_ = ' ' "		// Liga com itens liberados do pedido
	cQuery += "LEFT JOIN "+ RetSqlname( "DAK" ) + " DAK ON DAK.DAK_FILIAL = '"+ FWxFilial( "DAK" ) +"' AND DAK.DAK_COD = SC9.C9_CARGA AND DAK.D_E_L_E_T_ = ' ' "			// Cabe�alho da carga
	cQuery += "LEFT JOIN "+ retSqlname( "DA4" ) + " DA4 ON DA4.DA4_FILIAL = '"+ FWxFilial( "DA4" ) +"' AND DA4.DA4_COD = ZN1.ZN1_MOTORI AND DA4.D_E_L_E_T_ = ' ' "			// Cadastro de motorista
	cQuery += "WHERE ZN1.ZN1_FILIAL = '"+ FWxFilial( "ZN1" ) +"' "
	// 
	if ValType(mv_par01) == "D" .and. ValType(mv_par02) == "D"
		if !Empty(mv_par01) .or. !Empty(mv_par02)
			cQuery += "AND ZN1.ZN1_EMISS BETWEEN '"+ DTOS(mv_par01) +"' AND '"+ DTOS(mv_par02) +"' "
		endif
	endif
	cQuery += "  AND ZN1.D_E_L_E_T_ = ' '  "

	cQuery := ChangeQuery(cQuery)
	PlsQuery(cQuery, cAliasQry)

	DBSelectArea(cAliasTMP)
	(cAliasQry)->(DbGoTop())
	While !(cAliasQry)->(Eof())
		//Add Temporary Table
		If (RecLock(cAliasTMP, .T.))
			for nX := 1 to Len(aStruct)
				(cAliasTMP)->&(aStruct[nX][1]) := (cAliasQry)->&(aStruct[nX][1])
			next
			(cAliasTMP)->(MsUnlock())
		EndIf
		(cAliasQry)->(DBSkip())
	EndDo

	(cAliasTMP)->(DbGoTop())

Return

/*/{Protheus.doc} MenuDef
    Menu de opcoes
    @type Function
    @author DZ
    @since 17/11/2020
    @version 1.0
/*/
Static Function MenuDef()
	Local aRotDef := {}

	Add Option aRotDef Title '&Montar Simula��o' Action 'U_WWWWWW()' Operation 3 Access 0
	Add Option aRotDef Title '&Visualizar Simula��o' Action 'U_LSVISSIM()' Operation 2 Access 0
	Add Option aRotDef Title '&Wokflow separa��o' Action 'U_XXXXXX()' Operation 7 Access 0
	Add Option aRotDef Title '&Cancelar simula��o' Action 'U_YYYYY()' Operation 7 Access 0
	Add Option aRotDef Title '&Associar embarque' Action 'U_ICLG1ASS()' Operation 7 Access 0
	Add Option aRotDef TiTle '&Mapa de Carregamento' Action 'U_LSMPCAR()' Operation 7 Access 0
	Add Option aRotDef Title '&Adicionar Pedido Avulso' Action 'U_LSADDPED()' Operation 7 Access 0
    Add Option aRotDef Title '&Gerar Carga OMS' Action 'U_LSINTDAK' Operation 7 Access 0
	Add Option aRotDef Title '&Faturar Carga' Action 'U_LSFTCAR' Operation 7 Access 0
	Add Option aRotDef Title '&Legenda' Action 'U_LGLOG001' Operation 7 Access 0
	Add Option aRotDef Title 'Eliminar Vinculos Indevidos' Action 'U_LGREMSIM' Operation 7 Access 0 

Return(aRotDef)

/*/{Protheus.doc} LGREMSIM
Fun��o para desvincular pedidos de processos de simula��o de carga quando a simula��o n�o estiver gravada na ZN1
@type function
@version 1.0
@author Igor
@since 14/02/2022
/*/
user function LGREMSIM()

	local aArea := getArea()
	local cQuery := "" as character

	if MsgYesNo( "Deseja realmente limpar o conte�do dos campos da tabela de PEDIDOS e PEDIDOS LIBERADOS referente a simula��es de cargas que n�o estiverem gravadas na tabela ZN1?","Est� certo disso?" )
		
		DBSelectArea( "SC5" )
		SC5->( DBOrderNickName( "SIMULACAO" ) )

		cQuery := "SELECT C5_NUM FROM "+ RetSqlname( "SC5" ) + " C5 "
		cQuery += "WHERE C5.C5_FILIAL = '"+ FWxFilial( "SC5" ) +"' "
		cQuery += "  AND C5.C5_X_SIMUL <> '"+ Space( TAMSX3("C5_X_SIMUL")[1] ) +"' "
		cQuery += "  AND C5.C5_X_SIMUL NOT IN ( SELECT ZN1_SIMULA FROM "+ RetSqlName( "ZN1" ) +" WHERE ZN1_FILIAL = '"+ FWxFilial( "ZN1" ) +"' AND D_E_L_E_T_ = ' ' ) "
		cQuery += "  AND C5.D_E_L_E_T_ = ' ' "

		DBUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), "TEMP", .F., .T. )
		if ! TEMP->( EOF() )

			DBSelectArea( "SC5" )
			SC5->( DBSetOrder( 1 ) )		// C5_FILIAL + C5_NUM			

			while ! TEMP->( EOF() )

				if SC5->( DBSeek( FWxFilial( "SC5" ) + TEMP->C5_NUM ) )
					
					RecLock( "SC5", .F. )
					SC5->C5_X_SIMUL  := Space( TAMSX3("C5_X_SIMUL")[1] )
					SC5->C5_X_SQENT  := Space( TAMSX3("C5_X_SQENT")[1] )
					SC5->C5_X_LACRE  := Space( TAMSX3("C5_X_LACRE")[1] )
					SC5->( MsUnlock() )
					
					DBSelectArea( "SC9" )
					SC9->( DBSetOrder( 1 ) )		// C9_FILIAL + C9_PEDIDO
					if SC9->( DBSeek( FWxFilial( "SC9" ) + SC5->C5_NUM ) )
						while ! SC9->( EOF() ) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == FWxFilial( "SC9" ) + SC5->C5_NUM
							RecLock( "SC9", .F. )
							SC9->C9_X_SIMUL := Space(TAMSX3("C9_X_SIMUL")[1])
							SC9->( MsUnlock() )
							SC9->( DBSkip() )
						enddo
					endif

				endif
				
				TEMP->( DBSkip() )
			EndDo
		endif
		TEMP->( DBCloseArea() )

		MsgInfo( "Pedidos desvinculados com sucesso!","S U C E S S O" )

	endif

	restArea( aArea )
return nil	

/*/{Protheus.doc} LSFTCAR
Fun��o para realizar a chamada da fun��o de faturamento autom�tico
@type function
@version  1.0
@author Igor
@since 10/02/2022
@param cAlias, character, alias do browse
@param nRec, numeric, Recno do alias
@param nOpc, numeric, Opcao clicada pelo usuario
/*/
user function LSFTCAR( cAlias, nRec, nOpc )
	
	local aArea := getArea()
	local lFatura := .F. as logical
	
	// Verifica se a integra��o com OMS j� aconteceu
	if !Empty( ( cAlias )->C9_CARGA )
		
		DBSelectArea( "DAK" )
		DAK->( DBSetOrder( 1 ) )		// DAK_FILIAL + DAK_COD
		if DAK->( DBSeek( FWxFilial( "DAK" ) + ( cAlias )->C9_CARGA ) )
			if DAK->DAK_FEZNF == "2"	// Indica que ainda n�o foram geradas as notas fiscais
				Processa( {|| lFatura := U_LSMTA461( ( cAlias )->C9_CARGA, .T. ) }, 'Aguarde!','Preparando faturamento autom�tico...', .F. )
				if lFatura
					RecLock( cAlias, .F. )
					( cAlias )->GERNFE := 'Sim'
					( cAlias )->( MsUnlock() )
					MsgInfo( "Faturamento autom�tico da carga <b>"+ ( cAlias )->C9_CARGA +"</b> finalizado com sucesso!","S U C E S S O" )
				endif
			else
				ShowHelpDlg( 'J� faturada',{ "A carga "+ ( cAlias )->C9_CARGA +" j� se encontra faturada!" }, 1,;
					{ 'Para utilizar essa op��o, selecione uma carga que n�o esteja faturada' }, 1 )
			endif 
		endif
	else
		ShowHelpDlg( 'N�o Integrada', {"A simula��o "+ ( cAlias )->C5_X_SIMUL + " ainda n�o foi efetivada!"}, 1,;
		           {'Para efetiv�-la, realize o processo de integra��o da carga com OMS' }, 1 )
	endif

	restArea( aArea )
return nil

/*/{Protheus.doc} LSINTDAK
Fun��o respons�vel pelo processo de convers�o da simula��o em uma carga no m�dulo OMS
@type function
@version 1.0
@author Igor
@since 07/02/2022
@param cSimula, character, ID do processo de simula��o de carga
@return logical, lDone
/*/
user function LSINTDAK( cAlias, nRec, nOpc, cSimula )
    
    local lDone    := .F.
    local aDAK     := {} as array
    local aDAI     := {} as array
    local cCarga   := "" as character
    local aOrders  := {} as array
    local cOldFun  := FunName()
    local cMsgErro := "" as character
	local nX       := 0  as numeric
	local lFatura  := .F. as logical
	local aNotRdy  := {} as array
	local cNotRdy  := "" as character

    private lMsHelpAuto := .T. as logical
    private lMsErroAuto := .F. as logical

	default nRec    := ( cAliasTMP )->(Recno())
	default nOpc    := 2
    default cSimula := ( cAliasTMP )->C5_X_SIMUL

	// Fun��o para verificar se h� pedidos pendentes de separa��o
	aNotRdy := notReady( ( cAliasTMP )->C5_X_SIMUL )

	// Valida preenchimento do ve�culo
	if Empty( ( cAliasTMP )->ZN1_VEICUL )
		ShowHelpDlg( 'VEICULO',{"Ve�culo n�o informado ao processo de simula��o "+ ( cAliasTMP )->C5_X_SIMUL}, 1,;
					{ 'Informe um ve�culo por meio do processo de associa��o de ve�culo na carga.' },1 )
		return lDone

	// Valida preenchimento da data de embarque
	elseif Empty( DtoS( (cAliasTMP)->ZN1_DTEMB ) )
		ShowHelpDlg( 'DATA EMBARQUE',{"Data de embarque ainda n�o informada no processo de simula��o n�mero "+ ( cAliasTMP )->C5_X_SIMUL}, 1,;
		{ 'Informe a data de embarque por meio do processo de associa��o de ve�culo na carga antes de prosseguir.' },1 )
		return lDone
	
	// Verifica se j� foi gerado carga para evitar gera��o de carga em duplicidade
	elseif !Empty( ( cAliasTMP )->C9_CARGA )
		ShowHelpDlg('JA EXISTE',{"J� existe uma carga gerada para o processo de simula��o "+ ( cAliasTMP )->C5_X_SIMUL}, 1, { 'Carga gerada: '+ ( cAliasTMP )->C9_CARGA }, 1 )
		return lDone
	
	// Verifica se existem pedidos pendentes de separa��o
	elseif len( aNotRdy ) > 0
		cNotRdy := ""
		aEval( aNotRdy, {|x| cNotRdy += iif( !Empty( cNotRdy ),',','' ) + x } )
		ShowHelpDlg('N�o Est� Pronta',{"A carga "+ ( cAliasTMP )->C5_X_SIMUL +" est� em processo de separa��o."}, 1,;
		            { 'Aguarde o t�rmino do processo para poder prosseguir!','Pedidos ainda pendentes: '+ cNotRdy }, 2 )
		return lDone
	endif

    DBSelectArea( "ZN1" )
    ZN1->( DBSetOrder( 1 ) )        // ZN1_FILIAL + ZN1_SIMULA
    if ZN1->( DBSeek( FWxFilial( "ZN1" ) + cSimula ) )

        aDAK := {}
        aAdd( aDAK, { "DAK_FILIAL", FWxFilial( "DAK" ), nil } )
        
        // Obt�m numera��o autom�tica
        cCarga := GETSX8NUM( "DAK", "DAK_COD" )

        aAdd( aDAK, { "DAK_COD", cCarga, nil } )
        aAdd( aDAK, { "DAK_SEQCAR", "01", nil } )
        aAdd( aDAK, { "DAK_ROTEIR", "999999", Nil } )
        aAdd( aDAK, { "DAK_CAMINH", ZN1->ZN1_VEICUL, Nil } )
        aAdd( aDAK, { "DAK_MOTORI", ZN1->ZN1_MOTORI, Nil } )
        aAdd( aDAK, { "DAK_PESO", 0, Nil } )        // OMS calcula automaticamente
        aAdd( aDAK, { "DAK_DATA", dDataBase, Nil } )
        aAdd( aDAK, { "DAK_HORA", Time(), Nil } )
        aAdd( aDAK, { "DAK_JUNTOU", "Manual", Nil } )
        aAdd( aDAK, { "DAK_ACECAR", "2", Nil } )
        aAdd( aDAK, { "DAK_ACEVAS", "2", Nil } )
        aAdd( aDAK, { "DAK_ACEFIN", "2", Nil } )
        aAdd( aDAK, { "DAK_FLGUNI", "2", Nil } )
        aAdd( aDAK, { "DAK_TRANSP", ZN1->ZN1_TRANSP, Nil } )       

        DBSelectArea( "SC5" )
        SC5->( DBOrderNickName( "SIMULACAO" ) )
        if SC5->( DBSeek( FWxFilial( "SC5" ) + cSimula ) )
            aOrders := {}
            while ! SC5->( EOF() ) .and. SC5->C5_FILIAL + SC5->C5_X_SIMUL == FWxFilial( "SC5" ) + cSimula

                aAdd( aOrders, {{ "C5_NUM", SC5->C5_NUM },;
                                { "C5_X_SQENT", SC5->C5_X_SQENT }} )

                SC5->( DBSkip() )
            EndDo
            // Ordena os pedidos do vetor pela sequ�ncia de entrega para que a carga seja gerada conforme a sequ�ncia definida no processo de simula��o
            aSort( aOrders,,,{|x,y| x[aScan(aOrders[1],{|z| AllTrim(z[1]) == "C5_X_SQENT" })][2] < y[aScan(aOrders[1],{|z| AllTrim(z[1]) == "C5_X_SQENT" })][2] } )

        endif
        
        aDAI := {}
        // Percorre os pedidos para adicion�-los ao vetor oficial que ser� utiliado para gera��o da execAuto
        for nX := 1 to len( aOrders )
            
            // Posiciona no cabe�alho do pedido
            DBSelectArea( "SC5" )
            SC5->( DBSetOrder( 1 ) )        // C5_FILIAL + C5_NUM
            SC5->( DBSeek( FWxFilial( "SC5" ) + aOrders[nX][ getPos(aOrders,"C5_NUM", nX) ][02]  ))

            DBSelectArea( "SA1" )
            SA1->( DBSetOrder( 1 ) )        // A1_FILIAL + A1_COD + A1_LOJA
            SA1->( DBSeek( FWxFilial( "SA1" ) + SC5->C5_CLIENT + SC5->C5_LOJAENT ) )

            aAdd( aDAI, { cCarga,;          // 01 - C�digo da carga
                          "999999",;        // 02 - Codigo da Rota
                          "999999",;        // 03 - Codigo da Zona
                          "999999",;        // 04 - Codigo do Setor
                          SC5->C5_NUM,;     // 05 - Pedido
                          SC5->C5_CLIENT,;  // 06 - Cliente de entrega
                          SC5->C5_LOJAENT,; // 07 - Loja de entrega
                          SA1->A1_NOME,;    // 08 - Nome do cliente de entrega
                          SA1->A1_BAIRRO,;  // 09 - Bairro do cliente de entrega
                          SA1->A1_MUN,;     // 10 - Munic�pio do cliente de entrega
                          SA1->A1_EST,;     // 11 - Estado do cliente de entrega
                          SC5->C5_FILIAL,;  // 12 - Filial do pedido de venda
                          SA1->A1_FILIAL,;  // 13 - Filial do cliente
                          0,;               // 14 - Peso Total dos Itens
                          0,;               // 15 - Volume Total dos itens
                          "08:00",;         // 16 - Hora da chegada
                          "0001:00",;       // 17 - Time Service
                          Nil,;             // 18 - N�o usado
                          dDataBase,;       // 19 - Data de chegada
                          dDataBase,;       // 20 - Data de sa�da
                          Nil,;             // 21 - N�o usado
                          Nil,;             // 22 - N�o usado
                          0,;               // 23 - Valor do frete
                          0,;               // 24 - Frete aut�nomo    
                          0,;               // 25 - Valor total de itens (calculado pelo OMSA200)
                          0,;               // 26 - Quantidade total de itens (calculado pelo OMSA200)
                          Nil,;             // 27 - N�o usado
                          "" } )            // 28 - Transportadora redespachante
            
        next nX
		
        SetFunName( "OMSA200" ) // Seta o nome da fun��o para a correta execu��o do processo de integra��o

		// Inicia transa��o protegida
		BEGIN TRANSACTION

			MSExecAuto( {|x,y,z| OMSA200(x,y,z) }, aDAK, aDAI, 3 )

			if lMsErroAuto
				cMsgErro := MostraErro()
				DisarmTransaction()
			else
				// Atualiza browse da rotina
				RecLock( cAlias, .F. )
				( cAlias )->C9_CARGA := cCarga
				( cAlias )->( MsUnlock() )
				MsgInfo( "Carga <b> "+ cCarga +" </b>gerada com sucesso!","S U C E S S O" )
			endif

		END TRANSACTION
        SetFunName( cOldFun )

		// Se preencheu a carga � porque deu certo o processo de integra��o
		// Sendo assim, chama fun��o de faturamento autom�tico da carga
		if !Empty( ( cAlias )->C9_CARGA ) .and. FindFunction( "U_LSMTA461" )
			Processa( {|| lFatura := U_LSMTA461( ( cAlias )->C9_CARGA, .T. ) }, 'Aguarde!','Preparando faturamento autom�tico...', .F. )
			if lFatura
				// Atualiza browse da rotina
				RecLock( cAlias, .F. )
				( cAlias )->GERNFE := 'Sim'
				( cAlias )->( MsUnlock() )
				MsgInfo( "Faturamento autom�tico da carga <b>"+ ( cAlias )->C9_CARGA +"</b> finalizado com sucesso!","S U C E S S O" )
			endif
		endif

    else
        ShowHelpDlg( 'ID Simula��o', {"O ID do processo de simula��o enviado "+ iif( !Empty( cSimula ), "("+cSimula+")", "" ) +" n�o existe ou a carga "+;
            "ainda n�o est� pronta para que o processo de montagem de carga seja realizado" }, 1,;
            { 'Primeiro, verifique se o processo de simula��o cont�m v�nculo com ve�culo e motorista, e tamb�m, se o processo de separa��o j� foi realizado.' }, 1 )
    endif

return lDone

/*/{Protheus.doc} notReady
Fun��o para buscar pedidos ainda pendentes de separa��o para o processo informado
@type function
@version 1.0 
@author Igor
@since 14/02/2022
@param cSimula, character, ID do processo de simula��o
@return array, aNotReady
/*/
static function notReady( cSimula )
	
	local aArea := getArea()
	local aNotRdy := {} as array
	
	DBSelectArea( "SC9" )
	SC9->( DBOrderNickName( "SIMULACAO" ) )	// C9_FILIAL + C9_X_SIMUL
	if SC9->( DBSeek( FWxFilial( "SC9" ) + cSimula ) )
		// Percorre os pedidos liberados vinculados ao processo de simula��o
		while ! SC9->( EOF() ) .and. SC9->C9_FILIAL + SC9->C9_X_SIMUL == FWxFilial( "SC9" ) + cSimula
			// Verifica se o item est� em processo de separa��o
			if SC9->C9_BLEST == 'SP'
				// Verifica se o pedido j� est� relacionado no vetor 
				if aScan( aNotRdy, {|x| x == SC9->C9_PEDIDO } ) == 0
					aAdd( aNotRdy, SC9->C9_PEDIDO )
				endif
			endif
			SC9->( DBSkip() )
		enddo
	endif

	restArea( aArea )
return aNotRdy


/*/{Protheus.doc} getPos
Fun��o para retornar a posi��o de um campo no vetor aOrders
@type function
@version 1.0
@author Igor
@since 07/02/2022
@param aVetor, array, vetor com os dados
@param cField, character, nome do campo cuja posi��o ser� retornada
@return numeric, nPosition
/*/
static function getPos( aVetor, cField, nLine )
return aScan( aVetor[nLine], {|x| AllTrim( x[1] ) == AllTrim( cField ) } )

/*/{Protheus.doc} LSMPCAR
Funcao responsavel pela chamada do relatorio de impressao do mapa de carregamento da simulacao
@type function
@version 12.1.27
@author Igor
@since 31/01/2022
@param cAlias, character, alias do browse
@param nRec, numeric, Recno do registro posicionado no Browse
@param nOpc, numeric, op��o selecionada pelo usu�rio
/*/
User Function LSMPCAR( cAlias, nRec, nOpc )
	
	local aArea := getArea()

	// Valida preenchimento o motorista
	if Empty( ( cAliasTMP )->ZN1_VEICUL )
		ShowHelpDlg( 'VEICULO',{"Ve�culo n�o informado ao processo de simula��o "+ ( cAliasTMP )->C5_X_SIMUL}, 1,;
					{ 'Informe um ve�culo por meio do processo de associa��o de ve�culo na carga.' },1 )
	// Valida preenchimento da data de embarque
	elseif Empty( DtoS( (cAliasTMP)->ZN1_DTEMB ) )
		ShowHelpDlg( 'DATA EMBARQUE',{"Data de embarque ainda n�o informada no processo de simula��o n�mero "+ ( cAliasTMP )->C5_X_SIMUL}, 1,;
					{ 'Informe a data de embarque por meio do processo de associa��o de ve�culo na carga antes de prosseguir.' },1 )
	else
		// Chama impress�o do mapa de carregamento
		U_LSROMS03( (cAliasTMP)->C5_X_SIMUL )
	endif

	restArea( aArea )
return Nil


//ADD IGOR EVENTO DE CANCELAMENTO 
User Function YYYYY()

	// VERIFICAR O FONTE LSOMS06 NA LINHA 1162 QUE CONTEM QUESTAO BLOQUEIO DA CARGA SEPARACAO
	cSimu := (cAliasTMP)->C5_X_SIMUL
	cRetorno := ""
	// MsgInfo("Evento Cancelar WorkFlow...(" + cSimu + ")", "TESTE")

	if Empty((cAliasTMP)->C9_CARGA)

		if MsgYesNo("Realmente deseja Cancelar esta Simulacao (" + cSimu + ") ?", "ATEN��O")


			if !Empty((cAliasTMP)->ZN1_VEICUL)
				cRetorno := FWInputBox("Informe o Motivo do Cancelamento? :", "")
				U_FWSEP003(xFilial("ZN1"), (cAliasTMP)->C5_X_SIMUL, "01", cRetorno)
			EndIf

			// REALIZA PROCESSO DE LIMPAR A SIMULACAO DA SC5 E SC9 E VOLTA
			CLEARSIM((cAliasTMP)->C5_X_SIMUL)

			//Restaura os parametros
			RESPARAM()

			//Seleciona registros
			FWMsgRun(, {|| ATUGRID() }, "Processando", "Atualizando registros...")

		endIf
	else
		MsgAlert("N�o � possivel Cancelar a Simulacao!", "ATEN��O")
	endif

return

/*/{Protheus.doc} LSVISSIM
Fun��o respons�vel pela visualiza��o do processo de simula��o de carga
@type function
@version 1.0 
@author Igor
@since 15/02/2022
/*/
user function LSVISSIM()
	local aArea := getArea()
	
	// Chama rotina de montagem de simula��o em modo de visualiza��o
	U_GAOMS022( 2 )

	restArea( aArea )
return Nil

/*/{Protheus.doc} WWWWWW
Chama rotina de montagem de simula��o
@type function
@version 1.0 
@author Igor
@since 14/02/2022
/*/
User Function WWWWWW()

	Local aArea := GetArea()
	local lIncluiu := .F. as logical

	// Chama fun��o de montagem do processo de simula��o
	lIncluiu := U_GAOMS022( 3 )

	// Verifica se houve inclus�o de uma nova simula��o para ver se tem necessidade de atualizar o grid
	if lIncluiu

		//Restaura os parametros
		RESPARAM()

		//Seleciona registros
		FWMsgRun(, {|| ATUGRID() }, "Processando", "Atualizando registros...")
	else
		//Restaura os parametros
		RESPARAM()
		RestArea(aArea)
	endif

Return

/*/{Protheus.doc} XXXXXX
Fun��o para disparo do workflow de separa��o
@type function
@version 1.0
@author ICmais
@since 2/4/2022
/*/
User Function XXXXXX()

	cSimula :=(cAliasTMP)->C5_X_SIMUL

	// Valida v�nculo do ve�culo com a carga
	IF Empty((cAliasTMP)->C9_CARGA) .AND. !Empty((cAliasTMP)->ZN1_VEICUL)

		if MsgYesNo("Deseja Enviar Workflow da (" + cSimula + ") para separa��o ?", "ATEN��O")

			U_FWSEP001( xFilial("ZN1"), cSimula, "01", 2 )

		EndIF
	else
		MsgAlert("N�o � possivel enviar Workflow da Simulacao (" + cSimula + "), veiculo n�o associado !", "ATEN��O")
	EndiF

return

/*/{Protheus.doc} User Function ICLG1ASS
    Verifica se pode associar veiculo a carga
    @type  Function
    @author user
    @since 17/12/2021
    @version 1.0
/*/
User Function ICLG1ASS()

	if Empty((cAliasTMP)->C9_CARGA)

		// Chama fun��o respons�vel pelo v�nculo dos dados de ve�culo, motorista e transportador
		if U_ICLOG002((cAliasTMP)->C5_X_SIMUL)
			//Restaura os parametros
			RESPARAM()
			//Seleciona registros
			FWMsgRun(, {|| ATUGRID() }, "Processando", "Atualizando registros...")
		else
			RESPARAM()
		endif
	else
		MsgAlert("N�o � possivel associar veiculo j� possui carga vinculada!", "ATEN��O")
	endif

Return




/*/{Protheus.doc} ATUGRID
    Atualiza grid
    @type Function
    @author ICMAIS
    @since 17/12/2021
    @version 1.0
/*/
Static Function ATUGRID()

	DBSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())
	While !(cAliasTMP)->(Eof())
		//Limpa tabela
		(RecLock(cAliasTMP, .F.))
		(cAliasTMP)->(dbDelete())
		(cAliasTMP)->(MsUnlock())

		(cAliasTMP)->(DBSkip())
	EndDo

	PROCREG()
Return


/*/{Protheus.doc} CLEARSIM
    Limpa os dados relacionados a simulacao
    @type Function
    @author DZ
    @since 10/01/2022
    @version 1.0
    @param cCodSimul, character, codigo do processo de simulacao
/*/
Static Function CLEARSIM(cCodSimul)
	
	Local aArea     := GetArea()
	Local cQryUpd   := ""

	BEGIN TRANSACTION

		//Limpa SC5
		cQryUpd := " UPDATE "+ RetSqlName("SC5")
		cQryUpd += " 	SET C5_X_SIMUL = '', "
		cQryUpd += "        C5_TRANSP  = '"+ Space( TAMSX3("C5_TRANSP")[1] ) +"' "
		cQryUpd += " WHERE C5_FILIAL = '" + xFilial("SC5") + "'"
		cQryUpd += "	AND C5_X_SIMUL = '" + cCodSimul + "'"

		If TCSQLEXEC(cQryUpd) < 0
			Alert("Ocorreu um erro na execu��o do comando SC5." + TCSQLError())
			DisarmTransaction()
		EndIf


		//Limpa SC9
		cQryUpd := " UPDATE "+ RetSqlName("SC9")
		cQryUpd += " 	SET C9_X_SIMUL = '', C9_BLEST = '' "
		cQryUpd += " WHERE C9_FILIAL = '" + xFilial("SC9") + "'"
		cQryUpd += "	AND C9_X_SIMUL = '" + cCodSimul + "'"

		If TCSQLEXEC(cQryUpd) < 0
			Alert("Ocorreu um erro na execu��o do comando SC9." + TCSQLError())
			DisarmTransaction()
		EndIf

		DBSelectArea( "ZN1" )
		ZN1->( DBSetOrder( 1 ) )
		if ZN1->( DBSeek( FWxFIlial( "ZN1" ) + cCodSimul ) )
			RecLock( "ZN1", .F. )
			ZN1->( DBDelete() )
			ZN1->( MsUnlock() )
		endif  

	END TRANSACTION

	RestArea(aArea)
Return




/*/{Protheus.doc} GRVPARAM
    Grava os parametros MV_PAR...
    @type Function
    @author user
    @since 12/01/2022
    @version 1.0
/*/
Static Function GRVPARAM()
	Local nMV := 0

	For nMv := 1 To 2
		aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv

Return




/*/{Protheus.doc} RESPARAM
    Restaura os conteudos do parametros MV_PAR...
    @type Function
    @author user
    @since 12/01/2022
    @version 1.0
/*/
Static Function RESPARAM()
	Local nMv := 0

	For nMv := 1 To Len( aMvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv

Return
