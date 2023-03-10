#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? LSCLIFOR ?Autor  ? Lincoln Rossetto   ? Data ?  16/10/08   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Programa responsavel por trabalhar a questao do codigo de  ???
???          ? cliente/fornecedor validando por CNPJ/CPF e informando au- ???
???          ? tomaticamente o codigo da loja                             ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Rotinas de cadastro de clientes/fornecedor.                ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function LSCLIFOR( pcOrigem, pcPessoa, pcCgc, pcRep )
***************************************************
Local lShare    := .T.
Local lReadOnly := .F.
Local aArea     := iif( pcOrigem == "SA1", SA1->( GetArea() ), SA2->( GetArea() ) )
Local hEnter    := Chr( 13 )
Local cAlias    := GetNextAlias()
Local cAlias2   := GetNextAlias( )
Local lExterior := .F.
Local aStru     := { }
Local cCod      := ""
Local cTabTMP   := ""
Local cQuery    := ""
Local cRetLoja  := ""
Local oModelo	:= FWModelActive()

Private cPathExtras := U_LSALXDIR( "SIGAOMS", "LSCLIFOR" )

Default pcOrigem := ""
Default pcPessoa := ""
Default pcCgc    := ""

If  Empty( pcOrigem ) .Or. ( !pcOrigem $ "SA1#SA2" )
	Aviso("Aten??o","Par?metros informados insuficentes ou inv?lidos ! ['Origem']" ,{ "Ok" }, 2 )
	Return( cCod )
Endif

If pcOrigem == "SA1"
	lExterior := iif( M->A1_EST == "EX", .T., .F. )
	
	If !lExterior
		cCod       := M->A1_COD
		cRetLoja   := M->A1_LOJA
		
		If Empty( pcCgc )
	        Aviso("Aten??o","Par?metros informados insuficentes ou inv?lidos ! ['CPF/CNPJ']" ,{ "Ok" }, 2 )
	        Return( cCod )
        Endif

		If pcPessoa == "F"
			dBSelectArea( "SA1" )
			SA1->( dBSetOrder( 1 ) )
			SA1->( dBGoTop( ) )
			
			If SA1->( MsSeek( xFilial( "SA1" ) + SUBSTR( ALLTRIM( pcCgc ), 1, 9 ) ) )
		        aStru   := { { "A1_COD" , "C", TAMSX3( "A1_COD"  )[ 1 ], TAMSX3( "A1_COD"  )[ 2 ] },;
		                     { "A1_LOJA", "C" ,TAMSX3( "A1_LOJA" )[ 1 ], TAMSX3( "A1_LOJA" )[ 2 ] } }
		        
		        cTabTMP := CriaTrab( aStru, .T. )
				
				cQuery  := "  SELECT SA1.A1_COD, SA1.A1_LOJA " + hEnter
				cQuery  += "    FROM " + RetSqlName( "SA1" ) + " SA1" + hEnter
				cQuery  += "   WHERE SA1.D_E_L_E_T_ <> '*'" +  hEnter
				cQuery  += "   	 AND SA1.A1_LOJA <> '9999'" +  hEnter
				cQuery  += "     AND SUBSTRING(SA1.A1_CGC,1,9) = '" + SUBSTR( ALLTRIM( pcCgc ),1,9 ) + "'" + hEnter
				cQuery  += "     AND SA1.A1_FILIAL             = '" + xFilial( "SA1" ) + "'"  + hEnter
				cQuery  += "ORDER BY SA1.A1_LOJA" + hEnter
				
				MemoWrite( cPathExtras + "LSCLIFOR.SQL", cQuery )
				
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
				
				cCod     := SUBSTR( ALLTRIM( pcCgc ),1,9 )
				cRetLoja := ( cAlias )->A1_LOJA
				cRetLoja := Soma1( cRetLoja )

				
				Aviso( "Aten??o", "Existe cliente com outras lojas cadastrado com este CPF." + chr( 13 ) + "O codigo do cliente ser? " + cCod + " com a loja " +  cRetLoja,{"Ok"},2)
				ROLLBACKSXE()
			Else
				cCod     := SUBSTR( ALLTRIM( pcCgc ),1,9 )		
				cRetLoja := StrZero( 1, TamSX3( "A1_LOJA" )[ 1 ] )
			Endif
			
		ElseIf pcPessoa == "J"
			dBSelectArea( "SA1" )
			SA1->( dBSetOrder( 3 ) )
			SA1->( dBGoTop( ) )
			
			If SA1->( MsSeek( xFilial( "SA1" ) + pcCgc ) )
				Aviso( "Aten??o", "Existe cliente com este CNPJ, impossivel prosseguir !", { "Ok" },2)
				Return( cCod )
			Else
				cCod      := SUBSTR( ALLTRIM( pcCgc ),1,8 )
				cRetLoja  := SUBSTR( pcCgc, 9, 4 )
			Endif
			
		Endif
		
	Else
	   ROLLBACKSXE()
       cQuery := "SELECT MAX( SA1.A1_COD ) A1_MAX_COD" + hEnter
       cQuery += "  FROM " + RetSqlName( "SA1" ) + " SA1 " + hEnter
       cQuery += " WHERE SA1.D_E_L_E_T_   <> '*'" + hEnter
       cQuery += "   AND SA1.A1_LOJA <> '9999'" +  hEnter
       cQuery += "   AND SA1.A1_COD LIKE 'EX%'"   + hEnter
       cQuery += "   AND SA1.A1_FILIAL     = '" + xFilial( "SA1" ) +"'" + hEnter

       MemoWrite( cPathExtras + "LSCLIFOR2.SQL", cQuery )
				
       If Select( cAlias2 ) > 0
	       ( cAlias2 )->( dBclosearea( ) )
	       Ferase( lower( cAlias2 ) + GetDBExtension( ) )
	       Ferase( lower( cAlias2 ) + OrdBagExt( ) )
       Endif
				
	   dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAlias2, lShare, lReadOnly )
				
	   cCod     := "EX" + StrZero( Val( SubStr( ( cAlias2 )->A1_MAX_COD, 3, Len( ( cAlias2 )->A1_MAX_COD ) ) ) + 1, TamSX3( "A1_COD" )[ 1 ] - 2 )
	   cRetLoja := StrZero( 1, TamSX3( "A1_LOJA" )[ 1 ]  )
	    	
	Endif
	If Alltrim(FunName()) == "CRMA980"
		oModelSA1 := oModelo:GetModel("SA1MASTER") 
	EndIf
ElseIf pcOrigem == "SA2"
	lExterior := iif( M->A2_EST == "EX", .T., .F. )
	
	If !lExterior
		cCod       := M->A2_COD
		cRetLoja   := M->A2_LOJA
		If pcPessoa == "F"
			dBSelectArea( "SA2" )
			SA2->( dBSetOrder( 1 ) )
			SA2->( dBGoTop( ) )
			
			If SA2->( MsSeek( xFilial( "SA2" ) + SUBSTR( ALLTRIM( pcCgc ), 1, 9 ) ) )
		        aStru   := { { "A2_COD" , "C", TAMSX3( "A2_COD"  )[ 1 ], TAMSX3( "A2_COD"  )[ 2 ] },;
		                     { "A2_LOJA", "C" ,TAMSX3( "A2_LOJA" )[ 1 ], TAMSX3( "A2_LOJA" )[ 2 ] } }
		        
		        cTabTMP := CriaTrab( aStru, .T. )
				
				cQuery  := "  SELECT SA2.A2_COD, SA2.A2_LOJA " + hEnter
				cQuery  += "    FROM " + RetSqlName( "SA2" ) + " SA2" + hEnter
				cQuery  += "   	WHERE SA2.D_E_L_E_T_ <> '*'" +  hEnter
				cQuery  += "   	 AND SA2.A2_LOJA <> '9999'" +  hEnter
				cQuery  += "     AND SUBSTRING(SA2.A2_CGC,1,9) = '" + SUBSTR( ALLTRIM( pcCgc ),1,9 ) + "'" + hEnter
			   	cQuery  += "     AND SA2.A2_FILIAL             = '" + xFilial( "SA2" ) + "'"  + hEnter
				cQuery  += "ORDER BY SA2.A2_LOJA" + hEnter

				MemoWrite( cPathExtras + "LSCLIFOR.SQL", cQuery )
				
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
				
				cCod     := SUBSTR( ALLTRIM( pcCgc ),1,9 )
				cRetLoja := ( cAlias )->A2_LOJA
				cRetLoja := Soma1( cRetLoja )
				
				Aviso( "Aten??o", "Existe fornecedor com outras lojas cadastrado com este CPF." + chr( 13 ) + "O codigo do cliente ser? " + cCod + " com a loja " +  cRetLoja,{"Ok"},2)
				ROLLBACKSXE()
				
			Else
				cCod     := SUBSTR( ALLTRIM( pcCgc ),1,9 )		
				cRetLoja := StrZero( 1, TamSX3( "A2_LOJA" )[ 1 ] )
			Endif
			
		ElseIf pcPessoa == "J"
			dBSelectArea( "SA2" )
			SA2->( dBSetOrder( 3 ) )
			SA2->( dBGoTop( ) )
			
			If SA2->( MsSeek( xFilial( "SA2" ) + pcCgc ) ) .AND. Alltrim(pcRep) != "D"
				Aviso( "Aten??o", "Existe fornecedor com este CNPJ, impossivel prosseguir !", { "Ok" },2)
				Return( cCod )
			ElseiF Alltrim(pcRep) == "D"
				cCod      := SUBSTR( ALLTRIM( pcCgc ),1,8 )
				cRetLoja  := "9" + SUBSTR( pcCgc, 10, 3 ) 
			Else
				cCod      := SUBSTR( ALLTRIM( pcCgc ),1,8 )
				cRetLoja  := SUBSTR( pcCgc, 9, 4 ) 
			Endif
			
		Endif
	Else
	   ROLLBACKSXE()
       cQuery := "SELECT MAX( SA2.A2_COD ) A2_MAX_COD" + hEnter
       cQuery += "  FROM " + RetSqlName( "SA2" ) + " SA2 " + hEnter
       cQuery += " WHERE SA2.D_E_L_E_T_   <> '*'" + hEnter
	   cQuery += "   AND SA2.A2_LOJA <> '9999'" +  hEnter
       cQuery += "   AND SA2.A2_COD LIKE 'EX%'"   + hEnter
       cQuery += "   AND SA2.A2_FILIAL     = '" + xFilial( "SA2" ) +"'" + hEnter

       MemoWrite( cPathExtras + "LSCLIFOR2.SQL", cQuery )
				
       If Select( cAlias2 ) > 0
	      ( cAlias2 )->( dBclosearea( ) )
	      Ferase( lower( cAlias2 ) + GetDBExtension( ) )
	      Ferase( lower( cAlias2 ) + OrdBagExt( ) )
       Endif
				
	   dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery ) ),cAlias2, lShare, lReadOnly )
				
	   cCod     := "EX" + StrZero( Val( SubStr( ( cAlias2 )->A2_MAX_COD, 3, Len( ( cAlias2 )->A2_MAX_COD ) ) ) + 1, TamSX3( "A2_COD" )[ 1 ] - 2 )
	   cRetLoja := StrZero( 1, TamSX3( "A2_LOJA" )[ 1 ]  )
	Endif  
	
 	oModelSA2 := oModelo:GetModel("SA2MASTER")
	
Endif        
If Alltrim(FunName()) == "MATA030"
	iif( pcOrigem == "SA1",  M->A1_LOJA := cRetLoja, oModelSA2:LoadValue("A2_LOJA", cRetLoja))
else
	iif( pcOrigem == "SA1",  oModelSA1:LoadValue("A1_LOJA", cRetLoja), oModelSA2:LoadValue("A2_LOJA", cRetLoja))
EndIf
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

//???????????????????????????????????????????Ŀ
//?Restaura integridade das tabelas envolvidas?
//?????????????????????????????????????????????
Restarea( aArea )

Return( cCod )
