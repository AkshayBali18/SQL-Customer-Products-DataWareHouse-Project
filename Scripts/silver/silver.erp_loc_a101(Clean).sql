/*
-- Description: Cleanses ERP Location data and validates keys against CRM Customers.
-- Domain: ERP / Locations
*/
  ---Compare PK=FK if not then match them---

select replace(cid,'-','') cid,
CNTRY
from
bronze.erp_loc_a101
where replace(cid,'-','') not in(select cst_key from silver.crm_cust_info)

 -- Normalize and Handle missing or blank country codes
select cid,
cntry,
case when CNTRY = 'DE' then 'Germany'
when trim(CNTRY) in('US','USA') then 'United States'
when trim(CNTRY) = '' or CNTRY is null then 'n/a'
else trim(CNTRY)
end cntry
from bronze.erp_loc_a101
