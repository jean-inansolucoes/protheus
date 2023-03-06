//------------------------------------------------------------------------
/*
EXEMPLO DE INCLUSÃO
*/
//------------------------------------------------------------------------
 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
 
User Function TMATA241()
Local _aCab1    := {}
Local _aItem    := {}
Local _atotitem := {}
Local cCodigoTM := "001"
Local cCodProd  := "01010004 "
Local cUnid     := "L "
 
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
 
//Private _acod := {"1","MP1"}
 
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01LAT01" MODULO "EST"
 
_aCab1 := {{"D3_DOC" ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
          {"D3_TM" ,cCodigoTM , NIL},;
          {"D3_CC" ,"10.03.02.003", NIL},;
          {"D3_EMISSAO" ,ddatabase, NIL}}
 
 
_aItem:={{"D3_COD" ,cCodProd ,NIL},;
  {"D3_UM" ,cUnid ,NIL},;
  {"D3_QUANT" ,570 ,NIL},;
  {"D3_LOCAL" ,"02" ,NIL},;
  {"D3_LOTECTL" ,"",NIL},;
  {"D3_LOCALIZ" , "",NIL},;
  {"D3_OBSERVA", "NumSeq SD1: 99SN3N", NIL}}
 
aadd(_atotitem,_aitem)
MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
 
If lMsErroAuto
    Mostraerro()
    DisarmTransaction()
    break
EndIf
 
Return
