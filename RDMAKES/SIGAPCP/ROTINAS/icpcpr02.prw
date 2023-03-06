#include "protheus.ch"
#include "parmtype.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function ICPCPR02
    Etiqueta SORO Silvestre
	@type  Function
	@author ICMAIS
	@since 26/12/2020
	@version 1.0
	@return nil, nil, nil
/*/
User Function ICPCPR02()

	Local sConteudo
	Local aArea			:= GetArea()
	Local aDados		:= {}
	Local aPergs   		:= {}
	Local cCodBar		:= ""
	Local cFabric		:= ""
	Local nQtdEtq		:= 1

	Private nX1PrdQt    := 1
	Private cX1Porta    := "LPT2" //""
	Private lX1Driv     := .F.
	Private lX1StPrn    := .F.
	Private cModelPrt	:= "OS 214" //"ZEBRA"

	//MsgInfo("Dadoso =["+ cModelPrt+"|Porta="+cX1Porta+"]"," Portas")//

	//Informa quantidade de etiquetas a serem impressas
	aAdd(aPergs,{1,"Quantidade",nQtdEtq,"@E 9,999.99","","","",20,.T.}) // Tipo num�rico
	if ParamBox(aPergs,"Informe quantidade de etiquetas",/*@aRetBox*/,,,,,,,,.F.)
		nQtdEtq	:= MV_PAR01

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

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(DbGoTop())
		if dbSeek(xFilial("SB1")+SZA->ZA_PRODUTO)
			cCodBar := SB1->B1_CODBAR
			cFabric := SB1->B1_FABRIC	
			//cFabric := "SILVESTRE"
		endif

		//Exemplo aDados fixos
		Aadd(aDados,AllTrim(SZA->ZA_PRODUTO)) //Codigo
		Aadd(aDados,AllTrim(SZA->ZA_DESC)) //Descricao
		Aadd(aDados,"FABRICANTE " + AllTrim(cFabric)) //Fabricante
		Aadd(aDados,DTOC(SZA->ZA_DATFAB)) //Fabricacao
		Aadd(aDados,DTOC(SZA->ZA_DATVLD)) //Validade
		Aadd(aDados,AllTrim(SZA->ZA_LOTECTL)) //Lote
		Aadd(aDados,AllTrim(cCodBar)) //Barras

		EMPZEB( aDados, nQtdEtq )


     	/*MSCBBEGIN(1,4)
		MSCBSAY(10,10,"TESTE IMPRESSAO EM REDE", "N","2","1,1")
		MSCBEND()
		MSCBCLOSEPRINTER()*/



	endif

	RestArea( aArea )

Return( sConteudo )




Static Function EMPZEB(  aDados, nQtdEtq )

	Local nCol		:= 10
	Local NY		:= 0
	Local nQtdImp	:= nQtdEtq
	Local sConteudo

	/*
	Estrutura aDados
	aDados[1] Codigo
	aDados[2] Descricao
	aDados[3] Fabricante
	aDados[4] Fabricacao
	aDados[5] Validade
	aDados[6] Lote
	aDados[7] Barras
	*/

	For NY := 1 To nQtdImp
		sleep(250)
		MSCBBEGIN( 1, 4 )
		
		MSCBBOX(010,110,100,140,3)
		
		MSCBSAY(nCol+025, 0133, aDados[1] , "N" , "4", "1,1" )
		MSCBSAY(nCol+005, 125, aDados[2] , "N" , "4", "1,1" )

		 MSCBSAY(nCol+010, 96, aDados[3] , "N" , "6", "1,1" )

		MSCBBOX(010,38,100,90,3)
		MSCBSAY(nCol+005, 079, "FAB.: " + aDados[4] , "N" , "5", "2,1" )
		MSCBSAY(nCol+005, 061, "VAL.: " + aDados[5] , "N" , "5", "2,1" )
		MSCBSAY(nCol+005, 043, "LOTE: " + aDados[6] , "N" , "5", "2,1" )

		//Codigo barras
    	//MSCBSAYBAR( nCol+020 , 013 , aDados[7],"N" ,"MB07",15,.F.,.T.,.F.,,3,1,.T.,.F.)
        if EMPTY( ALLTRIM(aDados[7]) )
		ELSE
		MSCBSAYBAR( nCol+020  , 13, aDados[7] ,"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
		ENDIF
		
		sConteudo := MSCBEND( )
		MSCBClosePrinter( )

		sConteudo := ""
	Next NY

Return( sConteudo )
