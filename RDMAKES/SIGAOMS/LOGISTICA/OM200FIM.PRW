#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"
#INCLUDE "RWMAKE.CH"




// FONTE QUE CONTEM OS PONTOS DE ENTRADA DA ROTINA OMSALLIN.PRW
User Function OM200FIMT()

 cQuery    :=  ""
 hEnter    := Chr( 13 )
 cAliasSC9 := GetNextAlias( )
 lFirst    := .T.
 lNew      := .F.
 lAssVeic	:= .F.
 cCodSimul	:= ""
 _aCli		:= {}

 cCarga   := ""
 cSeqCar  := ""

 cCarga   := DAK->DAK_COD
 cSeqCar  := DAK->DAK_SEQCAR


//MsgInfo("Ponto de entrada OM200FIMT ", "TESTE")

//MsgInfo("Opa chegou aqui OS200MOT - 01 ", "TESTE")
If ISINCALLSTACK( 'OMSA200' )	
      CursorWait()
	SysRefresh()
	
    /// libera carga
	OsAvalDAK( "DAK", 12 )
	
	cQuery := "SELECT SC9.*,"                                 +       hEnter
	cQuery += "       SC9.R_E_C_N_O_ RECSC9 "                 +       hEnter
	cQuery += "  FROM " + RetSqlName( "SC9" ) + " SC9 "       +       hEnter
	cQuery += " WHERE SC9.C9_FILIAL   = '" + xFilial( "SC9" ) + "'" + hEnter
	cQuery += "   AND SC9.C9_CARGA    = '" + DAK->DAK_COD     + "'" + hEnter
	cQuery += "   AND SC9.C9_SEQCAR   = '" + DAK->DAK_SEQCAR  + "'" + hEnter
	cQuery += "   AND SC9.D_E_L_E_T_ <> '*'"                  +       hEnter
	cQuery += "ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM"           +       hEnter
	
	//MemoWrite( cPathExtras + ProcName() + ".SQL", cQuery)
	
	If Select( cAliasSC9 ) > 0
		( cAliasSC9 )->( dBclosearea( ) )
	Endif
	
	cQuery := ChangeQuery(cQuery)
	
	dBUseArea(.T.,"TOPCONN",TCGENQRY(,, cQuery ),cAliasSC9,.F.,.T.)
	

	( cAliasSC9 )->( dBGoTop( ) )
	While !( cAliasSC9 )->( Eof( ) )
	      SC9->( dBGoTop( ) )
	      SC9->( dBGoTo( ( cAliasSC9 )->RECSC9 ) )
	      
		
		if !lAssVeic .and. !Empty(( cAliasSC9 )->C9_X_SIMUL)
			lAssVeic := .T.	
			cCodSimul := ( cAliasSC9 )->C9_X_SIMUL
		endif
		
		( cAliasSC9 )->( dBSkip( ) )
	Enddo
	
	If Select( cAliasSC9 ) > 0
		( cAliasSC9 )->( dBclosearea( ) )
	Endif

	//Realiza associacao do veiculo
	if lAssVeic
     // MsgAlert("Chama Associa veiculo ("+ cCarga +" | "+ cSeqCar +")", "ATENÇÃO")
		ASSVEIC(cCodSimul, cCarga,  cSeqCar )
	endif
	
Endif

Return ( NIL )




/*/{Protheus.doc} ASSVEIC
	Associacao veiculo
	@type  Static Function
	@author user
	@since 10/01/2022
	@version 1.0
/*/
Static Function ASSVEIC(cSimula,cCarga, cSeqcar)
	Local aArea		:= GetArea()
	Local cGetVei   := ""
	Local cGetMot   := ""

	DbSelectArea("ZN1")
	ZN1->(DbSetOrder(1))
	ZN1->(dbGoTop())
	if dbSeek(xFilial("ZN1")+cSimula)
	 
	  cGetVei := ZN1->ZN1_VEICUL 
	  cGetMot := ZN1->ZN1_MOTORI
	endif


     //MsgAlert("Associa Veiculo procurando por carga  ("+ cCarga +" | "+ cSeqCar +") dados ("+cGetVei+"|"+cGetMot+")", "ATENÇÃO")
    DbSelectArea("DAK")
	DAK->(DbSetOrder(1))
	DAK->(dbGoTop())
	If DAK->(DbSeek( xFilial('DAK')+ cCarga + cSeqcar ))
            //Fazer algo aqui
    Endif
    If RecLock('DAK',.F.)
       //Alterar algo aqui
	   DAK->DAK_CAMINH := cGetVei
	   DAK->DAK_MOTORI := cGetMot
       DAK->(MsUnlock())
   Endif
	
	RestArea(aArea)
Return 
