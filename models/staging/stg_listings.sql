select
    id as listings_id,
    listing_url,
    initcap(name) as name,
    upper(room_type) as room_type,
    minimum_nights,
    host_id,
    replace(price, '$', '')::int as price,
    created_at,
    updated_at
from airbnb.raw.raw_listings
