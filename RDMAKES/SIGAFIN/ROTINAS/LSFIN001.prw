#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LSFIN001()º Autor ³ Jefferson Mittanck       ³  05/10/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para carregar automaticamente as configurações      º±±
±±º          ³ para envio/retorno de CNAB                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio Silvestre -  Rotinas de envio e retorno de CNAB  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LSFIN001()
                    
Local ntam := 0 

DbSelectArea("SEE")
DbGoTop()           
DbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³Ira buscar na tabela SEE com base nos parametros informados na consulta³
//³padrão (banco+conta+agencia+subconta), o arquivo de configuração do    ³
//³CNAB conforme configurado na rotina de parametros de bancos.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³Ira preencher o campo de diretorio na rotina de geração do arquivo de CNAB de acordo com o         ³
//³diretorio padrão informando na rotina de parametro de bancos (SEE) + expressão do banco + Data Base³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³

If ISINCALLSTACK("FINA150")    // Geração do arquivo de Remessa de cobrança
	If Dbseek(xFilial("SEE")+mv_par05+mv_par06+mv_par07+mv_par08)
		mv_par03 := Alltrim(SEE->EE_X_ARQRM)
		mv_par09 := If(SEE->EE_NRBYTES == 400, 1 ,2)		
		If mv_par05 = "001" // BANCO DO BRASIL
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "LF" + SubStr(SEE->EE_CONTA,1,2) + SubStr(Alltrim(SEE->EE_ULTDSK),3,4)
		ElseIf mv_par05 = "237" // BRADESCO
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "CB" + InfoData() + "01" + Alltrim(SEE->EE_EXTEN) 
		ElseIf mv_par05 = "341" // ITAU
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "r" + GRAVADATA(DDATABASE,.F.,1) + "1." + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "422" // SAFRA
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "LF" + SubStr(SEE->EE_CONTA,1,3) + SubStr(Alltrim(SEE->EE_ULTDSK),3,4) + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "748" // SICREDI
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + Alltrim(SEE->EE_CODEMP) + InfoData() + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + "." + Alltrim(SEE->EE_EXTEN)
		ElseIf mv_par05 = "756" // SICOOB
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + Alltrim(SEE->EE_ULTDSK) + "_" + substr(SEE->EE_CODEMP,5,7) + "_" + InfoData() + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + "." + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "033" // SANTANDER
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + Alltrim(SEE->EE_ULTDSK) + "_" + substr(SEE->EE_CODEMP,5,7) + "_" + InfoData() + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + "." + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "655" // VOTORANTIM
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "r" + GRAVADATA(DDATABASE,.F.,1) + "1." + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "707" // DAYCOVAL
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "LXL" + SubStr(GRAVADATA(DDATABASE,.F.,1),1,4) + "1." + Alltrim(SEE->EE_EXTEN)
		

		EndIf 
		
	EndIf
	
ElseIf ISINCALLSTACK("FINA200") // Recepção do arquivo de retorno de Cobrança
	If Dbseek(xFilial("SEE")+mv_par06+mv_par07+mv_par08+mv_par09)

        // Incluido por Joel em 09/04/2012
	   /*	If mv_par06 $ '655/341/422'			
			If MSGBOX("Efetuar retorno de arquivo com envio antes de 09/04/2012 ?","Retorno CNAB","YESNO")  
		 		ntam := LEN(Alltrim(SEE->EE_X_ARQRT))
				mv_par05 := SUBSTR(Alltrim(SEE->EE_X_ARQRT),1,ntam-4)+"ANT"+SUBSTR(Alltrim(SEE->EE_X_ARQRT),ntam-3,4)
			Else
				mv_par05 := Alltrim(SEE->EE_X_ARQRT)			
			EndIf
		Else
			mv_par05 := Alltrim(SEE->EE_X_ARQRT)			
		EndIf
	*/	
		// Fim inclusao Joel em 09/04/2012
		
		mv_par05 := Alltrim(SEE->EE_X_ARQRT)
							
		mv_par12 := If(SEE->EE_NRBYTES == 400, 1 ,2)		
	EndIf
ElseIf ISINCALLSTACK("FINA151") // Geração do arquivo de Remessa de Instruções de cobrançaa
		If Dbseek(xFilial("SEE")+mv_par05+mv_par06+mv_par07+mv_par08)
		mv_par03 := Alltrim(SEE->EE_X_ARQRM)
		If mv_par05 = "001" // BANCO DO BRASIL
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "LF" + SubStr(SEE->EE_CONTA,1,2) + SubStr(Alltrim(SEE->EE_ULTDSK),3,4)
		ElseIf mv_par05 = "237" // BRADESCO
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "CB" + InfoData() + "01" + Alltrim(SEE->EE_EXTEN) 
		ElseIf mv_par05 = "341" // ITAU
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "r" + GRAVADATA(DDATABASE,.F.,1) + "1." + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "422" // SAFRA
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "LF" + SubStr(SEE->EE_CONTA,1,3) + SubStr(Alltrim(SEE->EE_ULTDSK),3,4) + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "748" // SICREDI
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + Alltrim(SEE->EE_CODEMP) + InfoData() + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + "." + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "756" // SICOOB
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + Alltrim(SEE->EE_ULTDSK) + "_" + substr(SEE->EE_CODEMP,5,7) + "_" + InfoData() + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + "." + Alltrim(SEE->EE_EXTEN)
		ElseIf mv_par05 = "033" // santander
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + Alltrim(SEE->EE_ULTDSK) + "_" + "_" + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + "." + Alltrim(SEE->EE_EXTEN)
		ElseIf mv_par05 = "655" // VOTORANTIM
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "r" + GRAVADATA(DDATABASE,.F.,1) + "1." + Alltrim(SEE->EE_EXTEN)	
		ElseIf mv_par05 = "707" // DAYCOVAL
			mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "LXL" + SubStr(GRAVADATA(DDATABASE,.F.,1),1,4) + "1." + Alltrim(SEE->EE_EXTEN)		
		EndIf
	EndIf
ElseIf ISINCALLSTACK("FINR650") // Relatório para leitura do arquivo de retorno do CNAB.
	If Dbseek(xFilial("SEE")+mv_par03+mv_par04+mv_par05+mv_par06)

        /* Incluido por Joel em 09/04/2012
		If mv_par03 $ '655/341/422'						
			If MSGBOX("Efetuar retorno de arquivo com envio antes de 09/04/2012 ?","Retorno CNAB","YESNO")  
				ntam := LEN(Alltrim(SEE->EE_X_ARQRT))
				mv_par02 := SUBSTR(Alltrim(SEE->EE_X_ARQRT),1,ntam-4)+"ANT"+SUBSTR(Alltrim(SEE->EE_X_ARQRT),ntam-3,4)
			Else
				mv_par02 := Alltrim(SEE->EE_X_ARQRT)					
			EndIf		
		Else		
			mv_par02 := Alltrim(SEE->EE_X_ARQRT)							
		EndIf	
		// Fim inclusao Joel em 09/04/2012 */
		
		mv_par02 := Alltrim(SEE->EE_X_ARQRT)
		mv_par08 := If(SEE->EE_NRBYTES == 400, 1 ,2)		
	EndIf

ElseIf ISINCALLSTACK("FINA420") // Geração do arquivo de remessa de pagamento
	If Dbseek(xFilial("SEE")+mv_par05+mv_par06+mv_par07+mv_par08)
		mv_par03 := Alltrim(SEE->EE_X_ARQRM)
		mv_par09 := If(SEE->EE_NRBYTES == 400, 1 ,2)		
		If mv_par05 = "001" // BANCO DO BRASIL
				mv_par04 := Alltrim(SEE->EE_X_DIRCN) + "BB" + Alltrim(SEE->EE_CONTA) + SubStr(Alltrim(SEE->EE_ULTDSK),3,4)
		ElseIf	mv_par05 = "756"
				mv_par03 := Alltrim(SEE->EE_X_ARQRM)
				mv_par04 := Alltrim(SEE->EE_X_DIRCN) + ALLTRIM(SEE->EE_CODEMP) + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + Strzero(VAL(Alltrim(Str(month(ddatabase)))),2) + "0"
		ElseIf mv_par05 = "748" // SICREDI
				If Alltrim(SEE->EE_SUBCTA) != "PAG"
				    Alert("O Selecione um banco de pagamentos!")
				    mv_par05 := ""
				Else
					If Aviso( "Atencao", "Escolha o tipo de remessa que deseja gerar!", {"Credito C/C", "Pag. Titulos"},) = 1
						mv_par03 := Alltrim(SEE->EE_X_ARQRM)
						mv_par04 := Alltrim(SEE->EE_X_DIRCN) + ALLTRIM(SEE->EE_CODEMP) + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + Strzero(VAL(Alltrim(Str(month(ddatabase)))),2) + "0"
					Else
						mv_par03 := Alltrim("SICREDIB.2PE ")
						mv_par04 := "BAE" + ALLTRIM(SEE->EE_CODEMP) + Strzero(VAL(Alltrim(Str(day(ddatabase)))),2) + Strzero(VAL(Alltrim(Str(month(ddatabase)))),2) + "0"
					EndIf
				EndIf			
				
		EndIf			
	EndIf

ElseIf ISINCALLSTACK("FINA430") // Recepção do arquivo de retorno de pagamento
	If Dbseek(xFilial("SEE")+mv_par05+mv_par06+mv_par07+mv_par08)
		mv_par04 := Alltrim(SEE->EE_X_ARQRT)
		mv_par10 := If(SEE->EE_NRBYTES == 400, 1 ,2)		
	EndIf
		
Endif
	
Return()
	

	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para calcular carcter para identificar o MES conforme necessidade do banco SICREDI.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function InfoData()
****************************
Local aAux :=  { "Janeiro", "Fevereiro", "Marco", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro" }
Local cAux := ""
Local nAux := Month( ddatabase )
Local cMes := aAux[ nAux ]

do case
	case nAux < 10
		cAux := Alltrim( Str( nAux ) )
		
	case nAux == 10
		cAux := "O"
		
	case nAux == 11
		cAux := "N"
		
	case nAux == 12
		cAux := "D"
		
	OtherWise
		cAux := Alltrim( Str( nAux ) )
		
endcase

Return( cAux )

/************************************
  CONTA BANCO DO BRASIL CM DIG "X"                                   
************************************/
User Function CONTASBB()
Local dRet := ""

	dRet := STRZERO(VAL(IF(EMPTY(Alltrim(SE2->E2_X_CTADP)),(SUBSTR(Alltrim(SA2->A2_NUMCON),1,LEN(Alltrim(SA2->A2_NUMCON))-1)),(SUBSTR(Alltrim(SE2->E2_X_CTADP),1,LEN(Alltrim(SE2->E2_X_CTADP))-1)))),12)+IF(EMPTY(Alltrim(SE2->E2_X_CTADP)),SUBSTR(Alltrim(SA2->A2_NUMCON),LEN(Alltrim(SA2->A2_NUMCON)),1),SUBSTR(Alltrim(SE2->E2_X_CTADP),LEN(Alltrim(SE2->E2_X_CTADP)),1))

Return(dRet)

/************************************
  AGENCIA BANCO DO BRASIL CM DIG "X"                                   
************************************/
User Function AGENCIASBB()
Local dRet := ""

dRet := STRZERO(VAL(IF(EMPTY(Alltrim(SE2->E2_X_AGDEP)),(SUBSTR(Alltrim(SA2->A2_AGENCIA),1,LEN(Alltrim(SA2->A2_AGENCIA))-1)),(SUBSTR(Alltrim(SE2->E2_X_AGDEP),1,LEN(Alltrim(SE2->E2_X_AGDEP))-1)))),5)+IF(EMPTY(Alltrim(SE2->E2_X_AGDEP)),SUBSTR(Alltrim(SA2->A2_AGENCIA),LEN(Alltrim(SA2->A2_AGENCIA)),1),SUBSTR(Alltrim(SE2->E2_X_AGDEP),LEN(Alltrim(SE2->E2_X_AGDEP)),1))

Return(dRet) 

/************************************
  CALCULA VALOR LANCAENTO CNAB PAG                                   
************************************/
User Function VLPAGLAN()
Local dRet := ""
Local x,i := 0

dRet := ((SE2->E2_SALDO-SE2->E2_DECRESC+SE2->E2_ACRESC)*100)

dRet := Transform(dRet, "@E 999999999999999")

x := (15 - LEN(Alltrim(dRet)))
i := 0

dRet := Alltrim(dRet)

While i < x
    dRet := "0" + dRet
    i := i + 1
EndDo
 
Return(dRet)
/************************************
  RETORNA VALOR DOCUMENTO CNAB PAG                                   
************************************/
User Function VLPAGDOC()
Local dRet := ""
Local x,i := 0

dRet := (SE2->E2_SALDO*100)

dRet := Transform(dRet, "@E 999999999999999")

x := (15 - LEN(Alltrim(dRet)))
i := 0

dRet := Alltrim(dRet)

While i < x
    dRet := "0" + dRet
    i := i + 1
EndDo
 
Return(dRet)  

/************************************
  RETORNA DATA LIMITE DO DESCONTO                                   
************************************/
User Function VENCDESC()

If STRZERO(INT(ROUND(SE1->E1_DECRESC*100,2)),13) != "0000000000000"               

	dRet := GRAVADATA(SE1->E1_VENCTO,.F.,1)                             
Else
	dRet := "000000"                             
EndIf
 
Return(dRet) 

/**********************************************************/
/*******  RETORNA ABATIMENTO DA INSTRUCAO DE COBRANCA *****/
/**********************************************************/

User Function VLABAT()
***********************

Local nAbat

If (SE1->E1_OCORREN == "04")
	nAbat := POSICIONE("FI2",1, SE1->E1_FILIAL+SE1->E1_SITUACA+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_OCORREN,"FI2->FI2_VALNOV")     
	nAbat := STRTRAN(nAbat,".","")
	nAbat := STRTRAN(nAbat,",",".")      
Else
    nAbat := "0"
EndIf

nAbat := STRZERO(INT(ROUND(VAL(nAbat)*100,2)),13)

Return(nAbat) 
