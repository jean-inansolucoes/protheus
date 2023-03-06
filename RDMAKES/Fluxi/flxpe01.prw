#include "protheus.ch"

/*/{Protheus.doc} User Function FLXPE01
    Ponto de entrada para realizar validacoes
    conforme necessidade apos priorizar pedido
    @type  Function
    @author Fluxi
    @since 15/07/2021
    @version 1.0
    @param PARAMIXB[1], caracter, codigo pedido
    @param PARAMIXB[2], numerico, tipo de operacao
/*/
User Function FLXPE01()

    Local aArea     := GetArea()
    Local cCodPed   := PARAMIXB[1]
    Local nTipOper  := PARAMIXB[2]
    Local cFlag     := ""
    local cSimula   := "" as character

    Do Case
    Case nTipOper == 1
        cFlag := "SP"
    Otherwise
        cFlag := ""
    EndCase

    DbSelectArea("SC9")
    SC9->(DbSetOrder(1))
    SC9->(dbGoTop())
    if dbSeek(xFilial("SC9")+cCodPed)
        cSimula := SC9->C9_X_SIMUL
        while SC9->(!Eof()) .And. SC9->C9_PEDIDO == cCodPed
            if Empty(SC9->C9_NFISCAL) .And. Empty(SC9->C9_SERIENF)
                Reclock("SC9",.F.)
                SC9->C9_BLEST := cFlag
                SC9->(MsUnlock())               
            endif

            SC9->(dbSkip())
        end
        // Valida se terminou de fazer a separação 
        if !Empty( cSimula ) .and. AllDone( cSimula )
            U_FWSEP001( xFilial("ZN1"), cSimula, "01", 2 )
        endif
    endif

    RestArea(aArea)

Return 

/*/{Protheus.doc} allDone
Função que verifica 
@type function
@version 1.0
@author ICmais
@since 26/05/2022
@param cSimula, character, ID do processo de simulação de carga
@return logical, lAllDone
/*/
static function AllDone( cSimula )
    
    local lAllDone := .T. as logical
    local cQuery   := "" as character

    // Query para ler a quantidade de itens pendentes de separação para a simulação de carga na qual pertence o pedido que está sendo apontado
    cQuery := "SELECT COUNT(*) QTDEPEND FROM "+ RetSqlName( "SC9" ) +" C9 "
    cQuery += "WHERE C9.C9_FILIAL  = '"+ FWxFilial( "SC9" ) +"' "
    cQuery += "  AND C9.C9_X_SIMUL = '"+ cSimula +"' "
    cQuery += "  AND C9.C9_NFISCAL = '"+ Space( TAMSX3("C9_NFISCAL")[1] ) +"' "
    cQuery += "  AND C9.C9_BLEST   = 'SP' "
    cQuery += "  AND C9.D_E_L_E_T_ = ' ' "

    DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TEMP", .F. /* lShared */, .T. /* lReadOnly */ ) 
    lAllDone := TEMP->QTDEPEND == 0     // nenhuma pendência significa que tudo já foi finalizado
    TEMP->( DBCloseArea() )

return lAllDone


