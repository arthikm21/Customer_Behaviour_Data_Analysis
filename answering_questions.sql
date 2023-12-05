-- 1. What is the total amount each customer spent at the restaurant?
select s.customer_id, SUM(m.price) as total_spent
from sales s
join menu m on s.product_id = m.product_id
group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?
select s.customer_id, count(DISTINCT s.order_date) as total_visits
from sales s
group by s.customer_id
order by total_visits DESC;

-- 3. What was the first item from the menu purchased by each customer?

WITH customer_first_purchase AS(
	SELECT s.customer_id, MIN(s.order_date) AS first_purchase_date
	FROM sales s
	GROUP BY s.customer_id
)
SELECT cfp.customer_id, cfp.first_purchase_date, m.product_name
FROM customer_first_purchase cfp
INNER JOIN sales s ON s.customer_id = cfp.customer_id
AND cfp.first_purchase_date = s.order_date
INNER JOIN menu m on m.product_id = s.product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name, COUNT(*) AS total_purchased
FROM sales s
INNER JOIN menu m on s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchased DESC;

-- 5. Which item was the most popular for each customer?
with most_popular_item as (
SELECT
    s.customer_id,
    m.product_name,
    COUNT(*) AS purchase_count,
    ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS popularity_rank
FROM
    sales s
JOIN
    menu m ON m.product_id = s.product_id
GROUP BY
    s.customer_id, m.product_name)
select mpi.customer_id, mpi.product_name, mpi.purchase_count
from most_popular_item mpi;

-- 6. Which item was purchased first by the customer after they became a member?
with purchase_after_membership as (
select s.customer_id, min(s.order_date) as first_purchase_date
from sales s
join members mb on s.customer_id = mb.customer_id
where s.order_date >= mb.join_date
group by customer_id
)
select pam.customer_id, m.product_name
from purchase_after_membership pam
join sales s on pam.customer_id = s.customer_id
and pam.first_purchase_date = s.order_date
join menu m on s.product_id = m.product_id;

-- 7. Which item was purchased just before the customer became a member?
with last_purchase_before_membership as (
select s.customer_id, MAX(s.order_date) as last_purchase_date
from sales s
join members mb on s.customer_id = mb.customer_id
where s.order_date < mb.join_date
group by s.customer_id
)
select lpbm.customer_id, m.product_name
from last_purchase_before_membership lpbm
join sales s on lpbm.customer_id = s.customer_id
and lpbm.last_purchase_date = s.order_date
join menu m on s.product_id = m.product_id;

-- 8. What is the total items and amount spent for each member before they became a member?

select s.customer_id, count(m.product_name), sum(m.price) as total_spent
from sales s
join menu m on s.product_id = m.product_id
join members mb on s.customer_id = mb.customer_id
where s.order_date < mb.join_date
group by customer_id;

select s.customer_id, count(*) as total_items, sum(m.price) as total_spent
from sales s
join menu m on s.product_id = m.product_id
join members mb on s.customer_id = mb.customer_id
where s.order_date < mb.join_date
group by customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id, 
SUM(case when product_name = 'sushi' then m.price*20
else m.price*10 end) as points_earned
from sales s
join menu m on s.product_id = m.product_id
group by customer_id
order by customer_id;

/* 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
how many points do customer A and B have at the end of January?*/
select s.customer_id, 
SUM(
case when order_date between join_date and adddate(mb.join_date, interval 7 day) then m.price*20 
when m.product_name = 'sushi' then m.price*20
else m.price*10 end) as points_earned_until_january
from sales s
join menu m on s.product_id = m.product_id
left join members mb on s.customer_id = s.customer_id
WHERE s.customer_id = mb.customer_id AND s.order_date <= '2021-01-31'
group by customer_id
ORDER BY customer_id;





