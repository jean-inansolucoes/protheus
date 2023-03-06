#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTIMPCLI บAutor  ณAlexandre Longhinottiบ Data ณ  25/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de inclusใo de clientes a partir dos funcionแrios    บฑฑ
ฑฑบ          ณde tipo produtor.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LSIMPCLI()
*-----------------------*                
                                  
Private oDlgProc               
Private cString  	:= "SA1"
Private cPerg    	:= "LSIMPCLI00"
Private cTitulo  	:= "Inclusใo de clientes"

    
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	//Montagem da tela de processamento
	
	@ 200,1 TO 340,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar a inclusใo de clientes "
	@ 022,018 Say " a partir dos funcionแrios cadastrados no sistema"
	@ 032,018 Say " estes clientes serใo amarrados ao funcionแrio. "
	
	@ 02,010 TO 050,190
	@ 056,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)	
	@ 056,130 BMPBUTTON TYPE 01 ACTION RptStatus({|| fProcessa(oDlgProc) },cTitulo)  
	@ 056,160 BMPBUTTON TYPE 02 ACTION Close(oDlgProc)
	
	Activate Dialog oDlgProc Centered		
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTIMPCLI บAutor  ณAlexandre Longhinottiบ Data ณ  25/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de inclusใo de clientes a partir dos fornecedores    บฑฑ
ฑฑบ          ณde tipo produtor.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fProcessa(oDlgProc)                                                      

Local nPerLim := VAL(GetMV("MV_CREDFUN"))    
Local nINC := 0
//Local _RegSRA := SRA->(Recno())
Local lMsErroAuto	:= .F. 

	dbSelectArea("SRA")
	dbSetOrder(1)
	SET FILTER TO SRA->RA_MAT  >= mv_par01 .and. SRA->RA_MAT  <= mv_par02 .and. SRA->RA_SITFOLH != 'D' .and. ALLTRIM(SRA->RA_CLIENTE) ==''
	dbGoTop()

	While ! SRA->(EOF()) 
                                                                                       
		
			dbSelectArea("SA1")
			dbSetOrder(1) 		
			dbGoTop()

			If ! dbSeek ( xFilial("SA1") + SRA->RA_CLIENTE + SRA->RA_LOJA )
				
				
				IF EMPTY(SRA->RA_EMAIL)
					_EMAIL := "SEM"
				ELSE
					_EMAIL := SRA->RA_EMAIL
				ENDIF
				aVetor := { {"A1_COD"   ,SUBSTR(SRA->RA_CIC,1,9),nil},;
				{"A1_LOJA"   ,"0001"                        ,nil},;
				{"A1_PESSOA" ,"F" 	 		      			,nil},;
				{"A1_TIPO"   ,"F"		          			,nil},;
				{"A1_NOME"   ,SRA->RA_NOME       			,nil},;
				{"A1_NREDUZ" ,SRA->RA_NOME					,nil},;
				{"A1_CGC"    ,SRA->RA_CIC             		,nil},;
				{"A1_END"    ,SRA->RA_ENDEREC       		,nil},;
				{"A1_EST"    ,SRA->RA_ESTADO          		,nil},;
				{"A1_BAIRRO" ,SRA->RA_BAIRRO       			,nil},;
				{"A1_COD_MUN",SRA->RA_X_CDMUN        		,nil},; 
				{"A1_MUN"    ,SRA->RA_MUNICIP         		,nil},;
				{"A1_PAIS"   ,"105"			      			,nil},;
				{"A1_CEP"    ,SRA->RA_CEP        			,nil},; 
				{"A1_INSCR"  ,"ISENTO"	      				,nil},;
				{"A1_EMAIL"  ,_EMAIL 		      			,nil},;
				{"A1_X_CANAL"   ,"999999"	      			,nil},;
				{"A1_CONTA"  ,"10102010001"    				,nil},;
				{"A1_TPFRET"  ,"S"    						,nil},;
				{"A1_TPESSOA" ,"PF" 	 		      		,nil},;
				{"A1_CODPAIS","01058"			   			,nil},;  
				{"A1_RECCPFI","S"				   			,nil},;  
				{"A1_RECPIS","S"				   			,nil},;  
				{"A1_CONTRIB","2"		      				,nil},;
				{"A1_SIMPNAC" ,"2" 	 		      			,nil},;
				{"A1_GRPTRIB"   ,"005"			      		,nil},;  
				{"A1_MSBLQL" ,"2"		      				,nil},;
				{"A1_COND"   ,"901"		      				,nil},;
				{"A1_X_FORMA","CO"		      				,nil},;				
				{"A1_X_ENIC","2"		      				,nil},;	
				{"A1_LC"  	 ,((SRA->RA_SALARIO * nPerLim) / 100)	,nil},;
				{"A1_VENCLC" ,ctod("31/12/2099")			,nil},;
				{"A1_VEND"   ,"000000"		      			,nil},;
				{"A1_TABELA"   ,AllTrim(GetMV("MV_TBPRFUN"))			,nil},;
				{"A1_GRPVEN"   ,AllTrim(GetMV("MX_GRUPFUN"))			,nil},;
				{"A1_X_FUNC" ,SRA->RA_MAT		      		,nil},;
				{"A1_COMPLEM",SRA->RA_COMPLEM      			,nil}}  
	
		  		MSExecAuto({ |x,y| Mata030(x,y) },aVetor, 3) //Inclusao   
	            
	            If !lMsErroAuto               
					Reclock("SRA",.F.)
					SRA->RA_CLIENTE := SUBSTR(SRA->RA_CIC,1,9)
			   		SRA->RA_LOJA   := "0001"
			   		SRA->( Msunlock() )
			   		nINC ++
				Else
					MostraErro()
        			ConOut("Erro na Inclusao!")
				EndIf
				
			EndIf
				
	   		//	dbSelectArea("SA1")
			//SA1->(dbSkip())
			dbSelectArea("SRA")
			SRA->(dbSkip())
	
	Enddo
    
    dbSelectArea("SA1")
	SET FILTER TO 
	
	Close(oDlgProc)
	
	If nINC > 0
		MsgInfo("Processo concluido! Foram incluidos " + cValToChar(nINC) + " novos clientes.")
	Else
		MsgInfo("Processo concluido! Nใo foram incluidos novos clientes, verifique os parโmetros.")	
	EndIf                                                                                      
	

Return Nil  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTIMPCLI บAutor  ณAlexandre Longhinottiบ Data ณ  25/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()
local i, j
aRegs  := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Funcinแrio De      ?","Funcinแrio De      ?","Funcinแrio De      ?","mv_ch1","C",TAMSX3("RA_MAT")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SRA","",""})
	aAdd(aRegs,{cPerg,"02","Funcinแrio At้     ?","Funcinแrio At้     ?","Funcinแrio Ate     ?","mv_ch2","C",TAMSX3("RA_MAT")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SRA","",""})
	
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
