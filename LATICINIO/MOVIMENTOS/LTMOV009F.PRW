#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}LTMOV9F
  ==============================================================================
    @description
    Chamada da fun豫o para abertura de protocolos

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
    
    //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    //쿣erifica se o usu?rio tem permiss?o para utilizar a funcionalidade Qualidade?
    //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    If __cUserId $ cUsrQld
        lExeQlq := .T.
    EndIf

    If !lExeQlq
        MsgAlert("Usu?rio sem acesso para abertura de n?o conformidades!")
        Return
    EndIf
    
   

    If !Empty(ZM1->ZM1_IDPROT)
        MsgAlert("J? existe Protocolo para essa pesagem!")
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
    Chamada da fun豫o para abertura de protocolos

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
    
    //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    //쿣erifica se o usu?rio tem permiss?o para utilizar a funcionalidade Qualidade?
    //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
    If __cUserId $ cUsrQld
        lExeQlq := .T.
    EndIf

    If !lExeQlq
        MsgAlert("Usu?rio sem acesso para abertura de n?o conformidades!")
        Return
    EndIf
    
   

    If !Empty(ZM1->ZM1_IDPROT)
        MsgAlert("J? existe Protocolo para essa pesagem!")
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

