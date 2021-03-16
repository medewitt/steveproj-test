source(here::here("src", "output_validator.R"))
library(tinytest)

expect_error(output_validator(mtcars,validation_yml = "false"))
