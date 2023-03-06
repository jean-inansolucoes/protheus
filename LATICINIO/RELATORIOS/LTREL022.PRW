#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL022 ºAutor  ³Rafael Parma         º Data ³  09/06/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão de laudo de antibiótico para o produtor.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
  
*-----------------------*
User Function LTREL022()
*-----------------------*


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "LAUDO DE ANTIBIÓTICO"              
Local cPict          := ""
Local titulo         := "LAUDO DE ANTIBIÓTICO"              
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00022"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL022"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL022"
Public STRING_NULL   := ""


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamado rotina de verificação/criação do grupo de perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cString := "ZLD"
	AjustaSX1()                                                 
	If ! Pergunte(cPerg, .T.) 
		Return
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Processa({|| Report(Cabec1,Cabec2,Titulo,nLin) },Titulo,"Processando...")	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Report   ºAutor  ³Rafael Parma         º Data ³  09/06/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressão de laudo de antibiótico para o produtor.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Report(Cabec1, Cabec2, Titulo, nLin)

Local cAliasTMP := GetNextAlias() 
Local cAliasQTD := GetNextAlias()
Local cCODMOV   := STRING_NULL
Local hEnter	:= CHR(10) + CHR(13) 
Local aParam    := {}
Local nPag      := 1
Local nCCS_MAX  := 0
Local nCBT_MAX  := 0
Local nSLT_MAX  := 0 
Local nGORD_MIN := 0
Local nPROT_MIN := 0
Local nLACT_MIN := 0
Private cBitMap := "lgrl01.bmp"

	nheight07  := 7
	nHeight08  := 8
	nHeight09  := 9
	nHeight10  := 10
	nHeight11  := 11
	nHeight12  := 12
	nheight13  := 13
	nHeight15  := 15
	
	lBold	   := .T.
	lUnderLine := .T.
	
	oFont1	:= TFont():New( "Arial",,nheight07,,lBold,,,,,!lUnderLine )
	oFont2  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont3  := TFont():New( "Mono AS",,nHeight10,,lBold,,,,,!lUnderLine )
	oFont4  := TFont():New( "Arial",,nHeight11,,lBold,,,,,!lUnderLine )
	oFont5  := TFont():New( "Arial",,nHeight13,,lBold,,,,,!lUnderLine )
	oFont6  := TFont():New( "Arial",,nheight15,,lBold,,,,,!lUnderLine )
	oFont7  := TFont():New( "Arial",,nheight12,,lBold,,,,,!lUnderLine )
	oFont8  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont9  := TFont():New( "Arial",,nheight10,,lBold,,,,,!lUnderLine )
	lFirst	:= .T.

	oPrn    := TMSPrinter():New()
	oPen    := TPen():New(,7,CLR_BLACK,oPrn)

	cQuery := " SELECT 														" + hEnter
	cQuery += "     	ZL7.ZL7_LINHA,										" + hEnter
	cQuery += "     	ZL7.ZL7_DATA,										" + hEnter
	cQuery += "     	ZL7.ZL7_NOMLIN,										" + hEnter	
	cQuery += "     	ZLD.ZLD_CODMOV,										" + hEnter
	cQuery += "     	ZLD.ZLD_DATCOL,										" + hEnter
	cQuery += "         ZLD.ZLD_DATANA,										" + hEnter
	cQuery += "         ZLD.ZLD_PRODUT,										" + hEnter
	cQuery += "         ZLD.ZLD_LOJPRD,										" + hEnter
	cQuery += "         ZLD.ZLD_NOMPRD,										" + hEnter
	cQuery += "         ZLD.ZLD_NUMERO,										" + hEnter
	cQuery += "         ZLD.ZLD_ANTIBI,										" + hEnter
	cQuery += "         ZLD.ZLD_TAANT,										" + hEnter
	cQuery += "         ZLD.ZLD_COLETO,										" + hEnter
	cQuery += "         ZLD.ZLD_ANALIS,										" + hEnter	
	cQuery += "         ZLD.ZLD_QTDCON										" + hEnter
	cQuery += " FROM " + RetSqlName("ZLD") + " ZLD							" + hEnter
	cQuery += " INNER JOIN " + RetSqlName("ZL7") + " ZL7					" + hEnter
	cQuery += " ON		ZLD.ZLD_FILIAL = ZL7.ZL7_FILIAL						" + hEnter
	cQuery += " AND		ZLD.ZLD_CODMOV = ZL7.ZL7_COD						" + hEnter
	cQuery += "WHERE    ZLD.ZLD_FILIAL = '" + xFilial("ZLD") + "' 			" + hEnter
	cQuery += "AND 		( ZLD.ZLD_DATCOL BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par02) + "' )	" + hEnter
	cQuery += "AND 		( ZLD.ZLD_DATANA BETWEEN '" + dtos(mv_par03) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(mv_par04) + "' )	" + hEnter
	cQuery += "AND 		( ZL7.ZL7_LINHA  BETWEEN '" + mv_par05 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par06 + "' )		" + hEnter	
	cQuery += "AND 		( ZLD.ZLD_PRODUT BETWEEN '" + mv_par07 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par08 + "' )		" + hEnter	
	cQuery += "AND 		( ZLD.ZLD_LOJPRD BETWEEN '" + mv_par09 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par10 + "' )		" + hEnter	
	cQuery += "AND 		( ZL7.ZL7_TRANSP BETWEEN '" + mv_par11 + "' 		" + hEnter
	cQuery += "AND                 		         '" + mv_par12 + "' )		" + hEnter		                                                                  
	cQuery += "AND 		ZLD.ZLD_ANTIBI     = 'P' 							" + hEnter
	cQuery += "AND 		ZLD.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL7.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += " ORDER BY													" + hEnter
	cQuery += "     	ZL7.ZL7_LINHA,										" + hEnter
	If mv_par13 == 1
		cQuery += "     ZLD.ZLD_PRODUT, ZLD.ZLD_LOJPRD						" + hEnter		
	Else                                                                                  
		cQuery += "     ZLD.ZLD_NOMPRD										" + hEnter
	EndIf

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	oPrn:SetPortrait()
	oPrn:Setup()
		 
	While (cAliasTMP)->(!EOF())
        

		//-- Recupera número de amostras positivas, para realizar divisão da quantidade condenada.
		If cCODMOV != (cAliasTMP)->ZLD_CODMOV
		
			nPOSITIVO := 1
	
			cQuery := " SELECT 														" + hEnter
			cQuery += "     	COUNT(*) TOTAL										" + hEnter
			cQuery += " FROM " + RetSqlName("ZLD") + " ZLD							" + hEnter
			cQuery += " WHERE   ZLD.ZLD_FILIAL  = '" + xFilial("ZLD") + "' 			" + hEnter
			cQuery += " AND     ZLD.ZLD_CODMOV  = '" + (cAliasTMP)->ZLD_CODMOV +"'	" + hEnter
			cQuery += " AND 	ZLD.ZLD_ANTIBI  = 'P' 								" + hEnter
			cQuery += " AND 	ZLD.D_E_L_E_T_ != '*' 								" + hEnter
	
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasQTD)			
			dbSelectArea(cAliasQTD)
			(cAliasQTD)->(dbGoTop())
			nPOSITIVO := (cAliasQTD)->TOTAL
			(cAliasQTD)->(dbCloseArea())
					
			nQTDCOND := (cAliasTMP)->ZLD_QTDCON/nPOSITIVO  
		
		EndIf
		cCODMOV := (cAliasTMP)->ZLD_CODMOV			
		//-- Inicio da impressão
		
		Li    := 50
		nCol  := 50
		nIncr := 0

		oPrn:StartPage()
		oPrn:SayBitmap( Li+030, nCol+000, cBitMap , 300, 90 )

		//SUPERIOR
		oPrn:Line( 0050, 0030,0050, 2300 )
		//ESQUERDO
		oPrn:Line( 0050, 0030,2900, 0030 )
		//DIREITO
		oPrn:Line( 0050, 2300,2900, 2300 )
		//INFERIOR
		oPrn:Line( 2900, 0030,2900, 2300 )
		
		oPrn:Box( 060, 040, 0300, 2290 )			
		oPrn:Box( 310, 040, 0500, 2290 )
		oPrn:Box( 510, 040, 2890, 2290 )
    	
		nIncr += 040
		oPrn:Say( Li+nIncr, nCol+0840, SM0->M0_NOMECOM, oFont6, 100 )
		
		nIncr += 060
		oPrn:Say( Li+nIncr, nCol+0840, "LAUDO DE ANÁLISE", oFont6, 100 )
		nIncr += 040
		oPrn:Say( Li+nIncr, nCol+1900, "Emissão: "+DTOC(DDATABASE), oFont2, 100 )
		
		nIncr += 170
		oPrn:Say( Li+nIncr, nCol+0050, "Produtor: "+(cAliasTMP)->ZLD_PRODUT+"/"+(cAliasTMP)->ZLD_LOJPRD+"-"+SubSTR((cAliasTMP)->ZLD_NOMPRD,1,40), oFont5, 100 )
		nIncr += 080
		oPrn:Say( Li+nIncr, nCol+0050, "Número do copo: "+(cAliasTMP)->ZLD_NUMERO, oFont5, 100 )

		nIncr += 240
		oPrn:Say( Li+nIncr, nCol+0050, "Análise realizada: Resíduo de Antibiótico em Leite.", oFont6, 100 )
		nIncr += 160
		oPrn:Say( Li+nIncr, nCol+0050, "Data de Coleta: "+DTOC(STOD((cAliasTMP)->ZLD_DATCOL)), oFont5, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0050, "Coletor: "+(cAliasTMP)->ZLD_COLETO, oFont5, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0050, "Data de Análise: "+DTOC(STOD((cAliasTMP)->ZLD_DATANA)), oFont5, 100 )
		nIncr += 090                                                                        
		cDESCMET := IIF((cAliasTMP)->ZLD_TAANT=="B","Betalactâmico",IIF((cAliasTMP)->ZLD_TAANT=="T","Tetraciclina","Ambos (Betalactâmico/Tetraciclina)"))
		oPrn:Say( Li+nIncr, nCol+0050, "Método Utilizado: "+cDESCMET, oFont5, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0050, "Analisado por: "+(cAliasTMP)->ZLD_ANALIS, oFont5, 100 )

		nIncr += 180
		oPrn:Say( Li+nIncr, nCol+0050, "Resultado: POSITIVO para resíduo de antibiótico.", oFont6, 100 )
		
		nIncr += 180
		oPrn:Say( Li+nIncr, nCol+0050, "Observações: ", oFont6, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0050, "Amostra coletada, referente a carga de leite ("+ALLTRIM(TRANSFORM((cAliasTMP)->ZLD_QTDCON,"@E 999,999,999"))+" litros) a ser entregue dia "+DTOC(STOD((cAliasTMP)->ZL7_DATA))+", ", oFont5, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0050, "a qual apresentou resultado positivo para resíduos de antibiótico sendo condenada. ", oFont5, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0050, "Amostra acima citada referente ao rastreamento do resíduo.", oFont5, 100 )

		nIncr += 400
		oPrn:Say( Li+nIncr, nCol+0840, SM0->M0_NOMECOM, oFont6, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0840, UPPER(ALLTRIM(mv_par14)), oFont6, 100 )
		nIncr += 090
		oPrn:Say( Li+nIncr, nCol+0840, "RESPONSÁVEL TÉCNICO", oFont6, 100 )
		
		oPrn:EndPage() 
		        		
		(cAliasTMP)->(dbSkip())
				
	EndDo
    
	(cAliasTMP)->(dbCloseArea())
	
	oPrn:Preview()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se em disco, desvia para Spool                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
		Set Printer To
		Commit
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return
     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  21/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------------------------------------------------*
Static Function AjustaSX1()                                            
*---------------------------------------------------------------------*
aRegs   := {} ; aHelp01 := {} ; aHelp02 := {} ; aHelp03 := {}  
aHelp04 := {} ; aHelp05 := {} ; aHelp06 := {} ; aHelp07 := {} 
aHelp08 := {} ; aHelp09 := {} ; aHelp10 := {} ; aHelp11 := {} 
aHelp12 := {} ; aHelp13 := {} 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Data Coleta De     ?","Data Coleta De     ?","Data Coleta De     ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02201."})
	aAdd(aRegs,{cPerg,"02","Data Coleta Até    ?","Data Coleta Até    ?","Data Coleta Até    ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02202."})	
	aAdd(aRegs,{cPerg,"03","Data Análise De    ?","Data Análise De    ?","Data Análise De    ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02203."})
	aAdd(aRegs,{cPerg,"04","Data Análise Até   ?","Data Análise Até   ?","Data Análise Até   ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02204."})	
	aAdd(aRegs,{cPerg,"05","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch5","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL02205."})
	aAdd(aRegs,{cPerg,"06","Linha Até          ?","Linha Até          ?","Linha Até          ?","mv_ch6","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL02206."})
	aAdd(aRegs,{cPerg,"07","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch7","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02207."})
	aAdd(aRegs,{cPerg,"08","Produtor Até       ?","Produtor Até       ?","Produtor Até       ?","mv_ch8","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02208."})
	aAdd(aRegs,{cPerg,"09","Loja Produtor De   ?","Loja Produtor De   ?","Loja Produtor De   ?","mv_ch9","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02209."})
	aAdd(aRegs,{cPerg,"10","Loja Produtor Até  ?","Loja Produtor Até  ?","Loja Produtor Até  ?","mv_cha","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02210."})
	aAdd(aRegs,{cPerg,"11","Transportador De   ?","Transportador De   ?","Transportador De   ?","mv_chb","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02211."})
	aAdd(aRegs,{cPerg,"12","Transportador Até  ?","Transportador Até  ?","Transportador Até  ?","mv_chc","C",TAMSX3("A4_COD")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",".LTREL02212."})
	aAdd(aRegs,{cPerg,"13","Ordenar Por        ?","Ordenar Por        ?","Ordenar Por        ?","mv_chd","N",01,0,1,"C","","mv_par13","Código Produtor","Código Produtor","Código Produtor","","","Nome Produtor","Nome Produtor","Nome Produtor","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL02213."})	
	aAdd(aRegs,{cPerg,"14","Nome Responsável   ?","Nome Responsável   ?","Nome Responsável   ?","mv_che","C",60,0,1,"C","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD( aHelp01, "Informe a data inicial de coleta para     " )       
	AADD( aHelp01, "análise.                                  " )       
	AADD( aHelp02, "Informe a data final de coleta para       " )       
	AADD( aHelp02, "análise.                                  " )
	AADD( aHelp03, "Informe a data inicial de análise.        " )       
	AADD( aHelp04, "Informe a data final de análise.          " )       
	AADD( aHelp05, "Informe o código inicial da linha de      " )       
	AADD( aHelp05, "coleta.                                   " )       
	AADD( aHelp06, "Informe o código final da linha de        " )       
	AADD( aHelp06, "coleta.                                   " )       
	AADD( aHelp07, "Informe o código inicial do produtor      " )       
	AADD( aHelp07, "a ser impresso.                           " )       
	AADD( aHelp08, "Informe o código final do produtor        " )       
	AADD( aHelp08, "a ser impresso.                           " )       
	AADD( aHelp09, "Informe o código inicial da loja do       " )       
	AADD( aHelp09, "produtor a ser impresso.                  " )       
	AADD( aHelp10, "Informe o código final da loja do         " )       
	AADD( aHelp10, "produtor a ser impresso.                  " )       
	AADD( aHelp11, "Informe o código inicial do transportador." )       
	AADD( aHelp12, "Informe o código final do transportador.  " )       
	AADD( aHelp13, "Ordenar registros impressos pelo codigo   " )       
	AADD( aHelp13, "ou nome do produtor.                      " )
		
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o Help dos campos no arquivo de Help³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PutSX1Help("P.LTREL02201.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL02202.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL02203.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL02204.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL02205.",aHelp05,aHelp05,aHelp05)
	PutSX1Help("P.LTREL02206.",aHelp06,aHelp06,aHelp06)
	PutSX1Help("P.LTREL02207.",aHelp07,aHelp07,aHelp07)
	PutSX1Help("P.LTREL02208.",aHelp08,aHelp08,aHelp08)	
	PutSX1Help("P.LTREL02209.",aHelp09,aHelp09,aHelp09)
	PutSX1Help("P.LTREL02210.",aHelp10,aHelp10,aHelp10)
	PutSX1Help("P.LTREL02211.",aHelp11,aHelp11,aHelp11)
	PutSX1Help("P.LTREL02212.",aHelp12,aHelp12,aHelp12)			
	PutSX1Help("P.LTREL02213.",aHelp13,aHelp13,aHelp13)
					
Return Nil