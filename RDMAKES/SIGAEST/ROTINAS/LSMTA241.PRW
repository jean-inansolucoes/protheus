#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSMTA241  ºAutor  ³                     Data ³  30/11/2021  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa apra efetuar o movimento interno multiplo         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS TRELAC                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LSMTA241(aDadosMov,cOpcao)

	Local aArea	    := GetArea()
	Local aCab 		:= {}
	Local aItem 	:= {}
	Local aTotItem	:= {}
	Local cObserva  := ""

	Private lMsHelpAuto := .T. // se .T. direciona as mensagens de help
	Private lMsErroAuto := .F. //necessario a criacao
//Private l241Auto    := .T. //Não apresenta mensagem de confirmação

/*
aDadosMov[01] Filial	
aDadosMov[02] Tipo Movimento
aDadosMov[03] Produto	
aDadosMov[04] Unidade Medida    
aDadosMov[05] Local
aDadosMov[06] Quantidade	
aDadosMov[07] Valor	
aDadosMov[08] Nro Documento	
aDadosMov[09] Serie Documento
aDadosMov[10] Fornecedor
aDadosMov[11] Loja
aDadosMov[12] Lote	
aDadosMov[13] Data Digitação
aDadosMov[14] Centro de Custo
aDadosMov[15] NUMSEQ Numero Sequencial  
*/

/* LEITE LTMOV002
aDadosMov[01] Filial	
aDadosMov[02] Tipo Movimento
aDadosMov[03] Produto	
aDadosMov[04] Unidade Medida    
aDadosMov[05] Local
aDadosMov[06] Quantidade	
aDadosMov[07] Nro Documento	
aDadosMov[08] Data Digitação
aDadosMov[09] NUMSEQ Numero Sequencial  
*/

//***************************************************
// Define a opção de Inclusão ou estorno do Movimento
//***************************************************
	If cOpcao == "I"     //Inclulsão
		nOpcao := 3
	ElseIf cOpcao == "E" //Estorno
		nOpcao  := 6
	EndIf

	aCab := {}
	aItem:={}

	IF cOpcao == "E" //Estorno

		If  ALLTRIM(aDadosMov[03]) == AllTRIM(GetMV("MV_ZLTPRD")) // LEITE LTMOV002

            SD3->(DbgoTop())
		    SD3->(DbSetOrder(3))//D3_FILIAL, D3_COD, D3_LOCAL, D3_NUMSEQ
		    SD3->(DbSeek(xFilial("SD3") + aDadosMov[03] + aDadosMov[05] + aDadosMov[09] ))

            aCab := {   {"D3_TM"		,aDadosMov[02]	, NIL},;
				{"D3_EMISSAO" 	,aDadosMov[08]  , NIL}}

			aItem:={ 	{"D3_COD" 		,ALLTRIM(aDadosMov[03]) 	,NIL},;
				{"D3_UM" 		,aDadosMov[04] 	,NIL},;
				{"D3_QUANT" 	,aDadosMov[06]  ,NIL},;
				{"D3_LOCAL" 	,aDadosMov[05]	,NIL},;
				{"INDEX" 	    ,3	            ,NIL}}
		Else
			
            SD3->(DbgoTop())
		    SD3->(DbSetOrder(3))//D3_FILIAL, D3_COD, D3_LOCAL, D3_NUMSEQ
		    SD3->(DbSeek(xFilial("SD3") + aDadosMov[03] + aDadosMov[05] + aDadosMov[15] ))
            
            aCab := {   {"D3_TM"		,aDadosMov[02]	, NIL},;
				{"D3_EMISSAO" 	,aDadosMov[13]  , NIL}}

			aItem:={ 	{"D3_COD" 		,ALLTRIM(aDadosMov[03]) 	,NIL},;
				{"D3_UM" 		,aDadosMov[04] 	,NIL},;
				{"D3_QUANT" 	,aDadosMov[06]  ,NIL},;
				{"D3_LOCAL" 	,aDadosMov[05]	,NIL},;
				{"D3_LOTECTL" 	,aDadosMov[12]	,NIL},;
				{"INDEX" 	    ,3	            ,NIL}}
		EndIf
	
    ElseIf  ALLTRIM(aDadosMov[03]) == AllTRIM(GetMV("MV_ZLTPRD")) //Inclusão

		aCab := {  	{"D3_DOC"		,ALLTRIM(aDadosMov[07])	, NIL},;
			{"D3_TM"		,aDadosMov[02]	, NIL},;
			{"D3_EMISSAO" 	,aDadosMov[08]  , NIL}}

		aItem:={ 	{"D3_COD" 		,aDadosMov[03] 	,NIL},;
			{"D3_UM" 		,aDadosMov[04] 	,NIL},;
			{"D3_QUANT" 	,aDadosMov[06]  ,NIL},;
			{"D3_LOCAL" 	,aDadosMov[05]	,NIL}}
			

	Else

		cObserva := "NumSeq SD1: "+aDadosMov[15]

		aCab := {  	{"D3_DOC"		,ALLTRIM(aDadosMov[08])	, NIL},;
			{"D3_TM"		,aDadosMov[02]	, NIL},;
			{"D3_CC"		,aDadosMov[14]	, NIL},;
			{"D3_EMISSAO" 	,aDadosMov[13]  , NIL}}

		If AllTrim(Posicione("SF5",1,xFilial("SF5") + PadR(aDadosMov[02],TamSx3("F5_CODIGO")[1]),"F5_VAL")) == "S"
			aItem:={ 	{"D3_COD" 		,ALLTRIM(aDadosMov[03]) 	,NIL},;
				{"D3_UM" 		,aDadosMov[04] 	,NIL},;
				{"D3_QUANT" 	,aDadosMov[06]  ,NIL},;
				{"D3_LOCAL" 	,aDadosMov[05]	,NIL},;
				{"D3_CUSTO1" 	,aDadosMov[07] 	,NIL},;
				{"D3_LOTECTL" 	,aDadosMov[12]	,NIL},;
				{"D3_OBSERVA"	,cObserva   	,NIL}}
		Else
			aItem:={ 	{"D3_COD" 		,ALLTRIM(aDadosMov[03]) 	,NIL},;
				{"D3_UM" 		,aDadosMov[04] 	,NIL},;
				{"D3_QUANT" 	,aDadosMov[06]  ,NIL},;
				{"D3_LOCAL" 	,aDadosMov[05]	,NIL},;
				{"D3_LOTECTL" 	,aDadosMov[12]	,NIL},;
				{"D3_OBSERVA"	,cObserva   	,NIL}}
		EndIf
	EndIf
	Aadd(aTotItem,aItem)

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aTotItem,nOpcao)

	If lMsErroAuto
		Mostraerro()
		DisarmTransaction()
		break
	EndIf

	RestArea(aArea)

Return
