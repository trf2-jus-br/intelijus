-- CALCULO DE METAS DE 2017
--
with mvep as
    (   
    select QUPR_ID_ORGAO as ESPR_ID_ORGAO,
          ORJU_SG_ORGAO as ESPR_SG_ORGAO,
          QUPR_ID_UNIDADE as ESPR_ID_UNIDADE,
          QUPR_NR_ANO as ESPR_NR_ANO,
          QUPR_TP_MOVIMENTACAO as ESPR_TP_MOVIMENTACAO,
          QUPR_QT_PROCESSO as ESPR_QT_PROCESSO,
          QUPR_TP_COLETIVO as ESPR_TP_COLETIVO,
          QUPR_SG_CLASSE as ESPR_SG_CLASSE,
          QUPR_SG_NATUREZA as ESPR_SG_NATUREZA,
          QUPR_SG_ASSUNTO_PRINCIPAL as ESPR_SG_ASSUNTO_PRINCIPAL,
          decode(orju_tp_instancia, 1, 'PRIMEIRA', 2, 'SEGUNDA') as ESPR_tp_instancia, 
          ORJU_TP_UNIDADE as ESPR_TP_UNIDADE,
          ORJU_SG_UNIDADE as ESPR_SG_UNIDADE
    from MV_QUANTIDADE_PROCESSO, VW_ORGAO_JULGADOR
    where orju_id_orgao = QUPR_id_orgao
    and orju_id_unidade = QUPR_id_unidade
    and orju_id_orgao = ? 
    and orju_id_unidade = ?
    )

-- META ESPECÍFICA 1
-- AÇÕES CRIMINAIS: Baixar quantidade maior de processos criminais do que os casos novos criminais no ano corrente.
select 'Meta 7 - Baixados' as nome, 'Baixar quantidade maior de processos criminais do que os casos novos criminais no ano corrente' as descricao, decode(distribuidos, 0, null, round(100 * baixados / distribuidos, 1)) as valor, baixados || ' baixados / ' || distribuidos || ' processos criminais distribuidos em  ' || extract(year from sysdate) || ' = ' || decode(distribuidos, 0, null, round(100 * baixados / distribuidos, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_sg_natureza = 'CRIMINAL' and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_sg_natureza = 'CRIMINAL' and espr_tp_movimentacao = 'BAIXADO')     then espr_qt_processo else 0 end) as baixados
    from mvep
    )
where distribuidos > 0

-- META ESPECÍFICA 2
-- AÇÕES CRIMINAIS: Julgar quantidade maior de processos criminais do que os casos novos criminais no ano corrente.
union all
select 'Meta 7 - Julgados' as nome, 'Julgar quantidade maior de processos criminais do que os casos novos criminais no ano corrente' as descricao, decode(distribuidos, 0, null, round(100 * julgados / distribuidos, 1)) as valor, julgados || ' julgados / ' || distribuidos || ' processos criminais distribuidos em ' || extract(year from sysdate) || ' = ' || decode(distribuidos, 0, null, round(100 * julgados / distribuidos, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_sg_natureza = 'CRIMINAL' and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_sg_natureza = 'CRIMINAL' and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgados
    from mvep
    )
where distribuidos > 0

-- META ESPECÍFICA 3
-- AÇÕES PENAIS: Identificar e julgar até 31/12 do ano corrente, 70% das ações penais vinculadas aos crimes relacionados à improbidade administrativa, ao tráfico de pessoas, à exploração sexual e ao trabalho escravo, distribuídas até 31/12/2014.
union all
select 'Meta 8' as nome, 'Identificar e julgar até 31/12 do ano corrente, 70% das ações penais vinculadas aos crimes relacionados à improbidade administrativa, ao tráfico de pessoas, à exploração sexual e ao trabalho escravo, distribuídas até 31/12/2014.' as descricao, decode(distribuidos, 0, null, round(100 * julgados / distribuidos / 0.7, 1)) as valor, julgados || ' julgados / ' || distribuidos || ' processos criminais distribuidos até ' ||(extract(year from sysdate) - 3) || ' / 70% = ' || decode(distribuidos, 0, null, round(100 * julgados / distribuidos / 0.7, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_sg_assunto_principal = '1-IMPROB' and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_sg_assunto_principal = '1-IMPROB' and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgados
    from mvep
    )
where distribuidos > 0

order by nome 