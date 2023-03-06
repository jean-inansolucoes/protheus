#INCLUDE "totvs.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH" /*
#Include "aarray.ch"
#Include "json.ch"*/
/*
Programa: EXPORSB1 
Autor: IGOR BENTES
Data: 09/02/2022
Desc.: PERMITE EXPORTA CADASTRO DE PRODUTO NO FORMATO CSV 

*/

User Function  EXPORSB1(cDiretorio, cProdDe1, cProdAte1, cGruDe1, cGruAte1, cOPData1, cTPDe, cTPAte )

   
Local   cQuery 
Local   cRetorno     
Local   cAlias 		:= getNextAlias()
Local   aArea 		:= GetArea()  
Private cArquivo    := 'EXPORSB1'
  		nTotalReg 	:= 0
Private aVetProd 	:= {}
	    cRet 		:= ""
	    aCab		:= {}
     	aLin 		:= {}

 

 aCab1 := { "CODIGO", "NOME", "CATEGORIA", "MARCA", "PESO_CAIXA", "GRAMATURA", "UNIDADE_CX", "PESO_VARIAVEL" }
 
/*
cQuery := "SELECT SB1.B1_COD AS CODIGO, "
cQuery += " SB1.B1_DESC AS NOME, "
cQuery += " SBM.BM_DESC AS CATEGORIA, "
cQuery += "  SB1.B1_FABRIC as MARCA, "
cQuery += " 0 AS PESO_CAIXA_KG, " // SOMENTE INTEIROS
cQuery += " 0 AS GRAMATURA, " // INT
cQuery += " 0 AS UNIDADE_CX, " // INT
cQuery += " 1 AS PESO_VARIAVEL " // BOOL AJUSTAR
Query += " FROM "+ RetSqlName("SB1") +" SB1 "
cQuery += " INNER JOIN " + RetSqlName("SBM") + " SBM ON SBM.BM_GRUPO=SB1.B1_GRUPO AND SBM.D_E_L_E_T_<>'*' "
cQuery += " WHERE  "
cQuery += " SB1.D_E_L_E_T_<>'*' AND "
//cQuery += " SB1.B1_FILIAL ='"+ cFilial1 +"' AND "
//cQuery += " SB1.B1_TIPO IN ('PA', 'MC') AND "
cQuery += " SB1.B1_COD BETWEEN '"+ cProdDe1 +"' AND '"+ cProdAte1 +"' AND "
cQuery += " SB1.B1_GRUPO BETWEEN '"+ cGruDe1 +"' AND '"+ cGruAte1 +"' " 
*/
cQuery := "SELECT SB1.B1_COD AS CODIGO, "+chr(10)+chr(13)
cQuery += "SB1.B1_DESC AS NOME, 		"+chr(10)+chr(13)
cQuery += "SBM.BM_DESC AS CATEGORIA, 	"+chr(10)+chr(13)
cQuery += " CASE 						"+chr(10)+chr(13)
cQuery += " WHEN SB1.B1_DESC LIKE '%TRES BARRAS%'"+chr(10)+chr(13)
cQuery += "	THEN 'TRES BARRAS'"+chr(10)+chr(13)
cQuery += " WHEN SB1.B1_DESC LIKE '%TRELAC%'"+chr(10)+chr(13)
cQuery += "	THEN 'TRELAC'"+chr(10)+chr(13)
cQuery += " WHEN SB1.B1_DESC LIKE '%T. BARRAS%'"+chr(10)+chr(13)
cQuery += "	THEN 'TRES BARRAS'"+chr(10)+chr(13)
cQuery += " WHEN SB1.B1_DESC LIKE '%SIL%'"+chr(10)+chr(13)
cQuery += " THEN 'SILVESTRE'"+chr(10)+chr(13)
cQuery += " WHEN SB1.B1_DESC LIKE '%VIANA%'"+chr(10)+chr(13)
cQuery += " THEN 'VIANA DO CASTELO'"+chr(10)+chr(13)
cQuery += "  ELSE ''"+chr(10)+chr(13)
cQuery += " END MARCA,"+chr(10)+chr(13)
cQuery += " ROUND( IIF( TRIM(SB1.B1_UM) = 'KG', SB1.B1_CONV*1000, (SB1.B1_PESO * SB1.B1_QE)*1000),0) AS PESO_CAIXA,"+chr(10)+chr(13)
cQuery += " ROUND( IIF( TRIM(SB1.B1_UM) = 'KG', ( IIF( SB1.B1_QE > 0, (SB1.B1_CONV / SB1.B1_QE) * 1000, 1) ), B1_PESO*1000) ,0) GRAMATURA, "+chr(10)+chr(13)
cQuery += " SB1.B1_QE AS UNIDADE_CX,"+chr(10)+chr(13)
cQuery += " CASE"+chr(10)+chr(13)
cQuery += " WHEN TRIM(SB1.B1_UM) = 'KG'"+chr(10)+chr(13)
cQuery += " THEN 1 "+chr(10)+chr(13)
cQuery += " WHEN TRIM(SB1.B1_UM) = 'UN'"+chr(10)+chr(13)
cQuery += " THEN 0 "+chr(10)+chr(13)
cQuery += " END PESO_VARIAVEL "
cQuery += " FROM "+ RetSqlName("SB1") +" SB1 "+chr(10)+chr(13)
cQuery += " INNER JOIN "+ RetSqlName("SBM") +" SBM ON SBM.BM_GRUPO=SB1.B1_GRUPO AND SBM.D_E_L_E_T_<>'*' "+chr(10)+chr(13)
cQuery += " INNER JOIN "+ RetSqlName("SB2") +" SB2 ON SB2.B2_COD = SB1.B1_COD AND SB2.B2_FILIAL = '01LAT04'"+chr(10)+chr(13)
cQuery += " WHERE  "+chr(10)+chr(13)
cQuery += " SB1.D_E_L_E_T_<>'*' AND B1_TIPO = 'PA' AND SBM.BM_GRUPO <> '0010' AND B2_QATU > 0 AND "+chr(10)+chr(13)
cQuery += " SB1.B1_COD BETWEEN '"+ cProdDe1 +"' AND '"+ cProdAte1 +"' AND "+chr(10)+chr(13)
cQuery += " SB1.B1_GRUPO BETWEEN '"+ cGruDe1 +"' AND '"+ cGruAte1 +"' "+chr(10)+chr(13) 


 
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

		       cCODIGO			       := ALLTRIM( cAlias->CODIGO )
		       cNOME		           := ALLTRIM( cAlias->NOME )
		       cCATEGORIA	         := ALLTRIM( cAlias->CATEGORIA )
		       cMARCA		           := ALLTRIM( cAlias->MARCA )
			     nPESO_CAIXA_KG    	 := cAlias->PESO_CAIXA_KG
			     nGRAMATURA          := cAlias->GRAMATURA
		       nUNIDADE_CX         := cAlias->UNIDADE_CX
		       lPESO_VARIAVEL			 := cAlias->PESO_VARIAVEL
		      	       
		       
		       
		
				aAdd(aVetProd, {cCODIGO, cNOME, cCATEGORIA, cMARCA, nPESO_CAIXA_KG, nGRAMATURA, nUNIDADE_CX, lPESO_VARIAVEL })

	         nNex := nNex +1
	       cAlias->(dbSkip())
	
	    Enddo	
		
	  cAlias->( DbCloseArea() ) 
	
      RestArea(aArea)

     
     
     U_CSV(cDiretorio,aCab1, aVetProd)
     nTotal  := Len(aVetProd)
  
     
    

MsgStop("PROCESSO FINALIZADO! TOTAL DE REG. GERADOS="+ str(nTotalReg) +" ARQUIVO GERADO :"+cArquivo+".CSV ")
    	


Return 



User function CSV(cDiretorio, aCab, aDados)

Local cCSV    := ""  
Local aLin    := aDados  
Local cDados  := "" 
Local L
nHdl   := 0
hEnter		:= CHR(13) + CHR(10)
cArquivo    := 'EXPORSB1'
cNomeArq := "produtos.csv"
cDestinoDef	:= alltrim(cDiretorio)+alltrim(cNomeArq) //"D:\" + cNomeArq

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
	   		ShowHelpDlg("Atenção", {"Ocorreu o erro " + ALLTRIM(STR(FERROR())) + " durante a geração do arquivo " + cArquivo}, 5, {"Favor tentar gerar o arquivo novamente de modo manual sobre a nota fiscal."}, 5)
	   		Return
		EndIf
	EndIf

  if(LEN( aLin ) > 0 )
    cCab := +aCab[1] +',"'+ aCab[2] +'","'+ aCab[3] +'","'+ aCab[4] +'","'+ aCab[5] +'","'+ aCab[6] +'","'+ aCab[7] +'","'+ aCab[8] +'"'
   FWRITE(nHdl, cCab + hEnter)
  EndIF


  FOR L:= 1 TO LEN( aLin )
   //aCab1 := { "CODIGO",           "NOME",              "CATEGORIA",          "MARCA",                     "PESO_CAIXA_KG",                            "GRAMATURA",                              "UNIDADE_CX",                         "PESO_VARIAVEL" }
   cDados :=    aLin[L][1] + ',"' + aLin[L][2] + '","' + aLin[L][3] + '","' + aLin[L][4]  + '",' +  ALLTRIM( str( aLin[L][5] ) ) + "," +  ALLTRIM( STR( aLin[L][6] ) ) + "," + ALLTRIM ( STR( aLin[L][7] )) + "," +  ALLTRIM( STR( aLin[L][8] ) )  
   FWRITE(nHdl, cDados + hEnter)

  Next
  
  FClose(nHdl)
 
Return cCSV

