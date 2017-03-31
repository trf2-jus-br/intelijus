select
   pdpm_nm_pendencia as nome,
   pdpm_qt_total as valor,
   null as descricao,
   null as memoria_de_calculo 
from
   vw_pendencia_doc_proc_mov 
where
   pdpm_cd_secao = ? 
   and pdpm_cd_unidade = ?
order by
  pdpm_nm_pendencia