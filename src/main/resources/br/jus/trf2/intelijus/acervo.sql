select
   acpr_tp_acervo as nome,
   acpr_qt_total as valor,
   null as descricao,
   null as memoria_de_calculo 
from
   vw_acervo_processo
where
   acpr_cd_secao = ? 
   and acpr_cd_vara = ?
order by
  acpr_tp_acervo
