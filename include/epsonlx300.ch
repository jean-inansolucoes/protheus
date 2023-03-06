	#define Draft          chr(27)+'x'+'0'     // Modo Draft 
	#define NLQ            chr(27)+'x'+'1'     // Modo NLQ 
	#define NLQRoman       chr(27)+'k'+'0'     // Fonte NLQ "Roman" 
	#define NLQSansSer     chr(27)+'k'+'1'     // Fonte NLQ "SansSerif" 
	#define cpp10          chr(27)+'P'         // Espaçamento horizontal em 10cpp 
	#define cpp12          chr(27)+'M'         // Espaçamento horizontal em 12cpp 
	#define CondenOn       chr(15)             // Ativa o modo condensado 
	#define CondenOff      chr(18)             // Desativa o modo condensado 
	#define LargeOn        chr(27)+'W'+'1'     // Ativa o modo expandido 
	#define LargeOff       chr(27)+'W'+'0'     // Desativa o modo expandido 
	#define BoldOn         chr(27)+'E'         // Ativa o modo negrito 
	#define BoldOff        chr(27)+'F'         // Desativa o modo negrito 
	#define ItalicOn       chr(27)+'4'         // Ativa o modo itálico 
	#define ItalicOff      chr(27)+'5'         // Desativa o modo itálico 
	#define UnderlnOn      chr(27)+'-'+'1'     // Ativa o modo sublinhado 
	#define UnderlnOff     chr(27)+'-'+'0'     // Desativa o modo sublinhado 
	#define DblStrkOn      chr(27)+'G'         // Ativa o modo de passada dupla 
	#define DblStrkOff     chr(27)+'H'         // Desativa o modo de passada dupla 
	#define UpScriptOn     chr(27)+'S1'         // Ativa o modo sobrescrito 
	#define DnScriptOn     chr(27)+'S0'         // Ativa o modo subescrito 
	#define ScriptOff      chr(27)+'T'         // Desativa os modos sobrescrito e subescrito 
	
//{ Controle de página } 
	#define lpp6           chr(27)+'2'         // Espaçamento vertical de 6 linhas por polegada 
	#define lpp8           chr(27)+'0'         // Espaçamento vertical de 8 linhas por polegada 
	#define MargLeft       chr(27)+'l'+?       // Margem esquerda, onde "?" Margem 
	#define MargRight      chr(27)+'Q'+?       // Margem direita, onde "?" Margem 
	#define PaperSize      chr(27)+'C'+?       // Tamanho da página, onde "?" Linhas 
	#define NewPgOn        chr(27)+'N'+?       // Ativa o salto sobre o picote, onde "?" Linhas 
	#define NewPgOff       chr(27)+'O'         // Desativa o salto sobre o picote 
	
	// uso demapal
	#define PaperSzEsp     Chr(27)+Chr(67)+Chr(34)
	#define PaperNrm       Chr(27)+Chr(67)+Chr(66)
	#define StartPrint     chr(27)+'@'         // Inicializa a impressora
	
// { Controle da impressora } 
	#define LF             chr(10)             // Avança uma linha 
	#define FF             chr(12)             // Avança uma página 
	#define CR             chr(13)             // Retorno do carro
	
	#define INICABEC    Chr(27)+Chr(01)+Chr(01)
	#define FIMCABEC    Chr(27)+Chr(01)+Chr(02)
	#define INIFIELD    Chr(27)+Chr(02)+Chr(01)
	#define FIMFIELD    Chr(27)+Chr(02)+Chr(02)
	#define INIRODA     Chr(27)+Chr(03)+Chr(01)
	#define FIMRODA     Chr(27)+Chr(03)+Chr(02)
	#define INIPARAM    Chr(27)+Chr(04)+Chr(01)
	#define FIMPARAM    Chr(27)+Chr(04)+Chr(02)
	#define INITHINLINE Chr(27)+Chr(05)+Chr(01)
	#define FIMTHINLINE Chr(27)+Chr(05)+Chr(02)
	#define INIFATLINE  Chr(27)+Chr(06)+Chr(01)
	#define FIMFATLINE  Chr(27)+Chr(06)+Chr(02)
	#define INICENTER   Chr(27)+Chr(07)+Chr(01)
	#define FIMCENTER   Chr(27)+Chr(07)+Chr(02)
	#define INIRIGHT    Chr(27)+Chr(09)+Chr(01)
	#define FIMRIGHT    Chr(27)+Chr(09)+Chr(02)
	#define INILEFT     Chr(27)+Chr(11)+Chr(01)
	#define FIMLEFT     Chr(27)+Chr(11)+Chr(02)
	#define INILOGO     Chr(27)+Chr(14)+Chr(01)
	#define FIMLOGO     Chr(27)+Chr(14)+Chr(02)
	#define INIBORDER   Chr(27)+Chr(16)+Chr(01)
	#define FIMBORDER   Chr(27)+Chr(16)+Chr(02)
	
// Constantes para identificar o tipo de impressão.
	#define IMP_DISCO 1
	#define IMP_SPOOL 2
	#define IMP_PORTA 3
	#define IMP_EMAIL 4

	#define AMB_SERVER 1
	#define AMB_CLIENT 2
	