#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LTCAD004    ºAutor  ³JEAN P ROSSETTO   º Data ³  16/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ AMARRACAO PRODUTOR X EQUIPAMENTO                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TOTVS LATICINIO                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LTCAD004()

aRotina := {{ "Pesquisar" ,"AxPesqui", 0 , 1},;
{ "Visualiza" ,"U_LTCADZL4('VISUALIZAR')", 0 , 2},;
{ "Alterar"   ,"U_LTCADZL4('ALTERAR')", 0 , 4, 20 }}

cCadastro := "Amarracao Equipamentos x Produtor"
dbSelectArea("SA2")
dbSetOrder(1)
SET FILTER TO SA2->A2_X_TIPO == 'P'
dbGoTop()                         
mBrowse(6, 1, 22, 75, "SA2",,,,,,)

Return

User Function LTCADZL4(cOpcao)
Local _nI, I

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
dbSeek("ZL4")
aHeader:={}
While !Eof().And.(x3_arquivo=="ZL4")
	If Alltrim(x3_campo)$"ZL4_FILIAL/ZL4_COD/ZL4_LOJA/ZL4_SEQ/ZL4_NOME"
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
dbSelectArea("ZL4")
dbSetOrder(1)
IF dbSeek(xFilial("ZL4")+M->A2_COD+M->A2_LOJA)
	While !eof() .and. ZL4->ZL4_FILIAL+ZL4->ZL4_COD+ZL4->ZL4_LOJA == xFilial("ZL4")+M->A2_COD+M->A2_LOJA
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
		aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
ENDIF

cTitulo       :="Equipamento x Produtor"
cAliasEnchoice:="SA2"
cAliasGetD    :="ZL4"      
cLinOk        :="AllwaysTrue()"
cTudOk        :="AllwaysTrue()"
cFieldOk      :="AllwaysTrue()"
aCpoEnchoice:={"A2_COD","A2_LOJA","A2_NOME","A2_NREDUZ","A2_END","A2_EST","A2_MUN","A2_TIPO"}

_lRet         :=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,2,nOpcG,cFieldOk)
If _lRet
	IF ALLTRIM(cOpcao) == "EXCLUIR"
		
		cCodA2 := M->A2_CODIGO
		cLojA2 := M->A2_LOJA
	
		dbSelectArea("ZL4")
		dbSetOrder(1)
		dbGoTop()
		IF dbSeek(xFilial("ZL4")+cCodA2+cFilA2)
			WHILE !EOF() .AND. xFilial("ZL4")+cCodA2+cFilA2 == ZL4->ZL4_FILIAL+ZL4->ZL4_COD+ZL4->ZL4_LOJA
				RecLock("ZL4")
				dbDelete()
				MsUnLock()
				dbSkip()
			ENDDO
		ENDIF
		
	ELSE
		
		nP1   := aScan(aHeader,{|x| Alltrim(x[2])=="ZL4_EQUIP"})
		nP2   := aScan(aHeader,{|x| Alltrim(x[2])=="ZL4_DESC"})
	    //QUANDO HOUVER JA REGISTRO E HAVER ALTERACAO, SEMPRE DELETA TODOS E INCLUI NOVAMENTE
		dbSelectArea("ZL4")
		dbSetOrder(1)
		dbGoTop()
		IF dbSeek(XFILIAL("ZL4")+M->A2_COD+M->A2_LOJA)
			RecLock("ZL4")
			dbDelete()
			MsUnLock()
			dbSkip()
		ENDIF

		nGrvAcols := 1
		FOR I := 1 TO LEN(aCols)
			IF aCols[I,LEN(aCols[I])] == .f.
				RecLock("ZL4", .T.)
				Replace ZL4_FILIAL   With xFilial("ZL4")
				Replace ZL4_COD      With M->A2_COD
				Replace ZL4_LOJA     With M->A2_LOJA
				Replace ZL4_NOME     With M->A2_NOME
				Replace ZL4_SEQ      With STRZERO(nGrvAcols,3)
				Replace ZL4_EQUIP    With aCols[I,nP1]
				Replace ZL4_DESC     With aCols[I,nP2]
				MsUnLock("ZL4")
				nGrvAcols++
			ENDIF
		NEXT I
	
	ENDIF 
Endif
Return
