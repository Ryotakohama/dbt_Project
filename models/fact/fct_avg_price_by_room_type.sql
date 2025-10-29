{{ config(
    materialized='table'
)}}

select
    listings_id,
    room_type,
    round(avg(price),2) as avg_price
from {{ ref('dim_listings')}}
group by 1,2