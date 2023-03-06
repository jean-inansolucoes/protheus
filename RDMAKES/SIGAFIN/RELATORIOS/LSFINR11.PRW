
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"                                                                                                                       
#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                                                    
±±³Programa  ³ LSFINR11³ Autor ³ ALEXANDRE LONGHINOTTI  ³ Data ³ 07/12/21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO SANTANDER                              ³±±                             
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Incluir o parametro                        ³
//³MV_LSFIN01 - Multa a ser impressa no boleto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl


User Function LSFINR11(cNum, cSerie ,Banco , Agen ,Conta )
*********************************************************************************
LOCAL   aCampos      := {}
Local   hEnter       := Chr( 13 )
LOCAL   cMarca       := IIf(alltrim(FunName())=="MATA410" .OR. ISINCALLSTACK("MATA460A"),"",GetMark())
LOCAL   lInverte     := .f.
LOCAL   aMarked      := {}
/*LOCAL   aDesc        := { "Este programa imprime os boletos de",;
                          "cobranca bancaria de acordo com",;
                          "os parametros informados"}
*/
PRIVATE nRegSel      := 0
PRIVATE Exec         := .F.
PRIVATE cIndexName   := ''
PRIVATE cIndexKey    := ''
PRIVATE cFilter      := ''
PRIVATE dvnn         := 0
PRIVATE dvcb         := 0
PRIVATE dv           := 0
PRIVATE _cBanco  	 := "033"
PRIVATE c_Banco	     := Banco
PRIVATE c_Agen		 := Agen
PRIVATE c_Conta		 := Conta


Tamanho  := "M"
titulo   := "Impressão de Boleto"
cDesc1   := "Este programa destina-se a impressão de boletos do Banco Santander."
cDesc2   := ""                                                                                                                           
cDesc3   := ""
cString  := "SE1"
wnrel    := "LSFINR11"
lEnd     := .F.
cPerg    := "LSFINR0011"

aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dBSelectArea( "SE1" )

AjustaSX1()

If cNum == nil
	If !Pergunte( cPerg,.T., "Parâmetros - Boletos Santander" )
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
	cSql += "   AND ( SE1.E1_X_FRMPG = 'BOL')" + hEnter	// Filtra forma de pagamento = BOL -> BOLETO
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
	DEFINE MSDIALOG oDlg TITLE "Seleção de Títulos Santander" From 1,1 To 400,950 OF oMainWnd PIXEL
	
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
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER Santander COM COD. BARRAS        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel( aMarked,cNum,cSerie,Banco,Agen,Conta )
*****************************************************************
LOCAL oPrint
LOCAL n 	:= 0            
Local nCnpj	:= SM0->M0_CGC

LOCAL aDadosEmp    := {	ALLTRIM(SM0->M0_NOMECOM)                                                  ,; //[1]Nome da Empresa
                        SM0->M0_ENDCOB                                                            ,; //[2]Endereço
                        AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
                        "CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
                        "PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
                        "CNPJ.: "+ Transform(nCnpj,"@R 99.999.999/9999-99")          		      ,; //[6]CGC
                        "I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
                        Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := { "Após o vencimento cobrar multa de "									,;
                        "Mora Diária de R$ "          		    						   		,;
                        "Doc nº: "          		    						   				,;
                        "Até o vencimento conceder desconto de R$: "}

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0

oPrint:= TMSPrinter():New( "Boleto SANTANDER" )
oPrint:SetPortrait()    // ou SetLandscape()
oPrint:SetPaperSize(9) //A4
oPrint:Setup()
oPrint:StartPage()     // Inicia uma nova página

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
		aDadosBanco  := { "033-7"	                                                      ,; // [1]Numero do Banco
		                  SA6->A6_NOME      	            	                 	      ,; // [2]Nome do Banco
		                  SUBSTR(SA6->A6_AGENCIA, 1, 4)                          	      ,; // [3]Agência
		                  SA6->A6_NUMCON											      ,; // [4]Conta Corrente
		                  SA6->A6_DVCTA											  	      ,; // [5]Dígito da conta corrente
		                  SEE->EE_SUBCTA											  	  ,; // [6]Carteira
		                  SA6->A6_DVAGE											  	  	  ,; // [7]Posto
		                  SEE->EE_CODEMP         								           } // [8]Cod Cliente no banco
		
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := { AllTrim(SA1->A1_NOME)           	        	        	  ,; // [1]Razão Social
			                  AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	       	  ,; // [2]Código
			                  AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO) 	      ,; // [3]Endereço
			                  AllTrim(SA1->A1_MUN )                             	      ,; // [4]Cidade
			                  SA1->A1_EST                                       	      ,; // [5]Estado
			                  SA1->A1_CEP                                      	 	      ,; // [6]CEP
			                  SA1->A1_CGC										 	       } // [7]CGC
		Else
			aDatSacado   := { AllTrim( SA1->A1_NOME   )                                   ,; // [1]Razão Social
			                  AllTrim( SA1->A1_COD    ) + "-" + SA1->A1_LOJA              ,; // [2]Código
			                  AllTrim( SA1->A1_ENDCOB ) + "-" + AllTrim( SA1->A1_BAIRROC ),; // [3]Endereço
			                  AllTrim( SA1->A1_MUNC   )	                                  ,; // [4]Cidade
			                  SA1->A1_ESTC	                                              ,; // [5]Estado
			                  SA1->A1_CEPC                                                ,; // [6]CEP
			                  SA1->A1_CGC									      	       } // [7]CGC
		Endif
		
		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		
		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],STRZERO(VAL(aDadosBanco[4]),5),aDadosBanco[5],SEE->EE_FAXATU,(SE1->E1_SALDO - (SE1->E1_SDDECRE + _nVlrAbat)),SE1->E1_VENCTO, SE1->E1_PARCELA)
		
		aDadosTit   := { STRZERO(VAL(SUBSTR(E1_NUM,2,8)),8)+ IIF(!EMPTY(ALLTRIM(E1_PARCELA)),STRZERO(VAL(SUBSTR(E1_PARCELA,2,2)),2),"01") ,;  // [1] Número do título
		                 E1_EMISSAO                              								  ,;  // [2] Data da emissão do título
		                 Date()                                  							,;  // [3] Data da emissão do boleto
		                 E1_VENCTO                               							,;  // [4] Data do vencimento
		                  (E1_SALDO - (E1_SDDECRE + _nVlrAbat))                  							,;  // [5] Valor do título
		                 CB_RN_NN[3]                             							,;  // [6] Nosso número (Ver fórmula para calculo)
		                 E1_PREFIXO                           		    					,;  // [7] Prefixo da NF
		                 "DM"	                               								,;  // [8] Tipo do Titulo   //E1_TIPO
		                 E1_TIPO	                               							,;  // [9] Tipo do Titulo
		                 SEE->EE_SUBCTA														,;   // [10] Carteira
		                 E1_SDDECRE																}   // [11] Decrescimo
		
		If mv_par19 = 2 .OR. aMarked[i]
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
			n := n + 1
		EndIf
		
	EndIf
	DbSelectArea("TMPBOL2")
	dbskip()
	IncProc()
	i := i + 1
EndDo


oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COD. DE BARRAS       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)  //nParte 1 (Comprovante de Entrega,2 (Recibo do Sacado) ou 3 (Ficha de Compensação)
********************************************************************************************
Private oBrush                     
Private n_Juros := GETMV( "MV_TXPER"   ) / 100    //percentual de juros por dia 
Private n_Multa := alltrim(str(GETMV( "MV_LSFIN01" ))) //percentual da multa 


oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página
ImpParte(1,oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
ImpParte(2,oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
ImpParte(3,oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

DbSelectArea("SE1")
If Empty(SE1->E1_NUMBCO) .AND. SUBSTR(SE1->E1_TIPO,3,1) != "-"
	RecLock("SE1",.f.)
		SE1->E1_PORTADO	:= SUBSTR(aDadosBanco[1],1,3)
		SE1->E1_AGEDEP	:= aDadosBanco[3]               // Agência
		SE1->E1_CONTA   := aDadosBanco[4]				// Conta sem dig verificador
   		SE1->E1_NUMBCO  := CB_RN_NN[3]                  // Nosso número
		SE1->E1_CODBAR  := CB_RN_NN[1]                  // Codigo de Barras
		SE1->E1_CODDIG  := CB_RN_NN[2]		            // Linha Digitavel
		
		If Empty( SE1->E1_NUMBOR ) 
           SE1->E1_SITUACA  := "0"
        EndIf		                 						 

		
  	MsUnlock() 
	DbSelectArea("SEE")   
	RecLock("SEE",.f.)
		SEE->EE_FAXATU := STRZERO(VAL(SEE->EE_FAXATU) + 1,7)
	MsUnlock()
Else
		RecLock("SE1",.f.)
	
		SE1->E1_CODBAR  := CB_RN_NN[1]                  // Codigo de Barras
		SE1->E1_CODDIG  := CB_RN_NN[2]		            // Linha Digitavel
		
		If Empty( SE1->E1_NUMBOR ) 
           SE1->E1_SITUACA  := "0"
        EndIf		                 						 

	
  	MsUnlock() 
	DbSelectArea("SEE")   
		
EndIf       
DbSelectArea("SE1")
            
oPrint:EndPage() // Finaliza a página

Return()

Static Function ImpParte(nParte,oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
****************************************************************************************************
LOCAL i := 0
Local cLogoBco  := "\system\santander.bmp"    
Local cLogoBco1 := "\system\imgs\santander.bmp"    
Local _VENCTO 	:= IIF( LEN( DTOC( aDadosTit[ 4 ] ) ) == 8, SUBSTR( DTOC( aDadosTit[ 4 ] ),1, 6 ) + "20" + SUBSTR( DTOC( aDadosTit[ 4 ]),7,2),aDadostit[ 4 ])               
Local _EMISS	:= IIF( LEN( DTOC( aDadosTit[ 2 ] ) ) == 8, SUBSTR( DTOC( aDadosTit[ 2 ] ),1, 6 ) + "20" + SUBSTR( DTOC( aDadosTit[ 2 ]),7,2),aDadostit[ 2 ]) 
Local _DTBASE	:= IIF( LEN( DTOC( aDadosTit[ 3 ] ) ) == 8, SUBSTR( DTOC( aDadosTit[ 3 ] ),1, 6 ) + "20" + SUBSTR( DTOC( aDadosTit[ 3 ]),7,2),aDadostit[ 3 ])    
Local _CodBar	:= CB_RN_NN[1]
Local _CodDig	:= CB_RN_NN[2]
Local cPedido   := POSICIONE( "SC5",5, XFILIAL( "SC5" ) + "0" + SUBSTR(aDadosTit[1],1,8) + aDadosTit[7], "SC5->C5_NUM")
oFont7  := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,09,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18n:= TFont():New("Arial",9,18,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12 := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20 := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

If nParte == 1
	nLin := 00150
	
	oPrint:Line (nLin,550,0050,0550)
	oPrint:Line (nLin,760,0050,0760)  
	oPrint:SayBitmap(0035,100,cLogoBco,0370,0100 )     // Logo
	oPrint:Say  (0075,570,aDadosBanco[1],oFont18n )	  // [1]Numero do Banco
	oPrint:Say  (0084,1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (0150,100,0150,2300)
	oPrint:Say  (0150,100 ,"Cedente"                                        						,oFont7)
	oPrint:Say  (0200,100 ,aDadosEmp[1]                                 							,oFont10) //Nome + CNPJ
	oPrint:Say  (0150,1060,"Agência/Código Cedente"                         						,oFont8)
	oPrint:Say  (0200,1060,aDadosBanco[3]+"/"+aDadosBanco[8] 	,oFont10)
	oPrint:Say  (0150,1510,"Nro.Documento"                                  						,oFont8)
	oPrint:Say  (0200,1510,aDadosTit[1] 						          	 						,oFont10) //Numero(8 caracteres)+Parcela(2 caracteres)
	oPrint:Say  (0250,100 ,"Sacado"                                         						,oFont8)
	oPrint:Say  (0300,100 ,substr(aDatSacado[1],1,48)                          						,oFont10)	//Nome
	oPrint:Say  (0250,1060,"Vencimento"                                     						,oFont8)
	oPrint:Say  (0300,1060,DTOC(aDadosTit[4])                               						,oFont10)
	oPrint:Say  (0250,1510,"Valor do Documento"                          							,oFont8)
	oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")) 					,oFont10)
	oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 						,oFont10)
	oPrint:Say  (0450,0100,"com as características acima."             								,oFont10)
	oPrint:Say  (0350,1060,"Data"                                           						,oFont8)
	oPrint:Say  (0450,1060,"Assinatura(Nome por extenso)"                  							,oFont8)
	
	oPrint:Line (0250, 100,0250,1900 )
	oPrint:Line (0350, 100,0350,1900 )
	oPrint:Line (0450,1050,0450,1900 )
	oPrint:Line (0550, 100,0550,2300 )
	
	oPrint:Line (0550,1050,0150,1050 )
	oPrint:Line (0350,1500,0150,1500 )
	oPrint:Line (0550,1900,0150,1900 )
	
	oPrint:Say  (0160,1910,"(  )Mudou-se"                                	,oFont8)
	oPrint:Say  (0200,1910,"(  )Ausente"                                    ,oFont8)
	oPrint:Say  (0240,1910,"(  )Não existe nº indicado"                  	,oFont8)
	oPrint:Say  (0280,1910,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (0320,1910,"(  )Não procurado"                              ,oFont8)
	oPrint:Say  (0360,1910,"(  )Endereço insuficiente"                  	,oFont8)
	oPrint:Say  (0400,1910,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (0440,1910,"(  )Falecido"                                   ,oFont8)
	oPrint:Say  (0480,1910,"(  )Outros(anotar no verso)"                  	,oFont8)
	
ElseIf nParte == 2 .Or. nParte == 3
	
	If nParte == 2
		nLin := 750
		oPrint:Say  (nLin+110,2000,"Recibo do Sacado",oFont10)
	Else
		nlin := 2100   //1850
		oPrint:Say  (nLin+1045,1850,"Código de Baixa"	                             ,oFont10)
		oPrint:Say  (nLin+1085,1850,"Ficha de Compensação"                           ,oFont10)

		MSBAR3("INT25"  ,27.5,1.0,_CodBar,oPrint,.F.,,,,1.2,,,,.F.)

	EndIf

	For i := 100 to 2300 step 50
		oPrint:Line( nLin, i, nLin, i+30)
	Next i
	
	oPrint:Line (nlin+150,100,nlin+150,2300)
	oPrint:Line (nlin+150,550,nlin+50, 550)
	oPrint:Line (nlin+150,760,nlin+50, 760)
	oPrint:SayBitmap(nlin+45,100,cLogoBco,0370,0100 ) 	// Logo
	oPrint:Say  (nlin+70,570,aDadosBanco[1],oFont18n )	// [1]Numero do Banco
	oPrint:Say  (nLin+84,770,Transform(_CodDig,"@R 99999.99999  99999.999999  99999.999999  9  99999999999999"),oFont12)		//Linha Digitavel do Codigo de Barras
	
	oPrint:Line (nLin+250,100,nLin+250,2300 )
	oPrint:Line (nLin+350,100,nLin+350,2300 )
	oPrint:Line (nLin+420,100,nLin+420,2300 )
	oPrint:Line (nLin+490,100,nLin+490,2300 )
	
	oPrint:Line (nLin+350,0500,nLin+490,500)
	oPrint:Line (nLin+420,0750,nLin+490,750)
	oPrint:Line (nLin+350,1000,nLin+490,1000)
	oPrint:Line (nLin+350,1350,nLin+420,1350)
	oPrint:Line (nLin+350,1550,nLin+490,1550)
	
	oPrint:Say  (nLin+150,100 ,"Local de Pagamento"                             			,oFont8)
	oPrint:Say  (nLin+180,100 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO "				,oFont8)
	oPrint:Say  (nLin+210,100 ," "					,oFont8)
	
	oPrint:Say  (nLin+150,1910,"Vencimento"                                     			,oFont8)
	oPrint:Say  (nLin+190,2235,DTOC(aDadosTit[4])                               			,oFont10,,,,1)
	
	oPrint:Say  (nLin+250,100 ,"Cedente"                                        			,oFont8)
	oPrint:Say  (nLin+290,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10)       			//Nome + CNPJ
	
	oPrint:Say  (nLin+250,1910,"Agência/Código Cedente"                         			,oFont8)
	oPrint:Say  (nLin+290,2235,aDadosBanco[3]+"/"+aDadosBanco[8]							,oFont10,,,,1)
	
	oPrint:Say  (nLin+350,100 ,"Data do Documento"                              			,oFont8)
	oPrint:Say  (nLin+380,100 ,DTOC(aDadosTit[2])                               			,oFont10) // Emissao do Titulo (E1_EMISSAO)
	
	oPrint:Say  (nLin+350,505 ,"Nro.Documento"                                  			,oFont8)
	oPrint:Say  (nLin+380,605 ,aDadosTit[1]								   					,oFont10) //Numero(8 caracteres)+Parcela(2 caracteres)
	
	oPrint:Say  (nLin+350,1005,"Espécie Doc."                                   			,oFont8)
	oPrint:Say  (nLin+380,1050,"DM"															,oFont10) //Tipo do Titulo

	
	oPrint:Say  (nLin+350,1355,"Aceite"                                         			,oFont8)
	oPrint:Say  (nLin+380,1370,"N" 		                                           			,oFont10)
	
	oPrint:Say  (nLin+350,1555,"Data do Processamento"                        				,oFont8)
	oPrint:Say  (nLin+380,1655,DTOC(aDadosTit[3])                               			,oFont10) // Data impressao
	
	oPrint:Say  (nLin+350,1910,"Nosso Número"                                 				,oFont8)
	
	oPrint:Say  (nLin+380,2235,Alltrim(aDadosTit[6])	,oFont10,,,,1)				

	oPrint:Say  (nLin+420,100 ,"Uso do Banco"                                   			,oFont8)
	oPrint:Say  (nLin+450,150 ,""					                               			,oFont10) 
	
	oPrint:Say  (nLin+420,505 ,"Carteira"                                       			,oFont8)
	oPrint:Say  (nLin+450,555 ,"" 	                                  						,oFont10)
	
	oPrint:Say  (nLin+420,755 ,"Espécie"                                        			,oFont8)
	oPrint:Say  (nLin+450,805 ,"R$"                                             			,oFont10)
	
	oPrint:Say  (nLin+420,1005,"Quantidade"                                     			,oFont8)
	oPrint:Say  (nLin+420,1555,"Valor"                                          			,oFont8)
	
	oPrint:Say  (nLin+420,1910,"Valor do Documento"                          	   			,oFont8)
	oPrint:Say  (nLin+450,2235,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))			,oFont10,,,,1)
	
	oPrint:Say  (nLin+490,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)

	oPrint:Say  (nLin+540,100 ,aBolText[1]+" "+ n_Multa + "%."							      ,oFont10)
	oPrint:Say  (nLin+590,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*n_Juros),"@E 99,999.99"))      ,oFont10)
	//oPrint:Say  (nLin+640,100 ,"No 3º dia útil após o vencimento, seguirá automaticamente para cartório."                                   ,oFont10)
	If aDadosTit[11] > 0
		oPrint:Say  (nLin+690,100 ,"CLIENTE COM ACORDO COMERCIAL"                                          ,oFont10)
	EndIf
	oPrint:Say  (nLin+740,100 ,"Ref. Nota Nº: " + SE1->E1_NUM + " / Série: " + SE1->E1_PREFIXO + " / Parcela: " + IIF(!EMPTY(SE1->E1_PARCELA),SE1->E1_PARCELA,"001"),oFont10)
		
	oPrint:Say  (nLin+490,1910,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nLin+560,1910,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nLin+630,1910,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nLin+700,1910,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nLin+770,1910,"(=)Valor Cobrado"                               ,oFont8)
	
	oPrint:Say  (nLin+840,0100,"Sacado"                                         ,oFont8)
	oPrint:Say  (nLin+870,0100,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	oPrint:Say  (nLin+923,0100,aDatSacado[3]                                    ,oFont10)
 	oPrint:Say  (nLin+976,0104,"CEP: "+aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5]+"   "+IIF(SA1->A1_PESSOA=="J","CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99")),oFont10) // CEP+Cidade+Estado+CNPJ/CPF	
//	oPrint:Say  (nLin+976,1500,_CodBar)  //Impressao numerica do cod. Barras para conferencia
	oPrint:Say  (nLin+1045,0100,"Sacador/Avalista"                               ,oFont8)
	oPrint:Say  (nLin+1085,1500,"Autenticação Mecânica -"                        ,oFont8)
	
	oPrint:Line (nLin+150,1900,nLin+840,1900 ) 
	oPrint:Line (nLin+560,1900,nLin+560,2300 )  
	oPrint:Line (nLin+630,1900,nLin+630,2300 )  
	oPrint:Line (nLin+700,1900,nLin+700,2300 )  
	oPrint:Line (nLin+770,1900,nLin+770,2300 )  
	oPrint:Line (nLin+840,0100,nLin+840,2300 )  
	oPrint:Line (nLin+1080,100,nLin+1080,2300)
	
EndIf


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Modulo10(cData)
*******************************
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End

Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SICREI COM CODIGO DE BARRAS    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cParc)
********************************************************************************
LOCAL bldocnufinal := strzero(val(cNroDoc),12)
LOCAL blvalorfinal := strzero((nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
Local nDataBase    := CtoD("03/07/2000")
LOCAL _cfator      := 0
Local cTpCobr      := "1"	// Alltrim(SE1->E1_SITUACA) - alterado, pois o boleto pode ser impresso antes de gerar bordero. Se existir uma carteira diferente deverá ser criada regra para o conteúdo desta variável.
Local cCarteira    := Alltrim( SEE->EE_SUBCTA )
Local cCodEmp	   := Alltrim(SEE->EE_CODEMP) 
Local cCampoLivre  := ""

If ddatabase >= CtoD("22/02/2025")
	nDataBase    := CtoD("22/02/2025")
EndIF
_cfator:= StrZero( (dVencto - nDataBase)+ 1000, 4 )

If Empty(ALLTRIM(cParc))
	cParc := "001"
EndIf
//-------- Definicao do NOSSO NUMERO
dbSelectArea("SE1")
If Empty(SE1->E1_NUMBCO)
	s    :=  bldocnufinal   //NUMERO DO CLIENTE NO BANCO (CONVENIO)
Else
	s    :=  SE1->E1_NUMBCO
EndIf
                             
dvnn := CalDVNOS(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
If Empty(SE1->E1_NUMBCO)
	NN   := bldocnufinal + AllTrim(dvnn)
Else
	NN   := SE1->E1_NUMBCO
EndIf


//	-------- Definicao do CODIGO DE BARRAS                                                                                                                          
s    := cBanco + _cfator + blvalorfinal + "9" + cCodEmp + AllTrim(NN) +  "0101"
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.DDDDE		FFFGG.GGGGGI	HHHHH.HJJJJK	L			MMMMNNNNNNNNNN
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao "033"
//	  B = Codigo da moeda, sempre 9
//	  C = Fixo '9'
// 	  D = Primeiros 4 digitos Codigo Beneficiário
//	  E = Digito verificador do campo 1
//
s    := cBanco + "9" + SubStr(AllTrim(cCodEmp), 1, 4)
dv   := modulo10(s)
RN   := SubStr(s, 1, 9) + alltrim(str(dv))
//
// 	CAMPO 2:B
//		F = Restante do Codigo do beneficiário
//	   	G = Codigo do cliente
//	   	H = Nosso Numero
//	    I = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(AllTrim(cCodEmp), 5, 3) + SubStr(AllTrim(NN), 1, 7)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 10) + alltrim(str(dv))
//
// 	CAMPO 3:
//	     H = Restante Nosso Numero
//	     J = Numero da parcela
//	     K = Digito verificardo do campo 3
//	     
s    := SubStr(AllTrim(NN), 8, 6) + "0101"
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 10) + AllTrim(Str(dv))
//
// 	CAMPO 4:
//	     L = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb))
//
// 	CAMPO 5:
//	     M = fator Vencimento
//	     N = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))

Return({CB,RN,NN})  

//******************************************************************************
// Ajusta as perguntas (SX1) da rotina
//******************************************************************************

Static Function AjustaSX1()
Local i,j
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
aAdd(aRegs,{cPerg,"01","Prefixo de		 ?","Prefixo de       ?","Prefixo de       ?","mv_ch1" ,"C",TAMSX3("E1_PREFIXO")[1] ,0,0,"G","			","mv_par01",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"02","Prefixo até      ?","Prefixo até      ?","Prefixo até      ?","mv_ch2" ,"C",TAMSX3("E1_PREFIXO")[1] ,0,0,"G","			","mv_par02",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"03","Titulo de        ?","Titulo de        ?","Titulo de        ?","mv_ch3" ,"C",TAMSX3("E1_NUM")	[1] ,0,0,"G","			","mv_par03",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"04","Titulo até       ?","Titulo até       ?","Titulo até       ?","mv_ch4" ,"C",TAMSX3("E1_NUM")	[1] ,0,0,"G","			","mv_par04",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"05","Parcela de       ?","Parcela de       ?","Parcela de       ?","mv_ch5" ,"C",TAMSX3("E1_PARCELA")[1] ,0,0,"G","			","mv_par05",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"06","Parcela até      ?","Parcela até      ?","Parcela até      ?","mv_ch6" ,"C",TAMSX3("E1_PARCELA")[1] ,0,0,"G","			","mv_par06",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"07","Carga de         ?","Carga de         ?","Carga de         ?","mv_ch7" ,"C",TAMSX3("E1_X_CARGA")[1] ,0,0,"G","			","mv_par07",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","DAK" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"08","Carga até        ?","Carga até        ?","Carga até        ?","mv_ch8" ,"C",TAMSX3("E1_X_CARGA")[1] ,0,0,"G","			","mv_par08",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","DAK" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"09","Bordero de       ?","Bordero de       ?","Bordero de       ?","mv_ch9" ,"C",TamSX3("E1_NUMBOR")	[1]	,0,0,"G","			","mv_par09",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SEAR" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"10","Bordero até      ?","Bordero até      ?","Bordero até      ?","mv_ch10","C",TamSX3("E1_NUMBOR")	[1] ,0,0,"G","			","mv_par10",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SEAR" ,"","","",    			 ""})
aAdd(aRegs,{cPerg,"11","Cliente de       ?","Cliente de       ?","Cliente de       ?","mv_ch11","C",TamSX3("E1_CLIENTE")[1]	,0,0,"G","			","mv_par11",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SA1" ,"","","",    			 ""})
aAdd(aRegs,{cPerg,"12","Cliente até      ?","Cliente até      ?","Cliente até      ?","mv_ch12","C",TamSX3("E1_CLIENTE")[1] ,0,0,"G","			","mv_par12",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SA1" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"13","Loja de          ?","Loja de          ?","Loja de          ?","mv_ch13","C",TamSX3("E1_LOJA")	[1]	,0,0,"G","			","mv_par13",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","", 			     ""})
aAdd(aRegs,{cPerg,"14","Loja até         ?","Loja até         ?","Loja até         ?","mv_ch14","C",TamSX3("E1_LOJA")	[1]	,0,0,"G","			","mv_par14",			"",				"",				"","","",		"",		  "",		"","","",	  "",	  "",	  "","","","","","","","","","","","",   "" ,"","","",               ""})
aAdd(aRegs,{cPerg,"15","Vencimento de    ?","Vencimento de    ?","Vencimento de    ?","mv_ch15","D",08                      ,0,0,"G","			","mv_par15",         	"",        		"",         	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"16","Vencimento até   ?","Vencimento até   ?","Vencimento até   ?","mv_ch16","D",08						,0,0,"G","			","mv_par16",         	"", 	   	    "",    	     	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"17","Emissão de       ?","Emissão de       ?","Emissão de       ?","mv_ch17","D",08                      ,0,0,"G","			","mv_par17",         	"",        		"",         	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",	 "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"18","Emissão até      ?","Emissão até      ?","Emissão até      ?","mv_ch18","D",08						,0,0,"G","			","mv_par18",         	"", 	   	    "",    	     	"","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"19","Seleciona Titulos?","Seleciona Titulos?","Seleciona Titulos?","mv_ch19","N",01						,0,0,"C","naovazio()","mv_par19",		 "Sim",			 "Sim",			 "Sim","","",	 "Nao",	   "Nao",	 "Nao","","",	  "",	  "",	  "","","","","","","","","","","","",   "" ,"","","",               ""})
aAdd(aRegs,{cPerg,"20","Reimprime Boletos?","Reimprime Boletos?","Reimprime Boletos?","mv_ch20","N",01						,0,0,"C","naovazio()","mv_par20",		 "Sim",			 "Sim",			 "Sim","","",	 "Nao",	   "Nao",	 "Nao","","","Ambos","Ambos","Ambos","","","","","","","","","","","",   "" ,"","","",               ""})
aAdd(aRegs,{cPerg,"21","Banco   		 ?","banco de         ?","banco de         ?","mv_ch21","C",TAMSX3("E1_PORTADO")[1]  ,0,0,"G","			","mv_par21",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","","SEEBOL" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"22","Agencia 		 ?","Agencia          ?","Agencia          ?","mv_ch22","C",TAMSX3("E1_AGEDEP ")[1]  ,0,0,"G","			","mv_par22",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})
aAdd(aRegs,{cPerg,"23","Conta   		 ?","Conta            ?","Conta            ?","mv_ch23","C",TAMSX3("E1_CONTA  ")[1]  ,0,0,"G","			","mv_par23",           "",             "",             "","","",       "",       "",       "","","",     "",     "",     "","","","","","","","","","","","",   "" ,"","","",				 ""})

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

Static Function DVCampL(pNossoNum)
    local aPeso     := {9,8,7,6,5,4,3,2} // 2,3,4,5,6,7,8,9}
    local nPeso     := 1
    local nSoma     := 0
    local nCalc1    := 0
    local nCalc2    := 0
    local nCalc3    := 0
    local cRes      := ""
	local nx
    //
    for nX := 1 to len(pNossoNum)
        if nPeso > len(aPeso)
           nPeso := 1
        endif
        nSoma += val(substr(pNossoNum, nX, 1)) * aPeso[nPeso]
        nPeso++
    next
    //       
    nCalc1  := nSoma/11
    nCalc2  := int(nCalc1) * 11
    nCalc3  := nSoma - nCalc2
    nCalc4  := 11 - nCalc3
    //    
    iif(nCalc3 <= 1, cRes := "0", cRes := alltrim(Str(nCalc4)))

return(cRes)

static function CalDVNOS( pNossoNum )
    local aPeso     := {5,4,3,2,9,8,7,6,5,4,3,2}
    local nPeso     := 1
    local nSoma     := 0
    local nCalc1    := 0
    local nCalc2    := 0
    local nCalc3    := 0
    local nDV
    local nAux
    local cRes      := ""
	Local nX
    //                                                                  
    for nX := 1 to len(pNossoNum)
    	if nPeso > len(aPeso)
    	   nPeso := 1   
    	endif
    	//
        nSoma += val(substr(pNossoNum, nX, 1)) * aPeso[nPeso]
        nPeso++
    next
    //        
    //nCalc1 := int(nSoma / 11)     // 1o calculo
    //nCalc2 := nCalc1 * 11         // 3o calculo
    //nCalc3 := nSoma - nCalc2      // 4o calculo
    nCalc1 := (nSoma % 11)
    nCalc2 := 11 - nCalc1
    
 cRes := Iif ( nCalc1 == 0, "0", Iif (nCalc1 == 1, "0", Iif (nCalc1 == 10, "1", Str (nCalc2, 1) ) ))
 
return(cRes)

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/
Static Function cDVBarra(pNossoNum)
    local aPeso     :=  {4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2} //{9,8,7,6,5,4,3,2}
    local nPeso     := 1
    local nSoma     := 0
    local nCalc1    := 0
    local nCalc2    := 0
    local nCalc3    := 0
    local cRes      := ''
	local nX
    //
    for nX := 1 to len(pNossoNum)
    	if nPeso > len(aPeso)
    	   nPeso := 1   
    	endif
    	//
        nSoma += val(substr(pNossoNum, nX, 1)) * aPeso[nPeso]
        nPeso++
    next
    //   
    nCalc1 := mod(nSoma,11)
    nCalc2 := 11 - nCalc1
                         
    iif(((nCalc2 < 2) .OR. (nCalc2 > 9)),cRes := "1", cRes := alltrim(str(nCalc2)))
    
return( cRes )
