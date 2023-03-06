#include "rwmake.ch"
#Include "ap5mail.ch"
#Include "tbiconn.ch"
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA420CRI บAutor  ณAlexandre Longhinotti บ Data ณ  18/02/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verificar duplica็ใo do campo E2_IDCNAB.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA420CRI()
Local lRet := .T.
Local cAliasTMP    	:= GetNextAlias()
Local hEnter	   	:= CHR(10) + CHR(13)
Local _cMsg 		:= "Ocorreram problemas na gera็ใo do arquivo de CNAB a Pagar !"+CHR(10)+ ;
"Entre em contato com o Administrador do sistema. "

If (Select(cAliasTMP) <> 0)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
Endif

cQuery := "SELECT SE2.E2_FILIAL,SE2.E2_PORTADO,SE2.E2_NUM,SE2.E2_PARCELA,SE2.E2_EMISSAO,SE2.E2_VENCTO,SE2.E2_VALOR,SE2.E2_IDCNAB, SE2.E2_BAIXA " + hEnter
cQuery += "FROM SE2010 SE2 " 							+ hEnter
cQuery += "WHERE D_E_L_E_T_ = ' ' " 					+ hEnter
cQuery += "AND SE2.E2_IDCNAB IN( SELECT E2.E2_IDCNAB " 	+ hEnter
cQuery += "		FROM SE2010 E2 " 						+ hEnter
cQuery += "		WHERE E2.D_E_L_E_T_ = ' ' " 			+ hEnter
cQuery += "     GROUP BY E2.E2_IDCNAB" 					+ hEnter
cQuery += "     HAVING COUNT(*) > 1) " 					+ hEnter
cQuery += "AND SE2.E2_IDCNAB != ' ' " 					+ hEnter
cQuery += "ORDER BY SE2.E2_IDCNAB"

TcQuery ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())

If (cAliasTMP)->( !EOF() )
	EnvMail()
	Final(_cMsg)
EndIf
Return(lRet)
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

Local _cSubject := "Problema IDCNAB SE2"
Local _cBody    := "Problema IDCNABs da SE2 duplicados, referentes aos borderos: "+MV_PAR01+" a "+MV_PAR02
Local _cDest    := GETMV("MV_X_MDEST")
Local _lOk 		:= .T.
Local _cMsg 		:= "Ocorreram problemas na gera็ใo do arquivo de CNAB a Pagar !"+CHR(10)+ ;
"Entre em contato com o Administrador do sistema. "

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


