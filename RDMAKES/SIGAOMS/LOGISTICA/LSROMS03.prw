#include 'totvs.ch'
#include 'topconn.ch'

#define PRINTPDF 6      

/*/{Protheus.doc} LSROMS03
Função responsável pela impressão do romaneio de separação conforme definido 
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/27/2022
@param cSimula, character, ID da simulação (opcional, caso o parâmetro lEmail for .T., esse parâmetro se torna obrigatório)
@param lEmail, logical, indica se o relatório está sendo gerado de forma automática (opcional)
@return character, cFilePDF (apenas quando geração for automática)
/*/
user function LSROMS03( cSimula, lEmail )

    local aArea     := getArea()
    local oReport   as object
    local cPerg     := AllTrim( structPerg() )
    local cFileName := "" as character
    local cFilePDF  := "" as character

    default cSimula := ""
    default lEmail  := .F.

    // Estrutura a pesquisa padrão para seleção das simulações
    structSXB()     // Pesquisa padrão de simulações
    if Empty( cSimula )
        if lEmail
            Help( ,, 'Automático',, "ID da simulação não enviado!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'Para utilizar o relatório anexado ao e-mail, o ID da simulação deve ser recebido via parâmetro!' } )
            restArea( aArea )
            return nil
        endif
        if ! Pergunte( cPerg, .T. )
            restArea( aArea )
            return Nil  
        endif
    else
        // Carrega grupo de perguntas apenas em memória sem exibir janela
        pergunte( cPerg, .F. )
        MV_PAR01 := cSimula
    endif
    
    // Valida regra de negócio antes de prosseguir com a impressão do relatório
    DBSelectArea( "ZN1" )
    ZN1->( DBSetOrder( 1 ) )    // ZN1_FILIAL + ZN1_SIMULA
    if ! ZN1->( DBSeek( FWxFilial( "ZN1" ) + MV_PAR01 ) )
        Help( ,, 'ID Simulação',, "O código da simulação informada não existe!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'Utilize a lupa de pesquisa para facilitar o preenchimento ou digite um código válido!' } )
    elseif (Empty( ZN1->ZN1_VEICUL ) .or. Empty(DtoS(ZN1->ZN1_DTEMB)) .or. Empty(DtoS(ZN1->ZN1_DTSEP))  )
        Help( ,, 'Carga Não Preparada',, "Veículo, Data de Embarque ou Data de Separação ainda não foram definidos!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'Defina o veículo, data de embarque e data de separação primeiro para que seja possível gerar o mapa de carregamento!' } )
    else

        // Verifica se o usuário gostaria de revisar a sequência de entrega antes de prosseguir, caso contrário
        if ! U_LSSEQENT( MV_PAR01 )
            msgInfo( "Impressão cancelada!","Cancelado" )
            Return nil
        endif

        // Monta modelo padrão do relatório
        oReport := reportDef( cPerg, cSimula )

        // Quando for para anexar o arquivo ao PDF ao e-mail, apenas imprime o PDF
        if lEmail

            cFileName := AllTrim(cPerg) +"_"+ AllTrim(MV_PAR01)
            oReport:SetDevice( PRINTPDF )   // Imprime em PDF para anexar ao e-mail
            oReport:SetEnvironment( 2 )     // Gera relatório em PDF no Client 1=Server ou 2=Client
            oReport:SetPreview(.F.)         // Desativa prévia de impressão
            oReport:SetFile( cFileName )
            oReport:cPathPDF := GetTempPath(.T. /* lLocal */)
            oReport:Print(.F. /* lShowDlg */)

            // Atribui e caminho do arquivo em PDF para retornar para a função responsável por anexar o arquivo ao workflow
            cFilePDF := GetTempPath(.T. /* lLocal */) + "totvsprinter\"+cFileName +".tmp.pdf"
            if ! File( cFilePDF )
                cFilePDF := ""
                Help( ,, 'PDF não gerado!',, "Falha durante o processo de geração do mapa de carregamento em PDF", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'Favor entrar em contato com o administrador do sistema!' } )
            else
                // Copia arquivo pdf para dentro do diretório spool do protheus para poder anexar no workflow
                if CpyT2S( cFilePDF, '\spool' )
                    cFilePDF := "\spool\"+ cFileName +".tmp.pdf"
                else
                    Help( ,, 'PDF não gerado!',, "Falha ao copiar PDF para o servidor...", 1, 0, NIL, NIL, NIL, NIL, NIL,;
                        { 'Favor entrar em contato com o administrador do sistema!' } )
                endif
            endif

        else
		    oReport:PrintDialog()
        endif

    endif

    restArea( aArea )
return cFilePDF

/*/{Protheus.doc} reportDef
Função para montar o modelo gráfico do relatório a ser impresso
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/27/2022
@param cPerg, character, ID do grupo de perguntas
@param cSimula, character, ID do processo de simulação (opcional)
@return object, oReport
/*/
static function reportDef( cPerg, cSimula )
    
    Local oReport  as object
	Local oCarga   as object
    local oPontos  as object
	Local oProds   as object
    //local oBreak   as object

    default cSimula := ""

	//Criação do componente de impressão
	oReport := TReport():New(	AllTrim(cPerg),;		                    //Nome do Relatório
								"Mapa de Carregamento - "+ MV_PAR01,;		//Título
								iif(Empty(cSimula), cPerg, nil ),;          //Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| reportPrint( oReport )},;	//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9)   // Folha A4
	oReport:SetLandscape()           // Folha na vertical
	oReport:SetLineHeight(90)
	oReport:nFontBody := 11
    oReport:cFontBody := "Courier New" 
    oReport:SetBorder( "ALL", 10, RGB(0,0,0), .T. ) 


	//Criando a seção de dados
	oCarga := TRSection():New(	oReport,;		        // Objeto TReport que a seção pertence
                                "Dados da Simulação",;	// Descrição da seção
                                { "QRYAUX" })		    // Tabelas utilizadas, a primeira será considerada como principal da seção
	oCarga:SetTotalInLine(.F.)  // Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas da seção carga
	TRCell():New(oCarga, "ZN1_SIMULA", "QRYAUX", "Simulação", "@!", TAMSX3("ZN1_SIMULA")[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
	TRCell():New(oCarga, "ZN1_VEICUL", "QRYAUX", "Veiculo"  , "@!", TAMSX3("ZN1_VEICUL")[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "DA3_DESC"  , "QRYAUX", "Modelo"   , "@x", TAMSX3("DA3_DESC"  )[1]  , /*lPixel*/,{|| AllTrim(RetField( "DA3",1,FWxFilial("DA3") + cVeiculo,"DA3_DESC" )) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "ZN1_MOTORI", "QRYAUX", "Cod.Mot." , "@!", TAMSX3("ZN1_MOTORI")[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "DA4_NOME"  , "QRYAUX", "Motorista", "@x", TAMSX3("DA4_NOME"  )[1]  , /*lPixel*/,{|| AllTrim(RetField( "DA4",1,FWxFilial("DA4") + cMotorista,"DA4_NOME" )) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "ZN1_DTSEP" , "QRYAUX", "Dt.Sep."  , "@D",                        20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "ZN1_DTEMB" , "QRYAUX", "Dt.Emb."  , "@D",                        20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "ZN1_HORA"  , "QRYAUX", "Hora"     , "@!", TAMSX3("ZN1_HORA"  )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "PESOBRUTO" , "QRYAUX", "Peso"     , "@E 999,999.999",            20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "VOLUMEM3"  , "QRYAUX", "Volume M3", "@E 99,999.999",             18, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "PONTOSENT" , "QRYAUX", "Entregas" , "@E 999",                    10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oCarga, "VALOR"     , "QRYAUX", "Valor Car", "@E 999,999,999.99",         20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    oCarga:SetHeaderSection( .T. /* lHeaderSection */ )    // Imprime o cabeçalho da seção a cada quebra de seção

    //Criando a seção dos pontos de entrega
	oPontos := TRSection():New(	oCarga,;		            // Objeto TReport que a seção pertence
									"Pontos de Entrega",;	// Descrição da seção
									{ "PONTOS" })		    // Tabelas utilizadas, a primeira será considerada como principal da seção
	oPontos:SetTotalInLine(.F.)  // Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	TRCell():New(oPontos, "C5_X_SQENT", "PONTOS", "Seq.Entrega", "@!", TAMSX3("C5_X_SQENT" )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oPontos, "C5_X_LACRE", "PONTOS", "Lacre"      , "@!", TAMSX3("C5_X_LACRE" )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oPontos, "C5_CLIENT" , "PONTOS", "Cliente"    , "@!", TAMSX3("C5_CLIENT"  )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oPontos, "C5_LOJAENT", "PONTOS", "Loja"       , "@!", TAMSX3("C5_LOJAENT" )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oPontos, "A1_NREDUZ" , "PONTOS", "N.Fantasia" , "@!",                         30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oPontos, "A1_NOME"   , "PONTOS", "Raz. Social", "@!",                         30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
	TRCell():New(oPontos, "PESOBRUTO" , "PONTOS", "Peso"       , "@E 999,999.999",             20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oPontos, "VOLUMEM3"  , "PONTOS", "Volume M3"  , "@E 99,999.999",              18, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    oPontos:SetHeaderSection( .T. /* lHeaderSection */)

    oProds := TRSection():New(	oPontos,;		            // Objeto TReport que a seção pertence
                                "Produtos",;	            // Descrição da seção
                                { "PRODS" })		        // Tabelas utilizadas, a primeira será considerada como principal da seção
    TRCell():New(oProds, "WHITE01"   , "PRODS", "->"       , "@!", 01, /*lPixel*/,{|| Space(1) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oProds, "C9_PEDIDO" , "PRODS", "Pedido"   , "@!", TAMSX3("C9_PEDIDO"  )[1]+9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oProds, "C9_ITEM"   , "PRODS", "Item"     , "@!", TAMSX3("C9_ITEM"    )[1]+4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oProds, "C9_PRODUTO", "PRODS", "Produto"  , "@!", TAMSX3("C6_DESCRI" )[1]+50, /*lPixel*/,{|| Trim(PRODS->C9_PRODUTO) +'-'+ Trim(PRODS->C6_DESCRI) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oProds, "C9_LOTECTL", "PRODS", "Lote"     , "@x", TAMSX3("C9_LOTECTL" )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oProds, "C9_QTDLIB" , "PRODS", "Qt.Lib."  , "@E 999,999.9999", TAMSX3("C9_QTDLIB"  )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oProds, "C6_UM"     , "PRODS", "Un.M."    , "@!", TAMSX3("C6_UM"      )[1]+8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.F./*lBold*/)
    TRCell():New(oProds, "PESOBRUTO" , "PRODS", "Peso"     , "@E 999,999.9999",            18, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oProds, "C9_QTDLIB2", "PRODS", "Volumes"   , "@E 999,999.999",             18, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oProds, "PESOINFO"  , "PRODS", "Peso Inf.", "@!",                         30, /*lPixel*/,{|| '['+ Space(12) +']' },"CENTER",/*lLineBreak*/,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)
    TRCell():New(oProds, "LOTEINFO"  , "PRODS", "Lote Inf.", "@!",                         30, /*lPixel*/,{|| '['+ Space(12) +']' },"CENTER",/*lLineBreak*/,"CENTER",/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T./*lBold*/)

    oBreak := TRBreak():New(oProds,{|| PRODS->(C9_PEDIDO) },{|| "Pedido " })
    oProds:SetHeaderBreak(.T.)      // Indica que deve imprimir cabeçalho toda vez que houver quebra de seção
    oPontos:SetHeaderBreak(.T.)
    oCarga:SetHeaderBreak(.T.)
    //oProds:SetPageBreak(.T.)        // Salta página a cada quebra de seção

return oReport

/*/{Protheus.doc} reportPrint
Função para realizar a impressão gráfica do relatório usando como base o modelo definido no reportDef
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/27/2022
@param oReport, object, objeto modelo do relatório
/*/
static function reportPrint( oReport )

    local oCarga  := oReport:section(1)
    local oPontos := oCarga:section(1)
    local oProds  := oPontos:section(1)
    local cQuery  := "" as character
    local cPedido := "" as character

    private cMotorista := "" as character
    private cVeiculo   := "" as character

    // Captura dados da simulação de carga
    cQuery := "SELECT ZN1.ZN1_SIMULA, ZN1.ZN1_VEICUL, ZN1.ZN1_MOTORI, ZN1.ZN1_DTSEP, ZN1.ZN1_DTEMB, ZN1.ZN1_HORA, "
    cQuery += " SUM(B1.B1_PESBRU * C9.C9_QTDLIB) PESOBRUTO, "                                                               // Peso bruto com base no peso cadastrado no produto e na quantidade liberada
    cQuery += " SUM( COALESCE( (B5.B5_COMPRLC * B5.B5_LARGLC * B5.B5_ALTURLC ) * C9.C9_QTDLIB , 0 ) ) VOLUMEM3, "           // Metragem cubica obtica com base no comprimento, largura e altura informado no complemento do produto SB5
    cQuery += " COUNT( DISTINCT CONCAT( C9.C9_CLIENTE, C9.C9_LOJA ) ) PONTOSENT, "                                          // Conta quantos clientes diferentes existem para calcular os pontos de entrega
    cQuery += " SUM( C9.C9_QTDLIB * C9.C9_PRCVEN ) VALOR "                                                                  // Soma o valor com base no preço unitário e na quantidade liberada
    cQuery += "FROM "+ retSqlName( "ZN1" ) +" ZN1 "
    
    // Itens liberados dos pedidos
    cQuery += "INNER JOIN "+ retSqlName( "SC9" ) +" C9 "
    cQuery += " ON C9.C9_FILIAL  = '"+ FWxFilial( "SC9" ) +"' "
    cQuery += "AND C9.C9_X_SIMUL = '"+ MV_PAR01 +"' "
    cQuery += "AND C9.D_E_L_E_T_ = ' ' "

    // Produto
    cQuery += "INNER JOIN "+ retSqlName( "SB1" ) +" B1 "
    cQuery += " ON B1.B1_FILIAL  = '"+ FWxFilial( "SB1" ) +"' "
    cQuery += "AND B1.B1_COD     = C9.C9_PRODUTO "
    cQuery += "AND B1.D_E_L_E_T_ = ' ' "

    // Complemento de produto
    cQuery += "LEFT JOIN "+ retSqlName( "SB5" ) +" B5 "
    cQuery += " ON B5.B5_FILIAL  = '"+ FWxFilial( "SB5" ) +"' "
    cQuery += "AND B5.B5_COD     = B1.B1_COD "
    cQuery += "AND B5.D_E_L_E_T_ = ' ' "

    cQuery += "WHERE ZN1.ZN1_FILIAL = '"+ FWxFilial( "ZN1" ) +"' "
    cQuery += "  AND ZN1.ZN1_SIMULA = '"+ MV_PAR01 +"' "
    cQuery += "  AND ZN1.D_E_L_E_T_ = ' ' "

    cQuery += "GROUP BY ZN1.ZN1_SIMULA, ZN1.ZN1_VEICUL, ZN1.ZN1_MOTORI, ZN1.ZN1_DTSEP, ZN1.ZN1_DTEMB, ZN1.ZN1_HORA "

    DBUseArea( .T. /* lnew */, "TOPCONN" /* cDriver */, TcGenQry( ,,cQuery ), "QRYAUX" /* cAlias */, .F. /* lShared */, .T. /* lReadOnly */  )
    
    // Seta tipagem dos campos na tabela temporária do retorno da query
    TcSetField( "QRYAUX","ZN1_DTSEP", "D" )
    TcSetField( "QRYAUX","ZN1_DTEMB", "D" )

    if !QRYAUX->( EOF() )
        oCarga:Init()
        cVeiculo   := QRYAUX->ZN1_VEICUL
        cMotorista := QRYAUX->ZN1_MOTORI
        oCarga:PrintLine()
        
        // Define query para leitura da sequência de entrega 
        cQuery := "SELECT C5_X_SQENT, C5_X_LACRE, C5_CLIENT, C5_LOJAENT, A1_NREDUZ, A1_NOME, "
        cQuery += "       SUM(B1.B1_PESBRU * C9.C9_QTDLIB) PESOBRUTO, "
        cQuery += "       SUM( COALESCE( (B5.B5_COMPRLC * B5.B5_LARGLC * B5.B5_ALTURLC ) * C9.C9_QTDLIB , 0 ) ) VOLUMEM3 "
        cQuery += "FROM "+ retSqlName("SC5") + " C5 "

        // Liga com cliente
        cQuery += "INNER JOIN "+ retSqlname( "SA1" ) +" A1 "
        cQuery += " ON A1.A1_FILIAL  = '"+ FWxFilial( "SA1" ) +"' "
        cQuery += "AND A1.A1_COD     = C5.C5_CLIENT "
        cQuery += "AND A1.A1_LOJA    = C5.C5_LOJACLI "
        cQuery += "AND A1.D_E_L_E_T_ = ' ' "

        // Itens liberados do pedido
        cQuery += "INNER JOIN "+ retSqlname( "SC9" ) +" C9 "
        cQuery += " ON C9.C9_FILIAL  = '"+ FWxFilial( "SC9" ) +"' "
        cQuery += "AND C9.C9_PEDIDO  = C5.C5_NUM "
        cQuery += "AND C9.C9_X_SIMUL = C5.C5_X_SIMUL "
        cQuery += "AND C9.D_E_L_E_T_ = ' ' "

        // Itens dos pedidos
        cQuery += "INNER JOIN "+ retSqlname( "SC6" ) +" C6 "
        cQuery += " ON C6.C6_FILIAL  = '"+ FwxFilial( "SC6" ) +"' "
        cQuery += "AND C6.C6_NUM     = C9.C9_PEDIDO "
        cQuery += "AND C6.C6_ITEM    = C9.C9_ITEM "
        cQuery += "AND C6.C6_PRODUTO = C9.C9_PRODUTO "
        cQuery += "AND C6.D_E_L_E_T_ = ' ' "

        // Produto
        cQuery += "INNER JOIN "+ retSqlname( "SB1" ) +" B1 "
        cQuery += " ON B1.B1_FILIAL  = '"+ FWxFilial( "SB1" ) +"' "
        cQuery += "AND B1.B1_COD     = C9.C9_PRODUTO "
        cQuery += "AND B1.D_E_L_E_T_ = ' ' "

        // Complemento de produto
        cQuery += "LEFT JOIN "+ retSqlName( "SB5" ) +" B5 "
        cQuery += " ON B5.B5_FILIAL  = '"+ FWxFilial( "SB5" ) +"' "
        cQuery += "AND B5.B5_COD     = B1.B1_COD "
        cQuery += "AND B5.D_E_L_E_T_ = ' ' "

        cQuery += "WHERE C5.C5_FILIAL  = '"+ FWxFilial( "SC5" ) +"' "      
        cQuery += "  AND C5.C5_X_SIMUL = '"+ MV_PAR01 +"' "
        cQuery += "  AND C5.D_E_L_E_T_ = ' ' "

        cQuery += "GROUP BY C5_X_SQENT, C5_X_LACRE, C5_CLIENT, C5_LOJAENT, A1_NREDUZ, A1_NOME "

        DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PONTOS", .F., .T. )
        if !PONTOS->( EOF() )

            while !PONTOS->( EOF() )
                oPontos:Init()
                oPontos:PrintLine()

                // Define query para leitura dos produtos do ponto de entrega 
                cQuery := "SELECT C9_PEDIDO, C9_ITEM, TRIM(C9_PRODUTO) C9_PRODUTO, C6_DESCRI, "+ CHR(13)+CHR(10)
                cQuery += "       CASE WHEN B1.B1_RASTRO = 'L' THEN C9_LOTECTL ELSE C6.C6_X_LOTE END C9_LOTECTL, "+ CHR(13)+CHR(10)
                cQuery += "       C9_QTDLIB, C9_QTDLIB2, C6_UM, C9_QTDLIB2, C6_SEGUM, " + CHR(13)+CHR(10)
                cQuery += "       B1.B1_PESBRU * C9.C9_QTDLIB PESOBRUTO, "+ CHR(13)+CHR(10)
                cQuery += "       COALESCE( (B5.B5_COMPRLC * B5.B5_LARGLC * B5.B5_ALTURLC ) * C9.C9_QTDLIB , 0 ) VOLUMEM3 "+ CHR(13)+CHR(10)
                cQuery += "FROM "+ retSqlName("SC5") + " C5 "+ CHR(13)+CHR(10)

                // Liga com itens do pedido
                cQuery += "INNER JOIN "+ retSqlName( "SC6" ) +" C6 "+ CHR(13)+CHR(10)
                cQuery += " ON C6.C6_FILIAL  = '"+ FWxFilial( "SC6" ) +"' "+ CHR(13)+CHR(10)
                cQuery += "AND C6.C6_NUM     = C5.C5_NUM "+ CHR(13)+CHR(10)
                cQuery += "AND C6.D_E_L_E_T_ = ' ' "+ CHR(13)+CHR(10)

                // Liga com cliente
                cQuery += "INNER JOIN "+ retSqlname( "SA1" ) +" A1 "+ CHR(13)+CHR(10)
                cQuery += " ON A1.A1_FILIAL  = '"+ FWxFilial( "SA1" ) +"' "+ CHR(13)+CHR(10)
                cQuery += "AND A1.A1_COD     = C5.C5_CLIENT "+ CHR(13)+CHR(10)
                cQuery += "AND A1.A1_LOJA    = C5.C5_LOJACLI "+ CHR(13)+CHR(10)
                cQuery += "AND A1.D_E_L_E_T_ = ' ' "+ CHR(13)+CHR(10)

                // Itens liberados do pedido
                cQuery += "INNER JOIN "+ retSqlname( "SC9" ) +" C9 "+ CHR(13)+CHR(10)
                cQuery += " ON C9.C9_FILIAL  = '"+ FWxFilial( "SC9" ) +"' "+ CHR(13)+CHR(10)
                cQuery += "AND C9.C9_PEDIDO  = C6.C6_NUM "+ CHR(13)+CHR(10)
                cQuery += "AND C9.C9_ITEM    = C6.C6_ITEM "+ CHR(13)+CHR(10)
                cQuery += "AND C9.C9_PRODUTO = C9.C9_PRODUTO "+ CHR(13)+CHR(10)
                cQuery += "AND C9.C9_X_SIMUL = C5.C5_X_SIMUL "+ CHR(13)+CHR(10)
                cQuery += "AND C9.D_E_L_E_T_ = ' ' "+ CHR(13)+CHR(10)

                // Produto
                cQuery += "INNER JOIN "+ retSqlname( "SB1" ) +" B1 "+ CHR(13)+CHR(10)
                cQuery += " ON B1.B1_FILIAL  = '"+ FWxFilial( "SB1" ) +"' "+ CHR(13)+CHR(10)
                cQuery += "AND B1.B1_COD     = C9.C9_PRODUTO "+ CHR(13)+CHR(10)
                cQuery += "AND B1.D_E_L_E_T_ = ' ' "+ CHR(13)+CHR(10)

                // Complemento de produto
                cQuery += "LEFT JOIN "+ retSqlName( "SB5" ) +" B5 "+ CHR(13)+CHR(10)
                cQuery += " ON B5.B5_FILIAL  = '"+ FWxFilial( "SB5" ) +"' "+ CHR(13)+CHR(10)
                cQuery += "AND B5.B5_COD     = B1.B1_COD "+ CHR(13)+CHR(10)
                cQuery += "AND B5.D_E_L_E_T_ = ' ' "+ CHR(13)+CHR(10)

                cQuery += "WHERE C5.C5_FILIAL  = '"+ FWxFilial( "SC5" ) +"' "      + CHR(13)+CHR(10)
                cQuery += "  AND C5.C5_X_SIMUL = '"+ MV_PAR01 +"' "+ CHR(13)+CHR(10)
                cQuery += "  AND C5.C5_CLIENT  = '"+ PONTOS->C5_CLIENT +"' "+ CHR(13)+CHR(10)
                cQuery += "  AND C5.C5_LOJAENT = '"+ PONTOS->C5_LOJAENT +"' "+ CHR(13)+CHR(10)
                cQuery += "  AND C5.D_E_L_E_T_ = ' ' "+ CHR(13)+CHR(10)
                
                cQuery += "ORDER BY C9_PEDIDO, C9_ITEM, TRIM(C9_PRODUTO), C6_DESCRI, C9_LOTECTL "
                //CopyToClipBoard(cQuery)
                DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PRODS", .F., .T. )

                if !PRODS->(EOF())
                    
                    oProds:Init()
                    cPedido := PRODS->C9_PEDIDO

                    while !PRODS->( EOF() )
                        // A cada alteração de pedido, quebra página e reimprime o cabeçalho
                        if cPedido != PRODS->C9_PEDIDO
                            oPontos:Finish()
                            oReport:EndPage()
                            oCarga:PrintLine()
                            oPontos:Init()
                            oPontos:PrintLine()
                        endif
                        oProds:PrintLine()
                        cPedido := PRODS->C9_PEDIDO
                        PRODS->( DBSkip() )
                    enddo
                    oProds:Finish()
                endif
                PRODS->( DBCloseArea() )  

                PONTOS->( DBSkip() )
                oPontos:Finish()
                
                if ! PONTOS->(EOF())
                    oReport:EndPage()
                    oCarga:PrintLine()
                endif       

            enddo

        endif
        PONTOS->( DBCloseArea() )

        oCarga:Finish()
    endif
    QRYAUX->( DBCloseArea() )

return Nil


/*/{Protheus.doc} structPerg
Grupo de perguntas do relatório
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/27/2022
@return character, ID do grupo de perguntas
/*/
static function structPerg()
    
    local cPerg := PADR("LSROMS03",10," ")       // grupo de perguntas do relatório

    DBSelectArea( "SX1" )
    SX1->( DBSetOrder( 1 ) )        // X1_GRUPO + X1_ORDEM
    if ! SX1->(DBSeek( cPerg + "01" ))
        PutSX1( cPerg, "01", "Cod.Simulação", "Simulación", "Simulation ID", "mv_ch1" , "C", TAMSX3("ZN1_SIMULA")[1], 0, 0, "G", "", "ZN1SIM","","","MV_PAR01",,,,,,,,,,,,,,,,,,,)
    endif
    
return cPerg

/*/{Protheus.doc} structSXB
Função para criar a pesquisa padrão no dicionário de dados de forma automática
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/27/2022
@return logical, lSXBExists
/*/
static function structSXB()
    
    local lSuccess := .F.      as logical
    local cSXB     := "ZN1SIM" as character
    
    lSuccess := existSXB( cSXB )
    if !lSuccess
        DBSelectArea( "SXB" )
        SXB->( DBSetOrder(1) )
        
        // Cabeçalho da Pesquisa Padrão
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "1"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "DB"
        SXB->XB_DESCRI  := "Simulacoes de Carga "
        SXB->XB_DESCSPA := "Simulaciónes"
        SXB->XB_DESCENG := "Simulations"
        SXB->XB_CONTEM  := "ZN1"
        SXB->(MSUnlock())

        // Índices da pesquisa
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "2"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "01"
        SXB->XB_DESCRI  := "Simulacoes"
        SXB->XB_DESCSPA := "Simulaciónes"
        SXB->XB_DESCENG := "Simulations"
        SXB->XB_CONTEM  := ""
        SXB->(MSUnlock())

        // Coluna de exibição 01 do índice 1
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "4"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "01"
        SXB->XB_DESCRI  := "Simulacoes"
        SXB->XB_DESCSPA := "Simulaciónes"
        SXB->XB_DESCENG := "Simulations"
        SXB->XB_CONTEM  := "ZN1_SIMULA"
        SXB->(MSUnlock())

        // Coluna de exibição 02 do índice 1
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "4"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "02"
        SXB->XB_DESCRI  := "Veiculo"
        SXB->XB_DESCSPA := "Vehículo"
        SXB->XB_DESCENG := "Vehicle"
        SXB->XB_CONTEM  := "ZN1_VEICUL"
        SXB->(MSUnlock())

        // Coluna de exibição 03 do índice 1
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "4"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "03"
        SXB->XB_DESCRI  := "Placa"
        SXB->XB_DESCSPA := "Junta"
        SXB->XB_DESCENG := "Board"
        SXB->XB_CONTEM  := "ZN1_PLACA"
        SXB->(MSUnlock())

        // Coluna de exibição 04 do índice 1
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "4"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "04"
        SXB->XB_DESCRI  := "Separação"
        SXB->XB_DESCSPA := "Separación"
        SXB->XB_DESCENG := "Separation"
        SXB->XB_CONTEM  := "ZN1_DTSEP"
        SXB->(MSUnlock())

        // Coluna de exibição 05 do índice 1
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "4"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "05"
        SXB->XB_DESCRI  := "Embarque"
        SXB->XB_DESCSPA := "Embarque"
        SXB->XB_DESCENG := "Boarding"
        SXB->XB_CONTEM  := "ZN1_DTEMB"
        SXB->(MSUnlock())

        // Retorno da pesquisa padrão
        RecLock("SXB", .T.)
        SXB->XB_ALIAS   := cSXB
        SXB->XB_TIPO    := "5"       
        SXB->XB_SEQ     := "01"
        SXB->XB_COLUNA  := "  "
        SXB->XB_DESCRI  := " "
        SXB->XB_DESCSPA := " "
        SXB->XB_DESCENG := " "
        SXB->XB_CONTEM  := "ZN1->ZN1_SIMULA"
        SXB->(MSUnlock())

    endif
return existSXB( cSXB )

/*/{Protheus.doc} existSXB
Função para retornar existência da pesquisa padrão enviada por parâmetro
@type function
@version 1.0
@author Jean Carlos Pandolfo Saggin
@since 1/27/2022
@param cSXB, character, ID da pesquisa padrão
@return logical, lExists
/*/
static function existSXB( cSXB )
    DBSelectArea( "SXB" )
    SXB->( DBSetOrder( 1 ) )        // SXB_ALIAS + XB_TIPO + XB_SEQ + XB_COLUNA
return SXB->( DBSeek( cSXB ) )
