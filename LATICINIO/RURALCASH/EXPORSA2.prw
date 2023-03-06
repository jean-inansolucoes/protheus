#INCLUDE "totvs.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH" 
/*
Programa: EXPORSA1
Autor: IGOR BENTES
Data: 09/02/2022
Desc.: PERMITE EXPORTA CADASTRO DE CLIENTES .CSV SOUK 

*/
user function EXPORSA2(cDiretorio, cLacDe1, cLacAte1, cOPData1)

Local   cQuery 
Local   cRetorno     
Local   cAlias 		:= getNextAlias()
Local   aArea 		:= GetArea()  

Default cDiretorio	:= "/RURALCASH/" // caso de execução seja via SMARTCLIENT
Default cLacDe1		:= ''
Default cLacAte1	:= 'ZZZZZZZZZ'
Default cOPData1	:= ''
private lExecjob	:= isBlind() // caso de execução seja via SCHEDULE
Private cArquivo    := 'EXPORSA2'
  		nTotalReg 	:= 0
Private aVetProd 	:= {}
	    cRet 		:= ""
	    aCab		:= {}
     	aLin 		:= {}
     	cLinha 		:= ""
     	cInsert     := ""

if lExecjob // caso de execução seja via SCHEDULE
	cDiretorio	:= "/RURALCASH/"
EndIf

CONOUT("EXPORSA2-" + DTOC(DATE()) + "-" + TIME() + "-Inicio do processo.")     	

If Type("cEmpAnt")=="U"
		WFPrepEnv("01","01LAT01")
EndIf

  aCab   := { "cpf", "tipo", "dia-faturamento" }
    

 // QUERY PARA BUSCAR OS CAMPOS NO SISTEMA PROTHEUS 
  cQuery :=  "SELECT TRIM(SA2.A2_CGC) AS CPF, " +chr(10)
  	cQuery += "   IIF( (TRIM(SA2.A2_X_FUNC)) = '','P','F') AS TIPO,"+chr(10)
	cQuery += "   SA2.A2_COND AS COND "+chr(10)
	cQuery += "FROM " + RetSqlName("SA2") + " AS SA2 "+chr(10)
  	cQuery += "WHERE SA2.D_E_L_E_T_<> '*' AND  SA2.A2_X_ENRUR = '1' AND  SA2.A2_X_DTENV = '' AND SA2.A2_MSBLQL <> '1' " +chr(10)
	
 
   // GRAVA SQL EXECUTADO PARA ANALISE CASO DE ERRO 
    MemoWrite(cArquivo  +".sql",  cQuery)
   
    TcQuery cQuery New Alias cAlias
   // REALIZA UMA CONTAGEM PARA VERIFICAR QUANTOS REGISTRO ENCONTROU 
    While !Eof()
        nTotalReg := nTotalReg +1 
        cAlias->(dbSkip())
    Enddo
   // POSICIONA NO PRIMEIRO REGISTRO APOS CONTAGEM 
    cAlias->(dbGoTop()) 
   // INICIA LOOP ATE 
   
    
   
   
   nNex :=0
   While nTotalReg <> nNex
			   aParc := Condicao(1,cAlias->COND,,dDataBase)
			   dFat := SUBSTR(DTOC(aParc[1,1]),1,2)
			   cCNPJ                := ALLTRIM( cAlias->CPF )	      
           	   nTipo              := cAlias->TIPO
			   
			   
          
          aAdd(aVetProd, {cCNPJ, nTipo, dFat })
               
	         nNex := nNex +1
	       cAlias->(dbSkip())
	
	    Enddo	
		
	  cAlias->( DbCloseArea() ) 
	
      RestArea(aArea)

     U_CSV_SA2(cDiretorio, aCab, aVetProd)
     nTotal  := Len(aVetProd)
      
CONOUT("EXPORSA2-" + DTOC(DATE()) + "-" + TIME() + "- FIM do processo.")     	   

//MsgStop("PROCESSO FINALIZADO! TOTAL DE REG. GERADOS="+ str(nTotalReg) +" ARQUIVO GERADO :"+cArquivo+".CSV ")
    	


Return


User function CSV_SA2(cDiretorio, aCab, aDados)

Local cCSV    := ""  
Local aLin    := aDados  
Local cDados  := "" 
Local L
Local cComandoApi := ""
Local cDirApi := "D:\TOTVS12\Microsiga\Protheus_Data\RURALCASH\"


nHdl   := 0
hEnter		:= CHR(13) + CHR(10)
cArquivo    := 'EXPORSA2'
cNomeArq := "producer-" + DTOS(DATE()) + REPLACE(TIME(),":","") +".csv"
cNomeBat := "producer.ps1"
cDestinoDef	:= alltrim(cDiretorio)+alltrim(cNomeArq) //"D:\" + cNomeArq
cDestinoBat	:= alltrim(cDiretorio)+alltrim(cNomeBat) //"D:\" + cNomeArq
CONOUT("EXPORSA2-" + DTOC(DATE()) + "-" + TIME() + "- Inicio da criação do arquivo csv.") 
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Cria o arquivo texto para gravação das informação da nota fiscal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	FERASE(cDestinoBat)
	
	nHdl := FCREATE(cDestinoDef)
	nHdlb := FCREATE(cDestinoBat)
	
	If nHdl == -1 
		cArquivo := cDestinoDef
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Se não conseguiu criar no arquivo definido no parâmetro, tenta no C:\³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nHdl := FCREATE(cArquivo)
		If nHdl == -1 
	   		//ShowHelpDlg("Atenção", {"Ocorreu o erro " + ALLTRIM(STR(FERROR())) + " durante a geração do arquivo " + cArquivo}, 5, {"Favor tentar gerar o arquivo novamente de modo manual sobre a nota fiscal."}, 5)
	   		Return
		EndIf
	EndIf

  if(LEN( aLin ) > 0 )
   cCab := aCab[1] +','+ aCab[2] +','+ aCab[3]
   FWRITE(nHdl, cCab + hEnter)
   
   cComandoApi := '$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"' + hEnter
   cComandoApi += '$headers.Add("Content-Type", "text/csv; charset=UTF-8")' + hEnter
   cComandoApi += '$headers.Add("filename", "' + cNomeArq + '")' + hEnter
   cComandoApi += '$headers.Add("x-api-key", "qUKVQ2iASf6LiUA6cpumG8B9o6r0XwYL455mDxsw")' + hEnter
   cComandoApi += "$uri = 'https://test.api.easycodeit.com/file-receiver/v1/upload'" + hEnter
   cComandoApi += "$FilePath = '" + cDirApi + cNomeArq + "'" + hEnter 
   cComandoApi += "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12" + hEnter 
   cComandoApi += '$response = Invoke-RestMethod -uri $uri -Method Put -Headers $headers -Infile $FilePath' + hEnter
   cComandoApi += '$response | ConvertTo-Json'
   
   FWRITE(nHdlb, cComandoApi + hEnter)

   //FWRITE(nHdlb, 'curl -X PUT "https://test.api.easycodeit.com/file-receiver/v1/upload" -H "Content-Type:text/csv; charset=UTF-8" -H "filename:' + cNomeArq + '" -H "x-api-key:qUKVQ2iASf6LiUA6cpumG8B9o6r0XwYL455mDxsw" --data-binary @'+ cNomeArq)
  EndIF

  FOR L:= 1 TO LEN( aLin )
   
   cDados :=  ""
   cDados1 :=   aLin[L][1] + ',' +     aLin[L][2]          + ',' +   aLin[L][3]
     
   cDados := cDados1 
   FWRITE(nHdl, cDados + hEnter)

  Next
  
  FClose(nHdl)
  FClose(nHdlb)
  CONOUT("EXPORSA2-" + DTOC(DATE()) + "-" + TIME() + "- Fim da criação do arquivo csv." + cDestinoDef) 
	/*
	If ! WaitRunSrv(cDirApi+cNomeArq , .T. , "c:\WINDOWS\system32\" )
    	ConOut("WaitRunSRV - Erro na execução do Bat: " + Time())
	Else
    	ConOut("WaitRunSRV - Execução do Bat com Sucesso. " + Time())
	EndIf
	*/
Return cCSV
