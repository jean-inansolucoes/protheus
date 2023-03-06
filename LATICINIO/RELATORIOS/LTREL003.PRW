#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL003 บAutor  ณRafael Parma         บ Data ณ  17/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo da planilha para lan็amentos de coletas บฑฑ
ฑฑบ          ณde leite a campo.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL003()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "PLANILHA PARA COLETAS DE LEITE"
//Local cPict          := ""
Local titulo         := "PLANILHA PARA COLETAS DE LEITE"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := "" 
//Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00003"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LTREL003"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL003"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZL0"
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

	RptStatus({|| Report(Cabec1,Cabec2,Titulo,nLin) },Titulo)	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณReport    บ Autor ณRafael Parma        บ Data ณ  22/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo da planilha para lan็amentos de coletas บฑฑ
ฑฑบ          ณde leite a campo.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Report(Cabec1,Cabec2,Titulo,nLin)
Local nCol       := 0
Local cAliasTMP  := "TMP"
Local cCODLIN    := STRING_Null
Local cDSCLIN    := STRING_Null                               
Local cCODTRP    := STRING_Null
Local cDSCTRP    := STRING_Null                               
Local hEnter	 := CHR(10) + CHR(13) 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif
	    
	cQuery := "SELECT 	ZL0.ZL0_COD,								" + hEnter
	cQuery += "			ZL0.ZL0_DESC,  								" + hEnter    
	cQuery += "			ZL0.ZL0_TRANSP, 							" + hEnter
	cQuery += "			ZL0.ZL0_NOMTRP, 							" + hEnter
	cQuery += "			ZL1.ZL1_SEQ,   								" + hEnter		
	cQuery += "			ZL1.ZL1_PRODUT,								" + hEnter
	cQuery += "			ZL1.ZL1_LOJPRD,								" + hEnter
	cQuery += "			SA2.A2_NOME									" + hEnter  
	cQuery += "FROM " + RetSqlName("ZL0") + " ZL0					" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL1") + " ZL1   			" + hEnter
	cQuery += "ON       ZL0.ZL0_FILIAL = ZL1.ZL1_FILIAL             " + hEnter		
	cQuery += "AND      ZL0.ZL0_COD    = ZL1.ZL1_COD                " + hEnter		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   		" + hEnter
	cQuery += "ON       ZL1.ZL1_PRODUT    = SA2.A2_COD      	    " + hEnter		
	cQuery += "AND      ZL1.ZL1_LOJPRD    = SA2.A2_LOJA         	" + hEnter			
	cQuery += "WHERE    ZL0.ZL0_FILIAL = '" + xFilial("ZL0") + "' 	" + hEnter
	cQuery += "AND 		( ZL0.ZL0_COD  BETWEEN '" + mv_par01 + "' 	" + hEnter
	cQuery += "AND                 		       '" + mv_par02 + "' )	" + hEnter	
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 					" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 					" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_    != '*' 					" + hEnter
	cQuery += "ORDER BY ZL0.ZL0_COD, SA2.A2_NOME	  				" + hEnter

	memowrite("LTREL003_1.SQL",cQuery)
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
	    
	    If mv_par03 == 1	// Layout 1

			If cCODLIN != (cAliasTMP)->ZL0_COD
				
				If cCODLIN != STRING_Null
					nLin += 3
					@nLin,005 PSAY "TOTAL.....: " + Replicate("_",8)
					@nLin,030 PSAY "PLAFAFORMA: " + Replicate("_",8)
					@nLin,055 PSAY "DIFERENวA.: " + Replicate("_",8)
				EndIf
	
			/*
	                      1         2         3         4         5         6         7         8
	            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
	            ---------------------------------------------------------------------------------
			    PRODUTOR                            QTDE  PRODUTOR                           QTDE  
			*/  
				
				Cabec1 := (cAliasTMP)->ZL0_COD + "-" + SubSTR((cAliasTMP)->ZL0_DESC,1,20)
				Cabec1 += " | " + (cAliasTMP)->ZL0_TRANSP + "-" + SubSTR((cAliasTMP)->ZL0_NOMTRP,1,20)
				Cabec1 += " | DATA : __/__/____"
				Cabec2 := "PRODUTOR                           QTDE   PRODUTOR                           QTDE"
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 41   
			EndIf                                  
			
			If nLin > 63			
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 41   
			 EndIf
	        
	        If nCol == 0
	        	nCol := 41
	        Else
	        	nCol := 0
	        	nLin += 2
	        EndIf
	        
			@nLin,nCol    PSAY ALLTRIM((cAliasTMP)->ZL1_PRODUT) + Space(01) + SubSTR((cAliasTMP)->A2_NOME,1,22)
			@nLin,nCol+31 PSAY Replicate("_",8)
	
		ElseIf mv_par03 == 2	// Layout 2
		

			If cCODLIN != (cAliasTMP)->ZL0_COD
				
				If cCODLIN != STRING_Null
		
					If nLin > 57
					
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
					    nLin := 9
					    nCol := 0   
					 EndIf
				
					nLin += 2
					@nLin,010 PSAY Replicate("_",18)
					@nLin,050 PSAY Replicate("_",18)
					nLin+= 1
					@nLin,012 PSAY "ASS. FRETEIRO"
					@nLin,052 PSAY "ASS. ANALISTA"			
					nLin+= 2
					@nLin,020 PSAY "TOTAL LINHA.......: " + Replicate("_",8)
					nLin+= 1
					@nLin,020 PSAY "TOTAL PLAFAFORMA..: " + Replicate("_",8)
					nLin+= 1
					@nLin,020 PSAY "QUANT. SOBRA......: " + Replicate("_",8)
					nLin+= 1                                        
					@nLin,020 PSAY "QUANT. FALTA......: " + Replicate("_",8)
		
				EndIf
	
			/*
	                      1         2         3         4         5         6         7         8         9         0         1         2         3
	            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12
	            ---------------------------------------------------------------------------------
			    PRODUTOR                | QTD LT | HORARIO | TEMP L.| TAN.C-I | TAN.123 | TEMP T. 
			    012345 JOAO PEDRO ARAUJ | ______ | _______ | ______ | _______ | _______ | _______
			*/  
				
				Cabec1 := (cAliasTMP)->ZL0_COD + "-" + SubSTR((cAliasTMP)->ZL0_DESC,1,20)
				Cabec1 += " | " + (cAliasTMP)->ZL0_TRANSP + "-" + SubSTR((cAliasTMP)->ZL0_NOMTRP,1,20)
				Cabec1 += " | DATA : __/__/____"
				Cabec2 := "PRODUTOR                | QTD LT | HORARIO | TEMP L.| TAN.C-I | TAN.123 | TEMP T."
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 0   
			    
			EndIf                                  
			
			If nLin > 63			
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 0   
			 EndIf

			@nLin,nCol    PSAY ALLTRIM((cAliasTMP)->ZL1_PRODUT) + Space(01) + SubSTR((cAliasTMP)->A2_NOME,1,15)
			@nLin,nCol+24 PSAY "| ______ | _______ | ______ | _______ | _______ | _______"
			
			nLin += 2


		ElseIf mv_par03 == 3	//	Layout 3
		
			If cCODLIN != (cAliasTMP)->ZL0_COD
				
				If cCODLIN != STRING_Null
					nLin += 2
					@nLin,005 PSAY "TOTAL.....: " + Replicate("_",8)
					@nLin,030 PSAY "PLAFAFORMA: " + Replicate("_",8)
					@nLin,055 PSAY "DIFERENวA.: " + Replicate("_",8)
				EndIf
	
			/*
	                      1         2         3         4         5         6         7         8
	            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
	            ---------------------------------------------------------------------------------
			    PRODUTOR                                     QUANTIDADE           NUMERO AMOSTRA
			*/  
				
				Cabec1 := (cAliasTMP)->ZL0_COD + "-" + SubSTR((cAliasTMP)->ZL0_DESC,1,20)
				Cabec1 += " | " + (cAliasTMP)->ZL0_TRANSP + "-" + SubSTR((cAliasTMP)->ZL0_NOMTRP,1,20)
				Cabec1 += " | DATA : __/__/____"
				Cabec2 := "PRODUTOR                                     QUANTIDADE           NUMERO AMOSTRA"
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 41   
			EndIf                                  
			
			If nLin > 63			
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 41   
			 EndIf
        	nCol := 0
        	nLin += 2
			
			@nLin,000 PSAY ALLTRIM((cAliasTMP)->ZL1_PRODUT) + Space(01) + SubSTR((cAliasTMP)->A2_NOME,1,35)
			@nLin,045 PSAY Replicate("_",10)		
			@nLin,066 PSAY Replicate("_",10)		
					

		ElseIf mv_par03 == 4	//	Layout 4
		
			If cCODLIN != (cAliasTMP)->ZL0_COD
				
				If cCODLIN != STRING_Null
					nLin += 2
					@nLin,005 PSAY "TOTAL DA FOLHA: _________________"
				EndIf
	
			/*
	                      1         2         3         4         5         6         7         8
	            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
	            ---------------------------------------------------------------------------------
			    DADOS PRODUTOR                          LITROS    ALIZAROL  TEMPER.   NR.AMOSTRA
			*/  
				
				Cabec1 := (cAliasTMP)->ZL0_COD + "-" + SubSTR((cAliasTMP)->ZL0_DESC,1,20)
				Cabec1 += " | " + (cAliasTMP)->ZL0_TRANSP + "-" + SubSTR((cAliasTMP)->ZL0_NOMTRP,1,20)
				Cabec1 += " | DATA :___/___/___"
				Cabec2 := "DADOS PRODUTOR                          LITROS    ALIZAROL  TEMPER.   NR.AMOSTRA"
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 41   
			EndIf                                  
			
			If nLin > 60
				nLin += 2
				@nLin,005 PSAY "TOTAL DA FOLHA: _________________"				
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 41   
			 EndIf
        	nCol := 0
        	nLin += 2
			
			@nLin,000 PSAY ALLTRIM((cAliasTMP)->ZL1_PRODUT) + Space(01) + SubSTR((cAliasTMP)->A2_NOME,1,29)
			@nLin,040 PSAY Replicate("_",08)		
			@nLin,050 PSAY Replicate("_",08)		
			@nLin,060 PSAY Replicate("_",08)
			@nLin,070 PSAY Replicate("_",08)


		EndIf
		

		cCODLIN := (cAliasTMP)->ZL0_COD
		cDSCLIN := (cAliasTMP)->ZL0_DESC
		cCODTRP := (cAliasTMP)->ZL0_TRANSP
		cDSCTRP := (cAliasTMP)->ZL0_NOMTRP
		

	    (cAliasTMP)->(dbSkip())
	   		
	EndDo
                
	If mv_par03 == 1 .or. mv_par03 == 3	// Layout 1 / Layout 3

		If cCODLIN != STRING_Null
			nLin += 3
			@nLin,005 PSAY "TOTAL.....: " + Replicate("_",8)
			@nLin,030 PSAY "PLAFAFORMA: " + Replicate("_",8)
			@nLin,055 PSAY "DIFERENวA.: " + Replicate("_",8)
		EndIf                                                     
		
	ElseIf mv_par03 == 4

		If cCODLIN != STRING_Null
			nLin += 2
			@nLin,005 PSAY "TOTAL DA FOLHA: _________________"
		EndIf
	
	Else

		If cCODLIN != STRING_Null

			If nLin > 57
			
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
			    nLin := 9
			    nCol := 0   
			 EndIf
		
			nLin += 2
			@nLin,010 PSAY Replicate("_",18)
			@nLin,050 PSAY Replicate("_",18)
			nLin+= 1
			@nLin,012 PSAY "ASS. FRETEIRO"
			@nLin,052 PSAY "ASS. ANALISTA"			
			nLin+= 2
			@nLin,020 PSAY "TOTAL LINHA.......: " + Replicate("_",8)
			nLin+= 1
			@nLin,020 PSAY "TOTAL PLAFAFORMA..: " + Replicate("_",8)
			nLin+= 1
			@nLin,020 PSAY "QUANT. SOBRA......: " + Replicate("_",8)
			nLin+= 1                                        
			@nLin,020 PSAY "QUANT. FALTA......: " + Replicate("_",8)
						
		
		EndIf

	EndIf

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
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  17/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()
Local i,j
aRegs   := {}
aHelp01 := {}  
aHelp02 := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch1","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0301."})
	aAdd(aRegs,{cPerg,"02","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch2","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0302."})
	aAdd(aRegs,{cPerg,"03","Layout Impressใo   ?","Layout Impressใo   ?","Layout Impressใo   ?","mv_ch3","N",01,0,2,"C","","mv_par03","Layout 1","Layout 1","Layout 1","","","Layout 2","Layout 2","Layout 2","","","Layout 3","Layout 3","Layout 3","","","Layout 4","Layout 4","Layout 4","","","","","","", "","","",""})

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe o c๓digo da linha inicial        " )       
	AADD( aHelp01, "a ser impresso.                          " )       
	AADD( aHelp02, "Informe o c๓digo da linha final          " )       
	AADD( aHelp02, "a ser impresso.                          " )       
	
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
	PutSX1Help("P.LTREL0301.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0302.",aHelp02,aHelp02,aHelp02)
		
Return Nil
