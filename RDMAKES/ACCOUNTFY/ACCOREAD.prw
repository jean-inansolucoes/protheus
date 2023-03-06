#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'
#include 'totvs.ch'
/*/{Protheus.doc} ACCOREAD
    Class responsavel pela leitura do Layout 
    @type  Class
    @author Fernando Oliveira Feres  
    @since 26/10/2020
    @version 1.0
    @example    
    (examples)
    @see (links_or_references)
/*/

Class ACCOREAD 

    method new()constructor
    method LoadDados()    
    method execInt()
    method destroy()
    method GeraNum()
 
    data lJob        as boolean
    data lEnd        as boolean
    data cFIJOB      as string 
    data aFiliais    as array  
    data lResult     as boolean 
    data cErroExec   as string

EndClass    

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Metodo construtor
@author Fernando Oliveira Feres
@since   26/10/2020
@version 1.0
@param   cId    , character, Id relacionado ao codigo das tabelas ZKT e ZKV
@param   cMsgErro , character, mensagem de erro
@return  object, self
/*/
//-------------------------------------------------------------------

method new(cFIJob, lJob, lEnd, lResult, cErroExec) class ACCOREAD

    default lJob  := .T.
    default lResult := .F.

    self:lJob      := lJob
    self:lEnd      := lEnd
    self:cFIJob    := cFIJob
    self:lResult   := lResult
    self:cErroExec := cErroExec
return

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Metodo para carregar os dados e montar a temp 
@author Fernando Oliveira Feres
@since   15/06/2020
@version 1.0
@param   cId    , character, Id relacionado ao codigo das tabelas ZKT e ZKV
@param   lSeekOk  , character, resultado do seek na tabela
@param   cMsgErro , character, mensagem de erro
@return  object, self
/*/
//-------------------------------------------------------------------

method LoadDados(cLayout,cCard,cFiliais,cData,lClean) class ACCOREAD

    Local oCriaTemp as Object
    Local cResult   as character

    // Clase responsavel pela extração dos dados e criação de temporaria
    oCriaTemp := ACTEMPDB():new()
    cResult := oCriaTemp:criaTemp(cLayout,cCard,cFiliais,cData,lClean)

    freeObj(oCriaTemp)
return cResult


//-------------------------------------------------------------------
/*/{Protheus.doc} execInt
Monta o arquivo JSON e chama a rotina respons?l pela grava? dos dados.
@author Fernando Oliveira Feres
@since   26/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------

method execInt(aDados) class ACCOREAD
    
    local oJson      as object  
    local oJsonAux   
    local oAccouEnv  as object
    local aJson      as array 
    local nTamDados  as numeric 
    local nQtdPartes as numeric
    local nTam       as numeric
    local nInd       as numeric 
    local lRet       as logical     
    local nI         as numeric
    Local cQuery     as character
    Local cAlias     as character
    Local nRegAtu    as numeric
    Local x          as numeric
    Local aRet       as array
    Local aRetF      as array
    Local aHeadAux   as array
    Local cQry       as character
    Local cRecFim    as character
    Local cTabela    as character
    Local aCampos    as array
    Local nPos       as numeric
    Local nPosRec    as numeric
    Local nQtdJson   as numeric
    Local cTipo      as character
    Local cCodigo    as character
    Local cIdLog     as character
    Local cMesAno    as character
    local nTamReg    as numeric
    Local lConRet   := .F.
    Local cJson     := ""
    Local cMsgApi    as character
    Local nx

    Local cpsDefault := "accountDescription-accountId-releaseDate-releaseDescription-value-costCenter-optionalInformation"
    Local cpsContabeis := "CTT_CUSTO-CT1_CONTA"
    Local nCatTags   as numeric

    Local cmascConta as character
    Local cmascCC    as character
    
    
    
    private xValue    
    private cAliasZKV := GetNextAlias()     

    lRet     := .T.    
    aCampos  := {}
    aHeadAux := {}
    aRet     := {}
    aRetF    := Array(Fcount())
    nI       := 1
    aJson    := {}
    nRegAtu  := 1
    x        := 0
    lSeekOk  := .F.
    cQry     := ""
    nPos     := 0
    nPosRec  := 0
    nQtdJson := 0
    oJsonAux := {}
    cCodigo  := ""
    cIdLog   := ""
    nTamReg  := 0
    nCatTags := 0

    oProcess:Set1Progress(6)
    
    cQry := " SELECT ZKT_NOMTEM, ZKT_LIMITE, ZKT_METODO, ZKT_CODIGO, ZKV_ID, ZKV_IDPART, ZKV_CARD FROM " + RetSqlName("ZKV") + " ZKV "
    cQry += " INNER JOIN " + RetSqlName("ZKT") + " ZKT "
    cQry += " ON ZKT.ZKT_CODIGO = ZKV.ZKV_LAYOUT "
    cQry += " AND ZKT.D_E_L_E_T_ = ' ' "
    cQry += " WHERE ZKV.ZKV_FILIAL = '" + xFilial("ZKV") + "' " 
    cQry += " AND ZKV.ZKV_CARD >= '" + aDados[1] + "'"
    cQry += " AND ZKV.ZKV_ID >= '" + aDados[2] + "'"
    cQry += " AND ZKV.ZKV_ID <= '" + aDados[3] + "' "
    cQry += " AND ZKV.D_E_L_E_T_ = ' ' "

    IF SELECT("cAliasZKV") > 0
        cAliasZKV->(DbCloseArea())
    ENDIF

    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasZKV, .F., .T.)  
    
    dbSelectArea("ZKY")

    dbSelectArea("ZKV")
    ZKV->(dbSetOrder(2))  
    while (cAliasZKV)->(!EOF())   
        
        //Delete os jsons caso j?xista
        ZKY->(DBSetOrder(1))
        if ZKY->(dbSeek( xFilial("ZKY") + (cAliasZKV)->ZKV_ID))
            while ZKY->(!EOF())   
                RecLock('ZKY', .F.)
                    DbDelete()
                ZKY->(MsUnlock())

                ZKY->(DBSkip())
            enddo
        endif

        cTabela  := alltrim((cAliasZKV)->ZKT_NOMTEM) + cEmpAnt
        nQtdJson := (cAliasZKV)->ZKT_LIMITE
        cTipo    := cValToChar((cAliasZKV)->ZKT_METODO)
        cCodigo  := alltrim((cAliasZKV)->ZKT_CODIGO)
        cIdLog   := alltrim((cAliasZKV)->ZKV_ID)
        cCard    := alltrim(aDados[1])//alltrim((cAliasZKV)->ZKV_CARD)

        if !Empty((cAliasZKV)->ZKV_IDPART)
            //Caso j?xista Id da parte criada, realiza o cancelamento para a nova cria?                                 
            oAccouEnv  := ACCOUENV():new(cIdLog,.T.,lSeekOk,)
            cMsgApi := oAccouEnv:putId(cIdLog, alltrim((cAliasZKV)->ZKV_IDPART))
            if !Empty(cMsgApi)
                MsgAlert("Erro ao realizar o cancelamento do ID das partes! - Erro API: " + cMsgApi + " - Favor entrar em contato com a Accountfy.","TOTVS")
                return .F.  
            endif
        endif

        //Atualiza a etapa de Preparando dados           
        if ZKV->(dbSeek( xFilial("ZKV") + cIdLog))
            RecLock("ZKV", .F.)            
            ZKV->ZKV_DTINI2 := date()
            ZKV->ZKV_HRINI2 := time()
            ZKV->ZKV_ETAPA   := "2"
            ZKV->ZKV_USER    := UsrRetName(__cuserID)   
            ZKV->(MsUnLock())
        endif

        if Empty(cTabela)
            self:cErroExec += "Dados n?encontrado "+CRLF
            return .F.    
        endif

        if !lockbyname(cTabela)
            Msginfo("O processamento já está em andamento em outra instância e não poderá existir a concorrência.")
            return .F.
        endif

        cAliasZKU := GetNextAlias()
        cQuery := " SELECT ZKU_CPINTE, ZKU_CPPROT, ZKU_TIPO, ZKU_ALIAS, ZKU_MASCAR FROM " + RetSqlName("ZKU") 
        cQuery += " WHERE ZKU_FILIAL = '" + xFilial("ZKU") + "' " 
        cQuery += " AND ZKU_CODIGO = '" + alltrim(cCodigo) + "'"
        cQuery += " AND D_E_L_E_T_ = ' ' "
        cQuery += " ORDER BY ZKU_SEQ "

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZKU,.F.,.T.) 
        
        if !(cAliasZKU)->(EOF())
            aCampos  := {}
            While (cAliasZKU)->(!EOF())            
                aadd(aCampos, { alltrim((cAliasZKU)->ZKU_CPINTE), alltrim((cAliasZKU)->ZKU_CPPROT), alltrim((cAliasZKU)->ZKU_TIPO), alltrim((cAliasZKU)->ZKU_ALIAS), AllTrim((cAliasZKU)->ZKU_MASCAR)}) //inclui os campos do depara no array
                
                (cAliasZKU)->(dbskip())
            enddo   
        else                
            Msginfo("De / para não encontrado!")
            return .F.
        endif
        (cAliasZKU)->(DbCloseArea())
        

        cAlias := GetNextAlias()
        cQuery := " SELECT * FROM " + cTabela + " WHERE ID_LOG = '" + cIdLog + "' AND FLAG = '0' ORDER BY TMPRECNO "
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)  
        
        if !(cAlias)->(EOF())
                    
            nTamDados := Contar(cAlias,"!Eof()")           
            
            oProcess:Inc1Progress('Processando as informações')   
            oProcess:Inc1Progress('Processando as informações')            
            oProcess:Set2Progress(nTamDados)

            nIn := nQtdJson // Limite de registros - separando por lotes
            
            nInd := 1 
            nTam := 0
            nQtdPartes := 0
            cmascConta := GetMv("MV_MASCARA")
            cmascCC    := GetMv("MV_MASCCUS")
            (cAlias)->(dbGoTop())     
                            
            while !(cAlias)->(EOF())     
                oProcess:Inc2Progress('Preparando os dados...')
                If oProcess:Cancel()
                    lCancel:=.T.
                    Disarmtransaction()
                    return .F.
                EndIf

                if nTam == 0                    
                    oJsonAux := {}
                    oJson :=  {}   
                    cRecIni := (cAlias)->TMPRECNO
                    cMesAno := substr((cAlias)->CT2_DATA,5,2)+"/"+substr((cAlias)->CT2_DATA,0,4)
                endif

                nTam += 1
                
                if !Empty(cJson)
                    cJson += ","
                endif          

                cJson +="{"
                cJsonEtq := ""
                for nx := 1 to len(aCampos)                   

                    if alltrim(aCampos[nx][2]) <> "FLAG" .and. alltrim(aCampos[nx][2]) <> "TMPRECNO" .and. alltrim(aCampos[nx][2]) <> "ID_LOG"
                        Do Case
                        Case UPPER(aCampos[nx][3]) == "C"
                            
                            cHist := ""

                            if aCampos[nx][2] $ cpsContabeis .And. aCampos[nx][5] =="S"
                                cTamEntid := TamSx3(aCampos[nx][2])[1]
                                if aCampos[nx][2] == "CT1_CONTA"
                                    
                                    cHist := MascaraCTB(alltrim((cAlias)->&(aCampos[nx][4])),cmascConta,cTamEntid,,cAlias)
                                else
                                    cHist := MascaraCTB(alltrim((cAlias)->&(aCampos[nx][4])),cmascCC,cTamEntid,,cAlias)
                                endIf
                            else
                                cHist := u_zLimpaEsp(strtran(alltrim((cAlias)->&(aCampos[nx][4])),'"',''))
                            Endif
                            

                            if aCampos[nx][1] $  cpsDefault
                                cJson += '"' + aCampos[nx][1] +'":' + '"' +  RTRIM(FwCutOff(alltrim(cHist), .f.)) + '"' + iif(nx<>len(aCampos),",","")
                            else
                                if cHist <> ""
                                    if nCatTags == 0
                                        cJsonEtq += '"categoryTags":[{"name":"' + aCampos[nx][1] + '", "tag":{"name":"' + RTRIM(FwCutOff(alltrim(cHist), .f.)) + '"}}'
                                    else
                                        cJsonEtq += ',{"name":"' + aCampos[nx][1] + '", "tag":{"name":"' + RTRIM(FwCutOff(alltrim(cHist), .f.)) + '"}}''
                                    ENDIF
                                    nCatTags++
                                Endif
                            Endif
                         	
                        
                        Case UPPER(aCampos[nx][3]) == "N"
                            if (cAlias)->DC == 'C'                        
                                
                                cJson += '"' + aCampos[nx][1] +'":' + alltrim(str(Round((cAlias)->&(aCampos[nx][4]) * (-1), 2))) + iif(nx<>len(aCampos),",","")
                            else
                                
                                cJson += '"' + aCampos[nx][1] +'":' + alltrim(str(Round((cAlias)->&(aCampos[nx][4]), 2))) + iif(nx<>len(aCampos),",","")
                            endif
                        Case UPPER(aCampos[nx][3]) == "D" 
                            
                            cJson += '"' + aCampos[nx][1] +'":' + '"' +  substr((cAlias)->&(aCampos[nx][4]),7,2)+"/"+substr((cAlias)->&(aCampos[nx][4]),5,2)+"/"+substr((cAlias)->&(aCampos[nx][4]),0,4) + '"' + iif(nx<>len(aCampos),",","")
                        Otherwise
                            
                            cJson += '"' + aCampos[nx][1] +'":' + '"' +  RTRIM(FwCutOff(alltrim((cAlias)->&(aCampos[nx][4])), .f.)) + '"' + iif(nx<>len(aCampos),",","")
                        endcase
                    endif
                next nx
                if nCatTags > 0
                    cJsonEtq += "]"
                    if SubStr(cJson, Len(cJson), 1) == ','
                        cJson   += cJsonEtq
                    else
                        cJson   +=','+cJsonEtq
                    ENDIF
                    nCatTags :=0
                else
                    if SubStr(cJson, Len(cJson), 1) == ','
                        cJson := SUBSTR(cJson,1,Len(Alltrim(cJson))-1)
                    Endif
                ENDIF
                cJson += "}"    

                cRecFim := (cAlias)->TMPRECNO

                if nTam == nIn  
                    //Somando a quantidade de partes
                    nQtdPartes += 1

                    if lRet                    
                        
                        reclock("ZKY",.T.)
                            ZKY->ZKY_FILIAL  := xFilial("ZKY")
                            ZKY->ZKY_IDLOG   := cIdLog
                            ZKY->ZKY_SEQ     := self:GeraNum(cIdLog)
                            ZKY->ZKY_MSGTRA := "["+cJson+"]"
                            ZKY->ZKY_DATAIN := date()
                            ZKY->ZKY_HORAIN := time()
                            ZKY->ZKY_HORAFI := time()
                            
                        ZKY->(msunlock())   

                        cJson := ""                 
                    else
                        reclock("ZKY",.T.)
                            ZKY->ZKY_FILIAL  := xFilial("ZKY")
                            ZKY->ZKY_IDLOG   := cIdLog
                            ZKY->ZKY_SEQ     := self:GeraNum(cIdLog)
                            ZKY->ZKY_MSGTRA := "["+cJson+"]"
                            ZKY->ZKY_DATAIN := date()
                            ZKY->ZKY_HORAIN := time()
                            ZKY->ZKY_HORAFI := time()
                            ZKY->ZKY_LOG     := self:cErroExec
                        ZKY->(msunlock())
                        lRet := .T.
                        cJson := ""                 
                    endif 

                    //Atualiza a quantidade de registro gerados
                    nTamReg += nTam

                    nTam := 0
                endif
                         

                (cAlias)->(dbSkip())

            enddo   

            if nTam < nIn 
                //Somando a quantidade de partes
                nQtdPartes += 1

                if lRet                         
                                    
                    reclock("ZKY",.T.)
                        ZKY->ZKY_FILIAL  := xFilial("ZKY")
                        ZKY->ZKY_IDLOG   := cIdLog
                        ZKY->ZKY_SEQ     := self:GeraNum(cIdLog)
                        ZKY->ZKY_MSGTRA := "["+cJson+"]"
                        ZKY->ZKY_DATAIN := date()
                        ZKY->ZKY_HORAIN := time()
                        ZKY->ZKY_HORAFI := time()
                        ZKY->ZKY_LOG     := self:cErroExec
                    ZKY->(msunlock())                 
                else                           
                    reclock("ZKY",.T.)
                        ZKY->ZKY_FILIAL  := xFilial("ZKY")
                        ZKY->ZKY_IDLOG   := cIdLog
                        ZKY->ZKY_SEQ     := self:GeraNum(cIdLog)
                        ZKY->ZKY_MSGTRA := "["+cJson+"]"
                        ZKY->ZKY_DATAIN := date()
                        ZKY->ZKY_HORAIN := time()
                        ZKY->ZKY_HORAFI := time()
                        ZKY->ZKY_LOG     := self:cErroExec
                    ZKY->(msunlock())
                    lRet := .T.

                endif 

                //Atualiza a quantidade de registro gerados
                nTamReg += nTam
            endif 

            unlockbyname(cTabela)   
            (cAlias)->(DbCloseArea())                                 
            
            freeObj(oJsonAux) 
            freeObj(oJson)
                      
            //Envia a quantidade de partes e gera o ID                                   
            oAccouEnv  := ACCOUENV():new(cIdLog,.T.,lSeekOk,)
            cMsgApi := oAccouEnv:postId(cIdLog,nQtdPartes,cMesAno,cCard)
            if !Empty(cMsgApi)                
                MsgAlert("Erro ao gerar ID das partes Accountfy! - Erro API: " + cMsgApi + " - Favor entrar em contato com a Accountfy.","TOTVS")
                return .F.  
            endif
           
            //Atualiza a etapa de Envio            
            if ZKV->(dbSeek( xFilial("ZKV") + cIdLog))
                RecLock("ZKV", .F.)            
                ZKV->ZKV_DTFIN2 := date()
                ZKV->ZKV_HRFIN2 := time()
                ZKV->ZKV_USER    := UsrRetName(__cuserID)  
                ZKV->ZKV_QTDREG  := nTamReg 
                ZKV->(MsUnLock())
            endif

        else
            self:cErroExec := "Requisição não executada para este layout! "+ CRLF
            MsgAlert("Requisição não executada para este layout!","TOTVS")            
            return .F. 
        endif       

        (cAliasZKV)->(DbSkip())
    enddo

    (cAliasZKV)->(DbCloseArea())   

    if lRet 
        //carregar os dados e cria json de exporta?
        if U_ACC00008(aDados, oProcess)                                    
            oProcess:Inc1Progress('Processando as informações')
            oProcess:Inc1Progress('Processando as informações')
            oProcess:Set4Progress(1)          

            While !lConRet
                oProcess:Inc4Progress('Processando...')
                oProcess:Inc4Progress('Processando...')
                If oProcess:Cancel()
                    lCancel:=.T.
                    Disarmtransaction()
                    return .F.
                EndIf  
                                   
                if U_ACCOU09(aDados)                    
                    lConRet := .T.
                endif                        
                
                Sleep(10000) // 10 Segundos
            EndDo
            lRet := .T.
        else
            return .F.
        endif  

        oProcess:nCancel := 0
        oProcess:oDlg:End()                       
    endif

return lRet

method GeraNum(cId) class ACCOREAD
    Local cQuery := ""
    Local cRet := ""
    Local cAlias := GetNextAlias()

    cQuery:= "SELECT MAX(ZKY_SEQ) AS ZKY_SEQ FROM "+ RetSqlName("ZKY") + " ZKY WHERE ZKY_IDLOG = '"+cId+"' AND ZKY.D_E_L_E_T_ <> '*' "

    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T. )

    If !Empty((cAlias)->ZKY_SEQ)

        cRet:= Soma1((cAlias)->ZKY_SEQ)

    Else
        cRet:= "000001"

    Endif 

return cRet

User Function zLimpaEsp(_sOrig)
   local _sRet := _sOrig

    _sRet := StrTran(_sRet, "&", "E")
    _sRet := StrTran(_sRet, ">", "")
    _sRet := StrTran(_sRet, "<", "")
     _sRet := StrTran(_sRet, "{", "")
    _sRet := StrTran(_sRet, "}", "")
    _sRet := StrTran(_sRet, "[", "")
    _sRet := StrTran(_sRet, "]", "")
    _sRet := StrTran(_sRet, "\", "")
    _sRet := StrTran(_sRet, "á", "a")
    _sRet := StrTran(_sRet, "é", "e")
    _sRet := StrTran(_sRet, "í", "i")
    _sRet := StrTran(_sRet, "ó", "o")
    _sRet := StrTran(_sRet, "ú", "u")
    _SRET := StrTran (_SRET, "Á", "A")
    _SRET := StrTran (_SRET, "É", "E")
    _SRET := StrTran (_SRET, "Í", "I")
    _SRET := StrTran (_SRET, "Ó", "O")
    _SRET := StrTran (_SRET, "Ú", "U")
    _sRet := StrTran (_sRet, "ã", "a")
    _sRet := strtran (_sRet, "õ", "o")
    _SRET := STRTRAN (_SRET, "Ã", "A")
    _SRET := STRTRAN (_SRET, "Õ", "O")
    _sRet := strtran (_sRet, "â", "a")
    _sRet := strtran (_sRet, "ê", "e")
    _sRet := strtran (_sRet, "î", "i")
    _sRet := strtran (_sRet, "ô", "o")
    _sRet := strtran (_sRet, "û", "u")
    _SRET := STRTRAN (_SRET, "Â", "A")
    _SRET := STRTRAN (_SRET, "Ê", "E")
    _SRET := STRTRAN (_SRET, "Î", "I")
    _SRET := STRTRAN (_SRET, "Ô", "O")
    _SRET := STRTRAN (_SRET, "Û", "U")
    _sRet := strtran (_sRet, "ç", "c")
    _sRet := strtran (_sRet, "Ç", "C")
    _sRet := strtran (_sRet, "à", "a")
    _sRet := strtran (_sRet, "À", "A")
    _sRet := strtran (_sRet, "º", ".")
    _sRet := strtran (_sRet, "ª", ".")
    _sRet := strtran (_sRet, chr (9), " ") // TAB
return _sRet

