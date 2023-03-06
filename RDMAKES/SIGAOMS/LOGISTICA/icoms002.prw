//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas



User Function GETCOMIS( cVend, cProd)
    Local aArea     := GetArea()
    Local cVendedor := cVend
    Local cProduto  := cProd
    Local cGrupo    :=""
    Local nComiss   := 0.0
    ConOut( 'GETCOMIS - Buscando regra compativel com vendedor ['+ cVend +'] e produto ['+ cProd +']...' )
    cGrupo := POSICIONE('SB1',1,XFILIAL('SB1')+cProduto,'B1_GRUPO')
    
    nComiss := POSICIONE('Z07',1,XFILIAL('Z07')+cVendedor+cGrupo,'Z07->Z07_COMISS')
    if(nComiss == 0 )
        nComiss := POSICIONE('Z07',1,XFILIAL('Z07')+cVendedor+'*','Z07->Z07_COMISS')
    EndIf

    ConOut( 'GETCOMIS - Final do ponto de entrada que retorna indice de comissao por produto [ '+ AllTrim( Transform( nComiss, "@E 99.99") ) +'% ]' )
    RestArea(aArea)
Return nComiss

