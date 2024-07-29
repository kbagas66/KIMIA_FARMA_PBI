CREATE OR REPLACE TABLE kimia_farma.tabel_analisa AS  -- Create Table "tabel_analisa"
SELECT  -- Define columns to be included in table "tabel_analisa"
  FT.transaction_id,
  FT.date,
  FT.branch_id,
  KC.branch_name,
  KC.kota,
  KC.provinsi,
  KC.rating AS rating_cabang,
  FT.customer_name,
  P.product_id,
  P.product_name,
  FT.price AS actual_price,
  FT.discount_percentage,
  FT.price * (1 - FT.discount_percentage) AS nett_sales,  -- Create column "nett_sales" using this formula: price * (1 – discount_percentage)
  CASE  -- Create column "persentase_gross_laba" by following the given condition
    WHEN FT.price <= 50000 THEN 0.1
    WHEN FT.price > 50000 AND FT.price <= 100000 THEN 0.15
    WHEN FT.price > 100000 AND FT.price <= 300000 THEN 0.20
    WHEN FT.price > 300000 AND FT.price <= 500000 THEN 0.25
    WHEN FT.price > 500000 THEN 0.30
  END AS persentase_gross_laba,
  (FT.price * 
  CASE  -- Create column "nett_profit" using this formula: (price * persentase_gross_laba) – (price * discount_percentage)
    WHEN FT.price <= 50000 THEN 0.1
    WHEN FT.price > 50000 AND FT.price <= 100000 THEN 0.15
    WHEN FT.price > 100000 AND FT.price <= 300000 THEN 0.20
    WHEN FT.price > 300000 AND FT.price <= 500000 THEN 0.25
    WHEN FT.price > 500000 THEN 0.30
  END) - (FT.price * FT.discount_percentage) AS nett_profit,
  FT.rating AS rating_transaksi
FROM  -- The new table created by combining columns from other generated tables. Use left join to join the tables with kf_final_transaction as the leftmost table
  kimia_farma.kf_final_transaction AS FT
  LEFT JOIN kimia_farma.kf_kantor_cabang AS KC ON FT.branch_id = KC.branch_id
  LEFT JOIN kimia_farma.kf_product AS P ON FT.product_id = P.product_id;
