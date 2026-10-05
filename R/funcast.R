#' Create a FunCast model
#'
#' @param K Number of basis functions for the future of Y.
#' @param s Smoothing coefficient.
#' @param basis_type "bspline" or "fourier".
#' @param auto_h If TRUE, h is selected with RRSS.
#' @param h_list Values of h if `auto_h = FALSE`.
#' @param degree B-spline degree.
#' @param rcond Pseudo-inverse threshold.
#' @return An object of class `funcast`.
#' @export
funcast <- function(K = 10L, s = 0.5, basis_type = "bspline",
                    auto_h = TRUE, h_list = NULL, degree = 3L,
                    rcond = NULL) {
  if (!is.null(h_list)) h_list <- as.list(as.integer(h_list))
  py_model <- funcast_py$FunCast(
    K = as.integer(K),
    s = s,
    basis_type = basis_type,
    auto_h = auto_h,
    h_list = h_list,
    degree = as.integer(degree),
    rcond = rcond
  )
  structure(list(py = py_model), class = "funcast")
}
