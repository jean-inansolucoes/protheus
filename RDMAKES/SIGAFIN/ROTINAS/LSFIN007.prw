#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
#include "rwmake.ch"
#include "colors.ch"
#include "ap5mail.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LSFIN007  �Autor  �Diego Coradini		 � Data �  13/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina respons�vel por gravar o codigo de barras dos t�tu- ���
���          � a pagar no processo de CNAB a pagar                        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico LATICINIO SILVESTRE                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LSFIN007()

Local aCampos	:={},aTam:={}
Local aCores 	:= {}     

cCadastro := "Visualiza��o Contas a Pagar"

aRotina   := {  { "Pesquisar"		,"AxPesqui"   	, 0, 1},;
                { "Visualizar"      ,"AxVisual"   	, 0, 2},;
                { "Ler C�digo"      ,'U_LERBARRA' 	, 0, 3},;
                { "Legenda"         ,'U_LEGANFIN001'	, 0, 5}}                                 

AADD(aCores, { 'Empty(SE2->E2_CODBAR)' 	 , 'BR_VERMELHO'}) 
AADD(aCores, { '!Empty(SE2->E2_CODBAR)'  , 'BR_VERDE'  	})    


    dbSelectArea("SE2")

	DBGOTOP()
    mBrowse( ,,,,"SE2",,,,,, aCores)
Return .t.

*---------------------
User Function LEGANFIN001()
*---------------------
	
Local	aCor2
Local 	cTitulo := "Boletos contas a Pagar"

	aCor2 := {{ 'BR_VERDE'    , "C�digo de Barras Lido" },; 
	          { 'BR_VERMELHO' , "Falta C�digo de Barras"}}
	
	BrwLegenda(cTitulo, "Legenda", aCor2)
	
Return .T.


User Function LERBARRA()     

Local cStr 			:= AllTrim(SE2->E2_CODBAR)
Local cFatVen		:= substr(cStr,6,4)		//FATOR DE VENCIMENTO DO DOCUMENTO EXTRAIDO DO CODIGO DE BARRAS
Local cVencto		:= CalcFV(cFatVen)      // VENCIMENTOS APOS CALCULO DO FATOR DE VENCIMENTO
Private M->E2_CODBAR:= SE2->E2_CODBAR

IF SE2->E2_SALDO=0
	MsgBox("T�tulo j� baixado!")      
	Return(.F.)   
ENDIF	

IF !EMPTY(CSTR)
	If SUBSTR(cStr,1,1) = "8"	
		msgAlert ("C�digo de barras validado!" + chr(13); 
		+ "Valor do documento: R$ " + transform( val(substr(cStr,5,11))/100,"@E 999,999,999.99" ) + chr(13))	
	Else
		MSGALERT("C�digo de barras validado!" + CHR(13);
		+ "Dados do c�digo de barras:" + CHR(13);
		+ "Valor do Documento: R$ " + TRANSFORM( VAL(SUBSTR(CSTR,10,10))/100,"@E 999,999,999.99" ) + CHR(13);
		+ "Data Vcto. Documento: " + DTOC(CVENCTO))
	Endif	
ENDIF


      DEFINE MSDIALOG oDlg1 TITLE "Ler C�digo de Barras" FROM 140,040 TO 488,620 PIXEL
      
    @ 013,30 Say "C�digo: " 
    @ 013,60 Get M->E2_CODBAR When .T. VALID U_PAGFORCB(M->E2_CODBAR) SIZE 140,10

    @ 007,10 TO 156,280  
    @ 160,200 bmpButton type 1 Action GRAVABAR(M->E2_CODBAR)
    @ 160,240 bmpbutton type 2 Action Close(oDlg1)      

      ACTIVATE MSDIALOG oDlg1 

Return .t.    
                        
Static Function GRAVABAR(BARRA)     
	    dbSelectArea("SE2")
		Reclock("SE2",.F.)
		Replace SE2->E2_CODBAR  With BARRA
		MsUnlock()               
Close(oDlg1)
RETURN .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  PAGFORCB    �Autor  �Jefferson Mittanck  � Data �  10/01/2012 ���
��������������������������������������������������������������������������͹��
���Desc.     �Programa para valida��o do C�digo de Barras e convers�o da   ���
���          �Linha Digit�vel do bloqueto em c�digo de barras.             ���
���          �FUNCAO EXECUTADA ATRAVEZ DE CHAMADA REALIZADO NA VALIDACAO DO���
���          �CAMPO E2_CODBAR - VALIDACAO DE USUARIO                       ���
��������������������������������������������������������������������������͹��
���Uso       � PROTHEUS 11                                                 ���
��������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function PAGFORCB()
*************************
Local cStr := AllTrim(M->E2_CODBAR)
Local cDVLD := ""	//DIGITO VERIFICADOR DA LINHA DIGITAVEL PARA COMPARACAO
Local cFatVen		//FATOR DE VENCIMENTO DO DOCUMENTO EXTRAIDO DO CODIGO DE BARRAS
           
// Verifica se o CAMPO est� vazio
If ValType(M->E2_CODBAR) == nil .OR. Empty(M->E2_CODBAR)
	MsgAlert("O campo deve ser preenchido com o C�digo de Barras" + chr(13) + "ou a Linha Digit�vel do bloqueto.")
	Return(.T.)
End

// Verifica se todos os d�gitos s�o num�rios
For i := 1 to Len(cStr)
	If !(Substr(cStr,i,1) $ "0123456789")
		MsgAlert("O campo deve ser preenchido apenas com n�meros!")
		Return(.F.)
	End
Next

If (Len(cStr) < 47) .and. (Len(cStr) <> 44) .and. substr(cStr,34,1) == "0"
	cStr := substr(cStr,1,33) + "00000000000000"
Endif

If ( (Len(cStr) != 44) .AND. (Len(cStr) != 47) .AND. (Len(cStr) != 48) )
	MsgAlert("Erro! " + chr(13) + "Quantidade de d�gitos incorreta. (" + cvaltochar(len(cStr)) + ").")
	Return(.F.)
End

If Len(cStr) == 48 .AND. SUBSTR(cStr,1,1) <> "8"
    MsgBox("Documento inv�lido! Somente � aceito documento DARF/Agua/Luz/Telefone com Linha Digit�vel iniciando com '8'")
    Return(.F.)
EndIf

// Codigo de barras
// Tam 48 - Linha Digitavel DARF/Agua/Luz/Telefone/etc
// Tam 47 - Linha Digitavel Boletos
// Tam 44 - Cod.Barras Boletos/DARF/Agua/Luz/etc

//�������������������������������������������������������������Ŀ
//�Tratamento para valida��o de c�digo de barras com 48 digitos.�
//�C�digos de barras referente a tributos e concessionarias.    �
//�Ex: DARF, fatura de agua, luz, telefone, etc.                �
//���������������������������������������������������������������

If Len(cStr) == 48 .AND. SUBSTR(cStr,1,1) = "8"
	// Converte LD para CB
	cDVLD := val(substr(cStr,4,1))		//EXTRAI O DIGITO VERIFICADOR DO CODIGO DE BARRAS DA LINHA DIGITAVEL
	cStr  := ConvLD(cStr) // Tam.44
	r 	  := CalcDV_CB(cStr,2)
	
	If r == cDVLD				//COMPARA O DIGITO VERIFICADOR CALCULADO COM O EXTRAIDO DA LINHA DIGITAVEL
		
		msgAlert ("C�digo de barras validado!" + chr(13); 
		+ "Valor do documento: R$ " + transform( val(substr(cStr,5,11))/100,"@E 999,999,999.99" ) + chr(13))

		M->E2_CODBAR := cStr
		return(.T.)
	Else
		msgAlert("Erro! " + chr(13) + "DV da Linha Digit�vel diferente do calculado. (" + cDVLD +" # "+ cvaltochar(r) +").")
		return(.F.)
	Endif
	
Else
	// Linha Digitavel Boletos
	If len(cStr) == 47
		cDVLD := substr(cStr,33,1)		//EXTRAI O DIGITO VERIFICADOR DO CODIGO DE BARRAS DA LINHA DIGITAVEL
		cStr := ConvLD(cStr)			//FUNCAO PARA CONVERSAO DA LINHA DIGITAVEL EM CODIGO DE BARRAS
		r := CalcDV_CB(cStr,1)
		
		If r == val(cDVLD)				//COMPARA O DIGITO VERIFICADOR CALCULADO COM O EXTRAIDO DA LINHA DIGITAVEL

			cFatVen := substr(cStr,6,4)
			If cFatVen == "0000"
				msgAlert("ATEN��O!" + chr(13);
				+ "O c�digo de barras n�o cont�m o fator de vencimento. " + chr(13);
				+ "Nesse caso, o banco acolhedor/recebedor estar� isento " + chr(13);
				+ "das responsabilidades pelo recebimento ap�s o vencimento." + chr(13);
				+ "Dados do c�digo de barras:" + chr(13);
				+ "Valor do documento: R$ " + transform( val(substr(cStr,10,10))/100,"@E 999,999,999.99" ) + chr(13);
				+ "Data vcto. documento: 00/00/00")
			Else
				cFatVen := CalcFV(cFatVen)
				msgAlert("C�digo de barras validado!" + chr(13);
				+ "Dados do c�digo de barras:" + chr(13);
				+ "Valor do documento: R$ " + transform( val(substr(cStr,10,10))/100,"@E 999,999,999.99" ) + chr(13);
				+ "Data vcto. documento: " + DTOC(cFatVen))
			Endif
			M->E2_CODBAR := cStr
			return(.T.)
		Else
			msgAlert("Erro! " + chr(13) + "DV da Linha Digit�vel diferente do calculado. (" + cDVLD +" # "+ cvaltochar(r) +").")
			return(.F.)
		Endif
	Else                          
	// C�digo de barras tamanho 44
        If substr(cStr,1,1) <> "8"
			cDVCB_ := val(substr(cStr,5,1))		//EXTRAI O DIGITO VERIFICADOR DO CODIGO DE BARRAS
			r := CalcDV_CB(cStr,1)
			If r == cDVCB_				//COMPARA O DIGITO VERIFICADOR CALCULADO COM O EXTRAIDO DA LINHA DIGITAVEL
				cFatVen := substr(cStr,6,4)
				cFatVen := CalcFV(cFatVen)			
					msgAlert ("C�digo de barras j� validado!" + chr(13);
					+ "Dados do c�digo de barras:" + chr(13);
					+ "Valor do documento: R$ " + transform( val(substr(cStr,10,10))/100,"@E 999,999,999.99" ) + chr(13);
					+ "Data vcto. documento: " + DTOC(cFatVen))
					M->E2_CODBAR := cStr
				return(.T.)
			Else
					msgAlert("Erro! " + chr(13) + "DV da Linha Digit�vel diferente do calculado. (" + cDVLD_ +" # "+ cvaltochar(r) +").")
					return(.F.)
			Endif			
		Else
			cDVCB_ := val(substr(cStr,4,1))		//EXTRAI O DIGITO VERIFICADOR DO CODIGO DE BARRAS
			r := CalcDV_CB(cStr,2)
			If r == cDVCB_				//COMPARA O DIGITO VERIFICADOR CALCULADO COM O EXTRAIDO DA LINHA DIGITAVEL
					msgAlert ("C�digo de barras j� validado!" + chr(13);
					+ "Valor do documento: R$ " + transform( val(substr(cStr,5,11))/100,"@E 999,999,999.99" ) + chr(13))
					M->E2_CODBAR := cStr
					return(.T.)
			Else
					msgAlert("Erro! " + chr(13) + "DV da Linha Digit�vel diferente do calculado. (" + cDVLD_ +" # "+ cvaltochar(r) +").")
					return(.F.)
			Endif			
				
		Endif
		
	Endif
Endif

Return(.T.)



/*
//���������������������������������������������������������������������������������������������������������������Ŀ
//�Fun��o para conversao da linha digitavel do bloqueto em codigo de barras, conforme Manual Operacional FEBRABAN.�
//�����������������������������������������������������������������������������������������������������������������
*/
//CONVERSAO DA LINHA DIGIT�VEL EM C�DIGO DE BARRAS
Static Function ConvLD(cStr)

Local cBcoMoed	:= ""	//C�DIGO DO BANCO E MOEDA "9 - REAL" (TAM-5)
Local cAgCart 	:= ""	//C�DIGO DA AG. S/ DIGITO MAIS A O PRIMEIRO DIGITO DA CARTEIRA (TAM-5)
Local cCartNN 	:= ""   //2o DIGITO DA CARTEIRA MAIS NOVE DIGITOS DO NOSSO NUMERO DO BLOQUETO (TAM-10)
Local cNNCCZ 	:= ""	//DOIS ULTIMOS DIGITOS NO NOSSO NUMERO, CONTA DO CEDENTE E ZERO PADRAO (TAM-10)
Local cDVCB 	:= ""	//DIGITO VERIFICADOR DO CODIGO DE BARRAS (TAM-1)
Local cFatVenc 	:= ""	//FATOR DE VENCIMENTO DO BLOQUETO (TAM-4)
Local cValTit 	:= ""	//VALOR NOMINAL DO TITULO (TAM-10)

cBcoMoed:= substr(cStr,1,4)
cAgCart := substr(cStr,5,5)
cCartNN	:= substr(cStr,11,10)
cNNCCZ 	:= substr(cStr,22,10)
cDVCB 	:= substr(cStr,33,1)
cFatVenc:= substr(cStr,34,4)
cValTit := substr(cStr,38,10)

// Jefferson
DO CASE
CASE LEN(cStr) == 47
	cStr := cBcoMoed + cDVCB + cFatVenc + cValTit + cAgCart + cCartNN + cNNCCZ
CASE LEN(cStr) == 48
   cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
OTHERWISE
	cStr := cStr+SPACE(48-LEN(cStr))
ENDCASE

Return(cStr)



// Calcula digito verificador para comparar
// nTipo: 1-Boleto ; 2-Faturas


//���������������������������������������������������������������������������������������������������������������������w��
//�Programa para realizar o calculo do digito verificador geral para comparar com o valor informado no c�digo de barras�
//���������������������������������������������������������������������������������������������������������������������w���
Static Function CalcDV_CB(cStr,nTipo)

Local i := 0
Local j := 4
Local r := 0
Local cCBAtu :=""

If nTipo = 1
	
	cCBAtu := substr(cStr,1,4) + substr(cStr,6,39)	//CODIGO DE BARRAS EXTRAIDO SEM O DIGITO VERIFICADOR, PARA SER CALCULADO
	for i := 1 to len(cCBAtu)
		r += Val(Substr(cCBAtu,i,1)) * j
		j--
		if j < 2
			j := 9
		Endif
	Next
	
	r := 11 - mod(r,11)
	if (r == 0) .or. (r == 1) .or. (r > 9)
		r := 1
	endif
	
Else
	// Consiste os quatro DV�s de T�tulos de Concession�rias de Servi�o P�blico e tributos pelo M�dulo 10.
	// CALCULA DV - BLOCO 1
	nMod  := 0
	nMult := 2
	nVal  := 0
	cCb   := SUBSTR(cStr,1,3) + SUBSTR(cStr,5,40)
	If SUBSTR(cStr,16,4) ==	"0232"	// Identifica o org�o arrecadador da guia. 0232 = Estado do Paran�
		r := val(CalDvBarGR(cCb))
	Else		
		For i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCb,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		Next
		r := 10 - MOD(nVal,10)
		r := IF(r==10,0,r) // Se o DV Calculado for 10 � assumido 0 (Zero).
	EndIf		
Endif

Return(r) // numerico

/*
//���������������������������������������������������������������������������������������������������������������Ŀ
//�Fun��o para c�lculo da data de vencimento baseado no fator de vencimento, conforme Manual Operacional FEBRABAN.�
//�����������������������������������������������������������������������������������������������������������������
*/
//FUNCAO PARA CALCULO DA DATA DE VENCIMENTO COM BASE NO FATOR DE VENCIMENTO
Static Function CalcFV(cFatVen)

Local ddata

ddata := CTOD("07/10/1997") + val(cFatVen)         

return(ddata)


//�������������������������������������������������������������������������������Ŀ
//�Fun��o para o calculo do digito verificador do c�digo de barras de guias GR-PR.�
//���������������������������������������������������������������������������������
Static function CalDvBarGR( pNossoNum )	
    local aPeso     := {4,3,2,9,8,7,6,5}
    local nPeso     := 1
    local nSoma     := 0
    local nCalc1    := 0
    local nCalc2    := 0
    local nCalc3    := 0
    local nDV
    local nAux
    local cRes      := ""
    //                                                                  
    for nX := 1 to len(pNossoNum)
    	if nPeso > len(aPeso)
    	   nPeso := 1   
    	endif
    	//
        nSoma += val(substr(pNossoNum, nX, 1)) * aPeso[nPeso]
        nPeso++
    next
    //        
    nCalc1 := int(nSoma / 11)    // 1o calculo
    nCalc2 := nCalc1 * 11         // 3o calculo
    nCalc3 := nSoma - nCalc2      // 4o calculo
    //    
    iif((11 - nCalc3) >= 10, cRes := "0", cRes := alltrim(Str((11 - nCalc3))))
return(cRes)
