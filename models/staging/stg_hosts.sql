select
    id as host_id,
    name as host_name,
    case
        when is_superhost = 't' then True 
        else False 
    end as is_superhost,
    created_at,
    updated_at
from airbnb.raw.raw_hosts
