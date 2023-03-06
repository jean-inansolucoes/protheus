#include 'protheus.ch'
#Include "FwMvcDef.CH"
#include "APWIZARD.CH"

/*{Protheus.doc} ACC00001
Dashboard Accountfty    
@author Fernando Oliveira Feres
@since 19/10/2020   
@version 1.0
@return Nil
*/
User Function ACC00001()

    local aCoors            as array   
    local oFWLayer          as object 
    local oBrowse1          as object 
    local oBrowse2          as object 
    local oBrowse3          as object 
    local oBrowse4          as object 
    local oBrowse5          as object
    local aParamBox         as array
    local oImg              as object    
    local oSay1             as object
    local oTGet1            as object 
    local oSay2             as object
    local oTGet2            as object
    local oSay3             as object
    local oTGet3            as object
    local oSay4             as object
    local oTGet4            as object
    local oSay5             as object
    local oTGet5            as object
    local oSay6             as object
    local oTGet6            as object
    local oSay7             as object
    local oTGet7            as object
    local oSay8             as object
    local oLayer2           as object
    local oPnlDoc2          as object    
    local oPanel2           as object    
    local oGrp1     		as object
    private aRetPar         as array
    private oFold           as object
    private oBrowseLeft     as object 
    private oBrowsePrinc    as object
    Private oDlgPrinc       as object
    private cCadastro       as character
    private oSayFtp         as object
    private oSayTot         as object
    private oSayPend        as object
    private oSayOk          as object
    private oSayError       as object    

    private cCod              := Space(06)
    private cDesc             := Space(30)
    private cUrl              := Space(100)
    private cEnd              := Space(100)
    private cCliId            := Space(50)
    private cCliSt            := Space(100)
    private cCnpj             := Space(14)

    
    //-------------------------------------
    //Inicialização de variáveis
    //-------------------------------------
    cCadastro := ""
    aParamBox := {}
    aRetPar   := {firstDay(date()), date()}
    aCoors    := FWGetDialogSize(oMainWnd)

    Define MsDialog oDlgPrinc Title 'Conexão Accountfy' From aCoors[1], aCoors[2] to aCoors[3], aCoors[4] Pixel

    //--------------------------------------------------
    // Cria o conteiner onde serão colocados os browses
    //--------------------------------------------------
    oFWLayer := FWLayer():New()
    oFWLayer:Init( oDlgPrinc, .F., .T. )

    //-----------------------------------------------
    //Definição do Painel 
    //-----------------------------------------------
    oFWLayer:AddLine( 'PANEL', 100, .T. )                 //Cria uma "linha" com 100% da tela
    oFwLayer:AddCollumn('MENU', 20, .F.,'PANEL')          //Painel do menu
    oFWLayer:AddCollumn( 'ALL', 80, .F., 'PANEL' )        //Painel central
    oPanelMenu := oFWLayer:GetColPanel( 'MENU', 'PANEL' )
    oPanel     := oFWLayer:GetColPanel( 'ALL', 'PANEL'  ) 

    //-----------------------------------------------------
    //Criação das abas
    //-----------------------------------------------------
    oFold := TFolder():New(0,0,{},,oPanel,,,,.T.,.F.,539,140)
    oFold:Align := CONTROL_ALIGN_ALLCLIENT
    oFold:Hide()
    oFold:Show()    
    oFold:AddItem("Log Integração")
    oFold:AddItem("Cadastro de Conexões")
    oFold:AddItem("Conectividade")
    oFold:AddItem("Config. De/Para")
    oFold:AddItem("Cadastro de Etiquetas")
        

    oAba01 := oFold:aDialogs[1]
    oAba02 := oFold:aDialogs[2]
    oAba03 := oFold:aDialogs[3]
    oAba04 := oFold:aDialogs[4]
    oAba05 := oFold:aDialogs[5]
    
    //------------------------
    //Criação do logotipo
    //------------------------
    oImg := TBitmap():New(80,002,170,140,,"\system\ACC.png",.T.,oPanelMenu, {||},,.F.,.F.,,,.F.,,.T.,,.F.)//centralizado

    //----------------------------------------
    //Criação dos botões de integração manual 
    //----------------------------------------
    oTButton1 := TButton():New( 220, 040, "Requisição Protheus"  ,oPanelMenu,{||U_ACC00006(oBrowse2)}    , 110,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
    oTButton2 := TButton():New( 250, 040, "Enviar Accountfy"      ,oPanelMenu,{||U_ACC00007(oBrowse2,.F.,aParamBox)}  , 110,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
    
    //------------------------------------
    // Browse da aba Log de Integração
    //------------------------------------
    oBrowse2:=U_ACC00004()
    oBrowse2:SetOwner( oAba01 )
    oBrowse2:SetProfileID( '1' )

    //--------------------
    // Ativa o Browse
    //--------------------
    oBrowse2:Activate()

    //------------------------------------
    // Browse da aba Cadastro de Conexões
    //------------------------------------
    oBrowse3:=U_ACC00010()
    oBrowse3:SetOwner( oAba02 )
    oBrowse3:SetProfileID( '2' )

    //--------------------
    // Ativa o Browse
    //--------------------
    oBrowse3:Activate()
    

    //----------------------
    // Criação ABA Conectividade
    //----------------------
    oLayer2 := FwLayer():New()
    oLayer2:Init(oAba03)
    
    oLayer2:AddLine('LIN1', 100, .F.)
    oLayer2:AddCollumn('COL1', 100, .T., 'LIN1')
    oLayer2:AddWindow('COL1', 'PAR'    , ''        , 100, .F. ,.T.,, 'LIN1', { || })

    oPnlDoc2 := oLayer2:GetWinPanel('COL1', 'PAR'    , 'LIN1')

   //Parametrização
    oGrp1   := TGroup():New( 008,002,220,300,"Parametrização",oPnlDoc2,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay1   := TSay():New(35,30,{||'Código:'},oGrp1,,,,,,.T.,,,100,20)
    cCod    := Space(06)
    oTGet1  := tGet():New(30,70,{|u| if(PCount()>0,cCod:=u,cCod)}, oGrp1 ,200,10,PesqPict("ZKX","ZKX_CODIGO"),{ || cDesc:=Posicione("ZKX",2,xFilial("ZKX")+cCod,"ZKX_DESC"),;
                cUrl  :=Posicione("ZKX",2,xFilial("ZKX")+cCod,"ZKX_URL") ,;
                cEnd  :=Posicione("ZKX",2,xFilial("ZKX")+cCod,"ZKX_ENDAPI") ,;
                cCliId:=Posicione("ZKX",2,xFilial("ZKX")+cCod,"ZKX_CLIID") ,;
                cCliSt:=Posicione("ZKX",2,xFilial("ZKX")+cCod,"ZKX_CLISEC") ,;
                cCnpj :=Posicione("ZKX",2,xFilial("ZKX")+cCod,"ZKX_CNPJ") },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"ZKX","cCod")
    
    oSay2   := TSay():New(55,30,{||'Descrição:'},oGrp1,,,,,,.T.,,,100,20)
    oTGet2  := tGet():New(50,70,{|u| if(PCount()>0,cDesc:=u,cDesc)}, oGrp1 ,200,10,/*@!*/,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.T.,,,"cDesc")

    oSay3   := TSay():New(75,30,{||'URL:'},oGrp1,,,,,,.T.,,,100,20)
    oTGet3  := tGet():New(70,70,{|u| if(PCount()>0,cUrl:=u,cUrl)}, oGrp1 ,200,10,/*Picture*/,{ || .T. },,,,,,.T.,,,,,,,,,,"cUrl")
    
    oSay4   := TSay():New(95,30,{||'Endereço:'},oGrp1,,,,,,.T.,,,100,20)
    oTGet4  := tGet():New(90,70,{|u| if(PCount()>0,cEnd:=u,cEnd)}, oGrp1 ,200,10,/*@!*/,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.T.,,,"cEnd")

    oSay5   := TSay():New(115,30,{||'Client_id:'},oGrp1,,,,,,.T.,,,100,20)
    oTGet5  := tGet():New(110,70,{|u| if(PCount()>0,cCliId:=u,cCliId)}, oGrp1 ,200,10,/*@!*/,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.T.,,,"cCliId")

    oSay6   := TSay():New(135,30,{||'Client_secret:'},oGrp1,,,,,,.T.,,,100,20)
    oTGet6  := tGet():New(130,70,{|u| if(PCount()>0,cCliSt:=u,cCliSt)}, oGrp1 ,200,10,/*@!*/,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.T.,,,"cCliSt")

    oSay7   := TSay():New(155,30,{||'Cnpj:'},oGrp1,,,,,,.T.,,,100,20)
    oTGet7  := tGet():New(150,70,{|u| if(PCount()>0,cCnpj:=u,cCnpj)}, oGrp1 ,200,10,/*@!*/,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.T.,,,"cCnpj")  //24
    
    oSay8   := TSay():New(10,340,{||'Status:'},oPnlDoc2,,,,,,.T.,,,100,20)
    oPanel2 := TPanelCss():New(20,340,nil,oPnlDoc2,nil,nil,nil,nil,nil,020,020,nil,nil)

    //Função que verifica a conexão
    MsgRun( "Carregando os dados...", "Aguarde", {|| verificaStatus(alltrim(cEnd),alltrim(cCliId),alltrim(cCliSt),oPanel2,oPnlDoc2)})
    
    TButton():New( 180, 30, "Testar", oPnlDoc2,{|| callTest(alltrim(cEnd),alltrim(cCliId),alltrim(cCliSt),oPanel2,oPnlDoc2)},45,015,,,.F.,.T.,.F.,,.F.,,,.F. )     
    
    //------------------------------------
    // Browse da aba De-para
    //------------------------------------
    oBrowse4:=U_ACC00003()
    oBrowse4:SetOwner( oAba04 )
    oBrowse4:SetProfileID( '4' )

    oBrowse4:Activate()

    //------------------------------------
    // Browse da aba Cadastro de Etiquetas
    //------------------------------------
    oBrowse5:=U_ACC00012()
    oBrowse5:SetOwner( oAba05 )
    oBrowse5:SetProfileID( '5' )

    //--------------------
    // Ativa o Browse
    //--------------------
    oBrowse5:Activate()
    
      
    oFold:ShowPage(1)
    
    Activate MsDialog oDlgPrinc Center

Return NIL

/*{Protheus.doc} 
Função para gravar a URL no parametro   
@author Fernando Oliveira Feres
@since 19/10/2020   
@version 1.0
@return Nil
*/
static function callTest(cEnd,cCliId,cCliSt,oPanel,oPnl)
	MsgRun( "Verificando a conexão...", "Aguarde", {|| verificaStatus(cEnd,cCliId,cCliSt,oPanel,oPnl) }) 
return 

/*{Protheus.doc} 
Função para gravar as informações de conexão    
@author Fernando Oliveira Feres
@since 19/10/2020   
@version 1.0
@return Nil
*/
static function atuaParam(cUrl,cEnd,cCliId,cCliSt,cCnpj,oPanel,oPnl)
    
    //Atualiza os parâmetros da conectividade	
    DbSelectArea("ZKX")
    ZKX->(DbSetOrder(1))
    if ZKX->(!DbSeek(xFilial("ZKX")+cCliId))
        If RecLock("ZKX",.T.)
            ZKX->ZKX_FILIAL  := xFilial("ZKX")
            ZKX->ZKX_URL     := cUrl
            ZKX->ZKX_ENDAPI  := cEnd
            ZKX->ZKX_CLIID   := cCliId
            ZKX->ZKX_CLISEC  := cCliSt
            ZKX->ZKX_CNPJ    := cCnpj
            ZKX->(MsUnLock())
        Endif
    else
        If RecLock("ZKX",.F.)
            ZKX->ZKX_FILIAL  := xFilial("ZKX")
            ZKX->ZKX_URL     := cUrl
            ZKX->ZKX_ENDAPI  := cEnd
            ZKX->ZKX_CLIID   := cCliId
            ZKX->ZKX_CLISEC  := cCliSt
            ZKX->ZKX_CNPJ    := cCnpj
            ZKX->(MsUnLock())
        Endif
    endif    

    //Atualiza a conexão
    MsgRun("Salvando as informações...","Aguarde",{ || verificaStatus(cEnd,cCliId,cCliSt,oPanel,oPnl)})

    Msginfo("Salvo com sucesso!")
	
return .T.

/*{Protheus.doc} 
Função que verifica o status da conexão   
@author Fernando Oliveira Feres
@since 19/10/2020   
@version 1.0
@return Nil
*/
static function verificaStatus(cEnd,cCliId,cCliSt,oPanel,oPnl) 
    local lRetorno  := .F.   
    local cResponse	:= ""    
    local cStyle1   := "QFrame{ border-style:solid; border-width:1px; border-color:#000000; background-color:#00FF00 }" //verde
    local cStyle2   := "QFrame{ border-style:solid; border-width:1px; border-color:#000000; background-color:#FF0000 }" //vermelho    
    Local oAccAut   := ACCOUAUT():New()    
    local aResult   := {}
    private cBody   := ""
    private cAccessToken := ""   

    aResult := oAccAut:getAuthToken(cEnd,cCliId,cCliSt)

    if Len(aResult) > 0
        if aResult[1][1] == 1
            cResponse := aResult[1][2]
            oPanel:setCSS(cStyle1)
        else
            cResponse := aResult[1][2]
            oPanel:setCSS(cStyle2)
        endif
    endif

    oTMultiget1 := tMultiget():new( 10, 370, {| u | if( pCount() > 0, cResponse := u, cResponse ) },oPnl,350,165,(TFont():New("Courier New",0,-11, .T. , .T. )),.F.,,,,.T.,,.F.,,.F.,.F.,.T.,,,.F.,, )

return lRetorno
