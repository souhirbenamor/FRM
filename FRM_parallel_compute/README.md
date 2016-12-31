
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **FRM_parallel_compute** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet : FRM_parallel_compute

Published in : 'FRM: A Financial Risk Meter based on penalizing tail events occurrence'

Description : parallel compute FRM series for 100 firms

Keywords : 'parallel, firms, quantile, financial, risk, LASSO, L1-norm penalty, tail, estimation,
variable, returns, linear'

Author : Lining Yu

Submitted : THU, December 15 2016 by Lining Yu

Datafile : 100_firms_returns_and_scaled_macro_2016-11-15.csv, lambda_mean_106vars_2016-11-14.csv

```


### R Code:
```r
# clear all variables
rm(list = ls(all = TRUE))
# install and load packages
# set the working directory setwd('C:/...')
libraries = c("quantreg", "doParallel", "foreach")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)
source("FRM_qrL1.r")
source("quantilelasso.r")
detectCores()
registerDoParallel(cores = 32)
getDoParWorkers()
### set the number of working days needed to be calculate
wd = 1
### set number of firms involved in the calculation
nf = 100

x0  = read.csv("100_firms_returns_and_scaled_macro_2016-11-15.csv")
final_data = x0
dt = final_data[, 1][(length(final_data[, 1]) - wd + 1):length(final_data[, 1])]
dt = as.Date(dt, format = "%d/%m/%Y")

# 6 macro state variables
m = as.matrix(x0[, (ncol(x0) - 5):ncol(x0)])
# log returns of 100 firms
xx0 = as.matrix(x0[, 2:(ncol(x0) - 6)])
# start the linear quantile lasso estimation for each firm number of rows of log
# return
n = nrow(xx0)
# number of covariates
p = ncol(xx0) + ncol(m) - 1
# quantile level
tau = 0.05
# moving window size
ws = 63
ptm <- proc.time()
lambda = foreach(k = 1:nf, .combine = cbind) %:% foreach(i = ((n - ws) - wd + 1):(n - ws)) %dopar% {
    print(i)
    # log return of firm k
    y = as.matrix(xx0[, k])
    # log returns of firms except firm k
    xx1 = as.matrix(xx0[, -k])
    yw = y[i:(i + ws)]
    mw = m[i:(i + ws), ]
    xx = xx1[i:(i + ws), ]
    ## all the independent variables
    xxw = cbind(xx, mw)
    fit = linear(yw, xxw, tau, i, k)
    print(fit$lambda.in)
}
proc.time() - ptm
lambda_all = matrix(unlist(lambda), ncol = nf, byrow = FALSE)
FRM = apply(lambda_all, 1, mean)

### combine the old FRM data and the updated data
old_FRM = as.matrix(read.csv("lambda_mean_106vars_2016-11-14.csv")[, 2])
dt_old = read.csv("lambda_mean_106vars_2016-11-14.csv")[, 1]
dt_old = strptime(as.character((dt_old)), "%Y-%m-%d")
dt_old = as.Date(dt_old, format = "%Y-%m-%d")
updated_dt = as.data.frame(c(dt_old, dt))
updated_FRM = c(old_FRM, FRM)
Final_FRM = cbind(updated_dt, updated_FRM)
colnames(Final_FRM) = c("date", "price")
write.csv(format(Final_FRM, scientific = FALSE), file = paste("lambda_mean_106vars_", 
    b, ".csv", sep = ""), row.names = FALSE, quote = FALSE)

### show the current risk level
maxFRM = max(Final_FRM[, 2])
curFRM = Final_FRM[, 2][length(Final_FRM[, 2])]
ql = curFRM/maxFRM
print(ql)


```
