#Include 'Protheus.ch'
User Function MA103BUT()
Local aButtons := {}
//Alert("Ponto de entrada executado")
	aadd(aButtons, {'Empenho1', {|| U_CMPREMP(SA2->A2_COD,SA2->A2_LOJA,SUBSTR(SA2->A2_NOME,0,40), SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_EMISSAO, SF1->F1_VALBRUT, SF1->F1_COND, SE2->E2_NATUREZ, SE4->E4_DESCRI)}, 'Nota Empenho'})  
	aadd(aButtons, {'Obs', {|| U_LSCOM003()}, 'Observações'})  
	
Return (aButtons)
