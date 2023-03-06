#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPE10MENU �Autor  Alexandre Longhi      � Data �  08/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para bot�o no cad. funcionarios          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Laticinio Silvestre                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GPE10MENU()

aAdd(aRotina, { "Hist. Funcion�rio", "U_LSGPE01", 0, 7, 0, Nil })

aAdd(aRotina, { "Bloq. Vendas", "U_LSGPE03", 0, 7, 0, Nil })
aAdd(aRotina, { "Desbloq. Vendas", "U_LSGPE03a", 0, 7, 0, Nil })
aAdd(aRotina, { "Lim. Cr�d. Padrao", "U_LSATUCLI", 0, 7, 0, Nil })
aAdd(aRotina, { "Alt. Limite Cr�d.", "U_LSLIMCRE", 0, 7, 0, Nil }) 
aAdd(aRotina, { "Cad. Clientes", "U_LSIMPCLI", 0, 7, 0, Nil }) 
aAdd(aRotina, { "Cad. Fornecedores", "U_LTIMPFOR", 0, 7, 0, Nil })


//Alert("Passou pelo GPE10MENU")

Return(Nil)
