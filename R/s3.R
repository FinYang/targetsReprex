#' @export
test_s3 <- function(x){
  UseMethod("test_s3")
}

#' @export
test_s3.numeric <- function(x){
  x+1
}
