# Libraries first
library(stevemisc)
library(tidyverse)
library(modelr)
library(validate)
library(logger)

log_appender(appender_file(file = here::here("logs","analysis.log")))
# Load stuff
Mods <- readRDS("data/Mods.rds")
Data <- readRDS("data/Data.rds")

Data %>%
  data_grid(lrscale = unique(lrscale), .model = Mods[[1]],
            immigsent = 0) %>% na.omit -> newdat

log_info("Running Simulations")

Sims <- list()

newdat %>%
  # repeat this data frame how many times we did simulations
  dplyr::slice(rep(row_number(), 1000)) %>%
  bind_cols(get_sims(Mods[[1]], newdata = newdat, 1000, 8675309), .) -> Sims$"SQI (Ideology)"

log_info("Simulations Complete")


# validate simulations for craziness ---------------------------------------
validation_template <- here::here("tests", "model-validation.yml")

v <- validator(.file = validation_template)

confront_data <- confront(Sims$`SQI (Ideology)`, v)

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


# save output -------------------------------------------------------------

log_info("Simulations Saved")
saveRDS(Sims, "data/Sims.rds")
