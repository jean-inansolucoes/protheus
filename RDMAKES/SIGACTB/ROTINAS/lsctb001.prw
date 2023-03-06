#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   �LSCTB001 � Autor �Luiz Gamero Prado       � Data �06.01.2012  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Cadastro de Categoria Operacao Contabil                       ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User function LSCTB001()
Private cCadastro := "Cadastro de Categoria Operacao CTB"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","U_LSCTB1VLD",0,5} }

dbSelectArea("SZ2")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZ2")
 
return 

// 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LSCTB1VLD  �Autor  �Luiz Gamero Prado  � Data �  10/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Validacao exclusao categoria operacao para verificar se   ���
���          �   esta amarrada no cadatro de TES                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico LAT SILVESTRE                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function LSCTB1VLD(calias,nreg,nopc)
Local _lret := .T.

DbSelectArea("SF4")
SF4->(DbGoTop())
While SF4->(!EOF())
  IF SZ2->Z2_COD == SF4->F4_CATOPER
  	_lret := .F.
    exit
  Endif
SF4->(DBSkip())
ENDDO
if _lret ==  .F.
	alert("Este cadatro esta amarrado no TES " + SF4->F4_CODIGO )
Else
    axDeleta(calias,nreg,nopc)
endif

return 