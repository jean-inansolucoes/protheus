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
user function EXPORSA1(cDiretorio, cLacDe1, cLacAte1, cOPData1)

Local   cQuery 
Local   cRetorno     
Local   cAlias 		:= getNextAlias()
Local   aArea 		:= GetArea()  

Default cDiretorio	:= "I:\Drives compartilhados\SOUK\BASE\" // caso de execução seja via SMARTCLIENT
Default cLacDe1		:= ''
Default cLacAte1	:= 'ZZZZZZZZZ'
Default cOPData1	:= ''
private lExecjob	:= isBlind() // caso de execução seja via SCHEDULE
Private cArquivo    := 'EXPORSA1'
  		nTotalReg 	:= 0
Private aVetProd 	:= {}
	    cRet 		:= ""
	    aCab		:= {}
     	aLin 		:= {}
     	cLinha 		:= ""
     	cInsert     := ""

if lExecjob // caso de execução seja via SCHEDULE
	cDiretorio	:= "/SOUK/"
EndIf

CONOUT("EXPORSA1-" + DTOC(DATE()) + "-" + TIME() + "-Inicio do processo.")     	

If Type("cEmpAnt")=="U"
		WFPrepEnv("01","01LAT01")
EndIf

  aCab   := { "CNPJ", "INSCRICAO_ESTADUAL", "CODIGO_INTERNO", "NOME_FANTASIA", "ATIVO", "CODIGO_TIPOLOGIA", "TIPOLOGIA", "SALDO", "PEDIDO_MINIMO", "ENDERECO_DE_ENTREGA", "CEP", "UF", "MUNICIPIO",  "FAIXA_1", "FAIXA_2", "FAIXA_3", "FAIXA_4", "SIMPLES" }
    

 // QUERY PARA BUSCAR OS CAMPOS NO SISTEMA PROTHEUS 
  cQuery :=  "SELECT TRIM(SA1.A1_CGC) AS CNPJ, " +chr(10)
  cQuery += "     TRIM(REPLACE(SA1.A1_INSCR,'.','')) AS INSCRICAO_ESTADUAL, "+chr(10)
	cQuery += "   TRIM(SA1.A1_COD)+TRIM(SA1.A1_LOJA) AS CODIGO_INTERNO, "+chr(10)
	cQuery += "   TRIM(SA1.A1_NREDUZ) AS NOME_FANTASIA, "+chr(10)
	cQuery += "   IIF(SA1.A1_MSBLQL = '1', '0', '1') AS ATIVO, "+chr(10)
	cQuery += "   TRIM(SA1.A1_X_CANAL) AS CODIGO_TIPOLOGIA, "+chr(10)
	cQuery += "   TRIM(ZAG.ZAG_DESCR) AS TIPOLOGIA, "+chr(10)
	cQuery += "   CAST(TRIM(REPLACE(CAST(IIF((A1_LC - (A1_SALDUP + A1_SALPEDL)) > 0, A1_LC - (A1_SALDUP + A1_SALPEDL), 0) AS NUMERIC(10,2)),'.','')) AS INT) AS SALDO,"+chr(10)
	cQuery += "   40000 AS PEDIDO_MINIMO, "+chr(10)
	cQuery += "   TRIM(SA1.A1_END) AS ENDERECO_DE_ENTREGA, "+chr(10)
	cQuery += "   SA1.A1_CEP AS CEP, "+chr(10)
	cQuery += "   SA1.A1_EST AS UF, "+chr(10)
	cQuery += "   TRIM(SA1.A1_MUN) AS MUNICIPIO, "+chr(10)
	cQuery += "   1 AS FAIXA_1, "+chr(10)
	cQuery += "   1 AS FAIXA_2, "+chr(10)
	cQuery += "   1 AS FAIXA_3, "+chr(10)
	cQuery += "   1 AS FAIXA_4, "+chr(10)
	cQuery += "   SA1.A1_SIMPNAC AS SIMPLES"+chr(10)
  	cQuery += " FROM " + RetSqlName("SA1") + " AS SA1 "+chr(10)
  	cQuery += "INNER JOIN " + RetSqlName("ZAG") + " ZAG ON ZAG.ZAG_CODIGO = SA1.A1_X_CANAL" +chr(10)
    cQuery += "WHERE SA1.D_E_L_E_T_<>'*' AND  A1_EST = 'SP' AND  A1_PESSOA = 'J' AND A1_UNIDVEN = '000001' AND" +chr(10)
  	cQuery += " SA1.A1_COD BETWEEN '"+ cLacDe1 +"' AND '"+ cLacAte1 +"'" +chr(10)
	

 
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
                        	       
			   cCNPJ                := ALLTRIM( cAlias->CNPJ )
		       cINSCRICAO_ESTADUAL	:= ALLTRIM( STRTRAN(cAlias->INSCRICAO_ESTADUAL,"-","") )
		       cCODIGO_INTERNO      := ALLTRIM( cAlias->CODIGO_INTERNO )
		       cNOME_FANTASIA		:= ALLTRIM( cAlias->NOME_FANTASIA )
		       lATIVO	       	    := ALLTRIM( cAlias->ATIVO )
		       nCODIGO_TIPOLOGIA    := cAlias->CODIGO_TIPOLOGIA
		       cTIPOLOGIA        	:= ALLTRIM( cAlias->TIPOLOGIA )
		       nSALDO        	    := cAlias->SALDO
		       nPEDIDO_MINIMO       := cAlias->PEDIDO_MINIMO
		       cENDERECO_DE_ENTREGA := ALLTRIM( cAlias->ENDERECO_DE_ENTREGA )
		       cCEP           	    := ALLTRIM( cAlias->CEP )
		       cUF        	        := ALLTRIM( cAlias->UF )
		       cMUNICIPIO        	:= ALLTRIM( cAlias->MUNICIPIO )
		       nFAIXA1        	    := cAlias->FAIXA_1
		       nFAIXA2		        := cAlias->FAIXA_2
		       nFAIXA3		        := cAlias->FAIXA_3
           	   nFAIXA4              := cAlias->FAIXA_4
			   nSIMPLES             := cAlias->SIMPLES
			   IF At ("ISEN",cINSCRICAO_ESTADUAL) > 0
					cINSCRICAO_ESTADUAL := ""
			   EndIf
          
          aAdd(aVetProd, {cCNPJ, cINSCRICAO_ESTADUAL,   cCODIGO_INTERNO,  cNOME_FANTASIA, lATIVO,  nCODIGO_TIPOLOGIA,   cTIPOLOGIA, nSALDO, nPEDIDO_MINIMO, cENDERECO_DE_ENTREGA, cCEP, cUF, cMUNICIPIO,  nFAIXA1, nFAIXA2, nFAIXA3, nFAIXA4, nSIMPLES })
               
	         nNex := nNex +1
	       cAlias->(dbSkip())
	
	    Enddo	
		
	  cAlias->( DbCloseArea() ) 
	
      RestArea(aArea)

     U_CSV_SA1(cDiretorio, aCab, aVetProd)
     nTotal  := Len(aVetProd)
      
CONOUT("EXPORSA1-" + DTOC(DATE()) + "-" + TIME() + "- FIM do processo.")     	   

//MsgStop("PROCESSO FINALIZADO! TOTAL DE REG. GERADOS="+ str(nTotalReg) +" ARQUIVO GERADO :"+cArquivo+".CSV ")
    	


Return


User function CSV_SA1(cDiretorio, aCab, aDados)

Local cCSV    := ""  
Local aLin    := aDados  
Local cDados  := "" 
Local L
nHdl   := 0
hEnter		:= CHR(13) + CHR(10)
cArquivo    := 'EXPORSA1'
cNomeArq := "clientes.csv"
cDestinoDef	:= alltrim(cDiretorio)+alltrim(cNomeArq) //"D:\" + cNomeArq
CONOUT("EXPORSA1-" + DTOC(DATE()) + "-" + TIME() + "- Inicio da criação do arquivo csv.") 
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Cria o arquivo texto para gravação das informação da nota fiscal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nHdl := FCREATE(cDestinoDef)
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
    cCab := '"'+ aCab[1] +'","'+ aCab[2] +'","'+ aCab[3] +'","'+ aCab[4] +'","'+ aCab[5] +'","'+ aCab[6] +'","'+ aCab[7] +'","'+ aCab[8] +'","'+ aCab[9] +'","'+ aCab[10] +'","'+ aCab[11] +'","'+ aCab[12] +'","'+ aCab[13] +'","'+ aCab[14] +'","'+ aCab[15] +'","'+ aCab[16] +'","'+ aCab[17] +'","'+ aCab[18] + '"'
   FWRITE(nHdl, cCab + hEnter)
  EndIF


  FOR L:= 1 TO LEN( aLin )
   
   cDados :=  ""
   cDados1 :=   aLin[L][1] + ',' +     aLin[L][2]          + ',' +   aLin[L][3]    + ',"' +   aLin[L][4]     + '",'
   cDados2 :=   aLin[L][5]   + ',' +  aLin[L][6] + ',"'  +   aLin[L][7]    + '",' 
   cDados3 :=  ALLTRIM( STR( aLin[L][8] ) )  + ',' +   ALLTRIM( str( aLin[L][9]) ) + ',"'  +    aLin[L][10] + '",' 
   cDados4 :=  aLin[L][11]     + ',"'  +  aLin[L][12]     + '","'  +    aLin[L][13]     + '",'  +    ALLTRIM( str(  aLin[L][14] ))    + ','  
   cDados5 :=  ALLTRIM( str( aLin[L][15]  ))    + ','  +  ALLTRIM( str( aLin[L][16] ))    + ','  +  ALLTRIM( str( aLin[L][17] ))  + ','  +  aLin[L][18]
  
   cDados := cDados1 + cDados2 + cDados3 + cDados4 + cDados5
   FWRITE(nHdl, cDados + hEnter)

  Next
  
  FClose(nHdl)
	CONOUT("EXPORSA1-" + DTOC(DATE()) + "-" + TIME() + "- Fim da criação do arquivo csv." + cDestinoDef) 
Return cCSV
