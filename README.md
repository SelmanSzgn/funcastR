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

## Usage

```r
library(funcastR)

m <- funcast(K=5, s=0.8)
m <- fit(m, Y_past, Y_future, t_past, t_future)
pred <- predict(m, Y_past_new)
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
