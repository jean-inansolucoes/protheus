#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} ICNFE001
Function para busca o numero do protocolo de autorizacao da NF-e para enviar para ICMAIS
@type function
@version 12.1.25
@author ICMAIS
@since 04/02/2021
@return character, cQueryCompl
/*/
user function ICNFE001(SERIE, NFE)


    Local cAliasTMP   := GetNextAlias()   
    Local cReturn     := ""
    Local cQuery      := ""
    //Local SERIE       :="001"
    //Local NFE         :="000020763"


    If (Select(cAliasTMP) <> 0)
		DbSelectArea(cAliasTMP)
		(cAliasTMP)->(DbCloseArea())
	EndIf

      cQuery := "SELECT CONCAT ( TRIM(NFE_PROT), ' ' , ( SUBSTRING (DATE_NFE, 5, 2)+'/'+ SUBSTRING (DATE_NFE, 4, 2)+'/'+ SUBSTRING (DATE_NFE, 1, 4) ), ' ',TRIM(TIME_NFE)) AS PROTOCOLO FROM SPED050 WHERE NFE_ID = '"+SERIE+NFE+"' "
     
     //CONVERT( CHAR(10), TRIM(DATE_NFE), 112 )

    MemoWrite("ICNFE001.sql", cQuery)

	TcQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)
                                                       
	DbSelectArea(cAliasTMP)
	DbGoTop()


    If !(EoF())
     
     cReturn := ALLTRIM( (cAliasTMP)->PROTOCOLO )

    EndIF 
   //MsgInfo("Protocolo="+cReturn," NF-e Protocolo de uso")

return ( cReturn )




// BUSCA NATUREZA DA OPERACAO DA  NOTA FISCAL

user function ICNFE002(SERIE, NFE)

    Local cAliasTMP   := GetNextAlias()   
    Local cReturn     := ""
    Local cCFO        := ""
    Local cF4_TEXTO   := ""
    Local cQuery      := ""

    //Local NFE         := "000020093"
    //Local SERIE       :=  "001"

    // SF3
        dbSelectArea( "SF3" )
        SF3->( dbSetOrder( 6 ) )
        SF3->( dbGoTop( ) )
        If dbSeek( xFilial( "SF3" )+NFE+SERIE )
             cCFO := SF3->F3_CFO
        Endif
    // SF4
    If (Select(cAliasTMP) <> 0)
		DbSelectArea(cAliasTMP)
		(cAliasTMP)->(DbCloseArea())
	EndIf
       cQuery := "SELECT F4_TEXTO as CFO FROM  " + RetSQLName( "SF4" ) + " WHERE F4_CF='" + alltrim(cCFO) + "' AND D_E_L_E_T_<>'*' "

       MemoWrite("ICNFE001_SF4.sql", cQuery)

	TcQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)
                                                       
	DbSelectArea(cAliasTMP)
	DbGoTop()


    If !(EoF())
     
     cReturn := ALLTRIM( (cAliasTMP)->CFO )

    EndIF
//MsgInfo("Dadoso="+cReturn," NF-e NATUREZA OPERACAO")



return ( cReturn )


// DADOS DA TRANSPORADORA
user function ICNFE003(SERIE, NFE)

    Local cAliasTMP   := GetNextAlias()   
    Local cReturn     := ""
    Local cNOME       := ""
    Local cTRANSP     := ""
    Local cPLACA      := ""
    Local cTPFRETE    := ""
    Local cUFDEST     := ""
    Local nVOLUME     := 0
    Local cESPECIE    := ""
    Local nPBRUTO     := 0
    Local nLIQUID     := 0

    Local cFRETNFE    := ""
    
    Local cTRANSNOM   := ""
    Local cTRANSCGC   := ""
    Local cTRANSEND   := ""
    Local cTRANSMUN   := ""
    Local cTRANSUF    := ""
    Local cTRANSINSC  := ""

    //Local NFE         := "000020093"
   // Local SERIE       :=  "001"

        
        // SF2
        dbSelectArea( "SF2" )
        SF2->( dbSetOrder( 1 ) )
        SF2->( dbGoTop( ) )
        If dbSeek( xFilial( "SF2" )+NFE+SERIE )
             cTRANSP    := SF2->F2_TRANSP
             cTPFRETE   := SF2->F2_TPFRETE
             cPLACA     := SF2->F2_VEICUL1
             cUFDEST    := SF2->F2_UFDEST
             nVOLUME    := SF2->F2_VOLUME1
             cESPECIE   := ALLTRIM(SF2->F2_ESPECI1)
             nPBRUTO    := SF2->F2_PBRUTO
             nLIQUID    := SF2->F2_PLIQUI

        Endif

        SF2->(DbCloseArea())

        IF cTPFRETE == "C"
            cFRETNFE := "0-REMETENTE"
        EndIf

        IF cTPFRETE == "F"
            cFRETNFE := "1-DESTINATARIO"
        EndIf

        IF cTPFRETE == "T"
            cFRETNFE := "2-TERCEIRO"
        EndIf

        IF cTPFRETE == "R"
            cFRETNFE := "3-TRANSP PROP/REM"
        EndIf

        IF cTPFRETE == "D"
            cFRETNFE := "4-TRANS PROP/DEST"
        EndIf

        IF cTPFRETE == "S"
            cFRETNFE := "9-SEM FRETE"
        EndIf
        
        
        // SA4
        dbSelectArea( "SA4" )
        SA4->( dbSetOrder( 1 ) )
        SA4->( dbGoTop( ) )
        If dbSeek( xFilial( "SA4" )+cTRANSP )
            cTRANSNOM := ALLTRIM(SA4->A4_NOME) 
            cTRANSCGC   := SA4->A4_CGC
            cTRANSEND   := ALLTRIM(SA4->A4_END)
            cTRANSUF    := SA4->A4_EST
            cTRANSMUN   := ALLTRIM(SA4->A4_MUN)
            cTRANSINSC  := SA4->A4_INSEST
        Endif

        cReturn := " | "+ cTRANSNOM +" | "+ cFRETNFE +" | "+ cPLACA +" | "+ cTRANSUF +" | "+ cTRANSEND +" | "+ cTRANSMUN +" | "+ cTRANSUF +" | "+ cTRANSINSC +" | "+ ALLTRIM(STR(nVOLUME)) +" | "+ cESPECIE  +" | "+ ALLTRIM(STR(nPBRUTO)) +" | "+ ALLTRIM(STR(nLIQUID)) +" | "  
    
      // MsgInfo("Dadoso="+cReturn," NF-e transportadora")
 
 
       SA4->(DbCloseArea())
     // RestArea(cAliasTMP) 

return ( cReturn )



//TITULOS REFERENTE A NOTA FISCAL 
user function ICNFE004(SERIE, NFE)
  Local area        := GetNextAlias()   
  Local cReturn     := ""
  //Local SERIE       :="001"
  //Local NFE         :="000020808"
  

   // SF2
        dbSelectArea( "SE1" )
         SE1->( dbSetOrder( 1 ) )
         SE1->( dbGoTop( ) )
        If dbSeek( xFilial( "SE1" ) + SERIE + NFE )
            While  SE1->( !Eof() ) .and. SE1->E1_NUM == NFE
                IF LEN(cReturn) > 0
                    cReturn +=  SE1->E1_PARCELA  +";"+ DTOS(SE1->E1_EMISSAO)  +";"+ ALLTRIM(STR(SE1->E1_VALOR))   +"|"   //
                  Else
                    cReturn +=  "|"+ SE1->E1_PARCELA +";"+ DTOS(SE1->E1_EMISSAO) +";"+ ALLTRIM( STR(SE1->E1_VALOR ) )   +"|"  //
                EndIF
             SE1->( DbSkip() )
            Enddo
        Endif
       SE1->(DbCloseArea())
  
   //MsgInfo("Dadoso="+cReturn," NF-e titulos")

 
  return ( cReturn )
