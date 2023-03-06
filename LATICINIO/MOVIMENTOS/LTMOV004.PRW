#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV004    บAutor  ณRafael Parma      บ Data ณ  22/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Entrada de dados, conta corrente do integrado.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------*
User Function LTMOV004(xRotAuto, nOpc)
*-----------------------*

Public cAliasH		:= "ZLB"
Private lInclui		:= .F.
Private cCadastro	:= "Conta Corrente"
Private aCores		:= {}
Private l004Auto	:= xRotAuto <> NIL
Private aRotAuto	:= Nil
Private aRotina		:= {{'Pesquisar' 		,'AxPesqui'  ,0 ,1, 0, .F.},;
						{'Visualizar'		,'AxVisual'  ,0 ,2, 0, nil},;
						{'Incluir'   		,'U_LTMOV04C',0 ,3, 0, nil},;
						{'Alterar'   		,'U_LTMOV04A',0 ,4, 0, nil},;
						{'Excluir'   		,'U_LTMOV04D',0 ,5, 0, nil},;
						{'Imprimir'  		,'U_LTMOV04I',0 ,6, 0, nil},;
						{'Icluir Lote' 		,'U_LTMOV04T',0 ,7, 0, nil},;
						{'Excluir Lote' 	,'U_LTMOV04E',0 ,7, 0, nil},;
						{'Imprimir Lote' 	,'U_LTMOV04L',0 ,7, 0, nil} }
						
dBSelectArea(cAliasH)
(cAliasH)->(dBSetOrder(1))
(cAliasH)->(dBGotop())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Endereca a funcao de BROWSE                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If l004Auto
	aRotAuto := xRotAuto
	MBrowseAuto(nOpc, aRotAuto, cAliasH)
Else
	AADD(aCores, {'ZLB_STATUS == " " ', 'BR_VERDE'   })
	AADD(aCores, {'ZLB_STATUS != " " ', 'BR_VERMELHO'})
	
	mBrowse( ,,,,cAliasH,,,,,, aCores)
EndIf

If Select(cAliasH) > 0
	(cAliasH)->(dbCloseArea())
EndIf
	
Return           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04C    บAutor  ณRafael Parma      บ Data ณ  22/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusใo de dados, conta corrente do integrado.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
User Function LTMOV04C(cAlias,nReg,nOpc) 
*---------------------------------------* 
Private aDADOSCC := {}

l004Auto := If(Type('l004Auto') <> 'L',.f.,l004Auto)

If l004Auto
	AxInclui(cAlias,nReg,nOpc,/*aAcho*/,/*cFunc*/,/*aCpos*/,"U_LTMOV4TK()",/*lF3*/,/*cTransact*/,/*aButtons*/,/*aParam*/,aRotAuto,/*lVirtual*/, /*lMaximized*/)
Else
	lInclui   := .T.
	AxInclui(cAlias,nReg,nOpc,/*aAcho*/,/*cFunc*/,/*aCpos*/,"U_LTMOV4TK()")
	lInclui   := .F.

	If ZLB->ZLB_DESDOB == "S"
		If Len(aDADOSCC) > 0
			MsAguarde( {|| fUpdZLB(aDADOSCC) },"Incluindo registros desdobramento...") 
		EndIf
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04M    บAutor  ณRafael Parma      บ Data ณ  22/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Janela de desdobramento de registros.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------*
User Function LTMOV04M()
*---------------------------*

Local lRet      := .F.
Local nOpcDsd   := 0
Local nParceDsd := 0
Local nPerioDsd := 0
Local nTOTALPAR := 0   
Local nMaxParc  := SuperGetMV("MV_ZLMPCC",,99) 	//N๚mero maximo parcelas.
Local cCondPgto := Space(3)
Local cHistDsd  := Space(TAMSX3("ZLB_HIST")[1])
Local cValorDsd := "T"
Local nPAR
/*Local aParcelas := {}
Local aParcacre := {}
Local aParcdecre:= {}*/
Local oDlg
Local oVlDsd

	If M->ZLB_VALOR > 0 .and. !Empty(M->ZLB_DTMOV)

		DEFINE MSDIALOG oDlg FROM	0,0 TO 235,280 TITLE "Desdobramento" PIXEL
	
		@ 004, 007 TO 105, 105 OF oDlg PIXEL
	
		@ 010, 014 SAY "Condi็ใo de Pagamento" 					SIZE 90, 7 OF oDlg PIXEL
		@ 028, 014 SAY "Numero de Parcelas" 					SIZE 90, 7 OF oDlg PIXEL
		@ 046, 014 SAY "Valor do Titulo (Total ou Parcela)"  	SIZE 90, 7 OF oDlg PIXEL
		@ 064, 014 SAY "Periodo de Vencto. (em dias)"  			SIZE 90, 7 OF oDlg PIXEL
		@ 082, 014 SAY "Historico" 								SIZE 90, 7 OF oDlg PIXEL
	
		@ 018, 014 MSGET cCondPgto	F3 "SE4" Picture "!!!" SIZE 72, 08 OF oDlg PIXEL ;
														Valid (Empty (cCondPgto) .or. ExistCpo("SE4",cCondPgto)) .and. ;
														Fa290Cond(cCondPgto)
		@ 036, 014 MSGET  nParceDsd 		  	Picture "999" When IIf(Empty(cCondPgto),.T.,.F.);
		Valid f040ValPar(nParceDsd,nMaxParc) ;
		SIZE 80, 08 OF oDlg PIXEL
		@ 054, 014 COMBOBOX oVlDsd VAR cValorDsd ITEMS {"TOTAL","PARCELA"} SIZE 80, 47 OF oDlg PIXEL ; 
		When IIf(Empty(cCondPgto),.T.,.F.)
		@ 072, 014 MSGET nPerioDsd				Picture "999" When IIf(Empty(cCondPgto),.T.,.F.) ;
		Valid nPerioDsd > 0;
		SIZE 80, 08 OF oDlg PIXEL
		@ 090, 014 MSGET  cHistDsd			 	Picture "@S40";
		SIZE 80, 08 OF oDlg PIXEL
	
		DEFINE SBUTTON FROM 07, 110 TYPE 1 ACTION ;
		{||nOpcDsd:=1,IF(LTMV04TudoOk(cCondPgto,nParceDsd,cValorDsd,nPerioDsd,nMaxParc),oDlg:End(),nOpcDsd:=0)} ENABLE OF oDlg
		DEFINE SBUTTON FROM 23, 110 TYPE 2 ACTION {||nOpcDsd:=9 ,oDlg:End()} ENABLE OF oDlg
	
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpcDsd == 1
			lRet := .T.
			
			If !Empty(cCondPgto)
				If cValorDsd == "TOTAL"
					nVALOR := M->ZLB_VALOR
				Else
					nVALOR := M->ZLB_VALOR * nParceDsd
				EndIf
				
				aPARCELA := Condicao(nVALOR,cCondPgto,,IIF(!Empty(M->ZLB_DTMOV),M->ZLB_DTMOV,ddatabase))
				If Len(aPARCELA) > 0
					For nPAR := 1 to Len(aPARCELA)
						aAdd ( aDADOSCC, { aPARCELA[nPAR,01], aPARCELA[nPAR,02], cHistDsd } )
					Next nPAR
			 	EndIf
			 
			Else
	
				If cValorDsd == "TOTAL"
					nVALOR := Round(M->ZLB_VALOR / nParceDsd, 2)
				Else
					nVALOR := M->ZLB_VALOR
				EndIf
				
				dDATAREF := IIF(Empty(M->ZLB_DTMOV),M->ZLB_DTMOV,ddatabase)           
				
				For nPAR := 1 to nParceDsd
						If nPAR > 1 
							dDATAREF += nPerioDsd
						EndIf
						nTOTALPAR += nVALOR
						
						//--Acerto de arredontamento
						If nPAR == nParceDsd .and. nTOTALPAR < M->ZLB_VALOR
							nVALOR := nVALOR + ( M->ZLB_VALOR - nTOTALPAR )
						EndIf
						
						aAdd ( aDADOSCC, { dDATAREF, nVALOR, cHistDsd } )
				Next nPAR
			 	
			EndIf		 
			 
		EndIf
	
	Else                 
	
		Aviso("Aten็ใo", "Os campos obrigat๓rios devem ser preenchidos.", {"OK"}, 2)
	
	EndIf
		
Return (lRet)

  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04D    บAutor  ณRafael Parma      บ Data ณ  22/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera็ใo de dados, conta corrente do integrado.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LTMOV04A(cAlias,nReg,nOpc)  

	If !Empty(ZLB->ZLB_STATUS)
		Alert("Este movimento jแ foi integrado com o financeiro e nใo pode ser alterado.")
		Return
	Else
		AxAltera(cAlias,nReg,nOpc)
	EndIf 
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04D    บAutor  ณRafael Parma      บ Data ณ  22/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclusใo de dados, conta corrente do integrado.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LTMOV04D()

Private cTitulo := "Conta Corrente"

	If ! Empty ( (cAliasH)->ZLB_STATUS )
		U_LTALL001(cTitulo, "Documento jแ baixado.", "Impossํvel excluํ-lo!")
	Else
		If ApMsgNoYes("Confirme a exclusใo do movimento?", "Aten็ใo")
			Begin Transaction
				RecLock(cAliasH, .F., .T.)
				(cAliasH)->(dbDelete())
				(cAliasH)->(MsUnLock())
			End Transaction	
		EndIf		
	EndIf  
	
Return        
                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04I    บAutor  ณRafael Parma      บ Data ณ  05/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de recibo de adiantamento do conta corrente de   บฑฑ
ฑฑบ          ณ produtores/transportadores.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LTMOV04I()   
         
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "RECIBO DE ADIANTAMENTO"
Private cPict          := ""
Private titulo         := "RECIBO DE ADIANTAMENTO"
Private nLin           := 80
Private Cabec1         := ""
Private Cabec2         := "" 
Private imprime        := .T.
Private aOrd           := {}
         
Private cPerg        := "LTMOV0004I"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LTMOV04I"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
//Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LTMOV04I"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Validacoes...                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If ZLB->ZLB_TIPCD != "D"
		Alert("Apenas recibos de d้bitos podem ser impressos.")
		Return
	EndIf


	If ZLB->ZLB_QTDIMP != 0
		If ! ApMsgNoYes("Este recibo jแ foi impresso, deseja reimprimir?", titulo)
			Return
		EndIf
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cString := "ZLB"  
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,.F.,.F.,Tamanho,,.F.)


	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RptStatus({|| fPrintRec(Cabec1,Cabec2,Titulo,@nLin,.T.) },Titulo)
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SET DEVICE TO SCREEN
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()	


Return
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04L    บAutor  ณRafael Parma      บ Data ณ  05/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de recibo de adiantamento do conta corrente de   บฑฑ
ฑฑบ          ณ produtores/transportadores.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LTMOV04L()   
         
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "RECIBO"
Private cPict          := ""
Private titulo         := "RECIBO"
Private nLin           := 80
Private Cabec1         := ""
Private Cabec2         := "" 
Private imprime        := .T.
Private aOrd           := {"Data Movimento","Produtor/Transportador"}          
Private cPerg        := "LTMOV0004L"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LTMOV04L"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
//Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private nOrdem       := 1
Private wnrel        := "LTMOV04L"
Private cString      := "ZLB"  	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AjustaSX1()
	Pergunte(cPerg,.F.)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)


	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	nOrdem := aReturn[8]	

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	RptStatus({|| fPrintLOT(Cabec1,Cabec2,Titulo,@nLin) },Titulo)
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SET DEVICE TO SCREEN
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()	


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPrintRec   บAutor  ณRafael Parma      บ Data ณ  05/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de recibo de adiantamento do conta corrente de   บฑฑ
ฑฑบ          ณ produtores/transportadores.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPrintLOT(Cabec1,Cabec2,Titulo,nLin)

Local cAliasTMP := GetNextAlias()
Local hEnter	:= CHR(10) + CHR(13) 
//Local nTOTORDEM := 0
//Local nTOTGERAL := 0

	cQuery := "SELECT 														" + hEnter
	cQuery += "         ZLB.R_E_C_N_O_ NUMREC								" + hEnter
	cQuery += "FROM " + RetSqlName("ZLB") + " ZLB							" + hEnter
	cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2	ON					" + hEnter		
	cQuery += "			ZLB.ZLB_FORNEC = SA2.A2_COD						 	" + hEnter
	cQuery += "AND  	ZLB.ZLB_LOJFOR = SA2.A2_LOJA					 	" + hEnter	
	
	cQuery += "WHERE    ZLB.ZLB_FILIAL  = '" + xFilial("ZLB") + "' 			" + hEnter
	
	cQuery += "AND		ZLB.ZLB_DTMOV  BETWEEN '" + dtos(mv_par01) + "' 	" + hEnter
	cQuery += "AND             		           '" + dtos(mv_par02) + "' 	" + hEnter	
	cQuery += "AND		ZLB.ZLB_DTVCTO BETWEEN '" + dtos(mv_par03) + "' 	" + hEnter
	cQuery += "AND             		           '" + dtos(mv_par04) + "' 	" + hEnter	

	cQuery += "AND		ZLB.ZLB_FORNEC BETWEEN '" + mv_par05 + "' 			" + hEnter
	cQuery += "AND             		           '" + mv_par06 + "' 			" + hEnter	

	cQuery += "AND		ZLB.ZLB_LOJFOR BETWEEN '" + mv_par07 + "' 			" + hEnter
	cQuery += "AND             		           '" + mv_par08 + "' 			" + hEnter	

	cQuery += "AND		SA2.A2_X_LINHA BETWEEN '" + mv_par09 + "' 			" + hEnter
	cQuery += "AND             		           '" + mv_par10 + "' 			" + hEnter	
	If mv_par11 == 1  //-- cr้bito
		cQuery += "AND	ZLB.ZLB_TIPCD = 'C'									" + hEnter  	
	Else  //-- d้bito						
		cQuery += "AND	ZLB.ZLB_TIPCD = 'D'									" + hEnter  	
	EndIf
	cQuery += "AND 		ZLB.D_E_L_E_T_    != '*' 							" + hEnter
	cQuery += "AND 		SA2.D_E_L_E_T_    != '*' 							" + hEnter
 	
 	cQuery += "ORDER BY                 			 						" + hEnter		
	If nOrdem == 1
		cQuery += "         ZLB.ZLB_FORNEC, 								" + hEnter
		cQuery += "         ZLB.ZLB_LOJFOR 									" + hEnter	
    Else
		cQuery += "			ZLB.ZLB_DTMOV  									" + hEnter     	    	
    EndIf
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
    nCOUNT := 0
    lCabec := .T.
    While !(cAliasTMP)->(EOF())
		dbSelectArea("ZLB")
		ZLB->(dbGoTo((cAliasTMP)->NUMREC))
		
		If mv_par12 == 2	//Salta Pแgina/Recibo==Nใo
			nCOUNT += 1
			If nCOUNT % 2 == 0                  
				lCabec := .F.
				nLin += 8
			Else
				lCabec := .T.
			EndIf
		EndIf 
	
		fPrintRec(Cabec1,Cabec2,Titulo,@nLin,lCabec)
		
		(cAliasTMP)->(dbSkip())
	Enddo
	
	(cAliasTMP)->(dbCloseArea())

	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPrintRec   บAutor  ณRafael Parma      บ Data ณ  05/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de recibo de adiantamento do conta corrente de   บฑฑ
ฑฑบ          ณ produtores/transportadores.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPrintRec(Cabec1,Cabec2,Titulo,nLin,lCabec)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressใo do relat๓rio..                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("SA2") + SubSTR(ZLB->ZLB_FORNEC,1,TAMSX3("A2_COD")[1]) + ZLB->ZLB_LOJFOR )
	    
	    If lCabec
		    cabec1 := "RECIBO NUMERO: " + ZLB->ZLB_COD +"/"+ ZLB->ZLB_PARCEL + " - ADIANTAMENTO AO PRODUTOR / CARRETEIRO" 
			dbSelectArea("ZLB")
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Else        
			@nLin,000 PSAY __PrtThinLine() 	
	    	nLin += 2
			cabec1 := "RECIBO NUMERO: " + ZLB->ZLB_COD +"/"+ ZLB->ZLB_PARCEL + " - ADIANTAMENTO AO PRODUTOR / CARRETEIRO" 
			@nLin,000 PSAY cabec1
			nLin += 2
			@nLin,000 PSAY __PrtThinLine() 	
			nLin += 2
		EndIf	  	                                 
		
		nVALORMOV := ZLB->ZLB_VALOR + ( ( ZLB->ZLB_VALOR * ZLB->ZLB_JUROS ) / 100 )
	  	
		@nLin,005 PSAY ALLTRIM(SM0->M0_NOMECOM)
		@nLin,055 PSAY "R$ "+TRANSFORM(nVALORMOV,"@E 999,999,999.99")
		nLin += 2 
		@nLin,000 PSAY "AUTORIZO A EMPRESA "+ALLTRIM(SM0->M0_NOMECOM)+" A DESCONTAR"
		nLin += 1
		@nLin,000 PSAY "DO PRODUTOR/TRANSP.: " + SA2->A2_NOME + " CODIGO: "+ZLB->ZLB_FORNEC
		nLin += 1                        
		If !EMPTY(SA2->A2_X_LINHA)
			@nLin,000 PSAY "LINHA: " + SA2->A2_X_LINHA + "/" + SA2->A2_X_NOMLI
			nLin += 1                        
		EndIf
		@nLin,000 PSAY "O VALOR DE: ("+UPPER(EXTENSO(nVALORMOV))+")"
		nLin += 1	
		@nLin,000 PSAY "COM VENCIMENTO EM: "+cValToChar(ZLB->ZLB_DTVCTO)
		nLin += 1	
		@nLin,000 PSAY "MOTIVO: " + ZLB->ZLB_TPDESP + IIF(EMPTY(ZLB->ZLB_HIST)," "," - "+ZLB->ZLB_HIST)
		nLin += 2	
		@nLin,000 PSAY ALLTRIM(SM0->M0_CIDCOB)+", "+DTOC(ZLB->ZLB_DTMOV)+"   ASSINATURA: _________________________________"
		nLin += 3              
		@nLin,000 PSAY __PrtThinLine() 	
    	nLin += 3
    	
    EndIf  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza็ใo do contador de impressใo..                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    RecLock("ZLB",.F.)
    ZLB->ZLB_QTDIMP += 1
    ZLB->(MsUnLock())        

	
Return



/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณF040Valpar  ณ Autor ณ Mauricio Pequim Jr  ณ Data ณ 16/07/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Faz verificacao do numero de parcelas do desdobramento.    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ F040ValPar()                                        	      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ FINA040													  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                                                                       

Static Function F040VALPAR(nParceDsd,nMaxParc)

If nParceDsd > nMaxParc .or. nParceDsd < 2
	Help(" " , 1 , "FA050PCDSD")
	Return .F.
Endif
Return .T.


/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณA040TudoOKณ Autor ณ Mauricio Pequim Jr.   ณ Data ณ 16/07/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se dados para desdobramento estao corretos.		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ A040TudoOk()												  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ FINA040													  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LTMV04TudoOk(cCondPgto,nParceDsd,cValorDsd,nPerioDsd,nMaxParc)


If Empty (cCondPgto)
	If nParceDsd < 2 .or. nParceDsd > nMaxParc .or. Empty(cValorDsd) .or. nPerioDsd <= 0
		Help(" " , 1 , "FA050DADOS")
		Return .F.
	Endif
Endif                    

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfUpdZLB     บAutor  ณRafael Parma      บ Data ณ  01/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusใo de registros, desdobramento.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fUpdZLB(aDADOSCC)

Local aAreaTMP  := GetArea()
Local cAliasZLB := "ZLB"
Local aDADOSZLB := {}
Local nIND, nCPO
	dBSelectArea("SX3")
	SX3->( dBSetOrder( 1 ) )
	SX3->( dBGoTop( ) )
	SX3->( dBSeek( cAliasZLB ) )
	
	While !SX3->(EOF()) .And. SX3->X3_ARQUIVO == cAliasZLB
		AADD( aDADOSZLB, { SX3->X3_CAMPO, (cAliasZLB)->&(SX3->X3_CAMPO) } )
		SX3->(dbSkip())
	Enddo  
	
	If RecLock(cAliasZLB,.F.)        
		(cAliasZLB)->(dbDelete())
		(cAliasZLB)->(MsUnLock())
	EndIf
	
	For nIND := 1 to Len(aDADOSCC)
		If RecLock(cAliasZLB,.T.)
			For nCPO := 1 to Len(aDADOSZLB)
				If ! ALLTRIM(aDADOSZLB[nCPO,01]) $ "ZLB_DTVCTO/ZLB_VALOR/ZLB_PARCEL/ZLB_HIST/ZLB_DESDOB"
					(cAliasZLB)->&(aDADOSZLB[nCPO,01]) := aDADOSZLB[nCPO,02]
				ElseIf ALLTRIM(aDADOSZLB[nCPO,01]) == "ZLB_DTVCTO"
					(cAliasZLB)->&(aDADOSZLB[nCPO,01]) := aDADOSCC[nIND,01]
				ElseIf ALLTRIM(aDADOSZLB[nCPO,01]) == "ZLB_VALOR"
					(cAliasZLB)->&(aDADOSZLB[nCPO,01]) := aDADOSCC[nIND,02]					
				ElseIf ALLTRIM(aDADOSZLB[nCPO,01]) == "ZLB_HIST"
					(cAliasZLB)->&(aDADOSZLB[nCPO,01]) := aDADOSCC[nIND,03]
				ElseIf ALLTRIM(aDADOSZLB[nCPO,01]) == "ZLB_PARCEL"
					(cAliasZLB)->&(aDADOSZLB[nCPO,01]) := StrZERO(nIND,TAMSX3("ZLB_PARCEL")[1])
				ElseIf ALLTRIM(aDADOSZLB[nCPO,01]) == "ZLB_DESDOB"
					(cAliasZLB)->&(aDADOSZLB[nCPO,01]) := "N"
				EndIf
			Next nCPO			
			(cAliasZLB)->(MsUnLock())
		EndIf	
	Next nIND
 
 	RestArea(aAreaTMP)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV4VD    บAutor  ณRafael Parma     บ Data ณ  27/05/11    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da MsGetDados.                                     ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*------------------------------*
User Function LTMOV4VD()        
*------------------------------*                       
Local lRet := .T.
	//--Validacao do perํodo
	dDATA := IIf(Type("M->ZLB_DTMOV")!="U",M->ZLB_DTMOV,ZLB->ZLB_DTMOV)
	dbSelectArea("ZLC")
	dbSetOrder(1)
	If dbSeek( xFilial("ZLC")+(cValToChar(Year(dDATA))+STRZero(Month(dDATA),2)+"01") )
		If ZLC->ZLC_STATUS == "F"
			U_LTALL001("MOVIMENTO CONTA CORRENTE", "O perํodo deste movimento esta fechado.","Verifique o cadastro de perํodos.")
			lRet := .F.
		EndIf
	Else
		U_LTALL001("MOVIMENTO CONTA CORRENTE", "Nใo existe perํodo de movimento para lan็amento.","Verifique o cadastro de perํodos.")
		lRet := .F.
	EndIf		

Return (lRet)    



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04T    บAutor  ณRafael Parma      บ Data ณ  24/02/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusใo de registros em lote.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     
*-------------------------*
User Function LTMOV04T()
*-------------------------*
Private cPergT  := "LTMOV0004T"
Private nRegInc := 0

	//--Validacao do perํodo
	dbSelectArea("ZLC")
	dbSetOrder(1)
	If dbSeek( xFilial("ZLC")+(cValToChar(Year(ddatabase))+STRZero(Month(ddatabase),2)+"01") )
		If ZLC->ZLC_STATUS == "F"
			U_LTALL001("Inclusใo Lote", "O perํodo de movimento esta fechado nesta database.","Verifique o cadastro de perํodos.")
			Return
		EndIf
	Else
		U_LTALL001("Inclusใo Lote", "Nใo existe perํodo de movimento para lan็amento nesta database.","Verifique o cadastro de perํodos.")
		Return
	EndIf		


	//--Exibe janela de parโmetros..
	AjustSX1T()
	If Pergunte(cPergT,.T.)

		//--Valida็ใo dos parโmetros..
		If Empty(mv_par09)
			Alert("Parโmetro 09 - Motivo do movimento invแlido!")
			Return
		EndIf
		
		If mv_par10 <= 0
			Alert("Parโmetro 10 - Valor invแlido!")
			Return
		EndIf

    	//--Chamada da fun็ใo para inclusใo de registros..
    	MsAguarde({ || fIncZLB() }, "Processando registros...")
    	
    	
    	If nRegInc == 0
	    	Aviso("Aviso","Nใo foram localizados registros para gerar os movimentos, verifique os parโmetros.",{"OK"})
    	Else                                                                                            
    		Aviso("Aviso","Foram gerados: "+cValToChar(nRegInc)+" movimentos no conta corrente.",{"OK"})
    	EndIf
		
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIncZLB     บAutor  ณRafael Parma      บ Data ณ  24/02/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusใo de registros em lote.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     
	
*--------------------------------*
Static Function fIncZLB()
*--------------------------------*
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10)+CHR(13) 
Local cMV_ZLTCPG := SuperGetMV("MV_ZLTCPG",,"")	// c๓digo da condi็ใo de pagamento
        

	cQuery := "	SELECT 	ZL1.ZL1_PRODUT,               						" + hEnter
	cQuery += "         ZL1.ZL1_LOJPRD,				 						" + hEnter
	cQuery += "         ZL1.ZL1_NOMPRD,				 						" + hEnter
	cQuery += "         ZL1.ZL1_COD,   				 						" + hEnter	
	cQuery += "         SA2.A2_COND   				 						" + hEnter
	cQuery += "	FROM " + RetSqlName("ZL1") + " ZL1							" + hEnter 
	cQuery += "	INNER JOIN " + RetSqlName("SA2") + " SA2   					" + hEnter
	cQuery += "	ON       ZL1.ZL1_PRODUT    = SA2.A2_COD					 	" + hEnter
	cQuery += "	AND      ZL1.ZL1_LOJPRD    = SA2.A2_LOJA				 	" + hEnter	
	cQuery += "	WHERE    ZL1.ZL1_FILIAL    = '" + xFilial("ZL1") + "' 		" + hEnter
	cQuery += "	AND      ZL1.ZL1_COD    BETWEEN '" + mv_par01 + "'  		" + hEnter
	cQuery += "	AND      						'" + mv_par02 + "' 			" + hEnter
	cQuery += "	AND      ZL1.ZL1_PRODUT BETWEEN '" + mv_par03 + "'	 		" + hEnter
	cQuery += "	AND      						'" + mv_par04 + "'	 		" + hEnter
	cQuery += "	AND      ZL1.ZL1_LOJPRD BETWEEN '" + mv_par05 + "'	 		" + hEnter
	cQuery += "	AND      						'" + mv_par06 + "'	 		" + hEnter
	If mv_par07 == 1	//--Cheque
		cQuery += "	AND     SA2.A2_X_FPGTO      = 'C' 			 			" + hEnter
	ElseIf mv_par07 == 2	//--Dep๓sito
		cQuery += "	AND     SA2.A2_X_FPGTO      = 'D' 			 			" + hEnter		
	EndIf
	cQuery += "	AND 	 ZL1.D_E_L_E_T_   != '*' 							" + hEnter
	cQuery += "	AND 	 SA2.D_E_L_E_T_   != '*' 							" + hEnter	                        
	cQuery += "	ORDER BY 				               						" + hEnter
	cQuery += "         ZL1.ZL1_COD,   				 						" + hEnter	
	cQuery += "         ZL1.ZL1_PRODUT,   				 					" + hEnter	
	cQuery += "         ZL1.ZL1_LOJPRD				 						" + hEnter
		
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	


	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
    While !(cAliasTMP)->(EOF())              
    
		//--Define c๓digo do movimento
		CCODMOV := GETSXENUM("ZLB","ZLB_COD")			
    	While .T.
			dbSelectArea("ZLB")
	    	dbSetOrder(1)
    		If dbSeek( xFilial("ZLB")+CCODMOV )          
    			ConfirmSX8()
    			CCODMOV := GETSXENUM("ZLB","ZLB_COD")			
    		Else
    			Exit
    		EndIf
    	Enddo    
    	
		//--Define vencimento do movimento
		dVencto := ddatabase
		If !Empty((cAliasTMP)->A2_COND)
			aPARCELA := Condicao(mv_par10, (cAliasTMP)->A2_COND, 0)
			If Len(aPARCELA) > 0
				If aPARCELA[01][01] >= ddatabase
					dVencto := aPARCELA[01][01]
				EndIf
			EndIf
		Else
			aPARCELA := Condicao(mv_par10, cMV_ZLTCPG, 0)
			If Len(aPARCELA) > 0
				If aPARCELA[01][01] >= ddatabase
					dVencto := aPARCELA[01][01]
				EndIf
			EndIf
		EndIf

		//--Inclusใo do movimento
    	If RecLock("ZLB",.T.)
    		ZLB->ZLB_FILIAL	:= xFilial("ZLB")
    		ZLB->ZLB_COD	:= CCODMOV
    		ZLB->ZLB_PARCEL	:= STRZero(1,TAMSX3("ZLB_PARCEL")[1])
    		ZLB->ZLB_FORNEC	:= (cAliasTMP)->ZL1_PRODUT
    		ZLB->ZLB_LOJFOR	:= (cAliasTMP)->ZL1_LOJPRD
    		ZLB->ZLB_NOMFOR	:= (cAliasTMP)->ZL1_NOMPRD
    		ZLB->ZLB_TIPCD 	:= IIF(mv_par08==1,"C","D")
    		ZLB->ZLB_TPDESP	:= mv_par09
    		ZLB->ZLB_VALOR 	:= mv_par10
    		ZLB->ZLB_DTMOV 	:= ddatabase
    		ZLB->ZLB_DTVCTO	:= dVencto
    		ZLB->ZLB_HIST  	:= mv_par11
    		ZLB->(MsUnLock())
    	EndIf               
    	ConfirmSX8()
    	
    	nRegInc += 1
    	(cAliasTMP)->(dbSkip())
    Enddo                                                   
    (cAliasTMP)->(dbCloseArea())    
    	    		
    
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV04E    บAutor  ณRafael Parma      บ Data ณ  24/02/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclusใo de registros em lote.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     
*-------------------------*
User Function LTMOV04E()
*-------------------------*
Private cPergE  := "LTMOV0004E"
Private nRegInc := 0

	//--Exibe janela de parโmetros..
	AjustSX1E()
	If Pergunte(cPergE,.T.)

		If Aviso("Aviso","Confirma exclusใo dos movimentos c๓digo de: "+mv_par01+" at้: "+mv_par02+" ?",{"Sim","Nใo"}) == 1
    	                                                                                            
  			//--Chamada da fun็ใo para exclusใo de registros..
	    	MsAguarde({ || fExcZLB() }, "Processando registros...")

    		Aviso("Aviso","Foram excluํdos: "+cValToChar(nRegInc)+" movimentos no conta corrente.",{"OK"})
    	EndIf
		
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExcZLB     บAutor  ณRafael Parma      บ Data ณ  24/02/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclusใo de registros em lote.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     
	
*--------------------------------*
Static Function fExcZLB()
*--------------------------------*
Local cAliasTMP  := GetNextAlias()
Local hEnter	 := CHR(10)+CHR(13) 
        

	cQuery := "	SELECT 	ZLB.R_E_C_N_O_               					   			" + hEnter
	cQuery += "	FROM " + RetSqlName("ZLB") + " ZLB						  			" + hEnter 
	cQuery += "	WHERE    ZLB.ZLB_FILIAL    = '" + xFilial("ZLB") + "' 	  			" + hEnter
	cQuery += "	AND      ZLB.ZLB_COD BETWEEN '" + mv_par01 + "'  	   				" + hEnter
	cQuery += "	AND      					 '" + mv_par02 + "' 		   			" + hEnter
	cQuery += "	AND      ZLB.ZLB_STATUS    = '"+Space(TAMSX3("ZLB_STATUS")[1])+"'	" + hEnter
	cQuery += "	AND 	 ZLB.D_E_L_E_T_   != '*' 									" + hEnter
		
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	


	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
    While !(cAliasTMP)->(EOF())              
		dbSelectArea("ZLB")
		ZLB->(dbGoTo((cAliasTMP)->R_E_C_N_O_))
		If RecLock("ZLB",.F.)
			ZLB->(dbDelete())
			ZLB->(MsUnLock())
		EndIf       	
    	nRegInc += 1
    	(cAliasTMP)->(dbSkip())
    Enddo                                                   
    (cAliasTMP)->(dbCloseArea())    
    	    		
    
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV4TK  บAutor  ณMarcelo Joner        บ Data ณ 05/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela valida็ใo geral na inclusใo e alteraบฑฑ
ฑฑบ          ณ็ใo de movimentos no Conta Corrente do produtor.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laticinio                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LTMOV4TK()

Local lRet		:= .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta valida็๕es caso seja INCLUSรO ou ALTERAวรOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If INCLUI .OR. ALTERA
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณCaso o valor da despesa seja superior ao saldo, alerta e impede เ inclusใoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If M->ZLB_VALOR > M->ZLB_SALDO 
		If l004Auto
			U_GLALL001("O produtor nใo possui saldo financeiro.", "Aten็ใo", "Para inclusใo de despesas, deve-se haver saldo financeiro igual ou superior ao valor da despesa.")
		Else
			U_GLALL001("Aten็ใo", "O produtor nใo possui saldo financeiro suficiente para inclusใo desta despesa.", "Para inclusใo de despesas, deve-se haver saldo financeiro igual ou superior ao valor da despesa.")
		EndIf
		
		lRet := .F.	
	EndIf
EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  28/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1()
Local i, j
aRegs   := {}


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Data Movimento De   ?","Data Movimento De   ?","Data Movimento De   ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1501."})
	aAdd(aRegs,{cPerg,"02","Data Movimento At้  ?","Data Movimento At้  ?","Data Movimento At้  ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1502."})	
	aAdd(aRegs,{cPerg,"03","Data Vencimento De  ?","Data Vencimento De  ?","Data Vencimento De  ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1503."})
	aAdd(aRegs,{cPerg,"04","Data Vencimento At้ ?","Data Vencimento At้ ?","Data Vencimento At้ ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1504."})	
	aAdd(aRegs,{cPerg,"05","Produtor/Transp.De  ?","Produtor/Transp.De  ?","Produtor/Transp.De  ?","mv_ch5","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",".LTREL1505."})
	aAdd(aRegs,{cPerg,"06","Produtor/Transp.At้ ?","Produtor/Transp.At้ ?","Produtor/Transp.At้ ?","mv_ch6","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",".LTREL1506."})
	aAdd(aRegs,{cPerg,"07","Loja Prd/Transp.De  ?","Loja Prd/Transp.De  ?","Loja Prd/Transp.De  ?","mv_ch7","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1507."})
	aAdd(aRegs,{cPerg,"08","Loja Prd/Transp.At้ ?","Loja Produtor At้   ?","Loja Produtor At้   ?","mv_ch8","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",".LTREL1508."})
	aAdd(aRegs,{cPerg,"09","Linha De            ?","Linha De            ?","Linha De            ?","mv_ch9","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1509."})
	aAdd(aRegs,{cPerg,"10","Linha At้           ?","Linha At้           ?","Linha At้           ?","mv_cha","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",".LTREL1510."})
	aAdd(aRegs,{cPerg,"11","Tipo Movimento      ?","Tipo Movimento      ?","Tipo Movimento      ?","mv_chb","N",01,0,1,"C","","mv_par11","Cr้dito","Cr้dito","Cr้dito","","","D้bito","D้bito","D้bito","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","","","",".LTREL1511."})
	aAdd(aRegs,{cPerg,"12","Saltar Pแgina/Recibo?","Saltar Pแgina/Recibo?","Saltar Pแgina/Recibo?","mv_chc","N",01,0,1,"C","","mv_par12","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","","","","","","","",""})
	
	
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
					
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1T บAutor  ณRafael Parma       บ Data ณ  14/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas. Inclusใo registros em lote.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustSX1T()
Local i,j
aRegs   := {}


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPergT,"01","Linha De            ?","Linha De            ?","Linha De            ?","mv_ch1","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",""})
	aAdd(aRegs,{cPergT,"02","Linha At้           ?","Linha At้           ?","Linha At้           ?","mv_ch2","C",TAMSX3("ZL0_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "ZL0000","","",""})
	aAdd(aRegs,{cPergT,"03","Produtor De         ?","Produtor De         ?","Produtor De         ?","mv_ch3","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})
	aAdd(aRegs,{cPergT,"04","Produtor At้        ?","Produtor At้        ?","Produtor At้        ?","mv_ch4","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})
	aAdd(aRegs,{cPergT,"05","Loja De             ?","Loja De             ?","Loja De             ?","mv_ch5","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergT,"06","Loja At้            ?","Loja At้            ?","Loja At้            ?","mv_ch6","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergT,"07","Forma de Pagamento  ?","Forma de Pagamento  ?","Forma de Pagamento  ?","mv_ch7","N",01,0,1,"C","","mv_par07","Cheque","Cheque","Cheque","","","Dep๓sito","Dep๓sito","Dep๓sito","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergT,"08","Tipo do Movimento   ?","Tipo do Movimento   ?","Tipo do Movimento   ?","mv_ch8","N",01,0,1,"C","","mv_par08","Cr้dito","Cr้dito","Cr้dito","","","D้bito","D้bito","D้bito","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPergT,"09","Motivo do Movimento ?","Motivo do Movimento ?","Motivo do Movimento ?","mv_ch9","C",TAMSX3("ZLB_TPDESP")[1],0,0,"G","ExistCPO('SX5','LT'+mv_par09)","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "LT","","",""})
	aAdd(aRegs,{cPergT,"10","Valor do Movimento  ?","Valor do Movimento  ?","Valor do Movimento  ?","mv_cha","N",14,2,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergT,"11","Hist๓rico Movimento ?","Hist๓rico Movimento ?","Hist๓rico Movimento ?","mv_chb","C",TAMSX3("ZLB_HIST")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPergT + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next  
					
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1E บAutor  ณRafael Parma       บ Data ณ  14/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas. Exclusใo registros em lote.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustSX1E()
Local i,j
aRegs   := {}


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPergE,"01","C๓digo Movimento De ?","C๓digo Movimento De ?","C๓digo Movimento De ?","mv_ch1","C",TAMSX3("ZLB_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "ZLB000","","",""})
	aAdd(aRegs,{cPergE,"02","C๓digo Movimento At้?","C๓digo Movimento At้?","C๓digo Movimento At้?","mv_ch2","C",TAMSX3("ZLB_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "ZLB000","","",""})
	
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPergE + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next  
					
Return Nil
