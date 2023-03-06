#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} AdapterEtiqueta
Classe para facilitar a impressão de etiquetas
@type class
@version 1.0
@since 15/02/2023
/*/
CLASS AdapterEtiqueta FROM LongNameClass

    DATA bFuncao
    DATA lStarted
    DATA lOpened
    DATA cEtiqueta
    DATA cImagens
    DATA aImagens
    DATA cImgPreview

    DATA cModelPrt
    DATA cPorta
    DATA nDensidade
    DATA nTamanho
    DATA lSrv
    DATA lCHKStatus

    METHOD New() CONSTRUCTOR
    METHOD Open()
    METHOD Init()
    METHOD Print()
    METHOD Close()
    METHOD Destroy()
    METHOD Preview()
    METHOD SimulaLabelary()
    METHOD GeraQrCode()
    METHOD SavePreview()

ENDCLASS

/*/{Protheus.doc} AdapterEtiqueta::New
Método construtor da classe
@type method
@version 1.0
@return object, Instância da classe AdapterEtiqueta
/*/
METHOD New(bFuncao,cModelPrt,cPorta,nDensidade,nTamanho,lSrv,aImagens) CLASS AdapterEtiqueta

    Default bFuncao   := {|| }
    Default cModelPrt := "ZM400"
    Default cPorta    := "LPT1"
    Default nDensidade:= 8
    Default nTamanho  := 105
    Default lSrv      := .F.
    Default aImagens  := {}

    ::bFuncao   := bFuncao

    ::cModelPrt := cModelPrt
    ::cPorta    := cPorta
    ::nDensidade:= nDensidade
    ::nTamanho  := nTamanho
    ::lSrv      := lSrv

    ::lCHKStatus:= .F.
    ::lStarted  := .F.
    ::lOpened   := .F.
    ::cEtiqueta := ""
    ::cImagens  := ""
    ::aImagens  := aImagens

Return (Self)

/*/{Protheus.doc} AdapterEtiqueta::Open
Executa a inicialização da página e/ou da impressora
@type method
@version 1.0
/*/
METHOD Open() CLASS AdapterEtiqueta

    If !::lOpened
        MSCBPRINTER(::cModelPrt,::cPorta,::nDensidade,::nTamanho,::lSrv)
        MSCBCHKStatus(::lCHKStatus)
        ::lOpened:= .T.
    EndIf

Return ()

/*/{Protheus.doc} AdapterEtiqueta::Begin
Executa a inicialização da página e/ou da impressora
@type method
@version 1.0
/*/
METHOD Init(nxQtde, nVeloc, lSalva, aImagens) CLASS AdapterEtiqueta

    Default nxQtde  := 1
    Default nVeloc  := 4

    If !::lOpened
        ::Open()
    EndIf

    If ! Empty(aImagens)
        ::aImagens:= aImagens
    EndIf

    aEval(::aImagens, {|x| ::cImagens+= MSCBLOADGRF(x) + CRLF })

    MSCBBEGIN(nxQtde, nVeloc, ::nTamanho, lSalva)
    
    ::lStarted  := .T.
    ::cEtiqueta := ""

Return ()

/*/{Protheus.doc} AdapterEtiqueta::Print
Executa função que monta a impressão da etiqueta
@type method
@version 1.0
/*/
METHOD Print(xParam, lEndAuto, aImagens) CLASS AdapterEtiqueta

    Local xRet

    Default lEndAuto:= ! ::lStarted

    If ! ::lStarted
        ::Init(,,,aImagens)
    EndIf

    xRet:= Eval(::bFuncao, xParam, Self)

    If lEndAuto
        ::Close()
    EndIf

Return ( xRet )

/*/{Protheus.doc} AdapterEtiqueta::End
Finaliza a página de etiqueta
@type method
@version 1.0
/*/
METHOD Close(lClosePrint) CLASS AdapterEtiqueta
    Default lClosePrint:= .T.

    ::cEtiqueta:= ::cImagens + MSCBEND()
    ::lStarted:= .F.

    If lClosePrint .And. ::lOpened
        MSCBCLOSEPRINTER()
        ::lOpened:= .F.
    EndIf

Return ( ::cEtiqueta )

/*/{Protheus.doc} AdapterEtiqueta::Preview
Pré-visualizar Etiqueta

@type method
@version 1.0
/*/
METHOD Preview() CLASS AdapterEtiqueta

    //Criando a janela
    DEFINE MSDIALOG oDlgWeb TITLE "Etiqueta" FROM 000, 000  TO 450, 800 COLORS 0, 16777215 PIXEL

    @ 001, 001 BITMAP oBmpWeb SIZE 400, 100 OF oDlgWeb

    oBmpWeb:Load(,::cImgPreview)
    // oBmpWeb:Refresh()

    //Ativando a janela
    ACTIVATE MSDIALOG oDlgWeb CENTERED

Return ()

/*/{Protheus.doc} AdapterEtiqueta::SimulaLabelary
Gera uma imagem PNG ou um PDF para a etiqueta utilizando a API da Labelary
@type method
@version 1.0

@see http://labelary.com/viewer.html
/*/
METHOD SimulaLabelary(cEtiqueta, cArqSalva, cDensidade, cLargura, cAltura, lPdf) CLASS AdapterEtiqueta

    Local lRet   := .F.
    Local cURLAPI:= "http://api.labelary.com"
    Local cBasePt:= "/v1/printers/#1dpmm/labels/#2x#3/"
    Local cPath
    Local oRest
    Local aHeader:= {}
    Local xResult

    Default cEtiqueta := ::cEtiqueta
    Default cDensidade:= "8"
    // padrao � 10x10
    Default cLargura  := "3.9370"
    Default cAltura   := "3.9370"
    //Default cAltura   := "1.5748"
    Default lPdf      := .F.

    If lPdf
        Aadd(aHeader,"Accept: application/pdf")
        Default cArqSalva:= "C:\Temp\Etiqueta.pdf"
    Else
        cBasePt+= "0/"
        Default cArqSalva:= "C:\Temp\Etiqueta.png"
    EndIf

    Aadd(aHeader,"Content-Type: application/x-www-form-urlencoded")

    cPath:= I18N(cBasePt, {cDensidade, cLargura, cAltura})

    oRest:= FwRest():New(cURLAPI)
    oRest:setPath(cPath)
    oRest:SetPostParams(cEtiqueta)

    If oRest:Post(aHeader)
        xResult:= oRest:GetResult()
        MemoWrite(cArqSalva, xResult)
        If File(cArqSalva)
            lRet:= .T.
            ::cImgPreview:= cArqSalva
        EndIf
    EndIf

Return (lRet)

/*/{Protheus.doc} GeraQrCode
Geração do QRCode padrão Zebra
@type function
@version 1.0
@since 28/08/2020
@param nXmm, numeric, Posição eixo x (Horizontal)
@param nYmm, numeric, Posição eixo y (Vertical)
@param nTamanho, numeric, Tamanho da imagem
@param cBarra, character, Código de barra
@return character, Código Qr para adicionar na etiqueta via MSCBWrite
/*/
METHOD GeraQrCode(nXmm, nYmm, cBarra, nTamanho) CLASS AdapterEtiqueta

    Local cQrCode := ''
    Local cPosiX  := cValToChar(nXmm * ::nDensidade)
    Local cPosiY  := cValToChar(nYmm * ::nDensidade)
    Local cTamanho:= cValToChar(nTamanho)

    BeginContent var cQrCode
    ^FO%Exp:cPosiX%,%Exp:cPosiY%
    ^BQN,2,%Exp:cTamanho%
    ^FDQA,%Exp:cBarra%^FS
    EndContent

Return (cQrCode)

/*/{Protheus.doc} SavePreview
Salva a etiqueta em um arquivo Texto
@type function
@version 1.0
@since 28/08/2020
@param cFile, character, Arquivo destino
@return character, Código Qr para adicionar na etiqueta via MSCBWrite
/*/
METHOD SavePreview(cFile) CLASS AdapterEtiqueta

    Default cFile:= 'C:\Temp\Etiqueta.txt'

    MemoWrite(cFile, ::cEtiqueta)

Return (::cEtiqueta)
