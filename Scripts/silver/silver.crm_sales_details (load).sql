/*
-- Description: Cleanses Sales Transaction data; validates dates and enforces financial math.
-- Domain: CRM / Sales
*/


insert into silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)

select sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE
WHEN sls_order_dt = 0 OR len(sls_order_dt) !=8 THEN NULL 
ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
END  AS sla_order_dt,                                       --Check Invalid Date--
 CASE WHEN sls_ship_dt = 0 OR len(sls_ship_dt) !=8 THEN NULL 
ELSE CAST(CAST(sls_ship_dt AS VARCHAR)AS DATE)
END  AS sls_ship_dt,                                          --Check Invalid Date--
 CASE WHEN sls_due_dt = 0 OR len(sls_due_dt) !=8 THEN NULL 
ELSE CAST(CAST(sls_due_dt AS VARCHAR)AS DATE)
END  AS sls_due_dt,                                         --Check Invalid Date--
case
when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity* abs(sls_price) 
then sls_quantity* abs(sls_price)
else sls_sales
end sls_sales,            --Recalculate sales if original value is missing or incorrect
sls_quantity,
case
when sls_price is null or sls_price<=0 
then sls_sales/ nullif(sls_quantity,0)
else sls_price
end sls_price             -- Derive price if original value is invalid                                            
from bronze.crm_sales_details
