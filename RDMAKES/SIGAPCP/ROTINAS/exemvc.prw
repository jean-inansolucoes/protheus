//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "topconn.ch"
 
//Vari�veis Est�ticas
Static cTitulo := "An�lise Maturacao"
 
/*/{Protheus.doc} DZFIN64
    Cadastro Analise Economica Financeira
    @author DZ
    @since 30/12/2019
    @version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_DZFIN64()
/*/
User Function DZFIN64()
   AxCadastro( "SZ4", cTitulo )
Return Nil
