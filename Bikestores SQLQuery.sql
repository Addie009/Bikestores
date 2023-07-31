--Lets clean our data
--join the customers firstname and lastname into a column and also do the same for the staffs

SELECT CONCAT(first_name, ' ', last_name) as CustomerName
FROM sales.customers

ALTER TABLE sales.customers
ADD customerName VARCHAR(255)

UPDATE sales.customers
SET customerName = CONCAT(first_name, ' ', last_name)

SELECT CONCAT(first_name, ' ', last_name) as Salesman
FROM sales.staffs

ALTER TABLE sales.staffs
ADD salesman varchar(255)

UPDATE sales.staffs
SET salesman =  CONCAT(first_name, ' ', last_name)

--ANALYSIS
--Find the total Revenue
SELECT ROUND(SUM(quantity*list_price),2) as Revenue
FROM sales.order_items

--Find the total orders
SELECT SUM(quantity) as totalorders
FROM sales.order_items

--Find the first 10 products with their revenues
SELECT TOP 10 pro.product_id, pro.product_name, SUM(ite.quantity*ite.list_price) as revenue
FROM sales.order_items as ite
join production.products as pro
on ite.product_id = pro.product_id
group by pro.product_id, pro.product_name
order by revenue desc

--Find the names of the store and the revenues generated?
SELECT st.store_id, sto.store_name, round(sum(st.quantity*pro.list_price),2) as revenue
FROM production.products AS pro
join production.stocks as st
on pro.product_id = st.product_id
join sales.stores as sto
on st.store_id = sto.store_id
group by st.store_id, sto.store_name
order by revenue desc

--Find our Top 10 customers with their revenue generated
SELECT TOP 10 cus.customerName, SUM(ite.quantity*ite.list_price) as revenue
FROM SALES.order_items AS ite
join sales.orders as ord
on ite.order_id = ord.order_id
join sales.customers as cus
on ord.customer_id = cus.customer_id
GROUP BY cus.customerName
ORDER BY revenue desc

--Find our salesman with their sales/revenues generated
SELECT st.salesman, sum(ite.quantity*ite.list_price) as revenue_salesman
FROM sales.order_items as ite
join sales.orders as ord
on ite.order_id = ord.order_id
join sales.staffs as st
on ord.staff_id =st.staff_id
group by st.salesman
order by revenue_salesman desc

--Find the region with the highest revenue
SELECT cus.state, SUM(ite.quantity*ite.list_price) as revenue_per_state
FROM sales.order_items as ite
join sales.orders as ord
on ite.order_id = ord.order_id
join sales.customers as cus
on ord.customer_id = cus.customer_id
GROUP BY cus.state
ORDER BY revenue_per_state DESC

--Find the brands and their revenues
SELECT br.brand_name, SUM(ite.quantity*ite.list_price) as revenue_per_brand
FROM sales.order_items as ite
JOIN production.products as pro
on ite.product_id = pro.product_id
join production.brands as br
on pro.brand_id = br.brand_id
GROUP BY br.brand_name
ORDER BY revenue_per_brand DESC

--Find the categories and the revenue generated
SELECT cat.category_name, SUM(ite.quantity*ite.list_price) as revenue_per_brand
FROM sales.order_items as ite
JOIN production.products as pro
on ite.product_id = pro.product_id
join production.categories as cat
on pro.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY revenue_per_brand DESC

--Visualization
--Lets select all the data needed for visualization
select 
       ord.order_id, 
	   cus.CustomerName, 
	   cus.city, 
	   cus.state,
	   ord.order_date,
	   sum(ite.quantity) as total_units,
	   sum(ite.quantity*ite.list_price) as Revenue,
	    pro.product_name, 
	   ca.category_name, 
	   ba.brand_name,
	   st.store_name,
	   sf.salesman
from sales.orders as ord
JOIN sales.customers as cus
on ord.customer_id = cus.customer_id
join sales.order_items as ite
on ord.order_id = ite.order_id
join production.products as pro
on ite.product_id = pro.product_id
join production.categories as ca
on pro.category_id = ca.category_id
join production.brands as ba
on pro.brand_id = ba.brand_id
join sales.stores as st
on ord.store_id = st.store_id
join sales.staffs as sf
on ord.staff_id = sf.staff_id
group by  ord.order_id, 
	   cus.CustomerName, 
	   cus.city, 
	   cus.state,
	   ord.order_date,
	    pro.product_name, 
	   ca.category_name, 
	   ba.brand_name,
	   st.store_name,
	   sf.salesman

