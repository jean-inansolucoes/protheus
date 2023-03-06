#include "protheus.ch"
#include "rwmake.ch"                                         
#include "topconn.ch"   
#include "font.ch"
#include "colors.ch"   
#include "dbinfo.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSFIN014	 ºAutor  ³Totvs Cascavel	  º Data ³  27/06/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exportação arquivo TXT - Integração Boa Vista				   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Laticinio Silvestre				                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/        

***---------------------***
User Function LSFIN014()
***---------------------***

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/   
Local nLinha		:= 0  
Local aCamposEdt    := {}
Local aCols         := {}
Local cPerg         := "LSFIN014X1"
                                   
Private cDirDocs  := MsDocPath()
Private dDataIni  := CTOD( "  /  /  " )
Private dDataFim  := CTOD( "  /  /  " )
Private cTitulIni := Space( TamSX3( "E1_NUM" )[ 1 ]  )
Private cTitulFim := Space( TamSX3( "E1_NUM" )[ 1 ]  )
Private cClienIni := Space( TamSX3( "A1_COD" )[ 1 ]  )
Private cClienFim := Space( TamSX3( "A1_COD" )[ 1 ]  )
Private cLojaIni  := Space( TamSX3( "A1_LOJA" )[ 1 ]  )
Private cLojaFim  := Space( TamSX3( "A1_LOJA" )[ 1 ]  )
Private aHeader     := {}
Private nOpc 		:= GD_UPDATE //GD_INSERT+GD_DELETE+GD_UPDATE 
Private aHedCt		:= {}
Private aClsCt		:= {}
Private aBotoes		:= {}  
Private nOpcao		:= 0

Private cFieldOK    := 'TMP_OK'
Private oGetDados        

Private aSize	 	:= {} // pega o tamanho da tela  
Private aInfo 		:= {}
Private aObj 		:= {}
Private aPObj 		:= {}
Private aPGet 		:= {}   
Public ___lRet      := .T.

AJustaSX1( cPerg )
Pergunte( cPerg, .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona opcoes no acoes relacionadas 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
aAdd( aBotoes,{ 'Parâmetros',{|| Pergunte( cPerg, .T. ) },'Parâmetros' } ) 

// Retorna a área útil das janelas Protheus
aSize := MsAdvSize()
 
// Será utilizado três áreas na janela
// 1ª - Enchoice, sendo 80 pontos pixel
// 2ª - MsGetDados, o que sobrar em pontos pixel é para este objeto
// 3ª - Rodapé que é a própria janela, sendo 15 pontos pixel
 
AADD( aObj, { 100, 055, .T., .F. }) 
AADD( aObj, { 100, 015, .T., .T. })
 
// Cálculo automático da dimensões dos objetos (altura/largura) em pixel
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 }
aPObj := MsObjSize( aInfo, aObj )
 
// Cálculo automático de dimensões dos objetos MSGET
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {002, 002, 240, 270} } )


aCamposShw := {}
aCamposEdt := {}
cQuery     := "SELECT SE1.* FROM " + RetSQLName( "SE1" ) + " SE1 WHERE SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "' AND SE1.D_E_L_E_T_ <> '*'  "
cItem      := {}

// MODELO 1
//-----------------------------------------------------------------------------------------------------------
// Parametro 1: Alias a ser montado o aHeader
// Parametro 2: Campos a serem editados conforme a regra X3Uso( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL
// Parametro 3: Query para consultar os dados desejados
U_FSWMKB01( "SE1", @aCamposShw, cQuery )

//U_M9990201( "SE1", aCamposShw, aCamposEdt, aCores, cQuery, aCoord, oObjShow, oGetDados, 


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont09n   	:= TFont():New( "Tahoma",0,-12,,.T.,0,,700,.F.,.F.,,,,,, )
oFont07n   	:= TFont():New( "Tahoma",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      	:= MSDialog():New( aSize[7],0,aSize[6],aSize[5],"Geração de Arquivo - Boa Vista",,,.F.,,,,,,.T.,,,.T. )   

oGrpFil    	:= TGroup():New( 016,004,aPObj[1,3],aPObj[1,4],"   Parâmetros dos Filtros  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

nColA       := aPGet[1,1]+010
nColB       := aPGet[1,1]+050
nColC       := aPGet[1,1]+250
nColD       := aPGet[1,1]+290

nLinIniA    := aPObj[1,1]+012
nLinIniB    := aPObj[1,1]+010
oSay22     	:= TSay():New( nLinIniA,nColA,{||"Emissão de:"},oGrpFil,,oFont07n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oGCtIni    	:= TGet():New( nLinIniB,nColB,{|u| If(PCount()>0,dDataIni:=u,dDataIni)},oGrpFil,075,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataIni",,)

oSay44     	:= TSay():New( nLinIniA,nColC,{||"Emissão até:"},oGrpFil,,oFont07n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGCtFim   	:= TGet():New( nLinIniB,nColD,{|u| If(PCount()>0,dDataFim:=u,dDataFim)},oGrpFil,075,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataFim",,)

nLinIniA    += 12
nLinIniB    += 12
oSay2      	:= TSay():New( nLinIniA,nColA,{||"Título de:"},oGrpFil,,oFont07n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oGCtIni    	:= TGet():New( nLinIniB,nColB,{|u| If(PCount()>0,cTitulIni:=u,cTitulIni)},oGrpFil,075,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE1","cTitulIni",,)

oSay4      	:= TSay():New( nLinIniA,nColC,{||"Título até:"},oGrpFil,,oFont07n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGCtFim   	:= TGet():New( nLinIniB,nColD,{|u| If(PCount()>0,cTitulFim:=u,cTitulFim)},oGrpFil,075,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE1","cTitulFim",,)

nLinIniA    += 12
nLinIniB    += 12
oSay22     	:= TSay():New( nLinIniA,nColA,{||"Cliente de:"},oGrpFil,,oFont07n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oGCtIni    	:= TGet():New( nLinIniB,nColB,{|u| If(PCount()>0,cClienIni:=u,cClienIni)},oGrpFil,075,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cClienIni",,)
oGCtIni    	:= TGet():New( nLinIniB,nColB + 80,{|u| If(PCount()>0,cLojaIni:=u,cLojaIni)},oGrpFil,035,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cLojaIni",,)

oSay44     	:= TSay():New( nLinIniA,nColC,{||"Cliente até:"},oGrpFil,,oFont07n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGCtFim   	:= TGet():New( nLinIniB,nColD,{|u| If(PCount()>0,cClienFim:=u,cClienFim)},oGrpFil,075,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","cClienFim",,)
oGCtFim   	:= TGet():New( nLinIniB,nColD + 80,{|u| If(PCount()>0,cLojaFim:=u,cLojaFim)},oGrpFil,035,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cLojaFim",,)

oBtn1       := TButton():New( aPObj[1,1]+010,aPObj[1,4]-060,"Pesquisar",oGrpFil,{|| MsgRun( "Verificando movimentos", 'Aguarde...', {|| U_FSWMKB01( "SE1", Nil, fMontaQry( cPerg ) ) } ) },050,012,,oFont07n,,.T.,,"",,,,.F. )

oGetDados	:= MsNewGetDados():New(aPObj[2,1], aPObj[2,2], aPObj[2,3], aPObj[2,4],nOpc,'AllwaysTrue()','AllwaysTrue()','',aCamposShw,0,999,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHeader, aCols )
oGetDados:oBrowse:bLDblClick := {|| QualCol( oGetDados ) }  

oDlg1:bInit := {||EnchoiceBar( oDlg1, {|| Processa( {|| fGoProcess( oGetDados ) }, "Aguarde...", "Efetuando exportação...",.F.) }, {|| oDlg1:End() },.F.,aBotoes)}  

oDlg1:Activate(,,,.T.) 

Return    
              
***-----------------------------------***
static function fGoProcess( oGetDados )
***-----------------------------------***

Local nPosOK   := aScan( oGetDados:aHeader, { |X| Alltrim( X[ 2 ] ) ==  cFieldOK     } )
Local nPosCli  := aScan( oGetDados:aHeader, { |X| Alltrim( X[ 2 ] ) ==  "E1_CLIENTE" } )
Local nPosLja  := aScan( oGetDados:aHeader, { |X| Alltrim( X[ 2 ] ) ==  "E1_LOJA"    } )
Local nPosTit  := aScan( oGetDados:aHeader, { |X| Alltrim( X[ 2 ] ) ==  "E1_NUM"     } )
Local nPosPrf  := aScan( oGetDados:aHeader, { |X| Alltrim( X[ 2 ] ) ==  "E1_PREFIXO" } )
Local nPosPar  := aScan( oGetDados:aHeader, { |X| Alltrim( X[ 2 ] ) ==  "E1_PARCELA" } )
Local nPosTpo  := aScan( oGetDados:aHeader, { |X| Alltrim( X[ 2 ] ) ==  "E1_TIPO"    } )
Local lSelect  := .F.
Local nHdl     := 0
Local aSegmenB := {} 
Local nItens   :=  0
Local nVlrSe5  := 0
Local cVlrVnda

//INCLUSÃO DE REGISTROS PJ ABERTOS/INCLUSÃO (BAIXA POR PAGAMENTO) DE REGISTROS PJ FECHADOS.
Local cSegmenJ := ""

//CANCELAMENTO / EXCLUSAO DE REGISTROS PJ (EXCLUSÃO FÍSICA DO REGISTRO NA BASE DA BVS)
Local cSegmenB := ""

Private aBaixaSE5  := {}
Private	aTemBxCanc := {}

dBSelectArea( "SE1" )
SE1->( dBSetOrder( 1 ) ) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

dBSelectArea( "SA1" )
SA1->( dBSetOrder( 1 ) ) // A1_FILIAL+A1_COD+A1_LOJA

dBSelectArea( "SE5" )
SE5->( dBSetOrder( 7 ) ) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ

For nX := 1 To Len( oGetDados:aCols )

	If oGetDados:aCols[ nX ][ nPosOK ] == 'LBOK'
		nItens++
	Endif

Next

If nItens > 0
	nHdl := MsfCreate( cDirDocs + "\" + Alltrim( MV_PAR02 ) , 0 )
	ProcRegua( nItens )
Endif

If nItens == 0

	Alert( "Nenhum item encontrado para processar..." )

Else

	For nX := 1 To Len( oGetDados:aCols )
		
		If oGetDados:aCols[ nX ][ nPosOK ] == 'LBOK'
			SA1->( dBGoTop() )
		    SA1->( dBSeek( xFilial( "SA1" ) + oGetDados:aCols[ nX ][ nPosCli ] + oGetDados:aCols[ nX ][ nPosLja ] ) )
		    
			SE1->( dBGoTop() )
		    SE1->( dBSeek( xFilial( "SE1" ) + oGetDados:aCols[ nX ][ nPosPrf ] + oGetDados:aCols[ nX ][ nPosTit ] + oGetDados:aCols[ nX ][ nPosPar ] + oGetDados:aCols[ nX ][ nPosTpo ] ) )

		    cTpReg   := ""                                                            /* Tipos de Registro    */
		    cCNPJ    := PADR( ALLTRIM( SA1->A1_CGC ), 14 )                            /* CNPJ                 */
		    cRazSc   := PADR( SA1->A1_NOME  , 55 )                                    /* Razão Social         */
		    cNomFan  := PADR( SA1->A1_NREDUZ, 55 )                                    /* Nome Fantasia        */
		    cNatEnd  := PADR( ""            , 01 )                                    /* Natureza do Endereço */
		    cEnder   := PADR( SA1->A1_END + " " + SA1->A1_COMPLEM , 70 )              /* Endereço             */
		    cCidade  := PADR( SA1->A1_MUN   , 30 )                                    /* Cidade               */
		    cUf      := PADR( SA1->A1_EST   , 02 )                                    /* Estado               */
		    cCEP     := PADR( SA1->A1_CEP   , 08 )                                    /* CEP                  */
		    cDDDFne  := PADR( SA1->A1_DDD   , 04 )                                    /* DDD                  */
		    cFone    := PADR( SA1->A1_TEL   , 10 )                                    /* Telefone             */
		    cDDDFax  := PADR( SA1->A1_DDD   , 04 )                                    /* DDD Fax              */
		    cFax     := PADR( SA1->A1_FAX   , 10 )                                    /* Fax                  */
		    cEmail   := PADR( SA1->A1_EMAIL , 50 )                                    /* E-Mail               */
		    cCliDes  := PADR( Month( SA1->A1_DTINIV ) + Year( SA1->A1_DTINIV ), 6 )   /* Cliente Desde        */
		    cNumTit  := PADR( SE1->E1_NUM   , 12 )                                    /* Número do Título     */
	
		    Do Case
		    	Case Alltrim( SE1->E1_TIPO ) == "DP"
		    		cNumTiP  := PADR( "D"   , 1 )                                    /* Tipo de Título - DUPLICATA    */					    	
		    	Case Alltrim( SE1->E1_TIPO ) == "NF"
		    		cNumTiP  := PADR( "N"   , 1 )                                    /* Tipo de Título - NOTA FISCAL  */					    	
		    	Case Alltrim( SE1->E1_TIPO ) == "FT"
		    		cNumTiP  := PADR( "F"   , 1 )                                    /* Tipo de Título - FATURA       */		    	                                                                                                  
		    	Case Alltrim( SE1->E1_TIPO ) == "BOL"
		    		cNumTiP  := PADR( "B"   , 1 )                                    /* Tipo de Título - BOLETO       */					    	
		    	Case Alltrim( SE1->E1_TIPO ) == "CH"
		    		cNumTiP  := PADR( "C"   , 1 )                                    /* Tipo de Título - CHEQUE       */		    		
		    OtherWise
		    		cNumTiP  := PADR( "O"   , 1 )                                    /* Tipo de Título - OUTROS       */		    		
		    EndCase			    	
	   	  
	   		cQMoeda  := PADR( "R$"   , 04 )                                           /* Moeda                         */
		           
		    
		    //INCLUI SE1 NAO INTEGRADO AINDA
		    IF EMPTY(SE1->E1_X_BVIST)

			    Reclock("SE1",.F.)
			    SE1->E1_X_BVIST  := "I" //INCLUIDO
		    	SE1->( MsUnlock() )			    	
		
				cVlrVnda := Alltrim( Str( SE1->E1_VALOR  ) )
		   		cVlrVnda := StrZero( Val( SubStr( cVlrVnda, 1, IIF(At(  "." , cVlrVnda)>0,At(  "." , cVlrVnda) - 1 ,LEN(cVlrVnda))) ), 11 )   /* Valor da Venda                */
		   		    
		   		cCntVnda := Alltrim( Str( SE1->E1_VALOR ) )
		   		cCntVnda := IIF(At(  "." , cCntVnda )>0,SubStr( cCntVnda, At(  "." , cCntVnda ) + 1, Len( cCntVnda ) - ( At(  "." , cCntVnda ) ) ),"00")
		   		cCntVnda := StrZero( Val( IIF(LEN(cCntVnda)==1,cCntVnda+"0",cCntVnda) )  ,  2 )                                         /* Centavos                      */
		
		   		cVlrVPgt := Padr( "", 11 )                                                            /* Valor da Venda                */
		   		cCntVPgt := Padr( "", 02 )                                                            /* Centavos                      */                 
		
		   		cDtVenda := StrTran( DTOC( SE1->E1_EMISSAO ), "/", "" )                              /* Data da Venda                 */
				cDtVenct := StrTran( DTOC( SE1->E1_VENCREA ), "/", "" )                              /* Data do Vencimento            */
		   		cDtPagto := Space( 8 )
		   		
		
				//INCLUSÃO DE REGISTROS PJ ABERTOS/INCLUSÃO (BAIXA POR PAGAMENTO) DE REGISTROS PJ FECHADOS.
				cSegmenJ := "J"      + ;
			                cCNPJ    + ;
			                cRazSc   + ;
			                cNomFan  + ;
			                cNatEnd  + ;
			                cEnder   + ;
			                cCidade  + ;
			                cUf      + ;
			                cCEP     + ;
			                cDDDFne  + ;
			                cFone    + ;
			                cDDDFax  + ;
			                cFax     + ;
			                cEmail   + ;
			                cCliDes  + ;
			                cNumTit  + ;
			                cNumTiP  + ;
			                cQMoeda  + ;
			                cVlrVnda + ;
			                cCntVnda + ;
		                    cVlrVPgt + ;
		   		            cCntVPgt + ;
		   					cDtVenda + ;
				            cDtVenct + ;
		                    cDtPagto + CHR(13) + CHR(10)
		                    
		        FWrite( nHdl, cSegmenJ )
	   		ENDIF
	   		
	   		//GERA BAIXAS
	   		If ( SE1->E1_SALDO == 0 )  .AND. SE1->E1_X_BVIST  == "I" //INCLUI BAIXA TOTAL
                
			    Reclock("SE1",.F.)
			    SE1->E1_X_BVIST  := "B" //BAIXA TOTAL
		    	SE1->( MsUnlock() )

	   			aBaixaSE5  := {}
	   			aTemBxCanc := {}
	   			/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
				±± Verificação de itens baixados                                           ±±
				Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/   
				aBaixaTit := Sel070Baixa("VL /V2 /BA /RA /CP /LJ /", SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, NIL, NIL, SE1->E1_CLIENTE, SE1->E1_LOJA)
				
				nVlrSe5 := 0
				For nT := 1 To Len( aBaixaSE5 )
				    IF aBaixaSE5[ nT ][ 8 ]+aBaixaSE5[ nT ][ 16 ] > 0
						cDtPagto := StrTran( DTOC( aBaixaSE5[ nT ][ 7 ] ), "/", "" )
						nVlrSe5  += aBaixaSE5[ nT ][ 8 ]+aBaixaSE5[ nT ][ 16 ] 
			        ENDIF
				Next	                    				
				
				//ANALISA SE TEVE BAIXA PARA GRAVAR ARQUIVO
				IF nVlrSe5 > 0 .AND. !EMPTY(cDtPagto)

						cVlrVPgt := Alltrim( Str( nVlrSe5  ) )
				   		cVlrVPgt := StrZero( Val( SubStr( cVlrVPgt, 1, IIF(At(  "." , cVlrVPgt)>0,At(  "." , cVlrVPgt) - 1 ,LEN(cVlrVPgt))) ), 11 )   /* Valor da Venda                */
		   		    
				   		cCntVPgt := Alltrim( Str( nVlrSe5 ) )
				   		cCntVPgt := IIF(At(  "." , cCntVPgt )>0,SubStr( cCntVPgt, At(  "." , cCntVPgt ) + 1, Len( cCntVPgt ) - ( At(  "." , cCntVPgt ) ) ),"00")
				   		cCntVPgt := StrZero( Val( IIF(LEN(cCntVPgt)==1,cCntVPgt+"0",cCntVPgt) )  ,  2 )
				
						//INCLUSÃO DE REGISTROS PJ ABERTOS/INCLUSÃO (BAIXA POR PAGAMENTO) DE REGISTROS PJ FECHADOS.
						cSegmenJ := "J"      + ;
					                cCNPJ    + ;
					                cRazSc   + ;
					                cNomFan  + ;
					                cNatEnd  + ;
					                cEnder   + ;
					                cCidade  + ;
					                cUf      + ;
					                cCEP     + ;
					                cDDDFne  + ;
					                cFone    + ;
					                cDDDFax  + ;
					                cFax     + ;
					                cEmail   + ;
					                cCliDes  + ;
					                cNumTit  + ;
					                cNumTiP  + ;
					                cQMoeda  + ;
					                cVlrVnda + ;
					                cCntVnda + ;
				                    cVlrVPgt + ;
				   		            cCntVPgt + ;
				   					cDtVenda + ;
						            cDtVenct + ;
				                    cDtPagto + CHR(13) + CHR(10)
				    	
				    	//GRAVA ARQUIVO
				    	FWrite( nHdl, cSegmenJ )
				    	
					EndIf				
	   		Endif
	   		
			/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
			±± Verificação de itens cancelados.                                        ±±
			Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/   
			IF SE1->E1_X_BVIST  == "B" //INTEGRADO BAIXA
				SE5->( dBGoTop() )
			    If SE5->( dBSeek( xFilial( "SE5" ) + oGetDados:aCols[ nX ][ nPosPrf ] + oGetDados:aCols[ nX ][ nPosTit ] + oGetDados:aCols[ nX ][ nPosPar ] + oGetDados:aCols[ nX ][ nPosTpo ] + oGetDados:aCols[ nX ][ nPosCli ] + oGetDados:aCols[ nX ][ nPosLja ] ) )
			    	
			    	While !SE5->( Eof() ) .And. ( SE5->( E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_CLIFOR + E5_LOJA  + E5_PARCELA ) ) == ( SE1->( E1_FILIAL + E1_PREFIXO + E1_NUM + E1_CLIENTE + E1_LOJA + E1_PARCELA ) )
			    		
			    		If TemBxCanc( SE5->( E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA + E5_SEQ ) )
			    			aAdd( aTemBxCanc, { SE5->E5_PREFIXO, SE5->E5_NUMERO, SE5->E5_PARCELA, SE5->E5_TIPO, SE5->E5_CLIFOR, SE5->E5_LOJA, SE5->E5_SEQ } )
			    		Endif
			    		
			    		SE5->( dBSkip() )
			    		
			    	Enddo
			    	
			    Endif
			    
				//CANCELAMENTO / EXCLUSAO DE REGISTROS PJ (EXCLUSÃO FÍSICA DO REGISTRO NA BASE DA BVS)
		        For nO := 1 To Len( aTemBxCanc ) 
				    Reclock("SE1",.F.)
				    SE1->E1_X_BVIST  := "I" //INCLUIDO
			    	SE1->( MsUnlock() )		        
		        	aAdd( aSegmenB, "B"      + ;
				                    cCNPJ    + ;
				                    cRazSc   + ;
				                    cNomFan  + ;
				                    cNatEnd  + ;
				                    cEnder   + ;
				                    cCidade  + ;
				                    cUf      + ;
				                    cCEP     + ;
				                    cDDDFne  + ;
				                    cFone    + ;
				                    cDDDFax  + ;
				                    cFax     + ;
				                    cEmail   + ;
				                    cCliDes  + ;
				                    cNumTit  + ;
				                    cNumTiP  + ;
				                    cQMoeda  + ;
				                    cVlrVnda + ;
				                    cCntVnda + ;
			   					    cDtVenda + ;
					                cDtVenct + ;
			                        cDtPagto + CHR(13) + CHR(10) )
			    Next
		    ENDIF
		    IncProc()		    
	 	Endif		
	Next
		
	For nX := 1 To Len( aSegmenB )
		FWrite( nHdl, aSegmenB[ nX ] )
	Next
	
	
	If nHdl > 0	
		fClose(nHdl)		
		lResult  := CpyS2T( cDirDocs + "\" + Alltrim( MV_PAR02 ), Alltrim( MV_PAR03 ), .T. )		
		MsgInfo( "Gerado arquivo com sucesso no caminho: "+ALLTRIM(MV_PAR03) + Alltrim( MV_PAR02 ) )
		
		//REINICIA VARIAVEIS
		aCols := {}
		dDataIni  := CTOD( "  /  /  " )
	 	dDataFim  := CTOD( "  /  /  " )
		cTitulIni := Space( TamSX3( "E1_NUM" )[ 1 ]  )
		cTitulFim := Space( TamSX3( "E1_NUM" )[ 1 ]  )
		cClienIni := Space( TamSX3( "A1_COD" )[ 1 ]  )
		cClienFim := Space( TamSX3( "A1_COD" )[ 1 ]  )
		cLojaIni  := Space( TamSX3( "A1_LOJA" )[ 1 ]  )
		cLojaFim  := Space( TamSX3( "A1_LOJA" )[ 1 ]  )   
		oGetDados:aCols := {}
		
		//REFRESH TELA
		oGetDados:Refresh()
		oGetDados:oBrowse:Refresh( .T. ) 
	Endif
	
Endif

Return( Nil )


***-----------------------------------***
Static Function QualCol( oGetDados )
***-----------------------------------***

Local oAux      := oGetDados
Local nLinFirst := 0


For nX := 1 To Len( oGetDados:aCOLS )
	If !oGetDados:aCols[ nX ][ Len( oGetDados:aHeader ) + 1 ]
		nLinFirst := nX
		Exit
	Endif
NExt

If Alltrim( aHeader[ oGetDados:OBROWSE:COLPOS ][ 2 ] ) == cFieldOK
	
	If oGetDados:aCOLS[ oGetDados:oBrowse:nAt, oGetDados:OBROWSE:COLPOS ] == Nil .OR. oGetDados:aCOLS[ oGetDados:oBrowse:nAt, oGetDados:OBROWSE:COLPOS ] == 'LBNO'
		
		If nLinFirst == oGetDados:oBrowse:nAt
			
			If Aviso( "Marcação", "Deseja marcar este item ou todos ?", { "Este Item", "Todos" } ) == 1
				oGetDados:aCOLS[ oGetDados:oBrowse:nAt, oGetDados:OBROWSE:COLPOS ] := 'LBOK'
			Else
				
				For nX := 1 To Len( oGetDados:aCOLS )  
					oGetDados:aCOLS[nX,1]:= 'LBOK'
				Next nX
							
			Endif
			
		Else 
			oGetDados:aCOLS[ oGetDados:oBrowse:nAt, oGetDados:OBROWSE:COLPOS ] := 'LBOK'
		Endif
	Else
		
		If nLinFirst == oGetDados:oBrowse:nAt
		
			If Aviso( "Marcação", "Deseja desmarcar este item ou todos ?", { "Este Item", "Todos" } ) == 1
				oGetDados:aCOLS[ oGetDados:oBrowse:nAt, oGetDados:OBROWSE:COLPOS ] := 'LBNO'
			Else
				For nX := 1 To Len( oGetDados:aCOLS )  
					oGetDados:aCOLS[nX,1]:= 'LBNO'
				Next nX
			Endif
		
		Else 
			oGetDados:aCOLS[ oGetDados:oBrowse:nAt, oGetDados:OBROWSE:COLPOS ] := 'LBNO'
		Endif
		
	Endif
	
Endif

oGetDados:oBrowse:Refresh( .T. ) 

Return( Nil )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marca todos os contratos			 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
***-----------------------------------***
Static Function MARKALL( )   
***-----------------------------------***

For nX := 1 To Len( oGetDados:aCOLS )  
	oGetDados:aCOLS[nX,1]:= 'LBOK'
Next nX
oGetDados:oBrowse:Refresh( .T. ) 
 
Return   



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desmarca todos os contratos			 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
***-----------------------------------***
Static Function DESMALL( )               
***-----------------------------------***

For nX := 1 To Len( oGetDados:aCOLS )  
	oGetDados:aCOLS[nX,1]:= 'LBNO'
Next nX
oGetDados:oBrowse:Refresh( .T. ) 
 
Return   

***-----------------------------------------------***
User Function FSWMKB01( cAlias, aCamposShw, cQuery )
***-----------------------------------------------***

Local aColsBrw   := {}
Local nPosItem   := 0
Local noMsNewGet := 0
Local nPosAlias  := 0
Local lShare     := .T.
Local lReadOnly  := .F.            
Local lFirst     := .F.
Local cAliasTMP  := GetNextAlias() 
Default cAlias   := ""
Default cQuery   := ""

If Len( aHeader ) == 0
    lFirst := .T.
    
	Aadd( aHeader,{ '',cFieldOK	,'@BMP',10						,0,	,,'C',,'V',,,'mark'	,'V','S' } ) 
	
	If !Empty( cAlias )
		
		dBSelectArea( "SX3" )
		SX3->( dBSetOrder( 1 ) )
		SX3->( dBGoTop() )
		SX3->( MsSeek( cAlias ) )
		
		while !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == cAlias
			noMsNewGet++
			
			If X3Uso( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL // .And. SX3->X3_BROWSE == "S"
				Aadd( aHeader, { AllTrim( X3Titulo( ) ),;
								SX3->X3_CAMPO         ,;
								SX3->X3_PICTURE       ,;
								SX3->X3_TAMANHO       ,;
								SX3->X3_DECIMAL       ,;
								SX3->X3_VALID         ,;
								SX3->X3_USADO         ,;
								SX3->X3_TIPO          ,;
								SX3->X3_F3            ,;
								SX3->X3_CONTEXT       ,;
								SX3->X3_CBOX          ,;
								SX3->X3_RELACAO       ,;
								".T."                 })
		   	
				If !Empty( cItem )
					
					If ( AllTrim( SX3->X3_CAMPO ) == cItem )
						nPosItem := noMsNewGet
					Endif
					
				Endif
				
			EndIf
			
			SX3->( dBSkip() )
			
		Enddo
		
	Else
	
		For nX := 1 To Len( aCamposShw )
			SX3->( dBGoTop() )
			If SX3->( dBSeek( aCamposShw[ 1 ] ) )
				noMsNewGet++ 
				
				Aadd( aHeader, { AllTrim( X3Titulo( ) ),;
								SX3->X3_CAMPO         ,;
								SX3->X3_PICTURE       ,;
								SX3->X3_TAMANHO       ,;
								SX3->X3_DECIMAL       ,;
								SX3->X3_VALID         ,;
								SX3->X3_USADO         ,;
								SX3->X3_TIPO          ,;
								SX3->X3_F3            ,;
								SX3->X3_CONTEXT       ,;
								SX3->X3_CBOX          ,;
								SX3->X3_RELACAO       ,;
								".T."                 })
								
				If !Empty( cItem )
					
					If ( AllTrim( SX3->X3_CAMPO ) == cItem )
						nPosItem := noMsNewGet
					Endif
					
				Endif
				
			Endif
			
		Next
		
	Endif
	

Endif

If lFirst
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa montagem do aCols para GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd( aColsBrw, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		If Alltrim( aHeader[ nI ][ 2 ] ) <> cFieldOK
			aColsBrw[ 1 ][ nI ] := CriaVar( aHeader[ nI ][ 2 ] )
		Endif
	Next
	
	aColsBrw[ 1 ][ Len( aHeader ) + 1 ] := .F.
	
	If nPosItem > 0
		aColsBrw[ 1 ][ nPosItem ] := StrZero( 1, TamSx3( cItem )[ 1 ] )
	Endif     
	
Else
	
	CursorWait()
	SysRefresh()
	
	cQuery := StrTran( UPPER( cQuery ), "SELECT", "SELECT '" + Space( 5 ) + "' " + cFieldOK + "," )
	
	MemoWrite( ProcName() + ".sql", cQuery )
	
	U_M9990201( "CLOSETMP", cAliasTMP )
	
	dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAliasTMP, lShare, lReadOnly )
	
				Aadd( aHeader, { AllTrim( X3Titulo( ) ),;
								SX3->X3_CAMPO         ,;
								SX3->X3_PICTURE       ,;
								SX3->X3_TAMANHO       ,;
								SX3->X3_DECIMAL       ,;
								SX3->X3_VALID         ,;
								SX3->X3_USADO         ,;
								SX3->X3_TIPO          ,;
								SX3->X3_F3            ,;
								SX3->X3_CONTEXT       ,;
								SX3->X3_CBOX          ,;
								SX3->X3_RELACAO       ,;
								".T."                 })
	
	
	For nX := 1 To Len( aHeader )

		If ( aHeader[ nX ][ 8 ] <> "C" )
			TcSetField( cAliasTMP, aHeader[ nX ][ 2 ], aHeader[ nX ][ 8 ], aHeader[ nX ][ 4 ], aHeader[ nX ][ 5 ] )
		EndIf

	Next nX
	
	While !( cAliasTMP )->( Eof() )
		aAdd( aColsBrw, Array( Len( aHeader ) + 1 ) )
		
		For nX := 1 To Len( aHeader )
			
			If aHeader[ nX ][ 10 ] != "V"
				
				If !Empty( nPosAlias := FieldPos( aHeader[ nX ][ 2 ] ) )
					aColsBrw[ Len( aColsBrw ) ][ nX ] := ( cAliasTMP )->( FieldGet( nPosAlias ) )
				EndIf
				
			Else
				
				If Alltrim( aHeader[ nX ][ 2 ] ) <> cFieldOK
					aColsBrw[ Len( aColsBrw ) ][ nX ] := CriaVar( aHeader[ nX ][ 2 ] )
					
				Else
				
					If MV_PAR04 == 1
						aColsBrw[ Len( aColsBrw ) ][ nX ] := 'LBOK'
					Else
						aColsBrw[ Len( aColsBrw ) ][ nX ] := 'LBNO'
					Endif
					
				Endif
				
			EndIf
		Next
		
		aColsBrw[ Len( aColsBrw ) ][ Len( aHeader ) + 1 ] := .F.
		
		( cAliasTMP )->( dBSkip() )
		
	Enddo
	
	CursorArrow()
	SysRefresh()

	
	U_M9990201( "CLOSETMP", cAliasTMP )

Endif

If !lFirst
	oGetDados:aCols  := aColsBrw
	oGetDados:oBrowse:Refresh()
Endif

Return( Nil )

***----------------------------***
Static Function fMontaQry( cPerg )
***----------------------------***

Local cQuery := ""
Pergunte( cPerg, .F. )

cQuery := "SELECT SE1.* " + CHR( 13 ) 
cQuery += "  FROM " + RetSQLName( "SE1" ) + " SE1, " + CHR( 13 ) 
cQuery += "       " + RetSQLName( "SA1" ) + " SA1  " + CHR( 13 ) 
cQuery += " WHERE SE1.E1_FILIAL       = '" + xFilial( "SE1" ) + "'" + CHR( 13 ) 
cQuery += "   AND SA1.A1_FILIAL       = '" + xFilial( "SA1" ) + "'" + CHR( 13 ) 
cQuery += "   AND SE1.E1_CLIENTE      = SA1.A1_COD "+ CHR( 13 ) 
cQuery += "   AND SE1.E1_LOJA         = SA1.A1_LOJA " + CHR( 13 ) 
cQuery += "   AND SA1.A1_PESSOA       = 'J'" + CHR( 13 ) 
cQuery += "   AND ( ( SE1.E1_EMISSAO >= '" + DTOS( dDataIni )   + "' ) AND ( SE1.E1_EMISSAO  <= '" + DTOS( dDataFim  ) + "' ) )" + CHR( 13 ) 
cQuery += "   AND ( ( SE1.E1_NUM     >= '" + cTitulIni  + "' ) AND ( SE1.E1_NUM      <= '" + cTitulFim + "' ) )" + CHR( 13 ) 
cQuery += "   AND ( ( SE1.E1_CLIENTE >= '" + cClienIni  + "' ) AND ( SE1.E1_CLIENTE  <= '" + cClienFim  + "' ) )" + CHR( 13 ) 
cQuery += "   AND ( ( SE1.E1_LOJA    >= '" + cLojaIni   + "' ) AND ( SE1.E1_LOJA     <= '" + cLojaFim   + "' ) )" + CHR( 13 ) 

If !Empty( MV_PAR01 )
	cQuery += "   AND SE1.E1_TIPO        IN ( " + MV_PAR01   + " )" + CHR( 13 ) 
Endif

cQuery += "   AND SE1.D_E_L_E_T_     <> '*'"
cQuery += "   AND SA1.D_E_L_E_T_     <> '*'"

MemoWrite( ProcName() + ".sql", cQuery )

Return( cQuery )

***----------------------------***
Static Function AjustaSX1( cPerg )
***----------------------------***

Local aRegs  := {}
Local aSXBs  := { "GPER41", "GPER42", "GPER43", "GPER44" }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd( aRegs,{ cPerg, "01", "Considerar Tipos           ?","Considerar Tipos           ?","Considerar Tipos           ?","mv_ch1","C",99,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "FGTIPS","" ,"","","" } )
aAdd( aRegs,{ cPerg, "02", "Informe o nome do arquivo  ?","Informe o nome do arquivo  ?","Informe o nome do arquivo  ?","mv_ch2","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", ""      ,"" ,"","","" } )
aAdd( aRegs,{ cPerg, "03", "Selecione Local p/ Gravar  ?","Selecione Local p/ Gravar  ?","Selecione Local p/ Gravar  ?","mv_ch3","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "FGGDIR","" ,"","","" } )
aAdd( aRegs,{ cPerg, "04", "Trazer títulos selecionados?","Trazer títulos selecionados?","Trazer títulos selecionados?","mv_ch4","N",01,0,0,"C","","mv_par04","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","", "FGGDIR","" ,"","","" } )

dBSelectArea( "SX1" )
SX1->( dbSetOrder(1) )

For i := 1 To Len( aRegs )
	SX1->( dBGoTop() )
	
	If !SX1->( dBSeek( cPerg + aRegs[ i ][ 2 ] ) )
		RecLock( "SX1", .T. )
		For j := 1 to SX1->( FCount() )
			If j <= Len( aRegs[ i ] )
				SX1->( FieldPut( j, aRegs[ i ][ j ] ) )
			Endif
		Next
		SX1->( MsUnlock() )
	Endif
	
Next


aRegs := { }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens das consultas padrões da rotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd( aRegs, { "FGTIPS", "1", "01", "RE", "FGTIPS", "FGTIPS", "FGTIPS", "SX5"                 } )
aAdd( aRegs, { "FGTIPS", "2", "01", "01", ""      , ""      , ""      , "U_FGETIPOS( 'SX5' )" } )
aAdd( aRegs, { "FGTIPS", "5", "01", ""  , ""      , ""      , ""      , "___lRet"             } )

aAdd( aRegs, { "FGGDIR", "1", "01", "RE", "FGGDIR", "FGGDIR", "FGGDIR", "SA1"                 } )
aAdd( aRegs, { "FGGDIR", "2", "01", "01", ""      , ""      , ""      , "U_FGETDIR(  )"       } )
aAdd( aRegs, { "FGGDIR", "5", "01", ""  , ""      , ""      , ""      , "___lRet"             } )



dBSelectArea( "SXB" )
SXB->( dBSetOrder( 1 ) )

For i := 1 To Len( aRegs )
	SXB->( dBGoTop() )
	If !SXB->( dBseek( aRegs[ i ][ 1 ] +  aRegs[ i ][ 2 ] + aRegs[ i ][ 3 ] + aRegs[ i ][ 4 ] ) )
		
		RecLock( "SXB", .T. )
		For j := 1 to SXB->( FCount() )
			If j <= Len( aRegs[ i ] )
				SXB->( FieldPut( j, aRegs[ i ][ j ] ) )
			Endif
		Next
		SXB->( MsUnlock() )
		
	Endif
Next


Return Nil

***----------------------------***
User Function FGETIPOS( pcQual )
***----------------------------***
Local oOK            := LoadBitmap( GetResources(), 'LBTIK' )
Local oNO            := LoadBitmap( GetResources(), 'LBNO'   )
Local aObjects       := {}
Local aInfo          := {}
Local aPosObj        := {}
Local aLinDet        := {}
Local aCond          := {}
Local aCabTit        := { "", "Código", "Descrição" }
Local aLenTits       := { 12, 30      , 75         }
Local lFlag          := .F.
Local aSize          := MsAdvSize( , .F. , 430 )
Local nOption        := 2
Local cAux           := Space( 99 )
Local aAux           := StrTran( Alltrim( &( Readvar() ) ), "'", "" )
Local aSelects       := StrTokArr( aAux, "," )
Local cCampoCod      := ""
Local cCampoDes      := ""
Local cChave         := ""
Local oDlgConsP

Default pcQual       := ""

For nX := 1 To Len( aSelects )
	aSelects[ nX ] := Alltrim( aSelects[ nX ] )
Next

If !Empty( pcQual )
	
	Do Case
		Case pcQual == "SX5"
			cCampoCod := "X5_CHAVE"
			cCampoDes := "X5_DESCRI"
			cChave    := xFilial( "SX5" ) + "05"
			aCond     := { || xFilial( "SX5" ) == SX5->X5_FILIAL .And. SX5->X5_TABELA == "05" }
			
	EndCase
	
	dBSelectArea( pcQual )
	( pcQual )->( dBSetorder( 1 ) )
	( pcQual )->( dBGoTop() )
	( pcQual )->( MsSeek( cChave ) )
	
	While !( pcQual )->( Eof() ) .And. Eval( aCond )
		
		nPos  := aScan( aSelects, Alltrim( ( pcQual )->&( cCampoCod ) ) )
		lFlag := .F.
		
		If nPos > 0
			lFlag := .T.
		Endif
		
		aAdd( aLinDet, { lFlag                     ,;
		( pcQual )->&( cCampoCod ),;
		( pcQual )->&( cCampoDes ) } )
		
		( pcQual )->( dBSkip() )
	Enddo
	
	aSize[ 1 ] /= 1.9
	aSize[ 2 ] /= 1.9
	aSize[ 3 ] /= 1.9
	aSize[ 4 ] /= 1.6
	aSize[ 5 ] /= 1.9
	aSize[ 6 ] /= 1.6
	aSize[ 7 ] /= 1.9
	
	AAdd( aObjects, { 315,  75, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj  := MsObjSize( aInfo, aObjects,.T.)
	
	dBSelectArea( "SX2" )
	SX2->( dBSetOrder( 1 ) )
	SX2->( dBGoTop() )
	SX2->( dBSeek( pcQual ) )
	
	DEFINE DIALOG oDlgConsP TITLE Alltrim( SX2->X2_NOME ) FROM aSize[ 7 ],000 TO aSize[ 6 ],aSize[ 5 ] PIXEL
	
	oBrowse := TWBrowse():New( aPosObj[ 1 ][ 1 ] + 5, aPosObj[ 1 ][ 2 ], ( oDlgConsP:nWidth / 2 ) - 6, ( oDlgConsP:nHeight / 2 ) - 45,, aCabTit, aLenTits, oDlgConsP,,,,,,,,,,,,.F.,,.T.,,.T.,,.T.,.T. )
	
	oBrowse:SetArray( aLinDet )
	oBrowse:bLine      := {|| { If( aLinDet[ oBrowse:nAt ][ 01 ], oOK, oNO ),;
	aLinDet[ oBrowse:nAt ][ 02 ] , ;
	aLinDet[ oBrowse:nAt ][ 03 ]} }
	
	oBrowse:bLDblClick := {|| aLinDet[ oBrowse:nAt][ 1 ] := !aLinDet[ oBrowse:nAt ][ 1 ], oBrowse:DrawSelect( ) }
	
	ACTIVATE DIALOG oDlgConsP CENTERED ON INIT ( EnchoiceBar(oDlgConsP,{|| ( nOption := 1, oDlgConsP:End() ) },{|| ( nOption := 2, oDlgConsP:End() ) } ), ( CursorArrow(), SysRefresh() ) )
	
	If nOption == 1
		
		&( Readvar() ) := Space( 99 )
		
		For nX := 1 To Len( aLinDet )
			If aLinDet[ nX ][ 1 ]
				cAux += "'" + aLinDet[ nX ][ 2 ] + "', "
			Endif
		Next
		
		cAux := Alltrim( cAux )
		
		&( Readvar() ) :=  SubStr( cAux, 1, Len( cAux ) - 1 )
		
	Endif
	
Endif

Return( .T. )


***----------------------------***
User Function FGETDIR()
***----------------------------***
&( Readvar() ) :=  cGetFile( "","Selecione o local p/ gravar o arquivo...",0,"",.F.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_OVERWRITEPROMPT)
Return( .T. )