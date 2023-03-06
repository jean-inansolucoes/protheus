#include "Protheus.ch"
#include "Totvs.ch"
#include "parmtype.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "FWMVCDEF.ch"
#include "RestFUL.ch"     
#include "json.ch"

/*/{Protheus.doc} ACC00009
//
@author Fernando Oliveira Feres
@since 01/12/2020
@version 1.0
@return nil, nil
/*/
user function ACCOU09(aDados)
    Local oWsAccEnv := ACCOUENV():New()
    Local cQry      := ""
    Local lRet      := .F.
    Local cAliasZKV := GetNextAlias() 
    Local bObject 	:= {|| JsonObject():New()}
	Local oJson   	:= Eval(bObject)  
    Local cCard     := aDados[1]
    
    default cFilPlesk := "01001"
    default cEmpPlesk := "01" 
    conout("executando via JOB")   

    cQry := " SELECT ZKV_ID, ZKV_IDPART FROM " + RetSqlName("ZKV") + " ZKV "
    cQry += " WHERE ZKV.ZKV_ID BETWEEN '" + aDados[2] + "' AND '" + aDados[3] + "' "
    cQry += " AND ZKV.D_E_L_E_T_ <> '*' "
    cQry += " AND ZKV.ZKV_ETAPA = '4' "

    IF SELECT("cAliasZKV") > 0
        cAliasZKV->(DbCloseArea())
    ENDIF

    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasZKV, .F., .T.)  

    if (cAliasZKV)->(!EOF())
        dbSelectArea("ZKV")
        ZKV->(dbSetOrder(2))
        if !Empty((cAliasZKV)->ZKV_IDPART)
            while (cAliasZKV)->(!EOF())
                if ZKV->(dbSeek( xFilial("ZKV") + (cAliasZKV)->ZKV_ID))
                    RecLock("ZKV", .F.)
                    ZKV->ZKV_DTINI5 := date()
                    ZKV->ZKV_HRINI5 := time()
                    ZKV->ZKV_ETAPA := "5" 
                    ZKV->(MsUnLock())
                endif

                //verificar se o status esta finalizado
                oJson := oWsAccEnv:verificaStatus(Alltrim((cAliasZKV)->ZKV_IDPART),cCard)

                if valType(oJson) == 'J'

                    if alltrim(oJson['loadState']) == "FINALIZED"
                        if ZKV->(dbSeek( xFilial("ZKV") + (cAliasZKV)->ZKV_ID))
                            RecLock("ZKV", .F.)
                            ZKV->ZKV_ETAPA := "5"
                            ZKV->ZKV_DTFIN5 := date()
                            ZKV->ZKV_HRFIN5 := time() 
                            MsUnLock()
                        endif 
                    endif

                    lRet := .T.
                else
                    conout("Erro no retorno da API de Status.")
                    return .F.
                endif                   

                (cAliasZKV)->(DBSkip())
            enddo
        endif
    endif
   
return lRet
