/*
-- Description: Loads validated Product Category and Subcategory metadata.
-- Source: bronze.erp_px_cat_g1v2 
-- Target: silver.erp_px_cat_g1v2
*/
insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)

select id,
cat,
subcat,
maintenance
from silver.erp_px_cat_g1v2
