#include "protheus.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "colors.ch"
#include "topconn.ch"

/*{Protheus.doc} ACC00011
Funcao para cadastro de Conexões
@author Fernando Oliveira Feres
@since 20/10/2020
@version 1.0
@return Nil
*/
User Function ACC00011()

Local aArea   := GetArea()
Local oBrowse
Static cTitulo := "Cadastro de Conexões"

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZKX")
    
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
 
    ADD OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.ACC00011"	OPERATION 2 ACCESS 0
    ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.ACC00011"	OPERATION 3 ACCESS 0
    ADD OPTION aRot TITLE "Alterar"    ACTION "VIEWDEF.ACC00011"	OPERATION 4 ACCESS 0
    ADD OPTION aRot TITLE "Excluir"    ACTION "VIEWDEF.ACC00011"	OPERATION 5 ACCESS 0
    ADD OPTION aRot TITLE "Imprimir"   ACTION "VIEWDEF.ACC00011"	OPERATION 8 ACCESS 0
Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Criacao do menu MVC                                          |
  *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    
    Local oModel := Nil
    Local oZKX := FWFormStruct(1, "ZKX")

     //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('GWSASM')
    oModel:AddFields('ZKXMASTER',/*cOwner*/,oZKX)
    oModel:SetPrimaryKey({'ZKX_CODIGO'})

    oModel:SetDescription("Cadastro de Integrações")
    oModel:GetModel('ZKXMASTER'):SetDescription('Cadastro de Integrações')
    
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Criacao da visao MVC                                         |
  *---------------------------------------------------------------------*/

Static Function ViewDef()
  
    Local oModel := FWLoadModel("ACC00011")
    Local oZKX   := FWFormStruct(2, "ZKX")    
    Local oView 
 
    oView := FWFormView():New()
    oView:SetModel(oModel) 

    oView:AddField('VIEW_ZKX',oZKX,'ZKXMASTER')  

    oView:CreateHorizontalBox( 'SUPERIOR', 100 ) 

    oView:SetOwnerView('VIEW_ZKX','SUPERIOR')

    oView:EnableTitleView('VIEW_ZKX','Cadastro de Integrações')
     
    //Forca o fechamento da janela na confirmacao
    oView:SetCloseOnOk({||.T.})

Return oView

/*---------------------------------------------------------------------*
 | Func:  ZKTNUM                                                       |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Rotina para controle de sequencial                           |
  *---------------------------------------------------------------------*/

user function ZKXNUM()

Local cQuery := ""
Local cRet := ""
Local cAlias := GetNextAlias()
Local cDB    := TcGetDB()


If cDB == "ORACLE" .OR. cDB == "POSTGRES"
    cQuery:= "SELECT MAX(ZKX_CODIGO) AS ZKX_CODIGO FROM "+ RetSqlName("ZKX") + " ZKX "
Else
    cQuery:= "SELECT MAX(ZKX_CODIGO) AS ZKX_CODIGO FROM "+ RetSqlName("ZKX") + " ZKX WITH (NOLOCK) "
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T. )

If ! Empty((cAlias)->ZKX_CODIGO)

    cRet:= Soma1((cAlias)->ZKX_CODIGO)

Else
    cRet:= "000001"

Endif 	
return cRet

