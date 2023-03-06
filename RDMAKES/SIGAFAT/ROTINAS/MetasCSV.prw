#include 'topconn.ch'
#include 'totvs.ch'
#include 'fileio.ch'

#define PATH_CONFIG '/metascsv/'
#define FILE_NAME   'layout.cfg'

/*/{Protheus.doc} MetasCSV
Função para importação de metas em excel (.csv)
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
/*/
user function MetasCSV()

    local aArea   := getArea()
    local aConfig := {} as array
    local cFileImp := "" as character
    local cFileCSV := "" as character
    local oDlgImp  as object
    local lConfirm := .F. as logical
    local bValid   := {|| !lConfirm .or. file( cFileImp ) }
    local bOk      := {|| cFileImp := cFileCSV, lConfirm := .T., oDlgImp:End() }
    local bCancel  := {|| oDlgImp:End() }
    local aBottons := { {"BMPINCLUIR",{|| dialogConf( PATH_CONFIG + FILE_NAME, getConf( PATH_CONFIG + FILE_NAME ), cFileCSV ) },"Editar Layout"} }
    local bInit    := {|| EnchoiceBar( oDlgImp, bOk, bCancel, .F. /* lMensApag */, aBottons ) }
    local oFileCSV as object
    local cLabel   := "" as character
    local oSearch  as object
    local cMascara := "Arquivos de metas (*.csv)"
    local cTitulo  := "Selecione o arquivo de metas"
    local cDirIni  := ""
    local lSalvar  := .F.
    local aFileCab := {} as array
    local aFileIte := {} as array
    local aFile    := {} as array
    
    // Monta a caixa de diálogo de seleção do arquivo de metas
    oDlgImp  := TDialog():New(0,0,150,700,'Importação de Metas de Venda',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
    cLabel   := "Informe o arquivo .CSV que deseja utilizar como base para importação das metas de venda"
    oFileCSV := TGet():New( 40, 15, {|u| if( PCount() > 0, cFileCSV := u, cFileCSV ) }, oDlgImp, 300, 11, "@x", {|| Empty( cFileCSV ) .or. File( cFileCSV ) },;
                ,,,,,.T./* lPixel */,,,{|| .T. /* bWhen */},,,{|| Nil /* bChange */ }, .T. /* lReadOnly */, .F. /* lPassword */,,'cFileCSV',,,,.T.,.F.,,cLabel,1 )
    
    oSearch :=  TButton():New( 47, 317, "...", oDlgImp, {|| cFileCSV := pathFile( AllTrim( TFileDialog( cMascara, cTitulo,, cDirIni, lSalvar ) ) ) }, 12, 12,,,,.T. )  
    
    oDlgImp:Activate(,,,.T. /* lCentered */, bValid,,bInit )

    // Verifica se o usuário confirmou a tela e se o arquivo informado realmente existe
    if lConfirm .and. file( cFileImp )
        
        // Carrega as informações de configuração do layout de importação do arquivo ou
        // caso não exista configuração, permite ao usuário definí-las
        aConfig := loadConf( PATH_CONFIG, FILE_NAME, cFileImp )
        if len( aConfig ) == 0
            hlp( 'Ausência de Configurações','O layout para importação das metas via arquivo não foi detinido!','Ao acessar a rotina, configure o layout de acordo com o modelo de planilha utilizada!' )
            return Nil
        endif

        Processa( {|| aFile := impFile( cFileImp, aConfig ) }, 'Aguarde 1/2!','Lendo os dados de '+ cFileImp +'...' )
        if len( aFile ) == 2
            aFileCab := aClone( aFile[1] )
            aFileIte := aClone( aFile[2] )
            Processa( {|| importData( aFileCab, aFileIte ) }, 'Aguarde 2/2', 'Importando os dados...' )
        else
            hlp( 'Falha de leitura', 'Falha durante a leitura do arquivo '+ cFileImp, 'Ocorreu alguma falha durante o processo de leitura do arquivo '+;
            'que ocasionou falha na leitura dos dados. Verifique se a estrutura do arquivo está no formato correto e tente novamente.' )
        endif

    endif

    restArea( aArea )
return Nil

/*/{Protheus.doc} pathFile
Processa o nome do arquivo obtido para ajustar o patch de modo que o smartclient consiga processá-lo 
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/11/2022
@param cFile, character, path completo do arquivo
@return character, cNewFile
/*/
static function pathFile( cFile )

    local cNewFile := "" as character

    default cFile := ""

    if !Empty( cFile )
        // Se a execução estiver sendo feita no MacOS, utiliza o cGetFile
        if 'mac' $ Lower( GetRmtInfo()[2] )
            cNewFile := 'l:' + SubStr( cFile, 02 )
        else
            cNewFile := cFile
        endif
    endif
return cNewFile

/*/{Protheus.doc} importData
Função para executar a gravação dos dados no Protheus por meio de execauto
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/10/2022
@param aFileCab, array, vetor com os dados do cabeçalho do documento
@param aFileIte, array, vetor com os dados dos itens do documento 
/*/
static function importData( aCab, aIte )
    
    local nX      := 0   as numeric
    local nY      := 0   as numeric
    local cSequen := Replicate( "0", TAMSX3("CT_SEQUEN")[1] )
    local oModel         as object
    local oModelCab      as object
    local lAllOk  := .T. as logical
    local aErro   := {} as array

    default aCab := {}
    default aIte := {}

    if len( aCab ) == 0 .or. len( aIte ) == 0
        hlp( 'Dados com falha!','Pelo menos um dos vetores - documento ou itens do documento - está vazio!',;
        'Documento: '+ cValToChar( len( aCab ) ) + chr(13) + chr(10) +;
        'Itens do Documento: '+ cValToChar( len( aIte ) ) + chr(13) + chr(10) )
        return Nil
    else    
        // Ativa o modelo da rotina de Metas de Venda
        oModel := FWLoadModel( "FATA050" )
        oModel:SetOperation( 3 )        // Inclusão
        oModel:Activate()
        oModelCab := oModel:GetModel( "SCTCAB" )
        //aEval( aCab, {|x| oModelCab:SetValue( x[3], x[1] ) } )
        for nX := 1 to len( aCab )
            oModelCab:SetValue( aCab[nX][3], aCab[nX][1] )
        next nX

        oModelIte := oModel:GetModel( "SCTGRID" )
        for nX := 1 to len( aIte )
            oModelIte:AddLine()
            cSequen := Soma1( cSequen )
            oModelIte:SetValue( "CT_SEQUEN", cSequen )
            for nY := 1 to len( aIte[nX] )
                oModelIte:SetValue( aIte[nX][nY][3], aIte[nX][nY][1] )
            next nY
        next nX

        // Verifica se valida corretamente todos os dados do formulário
        if oModel:VldData()

            // Verifica se conseguiu efetivar o commit dos dados
            if oModel:CommitData()
                // Antes de exibir mensagem com o código do documento, verifica se ele está presente no vetor
                if aScan( aCab, {|x| AllTrim( x[3] ) == 'CT_DOC' } ) > 0
                    MsgInfo( "Documento "+ aCab[ aScan( aCab, {|x| AllTrim( x[3] ) == 'CT_DOC' } ) ][01] +" incluido com sucesso!","S U C E S S O !" )
                else
                    MsgInfo( "Metas importadas com sucesso!", "S U C E S S O !" )
                endif
            else
                lAllOk := .F.
            endif
        else
            lAllOk := .F.
        endif

        if ! lAllOk
            
            // Captura as falhas do modelo
            aErro := oModel:GetErrorMessage()
            
            //Monta o Texto que será mostrado na tela
            AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
            AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
            AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
            AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
            AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
            AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
            AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
            AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
            AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')

            MostraErro()

        endif

    endif

return Nil

/*/{Protheus.doc} impFile
Função responsável por executar o processamento do arquivo de metas no Protheus
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
@param cFileImp, character, path completo do arquivo a ser importado
@param aConfig, array, vetor de configurações para importação
@return array, aFileRead
/*/
static function impFile( cFileImp, aConfig )
    
    local oFile   as object
    local cLine   := "" as character
    local nLine   := 0 as numeric
    local aTmpCab := {} as array
    local aTmpIte := {} as array
    local nX      := 0 as numeric
    local nY      := 0 as numeric
    local aLine   := {} as array
    local aCab    := {} as array
    local aIte    := {} as array
    local aPosCab := {} as array
    local aPosIte := {} as array
    local nPos    := 0 as numeric
    local cFldArq := "" as character
    local nPosArq := 0 as numeric

    oFile := FWFileReader():New( cFileImp )
    if oFile:Open()
        while oFile:hasLine()
            nLine++
            cLine := AllTrim( oFile:GetLine() )
            if !Empty( cLine )
                if nLine == 1           // Linha dos campos do cabeçalho do arquivo
                    aLine := StrTokArr2( DecodeUTF8( cLine ), ';', .T. )
                    if len( aLine ) > 0
                        for nX := 1 to len( aLine )
                            // Verifica se encontrou referência para o campo lido no arquivo com um campo do Protheus
                            nPos := aScan( aConfig[1], {|x| AllTrim( x[1] ) == AllTrim( aLine[nX] ) } )
                            if nPos > 0 .and. !Empty( aConfig[1][nPos][2] )
                                aAdd( aPosCab, { nX, AllTrim( aLine[nX] ), aConfig[1][nPos][2] } )
                            endif
                        next nX
                    endif
                elseif nLine == 2       
                    aTmpCab := StrTokArr2( DecodeUTF8( cLine ), ';', .T. )
                elseif nLine == 3
                    aLine := StrTokArr2( DecodeUTF8( cLine ), ';', .T. )
                    if len( aLine ) > 0
                        for nX := 1 to len( aLine )
                            nPos := aScan( aConfig[2], {|x| AllTrim( x[1] ) == AllTrim( aLine[nX] ) } )
                            if nPos > 0 .and. !Empty( aConfig[2][nPos][2] )
                                aAdd( aPosIte, { nX, AllTrim( aLine[nX] ), aConfig[2][nPos][2] } )
                            endif
                        next nX
                    endif
                elseif nLine >= 4 
                    aAdd( aTmpIte, StrTokArr2( DecodeUTF8( cLine ), ';', .T. ) )
                endif
            endif
        end
        oFile:Close()

        if len( aTmpCab ) > 0
            aCab := {}
            for nX := 1 to len( aTmpCab )
                // Preenche o vetor apenas dos campos que tem relação com o Protheus
                nPos := aScan( aPosCab, {|x| x[1] == nX } )
                if nPos > 0 .and. !Empty( aConfig[1][nPos][2] )
                    cFldArq := aConfig[1][nPos][1]
                    nPosArq := aPosCab[ aScan( aPosCab, {|x| AllTrim(x[2]) == AllTrim( cFldArq ) } ) ][1]
                    aAdd( aCab, { convInfo( aTmpCab[nPosArq], aConfig[1][nPos][2] ) /* cConteud */, aConfig[1][nPos][1] /* cFieldFile */, aConfig[1][nPos][2] /* cFieldProtheus */ } )
                endif
            next nX
        endif
        if len( aTmpIte ) > 0
            aIte := {}
            for nX := 1 to len( aTmpIte )
                aLine := {}
                if len( aTmpIte[nX] ) > 0
                    for nY := 1 to len( aTmpIte[nX] )
                        // Atribui ao vetor apenas os campos que tem relação com o Protheus
                        nPos := aScan( aPosIte, {|x| x[1] == nY } )
                        if nPos > 0 .and. !Empty( aConfig[2][nPos][2] )
                            cFldArq := aConfig[2][nPos][1]
                            nPosArq := aPosIte[ aScan( aPosIte, {|x| AllTrim( x[2] ) == AllTrim( cFldArq ) } ) ][1]
                            aAdd( aLine, { convInfo( aTmpIte[nX][nPosArq], aConfig[2][nPos][2] ) /* cConteud */,;
                                            aConfig[2][nPos][1] /* cFieldFile */,;
                                            aConfig[2][nPos][2] /* cFieldProtheus */ } )
                        endif
                    next nY
                    if len( aLine ) > 0
                        aAdd( aIte, aClone( aLine ) )
                        aLine := {}
                    endif
                endif
            next nX
        endif
    endif

return { aCab, aIte }

/*/{Protheus.doc} convInfo
Função responsável pela conversão da string lida no arquivo .csv para a tipagem correta conforme definido para o campo do Protheus
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/12/2022
@return variadic, xConv
/*/
static function convInfo( cInfo, cCampo )
    
    local xConv := Nil
    local cType := GetSX3Cache( cCampo, 'X3_TIPO' )

    if cType == "N"     // Numérico
        if ',' $ cInfo
            xConv := Val( StrTran( StrTran( AllTrim( cInfo ), '.', '' ), ',', '.' ) )
        else
            xConv := Val( AllTrim( cInfo ) )
        endif
    elseif cType == "D" // Data
        xConv := CtoD( cInfo )
    elseif cType == "L" // Lógico
        xConv := Upper( AllTrim( cInfo ) ) $ "T/TRUE/.T."
    else
        xConv := cInfo
    endif

return xConv

/*/{Protheus.doc} loadConf
Função para manutenção e leitura do layout de configuração de importação dos dados
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
@param cPath, character, path do arquivo de configuração
@param cFile, character, nome do arquivo de configuração
@param cFileImp, character, path completo do arquivo que vai ser importado
@return array, aLayoutConfig
/*/
static function loadConf( cPath, cFile, cFileImp )
    
    local aConfig  := {} as array

    // Verifica se o ExistDir
    if ! ExistDir( cPath )
        MakeDir( cPath )
    endif

    // Valida existência do arquivo de configuraç˜ões
    if file( cPath + cFile )
        aConfig := getConf( cPath + cFile )
    else
        if dialogConf( cPath + cFile, aConfig, cFileImp )
            aConfig := getConf( cPath + cFile )
        endif
    endif

return aConfig

/*/{Protheus.doc} dialogConf
Função responsável pela exibição da tela e manutenção do arquivo de configurações armazenado internamente
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
@param cFileConfig, character, path completo do arquivo de configurações (obrigatório)
@param aConfig, array, vetor com as configurações já existentes (optional)
@param cFileImp, character, path completo do arquivo .csv que está sendo importado (obrigatório)
@return logical, lConfirm (indica se o usuário confirmou a operação)
/*/
static function dialogConf( cFileConfig, aConfig, cFileImp )

    local lConfirm := .T. as logical
    local bValid   := {|| .T. }
    local bOk      := {|| lConfirm := confirm( cFileConfig ) }
    local bCancel  := {|| oDlgConf:End() }
    local bInit    := {|| EnchoiceBar( oDlgConf, bOk, bCancel, .F. /* lMensApag */, {} /* aBottons */ ) }
    local oLayer   as object
    local oWinCab  as object
    local oWinIte  as object
    local aColCab := {} as array
    
    private oGrdCab  as object
    private oGrdIte  as object
    private aGrdCab  := {} as array
    private aGrdIte  := {} as array
    private oDlgConf as object

    default aConfig := {}

    // Valida se o arquivo selecionado é válido antes de prosseguir
    if ! File( cFileImp )
        hlp( 'Arquivo de importação','Primeiramente, selecione um arquivo '+ iif( !Empty( cFileImp ), 'válido','' ) +' para importar, depois clique na edição de layout!',;
        'É necessário selecionar um arquivo de importação '+ iif( !Empty( cFileImp ), 'válido','' ) +' para que o sistema previamente identifique as colunas existentes no arquivo para '+;
        "facilitar o desenvolvimento do layout" )
        return nil
    endif

    // Se as configurações já vierem preenchidas, atribui às variáveis do grid
    aGrdCab := fieldToGrid( aConfig, fileFields( .T. /* lCab */, cFileImp ), "C" )
    aGrdIte := fieldToGrid( aConfig, fileFields( .F. /* lCab */, cFileImp ), "G" )

    // Colunas do grid dos campos do cabeçalho
    aColCab := {}
    aAdd( aColCab, { 'Campo Arq.',{|| aGrdCab[oGrdCab:At()][1] }, 'C', '@x', 1, 30, 0, .F. /* lCanEdit */, {|| .T. /* bValid */}, .F., Nil, 'aGrdCab[oGrdCab:At()][1]' } )
    aAdd( aColCab, { 'Campo Protheus',{|| aGrdCab[oGrdCab:At()][2] }, 'C', '@x', 1, 10, 0, .T. /* lCanEdit */, {|| .T. /* bValid */}, .F., Nil, 'aGrdCab[oGrdCab:At()][2]', {|| Nil }, .F., .T., getOptions( 'SCT' ) } )

    // Colunas do grid de campos dos itens
    aColIte := {}
    aAdd( aColIte, { 'Campo Arq.',{|| aGrdIte[oGrdIte:At()][1] }, 'C', '@x', 1, 30, 0, .F. /* lCanEdit */, {|| .T. /* bValid */}, .F., Nil, 'aGrdIte[oGrdIte:At()][1]' } )
    aAdd( aColIte, { 'Campo Protheus',{|| aGrdIte[oGrdIte:At()][2] }, 'C', '@x', 1, 10, 0, .T. /* lCanEdit */, {|| .T. /* bValid */}, .F., Nil, 'aGrdIte[oGrdIte:At()][2]', {|| Nil }, .F., .T., getOptions( 'SCT' ) } )

    // Caixa de diálogo que permitirá ao usuário definir as configurações para importação do arquivo
    oDlgConf := TDialog():New( 0, 0, 600,900,'Defina o layout do arquivo',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
    oLayer := FWLayer():New()
    oLayer:Init( oDlgConf )
    oLayer:AddColumn( 'Col01', 100, .T. )
    oLayer:AddWindow( 'Col01', "WinCab", 'Cabeçalho', 30, .F., .T., {|| },,)
    oLayer:AddWindow( 'Col01', "WinIte", 'Itens', 60, .F., .T., {|| },,)
    oWinCab := oLayer:GetWinPanel( 'Col01', 'WinCab' )
    oWinIte := oLayer:GetWinPanel( 'Col01', 'WinIte' )

    // Monta o grid com as configurações dos campos do cabeçalho
    oGrdCab := FWBrowse():New( oWinCab )
    oGrdCab:SetDataArray()
    oGrdCab:SetArray( aGrdCab )
    oGrdCab:DisableConfig()
    oGrdCab:DisableFilter()
    oGrdCab:DisableReport()
    oGrdCab:lHeaderClick := .F.     // Desabilita clique no header
    aEval( aColCab, {|x| oGrdCab:AddColumn( aClone( x ) ) } ) 
    oGrdCab:SetEditCell( .T. )
    oGrdCab:Activate()

    // Monta o grid com as configurações dos campos dos itens das metas
    oGrdIte := FWBrowse():New( oWinIte )
    oGrdIte:SetDataArray()
    oGrdIte:SetArray( aGrdIte )
    oGrdIte:DisableConfig()
    oGrdIte:DisableFilter()
    oGrdIte:DisableReport()
    oGrdIte:lHeaderClick := .F.     // Desabilita clique no header
    aEval( aColIte, {|x| oGrdIte:AddColumn( aClone( x ) ) } ) 
    oGrdIte:SetEditCell( .T. )
    oGrdIte:Activate()

    oDlgConf:Activate(,,,.T. /* lCentered */, bValid,,bInit)

return lConfirm

/*/{Protheus.doc} fieldToGrid
Função para interrelacionar os campos do arquivo com os campos já configurados e salvos pelo usuário
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/11/2022
@param aConfig, array, vetor de configurações já salvas
@param aFields, array, vetor de campos encontrados nos cabeçalhos do arquivo
@param cReg, character, indica se está processando campos do cabeçalho ou dos itens do arquivo
@return array, aGrid (conteúdo do grid)
/*/
static function fieldToGrid( aConfig, aFields, cReg )
    
    local aGrid := {} as array
    local nX    := 0 as numeric
    local nPos  := 0 as numeric         // indica o posicionamento do campo do arquivo no vetor de configurações existentes
    local aConf := iif( len( aConfig ) == 2, iif( cReg == "C", aConfig[1], aConfig[2] ), {} )

    if len( aFields ) > 0

        for nX := 1 to len( aFields )
            if len( aConf ) > 0
                nPos := aScan( aConf, {|x| AllTrim( x[1] ) == AllTrim( aFields[nX] ) } )
            endif
            aAdd( aGrid, { AllTrim( aFields[nX] ),;
                            iif( nPos == 0, Space( 10 ), aConf[nPos][2] ) } )
        next nX
    endif

return aGrid

/*/{Protheus.doc} confirm
Função para gravação dos dados de configuração em um arquivo auxiliar
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@return logical, lDone
@since 5/11/2022
/*/
static function confirm( cFileName )

    local lDone := .T. as logical
    local lOk   := .F. as logical
    local nX    := 0 as numeric
    local oFile as object
    local cEOL  := chr(13) + chr(10)

    // Se o arquivo de configurações existe, realiza a exclusão do mesmo e grava um novo arquivo
    if File( cFileName )
        fErase( cFileName )
    endif
    
    // Valida para que, pelo menos um dos campos do cabeçalho e um dos campos do grid tenham sido
    // referenciados com os campos do Protheus
    if len( aGrdCab ) > 0
        
        lOk := .F.
        for nX := 1 to len( aGrdCab )
            if !Empty( aGrdCab[nX][2] )
                lOk := .T.
            endif
            if lOk
                Exit
            endif
        next nX

        if lOk .and. len( aGrdIte ) > 0
            lOk := .F.
            for nX := 1 to len( aGrdIte )
                if !Empty( aGrdIte[ nX ][2] )
                    lOk := .T.
                endif
                if lOk
                    Exit
                endif
            next nX
        else
            lOk := .F.
        endif

        lDone := lOk
    else
        lDone := .F.
    endif
    
    // Grava conteúdo em um arquivo de configurações no diretório raiz do sistema
    if lDone 
        oFile := FWFileWriter():New( cFileName, .F. )
        oFile:Create()
        if oFile:Write( '[cab]' + cEOL )
            for nX := 1 to len( aGrdCab )
                if ! Empty( aGrdCab[nX][1] ) .and. !Empty( aGrdCab[nX][2] ) .and. lOk
                    lOk := oFile:Write( AllTrim( aGrdCab[nX][1] ) +'|'+ AllTrim( aGrdCab[nX][2] ) + cEOL )
                elseif !lOk
                    lDone := .F.
                    Exit
                endif
            next nX
        endif
        if lDone .and. oFile:Write( '[ite]' + cEOL )
            for nX := 1 to len( aGrdIte )
                if !Empty( aGrdIte[nX][1] ) .and. !Empty( aGrdIte[nX][2] ) .and. lOk
                    lOk := oFile:Write( AllTrim( aGrdIte[nX][1] ) +'|'+ AllTrim( aGrdIte[nX][2] ) + cEOL )
                elseif !lOk
                    lDone := .F.
                    Exit
                endif
            next nX
        endif
        oFile:Close()
    endif

    if lDone
        oDlgConf:End()
    endif

return lDone

/*/{Protheus.doc} getOptions
Função para identificar os diferentes campos disponíveis 
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
@param cAlias, character, Alias de onde serão lidos os campos 
@return array, aOptions
/*/
static function getOptions( cAlias )
    local aOptions := {} as array
    local aTemp    := FWSX3Util():GetAllFields( cAlias, .F. /* lVirtual */ )
    local nField   := 0 as numeric
    if len( aTemp ) > 0
        for nField := 1 to len( aTemp )
            aAdd( aOptions, aTemp[nField]+'='+ AllTrim( GetSX3Cache( aTemp[nField], 'X3_TITULO' ) ) )
        next nField
        aAdd( aOptions, " " )
    endif
return aOptions

/*/{Protheus.doc} fileFields
Função responsável por retornar os campos das linhas de cabeçalho do arquivo .csv que vai ser importado
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
@param lCab, logical, .T. = indica se a leitura deve ser do cabeçalho, .F. = leitura dos itens
@param cFileImp, character, path completo do arquivo .csv que vai ser importado
@return array, aFieldsFile
/*/
static function fileFields( lCab, cFileImp )
    
    local aFields := {} as array
    local oFile   as object
    local nLine   := 0 as numeric
    local cLine   := "" as character
    local aLine   := {} as array

    oFile := FWFileReader():new( cFileImp )
    if oFile:Open()
        While oFile:hasLine()
            nLine++
            cLine := ALlTrim( oFile:getLine() )
            // Quando é pra retornar os campos do cabeçalho, executa apenas a primeira linha e sai
            if lCab .and. nLine == 1
                Exit
            endif
            // Quando chegar no cabeçalho dos itens, sai do arquivo
            if !lCab .and. nLine == 3
                Exit
            endif
        end
        oFile:Close()
    endif

    // Forma um vetor com os campos obtidas na última linha lida do arquivo
    if !Empty( cLine )
        aLine := StrTokArr( cLine, ';' )
        aEval( aLine, {|x| aAdd( aFields, AllTrim( DecodeUTF8(x) ) ) } )
    endif

return aFields

/*/{Protheus.doc} getConf
Realiza leitura das configurações gravadas
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
@param cFile, character, path + nome_do_arquivo.extensao
@return array, aConfig
/*/
static function getConf( cFile )
    
    local aConfig := {} as array
    local oFile   as object
    local cLine   := "" as character
    local aCab    := {} as array
    local aItens  := {} as array
    local lCab    := .F. as array

    oFile := FWFileReader():New( cFile )
    if oFile:Open()
        while oFile:hasLine()
            cLine := AllTrim( oFile:GetLine() )
            if cLine == '[cab]'
                lCab := .T.
            elseif cLine == '[ite]'
                lCab := .F.
            else
                aAdd( iif( lCab, aCab, aItens ), StrTokArr( cLine, '|' ) )
            endif
        end
        oFile:Close()
        aAdd( aConfig, aClone( aCab ) )
        aAdd( aConfig, aClone( aItens ) )
    endif

return aConfig

/*/{Protheus.doc} hlp
Função para exibição de modo facilitado do helpDialog
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 5/9/2022
@param cTitulo, character, Título da janela (obrigatório)
@param cErro, character, Falha ocorrida (obrigatório)
@param cHelp, character, Texto de ajuda (opcional)
/*/
static function hlp( cTitulo, cErro, cHelp )
return Help( ,, cTitulo,, cErro, 1, 0, NIL, NIL, NIL, NIL, NIL,{ cHelp } )
