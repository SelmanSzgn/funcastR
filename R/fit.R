#' Fit a model
#'
#' @param object A model object.
#' @param ... Passed to methods.
#' @export
fit <- function(object, ...) UseMethod("fit")

#' Fit a FunCast model
#'
#' @param object A `funcast` object.
#' @param Y_past Matrix, n rows and length(t_past) columns.
#' @param Y_future Matrix, n rows and length(t_future) columns.
#' @param t_past Numeric vector of past timestamps.
#' @param t_future Numeric vector of future timestamps.
#' @param covariates_past List of matrices, same shape as `Y_past`.
#' @param ... Unused.
#' @return The fitted `funcast` object, invisibly.
#' @export
fit.funcast <- function(object, Y_past, Y_future, t_past, t_future,
                        covariates_past = NULL, ...) {
  arr <- function(x) reticulate::np_array(x, dtype = "float64")
  if (!is.null(covariates_past)) {
    covariates_past <- lapply(covariates_past, arr)
  }
  object$py$fit(
    Y_past = arr(Y_past),
    Y_future = arr(Y_future),
    t_past = arr(t_past),
    t_future = arr(t_future),
    covariates_past = covariates_past
  )
  invisible(object)
}
