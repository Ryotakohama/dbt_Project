{{ config(
    materialized='table'
)}}

select
    room_type,
    round(avg(price),2) as avg_price
from {{ ref('stg_listings')}}
group by 1