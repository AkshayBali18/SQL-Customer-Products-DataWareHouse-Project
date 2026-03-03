/*
-- Description: Cleanses and deduplicates CRM customer data from Bronze to Silver.
-- Domain: CRM / Customers
*/

insert into silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
 cst_marital_status,
 cst_gndr,
 cst_create_date
)


select
cst_id,
cst_key,
trim(cst_firstname)firstname,
trim(cst_lastname)lastname,
case
when upper(trim(cst_marital_status)) = 'M' then 'Married'
when upper(trim(cst_marital_status)) = 'S' then 'Single'
else 'n/a'
end cst_marital_status,---- Normalize marital status values to readable format--
case 
when upper(trim(cst_gndr)) = 'M' then 'Male'
when upper(trim(cst_gndr)) = 'f' then 'Female'
else 'n/a'
end cst_gndr,--Normalize Gender values to readable format--
cst_create_date
from(
select 
*,
ROW_NUMBER () over (partition by cst_id order by cst_create_date desc)flag    --Uses ROW_NUMBER to keep the latest cst_create_date per cst_id.
from bronze.crm_cust_info)t
where flag=1                             ---- Select the most recent record per customer--
