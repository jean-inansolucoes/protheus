#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????Ŀ??
???Program   ?LSFIN009 ? Autor ?Rafael Parma            ? Data ?22.03.2012  ???
???????????????????????????????????????????????????????????????????????????Ĵ??       
???Descri??o ?Retorna registro do movimento banc?rio ref. libera??o			???
??? do cheque, exclu?do no PE A390CHEQ						   				???
???????????????????????????????????????????????????????????????????????????Ĵ??
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
/*/
*-----------------------------------------------------------------------------*
User Function LSFIN009()
*-----------------------------------------------------------------------------*
Private cPerg  := "LSFIN00009"
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
                   
	If U_LSF8USE5(mv_par01, mv_par02, mv_par06, "", "", "", mv_par03, mv_par04, mv_par05) 				
			//--Atualiza??o do saldo banc?rio...
			AtuSalBco(mv_par03, mv_par04, mv_par05, mv_par06, mv_par02, "-")
		
	EndIf

Return 

/*/
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????Ŀ??
???Program   ?AjustaSX1? Autor ?Rafael Parma            ? Data ?22.03.2012  ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ?Rotina para cria??o dos par?metros (SX1).                     ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
/*/
*-----------------------------------------------------------------------------*
Static Function AjustaSX1()
*-----------------------------------------------------------------------------*
Local aRegs  	:= {}  

aAdd(aRegs,{cPerg,"01","Cheque N?        ?","Cheque N?        ?","Cheque N?        ?","mv_ch01" ,"C",TAMSX3("E5_NUMCHEQ")[1] 	,0,0,"G","			","mv_par01",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"02","Valor do Cheque  ?","Valor do Cheque  ?","Valor do Cheque  ?","mv_ch02" ,"N",TAMSX3("E5_VALOR")[1]		,2,0,"G","			","mv_par02",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"03","Banco	         ?","Banco		      ?","Banco            ?","mv_ch03" ,"C",TAMSX3("E5_BANCO")[1]		,0,0,"G","			","mv_par03",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"04","Agencia          ?","Agencia          ?","Agencia          ?","mv_ch04" ,"C",TAMSX3("E5_AGENCIA")[1] 	,0,0,"G","			","mv_par04",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"05","Conta            ?","Conta            ?","Conta            ?","mv_ch05" ,"C",TAMSX3("E5_CONTA")[1] 		,0,0,"G","			","mv_par05",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"06","Data Movimento   ?","Data Movimento   ?","Data Movimento   ?","mv_ch06", "D",08                      	,0,0,"G","			","mv_par06",         	"",        		"",         	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
//aAdd(aRegs,{cPerg,"07","Filial de		 ?","Filial de		  ?","Filial de		   ?","mv_ch07", "C",07                      	,0,0,"G","			","mv_par07",		    "",			    "",			    "","","", 	    "",	      "",	    "","","",	  "",	  "",	  "","","","","","","","","","","","",   "XM0","","","", 			 ""})


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

Return
