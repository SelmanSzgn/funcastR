library(funcastR)

set.seed(42)

n <- 1000
m <- 200
tau <- 0.7
train_frac <- 0.8
nbas <- 10
m1 <- as.integer(tau * m)
t_all <- seq(0, 1, length.out = m)
t_past <- t_all[1:m1]
t_future <- t_all[(m1 + 1):m]
n_train <- as.integer(n * train_frac)
mu <- seq(0, 1, length.out = nbas)

# Gaussian basis, m x nbas
gauss <- sapply(mu, function(k) dnorm(t_all, mean = k, sd = 0.05))

# n x m covariate matrix
gen_covar <- function(n, gauss) {
  coefs <- matrix(rnorm(n * ncol(gauss)), n, ncol(gauss))
  coefs %*% t(gauss)
}

x1 <- gen_covar(n, gauss)
x2 <- gen_covar(n, gauss)
gam1 <- cos(2 * pi * t_all / 0.2)
gam2 <- sin(2 * pi * t_all / 0.2)

# functional concurrent model
y <- sweep(x1, 2, gam1, "*") + sweep(x2, 2, gam2, "*")

old_par <- par(mfrow = c(2, 2))
matplot(t_all, t(x1[1:10, ]), type = "l", lty = 1, col = "blue",
        xlab = "Timestamp", ylab = "", main = "X_1(t) covariate")
matplot(t_all, t(x2[1:10, ]), type = "l", lty = 1, col = "green",
        xlab = "Timestamp", ylab = "", main = "X_2(t) covariate")
plot(t_all, gam1, type = "l", col = "magenta",
     xlab = "Timestamp", ylab = "", main = "gamma_1(t) parameter")
plot(t_all, gam2, type = "l", col = "magenta",
     xlab = "Timestamp", ylab = "", main = "gamma_2(t) parameter")
par(old_par)

matplot(t_all, t(y[1:5, ]), type = "l", lty = 1, col = "brown",
        xlab = "Timestamp", ylab = "", main = "Y(t) response function")

train <- 1:n_train
test <- (n_train + 1):n
past <- 1:m1
future <- (m1 + 1):m

model <- funcast(K = 7L, s = 0.8)
model <- fit(
  model,
  y[train, past], y[train, future],
  t_past, t_future,
  covariates_past = list(x1[train, past], x2[train, past])
)
y_pred <- predict(
  model,
  y[test, past],
  covariates_past_new = list(x1[test, past], x2[test, past])
)

y_future_test <- y[test, future]

old_par <- par(mfrow = c(3, 3))
for (i in 1:9) {
  plot(t_all, y[test[i], ], type = "l", lty = 2, col = "brown",
       xlab = "Timestamp", ylab = "")
  lines(t_future, y_pred[i, ], col = "red")
  legend("topleft", c("Y(t)", "FunCast pred."),
         col = c("brown", "red"), lty = c(2, 1), cex = 0.6, bty = "n")
}
par(old_par)

rmse <- sqrt(mean((y_pred - y_future_test)^2))
r2 <- 1 - sum((y_future_test - y_pred)^2) /
  sum((y_future_test - mean(y_future_test))^2)
cat("Metrics on test set:\n")
cat(sprintf("RMSE : %.3g\n", rmse))
cat(sprintf("R2   : %.3g\n", r2))
cat("Demo finished.\n")
