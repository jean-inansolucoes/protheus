#include "rwmake.ch"     
#include "protheus.ch" 
#include "topconn.ch"

user function MA330TRB()

Local aArea      := GetArea()

DbSelectArea("TRB")
TRB->(DbGoTop())
While TRB->(!EOF())

	If TRB->TRB_CF=="REA"  .OR. TRB->TRB_CF=="DEA"
		RecLock('TRB',.F.)
			TRB->TRB_ORDEM := '299'
		MsUnlock('TRB')
	Endif
	
	TRB->( dbSkip() )
EndDo

RestArea(aArea)

Return
