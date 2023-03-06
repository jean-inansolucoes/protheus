User Function GP690SAL()
*************************
Local lRet 	:= .T.
Local dDiss := ctod(GetMv("MV_DTDISS"))

If (SR3->R3_DATA == dDiss .AND. SR3->R3_SEQ == "2") .OR. SR3->R3_DATA > dDiss
	lRet 	:= .F.
EndIf
                                                                                                                                                                                                                                              
Return( lRet )
