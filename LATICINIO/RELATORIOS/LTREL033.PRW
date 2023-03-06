#include "TOTVS.CH"
#include "FWPRINTSETUP.CH"
#include "RPTDEF.CH"
#include "TOPCONN.CH"


/*----------------------------------------------------------------------------------------------------
{Protheus.doc} Demograf
Demonstrativo de pagamento do produtor.

@version 1.0
------------------------------------------------------------------------------------------------------*/

user function Demograf()
                    
private cPerg		:= "LTREL00001"
private nPOSCOL		:= 6
private DATE_NULL	:= ctod("  /  /    ")
private STRING_NULL	:= ""
private lATPERCfor	:= SuperGetMV("MV_ZLATPN",,.F.)	// Ativo controle de percentual s/ fornecedor p/ gerar documento 
private lIMPSE1		:= SuperGetMV("MV_ZLISE1",,.F.) 
private lIMPSE2		:= SuperGetMV("MV_ZLISE2",,.F.) 
private lTITFRETE	:= SuperGetMV("MV_ZLHTFR",,.F.)	// Habilita geração de títulos de frete a pagar/receber no fechamento mensal do produtor.
private lExecjob	:= (alltrim(upper(funname()))$alltrim("RPC/WEBSERVICES"))
                                                                  
	conout(time()+"-------------Demograf-------------- start")
                               
	private oPrinter     
	pergunte(cPerg, .F.)
	if lExecjob
		private cPath := "\spool\pdf\"		
		private cFile := "demograf"+cvaltochar(ThreadID())+dtos(date())+strtran(time(),":","")+".pdf"
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
			oPrinter := FWMSPrinter():New("demograf", IMP_SPOOL)
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
local cDOC       := ""				// Documento de entrada
local cAliasTMP    := GetnextAlias()
local hEnter	   := CHR(10) + CHR(13) 
local lSTART_DATE  := .F.
local lEND_DATE    := .F.
local aDADOSIMP    := {}
private nPag 		:= 0
private nLin 		:= 0
private nCol 		:= 0                                                 
private oFont14CN  := TFont():New("Courier new",,16)
private oFont14CN  := TFont():New("Arial",,14)
private oFont12CN  := TFont():New("Arial",,12)
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
		cQuery += "			ZL6.ZL6_DOC,												" + hEnter
		cQuery += "			ZL6.ZL6_SERIE,												" + hEnter
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
		cQuery += "			ZL6.ZL6_DOC,												" + hEnter
		cQuery += "			ZL6.ZL6_SERIE,												" + hEnter
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
	                        
	memowrite("Demograf_1.SQL",cQuery)
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
			aAdd ( aDADOSIMP, { (cAliasTMP)->ZL6_PRODUT, (cAliasTMP)->ZL6_LOJPRD, (cAliasTMP)->ZL5_LINHA, (cAliasTMP)->ZL5_TRANSP, (cAliasTMP)->ZL5_NOMTRP, {}, (cAliasTMP)->A2_NOME, (cAliasTMP)->ZL6_DOC, (cAliasTMP)->ZL6_SERIE } )
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
	   	cDOC 	:= (cAliasTMP)->ZL6_DOC
	   	cSERIE 	:= (cAliasTMP)->ZL6_SERIE
	   	
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

			fTotalDesp( dSTART_DATE, dEND_DATE, aDADOSIMP[nY,1], aDADOSIMP[nY,2], @nVLR_DESP, @nVLR_CRED )

			fCalcProd( dSTART_DATE, iif(!lExecjob,mv_par11,2), aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], nQTD_TOTAL, @nPRC_LITRO, @nVLR_PROD, @nPRC_FRETE )
		  	
		  	fTotalPrd( DTOC(dSTART_DATE), DTOC(dEND_DATE), aDADOSIMP[nY,4], aDADOSIMP[nY,5], aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nVLR_DESP, nVLR_CRED, nPRC_FRETE, aDADOSIMP[nY,8], aDADOSIMP[nY,9] )
		  	

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressão análise IN 77                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  	fResAnlPrd( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], dSTART_DATE, dEND_DATE, aDADOSIMP[nY,4], aDADOSIMP[nY,5] )
		  	                                          
		  	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressão análise coleta a campo                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

		  	/*if (iif(!lExecjob,mv_par16==2,.F.))
		  		fResAnlCpo( aDADOSIMP[nY,1], aDADOSIMP[nY,2], aDADOSIMP[nY,3], dSTART_DATE, dEND_DATE, aDADOSIMP[nY,4], aDADOSIMP[nY,5] )
		  	endif*/
		  	
			
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
local dENDDATE 

	nVLR_PROD  := 0
	nPRC_LITRO := 0
	nPRC_FRETE := 0  
	    
   	dSTART_FIN := dSTART_DATE + 31
	dSTART_FIN := ctod("01/"+strzero(month(dSTART_FIN),2)+"/"+strzero(year(dSTART_FIN),4))
	
	if U_YIsBis(year(dSTART_FIN)) 
		dEND_FIN := ctod(Iif(strzero(month(dSTART_FIN),2)$"01/03/05/07/08/10/12","31",Iif(strzero(month(dSTART_FIN),2)=="02","29","30"))+"/"+strzero(month(dSTART_FIN),2)+"/"+strzero(year(dSTART_FIN),4))
    else
		dEND_FIN := ctod(Iif(strzero(month(dSTART_FIN),2)$"01/03/05/07/08/10/12","31",Iif(strzero(month(dSTART_FIN),2)=="02","28","30"))+"/"+strzero(month(dSTART_FIN),2)+"/"+strzero(year(dSTART_FIN),4))
    endif
	
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
			dbsetorder(4)	// ZL2_FILIAL+ZL2_PRODUT+ZL2_LOJPRD
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
		if U_YIsBis(year(dSTART_DATE)) 
			dENDDATE := ctod(Iif(strzero(month(dSTART_DATE),2)$"01/03/05/07/08/10/12","31",Iif(strzero(month(dSTART_DATE),2)=="02","29","30"))+"/"+strzero(month(dSTART_DATE),2)+"/"+strzero(year(dSTART_DATE),4))
		else
			dENDDATE := ctod(Iif(strzero(month(dSTART_DATE),2)$"01/03/05/07/08/10/12","31",Iif(strzero(month(dSTART_DATE),2)=="02","28","30"))+"/"+strzero(month(dSTART_DATE),2)+"/"+strzero(year(dSTART_DATE),4))
		endif
		//dENDDATE := ctod(Iif(strzero(month(dSTART_DATE),2)$"01/03/05/07/08/10/12","31",Iif(strzero(month(dSTART_DATE),2)=="02","28","30"))+"/"+strzero(month(dSTART_DATE),2)+"/"+strzero(year(dSTART_DATE),4))
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
			cCondSD1 := "AND 	SD1.D1_EMISSAO = '" + dtos(dENDDATE)  + "' 	" + hEnter			
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
		cQuery += "			SE1.E1_HIST,   											" + hEnter
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
				nPRC_FRETE  += (cAliasTMP)->E1_VALOR
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
				dbsetorder(4)	// ZL2_FILIAL+ZL2_PRODUT+ZL2_LOJPRD
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
	if !lExecjob
		oPrinter:Say(190, 830	, alltrim(SM0->M0_NOMECOM) +" - Filial: "+cFilAnt, oFont12:oFont )        	
	else
		oPrinter:Say(190, 630	, alltrim(SM0->M0_NOMECOM) +" - Filial: "+cFilAnt+" - ( Emitido pelo Portal do Produtor )", oFont12:oFont )        	
	endif
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
	oPrinter:Say(510, 220	,":  " + iif(SA2->A2_X_FPGTO=="C","CHEQUE","DEPOSITO: BANCO: " + alltrim(SA2->A2_BANCO) + " / AGENCIA:  "+ SA2->A2_AGENCIA +" / CONTA: " + alltrim(SA2->A2_NUMCON)), oFont14:oFont )

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

static function fTotalPrd(cSTART_DATE, cEND_DATE, cCODTRP, cDESTRP, cPRODUT, cLOJPRD, cLINCOL, nQTD_TOTAL, nPRC_LITRO, nVLR_PROD, nVLR_DESP, nVLR_CRED, nPRC_FRETE, cDOC, cSERIE)

local nFUNRURAL := 0
local nSENAR := 0
local nGilrat := 0
local nLIQUIDO  := 0
Local nVLRTRANSP := 0
Local nParc1 := 0
Local nParc2 := 0
local nPRCUNLIQ := nPRC_LITRO - nPRC_FRETE
local nPCFAT    := 0
Local cLISTCONDP  := SuperGetMV("MV_ZLCPCD",,"")			// Lista condições de pagamento para parcelas
Local cCondPag
Local cMV_ZLLIPAR := SuperGetMV("MV_ZLLIPAR",,1999) 	   	// Quantidade limite para geração de título com parcela única
//Local nMesAtual := MONTH(date())
//Local nMesrel := MONTH(ctod(cSTART_DATE))
Local nDiaRel := DAY(date())
Local nDifMes := 0
Local dMesAtual := date()
Local dMesrel := ctod(cSTART_DATE)
Local nDifDias 
Local cMV_ZLTTES  := AllTRIM(GetMV("MV_ZLTTES"))	   				// código da TES de movimento
Local nAlsenar := 0
Local nAlInss   := 0
Local nAlGilrat   := 0
Local cPontos:=0 
//nDifMes := nMesAtual - nMesrel
nDifDias := DateDiffDay(dMesAtual, dMesrel)


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
aPFunRur  := FunRur()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³aPFunRur[1]  == "F"³
//³aPFunRur[2]  == "L"³
//³aPFunRur[3]  == "J"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
nPosPer   := at(cTipoRur,"FLJ")
nPCFAT    := SA2->A2_X_PCDOC
cCondPag  := SA2->A2_COND

If Empty(alltrim(cDOC))
	nAlInss := POSICIONE("SED",1,XFILIAL("SED")+SA2->A2_NATUREZ,"ED_PERCINS")
	nAlsenar := POSICIONE("SF4",1,xFilial("SF4")+cMV_ZLTTES,"F4_ALSENAR")
Else
	nAlInss := POSICIONE("SD1",1,XFILIAL("SD1")+cDOC+cSERIE+cPRODUT+cLOJPRD,"D1_ALIQINS")
	nAlsenar := POSICIONE("SD1",1,xFilial("SD1")+cDOC+cSERIE+cPRODUT+cLOJPRD,"D1_ALSENAR")
EndIf

if nPosPer > 0
	If cTipoRur != "J"
		If cTipoRur = "F"
			If Empty(alltrim(cDOC))
				nAlGilrat := Val(aPFunRur[nPosPer])
			Else
				nAlGilrat := POSICIONE("SD1",1,xFilial("SD1")+cDOC+cSERIE+cPRODUT+cLOJPRD,"D1_ALIQFUN")
			EndIf	
			nAliquota := Val(aPFunRur[nPosPer]) + nAlInss + nAlsenar
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
			nPRCUNLIQ := nPRCUNLIQ - (( (nPRCUNLIQ * nPCFAT / 100) * (nAliquota) ) /100)
		else
			If cTipoRur = "F"
		   		nFUNRURAL := (nVLR_PROD * nAlInss) /100
		   		nGilrat := (nVLR_PROD * nAlGilrat) /100 
			EndIf
			
			nSENAR := (nVLR_PROD * nAlsenar) /100 
			nPRCUNLIQ := nPRCUNLIQ - ((nPRCUNLIQ * (nAliquota)) /100)
			
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

cPontos := (45 - len("QUANTIDADE PRODUZIDA EM LITROS"))
oPrinter:SayAlign(nLin, 70		, "QUANTIDADE PRODUZIDA EM LITROS",oFont14CN,1200,50,,0,0)
oPrinter:SayAlign(nLin, 700		, ": ",oFont14CN,1200,50,,0,0)
oPrinter:SayAlign(nLin, 750	, transform( nQTD_TOTAL, "@E 99,999,999" ),oFont14CN,400,50,,1,0)
nLin += 50
//if ((nDifMes >= 2) .OR. ((nDifMes = 1) .AND. (nDiaRel >= 8))) .OR. !lExecjob
if  nDifDias>= 37 .OR. !lExecjob
	
	oPrinter:SayAlign(nLin, 70		, "PREÇO UNITÁRIO EM LITROS BRUTO",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 750	, transform( nPRC_LITRO, "@E 9,999.9999" ),oFont14CN,400,50,,1,0)
	nLin += 50
	
	oPrinter:SayAlign(nLin, 70		, "PREÇO UNITÁRIO EM LITROS LÍQUIDO",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 750	, transform( nPRCUNLIQ , "@E 9,999.9999" ),oFont14CN,400,50,,1,0)
	nLin += 50
	
	oPrinter:SayAlign(nLin, 70		, "VALOR TOTAL DA PRODUÇÃO" ,oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 750	, transform( nVLR_PROD , "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
	nLin += 50
	
	oPrinter:SayAlign(nLin, 70		, "FUNRURAL/SENAR",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 750	, transform( nFUNRURAL + nSENAR +  nGilrat, "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
	nLin += 50
	
	oPrinter:SayAlign(nLin, 70		, "DESCONTO DÉBITOS" ,oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 750	, transform( nVLR_DESP , "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
	nLin += 50
	
	if lImpDescFRT
		nLIQUIDO := nLIQUIDO - nVLRTRANSP
		
		oPrinter:SayAlign(nLin, 70	, "DESCONTO TRANSPORTADOR" ,oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 750	, transform( nVLRTRANSP , "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
		nLin += 50
	endif
	
	oPrinter:SayAlign(nLin, 70		, "ACRÉSCIMO CRÉDITOS" ,oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 750	, transform( nVLR_CRED , "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
	nLin += 50
	
	oPrinter:SayAlign(nLin, 70		, "TOTAL LIQUIDO A RECEBER" ,oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
	oPrinter:SayAlign(nLin, 750	, transform( nLIQUIDO  , "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
	
	if cCondPag $ cLISTCONDP .and. nQTD_TOTAL > cMV_ZLLIPAR
		nParc1 := (nVLR_PROD / 2)- ((nFUNRURAL/2)  + (nSENAR / 2) + nGilrat)
		nParc2 := ((((nVLR_PROD / 2)) - nVLR_DESP - nVLRTRANSP) + nVLR_CRED - ((nFUNRURAL/2)  + (nSENAR / 2)))
		If nParc2 < 0
			nParc1 := nParc1 + nParc2
			nParc2 := 0
		EndIf
		nLin += 100
		
		oPrinter:SayAlign(nLin, 70	, "VALOR PRIMEIRA PARCELA" ,oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 750	, transform(nParc1  , "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
		nLin += 50
		
		oPrinter:SayAlign(nLin, 70	, "VALOR SEGUNDA  PARCELA" ,oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 700		, ": R$ ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 750	, transform( nParc2  , "@E 99,999,999.99" ),oFont14CN,400,50,,1,0)
		
	endif
Else
	oPrinter:SayAlign(nLin, 70		, "Informações de pagamento serão exibidas após o fechamento mensal. ",oFont12CN,1200,50,,0,0)
EndIf
nLin += 75


return




/*----------------------------------------------------------------------------------------------------
{Protheus.doc} fResAnlPrd
Função utilizada para impressão dos resultados de análises normativa 77.

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
local aResult	:= {}
local nPos := 0
local nLinhaEx
local lCPPok
local lGEOok 

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
	

	cQuery := "SELECT 	YEAR(ZL8.ZL8_DATCOL) * 100 + MONTH(ZL8.ZL8_DATCOL) as DTEXAME,	" + hEnter
	cQuery += "			ZL9.ZL9_GORD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_PROTN, 										" + hEnter  
	cQuery += "			ZL9.ZL9_LACT,  										" + hEnter  
	cQuery += "			ZL9.ZL9_SOLD,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CCS,  										" + hEnter  
	cQuery += "			ZL9.ZL9_CBT,  										" + hEnter
	cQuery += "			ZL9.ZL9_MEDGEO 										" + hEnter     
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
	cQuery += "AND 		( ZL8.ZL8_DATCOL BETWEEN '" + dtos(dINICIAL - 240) + "' 	" + hEnter
	cQuery += "AND             		             '" + dtos(dFINAL) + "' )	" + hEnter	
	cQuery += "AND 	 	ZL9.ZL9_PRODUT = '" + cCODPRD + "' 					" + hEnter
	cQuery += "AND 		ZL9.ZL9_LOJPRD = '" + cLOJPRD + "' 					" + hEnter
	cQuery += "AND 		ZL0.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL1.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL8.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		ZL9.D_E_L_E_T_    != '*' 							" + hEnter	
 	cQuery += "ORDER BY ZL8.ZL8_PROTOC DESC	 			 						" + hEnter	

	
	MemoWrite("Demograf_2.SQL",cQuery)
	
	if (Select(cAliasTMP) <> 0)
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbCloseArea())
	endif

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbselectarea(cAliasTMP)
	(cAliasTMP)->(dbgotop())

    //if ! empty ( (cAliasTMP)->ZL8_DATCOL )
    While (cAliasTMP)->(!EOF())
    	aAdd(aResult, { (cAliasTMP)->DTEXAME, ALLTRIM(str((cAliasTMP)->ZL9_GORD)), ALLTRIM(str((cAliasTMP)->ZL9_PROTN)), (cAliasTMP)->ZL9_LACT, (cAliasTMP)->ZL9_SOLD, (cAliasTMP)->ZL9_CCS, (cAliasTMP)->ZL9_CBT, (cAliasTMP)->ZL9_MEDGEO})
    	(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
		if nLin > 2500               
			PrintCabec( DTOC(dINICIAL), DTOC(dFINAL), cCODTRP, cDESTRP, cCODPRD, cLOJPRD, cLINCOL )
		endif
		
		dData := DATE()    
		
		oPrinter:Line(nLin, 5, nLin, 2300)
		nLin += 50
		oPrinter:Say(nLin, 850, "RESULTADO DE ANÁLISE - IN 77", oFont14BD:oFont )
	   	nLin += 25
		oPrinter:Line(nLin, 5, nLin, 2300)
	   		
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 699)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 901, nLin+50, 1097)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1503, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1903, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   											
	   	nLin += 35	
		oPrinter:Say(nLin, 50, "PARÂMETROS", oFont14BD:oFont )
		
		oPrinter:Say(nLin, 510, "VAL REF.", oFont14BD:oFont )
		oPrinter:Say(nLin, 715,  strzero(MONTH(DATE()-30),2) + "/"+ ALLTRIM(str(YEAR(DATE()-30))), oFont14BD:oFont )
		oPrinter:Say(nLin, 915,  strzero(MONTH(DATE()-60),2) + "/"+ ALLTRIM(str(YEAR(DATE()-60))), oFont14BD:oFont )
		oPrinter:Say(nLin, 1115, strzero(MONTH(DATE()-90),2) + "/"+ ALLTRIM(str(YEAR(DATE()-90))), oFont14BD:oFont )
		oPrinter:Say(nLin, 1315, strzero(MONTH(DATE()-120),2) + "/"+ ALLTRIM(str(YEAR(DATE()-120))), oFont14BD:oFont )
		oPrinter:Say(nLin, 1515, strzero(MONTH(DATE()-150),2) + "/"+ ALLTRIM(str(YEAR(DATE()-150))), oFont14BD:oFont )
		oPrinter:Say(nLin, 1715, strzero(MONTH(DATE()-180),2) + "/"+ ALLTRIM(str(YEAR(DATE()-180))), oFont14BD:oFont )
		oPrinter:Say(nLin, 1915, strzero(MONTH(DATE()-210),2) + "/"+ ALLTRIM(str(YEAR(DATE()-210))), oFont14BD:oFont )
		oPrinter:Say(nLin, 2115, strzero(MONTH(DATE()-240),2) + "/"+ ALLTRIM(str(YEAR(DATE()-240))), oFont14BD:oFont )
	   	
	   	nLin += 15
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 700)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 902, nLin+50, 1098)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1502, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1902, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   
	    nLinhaEx := nLin + 35
	   	nLin += 35
	   	oPrinter:Say(nLin, 50, "% GORDURA MIN ", oFont14BD:oFont )
	   	oPrinter:Say(nLin, 510, transform(nGORD_MIN,"@E 999.99"), oFont14BD:oFont )
	   	//oPrinter:Say(nLin, 710, transform((cAliasTMP)->ZL9_GORD,"@E 999.99"), oFont14:oFont )
	   	
	   	
	   	nLin += 15
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 700)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 902, nLin+50, 1098)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1502, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1902, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   										
	   	nLin += 35
	   	oPrinter:Say(nLin, 50, "% PROTEINA MIN", oFont14BD:oFont )
	   	oPrinter:Say(nLin, 510, transform(nPROT_MIN,"@E 999.99"), oFont14BD:oFont )
	   	
	   	nLin += 15
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 700)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 902, nLin+50, 1098)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1502, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1902, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   										
	   	nLin += 35
	   	oPrinter:Say(nLin, 50, "% EXTR SECO DES. MIN", oFont14BD:oFont )
	   	oPrinter:Say(nLin, 510, transform(nLACT_MIN,"@E 999.99"), oFont14BD:oFont )
	   	
	   	nLin += 15
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 700)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 902, nLin+50, 1098)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1502, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1902, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   	
	   	nLin += 35
	   	oPrinter:Say(nLin, 50, "% EXTR SECO TOT. MIN", oFont14BD:oFont )
	   	oPrinter:Say(nLin, 510, transform(nSLT_MAX,"@E 999.99"), oFont14BD:oFont )
	   	
	   	nLin += 15
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 700)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 902, nLin+50, 1098)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1502, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1902, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   										
	   nLin += 35
	   oPrinter:Say(nLin, 50, "CCS (ML) MAX", oFont14BD:oFont )
	   oPrinter:Say(nLin, 510, transform(nCCS_MAX*1000,"@E 9,999,999"), oFont14BD:oFont )
	   
	   nLin += 15
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 700)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 902, nLin+50, 1098)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1502, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1902, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   	
	   	
	   nLin += 35
	   oPrinter:Say(nLin, 50, "CPP (UFC/ML) MAX", oFont14BD:oFont )
	   oPrinter:Say(nLin, 510, transform(nCBT_MAX*1000,"@E 9,999,999"), oFont14BD:oFont )
	   
	   	nLin += 15
	   	oPrinter:Box(nLin, 5, nLin+50, 500)
	   		oPrinter:Box(nLin, 502, nLin+50, 700)
	   			oPrinter:Box(nLin, 703, nLin+50, 898)
	   				oPrinter:Box(nLin, 902, nLin+50, 1098)
	   					oPrinter:Box(nLin, 1102, nLin+50, 1300)
	   						oPrinter:Box(nLin, 1302, nLin+50, 1498)
	   							oPrinter:Box(nLin, 1502, nLin+50, 1700)
	   								oPrinter:Box(nLin, 1702, nLin+50, 1898)
	   									oPrinter:Box(nLin, 1902, nLin+50, 2100)
	   										oPrinter:Box(nLin, 2103, nLin+50, 2298)
	   	
	   	
	   nLin += 37
	   oPrinter:Say(nLin, 50, "MEDIA GEOMETRICA CPP", oFont14BD:oFont )
	   oPrinter:Say(nLin, 510, transform(nCBT_MAX*1000,"@E 9,999,999"), oFont14BD:oFont )
	   
	   	anomes := ALLTRIM(str(YEAR(DATE()-30))) + strzero(MONTH(DATE()-30),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		If (aResult[nPos][7] < nCBT_MAX)
	   			lCPPok := .T.	   			
	   		Else
	   			lCPPok := .F.
	   			
	   			oPrinter:Say(nLin + 50 , 50, "** ATENÇÃO ** CPP ESTÁ ACIMA DO LIMITE MÁXIMO PERMITIDO", oFont14BD:oFont )
	   			
	   		EndIf
	   		If (aResult[nPos][8] < nCBT_MAX)
	   			lGEOok := .T.	   			
	   		ElseIf aResult[nPos][8] > 0
	   			lGEOok := .F.
	   			
	   			oPrinter:Say(nLin+100, 50, "** ATENÇÃO ** A MEDIA GEOMÉTRICA ESTÁ ACIMA DO LIMITE MÁXIMO PERMITIDO", oFont14BD:oFont )
		
	   		EndIf
	   		
	   		oPrinter:Say(nLinhaEx    , 710, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50 , 710, transform(val(aResult[nPos][3]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 710, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 710, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 710, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 710, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 710, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	   	EndIf
	   		   	
	   	anomes := ALLTRIM(str(YEAR(DATE()-60))) + strzero(MONTH(DATE()-60),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		oPrinter:Say(nLinhaEx, 910, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50, 910, transform(val(aResult[nPos][3]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 910, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 910, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 910, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 910, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 910, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	   	EndIf
	   	
	   	anomes := ALLTRIM(str(YEAR(DATE()-90))) + strzero(MONTH(DATE()-90),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		oPrinter:Say(nLinhaEx, 1110, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50, 1110, transform(val(aResult[nPos][3]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 1110, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 1110, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 1110, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 1110, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 1110, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	    EndIf
	   	
	   	anomes := ALLTRIM(str(YEAR(DATE()-120))) + strzero(MONTH(DATE()-120),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		oPrinter:Say(nLinhaEx, 1310, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50, 1310, transform(val(aResult[nPos][3]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 1310, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 1310, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 1310, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 1310, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 1310, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	   	EndIf
	   	
	   	anomes := ALLTRIM(str(YEAR(DATE()-150))) + strzero(MONTH(DATE()-150),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		oPrinter:Say(nLinhaEx, 1510, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50, 1510, transform(val(aResult[nPos][3]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 1510, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 1510, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 1510, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 1510, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 1510, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	   	EndIf
	   	
	   	anomes := ALLTRIM(str(YEAR(DATE()-180))) + strzero(MONTH(DATE()-180),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		oPrinter:Say(nLinhaEx, 1710, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50, 1710, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 1710, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 1710, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 1710, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 1710, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 1710, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	   	EndIf
	   	
	   	anomes := ALLTRIM(str(YEAR(DATE()-210))) + strzero(MONTH(DATE()-210),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		oPrinter:Say(nLinhaEx, 1910, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50, 1910, transform(val(aResult[nPos][3]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 1910, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 1910, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 1910, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 1910, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 1910, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	   	EndIf
	   	
	   	anomes := ALLTRIM(str(YEAR(DATE()-240))) + strzero(MONTH(DATE()-240),2)
	   	nPos := aScan(aResult, {|x| AllTrim(Upper(str(x[1]))) == anomes})
	   	If nPos > 0
	   		oPrinter:Say(nLinhaEx, 2110, transform(val(aResult[nPos][2]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+50, 2110, transform(val(aResult[nPos][3]),"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+100, 2110, transform(aResult[nPos][4],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+150, 2110, transform(aResult[nPos][5],"@E 999.99"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+200, 2110, transform(aResult[nPos][6]*1000,"@E 9,999,999"), oFont14:oFont )
	   		oPrinter:Say(nLinhaEx+250, 2110, transform(aResult[nPos][7]*1000,"@E 9,999,999"), oFont14:oFont )
	   		If aResult[nPos][8] > 0
	   			oPrinter:Say(nLinhaEx+302, 2110, transform(aResult[nPos][8]*1000,"@E 9,999,999"), oFont14:oFont )
	   		EndIf
	   	EndIf
	   
	   	nLin += 125
	   	oPrinter:Line(nLin, 5, nLin, 2300)
		nLin += 50
		oPrinter:Say(nLin, 850, "EXAME DE REBANHO", oFont14BD:oFont )
	   	nLin += 25
		oPrinter:Line(nLin, 5, nLin, 2300)
			
		oPrinter:Box(nLin, 5, nLin+50, 502)
	   		oPrinter:Box(nLin, 500, nLin+50, 1000)
	   				oPrinter:Box(nLin, 1000, nLin+50, 1500)
	   					oPrinter:Box(nLin, 1502, nLin+50, 2002)
	   							oPrinter:Box(nLin, 2003, nLin+50, 2298)
		
		
		nLin += 35
			//-- Filtro dos dados
		cQuery := "SELECT TOP 1														" + hEnter
		cQuery += "     	ZLE.ZLE_PRODUT PRODUT,									" + hEnter
		cQuery += "     	ZLE.ZLE_LOJPRD LOJPRD,									" + hEnter
		cQuery += "         ZLE.ZLE_NOMPRD NOMPRD,									" + hEnter
		cQuery += "         ZLE.ZLE_LINHA  LINHA, 									" + hEnter
		cQuery += "         ZLE.ZLE_NOMLIN NOMLIN,									" + hEnter
		cQuery += "         ZLE.ZLE_DATEXA DATEXA,									" + hEnter
		cQuery += "         ZLE.ZLE_DATVAL DATVAL,									" + hEnter
		cQuery += "         ZLE.ZLE_NTUBER NTUBER,									" + hEnter
		cQuery += "         ZLE.ZLE_NBRUCE NBRUCE,									" + hEnter
		cQuery += "         ZLE.ZLE_QTDTUB QTDTUB,									" + hEnter
		cQuery += "         ZLE.ZLE_QTDBRU QTDBRU									" + hEnter	
		cQuery += "FROM " + RetSqlName("ZLE") + " ZLE								" + hEnter
		cQuery += "WHERE    ZLE.ZLE_FILIAL = '" + xFilial("ZLE") + "' 				" + hEnter
		cQuery += "AND 		( ZLE.ZLE_DATEXA BETWEEN '" + dtos(dINICIAL - 365) + "' " + hEnter
		cQuery += "AND                 		         '" + dtos(DATE()) + "' )		" + hEnter
		cQuery += "AND 		( ZLE.ZLE_DATVAL BETWEEN '" + dtos(dINICIAL - 365) + "' " + hEnter
		cQuery += "AND                 		         '" + dtos(dINICIAL + 730) + "' )" + hEnter
		cQuery += "AND 		( ZLE.ZLE_LINHA  BETWEEN '" + cLINCOL + "' 				" + hEnter
		cQuery += "AND                 		         '" + cLINCOL + "' )			" + hEnter	
		cQuery += "AND 		( ZLE.ZLE_PRODUT BETWEEN '" + cCODPRD + "' 				" + hEnter
		cQuery += "AND                 		         '" + cCODPRD + "' )			" + hEnter	
		cQuery += "AND 		( ZLE.ZLE_LOJPRD BETWEEN '" + cLOJPRD + "' 				" + hEnter
		cQuery += "AND                 		         '" + cLOJPRD + "' )			" + hEnter
		cQuery += "AND 		ZLE.D_E_L_E_T_    != '*' 								" + hEnter
		cQuery += "ORDER BY DATVAL DESC                       						" + hEnter
			
		MemoWrite("Demograf_2.SQL",cQuery)
	
		if (Select(cAliasTMP) <> 0)
			dbselectarea(cAliasTMP)
			(cAliasTMP)->(dbCloseArea())
		endif

		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
		dbselectarea(cAliasTMP)
		(cAliasTMP)->(dbgotop())

		if ! empty ( (cAliasTMP)->DATEXA )
					
			nCol := 70
			oPrinter:Say(nLin, nCol, "DATA EXAME",oFont14BD:oFont)
			nCol := 505
			oPrinter:Say(nLin, nCol, "VENCIMENTO EXAME",oFont14BD:oFont)			           
			nCol := 1005
			oPrinter:Say(nLin, nCol, "QTD EXAMES BRUC.",oFont14BD:oFont)
			nCol := 1505
			oPrinter:Say(nLin, nCol, "QTD EXAMES TUBERC.",oFont14BD:oFont)
			nCol := 2010
			oPrinter:Say(nLin, nCol, "STATUS",oFont14BD:oFont)
		
			nLin += 15
			oPrinter:Box(nLin, 5, nLin+50, 502)
				oPrinter:Box(nLin, 500, nLin+50, 1000)
	   				oPrinter:Box(nLin, 1000, nLin+50, 1500)
	   					oPrinter:Box(nLin, 1502, nLin+50, 2002)
	   							oPrinter:Box(nLin, 2003, nLin+50, 2298)
	   	
			nLin += 35
			nCol := 70
			oPrinter:Say(nLin, nCol, DTOC( STOD( (cAliasTMP)->DATEXA ) ),oFont14:oFont)
			nCol := 505
			oPrinter:Say(nLin, nCol, DTOC( STOD( (cAliasTMP)->DATVAL ) ),oFont14:oFont)			           
			nCol := 1005
			oPrinter:Say(nLin, nCol, transform((cAliasTMP)->QTDBRU,"@E 9,999,999"),oFont14:oFont)
			nCol := 1505
			oPrinter:Say(nLin, nCol, transform((cAliasTMP)->QTDTUB,"@E 9,999,999"),oFont14:oFont)
			nCol := 2010
			IF ( stod((cAliasTMP)->DATVAL) <= DATE() )
				oPrinter:Say(nLin, nCol, "Vencido",oFont14BD:oFont)
				nCol := 70
				nLin += 50
				oPrinter:Say(nLin, nCol, "Exame Vencido, favor providenciar novo exame!",oFont14BD:oFont)
			ELSE
				oPrinter:Say(nLin, nCol, "Vigente",oFont14BD:oFont)
			ENDIF
		EndIf
	
	/*
		oPrinter:SayAlign(nLin, 70, "DATA DA COLETA : "  + dtoc(stod((cAliasTMP)->ZL8_DATCOL)),oFont14CN,1200,50,,0,0)
	   	nLin += 50
	
		oPrinter:SayAlign(nLin, 70, "RESULTADOS: ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1150, "PARÂMETROS: ",oFont14CN,1200,50,,0,0)
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
	   	nLin += 75*/

	//endif 
	
	
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

	MemoWrite("Demograf_AC.SQL",cQuery)
	
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
	
		oPrinter:SayAlign(nLin, 70, "NÚMERO DA COLETA: " + (cAliasTMP)->ZLA_NUMERO,oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1150, "DATA DA COLETA : "+dtoc(stod((cAliasTMP)->ZLA_DATA)),oFont14CN,1200,50,,0,0)
	   	nLin += 50
	
		oPrinter:SayAlign(nLin, 70, "RESULTADOS: ",oFont14CN,1200,50,,0,0)
		oPrinter:SayAlign(nLin, 1150, "PARÂMETROS: ",oFont14CN,1200,50,,0,0)
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

	//conout("fTotalDesp")
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

                        
	memowrite("Demograf_3.SQL",cQuery)
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
			oPrinter:SayAlign(nLin, nCol, "DATA MOVIMENTO",oFont14CN,350,50,,0,0)
			nCol := 500
			oPrinter:SayAlign(nLin, nCol, "VENCIMENTO",oFont14CN,300,50,,0,0)			           
			nCol := 850
			oPrinter:SayAlign(nLin, nCol, "TIPO DO DÉBITO",oFont14CN,1000,50,,0,0)
			nCol := 1900
			oPrinter:SayAlign(nLin, nCol, "VALOR (R$)",oFont14CN,350,50,,1,0)

			lCabec := .T.
		endif
                          
		nLin += 50
		nCol := 70
		oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->ZLB_DTMOV ) ),oFont14CN,350,50,,0,0)
		nCol := 500
		oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->ZLB_DTVCTO ) ),oFont14CN,300,50,,0,0)			           
		nCol := 850
		oPrinter:SayAlign(nLin, nCol, alltrim(substr((cAliasTMP)->X5_DESCRI,1,18))+" / "+alltrim(substr((cAliasTMP)->ZLB_HIST,1,17)),oFont14CN,1500,60,,0,0)
		nCol := 1900
		oPrinter:SayAlign(nLin, nCol, transform((cAliasTMP)->ZLB_VALOR,"@E 99,999,999.99"),oFont14CN,350,50,,1,0)
		
		nVLR_DESP += (cAliasTMP)->ZLB_VALOR
		
		(cAliasTMP)->(dbskip())

    enddo

    (cAliasTMP)->(dbCloseArea())           

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
	//³Seleciona todos os títulos em aberto do contas a receber p/ o produtor         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ


	if lIMPSE1
	
		dbselectarea("SA1")
		dbsetorder(14) 	// Indice 13 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
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
			cQuery += "			SE1.E1_HIST,   											" + hEnter
			cQuery += "			SE1.E1_EMISSAO,   										" + hEnter
			cQuery += "			SE1.E1_VENCREA   										" + hEnter		
			cQuery += "	FROM " + RetSqlName("SE1") + " SE1								" + hEnter	
			cQuery += "	WHERE   SE1.E1_CLIENTE   = '" + SA1->A1_COD  + "'				" + hEnter
			cQuery += "	AND     SE1.E1_LOJA      = '" + SA1->A1_LOJA + "'				" + hEnter
			cQuery += " AND     ( SE1.E1_PREFIXO   != 'FRT'						 		" + hEnter
			cQuery += " AND       SE1.E1_PREFIXO   != 'PAP'						 		" + hEnter
			cQuery += " AND     SE1.E1_TIPO   != 'DP')							 		" + hEnter
			cQuery += "	AND     SE1.E1_VENCREA BETWEEN '" + dtos(dSTART_FIN) + "'		" + hEnter
			cQuery += "	AND     					   '" + dtos(dEND_FIN) + "'			" + hEnter
			if !lExecjob
				if mv_par17 != 1 
					cQuery += "	AND     SE1.E1_SALDO     > 0							" + hEnter
				endif		
			endif
			cQuery += "	AND 	SE1.D_E_L_E_T_  != '*' 									" + hEnter
			conout(cQuery)
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
					oPrinter:SayAlign(nLin, nCol, "DATA MOVIMENTO",oFont14CN,350,50,,0,0)
					nCol := 500
					oPrinter:SayAlign(nLin, nCol, "VENCIMENTO",oFont14CN,300,50,,0,0)			           
					nCol := 850
					oPrinter:SayAlign(nLin, nCol, "TIPO DO DÉBITO",oFont14CN,1000,50,,0,0)
					nCol := 1900
					oPrinter:SayAlign(nLin, nCol, "VALOR (R$)",oFont14CN,350,50,,1,0)
		
					lCabec := .T.
				endif

				if alltrim((cAliasTMP)->E1_TIPO) == "RA" .OR. (cAliasTMP)->E1_TIPO == "NCC"
					if !lExecjob
						if mv_par17 != 1
							nVALORCR := (cAliasTMP)->E1_SALDO * -1
						else
					    	nVALORCR := (cAliasTMP)->E1_VALOR * -1
						endif
					Else
						nVALORCR := (cAliasTMP)->E1_VALOR * -1
					Endif
				else
					if !lExecjob
						if mv_par17 != 1
							nVALORCR := (cAliasTMP)->E1_SALDO
						else
					    	nVALORCR := (cAliasTMP)->E1_VALOR
						endif
					Else
						nVALORCR := (cAliasTMP)->E1_VALOR
					Endif
				endif				

		                          
				nLin += 50
				nCol := 70
				oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E1_EMISSAO ) ),oFont14CN,350,50,,0,0)
				nCol := 500
				oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E1_VENCREA ) ),oFont14CN,300,50,,0,0)			           
				nCol := 850
				IF !Empty((cAliasTMP)->E1_HIST)
					oPrinter:SayAlign(nLin, nCol, ALLTRIM((cAliasTMP)->E1_HIST),oFont14CN,1000,50,,0,0)
				Else
					oPrinter:SayAlign(nLin, nCol, (cAliasTMP)->E1_PREFIXO+"-DEBITOS MESES ANTERIORES/NOTAS FISCAIS",oFont14CN,1000,50,,0,0)
				EndIf
				nCol := 1900
				oPrinter:SayAlign(nLin, nCol, transform(nVALORCR,"@R 99,999,999.99"),oFont14CN,350,50,,1,0)
		
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
    if !lExecjob
    	if mv_par17 != 1 
			cQuery += "AND 	ZLB.ZLB_STATUS    = ' '								" + hEnter		
		endif		
	endif
	cQuery += "AND 		ZLB.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "AND 		SX5.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "ORDER BY ZLB.ZLB_DTMOV, ZLB.ZLB_DTVCTO                       " + hEnter
                        
	memowrite("Demograf_3.SQL",cQuery)
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
		oPrinter:SayAlign(nLin, nCol, transform((cAliasTMP)->ZLB_VALOR,"@E 99,999,999.99"),oFont14CN,350,50,,1,0)

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
		if !lExecjob
	    	if mv_par17 != 1 
				cQuery += "	AND     SE2.E2_SALDO     > 0										" + hEnter
			endif
		endif
		cQuery += "	AND 	SE2.D_E_L_E_T_  != '*' 												" + hEnter
	    //conout(cQuery)
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
				oPrinter:SayAlign(nLin, nCol, "DATA MOVIMENTO",oFont14CN,350,50,,0,0)
				nCol := 500
				oPrinter:SayAlign(nLin, nCol, "VENCIMENTO",oFont14CN,300,50,,0,0)			           
				nCol := 850
				oPrinter:SayAlign(nLin, nCol, "TIPO DO CRÉDITO",oFont14CN,1000,50,,0,0)
				nCol := 1900
				oPrinter:SayAlign(nLin, nCol, "VALOR (R$)",oFont14CN,350,50,,1,0)
	
				lCabec := .T.
			endif

			if alltrim((cAliasTMP)->E2_TIPO) == "PA" .OR. (cAliasTMP)->E2_TIPO == "NDF"
				if !lExecjob
					if mv_par17 != 1
						nVALORCP := (cAliasTMP)->E2_SALDO * -1
					else
				    	nVALORCP := (cAliasTMP)->E2_VALOR * -1
					endif
				Else
					nVALORCP := (cAliasTMP)->E2_VALOR * -1
				Endif
				
			else
				if !lExecjob
					if mv_par17 != 1
						nVALORCP := (cAliasTMP)->E2_SALDO
					else
				    	nVALORCP := (cAliasTMP)->E2_VALOR
					endif
				Else
					nVALORCP := (cAliasTMP)->E2_VALOR
				Endif
				
			endif
	
			nLin += 50
			nCol := 70
			oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E2_EMISSAO ) ),oFont14CN,350,50,,0,0)
			nCol := 500
			oPrinter:SayAlign(nLin, nCol, DTOC( STOD( (cAliasTMP)->E2_VENCREA ) ),oFont14CN,300,50,,0,0)			           
			nCol := 850
			oPrinter:SayAlign(nLin, nCol, (cAliasTMP)->E2_PREFIXO+"-CREDITOS MESES ANTERIORES",oFont14CN,1000,50,,0,0)
			nCol := 1900
			oPrinter:SayAlign(nLin, nCol, transform(nVALORCP,"@R 99,999,999.99"),oFont14CN,350,50,,1,0)
	
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
    //cMSG3 := "As informações de pagamento (AG, CONTA, VENCIMENTOS) acima são do CADASTRO do poduto no momento da emissão do relatório"                        
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
