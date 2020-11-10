SELECT
    o.order_id,
    c.customer_id,
    SUM(CASE WHEN p.status = 'success' THEN p.amount_usd END) as successful_payments_usd,
    SUM(CASE WHEN p.status = 'fail' THEN p.amount_usd END) as failed_payments_usd
FROM 
    {{ ref('stg_payments') }} p 
LEFT JOIN 
    {{ ref('stg_orders') }} o ON p.order_id = o.order_id 
LEFT JOIN 
    {{ ref('stg_customers') }} c ON c.customer_id = o.customer_id
GROUP BY 
    o.order_id,
    c.customer_id
