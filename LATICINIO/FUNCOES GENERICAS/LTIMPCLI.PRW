#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTIMPCLI บAutor  ณRafael Parma         บ Data ณ  17/11/2009 บฑฑ
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
User Function LTIMPCLI()
*-----------------------*                
                                      
Private oDlgProc    
            
Private cString  	:= "SA1"
Private cPerg    	:= "LTIMPCLI00"
Private cTitulo  	:= "Inclusใo de clientes"

    
	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	//Montagem da tela de processamento
	
	@ 200,1 TO 340,390 DIALOG oDlgProc TITLE OemToAnsi(cTitulo)
	@ 010,018 Say " Este programa tem por objetivo efetuar a inclusใo de clientes "
	@ 022,018 Say " a partir dos fornecedores cadastrados no sistema, com o tipo "
	@ 032,018 Say " produtor, estes clientes serใo amarrados ao produtor. "
	
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

	dbSelectArea("SA2")
	dbSetOrder(1)
	SET FILTER TO SA2->A2_COD  >= mv_par01 .and. SA2->A2_COD  <= mv_par02 .and. SA2->A2_LOJA >= mv_par03 .and. SA2->A2_LOJA <= mv_par04
	dbGoTop()

	While ! SA2->(EOF()) 

		If SA2->A2_X_TIPO == "P" .AND. SA2->A2_LOJA != "9999"
			
			dbSelectArea("SA1")
			dbSetOrder(14) 		// Indice 9 = A1_FILIAL+A1_X_FORN+A1_X_LOJF 
			dbGoTop()

			If ! dbSeek ( xFilial("SA1") + SA2->A2_COD + SA2->A2_LOJA )
				
				
				If RecLock("SA1", .T.)
					SA1->A1_FILIAL	:= xFilial("SA1")
					SA1->A1_COD		:= SA2->A2_COD
					SA1->A1_LOJA	:= SA2->A2_LOJA
					SA1->A1_NOME	:= SA2->A2_NOME
					SA1->A1_PESSOA	:= SA2->A2_TIPO			//-- F=Fisica; J=Juridica
					SA1->A1_NREDUZ	:= SA2->A2_NREDUZ
					SA1->A1_END		:= SA2->A2_END
					SA1->A1_TIPO	:= "F"					//-- L=Produtor Rural  ///19/05/2016 - mudamos os clientes para F pois nao estava autorizando as NF de vendas de queijos
					SA1->A1_EST		:= SA2->A2_EST
					SA1->A1_ESTADO	:= SA2->A2_ESTADO
					SA1->A1_COD_MUN	:= SA2->A2_COD_MUN
					SA1->A1_MUN		:= SA2->A2_MUN
					SA1->A1_BAIRRO	:= SA2->A2_BAIRRO
					SA1->A1_CEP		:= SA2->A2_CEP
					SA1->A1_DDI		:= SA2->A2_DDI
					SA1->A1_DDD		:= SA2->A2_DDD
					SA1->A1_CONTRIB	:= "2"
					SA1->A1_CONTA	:= "10102010001"
					SA1->A1_TEL		:= SA2->A2_TEL
					SA1->A1_FAX		:= SA2->A2_FAX
					SA1->A1_CGC		:= SA2->A2_CGC
					SA1->A1_PAIS	:= SA2->A2_PAIS
					SA1->A1_CODPAIS	:= SA2->A2_CODPAIS
					SA1->A1_INSCR	:= "ISENTO"
					SA1->A1_PFISICA := SA2->A2_PFISICA
					SA1->A1_X_FORN	:= SA2->A2_COD                               
					SA1->A1_X_LOJF  := SA2->A2_LOJA
					SA1->A1_EMAIL   := "nfe.produtor@laticiniosilvestre.com.br"
					SA1->A1_ABATIMP := "1"
					SA1->A1_X_FORMA := "CO"						
					SA1->A1_LC  	:= 500
					SA1->A1_VENCLC  := CTOD("31/12/2099")
					SA1->A1_VEND  	:= "000000"
					SA1->A1_COND  	:= "902"
					SA1->A1_GRPTRIB	:= "005"
					SA1->A1_RECCOFI := "S"
					SA1->A1_RECPIS  := "S"
					SA1->A1_RECCSLL := "S"
					SA1->A1_TABELA := AllTrim(GetMV("MX_TBPRPRD"))
					SA1->A1_GRPVEN := AllTrim(GetMV("MX_GRUPPRD"))
					
					SA1->(MsUnLock())
					nINC ++
				Endif
			EndIf
		EndIf
		
		dbSelectArea("SA2")
		SA2->(dbSkip())
		
	Enddo
    
    dbSelectArea("SA2")
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
Local i,j
aRegs  := {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Produtor De        ?","Produtor De        ?","Produtor De        ?","mv_ch1","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","",""})
	aAdd(aRegs,{cPerg,"02","Produtor Ate       ?","Produtor Ate       ?","Produtor Ate       ?","mv_ch2","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","",""})
	aAdd(aRegs,{cPerg,"03","Loja De            ?","Loja De            ?","Loja De            ?","mv_ch3","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","",""})
	aAdd(aRegs,{cPerg,"04","Loja Ate           ?","Loja Ate           ?","Loja Ate           ?","mv_ch4","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","",""})

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
