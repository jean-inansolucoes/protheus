#include "protheus.ch"
#include "totvs.ch"

user function ACC00006(oBrowse2)
    
    Local oNewPag  
    Local cCard   := Space(6)  
    Local cLayout   := Space(6)
    Local cFiliais  := ""
    Local cMes      := Space(2)
    Local cAno      := Space(4)
    Local oStepWiz  := nil
    Local oDlg      := nil    
    Local aWiz      := {}
    Local aIdLog    := {}
    Local cId       :=  ""
    
    Private oPanel
    Private oPanelBkg
    Private aLst   := {}
    Private oListBox   
    Private oTMultiget1
    Private cTexto1 := ""
    Private cDesc   := ""

    DEFINE DIALOG oDlg TITLE 'Tela de Requisição' PIXEL STYLE nOR(  WS_VISIBLE ,  WS_POPUP )
    oDlg:nWidth := 800
    oDlg:nHeight := 620

    oPanelBkg:= tPanel():New(0,0,"",oDlg,,,,,,300,300)
    oPanelBkg:Align := CONTROL_ALIGN_ALLCLIENT

     /* Define o tipo e tamanho da fonte */
    Define Font oFont1     Name "Arial" Size 9,18
    Define Font oFontCabec Name "Arial" Bold Size 10,21 
        
    oStepWiz := FWWizardControl():New(oPanelBkg)
    oStepWiz:ActiveUISteps()
    
    //----------------------
    // Pagina 1
    //----------------------
    oNewPag := oStepWiz:AddStep("1")    
    oNewPag:SetStepDescription("Bem-Vindo(a)")
    oNewPag:SetConstruction({|Panel|cria_pg1(Panel)})
    oNewPag:SetNextAction({|| .T.})
    oNewPag:SetCancelAction({||.T., oDlg:End()})
    
    //----------------------
    // Pagina 2
    //----------------------
    oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel, @cCard, @cLayout, @cFiliais, @cMes, @cAno, @aWiz)})
    oNewPag:SetStepDescription("Segundo passo")
    oNewPag:SetNextAction({||valida_pg2(@cCard, @cMes, @cAno)})    
    oNewPag:SetCancelAction({||.T., oDlg:End()})  
    oNewPag:SetPrevAction({|| .F.})
    oNewPag:SetPrevTitle("Voltar")
    
    //----------------------
    // Pagina 3
    //----------------------
   
    //----------------------
	// Pagina 4
	//----------------------    
    //Ajustado para ocultar filiais
    oNewPag := oStepWiz:AddStep("3", {|Panel|cId := cria_pg4(Panel, @cCard, @cLayout, @cFiliais,@cMes, @cAno, @aWiz, oBrowse2)})
    oNewPag:SetStepDescription("Terceiro passo")
    oNewPag:SetNextAction({||.T., oDlg:End()})
    oNewPag:SetCancelAction({||.T., oDlg:End()})
    oNewPag:SetCancelWhen({||.F.})
        
    //Ativa Wizard
    oStepWiz:Activate()
    
    ACTIVATE DIALOG oDlg CENTER

    //Desativa Wizard
    oStepWiz:Destroy()

   if !Empty(cId)
        if MsgYesNo( "Deseja realizar o envio dos dados para Accountfy?" )	
            aadd(aIdLog, cCard)
            aadd(aIdLog, cId)
            aadd(aIdLog, cId)

            U_ACC00007(oBrowse2,.T.,aIdLog)

        endif
    endif

Return 
//--------------------------
// Construção da página 1
//--------------------------
Static Function cria_pg1(oPanel)
    Local oSay1 
    Local oImg1
        
    Private cColorBackGround     := "#FFFFFF"       
    Private cColorSeparator     := "#C0C0C0"       
    Private cGradientTop         := "#FFFFFF"
    Private cGradientBottom     := "#FFFFFF"
    Private cColorText        := "#990000"        

    oImg1 := TBitmap():New( 10,150,60,60,,"\system\ACC.png",.F.,oPanel,,,.F.,.T.,,"",.T.,,.T.,,.F. )    
    oSay1 := TSay():New(90,80,{||'Rotina responsável pela requisição do lançamento contábil.'},oPanel,,oFontCabec,,,,.T.,,,250,20)
   	
Return
 
//--------------------------
// Construção da página 2
//--------------------------
Static Function cria_pg2(oPanel, cCard, cLayout, cFiliais, cMes, cAno, aWiz)
    
    Local oTGet1
    Local oTGet2
    Local oTGet3 
    Local oTGet4

    oSay1   := TSay():New(35,10,{||'Card'},oPanel,,,,,,.T.,,,200,20)    
    oTGet1  := tGet():New(35,50,{|u| if(PCount()>0,cCard:=u,cCard)}, oPanel ,60,10,"@!",{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"ZKX","cCard")

    oSay2   := TSay():New(55,10,{||'Layout'},oPanel,,,,,,.T.,,,200,20)    
    oTGet2  := tGet():New(55,50,{|u| if(PCount()>0,cLayout:=u,cLayout)}, oPanel ,60,10,"@!",{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"ZKT","cLayout")
    
    oSay3   := TSay():New(75,10,{||'Mês'},oPanel,,,,,,.T.,,,100,20)
    oTGet3  := tGet():New(75,50,{|u| if(PCount()>0,cMes:=u,cMes)}, oPanel ,20,10,"@99",{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,"cMes")

    oSay4   := TSay():New(95,10,{|| 'Ano'},oPanel,,,,,,.T.,,,100,20)
    oTGet4  := tGet():New(95,50,{|u| if(PCount()>0,cAno:=u,cAno)}, oPanel ,30,10,"@9999",{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,"cAno")

Return

//----------------------------------------
// Validação do botão Próximo da página 2
//----------------------------------------
Static Function valida_pg2(cCard, cMes, cAno)
    
    If Empty(cCard)
        Alert("Informe o card !")
        Return(.F.)
    EndIf

    If Empty(cMes)
        Alert("Informe o mês !")
        Return(.F.)
    EndIf

    If Empty(cAno)
        Alert("Informe o ano !")
        Return(.F.)
    EndIf

Return(.T.)

//--------------------------
// Construção da página 4
//--------------------------
Static Function cria_pg4(oPanel, cCard, cLayout, cFiliais, cMes, cAno, aWiz, oBrowse2)
    Local oSayG
    Local n
    Private oProcess
    Private cId := ""
    Private lAllEmp := SuperGetMV("SA_EMPACC",.F.,.F.)
    Private lCheckUser := SuperGetMV("SA_USRACC",.F.,.T.)
   
    cFiliais := ' '

    aRet := FwListBranches(lCheckUser,lAllEmp,.T.,{'FLAG','SM0_EMPRESA','SM0_CODFIL','SM0_NOMRED'})
            
 
    For n := 1 To Len(aRet)
        cFiliais += Alltrim(aRet[n][3]) + "/"
    Next 

    cFiliais := lTrim(cFiliais)

    MsAguarde({|| cId := fProcessa(cLayout, cCard, cFiliais, cMes, cAno, aWiz) } , "Aguarde", "Requisitando os dados no protheus...")
    
    if !Empty(cId)
        oSayG  := TSay():New(50,50,{||'Processamento de dados realizada com sucesso!'},oPanel,,oFontCabec,,,,.T.,,,250,20)        
    else
        oSayG  := TSay():New(50,50,{||'Erro no processamento!'},oPanel,,oFontCabec,,,,.T.,,,250,20)        
    endif
    
Return cId

Static function fProcessa(cLayout, cCard, cFiliais, cMes, cAno,  aWiz)

    Local oAccread   := ACCOREAD():New()    
    Local lReturn    := .F.
    Local cFilExp    := ""
    Local nCount     := 0
    Local cData      := ""
    Local cRes       := ""    

    nCount  := 0
    cFilExp := ""
    cData := strzero(val(cAno),4) + strzero(val(cMes),2)
    cRes := oAccread:LoadDados(cLayout, cCard, cFiliais, cData, .T.)     
    lReturn := .T.   
        
Return cRes
