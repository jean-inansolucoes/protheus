#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}LTBFAT09
  ==============================================================================
    @description
    Programa respons?vel pelos custo do BI

    @author Alexandre Longhinotti <ti@trelac.com.br>
    @version 1.0
    @since 18/04/2022

/*/
//============================================================================\
User Function LTBFAT09(  )
    Private aRotina := MenuDef()
    Private cCadastro := "Custos BI"
    Private _nRotina   := 0
    oMBrowse := FWMBrowse():New()
    oMBrowse:SetAlias("ZMF")
    oMBrowse:SetDescription(cCadastro)

    oMBrowse:Activate()



Return ( Nil )
// FIM da Funcao LTBFAT09
//==============================================================================


//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Montagem do Menu

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function MenuDef()
	Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.LTBFAT09' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.LTBFAT09' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.LTBFAT09" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.LTBFAT09' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar" 	  ACTION "VIEWDEF.LTBFAT09" OPERATION 9 ACCESS 0    

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini??o do modelo de Dados

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	 //Na montagem da estrutura do Modelo de dados, o cabe?alho filtrar? e exibir? somente 3 campos, j? a grid ir? carregar a estrutura inteira conforme fun??o fModStruct
    Local oModel      := NIL
    Local oStruCab     := FWFormStruct(1, 'ZMF', {|cCampo| AllTRim(cCampo) $ "ZMF_DOC;ZMF_DESCRI;ZMF_DATA;"})
    Local oStruGrid := fModStruct()
     
    //Monta o modelo de dados, e na P?s Valida??o, informa a fun??o fValidGrid
    oModel := MPFormModel():New('mLTBFAT09', /*bPreValidacao*/, /*bPosValidacao*/ /*bPost*/ , /* Grava??o dos dados via bloco customizado */ /*bGrv*/)
    //oModel := MPFormModel():New('LTBFAT09M', /*bPreValidacao*/, {|oModel| fValidGrid(oModel)}, /*bCommit*/, /*bCancel*/ )
    
    oModel:SetDescription("Atualiza??o Custos BI")

    //Agora, define no modelo de dados, que ter? um Cabe?alho e uma Grid apontando para estruturas acima
    oModel:AddFields('MdFieldZMF', NIL, oStruCab)
    oModel:AddGrid('MdGridZMF', 'MdFieldZMF', oStruGrid, , )
 
    //Monta o relacionamento entre Grid e Cabe?alho, as express?es da Esquerda representam o campo da Grid e da direita do Cabe?alho
    oModel:SetRelation('MdGridZMF', {;
            {'ZMF_FILIAL', 'xFilial("ZMF")'},;
            {"ZMF_DOC",  "ZMF_DOC"},;
            {"ZMF_DESCRI", "ZMF_DESCRI"},;
            {"ZMF_DATA",  "ZMF_DATA"};
        }, ZMF->(IndexKey(1)))
     
    //Definindo outras informa??es do Modelo e da Grid
    oModel:GetModel("MdGridZMF"):SetMaxLine(9999)
    
    oModel:SetPrimaryKey({"ZMF_FILIAL", "ZMF_DOC"})                                              
       
    oStruGrid:SetProperty('ZMF_DESCRI',MODEL_FIELD_OBRIGAT,.F.)

Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini??o do interface

@author admin

@since 23/12/2020
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	//Na montagem da estrutura da visualiza??o de dados, vamos chamar o modelo criado anteriormente, no cabe?alho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a fun??o fViewStruct
    Local oView        := NIL
    Local oModel    := FWLoadModel('LTBFAT09')
    Local oStruCab  := FWFormStruct(2, "ZMF", {|cCampo| AllTRim(cCampo) $ "ZMF_DOC;ZMF_DESCRI;ZMF_DATA;"})
    Local oStruGRID := fViewStruct()
 
    //Define que no cabe?alho n?o ter? separa??o de abas (SXA)
    oStruCab:SetNoFolder()
 
    //Cria o View
    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    //Cria uma ?rea de Field vinculando a estrutura do cabe?alho com MDFieldZMF, e uma Grid vinculando com MdGridZMF
    oView:AddField('VIEW_ZMF', oStruCab, 'MdFieldZMF')
    oView:AddGrid ('GRID_ZMF', oStruGRID, 'MdGridZMF' )
 
    //O cabe?alho (MAIN) ter? 25% de tamanho, e o restante de 75% ir? para a GRID
    oView:CreateHorizontalBox("MAIN", 10)
    oView:CreateHorizontalBox("GRID", 90)
 
    //Vincula o MAIN com a VIEW_ZMF e a GRID com a GRID_ZMF
    oView:SetOwnerView('VIEW_ZMF', 'MAIN')
    oView:SetOwnerView('GRID_ZMF', 'GRID')
    oView:EnableControlBar(.T.)
 
    //Define o campo incremental da grid como o ZMF_ITEM
    oView:AddIncrementField('GRID_ZMF', 'ZMF_SEQUEN')

    // Criar novo botao na barra de botoes
    //oView:AddUserButton( "Reajuste Auto", ""          , {|oView| U_LT012PES() } )   
Return oView
 
//Fun??o chamada para montar o modelo de dados da Grid
Static Function fModStruct()
    Local oStruct
    oStruct := FWFormStruct(1, 'ZMF')
Return oStruct


//Fun??o chamada para montar a visualiza??o de dados da Grid
Static Function fViewStruct()
    Local cCampoCom := "ZMF_DOC;ZMF_DESCRI;ZMF_DATA;"
    Local oStruct
 
    //Ir? filtrar, e trazer todos os campos, menos os que tiverem na vari?vel cCampoCom
    oStruct := FWFormStruct(2, "ZMF", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct
 
//Fun??o que faz a valida??o da grid
Static Function fValidGrid(oModel)
    Local lRet     := .T.
    Local nDeletados := 0
    Local nLinAtual :=0
    Local oModelGRID := oModel:GetModel('MdGridZMF')
    Local oModelMain := oModel:GetModel('MdFieldZMF')
    Local nValorMain := oModelMain:GetValue("ZMF_VALOR")
    Local nValorGrid := 0
    Local cPictVlr   := PesqPict('ZMF', 'ZMF_VALOR')
 
    //Percorrendo todos os itens da grid
    For nLinAtual := 1 To oModelGRID:Length() 
        //Posiciona na linha
        oModelGRID:GoLine(nLinAtual) 
       
    Next nLinAtual
 
    //Se o tamanho da Grid for igual ao n?mero de itens deletados, acusa uma falha
    If oModelGRID:Length()==nDeletados
        lRet :=.F.
        Help( , , 'Dados Inv?lidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha v?lida!"})
    EndIf
 
    If lRet
        //Se o valor digitado no cabe?alho (valor da NF), n?o bater com o valor de todos os abastecimentos digitados (valor dos itens da Grid), ir? mostrar uma mensagem alertando, por?m ir? permitir salvar (do contr?rio, seria necess?rio alterar lRet para falso)
        If nValorMain != nValorGrid
            //lRet := .F.
            MsgAlert("O valor do cabe?alho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "Aten??o")
        EndIf
    EndIf
 
Return lRet





