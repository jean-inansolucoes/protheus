User Function MT103IPC()
*************************
Local nItem := PARAMIXB[1]
Local nPosA := aScan( aHeader,{|x| Trim( x[ 2 ] ) == "D1_COD" } ) 
Local nPosB := aScan( aHeader,{|x| Trim( x[ 2 ] ) == "D1_X_DESCP" } ) 

aCols[ nItem ][ nPosB ] := Posicione( "SB1", 1, xFilial( "SB1" ) + aCols[ nItem ][ nPosA ], "SB1->B1_DESC" )

Return( NIL )
