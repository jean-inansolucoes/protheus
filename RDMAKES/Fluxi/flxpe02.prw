#include "protheus.ch"

/*/{Protheus.doc} User Function FLXPE02
    Ponto de entrada realiza filtro customizado
    na SC9 liberacao
    @type  Function
    @author FLUXI
    @since 31/08/2021
    @version 1.0
    @return cRet, caracter, filtro
/*/
User Function FLXPE02()

    Local aArea := GetArea()

    cRet := " AND SC9.C9_BLEST = 'SP' "

   // MsgInfo("PONTO ENTRADA FLXPE02()"+ cRet , "Aviso")

    RestArea(aArea)
    
Return cRet
