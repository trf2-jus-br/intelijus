# Intelijus

Intelijus é um site que apresenta um painel de controle com métricas relevantes para os órgãos julgadores.

## Arquitetura

Completamente baseado em micro-serviços, o Intelijus é composto dos seguintes componentes:
- Site do Intelijus: desenvolvido em AngularJS e Java.
- Views e Materialized Views disponibilizadas em Oracle

## Views

Grande parte do trabalho de implantar o Intelijus consiste em criar views com todos os dados que são necessários para a apresentação dos indicadores e o cálculo de metas. A seguir, descreveremos todas as views utilizadas e detalharemos o nome e o conteúdo de cada coluna:

#### vw_orgao - Órgãos
- orga_id_orgao: Código numérico do órgão, ex.: 1
- orga_sg_orgao: Sigla do órgão, ex.: TRF2
- orga_nm_orgao: Nome do órgão, ex.: Tribunal Regional Federal da 2a Região

#### vw_unidade_orgao - Unidades (Órgãos Julgadores)
- unor_id_orgao: Código numérico do órgão
- unor_id_unidade: Código numérico da unidade, ex.: 1
- unor_sg_unidade: Sigla da unidade, ex.: 01VF
- unor_nm_unidade: Nome da unidade, ex.: 1a Vara Federal do Rio de Janeiro

#### vw_acervo_processo - Acervo
- acpr_id_orgao: Código numérico do órgão
- acpr_id_unidade: Código numérico da unidade
- acpr_tp_acervo: Tipo do acervo (DIGIAL ou FISICO)
- acpr_qt_total: Quantidade de processos em cada tipo, ex.: 42

#### vw_pendencia_doc_proc_mov - Pendências de Hoje
- pdpm_id_orgao: Código numérico do órgão
- pdpm_id_unidade: Código numérico da unidade
- pdpm_nm_pendencia: Nome do tipo da pendência, ex.: Petições pendentes de juntada
- pdpm_qt_total: Quantidade de pendências em cada tipo, ex.: 42
    
#### vw_produtividade - Produção de Hoje
- prod_id_orgao: Código numérico do órgão
- prod_id_unidade: Código numérico da unidade
- prod_nm_producao: Nome do tipo de documento produzido ou assinado, ex.: Despacho
- prod_vl_producao: Quantidade produzida, ex.: 42
    
#### mv_quantidade_processo - Quantidade de Processos por Categorias
- qupr_id_orgao: Código numérico do órgão
- qupr_id_unidade: Código numérico da unidade
- qupr_nr_ano: Número do ano, ex.: 2017
- qupr_tp_movimentacao: Tipo da movimentação (DISTRIBUIDO, JULGADO, CONCILIADO, BAIXADO)
- qupr_tp_coletivo: Indicador de quantidade de partes (INDIVIDUAL, COLETIVO)
- qupr_sg_classe: Sigla da classe processual, ex.: ExFis
- qupr_sg_natureza: Sigla da natureza (CIVIL, CRIMINAL)
- qupr_sg_assunto_principal: Sigla do principal assunto ('1-IMPROB', '9-OUTROS')
- qupr_qt_processo: Quantidade de processos na situação descrita pelos campos acima, ex.: 42
    
## Ambiente

Para executar o Intelijus, é necessário que algumas propriedades sejam definidas.

Para acessar servidor de banco de dados Oracle, utilize um pool de conexões de JBoss chamado **java:/jboss/datasources/IntelijusDS** em ambiente de produção. Caso deseje acessar o Oracle em ambiente de desenvolvimento sem fazer uso do pool, configure as seguintes propriedades:

```xml
<property name="intelijus.datasource.url" value="jdbc:oracle:thin:@127.0.0.1:1521/SQLDEV"/>
<property name="intelijus.datasource.username" value="intelijus"/>
<property name="intelijus.datasource.password" value="senha_secreta"/>
 ```

Configuração do servidor SMTP para o envio de emails de sugestões:

```xml
<property name="intelijus.smtp.remetente" value="intelijus@trf2.jus.br"/>
<property name="intelijus.smtp.host" value="smtp.trf2.jus.br"/>
<property name="intelijus.smtp.host.alt" value="smtp2.trf2.jus.br"/>
<property name="intelijus.smtp.auth" value="true"/>
<property name="intelijus.smtp.auth.usuario" value="intelijus"/>
<property name="intelijus.smtp.auth.senha" value="senha_secreta"/>
<property name="intelijus.smtp.porta" value="25"/>
<property name="intelijus.smtp.destinatario" value="equipe_responsavel@trf2.jus.br"/>
<property name="intelijus.smtp.assunto" value="Intelijus: Sugestão"/>
 ```
