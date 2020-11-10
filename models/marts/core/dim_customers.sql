WITH customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders')}}
),

customer_orders as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(DISTINCT order_id) as number_of_orders,
        SUM(successful_payments_usd) as lifetime_value
    from 
        {{ ref('fct_orders') }}
    LEFT JOIN 
        orders
    USING (order_id)

    GROUP BY customer_id
),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value
    from customers

    left join customer_orders using (customer_id)

)

select * from final