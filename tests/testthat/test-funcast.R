skip_if_no_funcast <- function() {
  testthat::skip_if_not(
    reticulate::py_module_available("funcast"),
    "Python module 'funcast' not available"
  )
}

test_that("funcast() creates a model with the given parameters", {
  skip_if_no_funcast()
  m <- funcast(K = 5L, s = 0.3)
  expect_s3_class(m, "funcast")
  expect_equal(m$py$K, 5L)
  expect_equal(m$py$s, 0.3)
})

test_that("fit() and predict() work end to end", {
  skip_if_no_funcast()
  set.seed(1)
  n <- 20
  t_past <- seq(0, 1, length.out = 30)
  t_future <- seq(1, 1.5, length.out = 10)
  a <- runif(n, 1, 2)
  Y_past <- outer(a, sin(2 * pi * t_past))
  Y_future <- outer(a, sin(2 * pi * t_future))

  m <- fit(funcast(K = 5L), Y_past, Y_future, t_past, t_future)
  pred <- predict(m, Y_past)

  expect_equal(dim(pred), c(n, 10L))
  expect_lt(max(abs(pred - Y_future)), 0.05)
})
