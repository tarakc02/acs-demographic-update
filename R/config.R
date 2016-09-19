config <- function(query) {
    # constants for local postgres database
    postgres_username <- Sys.getenv("POSTGRES_USERNAME")
    postgres_password <- Sys.getenv("POSTGRES_PW")
    postgres_host <- "localhost"
    postgres_port <- 5432
    geo_dbname <- "postgres"
    
    # try to deal with right-censoring of income data
    high_income <- 411160
    high_income_moe <- 1.645 * 8038
    
    # kind of arbitrary thing to make bg less certain than tract
    # means if no usable moe for bg/tract, then weighting approx 2:1 for tract:bg
    moe_scaler <- 1.88
    
    # household median income truncates @ 250000
    income_trunc <- 250000
    
    # directory where results are written
    external_data_dir <- "R:/Prospect Development/Prospect Analysis/external_datasets"
    csv_filename <- paste(external_data_dir, "acs_demographics.csv", sep = "/")
    
    # snapshot database location
    snapshot_db <- "R:/Prospect Development/Prospect Analysis/external_datasets/external_data.sqlite"
    
    get(query, inherits = FALSE)
}
