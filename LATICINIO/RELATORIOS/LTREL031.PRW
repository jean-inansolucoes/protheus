#include "TOTVS.CH"
#include "FWPRINTSETUP.CH"
#include "RPTDEF.CH"
#include "TOPCONN.CH"


/*----------------------------------------------------------------------------------------------------
{Protheus.doc} ltrel031
Demonstrativo de pagamento do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/

user function LTREL031()
                    
private cPerg		:= "LTREL00001"
private nPOSCOL		:= 6
private DATE_NULL	:= ctod("  /  /    ")
private STRING_NULL	:= ""
private lATPERCfor	:= SuperGetMV("MV_ZLATPN",,.F.)	// Ativo controle de percentual s/ fornecedor p/ gerar documento 
private lIMPSE1		:= SuperGetMV("MV_ZLISE1",,.F.) 
private lIMPSE2		:= SuperGetMV("MV_ZLISE2",,.F.) 
private lTITFRETE	:= SuperGetMV("MV_ZLHTFR",,.F.)	// Habilita geração de títulos de frete a pagar/receber no fechamento mensal do produtor.
private lExecjob	:= (alltrim(upper(funname()))$alltrim("RPC/WEBSERVICES"))
                                                                  
	conout(time()+"-------------ltrel031-------------- start")
                               
	private oPrinter     
	pergunte(cPerg, .F.)
	if lExecjob
		private cPath := "\spool\pdf\"		
		private cFile := "ltrel031"+cvaltochar(ThreadID())+dtos(date())+strtran(time(),":","")+".pdf"
		private cFilJob := paramixb[1]
		private cCodJob := paramixb[2]
		private cLojJob := paramixb[3]
		private nMesJob := paramixb[4]
		private nAnoJob := paramixb[5]
		oPrinter := FWMSPrinter():New(cFile, IMP_PDF, .T., cPath, .T.,,,, .T.,,, .F.)
		oPrinter:SetPortrait()
		oPrinter:SetPaperSize(DMPAPER_A4)  
		oPrinter:SetMargin(40,40,40,40)
		oPrinter:cPathPDF := cPath		
	 	Printreport()                                                        	 	
	 	return (cPath+cFile)
	 else
		if pergunte(cPerg, .T.)		
			oPrinter := FWMSPrinter():New("ltrel031", IMP_SPOOL)
			oPrinter:SetPaperSize(DMPAPER_A4) 
			oPrinter:SetMargin(40,40,40,40)
			oPrinter:SetPortrait()								
			Printreport()
		endif
	endif
		                   

return
		
		
		
/*----------------------------------------------------------------------------------------------------
{Protheus.doc} Printreport
Demonstrativo de pagamento do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/		

static function Printreport()

local nQTD_TOTAL   := 0					// quantidade total em litros
local nPRC_LITRO   := 0					// preço total dos litros  
local nPRC_FRETE   := 0					// preço por litro de frete
local nVLR_PROD    := 0					// valor total da produção   
local nVLR_DESP    := 0					// valor total de despesas
local nVLR_CRED    := 0					// valor total de creditos
local cPRODUT      := ""				// código do produtor
local cLOJPRD      := ""				// loja do produtor
local cLINHA       := ""				// linha do produtor
local cAliasTMP    := GetnextAlias()
local hEnter	   := CHR(10) + CHR(13) 
local lSTART_DATE  := .F.
local lEND_DATE    := .F.
local aDADOSIMP    := {}
private nPag 		:= 0
private nLin 		:= 0
private nCol 		:= 0                                                 
private oFont14CN  := TFont():New("Courier new",,16)
private oFont16CI  := TFont():New("Courier new",,16,,,,,,,,.T.)
private oFont16BD  := TFontEx():New(oPrinter,"Arial",16,16,.T.,.T.,.F.)  
private oFont16    := TFontEx():New(oPrinter,"Arial",16,16,.F.,.T.,.F.)  
private oFont14BD  := TFontEx():New(oPrinter,"Arial",14,14,.T.,.T.,.F.)  
private oFont14    := TFontEx():New(oPrinter,"Arial",14,14,.F.,.T.,.F.)  
private oFont12    := TFontEx():New(oPrinter,"Arial",12,12,.F.,.T.,.F.)  
private oFont10    := TFontEx():New(oPrinter,"Arial",10,10,.F.,.T.,.F.)  
                                                                             


	if !(lExecjob)            
	
		dSTART_DATE  := ctod("01/"+strzero(mv_par01,2)+"/"+strzero(mv_par02,4))	// primeiro dia do período
		dEND_DATE    := dSTART_DATE		// último dia do período
		dCURR_DATE   := dSTART_DATE     // dia do registro em processamento
		dLAST_DATE   := dSTART_DATE		// último dia impresso
		
		if U_YIsBis(mv_par02) 
			dEND_DATE := ctod(Iif(strzero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(strzero(mv_par01,2)=="02","29","30"))+"/"+strzero(mv_par01,2)+"/"+strzero(mv_par02,4))
	    else
			dEND_DATE := ctod(Iif(strzero(mv_par01,2)$"01/03/05/07/08/10/12","31",Iif(strzero(mv_par01,2)=="02","28","30"))+"/"+strzero(mv_par01,2)+"/"+strzero(mv_par02,4))   
	    endif
	
	else 

		dSTART_DATE  := ctod("01/"+strzero(nMesJob,2)+"/"+strzero(nAnoJob,4))	// primeiro dia do período
		dEND_DATE    := dSTART_DATE		// último dia do período
		dCURR_DATE   := dSTART_DATE		// dia do registro em processamento
		dLAST_DATE   := dSTART_DATE		// último dia impresso
		
		if U_YIsBis(nAnoJob) 
			dEND_DATE := ctod(Iif(strzero(nMesJob,2)$"01/03/05/07/08/10/12","31",Iif(strzero(nMesJob,2)=="02","29","30"))+"/"+strzero(nMesJob,2)+"/"+strzero(nAnoJob,4))
	    else
			dEND_DATE := ctod(Iif(strzero(nMesJob,2)$"01/03/05/07/08/10/12","31",Iif(strzero(nMesJob,2)=="02","28","30"))+"/"+strzero(nMesJob,2)+"/"+strzero(nAnoJob,4))   
	    endif
	
	endif
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro dos pedidos de acordo com os parametros informados pelo usuário. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	if (select(cAliasTMP) <> 0)
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	endif

	                  
	if !(lExecjob)

		cQuery := "SELECT 	ZL5.ZL5_COD,												" + hEnter
		cQuery += "			ZL5.ZL5_LINHA,  											" + hEnter    
		cQuery += "			ZL5.ZL5_TRANSP, 											" + hEnter
		cQuery += "			ZL5.ZL5_NOMTRP, 											" + hEnter	
		cQuery += "			ZL5.ZL5_DATA,												" + hEnter
		cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
		cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
		cQuery += "			SA2.A2_NOME,   												" + hEnteR
		cQuery += "			ZL6.ZL6_QTDE												" + hEnter
		cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" + hEnter
		cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          " + hEnter		
		cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             " + hEnter		
		cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" + hEnter
		cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	" + hEnter		
		cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	" + hEnter		
		cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xfilial("ZL5") + "' 				" + hEnter
	    
	    // filtro por linha
	    if mv_par09 == 1   
			cQuery += "AND ( ZL5.ZL5_LINHA  BETWEEN '" + mv_par03       + "' 			" + hEnter
			cQuery += "AND                 		    '" + mv_par04       + "' )			" + hEnter
	    // filtro por produtor
	    else                  
			cQuery += "AND ( ZL6.ZL6_PRODUT BETWEEN '" + mv_par05       + "' 			" + hEnter
			cQuery += "AND                		    '" + mv_par06       + "' )			" + hEnter
			cQuery += "AND ( ZL6.ZL6_LOJPRD BETWEEN '" + mv_par07       + "' 			" + hEnter
			cQuery += "AND                          '" + mv_par08       + "' )			" + hEnter
	    endif
	
		cQuery += "AND 		( SA2.A2_COND  BETWEEN '" + mv_par14       + "' 			" + hEnter
		cQuery += "AND      	           		 '" + mv_par15       + "' )				" + hEnter
	
		cQuery += "AND 		( ZL5.ZL5_DATA       BETWEEN '" + DTOS(dSTART_DATE) + "' 	" + hEnter
		cQuery += "AND      	                    	 '" + DTOS(dEND_DATE)   + "' )	" + hEnter
		cQuery += "AND 		ZL5.ZL5_STATUS         = '' 								" + hEnter
		cQuery += "AND 		ZL6.ZL6_QTDE           > 0 									" + hEnter
		cQuery += "AND 		ZL5.D_E_L_E_T_        != '*' 								" + hEnter
		cQuery += "AND 		ZL6.D_E_L_E_T_        != '*' 								" + hEnter
		cQuery += "AND 		SA2.D_E_L_E_T_        != '*' 								" + hEnter
	    
	    // filtro por linha
	    if mv_par09 == 1   
			if mv_par10 == 1
				cQuery += "ORDER BY ZL5.ZL5_LINHA, ZL6.ZL6_PRODUT, 						" + hEnter
				cQuery += "			ZL6.ZL6_LOJPRD, ZL5.ZL5_DATA						" + hEnter
			else
				cQuery += "ORDER BY ZL5.ZL5_LINHA, SA2.A2_NOME, ZL5.ZL5_DATA			" + hEnter
			endif		
		
		// filtro por produtor
		else
			if mv_par10 == 1                                                                                        
				cQuery += "ORDER BY ZL6.ZL6_PRODUT, ZL6.ZL6_LOJPRD, ZL5.ZL5_DATA 		" + hEnter
			else 
				cQuery += "ORDER BY SA2.A2_NOME, ZL5.ZL5_DATA 					   		" + hEnter
			endif
		endif

	else

		cQuery := "SELECT 	ZL5.ZL5_COD,												" + hEnter
		cQuery += "			ZL5.ZL5_LINHA,  											" + hEnter    
		cQuery += "			ZL5.ZL5_TRANSP, 											" + hEnter
		cQuery += "			ZL5.ZL5_NOMTRP, 											" + hEnter	
		cQuery += "			ZL5.ZL5_DATA,												" + hEnter
		cQuery += "			ZL6.ZL6_PRODUT,												" + hEnter
		cQuery += "			ZL6.ZL6_LOJPRD,												" + hEnter
		cQuery += "			SA2.A2_NOME,   												" + hEnteR
		cQuery += "			ZL6.ZL6_QTDE												" + hEnter
		cQuery += "FROM " + RetSqlName("ZL5") + " ZL5									" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6   							" + hEnter
		cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL                          " + hEnter		
		cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD                             " + hEnter		
		cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2		   						" + hEnter
		cQuery += "ON       ZL6.ZL6_PRODUT    = SA2.A2_COD      	                	" + hEnter		
		cQuery += "AND      ZL6.ZL6_LOJPRD    = SA2.A2_LOJA         	            	" + hEnter		
		cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + cFilJob + "'		 				" + hEnter
		cQuery += "AND 		ZL6.ZL6_PRODUT    = '" + cCodJob + "' 						" + hEnter
		cQuery += "AND 		ZL6.ZL6_LOJPRD 	  = '" + cLojJob + "' 						" + hEnter
		cQuery += "AND 		(ZL5.ZL5_DATA       BETWEEN '" + DTOS(dSTART_DATE) + "' 	" + hEnter
		cQuery += "AND      	                    	 '" + DTOS(dEND_DATE)   + "' )	" + hEnter
		cQuery += "AND 		ZL5.ZL5_STATUS         = '' 								" + hEnter
		cQuery += "AND 		ZL6.ZL6_QTDE           > 0 									" + hEnter
		cQuery += "AND 		ZL5.D_E_L_E_T_        != '*' 								" + hEnter
		cQuery += "AND 		ZL6.D_E_L_E_T_        != '*' 								" + hEnter
		cQuery += "AND 		SA2.D_E_L_E_T_        != '*' 								" + hEnter
		cQuery += "ORDER BY ZL6.ZL6_PRODUT, ZL6.ZL6_LOJPRD, ZL5.ZL5_DATA 				" + hEnter
	
	endif
	                        
	memowrite("ltrel031_1.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())
   	
 	while (cAliasTMP)->(!EOF())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ posição do produtor                                          			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        
		if len(aDADOSIMP) > 0
			nPOS := aScan ( aDADOSIMP, { |x| x[1] == (cAliasTMP)->ZL6_PRODUT .and. x[2] == (cAliasTMP)->ZL6_LOJPRD } )
		else
			nPOS := 0
		endif
		
		if nPOS == 0
			aAdd ( aDADOSIMP, { (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL5_TRANSP, (cAliasTMP)->ZL5_NOMTRP, {}, (cAliasTMP)->A2_NOME } )
			nPOS := len(aDADOSIMP)
		endif
				                                                                        

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ troca de produtor                                          				³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿				
	
	    if cPRODUT != (cAliasTMP)->ZL6_PRODUT .or. cLOJPRD != (cAliasTMP)->ZL6_LOJPRD	       
            
			if cPRODUT != STRING_NULL .or. cLOJPRD != STRING_NULL
				nPOS := aScan ( aDADOSIMP, { |x| x[1] == cPRODUT .and. x[2] == cLOJPRD } )
			endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ período final sem movimentos                               				³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   	
		   	if ! lEND_DATE .and. lSTART_DATE
				nTOT := ( dEND_DATE - dLAST_DATE )
				for nI := 1 to nTOT
					if nPOS != 0
						aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dLAST_DATE + nI) , 0 } )
					endif
				next nI
				lEND_DATE := .T.
			endif
	                                                                                     
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Limpeza dos totalizadores                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        nQTD_TOTAL   := 0
	        nPRC_LITRO   := 0
	        nPRC_FRETE   := 0
	        nVLR_PROD    := 0
	        nVLR_DESP    := 0
	        nVLR_CRED    := 0
	        dLAST_DATE   := dSTART_DATE
	        dCURR_DATE   := dSTART_DATE
	        lSTART_DATE  := .F.
			lEND_DATE    := .F.
	    	
	    	nPOS := aScan ( aDADOSIMP, { |x| x[1] == (cAliasTMP)->ZL6_PRODUT .and. x[2] == (cAliasTMP)->ZL6_LOJPRD } )
	        
	    endif                             
	    
	   	cPRODUT := (cAliasTMP)->ZL6_PRODUT  
	   	cLOJPRD := (cAliasTMP)->ZL6_LOJPRD
	   	cLINHA  := (cAliasTMP)->ZL5_LINHA
	   	
	   	nQTD_TOTAL += (cAliasTMP)->ZL6_QTDE
	   	dCURR_DATE := STOD( (cAliasTMP)->ZL5_DATA )
	   	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ período inicial                                              			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		
	   	if ! lSTART_DATE
		   	if dCURR_DATE == dSTART_DATE 
		   		lSTART_DATE := .T.
			endif
			if ! lSTART_DATE   
				nTOT := (( dCURR_DATE - dSTART_DATE ) - 1 )
				for nI := 0 to nTOT
					if nPOS != 0
						aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dSTART_DATE + nI) , 0 } )
						dLAST_DATE := dSTART_DATE + nI
					endif										
				next nI
				lSTART_DATE := .T.
			endif
		endif
		                        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ período intermediário sem movimentos                       				³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

		if (dLAST_DATE + 1) < dCURR_DATE
			nTOT := (( dCURR_DATE - dLAST_DATE ) - 1 )
			for nI := 1 to nTOT
				if nPOS != 0
					aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dLAST_DATE + 1) , 0 } )
					dLAST_DATE := dLAST_DATE + 1
				endif								
			next nI	
		endif
		   
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ movimento atual                                            				³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

		if nPOS != 0
			aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dCURR_DATE), (cAliasTMP)->ZL6_QTDE } )
		endif		
		dLAST_DATE := dCURR_DATE   

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ última data                                                				³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		
	   	if ! lEND_DATE
		   	if dLAST_DATE == dEND_DATE 
		   		lEND_DATE := .T.
			endif
		endif		
		
	    (cAliasTMP)->(dbskip())
	   		
	enddo

	(cAliasTMP)->(dbCloseArea())
                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ período final sem movimentos                               				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

   	if ! lEND_DATE .and. lSTART_DATE
		nTOT := ( dEND_DATE - dLAST_DATE )
		for nI := 1 to nTOT
			if nPOS != 0
				aAdd ( aDADOSIMP[nPOS][nPOSCOL], { DTOC(dLAST_DATE + nI) , 0 } )
			endif			
		next nI
	endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ indexação dos dados                                          			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	if !(lExecjob)

		if len(aDADOSIMP) > 0
			if mv_par10 == 1	// Ordena por linha + código produtor
				aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[3]+x[1] < y[3]+y[1] } )
			else	// Ordena por linha + nome produtor
				aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[3]+x[7] < y[3]+y[7] } )
			endif
			
			for nI := 1 to len(aDADOSIMP)
				aDADOSIMP[nI][nPOSCOL] := aSort( aDADOSIMP[nI][nPOSCOL],,,{ |x,y| x[1] < y[1] } )	
			next nI	
		endif
	
	else                                                                         
	                                                                 
		// Ordena por linha + código produtor
		aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[3]+x[1] < y[3]+y[1] } )
		for nI := 1 to len(aDADOSIMP)
			aDADOSIMP[nI][nPOSCOL] := aSort( aDADOSIMP[nI][nPOSCOL],,,{ |x,y| x[1] < y[1] } )	
		next nI	

	endif	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ impressão dos dados                                          			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	                                                                
	
	if len(aDADOSIMP) > 0
		
		for nY := 1 to len(aDADOSIMP)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Limpeza dos totalizadores                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        nQTD_TOTAL   := 0
	        nPRC_LITRO   := 0
	        nPRC_FRETE   := 0
	        nVLR_PROD    := 0
	        nVLR_DESP    := 0
	        nVLR_CRED    := 0


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressão dos dados do produtor                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			
	        PrintCabec( DTOC(dSTART_DATE), DTOC(dEND_DATE), aDADOSIMP[nY,4], aDADOSIMP[nY,5], aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3] )

	                                                                                     
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ impressão dos movimentos diarios                             			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			                                                                
			
			PrintMovimentos( aDADOSIMP, nY, @nQTD_TOTAL )


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressão das despesas e totalizadores do produtor no período           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

                                         
			if lExecjob
				//imprime dados financeiros se mes/ano de impressao igual ao da database ou 
				//database - mes/ano de impressao menor de 10 dias para caso nao tenha sido realizado o fechamento
				if (month(dSTART_DATE) == month(ddatabase) .and. year(dSTART_DATE) == year(ddatabase)) .or. ((ddatabase - dEND_DATE) < 10)
					fTotalDesp( dSTART_DATE, dEND_DATE, aDADOSIMP[nY,1], aDADOSIMP[nY,2], @nVLR_DESP, @nVLR_CRED )
				endif
			else
				fTotalDesp( dSTART_DATE, dEND_DATE, aDADOSIMP[nY,1], aDADOSIMP[nY,2], @nVLR_DESP, @nVLR_CRED )
			endif                                                                                                 
			
			
			fCalcProd( dSTART_DATE, iif(!lExecjob,mv_par11,2), aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], nQTD_TOTAL, @nPRC_LITRO, @nVLR_PROD, @nPRC_FRETE )
		  	         
		  	
		  	fTotalPrd( DTOC(dSTART_DATE), DTOC(dEND_DATE), aDADOSIMP[nY,4], aDADOSIMP[nY,5], aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nVLR_DESP, nVLR_CRED, nPRC_FRETE )
		  	

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressão análise IN 62                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  	
		  	fResAnlPrd( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], dSTART_DATE, dEND_DATE, aDADOSIMP[nY,4], aDADOSIMP[nY,5] )
		  	                                          
		  	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressão análise coleta a campo                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

		  	if (iif(!lExecjob,mv_par16==2,.F.))
		  		fResAnlCpo( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], dSTART_DATE, dEND_DATE, aDADOSIMP[nY,4], aDADOSIMP[nY,5] )
		  	endif
		  	
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressão de mensagens                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

		  	if !(lExecjob)
			  	fImpMensag( mv_par18, mv_par19, mv_par20 )
			endif         
			
		next nY
		
		oPrinter:EndPage()
	
	endif


	oPrinter:Print()		
	FreeObj(oPrinter)	        


	
return
     


/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fCalcProd
Definição do preço a ser pago ao produtor com base nas tabelas de preços por faixa ou tabela de exceção.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fCalcProd( dSTART_DATE, nEXCECAO, cPRODUT, cLOJPRD, cLINHA, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nPRC_FRETE )           

local dSTART_FIN := mv_par12
local dEND_FIN   := mv_par13 
local cNumFret   := "0"

	nVLR_PROD  := 0
	nPRC_LITRO := 0
	nPRC_FRETE := 0  

	
	if month(dSTART_DATE) == month(ddatabase) .and. year(dSTART_DATE) == year(ddatabase)
	
		if nEXCECAO == 1 	// Cadastro do produtor
			
			dbselectarea("SA2")
			dbsetorder(1)
			dbgotop()
			if dbseek ( xfilial("SA2") + cPRODUT + cLOJPRD )
				if ! empty ( SA2->A2_X_FAIXA )
					dbselectarea("ZL2")
					dbsetorder(1)
					dbgotop()
					if dbseek ( xfilial("ZL2") + SA2->A2_X_FAIXA )
						nPRC_LITRO := ZL2->ZL2_PRCLEI
						nPRC_FRETE := ZL2->ZL2_PRCFRT	
					endif
				else
					dbselectarea("ZL2")
					dbsetorder(2)
					dbgotop()   
					if dbseek ( xfilial("ZL2") + cLINHA )
						while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
							if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
								nPRC_LITRO := ZL2->ZL2_PRCLEI
								nPRC_FRETE := ZL2->ZL2_PRCFRT
								Exit
							endif
							ZL2->(dbskip())
						enddo
					endif
				endif	
			endif 
			
	    else	// tabela de exceções
	    
			dbselectarea("ZL2")
			dbsetorder(4)	// ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
			dbgotop()                                            
			if dbseek ( xfilial("ZL2") + cPRODUT + cLOJPRD, .T. )
				nPRC_LITRO := ZL2->ZL2_PRCLEI                
				nPRC_FRETE := ZL2->ZL2_PRCFRT
			else
				dbselectarea("ZL2")
				dbsetorder(2)	// // ZL2_FILIAL+ZL2_LINHA
				dbgotop()   
				if dbseek ( xfilial("ZL2") + cLINHA )
					while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
						if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
							nPRC_LITRO := ZL2->ZL2_PRCLEI
							nPRC_FRETE := ZL2->ZL2_PRCFRT
							Exit
						endif
						ZL2->(dbskip())
					enddo
				endif
			endif     
	    
	    endif                               
	    
	
	Else

		cMV_ZLTPRD	:= AllTRIM(GetMV("MV_ZLTPRD"))		//-- código do produto
		cANOMES		:= cvaltochar(year(dSTART_DATE))+STRZero(month(dSTART_DATE),2)
		hEnter		:= chr(10)+chr(13)                    
		cAliasTMP	:= GetNextAlias()
		
		//Períodos anteriores a 12/2014 as notas eram emitidas no mês seguinte.
		If cANOMES < "201411"
			nANO := SubSTR(cANOMES,1,4)
			nMES := Val(SubSTR(cANOMES,5,2))
			nMES += 1
			If nMES == 13
				nMES := 1
				nANO += 1
			EndIf
			cANOMES := cValToChar(nANO)+STRZero(nMES,2)
			cCondSD1 := "AND 	SUBSTRING(SD1.D1_EMISSAO,1,6) = '" + cANOMES  + "' 		" + hEnter	
		ElseIf cANOMES == "201411"
			cCondSD1 := "AND 	SD1.D1_EMISSAO		  >= '20141201'			 			" + hEnter
			cCondSD1 += "AND 	SD1.D1_EMISSAO		   < '20141231'			 			" + hEnter
		ElseIf cANOMES == "201412"
			cCondSD1 := "AND 	SD1.D1_EMISSAO		   = '20141231'			 			" + hEnter	
		Else
			cCondSD1 := "AND 	SUBSTRING(SD1.D1_EMISSAO,1,6) = '" + cANOMES  + "' 		" + hEnter			
		EndIf


		cQuery := "SELECT	SUM(SD1.D1_TOTAL) D1_TOTAL,									" + hEnter
		cQuery += "			SUM(SD1.D1_QUANT) D1_QUANT,									" + hEnter
		cQuery += "			SUM(SD1.D1_VALDEV) D1_VALDEV,								" + hEnter
		cQuery += "			SUM(SD1.D1_QTDEDEV) D1_QTDEDEV								" + hEnter
		cQuery += "FROM " + RetSqlName("SD1") + " SD1									" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2   							" + hEnter
		cQuery += "ON       SA2.A2_COD        = SD1.D1_FORNECE                          " + hEnter		
		cQuery += "AND      SA2.A2_LOJA       = SD1.D1_LOJA                             " + hEnter				
		cQuery += "AND      SA2.A2_X_TIPO     = 'P'			                            " + hEnter
		cQuery += "AND 		SA2.D_E_L_E_T_   != '*' 									" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1   							" + hEnter
		cQuery += "ON       SF1.F1_FILIAL     = SD1.D1_FILIAL                           " + hEnter		
		cQuery += "AND      SF1.F1_DOC        = SD1.D1_DOC                              " + hEnter		
		cQuery += "AND      SF1.F1_SERIE      = SD1.D1_SERIE                            " + hEnter		
		cQuery += "AND      SF1.F1_FORNECE    = SD1.D1_FORNECE                          " + hEnter		
		cQuery += "AND      SF1.F1_LOJA       = SD1.D1_LOJA                             " + hEnter		
		cQuery += "AND 		SF1.F1_TIPO       = 'N'					 					" + hEnter
		cQuery += "AND 		SF1.F1_ESPECIE    = 'SPED'		                            " + hEnter
		cQuery += "AND 		SF1.D_E_L_E_T_   != '*' 									" + hEnter	
		cQuery += "WHERE    SD1.D1_FORNECE    = '" + cPRODUT + "'						" + hEnter
		cQuery += "AND      SD1.D1_LOJA       = '" + cLOJPRD + "'						" + hEnter
		cQuery += cCondSD1
		cQuery += "AND 		SD1.D1_COD	      = '" + cMV_ZLTPRD + "' 					" + hEnter
		cQuery += "AND 		SD1.D_E_L_E_T_   != '*' 									" + hEnter

		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)			
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
	 	If (cAliasTMP)->(!EOF())
	 		nVALTOT := ((cAliasTMP)->D1_TOTAL -  (cAliasTMP)->D1_VALDEV)
	 		nQTDTOT := ((cAliasTMP)->D1_QUANT -  (cAliasTMP)->D1_QTDEDEV)
	 		If nQTDTOT > 0 .and. nVALTOT > 0
		 		nPRC_LITRO := Round(nVALTOT/nQTDTOT, 7)
		 	Endif
	 	EndIf
		(cAliasTMP)->(dbCloseArea())  

        cQuery := "	SELECT 															" + hEnter
		cQuery += "			SE1.E1_SALDO,											" + hEnter
		cQuery += "			SE1.E1_VALOR,											" + hEnter
		cQuery += "			SE1.E1_FILIAL,											" + hEnter
		cQuery += "			SE1.E1_PREFIXO,											" + hEnter
		cQuery += "			SE1.E1_NUM,   											" + hEnter
		cQuery += "			SE1.E1_PARCELA,											" + hEnter
		cQuery += "			SE1.E1_TIPO,  											" + hEnter
		cQuery += "			SE1.E1_CLIENTE,											" + hEnter
		cQuery += "			SE1.E1_LOJA,   											" + hEnter
		cQuery += "			SE1.E1_EMISSAO,   										" + hEnter
		cQuery += "			SE1.E1_VENCREA   										" + hEnter		
		cQuery += "	FROM " + RetSqlName("SE1") + " SE1								" + hEnter	
		cQuery += "	WHERE   SE1.E1_FILIAL    = '" + xfilial("SE1") + "' 			" + hEnter
		cQuery += "	AND     SE1.E1_CLIENTE   = '" + cPRODUT  + "'					" + hEnter
		cQuery += "	AND     SE1.E1_LOJA      = '" + cLOJPRD + "'			   		" + hEnter
		cQuery += " AND     ( SE1.E1_PREFIXO   = 'FRT'						 		" + hEnter
		cQuery += " AND     SE1.E1_TIPO   = 'DP')							 		" + hEnter
		cQuery += "	AND     SE1.E1_VENCREA BETWEEN '" + dtos(dSTART_FIN) + "'		" + hEnter
		cQuery += "	AND     					   '" + dtos(dEND_FIN) + "'			" + hEnter
		cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" + hEnter
		
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)				
		
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbgotop())
		
		while !(cAliasTMP)->(EOF())
			If cNumFret != (cAliasTMP)->E1_NUM
				nPRC_FRETE  := (cAliasTMP)->E1_VALOR
				cNumFret 	:= (cAliasTMP)->E1_NUM
			Else
				(cAliasTMP)->(dbskip())
			EndIf
			
        enddo
		
		If nQTDTOT > 0 .and. nPRC_FRETE > 0
	 		nPRC_FRETE := Round(nPRC_FRETE/nQTDTOT, 7)
	 	Endif
		
	 	(cAliasTMP)->(dbCloseArea())
                
                
		If nPRC_LITRO == 0

			if nEXCECAO == 1 	// Cadastro do produtor
				
				dbselectarea("SA2")
				dbsetorder(1)
				dbgotop()
				if dbseek ( xfilial("SA2") + cPRODUT + cLOJPRD )
					if ! empty ( SA2->A2_X_FAIXA )
						dbselectarea("ZL2")
						dbsetorder(1)
						dbgotop()
						if dbseek ( xfilial("ZL2") + SA2->A2_X_FAIXA )
							nPRC_LITRO := ZL2->ZL2_PRCLEI
							nPRC_FRETE := ZL2->ZL2_PRCFRT	
						endif
					else
						dbselectarea("ZL2")
						dbsetorder(2)
						dbgotop()   
						if dbseek ( xfilial("ZL2") + cLINHA )
							while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
								if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
									nPRC_LITRO := ZL2->ZL2_PRCLEI
									nPRC_FRETE := ZL2->ZL2_PRCFRT
									Exit
								endif
								ZL2->(dbskip())
							enddo
						endif
					endif	
				endif 
				
		    else	// tabela de exceções
		    
				dbselectarea("ZL2")
				dbsetorder(4)	// ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
				dbgotop()                                            
				if dbseek ( xfilial("ZL2") + cPRODUT + cLOJPRD, .T. )
					nPRC_LITRO := ZL2->ZL2_PRCLEI                
					nPRC_FRETE := ZL2->ZL2_PRCFRT
				else
					dbselectarea("ZL2")
					dbsetorder(2)	// // ZL2_FILIAL+ZL2_LINHA
					dbgotop()   
					if dbseek ( xfilial("ZL2") + cLINHA )
						while ! ZL2->(EOF()) .and. ZL2->ZL2_FILIAL + ZL2->ZL2_LINHA == xfilial("ZL2") + cLINHA
							if nQTD_TOTAL >= ZL2->ZL2_FXINI .and. nQTD_TOTAL <= ZL2->ZL2_FXFIN 
								nPRC_LITRO := ZL2->ZL2_PRCLEI
								nPRC_FRETE := ZL2->ZL2_PRCFRT
								Exit
							endif
							ZL2->(dbskip())
						enddo
					endif
				endif     
		    
		    endif                               
	
		endif	

	endif    
        
    
   	if nPRC_LITRO != 0
   		nVLR_PROD := Round ( nPRC_LITRO * nQTD_TOTAL , 7)
   	endif    

return 



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} PrintCabec
Impressão do cabeçalho do demonstrativo de pagamento do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function PrintCabec(cSTART_DATE, cEND_DATE, cCODTRP, cDESTRP, cPRODUT, cLOJPRD, cLINHA)
	
	Local cVenc := ctod("//")
	Local cVenc1
	
	dbselectarea("SA2")
	dbsetorder(1)
	dbgotop()
	dbseek( xfilial("SA2") + cPRODUT + cLOJPRD )                           

	dbselectarea("ZL0")
	dbsetorder(1)
	dbgotop()
	dbseek( xfilial("ZL0") + cLINHA )
	
	
	If nPag > 0
		oPrinter:EndPage()
	EndIf
	nPag++
	oPrinter:StartPage()                            

	oPrinter:Box(100, 5, 3000, 2300)
	                                           
	cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
	if file(cLogoD)
		oPrinter:SayBitmap(110,080,cLogoD,200,110)
	endif
		
	
	aPARCELA := Condicao(1,SA2->A2_COND,,ctod(cEND_DATE))
//	aPARCELA := Condicao(nVALOR,cCondPgto,,IIF(!Empty(M->ZLB_DTMOV),M->ZLB_DTMOV,ddatabase))
	If Len(aPARCELA) > 0
		For nPAR := 1 to Len(aPARCELA)
			if Empty(alltrim(dtos(cVenc)))
				cVenc := aPARCELA[nPAR,01]
				cVenc1 := dtoc(cVenc)
			Else
				cVenc1 := dtoc(cVenc) + " e " + dtoc(aPARCELA[nPAR,01])
			Endif
		Next nPAR
	EndIf
	
	
	oPrinter:Say(160, 650	, "DEMONSTRATIVO DE PAGAMENTO DO PRODUTOR", oFont16BD:oFont )
	oPrinter:Say(140, 2040	, "Data: " + dtoc(date()), oFont10:oFont )
	oPrinter:Say(170, 2040	, "Hora: " + substr(time(),1,5), oFont10:oFont )   
	oPrinter:Say(190, 830	, alltrim(SM0->M0_NOMECOM) +" - Filial: "+cFilAnt, oFont12:oFont )        	
	oPrinter:Say(200, 2040	, "Página: " + cvaltochar(nPag), oFont10:oFont )	

	oPrinter:Line(220, 5, 220, 2300)
	oPrinter:Say(270, 20	, "Período de entregas: " + cSTART_DATE + " a: " + cEND_DATE, oFont14:oFont )
	oPrinter:Say(270, 900	, "Transportador: " + cCODTRP + " / " + alltrim(cDESTRP), oFont14:oFont )

	oPrinter:Line(310, 5, 310, 2300)
	oPrinter:Say(360, 20	, "Produtor " , oFont14:oFont)
	oPrinter:Say(360, 220	,":  " + cPRODUT + "/" + cLOJPRD + " - " + alltrim(SA2->A2_NOME), oFont14:oFont )
	oPrinter:Say(360, 1900	, "CPF:  " + transform(SA2->A2_CGC,"@R 999.999.999-99"), oFont14:oFont )
	oPrinter:Say(410, 20	, "Endereço ", oFont14:oFont)
	oPrinter:Say(410, 220	,":  " + alltrim(SA2->A2_END) + " - " + alltrim(SA2->A2_MUN) + " / " + SA2->A2_EST, oFont14:oFont )	
	oPrinter:Say(460, 20	, "Linha    ", oFont14:oFont)
	oPrinter:Say(460, 220	,":  " + alltrim(cLINHA) + " / " + alltrim(ZL0->ZL0_DESC), oFont14:oFont )
	oPrinter:Say(510, 20	, "Pagamento", oFont14:oFont)
	oPrinter:Say(510, 220	,":  " + iif(SA2->A2_X_FPGTO=="C","CHEQUE",SA2->A2_COND + " - DEPOSITO: BANCO: " + alltrim(SA2->A2_BANCO) + " / AGENCIA:  "+ SA2->A2_AGENCIA +" / CONTA: " + alltrim(SA2->A2_NUMCON)) + " - VENCIMENTO: " + cVenc1, oFont14:oFont )

	nLin := 550
		
return



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} PrintMovimentos
Demonstrativo de pagamento do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function PrintMovimentos(aDADOSIMP, nY, nQTD_TOTAL)

local nJ   := 0
local lInc := .F.


	oPrinter:Line(nLin, 5, 550, 2300)
	nLin += 50
	oPrinter:Say(nLin, 1050	, "PRODUÇÃO", oFont14BD:oFont )
   	nLin += 25
	oPrinter:Line(nLin, 5, nLin, 2300)
   	nLin += 25

   	for nJ := 1 to len(aDADOSIMP[nY][nPOSCOL])

	   	nQTD_TOTAL += aDADOSIMP[nY][nPOSCOL][nJ][2]
		lInc := .F.
		
		nCol := 70
		if nJ <= 10
			oPrinter:SayAlign(nLin, nCol		, aDADOSIMP[nY][nPOSCOL][nJ][1] + ":",oFont14CN,350,50,,0,0)
			oPrinter:SayAlign(nLin, nCol+250	, transform(aDADOSIMP[nY][nPOSCOL][nJ][2],"@E 999,999"),oFont14CN,280,50,,1,0)
			lInc := .T.
		endif

		nCol := 790
		if nJ+10 <= 20
			oPrinter:SayAlign(nLin, nCol		, aDADOSIMP[nY][nPOSCOL][nJ+10][1] + ":",oFont14CN,350,50,,0,0)
			oPrinter:SayAlign(nLin, nCol+250	, transform(aDADOSIMP[nY][nPOSCOL][nJ+10][2],"@E 999,999"),oFont14CN,280,50,,1,0)
			lInc := .T.
		endif

		nCol := 1580                             
		if nJ+20 <= len(aDADOSIMP[nY][nPOSCOL])
			oPrinter:SayAlign(nLin, nCol		, aDADOSIMP[nY][nPOSCOL][nJ+20][1] + ":",oFont14CN,350,50,,0,0)
			oPrinter:SayAlign(nLin, nCol+250	, transform(aDADOSIMP[nY][nPOSCOL][nJ+20][2],"@E 999,999"),oFont14CN,280,50,,1,0)
			lInc := .T.
		endif
		
		if lInc
			nLin += 50
		endif

   	next nJ       
              
	nLin += 25
	
		
return



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fTotalPrd
Função utilizada para impressão dos totalizadores do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fTotalPrd(cSTART_DATE, cEND_DATE, cCODTRP, cDESTRP, cPRODUT, cLOJPRD, cLINCOL, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nVLR_DESP, nVLR_CRED, nPRC_FRETE)
                                                               
local nFUNRURAL := 0 
local nSENAR := 0
local nGilrat := 0
local nLIQUIDO  := 0
Local nVLRTRANSP := 0
local nPRCUNLIQ := nPRC_LITRO - nPRC_FRETE 
local nPCFAT    := 0
Local cLISTCONDP  := SuperGetMV("MV_ZLCPCD",,"")			// Lista condições de pagamento para parcelas                                            
Local cCondPag 
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// código da TES de movimento
Local nAlsenar := POSICIONE("SF4",1,xFilial("SF4")+cMV_ZLTTES,"F4_ALSENAR")
Local nAlInss   := 0
Local nAlGilrat   := 0

	lImpDescFRT := .F.
	if lTITFRETE
		if fCheckTPF() .AND. nPRC_FRETE > 0	//Verifica se transportador é pessoa física
			nVLRTRANSP := Round(nPRC_FRETE * nQTD_TOTAL, 7 ) 
			lImpDescFRT := .T.
		else
			nPRCUNLIQ := nPRC_LITRO
		endif		
	endif

	
	dbselectarea("SA2")
	dbsetorder(1)
	dbseek( xfilial("SA2") + cPRODUT + cLOJPRD )
	cTipoRur  := SA2->A2_TIPORUR
	cCondPag  := SA2->A2_COND
	aPFunRur  := FunRur()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³aPFunRur[1]  == "F"³
	//³aPFunRur[2]  == "L"³
	//³aPFunRur[3]  == "J"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nPosPer   := at(cTipoRur,"FLJ")
	nPCFAT    := SA2->A2_X_PCDOC
	nAlInss := POSICIONE("SED",1,XFILIAL("SED")+SA2->A2_NATUREZ,"ED_PERCINS")
	if nPosPer > 0
		If cTipoRur != "J"
			If cTipoRur = "F"
				nAlGilrat := Val(aPFunRur[nPosPer])
			ElseIf cTipoRur = "L"
				nAliquota := nAlsenar
	   		EndIf
	  		if SA2->A2_X_PCONT > 0
	 			nAliquota := SA2->A2_X_PCONT+ nAlsenar
	 		endif
	 		//-- Controle de serie de nota fiscal diferentes.
			if lATPERCfor
	 			nFUNRURAL := ( (nVLR_PROD * nPCFAT / 100) * nAlInss) /100
	 			nSENAR := ( (nVLR_PROD * nPCFAT / 100) * nAlsenar) /100
	  			nGilrat := ( (nVLR_PROD * nPCFAT / 100) * nAlGilrat) /100
	  			nPRCUNLIQ := nPRCUNLIQ - (( (nPRCUNLIQ * nPCFAT / 100) * (nAlInss+nAlsenar+nGilrat) ) /100)
	  		else
	   			nFUNRURAL := (nVLR_PROD * nAlInss) /100
	   			nSENAR := (nVLR_PROD * nAlsenar) /100 
				nGilrat := (nVLR_PROD * nAlGilrat) /100 
		 		nPRCUNLIQ := nPRCUNLIQ - ((nPRCUNLIQ * (nAlInss+nAlsenar+nAlGilrat)) /100)
	   		endif
	   	EndIf
	endif

	nLIQUIDO  := Round( (nVLR_PROD + nVLR_CRED) - ( (nFUNRURAL+nSENAR+nGilrat) + nVLR_DESP ), 7)



	if nLin > 2200
		PrintCabec( cSTART_DATE, cEND_DATE, cCODTRP, cDESTRP, cPRODUT, cLOJPRD, cLINCOL )
	endif
	   
	
	oPrinter:Line(nLin, 5, nLin, 2300)
	nLin += 50
	oPrinter:Say(nLin, 1050	, "TOTAIS", oFont14BD:oFont )
   	nLin += 25
	oPrinter:Line(nLin, 5, nLin, 2300)
   	nLin += 25

	oPrinter:SayAlign(nLin, 70		, "QUANTIDADE TOTAL PRODUZIDA EM LITROS....:",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 1100	, transform( nQTD_TOTAL, "@E 99,999,999" ),oFont14CN,400,50,,1,0)
   	nLin += 50

	oPrinter:SayAlign(nLin, 70		, "PREÇO UNITÁRIO EM LITROS BRUTO..........: R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 1100	, transform( nPRC_LITRO, "@E 9,999.9999" ),oFont14CN,400,50,,1,0)
   	nLin += 50

	oPrinter:SayAlign(nLin, 70		, "PREÇO UNITÁRIO EM LITROS LÍQUIDO........: R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 1100	, transform( nPRCUNLIQ , "@E 9,999.9999" ),oFont14CN,400,50,,1,0)
   	nLin += 50

	oPrinter:SayAlign(nLin, 70		, "VALOR TOTAL DA PRODUÇÃO..............(+): R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 1100	, transform( nVLR_PROD , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
   	nLin += 50

	oPrinter:SayAlign(nLin, 70		, "FUNRURAL.............................(-): R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 1100	, transform( nFUNRURAL , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
   	nLin += 50

	oPrinter:SayAlign(nLin, 70		, "DESCONTO DÉBITOS.....................(-): R$ ",oFont14CN,1200,50,,0,0)	
	oPrinter:SayAlign(nLin, 1100	, transform( nVLR_DESP , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
   	nLin += 50

	if lImpDescFRT                                                                                             
		nLIQUIDO := nLIQUIDO - nVLRTRANSP 
		oPrinter:SayAlign(nLin, 70	, "DESCONTO TRANSPORTADOR...............(-): R$ ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1100	, transform( nVLRTRANSP , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
	   	nLin += 50
	endif 

	oPrinter:SayAlign(nLin, 70		, "ACRÉSCIMO CRÉDITOS...................(+): R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 1100	, transform( nVLR_CRED , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
   	nLin += 50

	oPrinter:SayAlign(nLin, 70		, "TOTAL LIQUIDO A RECEBER.................: R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 1100	, transform( nLIQUIDO  , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
   	
   	if cCondPag $ cLISTCONDP 
   		nLin += 100
   		oPrinter:SayAlign(nLin, 70	, "VALOR PRIMEIRA PARCELA.............: R$ ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1100	, transform((nVLR_PROD / 2)- ((nFUNRURAL/2)  + (nSENAR))  , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
		nLin += 50
		oPrinter:SayAlign(nLin, 70	, "VALOR SEGUNDA  PARCELA.............: R$ ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1100	, transform( ((((nVLR_PROD / 2)) - nVLR_DESP - nVLRTRANSP) + nVLR_CRED - ((nFUNRURAL/2)  + (nGilrat)))  , "@E 999,999.99" ),oFont14CN,400,50,,1,0)
   	
   	endif
   	nLin += 75
    
	

return



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fResAnlPrd
Função utilizada para impressão dos resultados de análises normativa 62.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fResAnlPrd( cCODPRD, cLOJPRD, cLINCOL, dINICIAL, dFINAL, cCODTRP, cDESTRP)

local cAliasTMP := GetNextAlias()  
local cQuery    := STRING_Null
local hEnter	:= CHR(10) + CHR(13)
local nCCS_MAX  := 0
local nCBT_MAX  := 0
local nSLT_MAX  := 0 
local nGORD_MIN := 0
local nPROT_MIN := 0
local nLACT_MIN := 0
local aParam    := {}

    // recupera os limites de gordura do parâmetro
	U_LTGETPMM("MV_ZLGORD",aParam)
	nGORD_MIN := aParam[1]            
	
    // recupera os limites de proteína do parâmetro
	U_LTGETPMM("MV_ZLPROT",aParam)
	nPROT_MIN := aParam[1]

    // recupera os limites de lactose do parâmetro
	U_LTGETPMM("MV_ZLLACT",aParam)
	nLACT_MIN := aParam[1]                
	
    // recupera os limites de CCS do parâmetro
	U_LTGETPMM("MV_ZLCCS",aParam)	
	nCCS_MAX  := aParam[2]              
	
    // recupera os limites de CBT do parâmetro
	U_LTGETPMM("MV_ZLCBT",aParam)	
	nCBT_MAX  := aParam[2] 
	
	// recupera os limites de solidos totais do parâmetro
	U_LTGETPMM("MV_ZLSLT",aParam)
	nSLT_MAX  := aParam[1] //SuperGetMV("MV_ZLSLT",,"") 
 

	cQuery := "SELECT 	ZL8.ZL8_DATCOL,										" + hEnter
	cQuery += "			ZL9.ZL9_GORD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_PROTN, 										" + hEnter  
	cQuery += "			ZL9.ZL9_LACT,  										" + hEnter  
	cQuery += "			ZL9.ZL9_SOLD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CCS,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CBT  										" + hEnter    
	cQuery += "FROM " + RetSqlName("ZL8") + " ZL8							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("ZL9") + " ZL9         			" + hEnter
	cQuery += "ON       ZL8.ZL8_FILIAL    = ZL9.ZL9_FILIAL      			" + hEnter		
	cQuery += "AND      ZL8.ZL8_PROTOC    = ZL9.ZL9_PROTOC      			" + hEnter	
	cQuery += "INNER JOIN " + RetSqlName("ZL1") + " ZL1         			" + hEnter
	cQuery += "ON       ZL9.ZL9_FILIAL    = ZL1.ZL1_FILIAL      			" + hEnter		
	cQuery += "AND      ZL9.ZL9_PRODUT    = ZL1.ZL1_PRODUT      			" + hEnter	
	cQuery += "AND      ZL9.ZL9_LOJPRD    = ZL1.ZL1_LOJPRD      			" + hEnter	
	cQuery += "INNER JOIN " + RetSqlName("ZL0") + " ZL0         			" + hEnter
	cQuery += "ON       ZL1.ZL1_FILIAL    = ZL0.ZL0_FILIAL      			" + hEnter		
	cQuery += "AND      ZL1.ZL1_COD       = ZL0.ZL0_COD		      			" + hEnter	
	cQuery += "WHERE    ZL9.ZL9_FILIAL = '" + xfilial("ZL9") + "' 			" + hEnter
	cQuery += "AND 		( ZL8.ZL8_DATCOL BETWEEN '" + dtos(dINICIAL) + "' 	" + hEnter
	cQuery += "AND             		             '" + dtos(dFINAL) + "' )	" + hEnter	
	cQuery += "AND 	 	ZL9.ZL9_PRODUT = '" + cCODPRD + "' 					" + hEnter
	cQuery += "AND 		ZL9.ZL9_LOJPRD = '" + cLOJPRD + "' 					" + hEnter
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL8.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL9.D_E_L_E_T_    != '*' 							" + hEnter	
 	cQuery += "ORDER BY ZL8.ZL8_PROTOC	 			 						" + hEnter	

	
	MemoWrite("ltrel031_2.SQL",cQuery)
	
	if (Select(cAliasTMP) <> 0)
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	endif

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())

    if ! empty ( (cAliasTMP)->ZL8_DATCOL )


		if nLin > 2200               
			PrintCabec( DTOC(dINICIAL), DTOC(dFINAL), cCODTRP, cDESTRP, cCODPRD, cLOJPRD, cLINCOL )
		endif
		   
		
		oPrinter:Line(nLin, 5, nLin, 2300)
		nLin += 50
		oPrinter:Say(nLin, 850, "RESULTADO DE ANÁLISE - IN 62", oFont14BD:oFont )
	   	nLin += 25
		oPrinter:Line(nLin, 5, nLin, 2300)
	   	nLin += 25
	
		oPrinter:SayAlign(nLin, 70, "DATA DA COLETA : "  + dtoc(stod((cAliasTMP)->ZL8_DATCOL)),oFont16CI,1200,50,,0,0)
	   	nLin += 50
	
		oPrinter:SayAlign(nLin, 70, "RESULTADOS: ",oFont16CI,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1150, "PARÂMETROS: ",oFont16CI,1200,50,,0,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "(%) GORDURA...........:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZL9_GORD != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZL9_GORD,"@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "(%) GORDURA MÍNIMO..........:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nGORD_MIN,"@E 999.99"),oFont14CN,350,50,,1,0)
	   	nLin += 50
		
		oPrinter:SayAlign(nLin, 70, "(%) PROTEÍNA..........:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZL9_PROTN != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZL9_PROTN,"@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "(%) PROTEÍNA MÍNIMO.........:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nPROT_MIN,"@E 999.99"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "(%) EXTR. SECO DESENG.:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZL9_LACT != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZL9_LACT,"@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "(%) EXTR. SECO DESENG. MÍN..:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nLACT_MIN,"@E 999.99"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "(%) EXTR. SECO TOTAL..:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZL9_SOLD != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZL9_SOLD,"@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "(%) EXTR. SECO TOTAL MÍNIMO.:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nSLT_MAX, "@E 999.99"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "CCS (ML)..............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZL9_CCS != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZL9_CCS*1000,"@E 9,999,999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "CONT. CÉLULAS SOMÁTICAS MÁX.:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nCCS_MAX*1000, "@E 9999,999"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "CPP (UFC/ML)..........:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZL9_CBT != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZL9_CBT*1000,"@E 9,999,999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "CONT. PADRÃO EM PLACAS MÁX..:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nCBT_MAX*1000,"@E 9999,999"),oFont14CN,350,50,,1,0)
	   	nLin += 75

	endif 
	
	
	(cAliasTMP)->(dbCloseArea())
	
return



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fResAnlCpo
Função utilizada para impressão dos resultados de análises a campo.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fResAnlCpo( cCODPRD, cLOJPRD, cLINCOL, dINICIAL, dFINAL, cCODTRP, cDESTRP )

local cAliasTMP := GetnextAlias()  
local cQuery    := STRING_Null
local hEnter	:= CHR(10) + CHR(13)
local nCCS_MAX  := 0
local nCBT_MAX  := 0
local nSLT_MAX  := 0 
local nGORD_MIN := 0
local nPROT_MIN := 0
local nLACT_MIN := 0
local aParam    := {}


    // recupera os limites de gordura do parâmetro
	U_LTGETPMM("MV_ZLGORD",aParam)
	nGORD_MIN := aParam[1]            
	
    // recupera os limites de proteína do parâmetro
	U_LTGETPMM("MV_ZLPROT",aParam)
	nPROT_MIN := aParam[1]

    // recupera os limites de lactose do parâmetro
	U_LTGETPMM("MV_ZLLACT",aParam)
	nLACT_MIN := aParam[1]                
	
    // recupera os limites de CCS do parâmetro
	U_LTGETPMM("MV_ZLCCS",aParam)	
	nCCS_MAX  := aParam[2]              
	
    // recupera os limites de CBT do parâmetro
	U_LTGETPMM("MV_ZLCBT",aParam)	
	nCBT_MAX  := aParam[2] 
	
	// recupera os limites de solidos totais do parâmetro
	U_LTGETPMM("MV_ZLSLT",aParam)
	nSLT_MAX  := aParam[2]

    // recupera os limites de alizarol do parâmetro
	U_LTGETPMM("MV_ZLALI",aParam)	
	nALZ_MIN  := aParam[1] 

    // recupera os limites de crioscopia do parâmetro
	U_LTGETPMM("MV_ZLCRIO",aParam)	
	nCRI_MIN  := aParam[1]*1000 
	nCRI_MAX  := aParam[2]*1000 

    // recupera os limites de densidade do parâmetro
	U_LTGETPMM("MV_ZLDENS",aParam)	
	nDEN_MIN  := aParam[1] 
	nDEN_MAX  := aParam[2] 
	
    // recupera os limites de EST do parâmetro
	U_LTGETPMM("MV_ZLEST",aParam)	
	nEST_MIN  := aParam[1] 

    // recupera os limites de ESD do parâmetro
	U_LTGETPMM("MV_ZLESD",aParam)	
	nESD_MIN  := aParam[1] 

    // recupera os limites de redutase do parâmetro
	U_LTGETPMM("MV_ZLRED",aParam)	
	nRED_MIN  := aParam[1]

    // recupera os limites de acidez do parâmetro
	U_LTGETPMM("MV_ZLACDZ",aParam)	
	nACD_MIN  := aParam[1]		
	nACD_MAX  := aParam[2]
	 

	//-- Filtro dos dados
	cQuery := "SELECT 														" + hEnter
	cQuery += "     	ZLA.ZLA_NUMERO,										" + hEnter
	cQuery += "     	ZLA.ZLA_DATA,										" + hEnter
	cQuery += "         ZLA.ZLA_ACID,										" + hEnter
	cQuery += "         ZLA.ZLA_CRIO,										" + hEnter
	cQuery += "         ZLA.ZLA_PERC,										" + hEnter
	cQuery += "         ZLA.ZLA_GORD,										" + hEnter
	cQuery += "         ZLA.ZLA_ESD,										" + hEnter
	cQuery += "         ZLA.ZLA_DENS,										" + hEnter
	cQuery += "         ZLA.ZLA_PROT,										" + hEnter
	cQuery += "         ZLA.ZLA_QTDE,										" + hEnter
	cQuery += "         ZLA.ZLA_LACT,										" + hEnter
	cQuery += "         ZLA.ZLA_CLORET,										" + hEnter
	cQuery += "         ZLA.ZLA_NEUTRA,										" + hEnter
	cQuery += "         ZLA.ZLA_RECONS,										" + hEnter	 
	cQuery += "         ZLA.ZLA_ALIZAR,										" + hEnter	 
	cQuery += "         ZLA.ZLA_EST,										" + hEnter	 
	cQuery += "         ZLA.ZLA_REDUTA,										" + hEnter	 
	cQuery += "         ZLA.ZLA_HIDSOD,										" + hEnter	 
	cQuery += "         ZLA.ZLA_BICARB,										" + hEnter	 
	cQuery += "         ZLA.ZLA_BORATO,										" + hEnter	 
	cQuery += "         ZLA.ZLA_PERHID,										" + hEnter	 
	cQuery += "         ZLA.ZLA_forMOL,										" + hEnter	 
	cQuery += "         ZLA.ZLA_SACARO,										" + hEnter	 
	cQuery += "         ZLA.ZLA_AMIDO,										" + hEnter	 
	cQuery += "         ZLA.ZLA_ANALIS										" + hEnter	 
	/*
	cQuery += "         ZLA.ZLA_CCS,										" + hEnter	 
	cQuery += "         ZLA.ZLA_CBT											" + hEnter	 
	*/
	cQuery += "FROM " + RetSqlName("ZLA") + " ZLA							" + hEnter
	cQuery += "WHERE    ZLA.ZLA_FILIAL = '" + xfilial("ZLA") + "' 			" + hEnter
	cQuery += "AND 		ZLA.ZLA_PRODUT = '" + cCODPRD + "' 					" + hEnter
	cQuery += "AND 		ZLA.ZLA_LOJPRD = '" + cLOJPRD + "' 					" + hEnter
	cQuery += "AND 		( ZLA.ZLA_DATA   BETWEEN '" + dtos(dINICIAL) + "' 	" + hEnter
	cQuery += "AND                 		         '" + dtos(dFINAL) + "' )	" + hEnter
	cQuery += "AND 		ZLA.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "ORDER BY ZLA.ZLA_DATA										" + hEnter	

	MemoWrite("ltrel031_AC.SQL",cQuery)
	
	if (Select(cAliasTMP) <> 0)
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	endif

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())

    if ! (cAliasTMP)->(EOF())
                          
		if nLin > 1900
			PrintCabec( DTOC(dINICIAL), DTOC(dFINAL), cCODTRP, cDESTRP, cCODPRD, cLOJPRD, cLINCOL )			
		endif
		   
		
		oPrinter:Line(nLin, 5, nLin, 2300)
		nLin += 50
		oPrinter:Say(nLin, 850, "RESULTADO DE ANÁLISE - CAMPO", oFont14BD:oFont )
	   	nLin += 25
		oPrinter:Line(nLin, 5, nLin, 2300)
	   	nLin += 25
	
		oPrinter:SayAlign(nLin, 70, "NÚMERO DA COLETA: " + (cAliasTMP)->ZLA_NUMERO,oFont16CI,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1150, "DATA DA COLETA : "+dtoc(stod((cAliasTMP)->ZLA_DATA)),oFont16CI,1200,50,,0,0)
	   	nLin += 50
	
		oPrinter:SayAlign(nLin, 70, "RESULTADOS: ",oFont16CI,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1150, "PARÂMETROS: ",oFont16CI,1200,50,,0,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "(%) ALIZAROL..........:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_ALIZAR != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_ALIZAR, "@E 999999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "(%) ALIZAROL MÍNIMO.........:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nALZ_MIN,"@E 999999"),oFont14CN,350,50,,1,0)
	   	nLin += 50
        
		oPrinter:SayAlign(nLin, 70, "(%) ACIDEZ............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_ACID != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_ACID, "@E 999999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "(%) ACIDEZ MÍN./MÁX.........:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, alltrim(transform(nACD_MIN,"@E 999999"))+"/"+alltrim(transform(nACD_MAX,"@E 999999")),oFont14CN,350,50,,1,0)
	   	nLin += 50
        
		oPrinter:SayAlign(nLin, 70, "CRIOSCOPIA............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_CRIO != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_CRIO, "@E 999999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "CRIOSCOPIA MÍN./MÁX.........:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, alltrim(transform(nCRI_MIN,"@E 999999"))+"/"+alltrim(transform(nCRI_MAX,"@E 9999999")),oFont14CN,350,50,,1,0)
	   	nLin += 50
	
		oPrinter:SayAlign(nLin, 70, "(%) GORDURA...........:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_GORD != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_GORD, "@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "(%) GORDURA MÍNIMO..........:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nGORD_MIN, "@E 999.99"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "DENSIDADE.............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_DENS != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_DENS, "@E 99999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "DENSIDADE MÍN./MÁX..........:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, alltrim(transform(nDEN_MIN,"@E 99.999"))+"/"+alltrim(transform(nDEN_MAX,"@E 99.999")),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "E.S.T.................:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_EST != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_EST, "@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "E.S.T. MÍNIMO...............:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nEST_MIN,"@E 999.99"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "E.S.D.................:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_ESD != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_ESD, "@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "E.S.D. MÍNIMO...............:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nESD_MIN,"@E 999.99"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "REDUTAZE..............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_REDUTA != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_REDUTA, "@E 999999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		oPrinter:SayAlign(nLin, 1150, "REDUTAZE MÍNIMO.............:",oFont14CN,750,50,,0,0)	             
		oPrinter:SayAlign(nLin, 1810, transform(nRED_MIN,"@E 999999"),oFont14CN,350,50,,1,0)
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "HID. SÓDIO............:",oFont14CN,600,50,,0,0)	
		if !Empty((cAliasTMP)->ZLA_HIDSOD)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_HIDSOD=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "BICARBONATO...........:",oFont14CN,600,50,,0,0)	
		if !Empty((cAliasTMP)->ZLA_BICARB)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_BICARB=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50
		
		oPrinter:SayAlign(nLin, 70, "CLORETOS..............:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_CLORET)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_CLORET=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "BORATOS...............:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_BORATO)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_BORATO=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "PER. HIDROGÊNIO.......:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_PERHID)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_PERHID=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "FORMOL................:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_FORMOL)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_FORMOL=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "SACAROSE..............:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_SACARO)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_SACARO=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "AMIDO.................:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_AMIDO)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_AMIDO=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "PROTEÍNA..............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_PROT != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_PROT, "@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "LACTOSE...............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_LACT != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_LACT, "@E 999.99"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50
		
		oPrinter:SayAlign(nLin, 70, "RECONSTITUINTES.......:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_RECONS)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_RECONS=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "NEUTRALIZANTES........:",oFont14CN,600,50,,0,0)	
		if !empty((cAliasTMP)->ZLA_NEUTRA)
			oPrinter:SayAlign(nLin, 650	, Iif((cAliasTMP)->ZLA_NEUTRA=="P","POSITIVO","NEGATIVO"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	/*
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "(%) C.S.S.............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_CCS != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_CCS, "@E 999999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
	   	nLin += 50

		oPrinter:SayAlign(nLin, 70, "(%) C.B.T.............:",oFont14CN,600,50,,0,0)	
		if (cAliasTMP)->ZLA_CBT != 0
			oPrinter:SayAlign(nLin, 650	, transform((cAliasTMP)->ZLA_CBT, "@E 999999"),oFont14CN,350,50,,1,0)
		else                                                                                                          
			oPrinter:SayAlign(nLin, 650	, "NÃO ANALISADO",oFont14CN,350,50,,1,0)
		endif		
		*/
	   	nLin += 75
	
	endif
	
	(cAliasTMP)->(dbCloseArea())
	
return





/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fTotalDesp
Função utilizada para impressão das despesas do integrado com base nas informações da conta corrente. 

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fTotalDesp( dSTART_DATE, dEND_DATE, cPRODUT, cLOJPRD, nVLR_DESP, nVLR_CRED )            

local lCabec     := .F.     
local cAliasTMP  := GetnextAlias()
local hEnter	 := CHR(10) + CHR(13) 
local dSTART_FIN := mv_par12
local dEND_FIN   := mv_par13        
Local nMesAtual1 := MONTH(date())
Local nMesrel1 := MONTH(dSTART_DATE)
	
	if lExecjob             
		
		dSTART_FIN := dSTART_DATE + 31
		dSTART_FIN := ctod("01/"+strzero(month(dSTART_FIN),2)+"/"+strzero(year(dSTART_FIN),4))
		
		if U_YIsBis(year(dSTART_FIN)) 
			dEND_FIN := ctod(Iif(strzero(month(dSTART_FIN),2)$"01/03/05/07/08/10/12","31",Iif(strzero(month(dSTART_FIN),2)=="02","29","30"))+"/"+strzero(month(dSTART_FIN),2)+"/"+strzero(year(dSTART_FIN),4))
	    else
			dEND_FIN := ctod(Iif(strzero(month(dSTART_FIN),2)$"01/03/05/07/08/10/12","31",Iif(strzero(month(dSTART_FIN),2)=="02","28","30"))+"/"+strzero(month(dSTART_FIN),2)+"/"+strzero(year(dSTART_FIN),4))
	    endif
	
	endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DEBITO  															  . ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	if (Select(cAliasTMP) <> 0)
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	endif
	    
	cQuery := "SELECT 	ZLB.ZLB_TPDESP,										" + hEnter
	cQuery += "			ZLB.ZLB_VALOR,  									" + hEnter  
	cQuery += "			ZLB.ZLB_DTMOV,  									" + hEnter
	cQuery += "			ZLB.ZLB_DTVCTO, 									" + hEnter	
	cQuery += "			ZLB.ZLB_STATUS,										" + hEnter
	cQuery += "			ZLB.ZLB_DOC,   										" + hEnter
	cQuery += "			ZLB.ZLB_SERIE,  									" + hEnter
	cQuery += "			ZLB.ZLB_HIST,  								    	" + hEnter
	cQuery += "			SX5.X5_DESCRI 										" + hEnter
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" + hEnter
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " + hEnter		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xfilial("ZLB") + "' 		" + hEnter
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(dSTART_FIN) + "'   " + hEnter
	cQuery += "AND      				       '" + DTOS(dEND_FIN) + "'	    " + hEnter	
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'D'							    " + hEnter
    if !lExecjob
		if mv_par17 != 1
		    cQuery += "AND 		ZLB.ZLB_STATUS    = ' '						" + hEnter
		EndIf		
 	Else
		if (nMesAtual1 > nMesRel1)
			cQuery += "AND 		ZLB.ZLB_STATUS    = 'C'						" + hEnter	
		EndIf     
	EndIf
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter

                        
	memowrite("ltrel031_3.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())
	nVLR_DESP  := 0 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressão das despesas do produtor no período                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	
	
		/*
                      1         2         3         4         5         6         7         8
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            ---------------------------------------------------------------------------------
		    DATA MOVIMENTO  VENCIMENTO  TIPO DA DESPESA                             VALOR(R$)
		*/  	
	
	while (cAliasTMP)->(!EOF())

		if ! lCabec        

			oPrinter:Line(nLin, 5, nLin, 2300)
		   	nLin += 50
			oPrinter:Say(nLin, 1050	, "DÉBITOS", oFont14BD:oFont )
		   	nLin += 25
			oPrinter:Line(nLin, 5, nLin, 2300)
		   	nLin += 25
		
			nCol := 70
			oPrinter:SayAlign(nLin, nCol, "DATA MOVIMENTO",oFont16CI,350,50,,0,0)
			nCol := 500
			oPrinter:SayAlign(nLin, nCol, "VENCIMENTO",oFont16CI,300,50,,0,0)			           
			nCol := 850
			oPrinter:SayAlign(nLin, nCol, "TIPO DO DÉBITO",oFont16CI,1000,50,,0,0)
			nCol := 1900
			oPrinter:SayAlign(nLin, nCol, "VALOR (R$)",oFont16CI,350,50,,1,0)

			lCabec := .T.
		endif
                          
		nLin += 50
		nCol := 70
		oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->ZLB_DTMOV ) ),oFont14CN,350,50,,0,0)
		nCol := 500
		oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->ZLB_DTVCTO ) ),oFont14CN,300,50,,0,0)			           
		nCol := 850
		oPrinter:SayAlign(nLin, nCol, IIF(EMPTY(ALLTRIM((cAliasTMP)->ZLB_HIST)),alltrim(substr((cAliasTMP)->X5_DESCRI,1,20)),alltrim(substr((cAliasTMP)->ZLB_HIST,1,15)) ),oFont14CN,1000,50,,0,0)
		nCol := 1900
		oPrinter:SayAlign(nLin, nCol, transform((cAliasTMP)->ZLB_VALOR,"@E 999,999.99"),oFont14CN,350,50,,1,0)
		
		nVLR_DESP += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbskip())

    enddo

    (cAliasTMP)->(dbCloseArea())           

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
	//³Seleciona todos os títulos em aberto do contas a receber p/ o produtor         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ


	if lIMPSE1
	
		dbselectarea("SA1")
		dbsetorder(14) 	// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
		dbgotop()
		if dbseek ( xfilial("SA1") + substr(cPRODUT,1,TAMSX3("A2_COD")[1]) + substr(cLOJPRD,1,TAMSX3("A2_LOJA")[1]) )		
	
			cQuery := "	SELECT 															" + hEnter
			cQuery += "			SE1.E1_SALDO,											" + hEnter
			cQuery += "			SE1.E1_VALOR,											" + hEnter
			cQuery += "			SE1.E1_FILIAL,											" + hEnter
			cQuery += "			SE1.E1_PREFIXO,											" + hEnter
			cQuery += "			SE1.E1_NUM,   											" + hEnter
			cQuery += "			SE1.E1_PARCELA,											" + hEnter
			cQuery += "			SE1.E1_TIPO,  											" + hEnter
			cQuery += "			SE1.E1_CLIENTE,											" + hEnter
			cQuery += "			SE1.E1_LOJA,   											" + hEnter
			cQuery += "			SE1.E1_EMISSAO,   										" + hEnter
			cQuery += "			SE1.E1_VENCREA   										" + hEnter		
			cQuery += "	FROM " + RetSqlName("SE1") + " SE1								" + hEnter	
			cQuery += "	WHERE   SE1.E1_FILIAL    = '" + xfilial("SE1") + "' 			" + hEnter
			cQuery += "	AND     SE1.E1_CLIENTE   = '" + SA1->A1_COD  + "'				" + hEnter
			cQuery += "	AND     SE1.E1_LOJA      = '" + SA1->A1_LOJA + "'				" + hEnter
			cQuery += " AND     ( SE1.E1_PREFIXO   != 'FRT'						 		" + hEnter
			cQuery += " AND       SE1.E1_PREFIXO   != 'PAP'						 		" + hEnter
			cQuery += " AND     SE1.E1_TIPO   != 'DP')							 		" + hEnter
			cQuery += "	AND     SE1.E1_VENCREA BETWEEN '" + dtos(dSTART_FIN) + "'		" + hEnter
			cQuery += "	AND     					   '" + dtos(dEND_FIN) + "'			" + hEnter
			if mv_par17 != 1 
				cQuery += "	AND     SE1.E1_SALDO     > 0								" + hEnter
			endif		
			cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" + hEnter
		
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)				
			
			dbselectarea(cAliasTMP)
			(cAliasTMP)->(dbgotop())
			
			while !(cAliasTMP)->(EOF())

				if ! lCabec
					oPrinter:Line(nLin, 5, nLin, 2300)
				   	nLin += 50
					oPrinter:Say(nLin, 1050	, "DÉBITOS", oFont14BD:oFont )
				   	nLin += 25
					oPrinter:Line(nLin, 5, nLin, 2300)
				   	nLin += 25
				
					nCol := 70
					oPrinter:SayAlign(nLin, nCol, "DATA MOVIMENTO",oFont16CI,350,50,,0,0)
					nCol := 500
					oPrinter:SayAlign(nLin, nCol, "VENCIMENTO",oFont16CI,300,50,,0,0)			           
					nCol := 850
					oPrinter:SayAlign(nLin, nCol, "TIPO DO DÉBITO",oFont16CI,1000,50,,0,0)
					nCol := 1900
					oPrinter:SayAlign(nLin, nCol, "VALOR (R$)",oFont16CI,350,50,,1,0)
		
					lCabec := .T.
				endif

				if alltrim((cAliasTMP)->E1_TIPO) == "RA" .OR. (cAliasTMP)->E1_TIPO == "NCC"
					if mv_par17 != 1
						nVALORCR := (cAliasTMP)->E1_SALDO * -1
					else
					    nVALORCR := (cAliasTMP)->E1_VALOR * -1
					endif
					
				else
					if mv_par17 != 1
						nVALORCR := (cAliasTMP)->E1_SALDO
					else
						nVALORCR := (cAliasTMP)->E1_VALOR
					endif
				endif				

		                          
				nLin += 50
				nCol := 70
				oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E1_EMISSAO ) ),oFont14CN,350,50,,0,0)
				nCol := 500
				oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E1_VENCREA ) ),oFont14CN,300,50,,0,0)			           
				nCol := 850
				oPrinter:SayAlign(nLin, nCol, (cAliasTMP)->E1_PREFIXO+"-DEBITOS MESES ANTERIORES/NOTAS FISCAIS",oFont14CN,1000,50,,0,0)
				nCol := 1900
				oPrinter:SayAlign(nLin, nCol, transform(nVALORCR,"@R 999,999.99"),oFont14CN,350,50,,1,0)
		
				nVLR_DESP += nVALORCR
				
				(cAliasTMP)->(dbskip())
		
		    enddo
		
	    	(cAliasTMP)->(dbCloseArea())   
	 
	 	endif
	 
	 endif
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CREDITO 															  . ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

	if (Select(cAliasTMP) <> 0)
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	endif
	    
	cQuery := "SELECT 	ZLB.ZLB_TPDESP,										" + hEnter
	cQuery += "			ZLB.ZLB_VALOR,  									" + hEnter  
	cQuery += "			ZLB.ZLB_DTMOV,  									" + hEnter
	cQuery += "			ZLB.ZLB_DTVCTO, 									" + hEnter	
	cQuery += "			ZLB.ZLB_STATUS,										" + hEnter
	cQuery += "			ZLB.ZLB_DOC,   										" + hEnter
	cQuery += "			ZLB.ZLB_SERIE,  									" + hEnter
	cQuery += "			SX5.X5_DESCRI 										" + hEnter
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SX5") + " SX5   					" + hEnter
	cQuery += "ON       SX5.X5_CHAVE      = ZLB.ZLB_TPDESP                  " + hEnter		
	cQuery += "WHERE    ZLB.ZLB_FILIAL    = '" + xfilial("ZLB") + "' 		" + hEnter
	cQuery += "AND      ZLB.ZLB_FORNEC    = '" + cPRODUT        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_LOJFOR    = '" + cLOJPRD        + "'	 	" + hEnter
	cQuery += "AND      ZLB.ZLB_DTVCTO BETWEEN '" + DTOS(dSTART_FIN)  + "'  " + hEnter
	cQuery += "AND      				       '" + DTOS(dEND_FIN)    + "'  " + hEnter
	cQuery += "AND      SX5.X5_TABELA     = 'LT'                     	 	" + hEnter
	cQuery += "AND 		ZLB.ZLB_TIPCD     = 'C'							    " + hEnter	
    if mv_par17 != 1 
		cQuery += "AND 	ZLB.ZLB_STATUS    = ' '								" + hEnter		
	endif		
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter
                        
	memowrite("ltrel031_3.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())
	nVLR_CRED  := 0 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressão das creditos do produtor no período                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	
	
		/*
                      1         2         3         4         5         6         7         8
            0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
            ---------------------------------------------------------------------------------
		    DATA MOVIMENTO  VENCIMENTO  TIPO DO CREDITO                             VALOR(R$)
		*/  	


	if lCabec
		lCabec := .F.
		nLin += 75
	endif
		
	while (cAliasTMP)->(!EOF())

		if ! lCabec
			
			oPrinter:Line(nLin, 5, nLin, 2300)
		   	nLin += 50
			oPrinter:Say(nLin, 1050	, "CRÉDITOS", oFont14BD:oFont )
		   	nLin += 25
			oPrinter:Line(nLin, 5, nLin, 2300)
		   	nLin += 25
		
			nCol := 70
			oPrinter:SayAlign(nLin, nCol, "DATA MOVIMENTO",oFont16CI,350,50,,0,0)
			nCol := 500
			oPrinter:SayAlign(nLin, nCol, "VENCIMENTO",oFont16CI,300,50,,0,0)			           
			nCol := 850
			oPrinter:SayAlign(nLin, nCol, "TIPO DO CRÉDITO",oFont16CI,1000,50,,0,0)
			nCol := 1900
			oPrinter:SayAlign(nLin, nCol, "VALOR (R$)",oFont16CI,350,50,,1,0)

			lCabec := .T.
		endif

		nLin += 50
		nCol := 70
		oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->ZLB_DTMOV ) ),oFont14CN,350,50,,0,0)
		nCol := 500
		oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->ZLB_DTVCTO ) ),oFont14CN,300,50,,0,0)			           
		nCol := 850
		oPrinter:SayAlign(nLin, nCol, substr((cAliasTMP)->X5_DESCRI,1,30),oFont14CN,1000,50,,0,0)
		nCol := 1900
		oPrinter:SayAlign(nLin, nCol, transform((cAliasTMP)->ZLB_VALOR,"@E 999,999.99"),oFont14CN,350,50,,1,0)

		nVLR_CRED += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbskip())

    enddo

    (cAliasTMP)->(dbCloseArea()) 
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
	//³Seleciona todos os títulos em aberto do contas a pagar p/ o produtor           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ

	if lIMPSE2
	
		cQuery := "	SELECT 																		" + hEnter
		cQuery += "			SE2.E2_SALDO,														" + hEnter
		cQuery += "			SE2.E2_VALOR,														" + hEnter
		cQuery += "			SE2.E2_FILIAL,														" + hEnter
		cQuery += "			SE2.E2_PREFIXO,														" + hEnter
		cQuery += "			SE2.E2_NUM,   														" + hEnter
		cQuery += "			SE2.E2_PARCELA,														" + hEnter
		cQuery += "			SE2.E2_TIPO,  														" + hEnter
		cQuery += "			SE2.E2_forNECE,														" + hEnter
		cQuery += "			SE2.E2_LOJA,   														" + hEnter
		cQuery += "			SE2.E2_EMISSAO,   													" + hEnter
		cQuery += "			SE2.E2_VENCREA   													" + hEnter		
		cQuery += "	FROM " + RetSqlName("SE2") + " SE2											" + hEnter	
		cQuery += "	WHERE   SE2.E2_FILIAL    = '" + xfilial("SE2") + "' 						" + hEnter
		cQuery += "	AND     SE2.E2_FORNECE   = '" + substr(cPRODUT,1,TAMSX3("A2_COD")[1])  + "'	" + hEnter
		cQuery += "	AND     SE2.E2_LOJA      = '" + substr(cLOJPRD,1,TAMSX3("A2_LOJA")[1]) + "'	" + hEnter
		cQuery += " AND     ( SE2.E2_PREFIXO   != '001'									 		" + hEnter
		cQuery += " AND     SE2.E2_TIPO   != 'NF')										 		" + hEnter		
		cQuery += "	AND     SE2.E2_VENCREA BETWEEN '" + dtos(dSTART_FIN) + "'					" + hEnter
		cQuery += "	AND     					   '" + dtos(dEND_FIN) + "'						" + hEnter
		cQuery += "	AND     SE2.E2_SALDO     > 0												" + hEnter
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 												" + hEnter
	
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)				
		
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbgotop())
		
		while !(cAliasTMP)->(EOF())
	

			if ! lCabec

				oPrinter:Line(nLin, 5, nLin, 2300)
			   	nLin += 50
				oPrinter:Say(nLin, 1050	, "CRÉDITOS", oFont14BD:oFont )
			   	nLin += 25
				oPrinter:Line(nLin, 5, nLin, 2300)
			   	nLin += 25
			
				nCol := 70
				oPrinter:SayAlign(nLin, nCol, "DATA MOVIMENTO",oFont16CI,350,50,,0,0)
				nCol := 500
				oPrinter:SayAlign(nLin, nCol, "VENCIMENTO",oFont16CI,300,50,,0,0)			           
				nCol := 850
				oPrinter:SayAlign(nLin, nCol, "TIPO DO CRÉDITO",oFont16CI,1000,50,,0,0)
				nCol := 1900
				oPrinter:SayAlign(nLin, nCol, "VALOR (R$)",oFont16CI,350,50,,1,0)
	
				lCabec := .T.
			endif
            
			if alltrim((cAliasTMP)->E2_TIPO) == "PA" .OR. (cAliasTMP)->E2_TIPO == "NDF"
				if mv_par17 != 1
					nVALORCP := (cAliasTMP)->E2_SALDO * -1
				else
				   	nVALORCP := (cAliasTMP)->E2_VALOR * -1
				endif
			else	
				if mv_par17 != 1
					nVALORCP := (cAliasTMP)->E2_SALDO
				else
				   	nVALORCP := (cAliasTMP)->E2_VALOR
				endif			
			endif
		 /*	if alltrim((cAliasTMP)->E2_TIPO) == "PA" .OR. (cAliasTMP)->E2_TIPO == "NDF"
				nVALORCP := (cAliasTMP)->E2_SALDO * -1
			else
				nVALORCP := (cAliasTMP)->E2_SALDO
			endif
	     */
	     
			nLin += 50
			nCol := 70
			oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E2_EMISSAO ) ),oFont14CN,350,50,,0,0)
			nCol := 500
			oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E2_VENCREA ) ),oFont14CN,300,50,,0,0)			           
			nCol := 850
			oPrinter:SayAlign(nLin, nCol, (cAliasTMP)->E2_PREFIXO+"-CREDITOS MESES ANTERIORES",oFont14CN,1000,50,,0,0)
			nCol := 1900
			oPrinter:SayAlign(nLin, nCol, transform(nVALORCP,"@R 999,999.99"),oFont14CN,350,50,,1,0)
	
			nVLR_CRED += nVALORCP
			
			(cAliasTMP)->(dbskip())
	
	    enddo
	
		(cAliasTMP)->(dbCloseArea())   
	
	endif                              
	
	if lCabec
		lCabec := .F.
		nLin += 75
	endif	


return
      


/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fImpMensag
Impressão de mensagens.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fImpMensag( cMSG1, cMSG2, cMSG3 )
    cMSG3 := "As informações de pagamento (AG, CONTA, VENCIMENTOS) acima são do CADASTRO do produtor no momento da emissão do relatório"                        
	if !empty(cMSG1) .or. !empty(cMSG2).or. !empty(cMSG3)
		oPrinter:Line(nLin, 5, nLin, 2300)
		nLin += 50
	endif
		    
    if !empty(cMSG1)		
		oPrinter:Say(nLin, 20, alltrim(cMSG1), oFont14:oFont )
		nLin += 50
	endif
    
    if !empty(cMSG2)		
		oPrinter:Say(nLin, 20, alltrim(cMSG2), oFont14:oFont )
		nLin += 50
	endif
    
    if !empty(cMSG3)		
		oPrinter:Say(nLin, 20, alltrim(cMSG3), oFont14:oFont )
		nLin += 50
	endif

  
return



/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fCheckTPF
Verifica se transportador é pessoa física.

@version 1.0
------------------------------------------------------------------------------------------------------*/

static function fCheckTPF()

local aAreaTMP := GetArea()
local lRet := .F.
	                  
	//--Cadastro da linha do produtor posicionado.
	dbselectarea("ZL0")
	dbsetorder(1)
	if dbseek ( xfilial("ZL0") + SA2->A2_X_LINHA )
	
		//--Transportador relacionado a linha.
		dbselectarea("SA4")
		dbsetorder(1)
		if dbseek ( xfilial("SA4") + ZL0->ZL0_TRANSP )
			
			//--fornecedor do transportador.
			if !empty(SA4->A4_X_forN) .and. !empty(SA4->A4_X_LOJF)
				dbselectarea("SA2")
				dbsetorder(1)
				if dbseek ( xfilial("SA2") + SA4->A4_X_forN + SA4->A4_X_LOJF )
					if SA2->A2_TIPO == "F"
						lRet := .T.
					endif
				endif
			endif
		
		endif
	
	endif

	RestArea(aAreaTMP)	

return (lRet)
