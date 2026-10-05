set.seed(1)
n <- 20
t_past <- seq(0, 1, length.out = 30)
t_future <- seq(1, 1.5, length.out = 10)

a <- runif(n, 1, 2)
Y_past <- outer(a, sin(2 * pi * t_past))
Y_future <- outer(a, sin(2 * pi * t_future))

m <- funcast(K = 5L)
m <- fit(m, Y_past, Y_future, t_past, t_future)
pred <- predict(m, Y_past)

cat("dim:", dim(pred), "\n")
cat("max abs error:", max(abs(pred - Y_future)), "\n")
