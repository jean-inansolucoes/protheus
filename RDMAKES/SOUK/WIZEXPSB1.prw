#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
 
User Function WIZEXSB1()
    Local cNomWiz		:= FunName()
    Local cTitObj1		:= ""
    Local cTitObj2		:= ""
    Local aTxtApre		:= {}
    Local aPaineis		:= {}
    Local aArq			:= {}
    Local aWizard		:= {}
    Local aItens1		:= {}
    Local lRet			:= .T.
    Local nPos
    Local cMsg			:= ""
    Local nX
    Local cOrigem 		:= ""
    Local cDestino 		:= ""
    Local cArquivo 		:= ""
    Local cGrupo 		:= ""
    Local cNCM 			:= ""
    Local cTPDe 		:= ""
    Local cTPAte 		:= ""
    Local cPrdDe 		:= ""
    Local cPrdAte 		:= ""
   
 
    /*
    Função XFUNWizard
 
    Parametros:
    aTxtApre - Array com o cabecalho do Wizard
    aPaineis - Array com os paineis do Wizard
    cNomeWizard - Nome do arquivo de Wizard
    cNomeAnt - Nome do arquivo anterior do Wizard caso tenha mudado de nome
 
    Retorno:
    .T. Para validacao OK
    .F. Para validacao NAO OK
 
    Os parametros para o array aPaineis são:
    
    aAdd (aPaineis[nPos][3], {Tipo do objeto,;
                              Titulo,;
                              Mascara,;
                              Tipo do conteudo,;
                              Numero casas decimais,;
                              Array se for combobox ou listbox ou radiobox,;
                              Opcao de seleção se checkbox,;
                              Tamanho,;
                              Inicializador padrão,;
                              Se usa GetFile,;
                              Consulta Padrão F3})
 
    
    Tipo do objeto = 1=SAY, 2=MSGET, 3=COMBOBOX, 4=CHECKBOX, 5=LISTBOX, 6=RADIO
    Titulo do objeto, quando tiver. Ex: SAY(Caption), CHECKBOX.
    Picture quando for necessario. Ex: MSGET.
    Tipo de conteudo do objeto. Ex: 1=Caracter, 2=Numerico, 3=Data.
    Numero de casas decimais do objeto MSGET caso seja numerico.
    Itens de selecao dos objetos. Ex: COMBOBOX, LISTBOX, RADIO.
    Opcao de selecao do item quando CHECKBOX. Determina se iniciara marcado ou nao.
    Numero de casas inteiras quando o conteudo do objeto MSGET for numerico.
    Inicializador padrao
    Se usa get para Arquivo (.T. ou .F.)
    Consulta Padrão (F3)
    */
    
    //***************************** PAINEL 0 *****************************//
    aAdd ( aTxtApre , "Exportação de dados Wizard" )
    aAdd ( aTxtApre , "" )
    aAdd ( aTxtApre , "Preencha corretamente as informações solicitadas." )
    aAdd ( aTxtApre , "Informações necessárias para a exportação do arquivo csv." )
    
    //***************************** PAINEL 1 *****************************//
    //Inicializa o painel
    aAdd ( aPaineis , {} )
    nPos :=	Len ( aPaineis )
    
    aAdd ( aPaineis[nPos] , "Preencha corretamente as informações solicitadas." )
    aAdd ( aPaineis[nPos] , "Parâmetros da exportação" )
    aAdd ( aPaineis[nPos] , {} ) //Saltar uma linha
    
    aAdd (aPaineis[nPos][3], {1,"Diretorio (C:\) :",,,,,,})
    //aAdd (aPaineis[nPos][3], {2,,,1,,,,,,.T.})
    aAdd (aPaineis[nPos][3], {2,,Replicate ("X", 7),1,,,,7}) //Campo filial
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    
    aAdd (aPaineis[nPos][3], {1,"Produto Inicial",,,,,,})
    aAdd (aPaineis[nPos][3], {1,"Produto Final",,,,,,})
    aAdd (aPaineis[nPos][3], {2,,Replicate ("X", TamSx3("B1_COD")[1]),1,,,,TamSx3("B1_COD")[1],,,"SB1"}) // Campo codigo produto
    aAdd (aPaineis[nPos][3], {2,,Replicate ("X", TamSx3("B1_COD")[1]),1,,,,TamSx3("B1_COD")[1],,,"SB1"}) // Campo codigo produto
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    
    aAdd (aPaineis[nPos][3], {1,"Grupo Inicial",,,,,,})
    aAdd (aPaineis[nPos][3], {1,"Grupo Final",,,,,,})
    
    aAdd (aPaineis[nPos][3], {2,,Replicate ("X", TamSx3("B1_GRUPO")[1])	,1,,,,TamSx3("B1_GRUPO")[1],,,"SBM"})
    aAdd (aPaineis[nPos][3], {2,,Replicate ("X", TamSx3("B1_GRUPO")[1])	,1,,,,TamSx3("B1_GRUPO")[1],,,"SBM"})
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    
    //aAdd (aPaineis[nPos][3], {1,"Envia Registros para API ICMAIS ?",,,,,,})
    //aItens1	:=	{}
    //aAdd (aItens1, "1-Sim")
   // aAdd (aItens1, "2-Nao")
   // aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,})
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
   // aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
  
       
   /* 
    aAdd (aPaineis[nPos][3], {1,"Tipo de",,,,,,})
    aAdd (aPaineis[nPos][3], {1,"Tipo até",,,,,,})
    
     aAdd (aPaineis[nPos][3], {2,,Replicate ("X", TamSx3("B1_TIPO")[1])	,1,,,,TamSx3("B1_TIPO")[1],,,})
    aAdd (aPaineis[nPos][3], {2,,Replicate ("X", TamSx3("B1_TIPO")[1])	,1,,,,TamSx3("B1_TIPO")[1],,,})*/
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    aAdd (aPaineis[nPos][3], {0,"",,,,,,})//Saltar uma linha
    
    aAdd (aPaineis[nPos][3], {1,"Parametros para gerar .CSV SOUK",,,,,,})
  
    /*********************************************************************
    Função:
    XFUNWizard - Função de montagem do Wizard da rotina
    
    Parametros:
    aTxtApre - Array com o cabeçalho do Wizard
    aPaineis - Array com os paineis do Wizard
    cNomeWizard - Nome do arquivo de Wizard
    cNomeAnt - Nome do arquivo anterior do Wizard caso tenha mudado de nome
    
    Retorno:
    .T. Para validacao OK
    .F. Para validacao NAO OK
    **********************************************************************/
    
    if XFUNWizard( aTxtApre, aPaineis, cNomWiz )
        /*********************************************************************
        Função:
        XFUNLoadProf - Carrega os parametros no profile
        
        Parametros:
        cNomeWizard - Nome do arquivo de Wizard
        aParametros - Array com o conteudo do arquivo texto do Wizard (RETORNO POR REFERENCIA)
        
        Retorno:
        .T. Para validacao OK
        .F. Para validacao NAO OK
        **********************************************************************/       
        If XFUNLoadProf( cNomWiz , @aWizard )
            
            //Painel 1
            cDiretorio	:= aWizard[ 1, 01]
            cPrdDe    	:= aWizard[ 1, 02]
            cPrdAte   	:= aWizard[ 1, 03]
            cGruDe 	 	:= aWizard[ 1, 04]
            cGruAte 	:= aWizard[ 1, 05]
            cOPData 	:= "" //aWizard[ 1, 06]
           // cTPDe 	 	:= aWizard[ 1, 07]
           // cTPAte 	 	:= aWizard[ 1, 08]
           
            //MsgStop("O arquivo é obrigatório!"+ cNomWiz)
            
            //Caso queira validar
            /*If Empty( Alltrim( cFilial1 ))
                MsgStop("A Filial é obrigatório!")
                Return
            Endif*/
            
            U_EXPORSB1(cDiretorio, cPrdDe, cPrdAte, cGruDe, cGruAte, cOPData, cTPDe, cTPAte) 
             
        Endif
    Endif
Return





