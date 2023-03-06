#include 'protheus.ch'
#include 'parmtype.ch'

User Function DZUTIL03()

Private	cCadastro 	:= "Itens de Controle"
Private cAlias	  	:= "SZT"
Private	aCores    	:= {{"SZT->ZT_STATU=='1'", 'BR_AZUL' },;
		 				{"SZT->ZT_STATU=='2'", 'BR_VERDE'},;
		 				{"SZT->ZT_STATU=='3'", 'BR_VERMELHO'}}
		 				
Private	aRotina   	:= {{ 'Pesquisar' ,'AxPesqui',0,1},;
		                 {"Visualizar","AxVisual",0,2},;
		                 {"Incluir"   ,"AxInclui",0,3},;
		                 {"Alterar"   ,"AxAltera",0,4},;
						 {"Copiar"    ,"U_COPUTL03",0,4},;
		                 {"Excluir"   ,"AxDeleta",0,5},;
		                 {'Legenda'   ,'U_LEGITE',0,8},;
		                 {'Etiqueta'  ,'U_ETIQIC',0,}}
		              
	mBrowse(6,1,22,75,cAlias,,,,,,aCores)
		
Return    


User Function LEGITE()

Local	_aLeg := {{"BR_AZUL"     , "Em uso"     },;
				  {"BR_VERDE"    , "Disponível" },;
             	  {"BR_VERMELHO" , "Inativo"    }}

	BrwLegenda(cCadastro, "Status", _aLeg)
	
Return .t. 




User Function ETIQIC()

	MSCBPRINTER("ARGOX","LPT1",,,.F.,,,,)
   	MSCBCHKStatus(.F.)
	MSCBBEGIN(1,6) //Inicio da Imagem da Etiqueta          
	MSCBSAY(03,10,SZT->ZT_ID,"N", "1", "1,2")
	MSCBSAYBAR(03,02,AllTrim(SZT->ZT_ID),"N","MB02",10,.f.,.f.,,,5,2,.f.) 
	MSCBEND()
	MSCBCLOSEPRINTER()

Return




/*/{Protheus.doc} COPUTL03
	Funcao de copiar registro
	@Chamado 00001279
    @type  Function
    @author DZ
    @since 10/08/2019
    @version 1.0
/*/  
User Function COPUTL03( cAlias, nReg, nOpc )

Local nOpcA 	:= 0
Local aButtons	:= {}

nOpcA := AxInclui( cAlias, nReg, nOpc,,"U_CPUTL03",,,,,aButtons )

Return




/*/{Protheus.doc} CPUTL03
	Alimenta as variaveis de memoria
	@Chamado 00001279
    @type  Function
    @author DZ
    @since 10/08/2019
    @version 1.0
/*/  
User Function CPUTL03()

Local aCpoNot	:= { "ZT_CODIGO" }
Local bCampo 	:= { |nCPO| Field(nCPO) }
Local i

dbSelectArea("SZT")
For i := 1 to FCount()
	If aScan( aCpoNot, {|x| x == Upper(allTrim(FieldName(i) ))} ) == 0
		M->&(Eval(bCampo,i)) := FieldGet(i)
	EndIf
Next i

Return