# SUMMA+ 

Ensemble method - Strategy for Unsupervised Multiple Method Aggregation Plus (SUMMA+)

Original SUMMA : [link](http://jmlr.org/papers/v20/18-094.html) [pdf](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=4&cad=rja&uact=8&ved=2ahUKEwiFqOK39OXmAhUqh-AKHQIuDPEQFjADegQIBhAC&url=http%3A%2F%2Fwww.jmlr.org%2Fpapers%2Fvolume20%2F18-094%2F18-094.pdf&usg=AOvVaw2JrWKtNU8u-MMJSQ8iTGo8)

## Install

Prerequisite library: caret

```{r}
#R> install.packages("devtools")
#R> install.pakcages("caret", dependencies = c("Depends", "Suggests"))
#R> devtools::install_github("sungcheolkim78/r_summa",build_vignettes = T)  [TODO]
R> source("r_summa.R")
```

## Usage

```{r}
R> modellist <- c("svmRadial", "C5.0", "pls", "rda", "gbm", "nnet")
R> s1 <- summa(modellist)
R> s1 <- train(s1, Class~., training, update=FALSE)
R> s1 <- predict(s1, testing, alpha=1, Y=testingY)
```

## SUMMA+ approach

<p align="center"><img src="/tex/a62aee35afd467c7629adccee2a1b2ac.svg?invert_in_darkmode&sanitize=true" align=middle width=223.02910409999998pt height=49.315569599999996pt/></p>

where 

<p align="center"><img src="/tex/6593098996d28e3991f5ce94719a8741.svg?invert_in_darkmode&sanitize=true" align=middle width=174.05219204999997pt height=37.0084374pt/></p>

where <img src="/tex/347bed394338d5662bc68b387f5a8cce.svg?invert_in_darkmode&sanitize=true" align=middle width=40.41105584999999pt height=22.831056599999986pt/> is fitting coefficient of Fermi-Dirac distribution to class probability. And <img src="/tex/e06a9e24933688c8bb05dec657e6453d.svg?invert_in_darkmode&sanitize=true" align=middle width=26.381265899999992pt height=14.15524440000002pt/> are tuning parameter with default value of 1 and prevalence, respectively. 

<p align="center"><img src="/tex/911b0c88fb0dc3259f094e5560691542.svg?invert_in_darkmode&sanitize=true" align=middle width=238.06757205pt height=37.099754999999995pt/></p>

## SUMMA approach

<p align="center"><img src="/tex/60ddafa59eea0b8718ffdee44a4ff50c.svg?invert_in_darkmode&sanitize=true" align=middle width=246.6810357pt height=49.315569599999996pt/></p>

where <img src="/tex/f9c4988898e7f532b9f826a75014ed3c.svg?invert_in_darkmode&sanitize=true" align=middle width=14.99998994999999pt height=22.465723500000017pt/> is total number of samples and 

<p align="center"><img src="/tex/0de763ecb52570b462b82e6410063230.svg?invert_in_darkmode&sanitize=true" align=middle width=88.01592029999999pt height=34.999293449999996pt/></p>

where <img src="/tex/a9324b543468a13a525438d3e6fc402f.svg?invert_in_darkmode&sanitize=true" align=middle width=31.786619699999996pt height=24.65753399999998pt/> is the expectation value of rank <img src="/tex/1e438235ef9ec72fc51ac5025516017c.svg?invert_in_darkmode&sanitize=true" align=middle width=12.60847334999999pt height=22.465723500000017pt/> with a given class 1, 

<p align="center"><img src="/tex/1f661da8df29ef90300d557ea50e1597.svg?invert_in_darkmode&sanitize=true" align=middle width=137.53894605pt height=16.438356pt/></p>
