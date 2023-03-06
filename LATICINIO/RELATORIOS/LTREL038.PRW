#include "rwmake.ch"
#include "protheus.ch"
#include "epsonlx300.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTREL038     º Autor ³ Marcelo Joner	 º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de impressão de pesagens.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTREL038()

Local cDesc1		:= "Este programa tem como objetivo imprimir relatório "
Local cDesc2		:= "de acordo com os parêmetros informados pelo usuário."
Local cDesc3		:= "Ticket de Pesagem"
Local cPict			:= ""
Local cTitulo		:= "Ticket de Pesagem"
Local imprime		:= .T.
Local aOrd 			:= {}   
Local aDriver		:= ReadDriver()         
Local aArea			:= GetArea()

Private nLin		:= 00
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private nTamLin		:= 128
Private limite		:= 80
Private cTamanho	:= "P"
Private cNomeprog	:= "LTREL038"
Private nTipo		:= 18
Private aReturn		:= {"Zebrado", 1, "Administracao", 2, 2, 1, "", 4}
Private nLastKey	:= 0
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "LTREL038"
Private cCompac		:= aDriver[1]                 
private PaperEsp	:= Chr(27)+Chr(67)+Chr(30)
private PaperOK		:= Chr(27)+Chr(67)+Chr(66)
private NegritOn	:= Chr(27)+Chr(71)
private NegritOff	:= Chr(27)+Chr(72)
private InitPrint	:= Chr(27)+'@'
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Variaveis de controle na impressora do tamanho do papel/via em numero de linhas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Private PaperEsp  	:= Chr(27)+Chr(67)+Chr(36)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Declaração do objeto de impressão³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
wnrel := SetPrint("ZM1",cNomeprog,"",@cTitulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,cTamanho,,.F.,.F.,"EPSON.DRV",,.F.,"LPT1")

If nLastKey == 27
	Return
Endif                                                                      

SetDefault(aReturn, "ZM1")

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa função de impressão do layout do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RptStatus({|| REL038(cTitulo, nLin)}, cTitulo)             

RestArea(aArea)

Return




          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³REL038 º    Autor ³ Marcelo Joner  º     Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. Responsável pela   º±±
±±º          ³ impressão do layout do ticket de pesagem.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function REL038(Titulo,nLin)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Garante posicionamento no ticket atuali³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("ZM1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Seta definições iniciais do objeto de impressão³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
SetRegua(1)     
nLin := 0
@nLin,000 PSAY StartPrint
@nLin,000 PSAY PaperEsp
@nLin,000 PSAY Draft + NegritOn
//nLin++
@nLin,060 PSAY "TICKET BALANCA"
@nLin,000 PSAY Draft + NegritOff
nLin += 1
@ nLin,000 PSAY REPLICATE("-", nTamLin)
nLin++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime o cabeçalho do ticket de pesagem³
//ÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("SM0")
SM0->(dbSetOrder(1))
SM0->(dbGoTop())
SM0->(dbSeek(cEmpAnt + cFilAnt))
@nLin,000 PSAY UPPER(ALLTRIM(SM0->M0_NOMECOM))
@nLin,095 PSAY UPPER(ALLTRIM(SM0->M0_CIDCOB)) + " - " + IIF(SM0->M0_ESTCOB == "PR", "PARANA", IIF(SM0->M0_ESTCOB == "SP", "SAO PAULO", "SANTA CATARINA"))
nLin++
@nLin,000 PSAY UPPER(ALLTRIM(SM0->M0_ENDCOB)) + " - " + ALLTRIM(SM0->M0_COMPCOB)
@nLin,101 PSAY "TELEFONE: (" + SUBSTR(SM0->M0_TEL, 4, 2) + ") " + SUBSTR(SM0->M0_TEL, 7, 4) + "-" + SUBSTR(SM0->M0_TEL, 11, 4)
nLin++
@nLin,000 PSAY "CNPJ: " + TRANSFORM(SM0->M0_CGC, "@R 999.999.999-99")
nLin++
@ nLin,000 PSAY REPLICATE("-", nTamLin)
nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime os dados de entrada\saída da pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@nLin,000 PSAY "** ENTRADA: " + DTOC(ZM1->ZM1_DTINI) + " - " + ZM1->ZM1_HRINI
nLin++
@nLin,000 PSAY "** SAIDA  : " + DTOC(ZM1->ZM1_DTFIN) + " - " + ZM1->ZM1_HRFIN
nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime os dados do cliente\fornecedor e transportador³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@nLin,000 PSAY "EMPRESA   : " + UPPER(ALLTRIM(ZM1->ZM1_NOME))
@nLin,090 PSAY "PLACA: " + TRANSFORM(ZM1->ZM1_PLACA, PESQPICT("ZM1", "ZM1_PLACA"))
nLin++
@nLin,000 PSAY "MOTORISTA : " + UPPER(ALLTRIM(ZM1->ZM1_NOMMOT))
@nLin,090 PSAY "LINHA: " + UPPER(ALLTRIM(ZM1->ZM1_CODLIN))
nLin += 2
@nLin,000 PSAY Draft + NegritOn
@nLin,000 PSAY "TIPO      : " + IIF(ZM1->ZM1_TIPO == "1", "DESCARGA", "CARGA")
nLin++
@nLin,000 PSAY "PESAGEM   : " + UPPER(ALLTRIM(ZM1->ZM1_NUM))
nLin++
@nLin,000 PSAY "PRODUTO   : " + UPPER(ALLTRIM(ZM1->ZM1_DESC))
@nLin,000 PSAY Draft + NegritOff
nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras para composição do KG Descarte³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
nKgDes := 0
dbSelectArea("ZM3")
ZM3->(dbSetOrder(1))
ZM3->(dbGoTop())
If ZM3->(dbSeek(xFilial("ZM3") + ZM1->ZM1_NUM))
	While ZM3->(!EOF()) .AND. ZM3->ZM3_FILIAL == xFilial("ZM3") .AND. ZM3->ZM3_NUM == ZM1->ZM1_NUM
		nKgDes += (ZM3->ZM3_KGANT - ZM3->ZM3_KGPOS)
		ZM3->(dbSkip())
	End
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime os dados de peso da carga³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@nLin,000 PSAY "PESO ENTRADA :"
@nLin,115 PSAY TRANSFORM((ZM1->ZM1_KGINI + nKgDes), PESQPICT("ZM1", "ZM1_KGINI"))
nLin += 1
@nLin,000 PSAY "PESO SAIDA   :"
@nLin,115 PSAY TRANSFORM(ZM1->ZM1_KGFIN, PESQPICT("ZM1", "ZM1_KGFIN"))
nLin += 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso exista KG Descarte, apresenta informações em torno do mesmo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If nKgDes > 0
	@nLin,000 PSAY Draft + NegritOn
	@nLin,000 PSAY "SUBTOTAL     :"
	@nLin,115 PSAY TRANSFORM(ZM1->ZM1_KGBRT + nKgDes, PESQPICT("ZM1", "ZM1_KGBRT"))
	@nLin,000 PSAY Draft + NegritOff
	nLin++
	@nLin,000 PSAY "PESO DESCARTE:"
	@nLin,115 PSAY TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT"))
	nLin++
	@nLin,090 PSAY REPLICATE("-", (nTamLin - 90))
	nLin++
	@nLin,000 PSAY Draft + NegritOn
	@nLin,000 PSAY "PESO LIQUIDO :"
	@nLin,115 PSAY TRANSFORM(nKgDes, PESQPICT("ZM1", "ZM1_KGBRT"))
	@nLin,000 PSAY Draft + NegritOff
	nLin += 2
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Não havendo KG Descarte, imprimir apenas total final³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	@nLin,090 PSAY REPLICATE("-", (nTamLin - 90))
	nLin++
	@nLin,000 PSAY Draft + NegritOn
	@nLin,000 PSAY "PESO LIQUIDO :"
	@nLin,115 PSAY TRANSFORM(ZM1->ZM1_KGBRT, PESQPICT("ZM1", "ZM1_KGBRT"))
	@nLin,000 PSAY Draft + NegritOff
	nLin += 3
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Imprime sessão para assinatura do balanceiro e motorista³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@nLin,000 PSAY "ASS. BALANCEIRO: " + REPLICATE("_", 50)
nLin += 3
@nLin,000 PSAY "ASS. MOTORISTA : " + REPLICATE("_", 50)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Finaliza a execucao do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Se impressao em disco, chama o gerenciador de impressao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()


Return 
