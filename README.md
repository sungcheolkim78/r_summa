# SUMMA+ 

Ensemble method - Strategy for Unsupervised Multiple Method Aggregation Plus (SUMMA+)

Original SUMMA : [link](http://jmlr.org/papers/v20/18-094.html) [pdf](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=4&cad=rja&uact=8&ved=2ahUKEwiFqOK39OXmAhUqh-AKHQIuDPEQFjADegQIBhAC&url=http%3A%2F%2Fwww.jmlr.org%2Fpapers%2Fvolume20%2F18-094%2F18-094.pdf&usg=AOvVaw2JrWKtNU8u-MMJSQ8iTGo8)

## Install

Prerequisite library: caret

```{r}
R> install.pakcages("caret", dependencies = c("Depends", "Suggests"))
```

## Usage

```{r}
R> s1 <- summa(modellist)
R> s1 <- train(s1, Class~., training, update=FALSE)
R> s1 <- predict(s1, testing, alpha=1, Y=testingY)
```

## Concepts of SUMMA+

<p align="center"><img src="/tex/a62aee35afd467c7629adccee2a1b2ac.svg?invert_in_darkmode&sanitize=true" align=middle width=223.02910409999998pt height=49.315569599999996pt/></p>

<p align="center"><img src="/tex/6593098996d28e3991f5ce94719a8741.svg?invert_in_darkmode&sanitize=true" align=middle width=174.05219204999997pt height=37.0084374pt/></p>

where <img src="/tex/347bed394338d5662bc68b387f5a8cce.svg?invert_in_darkmode&sanitize=true" align=middle width=40.41105584999999pt height=22.831056599999986pt/> is fitting coefficient of Fermi-Dirac distribution to class probability. And <img src="/tex/c745b9b57c145ec5577b82542b2df546.svg?invert_in_darkmode&sanitize=true" align=middle width=10.57650494999999pt height=14.15524440000002pt/> is tuning parameter with default value of 1. 

<p align="center"><img src="/tex/911b0c88fb0dc3259f094e5560691542.svg?invert_in_darkmode&sanitize=true" align=middle width=238.06757205pt height=37.099754999999995pt/></p>

## Concepts of SUMMA

<p align="center"><img src="/tex/60ddafa59eea0b8718ffdee44a4ff50c.svg?invert_in_darkmode&sanitize=true" align=middle width=246.6810357pt height=49.315569599999996pt/></p>

where 

<p align="center"><img src="/tex/0de763ecb52570b462b82e6410063230.svg?invert_in_darkmode&sanitize=true" align=middle width=88.01592029999999pt height=34.999293449999996pt/></p>

and 

<p align="center"><img src="/tex/1f661da8df29ef90300d557ea50e1597.svg?invert_in_darkmode&sanitize=true" align=middle width=137.53894605pt height=16.438356pt/></p>
