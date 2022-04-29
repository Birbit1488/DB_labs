EXPLAIN ANALYZE
SELECT task2.customers.id, task2.customers.name
FROM task2.products, task2.sales, task2.customers, 
	task2.purchases_products_list, task2.purchases
WHERE task2.customers.id = task2.purchases.customer_id 
	AND task2.purchases.id = task2.purchases_products_list.purchase_id 
	AND task2.purchases_products_list.product_id = task2.products.id 
	AND task2.products.type = task2.sales.type 
	AND task2.sales.discount::integer >0
GROUP BY task2.customers.id


EXPLAIN ANALYZE
SELECT task2.customers.id, task2.customers.name, 
	SUM(task2.products.price * task2.sales.discount::integer / 100) AS saved
FROM task2.products, task2.sales, task2.customers, 
	task2.purchases_products_list, task2.purchases
WHERE task2.customers.id = task2.purchases.customer_id 
	AND task2.purchases.id = task2.purchases_products_list.purchase_id 
	AND task2.purchases_products_list.product_id = task2.products.id 
	AND task2.products.type = task2.sales.type
GROUP BY task2.customers.id
HAVING SUM(task2.products.price * task2.sales.discount::integer / 100) > 0;


CREATE INDEX products_idx
ON task2.products 
USING hash (type);


CREATE INDEX sales_idx
ON task2.sales 
USING hash (type);