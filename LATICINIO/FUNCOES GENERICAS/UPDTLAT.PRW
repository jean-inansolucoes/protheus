#include "rwmake.ch"       
#include "topconn.ch" 
#include "protheus.CH"
#include "apwizard.ch"                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDTLAT    ºAutor  ³Jean P. Rossetto 		Data ³  20/12/10   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de aplicação do módulo de gestão de laticinios.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
*------------------------------------*
User Function UPDTLAT()
*------------------------------------*

Local oNo 			:= LoadBitmap(GetResources(), "LBNO"  )
Local oOk 			:= LoadBitmap(GetResources(), "LBTIK" )
//Local cArqEmp 		:= "SIGAMAT.EMP"
//Local nModulo		:= 97
//Local __cInterNet 	:= Nil
Local hEnter 		:= CHR(10) + CHR(13)
Local lChkTWiz 		:= .F. 
Local lChkIWiz 		:= .F.
//Local lEmpenho		:= .F.
//Local lAtuMnu		:= .F.
Local oWizard
//Local nPanel
Local oLbxWiz
Local oChkTWiz
Local oChkIWiz 

Private lBackup		:= .F. 
Private aWiz 		:= {{.F.,"",""}}
Private aArqUpd		:= {}
          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia declaração do Wizard e seus componentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE WIZARD oWizard TITLE "Wizard" HEADER "Aplicação Módulo - Gestão de Laticinios" MESSAGE " ";
	TEXT "Este assiste estará lhe ajudando nos procedimentos necessários para a aplicação do módulo de Gestão de Laticinios no seu ambiente de trabalho." PANEL;
	NEXT {|| .T.} FINISH {|| .T.}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta itens do segundo PANEL do Wizard³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CREATE PANEL oWizard HEADER "Empresas Utilizadas" MESSAGE "Selecione abaixo as empresas em que deseja aplicar o módulo de Gestão de Laticinios" PANEL;
	BACK {|| oWizard:nPanel := 2, .T.} NEXT {|| If(Ascan(aWiz,{|x| x[1] == .T.}) == 0,(U_LTALL001("ATENCAO", "Nenhuma empresa foi selecionada", "Para continuar deverá estar selecionando as empresas para aplicação do módulo de Gestão de Laticinios"),.F.),.T.)} EXEC {||lChkTWiz:=.F., .T.}
	
		@ 010, 010 TO 125,280 OF oWizard:oMPanel[2] PIXEL                                                  
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama função responsavel pela carga das empresas existentes            ³
		//³no ambiente para que o usuario possa selecionar em quais deseja aplicar³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aWiz := UPDLOADEMP()                            

		@ 018, 020 LISTBOX oLbxWiz FIELDS HEADER "","Codigo","Descrição"  SIZE 171, 88 ON DBLCLICK (aWiz[oLbxWiz:nAt,1] := !aWiz[oLbxWiz:nAt,1],If(!aWiz[oLbxWiz:nAt,1],lChkTWiz := .F., ),oLbxWiz:Refresh(.f.),ApSxVerChk(@lChkTWiz,@aWiz,@oLbxWiz,@oChkTWiz)) OF oWizard:oMPanel[2] PIXEL 	
		oLbxWiz:SetArray(aWiz)
		oLbxWiz:bLine := {|| {If(aWiz[oLbxWiz:nAt,1],oOK,oNO),aWiz[oLbxWiz:nAt,2], aWiz[oLbxWiz:nAt,3]}}
	    oLbxWiz:bRClicked := { || AEVAL(aWiz,{|x|x[1]:=!x[1]}),oLbxWiz:Refresh(.F.) }
    
		@ 040, oLbxWiz:nWidth/2 + 40 CHECKBOX oChkTWiz VAR lChkTWiz PROMPT "Marcar Todos" SIZE 62, 10 OF oWizard:oMPanel[2] PIXEL
		oChkTWiz:blClicked := {|| AEval( aWiz,{|x,y| x[1] := lChkTWiz , If(lChkTWiz, (lChkIWiz := .F.,oChkIWiz:Refresh()), )})}    
	
		@ 070, oLbxWiz:nWidth/2 + 40 CHECKBOX oChkIWiz VAR lChkIWiz PROMPT "Inverter Marca" SIZE 62, 10 OF oWizard:oMPanel[2] PIXEL
		oChkIWiz:blClicked := {|| AEval( aWiz,{|x,y| x[1] := !x[1]}), lChkTWiz := (Ascan(aWiz,{|x|!x[1]}) == 0), oChkTWiz:Refresh()}    


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄA¿
		//³Seta itens do terceiro PANEL do Wizard³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAÙ
		CREATE PANEL oWizard HEADER "Executando" MESSAGE "Ao confirmar o procedimento o UPDATE será iniciado nas empresas selecionadas" PANEL;
		BACK {|| oWizard:nPanel := 3, .T.} NEXT {|| .T.} EXEC {|| .T.}
	                                                                                                        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta mensagem reforçando os procedimentos que o usuario deve³
		//³adotar antes de confirmar a execução do update de atualização³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTexto := "Atenção," + hEnter 
		cTexto += hEnter
		cTexto += "Antes de confirmar a execução dos procedimentos para " 
		cTexto += "a aplicação do módulo de Gestão de Laticinios, certifique-se "
		cTexto += "de que foram realizados os seguintes procedimentos:          "
		cTexto += hEnter 
		cTexto += hEnter
		cTexto += "    - Backup do banco de dados do ambiente"
		cTexto += hEnter
		cTexto += hEnter                                                            
		cTexto += "    - Backup dos arquivos do dicionário de dados (SX)"
		cTexto += hEnter
		cTexto += hEnter
		cTexto += "    - Backup do arquivo de configuração de empresas (SIGAMAT.EMP)"
		
		oMGet1     := TMultiGet():New( 018,020,{|u|if(Pcount()>0,cTexto:=u,cTexto)},oWizard:oMPanel[3],250,088,,,CLR_BLACK,CLR_GRAY,,.T.,"",,,.F.,.F.,.T.,,,.F.,,)                                                 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Seta itens do quarto PANEL do Wizard³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		CREATE PANEL oWizard HEADER "Finalizando" MESSAGE "O UPDATE esta sendo executado nas empresas selecionadas..." PANEL;
		BACK {|| oWizard:nPanel := 3, .T.}  FINISH {|| .T. } EXEC {|| .T., U_LTLOADUPD(), cTexto := "Processo de Atualização Realizado com Sucesso!!!"}
	                                             
 		oMGet2     := TMultiGet():New( 018,020,{|u|if(Pcount()>0,cTexto:=u,cTexto)},oWizard:oMPanel[4],250,088,,,CLR_BLACK,CLR_GRAY,,.T.,"",,,.F.,.F.,.T.,,,.F.,,)                                                                                                          
		oWizard:oDlg:lEscClose := .F.
		
		
ACTIVATE WIZARD oWizard CENTERED 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza declaração do Wizard³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                 
Return Nil




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ApSxVerChk  ºAutor ³Jean Pierre Rossetto º Data ³  20/12/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de verificação das empresas selecionadas para aplica º±±
±±º          ³ção da atualização                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ApSxVerChk(lChkTudo,aAlias,oLbx,oChk)
Local nI               
Local nCount := 0   
Local nSize

nSize := len(aAlias)

For nI := 1 to nSize
	If !aAlias[nI,1] 
		nCount++
	EndIf
Next                                             

If nCount > 0
	lChkTudo := .F.
Else
	lChkTudo := .T.
EndIf
oLbx:Refresh()
oChk:Refresh()                                      

Return lChkTudo 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Jean Pierre Rossetto  ³ Data ³20/12/10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MyOpenSM0Ex()
                  
Local lOpen := .F. 
Local nLoop := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza 20 testes de exclusividade no ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) 
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄi
//³Caso após os testes não tenha obtido acesso exclusivo,³
//³alerta o usuario através de mensagem                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄi
If !lOpen
	U_LTALL001("ATENCAO", "Não foi possivel obter acesso exclusivo ao ambiente", "Não é possivel efetuar os procedimentos sem acesso exclusivo ao ambiente")
EndIf                                 

Return lOpen                       





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDLOADEMP  ºAutor  ³Jean P. Rossetto    º Data ³  20/12/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel por efetuar analise/carga das empresas   º±±
±±º          ³disponiveis no ambiente para aplicação do update            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDLOADEMP()

Local aEmps	:= {}             
Local cEmp  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica exclusividade no acesso ao ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MyOpenSm0Ex()
	dbSelectArea("SM0")
	dbGotop()		
	While SM0->(!EOF())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona ao array as empresas não deletadas do sigamat.emp³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If (cEmp <> SM0->M0_CODIGO .AND. !SM0->(DELETED()))
			aAdd( aEmps, {.F., SM0->M0_CODIGO, UPPER(SM0->M0_NOME), SM0->(RECNO())})
			cEmp := SM0->M0_CODIGO
		ENDIF
		SM0->( dBSkip( ) )
	End
Endif                                     
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna o array com as empresas disponiveis no ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Return aEmps




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
0±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LTProc    ³ Autor ³Jean P. Rossetto       ³ Data ³20/12/10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao de processamento da gravacao das alterações no      ³±±
±±           ³ dicionario de dados do ambiente selecionado aplicando o    ³±±
±±³          ³ Módulo de TOTVS LATICINIO.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TOTVS LATICINIO.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTProc(lEnd)

Local lRet		:= .T.
Local lOpen     := .F.
Local cTexto    := ''
Local cFile     := ""
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
//Local cCodigo   := "DM"                          
Local hEnter	:= CHR(13) + CHR(10)
//Local nRecno    := 0
Local nX		:= 0
Local nI        := 0
Local nEmpApl	:= 0
Local aRecnoSM0 := {}    
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia procedimentos para garantir o acesso exclusivo ao ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbSetOrder(1)
dbGotop()
cEmp := ""
While !Eof()
	If (cEmp <> SM0->M0_CODIGO .AND. !SM0->(DELETED()))
		Aadd(aRecnoSM0,SM0->(RECNO()))
		cEmp := SM0->M0_CODIGO
	EndIf
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Checa exclusividade do ambiente para cada empresa/filial³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
For nI := 1 To Len(aRecnoSM0)
	SM0->(dbGoto(aRecnoSM0[nI]))
	RpcSetType(2)
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	RpcClearEnv()
	If !( lOpen := MyOpenSm0Ex() )
		Exit
	EndIf
Next nI


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa procedimentos para obter o numero total de ³
//³empresas nas quais o modulo será aplicado          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 
For nI := 1 To Len(aWiz)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr
	//³Caso o item do array posicionado seja .T. significa que a empresa³
	//³foi selecionada para aplicação então incremente nEmpApl          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr
	If aWiz[nI][1]
		nEmpApl++
	EndIf
Next nI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seta regua de processamento com a quantidade de empresas obtidas  ³
//³anteriormente as quais será aplicado o modulo de TOTVS LATICINIO. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_oProcess:SetRegua2(nEmpApl)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se esta em modo exclusivo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOpen              
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia laço para todas as empresas existentes no ambiente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 To Len(aWiz) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP
		//³Caso a empresa posicionada tenha sido selecionada para aplicação    ³
		//³dos procedimentos, executa os mesmos, caso contrario passa a proxima³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP
		If aWiz[nI][1]
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Prepara o ambiente (SXs) para a empresa posionada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			SM0->(dbGoto(aWiz[nI][4]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inicia carga da variavel referente ao controle de log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTexto += Replicate("-",128) + hEnter
			cTexto += "EMPRESA : " + SM0->M0_CODIGO + SM0->M0_NOME + hEnter	
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa barra de status referente a empresa³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_oProcess:IncRegua2("Atualizando Empresa " + SM0->M0_CODIGO + " - " + SM0->M0_CODFIL)
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização do Dicionario de Indices (SIX)³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			cTexto += LTAtuSIX()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização do Dicionario de Tabelas (SX2)³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			cTexto += LTAtuSX2() 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização do Dicionario de Campos (SX3)³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			cTexto += LTAtuSX3()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização de Tabelas Genéricas (SX5)³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			cTexto += LTAtuSX5()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização do Dicionario de Parametros (SX6)³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   	cTexto += LTAtuSX6()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização do Dicionario de Gatilhos (SX7)³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   	cTexto += LTAtuSX7()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização do Dicionario de Pastas (SXA)³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			cTexto += LTAtuSXA()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa Função de Atualização do Dicionario de Consultas Padrões (SXB)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   	cTexto += LTAtuSXB()
			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa procedimentos de atualização no banco de dados das tabelas envolvidas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Caso ocorra algum erro emite mensagem ao usuario³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If __GetX31Error()
					Alert(__GetX31Trace())
					Alert("Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.")
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
			Next nX
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Elimina preparação do ambiente e chega exclusividade ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
			EndIf
		EndIf
		
	Next nI
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Finalizando os procedimentos de atualização em todas as empresas³
	//³selecionadas, apresenta log do processo ao usuario              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lOpen
		cTexto := "LOG DA ATUALIZAÇÃO" + hEnter + cTexto
		__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
		DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
		DEFINE MSDIALOG oDlg TITLE "ATUALIZAÇÃO CONCLUIDA COM SUCESSO." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
		ACTIVATE MSDIALOG oDlg CENTER
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Finaliza atualização do ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Return lRet
                    



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LTAtuSIX      Autor ³Jean P. Rossetto       ³ Data ³20/12/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao de processamento do arquivo de indices SIX	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³TOTVS LATICINIO.                              			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSIX()                                                

Local cTexto	:= ""          
Local hEnter    := chr(13)+chr(10)
Local lAtualiza	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX2LAT que possui todas as tabelas do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
If Select("SIXLAT") > 0
	SIXLAT->(dbCloseArea())
EndIf
IF FILE("\UPDTLAT\SIXLAT.DTC")
	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SIXLAT.DTC", "SIXLAT", .F., .F.)       
	dbSelectArea("SIXLAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação a tabela SX2 da empresa logada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SIX")
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH
	//³Seta tamanho da regua de processamento com base no numero   ³
	//³de itens a serem aplicados existentes nas tabelas auxiliares³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH
	_oProcess:SetRegua1(nProcessa)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia laço de verificação + adição dos indices do Gestao de Laticinios³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SIXLAT->(!EOF())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona a tabela do Gestao de Laticinios somente se a mesma ainda não existir³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !SIX->(dbSeek(SIXLAT->INDICE + SIXLAT->ORDEM))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa verificações de geração de Log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAtualiza 
				cTexto += hEnter
				cTexto += "     ADICIONADO OS INDICES: " 
				cTexto += hEnter
				cTexto += hEnter
				lAtualiza := .T.    
				If lBackup
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Executa procedimentos de backup do SX que esta sendo manipulado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MAKEDIR("\UPDTLAT\BACKUP_SX\") 
					MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
					_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SIX" + cEmpAnt + "0.DTC"
					Copy to &_cArqDest VIA "CTREECDX"   
				EndIf               
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Efetua atualização do item³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RECLOCK("SIX", .T.)
			    SIX->INDICE		:= SIXLAT->INDICE
			    SIX->ORDEM		:= SIXLAT->ORDEM
			    SIX->CHAVE		:= SIXLAT->CHAVE
			    SIX->DESCRICAO	:= SIXLAT->DESCRICAO
			    SIX->DESCSPA	:= SIXLAT->DESCSPA
			    SIX->DESCENG	:= SIXLAT->DESCENG
			    SIX->PROPRI		:= SIXLAT->PROPRI
			    SIX->F3			:= SIXLAT->F3
			    SIX->NICKNAME	:= SIXLAT->NICKNAME
			    SIX->SHOWPESQ	:= SIXLAT->SHOWPESQ
			SIX->(MSUNLOCK())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona a chave do indice adicionado ao SIX a variavel do arquivo de LOG ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTexto += "     " + SIXLAT->CHAVE 
			cTexto += hEnter
		EndIf    
		SIXLAT->(dbSkip())   
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SIX³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Dicionário de Indices (SIX)")
	End 
                
ELSE
	cTexto += "Erro abrir arquivo \UPDTLAT\SIXLAT.DTC"
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SIXLAT.DTC")
ENDIF
SLEEP(5000)
cTexto += hEnter

Return cTexto





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LTAtuSX2      Autor ³Jean P. Rossetto       ³ Data ³20/12/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao de processamento da SX2                 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³TOTVS LATICINIO.                          				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSX2()                                                

Local lAtualiza	:= .F.
Local cTexto 	:= ""
Local hEnter    := chr(13)+chr(10)
Local cPath     


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX2LAT que possui todas as tabelas do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SX2LAT") > 0
	SX2LAT->(dbCloseArea())
EndIf

IF FILE("\UPDTLAT\SX2LAT.DTC")                

	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SX2LAT.DTC", "SX2LAT", .F., .F.)       
	dbSelectArea("SX2LAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação a tabela SX2 da empresa logada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SX2")
	dbSetOrder(1)
	cPath	:= SX2->X2_PATH
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia laço de verificação + adição das tabelas do Gestao de Laticinios³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SX2LAT->(!EOF())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona a tabela do Gestao de Laticinios somente se a mesma ainda não existir³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !SX2->(dbSeek(SX2LAT->X2_CHAVE))
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica geração de Log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAtualiza  
				cTexto += hEnter
				cTexto += "     ADICIONADO AS TABELAS: "  
				cTexto += hEnter
				cTexto += hEnter
				lAtualiza := .T.        
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Executa procedimentos de backup do SX que esta sendo manipulado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lBackup
					MAKEDIR("\UPDTLAT\BACKUP_SX\") 
					MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
					_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SX2" + cEmpAnt + "0.DTC"
					Copy to &_cArqDest VIA "CTREECDX"   
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realiza atualização do item³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RECLOCK("SX2", .T.)
	  
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Adiciona item ao array auxiliar para posterior atualização no banco de dados³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    AADD(aArqUpd, SX2LAT->X2_CHAVE)
			    
			    SX2->X2_CHAVE   := SX2LAT->X2_CHAVE
			    SX2->X2_PATH    := cPath
			    SX2->X2_ARQUIVO := SX2LAT->X2_CHAVE + cEmpAnt + "0"
			    SX2->X2_NOME	:= SX2LAT->X2_NOME
			    SX2->X2_NOMESPA	:= SX2LAT->X2_NOMESPA
			    SX2->X2_NOMEENG	:= SX2LAT->X2_NOMEENG
			    SX2->X2_ROTINA	:= SX2LAT->X2_ROTINA
			    SX2->X2_MODO	:= SX2LAT->X2_MODO
			    SX2->X2_DELET	:= SX2LAT->X2_DELET
			    SX2->X2_TTS		:= SX2LAT->X2_TTS
			    SX2->X2_UNICO	:= SX2LAT->X2_UNICO
			    SX2->X2_PYME	:= SX2LAT->X2_PYME
			    SX2->X2_MODULO	:= SX2LAT->X2_MODULO
			    SX2->X2_DISPLAY	:= SX2LAT->X2_DISPLAY	     
			SX2->(MSUNLOCK())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona o Alias da tabela adicionada ao SX2 do ambiente na variavel do arquivo de LOG³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTexto += "     " + SX2LAT->X2_CHAVE
			cTexto += hEnter
		EndIf   
		SX2LAT->(dbSkip()) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SX2³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Dicionário de Tabelas (SX2)")
	End                                            
ELSE
	cTexto += "Erro abrir arquivo \UPDTLAT\SX2LAT.DTC"
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SX2LAT.DTC")
ENDIF
SLEEP(5000)
cTexto += hEnter

Return cTexto                             

                         



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LTAtuSX3      Autor ³Jean P. Rossetto       ³ Data ³20/12/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao de processamento do SX3                 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³TOTVS LATICINIO.                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSX3() 
                        
Local cTexto	:= ""
Local cHelp		:= ""          
Local i			:= 0           
Local nAux		:= 1       
Local nCont		:= 0
Local aHelp		:= {}
Local hEnter    := chr(13)+chr(10)
Local cOrdem	:= "00"
Local lAtualiza	:= .F.       
Local lVerifica := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX3LAT que possui todas os campos do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SX3LAT") > 0
	SX3LAT->(dbCloseArea())
EndIf
bSx3Open := FILE("\UPDTLAT\SX3LAT.DTC")
bHlpOpen := FILE("\UPDTLAT\HELPLAT.DTC")                
IF bSx3Open .AND. bHlpOpen

	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SX3LAT.DTC", "SX3LAT", .F., .F.)       
	dbSelectArea("SX3LAT")           
	                       
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega a tabela auxiliar HELPLAT que possui todas os Helps de campos do Gestao de Laticinios³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("HELPLAT") > 0
		HELPLAT->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "CTREECDX", "\UPDTLAT\HELPLAT.DTC", "HELPLAT", .F., .F.)       
	dbSelectArea("HELPLAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação a tabela SX3 da empresa logada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())     
	    
	
	aArqUpd	:= {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia laço de verificação + adição dos campos do Gestao de Laticinios³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SX3LAT->(!EOF())   
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt
		//³Pega ultima ordem existente para o Alias do item³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt
		cOrdem	:= "00"	
		dbSelectArea("SX3")
		SX3->(dbSetOrder(1))
		SX3->(dbGoTop()) 	
	    dbSeek(SX3LAT->X3_ARQUIVO)
	    While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == SX3LAT->X3_ARQUIVO
	        cOrdem := SX3->X3_ORDEM
	    	SX3->(dbSkip())                                                                          
	    End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona o campo do Gestao de Laticinios somente se o mesmo ainda não existir³
		//ÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		SX3->(dbGoTop()) 
		If !SX3->(dbSeek(SX3LAT->X3_CAMPO))
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza variavel de controle do arquivo de log adicionando informacoes especificas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAtualiza
			    cTexto += hEnter
				cTexto += "     ADICIONADO OS CAMPOS: " 
				cTexto += hEnter
				cTexto += hEnter
				lAtualiza := .T.  
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Executa procedimentos de backup do SX que esta sendo manipulado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lBackup
					MAKEDIR("\UPDTLAT\BACKUP_SX\") 
					MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
					_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SX3" + cEmpAnt + "0.DTC"
					Copy to &_cArqDest VIA "CTREECDX"   
				EndIf
			EndIf  
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa o valor de ordem para a obter o valor da ordem do novo campo no SX3³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cOrdem	:= Soma1(cOrdem, 2)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega o Help do campo da tabela auxiliar de Helps e efetua tratativas necessario para adicionar o mesmo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("HELPLAT")  
			dbGoTop()
			While !HELPLAT->(EOF())
			    If HELPLAT->HELP_CAMPO == SX3LAT->X3_CAMPO		   	 	
			   	 	aHelp := STRTOKARR(HELPLAT->HELP_HELP, CHR(13))
			   	 	For i := 1 to Len(aHelp)
			   	 		nCont := Len(aHelp[i])
			   	 		cHelp := SUBSTR(aHelp[i], 1, nCont) + SPACE(1) 
			   	 		aHelp[i] := cHelp
			   	 	Next i	                              
			   	 	cHelp := ""   
			   	 	i     := 1 
					nAux  := Len(aHelp) 
					lVerifica := .T.
			   	 	
			   	 	While lVerifica
			   	 		If i <= Len(aHelp)
					   	 	If Len(ALLTRIM(aHelp[i])) == 0
						   	 	//Deleta o item do array
								ADEL(aHelp, i)  
								i := 1                  
								// Reorganiza o array
								ASIZE(aHelp,(nAux - 1))    
								nAux := Len(aHelp)     
							Else
								i++
							EndIf
						Else
							exit
						EndIf
					End
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza o help do campo o qual esta sendo incluido³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   		PUTHELP("P"+SX3LAT->X3_CAMPO, aHelp, aHelp, aHelp, .F.)
			   		aHelp	:= {}                                       
			   		nAux	:= 1
			   		exit                   
			    EndIf
				HELPLAT->(dbSkip())
			End	
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona o alias da tabela a qual pertence o campo para atualização posteriormente no banco de dados caso a tabela já exista no banco³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AADD(aArqUpd, SX3LAT->X3_ARQUIVO)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Efetua a atualização do novo item no SX3 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RECLOCK("SX3", .T.)
			    SX3->X3_ARQUIVO	:= SX3LAT->X3_ARQUIVO
			    SX3->X3_ORDEM	:= cOrdem 
			    SX3->X3_CAMPO	:= SX3LAT->X3_CAMPO
			    SX3->X3_TIPO	:= SX3LAT->X3_TIPO
			    SX3->X3_TAMANHO	:= SX3LAT->X3_TAMANHO
			    SX3->X3_DECIMAL	:= SX3LAT->X3_DECIMAL
			    SX3->X3_TITULO	:= SX3LAT->X3_TITULO
			    SX3->X3_TITSPA	:= SX3LAT->X3_TITSPA
			    SX3->X3_TITENG	:= SX3LAT->X3_TITENG
			    SX3->X3_DESCRIC	:= SX3LAT->X3_DESCRIC
			    SX3->X3_DESCSPA	:= SX3LAT->X3_DESCSPA
			    SX3->X3_DESCENG	:= SX3LAT->X3_DESCENG
			    SX3->X3_PICTURE	:= SX3LAT->X3_PICTURE
			    SX3->X3_VALID	:= SX3LAT->X3_VALID
			    SX3->X3_USADO	:= SX3LAT->X3_USADO
			    SX3->X3_RELACAO	:= SX3LAT->X3_RELACAO
			    SX3->X3_F3		:= SX3LAT->X3_F3
			    SX3->X3_NIVEL	:= SX3LAT->X3_NIVEL
			    SX3->X3_RESERV	:= SX3LAT->X3_RESERV
			    SX3->X3_CHECK	:= SX3LAT->X3_CHECK
			    SX3->X3_TRIGGER	:= SX3LAT->X3_TRIGGER
			    SX3->X3_PROPRI	:= SX3LAT->X3_PROPRI
			    SX3->X3_BROWSE	:= SX3LAT->X3_BROWSE
			    SX3->X3_VISUAL	:= SX3LAT->X3_VISUAL
			    SX3->X3_CONTEXT	:= SX3LAT->X3_CONTEXT
			    SX3->X3_OBRIGAT	:= SX3LAT->X3_OBRIGAT
			    SX3->X3_VLDUSER	:= SX3LAT->X3_VLDUSER
			    SX3->X3_CBOX	:= SX3LAT->X3_CBOX
			    SX3->X3_CBOXSPA	:= SX3LAT->X3_CBOXSPA
			    SX3->X3_CBOXENG	:= SX3LAT->X3_CBOXENG
			    SX3->X3_PICTVAR	:= SX3LAT->X3_PICTVAR
			    SX3->X3_WHEN	:= SX3LAT->X3_WHEN
			    SX3->X3_INIBRW	:= SX3LAT->X3_INIBRW
			    SX3->X3_GRPSXG	:= SX3LAT->X3_GRPSXG
			    SX3->X3_FOLDER	:= SX3LAT->X3_FOLDER
			    SX3->X3_PYME	:= SX3LAT->X3_PYME
			    SX3->X3_CONDSQL	:= SX3LAT->X3_CONDSQL
			    SX3->X3_CHKSQL	:= SX3LAT->X3_CHKSQL
			    SX3->X3_IDXSRV	:= SX3LAT->X3_IDXSRV
			    SX3->X3_ORTOGRA	:= SX3LAT->X3_ORTOGRA
			    SX3->X3_IDXFLD	:= SX3LAT->X3_IDXFLD
			    SX3->X3_TELA	:= SX3LAT->X3_TELA     
			SX3->(MSUNLOCK()) 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona o campo adicionado ao SX3 do ambiente na variavel do arquivo de LOG³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
			cTexto += "     " + SX3LAT->X3_CAMPO
			cTexto += hEnter                                                     
			cOrdem := "00"
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega o Help do campo da tabela auxiliar de Helps e efetua tratativas necessario para adicionar o mesmo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("HELPLAT")  
			dbGoTop()
			While !HELPLAT->(EOF())
			    If HELPLAT->HELP_CAMPO == SX3LAT->X3_CAMPO		   	 	
			   	 	aHelp := STRTOKARR(HELPLAT->HELP_HELP, CHR(13))
			   	 	For i := 1 to Len(aHelp)
			   	 		nCont := Len(aHelp[i])
			   	 		cHelp := SUBSTR(aHelp[i], 1, nCont) + SPACE(1) 
			   	 		aHelp[i] := cHelp
			   	 	Next i	                              
			   	 	cHelp := ""   
			   	 	i     := 1 
					nAux  := Len(aHelp) 
					lVerifica := .T.
			   	 	
			   	 	While lVerifica
			   	 		If i <= Len(aHelp)
					   	 	If Len(ALLTRIM(aHelp[i])) == 0
						   	 	//Deleta o item do array
								ADEL(aHelp, i)  
								i := 1                  
								// Reorganiza o array
								ASIZE(aHelp,(nAux - 1))    
								nAux := Len(aHelp)     
							Else
								i++
							EndIf
						Else
							exit
						EndIf
					End
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza o help do campo o qual esta sendo incluido³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   		PUTHELP("P"+SX3LAT->X3_CAMPO, aHelp, aHelp, aHelp, .F.)
			   		aHelp	:= {}                                       
			   		nAux	:= 1
			   		exit                   
			    EndIf
				HELPLAT->(dbSkip())
			End	
		EndIf 
		SX3LAT->(dbSkip())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SX3³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Dicionário de Campos (SX3)")
	End     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fecha as tabelas auxiliares utilizadas no processo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3LAT->(dbCloseArea())
	HELPLAT->(dbCloseArea())
ELSE
	IF !bSx3Open
		cTexto += "Erro abrir arquivo \UPDTLAT\SX3LAT.DTC"
		ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SX3LAT.DTC")		
	ENDIF
	IF !bHlpOpen                                   
		cTexto += "Erro abrir arquivo \UPDTLAT\HELPLAT.DTC"
		ALERT("Arquivo nao encontrado: "+"\UPDTLAT\HELPLAT.DTC")		
	ENDIF
ENDIF  

SLEEP(5000)
cTexto += hEnter
cTexto += hEnter

Return cTexto

             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LTAtuSX5      Autor ³Jean P. Rossetto       ³ Data ³20/12/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao de processamento do arquivo de tabelas genéricas.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³TOTVS LATICINIO.                              			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSX5()                                                

Local cTexto	:= ""          
Local hEnter    := chr(13)+chr(10)
Local lAtualiza	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX2LAT que possui todas as tabelas do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
If Select("SX5LAT") > 0
	SX5LAT->(dbCloseArea())
EndIf
IF FILE("\UPDTLAT\SX5LAT.DTC")
	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SX5LAT.DTC", "SX5LAT", .F., .F.)       
	dbSelectArea("SX5LAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação a tabela SX2 da empresa logada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SX5")
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH
	//³Seta tamanho da regua de processamento com base no numero   ³
	//³de itens a serem aplicados existentes nas tabelas auxiliares³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH
	_oProcess:SetRegua1(nProcessa)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia laço de verificação + adição dos indices do Gestao de Laticinios³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SX5LAT->(!EOF())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Adiciona a tabela do Gestao de Laticinios somente se a mesma ainda não existir³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !SX5->(dbSeek( SX5LAT->X5_FILIAL + SX5LAT->X5_TABELA + SX5LAT->X5_CHAVE ))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa verificações de geração de Log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAtualiza 
				cTexto += hEnter
				cTexto += "     ADICIONADA TABELA GENERICA: " 
				cTexto += hEnter
				cTexto += hEnter
				lAtualiza := .T.    
				If lBackup
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Executa procedimentos de backup do SX que esta sendo manipulado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MAKEDIR("\UPDTLAT\BACKUP_SX\") 
					MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
					_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SX5" + cEmpAnt + "0.DTC"
					Copy to &_cArqDest VIA "CTREECDX"   
				EndIf               
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Efetua atualização do item³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			RECLOCK("SX5", .T.)
			    SX5->X5_FILIAL		:= xFilial("SX5")
			    SX5->X5_TABELA		:= SX5LAT->X5_TABELA
			    SX5->X5_CHAVE		:= SX5LAT->X5_CHAVE
			    SX5->X5_DESCRI  	:= SX5LAT->X5_DESCRI
			    SX5->X5_DESCSPA	    := SX5LAT->X5_DESCSPA
			    SX5->X5_DESCENG 	:= SX5LAT->X5_DESCENG
			SX5->(MSUNLOCK())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona a chave do indice adicionado ao SX5 a variavel do arquivo de LOG ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTexto += "     " + SX5LAT->X5_TABELA + " - " +SX5LAT->X5_CHAVE
			cTexto += hEnter
		EndIf    
		SX5LAT->(dbSkip())   
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SX5³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Tabelas Genéricas (SX5)")
	End 
                
ELSE
	cTexto += "Erro abrir arquivo \UPDTLAT\SX5LAT.DTC"
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SX5LAT.DTC")
ENDIF
SLEEP(5000)
cTexto += hEnter

Return cTexto
             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTAtuSX6  ºAutor  ³Jean P. Rossetto    º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel pela atualização de paramentros (SX6)    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSX6()                                                

Local lAtualiza	:= .F.
Local lInclui	:= .F.
Local cTexto 	:= ""
Local hEnter    := chr(13)+chr(10)
/*Local cPath                     
Local cOrdem      */
            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX7LAT que contem todos os gatilhos de campos do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SX6LAT") > 0
	SX6LAT->(dbCloseArea())
EndIf                                                                                              
IF FILE("\UPDTLAT\SX6LAT.DTC")                

	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SX6LAT.DTC", "SX6LAT", .F., .F.)       
	dbSelectArea("SX6LAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação o SX7 da empresa logada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX6")
	dbSetOrder(1)       
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa laço o qual aplicará todos os gatilhos     ³
	//³do Gestao de Laticinios no SXB da empresa logada   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SX6LAT->(!EOF())                    
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
		//³Verifica se o parametro a ser incluido já existe no ambiente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
		dbSelectArea("SX6")
	    dbSetorder(1)
	    dbGoTop() 
	    lInclui := .T.
	    If dbSeek(SX6LAT->X6_FIL + SX6LAT->X6_VAR)
	    	lInclui := .F.
	    EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona o parametro somente se o mesmo não existir³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lInclui
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica atualização de Log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAtualiza  
				cTexto += hEnter
				cTexto += "     ADICIONADO OS PARAMETROS: "  
				cTexto += hEnter
				cTexto += hEnter
				lAtualiza := .T.
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Executa procedimentos de backup do SX que esta sendo manipulado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lBackup
					MAKEDIR("\UPDTLAT\BACKUP_SX\") 
					MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
					_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SX6" + cEmpAnt + "0.DTC"
					Copy to &_cArqDest VIA "CTREECDX"                            
				EndIf
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX
			//³Efetua atualização no SX6 do parametro posicionado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX
			RECLOCK("SX6", .T.)		    
			    SX6->X6_FIL		:= 	SX6LAT->X6_FIL		
			    SX6->X6_VAR		:=	SX6LAT->X6_VAR
			    SX6->X6_TIPO	:=	SX6LAT->X6_TIPO
			    SX6->X6_DESCRIC :=	SX6LAT->X6_DESCRIC
			    SX6->X6_DSCSPA	:=	SX6LAT->X6_DSCSPA
			    SX6->X6_DSCENG	:=	SX6LAT->X6_DSCENG
			    SX6->X6_DESC1	:=	SX6LAT->X6_DESC1
			    SX6->X6_DSCSPA1	:=	SX6LAT->X6_DSCSPA1
			    SX6->X6_DSCENG1	:=	SX6LAT->X6_DSCENG1
			    SX6->X6_DESC2	:=	SX6LAT->X6_DESC2
			    SX6->X6_DSCSPA2	:=	SX6LAT->X6_DSCSPA2
			    SX6->X6_DSCENG2	:=	SX6LAT->X6_DSCENG2
				SX6->X6_CONTEUD	:=	SX6LAT->X6_CONTEUD
				SX6->X6_CONTSPA	:=	SX6LAT->X6_CONTSPA
				SX6->X6_CONTENG	:=	SX6LAT->X6_CONTENG
				SX6->X6_PROPRI	:=	SX6LAT->X6_PROPRI
				SX6->X6_PYME	:=	SX6LAT->X6_PYME
				SX6->X6_VALID	:=	SX6LAT->X6_VALID
				SX6->X6_INIT	:=	SX6LAT->X6_INIT
				SX6->X6_DEFPOR	:=	SX6LAT->X6_DEFPOR
				SX6->X6_DEFSPA	:=	SX6LAT->X6_DEFSPA
				SX6->X6_DEFENG	:=	SX6LAT->X6_DEFENG
			SX6->(MSUNLOCK())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Registra gatilho na variavel de controle do log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTexto += "     " + SX6LAT->X6_VAR
			cTexto += hEnter
		EndIf   
		SX6LAT->(dbSkip())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SX6³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Dicionário de Parametros (SX6)")
	End                                                          
ELSE
	cTexto += "Erro abrir arquivo \UPDTLAT\SX6LAT.DTC"
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SX6LAT.DTC")
ENDIF
SLEEP(5000)
cTexto += hEnter

Return cTexto





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTAtuSX7  ºAutor  ³Jean P. Rossetto    º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de atualização do SX7 (Gatilhos de campos).          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao de Laticinios                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSX7()                                                

Local lAtualiza	:= .F.
Local lInclui	:= .F.
Local cTexto 	:= ""
Local hEnter    := chr(13)+chr(10)
//Local cPath                     
Local cOrdem      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX7LAT que contem todos os gatilhos de campos do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SX7LAT") > 0
	SX7LAT->(dbCloseArea())
EndIf                                                                                              
IF FILE("\UPDTLAT\SX7LAT.DTC")                
	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SX7LAT.DTC", "SX7LAT", .F., .F.)       
	dbSelectArea("SX7LAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação o SX7 da empresa logada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX7")
	dbSetOrder(1)       
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa laço o qual aplicará todos os gatilhos     ³
	//³do Gestao de Laticinios no SX7 da empresa logada   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SX7LAT->(!EOF())                    
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pega proxima sequencia valida para gatilho do campo posicionado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    dbSelectArea("SX7")
	    dbSetorder(1)
	    dbGoTop()
	    If dbSeek(SX7LAT->X7_CAMPO)
	    	While (SX7->(!EOF()) .AND. SX7->X7_CAMPO == SX7LAT->X7_CAMPO)   
				cOrdem := SX7->X7_SEQUENC   
				SX7->(dbSkip())
			End                    
			cOrdem := SOMA1(cOrdem)
	    Else
	    	cOrdem := STRZERO(1, 3)
	    EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se já existe gatilho para o campo, caso exista, verifica³
		//³se o mesmo possui a mesma regras e o mesmo contra dominio        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX7")
	    dbSetorder(1)
	    dbGoTop() 
	    lInclui := .F.
	    If dbSeek(SX7LAT->X7_CAMPO)
	    	While (SX7->(!EOF()) .AND. SX7->X7_CAMPO == SX7LAT->X7_CAMPO)   
				If (SX7->X7_REGRA != SX7LAT->X7_REGRA .AND. SX7->X7_CDOMIN != SX7LAT->X7_CDOMIN)
				   lInclui := .T.    
				Else
					lInclui := .F. 
					exit
				EndIf 
				SX7->(dbSkip())		
			End                    
		Else
			lInclui := .T.
	    EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona o gatilho posicionado na tabela auxiliar somente se o mesmo nao existir no SX7 da empresa logada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lInclui
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica atualização do log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAtualiza  
				cTexto += hEnter
				cTexto += "     ADICIONADO OS GATILHOS: "  
				cTexto += hEnter
				cTexto += hEnter
				lAtualiza := .T.
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Executa procedimentos de backup do SX que esta sendo manipulado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lBackup
					MAKEDIR("\UPDTLAT\BACKUP_SX\") 
					MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
					_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SX7" + cEmpAnt + "0.DTC"
					Copy to &_cArqDest VIA "CTREECDX"                            
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Efetuado atualização do item posicionado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RECLOCK("SX7", .T.)		    
			    SX7->X7_CAMPO   := SX7LAT->X7_CAMPO
				SX7->X7_SEQUENC	:= cOrdem
				SX7->X7_REGRA	:= SX7LAT->X7_REGRA
				SX7->X7_CDOMIN	:= SX7LAT->X7_CDOMIN
				SX7->X7_TIPO	:= SX7LAT->X7_TIPO
				SX7->X7_SEEK	:= SX7LAT->X7_SEEK
				SX7->X7_ALIAS	:= SX7LAT->X7_ALIAS
				SX7->X7_ORDEM	:= SX7LAT->X7_ORDEM
				SX7->X7_CHAVE	:= SX7LAT->X7_CHAVE
				SX7->X7_CONDIC	:= SX7LAT->X7_CONDIC
				SX7->X7_PROPRI	:= SX7LAT->X7_PROPRI	     
			SX7->(MSUNLOCK())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Registra gatilho na variavel de controle do log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTexto += "     " + SX7LAT->X7_CAMPO + "  " + SX7LAT->X7_SEQUENC + "  " + SUBSTR(SX7LAT->X7_REGRA, 1, 35)
			cTexto += hEnter
		EndIf   
		SX7LAT->(dbSkip())       
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SX7³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Dicionário de Gatilhos (SX7)")
	End                                                          
ELSE
	cTexto += "Erro abrir arquivo \UPDTLAT\SX7LAT.DTC"
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SX7LAT.DTC")
ENDIF
SLEEP(5000)
cTexto += hEnter

Return cTexto

             
             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTAtuSXA  ºAutor  ³Jean P. Rossetto    º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de atualização dos folders (SXA)                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSXA()                                                

Local lAtualiza	:= .F.
Local lInclui	:= .F.
Local cTexto 	:= ""
Local hEnter    := chr(13)+chr(10)
//Local cPath                     
Local cOrdem	:= "0"      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SXALAT que contem todos os gatilhos de campos do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SXALAT") > 0
	SXALAT->(dbCloseArea())
EndIf
IF FILE("\UPDTLAT\SXALAT.DTC")                
	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SXALAT.DTC", "SXALAT", .F., .F.)       
	dbSelectArea("SXALAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação o SX7 da empresa logada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SXA")
	dbSetOrder(1)       
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa laço o qual aplicará todos os gatilhos    ³
	//³do Gestao de Laticinios no SXB da empresa logada  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SXALAT->(!EOF())                    
	    	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona a pasta posicionada na tabela auxiliar somente se a mesma nao existir no SXA da empresa logada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lInclui := .T.
		dbSelectArea("SXA")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(SXALAT->XA_ALIAS)
			While (SXA->(!EOF()) .AND. SXA->XA_ALIAS == SXALAT->XA_ALIAS)
				If SXA->XA_DESCRIC == SXALAT->XA_DESCRIC
					lInclui := .F.			   
					exit
				Else
					cOrdem := SXA->XA_ORDEM
				EndIf 				           
				SXA->(dbSkip())
			End
		EndIf
		If lInclui
			cOrdem := SOMA1(cOrdem)                  
			
			If !lAtualiza  
				cTexto += hEnter
				cTexto += "     ADICIONADO OS FOLDERS: "  
				cTexto += hEnter
				cTexto += hEnter
				lAtualiza := .T.
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Executa procedimentos de backup do SX que esta sendo manipulado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lBackup
					MAKEDIR("\UPDTLAT\BACKUP_SX\") 
					MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
					_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SXA" + cEmpAnt + "0.DTC"
					Copy to &_cArqDest VIA "CTREECDX"                            
				EndIf
			EndIf
			
			RECLOCK("SXA", .T.)		    
			    SXA->XA_ALIAS	:= SXALAT->XA_ALIAS
				SXA->XA_ORDEM	:= cOrdem
				SXA->XA_DESCRIC	:= SXALAT->XA_DESCRIC
				SXA->XA_DESCSPA	:= SXALAT->XA_DESCSPA
				SXA->XA_DESCENG	:= SXALAT->XA_DESCENG
				SXA->XA_PROPRI	:= SXALAT->XA_PROPRI
			SXA->(MSUNLOCK())   
			
			cOrdem	:= "0"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Registra gatilho na variavel de controle do log³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTexto += "     " + SXALAT->XA_ALIAS + "  " + SXALAT->XA_ORDEM + "  " + UPPER(SXALAT->XA_DESCRIC)
			cTexto += hEnter
		EndIf   
		SXALAT->(dbSkip())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SXA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Dicionário de Folders (SXA)") 
	End                                                          
ELSE
	cTexto += "Erro abrir arquivo \UPDTLAT\SXALAT.DTC"
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SXALAT.DTC")
ENDIF
SLEEP(5000)
cTexto += hEnter

Return cTexto





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTAtuSXB  ºAutor  ³Jean P. Rossetto    º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel pela atualização de consultas padrões    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LTAtuSXB()                                                

Local lAtualiza	:= .F.
Local lInclui	:= .F.
Local cTexto 	:= ""
Local hEnter    := chr(13)+chr(10)
/*Local cPath                     
Local cOrdem      */
Local cConsulta := Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX7LAT que contem todos os gatilhos de campos do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SXBLAT") > 0
	SXBLAT->(dbCloseArea())
EndIf
IF FILE("\UPDTLAT\SXBLAT.DTC")                
	
	dbUseArea(.T., "CTREECDX", "\UPDTLAT\SXBLAT.DTC", "SXBLAT", .F., .F.)       
	dbSelectArea("SXBLAT")  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta para manipulação o SX7 da empresa logada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SXB")
	dbSetOrder(1)       
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa laço o qual aplicará todos os gatilhos     ³
	//³do Gestao de Laticinios no SXB da empresa logada   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SXBLAT->(!EOF())                    
	    
	        
		If !(cConsulta == SXBLAT->XB_ALIAS)
			dbSelectArea("SXB")
		    dbSetorder(1)
		    dbGoTop() 
		    lInclui := .F.
		    If !dbSeek(SXBLAT->XB_ALIAS)
		    	lInclui := .T. 
		    	cConsulta := SXBLAT->XB_ALIAS
		    	
		    	If !lAtualiza  
					cTexto += hEnter
					cTexto += "     ADICIONADO AS CONSULTAS PADROES: "  
					cTexto += hEnter
					cTexto += hEnter
					lAtualiza := .T.
				
					//
					//Executa procedimentos de backup do SX que esta sendo manipulado
					//
					If lBackup
						MAKEDIR("\UPDTLAT\BACKUP_SX\") 
						MAKEDIR("\UPDTLAT\BACKUP_SX\EMPRESA "+cEmpAnt)
						_cArqDest := "\UPDTLAT\BACKUP_SX\EMPRESA " + cEmpAnt + "\BKP_SXB" + cEmpAnt + "0.DTC"
						Copy to &_cArqDest VIA "CTREECDX"                            
					EndIf
				EndIf 
			Else
				cConsulta := NIL
		    EndIf
		    
		    If cConsulta != Nil
			    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Registra consulta padrao na variavel de controle do log³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cTexto += "     " + cConsulta 
				cTexto += hEnter
		    EndIf
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona o a consulta padrão posicionada na tabela auxiliar³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lInclui			
			RECLOCK("SXB", .T.)		    
				SXB->XB_ALIAS		:= SXBLAT->XB_ALIAS
				SXB->XB_TIPO		:= SXBLAT->XB_TIPO
				SXB->XB_SEQ			:= SXBLAT->XB_SEQ
				SXB->XB_COLUNA		:= SXBLAT->XB_COLUNA
				SXB->XB_DESCRI		:= SXBLAT->XB_DESCRI
				SXB->XB_DESCSPA		:= SXBLAT->XB_DESCSPA
				SXB->XB_DESCENG		:= SXBLAT->XB_DESCENG
				SXB->XB_CONTEM		:= SXBLAT->XB_CONTEM
				SXB->XB_WCONTEM		:= SXBLAT->XB_WCONTEM
			SXB->(MSUNLOCK())
		EndIf   
		SXBLAT->(dbSkip())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ„
		//³Atualiza barra de status do SXB³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_oProcess:IncRegua1("Atualizando Dicionário de Consultas Padrões (SXB)")
	End                                                          
ELSE
	cTexto += "Erro abrir arquivo \UPDTLAT\SXBLAT.DTC"
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\SXBLAT.DTC")
ENDIF
SLEEP(5000)
cTexto += hEnter

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTLOADUPD ºAutor  ³Jean P. Rossetto    º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel por executar a função de aplicação do    º±±
±±º          ³modulo de TOTVS LATICINIO.(LTPROC) através de apresentaçao  º±±
±±º          ³em componente MsNewProcess para que o usuario possa estar   º±±
±±º          ³acompanhando a execução do UPDATE							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTLOADUPD()   
                                     
Private nProcessa := (UPDNUMREGS("SIX") + UPDNUMREGS("SX2") + UPDNUMREGS("SX3") + UPDNUMREGS("SX5") + UPDNUMREGS("SX6") + UPDNUMREGS("SX7") + UPDNUMREGS("SXA") + UPDNUMREGS("SXB"))

_oProcess := MsNewProcess():New({|| LTProc()},"Atualizando Dicionário de Dados","Abrindo Arquivos",.F.)
_oProcess:Activate ()


Return nil                      



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDNUMREGS   ºAutor  ³Jean P. Rossetto   º Data ³  20/12/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsavel por retornar o numero de registros exis- º±±
±±º          ³tentes na tabela auxiliar repassada como parametro          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDNUMREGS(cItem)

Local nRegs := 0       

cItem := cItem + "LAT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SXALAT que contem todos os gatilhos de campos do Gestao de Laticinios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select(cItem) > 0
	(cItem)->(dbCloseArea())
EndIf
IF FILE("\UPDTLAT\" + cItem + ".DTC")
	dbUseArea(.T., "CTREECDX", "\UPDTLAT\" + cItem + ".DTC", cItem, .F., .F.)       
	dbSelectArea(cItem)  
	
	nRegs := (cItem)->(RECCOUNT()) 
	     
	If Select(cItem) > 0
		(cItem)->(dbCloseArea())
	EndIf
ELSE
	ALERT("Arquivo nao encontrado: "+"\UPDTLAT\" + cItem + ".DTC")
ENDIF

Return nRegs 






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTLOADHELP  ºAutor  ³Marcelo Joner     º Data ³  27/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsavel por analisar o SX3LAT o qual contem os   º±±
±±º          ³campos do Gestao de Cereais e com base na relação dos mesmosº±±
±±º          ³procura na base e adiciona a uma nova tabela (arquivo) auxi º±±
±±º          ³liar help de todos os campos presentes no SX3LAT, os mesmos º±± 
±±º          ³são utilizados para criação dos campos do LATICINIO.        º±±
±±º          ³															  º±±   
±±º          ³															  º±±
±±º          ³OBSERVAÇÃO: O MESMO DEVE SER EXECUTADO PELO REMOTE EM MODO  º±±
±±º          ³EXCLUSIVO													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTLOADHELP()
                                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura da tabela HELPLAT a qual será criada com os helps dos campos do LATICINIO.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStru	:= {{'HELP_CAMPO', 'C', 10, 0}, {'HELP_HELP', 'C', 950, 0} }
Local i		:= 0
Local cHelp	:= ""
Local aHelp	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄC
//³Cria a nova tabela no RootPath do ambiente, ou seja, \Protheus_Data\³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄC
dbCreate('\UPDTLAT\HELPLAT.DBF', aStru) 
Use '\UPDTLAT\HELPLAT.DBF' Via 'DBFCDX' New

dbSelectArea("HELPLAT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a tabela auxiliar SX3LAT que possui todas os campos do LATICINIO.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SX3LAT") > 0
	SX3LAT->(dbCloseArea())
EndIf

dbUseArea(.T., "CTREECDX", "\UPDTLAT\SX3LAT.DTC", "SX3LAT", .F., .F.)       
dbSelectArea("SX3LAT")    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seta variaveis necessarias³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
__TTSINUSE := .F.  
__TTSPUSH	:= {}
__CLOGSIGA	:= "NNNNNNN" 
CARQHLP	:= "SIGAHLP.HLP" 
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄd¿
//³Inicia a busca/gravacao dos Helps de campos conforme todos os campos existentes no SX3LAT³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄdÙ
While !SX3LAT->(EOF())                     
	RECLOCK("HELPLAT", .T.)
    	HELPLAT->HELP_CAMPO := SX3LAT->X3_CAMPO
    	HELPLAT->HELP_HELP  := AP5GETHELP(SX3LAT->X3_CAMPO)
	
		aHelp := STRTOKARR(HELPLAT->HELP_HELP, CHR(10))		
		cHelp := ""      

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicia uma regra de tratamento no Help obtido do campo para eliminar trechos repetidos e ³
		//³tambem sequencia de espaços em branco.                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		i   := 2     
		j 	:= 1
		nAux  := Len(aHelp) 
		lVerifica := .T.

   	 	While lVerifica
   	 		If i <= Len(aHelp)
		   	 	If (((aHelp[i] $ aHelp[j])  .AND. (i != j)) .OR. (Len(ALLTRIM(aHelp[i])) == 0))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Deleta o item do array³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					ADEL(aHelp, i)              
					j++       
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Reorganiza o array³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ASIZE(aHelp,(nAux - 1))    
					nAux := Len(aHelp)  
					If i > nAux
						exit
					Else
						i := 1
					EndIf   
				Else
					i++
				EndIf
			Else
				exit
			EndIf
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o help do campo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i := 1 To Len(aHelp)    
			cHelp += aHelp[i]
		Next i

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atribui o help do campo pronto ao campo da tabela onde o mesmo será gravado.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		HELPLAT->HELP_HELP  := cHelp

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Confirma a gravação do help na tabela HELPLAT e avanca para o proximo campo existente no SX3LAT³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		HELPLAT->(MSUNLOCK())
		SX3LAT->(dbSkip())
End                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha as tabelas utilizadas/manipuladas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3LAT->(dbCloseArea())
HELPLAT->(dbCloseArea())  

Alert("HELPS FINALIZADO")

Return Nil  




