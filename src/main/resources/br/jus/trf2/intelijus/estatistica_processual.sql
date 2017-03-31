select qupr_id_orgao as espr_id_orgao, orju_sg_orgao as espr_sg_orgao, qupr_id_unidade as espr_id_unidade, qupr_nr_ano as espr_nr_ano, qupr_tp_movimentacao as espr_tp_movimentacao, sum(qupr_qt_processo) as espr_qt_processo, qupr_tp_coletivo as espr_tp_coletivo, qupr_sg_natureza as espr_sg_natureza, decode(min(orju_tp_instancia), 1, 'PRIMEIRA', 2, 'SEGUNDA') as espr_tp_instancia, orju_tp_unidade as espr_tp_unidade,
    orju_sg_unidade as espr_sg_unidade
from mv_quantidade_processo, vw_orgao_julgador
where orju_id_orgao = qupr_id_orgao
    and orju_id_unidade = qupr_id_unidade
group by qupr_id_orgao, orju_sg_orgao, qupr_id_unidade, qupr_nr_ano, qupr_tp_movimentacao, qupr_tp_coletivo, qupr_sg_natureza, orju_tp_instancia, orju_tp_unidade, orju_sg_unidade