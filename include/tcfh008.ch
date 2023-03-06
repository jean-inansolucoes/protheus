#ifdef SPANISH
	#define STR0001 "Protheus - RR.HH. On-line"
	#define STR0002 "Consultar Apuntes"
	#define STR0003 "Periodo de apunte:"
#else
	#ifdef ENGLISH
		#define STR0001 "Protheus - HR Online"
		#define STR0002 "Query Annotations"
		#define STR0003 "Annotation Period:"
	#else
		Static STR0001 := "Protheus - RH Online"
		Static STR0002 := "Consultar Marca&ccedil;&otilde;es"
		Static STR0003 := "Per&iacute;odo de apontamento:"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Protheus - Rh Online"
			STR0002 := "Consultar Marcações"
			STR0003 := "Período de apontamento:"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
