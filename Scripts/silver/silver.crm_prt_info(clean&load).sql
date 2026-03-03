/*
-- Description: Cleanses and deduplicates CRM products data from Bronze to Silver.
-- Domain: CRM / Products
*/

INSERT INTO silver.crm_prd_info(
prd_id ,
cat_id ,
prd_key ,
prd_nm ,
prd_cost ,
prd_line ,
prd_start_dt ,
prd_end_dt 
)
select prd_id,
replace(substring(prd_key,1,5),'-','_')cat_id,    --Extracts Category ID from the first 5 chars of prd_key.

substring(prd_key,7,len(prd_key))prd_key,
prd_nm,
isnull(prd_cost,0)prd_cost,
case 
 when upper(trim( prd_line)) ='R' then 'Road'
when upper(trim( prd_line ))='S' then 'Other sale'
when upper(trim( prd_line ))='M' then 'Mountain'
when upper(trim( prd_line)) ='T' then 'Touring'
else 'n/a'
end as prd_line,                             --Normalizes Product Line codes.
cast(prd_start_dt as date)prd_start_dt,
cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) -1 as date )prd_end_dt   --Uses LEAD() to calculate prd_end_dt (current start date + 1 day).
from bronze.crm_prd_info
