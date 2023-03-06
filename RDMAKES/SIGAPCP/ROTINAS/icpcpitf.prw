#include "protheus.ch"
#include "parmtype.ch"
#include "rwmake.ch"
#include "topconn.ch"


/*
Função		ITF14()
Autor		ERPC
Descrição	Calcula Digito verificador para ITF14 
Parâmetro	String com 14 digitos 
Retorno		String contendo dígito verificador
*/
User function ITF14(cProduto)

Local cCodigo :=""
Local cCod    :=""
Local nNumero := 0
Local cITF14 :=""
  //CALCULO QUE SERA DEFINIDO PEARA CAIXA 
  //cCodigo := POSICIONE("SB1",1,XFILIAL("SB1")+cProduto,"SB1->B1_X_ITF14") 

  dbSelectArea("SB1")
	SB1->( dbSetOrder( 1 ) )
	SB1->( dbGoTop( ) )
	if dbSeek( xFilial("SB1") + cProduto )
		cCodigo := SB1->B1_X_ITF14
    
        if EMPTY(cCodigo)
        //CASO CODIGO SEJA BRANCO 
        cITF14 := "0"
      else
        nNumero := val(cCodigo) + 1
        cCod := StrZero( nNumero , 8 )
        cITF14 := ALLTRIM(ALLTRIM(SB1->B1_COD) + "" + cCod )
        RecLock("SB1",.F.)
        SB1->B1_X_ITF14 := cCod
        SB1->(MsUnlock())
      endIF
	endif

    



Return cITF14
