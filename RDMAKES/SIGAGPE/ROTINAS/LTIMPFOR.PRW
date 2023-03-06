#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTIMPFOR บAutor  ณRafael Parma         บ Data ณ  17/11/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de inclusใo de clientes a partir dos fornecedores    บฑฑ
ฑฑบ          ณde tipo produtor.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*-----------------------*
User Function LTIMPFOR()                                                                             	
*-----------------------*                
                                      
Private oDlgProc    
            
Private cString  	:= "SA2"
Private cPerg    	:= "LTIMPFOR01"
Private cTitulo  	:= "Inclusใo de fornecedores

    
	AjustaSX1()
	//If !Pergunte(cPerg,.T.)
	  //	Return
	//EndIf
	//Montagem da tela de processamento
If !(Alltrim(FunName()) == "LSFIN004")
	@ 200,1 TO 340,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar a inclusใo de fornecedores "
	@ 022,018 Say " a partir dos funcionarios cadastrados no sistema, "
	@ 032,018 Say " estes fornecedores serใo amarrados ao funcionarios. "
	
	@ 02,010 TO 050,190
	@ 056,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)	
	@ 056,130 BMPBUTTON TYPE 01 ACTION RptStatus({|| fProcessa(oDlgProc) },cTitulo)  
	@ 056,160 BMPBUTTON TYPE 02 ACTION Close(oDlgProc)
	
	Activate Dialog oDlgProc Centered		
Else
    fProcessa(oDlgProc)
EndIf	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalPrd  บAutor  ณRafael Parma         บ Data ณ  17/11/2009 บฑฑ
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
Local aVetor 		:= {}

If Empty(mv_par01)
	mv_par01 := "     "
EndIf
If Empty(mv_par02)
	mv_par02 := "ZZZZZ"
EndIf

dbSelectArea("SRA")
	dbSetOrder(1)
	SET FILTER TO SRA->RA_MAT  >= mv_par01 .and. SRA->RA_MAT  <= mv_par02
	dbGoTop()

	While ! SRA->(EOF()) 

		//If SRA->RA_SITFOLH != "D" .OR. CTOD("20/05/2012") < SRA->RA_DEMISSA
			
			dbSelectArea("SA2")
			dbSetOrder(1) 		// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
			dbGoTop()

			If ! dbSeek ( xFilial("SA2") + SUBSTR(SRA->RA_CIC,1,9) + "0001" )
				
				
				If RecLock("SA2", .T.)
					SA2->A2_FILIAL	:= xFilial("SA2")
					SA2->A2_COD		:= SUBSTR(SRA->RA_CIC,1,9)
					SA2->A2_LOJA	:= "0001"
					SA2->A2_NOME	:= SRA->RA_NOME
					SA2->A2_TIPO	:= "F"			//-- F=Fisica; J=Juridica
					SA2->A2_NREDUZ	:= SRA->RA_NOME
					SA2->A2_END		:= SRA->RA_ENDEREC
					SA2->A2_EST		:= SRA->RA_ESTADO
					SA2->A2_COD_MUN	:= SRA->RA_X_CDMUN
					SA2->A2_BAIRRO	:= SRA->RA_BAIRRO
					SA2->A2_CEP		:= SRA->RA_CEP
					SA2->A2_CONTA	:= "20103010001"
					SA2->A2_CGC		:= SRA->RA_CIC
					SA2->A2_PFISICA	:= SRA->RA_RG
					SA2->A2_PAIS	:= "105"
					SA2->A2_CODPAIS	:= "01058"
					SA2->A2_INSCR	:= "ISENTO"
					SA2->A2_X_FUNC	:= SRA->RA_MAT
					SA2->A2_SIMPNAC	:= "2"
					SA2->(MsUnLock())
					nINC ++
				Endif
            Else
            			Reclock("SA2",.F.)
            			SA2->A2_X_FUNC	:= SRA->RA_MAT
						SA2->(MsUnLock())
			EndIf
		//EndIf
		
		dbSelectArea("SRA")
		SRA->(dbSkip())
		
	Enddo
    
    dbSelectArea("SRA")
	SET FILTER TO 
	If !(Alltrim(FunName()) == "LSFIN004")
		Close(oDlgProc)
		If nINC > 0
			MsgInfo("Processo concluido! Foram incluidos " + cValToChar(nINC) + " novos fornecedores.")
		Else
			MsgInfo("Processo concluido! Nใo foram incluidos novos fornecedores, verifique os parโmetros.")	
		EndIf                                                                                      
	EndIf
	

Return Nil  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  17/11/09   บฑฑ
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
aRegs  := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch1","C",TAMSX3("RA_MAT")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SRA","",""})
	aAdd(aRegs,{cPerg,"02","Produtor Ate       ?","Produtor Ate       ?","Produtor Ate       ?","mv_ch2","C",TAMSX3("RA_MAT")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SRA","",""})

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
