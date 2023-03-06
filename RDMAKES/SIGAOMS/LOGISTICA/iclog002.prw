#include "rwmake.ch"
#include "protheus.ch"

/*/{Protheus.doc} User Function ICLOG002
    Tela associar veiculo embarque
    @type  Function
    @author ICMAIS
    @since 26/11/2021
    @version 1.0
    @param cSimula, character, codigo simulacao
    @return logical, lDone
/*/
User Function ICLOG002(cSimula)
    
    Local aArea     := GetArea()
    local lDone     := .F. as logical

    DEFAULT cSimula := ""

    if !Empty(cSimula)
        lDone := TELAVEI(cSimula)
    else
        MsgAlert("Simulação não encotrada, favor verificar os parâmetros.", "ATENÇÃO")
    endif

    RestArea(aArea)
Return lDone



/*/{Protheus.doc} TELAVEI
    Tela associacao de veiculo
    @type Function
    @author ICMAIS
    @since 26/11/2021
    @version 1.0
    @return logical, lOkPressed
/*/
Static Function TELAVEI(cCodSimu)

    Local lOK       := .F.
    Local oDlgAg    := nil
    Local bBtnOK  	:= {|| lOK := VldAgvOK(), IF(lOK, oDlgAg:End(), ) }
    Local bBtnCan 	:= {|| lOK := .F., oDlgAg:End() }
    Local aButtons	:= {}
    local oLbTran   := nil
    local oLbDTra   := Nil
    local cDesTra   := Space( TAMSX3("A4_NOME")[1] )
    
    private oGetTra := Nil
    Private oSDsVei := nil 
    Private oSPlaca := nil
    Private oSCapac := nil
    Private oGetMot := nil
    Private cGetHor := Space(5)
    Private dGetEmb := CTOD("//")
    Private dGetSep := CTOD("//")
    Private cSimula := cCodSimu
    Private cGetVei := Space(TamSX3("DA3_COD")[1])  
    Private cGetMot := Space(TamSX3("DA4_COD")[1])  
    Private cDesVei := ""
    Private cPlaca  := ""
    Private cNomMot := ""
    Private cGetObs := Space(TamSX3("ZN1_OBS")[1])
    private cGetTra := Space(TAMSX3("ZN1_TRANSP")[1])
    Private nCapac  := 0

    DbSelectArea("ZN1")
    ZN1->(DbSetOrder(1))
    ZN1->(dbGoTop())
    if dbSeek(xFilial("ZN1")+cSimula)
        cGetVei := ZN1->ZN1_VEICUL   
        cGetMot := ZN1->ZN1_MOTORI
        cDesVei := ZN1->ZN1_DESVEI
        cNomMot := ZN1->ZN1_NOMMOT
        cPlaca  := ZN1->ZN1_PLACA
        cGetHor := ZN1->ZN1_HORA 
        dGetEmb := ZN1->ZN1_DTEMB
        dGetSep := ZN1->ZN1_DTSEP
        nCapac  := ZN1->ZN1_CAPACI
        cGetObs := ZN1->ZN1_OBS
        cGetTra := ZN1->ZN1_TRANSP
        cDesTra := retField( "SA4", 1, FWxFilial( "SA4" ) + cGetTra, "A4_NOME" )
    endif

    oTFont12n := TFont():New('Tahoma',,-14,.T.,.T.)
    oTFont12 := TFont():New('Tahoma',,-14,.T.,.F.)

    DEFINE MSDIALOG oDlgAg TITLE "Associar Veiculo / Embarque" FROM 1,1 TO 370,680 PIXEL

    oSLbSim := TSay():New(35,10,{||'Simulação: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oSSimu  := TSay():New(35,50,{||cSimula},oDlgAg,,oTFont12,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

    oSLbVei := TSay():New(53,10,{||'Veiculo: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGetVei := TGet():New(50,40,{|u| If(PCount()>0,cGetVei:=u,cGetVei)},oDlgAg,55,12,'',{|| ATUVEIC() },CLR_BLACK,CLR_WHITE,oTFont12,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA3","cGetVei",,)
    oSDsVei := TSay():New(53,100,{|u| If(PCount()>0,cDesVei:=u,cDesVei)},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    
    oSLbPla := TSay():New(70,10,{||'Placa: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oSPlaca := TSay():New(70,40,{|u| If(PCount()>0,cPlaca:=u,cPlaca)},oDlgAg,,oTFont12,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oSLbCap := TSay():New(70,90,{||'Capacidade: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oSCapac := TSay():New(70,150,{|u| If(PCount()>0,nCapac:=u,nCapac)},oDlgAg,PesqPict("DA3","DA3_CAPACM"),oTFont12,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

    oSLbMot := TSay():New(88,10,{||'Motorista: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGetMot := TGet():New(85,60,{|u| If(PCount()>0,cGetMot:=u,cGetMot)},oDlgAg,50,12,'',{|| ATUMOT() },CLR_BLACK,CLR_WHITE,oTFont12,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA4","cGetMot",,)
    oSDsMot := TSay():New(88,120,{|u| If(PCount()>0,cNomMot:=u,cNomMot)},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

    oSLbSep := TSay():New(108,10,{||'Data separação: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGetSep := TGet():New(105,80,{|u| If(PCount()>0,dGetSep:=u,dGetSep)},oDlgAg,60,12,'',,CLR_BLACK,CLR_WHITE,oTFont12,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetSep",,)
    oSLbEmb := TSay():New(108,150,{||'Data Embarque: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGetEmb := TGet():New(105,220,{|u| If(PCount()>0,dGetEmb:=u,dGetEmb)},oDlgAg,60,12,'',,CLR_BLACK,CLR_WHITE,oTFont12,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetEmb",,)

    oSLbHor := TSay():New(128,10,{||'Hora Prev. Embarque: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGetHor := TGet():New(125,100,{|u| If(PCount()>0,cGetHor:=u,cGetHor)},oDlgAg,25,12,'99:99',,CLR_BLACK,CLR_WHITE,oTFont12,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetHor",,)

    oSLbHor := TSay():New(148,10,{||'Observação: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGetHor := TGet():New(145,60,{|u| If(PCount()>0,cGetObs:=u,cGetObs)},oDlgAg,250,12,'',,CLR_BLACK,CLR_WHITE,oTFont12,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetObs",,)

    oLbTran := TSay():New(168,10,{||'Transportador: '},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,060,20)
    oGetTra := TGet():New(165,70,{|u| If(PCount()>0,cGetTra:=u,cGetTra)},oDlgAg,030,12,'',{|| oLbDTra:SetText( changeTrans( cGetTra ), oLbDTra:CtrlRefresh() ) },;
               CLR_BLACK,CLR_WHITE,oTFont12,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA4","cGetTra",,)
    oLbDTra := TSay():New(168,110,{|u| if(PCount()>0,cDesTra:=u,cDesTra)},oDlgAg,,oTFont12n,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

    ACTIVATE MSDIALOG oDlgAg CENTERED ON INIT EnchoiceBar(oDlgAg, bBtnOK, bBtnCan,,aButtons,,,.F.,.F.,.F.)

Return lOk

/*/{Protheus.doc} changeTrans
Função para retornar nome da transportadora
@type function
@version  1.0
@author Igor
@since 09/02/2022
@param cTransp, character, código da transportadora (obrigatório)
@return character, cTranspName
/*/
static function changeTrans( cTransp )
return retField( "SA4", 1, FWxFilial( "SA4" ) + cTransp, "A4_NOME" )


/*/{Protheus.doc} ATUVEIC
    Atualiza dados do veiculo
    @type  Static Function
    @author ICMAIS
    @since 29/11/2021
    @version 1.0
/*/
Static Function ATUVEIC()

    Local aArea := GetArea()

    DbSelectArea("DA3")
    DA3->(DbSetOrder(1))
    DA3->(dbGoTop())
    if dbSeek(xFilial("DA3")+cGetVei)
        cDesVei := DA3->DA3_DESC
        oSDsVei:SetText(cDesVei)
        oSDsVei:CtrlRefresh()
        cPlaca := DA3->DA3_PLACA
        oSPlaca:SetText(cPlaca)
        oSPlaca:CtrlRefresh()
        nCapac := DA3->DA3_CAPACM
        oSCapac:SetText(nCapac)
        oSCapac:CtrlRefresh()
    endif

    RestArea(aArea)

Return 




/*/{Protheus.doc} ATUMOT
    Atualiza dados do motorista
    @type  Static Function
    @author ICMAIS
    @since 29/11/2021
    @version 1.0
/*/
Static Function ATUMOT()

    Local aArea := GetArea()

    DbSelectArea("DA4")
    DA4->(DbSetOrder(1))
    DA4->(dbGoTop())
    if dbSeek(xFilial("DA4")+cGetMot)
        cNomMot := DA4->DA4_NOME
        oSDsMot:SetText(cNomMot)
        oSDsMot:CtrlRefresh()
    endif

    RestArea(aArea)
    
Return 




/*/{Protheus.doc} VldAgvOK
    Grava ou atualiza associacao veiculo
    @type  Static Function
    @author user
    @since 01/12/2021
    @version version
    @return lRet, logico, retorno
/*/
Static Function VldAgvOK()
    Local lRet := .F.

    if MsgYesNo("Realmente deseja associar este veiculo?", "ATENÇÃO")

        DbSelectArea("ZN1")
        ZN1->(DbSetOrder(1))
        ZN1->(dbGoTop())
        if dbSeek(xFilial("ZN1")+cSimula)
            RecLock("ZN1", .F.)
        else
            RecLock("ZN1",.T.)
        endif

        ZN1->ZN1_FILIAL := xFilial("ZN1")
        ZN1->ZN1_SIMULA := cSimula
        ZN1->ZN1_VEICUL := cGetVei    
        ZN1->ZN1_MOTORI := cGetMot 
        ZN1->ZN1_DESVEI := cDesVei 
        ZN1->ZN1_NOMMOT := cNomMot 
        ZN1->ZN1_PLACA  := cPlaca 
        ZN1->ZN1_HORA   := cGetHor 
        ZN1->ZN1_DTEMB  := dGetEmb 
        ZN1->ZN1_DTSEP  := dGetSep 
        ZN1->ZN1_CAPACI := nCapac 
        ZN1->ZN1_OBS    := cGetObs
        ZN1->ZN1_REVISA += 1
        ZN1->ZN1_TRANSP := cGetTra
        ZN1->(MsUnlock())

        lRet := .T.
       // MsgInfo("Evento WorkFlow Disparado!", "Aviso")
       if MsgYesNo( 'Deseja ajustar a sequencia de carga e realizar o disparo do workflow?', 'Sequencia de Carregameto e Workflow' )
            U_FWSEP001( xFilial("ZN1"), cSimula, "01", 2 )
        endif
    endif
    
Return lRet
