#Include 'Protheus.ch'
#Include 'rwmake.ch'

/*/{Protheus.doc} User Function MT680EST
    Ponto entrada estorno producao
	@type  Function
	@author ICMAIS
	@since 19/08/2020
	@version 1.0
	@return nil, nil, nil
/*/
User Function MT680EST()
    Local aArea := GetArea()
    Local nAcao := PARAMIXB[1]
    Local lRet  := .F.

    //Confirmou estorno
    If nAcao == 2 
        dbSelectArea("SZA")
        SZA->(dbGoTop())
        If dbSeek(xFilial("SZA")+SH6->H6_OP)
            RecLock("SZA",.F.)
            SZA->ZA_STATUS := "A"
            SZA->(MsUnlock()) 
        EndIf
        lRet  := .T.
    Else 
        lRet  := .F.
    EndIf

    RestArea(aArea)
Return lRet
