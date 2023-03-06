#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTREL005 บAutor  ณRafael Parma         บ Data ณ  18/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo dos lan็amentos de entradas de leite.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTREL005()
*-----------------------*


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "LANวAMENTOS DE ENTRADAS DE LEITE"
Local cPict          := ""
Local titulo         := "LANวAMENTOS DE ENTRADAS DE LEITE"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}         
Private cPerg        := "LTREL00005"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LTREL005"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTREL005"
Public STRING_NULL   := ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamado rotina de verifica็ใo/cria็ใo do grupo de perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cString := "ZL5"
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
ฑฑบFuno    ณReport    บ Autor ณRafael Parma        บ Data ณ  18/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de impressใo dos lan็amentos de entradas de leite.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Report(Cabec1, Cabec2, Titulo, nLin)
Local aPROD       := {}
Local aTOTAL      := {}
Local cAliasTMP   := GetNextAlias()
Local cCODLIN     := STRING_Null
Local nCol        := 0
Local nTOTPRD     := 0
Local nTOTGRL     := 0
Local nTOTD       := 31
Local hEnter	  := CHR(10) + CHR(13) 
Local dSTART_DATE := ctod("01/"+StrZERO(mv_par01,2)+"/"+StrZERO(mv_par02,4))
Local dEND_DATE   := ctod("")
Local nI, nD := 0
    
	If U_YIsBis(mv_par02) 
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","29","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))
    Else
		dEND_DATE := ctod(Iif(StrZero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(StrZero(mv_par01,2)=="02","28","30"))+"/"+StrZero(mv_par01,2)+"/"+StrZero(mv_par02,4))   
    EndIf
	
	nTOTD := dEND_DATE - dSTART_DATE
			
	If StrZero(mv_par01,2) $ "01/03/05/07/08/10/12"
		Cabec2 := "PRODUTOR                    01    02    03    04    05    06    07    08    09    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31     TOTAL" 
	Elseif StrZero(mv_par01,2) == "02"
		If U_YIsBis(mv_par02)
			Cabec2 := "PRODUTOR                    01    02    03    04    05    06    07    08    09    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29                 TOTAL" 
		Else 
			Cabec2 := "PRODUTOR                    01    02    03    04    05    06    07    08    09    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28                       TOTAL" 		
		EndIf
	Else
		Cabec2 := "PRODUTOR                    01    02    03    04    05    06    07    08    09    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30           TOTAL" 
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos pedidos de acordo com os parametros informados pelo usuแrio. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	If (Select(cAliasTMP) <> 0)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	Endif


	cQuery := "SELECT 	ZL0.ZL0_COD,								" + hEnter
	cQuery += "			ZL0.ZL0_DESC,  								" + hEnter
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
	cQuery += "AND 		( ZL0.ZL0_COD  BETWEEN '" + mv_par03 + "' 	" + hEnter
	cQuery += "AND                 		       '" + mv_par04 + "' )	" + hEnter	
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 					" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 					" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_    != '*' 					" + hEnter
	cQuery += "ORDER BY ZL0.ZL0_COD, SA2.A2_NOME					" + hEnter
	

	memowrite("LTREL005_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
	 
	While (cAliasTMP)->(!EOF())
		AAdd ( aPROD, {(cAliasTMP)->ZL0_COD, (cAliasTMP)->ZL1_PRODUT, (cAliasTMP)->ZL1_LOJPRD, (cAliasTMP)->A2_NOME, {}, (cAliasTMP)->ZL0_DESC } )
		
		For nI := 0 to nTOTD
			AAdd ( aPROD[Len(aPROD),5], { ( dSTART_DATE + nI ), 0 } )
		Next nI

		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
		
	For nI := 0 to nTOTD
		AAdd ( aTOTAL, { ( dSTART_DATE + nI ), 0 } )
	Next nI	

	cQuery := "SELECT 	SUM(ZL6.ZL6_QTDE) ZL6_QTDE,  							" + hEnter
	cQuery += "			ZL5.ZL5_LINHA,  										" + hEnter
	cQuery += "			ZL5.ZL5_DATA,											" + hEnter
	cQuery += "			ZL6.ZL6_PRODUT,											" + hEnter
	cQuery += "			ZL6.ZL6_LOJPRD,											" + hEnter
	cQuery += "			SA2.A2_NOME												" + hEnter
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5								" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   						" + hEnter
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL              		" + hEnter		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                 		" + hEnter		
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   					" + hEnter
	cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                " + hEnter		
	cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            " + hEnter		
	cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "' 			" + hEnter
	cQuery += "AND 		( ZL5.ZL5_LINHA   BETWEEN '" + mv_par03 + "' 			" + hEnter
	cQuery += "AND                 		    	  '" + mv_par04 + "' )			" + hEnter
	cQuery += "AND 		( ZL5.ZL5_DATA    BETWEEN '" + DTOS(dSTART_DATE) + "' 	" + hEnter
	cQuery += "AND                          	  '" + DTOS(dEND_DATE)   + "' )	" + hEnter
	cQuery += "AND 		ZL5.D_E_L_E_T_   != '*' 								" + hEnter
	cQuery += "AND 		ZL6.D_E_L_E_T_   != '*' 								" + hEnter            
	cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 								" + hEnter
	cQuery += "GROUP BY ZL5.ZL5_LINHA,  										" + hEnter            
	cQuery += "			ZL5.ZL5_DATA,											" + hEnter	
	cQuery += "			ZL6.ZL6_PRODUT,  										" + hEnter            
	cQuery += "			ZL6.ZL6_LOJPRD,  										" + hEnter            
	cQuery += "			SA2.A2_NOME												" + hEnter	
	cQuery += "ORDER BY ZL5.ZL5_LINHA,  										" + hEnter            
	cQuery += "			ZL5.ZL5_DATA											" + hEnter	

	memowrite("LTREL005_2.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua(RecCount(cAliasTMP))
	 
	While (cAliasTMP)->(!EOF())

		nPOS1 := aScan(aPROD ,{ |x| x[1] == (cAliasTMP)->ZL5_LINHA  .and. ;
			                        x[2] == (cAliasTMP)->ZL6_PRODUT .and. ;
			                        x[3] == (cAliasTMP)->ZL6_LOJPRD })	
		
		If nPOS1 != 0
			
			nPOS2 := aScan(aPROD[nPOS1][5], { |x| x[1] == stod((cAliasTMP)->ZL5_DATA) })			                   
			
		Else
			dbSelectArea("ZL0")
			dbSetOrder(1)
			dbGoTop()
			dbSeek ( xFilial("ZL0") + (cAliasTMP)->ZL5_LINHA )
			
			AAdd ( aPROD, {ZL0->ZL0_COD, (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->A2_NOME, {}, ZL0->ZL0_DESC } )
			
			For nI := 0 to nTOTD
				AAdd ( aPROD[Len(aPROD),5], { ( dSTART_DATE + nI ), 0 } )
			Next nI	  
					
			nPOS1 := Len(aPROD)			
			nPOS2 := aScan(aPROD[nPOS1][5], { |x| x[1] == stod((cAliasTMP)->ZL5_DATA) })			                   
			
		EndIf

		If nPOS1 != 0 .and. nPOS2 != 0
			aPROD[nPOS1][5][nPOS2][2] := (cAliasTMP)->ZL6_QTDE 
		EndIf		

    	(cAliasTMP)->(dbSkip())    
	Enddo
	(cAliasTMP)->(dbCloseArea())
    
	// ordem - c๓digo linha + nome produtor
	aSort( aPROD , , , { |x,y| x[1]+x[4] < y[1]+y[4] } )     


    // verifico os registros sem movimentos
    If mv_par05 == 1
    	aPOSDEL := {}
	    If Len(aPROD) > 0
			For nI := 1 to Len(aPROD)
				For nD := 1 to (nTOTD+1)
					nTOTPRD += aPROD[nI][5][nD][2]
				Next nD
				If nTOTPRD == 0
					aAdd ( aPOSDEL, nI )
				EndIf
				nTOTPRD := 0
			Next nI
		EndIf 
		
	EndIf
				
    // impressใo dos registros
    If Len(aPROD) > 0
		For nI := 1 to Len(aPROD)
			
			If mv_par05 == 1
				lImp := .T.
				If Len(aPOSDEL) > 0
					For nD := 1 to Len(aPOSDEL)
						If aPOSDEL[nD] == nI
							lImp := .F.
							Exit
						EndIf
					Next nD					
				EndIf
				If  ! lImp
					Loop
				EndIf
			EndIf
			
			
			For nD := 1 to (nTOTD+1)

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
		
				If cCODLIN != aPROD[nI][1]
					
					If cCODLIN != STRING_Null
						
						If Len(aTOTAL) > 0
							fTotal(@aTOTAL, nTOTGRL, nTOTD, @nCol, @nLin)	
						EndIf 
												
						nTOTPRD := 0
						nTOTGRL := 0
						nLin    := 9
						nCol    := 0
						
					EndIf
		
					/*
			                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
			            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
			            -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					    PRODUTOR                    01    02    03    04    05    06    07    08    09    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31      TOTAL 
					*/  
					
					Cabec1 := "LINHA: " + aPROD[nI][1] +"/"+SubSTR(aPROD[nI][6],1,40) + " - PERIODO: " + dtoc(dSTART_DATE) + " A " + dtoc(dEND_DATE)				
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                       
				    nLin := 9
				
				EndIf                                  
				
				If nLin > 66					
					Cabec1 := "LINHA: " + aPROD[nI][1] +"/"+SubSTR(aPROD[nI][6],1,40) + " - PERIODO: " + dtoc(dSTART_DATE) + " A " + dtoc(dEND_DATE)				
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
					nLin := 9                                      
				 EndIf
		        
		        If nCol == 0		        	
					@nLin,nCol PSAY aPROD[nI][2]+" "+SubSTR(aPROD[nI][4],1,13)
					nCol := 20
				EndIf
				
				nCol += 6
				@nLin,nCol PSAY TRANSFORM(aPROD[nI][5][nD][2],"@E 99999")
				
				cCODLIN := aPROD[nI][1]
				nTOTPRD += aPROD[nI][5][nD][2]
				nTOTGRL += aPROD[nI][5][nD][2]
				aTOTAL[nD][2] += aPROD[nI][5][nD][2]
				
            Next nD
                                 
            @nLin,214 PSAY TRANSFORM(nTOTPRD,"@E 999999")
            
            nLin    += 1
            nCol    := 0
            nTOTPRD := 0
            
   		Next nI
    EndIf
    

	If Len(aTOTAL) > 0
		fTotal(@aTOTAL, nTOTGRL, nTOTD, @nCol, @nLin)
	EndIf

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
ฑฑบPrograma  ณfTotal     บAutor  ณRafael Parma       บ Data ณ  18/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para impressใo dos totalizadores.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function fTotal(aTOTAL, nTOTGRL, nTOTD, nCol, nLin)
             
	nLin += 1
	@nLin,000 PSAY __PrtThinLine()
	nLin += 1
	@nLin,000 PSAY "TOTAL"
	nCol := 20
	For nJ := 1 to (nTOTD+1)
		nCol += 6
		@nLin,nCol PSAY TRANSFORM(aTOTAL[nJ][2],"@E 99999")
		aTOTAL[nJ][2] := 0
	Next nJ
	@nLin,214 PSAY TRANSFORM(nTOTGRL,"@E 999999")
	nLin += 1
	@nLin,000 PSAY __PrtThinLine()	
		
Return    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  18/11/09   บฑฑ
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
Local i,j := 0
aRegs  := {}
aHelp01 := {}  
aHelp02 := {} 
aHelp03 := {}  
aHelp04 := {}                                                  
aHelp05 := {}  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","M๊s                ?","M๊s                ?","M๊s                ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0501."})
	aAdd(aRegs,{cPerg,"02","Ano                ?","Ano                ?","Ano                ?","mv_ch2","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL0502."})
	aAdd(aRegs,{cPerg,"03","Linha De           ?","Linha De           ?","Linha De           ?","mv_ch3","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0503."})
	aAdd(aRegs,{cPerg,"04","Linha At้          ?","Linha At้          ?","Linha At้          ?","mv_ch4","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL0504."})
	aAdd(aRegs,{cPerg,"05","Imprimir Zerados   ?","Imprimir Zerados   ?","Imprimir Zerados   ?","mv_ch5","N",01,0,1,"C","","mv_par05","Nao","Nao","Nao","","","Sim","Sim","Sim","","","","","","","","","","","","","","","","", "","","",".LTREL0505."})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Help de cada item do Grupo de Perguntasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD( aHelp01, "Informe o m๊s a ser impresso.            " )       
	AADD( aHelp02, "Informe o ano a ser impresso.            " )       
	AADD( aHelp03, "Informe o n๚mero inicial da linha        " )       
	AADD( aHelp03, "a ser impressa.                          " )       
	AADD( aHelp04, "Informe o n๚mero final da linha          " )       
	AADD( aHelp04, "a ser impressa.                          " )       
	AADD( aHelp05, "Informe se deseja imprimir os registros  " )       
	AADD( aHelp05, "de produtores sem movimenta็๕es.         " )      
	
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
	PutSX1Help("P.LTREL0501.",aHelp01,aHelp01,aHelp01)
	PutSX1Help("P.LTREL0502.",aHelp02,aHelp02,aHelp02)
	PutSX1Help("P.LTREL0503.",aHelp03,aHelp03,aHelp03)
	PutSX1Help("P.LTREL0504.",aHelp04,aHelp04,aHelp04)
	PutSX1Help("P.LTREL0505.",aHelp05,aHelp05,aHelp05)
	
Return Nil
