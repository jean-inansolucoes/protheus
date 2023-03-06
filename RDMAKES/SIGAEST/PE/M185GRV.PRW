/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M185GRV  ºAutor  ³Joel Lipnharski     º Data ³  04/01/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de moviment. interna estorno na tabela SD3 quando  º±±
±±º          ³ o campo Armazem de Destino - CP_X_LOC estiver preenchido.  º±±
±±º          ³ Utilizado para transferir o material para outro almox.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M185GRV()
	/*
	Local cTPMov  := GETMV("MV_SD3INC") //Cod. Movimentacao inclusao
	Local cProd   := SD3->D3_COD
	Local cUnd    := SD3->D3_UM
	Local cLoc    := SCP->CP_X_LOC
	Local nQtd    := SD3->D3_QUANT
	Local dEmis   := SD3->D3_EMISSAO
	Local nCusto  := SD3->D3_CUSTO1
	Local cCC     := SD3->D3_CC
	Local cConta  := SD3->D3_CONTA
	Local cNumSeq := SD3->D3_NUMSEQ
	Local cObs    := "INCLUIDO AUTOMATICAMENTE - REQUISICAO ARMAZEM."

	Local aVetSD3 := {}
	Local aVetCab := {}
	Local aVetItem:= {}

	Local RegSD3  := SD3->( Recno() )
	Local RegSCP  := SCP->( Recno() )
	Local aArea   := GetArea()

	Private lMsErroAuto := .F.
	
	If POSICIONE("SB1", 1, xFilial("SB1") + cProd, "B1_APROPRI ") <> 'I'
		If ISINCALLSTACK("A185Gera") //Modelo 1

			If !Empty(SCP->CP_X_LOC)

				Begin Transaction

					aadd( aVetSD3,{"D3_TM"     ,cTPMov ,Nil} )
					aadd( aVetSD3,{"D3_COD"    ,cProd  ,Nil} )
					aadd( aVetSD3,{"D3_UM"     ,cUnd   ,Nil} )
					aadd( aVetSD3,{"D3_LOCAL"  ,cLoc   ,Nil} )
					aadd( aVetSD3,{"D3_QUANT"  ,nQtd   ,Nil} )
					aadd( aVetSD3,{"D3_EMISSAO",dEmis  ,Nil} )
					aadd( aVetSD3,{"D3_CUSTO1" ,nCusto ,Nil} )
					aadd( aVetSD3,{"D3_CC"     ,cCC    ,Nil} )
					aadd( aVetSD3,{"D3_CONTA"  ,cConta ,Nil} )
					aadd( aVetSD3,{"D3_X_OBS"  ,cObs   ,Nil} )
					aadd( aVetSD3,{"D3_X_DOC"  ,cNumSeq,Nil} )

					MSExecAuto({|x,y| mata240(x,y)},aVetSD3,3)

				End Transaction

			EndIf

		ElseIf ISINCALLSTACK("A185GeraAut")  //Modelo 2

			If !Empty(SCP->CP_X_LOC)

				Begin Transaction

					aVetCab :={{"D3_TM"         ,cTPMov  ,NIL},;
						{"D3_CC"          ,cCC     ,NIL},;
						{"D3_EMISSAO"     ,dEmis   ,NIL}}

					aAdd(aVetItem,{{"D3_COD"    ,cProd   ,NIL},;
						{"D3_UM"      ,cUnd    ,NIL},;
						{"D3_LOCAL"   ,cLoc    ,NIL},;
						{"D3_QUANT"   ,nQtd    ,NIL},;
						{"D3_CUSTO1"  ,nCusto  ,NIL},;
						{"D3_X_OBS"   ,cObs    ,Nil},;
						{"D3_X_DOC"   ,cNumSeq ,NIL}})

					MSExecAuto({|x,y,z| MATA241(x,y,z)},aVetCab,aVetItem,3)

				End Transaction

			EndIf

		EndIf

		If lMsErroAuto
			MostraErro()
		EndIf
	EndIf
	dbSelectArea("SD3")
	SD3->(dbGoto(RegSD3))

	dbSelectArea("SCP")
	SCP->(dbGoto(RegSCP))

	RestArea(aArea)

	dbSelectArea("SD3")
	DbSetOrder(4)
	*/
Return()
