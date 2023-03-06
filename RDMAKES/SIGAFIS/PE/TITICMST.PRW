//============================================================================\
/*/{Protheus.doc}TITICMST
  ==============================================================================
    @description
    Descrição da função
    Ponto de entrada para alterar a natureza no titulo do imposto na apuração.
    @author Alexandre Longhinotti <ti@tresbarras.ind.br>
    @version 1.0
    @since 13/04/2021

/*/
//============================================================================\

#Include "protheus.ch"

User Function TITICMST
Local cOrigem := PARAMIXB[1]
Local cTipoImp := PARAMIXB[2]
Local lDifal := PARAMIXB[3]
 
//Apuracao de ISS
If AllTrim(cOrigem)='MATA954' //Apuracao de ISS
   
EndIf

//ICMS 
If AllTrim(cTipoImp)='1' // ICMS
    SE2->E2_VENCTO := DataValida(dDataBase+10,.T.)
    SE2->E2_VENCREA := DataValida(dDataBase+10,.T.)
EndIf

//ICMS ST
If AllTrim(cTipoImp)='3' // ICMS ST
    SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
    SE2->E2_VENCTO := DataValida(dDataBase+50,.T.)
    SE2->E2_VENCREA := DataValida(dDataBase+50,.T.)
    SE2->E2_NATUREZ := '20401007'
EndIf
 
//EXEMPLO 3 (lDifal)
If lDifal // DIFAL
  
EndIf
 
Return {SE2->E2_NUM,SE2->E2_VENCTO}
