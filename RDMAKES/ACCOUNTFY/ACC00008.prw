#include "protheus.ch"

/*/{Protheus.doc} ACC00008
//Função que envia o json da tabela de log para integrations Synchro.
@author Fernando Oliveira Feres
@since 27/10/2020
@version 1.0
@return nil, nil
/*/
user function ACC00008(aDados, oProcess)    
    local lRet      := .T.
    local oWsAccEnv := nil
    local oACWSAUT  := nil
    local cAliasZKV := GetNextAlias()
    local cAliasZKY := GetNextAlias()
    local nCountZ4  := 0
    local cIdParte  := ""
    local cMsgErro  := ""
    local cCard     := aDados[1]

    oACWSAUT := ACCOUAUT():New()

    cQry := " SELECT ZKV_ID,ZKV_IDPART FROM " + RetSqlName("ZKV") + " ZKV "
    cQry += " WHERE ZKV.ZKV_ID BETWEEN '" + aDados[2] + "' AND '" + aDados[3] + "' "
    cQry += " AND ZKV.D_E_L_E_T_ = ' ' "

    IF SELECT("cAliasZKV") > 0
        cAliasZKV->(DbCloseArea())
    ENDIF

    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasZKV, .F., .T.)  

    dbselectarea(cAliasZKV)       
    
    if (cAliasZKV)->(!EOF()) 
        
        DBSelectArea("ZKV")    
        ZKV->(dbSetOrder(2))
        while (cAliasZKV)->(!EOF()) 
            
            cIdParte := alltrim(StrTran((cAliasZKV)->ZKV_IDPART, '"',''))   

            //Atualiza a data e hora na tabela de log
            if ZKV->(dbSeek( xFilial("ZKV") + (cAliasZKV)->ZKV_ID))
                RecLock("ZKV", .F.)
                ZKV->ZKV_DTINI3 := date()
                ZKV->ZKV_HRINI3 := time()
                ZKV->ZKV_ETAPA  := "3"
                ZKV->ZKV_USER   := UsrRetName(__cuserID)   
                ZKV->(MsUnLock())
            endif
            
            dbSelectArea("ZKY")
            ZKY->(dbSetOrder(2)) 

            cQry := " SELECT ZKY_IDLOG, ZKY_SEQ FROM "+RetSqlName("ZKY")+" "
            cQry += " WHERE ZKY_FILIAL = '"+xFilial("ZKY")+"' "
            cQry += " AND ZKY_IDLOG = '"+ZKV->ZKV_ID+"'  "
            cQry += " AND D_E_L_E_T_ <> '*' "

            IF SELECT("cAliasZKY") > 0
                cAliasZKY->(DbCloseArea())
            ENDIF

            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasZKY,.F.,.T.)
            Count To nCountZ4
            dbselectarea(cAliasZKY)
            (cAliasZKY)->(DbGoTop())

            if (cAliasZKY)->(!EOF())
                
                //oProcess:Set1Progress(1)
                oProcess:Inc1Progress('Processando as informações')
                oProcess:Inc1Progress('Processando as informações')   
                oProcess:Set3Progress(nCountZ4)                

                while (cAliasZKY)->(!EOF()) .and. alltrim((cAliasZKY)->ZKY_IDLOG) == alltrim((cAliasZKV)->ZKV_ID)
                    oProcess:Inc3Progress("Enviando...")  
                    If oProcess:Cancel()
                        lCancel:=.T.
                        Disarmtransaction()
                        return .F.
                    EndIf

                    if ZKY->(dbSeek( xFilial("ZKY") + (cAliasZKV)->ZKV_ID + (cAliasZKY)->ZKY_SEQ))
                        //atualiza a data e hora que iniciou o processamento
                        RecLock("ZKY", .F.)
                        ZKY->ZKY_DATAIN := date()
                        ZKY->ZKY_HORAIN := time()                        
                        ZKY->ZKY_LOG    := cMsgErro
                        MsUnLock()

                        if !Empty((cAliasZKY)->ZKY_SEQ)                
                                
                            oWsAccEnv := ACCOUENV():New()
                            cMsgErro := oWsAccEnv:processaTemp(ZKY->ZKY_MSGTRA,cIdParte,Val(ZKY->ZKY_SEQ),cCard)
                            if !Empty(cMsgErro)
                                
                                RecLock("ZKY", .F.)
                                ZKY->ZKY_DATAFI := date()
                                ZKY->ZKY_HORAFI := time()                        
                                ZKY->ZKY_LOG    := cMsgErro
                                MsUnLock()

                                MsgAlert("Erro ao realizar o envio das partes para Accountfy! Erro Api: " + cMsgErro + " - Favor entrar em contato com a Accountfy.","TOTVS")
                                return .F.                            
                            endif

                            cMsgErro := "200 - Ok"

                            RecLock("ZKY", .F.)
                            ZKY->ZKY_DATAFI := date()
                            ZKY->ZKY_HORAFI := time()                        
                            ZKY->ZKY_LOG     := cMsgErro
                            MsUnLock()
                        endif 
                    endif
                    (cAliasZKY)->( dbskip() )
                enddo
                (cAliasZKY)->(DBCloseArea())

                //atualiza data/hora do processamento de envio de partes
                if ZKV->(dbSeek( xFilial("ZKV") + (cAliasZKV)->ZKV_ID))
                    RecLock("ZKV", .F.)
                    ZKV->ZKV_DTFIN3 := date()
                    ZKV->ZKV_HRFIN3 := time() 
                    ZKV->(MsUnLock())
                endif    
                
                //Confirmando o processo
                cMsgErro := oWsAccEnv:confirmaProcesso(cIdParte,cCard)
                if cMsgErro <> "200 - Ok" 
                            
                    if !Empty(cMsgErro)
                        
                        if ZKY->(dbSeek( xFilial("ZKY") + (cAliasZKV)->ZKV_ID + (cAliasZKY)->ZKY_SEQ))
                            RecLock("ZKY", .F.)
                            ZKY->ZKY_DATAFI := date()
                            ZKY->ZKY_HORAFI := time()                        
                            ZKY->ZKY_LOG    := cMsgErro
                            MsUnLock()
                        endif

                        MsgAlert("Erro ao realizar o envio das partes para Accountfy! - Erro API: " + cMsgErro + " - Favor entrar em contato com a Accountfy.","TOTVS")
                        return .F.
                    endif
                endif
                //Finalizando a confirmação do processo
                
                RecLock("ZKV", .F.)
                ZKV->ZKV_DTFIN4 := date()
                ZKV->ZKV_HRFIN4 := time()
                MsUnLock() 
            else
                (cAliasZKY)->(DBCloseArea())
            endif
            
        (cAliasZKV)->(DbSkip())  
        endDo

        (cAliasZKV)->(DBCloseArea())
    else
      //  Msginfo("Não existe dados para a integração!")   
        lRet := .F.
    endif
    

return lRet
