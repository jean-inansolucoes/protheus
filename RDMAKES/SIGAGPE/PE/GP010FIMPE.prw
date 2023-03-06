#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP010FIMPEºAutor  ³Alexandre Longinottiº Data ³  24/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastramento de Clientes de acordo com o cadastro de       º±±
±±º          ³funcionarios.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GP010FIMPE()

DbSelectArea("RD0")
DbSetOrder(6)
If DbSeek(xFilial("RD0")+M->RA_CIC)
	If Empty(ALLTRIM(RD0->RD0_PORTAL))
		Reclock("RD0",.F.)
		RD0->RD0_PORTAL := "000001"
		RD0->RD0_FILRH	:= xFilial("SRA")
		RD0->(MsunLock())			
	EndIf
EndIf

/*
Local aVetor 		:= {}
Local cCod   		:= ""
Local cBanco 		:= ""
Local cAgencia 		:= ""
Local cConta 		:= ""
Local cDvConta 		:= ""
Local cTpConta  	:= ""
Local lMsErroAuto	:= .F.   
Local cCmpdi		:= "N" 
Local bInclui		:= .F.    
Local bErro 		:= .T. 
Local _RegSRA       := SRA->(Recno())
Local aArea 		:= GetArea()
Local nPerLim := VAL(GetMV("MV_CREDFUN"))

If ( M->RA_CATFUNC != "A" )

		If !Inclui
			cCod := M->RA_CLIENTE
		EndIf                  	    
		                                                                                                                         
		If Inclui 
		
			//Cadastro do clientes já existe, não incluir somente desbloquear.
			If !(EMPTY(M->RA_CIC) ) //.AND. !( M->RA_CATFUNC $ "E/F" )     //Categorias E/F sao Bolsistas do ITAI, e serao amarrados ao fornecedor ITAI.
				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SUBSTR(M->RA_CIC,1,9)+"0001")  		
					dbSelectArea("SRA")
					SRA->(dbGoto(_RegSRA))
					Reclock("SRA",.F.)
					SRA->RA_CLIENTE := SA1->A1_COD
					SRA->RA_LOJA   	:= SA1->A1_LOJA				
					SRA->( Msunlock() )  
					If Msgbox("Já existe CLIENTE cadastrado com este CPF."+CHR(13)+ "Será gravado o código: "+SA1->A1_COD+"/"+SA1->A1_LOJA+" ao funcionario."+CHR(13)+"Deseja alterar o cadastro do cliente de acordo com o do funcionário?","ATENCAO","YESNO")
						cCod := SA1->A1_COD
						aVetor := { {"A1_COD"   ,cCod               ,nil},;
						{"A1_LOJA"   ,"0001"                        ,nil},;
						{"A1_NOME"   ,M->RA_NOME       				,nil},;
						{"A1_NREDUZ" ,M->RA_NOME					,nil},;
						{"A1_END"    ,M->RA_ENDEREC       			,nil},;
						{"A1_BAIRRO" ,M->RA_BAIRRO       			,nil},;
						{"A1_MUN"    ,M->RA_MUNICIP         		,nil},;
						{"A1_CEP"    ,M->RA_CEP        				,nil},; 
						{"A1_EST"    ,M->RA_ESTADO          		,nil},;
						{"A1_COD_MUN",M->RA_X_CDMUN        			,nil},; 
						{"A1_CONTRIB","2"		      				,nil},;
						{"A1_MSBLQL" ,"2"		      				,nil},;
						{"A1_COND"   ,"901"		      				,nil},;
			   			{"A1_X_FORMA","CO"		      				,nil},;					
			   			{"A1_VEND"   ,"000000"		      			,nil},;
						{"A1_LC"  	 ,((M->RA_SALARIO * nPerLim) / 100)	,nil},;
						{"A1_VENCLC" ,CTOD("31/12/2099")			,nil},;
						{"A1_COMPLEM",M->RA_COMPLEM      			,nil}}        
						MSExecAuto({ |x,y| Mata030(x,y) },aVetor, 4) //Alteracao				
		
					EndIf
					
					If SA1->A1_MSBLQL = "1" //FORNECEDOR ESTA BLOQUEADO, desbloquear.		
						Reclock("SA1",.F.)
						SA1->A1_MSBLQL := "2"
						SA1->(MsunLock())				
					EndIf 	
				Else
					bInclui := .T.
				EndIf
			Else
				bInclui := .T.
			EndIf     
			
			If bInclui // .AND. !( M->RA_CATFUNC $ "E/F" ) //Cadastro do Fornecedor não existe, incluir. 		
				IF EMPTY(M->RA_EMAIL)
					_EMAIL := "funcionarios@laticiniosilvestre.com.br"
				ELSE
					_EMAIL := M->RA_EMAIL
				ENDIF
				aVetor := { {"A1_NOME"   ,M->RA_NOME       				,nil},;
				{"A1_NREDUZ" ,M->RA_NOME					,nil},;
				{"A1_END"    ,M->RA_ENDEREC       			,nil},;
				{"A1_BAIRRO" ,M->RA_BAIRRO       			,nil},;
				{"A1_MUN"    ,M->RA_MUNICIP         		,nil},;
				{"A1_CEP"    ,M->RA_CEP        				,nil},; 
				{"A1_EST"    ,M->RA_ESTADO          		,nil},;
				{"A1_COD_MUN",M->RA_X_CDMUN        			,nil},; 
				{"A1_TIPO"   ,"F"		          			,nil},;
				{"A1_CGC"    ,M->RA_CIC             		,nil},;
				{"A1_INSCR"  ,"ISENTO"	      				,nil},;
				{"A1_CONTRIB","2"		      				,nil},;
				{"A1_CONTA"  ,"10102010001"    				,nil},;
				{"A1_MSBLQL" ,"2"		      				,nil},;
				{"A1_COND"   ,"901"		      				,nil},;
				{"A1_X_FORMA","CO"		      				,nil},;				
				{"A1_LC"  	 ,((M->RA_SALARIO * nPerLim) / 100)	,nil},;
				{"A1_VENCLC" ,CTOD("31/12/2099")			,nil},;
				{"A1_PAIS"   ,"105"			      			,nil},;  
				{"A1_CODPAIS","01058"			   			,nil},;  
				{"A1_VEND"   ,"000000"		      			,nil},;
				{"A1_EMAIL"  ,_EMAIL 		      			,nil},;
				{"A1_X_FUNC" ,M->RA_MAT		      			,nil},;
				{"A1_PESSOA" ,"F" 	 		      			,nil},;
				{"A1_COMPLEM",M->RA_COMPLEM      			,nil}}  
	
		  		MSExecAuto({ |x,y| Mata030(x,y) },aVetor, 3) //Inclusao   
	                               
				dbSelectArea("SRA")
				SRA->(dbGoto(_RegSRA))
				Reclock("SRA",.F.)
				SRA->RA_CLIENTE := SUBSTR(M->RA_CIC,1,9)
				SRA->RA_LOJA   := "0001"
				SRA->RA_FORNEC := SUBSTR(M->RA_CIC,1,9)
				SRA->( Msunlock() )
				 
			EndIf		
		
		ElseIf Altera // .AND. !( M->RA_CATFUNC $ "E/F" )
		
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+cCod+"0001")

				IF 	EMPTY(M->RA_EMAIL)
		  			_EMAIL := "funcionarios@laticiniosilvestre.com.br"
				ELSE
					_EMAIL := M->RA_EMAIL
				ENDIF
				If M->RA_SITFOLH != "D"
					aVetor := { {"A1_COD"   ,cCod               ,nil},;
					{"A1_LOJA"   ,"0001"                        ,nil},;
					{"A1_NOME"   ,M->RA_NOME       				,nil},;
					{"A1_NREDUZ" ,M->RA_NOME					,nil},;
					{"A1_END"    ,M->RA_ENDEREC       			,nil},;
					{"A1_BAIRRO" ,M->RA_BAIRRO       			,nil},;
					{"A1_MUN"    ,M->RA_MUNICIP         		,nil},;
					{"A1_CEP"    ,M->RA_CEP        				,nil},; 
					{"A1_EST"    ,M->RA_ESTADO          		,nil},;
					{"A1_COD_MUN",M->RA_X_CDMUN        			,nil},; 
					{"A1_CONTRIB","2"		      				,nil},;
					{"A1_MSBLQL" ,"2"		      				,nil},;
					{"A1_COND"   ,"901"		      				,nil},;
					{"A1_X_FORMA","CO"		      				,nil},;
					{"A1_LC"  	 ,((M->RA_SALARIO * nPerLim) / 100)	,nil},;
					{"A1_VENCLC" ,CTOD("31/12/2099")			,nil},;
					{"A1_PAIS"   ,"105"			      			,nil},;  
					{"A1_CODPAIS","01058"			   			,nil},;  
					{"A1_VEND"   ,"000000"		      			,nil},;
					{"A1_EMAIL"  ,_EMAIL 		      			,nil},;
					{"A1_PESSOA" ,"F" 	 		      			,nil},;
					{"A1_COMPLEM",M->RA_COMPLEM      			,nil}}  
			    Else
			    	If !Empty(SA1->A1_X_FUNC)
			    		aVetor := { {"A1_COD"   ,cCod               ,nil},;
						{"A1_LOJA"   ,"0001"                        ,nil},;
						{"A1_NOME"   ,M->RA_NOME       				,nil},;
						{"A1_NREDUZ" ,M->RA_NOME					,nil},;
						{"A1_END"    ,M->RA_ENDEREC       			,nil},;
						{"A1_BAIRRO" ,M->RA_BAIRRO       			,nil},;
						{"A1_MUN"    ,M->RA_MUNICIP         		,nil},;
						{"A1_CEP"    ,M->RA_CEP        				,nil},; 
						{"A1_EST"    ,M->RA_ESTADO          		,nil},;
						{"A1_COD_MUN",M->RA_X_CDMUN        			,nil},; 
						{"A1_CONTRIB","2"		      				,nil},;
						{"A1_MSBLQL" ,"1"		      				,nil},;
						{"A1_COND"   ,"901"		      				,nil},;
						{"A1_X_FORMA","CO"		      				,nil},;
						{"A1_LC"  	 ,((M->RA_SALARIO * 0) / 100)	,nil},;
						{"A1_VENCLC" ,CTOD("31/12/2000")			,nil},;
						{"A1_VEND"   ,"000000"		      			,nil},;
						{"A1_EMAIL"  ,_EMAIL 		      			,nil},;
						{"A1_COMPLEM",M->RA_COMPLEM      			,nil}} 
					Else
						aVetor := { {"A1_COD"   ,cCod               ,nil},;
						{"A1_LOJA"   ,"0001"                        ,nil},;
						{"A1_NOME"   ,M->RA_NOME       				,nil},;
						{"A1_NREDUZ" ,M->RA_NOME					,nil},;
						{"A1_END"    ,M->RA_ENDEREC       			,nil},;
						{"A1_BAIRRO" ,M->RA_BAIRRO       			,nil},;
						{"A1_MUN"    ,M->RA_MUNICIP         		,nil},;
						{"A1_CEP"    ,M->RA_CEP        				,nil},; 
						{"A1_EST"    ,M->RA_ESTADO          		,nil},;
						{"A1_COD_MUN",M->RA_X_CDMUN        			,nil},; 
						{"A1_CONTRIB","2"		      				,nil},;
						{"A1_MSBLQL" ,"2"		      				,nil},;
						{"A1_COND"   ,""		      				,nil},;
						{"A1_X_FORMA",""		      				,nil},;
						{"A1_LC"  	 ,((M->RA_SALARIO * 0) / 100)	,nil},;
						{"A1_VENCLC" ,CTOD("31/12/2000")			,nil},;
						{"A1_VEND"   ,""			      			,nil},;
						{"A1_EMAIL"  ,_EMAIL 		      			,nil},;
						{"A1_X_FUNC" ,""			      			,nil},;
						{"A1_COMPLEM",M->RA_COMPLEM      			,nil}} 
					EndIf 
			    EndIf
				MSExecAuto({ |x,y| Mata030(x,y) },aVetor, 4) //Alteracao				
					
			EndIf
		
		EndIf
			
		If lMsErroAuto          
				MostraErro()
		Endif
	
		
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+SRA->RA_CLIENTE+SRA->RA_LOJA)
		bErro := .F.
	EndIf
    
    If Altera
   		bErro := .F.
    EndIf
	  	                   
	If bErro .OR. lMsErroAuto
		Aviso("Atenção","Cliente NAO foi incluido automaticamente! Verificar.",{"OK"},2)	
		Mostraerro()
	Else 
		Aviso("Atenção","Cliente incluido/alterado com sucesso!",{"OK"},2)		
	EndIf

EndIf

RestArea(aArea)        
*/
Return()
