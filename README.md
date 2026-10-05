# funcastR

R interface to the Python [`funcast`](https://pypi.org/project/funcast/)
package, through `reticulate`.

## Installation

```r
# install.packages("remotes")
remotes::install_github("SelmanSzgn/funcastR")
```
Python and the `funcast` package are set up automatically by `reticulate`
on first use.

## Usage

```r
library(funcastR)

m <- funcast(K = 5L)
m <- fit(m, Y_past, Y_future, t_past, t_future)
pred <- predict(m, Y_past_new)
```

## Using your own Python

If automatic setup fails (e.g. restricted network), install `funcast` in a
Python environment and point R to it before loading the package:

```r
Sys.setenv(RETICULATE_PYTHON = "path/to/python")
library(funcastR)
```
