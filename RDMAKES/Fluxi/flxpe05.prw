#include "protheus.ch"

/*/{Protheus.doc} User Function FLXPE05
    Ponto de entrada para inclusao de botao
    outras acoes
    @type  Function
    @author FLUXI
    @since 16/10/2021
    @version 1.0
    @return aRet, vetor, rotina customizada
/*/
User Function FLXPE05()

    Local aArea     := GetArea()
    Local cTitulo   := "Enviar Workflow"
    Local cFuncao   := "U_CONCLU01()"
    Local aRet      := {}

    Aadd(aRet, cTitulo)
    Aadd(aRet, cFuncao)

    RestArea(aArea)
    
Return aRet


User Function CONCLU01()

 MsgInfo("Concluido a separação pode montar a carga!!", "Aviso")


Return ( NIL )
