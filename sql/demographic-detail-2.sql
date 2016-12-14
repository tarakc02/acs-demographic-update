with cads as (
    select 
        cads.entity_id, 
        ST_SetSRID(ST_MakePoint(cads.longitude, cads.latitude), 4269) as geocode
    from cads.geocodes cads    
)

select
    cads.entity_id,
    tenure_type_bg.b25003001 as tenure_type_hh_bg,
    tenure_type_bg.b25003001_moe as tenure_type_hh_moe_bg,
    tenure_type_tract.b25003001 as tenure_type_hh_tract,
    tenure_type_tract.b25003001_moe as tenure_type_hh_moe_tract,
    tenure_type_bg.b25003002 as tenure_type_owned_bg,
    tenure_type_bg.b25003002_moe as tenure_type_owned_moe_bg,
    tenure_type_tract.b25003002 as tenure_type_owned_tract,
    tenure_type_tract.b25003002_moe as tenure_type_owned_moe_tract,
    tenure_length_bg.b25038002 as hh_owner_occupied_bg,
    tenure_length_bg.b25038002_moe as hh_owner_occupied_moe_bg,
    tenure_length_tract.b25038002 as hh_owner_occupied_tract,
    tenure_length_tract.b25038002_moe as hh_owner_occupied_moe_tract,
    /*
        moved in after 2000
    */
    tenure_length_bg.b25038005 + tenure_length_bg.b25038004 + 
        tenure_length_bg.b25038003 as owner_occupied_after2000_bg,
    sqrt((tenure_length_bg.b25038005_moe ^ 2) + 
         (tenure_length_bg.b25038004_moe ^ 2) + 
         (tenure_length_bg.b25038003_moe ^ 2)) as owner_occupied_after2000_moe_bg,
    tenure_length_tract.b25038005 + tenure_length_tract.b25038004 + 
    tenure_length_tract.b25038003 as owner_occupied_after2000_tract,
    sqrt((tenure_length_tract.b25038005_moe ^ 2) +
         (tenure_length_tract.b25038004_moe ^ 2) + 
         (tenure_length_tract.b25038003_moe ^ 2)) as owner_occupied_after2000_moe_tract,
    /* 
        moved in 1980 or before 
    */
    tenure_length_bg.b25038007 + 
        tenure_length_bg.b25038008 as owner_occupied_before1980_bg,
    sqrt((tenure_length_bg.b25038007_moe ^ 2) + 
         (tenure_length_bg.b25038008_moe ^ 2)) as owner_occupied_before1980_moe_bg,
    tenure_length_tract.b25038007 + 
        tenure_length_tract.b25038008 as owner_occupied_before1980_tract,
    sqrt((tenure_length_tract.b25038007_moe ^ 2) + 
         (tenure_length_tract.b25038008_moe ^ 2)) as owner_occupied_before1980_moe_tract
from
    cads
    left join tiger.bg on ST_WITHIN(cads.geocode, bg.the_geom)
    left join tiger.tract on ST_WITHIN(cads.geocode, tract.the_geom)
    /* 
        tenure type 
    */
    left join acs2014_5yr.b25003_moe tenure_type_bg
        on substring(tenure_type_bg.geoid from position('S' in tenure_type_bg.geoid)+1) = bg.bg_id
    left join acs2014_5yr.b25003_moe tenure_type_tract
        on substring(tenure_type_tract.geoid from position('S' in tenure_type_tract.geoid)+1) = tract.tract_id
    /* 
        year moved in to unit -- only looking at owner-occupied 
    */
    left join acs2014_5yr.b25038_moe tenure_length_bg
        on substring(tenure_length_bg.geoid from position('S' in tenure_length_bg.geoid)+1) = bg.bg_id
    left join acs2014_5yr.b25038_moe tenure_length_tract
        on substring(tenure_length_tract.geoid from position('S' in tenure_length_tract.geoid)+1) = tract.tract_id
