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
    from TST_INTELIJUS.MV_QUANTIDADE_PROCESSO, TST_INTELIJUS.VW_ORGAO_JULGADOR
    where orju_id_orgao = QUPR_id_orgao
    and orju_id_unidade = QUPR_id_unidade
    and orju_id_orgao = ? 
    and orju_id_unidade = ?
    )

-- META 1
--  julgar quantidade maior de processos de conhecimento do que os distribuídos no ano corrente
select 'Meta 1' as nome, 'Julgar maior quantidade de processos de conhecimento do que os distribuídos no ano corrente' as descricao, decode(distribuidos, 0, null, round(100 * julgados / distribuidos, 1)) as valor, julgados || ' julgados / ' || distribuidos || ' distribuidos em ' ||(extract(year from sysdate)) || ' = ' || decode(distribuidos, 0, null, round(100 * julgados / distribuidos, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgados
    from mvep
    )
where distribuidos > 0

-- META 2
-- 100% dos processos distribuídos até 31/12/2012, 85% dos processos distribuídos em 2013
-- no 1º e 2º graus, e 100% dos processos distribuídos até 31/12/2014 nos Juizados Especiais Federais e nas
-- Turmas Recursais.
union all
select 'Meta 2' as nome, 'Julgar processos mais antigos' as descricao,
    case when espr_tp_unidade in('JUIZADO ESPECIAL', 'TURMA RECURSAL') then decode(distribuidosateanomenos3, 0, null, round(100 * julgadosateanomenos3 / distribuidosateanomenos3, 1))                                                                                                                                                  else least(decode(distribuidosateanomenos5, 0, null, round(100 * julgadosateanomenos5 / distribuidosateanomenos5, 1)), decode(distribuidosemanomenos4, 0, null, round(100 * julgadosemanomenos4 / distribuidosemanomenos4 / 0.85, 1)))                                                                                                                                                                                                                                                                                                                                            end as valor,
    case when espr_tp_unidade in('JUIZADO ESPECIAL', 'TURMA RECURSAL') then julgadosateanomenos3 || ' julgados / ' || distribuidosateanomenos3 || ' distribuidos até ' ||(extract(year from sysdate) - 3) || ' = ' || decode(distribuidosateanomenos3, 0, null, round(100 * julgadosateanomenos3 / distribuidosateanomenos3, 1)) || '%' else 'Menor percentual entre: (' || julgadosateanomenos5 || ' julgados / ' || distribuidosateanomenos5 || ' distribuidos até ' ||(extract(year from sysdate) - 5) || ' = ' || decode(distribuidosateanomenos5, 0, null, round(100 * julgadosateanomenos5 / distribuidosateanomenos5, 1)) || '%' || ') e (' || julgadosemanomenos4 || ' julgados / ' || distribuidosemanomenos4 || ' distribuidos em ' ||(extract(year from sysdate) - 4) || ' / 85% = ' || decode(distribuidosemanomenos4, 0, null, round(100 * julgadosemanomenos4 / distribuidosemanomenos4 / 0.85, 1)) || '%)' end as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 5 and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidosateanomenos5, sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 5 and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgadosateanomenos5, sum(
        case when(espr_nr_ano = extract(year from sysdate) - 4 and espr_tp_movimentacao = 'DISTRIBUIDO')  then espr_qt_processo else 0 end) as distribuidosemanomenos4, sum(
        case when(espr_nr_ano = extract(year from sysdate) - 4 and espr_tp_movimentacao = 'JULGADO')      then espr_qt_processo else 0 end) as julgadosemanomenos4, sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidosateanomenos3, sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgadosateanomenos3, espr_tp_unidade
    from mvep
    group by espr_tp_unidade
    )
where((espr_tp_unidade = 'JUIZADO ESPECIAL'
    or espr_tp_unidade = 'TURMA RECURSAL')
    and distribuidosateanomenos3 > 0)
    or(distribuidosateanomenos5 > 0
    and distribuidosemanomenos4 > 0)

-- META 3
-- Fomentar o alcance do percentual mínimo de 2% na proporção dos processos conciliados em relação aos distribuídos
union all
select 'Meta 3' as nome, 'Fomentar o alcance do percentual mínimo de 2% na proporção dos processos conciliados em relação aos distribuídos' as descricao, decode(distribuidos, 0, null, round(100 * conciliados / distribuidos / 0.02, 1)) as valor, conciliados || ' conciliados / ' || distribuidos || ' distribuidos em ' ||(extract(year from sysdate)) || ' / 2% = ' || decode(distribuidos, 0, null, round(100 * conciliados / distribuidos, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_tp_movimentacao = 'DISTRIBUIDO' and espr_id_orgao <> 2) then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_tp_movimentacao = 'CONCILIADO')  then espr_qt_processo else 0 end) as conciliados
    from mvep
    )
where distribuidos > 0

-- META 4
-- 70% das ações de improbidade administrativa distribuídas até 31/12/2014
union all
select 'Meta 4' as nome, 'Priorizar o julgamento dos processos relativos à corrupção e à improbidade administrativa' as descricao, decode(distribuidos, 0, null, round(100 * julgados / distribuidos / 0.85, 1)) as valor, julgados || ' julgados / ' || distribuidos || ' processos de improbidade administrativa distribuidos até ' ||(extract(year from sysdate) - 3) || ' / 85% = ' || decode(distribuidos, 0, null, round(100 * julgados / distribuidos / 0.85, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_sg_assunto_principal = '1-IMPROB' and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 3 and espr_sg_assunto_principal = '1-IMPROB' and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgados
    from mvep
    )
where distribuidos > 0

-- META 5
-- baixar quantidade maior de processos de execução não fiscal do que o total de casos novos de execução não fiscal no ano corrente
union all
select 'Meta 5' as nome, 'Impulsionar processos à execução' as descricao, decode(distribuidos, 0, null, round(100 * baixados / distribuidos, 1)) as valor, baixados || ' baixados / ' || distribuidos || ' processos não fiscais distribuidos em ' ||(extract(year from sysdate)) || ' = ' || decode(distribuidos, 0, null, round(100 * baixados / distribuidos, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_sg_classe <> 'ExFis' and espr_tp_movimentacao = 'DISTRIBUIDO' and espr_id_orgao <> 2) then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano = extract(year from sysdate) and espr_sg_classe <> 'ExFis' and espr_tp_movimentacao = 'BAIXADO')     then espr_qt_processo else 0 end) as baixados
    from mvep
    )
where distribuidos > 0

-- META 6
-- FAIXA 3: 70% dos processos de ações coletivas distribuídas até 31/12/2013, no 1º e 2º
-- graus. FAIXA 2: 80% dos processos de ações coletivas distribuídas até 31/12/2013, no 1º e 2º graus. FAIXA 1:
-- 85% dos processos de ações coletivas distribuídas até 31/12/2013, no 1º e 2º graus.
union all
select 'Meta 6' as nome, 'Priorizar o julgamento das ações coletivas' as descricao, decode(distribuidos, 0, null, round(100 * julgados / distribuidos / 0.85, 1)) as valor, julgados || ' julgados / ' || distribuidos || ' processos coletivos distribuidos até ' ||(extract(year from sysdate) - 4) || ' / 85% = ' || decode(distribuidos, 0, null, round(100 * julgados / distribuidos / 0.85, 1)) || '%' as memoria_de_calculo
from
    (select sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 4 and espr_tp_coletivo = 'COLETIVO' and espr_tp_movimentacao = 'DISTRIBUIDO') then espr_qt_processo else 0 end) as distribuidos, sum(
        case when(espr_nr_ano <= extract(year from sysdate) - 4 and espr_tp_coletivo = 'COLETIVO' and espr_tp_movimentacao = 'JULGADO')     then espr_qt_processo else 0 end) as julgados
    from mvep
    )
where distribuidos > 0

order by nome 