# SUMMA+ 

Ensemble method - Strategy for Unsupervised Multiple Method Aggregation Plus (SUMMA+)

Original SUMMA : [link](http://jmlr.org/papers/v20/18-094.html) [pdf](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=4&cad=rja&uact=8&ved=2ahUKEwiFqOK39OXmAhUqh-AKHQIuDPEQFjADegQIBhAC&url=http%3A%2F%2Fwww.jmlr.org%2Fpapers%2Fvolume20%2F18-094%2F18-094.pdf&usg=AOvVaw2JrWKtNU8u-MMJSQ8iTGo8)

## Install

## Usage

## Concepts

$$ y_k = \Theta\left\{\sum_{i=1}^M \lambda_2 (r^* - r_{ik})\right\} $$

$$ r^*_i = \frac{1}{\lambda_{2i}} \log \frac{1-\rho}{\rho} -\frac{\lambda_{1i}}{\lambda_{2i}} $$

where $\lambda_1, \lambda_2$ is fitting coefficient of Fermi-Dirac distribution to class probability.

$$ P_i(1|r_{ik}) = \frac{1}{1+\exp{(\lambda_{1i} + \lambda_{2i} r_{ik})}} $$

