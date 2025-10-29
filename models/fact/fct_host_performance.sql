-- Fact table to evaluate host performance based on listing reviews
{{ config(materialized='table') }}
select 
    dh.host_id,
    dh.host_name,
    count(distinct dl.listings_id) as total_listings,
    round(avg(flr.positive_review_percentage),2) as avg_positive_review_percentage,
    round(avg(flr.neutral_review_percentage),2) as avg_neutral_review_percentage,   
    round(avg(flr.negative_review_percentage),2) as avg_negative_review_percentage,
    case
        when avg(flr.positive_review_percentage) > 70 then 'Good Host'
        when avg(flr.positive_review_percentage) between 40 and 70 then 'Average Host'
        else 'Poor Host'
    end as host_performance_category
from {{ ref('dim_hosts')}} dh
join {{ ref('dim_listings')}} dl
    on dh.host_id = dl.host_id
join {{ ref('fct_listing_review_summary')}} flr 
    on dl.listings_id = flr.listings_id
group by dh.host_id, dh.host_name
order by total_listings desc

