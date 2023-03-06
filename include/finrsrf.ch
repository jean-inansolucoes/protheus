#ifdef SPANISH
	#define STR0001 "Procesando - DARF"
	#define STR0002 "Mensaje"
	#define STR0003 "No existen datos en el periodo informado"
	#define STR0004 "OK"
#else
	#ifdef ENGLISH
		#define STR0001 "Processing - DARF"
		#define STR0002 "Message"
		#define STR0003 "There are no data within the period informed"
		#define STR0004 "Ok"
	#else
		#define STR0001 "Processando - DARF"
		#define STR0002 "Mensagem"
		#define STR0003 "Nao há dados no periodo informado"
		#define STR0004 "Ok"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
