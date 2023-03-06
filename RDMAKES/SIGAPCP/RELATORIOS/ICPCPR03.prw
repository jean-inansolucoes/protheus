#include "protheus.ch"
#include "parmtype.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function ICPCPR03
    Etiqueta modelo GS1 para ZEBRA
	@type  Function
	@author ICMAIS
	@since 23/09/2021
	@version 1.0
	@return nil, nil, nil
/*/
User Function ICPCPR03(aDados)

	Local sConteudo
	Local aArea			:= GetArea()

    Private cSIF	    := AllTrim(GetMv("MV_X_SIF"))
	Private cPortaZebra	:= AllTrim(GetMv("MV_PORTZEBR"))
	Private cAliasSB1   := GetNextAlias( )
	Private cPerg	    := "CRPCP00001"
	Private nX1PrdQt    := 1
	Private cX1Porta    := cPortaZebra	//"LPT2" 
	Private lX1Driv     := .F.
	Private lX1StPrn    := .F.
	Private cModelPrt	:= "ZEBRA"

	//msginfo('ICPCPR03')
	//MsgInfo("Dadoso =["+ cModelPrt+"|Porta="+cX1Porta+"]"," Portas")//

	/*
	MSCBPRINTER( cModelPrt, cPorta, nDensidade, nTamanho, lSrv, nPorta, cServer, cEnv, nMemoria, cFila, lDrvWin, cPathSpool)
	Par�metros	         Descri��o
	====================================================================================================================================
	1.) [cModelPrt]      String com o modelo de impressora:
	+---------------------------------------------------------------------------------------------------------------------+
	|Fabricante | Impressoras                                                                                             |
	+---------------------------------------------------------------------------------------------------------------------+
	| Datamax   | ALLEGRO, ALLEGRO 2, PRODIGY, DMX, DESTINY, URANO, DATAMAX, OS 214, OS 314, PRESTIGE, ARGOX              |
	| Eltron    | ELTRON, TLP 2722, TLP 2742, TLP 2844, TLP 3742, C4-8                                                    |
	| Intermec  | INTERMEC, 3400-8, 3400-16, 3600-8, 4440-16, 7421C-8                                                     |
	| Zebra     | S300, S400, S500-6, S500-8, Z105S-6, Z105S-8, Z160S-6, Z160S-8, Z140XI, S600, Z4M, Z90XI, Z170XI, ZEBRA |
	+---------------------------------------------------------------------------------------------------------------------+

	2.) [cPorta]         String com a porta
	3.) [nDensidade]     N�mero com a densidade referente a quantidade de pixel por  mm. Este par�metro s� deve ser informado quando o par�metro cModelPrt n�o for informado, pois cModelPrt o atualizar� automaticamente. A utiliza��o deste par�metro dever� ser usado quando n�o souber o modelo da impressora, a aplica��o entendera que se trata de uma impressora Zebra.  O tamanho da etiqueta ser� necess�rio quando a mesma n�o for continua.
	4.) [nTamanho]   	 Tamanho da etiqueta em Mil�metros. Lembrando que este tamanho s� deve ser passado se a etiqueta for continua.
	5.) [lSrv]           Se .t. imprime no server,.f. no client. O seu valor padr�o � .f.
	6.) [nPorta]       	 N�mero da porta de outro server
	7.) [cServer]    	 endere�o IP de outro server
	8.) [cEnv]    	     environment do outro server
	9.) [nMemoria]   	 N�mero com bloco de mem�ria da impressora t�rmica. Caso seja enviada muita informa��o para a impressora, a fim que esta venha imprimir (sobrecarregando a mem�ria), pode ocorrer perda de dados. Por outro lado, se for informado blocos muito pequenos de mem�ria, implicar� na diminui��o da performance da impressora. Sendo assim o programador dever� fazer uma avalia��o para ver o que melhor se adequa a sua situa��o.
	10.) [cFila]	         Diret�rio onde ser� gravada as filas
	11.) [lDrvWin]	     Indica se ser� utilizando os drivers do windows para impress�o
	12.) [cPathSpool]	 Caminho do diret�rio onde ser�o geradas as filas de impress�o
	*/  

	//Impressao etiqueta
	CursorArrow()
	SysRefresh()

	MSCBPRINTER( cModelPrt, cX1Porta,,,.F.,,,,,,lX1Driv )
	MSCBCHKSTATUS( lX1StPrn )
	

	EMPZEB( aDados )

	RestArea( aArea )

Return( sConteudo )









Static Function EMPZEB(  aDados )

	Local nCol		:= 10
	Local NY		:= 0
	Local nQtdImp	:= 1
	Local sConteudo

	/*
	Estrutura aDados
	aDados[1] Codigo
	aDados[2] Descricao
	aDados[3] GTIN
	aDados[4] Quantidade
	aDados[5] Lote
	aDados[6] Peso Liquido
	aDados[7] Data Fabric
	aDados[8] Data Venc
	aDados[9] Peso Bruto
	aDados[10] Tara Embalagem
	aDados[11] Tara Caixa
	aDados[12] Tara Total
	aDados[13] Codigo Etiqueta
	aDados[14] Codigo caixa
	*/


	For NY := 1 To nQtdImp
		sleep(250)
		MSCBBEGIN( 1, 4 )
		
		 cTemperatura := POSICIONE("SB1",1,XFILIAL("SB1")+aDados[1],"SB1->B1_X_TEMPE")   
		 cUND         := POSICIONE("SB1",1,XFILIAL("SB1")+aDados[1],"SB1->B1_UM") 
		 cRegistro    := GetMv("MV_X_RGPRO")

		MSCBSAY(nCol + 50 , 005, AllTrim( aDados[1] ) +" | "+ AllTrim( aDados[2] ), "R" , "B", "025,020" )
		//1� linha
		MSCBBOX(48,005,59,042,1) //MSCBBOX(48,100,59,140,1)
		MSCBSAY(  nCol + 45, 007, "GTIN", "R" , "D", "010,010" )
		// regra para calular digito verificado ean14
		IF(cUND == "KG")
		cEAN14 := "9"+ SUBSTR(alltrim(aDados[3]), 1, 12) 
		//cEAN14 := cEAN14 +""+ U_EAN14(cEAN14)
		ELSE
		cEAN14 := "1"+ SUBSTR(alltrim(aDados[3]), 1, 12) 
		
		ENDIF
		
		cEAN14 := cEAN14 +""+ U_EAN14(cEAN14)

		MSCBSAY(    nCol + 40, 009, cEAN14, "R" , "B", "020,015" )
		
		MSCBBOX(48,042,59,032,1)// MSCBBOX(48,90,59,100,1)
		MSCBSAY(    nCol + 45, 044, "Pcs", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 40, 044, AllTrim(TRANSFORM(aDados[4], PesqPict("SZB","ZB_QTD"))), "R" , "B", "020,015" )
		MSCBBOX(48,42,59,76,1) //MSCBBOX(48,60,59,90,1)
		MSCBSAY(    nCol + 45, 55, "Lote", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 40, 55, aDados[5], "R" , "B", "020,015" )

		//2� linha
		MSCBBOX(38,005,48,027,1)
		MSCBSAY(    nCol + 35, 007, "Peso Liquido", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 30, 008, AllTrim(TRANSFORM(aDados[6], PesqPict("SZB","ZB_PESOLIQ"))), "R" , "B", "020,015" )
		MSCBSAY(    nCol + 30, 023, "kg", "R" , "D", "010,010" )
		MSCBBOX(38,027,48,52,1)
		MSCBSAY(    nCol + 35, 029, "Data Producao", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 30, 029, DTOC(aDados[7]), "R" , "B", "020,015" )
		MSCBBOX(38,027,48,76,1)
		MSCBSAY(    nCol + 35, 53, "Vencimento", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 30, 53, DTOC(aDados[8]), "R" , "B", "020,015" )

		//3� linha
		MSCBBOX(28,005,38,027,1)
		MSCBSAY(    nCol + 25, 007, "Peso Bruto", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 20, 008, AllTrim(TRANSFORM(aDados[9], PesqPict("SZB","ZB_PESOBAL"))), "R" , "B", "020,015" )
		MSCBSAY(    nCol + 20, 023, "kg", "R" , "D", "010,010" )
		MSCBBOX(28,027,38,52,1)
		MSCBSAY(    nCol + 25, 029, "Tara Embalagem", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 20, 035, AllTrim(TRANSFORM(aDados[10], PesqPict("SZB","ZB_TARAEMB"))), "R" , "B", "020,015" )
        MSCBBOX(28,027,48,76,1)
	   	MSCBSAY(    nCol + 25, 53, "Reg. SIF", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 20, 53,  cSIF, "R" , "B", "020,015" )



		//4� linha
		MSCBBOX(08,005,27.5,027,1)
		MSCBSAY(    nCol + 14, 007, "CONSERVACAO:", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 10, 007, "AMBIENTE", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 02, 007, Alltrim(cTemperatura), "R" , "D", "010,010" ) // ajusta para campo SB1 cTemperatura  "0.0 C A 22.00 C"
		MSCBBOX(20,027,27.5,052,1)
		MSCBSAY(    nCol + 14, 029, "Tara caixa", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 10, 035, AllTrim(TRANSFORM(aDados[11], PesqPict("SZB","ZB_TARACX"))), "R" , "B", "020,015" )
		MSCBBOX(08,027,20,052,1)
		MSCBSAY(    nCol + 06, 029, "Tara", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 02, 029, "Total", "R" , "D", "010,010" )
		MSCBSAY(    nCol + 02, 038, AllTrim(TRANSFORM(aDados[12], PesqPict("SZB","ZB_TARACX"))), "R" , "B", "020,015" )

		//Codigo barras unidade logistica

		IF EMPTY(aDados[14])
          // MSCBSAYBAR( 48, 80,   "00"+AllTrim(aDados[13])    ,"R" ,"MB07",08,.F.,.F.,.F.,,3,2,.T.,.F.) //MSCBSAYBAR( nCol , 45,   "00"+AllTrim(aDados[13])    ,"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
          //    MSCBSAY( 45, 84, "(00)"+AllTrim(aDados[13]), "R" , "D", "010,010" )
		  Else
		  // codigo da caixa 
                MSCBSAYBAR( 48, 80,  AllTrim(aDados[14])    ,"R" ,"MB07",08,.F.,.F.,.F.,,3,2,.T.,.F.) //MSCBSAYBAR( nCol , 45,   "00"+AllTrim(aDados[13])    ,"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
                MSCBSAY( 45, 84, AllTrim(aDados[14]), "R" , "D", "010,010" )
		EndIf

         cDATA1  := SUBSTR(DTOS(aDados[8]), 3)  	
         cDATA2  := SUBSTR(DTOS(aDados[7]), 3)
		//Codigo barras  nCol +1 horizintal
		  MSCBSAYBAR( 29 , 82, "15"+cDATA1+"11"+cDATA2+"10"+AllTrim(aDados[5])+"7030"+AllTrim(cRegistro),"R" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
            MSCBSAY(  26, 78, "(15)"+cDATA1+"(11)"+cDATA2+"(10)"+AllTrim(aDados[5])+"(7030)"+AllTrim(cRegistro), "R" , "D", "010,010" )
			
			//vertical
			///MSCBSAYBAR( 005 , 135, "15"+cDATA1+"11"+cDATA2+"10"+AllTrim(aDados[5])+"7030"+AllTrim(cRegistro),"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
		    ///  MSCBSAY(  005, 144, "(15)"+cDATA1+"(11)"+cDATA2+"(10)"+AllTrim(aDados[5])+"(7030)"+AllTrim(cRegistro), "N" , "D", "010,010" )
		
		cPLiquido := StrZero(Val( StrTran( AllTrim(TRANSFORM(aDados[6], PesqPict("SZB","ZB_PESOLIQ"))), ",", "")) + 0, 6 )  /// StrTran( AllTrim(aDados[6]), ",", "")
		cPBruto   := StrZero(Val(StrTran( AllTrim(TRANSFORM(aDados[9], PesqPict("SZB","ZB_PESOBAL"))), ",", "") ) + 0, 6 )
		nQTD_EMB :=  StrZero(  Val( AllTrim( str(aDados[4]) ) ) + 0, 2)
		//Codigo GS1               //AllTrim(aDados[3])/aDados[3]/aDados[14]/aDados[14] //"+ AllTrim(aDados[14]) +"(       2,5
		MSCBSAYBAR( 008 , 65, "01"+ cEAN14 +"3103"+ cPLiquido +"3303"+ cPBruto +"30"+ nQTD_EMB,"R" ,"MB07",11,.F.,.F.,.F.,,2,2,.T.,.F.)//MSCBSAYBAR( 008 , 54, "01"+ cEAN14 +"3103"+ cPLiquido +"3303"+ cPBruto +"30"+ nQTD_EMB,"R" ,"MB07",11,.F.,.F.,.F.,,3,2,.T.,.F.)
        
		MSCBSAY(  005,  60, "(01)"+ cEAN14 +"(3103)"+ cPLiquido +"(3303)"+ cPBruto +"(30)"+ nQTD_EMB, "R" , "D", "010,010" )
		
		//teste inverter
		//MSCBSAYBAR( nCol + 15 , 80, "01"+ cEAN14 +"3103"+ cPLiquido +"3303"+ cPBruto +"30"+ AllTrim(str(aDados[4])),"R" ,"MB07",08,.F.,.F.,.F.,,4,4,.T.,.F.)
         
          

      
		sConteudo := MSCBEND( )
		MSCBClosePrinter( )

		sConteudo := ""
	Next NY

Return( sConteudo )





/*
Fun��o		U_EAN14()
Autor		ERPC
Descri��o	Calcula Digito verificador para EAN14 
Par�metro	String com 13 digitos 
Retorno		String contendo d�gito verificador
*/
/*User function EAN14(cCod13)
Local nOdd := 0
Local nEven := 0 
Local nI
Local nDig  
Local nMul := 10 
For nI := 1 to 13
	If (nI%2) == 0
		nEven += val(substr(cCod13,nI,1))
	Else
		nOdd += val(substr(cCod13,nI,1))
	Endif
Next
nDig := nEven + (nOdd*3)
While nMul<nDig
	nMul += 10 
Enddo
Return strzero(nMul-nDig,1)
*/





