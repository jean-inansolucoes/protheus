#include "rwmake.ch"  
#Include "ap5mail.ch"
#Include "tbiconn.ch"
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIN150_1  บAutor  ณJoel Lipnharski     บ Data ณ  04/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verificar duplica็ใo do campo E1_IDCNAB.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIN150_1()
                                                                  
Local cAliasTMP    	:= GetNextAlias() 
Local hEnter	   	:= CHR(10) + CHR(13)
Local _cMsg 		:= "Ocorreram problemas na gera็ใo do arquivo de CNAB a Receber !"+CHR(10)+ ;
					   "Entre em contato com o Administrador do sistema. "

If (Select(cAliasTMP) <> 0)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
Endif

cQuery := "SELECT SE1.E1_FILIAL,SE1.E1_PORTADO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VALOR,SE1.E1_IDCNAB, SE1.E1_BAIXA " + hEnter
cQuery += "FROM SE1010 SE1 " 							+ hEnter
cQuery += "WHERE D_E_L_E_T_ = ' ' " 					+ hEnter
cQuery += "AND SE1.E1_IDCNAB IN( SELECT E1.E1_IDCNAB " 	+ hEnter
cQuery += "		FROM SE1010 E1 " 						+ hEnter
cQuery += "		WHERE E1.D_E_L_E_T_ = ' ' " 			+ hEnter
cQuery += "     GROUP BY E1.E1_IDCNAB" 					+ hEnter
cQuery += "     HAVING COUNT(*) > 1) " 					+ hEnter
cQuery += "AND SE1.E1_IDCNAB != ' ' " 					+ hEnter
cQuery += "ORDER BY SE1.E1_IDCNAB"

TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())

If (cAliasTMP)->( !EOF() )
	EnvMail()
	Final(_cMsg)

/*Else
	RECLOCK( "SEE", .F. )
		SEE->EE_X_ULARQ := ""					
	SEE->( MsUnLock( ) ) */
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail  บAutor  ณJoel Lipnharski      บ Data ณ  04/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio de e-mail informando da duplica็ใo de ID_CNAB.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnvMail()

Local _cSubject := "Problema IDCNAB"
Local _cBody    := "Problema IDCNABs duplicados, referentes aos borderos: "+MV_PAR01+" a "+MV_PAR02
Local _cDest    := GETMV("MV_X_MDEST")
Local _lOk 		:= .T.

CONNECT SMTP SERVER GetMV("MV_RELSERV") ACCOUNT GetMV("MV_RELACNT") PASSWORD GetMV("MV_RELPSW") RESULT _lOk

If _lOk
	If !MailAuth(alltrim(GetMV("MV_RELACNT")),alltrim(GetMV("MV_RELAPSW")) )
		MSGINFO("Falha na autentica็ใo do Usuแrio!")
		DISCONNECT SMTP SERVER RESULT lDisConectou
		_lOk := .F.
	Endif
Else
	MSGINFO("Falha na Comunicacao com o servidor!")
Endif

If _lok
	SEND MAIL FROM GetMV("MV_RELFROM") ;
	TO _cDest ;
	SUBJECT _cSubject ;
	BODY _cBody ;
	RESULT _lOk		
Else
	GET MAIL ERROR cSmtpError
	MsgSTop( "Erro de envio 2: " + cSmtpError+" Favor comunicar ao administrador do sistema.")
Endif

DISCONNECT SMTP SERVER RESULT _lok

If !_lok
	MSGINFO("Falha Disconnetc SMTP!")
Endif

Return

Return()