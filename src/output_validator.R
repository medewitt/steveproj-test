#' Output Validation Helper
#'
#' This function will apply a yml validator against some kind of object.
#' Target use is against inputs and outputs to ensure sanity of results
#' for error checking. Assumes that there is logging available
#'
#' @param validation_yml a string, the file path of a valid yaml to confront the
#'     data with
#' @param object a data.frame, the object that you wish to confront
#' @export

output_validator <- function(object, validation_yml = NULL){


  if(!is.null(validation_yml)){
  if(!file.exists(validation_yml)){
    stop(sprintf("%s does not exist"))
  }

  validation_template <- validation_yml

  v <- validator(.file = validation_template)

  confront_data <- confront(object, v)

  confront_results <- summary(confront_data)
  } else if(class(object) %in% "tinytests"){
    confront_results <- as.data.frame.matrix(summary(object))
    confront_results$name <- rownames(confront_results)
  } else {
    stop("You have not passed a valid yaml or object")
  }

  for(i in 1:nrow(confront_results)){
    if(confront_results[i,]$failures>0){
      log_info(glue::glue_data(.x = confront_results[i,],
                               "{name}; passed = {passes}; failures = {fails}"))
    } else {
      log_error(glue::glue_data(.x = confront_results[i,],
                                "{name}; passed = {passes}; failures = {fails}"))
    }

  }
}
