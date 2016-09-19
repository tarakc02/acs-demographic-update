snapshot <- function(demographic_data, updated_date) {
    demographic_data$updated = updated_date
    db <- dplyr::src_sqlite(config("snapshot_db"))
    dplyr::db_insert_into(
        db$con, 
        table = "acs",
        values = demographic_data)
}
