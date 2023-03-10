#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?LTREL006 ?Autor  ?Rafael Parma         ? Data ?  19/11/2009 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Rotina de impress?o de equipamentos x produtores.           ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS LATICINIO                                             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
  
*-----------------------*
User Function LTREL006()
*-----------------------*


//?????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de Variaveis                                             ?
//???????????????????????????????????????????????????????????????????????

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELA??O DE EQUIPAMENTOS X PRODUTORES"
Local cPict          := ""
Local titulo         := "RELA??O DE EQUIPAMENTOS X PRODUTORES"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00006"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 080
Private tamanho      := "P"
Private nomeprog     := "LTREL006"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL006"
Public STRING_NULL   := ""


	//???????????????????????????????????????????????????????????Ŀ
	//?Chamado rotina de verifica??o/cria??o do grupo de perguntas?
	//?????????????????????????????????????????????????????????????
	cString := "ZL4"
	AjustaSX1()                                                 
	Pergunte(cPerg, .F.) 
	
	//?????????????????????????????????????????????????????????????????????Ŀ
	//? Monta a interface padrao com o usuario...                           ?
	//???????????????????????????????????????????????????????????????????????
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//?????????????????????????????????????????????????????????????????????Ŀ
	//? Processamento. RPTSTATUS monta janela com a regua de processamento. ?
	//???????????????????????????????????????????????????????????????????????

	RptStatus({|| Report(Cabec1,Cabec2,Titulo,nLin) },Titulo)	

Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?Report    ? Autor ?Rafael Parma        ? Data ?  19/10/09   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Rotina de impress?o de equipamentos x produtores.           ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function Report(Cabec1, Cabec2, Titulo, nLin)
Local aPROD       := {}
Local aTOTAL      := {}
Local cAliasTMP   := GetNextAlias()
Local cCODPRD     := STRING_Null
Local hEnter	  := CHR(10) + CHR(13) 


	//?????????????????????????????????????????????????????????????????????????Ŀ
	//? Filtro dos pedidos de acordo com os parametros informados pelo usu?rio. ?
	//?????????????????????????????????????????????????????????????????????????Ŀ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif

	cQuery := "SELECT 	ZL4.ZL4_COD,										" + hEnter
	cQuery += "			ZL4.ZL4_LOJA,  										" + hEnter
	cQuery += "			ZL4.ZL4_NOME,  										" + hEnter		
	cQuery += "			ZL4.ZL4_SEQ,   										" + hEnter
	cQuery += "			ZL4.ZL4_EQUIP, 										" + hEnter
	cQuery += "			ZL4.ZL4_DESC,  										" + hEnter  
	cQuery += "			ZL1.ZL1_COD,  										" + hEnter  	
	cQuery += "			ZL0.ZL0_DESC  										" + hEnter  		
	cQuery += "FROM " + RetSqlName("ZL4") + " ZL4							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL1") + " ZL1         			" + hEnter
	cQuery += "ON       ZL4.ZL4_FILIAL    = ZL1.ZL1_FILIAL      			" + hEnter		
	cQuery += "AND      ZL4.ZL4_COD       = ZL1.ZL1_PRODUT      			" + hEnter	
	cQuery += "AND      ZL4.ZL4_LOJA      = ZL1.ZL1_LOJPRD      			" + hEnter	
	cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0         			" + hEnter
	cQuery += "ON       ZL1.ZL1_FILIAL    = ZL0.ZL0_FILIAL      			" + hEnter		
	cQuery += "AND      ZL1.ZL1_COD       = ZL0.ZL0_COD		      			" + hEnter	
	cQuery += "WHERE    ZL4.ZL4_FILIAL = '" + xFilial("ZL4") + "' 			" + hEnter
	If mv_par07 == 1
		cQuery += "AND 		( ZL4.ZL4_COD  BETWEEN '" + mv_par01 + "' 		" + hEnter
		cQuery += "AND                 		       '" + mv_par02 + "' )		" + hEnter	
		cQuery += "AND 		( ZL4.ZL4_LOJA BETWEEN '" + mv_par03 + "' 		" + hEnter
		cQuery += "AND                 		       '" + mv_par04 + "' )		" + hEnter	
	Else
		cQuery += "AND 		( ZL1.ZL1_COD  BETWEEN '" + mv_par05 + "' 		" + hEnter
		cQuery += "AND                 		       '" + mv_par06 + "' )		" + hEnter	
	EndIf
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL4.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "ORDER BY ZL4.ZL4_NOME, ZL4.ZL4_SEQ   						" + hEnter
	

	memowrite("LTREL006_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
	 
	While (cAliasTMP)->(!EOF())

		//?????????????????????????????????????????????????????????????????????Ŀ
		//? Verifica o cancelamento pelo usuario...                             ?
		//???????????????????????????????????????????????????????????????????????
						
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif 
		
		//?????????????????????????????????????????????????????????????????????Ŀ
		//? Impressao do cabecalho do relatorio. . .                            ?
		//???????????????????????????????????????????????????????????????????????

		/*
                      1         2         3         4         5         6         7         8
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            ---------------------------------------------------------------------------------
		    SEQ.  EQUIPAMENTO   DESCRI??O                                                    
		*/  

		If cCODPRD != (cAliasTMP)->ZL4_COD
			Cabec1 := "PRODUTOR: " + (cAliasTMP)->ZL4_COD + "/" + (cAliasTMP)->ZL4_LOJA + "-" + SubSTR((cAliasTMP)->ZL4_NOME,1,20)
			Cabec1 += " | LINHA: " + (cAliasTMP)->ZL1_COD + "/" + SubSTR((cAliasTMP)->ZL0_DESC,1,18)
			Cabec2 := "SEQ.  EQUIPAMENTO   DESCRI??O                                                   "			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			nLin := 9
		EndIf                                  
				
		If nLin > 55			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9                                       
		EndIf
		
		@nLin,000 PSAY (cAliasTMP)->ZL4_SEQ        
		@nLin,006 PSAY (cAliasTMP)->ZL4_EQUIP        
		@nLin,020 PSAY (cAliasTMP)->ZL4_DESC
		nLin += 1

		cCODPRD := (cAliasTMP)->ZL4_COD

		(cAliasTMP)->(dbSkip())
	Enddo

	(cAliasTMP)->(dbCloseArea())

	//?????????????????????????????????????????????????????????????????????Ŀ
	//? Finaliza a execucao do relatorio...                                 ?
	//???????????????????????????????????????????????????????????????????????
	
	SET DEVICE TO SCREEN
	
	//?????????????????????????????????????????????????????????????????????Ŀ
	//? Se impressao em disco, chama o gerenciador de impressao...          ?
	//???????????????????????????????????????????????????????????????????????
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return
     

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?AJUSTASX1  ?Autor  ?Rafael Parma       ? Data ?  19/11/09   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Fun??o utilizada para verificar/criar no ambiente o grupo   ???
???          ?de perguntas.                                               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS LATICINIO                                             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

Static Function AjustaSX1()
aRegs   := {}
aHelp01 := {}  
aHelp02 := {} 
aHelp03 := {}  
aHelp04 := {}                                                  
aHelp05 := {} 
aHelp06 := {} 
aHelp07 := {} 

	//???????????????????????????????????????????????????????
	//?Defini??o dos itens do grupo de perguntas a ser criado?
	//???????????????????????????????????????????????????????
	aAdd(aRegs,{cPerg,"01","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch1","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL0601."})
	aAdd(aRegs,{cPerg,"02","Produtor At?       ?","Produtor At?       ?","Produtor At?       ?","mv_ch2","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL0602."})
	aAdd(aRegs,{cPerg,"03","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch3","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0603."})
	aAdd(aRegs,{cPerg,"04","Loja Produtor At?  ?","Loja Produtor At?  ?","Loja Produtor At?  ?","mv_ch4","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0604."})
	aAdd(aRegs,{cPerg,"05","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0605."})
	aAdd(aRegs,{cPerg,"06","Linha At?          ?","Linha At?          ?","Linha At?          ?","mv_ch6","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0606."})
	aAdd(aRegs,{cPerg,"07","Filtrar Por        ?","Filtrar Por        ?","Filtrar Por        ?","mv_ch7","N",01,0,1,"C","","mv_par07","Produtor","Produtor","Produtor","","","Linha","Linha","Linha","","","","","","","","","","","","","","","","", "","","",".LTREL0607."})
	
	//???????????????????????????????????????????????????Ŀ
	//?Montagem do Help de cada item do Grupo de Perguntas?
	//?????????????????????????????????????????????????????
	AADD( aHelp01, "Informe o c?digo inicial do produtor     " )       
	AADD( aHelp01, "a ser impresso.                          " )       
	AADD( aHelp02, "Informe o c?digo final do produtor       " )       
	AADD( aHelp02, "a ser impresso.                          " )       
	AADD( aHelp03, "Informe a loja inicial do produtor       " )       
	AADD( aHelp03, "a ser impresso.                          " )       
	AADD( aHelp04, "Informe a loja final do produtor         " )       
	AADD( aHelp04, "a ser impresso.                          " )      
	AADD( aHelp05, "Informe o n?mero inicial da linha        " )       
	AADD( aHelp05, "a ser impressa.                          " )       
	AADD( aHelp06, "Informe o n?mero final da linha          " )       
	AADD( aHelp06, "a ser impressa.                          " )       
	AADD( aHelp07, "Informe se deseje imprimir por intervalo " )       
	AADD( aHelp07, "de linhas ou produtores.                 " )  
	
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
	
	//?????????????????????????????????????????????Ŀ
	//?Atualiza o Help dos campos no arquivo de Help?
	//???????????????????????????????????????????????
	PutSX1Help("P.LTREL0601.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0602.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL0603.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL0604.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL0605.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL0606.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL0607.",aHelp07,aHelp07,aHelp07)
				
Return Nil
