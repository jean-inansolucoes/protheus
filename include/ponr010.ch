#ifdef SPANISH
	#define STR0001 "Registro del reloj"
	#define STR0002 "Se imprimira de acuerdo con los parametros solicitados por el"
	#define STR0003 "usuario."
	#define STR0004 "Matricula"
	#define STR0005 "Centro de costo"
	#define STR0006 "Nombre"
	#define STR0007 "Turno"
	#define STR0008 "A Rayas"
	#define STR0009 "Administracion"
	#define STR0013 "Firma del empleado"
	#define STR0014 "T O T A L E S"
	#define STR0015 "Cod Descripcion              Calc.            Cod Descripcion              Calc.          "
	#define STR0016 "Cod Descripcion                       Infor.  Cod Descripcion                       Infor."
	#define STR0017 "Cod Descripcion              Calc.    Infor.  Cod Descripcion              Calc.    Infor."
	#define STR0018 "** Excepcion no Trabajada **"
	#define STR0019 "** Feriado **"
	#define STR0020 "** Ausente **"
	#define STR0021 "** D.S.R. **"
	#define STR0022 "** Compensado **"
	#define STR0023 "** No Trabajado **"
	#define STR0024 "Emp...: "
	#define STR0025 " Matr..: "
	#define STR0026 "  Placa : "
	#define STR0027 "Direc.: "
	#define STR0028 " Nombr.: "
	#define STR0029 "Num Contr:"
	#define STR0030 " Funcion:"
	#define STR0031 "C.C...: "
	#define STR0032 " Categ.: "
	#define STR0033 "Turno.: "
	#define STR0034 "   FECHA   DIA     "
	#define STR0035 "a E. "
	#define STR0036 "a S. "
	#define STR0037 "Motivo de Abono           Horas  Tipo da marcacion"
	#define STR0038 "C.Costo + Nombre"
	#define STR0039 "Periodo de apunte no valido."
	#define STR0040 "Consultar marcaciones"
	#define STR0041 "Motivo de abono"
	#define STR0042 "Fecha"
	#define STR0043 "Dia"
	#define STR0044 "&#170;E."
	#define STR0045 "&#170;S."
	#define STR0046 "Observaciones"
	#define STR0047 "Horas  Tipo de marcacion"
	#define STR0048 "Turno "
	#define STR0049 "Turnos: "
	#define STR0050 "Proceso + Matricula"
	#define STR0051 "Depto.: "
	#define STR0052 "Seleccione la opcion de impresion: "
	#define STR0053 "Por Periodo"
	#define STR0054 "Por Fechas"
	#define STR0055 "Proceso: "
	#define STR0056 "Periodo: "
	#define STR0057 "Procedim.: "
	#define STR0058 "Num.Pago: "
#else
	#ifdef ENGLISH
		#define STR0001 "Time Accounting Report"
		#define STR0002 "It will be printed according to the parameters selected "
		#define STR0003 "by the User."
		#define STR0004 "Registr."
		#define STR0005 "Cost Center"
		#define STR0006 "Name"
		#define STR0007 "Shift"
		#define STR0008 "Z.Form"
		#define STR0009 "Management"
		#define STR0013 "Employee signature"
		#define STR0014 "T O T A L S"
		#define STR0015 "Cod Descript.                Calc.            Cod Descript.                Calc.          "
		#define STR0016 "Cod Descript.                         Infor.  Cod Descript.                         Infor."
		#define STR0017 "Cod Descript.                Calc.    Infor.  Cod Descript.                Calc.    Infor."
		#define STR0018 "** Except. not Worked **"
		#define STR0019 "** Holiday **"
		#define STR0020 "** Absent **"
		#define STR0021 "** D.S.R. **"
		#define STR0022 "** Compensat. **"
		#define STR0023 "** Not Worked **"
		#define STR0024 "Com...: "
		#define STR0025 " Reg..: "
		#define STR0026 "  Plate : "
		#define STR0027 "Add...: "
		#define STR0028 " Name..: "
		#define STR0029 "CGC...: "
		#define STR0030 " Funct.: "
		#define STR0031 "C.C...: "
		#define STR0032 " Categ.: "
		#define STR0033 "Shift.: "
		#define STR0034 "   DATE    DAY     "
		#define STR0035 "to I. "
		#define STR0036 "to O. "
		#define STR0037 "Note                      Hours  Mark Type        "
		#define STR0038 "C.Cent. + Name"
		#define STR0039 "Invalid Annotation Period."
		#define STR0040 "Browse Anotations"
		#define STR0041 "Bonus Reason"
		#define STR0042 "Date"
		#define STR0043 "Day"
		#define STR0044 "&#170;I."
		#define STR0045 "&#170;O."
		#define STR0046 "Observations"
		#define STR0047 "Hours  Mark Type"
		#define STR0048 "Shift "
		#define STR0049 "Shifts: "
		#define STR0050 "Process + Registration"
		#define STR0051 "Dep.: "
		#define STR0052 "Select the printing option: "
		#define STR0053 "By Period"
		#define STR0054 "By Dates"
		#define STR0055 "Process: "
		#define STR0056 "Period: "
		#define STR0057 "Procedure: "
		#define STR0058 "Paym. Nbr.: "
	#else
		Static STR0001 := "Espelho do Ponto"
		Static STR0002 := "Ser� impresso de acordo com os parametros solicitados pelo"
		Static STR0003 := "usuario."
		Static STR0004 := "Matricula"
		Static STR0005 := "Centro de Custo"
		#define STR0006  "Nome"
		#define STR0007  "Turno"
		Static STR0008 := "Zebrado"
		Static STR0009 := "Administra��o"
		Static STR0013 := "Assinatura do Funcionario"
		#define STR0014  "T O T A I S"
		Static STR0015 := "Cod Descricao                Calc.            Cod Descricao                Calc.          "
		Static STR0016 := "Cod Descricao                         Infor.  Cod Descricao                         Infor."
		Static STR0017 := "Cod Descricao                Calc.    Infor.  Cod Descricao                Calc.    Infor."
		Static STR0018 := "** Excecao nao Trabalhada **"
		Static STR0019 := "** Feriado **"
		Static STR0020 := "** Ausente **"
		Static STR0021 := "** D.S.R. **"
		Static STR0022 := "** Compensado **"
		Static STR0023 := "** Nao Trabalhado **"
		Static STR0024 := "Emp...: "
		Static STR0025 := " Matr..: "
		Static STR0026 := "  Chapa : "
		Static STR0027 := "End...: "
		#define STR0028  " Nome..: "
		Static STR0029 := "CGC...: "
		Static STR0030 := " Funcao: "
		Static STR0031 := "C.C...: "
		#define STR0032  " Categ.: "
		Static STR0033 := "Turno.: "
		#define STR0034  "   DATA    DIA     "
		Static STR0035 := "a E. "
		Static STR0036 := "a S. "
		Static STR0037 := "Observacao                Horas  Tipo da Marcacao"
		Static STR0038 := "C.Custo + Nome"
		Static STR0039 := "Periodo de Apontamento Invalido."
		Static STR0040 := "Consultar Marca&ccedil;&otilde;es"
		Static STR0041 := "Motivo de Abono"
		#define STR0042  "Data"
		#define STR0043  "Dia"
		Static STR0044 := "&#170;E."
		Static STR0045 := "&#170;S."
		Static STR0046 := "Observa&ccedil;&otilde;es"
		Static STR0047 := "Horas  Tipo da Marca&ccedil;&atilde;o"
		Static STR0048 := "Turno "
		Static STR0049 := "Turnos: "
		Static STR0050 := "Processo + Matr�cula"
		#define STR0051  "Depto.: "
		Static STR0052 := "Selecione a op��o de impress�o: "
		#define STR0053  "Por Per�odo"
		#define STR0054  "Por Datas"
		#define STR0055  "Processo: "
		#define STR0056  "Per�odo: "
		Static STR0057 := "Roteiro: "
		Static STR0058 := "Num.Pagto: "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Espelho Do Ponto"
			STR0002 := "Ser� impresso de acordo com os par�metros solicitados pelo"
			STR0003 := "Utilizador."
			STR0004 := "Registo"
			STR0005 := "Centro De Custo"
			STR0008 := "C�digo de barras"
			STR0009 := "Administra��o"
			STR0013 := "Assinatura do Empregado"
			STR0015 := "C�d descri��o                c�lc.            c�d descri��o                c�lc.          "
			STR0016 := "C�d Descri��o                         Infor.  C�d Descri��o                         Infor."
			STR0017 := "C�d Descri��o                C�lc.    Infor.  C�d Descri��o                C�lc.    Infor."
			STR0018 := "** excep��o n�o trabalhada **"
			STR0019 := "** feriado **"
			STR0020 := "** ausente **"
			STR0021 := "** d.s.r. **"
			STR0022 := "** Compensado"
			STR0023 := "** n�o trabalhado **"
			STR0024 := "Emp.:"
			STR0025 := "Reg.:"
			STR0026 := "  Cart�o Reg.: "
			STR0027 := "Morada:"
			STR0029 := "NIF"
			STR0030 := " fun��o: "
			STR0031 := "C.c.:"
			STR0033 := "Turno:"
			STR0035 := "A.e."
			STR0036 := "A s. "
			STR0037 := "Observa��o  Horas  Tipo Da Marca��o"
			STR0038 := "C.custo + Nome"
			STR0039 := "Per�odo De Apontamento Inv�lido."
			STR0040 := "Consultar Marca��es"
			STR0041 := "Motivo De Autoriza��o"
			STR0044 := "&#170;e."
			STR0045 := "&#170;s."
			STR0046 := "Observa&��e&s"
			STR0047 := "Horas   Tipo Da Marca&��&o"
			STR0048 := "Turno"
			STR0049 := "Turnos:"
			STR0050 := "Processo + registo"
			STR0052 := "Seleccionar a op��o  de impressao: "
			STR0057 := "Mapa: "
			STR0058 := "Num.pgt: "
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Espelho Do Ponto"
			STR0002 := "Ser� impresso de acordo com os par�metros solicitados pelo"
			STR0003 := "Utilizador."
			STR0004 := "Registo"
			STR0005 := "Centro De Custo"
			STR0008 := "C�digo de barras"
			STR0009 := "Administra��o"
			STR0013 := "Assinatura do Empregado"
			STR0015 := "C�d descri��o                c�lc.            c�d descri��o                c�lc.          "
			STR0016 := "C�d Descri��o                         Infor.  C�d Descri��o                         Infor."
			STR0017 := "C�d Descri��o                C�lc.    Infor.  C�d Descri��o                C�lc.    Infor."
			STR0018 := "** excep��o n�o trabalhada **"
			STR0019 := "** feriado **"
			STR0020 := "** ausente **"
			STR0021 := "** d.s.r. **"
			STR0022 := "** Compensado"
			STR0023 := "** n�o trabalhado **"
			STR0024 := "Emp.:"
			STR0025 := "Reg.:"
			STR0026 := "  Cart�o Reg.: "
			STR0027 := "Morada:"
			STR0029 := "NIF"
			STR0030 := " fun��o: "
			STR0031 := "C.c.:"
			STR0033 := "Turno:"
			STR0035 := "A.e."
			STR0036 := "A s. "
			STR0037 := "Observa��o  Horas  Tipo Da Marca��o"
			STR0038 := "C.custo + Nome"
			STR0039 := "Per�odo De Apontamento Inv�lido."
			STR0040 := "Consultar Marca��es"
			STR0041 := "Motivo De Autoriza��o"
			STR0044 := "&#170;e."
			STR0045 := "&#170;s."
			STR0046 := "Observa&��e&s"
			STR0047 := "Horas   Tipo Da Marca&��&o"
			STR0048 := "Turno"
			STR0049 := "Turnos:"
			STR0050 := "Processo + registo"
			STR0052 := "Seleccionar a op��o  de impressao: "
			STR0057 := "Mapa: "
			STR0058 := "Num.pgt: "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF