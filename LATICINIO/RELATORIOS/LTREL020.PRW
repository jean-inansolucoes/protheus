#INCLUDE "TOPCONN.CH"	
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL020 บAutor  ณRafael Parma         บ Data ณ  10/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de rela็ใo de antibi๓tico ao produtor.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL020()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "ANTIBIำTICO AO PRODUTOR"
Local cPict          := ""
Local titulo         := "ANTIBIำTICO AO PRODUTOR"
Local nLin           := 80  
Local Cabec1         := "PRODUTOR                                          NUM. AMOSTRA    DATA ANALISE  NOME ANALISTA             TIPO ANALISE   ANTIBIOTICO"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00020"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "LTREL020"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL020"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZLG"
	AjustaSX1()                                                 
	Pergunte(cPerg, .F.) 
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RptStatus({|| Report(@Cabec1,@Cabec2,Titulo,nLin) },Titulo)	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL020 บAutor  ณRafael Parma         บ Data ณ  10/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de rela็ใo de rastreabilidade de antibi๓tico.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function Report(Cabec1, Cabec2, Titulo, nLin)                   
*---------------------------------------------------------------------*
Local cAliasTMP := GetNextAlias()
Local cCODLIN   := STRING_NULL
Local cCODPRD   := STRING_NULL
Local hEnter	:= CHR(10) + CHR(13) 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de registros....   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	 
	//-- Filtro dos dados
	cQuery := " SELECT 														" + hEnter
	cQuery += "     	ZLG.ZLG_AMOSTR,										" + hEnter
	cQuery += "     	ZLG.ZLG_PRODUT,										" + hEnter	
	cQuery += "     	ZLG.ZLG_LOJPRD,										" + hEnter
	cQuery += "     	ZLG.ZLG_NOMPRD,										" + hEnter
	cQuery += "         ZLG.ZLG_LINHA,										" + hEnter
	cQuery += "         ZLG.ZLG_ANALIS,										" + hEnter
	cQuery += "         ZLG.ZLG_DATANA,										" + hEnter
	cQuery += "         ZLG.ZLG_ANTIBI,										" + hEnter
	cQuery += "         ZLG.ZLG_TAANT										" + hEnter
	cQuery += " FROM " + RetSqlName("ZLG") + " ZLG							" + hEnter
	cQuery += "WHERE    ZLG.ZLG_FILIAL = '" + xFilial("ZLG") + "' 			" + hEnter
	cQuery += "AND 		( ZLG.ZLG_DATANA BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		( ZLG.ZLG_LINHA  BETWEEN '" + mv_par03 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par04 + "' )		" + hEnter	
	cQuery += "AND 		( ZLG.ZLG_PRODUT BETWEEN '" + mv_par05 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par06 + "' )		" + hEnter	
	cQuery += "AND 		( ZLG.ZLG_LOJPRD BETWEEN '" + mv_par07 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par08 + "' )		" + hEnter	
	cQuery += "AND 		ZLG.D_E_L_E_T_    != '*' 							" + hEnter
 	If mv_par09 == 1
		cQuery += "ORDER BY ZLG.ZLG_LINHA,  					 			" + hEnter
		If mv_par10 == 1
			cQuery += "		ZLG.ZLG_PRODUT  					 			" + hEnter
		Else
			cQuery += "		ZLG.ZLG_NOMPRD  					 			" + hEnter
		EndIf
	Else
		If mv_par10 == 1
			cQuery += "ORDER BY ZLG.ZLG_PRODUT  					 		" + hEnter
		Else
			cQuery += "ORDER BY ZLG.ZLG_NOMPRD  					 		" + hEnter
		EndIf
	EndIf
	

	memowrite("LTREL020.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
	 
	While (cAliasTMP)->(!EOF())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif 
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If mv_par09 == 1 .and. cCODLIN 	!= (cAliasTMP)->ZLG_LINHA
			Cabec2 := "LINHA: "+(cAliasTMP)->ZLG_LINHA+"-"+Posicione("ZL0",1,xFilial("ZL0")+(cAliasTMP)->ZLG_LINHA,"ZL0_DESC")
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9                                                                                                         			
		ElseIf mv_par09 == 2 .and. cCODPRD != (cAliasTMP)->ZLG_PRODUT+(cAliasTMP)->ZLG_LOJPRD                                 
			Cabec2 := "LINHA: "+(cAliasTMP)->ZLG_LINHA+"-"+Posicione("ZL0",1,xFilial("ZL0")+(cAliasTMP)->ZLG_LINHA,"ZL0_DESC")
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf				      
				
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		
		cCODLIN := (cAliasTMP)->ZLG_LINHA
		cCODPRD := (cAliasTMP)->ZLG_PRODUT+(cAliasTMP)->ZLG_LOJPRD
		

		/*
                      1         2         3         4         5         6         7         8         9        10        11        12        13  
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12
            -------------------------------------------------------------------------------------------------------------------------------------
		   "PRODUTOR                                          NUM. AMOSTRA    DATA ANALISE  NOME ANALISTA             TIPO ANALISE   ANTIBIOTICO"
	
		*/  

		
		@nLin,000 PSAY SUBSTR(ALLTRIM((cAliasTMP)->ZLG_PRODUT)+"/"+(cAliasTMP)->ZLG_LOJPRD+"-"+ALLTRIM((cAliasTMP)->ZLG_NOMPRD),1,36)
		@nLin,050 PSAY (cAliasTMP)->ZLG_AMOSTR
		@nLin,066 PSAY DTOC(STOD((cAliasTMP)->ZLG_DATANA))
		@nLin,080 PSAY SUBSTR((cAliasTMP)->ZLG_ANALIS,1,24) 
		@nLin,106 PSAY IIF((cAliasTMP)->ZLG_TAANT=="B","BETALAC.",IIF((cAliasTMP)->ZLG_TAANT=="T","TETRAC.","AMBOS"))
		@nLin,121 PSAY IIF((cAliasTMP)->ZLG_ANTIBI=="P","POSITIVO","NEGATIVO")
		nLin += 1

		(cAliasTMP)->(dbSkip())
		
	Enddo

	(cAliasTMP)->(dbCloseArea())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return
     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  19/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------*
Static Function AjustaSX1()                                            
*---------------------------------------------------------------------*
aRegs   := {}
aHelp01 := {}  
aHelp02 := {} 
aHelp03 := {}  
aHelp04 := {}                                                  
aHelp05 := {} 
aHelp06 := {} 
aHelp07 := {} 
aHelp08 := {} 
aHelp09 := {} 
aHelp10 := {} 
aHelp11 := {} 
aHelp12 := {} 

	aAdd(aRegs,{cPerg,"01","Data Anแlise De    ?","Data Anแlise De    ?","Data Anแlise De    ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02001."})
	aAdd(aRegs,{cPerg,"02","Data Anแlise At้   ?","Data Anแlise At้   ?","Data Anแlise At้   ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02002."})	
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL02003."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL02004."})
	aAdd(aRegs,{cPerg,"05","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02005."})
	aAdd(aRegs,{cPerg,"06","Produtor At้       ?","Produtor At้       ?","Produtor At้       ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02006."})
	aAdd(aRegs,{cPerg,"07","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02007."})
	aAdd(aRegs,{cPerg,"08","Loja Produtor At้  ?","Loja Produtor At้  ?","Loja Produtor At้  ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02008."})
	aAdd(aRegs,{cPerg,"09","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","Saltar Pแgina Por  ?","mv_ch9","N",01,0,1,"C","","mv_par09","Linha","Linha","Linha","","","Produtor","Produtor","Produtor","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02009."})
	aAdd(aRegs,{cPerg,"10","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_chA","N",01,0,1,"C","","mv_par10","C๓digo Produtor","C๓digo Produtor","C๓digo Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02010."})	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe a data inicial de anแlise.        " )       
	AADD( aHelp02, "Informe a data final de anแlise.          " )       
	AADD( aHelp03, "Informe o c๓digo inicial da linha de      " )       
	AADD( aHelp03, "coleta.                                   " )       
	AADD( aHelp04, "Informe o c๓digo final da linha de        " )       
	AADD( aHelp04, "coleta.                                   " )       
	AADD( aHelp05, "Informe o c๓digo inicial do produtor      " )       
	AADD( aHelp05, "a ser impresso.                           " )       
	AADD( aHelp06, "Informe o c๓digo final do produtor        " )       
	AADD( aHelp06, "a ser impresso.                           " )       
	AADD( aHelp07, "Informe o c๓digo inicial da loja do       " )       
	AADD( aHelp07, "produtor a ser impresso.                  " )       
	AADD( aHelp08, "Informe o c๓digo final da loja do         " )       
	AADD( aHelp08, "produtor a ser impresso.                  " )       
	AADD( aHelp09, "Informe se deseje saltar pagina por       " )       
	AADD( aHelp09, "produtor ou linha de coleta.              " )  
	AADD( aHelp10, "Ordenar registros impressos pelo codigo   " )       
	AADD( aHelp10, "ou nome do produtor.                      " )
		
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next  
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza o Help dos campos no arquivo de Helpณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutSX1Help("P.LTREL02001.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL02002.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL02003.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL02004.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL02005.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL02006.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL02007.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL02008.",aHelp08,aHelp08,aHelp08)	
	PutSX1Help("P.LTREL02009.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL02010.",aHelp10,aHelp10,aHelp10)

					
Return Nil