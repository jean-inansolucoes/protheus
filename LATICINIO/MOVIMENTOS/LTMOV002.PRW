#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV002 บAutor  ณRafael Parma         บ Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de entrada de dados de coleta de leite do transpor-  บฑฑ
ฑฑบ          ณtador.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------*
User Function LTMOV002(xRotAuto, nOpc)
	*-----------------------*

	Local cAliasTAB		:= "ZL7"
	Local cUsrPort		:= GETMV("MV_ZL00000",, "")
	Private aCores		:= {}
	Private aRotina

	Private l002Auto	:= xRotAuto <> NIL
	Private cCadastro	:= "Mov. Transportador"

	If __cUserId $ cUsrPort
		aRotina:= {{"Pesquisar"    	, "AxPesqui"   , 0, 1},;
			{"Visualizar"   	, "AxVisual"   , 0, 2},;
			{"Incluir"      	, "U_LTMOV2D3" , 0, 3}}
	Else
		aRotina:= {{"Pesquisar"    	, "AxPesqui"   , 0, 1},;
			{"Visualizar"   	, "AxVisual"   , 0, 2},;
			{"Incluir"      	, "U_LTMOV2D3" , 0, 3},;
			{"Alterar"      	, "U_LTMOV2D3" , 0, 4},;
			{"Excluir"      	, "U_LTMOV2D3" , 0, 5},;
			{"Totalizador"  	, "U_LTMOV2TT" , 0, 6},;
			{"Rastreab. Antib."	, "U_LTMOV2AN" , 0, 7},;
			{"Anแlises Tanques"	, "U_LTMOV2TQ" , 0, 8}}
	EndIf
	dbSelectArea(cAliasTAB)
	(cAliasTAB)->(dbSetOrder(1))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Endereca a funcao de BROWSE                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If l002Auto
		aRotAuto := xRotAuto
		MBrowseAuto(nOpc, aRotAuto, cAliasTAB)
	Else
		AADD(aCores, {'ZL7_STATUS == " "', 'BR_VERDE'   })
		AADD(aCores, {'ZL7_STATUS != " "', 'BR_VERMELHO'})
		mBrowse( ,,,,cAliasTAB,,,,,, aCores)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV2D3 บAutor  ณRafael Parma         บ Data ณ  09/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de entrada de dados de coleta de leite do transpor-  บฑฑ
ฑฑบ          ณtador, movimentos de estoque.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/     
	*-------------------------------------------*
User Function LTMOV2D3( cAlias, nReg, nOpc )
	*-------------------------------------------*

	Local cMV_ZLTTMV	:= AllTRIM(GetMV("MV_ZLTTMV")) 		// tipo do movimento de inclusใo do estoque valorizado
	Local cMV_ZLTTMI	:= AllTRIM(GetMV("MV_ZLTTMI")) 		// tipo do movimento de inclusใo do estoque quantidade
	Local cMV_ZLTTME	:= AllTRIM(GetMV("MV_ZLTTME")) 		// tipo do movimento de estorno do estoque
	Local cMV_ZLTLOC	:= AllTRIM(GetMV("MV_ZLTLOC"))		// armazem do movimento
	Local cMV_ZLTPRD	:= AllTRIM(GetMV("MV_ZLTPRD"))		// c๓digo do produto
	Local nZL7_QTDTRP	:= ZL7->ZL7_QTDTRP                   // quantidade da vazใo
	Local dZL7_DATA		:= ZL7->ZL7_DATA                     // data do movimento
	Local cZL7_COD		:= ZL7->ZL7_COD						// c๓digo do movimento
	Local CZL7_FILIAL	:= ZL7->ZL7_FILIAL
	Local aArraySD3_I	:= {}								// Array de inclusใo do estoque
	//Local aArraySD3_E	:= {}								// Array de estorno do estoque
	Local aArea			:= GetArea()
	Local nConfirm		:= 0
	Local cQuery    := ""
	Local cAliasTMP	:= GetNextAlias()
	Local aDadosMov := {}

	Private lMsHelpAuto := .T. // se .T. direciona as mensagens de help
	Private lMsErroAuto := .F. //necessario a criacao
	Private l241Auto    := .T. //Nใo apresenta mensagem de confirma็ใo




	Public STRING_Null	:= ""


	If cMV_ZLTPRD == STRING_Null
		U_LTALL001("Aten็ใo", "Produto nใo informado no parโmetro para movimento de estoque.","Inserir o conte๚do no param๊tro MV_ZLTPRD.")
		Return
	Else
		dbSelectArea("SB1")
		dbSetOrder(1)
		If ! dbSeek( xFilial("SB1") + cMV_ZLTPRD )
			U_LTALL001("Aten็ใo", "Produto informado no parโmetro nใo existente para movimento de estoque.","Verificar o conte๚do no param๊tro MV_ZLTPRD.")
			Return
		EndIf
	EndIf

	If cMV_ZLTTMI == STRING_Null .or. cMV_ZLTTME == STRING_Null .or. cMV_ZLTTMV == STRING_Null
		U_LTALL001("Aten็ใo", "Tipos de movimentos entrada/estorno nใo informados nos parโmetros para movimento de estoque.","Inserir o conte๚do nos param๊tros MV_ZLTTMI/MV_ZLTTME/MV_ZLTTMV.")
		Return
	Else
		dbSelectArea("SF5")
		dbSetOrder(1)
		If ! dbSeek( xFilial("SF5") + cMV_ZLTTMV )
			U_LTALL001("Aten็ใo", "Tipo de movimento de entrada informado no parโmetro nใo existente para movimento de estoque.","Verificar o conte๚do no param๊tro MV_ZLTTMV.")
			Return
		EndIf
		If ! dbSeek( xFilial("SF5") + cMV_ZLTTMI )
			U_LTALL001("Aten็ใo", "Tipo de movimento de entrada informado no parโmetro nใo existente para movimento de estoque.","Verificar o conte๚do no param๊tro MV_ZLTTMI.")
			Return
		EndIf
		If ! dbSeek( xFilial("SF5") + cMV_ZLTTME )
			U_LTALL001("Aten็ใo", "Tipo de movimento de estorno informado no parโmetro nใo existente para movimento de estoque.","Verificar o conte๚do no param๊tro MV_ZLTTME.")
			Return
		EndIf

	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณNใo permite manipular Mov. Transportador vinculado hแ Pesagemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	If nOpc == 4  .OR. nOpc == 5
		If !EMPTY(ZL7->ZL7_NUMPES)
			U_LTALL001("Aten็ใo", "O Mov. Transportador selecionado encontra-se vinculado hแ Pesagem " + ALLTRIM(ZL7->ZL7_NUMPES) + ".", "Nใo ้ possํvel " + IIF(nOpc == 4, "alterar", "excluir") + " Mov. Transportador que esteja vinculado hแ Pesagem.")
			Return
		EndIf
	EndIf

	RestArea(aArea)

	// Entrada de dados (ZL7)
	If nOpc == 3

		If AxInclui(cAlias,nReg,nOpc,/*aAcho*/,/*cFunc*/,/*aCpos*/,"U_LTMOV2VD()") == 1
			If ZL7->ZL7_TPROD != "O" .And. ZL7->ZL7_QTDVAZ > 0

				nQTDEST := (ZL7->ZL7_QTDTRP + ZL7->ZL7_QTDSOB ) - ( ZL7->ZL7_QTDANT + ZL7->ZL7_QTDFAL + ZL7->ZL7_QTDDES)
				/*
				// Entrada movimentos internos
				aArraySD3_I  := {	{"D3_FILIAL"	,ZL7->ZL7_FILIAL	,Nil	},;
									{"D3_TM"		,cMV_ZLTTMI			,Nil	},;
									{"D3_COD"		,cMV_ZLTPRD			,Nil	},;
									{"D3_UM"		,"L"			,Nil	},;
									{"D3_QUANT"		,nQTDEST			,Nil	},;
									{"D3_LOCAL"		,cMV_ZLTLOC			,Nil	},;
									{"D3_DOC"  		,ZL7->ZL7_COD		,Nil	},;
									{"D3_EMISSAO"	,ZL7->ZL7_DATA		,Nil	} }
				*/
				// Entrada movimentos internos
				aArraySD3_I  := {	{"D3_FILIAL"	,ZL7->ZL7_FILIAL	,Nil	},;
					{"D3_TM"		,cMV_ZLTTMI			,Nil	},;
					{"D3_COD"		,cMV_ZLTPRD			,Nil	},;
					{"D3_UM"		,"L"				,Nil	},;
					{"D3_LOCAL"		,cMV_ZLTLOC			,Nil	},;
					{"D3_QUANT"		,nQTDEST			,Nil	},;
					{"D3_DOC"  		,ZL7->ZL7_COD		,Nil	},;
					{"D3_EMISSAO"	,ZL7->ZL7_DATA		,Nil	} }
				nOldMod := nModulo
				nModulo := 4
				//MATA240(aArraySD3_I,3)
				U_LSMTA241(aArraySD3_I,"I")
				nModulo :=nOldMod

			EndIf
		EndIf


	ElseIf nOpc == 4

		// Altera็ใo de dados (ZL7)
		nZL7_QTDTRP := ZL7->ZL7_QTDTRP
		nZL7_QTDSOB := ZL7->ZL7_QTDSOB
		nZL7_QTDANT := ZL7->ZL7_QTDANT
		nZL7_QTDFAL := ZL7->ZL7_QTDFAL
		nZL7_QTDDES := ZL7->ZL7_QTDDES
		dZL7_DATA   := ZL7->ZL7_DATA
		cZL7_COD    := ZL7->ZL7_COD
		cZL7_FILIAL := ZL7->ZL7_FILIAL

		l002Auto := If(Type('l002Auto') <> 'L', .F., l002Auto)

		If l002Auto
			nConfirm := AxAltera(cAlias, nReg, nOpc,,,,,"U_LTMOV2VD()",/*cTransact*/,/*cFunc*/,/*aButtons>*/,/*aParam*/,aRotAuto,/*lVirtual*/,/*lMaximized*/)
		Else
			nConfirm := AxAltera(cAlias, nReg, nOpc,,,,,"U_LTMOV2VD()",/*cTransact*/,/*cFunc*/,/*aButtons>*/,/*aParam*/,/*aRotAuto*/,/*lVirtual*/,/*lMaximized*/)
		EndIf

		If nConfirm == 1

			// se a quantidade ou a data for alterada, estorna o movimento e inclui novamente
			If 	nZL7_QTDTRP != ZL7->ZL7_QTDTRP .or. dZL7_DATA   != ZL7->ZL7_DATA   .or. nZL7_QTDSOB != ZL7->ZL7_QTDSOB .or. ;
					nZL7_QTDANT != ZL7->ZL7_QTDANT .or. nZL7_QTDFAL != ZL7->ZL7_QTDFAL .or. nZL7_QTDDES != ZL7->ZL7_QTDDES

				If ZL7->ZL7_TPROD != "O"

					nQTDEST := (nZL7_QTDTRP + nZL7_QTDSOB ) - ( nZL7_QTDANT + nZL7_QTDFAL + nZL7_QTDDES)

				   /* // Estorno movimentos internos (valores antigos)
					aArraySD3_E  := {	{"D3_FILIAL"	,cZL7_FILIAL	 ,Nil	},;
										{"D3_TM"		,cMV_ZLTTME		 ,Nil	},;
										{"D3_COD"		,cMV_ZLTPRD		 ,Nil	},;
										{"D3_LOCAL"		,cMV_ZLTLOC		 ,Nil	},;
										{"D3_QUANT"		,nQTDEST		 ,Nil	},;						
										{"D3_DOC"  		,cZL7_COD		 ,Nil	},;						
										{"D3_EMISSAO"	,dZL7_DATA		 ,Nil	} }											
					
					*/

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Sele็ใo de Movimentos internos de Qtde e Valores       ณ
					//ณ gerados pelo Registro dos Itens da NF                  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					cQuery := " SELECT D3_FILIAL, D3_TM, D3_COD, D3_LOCAL, D3_UM, D3_QUANT, D3_CF,  D3_DOC, D3_CC, "   + CRLF
					cQuery += "        D3_EMISSAO, D3_LOTECTL, D3_NUMSEQ, D3_OBSERVA, D3_CUSTO1, R_E_C_N_O_ NRECNO "   + CRLF
					cQuery += " FROM "+RetSqlName( "SD3" )                          + CRLF
					cQuery += " WHERE D_E_L_E_T_ <> '*' "                           + CRLF
					cQuery += "     AND D3_FILIAL   = '" + cZL7_FILIAL +   	"'"    + CRLF
					cQuery += "     AND D3_DOC      = '" + cZL7_COD +    	"'"    + CRLF
					cQuery += "     AND D3_COD      = '" + cMV_ZLTPRD +     "'"    + CRLF
					cQuery += " 	AND D3_ESTORNO <> 'S' "                         + CRLF

					//ฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					//ณExecuta consulta SQL   ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					cAliasTMP := GetNextAlias()
					TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

					dbSelectArea(cAliasTMP)
					(cAliasTMP)->(dbGoTop())
					While (cAliasTMP)->(!EOF())

						//*****************************************************
						// adiciona os dados da Nf ao array aDadosMov que serแ
						// utilizando no execauto do Movimento Interno MATA241
						//*****************************************************
						aDadosMov := {}
						aAdd(aDadosMov,(cAliasTMP)->D3_FILIAL)  //01-Filial
						aAdd(aDadosMov,(cAliasTMP)->D3_TM)      //02-Tipo Movimento
						aAdd(aDadosMov,(cAliasTMP)->D3_COD)     //03-Produto
						aAdd(aDadosMov,(cAliasTMP)->D3_UM)      //04-Unidade Medida
						aAdd(aDadosMov,(cAliasTMP)->D3_LOCAL)   //05-Local
						aAdd(aDadosMov,(cAliasTMP)->D3_QUANT)   //06-Quantidade
						aAdd(aDadosMov,(cAliasTMP)->D3_DOC)     //07-Nro Documento
						aAdd(aDadosMov,(cAliasTMP)->D3_EMISSAO) //08-Data Digita็ใo
						aAdd(aDadosMov,(cAliasTMP)->D3_NUMSEQ)  //09-NUMSEQ Numero Sequencial


						//**********************************************************************
						//Gera Estorno do Movimento Interno Multiplo da diferen็a da Quantidade
						//**********************************************************************
						U_LSMTA241(aDadosMov,"E")

						(cAliasTMP)->(dbSkip())
						exit
					Enddo

					(cAliasTMP)->(dbCloseArea())

					RestArea(aArea)

					nQTDEST := (ZL7->ZL7_QTDTRP + ZL7->ZL7_QTDSOB ) - ( ZL7->ZL7_QTDANT + ZL7->ZL7_QTDFAL + ZL7->ZL7_QTDDES)

					// Entrada movimentos internos (novos valores)
					/*aArraySD3_I  := {	{"D3_TM"		,cMV_ZLTTMI			,Nil	},;
										{"D3_COD"		,cMV_ZLTPRD			,Nil	},;
										{"D3_QUANT"		,nQTDEST			,Nil	},;
										{"D3_LOCAL"		,cMV_ZLTLOC			,Nil	},;
										{"D3_DOC"  		,ZL7->ZL7_COD		,Nil	},;
										{"D3_EMISSAO"	,ZL7->ZL7_DATA		,Nil	} }	
					*/
					
					aDadosMov := {}
						aAdd(aDadosMov,cZL7_FILIAL)  //01-Filial
						aAdd(aDadosMov,cMV_ZLTTMI)      //02-Tipo Movimento
						aAdd(aDadosMov,cMV_ZLTPRD)     //03-Produto
						aAdd(aDadosMov,"L")      //04-Unidade Medida
						aAdd(aDadosMov,cMV_ZLTLOC)   //05-Local
						aAdd(aDadosMov,nQTDEST)   //06-Quantidade
						aAdd(aDadosMov,ZL7->ZL7_COD)     //07-Nro Documento
						aAdd(aDadosMov,ZL7->ZL7_DATA) //08-Data Digita็ใo
						
					nOldMod := nModulo
					nModulo := 4
					//MATA240(aArraySD3_I,3)
					U_LSMTA241(aDadosMov,"I")
					nModulo :=nOldMod
				/*	
					If lMsErroAuto
						MostraErro()
					
					Else
						//--Envio de workflow de altera็ใo
						//fSendWF()
					EndIf				
				*/
				EndIf

			EndIf

		EndIf

	ElseIf nOpc == 5 .and. U_LTMOV2VD()

		// Estorno movimentos internos
		nQTDEST := (ZL7->ZL7_QTDVAZ + ZL7->ZL7_QTDSOB ) - ( ZL7->ZL7_QTDANT + ZL7->ZL7_QTDFAL + ZL7->ZL7_QTDDES)

		/*aArraySD3_E  := {	{"D3_TM"		,cMV_ZLTTME			,Nil	},;
			{"D3_COD"		,cMV_ZLTPRD			,Nil	},;
			{"D3_QUANT"		,nQTDEST			,Nil	},;
			{"D3_LOCAL"		,cMV_ZLTLOC			,Nil	},;
			{"D3_DOC"  		,ZL7->ZL7_COD		,Nil	},;
			{"D3_EMISSAO"	,ZL7->ZL7_DATA		,Nil	} }*/


		If AxDeleta(cAlias, nReg, nOpc) != 1

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Sele็ใo de Movimentos internos de Qtde e Valores       ณ
					//ณ gerados pelo Registro dos Itens da NF                  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					cQuery := " SELECT D3_FILIAL, D3_TM, D3_COD, D3_LOCAL, D3_UM, D3_QUANT, D3_CF,  D3_DOC, D3_CC, "   + CRLF
					cQuery += "        D3_EMISSAO, D3_LOTECTL, D3_NUMSEQ, D3_OBSERVA, D3_CUSTO1, R_E_C_N_O_ NRECNO "   + CRLF
					cQuery += " FROM "+RetSqlName( "SD3" )                          + CRLF
					cQuery += " WHERE D_E_L_E_T_ <> '*' "                           + CRLF
					cQuery += "     AND D3_FILIAL   = '" + cZL7_FILIAL +   	"'"    + CRLF
					cQuery += "     AND D3_DOC      = '" + cZL7_COD +    	"'"    + CRLF
					cQuery += "     AND D3_COD      = '" + cMV_ZLTPRD +     "'"    + CRLF
					cQuery += " 	AND D3_ESTORNO <> 'S' "                         + CRLF

					//ฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					//ณExecuta consulta SQL   ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					cAliasTMP := GetNextAlias()
					TCQuery ChangeQuery( cQuery ) NEW Alias (cAliasTMP)

					dbSelectArea(cAliasTMP)
					(cAliasTMP)->(dbGoTop())
					While (cAliasTMP)->(!EOF())

						//*****************************************************
						// adiciona os dados da Nf ao array aDadosMov que serแ
						// utilizando no execauto do Movimento Interno MATA241
						//*****************************************************
						aDadosMov := {}
						aAdd(aDadosMov,(cAliasTMP)->D3_FILIAL)  //01-Filial
						aAdd(aDadosMov,(cAliasTMP)->D3_TM)      //02-Tipo Movimento
						aAdd(aDadosMov,(cAliasTMP)->D3_COD)     //03-Produto
						aAdd(aDadosMov,(cAliasTMP)->D3_UM)      //04-Unidade Medida
						aAdd(aDadosMov,(cAliasTMP)->D3_LOCAL)   //05-Local
						aAdd(aDadosMov,(cAliasTMP)->D3_QUANT)   //06-Quantidade
						aAdd(aDadosMov,(cAliasTMP)->D3_DOC)     //07-Nro Documento
						aAdd(aDadosMov,(cAliasTMP)->D3_EMISSAO) //08-Data Digita็ใo
						aAdd(aDadosMov,(cAliasTMP)->D3_NUMSEQ)  //09-NUMSEQ Numero Sequencial


						//**********************************************************************
						//Gera Estorno do Movimento Interno Multiplo da diferen็a da Quantidade
						//**********************************************************************
						U_LSMTA241(aDadosMov,"E")

						(cAliasTMP)->(dbSkip())
						exit
					Enddo

		EndIf

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV2TT บAutor  ณRafael Parma         บ Data ณ  16/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para totalizar a quantidade por linha + data.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS LATICINIO                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
		*-----------------------*
User Function LTMOV2TT()
	*-----------------------*
//Local nOpca := 0
	Local aArea := GetArea()
	Private cCODLIN  := Space(TAMSX3("ZL0_COD")[1])
	Private dDATATT  := ddatabase
	Private nTOTAL   := 0

	dbSelectArea("ZL0")

	DEFINE MSDIALOG oDlg FROM 010,100 TO 180,400 TITLE "Total da plataforma"  OF oMainWnd PIXEL
	@ 015,015 SAY "C๓digo Linha: "  SIZE 50,10 OF oDlg PIXEL
	@ 015,060 MSGET cCODLIN  F3 "ZL0000" SIZE 050,10 OF oDlg PIXEL
	@ 030,015 SAY "Data: "  SIZE 50,10 OF oDlg PIXEL
	@ 030,060 GET dDATATT VALID (!VAZIO()) SIZE 050,10 OF oDlg PIXEL
	@ 045,015 SAY "Total:  "  SIZE 50,10 OF oDlg PIXEL
	@ 045,060 GET nTOTAL PICTURE "@E 9,999,999.99"  WHEN .F.  SIZE 050,10 OF oDlg PIXEL

	DEFINE SBUTTON FROM 065, 060 TYPE 1 ACTION (MsAguarde({||fUpdZL2(cCODLIN,dDATATT,@nTOTAL) },"Processando..."))ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM 065, 090 TYPE 2 ACTION (oDlg:End())ENABLE OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	RestArea(aArea)

Return ()


	*------------------------------------------------*
Static Function fUpdZL2(cCODLIN, dDATATT, nTOTAL)
	*------------------------------------------------*
	Local cAliasTMP := "TZL7"
	nTOTAL := 0

	cQuery := "SELECT	SUM(ZL7.ZL7_QTDVAZ) AS ZL7_QTDVAZ			" + CHR(13)
	cQuery += "FROM 	" + RetSQLName("ZL7") + " ZL7				" + CHR(13)
	cQuery += "WHERE	ZL7.ZL7_FILIAL  = '" + xFilial("ZL7") + "'	" + CHR(13)
	If cCODLIN != Space(TAMSX3("ZL0_COD")[1])
		cQuery += "AND  	ZL7.ZL7_LINHA   = '" + cCODLIN	  + "'	" + CHR(13)
	EndIf
	cQuery += "AND  	ZL7.ZL7_DATA    = '" + dtos(dDATATT)  + "'	" + CHR(13)
	cQuery += "AND  	ZL7.D_E_L_E_T_ != '*'						" + CHR(13)

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	nTOTAL := (cAliasTMP)->ZL7_QTDVAZ
	(cAliasTMP)->(dbCloseArea())

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV2AN  บAutor  ณRafael Parma       บ Data ณ  10/09/09    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de anแlises por produtor.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*----------------------------------------------*
User Function LTMOV2AN( cAlias, nReg, nOpc )
	*----------------------------------------------*
	Local aArea        := GetArea()
	Local aPosObj      := {}
	Local aObjects     := {}
	Local aSize        := MsAdvSize( .F. )
//Local aGet         := {}
	Local aTravas      := {}
//Local aEntidade    := {}
	Local aRecZLD      := {}
//Local aChave       := {}

	Local cSeekZLD     := ""
	Local cEntidade    := "ZLD"

	Local lGravou      := .F.
	Local lTravas      := .T.

	Local nCntFor      := 0
	Local nUsado       := 0
//Local nPosUser     := 0
	Local nOpcA        := 0
//Local nScan        := 0
//Local nLoop        := 0

	Local oDlg
	Local oGetD
	Local oGetCPO

	PRIVATE lALTER     := .T.
	PRIVATE aCols      := {}
	PRIVATE aHeader    := {}

	nOpc := 4

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona a entidade                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cEntidade)
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("ZLD") + ZL7->ZL7_COD )
		dZLD_DATAC  := ZLD->ZLD_DATCOL
		dZLD_DATAN  := ZLD->ZLD_DATANA
		cZLD_COLETO := ZLD->ZLD_COLETO
		cZLD_ANALIS := ZLD->ZLD_ANALIS
		nZLD_QTDCON := ZLD->ZLD_QTDCON
	Else
		dZLD_DATAC  := ddatabase
		dZLD_DATAN  := ddatabase
		cZLD_COLETO := Space(TAMSX3("ZLD_COLETO")[1])
		cZLD_ANALIS := Space(TAMSX3("ZLD_ANALIS")[1])
		nZLD_QTDCON := 0
	EndIf

	SX2->( dbSetOrder( 1 ) )
	SX2->( dbSeek( cEntidade ) )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeader                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidade)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidade )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "ZLD_FILIAL|ZLD_CODMOV|ZLD_DATCOL|ZLD_DATANA|ZLD_COLETO|ZLD_ANALIS" )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf

		SX3->( dbSkip() )
	EndDo

	If nOpc != 3

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do aCols                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea(cEntidade)
		dbSetOrder(1)
		(cEntidade)->(dbGoTop())

		cSeekZLD := xFilial( cEntidade ) + ZL7->ZL7_COD
		If (cEntidade)->( MsSeek( cSeekZLD ) )

			While ( !Eof() .And. cSeekZLD == ZLD->(ZLD_FILIAL+ZLD_CODMOV)  )

				If ( SoftLock(cEntidade ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aCols,Array(nUsado+1))
					AAdd(aRecZLD, (cEntidade)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeader[nCntFor][10] != "V" )
							aCols[Len(aCols)][nCntFor] := ZLD->(FieldGet(FieldPos(aHeader[nCntFor][2])))
						Else
							aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
						EndIf
					Next
					aCols[Len(aCols)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidade)->( dbSkip()   )
			EndDo

		Else

			nOpc := 3

			cAliasTMP := GetNextAlias()
			nPosPRD := aScan(aHeader,{|x| AllTrim(x[2])=="ZLD_PRODUT"})
			nPosLOJ := aScan(aHeader,{|x| AllTrim(x[2])=="ZLD_LOJPRD"})
			nPosNOM := aScan(aHeader,{|x| AllTrim(x[2])=="ZLD_NOMPRD"})
			nPosAMS := aScan(aHeader,{|x| AllTrim(x[2])=="ZLD_NUMERO"})
			nPosANT := aScan(aHeader,{|x| AllTrim(x[2])=="ZLD_ANTIBI"})

			cQuery := "	SELECT 	ZL6.ZL6_PRODUT, 										"+chr(10)+chr(13)
			cQuery += "			ZL6.ZL6_LOJPRD, 										"+chr(10)+chr(13)
			cQuery += "			ZL6.ZL6_NOMPRD, 										"+chr(10)+chr(13)
			cQuery += "			ZL6.ZL6_AMOSTR 											"+chr(10)+chr(13)
			cQuery += "	FROM " + RetSQLName("ZL6") + " ZL6  							"+chr(10)+chr(13)
			cQuery += " INNER JOIN " + RetSQLName("ZL5") + " ZL5  						"+chr(10)+chr(13)
			cQuery += " ON ZL5.ZL5_FILIAL = ZL6.ZL6_FILIAL  							"+chr(10)+chr(13)
			cQuery += " AND ZL5.ZL5_COD   = ZL6.ZL6_COD   								"+chr(10)+chr(13)
			cQuery += " WHERE ZL5.ZL5_FILIAL = '" + xFilial("ZL5") + "' 				"+chr(10)+chr(13)
			cQuery += " AND ZL5.ZL5_DATA   = '"+DTOS(ZL7->ZL7_DATA)+"'   				"+chr(10)+chr(13)
			cQuery += " AND ZL5.ZL5_LINHA  = '"+ZL7->ZL7_LINHA+"'   					"+chr(10)+chr(13)
			cQuery += " AND ZL6.ZL6_AMOSTR != '"+Space(TAMSX3("ZL6_AMOSTR")[1])+"'   	"+chr(10)+chr(13)
			cQuery += " AND ZL5.D_E_L_E_T_ != '*'   									"+chr(10)+chr(13)
			cQuery += " AND ZL6.D_E_L_E_T_ != '*'   									"+chr(10)+chr(13)

			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			If !(cAliasTMP)->(EOF())

				dbSelectArea(cEntidade)
				AAdd(aTravas,{ Alias() , RecNo() })

				While !(cAliasTMP)->(EOF())

					AAdd(aCols,Array(nUsado+1))
					For nCntFor := 1 To nUsado
						If ( AllTrim(aHeader[nCntFor][2])=="ZLD_PRODUT" )
							aCols[Len(aCols)][nPosPRD] := (cAliasTMP)->ZL6_PRODUT
						ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLD_LOJPRD" )
							aCols[Len(aCols)][nPosLOJ] := (cAliasTMP)->ZL6_LOJPRD
						ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLD_NOMPRD" )
							aCols[Len(aCols)][nPosNOM] := (cAliasTMP)->ZL6_NOMPRD
						ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLD_NUMERO" )
							aCols[Len(aCols)][nPosAMS] := (cAliasTMP)->ZL6_AMOSTR
						ElseIf ( AllTrim(aHeader[nCntFor][2])=="ZLD_ANTIBI" )
							aCols[Len(aCols)][nPosANT] := CriaVar( aHeader[nCntFor,2] )
						EndIf
					Next nCntFor
					aCols[Len(aCols)][nUsado+1] := .F.

					(cAliasTMP)->(dbSkip())
				Enddo

			EndIf

			(cAliasTMP)->(dbCloseArea())

		EndIf


	Endif

	If Empty( aCols )
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[1][nUsado+1] := .F.

	EndIf

	If ( lTravas )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณJanela de manuten็ใo                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		AAdd( aObjects, { 100,  64, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 017,005 SAY OemToAnsi("Linha: ") 	   		SIZE 050,009 OF oDlg PIXEL
		@ 016,040 GET oGetCPO VAR ZL7->ZL7_LINHA 	SIZE 050,009 OF oDlg PIXEL WHEN .F.
		@ 016,100 GET oGetCPO VAR ZL7->ZL7_NOMLIN 	SIZE 100,009 OF oDlg PIXEL WHEN .F.
		@ 017,220 SAY OemToAnsi("Transportador: ")	SIZE 050,009 OF oDlg PIXEL
		@ 016,260 GET oGetCPO VAR ZL7->ZL7_TRANSP 	SIZE 050,009 OF oDlg PIXEL WHEN .F.
		@ 016,320 GET oGetCPO VAR ZL7->ZL7_NOMTRP 	SIZE 100,009 OF oDlg PIXEL WHEN .F.

		@ 033,005 SAY OemToAnsi("Data Coleta: ")	SIZE 050,009 OF oDlg PIXEL
		@ 032,040 GET oGetCPO VAR dZLD_DATAC		SIZE 050,009 OF oDlg PIXEL WHEN lALTER
		@ 033,120 SAY OemToAnsi("Nome Coletor: ") 	SIZE 050,009 OF oDlg PIXEL
		@ 032,160 GET oGetCPO VAR cZLD_COLETO PICTURE "@!"	SIZE 100,009 OF oDlg PIXEL WHEN lALTER

		@ 033,290 SAY OemToAnsi("Quantidade Condenada: ") 	SIZE 080,009 OF oDlg PIXEL
		@ 032,370 GET oGetCPO VAR nZLD_QTDCON PICTURE "@E 999,999,999.99"	SIZE 50,009 OF oDlg PIXEL WHEN lALTER


		@ 049,005 SAY OemToAnsi("Data Anแlise: ") 	SIZE 050,009 OF oDlg PIXEL
		@ 048,040 GET oGetCPO VAR dZLD_DATAN		SIZE 050,009 OF oDlg PIXEL WHEN lALTER
		@ 049,120 SAY OemToAnsi("Nome Analista: ") 	SIZE 050,009 OF oDlg PIXEL
		@ 048,160 GET oGetCPO VAR cZLD_ANALIS PICTURE "@!"	SIZE 100,009 OF oDlg PIXEL WHEN lALTER

		oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc,"U_LTM2LnOk()","AllwaysTrue", ,.T.)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| nOpcA:=1, Iif(U_LTM23TdOk(), oDlg:End(),nOpcA:=0)  } , {||oDlg:End()})

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza็ใo base de dados.                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := LTM2GRV( cEntidade, aRecZLD )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
		EndIf

	EndIf

	If ( __lSx8 )
		RollBackSx8()
	EndIf
	For nCntFor := 1 To Len(aTravas)
		dbSelectArea(aTravas[nCntFor][1])
		dbGoto(aTravas[nCntFor][2])
		MsUnLock()
	Next nCntFor

	RestArea( aArea )

Return(lGravou)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTM2LnOk   บAutor  ณRafael Parma     บ Data ณ  10/09/09     บฑฑ
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
User Function LTM2LnOk()
	*------------------------------*
	Local lRet := .T.

	Local nPPRD := aScan(aHeader,{|x| AllTrim(x[2])=="ZLD_PRODUT"})
	Local nPLOJ := aScan(aHeader,{|x| AllTrim(x[2])=="ZLD_LOJPRD"})
//Local nMaxFor   := Len(aCols)
//Local nUsado    := Len(aHeader)
//Local lTestaDel := nUsado <> Len(aCols[1])

	/*
	For nI := 1 to Len(aCols)              
		// verifica se existe registro duplicado
		If !aCols[nI][nUsado+1]
			If n != nI .and. aCols[nI,nPPRD]+aCols[nI,nPLOJ] == aCols[n,nPPRD]+aCols[n,nPLOJ]
				MsgAlert("Anแlise jแ informada para este produtor nesta data!")
				lRet := .F.
				Exit
			EndIf                          
		EndIf	
	Next nI  
	*/

	If lRet
		If Posicione("SA2",1,xFilial("SA2")+aCols[n,nPPRD]+aCols[n,nPLOJ],"A2_X_LINHA") != ZL7->ZL7_LINHA
			MsgAlert("Este produtor nใo pertence a esta linha de coleta!")
			lRet := .F.
		EndIf
	EndIf

Return (lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTM23TdOk   บAutor  ณRafael Parma     บ Data ณ  10/09/09    บฑฑ
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
User Function LTM23TdOk()
	*------------------------------*
	Local lRet := .T.
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTC6GRV  บAutor  ณRafael Parma         บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para grava็ใo dos dados.                    ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

	*-------------------------------------------------------------*
Static Function LTM2GRV( cEntidade, aRecZLD, lExclui )
	*-------------------------------------------------------------*
	Local cSeekZLD  := ""
	Local lGravou   := .F.
	Local nLoop     := 0
	Local nLoop2    := 0

	DEFAULT lExclui := .F.

	If lExclui

		cSeekZLD := xFilial( cEntidade ) + ZL7->ZL7_COD
		(cEntidade)->( dbSetOrder(1) )
		If (cEntidade)->( dbSeek( cSeekZLD ) )
			lGravou := .T.
			While !(cEntidade)->( EOF() ) .And. cSeekZLD == ZLD->(ZLD_FILIAL+ZLD_CODMOV)
				RecLock( cEntidade, .F. )
				(cEntidade)->( dbDelete() )
				(cEntidade)->( MsUnLock() )
				(cEntidade)->( dbSkip() )
			EndDo
		EndIf

	Else

		For nLoop := 1 To Len( aCols )
			lGravou := .T.
			If GDDeleted( nLoop )
				If nLoop <= Len( aRecZLD )
					(cEntidade)->( MsGoto( aRecZLD[ nLoop ] ) )
					RecLock( cEntidade, .F. )
					(cEntidade)->( dbDelete() )
					(cEntidade)->( MsUnlock() )
				EndIf
			Else
				If nLoop <= Len( aRecZLD )
					(cEntidade)->( MsGoto( aRecZLD[ nLoop ] ) )

					RecLock( cEntidade, .F. )
					ZLD->ZLD_FILIAL := xFilial( cEntidade )
					ZLD->ZLD_CODMOV := ZL7->ZL7_COD
					ZLD->ZLD_DATCOL := M->dZLD_DATAC
					ZLD->ZLD_DATANA := M->dZLD_DATAN
					ZLD->ZLD_COLETO := M->cZLD_COLETO
					ZLD->ZLD_ANALIS := M->cZLD_ANALIS
					ZLD->ZLD_QTDCON := M->nZLD_QTDCON

				Else
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Inclui e grava os campos chave                                         ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

					RecLock( cEntidade, .T. )
					ZLD->ZLD_FILIAL := xFilial( cEntidade )
					ZLD->ZLD_CODMOV := ZL7->ZL7_COD
					ZLD->ZLD_DATCOL := M->dZLD_DATAC
					ZLD->ZLD_DATANA := M->dZLD_DATAN
					ZLD->ZLD_COLETO := M->cZLD_COLETO
					ZLD->ZLD_ANALIS := M->cZLD_ANALIS
					ZLD->ZLD_QTDCON := M->nZLD_QTDCON

				EndIf

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Grava os demais campos                                                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				For nLoop2 := 1 To Len( aHeader )
					If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "ZLD_FILIAL|ZLD_CODMOV|ZLD_DATCOL|ZLD_DATANA|ZLD_COLETO|ZLD_ANALIS" )
						ZLD->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
					EndIf
				Next nLoop2
				ZLD->( MsUnlock() )
			EndIf
		Next nLoop
	EndIf

Return( lGravou )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV2TQ  บAutor  ณRafael Parma       บ Data ณ  27/05/11    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de anแlises de tanques.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*----------------------------------------------*
User Function LTMOV2TQ( cAlias, nReg, nOpc )
	*----------------------------------------------*
	Local aArea        := GetArea()
	Local aPosObj      := {}
	Local aObjects     := {}
	Local aSize        := MsAdvSize( .F. )
//Local aGet         := {}
	Local aTravas      := {}
//Local aEntidade    := {}
	Local aRecZLH      := {}
//Local aChave       := {}

	Local cSeekZLH     := ""
	Local cEntidade    := "ZLH"

	Local lGravou      := .F.
	Local lTravas      := .T.

	Local nCntFor      := 0
	Local nUsado       := 0
//Local nPosUser     := 0
	Local nOpcA        := 0
//Local nScan        := 0
//Local nLoop        := 0

	Local oDlg
	Local oGetD
	Local oGetCPO

	PRIVATE lALTER     := .T.
	PRIVATE aCols      := {}
	PRIVATE aHeader    := {}

	nOpc := 4

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona a entidade                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cEntidade)
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("ZLH") + ZL7->ZL7_COD )
		dZLH_DATA   := ZLH->ZLH_DATA
		cZLH_LINHA  := ZLH->ZLH_LINHA
		cZLH_NOMLIN := ZL7->ZL7_NOMLIN
		cZLH_ANALIS := ZLH->ZLH_ANALIS
	Else
		dZLH_DATA   := ZL7->ZL7_DATA
		cZLH_LINHA  := ZL7->ZL7_LINHA
		cZLH_NOMLIN := ZL7->ZL7_NOMLIN
		cZLH_ANALIS := Space(TAMSX3("ZLH_ANALIS")[1])
	EndIf

	SX2->( dbSetOrder( 1 ) )
	SX2->( dbSeek( cEntidade ) )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeader                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidade)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidade )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "ZLH_FILIAL|ZLH_CODVAZ|ZLH_LINHA|ZLH_DATA|ZLH_ANALIS" )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf

		SX3->( dbSkip() )
	EndDo


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cEntidade)
	dbSetOrder(1)
	(cEntidade)->(dbGoTop())

	cSeekZLH := xFilial( cEntidade ) + ZL7->ZL7_COD
	If (cEntidade)->( MsSeek( cSeekZLH ) )
		While ( !Eof() .And. cSeekZLH == ZLH->(ZLH_FILIAL+ZLH_CODVAZ)  )

			If ( SoftLock(cEntidade ) )
				AAdd(aTravas,{ Alias() , RecNo() })
				AAdd(aCols,Array(nUsado+1))
				AAdd(aRecZLH, (cEntidade)->( Recno() ) )
				For nCntFor := 1 To nUsado
					If ( aHeader[nCntFor][10] != "V" )
						aCols[Len(aCols)][nCntFor] := ZLH->(FieldGet(FieldPos(aHeader[nCntFor][2])))
					Else
						aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
					EndIf
				Next
				aCols[Len(aCols)][nUsado+1] := .F.
			Else
				lTravas := .F.
			EndIf
			(cEntidade)->( dbSkip()   )
		EndDo
	EndIf


	If Empty( aCols )
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[1][nUsado+1] := .F.

	EndIf

	If ( lTravas )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณJanela de manuten็ใo                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		AAdd( aObjects, { 100,  54, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 017,005 SAY OemToAnsi("Linha: ") 	   		SIZE 050,009 OF oDlg PIXEL
		@ 016,040 GET oGetCPO VAR ZL7->ZL7_LINHA 	SIZE 050,009 OF oDlg PIXEL WHEN .F.
		@ 016,100 GET oGetCPO VAR ZL7->ZL7_NOMLIN 	SIZE 100,009 OF oDlg PIXEL WHEN .F.
		@ 017,220 SAY OemToAnsi("Transportador: ")	SIZE 050,009 OF oDlg PIXEL
		@ 016,260 GET oGetCPO VAR ZL7->ZL7_TRANSP 	SIZE 050,009 OF oDlg PIXEL WHEN .F.
		@ 016,320 GET oGetCPO VAR ZL7->ZL7_NOMTRP 	SIZE 100,009 OF oDlg PIXEL WHEN .F.

		@ 033,005 SAY OemToAnsi("Data Anแlise: ") 	SIZE 050,009 OF oDlg PIXEL
		@ 032,040 GET oGetCPO VAR dZLH_DATA 		SIZE 050,009 OF oDlg PIXEL WHEN lALTER
		@ 033,130 SAY OemToAnsi("Nome Analista: ") 	SIZE 050,009 OF oDlg PIXEL
		@ 032,170 GET oGetCPO VAR cZLH_ANALIS 		PICTURE "@!"	SIZE 100,009 OF oDlg PIXEL WHEN lALTER

		oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc,"U_LTM2ZLHnOk()","AllwaysTrue", ,.T.)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| nOpcA:=1, Iif(U_LTM2TdOk(), oDlg:End(),nOpcA:=0)  } , {||oDlg:End()})

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza็ใo base de dados.                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := LTM2LHGRV( cEntidade, aRecZLH )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
		EndIf

	EndIf

	If ( __lSx8 )
		RollBackSx8()
	EndIf
	For nCntFor := 1 To Len(aTravas)
		dbSelectArea(aTravas[nCntFor][1])
		dbGoto(aTravas[nCntFor][2])
		MsUnLock()
	Next nCntFor

	RestArea( aArea )

Return(lGravou)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTM2LnOk   บAutor  ณRafael Parma     บ Data ณ  10/09/09     บฑฑ
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
User Function LTM2ZLHnOk()
	*------------------------------*
	Local lRet := .T.
	Local nI
	Local nTANQUE   := aScan(aHeader,{|x| AllTrim(x[2])=="ZLH_TANQUE"})
//Local nMaxFor   := Len(aCols)
	Local nUsado    := Len(aHeader)
//Local lTestaDel := nUsado <> Len(aCols[1])

	For nI := 1 to Len(aCols)
		// verifica se existe registro duplicado
		If !aCols[nI][nUsado+1]
			If n != nI .and. aCols[nI,nTANQUE] == aCols[n,nTANQUE]
				MsgAlert("C๓digo de tanque jแ informado!")
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next nI


Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTM23TdOk   บAutor  ณRafael Parma     บ Data ณ  27/05/11    บฑฑ
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
User Function LTM2TdOk()
	*------------------------------*
	Local lRet := .T.
Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTMOV2VD    บAutor  ณRafael Parma     บ Data ณ  27/05/11    บฑฑ
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
User Function LTMOV2VD()
	*------------------------------*
	Local lRet := .T.
	//--Validacao do perํodo
	dDATA := IIf(Type("M->ZL7_DATA")!="U",M->ZL7_DATA,ZL7->ZL7_DATA)
	dbSelectArea("ZLC")
	dbSetOrder(1)
	If dbSeek( xFilial("ZLC")+(cValToChar(Year(dDATA))+STRZero(Month(dDATA),2)+"01") )
		If ZLC->ZLC_STATUS == "F"
			U_LTALL001("Aten็ใo", "O perํodo deste movimento esta fechado.","Verifique o cadastro de perํodos.")
			lRet := .F.
		EndIf
	Else
		U_LTALL001("Aten็ใo", "Nใo existe perํodo de movimento para lan็amento.","Verifique o cadastro de perํodos.")
		lRet := .F.
	EndIf

Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLTM2LHGRVบAutor  ณRafael Parma         บ Data ณ  27/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para grava็ใo dos dados.                    ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

	*-------------------------------------------------------------*
Static Function LTM2LHGRV( cEntidade, aRecZLH, lExclui )
	*-------------------------------------------------------------*
	Local cSeekZLH  := ""
	Local lGravou   := .F.
	Local nLoop     := 0
	Local nLoop2    := 0

	DEFAULT lExclui := .F.

	If lExclui

		cSeekZLH := xFilial( cEntidade ) + ZL7->ZL7_COD
		(cEntidade)->( dbSetOrder(1) )
		If (cEntidade)->( dbSeek( cSeekZLH ) )
			lGravou := .T.
			While !(cEntidade)->( EOF() ) .And. cSeekZLH == ZLH->(ZLH_FILIAL+ZLH_CODVAZ)
				RecLock( cEntidade, .F. )
				(cEntidade)->( dbDelete() )
				(cEntidade)->( MsUnLock() )
				(cEntidade)->( dbSkip() )
			EndDo
		EndIf

	Else

		For nLoop := 1 To Len( aCols )
			lGravou := .T.
			If GDDeleted( nLoop )
				If nLoop <= Len( aRecZLH )
					(cEntidade)->( MsGoto( aRecZLH[ nLoop ] ) )
					RecLock( cEntidade, .F. )
					(cEntidade)->( dbDelete() )
					(cEntidade)->( MsUnlock() )
				EndIf
			Else
				If nLoop <= Len( aRecZLH )
					(cEntidade)->( MsGoto( aRecZLH[ nLoop ] ) )

					RecLock( cEntidade, .F. )
					ZLH->ZLH_FILIAL := xFilial( cEntidade )
					ZLH->ZLH_CODVAZ := ZL7->ZL7_COD
					ZLH->ZLH_LINHA  := M->cZLH_LINHA
					ZLH->ZLH_DATA   := M->dZLH_DATA
					ZLH->ZLH_ANALIS := M->cZLH_ANALIS

				Else
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Inclui e grava os campos chave                                         ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

					RecLock( cEntidade, .T. )
					ZLH->ZLH_FILIAL := xFilial( cEntidade )
					ZLH->ZLH_CODVAZ := ZL7->ZL7_COD
					ZLH->ZLH_LINHA  := M->cZLH_LINHA
					ZLH->ZLH_DATA   := M->dZLH_DATA
					ZLH->ZLH_ANALIS := M->cZLH_ANALIS

				EndIf

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Grava os demais campos                                                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				For nLoop2 := 1 To Len( aHeader )
					If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "ZLH_FILIAL|ZLH_CODVAZ|ZLH_LINHA|ZLH_DATA|ZLH_ANALIS" )
						ZLH->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
					EndIf
				Next nLoop2
				ZLH->( MsUnlock() )
			EndIf
		Next nLoop
	EndIf

Return( lGravou )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSendWF    บAutor  ณRafael Parma       บ Data ณ  13/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para enviar workflow na altera็ใo do movimento do    บฑฑ
ฑฑบ          ณtransportador.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*----------------------------------*
Static Function fSendWF()
*----------------------------------*
/*Local aArea := GetArea()
Local cEmailWF := ""
Local oProcess

    CONOUT("WFAMOVTRP - INICIO DA EXECUวรO")
	
	cEmailWF := SuperGetMV("MV_ZL7EW",,"")
	
	If ALLTRIM(cEmailWF) == ""
		Return
	Endif

	oProcess := TWFProcess():New( "WFAMOVTRP", "ALTERAวรO DO MOVIMENTO DO TRANSPORTADOR")
	oProcess:NewTask( "WFPCAVISO", "\workflow\wfamovtrp.html")
	
	oProcess:cSubject :=  "WF - AVISO - ALTERAวรO DO MOVIMENTO DO TRANSPORTADOR" 
							
	oHTML := oProcess:oHTML
	                                        
	CODLINH := ZL7->ZL7_LINHA + "-" + ALLTRIM(Posicione("ZL0",1,xFilial("ZL0")+ZL7->ZL7_LINHA,"ZL0_DESC"))
	CODTRAN := ZL7->ZL7_TRANSP + "-" + ALLTRIM(Posicione("SA4",1,xFilial("SA4")+ZL7->ZL7_TRANSP,"A4_NOME"))
	
	oHtml:ValByName("CFILIAL", SM0->M0_NOME					) 
	oHtml:ValByName("CNUMMOV", ZL7->ZL7_COD					)
	oHtml:ValByName("DDATABA", ZL7->ZL7_DATA 				)
	oHtml:ValByName("CODLINH", CODLINH		 				)
	oHtml:ValByName("CODTRAN", CODTRAN		 				)		
	oHtml:ValByName("CUSUARI", ALLTRIM(UPPER(CUSERNAME))	)

	oProcess:cTo  := LOWER(cEmailWF) 
	
	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
    
	CONOUT("WFAMOVTRP - FIM DA EXECUวรO")

	RestArea(aArea)
      
Return */
