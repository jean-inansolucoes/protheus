#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M103XNNF ³ Autor ³ Lincoln Rossetto      ³ Data ³ 14/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ROTINA RESPONSÁVEL PELA VALIDAÇÃO DO NÚMERO DA NOTA FISCAL ³±±
±±³          ³ DE ENTRADA E RESPONSÁVEL POR VALIDAR CARACTERES ESPECIAIS. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COMPRAS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M103XNNF()
***********************
Local nZeros    := 0
Local nLenNumNF := Len( Alltrim( cNFiscal ) )
Local nTamSX3NF := TamSX3( "F1_DOC" )[ 1 ]
Local lRet      := .T.
Local cChar     := ""
Local nAux      := 0

If !Empty( Alltrim( cNFiscal ) )
	For nX := 1 To nLenNumNF
		
		cChar := SubStr( Alltrim( cNFiscal ), nX, 1 )
		nAux := Asc( cChar )
		
		If ( ( nAux < 48 ) .Or. ( nAux > 57 ) )
			If lRet
				lRet := .F.
				exit
			Endif
		Endif
		
	Next
	
	If lRet
		If nLenNumNF < nTamSX3NF
			nZeros   :=   nTamSX3NF - nLenNumNF
			cNFiscal := Replicate( "0", nZeros ) + Alltrim( cNFiscal )
		Endif
	Else
		U_LSSHWHLP( "Atenção !", "Não são aceitos caracteres especiais no Número da Nota Fiscal", "Verifique novamente o Número informado!" )
	Endif
	
Endif


Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M103XSNF ³ Autor ³ Lincoln Rossetto      ³ Data ³ 14/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ROTINA RESPONSÁVEL PELA VALIDAÇÃO DO NÚMERO DA NOTA FISCAL ³±±
±±³          ³ DE ENTRADA E RESPONSÁVEL POR VALIDAR CARACTERES ESPECIAIS. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COMPRAS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M103XSNF( )
*************************
Local lRet 		:= .T. 
Local cSerieAnt := NoAcento( AnsiToOem( ALLTRIM( cSerie ) ) )
                                                                                    
For nX := 1 To Len( cSerieAnt ) 
	If !LetterOrNum( SUBSTR( cSerieAnt, nX, 1 ) )
		lRet   := .F. 
		U_MFSHWHLP( "Atenção !",;
		            "Não são aceitos caracteres especiais na Série da Nota Fiscal",;
		            "Verifique novamente a Série informada!" )
		Exit
	EndIf
Next nX

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M103XNFB ³ Autor ³ Lincoln Rossetto     ³ Data ³ 14/01/11  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ROTINA RESPONSÁVEL POR VERIRICAR O NOME DO CLIENTE OU DO   ³±±
±±³          ³ FORNECEDOR E EXIBIR NO BROWSE DO DOCUMENTO DE ENTRADA.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COMPRAS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M103XNFB()
************************
Local cRet := ""
If SF1->F1_TIPO$"D/B"
   cRet := POSICIONE("SA1",1,XFILIAL("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME")
Else
   cRet := POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
Endif

Return( cRet ) 


User Function ArrNCC()
**********************
Local nNcc := 0
dBSelectArea("SE1")
SE1->( dBSetORder( 1 ) )
SE1->( dBGoTop() )

While !SE1->( Eof( ) )
	
	If alltrim( SE1->E1_TIPO ) == "NCC"
		dBSelectArea( "SA1" )
		SA1->( dBSetORder( 1 ) )
		SA1->( dBGoTop( ) )         
		
		If SA1->( dBSeek( xFilial( "SA1" ) + SE1->E1_CLIENTE + SE1->E1_LOJA ) )
			If !Empty( SA1->A1_VEND )
				RECLOCK( "SE1", .F. )
				SE1->E1_VEND1 := SA1->A1_VEND
				nNcc++
				SE1->( MsUnlock( ) )
			Endif
		Endif
		
	Endif
	
	SE1->( dBSkip( ) )
	
Enddo

MsgInfo( Transform( nNcc, "@E 999,999" ) )

Return( NIL )

/*********************************************/
/*Valida cadastro produtor de leite */

User Function VLPRODCOND()
**********************

Local cMV_ZLTCPP  := AllTRIM(GetMV("MV_ZLTCPP"))	   				// códigos das condições de pagamento parcelado

If M->A2_X_TIPO == "P" .And. M->A2_LOJA !="9999" 

	If !(M->A2_COND $ cMV_ZLTCPP)
 			
		ShowHelpDlg( "Atenção!!! Param. MV_ZLTCPP",;
			{ "Esta condição não pode ser utilizada para produtor de leite!" }, 5,;
			{ "Utilize as condições: " + Alltrim(cMV_ZLTCPP) + Chr(13) + Chr(10)  +;
			" Conforme programação do financeiro"}, 5)
	EndIf 

EndIF

Return .T.
