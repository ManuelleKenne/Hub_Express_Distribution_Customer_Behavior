select * from express_distribution
-- total revenue by category
select SUM(purchase_amount_usd), category_product as total_revenue from express_distribution
group by category_product
-- Monthly sales trend
select SUM(purchase_amount_usd), frequency_of_purchase as total_sales from 
express_distribution
group by frequency_of_purchase
order by total_sales DESC;
-- Subquery: customers above average spending.
select customer_id, purchase_amount_usd from express_distribution
WHERE purchase_amount_usd > ( select AVG(purchase_amount_usd) from express_distribution);
-- Customer segmentation (VIP/Regular/New).
with customer_type as (
select customer_id, previous_orders, 
CASE
WHEN previous_orders = 0 THEN 'New'
WHEN previous_orders BETWEEN 1 AND 10 THEN 'Regular'
ELSE 'VIP'
END AS customer_segment from express_distribution)
select customer_segment, count(*) as "Number of customers" from customer_type
group by customer_segment
-- top 3 products per category.
with product_counts as (select category_product, count(customer_id) as total_orders,
ROW_NUMBER()over(partition by category_product
order by count(customer_id)DESC) as product_rank from express_distribution
group by category_product)
select product_rank, category_product, total_orders from product_counts
WHERE product_rank <= 3;

