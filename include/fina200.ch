#ifdef SPANISH
	#define STR0001 "Parametros"
	#define STR0002 "Visualizar"
	#define STR0003 "Recibir archivo"
	#define STR0004 "Salir"
	#define STR0005 "Confirmar"
	#define STR0006 "Comunic.bancaria retorno"
	#define STR0007 "Comun.bancaria retorno"
	#define STR0008 "�Recepciona? "
	#define STR0009 "Seleccionando registros..."
	#define STR0010 "Valor cobrado s/ titulo"
	#define STR0011 "Cancel.Ret. CBE. Lote"
	#define STR0012 "��Atencion!!"
	#define STR0013 "No fue posible abrir el archivo TB"
	#define STR0014 ".VRF, �Desea intentar nuevamente ?"
	#define STR0015 "El modulo Contabilidad esta en modo exclusivo, sin embargo se solicito el procesamiento de todas las sucursales. En este caso, el sistema no realiza la contabilidad online. �Confirma aun asi?"
#else
	#ifdef ENGLISH
		#define STR0001 "Parameters"
		#define STR0002 "View"
		#define STR0003 "Receive File"
		#define STR0004 "Quit"
		#define STR0005 "Ok  "
		#define STR0006 "Return-Bank Communication   "
		#define STR0007 "Return-Bank Communicat."
		#define STR0008 "  About reception ?   "
		#define STR0009 "Selecting Records...     "
		#define STR0010 "Value received w/o  Bill  "
		#define STR0011 "Post Ret. EDTB Lot "
		#define STR0012 "Attention !!!"
		#define STR0013 "Unable to open TB file"
		#define STR0014 ".VRF. Do you want to try again ?"
		#define STR0015 "Accounting is in exclusive mode and all branches will be processed. In this situation, on-line accounting is not calculated. Confirm it anyway?"
	#else
		Static STR0001 := "Parametros"
		#define STR0002  "Visualizar"
		Static STR0003 := "Receber Arquivo"
		Static STR0004 := "Abandona"
		#define STR0005  "Confirma"
		Static STR0006 := "Comunica��o Banc�ria-Retorno"
		Static STR0007 := "Comun.Banc�ria-Retorno"
		Static STR0008 := "  Quanto � recep��o ? "
		Static STR0009 := "Selecionando Registros..."
		Static STR0010 := "Valor recebido s/ Titulo"
		Static STR0011 := "Baixa Ret. CNAB. Lote"
		Static STR0012 := "Atencao !!!"
		Static STR0013 := "Nao foi possivel abrir o arquivo TB"
		Static STR0014 := ".VRF, Deseja tentar novamente ?"
		#define STR0015  "A Contabilidade est� em modo exclusivo e foi solicitado o processamento de todas as filiais. Neste caso, o sistema n�o realiza a contabiliza��o on-line. Confirma mesmo assim?"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Par�metros"
			STR0003 := "Receber Ficheiro"
			STR0004 := "Abandonar"
			STR0006 := "Comunica��o Banc�ria-Retorno"
			STR0007 := "Comun.banc�ria-retorno"
			STR0008 := "  quanto � recep��o ? "
			STR0009 := "A Seleccionar Registos..."
			STR0010 := "Valor Recebido S/ T�tulo"
			STR0011 := "Liquida��o Ret. PS2 Lote"
			STR0012 := "Aten��o !!!"
			STR0013 := "N�o Foi Poss�vel Abrir O Ficheiro Tb"
			STR0014 := ".vrf, deseja tentar novamente ?"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
