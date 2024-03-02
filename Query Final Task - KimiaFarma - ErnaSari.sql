CREATE TABLE dataset_kimia_farma.kf_analisa AS
SELECT ft.transaction_id, ft.date, ft.branch_id, kc.branch_name, kc.kota, kc.provinsi, kc.rating_cabang, ft.customer_name, ft.product_id, pr.product_name, pr.actual_price, ft.discount_percentage, ft.persentase_gross_laba,ft.net_sales, ft.net_profit, ft.rating
FROM dataset_kimia_farma.kf_final_transaction as ft
LEFT JOIN dataset_kimia_farma.kf_kantor_cabang as kc
  on ft.branch_id = kc.branch_id
LEFT JOIN dataset_kimia_farma.kf_product as pr
  on ft.product_id = pr.product_id
LEFT JOIN `dataset_kimia_farma.kf_inventory` as inv
  on ft.branch_id = inv.branch_id
