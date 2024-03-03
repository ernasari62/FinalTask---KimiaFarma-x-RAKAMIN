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
FROM dataset_kimia_farma.kf_final_transaction;
-- save as csv file
-- import csv file of gross laba to dataset

--- Create Analysis Table ---
CREATE TABLE dataset_kimia_farma.kf_analisa AS
SELECT ft.transaction_id, ft.date, ft.branch_id, kc.branch_name, kc.kota, kc.provinsi, kc.rating_cabang, ft.customer_name, ft.product_id, pr.product_name, pr.actual_price, ft.discount_percentage, gl.persentase_gross_laba
FROM dataset_kimia_farma.kf_final_transaction as ft
LEFT JOIN dataset_kimia_farma.kf_kantor_cabang as kc
  on ft.branch_id = kc.branch_id
LEFT JOIN dataset_kimia_farma.kf_product as pr
  on ft.product_id = pr.product_id
LEFT JOIN `dataset_kimia_farma.kf_inventory` as inv
  on ft.branch_id = inv.branch_id
RIGHT JOIN dataset_kimia_farma.kf_gross_laba as gl
  on ft.price = gl.price
;
