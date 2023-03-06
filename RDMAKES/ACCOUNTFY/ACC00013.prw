#include "protheus.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "colors.ch"
#include "topconn.ch"

/*{Protheus.doc} ACC00002
Funcao para cadastro de depara
@author Fernando Oliveira Feres
@since 20/10/2020
@version 1.0
@return Nil
*/
User Function ACC00013()

Local aArea   := GetArea()
Local oBrowse
Static cTitulo := "Cadastro de Etiquetas"

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZKW")
    
    oBrowse:SetDescription(cTitulo) 
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil



/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Criacao do menu MVC                                          |
  *---------------------------------------------------------------------*/
 
Static Function MenuDef()

Local aRot := {}
 
    ADD OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.ACC00013"	OPERATION 2 ACCESS 0
    ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.ACC00013"	OPERATION 3 ACCESS 0
    ADD OPTION aRot TITLE "Alterar"    ACTION "VIEWDEF.ACC00013"	OPERATION 4 ACCESS 0
    ADD OPTION aRot TITLE "Excluir"    ACTION "VIEWDEF.ACC00013"	OPERATION 5 ACCESS 0
    ADD OPTION aRot TITLE "Imprimir"   ACTION "VIEWDEF.ACC00013"	OPERATION 8 ACCESS 0
Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Criacao do menu MVC                                          |
  *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    
    Local oModel := Nil
    Local oZKW := FWFormStruct(1, "ZKW")
    Local oZKZ := FWFormStruct(1, "ZKZ")

     //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('GWSZSM')
    oModel:AddFields('ZKWMASTER',/*cOwner*/,oZKW)
    oModel:AddGrid('ZKZDETAIL','ZKWMASTER',oZKZ,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner e para quem pertence
     
    oModel:SetRelation( 'ZKZDETAIL', { { 'ZKZ_FILIAL', 'xFilial( "ZKZ" )' }, { 'ZKZ_CODIGO', 'ZKW_CODIGO' } }, ZKZ->( IndexKey( 1 ) ) )  
    oModel:GetModel('ZKZDETAIL'):SetUniqueLine({"ZKZ_CODIGO"})
    oModel:SetPrimaryKey({})

    oModel:SetDescription("Cadastro de Etiquetas")
    oModel:GetModel('ZKWMASTER'):SetDescription('Categorias')
    oModel:GetModel('ZKZDETAIL'):SetDescription('Etiquetas')

Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Criacao da visao MVC                                         |
  *---------------------------------------------------------------------*/

Static Function ViewDef()
  
    Local oModel := FWLoadModel("ACC00013")
    Local oZKW   := FWFormStruct(2, "ZKW")
    Local oZKZ   := FWFormStruct(2, "ZKZ")
    Local oView
 
    oView := FWFormView():New()
    oView:SetModel(oModel) 

    oView:AddField('VIEW_ZKW',oZKW,'ZKWMASTER')
    oView:AddGrid('VIEW_ZKZ',oZKZ,'ZKZDETAIL')   

    oView:CreateHorizontalBox( 'SUPERIOR', 30 ) 
    oView:CreateHorizontalBox( 'INFERIOR', 70 ) 

    oView:SetOwnerView('VIEW_ZKW','SUPERIOR')
    oView:SetOwnerView('VIEW_ZKZ','INFERIOR')

    oView:EnableTitleView('VIEW_ZKW','Cadastro de Etiquetas')
    oView:EnableTitleView('VIEW_ZKZ','Etiquetas')
    oView:AddIncrementField("VIEW_ZKZ","ZKZ_SEQ")
     
    //Forca o fechamento da janela na confirmacao
    oView:SetCloseOnOk({||.T.})

Return oView

/*---------------------------------------------------------------------*
 | Func:  ZKWNUM                                                       |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Rotina para controle de sequencial                           |
  *---------------------------------------------------------------------*/

user function ZKWNUM()

Local cQuery := ""
Local cRet := ""
Local cAlias := GetNextAlias()
Local cDB    := TcGetDB()


If cDB == "ORACLE" .OR. cDB == "POSTGRES"
    cQuery:= "SELECT MAX(ZKW_CODIGO) AS ZKW_CODIGO FROM "+ RetSqlName("ZKW") + " ZKW "
Else
    cQuery:= "SELECT MAX(ZKW_CODIGO) AS ZKW_CODIGO FROM "+ RetSqlName("ZKW") + " ZKW WITH (NOLOCK) "
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T. )

If ! Empty((cAlias)->ZKW_CODIGO)

    cRet:= Soma1((cAlias)->ZKW_CODIGO)

Else
    cRet:= "000001"

Endif 	
return cRet

