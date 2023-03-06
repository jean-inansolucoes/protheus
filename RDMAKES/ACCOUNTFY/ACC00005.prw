#include 'protheus.ch'

/*/{Protheus.doc} ACC00005
Tela de log de integração
@type User Function
@author Fernando Oliveira Feres
@since 22/10/2020
@version 1.0
@param param, param_type, param_descr
@return return, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ACC00005()

Local oBrowse
Local aColCnx := AddFields()

    oBrowse := FWMBrowse():New()
    dbSelectArea("ZKV")
    oBrowse:SetAlias("ZKV")
    oBrowse:SetFields(aColCnx)

    oBrowse:AddLegend("ZKV_ETAPA $ '1'", "BLUE", "Requisitando")
    oBrowse:AddLegend("ZKV_ETAPA $ '2'", "ORANGE","Preparando dados")
    oBrowse:AddLegend("ZKV_ETAPA $ '3'", "PINK", "Enviando")
    oBrowse:AddLegend("ZKV_ETAPA $ '4'", "YELLOW", "Processando")
    oBrowse:AddLegend("ZKV_ETAPA $ '5'", "GREEN", "Concluído")


	oBrowse:SetDescription('Log de Integração')
    oBrowse:setMenuDef('ACC00004')
    oBrowse:setSeek(.t.)
    oBrowse:DisableDetails()
	oBrowse:ForceQuitButton()

return oBrowse

Static Function AddFields()

Local aColumns 	:= {}
Local cDic      := "SX3"
Local cAliasTmp := "SX3TST"
Local cFiltro   := ""

    cFiltro := "X3_CAMPO == 'ZKV_ID'     .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_LAYOUT' .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_ETAPA'  .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_DATAIN' .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_HORAIN' .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_HRINI2' .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_HRINI3' .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_HRINI4' .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_HRINI5' .OR." 
    cFiltro += "X3_CAMPO == 'ZKV_NUMPAR' "

    cAliasTmp := "SX3TST"
    
    OpenSXs(NIL, NIL, NIL, NIL, NIL, cAliasTmp, cDic, NIL, .F.)
    (cAliasTmp)->(DbSetFilter({|| &(cFiltro)}, cFiltro))
    (cAliasTmp)->(DbGoTop())
    
    While ! (cAliasTmp)->(Eof())
        If X3Uso( &("(cAliasTmp)->X3_USADO")) .And. cNivel >= &("(cAliasTmp)->X3_NIVEL")
        
            Aadd(aColumns, {&("(cAliasTmp)->X3_TITULO"),;
                    &("(cAliasTmp)->X3_CAMPO"),;
                    &("(cAliasTmp)->X3_PICTURE"),;
                    &("(cAliasTmp)->X3_TAMANHO"),;
                    &("(cAliasTmp)->X3_DECIMAL"),;   
                    &("(cAliasTmp)->X3_TIPO"),;
                    ".T."})     
                                        
        EndIf        
        
        (cAliasTmp)->(dbSkip())
    EndDo

Return(aColumns)
