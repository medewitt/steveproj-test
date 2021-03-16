# Purpose: Pull data to save to data folder as an example

library(DDI)
library(RSQLite)
library(dplyr)


# prep work to mimic a database -------------------------------------------
#' Pull Data from a Database with Premade Query
#'
#' Theoretically this work could be saved in another sql script for better
#' clarity and just called.
#'
#' @param n_results an integer, how many results you wish to return. Default of
#'     \code{NULL} returns all results
generate_data <- function(n_results= NULL){
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

  ESS9GB <- stevedata::ESS9GB %>% as.data.frame()

  dbWriteTable(con, "mtcars", mtcars)
  dbWriteTable(con, "ESS9GB", ESS9GB)

  if(!is.null(n_results)){
    if(!is.integer(n_results)){
      stop(sprint("%s is not an integer, please submit and integer value", n_results))
    }

    q <- sprint("
  SELECT TOP %s* FROM ESS9GB;
  ", n_results)
  } else {
    q <- "
  SELECT * FROM ESS9GB;
  "
  }

  q_in <- DBI::dbSendQuery(con, q)

  out <- dbFetch(q_in)

  dbClearResult(q_in)
  on.exit(DBI::dbDisconnect(con))

  out
}


# pull result -------------------------------------------------------------

ESS9GB <- generate_data()

# save output -------------------------------------------------------------

saveRDS(ESS9GB, here::here("data", "ESS9GB.rds"))
