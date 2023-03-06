#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"


*---------------------------------------*
User Function LTMOV00X()                                                          
*---------------------------------------*
Local aTITSE1 := {}
Local aTITSE2 := {}


		aAdd (aTITSE1 , { "01LAT01FRT000025460   DP " } ) 
		aAdd (aTITSE2 , { "01LAT01001000025460   NF 6973786090001" } ) 
		

		If Len(aTITSE1) > 0 .and. Len(aTITSE2) > 0

			//зддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁDefine se compensaГЦo de credito ou debito.    Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддды
					    
              
	    	nVALMT := nTOTSE2
	    	nDEBCR := 1 
		
			aAutoCab := { 	{"AUTDVENINI450", CTOD("01/12/2011")		, nil},;
							{"AUTDVENFIM450", CTOD("16/01/2012")		, nil},; 
							{"AUTNLIM450" 	, nVALMT 					, nil},;
							{"AUTCCLI450" 	, "697378609" 	 			, nil},;
							{"AUTCLJCLI" 	, "0001"	   				, nil},;
							{"AUTCFOR450" 	, "697378609" 				, nil},;
							{"AUTCLJFOR" 	, "0001"					, nil},;
							{"AUTCMOEDA450" , "01" 						, nil},;
							{"AUTNDEBCRED" 	, nDEBCR					, nil},;
							{"AUTLTITFUTURO", .F. 						, nil},;
							{"AUTARECCHAVE" , aTITSE1 					, nil},;
							{"AUTAPAGCHAVE" , aTITSE2 					, nil}}
	
			//зддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁExecuta rotina de compensaГЦo entre carteiras.   Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддды		
			
			dbSelectArea("SE1")
			dbSelectArea("SE2")

			nOldMod := nModulo
			nModulo := 6
			MSExecAuto( {|x,y,z| FINA450(x,y,z)}, nil , aAutoCab , 3 ) //inclusao
			nModulo :=nOldMod
			
			If !lMsErroAuto

				Alert("OK")

			Else
			
				MostraErro()

			EndIf
		
		EndIf

Return	
