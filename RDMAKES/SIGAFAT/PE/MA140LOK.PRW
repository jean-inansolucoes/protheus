#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA140LOK    ºAutor ³Alexandre LonghinottiºData ³ 25/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obriga digitacao da nota de saida quando for conhecimento  º±±
±±º          ³ de frete				                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 */
User Function MT140LOK()

Local lRet:= ParamIXB[1]
Local aTotais:= ParamIXB[2]
Local aDesp:= ParamIXB[3] // Validações específicas a serem realizadas
Local cProdutos := GetMv("MV_PRDFRET") // Produtos utilizados na rotina de bloqueio
Local lBloq := GetMv("MV_BLQFRET") // habilita tratamento

If lBloq == .T.
	
	If ( ( AllTrim(cEspecie) $ "CTR/CTF/CTA" ) .AND. ( Empty(aCols[1][43]) .OR. Empty(aCols[1][44]) ) .And. ( Alltrim(aCols[1][2]) $ cProdutos ) )
		Alert("Os campos referentes a nota de saida devem ser preenchidos!")
		lRet:= .F.
	ElseIf ( AllTrim(cEspecie) $ "CTR/CTF/CTA" .And. ( Alltrim(aCols[1][2]) $ cProdutos ) )
		lRet := .F.
		dBSelectArea( "SF2" )
		SF2->( dBSetOrder( 1 ) )
		SF2->( dBGoTop(  ) )
		SF2->( MsSeek( xFilial( "SF2" ) + aCols[1][43] + aCols[1][44] ) )
		While !SF2->( Eof( ) ) .And. SF2->F2_DOC == aCols[1][43] .And. SF2->F2_SERIE == aCols[1][44] .And. SF2->F2_FILIAL == xFilial( "SF1" )
			lRet := .T.
			SF2->( dBSkip( ) )
		Enddo
		
		dBSelectArea( "SD1" )
		SD1->( dBSetOrder( 12 ) )
		SD1->( dBGoTop(  ) )
		SD1->( MsSeek( xFilial( "SD1" ) + aCols[1][43] + aCols[1][44] ) )
		While !SF2->( Eof( ) ) .And. SD1->D1_X_NFSAI == aCols[1][43] .And. SD1->D1_X_SERRF == aCols[1][44] .And. SD1->D1_FILIAL == xFilial( "SD1" )
			lRet := .F.
			SD1->( dBSkip( ) )
		Enddo
		
		If !lRet
			Alert("A NF de Saida infomada nao existe ou ja esta associada a outro documento!")
		EndIf
	EndIf
EndIf
Return lRet
