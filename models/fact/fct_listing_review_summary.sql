{{ config(materialized='table') }}

-- CTE to aggregate review sentiments per listing
with review_summary as (
    select
        dl.listings_id,
        dl.name as listing_name,
        count(*) as total_reviews,
        sum(case when dr.sentiment = 'POSITIVE' then 1 else 0 end) as positive_reviews,
        sum(case when dr.sentiment = 'NEGATIVE' then 1 else 0 end) as negative_reviews,
        sum(case when dr.sentiment = 'NEUTRAL' then 1 else 0 end) as neutral_reviews
    from {{ ref('dim_reviews') }} dr
    join {{ ref('dim_listings') }} dl
      on dr.listing_id = dl.listings_id
    group by dl.listings_id, dl.name
)

-- Final selection with calculated fields
select 
    listings_id,
    listing_name,
    total_reviews,
    round(positive_reviews / nullif(total_reviews, 0) * 100, 2) as positive_review_percentage,
    round(neutral_reviews / nullif(total_reviews, 0) * 100, 2) as neutral_review_percentage,
    round(negative_reviews / nullif(total_reviews, 0) * 100, 2) as negative_review_percentage,
    case 
        when (positive_reviews / nullif(total_reviews, 0) * 100) > 70 then 'Good'
        when (positive_reviews / nullif(total_reviews, 0) * 100) between 40 and 70 then 'Average'
        else 'Bad'
    end as sentiment_category
from review_summary
order by total_reviews desc
