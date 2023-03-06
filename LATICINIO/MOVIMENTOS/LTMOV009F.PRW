#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}LTMOV9F
  ==============================================================================
    @description
    Chamada da função para abertura de protocolos

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 20/04/2021

/*/
//============================================================================\
User Function LTMOV9F(  )
    
    Local cUsrQld	:= GETMV("MV_ZL00008",, "")
    Local _cOpc := ''
    Private lExeQlq	:= .F.
    Private _nRotina := 0
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Verifica se o usuário tem permissão para utilizar a funcionalidade Qualidade³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    If __cUserId $ cUsrQld
        lExeQlq := .T.
    EndIf

    If !lExeQlq
        MsgAlert("Usuário sem acesso para abertura de não conformidades!")
        Return
    EndIf
    
   

    If !Empty(ZM1->ZM1_IDPROT)
        MsgAlert("Já existe Protocolo para essa pesagem!")
        Return
    EndIf
    
    If Empty(ZM1->ZM1_CODLIN)
        _cOpc := 'F'
    Else
        _cOpc := 'P'    
    EndIf

    U_LTEV001(_cOpc)  

Return ( Nil )
// FIM da Funcao LTMOV9F
//==============================================================================

//============================================================================\
/*/{Protheus.doc}LTMOV9F
  ==============================================================================
    @description
    Chamada da função para abertura de protocolos

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 20/04/2021

/*/
//============================================================================\
User Function LTMOV9G(  )
    
    Local cUsrQld	:= GETMV("MV_ZL00008",, "")
    Local _cOpc := ''
    Private lExeQlq	:= .F.
    Private _nRotina := 0
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Verifica se o usuário tem permissão para utilizar a funcionalidade Qualidade³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    If __cUserId $ cUsrQld
        lExeQlq := .T.
    EndIf

    If !lExeQlq
        MsgAlert("Usuário sem acesso para abertura de não conformidades!")
        Return
    EndIf
    
   

    If !Empty(ZM1->ZM1_IDPROT)
        MsgAlert("Já existe Protocolo para essa pesagem!")
        Return
    EndIf
    
    If Empty(ZM1->ZM1_CODLIN)
        _cOpc := 'F'
    Else
        _cOpc := 'P'    
    EndIf

    U_LTEV001(_cOpc)  

Return ( Nil )
// FIM da Funcao LTMOV9F
//==============================================================================

