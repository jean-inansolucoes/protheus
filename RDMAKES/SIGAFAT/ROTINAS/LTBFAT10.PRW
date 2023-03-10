#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTBFAT10
  ==============================================================================
    @description
    Programa respons?vel pelo cadastro de comiss?es x vendedor x grupo

    @author Alexandre Longhinotti <ti@trelac.com.br>
    @version 1.0
    @since 10/05/2022

/*/
//============================================================================\
User Function LTBFAT10(  )
    Private aRotina := MenuDef()
    Private cCadastro := "Comiss?es por Vendedeor x Grupo"
    Private _nRotina   := 0
    oMBrowse := FWMBrowse():New()
    oMBrowse:SetAlias("Z07")
    oMBrowse:SetDescription(cCadastro)

    oMBrowse:Activate()



Return ( Nil )
// FIM da Funcao LTBFAT10
//==============================================================================


//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Montagem do Menu
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function MenuDef()
	Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.LTBFAT10' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.LTBFAT10' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.LTBFAT10" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.LTBFAT10' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar" 	  ACTION "VIEWDEF.LTBFAT10" OPERATION 9 ACCESS 0    

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini??o do modelo de Dados
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	 //Na montagem da estrutura do Modelo de dados, o cabe?alho filtrar? e exibir? somente 2 campos, j? a grid ir? carregar a estrutura inteira conforme fun??o fModStruct
    Local oModel      := NIL
    Local oStruCab     := FWFormStruct(1, 'Z07', {|cCampo| AllTRim(cCampo) $ "Z07_CODVEN;Z07_NOME;"})
    Local oStruGrid := fModStruct()
     
    //Monta o modelo de dados, e na P?s Valida??o, informa a fun??o fValidGrid
    oModel := MPFormModel():New('mLTBFAT10', /*bPreValidacao*/, /*bPosValidacao*/ /*bPost*/ , /* Grava??o dos dados via bloco customizado */ /*bGrv*/)
    
    oModel:SetDescription("Comiss?es por Vendedeor x Grupo")

    //Agora, define no modelo de dados, que ter? um Cabe?alho e uma Grid apontando para estruturas acima
    oModel:AddFields('MdField', NIL, oStruCab)
    oModel:AddGrid('MdGrid', 'MdField', oStruGrid, , )
 
    //Monta o relacionamento entre Grid e Cabe?alho, as express?es da Esquerda representam o campo da Grid e da direita do Cabe?alho
    oModel:SetRelation('MdGrid', {;
            {'Z07_FILIAL', 'xFilial("Z07")'},;
            {"Z07_CODVEN",  "Z07_CODVEN"},;
            {"Z07_NOME",  "Z07_NOME"};
        }, Z07->(IndexKey(1)))
     
    //Definindo outras informa??es do Modelo e da Grid
    oModel:GetModel("MdGrid"):SetMaxLine(9999)
    
    oModel:SetPrimaryKey({"Z07_FILIAL", "Z07_CODVEN"})                                              
       
    oStruGrid:SetProperty('Z07_NOME',MODEL_FIELD_OBRIGAT,.F.)

Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini??o do interface
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	//Na montagem da estrutura da visualiza??o de dados, vamos chamar o modelo criado anteriormente, no cabe?alho vamos mostrar somente 2 campos, e na grid vamos carregar conforme a fun??o fViewStruct
    Local oView        := NIL
    Local oModel    := FWLoadModel('LTBFAT10')
    Local oStruCab  := FWFormStruct(2, "Z07", {|cCampo| AllTRim(cCampo) $ "Z07_CODVEN;Z07_NOME;"})
    Local oStruGRID := fViewStruct()
 
    //Define que no cabe?alho n?o ter? separa??o de abas (SXA)
    oStruCab:SetNoFolder()
 
    //Cria o View
    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    //Cria uma ?rea de Field vinculando a estrutura do cabe?alho com MDField, e uma Grid vinculando com MdGrid
    oView:AddField('VIEW_MVC', oStruCab, 'MdField')
    oView:AddGrid ('GRID_MVC', oStruGRID, 'MdGrid' )
 
    //O cabe?alho (MAIN) ter? 25% de tamanho, e o restante de 75% ir? para a GRID
    oView:CreateHorizontalBox("MAIN", 12)
    oView:CreateHorizontalBox("GRID", 88)
 
    //Vincula o MAIN com a VIEW_MVC e a GRID com a GRID_MVC
    oView:SetOwnerView('VIEW_MVC', 'MAIN')
    oView:SetOwnerView('GRID_MVC', 'GRID')
    oView:EnableControlBar(.T.)
 
    //Define o campo incremental da grid como o ZMF_ITEM
    oView:AddIncrementField('GRID_MVC', 'Z07_SEQUEN')

    // Criar novo botao na barra de botoes
    //oView:AddUserButton( "Reajuste Auto", ""          , {|oView| U_LT012PES() } )   
Return oView
 
//Fun??o chamada para montar o modelo de dados da Grid
Static Function fModStruct()
    Local oStruct
    oStruct := FWFormStruct(1, 'Z07')
Return oStruct


//Fun??o chamada para montar a visualiza??o de dados da Grid
Static Function fViewStruct()
    Local cCampoCom := "Z07_CODVEN;Z07_NOME;"
    Local oStruct
 
    //Ir? filtrar, e trazer todos os campos, menos os que tiverem na vari?vel cCampoCom
    oStruct := FWFormStruct(2, "Z07", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct
 
 