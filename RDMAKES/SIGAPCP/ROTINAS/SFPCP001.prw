#include "protheus.ch"
#include "ap5mail.ch"
#include "rwmake.ch"
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SFPCP001  � Autor � FSW TOTVS CASCAVEL � Data � 07/11/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para calculo horas - PCP Mod2					  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TOTVS CASCAVEL                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
**---------------------------------------------------**
User Function SFPCP001()
**---------------------------------------------------**
Local nQtdOper	:= M->H6_X_QTDOP  //M->H6_X_QFUNC 
Local nMinTot	:= 0
Local xHorTot   := 0
Local nHraTot	:= 0
Local cVarRead := ReadVar()

//Verifica se � chamada pela rotina Apontamento PCP Mod2 e se os campos Bases est�o alimentados
IF ISINCALLSTACK("MATA681")// .AND. !EMPTY(M->H6_DATAINI) .AND. !EMPTY(M->H6_HORAINI) .AND. !EMPTY(M->H6_DATAFIN) .AND. !EMPTY(M->H6_HORAFIN)
	//IF Empty(M->H6_X_TEMPO) .OR. Alltrim(cVarRead) # "M->H6_X_QFUNC"
		cTempo := Alltrim(Transform(M->H6_TEMPO, "@E 9999:99"))
		M->H6_X_TEMPO := cTempo
	//ENDIF
	
	xHorTot   := M->H6_X_TEMPO
	 
	//Converte tudo para minutos & Realiza multiplica��o pelo numero de operadores
	nMinTot := Hrs2Min(SUBSTR(M->H6_X_TEMPO,0,AT(":",M->H6_X_TEMPO)-1)) * nQtdOper
	
	nHraTot := nMinTot + (((((VAL(SUBSTR(M->H6_X_TEMPO,AT(":",M->H6_X_TEMPO)+1,2))) * 100)/60) * nQtdOper)*60)/100
		
	//Converte tudo para hora
	xHorTot := Min2Hrs(nHraTot)
	xHorTot := Alltrim(Transform(xHorTot, "@E 9999.99"))
	                 
	//Atualizando o separador
	xHorTot := StrTran(xHorTot, '.', ":")
	xHorTot := StrTran(xHorTot, ',', ":")
	
	If Len(xHorTot) < 7
		xHorTot := Replicate('0', 7-Len(xHorTot)) + xHorTot
	EndIf
//Else
	//xHorTot := M->H6_TEMPO
EndIf
 
Return xHorTot