#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "rwmake.ch"

User Function LTRETCC()
Local nx
Local aAllusers := FWSFALLUSERS({"000002"})

For nx := 1 To Len(aAllusers)
    conout(aAllusers[nx][4] + " -" + aAllusers[nx][5])
Next
Return