//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Analise Matura��o"
 
/*/{Protheus.doc} zMatura
REGISTRO PLANILHA MATURACAO
@author IGOR
@since 23/10/2020
@version 1.0
    @return Nil, Função não tem retorno
    @example
    zMatura()
/*/
 
User Function zMatura()
    Local aArea   := GetArea()
     //DBSelectArea("SZ4")
    AxCadastro( "SZ4", cTitulo ) 
    RestArea(aArea)
Return Nil
 