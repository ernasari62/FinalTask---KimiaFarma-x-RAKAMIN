--- Data Preparation ---

-- Import 4 dataset to google big query --
SELECT price,
CASE
  WHEN price <= 50000 THEN '10%'
  WHEN price > 50000 THEN '15%'
  WHEN price > 100000 THEN '20%'
  WHEN price > 300000 THEN '25%'
  WHEN price > 500000 THEN '30%'
END AS persentase_gross_laba
FROM dataset_pbi_kf.kf_final_transaction;
-- save as csv file
-- import csv file of gross laba to dataset

--- Create Analysis Table ---
CREATE TABLE dataset_pbi_kf.kf_analisa AS
SELECT ft.transaction_id, ft.date, ft.branch_id, kc.branch_name, kc.kota, kc.provinsi, kc.rating_cabang, ft.customer_name, ft.product_id, pr.product_name, pr.actual_price, ft.discount_percentage, gl.persentase_gross_laba
FROM dataset_pbi_kf.kf_final_transaction as ft
LEFT JOIN dataset_pbi_kf.kf_kantor_cabang as kc
  on ft.branch_id = kc.branch_id
LEFT JOIN dataset_pbi_kf.kf_product as pr
  on ft.product_id = pr.product_id
LEFT JOIN `dataset_pbi_kf.kf_inventory` as inv
  on ft.branch_id = inv.branch_id
RIGHT JOIN dataset_pbi_kf.kf_gross_laba as gl
  on ft.price = gl.price
;

--- Menghitung Net Sales ---
UPDATE dataset_pbi_kf
SET discount_price = actual_price * discount_percentage
WHERE 1=1;
-- Can't get results because the data type which is FLOAT and INT can't do together --
-- Try to change the data type --
ALTER TABLE dataset_pbi_kf.kf_analisa
ALTER COLUMN persentase_gross_laba SET DATA TYPE INT64;
-- Still can't get the results --
-- Try different sintax --
ALTER TABLE dataset_pbi_kf.kf_analisa
ALTER COLUMN persentase_gross_laba INT64
USING CAST(persentase_gross_laba AS INT64);
-- Try Again
ALTER TABLE dataset_pbi_kf.kf_analisa
ALTER COLUMN persentase_gross_laba TYPE integer USING persentase_gross_laba::integer;
-- Try Again --
SELECT actual_price * discount_percentage AS discount_price
FROM dataset_pbi_kf.kf_analisa;
-- Still can't get the results --
-- Decided to process data of net sales and net profit with Microsoft Excel --

-- Re-import the dataset to google big query --
CREATE TABLE dataset_pbi_kf.kf_analisa AS
SELECT ft.transaction_id, ft.date, ft.branch_id, kc.branch_name, kc.kota, kc.provinsi, kc.rating_cabang, ft.customer_name, ft.product_id, pr.product_name, pr.actual_price, ft.discount_percentage, ft.persentase_gross_laba,ft.net_sales, ft.net_profit, ft.rating
FROM dataset_pbi_kf.kf_final_transaction as ft
LEFT JOIN dataset_pbi_kf.kf_kantor_cabang as kc
  on ft.branch_id = kc.branch_id
LEFT JOIN dataset_pbi_kf.kf_product as pr
  on ft.product_id = pr.product_id
LEFT JOIN `dataset_pbi_kf.kf_inventory` as inv
  on ft.branch_id = inv.branch_id
