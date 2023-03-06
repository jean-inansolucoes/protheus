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
User Function ACC00002()

Local aArea   := GetArea()
Local oBrowse
Static cTitulo := "Cadastro de Depara"

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZKT")
    
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
 
    ADD OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.ACC00002"	OPERATION 2 ACCESS 0
    ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.ACC00002"	OPERATION 3 ACCESS 0
    ADD OPTION aRot TITLE "Alterar"    ACTION "VIEWDEF.ACC00002"	OPERATION 4 ACCESS 0
    ADD OPTION aRot TITLE "Excluir"    ACTION "VIEWDEF.ACC00002"	OPERATION 5 ACCESS 0
    ADD OPTION aRot TITLE "Imprimir"   ACTION "VIEWDEF.ACC00002"	OPERATION 8 ACCESS 0
Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Criacao do menu MVC                                          |
  *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    
    Local oModel := Nil
    Local oZKT := FWFormStruct(1, "ZKT")
    Local oZKU := FWFormStruct(1, "ZKU")

     //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('GWSASM')
    oModel:AddFields('ZKTMASTER',/*cOwner*/,oZKT)
    oModel:AddGrid('ZKUDETAIL','ZKTMASTER',oZKU,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner e para quem pertence
     
    oModel:SetRelation( 'ZKUDETAIL', { { 'ZKU_FILIAL', 'xFilial( "ZKU" )' }, { 'ZKU_CODIGO', 'ZKT_CODIGO' } }, ZKU->( IndexKey( 1 ) ) )  
    oModel:GetModel('ZKUDETAIL'):SetUniqueLine({"ZKU_CPPROT","ZKU_CPINTE"})
    oModel:SetPrimaryKey({})

    oModel:SetDescription("Cadastro Integracao")
    oModel:GetModel('ZKTMASTER'):SetDescription('Integracao')
    oModel:GetModel('ZKUDETAIL'):SetDescription('De/Para')

Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Criacao da visao MVC                                         |
  *---------------------------------------------------------------------*/

Static Function ViewDef()
  
    Local oModel := FWLoadModel("ACC00002")
    Local oZKT   := FWFormStruct(2, "ZKT")
    Local oZKU   := FWFormStruct(2, "ZKU" ,{|cCampo| !AllTrim(cCampo)+"|" $ "ZKU_CODIGO|"})
    Local oView 
    Local aCombo := {"","GET","POST","PUT","DELETE"}
 
    oView := FWFormView():New()
    oView:SetModel(oModel) 

    oView:AddField('VIEW_ZKT',oZKT,'ZKTMASTER')
    oView:AddGrid('VIEW_ZKU',oZKU,'ZKUDETAIL')   

    oView:CreateHorizontalBox( 'SUPERIOR', 30 ) 
    oView:CreateHorizontalBox( 'INFERIOR', 70 ) 

    oView:SetOwnerView('VIEW_ZKT','SUPERIOR')
    oView:SetOwnerView('VIEW_ZKU','INFERIOR')

    oView:EnableTitleView('VIEW_ZKT','Cadastro de Integracao')
    oView:EnableTitleView('VIEW_ZKU','De/Para')
    oView:AddIncrementField("VIEW_ZKU","ZKU_SEQ")

    oZKT:SetProperty("ZKT_METODO" , MVC_VIEW_COMBOBOX, aCombo )
     
    //Forca o fechamento da janela na confirmacao
    oView:SetCloseOnOk({||.T.})

Return oView

/*---------------------------------------------------------------------*
 | Func:  ZKTNUM                                                       |
 | Autor: Fernando Feres                                               |
 | Data:  20/10/2020                                                   |
 | Desc:  Rotina para controle de sequencial                           |
  *---------------------------------------------------------------------*/

user function ZKTNUM()

Local cQuery := ""
Local cRet := ""
Local cAlias := GetNextAlias()
Local cDB    := TcGetDB()


If cDB == "ORACLE" .OR. cDB == "POSTGRES"
    cQuery:= "SELECT MAX(ZKT_CODIGO) AS ZKT_CODIGO FROM "+ RetSqlName("ZKT") + " ZKT "
Else
    cQuery:= "SELECT MAX(ZKT_CODIGO) AS ZKT_CODIGO FROM "+ RetSqlName("ZKT") + " ZKT WITH (NOLOCK) "
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T. )

If ! Empty((cAlias)->ZKT_CODIGO)

    cRet:= Soma1((cAlias)->ZKT_CODIGO)

Else
    cRet:= "000001"

Endif 	
return cRet

