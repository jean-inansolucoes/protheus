/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M185EST  ºAutor  ³Joel Lipnharski     º Data ³  04/01/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de movimentacao interna de estorno ref. lancamento º±±
±±º          ³ gerado para transferencia para o armazem de destino.       º±±
±±º          ³ ESTORNO MOVIMENTO P.E.: M185GRV.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M185EST()
/*    
Local aVetItem := {}
Local aVetCab := {}
Local cTPMov    := GETMV("MV_SD3EST") //Cod. Movimentacao inclusao
Local cProd     := SD3->D3_COD
Local cNumDoc   := SD3->D3_NUMSEQ
Local RegSD3    := SD3->( Recno() )
Local aAreaSD3  := GetArea()    

PRIVATE lMsErroAuto := .F.

dbSelectArea("SD3")
dbSetOrder(15)
dbGoTop()
If dbSeek( xFilial("SD3") + "100" + cNumDoc + cProd )

	Begin Transaction   
                                                                         	
		

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
	           		                 
		MSExecAuto({|x,y,z| MATA241(x,y,z)},aVetCab,aVetItem,6)   

			
		If lMsErroAuto
			MostraErro()
		EndIf
	         
	End Transaction
				
EndIf 

dbSelectArea("SD3")
SD3->(dbGoto(RegSD3))       

RestArea(aAreaSD3)
*/
Return()
