#include "protheus.ch"
#include "parmtype.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function ICPCPR01
    Etiqueta modelo GS1
	@type  Function
	@author ICMAIS
	@since 12/09/2020
	@version 1.0
	@return nil, nil, nil
/*/
User Function ICPCPR01(aDados)

	Local sConteudo
	Local aArea			:= GetArea()

	Private cAliasSB1   := GetNextAlias( )
	Private cPerg	    := "CRPCP00001"
	Private nX1PrdQt    := 1
	Private cX1Porta    := "LPT2" //""
	Private lX1Driv     := .F.
	Private lX1StPrn    := .F.
	Private cModelPrt	:= "OS 214"
   
  // MsgInfo("Dadoso =["+ cModelPrt+"|Porta="+cX1Porta+"]"," Portas")//

	//msginfo('ICPCPR01')

	/*
	MSCBPRINTER( cModelPrt, cPorta, nDensidade, nTamanho, lSrv, nPorta, cServer, cEnv, nMemoria, cFila, lDrvWin, cPathSpool)
	Parâmetros	         Descrição
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
	3.) [nDensidade]     Número com a densidade referente a quantidade de pixel por  mm. Este parâmetro só deve ser informado quando o parâmetro cModelPrt não for informado, pois cModelPrt o atualizará automaticamente. A utilização deste parâmetro deverá ser usado quando não souber o modelo da impressora, a aplicação entendera que se trata de uma impressora Zebra.  O tamanho da etiqueta será necessário quando a mesma não for continua.
	4.) [nTamanho]   	 Tamanho da etiqueta em Milímetros. Lembrando que este tamanho só deve ser passado se a etiqueta for continua.
	5.) [lSrv]           Se .t. imprime no server,.f. no client. O seu valor padrão é .f.
	6.) [nPorta]       	 Número da porta de outro server
	7.) [cServer]    	 endereço IP de outro server
	8.) [cEnv]    	     environment do outro server
	9.) [nMemoria]   	 Número com bloco de memória da impressora térmica. Caso seja enviada muita informação para a impressora, a fim que esta venha imprimir (sobrecarregando a memória), pode ocorrer perda de dados. Por outro lado, se for informado blocos muito pequenos de memória, implicará na diminuição da performance da impressora. Sendo assim o programador deverá fazer uma avaliação para ver o que melhor se adequa a sua situação.
	10.) [cFila]	         Diretório onde será gravada as filas
	11.) [lDrvWin]	     Indica se será utilizando os drivers do windows para impressão
	12.) [cPathSpool]	 Caminho do diretório onde serão geradas as filas de impressão
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
	*/


	For NY := 1 To nQtdImp
		sleep(250)
		MSCBBEGIN( 1, 4 )
		
		 cTemperatura := POSICIONE("SB1",1,XFILIAL("SB1")+aDados[1],"SB1->B1_X_TEMPE")   
		 cUND         := POSICIONE("SB1",1,XFILIAL("SB1")+aDados[1],"SB1->B1_UM") 
		 cRegistro    := GetMv("MV_X_RGPRO")

		MSCBSAY(    nCol + 50, 140, AllTrim( aDados[1] ) +" | "+ AllTrim( aDados[2] ), "R" , "4", "1,1" )
		//1º linha
		MSCBBOX(48,100,59,140,1)
		MSCBSAY(    nCol + 45, 138, "GTIN", "R" , "2", "1,1" )
		// regra para calular digito verificado ean14
		IF(cUND == "KG")
		cEAN14 := "9"+ SUBSTR(alltrim(aDados[3]), 1, 12) 
		//cEAN14 := cEAN14 +""+ U_EAN14(cEAN14)
		ELSE
		cEAN14 := "1"+ SUBSTR(alltrim(aDados[3]), 1, 12) 
		
		ENDIF
		
		cEAN14 := cEAN14 +""+ U_EAN14(cEAN14)

		MSCBSAY(    nCol + 40, 132, cEAN14, "R" , "3", "1,1" )
		
		MSCBBOX(48,90,59,100,1)
		MSCBSAY(    nCol + 45, 98, "Pcs", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 40, 97, AllTrim(TRANSFORM(aDados[4], PesqPict("SZB","ZB_QTD"))), "R" , "3", "1,1" )
		MSCBBOX(48,60,59,90,1)
		MSCBSAY(    nCol + 45, 88, "Lote", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 40, 88, aDados[5], "R" , "3", "1,1" )

		//2º linha
		MSCBBOX(38,110,48,140,1)
		MSCBSAY(    nCol + 35, 138, "Peso Liquido", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 30, 131, AllTrim(TRANSFORM(aDados[6], PesqPict("SZB","ZB_PESOLIQ"))), "R" , "4", "1,1" )
		MSCBSAY(    nCol + 30, 114, "kg", "R" , "2", "1,1" )
		MSCBBOX(38,85,48,110,1)
		MSCBSAY(    nCol + 35, 108, "Data Producao", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 30, 108, DTOC(aDados[7]), "R" , "3", "1,1" )
		MSCBBOX(38,60,48,85,1)
		MSCBSAY(    nCol + 35, 83, "Vencimento", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 30, 83, DTOC(aDados[8]), "R" , "3", "1,1" )

		//3º linha
		MSCBBOX(28,110,38,140,1)
		MSCBSAY(    nCol + 25, 138, "Peso Bruto", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 20, 131, AllTrim(TRANSFORM(aDados[9], PesqPict("SZB","ZB_PESOBAL"))), "R" , "4", "1,1" )
		MSCBSAY(    nCol + 20, 114, "kg", "R" , "2", "1,1" )
		MSCBBOX(28,85,38,110,1)
		MSCBSAY(    nCol + 25, 108, "Tara Embalagem", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 20, 100, AllTrim(TRANSFORM(aDados[10], PesqPict("SZB","ZB_TARAEMB"))), "R" , "3", "1,1" )

		//4º linha
		MSCBBOX(08,110,27.5,140,1)
		MSCBSAY(    nCol + 14, 138, "CONSERVACAO:", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 10, 138, "MANTENHA AMBIENTE", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 02, 138, Alltrim(cTemperatura), "R" , "2", "1,1" ) // ajusta para campo SB1 cTemperatura  "0.0 C A 22.00 C"
		MSCBBOX(20,85,27.5,110,1)
		MSCBSAY(    nCol + 14, 108, "Tara caixa", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 10, 98, AllTrim(TRANSFORM(aDados[11], PesqPict("SZB","ZB_TARACX"))), "R" , "3", "1,1" )
		MSCBBOX(08,85,20,110,1)
		MSCBSAY(    nCol + 06, 108, "Tara", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 02, 108, "Total", "R" , "2", "1,1" )
		MSCBSAY(    nCol + 02, 98, AllTrim(TRANSFORM(aDados[12], PesqPict("SZB","ZB_TARACX"))), "R" , "3", "1,1" )

		//Codigo barras unidade logistica
       // MSCBSAYBAR( nCol , 45,   "00"+AllTrim(aDados[13])    ,"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
        //   MSCBSAY( nCol + 05, 43, "(00)"+AllTrim(aDados[13]), "N" , "1", "1,1" )

        IF EMPTY(aDados[14])
          MSCBSAYBAR( nCol , 45,   "00"+AllTrim(aDados[13])    ,"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
           MSCBSAY( nCol + 05, 43, "(00)"+AllTrim(aDados[13]), "N" , "1", "1,1" )
		  Else
		  // codigo da caixa 
              MSCBSAYBAR( nCol , 45,   AllTrim(aDados[14])    ,"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
           MSCBSAY( nCol + 05, 43, AllTrim(aDados[14]), "N" , "1", "1,1" )
		EndIf




         cDATA1  := SUBSTR(DTOS(aDados[8]), 3)  	
         cDATA2  := SUBSTR(DTOS(aDados[7]), 3)
		//Codigo barras  nCol +1
		MSCBSAYBAR( 2.6 , 20, "15"+cDATA1+"11"+cDATA2+"10"+AllTrim(aDados[5])+"7030"+AllTrim(cRegistro),"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
            MSCBSAY( ( nCol -5) +01, 18, "(15)"+cDATA1+"(11)"+cDATA2+"(10)"+AllTrim(aDados[5])+"(7030)"+AllTrim(cRegistro), "N" , "1", "1,1" )
		
		
		cPLiquido := StrZero(Val( StrTran( AllTrim(TRANSFORM(aDados[6], PesqPict("SZB","ZB_PESOLIQ"))), ",", "")) + 0, 6 )  /// StrTran( AllTrim(aDados[6]), ",", "")
		cPBruto   := StrZero(Val(StrTran( AllTrim(TRANSFORM(aDados[9], PesqPict("SZB","ZB_PESOBAL"))), ",", "") ) + 0, 6 )
		nQTD_EMB :=  StrZero(  Val( AllTrim( str(aDados[4]) ) ) + 0, 2)
		//Codigo GS1               //AllTrim(aDados[3])/aDados[3]/aDados[14]/aDados[14] //"+ AllTrim(aDados[14]) +"(
		MSCBSAYBAR( 0.85 , 05, "01"+ cEAN14 +"3103"+ cPLiquido +"3303"+ cPBruto +"30"+ nQTD_EMB,"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
        
		MSCBSAY( ( nCol -5) + 01, 03, "(01)"+ cEAN14 +"(3103)"+ cPLiquido +"(3303)"+ cPBruto +"(30)"+ nQTD_EMB, "N" , "1", "1,1" )
		
		//teste inverter
		//MSCBSAYBAR( nCol + 15 , 80, "01"+ cEAN14 +"3103"+ cPLiquido +"3303"+ cPBruto +"30"+ AllTrim(str(aDados[4])),"R" ,"MB07",08,.F.,.F.,.F.,,4,4,.T.,.F.)
         
          

      
		sConteudo := MSCBEND( )
		MSCBClosePrinter( )

		sConteudo := ""
	Next NY

Return( sConteudo )





/*
Função		U_EAN14()
Autor		ERPC
Descrição	Calcula Digito verificador para EAN14 
Parâmetro	String com 13 digitos 
Retorno		String contendo dígito verificador
*/
User function EAN14(cCod13)
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






