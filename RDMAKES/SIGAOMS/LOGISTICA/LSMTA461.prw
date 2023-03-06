#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} LSMTA461
Fun��o personalizada para realiza��o do processo de faturamento autom�tico
@type function
@version 1.0
@author ICmais
@since 2/10/2022
@param cCarga, character, c�digo da carga que deseja faturar automaticamente (obrigat�rio)
@param lRegua, logical, indica se usa r�gua de processamento (opcional)
@return logical, lSuccess
/*/
user function LSMTA461( cCarga, lRegua )

    local aArea     := getArea()
    local lSuccess  := .F. as logical
    local cSerie    := ""  as character
    local lContinue := .T. as logical
    local aPvlNfs   := {}  as array
    local nPrcVen   := 0   as numeric
    local aPedidos  := {}  as array
    local nPd       := 0   as numeric
    local cNota     := ""  as character
    local cPedido   := ""  as character
    local cOldFun   := FunName()

    default cCarga := ""
    default lRegua := .F.       // default falso para uso de r�gua de processamento

    // Verifica se o par�metro recebido n�o est� vazio
    if Empty( cCarga )
        Help( ,, 'Nro da Carga',, "O n�mero da carga n�o foi enviado para a fun��o de faturamento autom�tica (LSMTA461)!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'Para que o faturamento autom�tico aconte�a, a fun��o LSMTA461 precisa receber o c�digo da carga a ser faturada!' } )
        lContinue := .F.
    else
        // Tenta posicionar na tabela de cargas para ver se o n�mero � v�lido
        DBSelectArea( "DAK" )
        DAK->( DBSetOrder( 1 ) )        // DAK_FILIAL + DAK_COD
        if ! DAK->( DBSeek( FWxFilial( "DAK" ) + cCarga ) )
            Help( ,, 'Nro da Carga',, "O n�mero da carga recebido � inv�lido!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'O n�mero enviado ('+ cCarga +') n�o existe, por isso, n�o � poss�vel prosseguir com o faturameto autom�tico!' } )
            lContinue := .F.
        endif
    endif
    
    // Pergunta se o usu�rio quer mesmo prosseguir com o faturamento
    lContinue := iif( lContinue, MsgYesNo( "Deseja iniciar o processo de faturamento autom�tico da carga n�mero "+ cCarga +"?", "Iniciar faturamento?" ), lContinue )
    // Executa perguntas padr�es da rotina MATA460
    lContinue := iif( lContinue, Pergunte("MT460A",.T.), lContinue )
    // Executa pergunta do n�mero da s�rie em que o usu�rio deseja realizar o faturamento
    lContinue := iif( lContinue, SX5NumNota(@cSerie,SuperGetMV("MV_TPNRNFS")), lContinue )
    
    // Se o usu�rio optou por continuar, pergunta o n�mero da s�rie que quer utilizar para iniciar o faturameto
    if lContinue
        
        // Percorre a SC9 para identificar os itens liberados dos pedidos vinculados � carga que deve ser faturada
        DBSelectArea( "SC9" )
        SC9->( DBSetOrder( 5 ) )        // C9_FILIAL + C9_CARGA + C9_SEQCAR + C9_SEQENT
        if SC9->( DBSeek( FWxFilial( "SC9" ) + DAK->DAK_COD + DAK->DAK_SEQCAR ) )
            while ! SC9->( EOF() ) .and. SC9->C9_FILIAL + SC9->C9_CARGA + SC9->C9_SEQCAR == FWxFilial( "SC9" ) + DAK->DAK_COD + DAK->DAK_SEQCAR
                
                cPedido := SC9->C9_PEDIDO

                // Adiciona para faturar apenas o que ainda n�o tiver sido faturado e, desde que, esteja 100% liberado de cr�dito e estoque
                if Empty( SC9->C9_NFISCAL ) .and. Empty( SC9->C9_BLCRED ) .and. Empty( SC9->C9_BLEST )

                    // Posiciona no cadastro de produto
                    dbSelectArea("SB1")
                    dbSetOrder(1)
                    MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

                    // Posiciona no cabe�alho do pedido
                    dbSelectArea("SC5")
                    dbSetOrder(1)
                    MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

                    // Posiciona no item do pedido a que refere a libera��o posicionada
                    dbSelectArea("SC6")
                    dbSetOrder(1)
                    MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

                    // Posiciona na posi��o de estoque do produto para o armaz�m em que a venda foi realizada
                    dbSelectArea("SB2")
                    dbSetOrder(1)
                    MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

                    // Posiciona no cadastro de TES
                    dbSelectArea("SF4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SF4")+SC6->C6_TES)

                    // Posiciona no cadastro de condi��es de pagamento
                    dbSelectArea("SE4")
                    dbSetOrder(1)
                    MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
                    
                    // Adequa o pre�o unit�rio conforme a quantidade de decimais do item da nota e tamb�m de acordo com a moeda do pa�s de destino
                    nPrcVen := a410Arred(xMoeda(SC9->C9_PRCVEN,SC5->C5_MOEDA,1,dDataBase,8),"D2_PRCVEN")
                    
                    // Adiciona os itens a serem faturados no vetor
                    aAdd( aPvlNfs, { SC9->C9_PEDIDO,;
                                    SC9->C9_ITEM,;
                                    SC9->C9_SEQUEN,;
                                    SC9->C9_QTDLIB,;
                                    nPrcVen,;
                                    SC9->C9_PRODUTO,;
                                    SF4->F4_ISS=="S",;
                                    SC9->(RecNo()),;
                                    SC5->(RecNo()),;
                                    SC6->(RecNo()),;
                                    SE4->(RecNo()),;
                                    SB1->(RecNo()),;
                                    SB2->(RecNo()),;
                                    SF4->(RecNo()),;
                                    SB2->B2_LOCAL,;
                                    DAK->(RecNo()),;
                                    SC9->C9_QTDLIB2 } )
                
                endif

                SC9->( DBSkip() )

                // verifica se percorreu toda a SC9 ou se mudou o n�mero do pedido
                if SC9->( EOF() ) .or. ( SC9->C9_PEDIDO != cPedido .and. len( aPvlNfs ) > 0 )
                    aAdd( aPedidos, { cPedido, aClone( aPvlNfs ) } )
                    aPvlNfs := {}
                endif

            enddo

            // Verifica se existem pedidos a serem faturados
            if Len( aPedidos ) > 0
                
                if lRegua
                    ProcRegua( len( aPedidos ) )
                endif
                
                for nPd := 1 to len( aPedidos )
                    
                    cNota := ""
                    if !lContinue
                        Exit
                    endif
                    if lRegua
                        IncProc( "Faturamento em andamento "+ cValToChar(nPd)+"/"+cValToChar( len( aPedidos ) ) +" - pedido: " + aPedidos[nPd][1] +"... " )
                    endif

                    SetFunName( "MATA460" )
                    BEGIN TRANSACTION
                        
                        // Executa prepara��o dos documentos de sa�da
                        cNota := MaPvlNfs(aPedidos[nPd][2],;
                                        cSerie,;
                                        MV_PAR01==1,;
                                        MV_PAR02==1,;
                                        MV_PAR03==1,;
                                        MV_PAR04==1,;
                                        MV_PAR05==1,;
                                        MV_PAR06,;
                                        MV_PAR07,;
                                        MV_PAR15==1,;
                                        MV_PAR16==2)
                        
                        // Valida se conseguiu gerar a nota fiscal
                        if Empty( cNota )
                            DisarmTransaction()
                        endif

                    END TRANSACTION
                    SetFunName( cOldFun )
                    
                    // localiza a nota fiscal para garantir que o processo ocorreu da forma correta
                    DbSelectArea( "SF2" )
                    SF2->( DBSetOrder( 1 ) )        // F2_FILIAL + F2_DOC + F2_SERIE
                    if Empty( cNota ) .or. ! SF2->( DBSeek( FWxFilial( "SF2" ) + cNota + cSerie ) )
                        lContinue := .F.
                        Help( ,, 'Gera��o da NFe',, "Ocorreu falha durante o processo de gera��o da nota fiscal!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'A falha ocorreu no momento do faturamento do pedido '+ aPedidos[nPd][01] +'!' } )
                    endif

                next nPd

                lSuccess := lContinue

            endif

        endif

    endif

    restArea( aArea )
return lSuccess
