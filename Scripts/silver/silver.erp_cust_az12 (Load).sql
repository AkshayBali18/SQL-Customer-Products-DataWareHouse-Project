/*
-- Description: Cleanses ERP Customer (AZ12) demographic data.
-- Source: bronze.erp_cust_az12
-- Target: silver.erp_cust_az12
*/


insert into silver.erp_cust_az12(CID,BDATE,GEN)

select 
case
when cid like 'NAS%' then substring(cid,4,len(cid)) -- Remove 'NAS' prefix if present
else cid
end cid,
CASE 
WHEN BDATE > GETDATE() THEN NULL
ELSE BDATE
END BDATE, -- Set future birthdates to NULL
case 
when upper(trim(gen)) in('F','Female') then 'Female'
when upper(trim(gen)) in('M','Male') then 'Male'
else 'n/a'
end GEN  -- Normalize gender values and handle unknown cases
from bronze.erp_cust_az12



