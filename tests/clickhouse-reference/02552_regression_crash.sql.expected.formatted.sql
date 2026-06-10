CREATE TABLE store_sales
(
    ss_sold_date_sk Float64,
    ss_sold_time_sk Float64,
    ss_customer_sk Float64,
    ss_cdemo_sk Float64,
    ss_hdemo_sk Float64
)
ENGINE = Memory();

INSERT INTO store_sales;

INSERT INTO store_sales (ss_sold_time_sk);

INSERT INTO store_sales (ss_cdemo_sk);

SELECT stochasticLinearRegressionState(0.03, 0.00001, 2, 'Momentum')(ss_sold_time_sk, ss_sold_time_sk, ss_sold_time_sk) AS ss_wholesale_cost
FROM store_sales
FORMAT Null;