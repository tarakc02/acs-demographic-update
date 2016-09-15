load_geo_db <- function(df) {
    postgres <- connect_geo_db()
    on.exit(disconnect_geo_db(postgres))
    
    # clean up the previous queries!
    query_geo_db(postgres, "delete from cads.geocodes")
    
    # now write my stuff
    DBI::dbWriteTable(
        postgres, 
        name = c("cads", "geocodes"), 
        value = df, 
        append = TRUE,
        row.names=FALSE
    )
}

clean_up <- function(dataframe, leave_alone = 1L) {
    keep <- rowSums(!is.na(dataframe[ , -leave_alone, drop = FALSE])) > 0
    dplyr::tbl_df(dataframe[keep, ])
}

demographic_query <- function() {
    postgres <- connect_geo_db()
    on.exit(disconnect_geo_db(postgres))
    
    demographic_detail_1 <- query_geo_db(
        postgres, 
        query = read_query("sql/demographic-detail-1.sql")
    ) 
    demographic_detail_2 <- query_geo_db(
        postgres,
        query = read_query("sql/demographic-detail-2.sql")
    )
    
    demographic_detail_1 <- clean_up(demographic_detail_1)
    demographic_detail_2 <- clean_up(demographic_detail_2)
    dplyr::left_join(
        demographic_detail_1,
        demographic_detail_2,
        by = "entity_id"
    )
}
