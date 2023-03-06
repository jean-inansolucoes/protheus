#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

//============================================================================\
/*/{Protheus.doc}LTBFIN03
  ==============================================================================
    @description
    Programa responsável pela impressão do contrato de empréstimo em word

    @author Djonata Guizzo <djonata.guizzo@totvs.com.br>
    @version 1.0
    @since 06/10/2020

/*/
//============================================================================\
User Function LTBFIN03(  )
    @ 96,012 TO 250,400 DIALOG _oDlg9 TITLE OemToAnsi("Integracao com MS-Word")
    @ 08,005 TO 048,190
    @ 18,010 SAY OemToAnsi("Esta rotina irá imprimir o Contrato de Empréstimo integrado com Word.")

    @ 56,130 BMPBUTTON TYPE 1 ACTION WordImp()
    @ 56,160 BMPBUTTON TYPE 2 ACTION Close(_oDlg9)

    ACTIVATE DIALOG _oDlg9 CENTERED
Return 




Static Function WordImp()
Local nK
Local _nTotJuros := 0
Local cPathDot		:= "\TOTVS\Contrato_Emprestimo.dotm"
Local cNewPath      := "C:\TOTVS\Contrato_Emprestimo.dotm"
Local _cNewArq      := "C:\TOTVS\Contrato_" 
Private	hWord   

If !ExistDir("C:\TOTVS\")
    MakeDir("C:\TOTVS\")
EndIf

CpyS2T(cPathDot,"C:\TOTVS\", .T.)

_cNewArq += Left(ZAK->ZAK_NOME,At(" ",ZAK->ZAK_NOME,/*nStart*/)-1) + "_"
_cNewArq += ZAK->ZAK_NUM + ".docx"
Close(_oDlg9)

dbSelectArea('SA2')
SA2->(dbSetOrder(1)) 
SA2->(dbGoTop())
SA2->(dbSeek(xFilial('SA2')+ZAK->ZAK_FORN+ZAK->ZAK_LOJA))

//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cNewPath )


dbSelectArea('ZAL')
ZAL->(dbSetOrder(1)) 
ZAL->(dbGoTop())
ZAL->(dbSeek(xFilial('ZAL')+ZAK->ZAK_NUM))

While ZAL->(!Eof()) .And. ZAL->ZAL_FILIAL+ZAL->ZAL_NUM == xFilial('ZAL')+ZAK->ZAK_NUM
    nK := Val(ZAL->ZAL_PARC)
    _nTotJuros += ZAL->ZAL_VLRJUR
    OLE_SetDocumentVar(hWord,"prt_parcela"+AllTrim(Str(nK)),ZAL->ZAL_PARC)
	OLE_SetDocumentVar(hWord,"prt_vencto"+AllTrim(Str(nK)),dToC(ZAL->ZAL_VENCTO))
	OLE_SetDocumentVar(hWord,"prt_valor"+AllTrim(Str(nK)),'R$ '+AllTrim(Transform(ZAL->ZAL_VLPARC,"@E 999,999,999.99")) )
    
    ZAL->(DbSkip())
EndDo


//Montagem das variaveis do cabecalho		
OLE_SetDocumentVar(hWord, 'prt_nome', AllTrim(ZAK->ZAK_NOME))
OLE_SetDocumentVar(hWord, 'prt_rg', AllTrim(SA2->A2_PFISICA))
OLE_SetDocumentVar(hWord, 'prt_cpf', Transform(AllTrim(SA2->A2_CGC),"@R 999.999.999-99"))
OLE_SetDocumentVar(hWord, 'prt_endereco', AllTrim(SA2->A2_END)+', '+AllTrim(SA2->A2_XNRO))
OLE_SetDocumentVar(hWord, 'prt_cidade', AllTrim(SA2->A2_MUN))
OLE_SetDocumentVar(hWord, 'prt_uf', AllTrim(SA2->A2_EST))
OLE_SetDocumentVar(hWord, 'prt_valor', AllTrim(Transform(ZAK->ZAK_VALOR+_nTotJuros,"@E 999,999,999.99")))
OLE_SetDocumentVar(hWord, 'prt_extenso', Extenso(ZAK->ZAK_VALOR+_nTotJuros))
OLE_SetDocumentVar(hWord, 'prt_dtlib', dToC(ZAK->ZAK_DTPGTO))
OLE_SetDocumentVar(hWord, 'prt_dtextenso', DtExtenso(dDataBase, .F., .T., .F.))

OLE_SetDocumentVar(hWord, 'prt_nroitens', cValToChar(ZAK->ZAK_PARC))
/* 
dbSelectArea('ZAL')
ZAL->(dbSetOrder(1)) 
ZAL->(dbGoTop())
ZAL->(dbSeek(xFilial('ZAL')+ZAK->ZAK_NUM))

While ZAL->(!Eof()) .And. ZAL->ZAL_FILIAL+ZAL->ZAL_NUM == xFilial('ZAL')+ZAK->ZAK_NUM
    nK := Val(ZAL->ZAL_PARC)
    OLE_SetDocumentVar(hWord,"prt_parcela"+AllTrim(Str(nK)),ZAL->ZAL_PARC)
	OLE_SetDocumentVar(hWord,"prt_vencto"+AllTrim(Str(nK)),dToC(ZAL->ZAL_VENCTO))
	OLE_SetDocumentVar(hWord,"prt_valor"+AllTrim(Str(nK)),'R$ '+AllTrim(Transform(ZAL->ZAL_VLPARC,"@E 999,999,999.99")) )
    
    ZAL->(DbSkip())
EndDo */

OLE_ExecuteMacro(hWord,"tabitens")

//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
// prt_cod1, prt_cod2 ... prt_cod10


/* OLE_ExecuteMacro(hWord,"tabitens")
OLE_SetDocumentVar(hWord,"prt_parcela","001") */
/* 
OLE_ExecuteMacro(hWord,"tabitens")
OLE_SetDocumentVar(hWord,"prt_parcela","002") */
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_UpdateFields(hWord)
/* If ApMsgNoYes("Imprime o Documento ?")
	Ole_PrintFile(hWord,"ALL",,,1)
EndIf */

OLE_SaveAsFile(hWord,_cNewArq)
		
/* If ApMsgNoYes("Fecha o Word e Corta o Link ?")
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
Endif */	
OLE_CloseFile( hWord )
OLE_CloseLink( hWord )

MsgInfo("O contrato foi gerado no diretório abaixo:" + chr(10)+chr(13) + _cNewArq)
ShellExecute( "open", _cNewArq, "", "", 1 )
Return()

// FIM da Funcao LTBFIN03
//==============================================================================



Static function DtExtenso(dData, lDiaExt, lMesExt, lAnoExt)  
Local cRetDat as Character
Default lDiaExt := .F.
Default lMesExt := .T.
Default lAnoExt := .F.
 
cRetDat := ""
If lDiaExt //convert dia por exenso
    cRetDat += Capital(Extenso(Day(dData), .t.))
else
    cRetDat += cValToChar(Day(dData)) 
Endif
cRetDat += " de " 
 
If lMesExt //convert dia por exenso
    cRetDat += Lower(MesExtenso(dData) )
else
    cRetDat += cValToChar(Month(dData)) 
Endif
cRetDat += " de "
 
If lAnoExt //convert dia por exenso
    cRetDat += Capital(Extenso(Year(dData), .t.))
else
    cRetDat += cValToChar(Year(dData)) 
Endif
return cRetDat 
