#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LTMOV007   ¦ Autor ¦ TOTVS PARANA CENTRAL  Data ¦ 01.12.2014  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Função para importação de movimentações dos transportadores e ³±±
±±³          ³produtores conforme registros do sistema MobAgile.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TOTVS                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/* #### CONFIGURAÇÕES DO APPSERVER.INI ####

[JOBLTMOV007]
MAIN=')
ENVIRONMENT=SILVESTRE       

[ONSTART]
JOBS=JOBLTMOV007
REFRESHRATE=6000      

#### CONFIGURAÇÕES DO APPSERVER.INI #### */

*-----------------------------------------------------------------------------*
User Function LTMOV007()
*-----------------------------------------------------------------------------*
ALTERT("ROTINA DESCONTINUADA - LTMOV007")
/*
Private cArqLOG		:= "/fechamento/integracao_mobagile_"+SubSTR(DTOS(DATE()),7,2)+'_'+SubSTR(DTOS(DATE()),5,2)+'_'+SubSTR(DTOS(DATE()),1,4)+"_"+STRTRAN(Time(),":","")+".log"
Private nHldLOG		:= 0
Private nCONNMOB	:= 0
Private nCONNERP	:= 0
Private aDADOSIMP	:= {}
//Private c_Ret := getmv("MV_ESTNEG") 
Private lValida := .T.
                                                                    
	conout("LTMOV007-"+dtoc(date())+"-"+time()+"-Inicio do processo.")


	//--Avalia threads em execução e aguarda até a conclusão para inicializar a rotina.
	nLIMIT := 0
	While !FreeAllThreads()                            
		If nLIMIT > 10
			Return .F.
		EndIf
		conout("LTMOV007-"+dtoc(date())+"-"+time()+"-Processo já em execução aguardando...("+cValToChar(nLIMIT)+")")  
		Sleep(10000)
		nLIMIT += 1
	EndDo

	//--Se estiver sendo executado por JOB.
	If Type("cEmpAnt")=="U"
		//--Abertura do ambiente
		cEMPDEF := "01"
		cFILDEF := "01LAT01" 
		RPCSetType(3)
		RpcSetEnv ( cEMPDEF, cFILDEF,,, "EST", GetEnvServer(), {"SA2","SB1","SD3","ZL5","ZL6","ZL7"} )
	EndIf

    //--Criação arquivo de log
    nHldLOG := fCreate(cArqLOG)
	If nHldLOG == -1   				
		conout("LTMOV007-"+dtoc(date())+"-"+time()+"-Erro na criação do arquivo de log: " + cArqLOG )
		conout("LTMOV007-"+dtoc(date())+"-"+time()+"-Fim do processo.")
		Return				
	EndIf
	                            
	//--Adiciona registro no arquivo de log
	cTEXTO := "00-Inicio do processo de integração."
	fWriteLog(cTEXTO,nHldLOG)

	
    //--Abertura conexão MobAgile
    nCONNMOB	:= TCLink("MSSQL/MOBAGILE","192.168.0.110",7890) 
    //--Abertura conexão ERP
    nCONNERP	:= TCLink("MSSQL/DADOSPRD","192.168.0.110",7890)
 
    
    If nCONNMOB < 0 .or. nCONNERP < 0
		
		//--Adiciona registro no arquivo de log
		cTEXTO := "00-00-Falha na conexão dbAccess - MSSQL7/MOBAGILE - Erro: " + cValToChar(nCONNMOB)
		fWriteLog(cTEXTO,nHldLOG)
		TCUnLink(nCONNMOB)
		                                       
		//--Adiciona registro no arquivo de log
		cTEXTO := "00-00-Falha na conexão dbAccess - DB2/DADOSADV - Erro: " + cValToChar(nCONNERP)
		fWriteLog(cTEXTO,nHldLOG)
		TCUnLink(nCONNERP)                              
		                                                                 
	
		conout("LTMOV007-"+dtoc(date())+"-"+time()+"-Fim do processo.")
		
		//--Fecha arquivo de log
		Ft_Fuse()
		fClose(nHldLOG)		
		Return

	Else 
		//--Adiciona registro no arquivo de log
		cTEXTO := "00-00-Conexões dbAccess OK."
		fWriteLog(cTEXTO,nHldLOG)
	EndIf


	//--Adiciona registro no arquivo de log
	cTEXTO := "01-Inicio da leitura de registros de coleta MobAgile."
	fWriteLog(cTEXTO,nHldLOG)

	//--Seta conexão MobAgile
	TCSETCONN(nCONNMOB)          
	
	//--Leitura dos registros de coleta
	fReadColetas(@aDADOSIMP)

	//--Adiciona registro no arquivo de log
	cTEXTO := "01-Fim da leitura de registros de coleta MobAgile."
	fWriteLog(cTEXTO,nHldLOG)
	
	If Len(aDADOSIMP) > 0
		//--Seta conexão ERP
		TCSETCONN(nCONNERP) 
		
		Begin Transaction
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-Inicio da gravação de registros de coleta ERP."
			fWriteLog(cTEXTO,nHldLOG)
			
			//--Escrita dos registros de coletas
			lValida := fWriteColetas(aDADOSIMP)                                    		
			
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-Fim da gravação de registros de coleta ERP."
			fWriteLog(cTEXTO,nHldLOG)
	
			//--Seta conexão MobAgile
			TCSETCONN(nCONNMOB)
		    
			//--Adiciona registro no arquivo de log
			cTEXTO := "03-Inicio da atualização de registros de coleta MobAgile."
			fWriteLog(cTEXTO,nHldLOG)

		    //--Atualização dos registros MobAgile
		    If lValida 
			    fUpdColetas(aDADOSIMP)		    
            Else
       			cTEXTO := "03-Registros do MobAgile não foram atualizados!."
				fWriteLog(cTEXTO,nHldLOG)
       		EndIf
			//--Adiciona registro no arquivo de log
			cTEXTO := "03-Fim da atualização de registros de coleta MobAgile."
			fWriteLog(cTEXTO,nHldLOG)
        End Transaction
	EndIf

	//--Adiciona registro no arquivo de log
	cTEXTO := "00-Fim do processo de integração."
	fWriteLog(cTEXTO,nHldLOG)
	
	
	//--Fecha arquivo de log
	Ft_Fuse()
	fClose(nHldLOG)
	
	IF (nHandle := FOPEN(cArqLOG)) >= 0
		// Posiciona no fim do arquivo, retornando o tamanho do mesmo
		nLength := FSEEK(nHandle, 0, FS_END)
		// Posiciona no início do arquivo
		FSEEK(nHandle, 0)
		// Fecha arquivo
		FCLOSE(nHandle)
	ELSE
		MsgStop( "File open error" )
	ENDIF
	
	nHandle := fopen('/fechamento/last.log' , FO_READWRITE + FO_SHARED )
	If nHandle == -1
    	MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
       /*	If Alltrim(c_Ret) == "S"
			PutMv("MV_ESTNEG", "N") 
		EndIf   
    	//cMesgl := chr(10)+chr(13)+SubSTR(DTOS(DATE()),7,2)+'_'+SubSTR(DTOS(DATE()),5,2)+'_'+SubSTR(DTOS(DATE()),1,4)+"_"+Time()+ " - "+Alltrim(str(nLength))+" - MV_ESTNEG = "+Alltrim(c_Ret)+chr(10)+chr(13)
    	cMesgl := chr(10)+chr(13)+SubSTR(DTOS(DATE()),7,2)+'_'+SubSTR(DTOS(DATE()),5,2)+'_'+SubSTR(DTOS(DATE()),1,4)+"_"+Time()+ " - "+Alltrim(str(nLength))+chr(10)+chr(13)
    	FSEEK(nHandle, 0, FS_END)
    	fWrite(nHandle, cMesgl, 100)
      	fclose(nHandle) // Fecha arquivo
	Endif
	If nLength < 512
        FERASE(cArqLOG)
	EndIf 

	
	//--Fecha conexões dbAccess
	TCUnLink(nCONNMOB)
	TCUnLink(nCONNERP)
	
	conout("LTMOV007-"+dtoc(date())+"-"+time()+"-Fim do processo.")

*/	
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fReadColetas¦ Autor ¦ TOTVS PARANA CENTRAL  Data ¦ 01.12.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Função para leitura dos registros de coletas.                 ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TOTVS                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
Static Function fReadColetas(aDADOSIMP)
*-----------------------------------------------------------------------------*
Local cAliasTMP := GetNextAlias()
Local aAreaTMP	:= GetArea()
                                 
	
	BeginSQL ALIAS cAliasTMP 
		SELECT CODROTA, CODCARRETEIRO, CODFORNEC, CODCURRAL, 
		COLETA.ID, PLACA, IDDISPOSITIVO, LOCALIZACAO, VOLUME, 
		TEMPERATURA, COMPARTIMENTO, NUMAMOSTRA,
		CONVERT(VARCHAR(12),DATAINSERCAO,103) DATAINS,
		CONVERT(VARCHAR(12),DATAHORA,103) DATACOL,
		CONVERT(VARCHAR(12),DATAHORA,114) HORACOL
		FROM COLETA
		INNER JOIN VEICULO
		ON CODVEICULO = CODIGO
		WHERE STATUS = 0
		AND ALIZAROL != 'R'
		ORDER BY CODROTA, DATAHORA, CODCARRETEIRO, CODFORNEC, CODCURRAL
	EndSQL
	
	While !(cAliasTMP)->(EOF())                     
   		dDATAINS := ctod((cAliasTMP)->DATAINS)
		dDATACOL := ctod((cAliasTMP)->DATACOL)
		cHORACOL := SubSTR((cAliasTMP)->HORACOL,01,05)

		If Len(aDADOSIMP) == 0
			nPOS := 0
		Else
			nPOS := aScan ( aDADOSIMP, {|x| x[1] == (cAliasTMP)->CODROTA .and. x[2] == dDATAINS .and. x[3] == (cAliasTMP)->CODCARRETEIRO .and. x[4] == STRTRAN((cAliasTMP)->PLACA,"-","")  } )
		EndIf
		
		If nPOS == 0
			aAdd ( aDADOSIMP, {(cAliasTMP)->CODROTA, dDATAINS, (cAliasTMP)->CODCARRETEIRO, STRTRAN((cAliasTMP)->PLACA,"-",""), {} } )
			
			nPOS := Len(aDADOSIMP)
		EndIf
		aAdd (aDADOSIMP[nPOS][05], { 	(cAliasTMP)->CODFORNEC, (cAliasTMP)->CODCURRAL,	(cAliasTMP)->LOCALIZACAO, (cAliasTMP)->VOLUME,;
										(cAliasTMP)->TEMPERATURA, (cAliasTMP)->COMPARTIMENTO, (cAliasTMP)->NUMAMOSTRA, cHORACOL,;
										(cAliasTMP)->ID, (cAliasTMP)->IDDISPOSITIVO, dDATACOL,  STRTRAN((cAliasTMP)->PLACA,"-","")} )
		
		
		
		(cAliasTMP)->(dbSkip())
	Enddo
	
	(cAliasTMP)->(dbCloseArea())
	
	RestArea(aAreaTMP)
	
Return
        
        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fWriteColetas¦ Autor ¦ TOTVS PARANA CENTRAL  Data ¦ 01.12.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Função para gravação dos registros de coletas no ERP.         ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TOTVS                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
Static Function fWriteColetas(aDADOSIMP)
*-----------------------------------------------------------------------------*
Local aAreaTMP		:= GetArea()
Local cCODMOV		:= ""
Local nQTDTOT		:= 0
Local nI, nJ
Private lMsErroAuto	:= .F.

 
	For nI := 1 to Len(aDADOSIMP)
		
		nQTDTOT	:= 0
		
		//--Inclusão do movimento do produtor (cabeçalho)
		If ! fMovProdCab( aDADOSIMP[nI][01], aDADOSIMP[nI][02], aDADOSIMP[nI][03], nQTDTOT, @cCODMOV ) 
			DisarmTransaction()
			Return(.T.)
		Else
			
			For nJ := 1 to Len(aDADOSIMP[nI][05])
				//--Inclusão do movimento do produtor (item)
				If ! fMovProdItem( 	aDADOSIMP[nI][05][nJ][01], aDADOSIMP[nI][05][nJ][02], aDADOSIMP[nI][05][nJ][03],; 
									aDADOSIMP[nI][05][nJ][04], aDADOSIMP[nI][05][nJ][05], aDADOSIMP[nI][05][nJ][06],;										 
									aDADOSIMP[nI][05][nJ][07], aDADOSIMP[nI][05][nJ][08], aDADOSIMP[nI][05][nJ][09],;
									aDADOSIMP[nI][05][nJ][10], cCODMOV, @nQTDTOT,  aDADOSIMP[nI][05][nJ][11], aDADOSIMP[nI][05][nJ][12])
					DisarmTransaction()
					Return(.T.)
				EndIf
			Next nJ
			
			If nQTDTOT > 0
				//--Inclusão do movimento do produtor (cabeçalho) - atualização quantidade
				If ! fMovProdCab( aDADOSIMP[nI][01], aDADOSIMP[nI][02], aDADOSIMP[nI][03], nQTDTOT, @cCODMOV , aDADOSIMP[nI][05]) 
					DisarmTransaction()
					Return(.T.)
				Else
					//--Inclusão do movimento do transportador 
					If ! fMovTransp( aDADOSIMP[nI][01], aDADOSIMP[nI][02], aDADOSIMP[nI][03], nQTDTOT, ALLTRIM(aDADOSIMP[nI][04]) ) 
						DisarmTransaction()
						Return(.F.)
					EndIf		
				EndIf
			EndIf		 
				
		EndIf
	
	Next nI
	
	RestArea(aAreaTMP)
                                 
Return(.T.)            


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fWriteLog  ¦ Autor ¦ TOTVS PARANA CENTRAL  Data ¦ 01.12.2014  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Função para escrita no arquivo de log.                        ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TOTVS                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
Static Function fWriteLog(cTxt,nHdl)
*-----------------------------------------------------------------------------*

	cTxt := dtoc(date())+"-"+time()+"-"+cTxt+chr(13)+chr(10)
	fWrite(nHdl,cTxt,Len(cTxt))                             
	conout(cTxt)
	
Return
    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fUpdColeta ¦ Autor ¦ TOTVS PARANA CENTRAL  Data ¦ 01.12.2014  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Atualização do campo de status das coletas importadas.        ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TOTVS                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
Static Function fUpdColetas(aDADOSIMP)
*-----------------------------------------------------------------------------*
Local aAreaTMP := GetArea()
Local nI, nJ
	For nI := 1 to Len(aDADOSIMP)
		For nJ := 1 to Len(aDADOSIMP[nI][05])
			cQuery := " UPDATE COLETA SET STATUS = 1 WHERE ID = "+cValToChar(aDADOSIMP[nI][05][nJ][09])+" AND IDDISPOSITIVO = '"+ALLTRIM(aDADOSIMP[nI][05][nJ][10])+"'"
			If TCSQLEXEC(cQuery) < 0
				cTEXTO := "03-01-Erro na atualização do campo STATUS = 1 para o registro - ID Coleta: "+cValToChar(aDADOSIMP[nI][05][nJ][09])+" - ID Dispositivo: "+ALLTRIM(aDADOSIMP[nI][05][nJ][10])
			Else
				cTEXTO := "03-01-Realizado atualização do campo STATUS = 1 para o registro - ID Coleta: "+cValToChar(aDADOSIMP[nI][05][nJ][09])+" - ID Dispositivo: "+ALLTRIM(aDADOSIMP[nI][05][nJ][10])
			EndIf
			//--Adiciona registro no arquivo de log
			fWriteLog(cTEXTO,nHldLOG)			
		Next nJ
	Next nI

	RestArea(aAreaTMP)
		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³FreeAllThreadsºAutor ³TOTVS PARANA CENTRALº Data ³13/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³Função utilizada para avaliar Threads em execução.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------------*
Static Function FreeAllThreads()
*---------------------------------------------------------------------------*
Local aUserInfoArray	:= GetUserInfoArray()
Local cEnvServer		:= GetEnvServer()
Local cComputerName		:= GetComputerName()
Local nThreads			:= 0
Local lFreeThreads		:= .F.

aEval( aUserInfoArray , { |aThread| IF(;
											( aThread[2] == cComputerName );
											.and.;
											( aThread[5] == "U_LTMOV007" );
											.and.;
											( aThread[6] == cEnvServer ),;
											++nThreads,;
											NIL )})

lFreeThreads	:= ( nThreads == 0 )

Return( lFreeThreads )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³fMovTransp    ºAutor ³TOTVS PARANA CENTRALº Data ³13/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³Função para inclusão do movimento do transportador.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------------*
Static Function fMovTransp(cLINHA, dDATA, cTRANSP, nQUANT, cPLACA )
*---------------------------------------------------------------------------*
//Local cMV_ZLTTMV	:= AllTRIM(GetMV("MV_ZLTTMV")) 		// tipo do movimento de inclusão do estoque valorizado
Local cMV_ZLTTMI	:= AllTRIM(GetMV("MV_ZLTTMI")) 		// tipo do movimento de inclusão do estoque quantidade
Local cMV_ZLTTME	:= AllTRIM(GetMV("MV_ZLTTME")) 		// tipo do movimento de estorno do estoque
Local cMV_ZLTLOC	:= AllTRIM(GetMV("MV_ZLTLOC"))		// armazem do movimento
Local cMV_ZLTPRD	:= AllTRIM(GetMV("MV_ZLTPRD"))		// código do produto
Local aArraySD3_I	:= {}								// Array de inclusão do estoque
Local aArraySD3_E	:= {}								// Array de estorno do estoque 
//Local aAreaTMP		:= GetArea()  
Local lRet			:= .T.
Local lNewMov		:= GETMV("MV_ZLT0001",, .F.)

Private lMsErroAuto:= .F.
                                       
	cCODLIN := SubSTR(cLINHA,01,TAMSX3("ZL7_LINHA")[1])
	cCODTRP := SubSTR(cTRANSP,01,TAMSX3("ZL7_TRANSP")[1])

	//--Adiciona registro no arquivo de log
	cTEXTO := "02-03-Inicio do processo de movimento do transportador - Linha: "+cCODLIN+" - Transportador: "+cCODTRP+" - Data: "+dtoc(dDATA)
	fWriteLog(cTEXTO,nHldLOG)

	//--Define código da filial
	If SubSTR(cCODLIN,01,02) == "TB"
		cFilAnt := "01LAT01"
	ElseIf SubSTR(cCODLIN,01,02) == "GC"
		cFilAnt := "01LAT02"
	ElseIf SubSTR(cCODLIN,01,02) == "MC"
		cFilAnt := "01LAT03"
	ElseIf SubSTR(cCODLIN,01,02) == "SP"
		cFilAnt := "01LAT04"
	ElseIf SubSTR(cCODLIN,01,02) == "NE"
		cFilAnt := "01LAT05"
	ElseIf SubSTR(cCODLIN,01,02) == "PI"
		cFilAnt := "01LAT06"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras quando deve sempre incluir um novo Mov. Transportador³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lNewMov
	
		//--Inclusão de novo movimento do transportador
		While .T.
			cCODMOV := GETSXENUM("ZL7","ZL7_COD")
			dbSelectArea("ZL7")
			dbSetOrder(1)
			If !dbSeek(xFilial("ZL7")+cCODMOV)
				Exit
			EndIf
		Enddo                                          

		If RECLOCK("ZL7",.T.)
			ZL7->ZL7_FILIAL := xFilial("ZL7")
			ZL7->ZL7_COD	:= cCODMOV
			ZL7->ZL7_LINHA 	:= cCODLIN
			ZL7->ZL7_NOMLIN	:= POSICIONE("ZL0",1,xFilial("ZL0")+cCODLIN,"ZL0_DESC")
			ZL7->ZL7_TRANSP	:= cCODTRP
			ZL7->ZL7_NOMTRP	:= POSICIONE("SA4",1,xFilial("SA4")+cCODTRP,"A4_NOME")
			ZL7->ZL7_DATA	:= dDATA
			ZL7->ZL7_HORA	:= TIME()  
			ZL7->ZL7_TPROD 	:= "L"
			ZL7->ZL7_QTDVAZ := 1
			ZL7->ZL7_QTDTRP := nQUANT
			ZL7->ZL7_INTEG	:= 1
			ZL7->ZL7_PLACA	:= cPLACA
			ZL7->(MSUNLOCK())
			
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-03-Incluido novo movimento do transportador - Código: "+cCODMOV+" - Quantidade: "+cValToChar(nQUANT)
			fWriteLog(cTEXTO,nHldLOG)
		Else
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-03-Erro na inclusão do novo movimento do transportador - Código: "+cCODMOV+" - Quantidade: "+cValToChar(nQUANT)
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.		
		EndIf
		
	Else
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se já existe Mov. Transportador e atualiza o mesmo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("ZL7")
		dbSetOrder(3)
		If dbSeek( xFilial("ZL7") + cCODLIN + dtos(dDATA) )
	
	
			nQTDEST := (ZL7->ZL7_QTDTRP + ZL7->ZL7_QTDSOB ) - ( ZL7->ZL7_QTDANT + ZL7->ZL7_QTDFAL )
	
		    //-- Movimento interno inverso (movimento de saída de estoque)
			aArraySD3_E  := {	{"D3_FILIAL"	,xFilial("SD3")	 , Nil	},;
								{"D3_TM"		,cMV_ZLTTME		 , Nil	},;
								{"D3_COD"		,cMV_ZLTPRD		 , Nil	},;
								{"D3_QUANT"		,nQTDEST		 , Nil	},;						
								{"D3_LOCAL"		,cMV_ZLTLOC		 , Nil	},;
								{"D3_DOC"  		,ZL7->ZL7_COD	 , Nil	},;						
								{"D3_EMISSAO"	,ZL7->ZL7_DATA	 , Nil	} }											
			
			nModulo := 4					
			//MATA240(aArraySD3_E, 3)
	
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-03-Movimento do transportador já existente - Código: "+ZL7->ZL7_COD+" - Quantidade: "+cValToChar(nQTDEST)
			fWriteLog(cTEXTO,nHldLOG)
	
	
			If lMsErroAuto
	
				//--Adiciona registro no arquivo de log
				cTEXTO := "02-03-Erro na inclusão do movimento interno de saída de estoque: "+MostraErro()
				fWriteLog(cTEXTO,nHldLOG)
				PutMv("MV_ESTNEG", "N")
				lRet := .F.
				
			Else
	
				//--Adiciona registro no arquivo de log
				cTEXTO := "02-03-Incluido novo movimento interno de saída de estoque."
				fWriteLog(cTEXTO,nHldLOG)
		
				//--Acrescenta quantidade ao movimento já existente
				If RecLock("ZL7",.F.)
					ZL7->ZL7_QTDVAZ := ZL7->ZL7_QTDVAZ + nQUANT
					ZL7->ZL7_QTDTRP := ZL7->ZL7_QTDTRP + nQUANT
					ZL7->(MsUnLock())
					
					//--Adiciona registro no arquivo de log
					cTEXTO := "02-03-Alterada quantidade do movimento do transortador - Código: "+ZL7->ZL7_COD+" - Quantidade: "+cValToChar(ZL7->ZL7_QTDVAZ)
					fWriteLog(cTEXTO,nHldLOG)
				Else
					//--Adiciona registro no arquivo de log
					cTEXTO := "02-03-Erro na alteração da quantidade do movimento do transortador - Código: "+ZL7->ZL7_COD+" - Quantidade: "+cValToChar(ZL7->ZL7_QTDVAZ)
					fWriteLog(cTEXTO,nHldLOG)
			
					lRet := .F.
				EndIf
		
			EndIf				
		Else
			
			//--Inclusão de novo movimento do transportador
			While .T.
				cCODMOV := GETSXENUM("ZL7","ZL7_COD")
				dbSelectArea("ZL7")
				dbSetOrder(1)
				If !dbSeek(xFilial("ZL7")+cCODMOV)
					Exit
				EndIf
			Enddo                                          
	
			If RecLock("ZL7",.T.)
				ZL7->ZL7_FILIAL := xFilial("ZL7")
				ZL7->ZL7_COD	:= cCODMOV
				ZL7->ZL7_LINHA 	:= cCODLIN
				ZL7->ZL7_NOMLIN	:= POSICIONE("ZL0",1,xFilial("ZL0")+cCODLIN,"ZL0_DESC")
				ZL7->ZL7_TRANSP	:= cCODTRP
				ZL7->ZL7_NOMTRP	:= POSICIONE("SA4",1,xFilial("SA4")+cCODTRP,"A4_NOME")
				ZL7->ZL7_DATA	:= dDATA
				ZL7->ZL7_HORA	:= TIME()  
				ZL7->ZL7_TPROD 	:= "L"
				ZL7->ZL7_QTDVAZ := 1
				ZL7->ZL7_QTDTRP := nQUANT
				ZL7->ZL7_INTEG	:= 1
				ZL7->ZL7_PLACA	:= cPLACA
				ZL7->(MsUnLock())
				
				//--Adiciona registro no arquivo de log
				cTEXTO := "02-03-Incluido novo movimento do transportador - Código: "+cCODMOV+" - Quantidade: "+cValToChar(nQUANT)
				fWriteLog(cTEXTO,nHldLOG)
			Else
				//--Adiciona registro no arquivo de log
				cTEXTO := "02-03-Erro na inclusão do novo movimento do transportador - Código: "+cCODMOV+" - Quantidade: "+cValToChar(nQUANT)
				fWriteLog(cTEXTO,nHldLOG)
				lRet := .F.		
			EndIf
		EndIf
	EndIf
	
	
	If lRet 
		
		// Inclusão movimento interno
		nQTDEST := (ZL7->ZL7_QTDTRP+ ZL7->ZL7_QTDSOB ) - ( ZL7->ZL7_QTDANT + ZL7->ZL7_QTDFAL )
		
		aArraySD3_I  := {	{"D3_FILIAL"	,xFilial("SD3")		, Nil	},;
							{"D3_TM"		,cMV_ZLTTMI			, Nil	},;
							{"D3_COD"		,cMV_ZLTPRD			, Nil	},;
							{"D3_QUANT"		,nQTDEST			, Nil	},;
							{"D3_LOCAL"		,cMV_ZLTLOC			, Nil	},;
							{"D3_DOC"  		,ZL7->ZL7_COD		, Nil	},;
							{"D3_EMISSAO"	,ZL7->ZL7_DATA		, Nil	} }
		
		nModulo := 4
		//MATA240(aArraySD3_I ,3)
		
		If lMsErroAuto
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-03-Erro na inclusão do movimento interno de entrada de estoque: "+MostraErro()
			fWriteLog(cTEXTO,nHldLOG)
	
			lRet := .F.
		Else
	
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-03-Incluido novo movimento interno de entrada de estoque."
			fWriteLog(cTEXTO,nHldLOG)
		
		EndIf 
	EndIf
		

	//--Adiciona registro no arquivo de log
	cTEXTO := "02-03-Fim do processo de movimento do transportador - Linha: "+cCODLIN+" - Transportador: "+cCODTRP+" - Data: "+dtoc(dDATA)
	fWriteLog(cTEXTO,nHldLOG)
	
		
Return (lRet)  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³fMovProdCab   ºAutor ³TOTVS PARANA CENTRALº Data ³13/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³Função para inclusão do movimento do produtor - cabeçalho.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------------*
Static Function fMovProdCab(cLINHA, dDATA, cTRANSP, nQUANT, cCODMOV, Var5 )
*---------------------------------------------------------------------------*
Local lRet	:= .T.

                                       
	cCODLIN := SubSTR(cLINHA,01,TAMSX3("ZL7_LINHA")[1])
	cCODTRP := SubSTR(cTRANSP,01,TAMSX3("ZL7_TRANSP")[1])

	//--Adiciona registro no arquivo de log
	cTEXTO := "02-01-Inicio do processo de movimento do produtor (cabeçalho) - Linha: "+cCODLIN+" - Transportador: "+cCODTRP+" - Data: "+dtoc(dDATA)
	fWriteLog(cTEXTO,nHldLOG)

	//--Define código da filial
	If SubSTR(cCODLIN,01,02) == "TB"
		cFilAnt := "01LAT01"
	ElseIf SubSTR(cCODLIN,01,02) == "GC"
		cFilAnt := "01LAT02"
	ElseIf SubSTR(cCODLIN,01,02) == "MC"
		cFilAnt := "01LAT03"
	ElseIf SubSTR(cCODLIN,01,02) == "SP"
		cFilAnt := "01LAT04"
	ElseIf SubSTR(cCODLIN,01,02) == "NE"
		cFilAnt := "01LAT05"
	ElseIf SubSTR(cCODLIN,01,02) == "PI"
		cFilAnt := "01LAT06"
	EndIf
		
	dbSelectArea("ZL5")
	dbSetOrder(2)
	If dbSeek( xFilial("ZL5") + dtos(dDATA) + cCODLIN )

		cCODMOV := ZL5->ZL5_COD

		//--Adiciona registro no arquivo de log
		cTEXTO := "02-01-Cabeçalho do movimento do produtor já existente - Código: "+cCODMOV+" - Quantidade Total: "+cValToChar(ZL5->ZL5_TOTAL)
		fWriteLog(cTEXTO,nHldLOG)

		If RecLock("ZL5",.F.)
			ZL5->ZL5_TOTAL  += nQUANT
			ZL5->ZL5_PLATF  := ZL5->ZL5_PLATF
			ZL5->(MsUnLock())
			
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-01-Alterado quantidade do movimento do produtor (cabeçalho) - Código: "+cCODMOV+" - Quantidade Total: "+cValToChar(ZL5->ZL5_TOTAL)
			fWriteLog(cTEXTO,nHldLOG)
		Else
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-01-Erro na alteração do movimento do produtor (cabeçalho) - Código: "+cCODMOV+" - Quantidade Total: "+cValToChar(ZL5->ZL5_TOTAL)
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.		
		EndIf

	
	Else

		//--Inclusão de novo movimento do transportador
		While .T.
			cCODMOV := GETSXENUM("ZL5","ZL5_COD")
			dbSelectArea("ZL5")
			dbSetOrder(1)
			If !dbSeek(xFilial("ZL5")+cCODMOV)
				Exit
			EndIf
		Enddo                                          

		If RecLock("ZL5",.T.)
			ZL5->ZL5_FILIAL := xFilial("ZL5")
			ZL5->ZL5_COD	:= cCODMOV
			ZL5->ZL5_LINHA 	:= cCODLIN
			ZL5->ZL5_NOMLIN	:= POSICIONE("ZL0",1,xFilial("ZL0")+cCODLIN,"ZL0_DESC")
			ZL5->ZL5_TRANSP	:= cCODTRP
			ZL5->ZL5_NOMTRP	:= POSICIONE("SA4",1,xFilial("SA4")+cCODTRP,"A4_NOME")
			ZL5->ZL5_DATA	:= dDATA
			ZL5->ZL5_X_PARC	:= 'P'
			ZL5->ZL5_TOTAL  := 0
			ZL5->ZL5_PLATF  := 1
			ZL5->ZL5_INTEG	:= 1
			ZL5->(MsUnLock())
			
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-01-Incluido novo movimento do produtor (cabeçalho) - Código: "+cCODMOV+" - Quantidade: "+cValToChar(nQUANT)
			fWriteLog(cTEXTO,nHldLOG)
		Else
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-01-Erro na inclusão do novo movimento do produtor (cabeçalho) - Código: "+cCODMOV+" - Quantidade: "+cValToChar(nQUANT)
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.		
		EndIf
				
	EndIf 

	//--Adiciona registro no arquivo de log
	cTEXTO := "02-01-Fim do processo de movimento do produtor (cabeçalho) - Linha: "+cCODLIN+" - Transportador: "+cCODTRP+" - Data: "+dtoc(dDATA)
	fWriteLog(cTEXTO,nHldLOG)

	
Return (lRet)										


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³fMovProdItem  ºAutor ³TOTVS PARANA CENTRALº Data ³13/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³Função para inclusão do movimento do produtor - item.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


*---------------------------------------------------------------------------*
Static Function fMovProdItem(cFORNECE, cLOJA, cLOCALIZ, nVOLUME, nTEMPERAT, nTANQUE, nAMOSTRA, cHORACOL, nIDCOL, cIDDISP, cCODMOV, nQTDTOT, dDATACOL, cPLACA )
*---------------------------------------------------------------------------*
Local lRet	:= .T.

                                       
	cCODPRD := SubSTR(cFORNECE,01,TAMSX3("ZL6_PRODUT")[1])
	cLOJPRD := SubSTR(cLOJA,01,TAMSX3("ZL6_LOJPRD")[1])
	cIDISP	:= PadL(cIDDISP, TAMSX3("ZL6_IDDISP")[1])

	//--Adiciona registro no arquivo de log
	cTEXTO := "02-02-Inicio do processo de movimento do produtor (item) - Produtor: "+cCODPRD+" - Loja: "+cLOJPRD+" - ID Coleta: "+cValToChar(nIDCOL)+" - ID Dispositivo: "+ALLTRIM(cIDISP)
	fWriteLog(cTEXTO,nHldLOG)

	dbSelectArea("ZL6")
	dbSetOrder(4)
	If dbSeek( xFilial("ZL6") + cCODMOV + cIDISP + ALLTRIM(STR(nIDCOL)) )

		//--Adiciona registro no arquivo de log
		cTEXTO := "02-02-Item do movimento do produtor já existente - Produtor: "+cCODPRD+" - Loja: "+cLOJPRD+" - ID Coleta: "+cValToChar(nIDCOL)+" - ID Dispositivo: "+ALLTRIM(cIDISP)
		fWriteLog(cTEXTO,nHldLOG)
	
	Else
		nTEMPERAT:=StrTran( cValToChar(nTEMPERAT), ",", "." ) 
		If RecLock("ZL6",.T.)
			ZL6->ZL6_FILIAL := xFilial("ZL6")
			ZL6->ZL6_COD	:= cCODMOV
			ZL6->ZL6_SEQ   	:= fNextSeq(xFilial("ZL6"),cCODMOV)
			ZL6->ZL6_PRODUT	:= cCODPRD
			ZL6->ZL6_LOJPRD	:= cLOJPRD
			ZL6->ZL6_NOMPRD	:= POSICIONE("SA2",1,xFilial("SA2")+cCODPRD+cLOJPRD,"A2_NOME")
			ZL6->ZL6_AMOSTR	:= cValToChar(nAMOSTRA)
			ZL6->ZL6_QTDE   := nVOLUME
			ZL6->ZL6_IDDISP := cIDISP
			ZL6->ZL6_IDMOB  := nIDCOL
			ZL6->ZL6_TANQUE := cValToChar(nTANQUE)
			ZL6->ZL6_TEMPER := IIF( LEN(nTEMPERAT) > 3, 2 ,VAL(nTEMPERAT))
			ZL6->ZL6_HORCOL	:= cHORACOL
			ZL6->ZL6_SEQZL7	:= IIF(ALLTRIM(UPPER(cLOCALIZ))=="NULL", Space(TAMSX3("ZL6_SEQZL7")[1]), cLOCALIZ )
		  	ZL6->ZL6_DTCOL	:= dDATACOL
		  	ZL6->ZL6_PLACA	:= IIF(ALLTRIM(UPPER(cPLACA))=="NULL", Space(TAMSX3("ZL6_PLACA")[1]), cPLACA )
			
			ZL6->(MsUnLock())
			
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-02-Incluido novo movimento do produtor (item) - Produtor: "+cCODPRD+" - Loja: "+cLOJPRD+" - ID Coleta: "+cValToChar(nIDCOL)+" - ID Dispositivo: "+ALLTRIM(cIDISP)
			fWriteLog(cTEXTO,nHldLOG)
			
			//--Atualização do totalizador de movimentos
			nQTDTOT += nVOLUME
			
		Else
			//--Adiciona registro no arquivo de log
			cTEXTO := "02-02-Erro na inclusão do novo movimento do produtor (item) - Produtor: "+cCODPRD+" - Loja: "+cLOJPRD+" - ID Coleta: "+cValToChar(nIDCOL)+" - ID Dispositivo: "+ALLTRIM(cIDISP)
			fWriteLog(cTEXTO,nHldLOG)
			lRet := .F.		
		EndIf
	EndIf 

	//--Adiciona registro no arquivo de log
	cTEXTO := "02-02-Fim do processo de movimento do produtor (item) - Produtor: "+cCODPRD+" - Loja: "+cLOJPRD+" - ID Coleta: "+cValToChar(nIDCOL)+" - ID Dispositivo: "+ALLTRIM(cIDISP)
	fWriteLog(cTEXTO,nHldLOG)

	
Return (lRet)										


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fNextSeq    ¦ Autor ¦ TOTVS PARANA CENTRAL  Data ¦ 01.12.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Função para retornar próximo número sequencial do movimento do³±±
±±³          ³produtor.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TOTVS                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------*
Static Function fNextSeq(cCODFIL, cCODMOV)
*-----------------------------------------------------------------------------*
Local cAliasTMP := GetNextAlias()
Local aAreaTMP	:= GetArea()
Local nSeq		:= 0
                                 
	
	BeginSQL ALIAS cAliasTMP 
		SELECT MAX (ZL6.ZL6_SEQ) ZL6_SEQ
		FROM %Table:ZL6% ZL6
		WHERE 	ZL6.ZL6_FILIAL 	= %Exp:cCODFIL%
		AND 	ZL6.ZL6_COD		= %Exp:cCODMOV%
		AND 	ZL6.%notDel%
	EndSQL
	
	If !(cAliasTMP)->(EOF())                     
		nSeq := Val((cAliasTMP)->ZL6_SEQ)
	EndIf            
	(cAliasTMP)->(dbCloseArea())
	
	cRet := STRZero(nSeq+1,TAMSX3("ZL6_SEQ")[1])
	
	RestArea(aAreaTMP)
	
Return (cRet)
