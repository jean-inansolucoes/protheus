//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "topconn.ch"
 
//Variáveis Estáticas
Static cTitulo := "Análise Maturacao"
 
/*/{Protheus.doc} DZFIN64
    Cadastro Analise Economica Financeira
    @author DZ
    @since 30/12/2019
    @version 1.0
    @return Nil, Função não tem retorno
    @example
    u_DZFIN64()
/*/
User Function DZFIN64()
   AxCadastro( "SZ4", cTitulo )
Return Nil
