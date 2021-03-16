# Purpose: Run tests on functions
## Utilizes tinytests framework and requires a file starting with test_*.R
## in the tests directory

library(tinytest)
library(logger)
log_appender(appender_file(file = here::here("logs","analysis.log")))

source(here::here("src", "output_validator.R"))

log_info("Running Function Tests")

out <- run_test_dir(here::here("tests"), verbose=0)

output_validator(out)
