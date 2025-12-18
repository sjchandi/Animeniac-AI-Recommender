library(DBI)
library(RSQLite)

db_path <- "watchlist.sqlite"

# Connect to the database
con <- dbConnect(SQLite(), db_path)

DBI::dbExecute(con, "
CREATE TABLE IF NOT EXISTS anime_watchlist (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    genre TEXT,
    finished BOOLEAN
);
")

