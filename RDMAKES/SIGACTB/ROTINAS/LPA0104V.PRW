#include "colors.ch"                                            
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPA0101V     ºAutor  ³RICARDO BRUNETO  º Data ³  03/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CONTABILIZACAO DO FINANCEIRO CONTAS A PAGAR LANÇ PADRAO      ±±
±±           ³ 530-002, ONDE FARÁ A SEPARAÇÃO DA CONTA A SER DEBITADA NO   ±±
±±           ³ PAGAMENTO PARA AS RETENCOES A RECOLHER, SEGUROS A PAGAR E   ±±
±±           ³ PAGAMENTOS NORMAIS DOS FORNECEDORES.                        ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO LATICINIOS SILVESTRE                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

USER FUNCTION LPA0104V()

LOCAL cCONTA := 0

   
Do Case
	Case AllTrim(SE2->E2_NATUREZ) $ ("20402001/20402002/20402003") // PIS/COFINS/CSLL RETIDOS
		cCONTA := "20104020002"
		
	Case AllTrim(SE2->E2_NATUREZ) == "20402004" // IRRF
		cCONTA := "20104020001"
		
	Case AllTrim(SE2->E2_NATUREZ) == "20401007" // ICMS-ST A RECOLHER, NO CASO DE PAGAMENTO PARA FUTURO REEMBOLSO DO CLIENTE
		cCONTA := "20104010008"
		
	Case AllTrim(SE2->E2_NATUREZ) == "20402005" // INSS RETIDO A RECOLHER (RETENÇÕES DOS DOCUMENTOS FISCAIS)
		cCONTA := "20104020004"
		
	Case AllTrim(SE2->E2_NATUREZ) == "20402007" // FUNRURAL RETIDO A RECOLHER (RETENÇÕES DOS DOCUMENTOS FISCAIS DE LEITE E LENHA DE PF)
		cCONTA := "20104020003"
		
	Case AllTrim(SE2->E2_NATUREZ) == "20402006" // ISSQN RETIDO A RECOLHER
		cCONTA := "20104020005"
		
	//Case AllTrim(SE2->E2_NATUREZ) $ ("20302001/20302002/20302003/20302004") // PAGTO SEGUROS, CAIRAO TODOS NA CONTA DA ALIANÇA A PAGAR, CONTAB MANUAL
		//cCONTA := "20105020001"

	Case AllTrim(SE2->E2_NATUREZ) == "20401001" // PAGTO DE ICMS SOBRE AS OPERAÇÕES PRÓPRIAS
		cCONTA := "20104010001"
	
	Case AllTrim(SE2->E2_NATUREZ) == "20204002" // PAGTO DO FGTS SOBRE A FOLHA DE PAGAMENTO
		cCONTA := "20103020002" 
		
	Case AllTrim(SE2->E2_NATUREZ) == "20204014" // PAGTO DA MULTA RESCISORIA DO FGTS
		cCONTA := "20103020003"
	
	Case AllTrim(SE2->E2_NATUREZ) == "20204003" // PAGTO DO IRRF SOBRE A FOLHA DE PAGAMENTO, COD 0561
		cCONTA := "20103020006"

	Case AllTrim(SE2->E2_NATUREZ) == ("20201001") // PAGTO DOS SALARIOS/ORDENADOS E DAS FERIAS, POIS O PASSIVO DE SALARIOS E 13 SAL SAO JUNTOS
		IF SE2->E2_TIPO == "ADI" 
			cCONTA := "10103020001" 
		ELSE
			cCONTA := "20103010001" 
		ENDIF
		                                            			                  
	Case AllTrim(SE2->E2_NATUREZ) == "20201002" // PAGTO DA ANTECIPACAO DO 13 SALARIO
		cCONTA := "10103020002"			                                            			                  
                                          			                  		                                            			                                                                                                                               		
	Case AllTrim(SE2->E2_NATUREZ) == "20201003" // PAGTO DA ANTECIPACAO DAS FERIAS
		cCONTA := "10103020003"	

	Case AllTrim(SE2->E2_NATUREZ) == "20201004" // PAGTO DAS RESCISÕES DA FOLHA DE PAGAMENTO
		cCONTA := "10103020005"
				
	Case AllTrim(SE2->E2_NATUREZ) == "20204015" // PAGTO DA CONTRIBUIÇÃO ASSISTENCIAL A RECOLHER
		cCONTA := "20103020004"

	Case AllTrim(SE2->E2_NATUREZ) == "20202001" // PAGTO DO PRO-LABORE
		cCONTA := "20103010004"
		
	Case AllTrim(SE2->E2_NATUREZ) == "20201005" // PAGTO DA PENSAO ALIMENTICIA DOS COLABORADORES
		cCONTA := "20103030002"		

	Case AllTrim(SE2->E2_NATUREZ) == "20201006" // PAGTO DAS INDENIZACOES TRABALHISTAS
		cCONTA := "20103030010"		

	Case AllTrim(SE2->E2_NATUREZ) == "20203007" // PAGTO DO CONVENIO FARMACIA
		cCONTA := "20103030003"		
		
	Case AllTrim(SE2->E2_NATUREZ) == "20203011" // PAGTO APAE
		cCONTA := "20103030004"		                         
		
	Case AllTrim(SE2->E2_NATUREZ) == "20204015" // PAGTO CONTRIBUICAO ASSISTENCIAL
		cCONTA := "20103020004"		                         		
				                                                                  
	Case AllTrim(SE2->E2_NATUREZ) == "20204016" // PAGTO CONTRIBUICAO SINDICAL
		cCONTA := "20103020005"		                         		
						                                                      
	Case AllTrim(SE2->E2_NATUREZ) == "20203012" .AND. AllTrim(SE2->E2_FORNECE) == "81115149" // PAGTO EMPRESTIMO CONSIGNADO SICREDI
		cCONTA := "20103030001"

	Case AllTrim(SE2->E2_NATUREZ) == "20203012" .AND. AllTrim(SE2->E2_FORNECE) == "04529074" // PAGTO EMPRESTIMO CONSIGNADO SICOOB
		cCONTA := "20103030005"		      
		
	Case AllTrim(SE2->E2_NATUREZ) == "10401002" // PAGTO DO REPASSE DOS CONVENIOS DE PRODUTORES RURAIS
		cCONTA := "20105040001"		      		
                 														
	OtherWise
		IF (SE2->E2_PREFIXO == "FRT" .OR. SE2->E2_PREFIXO == "PAP") //PARA OS PAGAMENTOS DOS CONVENIOS DOS PRODUTORES RURAIS
			cCONTA := "20105040001"
		ELSE
			IF !Empty(SE2->E2_X_CONTC)
				cCONTA := SE2->E2_X_CONTC // CONTA CREDITO ICLUSA NO TITULO A PAGAR
			ELSE
				  IF ((SE5->E5_TIPO="NDF" .OR. SE5->E5_TIPO="PA") .AND. SE5->E5_BANCO!="" .AND. SE5->E5_RECPAG="R")
				  	cCONTA := SA6->A6_CONTA
				  else
					cCONTA := SA2->A2_CONTA // CONTA PADRAO DE FORNECEDOR CFE CADASTRO
				  endif
				
			ENDIF
		ENDIF
EndCase


RETURN cCONTA


USER FUNCTION LPA0104H()    

LOCAL cHIST := ""

	IF(ALLTRIM(SE5->E5_NUMCHEQ) ="")
  		
  		IF (SE5->E5_TIPO="NDF" .AND. SE5->E5_BANCO!="" .AND. SE5->E5_RECPAG="R")
  			cHIST := SUBSTR ("BX NDF-" + SE2->E2_NUM + "-" + SA2->A2_NOME,1,40)
  		ELSEIF (SE5->E5_TIPO="PA" .AND. SE5->E5_BANCO!="" .AND. SE5->E5_RECPAG="R")
  	   		cHIST := SUBSTR ("DEV PAG-" + SE2->E2_NUM + "-" + SA2->A2_NOME,1,40)
  		ELSE	
  			cHIST := SUBSTR ("BX CPG-" + SE2->E2_NUM + "-" + SA2->A2_NOME,1,40)
  		ENDIF
  		
	ELSE
		cHIST := ("COMPENSACAO DO CHEQUE N " + ALLTRIM(SE5->E5_NUMCHEQ))
	ENDIF                                               

RETURN cHIST
