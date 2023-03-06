#include 'totvs.ch'
#include 'topconn.ch'

#define CLR_HGREY 12632256

/*/{Protheus.doc} LSADDPED
Função criada para permitir a adição de novos pedidos a uma simulação de carga já existente
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

    // Valida se a carga já não foi gerada no OMS antes de prosseguir
    if !Empty(( cAliasTMP )->( C9_CARGA ))
        ShowHelpDlg( 'Carga Gerada',{"A simulação "+ ( cAliasTMP )->C5_X_SIMUL +" já tem carga gerada no OMS!"}, 1,;
                                    { 'É impossível adicionar novos pedidos a uma carga já integrada com o OMS' , 1 } )
        restArea( aArea )
        return nil
    endif

    // Exibe caixa de diálogo para adicionar novos pedidos a uma simulação já existente
    DEFINE MSDIALOG oDlgAdd TITLE "SIMULACAO "+ (cAliasTMP)->C5_X_SIMUL +" - Adicionar Pedido" FROM 000, 000  TO 150, 600 COLORS 0, 16777215 PIXEL

    @ 034, 004 GROUP oGroup TO 073, 298 OF oDlgAdd COLOR 0, 16777215 PIXEL
    
    @ 042, 006 SAY oLbOrder  PROMPT "Pedido"       SIZE 025, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL
    @ 042, 058 SAY oLbCustom PROMPT "Cliente"      SIZE 025, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL
    @ 042, 115 SAY oLbStore  PROMPT "Loja"         SIZE 025, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL
    @ 042, 148 SAY oLbName   PROMPT "Razão Social" SIZE 043, 007 OF oDlgAdd COLORS 0, 16777215 PIXEL

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
Função que executa a efetivação dos dados no cabeçalho do pedido e nos itens liberados do pedido
@type function
@version 1.0
@author ICmais
@since 2/4/2022
@param cOrder, character, número do pedido (obrigatório)
@param cSimula, character, código da simulação (obrigatório)
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

                    // Vincula os itens liberados do pedido com o processo de simulação de carga
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

    // Se obteve sucesso no processo de adição do pedido à carga
    if lSuccess

        MsgInfo( "Pedido <b>"+ cOrder +"</b> adicionado com sucesso ao processo de simulação <b>"+ cSimula +"</b>", "S U C E S S O!" )

        // Verifica se a simulação já está gravada na ZN1, pois se estiver, deve gravar uma nova revisão e disparar o workflow
        DBSelectArea( "ZN1" )
        ZN1->( DBSetOrder( 1 ) )        // ZN1_FILIAL + ZN1_SIMULA
        if ZN1->( DBSeek( FWxFilial( "ZN1" ) + cSimula ) )
            RecLock( "ZN1", .F. )
            ZN1->ZN1_REVISA += 1
            ZN1->( MsUnlock() )

            // Chama função para disparo de workflow de separação para a carga posicionada na tabela temporária
            if FindFunction( "U_XXXXXX" )
                U_XXXXXX()
            endif

        endif

        oDlgAdd:End()

    endif

return nil

/*/{Protheus.doc} changeOrder
Função disparada após o preenchimento do campo do número do pedido
@type function
@version 1.0
@author ICmais
@since 2/4/2022
@param cOrder, character, número do pedido (obrigatório)
/*/
static function changeOrder( cOrder )
    cCustomer := retField( "SC5", 1, FWxFilial( "SC5" ) + cOrder, "C5_CLIENT" )
    cStore    := retField( "SC5", 1, FWxFilial( "SC5" ) + cOrder, "C5_LOJAENT" )
    cName     := retField( "SA1", 1, FWxFilial( "SA1" ) + cCustomer + cStore, "A1_NOME" )
    oDlgAdd:Refresh()
return nil

/*/{Protheus.doc} validOrder
Função para validar o pedido informado antes de prosseguir. A função valida se: o pedido existe, se está liberado,
se não foi faturado e se não existe bloqueio de crédito ou estoque.
@type function
@version 1.0
@author ICmais
@since 2/4/2022
@param cOrder, character, número do pedido de venda (obrigatório)
@return logical, lValidated
/*/
static function validOrder( cOrder )

    local lValidated := .T. as logical
    
    DBSelectArea( "SC5" )
    SC5->( DBSetOrder( 1 ) )        // C5_FILIAL + C5_NUM
    if SC5->( DBSeek( FWxFilial( "SC5" ) + cOrder ) )
        
        // Verifica se o pedido em questão já não foi faturado
        if Empty( SC5->C5_NOTA )

            // Verifica se os itens do pedido foram todos liberados antes de permitir que o usuário prossiga
            if SC5->C5_LIBEROK == "S"
                
                // Verifica se o pedido já não está ligado a outro processo de simulação
                if Empty( SC5->C5_X_SIMUL )
                    
                    DBSelectArea( "SC6" )
                    SC6->( DBSetOrder( 1 ) )        // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
                    if SC6->( DBSeek( FWxFilial( "SC6" ) + SC5->C5_NUM ) )

                        DBSelectArea( "SC9" )
                        SC9->( DBSetOrder( 1 ) )  // C9_FILIAL + C9_PEDIDO + C9_ITEM 
                        while ! SC6->( EOF() ) .and. SC6->C6_FILIAL + SC6->C6_NUM == FWxFilial( "SC6" ) + SC5->C5_NUM .and. lValidated
                            
                            // Tenta localizar registro na tabela de itens liberados do pedido
                            if SC9->( DBSeek( FWxFilial( "SC9" ) + SC6->C6_NUM + SC6->C6_ITEM ) ) 

                                // Percorre as liberações do produto, pois, devido ao processo de consumir saldo de mais que um lote, podem haver mais liberações para um mesmo item do pedido
                                while ! SC9->( EOF() ) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM == FWxFilial( "SC9" ) + SC6->C6_NUM + SC6->C6_ITEM .and. lValidated

                                    // Ignora os itens que já estiverem faturados (se chegou até aqui, o pedido não foi completamente faturado, então, há mais itens pendentes)
                                    if Empty( SC9->C9_NFISCAL )

                                        // Valida se o pedido está liberado de crédito e estoque
                                        if ! Empty( SC9->C9_BLCRED ) .or. ! Empty( SC9->C9_BLEST )
                                            lValidated := .F. 
                                            Help( ,, 'Pedido com bloqueio!',, "O item "+ SC6->C6_ITEM +"-"+ AllTrim( SC6->C6_DESCRI ) +;
                                                " referente ao pedido informado ( "+ cOrder +" ) está com bloqueio de "+iif( !Empty( SC9->C9_BLCRED ), "credito","estoque" )+"!",;
                                                1, 0, NIL, NIL, NIL, NIL, NIL,{ 'Para prosseguir, execute a rotina Liberação de '+; 
                                                iif( !Empty( SC9->C9_BLCRED ), "Credito","Estoque" ) +' para que o mesmo possa ser adicionado no processo de simulação de carga.' } )
                                        endif

                                    endif

                                    SC9->( DBSkip() )
                                EndDo

                            elseif ! Trim(SC6->C6_BLQ) == 'R '      // Verifica se não foi eliminado resíduo do produto
                                lValidated := .F.
                                Help( ,, 'Produto Não Liberado!',, "O item "+ SC6->C6_ITEM +"-"+ AllTrim( SC6->C6_DESCRI ) +;
                                    " referente ao pedido informado ( "+ cOrder +" ) não foi liberado!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                                    { 'Para prosseguir, execute a rotina Liberação de Pedido para que o mesmo possa ser adicionado no processo de simulação de carga.' } )
                            endif

                            SC6->( DBSkip() )
                        EndDo

                    endif
                
                else
                    lValidated := .F.
                    Help( ,, 'Pedido em Carga!',, "O pedido informado ( "+ cOrder +" ) já se encontra relacionado com o processo de simulação"+ SC5->C5_X_SIMUL +"!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                    { 'Selecione um pedido que ainda não esteja relacionado a um processo de simulação para poder prosseguir' } )
                endif
            else
                lValidated := .F.
                Help( ,, 'Pedido Não Liberado!',, "O pedido informado ( "+ cOrder +" ) não foi liberado!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                    { 'Um ou mais itens do pedido não foram liberados, por isso, é necessário executar o processo de liberação antes de prosseguir.' } )
            endif

        else
            lValidated := .F.
                Help( ,, 'Pedido finalizado!',, "O pedido informado ( "+ cOrder +" ) já se encontra finalizado!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                    { 'Selecione um pedido que ainda não esteja finalizado para poder prosseguir' } )
            
        endif
    else
        lValidated := .F.
        Help( ,, 'Pedido Não Existe!',, "Número do pedido inválido!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
            { 'Digite corretamente o pedido desejado ou utilize a lupa de pesquisa ou botão F3 para selecionar um pedido válido' } )
    endif

return lValidated
