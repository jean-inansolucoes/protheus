#include 'totvs.ch'
#include 'topconn.ch'

#define CLR_HGREY 12632256

/*/{Protheus.doc} LSADDPED
Fun��o criada para permitir a adi��o de novos pedidos a uma simula��o de carga j� existente
@type function
@version 1.0
@author ICmais
@since 2/4/2022
/*/
user function LSADDPED( cAlias, nReg, nOpc )

    local aArea := getArea()
    Local oCustomer
    Local oGroup
    Local oLbCustom
    Local oLbName
    Local oLbOrder
    Local oLbStore
    Local oName
    Local oOrder
    Local oStore
    local cOrder    := Space( TAMSX3("C5_NUM")[1] )
    local bConfirma := {|| confirma( cOrder, (cAliasTMP)->C5_X_SIMUL ) }
    local bCancel   := {|| oDlgAdd:End() }
    local aBottons  := {} as array

    Private cStore    := Space( TAMSX3("C5_LOJAENT")[1] )
    Private cCustomer := Space( TAMSX3("C5_CLIENT" )[1] )
    Private oDlgAdd
    Private cName     := Space( TAMSX3("A1_NOME"   )[1] )

    // Valida se a carga j� n�o foi gerada no OMS antes de prosseguir
    if !Empty(( cAliasTMP )->( C9_CARGA ))
        ShowHelpDlg( 'Carga Gerada',{"A simula��o "+ ( cAliasTMP )->C5_X_SIMUL +" j� tem carga gerada no OMS!"}, 1,;
                                    { '� imposs�vel adicionar novos pedidos a uma carga j� integrada com o OMS' , 1 } )
        restArea( aArea )
        return nil
    endif

    // Exibe caixa de di�logo para adicionar novos pedidos a uma simula��o j� existente
    DEFINE MSDIALOG oDlgAdd TITLE "SIMULACAO "+ (cAliasTMP)->C5_X_SIMUL +" - Adicionar Pedido" FROM 000, 000  TO 150, 600 COLORS 0, 16777215 PIXEL

    @ 034, 004 GROUP oGroup TO 073, 298 OF oDlgAdd COLOR 0, 16777215 PIXEL
    
    @ 042, 006 SAY oLbOrder  PROMPT "Pedido"       SIZE 025, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL
    @ 042, 058 SAY oLbCustom PROMPT "Cliente"      SIZE 025, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL
    @ 042, 115 SAY oLbStore  PROMPT "Loja"         SIZE 025, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL
    @ 042, 148 SAY oLbName   PROMPT "Raz�o Social" SIZE 043, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL

    @ 050, 005 MSGET oOrder    VAR cOrder    SIZE 046, 012 OF oDlgAdd VALID validOrder(cOrder) COLORS 0, 16777215 ON CHANGE changeOrder(cOrder) F3 "SC5" PIXEL
    @ 050, 057 MSGET oCustomer VAR cCustomer SIZE 052, 012 OF oDlgAdd COLORS 0, 8421504 READONLY F3 "SA3" PIXEL
    oCustomer:NCLRPANE := CLR_HGREY
    @ 050, 113 MSGET oStore    VAR cStore    SIZE 031, 012 OF oDlgAdd COLORS 0, 8421504 READONLY PIXEL
    oStore:NCLRPANE := CLR_HGREY
    @ 050, 147 MSGET oName     VAR cName     SIZE 142, 012 OF oDlgAdd COLORS 0, 8421504 READONLY PIXEL
    oName:NCLRPANE := CLR_HGREY

    ACTIVATE MSDIALOG oDlgAdd CENTERED ON INIT EnchoiceBar( oDlgAdd, bConfirma, bCancel, , aBottons )

    restArea( aArea )
return nil

/*/{Protheus.doc} confirma
Fun��o que executa a efetiva��o dos dados no cabe�alho do pedido e nos itens liberados do pedido
@type function
@version 1.0
@author ICmais
@since 2/4/2022
@param cOrder, character, n�mero do pedido (obrigat�rio)
@param cSimula, character, c�digo da simula��o (obrigat�rio)
/*/
static function confirma( cOrder, cSimula )
    
    Local lSuccess  := .F. as logical

    BEGIN TRANSACTION
    
        DBSelectArea( "SC5" )
        SC5->( DBSetOrder( 1 ) )        // C5_FILIAL + C5_NUM
        if SC5->( DBSeek( FWxFilial( "SC5" ) + cOrder ) )
            RecLock( "SC5", .F. )
            SC5->C5_X_SIMUL := cSimula
            SC5->( MsUnlock() )

            DBSelectArea( "SC9" )
            SC9->( DBSetOrder( 1 ) )
            if SC9->( DBSeek( FWxFilial( "SC9" ) + cOrder ) )
                while ! SC9->( EOF() ) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == FWxFilial( "SC9" ) + cOrder

                    // Vincula os itens liberados do pedido com o processo de simula��o de carga
                    if Empty( SC9->C9_NFISCAL ) .and. Empty( SC9->C9_BLEST ) .and. Empty( SC9->C9_BLCRED )
                        RecLock( "SC9", .F. )
                        SC9->C9_X_SIMUL := cSimula
                        SC9->C9_BLEST   := 'SP'
                        SC9->( MsUnlock() )

                        // Se chegou aqui uma vez, pode saber que deu certo
                        lSuccess := .T.
                    endif

                    SC9->( DBSkip() )
                enddo
            endif

        endif

    END TRANSACTION

    // Se obteve sucesso no processo de adi��o do pedido � carga
    if lSuccess

        MsgInfo( "Pedido <b>"+ cOrder +"</b> adicionado com sucesso ao processo de simula��o <b>"+ cSimula +"</b>", "S U C E S S O!" )

        // Verifica se a simula��o j� est� gravada na ZN1, pois se estiver, deve gravar uma nova revis�o e disparar o workflow
        DBSelectArea( "ZN1" )
        ZN1->( DBSetOrder( 1 ) )        // ZN1_FILIAL + ZN1_SIMULA
        if ZN1->( DBSeek( FWxFilial( "ZN1" ) + cSimula ) )
            RecLock( "ZN1", .F. )
            ZN1->ZN1_REVISA += 1
            ZN1->( MsUnlock() )

            // Chama fun��o para disparo de workflow de separa��o para a carga posicionada na tabela tempor�ria
            if FindFunction( "U_XXXXXX" )
                U_XXXXXX()
            endif

        endif

        oDlgAdd:End()

    endif

return nil

/*/{Protheus.doc} changeOrder
Fun��o disparada ap�s o preenchimento do campo do n�mero do pedido
@type function
@version 1.0
@author ICmais
@since 2/4/2022
@param cOrder, character, n�mero do pedido (obrigat�rio)
/*/
static function changeOrder( cOrder )
    cCustomer := retField( "SC5", 1, FWxFilial( "SC5" ) + cOrder, "C5_CLIENT" )
    cStore    := retField( "SC5", 1, FWxFilial( "SC5" ) + cOrder, "C5_LOJAENT" )
    cName     := retField( "SA1", 1, FWxFilial( "SA1" ) + cCustomer + cStore, "A1_NOME" )
    oDlgAdd:Refresh()
return nil

/*/{Protheus.doc} validOrder
Fun��o para validar o pedido informado antes de prosseguir. A fun��o valida se: o pedido existe, se est� liberado,
se n�o foi faturado e se n�o existe bloqueio de cr�dito ou estoque.
@type function
@version 1.0
@author ICmais
@since 2/4/2022
@param cOrder, character, n�mero do pedido de venda (obrigat�rio)
@return logical, lValidated
/*/
static function validOrder( cOrder )

    local lValidated := .T. as logical
    
    DBSelectArea( "SC5" )
    SC5->( DBSetOrder( 1 ) )        // C5_FILIAL + C5_NUM
    if SC5->( DBSeek( FWxFilial( "SC5" ) + cOrder ) )
        
        // Verifica se o pedido em quest�o j� n�o foi faturado
        if Empty( SC5->C5_NOTA )

            // Verifica se os itens do pedido foram todos liberados antes de permitir que o usu�rio prossiga
            if SC5->C5_LIBEROK == "S"
                
                // Verifica se o pedido j� n�o est� ligado a outro processo de simula��o
                if Empty( SC5->C5_X_SIMUL )
                    
                    DBSelectArea( "SC6" )
                    SC6->( DBSetOrder( 1 ) )        // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
                    if SC6->( DBSeek( FWxFilial( "SC6" ) + SC5->C5_NUM ) )

                        DBSelectArea( "SC9" )
                        SC9->( DBSetOrder( 1 ) )  // C9_FILIAL + C9_PEDIDO + C9_ITEM 
                        while ! SC6->( EOF() ) .and. SC6->C6_FILIAL + SC6->C6_NUM == FWxFilial( "SC6" ) + SC5->C5_NUM .and. lValidated
                            
                            // Tenta localizar registro na tabela de itens liberados do pedido
                            if SC9->( DBSeek( FWxFilial( "SC9" ) + SC6->C6_NUM + SC6->C6_ITEM ) ) 

                                // Percorre as libera��es do produto, pois, devido ao processo de consumir saldo de mais que um lote, podem haver mais libera��es para um mesmo item do pedido
                                while ! SC9->( EOF() ) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM == FWxFilial( "SC9" ) + SC6->C6_NUM + SC6->C6_ITEM .and. lValidated

                                    // Ignora os itens que j� estiverem faturados (se chegou at� aqui, o pedido n�o foi completamente faturado, ent�o, h� mais itens pendentes)
                                    if Empty( SC9->C9_NFISCAL )

                                        // Valida se o pedido est� liberado de cr�dito e estoque
                                        if ! Empty( SC9->C9_BLCRED ) .or. ! Empty( SC9->C9_BLEST )
                                            lValidated := .F. 
                                            Help( ,, 'Pedido com bloqueio!',, "O item "+ SC6->C6_ITEM +"-"+ AllTrim( SC6->C6_DESCRI ) +;
                                                " referente ao pedido informado ( "+ cOrder +" ) est� com bloqueio de "+iif( !Empty( SC9->C9_BLCRED ), "credito","estoque" )+"!",;
                                                1, 0, NIL, NIL, NIL, NIL, NIL,{ 'Para prosseguir, execute a rotina Libera��o de '+; 
                                                iif( !Empty( SC9->C9_BLCRED ), "Credito","Estoque" ) +' para que o mesmo possa ser adicionado no processo de simula��o de carga.' } )
                                        endif

                                    endif

                                    SC9->( DBSkip() )
                                EndDo

                            elseif ! Trim(SC6->C6_BLQ) == 'R '      // Verifica se n�o foi eliminado res�duo do produto
                                lValidated := .F.
                                Help( ,, 'Produto N�o Liberado!',, "O item "+ SC6->C6_ITEM +"-"+ AllTrim( SC6->C6_DESCRI ) +;
                                    " referente ao pedido informado ( "+ cOrder +" ) n�o foi liberado!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                                    { 'Para prosseguir, execute a rotina Libera��o de Pedido para que o mesmo possa ser adicionado no processo de simula��o de carga.' } )
                            endif

                            SC6->( DBSkip() )
                        EndDo

                    endif
                
                else
                    lValidated := .F.
                    Help( ,, 'Pedido em Carga!',, "O pedido informado ( "+ cOrder +" ) j� se encontra relacionado com o processo de simula��o"+ SC5->C5_X_SIMUL +"!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                    { 'Selecione um pedido que ainda n�o esteja relacionado a um processo de simula��o para poder prosseguir' } )
                endif
            else
                lValidated := .F.
                Help( ,, 'Pedido N�o Liberado!',, "O pedido informado ( "+ cOrder +" ) n�o foi liberado!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                    { 'Um ou mais itens do pedido n�o foram liberados, por isso, � necess�rio executar o processo de libera��o antes de prosseguir.' } )
            endif

        else
            lValidated := .F.
                Help( ,, 'Pedido finalizado!',, "O pedido informado ( "+ cOrder +" ) j� se encontra finalizado!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                    { 'Selecione um pedido que ainda n�o esteja finalizado para poder prosseguir' } )
            
        endif
    else
        lValidated := .F.
        Help( ,, 'Pedido N�o Existe!',, "N�mero do pedido inv�lido!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
            { 'Digite corretamente o pedido desejado ou utilize a lupa de pesquisa ou bot�o F3 para selecionar um pedido v�lido' } )
    endif

return lValidated
