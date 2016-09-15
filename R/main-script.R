library(dplyr)
source("R/config.R")
source("R/database-functions.R")
source("R/query-database.R")
source("R/processing-functions.R")

# these constants are stored in the config file. edit them there, not here!
high_income <- config("high_income")
high_income_moe <- config("high_income_moe")
moe_scaler <- config("moe_scaler")
income_trunc <- config("income_trunc")
external_data_dir <- config("external_data_dir")
csv_filename <- config("csv_filename")

# pull active/last-known home addresses for living people in cads, no po boxes
geocodes_from_cads <- getcdw::get_cdw("sql/cads-addresses.sql")

# load the lat/long data into local geo db
load_geo_db(geocodes_from_cads)

# spatial-join lat/long with acs tract/block-groups and retrieve 
# demographic data. warning: this takes a long time.
raw_demographics <- demographic_query()

# process the raw data
demographics <- raw_demographics %>%
    # adjust median income numbers to (try to) deal with the 250k cutoff
    # adjust both point estimate and moe
    mutate(median_income_moe_bg = 
               ifelse(median_income_bg > income_trunc, 
                      high_income_moe * moe_scaler, 
                      median_income_moe_bg)) %>%
    mutate(median_income_moe_tract = 
               ifelse(median_income_tract > income_trunc, 
                      high_income_moe, 
                      median_income_moe_tract)) %>%
    mutate(median_income_bg = 
               ifelse(median_income_bg > income_trunc, 
                      high_income, 
                      median_income_bg)) %>%
    mutate(median_income_tract = 
               ifelse(median_income_tract > income_trunc, 
                      high_income, 
                      median_income_tract)) %>%
    # combined_ratio combines estimates from block-group and tract levels,
    # and calculates a percentage
    mutate(investor_pct = 
               combined_ratio(
                   investors_bg, investors_moe_bg, 
                   hh_bg, hh_moe_bg,
                   investors_tract, investors_moe_tract, 
                   hh_tract, hh_moe_tract)) %>%
    mutate(median_income = 
               combine_estimates(
                   median_income_bg, median_income_moe_bg,
                   median_income_tract, median_income_moe_tract)) %>%
    mutate(under_18_pct = 
               combined_ratio(
                   under_18_bg, under_18_moe_bg, 
                   total_pop_bg, total_pop_moe_bg,
                   under_18_tract, under_18_moe_tract, 
                   total_pop_tract, total_pop_moe_tract)) %>%
    mutate(over_65_pct = 
               combined_ratio(
                   over_65_bg, over_65_moe_bg, 
                   total_pop_bg, total_pop_moe_bg,
                   over_65_tract, over_65_moe_tract, 
                   total_pop_tract, total_pop_moe_tract)) %>%
    mutate(college_educated_pct = 
               combined_ratio(
                   college_educated_bg, college_educated_moe_bg, 
                   pop25_plus_bg, pop25_plus_moe_bg,
                   college_educated_tract, college_educated_moe_tract, 
                   pop25_plus_tract, pop25_plus_moe_tract)) %>%
    mutate(private_hs_pct = 
               combined_ratio(
                   private_hs_bg, private_hs_moe_bg, 
                   pop_hs_bg, pop_hs_moe_bg, 
                   private_hs_tract, private_hs_moe_tract, 
                   pop_hs_tract, pop_hs_moe_tract)) %>%    
    mutate(homeowner_pct = 
               combined_ratio(
                   tenure_type_owned_bg, tenure_type_owned_moe_bg, 
                   tenure_type_hh_bg, tenure_type_hh_moe_bg,
                   tenure_type_owned_tract, tenure_type_owned_moe_tract, 
                   tenure_type_hh_tract, tenure_type_hh_moe_tract)) %>%
    mutate(after2000_pct = 
               combined_ratio(
                   owner_occupied_after2000_bg, owner_occupied_after2000_moe_bg, 
                   hh_owner_occupied_bg, hh_owner_occupied_moe_bg,
                   owner_occupied_after2000_tract, owner_occupied_after2000_moe_tract, 
                   hh_owner_occupied_tract, hh_owner_occupied_moe_tract)) %>%
    mutate(before1980_pct = 
               combined_ratio(
                   owner_occupied_before1980_bg, owner_occupied_before1980_moe_bg, 
                   hh_owner_occupied_bg, hh_owner_occupied_moe_bg,
                   owner_occupied_before1980_tract, owner_occupied_before1980_moe_tract, 
                   hh_owner_occupied_tract, hh_owner_occupied_moe_tract)) %>%
    select(entity_id,
           median_income,
           investor_pct, 
           under_18_pct, 
           over_65_pct, 
           college_educated_pct,
           private_hs_pct,
           homeowner_pct,
           after2000_pct,
           before1980_pct)

# overwrite file in external data directory
write.csv(demographics, file = csv_filename, row.names = FALSE)

# make snapshot
snapshot(demographics, updated = format.Date(Sys.Date(), "%Y%m%d"))
