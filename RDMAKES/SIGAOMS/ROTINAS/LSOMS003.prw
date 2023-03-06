#include "rwmake.ch"     
#include "protheus.ch" 
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LSOMS003  �Autor  �Jefferson Mittanck  � Data �  25/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chamada para sele��o do portador para amarra��o na SE1     ���
���          � e impressao do Boleto                                       ��
�������������������������������������������������������������������������͹��
���Uso       � LATICINIO SILVESTRE                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LSOMS003( cNum, cSerie , cBancoSC5 , cAgenSC5 , cNumConSC5)

Local cQuery 	 := ""
Private cBanco   := CriaVar( "A6_COD"	  )
Private cAgencia := CriaVar( "A6_AGENCIA" )
Private cNumCon  := CriaVar( "A6_NUMCON"  )

cQuery := " SELECT SE1.E1_NUM,SE1.E1_PREFIXO,SE1.E1_VENCTO,SE1.E1_EMISSAO,SE1.E1_X_FRMPG"
cQuery += " FROM " + RetSQLName( "SE1" ) + " AS SE1 "
cQuery += " WHERE SE1.D_E_L_E_T_<> '*'  AND SE1.E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND SE1.E1_NUM = '" + cNum + "' "
cQuery += " AND SE1.E1_PREFIXO = '" + cSerie + "' "
cQuery += " AND SE1.E1_X_FRMPG = 'BOL'"
                   
TcQuery cQuery New Alias "TMP"
dbSelectArea("TMP")
dbGoTop()       
nqtde := 0

While !EOF() 	
	nqtde++   
	dbskip()
EndDo       
DbGoTop()

If nqtde == 0  
	dbCloseArea("TMP")  	
	Return(.F.)
EndIf    

If nqtde == 1  
	If ( TMP->E1_VENCTO == TMP->E1_EMISSAO) 
		dbCloseArea("TMP")  	
		Return(.F.)
	EndIf
EndIf    

dbCloseArea("TMP")

If !Empty(cBancoSC5)
    
    cBanco	:= cBancoSC5
    cAgencia:= cAgenSC5
    cNumCon := cNumConSC5

	U_LSFINR01(cNum,cSerie,cBanco,cAgencia,cNumCon)
	
Else

	DEFINE�MSDIALOG�oDlg�FROM�15,�5�TO�25,�38�TITLE�"Impress�o de Boleto"�
	
	@ 1.0,2��  Say�"Banco  :"��Of�oDlg�
	@ 1.0,7.5� MSGET�cBanco�F3�"SEE1"� Of�oDlg //Valid�CarregaSa6(@cBanco)�Of�oDlg 
	
	@ 2.0,2��  Say�"Ag�ncia: " Of oDlg�     
	@ 2.0,7.5� MSGET�cAgencia�Of�oDlg when .F.//Valid�CarregaSa6(@cBanco,@cAgencia)�Of�oDlg when .F.
	
	@ 3.0,2��  Say�"Conta  : "�Of��oDlg
	@ 3.0,7.5� MSGET�cNumCon�Of�oDlg when .F.//Valid�CarregaSa6(@cBanco,@cAgencia,@cNumCon,,,.T.)�Of�oDlg when .F.   
	
	IF !Empty(cBanco)
		CarregaSa6(@cBanco,@cAgencia,@cNumCon,,,.T.)
	ENDIF
	
	@.3,1�TO�4.3,15.5�OF�oDlg
	DEFINE�SBUTTON�FROM�060,097.1���TYPE�1�ACTION�(nOpca�:=�1,If(!Empty(cBanco).and.�CarregaSa6(@cBanco,@cAgencia,@cNumCon,,,.T.),oDlg:End(),nOpca:=0))�ENABLE�OF�oDlg
	DEFINE�SBUTTON�FROM�060,067.1���TYPE�2�ACTION�(nOpca�:=�2,oDlg:End()) ENABLE�OF�oDlg
	ACTIVATE�MSDIALOG�oDlg
	


	If nOpca = 1
		Do Case
			Case cBanco == "748" 	// SICREDI
				U_LSFINR01(cNum,cSerie,cBanco,cAgencia,cNumCon) 
			Case cBanco == "341"    // ITAU
				U_XXXXXXXX(cNum,cSerie,cBanco,cAgencia,cNumCon)	
			Case cBanco == "001"    // BANCO DO BRASIL
				U_XXXXXXXX(cNum,cSerie,cBanco,cAgencia,cNumCon)					
			Case cBanco == "237"    // BRADESCO                                	
				U_XXXXXXXX(cNum,cSerie,cBanco,cAgencia,cNumCon)					
			Case cBanco == "422"    // SAFRA
				U_LSFINR02(cNum,cSerie,cBanco,cAgencia,cNumCon)									
		EndCase
	
	Else
	   MsgInfo( "o Boleto n�o ser� gerado!" )
	   
	Endif
	
EndIf

Return( .T. )
