select
   orga_id_orgao as codigo,
   orga_sg_orgao as nome,
   orga_nm_orgao as descricao 
from
   vw_orgao 
where
   orga_sg_orgao is not null
order by
   orga_sg_orgao desc