select
   prod_nm_producao as nome,
   prod_vl_producao as valor,
   null as descricao,
   null as memoria_de_calculo 
from
   vw_produtividade
where
   prod_id_orgao = ? 
   and prod_id_unidade= ?