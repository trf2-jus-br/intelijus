-- CALCULO DE METAS DE 2017
--
with mvep as
    (select * from vw_estatistica_processual where espr_id_orgao = ? and espr_id_unidade = ?
    )

-- META ESPECÍFICA 1
-- AÇÕES CRIMINAIS: Baixar quantidade maior de processos criminais do que os casos novos criminais no ano corrente.
select 'Meta Específica 1' as nome, 'Baixar quantidade maior de processos criminais do que os casos novos criminais no ano corrente' as descricao, decode(distribuidos, 0, null, round(100 * baixados / distribuidos, 1)) as valor, baixados || ' baixados / ' || distribuidos || ' processos criminais distribuidos em  ' || extract(year from sysdate) || ' = ' || decode(distribuidos, 0, null, round(100 * baixados / distribuidos, 1)) || '%' as memoria_de_calculo
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
select 'Meta Específica 2' as nome, 'Julgar quantidade maior de processos criminais do que os casos novos criminais no ano corrente' as descricao, decode(distribuidos, 0, null, round(100 * julgados / distribuidos, 1)) as valor, julgados || ' julgados / ' || distribuidos || ' processos criminais distribuidos em ' || extract(year from sysdate) || ' = ' || decode(distribuidos, 0, null, round(100 * julgados / distribuidos, 1)) || '%' as memoria_de_calculo
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
select 'Meta Específica 3' as nome, 'Identificar e julgar até 31/12 do ano corrente, 70% das ações penais vinculadas aos crimes relacionados à improbidade administrativa, ao tráfico de pessoas, à exploração sexual e ao trabalho escravo, distribuídas até 31/12/2014.' as descricao, decode(distribuidos, 0, null, round(100 * julgados / distribuidos / 0.7, 1)) as valor, julgados || ' julgados / ' || distribuidos || ' processos criminais distribuidos até ' ||(extract(year from sysdate) - 3) || ' / 70% = ' || decode(distribuidos, 0, null, round(100 * julgados / distribuidos, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_sg_assunto_principal = '1-IMPROB' and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_sg_assunto_principal = '1-IMPROB' and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgados
    from mvep
    )
where distribuidos > 0

order by nome 