#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} ICPDEXC
PE executado após conclusão do processo de exclusão do pedido utilizando monitor da integração ICmais
@type function
@version 1.0
@author Igor
@since 10/11/2020
@return Nil, Nil
/*/
user function ICPDEXC()

    local aArea   := GetArea()
    local cPedido := PARAMIXB[1]

  DBSelectArea( 'ZAI' )
    ZAI->( DBSetOrder( 1 ) )
    if ZAI->( DBSeek( FWxFilial( 'ZAI' ) + cPedido ) )
		// Percorre a ZAI enquanto o numero do pedido for igual
        While !ZAI->( EOF() ) .and. ZAI->ZAI_FILIAL + ZAI->ZAI_NUM == FWxFilial( 'ZAI' ) + cPedido

			RecLock( 'ZAI', .F. )
			ZAI->( DBDelete() )
			ZAI->( MsUnlock() )

			ZAI->( DBSkip() )
		end
    endif

    restArea( aArea )
return (nil)
