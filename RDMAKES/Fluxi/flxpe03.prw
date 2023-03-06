#include "protheus.ch"

/*/{Protheus.doc} User Function FLXPE03
    Ponto de entrada para substituir campos de carga
    @type  Function
    @author FLUXI
    @since 11/10/2021
    @version 1.0
    @return cRet, caracter, filtro
/*/
User Function FLXPE03()

    Local aArea     := GetArea()
    Local cCargaDe  := PARAMIXB[1][1]
    Local cCargaAte := PARAMIXB[1][2]
    Local cRet      := ""

    
    cRet := "  AND SC9.C9_X_SIMUL BETWEEN '"+ cCargaDe +"' AND '"+ cCargaAte +"' "

    //MsgInfo("PONTO ENTRADA FLXPE03()"+ cRet , "Aviso")

    RestArea(aArea)
    
Return cRet
