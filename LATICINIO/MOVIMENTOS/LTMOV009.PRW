#include "topconn.ch"
#include "protheus.ch"
#include "msgraphi.ch"
#include "msserial.ch"
#include "eicconst.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV009  ºAutor  ³Marcelo Joner       º Data ³  10/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de registro de pesagem de veículos.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV009()

	Local cAliasH	  	:= "ZM1"
	Local cUsrQld		:= GETMV("MV_ZL00008",, "")
	Local nX
	Private cCadastro	:= "Pesagens"
	Private aRotina		:= MENUDEF()
	Private aCores		:= {{"ZM1_STATUS == '1'", 'BR_VERDE'	, "Pesagem - Em Aberto"	},;
		{"ZM1_STATUS == '2'", 'BR_VERMELHO'	, "Pesagem - Finalizada"},;
		{"ZM1_STATUS == '9'", 'BR_PRETO'	, "Pesagem - Cancelada"	}}

	Private aCoresCon		:= {{"ZM1_STATUS == '1'", 'BR_VERDE'	, "Pesagem - Em Aberto"	},;
		{"(ZM1_STATUS == '2' .AND. ZM1_SITQLD == ' ') .OR. (ZM1_STATUS == '2' .AND. ZM1_SITCON == 'F'  .AND. ZM1_SITQLD == 'F' .AND. ZM1_FATCON > 0)"					, 'BR_VERMELHO'	, "Pesagem - Finalizada"},;
		{"(ZM1_STATUS == '2' .AND. ZM1_SITQLD == ' ') .OR. (ZM1_STATUS == '2' .AND. ZM1_SITCON != 'F'  .AND. ZM1_SITQLD != 'F')"					, 'BR_AZUL'		, "Analises Pendentes"},;
		{"ZM1_STATUS $ '1/2' .AND. ZM1_SITQLD == 'F' .AND. ZM1_SITCON == 'P' .AND. ZM1_STPROT <> 'P' .AND. ZM1_FATCON > 0 .AND. ZM1_PRCSOL == 0 .AND. ZM1_SLLT <> 0"   	, 'TABPRICE'		, "Sem Preço de Solidos"	},;
		{"ZM1_STATUS $ '1/2' .AND. ZM1_SITQLD == 'F' .AND. ZM1_SITCON == 'P' .AND. ZM1_STPROT <> 'P' "  											, 'BR_VIOLETA'		, "Conciliação Pendente"	},;
		{"ZM1_STATUS $ '1/2' .AND. ZM1_SITQLD == 'F' .AND. ZM1_SITCON == 'F' .AND. ZM1_STPROT <> 'P' .AND. ZM1_FATCON = 0"  						, 'PMSRRFSH'		, "Re-Conciliação Pendente"	},;
		{"ZM1_STATUS == '9'", 'BR_PRETO'	, "Pesagem - Cancelada"	}}

	Private aCoresQld	:= {{"ZM1_STATUS == '1'  .AND. ZM1_SITQLD != 'F' .AND. EMPTY(ZM1_STPROT)"							, 'BR_AMARELO'		, "Pesagem - Em Aberto"		},;
		{"ZM1_STATUS != '9'  .AND. ZM1_SITQLD == ' '"													, 'BR_MARRON_OCEAN'	, "Pesagem - Finalizada"	},;
		{"ZM1_STATUS == '9'"																			, 'BR_CANCEL'		, "Pesagem - Cancelada"		},;
		{"ZM1_STATUS == '2'  .AND. ZM1_SITQLD != 'F' .AND. EMPTY(ZM1_STPROT)"							, 'BR_VERDE'		, "Qualidade - Em Aberto"	},;
		{"ZM1_STATUS $ '1/2' .AND. ZM1_SITQLD == 'E' .AND. ZM1_SITCON <> 'P'"							, 'BR_AZUL'	 		, "Qualidade - Em Execução"	},;
		{"ZM1_STATUS $ '1/2' .AND. !EMPTY(ZM1_STPROT) .AND. ZM1_STPROT <> 'F' "	, 'UPDWARNING'			, "Qualidade - Aguardando Protocolo"},;
		{"ZM1_STATUS $ '1/2' .AND. ZM1_SITQLD == 'F' .AND. ZM1_SITCON == 'P' .AND. ZM1_STPROT <> 'P' .AND. ZM1_FATCON == 0" 	, 'BR_VIOLETA'		, "Qualidade - Finalizada"	},;
		{"ZM1_STATUS == '2'  .AND. ZM1_SITQLD == 'F' .AND. ( ZM1_SITCON == 'F' .OR. ZM1_SITCON == 'P') .AND. ZM1_FATCON > 0"						, 'BR_VERMELHO'		, "Conciliação - Efetuada"}}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Seta tecla F12 como tecla para executar função de remoção da balança configurada para integração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	SetKey(VK_F12, {|| LT019BLKILL()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Apresentação do browse da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oMBrowse := FWMBrowse():New()
	oMBrowse:SetAlias(cAliasH)
	oMBrowse:SetDescription(cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona definições de legenda caso o usuário possui permissão do processo de Qualidade³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If __cUserId $ cUsrQld
		For nX := 1 To Len(aCoresQld)
			oMBrowse:AddLegend(aCoresQld[nX][1], aCoresQld[nX][2], aCoresQld[nX][3])
		Next nX
	ElseIf __cUserId $ SuperGetMV("MX_PRECCON",,"")
		For nX := 1 To Len(aCoresCon)
			oMBrowse:AddLegend(aCoresCon[nX][1], aCoresCon[nX][2], aCoresCon[nX][3])
		Next nX
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Atualiza definições de legenda quando o usuário não possui permissão para o processo de Qualidade³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		For nX := 1 To Len(aCores)
			oMBrowse:AddLegend(aCores[nX][1], aCores[nX][2], aCores[nX][3])
		Next nX
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona definições de visões³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oMBrowse:SetAttach(.T.)
	oMBrowse:SetOpenChart(.F.)
	oTableAtt := LT009VIEW()
	oMBrowse:SetViewsDefault(oTableAtt:aViews)
	oMBrowse:SetChartsDefault(oTableAtt:aCharts)
	oMBrowse:Activate()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha a tabela manipulada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If Select(cAliasH) > 0
		(cAliasH)->(dBCloseArea())
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Remove vinculo de funções com algumas teclas especificas para com a rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ   
	SET KEY VK_F12 TO

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT009VIEW  ºAutor  ³Marcelo Joner       º Data ³ 12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela definição de visões e gráficos no   º±±
±±º          ³browse da rotina de pesagens.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT009VIEW()

	Local oTableAtt	:= FWTableAtt():New()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Pesagem - Em Aberto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oPesAbe := FWDSView():New()
	oPesAbe:SetID("LT9V01")
	oPesAbe:SetName("Em Aberto")
	oPesAbe:SetPublic(.T.)
	oPesAbe:SetCollumns(U_GLCPOBRW("ZM1"))
	oPesAbe:SetOrder(1)
	oPesAbe:AddFilter("Pesagens - Em Aberto", "ZM1_STATUS == '1'")
	oTableAtt:AddView(oPesAbe)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Pesagem - Finalizada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oPesFin := FWDSView():New()
	oPesFin:SetID("LT9V02")
	oPesFin:SetName("Finalizadas")
	oPesFin:SetPublic(.T.)
	oPesFin:SetCollumns(U_GLCPOBRW("ZM1"))
	oPesFin:SetOrder(1)
	oPesFin:AddFilter("Pesagens - Finalizadas", "ZM1_STATUS == '2'")
	oTableAtt:AddView(oPesFin)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Pesagem - Cancelada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oPesCan := FWDSView():New()
	oPesCan:SetID("LT9V03")
	oPesCan:SetName("Canceladas")
	oPesCan:SetPublic(.T.)
	oPesCan:SetCollumns(U_GLCPOBRW("ZM1"))
	oPesCan:SetOrder(1)
	oPesCan:AddFilter("Pesagens - Canceladas", "ZM1_STATUS == '9'")
	oTableAtt:AddView(oPesCan)

	oTableAtt:SetAlias("ZM1")

Return oTableAtt





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MENUDEF   ºAutor  ³Marcelo Joner       º Data ³  10/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição das sub-rotinas da rotina principal               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MENUDEF()

	Local aRotina	:= {{"&Pesquisar"				, "AxPesqui"	, 0 , 1},;
		{"&Visualizar"				, "U_LT019VIS"	, 0 , 2},;
		{"&Abrir"					, "U_LT019ABE"	, 0 , 3},;
		{"&Fechar"					, "U_LT019FEC"	, 0 , 4},;
		{"Al&terar"					, "U_LT019ALT"	, 0 , 4},;
		{"&Cancelar"				, "U_LT019CAN"	, 0 , 2},;
		{"&Descarte"				, "U_LT019DES"	, 0 , 2},;
		{"&New Qualidade "			, "U_LTMOV9D"	, 0 , 4},;
		{"&Analise por Produtor "	, "U_LTMOV9E"	, 0 , 4},;
		{"&Libera Descarregamento "	, "U_LT9FIN2"	, 0 , 4},;
		{"&Abertura de RNC "		, "U_LTMOV9F"	, 0 , 4},;
		{"C&onciliação"				, "U_LT019CON"	, 0 , 4},;
		{"&Imprime Matric"			, "U_LT019IMP"	, 0 , 6},;
		{"&Imprime Laser"			, "U_LTREL047"	, 0 , 6},;
		{"&Legenda"					, "U_LT019LEG"	, 0 , 2}}

Return aRotina
//{"&Qualidade"				, "U_LT019QUA"	, 0 , 4},;




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019LEG   ºAutor  ³Marcelo Joner      º Data ³  14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsavel pela apresentacao da tela referente as   º±±
±±º          ³definições de legenda da rotina de pesagens.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019LEG()

	Local nI		:= 0
	Local aLegenda	:= {}
	Local oLegenda	:= FWLegend():New()
	Local cUsrQld	:= GETMV("MV_ZL00008",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Compõe array com as legendas padrões da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If __cUserId $ cUsrQld
		For nI := 1 To Len(aCoresQld)
			AADD(aLegenda, {aCoresQld[nI][2],aCoresQld[nI][3]})
		Next nI
	Else
		For nI := 1 To Len(aCores)
			AADD(aLegenda, {aCores[nI][2],aCores[nI][3]})
		Next nI
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona legendas para apresentação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	For nI := 1 To Len(aLegenda)
		oLegenda:Add("",aLegenda[nI][1], aLegenda[nI][2])
	Next nI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Apresenta legenda ao usuário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oLegenda:Activate()
	oLegenda:View()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019VIS   ºAutor  ³Marcelo Joner      º Data ³  11/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela funcionalidade de visualização do   º±±
±±º          ³registro de pesagem.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019VIS(cAlias, nReg, nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função de apresentação da interface de pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	LT019DET(cAlias, nReg, nOpc)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019ABE   ºAutor  ³Marcelo Joner      º Data ³  11/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela funcionalidade de abertura de novas º±±
±±º          ³pesagens.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019ABE(cAlias, nReg, nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função de apresentação da interface de pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	LT019DET(cAlias, nReg, nOpc)

	MBrChgLoop(.F.)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019FEC   ºAutor  ³Marcelo Joner      º Data ³  14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela funcionalidade de fechamento das    º±±
±±º          ³pesagens existentes na rotina.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019FEC(cAlias, nReg, nOpc)
	Local lAchou	:= .F.
	Local _lProt	:= .F. // indica se pesagem precisa de protocolo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se à pesagem posicionada realmente está em aberto,³
//³caso contrario, alerta o usuario e não permite o fechamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	If ZM3->(dbSeek(xFilial("ZM3") + ZM1->ZM1_NUM))
		While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == ZM1->ZM1_NUM
			If ZM3->ZM3_STATUS == "D"
				If !EMPTY(ZM3->ZM3_USRDES)
					lAchou := .F.
					exit
				Else
					lAchou := .T.
				EndIf
			EndIf
			ZM3->(dbSkip())
		End
	Else // Processo novo de qualidade, mantido o processo antigo para compatibilidade
		dbSelectArea('ZM4')
		ZM4->(dbSetOrder(1))
		ZM4->(dbGoTop())
		If ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
			While ZM4->(!Eof()) .And. ZM4->ZM4_FILIAL == xFilial("ZM4") .AND. ZM4->ZM4_NUM == ZM1->ZM1_NUM
				If ZM4->ZM4_STATUS == "D"
					If !EMPTY(ZM1->ZM1_USRDES)
						lAchou := .F.
						exit
					Else
						lAchou := .T.
					EndIf
				ElseIf ZM4->ZM4_STATUS == 'P'
					_lProt := .t.
				EndIf

				ZM4->(DbSkip())
			EndDo
		EndIf
	EndIf

	If ZM1->ZM1_STATUS != "1"
		If ZM1->ZM1_STATUS == "2"
			U_GLALL001("Atenção", "A pesagem selecionada para fechamento já está finalizada.", "Somente é possível efetuar o fechamento de pesagens que estejam em aberto.")
		EndIf

		If ZM1->ZM1_STATUS == "9"
			U_GLALL001("Atenção", "A pesagem selecionada para fechamento está cancelada.", "Não é possivel fechar pesagens que estejam canceladas.")
		EndIf

		Return
	Else
		If lAchou
			U_GLALL001("Atenção", "A pesagem selecionada para fechamento possui DESCARTE", "Utilize a Rotina de Descarte ou Contate o Laboratório!")
		Else
			If EMPTY(ZM1->ZM1_STPROT)
				If ZM1->ZM1_LIBPRO <> 'S' .and. _lProt
					U_GLALL001("Atenção", "Protocolo necessário!", "Utilize a Rotina de Liberação para Descarregamento ou abra um Protocolo!")
					Return
				EndIf
			ElseIf ZM1->ZM1_STPROT <> "F" .and. ZM1->ZM1_LIBPRO <> 'S'
				U_GLALL001("Atenção", "Protocolo ainda não aprovado!", "Execute os procedimentos para aprovação do protocolo ou utilize a rotina de Liberação para Descarregamento!")
				Return
			ElseIf ZM1->ZM1_STPROT == "F" .and. ZM1->ZM1_LIBPRO <> 'S'
				If Posicione("ZM8",1,xFilial("ZM8")+ZM1->ZM1_IDPROT,'ZM8_AVAL') <> 'A'
					U_GLALL001("Atenção", "Protocolo não aprovado!", "Utilize a rotina de Liberação para Descarregamento para em seguida descartar o tanque que gerou NFC!")
					Return
				EndIf
			EndIf

			// Djonata - 20210331
			// Inverte a gravação dos campos armazenados na rotina de descarte e fechamento, pois o processo é executado invertido,
			// primeiro é pesado o leite bom, mas grava nos campos de descarte, depois é pesado o descarte, mas grava nos campos do leite bom,
			// foi solicitado para não alterar a sequência desse processo

		/* If !Empty(ZM1->ZM1_USRDES)
			_nPesoIni := ZM1->ZM1_KGIDES
			_nPesoFim := ZM1->ZM1_KGFDES
			_nPDesIni := ZM1->ZM1_KGINI
			_nPDesFim := ZM1->ZM1_KGFIN
			RecLock('ZM1',.F.)
				ZM1->ZM1_KGIDES := _nPDesIni 
				ZM1->ZM1_KGFDES := _nPDesFim
				ZM1->ZM1_KGINI	:= _nPesoIni
				ZM1->ZM1_KGFIN	:= _nPesoFim
				ZM1->ZM1_KGBRT	:= _nPesoIni - _nPesoFim
			ZM1->(MsUnlock())
		EndIf */


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de apresentação da interface de pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If SOFTLOCK("ZM1")
			LT019DET(cAlias, nReg, nOpc)
		EndIf
	EndIf
EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019ALT   ºAutor  ³Marcelo Joner      º Data ³  14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela funcionalidade de alteração das     º±±
±±º          ³pesagens existentes na rotina.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019ALT(cAlias, nReg, nOpc)

	Local cUsrAlt	:= GETMV("MV_ZL00003",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa demais regras, caso o usuário possua permissão de alteração de pesagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If __cUserId $ cUsrAlt

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Permite alterar à pesagem caso esteja finalizada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ZM1->ZM1_SITCON == "F" .AND. ALLTRIM(ZM1->ZM1_PROD) == "01010001"
			U_GLALL001("Atenção", "A pesagem selecionada para alteração está conciliada.", "É necessário desfazer a conciliação antes de alterar.")
		Else

			If ZM1->ZM1_STATUS == "9"
			/*If ZM1->ZM1_STATUS == "1"
				U_GLALL001("Atenção", "A pesagem selecionada para alteração está em aberto.", "Somente é possível alterar pesagens que estejam finalizadas.")
			EndIf*/
			               
		//	If ZM1->ZM1_STATUS == "9"
				U_GLALL001("Atenção", "A pesagem selecionada para alteração está cancelada.", "Somente é possível alterar pesagens que estejam finalizadas.")
		//	EndIf
			
			Return
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de apresentação da interface de pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If SOFTLOCK("ZM1")
				LT019DET(cAlias, nReg, nOpc)
			EndIf
		EndIf
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Alerta o usuário em relação à permissão de utilização³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_GLALL001("Atenção", "O seu usuário não possui permissão para utilizar está funcionalidade.", "Favor verificar à questão com o departamento de TI.")	
EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019CAN   ºAutor  ³Marcelo Joner      º Data ³  14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela funcionalidade de cancelamento das  º±±
±±º          ³pesagens existentes na rotina.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019CAN(cAlias, nReg, nOpc)

	Local cUsrCan	:= GETMV("MV_ZL00004",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa demais regras, caso o usuário possua permissão de cancelamento de pesagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If __cUserId $ cUsrCan

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Permite cancelar à pesagem caso não esteja cancelada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ZM1->ZM1_STATUS == "9"
			U_GLALL001("Atenção", "A pesagem selecionada para cancelamento já está cancelada.", "Somente é possível cancelar pesagens que não estejam canceladas.")
			Return
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de apresentação da interface de pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If SOFTLOCK("ZM1")
				LT019DET(cAlias, nReg, nOpc)
			EndIf
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Alerta o usuário em relação à permissão de utilização³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		U_GLALL001("Atenção", "O seu usuário não possui permissão para utilizar está funcionalidade.", "Favor verificar à questão com o departamento de TI.")
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019DES  ºAutor  ³Marcelo Joner        º Data ³ 15/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela funcionalidade Descarte presente no º±±
±±º          ³browse da rotina de Pesagem.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019DES(cAlias, nReg, nOpc)

	Local lAchou	:= .F.
	Local cUsrDes	:= GETMV("MV_ZL00009",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Não permite utilizar funcionalidade se à pesagem não estiver em aberto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If ZM1->ZM1_STATUS != "1"
		U_GLALL001("Atenção", "A pesagem selecionada não encontra-se em aberto.", "O processo de descarte somente pode ser utilizado em pesagens que estejam em aberto.")
		Return
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa demais regras, caso o usuário possua permissão para utilizar o processo de descarte³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If __cUserId $ cUsrDes

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Verifica se existem análises de qualidade para à pesagem com o status DESCARTE³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("ZM3")
			ZM3->(dbSetOrder(1))
			ZM3->(dbGoTop())
			If ZM3->(dbSeek(xFilial("ZM3") + ZM1->ZM1_NUM))
				While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == ZM1->ZM1_NUM
					If ZM3->ZM3_STATUS == "D" .AND. EMPTY(ZM3->ZM3_USRDES)
						lAchou := .T.
						exit
					EndIf
					ZM3->(dbSkip())
				End
			EndIf

			// Djonata - 20210330
			// Verifico nas tabelas novas caso não tenha encontrado na antiga
			// mantive a antiga para compatibilidade com as pesagens já executadas
			If !lAchou
				dbSelectArea("ZM4")
				ZM4->(dbSetOrder(1))
				ZM4->(dbGoTop())
				If ZM4->(dbSeek(xFilial("ZM4") + ZM1->ZM1_NUM))
					While ZM4->(!EOF()) .AND. ZM4->ZM4_FILIAL == xFilial("ZM4") .AND. ZM4->ZM4_NUM == ZM1->ZM1_NUM
						If ZM4->ZM4_STATUS == "D" //.AND. EMPTY(ZM3->ZM3_USRDES)
							lAchou := .T.
							exit
						EndIf
						ZM4->(dbSkip())
					End
				EndIf

			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de apresentação da interface de pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If lAchou
				If SOFTLOCK("ZM1")
					LT019DET(cAlias, nReg, nOpc)
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Impede à utilização da funcionalidade, pois não existem ocorrências de descarte³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				U_GLALL001("Atenção", "Não existem ocorrências de descarte para está pesagem.", "Somente é possível utilizar este processo sob pesagens que possuam incidência de descarte de produto.")
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Alerta o usuário em relação à permissão de utilização³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			U_GLALL001("Atenção", "O seu usuário não possui permissão para utilizar está funcionalidade.", "Favor verificar à questão com o departamento de TI.")
		EndIf
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019QUA  ºAutor  ³Marcelo Joner        º Data ³ 15/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por disponibilizar acesso à funcionalida-º±±
±±º          ³de de registro das análises de qualidade.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019QUA(cAlias, nReg, nOpc)

	Local lExeQlq	:= .F.
	Local cUsrQld	:= GETMV("MV_ZL00008",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se o usuário tem permissão para utilizar à funcionalidade Qualidade³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If __cUserId $ cUsrQld
		lExeQlq := .T.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Permite cancelar à pesagem caso não esteja cancelada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If ZM1->ZM1_STATUS == "9"
		U_GLALL001("Atenção", "A pesagem selecionada para registro de análise de qualidade está cancelada.", "Somente é possível utilizar pesagens que não estejam canceladas.")
		Return
	ElseIf ZM1->ZM1_DATA > sToD('20210331')
		U_GLALL001("Atenção", "Rotina inválida.", "Utilizar a nova rotina de pesagem.")
		Return
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de apresentação da interface de pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If SOFTLOCK("ZM1")
			U_LT019QLD(cAlias, nReg, nOpc, lExeQlq)
		EndIf
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019CON  ºAutor  ³Marcelo Joner        º Data ³ 28/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por disponibilizar acesso à funcionalida-º±±
±±º          ³de referente à conciliação da pesagem.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019CON(cAlias, nReg, nOpc)

	Local lExeCon	:= .F.
	Local cUsrCon	:= GETMV("MV_ZL00010",, "")
	Local cUsrAlt	:= GETMV("MV_ZL00003",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se o usuário tem permissão para utilizar à funcionalidade Conciliação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If __cUserId $ cUsrCon
		lExeCon := .T.
	EndIf

	If !(__cUserId $ cUsrAlt) .AND. ZM1->ZM1_SITCON == "F"
		lExeCon := .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função caso à pesagem posicionada esteja fechada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If ZM1->ZM1_STATUS == "2"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de apresentação da interface de vinculo de coletas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If SOFTLOCK("ZM1")
			U_LT019TRP(cAlias, nReg, nOpc, lExeCon)
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Alerta o usuário pois à pesagem não pode ser utilizada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		U_GLALL001("Atenção", "A pesagem selecionada para conciliação não encontra-se finalizada.", "Somente é possível utilizar pesagens que estejam finalizadas.")
		Return
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019IMP  ºAutor  ³Marcelo Joner        º Data ³ 17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução da rotina de impressão do  º±±
±±º          ³ticket de pesagem sob o registro posicionado no browse.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019IMP(cAlias, nReg, nOpc)

	Do Case
	Case ZM1->ZM1_STATUS == "1"
		U_GLALL001("Atenção", "A pesagem selecionada para impressão está em aberto.", "Somente é possível imprimir pesagens que estejam finalizadas.")
		Return

	Case ZM1->ZM1_STATUS == "9"
		U_GLALL001("Atenção", "A pesagem selecionada para impressão está cancelada.", "Somente é possível imprimir pesagens que estejam finalizadas.")
		Return

	OtherWise
		U_LTREL038()
	EndCase

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019DET  ºAutor  ³Marcelo Joner        º Data ³ 12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela disponibilização da interface ao    º±±
±±º          ³usuário em torno das principais funcionalidades da rotina.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019DET(cAlias, nReg, nOpc)

	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aBotoes		:= {}
	Local aCpoCab		:= {}
	Local aAltCab		:= {}
	Local aCpoLog		:= {}
	Local aAltLog		:= {}
	Local aCpoCod		:= {}
	Local aAltCod		:= {}
	Local aCpoPes		:= {}
	Local aAltPes		:= {}
	Local aStrZM3		:= {{"OK"			, "C", 02						, 0},;
		{"ZM3_TANQUE"	, "C", TAMSX3("ZM3_TANQUE")[1]	, 0},;
		{"ZM3_DTANA"	, "D", TAMSX3("ZM3_DTANA")[1]	, 0},;
		{"ZM3_HRANA"	, "C", TAMSX3("ZM3_HRANA")[1]	, 0},;
		{"ZM3_NOMANA"	, "C", TAMSX3("ZM3_NOMANA")[1]	, 0},;
		{"ZM3_KGANT"	, "N", TAMSX3("ZM3_KGANT")[1]	, 0},;
		{"ZM3_KGPOS"	, "N", TAMSX3("ZM3_KGPOS")[1]	, 0},;
		{"ZM3_DTDES"	, "D", TAMSX3("ZM3_DTDES")[1]	, 0},;
		{"ZM3_HRDES"	, "C", TAMSX3("ZM3_HRDES")[1]	, 0},;
		{"ZM3_USRDES"	, "C", TAMSX3("ZM3_USRDES")[1]	, 0},;
		{"ZM3_NOMDES"	, "C", TAMSX3("ZM3_NOMDES")[1]	, 0},;
		{"ZM3_STATUS"	, "C", 10						, 0}}

	Local aVwQLD		:= {{"OK"			, "",""								, "@!"							},;
		{"ZM3_TANQUE"	, "", U_LTALLXSX3("ZM3_TANQUE")[1]	, U_LTALLXSX3("ZM3_TANQUE")[6]	},;
		{"ZM3_DTANA"	, "", U_LTALLXSX3("ZM3_DTANA")[1]	, U_LTALLXSX3("ZM3_DTANA")[6]	},;
		{"ZM3_HRANA"	, "", U_LTALLXSX3("ZM3_HRANA")[1]	, U_LTALLXSX3("ZM3_HRANA")[6]	},;
		{"ZM3_NOMANA"	, "", U_LTALLXSX3("ZM3_NOMANA")[1]	, U_LTALLXSX3("ZM3_NOMANA")[6]	},;
		{"ZM3_KGANT"	, "", U_LTALLXSX3("ZM3_KGANT")[1]	, U_LTALLXSX3("ZM3_KGANT")[6]	},;
		{"ZM3_KGPOS"	, "", U_LTALLXSX3("ZM3_KGPOS")[1]	, U_LTALLXSX3("ZM3_KGPOS")[6]	},;
		{"ZM3_DTDES"	, "", U_LTALLXSX3("ZM3_DTDES")[1]	, U_LTALLXSX3("ZM3_DTDES")[6]	},;
		{"ZM3_HRDES"	, "", U_LTALLXSX3("ZM3_HRDES")[1]	, U_LTALLXSX3("ZM3_HRDES")[6]	},;
		{"ZM3_NOMDES"	, "", U_LTALLXSX3("ZM3_NOMDES")[1]	, U_LTALLXSX3("ZM3_NOMDES")[6]	},;
		{"ZM3_STATUS"	, "", U_LTALLXSX3("ZM3_STATUS")[1]	, U_LTALLXSX3("ZM3_STATUS")[6]	}}

	Local nOpcao		:= 0
//Local nModelo		:= 3
	Local nRecZM1		:= ZM1->(RECNO())
	Local lF3			:= .F.
	Local lColumn		:= .F.
	Local lMemoria		:= .T.
	Local lNoFolder		:= .T.
	Local lProperty		:= .F.
	Local lPesMan		:= GETMV("MV_ZL00001",, .F.)
	Local lPesPsw		:= !lPesMan .AND. (ISINCALLSTACK("U_LT019ABE") .OR. ISINCALLSTACK("U_LT019FEC") .OR. ISINCALLSTACK("U_LT019ALT"))
	Local nX
	Private aGets[0]
	Private aGets1[0]
	Private aGets2[0]
	Private aGets3[0]
	Private aTela[0][0]
	Private aTela1[0][0]
	Private aTela2[0][0]
	Private aTela3[0][0]
	Private aTrocaF3 	:= {}

	Private lPeso		:= .F.
	Private lInverte	:= .F.
	Private lDescarte	:= ISINCALLSTACK("U_LT019DES")
	Private cMarca		:= GetMark()
	Private bCampo		:= {|nCPO| Field(nCPO)}
	Private cAliasQLD	:= GetNextAlias()

	Private VISUAL		:= IIF(nOpc == 2, .T., .F.)
	Private INCLUI		:= IIF(nOpc == 3, .T., .F.)
	Private ALTERA		:= IIF(nOpc == 4, .T., .F.)
	Private DELETA		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta arrays com estruturas para MsMGet³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aCpoCab := U_GLENCHOICE(1, cAlias, OemToAnsi("CADASTRAIS"))
	aAltCab := U_GLENCHOICE(2, cAlias, OemToAnsi("CADASTRAIS"))
	aCpoCod := U_GLENCHOICE(1, cAlias, OemToAnsi("CLIENTE\FORNECEDOR"))
	aAltCod := U_GLENCHOICE(2, cAlias, OemToAnsi("CLIENTE\FORNECEDOR"))
	aCpoLog := U_GLENCHOICE(1, cAlias, OemToAnsi("TRANSPORTE"))
	aAltLog := U_GLENCHOICE(2, cAlias, OemToAnsi("TRANSPORTE"))
	aCpoPes := U_GLENCHOICE(1, cAlias, OemToAnsi("PESAGEM"))
	aAltPes := U_GLENCHOICE(2, cAlias, OemToAnsi("PESAGEM"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria tabela temporária referente as ANÁLISES DE QUALIDADE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cTabTMP := CriaTrab(aStrZM3, .T.)
	dbUseArea(.T.,, cTabTMP ,cAliasQLD, .F., .F.)
	dbSelectArea(cAliasQLD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Compõe variaveis em memória referente à tabela ZM1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea(cAlias)
	RegToMemory(cAlias, INCLUI)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Sendo inclusão, solicita placa do veículo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If INCLUI
		If !LT019SHW()
			Return
		EndIf
	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Atribui aos campos em memória, os valores do registro da tabela posicionado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea(cAlias)
		For nX := 1 TO FCount()
			M->&(Eval(bCampo, nX)) := FieldGet(nX)
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Carrega as informações de análises de qualidade para o alias temporário³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("ZM3")
		ZM3->(dbSetOrder(1))
		ZM3->(dbGoTop())
		If ZM3->(dbSeek(xFilial("ZM3") + M->ZM1_NUM))
			While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == M->ZM1_NUM
				RECLOCK(cAliasQLD, .T.)
				(cAliasQLD)->OK			:= ""
				(cAliasQLD)->ZM3_TANQUE	:= ZM3->ZM3_TANQUE
				(cAliasQLD)->ZM3_DTANA	:= ZM3->ZM3_DTANA
				(cAliasQLD)->ZM3_HRANA	:= ZM3->ZM3_HRANA
				(cAliasQLD)->ZM3_NOMANA	:= ZM3->ZM3_NOMANA
				(cAliasQLD)->ZM3_KGANT	:= ZM3->ZM3_KGANT
				(cAliasQLD)->ZM3_KGPOS	:= ZM3->ZM3_KGPOS
				(cAliasQLD)->ZM3_DTDES	:= ZM3->ZM3_DTDES
				(cAliasQLD)->ZM3_HRDES	:= ZM3->ZM3_HRDES
				(cAliasQLD)->ZM3_USRDES	:= ZM3->ZM3_USRDES
				(cAliasQLD)->ZM3_NOMDES	:= ZM3->ZM3_NOMDES
				(cAliasQLD)->ZM3_STATUS	:= IIF(ZM3->ZM3_STATUS == "A", "APROVADA", IIF(ZM3->ZM3_STATUS == "D", "DESCARTE", "VAZIO"))
				(cAliasQLD)->(MSUNLOCK())

				ZM3->(dbSkip())
			End
			(cAliasQLD)->(dbGoTop())
		Else
			_lDescarte := .F.
			dbSelectArea('ZM4')
			ZM4->(dbSetOrder(1))
			ZM4->(dbGoTop())
			If ZM4->(dbSeek(xFilial('ZM4')+M->ZM1_NUM))
				While ZM4->(!EOF()) .AND. ZM4->ZM4_FILIAL == xFilial("ZM4") .AND. ZM4->ZM4_NUM == M->ZM1_NUM
					dbSelectArea('ZM5')
					ZM5->(dbSetOrder(1))
					ZM5->(dbGoTop())
					If ZM5->(dbSeek(xFilial('ZM5')+M->ZM1_NUM+ZM4->ZM4_TANQUE))
						RECLOCK(cAliasQLD, .T.)
						(cAliasQLD)->OK			:= ""
						(cAliasQLD)->ZM3_TANQUE	:= ZM4->ZM4_TANQUE
						(cAliasQLD)->ZM3_DTANA	:= ZM1->ZM1_DATA
						(cAliasQLD)->ZM3_HRANA	:= ZM5->ZM5_HRANA
						(cAliasQLD)->ZM3_NOMANA	:= UsrFullName(ZM5->ZM5_USRANA)
						(cAliasQLD)->ZM3_STATUS	:= IIF(ZM4->ZM4_STATUS == "A", "APROVADA", IIF(ZM4->ZM4_STATUS == "D", "DESCARTE", IIF(ZM4->ZM4_STATUS == "P", "PROTOCOLO", "VAZIO")))

						If ZM4->ZM4_STATUS == 'D' .AND. !_lDescarte
							(cAliasQLD)->ZM3_KGANT	:= ZM1->ZM1_KGIDES
							(cAliasQLD)->ZM3_KGPOS	:= ZM1->ZM1_KGFDES
							(cAliasQLD)->ZM3_DTDES	:= ZM1->ZM1_DTDES
							(cAliasQLD)->ZM3_HRDES	:= ZM1->ZM1_HRDESC
							(cAliasQLD)->ZM3_USRDES	:= ZM1->ZM1_USRDES
							(cAliasQLD)->ZM3_NOMDES	:= UsrFullName(ZM1->ZM1_USRDES)
							_lDescarte := .T.
						EndIf

						(cAliasQLD)->(MSUNLOCK())
					EndIf
					ZM4->(dbSkip())
				EndDo

				(cAliasQLD)->(dbGoTop())
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Sendo VISUALIZAÇÃO, adiciona funcionalidades em OUTRAS AÇÕES³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If VISUAL
			AADD(aBotoes, {"UPDWARNING"	, {|| LT019LOG()}   , "Logs"})

			If ZM1->ZM1_STATUS == "9"
				AADD(aBotoes, {"nota"	, {|| LT019MTCAN(2)}, "Motivo"})
			EndIf
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Seta teclas de atalho para pesagem via balança e manual³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If ISINCALLSTACK("U_LT019ABE") .OR. ISINCALLSTACK("U_LT019FEC") .OR. ISINCALLSTACK("U_LT019DES")
		SetKey(VK_F5, {|| LT019INTBL()})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona atalho para peso manual caso esteja ativado integração com balança³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If lPesPsw .OR. ISINCALLSTACK("U_LT019DES")
			SetKey(VK_F8, {|| U_LT019KGM()})
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calcula tamanho\posicionamento da interface³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aSize := MsAdvSize()
	AADD(aObjects, {100, 035, .T., .T.})
	AADD(aObjects, {100, 065, .T., .T.})
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição do Dialog e demais componentes da interface³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDlg:bInit := {|| ENCHOICEBAR(oDlg,{|| IIF(LT019TOK(), (oDlg:End(), nOpcao := 1), )}, {|| (oDlg:End(), nOpcao := 2)},.F.,aBotoes)}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa regras para montagem do cabeçalho da pesagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oGetCab := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoCab, {aPosObj[1,1], aPosObj[1,2], aPosObj[1,3], aPosObj[1,4]}, aAltCab, 2,/*nColMens*/,/*cMensagem*/,'',oDlg, lF3, lMemoria, lColumn,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
	ZaGets1 := AClone(aGets)
	aTela1 := AClone(aTela)
	aGets  := {}
	aTela  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Cria o Folder principal dos itens da pesagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oFld := TFolder():New(aPosObj[2,1],aPosObj[2,2],{"&Cliente\Fornecedor", "&Transporte", "&Pesagem"},{},oDlg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2][2],aPosObj[2,3]-aPosObj[2][1],)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Cria regras para os campos da primeira aba do folder (Cli/For)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oGetCod := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoCod, {001,001,(oFld:aDialogs[1]:nClientHeight / 2)-2,(oFld:aDialogs[1]:nClientWidth / 2)-1}, aAltCod, 2,/*nColMens*/,/*cMensagem*/,'',oFld:aDialogs[1], lF3, lMemoria, lColumn,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
	aGets2 := AClone(aGets)
	aTela2 := AClone(aTela)
	aGets  := {}
	aTela  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Cria regras para os campos da segunda aba do folder (Logistica)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oGetLog := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoLog, {001,001,(oFld:aDialogs[1]:nClientHeight / 2)-2,(oFld:aDialogs[1]:nClientWidth / 2)-1}, aAltLog, 2,/*nColMens*/,/*cMensagem*/,'',oFld:aDialogs[2], lF3, lMemoria, lColumn,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
	aGets3 := AClone(aGets)
	aTela3 := AClone(aTela)
	aGets  := {}
	aTela  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Cria regras para os campos da terceira aba do folder (Pesagem)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oGetPes := MSMGET():NEW(cAlias,nReg,nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoPes, {001,001,(oFld:aDialogs[3]:nClientHeight / 2)-2,130}, aAltPes, 2,/*nColMens*/,/*cMensagem*/,'',oFld:aDialogs[3], lF3, lMemoria, .T.,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)
	aGets4 := AClone(aGets)
	aTela4 := AClone(aTela)
	aGets  := {}
	aTela  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Componentes referentes há integração com balança e peso via senha³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oPeso1 := TBtnBmp2():New(003,260,30,30, 'CARGA', , ,  , {|| IIF(ISINCALLSTACK("U_LT019ABE") .OR. ISINCALLSTACK("U_LT019DES"), LT019INTBL(),)} ,oFld:aDialogs[3], "Obter Peso", , .T.)
	oPeso2 := TBtnBmp2():New(003,330,30,30, 'CHAVE2', , , , {|| IIF(lPesPsw .OR. ISINCALLSTACK("U_LT019DES"), U_LT019KGM("E"),)} ,oFld:aDialogs[3], "Pesagem Manual", , .T.)

	oPeso3 := TBtnBmp2():New(070,260,30,30, 'CARGA', , ,  , {|| IIF(ISINCALLSTACK("U_LT019FEC"), LT019INTBL(),)} ,oFld:aDialogs[3], "Obter Peso", , .T.)
	oPeso4 := TBtnBmp2():New(070,330,30,30, 'CHAVE2', , , , {|| IIF(lPesPsw, U_LT019KGM("S"),)} ,oFld:aDialogs[3], "Pesagem Manual", , .T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Grid de apresentação de informações de análises de qualidade³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oFldQld := TFolder():New(001,200,{"Qualidade"},{},oFld:aDialogs[3],,,,.T.,.F.,aPosObj[2,4]-204,(oFld:aDialogs[3]:nClientHeight / 4)-2,)
	oMarQld := MsSelect():New(cAliasQLD,IIF(lDescarte, "OK", ""),"",aVwQLD,@lInverte,@cMarca,{001,001,(oFldQld:aDialogs[1]:nClientHeight / 2),(oFldQld:aDialogs[1]:nClientWidth / 2)},,,oFldQld:aDialogs[1])
	oMarQld:oBrowse:lHasMark     := .F.
	oMarQld:oBrowse:lCanAllMark  := .F.
	oMarQld:bMark                := {|| IIF(lDescarte, LT019MRK(), )}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Sendo abertura com placa já existente, foca na sessão de transporte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If INCLUI
		If lPeso
			If EMPTY(M->ZM1_CODVEI)
				oFld:SetOption(1)
				SetFocus(oGetPes:hWnd)
			Else
				oFld:SetOption(2)
				SetFocus(oGetPes:hWnd)
			EndIf

		Else
			SetFocus(oGetCab:aEntryCtrls[4]:hWnd)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Sendo FECHAMENTO ou DESCARTE, foca na sessão de pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ElseIf ISINCALLSTACK("U_LT019FEC") .OR. ISINCALLSTACK("U_LT019DES")
		oFld:SetOption(3)
	EndIf

	ACTIVATE MSDIALOG oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Remove definições de teclas de atalho da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	SetKey(VK_F5, Nil)
	SetKey(VK_F8, Nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Confirmando à interface, executa função de manipulação das informações na base de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If nOpcao == 1
		LT019GRV()
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso cancelou à abertura de uma nova pesagem, executa rollback no sequêncial³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ISINCALLSTACK("U_LT019ABE")
			ZM1->(ROLLBACKSX8())
			ZM1->(dbGoTo(nRecZM1))
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha alias temporário utilizado na interface³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If Select(cAliasQLD) > 0
		(cAliasQLD)->(dbCloseArea())
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019TOK  ºAutor  ³Marcelo Joner        º Data ³ 13/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação geral na confirmação da interface da    º±±
±±º          ³rotina de pesagens.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019TOK()

	Local lRet		:= .T.
	Local aArea		:= GetArea()
	Local cPrdLin	:= GETMV("MV_ZL00005",, "")
	Local cPrdTan	:= GETMV("MV_ZL00011",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras, caso seja ABERTURA ou ALTERAÇÃO da pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If INCLUI .OR. ALTERA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso campos obrigatórios não estejam informados, não permite prosseguir³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !OBRIGATORIO(aGets1, aTela1) .OR. !OBRIGATORIO(aGets2, aTela2) .OR. !OBRIGATORIO(aGets3, aTela3) .OR. !OBRIGATORIO(aGets4, aTela4)
			Return .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Aplica validações na confirmação de abertura da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ISINCALLSTACK("U_LT019ABE")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Aplica validações sob o peso de entrada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If M->ZM1_KGINI <= 0
				U_GLALL001("Atenção", "O peso de entrada não foi informado.", "Para confirmar à abertura da pesagem, deve ser informado o peso de entrada do veículo.")
				Return .F.
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Aplica validações sob o peso de saída³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ISINCALLSTACK("U_LT019FEC")
			If M->ZM1_KGFIN <= 0
				U_GLALL001("Atenção", "O peso de saída não foi informado.", "Para confirmar o fechamento da pesagem, deve ser informado o peso de saída do veículo.")
				Return .F.
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Aplica validações sob à informação do número de tanques do veículo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ALLTRIM(M->ZM1_PROD) $ cPrdTan .AND. M->ZM1_NRTNQ == 0
			U_GLALL001("Atenção", "Não foi informado número de tanques do veículo.", "Favor informar o número de tanques do veículo vinculado à está carga.")
			Return .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Aplica validação em relação à obrigatoriedade da linha de coleta da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If EMPTY(M->ZM1_NFCOM)
			If (M->ZM1_TIPO == "1" .AND. ISINCALLSTACK("U_LT019FEC") .AND. ALLTRIM(M->ZM1_PROD) $ cPrdLin .AND. EMPTY(M->ZM1_CODLIN))
				U_GLALL001("Atenção", "Não foi informada à linha de coleta da carga.", "Favor informar à linha de coleta vinculada à está carga.")
				Return .F.
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Alerta o usuário à respeito de inconsistência na informação dos campos de NOTA FISCAL e SÉRIE³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If M->ZM1_TIPO == "1" .AND. ISINCALLSTACK("U_LT019FEC") .AND. ((EMPTY(M->ZM1_NFCOM) .AND. !EMPTY(M->ZM1_SRCOM)) .OR. (!EMPTY(M->ZM1_NFCOM) .AND. EMPTY(M->ZM1_SRCOM)))
			U_GLALL001("Atenção", "Os campos referentes à Nota Fiscal e Série do fornecedor estão inconsistentes.", "É necessário que seja informado o número e série da nota fiscal do fornecedor vinculado à pesagem de entrada.")
			Return .F.
		EndIf

		IF M->ZM1_TIPO == "2" .AND. ISINCALLSTACK("U_LT019FEC")
			Return U_LT019TP()
		EndIf

		IF ISINCALLSTACK("U_LT019FEC")
			If Aviso("Atenção", "Confirma o Fechamento da pesagem da placa " + SUBSTR(M->ZM1_PLACA,1,3) + "-" + SUBSTR(M->ZM1_PLACA,4,4) + "?" , {"&Sim", "&Não"}, 2) == 2
				Return .F.

			EndIf
		ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de avaliação das informações de peso da carga e composição do TIPO da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		U_LTMOV9TP()
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Sendo CANCELAMENTO da pesagem, apresenta interface para informar o motivo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If ISINCALLSTACK("U_LT019CAN")
		lRet := LT019MTCAN(4)
	EndIf

	RestArea(aArea)

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019MTCAN  ºAutor ³Marcelo Joner       º Data ³ 13/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela apresentação de interface secundáriaº±±
±±º          ³onde deverá ser informado o motivo referente ao cancelamentoº±±
±±º          ³da pesagem.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019MTCAN(nOpc)

	Local aArea			:= GetArea()
	Local aCpoCad 		:= {'NOUSER', 'ZM1_OBSCAN'}
	Local aAltCad 		:= {'ZM1_OBSCAN'}
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local lRet			:= .T.
	Local lF3			:= .F.
	Local lColumn		:= .F.
	Local lMemoria		:= .T.
	Local lNoFolder		:= .T.
	Local lProperty		:= .F.
	Local cCadOld		:= cCadastro

	Default nOpc		:= 1

	Private aGets[0]
	Private aTela[0][0]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Sendo Visualização do motivo de cancelamento, apresenta demais campos para visualização³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If nOpc == 2
		cCadastro := "Cancelamento da Pesagem"
		aCpoCad := {'NOUSER', 'ZM1_OBSCAN', 'ZM1_USRCAN', 'ZM1_NOMCAN', 'ZM1_DTCAN', 'ZM1_HRCAN'}
		aAltCad := {'ZM1_OBSCAN', 'ZM1_USRCAN', 'ZM1_NOMCAN', 'ZM1_DTCAN', 'ZM1_HRCAN'}
	Else
		cCadastro := "Cancelar Pesagem"
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calcula tamanho\posicionamento da interface³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aSize := MsAdvSize(.T.)
	AADD(aObjects, {100, 100, .T., .T.})
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Declaração do dialog e demais componentes da interface secundária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oDlgLog := MSDialog():New(089,232,IIF(nOpc == 4, 220, 260),920,cCadastro,,,.F.,,,,,,.T.,,,.T. )
	oDlgLog:bInit := {|| ENCHOICEBAR(oDlgLog, {|| If(LT019VLCAN(), (lRet := .T., oDlgLog:End()),)}, {|| (lRet := .F., oDlgLog:End())}, .F., {})}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Cabeçalho da interface de Log³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oGetCad := MSMGET():NEW("ZM1",0, nOpc, /*aCRA*/,/*cLetra*/,/*cTexto*/, aCpoCad, {aPosObj[1][1], 001, (oDlgLog:nClientHeight / 2)-15,(oDlgLog:nClientWidth / 2)-5}, aAltCad, 2,/*nColMens*/,/*cMensagem*/,'',oDlgLog, lF3, lMemoria, lColumn,/*caTela*/,lNoFolder,lProperty, /*aField*/, /*aFolder*/, .F., /*lNoMDIStretch*/,/*cTela*/)

	oDlgLog:Activate(,,,.T.)

	cCadastro := cCadOld

	RestArea(aArea)

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019VLCAN ºAutor  ³Marcelo Joner       º Data ³ 13/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela validação geral da interface secun- º±±
±±º          ³dária de cancelamento de pesagens.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019VLCAN()

	Local lRet	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Campos obrigatórios do cabeçalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !OBRIGATORIO(aGets, aTela)
		Return .F.
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Valida à observação informada pelo usuário³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If Len(ALLTRIM(M->ZM1_OBSCAN)) <= 15
			U_GLALL001("Atenção", "A observação informada é inválida.", "Favor informar uma observação com mais de 15 caracteres referente ao cancelamento da pesagem.")
			Return .F.
		EndIf
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019GRV  ºAutor  ³Marcelo Joner        º Data ³ 13/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela manipulação das informações referen-º±±
±±º          ³tes as pesagens junto à base de dados.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019GRV()

	Local nI		:= 0
	Local aArea		:= GetArea()

	Do Case

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Regras de gravação da ABERTURA da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ISINCALLSTACK("U_LT019ABE")
		BEGIN TRANSACTION
			dbSelectArea("ZM1")
			RECLOCK("ZM1", .T.)
			For nI := 1 To FCount()
				If FieldName(nI) == "ZM1_FILIAL"
					FieldPut(nI, xFilial("ZM1"))
				Else
					If FieldName(nI) == "ZM1_STATUS"
						FieldPut(nI, "1")
					Else
						FieldPut(nI, M->&(FieldName(nI)))
					EndIf
				EndIf
			Next nI
			ZM1->(MSUNLOCK())

			ZM1->(CONFIRMSX8())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de verificação de incidência de análise de qualidade sob à pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			LT019STQLD()
		END TRANSACTION



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Regras de gravação do FECHAMENTO da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ISINCALLSTACK("U_LT019FEC")
		BEGIN TRANSACTION
			dbSelectArea("ZM1")
			RECLOCK("ZM1", .F.)
			For nI := 1 To FCount()
				If FieldName(nI) == "ZM1_FILIAL"
					FieldPut(nI, xFilial("ZM1"))
				Else
					If FieldName(nI) == "ZM1_STATUS"
						FieldPut(nI, "2")
					Else
						FieldPut(nI, M->&(FieldName(nI)))
					EndIf
				EndIf
			Next nI
			ZM1->(MSUNLOCK())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa função de verificação de incidência de análise de qualidade sob à pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			LT019STQLD()

			// Djonata - 20210331
			// Inverte a gravação dos campos armazenados na rotina de descarte e fechamento, pois o processo é executado invertido,
			// primeiro é pesado o leite bom, mas grava nos campos de descarte, depois é pesado o descarte, mas grava nos campos do leite bom,
			// foi solicitado para não alterar a sequência desse processo

			If !Empty(ZM1->ZM1_USRDES)
				_nPesoIni := ZM1->ZM1_KGIDES
				_nPesoFim := ZM1->ZM1_KGFDES
				_nPDesIni := ZM1->ZM1_KGINI
				_nPDesFim := ZM1->ZM1_KGFIN
				RecLock('ZM1',.F.)
				ZM1->ZM1_KGIDES := _nPDesIni
				ZM1->ZM1_KGFDES := _nPDesFim
				ZM1->ZM1_KGINI	:= _nPesoIni
				ZM1->ZM1_KGFIN	:= _nPesoFim
				ZM1->ZM1_KGBRT	:= _nPesoIni - _nPesoFim
				ZM1->(MsUnlock())
			EndIf
		END TRANSACTION

		If Aviso("Atenção", "Deseja realizar à impressão do ticket de pesagem?", {"&Sim", "&Não"}, 2) == 1
			If GETMV("MX_IMPTICK",, "") = "LASER"
				U_LTREL047()
			else
				U_LTREL038()
			EndIf
		EndIf



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Regras de gravação de ALTERAÇÃO ou DESCARTE da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ISINCALLSTACK("U_LT019ALT") .OR. ISINCALLSTACK("U_LT019DES")
		BEGIN TRANSACTION
			dbSelectArea("ZM1")
			RECLOCK("ZM1", .F.)
			For nI := 1 To FCount()
				If FieldName(nI) == "ZM1_FILIAL"
					FieldPut(nI, xFilial("ZM1"))
				Else
					FieldPut(nI, M->&(FieldName(nI)))
				EndIf
			Next nI
			ZM1->(MSUNLOCK())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Sendo execução através da funcionalidade DESCARTE, atualiza registros de análises de qualidade³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If ISINCALLSTACK("U_LT019DES")
				dbSelectArea(cAliasQLD)
				(cAliasQLD)->(dbGoTop())
				While (cAliasQLD)->(!EOF())
					dbSelectArea("ZM3")
					ZM3->(dbSetOrder(1))
					ZM3->(dbGoTop())
					If ZM3->(dbSeek(xFilial("ZM3") + ZM1->ZM1_NUM + (cAliasQLD)->ZM3_TANQUE))
						RECLOCK("ZM3", .F.)
						ZM3->ZM3_KGANT	:= (cAliasQLD)->ZM3_KGANT
						ZM3->ZM3_KGPOS	:= (cAliasQLD)->ZM3_KGPOS
						ZM3->ZM3_DTDES	:= (cAliasQLD)->ZM3_DTDES
						ZM3->ZM3_HRDES	:= (cAliasQLD)->ZM3_HRDES
						ZM3->ZM3_USRDES	:= (cAliasQLD)->ZM3_USRDES
						ZM3->ZM3_NOMDES	:= (cAliasQLD)->ZM3_NOMDES
						ZM3->(MSUNLOCK())
					ElseIf !Empty((cAliasQLD)->ZM3_KGANT)
						RecLock('ZM1',.F.)
						ZM1->ZM1_KGIDES := (cAliasQLD)->ZM3_KGANT
						ZM1->ZM1_KGFDES := (cAliasQLD)->ZM3_KGPOS
						ZM1->ZM1_USRDES := (cAliasQLD)->ZM3_USRDES
						ZM1->ZM1_DTDES  := (cAliasQLD)->ZM3_DTDES
						ZM1->ZM1_HRDESC := (cAliasQLD)->ZM3_HRDES
						ZM1->(MsUnlock())
					EndIf
					(cAliasQLD)->(dbSkip())
				End
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Sendo ALTERAÇÃO, executa função de verificação de incidência de análise de qualidade sob à pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If ISINCALLSTACK("U_LT019ALT")
				//LT019STQLD()
				dbSelectArea("ZM1")
				RECLOCK("ZM1", .F.)
				ZM1->ZM1_LTVAZ 	:= 0
				ZM1->ZM1_FATCON := 0
				ZM1->ZM1_LTBRT  := 0
				ZM1->ZM1_LTDIF  := 0

				ZM1->(MSUNLOCK())
			EndIf
		END TRANSACTION



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Regras de gravação do CANCELAMENTO da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Case ISINCALLSTACK("U_LT019CAN")
		BEGIN TRANSACTION
			dbSelectArea("ZM1")
			RECLOCK("ZM1", .F.)
			ZM1->ZM1_USRCAN := __cUserId
			ZM1->ZM1_NOMCAN := cUserName
			ZM1->ZM1_DTCAN  := dDataBase
			ZM1->ZM1_HRCAN  := SUBSTR(GetRmtTime(), 1, 5)
			ZM1->ZM1_OBSCAN := M->ZM1_OBSCAN
			ZM1->ZM1_STATUS := "9"
			ZM1->(MSUNLOCK())
		END TRANSACTION

	EndCase

	RestArea(aArea)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019STQLD ºAutor  ³Marcelo Joner       º Data ³ 15/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela atualização do campo de controle do º±±
±±º          ³status do processo de análise de qualidade da pesagem.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019STQLD()

	Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Posiciona no cadastro do produto vinculado há pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	If SB1->(dbSeek(xFilial("SB1") + ZM1->ZM1_PROD))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Havendo vinculo de Tipo de Análise ao produto, atualiza o campo de controle do status de pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !EMPTY(SB1->B1_X_TPANA)
			RECLOCK("ZM1", .F.)
			ZM1->ZM1_SITQLD := "P"
			ZM1->(MSUNLOCK())
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Não havendo Tipo de Análise ao produto, garante exclusão dos registros de qualidade³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("ZM3")
			ZM3->(dbSetOrder(1))
			ZM3->(dbGoTop())
			If ZM3->(dbSeek(xFilial("ZM3") + ZM1->ZM1_NUM))
				While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == ZM1->ZM1_NUM
					RECLOCK("ZM3", .F.)
					ZM3->(DBDELETE())
					ZM3->(MSUNLOCK())

					ZM3->(dbSkip())
				End
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Limpa o campo de controle do status da análise de qualidade da pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RECLOCK("ZM1", .F.)
			ZM1->ZM1_SITQLD := ""
			ZM1->(MSUNLOCK())
		EndIf
	EndIf

	RestArea(aArea)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019VCF  ºAutor  ³Marcelo Joner        º Data ³ 12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação vinculada aos campos de código e loja doº±±
±±º          ³cliente\fornecedor na rotina de pesagens.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019VCF(cCampo)

	Local lRet	:= .T.
	Local cPrdSer := GETMV("MV_ZL00013",, "")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Sendo ENTRADA, valida dados de FORNECEDOR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If M->ZM1_TIPO == "1" .OR. (ALLTRIM(M->ZM1_PROD) $ cPrdSer)
		If cCampo == "ZM1_CLIFOR"
			M->ZM1_LOJA := ""
		EndIf
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(dbGoTop())
		If SA2->(dbSeek(xFilial("SA2") + M->ZM1_CLIFOR + IIF(!EMPTY(M->ZM1_LOJA), M->ZM1_LOJA, "")))
			M->ZM1_LOJA := SA2->A2_LOJA
			M->ZM1_NOME := SA2->A2_NOME

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Verifica se o mesmo está presente em Produtores X Linha para obter o Transportador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("ZL1")
			ZL1->(dbSetOrder(4))
			ZL1->(dbGoTop())
			If ZL1->(dbSeek(xFilial("ZL1") + SA2->A2_COD + SA2->A2_LOJA))
				dbSelectArea("ZL0")
				ZL0->(dbSetOrder(1))
				ZL0->(dbGoTop())
				If ZL0->(dbSeek(xFilial("ZL0") + ZL1->ZL1_COD))
					M->ZM1_TRANSP := ZL0->ZL0_TRANSP
					M->ZM1_DTRANS := ZL0->ZL0_NOMTRP
				EndIf
			EndIf
		Else
			lRet := .F.
			U_GLALL001("Atenção", "O fornecedor informado é inválido.", "Favor verificar os dados informados.")
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Sendo SAÍDA, valida dados de CLIENTE³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbGoTop())
		If SA1->(dbSeek(xFilial("SA1") + M->ZM1_CLIFOR + IIF(!EMPTY(M->ZM1_LOJA), M->ZM1_LOJA, "")))
			M->ZM1_LOJA := SA1->A1_LOJA
			M->ZM1_NOME := SA1->A1_NOME
		Else
			lRet := .F.
			U_GLALL001("Atenção", "O cliente informado é inválido.", "Favor verificar os dados informados.")
		EndIf
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019MED  ºAutor  ³Marcelo Joner        º Data ³ 12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função vinculada as regras de modo de edição de algunas     º±±
±±º          ³campos da rotina de pesagens.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019MED(cCampo)

	Local lRet		:= .F.

	Default cCampo	:= ""

	Do Case
	Case cCampo == "ZM1_PLACA"
		lRet := IIF(EMPTY(M->ZM1_CODVEI) .AND. !(ISINCALLSTACK("U_LT019ABE")), .T., IIF(ISINCALLSTACK("U_LT019FEC"),.T., .F.) .AND. IIF(ISINCALLSTACK("U_LT019ALT"),.T., .F.))

	Case cCampo == "ZM1_CODVEI"
		lRet := IIF(ISINCALLSTACK("U_LT019ALT"),.T., .F.)

	Case cCampo == "ZM1_NOMMOT"
		lRet := EMPTY(M->ZM1_CODMOT)

	Case cCampo == "ZM1_TIPO"
		lRet := IIF(ISINCALLSTACK("U_LT019ALT"), GETMV("MV_ZL00003",, .F.), .F.)

	Case cCampo == "ZM1_PROD"
		lRet := IIF(ISINCALLSTACK("U_LT019ALT"), GETMV("MV_ZL00003",, .F.), .F.) .OR. ISINCALLSTACK("U_LT019ABE")

	Case cCampo == "ZM1_CODLIN"
		lRet := !EMPTY(M->ZM1_TRANSP)

	Case cCampo == "ZM1_NRTNQ"
		lRet := ALLTRIM(M->ZM1_PROD) $ ALLTRIM(GETMV("MV_ZL00011",, ""))
		M->ZM1_NRTNQ := IIF(lRet, M->ZM1_NRTNQ, 0)

	Case cCampo == "ZM1_KGINI"
		lRet := IIF(ISINCALLSTACK("U_LT019ABE"), GETMV("MV_ZL00001",, .F.), .F.)

	Case cCampo == "ZM1_KGFIN"
		lRet := IIF(ISINCALLSTACK("U_LT019FEC"), GETMV("MV_ZL00001",, .F.), .F.)

	Case cCampo == "ZM1_DTINI"
		lRet := IIF(ISINCALLSTACK("U_LT019ABE"), GETMV("MV_ZL00001",, .F.), IIF(ISINCALLSTACK("U_LT019ALT"), .T., .F.))

	Case cCampo == "ZM1_DTFIN"
		lRet := IIF(ISINCALLSTACK("U_LT019FEC"), GETMV("MV_ZL00001",, .F.), IIF(ISINCALLSTACK("U_LT019ALT"), .T., .F.))

	Case cCampo == "ZM1_HRINI"
		lRet := IIF(ISINCALLSTACK("U_LT019ABE"), GETMV("MV_ZL00001",, .F.), IIF(ISINCALLSTACK("U_LT019ALT"), .T., .F.))

	Case cCampo == "ZM1_HRFIN"
		lRet := IIF(ISINCALLSTACK("U_LT019FEC"), GETMV("MV_ZL00001",, .F.), IIF(ISINCALLSTACK("U_LT019ALT"), .T., .F.))


	EndCase

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019KGM    ºAutor  ³Marcelo Joner    º Data ³  12/02/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel por realizar as validações/procedimentos º±±
±±º          ³referentes à informação de peso via senha.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019KGM(cPesagem)

	Local nOpcao 		:=  2
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aPosObj		:= {}

	Private oGet2
	Private oGet3
	Private lEdit		:= .F.
	Private nPeso		:= 0
	Private cPsw		:= SPACE(20)
	Private cMotivo		:= SPACE(TAMSX3("ZM2_MOTIVO")[1])

	Default cPesagem	:= IIF(ISINCALLSTACK("U_LT019ABE"), "E", IIF(ISINCALLSTACK("U_LT019FEC"), "S", IIF(ISINCALLSTACK("U_LT019DES"), "E", "")))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Garante que as regras sejam executadas apenas se esta posicionado na aba Pesagem\Classificação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If oFld:nOption == 3

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Aborta execução da função caso exista divergência nos parâmetros em relação à funcionalidade que está em execução³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If (ISINCALLSTACK("U_LT019ABE") .AND. cPesagem != "E") .OR. (ISINCALLSTACK("U_LT019FEC") .AND. cPesagem != "S")
			Return
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso seja executado à partir da funcionalidade DESCARTE, valida que tenha análise qualidade selecionada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ISINCALLSTACK("U_LT019DES")
			lAchou := .F.
			dbSelectArea(cAliasQLD)
			nRecQLD := (cAliasQLD)->(RECNO())
			(cAliasQLD)->(dbGoTop())
			While (cAliasQLD)->(!EOF())
				If !EMPTY((cAliasQLD)->OK)
					lAchou := .T.
					exit
				EndIf
				(cAliasQLD)->(dbSkip())
			End
			(cAliasQLD)->(dbGoTo(nRecQLD))

			If !lAchou
				U_GLALL001("Atenção", "Não foi selecionado à análise de qualidade referente há realização do descarte.", "Para utilizar está funcionalidade, é necessário selecionar à análise de qualidade vinculada à ocorrência do descarte.")
				Return
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Remove definições de teclas de atalho³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		SetKey(VK_F5, Nil)
		SetKey(VK_F8, Nil)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Montagem dos parâmetros para criação da tela de exibição³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		aSize := MsAdvSize()
		AAdd(aObjects, {100, 100, .T., .F.})
		aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
		aPosObj := MsObjSize(aInfo, aObjects, .T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Inicia montagem do dialog de requisição da senha³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oDlgPesMan := MSDialog():New( 000,000,136,500,"Pesagem Manual",,,.F.,,,,,,.T.,,,.T. )
		oDlgPesMan:bInit := {|| ENCHOICEBAR(oDlgPesMan,{|| IIF(LT019PSW(.T.), (nOpcao := 1, oDlgPesMan:End()),) },{|| (nOpcao :=  2, oDlgPesMan:End())},.F.,{})}
		oSay1 := TSay():New(aPosObj[1,1]+001,008,{|| "Senha"},oDlgPesMan,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		oSay2 := TSay():New(aPosObj[1,1]+012,008,{|| "Peso"},oDlgPesMan,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		oSay3 := TSay():New(aPosObj[1,1]+024,008,{|| "Motivo"},oDlgPesMan,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		oGet1 := TGet():New(aPosObj[1,1]+000,036, {|u| If(PCount()>0,@cPsw := u ,@cPsw)},oDlgPesMan,060,008,'', {|| LT019PSW()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","@cPsw",,)
		oGet2 := TGet():New(aPosObj[1,1]+011,036, {|u| If(PCount()>0,@nPeso := u ,@nPeso)},oDlgPesMan,070,008,PESQPICT("ZM1", "ZM1_KGINI"), {|| LT019VKGMN(nPeso)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,lEdit,"","@nPeso",,,,.T.)
		oGet3 := TGet():New(aPosObj[1,1]+023,036, {|u| If(PCount()>0,@cMotivo := u ,@cMotivo)},oDlgPesMan,190,008,'@!', {|| .T.},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,lEdit,"","@cMotivo",,)
		oDlgPesMan:Activate(,,,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se o usuario confirmou a pesagem manual³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If nOpcao == 1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Pega o numero do próximo item na tabela ZM2³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("ZM2")
			ZM2->(dbSetOrder(1))
			ZM2->(dbGoTop())
			If ZM2->(dbSeek(xFilial("ZM2") + M->ZM1_NUM))
				nItem := 1
				While (ZM2->(!EOF()) .AND. ZM2->ZM2_NUM == M->ZM1_NUM)
					nItem++
					ZM2->(dbSkip())
				End
				nItem++
			Else
				nItem := 1
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Verifica qual a rotina que esta sendo executada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			Do Case
			Case ISINCALLSTACK("U_LT019ABE")
				cRotina :=  "1"

			Case ISINCALLSTACK("U_LT019FEC")
				cRotina :=  "2"

			Case ISINCALLSTACK("U_LT019ALT")
				cRotina :=  "3"

			Case ISINCALLSTACK("U_LT019DES")
				cRotina :=  "4"
			End Case

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Insere registro de log na tabela ZM2³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RECLOCK("ZM2", .T.)
			ZM2->ZM2_FILIAL	:= xFilial("ZM2")
			ZM2->ZM2_NUM	:= M->ZM1_NUM
			ZM2->ZM2_ITEM	:= STRZERO(nItem, TAMSX3("ZM2_ITEM")[1])
			ZM2->ZM2_CODUSR	:= __cUserId
			ZM2->ZM2_NOMUSR	:= cUserName
			ZM2->ZM2_DTANT	:= IIF(cRotina $ "1\4", M->ZM1_DTINI, M->ZM1_DTFIN)
			ZM2->ZM2_HRANT	:= IIF(cRotina $ "1\4", M->ZM1_HRINI, M->ZM1_HRFIN)
			ZM2->ZM2_VLRANT	:= IIF(cRotina $ "1\4", M->ZM1_KGINI, M->ZM1_KGFIN)
			ZM2->ZM2_DATA	:= dDataBase
			ZM2->ZM2_HORA	:= SUBSTR(GetRmtTime(), 1, 5)
			ZM2->ZM2_VALOR	:= nPeso
			ZM2->ZM2_FUNCAO	:= cRotina
			ZM2->ZM2_MOTIVO	:= cMotivo
			ZM2->(MSUNLOCK())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Verifica se trata-se da primeira pesagem da carga³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If cPesagem == "E"

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Sendo execução através da funcionalidade de DESCARTE, atualiza o registro da análise selecionada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If ISINCALLSTACK("U_LT019DES")
					dbSelectArea(cAliasQLD)
					nRecQLD := (cAliasQLD)->(RECNO())
					(cAliasQLD)->(dbGoTop())
					While (cAliasQLD)->(!EOF())
						If !EMPTY((cAliasQLD)->OK)
							RECLOCK(cAliasQLD, .F.)
							(cAliasQLD)->ZM3_KGANT	:= IIF((cAliasQLD)->ZM3_KGANT == 0, M->ZM1_KGINI, (cAliasQLD)->ZM3_KGANT)
							(cAliasQLD)->ZM3_KGPOS	:= nPeso
							(cAliasQLD)->ZM3_DTDES	:= dDataBase
							(cAliasQLD)->ZM3_HRDES	:= SUBSTR(TIME(), 1, 5)
							(cAliasQLD)->ZM3_USRDES	:= __cUserId
							(cAliasQLD)->ZM3_NOMDES	:= cUserName
							(cAliasQLD)->(MSUNLOCK())
						EndIf
						(cAliasQLD)->(dbSkip())
					End
					(cAliasQLD)->(dbGoTo(nRecQLD))
				EndIf

				M->ZM1_KGINI := nPeso
				M->ZM1_DTINI := dDataBase
				M->ZM1_HRINI := SUBSTR(GetRmtTime(), 1, 5)
				M->ZM1_KGBRT := nPeso
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Refere-se a segunda pesagem da carga³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				M->ZM1_KGFIN := nPeso
				M->ZM1_DTFIN := dDataBase
				M->ZM1_HRFIN := SUBSTR(GetRmtTime(), 1, 5)
				//M->ZM1_KGBRT := ROUND(IIF(M->ZM1_TIPO == "1", (M->ZM1_KGINI - nPeso), (nPeso - M->ZM1_KGINI)), TAMSX3("ZM1_KGBRT")[2])
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de avaliação das informações de peso da carga e composição do TIPO da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

		U_LTMOV9TP()


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Restaura teclas de atalho da interface principal da rotina³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		SetKey(VK_F5, {|| MOV001CBALANCA(1)})
		SetKey(VK_F8, {|| U_LT019KGM()})
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019PSW    ºAutor  ³Marcelo Joner º     Data ³  12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel por verificar a senha de liberação de    º±±
±±º          ³pesagem manual na rotina de pesagens.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019PSW(lConfirm)

	Local lRet 			:= .T.

	Default lConfirm	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca senha do parametro, pois trata-se de uma filial³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !UPPER(ALLTRIM(cPsw)) == UPPER(ALLTRIM(GETMV("MV_ZL00002", .T., "°")))
		lRet := .F.
		lEdit := .F.
		nPeso := 0
		U_GLALL001("Atenção", "Senha inválida.", "A senha informada não corresponde à senha de liberação definida para esta filial.")
	Else
		lEdit := .T.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Ao confirmar à tela de informações de pesagem manual, aplica demais validações³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lRet .AND. lConfirm
		If nPeso <= 0
			lRet := .F.
			U_GLALL001("Atenção", "O peso informado é inválido.", "O peso informado deve ser superior à zero.")
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Valida composição do motivo referente à ocorrência da pesagem manual³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If LEN(ALLTRIM(cMotivo)) < 15
				lRet := .F.
				U_GLALL001("Atenção", "Motivo de ocorrência da pesagem manual.", "Favor informar o motivo referente à realização da pesagem manual.")
			EndIf
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza TGet utilizado para informação manual do peso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oGet2:CtrlRefresh()

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019VKGMN  ºAutor  ³Marcelo Joner     º Data ³  12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel por validar o peso informado pelo usuárioº±±
±±º          ³ao utilizar o recurso via senha.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestão de Cereais                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019VKGMN(nPeso)

	Local lRet		:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras caso o valor de pesagem seja válido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !POSITIVO(nPeso)
		lRet := .F.
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019INTBL     ºAutor  ³Marcelo Joner º  Data ³  12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel pela comunicação com à balança e obtençãoº±±
±±º          ³da informação de peso do veículo.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019INTBL(nBalanca)

	Local cPorta 		:= ""
	Local cDados 		:= ""
	Local cBalanca		:= ""
	Local cPesoOld		:= ""
	Local nResp			:= 0
	Local nLeitDef		:= 0
	Local nLeitExe		:= 0
	Local lConectou 	:= .F.
	Local lPeso			:= .F.

	Private nHdll		:= 0

	Default nBalanca	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa demais regras, caso esteja com foco na sessão de PESAGEM presente na tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If oFld:nOption != 3
		Return
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso seja executado à partir da funcionalidade DESCARTE, valida que tenha análise qualidade selecionada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If ISINCALLSTACK("U_LT019DES")
		lAchou := .F.
		dbSelectArea(cAliasQLD)
		nRecQLD := (cAliasQLD)->(RECNO())
		(cAliasQLD)->(dbGoTop())
		While (cAliasQLD)->(!EOF())
			If !EMPTY((cAliasQLD)->OK)
				lAchou := .T.
				exit
			EndIf
			(cAliasQLD)->(dbSkip())
		End
		(cAliasQLD)->(dbGoTo(nRecQLD))

		If !lAchou
			U_GLALL001("Atenção", "Não foi selecionado à análise de qualidade referente há realização do descarte.", "Para utilizar está funcionalidade, é necessário selecionar à análise de qualidade vinculada à ocorrência do descarte.")
			Return
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Realiza chamada da função responsável por verificar a balança utilizada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cBalanca := LT019LDBAL(nBalanca)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Havendo balança configurada, executa regras de integração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If cBalanca != "F00001"
		dbSelectArea("ZM0")
		ZM0->(dbSetOrder(1))
		ZM0->(dbGoTop())
		If ZM0->(dbSeek(xFilial("ZM0") + cBalanca))
			nLeitDef := ZM0->ZM0_NUMLEI

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa procedimentos de conexão SERIAL com a balança³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If ZM0->ZM0_TPCONE == "1"

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Verifica a porta de comunicação da balança³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				cPorta := "COM" + ALLTRIM(ZM0->ZM0_PRTCOM)
				nMaxTen:= IIF(ZM0->ZM0_NUMEXE > 0, ZM0->ZM0_NUMEXE, 50)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Realiza a conexão com a balança³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If MsOpenPort(nHdll,cPorta + ":" + ALLTRIM(ZM0->ZM0_VELOCI) + "," + ZM0->ZM0_PARARI + "," + ZM0->ZM0_BITDAD + "," +ZM0->ZM0_BITPAR)
					cDados := U_GLGETANSWER(nHdll, cDados, 1)
					cDados := ALLTRIM(cDados)
					U_GLCLOSEPORT(nHdll)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa leituras do peso enquanto o mesmo no for estavel³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					nCount := 0
					While !lPeso

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso exista caractere de quebra, adequa string de retorno antes das demais análises³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					/*
					If ZM0->ZM0_USAQBR == "1"
						cDados := SUBSTR(cDados, At(SUBSTR(ZM0->ZM0_CHRQBR, 1, ZM0->ZM0_TAMQBR), cDados) + 1, 30)
					EndIf
					*/

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso o peso obtido esteja estavel, retorna o mesmo³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If SUBSTR(cDados, ZM0->ZM0_ESTINI, (ZM0->ZM0_ESTFIM - ZM0->ZM0_ESTINI)) == ALLTRIM(ZM0->ZM0_ESTDET)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Executa regras caso à balança possua controle de leitura de peso consecutivas iguais³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If nLeitDef > 0
								If cPesoOld == SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
									nLeitExe++
								Else
									nLeitExe := 0
									cPesoOld := SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Caso o número de leituras de peso equivalente tenha sido atingido, acata o peso em questão³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If nLeitExe >= nLeitDef
									cDados		:= SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
									lPeso		:= .T.
									lConectou	:= .T.
									exit
								EndIf
							Else

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Se não valida leituras equivalentes, já acata o peso obtido³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								cDados		:= SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
								lPeso		:= .T.
								lConectou	:= .T.
								exit
							EndIf
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso o peso não seja válido, efetua nova conexão³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If !lPeso

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Efetua nova comunio/leitura do peso na porta COM³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							MsOpenPort(nHdll,cPorta + ":" + ALLTRIM(ZM0->ZM0_VELOCI) + "," + ZM0->ZM0_PARARI + "," + ZM0->ZM0_BITDAD + "," +ZM0->ZM0_BITPAR)
							cDados := U_GLGETANSWER(nHdll, cDados, 1)
							cDados := ALLTRIM(cDados)
							U_GLCLOSEPORT(nHdll)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica numero máximo de conexões para leitura do peso³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							nCount++
							If nCount > nMaxTen
								exit
							EndIf
						EndIf
					End
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Valida se foi obtido conexao com alguma balanca, caso nao,³
				//³apresenta mensagem alertando o usuario.                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If !lConectou
					U_GLALL001("Atenção", "Não foi possível efetuar conexão com à balança " + cBalanca + " em nenhuma das portas: " + CHR(10) + CHR(10) + "COM1, COM2, COM3, COM4, COM5 e COM6.", "Favor verificar se à balança está ligada e conectada de maneira correta ao terminal." + CHR(10) + CHR(10) + "Caso o problema persista, favor efetuar contato com o departamento responsável.")
					Return
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Retorna o peso para o campo correspondente conforme a rotina realizada³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If ISINCALLSTACK("U_LT019ABE") .OR. ISINCALLSTACK("U_LT019DES")

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Verifica se trata-se de repesagem na ABERTURA da pesagem³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If M->ZM1_KGINI > 0 .AND. ISINCALLSTACK("U_LT019ABE")
							If AVISO("Atenção", "Confirma à repesagem do peso de entrada?", {"Sim", "Não"}, 2) == 1

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Grava registro de log referente a repesagem³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								dbSelectArea("ZM2")
								ZM2->(dbSetOrder(1))
								ZM2->(dbGoTop())
								If ZM2->(dbSeek(xFilial("ZM2") + M->ZM1_NUM))
									nItem := 1
									While (ZM2->(!EOF()) .AND. ZM2->ZM2_NUM == M->ZM1_NUM)
										nItem++
										ZM2->(dbSkip())
									End
									nItem++
								Else
									nItem := 1
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Insere registro de log na tabela ZM2³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								RECLOCK("ZM2", .T.)
								ZM2->ZM2_FILIAL	:= xFilial("ZM2")
								ZM2->ZM2_NUM    := M->ZM1_NUM
								ZM2->ZM2_ITEM	:= STRZERO(nItem, TAMSX3("ZM2_ITEM")[1])
								ZM2->ZM2_CODUSR := __cUserId
								ZM2->ZM2_NOMUSR	:= cUserName
								ZM2->ZM2_DTANT	:= M->ZM1_DTINI
								ZM2->ZM2_HRANT	:= M->ZM1_HRINI
								ZM2->ZM2_VLRANT	:= M->ZM1_KGINI
								ZM2->ZM2_DATA	:= dDataBase
								ZM2->ZM2_HORA	:= SUBSTR(GetRmtTime(), 1, 5)
								ZM2->ZM2_VALOR	:= ROUND(ABS(VAL(cDados)), 0)
								ZM2->ZM2_FUNCAO	:= "1"
								ZM2->ZM2_MOTIVO	:= "REPESAGEM VIA BALANÇA"
								ZM2->(MSUNLOCK())
							Else
								Return
							EndIf
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Sendo execução através da funcionalidade de DESCARTE, atualiza o registro da análise selecionada³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If ISINCALLSTACK("U_LT019DES")
							dbSelectArea(cAliasQLD)
							nRecQLD := (cAliasQLD)->(RECNO())
							(cAliasQLD)->(dbGoTop())
							While (cAliasQLD)->(!EOF())
								If !EMPTY((cAliasQLD)->OK)
									RECLOCK(cAliasQLD, .F.)
									(cAliasQLD)->ZM3_KGANT	:= IIF((cAliasQLD)->ZM3_KGANT == 0, M->ZM1_KGINI, (cAliasQLD)->ZM3_KGANT)
									(cAliasQLD)->ZM3_KGPOS	:= ROUND(ABS(VAL(cDados)), 0)
									(cAliasQLD)->ZM3_DTDES	:= dDataBase
									(cAliasQLD)->ZM3_HRDES	:= SUBSTR(TIME(), 1, 5)
									(cAliasQLD)->ZM3_USRDES	:= __cUserId
									(cAliasQLD)->ZM3_NOMDES	:= cUserName
									(cAliasQLD)->(MSUNLOCK())
								EndIf
								(cAliasQLD)->(dbSkip())
							End
							(cAliasQLD)->(dbGoTo(nRecQLD))

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Grava registro de log referente a repesagem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							dbSelectArea("ZM2")
							ZM2->(dbSetOrder(1))
							ZM2->(dbGoTop())
							If ZM2->(dbSeek(xFilial("ZM2") + M->ZM1_NUM))
								nItem := 1
								While (ZM2->(!EOF()) .AND. ZM2->ZM2_NUM == M->ZM1_NUM)
									nItem++
									ZM2->(dbSkip())
								End
								nItem++
							Else
								nItem := 1
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Insere registro de log na tabela ZM2³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							RECLOCK("ZM2", .T.)
							ZM2->ZM2_FILIAL	:= xFilial("ZM2")
							ZM2->ZM2_NUM    := M->ZM1_NUM
							ZM2->ZM2_ITEM	:= STRZERO(nItem, TAMSX3("ZM2_ITEM")[1])
							ZM2->ZM2_CODUSR := __cUserId
							ZM2->ZM2_NOMUSR	:= cUserName
							ZM2->ZM2_DTANT	:= M->ZM1_DTINI
							ZM2->ZM2_HRANT	:= M->ZM1_HRINI
							ZM2->ZM2_VLRANT	:= M->ZM1_KGINI
							ZM2->ZM2_DATA	:= dDataBase
							ZM2->ZM2_HORA	:= SUBSTR(GetRmtTime(), 1, 5)
							ZM2->ZM2_VALOR	:= ROUND(ABS(VAL(cDados)), 0)
							ZM2->ZM2_FUNCAO	:= "4"
							ZM2->ZM2_MOTIVO	:= "REPESAGEM VIA BALANÇA"
							ZM2->(MSUNLOCK())
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Atualiza as informações de pesagem³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						M->ZM1_KGINI := ROUND(ABS(VAL(cDados)), 0)
						M->ZM1_DTINI := dDataBase
						M->ZM1_HRINI := SUBSTR(GetRmtTime(), 1, 5)
						M->ZM1_KGBRT := M->ZM1_KGINI

					Else

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Funcionalidade de fechamento da pesagem³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If ISINCALLSTACK("U_LT019FEC")

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica se trata-se de repesagem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If M->ZM1_KGFIN  > 0
								If AVISO("Atenção", "Confirma à repesagem do peso saída?", {"Sim", "Não"}, 2) == 1

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Grava registro de log referente a repesagem³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									dbSelectArea("ZM2")
									ZM2->(dbSetOrder(1))
									ZM2->(dbGoTop())
									If ZM2->(dbSeek(xFilial("ZM2") + M->ZM1_NUM))
										nItem := 1
										While (ZM2->(!EOF()) .AND. ZM2->ZM2_NUM == M->ZM1_NUM)
											nItem++
											ZM2->(dbSkip())
										End
										nItem++
									Else
										nItem := 1
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Insere registro de log na tabela ZM2³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									RECLOCK("ZM2", .T.)
									ZM2->ZM2_FILIAL	:= xFilial("ZM2")
									ZM2->ZM2_NUM    := M->ZM1_NUM
									ZM2->ZM2_ITEM	:= STRZERO(nItem, TAMSX3("ZM2_ITEM")[1])
									ZM2->ZM2_CODUSR := __cUserId
									ZM2->ZM2_NOMUSR	:= cUserName
									ZM2->ZM2_DTANT	:= M->ZM1_DTFIN
									ZM2->ZM2_HRANT	:= M->ZM1_HRFIN
									ZM2->ZM2_VLRANT	:= M->ZM1_KGFIN
									ZM2->ZM2_DATA	:= dDataBase
									ZM2->ZM2_HORA	:= SUBSTR(GetRmtTime(), 1, 5)
									ZM2->ZM2_VALOR	:= ROUND(ABS(VAL(cDados)), 0)
									ZM2->ZM2_FUNCAO	:= "2"
									ZM2->ZM2_MOTIVO	:= "REPESAGEM VIA BALANÇA"
									ZM2->(MSUNLOCK())
								Else
									Return
								EndIf
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Atualiza as informações de pesagem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							M->ZM1_KGFIN := ROUND(ABS(VAL(cDados)), 0)
							M->ZM1_DTFIN := dDataBase
							M->ZM1_HRFIN := SUBSTR(GetRmtTime(), 1, 5)
							M->ZM1_KGBRT := ROUND(IIF(M->ZM1_TIPO == "1", (M->ZM1_KGINI - M->ZM1_KGFIN), (M->ZM1_KGFIN - M->ZM1_KGINI)), TAMSX3("ZM1_KGBRT")[2])
						EndIf
					EndIf
				EndIf

			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa procedimentos de conexão TCP/IP com a balança³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				nMaxTen  := IIF(ZM0->ZM0_NUMEXE > 0, ZM0->ZM0_NUMEXE, 50)
				oBalanca := tSocketClient():New()

				nResp := oBalanca:Connect(VAL(ALLTRIM(ZM0->ZM0_PRTIP)), ALLTRIM(ZM0->ZM0_IP), 100)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Aguarda após a conexão visando estabelecer comunicação com a balança³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				sleep(2000)

				If nResp == 0 .AND. oBalanca:IsConnected()

					oBalanca:Send(ALLTRIM(ZM0->ZM0_ENVIP))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Executa leituras do peso enquanto o mesmo no for estavel³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					nCount := 0
					While !lPeso

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Verifica se recebeu retorno de informações da balança³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If oBalanca:Receive(cDados, 1000) > 0
							cDados := ALLTRIM(cDados)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Ponto de entrada para tratamento nos dados obtidos da balança³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If ExistBlock("MOV01BAL")
								cDados := ExecBlock("MOV01BAL", .F., .F., {cDados})
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Caso exista caractere de quebra, adequa string de retorno antes das demais análises³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						/*
						If ZM0->ZM0_USAQBR == "1"
							cDados := SUBSTR(cDados, At(SUBSTR(ZM0->ZM0_CHRQBR, 1, ZM0->ZM0_TAMQBR), cDados) + 1, 30)
						EndIf
						*/

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Caso o peso obtido esteja estavel, retorna o mesmo³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If SUBSTR(cDados, ZM0->ZM0_ESTINI, ZM0->ZM0_ESTFIM) == ALLTRIM(ZM0->ZM0_ESTDET)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Executa regras caso à balança possua controle de leitura de peso consecutivas iguais³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If nLeitDef > 0
									If cPesoOld == SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
										nLeitExe++
									Else
										nLeitExe := 0
										cPesoOld := SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Caso o número de leituras de peso equivalente tenha sido atingido, acata o peso em questão³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									If nLeitExe >= nLeitDef
										cDados		:= SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
										lPeso		:= .T.
										lConectou	:= .T.
										exit
									EndIf
								Else

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Se não valida leituras equivalentes, já acata o peso obtido³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									cDados		:= SUBSTR(cDados, ZM0->ZM0_KGINI, (ZM0->ZM0_KGFIM - ZM0->ZM0_KGINI) + 1)
									lPeso		:= .T.
									lConectou	:= .T.
									exit
								EndIf
							EndIf
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso o peso não seja válido, atualiza contador de tentavias de leitura³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If !lPeso

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica numero máximo de conexões para leitura do peso³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							nCount++
							If nCount > nMaxTen
								oBalanca:CloseConnection()
								exit
							EndIf
						EndIf
					End

					oBalanca:CloseConnection()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Valida se foi obtido conexao com alguma balanca, caso nao,³
					//³apresenta mensagem alertando o usuario.                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !lConectou
						U_GLALL001("Atenção", "Não foi possível efetuar conexão com à balança " + cBalanca + " no endereço IP: " + ALLTRIM(ZM0->ZM0_IP) + ".", "Favor verificar se à balança está ligada e conectada em rede no IP configurado no cadastro." + CHR(10) + CHR(10) + "Caso o problema persista, favor efetuar contato com o departamento responsável.")
						Return
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Retorna o peso para o campo correspondente conforme a rotina realizada³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If ISINCALLSTACK("U_LT019ABE")

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica se trata-se de repesagem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If M->ZM1_KGINI > 0
								If AVISO("Atenção", "Confirma à repesagem do peso de entrada?", {"Sim", "Não"}, 2) == 1

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Grava registro de log referente a repesagem³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									dbSelectArea("ZM2")
									ZM2->(dbSetOrder(1))
									ZM2->(dbGoTop())
									If ZM2->(dbSeek(xFilial("ZM2") + M->ZM1_NUM))
										nItem := 1
										While (ZM2->(!EOF()) .AND. ZM2->ZM2_NUM == M->ZM1_NUM)
											nItem++
											ZM2->(dbSkip())
										End
										nItem++
									Else
										nItem := 1
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Insere registro de log na tabela ZM2³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									RECLOCK("ZM2", .T.)
									ZM2->ZM2_FILIAL	:= xFilial("ZM2")
									ZM2->ZM2_NUM    := M->ZM1_NUM
									ZM2->ZM2_ITEM	:= STRZERO(nItem, TAMSX3("ZM2_ITEM")[1])
									ZM2->ZM2_CODUSR := __cUserId
									ZM2->ZM2_NOMUSR	:= cUserName
									ZM2->ZM2_DTANT	:= M->ZM1_DTINI
									ZM2->ZM2_HRANT	:= M->ZM1_HRINI
									ZM2->ZM2_VLRANT	:= M->ZM1_KGINI
									ZM2->ZM2_DATA	:= dDataBase
									ZM2->ZM2_HORA	:= SUBSTR(GetRmtTime(), 1, 5)
									ZM2->ZM2_VALOR	:= ROUND(ABS(VAL(cDados)), 0)
									ZM2->ZM2_FUNCAO	:= "1"
									ZM2->ZM2_MOTIVO	:= "REPESAGEM VIA BALANÇA"
									ZM2->(MSUNLOCK())
								Else
									Return
								EndIf
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Atualiza as informações de pesagem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							M->ZM1_KGINI := ROUND(ABS(VAL(cDados)), 0)
							M->ZM1_DTINI := dDataBase
							M->ZM1_HRINI := SUBSTR(GetRmtTime(), 1, 5)
							M->ZM1_KGBRT := M->ZM1_KGINI
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica se trata-se de repesagem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							If M->ZM1_KGFIN > 0
								If AVISO("Atenção", "Confirma à repesagem do peso saída?", {"Sim", "Não"}, 2) == 1

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Grava registro de log referente a repesagem³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									dbSelectArea("ZM2")
									ZM2->(dbSetOrder(1))
									ZM2->(dbGoTop())
									If ZM2->(dbSeek(xFilial("ZM2") + M->ZM1_NUM))
										nItem := 1
										While (ZM2->(!EOF()) .AND. ZM2->ZM2_NUM == M->ZM1_NUM)
											nItem++
											ZM2->(dbSkip())
										End
										nItem++
									Else
										nItem := 1
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Insere registro de log na tabela ZM2³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									RECLOCK("ZM2", .T.)
									ZM2->ZM2_FILIAL	:= xFilial("ZM2")
									ZM2->ZM2_NUM  	:= M->ZM1_NUM
									ZM2->ZM2_ITEM	:= STRZERO(nItem, TAMSX3("ZM2_ITEM")[1])
									ZM2->ZM2_CODUSR	:= __cUserId
									ZM2->ZM2_NOMUSR	:= cUserName
									ZM2->ZM2_DTANT	:= M->ZM1_DTFIN
									ZM2->ZM2_HRANT	:= M->ZM1_HRFIN
									ZM2->ZM2_VLRANT	:= M->ZM1_KGFIN
									ZM2->ZM2_DATA	:= dDataBase
									ZM2->ZM2_HORA	:= SUBSTR(GetRmtTime(), 1, 5)
									ZM2->ZM2_VALOR	:= ROUND(ABS(VAL(cDados)), 0)
									ZM2->ZM2_FUNCAO	:= "2"
									ZM2->ZM2_MOTIVO	:= "REPESAGEM VIA BALANÇA"
									ZM2->(MSUNLOCK())
								Else
									Return
								EndIf
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Atualiza as informações de pesagem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							M->ZM1_KGFIN := ROUND(ABS(VAL(cDados)), 0)
							M->ZM1_DTFIN := dDataBase
							M->ZM1_HRFIN := SUBSTR(GetRmtTime(), 1, 5)
							M->ZM1_KGBRT := ROUND(IIF(M->ZM1_TIPO == "1", (M->ZM1_KGINI - M->ZM1_KGFIN), (M->ZM1_KGFIN - M->ZM1_KGINI)), TAMSX3("ZM1_KGBRT")[2])
						EndIf
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Alerta o usuário caso não conseguiu conexão com à balança³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					U_GLALL001("Atenção", "Não foi possível efetuar conexão com à balança " + cBalanca + " no endereço IP: " + ALLTRIM(ZM0->ZM0_IP) + ".", "Favor verificar se à balança está ligada e conectada em rede no IP configurado no cadastro." + CHR(10) + CHR(10) + "Caso o problema persista, favor efetuar contato com o departamento responsável.")
					Return
				EndIf
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Alerta o usuário caso não conseguiu localizar à balança vinculada ao arquivo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			U_GLALL001("Atenção", "A balança " + cBalanca + " informada no arquivo de configuração não foi localizada.", "Favor realizar à exclusão do arquivo de configuração e após isto, efetuar nova configuração da balança desejada.")
			Return
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função de avaliação das informações de peso da carga e composição do TIPO da pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_LTMOV9TP()

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019LDBAL    ºAutor  ³Marcelo Joner    º Data ³ 12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel por verificar se já existe uma balanca   º±±
±±º          ³utilizada no terminal, caso não, realiza procedimentos de   º±±
±±º          ³apresentação das balancas existentes para filial logada de  º±±
±±º          ³modo que o usuario escolha a balança que será utilizada.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019LDBAL(nBalanca)

	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aPosObj		:= {}
	Local cBalanca		:= ""
	Local cQuery		:= ""
	Local cArqTrab		:= ""
	Local nOpc			:= 2
	Local nItem			:= 0
	Local lLoad			:= .F.
	Local lInverte		:= .F.
	Local lReadOnly		:= .F.
	Local lShare		:= .T.
	Local aVwZM0		:= {}
	Local aStruct		:= {}
	Local cMarca		:= GetMark()
	Local cPath			:= GetTempPath()
	Local cCadOld		:= cCadastro

	Private cEOL		:= "CHR(13) + CHR(10)"
	Private cArqTxt		:= cPath + "balanca" + ALLTRIM(STR(nBalanca)) + ".ini"
	Private nHdl		:= fOpen(cArqTxt)
	Private cAlias		:= GetNextAlias()

	cEOL := &cEOL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa procedimentos de abertura do arquivo de configuração da balança utilizada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If nHdl == -1
		U_GLALL001("Atenção", "Não existe balança configurada para utilização neste terminal.", "Favor efetuar os procedimentos à seguir para efetuar configuração de uma balança.")
	Else
		lLoad := .T.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso tenha encontrado o arquivo de configuração da balança,    ³
//³realiza os procedimentos de leitura e validação da configuração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lLoad
		nTamFile := fSeek(nHdl, 0, 2)
		fSeek(nHdl,0,0)
		nTamLin  := LEN(cEOL) + TAMSX3("ZM0_COD")[1]
		cBalanca := SPACE(nTamLin)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Carrega código da balança presente no arquivo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If fRead(nHdl, @cBalanca, nTamLin) > 0
			cBalanca := ALLTRIM(cBalanca)
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Caso ocorreram erros na leitura do arquivo, alerta o usuario³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			U_GLALL001("Atenção", "Ocorreram erros na leitura do arquivo de configuração.", "Não foi possível ler o arquivo " + cArqTxt)
			cBalanca := ""
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Inicia procedimentos para apresentação ao usuario de todas as balancas³
		//³disponiveis para utilização na filial e posteriormente gera o arquivo ³
		//³de configuração no terminal conforme à balança selecionada            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		AADD(aVwZM0, {"ZM0_COD"   	, "", U_LTALLXSX3("ZM0_COD")[1]   	, U_LTALLXSX3("ZM0_COD")[6]   	})
		AADD(aVwZM0, {"ZM0_DESC"  	, "", U_LTALLXSX3("ZM0_DESC")[1]  	, U_LTALLXSX3("ZM0_DESC")[6]  	})
		AADD(aVwZM0, {"ZM0_TIPOCX"	, "", U_LTALLXSX3("ZM0_TPCONE")[1]	, U_LTALLXSX3("ZM0_TPCONE")[6]	})
		AADD(aVwZM0, {"ZM0_IP"    	, "", U_LTALLXSX3("ZM0_IP")[1]    	, U_LTALLXSX3("ZM0_IP")[6]    	})
		AADD(aVwZM0, {"ZM0_PORTAC"	, "", U_LTALLXSX3("ZM0_PRTCOM")[1] 	, U_LTALLXSX3("ZM0_PRTCOM")[6] 	})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta estrutura da tabela temporaria³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		AADD(aStruct, {"ZM0_COD"   	, U_LTALLXSX3("ZM0_COD")[3]   	, U_LTALLXSX3("ZM0_COD")[4]   	, U_LTALLXSX3("ZM0_COD")[5]   	})
		AADD(aStruct, {"ZM0_DESC"  	, U_LTALLXSX3("ZM0_DESC")[3]  	, U_LTALLXSX3("ZM0_DESC")[4]  	, U_LTALLXSX3("ZM0_DESC")[5]  	})
		AADD(aStruct, {"ZM0_TIPOCX"	, U_LTALLXSX3("ZM0_TPCONE")[3]	, 07							, U_LTALLXSX3("ZM0_TPCONE")[5]	})
		AADD(aStruct, {"ZM0_IP"    	, U_LTALLXSX3("ZM0_IP")[3]    	, U_LTALLXSX3("ZM0_IP")[4]    	, U_LTALLXSX3("ZM0_IP")[5]    	})
		AADD(aStruct, {"ZM0_PORTAC"	, U_LTALLXSX3("ZM0_PRTCOM")[3] 	, U_LTALLXSX3("ZM0_PRTCOM")[4] 	, U_LTALLXSX3("ZM0_PRTCOM")[5] 	})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta query de busca das balanças disponíveis para utilização na filial/parceria em questão³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cQuery := "SELECT DISTINCT									" + CRLF
		cQuery += "	    ZM0_COD,									" + CRLF
		cQuery += "	    ZM0_DESC,									" + CRLF
		cQuery += "	    ZM0_TPCONE,									" + CRLF
		cQuery += "     '" + SPACE(07) + "' ZM0_TIPOCX,				" + CRLF
		cQuery += "	    ZM0_IP,										" + CRLF
		cQuery += "	    ZM0_PRTCOM,									" + CRLF
		cQuery += "     '" + SPACE(05) + "' ZM0_PORTAC				" + CRLF

		cQuery += "FROM " + RetSQLName("ZM0") + " ZM0     			" + CRLF

		cQuery += "WHERE ZM0.ZM0_FILIAL  = '" + xFilial("ZM0") + "'	" + CRLF
		cQuery += "  AND ZM0.D_E_L_E_T_ <> '*'			  			" + CRLF

		cQuery += "ORDER BY ZM0_COD									" + CRLF

		cArqTrab  := CriaTrab( aStruct, .T. )

		If Select(cAlias) > 0
			(cAlias)->(dbCloseArea())
		EndIf

		cQuery := ChangeQuery(cQuery)

		TCQUERY cQuery NEW ALIAS cAlias

		Copy TO &cArqTrab
		dBCloseArea()
		dBUseArea( .T.,, cArqTrab, cAlias, lShare, lReadOnly )
		(cAlias)->(dbGoTop())
		While (cAlias)->(!EOF())
			RECLOCK(cAlias, .F.)
			(cAlias)->ZM0_TIPOCX := IIF((cAlias)->ZM0_TPCONE == "1", "SERIAL", "TCP/IP")
			(cAlias)->ZM0_PORTAC := "COM" + (cAlias)->ZM0_PRTCOM
			(cAlias)->(MSUNLOCK())

			(cAlias)->(dbSkip())
		End
		(cAlias)->(dbGoTop())

		cCadastro := "Balanças"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Montagem dos parâmetros para criação da tela de exibição³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		aSize := MsAdvSize()
		AAdd(aObjects, {100, 040, .T., .F.})
		AAdd(aObjects, {100, 060, .T., .F.})
		aInfo := {aSize[1], aSize[2], aSize[3]/2, aSize[4]/2, 5, 5}
		aPosObj := MsObjSize(aInfo, aObjects, .T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Inicia montagem do dialog se apresentação das balanças disponiveis³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oDlgBal := MSDialog():New( 089,232,aPosObj[1,1] + 312,845,"Configuração de Balança",,,.F.,,,,,,.T.,,,.T. )
		oDlgBal:bInit := {|| ENCHOICEBAR(oDlgBal, {|| (nOpc := 1, nItem := (cAlias)->(RECNO()), oDlgBal:End())}, {|| (nOpc := 2, oDlgBal:End())},.F.,{})}
		oBrw := MsSelect():New(cAlias,"","", aVwZM0,@lInverte,@cMarca,{aPosObj[1,1],001,aPosObj[1,1]+092,309},,,oDlgBal)
		oDlgBal:Activate(,,,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso o usuario confirmou a balanca selecionada, gera o arquivo ³
		//³de configuração com as informações da balanca selecionada      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If nOpc == 1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Cria o arquivo no local especificado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nHdl := fCreate(cArqTxt)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Verifica se conseguiu criar o arquivo de configuração no terminal³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If nHdl == -1
				U_GLALL001("Atenção", "Não foi possível criar o arquivo de configuração da balança selecionada.", "Favor efetuar contato com o departamento de TI e informar o ocorrido.")
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa procedimentos de gravação da balança selecionada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				dbSelectArea(cAlias)
				(cAlias)->(dbGoTo(nItem))

				cBalanca := (cAlias)->ZM0_COD
				cLin := Stuff(cEOL, 01, TAMSX3("ZM0_COD")[1], cBalanca)

				If fWrite(nHdl, cLin, LEN(cLin)) != LEN(cLin)
					U_GLALL001("Atenção", "Ocorreram erros no momento da gravação do arquivo de configuração.", "Não foi possível gravar o arquivo " + cArqTxt)
				EndIf
			EndIf
		Else
			U_GLALL001("Atenção", "Não foi efetuada à configuração de nenhuma balança para utilização neste terminal.", "Para realizar à pesagem de veículos deverá ser configurado uma balança ou utilizado o processo de pesagem manual através de senha.")
			Return "F00001"
		EndIf

		cCadastro := cCadOld
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha tabela temporaria caso a mesma esteja em uso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If Select(cAlias) > 0
		(cAlias)->(dBCloseArea())
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha o arquivo de configuração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	fClose(nHdl)

Return cBalanca





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019LOG    ºAutor   ³Marcelo Joner    º  Data ³ 13/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por verificar à existencia de logs de    º±±
±±º          ³repesagem e pesagem manual.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019LOG()

	Local cQuery		:= ""
	Local cArqTrab		:= ""
	Local cMarca		:= ""
	Local cAliasLOG		:= GetNextAlias()
	Local cCadOld		:= cCadastro
	Local lInverte		:= .F.
	Local lReadOnly		:= .F.
	Local lShare		:= .T.
	Local aVwZM2 		:= {}
	Local aStruct 		:= {}
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aPosObj		:= {}
	Local nX			:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Compõe array com os campos para visualização dos logs³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	AADD(aVwZM2, {"ZM2_ITEM"	, "", U_LTALLXSX3("ZM2_ITEM")[1]	, U_LTALLXSX3("ZM2_ITEM")[6]  })
	AADD(aVwZM2, {"ZM2_CODUSR"	, "", U_LTALLXSX3("ZM2_CODUSR")[1]	, U_LTALLXSX3("ZM2_CODUSR")[6]})
	AADD(aVwZM2, {"ZM2_NOMUSR"	, "", U_LTALLXSX3("ZM2_NOMUSR")[1]	, U_LTALLXSX3("ZM2_NOMUSR")[6]})
	AADD(aVwZM2, {"ZM2_DTANT"	, "", U_LTALLXSX3("ZM2_DTANT")[1]	, U_LTALLXSX3("ZM2_DTANT")[6] })
	AADD(aVwZM2, {"ZM2_HRANT"	, "", U_LTALLXSX3("ZM2_HRANT")[1]	, U_LTALLXSX3("ZM2_HRANT")[6] })
	AADD(aVwZM2, {"ZM2_VLRANT"	, "", U_LTALLXSX3("ZM2_VLRANT")[1]	, U_LTALLXSX3("ZM2_VLRANT")[6]})
	AADD(aVwZM2, {"ZM2_DATA"	, "", U_LTALLXSX3("ZM2_DATA")[1]	, U_LTALLXSX3("ZM2_DATA")[6]  })
	AADD(aVwZM2, {"ZM2_HORA"	, "", U_LTALLXSX3("ZM2_HORA")[1]	, U_LTALLXSX3("ZM2_HORA")[6]  })
	AADD(aVwZM2, {"ZM2_VALOR"	, "", U_LTALLXSX3("ZM2_VALOR")[1]	, U_LTALLXSX3("ZM2_VALOR")[6] })
	AADD(aVwZM2, {"FUNCAO"		, "", U_LTALLXSX3("ZM2_FUNCAO")[1]	, U_LTALLXSX3("ZM2_FUNCAO")[6]})
	AADD(aVwZM2, {"ZM2_MOTIVO"	, "", U_LTALLXSX3("ZM2_MOTIVO")[1]	, U_LTALLXSX3("ZM2_MOTIVO")[6]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta estrutura da tabela temporaria de apresentação dos logs³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	AADD(aStruct, {"ZM2_ITEM"	, U_LTALLXSX3("ZM2_ITEM")[3]	, U_LTALLXSX3("ZM2_ITEM")[4]	, U_LTALLXSX3("ZM2_ITEM")[5]  })
	AADD(aStruct, {"ZM2_CODUSR"	, U_LTALLXSX3("ZM2_CODUSR")[3]	, U_LTALLXSX3("ZM2_CODUSR")[4]	, U_LTALLXSX3("ZM2_CODUSR")[5]})
	AADD(aStruct, {"ZM2_NOMUSR"	, U_LTALLXSX3("ZM2_NOMUSR")[3]	, U_LTALLXSX3("ZM2_NOMUSR")[4]	, U_LTALLXSX3("ZM2_NOMUSR")[5]})
	AADD(aStruct, {"ZM2_DTANT"	, U_LTALLXSX3("ZM2_DTANT")[3]	, U_LTALLXSX3("ZM2_DTANT")[4]	, U_LTALLXSX3("ZM2_DTANT")[5] })
	AADD(aStruct, {"ZM2_HRANT"	, U_LTALLXSX3("ZM2_HRANT")[3]	, U_LTALLXSX3("ZM2_HRANT")[4]	, U_LTALLXSX3("ZM2_HRANT")[5] })
	AADD(aStruct, {"ZM2_VLRANT"	, U_LTALLXSX3("ZM2_VLRANT")[3]	, U_LTALLXSX3("ZM2_VLRANT")[4]	, U_LTALLXSX3("ZM2_VLRANT")[5]})
	AADD(aStruct, {"ZM2_DATA"	, U_LTALLXSX3("ZM2_DATA")[3]	, U_LTALLXSX3("ZM2_DATA")[4]	, U_LTALLXSX3("ZM2_DATA")[5]  })
	AADD(aStruct, {"ZM2_HORA"	, U_LTALLXSX3("ZM2_HORA")[3]	, U_LTALLXSX3("ZM2_HORA")[4]	, U_LTALLXSX3("ZM2_HORA")[5]  })
	AADD(aStruct, {"ZM2_VALOR"	, U_LTALLXSX3("ZM2_VALOR")[3]	, U_LTALLXSX3("ZM2_VALOR")[4]	, U_LTALLXSX3("ZM2_VALOR")[5] })
	AADD(aStruct, {"ZM2_FUNCAO"	, U_LTALLXSX3("ZM2_FUNCAO")[3]	, U_LTALLXSX3("ZM2_FUNCAO")[4]	, U_LTALLXSX3("ZM2_FUNCAO")[5]})
	AADD(aStruct, {"FUNCAO"		, U_LTALLXSX3("ZM2_FUNCAO")[3]	, 30							, U_LTALLXSX3("ZM2_FUNCAO")[5]})
	AADD(aStruct, {"ZM2_MOTIVO"	, U_LTALLXSX3("ZM2_MOTIVO")[3]	, U_LTALLXSX3("ZM2_MOTIVO")[4]	, U_LTALLXSX3("ZM2_MOTIVO")[5]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta query de busca dos registros de log de informações de peso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cQuery := "SELECT ZM2_ITEM,									" + CRLF
	cQuery += "       ZM2_CODUSR,								" + CRLF
	cQuery += "       ZM2_NOMUSR,								" + CRLF
	cQuery += "       ZM2_DTANT,								" + CRLF
	cQuery += "       ZM2_HRANT,								" + CRLF
	cQuery += "       ZM2_VLRANT,								" + CRLF
	cQuery += "       ZM2_DATA,									" + CRLF
	cQuery += "       ZM2_HORA,									" + CRLF
	cQuery += "       ZM2_VALOR,								" + CRLF
	cQuery += "       ZM2_FUNCAO,								" + CRLF
	cQuery += "       '" + SPACE(30) + "' FUNCAO,				" + CRLF
	cQuery += "       ZM2_MOTIVO								" + CRLF

	cQuery += "FROM " + RetSQLName("ZM2") + " ZM2     			" + CRLF

	cQuery += "WHERE ZM2.ZM2_FILIAL  = '" + xFilial("ZM2") + "'	" + CRLF
	cQuery += "  AND ZM2.ZM2_NUM     = '" + M->ZM1_NUM     + "'	" + CRLF
	cQuery += "  AND ZM2.D_E_L_E_T_ <> '*'			  			" + CRLF

	cQuery += "ORDER BY ZM2_NUM, ZM2_ITEM						" + CRLF

	cArqTrab  := CriaTrab( aStruct, .T. )

	If Select(cAliasLOG) > 0
		(cAliasLOG)->(dBCloseArea())
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasLOG,.T.,.T.)
	For nX := 1 To len(aStruct)
		If aStruct[nX][2] <> "C" .And. FieldPos(aStruct[nX][1])<>0
			TcSetField(cAliasLOG,aStruct[nX][1],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4])
		EndIf
	Next nX

	Copy TO &cArqTrab
	dBCloseArea()
	dBUseArea( .T.,, cArqTrab, cAliasLOG, lShare, lReadOnly )
	(cAliasLOG)->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza descrição das rotinas\operações³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	While (cAliasLOG)->(!EOF())
		RECLOCK(cAliasLOG, .F.)
		(cAliasLOG)->FUNCAO := IIF((cAliasLOG)->ZM2_FUNCAO == "1", "Abertura", IIF((cAliasLOG)->ZM2_FUNCAO == "2", "Fechamento", IIF((cAliasLOG)->ZM2_FUNCAO == "3", "Alteração", "Descarte")))
		(cAliasLOG)->(MSUNLOCK())

		(cAliasLOG)->(dbSkip())
	End
	(cAliasLOG)->(dbGoTop())

	cCadastro := "Logs de Pesagem"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Calculo das dimensões para interface secundária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aSize := MsAdvSize(.T.)
	AAdd(aObjects, {100, 100, .T., .T.})
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	aPosObj := MsObjSize(aInfo, aObjects, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Apresenta interface ao usuário com as informações de log³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oDlgLog := MSDialog():New(000,000,280,aSize[5], "Log de Pesagens",,,.F.,,,,,,.T.,,,.T. )
	oDlgLog:bInit := {||ENCHOICEBAR(oDlgLog, {|| oDlgLog:End()}, {|| oDlgLog:End()},.F.,{})}
	oBrw := MsSelect():New(cAliasLOG,"","", aVwZM2,@lInverte,@cMarca,{aPosObj[1,1],aPosObj[1,2],(oDlgLog:nClientHeight / 2)-15,(oDlgLog:nClientWidth / 2)-3},,,oDlgLog)
	oDlgLog:Activate(,,,.T.)

	If Select(cAliasLOG) > 0
		(cAliasLOG)->(dBCloseArea())
	EndIf

	cCadastro := cCadOld

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019BLKILL   ºAutor  ³Marcelo Joner  º  Data ³  14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para permitir ao usuário verificar/remover º±±
±±º          ³à balança configurada na estação para integração.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019BLKILL()

	Local aSize		:= {}
	Local aObjects	:= {}
	Local aInfo		:= {}
	Local aPosObj	:= {}
	Local aCols		:= {}
	Local aHeader	:= {}
	Local cBalanca  := LT019BLSV()
	Local nX
	Private oBrw1
	Private oBtn1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso não localizou balança vinculada ao terminal, aborta o processo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If cBalanca == "F00002"
		U_GLALL001("Atenção", "Não foi possível localizar nenhuma balança configurada para integração neste terminal.", "Este recurso somente pode ser utilizado quando existe uma balança configurado no terminal.")
		Return
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caso conseguiu ler o código da balança, executa demais regras³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If cBalanca != "F00001"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Compõe o aHeader com os campos do Cadastro Balanças³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("SX3")
			SX3->(dbSetOrder(1))
			SX3->(dbSeek("ZM0"))
			While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "ZM0"
				If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
					AADD(aHeader, {Trim(X3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						SX3->X3_RELACAO,;
						SX3->X3_WHEN,;
						SX3->X3_VISUAL,;
						SX3->X3_VLDUSER,;
						SX3->X3_VLDUSER})
				EndIf

				SX3->(dbSkip())
			End

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Carrega informações referentes ao cadastro da balança1³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("ZM0")
			ZM0->(dbSetOrder(1))
			ZM0->(dbGoTop())
			If ZM0->(dbSeek(xFilial("ZM0") + cBalanca))
				AADD(aCols, Array(Len(aHeader) + 1))
				For nX := 1 To Len(aHeader)
					If aHeader[nX][10] != "V"
						If !EMPTY(nPosZM0 := FieldPos(aHeader[nX][2]))
							aCols[Len(aCols)][nX] := ZM0->(FieldGet(nPosZM0))
						EndIf
					Else
						aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
					EndIf
				Next
				aCols[Len(aCols)][Len(aHeader) + 1] := .F.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calcula dimensões da interface secundária³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aSize := MsAdvSize()
			AAdd(aObjects, {100, 040, .T., .F.})
			AAdd(aObjects, {100, 060, .T., .F.})
			aInfo := {aSize[1], aSize[2], aSize[3] / 2, aSize[4] / 2, 5, 5}
			aPosObj := MsObjSize(aInfo, aObjects, .T.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Apresenta interface secundária ao usuário³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			oDlg2 := MSDialog():New(091,232,aPosObj[1,1] + 283,1030,"Balança X Pesagens",,,.F.,,,,,,.T.,,,.T. )
			oDlg2:bInit := {||EnchoiceBar(oDlg2,{|| oDlg2:End()},{|| oDlg2:End()},.F.,{})}
			oGrp1 := TGroup():New( aPosObj[1,1],004,aPosObj[1,1] + 060,396, "Balança",oDlg2,CLR_HBLUE,CLR_WHITE,.T.,.F. )
			oBrw1 := MsNewGetDados():New(aPosObj[1,1] + 008,008,aPosObj[1,1] + 056,392,0,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp1,aHeader,aCols)
			oBrw1:SetEditLine(.F.)
			oBtn1 := TButton():New(aPosObj[1,1] + 063,354,"Remover",oGrp1,{|| LT019BLEXC()},037,012,,,,.T.,,"",,,,.F. )
			oBtn1:lVisible := IIF(cBalanca == "F00001", .F., .T.)
			oDlg2:Activate(,,,.T.)
		EndIf
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019BLSV  ºAutor  ³Marcelo Joner   º    Data ³  14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por ler o arquivo de configuração da     º±±
±±º          ³balança e retornar o código da mesma caso exista.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019BLSV()

	Local lLoad		:= .F.
	Local cPath		:= GetTempPath()
	Local nBalanca	:= 1

	Private cEOL	:= "CHR(13) + CHR(10)"
	Private cArqTxt	:= cPath + "\balanca" + ALLTRIM(STR(nBalanca)) + ".ini"
	Private nHdl	:= fOpen(cArqTxt)
	Private cAlias	:= GetNextAlias()

	cEOL := &cEOL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa procedimentos de abertura do arquivo de configuração da balança utilizada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If nHdl != -1
		lLoad := .T.
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso tenha encontrado o arquivo de configuração da balança,    ³
//³realiza os procedimentos de leitura e validação da configuração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lLoad
		nTamFile := fSeek(nHdl, 0, 2)
		fSeek(nHdl,0,0)
		nTamLin  := LEN(cEOL) + TAMSX3("ZM0_COD")[1]
		cBalanca := SPACE(nTamLin)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Carrega código da balança presente no arquivo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If fRead(nHdl, @cBalanca, nTamLin) > 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Fecha o arquivo de balança manipulado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !FCLOSE(nHdl)
				U_GLALL001("Atenção", "Ocorreram erros ao fechar o arquivo de configuração da balança.", "Não foi possível fechar o arquivo " + cArqTxt + "." + CHR(13) + CHR(13) + "Esta falha pode afetar no processo de remoção da integração da balança com à rotina de pesagens.")
			EndIf
			Return ALLTRIM(cBalanca)
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Caso ocorreram erros na leitura do arquivo, alerta o usuario³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			U_GLALL001("Atenção", "Ocorreram erros na leitura do arquivo de configuração da balança.", "Não foi possível ler o arquivo " + cArqTxt)
			Return "F00001"
		EndIf
	Else
		Return "F00002"
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha o arquivo de balança manipulado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !FCLOSE(nHdl)
		U_GLALL001("Atenção", "Ocorreram erros ao fechar o arquivo de configuração da balança", "Não foi possível fechar o arquivo " + cArqTxt + "." + CHR(13) + CHR(13) + "Esta falha pode afetar no processo de remoção da integração da balança com à rotina de pesagens.")
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019BLEXC   ºAutor  ³Marcelo Joner    º Data ³  14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela exclusão do arquivo de configuração º±±
±±º          ³da balança.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019BLEXC()

	Local nBalanca	:= 1
	Local cPath		:= GetTempPath()
	Local cArqTxt 	:= cPath + "balanca" + ALLTRIM(STR(nBalanca)) + ".ini"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa os procedimentos de exclusão do arquivo de integração da balança com a rotina de romaneio de grãos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FERASE(cArqTxt) == -1
		Aviso("Atenção", "Não foi possível remover o arquivo: " + CHR(13) + CHR(13) + cArqTxt, {"OK"}, 2)
	Else
		Aviso("Atenção", "O arquivo: " + CHR(13) + CHR(13) + cArqTxt + CHR(13) + CHR(13) + " referente à integração com a balança " + STRZERO(nBalanca, 2) + " foi excluído com sucesso.", {"OK"}, 2)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa os procedimentos de atualização dos componentes na tela³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		oBrw1:aCols := {}
		oBrw1:oBrowse:Refresh()
		oBtn1:lVisible := .F.
		oBtn1:Refresh()
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019TP   ºAutor  ³Marcelo Joner        º Data ³ 14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função vinculada como validação do campo ZM1_TIPO.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019TP()
	Local lRet   := .T.
	Local cTpPrd := POSICIONE("SB1", 1, xFilial("SB1") + M->ZM1_PROD, "B1_TIPO")
	Local lTrava := SuperGetMV("MV_ZL00012",,.F.)
	Local cPrdSer := GETMV("MV_ZL00013",, "")
	Local cClifor := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa procedimentos de analise/substituíção da consulta padrão³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If M->ZM1_TIPO == "1" .OR. (ALLTRIM(M->ZM1_PROD) $ cPrdSer)
		aTrocaF3 := {{"ZM1_CLIFOR",	"SA2"}}
		cCliFor  := POSICIONE("SA2", 1, xFilial("SA2") + M->ZM1_CLIFOR, "A2_COD")
	Else
		aTrocaF3 := {{"ZM1_CLIFOR",	"SA1"}}
		cCliFor  := POSICIONE("SA1", 1, xFilial("SA1") + M->ZM1_CLIFOR, "A1_COD")
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Garante que os campos de CODIGO, LOJA e NOME sejam resetados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If Empty(cClifor)
		M->ZM1_CLIFOR := CRIAVAR("ZM1_CLIFOR")
		M->ZM1_LOJA   := CRIAVAR("ZM1_LOJA")
		M->ZM1_NOME   := CRIAVAR("ZM1_NOME")
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica a existencia de CARGA para alimentat os campos e travar a pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	If M->ZM1_TIPO == "2" .AND. ( cTpPrd == "PA" .OR. Empty(cTpPrd)) .AND. ( ALLTRIM(M->ZM1_PROD) # cPrdSer )

		dbSelectArea("ZN1")
		ZN1->(dbSetOrder(3))
		ZN1->(DbGoBottom())

		If ZN1->(dbSeek(xFilial("ZN1") + ALLTRIM(M->ZM1_PLACA)+' '+DTOS(M->ZM1_DATA)))
			dbSelectArea("SC5")
			SC5->(dbSetOrder(12))
			SC5->(dbGoTop())
			If SC5->(dbSeek(xFilial("SC5") + ALLTRIM(ZN1->ZN1_SIMULA)))	
			//ZN1 - ASSOC VEIC
			//SC5 C5_X_SIMU
			M->ZM1_CLIFOR := SC5->C5_CLIENTE
			M->ZM1_LOJA   := SC5->C5_LOJACLI
			M->ZM1_NOME   := POSICIONE("SA1",1,XFILIAL("SA1")+M->ZM1_CLIFOR+M->ZM1_LOJA,"A1_NOME")
			M->ZM1_PEDCOM := SC5->C5_NUM
			M->ZM1_NFCOM := SC5->C5_NOTA
			M->ZM1_SRCOM := SC5->C5_SERIE
			M->ZM1_TIPO := "2"
			//M->ZM1_NOMMOT := ZN1->ZN1_NOMMOT

			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			SC6->(dbGoTop())
			If SC6->(dbSeek(xFilial("SC6") + ALLTRIM(SC5->C5_NUM)))	
				M->ZM1_PROD := SC6->C6_PRODUTO
				
			EndIf
			

		EndIf
		ElseIf lTrava
			Aviso("Atenção", "Não foi possível encontrar a carga nesse dia para a placa: " + CHR(13) + CHR(13) + M->ZM1_PLACA, {"OK"}, 2)
			lRet := !lTrava
		EndIf
	EndIf
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019CG   ºAutor  ³Alexandre Longhinotti ºData ³ 14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função verifica a existencia de carga para a placa informadaº±±
±±º          ³ na validação do campo                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019CG()
	Local lRet   := .T.
/*Local lTrava := SuperGetMV("MV_ZL00012",,.F.)
Local cClifor := ""*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica a existencia de CARGA para alimentar os campos da pesagem            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("ZN1")
	ZN1->(dbSetOrder(3))
	ZN1->(DbGoBottom())
	If ZN1->(dbSeek(xFilial("ZN1") + ALLTRIM(M->ZM1_PLACA)+' '+DTOS(M->ZM1_DATA)))
			
		dbSelectArea("SC5")
		SC5->(dbSetOrder(12))
		SC5->(dbGoTop())
		If SC5->(dbSeek(xFilial("SC5") + ALLTRIM(ZN1->ZN1_SIMULA)))	
			//ZN1 - ASSOC VEIC
			//SC5 C5_X_SIMU
			M->ZM1_CLIFOR := SC5->C5_CLIENTE
			M->ZM1_LOJA   := SC5->C5_LOJACLI
			M->ZM1_NOME   := POSICIONE("SA1",1,XFILIAL("SA1")+M->ZM1_CLIFOR+M->ZM1_LOJA,"A1_NOME")
			M->ZM1_PEDCOM := SC5->C5_NUM
			M->ZM1_NFCOM := SC5->C5_NOTA
			M->ZM1_SRCOM := SC5->C5_SERIE
			M->ZM1_TIPO := "2"
			//M->ZM1_NOMMOT := ZN1->ZN1_NOMMOT

			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			SC6->(dbGoTop())
			If SC6->(dbSeek(xFilial("SC6") + ALLTRIM(SC5->C5_NUM)))	
				M->ZM1_PROD := SC6->C6_PRODUTO
				
			EndIf
			

		EndIf
	Else
		U_LT019PRD()
	EndIf
 

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019CG2  ºAutor  ³Alexandre Longhinotti ºData ³ 14/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função verifica a existencia de carga para a placa informadaº±±
±±º          ³ na confirmação dos dados iniciais da pesagem               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019CG2()
	Local lRet   := .T.

	dbSelectArea("ZN1")
	ZN1->(dbSetOrder(3))
	ZN1->(DbGoBottom())
	If !ZN1->(dbSeek(xFilial("ZN1") + ALLTRIM(M->ZM1_PLACA)+' '+DTOS(M->ZM1_DATA)))
		lRet   := .F.
	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019SHW   ºAutor  ³Marcelo Joner       º Data ³ 17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função referente à interface para informação da placa do    º±±
±±º          ³veículo antes da abertura da pesagem.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019SHW()

	Local aArea			:= GetArea()
	Local aSize			:= {}
	Local aObjects		:= {}
	Local aInfo			:= {}
	Local aPosObj		:= {}
	Local nOpc			:= 2
	Local lRet			:= .F.
	Local lShare		:= .T.
	Local lReadOnly		:= .F.
	Local aItems:= {'1=Descarga','2=Carga'}
	Local nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Montagem dos parâmetros para criação da tela de exibição³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aSize := MsAdvSize()
	AAdd(aObjects, {100, 040, .T., .F.})
	AAdd(aObjects, {100, 060, .T., .F.})
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ] / 2, aSize[ 4 ] / 2, 5, 5 }
	aPosObj := MsObjSize(aInfo, aObjects, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta dialog para informar à placa, produto e tipo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cCombo1:= aItems[1]


	oDlgY := MSDialog():New(000,000,0130,280,"Abertura - Informe a Placa",,,.F.,,,,,,.T.,,,.T. )
	oSayPlaca := TSay():New(010,004,{|| "Placa"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	@ 009, 040 MSGET oPlaca  	VAR M->ZM1_PLACA VALID U_LT019CG()	PICTURE PesqPict("ZM1", "ZM1_PLACA") OF oDlgY WHEN .T. PIXEL SIZE 030,008 HASBUTTON

	oSayProd := TSay():New(022,004,{|| "Produto"},oDlgY,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	@ 022, 040 MSGET oProd  	VAR M->ZM1_PROD  F3 "SB1" VALID U_LT019VPD() PICTURE PesqPict("SB1", "B1_COD")  SIZE 055,008 OF oDlgY WHEN .T. PIXEL SIZE 030,008 HASBUTTON
	If ExistTrigger('ZM1_PROD')
		RunTrigger(1,,nil,,'ZM1_PROD')
	EndIf
	oCombo1 := TComboBox():New(036,012,{|u|if(PCount()>0,M->ZM1_TIPO:=u,M->ZM1_TIPO)},aItems,50,20,oDlgY,,,,,,.T.,,,,,,,,,'M->ZM1_TIPO','Tipo        ', 2)
	oCombo1:SetHeight( 23 )

	oBtnPlaca := TButton():New(036, 90, "&Confirmar", oDlgY, {|| IIF(U_LT019TP(),(nOpc := 1, oDlgY:End()),)}, 030, 012,,,, .T.,,"",,,, .F.)

	oDlgY:Activate(,,,.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Confirmando à tela, verifica pesagem anterior para placa informada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If nOpc == 1
		lRet := .T.

		IF !U_LT019CG2()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Monta estrutura da tabela temporaria³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aStruct := ZM1->(dbStruct())
			cAliasPLA := GetNextAlias()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Busca último romaneio feito com à placa informada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cQuery := "SELECT ZM1.*																	" + CRLF

			cQuery += "FROM " + RetSQLName("ZM1") + " ZM1											" + CRLF

			cQuery += "WHERE ZM1.ZM1_FILIAL  = '" + xFilial("ZM1") + "'								" + CRLF
			cQuery += "  AND ZM1.ZM1_NUM     = (SELECT MAX(ZM12.ZM1_NUM) ZM1_NUM					" + CRLF
			cQuery += "                           FROM " + RetSQLName("ZM1") + " ZM12				" + CRLF
			cQuery += "                          WHERE ZM12.ZM1_FILIAL  = '" + xFilial("ZM1") + "'	" + CRLF
			cQuery += "                            AND ZM12.ZM1_PLACA   = '" + M->ZM1_PLACA   + "'	" + CRLF
			cQuery += "                            AND ZM12.D_E_L_E_T_ <> '*')						" + CRLF

			cTabTMP  := CriaTrab(aStruct, .T.)

			If Select(cAliasPLA) > 0
				(cAliasPLA)->(dbCloseArea())
			EndIf

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPLA,.T.,.T.)
			For nX := 1 To len(aStruct)
				If aStruct[nX][2] <> "C" .And. FieldPos(aStruct[nX][1])<>0
					TcSetField(cAliasPLA,aStruct[nX][1],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4])
				EndIf
			Next nX

			Copy TO &cTabTMP
			dBCloseArea()
			dBUseArea(.T.,, cTabTMP, cAliasPLA, lShare, lReadOnly)
			(cAliasPLA)->(dbGoTop())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Carrega informações caso encontrou pesagem anterior do veículo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If !EMPTY((cAliasPLA)->ZM1_NUM)
				lPeso := .T.
				//M->ZM1_TIPO		:= (cAliasPLA)->ZM1_TIPO
				//M->ZM1_PROD		:= (cAliasPLA)->ZM1_PROD
				//M->ZM1_DESC		:= (cAliasPLA)->ZM1_DESC
				M->ZM1_CLIFOR	:= (cAliasPLA)->ZM1_CLIFOR
				M->ZM1_LOJA		:= (cAliasPLA)->ZM1_LOJA
				M->ZM1_NOME		:= (cAliasPLA)->ZM1_NOME
				M->ZM1_TRANSP	:= (cAliasPLA)->ZM1_TRANSP
				M->ZM1_DTRANS	:= POSICIONE("SA4", 1, xFilial("SA4") + M->ZM1_TRANSP, "A4_NOME")
				M->ZM1_REBOQ1	:= (cAliasPLA)->ZM1_REBOQ1
				M->ZM1_REBOQ2	:= (cAliasPLA)->ZM1_REBOQ2
				M->ZM1_CODVEI	:= (cAliasPLA)->ZM1_CODVEI
				M->ZM1_CODMOT	:= (cAliasPLA)->ZM1_CODMOT
				M->ZM1_NOMMOT	:= (cAliasPLA)->ZM1_NOMMOT
				M->ZM1_NRTNQ	:= (cAliasPLA)->ZM1_NRTNQ

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa função para garantir atualização de campos conforme definições do cadastro do VEICULO³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				U_LT019VPD()
			EndIf
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Estorna número do romaneio que não será aberto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		ZM1->(ROLLBACKSX8())
	EndIf

	RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019PRD  ºAutor  ³Alexandre Longhi     º Data ³ 17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função verifica pesagem anterior para placa e prd informada º±±
±±º          ³ na rotina de pesagens.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019PRD()
	Local lRet			:= .T.
	Local lShare		:= .T.
	Local lReadOnly		:= .F.
	Local nX
//Local cPrdLin	:= GETMV("MV_ZL00005",, "")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta estrutura da tabela temporaria³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aStruct := ZM1->(dbStruct())
	cAliasPLA := GetNextAlias()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Busca último romaneio feito com à placa informada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cQuery := "SELECT ZM1.*																	" + CRLF

	cQuery += "FROM " + RetSQLName("ZM1") + " ZM1											" + CRLF

	cQuery += "WHERE ZM1.ZM1_FILIAL  = '" + xFilial("ZM1") + "'								" + CRLF
	cQuery += "  AND ZM1.ZM1_NUM     = (SELECT MAX(ZM12.ZM1_NUM) ZM1_NUM					" + CRLF
	cQuery += "                           FROM " + RetSQLName("ZM1") + " ZM12				" + CRLF
	cQuery += "                          WHERE ZM12.ZM1_FILIAL  = '" + xFilial("ZM1") + "'	" + CRLF
	cQuery += "                            AND ZM12.ZM1_PLACA   = '" + M->ZM1_PLACA   + "'	" + CRLF
	cQuery += "                            AND ZM12.D_E_L_E_T_ <> '*')						" + CRLF

	cTabTMP  := CriaTrab(aStruct, .T.)

	If Select(cAliasPLA) > 0
		(cAliasPLA)->(dbCloseArea())
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPLA,.T.,.T.)
	For nX := 1 To len(aStruct)
		If aStruct[nX][2] <> "C" .And. FieldPos(aStruct[nX][1])<>0
			TcSetField(cAliasPLA,aStruct[nX][1],aStruct[nX][2],aStruct[nX][3],aStruct[nX][4])
		EndIf
	Next nX

	Copy TO &cTabTMP
	dBCloseArea()
	dBUseArea(.T.,, cTabTMP, cAliasPLA, lShare, lReadOnly)
	(cAliasPLA)->(dbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Carrega informações caso encontrou pesagem anterior do veículo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !EMPTY((cAliasPLA)->ZM1_NUM)
		lPeso := .T.
		M->ZM1_TIPO		:= (cAliasPLA)->ZM1_TIPO
		M->ZM1_PROD		:= (cAliasPLA)->ZM1_PROD
		M->ZM1_DESC		:= (cAliasPLA)->ZM1_DESC
		M->ZM1_CLIFOR	:= (cAliasPLA)->ZM1_CLIFOR
		M->ZM1_LOJA		:= (cAliasPLA)->ZM1_LOJA
		M->ZM1_NOME		:= (cAliasPLA)->ZM1_NOME
		M->ZM1_TRANSP	:= (cAliasPLA)->ZM1_TRANSP
		M->ZM1_DTRANS	:= POSICIONE("SA4", 1, xFilial("SA4") + M->ZM1_TRANSP, "A4_NOME")
		M->ZM1_REBOQ1	:= (cAliasPLA)->ZM1_REBOQ1
		M->ZM1_REBOQ2	:= (cAliasPLA)->ZM1_REBOQ2
		M->ZM1_CODVEI	:= (cAliasPLA)->ZM1_CODVEI
		M->ZM1_CODMOT	:= (cAliasPLA)->ZM1_CODMOT
		M->ZM1_NOMMOT	:= (cAliasPLA)->ZM1_NOMMOT
		M->ZM1_NRTNQ	:= (cAliasPLA)->ZM1_NRTNQ
	EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019LIN  ºAutor  ³Marcelo Joner        º Data ³ 17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação vinculada ao campo referente há linha   º±±
±±º          ³de coleta na rotina de pesagens.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019LIN()

	Local lRet		:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa demais regras caso tenha sido informado uma linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !Vazio()
		If ExistCpo("ZL0")
			dbSelectArea("ZL0")
			ZL0->(dbSetOrder(1))
			ZL0->(dbGoTop())
			ZL0->(dbSeek(xFilial("ZL0") + M->ZM1_CODLIN))
			If ZL0->ZL0_TRANSP != M->ZM1_TRANSP
				//U_GLALL001("Atenção", "A linha informada não está vinculada ao transportador da pesagem.", "Favor informar uma linha vinculada ao transportador.")
				If Aviso("Atenção", "A linha informada não está vinculada ao transportador da pesagem. Deseja alterar o transportador?" , {"&Sim", "&Não"}, 2) == 2
					lRet := .F.
				Else
					M->ZM1_TRANSP := ZL0->ZL0_TRANSP
					M->ZM1_DTRANS := ZL0->ZL0_NOMTRP
					M->ZM1_CLIFOR := POSICIONE("SA4", 1, xFilial("SA4") + ZL0->ZL0_TRANSP, "A4_X_FORN")
					M->ZM1_LOJA   := POSICIONE("SA4", 1, xFilial("SA4") + ZL0->ZL0_TRANSP, "A4_X_LOJF")
					M->ZM1_NOME   := POSICIONE("SA4", 1, xFilial("SA4") + ZL0->ZL0_TRANSP, "A4_NOME")
					lRet := U_LTMOV9MT()
				EndIf
			ElseIf !U_LTMOV9MT()
				lRet := .F.
			EndIf

		Else
			lRet := .F.
		EndIf
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019MRK  ºAutor  ³Marcelo Joner        º Data ³ 15/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação vinculada ao grid de analises de quali- º±±
±±º          ³dade presente na sessão de Pesagem.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT019MRK()

	Local nPos	:= (cAliasQLD)->(RECNO())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Permite marcar apenas um registro do grid por vez³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If !EMPTY((cAliasQLD)->OK)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se o registro selecionado esta com status DESCARTE³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ALLTRIM((cAliasQLD)->ZM3_STATUS) == "DESCARTE"
			(cAliasQLD)->(dbGoTop())
			While (cAliasQLD)->(!EOF())
				If (cAliasQLD)->(RECNO()) <> nPos
					RECLOCK(cAliasQLD, .F.)
					(cAliasQLD)->OK := SPACE(2)
					(cAliasQLD)->(MSUNLOCK())
				EndIf
				(cAliasQLD)->(dbSkip())
			End
			(cAliasQLD)->(dbGoTo(nPos))
			oMarQld:oBrowse:Refresh()
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Alerta o usuáiro pois à análise selecionada não está como descarte³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			U_GLALL001("Atenção", "A análise de qualidade selecionada não pode ser utilizada.", "Somente é possível utilizar as análises que estejam com o status como DESCARTE.")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Remove à marcação da análise de qualidade utilizada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RECLOCK(cAliasQLD, .F.)
			(cAliasQLD)->OK := SPACE(2)
			(cAliasQLD)->(MSUNLOCK())
		EndIf
	EndIf

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT019VPD  ºAutor  ³Marcelo Joner        º Data ³ 05/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela validação do código do produto na   º±±
±±º          ³interface da Pesagem.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LT019VPD()

	Local lRet		:= .F.
	Local cPrdLin	:= GETMV("MV_ZL00005",, "")
	Local cPrdSer 	:= GETMV("MV_ZL00013",, "")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa demais regras caso o código informado seja válido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If VAZIO() .Or. EXISTCPO("SB1")
		lRet := .T.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras para busca das informações do Veículo pela Placa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !EMPTY(M->ZM1_PROD)
			If (ALLTRIM(M->ZM1_PROD) $ cPrdSer)
				M->ZM1_TIPO := "2"
			EndIf
			M->ZM1_DESC := POSICIONE("SB1", 1, xFilial("SB1") + M->ZM1_PROD, "B1_DESC")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Caso seja produto com controle de LINHA, puxa informações do VEICULO para à pesagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If ALLTRIM(M->ZM1_PROD) $ cPrdLin
				dbSelectArea("DA3")
				DA3->(dbSetOrder(3))
				DA3->(dbGoTop())
				If DA3->(dbSeek(xFilial("DA3") + SUBSTR(M->ZM1_PLACA, 1, TAMSX3("DA3_PLACA")[1])))
					M->ZM1_CODVEI := DA3->DA3_COD
					M->ZM1_NRTNQ  := DA3->DA3_X_QTAN

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém informações do FORNECEDOR vinculado ao VEICULO³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(DA3->DA3_CODFOR) .AND. !EMPTY(DA3->DA3_LOJFOR)
						M->ZM1_CLIFOR	:= DA3->DA3_CODFOR
						M->ZM1_LOJA		:= DA3->DA3_LOJFOR
						M->ZM1_NOME		:= POSICIONE("SA2", 1, xFilial("SA2") + DA3->DA3_CODFOR + DA3->DA3_LOJFOR, "A2_NOME")
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém informações do TRANSPORTADOR vinculado ao VEICULO³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(DA3->DA3_X_TRP)
						M->ZM1_TRANSP	:= DA3->DA3_X_TRP
						M->ZM1_DTRANS	:= POSICIONE("SA4", 1, xFilial("SA4") + DA3->DA3_X_TRP, "A4_NOME")
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Obtém informações do MOTORISTA vinculado ao VEICULO³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					If !EMPTY(DA3->DA3_MOTORI)
						M->ZM1_CODMOT	:= DA3->DA3_MOTORI
						M->ZM1_NOMMOT	:= POSICIONE("DA4", 1, xFilial("DA4") + DA3->DA3_MOTORI, "DA4_NOME")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return lRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV9TP  ºAutor  ³Marcelo Joner        º Data ³ 07/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela atualização do ZM1_TIPO conforme à  º±±
±±º          ³avaliação realizada sob os campos de peso entrada\saída.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV9TP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso esteja editando manualmente KG ENTRADA ou KG SAIDA valida peso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If "ZM1_KGINI" $ ALLTRIM(READVAR()) .OR. "ZM1_KGFIN" $ ALLTRIM(READVAR())
		If !POSITIVO()
			Return .F.
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Peso de SAIDA maior que peso de ENTRADA - TIPO CARGA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If M->ZM1_KGFIN > 0
		If M->ZM1_KGFIN > M->ZM1_KGINI
			M->ZM1_TIPO  := "2"
			M->ZM1_KGBRT := ROUND((M->ZM1_KGFIN - M->ZM1_KGINI), TAMSX3("ZM1_KGBRT")[2])
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Peso ENTRADA maior que peso SAÍDA - TIPO DESCARGA³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			M->ZM1_TIPO  := "1"
			M->ZM1_KGBRT := ROUND((M->ZM1_KGINI - M->ZM1_KGFIN), TAMSX3("ZM1_KGBRT")[2])
		EndIf
	EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV9MT  ºAutor  ³Marcelo Joner        º Data ³ 26/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de validação de Mov Transportador quando a linha de  º±±
±±º          ³for informada					                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV9MT(cPlaca)

	Local lRet		:= .T.
	DEFAULT cPlaca := M->ZM1_PLACA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa validação quando trata-se de edição da PLACA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	If !EMPTY(cPlaca)
		cQuery := "SELECT COUNT(*) TOTAL									" + CRLF
		cQuery += "FROM " + RetSQLName("ZL7") + " ZL7						" + CRLF
		cQuery += "WHERE ZL7.ZL7_FILIAL  = '" + xFilial("ZL7")    	+ "'	" + CRLF
		cQuery += "  AND ZL7.ZL7_TRANSP  = '" + M->ZM1_TRANSP     	+ "'	" + CRLF
		cQuery += "  AND ZL7.ZL7_LINHA   = '" + M->ZM1_CODLIN      	+ "'	" + CRLF
		cQuery += "  AND ZL7.ZL7_PLACA   = '" + cPlaca 	  			+ "'	" + CRLF
		cQuery += "  AND ZL7.ZL7_DATA    = '" + DTOS(M->ZM1_DATA)	+ "'	" + CRLF
		cQuery += "  AND ZL7.D_E_L_E_T_ <> '*'								" + CRLF

		cAliasTMP := GetNextAlias()

		If Select(cAliasTMP) > 0
			(cAliasTMP)->(dbCloseArea())
		EndIf

		dBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)

		If (cAliasTMP)->TOTAL == 0
			U_LTALL001("Atenção", "Não existe Mov. Transportador para à data, linha, transportador e placa informada.","Favor providenciar à inclusão de Mov. Transportador referente à Placa desta Pesagem.")
			lRet := .F.
		EndIf
	EndIf


Return lRet


User Function XSTPROT()
	Local _lRet := .F.

	DbSelectArea('ZM4')
	ZM4->(DbSetOrder(1))
	ZM4->(dbGoTop())
	ZM4->(dbSeek(xFilial("ZM4")+ZM1->ZM1_NUM))
	While !ZM4->(eof()) .AND. ZM4->ZM4_FILIAL+ZM4->ZM4_NUM == xFilial("ZM4")+ZM1->ZM1_NUM
		If ZM4->ZM4_STATUS == 'P'
			_lRet := .T.
			exit
		EndIf
		ZM4->(dbSkip())
	EndDo

Return _lRet


User Function LTPRCSOL()

	Local nPrcSol		:= 0
	Local cQuery		:= ""
	Local cAliasTMP		:= GetNextAlias()
	Local hEnter		:= CHR(10)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Composição da consulta SQL de análise dos registros
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cQuery := "SELECT ZME.ZME_PRECO				                        " + hEnter
	cQuery += "FROM " + RetSQLName("ZME") + " ZME				        " + hEnter
	cQuery += "WHERE ZME.ZME_FILIAL  = '" + xFilial("ZME")        + "'	" + hEnter
	cQuery += "  AND ZME.ZME_PROD       = '" + M->ZM1_PROD        + "'  " + hEnter
	cQuery += "  AND ZME.ZME_FORNEC     = '" + M->ZM1_CLIFOR      + "'	" + hEnter
	cQuery += "  AND ZME.ZME_LOJA       = '" + M->ZM1_LOJA        + "'	" + hEnter
	cQuery += "  AND ZME.ZME_DTDE     <= '" + dtos(M->ZM1_DATA)     + "'	" + hEnter
	cQuery += "  AND ZME.ZME_DTATE    >= '" + dtos(M->ZM1_DATA)     + "'	" + hEnter
	cQuery += "  AND ZME.D_E_L_E_T_ <> '*'						" + hEnter

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	While ! (cAliasTMP)->(EOF())

		If !EMPTY((cAliasTMP)->ZME_PRECO)
			nPrcSol := (cAliasTMP)->ZME_PRECO
		Endif
		(cAliasTMP)->(dbSkip())
	EndDo
	(cAliasTMP)->(dbCloseArea())

RETURN nPrcSol


User Function LTVERNT()
	Local cAliasTMP 	:= GetNextAlias()
	Local hEnter    	:= CHR(13) + CHR(10)
	Local cQuery 		:= ""
	Local lRet 			:= .T.
	
	cQuery := "SELECT ZM1_NFCOM NOTA" 			+ hEnter
	cQuery += "FROM " + RetSQLName("ZM1") + " ZM1 	"	+ hEnter
	cQuery += "WHERE ZM1_NFCOM ='" +  M->ZM1_NFCOM  + "'" 	+ hEnter
	cQuery += "AND ZM1_SRCOM ='" +  M->ZM1_SRCOM  + "'" 	+ hEnter
	cQuery += "AND ZM1_CLIFOR ='" +  M->ZM1_CLIFOR  + "'" 	+ hEnter
	cQuery += "AND ZM1_LOJA ='" +  M->ZM1_LOJA  + "'" 	+ hEnter
	cQuery += "AND ZM1.D_E_L_E_T_ <> '*'" 	+ hEnter

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	If !Empty(Alltrim((cAliasTMP)->NOTA))
		U_GLALL001("Atenção", "Os campos referentes à Nota Fiscal e Série do fornecedor estão inconsistentes.", "O número e série informados já foram utilizados em outra pesagem.")
		lRet 			:= .F.
	EndIf

Return lRet
