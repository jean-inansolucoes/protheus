#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "protheus.CH"
#Include "ap5mail.ch"
#Include "tbiconn.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "RPTDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LSFINR07³ Autor ³ ALEXANDRE LONGHINOTTI  ³ Data ³ 10/10/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ INCLUSÃ COBRANÇA DAYCOVAL		                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Incluir o parametro                        ³
//³MV_LSFIN01 - Multa a ser impressa no boleto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


User Function LSFIN015(cNum, cSerie ,Banco , Agen ,Conta )
*********************************************************************************
LOCAL   aCampos      := {}
Local   hEnter       := Chr( 13 )
LOCAL   cMarca       := IIf(alltrim(FunName())=="MATA410" .OR. ISINCALLSTACK("MATA460A"),"",GetMark())
LOCAL   lInverte     := .f.
LOCAL   aMarked      := {}
LOCAL   aDesc        := { "Este programa incluios títulos em",;
						  "cobranca bancaria de acordo com",;
						  "os parametros informados"}

PRIVATE nRegSel      := 0
PRIVATE Exec         := .F.
PRIVATE cIndexName   := ''
PRIVATE cIndexKey    := ''
PRIVATE cFilter      := ''
PRIVATE dvnn         := 0
PRIVATE dvcb         := 0
PRIVATE dv           := 0
PRIVATE _cBanco  	 := "707"
PRIVATE c_Banco	     := Banco
PRIVATE c_Agen		 := Agen
PRIVATE c_Conta		 := Conta


Tamanho  := "M"
titulo   := "Inclusão em Cobrança"
cDesc1   := "Este programa destina-se a inclusao de títulos em cobrança do Banco Daycoval."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "LSFIN015"
lEnd     := .F.
cPerg    := "LSFIN00015"

aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0

dBSelectArea( "SE1" )

AjustaSX1()

If cNum == nil
	If !Pergunte( cPerg,.T., "Parâmetros - Cobrança DAYCOVAL" )
		Set Filter to
		Return
	Endif
Else
	mv_par19     := 2
	c_Banco	     := Banco
	c_Agen		 := Agen
	c_Conta		 := Conta
	
EndIf

cSql := " SELECT SE1.E1_OK,      " + hEnter
cSql += "        SE1.E1_PREFIXO, " + hEnter
cSql += "        SE1.E1_NUM,     " + hEnter
cSql += "        SE1.E1_TIPO,    " + hEnter
cSql += "        SE1.E1_PARCELA, " + hEnter
cSql += "        SE1.E1_CLIENTE, " + hEnter
cSql += "        SE1.E1_LOJA,    " + hEnter
cSql += "        SE1.E1_VENCTO,  " + hEnter
cSql += "        SE1.E1_EMISSAO, " + hEnter
cSql += "        SE1.E1_PORTADO, " + hEnter
cSql += "        SE1.E1_AGEDEP,  " + hEnter
cSql += "        SE1.E1_CONTA,   " + hEnter
cSql += "        SE1.E1_NUMBOR,  " + hEnter
cSql += "        SE1.E1_NUMBCO,  " + hEnter
cSql += "        SE1.E1_SALDO,   " + hEnter
cSql += "        SE1.E1_X_CARGA, " + hEnter
cSql += "        SE1.E1_X_FRMPG	 " + hEnter
cSql += "                        " + hEnter
cSql += " FROM " + RetSqlName( "SE1" ) + " SE1            " + hEnter
cSql += "                                                  " + hEnter
cSql += " WHERE SE1.E1_FILIAL    = '" + XFILIAL("SE1") + "'" + hEnter

If cNum <> nil
	
	cSql += "   AND ( SE1.E1_PREFIXO >= '" + cSerie + "' AND SE1.E1_PREFIXO <= '" + cSerie + "')" + hEnter
	cSql += "   AND ( SE1.E1_NUM     >= '" + cNum + "' AND SE1.E1_NUM     <= '" + cNum + "')" + hEnter
	
Else
	cSql += "   AND ( SE1.E1_PREFIXO >= '" + MV_PAR01 + "' AND SE1.E1_PREFIXO <= '" + MV_PAR02 + "')" + hEnter
	cSql += "   AND ( SE1.E1_NUM     >= '" + MV_PAR03 + "' AND SE1.E1_NUM     <= '" + MV_PAR04 + "')" + hEnter
	cSql += "   AND ( SE1.E1_PARCELA >= '" + MV_PAR05 + "' AND SE1.E1_PARCELA <= '" + MV_PAR06 + "')" + hEnter
	cSql += "   AND ( SE1.E1_X_CARGA >= '" + MV_PAR07 + "' AND SE1.E1_X_CARGA <= '" + MV_PAR08 + "')" + hEnter
	cSql += "   AND ( SE1.E1_NUMBOR  >= '" + MV_PAR09 + "' AND SE1.E1_NUMBOR  <= '" + MV_PAR10 + "')" + hEnter
	cSql += "   AND ( SE1.E1_CLIENTE >= '" + MV_PAR11 + "' AND SE1.E1_CLIENTE <= '" + MV_PAR12 + "')" + hEnter
	cSql += "   AND ( SE1.E1_LOJA    >= '" + MV_PAR13 + "' AND SE1.E1_LOJA    <= '" + MV_PAR14 + "')" + hEnter
	cSql += "   AND ( SE1.E1_VENCTO  >= '" + DTOS( MV_PAR15 ) +"' AND SE1.E1_VENCTO  <= '" + DTOS( MV_PAR16 ) + "')" + hEnter
	cSql += "   AND ( SE1.E1_EMISSAO >= '" + DTOS( MV_PAR17 ) +"' AND SE1.E1_EMISSAO <= '" + DTOS( MV_PAR18 ) + "')" + hEnter
//	cSql += "   AND ( SE1.E1_X_FRMPG = 'BOL')" + hEnter	// Filtra forma de pagamento = BOL -> BOLETO
	If 	mv_par20 = 1  // reimprime boletos = sim
		cSql += "   AND ( SE1.E1_PORTADO    = '" + _cBanco + "')"
	ElseIf mv_par20 = 2  // reimprime boletos = não
		cSql += "   AND ( SE1.E1_PORTADO    = '' )"
	ElseIf mv_par20 = 3  // reimprime boletos = ambos
		cSql += "   AND ( SE1.E1_PORTADO    = '" + _cBanco + "' OR SE1.E1_PORTADO = '' )"
	EndIf
	
Endif

cSql += "	AND SE1.E1_SALDO	 > 0" + hEnter
cSql += "   AND SE1.D_E_L_E_T_  <> '*'" + hEnter
cSql += "	ORDER BY SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA " + hEnter

MemoWrite( ProcName() + ".SQL", cSql )

TCQUERY cSql NEW ALIAS "TMPBOL1"
TCSETFIELD("TMPBOL1","E1_EMISSAO","D",8,0)
TCSETFIELD("TMPBOL1","E1_VENCTO" ,"D",8,0)
dbSelectArea("TMPBOL1")
aStruc := dbStruct()
cArqTemp := CriaTrab(aStruc)
dbUseArea( .T. ,, cArqTemp , "TMPBOL2" )

APPEND FROM TMPBOL1
cIndTSAL := CriaTrab(NIL,.F.)

dbselectarea("TMPBOL1")
dbCloseArea("TMPBOL1")

dbSelectArea("TMPBOL2")
dbGoTop()

aCampos := {}
aAdd(aCampos, {"E1_OK"     ,"",""          ,""})
aAdd(aCampos, {"E1_PREFIXO","","Prefixo"   ,""})
aAdd(aCampos, {"E1_NUM"    ,"","Nr.Título" ,""})
aAdd(aCampos, {"E1_PARCELA","","Parcela"   ,""})
aAdd(aCampos, {"E1_TIPO"   ,"","Tipo"      ,""})
aAdd(aCampos, {"E1_PORTADO","","Portador"  ,""})
aAdd(aCampos, {"E1_SALDO"  ,"","Valor"     ,"@E 9,999,999.99"})
aAdd(aCampos, {"E1_NUMBOR ","","Bordero "  ,""})
aAdd(aCampos, {"E1_NUMBCO ","","Nosso Núm" ,""})
aAdd(aCampos, {"E1_EMISSAO","","Emissão"   ,""})
aAdd(aCampos, {"E1_VENCTO" ,"","Vencimento",""})
aAdd(aCampos, {"E1_CLIENTE","","Cliente"   ,""})
aAdd(aCampos, {"E1_LOJA"   ,"","Loja"      ,""})
aAdd(aCampos, {"E1_X_CARGA" ,"","Carga"	   ,""})
aAdd(aCampos, {"E1_X_FRMPG" ,"","Carga"	   ,""})

#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF

dbGoTop()
If mv_par19 = 1
	DEFINE MSDIALOG oDlg TITLE "Seleção de Títulos Daycoval" From 1,1 To 400,950 OF oMainWnd PIXEL
	
	oMark := MsSelect():New("TMPBOL2","E1_OK",,aCampos,@lInverte,@cMarca,{1,1,170,475})
	@ 180,010 Get nRegSel When .F. Size 35,25 Object _oReg
	@ 180,445 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
	@ 180,410 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
	
	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:bMark := {|| fContSel()}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAll(cMarca,oDlg,_oReg)}
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	Exec := .T.
EndIf

dbSelectArea("TMPBOL2")
dbGoTop()
Do While !Eof()
	If mv_par19 = 2 .OR. Marked("E1_OK")
		AADD(aMarked,.T.)
	Else
		AADD(aMarked,.F.)
	EndIf
	dbSkip()
EndDo
dbGoTop()

If Exec
	Processa({|lEnd|MontaRel( aMarked,cNum,cSerie,Banco,Agen,Conta ) } )
Endif
RetIndex("SE1")
fErase(cIndexName+OrdBagExt())

dbSelectArea("TMPBOL2")
dbCloseArea("TMPBOL2")

Return Nil


/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Atualiza o contador de registros selecionados
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function fContSel()
**************************
If Marked("E1_OK")
	nRegSel++
Else
	nRegSel--
Endif
_oReg:Refresh()
Return

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Marca/Desmarca todos os registros
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

Static Function fMarkAll(cMarca,oDlg)
*************************************
Local nRecno := Recno()
dbSelectArea("TMPBOL2")
dbGotop()
Do While !Eof()
	RecLock("TMPBOL2",.F.)
	If !Marked("E1_OK")
		E1_OK := cMarca
		nRegSel++
	Else
		E1_OK := "  "
		nRegSel--
	Endif
	MsUnlock()
	dbSkip()
EndDo
dbGoto(nRecno)
oDlg:Refresh()
_oReg:Refresh()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER SICREDI COM COD. BARRAS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel( aMarked,cNum,cSerie,Banco,Agen,Conta )
*****************************************************************
LOCAL n 	:= 0
Local nCnpj	:= SM0->M0_CGC

LOCAL aDadosBanco

LOCAL i            := 1
LOCAL nRec         := 0
Local nTit
Local cParcela
Local cDoc

DbSelectArea ("TMPBOL2")
dbGoTop()
Do While !EOF()
	nRec := nRec + 1
	dbSkip()
EndDo
dbGoTop()
ProcRegua(nRec)

i := 1
DbSelectArea("TMPBOL2")
Do While  !EOF()
	
	
	If mv_par19 = 2 .OR. aMarked[i]
		
		nTit := E1_NUM
		cParcela := Alltrim(E1_PARCELA)
		cDoc := "boleto_"+nTit+"_"+cParcela
		
		
		dBSelectArea( "SE1" )
		SE1->( dBSetOrder( 1 ) )
		SE1->( dBGoTop( ) )
		If !SE1->( dBSeek( xFilial( "SE1" ) + TMPBOL2->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO),.T.) )
			MsgBox("Titulo não localizado [ " + TMPBOL2->E1_PREFIXO + " ]/[" + TMPBOL2->E1_NUM + "]/[" + TMPBOL2->E1_PARCELA + "] , [SE1]. Favor verificar !" )
			Return()
		Endif
		
		//Posiciona o SA6 (Bancos)
		dBSelectArea("SA6")
		SA6->( dBSetOrder( 1 ) )
		SA6->( dBgotop() )
		If cNum <> nil
			lFound := SA6->( MsSeek(xFilial( "SA6" ) + c_Banco + c_Agen + c_Conta ) )
		Else
			lFound := SA6->( MsSeek( xFilial( "SA6" ) + MV_PAR21 + MV_PAR22 + MV_PAR23 ) )
		EndIf
		If !lFound
			If cNum <> nil
				MsgBox("Banco não localizado, Bco [ " + c_Banco + " ]/Ag.: [" + c_Agen + "]/CC: [" + c_Conta + "] , [SA6]. Favor verificar !" )
			Else
				MsgBox("Banco não localizado, Bco [ " + MV_PAR21 + " ]/Ag.: [" + MV_PAR22 + "]/CC: [" + MV_PAR23 + "] , [SA6]. Favor verificar !" )
			Endif
			Return()
		EndIf
		
		//Posiciona na Arq de Parametros CNAB
		DbSelectArea( "SEE" )
		SEE->( dBSetOrder( 1 ) )
		SEE->( dBgotop( ) )
		lFound := .T.
		If cNum <> nil
			lFound := SEE->( MsSeek( xFilial( "SEE" ) + c_Banco + c_Agen + c_Conta ) )
		Else
			lFound := SEE->( MsSeek( xFilial( "SEE" ) + MV_PAR21 + MV_PAR22 + MV_PAR23 ) )
		EndIf
		If !lFound
			If cNum <> nil
				MsgBox("Parametros do Banco não localizados, Bco [ " + c_Banco + " ]/Ag.: [" + c_Agen + "]/CC: [" + c_Conta + "] , [SEE]. Favor verificar !" )
			Else
				MsgBox("Parametros do Banco não localizados, Bco [ " + MV_PAR21 + " ]/Ag.: [" + MV_PAR22 + "]/CC: [" + MV_PAR23 + "] , [SEE]. Favor verificar !" )
			Endif
			Return()
		EndIf
		
		//Posiciona o SA1 (Cliente)
		DbSelectArea( "SA1" )
		SA1->( dBSetOrder( 1 ) )
		SA1->( dBGoTop( ) )
		If !SA1->( dBSeek( xFilial( "SA1" ) + TMPBOL2->E1_CLIENTE + TMPBOL2->E1_LOJA ) )
			MsgBox( "Cliente não localizado, [" + TMPBOL2->E1_CLIENTE + "]/[" + TMPBOL2->E1_LOJA + "], [SA1]. Favor verificar !" )
			Return()
		Endif
		
		DbSelectArea("TMPBOL2")
		aDadosBanco  := { "707"	                                                      ,; // [1]Numero do Banco
		SA6->A6_NOME      	            	                 	      ,; // [2]Nome do Banco
		SUBSTR(SA6->A6_AGENCIA, 1, 4)                          	      ,; // [3]Agência
		SA6->A6_NUMCON											      ,; // [4]Conta Corrente
		SA6->A6_DVCTA											  	      ,; // [5]Dígito da conta corrente
		SEE->EE_SUBCTA         								           } // [6]Posto
		
		
		
		
		If mv_par19 = 2 .OR. aMarked[i]
			
			DbSelectArea("SE1")
			If Empty(SE1->E1_NUMBCO) .AND. SUBSTR(SE1->E1_TIPO,3,1) != "-"
				RecLock("SE1",.f.)
				SE1->E1_PORTADO	:= SUBSTR(aDadosBanco[1],1,3)
				SE1->E1_AGEDEP	:= aDadosBanco[3]               // Agência
				SE1->E1_CONTA   := aDadosBanco[4]				// Conta sem dig verificador
				
				If Empty( SE1->E1_NUMBOR )
					SE1->E1_SITUACA  := "0"
				EndIf
				MsUnlock()
				
			EndIf
			DbSelectArea("SE1")
			n := n + 1
			
		EndIf
		
		
	EndIf
	DbSelectArea("TMPBOL2")
	dbskip()
	IncProc()
	i := i + 1
	
EndDo



Return nil



//******************************************************************************
// Ajusta as perguntas (SX1) da rotina
//******************************************************************************

Static Function AjustaSX1()

aRegs  	:= {}
aHelp1  := {}
aHelp2  := {}
aHelp3  := {}
aHelp4	:= {}
aHelp5	:= {}
aHelp6	:= {}
aHelp7	:= {}
aHelp8	:= {}
aHelp9	:= {}
aHelp10	:= {}
aHelp11	:= {}
aHelp12	:= {}
aHelp13	:= {}
aHelp14	:= {}
aHelp15	:= {}
aHelp16	:= {}
aHelp17	:= {}
aHelp18	:= {}
aHelp19	:= {}
aHelp20	:= {}
aHelp21	:= {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd(aRegs,{cPerg,"01","Prefixo de    ?","Prefixo de    ?","Prefixo de    ?","mv_ch1" ,"C",TAMSX3("E1_PREFIXO")[1] ,0,0,"G","			","mv_par01",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"02","Prefixo até   ?","Prefixo até   ?","Prefixo até   ?","mv_ch2" ,"C",TAMSX3("E1_PREFIXO")[1] ,0,0,"G","			","mv_par02",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"03","Titulo de     ?","Titulo de     ?","Titulo de     ?","mv_ch3" ,"C",TAMSX3("E1_NUM")	[1] ,0,0,"G","		     	","mv_par03",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"04","Titulo até    ?","Titulo até    ?","Titulo até    ?","mv_ch4" ,"C",TAMSX3("E1_NUM")	[1] ,0,0,"G","			    ","mv_par04",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"05","Parcela de    ?","Parcela de    ?","Parcela de    ?","mv_ch5" ,"C",TAMSX3("E1_PARCELA")[1] ,0,0,"G","			","mv_par05",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"06","Parcela até   ?","Parcela até   ?","Parcela até   ?","mv_ch6" ,"C",TAMSX3("E1_PARCELA")[1] ,0,0,"G","			","mv_par06",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"07","Carga de      ?","Carga de      ?","Carga de      ?","mv_ch7" ,"C",TAMSX3("E1_X_CARGA")[1] ,0,0,"G","			","mv_par07",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","DAK" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"08","Carga até     ?","Carga até     ?","Carga até     ?","mv_ch8" ,"C",TAMSX3("E1_X_CARGA")[1] ,0,0,"G","			","mv_par08",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","DAK" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"09","Bordero de    ?","Bordero de    ?","Bordero de    ?","mv_ch9" ,"C",TamSX3("E1_NUMBOR")	[1]	,0,0,"G","			","mv_par09",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SEAR" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"10","Bordero até   ?","Bordero até   ?","Bordero até   ?","mv_ch10","C",TamSX3("E1_NUMBOR")	[1] ,0,0,"G","			","mv_par10",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SEAR" ,"","","",    			 ""})
aAdd(aRegs,{cPerg,"11","Cliente de    ?","Cliente de    ?","Cliente de    ?","mv_ch11","C",TamSX3("E1_CLIENTE")[1]	,0,0,"G","			","mv_par11",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SA1" ,"","","",    			 ""})
aAdd(aRegs,{cPerg,"12","Cliente até   ?","Cliente até   ?","Cliente até   ?","mv_ch12","C",TamSX3("E1_CLIENTE")[1] ,0,0,"G","			","mv_par12",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SA1" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"13","Loja de       ?","Loja de       ?","Loja de       ?","mv_ch13","C",TamSX3("E1_LOJA")	[1]	,0,0,"G","			","mv_par13",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"14","Loja até      ?","Loja até      ?","Loja até      ?","mv_ch14","C",TamSX3("E1_LOJA")	[1]	,0,0,"G","			","mv_par14",			"",				"",				"","","",		"",		  "",		"","","",	  "",	  "",	  "","","","","","","","","","","","",   "" ,"","","",               ""})
aAdd(aRegs,{cPerg,"15","Vencimento de ?","Vencimento de ?","Vencimento de ?","mv_ch15","D",08                      ,0,0,"G","			","mv_par15",         	"",        		"",         	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"16","Vencimento até?","Vencimento até?","Vencimento até?","mv_ch16","D",08						,0,0,"G","			","mv_par16",         	"", 	   	    "",    	     	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"17","Emissão de    ?","Emissão de    ?","Emissão de    ?","mv_ch17","D",08                      ,0,0,"G","			","mv_par17",         	"",        		"",         	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"18","Emissão até   ?","Emissão até   ?","Emissão até   ?","mv_ch18","D",08						,0,0,"G","			","mv_par18",         	"", 	   	    "",    	     	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"19","Selec Titulos ?","Selec Titulos ?","Selec Titulos ?","mv_ch19","N",01						,0,0,"C","naovazio()","mv_par19",		 "Sim",			 "Sim",			 "Sim","","",	 "Nao",	   "Nao",	 "Nao","","",	  "",	  "",	  "","","","","","","","","","","","",   "" ,"","","",               ""})
aAdd(aRegs,{cPerg,"20","Reimp Boletos ?","Reimp Boletos ?","Reimp Boletos ?","mv_ch20","N",01						,0,0,"C","naovazio()","mv_par20",		 "Sim",			 "Sim",			 "Sim","","",	 "Nao",	   "Nao",	 "Nao","","","Ambos","Ambos","Ambos","","","","","","","","","","","",   "" ,"","","",               ""})
aAdd(aRegs,{cPerg,"21","Banco         ?","Banco         ?","Banco         ?","mv_ch21","C",TAMSX3("E1_PORTADO")[1]  ,0,0,"G","			","mv_par21",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SEEBOL" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"22","Agencia       ?","Agencia       ?","Agencia       ?","mv_ch22","C",TAMSX3("E1_AGEDEP ")[1]  ,0,0,"G","			","mv_par22",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"23","Conta         ?","Conta         ?","Conta         ?","mv_ch23","C",TAMSX3("E1_CONTA  ")[1]  ,0,0,"G","			","mv_par23",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aHelp1 , "Informe o Prefixo inicial do título a   ")
Aadd( aHelp1 , "ser filtrado.	 				  		")
Aadd( aHelp2 , "Informe o Prefixo final do título a ser ")
Aadd( aHelp2 , "filtrado.								")
Aadd( aHelp3 , "Informe o Título inicial a ser filtrado.")
Aadd( aHelp4 , "Informe o Título final a ser filtrado.  ")
Aadd( aHelp5 , "Informe a parcela inicial a ser filtrada")
Aadd( aHelp6 , "Informe a parcela final a ser filtrada.	")
Aadd( aHelp7 , "Informe a carga inicial a ser filtrada.	")
Aadd( aHelp8 , "Informe a carga final a ser filtrada.	")
Aadd( aHelp9 , "Informe o Bordero inicial a ser filtrado")
Aadd( aHelp10, "Informe o Bordero final a ser filtrado.	")
Aadd( aHelp11, "Informe o Cliente inicial a ser filtrado")
Aadd( aHelp12, "Informe o Cliente final a ser filtrado.	")
Aadd( aHelp13, "Informe a loja do cliente inicial a ser	")
Aadd( aHelp13, "filtrada.								")
Aadd( aHelp14, "Informe a loja do cliente final a ser 	")
Aadd( aHelp14, "filtrada.								")
Aadd( aHelp15, "Informe o vencimento inicial ser 		")
Aadd( aHelp15, "filtrado.								")
Aadd( aHelp16, "Informe o vencimento final ser filtrado.")
Aadd( aHelp17, "Informe a emissão inicial ser filtrado.	")
Aadd( aHelp18, "Informe a emissão final ser filtrado.	")
Aadd( aHelp19, "Informe se deseja realizar a seleção dos")
Aadd( aHelp19, "Títulos.								")
Aadd( aHelp19, "Sim = será apresentada tela para seleção")
Aadd( aHelp19, "dos títulos.							")
Aadd( aHelp19, "Não = Será realizada impressão dos bole-")
Aadd( aHelp19, "tos de acordo com parâmetros Definidos.	")
Aadd( aHelp20, "Informe se deseja reimprimir boletos.	")
Aadd( aHelp20, "Sim= Serão apresentados na seleção os 	")
Aadd( aHelp20, "títulos com boletos já impressos.		")
Aadd( aHelp20, "Não= Serão apresentados na seleção os 	")
Aadd( aHelp20, "títulos sem boletos.					")
Aadd( aHelp20, "Ambos= Serão apresentados na seleção 	")
Aadd( aHelp20, "todos os títulos.						")
Aadd( aHelp21, "Informar o banco a ser amarrado como 	")
Aadd( aHelp21, "portador do título caso seja a primeira ")
Aadd( aHelp21, "impressão do boleto.					")

dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j, aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o Help dos campos no arquivo de Help³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSX1Help("P." + cPerg + "01.", aHelp1, aHelp1, aHelp1)
PutSX1Help("P." + cPerg + "02.", aHelp2, aHelp2, aHelp2)
PutSX1Help("P." + cPerg + "03.", aHelp3, aHelp3, aHelp3)
PutSX1Help("P." + cPerg + "04.", aHelp4, aHelp4, aHelp4)
PutSX1Help("P." + cPerg + "05.", aHelp5, aHelp5, aHelp5)
PutSX1Help("P." + cPerg + "06.", aHelp6, aHelp6, aHelp6)
PutSX1Help("P." + cPerg + "07.", aHelp7, aHelp7, aHelp7)
PutSX1Help("P." + cPerg + "08.", aHelp8, aHelp8, aHelp8)
PutSX1Help("P." + cPerg + "09.", aHelp9, aHelp9, aHelp9)
PutSX1Help("P." + cPerg + "10.",aHelp10,aHelp10,aHelp10)
PutSX1Help("P." + cPerg + "11.",aHelp11,aHelp11,aHelp11)
PutSX1Help("P." + cPerg + "12.",aHelp12,aHelp12,aHelp12)
PutSX1Help("P." + cPerg + "13.",aHelp13,aHelp13,aHelp13)
PutSX1Help("P." + cPerg + "14.",aHelp14,aHelp14,aHelp14)
PutSX1Help("P." + cPerg + "15.",aHelp15,aHelp15,aHelp15)
PutSX1Help("P." + cPerg + "16.",aHelp16,aHelp16,aHelp16)
PutSX1Help("P." + cPerg + "17.",aHelp17,aHelp17,aHelp17)
PutSX1Help("P." + cPerg + "18.",aHelp18,aHelp18,aHelp18)
PutSX1Help("P." + cPerg + "19.",aHelp19,aHelp19,aHelp19)
PutSX1Help("P." + cPerg + "20.",aHelp20,aHelp20,aHelp20)
PutSX1Help("P." + cPerg + "21.",aHelp21,aHelp21,aHelp21)

Return



Return
