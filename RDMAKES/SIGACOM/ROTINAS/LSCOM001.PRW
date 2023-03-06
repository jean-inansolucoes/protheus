#include "TOTVS.CH"  
#include "RWMAKE.CH"
#include "TOPCONN.CH"
                           
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LSCOM001    º Autor ³ Rafael Parma      Data ³  18/10/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Função para cópia de arquivos XML referente ao documento de º±±
±±º          ³entrada para o computador do usuário.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LSCOM001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------------------*
User Function LSCOM001()
*--------------------------------------* 
Private cDlgTitle := "Arquivos XML - Documento Entrada"
Private cPerg     := "LSCOM00001"
Private cAliasTMP := GetNextAlias()
Private aCampos   := {} 
Private aFILECPY  := {}
Private lInverte  := .F. 
Private nOpcao    := 0
Private cMarca    := GetMark()        
Private oDlg

	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf    


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de registros                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery := "	SELECT	SF1.F1_FILIAL, 																		"+chr(10)+chr(13) 
	cQuery += "			SF1.F1_DOC,    																		"+chr(10)+chr(13)  
	cQuery += "			SF1.F1_SERIE,  																		"+chr(10)+chr(13)  
	cQuery += "			SF1.F1_FORNECE,																		"+chr(10)+chr(13)  
	cQuery += "			SF1.F1_LOJA,  																		"+chr(10)+chr(13)  
	cQuery += "			SA2.A2_NOME,   																		"+chr(10)+chr(13)  
	cQuery += "			SF1.F1_EMISSAO,																		"+chr(10)+chr(13)  
	cQuery += "			SF1.F1_X_NFXML,																		"+chr(10)+chr(13)
	cQuery += "			'  ' F1_X_OK																		"+chr(10)+chr(13) 					
	cQuery += " FROM " + RetSQLName("SF1") + " SF1															"+chr(10)+chr(13) 
	cQuery += " INNER JOIN " + RetSQLName("SA2") + " SA2													"+chr(10)+chr(13) 
	cQuery += "	ON		SA2.A2_COD = SF1.F1_FORNECE															"+chr(10)+chr(13) 
	cQuery += "	AND		SA2.A2_LOJA = SF1.F1_LOJA															"+chr(10)+chr(13) 
	cQuery += " WHERE	SF1.F1_FILIAL  BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'					"+chr(10)+chr(13) 
	cQuery += " AND		SF1.F1_FORNECE BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'					"+chr(10)+chr(13) 
	cQuery += " AND		SF1.F1_LOJA    BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'					"+chr(10)+chr(13) 
	cQuery += " AND		SF1.F1_DOC     BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'	   				"+chr(10)+chr(13) 			
	cQuery += " AND		SF1.F1_EMISSAO BETWEEN '" + dtos(mv_par09) + "' AND '" + dtos(mv_par10) + "'		"+chr(10)+chr(13) 
	cQuery += " AND 	SF1.F1_ESPECIE = 'SPED '															"+chr(10)+chr(13) 
	cQuery += " AND 	SF1.F1_X_NFXML <> ' ' 																"+chr(10)+chr(13) 
	cQuery += " AND 	SF1.D_E_L_E_T_ <> '*' 																"+chr(10)+chr(13) 
	cQuery += " AND 	SA2.D_E_L_E_T_ <> '*' 																"+chr(10)+chr(13) 
	cQuery += " ORDER BY SF1.F1_FILIAL, SF1.F1_EMISSAO, SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_DOC				"+chr(10)+chr(13) 
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)	
                                         
	dbSelectArea("SF1")
	aStruct := dbStruct()
	aAdd (aStruct , { "F1_X_OK", "C", 02 , 0 } )
	aAdd (aStruct , { "A2_NOME", "C", 40 , 0 } )

	cArqTrab := CriaTrab(aStruct, .T.)
	dbUseArea(.T.,, cArqTrab ,"_SF1", .F.,.F. )
	dbSelectArea("_SF1")
	Index on F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC to &cArqTrab

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza temporarios                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nREG := 0	
	dbSelectArea(cAliasTMP)
	dbGoTop()
	While ! (cAliasTMP)->(EOF())
	    dbSelectArea("_SF1")
	    RecLock("_SF1",.T.)
	    For x := 1 To Len(aStruct)
	       If ALLTRIM(aStruct[x,1]) $ "F1_FILIAL/F1_DOC/F1_SERIE/F1_FORNECE/F1_LOJA/F1_EMISSAO/F1_X_NFXML"
		       _nPosic := FieldPos(aStruct[x,1])
		       _cCampo := (cAliasTMP)+"->"+aStruct[x,1]
		       _cDados := &_cCampo
		       _SF1->(FieldPut(_nPosic,_cDados))
		   EndIf
		Next
	    _SF1->F1_X_OK := Space(02)
	    _SF1->A2_NOME := (cAliasTMP)->A2_NOME
	    MsUnLock("_SF1")
	    nREG += 1
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbSkip())
	Enddo             
	(cAliasTMP)->(dbCloseArea())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos para mostrar no BROWSE padrao                      ³
	//³ Necessario quando usando um arquivo qualquer (sem o SX3)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AADD(aCampos,{"F1_X_OK"   	,"" ," "          	," " })
	AADD(aCampos,{"F1_FILIAL"  	,"" ,"Filial"     	," " })
	AADD(aCampos,{"F1_DOC" 		,"" ,"Documento" 	," " })
	AADD(aCampos,{"F1_SERIE"	,"" ,"Serie"	 	," " })
	AADD(aCampos,{"F1_FORNECE" 	,"" ,"Fornecedor"	," " })
	AADD(aCampos,{"F1_LOJA" 	,"" ,"Loja"  		," " })
	AADD(aCampos,{"A2_NOME" 	,"" ,"Nome"  		," " })
	AADD(aCampos,{"F1_EMISSAO" 	,"" ,"Emissão"  	," " })
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Dialogo para Usuario Selecionar os Titulos Filtrados no arquivo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("_SF1")
	dbGoTop()

	DEFINE MSDIALOG oDlg TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL
	
	oMark := MsSelect():New("_SF1","F1_X_OK",,aCampos,@lInverte,@cMarca,{1,1,170,350})
  
	@ 180,310 BMPBUTTON TYPE 1 ACTION (nOpcao:=1,Close(oDlg))
	@ 180,270 BMPBUTTON TYPE 2 ACTION Close(oDlg) 
	
	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:bMark := {|| fRegSelED(oMark, cMarca, oDlg)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAllED(oMark, cMarca, oDlg)}


	ACTIVATE MSDIALOG oDlg CENTERED
    
	If nOpcao == 1
		
		//--Realiza cópia para dos arquivos para diretório destino.
		dbSelectArea("_SF1")
		dbGoTop()	
		While !EOF()
			If !Empty(_SF1->F1_X_OK)
				CpyS2T( _SF1->F1_X_NFXML, mv_par11, .F. )
				Alert(_SF1->F1_X_NFXML)
			EndIf
			_SF1->(dbSkip())
		Enddo
	
		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha alias temporarios                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	dbSelectArea("_SF1")
	dbCloseArea("_SF1")
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab+".*") 
	
Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*--------------------------------------------*
Static Function fRegSelED(oMark, cMarca, oDlg)
*--------------------------------------------*

	If Marked("F1_X_OK")
		RecLock("_SF1",.F.)
		Replace _SF1->F1_X_OK With cMarca
		MsUnlock()
	Else
		RecLock("_SF1",.F.)
		Replace _SF1->F1_X_OK With "  "
		MsUnlock()
	Endif
	
	oMark:oBrowse:Refresh(.t.)
	oDlg:Refresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marcador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*---------------------------------------------*
Static Function fMarkAllED(oMark, cMarca, oDlg)
*---------------------------------------------*
Local nREC := Recno()    
    
	dbGoTop()
	While !EOF()
		RecLock("_SF1",.F.)
		If Empty(_SF1->F1_X_OK)
			Replace _SF1->F1_X_OK With cMarca
		Else
			Replace _SF1->F1_X_OK With "  "
		Endif
		MsUnlock()
		dbSkip()
	EndDo  
	
	dbGoTo(nREC)
	oMark:oBrowse:Refresh(.t.)
	oDlg:Refresh()

Return .T. 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  18/10/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas MIFIN0003.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------------*
Static Function AjustaSX1()       
*--------------------------------*
aRegs  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Filial De           ?","Filial De           ?","Filial De           ?","mv_ch1","C",TAMSX3("F1_FILIAL")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","Filial Até          ?","Filial Até          ?","Filial Até          ?","mv_ch2","C",TAMSX3("F1_FILIAL")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"03","Fornecedor De       ?","Fornecedor De       ?","Fornecedor De       ?","mv_ch3","C",TAMSX3("F1_FORNECE")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","",""})
	aAdd(aRegs,{cPerg,"04","Fornecedor Até      ?","Fornecedor Até      ?","Fornecedor Até      ?","mv_ch4","C",TAMSX3("F1_FORNECE")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","",""})
	aAdd(aRegs,{cPerg,"05","Loja De             ?","Loja De             ?","Loja De             ?","mv_ch5","C",TAMSX3("F1_LOJA")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"06","Loja Até            ?","Loja Até            ?","Loja Até            ?","mv_ch6","C",TAMSX3("F1_LOJA")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"07","Documento De        ?","Documento De        ?","Documento De        ?","mv_ch7","C",TAMSX3("F1_DOC")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"08","Documento Até       ?","Documento Até       ?","Documento Até       ?","mv_ch8","C",TAMSX3("F1_DOC")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","Emissão De          ?","Emissão De          ?","Emissão De          ?","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"10","Emissão Até         ?","Emissão Até         ?","Emissão Até         ?","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"11","Diretório Destino   ?","Diretório Destino   ?","Diretório Destino   ?","mv_chb","C",60,0,0,"G","","mv_par11","","","","c:\","","","","","","","","","","","","","","","","","","","","", "","","",""})
                                 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Help de cada item do Grupo de Perguntas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next  
	
Return Nil