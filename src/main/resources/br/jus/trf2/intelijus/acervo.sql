select
   acer_tp_acervo as nome,
   acer_qt_processo as valor,
   null as descricao,
   null as memoria_de_calculo 
from
   vw_acervo
where
   acer_id_orgao = ? 
   and acer_id_unidade = ?
order by
  acer_tp_acervo
