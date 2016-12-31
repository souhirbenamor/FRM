
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **FRM_lambda_series** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet : FRM_lambda_series

Published in : 'FRM: A Financial Risk Meter based on penalizing tail events occurrence'

Description : 'generates the averaged lambda series by using 100 largest financial firms stock
returns and 6 macro variables.'

Keywords : returns, linear, quantile, LASSO, L1-norm penalty

See also : 'http://sfb649.wiwi.hu-berlin.de/frm/'

Author : Lining Yu, Thijs Benschop

Submitted : Mon, August 29 2016 by Lining Yu

Datafile : 100_firms_returns_and_scaled_macro_2016-11-15.csv

```


### R Code:
```r
  # clear all variables
  rm(list = ls(all = TRUE))
  graphics.off()

  # set the working directory
  #setwd("C:/Users/FRM_lambda_series")

   # install and load packages
  libraries = c("quantreg")
  lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
  })
  lapply(libraries, library, quietly = TRUE, character.only = TRUE)
  source("FRM_qrL1.r")
  source("quantilelasso.r")

  # read the file which includes log returns of 100 firms and 6 macro state
  # variables
  x0  = read.csv("100_firms_returns_and_scaled_macro_2016-11-15.csv", header = TRUE)
  # 6 macro state variables
  m   = as.matrix(x0[, 102:107])
  # log returns of 100 firms
  xx0 = x0[, 2:101]
  # start the linear quantile lasso estimation for each firm
  for (k in 1:ncol(xx0)) {
  cat("Financial firm:", k, "\n")
  # log return of firm k
  y              = as.matrix(xx0[, k])
  # log returns of firms except firm k
  xx1            = as.matrix(xx0[, -k]) 
  # number of rows of log return
  n              = nrow(xx1)
  # number of covariates
  p              = ncol(xx1) + ncol(m)
  # quantile level
  tau            = 0.05
  # moving window size
  ws             = 63 
  # lambda calculated from linear quantile lasso
  lambda_l       = matrix(0, (n - ws), 1)
  # start the moving window estimation
    for (i in 1:(n - ws)) {
      cat("time:",i,"\n")
      yw  = y[i:(i + ws)]
      mw  = m[i:(i + ws), ]
      xx          = xx1[i:(i + ws), ]
      # all the independent variables
      xxw         = cbind(xx, mw)
      fit         = linear(yw, xxw, tau, i, k)
      lambda_l[i] = fit$lambda.in
      cat("lambda:",lambda_l[i],"\n")
    }
    write.csv(lambda_l, file = paste("lambda_l_", k, ".csv", sep = ""))
  } 

  # calculate the average of 100 lambda series
  full.lambda = matrix(0, nrow(xx0), ncol(xx0))
  for (j in 1:ncol(xx1)) {
    lambda.firm      = read.csv(file = paste("lambda_l_", j, ".csv", sep = ""))
    full.lambda[, j] = as.matrix(lambda.firm)[, 2]
  }

  # FRM based on 100 firms
  average_lambda = 1/ncol(xx0) * (rowSums(full.lambda))

```
