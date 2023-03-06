#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "APWEBSRV.CH"            
#INCLUDE "RPTDEF.CH" 
#INCLUDE "TOTVS.CH"


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wslaticinio
Web Service Laticinio

@version 1.0
----------------------------------------------------------------------------------------------------*/

#define defDelpdf		.T.
#define defCodemp		"01"
#define defCodfil		"01LAT01"
#define defHashkey		"05341357000157@LATICINIOS.SILVESTRE.LTDA"
#define defNotfound		"Não foram encontrados dados."
#define defParamerror	"Parâmetros inválidos."


wsstruct Produtor
	wsdata cNomprd		as String
endwsstruct 

wsstruct Documento
	wsdata cFildoc		as String
	wsdata cNumdoc		as String
	wsdata cSerdoc		as String
	wsdata cDatdoc		as String	
endwsstruct 

wsstruct Demonstrativo
	wsdata cFilrec		as String
	wsdata cForrec		as String
	wsdata cLojrec		as String
	wsdata cMesrec		as String
	wsdata cAnorec		as String
endwsstruct

wsstruct Informe
	wsdata cFilinf		as String
	wsdata cForinf		as String
	wsdata cLojinf		as String
	wsdata cMesin1		as String
	wsdata cAnoin1		as String
	wsdata cMesin2		as String
	wsdata cAnoin2		as String
endwsstruct  



wsstruct Funcionario
	wsdata cCodfil		as String
	wsdata cMatfun		as String
	wsdata cNomfun		as String
	wsdata cMessag		as String
endwsstruct 
	
wsstruct Recibo
	wsdata cPerrec		as String
	wsdata cMesrec		as String
	wsdata cAnorec		as String
	wsdata cCodrec		as String
	wsdata cNomrec		as String	
endwsstruct 	

wsservice wslaticinio description "Web Service Laticinio"
    
	//Declaração de variaveis
	wsdata aDatdoc			as array of Documento	
	wsdata aDatrec			as array of Demonstrativo
	wsdata aDatinf			as array of Informe
	wsdata aDatprd			as array of Produtor
	wsdata cDemonstrativo	as Base64Binary
	wsdata cInforme			as Base64Binary
	wsdata cDanfe			as Base64Binary
	wsdata cXML				as Base64Binary	
	wsdata lReturn			as Boolean
	wsdata cReturn			as String
	wsdata cCodfil			as String
	wsdata cFornece			as String
	wsdata cLoja			as String
	wsdata cDoc				as String
	wsdata cSerie			as String	
	wsdata cHashkey			as String
	wsdata cLogin			as String
	wsdata cPassword 		as String	
	wsdata cNewpassword		as String
	wsdata cCadpro			as String
	wsdata cRegide			as String
	wsdata cAno				as String
	wsdata cMes				as String
	wsdata cAno2			as String
	wsdata cMes2			as String
	
	
	wsdata aDatfun			as array of Funcionario
	wsdata aDatpag			as array of Recibo
	wsdata cRecibo			as Base64Binary	
	wsdata cFilfun			as String
	wsdata cMatfun			as String
	wsdata cPerrec			as String
	wsdata cTiprec			as String

	//Declaração de metodos                           
	wsmethod wsfrtacs	description "Primeiro acesso do produtor"
	wsmethod wsautweb	description "Autenticação web do produtor"	
	wsmethod wsaltweb	description "Alteração de senha web do produtor"
	wsmethod wsenvpwd	description "Envio de senha por e-mail do produtor"
	wsmethod wsdocweb	description "Documentos de entrada no período"
	wsmethod wsdemweb	description "Demonstrativos de pagamento do produtor no período"
	wsmethod wsdempag	description "Demonstrativo de pagamento do produtor (pdf)"
	wsmethod wsinfweb	description "Informe de rendimentos do produtor no período"
	wsmethod wsinfren	description "Informe de rendimentos do produtor (pdf)"
	wsmethod wsdannfe	description "DANFE NFE (pdf)"
	wsmethod wsxmlnfe	description "XML NFE (xml)" 
	
	wsmethod wsautfun	description "Autenticação  web do funcionário"
	wsmethod wsaltfun	description "Alteração de senha web do funcionário"
	wsmethod wsenvfun	description "Envio de senha por e-mail do funcionário"
	wsmethod wspagfun	description "Recibos de pagamento do funcionário no período"
	wsmethod wsrecfun	description "Recibo de pagamento do funcionário (pdf)"
	
	
endwsservice
           
/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsfrtacs
Primeiro acesso do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsfrtacs wsreceive cHashkey,cLogin,cRegide,cCadpro,cPassword wssend aDatprd wsservice wslaticinio

local lWsret  := .t.
local aReturn := {}
local cRPCEnv := GetEnvServer()
	
	cLogin := REPLACE(cLogin,".","")
	cLogin := REPLACE(cLogin,"-","")
	

	conout(time()+"---------wsfrtacs------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cRegide) .or. empty(::cCadpro) .or. empty(::cPassword)
		SetSoapFault("wsautweb",defParamerror)
		lWsret := .f.
		conout(time()+"---------wsfrtacs------------param error")	
		
	else
		conout(time()+"---------wsfrtacs------------call lsautweb")

		aReturn := startjob("u_lsfrtacs",cRPCEnv,.T.,cRPCEnv,::cLogin,::cRegide,::cCadpro,::cPassword)
		
	endif
		
	if ((type("aReturn") == "A") .or. (type("aReturn") == "U" .and. valtype(aReturn) <> "U"))
		if aReturn[1] == "0"
			SetSoapFault("wsfrtacs","CPF e/ou Registro de Identidade e/ou Cadpro inválido(s)!")
			lWsret := .f.	
		elseif aReturn[1] == "1"
			SetSoapFault("wsfrtacs","Já existe registro de primeiro acesso ao site com os dados informados! Realize o acesso pelo site principal ou utilize a opção 'Esqueceu a senha' na página principal.")
			lWsret := .f.
		else
			aadd(::aDatprd,wsclassnew("Produtor"))
			::aDatprd[len(::aDatprd)]:cNomprd := aReturn[1]
		endif
	else
		SetSoapFault("wsfrtacs",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsfrtacs------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsautweb
Autenticação web do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsautweb wsreceive cHashkey,cLogin,cPassword wssend aDatprd wsservice wslaticinio

local lWsret  := .t.
local aReturn := {}
local cRPCEnv := GetEnvServer()

	conout(time()+"---------wsautweb------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cPassword)
		SetSoapFault("wsautweb",defParamerror)
		lWsret := .f.
		conout(time()+"---------wsautweb------------param error")	
		
	else
		conout(time()+"---------wsautweb------------call lsautweb")
	
		aReturn := startjob("u_lsautweb",cRPCEnv,.T.,cRPCEnv,::cLogin,::cPassword)
		conout(time()+ "---------wsautweb------------call lsautweb-")
	endif
		
	if ((type("aReturn") == "A") .or. (type("aReturn") == "U" .and. valtype(aReturn) <> "U"))
		if (len(aReturn) > 0)
			aadd(::aDatprd,wsclassnew("Produtor"))
			::aDatprd[len(::aDatprd)]:cNomprd := aReturn[len(aReturn),1]
		else
			SetSoapFault("wsautweb","CPF e/ou Senha inválido(s) ou não foi realizado registro de primeiro acesso!")
			lWsret := .f.	
		endif
	else
		SetSoapFault("wsautweb",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsautweb------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsaltweb
Alteração de senha web do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsaltweb wsreceive cHashkey,cLogin,cPassword,cNewpassword wssend lReturn wsservice wslaticinio

local lWsret  := .t.
local lLogin  := .f.
local cRPCEnv := GetEnvServer()

	conout(time()+"---------wsaltweb------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cPassword) .or. empty(::cNewpassword)
		SetSoapFault("wsaltweb",defParamerror)
		lWsret := .f.
		conout(time()+"---------wsaltweb------------param error")	
		
	else
		conout(time()+"---------wsaltweb------------call lsaltweb")
	
		lLogin := startjob("u_lsaltweb",cRPCEnv,.T.,cRPCEnv,::cLogin,::cPassword,::cNewpassword)
		
	endif

	if ((type("lLogin") == "L") .or. (type("lLogin") == "U" .and. valtype(lLogin) <> "U"))
		::lReturn := lLogin
	else
		SetSoapFault("wsaltweb",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsaltweb------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsenvpwd
Envio de senha por e-mail do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsenvpwd wsreceive cHashkey,cLogin wssend cReturn wsservice wslaticinio

local lWsret  := .t.
local cRetjob := ""
local cRPCEnv := GetEnvServer()

	conout(time()+"---------wsenvpwd------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin)
		SetSoapFault("wsenvpwd",defParamerror)
		lWsret := .f.
		conout(time()+"---------wsenvpwd------------param error")	
		
	else
		conout(time()+"---------wsenvpwd------------call lsenvpwd")
	
		cRetjob := startjob("u_lsenvpwd",cRPCEnv,.T.,cRPCEnv,::cLogin)
		
	endif

	if ((type("cRetjob") == "C") .or. (type("cRetjob") == "U" .and. valtype(cRetjob) <> "U"))
		::cReturn := cRetjob
	else
		SetSoapFault("wsenvpwd",defNotfound)
		lWsret := .f.	
	endif		
	
	conout(time()+"---------wsenvpwd------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsdocweb
Documentos de entrada no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsdocweb wsreceive cHashkey,cLogin,cMes,cAno wssend aDatdoc wsservice wslaticinio

local lWsret   := .t.
local aReturn  := {}
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsdocweb------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cMes) .or. empty(::cAno)
		SetSoapFault("wsdocweb",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsdocweb------------param error")	
		
	else
		conout(time()+"---------wsdocweb------------call lsdocweb")
	
		aReturn := startjob("u_lsdocweb",cRPCEnv,.T.,cRPCEnv,::cLogin,::cMes,::cAno)
		
	endif
	
	if ((type("aReturn") == "A") .or. (type("aReturn") == "U" .and. valtype(aReturn) <> "U"))
		if (len(aReturn) > 0)
			for i := 1 to len(aReturn)
				aadd(::aDatdoc,wsclassnew("Documento"))
				::aDatdoc[i]:cFildoc := aReturn[i,1]
				::aDatdoc[i]:cNumdoc := aReturn[i,2]
				::aDatdoc[i]:cSerdoc := aReturn[i,3]
				::aDatdoc[i]:cDatdoc := aReturn[i,4]
			next
		else
			SetSoapFault("wsdocweb",defNotfound)
			lWsret := .f.	
		endif
	else
		SetSoapFault("wsdocweb",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsdocweb------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsdemweb
Demonstrativos de pagamento no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsdemweb wsreceive cHashkey,cLogin,cMes,cAno wssend aDatrec wsservice wslaticinio

local lWsret   := .t.
local aReturn  := {}
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsdemweb------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cMes) .or. empty(::cAno)
		SetSoapFault("wsdemweb",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsdemweb------------param error")	
		
	else
		conout(time()+"---------wsdemweb------------call lsdemweb")
	
		aReturn := startjob("u_lsdemweb",cRPCEnv,.T.,cRPCEnv,::cLogin,::cMes,::cAno)
		
	endif
	
	if ((type("aReturn") == "A") .or. (type("aReturn") == "U" .and. valtype(aReturn) <> "U"))
		if (len(aReturn) > 0)
			for i := 1 to len(aReturn)
				aadd(::aDatrec,wsclassnew("Demonstrativo"))
				::aDatrec[i]:cFilrec := aReturn[i,1]
				::aDatrec[i]:cForrec := aReturn[i,2]
				::aDatrec[i]:cLojrec := aReturn[i,3]
				::aDatrec[i]:cMesrec := aReturn[i,4]
				::aDatrec[i]:cAnorec := aReturn[i,5]
			next
		else
			SetSoapFault("wsdemweb",defNotfound)	
			lWsret := .f.		
		endif
	else
		SetSoapFault("wsdemweb",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsdemweb------------end")
	
return (lWsret)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsdempag
Demonstrativo de pagamento

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsdempag wsreceive cHashkey,cCodfil,cFornece,cLoja,cMes,cAno wssend cDemonstrativo wsservice wslaticinio

local lWsret   := .t.
local cReturn  := ""
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsdempag------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cCodfil) .or. empty(::cFornece) .or. empty(::cLoja) .or. empty(::cMes) .or. empty(::cAno)
		SetSoapFault("wsdempag",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsdempag------------param error")	
		
	else
		conout(time()+"---------wsdempag------------call lsdempag")
	
		cReturn := startjob("u_lsdempag",cRPCEnv,.T.,cRPCEnv,::cCodfil,::cFornece,::cLoja,::cMes,::cAno)
		
	endif	

	if (type("cReturn") == "C") .or. (type("cReturn") == "U" .and. valtype(cReturn) <> "U")
		if !empty(cReturn)
			::cDemonstrativo := cReturn
		else
			SetSoapFault("wsdempag",defNotfound)
			lWsret := .f.	
		endif
	else
		SetSoapFault("wsdempag",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsdempag------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsinfweb
Demonstrativos de pagamento no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsinfweb wsreceive cHashkey,cLogin,cMes,cAno, cMes2, cAno2 wssend aDatinf wsservice wslaticinio

local lWsret   := .t.
local aReturn  := {}
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsinfweb------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cMes) .or. empty(::cAno) .or. empty(::cMes2) .or. empty(::cAno2)
		SetSoapFault("wsinfweb",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsinfweb------------param error")	
		
	else
		conout(time()+"---------wsinfweb------------call lsinfweb")
	
		aReturn := startjob("u_lsinfweb",cRPCEnv,.T.,cRPCEnv,::cLogin,::cMes,::cAno,::cMes2,::cAno2)
		
	endif
	
	if ((type("aReturn") == "A") .or. (type("aReturn") == "U" .and. valtype(aReturn) <> "U"))
		if (len(aReturn) > 0)
			for i := 1 to len(aReturn)
				aadd(::aDatinf,wsclassnew("Informe"))
				::aDatinf[i]:cFilinf := aReturn[i,1]
				::aDatinf[i]:cForinf := aReturn[i,2]
				::aDatinf[i]:cLojinf := aReturn[i,3]
				::aDatinf[i]:cMesin1 := aReturn[i,4]
				::aDatinf[i]:cAnoin1 := aReturn[i,5]
				::aDatinf[i]:cMesin2 := aReturn[i,6]
				::aDatinf[i]:cAnoin2 := aReturn[i,7]
			next
		else
			SetSoapFault("wsinfweb",defNotfound)	
			lWsret := .f.		
		endif
	else
		SetSoapFault("wsinfweb",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsinfweb------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsinfren
Demonstrativo de pagamento

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsinfren wsreceive cHashkey,cCodfil,cFornece,cLoja,cMes,cAno,cMes2,cAno2 wssend cInforme wsservice wslaticinio

local lWsret   := .t.
local cReturn  := ""
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsinfren------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cCodfil) .or. empty(::cFornece) .or. empty(::cLoja) .or. empty(::cMes) .or. empty(::cAno) .or. empty(::cMes2) .or. empty(::cAno2)
		SetSoapFault("wsinfren",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsinfren------------param error")	
		
	else
		conout(time()+"---------wsinfren------------call lsinfren")
	
		cReturn := startjob("u_lsinfren",cRPCEnv,.T.,cRPCEnv,::cCodfil,::cFornece,::cLoja,::cMes,::cAno,::cMes2,::cAno2)
		
	endif	

	if (type("cReturn") == "C") .or. (type("cReturn") == "U" .and. valtype(cReturn) <> "U")
		if !empty(cReturn)
			::cInforme := cReturn
		else
			SetSoapFault("wsinfren",defNotfound)
			lWsret := .f.	
		endif
	else
		SetSoapFault("wsinfren",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsinfren------------end")
	
return (lWsret)



/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsdannfe
DANFE NFE

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsdannfe wsreceive cHashkey,cCodfil,cDoc,cSerie wssend cDanfe wsservice wslaticinio

local lWsret   := .t.
local cReturn  := ""
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsdannfe------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cCodfil) .or. empty(::cDoc) .or. empty(::cSerie)
		SetSoapFault("wsdannfe",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsdannfe------------param error")	
		
	else
		conout(time()+"---------wsdannfe------------call lsdempag")
	
		cReturn := startjob("u_lsdannfe",cRPCEnv,.T.,cRPCEnv,::cCodfil,::cDoc,::cSerie)
		
	endif
	                            

	if (type("cReturn") == "C") .or. (type("cReturn") == "U" .and. valtype(cReturn) <> "U")
		if !empty(cReturn)
			::cDanfe := cReturn				
		else                     
			SetSoapFault("wsdannfe",defNotfound)
			lWsret := .f.	
		endif
	else                         
		SetSoapFault("wsdannfe",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsdannfe------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsxmlnfe
XML NFE

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsxmlnfe wsreceive cHashkey,cCodfil,cDoc,cSerie wssend cXML wsservice wslaticinio

local lWsret   := .t.
local cReturn  := ""
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsxmlnfe------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cCodfil) .or. empty(::cDoc) .or. empty(::cSerie)
		SetSoapFault("wsxmlnfe",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsxmlnfe------------param error")	
		
	else
		conout(time()+"---------wsxmlnfe------------call lsxmlnfe")
	
		cReturn := startjob("u_lsxmlnfe",cRPCEnv,.T.,cRPCEnv,::cCodfil,::cDoc,::cSerie)
		
	endif                                                          
	
	
	if (type("cReturn") == "C") .or. (type("cReturn") == "U" .and. valtype(cReturn) <> "U")
		if !empty(cReturn)
			::cXML := cReturn
		else
			SetSoapFault("wsxmlnfe",defNotfound)
			lWsret := .f.	
		endif
	else
		SetSoapFault("wsxmlnfe",defNotfound)
		lWsret := .f.
	endif	
		
	conout(time()+"---------wsxmlnfe------------end")
	
return (lWsret)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsfrtacs
Primeiro acesso do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsfrtacs(pRPCEnv,pLogin,pRegide,pCadpro,pPassword)     

local aReturn := {"0"}
	pLogin := REPLACE(pLogin,".","")
	pLogin := REPLACE(pLogin,"-","")
	conout(time()+"---------lsfrtacs------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	dbselectarea("SA2")
	SA2->(dbsetorder(3))
	SA2->(dbgotop())
	if SA2->(dbseek(xfilial("SA2")+alltrim(pLogin)),.t.)
		if alltrim(SA2->A2_CGC) == alltrim(pLogin)
			conout(time()+"---------lsfrtacs------------cgc")
			if alltrim(SA2->A2_PFISICA) == alltrim(pRegide)    
				conout(time()+"---------lsfrtacs------------pfisica")
				if alltrim(SA2->A2_INSCR) == alltrim(pCadpro)        
					conout(time()+"---------lsfrtacs------------inscr")
					if !empty(SA2->A2_X_LWEB)                                 
						conout(time()+"---------lsfrtacs------------lweb")
						aReturn := {"1"}
					else
						if reclock("SA2",.f.)
							SA2->A2_X_PWEB := alltrim(pPassword)
							SA2->A2_X_LWEB := dtoc(date())+"-"+time()
							SA2->(msunlock())
							aReturn := {alltrim(SA2->A2_NOME), alltrim(SA2->A2_PAIS)}
						endif                                  									
						conout(time()+"---------lsfrtacs------------lsautweb")						
					endif
				 endif
			endif
		endIf
	endif	
	RpcClearEnv()
	
	conout(time()+"---------lsfrtacs------------end")


return (aReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsautweb
Autenticação web do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsautweb(pRPCEnv,pLogin,pPassword)     

local aReturn := {}
	
	conout(time()+"---------lsautweb------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	dbselectarea("SA2")
	SA2->(dbsetorder(3))
	SA2->(dbgotop())
	if SA2->(dbseek(xfilial("SA2")+alltrim(pLogin)),.t.)
		if alltrim(SA2->A2_CGC) == alltrim(pLogin)
			conout(time()+"---------lsautweb------------found")
			if alltrim(SA2->A2_X_PWEB) == alltrim(pPassword)
				if !empty(SA2->A2_X_LWEB)
					if reclock("SA2",.f.)
						SA2->A2_X_EWEB := 0
						SA2->A2_X_LWEB := dtoc(date())+"-"+time()
						SA2->(msunlock())
					endif                                  			
					aadd(aReturn,{alltrim(SA2->A2_NOME),alltrim(SA2->A2_PAIS)})
					conout(time()+"---------lsautweb------------password")
				endif
			endif
		endIf
	endif	
	RpcClearEnv()
	
	conout(time()+"---------lsautweb------------end")


return (aReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsaltweb
Alteração de senha web do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsaltweb(pRPCEnv,pLogin,pPassword,pNewpassword)     

local lReturn := .f.
	
	conout(time()+"---------lsaltweb------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	dbselectarea("SA2")
	SA2->(dbsetorder(3))
	SA2->(dbgotop())
	if SA2->(dbseek(xfilial("SA2")+alltrim(pLogin)),.t.)
		if alltrim(SA2->A2_CGC) == alltrim(pLogin)
			conout(time()+"---------lsaltweb------------found")
			if alltrim(SA2->A2_X_PWEB) == alltrim(pPassword)
				if reclock("SA2",.F.)
					SA2->A2_X_PWEB := alltrim(pNewpassword)
					SA2->(msunlock())
					lReturn := .t.
					conout(time()+"---------lsaltweb------------change")
				endif			
				conout(time()+"---------lsaltweb------------password")
			endif
		endIf
	endif
		
	RpcClearEnv()
	
	conout(time()+"---------lsaltweb------------end")


return (lReturn)



/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsaltweb
Envio de senha por e-mail do produtor

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsenvpwd(pRPCEnv,pLogin)     

local lReturn := .f.
local cReturn := ""
	
	conout(time()+"---------lsenvpwd------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	dbselectarea("SA2")
	SA2->(dbsetorder(3))
	SA2->(dbgotop())
	if SA2->(dbseek(xfilial("SA2")+alltrim(pLogin)),.t.)
		if alltrim(SA2->A2_CGC) == alltrim(pLogin)
			conout(time()+"---------lsenvpwd------------found")
			if !empty(SA2->A2_EMAIL)
				if (SA2->A2_X_EWEB <= 2) //controle SPAM
					conout(time()+"---------lsenvpwd------------lsendmail")								
					cBody := '<html>'
					cBody += 'Recebemos o pedido para envio de senha de acesso ao site do produtor.'
					cBody += '<br>'
					cBody += '<br>'
					cBody += 'CPF: '+alltrim(SA2->A2_CGC)
					cBody += '<br>'
					cBody += 'Senha: '+alltrim(SA2->A2_X_PWEB)
					cBody += '<br>'
					cBody += '<br>'
					cBody += 'Favor não responder, e-mail autom&aacute;tico.'		
					cBody += '</html>'				
					cSubject := 'Laticínio Silvestre - Envio de senha por e-mail'										
					lReturn := u_lsendmail(alltrim(SA2->A2_EMAIL),cSubject,cBody)				
					if lReturn
						if reclock("SA2",.f.)
							SA2->A2_X_EWEB := (SA2->A2_X_EWEB+1)
							SA2->(msunlock())
						endif
						cReturn := "E-mail enviado para: "+alltrim(SA2->A2_EMAIL)
					else                                                         
						cReturn := "Erro não fun&ccedil;&atilde;o de envio de e-mail. Entre em contato com o Latic&iacute;nio."
					endif                                                         								
				else
					cReturn := "E-mail com a senha de acesso j&aacute; enviado para: "+alltrim(SA2->A2_EMAIL)
				endif
			else
				cReturn := "E-mail não cadastrado! Entre em contato com o Latic&iacute;nio."
			endif
		else                            
			cReturn := "CPF não localizado!"
		endif
	else
		cReturn := "CPF não localizado!"
	endIf
	
	RpcClearEnv()
	
	conout(time()+"---------lsenvpwd------------end")


return (cReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsendmail
Envio de e-mail genérico

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsendmail(pEmail,pSubject,pBody)

local lReturn		:= .t.
local cReturn		:= ""
local nTMailManager	:= 0
local cFrom			:= GetMv("MV_RELFROM",.F.,"")
local cSMTPServer	:= GetMv("MV_RELSERV",.F.,"")
local cSMTPUser 	:= GetMv("MV_RELACNT",.F.,"")
local cSMTPPass 	:= GetMv("MV_RELPSW",.F.,"")
local nSMTPPort		:= GetMv("MV_PORSMTP",.F.,25)
local nSMTPTimeout	:= GetMv("MV_RELTIME",.F.,60)
local lRelAuth 		:= GetMv("MV_RELAUTH",.F.,.F.)
local lRelSSL		:= GetMv("MV_RELSSL",.F.,.F.)
local lRelTLS		:= GetMv("MV_RELTLS",.F.,.F.)
local oMail			:= Nil
local oMessage 		:= Nil

	conout(time()+"---------lsendmail------------start")
	
	if (':'$cSMTPServer)
		aArr := strtokarr(cSMTPServer,':')
		if (len(aArr)==2)
			cSMTPServer := aArr[1]
			nSMTPPort := val(aArr[2])
		endif
	endif

	oMail := TMailManager():New()
	
	if (lRelSSL)
		oMail:SetUseSSL(lRelSSL)
	endif
	if (lRelTLS)
		oMail:SetUseTLS(lRelTLS)
	endif
	 
	oMail:Init('', cSMTPServer, cSMTPUser, cSMTPPass, 0, nSMTPPort)	
	oMail:SetSmtpTimeOut(nSMTPTimeout)

	nTMailManager := oMail:SmtpConnect()
	if nTMailManager == 0 .and. lRelAuth 
		nTMailManager := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)		
		if nTMailManager <> 0
			cReturn := oMail:GetErrorString(nTMailManager)
			lReturn := .f.
		endif
	endIf                                                     

	if nTMailManager <> 0
		cReturn := oMail:GetErrorString(nTMailManager)		
		lReturn := .f.
	endif

	if empty(cReturn)
		
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cFrom
		oMessage:cTo		:= pEmail
		oMessage:cSubject	:= pSubject
		oMessage:cBody		:= pBody
		oMessage:MsgBodyType("text/html")
	
		nTMailManager := oMessage:Send(oMail)
		if nTMailManager <> 0
			cReturn := oMail:GetErrorString(nTMailManager)					
			lReturn := .f.
		else
			cReturn := 'E-mail enviado para: '+pEmail
		endif
	    
		conout(time()+"---------lsendmail------------cReturn send "+cReturn)
		
		oMail:SMTPDisconnect()
	else
		conout(time()+"---------lsendmail------------cReturn connect "+cReturn)
	endif
	
	conout(time()+"---------lsendmail------------end")

Return (lReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsdocweb
Documentos de entrada no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsdocweb(pRPCEnv,pLogin,pMes,pAno)     

local aReturn := {}
	
	conout(time()+"---------lsdocweb------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	cQuery := Getnextalias()
	
	cCondicao := "% sa2.a2_cgc = '"+alltrim(pLogin)+"' and substring(sf1.f1_emissao,1,6) = '"+strzero(val(pAno),4)+strzero(val(pMes),2)+"' %"
	BeginSQL alias cQuery
		select sf1.f1_filial, sf1.f1_doc, sf1.f1_serie, sf1.f1_emissao from %table:sf1% sf1, %table:sa2% sa2 
		where  sf1.f1_fornece = sa2.a2_cod and sf1.f1_loja = sa2.a2_loja and sf1.f1_formul = 'S' 
		and %exp:cCondicao% and sf1.%notdel% and sa2.%notdel%
	EndSQL
	while !(cQuery)->(eof())
		aadd(aReturn,{(cQuery)->f1_filial,(cQuery)->f1_doc,(cQuery)->f1_serie,(cQuery)->f1_emissao})
		conout(time()+"---------lsdocweb------------f1_doc "+(cQuery)->f1_doc)
		(cQuery)->(dbskip())
	end
	(cQuery)->(dbclosearea())
		
		
	RpcClearEnv()
	
	conout(time()+"---------lsdocweb------------end")


return (aReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsdemweb
Demonstrativos de pagamento no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsdemweb(pRPCEnv,pLogin,pMes,pAno)     

local aReturn := {}
	
	conout(time()+"---------lsdemweb------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	cQuery := Getnextalias()
	
	cCondicao := "% sa2.a2_cgc = '"+alltrim(pLogin)+"' and substring(zl5.zl5_data,1,6) = '"+strzero(val(pAno),4)+strzero(val(pMes),2)+"' %"
	    
	BeginSQL alias cQuery
		select distinct zl6.zl6_filial, zl6.zl6_produt, zl6.zl6_lojprd 
		from %table:zl5% zl5, %table:zl6% zl6, %table:sa2% sa2 
		where zl6.zl6_produt = sa2.a2_cod and zl6.zl6_lojprd = sa2.a2_loja 
		and zl5.zl5_filial = zl6.zl6_filial and zl5.zl5_cod = zl6.zl6_cod
		and zl6.zl6_qtde > 0 and %exp:cCondicao% 
		and zl5.%notdel% and zl6.%notdel% and sa2.%notdel%
	EndSQL
	while !(cQuery)->(eof())
		aadd(aReturn,{(cQuery)->zl6_filial,(cQuery)->zl6_produt,(cQuery)->zl6_lojprd,strzero(val(pMes),2),strzero(val(pAno),4)})
		conout(time()+"---------lsdemweb------------zl6_produt "+(cQuery)->zl6_produt)
		(cQuery)->(dbskip())
	end
	(cQuery)->(dbclosearea())
		
		
	RpcClearEnv()
	
	conout(time()+"---------lsdemweb------------end")


return (aReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsdempag
Demonstrativo de pagamento (pdf)

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsdempag(pRPCEnv,pCodfil,pFornece,pLoja,pMes,pAno)     

local lReturn	:= .f.
local cReturn	:= ""
local nAttmax	:= 10
local nAttempt	:= 0

	conout(time()+"---------lsdempag------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	while (nAttempt<nAttmax)
		nAttempt++
		cFile := ExecBlock("Demograf",.F.,.F.,{pCodfil,pFornece,pLoja,val(pMes),val(pAno)})		
		sleep(3000)

		conout(time()+"---------lsdempag------------Demograf "+cFile)						

		aFile := directory(cFile)
		if len(aFile) > 0
			if (noround((aFile[Len(aFile),2])/1024,0) > 1)
				lReturn := .t.                                         
				exit
			endIf
		endIf		
		sleep(2000)
	end	
	
	if lReturn
		nHdlFile := fOpen(cFile,68)
		nTamFile := fSeek(nHdlFile,0,2)
		fSeek(nHdlFile,0,0)
		cBuffer  := Space(nTamFile)
		nBtLidos := fRead(nHdlFile,@cBuffer,nTamFile)	
		fClose(nHdlFile)
		cReturn := encode64(cBuffer)
		if defDelpdf
			ferase(cFile)
		endif
		conout(time()+"---------lsdempag------------cFile "+cFile)		
	endif
	
		
	RpcClearEnv()
	
	conout(time()+"---------lsdempag------------end")

return (cReturn)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsinfweb
Informe de rendimentos no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsinfweb(pRPCEnv,pLogin,pMes,pAno,pMes2,pAno2)     

local aReturn := {}
	
	conout(time()+"---------lsinfweb------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	cQuery := Getnextalias()
	
	cCondicao := "% sf1.f1_fornece = '"+alltrim(substr(pLogin,1,9))+"' and substring(sf1.f1_emissao,1,6) >= '"+strzero(val(pAno),4)+strzero(val(pMes),2)+"' and substring(sf1.f1_emissao,1,6) <= '"+strzero(val(pAno2),4)+strzero(val(pMes2),2)+"' %"
	    
	BeginSQL alias cQuery
		select distinct sf1.f1_filial ,sf1.f1_fornece, sf1.f1_loja		
		from %table:sf1% sf1 
		where %exp:cCondicao% 
		and sf1.%notdel%
	EndSQL
	while !(cQuery)->(eof())
		aadd(aReturn,{(cQuery)->f1_filial, (cQuery)->f1_fornece, (cQuery)->f1_loja,strzero(val(pMes),2),strzero(val(pAno),4),strzero(val(pMes2),2),strzero(val(pAno2),4)})
		conout(time()+"---------lsinfweb------------f1_fornece ")
		(cQuery)->(dbskip())
	end
	(cQuery)->(dbclosearea())
		
		
	RpcClearEnv()
	
	conout(time()+"---------lsinfweb------------end")


return (aReturn)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsinfren
Informe de Rendimentos (pdf)

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsinfren(pRPCEnv,pCodfil,pFornece,pLoja,pMes,pAno,pMes2,pAno2)     

local lReturn	:= .f.
local cReturn	:= ""
local nAttmax	:= 10
local nAttempt	:= 0

	conout(time()+"---------lsinfren------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	while (nAttempt<nAttmax)
		nAttempt++
		cFile := ExecBlock("LTREL034",.F.,.F.,{pCodfil,pFornece,pLoja,val(pMes),val(pAno),val(pMes2),val(pAno2)})
		sleep(3000)

		conout(time()+"---------lsinfren------------LTREL034 "+cFile)						

		aFile := directory(cFile)
		if len(aFile) > 0
			if (noround((aFile[Len(aFile),2])/1024,0) > 1)
				lReturn := .t.                                         
				exit
			endIf
		endIf		
		sleep(2000)
	end	
	
	if lReturn
		nHdlFile := fOpen(cFile,68)
		nTamFile := fSeek(nHdlFile,0,2)
		fSeek(nHdlFile,0,0)
		cBuffer  := Space(nTamFile)
		nBtLidos := fRead(nHdlFile,@cBuffer,nTamFile)	
		fClose(nHdlFile)
		cReturn := encode64(cBuffer)
		if defDelpdf
			ferase(cFile)
		endif
		conout(time()+"---------lsinfren------------cFile "+cFile)		
	endif
	
		
	RpcClearEnv()
	
	conout(time()+"---------lsinfren------------end")

return (cReturn)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsdannfe
DANFE NFE (pdf)

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsdannfe(pRPCEnv,pCodfil,pDoc,pSerie)     

local lReturn	:= .f.
local cReturn	:= ""
local nAttmax	:= 10
local nAttempt	:= 0

	conout(time()+"---------lsdannfe------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)

	dbselectarea("SM0")
	SM0->(dbgotop())
	SM0->(dbsetorder(1))
	if (dbseek(defCodemp+pCodfil))
		cFilant := pCodfil
		cIdent  := u_getidenttss()
	                                                   	
		if !empty(cIdent)                              
		
			conout(time()+"---------lsdannfe------------cident")
		
			while (nAttempt<nAttmax)
	                                                 
				nAttempt++
				conout(time()+"---------lsdannfe------------attempt "+cvaltochar(nAttempt))
				
				private cPathnfe := "\spool\pdf\"		
				private cFilenfe := "danfe"+cvaltochar(ThreadID())+dtos(date())+strtran(time(),":","")
				private cDocnfe := pDoc
				private cSernfe := pSerie
				private nTipnfe := 1
				private oSetup  := Nil
				
				//oSetup:=FWPrintSetup():New(PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN, "DANFE")
				//oSetup:SetPropert(PD_PRINTTYPE , 6)
				//oSetup:SetPropert(PD_ORIENTATION , 1)
				//oSetup:SetPropert(PD_DESTINATION , 1)
				//oSetup:SetPropert(PD_MARGIN , {60,60,60,60})
				//oSetup:SetPropert(PD_PAPERSIZE , 2)
				//oSetup:aOptions[PD_VALUETYPE] := cPathnfe
				oDanfe := FWMSPrinter():New(cFilenfe, IMP_PDF, .F. ,cPathnfe, .T., , , , , .F., ,.F. , )
				u_PrtNfeSef(cIdent,,,oDanfe, /*oSetup*/, cFilenfe,, 0)				
				sleep(3000)
				
				cFile := cPathnfe+cFilenfe+".pdf"		
				aFile := directory(cFile)
				if len(aFile) > 0					
					if (noround((aFile[Len(aFile),2])/1024,0) > 1)
						lReturn := .t. 
						exit
					endIf
				endIf		
				sleep(2000)
			end	
			
			if lReturn
				nHdlFile := fOpen(cFile,68)
				nTamFile := fSeek(nHdlFile,0,2)
				fSeek(nHdlFile,0,0)
				cBuffer  := Space(nTamFile)
				nBtLidos := fRead(nHdlFile,@cBuffer,nTamFile)	
				fClose(nHdlFile)
				cReturn := encode64(cBuffer)
				if defDelpdf
					ferase(cFile)
				endif				
				conout(time()+"---------lsdannfe------------cFile "+cFile)		
			endif
		endif	
	endif		
		
	RpcClearEnv()
	
	conout(time()+"---------lsdannfe------------end")

return (cReturn)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsxmlnfe
XML NFE (xml)

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsxmlnfe(pRPCEnv,pCodfil,pDoc,pSerie)     
                     
local cReturn := ""

	conout(time()+"---------lsxmlnfe------------start")
	                   
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	dbselectarea("SM0")
	SM0->(dbgotop())
	SM0->(dbsetorder(1))
	if (dbseek(defCodemp+pCodfil))
        cFilant := pCodfil
		cReturn := u_getxmltss(pDoc,pSerie)	
	endif
		
	RpcClearEnv()
	
	conout(time()+"---------lsxmlnfe------------end")

return (cReturn)
             	

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} getidenttss
ID Entidade TSS

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function getidenttss()

local cURL   		:= SuperGetMV("MV_SPEDUR1",,"")+"/SPEDADM.apw"
local cIdent 		:= ""
local lMethodOk		:= .f.
local oWsSPEDAdm	:= Nil

	conout(time()+"---------getidenttss------------start")
	
	if CTIsReady()

		oWsSPEDAdm										:= WsSPEDAdm():New()
		oWsSPEDAdm:cUSERTOKEN 							:= "TOTVS"
		oWsSPEDAdm:oWsEmpresa:cCNPJ       				:= SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"")	 )
		oWsSPEDAdm:oWsEmpresa:cCPF        				:= SM0->( IF(M0_TPINSC==3,M0_CGC,"") )
		oWsSPEDAdm:oWsEmpresa:cIE         				:= SM0->M0_INSC
		oWsSPEDAdm:oWsEmpresa:cIM         				:= SM0->M0_INSCM		
		oWsSPEDAdm:oWsEmpresa:cNOME       				:= SM0->M0_NOMECOM
		oWsSPEDAdm:oWsEmpresa:cFANTASIA   				:= SM0->M0_NOME
		oWsSPEDAdm:oWsEmpresa:cENDERECO   				:= FisGetEnd(SM0->M0_ENDENT)[1]
		oWsSPEDAdm:oWsEmpresa:cNUM        				:= FisGetEnd(SM0->M0_ENDENT)[3]
		oWsSPEDAdm:oWsEmpresa:cCOMPL      				:= FisGetEnd(SM0->M0_ENDENT)[4]
		oWsSPEDAdm:oWsEmpresa:cUF         				:= SM0->M0_ESTENT
		oWsSPEDAdm:oWsEmpresa:cCEP        				:= SM0->M0_CEPENT
		oWsSPEDAdm:oWsEmpresa:cCOD_MUN    				:= SM0->M0_CODMUN
		oWsSPEDAdm:oWsEmpresa:cCOD_PAIS   				:= "1058"
		oWsSPEDAdm:oWsEmpresa:cBAIRRO     				:= SM0->M0_BAIRENT
		oWsSPEDAdm:oWsEmpresa:cMUN        				:= SM0->M0_CIDENT
		oWsSPEDAdm:oWsEmpresa:cCEP_CP     				:= NIL
		oWsSPEDAdm:oWsEmpresa:cCP         				:= NIL
		oWsSPEDAdm:oWsEmpresa:cDDD        				:= Str(FisGetTel(SM0->M0_TEL)[2],3)
		oWsSPEDAdm:oWsEmpresa:cFONE       				:= AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
		oWsSPEDAdm:oWsEmpresa:cFAX        				:= AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
		oWsSPEDAdm:oWsEmpresa:cEMAIL      				:= UsrRetMail(RetCodUsr())
		oWsSPEDAdm:oWsEmpresa:cNIRE       				:= SM0->M0_NIRE
		oWsSPEDAdm:oWsEmpresa:dDTRE       				:= SM0->M0_DTRE
		oWsSPEDAdm:oWsEmpresa:cNIT        				:= SM0->( IF(M0_TPINSC==1,M0_CGC,"") )
		oWsSPEDAdm:oWsEmpresa:cINDSITESP  				:= ""
		oWsSPEDAdm:oWsEmpresa:cID_MATRIZ  				:= ""
		oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao		:= SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
		oWsSPEDAdm:_URL									:= cURL
		lMethodOk										:= oWsSPEDAdm:AdmEmpresas()
	
	
		default lMethodOk := .f.
		if !(lMethodOk)
			cError := if(empty(GetWscError(3)), GetWscError(1), GetWscError(3))
			conout(time()+"---------getidenttss------------cError "+cError)
			return (cIdent)
		endif
	
		cIdent  := oWsSPEDAdm:cAdmEmpresasResult
		
		conout(time()+"---------getidenttss------------cIdent "+cIdent)
		
	endif
	
	conout(time()+"---------getidenttss------------end")

return (cIdent)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} getxmltss
XML NFE

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function getxmltss(pDoc,pSerie)

local cURL   		:= SuperGetMV("MV_SPEDUR1",,"")+"/NFESBRA.apw"
local lRetornaFxOk	:= .f.
local cXml			:= ""
local cIdent 		:= u_getidenttss()
local oWsNFeSBRA	:= Nil         


	conout(time()+"---------getxmltss------------start")


	if !empty(cIdent)

		oWsNFeSBRA						:= WSNFeSBRA():New()
		oWsNFeSBRA:cUSERTOKEN        	:= "TOTVS"
		oWsNFeSBRA:cID_ENT           	:= cIdent 
		oWsNFeSBRA:_URL              	:= cURL
		oWsNFeSBRA:nDIASPARAEXCLUSAO	:= 0
		
		oWsNFeSBRA:oWSNFEID				:= NFESBRA_NFES2():New()
		oWsNFeSBRA:oWSNFEID:oWSNotas	:= NFESBRA_ARRAYOFNFESID2():New()  
		
		aadd(oWsNFeSBRA:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
		Atail(oWsNFeSBRA:oWSNFEID:oWSNotas:oWSNFESID2):cID := pSerie+pDoc	
		lRetornaFxOk		  			:= oWsNFeSBRA:RETORNANOTASNX()

		default lRetornaFxOk := .f.		
		if (lRetornaFxOk)

			nLennfe := len(oWsNFeSBRA:oWSRETORNANOTASNXRESULT:oWsNotas:OWSNFES5)

			if (nLennfe > 0)
			
				cXmlnfe := oWsNFeSBRA:oWSRETORNANOTASNXRESULT:oWsNotas:OWSNFES5[nLennfe]:oWsNFE:CXML
				cXmlprt := oWsNFeSBRA:oWSRETORNANOTASNXRESULT:oWsNotas:OWSNFES5[nLennfe]:oWsNFE:CXMLPROT				
				cXml := '<?xml version="1.0" encoding="UTF-8"?><nfeProc versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">' + cXmlnfe + cXmlprt + '</nfeProc>'				
				cXml := encode64(cXml)
				conout(time()+"---------getxmltss------------xml")

			endif
		
		endif
	
	endif	

	conout(time()+"---------getxmltss------------end")

return (cXml)




//**********************************************************************************//
//**********************************************************************************//
//**********************************************************************************//
//**********************************************************************************//
//**********************************************************************************//
//**********************************************************************************//
//**********************************************************************************//


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsautfun
Autenticação web do funcionário

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsautfun wsreceive cHashkey,cLogin,cPassword wssend aDatfun wsservice wslaticinio

local lWsret  := .t.
local aReturn := {}
local cRPCEnv := GetEnvServer()

	conout(time()+"---------wsautfun------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cPassword)
		SetSoapFault("wsautfun",defParamerror)
		lWsret := .f.
		conout(time()+"---------wsautfun------------param error")	
		
	else
		conout(time()+"---------wsautfun------------call lsautfun")
	
		aReturn := startjob("u_lsautfun",cRPCEnv,.T.,cRPCEnv,::cLogin,::cPassword)
		conout(time()+ "---------wsautfun------------call lsautfun-")
	endif
		
	if ((type("aReturn") == "A") .or. (type("aReturn") == "U" .and. valtype(aReturn) <> "U"))
		if (len(aReturn) > 0)
			aadd(::aDatfun,wsclassnew("Funcionario"))
			::aDatfun[len(::aDatfun)]:cCodfil := aReturn[len(aReturn),1]
			::aDatfun[len(::aDatfun)]:cMatfun := aReturn[len(aReturn),2]
			::aDatfun[len(::aDatfun)]:cNomfun := aReturn[len(aReturn),3]
			::aDatfun[len(::aDatfun)]:cMessag := aReturn[len(aReturn),4]
		else
			SetSoapFault("wsautweb","CPF e/ou Senha inválido(s)!")
			lWsret := .f.	
		endif
	else
		SetSoapFault("wsautfun",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsautfun------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsaltfun
Alteração de senha web do funcionário

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsaltfun wsreceive cHashkey,cLogin,cPassword,cNewpassword wssend lReturn wsservice wslaticinio

local lWsret  := .t.
local lLogin  := .f.
local cRPCEnv := GetEnvServer()

	conout(time()+"---------wsaltfun------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin) .or. empty(::cPassword) .or. empty(::cNewpassword)
		SetSoapFault("wsaltfun",defParamerror)
		lWsret := .f.
		conout(time()+"---------wsaltfun------------param error")	
		
	else
		conout(time()+"---------wsaltfun------------call lsaltfun")
	
		lLogin := startjob("u_lsaltfun",cRPCEnv,.T.,cRPCEnv,::cLogin,::cPassword,::cNewpassword)
		
	endif

	if ((type("lLogin") == "L") .or. (type("lLogin") == "U" .and. valtype(lLogin) <> "U"))
		::lReturn := lLogin
	else
		SetSoapFault("wsaltfun",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsaltfun------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsenvfun
Envio de senha por e-mail do funcionário

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsenvfun wsreceive cHashkey,cLogin wssend cReturn wsservice wslaticinio

local lWsret  := .t.
local cRetjob := ""
local cRPCEnv := GetEnvServer()

	conout(time()+"---------wsenvfun------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cLogin)
		SetSoapFault("wsenvfun",defParamerror)
		lWsret := .f.
		conout(time()+"---------wsenvfun------------param error")	
		
	else
		conout(time()+"---------wsenvfun------------call lsenvfun")
	
		cRetjob := startjob("u_lsenvfun",cRPCEnv,.T.,cRPCEnv,::cLogin)
		
	endif

	if ((type("cRetjob") == "C") .or. (type("cRetjob") == "U" .and. valtype(cRetjob) <> "U"))
		::cReturn := cRetjob
	else
		SetSoapFault("wsenvfun",defNotfound)
		lWsret := .f.	
	endif		
	
	conout(time()+"---------wsenvfun------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wspagfun
Recibos de pagamento do funcionário no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wspagfun wsreceive cHashkey,cFilfun,cMatfun,cMes,cAno wssend aDatpag wsservice wslaticinio

local lWsret   := .t.
local aReturn  := {}
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wspagfun------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cFilfun) .or. empty(::cMatfun) .or. empty(::cMes) .or. empty(::cAno)
		
		SetSoapFault("wspagfun",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wspagfun------------param error")	
		
	else
		conout(time()+"---------wspagfun------------call lspagfun")
	
		aReturn := startjob("u_lspagfun",cRPCEnv,.T.,cRPCEnv,::cFilfun,::cMatfun,::cMes,::cAno)
		
	endif
	
	if ((type("aReturn") == "A") .or. (type("aReturn") == "U" .and. valtype(aReturn) <> "U"))
		if (len(aReturn) > 0)
			for i := 1 to len(aReturn)
				aadd(::aDatpag,wsclassnew("Recibo"))
				::aDatpag[i]:cPerrec := aReturn[i,1]
				::aDatpag[i]:cMesrec := aReturn[i,2]
				::aDatpag[i]:cAnorec := aReturn[i,3]
				::aDatpag[i]:cCodrec := aReturn[i,4]
				::aDatpag[i]:cNomrec := aReturn[i,5]
			next
		else
			SetSoapFault("wspagfun",defNotfound)
			lWsret := .f.	
		endif
	else
		SetSoapFault("wspagfun",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wspagfun------------end")
	
return (lWsret)

/*---------------------------------------------------------------------------------------------------
{Protheus.doc} wsrecfun
Recibo de pagamento do funcionário (pdf)

@version 1.0
----------------------------------------------------------------------------------------------------*/
wsmethod wsrecfun wsreceive cHashkey,cFilfun,cMatfun,cPerrec,cTiprec wssend cRecibo wsservice wslaticinio

local lWsret   := .t.
local cReturn  := ""
local cRPCEnv  := GetEnvServer()

	conout(time()+"---------wsrecfun------------start")

	if (alltrim(decode64(::cHashkey)) <> defHashkey) .or. empty(::cFilfun) .or. empty(::cMatfun) .or. empty(::cPerrec) .or. empty(::cTiprec)
		SetSoapFault("wsrecfun",defParamerror)
		lWsret := .f.		
		conout(time()+"---------wsrecfun------------param error")	
		
	else
		conout(time()+"---------wsrecfun------------call lsdempag")
	
		cReturn := startjob("u_lsrecfun",cRPCEnv,.T.,cRPCEnv,::cFilfun,::cMatfun,::cPerrec,::cTiprec)
		
	endif
	
	if (type("cReturn") == "C") .or. (type("cReturn") == "U" .and. valtype(cReturn) <> "U")
		if !empty(cReturn)
			::cRecibo := cReturn
		else
			SetSoapFault("wsrecfun",defNotfound)
			lWsret := .f.	
		endif
	else
		SetSoapFault("wsrecfun",defNotfound)
		lWsret := .f.	
	endif
	
	conout(time()+"---------wsrecfun------------end")
	
return (lWsret)















/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsautfun
Autenticação web do funcionário

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsautfun(pRPCEnv,pLogin,pPassword)     

local aReturn := {}
local cMessage := ""
	
	conout(time()+"---------lsautfun------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)

	cQuery := Getnextalias()

	BeginSQL alias cQuery
		select sra.ra_filial, sra.ra_mat 
		from %table:sra% sra
		where sra.ra_cic = %exp:pLogin%
		and sra.ra_x_pweb = %exp:pPassword%
		and sra.ra_demissa = ' '
		and sra.ra_catfunc != 'A'
		and sra.%notdel%
	EndSQL
	
	conout(GetLastQuery()[2])
	
	if !(cQuery)->(eof())
		conout(time()+"---------lsautfun------------sql found")
		dbselectarea("SRA")
		SRA->(dbsetorder(1))
		SRA->(dbgotop())
		if SRA->(dbseek((cQuery)->ra_filial+(cQuery)->ra_mat),.t.)
			if reclock("SRA",.F.)
				SRA->RA_X_LWEB := dtoc(date())+"-"+time()
				SRA->(msunlock())
				conout(time()+"---------lsautfun------------change")
			endif				
			conout(time()+"---------lsautfun------------sra found")
			nTotal := mlcount(SRA->RA_X_HIST)		
			if nTotal>0
				for nLinha := 1 to nTotal
					cMessage += alltrim(memoline(SRA->RA_X_HIST,,nLinha)) + " "
				next nLinha			
			endif		
			aadd(aReturn,{alltrim(SRA->RA_FILIAL),alltrim(SRA->RA_MAT),alltrim(SRA->RA_NOME),alltrim(cMessage)})
		endif
	endif
	(cQuery)->(dbclosearea())	

	RpcClearEnv()
	
	conout(time()+"---------lsautfun------------end")


return (aReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsaltfun
Alteração de senha web do funcionário

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsaltfun(pRPCEnv,pLogin,pPassword,pNewpassword)     

local lReturn := .f.

	conout(time()+"---------lsaltfun------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)
	
	cQuery := Getnextalias()

	BeginSQL alias cQuery
		select sra.ra_filial, sra.ra_mat 
		from %table:sra% sra
		where sra.ra_cic = %exp:pLogin%
		and sra.ra_x_pweb = %exp:pPassword%
		and sra.ra_demissa = ' '
		and sra.ra_catfunc != 'A'
		and sra.%notdel%
	EndSQL
	
	conout(GetLastQuery()[2])
	
	if !(cQuery)->(eof())
		conout(time()+"---------lsaltfun------------sql found")
		dbselectarea("SRA")
		SRA->(dbsetorder(1))
		SRA->(dbgotop())
		if SRA->(dbseek((cQuery)->ra_filial+(cQuery)->ra_mat),.t.)
			if reclock("SRA",.F.)
				SRA->RA_X_PWEB := alltrim(pNewpassword)
				SRA->RA_X_LWEB := dtoc(date())+"-"+time()
				SRA->(msunlock())
				lReturn := .t.
				conout(time()+"---------lsaltfun------------change")
			endif				
		endif
	endif
	(cQuery)->(dbclosearea())		
	
		
	RpcClearEnv()
	
	conout(time()+"---------lsaltfun------------end")


return (lReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsenvfun
Envio de senha por e-mail do funcionário

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsenvfun(pRPCEnv,pLogin)     

local lReturn := .f.
local cReturn := ""
local cPassword := ""
	
	conout(time()+"---------lsenvfun------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)

	cQuery := Getnextalias()

	BeginSQL alias cQuery
		select sra.ra_filial, sra.ra_mat 
		from %table:sra% sra
		where sra.ra_cic = %exp:pLogin%		
		and sra.ra_demissa = ' '
		and sra.ra_catfunc != 'A'
		and sra.%notdel%
	EndSQL
	
	conout(GetLastQuery()[2])
	
	if !(cQuery)->(eof())
		conout(time()+"---------lsenvfun------------sql found")
		dbselectarea("SRA")
		SRA->(dbsetorder(1))
		SRA->(dbgotop())
		if SRA->(dbseek((cQuery)->ra_filial+(cQuery)->ra_mat),.t.)
			if !empty(SRA->RA_EMAIL) .and. !empty(SRA->RA_X_PWEB)
				if (SRA->RA_X_EWEB <= 2) //controle SPAM
					conout(time()+"---------lsenvfun------------lsendmail")								
					cBody := '<html>'
					cBody += 'Recebemos o pedido para envio de senha de acesso ao portal do funcionário.'
					cBody += '<br>'
					cBody += '<br>'
					cBody += 'CPF: '+alltrim(SRA->RA_CIC)
					cBody += '<br>'
					cBody += 'Senha: '+alltrim(SRA->RA_X_PWEB)
					cBody += '<br>'
					cBody += '<br>'
					cBody += 'Favor não responder, e-mail autom&aacute;tico.'		
					cBody += '</html>'				
					cSubject := 'Laticínio Silvestre - Envio de senha por e-mail'										
					lReturn := u_lsendmail(alltrim(SRA->RA_EMAIL),cSubject,cBody)				
					if lReturn
						if reclock("SRA",.f.)
							SRA->RA_X_EWEB := (SRA->RA_X_EWEB+1)
							SRA->(msunlock())
						endif
						cReturn := "E-mail enviado para: "+alltrim(SRA->RA_EMAIL)
					else                                                         
						cReturn := "Erro não fun&ccedil;&atilde;o de envio de e-mail. Entre em contato com o Latic&iacute;nio."
					endif                                                         								
				else
					cReturn := "E-mail com a senha de acesso j&aacute; enviado para: "+alltrim(SRA->RA_EMAIL)
				endif
			else
				cReturn := "E-mail e/ou senha não cadastrado! Entre em contato com o Latic&iacute;nio."
			endif			
		else
			cReturn := "CPF não localizado ou cadastro não ativo!"
		endif
	else
		cReturn := "CPF não localizado ou cadastro não ativo!"
	endif
	(cQuery)->(dbclosearea())	
	
	RpcClearEnv()
	
	conout(time()+"---------lsenvpwd------------end")


return (cReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lspagfun
Recibos de pagamento do funcionário no período

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lspagfun(pRPCEnv,pFilfun,pMatfun,pMes,pAno)     

local cRoteiro := ""
local cPeriodo := strzero(val(pAno),4)+strzero(val(pMes),2)
local aReturn := {}
local cMes := ""
local cAno := ""
	
	conout(time()+"---------lspagfun------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,defCodfil,,,"02",pRPCEnv)

	if cPeriodo == (strzero(Year(date()),4)+strzero(Month(date()),2))
		dUtil := lastday(ctod("01/"+strzero(Month(date()),2)+"/"+strzero(Year(date()),4)),1)
		for nUtil := 1 to 5
			dUtil := datavalida(dUtil,.T.)
			dUtil += 1
		next
		if date() < dUtil
			cPeriodo := "999999"
		endif
	endif
	
	cQuery := Getnextalias()

	BeginSQL alias cQuery
		select distinct rd_roteir roteiro, rd_periodo periodo from %table:srd% srd
		where srd.rd_filial = %exp:pFilfun%
		and srd.rd_mat = %exp:pMatfun%
		and srd.rd_periodo = %exp:cPeriodo%
		and srd.%notdel%
		union all
		select distinct rc_roteir roteiro, rc_periodo periodo from %table:src% src
		where src.rc_filial = %exp:pFilfun%
		and src.rc_mat = %exp:pMatfun%
		and src.rc_periodo = %exp:cPeriodo%
		and src.%notdel%		
		order by periodo desc, roteiro
	EndSQL
	
	conout(GetLastQuery()[2])
	
	while !(cQuery)->(eof())
		cRoteiro := ""
		do case 
			case (cQuery)->roteiro == "FOL"
				cRoteiro := "Folha de pagamento"
			case (cQuery)->roteiro == "ADI"
				cRoteiro := "Adiantammento de sal&aacute;rio"
			case (cQuery)->roteiro == "131"
				cRoteiro := "Primeira parcela 13 sal&aacute;rio"
			case (cQuery)->roteiro == "132"
				cRoteiro := "Segunda parcela 13 sal&aacute;rio"
		endcase
		cMes := MesExtenso(val(substr((cQuery)->periodo,5,2)))
		cAno := substr((cQuery)->periodo,1,4)
		aadd(aReturn,{(cQuery)->periodo,cMes,cAno,(cQuery)->roteiro,cRoteiro})
		conout(time()+"---------lspagfun------------periodo "+(cQuery)->periodo)
		(cQuery)->(dbskip())
	end
	(cQuery)->(dbclosearea())
		
		
	RpcClearEnv()
	
	conout(time()+"---------lspagfun------------end")


return (aReturn)


/*---------------------------------------------------------------------------------------------------
{Protheus.doc} lsrecfun
Recibo de pagamento do funcionário (pdf)

@version 1.0
----------------------------------------------------------------------------------------------------*/
user function lsrecfun(pRPCEnv,pFilfun,pMatfun,pPerrec,pTiprec)     

local lReturn	:= .f.
local cReturn	:= ""
local cWeek     := "01"
local cProcess  := "00001"
local nAttmax	:= 10
local nAttempt	:= 0

	conout(time()+"---------lsrecfun------------start")
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(defCodemp,pFilfun,,,"02",pRPCEnv)
		
	while (nAttempt<nAttmax)
                                             
		nAttempt++
		conout(time()+"---------lsrecfun------------attempt "+cvaltochar(nAttempt))
		
		public cPathrec := "\spool\pdf\"		
		public cFilerec := "recpag"+cvaltochar(ThreadID())+dtos(date())+strtran(time(),":","")
		public oPrinter := nil
		public oSetup := Nil		
		
		//oSetup:=FWPrintSetup():New(PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN, "RECPAG")
		//oSetup:SetPropert(PD_PRINTTYPE , 6)
		//oSetup:SetPropert(PD_ORIENTATION , 1)
		//oSetup:SetPropert(PD_DESTINATION , 1)
		//oSetup:SetPropert(PD_MARGIN , {60,60,60,60})
		//oSetup:SetPropert(PD_PAPERSIZE , 2)
		//oSetup:aOptions[PD_VALUETYPE] := cPathrec
		oPrinter := FWMSPrinter():New(cFilerec, IMP_PDF, .F. ,cPathrec, .T., , , , , .F., ,.F. , )
		
		U_Recpaglat(.T.,pFilfun, pMatfun, cProcess, pTiprec, pPerrec, cWeek)
		sleep(3000)
			
		cFile := cPathrec+cFilerec+".pdf"
		aFile := directory(cFile)
		
		if len(aFile) > 0
			if (noround((aFile[Len(aFile),2])/1024,0) > 1)
				lReturn := .t. 
				exit
			endIf
		endIf		
		sleep(2000)
	end	
	
	if lReturn
		nHdlFile := fOpen(cFile,68)
		nTamFile := fSeek(nHdlFile,0,2)
		fSeek(nHdlFile,0,0)
		cBuffer  := Space(nTamFile)
		nBtLidos := fRead(nHdlFile,@cBuffer,nTamFile)	
		fClose(nHdlFile)
		cReturn := encode64(cBuffer)
		if defDelpdf
			ferase(cFile)
		endif
		conout(time()+"---------lsrecfun------------cFile "+cFile)		
	endif
	
		
	RpcClearEnv()
	
	conout(time()+"---------lsrecfun------------end")

return (cReturn)
