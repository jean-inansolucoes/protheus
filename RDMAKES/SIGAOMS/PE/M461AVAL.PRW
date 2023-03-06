#include 'protheus.ch'
#include 'parmtype.ch'
 
User Function M461AVAL()
***********************
Local lRet := .T.


If DAK->DAK_BLQCAR == '1'
	lRet := .F.
Endif

Return( lRet )
