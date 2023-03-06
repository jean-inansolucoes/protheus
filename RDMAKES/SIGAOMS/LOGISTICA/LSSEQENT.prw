#include 'totvs.ch'
#include 'topconn.ch'

#define ALIGN_LEFT      1   
#define ALIGN_RIGHT     2
#define ALIGN_CENTER    3

/*/{Protheus.doc} LSSEQENT
Função para ajustar sequência de entrega dos pedidos do processo de simulação informado
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/29/2022
@param cSimula, character, ID do processo de simulação
/*/
User Function LSSEQENT( cSimula )
    
    local aArea     := getArea()
    Local oBtnDown  as object
    Local oBtnUp    as object
    Local oFntCab   := TFont():New("Tahoma",,020,,.F.,,,,,.F.,.F.)
    Local oGrpGrid  as object
    Local oGrpTit   as object
    Local oLblSeq   as object
    local oDlgSeq   as object
    local oTab      as object
    local aFields   as array
    Local cQuery    as character
    local cSeq      := "0000" as character
    local oBrw      as object
    local bOk       := {|| save(cSimula), lConfirm := .T., oDlgSeq:End() }
    local bCancel   := {|| oDlgSeq:End() }
    local bChgLine  := {|| SetFocus(nHWNDup), oBrw:SetFocus() }
    local aButtons  := {} as array
    local acampos   := {} as array
    local lFound    := .F. as logical
    local aSize     := MSAdvSize()
    local nHor      := (aSize[5]/2)*0.9
    local nHWNDup   := 0 as numeric
    local cNewSeq   := "" as character
    local lConfirm  := .F.

    default cSimula := ""     

    if Empty( cSimula )
        restArea( aArea )
        return nil
    endif

    // Define os campos da tabela temporária
    aFields := {}
    aAdd( aFields, { "SEQUENCIA", "C", TAMSX3("C5_X_SQENT")[1], TAMSX3("C5_X_SQENT")[2] } )
    aAdd( aFields, { "LACRE"    , "C", TAMSX3("C5_X_LACRE")[1], TAMSX3("C5_X_LACRE")[2] } )
    aAdd( aFields, { "CLIENTE"  , "C", TAMSX3("C5_CLIENT" )[1], TAMSX3("C5_CLIENT" )[2] } )
    aAdd( aFields, { "LOJA"     , "C", TAMSX3("C5_LOJAENT")[1], TAMSX3("C5_LOJAENT")[2] } )
    aAdd( aFields, { "FANTASIA" , "C", TAMSX3("A1_NREDUZ" )[1], TAMSX3("A1_NREDUZ" )[2] } )
    aAdd( aFields, { "RAZAO"    , "C", TAMSX3("A1_NOME"   )[1], TAMSX3("A1_NOME"   )[2] } )
    aAdd( aFields, { "ENDERECO" , "C", TAMSX3("A1_END"    )[1], TAMSX3("A1_END"    )[2] } )
    aAdd( aFields, { "BAIRRO"   , "C", TAMSX3("A1_BAIRRO" )[1], TAMSX3("A1_BAIRRO" )[2] } )
    aAdd( aFields, { "MUNICIPIO", "C", TAMSX3("A1_MUN"    )[1], TAMSX3("A1_MUN"    )[2] } )
    aAdd( aFields, { "ESTADO"   , "C", TAMSX3("A1_EST"    )[1], TAMSX3("A1_EST"    )[2] } )
    aAdd( aFields, { "PEDIDOS"  , "C",                      30,                      00 } )

    aCampos := {}
    aAdd( aCampos, {{ 'Seq.Ent.' , &('{|| SEQUENCIA }'), 'C', '@!', ALIGN_LEFT, TamSX3("C5_X_SQENT" )[01], TamSX3("C5_X_SQENT"  )[02] }} )
    aAdd( aCampos, {{ 'Lacre'    , &('{|| LACRE     }'), 'C', '@!', ALIGN_LEFT, TamSX3("C5_X_LACRE" )[01], TamSX3("C5_X_LACRE"  )[02], .T. /*lCanEdit*/,{|| .T. } /*bValid*/ }} )
    aAdd( aCampos, {{ 'Cliente'  , &('{|| CLIENTE   }'), 'C', '@!', ALIGN_LEFT, TamSX3("C5_CLIENT"  )[01], TamSX3("C5_CLIENT"   )[02] }} )
    aAdd( aCampos, {{ 'Loja'     , &('{|| LOJA      }'), 'C', '@!', ALIGN_LEFT, TamSX3("C5_LOJAENT" )[01], TamSX3("C5_LOJAENT"  )[02] }} )
    aAdd( aCampos, {{ 'Fantasia' , &('{|| FANTASIA  }'), 'C', '@!', ALIGN_LEFT, TamSX3("A1_NREDUZ"  )[01], TamSX3("A1_NREDUZ"   )[02] }} )
    aAdd( aCampos, {{ 'Bairro'   , &('{|| BAIRRO    }'), 'C', '@!', ALIGN_LEFT, TamSX3("A1_BAIRRO"  )[01], TamSX3("A1_BAIRRO"   )[02] }} )
    aAdd( aCampos, {{ 'Mun.'     , &('{|| MUNICIPIO }'), 'C', '@!', ALIGN_LEFT,                        20, TamSX3("A1_MUN"      )[02] }} )
    aAdd( aCampos, {{ 'UF'       , &('{|| ESTADO    }'), 'C', '@!', ALIGN_LEFT, TamSX3("A1_EST"     )[01], TamSX3("A1_EST"      )[02] }} )
    aAdd( aCampos, {{ 'Pedidos'  , &('{|| PEDIDOS   }'), 'C', '@!', ALIGN_LEFT,                        30, 00 }} )

    // Se já existir uma tabela temporária criada, força o fechamento para evitar falha durante processamento
    if Select( "ENTREGAS" ) > 0
        ENTREGAS->( DBCloseArea() )
    endif

    // Cria tabela temporária em banco
    oTab := FWTemporaryTable():New( "ENTREGAS", aFields )
    oTab:AddIndex( "01", { "SEQUENCIA", "LACRE" } )
    oTab:AddIndex( "02", { "CLIENTE", "LOJA" } )
    oTab:Create()

    // Busca os pedidos relacionados com o processo
    cQuery := "SELECT * FROM ( "
    cQuery += "SELECT CASE WHEN C5.C5_X_SQENT = '    ' THEN '9999' ELSE C5.C5_X_SQENT END C5_X_SQENT, "
    cQuery += "       C5.C5_X_LACRE, C5.C5_NUM, C5.C5_CLIENT, C5.C5_LOJAENT, A1.A1_NREDUZ, A1.A1_NOME, "
    cQuery += "       A1.A1_END, A1.A1_BAIRRO, A1.A1_MUN, A1.A1_EST "
    cQuery += "FROM "+ retSqlname( "SC5" ) +" C5 "

    // Clientes
    cQuery += "INNER JOIN "+ retSqlName( "SA1" ) +" A1 "
    cQuery += " ON A1.A1_FILIAL  = '"+ FWxfilial( "SA1" ) +"' "
    cQuery += "AND A1.A1_COD     = C5.C5_CLIENT "
    cQuery += "AND A1.A1_LOJA    = C5.C5_LOJAENT "
    cQuery += "AND A1.D_E_L_E_T_ = ' ' "

    cQuery += "WHERE C5.C5_FILIAL  = '"+ FWxFilial( "SC5" ) +"' "
    cQuery += "  AND C5.C5_X_SIMUL = '"+ cSimula +"' "
    cQuery += "  AND C5.D_E_L_E_T_ = ' ' "
    cQuery += ") QRY "
    cQuery += "ORDER BY QRY.C5_X_SQENT, QRY.C5_CLIENT, QRY.C5_LOJAENT "

    DBUseArea( .T. /* lNew */, "TOPCONN" /* cDriver */, TcGenQry(,,cQuery), "TEMP" /* cAlias */, .F. /* lShared */, .T. /* lReadOnly */ )
    if ! TEMP->( EOF() )

        // Abre a tabela temporária e posiciona no índice 2
        DBSelectArea( "ENTREGAS" )
        ENTREGAS->( DbSetOrder( 2 ) )       // CLIENTE + LOJA

        while ! TEMP->( EOF() ) 
            
            lFound := ENTREGAS->( DBSeek( TEMP->C5_CLIENT + TEMP->C5_LOJAENT ) )
            RecLock( "ENTREGAS", ! lFound )
                if ! lFound
                    if Empty( TEMP->C5_X_SQENT ) .or. TEMP->C5_X_SQENT == '9999'
                        cSeq := Soma1( cSeq )
                    else
                        cSeq := TEMP->C5_X_SQENT
                    endif
                    ENTREGAS->SEQUENCIA := cSeq
                    ENTREGAS->LACRE     := TEMP->C5_X_LACRE
                    ENTREGAS->CLIENTE   := TEMP->C5_CLIENT
                    ENTREGAS->LOJA      := TEMP->C5_LOJAENT
                    ENTREGAS->FANTASIA  := Trim(TEMP->A1_NREDUZ)
                    ENTREGAS->MUNICIPIO := Trim(TEMP->A1_MUN)
                    ENTREGAS->ESTADO    := TEMP->A1_EST
                    ENTREGAS->BAIRRO    := Trim(TEMP->A1_BAIRRO)
                endif
                ENTREGAS->PEDIDOS   := AllTrim(ENTREGAS->PEDIDOS) + iif( !Empty(Trim(ENTREGAS->PEDIDOS)),",","") + TEMP->C5_NUM
            ENTREGAS->( MsUnlock() )
            
            TEMP->( DBSkip() )

        enddo
    endif
    TEMP->( DBCloseArea() )

    // Reorganiza os registros da tabela temporária para virem por órdem de sequência
    ENTREGAS->( DBSetOrder( 1 ) )       // SEQUENCIA + LACRE

    // Exibe Dialog para interação do usuário com a ordenação das entregas
    DEFINE MSDIALOG oDlgSeq TITLE "SIMULAÇÃO DE CARGA - "+ cSimula FROM 000, 000  TO 560, aSize[5]*0.9 COLORS 0, 16777215 PIXEL

    @ 034, 004 GROUP oGrpTit  TO 070, nHor-2 OF oDlgSeq COLOR 0, 16777215 PIXEL
    @ 074, 004 GROUP oGrpGrid TO 276, nHor-30 OF oDlgSeq COLOR 0, 16777215 PIXEL

    @ 050, (nHor/2)-60 SAY oLblSeq PROMPT "SEQUENCIA DE ENTREGA" SIZE 120, 018 OF oDlgSeq FONT oFntCab COLORS 0, 16777215 PIXEL
    
    @ 074, nHor-26 BUTTON oBtnUp   PROMPT "Cima"   SIZE 024, 024 OF oDlgSeq ACTION {|| cNewSeq := actionUp(), oBrw:Refresh(), ENTREGAS->(DbGoTop()), ENTREGAS->(DBSeek(cNewSeq)) } PIXEL WHEN ENTREGAS->SEQUENCIA >= StrZero(2,TAMSX3("C5_X_SQENT")[1])
    nHWNDup := oBtnUp:HWND
    @ 102, nHor-26 BUTTON oBtnDown PROMPT "Baixo"  SIZE 024, 024 OF oDlgSeq ACTION {|| cNewSeq := actionDown(), oBrw:Refresh(), ENTREGAS->(DBGoTop()), ENTREGAS->(DBSeek(cNewSeq)) } PIXEL WHEN ENTREGAS->SEQUENCIA < cSeq
    
    // Define montagem do grid dos pedidos de retira
    oBrw := FWBrowse():New( oGrpGrid )
    oBrw:SetDataTable( .T. )
    oBrw:SetAlias( "ENTREGAS" )
    oBrw:DisableReport()
    oBrw:SetClrAlterRow( RGB(220,220,220) )
    aEval( aCampos, {|x| oBrw:SetColumns( aClone( x ) ) } )
    oBrw:SetEditCell( .T., {|| .T. /* bValid */ })
    oBrw:aColumns[02]:lEdit := .T.
    oBrw:aColumns[02]:cReadVar := "ENTREGAS->LACRE"
    oBrw:SetChange( bChgLine )
    oBrw:Activate()

    ACTIVATE MSDIALOG oDlgSeq CENTERED ON INIT EnchoiceBar( oDlgSeq, bOk, bCancel,nil, aButtons ) 

    // Encerra a tabela temporária e fecha o alias
    oTab:Delete()

Return lConfirm

/*/{Protheus.doc} save
Função responsável pelo salvamento da ordenação e dos dados dos lacres informados pelo operador
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/29/2022
@param cSimula, character, ID do processo de simulação
/*/
static function save( cSimula )
    
    local aArea := getArea()
    
    ENTREGAS->( DBGoTop() )
    while !ENTREGAS->( EOF() )

        // Atribui a sequência de entrega aos pedidos da SC5
        DBSelectArea( "SC5" )
        SC5->( DBOrderNickName( "SIMULACAO" ) )
        if SC5->( DBSeek( FWxFilial( "SC5" ) + cSimula + ENTREGAS->CLIENTE + ENTREGAS->LOJA ) )
            while !SC5->( EOF() ) .and. SC5->C5_FILIAL + SC5->C5_X_SIMUL + SC5->C5_CLIENT + SC5->C5_LOJAENT == FWxFilial( "SC5" ) + cSimula + ENTREGAS->CLIENTE + ENTREGAS->LOJA
                
                RecLock( "SC5", .F. )
                SC5->C5_X_SQENT := ENTREGAS->SEQUENCIA
                SC5->C5_X_LACRE := ENTREGAS->LACRE
                SC5->( MsUnlock() )
                
                SC5->( DBSkip() )
            enddo
        endif

        ENTREGAS->( DBSKip() )
    enddo

    restARea( aArea )
return 

/*/{Protheus.doc} actionUp
Ação do botão que joga sequência de entrega para cima
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/29/2022
@return character, cNewSeq
/*/
static function actionUp()
    
    local cSeqReg := ENTREGAS->SEQUENCIA
    local cNewSeq := StrZero(val( cSeqReg )-1, TAMSX3("C5_X_SQENT")[1] )
    
    // Atribui um conteúdo intermediário à sequencia do registro atual
    RecLock( "ENTREGAS", .F. )
    ENTREGAS->SEQUENCIA := "ZZZZ"
    ENTREGAS->( MsUnlock() )

    // Atribui a sequência do registro atual ao registro acima dele
    ENTREGAS->( DBSetOrder(1) )
    ENTREGAS->( DBSeek( cNewSeq ) )
    RecLock( "ENTREGAS", .F. )
    ENTREGAS->SEQUENCIA := cSeqReg
    ENTREGAS->( MsUnlock() )

    // Atribui a sequência do registro acima ao registro atual
    ENTREGAS->( DBSeek( "ZZZZ" ) )
    RecLock( "ENTREGAS", .F. )
    ENTREGAS->SEQUENCIA := cNewSeq
    ENTREGAS->( MsUnlock() )

return cNewSeq

/*/{Protheus.doc} actionDown
Ação do botão que joga sequencia para baixo
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/29/2022
@return character, cNewSeq
/*/
static function actionDown()
    
    local cSeqReg := ENTREGAS->SEQUENCIA
    local cNewSeq := Soma1( cSeqReg )

    // Atribui um conteúdo intermediário à sequencia do registro atual
    RecLock( "ENTREGAS", .F. )
    ENTREGAS->SEQUENCIA := "ZZZZ"
    ENTREGAS->( MsUnlock() )

    // Atribui a sequência do registro atual ao registro acima dele
    ENTREGAS->( DBSetOrder(1) )
    ENTREGAS->( DBSeek( cNewSeq ) )
    RecLock( "ENTREGAS", .F. )
    ENTREGAS->SEQUENCIA := cSeqReg
    ENTREGAS->( MsUnlock() )

    // Atribui a sequência do registro acima ao registro atual
    ENTREGAS->( DBSeek( "ZZZZ" ) )
    RecLock( "ENTREGAS", .F. )
    ENTREGAS->SEQUENCIA := cNewSeq
    ENTREGAS->( MsUnlock() )

return cNewSeq
