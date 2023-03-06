/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTVALRPS �Autor  �Lincoln Rossetto    � Data �  23/02/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada respons�vel pela valida��o da s�rie da no-���
���          � ta fiscal.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � MTVALRPS - Faturamento                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTVALRPS()
************************
Local lRet       := .F. 
Local cSerie     := PARAMIXB[1]   
Local aUsrGrupos := UsrRetGrp()
//Local aUserInfo  := {}
Local nX         := 0
Local cGrupo	 := ""

Do Case
	
	Case cSerie == "001"
		cGrupo := "000021"
			
	Case cSerie == "002"
		cGrupo := "000022"
		
	Case cSerie == "003"
		cGrupo := "000023"	
		
	Case cSerie == "004"
		cGrupo := "000024"	
		
	Case cSerie == "005"
		cGrupo := "000025"
	
	Case cSerie == "006"
		cGrupo := "000028"
		
	Case cSerie == "007"
		cGrupo := "000035"		

	Case cSerie == "900"
		cGrupo := "000032"	
EndCase

For nX := 1 To LEN(aUsrGrupos)
	
	If ( aUsrGrupos[ nX ] == cGrupo .Or. aUsrGrupos[ nX ] == "000018" .Or. aUsrGrupos[ nX ] == "000000" )
		lRet       := .T.
	EndIf

Next nX

If FunName() $ "MATA461/MATA460A/MATA460B" .and. cFilAnt == "01LAT01" .and. cSerie == "001"
	lRet       := .F.
EndIf

If !lRet
	U_LSSHWHLP( "Aten��o !", "Usu�rio sem permiss�o para emitir Nota Fiscal com a S�rie: " + cSerie, "Selecione a s�rie correta ou entre em contato com o setor Fiscal!" )
EndIf
/*
PSWOrder( 1 )
PSWSeek( __cUserID, .T. )

aUserInfo := PSWRet( 1 )
*/

Return( lRet )
