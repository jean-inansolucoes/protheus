#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ UPDDTENT บAutor  ณLincoln Rossetto    บ Data ณ  23/11/10  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arquivo com fun็๕es auxiliares para utiliza็ใo com demais  บฑฑ
ฑฑบDesc.     ณ rotinas.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LSSHWHLP บAutor  ณLincoln Rossetto    บ Data ณ  18/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Help Padrใo Microsiga.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSSHWHLP( pcTitulo, pcProblema, pcSolucao )
*********************************************************
Local aSvKeys   := GetKeys()  

ShowHelpDlg( TRANSFORM( pcTitulo, "@!" ),  { pcProblema }, 5, { pcSolucao }, 5)

RestKeys( aSvKeys , .T. )

Return Nil                                                                                                     
                                       
/*
_________________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-------------+-------------+-------+---------------------+------+----------+ฆฆ
ฆฆฆPrograma     ฆ LSSTRSX3    ฆ Autor ฆ LINCOLN P. ROSSETTO ฆ Data ฆ 23/11/10 ฆฆฆ
ฆฆ+-------------+-------------+-------+---------------------+------+----------+ฆฆ
ฆฆฆDescri็ใo    ฆ "RETORNA INFORMAวีES DO SX3 SOBRE UM DETERMINADO CAMPO"     ฆฆฆ
ฆฆ+-------------+-------------------------------------------------------------+ฆฆ
ฆฆฆRetorno      ฆ  ExpAA: Array com as informa็๕es sendo:                     ฆฆฆ
ฆฆฆ             ฆ    [1]: AllTrim(X3Titulo())                                 ฆฆฆ
ฆฆฆ             ฆ    [2]: SX3->X3_CAMPO                                       ฆฆฆ
ฆฆฆ             ฆ    [3]: SX3->X3_TIPO                                        ฆฆฆ
ฆฆฆ             ฆ    [4]: SX3->X3_TAMANHO                                     ฆฆฆ
ฆฆฆ             ฆ    [5]: SX3->X3_DECIMAL                                     ฆฆฆ
ฆฆฆ             ฆ    [6]: SX3->X3_PICTURE                                     ฆฆฆ
ฆฆฆ             ฆ    [7]: SX3->X3_VALID                                       ฆฆฆ
ฆฆฆ             ฆ    [8]: SX3->X3_VLDUSER                                     ฆฆฆ
ฆฆฆ             ฆ    [9]: SX3->X3_USADO                                       ฆฆฆ
ฆฆฆ             ฆ   [10]: SX3->X3_F3                                          ฆฆฆ
ฆฆฆ             ฆ   [11]: SX3->X3_CONTEXT                                     ฆฆฆ
ฆฆฆ             ฆ   [12]: SX3->X3_CBOX                                        ฆฆฆ
ฆฆฆ             ฆ   [13]: SX3->X3_RELACAO                                     ฆฆฆ
ฆฆฆ             ฆ   [14]: VisualSX3(ExpC1)                                    ฆฆฆ
ฆฆฆ             ฆ   [15]: X3Obrigat(ExpC1)                                    ฆฆฆ
ฆฆฆ             ฆ   [16]: SX3->X3_VISUAL                                      ฆฆฆ
ฆฆฆ             ฆ   [17]: SX3->X3_VLDUSER                                     ฆฆฆ
ฆฆฆ             ฆ   [18]: SX3->X3_PICTVAR                                     ฆฆฆ
ฆฆฆ             ฆ   [19]: SX3->X3_WHEN                                        ฆฆฆ
ฆฆ+-------------+-------------------------------------------------------------+ฆฆ
ฆฆฆParametros   ฆ ExpC1 : Campo a ser pesquisado no SX3                       ฆฆฆ
ฆฆ+-------------+-------------------------------------------------------------+ฆฆ
ฆฆฆManuten็๕es  ฆ     DATA     ANALISTA         MANUTENวรO                    ฆฆฆ
ฆฆ+-------------+-------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
*/            
User Function LSSTRSX3( ExpC1 )
*******************************
Local ExpAA := {}
Local cArea := GetArea()

SX3->( dbSetOrder( 2 ) )
SX3->( dbgotop( ) )

If SX3->( dbSeek( ExpC1 ) )
	ExpAA := { AllTrim( X3Titulo( ) ) , SX3->X3_CAMPO     , SX3->X3_TIPO , SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_PICTURE , ;
	           SX3->X3_VALID          , SX3->X3_VLDUSER   , SX3->X3_USADO, SX3->X3_F3     , SX3->X3_CONTEXT, SX3->X3_CBOX    , ;
	           SX3->X3_RELACAO        , VisualSX3( ExpC1 ), X3Obrigat( ExpC1 )            , SX3->X3_VISUAL , SX3->X3_VLDUSER , ; 
	           SX3->X3_PICTVAR        , SX3->X3_WHEN      , SX3->X3_DESCRIC                                                    }
Else
   U_LSSHWHLP( "DIPALSX3" , "Nใo foi possivel verificar as informa็๕es do Campo [" + ExpC1 + "]", "Informe o Campo Correto!" )
   ExpAA := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL, NIL, NIL, NIL, NIL, NIL }
EndIf

RestArea( cArea )

return( ExpAA )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LSALXDIR   บ Autor ณ Lincoln Rossetto บ Data ณ  23/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsแvel por criar no System a pasta extras onde  บฑฑ
ฑฑบ          ณficarแ gravado logs e instru็๕es de Querys montadas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Silvestre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณpcEmpresa = Titulo o qual serแ apresentado na tela          บฑฑ
ฑฑ 			 ณpcModulo  = Descri็ใo do problema validado				  บฑฑ
ฑฑ			 ณpcRotina  = Descri็ใo da solu็ใo para o problema validado   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSALXDIR( pcModulo, pcRotina )
*********************************************
Local cAux      := ""
Local cEmpLogIn := Alltrim( U_LSINFEL( )[ 4 ][ 2 ] )  // Retorna o Nome da Empresa Logada...
#Define cPathExtras  "\system\extras"
cAux := cPathExtras + "\" + Alltrim( cEmpLogIn ) + "\" + pcModulo + "\" + pcRotina

if !lIsDir( cAux )
    cAux := cPathExtras
	if !lIsDir( cAux )
		MakeDir( cAux )
	endif
	
	cAux := cPathExtras + "\" + cEmpLogIn
	if !lIsDir( cAux )
		MakeDir( cAux )
	endif
	
	cAux += "\" + pcModulo
	if !lIsDir( cAux )
		MakeDir( cAux )
	endif
	
	cAux += "\" + pcRotina
	if !lIsDir( cAux )
		MakeDir( cAux )
	endif
endif

cAux += "\" 

return( cAux )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LSINFEL บAutor  ณLincoln Rossetto    ณ Data ณ  15/06/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsแvel por retornar informa็๕es sobre a empresa บฑฑ
ฑฑบ          ณ e Filial logada.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Silvestre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณNenhum                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSINFEL( pcFilial )
**********************************
Local aArea      := GetArea()
Local aRet       := {}
Default pcFilial := cFilAnt 

If ( Select( "SM0" ) == 0 )
	OpenSM0()
Endif

If ( Select( "SM0" ) > 0 )
	SM0->( dBGotop() )
	
	If SM0->( dBSeek( cEmpAnt + pcFilial ) )
		
		For nI := 1 To SM0->( FCount() )
			aAdd( aRet, { SM0->( Field( nI )  ), SM0->( FieldGet( nI ) ) } )
		Next
		
	Endif
Endif

RestArea( aArea )

Return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LSCLERAC บAutor  ณLincoln Rossetto    ณ Data ณ  04/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ rotina responsแvel pela remo็ใo dos acentros do texto inforบฑฑ
ฑฑบ          ณ mado.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Silvestre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณNenhum                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSCLERAC( pcTexto )
*********************************
Local cTexto := pcTexto
Local aChars := { { "แ", "a" }, { "้", "e" }, { "ํ", "i" }, { "๓", "o" }, { "๚", "u" }, { "ม", "A" }, { "ษ", "E" }, { "อ", "I" }, { "ำ", "O" }, { "ฺ", "U" }, { "โ", "a" } ,;
                  { "๊", "e" }, { "๎", "i" }, { "๔", "o" }, { "๛", "u" }, { "ย", "A" }, { "ส", "E" }, { "ฮ", "I" }, { "ิ", "O" }, { "Û", "U" }, { "ใ", "a" }, { "๕", "o" } ,;
                  { "ร", "A" }, { "ี", "O" }, { "็", "c" }, { "ว", "C" }, { "ü", "u" }, { "Ü", "U" }, { "แ", "a" }, { "้", "e" }, { "ํ", "i" }, { "๓", "o" }, { "๚", "u" } ,;
                  { "ม", "A" }, { "ษ", "E" }, { "อ", "I" }, { "ำ", "O" }, { "ฺ", "U" }, { "โ", "a" }, { "๊", "e" }, { "๎", "i" }, { "๔", "o" }, { "๛", "u" }, { "ย", "A" } ,;
                  { "ส", "E" }, { "ฮ", "I" }, { "ิ", "O" }, { "Û", "U" }, { "ใ", "a" }, { "๕", "o" }, { "ร", "A" }, { "ี", "O" }, { "็", "c" }, { "ว", "C" }, { "ü", "u" } ,;
                  { "Ü", "U" }, { "เ", "a" }, { "่", "e" }, { "์", "i" }, { "๒", "o" }, { "๙", "u" }, { "ภ", "A" }, { "ศ", "E" }, { "ฬ", "I" }, { "า", "O" }, { "ู", "U" } }

For nX := 1 To Len( aChars )
    cTexto := StrTran( cTexto, aChars[ nX ][ 1 ], aChars[ nX ][ 2 ] )
Next

Return( cTexto )

                                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA460XNM บAutor  ณLincoln Rossetto    ณ Data ณ  17/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ rotina responsแvel por verificar o tipo deo movimento e re-บฑฑ
ฑฑบ          ณ tornar o nome do cliente/fornecedor.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Silvestre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณNenhum                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA460XNM( pcOrigem )
**********************************
//IIF(FindFunction("U_MA460XNM"),IIF(!INCLUI,U_MA460XNM("SC9"),''),'')
//IIF(FindFunction("U_MA460XNM"),U_MA460XNM( "SC9" ),'')
Local cAlias := pcOrigem
Local aArea  := {}
Local cRet   := ""
Local cSeek  := ""
Local cValid := ""
Local cField := ""

CursorWait()
SysRefresh()

Do Case
	Case cAlias == "SF2"
		aArea  := SF2->( GetArea( ) )
		cSeek  := "SF2->F2_CLIENTE + SF2->F2_LOJA"
		cValid := "F2_TIPO"
		
	Case cAlias == "SC9"
		aArea  := SC9->( GetArea( ) )
		cSeek  := "SC9->C9_CLIENTE + SC9->C9_LOJA"
		cAlias := "SC5"
		cValid := "C5_TIPO"

		dBSelectArea( "SC5" )
		SC5->( dBSetOrder( 1 ) )
		SC5->( dBGoTop( ) )
		SC5->( dBSeek( xFilial( "SC5" ) + SC9->C9_PEDIDO ) )

EndCase

If !Empty( cAlias )
	
	If !( cAlias )->&cValid $ "D/B"
		cRet   := Space( TamSX3( 'A1_NOME' )[ 1 ] )
		cAlias := "SA1"
		cField := "A1_NOME"
	Else
		cRet   := Space( TamSX3( 'A2_NOME' )[ 1 ] )
		cAlias := "SA2"
		cField := "A2_NOME"
	Endif
	
	dBSelectArea( cAlias )
	( cAlias )->( dBSetOrder( 1 ) )
	( cAlias )->( dBGoTop( ) )
	
	If ( cAlias )->( dBSeek( xFilial( cAlias ) + &cSeek ) )
		cRet := ( cAlias )->&cField
	Endif
Endif

If Len( aArea ) > 0
	RestArea( aArea )
Endif

CursorArrow()
SysRefresh()


Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALCNPJ  บAutor  ณMarcelo Joner       บ Data ณ  14/08/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de validacao do CNPJ                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico Moinho Igua็u                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VALCNPJ( cCliFor, cPessoa, cCgc )
***********************************************
Local lRet   := .T.
Local aArea  := { }
Local cxLoja := ""

If cPessoa == "J"
	If cCliFor == "C"
		aArea := SA1->( GetArea( ) )
		dBSelectArea( "SA1" )
		SA1->( dBSetOrder( 3 ) )
		SA1->( dbGoTop( ) )
		If SA1->( dBSeek( xFilial( "SA1" ) + cCgc ) )
			while !SA1->( Eof( ) ) .And. SA1->A1_FILIAL == xFilial( "SA1" ) .And. SA1->A1_COD == cCgc
				cxLoja := SA1->A1_LOJA
				SA1->( dBSkip( ) )
			enddo
			Aviso("Aten็ใo","Jแ existe o cliente " + SA1->A1_COD + " com a loja " + cxLoja + " cadastrado com o CNPJ informado.",{"Ok"},2)
			lRet := .F.
		EndIf
		
	Else
		If cCliFor == "F"
			aArea := SA2->( GetArea( ) )
			dBSelectArea( "SA2" )
			SA2->( dbSetOrder( 3 ) )
			SA2->( dbGoTop() )
			If SA2->( dBSeek( xFilial( "SA2" ) + cCgc ) )
				while !SA2->( Eof( ) ) .And. SA2->A2_FILIAL == xFilial( "SA2" ) .And. SA2->A2_COD == cCgc
					cxLoja := SA2->A2_LOJA
					SA2->( dBSkip( ) )
				enddo
				Aviso("Aten็ใo","Jแ existe o fornecedor " + SA2->A2_COD + " com a loja " + cxLoja + " cadastrado com o CNPJ informado.",{"Ok"},2)
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf

If Len( aArea ) > 0
	RestArea( aArea )
Endif

Return( lRet )

User Function IsModulo( cModName )
**********************************
Local lRet := .F.
Local nX   := 0

Static aModulos := RetModName()

nX := aScan( aModulos,{ |x| AllTrim( X[ 2 ] ) == cModName } )

If nX == nModulo
   lRet := .T.
EndIf

Return( lRet )


User Function CleanSA1()
*************************
dBSelectArea( "SA1" )
SA1->( dBSetOrder( 1 ) )
SA1->( dBGoTop( ) )
N  :=0
N1 :=0
N2 :=0
N3 :=0
N4 :=0
N5 :=0
N6 :=0
While !SA1->( Eof( ) )

    If "&" $ SA1->A1_NOME 
       cAux := Alltrim( SA1->A1_NOME )
       cAux := StrTran( cAux, "&", "E" )
       RecLock( "SA1", .F. )
       SA1->A1_NOME := cAux
       SA1->( MsUnLock( ) )
       N1++
    Endif

    If "'" $ SA1->A1_NOME 
       cAux := Alltrim( SA1->A1_NOME )
       cAux := StrTran( cAux, "'", " " )
       RecLock( "SA1", .F. )
       SA1->A1_NOME := cAux
       SA1->( MsUnLock( ) )
       N2++
    Endif

    If '"' $ SA1->A1_NOME 
       cAux := Alltrim( SA1->A1_NOME )
       cAux := StrTran( cAux, '"', " " )
       RecLock( "SA1", .F. )
       SA1->A1_NOME := cAux
       SA1->( MsUnLock( ) )
       N3++
    Endif

    If "&" $ SA1->A1_NREDUZ 
       cAux := Alltrim( SA1->A1_NREDUZ )
       cAux := StrTran( cAux, "&", "E" )
       RecLock( "SA1", .F. )
       SA1->A1_NREDUZ := cAux
       SA1->( MsUnLock( ) )
       N4++
    Endif

    If "'" $ SA1->A1_NREDUZ 
       cAux := Alltrim( SA1->A1_NREDUZ )
       cAux := StrTran( cAux, "'", " " )
       RecLock( "SA1", .F. )
       SA1->A1_NREDUZ := cAux
       SA1->( MsUnLock( ) )
       N5++
    Endif

    If '"' $ SA1->A1_NREDUZ 
       cAux := Alltrim( SA1->A1_NREDUZ )
       cAux := StrTran( cAux, '"', " " )
       RecLock( "SA1", .F. )
       SA1->A1_NREDUZ := cAux
       SA1->( MsUnLock( ) )
       N6++
    Endif

    SA1->( dBSkip( ) )
    N++
Enddo                   

MsgInfo( Transform( N , "@E 999,999" ) + Chr( 13 ) + ;
         Transform( N1, "@E 999,999" ) + Chr( 13 ) + ;
         Transform( N2, "@E 999,999" ) + Chr( 13 ) + ;
         Transform( N3, "@E 999,999" ) + Chr( 13 ) + ;
         Transform( N4, "@E 999,999" ) + Chr( 13 ) + ;
         Transform( N5, "@E 999,999" ) + Chr( 13 ) + ;
         Transform( N6, "@E 999,999" ) + Chr( 13 ))
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LSMSGPVD บAutor ณAlexandre LonghinottiบData ณ 23/09/11     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mensagems informativas nos pedidos de Venda                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OMS                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LSMSGPVD(cMsg)
****************************
Local oButton1
Local oMultiGe1
Local cMultiGe1 := cMsg
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Mensagem" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

    @ 011, 012 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 218, 053 COLORS 0, 16777215 READONLY HSCROLL PIXEL
    @ 073, 193 BUTTON oButton1 PROMPT "Fechar" Action Close(oDlg) SIZE 037, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return 
