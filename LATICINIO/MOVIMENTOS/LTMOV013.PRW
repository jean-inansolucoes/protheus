#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTMOV013
	==============================================================================
	@description
	Preenchimento da Descrição Problema para abertura do protocolo,
    chamada na rotina LTEVE001

	@author Djonata Guizzo <djonata.guizzo@totvs.com.br>
	@version 1.0
	@since 19/04/2021

/*/
//============================================================================\
User Function LTMOV013(  )
   
    //FWExecView('Registro de Ocorrências','LTMOV013', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
   
	
Return ( Nil )
// FIM da Funcao LTMOV013
//==============================================================================



//============================================================================\
/*/{Protheus.doc}ModelDef
	==============================================================================
	@description
	Definição do modelo para MVC

	@author Djonata Guizzo <djonata.guizzo@totvs.com.br>
	@version 1.0
	@since 03/06/2020

/*/
//============================================================================\
Static Function ModelDef(  )

	Local oModel
	Local oStr4     := StructMod(1)
    Local bGrv      := {|oModel| LT013GRV(oModel) }
    Local bLoadMod  := {|oModel| LoadModel(oModel)}
    
    //oStr1 := StructAF8(oStr1,1)

	// Criação do modelo e submodelos de dados
	oModel := MPFormModel():New('mLTMOV013', , , bGrv , /*bCancel*/)
	oModel:AddFields('MASTER',,oStr4,,,bLoadMod)
    
	// Liga o controle de nao repeticao de linha
	oModel:SetPrimaryKey({"ZM8_DESCR"})

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:SetDescription('Registro de Ocorrências')
	oModel:GetModel('MASTER'   ):SetDescription('Descrição do Problema')

Return ( oModel )
// FIM da Funcao ModelDef
//==============================================================================




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ViewDef   ºAutor  ³FSW TOTVS CASCAVEL   º Data ³ 26/10/2017 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³Definição da View p/ MVC                                    º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ViewDef()

    Local oView
    Local oModel    := ModelDef()
    Local oStr4     := StructMod(2)
    
    // Ligação dos modelos na View
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField('VIEW_MOD', oStr4, 'MASTER')

    // Elementos visuais
    oView:CreateVerticalBox ( 'TELA'    , 100,        )
    oView:CreateHorizontalBox( 'SUPERIOR',  100, 'TELA' )
    
    oView:SetOwnerView( 'VIEW_MOD', 'SUPERIOR' )
   
Return oView


Static Function StructMod(nOpc )
    Local oStruct
	If nOpc == 1
        oStruct:= FWFormModelStruct():New()
		
		oStruct:AddField('Descr.Problema', 'Descrição do Problema', 'ZM8_DESCR', 'M', TamSx3('ZM8_DESCR')[1], 0,,,{}, .F., , .F., .F., .F., , )
		
	ElseIf nOpc == 2
        oStruct:= FWFormViewStruct():New()
		oStruct:AddField( 'ZM8_DESCR','01','Descr.Problema','Descrição do Problema',, 'Get',,,,.T.,,,,,,,, )
        
	EndIf

Return ( oStruct )


//============================================================================\
/*/{Protheus.doc}LT013GRV
  ==============================================================================
    @description
    Grava os dados

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 19/04/2021

/*/
//============================================================================\
Static Function LT013GRV( oModel )
    Local _lRet  	    := .T.
	Local oModelMOD		:= oModel:GetModel("MASTER")
    Local _cDescProb    := oModelMod:GetValue("ZM8_DESCR")
    

    // Variável _aCabec definida como private no fonte LTEVE001
    _aCabec[5,2] := _cDescProb
    
    //LT013WF()

Return ( _lRet )
// FIM da Funcao LT013GRV
//==============================================================================


//============================================================================\
/*/{Protheus.doc}LoadModel
  ==============================================================================
    @description
    Carregamento inicial dos dados

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 04/06/2020

/*/
//============================================================================\
Static Function LoadModel( oModel )
    Local _aRet := {}

    aAdd(_aRet, {""}) //dados
   aAdd(_aRet, 0) //recno
 

Return ( _aRet )
// FIM da Funcao LoadModel
//==============================================================================



Static Function LT013WF()
    Local cWfDir		:= SuperGetMv('MV_WFDIR', .F., '\workflow')
	Local oProcOS
	Local oHTMLOS
    Local _cMailCoor := U_TPOS(ZR1->ZR1_COORD, 'AE8_EMAIL')
    //Local _cContrato:= U_TPOS(_cProj, 'AF8_X_CONT')
    //Local _lContFec := U_RESXPMS1('CONTRATO_FECHADO',_cContrato)
    Local _cSubj	:= "WF - OCORRENCIA EM ATENDIMENTO"
    Local _cObs		:= "<b>Atenção! Foi registrado uma ocorrência no atendimento da OS referenciada acima, conforme observações abaixo:</b>"
    
    _cObs += "<br><br><b> Resumo: </b><br>" + ZRO->ZRO_MOTIVO
	_cObs += "<br><br><b> Descrição: </b><br>" + ZRO->ZRO_OBS
	
    
	oProcOS	:= WFProcess( '1001', cWfDir+'\wf_os_exc.html', 'TOTVS Cascavel - Registro de Ocorrência' )
    oHTMLOS	:= oProcOS:oHTML

    oProcOS:cSubject:= _cSubj + ' - ' +  AllTrim(ZR1->ZR1_NOMTEC)
    
    oProcOS:cTo:= AllTrim(_cMailCoor)
    
	// Dados do Cliente (ZR5)
	oHTMLOS:ValByName( "TIPO_WORKFLOW", _cSubj )
	oHTMLOS:ValByName( "OS_CONSULTOR", ZR1->ZR1_NOMTEC )
	oHTMLOS:ValByName( "OS_COORDENADOR", U_TPOS(ZR1->ZR1_COORD, 'AE8_DESCRI') )
	oHTMLOS:ValByName( "CLIENTE_RAZAO_SOCIAL", ZR1->ZR1_NOME )
	oHTMLOS:ValByName( "OS_RESPONSAVEL", ZR1->ZR1_RESP )
	oHTMLOS:ValByName( "PROJETO", AllTrim(ZR1->ZR1_PROJET) + ' - ' + AllTrim(U_TPOS(ZR1->ZR1_PROJET, 'AF8_DESCRI')))
	oHTMLOS:ValByName( "OS_OBSERVACAO", _cObs )
	oHTMLOS:ValByName( "OS_DOC", ZR1->ZR1_DOC )
	oHTMLOS:ValByName( "OS_DATA", dToC(ZR1->ZR1_DATA) )
	oHTMLOS:ValByName( "OS_TIPO", IIF(ZR1->ZR1_TIPO=='EXC','Extra Cronograma', 'Normal' ))
	oHTMLOS:ValByName( "OS_TEMPO", ZR1->ZR1_HRTOT )
    oProcOS:Start()

Return

//====================================================================================================================\
/*/{Protheus.doc}WFProcess
  ====================================================================================================================
    @description
    Instancia a classe de WF

    @author TSC681 Thiago Mota
    @version 1.0
    @since 04/07/2019

/*/
//===================================================================================================================\
Static Function WFProcess( cCodTask, cFileModel, cTitle )
	oProcess := TWFProcess():New(cCodTask,cTitle)
	oProcess:NewTask(cCodTask,cFileModel)

Return ( oProcess )
// FIM da Funcao WFProcess
//======================================================================================================================
