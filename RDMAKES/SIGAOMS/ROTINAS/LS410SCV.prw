User Function LS410SCV( pcVar )
*******************************
Local aArea   := SA1->( GetArea() )
Local nPosCod := aScan( aHeadFor, { |x| Alltrim( x[ 2 ] ) == "CV_FORMAPG" } )
Local nPosDes := aScan( aHeadFor, { |x| Alltrim( x[ 2 ] ) == "CV_DESCFOR" } )
Local nPosRat := aScan( aHeadFor, { |x| Alltrim( x[ 2 ] ) == "CV_RATFOR"  } )
Local lGo     := .F.

 If ( ISINCALLSTACK( "A410INCLUI" ) .OR. ISINCALLSTACK( "A410ALTERA" ) ) .And. M->C5_TIPO == "N"
	
	If ISINCALLSTACK( "A410INCLUI" )
		aColsFor := {}
		lGo      := .T.                 
		
	ElseIf ISINCALLSTACK( "A410ALTERA" )
		If Len( aColsFor ) == 0
			aColsFor := {}
			lGo      := .T.
		Endif
	Endif
	
	If lGo 
		dBSelectArea( "SA1" )
		SA1->( dBSetOrder( 1 ) )
		SA1->( dBGoTop( ) )
		If SA1->( dBSeek( xFilial( "SA1" ) + M->C5_CLIENTE + M->C5_LOJACLI ) )
			If !Empty( SA1->A1_X_FORMA )
				dBSelectArea( "SX5" )
				SX5->( dBSetOrder( 1 ) )
				SX5->( dBGoTop( ) )
				SX5->(dbSeek(xFilial('SX5')+'24'+SA1->A1_X_FORMA))
				
				aAdd( aColsFor, Array( Len( aHeadFor ) + 1 ) )
				aColsFor[ Len( aColsFor ) ][ nPosCod ] := SA1->A1_X_FORMA
				aColsFor[ Len( aColsFor ) ][ nPosDes ] := Alltrim( SX5->X5_DESCRI )
				aColsFor[ Len( aColsFor ) ][ nPosRat ] := 100
				
				aColsFor[ Len( aColsFor ) ][ Len( aHeadFor ) + 1 ] := .F.
			Endif
		Endif
	Endif
Endif 

/*
If INCLUI .And. M->C5_TIPO == "N"
		dBSelectArea( "SA1" )
		SA1->( dBSetOrder( 1 ) )
		SA1->( dBGoTop( ) )
		If SA1->( dBSeek( xFilial( "SA1" ) + M->C5_CLIENTE + M->C5_LOJACLI ) )
			If !Empty( SA1->A1_x_FORMA )
				dBSelectArea( "SX5" )
				SX5->( dBSetOrder( 1 ) )
				SX5->( dBGoTop( ) )
				SX5->(dbSeek(xFilial('SX5')+'24'+SA1->A1_X_FORMA))
				
				
				aColsFor[ Len( aColsFor ) ][ nPosCod ] := SA1->A1_X_FORMA
				aColsFor[ Len( aColsFor ) ][ nPosDes ] := Alltrim( SX5->X5_DESCRI )
				aColsFor[ Len( aColsFor ) ][ nPosRat ] := 100
				
				aColsFor[ Len( aColsFor ) ][ Len( aHeadFor ) + 1 ] := .F.
			Endif
		Endif
	
Endif
*/
RestArea( aArea )

Return( pcVar )
