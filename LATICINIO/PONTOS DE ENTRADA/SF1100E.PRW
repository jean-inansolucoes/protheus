#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100E  ºAutor  ³Rafael Parma         º Data ³  25/02/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executado na exclusão do documento de entrada, atualização  º±±
±±º          ³dos flags nos itens de coleta do produtor.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------*
User Function SF1100E()
*----------------------*  
Local aArea  := GetArea()
Local aVetItem := {}
Local aVetCab := {}
Local lMV_LTRENFP := SuperGetMV("MV_LTRENFP")					// Utiliza customizacao que referencia NFP
Private lMsErroAuto := .F.


	//-- Libera registros para serem processado novamente.
	If ! Empty (SF1->F1_X_LINHA)
	
		cQuery := "UPDATE 	[" + RetSQLName("ZL6") + "]  			"
		cQuery += "SET 		ZL6_STATUS  = '', 						"
		cQuery += "			ZL6_DOC     = '', 						" 
		cQuery += "			ZL6_SERIE   = '' 						"
		cQuery += "WHERE 	ZL6_FILIAL  = '" + xFilial("ZL6") + "'	"
		cQuery += "AND  	ZL6_DOC     = '" + SF1->F1_DOC	  + "'	"
		cQuery += "AND  	ZL6_SERIE   = '" + SF1->F1_SERIE  + "'	"
		cQuery += "AND  	D_E_L_E_T_ != '*'						"
		TCSQLEXEC(cQuery)       
	
	EndIf                                                 
	
	// Limpa numero da nota da tabela das NFP
	If ( lMV_LTRENFP .And. !Empty (SF1->F1_X_NFP) ) .Or. ! Empty (SF1->F1_X_NFP)
  		dbSelectArea("ZLJ")
  		dbSetOrder(1)
 		dbGoTop()
		If dbSeek ( xFilial("ZLJ") + SF1->F1_FORNECE + SF1->F1_LOJA )
  			While ! ZLJ->(EOF()) .and. ZLJ->ZLJ_FILIAL + ZLJ->ZLJ_COD + ZLJ->ZLJ_LOJA == xFilial("ZLJ") + SF1->F1_FORNECE + SF1->F1_LOJA
				If  (ZLJ->ZLJ_NFCOMP = SF1->F1_DOC) .and. (ZLJ->ZLJ_SERIEC = SF1->F1_SERIE)
					RecLock("ZLJ",.F.)
					ZLJ->ZLJ_NFCOMP := ""
					ZLJ->ZLJ_SERIEC := ""
					ZLJ->ZLJ_EMISSA := ctod("  /  /  ")
				EndIf
				ZLJ->(dbSkip())
			EndDo
		EndIf
	EndIF

	
	/*
	//-- Estorno movimento interno valorizado.
	dbSelectArea("SD3")
	dbSetOrder(4)
	dbGoTop()
	If dbSeek( xFilial("SD3") + SF1->F1_X_NSSD3 )
	
		aArraySD3_E  := {	{"D3_TM"		,SD3->D3_TM			,Nil	},;
							{"D3_COD"		,SD3->D3_COD		,Nil	},;
							{"D3_QUANT"		,SD3->D3_QUANT		,Nil	},;
							{"D3_CUSTO1"	,SD3->D3_CUSTO1		,Nil	},;
							{"D3_LOCAL"		,SD3->D3_LOCAL		,Nil	},;
							{"D3_DOC"  		,SD3->D3_DOC		,Nil	},;
							{"D3_EMISSAO"	,SD3->D3_EMISSAO	,Nil	},;
							{"D3_NUMSEQ"	,SD3->D3_NUMSEQ		,Nil	},;
							{"INDEX",		4					,Nil	}}
		
		//MATA240(aArraySD3_E, 5)    

		aVetCab :={{"D3_TM"         ,SD3->D3_TM  ,NIL},; 
	        	  {"D3_CC"          ,SD3->D3_CC      ,NIL},; 
	    	      {"D3_EMISSAO"     ,SD3->D3_EMISSAO   ,NIL}} 
	
		aAdd(aVetItem,{{"D3_COD"    ,SD3->D3_COD   ,NIL},;
					  {"D3_LOCAL"   ,SD3->D3_LOCAL ,NIL},; 
	       	    	  {"D3_QUANT"   ,SD3->D3_QUANT ,NIL},; 
	           		  {"D3_CUSTO1"  ,SD3->D3_CUSTO1  ,NIL},; 
	           		  {"D3_NUMSEQ"	,SD3->D3_NUMSEQ		,Nil	},;
					  {"D3_X_DOC"   ,SD3->D3_X_DOC ,NIL},;
					  {"INDEX"        ,13					,Nil	}})
	           		                 
		MSExecAuto({|x,y,z| MATA241(x,y,z)},aVetCab,aVetItem,5)                 
		
		If lMsErroAuto                           		
			MostraErro()
		EndIf
			
	EndIf
	*/
	
	//-- geração de títulos de frete a pagar/receber no fechamento mensal do produtor.	 
	If SuperGetMV("MV_ZLHTFR",,.F.)		
		
		cPREFIXTIT := SuperGetMV("MV_ZLPTFR",,"")		// Prefixo do título de frete a pagar/receber
		
		//--Exclusão do título a receber (produtor)
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( SF1->F1_FILIAL + cPREFIXTIT + SF1->F1_DOC + Space(TAMSX3("E1_PARCELA")[1]) + "DP" )
			
			aTitulo := {}                                          
			AADD(aTitulo, {"E1_FILIAL" , SE1->E1_FILIAL  , Nil})   
			AADD(aTitulo, {"E1_PREFIXO", SE1->E1_PREFIXO , Nil})   
			AADD(aTitulo, {"E1_NUM"    , SE1->E1_NUM     , Nil})
			AADD(aTitulo, {"E1_PARCELA", SE1->E1_PARCELA , Nil})
			AADD(aTitulo, {"E1_TIPO"   , SE1->E1_TIPO    , Nil})  
			AADD(aTitulo, {"E1_CLIENTE", SE1->E1_CLIENTE , Nil})
			AADD(aTitulo, {"E1_LOJA"   , SE1->E1_LOJA    , Nil})
			
			nOldMod := nModulo
			nModulo := 6
			MSExecAuto({|x,y| FINA040(x,y)}, aTitulo, 5) 					
			nModulo :=nOldMod
			
			If lMsErroAuto                           		
				MostraErro()				
			EndIf
		
		EndIf
			
		//--Exclusão do título a pagar (transportador)
		dbSelectArea("SE2")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( SF1->F1_FILIAL + cPREFIXTIT + SF1->F1_DOC + Space(TAMSX3("E1_PARCELA")[1]) + "DP" )

			aTitulo := {}
			AADD(aTitulo, {"E2_FILIAL" , SE2->E2_FILIAL  , Nil})   
			AADD(aTitulo, {"E2_PREFIXO", SE2->E2_PREFIXO , Nil})   
			AADD(aTitulo, {"E2_NUM"    , SE2->E2_NUM     , Nil})
			AADD(aTitulo, {"E2_PARCELA", SE2->E2_PARCELA , Nil})
			AADD(aTitulo, {"E2_TIPO"   , SE2->E2_TIPO    , Nil})  
			AADD(aTitulo, {"E2_FORNECE", SE2->E2_FORNECE , Nil})
			AADD(aTitulo, {"E2_LOJA"   , SE2->E2_LOJA    , Nil})
			
			nOldMod := nModulo
			nModulo := 6
			MSExecAuto({|x,y,z| Fina050(x,y,z)}, aTitulo,, 5) 
			nModulo :=nOldMod
			
			If lMsErroAuto                           		
				MostraErro()				
			EndIf
		
		EndIf
	
	EndIf
	
	RestArea(aArea)

Return (.T.)
