#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} User Function ICPCP005
    Rotina criação de palete
    @type  Function
    @author ICMAI
    @since 13/12/2022
    @version 1.0
/*/
User Function ICPCP005()

    Local oBrowse := Nil

    dbSelectArea("ZPA")
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZPA")
    oBrowse:SetDescription("Criação de palete")
    oBrowse:Activate()
    
Return 




/*/{Protheus.doc} User Function MENUDEF
    Cria menu
    @type  Function
    @author ICMAIS
    @since 13/12/2022
    @version 1.0
/*/
Static Function MENUDEF()

    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.ICPCP005' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Novo'             ACTION 'U_IPCP05IC("")' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Associar Caixa'   ACTION 'U_IPCP05AC' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'          ACTION 'VIEWDEF.ICPCP005' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'          ACTION 'VIEWDEF.ICPCP005' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir etiqueta' ACTION 'U_ETQPALE0' OPERATION 6 ACCESS 0
   //ETQPALT1 , IMPETIQ
Return aRotina




/*/{Protheus.doc} User Function MODELDEF
    Modelo de dados
    @type  Function
    @author ICMAIS
    @since 13/12/2022
    @version 1.0
/*/
Static Function MODELDEF()
    //Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
    Local oModel      := NIL
    Local oStruCab     := FWFormStruct(1, 'ZPA', {|cCampo| AllTRim(cCampo) $ "ZPA_PALETE;ZPA_PESO;ZPA_QTDITE"})
    Local oStruGrid := fModStruct()
  
    //Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
    oModel := MPFormModel():New('ASATF05M', /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )
  
    //Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
    oModel:AddFields('MdFieldZPA', NIL, oStruCab)
    oModel:AddGrid('MdGridZPA', 'MdFieldZPA', oStruGrid, , )
  
    //Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
    oModel:SetRelation('MdGridZPA', {;
            {'ZPA_FILIAL', 'xFilial("ZPA")'},;
            {'ZPA_PALETE',  'ZPA_PALETE'};
        }, ZPA->(IndexKey(1)))
      
    //Definindo outras informações do Modelo e da Grid
    oModel:GetModel("MdGridZPA"):SetMaxLine(9999)
    oModel:SetDescription("Criação Paletes")
    oModel:SetPrimaryKey({"ZPA_FILIAL", "ZPA_PALETE", "ZPA_ITEM"})


Return oModel




/*/{Protheus.doc} User Function VIEWDEF
    Visao dados
    @type  Function
    @author ICMAIS
    @since 13/12/2022
    @version 1.0
/*/
Static Function VIEWDEF()
   //Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
    Local oView        := NIL
    Local oModel    := FWLoadModel('ICPCP005')
    Local oStruCab  := FWFormStruct(2, "ZPA", {|cCampo| AllTRim(cCampo) $ "ZPA_PALETE;ZPA_PESO;ZPA_QTDITE"})
    Local oStruGRID := fViewStruct()
  
    //Define que no cabeçalho não terá separação de abas (SXA)
    oStruCab:SetNoFolder()
  
    //Cria o View
    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
  
    //Cria uma área de Field vinculando a estrutura do cabeçalho com MdFieldZPA, e uma Grid vinculando com MdGridZPA
    oView:AddField('VIEW_ZPA', oStruCab, 'MdFieldZPA')
    oView:AddGrid ('GRID_ZPA', oStruGRID, 'MdGridZPA' )
  
    //O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)
  
    //Vincula o MAIN com a VIEW_ZPA e a GRID com a GRID_ZPA
    oView:SetOwnerView('VIEW_ZPA', 'MAIN')
    oView:SetOwnerView('GRID_ZPA', 'GRID')
    oView:EnableControlBar(.T.)
  
    //Define o campo incremental da grid como o ZPA_ITEM
    oView:AddIncrementField('GRID_ZPA', 'ZPA_ITEM')

Return oView




//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
    Local oStruct
    oStruct := FWFormStruct(1, 'ZPA')
Return oStruct




//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
    Local cCampoCom := "ZPA_PALETE;ZPA_PESO;ZPA_QTDITE"
    Local oStruct
  
    //Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
    oStruct := FWFormStruct(2, "ZPA", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct





/*/{Protheus.doc} User Function IPCP05IC
    Tela inclusao palete
    @type  Function
    @author ICMAIS
    @since 14/12/2022
    @version 1.0
/*/
User Function IPCP05IC(cCodAlt)

    Local aArea      := GetArea()
    Private cCodSeq  := ""
    Private oDlg     := Nil
    Private oSayItem := Nil
    Private oSayPeso := Nil
    Private oSayCnt  := Nil
    Private cNumPal  := ""   
    Private cGetGS1  := Space(TamSX3("ZGS_GS1")[1])
    Private cNumItem := ""
    Private nCounIt  := ""
    Private nPeso    := 0

    if Empty(cCodAlt)
        cCodSeq  := GetSxeNum("ZPA","ZPA_PALETE")
    else
        cCodSeq  := cCodAlt
    endif

    cNumItem := RTMAXITEM() // NUMERO DO ITEM
    nCounIt  := RTCOUNTIT(cCodSeq) // TOTAL DE CAIXAS  
    nPeso    := RTTOTPES(cCodSeq)  // PESO 

    oFont12n  := TFont():New("TAHOMA",0,-16,,.F.,0,,450,.T.,.F.,,,,,, )

    Define MsDialog oDlg Title 'Montagem de palete' From 000, 000 To 250, 480 Pixel Style DS_MODALFRAME

        oSay1 := TSay():New( 005,010,{||"Nº Palete: " + cCodSeq},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
        oSay1 := TSay():New( 005,100,{||"Item: "},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oSayItem := TSay():New( 005,125,{|| cNumItem},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oSay1 := TSay():New( 020,010,{||"Total caixas: "},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
        oSayCnt := TSay():New( 020,065,{|| nCounIt},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
        oSay1 := TSay():New( 020,100,{||"Peso: "},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
        oSayPeso := TSay():New( 020,140,{|| nPeso},oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
        oSay1 := TSay():New( 040,010,{||"Codigo da caixa" },oDlg,,oFont12n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)

        @ 060,010 GET oGetGS1 VAR cGetGS1 Picture "@!" Font oFont12n SIZE 200,15 OF oDlg PIXEL VALID (GRAVAPLT() .Or. Vazio()) //PASSWORD

        oBtnConf := TButton():New( 100,030, "&Sair",oDlg,{|| SAIRDLG()},044,015,,oFont12n,,.T.,,"",,,,.F. )
        oBtnConf := TButton():New( 100,100, "&Apagar ultimo registro",oDlg,{|| DELETGS1()},100,015,,oFont12n,,.T.,,"",,,,.F. )

        //oDlg:lEscClose := .F. 
        oDlg:lCentered := .T.
    Activate MsDialog oDlg

    RestArea(aArea)
    
Return 




/*/{Protheus.doc} SAIRDLG
    Fecha tela novo palete
    @type  Static Function
    @author ICMAIS
    @since 14/12/2022
    @version 1.0
/*/
Static Function SAIRDLG()

    if Empty(cNumPal)
        RollBackSX8()
    endif

    oDlg:End()
Return 




/*/{Protheus.doc} Static Function GRAVAPLT
    Grava registro palete
    @type  Static Function
    @author ICMAIS
    @since 14/12/2022
    @version 1.0
/*/
Static Function GRAVAPLT()

    Local cAlias     := "ZPA"
    Local bInsert    := .T.
    Local cAlSZB     := GetNextAlias()
    Local cAlSC9     := GetNextAlias()
    Local cAlZGS     := GetNextAlias()
    Local cQuery     := ""
    Local aBindParam := {}
    Local nCxPalet   := 0
    
    if !Empty(cGetGS1)

        cQuery := "SELECT SZB.ZB_PRODUTO, SZB.ZB_PESOBAL FROM "+ RetSqlName("SZB") +" SZB " 
        cQuery += " WHERE SZB.ZB_ITF14 = '"+ AllTrim(cGetGS1) +"'" 
        cQuery += " AND SZB.D_E_L_E_T_ = '' " 
       
        cQuery := ChangeQuery(cQuery)

        MPSysOpenQuery(cQuery,cAlSZB,,,)

        if !Empty((cAlSZB)->ZB_PRODUTO)

            //cQuery := "SELECT SC9.C9_PRODUTO FROM "+ RetSqlName("SC9") +" SC9 " 
            //cQuery += " WHERE SC9.C9_FILIAL = '"+ xFilial("SZB") +"'"
            //cQuery += " AND SC9.C9_PRODUTO = '"+ (cAlSZB)->ZB_PRODUTO +"' "
            //cQuery += " AND SC9.C9_PEDIDO = '"+ cNumPed +"'" 
            //cQuery += " AND SC9.D_E_L_E_T_ = '' " 

            //cQuery := ChangeQuery(cQuery)

            //MPSysOpenQuery(cQuery,cAlSC9,,,aBindParam)
 
            //if !Empty((cAlSC9)->C9_PRODUTO)

                //cQuery := "SELECT ZGS.ZGS_GS1 FROM "+ RetSqlName("ZGS") +" ZGS " 
                //cQuery += " WHERE ZGS.ZGS_FILIAL = '"+ xFilial("ZGS") +"'"
                //cQuery += " AND ZGS.ZGS_GS1 = '"+ cGetGS1 +"' "
                //cQuery += " AND ZGS.D_E_L_E_T_ = '' " 

                //cQuery := ChangeQuery(cQuery)

                //MPSysOpenQuery(cQuery,cAlZGS,,,)

                //if Empty((cAlZGS)->ZGS_GS1)


                //DbSelectArea("SB1")
                //SB1->(DbSetOrder(1))
                //SB1->(DbGoTop())
                //if dbSeek(xFilial("SB1")+(cAlSZB)->ZB_PRODUTO)
                //    nCxPalet := SB1->B1_X_MCXPL
                //endif

                //if Val(cNumItem) <= nCxPalet
                    RecLock(cAlias, bInsert)
                    ZPA->ZPA_FILIAL := xFilial(cAlias)
                    ZPA->ZPA_PALETE := cCodSeq
                    ZPA->ZPA_ITEM   := cNumItem
                    ZPA->ZPA_GS1    := cGetGS1
                    ZPA->ZPA_ORIGEM := "PALETES"
                    ZPA->ZPA_DATA   := dDataBase
                    ZPA->ZPA_USER   := AllTrim( cUsername )
                    (cAlias)->(MsUnlock())

                    if Empty(cNumPal)
                        cNumPal := cCodSeq
                        ConfirmSX8()
                    endif

                    // Atualiza o label com o valor correspondente
                    cNumItem := RTMAXITEM()
                    oSayItem:SetText(cNumItem)
                    oSayItem:CtrlRefresh()
                    
                    //Atualiza peso
                    nPeso += (cAlSZB)->ZB_PESOBAL
                    oSayPeso:SetText(nPeso)
                    oSayPeso:CtrlRefresh()

                    //Atualiza peso
                    nCounIt := RTCOUNTIT(cCodSeq)
                    oSayCnt:SetText(nCounIt)
                    oSayCnt:CtrlRefresh()
                //else
                //    FWAlertError("Numero maximo de caixas atingido para este palete!", "ATENÇÃO")
                //endif

                //else
                //    FWAlertError("Produto já foi bipado anteriormente!", "ATENÇÃO")
                //endif
            //else 
            //    FWAlertError("Produto não possui liberação!", "ATENÇÃO")
            //endif

            //(cAlSC9)->(DbCloseArea())
        else
            FWAlertError("Produto não encotrado no pedido!", "ATENÇÃO")
        endif

         (cAlSZB)->(DbCloseArea())
        
        //Limpa campos    
        cGetGS1 := Space(TamSX3("ZGS_GS1")[1])
        oGetGS1:CtrlRefresh()

        // E manda o FOCO pro GET 
        oGetGS1:SetFocus()

    endif

Return .T.




/*/{Protheus.doc} DELETGS1
    Exclui ultimo registro GS1
    @type  Static Function
    @author ICMS
    @since 18/10/2022
    @version 1.0
/*/
Static Function DELETGS1()

    Local aArea := GetArea()
    Local cItem := RTMAXITEM()
    cItem := StrZero(Val(cItem)-1,4)

    DbSelectArea("ZPA")
    ZPA->(DbSetOrder(1))
    if dbSeek(xFilial("ZPA")+cCodSeq+cItem)
        RecLock( "ZPA", .F. )
        ZPA->( dbDelete() )
        ZPA->( MsUnlock() ) 
    endif

    oGetGS1:SetFocus()

    RestArea(aArea)

Return 




/*/{Protheus.doc} RTMAXITEM
    Retorna numero sequencial item
    @type  Static Function
    @author ICMAIS
    @since 14/12/2022
    @version 1.0
    @return cItem, caracter, numero item
/*/
Static Function RTMAXITEM()

    Local cItem      := "0001"
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()
    //Local aBindParam := {}
    Default lSoma    := .T.
    
    cQuery := "SELECT MAX(ZPA_ITEM) ITEM FROM "+ RetSqlName("ZPA") +" WHERE ZPA_PALETE = '"+cCodSeq+"' AND D_E_L_E_T_ = '' "
    cQuery := ChangeQuery(cQuery)

    //aBindParam := {cCodSeq}
    
    MPSysOpenQuery(cQuery,cAlias,,,/*aBindParam*/)

    if !Empty((cAlias)->ITEM)
        cItem := Soma1((cAlias)->ITEM)
    endif
    
    (cAlias)->(DbCloseArea())
    
Return cItem




/*/{Protheus.doc} RTCOUNTIT
    Retorna contador caixas
    @type  Static Function
    @author ICMAIS
    @since 18/10/2022
    @version 1.0
    @return cItem, caracter, numero item
/*/
Static Function RTCOUNTIT(cCodSeq)

    Local nCount     := 0
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()
    //Local aBindParam := {}
    
    
    cQuery := "SELECT COUNT(ZPA_PALETE) COUNT FROM "+ RetSqlName("ZPA") +" WHERE ZPA_PALETE = '"+cCodSeq+"' AND D_E_L_E_T_ = '' "
    cQuery := ChangeQuery(cQuery)

    //aBindParam := {cCodSeq}
    
    MPSysOpenQuery(cQuery,cAlias,,,/*aBindParam*/)

    if (cAlias)->COUNT > 0
        nCount := (cAlias)->COUNT
    endif
    
    (cAlias)->(DbCloseArea())
    
Return nCount




/*/{Protheus.doc} RTTOTPES
    Retorna total peso
    @type  Static Function
    @author ICMAIS
    @since 14/12/2022
    @version 1.0
    @return cItem, caracter, numero item
/*/
Static Function RTTOTPES(cCodSeq)

    Local nPesTot    := 0
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()

    cQuery := "SELECT SUM(SZB.ZB_PESOBAL) PESO FROM "+ RetSqlName("SZB") +" SZB "     
    //cQuery += " WHERE SZB.ZB_ITF14 = '"+ AllTrim(cGetGS1) +"'" 
    cQuery += "INNER JOIN "+ RetSqlName("ZPA") +" ZPA ON ZPA.ZPA_PALETE = '"+ cCodSeq +"' AND ZPA.ZPA_GS1 = SZB.ZB_ITF14 AND ZPA.D_E_L_E_T_ = '' "
    cQuery += " AND SZB.D_E_L_E_T_ = '' " 
    
    cQuery := ChangeQuery(cQuery)

    MPSysOpenQuery(cQuery,cAlias,,,)

    if (cAlias)->PESO > 0
        nPesTot := (cAlias)->PESO
    endif
    
    (cAlias)->(DbCloseArea())
    
Return nPesTot




/*/{Protheus.doc} User Function ICP04INI
    Retorna dados inicializacao campos
    @type  Function
    @author ICMAIS
    @since 04/11/2022
    @version version
    @param cOpcao, caracter, opcao 
    @return nRet, numerico, peso ou item
/*/
User Function ICP05INI(cOpcao)
    Local nRet       := 0
    Default cCodSeq  := M->ZPA_PALETE   

    Do Case
    Case cOpcao == "RTCOUNTIT"
        nRet := RTCOUNTIT(cCodSeq)   
    Case cOpcao == "RTTOTPES"
        nRet := RTTOTPES(cCodSeq)   
    EndCase
    
Return nRet




/*/{Protheus.doc} User Function IPCP05AC
    Associar caixa
    @type  Function
    @author ICMAIS
    @since 15/12/2022
    @version 1.0
/*/
User Function IPCP05AC()
    if MsgNoYes("Deseja associar caixa no palete "+ZPA->ZPA_PALETE, "ATENÇÃO")
        U_IPCP05IC(ZPA->ZPA_PALETE)
    endif
Return 



/*/{Protheus.doc} User Function ETQPALE1
    impressao etiqueta
    @type  Function
    @author ICMAIS
    @since 13/01/2023
    @version 1.0
/*/
User Function ETQPALE0()
    if MsgNoYes("Deseja imprimir Etiqueta para palete "+ZPA->ZPA_PALETE, "ATENÇÃO")
        U_PRINTETQ(ZPA->ZPA_PALETE)
    endif
Return


/*/{Protheus.doc} User Function PRINTETQ
    Tela inclusao palete
    @type  Function
    @author ICMAIS
    @since 14/12/2022
    @version 1.0
/*/
User Function PRINTETQ(cCodAlt)

    Local aArea        := GetArea()
    Local cAlSZB       := GetNextAlias()
    Local aDados       := {}
    Local cProduto   := ""
    Local cDescProd  := ""
    Local cLote      := ""
    Local cDataVal   := ""
    Local cAno      := ""
    Local cMes      := ""
    Local cDia      := ""
    Private cCodPalete := ""
    Private cCodCX     := "" 
    Private nCounIt    := ""
    Private nPeso      := 0
    Private cQuery     := ""
    Private nN         := 0
    Private nRegSZB    := 0
    Private nNex       := 0
    Private nX         := 0
    


    
    cCodPalete  := cCodAlt   // RECEBE CODIGO DO PALETE
    nCounIt  := RTCOUNTIT(cCodAlt) // TOTAL DE CAIXAS  
    nPeso    := RTTOTPES(cCodAlt)  // PESO 
  
  //MsgInfo( 'Codigo Palete '+ ALLTRIM(cCodPalete) , 'I M P R E S S A O ' )
    // PEGA O CODIGO DA CAIXA QUE ESTA NO PALETE
    if ! Empty(cCodPalete)
        DbSelectArea("ZPA")
        ZPA->(DbSetOrder(1))
        ZPA->(DbGoTop())
        if dbSeek(xFilial("ZPA")+cCodPalete)  
            While !ZPA->( EOF() )
            // CRIA for OU forEach para pegar todas as caixa
                if nN == 0
                cCodCX := "('"+ ALLTRIM( ZPA->ZPA_GS1 )+ "'"
                else
                
                cCodCX += ", '"+ALLTRIM( ZPA->ZPA_GS1 )+"'"
                EndIF
                nN ++
            ZPA->( DbSkip() )
            EndDo
        endif
    EndIF


    if !Empty(cCodCX)
        // FECHA IN PARA QUERY
        cCodCX += ")"

        cQuery := "SELECT SZB.ZB_PRODUTO, SB1.B1_DESC, SZB.ZB_LOTECTL, SZB.ZB_DATAVLD FROM "+ RetSqlName("SZB") +" SZB " 
        cQuery += " INNER JOIN "+ RetSqlName("SB1") +" SB1 ON SB1.B1_COD=SZB.ZB_PRODUTO AND SB1.D_E_L_E_T_<>'*' "
        cQuery += " WHERE SZB.ZB_ITF14 IN "+ AllTrim(cCodCX) 
        cQuery += " AND SZB.D_E_L_E_T_ = '' " 
        //MemoWrite("ETAPALETE.sql",  cQuery)
        cQuery := ChangeQuery(cQuery)

        MPSysOpenQuery(cQuery,cAlSZB)

         While !Eof()
			nRegSZB := nRegSZB +1 
			(cAlSZB)->(dbSkip())
		Enddo
        nTotalReg := nRegSZB
        (cAlSZB)->(dbGoTop()) 

          MemoWrite("ETAPALETE1.sql",  alltrim((cAlSZB)->ZB_PRODUTO))
        if !Empty((cAlSZB)->ZB_PRODUTO)
           
               MemoWrite("ETAPALETE1.sql",  "entrou if")
            While !(cAlSZB)->( EOF() )
              // MSGInfo("PRODUTO"+ ALLTRIM((cAlSZB)->ZB_PRODUTO) + " DESCRI="+ALLTRIM((cAlSZB)->B1_DESC ) + "lote="+ALLTRIM((cAlSZB)->ZB_LOTECTL ) + "data v"+ALLTRIM((cAlSZB)->ZB_DATAVLD )) 
                cProduto := ALLTRIM((cAlSZB)->ZB_PRODUTO)
                cDescProd := ALLTRIM((cAlSZB)->B1_DESC )

                // CRIAR FUNCAO PARA VER SE O LOTE JA FOI ATRIBUIDO A VARIAVEL OU MUDAR PARA VETOR
                if ALLTRIM((cAlSZB)->ZB_LOTECTL ) $ cLote
                
                else
                   cLote += ALLTRIM((cAlSZB)->ZB_LOTECTL )+" "
                cAno := SUBSTR(ALLTRIM((cAlSZB)->ZB_DATAVLD), 0, 4) 
                cMes := SUBSTR(ALLTRIM((cAlSZB)->ZB_DATAVLD), 4, 2) 
                cDia := SUBSTR(ALLTRIM((cAlSZB)->ZB_DATAVLD), 6, 2)
                cDataVal += cDia+"/"+cMes+"/"+cAno+" "
                EndIf

             
			 (cAlSZB)->(dbSkip())
		    Enddo	
                
        else
        MemoWrite("ETAPALETE1.sql",  "entrou else")
            FWAlertError("Produto não encotrado no pedido!", "ATENÇÃO")
        endif

         (cAlSZB)->(DbCloseArea())
       

    endif

     // CRIA O VETOR PARA MANDA PARA FONTE DA ETIQUETA
     aAdd(aDados, ALLTRIM(cCodPalete) ) //01 - CODIGO DO PALETE
     aAdd(aDados, ALLTRIM(cProduto)) //02 - CODIGO DO PRODUTO
     aAdd(aDados, ALLTRIM(cDescProd))//- 03 - DESCRICAO DO ITEM
     aAdd(aDados, ALLTRIM(STR(nCounIt)) )  // 04 - QUANTIADE DE CAIXAS
     aAdd(aDados, ALLTRIM(STR(nPeso)))  // 05 - PESO 
     aAdd(aDados,ALLTRIM(cLote)) // 06 - LOTE   EXEMPLO: LT2022A - LT2023A
     aAdd(aDados,ALLTRIM(cDataVal))  // 07 - DATAS  VALIDADE , MAIS DE UMA DATA CONFORME O LOTE EXEMPLO: 31/12/2022 - 05/08/2023
     aAdd(aDados,""+AllTrim( cUsername ))  // 08 - CONFERENTE -FILIAL - R

     U_ETQPALT1(aDados)


    RestArea(aArea)
    
Return 
