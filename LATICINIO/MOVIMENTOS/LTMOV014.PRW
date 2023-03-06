#include "topconn.ch"
#include "protheus.ch"
#include "msgraphi.ch"               
#include "msserial.ch"
#include "eicconst.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTMOV014  ºAutor  Djonata Guizzo       º Data ³  10/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para aprovação de qualidade sem protocolo            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTMOV014()

Local cAliasH	  	:= "ZM1"
Local cUsrQld		:= GETMV("MV_ZL00008",, "")
Local nX
Private cCadastro	:= "Pesagens"
Private aRotina		:= MENUDEF()  
Private aCores		:= {{"ZM1_STATUS == '1'", 'BR_VERDE'	, "Pesagem - Em Aberto"	},;
						{"ZM1_STATUS == '2'", 'BR_VERMELHO'	, "Pesagem - Finalizada"},;
						{"ZM1_STATUS == '9'", 'BR_PRETO'	, "Pesagem - Cancelada"	}}
						
Private aCoresQld	:= {{"ZM1_STATUS == '1' .AND. ZM1_SITQLD != 'F'"						, 'BR_AMARELO'		, "Pesagem - Em Aberto"		},;
						{"ZM1_STATUS != '9' .AND. ZM1_SITQLD == ' '"						, 'BR_MARRON_OCEAN'	, "Pesagem - Finalizada"	},;
						{"ZM1_STATUS == '9'"												, 'BR_CANCEL'		, "Pesagem - Cancelada"		},;
						{"ZM1_STATUS == '2' .AND. ZM1_SITQLD == 'P'"						, 'BR_VERDE'		, "Qualidade - Em Aberto"	},;
						{"ZM1_STATUS $ '1/2' .AND. ZM1_SITQLD == 'E'"						, 'BR_AZUL'	 		, "Qualidade - Em Execução"	},;
						{"ZM1_STATUS $ '1/2' .AND. ZM1_SITQLD == 'F' .AND. ZM1_SITCON == 'P'", 'BR_VIOLETA'		, "Qualidade - Finalizada"	},;
						{"ZM1_STATUS == '2' .AND. ZM1_SITQLD == 'F' .AND. ZM1_SITCON == 'F'", 'BR_VERMELHO'		, "Conciliação - Finalizada"}}						



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Apresentação do browse da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oMBrowse := FWMBrowse():New()
oMBrowse:SetAlias(cAliasH)
oMBrowse:SetDescription(cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona definições de legenda caso o usuário possui permissão do processo de Qualidade³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If __cUserId $ cUsrQld
	For nX := 1 To Len(aCoresQld)	
		oMBrowse:AddLegend(aCoresQld[nX][1], aCoresQld[nX][2], aCoresQld[nX][3])
	Next nX	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Atualiza definições de legenda quando o usuário não possui permissão para o processo de Qualidade³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	For nX := 1 To Len(aCores)
		oMBrowse:AddLegend(aCores[nX][1], aCores[nX][2], aCores[nX][3])
	Next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Adiciona definições de visões³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oMBrowse:SetAttach(.T.)
oMBrowse:SetOpenChart(.F.)
oTableAtt := LT014VIEW()
oMBrowse:SetViewsDefault(oTableAtt:aViews)
oMBrowse:SetChartsDefault(oTableAtt:aCharts) 
oMBrowse:Activate()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Fecha a tabela manipulada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If Select(cAliasH) > 0
	(cAliasH)->(dBCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Remove vinculo de funções com algumas teclas especificas para com a rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ   
SET KEY VK_F12 TO

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LT014VIEW  ºAutor  ³Marcelo Joner       º Data ³ 12/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela definição de visões e gráficos no   º±±
±±º          ³browse da rotina de pesagens.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LT014VIEW()

Local oTableAtt	:= FWTableAtt():New()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Pesagem - Em Aberto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oPesAbe := FWDSView():New()
oPesAbe:SetID("LT9V01") 
oPesAbe:SetName("Em Aberto")
oPesAbe:SetPublic(.T.)
oPesAbe:SetCollumns(U_GLCPOBRW("ZM1"))
oPesAbe:SetOrder(1)
oPesAbe:AddFilter("Pesagens - Em Aberto", "ZM1_STATUS == '1'")
oTableAtt:AddView(oPesAbe)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Pesagem - Finalizada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oPesFin := FWDSView():New()
oPesFin:SetID("LT9V02") 
oPesFin:SetName("Finalizadas")
oPesFin:SetPublic(.T.)
oPesFin:SetCollumns(U_GLCPOBRW("ZM1"))
oPesFin:SetOrder(1)
oPesFin:AddFilter("Pesagens - Finalizadas", "ZM1_STATUS == '2'")
oTableAtt:AddView(oPesFin)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Pesagem - Cancelada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oPesCan := FWDSView():New()
oPesCan:SetID("LT9V03") 
oPesCan:SetName("Canceladas")
oPesCan:SetPublic(.T.)
oPesCan:SetCollumns(U_GLCPOBRW("ZM1"))
oPesCan:SetOrder(1)
oPesCan:AddFilter("Pesagens - Canceladas", "ZM1_STATUS == '9'")
oTableAtt:AddView(oPesCan)

oTableAtt:SetAlias("ZM1")

Return oTableAtt





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MENUDEF   ºAutor  ³Marcelo Joner       º Data ³  10/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definição das sub-rotinas da rotina principal               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laticinio                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MENUDEF()
                        
Local aRotina	:= {{"&Aprova sem Abert. Protocolo"		, "U_LTMOV14A"	, 0 , 4}}
                   
Return aRotina


// Função que trata os dados para aprovação de qualidade onde deveria ser gerado protocolo mas opte por não abrir
// A função irá fazer backup dos dados das tabelas ZM4, ZM5, ZM6 e ZM7, e irá alterar os conteúdos para que
// fiquem dentro da faixa de aprovação das respectivas características
User Function LTMOV14A()
    Local _aTabelas := {}
    Local _aCampos  := {}
    Local _lExec    := .F.
    Local _lAltera  := .F.
    Local _cTbTo    := ''
    Local _cTbFrom  := ''
    Local _nPosTab  := 0
    Local _nNewVal  := 0
    Local _nNewDec  := 0

    If !Empty(ZM1->ZM1_IDPROT )
        MsgAlert("Já foi aberto protocolo para essa pesagem. Para prosseguir com essa rotina, será necessário excluir o protocolo na rotina específica de protocolos!")
        Return
    EndIf

    DBSelectArea('ZMA')
    DBSelectArea('ZMB')
    DBSelectArea('ZMC')
    DBSelectArea('ZMD')

    // Tabela DE / Tabela PARA
    aAdd(_aTabelas,{'ZM4','ZMA'})
    aAdd(_aTabelas,{'ZM5','ZMB'})
    aAdd(_aTabelas,{'ZM6','ZMC'})
    aAdd(_aTabelas,{'ZM7','ZMD'})


    dbSelectArea('ZM4')
    ZM4->(dbSetOrder(1)) 
    ZM4->(dbGoTop())
    If ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
        While ZM4->(!Eof()) .And. ZM4->ZM4_FILIAL+ZM4->ZM4_NUM == xFilial('ZM4')+ZM1->ZM1_NUM
            // Se encontrar algum item que tenha protocolo, permite a execução
            If ZM4->ZM4_STATUS == 'P'
                _lExec := .T.
            EndIf

            ZM4->(DbSkip())
        EndDo
    EndIf

    If !_lExec
        MsgAlert("Atenção! Não há análises que exijam Protocolo!")
        Return
    EndIf

    If !MsgYesNo("Confirma aprovação sem abertura do protocolo? Não será possível estornar essa operação posteriormente!")
        Return
    EndIf

    RecLock("ZM1",.F.)
        ZM1->ZM1_SITQLD := 'F'
        ZM1->ZM1_STPROT := ''
    ZM1->(MsUnlock())

    // Inicia o backup das tabelas
    // Faz o backup de todos os registros, mesmo os aprovados ou com descarte, mas só ajusta os valores originais dos itens cujo tanque fique com status Protocolo
    dbSelectArea('ZM4')
    ZM4->(dbSetOrder(1)) 
    ZM4->(dbGoTop())
    If ZM4->(dbSeek(xFilial('ZM4')+ZM1->ZM1_NUM))
        While ZM4->(!Eof()) .And. ZM4->ZM4_FILIAL+ZM4->ZM4_NUM == xFilial('ZM4')+ZM1->ZM1_NUM
            // Se status protocolo, permite a alteração
            _lAltera := .F.
            If ZM4->ZM4_STATUS == 'P'
                _lAltera := .T.
            EndIf

            // Início Backup e ajustes da ZM4
            _cTbFrom    := 'ZM4'
            _nPosTab    := aScan(_aTabelas,{|x| x[1] == _cTbFrom})
            _cTbTo      := _aTabelas[_nPosTab,2]
            

            dbSelectArea('SX3')
            SX3->(dbSetOrder(1)) 
            SX3->(dbGoTop())
            If SX3->(dbSeek(_cTbTo))
                RecLock(_cTbTo,.T.)    
                    While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == _cTbTo
                            (_cTbTo)->&(SX3->X3_CAMPO) := (_cTbFrom)->&(_cTbFrom+Right(SX3->X3_CAMPO,7)) 
                        SX3->(DbSkip())
                    EndDo
                (_cTbTo)->(MsUnlock())
                    
            EndIf

            If _lAltera
                RecLock('ZM4',.F.)
                    ZM4->ZM4_STATUS := 'A' 
                ZM4->(MsUnlock())
            EndIf

            // Fim Backup e ajustes da ZM4


            // Início Backup e ajustes da ZM5
            dbSelectArea('ZM5')
            ZM5->(dbSetOrder(1)) 
            ZM5->(dbGoTop())
            If ZM5->(dbSeek(xFilial('ZM5')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE))
                While ZM5->(!Eof()) .And. ZM5->(ZM5_FILIAL+ZM5_NUM+ZM5_TANQUE) == xFilial('ZM5')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE
                    _cTbFrom    := 'ZM5'
                    _nPosTab    := aScan(_aTabelas,{|x| x[1] == _cTbFrom})
                    _cTbTo      := _aTabelas[_nPosTab,2]
                    

                    dbSelectArea('SX3')
                    SX3->(dbSetOrder(1)) 
                    SX3->(dbGoTop())
                    If SX3->(dbSeek(_cTbTo))
                        RecLock(_cTbTo,.T.)    
                            While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == _cTbTo
                                    (_cTbTo)->&(SX3->X3_CAMPO) := (_cTbFrom)->&(_cTbFrom+Right(SX3->X3_CAMPO,7)) 
                                SX3->(DbSkip())
                            EndDo
                        (_cTbTo)->(MsUnlock())
                            
                    EndIf

                    // Se permite alteração e o status for protocolo, irá alterar o valor da medição para um valor dentro da faixa em que fique aprovado
                    If _lAltera .AND. ZM5->ZM5_STATUS == 'P'
                        _nNewVal := 0
                        dbSelectArea('ZA2')
                        ZA2->(dbSetOrder(1)) 
                        ZA2->(dbGoTop())
                        If ZA2->(dbSeek(xFilial('ZA2')+ZM1->ZM1_PROD+ZM4->ZM4_REVISA+ZM5->ZM5_CARACT))
                            While ZA2->(!Eof()) .And. ZA2->(ZA2_FILIAL+ZA2_PROD+ZA2_REVISA+ZA2_CARACT) == xFilial('ZA2')+ZM1->ZM1_PROD+ZM4->ZM4_REVISA+ZM5->ZM5_CARACT
                                If ZA2->ZA2_RESULT == 'A'
                                    If ZA2->ZA2_CARACT == '000014'
                                        _nNewVal := ZA2->ZA2_FXDE + Randomize(0,20) / 100
                                    Else
                                        _nNewVal := Randomize(Max(ZA2->ZA2_FXDE, ZA2->ZA2_FXATE - 32767 ),ZA2->ZA2_FXATE)
                                        _nNewDec := Randomize(0,9) / 10
                                        _nNewVal += _nNewDec
                                    EndIf
                                    Exit
                                EndIf
                                
                                ZA2->(DbSkip())
                            EndDo
                        
                            RecLock('ZM5',.F.)
                                ZM5->ZM5_STATUS := 'A'
                                // 20210518 - Djonata - Não altera o valor do Prix em nenhuma hipótese,
                                // pois essa análise é base para o cálculo do valor a pagar aos produtores
                                If !ZM5->ZM5_CARACT $ GetMv("MX_BRIX")
                                    ZM5->ZM5_VALOR := _nNewVal 
                                Endif
                            ZM5->(MsUnlock())
                        
                        EndIf

                    EndIf
                    
                    ZM5->(DbSkip())
                EndDo
            EndIf
            // Fim Backup e ajustes da ZM5


            // Início Backup e ajustes da ZM6
            If _lAltera
                dbSelectArea('ZM6')
                ZM6->(dbSetOrder(1)) 
                ZM6->(dbGoTop())
                If ZM6->(dbSeek(xFilial('ZM6')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE))
                    While ZM6->(!Eof()) .And. ZM6->(ZM6_FILIAL+ZM6_NUM+ZM6_TANQUE) == xFilial('ZM6')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE
                        _cTbFrom    := 'ZM6'
                        _nPosTab    := aScan(_aTabelas,{|x| x[1] == _cTbFrom})
                        _cTbTo      := _aTabelas[_nPosTab,2]
                        

                        dbSelectArea('SX3')
                        SX3->(dbSetOrder(1)) 
                        SX3->(dbGoTop())
                        If SX3->(dbSeek(_cTbTo))
                            RecLock(_cTbTo,.T.)    
                                While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == _cTbTo
                                        (_cTbTo)->&(SX3->X3_CAMPO) := (_cTbFrom)->&(_cTbFrom+Right(SX3->X3_CAMPO,7)) 
                                    SX3->(DbSkip())
                                EndDo
                            (_cTbTo)->(MsUnlock())
                                
                        EndIf

                        RecLock('ZM6',.F.)
                            ZM6->(dbDelete())
                        ZM6->(MsUnlock())
                    
                        
                        ZM6->(DbSkip())
                    EndDo
                EndIf
            EndIf
            // Fim Backup e ajustes da ZM6

            // Início Backup e ajustes da ZM7
            If _lAltera
                dbSelectArea('ZM7')
                ZM7->(dbSetOrder(1)) 
                ZM7->(dbGoTop())
                If ZM7->(dbSeek(xFilial('ZM7')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE))
                    While ZM7->(!Eof()) .And. ZM7->(ZM7_FILIAL+ZM7_NUM+ZM7_TANQUE) == xFilial('ZM7')+ZM4->ZM4_NUM+ZM4->ZM4_TANQUE
                        _cTbFrom    := 'ZM7'
                        _nPosTab    := aScan(_aTabelas,{|x| x[1] == _cTbFrom})
                        _cTbTo      := _aTabelas[_nPosTab,2]
                        

                        dbSelectArea('SX3')
                        SX3->(dbSetOrder(1)) 
                        SX3->(dbGoTop())
                        If SX3->(dbSeek(_cTbTo))
                            RecLock(_cTbTo,.T.)    
                                While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == _cTbTo
                                        (_cTbTo)->&(SX3->X3_CAMPO) := (_cTbFrom)->&(_cTbFrom+Right(SX3->X3_CAMPO,7)) 
                                    SX3->(DbSkip())
                                EndDo
                            (_cTbTo)->(MsUnlock())
                                
                        EndIf

                        RecLock('ZM7',.F.)
                            ZM7->(dbDelete())
                        ZM7->(MsUnlock())
                    
                        
                        ZM7->(DbSkip())
                    EndDo
                EndIf
            EndIf
            // Fim Backup e ajustes da ZM7


            


            ZM4->(DbSkip())
        EndDo
    EndIf

Return
