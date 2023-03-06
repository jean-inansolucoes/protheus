#include "protheus.ch"

/*/{Protheus.doc} ACC00007
//Rotina que execução a criação de JSON.
@author Fernando Oliveira Feres
@since 26/10/2020
@version 1.0
@return nil, nil
/*/
user function ACC00007(oBrowse2, lDireto, aDados)
    
    Local oAccoread := ACCOREAD():New()
    Local lMsg := .F.   
    Local aParamBox := {}
    Local aRet      := {}

    if !lDireto
        aAdd(aParamBox,{1, "Card: "     , space(06)     , "", "", "ZKX" , "", 0, .F.})
        aAdd(aParamBox,{1, "Id De: "     , space(06)     , "", "", "ZKV" , "", 0, .F.})
        aAdd(aParamBox,{1, "Id Ate: "    , space(06)     , "", "", "ZKV" , "", 0, .F.})
                
        if ParamBox(aParamBox,"Informe o parametro",@aRet,,,,,,,"ACC00007", .T.) 

            if MsgYesNo( "Deseja gerar o envio das partes Id de: " + aRet[2] + " até: " + aRet[3] + " para o card " + aRet[1] + "?" )	
                        
                Begin Transaction
                    oProcess := ACCProgress():New({|| lMsg := oAccoread:execInt(aRet, oProcess)},"Processando as informações")
                    oProcess:Activate()
                end Transaction

                if lMsg
                    //Refresh na tabela de Log e Dashboard
                    oBrowse2:Refresh()                
                    MsgInfo("Concluído com sucesso!")
                endif
            else
                return 
            endif 
        endif
    else
        Begin Transaction
            oProcess := ACCProgress():New({|| lMsg := oAccoread:execInt(aDados, oProcess)},"Processando as informações")
            oProcess:Activate()
        end Transaction

        if lMsg
            //Refresh na tabela de Log e Dashboard
            oBrowse2:Refresh()                
            MsgInfo("Concluído com sucesso!")
        endif
    endif
    
return 

