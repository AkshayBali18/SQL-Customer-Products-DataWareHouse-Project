/*
-- Project: Data Warehouse Gold Layer (Medallion Architecture)
-- Model Type: Star Schema
-- Description: 
--   1. dim_customer: Unified Customer record from CRM/ERP.
--   2. dim_products: Active Product catalog with category hierarchy.
--   3. fact_sales: Sales transactions linked to Gold dimensions via Surrogate Keys.
*/

create view gold.dim_customer AS

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


create view gold.dim_products as
select row_number() over(order by pi.prd_start_dt,pi.prd_key) as product_key,
prd_id as product_id,
pi.prd_key as product_number,
pi.prd_nm as product_name,
pi.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pc.maintenance,
pi.prd_cost AS cost,
pi.prd_line AS product_line,
pi.prd_start_dt as start_date
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2  pc
on pi.cat_id = pc.id
where prd_end_dt is null


create view gold.fact_sales as
select sls_ord_num as order_number,
c.customer_key,
p.product_key,
sls_order_dt as order_date,
sls_ship_dt as ship_date,
sls_due_dt as due_date,
sls_sales as sales,
sls_quantity as quantity,
sls_price price
from silver.crm_sales_details sd
left join gold.dim_customer c
on sd.sls_cust_id=c.customer_id
left join gold.dim_products p
on sd.sls_prd_key=p.product_number






