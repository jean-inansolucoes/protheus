#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} ETQRECB1
Funcao padrao para impressao de etiqueta palete
@type function
@version 1.0
@author Igor
@since 11/01/2023
@param aETIQUETA, array, vetor de etiquetas a serem impressas
/*/

User Function ETQPALT1(aDados)

Local nPos       := 0
Local aArea      := GetArea()
Local cModel     := "ZEBRA"
Local cPorta     := "LPT1"
//Local aDados     := {}
Private lX1Driv  := .F.
Private lX1StPrn := .F.

Default aETIQUETA := {}
//default lTeste := .F.


 /*aAdd(aDados,"0000000012") //01 - CODIGO DO PALETE
 aAdd(aDados,"00010016") //02 - CODIGO DO PRODUTO
 aAdd(aDados,"QUEIJO MUSS TRELAC 4 KG")//- 03 - DESCRICAO DO ITEM
 aAdd(aDados,"09")  // 04 - QUANTIADE DE CAIXAS
 aAdd(aDados,"05,382")  // 05 - PESO 
 aAdd(aDados,"0466") // 06 - LOTES - INFORMA MAIS DE UM LOTE 
 aAdd(aDados,"22/12/2022")  // 07 - DATAS  VALIDADE , MAIS DE UMA DATA CONFORME O LOTE
 aAdd(aDados,"IGOR BENTES - 01LAT01")  // 08 - CONFERENTE -FILIAL - R
 */
 aAdd(aETIQUETA, aDados) 




// Verifica se o vetor de etiquetas veio com algum conteudo antes de prosseguir
if len( aETIQUETA ) == 0
    Help(NIL, NIL, 'Impressao de Etiquetas', NIL, 'Nenhuma informação de etiqueta recebida para impressão',;
    1, 0, NIL, NIL, NIL, NIL, NIL, {'Parametro com o conteúdo das etiquetas a serem impressos foi enviado vazio!'})
    restArea( aArea )
    return Nil
endif

CursorArrow()
SysRefresh()    
			
MSCBPRINTER( cModel, cPorta,,,.F.,,,,,,lX1Driv )
MSCBCHKSTATUS( lX1StPrn )

// 0123456 7890123     


IF LEN( aETIQUETA ) > 0
    For nPos := 1 to LEN( aETIQUETA ) 
        PRINT001( aETIQUETA[nPos])
        sleep(250) //AGUARDE
    Next nPos
EndIF  

RestArea( aArea )
Return (Nil)

/*/{Protheus.doc} PRINT001
Função usada para impressão das etiquetas
@type function
@version 1.0
@author Igor
@since 11/01/2023
@param aETIQUETA, array, vetor de etiquetas a serem impressas
/*/
Static function PRINT001(aEtq)

    Local nCol	 := 002
    Local sConteudo  
    Local nLinha := 0
 
	sleep(250) 

        MSCBBEGIN( 1, 4 )

        // LINHA 01
        nLinha := 047
        MSCBSAY(nLinha, nCol, "Número do Palete", "R" , "E", "016,012" )
        // LINHA 01 COLUNA 02
        MSCBSAY(nLinha , nCol+78, "Conferente: ", "R" , "E", "016,012" )
        
        // LINHA 02 - CODIGO DE BARRAS E CONFERENTE
        nLinha := nLinha - 009
        MSCBSAYBAR( nLinha , 002 , AllTrim( aEtq[1] ), "R" ,"MB07",9,.F.,.T.,.F.,'B',3,2,)
        // LINHA 02 COLUNA 02
        MSCBSAY(nLinha + 002 , nCol+68, AllTrim( aEtq[8] ), "R" , "E", "016,012" ) // nome do conferente
        
        // LINHA 03 - DESCRICAO
        nLinha := nLinha - 011
        MSCBSAY(nLinha, 002, AllTrim( aEtq[3] ) , "R" , "B", "035,030" ) //"B", "035,030" )
       
        // LINHA 03
        nLinha := nLinha - 010
        MSCBSAY(nLinha , 002, "Quantidade: ", "R" , "E", "016,012" )
        MSCBSAY(nLinha, 030, AllTrim( aEtq[4] ) , "R" , "B", "035,030" )
        MSCBSAY(nLinha , 065, "Peso: ", "R" , "E", "016,012" )
        MSCBSAY(nLinha, 078, AllTrim( aEtq[5] ) , "R" , "B", "035,030" )
        
        // LINHA 04
        nLinha := nLinha - 006
        MSCBSAY(nLinha , 002, "Lote:"+ AllTrim( aEtq[6] ), "R" , "E", "016,012" )
        // LINHA 05
        nLinha := nLinha - 006
        MSCBSAY(nLinha , 002, "Data Val:"+ AllTrim( aEtq[7] ) , "R" , "E", "016,012" )
    
        sConteudo := MSCBEND( )
        MSCBClosePrinter( )     

    

Return( nil )


