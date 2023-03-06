#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � LTSGPE01 �Autor  � Roberto Issau        �Data  �23/04/2012� ��
�������������������������������������������������������������������������Ĵ��
���Descri��o � CARTAO PONTO                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                

*-----------------------------------------------------------------*
User Function LTSGPE01()                        
*-----------------------------------------------------------------*

LOCAL wnrel                                         
LOCAL cDesc1:="Cartao Ponto"
LOCAL cDesc2:=""
LOCAL cDesc3:=" "

Private nColMc           := 0
Private limite           := 132
Private cConPc           := 0
Private bImpr 			 := .F.
Private tamanho          := "M"
Private nTipo            := 18
PRIVATE titulo           := "Cartao Ponto"
PRIVATE aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
PRIVATE nomeprog         := "LTSGPE02",nLastKey := 0
PRIVATE cString          := "SP8"
Private cBitMap          := "lgrl01.bmp"
Private cBitMap1         := "lgrl02.bmp"
Private cPerg		     := "LTSGPE0201"
Private wnrel  			 := "LTSGP2"
Private oBrush
Private aCoords1 		 := {611,041,699,2290}
Private aCoords2 		 := {2321,041,2419,2290}

ajustaSX1()
IF Pergunte(cPerg,.t.)
	If nLastKey == 27
		Return
	Endif
	
	nHeight10  := 10
	nHeight12  := 12
	nHeight09  := 9
	nheight07  := 7
	nheight06  := 6
	nHeight08  := 8
	nHeight15  := 15
	nheight13  := 13
	nHeight11  := 11
	lBold	   := .T.
	lUnderLine := .T.
	
	Processa( {|lFim| LTSGPEREL3(wnrel,cString,@lFim) },Titulo,"Aguarde.....",.t. )
ENDIF
Return


*-----------------------------------------------------------------*
Static Function LTSGPEREL3(wnrel,cString,lFim)
*-----------------------------------------------------------------*
LOCAL cabec1  := "",cabec2:= "",cabec3:= ""
LOCAL cbCont  := 0
LOCAL bSraFun := .f.
Private nCol  := 50
Private nIncr := 50
Private nPag  := 0

ProcRegua( 10 )

ofont1	:= TFont():New( "Arial",,nheight07,,lBold,,,,,!lUnderLine )
oFont2  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
oFont3  := TFont():New( "Mono AS",,nHeight10,,lBold,,,,,!lUnderLine )
oFont4  := TFont():New( "Arial",,nHeight11,,lBold,,,,,!lUnderLine )
oFont5  := TFont():New( "Arial",,nHeight13,,lBold,,,,,!lUnderLine )
oFont6  := TFont():New( "Arial",,nheight15,,lBold,,,,,!lUnderLine )
oFont7  := TFont():New( "Arial",,nheight12,,lBold,,,,,!lUnderLine )
oFont8  := TFont():New( "Times New Roman",,nheight08,,!lBold,,,,,!lUnderLine )
oFont9	:= TFont():New( "Arial",,nheight07,,lBold,,,,,!lUnderLine )
lFirst	:= .T.
If nLastKey == 27
	Return
Endif

oPrn  := TMSPrinter():New()
//oPrn  := SetPortrait()
oPen  := TPen():New(,7,CLR_BLACK,oPrn)
//li    := 10000
li := 0
m_pag := 1
nPag  := 0
cVar1 := ""
FOR I := 1 TO LEN(mv_par13)
	IF I > 1
		cVar1 += ","
	ENDIF
	cVar1 += "'"+SUBSTR(mv_par13,I,1)+"'"
	
NEXT I
cVar2 := ""
FOR I := 1 TO LEN(mv_par14)
	IF I > 1
		cVar2 += ","
	ENDIF
	cVar2 += "'"+SUBSTR(mv_par14,I,1)+"'"
NEXT I
If lFim
	return .f.
EndIf
    


                    
dbSelectArea("SP8")
dbSetOrder(1)  
 
//If "20"+substr(dtoc(mv_par11),7,2)+substr(dtoc(mv_par11),4,2) $ Getmv("MV_PONMES") .OR. DTOS(mv_par11) >= SUBSTR(Getmv("MV_PONMES"),0,8)        
If SP8->P8_DATA >= mv_par11 .and. SP8->P8_DATA <= mv_par12
	// busca tabela atual de marcacoes SP8
	cQuery := "SELECT P8_FILIAL, P8_MAT, P8_DATA, P8_HORA, P8_CC, P8_TURNO, RA_MAT, RA_NOME, P8_ORDEM "
	cQuery += " FROM "+RetSqlName("SP8")+" AS SP8, "+RetSqlName("SRA")+" AS SRA "
	cQuery += " WHERE  SP8.D_E_L_E_T_ <> '*' AND SRA.D_E_L_E_T_ <> '*' AND "
	cQuery += " SP8.P8_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery += " SP8.P8_MAT BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	cQuery += " SP8.P8_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery += " SP8.P8_TURNO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
	cQuery += " SP8.P8_DATA BETWEEN '"+DTOS(mv_par11)+"' AND '"+DTOS(mv_par12)+"' AND "
	cQuery += " SP8.P8_ORDEM <> '' AND "                                                                                    
	cQuery += "  (SP8.P8_TPMCREP = '') AND "
	cQuery += " SRA.RA_FILIAL = SP8.P8_FILIAL AND "
	cQuery += " SRA.RA_MAT = SP8.P8_MAT AND"
	cQuery += " SRA.RA_NOME BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' AND "
	cQuery += " SRA.RA_SITFOLH IN("+cVar1+") AND SRA.RA_CATFUNC IN("+cVar2+") "
	If alltrim(mv_par16) == "M"
		cQuery += " ORDER BY P8_MAT, P8_ORDEM, P8_DATA, P8_HORA "
	Else 
		cQuery += " ORDER BY P8_CC, RA_NOME, P8_ORDEM, P8_DATA, P8_HORA "
	EndIf
//	cQuery += "  ((SP8.P8_FLAG = 'E' AND SP8.P8_MOTIVRG = '') OR (SP8.P8_FLAG IN ('I', 'M') AND SP8.P8_MOTIVRG <> '')) AND "	
ELSE
	// busca tabela acumulados marcacoes SPG
	
	
	
	cQuery := "SELECT PG_FILIAL, PG_MAT, PG_DATA, PG_HORA, PG_CC, PG_TURNO, RA_MAT, RA_NOME, PG_ORDEM "
	cQuery += " FROM "+RetSqlName("SPG")+" AS SPG, "+RetSqlName("SRA")+" AS SRA "
	cQuery += " WHERE  SPG.D_E_L_E_T_ <> '*' AND SRA.D_E_L_E_T_ <> '*' AND "
	cQuery += " SPG.PG_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery += " SPG.PG_MAT BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	cQuery += " SPG.PG_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery += " SPG.PG_TURNO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
	cQuery += " SPG.PG_DATA BETWEEN '"+DTOS(mv_par11)+"' AND '"+DTOS(mv_par12)+"' AND "
	cQuery += " SPG.PG_ORDEM <> '' AND "
//	cQuery += "  ((SPG.PG_FLAG = 'E' AND SPG.PG_MOTIVRG = '') OR (SPG.PG_FLAG IN ('I', 'M') AND SPG.PG_MOTIVRG <> '')) AND "
	cQuery += "  (SPG.PG_TPMCREP = '') AND "
	cQuery += " SRA.RA_MAT = SPG.PG_MAT AND SRA.RA_NOME BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' AND "
	cQuery += " SRA.RA_SITFOLH IN("+cVar1+") AND SRA.RA_CATFUNC IN("+cVar2+") "
	If alltrim(mv_par16) == "M"
		cQuery += " ORDER BY PG_MAT, PG_ORDEM, PG_DATA, PG_HORA"
	Else
		cQuery += " ORDER BY PG_CC, RA_NOME, PG_ORDEM, PG_DATA, PG_HORA"
	Endif
ENDIF 
If (Select("TMP") <> 0)
	dbSelectArea("TMP")
	dbCloseArea()
Endif
If lFim
	return .f.
EndIf

MemoWrite("C:\LTSGPE03.TXT",cQuery)
TcQuery cQuery NEW ALIAS "TMP"
If Alias() <> "TMP"
	MsgBox("TMP - Par�metros Inv�lidos!")
	Return .f.
Endif
nPrimer := 0
nDatImp := 0
aVetPon := {}
dbSelectArea("TMP")
dbGoTop("TMP")                             
//SE MES CORRENTE REALIZA AS VALIDACOES NAS TABELAS SPC-APONTAMENTOS/SP6-MOTIVO DE ABONO OU JUSTIFICATIVA/SPK-EVENTOS ABONADOS/SP9-EVENTOS
//SE BUSCAR DE MES ACUMULADO REALIZA AS VALIDACOES NAS TABELAS SPH-APONTAMENTOS ACUMULADOS/SP6-MOTIVO DE ABONO OU JUSTIFICATIVA/SPK-EVENTOS ABONADOS/SP9-EVENTOS
//IF   "20"+substr(dtoc(mv_par11),7,2)+substr(dtoc(mv_par11),4,2) $ Getmv("MV_PONMES") .OR. DTOS(mv_par11) >= SUBSTR(Getmv("MV_PONMES"),0,8)
If SP8->P8_DATA >= mv_par11 .and. SP8->P8_DATA <= mv_par12
	cAlias := "SPC"
ELSE
	cAlias := "SPH"
ENDIF


cMat1   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT))
cMat2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT))
cDat1   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA))
cDat2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA))
cOrd1   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_ORDEM,TMP->PG_ORDEM))
cOrd2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_ORDEM,TMP->PG_ORDEM))
nHrAt   := 1
nDias   := 21
IF oPrn:Setup()
	If lFim
		return .f.
	EndIf
	INCPROC()
	IF !EOF()
		WHILE !EOF()
			If lFim
				return .f.
			EndIf
			
				IF nPrimer == 0
			  	IF IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA) == SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),0,6)+'21'
					//aVetPon - P1 = FILIAL, P2 = MATRICULA, P3 = DATA, P4 = TURNO, P5 = NOME, P6 = HORA1, P7 = HORA2, P8 = HORA3, P9 = HORA 4
					//          P10 = HORA 5, P11 = HORA 6, P12 = HORA 7, P13 = HORA 8, P14 = DESC EVENTO1, P15 = QTD EVENTO1, P16 = DESC EVENTO2, P17 = QTD EVENTO2
					//          P18 = DESC EVENTO3, P19 = QTD EVENTO3, P20 = DESC FALTA1, P21 = QTD FALTA1,P22 = FERIAS,P23 = AFASTAMENTO,P24 = MOTIVO AFAST
					//If cMat1 # cMat2 .AND. !EMPTY(cMat2)
					  //	nDias := 21
					//ENDIF     
					nHrAt := 1
					AADD(aVetPon, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
					IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),;
					TMP->RA_NOME,IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA),NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,;
					0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
					//nDias++
					nPrimer++
					nHrAt++
				ELSE
					bPq := .F.
					If cMat1 # cMat2 .AND. !EMPTY(cMat2)
						IF cMat1 # cMat2 .AND. DAY(STOD(cDat2)) > 1
							//nDias := 21
							//nNmBrc := nDias + 1 //LEN(aVetPon)+1
							WHILE nNmBrc < DAY(STOD(cDat2))
								nHrAt := 1
								dbSelectArea("SRA")
								dbSetOrder(1)
								dbSeek(xFilial("SRA")+cMat2,.t.)
								AADD(aVetPon, {cFil1,cMat2,;
								IIF(cAlias == "SPC",SUBSTR(cDat2,0,6)+STRZERO(nNmBrc,2),SUBSTR(cDat2,0,6)+STRZERO(nNmBrc,2)),;
								SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,;
								NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
								//nDias++
								nNmBrc++
								nHrAt := 0
								bPq := .t.
							ENDDO
							IF nNmBrc == VAL(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),7,2)) 
								nHrAt := 1
								AADD(aVetPon, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
								IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),;
								TMP->RA_NOME,IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA),NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,;
								0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
								//nDias++
								nPrimer++
								nHrAt := 2
							ENDIF
						ENDIF
					ENDIF
					IF !bPq
						//ATUALIZA DIAS EM BRANCO - SEM MARCACAO
						nNmBrc := 1
						WHILE nNmBrc < VAL(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),7,2))
							nHrAt := 1
							AADD(aVetPon, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
							IIF(cAlias == "SPC",SUBSTR(TMP->P8_DATA,0,6)+STRZERO(nNmBrc,2),SUBSTR(TMP->PG_DATA,0,6)+STRZERO(nNmBrc,2)),;
							IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),TMP->RA_NOME,;
							NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
							//nDias++
							nNmBrc++
							nHrAt := 0
							nPrimer++
						ENDDO
						IF nNmBrc == VAL(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),7,2))
							nHrAt := 1
							AADD(1, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
							IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),;
							TMP->RA_NOME,IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA),NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,;
							0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
							//nDias++
							nPrimer++
							nHrAt := 2
						ENDIF
					ENDIF
				ENDIF
			ELSE
				IF cMat1 == cMat2 .AND. cOrd1 == cOrd2  //cDat1 == cDat2
					IF LEN(aVetPon[len(aVetPon)]) < nHrAt+5
						MSGALERT(">>> ERRO <<< ... ANALISAR TABELAS (SP8/SPG), POIS DEVEM HAVER REGISTROS DUPLICADOS PARA O FUNCIONARIO: "+aVetPon[len(aVetPon)][2])
 						RETURN .F.
					ELSE//IF aVetPon[len(aVetPon)][2] == "000101"
						IF nHrAt+5 > 6
							IF aVetPon[len(aVetPon)][nHrAt+4] == IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA) .OR. aVetPon[len(aVetPon)][nHrAt+4] == NIL
								MSGALERT(">>> ERRO <<< ... ANALISAR TABELAS (SP8/SPG), POIS DEVEM HAVER REGISTROS DUPLICADOS PARA O FUNCIONARIO: "+aVetPon[len(aVetPon)][2])
 								RETURN .F.
							ENDIF
						ENDIF
					ENDIF
					aVetPon[len(aVetPon)][nHrAt+5] := IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA)
					nHrAt++
				ELSE
					IF cMat1 == cMat2
//						IF (DTOS(STOD(cDat1)+1) == cDat2) .OR. (VAL(cOrd1)+1 == VAL(cOrd2))
						IF (VAL(cOrd1)+1 == VAL(cOrd2))
							nHrAt := 1
							AADD(aVetPon, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
							IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),;
							TMP->RA_NOME,IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA),NIL,NIL,NIL,NIL,;
							NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
							//nDias++
							nPrimer++             
							nHrAt++
						ELSE
							//ATUALIZA DIAS EM BRANCO - SEM MARCACAO
							nNmBrc := VAL(cOrd1)+1//nDias+1//LEN(aVetPon)+1
							WHILE nNmBrc < VAL(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),7,2)) .and. cMat1 == cMat2
								nHrAt := 1
								AADD(aVetPon, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
								IIF(cAlias == "SPC",SUBSTR(TMP->P8_DATA,0,6)+STRZERO(nNmBrc,2),SUBSTR(TMP->PG_DATA,0,6)+STRZERO(nNmBrc,2)),;
								IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),TMP->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,;
								NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
								//nDias++
								cMat2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT))
								nNmBrc++
								nHrAt := 0
							ENDDO
							IF nNmBrc == VAL(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),7,2)) .and. cMat1 == cMat2
								nHrAt := 1
								AADD(aVetPon, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
								IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),;
								TMP->RA_NOME,IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA),NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,;
								NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
								//nDias++
								cMat2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT))
								nPrimer++
								nHrAt := 2
							ENDIF
						ENDIF
					ELSE
						If cMat1 # cMat2 .AND. !EMPTY(cMat2)
							IF cDat1 < DTOS(STOD(STRZERO(YEAR(STOD(cDat1)),4)+STRZERO(MONTH(STOD(cDat1))+1,2)+"21")-1)
								nNmBrc := DAY(STOD(cDat1)) + 1
								nDayComp := ULTDIA(STOD(CDAT1))
								WHILE nNmBrc <= nDayComp
									nHrAt := 1
									dbSelectArea("SRA")
									dbSetOrder(1)
									dbSeek(xFilial("SRA")+cMat1,.t.)
									AADD(aVetPon, {cFil1,cMat1,;
									IIF(cAlias == "SPC",SUBSTR(cDat1,0,6)+STRZERO(nNmBrc,2),SUBSTR(cDat1,0,6)+STRZERO(nNmBrc,2)),;
									SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,;
									NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
									//nDias++
									nNmBrc++
									nHrAt := 0
								ENDDO
							ELSE
								//							IF cMat1 # cMat2 .AND.  cDat1 # cDat2 .AND. DAY(STOD(cDat2)) > 1
								IF cMat1 # cMat2 .AND. DAY(STOD(cDat2)) > 1
									//nDias := 21
									//nNmBrc := nDias + 1 //LEN(aVetPon)+1
									WHILE nNmBrc < DAY(STOD(cDat2))
										nHrAt := 1
										dbSelectArea("SRA")
										dbSetOrder(1)
										dbSeek(xFilial("SRA")+cMat2,.t.)
										AADD(aVetPon, {cFil1,cMat2,;
										IIF(cAlias == "SPC",SUBSTR(cDat2,0,6)+STRZERO(nNmBrc,2),SUBSTR(cDat2,0,6)+STRZERO(nNmBrc,2)),;
										SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,;
										NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
										//nDias++
										nNmBrc++
										nHrAt := 0
									ENDDO
								ENDIF
							ENDIF
							//nDias := 21
							dbSelectArea("TMP")
							IF !EOF()     
								nHrAt := 1
								AADD(aVetPon, {IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL),IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT),;
								IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),IIF(cAlias == "SPC",IIF(EMPTY(TMP->P8_TURNO),POSICIONE("SRA",1,XFILIAL("SRA")+TMP->P8_MAT,"RA_TNOTRAB"),TMP->P8_TURNO),TMP->PG_TURNO),;
								TMP->RA_NOME,IIF(cAlias == "SPC",TMP->P8_HORA,TMP->PG_HORA),NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,;
								0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
								//nDias++
								nPrimer++
								nHrAt := 2
							ENDIF
						ENDIF
					ENDIF
				ENDIF
				nPrimer++
			ENDIF
			cMat1   := IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT)
			cDat1   := IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA)
			cFil1   := IIF(cAlias == "SPC",TMP->P8_FILIAL,TMP->PG_FILIAL)
			cOrd1   := IIF(cAlias == "SPC",TMP->P8_ORDEM,TMP->PG_ORDEM)
			dbSelectArea("TMP")
			dbSkip()                       
			//Alterado por Roberto
			//If "20"+substr(dtoc(mv_par11),7,2)+substr(dtoc(mv_par11),4,2) $ Getmv("MV_PONMES") .OR. DTOS(mv_par11) >= SUBSTR(Getmv("MV_PONMES"),0,8)			
			If SP8->P8_DATA >= mv_par11 .and. SP8->P8_DATA <= mv_par12
		  
				
					IF  ALLTRIM(TMP->P8_MAT) == "000016"
					HFD := 1
				ENDIF
			ELSE
				IF  ALLTRIM(TMP->PG_MAT) == "000016"
					HFD := 1
				ENDIF			
			ENDIF			
			cOrd2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_ORDEM,TMP->PG_ORDEM))
			cMat2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_MAT,TMP->PG_MAT))
			cDat2   := IIF(EOF(),"",IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA))
			IF cMat1 # cMat2
				nPrimer := 0
				IF !EOF()
					IF DAY(STOD(cDat1)) < DAY(STOD(STRZERO(YEAR(STOD(CDAT1))+1,4)+"0101")-1)
						nNmBrc   := DAY(STOD(cDat1))+1
						//nDayComp := DAY(STOD(STRZERO(YEAR(STOD(CDAT1))+1,4)+"0101")-1)
						nDayComp := ULTDIA(STOD(CDAT1))
						WHILE nNmBrc <= nDayComp    
							dbSelectArea("SRA")
							dbSetOrder(1)
							dbSeek(xFilial("SRA")+cMat1,.t.)					
							nHrAt := 1
							AADD(aVetPon, {cFil1,cMat1,;
							SUBSTR(cDat1,0,6)+STRZERO(nNmBrc,2),;
							SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,;
							NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
							//nDias++
							nNmBrc++
							nHrAt := 0
						ENDDO
					ENDIF
				ENDIF
			ENDIF
			IF EOF()
				//ATUALIZA DIAS EM BRANCO - SEM MARCACAO
				IF VAL(cOrd1) < DAY(STOD(cDat1))
					DdAT1  := STOD(cDat1)-1
					nNmBrc := DAY(STOD(cDat1))
				ELSE
					DdAT1  := STOD(cDat1)
					nNmBrc := DAY(STOD(cDat1))+1
				ENDIF
				
				dbSelectArea("SRA")
				dbSetOrder(1)
				dbSeek(xFilial("SRA")+cMat1,.t.)        
				nDayComp := ULTDIA(STOD(CDAT1))
				WHILE nNmBrc <= nDayComp
					nHrAt := 1
					AADD(aVetPon, {cFil1,cMat1,;
					SUBSTR(cDat1,0,6)+STRZERO(nNmBrc,2),;
					SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,;
					NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
					//nDias++
					nNmBrc++
					nHrAt := 0
				ENDDO
			ENDIF
			dbSelectArea("TMP")
		ENDDO
	ELSE
		i    := 1
		IOk  := 1
		dbSelectArea("SRA")
		dbSetOrder(1)
		IF dbSeek(xFilial("SRA")+mv_par05)
			WHILE !EOF() .AND. SRA->RA_MAT >= mv_par05 .AND. SRA->RA_MAT <= mv_par06
				IF SRA->RA_TNOTRAB >= mv_par07 .AND. SRA->RA_TNOTRAB <= mv_par08 .AND. SRA->RA_NOME >= mv_par09 .AND. SRA->RA_NOME <= mv_par10 .AND. ;
					SRA->RA_SITFOLH $ mv_par13 .AND. SRA->RA_CATFUNC $ mv_par14
					lSR8Cont := .f.
					FOR I := 1 TO  DAY(MV_PAR12)
						dbSelectArea("SR8")
						dbSetOrder(1)
						dbGoTop()
						IF dbSeek(xFilial("SR8")+SRA->RA_MAT)
							WHILE !EOF() .AND. xFilial("SR8")+SRA->RA_MAT == SR8->R8_FILIAL+SR8->R8_MAT
								WHILE !EOF() .AND. ; //SR8->R8_FILIAL+SR8->R8_MAT+DTOS(SR8->R8_DATAINI) <= xFilial("SR8")+SRA->RA_MAT+STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2) .AND. ;
									IIF(EMPTY(DTOS(SR8->R8_DATAFIM)),.T.,SR8->R8_FILIAL+SR8->R8_MAT+DTOS(SR8->R8_DATAFIM) >= xFilial("SR8")+SRA->RA_MAT+STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2))  .AND. ;
									i <= DAY(MV_PAR12) .AND. (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2) >= DTOS(SR8->R8_DATAINI) .AND. (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2) <= DTOS(SR8->R8_DATAFIM) .OR. EMPTY(DTOS(SR8->R8_DATAFIM))))
									// Apos encontrar a data de afastamento registrar no vetor.
									IF len(aVetPon) < 1 .AND. I > 1 .and. i < DAY(MV_PAR12)          
									// literalmente nao tem nada no vetor. Preencher com vazio ate a data do primeiro registro de afastamento
										FOR XX := DAY(MV_PAR11) TO I-1
											AADD(aVetPon, {SR8->R8_FILIAL,SR8->R8_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(XX,2)),;
											SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})								
										NEXT XX
										//FOR nAl := IOk TO DAY(MV_PAR12)
										FOR nAl := I TO DAY(MV_PAR12)
											//IF i < DAY(MV_PAR12)
											IF i <= DAY(MV_PAR12)
												nHrAt := 1
												AADD(aVetPon, {SR8->R8_FILIAL,SR8->R8_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(nAl,2)),;
												SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,"AFASTAMENTO",ALLTRIM(SR8->R8_TIPO)+"-"+SUBSTR(ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"30"+SR8->R8_TIPO,"X5_DESCRI")),0,18),NIL,NIL,.f.})
												lSR8Cont := .t.
												bSraFun := .t.
												i++
											ELSE
												I++
											ENDIF
										NEXT nAl
									ELSE
										IF I > len(aVetPon)+1 .and. i < DAY(MV_PAR12) .AND. I > 1
											FOR nAl := len(aVetPon) TO I
												nHrAt := 1
												AADD(aVetPon, {SR8->R8_FILIAL,SR8->R8_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(nAl,2)),;
												SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,"AFASTAMENTO",ALLTRIM(SR8->R8_TIPO)+"-"+SUBSTR(ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"30"+SR8->R8_TIPO,"X5_DESCRI")),0,18),NIL,NIL,.f.})
												i++
												bSraFun := .t.
												lSR8Cont := .t.
											NEXT nAl
										ELSE
											IF i <= DAY(MV_PAR12)
												IF DTOS(SR8->R8_DATAINI) > STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2)
													nHrAt := 1
													AADD(aVetPon, {SR8->R8_FILIAL,SR8->R8_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2)),;
													SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
													lSR8Cont := .t.
												ELSE
													dbSelectArea("SP3")
													dbSetOrder(1)
													dbGoTop()
													IF dbSeek(xFilial("SP3")+STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2))
														nHrAt := 1
														AADD(aVetPon, {SR8->R8_FILIAL,SR8->R8_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2)),;
														SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
														lSR8Cont := .t.
													ELSE          
														nHrAt := 1
														AADD(aVetPon, {SR8->R8_FILIAL,SR8->R8_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(I,2)),;
														SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,"AFASTAMENTO",ALLTRIM(SR8->R8_TIPO)+"-"+SUBSTR(ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"30"+SR8->R8_TIPO,"X5_DESCRI")),0,18),NIL,NIL,.f.})
														lSR8Cont := .t.
													ENDIF
												ENDIF
												dbSelectArea("SR8")
												i++
												bSraFun := .t.
											ENDIF
										ENDIF
									ENDIF
								ENDDO
								dbSelectArea("SR8")
								dbSkip()
							ENDDO
						ENDIF       
					NEXT I
					//VERIFICA SE FUNCIONARIO FOI DEMITIDO SEM HAVER NENHUMA MARCAO NO MES/SEM TER EXCESSAO/FERIAS
					IF !lSR8Cont                                                                                  
						IF !EMPTY(SRA->RA_DEMISSA) .AND. SRA->RA_DEMISSA >= MV_PAR11 .AND. SRA->RA_DEMISSA <= MV_PAR12
							FOR XX := MV_PAR11 TO SRA->RA_DEMISSA
								AADD(aVetPon, {SRA->RA_FILIAL,SRA->RA_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(DAY(XX),2)),;
								SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})								
							NEXT XX                              
/*							FOR XX := SRA->RA_DEMISSA TO MV_PAR12
								AADD(aVetPon, {SRA->RA_FILIAL,SRA->RA_MAT, (STRZERO(YEAR(MV_PAR11),4)+STRZERO(MONTH(MV_PAR11),2)+STRZERO(DAY(XX),2)),;
								SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,"DEMITIDO",NIL,NIL,NIL,NIL,.f.})								
							NEXT XX */

						ENDIF
					ENDIF
					
				ENDIF
				dbSelectArea("SRA")
				dbSkip()
			ENDDO
		ENDIF
	ENDIF
	INCPROC()
	IF LEN(aVetPon) > 0
		// Esse IF compara o tamanho do vetor com o ?ltimo dia do mes da marca??o de ponto ou do apontamento
		/*IF LEN(aVetPon) < IIF(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),5,2) == "12",;
			31,DAY(STOD(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),0,4)+;
			STRZERO(VAL(SUBSTR(IIF(cAlias == "SPC",TMP->P8_DATA,TMP->PG_DATA),5,2))+1,2)+"01")-1)) .AND. !bSraFun */
		// Validar tamb?m quando nenhuma das datas estiverem preenchidas para gerar as movimenta??es vazias.
		IF LEN(aVetPon) < ULTDIA(IIF(cAlias == "SPC",IIF(TMP->P8_DATA <> " ",TMP->P8_DATA,MV_PAR12),IIF(TMP->PG_DATA <> " ", TMP->PG_DATA, MV_PAR12)))
			nNmBrc := LEN(aVetPon)+1
			WHILE nNmBrc <= VAL(SUBSTR(cDat1,7,2)) .AND. ;
				nNmBrc <=IIF(SUBSTR(IIF(cAlias == "SPC",IIF(EOF(),cDat1,TMP->P8_DATA),IIF(EOF(),cDat1,TMP->PG_DATA)),5,2) == "12", 21,;
				DAY(STOD(SUBSTR(IIF(cAlias == "SPC",IIF(EOF(),cDat1,TMP->P8_DATA),IIF(EOF(),cDat1,TMP->PG_DATA)),0,4)+;
				STRZERO(VAL(SUBSTR(IIF(cAlias == "SPC",IIF(EOF(),cDat1,TMP->P8_DATA),IIF(EOF(),cDat1,TMP->PG_DATA)),5,2))+1,2)+"21")-1))
				AADD(aVetPon, {aVetPon[1][1],aVetPon[1][2],SUBSTR(cDat1,0,6)+STRZERO(nNmBrc,2),aVetPon[1][4],aVetPon[1][5],NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.})
				//nDias++                                   
				nHrAt := 1
				nNmBrc++
				nHrAt := 0
			ENDDO
		ENDIF
		//aVetPon - P1 = FILIAL, P2 = MATRICULA, P3 = DATA, P4 = TURNO, P5 = NOME, P6 = HORA1, P7 = HORA2, P8 = HORA3, P9 = HORA 4
		//          P10 = HORA 5, P11 = HORA 6, P12 = HORA 7, P13 = HORA 8, P14 = DESC EVENTO1, P15 = QTD EVENTO1, P16 = DESC EVENTO2, P17 = QTD EVENTO2
		//          P18 = DESC EVENTO3, P19 = QTD EVENTO3, P20 = DESC FALTA1, P21 = QTD FALTA1,P22 = FERIAS,P23 = AFASTAMENTO,P24 = MOTIVO AFAST
		INCPROC()
		FOR I := 1 TO LEN(aVetPon)
			DbSelectArea(cAlias) //spc/sph
			dbSetOrder(2)
			dbGoTop()
			IF dbSeek(XFILIAL(cAlias)+aVetPon[I][2]+aVetPon[I][3])
				cChave1 := IIF(cAlias == "SPC",SPC->PC_FILIAL+SPC->PC_MAT+DTOS(SPC->PC_DATA),SPH->PH_FILIAL+SPH->PH_MAT+DTOS(SPH->PH_DATA))
				cChave2 := XFILIAL("SPC")+aVetPon[I][2]+aVetPon[I][3]
				WHILE !EOF() .AND. cChave1 ==  cChave2
					IF IIF(cAlias == "SPC",!EMPTY(SPC->PC_PDI),!EMPTY(SPH->PH_PDI)) .AND. IIF(cAlias == "SPC",EMPTY(SPC->PC_ABONO),EMPTY(SPH->PH_ABONO))
						IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
							aVetPon[I][18] := POSICIONE("SP9",1,XFILIAL("SP9")+IIF(cAlias == "SPC",SPC->PC_PDI,SPH->PH_PDI),"P9_DESC")
							aVetPon[I][19] := SPC->PC_QUANTI
						ENDIF
						IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
							aVetPon[I][16] := POSICIONE("SP9",1,XFILIAL("SP9")+IIF(cAlias == "SPC",SPC->PC_PDI,SPH->PH_PDI),"P9_DESC")
							aVetPon[I][17] := SPC->PC_QUANTI
						ENDIF
						IF EMPTY(aVetPon[I][14])
							aVetPon[I][14] := POSICIONE("SP9",1,XFILIAL("SP9")+IIF(cAlias == "SPC",SPC->PC_PDI,SPH->PH_PDI),"P9_DESC")
							aVetPon[I][15] := SPC->PC_QUANTI
						ENDIF
					ELSE
						IF IIF(cAlias == "SPC",!EMPTY(SPC->PC_ABONO),!EMPTY(SPH->PH_ABONO))
							IF IIF(cAlias == "SPC",SPC->PC_QTABONO,SPH->PH_QTABONO) < IIF(cAlias == "SPC",SPC->PC_QUANTC,SPH->PH_QUANTC)
								IF POSICIONE("SRA",1,XFILIAL("SRA")+IIF(cAlias == "SPC",SPC->PC_MAT,SPH->PH_MAT),"RA_ADMISSA") < IIF(cAlias == "SPC",SPC->PC_DATA,SPH->PH_DATA)
									IF  POSICIONE("SPJ",1,XFILIAL("SPJ")+SUBSTR(aVetPon[I][4],0,3)+"21"+ALLTRIM(STR(DOW(STOD(aVetPon[I][3])))),"PJ_TPDIA") $ "D/N/C"
										oPrn:Say( Li+nIncr, nCol+0270, "" , oFont9, 100 )
									ELSE
										aVetPon[I][20] := "F A L T A"
										aVetPon[I][21] := IIF(cAlias == "SPC",SPC->PC_QUANTC,SPH->PH_QUANTC) - IIF(cAlias == "SPC",SPC->PC_QTABONO,SPH->PH_QTABONO)
									ENDIF
								ELSE
									dbSelectArea("SP6")
									dbSetOrder(1)
									dbGoTop()
									IF dbSeek(XFILIAL("SP6")+IIF(cAlias == "SPC",SPC->PC_ABONO,SPH->PH_ABONO))
										aVetPon[I][20] := SP6->P6_DESC
										aVetPon[I][21] := IIF(cAlias == "SPC",SPC->PC_QTABONO,SPH->PH_QTABONO)
									ENDIF
								ENDIF
							ENDIF
							dbSelectArea("SPK")
							dbSetOrder(2)
							dbGoTop()
							IF dbSeek(XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3]+SPC->PC_PD)
								WHILE !EOF() .AND. XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3]+SPC->PC_PD == SPK->PK_FILIAL+SPK->PK_MAT+DTOS(SPK->PK_DATA)+SPK->PK_CODEVE
									dbSelectArea("SP6")
									dbSetOrder(1)
									dbGoTop()
									IF dbSeek(XFILIAL("SP6")+SPK->PK_CODABO)
										IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
											aVetPon[I][18] := SP6->P6_DESC
											dbSelectArea("SPK")
											aVetPon[I][19] := SPK->PK_HRSABO
										ENDIF
										IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
											aVetPon[I][16] := SP6->P6_DESC
											dbSelectArea("SPK")
											aVetPon[I][17] := SPK->PK_HRSABO
										ENDIF
										IF EMPTY(aVetPon[I][14])
											aVetPon[I][14] := SP6->P6_DESC
											dbSelectArea("SPK")
											aVetPon[I][15] := SPK->PK_HRSABO
										ENDIF
									ENDIF
									dbSelectArea("SPK")
									dbSkip()
								ENDDO
							ELSE
								dbSelectArea("SP6")
								dbSetOrder(1)
								dbGoTop()
								IF dbSeek(XFILIAL("SP6")+IIF(cAlias == "SPC",SPC->PC_ABONO,SPH->PH_ABONO) )
									IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
										aVetPon[I][18] := SP6->P6_DESC
										aVetPon[I][19] := SPC->PC_QUANTC
									ENDIF
									IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
										aVetPon[I][16] := SP6->P6_DESC
										aVetPon[I][17] := SPC->PC_QUANTC
									ENDIF
									IF EMPTY(aVetPon[I][14])
										aVetPon[I][14] := SP6->P6_DESC
										aVetPon[I][15] := SPC->PC_QUANTC
									ENDIF
								ENDIF
							ENDIF
						ELSE
							dbSelectArea("SPK")
							dbSetOrder(2)
							dbGoTop()
							IF dbSeek(XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3]) .AND. IIF(cAlias == "SPC",!EMPTY(SPC->PC_ABONO),!EMPTY(SPH->PH_ABONO))
								WHILE !EOF() .AND. XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3] == SPK->PK_FILIAL+SPK->PK_MAT+DTOS(SPK->PK_DATA)
									dbSelectArea("SP6")
									dbSetOrder(1)
									dbGoTop()
									IF dbSeek(XFILIAL("SP6")+SPK->PK_CODABO)
										IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
											aVetPon[I][18] := SP6->P6_DESC
											dbSelectArea("SPK")
											aVetPon[I][19] := SPK->PK_HRSABO
										ENDIF
										IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
											aVetPon[I][16] := SP6->P6_DESC
											dbSelectArea("SPK")
											aVetPon[I][17] := SPK->PK_HRSABO
										ENDIF
										IF EMPTY(aVetPon[I][14])
											aVetPon[I][14] := SP6->P6_DESC
											dbSelectArea("SPK")
											aVetPon[I][15] := SPK->PK_HRSABO
										ENDIF
									ENDIF
									dbSelectArea("SPK")
									dbSkip()
								ENDDO
							ELSE
								dbSelectArea(cAlias)
								IF EMPTY(aVetPon[I][14])
									aVetPon[I][14] := IIF(cAlias == "SPC",POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PD,"P9_DESC"),POSICIONE("SP9",1,XFILIAL("SP9")+SPH->PH_PD,"P9_DESC"))
									aVetPon[I][15] := IIF(cAlias == "SPC",SPC->PC_QUANTC,SPH->PH_QUANTC)
								ELSE
									IF EMPTY(aVetPon[I][16])
										aVetPon[I][16] := IIF(cAlias == "SPC",POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PD,"P9_DESC"),POSICIONE("SP9",1,XFILIAL("SP9")+SPH->PH_PD,"P9_DESC"))
										aVetPon[I][17] := IIF(cAlias == "SPC",SPC->PC_QUANTC,SPH->PH_QUANTC)
									ELSE
										IF EMPTY(aVetPon[I][18])
											aVetPon[I][18] := IIF(cAlias == "SPC",POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PD,"P9_DESC"),POSICIONE("SP9",1,XFILIAL("SP9")+SPH->PH_PD,"P9_DESC"))
											aVetPon[I][19] := IIF(cAlias == "SPC",SPC->PC_QUANTC,SPH->PH_QUANTC)
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
					//aVetPon - P1 = FILIAL, P2 = MATRICULA, P3 = DATA, P4 = TURNO, P5 = NOME, P6 = HORA1, P7 = HORA2, P8 = HORA3, P9 = HORA 4
					//          P10 = HORA 5, P11 = HORA 6, P12 = HORA 7, P13 = HORA 8, P14 = DESC EVENTO1, P15 = QTD EVENTO1, P16 = DESC EVENTO2, P17 = QTD EVENTO2
					//          P18 = DESC EVENTO3, P19 = QTD EVENTO3, P20 = DESC FALTA1, P21 = QTD FALTA1,P22 = FERIAS,P23 = AFASTAMENTO,P24 = MOTIVO AFAST
					
					dbSelectArea("SRH")
					dbSetOrder(1)
					dbGoTop()
					IF dbSeek(xFilial("SRH")+aVetPon[I][2])
						WHILE !EOF() .AND. aVetPon[I][2] == SRH->RH_MAT
							IF STOD(aVetPon[I][3]) >= SRH->RH_DATAINI .AND. ;
								STOD(aVetPon[I][3]) <= SRH->RH_DATAFIM
								aVetPon[I][22] := "FERIAS"
								EXIT
							ENDIF
							dbSkip()
						ENDDO
					ENDIF
					
					dbSelectArea("SR8")
					dbSetOrder(1)
					dbGoTop()
					IF dbSeek(xFilial("SR8")+aVetPon[I][2])// .AND. !bCompens
						WHILE !EOF() .AND. aVetPon[I][2] == SR8->R8_MAT
							IF STOD(aVetPon[I][3]) >= SR8->R8_DATAINI .AND. ;
								(STOD(aVetPon[I][3]) <= SR8->R8_DATAFIM .OR. EMPTY(DTOS(SR8->R8_DATAFIM)))
								aVetPon[I][23] := "AFASTAMENTO"
								aVetPon[I][24] := ALLTRIM(SR8->R8_TIPO)+"-"+SUBSTR(ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"30"+SR8->R8_TIPO,"X5_DESCRI")),0,18)
								EXIT
							ENDIF
							dbSkip()
						ENDDO
					ENDIF
					
					dbSelectArea(cAlias)
					dbSkip()
					cChave1 := IIF(cAlias == "SPC",SPC->PC_FILIAL+SPC->PC_MAT+DTOS(SPC->PC_DATA),SPH->PH_FILIAL+SPH->PH_MAT+DTOS(SPH->PH_DATA))
				ENDDO
			ELSE
				INCPROC()
				dbSelectArea("SRH")
				dbSetOrder(1)
				dbGoTop()
				IF dbSeek(xFilial("SRH")+aVetPon[I][2])
					WHILE !EOF() .AND. aVetPon[I][2] == SRH->RH_MAT
						IF STOD(aVetPon[I][3]) >= SRH->RH_DATAINI .AND. ;
							STOD(aVetPon[I][3]) <= SRH->RH_DATAFIM
							dbSelectArea("SP3")
							dbSetOrder(1)
							dbGoTop()
							IF !dbSeek(xFilial("SP3")+aVetPon[I][3])
								aVetPon[I][22] := "FERIAS"
							ENDIF
							EXIT
						ENDIF
						dbSelectArea("SRH")
						dbSkip()
					ENDDO
				ENDIF
				
				dbSelectArea("SR8")
				dbSetOrder(1)
				dbGoTop()
				IF dbSeek(xFilial("SR8")+aVetPon[I][2])// .AND. !bCompens
					WHILE !EOF() .AND. aVetPon[I][2] == SR8->R8_MAT
						IF STOD(aVetPon[I][3]) >= SR8->R8_DATAINI .AND. ;
							(STOD(aVetPon[I][3]) <= SR8->R8_DATAFIM .OR.  EMPTY(DTOS(SR8->R8_DATAFIM)))
							dbSelectArea("SP3")
							dbSetOrder(1)
							dbGoTop()
							IF !dbSeek(xFilial("SP3")+aVetPon[I][3])
								aVetPon[I][23] := "AFASTAMENTO"
								aVetPon[I][24] := ALLTRIM(SR8->R8_TIPO)+"-"+SUBSTR(ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"30"+SR8->R8_TIPO,"X5_DESCRI")),0,18)
							ENDIF
							dbSelectArea("SR8")
							EXIT
						ENDIF
						dbSkip()
					ENDDO
				ENDIF
			ENDIF
			//CALCULA EXCECAO
			IF mv_par15 == 1
				IF aVetPon[i][6] <> NIL
					CALCSP2(aVetPon,i)
					x := 1
				ENDIF
			ENDIF
		NEXT I
		IF (LEN(AVETPON)) > 0                                                                              
			cDat1 := AVETPON[len(AVETPON),3]
			IF LEN(AVETPON) < DAY(STOD(STRZERO(YEAR(STOD(cDat1)),4)+STRZERO(MONTH(STOD(cDat1))+1,2)+"21")-1)
				nNmBrc := DAY(STOD(STRZERO(YEAR(STOD(cDat1)),4)+STRZERO(MONTH(STOD(cDat1))+1,2)+"21")-1)
				cMat1 := AVETPON[len(AVETPON),2]
				cDat1 := AVETPON[len(AVETPON),3]
				FOR xx := LEN(AVETPON)+1 TO nNmBrc
					nHrAt := 1
					dbSelectArea("SRA")
					dbSetOrder(1)
					dbSeek(xFilial("SRA")+cMat1,.t.)
					AADD(aVetPon, {" ",cMat1,;
					SUBSTR(cDat1,0,6)+STRZERO(xx,2),;
					SRA->RA_TNOTRAB,SRA->RA_NOME,NIL,NIL,NIL,NIL,NIL,NIL,;
					NIL,NIL,NIL,0,NIL,0,NIL,0,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.f.}) //27
					
				NEXT xx
			ENDIF
		ENDIF
		IF LEN(aVetPon) > 0
			cMat1 := aVetPon[1][2]
			cMat2 := aVetPon[1][2]
		ENDIF
		FOR I := 1 TO LEN(aVetPon)
			IF li <= 1850
				Li    := 50
				nCol  := 50
				nIncr := 0
				nPag ++
				oPrn:StartPage()
				If cEmpAnt = "21"
					oPrn:SayBitmap( Li+000, nCol+000, cBitMap, 365, 152 )
				ElseIf cEmpAnt = "02"
					oPrn:SayBitmap( Li+000, nCol+000, cBitMap1, 365, 152 )
				Endif
				nIncr += 030
				//removido o desenho da caixa, para que ele fa�a ao final: 
								
				dbSelectArea("SRA")
				dbSetorder(1)
				dbGoTop()
				dbSeek(XFILIAL("SRA")+aVetPon[I][2],.T.)
				nIncr += 000
				oPrn:Say( Li+nIncr, nCol+0050, "Cart�o Ponto", oFont6, 100 )
				nIncr += 080
				oPrn:Say( Li+nIncr, nCol+0400, SM0->M0_NOMECOM, ofont9, 100 )
				oPrn:Say( Li+nIncr, nCol+1100, "CNPJ: "+TRANSFORM(SM0->M0_CGC, "@R ##.###.###/####-##"), ofont9, 100 )
				oPrn:Say( Li+nIncr, nCol+1450, "ENDERE�O: "+SM0->M0_ENDCOB, ofont9, 100 )
				oPrn:Say( Li+nIncr, nCol+2000, SM0->M0_CIDCOB, ofont9, 100 )
				oPrn:Box( 210, 040, 340, 2290 )
				nIncr += 60
				oPrn:Say( Li+nIncr, nCol+0000, "MATR�CULA: "+ALLTRIM(aVetPon[I][2]), oFont2, 100 )
				oPrn:Say( Li+nIncr, nCol+0950, "FUN��O: "+ALLTRIM(POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")), oFont2, 100 )
				nIncr += 40
				oPrn:Say( Li+nIncr, nCol+0000, "NOME: "+ALLTRIM(SRA->RA_NOME), oFont2, 100 )
				oPrn:Say( Li+nIncr, nCol+0950, "HOR�RIO: "+ALLTRIM(POSICIONE("SR6",1,XFILIAL("SR6")+SRA->RA_TNOTRAB,"R6_DESC")), oFont2, 100 )
				nIncr += 40
				oPrn:Say( Li+nIncr, nCol+0000, "C.C.: "+ALLTRIM(POSICIONE("SI3",1,XFILIAL("SI3")+SRA->RA_CC,"I3_DESC")), oFont2, 100 )
				oPrn:Say( Li+nIncr, nCol+0950, "JORNADA DE TRABALHO SEMANAL: "+ALLTRIM(STR(SRA->RA_HRSEMAN))+" HORAS", oFont2, 100 )
				nIncr += 100
				oPrn:Box( 350, 040, 400, 2290 )
				oPrn:Say( Li+nIncr-40, nCol+0000, "CART�O PONTO", oFont2, 100 )                               
				oPrn:Say( Li+nIncr-40, nCol+1380, "PERIODO:", oFont2, 100 )
    			oPrn:Say( Li+nIncr-40, nCol+1800, dtoc(mv_par11)+ " a " +dtoc(mv_par12), ofont2, 100)
		  //	oPrn:Say( Li+nIncr-40, nCol+1950, STR(MONTH(STOD(aVetPon[I][3])))+"/"+ALLTRIM(STR(YEAR(STOD(aVetPon[I][3])))), oFont2, 100 )
				nIncr += 40
				
				oPrn:Box( 410, 040, 480, 2290 )
				oPrn:Say( Li+nIncr, nCol+0030, "DATA", oFont2, 100 )                   
			 	oPrn:Say( Li+nIncr, nCol+0230, "MARCA��ES", oFont2, 100 )
				oPrn:Say( Li+nIncr, nCol+1160, "DESCRI��O", oFont2, 100 )  //1200-1130
			 	oPrn:Say( Li+nIncr, nCol+0940, "QTDE", oFont2, 100 )
			 	oPrn:Say( Li+nIncr, nCol+1850, "OBSERVACAO", oFont2, 100 )
				
				nIncr += 65
				
				cMatAnt := aVetPon[I][2]
				cMatPos := aVetPon[I][2]
				//aVetPon - P1 = FILIAL, P2 = MATRICULA, P3 = DATA, P4 = TURNO, P5 = NOME, P6 = HORA1, P7 = HORA2, P8 = HORA3, P9 = HORA 4
				//          P10 = HORA 5, P11 = HORA 6, P12 = HORA 7, P13 = HORA 8, P14 = DESC EVENTO1, P15 = QTD EVENTO1, P16 = DESC EVENTO2, P17 = QTD EVENTO2
				//          P18 = DESC EVENTO3, P19 = QTD EVENTO3, P20 = DESC FALTA1, P21 = QTD FALTA1,P22 = FERIAS,P23 = AFASTAMENTO,P24 = MOTIVO AFAST
				nAux   := I
				//nDias  := 21
				nRepet := 1
				WHILE I <= LEN(aVetPon) .AND. cMat1 == cMat2  
					IF !EMPTY(aVetPon[I][16]) .OR. !EMPTY(aVetPon[I][18]) .OR. !EMPTY(aVetPon[I][20])
					   	IF !EMPTY(aVetPon[I][16]) .AND. EMPTY(aVetPon[I][18]) .AND. EMPTY(aVetPon[I][20])
						nRepet := 2       
				 		ENDIF     
					ENDIF
					FOR nRpt := 1 to nRepet
					    cHoraImp := IIF(EMPTY(aVetPon[I][3]),"",(aVetPon[I][3]))+SPACE(15)+IIF(EMPTY(aVetPon[I][6]),"",TTOC(aVetPon[I][6]))+SPACE(5);
						+IIF(EMPTY(aVetPon[I][7]),"",TTOC(aVetPon[I][7]))+SPACE(5)+IIF(EMPTY(aVetPon[I][8]),"",TTOC(aVetPon[I][8]))+SPACE(5);
						+IIF(EMPTY(aVetPon[I][9]),"",TTOC(aVetPon[I][9]))+SPACE(5)+IIF(EMPTY(aVetPon[I][10]),"",TTOC(aVetPon[I][10]))+SPACE(5);
						+IIF(EMPTY(aVetPon[I][11]),"",TTOC(aVetPon[I][11]))+SPACE(5)+IIF(EMPTY(aVetPon[I][12]),"",TTOC(aVetPon[I][12]))+SPACE(5);
						+IIF(EMPTY(aVetPon[I][13]),"",TTOC(aVetPon[I][13]))
				                            
				        //oPrn:Say ( Li+nIncr, nCol+0000, (aVetPon[I][3]), ofont9, 100)
 						//	oPrn:Say( Li+nIncr, nCol+0080, SUBSTR(DIASEMANA(STOD(aVetPon[I][3])),0,3), ofont9, 100 )
					    //	ENDIF
						//	oPrn:Say( Li+nIncr, nCol+0000, ALLTRIM(STR(nDias)) , ofont9, 100 )
						//	oPrn:Say( Li+nIncr, nCol+0000, cDat1 , ofont9, 100 )
						//	oPrn:Say( Li+nIncr, nCol+0080, SUBSTR(DIASEMANA(STOD(aVetPon[I][3])),0,3), ofont9, 100 )
						//	ENDIF
					 	           
						
						//FERIADO
						bFeriado := .f.
						dbSelectArea("SP3")
						dbSetOrder(1)
						dbGoTop()
						IF dbSeek(xFilial("SP3")+aVetPon[I][3])
							bAfas := .F.
							dbSelectArea("SR8")
							dbSetOrder(1)
							dbGoTop()
							IF dbSeek(xFilial("SR8")+aVetPon[I][2])
								WHILE !EOF() .AND. aVetPon[I][2] == SR8->R8_MAT
									IF STOD(aVetPon[I][3]) >= SR8->R8_DATAINI .AND. ;
										(STOD(aVetPon[I][3]) <= SR8->R8_DATAFIM .OR. EMPTY(DTOS(SR8->R8_DATAFIM)))
										aVetPon[I][23] := "AFASTAMENTO"
										aVetPon[I][24] := ALLTRIM(SR8->R8_TIPO)+"-"+SUBSTR(ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"30"+SR8->R8_TIPO,"X5_DESCRI")),0,18)
										bAfas := .T.
										EXIT
									ENDIF
									dbSkip()
								ENDDO
								IF !bAfas
									dbSelectArea("SP3")
									oPrn:Say( Li+nIncr, nCol+1160, "FERIADO" , ofont9, 100 )
									oPrn:Say( Li+nIncr, nCol+0900, "***", ofont9, 100 ) //9997
									oPrn:Say( Li+nIncr, nCol+1250, ALLTRIM(SP3->P3_DESC), oFont9, 100 )
									aVetPon[I][27] := .t.
									bFeriado := .t.
								ENDIF
							ELSE
								dbSelectArea("SP3")
								oPrn:Say( Li+nIncr, nCol+1160, "FERIADO" , ofont9, 100 )
								oPrn:Say( Li+nIncr, nCol+0900, "***", ofont9, 100 ) //9997
								oPrn:Say( Li+nIncr, nCol+1250, ALLTRIM(SP3->P3_DESC), oFont9, 100 )
								aVetPon[I][27] := .t.
								bFeriado := .t.
							ENDIF
						ELSE
							IF nRpt == 1
								IF SUBSTR(DIASEMANA(STOD(aVetPon[I][3])),0,3) $ "Sab/Dom"
									oPrn:Say( Li+nIncr, nCol+0900, "**", ofont9, 100 )          //9998
								ELSE
									oPrn:Say( Li+nIncr, nCol+0900, "*", ofont9, 100 )           //067
								ENDIF
							ENDIF
						ENDIF
						
						IF EMPTY(cHoraImp) .AND. nRpt == 1
							IF  POSICIONE("SPJ",1,XFILIAL("SPJ")+SUBSTR(aVetPon[I][4],0,3)+"21"+ALLTRIM(STR(DOW(STOD(aVetPon[I][3])))),"PJ_TPDIA") $ "D/N/C"
								oPrn:Say( Li+nIncr, nCol+0270, "" , oFont9, 100 )
							ELSE
								dbSelectArea("SP2")
					   			dbSetOrder(3)
								dbGoTop()
								IF dbSeek(xFilial("SP2")+ALLTRIM(SRA->RA_MAT)+SPACE(9)+SPACE(3)+aVetPon[I][3])
									IF ALLTRIM(SP2->P2_TRABA) == "D"
										oPrn:Say( Li+nIncr, nCol+0270, SP2->P2_MOTIVO , oFont9, 100 )
									ENDIF
								ELSE
									IF !EMPTY(aVetPon[I][22]) .AND. EMPTY(aVetPon[I][23])       
										oPrn:Say( Li+nIncr, nCol+0270, aVetPon[I][22] , oFont9, 100 )
									ELSE
										IF !EMPTY(aVetPon[I][23])
											oPrn:Say( Li+nIncr, nCol+0270, aVetPon[I][23] , oFont9, 100 )
											oPrn:Say( Li+nIncr, nCol+1060, aVetPon[I][24] , ofont9, 100 )
										ELSE
											IF IIF(nRpt==1,EMPTY(aVetPon[I][14]),IIF(nRpt==2,EMPTY(aVetPon[I][16]),EMPTY(aVetPon[I][18]))) .AND. !bFeriado .AND. EMPTY(SRA->RA_DEMISSA)
												IF POSICIONE("SRA",1,XFILIAL("SRA")+aVetPon[I][2],"RA_ADMISSA") < STOD(aVetPon[I][3])
													IF  POSICIONE("SPJ",1,XFILIAL("SPJ")+SUBSTR(aVetPon[I][4],0,3)+"21"+ALLTRIM(STR(DOW(STOD(aVetPon[I][3])))),"PJ_TPDIA") $ "D/N/C"
														oPrn:Say( Li+nIncr, nCol+0270, "" , oFont9, 100 )
													ELSE
														oPrn:Say( Li+nIncr, nCol+0270, "F A L T A" , oFont9, 100 )
														oPrn:Say( Li+nIncr, nCol+1160, IIF(EMPTY(aVetPon[I][14]),"** Ausente **",aVetPon[I][14]), oFont9, 100 )
													ENDIF
												ENDIF
											ELSE
												IF EMPTY(aVetPon[I][6]) .AND. EMPTY(aVetPon[I][7]) .AND. EMPTY(aVetPon[I][8]).AND. EMPTY(aVetPon[I][9]);
													.AND. !EMPTY(SRA->RA_DEMISSA) .AND. SRA->RA_DEMISSA >= STOD(aVetPon[I][3])
													dbSelectArea("SPC")
													dbSetOrder(2)
													dbGoTop()
													IF dbSeek(XFILIAL("SPC")+aVetPon[I][2]+aVetPon[I][3])
														cChave1 := SPC->PC_FILIAL+SPC->PC_MAT+DTOS(SPC->PC_DATA)
														cChave2 := XFILIAL("SPC")+aVetPon[I][2]+aVetPon[I][3]
														IF !EOF()
															WHILE !EOF() .AND. SPC->PC_FILIAL+SPC->PC_MAT+DTOS(SPC->PC_DATA) ==  cChave2
																IF !EMPTY(SPC->PC_PDI) .AND. EMPTY(SPC->PC_ABONO)
																	IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
																		aVetPon[I][18] := POSICIONE("SP9",1,XFILIAL("SP9")+IIF(cAlias == "SPC",SPC->PC_PDI,SPH->PH_PDI),"P9_DESC")
																		aVetPon[I][19] := SPC->PC_QUANTI
																	ENDIF
																	IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
																		aVetPon[I][16] := POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PDI,"P9_DESC")
																		aVetPon[I][17] := SPC->PC_QUANTI
																	ENDIF
																	IF EMPTY(aVetPon[I][14])
																		aVetPon[I][14] := POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PDI,"P9_DESC")
																		aVetPon[I][15] := SPC->PC_QUANTI
																	ENDIF
																ELSE
																	IF !EMPTY(SPC->PC_ABONO)
																		IF SPC->PC_QTABONO < SPC->PC_QUANTC
																			IF POSICIONE("SRA",1,XFILIAL("SRA")+SPC->PC_MAT,"RA_ADMISSA") < SPC->PC_DATA
																				IF  POSICIONE("SPJ",1,XFILIAL("SPJ")+SUBSTR(aVetPon[I][4],0,3)+"21"+ALLTRIM(STR(DOW(STOD(aVetPon[I][3])))),"PJ_TPDIA") $ "D/N/C"
																					oPrn:Say( Li+nIncr, nCol+0270, "" , oFont9, 100 )
																				ELSE
																					aVetPon[I][20] := "F A L T A"
																					aVetPon[I][21] := SPC->PC_QUANTC - SPC->PC_QTABONO
																				ENDIF
																			ELSE
																				dbSelectArea("SP6")
																				dbSetOrder(1)
																				dbGoTop()
																				IF dbSeek(XFILIAL("SP6")+SPC->PC_ABONO)
																					aVetPon[I][20] := SP6->P6_DESC
																					aVetPon[I][21] := SPC->PC_QTABONO
																				ENDIF
																			ENDIF
																		ENDIF
																		dbSelectArea("SPK")
																		dbSetOrder(2)
																		dbGoTop()
																		IF dbSeek(XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3]+SPC->PC_PD)
																			WHILE !EOF() .AND. XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3]+SPC->PC_PD == SPK->PK_FILIAL+SPK->PK_MAT+DTOS(SPK->PK_DATA)+SPK->PK_CODEVE
																				dbSelectArea("SP6")
																				dbSetOrder(1)
																				dbGoTop()
																				IF dbSeek(XFILIAL("SP6")+SPK->PK_CODABO)
																					IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
																						aVetPon[I][18] := SP6->P6_DESC
																						dbSelectArea("SPK")
																						aVetPon[I][19] := SPK->PK_HRSABO
																					ENDIF
																					IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
																						aVetPon[I][16] := SP6->P6_DESC
																						dbSelectArea("SPK")
																						aVetPon[I][17] := SPK->PK_HRSABO
																					ENDIF
																					IF EMPTY(aVetPon[I][14])
																						aVetPon[I][14] := SP6->P6_DESC
																						dbSelectArea("SPK")
																						aVetPon[I][15] := SPK->PK_HRSABO
																					ENDIF
																				ENDIF
																				dbSelectArea("SPK")
																				dbSkip()
																			ENDDO
																		ELSE
																			dbSelectArea("SP6")
																			dbSetOrder(1)
																			dbGoTop()
																			IF dbSeek(XFILIAL("SP6")+SPC->PC_ABONO )
																				IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
																					aVetPon[I][18] := SP6->P6_DESC
																					aVetPon[I][19] := SPC->PC_QUANTC
																				ENDIF
																				IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
																					aVetPon[I][16] := SP6->P6_DESC
																					aVetPon[I][17] := SPC->PC_QUANTC
																				ENDIF
																				IF EMPTY(aVetPon[I][14])
																					aVetPon[I][14] := SP6->P6_DESC
																					aVetPon[I][15] := SPC->PC_QUANTC
																				ENDIF
																			ENDIF
																		ENDIF
																	ELSE
																		dbSelectArea("SPK")
																		dbSetOrder(2)
																		dbGoTop()
																		IF dbSeek(XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3]) .AND. !EMPTY(SPC->PC_ABONO)
																			WHILE !EOF() .AND. XFILIAL("SPK")+aVetPon[I][2]+aVetPon[I][3] == SPK->PK_FILIAL+SPK->PK_MAT+DTOS(SPK->PK_DATA)
																				dbSelectArea("SP6")
																				dbSetOrder(1)
																				dbGoTop()
																				IF dbSeek(XFILIAL("SP6")+SPK->PK_CODABO)
																					IF !EMPTY(aVetPon[I][14]) .and. !EMPTY(aVetPon[I][16]) .and. EMPTY(aVetPon[I][18])
																						aVetPon[I][18] := SP6->P6_DESC
																						dbSelectArea("SPK")
																						aVetPon[I][19] := SPK->PK_HRSABO
																					ENDIF
																					IF !EMPTY(aVetPon[I][14]) .and. EMPTY(aVetPon[I][16])
																						aVetPon[I][16] := SP6->P6_DESC
																						dbSelectArea("SPK")
																						aVetPon[I][17] := SPK->PK_HRSABO
																					ENDIF
																					IF EMPTY(aVetPon[I][14])
																						aVetPon[I][14] := SP6->P6_DESC
																						dbSelectArea("SPK")
																						aVetPon[I][15] := SPK->PK_HRSABO
																					ENDIF
																				ENDIF
																				dbSelectArea("SPK")
																				dbSkip()
																			ENDDO
																		ELSE
																			dbSelectArea(cAlias)
																			IF EMPTY(aVetPon[I][14])
																				aVetPon[I][14] := POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PD,"P9_DESC")
																				aVetPon[I][15] := SPC->PC_QUANTC
																			ELSE
																				IF EMPTY(aVetPon[I][16])
																					aVetPon[I][16] := POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PD,"P9_DESC")
																					aVetPon[I][17] := SPC->PC_QUANTC
																				ELSE
																					IF EMPTY(aVetPon[I][18])
																						aVetPon[I][18] := POSICIONE("SP9",1,XFILIAL("SP9")+SPC->PC_PD,"P9_DESC")
																						aVetPon[I][19] := SPC->PC_QUANTC
																					ENDIF
																				ENDIF
																			ENDIF
																		ENDIF
																	ENDIF
																ENDIF
																dbSelectArea("SPC")
																dbSkip()
															ENDDO
														ELSE
															oPrn:Say( Li+nIncr, nCol+0270, "F A L T A" , oFont9, 100 )
															oPrn:Say( Li+nIncr, nCol+1160, IIF(EMPTY(aVetPon[I][14]),"** Ausente **",aVetPon[I][14]), oFont9, 100 )
														ENDIF
													ELSE
														oPrn:Say( Li+nIncr, nCol+0270, "F A L T A" , oFont9, 100 )
														oPrn:Say( Li+nIncr, nCol+1160, IIF(EMPTY(aVetPon[I][14]),"** Ausente **",aVetPon[I][14]), oFont9, 100 )
													ENDIF
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
							//						ENDIF
							IF !avetpon[i][27]
								oPrn:Say( Li+nIncr, nCol+1160, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][14]),"",aVetPon[I][14]),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][16]),"",aVetPon[I][16]),IIF(EMPTY(aVetPon[I][18]),"",aVetPon[I][18]))), oFont9, 100 )
							ENDIF
						ELSE
							IF nRpt == 1  
	 	 					  //	oPrn:Say( Li+nIncr, nCol+0000, dtoc(cDatap) , ofont9, 100 )
    							oPrn:Say( Li+nIncr, nCol+0010, cHoraImp , oFont9, 100 )
								dbSelectArea("SP2")
								dbSetOrder(3)
								dbGoTop()
								IF dbSeek(xFilial("SP2")+ALLTRIM(SRA->RA_MAT)+SPACE(9)+SPACE(3)+aVetPon[I][3])
									IF ALLTRIM(SP2->P2_TRABA) == "D"
										oPrn:Say( Li+nIncr, nCol+0770, SP2->P2_MOTIVO , ofont9, 100 )
									ENDIF
								ENDIF
							ENDIF
						IF  ALLTRIM(valtype(aVetPon[I][14])) == "N"
								MSGALERT(">>> ERRO <<< ... ANALISAR TABELAS (SP8/SPG), POIS DEVEM HAVER REGISTROS DUPLICADOS PARA O FUNCIONARIO: "+aVetPon[I][2])
								RETURN .F.
							ENDIF
  							IF !bFeriado
								oPrn:Say( Li+nIncr, nCol+1160, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][14]),"",aVetPon[I][14]),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][16]),"",aVetPon[I][16]),IIF(EMPTY(aVetPon[I][18]),"",aVetPon[I][18]))), oFont9, 100 )
							ENDIF
						ENDIF
						IF nRpt == 1
							//oPrn:Say( Li+nIncr, nCol+1750, ALLTRIM(STR(nDias)) , ofont9, 100 )
							IF IIF(nRpt==1,!EMPTY(aVetPon[I][14]),IIF(nRpt==2,!EMPTY(aVetPon[I][16]),!EMPTY(aVetPon[I][18])))
								IF avetpon[i][27]
									oPrn:Say( Li+nIncr, nCol+0950, "00:00", ofont9, 100 )
									nIncr += 035
								ENDIF
								oPrn:Say( Li+nIncr, nCol+1160, IIF(nRpt==1,aVetPon[I][14],IIF(nRpt==2,aVetPon[I][16],aVetPon[I][18])), oFont9, 100 )
							ENDIF
							oPrn:Say( Li+nIncr, nCol+0950, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][15]),"00:00",TTOC(aVetPon[I][15])),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][17]),"00:00",TTOC(aVetPon[I][17])),IIF(EMPTY(aVetPon[I][19]),"00:00",TTOC(aVetPon[I][19])))) , ofont9, 100 )
							nRpt++
						ENDIF
						nIncr += 35
						IF !EMPTY(aVetPon[I][20])
							IF nRpt == 1
							  //	oPrn:Say( Li+nIncr, nCol+0000, ALLTRIM(STR(nDias)) , ofont9, 100 )
								oPrn:Say( Li+nIncr, nCol+0080, SUBSTR(DIASEMANA(STOD(aVetPon[I][3])),0,3), ofont9, 100 )
							ENDIF
							//FERIADO
							dbSelectArea("SP3")
							dbSetOrder(1)
							dbGoTop()
							IF dbSeek(xFilial("SP3")+aVetPon[I][3])
								dbSelectArea("SR8")
								dbSetOrder(1)
								dbGoTop()
								IF dbSeek(xFilial("SR8")+aVetPon[I][2])
									WHILE !EOF() .AND. aVetPon[I][2] == SR8->R8_MAT
										IF STOD(aVetPon[I][3]) >= SR8->R8_DATAINI .AND. ;
											(STOD(aVetPon[I][3]) <= SR8->R8_DATAFIM .or. EMPTY(DTOS(SR8->R8_DATAFIM)))
											aVetPon[I][23] := "AFASTAMENTO"
											aVetPon[I][24] := ALLTRIM(SR8->R8_TIPO)+"-"+SUBSTR(ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"30"+SR8->R8_TIPO,"X5_DESCRI")),0,18)
											EXIT
										ENDIF
										dbSkip()
									ENDDO
								ELSE
									oPrn:Say( Li+nIncr, nCol+1160, "FERIADO" , ofont9, 100 )
									oPrn:Say( Li+nIncr, nCol+0170, "***", ofont9, 100 ) //9997
									oPrn:Say( Li+nIncr, nCol+1250, ALLTRIM(SP3->P3_DESC), oFont9, 100 )
									aVetPon[I][27] := .t.
								ENDIF
							ELSE
								IF nRpt == 1
									IF SUBSTR(DIASEMANA(STOD(aVetPon[I][3])),0,3) $ "Sab/Dom"
										oPrn:Say( Li+nIncr, nCol+0170, "**", ofont9, 100 )   //9998
									ELSE
										oPrn:Say( Li+nIncr, nCol+0170, "*", ofont9, 100 )    //067

									ENDIF
								ENDIF
								IF EMPTY(SRA->RA_DEMISSA)
									IF POSICIONE("SRA",1,XFILIAL("SRA")+aVetPon[I][2],"RA_ADMISSA") < STOD(aVetPon[I][3])
										IF  POSICIONE("SPJ",1,XFILIAL("SPJ")+SUBSTR(aVetPon[I][4],0,3)+"21"+ALLTRIM(STR(DOW(STOD(aVetPon[I][3])))),"PJ_TPDIA") $ "D/N/C"
											oPrn:Say( Li+nIncr, nCol+0270, "" , oFont9, 100 )
										ELSE
											oPrn:Say( Li+nIncr, nCol+0270, "F A L T A" , oFont9, 100 )
										ENDIF
									ENDIF
								ELSE
									oPrn:Say( Li+nIncr, nCol+0270, "F A L T A" , oFont9, 100 )
								ENDIF
							ENDIF
							oPrn:Say( Li+nIncr, nCol+0950, IIF(EMPTY(aVetPon[I][21]),"00:00",TTOC(aVetPon[I][21])) , ofont9, 100 )
							IF nRpt == 1
							//	oPrn:Say( Li+nIncr, nCol+1750, ALLTRIM(STR(nDias)) , ofont9, 100 )
							ENDIF
							nIncr += 35
						ENDIF
						IF !EMPTY(aVetPon[I][16]) .or. !EMPTY(aVetPon[I][18]) .or. !EMPTY(aVetPon[I][20])
							IF !EMPTY(aVetPon[I][16])
								oPrn:Say( Li+nIncr, nCol+1160, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][14]),"",aVetPon[I][14]),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][16]),"",aVetPon[I][16]),"")), oFont9, 100 )
								oPrn:Say( Li+nIncr, nCol+0950, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][15]),"00:00",TTOC(aVetPon[I][15])),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][17]),"00:00",TTOC(aVetPon[I][17])),"00:00")) , ofont9, 100 )
								nIncr += 35
							ENDIF
							IF !EMPTY(aVetPon[I][18])
								oPrn:Say( Li+nIncr, nCol+1160, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][14]),"",aVetPon[I][14]),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][18]),"",aVetPon[I][18]),"")), oFont9, 100 )
								oPrn:Say( Li+nIncr, nCol+0950, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][15]),"00:00",TTOC(aVetPon[I][15])),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][19]),"00:00",TTOC(aVetPon[I][19])),"00:00")) , ofont9, 100 )
								nIncr += 35
							ENDIF
							IF !EMPTY(aVetPon[I][20])
								oPrn:Say( Li+nIncr, nCol+1160, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][14]),"",aVetPon[I][14]),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][20]),"",aVetPon[I][20]),"")), oFont9, 100 )
								oPrn:Say( Li+nIncr, nCol+0950, IIF(nRpt==1,IIF(EMPTY(aVetPon[I][15]),"00:00",TTOC(aVetPon[I][15])),IIF(nRpt==2,IIF(EMPTY(aVetPon[I][21]),"00:00",TTOC(aVetPon[I][21])),"00:00")) , ofont9, 100 )
								nIncr += 35
							ENDIF
							
						ENDIF
					NEXT nRpt
					
					cMat1 := aVetPon[I][2]
					I++
					//VERIFICA SE A POSICAO 25/26 DO VETOR TEM CONTEUDO, CASO SIM O MESMO REALIZA IMPRESSAO DE UMA NOVA LINHA
					//PARA DEMONSTRAR A EXCECAO PARTICULAR DA FLS
					IF !EMPTY(aVetPon[I-1][25]) .OR. !EMPTY(aVetPon[I-1][26])
						IMPEXCLS(aVetPon,i-1)
					ENDIF
					
					IF LEN(aVetPon) >= I
						cMat2 := aVetPon[I][2]
					ELSE
						cMat2 := ""
					ENDIF
					//nDias++
					//nRepet := 1
			ENDDO
				// LINHAS                   
				
				if ( nIncr <= 2580 )
					//SUPERIOR
					oPrn:Line( 0020, 0030,0020, 2300 )
					//ESQUERDO
					oPrn:Line( 0020, 0030,3330, 0030 )
				
					//DIREITO
					oPrn:Line( 0020, 2300,3330, 2300 )
					//INFERIOR
					oPrn:Line( 3330, 0030,3330, 2300 )
					oPrn:Box( 480, 040, 2600, 2290 )        //  2740 - 2600
					
					// COLUNAS
			 		oPrn:Line(410, 1860,2600, 1860 )
				else
					//SUPERIOR
					oPrn:Line( 0020, 0030,0020, 2300 )
					//ESQUERDO
					oPrn:Line( 0020, 0030,3330, 0030 )
					//DIREITO
					oPrn:Line( 0020, 2300,3330, 2300 )
					//INFERIOR
					oPrn:Line( 3330, 0030,3330, 2300 )
					oPrn:Box( 480, 040, 3320, 2290 )        //  2740 - 2600
					
					// COLUNAS
	 				oPrn:Line(410, 1860,3320, 1860 )     
					
					nLinCd := 525
					FOR nCo := 1 TO 69 //63 - 59
					 //	oPrn:Line( nLinCd, 1680,nLinCd, 1770 )
						oPrn:Line( nLinCd, 1900,nLinCd, 2290 )
						nLinCd += 35
					NEXT nCo
					 
					oPrn:EndPage()     
					
					//cria nova p�gina
					Li    := 50
					nCol  := 50
					nIncr := 0
					nPag ++
					oPrn:StartPage()
					If cEmpAnt = "21"
						oPrn:SayBitmap( Li+000, nCol+000, cBitMap, 365, 152 )
					ElseIf cEmpAnt = "02"
						oPrn:SayBitmap( Li+000, nCol+000, cBitMap1, 365, 152 )
					Endif     
					
					nIncr += 030   
					
					dbSelectArea("SRA")
					dbSetorder(1)
					dbGoTop()
					dbSeek(XFILIAL("SRA")+aVetPon[1][2],.T.)
					nIncr += 000
					oPrn:Say( Li+nIncr, nCol+0050, "Cart�o Ponto", oFont6, 100 )
					nIncr += 080
					oPrn:Say( Li+nIncr, nCol+0400, SM0->M0_NOMECOM, ofont9, 100 )
					oPrn:Say( Li+nIncr, nCol+1100, "CNPJ: "+TRANSFORM(SM0->M0_CGC, "@R ##.###.###/####-##"), ofont9, 100 )
					oPrn:Say( Li+nIncr, nCol+1450, "ENDERE�O: "+SM0->M0_ENDCOB, ofont9, 100 )
					oPrn:Say( Li+nIncr, nCol+2000, SM0->M0_CIDCOB, ofont9, 100 )
					oPrn:Box( 210, 040, 340, 2290 )
					nIncr += 60
					oPrn:Say( Li+nIncr, nCol+0000, "MATR�CULA: "+ALLTRIM(aVetPon[1][2]), oFont2, 100 )
					oPrn:Say( Li+nIncr, nCol+0950, "FUN��O: "+ALLTRIM(POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")), oFont2, 100 )
					nIncr += 40
					oPrn:Say( Li+nIncr, nCol+0000, "NOME: "+ALLTRIM(SRA->RA_NOME), oFont2, 100 )
					oPrn:Say( Li+nIncr, nCol+0950, "HOR�RIO: "+ALLTRIM(POSICIONE("SR6",1,XFILIAL("SR6")+SRA->RA_TNOTRAB,"R6_DESC")), oFont2, 100 )
					nIncr += 40
					oPrn:Say( Li+nIncr, nCol+0000, "C.C.: "+ALLTRIM(POSICIONE("SI3",1,XFILIAL("SI3")+SRA->RA_CC,"I3_DESC")), oFont2, 100 )
					oPrn:Say( Li+nIncr, nCol+0950, "JORNADA DE TRABALHO SEMANAL: "+ALLTRIM(STR(SRA->RA_HRSEMAN))+" HORAS", oFont2, 100 )
					nIncr += 100
					oPrn:Box( 350, 040, 400, 2290 )
					oPrn:Say( Li+nIncr-40, nCol+0000, "CART�O PONTO", oFont2, 100 )                  
					oPrn:Say( Li+nIncr-40, nCol+1380, "PERIODO:", oFont2, 100 )
	    			oPrn:Say( Li+nIncr-40, nCol+1800, dtoc(mv_par11)+ " a " +dtoc(mv_par12), ofont2, 100)
 					nIncr += 40
					
					oPrn:Box( 410, 040, 480, 2290 )
 					oPrn:Say( Li+nIncr, nCol+0030, "DATA		MARCA��ES", oFont2, 100 )
					oPrn:Say( Li+nIncr, nCol+1160, "DESCRI��O", oFont2, 100 )  //1200-1130
					oPrn:Say( Li+nIncr, nCol+0940, "QTDE", oFont2, 100 )
 					oPrn:Say( Li+nIncr, nCol+1850, "OBSERVACAO", oFont2, 100 )
					
					nIncr += 65
					
					//SUPERIOR
					oPrn:Line( 0020, 0030,0020, 2300 )
					//ESQUERDO
					oPrn:Line( 0020, 0030,3330, 0030 )
					//DIREITO
					oPrn:Line( 0020, 2300,3330, 2300 )
					//INFERIOR
					oPrn:Line( 3330, 0030,3330, 2300 )
					oPrn:Box( 480, 040, 2600, 2290 )        //  2740 - 2600
					
					// COLUNAS
 				oPrn:Line(410, 1860,2600, 1860 )
				endif
				nIncr := 2580 //2690 - 2580
				oPrn:Box(2600, 040, 2770, 2290 )  //2740 - 2600   2880 - 2770
				oPrn:Line(2600, 0800,2770, 0800 )
				oPrn:Line(2600, 1600,2770, 1600 )
		 		nIncr += 90
		 		nIncr += 50
	 			nIncr += 40
				nColPg := 0     
				cQueryIn := "select p6_codigo, p6_desc "
				cQueryIn += "  from  " + RetSQLName("SP6")
				cQueryIn += " where d_e_l_e_t_ <> '*' "  
				// trar� somente os novos c�digos a partir da portaria 1510 implantada no mes 02/2010
				if (DDATABASE < ctod("01/02/2010"))
					cQueryIn += "   and length(p6_codigo) = 3 "
				else
					cQueryIn += "   and length(p6_codigo) = 2 "
				endif
				cQueryIn += " order by p6_codigo "
				                                  
				If (Select("TMP2") <> 0)
					dbSelectArea("TMP2")
					dbCloseArea()
				Endif
				cQueryIn := changeQuery(cQueryIn)
				TcQuery cQueryIn NEW ALIAS "TMP2"
				
				dbSelectArea("TMP2")
				dbGoTop()
				WHILE !EOF()
					oPrn:Say( Li+nIncr, nCol+nColPg, ALLTRIM(TMP2->P6_CODIGO)+" - "+ALLTRIM(TMP2->P6_DESC), ofont9, 100 )
					IF nColPg == 1650
						nColPg := 0
						nIncr += 35
					ELSE
						nColPg += 550
					ENDIF
					dbSelectArea("TMP2")
					dbSkip()
				ENDDO
				dbSelectArea("SPG")
				nLinCd := 525
				FOR nCo := 1 TO 59 //63 - 59
				//	oPrn:Line( nLinCd, 1680,nLinCd, 1770 )
					oPrn:Line( nLinCd, 1900,nLinCd, 2290 )
					nLinCd += 35
				NEXT nCo 
				
				oPrn:EndPage()
				IF LEN(aVetPon) >= I
					cMat1 := aVetPon[I][2]
					cMat2 := aVetPon[I][2]
				ENDIF
			ENDIF
			I--
		NEXT I
		nItem := 0
		oPrn:Preview()
	ELSE
		MSGALERT("N�O EXISTEM DADOS PARA OS PARAMETROS INFORMADOS!")
	ENDIF
	
ENDIF
//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()



Return



*-----------------------------------------------------------------*
Static Function ajustaSX1()
*-----------------------------------------------------------------*
_sAlias := Alias()
aRegs :={}

dbSelectArea("SX1")
dbSetOrder(1)
aAdd(aRegs,{cperg,"01","Filial de           ?","","","mv_ch1","C",07,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0","",""})
aAdd(aRegs,{cperg,"02","Filial ate          ?","","","mv_ch2","C",07,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0","",""})
aAdd(aRegs,{cperg,"03","Centro de Custo de  ?","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT","",""})
aAdd(aRegs,{cperg,"04","Centro de Custo ate ?","","","mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT","",""})
aAdd(aRegs,{cperg,"05","Matricula de        ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA","",""})
aAdd(aRegs,{cperg,"06","Matricula ate       ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA","",""})
aAdd(aRegs,{cperg,"07","Turno de            ?","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SR6","",""})
aAdd(aRegs,{cperg,"08","Turno ate           ?","","","mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SR6","",""})
aAdd(aRegs,{cperg,"09","Nome de             ?","","","mv_ch9","C",30,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"10","Nome ate            ?","","","mv_cha","C",30,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"11","Data de             ?","","","mv_chf","D",08,0,0,"G","NaoVazio()","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"12","Data ate            ?","","","mv_chg","D",08,0,0,"G","NaoVazio()","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"13","Situacoes           ?","","","mv_chh","C",05,0,0,"G","fSituacao","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"14","Categorias          ?","","","mv_chi","C",15,0,0,"G","fCategoria","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"15","Exce��es            ?","","","mv_chj","N",01,0,0,"C","","mv_par15","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cperg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return .t.

//TRANSFORMA HORA NUMERICA EM HORA CARACTER
*-----------------------------------------------------------------*
Static Function TTOC(nHora)
*-----------------------------------------------------------------*
Local nHora
Local cHora := ""

cInd  := ""
IF LEN(ALLTRIM(STR(INT(nHora)))) == 1
	cInt := "0"+ALLTRIM(STR(INT(nHora)))
ELSE
	IF LEN(ALLTRIM(STR(INT(nHora)))) == 2
		cInt := ALLTRIM(STR(INT(nHora)))
	ELSE
		cInt := "00"
	ENDIF
ENDIF
IF LEN(ALLTRIM(SUBSTR(ALLTRIM(STR(nHora-INT(nHora))),3,2))) == 1
	cDev := (ALLTRIM(SUBSTR(ALLTRIM(STR(nHora-INT(nHora))),3,2)))+"0"  
	// controlar se os minutos s�o superiores a 60
	if val(cDev) > 60
		// se � superior atualizar a hora para mais 1 e a realizar diferen�a do minuto superior
		// com 60
		cDev := (ALLTRIM(STR(VAL(cDev) - 60)))
		if len(alltrim(cDev)) = 1
			cDev := "0"+cDev
		endif
		cInt := (alltrim(str(val(cInt) + 1)))
		if len(alltrim(cInt)) == 1
			cInt := "0"+cInt
		endif
	endif
ELSE
	IF LEN(ALLTRIM(SUBSTR(ALLTRIM(STR(nHora-INT(nHora))),3,2))) == 2
		cDev := (ALLTRIM(SUBSTR(ALLTRIM(STR(nHora-INT(nHora))),3,2)))
		// controlar se os minutos s�o superiores a 60       
			// controlar se os minutos s�o superiores a 60
		if val(cDev) > 60
			// se � superior atualizar a hora para mais 1 e a realizar diferen�a do minuto superior
			// com 60
			cDev := (ALLTRIM(STR(VAL(cDev) - 60)))
			if len(alltrim(cDev)) = 1
				cDev := "0"+cDev
			endif
			cInt := (alltrim(str(val(cInt) + 1)))
			if len(alltrim(cInt)) == 1
				cInt := "0"+cInt
			endif
		endif
	ELSE
		cDev := "00"
	ENDIF
ENDIF
cHora := cInt+":"+cDev


Return cHora

*-----------------------------------------------------------------*
Static Function CALCSP2(aVetSp2,nCon)
*-----------------------------------------------------------------*
Local aVetSp2,nCon
Local nPositP2 := 0

IF DIASEMANA(STOD(aVetSp2[nCon][3])) # "Sabado" .and. DIASEMANA(STOD(aVetSp2[nCon][3])) # "Domingo"
	cQuery := " SELECT P2_MAT, P2_DATA, P2_DATAATE, P2_MOTIVO, P2_TURNO, P2_TRABA, P2_ENTRA1, P2_SAIDA1, P2_ENTRA2, "
	cQuery += " P2_SAIDA2, P2_ENTRA3, P2_SAIDA3, P2_ENTRA4, P2_SAIDA4, P2_TOTHORA, PJ_TURNO, PJ_DIA, PJ_TPDIA, PJ_ENTRA1, "
	cQuery += " PJ_ENTRA1, PJ_SAIDA1, PJ_ENTRA2, PJ_SAIDA2, PJ_ENTRA3, PJ_SAIDA3, PJ_ENTRA4, PJ_SAIDA4 "
	cQuery += " FROM " + RetSQLName("SP2") + " AS SP2, " + RetSQLName("SPJ") + " AS SPJ "
	cQuery += " WHERE SP2.D_E_L_E_T_<>'*'  AND SP2.P2_FILIAL = '" + XFILIAL("SP2") + "' AND "
	cQuery += " '"+aVetSp2[nCon][3]+"' BETWEEN SP2.P2_DATA AND SP2.P2_DATAATE AND "
	cQuery += " (SP2.P2_MAT = '"+aVetSp2[nCon][2]+"' OR (SP2.P2_TURNO = '"+aVetSp2[nCon][4]+"' AND SP2.P2_MAT = '' )) AND "
	cQuery += " SP2.P2_TRABA = 'S' AND SP2.P2_TURNO = SPJ.PJ_TURNO AND "
	cQuery += " (SP2.P2_ENTRA1 <> SPJ.PJ_ENTRA1 OR SP2.P2_ENTRA2 <> SPJ.PJ_ENTRA2 OR SP2.P2_ENTRA3 <> SPJ.PJ_ENTRA3 OR SP2.P2_ENTRA4 <> SPJ.PJ_ENTRA4 OR "
	cQuery += "  SP2.P2_SAIDA1 <> SPJ.PJ_SAIDA1 OR SP2.P2_SAIDA2 <> SPJ.PJ_SAIDA2 OR SP2.P2_SAIDA3 <> SPJ.PJ_SAIDA3 OR SP2.P2_SAIDA4 <> SPJ.PJ_SAIDA4) AND "
	cQuery += " SPJ.PJ_DIA = '"+ALLTRIM(STR(DOW(STOD(aVetSp2[nCon][3]))))+"'  "
	
	memowrite("C:\Coleta\LTSSP2.TXT",cQuery)
	TCQUERY cQuery NEW ALIAS "TMPSP2"
	dbSelectArea("TMPSP2")
	dbGoTop()
	xx := 1
	IF !EOF()
		WHILE !EOF()
			IF !EMPTY(TMPSP2->P2_MAT)
				nPositP2 := xx
			ENDIF
			dbSkip()
			xx++
		ENDDO
	ENDIF
	dbGoTop()
	xx := 1
	IF !EOF()
		WHILE !EOF()
			DO CASE
				CASE (TMPSP2->P2_ENTRA1 # TMPSP2->PJ_ENTRA1 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_ENTRA1 # TMPSP2->PJ_ENTRA1 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][6])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][6] , SUBHORAS(TMPSP2->PJ_ENTRA1,TMPSP2->P2_ENTRA1))) > SOMAHORAS(TMPSP2->PJ_ENTRA1,0.05).OR.(SOMAHORAS(aVetSp2[i][6] , SUBHORAS(TMPSP2->PJ_ENTRA1,TMPSP2->P2_ENTRA1))) < (SOMAHORAS(TMPSP2->PJ_ENTRA1,0.05)),TMPSP2->P2_MOTIVO,"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][6] , SUBHORAS(TMPSP2->PJ_ENTRA1,TMPSP2->P2_ENTRA1))) > SOMAHORAS(TMPSP2->PJ_ENTRA1,0.05).OR.(SOMAHORAS(aVetSp2[i][6] , SUBHORAS(TMPSP2->PJ_ENTRA1,TMPSP2->P2_ENTRA1))) < (SOMAHORAS(TMPSP2->PJ_ENTRA1,0.05)),SUBHORAS(TMPSP2->PJ_ENTRA1,TMPSP2->P2_ENTRA1),"")
					ENDIF
				CASE (TMPSP2->P2_ENTRA2 # TMPSP2->PJ_ENTRA2 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_ENTRA2 # TMPSP2->PJ_ENTRA2 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][8])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][8] , SUBHORAS(TMPSP2->PJ_ENTRA2,TMPSP2->P2_ENTRA2))) > SOMAHORAS(TMPSP2->PJ_ENTRA2,0.05).OR.(SOMAHORAS(aVetSp2[i][8] , SUBHORAS(TMPSP2->PJ_ENTRA2,TMPSP2->P2_ENTRA2))) < (SOMAHORAS(TMPSP2->PJ_ENTRA2,0.05)),TMPSP2->P2_MOTIVO,"")
						//						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][8] , SUBHORAS(TMPSP2->PJ_ENTRA2,TMPSP2->P2_ENTRA2))) > SOMAHORAS(TMPSP2->PJ_ENTRA2,0.05).OR.(SOMAHORAS(aVetSp2[i][8] , SUBHORAS(TMPSP2->PJ_ENTRA2,TMPSP2->P2_ENTRA2))) < (SOMAHORAS(TMPSP2->PJ_ENTRA2,0.05)),SUBHORAS(TMPSP2->PJ_ENTRA2,aVetSp2[i][8]),"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][8] , SUBHORAS(TMPSP2->PJ_ENTRA2,TMPSP2->P2_ENTRA2))) > SOMAHORAS(TMPSP2->PJ_ENTRA2,0.05).OR.(SOMAHORAS(aVetSp2[i][8] , SUBHORAS(TMPSP2->PJ_ENTRA2,TMPSP2->P2_ENTRA2))) < (SOMAHORAS(TMPSP2->PJ_ENTRA2,0.05)),SUBHORAS(TMPSP2->PJ_ENTRA2,TMPSP2->P2_ENTRA2),"")
					ENDIF
				CASE (TMPSP2->P2_ENTRA3 # TMPSP2->PJ_ENTRA3 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_ENTRA3 # TMPSP2->PJ_ENTRA3 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][10])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][10] , SUBHORAS(TMPSP2->PJ_ENTRA3,TMPSP2->P2_ENTRA3))) > SOMAHORAS(TMPSP2->PJ_ENTRA3,0.05).OR.(SOMAHORAS(aVetSp2[i][10] , SUBHORAS(TMPSP2->PJ_ENTRA3,TMPSP2->P2_ENTRA3))) < (SOMAHORAS(TMPSP2->PJ_ENTRA3,0.05)),TMPSP2->P2_MOTIVO,"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][10] , SUBHORAS(TMPSP2->PJ_ENTRA3,TMPSP2->P2_ENTRA3))) > SOMAHORAS(TMPSP2->PJ_ENTRA3,0.05).OR.(SOMAHORAS(aVetSp2[i][10] , SUBHORAS(TMPSP2->PJ_ENTRA3,TMPSP2->P2_ENTRA3))) < (SOMAHORAS(TMPSP2->PJ_ENTRA3,0.05)),SUBHORAS(TMPSP2->PJ_ENTRA3,TMPSP2->P2_ENTRA3),"")
					ENDIF
				CASE (TMPSP2->P2_ENTRA4 # TMPSP2->PJ_ENTRA4 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_ENTRA4 # TMPSP2->PJ_ENTRA4 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][12])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][12] , SUBHORAS(TMPSP2->PJ_ENTRA4,TMPSP2->P2_ENTRA4))) > SOMAHORAS(TMPSP2->PJ_ENTRA4,0.05).OR.(SOMAHORAS(aVetSp2[i][12] , SUBHORAS(TMPSP2->PJ_ENTRA4,TMPSP2->P2_ENTRA4))) < (SOMAHORAS(TMPSP2->PJ_ENTRA4,0.05)),TMPSP2->P2_MOTIVO,"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][12] , SUBHORAS(TMPSP2->PJ_ENTRA4,TMPSP2->P2_ENTRA4))) > SOMAHORAS(TMPSP2->PJ_ENTRA5,0.05).OR.(SOMAHORAS(aVetSp2[i][12] , SUBHORAS(TMPSP2->PJ_ENTRA4,TMPSP2->P2_ENTRA4))) < (SOMAHORAS(TMPSP2->PJ_ENTRA4,0.05)),SUBHORAS(TMPSP2->PJ_ENTRA4,TMPSP2->P2_ENTRA4),"")
					ENDIF
				CASE (TMPSP2->P2_SAIDA1 # TMPSP2->PJ_SAIDA1 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_SAIDA1 # TMPSP2->PJ_SAIDA1 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][7])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][7] , SUBHORAS(TMPSP2->PJ_SAIDA1,TMPSP2->P2_SAIDA1))) > SOMAHORAS(TMPSP2->PJ_SAIDA1,0.05).OR.(SOMAHORAS(aVetSp2[i][7] , SUBHORAS(TMPSP2->PJ_SAIDA1,TMPSP2->P2_SAIDA1))) < (SOMAHORAS(TMPSP2->PJ_SAIDA1,0.05)),TMPSP2->P2_MOTIVO,"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][7] , SUBHORAS(TMPSP2->PJ_SAIDA1,TMPSP2->P2_SAIDA1))) > SOMAHORAS(TMPSP2->PJ_SAIDA1,0.05).OR.(SOMAHORAS(aVetSp2[i][7] , SUBHORAS(TMPSP2->PJ_SAIDA1,TMPSP2->P2_SAIDA1))) < (SOMAHORAS(TMPSP2->PJ_SAIDA1,0.05)),SUBHORAS(TMPSP2->P2_SAIDA1,TMPSP2->PJ_SAIDA1),"")
					ENDIF
				CASE (TMPSP2->P2_SAIDA2 # TMPSP2->PJ_SAIDA2 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_SAIDA2 # TMPSP2->PJ_SAIDA2 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][9])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][9] , SUBHORAS(TMPSP2->PJ_SAIDA2,TMPSP2->P2_SAIDA2))) > SOMAHORAS(TMPSP2->PJ_SAIDA2,0.05).OR.(SOMAHORAS(aVetSp2[i][9] , SUBHORAS(TMPSP2->PJ_SAIDA2,TMPSP2->P2_SAIDA2))) < (SOMAHORAS(TMPSP2->PJ_SAIDA2,0.05)),TMPSP2->P2_MOTIVO,"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][9] , SUBHORAS(TMPSP2->PJ_SAIDA2,TMPSP2->P2_SAIDA2))) > SOMAHORAS(TMPSP2->PJ_SAIDA2,0.05).OR.(SOMAHORAS(aVetSp2[i][9] , SUBHORAS(TMPSP2->PJ_SAIDA2,TMPSP2->P2_SAIDA2))) < (SOMAHORAS(TMPSP2->PJ_SAIDA2,0.05)),SUBHORAS(TMPSP2->P2_SAIDA2,TMPSP2->PJ_SAIDA2),"")
					ENDIF
				CASE (TMPSP2->P2_SAIDA3 # TMPSP2->PJ_SAIDA3 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_SAIDA3 # TMPSP2->PJ_SAIDA3 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][11])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][11] , SUBHORAS(TMPSP2->PJ_SAIDA3,TMPSP2->P2_SAIDA3))) > SOMAHORAS(TMPSP2->PJ_SAIDA3,0.05).OR.(SOMAHORAS(aVetSp2[i][11] , SUBHORAS(TMPSP2->PJ_SAIDA3,TMPSP2->P2_SAIDA3))) < (SOMAHORAS(TMPSP2->PJ_SAIDA3,0.05)),TMPSP2->P2_MOTIVO,"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][11] , SUBHORAS(TMPSP2->PJ_SAIDA3,TMPSP2->P2_SAIDA3))) > SOMAHORAS(TMPSP2->PJ_SAIDA3,0.05).OR.(SOMAHORAS(aVetSp2[i][11] , SUBHORAS(TMPSP2->PJ_SAIDA3,TMPSP2->P2_SAIDA3))) < (SOMAHORAS(TMPSP2->PJ_SAIDA3,0.05)),SUBHORAS(TMPSP2->P2_SAIDA3,TMPSP2->PJ_SAIDA3),"")
					ENDIF
				CASE (TMPSP2->P2_SAIDA4 # TMPSP2->PJ_SAIDA4 .AND. nPositP2 == 0) .or. (nPositP2 > 0 .and. TMPSP2->P2_SAIDA4 # TMPSP2->PJ_SAIDA4 .and. xx == nPositP2)
					IF !EMPTY(aVetPon[i][13])
						aVetPon[i][25] := IIF((SOMAHORAS(aVetSp2[i][13] , SUBHORAS(TMPSP2->PJ_SAIDA4,TMPSP2->P2_SAIDA4))) > SOMAHORAS(TMPSP2->PJ_SAIDA4,0.05).OR.(SOMAHORAS(aVetSp2[i][13] , SUBHORAS(TMPSP2->PJ_SAIDA4,TMPSP2->P2_SAIDA4))) < (SOMAHORAS(TMPSP2->PJ_SAIDA4,0.05)),TMPSP2->P2_MOTIVO,"")
						aVetPon[i][26] := IIF((SOMAHORAS(aVetSp2[i][13] , SUBHORAS(TMPSP2->PJ_SAIDA4,TMPSP2->P2_SAIDA4))) > SOMAHORAS(TMPSP2->PJ_SAIDA4,0.05).OR.(SOMAHORAS(aVetSp2[i][13] , SUBHORAS(TMPSP2->PJ_SAIDA4,TMPSP2->P2_SAIDA4))) < (SOMAHORAS(TMPSP2->PJ_SAIDA4,0.05)),SUBHORAS(TMPSP2->P2_SAIDA4,TMPSP2->PJ_SAIDA4),"")
					ENDIF
			ENDCASE
			dbSkip()
			xx++
		ENDDO
	ENDIF
	dbSelectArea("TMPSP2")
	dbCloseArea("TMPSP2")
Endif
Return .t.

*-----------------------------------------------------------------*
Static Function IMPEXCLTS(aVetExc,xx)
*-----------------------------------------------------------------*
Local aVetExc


cHoraImp := IIF(EMPTY(aVetExc[xx][6]),"",TTOC(aVetExc[xx][6]))+SPACE(5)+IIF(EMPTY(aVetExc[xx][7]),"",TTOC(aVetExc[xx][7]))+SPACE(5);
+IIF(EMPTY(aVetExc[xx][8]),"",TTOC(aVetExc[xx][8]))+SPACE(5)+IIF(EMPTY(aVetExc[xx][9]),"",TTOC(aVetExc[xx][9]))+SPACE(5);
+IIF(EMPTY(aVetExc[xx][10]),"",TTOC(aVetExc[xx][10]))+SPACE(5)+IIF(EMPTY(aVetExc[xx][11]),"",TTOC(aVetExc[xx][11]))+SPACE(5);
+IIF(EMPTY(aVetExc[xx][12]),"",TTOC(aVetExc[xx][12]))+SPACE(5)+iIF(EMPTY(aVetExc[xx][13]),"",TTOC(aVetExc[xx][13]))
                                         
    
// cDatap := SP8->P8_DATA
 //oPrn:Say( Li+nIncr, nCol+0000, dtoc(cDatap) , ofont9, 100 )
  

//oPrn:Say( Li+nIncr, nCol+0000, ALLTRIM(STR(nDias)) , ofont9, 100 )
//oPrn:Say( Li+nIncr, nCol+0080, SUBSTR(DIASEMANA(STOD(aVetExc[xx][3])),0,3), ofont9, 100 )
                                                                       
 
oPrn:Say( Li+nIncr, nCol+1100, aVetExc[xx][25] , ofont9, 100 )
//oPrn:Say( Li+nIncr, nCol+1500, TTOC(aVetExc[xx][26]) , ofont9, 100 )
oPrn:Say( Li+nIncr, nCol+800, TTOC(aVetExc[xx][26]) , ofont9, 100 )

nIncr += 35

Return .t.      
                                                                
//Fun��o com a responsabilidade de trazer o ultimo dia do mes passado por parametro.
*-----------------------------------------------------------------*
Static Function ULTDIA(dData)
*-----------------------------------------------------------------*
Local nMes := MONTH(dData)
FOR n := 21 to 20
	dData++
	IF nMes # MONTH(dData)
		dData--
		exit
	ENDIF
NEXT n
return(DAY(dData)) 