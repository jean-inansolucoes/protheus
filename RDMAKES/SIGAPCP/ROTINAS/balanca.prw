
/*/{Protheus.doc} User Function tstbal
    (long_description)
    @type  Function
    @author user
    @since 04/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function tstbal()

    Local nPesoRet
    Local cPorta    := ""
    Local cVelocid  := ""
    Local cParidade := ""
    Local cBits     := ""
    Local cStopBits := ""
    Local cFluxo    := ""
    Local nTempo    := ""
    Local cConfig   := ""
    Local lRet      := .T.
    Local nH        := 0
    Local cBuffer   := ""
    Local nPosFim   := 0
    Local nPosIni   := 0
    Local nX        := 0
    Local cPesoLido := ""
    Local cMarca    := "TOLEDO"
    Local cLog      := ""
    Local cFilName  := "balanca_"+StrTran(Time(),":","")+".txt"
    aLin 		    := {}
     
    //Se houver marca
    If ! Empty(cMarca)
        cMarca := Upper(Alltrim(cMarca))
         
        //Pegando a porta padrão da balança
        cPorta    := "COM1" //SuperGetMV("MV_X_PORTA",.F.,"COM1")
         

        If (cMarca == "TOLEDO")
            cVelocid  := "4800" //SuperGetMV("MV_X_VELOC", .F.,"4800")    //Velocidade
            cParidade := "N" //SuperGetMV("MV_X_PARID", .F.,"N")       //Paridade
            cBits     := "8" //SuperGetMV("MV_X_BITS",  .F.,"8")       //Bits
            cStopBits := "1" //SuperGetMV("MV_X_SBITS", .F.,"1")       //Stop Bit
            cFluxo    := "" //SuperGetMV("MV_X_FLUXO", .F.,"")        //Controle de Fluxo
            nTempo    := 20 //SuperGetMV("MV_X_TEMPO", .F.,5)         //Tempo
        //Qualquer balança que utilize porta serial
        Else
            cVelocid  := SuperGetMV("MV_X_VELOC", .F.,"9600")    //Velocidade
            cParidade := SuperGetMV("MV_X_PARID", .F.,"n")       //Paridade
            cBits     := SuperGetMV("MV_X_BITS",  .F.,"8")       //Bits
            cStopBits := SuperGetMV("MV_X_SBITS", .F.,"1")       //Stop Bit
            cFluxo    := SuperGetMV("MV_X_FLUXO", .F.,"")        //Controle de Fluxo
            nTempo    := SuperGetMV("MV_X_TEMPO", .F.,5)         //Tempo
        EndIf
         

        If cMarca == "TOLEDO"
            //Montando a configuração (Porta:Velocidade,Paridade,Bits,Stop)
            cConfig := cPorta+":"+cVelocid+","+cParidade+","+cBits+","+cStopBits
             
            //Guarda resultado se houve abertura da porta
            lRet := MSOpenPort(@nH,cConfig)
            lOk  := .T.
             
            //Se não conseguir abrir a porta, tenta mais uma vez, remapeando
            /*
            If ! lRet
                //Força o fechamento e abertura da porta novamente
                WaitRun("NET USE "+cPorta+": /DELETE")
                WaitRun("NET USE "+cPorta+" ")
                 
                lOk := MSOpenPort(@nH,cConfig)
                 
                If !lOk
                    MsgStop("<b>Falha</b> ao conectar com a porta serial. Detalhes:"+;
                            "<br><b>Porta:</b> "        +cPorta+;
                            "<br><b>Velocidade:</b> "    +cVelocid+;
                            "<br><b>Paridade:</b> "        +cParidade+;
                            "<br><b>Bits:</b> "            +cBits+;
                            "<br><b>Stop Bits:</b> "    +cStopBits,"Atenção")
                EndIf
            EndIf
            */
             
            If lRet //lOk
            
                //Inicializa balança
                MsWrite(nH,CHR(5))
                nTaman := 15
                 nLeitu := 0
                //Realiza a leitura
                For nX := 1 To 50
                    //Obtendo o tempo de espera antes de iniciar a leitura da balança e realiza a leitura    
                    Sleep(nTempo)
                    MSRead(nH,@cBuffer)
                     
                    //Obtendo os caracteres inciais
                    cBuffer := AllTrim(SubStr(AllTrim(cBuffer),1,nTaman))

                    cLog += cBuffer + "-"
                      
                      
                    //Se a linha retornada for igual ao tamanho limite
                    /*
                    If Len(AllTrim(cBuffer)) >= nTaman
                        aAdd(aLin, { cBuffer })
                        If(nLeitu == 10)
                          Exit
                        else
                          nLeitu += 1
                          nX := 1
                          cBuffer := 0
                        EndIf
                    EndIf
                    */
                Next nX    

               //Gera arquivo de log
                Memowrite("c:\temp\"+cFilName,cLog)
                
                //msginfo(cBuffer)
                 
                 
                //Verifica onde começa o "q" e soma 2 espaços
                //nPosIni := At("q",cBuffer)+2
     
                //Obtendo apenas o peso da balança
                //cPesoLido := SubStr(cBuffer,nPosIni,nPosIni+3)
            Else
                msginfo("Não houve comunicação com a porta")
            EndIf
             
            //Encerra a conexão com a porta
            MSClosePort(nH,cConfig)
        EndIf    
         
        //Converte o peso obtido para inteiro e o atribui a variavel de retorno
        nPesoRet := Val(cPesoLido)
            
        msClosePort(nH,cConfig)
    EndIf
    
Return 




urn 




