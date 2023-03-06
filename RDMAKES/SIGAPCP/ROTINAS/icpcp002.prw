
/*/{Protheus.doc} User Function tstbal
    Realiza leitura e captura peso balanca
    @type  Function
    @author ICMAIS
    @since 06/10/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ICPCP002()

     Local aArea     := GetArea()
    Local nPesoRet  := 0
    Local nPosFim   := 0
    Local nPosIni   := 0
    Local nX        := 0
    Local nTent     := 0
    Local nLeitu    := 0
    Local cPesoLido := 0
    Local nTaman    := 0
    Local nInPesEst := 0
    Local nFmPesEst := 0
    Local nH        := 0
    Local lRet      := .T.
    Local cPorta    := ""
    Local cVelocid  := ""
    Local cParidade := ""
    Local cBits     := ""
    Local cStopBits := ""
    Local nTempo    := ""
    Local cConfig   := ""
    Local cBuffer   := ""
    Local cMarca    :=  "TOLEDO"

    //Se houver marca
    If ! Empty(cMarca)

        //Pegando a porta padrão da balança
        cPorta      := SuperGetMV("MV_X_PORTA", .F.,"COM1")     //Porta
        cVelocid    := SuperGetMV("MV_X_VELOC", .F.,"4800")     //Velocidade
        cParidade   := SuperGetMV("MV_X_PARID", .F.,"N")        //Paridade
        cBits       := SuperGetMV("MV_X_BITS",  .F.,"8")        //Bits
        cStopBits   := SuperGetMV("MV_X_SBITS", .F.,"1")        //Stop Bit
        nTempo      := SuperGetMV("MV_X_TEMPO", .F.,500)         //Tempo
        nTent       := 10
        nPosIni     := 1
        nPosFim     := 14
        nInPesEst   := 4
        nFmPesEst   := 11

        //Montando a configuração (Porta:Velocidade,Paridade,Bits,Stop)
        cConfig := cPorta+":"+cVelocid+","+cParidade+","+cBits+","+cStopBits

        //Guarda resultado se houve abertura da porta
        lRet := MSOpenPort(@nH,cConfig)

        If lRet
            //Inicializa balança
            MsWrite(nH,CHR(5))
            nTaman := nPosFim
            nLeitu := 0
            //Realiza a leitura
            For nX := 1 To nTent
                //Obtendo o tempo de espera antes de iniciar a 
                //leitura da balança e realiza a leitura
                Sleep(nTempo)
                MSRead(nH,@cBuffer)

                //Obtendo os caracteres inciais
                cBuffer := AllTrim(SubStr(AllTrim(cBuffer),nPosIni,nPosFim)) //"l0 00019300000" 

                //Se a linha retornada for igual ao tamanho limite
                If Len(AllTrim(cBuffer)) == nTaman

                    If SubStr(cBuffer,1,2) == "l0" //Estavel
                        Exit
                    Endif

                EndIf
            Next nX

            //Verifica onde começa a leitura estavel
            //nInPesEst := At("q",cBuffer)+2

            //Obtendo apenas o peso da balança
            cPesoLido := SubStr(cBuffer,nInPesEst,nFmPesEst)
        Else
            msgstop("Não houve comunicação com a porta da balança")
        EndIf

        //Encerra a conexão com a porta
        MSClosePort(nH,cConfig)

        //Converte o peso obtido para inteiro e o atribui a variavel de retorno
        nPesoRet := (Val(cPesoLido)/1000)/1000
    EndIf

    //Sleep(500)
    //nPesoRet := 5

    RestArea(aArea)

Return nPesoRet
