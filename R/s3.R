#' @export
test_s3 <- function(x){
  1
  UseMethod("test_s3")
}

#' @export
test_s3.numeric <- function(x){
  x+2
}
