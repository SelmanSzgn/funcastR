# Python module handle
funcast_py <- NULL

.onLoad <- function(libname, pkgname) {
  reticulate::py_require("funcast")
  funcast_py <<- reticulate::import("funcast", delay_load = TRUE)
}
