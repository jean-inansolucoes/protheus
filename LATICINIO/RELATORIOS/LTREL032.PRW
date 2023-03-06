#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"

*---------------------------------------------------------------------------* 
User Function TstQrCode()                                                     
*---------------------------------------------------------------------------* 

Private cPerg := "IMPRQRCODE"
Private oPrinter

	AjustaSX1()                                                 
	If Pergunte(cPerg, .T.) 
	
		oPrinter := FWMSPrinter():New(FUNNAME(), 2)
		oPrinter:SetPortrait()		
		oPrinter:SetResolution(78)
		oPrinter:SetPaperSize(DMPAPER_A4)
		oPrinter:SetMargin(60,60,60,60)
		oBrush := TBrush():New(,CLR_BLACK )		
		MsAguarde( {|| QRMCode() }, "Imprimindo registros... Aguarde!")	
	EndIf

Return 


*---------------------------------------------------------------------------* 
Static Function QRMCode()                                                       
*---------------------------------------------------------------------------* 
Local oFont12X	:= TFontEx():New(oPrinter,"Arial",12,12,.F.,.T.,.F.)
Local cAliasTMP := GetNextAlias()
Local aDADOSIMP	:= {}

	cQuery := "SELECT 	ZL0.ZL0_COD,			  									" 
	cQuery += "			ZL1.ZL1_PRODUT,												" 
	cQuery += "			ZL1.ZL1_LOJPRD,												" 
	cQuery += "			SA2.A2_NOME,												" 
	cQuery += "			SA2.A2_X_LINHA												" 
	cQuery += "FROM " + RetSqlName("ZL0") + " ZL0									" 
	cQuery += "INNER JOIN " + RetSqlName("ZL1") + " ZL1   							" 
	cQuery += "ON       ZL1.ZL1_FILIAL    		= 	ZL0.ZL0_FILIAL                  " 		
	cQuery += "AND      ZL1.ZL1_COD				= 	ZL0.ZL0_COD                     " 		
	cQuery += "AND 		ZL1.D_E_L_E_T_        	!= '*' 								" 
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" 
	cQuery += "ON       SA2.A2_COD				= ZL1.ZL1_PRODUT    				" 		
	cQuery += "AND      SA2.A2_LOJA				= ZL1.ZL1_LOJPRD    				" 
	cQuery += "AND 		SA2.D_E_L_E_T_        	!= '*' 								" 			
	cQuery += "WHERE    ZL0.ZL0_FILIAL			= 	'" + xFilial("ZL0") + "' 		" 
    cQuery += "AND   	ZL0.ZL0_COD		BETWEEN 	'" + mv_par01 + "' 		   		" 
	cQuery += "AND                 		    		'" + mv_par02 + "'				" 
    cQuery += "AND   	ZL1.ZL1_PRODUT	BETWEEN 	'" + mv_par03 + "' 		   		" 
	cQuery += "AND                 		    		'" + mv_par04 + "'				" 
    cQuery += "AND   	ZL1.ZL1_LOJPRD	BETWEEN 	'" + mv_par05 + "' 		   		" 
	cQuery += "AND                 		    		'" + mv_par06 + "'				" 
	cQuery += "AND 		ZL0.D_E_L_E_T_        	!= '*' 								" 
	cQuery += "ORDER BY	ZL0.ZL0_COD,			  									" 
	cQuery += "			SA2.A2_NOME													" 

                       
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
 	While (cAliasTMP)->(!EOF())
 		aAdd ( aDADOSIMP, { (cAliasTMP)->ZL0_COD, (cAliasTMP)->ZL1_PRODUT, (cAliasTMP)->ZL1_LOJPRD, (cAliasTMP)->A2_NOME , (cAliasTMP)->A2_X_LINHA } )
 		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())

	
	If Len(aDADOSIMP) > 0
		nNUMPRD := 1
		nLin	:= 020
		nLinQR	:= 450
		nCol	:= 020
		nColQR	:= 180
		oPrinter:StartPage()
		For nI := 1 to Len(aDADOSIMP)
			
			If nNUMPRD > 8
				nNUMPRD := 1
				nLin	:= 020
				nLinQR	:= 450
				oPrinter:EndPage()					
				oPrinter:StartPage()
			EndIf
			
			If nI % 2 == 0
				nCol := 1100
				nColQR := 1270
			Else
				nCol := 020
				nColQR := 180
				If nNUMPRD > 1
					nLin += 650
					nLinQR += 640
				EndIf
			EndIf

			oPrinter:Box( nLin, nCol, nLin+600, nCol+1020, "-2")
			oPrinter:Say( nLin+050, nCol+040, "Fornecedor: "+aDADOSIMP[nI][02]+"/"+aDADOSIMP[nI][03]+"/ "+aDADOSIMP[nI][05]	, oFont12X:oFont )
			oPrinter:Say( nLin+100, nCol+040, Substr(aDADOSIMP[nI][04],0,50)	, oFont12X:oFont )

			cTexto := "000000"+aDADOSIMP[nI][02]+"000"+aDADOSIMP[nI][03]
			oPrinter:QRCode(nLinQR+140, nColQR+080,cTexto,120)
							
			nNUMPRD += 1			
		
		Next nI
		oPrinter:EndPage()
	EndIf
	
	oPrinter:Preview()
	FreeObj(oPrinter)
	
Return .t.


*---------------------------------------------------------------------------* 
Static Function AjustaSX1()
*---------------------------------------------------------------------------*        
aRegs  := {}  
       
	aAdd(aRegs,{cPerg,"01","Linha De            ?","Linha De            ?","Linha De            ?","mv_ch1","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"02","Linha Até           ?","Linha Até           ?","Linha Até           ?","mv_ch2","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0002","","",""})
	aAdd(aRegs,{cPerg,"03","Produtor De         ?","Produtor De         ?","Produtor De         ?","mv_ch3","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",""})
	aAdd(aRegs,{cPerg,"04","Produtor Até        ?","Produtor Até        ?","Produtor Até        ?","mv_ch4","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA2ZL2","","",""})
	aAdd(aRegs,{cPerg,"05","Loja Produtor De    ?","Loja Produtor De    ?","Loja Produtor De    ?","mv_ch5","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"06","Loja Produtor Até   ?","Loja Produtor Até   ?","Loja Produtor Até   ?","mv_ch6","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})

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
		
Return Nil

