#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"

User Function Exec450()
	Local aAutoCab := {}
	
	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
	
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST"
	
	
	MSGINFO("Compensação entre carteiras")
	ConOut(Repl("-", 80))
	ConOut(Repl("*", 80))
	ConOut(PadC(" ------------  Iniciando FINA450 !  -------------", 80))
	ConOut(Repl("*", 80))
	ConOut(Repl("-", 80))
	
	aAutoCab := { {"AUTDVENINI450", cTod('16/07/18') , nil},;
					{"AUTDVENFIM450", cTod('16/07/18') , nil},;
					{"AUTNLIM450" , 10000 , nil},;
					{"AUTCCLI450" , "766322539" , nil},;
					{"AUTCLJCLI" , "0001" , nil},;
					{"AUTCFOR450" , "766322539" , nil},;
					{"AUTCLJFOR" , "0001" , nil},;
					{"AUTCMOEDA450" , "01" , nil},;
					{"AUTNDEBCRED" , 1 , nil},;
					{"AUTLTITFUTURO", .F. , nil},;
					{"AUTARECCHAVE" , {} , nil},;
					{"AUTAPAGCHAVE" , {} , nil}}
				
	
	// Dados do titulo a receber
	SE1->( dbSetOrder( 1 ) )
	SE1->( MsSeek( xFilial( "SE1" ) + PadR( "MAN" , TamSX3("E1_PREFIXO")[ 1 ] ) + ;
		PadR( "000000001" , TamSX3( "E1_NUM" )[ 1 ] ) + ;
		PadR( "999" , TamSX3( "E1_PARCELA" )[ 1 ] ) + ;
		PadR( "CO " , TamSX3( "E1_TIPO" )[ 1 ] ) ) )
	
	AAdd( aAutoCab[11,2], { xFilial( "SE1" ) + PadR( "MAN" ,   TamSX3( "E1_PREFIXO" )[ 1 ] ) + ;
		PadR( "000000001" , TamSX3( "E1_NUM" )[ 1 ] ) + ;
		PadR( "999" , TamSX3( "E1_PARCELA" )[ 1 ] ) + ;
		PadR( "CO " , TamSX3( "E1_TIPO" )[ 1 ] ) } )
	
	
	// Dados do titulo a pagar
	SE2->( dbSetOrder( 1 ) )
	SE2->( MsSeek( xFilial( "SE2" ) + PadR( "MAN" , TamSX3(   "E2_PREFIXO" )[ 1 ] ) + ;
		PadR( "000000001" , TamSX3( "E2_NUM" )[ 1 ] ) + ;
		PadR( "999" , TamSX3( "E2_PARCELA" )[ 1 ] ) + ;
		PadR( "NF " , TamSX3( "E2_TIPO" )[ 1 ] ) + ;
		PadR( "766322539" , TamSX3( "E2_FORNECE" )[ 1 ] ) + ;
		PadR( "0001" , TamSX3( "E2_LOJA" )[ 1 ] ) ) )
	
	AAdd( aAutoCab[12,2], { xFilial( "SE2" ) + PadR( "MAN" ,   TamSX3( "E2_PREFIXO" )[ 1 ] ) + ;
		PadR( "000000001" , TamSX3( "E2_NUM" )[ 1 ] ) + ;
		PadR( "999" , TamSX3( "E2_PARCELA" )[ 1 ] ) + ;
		PadR( "NF " , TamSX3( "E2_TIPO" )[ 1 ] ) + ;
		PadR( "766322539" , TamSX3( "E2_FORNECE" )[ 1 ] ) + ;
		PadR( "0001" , TamSX3( "E2_LOJA" )[ 1 ] ) } )
	
	
	MSExecAuto({|x,y,z| Fina450(x,y,z)}, nil , aAutoCab , 3 )
	
	
	If !lMsErroAuto
		msgalert("Incluido com sucesso! ")
		ConOut(Repl("-", 80))
		ConOut(Repl("*", 80))
		ConOut(PadC(" ------------  FIM FINA450 !  -------------", 80))
		ConOut(Repl("*", 80))
		ConOut(Repl("-", 80))
		confirmsx8()
	Else
		ConOut(Repl("-", 80))
		ConOut(Repl("*", 80))
		ConOut(PadC(" ------------  ERRO FINA450 !  -------------", 80))
		ConOut(Repl("*", 80))
		ConOut(Repl("-", 80))
		msgalert("ERRO FINA450 ! ")
		rollbacksx8()
		MostraErro()
	EndIf
	
	//RESET ENVIRONMENT
	
Return
