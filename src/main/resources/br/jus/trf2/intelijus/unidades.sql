select
   unor_id_unidade as codigo,
   unor_sg_unidade as nome,
   unor_nm_unidade as descricao 
from
   vw_unidade_orgao 
where
   unor_id_orgao = ?
order by
   unor_sg_unidade