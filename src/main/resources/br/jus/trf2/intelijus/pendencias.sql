select
   pend_nm_pendencia as nome,
   pend_qt_processo as valor,
   null as descricao,
   null as memoria_de_calculo 
from
   vw_pendencia
where
   pend_id_orgao = ? 
   and pend_id_unidade = ?
order by
  pend_nm_pendencia