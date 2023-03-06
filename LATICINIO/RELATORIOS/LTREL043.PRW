#include "rwmake.ch"    
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL043  º Autor ³Djonata Guizzo       º Data ³ 18/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatório de análises de qualidade.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTREL043()
    Local   _aCaract    := {}
    Local   aFields     := {}
    Local   _nI
    Private oReport
    Private cFile		:= "LTREL043"
    Private cPerg		:= "LTREL039LT"
    Private cTitle		:= "Análises de Qualidade"
    Private cHelp		:= "Relatório responsável por apresentar as principais informações à respeito das ocorrências de análises de qualidade vinculadas à registros de pesagens."
    Private cAliasTMP	:= GetNextAlias()
    Private cAliasTMP2	:= GetNextAlias()
    Private cAliasTMP3	:= GetNextAlias()



    dbSelectArea("ZA3")
    ZA3->(dbSetOrder(1))
    ZA3->(dbGoTop())
    While ZA3->(!EOF())
        aAdd(_aCaract,{ZA3->ZA3_COD, ZA3->ZA3_TIPO})
        ZA3->(dbSkip())
    EndDo

    // Crio Alias temporário que será utilizado para gravação dos dados a serem apresentados no objeto oSection4
    oTempTable := FWTemporaryTable():New( "TRB" )
    //--------------------------
    //Monta os campos da tabela
    //--------------------------
    aadd(aFields,{"ZM4_FILIAL","C",TamSx3('ZM4_FILIAL')[1],0})
    aadd(aFields,{"ZM4_NUM","C",TamSx3('ZM4_NUM')[1],0})
    aadd(aFields,{"ZM4_TANQUE","C",TamSx3('ZM4_TANQUE')[1],0})
    aadd(aFields,{"ZM4_HRDESC","C",TamSx3('ZM4_HRDESC')[1],0})
    aadd(aFields,{"ZM4_SILO","N",TamSx3('ZM4_SILO')[1],0})
    aadd(aFields,{"ZM4_SEQSIL","N",TamSx3('ZM4_SEQSIL')[1],0})

    For _nI := 1 To Len(_aCaract)
        If _aCaract[_nI,2] == 'T'
            _cTipo := 'C'
            _nTam1 := 10
            _nTam2 := 0
        Else
            _cTipo := 'N'
            _nTam1 := 12
            _nTam2 := 4
        EndIf
        aadd(aFields,{"TRB_"+_aCaract[_nI,1],_cTipo,_nTam1,_nTam2})
    Next _nI


    aadd(aFields,{"ZM4_STATUS","C",TamSx3('ZM4_STATUS')[1],0})

    oTemptable:SetFields( aFields )
    oTempTable:AddIndex("01", {"ZM4_NUM", "ZM4_TANQUE"} )
    //------------------
    //Criação da tabela
    //------------------
    oTempTable:Create()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Executa a rotina de verificação do grupo de perguntas³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    PERGUNTE(cPerg, .F.)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Cria o objeto pertinente ao processamento do relatório³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oReport := REL043()
    oReport:PRINTDIALOG()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Elimina tabelas temporárias³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    If Select(cAliasTMP) > 0
        (cAliasTMP)->(dbCloseArea())
    EndIf

    If Select(cAliasTMP2) > 0
        (cAliasTMP2)->(dbCloseArea())
    EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REL043  ºAutor  ³Djonata Guizzo        º Data ³ 18/02/2021  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pelo processamento das demais regras em  º±±
±±º          ³torno da execução do relatório.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function REL043()

    Local aOrdem	:= {}

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Cria o componente de processamento do relatório³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL043PRT(oReport)}, cHelp,, "Total Filial")
    oReport:SetLandscape()
    oReport:EndReport(.F.)
    oReport:SetTotalInLine(.F.)
    oReport:bTotalPrint := {|| }


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Cria a sessão principal de FILIAL³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oSection1 := TRSection():New(oReport, "Filial", {"SM0"}, aOrdem)
    TRCell():New(oSection1, "ZM1_FILIAL", ""   , "Filial")
    TRCell():New(oSection1, "M0_FILIAL"	, "SM0", "Descrição", "@!", 30,, {|| POSICIONE("SM0", 1, cEmpAnt + (cAliasTMP)->ZM1_FILIAL, "M0_FILIAL")})


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Cria a sessão principal de PRODUTO³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oSection2 := TRSection():New(oSection1, "Produto", {"SB1"})
    oSection2:SetLeftMargin(02)
    TRCell():New(oSection2, "B1_COD"	, "SB1", "Produto",,TAMSX3("B1_COD")[1])
    TRCell():New(oSection2, "B1_DESC"	, "SB1", "Descrição",,50)
    TRCell():New(oSection2, "TIPO"		,    "", "Tipo", "@!", 15,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", "ENTRADA", "SAIDA")})


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Cria a sessão principal de PESAGENS³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oSection3 := TRSection():New(oSection2, "Pesagens", {"ZM1"})
    oSection3:lHeaderVisible := .F.
    oSection3:SetLeftMargin(04)

    TRCell():New(oSection3, "ZM1_NUM"	, "ZM1",,,06)
    TRCell():New(oSection3, "ZM1_CLIFOR", "ZM1",,,TAMSX3("ZM1_CLIFOR")[1])
    TRCell():New(oSection3, "ZM1_LOJA"	, "ZM1",,,TAMSX3("ZM1_LOJA")[1])
    TRCell():New(oSection3, "ZM1_NOME"	, "ZM1", "Nome",,30)
    TRCell():New(oSection3, "ZM1_PLACA"	, "ZM1", "Placa",,TAMSX3("ZM1_PLACA")[1])
    TRCell():New(oSection3, "ZM1_CODLIN", "ZM1", "Linha",,TAMSX3("ZM1_CODLIN")[1])
    TRCell():New(oSection3, "ZM1_NFCOM"	, "ZM1")
    TRCell():New(oSection3, "ZM1_SRCOM"	, "ZM1")
    TRCell():New(oSection3, "ZM1_DTINI"	, "ZM1", "Data Ent")
    TRCell():New(oSection3, "ZM1_HRINI"	, "ZM1", "Hora Ent")
    TRCell():New(oSection3, "ZM1_KGINI"	, "ZM1", "Kg Entrada",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGINI, ((cAliasTMP)->ZM1_KGINI * -1))})
    TRCell():New(oSection3, "ZM1_DTFIN"	, "ZM1", "Data Sai")
    TRCell():New(oSection3, "ZM1_HRFIN"	, "ZM1", "Hora Sai")
    TRCell():New(oSection3, "ZM1_KGFIN"	, "ZM1", "Kg Saída",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGFIN, ((cAliasTMP)->ZM1_KGFIN * -1))})
    TRCell():New(oSection3, "ZM1_KGBRT"	, "ZM1", "Kg Líquido",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_KGBRT, ((cAliasTMP)->ZM1_KGBRT * -1))})
    TRCell():New(oSection3, "ZM1_LTBRT" , "ZM1", "Lt Líquido",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTBRT, ((cAliasTMP)->ZM1_LTBRT * -1))})
    TRCell():New(oSection3, "ZM1_LTMOV" , "ZM1", "Lt Coleta",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTMOV, ((cAliasTMP)->ZM1_LTMOV * -1))})
    TRCell():New(oSection3, "ZM1_LTNOTA", "ZM1", "Lt Nota",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTNOTA, ((cAliasTMP)->ZM1_LTNOTA * -1))})
    TRCell():New(oSection3, "ZM1_LTDIF" , "ZM1", "Lt Dif.",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_LTDIF, ((cAliasTMP)->ZM1_LTDIF * -1))})
    TRCell():New(oSection3, "ZM1_QLD022", "ZM1", "ST Brix",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_QLD022, ((cAliasTMP)->ZM1_QLD022 * -1))})
    TRCell():New(oSection3, "ZM1_SLKG"  , "ZM1", "Sól. Kg",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_SLKG, ((cAliasTMP)->ZM1_SLKG * -1))})
    TRCell():New(oSection3, "ZM1_SLLT"  , "ZM1", "Sól. Lt",,,, {|| IIF((cAliasTMP)->ZM1_TIPO == "1", (cAliasTMP)->ZM1_SLLT, ((cAliasTMP)->ZM1_SLLT * -1))})
    TRCell():New(oSection3, "ZM1_STATUS", "ZM1", "Pesagem", "@!", 12)
    TRCell():New(oSection3, "ZM1PRCSOL",    "", "Preço Comb.", "@E 999.99", 6,, {|| ROUND(((cAliasTMP)->ZM1_PRCSOL ) , 2)})
    TRCell():New(oSection3, "VLRSOLKG"	,    "", "Vl. Total Sol. KG", "@E 999,999,999.99", 9,, {|| ROUND(((cAliasTMP)->ZM1_SLKG * (cAliasTMP)->ZM1_PRCSOL ) , 2)})
    TRCell():New(oSection3, "VLRSOLLT"	,    "", "Vl. Total Sol. LT", "@E 999,999,999.99", 9,, {|| ROUND(((cAliasTMP)->ZM1_SLLT * (cAliasTMP)->ZM1_PRCSOL ) , 2)})
    TRCell():New(oSection3, "VLRTOTAL"	,    "", "Vl. Total", "@E 999,999,999.99", 9,, {|| ROUND(((cAliasTMP)->ZM1_LTBRT * (cAliasTMP)->ZM1_PRCSOL ) , 2)})
     
    If MV_PAR22 == 1
        TRCell():New(oSection3, "PRECONOTA"	,    "", "Preço NF", "@E 999.99", 6,, {|| (POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_TOTAL") / (POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_QUANT") / (cAliasTMP)->ZM1_FATCON))})
        TRCell():New(oSection3, "QTDCONOTA"	,    "", "QTD NF", "@E 999,999.99", 10,, {|| (POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_QUANT") / (cAliasTMP)->ZM1_FATCON)})
        TRCell():New(oSection3, "TOTALNOTA"	,    "", "TOTAL NF", "@E 999,999.99", 10,, {|| POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_TOTAL")})
        TRCell():New(oSection3, "VLDIFEREN"	,    "", "DIF VALOR", "@E 999,999.99", 10,, {|| ROUND(POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_TOTAL") - ((cAliasTMP)->ZM1_SLKG * (cAliasTMP)->ZM1_PRCSOL ),2) })
    Else
        TRCell():New(oSection3, "PRECONOTA"	,    "", "Preço NF", "@E 999.99", 6,, {|| POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_VUNIT")})
        TRCell():New(oSection3, "QTDCONOTA"	,    "", "QTD NF", "@E 999,999.99", 10,, {|| POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_QUANT")})
        TRCell():New(oSection3, "TOTALNOTA"	,    "", "TOTAL NF", "@E 999,999.99", 10,, {|| POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_TOTAL")})
        TRCell():New(oSection3, "VLDIFEREN"	,    "", "DIF VALOR", "@E 999,999.99", 10,, {|| ROUND(POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_TOTAL") - ((cAliasTMP)->ZM1_SLLT * (cAliasTMP)->ZM1_PRCSOL ),2) })
    EndIf
   
   
    If MV_PAR22 == 1
	    cQryLtKg := "%SUM((DADOS.ZM1_SLKG * DADOS.ZM1_PRCSOL) - DADOS.D1_TOTAL) SD1_VLTOTD %" 
	    cQryUnQt := "%(SD1.D1_TOTAL / (SD1.D1_QUANT / ZM1_FATCON)) D1_VUNIT, (SD1.D1_QUANT / ZM1_FATCON) D1_QUANT%"
    Else
	    cQryLtKg := "%SUM((DADOS.ZM1_SLLT * DADOS.ZM1_PRCSOL) - DADOS.D1_TOTAL) SD1_VLTOTD %" 
	    cQryUnQt := "%SD1.D1_VUNIT,SD1.D1_QUANT%"
    EndIf

    oSection3:aCell[6]:Disable()
    oSection3:aCell[10]:Disable()
    oSection3:aCell[12]:Disable()
    oSection3:aCell[13]:Disable()
    oSection3:aCell[16]:Disable()
    oSection3:aCell[17]:Disable()
    oSection3:aCell[18]:Disable()
    oSection3:aCell[19]:Disable()
    oSection3:aCell[20]:Disable()
    oSection3:aCell[21]:Disable()
    oSection3:aCell[22]:Disable()
    oSection3:aCell[23]:Disable()
    oSection3:aCell[24]:Disable()
    oSection3:aCell[25]:Disable()
    oSection3:aCell[26]:Disable()
    oSection3:aCell[27]:Disable()



    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Cria a sessão principal de ANALISES DE QUALIDADE³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oSection4 := TRSection():New(oSection3, "Análises", {"SB1", "ZM4", "TRB"})
    oSection4:SetLeftMargin(06)
    oSection4:lHeaderVisible := .T.
    TRCell():New(oSection4, "ZM4_TANQUE", "ZM4")
    TRCell():New(oSection4, "ZM4_HRDESC", "ZM4",,"@R 99:99")
    TRCell():New(oSection4, "ZM4_SILO", "ZM4")
    TRCell():New(oSection4, "ZM4_SEQSIL", "ZM4",,"@E 9,999")

    dbSelectArea("ZA3")
    ZA3->(dbSetOrder(1))
    ZA3->(dbGoTop())
    While ZA3->(!EOF())
        TRCell():New(oSection4, "TRB_"+ZA3->ZA3_COD, "TRB",AllTrim(ZA3->ZA3_DESCR), iif(ZA3->ZA3_TIPO=='N',"@E 999,999.9999",))
        ZA3->(dbSkip())
    EndDo

    TRCell():New(oSection4, "ZM4_STATUS", "ZM4")

    // Faço consulta para preenhcer o alias temporário TRB
    _cQry := ' SELECT '
    _cQry += "      ZM4_FILIAL, ZM4_NUM, ZM4_TANQUE, ZM4_HRDESC, ZM4_SILO, ZM4_SEQSIL, ZM4_STATUS, 'TRB_'+ZM5_CARACT AS ZM5_CARACT, ZM5_TEXTO, ZM5_DESCTX, ZM5_VALOR, ZA3_TIPO "
    _cQry += " FROM "
    _cQry +=        RetSqlName("ZM1") + " ZM1 "
    _cQry += " INNER JOIN " + RetSqlName("ZM4") + " ZM4 ON ZM4.D_E_L_E_T_ = '' AND ZM4_FILIAL = ZM1_FILIAL AND ZM4_NUM = ZM1_NUM "
    _cQry += " INNER JOIN " + RetSqlName("ZM5") + " ZM5 ON ZM5.D_E_L_E_T_ = '' AND ZM5_FILIAL = ZM1_FILIAL AND ZM5_NUM = ZM1_NUM AND ZM5_TANQUE = ZM4_TANQUE "
    _cQry += " INNER JOIN " + RetSqlName("ZA3") + " ZA3 ON ZA3.D_E_L_E_T_ = '' AND ZA3_FILIAL = '"+xFilial("ZA3")+"' AND ZA3_COD = ZM5_CARACT "
    _cQry += " WHERE  "
    _cQry += "      ZM1.D_E_L_E_T_ = '' "
    _cQry += "      AND ZM1.ZM1_FILIAL  >= '"+MV_PAR01+"' AND ZM1.ZM1_FILIAL  <= '"+MV_PAR02+"' "
    _cQry += "      AND ZM1.ZM1_PROD    >= '"+MV_PAR03+"' AND ZM1.ZM1_PROD    <= '"+MV_PAR04+"' "
    _cQry += "      AND ZM1.ZM1_CLIFOR  >= '"+MV_PAR07+"' AND ZM1.ZM1_CLIFOR  <= '"+MV_PAR08+"' "
    _cQry += "      AND ZM1.ZM1_LOJA    >= '"+MV_PAR09+"' AND ZM1.ZM1_LOJA    <= '"+MV_PAR10+"' "
    _cQry += "      AND ZM1.ZM1_PLACA   >= '"+MV_PAR15+"' AND ZM1.ZM1_PLACA   <= '"+MV_PAR16+"' "
    _cQry += "      AND ZM1.ZM1_TRANSP  >= '"+MV_PAR17+"' AND ZM1.ZM1_TRANSP  <= '"+MV_PAR18+"' "
    _cQry += "      AND ZM1.ZM1_DATA	>= '"+dtos(MV_PAR19)+"' AND ZM1.ZM1_DATA    <= '"+dtos(MV_PAR20)+"' "
    //_cQry += "      AND ZM1.ZM1_TIPO     = '2' "
    _cQry += " ORDER BY  "
    _cQry += "      1, 2 "
    

    If Select("TMP") > 0
        TMP->(dbCloseArea())
    EndIf

    TcQuery _cQry New Alias 'TMP'

    _cIdx := ''
    While !TMP->(EOF())
        If _cIdx <> TMP->ZM4_NUM+TMP->ZM4_TANQUE
            
            _cIdx := TMP->ZM4_NUM+TMP->ZM4_TANQUE
            RecLock('TRB',.T.)
                TRB->ZM4_FILIAL := TMP->ZM4_FILIAL
                TRB->ZM4_NUM := TMP->ZM4_NUM
                TRB->ZM4_TANQUE := TMP->ZM4_TANQUE
                TRB->ZM4_STATUS := TMP->ZM4_STATUS
                TRB->ZM4_HRDESC := TMP->ZM4_HRDESC
                TRB->ZM4_SILO := TMP->ZM4_SILO
                TRB->ZM4_SEQSIL := TMP->ZM4_SEQSIL
        EndIf

        While !TMP->(EOF()) .AND. TMP->ZM4_NUM+TMP->ZM4_TANQUE == _cIdx
            TRB->&(TMP->ZM5_CARACT) := IIf(TMP->ZA3_TIPO == 'T', TMP->ZM5_TEXTO+'-'+TMP->ZM5_DESCTX, TMP->ZM5_VALOR)

            TMP->(dbSkip())
        EndDo

        If !Empty(_cIdx)
            TRB->(MsUnlock())
        EndIf

    EndDo
 


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Cria a sessão de TOTAIS POR PRODUTO³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oSection5 := TRSection():New(oReport, "Totais por Produto",,,,,,,.F.,.F.,.F.,,,,,.F.)
    oSection5:SetLeftMargin(50)
    oSection5:lHeaderVisible := .T.
    TRCell():New(oSection5, "B1_COD"	, "", "Produto",PESQPICT("SB1", "B1_COD"), TAMSX3("B1_COD")[1])
    TRCell():New(oSection5, "B1_DESC"	, "", "Descrição",PESQPICT("SB1", "B1_DESC"), TAMSX3("B1_DESC")[1])
    TRCell():New(oSection5, "ZM1_KGBRT"	, "ZM1", "Kg Líquido")
    TRCell():New(oSection5, "ZM1_LTBRT" , "ZM1", "Lt Líquido")
    TRCell():New(oSection5, "ZM1_LTMOV" , "ZM1", "Lt Coleta")
    TRCell():New(oSection5, "ZM1_LTNOTA", "ZM1", "Lt Nota")
    TRCell():New(oSection5, "ZM1_LTDIF" , "ZM1", "Lt Dif.")
    TRCell():New(oSection5, "ZM1_QLD022", "ZM1", "ST Brix")
    TRCell():New(oSection5, "ZM1_SLKG"  , "ZM1", "Sól. Kg")
    TRCell():New(oSection5, "ZM1_SLLT"  , "ZM1", "Sól. Lt")
    TRCell():New(oSection5, "ZM1_VLSLKG", "ZM1", "Vl. Sól. kg")
    TRCell():New(oSection5, "ZM1_VLSLLT", "ZM1", "Vl. Sól. Lt")
    TRCell():New(oSection5, "ZM1_VLSLTT", "ZM1", "Vl. Total")
    TRCell():New(oSection5, "VLDIFEREN"	,    "", "DIF VALOR", "@E 999,999.99", 10,, {|| ROUND(POSICIONE("SD1", 1, xFilial("ZM1", (cAliasTMP)->ZM1_FILIAL) + (cAliasTMP)->ZM1_NFCOM + (cAliasTMP)->ZM1_SRCOM + (cAliasTMP)->ZM1_CLIFOR + (cAliasTMP)->ZM1_LOJA, "D1_TOTAL") - ((cAliasTMP)->ZM1_SLLT * (cAliasTMP)->ZM1_PRCSOL ),2) })

    oSection5:aCell[05]:Disable()
    oSection5:aCell[06]:Disable()
    oSection5:aCell[07]:Disable()
    oSection5:aCell[08]:Disable()
    oSection5:aCell[09]:Disable()
    oSection5:aCell[10]:Disable()
    oSection5:aCell[11]:Disable()
    oSection5:aCell[12]:Disable()
    oSection5:aCell[13]:Disable()
    oSection5:aCell[14]:Disable()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Totalizador referente à sessão de TOTAIS POR PRODUTOS³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    oBreak1 := TRBreak():New(oSection5,{|| (cAliasTMP3)->FLAG}, "Totais",.F.)   
    oBreak1:lHeaderPage := .F.
    TRFunction():New(oSection5:Cell("ZM1_KGBRT") , "TZM1_KGBRT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_LTBRT") , "TZM1_LTBRT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_LTMOV") , "TZM1_LTMOV"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_LTNOTA"), "TZM1_LTNOTA", "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_LTDIF") , "TZM1_LTDIF"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_QLD022"), "TZM1_QLD022", "AVERAGE"	, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_SLKG")	 , "TZM1_SLKG"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_SLLT")	 , "TZM1_SLLT"	, "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_VLSLKG"), "TZM1_VLSLKG", 			, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_VLSLLT"), "TZM1_VLSLLT", 			, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("ZM1_VLSLTT"), "TZM1_VLSLTT", 			, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)
    TRFunction():New(oSection5:Cell("VLDIFEREN") , "TVLDIFEREN" , "SUM"		, oBreak1,,"@E 99,999,999.99",,.F.,.T.,.F.)

Return oReport





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REL043PRT   ºAutor  ³Djonata Guizzo      º Data ³18/02/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução das regras de montagem da  º±±
±±º          ³query de busca das informações\impressão das mesmas.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function REL043PRT(oReport)

Local nI		:= 0
Local nY		:= 0
Local cQryTpNota:= ""
Local aDetCpo	:= LT043TPA(MV_PAR21)
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)
Local oSection4	:= oReport:Section(1):Section(1):Section(1):Section(1)
Local oSection5	:= oReport:Section(2)
oSection3:SetHeaderPage()
//oSection3:SetHeaderSection(.F.)

If MV_PAR23 != 4
		cQryTpNota := "%AND ZM1.ZM1_TPNOTA = '" + ALLTRIM(STR(MV_PAR23)) + "'%"
Else
		CQryTpNota := "%AND ZM1.ZM1_TPNOTA >= '' AND ZM1.ZM1_TPNOTA <= 'Z' %" 
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Efetua montagem da query da sessão de FILIAIS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
BEGIN REPORT QUERY oSection1
	BEGINSQL Alias cAliasTMP
		Column ZM1_DATA   as Date
		Column ZM1_DTINI  as Date
		Column ZM1_DTFIN  as Date
		
		%noparser%
		
		SELECT DISTINCT DADOS.*
		
		FROM
			(SELECT DISTINCT ZM1.*, 
							SB1.B1_COD, 
							SB1.B1_DESC
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '2'
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)
			
			  
			UNION ALL
			
			
			SELECT DISTINCT ZM1.*, 
							SB1.B1_COD, 
							SB1.B1_DESC
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '1'
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)) DADOS
		  
		ORDER BY ZM1_FILIAL, B1_COD, ZM1_TIPO, ZM1_DATA, ZM1_NUM
		  
	EndSQL
END REPORT QUERY oSection1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Efetua montagem da query de busca das ANÁLISES DE PESAGEM³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
_cTbName :=  '%' + StrTran(oTempTable:GetRealName(),'dbo.','') +  '%'
BEGIN REPORT QUERY oSection4
	
	BEGINSQL Alias cAliasTMP2
		
		SELECT DISTINCT
				TRB.*
				
		FROM
			%Exp:_cTbName% TRB
			
		WHERE TRB.ZM4_FILIAL = %report_param:(cAliasTMP)->ZM1_FILIAL%
		  AND TRB.ZM4_NUM    = %report_param:(cAliasTMP)->ZM1_NUM%
		  
		ORDER BY TRB.ZM4_FILIAL, TRB.ZM4_NUM, TRB.ZM4_TANQUE	
	EndSQL
	
END REPORT QUERY oSection4


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Efetua montagem da query da sessão de TOTAIS POR PRODUTOS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
BEGIN REPORT QUERY oSection5
	BEGINSQL Alias cAliasTMP3
		
		%noparser%
		
		SELECT DISTINCT '1' FLAG,
						DADOS.B1_COD,
		                DADOS.B1_DESC,
		                SUM(DADOS.ZM1_KGBRT) ZM1_KGBRT,
		                SUM(DADOS.ZM1_LTBRT) ZM1_LTBRT,
		                SUM(DADOS.ZM1_LTNOTA) ZM1_LTNOTA,
		                SUM(DADOS.ZM1_LTDIF) ZM1_LTDIF,
		                SUM(DADOS.ZM1_QLD022) ZM1_QLD022,
		                SUM(DADOS.ZM1_SLKG) ZM1_SLKG,
		                SUM(DADOS.ZM1_SLLT) ZM1_SLLT,
						SUM(DADOS.ZM1_SLKG * DADOS.ZM1_PRCSOL) ZM1_VLSLKG,
						SUM(DADOS.ZM1_SLLT * DADOS.ZM1_PRCSOL) ZM1_VLSLLT,
						SUM(DADOS.ZM1_LTBRT * DADOS.ZM1_PRCSOL) ZM1_VLSLTT
						
						
		                
		FROM
			(SELECT DISTINCT SB1.B1_COD, 
							 SB1.B1_DESC,
							 (ZM1.ZM1_KGBRT * -1) ZM1_KGBRT,
		                	 (ZM1.ZM1_LTBRT * -1) ZM1_LTBRT,
		                	 (ZM1.ZM1_LTNOTA * -1) ZM1_LTNOTA,
		                	 (ZM1.ZM1_LTDIF * -1) ZM1_LTDIF,
		                	 (ZM1.ZM1_QLD022 * -1) ZM1_QLD022,
		                	 (ZM1.ZM1_SLKG * -1) ZM1_SLKG,
		                	 (ZM1.ZM1_SLLT * -1) ZM1_SLLT,
							 (ZM1.ZM1_PRCSOL * -1) ZM1_PRCSOL
							 
			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR07% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR08%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR09% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR10%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '2
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)
			
			  
			UNION ALL
			
			
			SELECT DISTINCT SB1.B1_COD, 
							SB1.B1_DESC,
							ZM1.ZM1_KGBRT,
		                	ZM1.ZM1_LTBRT,
		                	ZM1.ZM1_LTNOTA,
		                	ZM1.ZM1_LTDIF,
		                	ZM1.ZM1_QLD022,
		                	ZM1.ZM1_SLKG,
		                	ZM1.ZM1_SLLT,
							ZM1.ZM1_PRCSOL

			
			FROM
				%Table:SB1% SB1,
				%Table:ZM1% ZM1
				
			WHERE SB1.B1_FILIAL    = %xFilial:SB1%
			  AND SB1.B1_COD       = ZM1.ZM1_PROD
			  AND SB1.B1_GRUPO    >= %Exp:MV_PAR05% AND SB1.B1_GRUPO    <= %Exp:MV_PAR06%
			  AND SB1.B1_X_TPANA   = %Exp:MV_PAR21%
			  AND SB1.%NotDel%
			  
			  AND ZM1.ZM1_FILIAL  >= %Exp:MV_PAR01% AND ZM1.ZM1_FILIAL  <= %Exp:MV_PAR02%
			  AND ZM1.ZM1_PROD    >= %Exp:MV_PAR03% AND ZM1.ZM1_PROD    <= %Exp:MV_PAR04%
			  AND ZM1.ZM1_CLIFOR  >= %Exp:MV_PAR11% AND ZM1.ZM1_CLIFOR  <= %Exp:MV_PAR12%
			  AND ZM1.ZM1_LOJA    >= %Exp:MV_PAR13% AND ZM1.ZM1_LOJA    <= %Exp:MV_PAR14%
			  AND ZM1.ZM1_PLACA   >= %Exp:MV_PAR15% AND ZM1.ZM1_PLACA   <= %Exp:MV_PAR16%
			  AND ZM1.ZM1_TRANSP  >= %Exp:MV_PAR17% AND ZM1.ZM1_TRANSP  <= %Exp:MV_PAR18%
			  AND ZM1.ZM1_DATA	  >= %Exp:MV_PAR19% AND ZM1.ZM1_DATA    <= %Exp:MV_PAR20%
			  AND ZM1.ZM1_TIPO     = '1'
			  %Exp:cQryTpNota%
			  AND ZM1.%NotDel%
			  
			  AND EXISTS (SELECT * 
			              FROM %Table:ZM4% ZM4
			              WHERE ZM4.ZM4_FILIAL = ZM1.ZM1_FILIAL
			                AND ZM4.ZM4_NUM    = ZM1.ZM1_NUM
			                AND ZM4.%NotDel%)) DADOS
		
		GROUP BY B1_COD, B1_DESC
		
		ORDER BY B1_COD
		  
	EndSQL
END REPORT QUERY oSection5

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Vincula à query da primeira sessão à segunda sessão e define regra de quebra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oSection2:SetParentQuery()
oSection2:SetParentFilter({|cParam| (cAliasTMP)->ZM1_FILIAL == cParam},{|| (cAliasTMP)->ZM1_FILIAL})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Vincula à query da primeira sessão à terceira sessão e define regra de quebra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oSection3:SetParentQuery()
oSection3:SetParentFilter({|cParam| (cAliasTMP)->ZM1_FILIAL + (cAliasTMP)->B1_COD + (cAliasTMP)->ZM1_TIPO == cParam},{|| (cAliasTMP)->ZM1_FILIAL + (cAliasTMP)->B1_COD + (cAliasTMP)->ZM1_TIPO})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso seja emissão para LEITE, habilita células da sessão de PESAGENS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If MV_PAR21 == "1"
	oSection3:aCell[17]:Enable()
	oSection3:aCell[18]:Enable()
	oSection3:aCell[19]:Enable()
	
	
	oSection5:aCell[05]:Enable()
	oSection5:aCell[06]:Enable()
	oSection5:aCell[07]:Enable()
		
	oSection5:aCell[07]:Enable()
	
	If MV_PAR23 == 1
		oSection3:aCell[24]:Enable()
		oSection3:aCell[27]:Enable()
		oSection5:aCell[13]:Enable()
		oSection5:aCell[14]:Enable()
	EndIf	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Caso seja emissão para SORO, habilita células da sessão de PESAGENS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oSection3:aCell[16]:Enable()
	oSection3:aCell[18]:Enable()
	oSection3:aCell[19]:Enable()
	oSection3:aCell[20]:Enable()
	If MV_PAR23 == 1
		oSection3:aCell[24]:Enable()
	EndIf
	
	oSection5:aCell[06]:Enable()
	oSection5:aCell[07]:Enable()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Ativa célula referente há informação de SOLIDOS conforme parâmetro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If MV_PAR22 == 1
		oSection3:aCell[21]:Enable()
		oSection5:aCell[09]:Enable()
		oSection5:aCell[11]:Enable()
		If MV_PAR23 == 1
			oSection3:aCell[25]:Enable()
		EndIf
	Else
		oSection3:aCell[22]:Enable()
		oSection5:aCell[10]:Enable()
		oSection5:aCell[12]:Enable()
		oSection5:aCell[14]:Enable()

		If MV_PAR23 == 1	
			oSection3:aCell[26]:Enable()
		EndIf
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras para desabilitar as células da sessão de ANÁLISES QUALIDADE que não se referem ao TIPO DE ANÁLISE utilizada na emissão do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
For nI := 1 To Len(oSection4:aCell)
	If "TRB_" $ ALLTRIM(oSection4:aCell[nI]:cName)
		lAchou := .F.
		For nY := 1 To Len(aDetCpo)
			If ALLTRIM(oSection4:aCell[nI]:cName) $ ALLTRIM(aDetCpo[nY][3])
				lAchou := .T.
				exit
			EndIf
		Next nY
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso o campo vinculado à célula atual não está na relação de campos do tipo da análise, desativa à mesma³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !lAchou
			oSection4:aCell[nI]:Disable()
		EndIf
	EndIf
Next nI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Seta regra de contador do processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oReport:SetMeter((cAliasTMP)->(RECCOUNT()))


//oSection4:Disable()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa a impressão das sessões do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oSection1:Print()



oReport:SkipLine(3)
oSection5:Print()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SCHEDDEF  ºAutor  ³Djonata Guizzo      º Data ³ 18/02/2021  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por disponibilizar a utilização do rela- º±±
±±º          ³tório na funcionalidade de Schedule.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SCHEDDEF()

Local aParam

aParam := {"R", "LTREL043LT", "", {}, "Análises de Qualidade"}

Return aParam



Static Function LT043TPA(cTpAna)

Local aDetQld	:= {}
Local _cCpos    := ''
Local _cRevisa  := ''
Local _cLeite   := PadR('01010001',TamSx3('B1_COD')[1],/*cFill*/)
Local _cSoro    := PadR('01010004',TamSx3('B1_COD')[1],/*cFill*/)
Default cTpAna	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição do array com os conjuntos de tipos de análises de qualidade³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If cTpAna == "" .OR. cTpAna == "1"
    dbSelectArea('ZA5')
    ZA5->(dbSetOrder(1)) 
    ZA5->(dbGoTop())
    If ZA5->(dbSeek(xFilial('ZA5')+_cLeite))
        While ZA5->(!Eof()) .And. ZA5->ZA5_FILIAL+ZA5->ZA5_PROD == xFilial('ZA5')+_cLeite
            _cRevisa := ZA5->ZA5_REVISA
            
            ZA5->(DbSkip())
        EndDo
    EndIf

    dbSelectArea('ZA1')
    ZA1->(dbSetOrder(1)) 
    ZA1->(dbGoTop())
    If ZA1->(dbSeek(xFilial('ZA1')+_cLeite+_cRevisa))
        While ZA1->(!Eof()) .And. ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA == xFilial('ZA1')+_cLeite+_cRevisa
            _cCpos += 'TRB_'+ZA1->ZA1_CARACT+'/'
            
            ZA1->(DbSkip())
        EndDo
    EndIf

	AADD(aDetQld, {"1", "Leite Crú"		, _cCpos})
EndIf

_cCpos := ''

If cTpAna == "" .OR. cTpAna == "2"

    dbSelectArea('ZA5')
    ZA5->(dbSetOrder(1)) 
    ZA5->(dbGoTop())
    If ZA5->(dbSeek(xFilial('ZA5')+_cSoro))
        While ZA5->(!Eof()) .And. ZA5->ZA5_FILIAL+ZA5->ZA5_PROD == xFilial('ZA5')+_cSoro
            _cRevisa := ZA5->ZA5_REVISA
            
            ZA5->(DbSkip())
        EndDo
    EndIf

    dbSelectArea('ZA1')
    ZA1->(dbSetOrder(1)) 
    ZA1->(dbGoTop())
    If ZA1->(dbSeek(xFilial('ZA1')+_cSoro+_cRevisa))
        While ZA1->(!Eof()) .And. ZA1->ZA1_FILIAL+ZA1->ZA1_PROD+ZA1->ZA1_REVISA == xFilial('ZA1')+_cSoro+_cRevisa
            _cCpos += 'TRB_'+ZA1->ZA1_CARACT+'/'
            
            ZA1->(DbSkip())
        EndDo
    EndIf
	AADD(aDetQld, {"2", "Soro In Natura", _cCpos})
EndIf

Return aDetQld
