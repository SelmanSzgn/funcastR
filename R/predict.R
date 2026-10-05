#' Predict with a FunCast model
#'
#' @param object A fitted `funcast` object.
#' @param Y_past_new Matrix, n_new rows and length(t_past) columns.
#' @param covariates_past_new List of matrices, same shape as `Y_past_new`.
#' @param ... Unused.
#' @return Matrix, n_new rows and length(t_future) columns.
#' @export
predict.funcast <- function(object, Y_past_new,
                            covariates_past_new = NULL, ...) {
  arr <- function(x) reticulate::np_array(x, dtype = "float64")
  if (!is.null(covariates_past_new)) {
    covariates_past_new <- lapply(covariates_past_new, arr)
  }
  object$py$predict(
    Y_past_new = arr(Y_past_new),
    covariates_past_new = covariates_past_new
  )
}
