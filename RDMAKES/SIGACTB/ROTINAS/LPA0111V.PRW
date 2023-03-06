#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0111V  ºAutor  ³Alexandre Longhinotti º Data ³  19/10/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³.....													       ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO LATICINIOS SILVESTRE                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

User Function LPA0111V()

Local hEnter 			:= CHR(10) + CHR(13)
Local nValor 			:= 0
Local nValorRT 			:= 0
Local nValorRD 			:= 0
Local cAliasTMP    		:= GetNextAlias()
Local cAliasTMP1   		:= GetNextAlias()
Local dDtIni 			:= SUBSTR(MV_PAR01,3,4) + SUBSTR(MV_PAR01,1,2) + "01"
Local dDtFim 			:= SUBSTR(MV_PAR01,3,4) + SUBSTR(MV_PAR01,1,2) + "31"

If (SRZ->RZ_CC >="08.03" .AND. SRZ->RZ_CC <= "08.03.99.999") .OR. (SRZ->RZ_CC >= "09" .AND. SRZ-> RZ_CC<= "97.99.99.999")
	
	cQuery := " SELECT SRT.RT_FILIAL, SRT.RT_DATACAL, SRT.RT_CC, SRT.RT_MAT, SUM(SRT.RT_VALOR) AS VLRPROV 	" + hEnter
	cQuery += "	FROM " + RetSqlName("SRT") + " SRT									  					  	" + hEnter
	cQuery += " WHERE SRT.RT_VERBA IN ('878','879','880')								  					" + hEnter
	cQuery += " AND SRT.RT_MAT = '" + SRA->RA_MAT	+ "'                                  					" + hEnter
	cQuery += " AND SRT.RT_DATACAL BETWEEN '" + dDtIni + "' AND '" + dDtFim + "' AND 			   			" + hEnter
	cQuery += " SRT.D_E_L_E_T_ <> '*'												  						" + hEnter
	cQuery += " GROUP BY SRT.RT_FILIAL, SRT.RT_CC, SRT.RT_DATACAL, SRT.RT_MAT					   	  		" + hEnter
	cQuery += " ORDER BY SRT.RT_MAT														  					" + hEnter
	
	MemoWrite("LPA0107V.SQL",cQuery)
	TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	
	nValorRT := (cAliasTMP)->VLRPROV
	
	(cAliasTMP)->( dbskip() )
	
	If ( nValorRT > 0 )
		
		cQuery :=  " SELECT SRD.RD_DATARQ, SRD.RD_CC, SRD.RD_MAT, SUM(SRD.RD_VALOR) AS VLRPGTO 			  		" + hEnter
		cQuery += "	FROM " + RetSqlName("SRD") + " SRD									  					  	" + hEnter
		cQuery += " WHERE SRD.RD_PD IN ('025','026','027','028','029','030','031','032','033','034','035','036','037','038','039','040','041','042','043','044','049','055','068','069','070','084') " + hEnter
		cQuery += " AND SRD.RD_MAT = '" + SRA->RA_MAT	+ "'                                  					" + hEnter
		cQuery += " AND SRD.RD_DATARQ = '" + SUBSTR(MV_PAR01,3,4) + SUBSTR(MV_PAR01,1,2) + "'                   " + hEnter
		cQuery += "	AND SRD.D_E_L_E_T_ <> '*' 											   	  					" + hEnter
		cQuery += "	GROUP BY SRD.RD_DATARQ, SRD.RD_CC, SRD.RD_MAT							  	      			" + hEnter
		cQuery += "	ORDER BY SRD.RD_MAT														  					" + hEnter
		
		MemoWrite("LPA0107Va.SQL",cQuery)
		TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP1)
		
		dbSelectArea(cAliasTMP1)
		(cAliasTMP1)->(dbGoTop())
		
		nValorRD := (cAliasTMP1)->VLRPGTO
		
		(cAliasTMP1)->( dbskip() )
		
		nValor := nValorRD - nValorRT
		
		
		
	Else
		nValor := 0
	EndIf
EndIf
Return nValor
