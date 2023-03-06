#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTCAD012 ºAutor  ³ALEXANDRE LONGHINOTTI º Data ³  17/08/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ AMARRACAO PRODUTOR X NFS DE PRODUTOR                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTCAD012()

aRotina := {{ "Pesquisar" ,"AxPesqui", 0 , 1},;
			{ "Visualiza" ,"U_LTCADZLJ('VISUALIZAR')", 0 , 2},;
			{ "Alterar"   ,"U_LTCADZLJ('ALTERAR')", 0 , 4, 20 }}

cCadastro := "Produtor x Faixa Numeração NFPR"
dbSelectArea("SA2")
dbSetOrder(1)
SET FILTER TO SA2->A2_X_TIPO == 'P'
dbGoTop()                         
mBrowse(6, 1, 22, 75, "SA2",,,,,,)

Return

User Function LTCADZLJ(cOpcao)
Local _ni, I
Do Case
	
	Case cOpcao=="ALTERAR"; nOpcE:=3 ; nOpcG:=3
	Case cOpcao=="VISUALIZAR"; nOpcE:=2 ; nOpcG:=2
EndCase

//dbSelectArea("SA2")
//RegToMemory("SA2",(cOpcao=="ALTERAR"))
RegToMemory( "SA2", .F., .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado:=0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZLJ")
aHeader:={}
While !Eof().And.(x3_arquivo=="ZLJ")
	If Alltrim(x3_campo)$"ZLJ_FILIAL/ZLJ_COD/ZLJ_LOJA/ZLJ_SEQ/ZLJ_NOME"
		dbSkip()
		Loop
	Endif
	nUsado:=nUsado+1
	Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
	x3_tamanho, x3_decimal,"AllwaysTrue()",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	dbSkip()
Enddo

aCols:={}
dbSelectArea("ZLJ")
dbSetOrder(1)
IF dbSeek(xFilial("ZLJ")+M->A2_COD+M->A2_LOJA)
	While !eof() .and. ZLJ->ZLJ_FILIAL+ZLJ->ZLJ_COD+ZLJ->ZLJ_LOJA == xFilial("ZLJ")+M->A2_COD+M->A2_LOJA
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
		aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
ENDIF

cTitulo       :="Faixa de Numeração NF Produtor"
cAliasEnchoice:="SA2"
cAliasGetD    :="ZLj"      
cLinOk        :="AllwaysTrue()"
cTudOk        :="AllwaysTrue()"
cFieldOk      :="AllwaysTrue()"
aCpoEnchoice:={"A2_COD","A2_LOJA","A2_NOME","A2_NREDUZ","A2_END","A2_EST","A2_MUN","A2_TIPO"}

_lRet         :=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,2,nOpcG,cFieldOk)
If _lRet
	IF ALLTRIM(cOpcao) == "EXCLUIR"
		
		cCodA2 := M->A2_CODIGO
		cLojA2 := M->A2_LOJA
	
		dbSelectArea("ZLJ")
		dbSetOrder(1)
		dbGoTop()
		IF dbSeek(xFilial("ZLJ")+cCodA2+cFilA2)
			WHILE !EOF() .AND. xFilial("ZLJ")+cCodA2+cFilA2 == ZLJ->ZLJ_FILIAL+ZLJ->ZLJ_COD+ZLJ->ZLJ_LOJA
				RecLock("ZLJ")
				dbDelete()
				MsUnLock()
				dbSkip()
			ENDDO
		ENDIF
		
	ELSE
		
		nP1   := aScan(aHeader,{|x| Alltrim(x[2])=="ZLJ_NUMNF"})
		nP2   := aScan(aHeader,{|x| Alltrim(x[2])=="ZLJ_SERIEP"})
		nP3   := aScan(aHeader,{|x| Alltrim(x[2])=="ZLJ_VALNF"})
		nP4   := aScan(aHeader,{|x| Alltrim(x[2])=="ZLJ_NFCOMP"})
		nP5   := aScan(aHeader,{|x| Alltrim(x[2])=="ZLJ_SERIEC"})
		nP6   := aScan(aHeader,{|x| Alltrim(x[2])=="ZLJ_EMISSA"})
	    //QUANDO HOUVER JA REGISTRO E HAVER ALTERACAO, SEMPRE DELETA TODOS E INCLUI NOVAMENTE
		dbSelectArea("ZLJ")
		dbSetOrder(1)
		dbGoTop()
		IF dbSeek(XFILIAL("ZLJ")+M->A2_COD+M->A2_LOJA)
			WHILE !EOF() .AND. xFilial("ZLJ")+M->A2_COD+M->A2_LOJA == ZLJ->ZLJ_FILIAL+ZLJ->ZLJ_COD+ZLJ->ZLJ_LOJA
				RecLock("ZLJ")
				dbDelete()
				MsUnLock()
				dbSkip()
			ENDDO
		ENDIF

		nGrvAcols := 1
		FOR I := 1 TO LEN(aCols)
			IF aCols[I,LEN(aCols[I])] == .f.
				RecLock("ZLJ", .T.)
				Replace ZLJ_FILIAL   With xFilial("ZLJ")
				Replace ZLJ_COD      With M->A2_COD
				Replace ZLJ_LOJA     With M->A2_LOJA
				Replace ZLJ_NOME     With M->A2_NOME
				Replace ZLJ_SEQ      With STRZERO(nGrvAcols,3)
				Replace ZLJ_NUMNF    With aCols[I,nP1]
				Replace ZLJ_SERIEP   With aCols[I,nP2]				
				Replace ZLJ_VALNF    With aCols[I,nP3]
				Replace ZLJ_NFCOMP   With aCols[I,nP4]
				Replace ZLJ_SERIEC   With aCols[I,nP5]				
				Replace ZLJ_EMISSA   With aCols[I,nP6]
				MsUnLock("ZLJ")
				nGrvAcols++
			ENDIF
		NEXT I
	
	ENDIF 
Endif
Return
