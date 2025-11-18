{{ config(materialized='table') }}

select 
    host_id,
    host_name,
    total_listings,
    avg_positive_review_percentage as host_positive_review_pct,
    avg_neutral_review_percentage as host_neutral_review_pct,
    avg_negative_review_percentage as host_negative_review_pct,
    host_performance_category,
    rank() over(order by avg_positive_review_percentage desc) as host_rank
from {{ ref('fct_host_performance')}}