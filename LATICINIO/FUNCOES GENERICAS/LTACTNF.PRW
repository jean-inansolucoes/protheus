#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?LTREL011 ?Autor  ?Rafael Parma         ? Data ?  22/10/2009 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Rotina de impress?o de pagamentos de produtores.            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?TOTVS LATICINIO                                             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
  
*-----------------------*
User Function LTACTNF()
*-----------------------* 
Local dEmissao  := ctod("31/01/2010") 
Local cAliasTMP := "SF1T"                                  
Local nREC      := 0

	dbSelectArea("SF1")
	SET FILTER TO SF1->F1_EMISSAO == dEmissao
	
	dbSelectArea("SF1")
	dbGoTop()
	While !EOF()         
		nREC += 1
		cQuery := " SELECT ZL1_COD FROM "+RetSQLName("ZL1")+" WHERE ZL1_PRODUT = '"+SF1->F1_FORNECE+"' AND ZL1_LOJPRD = '"+SF1->F1_LOJA+"' AND D_E_L_E_T_ <> '*' "
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		If ALLTRIM((cAliasTMP)->ZL1_COD) != ""
			RecLock("SF1", .F.)
			SF1->F1_X_LINHA := (cAliasTMP)->ZL1_COD
			SF1->(MsUnLock())			
		EndIf
		(cAliasTMP)->(dbCloseArea())
		dbSelectArea("SF1")
		dbSkip()
	Enddo
	
	Alert("Processo finalizado! "+STR(nREC))
	
Return
	
