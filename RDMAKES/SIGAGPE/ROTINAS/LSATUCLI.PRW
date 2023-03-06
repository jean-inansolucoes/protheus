#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTATUCLI บAutor  ณAlexandre Longhinottiบ Data ณ  25/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de atualiza็ใo do limite de cr้dito ds funcionแrios  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LSATUCLI()
*-----------------------*                
                                     
Private oDlgProc               
Private cString  	:= "SA1"
Private cPerg    	:= "LSATUCLI00"
Private cTitulo  	:= "Atualiza็ใo Limite de Cr้dito"

    
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	//Montagem da tela de processamento
	
	@ 200,1 TO 340,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar a ATUALIZAวรO de clientes "
	@ 022,018 Say " a partir dos funcionแrios cadastrados no sistema,"
	@ 032,018 Say " serแ atualizado o limite de cr้dito com base no salแrio. "
	
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

Local nINC := 0
Local _RegSRA := SRA->(Recno())
Local lMsErroAuto	:= .F.
Local nPerLim := VAL(GetMV("MV_CREDFUN"))  

	dbSelectArea("SRA")
	dbSetOrder(1)
	SET FILTER TO SRA->RA_MAT  >= mv_par01 .and. SRA->RA_MAT  <= mv_par02 .and. SRA->RA_FILIAL == xFilial("SRA")
	dbGoTop()

	While ! SRA->(EOF()) 

		If SRA->RA_SITFOLH != "D"			
			dbSelectArea("SA1")
			dbSetOrder(1) 		
			dbGoTop()

			If dbSeek ( xFilial("SA1") + SRA->RA_CLIENTE + SRA->RA_LOJA )
				If SA1->A1_VENCLC > CTOD("31/12/2011")				
				Reclock("SA1",.F.)
				SA1->A1_LC 	   	:= ((SRA->RA_SALARIO * nPerLim) / 100)
				SA1->A1_X_FUNC 	:= SRA->RA_MAT
				SA1->A1_VEND   	:= "000000"
				SA1->A1_X_FORMA	:= "CO"	
				SA1->A1_RISCO 	:= ""
				SA1->A1_COND 	:= "901"
				SA1->A1_TABELA 	:= AllTrim(GetMV("MV_TBPRFUN"))
				SA1->A1_GRPVEN 	:= AllTrim(GetMV("MX_GRUPFUN"))				
				SA1->A1_TPFRET := "S"
			   //	SA1->A1_VENCLC  := CTOD("31/12/2099")
				SA1->(MsunLock())		
				nINC ++
				EndIf
			EndIf
				
	   		//	dbSelectArea("SA1")
			//SA1->(dbSkip())
			dbSelectArea("SRA")
			SRA->(dbSkip())
		Else
			dbSelectArea("SA1")
			dbSetOrder(1) 		
			dbGoTop()

			If dbSeek ( xFilial("SA1") + SRA->RA_CLIENTE + SRA->RA_LOJA )
				If SA1->A1_VENCLC > CTOD("31/12/2000") .AND. !Empty(SA1->A1_X_FUNC)
					Reclock("SA1",.F.)
					SA1->A1_LC 	   := ((SRA->RA_SALARIO * 0) / 100)
			   		SA1->A1_X_FUNC := ""
					SA1->A1_VEND   	:= ""
			   		SA1->A1_X_FORMA	:= ""	
			   		SA1->A1_RISCO 	:= ""
					SA1->A1_COND 	:= ""
					SA1->A1_TABELA 	:= ""
					SA1->A1_GRPVEN 	:= ""
			   		SA1->(MsunLock())		
			   		//nINC ++
				EndIf
			EndIf
				
	   		//	dbSelectArea("SA1")
			//SA1->(dbSkip())
			dbSelectArea("SRA")
			SRA->(dbSkip())
		EndIf
	Enddo
    
    dbSelectArea("SA1")
	SET FILTER TO 
	
	Close(oDlgProc)
	If nINC > 0
		MsgInfo("Processo concluido! Foram atualizados " + cValToChar(nINC) + " clientes.")
	Else
		MsgInfo("Processo concluido! Nenhum cliente atualizado, verifique os parโmetros.")	
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
local j
local i

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
