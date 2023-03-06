#INCLUDE "TOPCONN.Ch"
#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M512AGRV    ºAutor ³Alexandre LonghinottiºData ³ 25/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ É chamado antes da exclusão do registro no SD2, na exclusãoº±±
±±º          ³ de Documentos de saída                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 */
User function M512AGRV()
************************
Local lRet := .F.
Local lBloq := GetMv("MV_BLQFRET") // habilita tratamento
Local cConhec := POSICIONE( "SA4",1, XFILIAL( "SA4" ) + M->F2_TRANSP, "SA4->A4_CONHEC")		   
Local cTransp := POSICIONE( "SA4",1, XFILIAL( "SA4" ) + M->F2_TRANSP, "SA4->A4_X_FORN")
Local cLoja   := POSICIONE( "SA4",1, XFILIAL( "SA4" ) + M->F2_TRANSP, "SA4->A4_X_LOJF")
Local _cMsg   := "Nao existe conhecimento de frete para esta Nota no sistema."+CHR(10)+ ;
					   "** ATENÇÃO ** Manutenção NÃO efetuada!"				   

If  lBloq .And. cConhec != "1"
	dBSelectArea( "SD1" )
	SD1->( dBSetOrder( 12 ) )
	SD1->( dBGoTop(  ) )
	SD1->( MsSeek( xFilial( "SF2" ) + SF2->F2_DOC + SF2->F2_SERIE ) )
	While !SD1->( Eof( ) ) .And. SD1->D1_X_NFSAI == SF2->F2_DOC .And. SD1->D1_X_SERRF == SF2->F2_SERIE .And. SD1->D1_FILIAL == xFilial( "SF2" )
		
		If cTransp != SD1->D1_FORNECE .OR. cLoja != SD1->D1_LOJA
			_cMsg 		:= "Transportador diferente do lançado no conhec. de frete."+CHR(10)+ ;
					       "** ATENÇÃO ** Manutenção NÃO efetuada!"
			lRet := .F.	
		Else
			lRet := .T.
		EndIf
		SD1->( dBSkip( ) )
	Enddo
	
	If !lRet .And. !Empty(Alltrim(M->F2_TRANSP))
		Alert(_cMsg)
		RECLOCK("SF2",.F.)
			SF2->F2_TRANSP := ""
			SF2->F2_VEICUL1 := ""
			SF2->F2_VEICUL2 := ""
			SF2->F2_VEICUL3 := ""
		SE2->(MSUNLOCK())
	EndIf

EndIf


Return()

