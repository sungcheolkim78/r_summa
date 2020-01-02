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
R> modellist <- c("svmRadial", "C5.0", "pls", "rda", "gbm", "nnet")
R> s1 <- summa(modellist)
R> s1 <- train(s1, Class~., training, update=FALSE)
R> s1 <- predict(s1, testing, alpha=1, Y=testingY)
```

## Concepts of SUMMA+

$$ y_k^{MLE} = \Theta\left\{\sum_{i=1}^M \lambda_{2i}^\alpha (r^*_i - r_{ik})\right\} $$

where 

$$ r^*_i = \frac{1}{\lambda_{2i}} \log \frac{1-\rho}{\rho} -\frac{\lambda_{1i}}{\lambda_{2i}} $$

where $\lambda_1, \lambda_2$ is fitting coefficient of Fermi-Dirac distribution to class probability. And $\alpha, \rho$ are tuning parameter with default value of 1 and prevalence, respectively. 

$$ P_i(1|r_{ik}) = \frac{1}{1+\exp{(\lambda_{1i} + \lambda_{2i} r_{ik})}} $$

## Concepts of SUMMA

$$ y_k^{MLE} = \Theta\left\{\sum_{i=1}^M v_i (\frac{N+1}{2} - r_{ik})\right\} $$

where $N$ is total number of samples and 

$$ v_i = \frac{12\Delta_i}{N^2 - 1} $$

where $\left R|0\right>$ is the expectation value of rank $R$ with a given class 1, 

$$ \Delta_i = \left< R|0\right> - \left< R|1\right> $$
