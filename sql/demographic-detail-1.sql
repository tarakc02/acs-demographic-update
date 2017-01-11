with cads as 
(
    select 
    cads.entity_id, 
    ST_SetSRID(ST_MakePoint(cads.longitude, cads.latitude), 4269) as geocode
    from 
    cads.geocodes cads 
)
    
select 
    cads.entity_id,
    /* 
        count of households 
    */    
    invest_bg.b19054001 as hh_bg,
    invest_bg.b19054001_moe as hh_moe_bg,
    invest_tract.b19054001 as hh_tract,
    invest_tract.b19054001_moe as hh_moe_tract,
    /* 
        num of investors 
    */
    invest_bg.b19054002 as investors_bg,
    invest_bg.b19054002_moe as investors_moe_bg,
    invest_tract.b19054002 as investors_tract,
    invest_tract.b19054002_moe as investors_moe_tract,    
    /* 
        median income 
    */    
    median_income_bg.b19013001 as median_income_bg,
    median_income_bg.b19013001_moe as median_income_moe_bg,
    median_income_tract.b19013001 as median_income_tract,
    median_income_tract.b19013001_moe as median_income_moe_tract,
    /* 
        old & young ppl with associated denominator 
    */
    /* 
        denominator 
    */
    age_bg.b01001001 as total_pop_bg,
    age_bg.b01001001_moe as total_pop_moe_bg,
    age_tract.b01001001 as total_pop_tract,
    age_tract.b01001001_moe as total_pop_moe_tract,
    /* 
        under 18 
    */    
    age_bg.b01001003 + age_bg.b01001004 + age_bg.b01001005 + age_bg.b01001006 +
        age_bg.b01001027 + age_bg.b01001028 + age_bg.b01001029 + 
        age_bg.b01001030 as under_18_bg,
    sqrt((age_bg.b01001003_moe ^ 2) + (age_bg.b01001004_moe ^ 2) + 
         (age_bg.b01001005_moe ^ 2) + (age_bg.b01001006_moe ^ 2) +
         (age_bg.b01001027_moe ^ 2) + (age_bg.b01001028_moe ^ 2) + 
         (age_bg.b01001029_moe ^ 2) + (age_bg.b01001030_moe ^ 2)) as under_18_moe_bg,
    age_tract.b01001003 + age_tract.b01001004 + age_tract.b01001005 + 
        age_tract.b01001006 + age_tract.b01001027 + age_tract.b01001028 + 
        age_tract.b01001029 + age_tract.b01001030 as under_18_tract,
    sqrt((age_tract.b01001003_moe ^ 2) + (age_tract.b01001004_moe ^ 2) + 
         (age_tract.b01001005_moe ^ 2) + (age_tract.b01001006_moe ^ 2) +
         (age_tract.b01001027_moe ^ 2) + (age_tract.b01001028_moe ^ 2) + 
         (age_tract.b01001029_moe ^ 2) + (age_tract.b01001030_moe ^ 2)) as under_18_moe_tract,
    /* 
        over 65 
    */
    age_bg.b01001020 + age_bg.b01001021 + age_bg.b01001022 + age_bg.b01001023 + 
        age_bg.b01001024 + age_bg.b01001025 + age_bg.b01001044 + 
        age_bg.b01001045 + age_bg.b01001046 + age_bg.b01001047 + 
        age_bg.b01001048 + age_bg.b01001049 as over_65_bg,
    sqrt((age_bg.b01001020_moe ^ 2) + (age_bg.b01001021_moe ^ 2) + 
         (age_bg.b01001022_moe ^ 2) + (age_bg.b01001023_moe ^ 2) + 
         (age_bg.b01001024_moe ^ 2) + (age_bg.b01001025_moe ^ 2) + 
         (age_bg.b01001044_moe ^ 2) + (age_bg.b01001045_moe ^ 2) + 
         (age_bg.b01001046_moe ^ 2) + (age_bg.b01001047_moe ^ 2) + 
         (age_bg.b01001048_moe ^ 2) + (age_bg.b01001049_moe ^ 2))  as over_65_moe_bg,
    age_tract.b01001020 + age_tract.b01001021 + age_tract.b01001022 + 
        age_tract.b01001023 + age_tract.b01001024 + age_tract.b01001025 + 
        age_tract.b01001044 + age_tract.b01001045 + age_tract.b01001046 + 
        age_tract.b01001047 + age_tract.b01001048 + age_tract.b01001049 as over_65_tract,
    sqrt((age_tract.b01001020_moe ^ 2) + (age_tract.b01001021_moe ^ 2) + 
         (age_tract.b01001022_moe ^ 2) + (age_tract.b01001023_moe ^ 2) + 
         (age_tract.b01001024_moe ^ 2) + (age_tract.b01001025_moe ^ 2) + 
         (age_tract.b01001044_moe ^ 2) + (age_tract.b01001045_moe ^ 2) + 
         (age_tract.b01001046_moe ^ 2) + (age_tract.b01001047_moe ^ 2) + 
         (age_tract.b01001048_moe ^ 2) + (age_tract.b01001049_moe ^ 2))  as over_65_moe_tract,
    /* 
        college educated, with denominator 
    */
    /* 
        denominator 
    */
    education_bg.b15003001 as pop25_plus_bg,
    education_bg.b15003001_moe as pop25_plus_moe_bg,
    education_tract.b15003001 as pop25_plus_tract,
    education_tract.b15003001_moe as pop25_plus_moe_tract,
    /* 
        college educated 
    */
    education_bg.b15003022 + education_bg.b15003023 + education_bg.b15003024 + 
        education_bg.b15003025 as college_educated_bg,
    sqrt((education_bg.b15003022_moe ^ 2) + (education_bg.b15003023_moe ^ 2) + 
         (education_bg.b15003024_moe ^ 2) + (education_bg.b15003025_moe ^ 2)) as college_educated_moe_bg,
    education_tract.b15003022 + education_tract.b15003023 + 
        education_tract.b15003024 + education_tract.b15003025 as college_educated_tract,
    sqrt((education_tract.b15003022_moe ^ 2) + (education_tract.b15003023_moe ^ 2) + 
         (education_tract.b15003024_moe ^ 2) + 
         (education_tract.b15003025_moe ^ 2)) as college_educated_moe_tract,
    /* 
        private high schools -- with denominator 
    */
    /* 
        denominator 
    */
    private_school_bg.b14002016 + private_school_bg.b14002040 as pop_hs_bg,
    sqrt((private_school_bg.b14002016_moe ^ 2) + 
         (private_school_bg.b14002040_moe ^ 2)) as pop_hs_moe_bg,
    private_school_tract.b14002016 + private_school_tract.b14002040 as pop_hs_tract,
    sqrt((private_school_tract.b14002016_moe ^ 2) + 
         (private_school_tract.b14002040_moe ^ 2)) as pop_hs_moe_tract,
    /* 
        private high school 
    */
    private_school_bg.b14002018 + private_school_bg.b14002042 as private_hs_bg,
    sqrt((private_school_bg.b14002018_moe ^ 2) + 
         (private_school_bg.b14002042_moe ^ 2)) as private_hs_moe_bg,
    private_school_tract.b14002018 + private_school_tract.b14002042 as private_hs_tract,
    sqrt((private_school_tract.b14002018_moe ^ 2) + 
         (private_school_tract.b14002042_moe ^ 2)) as private_hs_moe_tract
from 
    cads
    left join tiger.bg on ST_WITHIN(cads.geocode, bg.the_geom)
    left join tiger.tract on ST_WITHIN(cads.geocode, tract.the_geom)
    /* 
        median income 
    */
    left join acs2015_5yr.b19013_moe median_income_bg
        on substring(median_income_bg.geoid from position('S' in median_income_bg.geoid)+1) = bg.bg_id
    left join acs2015_5yr.b19013_moe median_income_tract
        on substring(median_income_tract.geoid from position('S' in median_income_tract.geoid)+1) = tract.tract_id
    /* 
        percent investors (arithmetic now or later?) 
    */
    left join acs2015_5yr.b19054_moe invest_bg
        on substring(invest_bg.geoid from position('S' in invest_bg.geoid)+1) = bg.bg_id
    left join acs2015_5yr.b19054_moe invest_tract
        on substring(invest_tract.geoid from position('S' in invest_tract.geoid)+1) = tract.tract_id
    /* 
        ages 
    */
    left join acs2015_5yr.b01001_moe age_bg
        on substring(age_bg.geoid from position('S' in age_bg.geoid)+1) = bg.bg_id
    left join acs2015_5yr.b01001_moe age_tract
        on substring(age_tract.geoid from position('S' in age_tract.geoid)+1) = tract.tract_id
    /* 
        education level 
    */
    left join acs2015_5yr.b15003_moe education_bg
        on substring(education_bg.geoid from position('S' in education_bg.geoid)+1) = bg.bg_id
    left join acs2015_5yr.b15003_moe education_tract
        on substring(education_tract.geoid from position('S' in education_tract.geoid)+1) = tract.tract_id
    /* 
        school type (private vs public) 
    */
    left join acs2015_5yr.b14002_moe private_school_bg
        on substring(private_school_bg.geoid from position('S' in private_school_bg.geoid)+1) = bg.bg_id
    left join acs2015_5yr.b14002_moe private_school_tract
        on substring(private_school_tract.geoid from position('S' in private_school_tract.geoid)+1) = tract.tract_id;
