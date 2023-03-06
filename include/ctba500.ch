#ifdef SPANISH
	#define STR0001 "Contabilidad de archivos TXT"
	#define STR0002 "  El  objetivo  de  este  programa  es  generar  los  asientos contables"
	#define STR0003 "Off Line con datos importados de otras fuentes."
#else
	#ifdef ENGLISH
		#define STR0001 "TXT File Accounting     "
		#define STR0002 "  The purpose of this program is to generate the Offline Ledger "
		#define STR0003 "Entries with data imported from other sources. "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Contabilização De Ficheiros De Texto", "Contabilizacao de Arquivos TXT" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "  O objetivo deste programa é o de criar lançamentos contabilísticos", "  O  objetivo  deste programa  e  o  de  gerar  lancamentos  contabeis" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A partir do ficheiro de texto importado de outros sistemas.", "a partir de arquivo texto importados de outros sistemas." )
	#endif
#endif
