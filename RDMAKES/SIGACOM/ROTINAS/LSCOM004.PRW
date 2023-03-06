#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSCOM004 ºAutor ³ Alexandre Longhinotti ºData ³ 09/03/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exec-auto Solcitação de compras							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       ³ TRELAC 			      COM                                 ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LSCOM004(aItemSC, lMensagem)
Local AreaAtual := GetArea()
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.       
Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ConOut(Repl("-",80))
ConOut(PadC(OemToAnsi("Iniciando criação automática da Solicitação de Compra."),80))
ConOut(OemToAnsi("Inicio: ")+Time())          
                                       
if lMensagem = nil
     lMensagem := .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿          
//| Verifica numero da SC       |          
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ          

cDoc := GetSXENum("SC1","C1_NUM")          
SC1->(dbSetOrder(1))          
While SC1->(dbSeek(xFilial("SC1")+cDoc))               
     ConfirmSX8()               
     cDoc := GetSXENum("SC1","C1_NUM")          
EndDo                         
aadd(aCabec,{"C1_NUM"    ,cDoc})          
aadd(aCabec,{"C1_SOLICIT",cUserName})          
aadd(aCabec,{"C1_EMISSAO",dDataBase})          
For nX := 1 To Len(aItemSC)
     aLinha := {}               
     aadd(aLinha,{"C1_ITEM"   ,StrZero(nX,Len(SC1->C1_ITEM)),Nil})               
     aadd(aLinha,{"C1_PRODUTO",aItemSC[nX,1],Nil})               
     aadd(aLinha,{"C1_QUANT" ,aItemSC[nX,2],Nil})               
     aadd(aItens,aLinha)          
Next nX          


MSExecAuto({|x,y| mata110(x,y)},aCabec,aItens)          


If lMsErroAuto                
     Mostraerro()
     MsgAlert("Erro na inclusao da Solic. de Compra!", "Atenção")
Else               
     MsgInfo("Solic. Compras "+ cDoc +" incluída com sucesso!", "Info")
     
EndIf     

RestArea(AreaAtual)

Return(.T.)
