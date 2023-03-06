#INCLUDE "TOPCONN.Ch"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SF2460I  �Autor  � Lincoln Rossetto   � Data �  20/09/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina respons�vel pela replica��o das formas de pagamento ���
���          � para os t�tulos gerados no financeiro.                     ���
�������������������������������������������������������������������������͹��
���Uso       � Laticinio Silvestre                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SF2460I()
***********************
Local aAreaSF2   := SF2->( Getarea() )
Local aAreaSD2   := SD2->( Getarea() )
Local aAreaSE1   := SE1->( Getarea() )

dBSelectArea( "SCV" )
SCV->( dBSetOrder( 1 ) )
SCV->( dBGoTop( ) )
If SCV->( MsSeek( xFilial( "SCV" ) + SC5->C5_NUM ) )
    
	dBSelectArea( "SE1" )
	SE1->( dBSetOrder( 2 ) )
	SE1->( dBGoTop( ) )
	
	If SE1->( dBSeek( xFilial( "SE1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC ) )
		While !SE1->( Eof() ) .And. SE1->E1_FILIAL == xFilial( "SE1" ) .And. SE1->E1_CLIENTE  == SF2->F2_CLIENTE .And. SE1->E1_LOJA  == SF2->F2_LOJA .And. SF2->F2_SERIE == SE1->E1_PREFIXO .And. SE1->E1_NUM == SF2->F2_DOC
			RecLock( "SE1",.F. )
			
			SE1->E1_X_FRMPG := SCV->CV_FORMAPG
			SE1->E1_X_DSFPG := SCV->CV_DESCFOR
			
			SE1->( MsUnLock() )
			SE1->( dBSkip( ) )
		EndDo
	Endif

Endif

RestArea( aAreaSF2 )
RestArea( aAreaSD2 )
RestArea( aAreaSE1 )

Return
