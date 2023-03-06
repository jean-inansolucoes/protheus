#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSALLFIN  ºAutor ³Alexandre Longhinotti ºData ³  26/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funçoes diversas do financeiro						      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/* Retorna nf de origem da NCC */

User Function RTORINCC()
Local cRet := ""
dbSelectArea("SD1")
cRet := "Titulo Ref. A NF: " + POSICIONE( "SD1",1,XFILIAL( "SD1" ) + SE1->E1_NUM + SE1->E1_PREFIXO,"SD1->D1_NFORI") + " / " + POSICIONE( "SD1",1,XFILIAL( "SD1" ) + SE1->E1_NUM + SE1->E1_PREFIXO,"SD1->D1_SERIORI")                            
If SE1->E1_TIPO == "NCC"
	Aviso( "Informação", cRet, { "OK" } )
Else
	Aviso( "Informação", "Opção disponível para titulos do tipo NCC!", { "OK" } )
EndIf
Return



User Function RTORIABT()
Local cRet := ""
If SE1->E1_TIPO == "NCC"
	dbSelectArea("SE5")
	dbSetOrder(7)
	dbGoTop()
	If dbSeek(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))	
		cRet := "Título compensado: Prefixo/Número: " + SubSTR(SE5->E5_DOCUMEN,1,TAMSX3("E1_PREFIXO")[1])+"/"+SubSTR(SE5->E5_DOCUMEN,TAMSX3("E1_PREFIXO")[1]+1,TAMSX3("E1_NUM")[1])
	Else
		cRet := "Título não localizado no SE5."
	EndIf
	Aviso( "Informação", cRet, { "OK" } )
Else
	Aviso( "Informação", "Opção disponível para titulos do tipo NCC!", { "OK" } )
EndIf

Return

User Function RTSALDO()
LOCAL cRet := ""
LOCAL _nVlrAbat    := 0

_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
cRet := STRZERO(INT(ROUND((SE1->E1_SALDO - (SE1->E1_SDDECRE + _nVlrAbat))*100,2)),13)

Return ( cRet )

User Function RTNUMDOC()
         
Local cRet := ""

cRet := STRZERO(VAL(SUBSTR(SE1->E1_NUM,2,8)),8)+STRZERO(VAL(SUBSTR(SE1->E1_PARCELA,2,2)),2)

Return ( cRet )   

User Function RTNUMDO1()
         
Local cRet := ""
Local cParc := SUBSTR(SE1->E1_PARCELA,2,2)

If Empty(ALLTRIM(cParc))
   cParc := "01"
EndIf

cRet := STRZERO(VAL(SUBSTR(SE1->E1_NUM,2,8)),8)+STRZERO(VAL(cParc),2)

Return ( cRet ) 


User Function RTVALTIT()
LOCAL cRet := ""

If SE1->E1_X_FRMPG = 'BOL'
	cRet := STRZERO(INT(ROUND((SE1->E1_SALDO)*100,2)),13)
Else
	cRet := STRZERO(INT(ROUND((SE1->E1_SALDO - SE1->E1_SDDECRE)*100,2)),13)
EndIf


Return ( cRet )

User Function RTVALDESC()
LOCAL cRet := ""

If INT(ROUND((SE1->E1_SDDECRE)*100,2)) > 0 .and. SE1->E1_X_FRMPG = 'BOL'
	cRet := STRZERO(INT(ROUND((SE1->E1_SDDECRE)*100,2)),13)
Else
	cRet := "0000000000000"
EndIf

Return ( cRet )

User Function RTDTDESC()
LOCAL cRet := ""

If INT(ROUND((SE1->E1_SDDECRE)*100,2)) > 0 .and. SE1->E1_X_FRMPG = 'BOL'
	cRet := GRAVADATA(SE1->E1_VENCTO,.F.,1)
Else
	cRet := "000000"
EndIf

Return ( cRet )

User Function RTVALNOTA()
LOCAL cRet := ""
LOCAL _nVlrNota    := 0

_nVlrNota   :=  POSICIONE( "SF2",1,XFILIAL( "SF2" ) + SE1->E1_NUM + SE1->E1_PREFIXO,"SF2->F2_VALFAT")
cRet := STRZERO(INT(ROUND((_nVlrNota)*100,2)),13)

Return ( cRet )

User Function RTCHAVE()
LOCAL cRet := ""

cRet   :=  POSICIONE( "SF2",1,XFILIAL( "SF2" ) + SE1->E1_NUM + SE1->E1_PREFIXO,"SF2->F2_CHVNFE")

Return ( cRet )   

User Function RTCNABE1()
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10)+CHR(13)     
Local nID 		 := 0
     
	cQuery := "	SELECT MAX(SE1.E1_IDCNAB) AS IDCNAB    					   			"   + hEnter
	cQuery += "	FROM SE1010 SE1									  		  			"   + hEnter
	cQuery += "	WHERE    SE1.E1_IDCNAB != ' '				 	  					"   + hEnter
	cQuery += "	AND 		D_E_L_E_T_ 	!= 	'*' 					   				" 	+ hEnter
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP) 
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nID := (cAliasTMP)->IDCNAB	
	MsgInfo(nID)
	
Return 

User Function RTCNABE2()
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10)+CHR(13)     
Local nID 		 := 0
     
	cQuery := "	SELECT MAX(SE2.E2_IDCNAB) AS IDCNAB    					   			"   + hEnter
	cQuery += "	FROM SE2010 SE2									  		  			"   + hEnter
	cQuery += "	WHERE    SE2.E2_IDCNAB != ' '				 	  					"   + hEnter
	cQuery += "	AND 		D_E_L_E_T_ 	!= 	'*' 					   				" 	+ hEnter
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP) 
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nID := (cAliasTMP)->IDCNAB	
	MsgInfo(nID)
Return 

User Function BRICNAB() 
Public c_Ret := getmv("MV_XSEQREM") 
c_Ret :=c_Ret+1 
PutMv("MV_XSEQREM", c_Ret) 
Return(c_Ret)

User Function 756CNAB() 
Public c_Ret := getmv("MV_SEQREM2") 
c_Ret :=c_Ret+1 
PutMv("MV_SEQREM2", c_Ret) 
Return(c_Ret)
