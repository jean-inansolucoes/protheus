#include 'protheus.ch'
#include 'parmtype.ch'
#Include "totvs.ch"
#include 'restful.ch'

/*/{Protheus.doc} ACCOUENV
Webservice responsável por acionar a API Integração. 
@author Fernando Oliveira Feres
@since     27/10/2020
@version   1.0

/*/
class ACCOUENV

	method new() constructor 
	method processaTemp()
    method confirmaProcesso()
    method postId()
    method putId()
    method verificaStatus()    
	
	data aHeader		
	data cId
	data cEndereco
	data oJson 
	data oSYUTILS	
	data cPath
	data oRestClient

endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fernando Oliveira Feres
@since     27/10/2020
@version   1.0
/*/
method new() class ACCOUENV
	local oACCOUAUT := nil
	
	::aHeader := {}
	oACCOUAUT := ACCOUAUT():New(@Self)	
return

/*/{Protheus.doc} processaTemp
//Metodo responsavel por processar json da tabela de log.
@author Fernando Oliveira Feres
@since     27/10/2020
@version 1.0
@param cJSON, characters, json.
/*/
method processaTemp(cJSON, cId, nPart, cCard) class ACCOUENV
	
	Local cResponse	:= ""	
    Local aHeader   := {}
    Local oAccAut   := ACCOUAUT():New() 
    Local clVol     := .T.
    Private cPath   := ""
    Private cUrl    := ""
    Private cToken  := ""
    Private cParCli := cCard
    Private cEndAPI := ""
    Private cCliSec := ""
  
    cUrl    := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_URL")) 
    cEndAPI := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_ENDAPI"))
    cCliSec := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLISEC"))
    cCliId  := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLIID"))

    //oAccAut:getAuthToken(cEndAPI,cCliId,cCliSec)

    //cToken := POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_TOKEN")
    cToken := POSICIONE("ZKX",1,xFilial("ZKX")+cCliId,"ZKX_TOKEN")
      
    aAdd(aHeader, "Content-Type: application/json")     
    aAdd(aHeader, "Authorization: Bearer " + cToken)  
		
	cPath := "/v1/ledger/load/"+ cId +"/upload/" + cValToChar(nPart)

    ::oRestClient := FWRest():New(cUrl) 
    ::oRestClient:SetPath(cPath) 

    ::oRestClient:SetPostParams(EncodeUtf8(cJSON))    
    ::oRestClient:Post(aHeader)
    
    if self:oRestClient:ORESPONSEH:CSTATUSCODE == "200"
        cResponse := ""

        If RecLock("ZKV", .F.)
            ZKV->ZKV_DTINI4 := date()
            ZKV->ZKV_HRINI4 := time() 
            MsUnLock()
        Endif           
             
    else		
        cResponse := ::oRestClient:GetLastError()      
        
        If RecLock("ZKV", .F.)
            ZKV->ZKV_DTFIN3 := date()
            ZKV->ZKV_HRFIN3 := time()
            ZKV->ZKV_ETAPA := "2"
            ZKV->ZKV_LOG    := cResponse
            MsUnLock()
        Endif          

        clVol := .F.
    endif

	freeObj(::oRestClient)
return cResponse

/*/{Protheus.doc} confirmaProcesso
//Metodo responsavel por processar json da tabela de log.
@author Fernando Oliveira Feres
@since     27/10/2020
@version 1.0
@param cJSON, characters, json.
/*/
method confirmaProcesso(cId,cCard) class ACCOUENV
	
	Local cResponse	:= ""	
    Local aHeader   := {}
    Local oAccAut   := ACCOUAUT():New() 
    Local clVol     := .T.
    Private cPath   := ""
    Private cUrl    := ""
    Private cToken  := ""
    Private cParCli := cCard
    Private cEndAPI := ""
    Private cCliSec := ""
  
    cUrl    := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_URL")) 
    cEndAPI := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_ENDAPI"))
    cCliSec := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLISEC"))
    cCliId  := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLISEC"))

    oAccAut:getAuthToken(cEndAPI,cCliId,cCliSec)

    cToken := POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_TOKEN")

    aAdd(aHeader, "Authorization: Bearer " + cToken)
    aAdd(aHeader, "Content-Type: application/json")    
		
	cPath := "/v1/ledger/load/"+ cId +"/process"

    ::oRestClient := FWRest():New(cUrl) 
    ::oRestClient:SetPath(cPath) 
    ::oRestClient:Put(aHeader)   

    if self:oRestClient:ORESPONSEH:CSTATUSCODE == '200'
        cResponse := ""
        
        If RecLock("ZKV", .F.)
            ZKV->ZKV_DTINI4 := date()
            ZKV->ZKV_HRINI4 := time()
            ZKV->ZKV_ETAPA   := "4"
            MsUnLock()
        Endif
        clVol := .T.
    else
        cResponse := ::oRestClient:GetLastError()
        
       If RecLock("ZKV", .F.)
            ZKV->ZKV_DTFIN4 := date()
            ZKV->ZKV_HRFIN4 := time()
            ZKV->ZKV_ETAPA := "3"
            ZKV->ZKV_LOG    := cResponse
            MsUnLock()
        Endif 
        clVol := .F.
    endif  
	freeObj(::oRestClient)
return cResponse

method postId(cCod,cNPartes,cDate,cCard) class ACCOUENV

    Local lRet      := .F.
    Local aHeader   := {}
    Local oAccAut   := ACCOUAUT():New() 
    Local cMsg      := ""
    Private cPath   := ""
    Private cJSON   := ""
    Private cUrl    := ""
    Private cCNPJ   := ""
    Private cToken  := ""
    Private cParCli := cCard
    Private cEndAPI := ""
    Private cCliSec := ""
    Private cIdACC  := ""
    
 
    cUrl    := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_URL")) 
    cCNPJ   := TRANSFORM(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CNPJ"),"@R 99.999.999/9999-99")
    cCliId  := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLIID"))
    cEndAPI := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_ENDAPI"))
    cCliSec := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLISEC"))

    oAccAut:getAuthToken(cEndAPI,cCliId,cCliSec)

    cToken := POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_TOKEN")
    
    cMsg := ""

    dbSelectArea("ZKV")
	ZKV->(dbSetOrder(2))
	if ZKV->(dbSeek( xFilial("ZKV") + cCod))
        aAdd(aHeader, "Authorization: Bearer " + cToken)
        aAdd(aHeader, "accept: application/json")
        aAdd(aHeader, "Content-Type: application/json")        

        cPath := "/v1/ledger/load/new"
        cJSON := '{ "clientId": "'+cCliId+'", "cnpj": "'+cCNPJ+'", "numberOfTotalParts": '+ cValToChar(cNPartes)+', "yearMonth": "'+cDate+'" }'
			
        ::oRestClient := FWRest():New(cUrl) 
		::oRestClient:SetPath(cPath) 

		::oRestClient:SetPostParams(EncodeUtf8(cJSON))
		::oRestClient:Post(aHeader)
		
		if ::oRestClient:ORESPONSEH:CSTATUSCODE == "201"
            cIdACC := ::oRestClient:GetResult()			
			If RecLock("ZKV", .F.)
                ZKV->ZKV_NUMPAR := cNPartes
                ZKV->ZKV_IDPART  := StrTran(cIdACC, '"','')           
                MsUnLock()
            Endif 

            cMsg := ""
            lRet := .T.
        else
            cMsg := ::oRestClient:GetLastError()
        
            If RecLock("ZKV", .F.)		
                ZKV->ZKV_ETAPA   := "1"           
                ZKV->ZKV_LOG     := cMsg
                MsUnLock()
            Endif    

            lRet := .F.
		endif      
    endIf  
return cMsg


method putId(cCod,cIdPart) class ACCOUENV
    Local lRet := .F.
    Local aHeader := {}
    Local oAccAut   := ACCOUAUT():New() 
    Local cMsg := ""
    Private cPath := ""
    Private cJSON := ""
    Private cUrl  := ""    
    Private cToken := ""
    Private cParCli := cCard
    Private cEndAPI := ""
    Private cCliSec := ""
    Private cIdACC  := ""
    
 
    cUrl    := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_URL"))     
    cEndAPI := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_ENDAPI"))
    cCliSec := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLISEC"))
    cCliId  := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLIID"))

    oAccAut:getAuthToken(cEndAPI,cCliId,cCliSec)

    cToken := POSICIONE("ZKX",1,xFilial("ZKX")+cCliId,"ZKX_TOKEN")
    
    cMsg := ""

    dbSelectArea("ZKV")
	ZKV->(dbSetOrder(2))
	if ZKV->(dbSeek( xFilial("ZKV") + cCod))
        aAdd(aHeader, "Authorization: Bearer " + cToken)
        aAdd(aHeader, "accept: application/json")
        aAdd(aHeader, "Content-Type: application/json")        

        cPath := "/v1/ledger/load/" + alltrim(cIdPart) + "/cancel"         
			
        ::oRestClient := FWRest():New(cUrl) 
		::oRestClient:SetPath(cPath) 
				
		if ::oRestClient:Put(aHeader)            
			If RecLock("ZKV", .F.)
                ZKV->ZKV_NUMPAR := 0
                ZKV->ZKV_IDPART  := ""
                ZKV->ZKV_LOG     := ""
                MsUnLock() 
            Endif    

            cMsg := ""
            lRet := .T.
        else
            cMsg := ::oRestClient:GetLastError()
        
          If RecLock("ZKV", .F.)		
                ZKV->ZKV_ETAPA   := "1"           
                ZKV->ZKV_LOG     := cMsg
                MsUnLock()
            Endif

            lRet := .F.
		endif      
    endIf  
return cMsg

/*/{Protheus.doc} verificaStatus
//Metodo responsavel por verificar status do processo.
@author Fernando Oliveira Feres
@since     01/12/2020
@version 1.0
@param cJSON, characters, json.
/*/
method verificaStatus(cId,cCard) class ACCOUENV
	
	Local cResponse	:= ""	
    Local aHeader := {}
    Local oAccAut   := ACCOUAUT():New() 
    local oStatus := JsonObject():new()
    Private cPath := ""
    Private cUrl  := ""
    Private cToken := ""
    Private cParCli := cCard
    Private cEndAPI := ""
    Private cCliSec := ""
  
    cUrl    := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_URL")) 
    cEndAPI := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_ENDAPI"))
    cCliSec := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLISEC"))
    cCliId  := alltrim(POSICIONE("ZKX",2,xFilial("ZKX")+cParCli,"ZKX_CLIID"))

    oAccAut:getAuthToken(cEndAPI,cCliId,cCliSec)

    cToken := POSICIONE("ZKX",1,xFilial("ZKX")+cCliId,"ZKX_TOKEN")

    aAdd(aHeader, "Authorization: Bearer " + cToken)    
    aAdd(aHeader, "Content-Type: application/json")    
		
	cPath := "/v1/ledger/load/"+ cId +"/"

    ::oRestClient := FWRest():New(cUrl) 
    ::oRestClient:SetPath(cPath) 
    ::oRestClient:Get(aHeader)
    
    if self:oRestClient:ORESPONSEH:CSTATUSCODE == "200"
        cResponse := ::oRestClient:getResult()
        oStatus:fromJson(decodeUtf8(cResponse))
    else		
        cResponse := ::oRestClient:GetLastError()
       
       If RecLock("ZKV", .F.)
            ZKV->ZKV_DTFIN5 := date()
            ZKV->ZKV_HRFIN5 := time()
            ZKV->ZKV_ETAPA   := "4"
            ZKV->ZKV_LOG     := cResponse
            MsUnLock()
        Endif     
        oStatus := nil
    endif

	freeObj(::oRestClient)
return oStatus
