#include 'protheus.ch' 

/*/{Protheus.doc} ACCOUAUT
Classe de autenticação.
@author Fernando Oliveira Feres
@since     26/10/2020
@version   1.0
/*/
class ACCOUAUT 

	method new(oWs) constructor        
    method getAuthToken()  

	data oRest          //Objeto do client rest
	data cSignature     //Siganture necessÃ¡rio para autenticaÃ§Ã£o no api 
	data cApiKey        //ApiKey 
    data aHeaderInt
    data cBody as Array
    data cEndToken 
    data oRestInt
    
endclass


/*/{Protheus.doc} new
Metodo construtor
@author Fernando Oliveira Feres
@since     10/06/2020
@version   1.0
/*/
method new(oWs) class ACCOUAUT	    
         
    ::oRest   := oWs 
RETURN

/*/{Protheus.doc} getAuthToken
//Gera a signature necessï¿½ria para a autenticaï¿½ï¿½o no
API e adiciona todos as informaï¿½ï¿½es necessï¿½rias
no header da requisiï¿½ï¿½o.
@author Fernando Oliveira Feres
@since     10/06/2020
@version 1.0
@return nil, nil
/*/
method getAuthToken(cEnd,cCliId,cCliSt) class ACCOUAUT
	
    Local cResponse     := {}
    Local aHeader       := {}
    Local cBody         := ""
    Local oJson         := ""
    Local cAccessToken  := ""

    aadd(aHeader, "Content-Type: application/x-www-form-urlencoded")    
    cBody := "client_id=" + cCliId + "&client_secret=" + cCliSt 

    ::oRest  := FWRest():New(cEnd)  
    ::oRest:SetPath("")
    ::oRest:SetPostParams(cBody)

    oJson := JsonObject():new()
    
    if (::oRest :Post(aHeader))            
        aadd(cResponse,{1,"OK - Conectado!"})

        oJson:fromJson(::oRest:GetResult())

		cAccessToken := oJson["accesToken"]

        DbSelectArea("ZKX")
        ZKX->(DbSetOrder(1))
        if ZKX->(DbSeek(xFilial("ZKX")+cCliId))
            dbGoTop()
            while ZKX->(!Eof() .and. Alltrim(ZKX->ZKX_CLIID) == cCliId)
                If Reclock("ZKX",.F.)
                    ZKX->ZKX_TOKEN := cAccessToken
                    ZKX->(MsUnLock())
                Endif    
                
                ZKX->(dbSkip())
            EndDo
        endif    
        ZKX->(dbClosearea())
              
    else
        if !Empty(::oRest:CRESULT)            
            aadd(cResponse,{2,::oRest:CRESULT})
        else
            aadd(cResponse,{2,"Error: " + ::oRest:CINTERNALERROR})            
        endif
    endif 
    
Return cResponse




