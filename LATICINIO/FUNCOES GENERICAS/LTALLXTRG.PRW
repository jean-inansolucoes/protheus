#include "protheus.ch"         
#include "topconn.ch"           
#include "protheus.ch"
#include "rwmake.ch"           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTALLXTRG  บAutor  ณRafael Parma       บ Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina a qual contempla todas as fun็๕es usadas em gatilhos.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTTRG001      บAutor  ณRafael Parma      Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de preenchimento de dados na tela de inclusใo de da- บฑฑ
ฑฑบ          ณdos da coleta de leite do produtor (LTMOV001).              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณcLinha = Linha de coleta de leite.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*-----------------------------------------*
User Function LTTRG001( cLinha, dDataMov )
*-----------------------------------------*
Local nRecord     := 0
Local nP_NOMPRD   := 4	// posicao do campo ZL4_NOMPRD no aCols
Local nW, nT
Local nLenTRANSP  := TamSX3("ZL5_TRANSP")[1]
Local nLenNOMTRP  := TamSX3("ZL5_NOMTRP")[1]
//Local STRING_Null := ""                  
Local nSizeRecord := Len(oGetD:aCols)
Local nSizeField  := Len(oGetD:aCols[1])
Local aArea       := GetArea()
Local cAliasCAB   := "ZL0"
Local cAliasDET   := "ZL1"
Local cAliasTMP   := GetNextAlias()
Local hEnter	  := CHR(10) + CHR(13) 
Local cMV_ZLTPLC  := ALLTRIM(GETMV("MV_ZLTPLC"))
    
    aOrdemCPO := {}
	dbSelectArea("SX3")
	dbSetOrder(2)               
	dbseek("ZL6_SEQ")
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_SEQ", 	.F., 0 } )
	dbseek("ZL6_PRODUT")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_PRODUT", .F., 0 } )
	dbseek("ZL6_LOJPRD")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_LOJPRD", .F., 0 } )
	dbseek("ZL6_NOMPRD")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_NOMPRD", .F., 0 } )
	dbseek("ZL6_QTDE")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_QTDE",	 .F., 0 } )
	dbseek("ZL6_AMOSTR")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_AMOSTR", .F., 0 } )
	dbseek("ZL6_TANQUE")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_TANQUE", .F., 0 } )
	dbseek("ZL6_TEMPER")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_TEMPER", .F., 0 } )
	dbseek("ZL6_HORCOL")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_HORCOL", .F., 0 } )
	dbseek("ZL6_DTCOL")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_DTCOL", .F., 0 } )
	dbseek("ZL6_PLACA")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_PLACA", .F., 0 } )
	dbseek("ZL6_SEQZL7")    
	aAdd( aOrdemCPO, { val(SX3->X3_ORDEM), "ZL6_SEQZL7", .F., 0 } )
	
	
	For nW := 1 to Len(aOrdemCPO)
		nSEQSUP := 99
		For nT := 1 to Len(aOrdemCPO)
			If ! aOrdemCPO[nT,03] .and. aOrdemCPO[nT,01] < nSEQSUP
				nSEQSUP := aOrdemCPO[nT,01]
			EndIf
		Next nT
		For nT := 1 to Len(aOrdemCPO)
			If ! aOrdemCPO[nT,03] .and. nSEQSUP == aOrdemCPO[nT,01]
				aOrdemCPO[nT,03] := .T.
				aOrdemCPO[nT,04] := nW
				Exit
			EndIf
		Next nT
	Next nW
    
    
    If Empty (dDataMov)
    	U_LTALL001 ("Coleta do produtor","Data do movimento em branco!","Favor preencher a data do movimento.")
		
		// alimenta os campos do cabe็alho
		M->ZL5_TRANSP := Space(nLenTRANSP)
		M->ZL5_NOMTRP := Space(nLenNOMTRP)
			
		// limpeza do array de itens, caso jแ esteja preenchido.
		If cMV_ZLTPLC == "S"
		
			If nSizeRecord > 1
				oGetD:aCols := {}
				AADD(oGetD:aCols, {"", "", "", "", "", "", "", "", "", "", .F.})
				nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_SEQ" 	})
				oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := "001"
				nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_QTDE" })
				oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := 0
				nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_TEMPER" })
				oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := 0

			EndIf
			oGetD:oBrowse:Refresh()
	
		EndIf
		
		RestArea(aArea)
    	Return ( cLinha )
    EndIf
    
	dbSelectArea(cAliasCAB)
	(cAliasCAB)->(dbSetOrder(1))
	(cAliasCAB)->(dbGoTop())
	If dbSeek( xFilial(cAliasCAB) + cLinha )
		
		If ! Empty(M->ZL5_TRANSP)
			cTRANSP := M->ZL5_TRANSP
		Else                                  
			cTRANSP := (cAliasCAB)->ZL0_TRANSP
		EndIf
		
		// alimenta a quanditade da vazใo do transportador na data e linha
		cQuery := "	SELECT SUM(ZL7_QTDVAZ) ZL7_QTDVAZ						" + hEnter
		cQuery += "	FROM " + RetSQLName("ZL7") + " ZL7 						" + hEnter
		cQuery += " WHERE 													" + hEnter
		cQuery += " ZL7.ZL7_FILIAL 		= '" + xFilial("ZL7") + "'   		" + hEnter		
		cQuery += " AND ZL7.ZL7_DATA    = '" + dtos(dDataMov) + "'   		" + hEnter
		cQuery += " AND ZL7.ZL7_TRANSP  = '" + cTRANSP 		  + "'			" + hEnter
		cQuery += " AND ZL7.ZL7_LINHA   = '" + cLinha 		  + "'   		" + hEnter
		cQuery += " AND ZL7.ZL7_TPROD  != 'O'								" + hEnter		
		cQuery += " AND ZL7.D_E_L_E_T_ != '*'								" + hEnter

		memowrite("LTTRG001_1.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)		
						
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		If ! Empty ( (cAliasTMP)->ZL7_QTDVAZ )
			M->ZL5_PLATF := (cAliasTMP)->ZL7_QTDVAZ
		Else 
			M->ZL5_PLATF := 0
		EndIf
				
		(cAliasTMP)->(dbCloseArea())
		
		If M->ZL5_PLATF == 0
			U_LTALL001 ("Coleta do produtor","Movimento do transportador inexistente!","Favor efetuar o movimento do transportador para esta linha e dada.")

			// alimenta os campos do cabe็alho
			M->ZL5_TRANSP := Space(nLenTRANSP)
			M->ZL5_NOMTRP := Space(nLenNOMTRP)			
			
			
			If cMV_ZLTPLC == "S"
				// limpeza do array de itens, caso jแ esteja preenchido.
				If nSizeRecord > 1
					oGetD:aCols := {}
					AADD(oGetD:aCols, {"", "", "", "", "", "", "", "", "", "", .F.})
					nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_SEQ" 	})
					oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := "001"
					nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_QTDE" })
					oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := 0					
					nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_TEMPER" })
					oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := 0
						
				EndIf
				
				oGetD:oBrowse:Refresh()
			EndIf
				
			RestArea(aArea)			
			Return ( cLinha )
		
		EndIf 	    	
	
		// alimenta os campos do cabe็alho
		M->ZL5_TRANSP := cTRANSP
		M->ZL5_NOMTRP := Posicione("SA4",1,xFilial("SA4")+cTRANSP,"A4_NOME")
		
		If cMV_ZLTPLC == "S"	
			// limpeza do array de itens, caso jแ esteja preenchido.
			If nSizeRecord > 1
				oGetD:aCols := {}
				AADD(oGetD:aCols, {"", "", "", "", "", "", "", "", "", "", .F.})
				nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_SEQ" 	})
				oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := "001"
				nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_QTDE" })
				oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := 0				
				nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_TEMPER" })
				oGetD:aCols[Len(oGetD:aCols),aOrdemCPO[nPOS,04]] := 0
				
			EndIf            
	        // alimenta os campos de itens
			dbSelectArea(cAliasDET)
			(cAliasDET)->(dbSetOrder(1))
			(cAliasDET)->(dbGoTop())
			If dbSeek( xFilial(cAliasDET) + cLinha )
				While !(cAliasDET)->(EOF()) .And. xFilial(cAliasDET) == (cAliasCAB)->ZL0_FILIAL .And. (cAliasDET)->ZL1_COD == (cAliasCAB)->ZL0_COD
					nRecord += 1		      
					(cAliasDET)->(dbSkip())
				EndDo                                                                                                                      
				If nRecord != 0    
					nI := 0           				
					dbSelectArea(cAliasDET)
					(cAliasDET)->(dbSetOrder(1))
					(cAliasDET)->(dbGoTop())
					If dbSeek( xFilial(cAliasDET) + cLinha )
						While !(cAliasDET)->(EOF()) .And. xFilial(cAliasDET) == (cAliasCAB)->ZL0_FILIAL .And. (cAliasDET)->ZL1_COD == (cAliasCAB)->ZL0_COD
							nI += 1
							If nI == 1
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_SEQ" 	})
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := StrZERO(nI,3)
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_QTDE" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := 0							
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_PRODUT" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := (cAliasDET)->ZL1_PRODUT						
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_LOJPRD" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := (cAliasDET)->ZL1_LOJPRD						
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_NOMPRD" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := (cAliasDET)->ZL1_NOMPRD							
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_AMOSTR" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_AMOSTR")[1])
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_TANQUE" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_TANQUE")[1])
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_TEMPER" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := 0
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_HORCOL" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_HORCOL")[1])
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_DTCOL" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := M->ZL5_DATA
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_PLACA" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_PLACA")[1])
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_SEQZL7" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_SEQZL7")[1])
								oGetD:aCols[nI,13]:= .F.
							ElseIf nI != 1
								aadd(oGetD:aCols,Array(nSizeField))
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_SEQ" 	})
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := StrZERO(nI,3)
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_QTDE" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := 0							
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_PRODUT" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := (cAliasDET)->ZL1_PRODUT						
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_LOJPRD" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := (cAliasDET)->ZL1_LOJPRD						
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_NOMPRD" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := (cAliasDET)->ZL1_NOMPRD
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_AMOSTR" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_AMOSTR")[1])																
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_TANQUE" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_TANQUE")[1])
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_TEMPER" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := 0
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_HORCOL" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_HORCOL")[1])
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_DTCOL" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := M->ZL5_DATA
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_PLACA" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_PLACA")[1])
								nPOS := aScan(aOrdemCPO,{|x| x[2] == "ZL6_SEQZL7" })
								oGetD:aCols[nI,aOrdemCPO[nPOS,04]] := Space(TAMSX3("ZL6_SEQZL7")[1])

								oGetD:aCols[nI,13]:= .F.
							EndIf 					
							(cAliasDET)->(dbSkip())
						EndDo                                                                                                                     
					EndIf
				EndIf	
			EndIf
	
			aSort( oGetD:aCols , , , { |x,y| x[nP_NOMPRD] < y[nP_NOMPRD] } )		
			oGetD:oBrowse:Refresh()	
		
		EndIf
		
	EndIf
	RestArea(aArea)
	
Return ( cLinha )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTTRG002      บAutor  ณRafael Parma      Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de preenchimento de dados na tela de inclusใo de da- บฑฑ
ฑฑบ          ณdos da coleta de leite do transportador (LTMOV002).         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณcLinha = Linha de coleta de leite.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*-------------------------------*
User Function LTTRG002( cLinha )
*-------------------------------*
Local aArea     := GetArea()
Local cAliasCAB := "ZL0"
         
	dbSelectArea(cAliasCAB)
	(cAliasCAB)->(dbSetOrder(1))
	(cAliasCAB)->(dbGoTop())
	If dbSeek( xFilial(cAliasCAB) + cLinha )
		// alimenta os campos do cabe็alho
		M->ZL7_TRANSP := (cAliasCAB)->ZL0_TRANSP
		M->ZL7_NOMTRP := (cAliasCAB)->ZL0_NOMTRP
		M->ZL7_DATA   := dDataBase
	EndIf                             
	
	RestArea(aArea)
	
Return ( cLinha )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTTRG003      บAutor  ณRafael Parma      Data ณ  30/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para preenchimento automแtico da tabela de pre็o por บฑฑ
ฑฑบ          ณfaixa ou tabela de exce็ใo do produtor. (LTMOV001).         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณcProdut = C๓digo do produtor                                บฑฑ
ฑฑบ          ณcLoja   = Loja do produtor                                  บฑฑ
ฑฑบ          ณcLinha  = C๓digo da linha                                   บฑฑ
ฑฑบ          ณnQtde   = Quantidade do movimento                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*-------------------------------------------------------*
User Function LTTRG003( cProdut, cLoja, cLinha, nQtde )
*-------------------------------------------------------*
Local aArea     := GetArea()
Local cTabela   := ""
Local lFlag     := .F.
    
    If nQtde <= 0
		RestArea ( aArea )	
		Return ( cTabela )    
    EndIf
         
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbGoTop())
	If dbSeek( xFilial("SA2") + cProdut + cLoja )
		If ! Empty ( SA2->A2_X_FAIXA )
			lFlag   := .T.
			cTabela := SA2->A2_X_FAIXA
		EndIf			
	EndIf
	
	If ! lFlag
		dbSelectArea("ZL2")
		ZL2->(dbSetOrder(2))
		ZL2->(dbGoTop())
		If dbSeek( xFilial("ZL2") + cLinha )
			While !ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLinha
				If nQtde >= ZL2->ZL2_FXINI .and. nQtde <= ZL2->ZL2_FXFIN
					lFlag   := .T.
					cTabela := ZL2->ZL2_COD
					Exit
				EndIf
				ZL2->(dbSkip())
			Enddo
		EndIf			
	EndIf                             
	                                                      
	If ! lFlag
		U_LTALL001("Entrada do Produtor", "Tabela de pre็o nใo existente para esta linha e quantidade de litros!", "Incluir tabela de pre็o para a linha e quantidade.")
	EndIf     
	
	RestArea ( aArea )
	
Return ( cTabela )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTVAL001      บAutor  ณRafael Parma      Data ณ  05/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo de lancamento de coleta de leite do produtor na   บฑฑ
ฑฑบ          ณmesma data e linha de coleta (LTMOV001).                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณcLinha = Linha de coleta de leite.                          บฑฑ
ฑฑบParametrosณdData  = Data coleta de leite.                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*-------------------------------------------------*
User Function LTVAL001( cLinha, dData, cTransp )
*-------------------------------------------------*
Local aArea     := GetArea()
Local cAliasTMP := GetNextAlias()
Local lRet      := .T.
         
	If !Empty(cLinha) .and. !Empty(dData)

		cQuery := "	SELECT											"
		cQuery += "		ZL5.ZL5_DATA,								"
		cQuery += "		ZL5.ZL5_LINHA								"
		cQuery += "	FROM " + RetSQLName("ZL5") + " ZL5				"
		cQuery += "	WHERE											"
		cQuery += "		ZL5.ZL5_DATA    = '" + dtos(dData) + "'		"
		cQuery += "	AND	ZL5.ZL5_LINHA   = '" + cLinha + "'			"
		If ALLTRIM(cTransp) == ""
			dbSelectArea("ZL0")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("ZL0")+cLinha)
				cTransp := ZL0->ZL0_TRANSP
			EndIf
		EndIf
		cQuery += "	AND	ZL5.ZL5_TRANSP  = '" + cTransp + "'			"
		cQuery += "	AND	ZL5.D_E_L_E_T_ != '*'						"
				
		memowrite("LTVAL001_1.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)		
						
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		If ! Empty ( (cAliasTMP)->ZL5_DATA ) .or. ! Empty ( (cAliasTMP)->ZL5_LINHA )
			lRet := .F.
		EndIf			
		(cAliasTMP)->(dbCloseArea())

		If ! lRet
			U_LTALL001("Entrada do Produtor", "Movimento jแ existente para esta linha, data e transportador.", "Altere o c๓digo da linha e/ou data.")
		EndIf
	                         
	EndIf
	
	RestArea(aArea)
	
Return ( lRet )

                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTTRGDTV      บAutor  ณRafael Parma      Data ณ  28/01/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilho sobre campo ZLB_FORNEC-ZLB_LOJFOR para atualizacao  บฑฑ
ฑฑบ          ณdo campo ZLB_DTVCTO com data vencimento do fornecedor.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*-------------------------------*
User Function LTTRGDTV(dDtMov)
*-------------------------------*

Local dRET := ddatabase
//Local aArea := GetArea()
Local cMV_ZLTMCC  := "902" //Condicao pagamento dos titulos a receber do produtor //AllTRIM(GetMV("MV_ZLTMCC"))		// c๓digo da condi็ใo de pagamento padrao

If dDtMov != NIL .And. dDtMov != ctod("  /  /  ")
	dRET := dDtMov
EndIf

	//-- utiliza condi็ใo pagamento do produtor
   /*	If SuperGetMV("MV_ZLUCPP",,.F.)
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("SA2") + SubSTR(M->ZLB_FORNEC,1,TAMSX3("A2_COD")[1]) + SubSTR(M->ZLB_LOJFOR,1,TAMSX3("A2_LOJA")[1]) )
			If !Empty(SA2->A2_COND)
				aPARCELA := Condicao(1,SA2->A2_COND,,dRET)
				dRET := aPARCELA[01][01]
			EndIf
		EndIf
	ElseIf cMV_ZLTCPG != ""
		aPARCELA := Condicao(1,cMV_ZLTCPG,,dRET)
		dRET := aPARCELA[01][01]
	EndIf */
	aPARCELA := Condicao(1,cMV_ZLTMCC,,dRET)
	dRET := aPARCELA[01][01]
		
Return (dRET)    



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTTRGDES      บAutor  ณRafael Parma      Data ณ  01/08/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilho sobre campo ZLB_DESDOB-ZLB_DESDOB para abertura da  บฑฑ
ฑฑบ          ณjanela de desdobramento.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*-------------------------------*
User Function LTTRGDES()
*-------------------------------*
Local cRet := M->ZLB_DESDOB

	If cRet == "S" .and. lInclui
		If ! U_LTMOV04M()
			cRet := "N"
		EndIf
	EndIf

Return (cRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTTRG004      บAutor  ณRafael Parma      Data ณ  14/02/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para calculo do saldo do produtor no lan็amento do   บฑฑ
ฑฑบ          ณmovimento do conta corrente, campo ZLB_SALDO.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณcProdut = C๓digo do produtor                                บฑฑ
ฑฑบ          ณcLoja   = Loja do produtor                                  บฑฑ
ฑฑบ          ณdPeriodo= Data perํodo movimentos                           บฑฑ
ฑฑบ          ณdVencto = Data vencimento movimentos                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*--------------------------------------------------------------*
User Function LTTRG004( cCODPRD, cLOJPRD, dPeriodo, dVencto )
*--------------------------------------------------------------*

Local cAliasTMP  := GetNextAlias()
Local dINI_COL   := ctod("01/"+StrZERO(Month(dPeriodo),2)+"/"+StrZERO(Year(dPeriodo),4))	//-- primeiro dia do perํodo
Local dFIN_COL   := dINI_COL																//-- ๚ltimo dia do perํodo
Local dINI_VCT   := ctod("01/"+StrZERO(Month(dVencto),2)+"/"+StrZERO(Year(dVencto),4))	//-- primeiro dia do perํodo vencimento
Local dFIN_VCT   := dINI_VCT																//-- ๚ltimo dia do perํodo vencimento
Local nSALDO	 := 0                     
Local lATPERCFOR := SuperGetMV("MV_ZLATPN",,.F.)	// Ativo controle de percentual s/ fornecedor p/ gerar documento 
Local lTITFRETE  := SuperGetMV("MV_ZLHTFR",,.F.)	// Habilita gera็ใo de tํtulos de frete a pagar/receber no fechamento mensal do produtor.
Local nFUNRURAL  := 0
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// c๓digo da TES de movimento
Local nAlsenar := POSICIONE("SF4",1,xFilial("SF4")+cMV_ZLTTES,"F4_ALSENAR")
Local nAlInss   := 0

	//--Define perํodo entrega de leite
	If U_YIsBis(Year(dPeriodo)) 
		dFIN_COL := ctod(Iif(StrZero(Month(dPeriodo),2)$"01/03/05/07/08/10/12","31",Iif(StrZero(Month(dPeriodo),2)=="02","29","30"))+"/"+StrZero(Month(dPeriodo),2)+"/"+StrZero(Year(dPeriodo),4))
    Else
		dFIN_COL := ctod(Iif(StrZero(Month(dPeriodo),2)$"01/03/05/07/08/10/12","31",Iif(StrZero(Month(dPeriodo),2)=="02","28","30"))+"/"+StrZero(Month(dPeriodo),2)+"/"+StrZero(Year(dPeriodo),4))   
    EndIf


	//--Define perํodo vencimento tํtulos
	If U_YIsBis(Year(dVencto)) 
		dFIN_VCT := ctod(Iif(StrZero(Month(dVencto),2)$"01/03/05/07/08/10/12","31",Iif(StrZero(Month(dVencto),2)=="02","29","30"))+"/"+StrZero(Month(dVencto),2)+"/"+StrZero(Year(dVencto),4))
    Else
		dFIN_VCT := ctod(Iif(StrZero(Month(dVencto),2)$"01/03/05/07/08/10/12","31",Iif(StrZero(Month(dVencto),2)=="02","28","30"))+"/"+StrZero(Month(dVencto),2)+"/"+StrZero(Year(dVencto),4))   
    EndIf


	//--Posiciona sobre fornecedor
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek ( xFilial("SA2") + cCODPRD + cLOJPRD )
              

	//--Sele็ใo movimentos
	cQuery := "SELECT 	ZL5.ZL5_LINHA, 												" 
	cQuery += "			SUM(ZL6.ZL6_QTDE) ZL6_QTDE									" 
	cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" 
	cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" 
	cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          " 		
	cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             " 		
	cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "' 				" 
	cQuery += "AND 		ZL6.ZL6_PRODUT    = '" + cCODPRD        + "' 		  		" 
	cQuery += "AND 		ZL6.ZL6_LOJPRD    = '" + cLOJPRD        + "' 		  		" 
	cQuery += "AND 		( ZL5.ZL5_DATA       BETWEEN '" + DTOS(dINI_COL) + "'  		" 
	cQuery += "AND      	                    	 '" + DTOS(dFIN_COL) + "' )		" 
	cQuery += "AND 		ZL5.ZL5_STATUS         = '' 								" 
	cQuery += "AND 		ZL6.ZL6_QTDE           > 0 									" 
	cQuery += "AND 		ZL5.D_E_L_E_T_        != '*' 								" 
	cQuery += "AND 		ZL6.D_E_L_E_T_        != '*' 								" 
	cQuery += "GROUP BY ZL5.ZL5_LINHA 												" 
    
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

	nTOT_DESP := 0
	nTOT_CRED := 0
	nTOT_PROD := 0             
	nTOT_QTDE := 0
	nPRC_ULIQ := 0    
	nPRC_FRET := 0		

	//--Calculo da produ็ใo
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())   
	While ! (cAliasTMP)->(EOF())          
	
		nVLR_PROD := 0
		nPRC_LITR := 0		
		fCalcProd( 2, cCODPRD, cLOJPRD, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL6_QTDE, @nPRC_LITR, @nVLR_PROD, @nPRC_FRET )
   		
   		//--Pre็o unitแrio liquido
   		nPRC_ULIQ := nPRC_LITR - nPRC_FRET
   		//--Total produ็ใo
   		nTOT_PROD += nVLR_PROD
   		//--Quantidade total
   		nTOT_QTDE += (cAliasTMP)->ZL6_QTDE
   		
   		(cAliasTMP)->(dbSkip())		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	
	//--Movimentos financeiros
	fTotalDesp( dINI_VCT, dFIN_VCT, cCODPRD, cLOJPRD, @nTOT_DESP, @nTOT_CRED )                				
	
	//--Calculo FUNRURAL
	cTipoRur  := SA2->A2_TIPORUR
	aPFunRur  := FunRur()
	nPosPer   := at(cTipoRur,"FLJ")
	nPCFAT    := SA2->A2_X_PCDOC
	nAlInss := POSICIONE("SED",1,XFILIAL("SED")+SA2->A2_NATUREZ,"ED_PERCINS")
	If nPosPer > 0 
		If cTipoRur != "J"
			If cTipoRur = "F"
				nAliquota := Val(aPFunRur[nPosPer]) + nAlsenar + nAlInss
			ElseIf cTipoRur = "L"
				nAliquota := nAlsenar
			EndIf
			If SA2->A2_X_PCONT > 0
				nAliquota := SA2->A2_X_PCONT + nAlsenar
			EndIf
	
			//-- Controle de serie de nota fiscal diferentes.
			If lATPERCFOR		
				nFUNRURAL := ( (nTOT_PROD * nPCFAT / 100) * nAliquota) /100
				nPRC_ULIQ := nPRC_ULIQ - (( (nPRC_ULIQ * nPCFAT / 100) * nAliquota) /100)
			Else		
				If (nTOT_PROD > 0 .AND. nAliquota > 0)
			   		nFUNRURAL := (nTOT_PROD * nAliquota) /100
					nPRC_ULIQ := nPRC_ULIQ - ((nPRC_ULIQ * nAliquota) /100)
				EndIf
			EndIf
		EndIf
	EndIf 
	                                              
	//--Calculo do saldo
	nSALDO  := Round( (nTOT_PROD + nTOT_CRED) - ( nFUNRURAL + nTOT_DESP ), 2) 
	
	If lTITFRETE

		//--Posiciona sobre fornecedor
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek ( xFilial("SA2") + cCODPRD + cLOJPRD )
		
		If fCheckTPF() .AND. nPRC_FRET > 0	//Verifica se transportador ้ pessoa fํsica
			nVLRTRANSP := Round(nPRC_FRET * nTOT_QTDE, 2 ) 
			nSALDO := nSALDO - nVLRTRANSP                                                                                         		
		EndIf
	EndIf                               
	

Return (nSALDO)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotalDesp บAutor  ณRafael Parma       บ Data ณ  14/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para cแlculo das receitas/despesas do produtor.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------------------------------------------------------------*        
Static Function fTotalDesp( dINI_VCT, dFIN_VCT, cPRODUT, cLOJPRD, nVLR_DESP, nVLR_CRED )            
*----------------------------------------------------------------------------------------------------*        
Local cAliasTMP  := GetNextAlias()
//Local hEnter	 := CHR(10) + CHR(13) 
Local lIMPSE1    := SuperGetMV("MV_ZLISE1",,.F.) 
Local lIMPSE2    := SuperGetMV("MV_ZLISE2",,.F.) 

	nVLR_DESP  := 0
	nVLR_CRED  := 0 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ DEBITO CONTA CORRENTE												    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	cQuery := "SELECT 	                   									" 
	cQuery += "			SUM(ZLB.ZLB_VALOR) ZLB_VALOR						"   
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" 
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" 
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " 		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" 
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" 
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" 
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(dINI_VCT) + "'   	" 
	cQuery += "AND      				       '" + DTOS(dFIN_VCT) + "'	    " 	
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'D'							    " 
	cQuery += "AND 		ZLB.ZLB_STATUS    = ' '								" 		
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" 
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" 
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" 

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())
		nVLR_DESP += (cAliasTMP)->ZLB_VALOR
    EndIf
    (cAliasTMP)->(dbCloseArea())           

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
	//ณSeleciona todos os tํtulos em aberto do contas a receber p/ o produtor         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

	If lIMPSE1
		dbSelectArea("SA1")
		dbSetOrder(14) 	// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
		dbGoTop()
		If dbSeek ( xFilial("SA1") + SubSTR(cPRODUT,1,TAMSX3("A2_COD")[1]) + SubSTR(cLOJPRD,1,TAMSX3("A2_LOJA")[1]) )		
	
			cQuery := "	SELECT  SE1.E1_TIPO,											" 
			cQuery += "			SUM(SE1.E1_SALDO) E1_SALDO								" 
			cQuery += "	FROM " + RetSqlName("SE1") + " SE1								" 	
			cQuery += "	WHERE   SE1.E1_FILIAL    = '" + xFilial("SE1") + "' 			" 
			cQuery += "	AND     SE1.E1_CLIENTE   = '" + SA1->A1_COD  + "'				" 
			cQuery += "	AND     SE1.E1_LOJA      = '" + SA1->A1_LOJA + "'				" 
			cQuery += "	AND     SE1.E1_VENCREA BETWEEN '" + dtos(dINI_VCT) + "'			" 
			cQuery += "	AND     					   '" + dtos(dFIN_VCT) + "'			" 
			cQuery += "	AND     SE1.E1_SALDO     > 0									" 
			cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" 
			cQuery += "	GROUP BY SE1.E1_TIPO											" 
		
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)				
			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			
			While ! (cAliasTMP)->(EOF())
				If ALLTRIM((cAliasTMP)->E1_TIPO) == "RA" .OR. (cAliasTMP)->E1_TIPO == "NCC"
					nVALORCR := (cAliasTMP)->E1_SALDO * -1
				Else
					nVALORCR := (cAliasTMP)->E1_SALDO
				EndIf				
				nVLR_DESP += nVALORCR
				(cAliasTMP)->(dbSkip())
		    EndDo
	    	(cAliasTMP)->(dbCloseArea())   
	 
	 	EndIf
	 EndIf
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ CREDITO CONTA CORRENTE												    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

	cQuery := "SELECT 	               										" 
	cQuery += "			SUM(ZLB.ZLB_VALOR) ZLB_VALOR						"   
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" 
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" 
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " 		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 		" 
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" 
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" 
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(dINI_VCT) + "'  	" 
	cQuery += "AND      				       '" + DTOS(dFIN_VCT) + "'  	" 
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'C'							    " 	
	cQuery += "AND 		ZLB.ZLB_STATUS    = ' '								" 
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" 			
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" 
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" 
                        
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	If !(cAliasTMP)->(EOF())
		nVLR_CRED += (cAliasTMP)->ZLB_VALOR
    EndIf
    (cAliasTMP)->(dbCloseArea()) 
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
	//ณSeleciona todos os tํtulos em aberto do contas a pagar p/ o produtor           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

	If lIMPSE2
		cQuery := "	SELECT 	SE2.E2_TIPO,														" 
		cQuery += "			SUM(SE2.E2_SALDO) E2_SALDO											" 
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2											" 	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xFilial("SE2") + "' 						" 
		cQuery += "	AND     SE2.E2_FORNECE   = '" + SubSTR(cPRODUT,1,TAMSX3("A2_COD")[1])  + "'	" 
		cQuery += "	AND     SE2.E2_LOJA      = '" + SubSTR(cLOJPRD,1,TAMSX3("A2_LOJA")[1]) + "'	" 
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dINI_VCT) + "'						" 
		cQuery += "	AND     					   '" + dtos(dFIN_VCT) + "'						" 
		cQuery += "	AND     SE2.E2_SALDO     > 0												" 
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 												" 
		cQuery += " GROUP BY SE2.E2_TIPO														" 
	
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)				
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		
		While !(cAliasTMP)->(EOF())
			If ALLTRIM((cAliasTMP)->E2_TIPO) == "PA" .OR. (cAliasTMP)->E2_TIPO == "NDF"
				nVALORCP := (cAliasTMP)->E2_SALDO * -1
			Else
				nVALORCP := (cAliasTMP)->E2_SALDO
			EndIf
			nVLR_CRED += nVALORCP
			(cAliasTMP)->(dbSkip())
	    EndDo
		(cAliasTMP)->(dbCloseArea())   
	EndIf
                  
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalcProd  บAutor  ณRafael Parma       บ Data ณ  14/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo do pre็o a ser pago ao produtor com base nas      บฑฑ
ฑฑบ          ณtabelas de pre็os por faixa ou tabela de exce็ใo.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/              
*----------------------------------------------------------------------------------------------------------------*        
Static Function fCalcProd( nEXCECAO, cPRODUT, cLOJPRD, cLINHA, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nPRC_FRETE )           
*----------------------------------------------------------------------------------------------------------------*        

	nVLR_PROD  := 0
	nPRC_LITRO := 0
	nPRC_FRETE := 0  
	
	If nEXCECAO == 1 	// Cadastro do produtor
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("SA2") + cPRODUT + cLOJPRD )
			If ! Empty ( SA2->A2_X_FAIXA )
				dbSelectArea("ZL2")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial("ZL2") + SA2->A2_X_FAIXA )
					nPRC_LITRO := ZL2->ZL2_PRCLEI
					nPRC_FRETE := ZL2->ZL2_PRCFRT	
				EndIf
			Else
				dbSelectArea("ZL2")
				dbSetOrder(2)
				dbGoTop()   
				If dbSeek ( xFilial("ZL2") + cLINHA )
					While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
						If nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
							nPRC_LITRO := ZL2->ZL2_PRCLEI
							nPRC_FRETE := ZL2->ZL2_PRCFRT
							Exit
						EndIf
						ZL2->(dbSkip())
					EndDo
				EndIf
			EndIf	
		EndIf 
		
    Else	// tabela de exce็๕es
    
		dbSelectArea("ZL2")
		dbSetOrder(3)	// ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
		dbGoTop()                                            
		If dbSeek ( xFilial("ZL2") + cLINHA + cPRODUT + cLOJPRD, .T. )
			nPRC_LITRO := ZL2->ZL2_PRCLEI                
			nPRC_FRETE := ZL2->ZL2_PRCFRT
		Else
			dbSelectArea("ZL2")
			dbSetOrder(2)	// // ZL2_FILIAL+ZL2_LINHA
			dbGoTop()   
			If dbSeek ( xFilial("ZL2") + cLINHA )
				While ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xFilial("ZL2") + cLINHA
					If nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
						nPRC_LITRO := ZL2->ZL2_PRCLEI
						nPRC_FRETE := ZL2->ZL2_PRCFRT
						Exit
					EndIf
					ZL2->(dbSkip())
				EndDo
			EndIf
		EndIf     
    
    EndIf
    
   	If nPRC_LITRO != 0
   		nVLR_PROD := Round ( nPRC_LITRO * nQTD_TOTAL , 4)
   	EndIf
   	

Return 




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCheckTPF   บAutor  ณRafael Parma       บ Data ณ  22/10/09  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se transportador ้ pessoa fํsica.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCheckTPF()
Local aAreaTMP := GetArea()
Local lRet := .F.
	                  
	//--Cadastro da linha do produtor posicionado.
	dbSelectArea("ZL0")
	dbSetOrder(1)
	If dbSeek ( xFilial("ZL0") + SA2->A2_X_LINHA )
	
		//--Transportador relacionado a linha.
		dbSelectArea("SA4")
		dbSetOrder(1)
		If dbSeek ( xFilial("SA4") + ZL0->ZL0_TRANSP )
			
			//--Fornecedor do transportador.
			If !Empty(SA4->A4_X_FORN) .and. !Empty(SA4->A4_X_LOJF)
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek ( xFilial("SA2") + SA4->A4_X_FORN + SA4->A4_X_LOJF )
					If SA2->A2_TIPO == "F"
						lRet := .T.
					EndIf
				EndIf
			EndIf
		
		EndIf
	
	EndIf

	RestArea(aAreaTMP)	

Return (lRet)
