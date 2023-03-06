#INCLUDE "PROTHEUS.CH"

//Função para criar regua de processamento.

User Function ACCXCLAS
Return .T.

Class ACCProgress

Data	bFuncProc	As 	Block
Data	cCaption	As	String
Data	lExtTaf  	As	Boolean

Data	c1ASayProc	As	String
Data	o1ASayProc	As 	Object
Data	c1BSayProc	As	String
Data	o1BSayProc	As 	Object

Data	c2ASayProc	As	String
Data	o2ASayProc	As 	Object
Data	c2BSayProc	As	String
Data	o2BSayProc	As 	Object

Data	c3ASayProc	As	String
Data	o3ASayProc	As 	Object
Data	c3BSayProc	As	String
Data	o3BSayProc	As 	Object

Data	c4ASayProc	As	String
Data	o4ASayProc	As 	Object
Data	c4BSayProc	As	String
Data	o4BSayProc	As 	Object

Data	c5ASayProc	As	String
Data	o5ASayProc	As 	Object
Data	c5BSayProc	As	String
Data	o5BSayProc	As 	Object


Data	c1DetLin	As	String
Data	o1DetSay	As	Object

Data	c1ValLin	As	String
Data	o11DetSay	As	Object

Data	c2DetLin	As	String
Data	o2DetSay	As	Object

Data	c2ValLin	As	String
Data	o22DetSay	As	Object

Data	c3DetLin	As	String
Data	o3DetSay	As	Object

Data	c3ValLin	As	String
Data	o33DetSay	As	Object

Data	c4DetLin	As	String
Data	o4DetSay	As	Object

Data	c4ValLin	As	String
Data	o44DetSay	As	Object

Data	c5DetLin	As	String
Data	o5DetSay	As	Object

Data	c5ValLin	As	String
Data	o55DetSay	As	Object

Data	oDlg 		As 	Object
Data	nWidth 		As	Integer
Data	nHeight 	As	Integer
Data	nAlign 		As	Integer
Data	o1Progress	As	Object
Data	n1TProgress	As	Integer
Data	n1IncPr		As	Integer
Data	o2Progress	As	Object
Data	n2TProgress	As	Integer
Data	n2IncPr		As	Integer
Data	o3Progress	As	Object
Data	n3TProgress	As	Integer
Data	n3IncPr		As	Integer
Data	o4Progress	As	Object
Data	n4TProgress	As	Integer
Data	n4IncPr		As	Integer
Data	o5Progress	As	Object
Data	n5TProgress	As	Integer
Data	n5IncPr		As	Integer
Data	nCancel		As	Integer
Data	nPInc		As	Integer


Method New(bFuncProc,cCaption)			CONSTRUCTOR
Method Activate()
Method Set1Progress(nTotal,nPInc)
Method Set2Progress(nTotal,nPInc)
Method Set3Progress(nTotal,nPInc)
Method Set4Progress(nTotal,nPInc)
Method Set5Progress(nTotal,nPInc)
Method Inc1Progress()
Method Inc2Progress()
Method Inc3Progress()
Method Inc4Progress()
Method Inc5Progress()
Method SetDetProgress(cDetLin1,nValLin1,cDetLin2,nValLin2,cDetLin3,nValLin3,cDetLin4,nValLin4)
Method Cancel()
Method Ret1Progress()
Method Ret2Progress()
Method Ret3Progress()
Method Ret4Progress()
Method Ret5Progress()

EndClass

Method New(bFuncProc,cCaption,lExtTaf) Class ACCProgress     

Default lExtTaf := .F.

Self:bFuncProc	:=	bFuncProc
Self:cCaption	:=	cCaption  
Self:lExtTaf    :=  lExtTaf
Self:oDlg 		:= 	Nil
Self:nWidth 	:= 	450
Self:nHeight 	:= 	480
Self:nAlign 	:= 	CONTROL_ALIGN_ALLCLIENT
Self:n1IncPr	:=	1
Self:n2IncPr	:=	1
Self:n3IncPr	:=	2
Self:n4IncPr	:=	2
Self:n5IncPr	:=	1
Self:nCancel	:=	0
Self:n1TProgress:=	1
Self:n2TProgress:=	1
Self:n3TProgress:=	1
Self:n4TProgress:=	1
Self:n5TProgress:=	1
Self:c1ASayProc	:=	"Obtendo informacoes, aguarde..."
Self:c1BSayProc	:=	""
Self:c2ASayProc	:=	"Obtendo informacoes, aguarde..."
Self:c2BSayProc	:=	""
Self:c3ASayProc	:=	"Obtendo informacoes, aguarde..."
Self:c3BSayProc	:=	""
Self:c4ASayProc	:=	"Obtendo informacoes, aguarde..."
Self:c4BSayProc	:=	""
Self:c5ASayProc	:=	"Obtendo informacoes, aguarde..."
Self:c5BSayProc	:=	""
Self:c1DetLin	:=	"Obtendo informacoes, aguarde..."
Self:c1ValLin	:=	""
Self:c2DetLin	:=	"Obtendo informacoes, aguarde..."
Self:c2ValLin	:=	""
Self:c3DetLin	:=	"Obtendo informacoes, aguarde..."
Self:c3ValLin	:=	""
Self:c4DetLin	:=	"Obtendo informacoes, aguarde..."
Self:c4ValLin	:=	""
Self:c5DetLin	:=	"Obtendo informacoes, aguarde..."
Self:c5ValLin	:=	""

Return

Method Activate() Class ACCProgress
Local	oPanel1
Local	bBlock		:=	Self:bFuncProc
Local	oBntCan

DEFINE MSDIALOG Self:oDlg TITLE OemToAnsi(Self:cCaption)  PIXEL FROM 0,0 TO Self:nHeight,Self:nWidth Of oMainWnd

oPanel1	:=	TPanel():New (0,0,,Self:oDlg,,,,,,230,185,.F.,.F.)
TGroup ():New(5, 5, 180, 220, "", oPanel1,,, .T., .T. )

Self:o1ASayProc	:=	TSay():New(010,010,{|| Self:c1ASayProc },oPanel1,,,,,,.T.,,,200,15,,,,.T.,,.T.)
Self:o1Progress	:=	TMeter():New(20,10,,Self:n1TProgress,oPanel1,205,10,,.T.,/*oFtArialB*/,"",.T.,,,GetSysColor(13),GetSysColor(),.F.)
Self:o1Progress:Set(0)
Self:o1BSayProc	:=	TSay():New(035,010,{|| Self:c1BSayProc },oPanel1,,,,.T.,,.T.,,,200,15,,,,.T.,,.T.)


Self:o2ASayProc	:=	TSay():New(045,010,{|| Self:c2ASayProc },oPanel1,,,,,,.T.,,,200,15,,,,.T.,,.T.)
Self:o2Progress	:=	TMeter():New(55,10,,Self:n2TProgress,oPanel1,205,10,,.T.,/*oFtArialB*/,"",.T.,,,GetSysColor(13),GetSysColor(),.F.)
Self:o2Progress:Set(0)
Self:o2BSayProc	:=	TSay():New(070,010,{|| Self:c2BSayProc },oPanel1,,,,.T.,,.T.,,,200,15,,,,.T.,,.T.)

Self:o3ASayProc	:=	TSay():New(080,010,{|| Self:c3ASayProc },oPanel1,,,,,,.T.,,,200,15,,,,.T.,,.T.)
Self:o3Progress	:=	TMeter():New(90,10,,Self:n3TProgress,oPanel1,205,10,,.T.,/*oFtArialB*/,"",.T.,,,GetSysColor(13),GetSysColor(),.F.)
Self:o3Progress:Set(0)
Self:o3BSayProc	:=	TSay():New(105,010,{|| Self:c3BSayProc },oPanel1,,,,.T.,,.T.,,,200,15,,,,.T.,,.T.)

Self:o4ASayProc	:=	TSay():New(115,010,{|| Self:c4ASayProc },oPanel1,,,,,,.T.,,,200,15,,,,.T.,,.T.)
Self:o4Progress	:=	TMeter():New(125,10,,Self:n4TProgress,oPanel1,205,10,,.T.,/*oFtArialB*/,"",.T.,,,GetSysColor(13),GetSysColor(),.F.)
Self:o4Progress:Set(0)
Self:o4BSayProc	:=	TSay():New(140,010,{|| Self:c4BSayProc },oPanel1,,,,.T.,,.T.,,,200,15,,,,.T.,,.T.)

oBntCan	:=	TButton():New(190,180, 'Cancelar' ,Self:oDlg,{|| Iif(CancProc(),(Self:oDlg:End(),Self:nCancel := 1),)},40,13,,,,.T.,,,,,,)	

ACTIVATE MSDIALOG Self:oDlg CENTERED ON INIT (Eval(bBlock),Eval({||oBntCan:Hide()}))

Return

Method Set1Progress(nTotal,nPInc) Class ACCProgress
Default	nPInc	:=	1

Self:n1IncPr	:=	nPInc
Self:o1Progress:Set(1)
Self:o1Progress:nTotal	:=	nTotal
Self:o1Progress:Refresh()
Return

Method Set2Progress(nTotal,nPInc) Class ACCProgress
Default	nPInc	:=	1

Self:n2IncPr	:=	nPInc
Self:o2Progress:Set(1)
Self:o2Progress:nTotal	:=	nTotal
Self:o2Progress:Refresh()
Return

Method Set3Progress(nTotal,nPInc) Class ACCProgress
Default	nPInc	:=	1

Self:n3IncPr	:=	nPInc
Self:o3Progress:Set(1)
Self:o3Progress:nTotal	:=	nTotal
Self:o3Progress:Refresh()
Return

Method Set4Progress(nTotal,nPInc) Class ACCProgress
Default	nPInc	:=	1

Self:n4IncPr	:=	nPInc
Self:o4Progress:Set(1)
Self:o4Progress:nTotal	:=	nTotal
Self:o4Progress:Refresh()
Return

Method Set5Progress(nTotal,nPInc) Class ACCProgress
Default	nPInc	:=	1

Self:n5IncPr	:=	nPInc
Self:o5Progress:Set(1)
Self:o5Progress:nTotal	:=	nTotal
Self:o5Progress:Refresh()
Return

Method Inc1Progress(c1ASayProc,c1BSayProc) Class ACCProgress
Default	c1ASayProc	:=	Self:c1ASayProc
Default	c1BSayProc	:=	Self:c1BSayProc

Self:c1ASayProc				:=	c1ASayProc
Self:o1ASayProc:cTitle 		:=	c1ASayProc
Self:o1ASayProc:cCaption	:=	c1ASayProc
Self:o1ASayProc:Refresh()

Self:c1BSayProc				:=	c1BSayProc
Self:o1BSayProc:cTitle 		:=	c1BSayProc
Self:o1BSayProc:cCaption	:=	c1BSayProc
Self:o1BSayProc:Refresh()

Self:o1Progress:Set(Self:n1IncPr++)

Return

Method Inc2Progress(c2ASayProc,c2BSayProc) Class ACCProgress
Default	c2ASayProc	:=	Self:c2ASayProc
Default	c2BSayProc	:=	Self:c2BSayProc

Self:c2ASayProc				:=	c2ASayProc
Self:o2ASayProc:cTitle 		:=	c2ASayProc
Self:o2ASayProc:cCaption	:=	c2ASayProc
Self:o2ASayProc:Refresh()

Self:c2BSayProc				:=	c2BSayProc
Self:o2BSayProc:cTitle 		:=	c2BSayProc
Self:o2BSayProc:cCaption	:=	c2BSayProc
Self:o2BSayProc:Refresh()

Self:o2Progress:Set(Self:n2IncPr++)

Return

Method Inc3Progress(c3ASayProc,c3BSayProc) Class ACCProgress
Default	c3ASayProc	:=	Self:c3ASayProc
Default	c3BSayProc	:=	Self:c3BSayProc

Self:c3ASayProc				:=	c3ASayProc
Self:o3ASayProc:cTitle 		:=	c3ASayProc
Self:o3ASayProc:cCaption	:=	c3ASayProc
Self:o3ASayProc:Refresh()

Self:c3BSayProc				:=	c3BSayProc
Self:o3BSayProc:cTitle 		:=	c3BSayProc
Self:o3BSayProc:cCaption	:=	c3BSayProc
Self:o3BSayProc:Refresh()

Self:o3Progress:Set(Self:n3IncPr++)

Return

Method Inc4Progress(c4ASayProc,c4BSayProc) Class ACCProgress
Default	c4ASayProc	:=	Self:c4ASayProc
Default	c4BSayProc	:=	Self:c4BSayProc

Self:c4ASayProc				:=	c4ASayProc
Self:o4ASayProc:cTitle 		:=	c4ASayProc
Self:o4ASayProc:cCaption	:=	c4ASayProc
Self:o4ASayProc:Refresh()

Self:c4BSayProc				:=	c4BSayProc
Self:o4BSayProc:cTitle 		:=	c4BSayProc
Self:o4BSayProc:cCaption	:=	c4BSayProc
Self:o4BSayProc:Refresh()

Self:o4Progress:Set(Self:n4IncPr++)

Return

Method Inc5Progress(c5ASayProc,c5BSayProc) Class ACCProgress
Default	c5ASayProc	:=	Self:c5ASayProc
Default	c5BSayProc	:=	Self:c5BSayProc

Self:c5ASayProc				:=	c5ASayProc
Self:o5ASayProc:cTitle 		:=	c5ASayProc
Self:o5ASayProc:cCaption	:=	c5ASayProc
Self:o5ASayProc:Refresh()

Self:c5BSayProc				:=	c5BSayProc
Self:o5BSayProc:cTitle 		:=	c5BSayProc
Self:o5BSayProc:cCaption	:=	c5BSayProc
Self:o5BSayProc:Refresh()

Self:o5Progress:Set(Self:n5IncPr++)

Return

Method SetDetProgress(c1DetLin,c1ValLin,c2DetLin,c2ValLin,c3DetLin,c3ValLin,c4DetLin,c4ValLin,c5DetLin,c5ValLin) Class ACCProgress

Self:c1DetLin	:=	c1DetLin
Self:c1ValLin	:=	c1ValLin
Self:c2DetLin	:=	c2DetLin
Self:c2ValLin	:=	c2ValLin
Self:c3DetLin	:=	c3DetLin
Self:c3ValLin	:=	c3ValLin
Self:c4DetLin	:=	c4DetLin
Self:c4ValLin	:=	c4ValLin
Self:c5DetLin	:=	c5DetLin
Self:c5ValLin	:=	c5ValLin

Self:o1DetSay:refresh()
Self:o2DetSay:refresh()
Self:o3DetSay:refresh()
Self:o4DetSay:refresh()
Self:o5DetSay:refresh()
Self:o6DetSay:refresh()
Self:o7DetSay:refresh()
Self:o8DetSay:refresh()
Self:o9DetSay:refresh()

Return

Method Cancel() Class ACCProgress
Return Self:nCancel==1

Static Function CancProc()
Return MsgYesNo("Deseja realmente cancelar o processamento da rotina ?")	

Method Ret1Progress() Class ACCProgress
Return Self:n1IncPr

Method Ret2Progress() Class ACCProgress
Return Self:n2IncPr

Method Ret3Progress() Class ACCProgress
Return Self:n3IncPr

Method Ret4Progress() Class ACCProgress
Return Self:n4IncPr

Method Ret5Progress() Class ACCProgress
Return Self:n5IncPr
