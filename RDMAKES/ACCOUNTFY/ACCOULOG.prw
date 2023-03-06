#include 'protheus.ch'
/*/{Protheus.doc} ACCOULOG
    Class responsavel pela gravação na tabela SZ4 - Log de integração
    @type  Class
    @author Fernando Oliveira Feres
    @since 26/10/2020
    @version 1.0
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example    
    (examples)
    @see (links_or_references)
/*/

Class ACCOULOG 

    method new() constructor
    method insert() 
    method destroy()

    data cFilLog as string
    data lNewReg as boolean
    data cLogAlias as string

endClass 

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Mï¿½todo construtor
@author Fernando Oliveira Feres
@since   26/10/2020
@version 1.0
@param   cId    , character, Id relacionado ao codigo das tabelas SZ2 e SZ3
@param   lSeekOk  , character, resultado do seek na tabela
@param   cMsgErro , character, mensagem de erro
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cId,lSeekOk,cMsgErro) class ACCOULOG
            
    default lSeekOk := .F.

    self:lNewReg := .T.

return

//-------------------------------------------------------------------
/*/{Protheus.doc} insert
Insert dos campos da tabela ZKY - Filho Log de processamento.
@author Fernando Oliveira Feres
@since   26/10/2020
@version 1.0
@param   aLogSet, array, vetor com nome do campo x valor .
@return  nil, nil   
/*/
//-------------------------------------------------------------------
method insert(aLogSet) class ACCOULOG

local nInd as numeric

self:lNewReg := .T.
dbSelectArea("ZKY")
If reclock("ZKY",self:lNewReg)

    for nInd := 1 to len(aLogSet)
        ZKY->&(aLogSet[nInd][1]) := aLogSet[nInd][2]
    next nInd
        
    ZKY->(msUnlock())
    
Endif

return


//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Limpeza de objetos e fechamento de alias SZ2
@author Fernando Oliveira Feres
@since   26/10/2020
@version 1.0
@return  nil, nil
/*/
//-------------------------------------------------------------------
method destroy() class ACCOULOG
    confirmSX8()
return
