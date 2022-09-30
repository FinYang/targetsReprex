#' @export
list_fun <- list(function(a){as.list(environment())})


#' @export
specials_test <- fabletools::new_specials(
  q= function(q = 1){
    as.list(environment())
  },
  .required_specials = c("q")
)
