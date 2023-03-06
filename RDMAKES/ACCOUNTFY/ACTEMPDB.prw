#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} ACTEMPDB
    Classe criação da tabela temporaria
    @type  User Function
    @author Fernando Oliveira Feres
    @since 26/10/2020
    @version 1.0
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Class ACTEMPDB

    method new() constructor
    method criaTemp()
    method logNum()
    method DropTemp() 

    data dDataDe  as Date
    data dDataAte as Date
    data lClean   as Logical
    data cFil     as String
    data cLayout  as String

endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author Fernando Oliveira Feres
@since   26/10/2020
@version 1.0
@param   dDataDe , Date , Data inicial de extraï¿½ï¿½o
@param   dDataAte ,Date, Data Final de extraï¿½ï¿½o
@param   lClean , Logico , variavel de control referente a limpeza da tabela
@param   cLayout , Carater , variavel referente ao codigo do layout
@return  object, self
/*/
//-------------------------------------------------------------------

method new(cFil,cLayout,lClean) class ACTEMPDB
    
    self:lClean     := lClean
    self:cLayout    := cLayout
    self:cFil       := cFil

return 

//-------------------------------------------------------------------
/*/{Protheus.doc} CriaTemp
Método para criar a tabela temporaria
@author Fernando Oliveira Feres
@since   26/10/2020
@version 1.0
/*/
//-------------------------------------------------------------------
method criaTemp(cLayout, cCard, cFiliais, cData, lClean) CLASS ACTEMPDB

Local cQry       as character
Local lRet       as logical
Local cTabela    as character
Local nRec       as numeric
Local aCpos      as character
Local aSelect    as character
Local aCampos    as character
Local aCposCab    as character
Local aCposInt   as character
Local cId        as character
Local aCampId    as array
Local cNameIndex as character
Local nI
Local cDB        := TcGetDB()
Local cFilexp   := cFiliais
Local i

Local cDic      := "SX3"
Local cAliasTmp := "SX3TST"
Local cFiltro   := ""

Private cNomeBlock  := ""
private cAliasZKU   := GetNextAlias()
private cAliasCT2   := GetNextAlias()
private cAliasTAB   := GetNextAlias()

lRet     := .T.
cTabela  := ""
nRec     := 0
aCpos    := ""
aCposCab := ""
aSelect  := {}
aHeader  := {}
aCampos  := ""
aCposInt := ""
aSX3     := {}
aSX3TST  := {}
aCampId  := {}
cId      := ""

FWLogMsg("INFO", , "ACTEMPDB", , , , "---> TABELA TEMPORARIA INICIO: " + TIME(), , ,)

Begin transaction 

    //Nome de tabela sugerido para criação da tmp
    cTabela := alltrim(ZKT->ZKT_NOMTEM) + cEmpAnt

    cId := Self:logNum() 


    if !lockbyname(cTabela)
        Msginfo("O processamento já está em andamento em outra instância e Não poderia existir a concorrência.")
        lret := .f.
    endif

    //Verifica se existe a tabela temporï¿½ria 
    
    If cDB == "ORACLE" .OR. cDB == "POSTGRES"
        beginSql alias cAliasZKU               
            SELECT *
            FROM %table:ZKU% ZKU
            WHERE ZKU.ZKU_FILIAL = %xFilial:ZKU%
            AND ZKU.ZKU_CODIGO = %Exp:cLayout%
            AND ZKU.%notDel%
        endsql
    else
        beginSql alias cAliasZKU               
            SELECT *
            FROM %table:ZKU% ZKU (NOLOCK)
            WHERE ZKU.ZKU_FILIAL = %xFilial:ZKU%
            AND ZKU.ZKU_CODIGO = %Exp:cLayout%
            AND ZKU.%notDel%
        endsql
    Endif        

    cFiltro := "X3_ARQUIVO == 'CT1' .OR. " 
    cFiltro += "X3_ARQUIVO == 'CT2' .OR. " 
    cFiltro += "X3_ARQUIVO == 'CTT'" 

    OpenSXs(NIL, NIL, NIL, NIL, NIL, cAliasTmp, cDic, NIL, .F.)
    (cAliasTmp)->(DbSetFilter({|| &(cFiltro)}, cFiltro))
    (cAliasTmp)->(DbGoTop())

    While ! (cAliasTmp)->(Eof())
                
            Aadd(aHeader, {&("(cAliasTmp)->X3_TITULO"),;
                &("(cAliasTmp)->X3_CAMPO"),;
                &("(cAliasTmp)->X3_TIPO"),;
                &("(cAliasTmp)->X3_TAMANHO"),;
                &("(cAliasTmp)->X3_DECIMAL"),;  
                &("(cAliasTmp)->X3_CONTEXT"),;
                ".T."})    
        (cAliasTmp)->(dbSkip())

    EndDo

    //Verifica se existe o layout de depara
    if (cAliasZKU)->(!Eof())         
        while (cAliasZKU)->(!Eof())
            dbSelectArea("SX3TST")
            SX3TST->( dbsetorder(2) )
            SX3TST->( dbgotop() )
            SX3TST->( dbSeek( alltrim((cAliasZKU)->ZKU_CPPROT) ) )
            
            if SX3TST->X3_ARQUIVO == "CT1" .or. SX3TST->X3_ARQUIVO == "CT2" .or. SX3TST->X3_ARQUIVO == "CTT"
                If SX3TST->X3_CONTEXT <> "V"
                    aAdd(aSX3, {SX3TST->X3_CAMPO,SX3TST->X3_TIPO,SX3TST->X3_TAMANHO,SX3TST->X3_DECIMAL})  
                    aCpos += alltrim(SX3TST->X3_CAMPO) + ","                
                EndIf
            Endif            
            (cAliasZKU)->(dbSkip())
        EndDo
    else
        ///Caso não exista o parametro de layout, o sistema irá considerar todas as colunas da CT2 e CT1
      /* DbSelectArea("SX3TST")
        SX3TST->(DbSetOrder(1))
        SX3TST->(DbSeek("CT1"))
        While !Eof() .and. SX3TST->X3_ARQUIVO == "CT1"
            If SX3TST->X3_CONTEXT <> "V"
                aAdd(aSX3, {SX3TST->X3_CAMPO,SX3TST->X3_TIPO,SX3TST->X3_TAMANHO,SX3TST->X3_DECIMAL})  
                aCpos += alltrim(SX3TST->X3_CAMPO) + "," 
            EndIf
            SX3TST->(dbSkip())
        EndDo 

        SX3TST->(dbGoTop())
        SX3TST->(DbSeek("CT2"))
        While !Eof() .and. SX3TST->X3_ARQUIVO == "CT2"
            If SX3TST->X3_CONTEXT <> "V"
                aAdd(aSX3, {SX3TST->X3_CAMPO,SX3TST->X3_TIPO,SX3TST->X3_TAMANHO,SX3TST->X3_DECIMAL})  
                aCpos += alltrim(SX3TST->X3_CAMPO) + "," 
            EndIf
            SX3TST->(dbSkip())
        EndDo      

        //Inclusao do campo CTT_CUSTO
        aAdd(aSX3, {"CTT_CUSTO","C",9,0})  
        aCpos += "CTT_CUSTO ," */

        MsgAlert ("Não foi definido o layout de importação !")
    endif

    if Len(aSX3) > 0
        //Verifica se não existe a tabela temporária criada
        TCDelFile(cTabela)
        if TCCanOpen(cTabela)
            if !TCDelFile(cTabela)
                cQuery := "DROP TABLE "+cTabela
                TCSqlExec( cQuery )    
            EndIf
        EndIf
        if !TCCanOpen(cTabela)
            cQry := "Create Table " + cTabela
            cQry += " ( "

            For nI := 1 To Len(aSX3)
                If !Empty( aSX3[nI][2] )
                    Do Case
                        Case (aSX3[nI][2] == "C")
                            cQry += "[" + STRTRAN(alltrim(aSX3[nI][1])," ", "_") + "] VARCHAR(" + cValToChar(aSX3[nI][3]) + ") NULL, "
                        Case (aSX3[nI][2] == "N")
                            cQry += "[" + STRTRAN(alltrim(aSX3[nI][1])," ", "_") + "]  DECIMAL(" + cValToChar(aSX3[nI][3])+","+cValToChar(aSX3[nI][4]) + ") NULL, "
                        Case (aSX3[nI][2] == "D")
                            cQry += "["+ STRTRAN(alltrim(aSX3[nI][1])," ", "_") + "] VARCHAR(8) NULL, "
                        Case (aSX3[nI][2] == "L")
                            cQry += "["+ STRTRAN(alltrim(aSX3[nI][1])," ", "_") + "] VARCHAR(1) NULL, "
                        Case (aSX3[nI][2] == "M")
                            cQry += "["+ STRTRAN(alltrim(aSX3[nI][1])," ", "_") + "] VARBINARY(MAX) NULL, "
                    EndCase
                EndIf            
            Next nI

           cQry += " TMPRECNO VARCHAR(10) NULL, ID_LOG VARCHAR(6) NULL, FLAG int, DC VARCHAR(1) )"  
            
            If TCSqlExec( cQry ) <> 0
                UserException("Erro ao criar a tabela" + CRLF + TCSqlError())   
                FWLogMsg("INFO", , "ACTEMPDB", , , , "---> ERRO AO CRIAR TABELA: " + TcSqlError(), , ,)
                DisarmTransaction()                
                lret := .f.                   
            EndIf

            cNameIndex := cTabela + "_idx"
            cQry := "CREATE INDEX "+ cNameIndex + " ON " + cTabela + " (TMPRECNO, ID_LOG, FLAG)"

            If TCSqlExec( cQry ) <> 0
                UserException("Erro ao criar indice" + CRLF + TCSqlError())   
                FWLogMsg("INFO", , "ACTEMPDB", , , , "---> ERRO AO CRIAR INDICE: " + TcSqlError(), , ,)
                DisarmTransaction()                
                lret := .f.        
            EndIf
        endif

        //Gravação na tabela Log
        dbSelectArea("ZKV")
        ZKV->(dbSetOrder(2))
        //processamento da primeira barra de progresso
        //oProcess:IncRegua1("Processando as informaçães")                
        
        if ZKV->(!dbSeek( xFilial("ZKV") + cId))
            If RecLock("ZKV", .T.)
                ZKV->ZKV_FILIAL  := xFilial("ZKV")
                ZKV->ZKV_ID      := cId
                ZKV->ZKV_LAYOUT  := cLayout
                ZKV->ZKV_DATAIN := date()
                ZKV->ZKV_HORAIN := time()
                ZKV->ZKV_ETAPA   := "1"
                ZKV->ZKV_USER    := UsrRetName(__cuserID)
                ZKV->ZKV_CARD    := cCard  
                ZKV->(MsUnLock())
            Endif
        endif

       cFilExp :=  substr(cFilexp,1,(len(cFilexp)-1))
       //cFilExp :=  FormatIn( cFilExp,"/")

        //Insere as informações da query do layout Debito
        If cDB == "ORACLE" .OR. cDB == "POSTGRES"
            cQry := "INSERT INTO " + cTabela + " (" + aCpos + " TMPRECNO, ID_LOG, FLAG, DC ) " + CRLF
            cQry += " (SELECT " + aCpos + " CT2.R_E_C_N_O_ , '" + cId + "', 0, 'D' "
            cQry += " FROM " + RetSqlName("CT1") + " CT1 "
            cQry += " INNER JOIN " + RetSqlName("CT2") + " CT2 "
            cQry += " ON CT2.CT2_DEBITO = CT1.CT1_CONTA "
            if !Empty(cFilExp)
                cQry += " AND CT2.CT2_FILIAL IN " + cFilExp  + " "
            endif
            cQry += " AND CT2.CT2_TPSALD = '1' "
            cQry += " AND SUBSTR(CT2.CT2_DATA, 1, 6) = '" + cData + "' "
            cQry += " AND CT2.D_E_L_E_T_ <> '*'"
            cQry += " LEFT JOIN " + RetSqlName("CTT") + " CTT "
            cQry += " ON CTT.CTT_CUSTO = CT2.CT2_CCD "
            cQry += " AND CTT.CTT_FILIAL = '" + SUBSTR(cFilExp,1,5)  + "' "
            cQry += " AND CTT.D_E_L_E_T_ <> '*' "
            cQry += " WHERE CT1.CT1_FILIAL = '" + SUBSTR(cFilExp,1,5)  + "' "
            cQry += " AND CT1.D_E_L_E_T_ <> '*')"
        else
            cQry := "INSERT INTO " + cTabela + " (" + aCpos + " TMPRECNO, ID_LOG, FLAG, DC ) " + CRLF
            cQry += " (SELECT " + aCpos + " CT2.R_E_C_N_O_ , '" + cId + "', 0, 'D' "
            cQry += " FROM " + RetSqlName("CT1") + " CT1 (NOLOCK)"
            cQry += " INNER JOIN " + RetSqlName("CT2") + " CT2 (NOLOCK) "
            cQry += " ON CT2.CT2_DEBITO = CT1.CT1_CONTA "
            if !Empty(cFilExp)
                cQry += " AND CT2.CT2_FILIAL = '" + cFilExp  + "' "
            endif
            cQry += " AND CT2.CT2_TPSALD = '1' "
            cQry += " AND SUBSTRING(CT2.CT2_DATA, 1, 6) = '" + cData + "' "
            cQry += " AND CT2.D_E_L_E_T_ <> '*'"
            cQry += " LEFT JOIN " + RetSqlName("CTT") + " CTT (NOLOCK)"
            cQry += " ON CTT.CTT_CUSTO = CT2.CT2_CCD "
            cQry += " AND CTT.CTT_FILIAL = '" + SUBSTR(cFilExp,1,5)  + "' "
            cQry += " AND CTT.D_E_L_E_T_ <> '*' "
            cQry += " WHERE CT1.CT1_FILIAL = '" + SUBSTR(cFilExp,1,5)  + "' "
            cQry += " AND CT1.D_E_L_E_T_ <> '*')" 
        Endif           
        
        If TCSqlExec( cQry ) <> 0
            UserException("Erro ao criar a tabela" + CRLF + TCSqlError())   
            FWLogMsg("INFO", , "ACTEMPDB", , , , "---> ERRO AO CRIAR TABELA: " + TcSqlError(), , ,)
            DisarmTransaction()
            lret := .f.       
        EndIf

        //Insere as informações da query do layout Credito
        If cDB == "ORACLE" .OR. cDB == "POSTGRES"
            cQry := "INSERT INTO " + cTabela + " (" + aCpos + " TMPRECNO, ID_LOG, FLAG, DC ) " + CRLF
            cQry += " (SELECT " + aCpos + " CT2.R_E_C_N_O_ , '" + cId + "', 0, 'C' "
            cQry += " FROM " + RetSqlName("CT1") + " CT1 "
            cQry += " INNER JOIN " + RetSqlName("CT2") + " CT2 "
            cQry += " ON CT2.CT2_CREDIT = CT1.CT1_CONTA "
            if !Empty(cFilExp)
                cQry += " AND CT2.CT2_FILIAL = '" + cFilExp  + "' "
            endif
            cQry += " AND CT2.CT2_TPSALD = '1' "
            cQry += " AND SUBSTR(CT2.CT2_DATA, 1, 6) = '" + cData + "' "
            cQry += " AND CT2.D_E_L_E_T_ <> '*'"
            cQry += " LEFT JOIN " + RetSqlName("CTT") + " CTT "
            cQry += " ON CTT.CTT_CUSTO = CT2.CT2_CCC "
            cQry += " AND CTT.CTT_FILIAL = '" + SUBSTR(cFilExp,1,5)  + "' "
            cQry += " AND CTT.D_E_L_E_T_ <> '*' "
            cQry += " WHERE CT1.CT1_FILIAL = '" + SUBSTR(cFilExp,1,5)  + "' "
            cQry += " AND CT1.D_E_L_E_T_ <> '*')"       
        Else
            cQry := "INSERT INTO " + cTabela + " (" + aCpos + " TMPRECNO, ID_LOG, FLAG, DC ) " + CRLF
            cQry += " (SELECT " + aCpos + " CT2.R_E_C_N_O_ , '" + cId + "', 0, 'C' "
            cQry += " FROM " + RetSqlName("CT1") + " CT1 (NOLOCK)"
            cQry += " INNER JOIN " + RetSqlName("CT2") + " CT2 (NOLOCK) "
            cQry += " ON CT2.CT2_CREDIT = CT1.CT1_CONTA "
            if !Empty(cFilExp)
                cQry += " AND CT2.CT2_FILIAL = '" + cFilExp  + "' "
            endif
            cQry += " AND CT2.CT2_TPSALD = '1' "
            cQry += " AND SUBSTRING(CT2.CT2_DATA, 1, 6) = '" + cData + "' "
            cQry += " AND CT2.D_E_L_E_T_ <> '*'"
            cQry += " LEFT JOIN " + RetSqlName("CTT") + " CTT (NOLOCK)"
            cQry += " ON CTT.CTT_CUSTO = CT2.CT2_CCC "
            cQry += " AND CTT.CTT_FILIAL = '" + SUBSTR(cFilEXp,1,5)  + "' "
            cQry += " AND CTT.D_E_L_E_T_ <> '*' "
            cQry += " WHERE CT1.CT1_FILIAL = '" + SUBSTR(cFilExp,1,5)  + "' "
            cQry += " AND CT1.D_E_L_E_T_ <> '*')"
        Endif

        If TCSqlExec( cQry ) <> 0
            UserException("Erro ao criar a tabela" + CRLF + TCSqlError())   
            FWLogMsg("INFO", , "ACTEMPDB", , , , "---> ERRO AO CRIAR TABELA: " + TcSqlError(), , ,)
            DisarmTransaction()
            lret := .f.      
        EndIf
    else
        MsgAlert("Não existem campos de integração!","TOTVS")
        DisarmTransaction()
        lRet := .F.        
    endif
    unlockbyname(cTabela)   
    
End Transaction

Begin Transaction
    
    //atualiza data e hora final da tabela de log.    
    dbSelectArea("ZKV")
    ZKV->(dbSetOrder(2))
    //oProcess:IncRegua2("Processando as informações")                                   
    if ZKV->(dbSeek( xFilial("ZKV") + cId))
        If RecLock("ZKV", .F.)
            ZKV->ZKV_DATAFI := date()
            ZKV->ZKV_HORAFI := time()
            ZKV->ZKV_USER    := UsrRetName(__cuserID)   
            ZKV->(MsUnLock())
        Endif    
    endif                    
    

End Transaction

FWLogMsg("INFO", , "ACTEMPDB", , , , "---> TABELA TEMPORARIA TÉRMINO: " + TIME(), , ,)

Return cId


method logNum() CLASS ACTEMPDB
    Local cQuery := ""
    Local cRet := ""
    Local cAlias := GetNextAlias()
    Local cDB := TcGetDB()

    If cDB == "ORACLE" .OR. cDB == "POSTGRES"
        cQuery:= "SELECT MAX(ZKV_ID) AS ZKV_ID FROM "+ RetSqlName("ZKV") + " ZKV "
    Else
        cQuery:= "SELECT MAX(ZKV_ID) AS ZKV_ID FROM "+ RetSqlName("ZKV") + " ZKV (NOLOCK) "
    Endif
    dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T. )

    If ! Empty((cAlias)->ZKV_ID)

        cRet:= Soma1((cAlias)->ZKV_ID)

    Else
        cRet:= "000001"

    Endif 

return cRet
