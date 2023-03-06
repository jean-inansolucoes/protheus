#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function FLXPE04
    Ponto de entrada apos ajuste do pedido de venda
    @type  Function
    @author FLUXI
    @since 13/10/2021
    @version 1.0
    @return cRet, caracter, filtro
/*/
User Function FLXPE04()

    Local aArea     := GetArea()
    Local cPedido   := PARAMIXB[1]
    Local cSimula   := PARAMIXB[2]
    Local cQryUpd   := ""

    if !Empty(cSimula)
        cQryUpd := " UPDATE "+ RetSqlName("SC9")
        cQryUpd += " SET C9_X_SIMUL = '"+ cSimula +"'"
        cQryUpd += " WHERE C9_FILIAL = '"+ xFilial("SC9") +"'"
        cQryUpd += " AND C9_PEDIDO = '"+ cPedido +"'"
        cQryUpd += " AND D_E_L_E_T_ <> '*' "
                    
        If TCSQLEXEC(cQryUpd) < 0
            Alert("Ocorreu um erro na atualização da simulação." + TCSQLError())
        EndIf
    endif

    //Ajusta segunda unidade de medida
    DbSelectArea("SC6")
    SC6->(DbSetOrder(1))
    SC6->(DbGoTop())
    if dbSeek(xFilial("SC6")+cPedido)
        while SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cPedido
            dbSelectArea("SC9")
            SC9->(dbSetOrder(1))
            SC9->(dbGoTop())
            if dbSeek(xFilial("SC9")+SC6->C6_NUM)
                while SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == SC6->C6_NUM                             
                    if SC6->C6_PRODUTO == SC9->C9_PRODUTO .And. SC6->C6_ITEM == SC9->C9_ITEM .And. Empty(SC9->C9_NFISCAL)
                        RecLock("SC9",.F.)
					    SC9->C9_QTDLIB2 := SC6->C6_UNSVEN
                        SC9->(MsUnlock())

                        Exit
                    endIf
                    SC9->(dbSkip())
                endDo
            endIf
            SC6->(dbSkip())
        enddo
    endif

    RestArea(aArea)
    
Return 
