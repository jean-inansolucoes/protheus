#INCLUDE "PROTHEUS.CH"

User Function UPDBIRFER()

Local aButtons  := {}
Local aSays     := {}
Local cMsg      := ""
Local lContinua := .F.
Local nOpcA     := 0

Private aCodFol := {}
Private aLog    := {}
Private aTitle  := {}
Private cPerg   := "UPDBFER"

//Carrega o array aCodFol para verificar o cadastro de verbas x Ids de cálculo
Fp_CodFol(@aCodFol, cFilAnt, .F., .F.)

//Verifica se existe o cadastro da verba de Id 1562 e se a verba foi preenchida
If Len(aCodFol) >= 1562
	lContinua := !Empty( aCodFol[1562,1] )
EndIf 

//Se não existir cadastro da verba para o Id 1562, aborta o processamento da rotina
If !lContinua
	cMsg := OemToAnsi( "Para executar essa rotina é obrigatório o cadastro da verba (Tipo 3 - Base Provento) do seguinte identificador:" ) + CRLF
	cMsg += OemToAnsi( "1562 - Base de IRRF Férias s/ dedução" )
	MsgInfo( cMsg )
	Return()
EndIf

//Cria as perguntas no dicionário SX1 para filtro do processamento
fCriaSX1()

aAdd(aSays,OemToAnsi( "Este programa tem como objetivo gerar a verba do Id 1562 - Base de IRRF Férias s/" ))
aAdd(aSays,OemToAnsi( "dedução no movimento acumulado (tabela SRD) dos funcionários de acordo com as" ))
aAdd(aSays,OemToAnsi( "verbas das férias com incidência de IR para a geração correta do evento S-1200" ))
aAdd(aSays,OemToAnsi( "do eSocial." ))
aAdd(aSays,OemToAnsi( "Obs.: para a geração da verba no movimento mensal (tabelas SRC) deverá ser efetuado"))
aAdd(aSays,OemToAnsi( "o recálculo da folha."))

aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpcA := 1,IF(gpconfOK(), FechaBatch(), nOpcA := 0 ) }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

//Abre a tela de processamento
FormBatch( "Geração da Base de IRRF Férias s/ dedução", aSays, aButtons )

//Efetua o processamento de geração
If nOpcA == 1
    Aadd( aTitle, OemToAnsi( "Funcionários que tiveram a verba de Id 1562 gerada:" ) )
    Aadd( aLog, {} )
    ProcGpe( {|lEnd| fProcessa()},,,.T. )
    fMakeLog(aLog,aTitle,,,"UPDBIRFER",OemToAnsi("Log de Ocorrências"),"M","P",,.F.)
EndIf

Return

/*/{Protheus.doc} fProcessa
Função que efetua o processamento para a geração do Id 1562
/*/
Static Function fProcessa()

Local cAliasQry := GetNextAlias()
Local cFilOld   := cFilAnt
Local cJoinRDRV	:= "% " + FWJoinFilial( "SRD", "SRV" ) + " %"
Local cWhere    := ""
Local lNovo     := .F.

Pergunte( cPerg, .F. )
MakeSqlExpr( cPerg )

//Filial
If !Empty(mv_par01)
    cWhere += mv_par01
EndIf

//Matricula
If !Empty(mv_par02)
	cWhere += Iif(!Empty(cWhere)," AND ","")
	cWhere += mv_par02
EndIf

//Periodo inicial
cWhere += Iif(!Empty(cWhere)," AND ","")
cWhere += "RD_DATARQ >= '" + mv_par03 + "' "

//Periodo final
cWhere += "AND RD_DATARQ <= '" + mv_par04 + "' "

//Filtro para somente trazer verbas que existam no cálculo de férias (SRH)
cWhere += "AND EXISTS( SELECT SRR.RR_FILIAL, SRR.RR_MAT, SRR.RR_PD FROM " + RetSqlName('SRR') + " SRR WHERE SRR.RR_FILIAL = SRD.RD_FILIAL AND SRR.RR_MAT = SRD.RD_MAT AND SRR.RR_DATAPAG = SRD.RD_DATPGT AND SRR.RR_PD = SRD.RD_PD AND SRR.RR_ROTEIR = 'FER' AND SRR.D_E_L_E_T_ = ' ' )"

//Prepara a variável para uso no BeginSql
cWhere := "%" + cWhere + "%"

//Processa a query e cria a tabela temporária com os resultados
BeginSql alias cAliasQry
	SELECT SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_CC, SRD.RD_DATARQ, SRD.RD_SEMANA, SRD.RD_DATPGT, MIN(SRD.RD_SEQ) AS RD_SEQ, SUM(SRD.RD_VALOR) AS RD_VALOR
    FROM %table:SRD% SRD
    INNER JOIN %table:SRV% SRV
    ON	%exp:cJoinRDRV% AND
        SRV.RV_COD = SRD.RD_PD AND
        SRV.%notDel%
	WHERE %exp:cWhere% AND
			SRV.RV_TIPOCOD = '1' AND
            SRD.RD_IR = 'S' AND
            SRD.%notDel%
	GROUP BY SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_CC, SRD.RD_DATARQ, SRD.RD_SEMANA, SRD.RD_DATPGT
EndSql 

While (cAliasQry)->( !EoF() )
    //Carrega o array aCodFol para verificar o cadastro de verbas x Ids de cálculo
    If (cAliasQry)->RD_FILIAL != cFilOld
        cFilOld := (cAliasQry)->RD_FILIAL
        RstaCodFol()
        Fp_CodFol(@aCodFol, (cAliasQry)->RD_FILIAL, .F., .F.)  
    EndIf
    
    //Ordena a tabela SRA pela ordem 1 - RA_FILIAL+RA_MAT
    SRA->( dbSetOrder(1) )
    //Posiciona na tabela SRA
    SRA->( dbSeek( (cAliasQry)->RD_FILIAL + (cAliasQry)->RD_MAT ) )
    
    //Ordena a tabela SRD pela ordem 4 - RD_FILIAL+RD_MAT+DTOS(RD_DATPGT)+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
    SRD->( dbSetOrder(4) )
    //Verifica se possui a verba de ID 0164 na competência com a data de pagamento pois significará que essas férias vieram do mês anterior,
    //não sendo necessário a geração da verba de ID 1562 pois a verba de ID 0164 já irá deduzir os proventos de férias.
    If SRD->( dbSeek( (cAliasQry)->RD_FILIAL + (cAliasQry)->RD_MAT + (cAliasQry)->RD_DATPGT + aCodFol[164, 1] + (cAliasQry)->RD_SEMANA ) )
        While SRD->( !EoF() .And. SRD->RD_FILIAL + SRD->RD_MAT + dToS(SRD->RD_DATPGT) + SRD->RD_PD + SRD->RD_SEMANA == (cAliasQry)->RD_FILIAL + (cAliasQry)->RD_MAT + (cAliasQry)->RD_DATPGT + aCodFol[164, 1] + (cAliasQry)->RD_SEMANA )
            //Se a verba do Id 0164 encontrada estiver no mesmo período da verba de férias, pula para o próximo registro 
            If SRD->RD_DATARQ == (cAliasQry)->RD_DATARQ
                //Pula para o próximo registro
                (cAliasQry)->( dbSkip() )
                //Volta para o início do laço para recomeçar a validação
                Loop
            EndIf
            SRD->( dbSkip() )
        EndDo
    EndIf

    //Ordena a tabela SRD pela ordem 1 - RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
    SRD->( dbSetOrder(1) )
    //Verifica se a verba de Id 1562 já exista na tabela SRD
    lNovo := SRD->( !dbSeek( (cAliasQry)->RD_FILIAL + (cAliasQry)->RD_MAT + (cAliasQry)->RD_DATARQ + aCodFol[1562, 1] + (cAliasQry)->RD_SEMANA + (cAliasQry)->RD_SEQ + (cAliasQry)->RD_CC ) )

    //Trava o registro na SRD para edição
    If SRD->( RecLock("SRD", lNovo) )
        //Se for inclusão, grava todos campos da SRD
        //Se for alteração, apenas altera o valor do registro
        If lNovo
            SRD->RD_FILIAL  := (cAliasQry)->RD_FILIAL
            SRD->RD_MAT     := (cAliasQry)->RD_MAT
            SRD->RD_CC      := (cAliasQry)->RD_CC
            SRD->RD_PD      := aCodFol[1562, 1]
            SRD->RD_TIPO1   := "V"
            SRD->RD_DATARQ  := (cAliasQry)->RD_DATARQ
            SRD->RD_DATPGT  := sToD((cAliasQry)->RD_DATPGT)
            SRD->RD_SEQ     := (cAliasQry)->RD_SEQ
            SRD->RD_TIPO2   := "C"
            SRD->RD_MES     := SubStr( (cAliasQry)->RD_DATARQ, 5, 2 )
            SRD->RD_STATUS  := "A"
            SRD->RD_INSS    := "N"
            SRD->RD_IR      := "N"
            SRD->RD_FGTS    := "N"
            SRD->RD_PROCES  := SRA->RA_PROCES
            SRD->RD_PERIODO := (cAliasQry)->RD_DATARQ
            SRD->RD_SEMANA  := (cAliasQry)->RD_SEMANA
            SRD->RD_ROTEIR  := "FOL"
            SRD->RD_DTREF   := sToD((cAliasQry)->RD_DATPGT)
        EndIf
        SRD->RD_VALOR   := (cAliasQry)->RD_VALOR
        
        //Adiciona no log de ocorrências
        aAdd( aLog[1], "Filial: " + (cAliasQry)->RD_FILIAL + "  -  Matrícula: " + (cAliasQry)->RD_MAT + "  -  Período: " + (cAliasQry)->RD_DATARQ + "  -  Valor: R$ " + cValToChar( Transform( (cAliasQry)->RD_VALOR, "@E 99,999,999,999.99" ) ) )

        //Libera o registro da SRD
        SRD->( MsUnlock() )
    EndIf
    
    //Pula para o próximo registro
    (cAliasQry)->( dbSkip() )
EndDo

//Fecha a tabela temporária da query
(cAliasQry)->( dbCloseArea() )

Return

/*/{Protheus.doc} fCriaSX1
Função que cria as perguntas que serão utilizdas na rotina
/*/
Static Function fCriaSX1()

Local aHelpPor := {}

AAdd( aHelpPor, "Informe o período inicial para a" )
AAdd( aHelpPor, "geração da verba de base." )
EngHLP117( "P"+".UPDBFER03.", aHelpPor, aHelpPor, aHelpPor )

aHelpPor := {}
AAdd( aHelpPor, "Informe o período final para a" )
AAdd( aHelpPor, "geração da verba de base." )
EngHLP117( "P"+".UPDBFER04.", aHelpPor, aHelpPor, aHelpPor )

//			<cGrupo>	, <cOrdem>	, <cPergunt>				, <cPerSpa>	, <cPerEng>		, <cVar>	,<cTipo>	,<nTamanho>	,<nDecimal>		, <nPresel>		,<cGSC>	,<cValid>							,<cF3>		,<cGrpSxg>	,<cPyme>	,<cVar01>			,<cDef01> 		,<cDefSpa1>		,<cDefEng1>		,<cCnt01>		,<cDef02>				,<cDefSpa2>				,<cDefEng2>			,<cDef03>	, <cDefSpa3>	,<cDefEng3>		, <cDef04>	,<cDefSpa4>		, <cDefEng4>	,<cDef05>		, <cDefSpa5>	, <cDefEng5>	, <aHelpPor>, <aHelpEng>	, <aHelpSpa>	, <cHelp> )
EngSX1117( cPerg 	    , "01" 		,"Filial ?"			 		, ""		, ""		 	, "MV_CH1" 	, "C" 		, 99		,0				, 0	   			, "R" 	, ""								, "XM0" 	, ""		, "S" 		, "MV_PAR01" 		, "" 	   		, "" 			, "" 			, "RD_FILIAL"	, "" 					, ""					, "" 	 			, "" 		, "" 			, "" 			, "" 		, ""	 		, ""	  	 	, ""			, "" 		 	, ""	  		, {}	   	, {}   			, {} 			, ".RHFILDE."	)
EngSX1117( cPerg 	    , "02" 		,"Matrícula ?"	 			, "" 		, ""			, "MV_CH2"	, "C" 		, 99   		,0	  			, 0	  	 		, "R" 	, ""								, "SRA" 	, "" 		, "S" 		, "MV_PAR02" 		, "" 	  		, "" 			, "" 			, "RD_MAT"		, "" 					, ""					, "" 	 			, "" 		, "" 			, "" 			, "" 	 	, ""	  		, ""	   		, ""		  	, "" 		 	, ""	  		, {}	   	, {} 			, {} 			, ".RHMATD."	)
EngSX1117( cPerg 	    , "03"		,"Período inicial? (AAAAMM)", ""		, ""	        , 'MV_CH3'	, 'C'		, 6			,0				, 0				, 'G'	, 'NaoVazio()'						, ""		, ""		, "S"		, "MV_PAR03"		, "" 	   		, ""			, "" 	   		, ""			, "" 					, "" 					, "" 	 			, ""	  	, ""	   		, ""		  	, "" 		, ""	  		, ""	   		, "" 			, "" 			, ""	  		, {}	   	, {} 			, {} 			, ".UPDBFER03."	)
EngSX1117( cPerg 	    , "04"		,"Período final? (AAAAMM)"	, ""		, ""	        , 'MV_CH4'	, 'C'		, 6			,0				, 0				, 'G'	, 'NaoVazio()'						, ""		, ""		, "S"		, "MV_PAR04"		, "" 			, ""			, "" 	   		, ""			, "" 					, "" 					, "" 	 			, ""	  	, ""	   		, ""		  	, "" 		, ""	  		, ""	   		, "" 			, "" 			, ""	  		, {}	   	, {} 			, {} 			, ".UPDBFER04."	)

Return