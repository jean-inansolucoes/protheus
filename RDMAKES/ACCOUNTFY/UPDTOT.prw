#INCLUDE "protheus.ch"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDTOT
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDTOT( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := "usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça um"
Local   cDesc4    := "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
Local   cDesc5    := "ocorram eventuais falhas, esse backup possa ser restaurado."
Local   cDesc6    := ""
Local   cDesc7    := ""
Local   cMsg      := ""
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

If lAuto
	lOk := .T.
Else
	FormBatch(  cTitulo,  aSay,  aButton )
EndIf

If lOk

	If GetVersao(.F.) < "12" 
		cMsg := "Este update NÃO PODE ser executado neste Ambiente." + CRLF + CRLF + ;
				"Os arquivos de dicionários se encontram em formato ISAM (" + GetDbExtension() + ") e este update está preparado " + ;
				"para atualizar apenas ambientes com dicionários no Banco de Dados."

		If lAuto
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( cMsg )
			ConOut( DToC(Date()) + "|" + Time() + cMsg )
		Else
			MsgInfo( cMsg )
		EndIf

		Return NIL
	EndIf

	If lAuto
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else

		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDTOT" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDTOT" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Realizada." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualização não Realizada." )

		EndIf

	Else
		Final( "Atualização não Realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( "SM0" )
	dbGoTop()

	While !SM0->( EOF() )
		// Só adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	SM0->( dbCloseArea() )

	If lOpen

		For nI := 1 To Len( aRecnoSM0 )

			If !( lOpen := MyOpenSm0(.F.) )
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versão.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estação............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )

			//------------------------------------
			// Atualiza o dicionário SX2
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()

			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3()

			//------------------------------------
			// Atualiza o dicionário SIX
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()

			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

			// Alteração física dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//------------------------------------
			// Atualiza o dicionário SX6
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()

			//------------------------------------
			// Atualiza o dicionário SXB
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB()

			//------------------------------------
			// Atualiza os helps
			//------------------------------------
			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuHlp()

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX2
Função de processamento da gravação do SX2 - Arquivos

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX2()
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cCpoUpd   := "X2_ROTINA /X2_UNICO  /X2_DISPLAY/X2_SYSOBJ /X2_USROBJ /X2_POSLGT /"
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela ZKT
//
aAdd( aSX2, { ;
	'ZKT'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZKT'+cEmpr																, ; //X2_ARQUIVO
	'Cabeçalho Depara ACC'													, ; //X2_NOME
	'Cabeçalho Depara ACC'													, ; //X2_NOMESPA
	'Cabeçalho Depara ACC'													, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZKU
//
aAdd( aSX2, { ;
	'ZKU'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZKU'+cEmpr																, ; //X2_ARQUIVO
	'Itens Depara ACC'														, ; //X2_NOME
	'Itens Depara ACC'														, ; //X2_NOMESPA
	'Itens Depara ACC'														, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZKV
//
aAdd( aSX2, { ;
	'ZKV'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZKV'+cEmpr																, ; //X2_ARQUIVO
	'Log de integração'														, ; //X2_NOME
	'Log de integração'														, ; //X2_NOMESPA
	'Log de integração'														, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZKW
//
aAdd( aSX2, { ;
	'ZKW'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZKW'+cEmpr																, ; //X2_ARQUIVO
	'Categorias de Etiquetas'		      									, ; //X2_NOME
	'Categorias de Etiquetas'										    	, ; //X2_NOMESPA
	'Categorias de Etiquetas'			            						, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZKX
//
aAdd( aSX2, { ;
	'ZKX'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZKX'+cEmpr																, ; //X2_ARQUIVO
	'Tabela de Conexão'														, ; //X2_NOME
	'Tabela de Conexão'														, ; //X2_NOMESPA
	'Tabela de Conexão'														, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZKY
//
aAdd( aSX2, { ;
	'ZKY'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZKY'+cEmpr																, ; //X2_ARQUIVO
	'Tabela de Mensagem Trafegada'											, ; //X2_NOME
	'Tabela de Mensagem Trafegada'											, ; //X2_NOMESPA
	'Tabela de Mensagem Trafegada'											, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela ZKZ
//
aAdd( aSX2, { ;
	'ZKZ'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZKZ'+cEmpr																, ; //X2_ARQUIVO
	'Cadastro de Etiquetas'	     	      									, ; //X2_NOME
	'Cadastro de Etiquetas'		     								    	, ; //X2_NOMESPA
	'Cadastro de Etiquetas'		    	            						, ; //X2_NOMEENG
	'E'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'E'																		, ; //X2_MODOEMP
	'E'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			AutoGrLog( "Foi incluída a tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf
			EndIf
		Next nJ
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			RecLock( "SX2", .F. )
			SX2->X2_UNICO := aSX2[nI][12]
			MsUnlock()

			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
			EndIf

			AutoGrLog( "Foi alterada a chave única da tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .F. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If PadR( aEstrut[nJ], 10 ) $ cCpoUpd
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf

			EndIf
		Next nJ
		MsUnLock()

	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cSeqAtu   := ""
Local nI        := 0
Local nJ        := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


//
// Campos Tabela ZKT
//
aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZKT_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'XXXXXX X'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZKT_CODIGO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Codigo'																, ; //X3_TITULO
	'Codigo'																, ; //X3_TITSPA
	'Codigo'																, ; //X3_TITENG
	'Codigo'																, ; //X3_DESCRIC
	'Codigo'																, ; //X3_DESCSPA
	'Codigo'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'U_ZKTNUM()'															, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZKT_NOME'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome'																	, ; //X3_TITULO
	'Nome'																	, ; //X3_TITSPA
	'Nome'																	, ; //X3_TITENG
	'Nome'																	, ; //X3_DESCRIC
	'Nome'																	, ; //X3_DESCSPA
	'Nome'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZKT_DESC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descricao'																, ; //X3_TITULO
	'Descricao'																, ; //X3_TITSPA
	'Descricao'																, ; //X3_TITENG
	'Descricao'																, ; //X3_DESCRIC
	'Descricao'																, ; //X3_DESCSPA
	'Descricao'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZKT_PATH'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Path'																	, ; //X3_TITULO
	'Path'																	, ; //X3_TITSPA
	'Path'																	, ; //X3_TITENG
	'Path'																	, ; //X3_DESCRIC
	'Path'																	, ; //X3_DESCSPA
	'Path'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZKT_METODO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Metodo'																, ; //X3_TITULO
	'Metodo'																, ; //X3_TITSPA
	'Metodo'																, ; //X3_TITENG
	'Metodo'																, ; //X3_DESCRIC
	'Metodo'																, ; //X3_DESCSPA
	'Metodo'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZKT_DATA'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Criacao'															, ; //X3_TITULO
	'Dt Criacao'															, ; //X3_TITSPA
	'Dt Criacao'															, ; //X3_TITENG
	'Data de Criacao'														, ; //X3_DESCRIC
	'Data de Criacao'														, ; //X3_DESCSPA
	'Data de Criacao'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'DDATABASE'																, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZKT_NOMTEM'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	35																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Nome Temp'																, ; //X3_TITULO
	'Nome Temp'																, ; //X3_TITSPA
	'Nome Temp'																, ; //X3_TITENG
	'Nome Tabela Temporaria'												, ; //X3_DESCRIC
	'Nome Tabela Temporaria'												, ; //X3_DESCSPA
	'Nome Tabela Temporaria'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZKT_LIMITE'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Limite Json'															, ; //X3_TITULO
	'Limite Json'															, ; //X3_TITSPA
	'Limite Json'															, ; //X3_TITENG
	'Limite de registro json'												, ; //X3_DESCRIC
	'Limite de registro json'												, ; //X3_DESCSPA
	'Limite de registro json'												, ; //X3_DESCENG
	'@E 99999'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKT'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZKT_OBSERV'																, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Observacao'															, ; //X3_TITULO
	'Observacao'															, ; //X3_TITSPA
	'Observacao'															, ; //X3_TITENG
	'Observacao'															, ; //X3_DESCRIC
	'Observacao'															, ; //X3_DESCSPA
	'Observacao'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZKU
//
aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZKU_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'XXXXXX X'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZKU_SEQ'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Sequencial'															, ; //X3_TITULO
	'Sequencial'															, ; //X3_TITSPA
	'Sequencial'															, ; //X3_TITENG
	'Sequencial'															, ; //X3_DESCRIC
	'Sequencial'															, ; //X3_DESCSPA
	'Sequencial'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZKU_CODIGO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Codigo'																, ; //X3_TITULO
	'Codigo'																, ; //X3_TITSPA
	'Codigo'																, ; //X3_TITENG
	'Codigo'																, ; //X3_DESCRIC
	'Codigo'																, ; //X3_DESCSPA
	'Codigo'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZKU_CPPROT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cam Protheus'															, ; //X3_TITULO
	'Cam Protheus'															, ; //X3_TITSPA
	'Cam Protheus'															, ; //X3_TITENG
	'Campo Protheus'														, ; //X3_DESCRIC
	'Campo Protheus'														, ; //X3_DESCSPA
	'Campo Protheus'														, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZKU_CPINTE'		 													, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cp Integraca'															, ; //X3_TITULO
	'Cp Integraca'															, ; //X3_TITSPA
	'Cp Integraca'															, ; //X3_TITENG
	'Campo Integracao'														, ; //X3_DESCRIC
	'Campo Integracao'														, ; //X3_DESCSPA
	'Campo Integracao'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZKU_TIPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo'																	, ; //X3_TITULO
	'Tipo'																	, ; //X3_TITSPA
	'Tipo'																	, ; //X3_TITENG
	'Tipo'																	, ; //X3_DESCRIC
	'Tipo'																	, ; //X3_DESCSPA
	'Tipo'																	, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZKU_TABELA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tabela'																, ; //X3_TITULO
	'Tabela'																, ; //X3_TITSPA
	'Tabela'																, ; //X3_TITENG
	'Tabela'																, ; //X3_DESCRIC
	'Tabela'																, ; //X3_DESCSPA
	'Tabela'																, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZKU_DATA'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Criacao'															, ; //X3_TITULO
	'Dt Criacao'															, ; //X3_TITSPA
	'Dt Criacao'															, ; //X3_TITENG
	'Data Criacao'															, ; //X3_DESCRIC
	'Data Criacao'															, ; //X3_DESCSPA
	'Data Criacao'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'DDATABASE'																, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	'.F.'																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZKU_LAYOUT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Layout'																, ; //X3_TITULO
	'Layout'																, ; //X3_TITSPA
	'Layout'																, ; //X3_TITENG
	'Layout'																, ; //X3_DESCRIC
	'Layout'																, ; //X3_DESCSPA
	'Layout'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''  																	, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME	

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZKU_ALIAS'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	11																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Apelido'	     	    												, ; //X3_TITULO
	'Apelido'																, ; //X3_TITSPA
	'Apelido'																, ; //X3_TITENG
	'Apelido'																, ; //X3_DESCRIC
	'Apelido'																, ; //X3_DESCSPA
	'Apelido'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''	    																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKU'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZKU_MASCAR'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1	 																	, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Masc contabi'	     	    											, ; //X3_TITULO
	'Masc contabi'															, ; //X3_TITSPA
	'Masc contabi'															, ; //X3_TITENG
	'Masc contabi'															, ; //X3_DESCRIC
	'Masc contabi'															, ; //X3_DESCSPA
	'Masc contabi'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	'€'																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'S=Sim;N=Não'   														, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''	    																, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME			

//
// Campos Tabela ZKV
//
aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZKV_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	''																		, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'þÀ'																	, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZKV_ID'																	, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'ID'																	, ; //X3_TITULO
	'ID'																	, ; //X3_TITSPA
	'ID'																	, ; //X3_TITENG
	'Identificador'															, ; //X3_DESCRIC
	'Identificador'															, ; //X3_DESCSPA
	'Identificador'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZKV_LAYOUT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Layout'																, ; //X3_TITULO
	'Layout'																, ; //X3_TITSPA
	'Layout'																, ; //X3_TITENG
	'Layout'																, ; //X3_DESCRIC
	'Layout'																, ; //X3_DESCSPA
	'Layout'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZKV_METODO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Metodo'																, ; //X3_TITULO
	'Metodo'																, ; //X3_TITSPA
	'Metodo'																, ; //X3_TITENG
	'Metodo'																, ; //X3_DESCRIC
	'Metodo'																, ; //X3_DESCSPA
	'Metodo'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZKV_ETAPA'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Etapa'																	, ; //X3_TITULO
	'Etapa'																	, ; //X3_TITSPA
	'Etapa'																	, ; //X3_TITENG
	'Etapa'																	, ; //X3_DESCRIC
	'Etapa'																	, ; //X3_DESCSPA
	'Etapa'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'1=Requisitando;2=Preparando dados;3=Enviando;4=Processando;5=Concluído'	, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZKV_DATAIN'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt Ini Etap1'															, ; //X3_TITULO
	'Dt Ini Etap1'															, ; //X3_TITSPA
	'Dt Ini Etap1'															, ; //X3_TITENG
	'Dt Inicial Etapa 1'													, ; //X3_DESCRIC
	'Dt Inicial Etapa 1'													, ; //X3_DESCSPA
	'Dt Inicial Etapa 1'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZKV_HORAIN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Ini Etap1'															, ; //X3_TITULO
	'Hr Ini Etap1'															, ; //X3_TITSPA
	'Hr Ini Etap1'															, ; //X3_TITENG
	'Hr Inicial Etapa 1'													, ; //X3_DESCRIC
	'Hr Inicial Etapa 1'													, ; //X3_DESCSPA
	'Hr Inicial Etapa 1'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZKV_DATAFI'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Fin Etap1'															, ; //X3_TITULO
	'DT Fin Etap1'															, ; //X3_TITSPA
	'DT Fin Etap1'															, ; //X3_TITENG
	'Dt Final Etapa 1'														, ; //X3_DESCRIC
	'Dt Final Etapa 1'														, ; //X3_DESCSPA
	'Dt Final Etapa 1'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZKV_HORAFI'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Fin Etap1'															, ; //X3_TITULO
	'Hr Fin Etap1'															, ; //X3_TITSPA
	'Hr Fin Etap1'															, ; //X3_TITENG
	'Hr Final Etapa 1'														, ; //X3_DESCRIC
	'Hr Final Etapa 1'														, ; //X3_DESCSPA
	'Hr Final Etapa 1'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZKV_DTINI2'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Ini Etap2'															, ; //X3_TITULO
	'DT Ini Etap2'															, ; //X3_TITSPA
	'DT Ini Etap2'															, ; //X3_TITENG
	'Dt Inicial Etapa 2'													, ; //X3_DESCRIC
	'Dt Inicial Etapa 2'													, ; //X3_DESCSPA
	'Dt Inicial Etapa 2'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZKV_HRINI2'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Ini Etap2'															, ; //X3_TITULO
	'Hr Ini Etap2'															, ; //X3_TITSPA
	'Hr Ini Etap2'															, ; //X3_TITENG
	'Hr Inicial Etapa 2'													, ; //X3_DESCRIC
	'Hr Inicial Etapa 2'													, ; //X3_DESCSPA
	'Hr Inicial Etapa 2'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'ZKV_DTFIN2'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Fin Etap2'															, ; //X3_TITULO
	'DT Fin Etap2'															, ; //X3_TITSPA
	'DT Fin Etap2'															, ; //X3_TITENG
	'Dt Final Etapa 2'														, ; //X3_DESCRIC
	'Dt Final Etapa 2'														, ; //X3_DESCSPA
	'Dt Final Etapa 2'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'ZKV_HRFIN2'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Fin Etap2'															, ; //X3_TITULO
	'Hr Fin Etap2'															, ; //X3_TITSPA
	'Hr Fin Etap2'															, ; //X3_TITENG
	'Hr Final Etapa 2'														, ; //X3_DESCRIC
	'Hr Final Etapa 2'														, ; //X3_DESCSPA
	'Hr Final Etapa 2'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'ZKV_DTINI3'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Ini Etap3'															, ; //X3_TITULO
	'DT Ini Etap3'															, ; //X3_TITSPA
	'DT Ini Etap3'															, ; //X3_TITENG
	'Dt Inicial Etapa 3'													, ; //X3_DESCRIC
	'Dt Inicial Etapa 3'													, ; //X3_DESCSPA
	'Dt Inicial Etapa 3'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'ZKV_HRINI3'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Ini Etap3'															, ; //X3_TITULO
	'Hr Ini Etap3'															, ; //X3_TITSPA
	'Hr Ini Etap3'															, ; //X3_TITENG
	'Hr Inicial Etapa 3'													, ; //X3_DESCRIC
	'Hr Inicial Etapa 3'													, ; //X3_DESCSPA
	'Hr Inicial Etapa 3'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'ZKV_DTFIN3'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Fin Etap3'															, ; //X3_TITULO
	'DT Fin Etap3'															, ; //X3_TITSPA
	'DT Fin Etap3'															, ; //X3_TITENG
	'Dt Final Etapa 3'														, ; //X3_DESCRIC
	'Dt Final Etapa 3'														, ; //X3_DESCSPA
	'Dt Final Etapa 3'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'ZKV_HRFIN3'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Fin Etap3'															, ; //X3_TITULO
	'Hr Fin Etap3'															, ; //X3_TITSPA
	'Hr Fin Etap3'															, ; //X3_TITENG
	'Hr Final Etapa 3'														, ; //X3_DESCRIC
	'Hr Final Etapa 3'														, ; //X3_DESCSPA
	'Hr Final Etapa 3'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'ZKV_DTINI4'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Ini Etap4'															, ; //X3_TITULO
	'DT Ini Etap4'															, ; //X3_TITSPA
	'DT Ini Etap4'															, ; //X3_TITENG
	'Dt Inicial Etapa 4'													, ; //X3_DESCRIC
	'Dt Inicial Etapa 4'													, ; //X3_DESCSPA
	'Dt Inicial Etapa 4'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'ZKV_HRINI4'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Ini Etap4'															, ; //X3_TITULO
	'Hr Ini Etap4'															, ; //X3_TITSPA
	'Hr Ini Etap4'															, ; //X3_TITENG
	'Hr Inicial Etapa 4'													, ; //X3_DESCRIC
	'Hr Inicial Etapa 4'													, ; //X3_DESCSPA
	'Hr Inicial Etapa 4'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'ZKV_DTFIN4'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Fin Etap4'															, ; //X3_TITULO
	'DT Fin Etap4'															, ; //X3_TITSPA
	'DT Fin Etap4'															, ; //X3_TITENG
	'Dt Final Etapa 4'														, ; //X3_DESCRIC
	'Dt Final Etapa 4'														, ; //X3_DESCSPA
	'Dt Final Etapa 4'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'ZKV_HRFIN4'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Fin Etap4'															, ; //X3_TITULO
	'Hr Fin Etap4'															, ; //X3_TITSPA
	'Hr Fin Etap4'															, ; //X3_TITENG
	'Hr Final Etapa 4'														, ; //X3_DESCRIC
	'Hr Final Etapa 4'														, ; //X3_DESCSPA
	'Hr Final Etapa 4'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'ZKV_DTINI5'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Ini Etap5'															, ; //X3_TITULO
	'DT Ini Etap5'															, ; //X3_TITSPA
	'DT Ini Etap5'															, ; //X3_TITENG
	'Dt Inicial Etapa 5'													, ; //X3_DESCRIC
	'Dt Inicial Etapa 5'													, ; //X3_DESCSPA
	'Dt Inicial Etapa 5'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'ZKV_HRINI5'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Ini Etap5'															, ; //X3_TITULO
	'Hr Ini Etap5'															, ; //X3_TITSPA
	'Hr Ini Etap5'															, ; //X3_TITENG
	'Hr Inicial Etapa 5'													, ; //X3_DESCRIC
	'Hr Inicial Etapa 5'													, ; //X3_DESCSPA
	'Hr Inicial Etapa 5'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'ZKV_DTFIN5'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'DT Fin Etap5'															, ; //X3_TITULO
	'DT Fin Etap5'															, ; //X3_TITSPA
	'DT Fin Etap5'															, ; //X3_TITENG
	'Dt Final Etapa 5'														, ; //X3_DESCRIC
	'Dt Final Etapa 5'														, ; //X3_DESCSPA
	'Dt Final Etapa 5'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'ZKV_HRFIN5'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hr Fin Etap5'															, ; //X3_TITULO
	'Hr Fin Etap5'															, ; //X3_TITSPA
	'Hr Fin Etap5'															, ; //X3_TITENG
	'Hr Final Etapa 5'														, ; //X3_DESCRIC
	'Hr Final Etapa 5'														, ; //X3_DESCSPA
	'Hr Final Etapa 5'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'ZKV_USER'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Usuario'																, ; //X3_TITULO
	'Usuario'																, ; //X3_TITSPA
	'Usuario'																, ; //X3_TITENG
	'Usuario'																, ; //X3_DESCRIC
	'Usuario'																, ; //X3_DESCSPA
	'Usuario'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'ZKV_LOG'																, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Log'																	, ; //X3_TITULO
	'Log'																	, ; //X3_TITSPA
	'Log'																	, ; //X3_TITENG
	'Log'																	, ; //X3_DESCRIC
	'Log'																	, ; //X3_DESCSPA
	'Log'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'ZKV_MSGTRA'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Msg Trafegad'															, ; //X3_TITULO
	'Msg Trafegad'															, ; //X3_TITSPA
	'Msg Trafegad'															, ; //X3_TITENG
	'Mensagem Trafegada'													, ; //X3_DESCRIC
	'Mensagem Trafegada'													, ; //X3_DESCSPA
	'Mensagem Trafegada'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'ZKV_RECINI'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Rec Inicial'															, ; //X3_TITULO
	'Rec Inicial'															, ; //X3_TITSPA
	'Rec Inicial'															, ; //X3_TITENG
	'Recno Inicial'															, ; //X3_DESCRIC
	'Recno Inicial'															, ; //X3_DESCSPA
	'Recno Inicial'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'ZKV_RECFIN'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Recno Final'															, ; //X3_TITULO
	'Recno Final'															, ; //X3_TITSPA
	'Recno Final'															, ; //X3_TITENG
	'Recno Final'															, ; //X3_DESCRIC
	'Recno Final'															, ; //X3_DESCSPA
	'Recno Final'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'ZKV_QTDREG'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	15																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Qtd Registro'															, ; //X3_TITULO
	'Qtd Registro'															, ; //X3_TITSPA
	'Qtd Registro'															, ; //X3_TITENG
	'Qtd Registro'															, ; //X3_DESCRIC
	'Qtd Registro'															, ; //X3_DESCSPA
	'Qtd Registro'															, ; //X3_DESCENG
	'@E 999,999,999,999,999'												, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'32'																	, ; //X3_ORDEM
	'ZKV_NUMPAR'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Num Partes'															, ; //X3_TITULO
	'Num Partes'															, ; //X3_TITSPA
	'Num Partes'															, ; //X3_TITENG
	'Numero de Partes'														, ; //X3_DESCRIC
	'Numero de Partes'														, ; //X3_DESCSPA
	'Numero de Partes'														, ; //X3_DESCENG
	'@E 9999999'															, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'33'																	, ; //X3_ORDEM
	'ZKV_IDPART'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	50																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Id Ledger'																, ; //X3_TITULO
	'Id Ledger'																, ; //X3_TITSPA
	'Id Ledger'																, ; //X3_TITENG
	'Id Ledger'																, ; //X3_DESCRIC
	'Id Ledger'																, ; //X3_DESCSPA
	'Id Ledger'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKV'																	, ; //X3_ARQUIVO
	'34'																	, ; //X3_ORDEM
	'ZKV_CARD'																	, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'ID'																	, ; //X3_TITULO
	'ID'																	, ; //X3_TITSPA
	'ID'																	, ; //X3_TITENG
	'Card'																	, ; //X3_DESCRIC
	'Card'																	, ; //X3_DESCSPA
	'Card'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME	
//********************************
//
// Campos Tabela ZKW
//
aAdd( aSX3, { ;
	'ZKW'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZKW_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'XXXXXX X'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKW'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZKW_CODIGO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	06																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Codigo'																, ; //X3_TITULO
	'Codigo'																, ; //X3_TITSPA
	'Codigo'																, ; //X3_TITENG
	'Codigo'																, ; //X3_DESCRIC
	'Codigo'																, ; //X3_DESCSPA
	'Codigo'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'U_ZKWNUM()'															, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKW'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZKW_PREFIX'     														, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	03																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Prefixo'	    														, ; //X3_TITULO
	'Prefixo'																, ; //X3_TITSPA
	'Prefixo'																, ; //X3_TITENG
	'Prefixo'																, ; //X3_DESCRIC
	'Prefixo'																, ; //X3_DESCSPA
	'Prefixo'		 														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKW'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZKW_DESC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descrição'																, ; //X3_TITULO
	'Descrição'																, ; //X3_TITSPA
	'Descrição'																, ; //X3_TITENG
	'Descrição'																, ; //X3_DESCRIC
	'Descrição'																, ; //X3_DESCSPA
	'Descrição'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKW'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZKW_CAMPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Campo'																	, ; //X3_TITULO
	'Campo'																	, ; //X3_TITSPA
	'Campo'																	, ; //X3_TITENG
	'Campo'																	, ; //X3_DESCRIC
	'Campo'																	, ; //X3_DESCSPA
	'Campo'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME


//********************************
//
// Campos Tabela ZKX
//
aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZKX_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'XXXXXX X'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZKX_CODIGO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	06																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Codigo'																, ; //X3_TITULO
	'Codigo'																, ; //X3_TITSPA
	'Codigo'																, ; //X3_TITENG
	'Codigo'																, ; //X3_DESCRIC
	'Codigo'																, ; //X3_DESCSPA
	'Codigo'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	'U_ZKXNUM()'															, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZKX_DESC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descrição'																, ; //X3_TITULO
	'Descrição'																, ; //X3_TITSPA
	'Descrição'																, ; //X3_TITENG
	'Descrição'																, ; //X3_DESCRIC
	'Descrição'																, ; //X3_DESCSPA
	'Descrição'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME	

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZKX_URL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	200																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Url API'																, ; //X3_TITULO
	'Url API'																, ; //X3_TITSPA
	'Url API'																, ; //X3_TITENG
	'Url API'																, ; //X3_DESCRIC
	'Url API'																, ; //X3_DESCSPA
	'Url API'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME		

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZKX_ENDAPI'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	200																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'End Conexao'															, ; //X3_TITULO
	'End Conexao'															, ; //X3_TITSPA
	'End Conexao'															, ; //X3_TITENG
	'Endereco Conexao'														, ; //X3_DESCRIC
	'Endereco Conexao'														, ; //X3_DESCSPA
	'Endereco Conexao'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZKX_CLIID'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	100																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Client ID'																, ; //X3_TITULO
	'Client ID'																, ; //X3_TITSPA
	'Client ID'																, ; //X3_TITENG
	'Client ID'																, ; //X3_DESCRIC
	'Client ID'																, ; //X3_DESCSPA
	'Client ID'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZKX_CLISEC'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	150																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Client Secre'															, ; //X3_TITULO
	'Client Secre'															, ; //X3_TITSPA
	'Client Secre'															, ; //X3_TITENG
	'Client Secret'															, ; //X3_DESCRIC
	'Client Secret'															, ; //X3_DESCSPA
	'Client Secret'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZKX_TOKEN'																, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Token'																	, ; //X3_TITULO
	'Token'																	, ; //X3_TITSPA
	'Token'																	, ; //X3_TITENG
	'Token'																	, ; //X3_DESCRIC
	'Token'																	, ; //X3_DESCSPA
	'Token'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKX'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZKX_CNPJ'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'CNPJ'																	, ; //X3_TITULO
	'CNPJ'																	, ; //X3_TITSPA
	'CNPJ'																	, ; //X3_TITENG
	'CNPJ'																	, ; //X3_DESCRIC
	'CNPJ'																	, ; //X3_DESCSPA
	'CNPJ'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZKY
//
aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZKY_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'XXXXXX X'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZKY_IDLOG'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'ID Log'																, ; //X3_TITULO
	'ID Log'																, ; //X3_TITSPA
	'ID Log'																, ; //X3_TITENG
	'ID Log'																, ; //X3_DESCRIC
	'ID Log'																, ; //X3_DESCSPA
	'ID Log'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZKY_SEQ'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Sequencia'																, ; //X3_TITULO
	'Sequencia'																, ; //X3_TITSPA
	'Sequencia'																, ; //X3_TITENG
	'Sequencia'																, ; //X3_DESCRIC
	'Sequencia'																, ; //X3_DESCSPA
	'Sequencia'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZKY_MSGTRA'															, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Msg Trafegad'															, ; //X3_TITULO
	'Msg Trafegad'															, ; //X3_TITSPA
	'Msg Trafegad'															, ; //X3_TITENG
	'Mensagem Trafegada'													, ; //X3_DESCRIC
	'Mensagem Trafegada'													, ; //X3_DESCSPA
	'Mensagem Trafegada'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZKY_DATAIN'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Data Ini'																, ; //X3_TITULO
	'Data Ini'																, ; //X3_TITSPA
	'Data Ini'																, ; //X3_TITENG
	'Data Inicial'															, ; //X3_DESCRIC
	'Data Inicial'															, ; //X3_DESCSPA
	'Data Inicial'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZKY_HORAIN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hora Ini'																, ; //X3_TITULO
	'Hora Ini'																, ; //X3_TITSPA
	'Hora Ini'																, ; //X3_TITENG
	'Hora Inicial'															, ; //X3_DESCRIC
	'Hora Inicial'															, ; //X3_DESCSPA
	'Hora Inicial'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZKY_DATAFI'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Data Fin'																, ; //X3_TITULO
	'Data Fin'																, ; //X3_TITSPA
	'Data Fin'																, ; //X3_TITENG
	'Data Final'															, ; //X3_DESCRIC
	'Data Final'															, ; //X3_DESCSPA
	'Data Final'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZKY_HORAFI'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	8																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Hora Fin'																, ; //X3_TITULO
	'Hora Fin'																, ; //X3_TITSPA
	'Hora Fin'																, ; //X3_TITENG
	'Hora Final'															, ; //X3_DESCRIC
	'Hora Final'															, ; //X3_DESCSPA
	'Hora Final'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKY'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZKY_LOG'																, ; //X3_CAMPO
	'M'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Log'																	, ; //X3_TITULO
	'Log'																	, ; //X3_TITSPA
	'Log'																	, ; //X3_TITENG
	'Log'																	, ; //X3_DESCRIC
	'Log'																	, ; //X3_DESCSPA
	'Log'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela ZKZ
//
aAdd( aSX3, { ;
	'ZKZ'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZKZ_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	'XXXXXX X'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKZ'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZKZ_CODCAT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Código Categoria'														, ; //X3_TITULO
	'Código Categoria'																, ; //X3_TITSPA
	'Código Categoria'																, ; //X3_TITENG
	'Código Categoria'																, ; //X3_DESCRIC
	'Código Categoria'																, ; //X3_DESCSPA
	'Código Categoria'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKZ'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZKZ_SEQ'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Sequencia'																, ; //X3_TITULO
	'Sequencia'																, ; //X3_TITSPA
	'Sequencia'																, ; //X3_TITENG
	'Sequencia'																, ; //X3_DESCRIC
	'Sequencia'																, ; //X3_DESCSPA
	'Sequencia'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKZ'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZKZ_CODIGO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	9																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Código'																, ; //X3_TITULO
	'Código'																, ; //X3_TITSPA
	'Código'																, ; //X3_TITENG
	'Código'																, ; //X3_DESCRIC
	'Código'																, ; //X3_DESCSPA
	'Código'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZKZ'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZKZ_DESETQ'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Descrição'																, ; //X3_TITULO
	'Descrição'																, ; //X3_TITSPA
	'Descrição'																, ; //X3_TITENG
	'Descrição'															, ; //X3_DESCRIC
	'Descrição'															, ; //X3_DESCSPA
	'Descrição'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	'xxxxxx x'																, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME	


//
// Atualizando dicionário
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq] $ cAlias )
		cAlias += aSX3[nI][nPosArq] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo] )

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSIX()
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela ZKT
//
aAdd( aSIX, { ;
	'ZKT'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZKT_FILIAL+ZKT_CODIGO'													, ; //CHAVE
	'Codigo'																, ; //DESCRICAO
	'Codigo'																, ; //DESCSPA
	'Codigo'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZKT'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZKT_FILIAL+ZKT_CODIGO+ZKT_NOME'											, ; //CHAVE
	'Codigo+Nome'															, ; //DESCRICAO
	'Codigo+Nome'															, ; //DESCSPA
	'Codigo+Nome'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela ZKU
//
aAdd( aSIX, { ;
	'ZKU'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZKU_FILIAL+ZKU_CODIGO'													, ; //CHAVE
	'Codigo'																, ; //DESCRICAO
	'Codigo'																, ; //DESCSPA
	'Codigo'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZKU'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZKU_FILIAL+ZKU_CODIGO+ZKU_CPINTE'										, ; //CHAVE
	'Codigo+cp Integracao'													, ; //DESCRICAO
	'Codigo+cp Integracao'													, ; //DESCSPA
	'Codigo+cp Integracao'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZKU'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'ZKU_FILIAL+ZKU_CODIGO+ZKU_CPPROT'											, ; //CHAVE
	'Codigo+cp Protheus'													, ; //DESCRICAO
	'Codigo+cp Protheus'													, ; //DESCSPA
	'Codigo+cp Protheus'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZKU'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'ZKU_FILIAL+ZKU_LAYOUT+ZKU_CODIGO'											, ; //CHAVE
	'Cod. Layout+Codigo'													, ; //DESCRICAO
	'Cod. Layout+Codigo'													, ; //DESCSPA
	'Cod. Layout+Codigo'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ	

//
// Tabela ZKV
//
aAdd( aSIX, { ;
	'ZKV'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZKV_FILIAL+ZKV_LAYOUT+ZKV_METODO+ZKV_USER'									, ; //CHAVE
	'Layout+Metodo+Usuario'													, ; //DESCRICAO
	'Layout+Metodo+Usuario'													, ; //DESCSPA
	'Layout+Metodo+Usuario'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZKV'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZKV_FILIAL+ZKV_ID'														, ; //CHAVE
	'Id'																	, ; //DESCRICAO
	'Id'																	, ; //DESCSPA
	'Id'																	, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela ZKW
//
aAdd( aSIX, { ;
	'ZKW'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZKW_FILIAL+ZKW_CODIGO'													, ; //CHAVE
	'Cod Categoria'															, ; //DESCRICAO
	'Cod Categoria'															, ; //DESCSPA
	'Cod Categoria'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ	

//
// Tabela ZKX
//
aAdd( aSIX, { ;
	'ZKX'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZKX_FILIAL+ZKX_CLIID'													, ; //CHAVE
	'ClientID'																, ; //DESCRICAO
	'ClientID'																, ; //DESCSPA
	'ClientID'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZKX'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZKX_FILIAL+ZKX_CODIGO'													, ; //CHAVE
	'Codigo'																, ; //DESCRICAO
	'Codigo'																, ; //DESCSPA
	'Codigo'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ	

//
// Tabela ZKY
//
aAdd( aSIX, { ;
	'ZKY'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZKY_FILIAL+ZKY_IDLOG'													, ; //CHAVE
	'ID Log'																, ; //DESCRICAO
	'ID Log'																, ; //DESCSPA
	'ID Log'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZKY'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZKY_FILIAL+ZKY_IDLOG+ZKY_SEQ'												, ; //CHAVE
	'Id Log+Seq'															, ; //DESCRICAO
	'Id Log+Seq'															, ; //DESCSPA
	'Id Log+Seq'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela ZKZ
//
aAdd( aSIX, { ;
	'ZKZ'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZKZ_FILIAL+ZKZ_CODIGO'													, ; //CHAVE
	'Cod. Etiqueta'															, ; //DESCRICAO
	'Cod. Etiqueta'															, ; //DESCSPA
	'Cod. Etiqueta'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ	

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for alteração precisa apagar o indice do banco
		EndIf
	EndIf

	RecLock( "SIX", !lAlt )
	For nJ := 1 To Len( aSIX[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
		EndIf
	Next nJ
	MsUnLock()

	dbCommit()

	If lDelInd
		TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
	EndIf

	oProcess:IncRegua2( "Atualizando índices..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX6
Função de processamento da gravação do SX6 - Parâmetros

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6()
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

AutoGrLog( "Ínicio da Atualização" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SA_CIDACC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Client id'																, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''														             	, ; //X6_CONTEUD
	''														            	, ; //X6_CONTSPA
	''														            	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SA_EMPACC'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Permissao Empresa'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''														             	, ; //X6_CONTEUD
	''														            	, ; //X6_CONTSPA
	''														            	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SA_USRACC'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Usuário ACC'															, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''														             	, ; //X6_CONTEUD
	''														            	, ; //X6_CONTSPA
	''														            	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME		

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( "SX6" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )
	lContinua := .F.
	lReclock  := .F.

	If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
		lContinua := .T.
		lReclock  := .T.
		AutoGrLog( "Foi incluído o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]" )
	EndIf

	If lContinua
		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + "/"
		EndIf

		RecLock( "SX6", lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SX6)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX7
Função de processamento da gravação do SX7 - Gatilhos

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------

Static Function FSAtuSX7()
Local aEstrut   := {}
Local aAreaSX3  := SX3->( GetArea() )
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )
 
AutoGrLog( "Ínicio da Atualização" + " SX7" + CRLF )
 
aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
             "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" ,"X7_LOCALIZ"}
 
aAdd( aSX7, { ;
    'ZKU_CPPROT'                                                            , ; //X7_CAMPO
    '001'                                                                   , ; //X7_SEQUENC
    'ZKU->ZKU_CPPROT'                                                       , ; //X7_REGRA
    'ZKU_ALIAS'                                                             , ; //X7_CDOMIN
    'P'                                                                     , ; //X7_TIPO
    'N'                                                                     , ; //X7_SEEK
    ''                                                                      , ; //X7_ALIAS
    1                                                                       , ; //X7_ORDEM
    ''                                                                      , ; //X7_CHAVE
    'U'                                                                     , ; //X7_PROPRI
    ''                                                                      , ; //X7_CONDIC
    ''                                                                      } ) //X7_LOCALIZ
 
 
//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX7 ) )
 
dbSelectArea( "SX3" )
dbSetOrder( 2 )
 
dbSelectArea( "SX7" )
dbSetOrder( 1 )
 
For nI := 1 To Len( aSX7 )
 
    If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )
 
        If !( aSX7[nI][1] $ cAlias )
            cAlias += aSX7[nI][1] + "/"
            AutoGrLog( "Foi incluído o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
        EndIf
 
        RecLock( "SX7", .T. )
    Else
 
        If !( aSX7[nI][1] $ cAlias )
            cAlias += aSX7[nI][1] + "/"
            AutoGrLog( "Foi alterado o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
        EndIf
 
        RecLock( "SX7", .F. )
    EndIf
 
    For nJ := 1 To Len( aSX7[nI] )
        If FieldPos( aEstrut[nJ] ) > 0
            FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
        EndIf
    Next nJ
 
    dbCommit()
    MsUnLock()
 
    If SX3->( dbSeek( SX7->X7_CAMPO ) )
        RecLock( "SX3", .F. )
        SX3->X3_TRIGGER := "S"
        MsUnLock()
    EndIf
 
    oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )
 
Next nI
 
RestArea( aAreaSX3 )
 
AutoGrLog( CRLF + "Final da Atualização" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )
 
Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXB
Função de processamento da gravação do SXB - Consultas Padrao

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXB()
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

AutoGrLog( "Ínicio da Atualização" + " SXB" + CRLF )

aEstrut := { "XB_ALIAS"  , "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , "XB_DESCRI" , "XB_DESCSPA", "XB_DESCENG", ;
             "XB_WCONTEM", "XB_CONTEM" }


//
// Consulta ZKT
//
aAdd( aSXB, { ;
	'ZKT'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Tabela de Layout'														, ; //XB_DESCRI
	'Tabela de Layout'														, ; //XB_DESCSPA
	'Tabela de Layout'														, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKT'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKT'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Codigo'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKT'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Codigo'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKT_CODIGO'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKT'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Nome'																	, ; //XB_DESCRI
	'Nome'																	, ; //XB_DESCSPA
	'Nome'																	, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKT_NOME'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKT'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Metodo'																, ; //XB_DESCRI
	'Metodo'																, ; //XB_DESCSPA
	'Metodo'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKT_METODO'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKT'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKT->ZKT_CODIGO'														} ) //XB_CONTEM

//
// Consulta ZKV
//
aAdd( aSXB, { ;
	'ZKV'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Tabela Log'															, ; //XB_DESCRI
	'Tabela Log'															, ; //XB_DESCSPA
	'Tabela Log'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKV'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKV'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Layout+metodo+usuari'													, ; //XB_DESCRI
	'Layout+metodo+usuari'													, ; //XB_DESCSPA
	'Layout+metodo+usuari'													, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKV'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Filial'																, ; //XB_DESCRI
	'Sucursal'																, ; //XB_DESCSPA
	'Branch'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKV_FILIAL'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKV'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'ID'																	, ; //XB_DESCRI
	'ID'																	, ; //XB_DESCSPA
	'ID'																	, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKV_ID'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKV'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Layout'																, ; //XB_DESCRI
	'Layout'																, ; //XB_DESCSPA
	'Layout'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKV_LAYOUT'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKV'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKV->ZKV_ID'															} ) //XB_CONTEM	

//
// Consulta ZKX
//
aAdd( aSXB, { ;
	'ZKX'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Conexões'																, ; //XB_DESCRI
	'Conexões'																, ; //XB_DESCSPA
	'Conexões'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKX'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKX'																	, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Código'																, ; //XB_DESCRI
	'Código'																, ; //XB_DESCSPA
	'Código'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKX'																	, ; //XB_ALIAS
	'3'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cadastra Novo'															, ; //XB_DESCRI
	'Cadastra Novo'															, ; //XB_DESCSPA
	'Cadastra Novo'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'01'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKX'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Codigo'																, ; //XB_DESCRI
	'Codigo'																, ; //XB_DESCSPA
	'Codigo'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKX_CODIGO'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKX'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Descrição'																, ; //XB_DESCRI
	'Descrição'																, ; //XB_DESCSPA
	'Descrição'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKX_DESC'																} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKX'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKX->ZKX_CODIGO'														} ) //XB_CONTEM

//
// Consulta ZKW
//
aAdd( aSXB, { ;
	'ZKW'																	, ; //XB_ALIAS
	'1'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'DB'																	, ; //XB_COLUNA
	'Categoria Etiquetas'													, ; //XB_DESCRI
	'Categoria Etiquetas'													, ; //XB_DESCSPA
	'Categoria Etiquetas'													, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKW'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKW'																, ; //XB_ALIAS
	'2'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cod Categ'																, ; //XB_DESCRI
	'Cod Categ'																, ; //XB_DESCSPA
	'Cod Categ'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	''																		} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKW'																	, ; //XB_ALIAS
	'3'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cadastra Novo'															, ; //XB_DESCRI
	'Cadastra Novo'															, ; //XB_DESCSPA
	'Cadastra Novo'															, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'01'																	} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKW'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'01'																	, ; //XB_COLUNA
	'Cod Categ'																, ; //XB_DESCRI
	'Cod Categ'																, ; //XB_DESCSPA
	'Cod Categ'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKW_CODIGO'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKW'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'02'																	, ; //XB_COLUNA
	'Prefixo'																, ; //XB_DESCRI
	'Prefixo'																, ; //XB_DESCSPA
	'Prefixo'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKW_PREFIX'															} ) //XB_CONTEM

aAdd( aSXB, { ;
	'ZKW'																	, ; //XB_ALIAS
	'4'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	'03'																	, ; //XB_COLUNA
	'Descrição'																, ; //XB_DESCRI
	'Descrição'																, ; //XB_DESCSPA
	'Descrição'																, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKW_DESC'																} ) //XB_CONTEM	

aAdd( aSXB, { ;
	'ZKW'																	, ; //XB_ALIAS
	'5'																		, ; //XB_TIPO
	'01'																	, ; //XB_SEQ
	''																		, ; //XB_COLUNA
	''																		, ; //XB_DESCRI
	''																		, ; //XB_DESCSPA
	''																		, ; //XB_DESCENG
	''																		, ; //XB_WCONTEM
	'ZKW->ZKW_CODIGO'														} ) //XB_CONTEM		

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				AutoGrLog( "Foi incluída a consulta padrão " + aSXB[nI][1] )
			EndIf

			RecLock( "SXB", .T. )

			For nJ := 1 To Len( aSXB[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
				EndIf
			Next nJ

			dbCommit()
			MsUnLock()

		Else

			//
			// Verifica todos os campos
			//
			For nJ := 1 To Len( aSXB[nI] )

				//
				// Se o campo estiver diferente da estrutura
				//
				If aEstrut[nJ] == SXB->( FieldName( nJ ) ) .AND. ;
					!StrTran( AllToChar( SXB->( FieldGet( nJ ) ) ), " ", "" ) == ;
					 StrTran( AllToChar( aSXB[nI][nJ]            ), " ", "" )

					cMsg := "A consulta padrão " + aSXB[nI][1] + " está com o " + SXB->( FieldName( nJ ) ) + ;
					" com o conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
					", e este é diferente do conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SXB e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SXB que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						RecLock( "SXB", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						dbCommit()
						MsUnLock()

							If !( aSXB[nI][1] $ cAlias )
								cAlias += aSXB[nI][1] + "/"
								AutoGrLog( "Foi alterada a consulta padrão " + aSXB[nI][1] )
							EndIf

					EndIf

				EndIf

			Next

		EndIf

	EndIf

	oProcess:IncRegua2( "Atualizando Consultas Padrões (SXB)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuHlp
Função de processamento da gravação dos Helps de Campos

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuHlp()
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

AutoGrLog( "Ínicio da Atualização" + " " + "Helps de Campos" + CRLF )


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

//
// Helps Tabela ZKT
//
//
// Helps Tabela ZKU
//
aHlpPor := {}
aAdd( aHlpPor, 'Código que identifica a filial da' )
aAdd( aHlpPor, 'empre-sa usuária do sistema.' )
aHlpEng := {}
aAdd( aHlpEng, 'Código que identifica a filial da' )
aAdd( aHlpEng, 'empre-sa usuária do sistema.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Código que identifica a filial da' )
aAdd( aHlpSpa, 'empre-sa usuária do sistema.' )

PutSX1Help( "PZKU_FILIAL ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZKU_FILIAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Código de identificação do funcionário' )
aAdd( aHlpPor, 'usuário do módulo SigaSbi.' )
aHlpEng := {}
aAdd( aHlpEng, 'Código de identificação do funcionário' )
aAdd( aHlpEng, 'usuário do módulo SigaSbi.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Código de identificação do funcionário' )
aAdd( aHlpSpa, 'usuário do módulo SigaSbi.' )

PutSX1Help( "PZKU_CODIGO ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZKU_CODIGO" )

//
// Helps Tabela ZKV
//
aHlpPor := {}
aAdd( aHlpPor, 'Código que identifica a filial de' )
aAdd( aHlpPor, 'empre-sa usuária do sistema.' )
aHlpEng := {}
aAdd( aHlpEng, 'Código que identifica a filial de' )
aAdd( aHlpEng, 'empre-sa usuária do sistema.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Código que identifica a filial de' )
aAdd( aHlpSpa, 'empre-sa usuária do sistema.' )

PutSX1Help( "PZKV_FILIAL ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZKV_FILIAL" )

//
// Helps Tabela ZKW
//
aHlpPor := {}
aAdd( aHlpPor, 'Código que identifica a filial de' )
aAdd( aHlpPor, 'empre-sa usuária do sistema.' )
aHlpEng := {}
aAdd( aHlpEng, 'Código que identifica a filial de' )
aAdd( aHlpEng, 'empre-sa usuária do sistema.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Código que identifica a filial de' )
aAdd( aHlpSpa, 'empre-sa usuária do sistema.' )

PutSX1Help( "PZKW_FILIAL ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZKW_FILIAL" )

//
// Helps Tabela ZKX
//
aHlpPor := {}
aAdd( aHlpPor, 'Código que identifica a filial da' )
aAdd( aHlpPor, 'empre-sa usuária do sistema.' )
aHlpEng := {}
aAdd( aHlpEng, 'Código que identifica a filial da' )
aAdd( aHlpEng, 'empre-sa usuária do sistema.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Código que identifica a filial da' )
aAdd( aHlpSpa, 'empre-sa usuária do sistema.' )

PutSX1Help( "PZKX_FILIAL ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZKX_FILIAL" )

//
// Helps Tabela ZKY
//
aHlpPor := {}
aAdd( aHlpPor, 'Código que identifica a filial da' )
aAdd( aHlpPor, 'empre-sa usuária do sistema.' )
aHlpEng := {}
aAdd( aHlpEng, 'Código que identifica a filial da' )
aAdd( aHlpEng, 'empre-sa usuária do sistema.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Código que identifica a filial da' )
aAdd( aHlpSpa, 'empre-sa usuária do sistema.' )

PutSX1Help( "PZKY_FILIAL ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZKY_FILIAL" )

AutoGrLog( CRLF + "Final da Atualização" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF )

//
// Helps Tabela ZKZ
//
aHlpPor := {}
aAdd( aHlpPor, 'Código que identifica a filial da' )
aAdd( aHlpPor, 'empre-sa usuária do sistema.' )
aHlpEng := {}
aAdd( aHlpEng, 'Código que identifica a filial da' )
aAdd( aHlpEng, 'empre-sa usuária do sistema.' )
aHlpSpa := {}
aAdd( aHlpSpa, 'Código que identifica a filial da' )
aAdd( aHlpSpa, 'empre-sa usuária do sistema.' )

PutSX1Help( "PZKZ_FILIAL ", aHlpPor, aHlpEng, aHlpSpa, .T.,,.T. )
AutoGrLog( "Atualizado o Help do campo " + "ZKZ_FILIAL" )

AutoGrLog( CRLF + "Final da Atualização" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF )

Return {}


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
             Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
//---------------------------------------------
Local   aRet      := {}
Local   aSalvAmb  := GetArea()
Local   aSalvSM0  := {}
Local   aVetor    := {}
Local   cMascEmp  := "??"
Local   cVar      := ""
Local   lChk      := .F.
Local   lOk       := .F.
Local   lTeveMarc := .F.
Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc

Local   aMarcadas := {}


If !MyOpenSm0(.F.)
	Return aRet
EndIf


dbSelectArea( "SM0" )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), aVetor[oLbx:nAt, 2], aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDTOT" ) ) ) ;
Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Função auxiliar para inverter a seleção do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Função auxiliar para verificar se estão todos marcados ou não

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Função de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)
Local lOpen := .F.
Local nLoop := 0

If FindFunction( "OpenSM0Excl" )
	For nLoop := 1 To 20
		If OpenSM0Excl(,.F.)
			lOpen := .T.
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
Else
	For nLoop := 1 To 20
		dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
EndIf

If !lOpen
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  12/01/2021
@obs    Gerado por EXPORDIC - V.6.5.0.3 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
Local cRet  := ""
Local cFile := NomeAutoLog()
Local cAux  := ""

FT_FUSE( cFile )
FT_FGOTOP()

While !FT_FEOF()

	cAux := FT_FREADLN()

	If Len( cRet ) + Len( cAux ) < 1048000
		cRet += cAux + CRLF
	Else
		cRet += CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
