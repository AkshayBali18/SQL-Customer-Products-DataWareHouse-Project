/*
-- Object Name: dim_customers (View)
-- Description: Consolidated Customer Master record merging CRM, ERP Tables.
*/
--Make Object in SQL by creating Views (Customers,Product,Sales)
-- Join Realated Tables for making Customers all detail in one table
select 
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.BDATE,
ca.GEN,
la.CNTRY
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key= ca.CID
left join silver.erp_loc_a101 la
on ci.cst_key=la.CID

--Checking Error in two similar coloum (Gender)
--If found then take Value of Master Table
select distinct
ci.cst_gndr,
ca.GEN,
case 
when ci.cst_gndr != 'n/a' then ci.cst_gndr --- CRM is the Master Table
else coalesce(ca.gen ,'n/a')
end new_gen
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key= ca.CID
left join silver.erp_loc_a101 la
on ci.cst_key=la.CID
order by ci.cst_gndr,ca.GEN

--make Indiviual key for every entery (even duplicate)
-- Rearrage coloum according to standardization
select
row_number() over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.CNTRY as country,
ci.cst_marital_status as marital_status,
case 
when ci.cst_gndr != 'n/a' then ci.cst_gndr
else coalesce(ca.gen ,'n/a')
end gender,
ca.BDATE as birth_date,
ci.cst_create_date as create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key= ca.CID
left join silver.erp_loc_a101 la
on ci.cst_key=la.CID
