/*
-- Description: Discovery and Audit queries for Product Category data (G1V2).
-- Purpose: Identifying unwantedspace issues and Data Standardization & Consistency
*/
--Check for unwanted Spaces
SELECT * FROM bronze. erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

--Data Standardization & Consistency
SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2
