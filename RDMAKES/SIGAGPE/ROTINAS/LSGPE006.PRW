#Include "rwmake.ch"
#Include "colors.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSGPE006   ºAutor  ³Totvs Cascavel     º Data ³  21/06/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina p/ verificar vencimento do 1.periodo de Experiência º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TRELAC                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------------------------------------------------------*
User Function LSGPE006()
*---------------------------------------------------------------------------*

LOCAL _VCTO1
LOCAL _hoje
LOCAL _vetvenc  := {}
LOCAL cEmail
LOCAL cStatus 	:= SPACE(6)            
LOCAL I := 0

_VCTO1   := 10
cEmail	 := GETMV("MV_X_EMFRH")
_hoje    := DDATABASE      

DBSELECTAREA("SRA")  

IF SELECT("TMPSRA") > 0
	("TMPSRA")->(dbclosearea())
ENDIF

cQuery := ""
cQuery += " SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_CC, CTT_DESC01, RA_TNOTRAB, R6_DESC, RA_VCTOEXP "
cQuery += " FROM " + RetSqlName("SRA") +  " RA "
cQuery += " INNER JOIN CTT010 ON CTT_CUSTO = RA_CC
cQuery += " INNER JOIN SR6010 ON R6_TURNO = RA_TNOTRAB
cQuery += " WHERE RA_CATFUNC NOT IN ('P', 'A') AND "
cQuery += " RA.RA_SITFOLH <> 'D' AND "
cQuery += " RA.D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_CC, CTT_DESC01, RA_TNOTRAB, R6_DESC, RA_VCTOEXP "
cQuery += " ORDER BY RA_FILIAL, RA_NOME "

MemoWrite("TMPSRA.TXT",cQuery)
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPSRA"
TMPSRA->(DbGotop())

_TESTE1 := dtos(_HOJE + _VCTO1)

WHILE TMPSRA->(!EOF())
	
	_1dtbase :=  stod(TMPSRA->RA_VCTOEXP) 
	_1dadmis :=  stod(TMPSRA->RA_ADMISSA)

	IF _TESTE1 == dtos(_1dtbase)
		aaDD(_vetvenc,{TMPSRA->RA_FILIAL, TMPSRA->RA_MAT, TMPSRA->RA_NOME, _1dadmis, TMPSRA->RA_CC, TMPSRA->CTT_DESC01, TMPSRA->RA_TNOTRAB, TMPSRA->R6_DESC, dtos(_1dtbase)}) 
    ENDIF
	
	TMPSRA->(DBSKIP())
ENDDO
TMPSRA->(dbclosearea())

oProcess := TWFProcess():New("WFVCTEXP","Tempo Servico ")
oProcess :NewTask(cStatus,"\workflow\wfvctexp.html")
oProcess :cSubject := ("Aviso 1. Vencimento de Experiência.")
oProcess :cTo  := cEmail
                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta o workflow            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
IF LEN(_VETVENC) > 0
	oHtml:= oProcess:oHTML
   //	oHtml:ValByName("data"                ,ALLTRIM(DTOC(DDATABASE)))
	
	FOR I := 1 TO len( _VETVENC )
		_dt1 := stod( _VETVENC[I][9] )
		AAdd( (oHtml:ValByName( "tit.emp"    ) ), SM0->M0_CODIGO )
		AAdd( (oHtml:ValByName( "tit.fil"    ) ), _VETVENC[I][1] )
		AAdd( (oHtml:ValByName( "tit.mat"    ) ), _VETVENC[I][2] )
		AAdd( (oHtml:ValByName( "tit.nome" 	 ) ), _VETVENC[I][3] )
		AAdd( (oHtml:ValByName( "tit.adim" 	 ) ), _VETVENC[I][4] )
		AAdd( (oHtml:ValByName( "tit.cc" 	 ) ), _VETVENC[I][5] )
		AAdd( (oHtml:ValByName( "tit.dcc" 	 ) ), _VETVENC[I][6] )
		AAdd( (oHtml:ValByName( "tit.turn" 	 ) ), _VETVENC[I][7] )
		AAdd( (oHtml:ValByName( "tit.dtur" 	 ) ), _VETVENC[I][8] )
		AAdd( (oHtml:ValByName( "tit.vcto01" ) ), _dt1 )
	NEXT I
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:Start()
ENDIF

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSGPE007   ºAutor  ³Totvs Cascavel     º Data ³  22/06/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina p/ verificar vencimento do 2.periodo de Experiência º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TRELAC                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------------------------------------------------------*
User Function LSGPE007()
*---------------------------------------------------------------------------*

LOCAL _VCTO1
LOCAL _hoje
LOCAL _vetvenc  := {}
LOCAL cEmail
LOCAL cStatus 	:= SPACE(6)            
LOCAL I := 0

_VCTO1   := 10
cEmail	 := GETMV("MV_X_EMFRH")
_hoje    := DDATABASE      

DBSELECTAREA("SRA")  

IF SELECT("TMPSRA2") > 0
	("TMPSRA2")->(dbclosearea())
ENDIF

cQuery := ""
cQuery += " SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_CC, CTT_DESC01, RA_TNOTRAB, R6_DESC, RA_VCTEXP2 "
cQuery += " FROM " + RetSqlName("SRA") +  " RA "
cQuery += " INNER JOIN CTT010 ON CTT_CUSTO = RA_CC
cQuery += " INNER JOIN SR6010 ON R6_TURNO = RA_TNOTRAB
cQuery += " WHERE RA_CATFUNC NOT IN ('P', 'A') AND "
cQuery += " RA.RA_SITFOLH <> 'D' AND "
cQuery += " RA.D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_CC, CTT_DESC01, RA_TNOTRAB, R6_DESC, RA_VCTEXP2 "
cQuery += " ORDER BY RA_FILIAL, RA_NOME "

MemoWrite("TMPSRA2.TXT",cQuery)
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPSRA2"
TMPSRA2->(DbGotop())

_TESTE1 := dtos(_HOJE + _VCTO1)

WHILE TMPSRA2->(!EOF())
	
	_2dtbase :=  stod(TMPSRA2->RA_VCTEXP2)
    _1dadmis :=  stod(TMPSRA2->RA_ADMISSA) 
	
	IF _TESTE1 == dtos(_2dtbase)
		aaDD(_vetvenc,{TMPSRA2->RA_FILIAL, TMPSRA2->RA_MAT, TMPSRA2->RA_NOME, _1dadmis, TMPSRA2->RA_CC, TMPSRA2->CTT_DESC01, TMPSRA2->RA_TNOTRAB, TMPSRA2->R6_DESC, dtos(_2dtbase)}) 
    ENDIF
	
	TMPSRA2->(DBSKIP())
ENDDO
TMPSRA2->(dbclosearea())

oProcess := TWFProcess():New("WFVCTEXP2","Tempo Servico ")
oProcess :NewTask(cStatus,"\workflow\wfvctexp2.html")
oProcess :cSubject := ("Aviso 2. Vencimento de Experiência.")
oProcess :cTo  := cEmail
                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta o workflow            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
IF LEN(_VETVENC) > 0
	oHtml:= oProcess:oHTML
   //	oHtml:ValByName("data"                ,ALLTRIM(DTOC(DDATABASE)))
	
	FOR I := 1 TO len( _VETVENC )
		_dt2 := stod( _VETVENC[I][9] )
		AAdd( (oHtml:ValByName( "tit.emp"    ) ), SM0->M0_CODIGO )
		AAdd( (oHtml:ValByName( "tit.fil"    ) ), _VETVENC[I][1] )
		AAdd( (oHtml:ValByName( "tit.mat"    ) ), _VETVENC[I][2] )
		AAdd( (oHtml:ValByName( "tit.nome" 	 ) ), _VETVENC[I][3] )
		AAdd( (oHtml:ValByName( "tit.adim" 	 ) ), _VETVENC[I][4] )
		AAdd( (oHtml:ValByName( "tit.cc" 	 ) ), _VETVENC[I][5] )
		AAdd( (oHtml:ValByName( "tit.dcc" 	 ) ), _VETVENC[I][6] )
		AAdd( (oHtml:ValByName( "tit.turn" 	 ) ), _VETVENC[I][7] )
		AAdd( (oHtml:ValByName( "tit.dtur" 	 ) ), _VETVENC[I][8] )
		AAdd( (oHtml:ValByName( "tit.vcto02" ) ), _dt2 )
	NEXT I
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:Start()
ENDIF

RETURN 

#Include "rwmake.ch"
#Include "colors.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSGPE008   ºAutor  ³Totvs Cascavel     º Data ³  22/06/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina p/ verificar vencimento do 1.periodo de Ferias      º±±
±±º          ³ Aviso 60 dias antes do vencimento e 180 dias apos o venc.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TRELAC                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------------------------------------------------------*
User Function LSGPE008()
*---------------------------------------------------------------------------*

LOCAL _VCTO1
LOCAL _hoje
LOCAL _vetvenc  := {}
LOCAL cEmail
LOCAL cStatus 	:= SPACE(6)            
LOCAL I := 0

_VCTO1   := 60
_VCTO2   := 180

cEmail	 := GETMV("MV_X_EMFRH")
_hoje    := DDATABASE      

DBSELECTAREA("SRA")  

IF SELECT("TMPSRF") > 0
	("TMPSRF")->(dbclosearea())
ENDIF

cQuery := ""
cQuery += " SELECT RF_FILIAL,RF_MAT,RA_NOME,RA_ADMISSA,RA_CC,CTT_DESC01,RA_TNOTRAB,R6_DESC,RF_DATABAS, RF_DATAINI "
cQuery += " FROM " + RetSqlName("SRF") +  " RF "
cQuery += " INNER JOIN SRA010 RA ON RA_MAT = RF_MAT AND RA_CATFUNC NOT IN ('P', 'A') AND RA_SITFOLH <> 'D' AND RA.D_E_L_E_T_ <> '*' "
cQuery += " INNER JOIN CTT010 ON CTT_CUSTO = RA_CC
cQuery += " INNER JOIN SR6010 ON R6_TURNO = RA_TNOTRAB
cQuery += " WHERE RF_STATUS = '1'
cQuery += " GROUP BY RF_FILIAL,RF_MAT,RA_NOME,RA_ADMISSA,RA_CC,CTT_DESC01,RA_TNOTRAB,R6_DESC,RF_DATABAS, RF_DATAINI "
cQuery += " ORDER BY RF_FILIAL, RA_NOME "

MemoWrite("TMPSRF.TXT",cQuery)
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPSRF"
TMPSRF->(DbGotop())

_TESTE1 := dtos(_HOJE + _VCTO1)
_TESTE2 := dtos(_HOJE)


WHILE TMPSRF->(!EOF())
	
	_1dtbase :=  stod(TMPSRF->RF_DATABAS) + 365 
	_1dadmis :=  stod(TMPSRF->RA_ADMISSA)
    _1dprg   :=  stod(TMPSRF->RF_DATAINI)
    _2dtbase :=  stod(TMPSRF->RF_DATABAS) + 545 // 180 DIAS APOS O VENCIMENTO DA 1. FERIAS

	IF _TESTE1 == dtos(_1dtbase)
		aaDD(_vetvenc,{TMPSRF->RF_FILIAL, TMPSRF->RF_MAT, TMPSRF->RA_NOME, _1dadmis, TMPSRF->RA_CC, TMPSRF->CTT_DESC01, TMPSRF->RA_TNOTRAB, TMPSRF->R6_DESC, dtos(_1dtbase), dtos(_1dprg)}) 
    ELSEIF _TESTE2 == dtos(_2dtbase)
        aaDD(_vetvenc,{TMPSRF->RF_FILIAL, TMPSRF->RF_MAT, TMPSRF->RA_NOME, _1dadmis, TMPSRF->RA_CC, TMPSRF->CTT_DESC01, TMPSRF->RA_TNOTRAB, TMPSRF->R6_DESC, dtos(_1dtbase), dtos(_1dprg)}) 
    ENDIF

	TMPSRF->(DBSKIP())
ENDDO
TMPSRF->(dbclosearea())

oProcess := TWFProcess():New("WFVCTFER","Tempo Ferias ")
oProcess :NewTask(cStatus,"\workflow\wfvctfer.html")
oProcess :cSubject := ("Aviso 1. Vencimento de Ferias.")
oProcess :cTo  := cEmail
                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta o workflow            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
IF LEN(_VETVENC) > 0
	oHtml:= oProcess:oHTML

	FOR I := 1 TO len( _VETVENC )
		_dt1 := stod( _VETVENC[I][9] )
		AAdd( (oHtml:ValByName( "tit.emp"    ) ), SM0->M0_CODIGO )
		AAdd( (oHtml:ValByName( "tit.fil"    ) ), _VETVENC[I][1] )
		AAdd( (oHtml:ValByName( "tit.mat"    ) ), _VETVENC[I][2] )
		AAdd( (oHtml:ValByName( "tit.nome" 	 ) ), _VETVENC[I][3] )
		AAdd( (oHtml:ValByName( "tit.adim" 	 ) ), _VETVENC[I][4] )
		AAdd( (oHtml:ValByName( "tit.cc" 	 ) ), _VETVENC[I][5] )
		AAdd( (oHtml:ValByName( "tit.dcc" 	 ) ), _VETVENC[I][6] )
		AAdd( (oHtml:ValByName( "tit.turn" 	 ) ), _VETVENC[I][7] )
		AAdd( (oHtml:ValByName( "tit.dtur" 	 ) ), _VETVENC[I][8] )
		AAdd( (oHtml:ValByName( "tit.vcto01" ) ), _dt1 )
		AAdd( (oHtml:ValByName( "tit.dprg" 	 ) ), _VETVENC[I][10] )
	NEXT I
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:Start()
ENDIF

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSGPE009   ºAutor  ³Totvs Cascavel     º Data ³  22/06/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina p/ verificar vencimento do 2.periodo de Ferias      º±±
±±º          ³ Aviso 90 dias antes do vencimento e 180 dias apos o venc.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TRELAC                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------------------------------------------------------*
User Function LSGPE009()
*---------------------------------------------------------------------------*

LOCAL _VCTO1
LOCAL _hoje
LOCAL _vetvenc  := {}
LOCAL cEmail
LOCAL cStatus 	:= SPACE(6)            
LOCAL I := 0

_VCTO1   := 90
cEmail	 := GETMV("MV_X_EMFRH")
_hoje    := DDATABASE      

DBSELECTAREA("SRA")  

IF SELECT("TMPSRF") > 0
	("TMPSRF")->(dbclosearea())
ENDIF

cQuery := ""
cQuery += " SELECT RF_FILIAL, RF_MAT, RA_NOME, RA_ADMISSA, RA_CC, CTT_DESC01, RA_TNOTRAB, R6_DESC, RF_DATABAS, RF_DATAINI "
cQuery += " FROM " + RetSqlName("SRF") +  " RF "
cQuery += " INNER JOIN SRA010 RA ON RA_MAT = RF_MAT AND RA_CATFUNC NOT IN ('P', 'A') AND RA_SITFOLH <> 'D' AND RA.D_E_L_E_T_ <> '*' "
cQuery += " INNER JOIN CTT010 ON CTT_CUSTO = RA_CC
cQuery += " INNER JOIN SR6010 ON R6_TURNO = RA_TNOTRAB
cQuery += " WHERE RF_STATUS = '1'
cQuery += " GROUP BY RF_FILIAL,RF_MAT,RA_NOME,RA_ADMISSA,RA_CC,CTT_DESC01,RA_TNOTRAB,R6_DESC,RF_DATABAS, RF_DATAINI "
cQuery += " ORDER BY RF_FILIAL, RA_NOME "

MemoWrite("TMPSRF.TXT",cQuery)
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMPSRF"
TMPSRF->(DbGotop())

_TESTE1 := dtos(_HOJE + _VCTO1)
_TESTE2 := dtos(_HOJE)

WHILE TMPSRF->(!EOF())
	
	_1dtbase :=  stod(TMPSRF->RF_DATABAS) + 730
	_1dadmis :=  stod(TMPSRF->RA_ADMISSA)
    _1dprg   :=  stod(TMPSRF->RF_DATAINI)
	_2dtbase :=  stod(TMPSRF->RF_DATABAS) + 910 // 180 DIAS APOS O VENCIMENTO DA 2. FERIAS.

	IF _TESTE1 == dtos(_1dtbase)
		aaDD(_vetvenc,{TMPSRF->RF_FILIAL, TMPSRF->RF_MAT, TMPSRF->RA_NOME, _1dadmis, TMPSRF->RA_CC, TMPSRF->CTT_DESC01, TMPSRF->RA_TNOTRAB, TMPSRF->R6_DESC, dtos(_1dtbase), dtos(_1dprg)}) 
    ELSEIF _TESTE2 == dtos(_2dtbase)
        aaDD(_vetvenc,{TMPSRF->RF_FILIAL, TMPSRF->RF_MAT, TMPSRF->RA_NOME, _1dadmis, TMPSRF->RA_CC, TMPSRF->CTT_DESC01, TMPSRF->RA_TNOTRAB, TMPSRF->R6_DESC, dtos(_1dtbase), dtos(_1dprg)}) 
    ENDIF
	
	TMPSRF->(DBSKIP())
ENDDO
TMPSRF->(dbclosearea())

oProcess := TWFProcess():New("WFVCTFER2","Tempo Ferias 2")
oProcess :NewTask(cStatus,"\workflow\wfvctfer2.html")
oProcess :cSubject := ("Aviso 2. Vencimento de Ferias.")
oProcess :cTo  := cEmail
                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta o workflow            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
IF LEN(_VETVENC) > 0
	oHtml:= oProcess:oHTML

	FOR I := 1 TO len( _VETVENC )
		_dt1 := stod( _VETVENC[I][9] )
		AAdd( (oHtml:ValByName( "tit.emp"    ) ), SM0->M0_CODIGO )
		AAdd( (oHtml:ValByName( "tit.fil"    ) ), _VETVENC[I][1] )
		AAdd( (oHtml:ValByName( "tit.mat"    ) ), _VETVENC[I][2] )
		AAdd( (oHtml:ValByName( "tit.nome" 	 ) ), _VETVENC[I][3] )
		AAdd( (oHtml:ValByName( "tit.adim" 	 ) ), _VETVENC[I][4] )
		AAdd( (oHtml:ValByName( "tit.cc" 	 ) ), _VETVENC[I][5] )
		AAdd( (oHtml:ValByName( "tit.dcc" 	 ) ), _VETVENC[I][6] )
		AAdd( (oHtml:ValByName( "tit.turn" 	 ) ), _VETVENC[I][7] )
		AAdd( (oHtml:ValByName( "tit.dtur" 	 ) ), _VETVENC[I][8] )
		AAdd( (oHtml:ValByName( "tit.vcto01" ) ), _dt1 )
		AAdd( (oHtml:ValByName( "tit.dprg" 	 ) ), _VETVENC[I][10] )
	NEXT I
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:Start()
ENDIF

RETURN
