#INCLUDE 'PROTHEUS.CH'
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTCAD013
  ==============================================================================
    @description
    Amarração de Produtos com suas respectivas características a serem
    medidas pela qualidade, bem como as faixas para aprovação ou descarte
    dos materiais

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 23/12/2020

/*/
//============================================================================\
User Function LTCAD013(  )
    Local cUsrQld	  := GETMV("MX_USR013",, "")
    Private _cRevisao := '000'
    Private oStr3

    dbSelectArea('ZA5')
    dbSelectArea('ZA1')
    dbSelectArea('ZA2')
    
    If !(__cUserId $ cUsrQld)
        MsgAlert("Usuário sem acesso a essa rotina (MX_USR013)")
        Return
    EndIf

Return FWExecView('Análises vs Faixas de Medição','LTCAD013', MODEL_OPERATION_INSERT, , { || .T. }, , , )
// FIM da Funcao LTCAD013
//==============================================================================


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct(1,'ZA5')
	Local oStr2:= FWFormStruct(1,'ZA1')
	Local oStr3:= FWFormStruct(1,'ZA2')


	oModel := MPFormModel():New('mLTCAD013')


	oModel:SetDescription('Amarração Produto vs Características vs Faixas')
	
	//oStr2:SetProperty('ZRK_COD',MODEL_FIELD_OBRIGAT,.F.)
	//oStr1:RemoveField( 'ZRK_DDE' )


    oModel:addFields('MASTER',,oStr1) 
	oModel:SetPrimaryKey({ 'ZA5_FILIAL', 'ZA5_PROD', 'ZA5_REVISA' })

	oModel:addGrid('ZA1DETAIL','MASTER',oStr2)
	oModel:getModel('ZA1DETAIL'):SetDescription('Características')
	oModel:GetModel('ZA1DETAIL'):SetUniqueLine( { 'ZA1_FILIAL', 'ZA1_CARACT' } )
	oModel:SetRelation('ZA1DETAIL', { { 'ZA1_FILIAL', "FwXFilial('ZA1')" },{ 'ZA1_PROD', "ZA5_PROD" },{ 'ZA1_REVISA', "ZA5_REVISA" } }, ZA1->(IndexKey(1)) )
	
	oModel:addGrid('ZA2DETAIL','ZA1DETAIL',oStr3)
	oModel:getModel('ZA2DETAIL'):SetDescription('Faixa de Medições')
	oModel:GetModel('ZA2DETAIL'):SetUniqueLine( { 'ZA2_FILIAL','ZA2_CARACT', 'ZA2_FXDE', 'ZA2_FXATE', 'ZA2_MED' } )
	oModel:SetRelation('ZA2DETAIL', { { 'ZA2_FILIAL', "FwXFilial('ZA2')" },{ 'ZA2_PROD', "ZA5_PROD" },{ 'ZA2_REVISA', "ZA5_REVISA" },{ 'ZA2_CARACT', "ZA1_CARACT" } }, ZA2->(IndexKey(2)) )
	

    oStr3:SetProperty("ZA2_FXDE",MODEL_FIELD_WHEN,{|x,y,z| U_LT013EDIT(x,y,z)})
    oStr3:SetProperty("ZA2_FXATE",MODEL_FIELD_WHEN,{|x,y,z| U_LT013EDIT(x,y,z)})
    oStr3:SetProperty("ZA2_MED",MODEL_FIELD_WHEN,{|x,y,z| U_LT013EDIT(x,y,z)})
    
 
	//oModel:GetModel('MASTER'):SetOnlyQuery(.T.)
    //oModel:getModel('MASTER'):SetOptional(.T.)

	
	


Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZA5')
	Local oStr2:= FWFormStruct(2, 'ZA1')
	oStr3:= FWFormStruct(2, 'ZA2')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'MASTER' )
	oView:AddGrid('FORM2' , oStr2,'ZA1DETAIL')  
	oView:AddGrid('FORM3' , oStr3,'ZA2DETAIL')  
	

    oView:CreateHorizontalBox( 'BOXFORM1', 20)
    oView:CreateHorizontalBox( 'BOXFORM3', 80)
	oView:CreateVerticalBox("LEFTBOX",30,'BOXFORM3')
	oView:CreateVerticalBox("RIGTHBOX",70,'BOXFORM3')
	
	oView:SetOwnerView('FORM1','BOXFORM1')
    oView:SetOwnerView('FORM2','LEFTBOX')
	oView:SetOwnerView('FORM3','RIGTHBOX')
	
    oView:AddIncrementField('FORM2', 'ZA1_ORDEM')
	oView:EnableTitleView('FORM2' , 'Análises a serem avaliadas' ) 
	oView:EnableTitleView('FORM3' , 'Faixas de Medições do CQ' ) 

    oStr2:RemoveField( 'ZA1_PROD' )
	oStr2:RemoveField( 'ZA1_REVISA' )
	oStr3:RemoveField( 'ZA2_PROD' )
    oStr3:RemoveField( 'ZA2_REVISA' )
    oStr3:RemoveField( 'ZA2_CARACT' )

    
    // Realiza carga inicial dos dados em caso de renegociação
    oView:SetAfterViewActivate({|oView| LoadAnalises(oView) })

Return oView


Static Function LoadAnalises( oView )

	Local oModelZA5	:= oView:GetModel("MASTER")
	Local oModelZA1	:= oView:GetModel("ZA1DETAIL")
	Local oModelZA2	:= oView:GetModel("ZA2DETAIL")
	Local _lPrimZA1	:= .T.
    Local _lPrimZA2	:= .T.
    Local _nLinZA1  := 0
    Local _nLinZA2  := 0
    Local _nLinAtu  := 0

    dbSelectArea('ZA5')
    ZA5->(dbSetOrder(1)) 
    ZA5->(dbGoTop())
    If ZA5->(dbSeek(xFilial('ZA5')+SB1->B1_COD))
        While ZA5->(!Eof()) .And. ZA5->ZA5_FILIAL+ZA5->ZA5_PROD == SB1->B1_FILIAL+SB1->B1_COD
            _cRevisao := ZA5->ZA5_REVISAO
            
            ZA5->(DbSkip())
        EndDo
    EndIf
	
	If oView:GetModel():GetOperation() == MODEL_OPERATION_INSERT
        oModelZA5:LoadValue("ZA5_REVISA"    , Soma1(_cRevisao))
        oModelZA5:LoadValue("ZA5_PROD"      , SB1->B1_COD)
        oModelZA5:LoadValue("ZA5_DESCR"     , SB1->B1_DESC)
        
        dbSelectArea('ZA1')
        ZA1->(dbSetOrder(1)) 
        ZA1->(dbGoTop())
        If ZA1->(dbSeek(xFilial('ZA1')+SB1->B1_COD+_cRevisao))
            While !ZA1->(EOF()) .AND. ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA == xFilial('ZA1')+SB1->B1_COD+_cRevisao
                If _lPrimZA1
                    _lPrimZA1 := .F.
                Else
                    _nLinAtu := oModelZA1:Length()
                    _nLinZA1 := oModelZA1:AddLine()

                    If _nLinZA1 <> (_nLinAtu + 1)
                        oView:ShowLastError()
                        oView:Refresh()
                        Return (.F.)
                    EndIf
                EndIf

                oModelZA1:LoadValue('ZA1_PROD'  , SB1->B1_COD )
                oModelZA1:LoadValue('ZA1_REVISA', Soma1(_cRevisao) )
                oModelZA1:LoadValue('ZA1_CARACT', ZA1->ZA1_CARACT )
                oModelZA1:LoadValue('ZA1_DESCR', ZA1->ZA1_DESCR )
                oModelZA1:LoadValue('ZA1_ORDEM' , ZA1->ZA1_ORDEM )
                oModelZA1:LoadValue('ZA1_TIPO'  , ZA1->ZA1_TIPO )

                dbSelectArea('ZA2')
                ZA2->(dbSetOrder(1)) 
                ZA2->(dbGoTop())
                If ZA2->(dbSeek(xFilial('ZA2')+SB1->B1_COD+_cRevisao+ZA1->ZA1_CARACT))
                    While !ZA2->(EOF()) .AND. ZA2->(ZA2_FILIAL+ZA2_PROD+ZA2_REVISA+ZA2_CARACT) == xFilial('ZA2')+SB1->B1_COD+_cRevisao+ZA1->ZA1_CARACT
                        If _lPrimZA2
                            _lPrimZA2 := .F.
                        Else
                            _nLinAtu := oModelZA2:Length()
                            _nLinZA2 := oModelZA2:AddLine()

                            If _nLinZA2 <> (_nLinAtu + 1)
                                oView:ShowLastError()
                                oView:Refresh()
                                Return (.F.)
                            EndIf
                        EndIf

                        oModelZA2:LoadValue('ZA2_PROD'  , SB1->B1_COD )
                        oModelZA2:LoadValue('ZA2_REVISA', Soma1(_cRevisao) )
                        oModelZA2:LoadValue('ZA2_CARACT', ZA2->ZA2_CARACT )
                        oModelZA2:LoadValue('ZA2_FXDE'  , ZA2->ZA2_FXDE )
                        oModelZA2:LoadValue('ZA2_FXATE' , ZA2->ZA2_FXATE )
                        oModelZA2:LoadValue('ZA2_MED'   , ZA2->ZA2_MED )
                        oModelZA2:LoadValue('ZA2_DESMED', ZA2->ZA2_MED )
                        oModelZA2:LoadValue('ZA2_RESULT', ZA2->ZA2_RESULT )
                        /* oModelZA2:LoadValue('ZA2_DTINI' , ZA2->ZA2_DTINI )
                        oModelZA2:LoadValue('ZA2_DTFIM' , ZA2->ZA2_DTFIM ) */
                          
                        ZA2->(dbSkip())
                    EndDo
                EndIf 
                oModelZA2:SetLine(1)


                _lPrimZA2 := .T.
                ZA1->(dbSkip()) 
            EndDo

            oModelZA1:SetLine(1)
        EndIf


        oView:Refresh()
    EndIf

Return ( .T. )


//U_LT013X3(_cCampo)
//============================================================================\
/*/{Protheus.doc}LTCAD013
  ==============================================================================
    @description
    Retorna no gatilho do campo ZA1_CARACT a descrição do campo selecionada
    para o campo ZA1_DESCR

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 28/12/2020

/*/
//============================================================================\
User Function LT013X3( _cCampo )
    Local _cDescr := Posicione('ZA3',1,xFilial('ZA3')+FwFldGet("ZA1_CARACT"),'ZA3_DESCR')

Return ( _cDescr )
// FIM da Funcao LTCAD013
//==============================================================================



// verifica se permite editar os campos
User Function LT013EDIT(x,_cCampo,z)
    Local _lRet := .T.
    Local oModel := FWModelActive()
    Local oView  := FwViewActive()
    Local oModelZA1 := oModel:GetModel("ZA1DETAIL")
    Local _cCaract := oModelZA1:GetValue("ZA1_CARACT")
    Local _aOpcoes := {}

    If AllTrim(_cCampo) == 'ZA2_MED'
        _lRet := oModelZA1:GetValue("ZA1_TIPO") == 'T'
        dbSelectArea('ZA4')
        ZA4->(dbSetOrder(1)) 
        ZA4->(dbGoTop())
        If ZA4->(dbSeek(xFilial('ZA4')+_cCaract))
            While ZA4->(!Eof()) .And. ZA4->(ZA4_FILIAL+ZA4_CARACT) == xFilial('ZA4')+_cCaract
                aAdd(_aOpcoes,ZA4->ZA4_COD+'='+ALLTRIM(ZA4->ZA4_DESCR))
                
                ZA4->(DbSkip())
            EndDo
        EndIf

    Else
        _lRet := oModelZA1:GetValue("ZA1_TIPO") == 'N'
    EndIf
Return _lRet

//============================================================================\
/*/{Protheus.doc}LT013GAT
  ==============================================================================
    @description
    Gatilhos

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 04/02/2021

/*/
//============================================================================\
User Function LT013GAT( _cField, _cFieldTo )
    Local oModelZA1 := FWModelActive():GetModel("ZA1DETAIL")
    Local _nLine    := oModelZA1:GetLine()
    Local _cCaract  := oModelZA1:GetValue("ZA1_CARACT",_nLine)
    Local _xRet
    
    If _cField == 'ZA2_MED' .AND. _cFieldTo == 'ZA2_DESMED'
        _xRet := Posicione('ZA4',1,xFilial('ZA4')+_cCaract+M->ZA2_MED,'ZA4_DESCR')
    EndIf

Return ( _xRet )
// FIM da Funcao LT013GAT
//==============================================================================


/// Retorna a característica para filtro no f3 da medição
User Function LT013CAR(  )
    Local oView     := FWViewActive()
    Local oModelZ    
    Local _nLine     
    Local _cCaract  

    If IsInCallStack('U_LTMOV009')
        oModelZ   := oView:oModel:GetModel("ZM5DETAIL")
        _nLine    := oModelZ:GetLine()
        _cCaract  := oModelZ:GetValue("ZM5_CARACT",_nLine)
    Else
        oModelZ   := oView:oModel:GetModel("ZA1DETAIL")
        _nLine    := oModelZ:GetLine()
        _cCaract  := oModelZ:GetValue("ZA1_CARACT",_nLine)
    EndIf

Return ( _cCaract )
