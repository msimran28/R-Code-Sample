library(mosaic)
library(tidyverse)
library(FNN)
sclass = read.csv('./sclass.csv')

# The variables involved
summary(sclass)

# 1st data set : 350 
sclass550 = subset(sclass, trim == '350')
dim(sclass550)

# Make a train-test split
N = nrow(sclass550)
N_train = floor(0.8*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE)

sclass550_train = sclass550[train_ind,]
sclass550_test = sclass550[-train_ind,]

y_train_550 = sclass550_train$price
X_train_550 = data.frame(mileage = sclass550_train$mileage)
y_test_550 = sclass550_test$price
X_test_550 = data.frame(mileage = sclass550_test$mileage)

# define a helper function for calculating RMSE
rmse = function(y, ypred) {
  sqrt(mean(data.matrix((y-ypred)^2)))
}

#create and set up the empty set 'knn_results' to save values of 'k'
knn_results = data.frame(k=c(), knn_tst_rmse=c())

# Run a loop of k values
k <- c(3:332)
for (v in k) {
  pred_knn = knn.reg(train = X_train_550, test = X_test_550, y = y_train_550, k=v) 
  a = pred_knn$pred #predicts 'y' values through the knnreg eq.
  knn_tst_rmse = rmse(y_test, a) #run the rmse on actual and predicted y values
  knn_results = rbind(knn_results, c(v, knn_tst_rmse)) #save the results of k in the predefined data frame
}
colnames(knn_results) = c("k", "Test RMSE")

optimum_k = which.min(knn_results$knn_tst_rmse)
optimum_k

# Plot: rmse vs knn
```{r echo = FALSE}
plot(k_grid, rmse_grid, log='x')
abline(h=rmse(Ytest, yhat_test2)) 
```