connect_geo_db <- function() {
    DBI::dbConnect(
        RPostgreSQL::PostgreSQL(), 
        user = config("postgres_username"), 
        password = config("postgres_password"),
        dbname = config("geo_dbname"),
        host = config("postgres_host"),
        port = config("postgres_port")
    )
}

disconnect_geo_db <- function(connection) {
    DBI::dbDisconnect(connection)
}

query_geo_db <- function(connection, query) {
    DBI::dbGetQuery(connection, query)
}

read_query <- function(filename) {
    text_con <- file(filename, open = "rt")
    on.exit(close(text_con))
    paste(readLines(text_con), collapse = "\n")
}
