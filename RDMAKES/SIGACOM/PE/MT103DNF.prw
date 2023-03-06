
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103DNF  �Autor  �Rafael Parma       � Data �  27/03/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para valida��o do campo F1_CHVNFE.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �TOTVS                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103DNF()

Local lRet := .T.
Local aDanfe:= PARAMIXB[1]

	If Len(aDanfe) > 0		
		If ALLTRIM(cEspecie) $ "SPED/CTE" .and. CFORMUL == "N"		
			If Empty(aDanfe[13]) .AND. __cChvNFE == ""
				Aviso("Aviso","Imposs�vel recuperar a chave NFE atrav�s do arquivo XML. Favor inserir a chave manualmente. Imposs�vel gravar o documento.",{"OK"})
				lRet := .F.			
			ElseIf !Empty(aDanfe[13]) .AND. LEN(ALLTRIM(aDanfe[13])) != 44
				Aviso("Aviso","A chave informada n�o � v�lida!. Favor inserir a chave correta.",{"OK"})
				lRet := .F.			
			EndIf
		EndIf
	EndIf      


Return (lRet)
