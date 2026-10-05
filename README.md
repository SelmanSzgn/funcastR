# funcastR

R interface to the Python [`funcast`](https://pypi.org/project/funcast/)
package, through `reticulate`.

## Installation

```r
# install.packages("pak")
pak::pak("SelmanSzgn/funcastR")
```
Python and the `funcast` package are set up automatically by `reticulate`
on first use.

### Usage

```r
library(funcastR)

# simulated data: Y(t) = (1 + t) * X(t)
set.seed(1)
n <- 200
t_all <- seq(0, 1, length.out = 100)
x <- outer(rnorm(n), sin(2 * pi * t_all)) +
  outer(rnorm(n), cos(2 * pi * t_all))
y <- sweep(x, 2, 1 + t_all, "*")

# past / future split of the time axis
past <- t_all <= 0.7
t_past <- t_all[past]
t_future <- t_all[!past]

# train / test split of the observations
train <- 1:150
test <- 151:200

# model and training
model <- funcast(K = 7L, s = 0.8)
model <- fit(
  model,
  Y_past = y[train, past],
  Y_future = y[train, !past],
  t_past = t_past,
  t_future = t_future,
  covariates_past = list(x[train, past])
)

# prediction of the future of new curves
y_pred <- predict(
  model,
  Y_past_new = y[test, past],
  covariates_past_new = list(x[test, past])
)

dim(y_pred)  # 50 x 30: one row per test curve, one column per t_future

# evaluation
sqrt(mean((y_pred - y[test, !past])^2))

# plot the first test curve
plot(t_all, y[test[1], ], type = "l", lty = 2)
lines(t_future, y_pred[1, ], col = "red")

```
## Demo

A complete example (synthetic data with two covariates, training,
prediction, plots and test metrics) is installed with the package:

```r
library(funcastR)
source(system.file("examples/demo.R", package = "funcastR"))
```

## Using your own Python

If automatic setup fails (e.g. restricted network), install `funcast` in a
Python environment and point R to it before loading the package:

```r
Sys.setenv(RETICULATE_PYTHON = "path/to/python")
library(funcastR)
```
