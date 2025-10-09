select 
    listing_id,
    date::date as date,
    reviewer_name,
    initcap(comments) as comments,
    upper(sentiment) as sentiment
from airbnb.raw.raw_reviews
