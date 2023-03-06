#ifdef SPANISH
	#define STR0001 "Matricula"
	#define STR0002 "Centro de Costo"
	#define STR0003 "Nombre"
	#define STR0004 "Emision de Etiqueta de Contrato de Trabajo. "
	#define STR0005 "Se imprimira segun los parametros solicitados por el"
	#define STR0006 "usuario."
	#define STR0007 "A Rayas"
	#define STR0008 "Administracion"
	#define STR0009 "EMISION ETIQUETA DE CONTRATO DE TRABAJO"
	#define STR0010 " POR MES"
	#define STR0011 " POR HRS"
	#define STR0012 " POR DIA"
	#define STR0013 "Remuneracion R$ "
	#define STR0014 " CNPJ "
	#define STR0015 "Esp. Establecimiento "
	#define STR0016 "CARGO "
	#define STR0017 "  CBO "
	#define STR0018 "Fecha Ingreso "
	#define STR0019 " de "
	#define STR0020 "Registro Nº  "
	#define STR0021 " Pgs./Ficha "
	#define STR0022 "Remuneracion R$ "
	#define STR0023 "SUC.: "
	#define STR0024 "MAT.:   "
	#define STR0025 "REG. PROF: "
	#define STR0026 "Fch Salida "
	#define STR0027 " de "
	#define STR0028 " POR SIN"
#else
	#ifdef ENGLISH
		#define STR0001 "Registration"
		#define STR0002 "Cost Center"
		#define STR0003 "Name"
		#define STR0004 "Print Work Contract Labels."
		#define STR0005 "It will be printed according to the parameters selected by the"
		#define STR0006 "user."
		#define STR0007 "Z.Form"
		#define STR0008 "Management"
		#define STR0009 "PRINT WORK CONTRACT LABELS"
		#define STR0010 " BY MONTH"
		#define STR0011 " BY HOUR"
		#define STR0012 " BY DAY"
		#define STR0013 "Salary R$ "
		#define STR0014 " CNPJ (National Corporate Taxpayer's Register) "
		#define STR0015 "Type of establishment "
		#define STR0016 "POSITION"
		#define STR0017 "  CBO "
		#define STR0018 "Admission Date "
		#define STR0019 " in "
		#define STR0020 "Record No. "
		#define STR0021 " Pgs./Form "
		#define STR0022 "Salary R$ "
		#define STR0023 "BCH.: "
		#define STR0024 "REGIST: "
		#define STR0025 "EMPL.BOOK: "
		#define STR0026 "Exit Date "
		#define STR0027 " in "
		#define STR0028 "FOR NOTHING"
	#else
		#define STR0001 "Matricula"
		#define STR0002 "Centro de Custo"
		#define STR0003 "Nome"
		#define STR0004 "Emissäo de Etiqueta de Contrato de Trabalho."
		#define STR0005 "Será impresso de acordo com os parametros solicitados pelo"
		#define STR0006 "usuario."
		#define STR0007 "Zebrado"
		#define STR0008 "Administraçäo"
		#define STR0009 "EMISSÄO ETIQUETA DE CONTRATO DE TRABALHO"
		#define STR0010 " POR MES"
		#define STR0011 " POR HRS"
		#define STR0012 " POR DIA"
		#define STR0013 "Remuneracao R$ "
		#define STR0014 " CNPJ "
		#define STR0015 "Esp. Estabelecimento "
		#define STR0016 "CARGO "
		#define STR0017 "  CBO "
		#define STR0018 "Data Admissao "
		#define STR0019 " de "
		#define STR0020 "Registro No. "
		#define STR0021 " Fls./Ficha "
		#define STR0022 "Remuneracao R$ "
		#define STR0023 "FIL.: "
		#define STR0024 "MATRIC: "
		#define STR0025 "CART.PROF: "
		#define STR0026 "Data Saida "
		#define STR0027 " de "
		#define STR0028 " POR SEM"
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
