# Libraries first
library(stevemisc)
library(tidyverse)
library(modelr)
library(validate)
library(logger)
source(here::here("src", "output_validator.R"))

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
## Wrapping the validation into a function available in src
output_validator(Sims$`SQI (Ideology)`, here::here("tests", "model-validation.yml"))


# save output -------------------------------------------------------------

log_info("Simulations Saved")
saveRDS(Sims, "data/Sims.rds")
