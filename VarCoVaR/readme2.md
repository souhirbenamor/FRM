# VarCoVaR RiskMeter 2.0 (CopyRight by Lukas Borke)

* **Black dots**: Lambda time series
* **Red dots**: VarCoVaR time series

![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot_ave_l_VarCoVaR_120.png)

### The VarCoVaR RiskMeter shows
* a better pronounced behaviour (than the old FRM version)
* the Pearson correlation between both time series: 0.966
* a clear visual correlation with the Lambda structure
* that market heights and lows are better captured
* a clear, concise statistical definition and derivation: conditional variance of CoVaR
* a clear economic interpretation: volatility of the (Co)VaR according to the covariates
* in contrast to the abstract Lambda index the VarCoVaR scale, which is the value domain of the (Co)VaR
* that the Lambda value domain does not start with zero: clear disadvantage in comparison with VarCoVaR. "No risk" should start with zero.
* a better spread between extreme values
* more stability over different companies but still different and individual characterizations
* the incorporation of the whole market volatility and not only Lambdas (based on Betas) from L1-Q-regression
* the financial crisis from 2008 much better pronunciated (peak value)
* also the volatility and uncertainty of the CoVaR of any given company/asset
* many interesting other features waiting for being analysed, investigated and evaluated...


### Lambda vs. VarCoVaR for individual companies ...

* **Black dots**: Lambda time series
* **Red dots**: VarCoVaR time series
* **Green dots**: Squares of euclidean norm of the Beta vectors (from L1-Q-regression)


### 28 Companies (S&P 500) over the last 8 years
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot1.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot2.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot3.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot4.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot5.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot13.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot22.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot30.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot38.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot46.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot54.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot62.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot70.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot79.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot87.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot95.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot103.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot111.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot119.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot127.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot136.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot144.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot152.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot160.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot168.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot176.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot184.png)
![](https://github.com/QuantLet/FRM/blob/master/VarCoVaR/plot193.png)

### Look for other companies (total of 120) into the [PNG files above... ](https://github.com/QuantLet/FRM/tree/master/VarCoVaR)

### Stay tuned ...
