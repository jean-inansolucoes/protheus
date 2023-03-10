#include "protheus.ch"
#include "rwmake.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT103MNT  ?Autor ?Totvs Paran? Central ? Data ?  04/10/11   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Ponto de entrada utilizado para execu??o das regras de      ???
???          ?rateio de multiplas naturezas financeiras automatico na     ???
???          ?inclus?o de documento fiscal de entrada.                    ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?Especifico Avicola Pato Branco                              ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function MT103MNT()
                    
Local cTipos		:= "N"
Local aNaturezas	:= {}
Local aHeadSEV 		:= PARAMIXB[1]   
Local aColsSEV 		:= PARAMIXB[2]
Local nPosProdSD1	:= aScan(aHeader ,{ |x| ALLTRIM(x[2]) == "D1_COD"})

//?????????????????????????????????????????????????????????????????????????????????????????????
//?Executa o processo caso o tipo do documento esteja entre os tipos que devem ser processados?
//?????????????????????????????????????????????????????????????????????????????????????????????
If MaFisRet(, "NF_TIPONF") $ cTipos .AND. GetMv("MV_MULNATP",,.F.)

	aColsSEV := {}
	
	//????????????????????????????????????????????????????????????????????????????????????????????
	//?Executa la?o para obter o valor total de todos os produtos existem no documento de entrada?
	//????????????????????????????????????????????????????????????????????????????????????????????
	For nI := 1 To Len(aCols)         
		lAchou 		:= .F.
		cNatureza	:= ""
		                 
		//????????????????????????????????????????????????????????????????????
		//?Considera o item do documento de entrada caso o mesmo possua valor?
		//?financeiro para duplicatas a pagar e n?o esteja exclu?do no aCols ?
		//????????????????????????????????????????????????????????????????????
		If MaFisRet(nI,"IT_BASEDUP") > 0 .AND. !aCols[nI][Len(aHeader) + 1]
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbGoTop())
			If SB1->(dbSeek(xFilial("SB1") + aCols[nI][nPosProdSD1]))
				If Len(aNaturezas) > 0   
					For nY := 1 To Len(aNaturezas)                         
					
						//????????????????????????????????????????????????????????????????
						//?Caso exista natureza no cadastro do produto, considera a mesma?
						//????????????????????????????????????????????????????????????????
						If !EMPTY(SB1->B1_X_NATUR)
							If SB1->B1_X_NATUR == "20301010"
								MSGALERT( "SB1->B1_COD", '' )
							EndIf
							If SB1->B1_X_NATUR == aNaturezas[nY][1]
								aNaturezas[nY][2] += MaFisRet(nI,"IT_BASEDUP")    
								lAchou := .T.
								exit      
							Else
								cNatureza := SB1->B1_X_NATUR
							EndIf        
						Else             
							
							//??????????????????????????????????????????????????????????????????????????????????????????????????
							//?N?o existindo natureza no cadastro do produto, verifica o grupo de produtos vinculado ao produto?
							//??????????????????????????????????????????????????????????????????????????????????????????????????
							dbSelectArea("SBM")
							SBM->(dbSetOrder(1))
							SBM->(dbGoTop())
							If SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO))
						 		If !EMPTY(SBM->BM_X_NATUR)
						 			If SBM->BM_X_NATUR == aNaturezas[nY][1]
							           	aNaturezas[nY][2] += MaFisRet(nI,"IT_BASEDUP")
										lAchou := .T.
										exit   
									Else
										cNatureza := SBM->BM_X_NATUR
									EndIf        
								EndIf 
							Else
								Alert("N?o existe natureza financeira para o produto\grupo de produtos")
							EndIf
						EndIf
					Next nY 
					
				Else   
					
					//?????????????????????????????????????????????????????????????????????????????
					//?Apenas carrega a natureza financeira vinculada ao produto\grupo de produtos?
					//?????????????????????????????????????????????????????????????????????????????
					If !EMPTY(SB1->B1_X_NATUR)
						cNatureza := SB1->B1_X_NATUR
					Else
						dbSelectArea("SBM")
						SBM->(dbSetOrder(1))
						SBM->(dbGoTop())
						If SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO))
					 		If !EMPTY(SBM->BM_X_NATUR)
					 			cNatureza := SBM->BM_X_NATUR  
					 		Else
								Alert("N?o existe natureza financeira para o produto\grupo de produtos")
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			//?????????????????????????????????????????????????????????????????
			//?Caso n?o tenha encontrado a natureza, adiciona a mesma no array?
			//?????????????????????????????????????????????????????????????????
			If !lAchou .AND. !EMPTY(cNatureza)
				AADD(aNaturezas, {cNatureza, MaFisRet(nI,"IT_BASEDUP")})
			EndIf
		EndIf		
	Next nI                                              
	
	//????????????????????????????????????????????????????????????????????????????????????
	//?Com base no array aNaturezas, executa regras de composi??o do rateio das naturezas?
	//????????????????????????????????????????????????????????????????????????????????????
	If Len(aNaturezas) > 0
		
		//??????????????????????????????????????????????????
		//?Obtem o total financeiro do documento de entrada?
		//??????????????????????????????????????????????????
		nTotalNF := MaFisRet(, "NF_BASEDUP")
	                        
		//?????????????????????????????????????????????????????????????????????????
		//?Executa o calculo para cada natureza financeira, atualizando o aColsSEV?
		//????????????????????????????????????????????????????????????????????????? 
		nTotPercent := 0          	
		For nI := 1 To Len(aNaturezas)
			nPercentProd := ROUND((aNaturezas[nI][2] / nTotalNF), GETMV("MV_MULTDEC",,2)) * 100
			AADD(aColsSEV, {aNaturezas[nI][1], nPercentProd, SPACE(TAMSX3("EV_IDDOC")[1]), "SEV", 0, .F.})
			nTotPercent += nPercentProd
		Next nI 
		
		//?????????????????????????????????????????????????????????????????????????
		//?Caso n?o tenha fechado 100 %, acrescenta a diferen?a na ?ltima natureza?
		//?????????????????????????????????????????????????????????????????????????
		If nTotPercent > 100    
		 _DifPerc := nTotPercent - 100
			aColsSEV[Len(aColsSEV)][2] -= ROUND(( _Difperc), GETMV("MV_MULTDEC",,2)) 
		EndIf
		If nTotPercent < 100    
		 _DifPerc := 100 - nTotPercent
			aColsSEV[Len(aColsSEV)][2] += ROUND(( _Difperc), GETMV("MV_MULTDEC",,2)) 
		EndIf

	EndIf  
EndIf

Return aColsSEV    
