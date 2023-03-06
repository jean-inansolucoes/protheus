#include "protheus.ch"
#include "totvs.ch"
#include "colors.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "jpeg.ch"
#include "dbinfo.ch"
#include "prconst.ch"
#include "font.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M9990201 บ Autor ณ FSW RESULTAR			    ณ  22/05/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar.						                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออeออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบFuncoes   ณ CLOSETMP:   Limpa alias temporario.		                  บฑฑ
ฑฑบ          ณ PRODUTO:    Gatilho para trazer codigo automatico Produto. บฑฑ
ฑฑบ          ณ CLIFOR:     Gatilho para trazer codigo automatico Cli/For. บฑฑ
ฑฑบ          ณ TELA:  	   Calculo dimensoes NewGetDados                  บฑฑ
ฑฑบ          ณ SAVEAREA:   Salva แreas de trabalho                        บฑฑ
ฑฑบ          ณ RESTAREA:   Restaura แreas de trabalho                     บฑฑ
ฑฑบ          ณ USERINFO:   Retorna um vetor c/ informa็๕es do Usr/Grupo	  บฑฑ
ฑฑบ          ณ VLDCLIPCTE: Valida Produto/Pacote x Hardlock Cliente		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FSW						                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
***--------------------------------------------------------------------------------------------------***
User Function M9990201(xParam1,xParam2,xParam3,xParam4,xParam5,xParam6,xParam7,xParam8,xParam9,xParam10)
***--------------------------------------------------------------------------------------------------***

Local xReturn
Private bJobOrig    :=  ALLTRIM(GetWebJob()) == "HTTP:GENPROC"

DO CASE
	CASE ALLTRIM(xParam1) == "CLOSETMP"
		xReturn := XFUN001(xParam2)
	CASE ALLTRIM(xParam1) == "PRODUTO"
		xReturn := XFUN002()
	CASE ALLTRIM(xParam1) == "CLIFOR"
		xReturn := XFUN003(xParam2,xParam3,xParam4,xParam5)
	CASE ALLTRIM(xParam1) == "TELA"
		xReturn := XFUN004(xParam2)
	CASE ALLTRIM(xParam1) == "SAVEAREA"
		xReturn := XFUN005(xParam2)
	CASE ALLTRIM(xParam1) == "RESTAREA"
		xReturn := XFUN006(xParam2)
	CASE ALLTRIM(xParam1) == "USERINFO"
		xReturn := XFUN007(xParam2)    
	CASE ALLTRIM(xParam1) == "VLDCLIPCTE"
		xReturn := XFUN008(xParam2)
ENDCASE

Return xReturn

//FUNCAO RESPONSAVEL POR LIMPAR ALIAS E ARQUIVOS TEMPORARIOS
**-------------------------------------**
Static Function XFUN001( cAliasTmp )
**-------------------------------------**
If Select( cAliasTmp ) > 0
	DbSelectArea( cAliasTmp )
	cArq := DbInfo( DBI_FULLPATH )
	cArq := AllTrim( SubStr( cArq,Rat( "\",cArq )+1 ) )
	DbCloseArea( )
	FErase( cArq )
EndIf
Return .t.


//FUNCAO RESPOSANVEL POR RETORNAR CODIGO CLIENTE AUTOMATICO
***--------------------***
Static Function XFUN002()
***--------------------***

Local cArea  	  := GetArea()
Local cAliasTMP   := GetNextAlias()
Local cQuery,cProxProd, cArea, cUltProd, nUltProd, nTamanho


nTamanho := 4 //deve ser alimentado com o tamanho do codigo sem considerar o grupo.  Exemplo:
/*grupo 0101 codigo 000001 - B1_COD = 01010001
|____||___|
GRP  COD
4    4                 */

cGrpAtual  := M->B1_GRUPO

cQuery := "SELECT MAX(B1_COD) AS ULTPROD "
cQuery += "FROM "+RetSqlName( "SB1" )+" "
cQuery += "WHERE D_E_L_E_T_ <> '*' AND B1_GRUPO ='"+cGrpAtual+"' "

TcQuery cQuery New Alias (cAliasTMP)

dbSelectArea(cAliasTMP)

cUltProd  := &(cAliasTMP+"->ultprod")
nUltProd  := val(&(cAliasTMP+"->ultprod"))


If nUltProd <> 0
	cProxProd := SUBSTR(ALLTRIM(cUltProd),0,4)+STRZERO(VAL(SUBSTR(ALLTRIM(cUltProd),5,nTamanho))+1,nTamanho)
Else
	cProxProd := StrZero(Val(Alltrim(cGrpAtual)+"0001"),8)
Endif

U_M9990101("CLOSETMP",cAliasTMP)
RestArea( cArea )

Return( cProxProd )

***-------------------------------------------------***
Static Function XFUN003( pcOrigem, pcPessoa, pcCgc, cTypCh )
***-------------------------------------------------***
Local lShare    := .T.
Local lReadOnly := .F.
Local aArea     := iif( pcOrigem == "SA1", SA1->( GetArea() ), SA2->( GetArea() ) )
Local hEnter    := Chr( 13 )
Local cAlias    := GetNextAlias()
Local cAlias2   := GetNextAlias( )
Local lExterior := .F.
Local aStru     := { }
Local bCond     := { }
Local nRecs     := 0
Local cCod      := ""
Local cTabTMP   := ""
Local cQuery    := ""
Local cRetLoja  := ""
Local cSelect   := ""
Local cAliasSQL := ""
Local cRestrict := ""
Local cCgcSQL   := ""
Local cLjaSQL   := ""
Local cSeek     := ""

Default pcOrigem := ""
Default pcPessoa := ""
Default pcCgc    := ""

If  Empty( pcOrigem ) .Or. ( !pcOrigem $ "SA1#SA2" )
	Aviso("Aten็ใo","Parโmetros informados insuficentes ou invแlidos ! ['Origem']" ,{ "Ok" }, 2 )
	Return( cCod )
Endif

If pcOrigem == "SA1"
	lExterior := iif( M->A1_EST == "EX", .T., .F. )
	
	If Empty(cTypCh)
		If !lExterior
			cCod       := M->A1_COD
			cRetLoja   := M->A1_LOJA
			
			If Empty( M->A1_CGC )
				Aviso("Aten็ใo","Parโmetros informados insuficentes ou invแlidos ! ['CPF/CNPJ']" ,{ "Ok" }, 2 )
				Return( cCod )
			Endif
			
			If M->A1_PESSOA == "F"
				dBSelectArea( "SA1" )
				SA1->( dBSetOrder( 1 ) )
				SA1->( dBGoTop( ) )
				
				If SA1->( MsSeek( xFilial( "SA1" ) + SUBSTR( ALLTRIM( M->A1_PESSOA ), 1, 9 ) ) )
					aStru   := { { "A1_COD" , "C", TAMSX3( "A1_COD"  )[ 1 ], TAMSX3( "A1_COD"  )[ 2 ] },;
					{ "A1_LOJA", "C" ,TAMSX3( "A1_LOJA" )[ 1 ], TAMSX3( "A1_LOJA" )[ 2 ] } }
					
					cTabTMP := CriaTrab( aStru, .T. )
					
					cQuery  := "  SELECT SA1.A1_COD, SA1.A1_LOJA " + hEnter
					cQuery  += "    FROM " + RetSqlName( "SA1" ) + " SA1" + hEnter
					cQuery  += "   WHERE SA1.D_E_L_E_T_ <> '*'" +  hEnter
					cQuery  += "     AND SUBSTRING(SA1.A1_CGC,1,9) = '" + SUBSTR( ALLTRIM( M->A1_PESSOA ),1,9 ) + "'" + hEnter
					cQuery  += "     AND SA1.A1_FILIAL             = '" + xFilial( "SA1" ) + "'"  + hEnter
					cQuery  += "ORDER BY SA1.A1_LOJA" + hEnter
					
					MemoWrite( "MFCLIFOR.SQL", cQuery )
					
					If Select( cAlias ) > 0
						( cAlias )->( dBclosearea( ) )
						Ferase( lower( cAlias ) + GetDBExtension( ) )
						Ferase( lower( cAlias ) + OrdBagExt( ) )
					Endif
					
					dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAlias, lShare, lReadOnly )
					
					Copy to &cTabTMP
					dBclosearea()
					dBusearea(.T.,,cTabTMP,cAlias,.T.,.F.)
					
					( cAlias )->( dBGoBottom( ) )
					
					cCod       := SUBSTR( ALLTRIM( M->A1_PESSOA ),1,9 )
					cRetLoja   := ( cAlias )->A1_LOJA
					cRetLoja   := Soma1( cRetLoja )
					M->A1_LOJA := cRetLoja
					cCod       := cRetLoja
					
					Aviso( "Aten็ใo", "Existe cliente com outras lojas cadastrado com este CPF." + chr( 13 ) + "O codigo do cliente serแ " + cCod + " com a loja " +  cRetLoja,{"Ok"},2)
					ROLLBACKSXE()
				Else
					cCod     := SUBSTR( ALLTRIM( M->A1_PESSOA ),1,9 )
					cRetLoja := StrZero( 1, TamSX3( "A1_LOJA" )[ 1 ] )
					M->A1_LOJA := cRetLoja
					cCod       := cRetLoja
				Endif
				
			ElseIf pcPessoa == "J"
				dBSelectArea( "SA1" )
				SA1->( dBSetOrder( 3 ) )
				SA1->( dBGoTop( ) )
				
				If SA1->( MsSeek( xFilial( "SA1" ) + M->A1_PESSOA ) )
					Aviso( "Aten็ใo", "Existe cliente com este CNPJ, impossivel prosseguir !", { "Ok" },2)
					Return( cCod )
				Else
					cCod      := SUBSTR( ALLTRIM( M->A1_PESSOA ),1,8 )
					cRetLoja  := SUBSTR( M->A1_PESSOA, 9, 4 )
					cCod       := cRetLoja
				Endif
			Endif
		Endif
	ElseIf	cTypCh == "X"
		cQuery := "SELECT MAX( SA1.A1_COD ) A1_MAX_COD" + hEnter
		cQuery += "  FROM " + RetSqlName( "SA1" ) + " SA1 " + hEnter
		cQuery += " WHERE SA1.D_E_L_E_T_   <> '*'" + hEnter
		cQuery += "   AND SA1.A1_TIPO = 'X' "   + hEnter
		cQuery += "   AND SA1.A1_FILIAL     = '" + xFilial( "SA1" ) +"'" + hEnter
		
		MemoWrite( "MFCLIFOR2.SQL", cQuery )
		
		If Select( cAlias2 ) > 0
			( cAlias2 )->( dBclosearea( ) )
			Ferase( lower( cAlias2 ) + GetDBExtension( ) )
			Ferase( lower( cAlias2 ) + OrdBagExt( ) )
		Endif
		
		dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAlias2, lShare, lReadOnly )
		
		If VAL(SUBSTR(( cAlias2 )->A1_MAX_COD,3,LEN(( cAlias2 )->A1_MAX_COD)-2)) > 0
			cCod	   := "EX"+STRZERO((VAL(SUBSTR(ALLTRIM(( cAlias2 )->A1_MAX_COD),3,9))+1),LEN(SA1->A1_COD)-2)
			M->A1_COD  := cCod
			M->A1_LOJA := STRZERO(1,LEN(SA1->A1_LOJA))
		Else
			cCod       := "EX"+STRZERO(1,LEN(SA1->A1_COD)-2)
			M->A1_COD  := cCod
			M->A1_LOJA := STRZERO(1,LEN(SA1->A1_LOJA))
			
		EndIf
	Endif
	
ElseIf pcOrigem == "SA2"
	lExterior := iif( M->A2_EST == "EX", .T., .F. )
	
	If Empty(cTypCh)
		If !lExterior
			cCod       := M->A2_COD
			cRetLoja   := M->A2_LOJA
			If M->A2_TIPO == "F"
				dBSelectArea( "SA2" )
				SA2->( dBSetOrder( 1 ) )
				SA2->( dBGoTop( ) )
				
				If SA2->( MsSeek( xFilial( "SA2" ) + SUBSTR( ALLTRIM( M->A2_TIPO ), 1, 9 ) ) )
					aStru   := { { "A2_COD" , "C", TAMSX3( "A2_COD"  )[ 1 ], TAMSX3( "A2_COD"  )[ 2 ] },;
					{ "A2_LOJA", "C" ,TAMSX3( "A2_LOJA" )[ 1 ], TAMSX3( "A2_LOJA" )[ 2 ] } }
					
					cTabTMP := CriaTrab( aStru, .T. )
					
					cQuery  := "  SELECT SA2.A2_COD, SA2.A2_LOJA " + hEnter
					cQuery  += "    FROM " + RetSqlName( "SA2" ) + " SA2" + hEnter
					cQuery  += "   WHERE SA2.D_E_L_E_T_ <> '*'" +  hEnter
					cQuery  += "     AND SUBSTRING(SA2.A2_CGC,1,9) = '" + SUBSTR( ALLTRIM( M->A2_TIPO ),1,9 ) + "'" + hEnter
					cQuery  += "     AND SA2.A2_FILIAL             = '" + xFilial( "SA2" ) + "'"  + hEnter
					cQuery  += "ORDER BY SA2.A2_LOJA" + hEnter
					
					MemoWrite( "MFCLIFOR.SQL", cQuery )
					
					If Select( cAlias ) > 0
						( cAlias )->( dBclosearea( ) )
						Ferase( lower( cAlias ) + GetDBExtension( ) )
						Ferase( lower( cAlias ) + OrdBagExt( ) )
					Endif
					
					dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAlias, lShare, lReadOnly )
					
					Copy to &cTabTMP
					dBclosearea()
					dBusearea(.T.,,cTabTMP,cAlias,.T.,.F.)
					
					( cAlias )->( dBGoBottom( ) )
					
					cCod     := SUBSTR( ALLTRIM( M->A2_TIPO ),1,9 )
					cRetLoja := ( cAlias )->A2_LOJA
					cRetLoja := Soma1( cRetLoja )
					M->A2_LOJA := cRetLoja
					cCod       := cRetLoja
					
					Aviso( "Aten็ใo", "Existe cliente com outras lojas cadastrado com este CPF." + chr( 13 ) + "O codigo do cliente serแ " + cCod + " com a loja " +  cRetLoja,{"Ok"},2)
					ROLLBACKSXE()
					
				Else
					cCod     := SUBSTR( ALLTRIM( M->A2_TIPO ),1,9 )
					cRetLoja := StrZero( 1, TamSX3( "A2_LOJA" )[ 1 ] )
					M->A2_LOJA := cRetLoja
					cCod       := cRetLoja
				Endif
				
			ElseIf M->A2_TIPO == "J"
				dBSelectArea( "SA2" )
				SA2->( dBSetOrder( 3 ) )
				SA2->( dBGoTop( ) )
				
				If SA2->( MsSeek( xFilial( "SA2" ) + M->A2_TIPO ) )
					Aviso( "Aten็ใo", "Existe fornecedor com este CNPJ, impossivel prosseguir !", { "Ok" },2)
					Return( cCod )
				Else
					cCod      := SUBSTR( ALLTRIM( M->A2_TIPO ),1,8 )
					cRetLoja  := SUBSTR( M->A2_TIPO, 9, 4 )
					cCod       := cRetLoja
				Endif
				
			Endif
		Endif
	ElseIf	cTypCh == "X"
		cQuery := "SELECT MAX( SA2.A2_COD ) A2_MAX_COD" + hEnter
		cQuery += "  FROM " + RetSqlName( "SA2" ) + " SA2 " + hEnter
		cQuery += " WHERE SA2.D_E_L_E_T_   <> '*'" + hEnter
		cQuery += "   AND SA2.A2_TIPO = 'X' "   + hEnter
		cQuery += "   AND SA2.A2_FILIAL     = '" + xFilial( "SA2" ) +"'" + hEnter
		
		MemoWrite( "MFCLIFOR2.SQL", cQuery )
		
		If Select( cAlias2 ) > 0
			( cAlias2 )->( dBclosearea( ) )
			Ferase( lower( cAlias2 ) + GetDBExtension( ) )
			Ferase( lower( cAlias2 ) + OrdBagExt( ) )
		Endif
		
		dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAlias2, lShare, lReadOnly )
		
		If VAL(SUBSTR(( cAlias2 )->A2_MAX_COD,3,LEN(( cAlias2 )->A2_MAX_COD)-2)) > 0
			cCod	   :=  SOMA1( ( cAlias2 )->A2_MAX_COD )
			M->A2_COD  := cCod
			M->A2_LOJA := STRZERO(1,LEN(SA2->A2_LOJA))
		Else
			cCod       := "EX"+STRZERO(VAL(SOMA1("0")),LEN(SA2->A2_COD)-2)
			M->A2_COD  := cCod
			M->A2_LOJA := STRZERO(1,LEN(SA2->A2_LOJA))
		EndIf
	Endif
	
Endif

iif( pcOrigem == "SA1",  M->A1_LOJA := cRetLoja, M->A2_LOJA := cRetLoja )

If Select( cAlias ) > 0
	( cAlias )->( dBclosearea( ) )
	Ferase( lower( cAlias ) + GetDBExtension( ) )
	Ferase( lower( cAlias ) + OrdBagExt( ) )
Endif

If Select( cAlias2 ) > 0
	( cAlias2 )->( dBclosearea( ) )
	Ferase( lower( cAlias2 ) + GetDBExtension( ) )
	Ferase( lower( cAlias2 ) + OrdBagExt( ) )
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura integridade das tabelas envolvidasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Restarea( aArea )

Return( cCod )


***--------------------***
Static Function XFUN004(nTam)
***--------------------***

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP11" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XFUN005  บAutor  ณ FSW RESULTAR       บ Data ณ 23/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo gen้rica para Salvar os posicionamentos das Areas   บฑฑ
ฑฑบ          ณ de Trabalho (Alias) repassados.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ aAlias: Vetor com os Alias das tabelas. Exemplo:           ณฑฑ
ฑฑบ          ณ         { "SC5", "SC6", "SC9" }                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ aRet: Vetor com as informa็๕es salvas de cada Alias        ณฑฑ
ฑฑบ          ณ         { Alias(), IndexOrd(), RecNo() }                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FSW                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
***-------------------------***
Static Function XFUN005(aAlias)
***-------------------------***

Local aRet := {}
Local ix := 0
Default aAlias := {}

aAdd(aRet, { GetArea() })	// Adiciona a Area Atual na 1a posi็ใo
For ix := 1 to Len(aAlias)
	If Select(aAlias[ix]) > 0
		aAdd(aRet, { (aAlias[ix])->(GetArea()) })
	Endif
Next ix

Return(aRet)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XFUN006  บAutor  ณ FSW RESULTAR       บ Data ณ 23/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo gen้rica para Restaurar os posicionamentos das      บฑฑ
ฑฑบ          ณ Areas de Trabalho salvas.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ aSave: Vetor com as Areas Salvas de cada Alias. Exemplo:   ณฑฑ
ฑฑบ          ณ        { Alias(), IndexOrd(), RecNo() }                    บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FSW                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
***-------------------------***
Static Function XFUN006(aSave)
***-------------------------***

Local ix := 0
Default aSave := {}

// Restaura de trแs para frente, a primeira posi็ใo serแ a Area Atual
For ix := Len(aSave) to 1 step -1
	RestArea(aSave[ix][1])
Next ix

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XFUN007  บAutor  ณ FSW RESULTAR       บ Data ณ 28/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo gen้rica para Retornar um vetor com as Informa็๕es  บฑฑ
ฑฑบ          ณ de um Usuแrio                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ cUsuario: ID do usuแrio                                    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Array contendo as informa็๕es do usuแrio                   ณฑฑ
ฑฑบ          ณ Se nใo encontrar o Usuแrio retorna um array vazio          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FSW                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

LINK TDN: http://tdn.totvs.com/pages/releaseview.action?pageId=6814854
อndice  Tipo Conteudo
[1][1]  C    N๚mero de identifica็ใo seqüencial com o tamanho de 6 caracteres
[1][2]  C    Nome do usuแrio
[1][3]  C    Senha (criptografada)
[1][4]  C    Nome completo do usuแrio
[1][5]  A    Vetor contendo as ๚ltimas n senhas do usuแrio
[1][6]  D    Data de validade
[1][7]  N    N๚mero de dias para expirar
[1][8]  L    Autoriza็ใo para alterar a senha
[1][9]  L    Alterar a senha no pr๓ximo logon
[1][10] A    Vetor com os grupos
[1][11] C    N๚mero de identifica็ใo do superior
[1][12] C    Departamento
[1][13] C    Cargo
[1][14] C    E-mail
[1][15] N    N๚mero de acessos simultโneos
[1][16] D    Data da ๚ltima altera็ใo
[1][17] L    Usuแrio bloqueado
[1][18] N    N๚mero de dํgitos para o ano
[1][19] L    Listner de liga็๕es
[1][20] C    Ramal
[1][21] C    Log de opera็๕es
[1][22] C    Empresa, filial e matricula
[1][23] A    Informa็๕es do sistema 
[1][23][1]  L  Permite alterar database do sistema
[1][23][1]  N  Dias a retroceder
[1][23][1]  N  Dias a avan็ar
[1][24] D     Data de inclusใo no sistema
[1][25] C     Nํvel global de campo
[1][26] U     Nใo usado   
*/
***---------------------------***
Static Function XFUN007(cUsuario)
***---------------------------***

Local aRetUser := {}
Local cUserOld := __cUserId

PswOrder(1)
If PswSeek(cUsuario,.T.)
	aRetUser := PswRet(1)	//1=Informa็๕es do us๚ario
EndIf
PswOrder(1)
PswSeek(cUserOld,.T.)

Return(aRetUser)


***---------------------------***
Static Function XFUN008(xPacote)
***---------------------------***      
Local xResult   := .F.
Local cHlNumCli := AllTrim(Str(Ls_GetId())) //BUSCA NUMERACAO DO HARDLOCK DO CLIENTE/BASE EM EXECUCAO
Local xRet007   := {"",0,CTOD("  /  /  "),.T.,xResult,999,""}
Local a99901    := {} //VETOR HARDLOCKS PROCESSO 99901 - CADASTRO DE DESTINATARIOS
Local a00201    := {} //VETOR HARDLOCKS PROCESSO 00201 - PROCESSO COTACAO DE COMPRAS
Local x999
Local x002

AADD(a99901,{'2100003143'}) //RESULTAR - FRANQUIA

AADD(a00201,{'2100003143'}) //RESULTAR - FRANQUIA

// VALIDA PACOTE
DO CASE 
	CASE EMPTY(FUNNAME()) .OR. ALLTRIM(cEmpAnt) == '99' //EMPRESA TESTE / UPD
		xResult 	:= .T. 
		xRet007[7]  := '99'
	
	CASE ALLTRIM(xPacote) == '99901' //CADASTRO DE DESTINATมRIOS - WF
		FOR X999 := 1 TO LEN(a99901)
			IF ALLTRIM(cHlNumCli) $ ALLTRIM(a99901[X999][1])
				xResult 	:= .T. 
				xRet007[7]  := cHlNumCli
			ENDIF
		NEXT X999
	
	CASE ALLTRIM(xPacote) == '00201' //PROCESSO COTACAO COMPRAS - WF
		FOR X002 := 1 TO LEN(a00201)
			IF ALLTRIM(cHlNumCli) $ ALLTRIM(a00201[X002][1])
				xResult 	:= .T. 
				xRet007[7]  := cHlNumCli
			ENDIF
		NEXT X002
		
ENDCASE

xRet007[5] := xResult

Return xRet007