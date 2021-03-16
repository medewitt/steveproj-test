# load libraries ----
# load the functions I need to process the data
library(stevedata) # has the raw data
library(tidyverse) # used for most everything
library(validate)
library(logger)

log_appender(appender_file(file = here::here("logs","analysis.log")))
# "load" the data ----
# Note: in your case, you can load raw data from wherever, even outside the project directory
# For example, if you're analyzing ANES data, you're not ask to stick it in your project directory
# If you can share the raw data, create a directory called "data-raw" in the main project directory
# Then, load it from there.
ESS9GB <- readRDS(here::here("data","ESS9GB.rds"))

# "prep" the data ----
# I can do anything I want here. I can recode things, transform variables, or whatever
# Here, let's just create a stupid noise variable
set.seed(8675309)
ESS9GB %>%
  mutate(noise = rnorm(nrow(.))) -> Data


# checking ----------------------------------------------------------------
log_info("Import Data Validation {Sys.info()['sysname'][[1]]}" )
validation_template <- here::here("tests", "data-validation.yml")

v <- validator(.file = validation_template)

confront_data <- confront(ESS9GB, v)

confront_results <- summary(confront_data)

for(i in 1:nrow(confront_results)){
  if(confront_results[i,]$fails>0){
    log_info(glue::glue_data(.x = confront_results[i,],
                             "{name}; passed = {passes}; failures = {fails}"))
  } else {
    log_error(glue::glue_data(.x = confront_results[i,],
                             "{name}; passed = {passes}; failures = {fails}"))
  }

}

# ^ Notice that I "finished" my data prep into a new object, titled "Data"
# Now: I save it to data/Data.rds

log_info("Data Saved")
saveRDS(Data, "data/Data.rds")
