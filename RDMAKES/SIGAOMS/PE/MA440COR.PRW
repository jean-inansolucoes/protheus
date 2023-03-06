#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}MA440COR
  ==============================================================================
    @description
    Legenda rotina lib. pedido

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 16/09/2020

/*/
//============================================================================\
User Function MA440COR(  )
    Local aCores := PARAMIXB

    // Aproveito customização da rotina Pedido de Venda;
    aCores := ExecBlock("MA410COR",.F.,.F.,aCores)

Return ( aCores )
// FIM da Funcao MA440COR
//==============================================================================



