# r_summa.R
# SUMMA plus - ensemble method for binary classifier
#
# author: Sungcheol Kim @ IBM

library(caret)
library(purrr)
library(doParallel)

# summa S3 object

# initializer
new_summa <- function(x = list(), method = "plus", fitControl = NULL) {
  stopifnot(is.character(x))
  method <- match.arg(method, c("plus", "default"))
  if (is.null(fitControl)) {
    set.seed(1)
    seeds <- vector(mode = "list", length = 51)
    for(i in 1:50) seeds[[i]] <- sample.int(1000, 22)
    seeds[[51]] <- sample.int(1000, 1)
    
    fitControl <- trainControl(method = "repeatedcv", repeats = 5, 
                               classProbs = TRUE, summaryFunction = twoClassSummary, 
                               search = "random", seeds = seeds)
  }
  
  structure(list(modellist = x, 
                 method = "summa", 
                 modelInfo = list(label="summa"),
                 fitControl = fitControl,
                 fitlist = list(), 
                 testlist = list(),
                 testproblist = list(), 
                 roclist = list(),
                 lambdalist = list(), 
                 Y = list(),
                 rho = numeric()), 
            method = method, 
            class = "summa")
}

# validate
validate_summa <- function(x) {
  modellist_full <- names(caret::getModelInfo())
  check <- x$modellist %in% modellist_full
  if(!all(check)) {
    stop(paste0('unknown model name: ', x$modellist[!check], '\n'))
  }
  x
}

# helper
summa <- function(x = list(), method = "plus", fitControl = NULL) {
  validate_summa(new_summa(x, method, fitControl))
}

# S3 method
update.summa <- function(summa, newlist) {
  summa$modellist <- newlist
  validate_summa(summa)
}

addmodel.summa <- function(summa, newmodelname) {
  check <- newmodelname %in% summa$modellist
  summa$modellist <- c(summa$modellist, newmodelname[!check])
  validate_summa(summa)
}

train.summa <- function(summa, formula, data, update=FALSE, n_cores=-1) {
  if (n_cores == -1) n_cores <- detectCores() - 1

  caret_train <- function(method) {
    message(paste0('Training algorithm : ', method, ' with : ', n_cores, ' cores'))
    flush.console()
    
    if (method %in% names(summa$fitlist) && !update) {
      message(paste0('... using cached result: ', method))
      summa$fitlist[[method]]
    } else {
      set.seed(1024)
      caret::train(formula, data=data, method=method, trControl=summa$fitControl, 
                   metric="ROC", tuneLength=4, preProc = c("center", "scale"))
    }
  }
  
  cl <- makePSOCKcluster(n_cores)
  registerDoParallel(cl)
  summa$fitlist <- map(summa$modellist, caret_train)
  stopCluster(cl)
  
  names(summa$fitlist) <- summa$modellist
  summa
}

predict.summa <- function(summa, newdata, alpha=1.0, newmodellist = NULL, Y=NULL) {
  summa$testlist <- map(summa$fitlist, predict, newdata=newdata)
  summa$testproblist <- map(summa$fitlist, predict, newdata=newdata, type='prob')
  
  if(!is.null(Y)) {
    class1name = levels(Y)[[1]]
    class2name = levels(Y)[[2]]
    rho <- sum(Y == class1name)/length(Y)

    summa$Y <- Y
    summa$roclist <- map(summa$testproblist, rocrank, reference = Y)
    summa$lambdalist <- map(summa$roclist, lambda_fromROC, N=length(Y), rho=rho)
    
    res <- cal_score(summa, alpha = alpha, newmodellist = newmodellist)
    summa$testlist$summa <- as.factor(ifelse(res > 0, class2name, class1name))
    summa$testproblist$summa <- data.frame(1/(1 + exp(res)), 1/(1+exp(-res)))
    names(summa$testproblist$summa) <- c(class1name, class2name)
    
    summa$roclist <- c(summa$roclist, summa = rocrank(summa$testproblist$summa, reference = Y))
    summa$lambdalist$summa <- lambda_fromROC(summa$roclist$summa, N=length(Y), rho=rho)
    summa$confmatrix <- map(summa$testlist, confusionMatrix, reference = Y)

    print.summa(summa, newmodellist = newmodellist)
    #print(summa$confmatrix$summa)
    #print(summa$testproblist$summa)
  }
  summa
}

plot.summa <- function(summa) {
  temp <- resamples(summa$fitlist)
  dotplot(temp)
}

print.summa <- function(summa, newmodellist = NULL) {
  if (is.null(newmodellist)) 
    newmodellist <- c(summa$modellist, 'summa')
  else 
    newmodellist <- c(newmodellist, 'summa')
  
  ROC <- unlist(summa$roclist[newmodellist])
  l1 <- map_dbl(summa$lambdalist[newmodellist], 1)
  l2 <- map_dbl(summa$lambdalist[newmodellist], 2)
  rs <- map_dbl(summa$lambdalist[newmodellist], 3)
  print(rbind(ROC, l1, l2, rs))
}

# Utility functions

cal_score <- function(summa, newmodellist = NULL, alpha = 1.0, view = FALSE) {
  if (is.null(newmodellist)) newmodellist <- summa$modellist
  
  res <- matrix(0, nrow=length(summa$testlist[[1]]), ncol=length(newmodellist))
  colnames(res) <- newmodellist
  
  for(m in newmodellist) {
    res[ , m] <- rank(summa$testproblist[[m]][[1]])
    res[ , m] <- summa$lambdalist[[m]][[2]]^alpha *(summa$lambdalist[[m]][[3]] - res[, m])
  }
  
  if(view) {
    temp <- as.data.frame(res)
    temp$summa <- rowMeans(res)
    names(temp)[-ncol(temp)] <- c(summa$modellist)
    plot(temp)
    print(cor(temp, method = "spearman"))
  }
  
  rowMeans(res)
}

# calculate ROC from rank and reference
rocrank <- function(problist, reference) {
  classNames1 <- unique(reference)[[1]]
  classNames2 <- unique(reference)[[2]]
  
  temp <- data.frame(prob=problist[[1]], truth=reference)
  temp <- temp[order(temp$prob, decreasing = TRUE), ]
  temp$rank <- seq_along(reference)
  
  (mean(temp$rank[temp$truth == classNames1]) - mean(temp$rank[temp$truth == classNames2]))/length(reference) + 0.5
}

# calculate lambda1,2 from ROC, rho
lambda_fromROC <- function(ROC, N=N, rho=rho) {
  costFunc <- function(l, rho, auroc, N) {
    r <- 1:N
    sum1 <- sum(1/(1+exp(l[2]*r - l[1])))/N
    sum2 <- sum(r/(1+exp(l[2]*r - l[1])))/(N*N*rho)
    
    (rho - sum1)^2 + (1 + .5/N - rho/2 - auroc*(1-rho) - sum2)^2
  }
  temp <- optim(c(N*rho*0.1, 0.1), costFunc, rho=rho, auroc=ROC, N=N)
  l1 <- -temp$par[1]
  l2 <- temp$par[2]
  rs <- 1/l2 * log((1 - rho)/rho) - l1/l2
  return(c(l1 = l1, l2 = l2, rs = rs))
}