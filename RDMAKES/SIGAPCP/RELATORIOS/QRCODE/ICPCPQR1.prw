#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} ETQRECB1
Funcao padrao para impressao de etiqueta com QRCODE
@type function
@version 1.0
@author Igor
@since 15/02/2023
@param aETIQUETA, array, vetor de etiquetas a serem impressas
@param lTeste, logical, indica se é uma chamada para teste ou não .T.(Teste) .F. (Executar)
/*/
User Function ICPCPQR1(aDados)

Local nPos         := 0
Default aETIQUETA  := {}
default lTeste     := .F.

// DADOS MANUAIS PARA VETOR


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

/*aAdd(aETIQUETA,'00810003')
aAdd(aETIQUETA,'ORO EM PO ROHDEN (SERVICOS)')
aAdd(aETIQUETA,'123456789012345')
aAdd(aETIQUETA, 49,4500)
aAdd(aETIQUETA, 'ROH 0033')
aAdd(aETIQUETA, 15.500)
aAdd(aETIQUETA, '15/02/2023')
aAdd(aETIQUETA, '15/02/2024')
aAdd(aETIQUETA, 16.500)
aAdd(aETIQUETA, 0.00)
aAdd(aETIQUETA, 0.00)
aAdd(aETIQUETA, 0.00)
aAdd(aETIQUETA, '0081000300000075')
aAdd(aETIQUETA, '0081000300000000')*/

aAdd(aETIQUETA, aDados)

//MsgInfo( 'Teste de impressão de etiquetas QRCODE: '+ ALLTRIM(aETIQUETA[1]) , 'I M P R E S S A O ' )

// Verifica se o vetor de etiquetas veio com algum conteudo antes de prosseguir
if len( aETIQUETA ) == 0
    Help(NIL, NIL, 'Impressao de Etiquetas', NIL, 'Nenhuma informação de etiqueta recebida para impressão',;
    1, 0, NIL, NIL, NIL, NIL, NIL, {'Parametro com o conteúdo das etiquetas a serem impressos foi enviado vazio!'})
    restArea( aArea )
    return Nil
endif


// aAdd(aDados,"BB") // 08 - UNIDADE DE MEDIDA
// aAdd(aETIQUETA, aDados)
private _nModelo     := 1
Private _aImagem
Private _lPDF



cResult := ""
IF LEN( aETIQUETA ) > 0
    For nPos := 1 to LEN( aETIQUETA ) 
       
        QRPRODT1(aETIQUETA[nPos])
        sleep(250) //AGUARDE
    Next nPos
    if lTeste .and. !Empty( cResult )
        MsgInfo( 'Teste de impressão de etiquetas: '+ chr(13)+chr(10)+ cResult, 'I M P R E S S A O ' )
    endif
EndIF  

//RestArea( aArea )
Return (Nil)

/*/{Protheus.doc} PRINT001
Função usada para impressão das etiquetas com QRCODE
@type function
@version 1.0
@author Igor
@since 15/02/2023
@param aETIQUETA, array, vetor de etiquetas a serem impressas
@param lTeste, logical, indica se é apenas uma chamada para teste
/*/

///MODELO PARA IMPRESSAO DE QRCODE

#DEFINE MODELO_PEQ10x6 1

Static function QRPRODT1(aDados)
   
    Local aArea			:= GetArea()
    Local lPDF      := _lPDF
    Local nQtdImp   := 1
    Local bPrint    :={|aParam, oImpEti| ImpEtiq(_nModelo,aDados, lPDF, oImpEti, nQtdImp)}
    Local cModel	:= "ZEBRA"
    Local cPorta    := "LPT1" 
    Local nDensi    := 8
    Local nTamanho  := 75 // mm Altura
    Local oImpEti   := AdapterEtiqueta():New(bPrint, cModel, cPorta, nDensi, nTamanho)   
    Local lEndAuto  := _nModelo == MODELO_PEQ10x6
    
    oImpEti:Print({ }, lEndAuto)  
     RestArea( aArea )

Return (Nil)


Static Function ImpEtiq(nModelo, aDados,  lPDF, oImpEti, nQtdImp)

    Return PRINTETQ( aDados, oImpEti )

Return


Static Function PRINTETQ( aDados, oImpEti )

Local nCol	:= 10
Local NY		:= 0
Local nLin  := 2
Local cqrcode := ""

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
    aDados[15] Temperatura
    aDados[16] unidade
    aDados[17] registro
    aDados[18] sif
    aDados[19] QRCODE
	*/




  

    MSCBWrite( "^LT0" )     // 	Label top = 0
    MSCBWrite( "^BY1,3,1" )
    MSCBBEGIN( 1, 4 )
         cTemperatura := aDados[15] // POSICIONE("SB1",1,XFILIAL("SB1")+aDados[1],"SB1->B1_X_TEMPE")   
		 cUND         := aDados[16] //POSICIONE("SB1",1,XFILIAL("SB1")+aDados[1],"SB1->B1_UM") 
		 cRegistro    := aDados[17] //GetMv("MV_X_RGPRO")
         cSIF         := aDados[18]
       
		//1º linha
		MSCBSAY(nCol + 50 , 005, AllTrim( aDados[1] ) +" | "+ AllTrim( aDados[2] ), "R" , "B", "025,020" )
		//1º linha
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

		//2º linha
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

		//3º linha
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



		//4º linha
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
            MSCBSAY(  26, 76, "(15)"+cDATA1+"(11)"+cDATA2+"(10)"+AllTrim(aDados[5])+"(7030)"+AllTrim(cRegistro), "R" , "D", "010,010" )
			
			//vertical
			///MSCBSAYBAR( 005 , 135, "15"+cDATA1+"11"+cDATA2+"10"+AllTrim(aDados[5])+"7030"+AllTrim(cRegistro),"N" ,"MB07",08,.F.,.F.,.F.,,2,2,.T.,.F.)
		    ///  MSCBSAY(  005, 144, "(15)"+cDATA1+"(11)"+cDATA2+"(10)"+AllTrim(aDados[5])+"(7030)"+AllTrim(cRegistro), "N" , "D", "010,010" )
		
		cPLiquido := StrZero(Val( StrTran( AllTrim(TRANSFORM(aDados[6], PesqPict("SZB","ZB_PESOLIQ"))), ",", "")) + 0, 6 )  /// StrTran( AllTrim(aDados[6]), ",", "")
		cPBruto   := StrZero(Val(StrTran( AllTrim(TRANSFORM(aDados[9], PesqPict("SZB","ZB_PESOBAL"))), ",", "") ) + 0, 6 )
		nQTD_EMB :=  StrZero(  Val( AllTrim( str(aDados[4]) ) ) + 0, 2)
		//Codigo GS1               //AllTrim(aDados[3])/aDados[3]/aDados[14]/aDados[14] //"+ AllTrim(aDados[14]) +"(       2,5
		//65
        MSCBSAYBAR( 008 , 78, "01"+ cEAN14 +"3103"+ cPLiquido +"3303"+ cPBruto +"30"+ nQTD_EMB,"R" ,"MB07",11,.F.,.F.,.F.,,2,2,.T.,.F.)//MSCBSAYBAR( 008 , 54, "01"+ cEAN14 +"3103"+ cPLiquido +"3303"+ cPBruto +"30"+ nQTD_EMB,"R" ,"MB07",11,.F.,.F.,.F.,,3,2,.T.,.F.)
        //60
		MSCBSAY(  005,  74, "(01)"+ cEAN14 +"(3103)"+ cPLiquido +"(3303)"+ cPBruto +"(30)"+ nQTD_EMB, "R" , "D", "010,010" )
		
    nCol := 010
    nLin := 045
    
     //LINHA QUE GERA O QRCODE
    cqrcode := aDados[19]// AllTrim( aDados[1] ) +"-"+ ALLTRIM( aDados[2] ) 
    MSCBWrite( oImpEti:GeraQrCode((nCol), (nLin), ALLTRIM( cqrcode ), 4) )
  

Return( nil )
