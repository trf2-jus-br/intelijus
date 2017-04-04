select
   prod_nm_producao as nome,
   prod_qt_processo as valor,
   prod_dt_producao as dt,
   null as descricao,
   null as memoria_de_calculo 
from
	vw_produtividade
where
   prod_id_orgao = ? 
   and prod_id_unidade= ?
order by
   prod_dt_producao