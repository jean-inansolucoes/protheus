#include "protheus.ch"
#include "topconn.ch"          
#include "protheus.ch" 
#include "rwmake.ch" 
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTALLXFUN  บAutor  ณRafael Parma       บ Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina a qual contempla todas as fun็๕es gen้ricas usadas   บฑฑ
ฑฑบ          ณnos programas personalizados.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTALLXSX3     บAutor  ณRafael Parma      Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ"RETORNA INFORMAวีES DO SX3 SOBRE UM DETERMINADO CAMPO"     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณExpC1 : Campo a ser pesquisado no SX3                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบRetorno   ณExpAA: Array com as informa็๕es sendo:                      บฑฑ
ฑฑบ          ณ[1]: AllTrim(X3Titulo())                                    บฑฑ
ฑฑบ          ณ[2]: SX3->X3_CAMPO                                          บฑฑ
ฑฑบ          ณ[3]: SX3->X3_TIPO                                           บฑฑ
ฑฑบ          ณ[4]: SX3->X3_TAMANHO                                        บฑฑ
ฑฑบ          ณ[5]: SX3->X3_DECIMAL                                        บฑฑ
ฑฑบ          ณ[6]: SX3->X3_PICTURE                                        บฑฑ
ฑฑบ          ณ[7]: SX3->X3_VALID                                          บฑฑ
ฑฑบ          ณ[8]: SX3->X3_VLDUSER                                        บฑฑ
ฑฑบ          ณ[9]: SX3->X3_USADO                                          บฑฑ
ฑฑบ          ณ[10]: SX3->X3_F3                                            บฑฑ
ฑฑบ          ณ[11]: SX3->X3_CONTEXT                                       บฑฑ
ฑฑบ          ณ[12]: SX3->X3_CBOX                                          บฑฑ
ฑฑบ          ณ[13]: SX3->X3_RELACAO                                       บฑฑ
ฑฑบ          ณ[14]: VisualSX3(ExpC1)                                      บฑฑ
ฑฑบ          ณ[15]: X3Obrigat(ExpC1)                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               

*-------------------------------*
User Function LTALLXSX3( ExpC1 )
*-------------------------------*
Local ExpAA := {}
Local cArea := GetArea()

	SX3->( dbSetOrder( 2 ) )
	SX3->( dbgotop( ) )
	
	If SX3->( dbSeek( ExpC1 ) )
		ExpAA := { AllTrim( X3Titulo( ) ) , SX3->X3_CAMPO     , SX3->X3_TIPO , SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_PICTURE, ;
		           SX3->X3_VALID          , SX3->X3_VLDUSER   , SX3->X3_USADO, SX3->X3_F3     , SX3->X3_CONTEXT, SX3->X3_CBOX   , ;
		           SX3->X3_RELACAO        , VisualSX3( ExpC1 ), X3Obrigat( ExpC1 ) }
	Else
	   U_LTALL001("LTALLXSX3" , "Nใo foi possivel verificar as informa็๕es do Campo [" + ExpC1 + "]", "Informe o Campo Correto!" )
		ExpAA := { nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil }
	EndIf
	
	RestArea( cArea )
	
Return( ExpAA )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTALL001      บAutor  ณRafael Parma      Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de apresenta็ใo de tela estilo (HELP) do Protheus.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณcTitulo   = Titulo o qual serแ apresentado na tela          บฑฑ
ฑฑ 			 ณcProblema = Descri็ใo do problema validado				  บฑฑ
ฑฑ			 ณcSolucao  = Descri็ใo da solu็ใo para o problema validado   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------*
User Function LTALL001( pcTitulo, pcProblema, pcSolucao )
*---------------------------------------------------------*
Local aSvKeys   := GetKeys()  

//ShowHelpDlg( TRANSFORM(pcTitulo, "@!"),  {pcProblema}, 5, {pcSolucao}, 5)
Help(NIL, NIL, pcTitulo, NIL, pcProblema, 1, 0, NIL, NIL, NIL, NIL, NIL, {pcSolucao})

RestKeys( aSvKeys , .T. )
	
Return Nil                                                                                                     
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTALLXACE     บAutor  ณRafael Parma      Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsแvel por trocar os caracteres especiais de um บฑฑ
ฑฑบ          ณparโmetro por caracteres normais.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS LATICINIO                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณNenhum                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTALLXACE ( pcTexto )

Local cTexto := pcTexto

// acento agudo
cTexto := StrTran( cTexto, "แ", "a" )
cTexto := StrTran( cTexto, "้", "e" )
cTexto := StrTran( cTexto, "ํ", "i" )
cTexto := StrTran( cTexto, "๓", "o" )
cTexto := StrTran( cTexto, "๚", "u" )
cTexto := StrTran( cTexto, "ม", "A" )
cTexto := StrTran( cTexto, "ษ", "E" )
cTexto := StrTran( cTexto, "อ", "I" )
cTexto := StrTran( cTexto, "ำ", "O" )
cTexto := StrTran( cTexto, "ฺ", "U" )

// acento circunflexo
cTexto := StrTran( cTexto, "โ", "a" )
cTexto := StrTran( cTexto, "๊", "e" )
cTexto := StrTran( cTexto, "๎", "i" )
cTexto := StrTran( cTexto, "๔", "o" )
cTexto := StrTran( cTexto, "๛", "u" )
cTexto := StrTran( cTexto, "ย", "A" )
cTexto := StrTran( cTexto, "ส", "E" )
cTexto := StrTran( cTexto, "ฮ", "I" )
cTexto := StrTran( cTexto, "ิ", "O" )
cTexto := StrTran( cTexto, "Û", "U" )

// til
cTexto := StrTran( cTexto, "ใ", "a" )
cTexto := StrTran( cTexto, "๕", "o" )
cTexto := StrTran( cTexto, "ร", "A" )
cTexto := StrTran( cTexto, "ี", "O" )

// ce-cedilha
cTexto := StrTran( cTexto, "็", "c" )
cTexto := StrTran( cTexto, "ว", "C" )

// trema
cTexto := StrTran( cTexto, "ü", "u" )
cTexto := StrTran( cTexto, "Ü", "U" )

// crase
cTexto := StrTran( cTexto, "เ", "a" )
cTexto := StrTran( cTexto, "่", "e" )
cTexto := StrTran( cTexto, "์", "i" )
cTexto := StrTran( cTexto, "๒", "o" )
cTexto := StrTran( cTexto, "๙", "u" )
cTexto := StrTran( cTexto, "ภ", "A" )
cTexto := StrTran( cTexto, "ศ", "E" )
cTexto := StrTran( cTexto, "ฬ", "I" )
cTexto := StrTran( cTexto, "า", "O" )
cTexto := StrTran( cTexto, "ู", "U" )

Return(cTexto)     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTALL002      บAutor  ณRafael Parma      Data ณ  30/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de valida็ใo da data do movimento dentro do perํodo. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑบParametrosณdDATA  = Data do movimento.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*------------------------------*
User Function LTALL002( dDATA )
*------------------------------*
Local aArea   := GetArea()
Local cTitulo := "Data do Movimento"
Local cSTATUS := "A"
Local dDtRet  := ctod("  /  /  ")
                   
	dbSelectArea("ZLC")
	dbSetOrder(3)
	dbGoTop()
	dbSeek ( xFilial ("ZLC") + cSTATUS )
	While ! ZLC->(EOF()) .and. ZLC->ZLC_FILIAL + ZLC->ZLC_STATUS == xFilial ("ZLC") + cSTATUS
		If dDATA >= ZLC->ZLC_DTINI .and. dDATA <= ZLC->ZLC_DTFIN
			dDtRet := dDATA
			Exit
		EndIf
		ZLC->(dbSkip())
	Enddo   
	
	If dDtRet != dDATA
		U_LTALL001(cTitulo, "A data informada nใo pertence a um perํodo vแlido.", "Verificar o cadastro de perํodos de movimento.")	
	EndIf
	
	RestArea ( aArea )
	
Return ( dDtRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณYIsBis     บAutor  ณRafael Parma       บ Data ณ  18/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar se o ano ้ bissexto.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------*
User Function YIsBis(nAno)      
*------------------------------*
Local lBis := .F.
	
	// Se ano m๓dulo 400 ้ 0 entใo bissexto
	// Senใo se ano m๓dulo 100 ้ 0 entใo nใo bissexto
	// Senใo se ano m๓dulo 4 ้ 0 entใo bissexto
	// Senใo nใo_bissexto
	If (nAno%400) == 0
	   lBis := .T.
	ElseIf (nAno%100) == 0
	   lBis := .F.
	ElseIf (nAno%4) == 0
	   lBis := .T.
	EndIf

Return ( lBis )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTGETPMM    บAutor  ณRafael Parma       บ Data ณ  19/11/09  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para retornar o valor mํnimo e mแximo      บฑฑ
ฑฑบ          ณdefinido no parโmetro.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------------*
User Function LTGETPMM(cMV_PAR, aMM) 
*-----------------------------------*
Local nPOS := 0
Local cPAR := ALLTRIM(GETMV(cMV_PAR))
    
	aMM  := {0,0}
	If Len(cPAR) > 0
		nPOS := At("/",cPAR)
		If nPOS > 1
			aMM[1] := VAL(SubSTR(cPAR,1,nPOS-1))
		EndIf
		If Len(cPAR) > nPOS
			aMM[2] := VAL(SubSTR(cPAR,nPOS+1,Len(cPAR)))
		EndIf
	EndIf
	
Return ( aMM )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTCHKLIN    บAutor  ณRafael Parma       บ Data ณ  25/02/10  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de valida็ใo para o produtor + loja dentro da linha, บฑฑ
ฑฑบ          ณutilizada na amarra็ใo do produtor a tabela de pre็o.       บฑฑ
ฑฑบ          ณCampo: ZL2_PRODUT                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*------------------------*
User Function LTCHKLIN()
*------------------------*
Local cLOJPRD := IIF(EMPTY(M->ZL2_LOJPRD),"0001",M->ZL2_LOJPRD)
Local lRET := .T.
	
	If Empty(M->ZL2_LINHA) .or. Empty(M->ZL2_PRODUT) 
		Return lRET
	EndIf
	
	dbSelectArea("ZL1")
	dbSetOrder(3)	//ZL1_FILIAL+ZL1_COD+ZL1_PRODUT+ZL1_LOJPRD
	dbGoTop()
	If ! dbSeek ( xFilial("ZL1") + M->ZL2_LINHA + M->ZL2_PRODUT + cLOJPRD )
		Alert("Produtor/Loja nใo relacionado a esta linha!")
		lRET := .F.
	EndIf
	
	If lRET
		dbSelectArea("ZL2")
		dbSetOrder(3)	//ZL2_FILIAL+ZL2_LINHA+ZL2_PRODUT+ZL2_LOJPRD
		dbGoTop()
		If dbSeek ( xFilial("ZL1") + M->ZL2_LINHA + M->ZL2_PRODUT + cLOJPRD )
			If ZL2->ZL2_COD != M->ZL2_COD
				Alert("Linha/Produtor/Loja jแ cadastrado como exce็ใo!")
				lRET := .F.
			EndIf
		EndIf	
	EndIf
    
	
Return ( lRET )     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTZ6CPRD    บAutor  ณRafael Parma       บ Data ณ  25/02/10  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de valida็ใo para o produtor + loja dentro da linha, บฑฑ
ฑฑบ          ณutilizada na amarra็ใo do produtor a tabela de pre็o.       บฑฑ
ฑฑบ          ณCampo: ZL6_PRODUT                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*------------------------*
User Function LTZ6CPRD()
*------------------------*
/*Local nLOJPRD := aScan(aHeader,{|x| Alltrim(x[2])=="ZL6_LOJPRD"})
Local cLOJPRD := ""*/
Local lRET := .T.
                                                                                   
	
	If Empty(M->ZL5_LINHA) .or. Empty(M->ZL6_PRODUT) 
		Return lRET
	EndIf
	
	dbSelectArea("ZL1")
	dbSetOrder(3)	//ZL1_FILIAL+ZL1_COD+ZL1_PRODUT+ZL1_LOJPRD
	dbGoTop()
	If ! dbSeek ( xFilial("ZL1") + M->ZL5_LINHA + SA2->A2_COD + SA2->A2_LOJA  )		
		If ! SuperGetMV("MV_ZLMVLD",,.F.)                         
			Alert("Produtor/Loja nใo relacionado a esta linha!")
			lRET := .F.	
		Else
			MsgInfo("Produtor/Loja nใo relacionado a esta linha!")
		EndIf
	Else
	  /*	dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek( xFilial("SA2") + M->ZL6_PRODUT )*/
		If SA2->A2_MSBLQL == "1" //bloqueado
			Alert("O cadastro deste produtor esta bloqueado!")
			lRET := .F.	
		EndIf
		
	
	EndIf
	
Return ( lRET )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTZ6QTDE    บAutor  ณRafael Parma       บ Data ณ  04/03/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de valida็ใo para quantidade maxima, minima e frequen-ฑฑ
ฑฑบ          ณcia de entrega do produtor.                                 บฑฑ
ฑฑบ          ณCampo: ZL6_QTDE                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

*------------------------*
User Function LTZ6QTDE()
*------------------------*
Local aArea   := GetArea()
Local nCODPRD := aScan(aHeader,{|x| Alltrim(x[2])=="ZL6_PRODUT"})
Local nLOJPRD := aScan(aHeader,{|x| Alltrim(x[2])=="ZL6_LOJPRD"})
Local cAliasTMP := GetNextAlias() 
Local hEnter    := chr(13)+chr(10)
Local lRET := .T.
	                                                                                    
	dbSelectArea("SA2")
	dbSetOrder(1)	//A2_FILIAL+A2_COD+A2_LOJA
	dbGoTop()   
	If dbSeek ( xFilial("SA2") + aCols[n,nCODPRD] + aCols[n,nLOJPRD]  )
		
		If ( M->ZL6_QTDE < SA2->A2_X_QMIN .AND. SA2->A2_X_QMIN > 0 ) .or. ( M->ZL6_QTDE > SA2->A2_X_QMAX .AND. SA2->A2_X_QMAX > 0 )
			Aviso("Aten็ใo","A quantidade informada esta fora dos limites do produtor.",{"OK"},2)
		EndIf 
		
		cQuery := "SELECT 															" + hEnter
		cQuery += "			MAX(ZL5.ZL5_DATA) ZL5_DATA								" + hEnter
		cQuery += "FROM " + RetSqlName("ZL5") + " ZL5								" + hEnter
		cQuery += "INNER JOIN " + RetSqlName("ZL6") + " ZL6		   					" + hEnter
		cQuery += "ON       ZL5.ZL5_FILIAL    = ZL6.ZL6_FILIAL  	                " + hEnter		
		cQuery += "AND      ZL5.ZL5_COD       = ZL6.ZL6_COD         	            " + hEnter		
		cQuery += "WHERE    ZL5.ZL5_FILIAL    = '" + xFilial("ZL5") + "'	 		" + hEnter
		cQuery += "AND 		ZL6.ZL6_PRODUT    = '" + aCols[n,nCODPRD] +  "'			" + hEnter
		cQuery += "AND 		ZL6.ZL6_LOJPRD    = '" + aCols[n,nLOJPRD] +  "'			" + hEnter
		cQuery += "AND 		ZL5.D_E_L_E_T_   != '*' 								" + hEnter
		cQuery += "AND 		ZL6.D_E_L_E_T_   != '*' 								" + hEnter
		
		MemoWrite("LTZ6QTDE.TXT",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		          
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
	    If !(cAliasTMP)->(EOF())
	    	nDIAS := M->ZL5_DATA - stod((cAliasTMP)->ZL5_DATA)
	    	If SA2->A2_X_FRENT == "1" .and. nDIAS > 1
	    		Aviso("Aten็ใo","Nใo hแ lan็amento com data anterior para este produtor.",{"OK"},2)
	    	ElseIf SA2->A2_X_FRENT == "2" .and. nDIAS == 1                                         
	    		Aviso("Aten็ใo","A data do lan็amento nใo confere com a frequ๊ncia de coleta do produtor.",{"OK"},2)
	    	EndIf
	    EndIf
	    (cAliasTMP)->(dbCloseArea())
		
	EndIf

	RestArea(aArea)
	
Return ( lRET )


//============================================================================\
/*/{Protheus.doc}LTALLXFUN
  ==============================================================================
	@description
	bUSCA SEQUENCIAL DO MOVIMENTO DO TRANSPORTADOR POR PLACA

	@author Alexandre Longhinotti <ti@tresbarras.ind.br>
	@version 1.0
	@since 06/11/2020

/*/
//============================================================================\
User Function LTZL7SEQ()
Local nSeq := "001"
Local cAliasTMP := GetNextAlias()
Local hEnter    := CHR(13) + CHR(10)
    
    If ! Empty (M->ZL7_DATA) .AND. ! Empty(M->ZL7_LINHA) .AND. ! Empty(M->ZL7_PLACA)

		// alimenta a quanditade da vazใo do transportador na data e linha
		cQuery := "	SELECT ZL7_SEQ						" + hEnter
		cQuery += "	FROM " + RetSQLName("ZL7") + " ZL7 						" + hEnter
		cQuery += " WHERE 													" + hEnter
		cQuery += " ZL7.ZL7_FILIAL 		= '" + xFilial("ZL7")    + "'   	" + hEnter		
		cQuery += " AND ZL7.ZL7_DATA    = '" + dtos(M->ZL7_DATA) + "'   	" + hEnter
		cQuery += " AND ZL7.ZL7_TRANSP  = '" + M->ZL7_TRANSP     + "'		" + hEnter
		cQuery += " AND ZL7.ZL7_LINHA   = '" + M->ZL7_LINHA      + "'   	" + hEnter
		cQuery += " AND ZL7.ZL7_TPROD  != 'O'								" + hEnter
		cQuery += " AND ZL7.D_E_L_E_T_ != '*'								" + hEnter
		
		
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)		
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		
		ProcRegua((cAliasTMP)->(RecCount()))

		While !(cAliasTMP)->(EOF())
			If ! Empty ( (cAliasTMP)->ZL7_SEQ )
				nSeq := CVALTOCHAR(STRZERO((VAL((cAliasTMP)->ZL7_SEQ)+1),3))
			EndIf

		IncProc()	
		(cAliasTMP)->(dbSkip())
		Enddo				
		(cAliasTMP)->(dbCloseArea())     
	ENDiF

Return ( nSeq )
// FIM da Funcao LTALLXFUN
//==============================================================================






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGLALL001      บAutor  ณMarcelo Jonerบ    Data ณ  10/02/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de apresenta็ใo de tela estilo (HELP) do Protheus.   บฑฑ
ฑฑบ          ณUtilizada especificamente para o Laticinio                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GLALL001(cTitulo, cProblema, cSolucao)

Local aSvKeys		:= GetKeys()

Default cTitulo		:= ""
Default cProblema	:= ""
Default cSolucao	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta fun็ใo padrใo de apresenta็ใo da mensagemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Tone()
Help(NIL, NIL, cTitulo, NIL, cProblema, 1, 0, NIL, NIL, NIL, NIL, NIL, {cSolucao})

RestKeys(aSvKeys, .T.)

Return 





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณGLCPOBRW  บAutor  ณMarcelo Joner        บ Data ณ 12/02/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por retornar array com os campos do aliasบฑฑ
ฑฑบ          ณinformado que estใo configurados para exibi็ใo no browse.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GLCPOBRW(cTabela)

Local aCampos	:= {Nil}

Default cTabela	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta regras caso tenha sido informado o aliasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If !EMPTY(cTabela)
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	If SX3->(dbSeek(cTabela))
		While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cTabela
			If SX3->X3_BROWSE == "S"
				AADD(aCampos, ALLTRIM(SX3->X3_CAMPO))
			EndIf
			
			SX3->(dbSkip())
		End
	EndIf
EndIf

Return aCampos





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGLENCHOICE บAutor  ณMarcelo Joner      บ Data ณ  12/02/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela carga dos arrays de utiliza็ใo no   บฑฑ
ฑฑบ          ณenchoice conforme os parametros de alias e folder.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GLENCHOICE(nOpcao, cAlias, cDescricao, cCpoNoAlter, cCpoNoLoad)
                 
Local cFolder		:= ""
Local aAlterCad 	:= {}    
Local aArea			:= GetArea()
Local aCpoCad   	:= {'NOUSER'}

Default cDescricao	:= ""
Default cCpoNoAlter	:= ""
Default cCpoNoLoad	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCaso tenha sido informado um folder, carrega o c๓digo do mesmoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If !EMPTY(cDescricao)
	dbSelectArea("SXA")
	SXA->(dbSetOrder(1))
	SXA->(dbGoTop())
	If SXA->(dbSeek(cAlias))
		While SXA->(!EOF()) .AND. SXA->XA_ALIAS == cAlias
		    If ALLTRIM(UPPER(SXA->XA_DESCRIC)) == ALLTRIM(UPPER(cDescricao))
				cFolder := SXA->XA_ORDEM
				exit
			EndIf
			SXA->(dbSkip())
		End
	Else
		U_GCALL001("Aten็ใo", "Nใo foi localizado defini็๕es de pastas para o alias " + ALLTRIM(cAlias), "Favor entrar em contato com o departamento de TI e informar o ocorrido.")
		Return {}
	EndIf
EndIf  

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbGoTop()) 
SX3->(dbSeek(cAlias))
While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == ALLTRIM(UPPER(cAlias)) 
	If IIF(!EMPTY(cFolder), ALLTRIM(SX3->X3_FOLDER) == ALLTRIM(cFolder), .T.) .AND. X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. IIF(!EMPTY(cCpoNoLoad), !(ALLTRIM(SX3->X3_CAMPO) $ cCpoNoLoad), .T.)
		AADD(aCpoCad, ALLTRIM(SX3->X3_CAMPO))
		
		If IIF(!EMPTY(cCpoNoAlter), !(ALLTRIM(SX3->X3_CAMPO) $ cCpoNoAlter), .T.)
			AADD(aAlterCad, ALLTRIM(SX3->X3_CAMPO))
		EndIf
	EndIf
	SX3->(dbSkip())
End     

RestArea(aArea)

Return IIF(nOpcao == 1, aCpoCad, aAlterCad)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณALTERA VALOR DO PARAMETRO MV_ZL00014 com o numero de dias para busca das coletas na API do MilkUP
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
User Function DIASMKP()
Local nDias := GETMV("MV_ZL00014",, 0) 
Local nOpc := 0
Local cCab := "Dias Col. API - Atual ้: " + ALLTRIM(STR(nDias))	+ " Dias"

	oDlgY := MSDialog():New(000,000,050,250,cCab,,,.F.,,,,,,.T.,,,.T. )
	oSayData := TSay():New(010,004,{|| "Alterar Para:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	@ 009, 040 MSGET oData  	VAR nDias	PICTURE "@E 99" OF oDlgY WHEN .T. PIXEL SIZE 030,008 HASBUTTON
	oBtnData := TButton():New(007, 80, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 037, 012,,,, .T.,,"",,,, .F.)
	oDlgY:Activate(,,,.T.)
	If nOpc == 1
		PUTMV("MV_ZL00014",nDias)
	EndIf
Return


User Function ACRESERV()

Local nFilial
Local nArmazem
Local nProduto
Local nReserva
Local nOpc := 0
Local cCab := "Informe os dados a baixo para ajustar o saldo de reserva"

	oDlgY := MSDialog():New(000,000,050,250,cCab,,,.F.,,,,,,.T.,,,.T. )
	oSayData := TSay():New(010,004,{|| "Filial:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	@ 009, 040 MSGET oData  	VAR nFilial	PICTURE "@E 9999999" OF oDlgY WHEN .T. PIXEL SIZE 030,008 HASBUTTON
	oSayData := TSay():New(020,004,{|| "Armaz้m:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,042,008)
	@ 019, 040 MSGET oData  	VAR nArmazem	PICTURE "@E 99" OF oDlgY WHEN .T. PIXEL SIZE 040,008 HASBUTTON
	oSayData := TSay():New(030,004,{|| "Produto:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,052,008)
	@ 029, 040 MSGET oData  	VAR nProduto	PICTURE "@E 99999999" OF oDlgY WHEN .T. PIXEL SIZE 050,008 HASBUTTON
	oSayData := TSay():New(040,004,{|| "Saldo Reserva:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,062,008)
	@ 039, 040 MSGET oData  	VAR nReserva	PICTURE "@E 999,999,999.9999" OF oDlgY WHEN .T. PIXEL SIZE 060,008 HASBUTTON
	oBtnData := TButton():New(047, 80, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 067, 012,,,, .T.,,"",,,, .F.)
	oDlgY:Activate(,,,.T.)
	If nOpc == 1
			dBSelectArea( "SB2" )
			SB2->( dBSetOrder( 1 ) )
			SB2->( dBGoTop() )
			If SB2->( dBSeek( nFilial + nProduto + nArmazem ) )
			   RecLock( "SB2", .F. )
			   SB2->B2_RESERVA := nReserva
			   SB2->( MsUnLock( ) )
			Endif

	EndIf
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณALTERA VALOR DO PARAMETRO MV_TCFDFOL com o dia de disponibiliza็ใo dos recibos de pagametnos no app MeuRH
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
User Function DIASFOL()
Local nDias := GETMV("MV_TCFDFOL",, 0) 
Local nOpc := 0
Local cCab := "Dias de disp Atual ้: " + ALLTRIM(nDias)	

	oDlgY := MSDialog():New(000,000,050,250,cCab,,,.F.,,,,,,.T.,,,.T. )
	oSayData := TSay():New(010,004,{|| "Alterar Para:"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	@ 009, 040 MSGET oData  	VAR nDias	PICTURE "@E 99" OF oDlgY WHEN .T. PIXEL SIZE 030,008 HASBUTTON
	oBtnData := TButton():New(007, 80, "&OK", oDlgY, {|| (nOpc := 1, oDlgY:End())}, 037, 012,,,, .T.,,"",,,, .F.)
	oDlgY:Activate(,,,.T.)
	If nOpc == 1
		PUTMV("MV_TCFDFOL",nDias)
	EndIf
Return

